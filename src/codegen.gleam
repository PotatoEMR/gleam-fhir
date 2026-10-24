import argv
import codegen_bound_coding
import codegen_client
import codegen_decode
import codegen_helpers
import codegen_profile
import codegen_profile_json
import codegen_to_json
import download_profile_package
import fhir/template_primitive_types
import filepath
import gleam/bool
import gleam/dict
import gleam/http/request
import gleam/httpc
import gleam/int
import gleam/io
import gleam/json
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/set.{type Set}
import gleam/string
import shellout

//dev dependencies but not required for users
import simplifile

const check_versions = ["r4", "r4b", "r5"]

const zip_file_names = [
  "profiles-resources.json",
  "profiles-types.json",
]

const fhir_url = "https://www.hl7.org/fhir"

const gen_into_dir = "src/fhir"

const download_dir = "downloads"

fn simplifier_core_package_version(fhir_version: String) {
  case fhir_version {
    "r4" -> "4.0.1"
    "r4b" -> "4.3.0"
    "r5" -> "5.0.0"
    _ -> panic as "unsupported FHIR version"
  }
}

pub fn main() {
  io.println("🔥🔥🔥 bultaoreune")

  // caps used to matter for profile urls, not sure if simplifier cares
  let args_cased = argv.load().arguments
  let args_lower = args_cased |> list.map(fn(s) { string.lowercase(s) })

  case
    list.contains(args_lower, "r4")
    || list.contains(args_lower, "r4b")
    || list.contains(args_lower, "r5")
  {
    False ->
      panic as "run with args r4 r4b r5 to generate eg gleam run -m codegen r4 r5"
    True -> Nil
  }

  let download_files = list.contains(args_lower, "download")
  let preserve_slice_order = list.contains(args_lower, "order")
  let client_resources = case list.contains(args_lower, "noio") {
    True -> []
    False -> codegen_helpers.client_resource_fields
  }
  let capability_statement_file = case
    list.find(args_cased, fn(arg) {
      string.starts_with(arg, "CapabilityStatement=")
    })
  {
    Ok(arg) -> {
      let assert [_, filename] = string.split(arg, "=")
      Some(filename)
    }
    Error(_) -> None
  }
  let requested_resources = case
    list.find(args_lower, fn(arg) {
      string.starts_with(arg, "structuredefinitions=")
    })
  {
    Ok(arg) -> {
      let assert [_, resources] = string.split(arg, "=")
      Some(
        resources
        |> string.split(",")
        |> list.map(string.lowercase),
      )
    }
    Error(_) -> None
  }
  let gen_specific_resources =
    option.map(requested_resources, fn(resources) {
      list.fold(client_resources, resources, fn(resources, resource) {
        list.prepend(resources, string.lowercase(resource.0))
      })
    })
  let minimal_client_resources = case requested_resources {
    None -> set.new()
    Some(resources) ->
      client_resources
      |> list.filter_map(fn(resource) {
        case list.contains(resources, string.lowercase(resource.0)) {
          True -> Error(Nil)
          False -> Ok(resource.0)
        }
      })
      |> set.from_list
  }

  let _ = case download_files {
    True -> {
      case simplifile.delete(download_dir) {
        Ok(_) -> Nil
        Error(simplifile.Enoent) -> Nil
        Error(_) -> panic as "could not remove dir to download fhir into"
      }
      let assert Ok(_) = simplifile.create_directory_all(download_dir)
    }
    False -> {
      io.println("Run with \"download\" arg to download files from fhir")
      Ok(Nil)
    }
  }
  // on you to rm -rf generated_fhir && mkdir generated_fhir
  // so we can call codegen multiple times in one script
  // case simplifile.delete(gen_into_dir) {
  //   Ok(_) -> Nil
  //   Error(simplifile.Enoent) -> Nil
  //   Error(_) -> panic as "could not remove fhir dir"
  // }
  // let assert Ok(_) = simplifile.create_directory_all(gen_into_dir)

  case simplifile.is_directory("downloads_custom") {
    Ok(True) -> {
      let assert Ok(_) =
        shellout.command(
          "cp",
          ["-R", "downloads_custom/.", download_dir],
          ".",
          [],
        )
      Nil
    }
    _ -> Nil
  }

  let profiles_dir = download_dir |> filepath.join("profile_package")
  let custom_profile =
    list.find(args_cased, fn(arg) { string.starts_with(arg, "custom=") })
  let profiles_dir = case custom_profile {
    Error(_) -> None
    Ok(custom_profile) -> {
      let assert [_, simplifier_profile] = string.split(custom_profile, "=")
      let assert [pkg_name, pkg_version] = string.split(simplifier_profile, "/")
        as "need name and version separated by slash, eg hl7.fhir.us.core/9.0.0"
      case download_files {
        False -> Nil
        True -> {
          let packages =
            download_profile_package.download_package_with_dependencies(
              pkg_name,
              pkg_version,
              profiles_dir,
            )
          let count = packages |> set.size |> int.to_string
          io.println("Resolved " <> count <> " packages into " <> profiles_dir)
        }
      }
      profiles_dir
      |> filepath.join(pkg_name)
      |> filepath.join(pkg_version)
      |> filepath.join("package")
      |> Some
    }
  }

  list.map(check_versions, fn(fhir_version) {
    let custom_profile_name = case custom_profile {
      Ok(custom_profile) -> {
        let assert [_, simplifier_profile] = string.split(custom_profile, "=")
        let gen_folder_name =
          simplifier_profile
          |> string.replace("/", "_")
          |> string.replace(".", "_")
          |> string.replace("-", "_")
          |> string.lowercase
        Some(gen_folder_name)
      }
      Error(_) -> None
    }

    let _ = case list.contains(args_lower, fhir_version) {
      True ->
        gen_fhir(
          fhir_version,
          download_files,
          custom_profile_name,
          profiles_dir,
          capability_statement_file,
          preserve_slice_order,
          gen_specific_resources,
          minimal_client_resources,
          client_resources,
        )
      False -> Nil
    }
  })
}

