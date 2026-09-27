import codegen_bound_coding
import codegen_decode
import codegen_helpers
import codegen_profile_json.{
  type ExtensionDefinition, type SliceFieldType, type SlicePlan,
  BoundCodeableconceptSlice, BoundCodingSlice, ComplexExtension,
  ExtensionDefinition, FixedSliceType, FixedValueDiscriminator, SimpleExtension,
  TypeSlicePlan, ValueSlicePlan, aggregate_slice_constructor,
  aggregate_slice_type_name, aggregate_value_slice_roots,
  does_profile_restrict_complex_type, extension_field_name,
  extension_field_to_json_call, find_element, profile_base_field_type,
  profile_extension_definition, profile_field_has_primitive_type,
  profile_field_is_primitive_slice, profile_field_min,
}
import codegen_slice_complex_type
import codegen_to_json
import filepath
import gleam/dict
import gleam/dynamic/decode
import gleam/int
import gleam/io
import gleam/json
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/set.{type Set}
import gleam/string
import simplifile

type ProfileFiles {
  ProfileFiles(
    resources: List(codegen_helpers.Resource),
    extensions: dict.Dict(String, ExtensionDefinition),
    datatype_profiles: dict.Dict(String, codegen_helpers.Resource),
  )
}

type PackageIndexFile {
  PackageIndexFile(
    filename: String,
    url: Option(String),
    type_: Option(String),
    resource_type: Option(String),
    kind: Option(String),
  )
}

fn package_index_decoder() {
  use files <- decode.field("files", decode.list(package_index_file_decoder()))
  decode.success(files)
}

fn package_index_file_decoder() {
  use filename <- decode.field("filename", decode.string)
  use url <- decode.optional_field("url", None, decode.optional(decode.string))
  use type_ <- decode.optional_field(
    "type",
    None,
    decode.optional(decode.string),
  )
  use resource_type <- decode.optional_field(
    "resourceType",
    None,
    decode.optional(decode.string),
  )
  use kind <- decode.optional_field(
    "kind",
    None,
    decode.optional(decode.string),
  )
  decode.success(PackageIndexFile(
    filename:,
    url:,
    type_:,
    resource_type:,
    kind:,
  ))
}

fn canonical_url(url: String) -> String {
  let assert [url, ..] = string.split(url, "|")
  url
}

fn read_structure_definition(path: String) -> codegen_helpers.Resource {
  let assert Ok(contents) = simplifile.read(path)
  let assert Ok(resource) =
    json.parse(contents, codegen_helpers.resource_decoder())
    as "profile structure definitions downloaded"
  resource
}

fn root_profile_resources(profiles_dir: String) {
  let assert Ok(files) = simplifile.read_directory(profiles_dir) as profiles_dir
  files
  |> list.filter(fn(file) {
    let path = filepath.join(profiles_dir, file)
    case simplifile.read(path) {
      Error(_) -> False
      Ok(contents) ->
        case json.parse(contents, decode.dynamic) {
          Error(_) -> False
          Ok(value) ->
            decode.run(
              value,
              decode.field("resourceType", decode.string, fn(value) {
                decode.success(value)
              }),
            )
            == Ok("StructureDefinition")
        }
    }
  })
  |> list.map(fn(file) {
    read_structure_definition(filepath.join(profiles_dir, file))
  })
}

fn referenced_extension_urls(resources: List(codegen_helpers.Resource)) {
  resources
  |> list.flat_map(fn(resource) {
    case resource.snapshot {
      None -> []
      Some(snapshot) ->
        snapshot.element
        |> list.flat_map(fn(element) {
          element.type_
          |> list.flat_map(fn(type_) {
            case type_.code {
              "Extension" -> list.map(type_.profile, canonical_url)
              _ -> []
            }
          })
        })
    }
  })
  |> set.from_list
}

fn base_structure_elements(
  profiles_dir: String,
  profile_elements: List(codegen_helpers.Element),
) -> dict.Dict(String, codegen_helpers.Element) {
  let directories = codegen_helpers.package_directories(profiles_dir)
  profile_elements
  |> list.flat_map(fn(element) {
    let type_roots = list.map(element.type_, fn(type_) { type_.code })
    case element.base.path |> string.split(".") |> list.first {
      Ok(root) -> [root, ..type_roots]
      Error(_) -> type_roots
    }
  })
  |> set.from_list
  |> set.to_list
  |> list.flat_map(fn(root) {
    directories
    |> list.find_map(fn(directory) {
      let path =
        filepath.join(directory, "StructureDefinition-" <> root <> ".json")
      case simplifile.is_file(path) {
        Ok(True) -> {
          let resource = read_structure_definition(path)
          case
            resource.url == "http://hl7.org/fhir/StructureDefinition/" <> root,
            resource.snapshot
          {
            True, Some(snapshot) -> Ok(snapshot.element)
            _, _ -> Error(Nil)
          }
        }
        _ -> Error(Nil)
      }
    })
    |> result.unwrap([])
  })
  |> list.map(fn(element) { #(element.path, element) })
  |> dict.from_list
}

fn extension_fields(resource: codegen_helpers.Resource) {
  let assert Some(snapshot) = resource.snapshot
  let slices =
    snapshot.element
    |> list.filter(fn(element) {
      element.path == "Extension.extension"
      && element.max != "0"
      && element.slice_name != None
    })

  case slices {
    [] ->
      case
        list.find(snapshot.element, fn(element) {
          element.id == "Extension.value[x]" && element.max != "0"
        })
      {
        Ok(value) ->
          case value.type_ {
            [_] -> Some(SimpleExtension(value))
            _ -> Some(ComplexExtension([value], "closed"))
          }
        Error(_) -> None
      }
    _ -> {
      let fields =
        slices
        |> list.filter_map(fn(slice) {
          let assert Some(slice_name) = slice.slice_name
          case
            list.find(snapshot.element, fn(element) {
              element.id == slice.id <> ".value[x]" && element.max != "0"
            })
          {
            Error(_) -> Error(Nil)
            Ok(value) ->
              Ok(
                codegen_helpers.Element(
                  ..value,
                  id: "Extension." <> slice_name,
                  path: "Extension." <> slice_name,
                  min: slice.min,
                  max: slice.max,
                  slice_name: None,
                  slicing: None,
                ),
              )
          }
        })
        |> list.reverse
      let slicing_rules =
        snapshot.element
        |> list.find(fn(element) { element.id == "Extension.extension" })
        |> result.map(fn(element) {
          element.slicing
          |> option.map(fn(slicing) { slicing.rules })
          |> option.unwrap("closed")
        })
        |> result.unwrap("closed")
      Some(ComplexExtension(fields, slicing_rules))
    }
  }
}

fn extension_definitions(
  profiles_dir: String,
  referenced_urls: Set(String),
) -> dict.Dict(String, ExtensionDefinition) {
  codegen_helpers.package_directories(profiles_dir)
  |> list.flat_map(fn(package_dir) {
    let index_path = filepath.join(package_dir, ".index.json")
    case simplifile.read(index_path) {
      Error(_) -> []
      Ok(contents) -> {
        let assert Ok(files) = json.parse(contents, package_index_decoder())
        files
        |> list.filter_map(fn(file) {
          case file.type_, file.url {
            Some("Extension"), Some(url) ->
              case set.contains(referenced_urls, url) {
                False -> Error(Nil)
                True -> {
                  let resource =
                    read_structure_definition(filepath.join(
                      package_dir,
                      file.filename,
                    ))
                  case extension_fields(resource) {
                    None -> Error(Nil)
                    Some(kind) ->
                      Ok(#(
                        url,
                        ExtensionDefinition(
                          name: resource.id
                            |> string.replace("-", "_")
                            |> string.replace(".", "_")
                            |> codegen_helpers.to_camel_case,
                          kind:,
                        ),
                      ))
                  }
                }
              }
            _, _ -> Error(Nil)
          }
        })
      }
    }
  })
  |> dict.from_list
}

fn load_profile_files(
  profiles_dir: String,
  gen_specific_resources: Option(List(String)),
) -> ProfileFiles {
  let gen_specific_resources = case gen_specific_resources {
    None -> None
    Some(gen_specific_resources) ->
      Some(
        gen_specific_resources
        |> list.append(
          list.map(gen_specific_resources, fn(res) { res <> "profile" }),
        ),
      )
  }
  let structures = root_profile_resources(profiles_dir)
  let resources =
    list.filter(structures, fn(resource) {
      resource.kind == Some("resource")
      && case gen_specific_resources {
        None -> True
        Some(gen_specific_resources) ->
          list.contains(gen_specific_resources, string.lowercase(resource.name))
      }
    })
  let datatype_profile_urls =
    resources
    |> list.flat_map(fn(resource) {
      case resource.snapshot {
        None -> []
        Some(snapshot) ->
          snapshot.element
          |> list.flat_map(fn(element) {
            element.type_
            |> list.flat_map(fn(type_) {
              case type_.code {
                "Extension" -> []
                _ -> list.map(type_.profile, canonical_url)
              }
            })
          })
      }
    })
    |> set.from_list
  let datatype_profiles =
    codegen_helpers.package_directories(profiles_dir)
    |> list.flat_map(fn(package_dir) {
      let index_path = filepath.join(package_dir, ".index.json")
      case simplifile.read(index_path) {
        Error(_) -> []
        Ok(contents) -> {
          let assert Ok(files) = json.parse(contents, package_index_decoder())
          files
          |> list.filter(fn(file) {
            file.resource_type == Some("StructureDefinition")
            && file.kind == Some("complex-type")
            && file.type_ != Some("Extension")
          })
          |> list.filter_map(fn(file) {
            case file.url {
              Some(url) -> {
                let resource =
                  read_structure_definition(filepath.join(
                    package_dir,
                    file.filename,
                  ))
                case resource.kind, resource.type_ {
                  Some("complex-type"), Some(type_) if type_ != "Extension" ->
                    case
                      canonical_url(url)
                      == "http://hl7.org/fhir/StructureDefinition/" <> type_
                    {
                      True -> Error(Nil)
                      False -> Ok(#(canonical_url(url), resource))
                    }
                  _, _ -> Error(Nil)
                }
              }
              _ -> Error(Nil)
            }
          })
        }
      }
    })
    |> dict.from_list
  // Follow datatype references transitively, including references from datatypes.
  let datatype_profile_urls =
    list.fold(
      dict.values(datatype_profiles),
      datatype_profile_urls,
      fn(urls, _) {
        list.fold(set.to_list(urls), urls, fn(urls, url) {
          case dict.get(datatype_profiles, url) {
            Error(_) -> urls
            Ok(profile) -> {
              let assert Some(snapshot) = profile.snapshot
              list.fold(snapshot.element, urls, fn(urls, element) {
                list.fold(element.type_, urls, fn(urls, type_) {
                  case type_.code {
                    "Extension" -> urls
                    _ ->
                      set.union(
                        urls,
                        set.from_list(list.map(type_.profile, canonical_url)),
                      )
                  }
                })
              })
            }
          }
        })
      },
    )
  let datatype_profiles =
    dict.filter(datatype_profiles, fn(url, _) {
      set.contains(datatype_profile_urls, url)
    })
  let extensions =
    list.append(resources, dict.values(datatype_profiles))
    |> referenced_extension_urls
    |> extension_definitions(profiles_dir, _)
  ProfileFiles(resources:, extensions:, datatype_profiles:)
}

pub fn required_complex_type_names(
  profiles_dir: String,
  gen_specific_resources: Option(List(String)),
) -> Set(String) {
  let profile_files = load_profile_files(profiles_dir, gen_specific_resources)
  let resource_elements =
    list.append(
      profile_files.resources,
      dict.values(profile_files.datatype_profiles),
    )
    |> list.flat_map(fn(resource) {
      case resource.snapshot {
        Some(snapshot) -> snapshot.element
        None -> []
      }
    })
  let extension_elements =
    profile_files.extensions
    |> dict.values
    |> list.flat_map(fn(extension) {
      case extension.kind {
        SimpleExtension(element) -> [element]
        ComplexExtension(elements, _) -> elements
      }
    })
  list.append(resource_elements, extension_elements)
  |> list.flat_map(fn(element) {
    element.type_ |> list.map(fn(type_) { type_.code })
  })
  |> set.from_list
}

fn extension_field_type(
  extension_name: String,
  element: codegen_helpers.Element,
  valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
) -> #(String, String, dict.Dict(String, codegen_helpers.ValuesetItem)) {
  let field_name = extension_field_name(element)
  case element.type_ {
    [type_] -> {
      let #(gleam_type, valueset_acc) =
        codegen_helpers.string_to_type(
          type_.code,
          [extension_name, field_name],
          element,
          codegen_helpers.ComplexTypes,
          valueset_acc,
        )
      #(gleam_type, "", valueset_acc)
    }
    types -> {
      let choice_name = extension_name <> string.capitalise(field_name)
      let #(variants, cases, valueset_acc) =
        list.fold(types, #("", "", valueset_acc), fn(acc, type_) {
          let #(variants, cases, valueset_acc) = acc
          let #(gleam_type, valueset_acc) =
            codegen_helpers.string_to_type(
              type_.code,
              [
                "somehow this is used in [x] for any type (int, bool, code, etc) and ofc that code has no defined binding",
              ],
              element,
              codegen_helpers.ComplexTypes,
              valueset_acc,
            )
          #(
            variants
              <> "  "
              <> choice_name
              <> string.capitalise(type_.code)
              <> "(value: "
              <> gleam_type
              <> ")\n",
            cases
              <> "    "
              <> choice_name
              <> string.capitalise(type_.code)
              <> "(value) -> "
              <> codegen_to_json.string_to_encoder_type(
              type_.code,
              [extension_name, field_name],
              element,
              codegen_helpers.ComplexTypes,
            )
              <> "(value)\n",
            valueset_acc,
          )
        })
      #(
        choice_name,
        "pub type "
          <> choice_name
          <> " {\n"
          <> variants
          <> "}\n\npub fn "
          <> codegen_helpers.to_snake_case(choice_name)
          <> "_to_json(value: "
          <> choice_name
          <> ") -> Json {\n  case value {\n"
          <> cases
          <> "  }\n}\n\n",
        valueset_acc,
      )
    }
  }
}

