import codegen_bound_coding
import codegen_decode
import codegen_helpers
import codegen_profile_json.{
  type ExtensionDefinition, type PrimitiveExtensionValue, type SliceFieldType,
  type SlicePlan, BoundCodeableconceptSlice, BoundCodingSlice, ComplexExtension,
  ExtensionDefinition, FixedSliceType, FixedValueDiscriminator,
  PrimitiveExtensionValue, SimpleExtension, TypeSlicePlan, ValueSlicePlan,
  aggregate_slice_constructor, aggregate_slice_type_name,
  aggregate_value_slice_roots, does_profile_restrict_complex_type,
  extension_field_name, extension_field_to_json_call, find_element,
  profile_base_field_type, profile_extension_definition, profile_extension_type,
  profile_field_has_primitive_type, profile_field_is_primitive_slice,
  profile_field_min,
}
import codegen_slice_complex_type
import filepath
import gleam/dict
import gleam/dynamic/decode
import gleam/int
import gleam/io
import gleam/json
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/order
import gleam/result
import gleam/set.{type Set}
import gleam/string
import simplifile

type SliceHelper {
  CodingSystem
  CodingSystemCode
  CodingSystemCodeDisplay
  CodingSystemRequiredCodeDisplay
  ConceptSystem
  ConceptSystemCode
  ConceptSystemCodeDisplay
  ConceptList1System
  ConceptList1SystemCode
  ConceptList1SystemCodeDisplay
}

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
  let directories =
    codegen_helpers.package_directories(profiles_dir) |> list.reverse
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
            Error(_) -> {
              // A child can itself be a complex extension with no value[x].
              case
                list.any(snapshot.element, fn(child) {
                  string.starts_with(child.id, slice.id <> ".extension:")
                })
              {
                False ->
                  case slice.type_ {
                    [codegen_helpers.Type(profile: [_, ..], ..)] ->
                      Ok(
                        codegen_helpers.Element(
                          ..slice,
                          id: "Extension." <> slice_name,
                          path: "Extension." <> slice_name,
                          slice_name: None,
                          slicing: None,
                        ),
                      )
                    _ -> Error(Nil)
                  }
                True -> {
                  let assert [extension_type] = slice.type_
                  Ok(
                    codegen_helpers.Element(
                      ..slice,
                      id: "Extension." <> slice_name,
                      path: "Extension." <> slice_name,
                      slice_name: None,
                      slicing: None,
                      type_: [
                        codegen_helpers.Type(..extension_type, profile: [
                          case string.contains(resource.url, "#") {
                            True ->
                              resource.url <> string.drop_start(slice.id, 9)
                            False -> resource.url <> "#" <> slice.id
                          },
                        ]),
                      ],
                    ),
                  )
                }
              }
            }
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
  inline_profiles: List(codegen_helpers.Resource),
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
                True ->
                  Ok(
                    read_structure_definition(filepath.join(
                      package_dir,
                      file.filename,
                    )),
                  )
              }
            _, _ -> Error(Nil)
          }
        })
      }
    }
  })
  |> list.append(inline_profiles)
  |> list.flat_map(fn(resource) {
    let assert Some(snapshot) = resource.snapshot
    let nested =
      snapshot.element
      |> list.filter(fn(element) {
        element.slice_name != None
        && element.max != "0"
        && list.any(snapshot.element, fn(child) {
          string.starts_with(child.id, element.id <> ".extension:")
        })
      })
      |> list.map(fn(element) {
        let elements =
          snapshot.element
          |> list.filter(fn(child) {
            string.starts_with(child.id, element.id <> ".")
          })
          |> list.map(fn(child) {
            codegen_helpers.Element(
              ..child,
              id: "Extension"
                <> string.drop_start(child.id, string.length(element.id)),
              path: "Extension"
                <> string.drop_start(child.path, string.length(element.path)),
            )
          })
        codegen_helpers.Resource(
          ..resource,
          id: resource.id
            <> "_"
            <> string.replace(
              string.drop_start(element.id, 20),
              ".extension:",
              "_",
            ),
          url: case string.contains(resource.url, "#") {
            True -> resource.url <> string.drop_start(element.id, 9)
            False -> resource.url <> "#" <> element.id
          },
          snapshot: Some(codegen_helpers.Snapshot(element: elements)),
        )
      })
    [resource, ..nested]
  })
  |> list.filter_map(fn(resource) {
    let url = resource.url
    case extension_fields(resource) {
      None -> Error(Nil)
      Some(kind) -> {
        let name =
          resource.id
          |> string.replace("-", "_")
          |> string.replace(".", "_")
          |> string.replace("[x]", "")
          |> codegen_helpers.to_camel_case
        let fields = case kind {
          SimpleExtension(field) -> [field]
          ComplexExtension(fields, _) -> fields
        }
        let assert Some(snapshot) = resource.snapshot
        let primitive_values =
          fields
          |> list.flat_map(fn(field) {
            list.map(field.type_, fn(type_) {
              #(field, codegen_helpers.Element(..field, type_: [type_]))
            })
          })
          |> list.filter(fn(pair) {
            profile_field_has_primitive_type(pair.1, "")
          })
          |> list.filter_map(fn(pair) {
            let #(original, field) = pair
            let assert [type_] = field.type_
            let key = case original.type_ {
              [_] -> field.id
              _ -> field.id <> "|" <> type_.code
            }
            let source_id = case kind {
              SimpleExtension(_) -> field.id
              ComplexExtension([only], _) if only.path == "Extension.value[x]" ->
                field.id
              _ ->
                "Extension.extension:"
                <> string.drop_start(field.id, string.length("Extension."))
                <> ".value[x]"
            }
            let source =
              snapshot.element
              |> list.find(fn(slice) {
                string.starts_with(slice.id, source_id <> ":")
                && list.length(slice.type_) == 1
                && list.any(slice.type_, fn(candidate) {
                  candidate.code == type_.code
                })
              })
              |> result.unwrap(codegen_helpers.Element(..field, id: source_id))
            let source_id = source.id
            let children =
              list.filter(snapshot.element, fn(child) {
                string.starts_with(child.id, source_id <> ".")
              })
            case
              list.any(children, fn(child) {
                child.max != "0"
                && {
                  child.slice_name != None
                  || {
                    child.id == source_id <> ".extension"
                    && {
                      child.slicing != None
                      || child.min != child.base.min
                      || child.max != child.base.max
                    }
                  }
                }
              })
            {
              False -> Error(Nil)
              True -> {
                let value_name =
                  name
                  <> case extension_field_name(field) {
                    "value" -> "Value"
                    field_name ->
                      codegen_helpers.to_camel_case(field_name) <> "Value"
                  }
                let value_name = case original.type_ {
                  [_] -> value_name
                  _ ->
                    name
                    <> case extension_field_name(field) {
                      "value" -> ""
                      field_name -> codegen_helpers.to_camel_case(field_name)
                    }
                    <> codegen_helpers.to_camel_case(type_.code)
                    <> "Value"
                }
                let elements = [
                  codegen_helpers.Element(
                    ..source,
                    id: value_name,
                    path: value_name,
                    slicing: None,
                    slice_name: None,
                  ),
                  ..list.map(children, fn(child) {
                    codegen_helpers.Element(
                      ..child,
                      id: value_name
                        <> string.drop_start(child.id, string.length(source_id)),
                      path: value_name
                        <> string.drop_start(
                          child.path,
                          string.length(field.path),
                        ),
                    )
                  })
                ]
                Ok(#(key, PrimitiveExtensionValue(name: value_name, elements:)))
              }
            }
          })
          |> dict.from_list
        let instance_url =
          snapshot.element
          |> list.find(fn(element) { element.id == "Extension.url" })
          |> result.map(fn(element) { option.unwrap(element.fixed_uri, url) })
          |> result.unwrap(url)
        Ok(#(
          url,
          ExtensionDefinition(
            name:,
            url: instance_url,
            kind:,
            primitive_values:,
          ),
        ))
      }
    }
  })
  |> dict.from_list
  |> fn(definitions) {
    let urls =
      dict.to_list(definitions)
      |> list.fold(referenced_urls, fn(urls, item) {
        case set.contains(urls, item.0) {
          False -> urls
          True -> {
            let fields = case item.1.kind {
              SimpleExtension(field) -> [field]
              ComplexExtension(fields, _) -> fields
            }
            let primitive_children =
              item.1.primitive_values
              |> dict.values
              |> list.flat_map(fn(value) { value.elements })
            let referenced =
              list.append(fields, primitive_children)
              |> list.flat_map(fn(field) {
                list.flat_map(field.type_, fn(type_) { type_.profile })
              })
            set.union(urls, set.from_list(list.map(referenced, canonical_url)))
          }
        }
      })
    case set.size(urls) > set.size(referenced_urls) {
      True -> extension_definitions(profiles_dir, urls, inline_profiles)
      False -> dict.filter(definitions, fn(url, _) { set.contains(urls, url) })
    }
  }
}