fn gen_fhir(
  fhir_version: String,
  download_files: Bool,
  custom_profile_name: Option(String),
  profiles_dir: Option(String),
  capability_statement_file: Option(String),
  preserve_slice_order: Bool,
  gen_specific_resources: Option(List(String)),
  minimal_client_resources: Set(String),
  client_resources: List(#(String, List(String))),
) -> Nil {
  let extract_dir_ver = download_dir |> filepath.join(fhir_version)

  let _ = case download_files {
    True -> {
      let _ =
        download_profile_package.download_package_with_dependencies(
          "hl7.fhir." <> fhir_version <> ".core",
          simplifier_core_package_version(fhir_version),
          download_dir |> filepath.join("profile_package"),
        )
      let assert Ok(_) = simplifile.create_directory_all(extract_dir_ver)
      use filename <- list.map(zip_file_names)
      io.println(
        "download "
        <> fhir_url
        <> "/"
        <> string.uppercase(fhir_version)
        <> "/"
        <> filename,
      )
      let assert Ok(req) =
        request.to(
          fhir_url <> "/" <> string.uppercase(fhir_version) <> "/" <> filename,
        )
      let assert Ok(resp) = httpc.send(req)
      let write_path = filepath.join(extract_dir_ver, filename)
      let assert Ok(Nil) = simplifile.write(to: write_path, contents: resp.body)
      Nil
    }
    False -> [Nil]
  }

  let pkg_prefix = case custom_profile_name {
    Some(name) -> name
    None -> fhir_version
  }
  let gen_dir = filepath.join(gen_into_dir, pkg_prefix)
  let assert Ok(_) = simplifile.create_directory_all(gen_dir)
  let gen_gleamfile = filepath.join(gen_dir, "resources.gleam")
  let gen_vsfile = filepath.join(gen_dir, "valuesets.gleam")
  let complex_types_file = filepath.join(extract_dir_ver, "profiles-types.json")
  let valuesets_package_dir = case profiles_dir {
    Some(directory) -> directory
    None ->
      download_dir
      |> filepath.join("profile_package")
      |> filepath.join("hl7.fhir." <> fhir_version <> ".core")
      |> filepath.join(simplifier_core_package_version(fhir_version))
      |> filepath.join("package")
  }
  let #(
    resources_gen,
    valueset_acc,
    resource_type_names,
    core_resource_entries,
    _,
    resource_constructors,
    available_valuesets,
  ) =
    file_to_types(
      spec_file: filepath.join(extract_dir_ver, "profiles-resources.json"),
      fv: fhir_version,
      current_bucket: codegen_helpers.Resources,
      valueset_acc: dict.new(),
      gen_specific_resources:,
      gen_specific_complex_types: None,
      minimal_client_resources:,
      valuesets_package_dir:,
      available_valuesets: dict.new(),
    )
  let profile_type_names = case profiles_dir {
    Some(profiles_dir) ->
      codegen_profile.required_complex_type_names(
        profiles_dir,
        gen_specific_resources,
      )
    None -> set.new()
  }
  let gen_specific_complex_types =
    resource_type_names
    |> set.union(profile_type_names)
    |> required_complex_types(complex_types_file, _)
    |> Some
  let #(
    complex_types_gen,
    valueset_acc,
    _,
    _,
    core_type_urls,
    core_constructors,
    available_valuesets,
  ) =
    file_to_types(
      spec_file: complex_types_file,
      fv: fhir_version,
      current_bucket: codegen_helpers.ComplexTypes,
      valueset_acc:,
      gen_specific_resources:,
      gen_specific_complex_types:,
      minimal_client_resources:,
      valuesets_package_dir:,
      available_valuesets:,
    )
  let #(
    profile_complex_types,
    profile_resources,
    valueset_acc,
    preloaded_valuesets,
    profile_resource_entries,
    constructors,
    profile_required,
  ) = case custom_profile_name {
    None -> #(
      "",
      "",
      valueset_acc,
      available_valuesets,
      [],
      dict.merge(resource_constructors, core_constructors),
      #(codegen_helpers.required_code(), codegen_helpers.required_code()),
    )
    Some(_) -> {
      let assert Some(profiles_dir) = profiles_dir
      let #(
        complex_types,
        resources,
        valuesets,
        loaded_valuesets,
        resource_entries,
        constructors,
        required,
      ) =
        codegen_profile.profile_files_to_types(
          profiles_dir,
          preserve_slice_order,
          valueset_acc,
          gen_specific_resources,
          core_type_urls,
          dict.merge(resource_constructors, core_constructors),
          available_valuesets,
          fhir_version,
        )
      #(
        complex_types,
        resources,
        valuesets,
        loaded_valuesets,
        resource_entries,
        constructors,
        required,
      )
    }
  }
  let complex_types_gen = complex_types_gen <> profile_complex_types
  let resource_entries =
    list.append(core_resource_entries, profile_resource_entries)
  let _ =
    list.fold(resource_entries, dict.new(), fn(names, entry) {
      let name = entry.1
      case dict.get(names, name) {
        Ok(url) ->
          panic as {
            "Gleam name collision for resources."
            <> name
            <> ": "
            <> url
            <> " and "
            <> entry.2
          }
        Error(_) -> dict.insert(names, name, entry.2)
      }
    })
  let resource_names =
    resource_entries
    |> list.map(fn(resource_entry) {
      let gleam_type = resource_entry.1
      "Resource" <> gleam_type <> "(" <> gleam_type <> ")\n"
    })
    |> string.concat
  let assert [fallback_resource, ..] = resource_entries
    as "no resource StructureDefinitions selected"
  let resource_failure =
    codegen_helpers.to_snake_case(fallback_resource.1)
    <> "_decoder() |> decode.map(Resource"
    <> fallback_resource.1
    <> ") |> decode.then(fn(value) { decode.failure(value, expected: \"\") })"
  let resource_encoders =
    resource_entries
    |> list.map(fn(resource_entry) {
      let gleam_type = resource_entry.1
      "Resource"
      <> gleam_type
      <> "(resource) -> "
      <> codegen_helpers.to_snake_case(gleam_type)
      <> "_to_json(resource)\n"
    })
    |> string.concat
  let resource_types =
    resource_entries
    |> list.fold([], fn(resource_types, resource_entry) {
      case list.contains(resource_types, resource_entry.0) {
        True -> resource_types
        False -> [resource_entry.0, ..resource_types]
      }
    })
    |> list.reverse
  let resource_decoders =
    resource_types
    |> list.map(fn(resource_type) {
      let matching_entries =
        list.filter(resource_entries, fn(resource_entry) {
          resource_entry.0 == resource_type
        })
      case matching_entries {
        [resource_entry] -> {
          let gleam_type = resource_entry.1
          "\""
          <> resource_type
          <> "\" -> "
          <> codegen_helpers.to_snake_case(gleam_type)
          <> "_decoder() |> decode.map(Resource"
          <> gleam_type
          <> ")\n"
        }
        [first_entry, ..rest_entries] -> {
          let first_gleam_type = first_entry.1
          let first_profile_decoder =
            "#(\""
            <> first_entry.2
            <> "\", "
            <> codegen_helpers.to_snake_case(first_gleam_type)
            <> "_decoder() |> decode.map(Resource"
            <> first_gleam_type
            <> "))"
          let rest_profile_decoders =
            rest_entries
            |> list.map(fn(resource_entry) {
              let gleam_type = resource_entry.1
              "#(\""
              <> resource_entry.2
              <> "\", "
              <> codegen_helpers.to_snake_case(gleam_type)
              <> "_decoder() |> decode.map(Resource"
              <> gleam_type
              <> "))"
            })
            |> string.join(",\n")
          "\""
          <> resource_type
          <> "\" -> match_profile(ct.List1("
          <> first_profile_decoder
          <> ", ["
          <> rest_profile_decoders
          <> "]))\n"
        }
        [] -> panic as "resource type has no generated decoder"
      }
    })
    |> string.concat
  let resource_type_variants =
    resource_types
    |> list.map(fn(resource_type) {
      let gleam_type =
        resource_type
        |> string.replace("-", "_")
        |> codegen_helpers.to_camel_case
      let gleam_type = case gleam_type {
        "List" -> "Listfhir"
        _ -> gleam_type
      }
      "Rt" <> gleam_type <> "\n"
    })
    |> string.concat
  let resource_type_to_string_arms =
    resource_types
    |> list.map(fn(resource_type) {
      let gleam_type =
        resource_type
        |> string.replace("-", "_")
        |> codegen_helpers.to_camel_case
      let gleam_type = case gleam_type {
        "List" -> "Listfhir"
        _ -> gleam_type
      }
      "Rt" <> gleam_type <> " -> \"" <> resource_type <> "\"\n"
    })
    |> string.concat
  let uses_profile_match =
    list.any(resource_types, fn(resource_type) {
      list.length(
        list.filter(resource_entries, fn(resource_entry) {
          resource_entry.0 == resource_type
        }),
      )
      > 1
    })
  let match_profile_source = case uses_profile_match {
    False -> ""
    True ->
      "fn match_profile(profile_decoders: ct.List1(#(String, Decoder(a)))) -> Decoder(a) {
        use found_profiles <- decode.optional_field(
          \"meta\",
          [],
          decode.optional_field(
            \"profile\",
            [],
            decode.list(decode.string),
            decode.success,
          ),
        )
        case list.find(
          [profile_decoders.first, ..profile_decoders.rest],
          fn(profile_decoder) {
            let #(profile_name, _decoder) = profile_decoder
            list.any(found_profiles, fn(found_profile) {
              found_profile == profile_name
              || string.starts_with(found_profile, profile_name <> \"|\")
            })
          },
        ) {
          Ok(#(_profile_name, decoder)) -> decoder
          Error(Nil) -> {
            let #(_profile_name, first_decoder) = profile_decoders.first
            decode.one_of(
              first_decoder,
              list.map(profile_decoders.rest, fn(profile_decoder) {
                let #(_profile_name, decoder) = profile_decoder
                decoder
              }),
            )
          }
        }
      }\n"
  }
  let resource_enum = "pub type ResourceType {" <> resource_type_variants <> "}
      pub fn resource_type_to_string(resource_type: ResourceType) -> String {
        case resource_type {" <> resource_type_to_string_arms <> "}
      }

      pub type Resource {" <> resource_names <> "}
      pub fn resource_to_json(resource: Resource) {
        case resource {" <> resource_encoders <> "}
      }

      " <> match_profile_source <> "pub fn resource_decoder() -> Decoder(Resource) {
        use tag <- decode.field(\"resourceType\", decode.string)
        case tag {" <> resource_decoders <> "_ ->
            " <> resource_failure <> "
            |> decode.map_errors(fn(_errors) {
              [decode.DecodeError(
                expected: \"one of Account, ActivityDefinition, AdverseEvent, AllergyIntolerance... or any resource name\",
                found: tag,
                path: [\"resourceType\"],
              )]
            })
        }
        |> decode.map_errors(fn(errors) {
          list.map(errors, fn(error) {
            decode.DecodeError(..error, path: [\"(\" <> tag <> \")\", ..error.path])
          })
        })
      }
      "
  let resources_gen = resources_gen <> profile_resources <> resource_enum
  let #(all_vs, failure_variant_replacements) =
    valueset_to_types(fhir_version, valueset_acc, preloaded_valuesets)
  let replace_failure_variants = fn(source) {
    list.fold(failure_variant_replacements, source, fn(source, replacement) {
      string.replace(source, replacement.0, replacement.1)
    })
  }
  let complex_types_gen = replace_failure_variants(complex_types_gen)
  let resources_gen = replace_failure_variants(resources_gen)
  let helper_dependencies =
    [
      #("SliceElt", []),
      #("slice_elt_new", ["SliceElt"]),
      #("slice_elts_to_values", [
        "SliceElt",
        "import:int",
        "import:list",
        "import:order",
      ]),
      #("List1", []),
      #("List2", []),
      #("List3", []),
      #("ExplicitFalse", []),
      #("ExplicitTrue", []),
      #("list1_to_json", ["List1"]),
      #("list1_decoder", ["List1"]),
      #("list2_to_json", ["List2"]),
      #("list2_decoder", ["List2"]),
      #("list3_to_json", ["List3"]),
      #("list3_decoder", ["List3"]),
      #("none_if_omitted", []),
      #("decode_optional_string", []),
      #("decode_optional_bool", []),
      #("decode_number", ["import:int"]),
      #("Primitive", []),
      #("PrimitiveExtPart", []),
      #("primitive_slice_to_json", []),
      #("primitive_slice_list_to_json", ["import:list"]),
      #("primitive_ext_part_decoder", ["PrimitiveExtPart"]),
      #("primitive_decoder", [
        "Primitive",
        "PrimitiveExtPart",
        "primitive_ext_part_decoder",
      ]),
      #("primitives_decoder", [
        "Primitive",
        "PrimitiveExtPart",
        "map2_fillnone",
        "primitive_ext_part_decoder",
      ]),
      #("primitive_slice_decoder", ["Primitive", "primitive_decoder"]),
      #("primitive_choice_slice_decoder", [
        "Primitive",
        "primitive_slice_decoder",
      ]),
      #("primitive_slice_list_decoder", [
        "Primitive",
        "primitive_slice_list_from_primitives",
        "primitives_decoder",
      ]),
      #("primitive_slice_list_from_primitives", [
        "Primitive",
        "import:int",
        "import:list",
      ]),
      #("map2_fillnone", ["map2_fillnone_loop"]),
      #("map2_fillnone_loop", ["import:list"]),
      #("one_from_array_decoder", []),
      #("optional_one_from_array_decoder", []),
      #("BoundCoding", ["Extension"]),
      #("bound_coding_decoder", ["BoundCoding"]),
      #("BoundCodeableconcept", [
        "BoundCoding",
        "Coding",
        "bound_coding_decoder",
        "import:list",
      ]),
      #("BoundCodeablereference", ["BoundCodeableconcept", "Reference"]),
      #("BoundQuantity", ["Extension", "decode_number"]),
      #("insert_at", ["import:list"]),
    ]
    |> dict.from_list
  let helper_dependencies = case preserve_slice_order {
    True ->
      dict.insert(helper_dependencies, "BoundCodeableconcept", [
        "BoundCoding",
        "Coding",
        "insert_at",
        "bound_coding_decoder",
        "import:list",
      ])
    False -> helper_dependencies
  }
  let core_required = fn(bucket) {
    let core_constructors = dict.merge(resource_constructors, core_constructors)
    let required =
      codegen_profile_json.constructor_requirements(core_constructors, bucket)
    core_constructors
    |> dict.values
    |> list.fold(required, fn(required, constructor) {
      case constructor {
        codegen_profile_json.RecordConstructor(current, _, fields)
          if current == bucket
        ->
          list.fold(fields, required, fn(required, field) {
            let required = case field.0.min, field.0.type_ {
              0, [_, _, ..] ->
                codegen_helpers.require_function(required, "none_if_omitted")
              _, _ -> required
            }
            case field.0.max, field.0.min {
              max, minimum if max != "1" && minimum > 0 && minimum <= 3 ->
                required
                |> codegen_helpers.require_function(
                  "list" <> int.to_string(minimum) <> "_decoder",
                )
                |> codegen_helpers.require_function(
                  "list" <> int.to_string(minimum) <> "_to_json",
                )
              _, _ -> required
            }
          })
        _ -> required
      }
    })
  }
  let complex_required =
    core_required(codegen_helpers.ComplexTypes)
    |> codegen_helpers.merge_required_code(
      codegen_profile_json.constructor_requirements(
        constructors,
        codegen_helpers.ComplexTypes,
      ),
    )
    |> codegen_helpers.merge_required_code(profile_required.0)
  let resource_required =
    core_required(codegen_helpers.Resources)
    |> codegen_helpers.merge_required_code(
      codegen_profile_json.constructor_requirements(
        constructors,
        codegen_helpers.Resources,
      ),
    )
    |> codegen_helpers.merge_required_code(profile_required.1)
  let resource_required =
    codegen_helpers.RequiredCode(
      ..resource_required,
      modules: case core_resource_entries {
          [] -> resource_required.modules
          _ -> set.insert(resource_required.modules, "bool")
        }
        |> set.insert("list"),
    )
  let resource_required = case uses_profile_match {
    True ->
      codegen_helpers.RequiredCode(
        ..resource_required,
        types: set.insert(resource_required.types, "ct.List1"),
        modules: set.insert(resource_required.modules, "string"),
      )
    False -> resource_required
  }
  let required =
    codegen_helpers.merge_required_code(complex_required, resource_required)
  let initial_names =
    set.union(required.types, required.functions)
    |> set.to_list
    |> list.map(fn(name) { string.replace(name, "ct.", "") })
    |> set.from_list
  let required_names =
    codegen_helpers.required_names(
      helper_dependencies,
      initial_names,
      set.new(),
    )
  let helper_definitions = [
    #("ExplicitFalse", fn() { "pub type ExplicitFalse { ExplicitFalse }\n\n" }),
    #("ExplicitTrue", fn() { "pub type ExplicitTrue { ExplicitTrue }\n\n" }),
    #("decode_optional_string", fn() {
      "pub fn decode_optional_string(
  name: String,
  next: fn(Option(String)) -> Decoder(a),
) -> Decoder(a) {
  decode.optional_field(name, None, decode.optional(decode.string), next)
}\n\n"
    }),
    #("decode_optional_bool", fn() {
      "pub fn decode_optional_bool(
  name: String,
  next: fn(Option(Bool)) -> Decoder(a),
) -> Decoder(a) {
  decode.optional_field(name, None, decode.optional(decode.bool), next)
}\n\n"
    }),
    #("SliceElt", fn() {
      "      pub type SliceElt(a) {
        SliceElt(value: a, internal_gleam_fhir_index: Option(Int))
      }

