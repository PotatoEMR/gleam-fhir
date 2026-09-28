import argv
import codegen_bound_coding
import codegen_client
import codegen_decode
import codegen_helpers
import codegen_profile
import codegen_to_json
import download_profile_package
import fhir/r4_gen/resources as r4
import fhir/template_primitive_types
import filepath
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
  let gen_specific_resources = case
    list.find(args_lower, fn(arg) {
      string.starts_with(arg, "structuredefinitions=")
    })
  {
    Ok(arg) -> {
      let assert [_, resources] = string.split(arg, "=")
      Some(
        resources
        |> string.split(",")
        |> list.map(string.lowercase)
        // always need these resources for the client stuff
        |> list.prepend("bundle")
        |> list.prepend("parameters")
        |> list.prepend("operationoutcome"),
      )
    }
    Error(_) -> None
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
  let f_primitive_types = filepath.join(gen_dir, "primitive_types.gleam")
  let assert Ok(_) =
    simplifile.write(
      to: f_primitive_types,
      contents: template_primitive_types.source,
    )
  io.println("generated " <> f_primitive_types)
  let gen_gleamfile = filepath.join(gen_dir, "resources.gleam")
  let gen_vsfile = filepath.join(gen_dir, "valuesets.gleam")
  let shared_imports = "import gleam/json.{type Json}
      import gleam/dynamic/decode.{type Decoder}
      import gleam/option.{type Option, None, Some}
      import gleam/list
      import fhir/" <> pkg_prefix <> "/primitive_types.{type Date, type DateTime, type Instant, type Time} as pt
      import fhir/" <> pkg_prefix <> "/valuesets\n"
  let r_imports = shared_imports <> "import gleam/bool\nimport gleam/int\n"

  let complex_types_file = filepath.join(extract_dir_ver, "profiles-types.json")
  let #(resources_gen, valueset_acc, resource_type_names, core_resource_entries) =
    file_to_types(
      spec_file: filepath.join(extract_dir_ver, "profiles-resources.json"),
      fv: pkg_prefix,
      current_bucket: codegen_helpers.Resources,
      valueset_acc: dict.new(),
      gen_specific_resources:,
      gen_specific_complex_types: None,
    )
  let profile_type_names = case profiles_dir {
    Some(profiles_dir) ->
      codegen_profile.required_complex_type_names(
        profiles_dir,
        gen_specific_resources,
      )
    None -> set.new()
  }
  let gen_specific_complex_types = case gen_specific_resources {
    Some(_) ->
      resource_type_names
      |> set.union(profile_type_names)
      |> required_complex_types(complex_types_file, _)
      |> Some
    None -> None
  }
  let #(complex_types_gen, valueset_acc, _, _) =
    file_to_types(
      spec_file: complex_types_file,
      fv: pkg_prefix,
      current_bucket: codegen_helpers.ComplexTypes,
      valueset_acc:,
      gen_specific_resources:,
      gen_specific_complex_types:,
    )
  let #(
    profile_complex_types,
    profile_resources,
    valueset_acc,
    preloaded_valuesets,
    profile_resource_entries,
  ) = case custom_profile_name {
    None -> #("", "", valueset_acc, None, [])
    Some(_) -> {
      let assert Some(profiles_dir) = profiles_dir
      let #(
        complex_types,
        resources,
        valuesets,
        loaded_valuesets,
        resource_entries,
      ) =
        codegen_profile.profile_files_to_types(
          profiles_dir,
          preserve_slice_order,
          valueset_acc,
          gen_specific_resources,
        )
      #(
        complex_types,
        resources,
        valuesets,
        Some(loaded_valuesets),
        resource_entries,
      )
    }
  }
  let complex_types_gen = complex_types_gen <> profile_complex_types
  let resource_entries =
    list.append(core_resource_entries, profile_resource_entries)
  let resource_names =
    resource_entries
    |> list.map(fn(resource_entry) {
      let gleam_type = resource_entry.1
      "Resource" <> gleam_type <> "(" <> gleam_type <> ")\n"
    })
    |> string.concat
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
        let ct.List1(first_profile_decoder, rest_profile_decoders) = profile_decoders
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
          [first_profile_decoder, ..rest_profile_decoders],
          fn(profile_decoder) {
            let #(profile_name, _decoder) = profile_decoder
            list.any(found_profiles, fn(found_profile) {
              found_profile |> string.starts_with(profile_name)
            })
          },
        ) {
          Ok(#(_profile_name, decoder)) -> decoder
          Error(Nil) -> {
            let #(_profile_name, first_decoder) = first_profile_decoder
            decode.one_of(
              first_decoder,
              list.map(rest_profile_decoders, fn(profile_decoder) {
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
            decode.failure(
              ResourceParameters(parameters_new()),
              expected: \"\",
            )
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
  let r_imports =
    r_imports
    <> case uses_profile_match {
      True -> "import gleam/string\n"
      False -> ""
    }
  let #(all_vs, unavailable_valuesets, failure_variant_replacements) =
    valueset_to_types(
      fhir_version,
      valueset_acc,
      profiles_dir,
      preloaded_valuesets,
    )
  let replace_failure_variants = fn(source) {
    list.fold(failure_variant_replacements, source, fn(source, replacement) {
      string.replace(source, replacement.0, replacement.1)
    })
  }
  let complex_types_gen =
    replace_unavailable_bindings(complex_types_gen, unavailable_valuesets)
    |> replace_failure_variants
  let resources_gen =
    replace_unavailable_bindings(resources_gen, unavailable_valuesets)
    |> replace_failure_variants
  let bound_codeable_reference_source = case
    string.contains(resources_gen, "ct.BoundCodeablereference(valuesets.")
  {
    True -> codegen_bound_coding.bound_codeable_reference
    False -> ""
  }
  let generated_types_and_resources = complex_types_gen <> resources_gen
  let uses_slice_elt =
    string.contains(resources_gen, "ct.SliceElt(")
    || string.contains(complex_types_gen, "SliceElt(")
  let ct_imports =
    shared_imports
    <> "import gleam/int\n"
    <> case string.contains(complex_types_gen, "result.") {
      True -> "import gleam/result\n"
      False -> ""
    }
    <> case string.contains(complex_types_gen, "bool.") {
      True -> "import gleam/bool\n"
      False -> ""
    }
    <> case uses_slice_elt {
      True -> "import gleam/order\n"
      False -> ""
    }
  let slice_elt_type = case uses_slice_elt {
    True ->
      "
      pub type SliceElt(a) {
        SliceElt(value: a, internal_gleam_fhir_index: Option(Int))
      }

      pub fn slice_elt_new(value: a) -> SliceElt(a) {
        SliceElt(value:, internal_gleam_fhir_index: None)
      }

      pub fn slice_elts_to_values(slice_elts: List(SliceElt(a))) -> List(a) {
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
    False -> ""
  }
  let uses_list1 = string.contains(generated_types_and_resources, "List1(")
  let uses_list2 = string.contains(generated_types_and_resources, "List2(")
  let uses_list3 = string.contains(generated_types_and_resources, "List3(")
  let list_type_defs =
    case uses_list1 {
      True ->
        "
      /// 1..*
      pub type List1(a){ List1(first: a, rest: List(a)) }
      "
      False -> ""
    }
    <> case uses_list2 {
      True ->
        "
      /// 2..*
      pub type List2(a){ List2(first: a, second: a, rest: List(a)) }
      "
      False -> ""
    }
    <> case uses_list3 {
      True ->
        "
      /// 3..*
      pub type List3(a){ List3(first: a, second: a, third: a, rest: List(a)) }
      "
      False -> ""
    }

  let list_helpers =
    case uses_list1 {
      True ->
        "
      pub fn list1_to_json(l: List1(a), tj: fn(a) -> Json) {
        let List1(first:, rest:) = l
        json.array([first, ..rest], tj)
      }

      pub fn list1_decoder(
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
      False -> ""
    }
    <> case uses_list2 {
      True ->
        "
      pub fn list2_to_json(l: List2(a), tj: fn(a) -> Json) {
        let List2(first:, second:, rest:) = l
        json.array([first, second, ..rest], tj)
      }

      pub fn list2_decoder(
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
      False -> ""
    }
    <> case uses_list3 {
      True ->
        "
      pub fn list3_to_json(l: List3(a), tj: fn(a) -> Json) {
        let List3(first:, second:, third:, rest:) = l
        json.array([first, second, third, ..rest], tj)
      }

      pub fn list3_decoder(
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
      False -> ""
    }

  let helpers_block =
    "
      //std lib decode.optional supports myfield: null but what if myfield is omitted from json entirely?
      pub fn none_if_omitted(d: decode.Decoder(a)) -> decode.Decoder(Option(a)) {
        decode.one_of(d |> decode.map(Some), [decode.success(None)])
      }

      //std lib decode.float will NOT decode numbers without decimal point eg 4, only 4.0
      pub fn decode_number() {
        decode.one_of(decode.float, [decode.map(decode.int, int.to_float)])
      }

      pub type Primitive(a) {
        Primitive(id: Option(String), ext: List(Extension), value: Option(a))
      }

      pub type PrimitiveExtPart {
        PrimitiveExtPart(id: Option(String), ext: List(Extension))
      }

      pub fn primitive_ext_part_to_json(p: Primitive(_)) {
        let Primitive(id, ext, _) = p
        let fields = []
        let fields = case id {
          Some(v) -> [#(\"id\", json.string(v)), ..fields]
          None -> fields
        }
        let fields = case ext {
          [] -> fields
          _ -> [#(\"extension\", json.array(ext, extension_to_json)), ..fields]
        }
        json.object(fields)
      }

      pub fn primitive_to_json(old_fields: List(#(String, Json)), primitive: Primitive(a), field_to_json: fn(a) -> Json, name: String){
        let old_fields = case primitive.id, primitive.ext {
            None, [] -> old_fields
            _, _ -> [#(\"_\" <> name, primitive_ext_part_to_json(primitive)), ..old_fields]
        }
        case primitive.value {
            None -> old_fields
            Some(v) -> [#(name, field_to_json(v)), ..old_fields]
        }
      }

      pub fn primitives_to_json(old_fields: List(#(String, Json)), field: List(Primitive(a)), field_to_json: fn(a) -> Json, name: String){
          let vals = list.map(field, fn(primitive){
              json.nullable(primitive.value, field_to_json)
          })
          let exts = list.map(field, fn(primitive){
              case primitive.id, primitive.ext {
                  None, [] -> json.null()
                  _, _ -> primitive_ext_part_to_json(primitive)
              }
          })
          let old_fields = case list.any(vals, fn(j){j != json.null()}){
              False -> old_fields
              True -> [#(name, json.preprocessed_array(vals)), ..old_fields]
          }
          case list.any(exts, fn(j){j != json.null()}){
              False -> old_fields
              True -> [#(\"_\" <> name, json.preprocessed_array(exts)), ..old_fields]
          }
      }

      pub fn primitive_slice_to_json(
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

      pub fn primitive_slice_list_to_json(
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

      pub fn primitive_ext_part_decoder() {
        use ext <- decode.optional_field(
          \"extension\",
          [],
          decode.list(extension_decoder()),
        )
        use id <- decode.optional_field(\"id\", None, decode.optional(decode.string))
        decode.success(PrimitiveExtPart(ext:, id:))
      }

      pub fn primitive_decoder(name: String, thing_decoder: Decoder(a), next: fn(Primitive(a)) -> Decoder(b)) -> Decoder(b){
          use value <- decode.optional_field(name, None, decode.optional(thing_decoder))
          use pwe <- decode.optional_field(\"_\" <> name, None, decode.optional(primitive_ext_part_decoder()))
          let #(id, ext) = case pwe {
            None -> #(None, [])
            Some(PrimitiveExtPart(id, ext)) -> #(id, ext)
          }
          let together = Primitive(id:, ext:, value:,)
          next(together)
      }

      pub fn primitives_decoder(
        name: String,
        thing_decoder: Decoder(a),
        next: fn(List(Primitive(a))) -> Decoder(b),
      ) -> Decoder(b) {
          use values <- decode.optional_field(name, [], decode.list(decode.optional(thing_decoder)))
          use pwes <- decode.optional_field(\"_\" <> name, [], decode.list(decode.optional(primitive_ext_part_decoder())))
          let together = map2_fillnone(pwes, values, fn(pwe, value){
              let #(id, ext) = case pwe {
                  None -> #(None, [])
                  Some(PrimitiveExtPart(id, ext)) -> #(id, ext)
              }
              Primitive(id:, ext:, value:,)
          })
          next(together)
      }

      pub fn primitive_slice_decoder(
        name: String,
        thing_decoder: Decoder(a),
        convert: fn(Primitive(a)) -> Decoder(b),
        next: fn(b) -> Decoder(c),
      ) -> Decoder(c) {
        use primitive <- primitive_decoder(name, thing_decoder)
        use value <- decode.then(convert(primitive))
        next(value)
      }

      pub fn primitive_choice_slice_decoder(
        name: String,
        thing_decoder: Decoder(a),
        convert: fn(Primitive(a)) -> Decoder(b),
        next: fn(b) -> Decoder(c),
      ) -> Decoder(c) {
        use value_present <- decode.optional_field(
          name,
          False,
          decode.dynamic |> decode.map(fn(_) { True }),
        )
        use extension_present <- decode.optional_field(
          \"_\" <> name,
          False,
          decode.dynamic |> decode.map(fn(_) { True }),
        )
        case value_present || extension_present {
          True -> primitive_slice_decoder(name, thing_decoder, convert, next)
          False -> {
            use _ <- decode.field(name, thing_decoder)
            primitive_slice_decoder(name, thing_decoder, convert, next)
          }
        }
      }

      pub fn primitive_slice_list_decoder(
        name: String,
        thing_decoder: Decoder(a),
        convert: fn(Primitive(a)) -> Decoder(b),
        next: fn(List(b)) -> Decoder(c),
      ) -> Decoder(c) {
        use primitives <- primitives_decoder(name, thing_decoder)
        primitive_slice_list_from_primitives(primitives, convert, next)
      }

      fn primitive_slice_list_from_primitives(
        primitives: List(Primitive(a)),
        convert: fn(Primitive(a)) -> Decoder(b),
        next: fn(List(b)) -> Decoder(c),
      ) -> Decoder(c) {
        case primitives {
          [] -> next([])
          [first, ..rest] -> {
            use first <- decode.then(convert(first))
            use rest <- primitive_slice_list_from_primitives(rest, convert)
            next([first, ..rest])
          }
        }
      }

      pub fn map2_fillnone(list1: List(Option(a)), list2: List(Option(b)), with fun: fn(Option(a), Option(b)) -> c) -> List(c) {
        map2_fillnone_loop(list1, list2, fun, [])
      }

      fn map2_fillnone_loop(
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

  let ct_content =
    string.concat([
      "////[https://hl7.org/fhir/",
      fhir_version,
      "](https://hl7.org/fhir/",
      fhir_version,
      ") complex types\n",
      ct_imports,
      list_type_defs,
      slice_elt_type,
      codegen_bound_coding.bound_coding_and_cc(preserve_slice_order),
      codegen_bound_coding.find_elt_and_rest_result(preserve_slice_order),
      case preserve_slice_order {
        True -> codegen_bound_coding.insert_at
        False -> ""
      },
      bound_codeable_reference_source,
      codegen_bound_coding.bound_quantity,
      complex_types_gen,
      list_helpers,
      helpers_block,
      codegen_decode.array_cardinality_decoders,
    ])
  let resource_complex_imports =
    [
      #("type List1", "List1("),
      #("list1_to_json", "list1_to_json("),
      #("list1_decoder", "list1_decoder("),
      #("type List2", "List2("),
      #("list2_to_json", "list2_to_json("),
      #("list2_decoder", "list2_decoder("),
      #("type List3", "List3("),
      #("list3_to_json", "list3_to_json("),
      #("list3_decoder", "list3_decoder("),
      #("none_if_omitted", "none_if_omitted("),
      #("decode_number", "decode_number("),
      #("type Primitive", "Primitive("),
      #("Primitive", "Primitive(id:"),
      #("primitive_decoder", "primitive_decoder("),
      #("primitives_decoder", "primitives_decoder("),
      #("primitive_choice_slice_decoder", "primitive_choice_slice_decoder("),
      #("primitive_slice_decoder", "primitive_slice_decoder("),
      #("primitive_slice_list_decoder", "primitive_slice_list_decoder("),
      #("primitive_to_json", "primitive_to_json("),
      #("primitives_to_json", "primitives_to_json("),
      #("primitive_slice_to_json", "primitive_slice_to_json("),
      #("primitive_slice_list_to_json", "primitive_slice_list_to_json("),
    ]
    |> list.filter_map(fn(item) {
      case string.contains(resources_gen, item.1) {
        True -> Ok(item.0)
        False -> Error(Nil)
      }
    })
  let result_import = case string.contains(resources_gen, "result.") {
    True -> "import gleam/result\n"
    False -> ""
  }
  let r_ct_import =
    "import fhir/"
    <> pkg_prefix
    <> "/complex_types.{"
    <> string.join(resource_complex_imports, ", ")
    <> "} as ct\n"
  let r_content =
    string.concat([
      "////[https://hl7.org/fhir/",
      fhir_version,
      "](https://hl7.org/fhir/",
      fhir_version,
      ") resources\n",
      r_imports,
      result_import,
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
    )
  list.each(
    [
      #("sansio.gleam", sansio),
      #("client_httpc.gleam", httpc_layer),
      #("client_rsvp.gleam", rsvp_layer),
      #("search_params.gleam", search_params),
    ],
    fn(to_file) {
      let file = filepath.join(gen_dir, to_file.0)
      let assert Ok(_) = simplifile.write(to: file, contents: to_file.1)
      io.println("generated " <> to_file.0)
    },
  )
}

// what we should probably do ideally is generate these fns with ordinary coding/cc in the first place
// rather than bound coding/cc, but idk if when we first generate them we know if a bound valueset will be unavailable
// this string replacement is clearly dumb but if it doesnt work the output wont compile so eh
fn replace_unavailable_bindings(
  source: String,
  unavailable_valuesets: Set(String),
) -> String {
  unavailable_valuesets
  |> set.fold(source, fn(source, url) {
    let type_name = codegen_helpers.concept_name_from_url(url)
    let fn_name =
      url
      |> codegen_helpers.concept_name_from_url
      |> codegen_helpers.to_snake_case
    source
    |> string.replace(
      codegen_bound_coding.bound_codeablereference_encoder_call_source(
        "",
        fn_name,
        "v",
      ),
      "codeablereference_to_json(v)",
    )
    |> string.replace(
      codegen_bound_coding.bound_codeablereference_encoder_call_source(
        "ct.",
        fn_name,
        "v",
      ),
      "ct.codeablereference_to_json(v)",
    )
    |> string.replace(
      codegen_bound_coding.bound_codeableconcept_encoder_call_source(
        "",
        fn_name,
        "v",
      ),
      "codeableconcept_to_json(v)",
    )
    |> string.replace(
      codegen_bound_coding.bound_codeableconcept_encoder_call_source(
        "ct.",
        fn_name,
        "v",
      ),
      "ct.codeableconcept_to_json(v)",
    )
    |> string.replace(
      codegen_bound_coding.bound_coding_encoder_call_source("", fn_name, "v"),
      "coding_to_json(v)",
    )
    |> string.replace(
      codegen_bound_coding.bound_coding_encoder_call_source("ct.", fn_name, "v"),
      "ct.coding_to_json(v)",
    )
    |> string.replace(
      codegen_bound_coding.bound_quantity_encoder_call_source("", fn_name, "v"),
      "quantity_to_json(v)",
    )
    |> string.replace(
      codegen_bound_coding.bound_quantity_encoder_call_source(
        "ct.",
        fn_name,
        "v",
      ),
      "ct.quantity_to_json(v)",
    )
    |> string.replace(
      codegen_bound_coding.bound_codeablereference_encoder_source("", fn_name),
      "codeablereference_to_json",
    )
    |> string.replace(
      codegen_bound_coding.bound_codeablereference_encoder_source(
        "ct.",
        fn_name,
      ),
      "ct.codeablereference_to_json",
    )
    |> string.replace(
      codegen_bound_coding.bound_codeableconcept_encoder_source("", fn_name),
      "codeableconcept_to_json",
    )
    |> string.replace(
      codegen_bound_coding.bound_codeableconcept_encoder_source("ct.", fn_name),
      "ct.codeableconcept_to_json",
    )
    |> string.replace(
      codegen_bound_coding.bound_coding_encoder_source("", fn_name),
      "coding_to_json",
    )
    |> string.replace(
      codegen_bound_coding.bound_coding_encoder_source("ct.", fn_name),
      "ct.coding_to_json",
    )
    |> string.replace(
      codegen_bound_coding.bound_quantity_encoder_source("", fn_name),
      "quantity_to_json",
    )
    |> string.replace(
      codegen_bound_coding.bound_quantity_encoder_source("ct.", fn_name),
      "ct.quantity_to_json",
    )
    |> string.replace(
      codegen_bound_coding.bound_codeablereference_decoder_source("", fn_name),
      "codeablereference_decoder()",
    )
    |> string.replace(
      codegen_bound_coding.bound_codeablereference_decoder_source(
        "ct.",
        fn_name,
      ),
      "ct.codeablereference_decoder()",
    )
    |> string.replace(
      codegen_bound_coding.bound_codeableconcept_decoder_source("", fn_name),
      "codeableconcept_decoder()",
    )
    |> string.replace(
      codegen_bound_coding.bound_codeableconcept_decoder_source("ct.", fn_name),
      "ct.codeableconcept_decoder()",
    )
    |> string.replace(
      codegen_bound_coding.bound_coding_decoder_source("", fn_name),
      "coding_decoder()",
    )
    |> string.replace(
      codegen_bound_coding.bound_coding_decoder_source("ct.", fn_name),
      "ct.coding_decoder()",
    )
    |> string.replace(
      codegen_bound_coding.bound_quantity_decoder_source("", fn_name),
      "quantity_decoder()",
    )
    |> string.replace(
      codegen_bound_coding.bound_quantity_decoder_source("ct.", fn_name),
      "ct.quantity_decoder()",
    )
    |> string.replace(
      "ct.bound_coding_from_coding(value, valuesets."
        <> fn_name
        <> "_from_code_and_system) |> result.replace_error(\"required ValueSet\")",
      "Ok(value)",
    )
    |> string.replace(
      "ct.bound_coding_from_coding(value, valuesets."
        <> fn_name
        <> "_from_code_and_system)",
      "Ok(value)",
    )
    |> string.replace(
      "ct.bound_codeableconcept_from_codeableconcept(value, valuesets."
        <> fn_name
        <> "_from_code_and_system) |> result.replace_error(\"required ValueSet\")",
      "Ok(value)",
    )
    |> string.replace(
      "ct.bound_codeableconcept_from_codeableconcept(value, valuesets."
        <> fn_name
        <> "_from_code_and_system)",
      "Ok(value)",
    )
    |> string.replace(
      "ct.bound_quantity_from_quantity(value, valuesets."
        <> fn_name
        <> "_from_code_and_system) |> result.replace_error(\"required ValueSet\")",
      "Ok(value)",
    )
    |> string.replace(
      "ct.bound_quantity_from_quantity(value, valuesets."
        <> fn_name
        <> "_from_code_and_system)",
      "Ok(value)",
    )
    |> string.replace(
      "valuesets."
        <> fn_name
        <> "_from_code(value) |> result.replace_error(\"required ValueSet\")",
      "Ok(value)",
    )
    |> string.replace(
      "BoundCodeablereference(valuesets." <> type_name <> ")",
      "Codeablereference",
    )
    |> string.replace(
      "BoundCodeableconcept(valuesets." <> type_name <> ")",
      "Codeableconcept",
    )
    |> string.replace("BoundCoding(valuesets." <> type_name <> ")", "Coding")
    |> string.replace(
      "BoundQuantity(valuesets." <> type_name <> ")",
      "Quantity",
    )
    |> string.replace("valuesets." <> type_name, "String")
    |> string.replace("valuesets." <> fn_name <> "_to_json", "json.string")
    |> string.replace("valuesets." <> fn_name <> "_decoder()", "decode.string")
  })
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
) -> #(
  String,
  dict.Dict(String, codegen_helpers.ValuesetItem),
  Set(String),
  List(#(String, String, String)),
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
  let referenced_type_names =
    entries
    |> list.flat_map(fn(resource) {
      case resource.snapshot {
        Some(snapshot) -> snapshot.element
        None -> []
      }
    })
    |> list.flat_map(fn(element) {
      element.type_ |> list.map(fn(type_) { type_.code })
    })
    |> set.from_list

  let #(all_resources_and_types, valueset_acc) =
    list.fold(
      entries,
      #("", valueset_acc),
      fn(acc, resource: codegen_helpers.Resource) {
        let #(elt_str_acc, valueset_acc) = acc
        //map of type -> fields needed to list out all the BackboneElements
        //because they're subcomponents eg Allergy -> Reaction
        //and rather than nested, we want to write fields one after the other
        let starting_res_fields = dict.new() |> dict.insert(resource.name, [])
        //we want to write types in order of parsing backbone elements, but map order random
        //put elts into name of current struct, eg AllergyIntolerance, AllergyIntoleranceReaction...
        let type_order = [resource.name]
        let assert Some(snapshot) = resource.snapshot

        let f_o = #(starting_res_fields, type_order)

        let #(resource_types, valueset_acc) = {
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
            from: #("", valueset_acc),
            with: fn(acc, new_type) {
              let #(old_type_acc, valueset_acc) = acc
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
                encoder_args,
                encoder_json_always,
                encoder_json_options,
                decoder_use,
                decoder_success,
                decoder_always_failure_fordr,
                valueset_acc,
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
                    "",
                    valueset_acc,
                  ),
                  over: fields,
                  with: fn(acc, elt: codegen_helpers.Element) {
                    //this should clearly be custom type not tuple
                    let fields_acc = acc.0
                    let choicetypes_acc = acc.1
                    let newfunc_args_acc = acc.2
                    let newfunc_fields_acc = acc.3
                    let encoder_args_acc = acc.4
                    let encoder_always_acc = acc.5
                    let encoder_optional_acc = acc.6
                    let decoder_use_acc = acc.7
                    let decoder_success_acc = acc.8
                    let decoder_always_failure_acc = acc.9
                    let valueset_acc = acc.10
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
                    let #(choicetypes_acc, valueset_acc) = case elt.type_ {
                      [] -> #(choicetypes_acc, valueset_acc)
                      [_] -> #(choicetypes_acc, valueset_acc)
                      _ -> {
                        let #(choice_fields, valueset_acc) =
                          list.fold(
                            over: elt.type_,
                            from: #("", valueset_acc),
                            with: fn(acc, typ) {
                              let #(fields_acc, valueset_acc) = acc
                              let #(choice_type, valueset_acc) =
                                codegen_helpers.string_to_type(
                                  typ.code,
                                  [
                                    "somehow this is used in [x] for any type (int, bool, code, etc) and ofc that code has no defined binding",
                                  ],
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
                        )
                      }
                    }
                    let #(newfunc_arg, newfunc_field) =
                      codegen_helpers.new_fn_arg_and_field(
                        elt_snake,
                        field_type,
                        elt.min,
                        elt.max,
                        is_primitive,
                      )
                    //all the fields for encoder to convert to json
                    let encoder_args_acc = encoder_args_acc <> elt_snake <> ":,"
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
                    let #(
                      encoder_optional_acc,
                      encoder_always_acc,
                      decoder_always_failure_acc,
                    ) = case elt.min, elt.max {
                      0, "*" -> {
                        //0..* list: omit from json if empty
                        let opts =
                          encoder_optional_acc
                          <> "\nlet fields = case "
                          <> elt_snake
                          <> " {
                        [] -> fields
                        _ -> [#(\""
                          <> elt_last_part_withgleamtype
                          <> "\", json.array("
                          <> elt_snake
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
                          <> elt_snake
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
                          <> elt_snake
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
                          <> elt_snake
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
                          <> elt_snake
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
                            elt_snake,
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
                          <> field_type_encoder_call(elt_snake)
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
                      encoder_args_acc,
                      encoder_always_acc,
                      encoder_optional_acc,
                      decoder_use_acc,
                      decoder_success_acc,
                      decoder_always_failure_acc,
                      valueset_acc,
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
                  "(",
                  newfunc_fields,
                  ")\n}",
                ])
              let type_choicetypes = string.join(choicetypes, "\n")
              let is_domainresource = case resource.kind {
                Some("complex-type") -> False
                Some("resource") -> resource.name == new_type
                _ -> panic as "????"
              }
              let assert Some(fhir_resource_type) = resource.type_

              case camel_type {
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
                let Extension(id:, url:, ext:) = extension
                let fields = [#(\"url\", json.string(url))]
                let fields = case id {
                  Some(v) -> [#(\"id\", json.string(v)), ..fields]
                  None -> fields
                }
                let fields = [ext_simple_or_complex_to_json(ext), ..fields]
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
                          encoder_args,
                          encoder_json_always,
                          encoder_json_options,
                          is_domainresource,
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
            },
          )
        }
        let gen_str = elt_str_acc <> "\n" <> resource_types
        #(gen_str, valueset_acc)
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
  exclude_not_selectable: Bool,
  needs_system: Bool,
) {
  case dict.get(all_vs_or_cs, vs_url) {
    Ok(codegen_helpers.VocValueset(valueset)) ->
      case valueset.compose {
        Some(compose) ->
          valueset_compose_type_source(
            compose,
            vs_url,
            vsname,
            all_vs_or_cs,
            exclude_not_selectable,
            needs_system,
          )
        None -> panic as { "ValueSet " <> vs_url <> " has no compose" }
      }
    Ok(codegen_helpers.VocCodesystem(_)) ->
      panic as { vs_url <> " resolved to a CodeSystem instead of a ValueSet" }
    Error(_) -> panic as { "Could not load ValueSet " <> vs_url }
  }
}

fn valueset_compose_type_source(
  compose: r4.ValuesetCompose,
  vs_url: String,
  vsname: String,
  all_vs_or_cs: dict.Dict(String, codegen_helpers.VsOrCs),
  exclude_not_selectable: Bool,
  needs_system: Bool,
) {
  let includes = [compose.include.first, ..compose.include.rest]
  let #(codes, open_variants, systems, _) =
    list.fold(includes, #([], [], set.new(), 1), fn(acc, include) {
      let #(codes, open_variants, systems, index) = acc
      case
        codegen_bound_coding.valueset_include_codes(
          include,
          all_vs_or_cs,
          exclude_not_selectable,
        )
      {
        codegen_bound_coding.ValuesetIncludeExpanded(include_codes) -> #(
          list.fold(include_codes, codes, fn(codes, code) { [code, ..codes] }),
          open_variants,
          include_codes
            |> list.fold(systems, fn(systems, member) {
              let codegen_bound_coding.ValuesetCodeWithSystem(system:, ..) =
                member
              set.insert(systems, system)
            }),
          index + 1,
        )
        codegen_bound_coding.ValuesetIncludeString(system) -> {
          let variant_name =
            vsname <> codegen_bound_coding.valueset_include_name(include, index)
          #(
            codes,
            [
              codegen_bound_coding.OpenValuesetVariant(
                name: variant_name,
                system:,
              ),
              ..open_variants
            ],
            set.insert(systems, system),
            index + 1,
          )
        }
      }
    })
  let codes = list.reverse(codes)
  let open_variants = case needs_system, open_variants {
    False, [_, _, ..] -> [
      codegen_bound_coding.OpenValuesetVariant(
        name: vsname <> "Other",
        system: "",
      ),
    ]
    _, _ -> open_variants
  }
  let #(_, duplicate_codes) =
    list.fold(codes, #(set.new(), set.new()), fn(acc, member) {
      let #(seen_codes, duplicate_codes) = acc
      let codegen_bound_coding.ValuesetCodeWithSystem(code:, ..) = member
      case set.contains(seen_codes, code) {
        True -> #(seen_codes, set.insert(duplicate_codes, code))
        False -> #(set.insert(seen_codes, code), duplicate_codes)
      }
    })
  let assert Ok(vs_url_name) = vs_url |> string.split("/") |> list.last
  let assert Ok(vs_namespace) = vs_url_name |> string.split("-") |> list.first
  let vs_namespace =
    vs_namespace |> codegen_helpers.codetovarname |> string.capitalise
  let codes =
    list.map(codes, fn(member) {
      let codegen_bound_coding.ValuesetCodeWithSystem(code:, system:, ..) =
        member
      let code_name = code |> codegen_helpers.codetovarname |> string.capitalise
      let variant = case set.contains(duplicate_codes, code) {
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
  let variants =
    codes
    |> list.map(fn(member) {
      let codegen_bound_coding.ValuesetCodeWithSystem(variant:, ..) = member
      vsname <> variant <> "\n"
    })
    |> string.concat
    |> string.append(
      list.fold(open_variants, "", fn(acc, open_variant) {
        let codegen_bound_coding.OpenValuesetVariant(name:, ..) = open_variant
        acc <> name <> "(value: String)\n"
      }),
    )
  let code_functions = case needs_system, open_variants, codes {
    True, _, _ ->
      string.concat([
        gen_valueset_encoder(vsname),
        gen_valueset_to_code(vsname, codes, open_variants),
        codegen_bound_coding.gen_valueset_from_code_and_system(
          vsname,
          codes,
          open_variants,
        ),
        case open_variants, codes, set.is_empty(duplicate_codes) {
          [], [_, ..], True -> gen_valueset_decoder(vsname, codes, [])
          _, _, _ -> ""
        },
      ])
    False, _, _ ->
      string.concat([
        gen_valueset_encoder(vsname),
        gen_valueset_to_code(vsname, codes, open_variants),
        gen_valueset_from_code(vsname, codes, open_variants),
        gen_valueset_decoder(vsname, codes, open_variants),
      ])
  }
  let system_function = case needs_system {
    True ->
      codegen_bound_coding.gen_valueset_system(
        vsname,
        codes,
        open_variants,
        systems,
      )
    False -> ""
  }
  let failure_variant_replacements = case needs_system {
    True -> [
      #(
        "valuesets." <> string.lowercase(vsname) <> "_failure_variant",
        "valuesets."
          <> codegen_bound_coding.valueset_failure_variant_source(
          vsname,
          codes,
          open_variants,
        ),
      ),
    ]
    False -> []
  }
  #(
    "pub type "
      <> vsname
      <> "{"
      <> variants
      <> "}\n"
      <> code_functions
      <> system_function,
    failure_variant_replacements,
  )
}

fn valueset_to_types(
  fhir_version: String,
  valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
  profiles_dir: Option(String),
  preloaded_valuesets: Option(dict.Dict(String, codegen_helpers.VsOrCs)),
) {
  // the valueset urls needed by elements by required bindings
  // and if they are for a code or for coding/cc
  // because if latter
  let vs_url_set =
    valueset_acc
    |> dict.keys
    |> set.from_list
    |> set.delete("")
    |> set.delete("http://unitsofmeasure.org")
    |> set.delete("http://hl7.org/fhir/ValueSet/color-codes")

  let vs_imports =
    string.concat([
      "////[https://hl7.org/fhir/",
      fhir_version,
      "](https://hl7.org/fhir/",
      fhir_version,
      ") valuesets\n\nimport gleam/dynamic/decode.{type Decoder}\n  import gleam/json.{type Json}\n",
    ])
  let all_vs_or_cs = case preloaded_valuesets {
    Some(valuesets) -> valuesets
    None -> {
      let simplifier_package_version =
        simplifier_core_package_version(fhir_version)
      let package_dir = case profiles_dir {
        None ->
          download_dir
          |> filepath.join("profile_package")
          |> filepath.join("hl7.fhir." <> fhir_version <> ".core")
          |> filepath.join(simplifier_package_version)
          |> filepath.join("package")
        Some(profile_package_dir) -> profile_package_dir
      }
      codegen_helpers.load_valuesets(package_dir, vs_url_set)
    }
  }
  let vs_url_sorted =
    set.to_list(vs_url_set)
    |> list.sort(fn(a, b) {
      string.compare(
        string.lowercase(codegen_helpers.concept_name_from_url(a)),
        string.lowercase(codegen_helpers.concept_name_from_url(b)),
      )
    })
  list.fold(
    from: #(vs_imports, set.new(), []),
    over: vs_url_sorted,
    with: fn(acc, vs_url) {
      let #(valuesets_acc, unavailable_valuesets, failure_variant_replacements) =
        acc
      let vsname = codegen_helpers.concept_name_from_url(vs_url)
      let assert Ok(valueset_item) = dict.get(valueset_acc, vs_url)
      let needs_system = case valueset_item {
        codegen_helpers.ValuesetBoundCodingOrCcNeedsSystem -> True
        codegen_helpers.ValuesetCodeOnlyDontNeedSystem -> False
      }
      case codegen_helpers.valueset_can_generate_system(vs_url, all_vs_or_cs) {
        True -> {
          let #(valueset_source, replacements) =
            valueset_type_source(
              vs_url,
              vsname,
              all_vs_or_cs,
              fhir_version == "r4",
              needs_system,
            )
          #(
            valuesets_acc <> valueset_source,
            unavailable_valuesets,
            list.append(replacements, failure_variant_replacements),
          )
        }
        False -> {
          io.println("unable to expand valueset " <> vs_url)
          #(
            valuesets_acc,
            set.insert(unavailable_valuesets, vs_url),
            failure_variant_replacements,
          )
        }
      }
    },
  )
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

fn gen_valueset_to_code(
  vsname: String,
  vs_codes: List(codegen_bound_coding.ValuesetCodeWithSystem),
  open_variants: List(codegen_bound_coding.OpenValuesetVariant),
) -> String {
  let vsname_lower = vsname |> string.lowercase()
  let template =
    "pub fn CNAMELOWER_to_code(CNAMELOWER: CNAMECAPITAL) -> String {
    case CNAMELOWER {" <> list.fold(
      from: "",
      over: vs_codes,
      with: fn(acc: String, member: codegen_bound_coding.ValuesetCodeWithSystem) {
        let codegen_bound_coding.ValuesetCodeWithSystem(code:, variant:, ..) =
          member
        acc
        <> "CODETYPE -> \"ACTUALCODE\"\n"
        |> string.replace("CODETYPE", vsname <> variant)
        |> string.replace("ACTUALCODE", code)
      },
    ) <> list.fold(open_variants, "", fn(acc, open_variant) {
      let codegen_bound_coding.OpenValuesetVariant(name:, ..) = open_variant
      acc <> name <> "(value) -> value\n"
    }) <> "}
  }
  "
  template
  |> string.replace("CNAMELOWER", vsname_lower)
  |> string.replace("CNAMECAPITAL", vsname |> string.capitalise())
}

fn gen_valueset_decoder(
  vsname: String,
  vs_codes: List(codegen_bound_coding.ValuesetCodeWithSystem),
  open_variants: List(codegen_bound_coding.OpenValuesetVariant),
) -> String {
  let vsname_lower = vsname |> string.lowercase()
  let fallback = case open_variants, vs_codes {
    [codegen_bound_coding.OpenValuesetVariant(name:, ..), ..], _ ->
      "decode.success(" <> name <> "(variant))"
    [], [codegen_bound_coding.ValuesetCodeWithSystem(variant:, ..), ..] ->
      "decode.failure(" <> vsname <> variant <> ", \"CNAMECAPITAL\")"
    [], [] -> panic as { "ValueSet " <> vsname <> " has no codes" }
  }
  let template = "pub fn CNAMELOWER_decoder() -> Decoder(CNAMECAPITAL) {
    use variant <- decode.then(decode.string)
    case variant {" <> list.fold(
      from: "",
      over: vs_codes,
      with: fn(acc: String, member: codegen_bound_coding.ValuesetCodeWithSystem) {
        let codegen_bound_coding.ValuesetCodeWithSystem(code:, variant:, ..) =
          member
        acc
        <> "\"ACTUALCODE\" -> decode.success(CODETYPE)\n"
        |> string.replace("CODETYPE", vsname <> variant)
        |> string.replace("ACTUALCODE", code)
      },
    ) <> "_ -> " <> fallback <> "}
  }
  "
  template
  |> string.replace("CNAMELOWER", vsname_lower)
  |> string.replace("CNAMECAPITAL", vsname |> string.capitalise())
}

fn gen_valueset_from_code(
  vsname: String,
  vs_codes: List(codegen_bound_coding.ValuesetCodeWithSystem),
  open_variants: List(codegen_bound_coding.OpenValuesetVariant),
) -> String {
  let vsname_lower = vsname |> string.lowercase()
  let fallback = case open_variants {
    [codegen_bound_coding.OpenValuesetVariant(name:, ..), ..] ->
      "Ok(" <> name <> "(code))"
    [] -> "Error(Nil)"
  }
  let template =
    "pub fn CNAMELOWER_from_code(code: String) -> Result(CNAMECAPITAL, Nil) {
    case code {" <> list.fold(
      from: "",
      over: vs_codes,
      with: fn(acc: String, member: codegen_bound_coding.ValuesetCodeWithSystem) {
        let codegen_bound_coding.ValuesetCodeWithSystem(code:, variant:, ..) =
          member
        acc
        <> "\"ACTUALCODE\" -> Ok(CODETYPE)\n"
        |> string.replace("CODETYPE", vsname <> variant)
        |> string.replace("ACTUALCODE", code)
      },
    ) <> "_ -> " <> fallback <> "}
  }
  "
  template
  |> string.replace("CNAMELOWER", vsname_lower)
  |> string.replace("CNAMECAPITAL", vsname |> string.capitalise())
}