fn load_profile_files(
  profiles_dir: String,
  gen_specific_resources: Option(List(String)),
) -> ProfileFiles {
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
  // Keep local extension constraints instead of discarding their descendants.
  let #(profiles, inline_profiles) =
    list.append(resources, dict.values(datatype_profiles))
    |> list.fold(#([], []), fn(acc, resource) {
      let #(profiles, inline_profiles) = acc
      let assert Some(snapshot) = resource.snapshot
      let roots =
        snapshot.element
        |> list.filter(fn(element) {
          element.slice_name != None
          && list.any(element.type_, fn(type_) { type_.code == "Extension" })
          && list.any(snapshot.element, fn(child) {
            string.starts_with(child.id, element.id <> ".")
          })
        })
      let elements =
        list.map(snapshot.element, fn(element) {
          case list.any(roots, fn(root) { root.id == element.id }) {
            False -> element
            True -> {
              let assert [type_] = element.type_
              codegen_helpers.Element(..element, type_: [
                codegen_helpers.Type(..type_, profile: [
                  resource.url <> "#" <> element.id,
                ]),
              ])
            }
          }
        })
      let inline_profiles =
        list.fold(roots, inline_profiles, fn(profiles, root) {
          let elements =
            elements
            |> list.filter(fn(child) {
              string.starts_with(child.id, root.id <> ".")
            })
            |> list.map(fn(child) {
              codegen_helpers.Element(
                ..child,
                id: "Extension"
                  <> string.drop_start(child.id, string.length(root.id)),
                path: "Extension"
                  <> string.drop_start(child.path, string.length(root.path)),
              )
            })
          [
            codegen_helpers.Resource(
              ..resource,
              id: resource.id
                <> "_"
                <> string.replace(string.replace(root.id, ".", "_"), ":", "_"),
              url: resource.url <> "#" <> root.id,
              kind: Some("complex-type"),
              type_: Some("Extension"),
              snapshot: Some(codegen_helpers.Snapshot(element: elements)),
            ),
            ..profiles
          ]
        })
      #(
        [
          codegen_helpers.Resource(
            ..resource,
            snapshot: Some(codegen_helpers.Snapshot(element: elements)),
          ),
          ..profiles
        ],
        inline_profiles,
      )
    })
  let resources =
    profiles |> list.filter(fn(profile) { profile.kind == Some("resource") })
  let datatype_profiles =
    profiles
    |> list.filter(fn(profile) { profile.kind == Some("complex-type") })
    |> list.map(fn(profile) { #(canonical_url(profile.url), profile) })
    |> dict.from_list
  let extensions =
    profiles
    |> referenced_extension_urls
    |> extension_definitions(profiles_dir, _, inline_profiles)
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
      let fields = case extension.kind {
        SimpleExtension(element) -> [element]
        ComplexExtension(elements, _) -> elements
      }
      list.append(
        fields,
        extension.primitive_values
          |> dict.values
          |> list.flat_map(fn(value) { value.elements }),
      )
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
  primitive_values: dict.Dict(String, PrimitiveExtensionValue),
  valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
  datatype_types: dict.Dict(String, String),
  constructors: dict.Dict(String, codegen_profile_json.ConstructorDefinition),
) -> #(
  String,
  String,
  dict.Dict(String, codegen_helpers.ValuesetItem),
  dict.Dict(String, codegen_profile_json.ConstructorDefinition),
) {
  let field_name = extension_field_name(element)
  case element.type_ {
    [type_] -> {
      let #(gleam_type, valueset_acc) =
        codegen_profile_json.profile_value_type(
          type_,
          element,
          [extension_name, field_name],
          codegen_helpers.ComplexTypes,
          datatype_types,
          valueset_acc,
        )
      #(gleam_type, "", valueset_acc, constructors)
    }
    types -> {
      let choice_name = extension_name <> string.capitalise(field_name)
      let #(variants, valueset_acc, constructors) =
        list.fold(types, #("", valueset_acc, constructors), fn(acc, type_) {
          let #(variants, valueset_acc, constructors) = acc
          let #(gleam_type, valueset_acc) =
            codegen_profile_json.profile_value_type(
              type_,
              codegen_helpers.Element(..element, type_: [type_]),
              [extension_name, field_name],
              codegen_helpers.ComplexTypes,
              datatype_types,
              valueset_acc,
            )
          let gleam_type = case
            dict.get(primitive_values, element.id <> "|" <> type_.code)
          {
            Ok(PrimitiveExtensionValue(name:, ..)) -> name
            Error(_) -> gleam_type
          }
          #(
            variants
              <> "  "
              <> choice_name
              <> string.capitalise(type_.code)
              <> "(value: "
              <> gleam_type
              <> ")\n",
            valueset_acc,
            case variants {
              "" ->
                dict.insert(
                  constructors,
                  codegen_profile_json.constructor_key(
                    codegen_helpers.ComplexTypes,
                    choice_name,
                  ),
                  codegen_profile_json.ChoiceConstructor(
                    codegen_helpers.ComplexTypes,
                    choice_name <> string.capitalise(type_.code),
                    gleam_type,
                  ),
                )
              _ -> constructors
            },
          )
        })
      #(
        choice_name,
        "pub type " <> choice_name <> " {\n" <> variants <> "}\n\n",
        valueset_acc,
        constructors,
      )
    }
  }
}