"
    }),
    #("slice_elt_new", fn() {
      "      pub fn slice_elt_new(value: a) -> SliceElt(a) {
        SliceElt(value:, internal_gleam_fhir_index: None)
      }

"
    }),
    #("slice_elts_to_values", fn() {
      "      pub fn slice_elts_to_values(slice_elts: List(SliceElt(a))) -> List(a) {
        slice_elts
        |> list.sort(fn(first, second) {
          case
            first.internal_gleam_fhir_index,
            second.internal_gleam_fhir_index
          {
            Some(first), Some(second) -> int.compare(first, second)
            Some(_), None -> order.Lt
            None, Some(_) -> order.Gt
            None, None -> order.Eq
          }
        })
        |> list.map(fn(slice_elt) { slice_elt.value })
      }
      "
    }),
    #("List1", fn() {
      "      pub type List1(a){ List1(first: a, rest: List(a)) }
      "
    }),
    #("List2", fn() {
      "      pub type List2(a){ List2(first: a, second: a, rest: List(a)) }
      "
    }),
    #("List3", fn() {
      "      pub type List3(a){ List3(first: a, second: a, third: a, rest: List(a)) }
      "
    }),
    #("list1_to_json", fn() {
      "      pub fn list1_to_json(l: List1(a), tj: fn(a) -> Json) {
        json.array([l.first, ..l.rest], tj)
      }

"
    }),
    #("list1_decoder", fn() {
      "      pub fn list1_decoder(
        name: String,
        inner: decode.Decoder(a),
        next: fn(List1(a)) -> decode.Decoder(b),
      ) -> decode.Decoder(b) {
        use lst <- decode.field(name, decode.list(inner))
        case lst {
          [first, ..rest] -> next(List1(first:, rest:))
          _ -> {
            use fail_decode_to_satisfy_gleam_type <- decode.field(name, inner)
            next(List1(first: fail_decode_to_satisfy_gleam_type, rest: []))
          }
        }
      }
      "
    }),
    #("list2_to_json", fn() {
      "      pub fn list2_to_json(l: List2(a), tj: fn(a) -> Json) {
        json.array([l.first, l.second, ..l.rest], tj)
      }

"
    }),
    #("list2_decoder", fn() {
      "      pub fn list2_decoder(
        name: String,
        inner: decode.Decoder(a),
        next: fn(List2(a)) -> decode.Decoder(b),
      ) -> decode.Decoder(b) {
        use lst <- decode.field(name, decode.list(inner))
        case lst {
          [first, second, ..rest] -> next(List2(first:, second:, rest:))
          _ -> {
            use fail_decode_to_satisfy_gleam_type <- decode.field(name, inner)
            next(List2(first: fail_decode_to_satisfy_gleam_type, second: fail_decode_to_satisfy_gleam_type, rest: []))
          }
        }
      }
      "
    }),
    #("list3_to_json", fn() {
      "      pub fn list3_to_json(l: List3(a), tj: fn(a) -> Json) {
        json.array([l.first, l.second, l.third, ..l.rest], tj)
      }

"
    }),
    #("list3_decoder", fn() {
      "      pub fn list3_decoder(
        name: String,
        inner: decode.Decoder(a),
        next: fn(List3(a)) -> decode.Decoder(b),
      ) -> decode.Decoder(b) {
        use lst <- decode.field(name, decode.list(inner))
        case lst {
          [first, second, third, ..rest] -> next(List3(first:, second:, third:, rest:))
          _ -> {
            use fail_decode_to_satisfy_gleam_type <- decode.field(name, inner)
            next(List3(first: fail_decode_to_satisfy_gleam_type, second: fail_decode_to_satisfy_gleam_type, third: fail_decode_to_satisfy_gleam_type, rest: []))
          }
        }
      }
      "
    }),
    #("none_if_omitted", fn() {
      "      pub fn none_if_omitted(d: decode.Decoder(a)) -> decode.Decoder(Option(a)) {
        decode.one_of(d |> decode.map(Some), [decode.success(None)])
      }

      //std lib decode.float will NOT decode numbers without decimal point eg 4, only 4.0
"
    }),
    #("decode_number", fn() {
      "      pub fn decode_number() {
        decode.one_of(decode.float, [decode.map(decode.int, int.to_float)])
      }

      // Primitive and PrimitiveExtPart are used for decoding JSON
      // but generic primitive extensions are NOT supported;
      // the only supported primitive extensions are when profiles define them
      // in which case they are generated as actual types
      // for example
      // pub type UsCoreQuestionnaireresponseQuestionnaire {
      //   UsCoreQuestionnaireresponseQuestionnaire(
      //     id: Option(String),
      //     extension: List(ct.Extension),
      //     questionnaire_display: Option(String),
      //     url: Option(String),
      //     value: Option(String),
      //   )
      // }
      // so a user should never do anything with the Primitive type
"
    }),
    #("Primitive", fn() {
      "      @internal
      pub type Primitive(a, b) {
        Primitive(id: Option(String), ext: List(b), value: Option(a))
      }

"
    }),
    #("PrimitiveExtPart", fn() {
      "      @internal
      pub type PrimitiveExtPart(b) {
        PrimitiveExtPart(id: Option(String), ext: List(b))
      }

"
    }),
    #("primitive_slice_to_json", fn() {
      "      pub fn primitive_slice_to_json(
        old_fields: List(#(String, Json)),
        primitive: a,
        field_value_to_json: fn(a) -> Option(Json),
        field_rest_to_json: fn(a) -> Option(Json),
        name: String,
      ) {
        let old_fields = case field_rest_to_json(primitive) {
          None -> old_fields
          Some(value) -> [#(\"_\" <> name, value), ..old_fields]
        }
        case field_value_to_json(primitive) {
          None -> old_fields
          Some(value) -> [#(name, value), ..old_fields]
        }
      }

"
    }),
    #("primitive_slice_list_to_json", fn() {
      "      pub fn primitive_slice_list_to_json(
        old_fields: List(#(String, Json)),
        field: List(a),
        field_value_to_json: fn(a) -> Option(Json),
        field_rest_to_json: fn(a) -> Option(Json),
        name: String,
      ) {
        let vals = list.map(field, fn(value) {
          json.nullable(field_value_to_json(value), fn(json) { json })
        })
        let exts = list.map(field, fn(value) {
          json.nullable(field_rest_to_json(value), fn(json) { json })
        })
        let old_fields = case list.any(vals, fn(j) { j != json.null() }) {
          False -> old_fields
          True -> [#(name, json.preprocessed_array(vals)), ..old_fields]
        }
        case list.any(exts, fn(j) { j != json.null() }) {
          False -> old_fields
          True -> [#(\"_\" <> name, json.preprocessed_array(exts)), ..old_fields]
        }
      }

"
    }),
    #("primitive_ext_part_decoder", fn() {
      "      pub fn primitive_ext_part_decoder(extension_decoder: Decoder(a)) {
        use ext <- decode.optional_field(
          \"extension\",
          [],
          decode.list(extension_decoder),
        )
        use id <- decode.optional_field(\"id\", None, decode.optional(decode.string))
        decode.success(PrimitiveExtPart(ext:, id:))
      }

"
    }),
    #("primitive_decoder", fn() {
      "      pub fn primitive_decoder(name: String, thing_decoder: Decoder(a), extension_decoder: Decoder(b), next: fn(Primitive(a, b)) -> Decoder(c)) -> Decoder(c){
          use value <- decode.optional_field(name, None, decode.optional(thing_decoder))
          use pwe <- decode.optional_field(\"_\" <> name, None, decode.optional(primitive_ext_part_decoder(extension_decoder)))
          let #(id, ext) = case pwe {
            None -> #(None, [])
            Some(PrimitiveExtPart(id, ext)) -> #(id, ext)
          }
          let together = Primitive(id:, ext:, value:,)
          next(together)
      }

"
    }),
    #("primitives_decoder", fn() {
      "      pub fn primitives_decoder(
        name: String,
        thing_decoder: Decoder(a),
        extension_decoder: Decoder(b),
        next: fn(List(Primitive(a, b))) -> Decoder(c),
      ) -> Decoder(c) {
          use values <- decode.optional_field(name, [], decode.list(decode.optional(thing_decoder)))
          use pwes <- decode.optional_field(\"_\" <> name, [], decode.list(decode.optional(primitive_ext_part_decoder(extension_decoder))))
          let together = map2_fillnone(pwes, values, fn(pwe, value){
              let #(id, ext) = case pwe {
                  None -> #(None, [])
                  Some(PrimitiveExtPart(id, ext)) -> #(id, ext)
              }
              Primitive(id:, ext:, value:,)
          })
          next(together)
      }

"
    }),
    #("primitive_slice_decoder", fn() {
      "      pub fn primitive_slice_decoder(
        name: String,
        thing_decoder: Decoder(a),
        extension_decoder: Decoder(b),
        convert: fn(Primitive(a, b)) -> Decoder(c),
        next: fn(c) -> Decoder(d),
      ) -> Decoder(d) {
        use primitive <- primitive_decoder(name, thing_decoder, extension_decoder)
        use value <- decode.then(case primitive.value, primitive.id, primitive.ext {
          None, None, [] -> decode.field(name, thing_decoder, fn(_) { convert(primitive) })
          _, _, _ -> convert(primitive)
        })
        next(value)
      }

"
    }),
    #("primitive_choice_slice_decoder", fn() {
      "      pub fn primitive_choice_slice_decoder(
        name: String,
        thing_decoder: Decoder(a),
        extension_decoder: Decoder(b),
        convert: fn(Primitive(a, b)) -> Decoder(c),
        next: fn(c) -> Decoder(d),
      ) -> Decoder(d) {
        use value_present <- decode.optional_field(
          name,
          False,
          decode.success(True),
        )
        use extension_present <- decode.optional_field(
          \"_\" <> name,
          False,
          decode.success(True),
        )
        case value_present || extension_present {
          True -> primitive_slice_decoder(name, thing_decoder, extension_decoder, convert, next)
          False -> {
            use _ <- decode.field(name, thing_decoder)
            primitive_slice_decoder(name, thing_decoder, extension_decoder, convert, next)
          }
        }
      }

"
    }),
    #("primitive_slice_list_decoder", fn() {
      "      pub fn primitive_slice_list_decoder(
        name: String,
        thing_decoder: Decoder(a),
        extension_decoder: Decoder(b),
        convert: fn(Primitive(a, b)) -> Decoder(c),
        next: fn(List(c)) -> Decoder(d),
      ) -> Decoder(d) {
        use primitives <- primitives_decoder(name, thing_decoder, extension_decoder)
        primitive_slice_list_from_primitives(primitives, convert, name, 0, next)
      }

"
    }),
    #("primitive_slice_list_from_primitives", fn() {
      "      fn primitive_slice_list_from_primitives(
        primitives: List(Primitive(a, b)),
        convert: fn(Primitive(a, b)) -> Decoder(c),
        name: String,
        index: Int,
        next: fn(List(c)) -> Decoder(d),
      ) -> Decoder(d) {
        case primitives {
          [] -> next([])
          [first, ..rest] -> {
            use first <- decode.then(convert(first) |> decode.map_errors(fn(errors) {
              list.map(errors, fn(error) {
                case error.path {
                  [field, ..path] if field == name ->
                    decode.DecodeError(..error, path: [field, int.to_string(index), ..path])
                  _ -> error
                }
              })
            }))
            use rest <- primitive_slice_list_from_primitives(rest, convert, name, index + 1)
            next([first, ..rest])
          }
        }
      }