fn generate_extension_types(
  extensions: dict.Dict(String, ExtensionDefinition),
  preserve_slice_order: Bool,
  valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
) -> #(String, dict.Dict(String, codegen_helpers.ValuesetItem)) {
  let extension_slice_elt_source = case
    preserve_slice_order && dict.size(extensions) > 0
  {
    True ->
      "pub type ExtensionSliceElt(a) {\n  ExtensionSliceElt(\n    value: a,\n    id: Option(String),\n    internal_gleam_fhir_index: Option(Int),\n  )\n}\n\npub fn extension_slice_elt_new(value: a) -> ExtensionSliceElt(a) {\n  ExtensionSliceElt(value:, id: None, internal_gleam_fhir_index: None)\n}\n\n"
    False -> ""
  }
  extensions
  |> dict.values
  |> list.sort(fn(a, b) { string.compare(a.name, b.name) })
  |> list.fold(#(extension_slice_elt_source, valueset_acc), fn(acc, extension) {
    let #(source, valueset_acc) = acc
    case extension.kind {
      SimpleExtension(_) -> #(source, valueset_acc)
      ComplexExtension([], _) -> #(source, valueset_acc)
      ComplexExtension(fields, slicing_rules) -> {
        let open = slicing_rules != "closed"
        let initial_field_acc = #("", "", "", "", "", "", valueset_acc)
        let #(
          field_source,
          choice_source,
          newfunc_args,
          newfunc_fields,
          encoder_args,
          children_source,
          valueset_acc,
        ) =
          list.fold(fields, initial_field_acc, fn(acc, field) {
            let #(
              field_source,
              choice_source,
              newfunc_args,
              newfunc_fields,
              encoder_args,
              children_source,
              valueset_acc,
            ) = acc
            let #(field_type, new_choice, valueset_acc) =
              extension_field_type(extension.name, field, valueset_acc)
            let stored_field_type = case preserve_slice_order {
              True -> "ExtensionSliceElt(" <> field_type <> ")"
              False -> field_type
            }
            let field_name =
              field |> extension_field_name |> codegen_helpers.to_snake_case
            let #(newfunc_arg, newfunc_field) =
              codegen_helpers.new_fn_arg_and_field(
                field_name,
                stored_field_type,
                field.min,
                field.max,
                False,
              )
            let to_json = fn(value) {
              let encoded =
                extension_field_to_json_call(
                  extension.name,
                  field,
                  field_type,
                  case preserve_slice_order {
                    True -> value <> ".value"
                    False -> value
                  },
                  case preserve_slice_order {
                    True -> Some(value <> ".id")
                    False -> None
                  },
                )
              case preserve_slice_order {
                True ->
                  "SliceElt("
                  <> encoded
                  <> ", "
                  <> value
                  <> ".internal_gleam_fhir_index)"
                False -> encoded
              }
            }
            let new_children_source = case field.min, field.max {
              0, "1" ->
                "\n  let children = case "
                <> field_name
                <> " {\n    Some(value) -> ["
                <> to_json("value")
                <> ", ..children]\n    None -> children\n  }"
              1, "1" ->
                "\n  let children = [" <> to_json(field_name) <> ", ..children]"
              0, "*" ->
                "\n  let children = list.append(list.map("
                <> field_name
                <> ", fn(value) { "
                <> to_json("value")
                <> " }), children)"
              1, "*" ->
                "\n  let List1(first, rest) = "
                <> field_name
                <> "\n  let children = list.append(["
                <> to_json("first")
                <> ", ..list.map(rest, fn(value) { "
                <> to_json("value")
                <> " })], children)"
              2, "*" ->
                "\n  let List2(first, second, rest) = "
                <> field_name
                <> "\n  let children = list.append(["
                <> to_json("first")
                <> ", "
                <> to_json("second")
                <> ", ..list.map(rest, fn(value) { "
                <> to_json("value")
                <> " })], children)"
              3, "*" ->
                "\n  let List3(first, second, third, rest) = "
                <> field_name
                <> "\n  let children = list.append(["
                <> to_json("first")
                <> ", "
                <> to_json("second")
                <> ", "
                <> to_json("third")
                <> ", ..list.map(rest, fn(value) { "
                <> to_json("value")
                <> " })], children)"
              0, _ ->
                "\n  let children = list.append(list.map("
                <> field_name
                <> ", fn(value) { "
                <> to_json("value")
                <> " }), children)"
              _, _ -> panic as "unsupported extension cardinality"
            }
            #(
              field_source
                <> "    "
                <> field_name
                <> ": "
                <> codegen_helpers.cardinality(
                stored_field_type,
                field.min,
                field.max,
              )
                <> ",\n",
              choice_source <> new_choice,
              newfunc_args <> newfunc_arg,
              newfunc_fields <> newfunc_field,
              encoder_args <> field_name <> ":,",
              children_source <> new_children_source,
              valueset_acc,
            )
          })
        let open_field_source = case open {
          True -> {
            let field_type = case preserve_slice_order {
              True -> "SliceElt(Extension)"
              False -> "Extension"
            }
            "    extension: List(" <> field_type <> "),\n"
          }
          False -> ""
        }
        let open_new_field = case open {
          True -> "extension: [],"
          False -> ""
        }
        let open_encoder_arg = case open {
          True -> "extension:,"
          False -> ""
        }
        let initial_children = case open, preserve_slice_order {
          False, _ -> "  let children = []"
          True, False ->
            "  let children = list.map(extension, extension_to_json)"
          True, True ->
            "  let children = list.map(extension, fn(value) { SliceElt(extension_to_json(value.value), value.internal_gleam_fhir_index) })"
        }
        let ordered_children = case preserve_slice_order {
          True -> "\n  let children = slice_elts_to_values(children)"
          False -> ""
        }
        let json_fields =
          "[#(\"url\", json.string(url)), #(\"extension\", json.preprocessed_array(children))]"
        let encoder_name =
          codegen_helpers.to_snake_case(extension.name) <> "_to_json"
        let encoder_body =
          "  let "
          <> extension.name
          <> "("
          <> open_encoder_arg
          <> encoder_args
          <> ") = value\n"
          <> initial_children
          <> children_source
          <> ordered_children
          <> case preserve_slice_order {
            True ->
              "\n  let fields = "
              <> json_fields
              <> "\n  let fields = case id { Some(id) -> [#(\"id\", json.string(id)), ..fields] None -> fields }\n  json.object(fields)"
            False -> "\n  json.object(" <> json_fields <> ")"
          }
          <> "\n}\n\n"
        let encoder_source = case preserve_slice_order {
          True ->
            "pub fn "
            <> encoder_name
            <> "(value: "
            <> extension.name
            <> ", url: String, id: Option(String)) -> Json {\n"
            <> encoder_body
          False ->
            "pub fn "
            <> encoder_name
            <> "(value: "
            <> extension.name
            <> ", url: String) -> Json {\n"
            <> encoder_body
        }
        #(
          source
            <> "pub type "
            <> extension.name
            <> " {\n  "
            <> extension.name
            <> "(\n"
            <> open_field_source
            <> field_source
            <> "  )\n}\n\npub fn "
            <> codegen_helpers.to_snake_case(extension.name)
            <> "_new("
            <> newfunc_args
            <> ") -> "
            <> extension.name
            <> " {\n  "
            <> extension.name
            <> "("
            <> open_new_field
            <> newfunc_fields
            <> ")\n}\n\n"
            <> encoder_source
            <> choice_source,
          valueset_acc,
        )
      }
    }
  })
}

fn remove_profile_extension_children(
  elements: List(codegen_helpers.Element),
  extensions: dict.Dict(String, ExtensionDefinition),
) -> List(codegen_helpers.Element) {
  let extension_ids =
    elements
    |> list.filter_map(fn(element) {
      case profile_extension_definition(element, extensions) {
        Some(_) -> Ok(element.id <> ".")
        None -> Error(Nil)
      }
    })
  list.filter(elements, fn(element) {
    !list.any(extension_ids, fn(id) { string.starts_with(element.id, id) })
  })
}

fn element_type_is(element: codegen_helpers.Element, expected: String) -> Bool {
  case element.type_ {
    [codegen_helpers.Type(code:, ..)] -> code == expected
    _ -> False
  }
}