fn generate_extension_types(
  extensions: dict.Dict(String, ExtensionDefinition),
  preserve_slice_order: Bool,
  valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
  datatype_types: dict.Dict(String, String),
) -> #(
  String,
  dict.Dict(String, codegen_helpers.ValuesetItem),
  dict.Dict(String, codegen_profile_json.ConstructorDefinition),
) {
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
  |> list.fold(
    #(extension_slice_elt_source, valueset_acc, dict.new()),
    fn(acc, extension) {
      let #(source, valueset_acc, constructors) = acc
      case extension.kind {
        SimpleExtension(_) -> #(source, valueset_acc, constructors)
        ComplexExtension([], _) -> #(source, valueset_acc, constructors)
        ComplexExtension(fields, slicing_rules) -> {
          let open = slicing_rules != "closed"
          let initial_field_acc = #(
            "",
            "",
            "",
            "",
            "",
            valueset_acc,
            [],
            constructors,
          )
          let #(
            field_source,
            choice_source,
            newfunc_args,
            newfunc_fields,
            children_source,
            valueset_acc,
            constructor_arguments,
            constructors,
          ) =
            list.fold(fields, initial_field_acc, fn(acc, field) {
              let #(
                field_source,
                choice_source,
                newfunc_args,
                newfunc_fields,
                children_source,
                valueset_acc,
                constructor_arguments,
                constructors,
              ) = acc
              let #(field_type, new_choice, valueset_acc, constructors) =
                extension_field_type(
                  extension.name,
                  field,
                  extension.primitive_values,
                  valueset_acc,
                  datatype_types,
                  constructors,
                )
              let #(field_type, valueset_acc) = case
                profile_extension_type(
                  codegen_helpers.ComplexTypes,
                  field,
                  extensions,
                  valueset_acc,
                  datatype_types,
                )
              {
                Some(resolved) -> resolved
                None -> #(
                  case dict.get(extension.primitive_values, field.id) {
                    Ok(PrimitiveExtensionValue(name:, ..)) -> name
                    Error(_) -> field_type
                  },
                  valueset_acc,
                )
              }
              let stored_field_type = case preserve_slice_order {
                True -> "ExtensionSliceElt(" <> field_type <> ")"
                False -> field_type
              }
              let field_name = codegen_helpers.field_name(field)
              let #(newfunc_arg, newfunc_field, required_argument) =
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
                    extension.primitive_values,
                    profile_extension_definition(field, extensions),
                    datatype_types,
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
              let field_value = "value." <> field_name
              let field_max = case field.max {
                "0" | "1" -> field.max
                _ -> "*"
              }
              let new_children_source = case field.min, field_max {
                0, "1" ->
                  "\n  let children = case "
                  <> field_value
                  <> " {\n    Some(value) -> ["
                  <> to_json("value")
                  <> ", ..children]\n    None -> children\n  }"
                1, "1" ->
                  "\n  let children = ["
                  <> to_json(field_value)
                  <> ", ..children]"
                0, "*" ->
                  "\n  let children = list.append(list.map("
                  <> field_value
                  <> ", fn(value) { "
                  <> to_json("value")
                  <> " }), children)"
                1, "*" ->
                  "\n  let children = list.append(["
                  <> to_json(field_value <> ".first")
                  <> ", ..list.map("
                  <> field_value
                  <> ".rest, fn(value) { "
                  <> to_json("value")
                  <> " })], children)"
                2, "*" ->
                  "\n  let children = list.append(["
                  <> to_json(field_value <> ".first")
                  <> ", "
                  <> to_json(field_value <> ".second")
                  <> ", ..list.map("
                  <> field_value
                  <> ".rest, fn(value) { "
                  <> to_json("value")
                  <> " })], children)"
                3, "*" ->
                  "\n  let children = list.append(["
                  <> to_json(field_value <> ".first")
                  <> ", "
                  <> to_json(field_value <> ".second")
                  <> ", "
                  <> to_json(field_value <> ".third")
                  <> ", ..list.map("
                  <> field_value
                  <> ".rest, fn(value) { "
                  <> to_json("value")
                  <> " })], children)"
                0, _ ->
                  "\n  let children = list.append(list.map("
                  <> field_value
                  <> ", fn(value) { "
                  <> to_json("value")
                  <> " }), children)"
                _, _ -> panic as "unsupported extension cardinality"
              }
              #(
                field_source
                  <> case field.max {
                  "0" | "1" | "*" -> ""
                  _ -> "    // TODO enforce max somehow\n"
                }
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
                children_source <> new_children_source,
                valueset_acc,
                case required_argument {
                  Some(argument) -> [argument, ..constructor_arguments]
                  None -> constructor_arguments
                },
                constructors,
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
          let initial_children = case open, preserve_slice_order {
            False, _ -> "  let children = []"
            True, False ->
              "  let children = list.map(value.extension, extension_to_json)"
            True, True ->
              "  let children = list.map(value.extension, fn(value) { SliceElt(extension_to_json(value.value), value.internal_gleam_fhir_index) })"
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
            initial_children
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
          let encoder_body = case fields {
            [codegen_helpers.Element(path: "Extension.value[x]", ..) as field] -> {
              let #(field_type, _, _, _) =
                extension_field_type(
                  extension.name,
                  field,
                  extension.primitive_values,
                  valueset_acc,
                  datatype_types,
                  constructors,
                )
              let field_name = codegen_helpers.field_name(field)
              let field_value = case field.min {
                0 -> "choice_value"
                _ -> "value." <> field_name
              }
              let encoded =
                extension_field_to_json_call(
                  extension.name,
                  field,
                  field_type,
                  case preserve_slice_order {
                    True -> field_value <> ".value"
                    False -> field_value
                  },
                  case preserve_slice_order {
                    True -> Some("id")
                    False -> None
                  },
                  extension.primitive_values,
                  profile_extension_definition(field, extensions),
                  datatype_types,
                )
                |> string.replace(
                  "json.string(\"value[x]\")",
                  "json.string(url)",
                )
              let encoded = case field.min {
                0 ->
                  "case "
                  <> "value."
                  <> field_name
                  <> " { Some(choice_value) -> "
                  <> encoded
                  <> " None -> json.object([#(\"url\", json.string(url))]) }"
                _ -> encoded
              }
              "  " <> encoded <> "\n}\n\n"
            }
            _ -> encoder_body
          }
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
            dict.insert(
              constructors,
              codegen_profile_json.constructor_key(
                codegen_helpers.ComplexTypes,
                extension.name,
              ),
              codegen_profile_json.RecordConstructor(
                codegen_helpers.ComplexTypes,
                list.reverse(constructor_arguments),
                [],
              ),
            ),
          )
        }
      }
    },
  )
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
              available: True,
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
              available: True,
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
                  available: True,
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
      Ok(
        TypeSlicePlan(
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
          descendants: case profile_field_has_primitive_type(root, "") {
            True -> []
            False ->
              list.filter(elements, fn(element) {
                let prefix = root.id <> "."
                string.starts_with(element.id, prefix)
                && string.contains(
                  string.drop_start(element.id, string.length(prefix)),
                  ".",
                )
              })
          },
        ),
      )
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
  base_elements: dict.Dict(String, codegen_helpers.Element),
  extensions: dict.Dict(String, ExtensionDefinition),
) -> #(
  List(codegen_helpers.Element),
  dict.Dict(String, SliceFieldType),
  dict.Dict(String, SlicePlan),
  Set(String),
  dict.Dict(String, SliceFieldType),
) {
  let groups =
    elements
    |> list.filter(fn(element) {
      element.slicing != None && !is_extension_slicing(element)
    })
    |> list.sort(fn(a, b) { string.compare(b.id, a.id) })

  // Reuse a referenced datatype for optional slices without inline constraints.
  // Its decoder checks the profile constraints and keeps primitive extensions.
  let referenced_slice_ids =
    groups
    |> list.flat_map(fn(group) {
      let assert Some(slicing) = group.slicing
      direct_slice_roots(group, elements)
      |> list.filter_map(fn(root) {
        use _ <- result.try(case root.min {
          0 -> Ok(Nil)
          _ -> Error(Nil)
        })
        use _ <- result.try(case root.type_ {
          [codegen_helpers.Type(profile: [url], ..)] -> {
            use profile <- result.try(dict.get(
              datatype_profiles,
              canonical_url(url),
            ))
            use snapshot <- result.try(option.to_result(profile.snapshot, Nil))
            use profile_root <- result.try(list.first(snapshot.element))
            let supported = case slicing.discriminator {
              [codegen_helpers.Discriminator(type_: "profile", path: "$this")] ->
                True
              [_, ..] ->
                only_value_or_pattern_discriminators(slicing)
                && list.all(slicing.discriminator, fn(discriminator) {
                  case
                    find_element(
                      snapshot.element,
                      profile_root.id <> "." <> discriminator.path,
                    )
                  {
                    Ok(child) ->
                      child.fixed_code != None || child.fixed_uri != None
                    Error(_) -> False
                  }
                })
              [] -> False
            }
            case supported {
              True -> Ok(Nil)
              False -> Error(Nil)
            }
          }
          _ -> Error(Nil)
        })
        case
          list.any(elements, fn(child) {
            string.starts_with(child.id, root.id <> ".")
          })
        {
          True -> Error(Nil)
          False -> Ok(root.id)
        }
      })
    })
    |> set.from_list

  let profiled_datatype_children =
    elements
    |> list.filter(fn(element) {
      !set.contains(referenced_slice_ids, element.id)
      && list.length(element.type_) == 1
      && {
        element.slice_name != None
        || list.any(elements, fn(child) {
          string.starts_with(child.id, element.id <> ".")
        })
      }
    })
    |> list.flat_map(fn(root) {
      root.type_
      |> list.flat_map(fn(type_) {
        let prefix = type_.code <> "."
        codegen_profile_json.resolve_datatype_profiles(type_, datatype_profiles)
        |> fn(profiles) {
          case profiles {
            [profile] -> Ok(profile)
            _ -> Error(Nil)
          }
        }
        |> result.map(fn(profile) {
          case profile.snapshot {
            None -> []
            Some(snapshot) ->
              remove_profile_extension_children(snapshot.element, extensions)
              |> list.filter_map(fn(child) {
                case string.starts_with(child.id, prefix) {
                  False -> Error(Nil)
                  True -> {
                    let suffix =
                      string.drop_start(child.id, string.length(type_.code))
                    let path_suffix =
                      string.drop_start(child.path, string.length(type_.code))
                    let child_id = root.id <> suffix
                    case find_element(elements, child_id) {
                      Ok(existing) -> {
                        let fixed_uri = case
                          existing.fixed_uri,
                          child.fixed_uri
                        {
                          Some(value), Some(inherited) if value != inherited ->
                            panic as {
                              "conflicting URI constraints for " <> child_id
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
                              "conflicting code constraints for " <> child_id
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
                            slicing: case existing.slicing {
                              Some(_) -> existing.slicing
                              None -> child.slicing
                            },
                            type_: list.map(existing.type_, fn(local_type) {
                              case
                                list.find(child.type_, fn(inherited_type) {
                                  inherited_type.code == local_type.code
                                })
                              {
                                Ok(inherited_type) ->
                                  codegen_helpers.Type(
                                    ..local_type,
                                    profile: case local_type.profile {
                                      [] -> inherited_type.profile
                                      profiles -> profiles
                                    },
                                    target_profile: case
                                      local_type.target_profile
                                    {
                                      [] -> inherited_type.target_profile
                                      profiles -> profiles
                                    },
                                  )
                                Error(_) -> local_type
                              }
                            }),
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
  let profiled_datatype_child_ids =
    profiled_datatype_children
    |> list.map(fn(element) { element.id })
    |> set.from_list
  let elements =
    elements
    |> list.filter(fn(element) {
      !set.contains(profiled_datatype_child_ids, element.id)
    })
    |> list.append(profiled_datatype_children)
  let inherited_datatype_children =
    elements
    |> list.filter(fn(element) {
      {
        !set.contains(referenced_slice_ids, element.id)
        && !profile_field_has_primitive_type(element, "")
        && case element.type_ {
          [codegen_helpers.Type(code:, ..)] ->
            !list.contains(
              [
                "Extension",
                "Element",
                "BackboneElement",
                "Resource",
                "DomainResource",
              ],
              code,
            )
          _ -> False
        }
      }
      && {
        element.slice_name != None
        || list.any(elements, fn(child) {
          string.starts_with(child.id, element.id <> ".")
        })
      }
    })
    |> list.flat_map(fn(root) {
      let assert [type_] = root.type_
      let prefix = type_.code <> "."
      let group_id = case root.slice_name {
        None -> root.id
        Some(_) ->
          root.id
          |> string.split(":")
          |> list.reverse
          |> list.drop(1)
          |> list.reverse
          |> string.join(":")
      }
      // A snapshot can leave datatype children implicit or expand only some.
      // Use the core fields, with any explicit group or slice fields preserved.
      base_elements
      |> dict.values
      |> list.filter(fn(child) {
        string.starts_with(child.path, prefix)
        && !string.contains(
          string.drop_start(child.path, string.length(prefix)),
          ".",
        )
      })
      |> list.sort(fn(a, b) { string.compare(a.path, b.path) })
      |> list.filter_map(fn(base_child) {
        let suffix =
          string.drop_start(base_child.path, string.length(type_.code))
        let child_id = root.id <> suffix
        case find_element(elements, child_id) {
          Ok(_) -> Error(Nil)
          Error(_) -> {
            let child =
              find_element(elements, group_id <> suffix)
              |> result.unwrap(base_child)
            Ok(
              codegen_helpers.Element(
                ..child,
                id: child_id,
                path: root.path <> suffix,
                slice_name: None,
              ),
            )
          }
        }
      })
    })
  let elements = list.append(elements, inherited_datatype_children)
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
            case set.contains(referenced_slice_ids, root.id) {
              True ->
                Ok(ValueSlicePlan(root_id: root.id, overrides: [], nested: []))
              False ->
                plan_slice(
                  slicing,
                  group,
                  root,
                  current_elements,
                  available_valuesets,
                  planned_slices,
                )
            }
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
                      || {
                        !list.any(replacements_kept, fn(replacement) {
                          replacement.0 == root_id
                        })
                        && list.any(current_elements, fn(root) {
                          root.id == root_id
                          && list.any(root.type_, fn(type_) {
                            type_.profile != []
                          })
                        })
                      }
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
                TypeSlicePlan(slice:, descendants: [], ..) -> Ok(slice.id)
                _ -> Error(Nil)
              }
            })
          let nested_type_slice_ids =
            plans
            |> list.filter_map(fn(plan) {
              case plan {
                TypeSlicePlan(slice:, descendants: [_, ..], ..) -> Ok(slice.id)
                _ -> Error(Nil)
              }
            })
          let current_elements =
            remove_element_trees(current_elements, type_slice_ids, True)
            |> list.filter(fn(element) {
              !list.contains(nested_type_slice_ids, element.id)
            })
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
      set.union(nested_value_discriminators, referenced_slice_ids),
      slice_discriminator_checks,
    )
  }
}

pub fn profile_files_to_types(
  profiles_dir: String,
  preserve_slice_order: Bool,
  valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
  gen_specific_resources: Option(List(String)),
  core_type_urls: Set(String),
  core_constructors: dict.Dict(
    String,
    codegen_profile_json.ConstructorDefinition,
  ),
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
            ..,
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
      let fields = case extension.kind {
        SimpleExtension(element) -> [element]
        ComplexExtension(elements, _) -> elements
      }
      list.append(
        fields,
        extension.primitive_values
          |> dict.values
          |> list.flat_map(fn(value) { value.elements }),
      )
    })
  let required_valuesets =
    valueset_acc
    |> dict.keys
    |> set.from_list
    |> set.union(required_valuesets_from_elements(resource_elements))
    |> set.union(required_valuesets_from_elements(extension_elements))
    |> set.union(required_valuesets_from_elements(dict.values(base_elements)))
    |> set.delete("")
  let available_slice_valuesets =
    codegen_helpers.load_valuesets(profiles_dir, required_valuesets)
  let unavailable_valuesets =
    set.fold(required_valuesets, set.new(), fn(unavailable, reference) {
      let url = canonical_url(reference)
      case
        codegen_helpers.valueset_can_generate_system(
          url,
          available_slice_valuesets,
        )
      {
        True -> unavailable
        False -> {
          io.println("unable to expand valueset " <> reference)
          set.insert(unavailable, url)
        }
      }
    })
  // All generators consume the resolved binding on each element.
  let normalized_profiles =
    list.append(
      profile_structures.resources,
      dict.values(profile_structures.datatype_profiles),
    )
    |> list.map(fn(profile) {
      codegen_helpers.Resource(
        ..profile,
        snapshot: option.map(profile.snapshot, fn(snapshot) {
          codegen_helpers.Snapshot(
            element: list.map(snapshot.element, fn(element) {
              case element.binding {
                Some(
                  codegen_helpers.Binding(
                    strength: "required",
                    value_set: Some(reference),
                    ..,
                  ) as binding,
                ) ->
                  case
                    set.contains(
                      unavailable_valuesets,
                      canonical_url(reference),
                    )
                  {
                    True ->
                      codegen_helpers.Element(
                        ..element,
                        binding: Some(
                          codegen_helpers.Binding(..binding, available: False),
                        ),
                      )
                    False -> element
                  }
                _ -> element
              }
            }),
          )
        }),
      )
    })
  let base_elements =
    dict.map_values(base_elements, fn(_, element) {
      case element.binding {
        Some(
          codegen_helpers.Binding(
            strength: "required",
            value_set: Some(reference),
            ..,
          ) as binding,
        ) ->
          case set.contains(unavailable_valuesets, canonical_url(reference)) {
            True ->
              codegen_helpers.Element(
                ..element,
                binding: Some(
                  codegen_helpers.Binding(..binding, available: False),
                ),
              )
            False -> element
          }
        _ -> element
      }
    })
  let extensions =
    dict.map_values(profile_structures.extensions, fn(_, extension) {
      let fields = case extension.kind {
        SimpleExtension(field) -> [field]
        ComplexExtension(fields, _) -> fields
      }
      let field_count = list.length(fields)
      let fields =
        list.append(
          fields,
          extension.primitive_values
            |> dict.values
            |> list.flat_map(fn(value) { value.elements }),
        )
      let fields =
        list.map(fields, fn(field) {
          case field.binding {
            Some(
              codegen_helpers.Binding(
                strength: "required",
                value_set: Some(value_set),
                ..,
              ) as binding,
            ) ->
              case
                set.contains(unavailable_valuesets, canonical_url(value_set))
              {
                True ->
                  codegen_helpers.Element(
                    ..field,
                    binding: Some(
                      codegen_helpers.Binding(..binding, available: False),
                    ),
                  )
                False -> field
              }
            _ -> field
          }
        })
      let kind = case extension.kind {
        SimpleExtension(_) -> {
          let assert [field] = list.take(fields, field_count)
          SimpleExtension(field)
        }
        ComplexExtension(_, rules) ->
          ComplexExtension(list.take(fields, field_count), rules)
      }
      let primitive_values =
        dict.map_values(extension.primitive_values, fn(_, value) {
          PrimitiveExtensionValue(
            ..value,
            elements: list.filter(fields, fn(field) {
              field.id == value.name
              || string.starts_with(field.id, value.name <> ".")
            }),
          )
        })
      ExtensionDefinition(..extension, kind:, primitive_values:)
    })
  let resource_count = list.length(profile_structures.resources)
  let datatype_profiles =
    normalized_profiles
    |> list.drop(resource_count)
    |> list.map(fn(profile) { #(canonical_url(profile.url), profile) })
    |> dict.from_list
  let profile_structures =
    ProfileFiles(
      resources: list.take(normalized_profiles, resource_count),
      datatype_profiles:,
      extensions:,
    )
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
  let primitive_profiles =
    profile_structures.extensions
    |> dict.values
    |> list.flat_map(fn(extension) {
      extension.primitive_values
      |> dict.values
      |> list.map(fn(value) {
        codegen_helpers.Resource(
          id: codegen_helpers.to_snake_case(value.name),
          name: value.name,
          url: "urn:gleam-fhir:" <> value.name,
          resource_type: "StructureDefinition",
          kind: Some("complex-type"),
          type_: Some("Element"),
          base_definition: None,
          context: [],
          snapshot: Some(codegen_helpers.Snapshot(element: value.elements)),
        )
      })
    })
  let profile_definitions =
    list.append(
      list.append(profile_resources, primitive_profiles),
      dict.values(profile_structures.datatype_profiles),
    )
    |> list.sort(fn(a, b) {
      case a.kind == Some("complex-type"), b.kind == Some("complex-type") {
        True, False -> order.Lt
        False, True -> order.Gt
        _, _ -> string.compare(a.id, b.id)
      }
    })
  let profile_definitions =
    list.filter(profile_definitions, fn(profile) {
      !set.contains(core_type_urls, canonical_url(profile.url))
    })
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
  // Check the names we emit, keeping the original URLs for diagnostics.
  let core_names =
    core_type_urls
    |> set.to_list
    |> list.map(fn(url) {
      let assert Ok(id) = url |> string.split("/") |> list.last
      #("complex_types." <> codegen_helpers.to_camel_case(id), url)
    })
  let extension_names =
    profile_structures.extensions
    |> dict.values
    |> list.map(fn(extension) {
      #("complex_types." <> extension.name, extension.url)
    })
  let profile_names =
    list.map(profile_definitions, fn(profile) {
      let name = case codegen_helpers.to_camel_case(profile.id) {
        "List" -> "Listfhir"
        name -> name
      }
      let module = case profile.kind {
        Some("resource") -> "resources."
        _ -> "complex_types."
      }
      #(module <> name, profile.url)
    })
  let _ =
    list.append(core_names, list.append(extension_names, profile_names))
    |> list.fold(dict.new(), fn(names, entry) {
      let #(name, url) = entry
      case dict.get(names, name) {
        Ok(previous_url) ->
          panic as {
            "Gleam name collision for "
            <> name
            <> ": "
            <> previous_url
            <> " and "
            <> url
          }
        Error(_) -> dict.insert(names, name, url)
      }
    })
  let profile_structures =
    ProfileFiles(
      ..profile_structures,
      extensions: dict.map_values(
        profile_structures.extensions,
        fn(_, extension) {
          case extension.kind {
            SimpleExtension(_) -> extension
            ComplexExtension(fields, rules) ->
              ExtensionDefinition(
                ..extension,
                kind: ComplexExtension(
                  codegen_helpers.name_record_fields(fields, fields),
                  rules,
                ),
              )
          }
        },
      ),
    )
  let #(extension_types, valueset_acc, constructors) =
    generate_extension_types(
      profile_structures.extensions,
      preserve_slice_order,
      valueset_acc,
      datatype_types,
    )
  let constructors = dict.merge(core_constructors, constructors)
  let #(
    profile_complex_types,
    profile_resources,
    valueset_acc,
    _,
    slice_helpers,
    decoder_contexts,
    constructors,
  ) =
    list.fold(
      over: profile_definitions,
      from: #(
        extension_types,
        "",
        valueset_acc,
        dict.new(),
        set.new(),
        [],
        constructors,
      ),
      with: fn(acc, resource) {
        let #(
          extension_types,
          generated_acc,
          valueset_acc,
          generated_extension_classifiers,
          slice_helpers,
          decoder_contexts,
          constructors,
        ) = acc
        let current_bucket = case resource.kind {
          Some("complex-type") -> codegen_helpers.ComplexTypes
          _ -> codegen_helpers.Resources
        }
        let complex_prefix =
          codegen_helpers.bucket_prefix("Quantity", current_bucket)
        let classifier_key = case current_bucket {
          codegen_helpers.ComplexTypes -> "complex"
          codegen_helpers.Resources -> "resources"
        }
        let classifier_sets = generated_extension_classifiers
        let generated_extension_classifiers =
          dict.get(classifier_sets, classifier_key) |> result.unwrap(set.new())
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
            base_elements,
            profile_structures.extensions,
          )
        let slice_helpers =
          list.append(
            dict.values(slice_type_overrides),
            dict.values(slice_discriminator_checks),
          )
          |> list.fold(slice_helpers, fn(helpers, override) {
            case override {
              FixedSliceType(type_name, ..) ->
                case type_name {
                  "ct.CodingFixedSystem" -> set.insert(helpers, CodingSystem)
                  "ct.CodingFixedSystemCode" ->
                    set.insert(helpers, CodingSystemCode)
                  "ct.CodingFixedSystemCodeDisplay" ->
                    set.insert(helpers, CodingSystemCodeDisplay)
                  "ct.CodingFixedSystemRequiredCodeDisplay" ->
                    set.insert(helpers, CodingSystemRequiredCodeDisplay)
                  "ct.CodeableconceptFixedSystem" ->
                    helpers
                    |> set.insert(ConceptSystem)
                    |> set.insert(CodingSystem)
                  "ct.CodeableconceptFixedSystemCode" ->
                    helpers
                    |> set.insert(ConceptSystemCode)
                    |> set.insert(CodingSystemCode)
                  "ct.CodeableconceptFixedSystemCodeDisplay" ->
                    helpers
                    |> set.insert(ConceptSystemCodeDisplay)
                    |> set.insert(CodingSystemCodeDisplay)
                  "ct.CodeableconceptList1FixedSystem" ->
                    helpers
                    |> set.insert(ConceptList1System)
                    |> set.insert(CodingSystem)
                  "ct.CodeableconceptList1FixedSystemCode" ->
                    helpers
                    |> set.insert(ConceptList1SystemCode)
                    |> set.insert(CodingSystemCode)
                  "ct.CodeableconceptList1FixedSystemCodeDisplay" ->
                    helpers
                    |> set.insert(ConceptList1SystemCodeDisplay)
                    |> set.insert(CodingSystemCodeDisplay)
                  _ -> helpers
                }
              _ -> helpers
            }
          })
        let profile_prefix =
          resource.id
          |> string.replace("-", "_")
          |> string.replace(".", "_")
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

        let nested_type_slices =
          dict.values(type_slice_overrides)
          |> list.filter_map(fn(plan) {
            case plan {
              TypeSlicePlan(descendants: [_, ..], ..) -> Ok(plan)
              _ -> Error(Nil)
            }
          })
        let slice_base_type_names =
          list.fold(nested_type_slices, slice_base_type_names, fn(names, plan) {
            let assert TypeSlicePlan(
              root_id:,
              fhir_type:,
              slice:,
              children:,
              descendants:,
            ) = plan
            let assert [_, ..root_parts] =
              root_id
              |> string.replace("-", "")
              |> string.replace(":", ".")
              |> string.split(".")
            let sliced_name =
              string.join([profile_prefix, ..root_parts], "_")
              |> string.replace("[x]", "")
              |> codegen_helpers.to_camel_case
              |> string.append(string.capitalise(fhir_type) <> "Sliced")
            list.fold(
              [slice, ..list.append(children, descendants)],
              names,
              fn(names, element) {
                let assert [_, ..parts] =
                  element.id
                  |> string.replace("-", "")
                  |> string.replace(":", ".")
                  |> string.split(".")
                let canonical_name =
                  string.join([profile_prefix, ..parts], "_")
                  |> string.replace("[x]", "")
                  |> codegen_helpers.to_camel_case
                let suffix =
                  element.id
                  |> string.drop_start(string.length(slice.id))
                  |> string.replace("-", "")
                  |> string.replace(":", ".")
                  |> string.replace(".", "_")
                  |> string.replace("[x]", "")
                  |> codegen_helpers.to_camel_case
                dict.insert(names, canonical_name, sliced_name <> suffix)
              },
            )
          })
        let nested_type_paths =
          list.map(nested_type_slices, fn(plan) {
            let assert TypeSlicePlan(slice:, ..) = plan
            let assert [_, ..parts] =
              slice.id
              |> string.replace("-", "")
              |> string.replace(":", ".")
              |> string.split(".")
            string.join([profile_prefix, ..parts], "_")
          })

        let #(type_fields, type_order) =
          profile_elements
          |> list.fold(
            #(
              dict.new() |> dict.insert(profile_prefix, []),
              set.from_list([profile_prefix, ..nested_type_paths]),
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
                  if parent_path != ""
                  && { min != element.min || max != element.max }
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
        let profile_unions =
          profile_elements
          |> list.filter_map(fn(element) {
            case element.max, element.type_ {
              "0", _ -> Error(Nil)
              _, [type_] ->
                case
                  codegen_profile_json.resolve_datatype_profiles(
                    type_,
                    datatype_types,
                  )
                {
                  [_, _, ..] as profiles -> {
                    let assert [_, ..rest] =
                      element.id
                      |> string.replace("-", "")
                      |> string.replace(":", ".")
                      |> string.split(".")
                    Ok(#(string.join([profile_prefix, ..rest], "_"), profiles))
                  }
                  _ -> Error(Nil)
                }
              _, _ -> Error(Nil)
            }
          })
          |> dict.from_list
        let type_order =
          list.filter(type_order, fn(path) {
            !dict.has_key(profile_unions, path)
          })
        let #(union_source, constructors) =
          profile_unions
          |> dict.to_list
          |> list.sort(fn(a, b) { string.compare(a.0, b.0) })
          |> list.fold(#("", constructors), fn(acc, item) {
            let #(source, constructors) = acc
            let #(path, profiles) = item
            let name =
              path |> string.replace("[x]", "") |> codegen_helpers.to_camel_case
            let variants =
              list.map(profiles, fn(profile) {
                "  "
                <> name
                <> profile
                <> "("
                <> complex_prefix
                <> profile
                <> ")\n"
              })
              |> string.concat
            let encoders =
              list.map(profiles, fn(profile) {
                "    "
                <> name
                <> profile
                <> "(value) -> "
                <> complex_prefix
                <> codegen_helpers.to_snake_case(profile)
                <> "_to_json(value)\n"
              })
              |> string.concat
            let assert [first, ..] = profiles
            #(
              source
                <> "pub type "
                <> name
                <> " {\n"
                <> variants
                <> "}\n\n"
                <> "pub fn "
                <> codegen_helpers.to_snake_case(name)
                <> "_to_json(value: "
                <> name
                <> ") -> Json {\n  case value {\n"
                <> encoders
                <> "  }\n}\n\n",
              dict.insert(
                constructors,
                codegen_profile_json.constructor_key(current_bucket, name),
                codegen_profile_json.ChoiceConstructor(
                  current_bucket,
                  name <> first,
                  complex_prefix <> first,
                ),
              ),
            )
          })
        let type_fields =
          dict.map_values(type_fields, fn(_, fields) {
            codegen_profile_json.name_profile_record_fields(
              list.reverse(fields),
              profile_prefix,
              type_order,
            )
            |> list.reverse
          })
        let #(generated_profile, valueset_acc, constructors) =
          list.fold(
            over: type_order,
            from: #("", valueset_acc, constructors),
            with: fn(acc, current_type) {
              let #(types_acc, valueset_acc, constructors) = acc
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
                    { element.fixed_code == None && element.fixed_uri == None }
                    || element.min == 0
                    || element.max != "1"
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
                constructor_arguments,
                constructor_fields,
                constructors,
              ) =
                list.fold(
                  over: list.reverse(fields),
                  from: #("", "", "", "", valueset_acc, [], [], constructors),
                  with: fn(acc, element) {
                    let #(
                      fields_acc,
                      choices_acc,
                      newfunc_args_acc,
                      newfunc_fields_acc,
                      valueset_acc,
                      constructor_arguments,
                      constructor_fields,
                      constructors,
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
                    let field_name = codegen_helpers.field_name(element)
                    let choice_type =
                      gleam_type <> string.capitalise(safe_field_name)

                    let is_primitive = False

                    let #(base_field_type, valueset_acc) =
                      profile_base_field_type(
                        current_bucket,
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
                    let #(
                      base_field_type,
                      aggregate_slice_source,
                      valueset_acc,
                      constructors,
                    ) = case dict.get(aggregate_slice_groups, element.id) {
                      Error(_) -> #(
                        base_field_type,
                        "",
                        valueset_acc,
                        constructors,
                      )
                      Ok(#(roots, _)) -> {
                        let aggregate_type =
                          aggregate_slice_type_name(
                            choice_type,
                            base_field_type,
                          )
                        let #(variants, valueset_acc, constructors) =
                          list.fold(
                            roots,
                            #("", valueset_acc, constructors),
                            fn(acc, root) {
                              let #(variants, valueset_acc, constructors) = acc
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
                                  current_bucket,
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
                                case variants {
                                  "" ->
                                    dict.insert(
                                      constructors,
                                      codegen_profile_json.constructor_key(
                                        current_bucket,
                                        aggregate_type,
                                      ),
                                      codegen_profile_json.ChoiceConstructor(
                                        current_bucket,
                                        aggregate_slice_constructor(
                                          aggregate_type,
                                          slice_name,
                                          payload_type,
                                        ),
                                        payload_type,
                                      ),
                                    )
                                  _ -> constructors
                                },
                              )
                            },
                          )
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
                          constructors,
                        )
                      }
                    }
                    let field_type = base_field_type
                    let is_resource_slice_elt =
                      codegen_profile_json.profile_field_is_slice_elt(
                        element,
                        fields,
                        preserve_slice_order,
                      )
                    let field_type = case is_resource_slice_elt {
                      True ->
                        case
                          profile_extension_definition(
                            element,
                            profile_structures.extensions,
                          )
                        {
                          Some(_) ->
                            complex_prefix
                            <> "ExtensionSliceElt("
                            <> field_type
                            <> ")"
                          None ->
                            complex_prefix <> "SliceElt(" <> field_type <> ")"
                        }
                      False -> field_type
                    }
                    let card_min = case
                      dict.get(aggregate_slice_groups, element.id)
                    {
                      Ok(#(_, remaining_minimum)) -> remaining_minimum
                      Error(_) -> profile_field_min(element)
                    }
                    let cardinality = case card_min, element.max {
                      min, "*" if min > 3 ->
                        panic as {
                          "unsupported cardinality "
                          <> int.to_string(min)
                          <> "..* for "
                          <> element.id
                        }
                      _, _ ->
                        codegen_helpers.cardinality(
                          field_type,
                          card_min,
                          element.max,
                        )
                    }
                    let meta_profile = case
                      current_type == profile_prefix
                      && resource.kind == Some("resource"),
                      element.base.path,
                      element.max
                    {
                      True, "Resource.meta", "1" -> {
                        case field_type {
                          "ct.Meta" -> Some(#("profile", "List(String)", False))
                          _ ->
                            case
                              dict.get(
                                constructors,
                                codegen_profile_json.constructor_key(
                                  current_bucket,
                                  field_type,
                                ),
                              )
                            {
                              Ok(codegen_profile_json.RecordConstructor(
                                _,
                                arguments,
                                fields,
                              )) -> {
                                fields
                                |> list.find_map(fn(field) {
                                  let #(definition, type_) = field
                                  case
                                    definition.base.path,
                                    definition.slice_name,
                                    type_
                                  {
                                    "Meta.profile", None, "List(String)"
                                    | "Meta.profile", None, "List1(String)"
                                    | "Meta.profile", None, "List2(String)"
                                    | "Meta.profile", None, "List3(String)"
                                    | "Meta.profile", None, "Option(String)"
                                    | "Meta.profile", None, "String"
                                    ->
                                      Ok(#(
                                        codegen_helpers.field_name(definition),
                                        type_,
                                        arguments != [],
                                      ))
                                    _, _, _ -> Error(Nil)
                                  }
                                })
                                |> option.from_result
                              }
                              _ -> None
                            }
                        }
                      }
                      _, _, _ -> None
                    }
                    // Required fields in a profiled Meta come from the caller.
                    let constructor_min = case meta_profile {
                      Some(#(_, _, True)) -> 1
                      _ -> card_min
                    }
                    let #(newfunc_arg, newfunc_field, required_argument) =
                      codegen_helpers.new_fn_arg_and_field(
                        field_name,
                        field_type,
                        constructor_min,
                        element.max,
                        is_primitive,
                      )
                    let newfunc_field = case meta_profile {
                      None -> newfunc_field
                      Some(#(profile_field, profile_type, _)) -> {
                        let meta = case constructor_min {
                          0 ->
                            field_type
                            |> string.split(".")
                            |> list.map(codegen_helpers.to_snake_case)
                            |> string.join(".")
                            |> string.append("_new()")
                          _ -> field_name
                        }
                        let url = "\"" <> resource.url <> "\""
                        let profile_value = "meta." <> profile_field
                        let #(profiles, tagged) = case profile_type {
                          "List(String)" -> #(
                            profile_value,
                            "[" <> url <> ", .." <> profile_value <> "]",
                          )
                          "List1(String)" | "List2(String)" | "List3(String)" -> {
                            let firsts = case profile_type {
                              "List1(String)" -> profile_value <> ".first"
                              "List2(String)" ->
                                profile_value
                                <> ".first, "
                                <> profile_value
                                <> ".second"
                              _ ->
                                profile_value
                                <> ".first, "
                                <> profile_value
                                <> ".second, "
                                <> profile_value
                                <> ".third"
                            }
                            let list_type = case profile_type {
                              "List1(String)" -> "List1"
                              "List2(String)" -> "List2"
                              _ -> "List3"
                            }
                            #(
                              "["
                                <> firsts
                                <> ", .."
                                <> profile_value
                                <> ".rest]",
                              complex_prefix
                                <> list_type
                                <> "(.."
                                <> profile_value
                                <> ", rest: ["
                                <> url
                                <> ", .."
                                <> profile_value
                                <> ".rest])",
                            )
                          }
                          "Option(String)" -> #("", "Some(" <> url <> ")")
                          _ -> #("", url)
                        }
                        let tagged = case profiles {
                          "" -> tagged
                          _ ->
                            "case list.contains("
                            <> profiles
                            <> ", "
                            <> url
                            <> ") { True -> "
                            <> profile_value
                            <> " False -> "
                            <> tagged
                            <> " }"
                        }
                        field_name
                        <> ": "
                        <> case card_min {
                          0 -> "Some("
                          _ -> ""
                        }
                        <> "{ let meta = "
                        <> meta
                        <> " "
                        <> field_type
                        <> "(..meta, "
                        <> profile_field
                        <> ": "
                        <> tagged
                        <> ") }"
                        <> case card_min {
                          0 -> "),"
                          _ -> ","
                        }
                      }
                    }

                    let #(new_choice_source, valueset_acc, constructors) = case
                      element.type_
                    {
                      [] | [_] -> #("", valueset_acc, constructors)
                      choice_types -> {
                        let #(
                          variants,
                          sliced_types,
                          valueset_acc,
                          constructors,
                        ) =
                          list.fold(
                            over: choice_types,
                            from: #("", "", valueset_acc, constructors),
                            with: fn(acc, choice) {
                              let #(
                                variants_acc,
                                sliced_types_acc,
                                valueset_acc,
                                constructors,
                              ) = acc
                              let #(
                                variant_type,
                                sliced_type,
                                valueset_acc,
                                constructors,
                              ) = case
                                dict.get(
                                  type_slice_overrides,
                                  type_slice_key(element.id, choice.code),
                                )
                              {
                                Ok(TypeSlicePlan(descendants: [_, ..], ..)) -> #(
                                  choice_type
                                    <> string.capitalise(choice.code)
                                    <> "Sliced",
                                  "",
                                  valueset_acc,
                                  constructors,
                                )
                                Ok(TypeSlicePlan(slice:, children: [], ..)) -> {
                                  let #(variant_type, valueset_acc) =
                                    codegen_helpers.string_to_type(
                                      choice.code,
                                      all_parts,
                                      slice,
                                      current_bucket,
                                      valueset_acc,
                                    )
                                  #(
                                    variant_type,
                                    "",
                                    valueset_acc,
                                    constructors,
                                  )
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
                                  let type_fields =
                                    codegen_profile_json.name_profile_record_fields(
                                      type_fields,
                                      profile_prefix,
                                      type_order,
                                    )
                                  let #(
                                    fields,
                                    newfunc_args,
                                    newfunc_fields,
                                    valueset_acc,
                                    nested_arguments,
                                  ) =
                                    type_fields
                                    |> list.filter(fn(child) {
                                      {
                                        child.fixed_code == None
                                        && child.fixed_uri == None
                                      }
                                      || child.min == 0
                                      || child.max != "1"
                                    })
                                    |> list.fold(
                                      #("", "", "", valueset_acc, []),
                                      fn(acc, child) {
                                        let #(
                                          fields,
                                          newfunc_args,
                                          newfunc_fields,
                                          valueset_acc,
                                          nested_arguments,
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
                                            current_bucket,
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
                                          codegen_profile_json.profile_field_is_slice_elt(
                                            child,
                                            type_fields,
                                            preserve_slice_order,
                                          )
                                        let gleam_type = case is_slice_elt {
                                          True ->
                                            case
                                              profile_extension_definition(
                                                child,
                                                profile_structures.extensions,
                                              )
                                            {
                                              Some(_) ->
                                                complex_prefix
                                                <> "ExtensionSliceElt("
                                                <> gleam_type
                                                <> ")"
                                              None ->
                                                complex_prefix
                                                <> "SliceElt("
                                                <> gleam_type
                                                <> ")"
                                            }
                                          False -> gleam_type
                                        }
                                        let field_name =
                                          codegen_helpers.field_name(child)
                                        let child_min = profile_field_min(child)
                                        let #(
                                          newfunc_arg,
                                          newfunc_field,
                                          required_argument,
                                        ) =
                                          codegen_helpers.new_fn_arg_and_field(
                                            field_name,
                                            gleam_type,
                                            child_min,
                                            child.max,
                                            False,
                                          )
                                        #(
                                          fields
                                            <> case child.max {
                                            "0" | "1" | "*" -> ""
                                            _ ->
                                              "    // TODO enforce max somehow\n"
                                          }
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
                                          case required_argument {
                                            Some(argument) -> [
                                              argument,
                                              ..nested_arguments
                                            ]
                                            None -> nested_arguments
                                          },
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
                                    dict.insert(
                                      constructors,
                                      codegen_profile_json.constructor_key(
                                        current_bucket,
                                        sliced_name,
                                      ),
                                      codegen_profile_json.RecordConstructor(
                                        current_bucket,
                                        list.reverse(nested_arguments),
                                        [],
                                      ),
                                    ),
                                  )
                                }
                                Error(_) | Ok(ValueSlicePlan(..)) -> {
                                  let #(variant_type, valueset_acc) =
                                    profile_base_field_type(
                                      current_bucket,
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
                                  #(
                                    variant_type,
                                    "",
                                    valueset_acc,
                                    constructors,
                                  )
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
                                case variants_acc {
                                  "" ->
                                    dict.insert(
                                      constructors,
                                      codegen_profile_json.constructor_key(
                                        current_bucket,
                                        choice_type,
                                      ),
                                      codegen_profile_json.ChoiceConstructor(
                                        current_bucket,
                                        choice_type
                                          <> string.capitalise(choice.code),
                                        variant_type,
                                      ),
                                    )
                                  _ -> constructors
                                },
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
                          constructors,
                        )
                      }
                    }

                    let new_choice_source =
                      aggregate_slice_source <> new_choice_source
                    #(
                      fields_acc
                        <> case element.max {
                        "0" | "1" | "*" -> ""
                        _ -> "    // TODO enforce max somehow\n"
                      }
                        <> "    "
                        <> field_name
                        <> ": "
                        <> cardinality
                        <> ",\n",
                      new_choice_source <> choices_acc,
                      newfunc_args_acc <> newfunc_arg,
                      newfunc_fields_acc <> newfunc_field,
                      valueset_acc,
                      case required_argument {
                        Some(argument) -> [argument, ..constructor_arguments]
                        None -> constructor_arguments
                      },
                      [#(element, cardinality), ..constructor_fields],
                      constructors,
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
              #(
                declaration <> types_acc,
                valueset_acc,
                dict.insert(
                  constructors,
                  codegen_profile_json.constructor_key(
                    current_bucket,
                    gleam_type,
                  ),
                  codegen_profile_json.RecordConstructor(
                    current_bucket,
                    list.reverse(constructor_arguments),
                    list.reverse(constructor_fields),
                  ),
                ),
              )
            },
          )

        let assert Some(resource_type) = resource.type_
        let #(profile_encoders, valueset_acc) =
          codegen_profile_json.generate_to_json(
            current_bucket,
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
        let decoder_context =
          codegen_profile_json.DecodeContext(
            current_bucket:,
            resource_type:,
            is_resource: resource.kind == Some("resource"),
            snapshot_elements: snapshot.element,
            profile_prefix:,
            type_order:,
            type_fields:,
            extensions: profile_structures.extensions,
            slice_base_type_names:,
            slice_type_overrides:,
            datatype_types:,
            profile_unions:,
            nested_value_discriminators:,
            slice_discriminator_checks:,
            type_slice_overrides:,
            preserve_slice_order:,
            valueset_acc:,
            available_valuesets: available_slice_valuesets,
            base_elements:,
            constructors: dict.new(),
          )

        let generated_source =
          union_source <> generated_profile <> profile_encoders
        let #(extension_types, generated_acc) = case current_bucket {
          codegen_helpers.ComplexTypes -> #(
            extension_types <> generated_source,
            generated_acc,
          )
          codegen_helpers.Resources -> #(
            extension_types,
            generated_acc <> generated_source,
          )
        }
        #(
          extension_types,
          generated_acc,
          valueset_acc,
          dict.insert(
            classifier_sets,
            classifier_key,
            generated_extension_classifiers,
          ),
          slice_helpers,
          [#(profile_type, decoder_context), ..decoder_contexts],
          constructors,
        )
      },
    )
  let #(profile_complex_types, profile_resources, _) =
    decoder_contexts
    |> list.reverse
    |> list.fold(
      #(profile_complex_types, profile_resources, dict.new()),
      fn(acc, item) {
        let #(complex_source, resource_source, classifier_sets) = acc
        let #(profile_type, context) = item
        let classifier_key = case context.current_bucket {
          codegen_helpers.ComplexTypes -> "complex"
          codegen_helpers.Resources -> "resources"
        }
        let generated_classifiers =
          dict.get(classifier_sets, classifier_key)
          |> result.unwrap(set.new())
        let #(decoders, generated_classifiers) =
          codegen_profile_json.generate_decoders(
            codegen_profile_json.DecodeContext(..context, constructors:),
            profile_type,
            generated_classifiers,
          )
        let classifier_sets =
          dict.insert(classifier_sets, classifier_key, generated_classifiers)
        case context.current_bucket {
          codegen_helpers.ComplexTypes -> #(
            complex_source <> decoders,
            resource_source,
            classifier_sets,
          )
          codegen_helpers.Resources -> #(
            complex_source,
            resource_source <> decoders,
            classifier_sets,
          )
        }
      },
    )
  let #(concept_system_source, concept_system_code_source) =
    codegen_slice_complex_type.slice_codeableconcept(preserve_slice_order)
  let slice_types =
    [
      #(CodingSystem, codegen_slice_complex_type.slice_coding_fixed_system),
      #(
        CodingSystemCode,
        codegen_slice_complex_type.slice_coding_fixed_system_code,
      ),
      #(
        CodingSystemCodeDisplay,
        codegen_slice_complex_type.slice_coding_display,
      ),
      #(
        CodingSystemRequiredCodeDisplay,
        codegen_slice_complex_type.slice_coding_fixeduri,
      ),
      #(ConceptSystem, concept_system_source),
      #(ConceptSystemCode, concept_system_code_source),
      #(
        ConceptSystemCodeDisplay,
        codegen_slice_complex_type.slice_codeableconcept_display(
          preserve_slice_order,
        ),
      ),
      #(
        ConceptList1System,
        codegen_slice_complex_type.slice_codeableconcept_list1_fixed_system,
      ),
      #(
        ConceptList1SystemCode,
        codegen_slice_complex_type.slice_codeableconcept_list1_fixed_system_code,
      ),
      #(
        ConceptList1SystemCodeDisplay,
        codegen_slice_complex_type.slice_codeableconcept_list1_fixed_system_code_display,
      ),
    ]
    |> list.fold("", fn(source, entry) {
      case set.contains(slice_helpers, entry.0) {
        True -> source <> entry.1
        False -> source
      }
    })
  let profile_complex_types = slice_types <> profile_complex_types
  let assert [profile_complex_types, profile_resources] =
    list.map(
      [
        #(codegen_helpers.ComplexTypes, profile_complex_types),
        #(codegen_helpers.Resources, profile_resources),
      ],
      fn(entry) {
        let #(current_bucket, source) = entry
        let result_search_source = case
          string.contains(source, "find_required_elt_and_rest_result("),
          string.contains(source, "find_optional_elt_and_rest_result("),
          string.contains(
            source,
            "find_at_least_n_elts_and_rest_result_or_failure(",
          )
        {
          False, False, False -> ""
          required, optional, repeated ->
            case current_bucket {
              codegen_helpers.Resources ->
                codegen_bound_coding.find_elt_and_rest_result(False)
              codegen_helpers.ComplexTypes -> ""
            }
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
        case string.contains(source, "result_or_decode_failure(") {
          True -> codegen_decode.result_or_decode_failure
          False -> ""
        }
        <> result_search_source
        <> case string.contains(source, "slice_acc_errors(") {
          True -> codegen_profile_json.slice_acc_errors_source
          False -> ""
        }
        <> source
      },
    )
  #(
    profile_complex_types,
    profile_resources,
    valueset_acc,
    available_slice_valuesets,
    profile_resource_entries,
  )
}