"
    }),
    #("map2_fillnone", fn() {
      "      pub fn map2_fillnone(list1: List(Option(a)), list2: List(Option(b)), with fun: fn(Option(a), Option(b)) -> c) -> List(c) {
        map2_fillnone_loop(list1, list2, fun, [])
      }

"
    }),
    #("map2_fillnone_loop", fn() {
      "      fn map2_fillnone_loop(
        list1: List(Option(a)),
        list2: List(Option(b)),
        fun: fn(Option(a), Option(b)) -> c,
        acc: List(c),
      ) -> List(c) {
        case list1, list2 {
          [], [] -> list.reverse(acc)
          [a, ..as_], [] -> map2_fillnone_loop(as_, [], fun, [fun(a, None), ..acc])
          [], [b, ..bs] -> map2_fillnone_loop([], bs, fun, [fun(None, b), ..acc])
          [a, ..as_], [b, ..bs] -> map2_fillnone_loop(as_, bs, fun, [fun(a, b), ..acc])
        }
      }


      "
    }),
    #("one_from_array_decoder", fn() {
      "pub fn one_from_array_decoder(
  name: String,
  inner: decode.Decoder(a),
  next: fn(a) -> decode.Decoder(b),
) -> decode.Decoder(b) {
  use values <- decode.field(name, decode.list(inner))
  case values {
    [value] -> next(value)
    _ -> {
      use impossible_value <- decode.field(name, inner)
      next(impossible_value)
    }
  }
}

"
    }),
    #("optional_one_from_array_decoder", fn() {
      "pub fn optional_one_from_array_decoder(
  name: String,
  inner: decode.Decoder(a),
  next: fn(Option(a)) -> decode.Decoder(b),
) -> decode.Decoder(b) {
  use values <- decode.optional_field(name, [], decode.list(inner))
  case values {
    [] -> next(None)
    [value] -> next(Some(value))
    _ -> {
      use impossible_value <- decode.field(name, inner)
      next(Some(impossible_value))
    }
  }
}"
    }),
    #("BoundCoding", fn() {
      codegen_bound_coding.bound_coding_and_cc(
        preserve_slice_order,
        set.insert(
          set.delete(required_names, "BoundCodeableconcept"),
          "BoundCoding",
        ),
        None,
      )
    }),
    #("bound_coding_decoder", fn() { "" }),
    #("BoundCodeableconcept", fn() {
      codegen_bound_coding.bound_coding_and_cc(
        preserve_slice_order,
        set.delete(required_names, "BoundCoding"),
        None,
      )
    }),
    #("BoundCodeablereference", fn() {
      codegen_bound_coding.bound_codeable_reference
    }),
    #("BoundQuantity", fn() { codegen_bound_coding.bound_quantity }),
    #("insert_at", fn() { codegen_bound_coding.insert_at }),
  ]
  let helper_sources =
    helper_definitions
    |> list.filter(fn(definition) { set.contains(required_names, definition.0) })
    |> list.map(fn(definition) { definition.1() })
    |> string.concat
  let complex_modules =
    set.to_list(required_names)
    |> list.filter_map(fn(name) {
      case string.starts_with(name, "import:") {
        True -> Ok(string.drop_start(name, 7))
        False -> Error(Nil)
      }
    })
    |> set.from_list
    |> set.union(complex_required.modules)
  let imports = fn(required: codegen_helpers.RequiredCode, modules) {
    "import gleam/json.{type Json}\n"
    <> "import gleam/dynamic/decode.{type Decoder}\n"
    <> "import gleam/option.{type Option, None, Some}\n"
    <> {
      [
        #("bool", "gleam/bool"),
        #("int", "gleam/int"),
        #("list", "gleam/list"),
        #("string", "gleam/string"),
        #("dict", "gleam/dict"),
        #("float", "gleam/float"),
        #("result", "gleam/result"),
        #("calendar", "gleam/time/calendar"),
        #("order", "gleam/order"),
        #("valuesets", "fhir/" <> pkg_prefix <> "/valuesets"),
      ]
      |> list.filter(fn(entry) { set.contains(modules, entry.0) })
      |> list.map(fn(entry) { "import " <> entry.1 <> "\n" })
      |> string.concat
    }
    <> case
      set.contains(required.types, "Dynamic")
      || set.contains(modules, "dynamic")
    {
      True -> "import gleam/dynamic.{type Dynamic}\n"
      False -> ""
    }
    <> case
      ["Date", "DateTime", "Instant", "Time"]
      |> list.filter(fn(name) { set.contains(required.types, name) })
    {
      [] -> ""
      names ->
        "import fhir/"
        <> pkg_prefix
        <> "/primitive_types.{"
        <> {
          names |> list.map(fn(name) { "type " <> name }) |> string.join(", ")
        }
        <> "} as pt\n"
    }
  }
  let ct_imports = imports(complex_required, complex_modules)
  let r_imports = imports(resource_required, resource_required.modules)
  let resource_complex_imports =
    ["List1", "List2", "List3", "Primitive"]
    |> list.filter(fn(name) { set.contains(resource_required.types, name) })
    |> list.map(fn(name) { "type " <> name })
  let resource_complex_imports =
    list.append(
      resource_complex_imports,
      resource_required.functions
        |> set.to_list
        |> list.filter(fn(name) { dict.has_key(helper_dependencies, name) }),
    )
  let r_ct_import =
    "import fhir/"
    <> pkg_prefix
    <> "/complex_types"
    <> case resource_complex_imports {
      [] -> ""
      names -> ".{" <> string.join(names, ", ") <> "}"
    }
    <> " as ct\n"
  let primitive_types =
    set.intersection(
      required.types,
      set.from_list(["Date", "DateTime", "Instant", "Time"]),
    )
  let f_primitive_types = filepath.join(gen_dir, "primitive_types.gleam")
  let assert Ok(_) =
    simplifile.write(
      to: f_primitive_types,
      contents: template_primitive_types.source(primitive_types),
    )
  io.println("generated " <> f_primitive_types)
  let ct_content =
    string.concat([
      "////[https://hl7.org/fhir/",
      fhir_version,
      "](https://hl7.org/fhir/",
      fhir_version,
      ") complex types\n",
      ct_imports,
      helper_sources,
      complex_types_gen,
    ])
  let r_content =
    string.concat([
      "////[https://hl7.org/fhir/",
      fhir_version,
      "](https://hl7.org/fhir/",
      fhir_version,
      ") resources\n",
      r_imports,
      r_ct_import,
      resources_gen,
    ])
  let f_complex_types = filepath.join(gen_dir, "complex_types.gleam")
  let assert Ok(_) = simplifile.write(to: f_complex_types, contents: ct_content)
  io.println("generated " <> f_complex_types)
  let assert Ok(_) = simplifile.write(to: gen_gleamfile, contents: r_content)
  io.println("generated " <> gen_gleamfile)

  let assert Ok(_) = simplifile.write(to: gen_vsfile, contents: all_vs)
  io.println("generated " <> gen_vsfile)

  let client_files = case client_resources {
    [] -> []
    _ -> {
      let #(sansio, httpc_layer, rsvp_layer, search_params) =
        codegen_client.gen(
          filepath.join(extract_dir_ver, "profiles-resources.json"),
          fhir_version,
          pkg_prefix,
          custom_profile_name,
          case profiles_dir {
            Some(dir) -> dir
            None -> ""
          },
          capability_statement_file,
          gen_specific_resources,
          profile_resource_entries,
          constructors,
        )
      [
        #("sansio.gleam", sansio),
        #("client_httpc.gleam", httpc_layer),
        #("client_rsvp.gleam", rsvp_layer),
        #("search_params.gleam", search_params),
      ]
    }
  }
  list.each(
    [
      "sansio.gleam",
      "client_httpc.gleam",
      "client_rsvp.gleam",
      "search_params.gleam",
    ],
    fn(to_file) {
      let file = filepath.join(gen_dir, to_file)
      case list.key_find(client_files, to_file) {
        Ok(contents) -> {
          let assert Ok(_) = simplifile.write(to: file, contents:)
          io.println("generated " <> to_file)
        }
        Error(_) ->
          case simplifile.delete(file) {
            Ok(_) | Error(simplifile.Enoent) -> Nil
            Error(_) -> panic as { "could not remove " <> file }
          }
      }
    },
  )
}

fn required_complex_types(
  spec_file: String,
  initial: Set(String),
) -> Set(String) {
  let assert Ok(spec) = simplifile.read(spec_file)
  let assert Ok(bundle) =
    json.parse(from: spec, using: codegen_helpers.bundle_decoder())
  let complex_types =
    list.fold(bundle.entry, dict.new(), fn(types, entry) {
      case entry.resource.kind, entry.resource.name {
        Some("complex-type"), "Base"
        | Some("complex-type"), "BackboneElement"
        | Some("complex-type"), "Element"
        -> types
        Some("complex-type"), name -> dict.insert(types, name, entry.resource)
        _, _ -> types
      }
    })
  required_complex_types_loop(complex_types, initial, set.new())
}

fn required_complex_types_loop(
  complex_types: dict.Dict(String, codegen_helpers.Resource),
  pending: Set(String),
  required: Set(String),
) -> Set(String) {
  case set.to_list(pending) {
    [] -> required
    [name, ..] -> {
      let pending = set.delete(pending, name)
      case set.contains(required, name), dict.get(complex_types, name) {
        True, _ | _, Error(_) ->
          required_complex_types_loop(complex_types, pending, required)
        False, Ok(resource) -> {
          let dependencies = case resource.snapshot {
            None -> []
            Some(snapshot) ->
              snapshot.element
              |> list.filter(fn(element) { element.max != "0" })
              |> list.flat_map(fn(element) {
                element.type_ |> list.map(fn(type_) { type_.code })
              })
          }
          let pending =
            list.fold(dependencies, pending, fn(pending, dependency) {
              set.insert(pending, dependency)
            })
          required_complex_types_loop(
            complex_types,
            pending,
            set.insert(required, name),
          )
        }
      }
    }
  }
}