fn coding_type_from_elements(
  coding: codegen_helpers.Element,
  elements: List(codegen_helpers.Element),
) -> Result(String, String) {
  let #(pattern_system, pattern_code, pattern_display) = case
    coding.pattern_coding
  {
    Some(codegen_helpers.DiscriminatorCodingValue(system:, code:, display:)) -> #(
      system,
      code,
      display,
    )
    None -> #(None, None, None)
  }
  let child_system =
    find_element(elements, coding.id <> ".system")
    |> result.map(fn(element) { element.fixed_uri })
    |> result.unwrap(None)
  let child_code =
    find_element(elements, coding.id <> ".code")
    |> result.map(fn(element) { element.fixed_code })
    |> result.unwrap(None)
  let system = case pattern_system, child_system {
    Some(pattern), Some(child) if pattern != child ->
      panic as { "conflicting Coding system constraints for " <> coding.id }
    Some(pattern), _ -> Some(pattern)
    None, child -> child
  }
  let code = case pattern_code, child_code {
    Some(pattern), Some(child) if pattern != child ->
      panic as { "conflicting Coding code constraints for " <> coding.id }
    Some(pattern), _ -> Some(pattern)
    None, child -> child
  }
  case system, code, pattern_display {
    Some(_), Some(_), Some(_) -> Ok("ct.CodingFixedSystemCodeDisplay")
    Some(_), Some(_), None -> Ok("ct.CodingFixedSystemCode")
    Some(_), None, None -> Ok("ct.CodingFixedSystem")
    _, _, _ -> Error("Coding pattern has unsupported fixed fields")
  }
}

fn codeableconcept_type_from_elements(
  concept: codegen_helpers.Element,
  elements: List(codegen_helpers.Element),
) -> Result(String, String) {
  let coding = case concept.pattern_codeableconcept {
    Some(codegen_helpers.DiscriminatorCodeableconceptValue(coding: [pattern])) ->
      Ok(
        codegen_helpers.Element(
          ..concept,
          id: concept.id <> ".coding",
          path: concept.path <> ".coding",
          slice_name: None,
          slicing: None,
          type_: [
            codegen_helpers.Type(
              code: "Coding",
              target_profile: [],
              profile: [],
            ),
          ],
          pattern_coding: Some(pattern),
          pattern_codeableconcept: None,
        ),
      )
    Some(_) -> Error("CodeableConcept pattern has more than one Coding")
    None ->
      find_element(elements, concept.id <> ".coding")
      |> result.replace_error("missing CodeableConcept coding element")
  }
  use coding <- result.try(coding)
  use coding_type <- result.try(coding_type_from_elements(coding, elements))
  // A concept pattern requires a matching coding, while unsliced child
  // constraints apply to every coding in the required list.
  case concept.pattern_codeableconcept, coding.slicing, coding.min, coding.max {
    None, None, 1, "*" ->
      case coding_type {
        "ct.CodingFixedSystem" -> Ok("ct.CodeableconceptList1FixedSystem")
        "ct.CodingFixedSystemCode" ->
          Ok("ct.CodeableconceptList1FixedSystemCode")
        "ct.CodingFixedSystemCodeDisplay" ->
          Ok("ct.CodeableconceptList1FixedSystemCodeDisplay")
        _ -> Error("unsupported CodeableConcept Coding type")
      }
    _, _, _, _ ->
      case coding_type {
        "ct.CodingFixedSystem" -> Ok("ct.CodeableconceptFixedSystem")
        "ct.CodingFixedSystemCode" -> Ok("ct.CodeableconceptFixedSystemCode")
        "ct.CodingFixedSystemCodeDisplay" ->
          Ok("ct.CodeableconceptFixedSystemCodeDisplay")
        _ -> Error("unsupported CodeableConcept Coding type")
      }
  }
}

fn discriminator_paths(slicing: codegen_helpers.Slicing) -> List(String) {
  slicing.discriminator
  |> list.filter_map(fn(discriminator) {
    case discriminator.type_ {
      "value" | "pattern" -> Ok(discriminator.path)
      _ -> Error(Nil)
    }
  })
  |> list.sort(string.compare)
}

fn only_value_or_pattern_discriminators(
  slicing: codegen_helpers.Slicing,
) -> Bool {
  list.length(discriminator_paths(slicing))
  == list.length(slicing.discriminator)
}

fn plan_whole_value_slice(
  _group: codegen_helpers.Element,
  root: codegen_helpers.Element,
  elements: List(codegen_helpers.Element),
  available_valuesets: dict.Dict(String, codegen_helpers.VsOrCs),
) -> Result(SlicePlan, String) {
  case root.type_ {
    [codegen_helpers.Type(code: "Coding", ..)] ->
      case coding_type_from_elements(root, elements) {
        Ok(type_) -> {
          use #(system, code, display) <- result.try(
            codegen_profile_json.discriminator_literals(root, [root, ..elements])
            |> result.replace_error("missing discriminator literals"),
          )
          Ok(
            ValueSlicePlan(
              root_id: root.id,
              overrides: [
                #(
                  root.id,
                  FixedSliceType(
                    type_,
                    [root, ..elements],
                    system,
                    code,
                    display,
                  ),
                ),
              ],
              nested: [],
            ),
          )
        }
        Error(_) ->
          case root.binding {
            Some(codegen_helpers.Binding(
              strength: "required",
              value_set: Some(value_set),
            )) -> {
              let value_set = canonical_url(value_set)
              case
                codegen_helpers.valueset_can_generate_discriminator(
                  value_set,
                  available_valuesets,
                )
              {
                True ->
                  Ok(
                    ValueSlicePlan(
                      root_id: root.id,
                      overrides: [#(root.id, BoundCodingSlice)],
                      nested: [],
                    ),
                  )
                False ->
                  Error(
                    "cant expand valueset required for discriminator "
                    <> value_set,
                  )
              }
            }
            _ -> Error("unsupported Coding $this value pattern")
          }
      }
    [codegen_helpers.Type(code: "CodeableConcept", ..)] ->
      case codeableconcept_type_from_elements(root, elements) {
        Ok(type_) -> {
          use #(system, code, display) <- result.try(
            codegen_profile_json.discriminator_literals(root, [root, ..elements])
            |> result.replace_error("missing discriminator literals"),
          )
          Ok(
            ValueSlicePlan(
              root_id: root.id,
              overrides: [
                #(
                  root.id,
                  FixedSliceType(
                    type_,
                    [root, ..elements],
                    system,
                    code,
                    display,
                  ),
                ),
              ],
              nested: [],
            ),
          )
        }
        Error(_) ->
          case root.binding {
            Some(codegen_helpers.Binding(
              strength: "required",
              value_set: Some(value_set),
            )) -> {
              let value_set = canonical_url(value_set)
              case
                codegen_helpers.valueset_can_generate_discriminator(
                  value_set,
                  available_valuesets,
                )
              {
                True ->
                  Ok(
                    ValueSlicePlan(
                      root_id: root.id,
                      overrides: [#(root.id, BoundCodeableconceptSlice)],
                      nested: [],
                    ),
                  )
                False ->
                  Error(
                    "cant expand valueset required for discriminator "
                    <> value_set,
                  )
              }
            }
            _ -> Error("unsupported CodeableConcept $this value pattern")
          }
      }
    [codegen_helpers.Type(code: "Identifier", ..)] ->
      case root.pattern_identifier {
        Some(codegen_helpers.DiscriminatorIdentifierValue(
          system: Some(system),
          value: None,
        )) -> {
          let system_override = #(
            root.id <> ".system",
            FixedValueDiscriminator(system),
          )
          case find_element(elements, root.id <> ".type") {
            Ok(type_) ->
              case codeableconcept_type_from_elements(type_, elements) {
                Ok(type_name) -> {
                  use #(type_system, type_code, type_display) <- result.try(
                    codegen_profile_json.discriminator_literals(type_, [
                      type_,
                      ..elements
                    ])
                    |> result.replace_error("missing discriminator literals"),
                  )
                  Ok(
                    ValueSlicePlan(
                      root_id: root.id,
                      overrides: [
                        system_override,
                        #(
                          type_.id,
                          FixedSliceType(
                            type_name,
                            [type_, ..elements],
                            type_system,
                            type_code,
                            type_display,
                          ),
                        ),
                      ],
                      nested: [],
                    ),
                  )
                }
                Error(_) ->
                  Ok(
                    ValueSlicePlan(
                      root_id: root.id,
                      overrides: [system_override],
                      nested: [],
                    ),
                  )
              }
            Error(_) ->
              Ok(
                ValueSlicePlan(
                  root_id: root.id,
                  overrides: [system_override],
                  nested: [],
                ),
              )
          }
        }
        _ -> Error("unsupported Identifier $this value pattern")
      }
    _ -> Error("unsupported $this value pattern")
  }
}

fn plan_system_code_slice(
  root: codegen_helpers.Element,
  elements: List(codegen_helpers.Element),
) -> Result(SlicePlan, String) {
  let coding_id = root.id <> ".coding"
  case
    find_element(elements, coding_id),
    element_type_is(root, "CodeableConcept")
  {
    Ok(_), True ->
      case codeableconcept_type_from_elements(root, elements) {
        Ok("ct.CodeableconceptFixedSystemCode" as type_)
        | Ok("ct.CodeableconceptFixedSystemCodeDisplay" as type_)
        | Ok("ct.CodeableconceptList1FixedSystemCode" as type_)
        | Ok("ct.CodeableconceptList1FixedSystemCodeDisplay" as type_) -> {
          use #(system, code, display) <- result.try(
            codegen_profile_json.discriminator_literals(root, [root, ..elements])
            |> result.replace_error("missing discriminator literals"),
          )
          Ok(
            ValueSlicePlan(
              root_id: root.id,
              overrides: [
                #(
                  root.id,
                  FixedSliceType(
                    type_,
                    [root, ..elements],
                    system,
                    code,
                    display,
                  ),
                ),
              ],
              nested: [],
            ),
          )
        }
        Ok(_) -> Error("don't have discriminator fixed system/fixed code")
        Error(reason) -> Error(reason)
      }
    _, _ -> Error("missing CodeableConcept Coding constraints")
  }
}