fn file_to_types(
  spec_file spec_file: String,
  fv fhir_version: String,
  current_bucket current_bucket: codegen_helpers.Category,
  valueset_acc valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
  gen_specific_resources gen_specific_resources: Option(List(String)),
  gen_specific_complex_types gen_specific_complex_types: Option(Set(String)),
  minimal_client_resources minimal_client_resources: Set(String),
  valuesets_package_dir valuesets_package_dir: String,
  available_valuesets available_valuesets: dict.Dict(
    String,
    codegen_helpers.VsOrCs,
  ),
) -> #(
  String,
  dict.Dict(String, codegen_helpers.ValuesetItem),
  Set(String),
  List(#(String, String, String)),
  Set(String),
  dict.Dict(String, codegen_profile_json.ConstructorDefinition),
  dict.Dict(String, codegen_helpers.VsOrCs),
) {
  let assert Ok(spec) = simplifile.read(spec_file)
    as "spec files should all be downloaded in dev/downloads/{r4 r4b r5}, run with download arg if not"
  let assert Ok(bundle) =
    json.parse(from: spec, using: codegen_helpers.bundle_decoder())
  let entries =
    list.filter(bundle.entry, fn(e) {
      case e.resource.kind, e.resource.name {
        // _, "AllergyIntolerance" -> True
        // _, _ -> False
        // debug: uncomment to try just allergyintolerance
        _, "Base" -> False
        _, "BackboneElement" -> False
        _, "Resource" -> False
        _, "Element" -> False
        Some("complex-type"), name ->
          case gen_specific_complex_types {
            Some(names) -> set.contains(names, name)
            None -> True
          }
        Some("resource"), resname ->
          case gen_specific_resources {
            None -> True
            Some(gen_specific_resources) ->
              gen_specific_resources |> list.contains(string.lowercase(resname))
          }
        _, _ -> False
      }
    })

  let entries = list.map(entries, fn(entry) { entry.resource })
  let entries =
    list.map(entries, fn(resource) {
      case set.contains(minimal_client_resources, resource.name) {
        False -> resource
        True -> {
          let assert Some(resource_type) = resource.type_
          let assert Ok(fields) =
            list.key_find(codegen_helpers.client_resource_fields, resource_type)
          let needs_valueset_parameters = case gen_specific_resources {
            None -> True
            Some(resources) -> list.contains(resources, "valueset")
          }
          let fields = case
            resource_type == "Parameters" && needs_valueset_parameters
          {
            True -> codegen_helpers.valueset_parameter_fields
            False -> fields
          }
          codegen_helpers.Resource(
            ..resource,
            snapshot: option.map(resource.snapshot, fn(snapshot) {
              codegen_helpers.Snapshot(
                element: snapshot.element
                |> list.filter(fn(element) {
                  element.path == resource_type
                  || list.contains(fields, element.path)
                })
                |> list.map(fn(element) {
                  case element.path == "Parameters.parameter.value[x]" {
                    True ->
                      codegen_helpers.Element(
                        ..element,
                        type_: list.filter(element.type_, fn(type_) {
                          list.contains(
                            codegen_helpers.valueset_parameter_types,
                            type_.code,
                          )
                        }),
                      )
                    False -> element
                  }
                }),
              )
            }),
          )
        }
      }
    })
  let required_valuesets =
    entries
    |> list.flat_map(fn(resource) {
      case resource.snapshot {
        Some(snapshot) -> snapshot.element
        None -> []
      }
    })
    |> list.filter_map(fn(element) {
      case element.max, element.binding {
        "0", _ -> Error(Nil)
        _,
          Some(codegen_helpers.Binding(
            strength: "required",
            value_set: Some(url),
            ..,
          ))
        -> Ok(url)
        _, _ -> Error(Nil)
      }
    })
    |> set.from_list
  let available_valuesets =
    codegen_helpers.load_valuesets(
      valuesets_package_dir,
      required_valuesets,
      available_valuesets,
      fhir_version,
    )
  let unavailable_valuesets =
    set.fold(required_valuesets, set.new(), fn(unavailable, reference) {
      let assert [url, ..] = string.split(reference, "|")
      case
        codegen_helpers.valueset_can_generate_system(url, available_valuesets)
      {
        True -> unavailable
        False -> {
          io.println("unable to expand valueset " <> reference)
          set.insert(unavailable, url)
        }
      }
    })
  // Resolve bindings on the elements before emitting any types or codecs.
  let entries =
    list.map(entries, fn(resource) {
      codegen_helpers.Resource(
        ..resource,
        snapshot: option.map(resource.snapshot, fn(snapshot) {
          codegen_helpers.Snapshot(
            element: list.map(snapshot.element, fn(element) {
              case element.binding {
                Some(
                  codegen_helpers.Binding(
                    strength: "required",
                    value_set: Some(reference),
                    ..,
                  ) as binding,
                ) -> {
                  let assert [url, ..] = string.split(reference, "|")
                  case set.contains(unavailable_valuesets, url) {
                    True ->
                      codegen_helpers.Element(
                        ..element,
                        binding: Some(
                          codegen_helpers.Binding(..binding, available: False),
                        ),
                      )
                    False -> element
                  }
                }
                _ -> element
              }
            }),
          )
        }),
      )
    })
  let referenced_type_names =
    entries
    |> list.flat_map(fn(resource) {
      case resource.snapshot {
        Some(snapshot) -> snapshot.element
        None -> []
      }
    })
    |> list.filter(fn(element) { element.max != "0" })
    |> list.flat_map(fn(element) {
      element.type_ |> list.map(fn(type_) { type_.code })
    })
    |> set.from_list

  let #(all_resources_and_types, valueset_acc, constructors) =
    list.fold(
      entries,
      #("", valueset_acc, dict.new()),
      fn(acc, resource: codegen_helpers.Resource) {
        let #(elt_str_acc, valueset_acc, constructors) = acc
        //map of type -> fields needed to list out all the BackboneElements
        //because they're subcomponents eg Allergy -> Reaction
        //and rather than nested, we want to write fields one after the other
        let starting_res_fields = dict.new() |> dict.insert(resource.name, [])
        //we want to write types in order of parsing backbone elements, but map order random
        //put elts into name of current struct, eg AllergyIntolerance, AllergyIntoleranceReaction...
        let type_order = [resource.name]
        let assert Some(snapshot) = resource.snapshot

        let f_o = #(starting_res_fields, type_order)

        let #(resource_types, valueset_acc, constructors) = {
          let fields_and_order =
            list.fold(over: snapshot.element, from: f_o, with: fn(f_o, elt) {
              let res_fields = f_o.0
              let order = f_o.1

              let pathparts =
                elt.id
                |> string.replace("-", "")
                |> string.replace(":", ".")
                |> string.split(".")
              let assert [_, ..rest] = pathparts
              let pathparts = [resource.name, ..rest]
              let field_path = string.join(pathparts, "_")
              //there must be a better way to drop last item?
              let pp_minus_last =
                pathparts |> list.reverse |> list.drop(1) |> list.reverse
              let field_path_minus_last = string.join(pp_minus_last, "_")

              let appended_field = case
                dict.get(res_fields, field_path_minus_last)
              {
                Ok(field_list) -> [elt, ..field_list]
                Error(_) -> [elt]
              }
              let res_fields =
                dict.insert(res_fields, field_path_minus_last, appended_field)

              let order = case elt.type_ {
                [first, ..] -> {
                  case first.code {
                    "BackboneElement" -> [field_path, ..order]
                    "Element" -> [field_path, ..order]
                    _ -> order
                  }
                }
                [] -> order
              }
              #(res_fields, order)
            })

          let type_fields = fields_and_order.0
          let type_order = fields_and_order.1

          list.fold(
            over: type_order,
            from: #("", valueset_acc, constructors),
            with: fn(acc, new_type) {
              let #(old_type_acc, valueset_acc, constructors) = acc
              let new_doc_link = {
                let link =
                  string.concat([
                    string.replace(
                      resource.url,
                      "hl7.org/fhir",
                      "hl7.org/fhir/" <> fhir_version,
                    ),
                    "#resource",
                  ])
                "///[" <> link <> "](" <> link <> ")"
              }

              let camel_type = case new_type == resource.name {
                True ->
                  resource.id
                  |> string.replace("-", "_")
                  |> codegen_helpers.to_camel_case
                False -> new_type |> codegen_helpers.to_camel_case
              }
              //conflict gleam list
              let camel_type = case camel_type == "List" {
                True -> "Listfhir"
                False -> camel_type
              }
              let snake_type = codegen_helpers.to_snake_case(camel_type)
              let assert Ok(fields) = dict.get(type_fields, new_type)
              let fields = case resource.name {
                "SimpleQuantity" ->
                  list.filter(fields, fn(x) { x.path != "Quantity.comparator" })
                //simplequantity has no comparator
                _ -> fields
              }
              let fields =
                fields
                |> list.filter(fn(elt) { elt.max != "0" })
              // this tuple is important - all the stuff you generate for each field
              // should probably be a custom type
              // also choice fields do one more fold within this, on their type possibilities
              // make field type, its [x] types, type_new() args and fields, to_json args/always+optional, decoder
              let #(
                field_list,
                choicetypes,
                newfunc_args,
                newfunc_fields,
                encoder_json_always,
                encoder_json_options,
                decoder_use,
                decoder_success,
                decoder_always_failure_fordr,
                valueset_acc,
                constructor_arguments,
                constructor_fields,
                constructors,
              ) =
                list.fold(
                  from: #(
                    "",
                    list.new(),
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    valueset_acc,
                    [],
                    [],
                    constructors,
                  ),
                  over: fields,
                  with: fn(acc, elt: codegen_helpers.Element) {
                    //this should clearly be custom type not tuple
                    let fields_acc = acc.0
                    let choicetypes_acc = acc.1
                    let newfunc_args_acc = acc.2
                    let newfunc_fields_acc = acc.3
                    let encoder_always_acc = acc.4
                    let encoder_optional_acc = acc.5
                    let decoder_use_acc = acc.6
                    let decoder_success_acc = acc.7
                    let decoder_always_failure_acc = acc.8
                    let valueset_acc = acc.9
                    let constructor_arguments = acc.10
                    let constructor_fields = acc.11
                    let constructors = acc.12
                    //yeah this should be custom type right
                    let allparts =
                      elt.id
                      |> string.replace("-", "")
                      |> string.replace(":", ".")
                      |> string.split(".")
                    let assert [_, ..rest_allparts] = allparts
                    let allparts = [resource.name, ..rest_allparts]
                    let assert Ok(elt_last_part) = allparts |> list.last
                    //for choice types, which will have a custom type
                    let elt_last_part_withgleamtype =
                      string.replace(elt_last_part, "[x]", "")
                    // withgleamtype still hasnt escaped the gleam types (use, case, etc) but it's expected in json fields
                    // so "\"" <> elt_last_part_withgleamtype <> "\"" should always be actual string for json
                    let elt_last_part =
                      codegen_helpers.escape_field_name(
                        elt_last_part_withgleamtype,
                      )
                    let field_name_new =
                      camel_type <> string.capitalise(elt_last_part)
                    let is_primitive = False
                    let #(field_type, valueset_acc) = case elt.type_ {
                      [one_type] -> {
                        let #(base_type, valueset_acc) =
                          codegen_helpers.string_to_type(
                            one_type.code,
                            allparts,
                            elt,
                            current_bucket,
                            valueset_acc,
                          )
                        let field_type = base_type
                        #(field_type, valueset_acc)
                      }
                      [] -> #(
                        {
                          codegen_helpers.link_type_from(
                            elt.content_reference,
                            resource.name,
                          )
                          |> codegen_helpers.to_camel_case
                        },
                        valueset_acc,
                      )
                      _ -> #(field_name_new, valueset_acc)
                    }
                    let elt_snake = codegen_helpers.to_snake_case(elt_last_part)
                    let this_type_fields =
                      string.concat([
                        case elt.max {
                          "0" | "1" | "*" -> ""
                          _ -> "// TODO enforce max somehow\n"
                        },
                        elt_snake,
                        ": ",
                        codegen_helpers.cardinality(
                          field_type,
                          elt.min,
                          elt.max,
                        ),
                        ",\n",
                        fields_acc,
                      ])
                    let #(choicetypes_acc, valueset_acc, constructors) = case
                      elt.type_
                    {
                      [] -> #(choicetypes_acc, valueset_acc, constructors)
                      [_] -> #(choicetypes_acc, valueset_acc, constructors)
                      _ -> {
                        let #(choice_fields, valueset_acc, constructors) =
                          list.fold(
                            over: elt.type_,
                            from: #("", valueset_acc, constructors),
                            with: fn(acc, typ) {
                              let #(fields_acc, valueset_acc, constructors) =
                                acc
                              let #(choice_type, valueset_acc) =
                                codegen_helpers.string_to_type(
                                  typ.code,
                                  allparts,
                                  elt,
                                  current_bucket,
                                  valueset_acc,
                                )
                              #(
                                string.concat([
                                  fields_acc,
                                  //add all fields of this choice type
                                  "\n",
                                  field_name_new,
                                  string.capitalise(typ.code),
                                  "(",
                                  elt_snake,
                                  ": ",
                                  choice_type,
                                  ")",
                                ]),
                                valueset_acc,
                                codegen_profile_json.record_choice(
                                  constructors,
                                  current_bucket,
                                  field_name_new,
                                  field_name_new <> string.capitalise(typ.code),
                                  choice_type,
                                ),
                              )
                            },
                          )
                        #(
                          [
                            string.concat([
                              "\n",
                              new_doc_link,
                              "\npub type ",
                              field_name_new,
                              "{",
                              choice_fields,
                              "}",
                              //each choice type needs its own to_json and decoder
                              "\npub fn ",
                              snake_type,
                              "_",
                              elt_last_part |> string.lowercase(),
                              "_to_json(elt: ",
                              field_name_new,
                              ") -> Json {case elt{",
                              list.fold(
                                over: elt.type_,
                                from: "",
                                with: fn(acc, typ) {
                                  //add all cases of choice type to type_to_json()
                                  string.concat([
                                    acc,
                                    field_name_new,
                                    string.capitalise(typ.code),
                                    "(v) -> ",
                                    codegen_to_json.string_to_encoder_call(
                                      typ.code,
                                      allparts,
                                      elt,
                                      current_bucket,
                                      "v",
                                    ),
                                    "\n",
                                  ])
                                },
                              ),
                              "}}",
                              //now the decoder
                              "\npub fn ",
                              snake_type,
                              "_",
                              elt_last_part |> string.lowercase(),
                              "_decoder() -> Decoder(",
                              field_name_new,
                              "){",
                              // each choice field here needs to decode from not just type but prefixType
                              // dateTime -> onsetDateTime or age -> onsetAge etc
                              // idk will do later!
                              {
                                // need to split types into first and rest for decoder because idk
                                // gleam decode.one_of needs it that way...
                                // to get an error msg from first or something but it is not a joyful api
                                let assert [fst_type_, ..rest_type_] = elt.type_
                                let decode_one_of_first =
                                  codegen_decode.gen_choice_field_decoder(
                                    fst_type_.code,
                                    allparts,
                                    fhir_version,
                                    elt,
                                    field_name_new
                                      <> string.capitalise(fst_type_.code),
                                    elt_last_part_withgleamtype,
                                    current_bucket,
                                  )
                                let decode_one_of_rest =
                                  list.fold(
                                    over: rest_type_,
                                    from: "",
                                    with: fn(acc, typ) {
                                      //add all cases of choice type to type_to_json()
                                      string.concat([
                                        acc,
                                        codegen_decode.gen_choice_field_decoder(
                                          typ.code,
                                          allparts,
                                          fhir_version,
                                          elt,
                                          field_name_new
                                            <> string.capitalise(typ.code),
                                          elt_last_part_withgleamtype,
                                          current_bucket,
                                        ),
                                      ])
                                    },
                                  )
                                "decode.one_of("
                                <> decode_one_of_first
                                <> "["
                                <> decode_one_of_rest
                                <> "])"
                              },
                              "}",
                            ]),
                            ..choicetypes_acc
                            //add to all choice types
                          ],
                          valueset_acc,
                          constructors,
                        )
                      }
                    }
                    let #(newfunc_arg, newfunc_field, required_argument) =
                      codegen_helpers.new_fn_arg_and_field(
                        elt_snake,
                        field_type,
                        elt.min,
                        elt.max,
                        is_primitive,
                      )
                    //all the fields for encoder to convert to json
                    let field_value = snake_type <> "." <> elt_snake
                    let field_type_encoder = case elt.type_ {
                      [one_type] ->
                        codegen_to_json.string_to_encoder_type(
                          one_type.code,
                          allparts,
                          elt,
                          current_bucket,
                        )
                      [] -> {
                        codegen_helpers.link_type_from(
                          elt.content_reference,
                          resource.name,
                        )
                        <> "_to_json"
                      }
                      _ ->
                        snake_type
                        <> "_"
                        <> elt_last_part |> string.lowercase()
                        <> "_to_json"
                    }
                    let field_type_encoder_call = fn(value) {
                      case elt.type_ {
                        [one_type] ->
                          codegen_to_json.string_to_encoder_call(
                            one_type.code,
                            allparts,
                            elt,
                            current_bucket,
                            value,
                          )
                        _ -> field_type_encoder <> "(" <> value <> ")"
                      }
                    }
                    // can't just put all encode json args in one big acc in array
                    // because optional ones need case to add to array or not
                    // also putting lists as optional_acc so in empty list cast it omits instead of field: []
                    // hence two separate accs
                    let field_max = case elt.max {
                      "0" | "1" -> elt.max
                      _ -> "*"
                    }
                    let #(
                      encoder_optional_acc,
                      encoder_always_acc,
                      decoder_always_failure_acc,
                    ) = case elt.min, field_max {
                      0, "*" -> {
                        //0..* list: omit from json if empty
                        let opts =
                          encoder_optional_acc
                          <> "\nlet fields = case "
                          <> field_value
                          <> " {
                        [] -> fields
                        _ -> [#(\""
                          <> elt_last_part_withgleamtype
                          <> "\", json.array("
                          <> field_value
                          <> ","
                          <> field_type_encoder
                          <> ")), ..fields]
                          }"
                        #(opts, encoder_always_acc, decoder_always_failure_acc)
                      }
                      1, "*" -> {
                        //1..* list: always present, destructure List1
                        let always =
                          encoder_always_acc
                          <> "#(\""
                          <> elt_last_part_withgleamtype
                          <> "\", list1_to_json("
                          <> field_value
                          <> ","
                          <> field_type_encoder
                          <> ")),"
                        let decoder_always_failure =
                          decoder_always_failure_acc <> elt_snake <> ":, "
                        #(encoder_optional_acc, always, decoder_always_failure)
                      }
                      2, "*" -> {
                        //2..* list: always present, destructure List2
                        let always =
                          encoder_always_acc
                          <> "#(\""
                          <> elt_last_part_withgleamtype
                          <> "\", list2_to_json("
                          <> field_value
                          <> ","
                          <> field_type_encoder
                          <> ")),"
                        let decoder_always_failure =
                          decoder_always_failure_acc <> elt_snake <> ":, "
                        #(encoder_optional_acc, always, decoder_always_failure)
                      }
                      3, "*" -> {
                        //3..* list: always present, destructure List3
                        let always =
                          encoder_always_acc
                          <> "#(\""
                          <> elt_last_part_withgleamtype
                          <> "\", list3_to_json("
                          <> field_value
                          <> ","
                          <> field_type_encoder
                          <> ")),"
                        let decoder_always_failure =
                          decoder_always_failure_acc <> elt_snake <> ":, "
                        #(encoder_optional_acc, always, decoder_always_failure)
                      }
                      0, "1" -> {
                        //optional case to json, in Some case add to fields list
                        let choicetype_suffixes =
                          codegen_helpers.gen_choicetype_suffixes(
                            "v",
                            elt.type_,
                            field_name_new,
                          )
                        let opts =
                          encoder_optional_acc
                          <> "\nlet fields = case "
                          <> field_value
                          <> " {
                        Some(v) -> [#(\""
                          <> elt_last_part_withgleamtype
                          <> "\""
                          <> choicetype_suffixes
                          <> ", "
                          <> field_type_encoder_call("v")
                          <> "), ..fields]
                          None -> fields
                        }"
                        #(opts, encoder_always_acc, decoder_always_failure_acc)
                      }
                      1, "1" -> {
                        //mandatory case to json, put in first fields list
                        let choicetype_suffixes =
                          codegen_helpers.gen_choicetype_suffixes(
                            field_value,
                            elt.type_,
                            field_name_new,
                          )
                        let always =
                          encoder_always_acc
                          <> "#(\""
                          <> elt_last_part_withgleamtype
                          <> "\""
                          <> choicetype_suffixes
                          <> ", "
                          <> field_type_encoder_call(field_value)
                          <> "),"
                        let decoder_always_failure =
                          decoder_always_failure_acc <> elt_snake <> ":, "
                        #(encoder_optional_acc, always, decoder_always_failure)
                      }
                      _, _ -> panic as "cardinality panic 72"
                    }
                    let field_type_decoder = case elt.type_ {
                      [_] | [] -> {
                        let decoder_itself = case elt.type_ {
                          [one_type] ->
                            codegen_decode.string_to_decoder_type(
                              one_type.code,
                              allparts,
                              fhir_version,
                              elt,
                              current_bucket,
                            )
                          [] ->
                            codegen_helpers.link_type_from(
                              elt.content_reference,
                              resource.name,
                            )
                            <> "_decoder()"
                          _ -> panic as "compiler should see this cant happen"
                        }
                        codegen_decode.field_decoder(
                          elt_last_part_withgleamtype,
                          decoder_itself,
                          elt.min,
                          elt.max,
                          is_primitive,
                        )
                      }
                      _ -> {
                        let choicetype_decoder_itself =
                          string.concat([
                            snake_type,
                            "_",
                            elt_last_part |> string.lowercase(),
                            "_decoder()",
                          ])
                        case elt.min {
                          //for choice type case, custom decoder already knows field names, but we need decode.then and omit if empty
                          1 ->
                            "decode.then(" <> choicetype_decoder_itself <> ")"
                          0 ->
                            "decode.then(none_if_omitted("
                            <> choicetype_decoder_itself
                            <> "))"
                          _ -> panic as "card panic 37"
                        }
                      }
                    }

                    let decoder_use_acc =
                      string.concat([
                        decoder_use_acc,
                        "use ",
                        elt_snake,
                        " <- ",
                        field_type_decoder,
                        "\n",
                      ])
                    let decoder_success_acc =
                      decoder_success_acc <> elt_snake <> ":,"
                    #(
                      this_type_fields,
                      choicetypes_acc,
                      newfunc_args_acc <> newfunc_arg,
                      newfunc_fields_acc <> newfunc_field,
                      encoder_always_acc,
                      encoder_optional_acc,
                      decoder_use_acc,
                      decoder_success_acc,
                      decoder_always_failure_acc,
                      valueset_acc,
                      case required_argument {
                        Some(argument) -> [argument, ..constructor_arguments]
                        None -> constructor_arguments
                      },
                      [
                        #(
                          codegen_helpers.Element(
                            ..elt,
                            gleam_type: Some(field_type),
                          ),
                          codegen_helpers.cardinality(
                            field_type,
                            elt.min,
                            elt.max,
                          ),
                        ),
                        ..constructor_fields
                      ],
                      constructors,
                    )
                  },
                )
              //now have #(field_list, choicetypes, newfunc_args, newfunc_fields) tuple should prolly be custom type or something
              // first elt in tuple is all the fields for this type

              let type_newfields =
                string.concat([
                  "pub type ",
                  camel_type,
                  "\n{\n",
                  camel_type,
                  "(",
                  field_list,
                  ")\n}",
                ])
              let type_new_newfunc =
                string.concat([
                  "pub fn ",
                  snake_type,
                  "_new(",
                  newfunc_args,
                  ") ->" <> camel_type,
                  "{",
                  camel_type,
                  case newfunc_fields {
                    "" -> ""
                    _ -> "(" <> newfunc_fields <> ")"
                  },
                  "\n}",
                ])
              let type_choicetypes = string.join(choicetypes, "\n")
              let is_domainresource = case resource.kind {
                Some("complex-type") -> False
                Some("resource") -> resource.name == new_type
                _ -> panic as "????"
              }
              let assert Some(fhir_resource_type) = resource.type_

              let constructors = case camel_type {
                "Extension" -> constructors
                _ ->
                  dict.insert(
                    constructors,
                    codegen_profile_json.constructor_key(
                      current_bucket,
                      camel_type,
                    ),
                    codegen_profile_json.RecordConstructor(
                      current_bucket,
                      list.reverse(constructor_arguments),
                      list.reverse(constructor_fields),
                    ),
                  )
              }
              let #(source, valueset_acc) = case camel_type {
                "Extension" -> {
                  let assert [elt, ..] = fields
                  let #(extension_value_types, valueset_acc) =
                    list.fold(
                      over: elt.type_,
                      from: #("", valueset_acc),
                      with: fn(acc, typ: codegen_helpers.Type) {
                        let #(types_acc, valueset_acc) = acc
                        let #(type_, valueset_acc) =
                          codegen_helpers.string_to_type(
                            typ.code,
                            [],
                            elt,
                            codegen_helpers.ComplexTypes,
                            valueset_acc,
                          )
                        #(
                          string.concat([
                            types_acc,
                            "ExtensionValue",
                            string.capitalise(typ.code),
                            "(value: ",
                            type_,
                            ")",
                            "\n",
                          ]),
                          valueset_acc,
                        )
                      },
                    )
                  #("
              ///[http://hl7.org/fhir/r4/StructureDefinition/Extension#resource](http://hl7.org/fhir/r4/StructureDefinition/Extension#resource)
              pub type Extension {
                Extension(id: Option(String), url: String, ext: ExtensionSimpleOrComplex)
              }
              ///[http://hl7.org/fhir/r4/StructureDefinition/Extension#resource](http://hl7.org/fhir/r4/StructureDefinition/Extension#resource)
              pub type ExtensionSimpleOrComplex {
                ExtComplex(children: List(Extension))
                ExtSimple(value: ExtensionValue)
              }
              ///[http://hl7.org/fhir/r4/StructureDefinition/Extension#resource](http://hl7.org/fhir/r4/StructureDefinition/Extension#resource)
              pub type ExtensionValue {
                " <> extension_value_types <> "
              }
              pub fn extension_to_json(extension: Extension) -> Json {
                let fields = [#(\"url\", json.string(extension.url))]
                let fields = case extension.id {
                  Some(v) -> [#(\"id\", json.string(v)), ..fields]
                  None -> fields
                }
                let fields = [ext_simple_or_complex_to_json(extension.ext), ..fields]
                json.object(fields)
              }
              fn ext_simple_or_complex_to_json(ext) {
                case ext {
                  ExtComplex(children) -> #(
                    \"extension\",
                    json.array(children, extension_to_json),
                  )
                  ExtSimple(val) -> extsimple_to_json(val)
                }
              }
              fn extsimple_to_json(v: ExtensionValue) -> #(String, Json) {
                #(
                  \"value\"
                    <> case v {" <> list.fold(
                    over: elt.type_,
                    from: "",
                    with: fn(acc: String, typ: codegen_helpers.Type) -> String {
                      string.concat([
                        acc,
                        "ExtensionValue",
                        string.capitalise(typ.code),
                        "(_) -> \"",
                        {
                          let assert [fst, ..rest] =
                            string.to_graphemes(typ.code)
                          string.uppercase(fst) <> string.concat(rest)
                        },
                        "\"",
                      ])
                    },
                  ) <> "},
                  extension_value_to_json(v),
                )
              }
              pub fn extension_value_to_json(elt: ExtensionValue) -> Json {
                case elt {
                  " <> list.fold(
                    over: elt.type_,
                    from: "",
                    with: fn(acc: String, typ: codegen_helpers.Type) -> String {
                      string.concat([
                        acc,
                        "ExtensionValue",
                        string.capitalise(typ.code),
                        "(v) -> ",
                        codegen_to_json.string_to_encoder_call(
                          typ.code,
                          [],
                          elt,
                          codegen_helpers.ComplexTypes,
                          "v",
                        ),
                        "\n",
                      ])
                    },
                  ) <> "
              }
              }
              pub fn extension_decoder() -> Decoder(Extension) {
                use url <- decode.field(\"url\", decode.string)
                use id <- decode.optional_field(\"id\", None, decode.optional(decode.string))
                use ext <- decode.then(ext_simple_or_complex_decoder())
                decode.success(Extension(url:, id:, ext:))
              }
              pub fn ext_simple_or_complex_decoder() {
                decode.one_of(
                  decode.field(\"extension\", decode.list(extension_decoder()), decode.success)
                    |> decode.map(ExtComplex),
                  [" <> list.fold(
                    over: elt.type_,
                    from: "",
                    with: fn(acc: String, typ: codegen_helpers.Type) -> String {
                      let assert [fst, ..rest] = string.to_graphemes(typ.code)
                      let first_upper =
                        string.uppercase(fst) <> string.concat(rest)
                      string.concat([
                        acc,
                        "decode.field(\"value"
                          <> first_upper
                          <> "\", "
                          <> codegen_decode.string_to_decoder_type(
                          typ.code,
                          [],
                          "",
                          elt,
                          codegen_helpers.ComplexTypes,
                        )
                          <> ", decode.success)
                       |> decode.map(ExtensionValue"
                          <> string.capitalise(typ.code)
                          <> ")
                       |> decode.map(ExtSimple),",
                      ])
                    },
                  ) <> "],
                )
              }
              ", valueset_acc)
                }
                _ -> {
                  let decoder =
                    codegen_decode.gen_res_decoder(
                      fhir_resource_type,
                      camel_type,
                      snake_type,
                      decoder_use,
                      decoder_success,
                      is_domainresource,
                      decoder_always_failure_fordr,
                    )
                  #(
                    string.join(
                      [
                        new_doc_link,
                        type_newfields,
                        type_choicetypes,
                        type_new_newfunc,
                        old_type_acc,
                        codegen_helpers.gen_res_encoder(
                          fhir_resource_type,
                          camel_type,
                          snake_type,
                          encoder_json_always,
                          encoder_json_options,
                          is_domainresource,
                          constructor_fields != [],
                        ),
                        decoder,
                        add_forgiving_type_and_decoder_if_bundle_or_bundleentry(
                          camel_type,
                          type_newfields,
                          decoder,
                          decoder_success,
                        ),
                      ],
                      "\n",
                    ),
                    valueset_acc,
                  )
                }
              }
              #(source, valueset_acc, constructors)
            },
          )
        }
        let gen_str = elt_str_acc <> "\n" <> resource_types
        #(gen_str, valueset_acc, constructors)
      },
    )
  let resource_entries = case
    spec_file |> string.ends_with("profiles-resources.json")
  {
    False -> []
    True ->
      entries
      |> list.filter(fn(resource) {
        resource.kind == Some("resource") && resource.name != "DomainResource"
      })
      |> list.map(fn(resource) {
        let assert Some(resource_type) = resource.type_
        let gleam_type =
          resource.id
          |> string.replace("-", "_")
          |> codegen_helpers.to_camel_case
        let gleam_type = case gleam_type {
          "List" -> "Listfhir"
          _ -> gleam_type
        }
        #(resource_type, gleam_type, resource.url)
      })
  }
  #(
    all_resources_and_types,
    valueset_acc,
    referenced_type_names,
    resource_entries,
    entries |> list.map(fn(resource) { resource.url }) |> set.from_list,
    constructors,
    available_valuesets,
  )
}

fn add_forgiving_type_and_decoder_if_bundle_or_bundleentry(
  camel_type: String,
  type_newfields: String,
  normal_decoder: String,
  decoder_success: String,
) -> String {
  case camel_type {
    "Bundle" -> {
      let typ =
        type_newfields
        |> string.replace("pub type Bundle {", "pub type BundleForgiving {")
        |> string.replace("pub type Bundle\n{", "pub type BundleForgiving\n{")
        |> string.replace("Bundle(", "BundleForgiving(")
        |> string.replace(
          "entry: List(BundleEntry),",
          "entry: List(BundleEntryForgiving),",
        )

      let decoder_success = decoder_success <> "), \"resourceType\")"
      let decoder =
        normal_decoder
        |> string.replace(
          "pub fn bundle_decoder() -> Decoder(Bundle)",
          "pub fn bundle_decoder_forgiving() -> Decoder(BundleForgiving)",
        )
        |> string.replace(
          "decode.list(bundle_entry_decoder())",
          "decode.list(bundle_entry_decoder_forgiving())",
        )
        |> string.replace(
          "decode.success(Bundle(",
          "decode.success(BundleForgiving(",
        )
        |> string.replace(
          "decode.failure(bundle_new(type_:, ), \"resourceType\")",
          "decode.failure(BundleForgiving(" <> decoder_success,
        )
        |> string.replace(
          "decode.failure(bundle_new(), \"resourceType\")",
          "decode.failure(BundleForgiving(" <> decoder_success,
        )

      typ <> "\n" <> decoder
    }
    "BundleEntry" -> {
      let typ =
        type_newfields
        |> string.replace(
          "pub type BundleEntry {",
          "pub type BundleEntryForgiving {",
        )
        |> string.replace(
          "pub type BundleEntry\n{",
          "pub type BundleEntryForgiving\n{",
        )
        |> string.replace("BundleEntry(", "BundleEntryForgiving(")
        |> string.replace(
          "resource: Option(Resource),",
          "resource: Option(Result(Resource, List(decode.DecodeError))),",
        )

      let forgiving_resource_decoder =
        "decode.optional(
      decode.one_of(resource_decoder() |> decode.map(Ok), [
        decode.dynamic
        |> decode.map(fn(res_json) {
          decode.run(res_json, resource_decoder())
        }),
      ]),
    )"

      let decoder =
        normal_decoder
        |> string.replace(
          "pub fn bundle_entry_decoder() -> Decoder(BundleEntry)",
          "pub fn bundle_entry_decoder_forgiving() -> Decoder(BundleEntryForgiving)",
        )
        |> string.replace(
          "decode.optional(resource_decoder())",
          forgiving_resource_decoder,
        )
        |> string.replace(
          "decode.success(BundleEntry(",
          "decode.success(BundleEntryForgiving(",
        )

      typ <> "\n" <> decoder
    }
    _ -> ""
  }
}