fn plan_child_value_slice(
  root: codegen_helpers.Element,
  path: String,
  elements: List(codegen_helpers.Element),
  available_valuesets: dict.Dict(String, codegen_helpers.VsOrCs),
  planned_slices: dict.Dict(String, SlicePlan),
) -> Result(SlicePlan, String) {
  let child_id = root.id <> "." <> path
  use child <- result.try(
    find_element(elements, child_id)
    |> result.replace_error("missing discriminator element " <> child_id),
  )
  case child.type_ {
    [codegen_helpers.Type(code: "CodeableConcept", ..)] ->
      case codeableconcept_type_from_elements(child, elements) {
        Ok(type_) -> {
          use #(system, code, display) <- result.try(
            codegen_profile_json.discriminator_literals(child, [
              child,
              ..elements
            ])
            |> result.replace_error("missing discriminator literals"),
          )
          Ok(
            ValueSlicePlan(
              root_id: root.id,
              overrides: [
                #(
                  child_id,
                  FixedSliceType(
                    type_,
                    [child, ..elements],
                    system,
                    code,
                    display,
                  ),
                ),
              ],
              nested: [],
            ),
          )
        }
        Error(_) -> {
          let nested_group = find_element(elements, child_id <> ".coding")
          case nested_group {
            Ok(codegen_helpers.Element(slicing: Some(_), ..)) -> {
              let nested_group = result.unwrap(nested_group, child)
              let nested_roots = direct_slice_roots(nested_group, elements)
              case
                nested_roots,
                list.try_map(nested_roots, fn(nested_root) {
                  dict.get(planned_slices, nested_root.id)
                })
              {
                [_, ..], Ok(nested) ->
                  Ok(ValueSlicePlan(root_id: root.id, overrides: [], nested:))
                _, _ ->
                  plan_whole_value_slice(
                    root,
                    child,
                    elements,
                    available_valuesets,
                  )
              }
            }
            _ ->
              plan_whole_value_slice(root, child, elements, available_valuesets)
          }
        }
      }
    [codegen_helpers.Type(code: "Coding", ..)] ->
      case coding_type_from_elements(child, elements) {
        Ok(type_) -> {
          use #(system, code, display) <- result.try(
            codegen_profile_json.discriminator_literals(child, [
              child,
              ..elements
            ])
            |> result.replace_error("missing discriminator literals"),
          )
          Ok(
            ValueSlicePlan(
              root_id: root.id,
              overrides: [
                #(
                  child_id,
                  FixedSliceType(
                    type_,
                    [child, ..elements],
                    system,
                    code,
                    display,
                  ),
                ),
              ],
              nested: [],
            ),
          )
        }
        Error(_) ->
          plan_whole_value_slice(root, child, elements, available_valuesets)
      }
    [codegen_helpers.Type(code: "code", ..)] ->
      case child.fixed_code {
        Some(code) ->
          Ok(
            ValueSlicePlan(
              root_id: root.id,
              overrides: [#(child_id, FixedValueDiscriminator(code))],
              nested: [],
            ),
          )
        None -> Error("missing code discriminator literal at " <> child_id)
      }
    _ -> Error("unsupported value pattern at " <> child_id)
  }
}

fn plan_value_slice(
  slicing: codegen_helpers.Slicing,
  group: codegen_helpers.Element,
  root: codegen_helpers.Element,
  elements: List(codegen_helpers.Element),
  available_valuesets: dict.Dict(String, codegen_helpers.VsOrCs),
  planned_slices: dict.Dict(String, SlicePlan),
) -> Result(SlicePlan, String) {
  case
    only_value_or_pattern_discriminators(slicing),
    discriminator_paths(slicing)
  {
    True, ["$this"] ->
      plan_whole_value_slice(group, root, elements, available_valuesets)
    True, ["code", "system"] | True, ["code"] ->
      case element_type_is(root, "Coding") {
        True ->
          case coding_type_from_elements(root, elements) {
            Ok("ct.CodingFixedSystemCode" as type_)
            | Ok("ct.CodingFixedSystemCodeDisplay" as type_) -> {
              use #(system, code, display) <- result.try(
                codegen_profile_json.discriminator_literals(root, [
                  root,
                  ..elements
                ])
                |> result.replace_error("missing discriminator literals"),
              )
              Ok(
                ValueSlicePlan(
                  root_id: root.id,
                  overrides: [
                    #(
                      root.id,
                      FixedSliceType(
                        type_,
                        [root, ..elements],
                        system,
                        code,
                        display,
                      ),
                    ),
                  ],
                  nested: [],
                ),
              )
            }
            Ok(_) -> Error("don't have discriminator fixed system/fixed code")
            Error(reason) -> Error(reason)
          }
        False ->
          plan_child_value_slice(
            root,
            "code",
            elements,
            available_valuesets,
            planned_slices,
          )
      }
    True, ["coding.code", "coding.system"] | True, ["coding.code"] ->
      plan_system_code_slice(root, elements)
    True, ["coding"] ->
      case codeableconcept_type_from_elements(root, elements) {
        Ok(type_) -> {
          use #(system, code, display) <- result.try(
            codegen_profile_json.discriminator_literals(root, [root, ..elements])
            |> result.replace_error("missing discriminator literals"),
          )
          Ok(
            ValueSlicePlan(
              root_id: root.id,
              overrides: [
                #(
                  root.id,
                  FixedSliceType(
                    type_,
                    [root, ..elements],
                    system,
                    code,
                    display,
                  ),
                ),
              ],
              nested: [],
            ),
          )
        }
        Error(reason) -> Error(reason)
      }
    True, ["system"] ->
      case group.type_ {
        [codegen_helpers.Type(code: "Identifier", ..)] -> {
          let system_id = root.id <> ".system"
          case find_element(elements, system_id) {
            Ok(codegen_helpers.Element(fixed_uri: Some(system), ..)) ->
              case find_element(elements, root.id <> ".type") {
                Ok(type_) ->
                  case codeableconcept_type_from_elements(type_, elements) {
                    Ok(type_name) -> {
                      use #(type_system, type_code, type_display) <- result.try(
                        codegen_profile_json.discriminator_literals(type_, [
                          type_,
                          ..elements
                        ])
                        |> result.replace_error(
                          "missing discriminator literals",
                        ),
                      )
                      Ok(
                        ValueSlicePlan(
                          root_id: root.id,
                          overrides: [
                            #(
                              root.id <> ".system",
                              FixedValueDiscriminator(system),
                            ),
                            #(
                              type_.id,
                              FixedSliceType(
                                type_name,
                                [type_, ..elements],
                                type_system,
                                type_code,
                                type_display,
                              ),
                            ),
                          ],
                          nested: [],
                        ),
                      )
                    }
                    Error(_) ->
                      Ok(
                        ValueSlicePlan(
                          root_id: root.id,
                          overrides: [
                            #(
                              root.id <> ".system",
                              FixedValueDiscriminator(system),
                            ),
                          ],
                          nested: [],
                        ),
                      )
                  }
                Error(_) ->
                  Ok(
                    ValueSlicePlan(
                      root_id: root.id,
                      overrides: [
                        #(root.id <> ".system", FixedValueDiscriminator(system)),
                      ],
                      nested: [],
                    ),
                  )
              }
            _ -> Error("Identifier slice has no system literal")
          }
        }
        [codegen_helpers.Type(code: "Coding", ..)] -> {
          case find_element(elements, root.id <> ".system") {
            Error(_) | Ok(codegen_helpers.Element(fixed_uri: None, ..)) ->
              case root.binding {
                Some(codegen_helpers.Binding(
                  strength: "required",
                  value_set: Some(value_set),
                )) -> {
                  let value_set = canonical_url(value_set)
                  case
                    codegen_helpers.valueset_can_generate_discriminator(
                      value_set,
                      available_valuesets,
                    )
                  {
                    True ->
                      Ok(
                        ValueSlicePlan(
                          root_id: root.id,
                          overrides: [#(root.id, BoundCodingSlice)],
                          nested: [],
                        ),
                      )
                    False ->
                      Error(
                        "cant expand valueset required for discriminator "
                        <> value_set,
                      )
                  }
                }
                _ -> Error("Coding slice has no system literal")
              }
            Ok(_) -> {
              use #(system, code, display) <- result.try(
                codegen_profile_json.discriminator_literals(root, [
                  root,
                  ..elements
                ])
                |> result.replace_error("missing discriminator literals"),
              )
              let required_code = case
                find_element(elements, root.id <> ".code")
              {
                Ok(code) -> code.min > 0
                Error(_) -> False
              }
              let required_display = case
                find_element(elements, root.id <> ".display")
              {
                Ok(display) -> display.min > 0
                Error(_) -> False
              }
              Ok(
                ValueSlicePlan(
                  root_id: root.id,
                  overrides: [
                    #(
                      root.id,
                      FixedSliceType(
                        case required_code, required_display {
                          True, True ->
                            "ct.CodingFixedSystemRequiredCodeDisplay"
                          _, _ -> "ct.CodingFixedSystem"
                        },
                        [root, ..elements],
                        system,
                        code,
                        display,
                      ),
                    ),
                  ],
                  nested: [],
                ),
              )
            }
          }
        }
        _ -> Error("unsupported system discriminator type")
      }
    True, [path] -> {
      let assert [first, ..] = string.split(path, ".")
      plan_child_value_slice(
        root,
        first,
        elements,
        available_valuesets,
        planned_slices,
      )
    }
    True, [first_path, ..rest_paths] -> {
      let assert [first, ..] = string.split(first_path, ".")
      case
        list.all(rest_paths, fn(path) {
          string.starts_with(path, first <> ".") || path == first
        })
      {
        True ->
          plan_child_value_slice(
            root,
            first,
            elements,
            available_valuesets,
            planned_slices,
          )
        False -> Error("value discriminator paths do not share one child")
      }
    }
    False, _ -> Error("")
    True, _ -> Error("unsupported value discriminator path")
  }
}

fn plan_slice(
  slicing: codegen_helpers.Slicing,
  group: codegen_helpers.Element,
  root: codegen_helpers.Element,
  elements: List(codegen_helpers.Element),
  available_valuesets: dict.Dict(String, codegen_helpers.VsOrCs),
  planned_slices: dict.Dict(String, SlicePlan),
) -> Result(SlicePlan, String) {
  case slicing.discriminator, root.type_ {
    [codegen_helpers.Discriminator(type_: "type", path: "$this")],
      [codegen_helpers.Type(code:, ..)]
    ->
      Ok(TypeSlicePlan(
        root_id: group.id,
        fhir_type: code,
        slice: root,
        children: elements
          |> list.filter(fn(element) {
            let prefix = root.id <> "."
            string.starts_with(element.id, prefix)
            && !string.contains(
              string.drop_start(element.id, string.length(prefix)),
              ".",
            )
          })
          |> list.map(fn(element) {
            case element.id == root.id <> ".value", element.type_ {
              True, [type_] ->
                case
                  string.starts_with(
                    type_.code,
                    "http://hl7.org/fhirpath/System.",
                  )
                {
                  True ->
                    codegen_helpers.Element(..element, type_: [
                      codegen_helpers.Type(..type_, code:),
                    ])
                  False -> element
                }
              _, _ -> element
            }
          }),
      ))
    _, _ ->
      plan_value_slice(
        slicing,
        group,
        root,
        elements,
        available_valuesets,
        planned_slices,
      )
  }
}

fn type_slice_key(root_id: String, fhir_type: String) -> String {
  root_id <> "|" <> fhir_type
}

fn direct_slice_roots(
  group: codegen_helpers.Element,
  elements: List(codegen_helpers.Element),
) -> List(codegen_helpers.Element) {
  let prefix = group.id <> ":"
  elements
  |> list.filter(fn(element) {
    element.path == group.path
    && element.slice_name != None
    && case string.starts_with(element.id, prefix) {
      False -> False
      True ->
        !string.contains(
          string.drop_start(element.id, string.length(prefix)),
          ".",
        )
    }
  })
  |> list.sort(fn(a, b) { string.compare(a.id, b.id) })
}

fn is_extension_slicing(group: codegen_helpers.Element) -> Bool {
  case group.slicing {
    Some(slicing) ->
      element_type_is(group, "Extension")
      && only_value_or_pattern_discriminators(slicing)
      && discriminator_paths(slicing) == ["url"]
    None -> False
  }
}

fn remove_element_trees(
  elements: List(codegen_helpers.Element),
  roots: List(String),
  include_roots: Bool,
) -> List(codegen_helpers.Element) {
  list.filter(elements, fn(element) {
    !list.any(roots, fn(root) {
      string.starts_with(element.id, root <> ".")
      || { include_roots && element.id == root }
    })
  })
}