// region valuesets
// note we already have a list of required bindings from resources, now need to fill codes in for those

fn valueset_type_source(
  vs_url: String,
  vsname: String,
  all_vs_or_cs: dict.Dict(String, codegen_helpers.VsOrCs),
  needs_system: Bool,
  needs_code: Bool,
  needs_membership: Bool,
) {
  let assert Ok(codegen_helpers.VocValueset(codes: members, ..)) =
    dict.get(all_vs_or_cs, vs_url)
    as { "Could not load ValueSet " <> vs_url }
  let assert True = members != []
    as { "ValueSet has no selectable codes: " <> vs_url }
  let systems = members |> list.map(fn(member) { member.0 }) |> set.from_list
  let codes =
    list.map(members, fn(member) {
      codegen_bound_coding.ValuesetCodeWithSystem(
        code: member.1,
        system: member.0,
        variant: "",
      )
    })
  let membership_source = case needs_membership && !needs_system {
    True ->
      codegen_bound_coding.gen_valueset_from_code_and_system(
        vsname,
        codes,
        False,
      )
    False -> ""
  }
  use <- bool.guard(!needs_system && !needs_code, #(
    membership_source,
    [],
    False,
  ))
  //   let #(codes, open_variants, systems) =
  //     list.fold(members, #([], [], set.new()), fn(acc, member) {
  //       let #(codes, open_variants, systems) = acc
  //       let #(system, code) = member
  //       let systems = set.insert(systems, system)
  //       case code {
  //         Some(code) -> #(
  //           [
  //             codegen_bound_coding.ValuesetCodeWithSystem(
  //               code:,
  //               system:,
  //               variant: "",
  //             ),
  //             ..codes
  //           ],
  //           open_variants,
  //           systems,
  //         )
  //         None -> #(
  //           codes,
  //           [
  //             codegen_bound_coding.OpenValuesetVariant(
  //               name: vsname <> codegen_helpers.concept_name_from_url(system),
  //               system:,
  //             ),
  //             ..open_variants
  //           ],
  //           systems,
  //         )
  //       }
  //     })
  //   let codes = list.reverse(codes)
  //   let open_variants = case needs_system, open_variants {
  //     False, [_, _, ..] -> [
  //       codegen_bound_coding.OpenValuesetVariant(
  //         name: vsname <> "Other",
  //         system: "",
  //       ),
  //     ]
  //     _, _ -> open_variants
  //   }
  let #(code_systems, duplicate_codes) =
    list.fold(codes, #(dict.new(), set.new()), fn(acc, member) {
      let #(seen_codes, duplicate_codes) = acc
      let codegen_bound_coding.ValuesetCodeWithSystem(code:, system:, ..) =
        member
      case dict.has_key(seen_codes, code) {
        True -> #(seen_codes, set.insert(duplicate_codes, code))
        False -> #(dict.insert(seen_codes, code, system), duplicate_codes)
      }
    })
  let codes = case needs_system {
    True -> codes
    False ->
      list.filter(codes, fn(member) {
        dict.get(code_systems, member.code) == Ok(member.system)
      })
  }
  let assert Ok(vs_url_name) = vs_url |> string.split("/") |> list.last
  let assert Ok(vs_namespace) = vs_url_name |> string.split("-") |> list.first
  let vs_namespace =
    vs_namespace |> codegen_helpers.codetovarname |> string.capitalise
  let codes =
    list.map(codes, fn(member) {
      let codegen_bound_coding.ValuesetCodeWithSystem(code:, system:, ..) =
        member
      let code_name = code |> codegen_helpers.codetovarname |> string.capitalise
      let variant = case needs_system && set.contains(duplicate_codes, code) {
        False -> code_name
        True -> {
          let system_name = codegen_helpers.concept_name_from_url(system)
          let system_name = case string.starts_with(system_name, vs_namespace) {
            True ->
              system_name
              |> string.drop_start(string.length(vs_namespace))
              |> string.capitalise
            False -> system_name
          }
          system_name <> code_name
        }
      }
      codegen_bound_coding.ValuesetCodeWithSystem(..member, variant:)
    })
  let valueset_items =
    "pub const "
    <> string.lowercase(vsname)
    <> ": List("
    <> vsname
    <> ") = ["
    <> {
      codes
      |> list.map(fn(member) { vsname <> member.variant })
      |> string.join(", ")
    }
    <> "]\n"
  let variants =
    codes
    |> list.map(fn(member) {
      let codegen_bound_coding.ValuesetCodeWithSystem(variant:, ..) = member
      vsname <> variant <> "\n"
    })
    |> string.concat
  //     |> string.append(
  //       list.fold(open_variants, "", fn(acc, open_variant) {
  //         let codegen_bound_coding.OpenValuesetVariant(name:, ..) = open_variant
  //         acc <> name <> "(value: String)\n"
  //       }),
  //     )
  let has_decoder = needs_code
  let code_functions = case needs_system {
    True ->
      string.concat([
        case needs_code {
          True -> gen_valueset_encoder(vsname)
          False -> ""
        },
        gen_valueset_to_code(vsname, codes),
        codegen_bound_coding.gen_valueset_from_code_and_system(
          vsname,
          codes,
          True,
        ),
        case has_decoder {
          False -> ""
          True -> {
            let codes =
              list.filter(codes, fn(member) {
                dict.get(code_systems, member.code) == Ok(member.system)
              })
            gen_valueset_from_code(vsname, codes)
            <> gen_valueset_decoder(vsname, codes)
          }
        },
      ])
    False ->
      string.concat([
        gen_valueset_encoder(vsname),
        gen_valueset_to_code(vsname, codes),
        gen_valueset_from_code(vsname, codes),
        gen_valueset_decoder(vsname, codes),
      ])
  }
  let system_function = case needs_system {
    True -> codegen_bound_coding.gen_valueset_system(vsname, codes, systems)
    False -> ""
  }
  let failure_variant_replacements = [
    #(
      "valuesets." <> string.lowercase(vsname) <> "_failure_variant",
      "valuesets."
        <> codegen_bound_coding.valueset_failure_variant_source(vsname, codes),
    ),
  ]
  #(
    "pub type "
      <> vsname
      <> "{"
      <> variants
      <> "}\n"
      <> case has_decoder {
      True -> valueset_items
      False -> ""
    }
      <> code_functions
      <> membership_source
      <> system_function,
    failure_variant_replacements,
    has_decoder,
  )
}

fn valueset_to_types(
  fhir_version: String,
  valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
  all_vs_or_cs: dict.Dict(String, codegen_helpers.VsOrCs),
) {
  // the valueset urls needed by elements by required bindings
  // and if they are for a code or for coding/cc
  // because if latter
  let vs_url_set =
    valueset_acc
    |> dict.keys
    |> set.from_list
    |> set.delete("")
  // |> set.delete("http://unitsofmeasure.org")
  // |> set.delete("http://hl7.org/fhir/ValueSet/color-codes")

  let vs_imports =
    string.concat([
      "////[https://hl7.org/fhir/",
      fhir_version,
      "](https://hl7.org/fhir/",
      fhir_version,
      ") valuesets\n\nimport gleam/dynamic/decode.{type Decoder}\nimport gleam/json.{type Json}\nimport gleam/list\nimport gleam/string\n",
    ])
  //   let all_vs_or_cs = case preloaded_valuesets {
  //     Some(valuesets) -> valuesets
  //     None -> {
  //       let simplifier_package_version =
  //         simplifier_core_package_version(fhir_version)
  //       let package_dir = case profiles_dir {
  //         None ->
  //           download_dir
  //           |> filepath.join("profile_package")
  //           |> filepath.join("hl7.fhir." <> fhir_version <> ".core")
  //           |> filepath.join(simplifier_package_version)
  //           |> filepath.join("package")
  //         Some(profile_package_dir) -> profile_package_dir
  //       }
  //       codegen_helpers.load_valuesets(package_dir, vs_url_set)
  //     }
  //   }
  let vs_url_sorted =
    set.to_list(vs_url_set)
    |> list.sort(fn(a, b) {
      string.compare(
        string.lowercase(codegen_helpers.concept_name_from_url(a)),
        string.lowercase(codegen_helpers.concept_name_from_url(b)),
      )
    })
  let #(source, replacements, has_decoder) =
    list.fold(
      from: #("", [], False),
      over: vs_url_sorted,
      with: fn(acc, vs_url) {
        let #(valuesets_acc, failure_variant_replacements, has_decoder) = acc
        let vsname = codegen_helpers.concept_name_from_url(vs_url)
        let assert Ok(valueset_item) = dict.get(valueset_acc, vs_url)
        let #(valueset_source, replacements, valueset_has_decoder) =
          valueset_type_source(
            vs_url,
            vsname,
            all_vs_or_cs,
            valueset_item.needs_system,
            valueset_item.needs_code,
            valueset_item.needs_membership,
          )
        #(
          valuesets_acc <> valueset_source,
          list.append(replacements, failure_variant_replacements),
          has_decoder || valueset_has_decoder,
        )
      },
    )
  let not_included_failure = case has_decoder {
    False -> ""
    True ->
      "fn not_included_failure(
        variant: String,
        placeholder: a,
        name: String,
        values: List(a),
        to_code: fn(a) -> String,
      ) -> Decoder(a) {
        let expected =
          \"code from valueset \" <> name <> \" [\"
            <> { values |> list.map(to_code) |> string.join(\", \") }
            <> \"]\"

        decode.failure(placeholder, expected)
        |> decode.map_errors(fn(_) {
          [decode.DecodeError(expected:, found: variant, path: [])]
        })
      }\n"
  }
  #(vs_imports <> not_included_failure <> source, replacements)
}

fn gen_valueset_encoder(vsname: String) -> String {
  let vsname_lower = vsname |> string.lowercase()
  let template =
    "pub fn CNAMELOWER_to_json(CNAMELOWER: CNAMECAPITAL) -> Json {
    json.string(CNAMELOWER_to_code(CNAMELOWER))
  }
  "
  template
  |> string.replace("CNAMELOWER", vsname_lower)
  |> string.replace("CNAMECAPITAL", vsname |> string.capitalise())
}

//  <> list.fold(open_variants, "", fn(acc, open_variant) {
//       let codegen_bound_coding.OpenValuesetVariant(name:, ..) = open_variant
//       acc <> name <> "(value) -> value\n"
//     })
fn gen_valueset_to_code(
  vsname: String,
  vs_codes: List(codegen_bound_coding.ValuesetCodeWithSystem),
) -> String {
  let vsname_lower = vsname |> string.lowercase()
  let template =
    "pub fn "
    <> vsname_lower
    <> "_to_code("
    <> vsname_lower
    <> ": "
    <> vsname
    <> ") -> String {\n    case "
    <> vsname_lower
    <> " {"
    <> list.fold(
      from: "",
      over: vs_codes,
      with: fn(acc: String, member: codegen_bound_coding.ValuesetCodeWithSystem) {
        let codegen_bound_coding.ValuesetCodeWithSystem(code:, variant:, ..) =
          member
        acc
        <> vsname
        <> variant
        <> " -> "
        <> json.to_string(json.string(code))
        <> "\n"
      },
    )
    <> "}
  }
  "
  template
}

fn gen_valueset_decoder(
  vsname: String,
  vs_codes: List(codegen_bound_coding.ValuesetCodeWithSystem),
) -> String {
  let vsname_lower = vsname |> string.lowercase()
  let fallback = case vs_codes {
    [codegen_bound_coding.ValuesetCodeWithSystem(variant:, ..), ..] ->
      "not_included_failure(variant, "
      <> vsname
      <> variant
      <> ", "
      <> json.to_string(json.string(vsname))
      <> ", "
      <> vsname_lower
      <> ", "
      <> vsname_lower
      <> "_to_code)"
    [] -> panic as { "ValueSet " <> vsname <> " has no codes" }
  }
  let template =
    "pub fn " <> vsname_lower <> "_decoder() -> Decoder(" <> vsname <> ") {
    use variant <- decode.then(decode.string)
    case " <> vsname_lower <> "_from_code(variant) {
      Ok(code) -> decode.success(code)
      Error(_) -> " <> fallback <> "
    }
  }
  "
  template
}

fn gen_valueset_from_code(
  vsname: String,
  vs_codes: List(codegen_bound_coding.ValuesetCodeWithSystem),
) -> String {
  let vsname_lower = vsname |> string.lowercase()
  //   let fallback = case open_variants {
  //     [codegen_bound_coding.OpenValuesetVariant(name:, ..), ..] ->
  //       "Ok(" <> name <> "(code))"
  //     [] -> "Error(Nil)"
  //   }
  let template =
    "pub fn "
    <> vsname_lower
    <> "_from_code(code: String) -> Result("
    <> vsname
    <> ", Nil) {
    case code {"
    <> list.fold(
      from: "",
      over: vs_codes,
      with: fn(acc: String, member: codegen_bound_coding.ValuesetCodeWithSystem) {
        let codegen_bound_coding.ValuesetCodeWithSystem(code:, variant:, ..) =
          member
        acc
        <> json.to_string(json.string(code))
        <> " -> Ok("
        <> vsname
        <> variant
        <> ")\n"
      },
    )
    <> "_ -> Error(Nil)}
  }
  "
  template
}