fn prepare_profile_slices(
  resource_id: String,
  elements: List(codegen_helpers.Element),
  available_valuesets: dict.Dict(String, codegen_helpers.VsOrCs),
  datatype_profiles: dict.Dict(String, codegen_helpers.Resource),
) -> #(
  List(codegen_helpers.Element),
  dict.Dict(String, SliceFieldType),
  dict.Dict(String, SlicePlan),
  Set(String),
  dict.Dict(String, SliceFieldType),
) {
  let profiled_identifier_children =
    elements
    |> list.filter(fn(element) {
      element.slice_name != None && element_type_is(element, "Identifier")
    })
    |> list.flat_map(fn(root) {
      root.type_
      |> list.flat_map(fn(type_) {
        type_.profile
        |> list.find_map(fn(url) {
          dict.get(datatype_profiles, canonical_url(url))
        })
        |> result.map(fn(profile) {
          case profile.snapshot {
            None -> []
            Some(snapshot) ->
              snapshot.element
              |> list.filter_map(fn(child) {
                case string.starts_with(child.id, "Identifier.") {
                  False -> Error(Nil)
                  True -> {
                    let suffix = string.drop_start(child.id, 10)
                    let path_suffix = string.drop_start(child.path, 10)
                    let child_id = root.id <> suffix
                    case find_element(elements, child_id) {
                      Ok(existing) -> {
                        let fixed_uri = case
                          existing.fixed_uri,
                          child.fixed_uri
                        {
                          Some(value), Some(inherited) if value != inherited ->
                            panic as {
                              "conflicting Identifier system constraints for "
                              <> child_id
                            }
                          Some(value), _ -> Some(value)
                          None, inherited -> inherited
                        }
                        let fixed_code = case
                          existing.fixed_code,
                          child.fixed_code
                        {
                          Some(value), Some(inherited) if value != inherited ->
                            panic as {
                              "conflicting Identifier code constraints for "
                              <> child_id
                            }
                          Some(value), _ -> Some(value)
                          None, inherited -> inherited
                        }
                        Ok(
                          codegen_helpers.Element(
                            ..existing,
                            min: int.max(existing.min, child.min),
                            max: case existing.max, child.max {
                              "*", inherited -> inherited
                              value, "*" -> value
                              value, inherited -> {
                                let assert Ok(value) = int.parse(value)
                                let assert Ok(inherited) = int.parse(inherited)
                                int.min(value, inherited) |> int.to_string
                              }
                            },
                            binding: case existing.binding {
                              Some(_) -> existing.binding
                              None -> child.binding
                            },
                            fixed_code:,
                            fixed_uri:,
                            pattern_coding: case existing.pattern_coding {
                              Some(_) -> existing.pattern_coding
                              None -> child.pattern_coding
                            },
                            pattern_codeableconcept: case
                              existing.pattern_codeableconcept
                            {
                              Some(_) -> existing.pattern_codeableconcept
                              None -> child.pattern_codeableconcept
                            },
                            pattern_identifier: case
                              existing.pattern_identifier
                            {
                              Some(_) -> existing.pattern_identifier
                              None -> child.pattern_identifier
                            },
                          ),
                        )
                      }
                      Error(_) ->
                        Ok(
                          codegen_helpers.Element(
                            ..child,
                            id: child_id,
                            path: root.path <> path_suffix,
                          ),
                        )
                    }
                  }
                }
              })
          }
        })
        |> result.unwrap([])
      })
    })
  let profiled_identifier_child_ids =
    profiled_identifier_children
    |> list.map(fn(element) { element.id })
    |> set.from_list
  let elements =
    elements
    |> list.filter(fn(element) {
      !set.contains(profiled_identifier_child_ids, element.id)
    })
    |> list.append(profiled_identifier_children)
  let identifier_children = [
    "id",
    "extension",
    "use",
    "type",
    "system",
    "value",
    "period",
    "assigner",
  ]
  let inherited_identifier_children =
    elements
    |> list.filter(fn(element) {
      element.slice_name != None
      && element.pattern_identifier != None
      && element_type_is(element, "Identifier")
    })
    |> list.flat_map(fn(root) {
      identifier_children
      |> list.filter_map(fn(child_name) {
        let child_id = root.id <> "." <> child_name
        case find_element(elements, child_id) {
          Ok(_) -> Error(Nil)
          Error(_) ->
            case find_element(elements, root.path <> "." <> child_name) {
              Ok(child) ->
                Ok(
                  codegen_helpers.Element(
                    ..child,
                    id: child_id,
                    slice_name: None,
                  ),
                )
              Error(_) -> Error(Nil)
            }
        }
      })
    })
  let elements = list.append(elements, inherited_identifier_children)
  let elements =
    list.map(elements, fn(element) {
      case string.ends_with(element.id, ".system"), element.fixed_uri {
        True, None -> {
          let parent_id = string.drop_end(element.id, 7)
          case find_element(elements, parent_id) {
            Ok(codegen_helpers.Element(
              type_: [codegen_helpers.Type(code: "Identifier", ..)],
              pattern_identifier: Some(codegen_helpers.DiscriminatorIdentifierValue(
                system: Some(system),
                ..,
              )),
              ..,
            )) -> codegen_helpers.Element(..element, fixed_uri: Some(system))
            _ -> element
          }
        }
        _, _ -> element
      }
    })
  let groups =
    elements
    |> list.filter(fn(element) {
      element.slicing != None && !is_extension_slicing(element)
    })
    |> list.sort(fn(a, b) { string.compare(b.id, a.id) })

  list.fold(
    groups,
    #(elements, dict.new(), dict.new(), dict.new(), set.new(), dict.new()),
    fn(acc, group) {
      let #(
        current_elements,
        overrides,
        type_slice_overrides,
        planned_slices,
        nested_value_discriminators,
        slice_discriminator_checks,
      ) = acc
      let assert Some(slicing) = group.slicing
      let roots = direct_slice_roots(group, current_elements)
      let discriminator_type = case slicing.discriminator {
        [discriminator, ..] -> discriminator.type_
        [] -> "unknown"
      }
      let #(plans, unsupported_ids) =
        list.fold(roots, #([], []), fn(acc, root) {
          let #(plans, unsupported_ids) = acc
          case
            plan_slice(
              slicing,
              group,
              root,
              current_elements,
              available_valuesets,
              planned_slices,
            )
          {
            Ok(plan) -> #([plan, ..plans], unsupported_ids)
            Error(reason) -> {
              let message = case
                string.starts_with(
                  reason,
                  "cant expand valueset required for discriminator ",
                )
              {
                True ->
                  "not slicing because "
                  <> reason
                  <> " for "
                  <> resource_id
                  <> " "
                  <> root.id
                False ->
                  "not slicing "
                  <> discriminator_type
                  <> " discriminator "
                  <> resource_id
                  <> " "
                  <> root.id
                  <> case reason {
                    "" -> ""
                    _ -> " because " <> reason
                  }
              }
              io.println(message)
              #(plans, [root.id, ..unsupported_ids])
            }
          }
        })
      let #(plans, nested_value_discriminators, slice_discriminator_checks) =
        list.fold(
          plans,
          #([], nested_value_discriminators, slice_discriminator_checks),
          fn(acc, plan) {
            let #(plans, nested_value_discriminators, checks) = acc
            case plan {
              ValueSlicePlan(root_id:, overrides: replacements, ..) -> {
                // A constrained CodeableConcept may still reuse a shared Coding.
                let replacements =
                  list.flat_map(replacements, fn(replacement) {
                    let coding = {
                      use _ <- result.try(case replacement.1 {
                        FixedSliceType(type_name, ..) ->
                          case
                            string.starts_with(type_name, "ct.Codeableconcept")
                          {
                            True -> Ok(Nil)
                            False -> Error(Nil)
                          }
                        _ -> Error(Nil)
                      })
                      use element <- result.try(find_element(
                        current_elements,
                        replacement.0 <> ".coding",
                      ))
                      use type_name <- result.try(
                        coding_type_from_elements(element, current_elements)
                        |> result.replace_error(Nil),
                      )
                      use #(system, code, display) <- result.try(
                        codegen_profile_json.discriminator_literals(
                          element,
                          current_elements,
                        )
                        |> result.replace_error(Nil),
                      )
                      Ok(#(
                        element.id,
                        FixedSliceType(
                          type_name,
                          current_elements,
                          system,
                          code,
                          display,
                        ),
                      ))
                    }
                    case coding {
                      Ok(coding) -> [replacement, coding]
                      Error(_) -> [replacement]
                    }
                  })
                let replacements_kept =
                  list.filter(replacements, fn(replacement) {
                    case replacement.1 {
                      FixedSliceType(type_name, _, system, code, display) -> {
                        let fields = case
                          string.starts_with(type_name, "ct.Codeableconcept")
                        {
                          True -> [
                            "id",
                            "extension",
                            "coding",
                            "text",
                            "coding.id",
                            "coding.extension",
                            "coding.version",
                            "coding.system",
                            "coding.code",
                            "coding.display",
                            "coding.userSelected",
                          ]
                          False -> [
                            "id",
                            "extension",
                            "version",
                            "system",
                            "code",
                            "display",
                            "userSelected",
                          ]
                        }
                        let prefix = replacement.0 <> "."
                        !list.any(current_elements, fn(child) {
                          case string.starts_with(child.id, prefix) {
                            False -> False
                            True -> {
                              let field =
                                string.drop_start(
                                  child.id,
                                  string.length(prefix),
                                )
                              let fixed_field = case field {
                                "system" | "coding.system" -> system != ""
                                "code" | "coding.code" -> code != ""
                                "display" | "coding.display" -> display != None
                                _ -> False
                              }
                              let required_field =
                                type_name
                                == "ct.CodingFixedSystemRequiredCodeDisplay"
                                && { field == "code" || field == "display" }
                              let required_coding_list =
                                string.starts_with(
                                  type_name,
                                  "ct.CodeableconceptList1",
                                )
                                && field == "coding"
                              let cardinality_preserved = case
                                required_coding_list,
                                fixed_field,
                                required_field
                              {
                                True, _, _ -> child.min == 1 && child.max == "*"
                                False, True, _ ->
                                  child.min <= 1 && child.max == "1"
                                False, False, True ->
                                  child.min == 1 && child.max == "1"
                                False, False, False ->
                                  child.min == child.base.min
                                  && child.max == child.base.max
                              }
                              child.slice_name != None
                              || !list.contains(fields, field)
                              || list.any(child.type_, fn(type_) {
                                type_.profile != []
                              })
                              || !cardinality_preserved
                              || case child.binding {
                                Some(binding) ->
                                  binding.strength == "required" && !fixed_field
                                None -> False
                              }
                            }
                          }
                        })
                      }
                      _ -> True
                    }
                  })
                let checks =
                  list.fold(replacements, checks, fn(checks, replacement) {
                    case list.contains(replacements_kept, replacement) {
                      True -> checks
                      False -> dict.insert(checks, replacement.0, replacement.1)
                    }
                  })
                case
                  list.length(replacements_kept) == list.length(replacements)
                {
                  True -> #(
                    [plan, ..plans],
                    case
                      list.any(replacements, fn(replacement) {
                        case replacement.1 {
                          FixedValueDiscriminator(_) ->
                            case find_element(current_elements, replacement.0) {
                              Ok(child) -> element_type_is(child, "code")
                              Error(_) -> False
                            }
                          _ -> False
                        }
                      })
                    {
                      True -> set.insert(nested_value_discriminators, root_id)
                      False -> nested_value_discriminators
                    },
                    checks,
                  )
                  False -> #(
                    [
                      ValueSlicePlan(..plan, overrides: replacements_kept),
                      ..plans
                    ],
                    set.insert(nested_value_discriminators, root_id),
                    checks,
                  )
                }
              }
              TypeSlicePlan(..) -> #(
                [plan, ..plans],
                nested_value_discriminators,
                checks,
              )
            }
          },
        )
      let keep_supported_open_slices =
        unsupported_ids != [] && plans != [] && slicing.rules == "open"
      let current_elements = case keep_supported_open_slices {
        True -> remove_element_trees(current_elements, unsupported_ids, True)
        False -> current_elements
      }
      let unsupported_ids = case keep_supported_open_slices {
        True -> []
        False -> unsupported_ids
      }
      case unsupported_ids {
        [_, ..] -> {
          let root_ids = list.map(roots, fn(root) { root.id })
          let current_elements =
            current_elements
            |> remove_element_trees(root_ids, True)
            |> list.map(fn(element) {
              case element.id == group.id {
                True -> codegen_helpers.Element(..element, slicing: None)
                False -> element
              }
            })
          #(
            current_elements,
            overrides,
            type_slice_overrides,
            planned_slices,
            nested_value_discriminators,
            slice_discriminator_checks,
          )
        }
        [] -> {
          let type_slice_ids =
            plans
            |> list.filter_map(fn(plan) {
              case plan {
                TypeSlicePlan(slice:, ..) -> Ok(slice.id)
                ValueSlicePlan(..) -> Error(Nil)
              }
            })
          let current_elements =
            remove_element_trees(current_elements, type_slice_ids, True)
          let replacement_ids =
            plans
            |> list.flat_map(fn(plan) {
              case plan {
                ValueSlicePlan(overrides:, ..) ->
                  list.map(overrides, fn(pair) { pair.0 })
                TypeSlicePlan(..) -> []
              }
            })
          let current_elements =
            remove_element_trees(current_elements, replacement_ids, False)
          let overrides =
            plans
            |> list.flat_map(fn(plan) {
              case plan {
                ValueSlicePlan(overrides:, ..) -> overrides
                TypeSlicePlan(..) -> []
              }
            })
            |> list.fold(overrides, fn(overrides, pair) {
              dict.insert(overrides, pair.0, pair.1)
            })
          let type_slice_overrides =
            list.fold(plans, type_slice_overrides, fn(overrides, plan) {
              case plan {
                TypeSlicePlan(root_id:, fhir_type:, ..) ->
                  dict.insert(
                    overrides,
                    type_slice_key(root_id, fhir_type),
                    plan,
                  )
                ValueSlicePlan(..) -> overrides
              }
            })
          let planned_slices =
            list.fold(plans, planned_slices, fn(planned_slices, plan) {
              case plan {
                ValueSlicePlan(root_id:, ..) ->
                  dict.insert(planned_slices, root_id, plan)
                TypeSlicePlan(slice:, ..) ->
                  dict.insert(planned_slices, slice.id, plan)
              }
            })
          let nested_value_discriminators =
            list.fold(
              plans,
              nested_value_discriminators,
              fn(nested_value_discriminators, plan) {
                case plan {
                  ValueSlicePlan(root_id:, nested: [_, ..], ..) ->
                    set.insert(nested_value_discriminators, root_id)
                  _ -> nested_value_discriminators
                }
              },
            )
          #(
            current_elements,
            overrides,
            type_slice_overrides,
            planned_slices,
            nested_value_discriminators,
            slice_discriminator_checks,
          )
        }
      }
    },
  )
  |> fn(result) {
    let #(
      elements,
      overrides,
      type_slice_overrides,
      _,
      nested_value_discriminators,
      slice_discriminator_checks,
    ) = result
    #(
      elements,
      overrides,
      type_slice_overrides,
      nested_value_discriminators,
      slice_discriminator_checks,
    )
  }
}

pub fn profile_files_to_types(
  profiles_dir: String,
  preserve_slice_order: Bool,
  valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
  gen_specific_resources: Option(List(String)),
) -> #(
  String,
  String,
  dict.Dict(String, codegen_helpers.ValuesetItem),
  dict.Dict(String, codegen_helpers.VsOrCs),
  List(#(String, String, String)),
) {
  let profile_structures =
    load_profile_files(profiles_dir, gen_specific_resources)
  let required_valuesets_from_elements = fn(
    elements: List(codegen_helpers.Element),
  ) -> Set(String) {
    elements
    |> list.filter_map(fn(element) {
      case element.max, element.binding {
        "0", _ -> Error(Nil)
        _,
          Some(codegen_helpers.Binding(
            strength: "required",
            value_set: Some(value_set),
          ))
        -> Ok(value_set)
        _, _ -> Error(Nil)
      }
    })
    |> set.from_list
  }
  let resource_elements =
    list.append(
      profile_structures.resources,
      dict.values(profile_structures.datatype_profiles),
    )
    |> list.flat_map(fn(resource) {
      case resource.snapshot {
        None -> []
        Some(snapshot) -> snapshot.element
      }
    })
  let base_elements = base_structure_elements(profiles_dir, resource_elements)
  let extension_elements =
    profile_structures.extensions
    |> dict.values
    |> list.flat_map(fn(extension) {
      case extension.kind {
        SimpleExtension(element) -> [element]
        ComplexExtension(elements, _) -> elements
      }
    })
  let required_valuesets =
    valueset_acc
    |> dict.keys
    |> set.from_list
    |> set.union(required_valuesets_from_elements(resource_elements))
    |> set.union(required_valuesets_from_elements(extension_elements))
    |> set.delete("")
    |> set.delete("http://unitsofmeasure.org")
    |> set.delete("http://hl7.org/fhir/ValueSet/color-codes")
  let available_slice_valuesets =
    codegen_helpers.load_valuesets(profiles_dir, required_valuesets)
  let profile_resources =
    profile_structures.resources
    |> list.sort(fn(a, b) { string.compare(a.id, b.id) })
  let profile_resource_entries =
    list.map(profile_resources, fn(resource) {
      let assert Some(resource_type) = resource.type_
      let profile_type =
        resource.id
        |> string.replace("-", "_")
        |> codegen_helpers.to_camel_case
      let profile_type = case profile_type {
        "List" -> "Listfhir"
        _ -> profile_type
      }
      #(resource_type, profile_type, resource.url)
    })
  let profile_definitions =
    list.append(
      profile_resources,
      dict.values(profile_structures.datatype_profiles),
    )
    |> list.sort(fn(a, b) { string.compare(a.id, b.id) })
  let datatype_types =
    profile_definitions
    |> list.filter(fn(profile) { profile.kind == Some("complex-type") })
    |> list.map(fn(profile) {
      #(
        canonical_url(profile.url),
        profile.id |> string.replace("-", "_") |> codegen_helpers.to_camel_case,
      )
    })
    |> dict.from_list
  let #(extension_types, valueset_acc) =
    generate_extension_types(
      profile_structures.extensions,
      preserve_slice_order,
      valueset_acc,
    )
  let slice_types =
    codegen_slice_complex_type.slice_coding
    <> codegen_slice_complex_type.slice_coding_display
    <> codegen_slice_complex_type.slice_coding_fixeduri
    <> codegen_slice_complex_type.slice_codeableconcept(preserve_slice_order)
    <> codegen_slice_complex_type.slice_codeableconcept_display(
      preserve_slice_order,
    )
    <> codegen_slice_complex_type.slice_codeableconcept_list1

  let #(profile_complex_types, profile_resources, valueset_acc, _) =
    list.fold(
      over: profile_definitions,
      from: #(slice_types <> extension_types, "", valueset_acc, set.new()),
      with: fn(acc, resource) {
        let #(
          extension_types,
          generated_acc,
          valueset_acc,
          generated_extension_classifiers,
        ) = acc
        let assert Some(snapshot) = resource.snapshot
        let profile_elements =
          remove_profile_extension_children(
            snapshot.element,
            profile_structures.extensions,
          )
        let #(
          profile_elements,
          slice_type_overrides,
          type_slice_overrides,
          nested_value_discriminators,
          slice_discriminator_checks,
        ) =
          prepare_profile_slices(
            resource.id,
            profile_elements,
            available_slice_valuesets,
            profile_structures.datatype_profiles,
          )
        let profile_prefix = string.replace(resource.id, "-", "_")
        let profile_type = case
          dict.get(datatype_types, canonical_url(resource.url))
        {
          Ok(profile_type) -> profile_type
          Error(_) ->
            case codegen_helpers.to_camel_case(profile_prefix) {
              "List" -> "Listfhir"
              profile_type -> profile_type
            }
        }
        let slice_base_type_names =
          profile_elements
          |> list.filter_map(fn(element) {
            case
              element.slicing,
              string.ends_with(element.path, "[x]"),
              aggregate_value_slice_roots(element, profile_elements),
              element.type_
            {
              Some(codegen_helpers.Slicing(rules:, ..)), False, None, _
              | Some(codegen_helpers.Slicing(rules:, ..)),
                False,
                Some(_),
                [codegen_helpers.Type(code: "BackboneElement", ..)]
              | Some(codegen_helpers.Slicing(rules:, ..)),
                False,
                Some(_),
                [codegen_helpers.Type(code: "Element", ..)]
              | Some(codegen_helpers.Slicing(rules:, ..)), False, Some(_), []
              -> {
                let assert [_, ..rest] =
                  element.id
                  |> string.replace("-", "")
                  |> string.replace(":", ".")
                  |> string.split(".")
                let base_name =
                  [profile_prefix, ..rest]
                  |> string.join("_")
                  |> codegen_helpers.to_camel_case
                let slice_base_name = case rules {
                  "open" | "openAtEnd" -> base_name <> "Open"
                  "closed" -> base_name <> "SliceBase"
                  _ -> panic as { "unknown slicing rule " <> rules }
                }
                Ok(#(base_name, slice_base_name))
              }
              _, _, _, _ -> Error(Nil)
            }
          })
          |> dict.from_list

        let #(type_fields, type_order) =
          profile_elements
          |> list.fold(
            #(
              dict.new() |> dict.insert(profile_prefix, []),
              set.from_list([profile_prefix]),
            ),
            fn(acc, element) {
              let #(type_fields, type_order) = acc
              let path_parts =
                element.id
                |> string.replace("-", "")
                |> string.replace(":", ".")
                |> string.split(".")
              let assert [_, ..rest] = path_parts
              let path_parts = [profile_prefix, ..rest]
              let field_path = string.join(path_parts, "_")
              let parent_path =
                path_parts
                |> list.reverse
                |> list.drop(1)
                |> list.reverse
                |> string.join("_")
              let is_choice = string.ends_with(element.path, "[x]")
              let field_parent = case element.slice_name, is_choice {
                Some(_), False ->
                  path_parts
                  |> list.reverse
                  // drop 2 because putting slice element inside of element ABOVE the slice
                  // eg for UsCoreBloodPressureComponentSystolic
                  // instead of in UsCoreBloodPressureComponent it goes in UsCoreBloodPressure
                  // so that UsCoreBloodPressure can enforce 1 systolic component, 1 diastolic, list of rest of components
                  |> list.drop(2)
                  |> list.reverse
                  |> string.join("_")
                _, _ -> parent_path
              }
              let element = case
                string.ends_with(element.id, ".value"),
                set.contains(type_order, parent_path)
              {
                True, True -> {
                  let primitive_id = string.drop_end(element.id, 6)
                  case
                    list.find(profile_elements, fn(candidate) {
                      candidate.id == primitive_id
                      && profile_field_has_primitive_type(candidate, "")
                    })
                  {
                    Ok(primitive) ->
                      codegen_helpers.Element(
                        ..element,
                        type_: primitive.type_,
                        binding: primitive.binding,
                      )
                    Error(_) -> element
                  }
                }
                _, _ -> element
              }
              let fields = case dict.get(type_fields, field_parent) {
                Ok(fields) -> [element, ..fields]
                Error(_) -> [element]
              }
              let type_fields = dict.insert(type_fields, field_parent, fields)
              let type_order = case element.type_ {
                [first, ..] ->
                  case
                    first.code,
                    does_profile_restrict_complex_type(
                      set.to_list(type_order),
                      parent_path,
                    )
                  {
                    "BackboneElement", True | "Element", True ->
                      set.insert(type_order, field_path)
                    _, _ -> type_order
                  }
                [] -> type_order
              }
              let type_order = case element.base, element.slice_name {
                codegen_helpers.ElementBase(path: _, min:, max:), None
                  if min != element.min || max != element.max
                -> set.insert(type_order, parent_path)
                _, _ -> type_order
              }
              let type_order = case element.slice_name, is_choice {
                Some(_), False ->
                  case
                    set.contains(nested_value_discriminators, element.id),
                    dict.has_key(slice_type_overrides, element.id)
                  {
                    True, _ | False, False ->
                      type_order
                      |> set.insert(field_parent)
                      |> set.insert(field_path)
                    False, True -> set.insert(type_order, field_parent)
                  }
                Some(_), True -> set.insert(type_order, field_path)
                None, _ -> type_order
              }
              #(type_fields, type_order)
            },
          )
        let type_order =
          list.fold(
            list.reverse(profile_elements),
            type_order,
            fn(type_order, element) {
              let path_parts =
                element.id
                |> string.replace("-", "")
                |> string.replace(":", ".")
                |> string.split(".")
              let assert [_, ..rest] = path_parts
              let path_parts = [profile_prefix, ..rest]
              let field_path = string.join(path_parts, "_")
              let parent_path =
                path_parts
                |> list.reverse
                |> list.drop(1)
                |> list.reverse
                |> string.join("_")
              case set.contains(type_order, field_path) {
                False -> type_order
                True ->
                  case
                    parent_path != "" && dict.has_key(type_fields, parent_path)
                  {
                    True -> set.insert(type_order, parent_path)
                    False -> type_order
                  }
              }
            },
          )
          |> set.to_list
          |> list.filter(fn(type_) { dict.has_key(type_fields, type_) })
          |> list.sort(fn(a, b) { string.compare(b, a) })
        let #(generated_profile, valueset_acc) =
          list.fold(
            over: type_order,
            from: #("", valueset_acc),
            with: fn(acc, current_type) {
              let #(types_acc, valueset_acc) = acc
              let gleam_type = case current_type == profile_prefix {
                True -> profile_type
                False ->
                  current_type
                  |> string.replace("[x]", "")
                  |> codegen_helpers.to_camel_case
              }
              let gleam_type = case
                dict.get(slice_base_type_names, gleam_type)
              {
                Ok(open_name) -> open_name
                Error(_) -> gleam_type
              }
              let assert Ok(fields) = dict.get(type_fields, current_type)
              let aggregate_slice_groups =
                fields
                |> list.filter_map(fn(group) {
                  case aggregate_value_slice_roots(group, fields) {
                    Some(aggregate) -> Ok(#(group.id, aggregate))
                    None -> Error(Nil)
                  }
                })
                |> dict.from_list
              let aggregate_slice_root_ids =
                aggregate_slice_groups
                |> dict.values
                |> list.flat_map(fn(aggregate) {
                  let #(roots, _) = aggregate
                  list.filter_map(roots, fn(root) {
                    case root.min == 0 {
                      True -> Ok(root.id)
                      False -> Error(Nil)
                    }
                  })
                })
                |> set.from_list
              let fields =
                list.filter(fields, fn(element) {
                  element.max != "0"
                  && {
                    element.fixed_code == None
                    && element.fixed_uri == None
                    || {
                      let assert [_, ..rest] =
                        element.id
                        |> string.replace("-", "")
                        |> string.replace(":", ".")
                        |> string.split(".")
                      profile_field_is_primitive_slice(
                        element,
                        "",
                        type_order,
                        string.join([profile_prefix, ..rest], "_"),
                      )
                    }
                  }
                  && !set.contains(aggregate_slice_root_ids, element.id)
                  && case element.slicing {
                    Some(slicing) ->
                      slicing.rules != "closed"
                      || string.ends_with(element.path, "[x]")
                      || dict.has_key(aggregate_slice_groups, element.id)
                    None -> True
                  }
                })

              let #(
                field_source,
                choice_source,
                newfunc_args,
                newfunc_fields,
                valueset_acc,
              ) =
                list.fold(
                  over: list.reverse(fields),
                  from: #("", "", "", "", valueset_acc),
                  with: fn(acc, element) {
                    let #(
                      fields_acc,
                      choices_acc,
                      newfunc_args_acc,
                      newfunc_fields_acc,
                      valueset_acc,
                    ) = acc
                    let all_parts =
                      element.id
                      |> string.replace("-", "")
                      |> string.replace(":", ".")
                      |> string.split(".")
                    let assert [_, ..rest] = all_parts
                    let all_parts = [profile_prefix, ..rest]
                    let assert Ok(last_part) = all_parts |> list.last
                    let field_path = string.join(all_parts, "_")
                    let json_field_name = string.replace(last_part, "[x]", "")
                    let safe_field_name =
                      codegen_helpers.escape_field_name(json_field_name)
                    let field_name =
                      option.unwrap(element.slice_name, safe_field_name)
                      |> codegen_helpers.escape_field_name
                      |> codegen_helpers.to_snake_case
                    let choice_type =
                      gleam_type <> string.capitalise(safe_field_name)

                    let is_primitive_slice =
                      profile_field_is_primitive_slice(
                        element,
                        json_field_name,
                        type_order,
                        field_path,
                      )
                    let is_primitive = False

                    let #(base_field_type, valueset_acc) =
                      profile_base_field_type(
                        element,
                        all_parts,
                        field_path,
                        choice_type,
                        profile_structures.extensions,
                        type_order,
                        slice_base_type_names,
                        slice_type_overrides,
                        datatype_types,
                        valueset_acc,
                      )
                    // If named slices do not enforce the group minimum, use a
                    // variant collection whose cardinality enforces the remainder.
                    let #(base_field_type, aggregate_slice_source, valueset_acc) = case
                      dict.get(aggregate_slice_groups, element.id)
                    {
                      Error(_) -> #(base_field_type, "", valueset_acc)
                      Ok(#(roots, _)) -> {
                        let aggregate_type =
                          aggregate_slice_type_name(
                            choice_type,
                            base_field_type,
                          )
                        let #(variants, valueset_acc) =
                          list.fold(roots, #("", valueset_acc), fn(acc, root) {
                            let #(variants, valueset_acc) = acc
                            let assert Some(slice_name) = root.slice_name
                            let root_parts =
                              root.id
                              |> string.replace("-", "")
                              |> string.replace(":", ".")
                              |> string.split(".")
                            let assert [_, ..root_rest] = root_parts
                            let root_parts = [profile_prefix, ..root_rest]
                            let root_field_path = string.join(root_parts, "_")
                            let #(payload_type, valueset_acc) =
                              profile_base_field_type(
                                root,
                                root_parts,
                                root_field_path,
                                aggregate_type,
                                profile_structures.extensions,
                                type_order,
                                slice_base_type_names,
                                slice_type_overrides,
                                datatype_types,
                                valueset_acc,
                              )
                            #(
                              variants
                                <> "  "
                                <> aggregate_slice_constructor(
                                aggregate_type,
                                slice_name,
                                payload_type,
                              )
                                <> "(value: "
                                <> payload_type
                                <> ")\n",
                              valueset_acc,
                            )
                          })
                        let variants =
                          variants
                          <> "  "
                          <> aggregate_slice_constructor(
                            aggregate_type,
                            "Open",
                            base_field_type,
                          )
                          <> "(value: "
                          <> base_field_type
                          <> ")\n"
                        #(
                          aggregate_type,
                          "pub type "
                            <> aggregate_type
                            <> " {\n"
                            <> variants
                            <> "}\n\n",
                          valueset_acc,
                        )
                      }
                    }
                    let field_type = base_field_type
                    let is_resource_slice_elt =
                      preserve_slice_order
                      && element.base.max != "1"
                      && !dict.has_key(aggregate_slice_groups, element.id)
                      && !string.ends_with(element.path, "[x]")
                      && {
                        let extension_group =
                          list.any(element.type_, fn(type_) {
                            type_.code == "Extension"
                          })
                        !extension_group
                        || element.slice_name != None
                        || list.any(fields, fn(candidate) {
                          candidate.path == element.path
                          && candidate.slice_name != None
                        })
                      }
                      && case element.slice_name, element.slicing {
                        Some(_), _ | _, Some(_) -> True
                        None, None -> False
                      }
                    let field_type = case is_resource_slice_elt {
                      True ->
                        case
                          profile_extension_definition(
                            element,
                            profile_structures.extensions,
                          )
                        {
                          Some(_) ->
                            "ct.ExtensionSliceElt(" <> field_type <> ")"
                          None -> "ct.SliceElt(" <> field_type <> ")"
                        }
                      False -> field_type
                    }
                    let card_min = case
                      dict.get(aggregate_slice_groups, element.id)
                    {
                      Ok(#(_, remaining_minimum)) -> remaining_minimum
                      Error(_) ->
                        profile_field_min(
                          element,
                          is_primitive || is_primitive_slice,
                        )
                    }
                    let cardinality = case card_min, element.max {
                      min, "*" if min > 3 ->
                        panic as {
                          "unsupported cardinality "
                          <> int.to_string(min)
                          <> "..* for "
                          <> element.id
                        }
                      min, max if min != 0 && min != 1 && max != "*" ->
                        panic as {
                          "unsupported cardinality "
                          <> int.to_string(min)
                          <> ".."
                          <> max
                          <> " for "
                          <> element.id
                        }
                      _, _ ->
                        codegen_helpers.cardinality(
                          field_type,
                          card_min,
                          element.max,
                        )
                    }
                    let #(newfunc_arg, newfunc_field) =
                      codegen_helpers.new_fn_arg_and_field(
                        field_name,
                        field_type,
                        card_min,
                        element.max,
                        is_primitive,
                      )
                    let newfunc_field = case
                      current_type == profile_prefix,
                      field_name
                    {
                      True, "meta" -> "    meta: Some(ct.Meta(
                          id: None,
                          extension: [],
                          version_id: None,
                          last_updated: None,
                          source: None,
                          profile: [\"" <> resource.url <> "\"],
                          security: [],
                          tag: [],
                        )),\n"
                      _, _ -> newfunc_field
                    }

                    let #(new_choice_source, valueset_acc) = case
                      element.type_
                    {
                      [] | [_] -> #("", valueset_acc)
                      choice_types -> {
                        let #(variants, sliced_types, valueset_acc) =
                          list.fold(
                            over: choice_types,
                            from: #("", "", valueset_acc),
                            with: fn(acc, choice) {
                              let #(
                                variants_acc,
                                sliced_types_acc,
                                valueset_acc,
                              ) = acc
                              let #(variant_type, sliced_type, valueset_acc) = case
                                dict.get(
                                  type_slice_overrides,
                                  type_slice_key(element.id, choice.code),
                                )
                              {
                                Ok(TypeSlicePlan(slice:, children: [], ..)) -> {
                                  let #(variant_type, valueset_acc) =
                                    codegen_helpers.string_to_type(
                                      choice.code,
                                      all_parts,
                                      slice,
                                      codegen_helpers.Resources,
                                      valueset_acc,
                                    )
                                  #(variant_type, "", valueset_acc)
                                }
                                Ok(TypeSlicePlan(slice: _, children:, ..)) -> {
                                  let sliced_name =
                                    choice_type
                                    <> string.capitalise(choice.code)
                                    <> "Sliced"
                                  let aggregate_slice_groups =
                                    children
                                    |> list.filter_map(fn(group) {
                                      case
                                        aggregate_value_slice_roots(
                                          group,
                                          children,
                                        )
                                      {
                                        Some(aggregate) ->
                                          Ok(#(group.id, aggregate))
                                        None -> Error(Nil)
                                      }
                                    })
                                    |> dict.from_list
                                  let omitted_slice_roots =
                                    aggregate_slice_groups
                                    |> dict.values
                                    |> list.flat_map(fn(aggregate) {
                                      let #(roots, _) = aggregate
                                      list.filter(roots, fn(root) {
                                        root.min == 0
                                      })
                                    })
                                  let type_fields =
                                    list.filter(children, fn(child) {
                                      child.max != "0"
                                      && !list.any(
                                        omitted_slice_roots,
                                        fn(root) { root.id == child.id },
                                      )
                                      && case child.slicing {
                                        Some(slicing) ->
                                          slicing.rules != "closed"
                                          || string.ends_with(child.path, "[x]")
                                          || dict.has_key(
                                            aggregate_slice_groups,
                                            child.id,
                                          )
                                        None -> True
                                      }
                                    })
                                  let #(
                                    fields,
                                    newfunc_args,
                                    newfunc_fields,
                                    valueset_acc,
                                  ) =
                                    type_fields
                                    |> list.filter(fn(child) {
                                      child.fixed_code == None
                                      && child.fixed_uri == None
                                    })
                                    |> list.fold(
                                      #("", "", "", valueset_acc),
                                      fn(acc, child) {
                                        let #(
                                          fields,
                                          newfunc_args,
                                          newfunc_fields,
                                          valueset_acc,
                                        ) = acc
                                        let assert Ok(json_field_name) =
                                          child.path
                                          |> string.split(".")
                                          |> list.last
                                        let field_name = case child.slice_name {
                                          Some(slice_name) -> slice_name
                                          None -> json_field_name
                                        }
                                        let field_name =
                                          field_name
                                          |> codegen_helpers.escape_field_name
                                          |> codegen_helpers.to_snake_case
                                        let all_parts = [
                                          sliced_name,
                                          field_name,
                                        ]
                                        let field_path =
                                          string.join(all_parts, "_")
                                        let #(gleam_type, valueset_acc) =
                                          profile_base_field_type(
                                            child,
                                            all_parts,
                                            field_path,
                                            "",
                                            profile_structures.extensions,
                                            type_order,
                                            slice_base_type_names,
                                            slice_type_overrides,
                                            datatype_types,
                                            valueset_acc,
                                          )
                                        let is_slice_elt =
                                          preserve_slice_order
                                          && child.base.max != "1"
                                          && !dict.has_key(
                                            aggregate_slice_groups,
                                            child.id,
                                          )
                                          && !string.ends_with(
                                            child.path,
                                            "[x]",
                                          )
                                          && {
                                            let extension_group =
                                              list.any(child.type_, fn(type_) {
                                                type_.code == "Extension"
                                              })
                                            !extension_group
                                            || child.slice_name != None
                                            || list.any(
                                              type_fields,
                                              fn(candidate) {
                                                candidate.path == child.path
                                                && candidate.slice_name != None
                                              },
                                            )
                                          }
                                          && case
                                            child.slice_name,
                                            child.slicing
                                          {
                                            Some(_), _ | _, Some(_) -> True
                                            None, None -> False
                                          }
                                        let gleam_type = case is_slice_elt {
                                          True ->
                                            case
                                              profile_extension_definition(
                                                child,
                                                profile_structures.extensions,
                                              )
                                            {
                                              Some(_) ->
                                                "ct.ExtensionSliceElt("
                                                <> gleam_type
                                                <> ")"
                                              None ->
                                                "ct.SliceElt("
                                                <> gleam_type
                                                <> ")"
                                            }
                                          False -> gleam_type
                                        }
                                        let child_min =
                                          profile_field_min(child, False)
                                        let #(newfunc_arg, newfunc_field) =
                                          codegen_helpers.new_fn_arg_and_field(
                                            field_name,
                                            gleam_type,
                                            child_min,
                                            child.max,
                                            False,
                                          )
                                        #(
                                          fields
                                            <> "    "
                                            <> field_name
                                            <> ": "
                                            <> codegen_helpers.cardinality(
                                            gleam_type,
                                            child_min,
                                            child.max,
                                          )
                                            <> ",\n",
                                          newfunc_args <> newfunc_arg,
                                          newfunc_fields <> newfunc_field,
                                          valueset_acc,
                                        )
                                      },
                                    )
                                  #(
                                    sliced_name,
                                    "pub type "
                                      <> sliced_name
                                      <> " {\n  "
                                      <> sliced_name
                                      <> "(\n"
                                      <> fields
                                      <> "  )\n}\n\n"
                                      <> "pub fn "
                                      <> codegen_helpers.to_snake_case(
                                      sliced_name,
                                    )
                                      <> "_new("
                                      <> newfunc_args
                                      <> ") -> "
                                      <> sliced_name
                                      <> " {\n  "
                                      <> sliced_name
                                      <> "("
                                      <> newfunc_fields
                                      <> ")\n}\n\n",
                                    valueset_acc,
                                  )
                                }
                                Error(_) | Ok(ValueSlicePlan(..)) -> {
                                  let #(variant_type, valueset_acc) =
                                    profile_base_field_type(
                                      codegen_helpers.Element(..element, type_: [
                                        choice,
                                      ]),
                                      all_parts,
                                      "",
                                      choice_type,
                                      profile_structures.extensions,
                                      type_order,
                                      slice_base_type_names,
                                      slice_type_overrides,
                                      datatype_types,
                                      valueset_acc,
                                    )
                                  #(variant_type, "", valueset_acc)
                                }
                              }
                              #(
                                variants_acc
                                  <> "  "
                                  <> choice_type
                                  <> string.capitalise(choice.code)
                                  <> "(value: "
                                  <> variant_type
                                  <> ")\n",
                                sliced_types_acc <> sliced_type,
                                valueset_acc,
                              )
                            },
                          )
                        #(
                          "pub type "
                            <> choice_type
                            <> " {\n"
                            <> variants
                            <> "}\n\n"
                            <> sliced_types,
                          valueset_acc,
                        )
                      }
                    }

                    let new_choice_source =
                      aggregate_slice_source <> new_choice_source
                    #(
                      fields_acc
                        <> "    "
                        <> field_name
                        <> ": "
                        <> cardinality
                        <> ",\n",
                      new_choice_source <> choices_acc,
                      newfunc_args_acc <> newfunc_arg,
                      newfunc_fields_acc <> newfunc_field,
                      valueset_acc,
                    )
                  },
                )

              let declaration =
                "pub type "
                <> gleam_type
                <> " {\n  "
                <> gleam_type
                <> "(\n"
                <> field_source
                <> "  )\n}\n\n"
                <> "pub fn "
                <> codegen_helpers.to_snake_case(gleam_type)
                <> "_new("
                <> newfunc_args
                <> ") -> "
                <> gleam_type
                <> " {\n  "
                <> gleam_type
                <> "("
                <> newfunc_fields
                <> ")\n}\n\n"
                <> choice_source
              #(declaration <> types_acc, valueset_acc)
            },
          )

        let assert Some(resource_type) = resource.type_
        let #(profile_encoders, valueset_acc) =
          codegen_profile_json.generate_to_json(
            resource_type,
            resource.kind == Some("resource"),
            snapshot.element,
            profile_prefix,
            profile_type,
            type_order,
            type_fields,
            profile_structures.extensions,
            slice_base_type_names,
            slice_type_overrides,
            datatype_types,
            type_slice_overrides,
            preserve_slice_order,
            valueset_acc,
          )
        let #(profile_decoders, generated_extension_classifiers) =
          codegen_profile_json.generate_decoders(
            resource_type,
            resource.kind == Some("resource"),
            snapshot.element,
            profile_prefix,
            profile_type,
            type_order,
            type_fields,
            profile_structures.extensions,
            slice_base_type_names,
            slice_type_overrides,
            datatype_types,
            nested_value_discriminators,
            slice_discriminator_checks,
            type_slice_overrides,
            preserve_slice_order,
            valueset_acc,
            available_slice_valuesets,
            base_elements,
            generated_extension_classifiers,
          )

        #(
          extension_types,
          generated_acc
            <> generated_profile
            <> profile_encoders
            <> profile_decoders,
          valueset_acc,
          generated_extension_classifiers,
        )
      },
    )
  let result_search_source = case
    string.contains(profile_resources, "find_required_elt_and_rest_result("),
    string.contains(profile_resources, "find_optional_elt_and_rest_result("),
    string.contains(
      profile_resources,
      "find_at_least_n_elts_and_rest_result_or_failure(",
    )
  {
    False, False, False -> ""
    required, optional, repeated ->
      codegen_bound_coding.find_elt_and_rest_result(False)
      <> case required {
        True -> codegen_bound_coding.find_required_elt_and_rest_result
        False -> ""
      }
      <> case optional {
        True -> codegen_bound_coding.find_optional_elt_and_rest_result
        False -> ""
      }
      <> case repeated {
        True ->
          codegen_bound_coding.find_at_least_n_elts_and_rest_result
          <> codegen_bound_coding.find_at_least_n_elts_and_rest_result_or_failure
        False -> ""
      }
  }
  #(
    profile_complex_types,
    case string.contains(profile_resources, "result_or_decode_failure(") {
      True -> codegen_decode.result_or_decode_failure
      False -> ""
    }
      <> result_search_source
      <> case string.contains(profile_resources, "slice_acc_errors(") {
      True -> codegen_profile_json.slice_acc_errors_source
      False -> ""
    }
      <> profile_resources,
    valueset_acc,
    available_slice_valuesets,
    profile_resource_entries,
  )
}
