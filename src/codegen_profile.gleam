import codegen_bound_coding
import codegen_constraint
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
import gleam/bool
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

fn load_base_structure_elements(
  roots: List(String),
  directories: List(String),
  loaded: Set(String),
  elements: List(codegen_helpers.Element),
) -> List(codegen_helpers.Element) {
  case roots {
    [] -> elements
    [root, ..rest] -> {
      case set.contains(loaded, root) {
        True ->
          load_base_structure_elements(rest, directories, loaded, elements)
        False -> {
          let children =
            directories
            |> list.find_map(fn(directory) {
              let path =
                filepath.join(
                  directory,
                  "StructureDefinition-" <> root <> ".json",
                )
              case simplifile.is_file(path) {
                Ok(True) -> {
                  let resource = read_structure_definition(path)
                  case
                    resource.url
                    == "http://hl7.org/fhir/StructureDefinition/" <> root,
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
          let referenced =
            children
            |> list.flat_map(fn(child) {
              list.map(child.type_, fn(type_) { type_.code })
            })
          load_base_structure_elements(
            list.append(referenced, rest),
            directories,
            set.insert(loaded, root),
            list.fold(children, elements, fn(elements, child) {
              [child, ..elements]
            }),
          )
        }
      }
    }
  }
}

fn base_structure_elements(
  profiles_dir: String,
  profile_elements: List(codegen_helpers.Element),
) -> dict.Dict(String, codegen_helpers.Element) {
  let directories =
    codegen_helpers.package_directories(profiles_dir) |> list.reverse
  let roots =
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
  load_base_structure_elements(roots, directories, set.new(), [])
  |> list.reverse
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

fn constrained_type_from_elements(
  root: codegen_helpers.Element,
  elements: List(codegen_helpers.Element),
  base_elements: dict.Dict(String, codegen_helpers.Element),
) -> Result(String, String) {
  use datatype <- result.try(case root.type_ {
    [datatype] -> Ok(datatype.code)
    _ -> Error("constraint needs one datatype")
  })
  // Expand into a local copy so naming uses the same scalar constraints for
  // object patterns and explicit child definitions.
  let elements = case root.constraint {
    Some(constraint) ->
      expand_constraint(root, constraint, elements, base_elements)
    None -> elements
  }
  let prefix = root.id <> "."
  let fields =
    elements
    |> list.filter(fn(field) {
      string.starts_with(field.id, prefix)
      && !string.contains(
        string.drop_start(field.id, string.length(prefix)),
        ".",
      )
      && field.slice_name == None
      && field.max != "0"
    })
    |> list.sort(fn(a, b) {
      let a_order =
        dict.get(
          base_elements,
          datatype <> string.drop_start(a.path, string.length(root.path)),
        )
        |> result.map(fn(field) { field.definition_order })
        |> result.unwrap(a.definition_order)
      let b_order =
        dict.get(
          base_elements,
          datatype <> string.drop_start(b.path, string.length(root.path)),
        )
        |> result.map(fn(field) { field.definition_order })
        |> result.unwrap(b.definition_order)
      int.compare(a_order, b_order)
    })
  let fixed =
    fields
    |> list.filter(fn(field) {
      field.max == "1"
      && case codegen_helpers.constant(field) {
        Some(codegen_constraint.Object(_))
        | Some(codegen_constraint.Array(_))
        | None -> False
        Some(_) -> True
      }
    })
    |> list.map(codegen_helpers.field_name)
  let required =
    fields
    |> list.filter(fn(field) {
      field.min > 0
      && field.max == "1"
      && !list.contains(fixed, codegen_helpers.field_name(field))
    })
    |> list.map(codegen_helpers.field_name)
  case fixed {
    [_, ..] ->
      Ok(
        "ct."
        <> codegen_slice_complex_type.constrained_type_name(
          datatype,
          fixed,
          required,
          False,
        ),
      )
    [] -> {
      let members =
        fields
        |> list.filter(fn(field) {
          field.base.max != "1"
          && !profile_field_has_primitive_type(field, "")
          && list.any(elements, fn(child) {
            {
              string.starts_with(child.id, field.id <> ".")
              || string.starts_with(child.id, field.id <> ":")
            }
            && {
              child.constraint != None
              || codegen_helpers.constant(child) != None
            }
          })
        })
      case members, required {
        [member], _ -> {
          // This shared record describes the matching member. Additional
          // constraints on the parent fields keep the profile record below.
          let all_members = member.slicing == None
          let list1 = all_members && member.min == 1 && member.max == "*"
          let member = case member.slicing {
            None -> Ok(member)
            Some(_) ->
              case direct_slice_roots(member, elements) {
                [pattern] if pattern.pattern_match -> Ok(pattern)
                _ -> Error("shared name needs one matching list member")
              }
          }
          use member <- result.try(member)
          use child_name <- result.try(constrained_type_from_elements(
            member,
            elements,
            base_elements,
          ))
          let assert [child_type] = member.type_
          let suffix =
            string.drop_start(
              child_name,
              string.length(
                "ct." <> codegen_helpers.to_camel_case(child_type.code),
              ),
            )
          Ok(
            "ct."
            <> codegen_slice_complex_type.constrained_type_name(
              datatype,
              [],
              [],
              list1,
            )
            <> case all_members && !list1 {
              True ->
                "All"
                <> codegen_helpers.to_camel_case(codegen_helpers.field_name(
                  member,
                ))
              False -> ""
            }
            <> suffix,
          )
        }
        [], [_, ..] ->
          Ok(
            "ct."
            <> codegen_slice_complex_type.constrained_type_name(
              datatype,
              [],
              required,
              False,
            ),
          )
        _, _ -> Error("no shared constrained fields")
      }
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

// Reuse a shared type when it expresses the complete field constraint.
// Otherwise descend into the datatype fields and keep their profile types.
fn plan_constraint_fields(
  root: codegen_helpers.Element,
  elements: List(codegen_helpers.Element),
  available_valuesets: dict.Dict(String, codegen_helpers.VsOrCs),
  base_elements: dict.Dict(String, codegen_helpers.Element),
) -> Result(List(#(String, SliceFieldType)), String) {
  use <- bool.guard(root.max == "0", Error("prohibited field " <> root.id))
  let shared_type = case root.type_ {
    [type_] ->
      case dict.get(base_elements, type_.code) {
        Ok(codegen_helpers.Element(type_: _, ..))
          if type_.code != "BackboneElement" && type_.code != "Element"
        -> constrained_type_from_elements(root, elements, base_elements)
        _ -> Error("no shared constrained type")
      }
    _ -> Error("no shared constrained type")
  }
  let shared =
    shared_type
    |> result.try(fn(type_) {
      // The existing conversion calls accept these three scalar arguments.
      // Name construction itself accepts any fixed and required field lists.
      use #(_, _, fixed, _) <- result.try(
        codegen_slice_complex_type.helper_fields(type_)
        |> result.replace_error("not a shared constraint name"),
      )
      use _ <- result.try(
        case
          list.all(fixed, fn(field) {
            list.contains(["system", "code", "display"], field)
          })
        {
          True -> Ok(Nil)
          False -> Error("shared conversion needs different scalar arguments")
        },
      )
      let assert [datatype] = root.type_
      let fields =
        codegen_slice_complex_type.datatype_fields(datatype.code, base_elements)
      let direct =
        list.all(fixed, fn(name) {
          list.any(fields, fn(field) {
            codegen_helpers.field_name(field) == name
          })
        })
      let required = case direct {
        True -> codegen_slice_complex_type.required_fields(type_, fields)
        False -> []
      }
      use _ <- result.try(
        case
          list.any(fields, fn(field) {
            list.contains(required, codegen_helpers.field_name(field))
            && field.base.max != "1"
          })
        {
          True -> Error("shared required field has a list cardinality")
          False -> Ok(Nil)
        },
      )
      use _ <- result.try(
        case
          list.any(fields, fn(field) {
            list.contains(required, codegen_helpers.field_name(field))
            && case field.type_ {
              [field_type] ->
                list.any(
                  codegen_slice_complex_type.datatype_fields(
                    field_type.code,
                    base_elements,
                  ),
                  fn(child) { child.min > 0 },
                )
              _ -> False
            }
          })
        {
          True -> Error("required field constructor needs arguments")
          False -> Ok(Nil)
        },
      )
      use #(system, code, display) <- result.try(case fixed {
        [] -> Ok(#("", "", None))
        _ ->
          codegen_profile_json.discriminator_literals(root, [root, ..elements])
          |> result.replace_error("missing discriminator literals")
      })
      use _ <- result.try(case list.contains(fixed, "display"), display {
        True, None -> Error("missing fixed display literal")
        _, _ -> Ok(Nil)
      })
      case
        list.all(
          [
            system,
            code,
            ..case display {
              Some(value) -> [value]
              None -> []
            }
          ],
          codegen_constraint.text_can_use_legacy_template,
        )
      {
        True -> Ok(#(type_, system, code, display))
        False -> Error("literal requires escaping")
      }
    })
  case shared {
    Ok(#(type_, system, code, display)) -> {
      Ok([
        #(
          root.id,
          FixedSliceType(type_, [root, ..elements], system, code, display),
        ),
      ])
    }
    Error(_) -> {
      let literal = case root.fixed_code, root.fixed_uri {
        Some(value), _ | _, Some(value) -> Some(value)
        _, _ -> None
      }
      case literal {
        Some(value) -> Ok([#(root.id, FixedValueDiscriminator(value))])
        None -> {
          let prefix = root.id <> "."
          let children =
            list.filter(elements, fn(child) {
              string.starts_with(child.id, prefix)
              && !string.contains(
                string.drop_start(child.id, string.length(prefix)),
                ".",
              )
              && child.slice_name == None
              && {
                child.constraint != None
                || codegen_helpers.constant(child) != None
                || list.any(elements, fn(descendant) {
                  string.starts_with(descendant.id, child.id <> ".")
                  && {
                    descendant.constraint != None
                    || codegen_helpers.constant(descendant) != None
                  }
                })
              }
            })
          let replacements =
            children
            |> list.filter_map(fn(child) {
              plan_constraint_fields(
                child,
                elements,
                available_valuesets,
                base_elements,
              )
            })
            |> list.flatten
          case replacements {
            [_, ..] -> Ok(replacements)
            [] -> {
              let bound_type = case root.type_ {
                [codegen_helpers.Type(code: "Coding", ..)] ->
                  Ok(BoundCodingSlice)
                [codegen_helpers.Type(code: "CodeableConcept", ..)] ->
                  Ok(BoundCodeableconceptSlice)
                _ -> Error("no constraint for " <> root.id)
              }
              case root.constraint, bound_type {
                Some(_), _ -> Ok([])
                _, _ -> {
                  use bound_type <- result.try(bound_type)
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
                        True -> Ok([#(root.id, bound_type)])
                        False ->
                          Error(
                            "cant expand valueset required for discriminator "
                            <> value_set,
                          )
                      }
                    }
                    _ -> Error("no fixed or pattern constraint for " <> root.id)
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

fn plan_whole_value_slice(
  _group: codegen_helpers.Element,
  root: codegen_helpers.Element,
  elements: List(codegen_helpers.Element),
  available_valuesets: dict.Dict(String, codegen_helpers.VsOrCs),
  base_elements: dict.Dict(String, codegen_helpers.Element),
) -> Result(SlicePlan, String) {
  use overrides <- result.try(plan_constraint_fields(
    root,
    elements,
    available_valuesets,
    base_elements,
  ))
  Ok(ValueSlicePlan(root_id: root.id, overrides:, nested: []))
}

fn plan_child_value_slice(
  root: codegen_helpers.Element,
  path: String,
  elements: List(codegen_helpers.Element),
  available_valuesets: dict.Dict(String, codegen_helpers.VsOrCs),
  planned_slices: dict.Dict(String, SlicePlan),
  base_elements: dict.Dict(String, codegen_helpers.Element),
) -> Result(SlicePlan, String) {
  let child_id = root.id <> "." <> path
  use child <- result.try(
    find_element(elements, child_id)
    |> result.replace_error("missing discriminator element " <> child_id),
  )
  let replacements = case
    plan_constraint_fields(root, elements, available_valuesets, base_elements)
  {
    Ok([#(id, _)]) as planned if id == root.id -> planned
    _ ->
      plan_constraint_fields(
        child,
        elements,
        available_valuesets,
        base_elements,
      )
  }
  case replacements {
    Ok(overrides) ->
      Ok(ValueSlicePlan(root_id: root.id, overrides:, nested: []))
    Error(reason) -> {
      let nested_groups =
        list.filter(elements, fn(group) {
          group.slicing != None && string.starts_with(group.id, child_id <> ".")
        })
      let roots =
        list.flat_map(nested_groups, fn(group) {
          direct_slice_roots(group, elements)
        })
      case
        roots,
        list.try_map(roots, fn(root) { dict.get(planned_slices, root.id) })
      {
        [_, ..], Ok(nested) ->
          Ok(ValueSlicePlan(root_id: root.id, overrides: [], nested:))
        _, _ -> Error(reason)
      }
    }
  }
}

fn plan_value_slice(
  slicing: codegen_helpers.Slicing,
  group: codegen_helpers.Element,
  root: codegen_helpers.Element,
  elements: List(codegen_helpers.Element),
  available_valuesets: dict.Dict(String, codegen_helpers.VsOrCs),
  planned_slices: dict.Dict(String, SlicePlan),
  base_elements: dict.Dict(String, codegen_helpers.Element),
) -> Result(SlicePlan, String) {
  case
    only_value_or_pattern_discriminators(slicing),
    discriminator_paths(slicing)
  {
    True, ["$this"] ->
      plan_whole_value_slice(
        group,
        root,
        elements,
        available_valuesets,
        base_elements,
      )
    True, ["code", "system"] | True, ["code"] ->
      case element_type_is(root, "Coding") {
        True ->
          plan_whole_value_slice(
            group,
            root,
            elements,
            available_valuesets,
            base_elements,
          )
        False ->
          plan_child_value_slice(
            root,
            "code",
            elements,
            available_valuesets,
            planned_slices,
            base_elements,
          )
      }
    True, ["coding.code", "coding.system"]
    | True, ["coding.code"]
    | True, ["coding"]
    ->
      plan_whole_value_slice(
        group,
        root,
        elements,
        available_valuesets,
        base_elements,
      )
    True, ["system"] ->
      case group.type_ {
        [codegen_helpers.Type(code: "Identifier", ..)] ->
          case find_element(elements, root.id <> ".system") {
            Ok(system)
              if system.constraint != None || system.fixed_uri != None
            ->
              plan_whole_value_slice(
                group,
                root,
                elements,
                available_valuesets,
                base_elements,
              )
            _ -> Error("Identifier slice has no system literal")
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
            Ok(_) ->
              plan_whole_value_slice(
                group,
                root,
                elements,
                available_valuesets,
                base_elements,
              )
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
        base_elements,
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
            base_elements,
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
  base_elements: dict.Dict(String, codegen_helpers.Element),
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
        base_elements,
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

// Expand object fields using the datatype snapshot. Array patterns become
// required matching slices; they do not constrain every member of the array.
fn expand_constraint(
  root: codegen_helpers.Element,
  constraint: codegen_constraint.Constraint,
  elements: List(codegen_helpers.Element),
  base_elements: dict.Dict(String, codegen_helpers.Element),
) -> List(codegen_helpers.Element) {
  let codegen_constraint.Constraint(fixed:, value:, ..) = constraint
  case value {
    codegen_constraint.Object(fields) -> {
      let assert [datatype] = root.type_
      let prefix = datatype.code <> "."
      let inherited =
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
        |> list.filter_map(fn(child) {
          let suffix =
            string.drop_start(child.path, string.length(datatype.code))
          let id = root.id <> suffix
          case find_element(elements, id) {
            Ok(_) -> Error(Nil)
            Error(_) ->
              Ok(
                codegen_helpers.Element(
                  ..child,
                  id:,
                  path: root.path <> suffix,
                  slice_name: None,
                ),
              )
          }
        })
      let elements = list.append(elements, inherited)
      let elements = case fixed {
        False -> elements
        True ->
          list.map(elements, fn(child) {
            let prefix = root.id <> "."
            case
              string.starts_with(child.id, prefix)
              && !string.contains(
                string.drop_start(child.id, string.length(prefix)),
                ".",
              )
              && !list.any(fields, fn(field) {
                child.path == root.path <> "." <> field.0
                || {
                  string.ends_with(child.path, "[x]")
                  && list.any(child.type_, fn(type_) {
                    string.drop_end(child.path, 3)
                    <> string.uppercase(string.slice(type_.code, 0, 1))
                    <> string.drop_start(type_.code, 1)
                    == root.path <> "." <> field.0
                  })
                }
              })
            {
              True -> codegen_helpers.Element(..child, min: 0, max: "0")
              False -> child
            }
          })
      }
      list.fold(fields, elements, fn(elements, field) {
        let #(name, value) = field
        let choice =
          base_elements
          |> dict.values
          |> list.find_map(fn(child) {
            case
              string.starts_with(child.path, datatype.code <> ".")
              && string.ends_with(child.path, "[x]")
            {
              False -> Error(Nil)
              True -> {
                let suffix =
                  child.path
                  |> string.drop_start(string.length(datatype.code) + 1)
                  |> string.drop_end(3)
                child.type_
                |> list.find_map(fn(type_) {
                  let json_name =
                    suffix
                    <> string.uppercase(string.slice(type_.code, 0, 1))
                    <> string.drop_start(type_.code, 1)
                  case name == json_name {
                    True -> Ok(#(suffix <> "[x]", type_))
                    False -> Error(Nil)
                  }
                })
              }
            }
          })
        let field_name = case choice {
          Ok(#(name, _)) -> name
          Error(_) -> name
        }
        let child_id = root.id <> "." <> field_name
        let child = case find_element(elements, child_id) {
          Ok(child) -> child
          Error(_) -> {
            let base_id = datatype.code <> "." <> field_name
            let assert Ok(base_child) = dict.get(base_elements, base_id)
              as { "missing datatype field " <> base_id <> " for " <> root.id }
            codegen_helpers.Element(
              ..base_child,
              id: child_id,
              path: root.path <> "." <> field_name,
              slice_name: None,
            )
          }
        }
        let child = case choice {
          Ok(#(_, type_)) -> codegen_helpers.Element(..child, type_: [type_])
          Error(_) -> child
        }
        let assert [child_type] = child.type_
        let child_constraint =
          codegen_constraint.Constraint(
            fixed:,
            type_name: child_type.code,
            value:,
          )
        let child =
          codegen_helpers.Element(
            ..child,
            min: int.max(1, child.min),
            max: case fixed, value {
              True, codegen_constraint.Array(_) -> "1"
              _, _ -> child.max
            },
            constraint: Some(child_constraint),
          )
        let elements = case find_element(elements, child_id) {
          Ok(_) ->
            list.map(elements, fn(element) {
              case element.id == child_id {
                True -> child
                False -> element
              }
            })
          Error(_) -> list.append(elements, [child])
        }
        expand_constraint(child, child_constraint, elements, base_elements)
      })
    }
    codegen_constraint.Array(values) -> {
      case fixed, values {
        False, [codegen_constraint.Object(_) as value] -> {
          let pattern_id = root.id <> ":pattern"
          let elements = case find_element(elements, pattern_id) {
            Ok(_) -> elements
            Error(_) -> {
              let group =
                codegen_helpers.Element(
                  ..root,
                  constraint: None,
                  pattern_match: True,
                  slicing: Some(codegen_helpers.Slicing(
                    discriminator: [
                      codegen_helpers.Discriminator(
                        type_: "pattern",
                        path: "$this",
                      ),
                    ],
                    ordered: False,
                    rules: "open",
                  )),
                )
              let pattern =
                codegen_helpers.Element(
                  ..root,
                  id: pattern_id,
                  slice_name: Some("pattern"),
                  slicing: None,
                  min: 1,
                  max: "*",
                  pattern_match: True,
                  constraint: Some(
                    codegen_constraint.Constraint(..constraint, value:),
                  ),
                  pattern_coding: case root.type_ {
                    [codegen_helpers.Type(code: "Coding", ..)] ->
                      Some(codegen_helpers.coding_pattern(value))
                    _ -> None
                  },
                )
              let elements =
                list.map(elements, fn(element) {
                  case element.id == root.id {
                    True -> group
                    False -> element
                  }
                })
              list.append(elements, [pattern])
            }
          }
          let assert Ok(pattern) = find_element(elements, pattern_id)
          let pattern_constraint =
            option.unwrap(
              pattern.constraint,
              codegen_constraint.Constraint(..constraint, value:),
            )
          expand_constraint(
            pattern,
            pattern_constraint,
            elements,
            base_elements,
          )
        }
        False, [_, ..] -> {
          case
            list.all(values, fn(value) {
              case value {
                codegen_constraint.Text(_)
                | codegen_constraint.Boolean(_)
                | codegen_constraint.Integer(_)
                | codegen_constraint.Decimal(_) -> True
                _ -> False
              }
            })
          {
            True -> {
              case
                list.any(elements, fn(child) {
                  string.starts_with(child.id, root.id <> ".")
                })
              {
                True ->
                  panic as {
                    "Array pattern on a primitive with id or extensions declared by the profile is unsupported: "
                    <> root.id
                  }
                False -> Nil
              }
              list.map(elements, fn(element) {
                case element.id == root.id {
                  True ->
                    codegen_helpers.Element(..element, pattern_literals: values)
                  False -> element
                }
              })
            }
            False -> elements
          }
        }
        _, _ -> elements
      }
    }
    codegen_constraint.Text(value) -> {
      let assert [datatype] = root.type_
      case
        codegen_constraint.text_can_use_legacy_template(value)
        && list.contains(
          [
            "string",
            "code",
            "uri",
            "url",
            "canonical",
            "id",
            "oid",
            "uuid",
            "markdown",
            "base64Binary",
            "xhtml",
          ],
          datatype.code,
        )
      {
        False -> elements
        True ->
          list.map(elements, fn(element) {
            case element.id == root.id {
              False -> element
              True -> {
                let existing = case element.fixed_code, element.fixed_uri {
                  Some(value), _ | _, Some(value) -> Some(value)
                  _, _ -> None
                }
                case existing {
                  Some(existing) if existing != value ->
                    panic as { "conflicting constraints for " <> root.id }
                  _ -> Nil
                }
                case root.max {
                  "0" ->
                    panic as {
                      "constraint requires prohibited field " <> root.id
                    }
                  _ -> Nil
                }
                case datatype.code {
                  "uri" ->
                    codegen_helpers.Element(..element, fixed_uri: Some(value))
                  _ ->
                    codegen_helpers.Element(..element, fixed_code: Some(value))
                }
              }
            }
          })
      }
    }
    _ -> elements
  }
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
  List(codegen_helpers.Element),
) {
  // Choice children use the same per datatype records as explicit type slices.
  let elements =
    list.flat_map(elements, fn(element) {
      use <- bool.guard(
        list.any(elements, fn(parent) {
          list.length(parent.type_) > 1
          && parent.slicing == None
          && string.starts_with(element.id, parent.id <> ".")
        }),
        [],
      )
      let children =
        list.filter(elements, fn(child) {
          string.starts_with(child.id, element.id <> ".")
        })
      case element.type_, element.slicing, children {
        [_, _, ..], None, [_, ..] -> {
          let slicing =
            codegen_helpers.Slicing(
              rules: "closed",
              ordered: False,
              discriminator: [
                codegen_helpers.Discriminator("type", "$this"),
              ],
            )
          let slices =
            list.flat_map(element.type_, fn(datatype) {
              let root =
                codegen_helpers.Element(
                  ..element,
                  id: element.id <> ":" <> datatype.code,
                  slice_name: Some(datatype.code),
                  type_: [datatype],
                )
              let fields =
                codegen_slice_complex_type.datatype_fields(
                  datatype.code,
                  base_elements,
                )
                |> list.map(fn(field) {
                  codegen_helpers.Element(
                    ..field,
                    id: element.id
                      <> string.drop_start(
                        field.path,
                        string.length(datatype.code),
                      ),
                    path: element.path
                      <> string.drop_start(
                        field.path,
                        string.length(datatype.code),
                      ),
                  )
                })
                |> list.append(children)
                |> list.map(fn(field) { #(field.id, field) })
                |> dict.from_list
                |> dict.values
                |> list.map(fn(field) {
                  codegen_helpers.Element(
                    ..field,
                    id: root.id
                      <> string.drop_start(field.id, string.length(element.id)),
                  )
                })
              [root, ..fields]
            })
          [codegen_helpers.Element(..element, slicing: Some(slicing)), ..slices]
        }
        _, _, _ -> [element]
      }
    })
  let elements =
    list.map(elements, fn(element) {
      let element = case string.ends_with(element.id, ".value") {
        True -> {
          let primitive_id = string.drop_end(element.id, 6)
          case
            list.find(elements, fn(candidate) {
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
        False -> element
      }
      case element.type_ {
        [datatype] ->
          case
            codegen_profile_json.resolve_datatype_profiles(
              datatype,
              datatype_profiles,
            )
          {
            [profile] ->
              case profile.snapshot {
                Some(snapshot) ->
                  case list.first(snapshot.element) {
                    Ok(inherited) ->
                      codegen_helpers.Element(
                        ..element,
                        constraint: option.or(
                          element.constraint,
                          inherited.constraint,
                        ),
                        pattern_coding: option.or(
                          element.pattern_coding,
                          inherited.pattern_coding,
                        ),
                        pattern_codeableconcept: option.or(
                          element.pattern_codeableconcept,
                          inherited.pattern_codeableconcept,
                        ),
                        pattern_identifier: option.or(
                          element.pattern_identifier,
                          inherited.pattern_identifier,
                        ),
                      )
                    Error(_) -> element
                  }
                None -> element
              }
            _ -> element
          }
        _ -> element
      }
    })
  let discriminator_elements =
    elements
    |> list.filter(fn(root) { list.length(root.type_) == 1 })
    |> list.flat_map(fn(root) {
      root.type_
      |> list.flat_map(fn(type_) {
        case
          codegen_profile_json.resolve_datatype_profiles(
            type_,
            datatype_profiles,
          )
        {
          [profile] ->
            case profile.snapshot {
              Some(snapshot) ->
                snapshot.element
                |> list.filter(fn(child) {
                  string.starts_with(child.id, type_.code <> ".")
                })
                |> list.map(fn(child) {
                  codegen_helpers.Element(
                    ..child,
                    id: root.id
                      <> string.drop_start(child.id, string.length(type_.code)),
                    path: root.path
                      <> string.drop_start(
                        child.path,
                        string.length(type_.code),
                      ),
                  )
                })
              None -> []
            }
          _ -> []
        }
      })
    })
    |> list.append(elements)
    |> list.map(fn(element) { #(element.id, element) })
    |> dict.from_list
    |> dict.values
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
                    Ok(child) -> codegen_helpers.constant(child) != None
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
        || list.any(element.type_, fn(type_) {
          list.any(type_.profile, fn(url) {
            string.starts_with(url, "urn:gleam-fhir:inline:")
          })
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
                            constraint: case existing.constraint {
                              Some(_) -> existing.constraint
                              None -> child.constraint
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
  // Custom concept records still need one coding matching the parent pattern.
  // Express it as a required slice so the existing coding representation keeps
  // its constants, other fields, additional codings, and their positions.
  let concept_pattern_children =
    elements
    |> list.flat_map(fn(root) {
      case root.pattern_codeableconcept {
        Some(codegen_helpers.DiscriminatorCodeableconceptValue(coding: [pattern])) -> {
          let custom_record =
            list.any(elements, fn(child) {
              let prefix = root.id <> "."
              case string.starts_with(child.id, prefix) {
                False -> False
                True -> {
                  let field = string.drop_start(child.id, string.length(prefix))
                  let fixed_field = case field {
                    "coding.system" -> pattern.system != None
                    "coding.code" -> pattern.code != None
                    "coding.display" -> pattern.display != None
                    _ -> False
                  }
                  child.slice_name != None
                  || !list.contains(
                    [
                      "id", "extension", "coding", "text", "coding.id",
                      "coding.extension", "coding.version", "coding.system",
                      "coding.code", "coding.display", "coding.userSelected",
                    ],
                    field,
                  )
                  || list.any(child.type_, fn(type_) { type_.profile != [] })
                  || case fixed_field {
                    True -> child.min > 1 || child.max != "1"
                    False ->
                      child.min != child.base.min || child.max != child.base.max
                  }
                  || case child.binding {
                    Some(binding) ->
                      binding.strength == "required" && !fixed_field
                    None -> False
                  }
                }
              }
            })
          case custom_record {
            False -> []
            True -> {
              let coding_id = root.id <> ".coding"
              let coding = case find_element(elements, coding_id) {
                Ok(coding) -> coding
                Error(_) -> {
                  let assert Ok(coding) =
                    base_elements
                    |> dict.values
                    |> list.find(fn(child) {
                      child.path == "CodeableConcept.coding"
                    })
                  codegen_helpers.Element(
                    ..coding,
                    id: coding_id,
                    path: root.path <> ".coding",
                  )
                }
              }
              case coding.slicing {
                Some(_) -> []
                None -> {
                  let assert True = coding.max != "0"
                  let pattern_id = coding.id <> ":pattern"
                  let assert Error(_) = find_element(elements, pattern_id)
                  [
                    codegen_helpers.Element(
                      ..coding,
                      pattern_match: True,
                      slicing: Some(codegen_helpers.Slicing(
                        discriminator: [
                          codegen_helpers.Discriminator(
                            type_: "pattern",
                            path: "$this",
                          ),
                        ],
                        ordered: False,
                        rules: "open",
                      )),
                    ),
                    codegen_helpers.Element(
                      ..coding,
                      id: pattern_id,
                      slice_name: Some("pattern"),
                      slicing: None,
                      min: 1,
                      max: "*",
                      pattern_coding: Some(pattern),
                      constraint: option.then(root.constraint, fn(constraint) {
                        case
                          codegen_constraint.field(constraint.value, "coding")
                        {
                          Some(codegen_constraint.Array([value])) ->
                            Some(
                              codegen_constraint.Constraint(
                                ..constraint,
                                type_name: "Coding",
                                value:,
                              ),
                            )
                          _ -> None
                        }
                      }),
                      pattern_match: True,
                    ),
                  ]
                }
              }
            }
          }
        }
        _ -> []
      }
    })
  let concept_pattern_child_ids =
    concept_pattern_children
    |> list.map(fn(child) { child.id })
    |> set.from_list
  let elements =
    elements
    |> list.filter(fn(element) {
      !set.contains(concept_pattern_child_ids, element.id)
    })
    |> list.append(concept_pattern_children)
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
      let fields =
        codegen_slice_complex_type.datatype_fields(type_.code, base_elements)
      base_elements
      |> dict.values
      |> list.filter(fn(child) {
        string.starts_with(child.path, prefix)
        && {
          !string.contains(
            string.drop_start(child.path, string.length(prefix)),
            ".",
          )
          || list.any(fields, fn(field) {
            element_type_is(field, "BackboneElement")
            && string.starts_with(child.path, field.path <> ".")
          })
        }
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
    list.fold(elements, elements, fn(expanded, root) {
      case root.constraint {
        None -> expanded
        Some(constraint) -> {
          // Preserve the existing shared Coding and CodeableConcept types.
          // Their fields are already propagated below; extra fields require a
          // profile record, built by the same recursive expansion as other types.
          let shared = codegen_helpers.constraint_uses_shared_type(root)
          case shared || root.max == "0" {
            True -> expanded
            False ->
              expand_constraint(root, constraint, expanded, base_elements)
          }
        }
      }
    })
  let elements =
    list.map(elements, fn(element) {
      let assert Ok(field) = element.id |> string.split(".") |> list.last
      let parent_id = string.drop_end(element.id, string.length(field) + 1)
      let pattern = case find_element(elements, parent_id) {
        Ok(codegen_helpers.Element(pattern_identifier: Some(pattern), ..)) ->
          case field {
            "system" -> pattern.system
            _ -> None
          }
        Ok(codegen_helpers.Element(pattern_coding: Some(pattern), ..)) ->
          case field {
            "system" -> pattern.system
            "code" -> pattern.code
            "display" -> pattern.display
            _ -> None
          }
        _ -> None
      }
      let pattern =
        option.then(pattern, fn(value) {
          case codegen_constraint.text_can_use_legacy_template(value) {
            True -> Some(value)
            False -> None
          }
        })
      let element = case pattern {
        Some(value) -> {
          let existing = case field {
            "system" -> element.fixed_uri
            _ -> element.fixed_code
          }
          case existing {
            Some(existing) if existing != value ->
              panic as { "conflicting pattern constraints for " <> element.id }
            _ -> Nil
          }
          case element.max {
            "0" ->
              panic as { "pattern requires prohibited field " <> element.id }
            _ -> Nil
          }
          case field {
            "system" ->
              codegen_helpers.Element(..element, min: 1, fixed_uri: Some(value))
            _ ->
              codegen_helpers.Element(
                ..element,
                min: 1,
                fixed_code: Some(value),
              )
          }
        }
        None -> element
      }
      // A named slice supplies its scalar constants whenever its value exists.
      // The cardinality of the slice itself remains unchanged.
      case
        element.max == "1"
        && { element.fixed_uri != None || element.fixed_code != None }
        && list.any(elements, fn(root) {
          root.slice_name != None
          && string.starts_with(element.id, root.id <> ".")
        })
      {
        True -> codegen_helpers.Element(..element, min: int.max(1, element.min))
        False -> element
      }
    })
  let groups =
    elements
    |> list.filter(fn(element) {
      element.slicing != None && !is_extension_slicing(element)
    })
    |> list.sort(fn(a, b) { string.compare(b.id, a.id) })

  let discriminator_elements =
    list.append(discriminator_elements, elements)
    |> list.map(fn(element) { #(element.id, element) })
    |> dict.from_list
    |> dict.values
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
                  base_elements,
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
                        constrained_type_from_elements(
                          element,
                          current_elements,
                          base_elements,
                        )
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
                        let assert Ok(definition) =
                          find_element(current_elements, replacement.0)
                        let assert [datatype] = definition.type_
                        let fields =
                          codegen_slice_complex_type.datatype_fields(
                            datatype.code,
                            base_elements,
                          )
                          |> list.map(fn(field) {
                            string.drop_start(
                              field.path,
                              string.length(datatype.code) + 1,
                            )
                          })
                        let fields = case
                          string.starts_with(type_name, "ct.Codeableconcept")
                        {
                          True ->
                            list.append(
                              fields,
                              codegen_slice_complex_type.datatype_fields(
                                "Coding",
                                base_elements,
                              )
                                |> list.map(fn(field) {
                                  "coding."
                                  <> string.drop_start(
                                    field.path,
                                    string.length("Coding."),
                                  )
                                }),
                            )
                          False -> fields
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
                                list.contains(
                                  codegen_slice_complex_type.required_fields(
                                    type_name,
                                    list.filter(current_elements, fn(candidate) {
                                      string.starts_with(candidate.id, prefix)
                                    }),
                                  ),
                                  codegen_helpers.field_name(child),
                                )
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
                              child.pattern_literals != []
                              || child.slice_name != None
                              || !list.contains(fields, field)
                              || list.any(child.type_, fn(type_) {
                                type_.profile != []
                              })
                              || !cardinality_preserved
                              || case child.binding {
                                Some(binding) ->
                                  binding.strength == "required"
                                  && !fixed_field
                                  && child.binding
                                  != {
                                    dict.get(base_elements, child.base.path)
                                    |> result.map(fn(base) { base.binding })
                                    |> result.unwrap(None)
                                  }
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
                        let prefix = root_id <> "."
                        let nested =
                          string.starts_with(replacement.0, prefix)
                          && string.contains(
                            string.drop_start(
                              replacement.0,
                              string.length(prefix),
                            ),
                            ".",
                          )
                        nested
                        || {
                          case replacement.1 {
                            FixedValueDiscriminator(_) ->
                              case
                                find_element(current_elements, replacement.0)
                              {
                                Ok(child) -> element_type_is(child, "code")
                                Error(_) -> False
                              }
                            _ -> False
                          }
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
      let nested_value_discriminators =
        list.fold(roots, nested_value_discriminators, fn(selected, root) {
          let prefix = root.id <> "."
          case
            list.any(current_elements, fn(element) {
              {
                element.id == root.id || string.starts_with(element.id, prefix)
              }
              && codegen_helpers.constraint_needs_check(element)
            })
          {
            True -> set.insert(selected, root.id)
            False -> selected
          }
        })
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
                _ -> Error(Nil)
              }
            })
          let current_elements =
            list.filter(current_elements, fn(element) {
              !list.contains(type_slice_ids, element.id)
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
    let overrides =
      list.fold(elements, overrides, fn(overrides, root) {
        let eligible = case root.type_ {
          [type_] ->
            dict.has_key(base_elements, type_.code)
            && type_.code != "Element"
            && type_.code != "BackboneElement"
            && type_.code != "Extension"
            && !profile_field_has_primitive_type(root, "")
            && case root.binding {
              Some(codegen_helpers.Binding(
                strength: "required",
                available: True,
                ..,
              )) -> False
              _ -> True
            }
          _ -> False
        }
        case eligible, dict.has_key(overrides, root.id) {
          True, False -> {
            let planned =
              plan_constraint_fields(
                root,
                elements,
                available_valuesets,
                base_elements,
              )
            case planned {
              Ok([
                #(
                  id,
                  FixedSliceType(type_name, _, system, code, display) as shared,
                ),
              ])
                if id == root.id
              -> {
                let complete = {
                  let assert [datatype] = root.type_
                  let fields =
                    codegen_slice_complex_type.datatype_fields(
                      datatype.code,
                      base_elements,
                    )
                    |> list.map(fn(field) {
                      string.drop_start(
                        field.path,
                        string.length(datatype.code) + 1,
                      )
                    })
                  let fields = case
                    string.starts_with(type_name, "ct.Codeableconcept")
                  {
                    True ->
                      list.append(
                        fields,
                        codegen_slice_complex_type.datatype_fields(
                          "Coding",
                          base_elements,
                        )
                          |> list.map(fn(field) {
                            "coding."
                            <> string.drop_start(
                              field.path,
                              string.length("Coding."),
                            )
                          }),
                      )
                    False -> fields
                  }
                  let prefix = root.id <> "."
                  !list.any(elements, fn(child) {
                    case string.starts_with(child.id, prefix) {
                      False -> False
                      True -> {
                        let field =
                          string.drop_start(child.id, string.length(prefix))
                        let fixed_field = case field {
                          "system" | "coding.system" -> system != ""
                          "code" | "coding.code" -> code != ""
                          "display" | "coding.display" -> display != None
                          _ -> False
                        }
                        let required_field =
                          list.contains(
                            codegen_slice_complex_type.required_fields(
                              type_name,
                              list.filter(elements, fn(candidate) {
                                string.starts_with(candidate.id, prefix)
                              }),
                            ),
                            codegen_helpers.field_name(child),
                          )
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
                          False, True, _ -> child.min <= 1 && child.max == "1"
                          False, False, True ->
                            child.min == 1 && child.max == "1"
                          False, False, False ->
                            child.min == child.base.min
                            && child.max == child.base.max
                        }
                        child.pattern_literals != []
                        || child.slice_name != None
                        || !list.contains(fields, field)
                        || list.any(child.type_, fn(type_) {
                          type_.profile != []
                        })
                        || !cardinality_preserved
                        || case child.binding {
                          Some(binding) ->
                            binding.strength == "required"
                            && !fixed_field
                            && child.binding
                            != {
                              dict.get(base_elements, child.base.path)
                              |> result.map(fn(base) { base.binding })
                              |> result.unwrap(None)
                            }
                          None -> False
                        }
                      }
                    }
                  })
                }
                case complete {
                  True -> dict.insert(overrides, root.id, shared)
                  False -> overrides
                }
              }
              _ -> overrides
            }
          }
          _, _ -> overrides
        }
      })
    let shared_roots =
      dict.keys(overrides)
      |> list.filter(fn(id) {
        string.contains(id, ".")
        && case dict.get(overrides, id) {
          Ok(FixedSliceType(..)) -> True
          _ -> False
        }
      })
    let elements = remove_element_trees(elements, shared_roots, False)
    #(
      elements,
      overrides,
      type_slice_overrides,
      set.union(nested_value_discriminators, referenced_slice_ids),
      slice_discriminator_checks,
      discriminator_elements,
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
  dict.Dict(String, codegen_profile_json.ConstructorDefinition),
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
  let core_fields =
    core_constructors
    |> dict.values
    |> list.flat_map(fn(constructor) {
      case constructor {
        codegen_profile_json.RecordConstructor(_, _, fields) ->
          list.map(fields, fn(field) { #(field.0.path, field.0.gleam_type) })
        _ -> []
      }
    })
    |> dict.from_list
  let base_elements =
    dict.map_values(base_elements, fn(path, element) {
      codegen_helpers.Element(
        ..element,
        gleam_type: dict.get(core_fields, path) |> result.unwrap(None),
      )
    })
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
  // Datatype records that need more than a shared field constraint remain
  // datatype profiles. Generate them in complex_types, including their children.
  let #(resources, datatype_profiles) =
    list.fold(
      list.take(normalized_profiles, resource_count),
      #([], datatype_profiles),
      fn(acc, resource) {
        let #(resources, profiles) = acc
        let assert Some(snapshot) = resource.snapshot
        let #(prepared, overrides, _, _, _, definitions) =
          prepare_profile_slices(
            resource.id,
            snapshot.element,
            available_slice_valuesets,
            profiles,
            base_elements,
            extensions,
          )
        let roots =
          prepared
          |> list.filter(fn(root) {
            root.max != "0"
            && !dict.has_key(overrides, root.id)
            && case root.binding {
              // Required bindings already use a complex type that carries the
              // ValueSet. A plain datatype profile would lose that type.
              Some(codegen_helpers.Binding(
                strength: "required",
                available: True,
                ..,
              )) -> False
              _ -> True
            }
            && case root.type_ {
              [type_] ->
                dict.has_key(base_elements, type_.code)
                && type_.code != "Element"
                && type_.code != "BackboneElement"
                && type_.code != "Extension"
                && type_.code != "Resource"
                && type_.code != "DomainResource"
                && !profile_field_has_primitive_type(root, "")
              _ -> False
            }
            && list.any(prepared, fn(child) {
              string.starts_with(child.id, root.id <> ".")
              && {
                child.min != child.base.min
                || child.max != child.base.max
                || codegen_helpers.constant(child) != None
                || case child.slicing {
                  Some(_) -> !element_type_is(child, "Extension")
                  None -> False
                }
              }
            })
          })
        let roots =
          list.filter(roots, fn(root) {
            !list.any(roots, fn(parent) {
              string.starts_with(root.id, parent.id <> ".")
            })
          })
        let profiles =
          list.fold(roots, profiles, fn(profiles, root) {
            let assert [datatype] = root.type_
            let assert Ok(base) = dict.get(base_elements, datatype.code)
            let name =
              codegen_helpers.to_camel_case(datatype.code)
              <> codegen_helpers.to_camel_case(resource.id)
              <> {
                root.id
                |> string.split(".")
                |> list.drop(1)
                |> string.join("_")
                |> string.replace(":", "_")
                |> string.replace("[x]", "")
                |> codegen_helpers.to_camel_case
              }
            let url = "urn:gleam-fhir:inline:" <> resource.id <> ":" <> root.id
            let elements =
              definitions
              |> list.filter(fn(child) {
                string.starts_with(child.id, root.id <> ".")
              })
              |> list.map(fn(child) {
                let child =
                  find_element(prepared, child.id) |> result.unwrap(child)
                codegen_helpers.Element(
                  ..child,
                  id: datatype.code
                    <> string.drop_start(child.id, string.length(root.id)),
                  path: datatype.code
                    <> string.drop_start(child.path, string.length(root.path)),
                )
              })
            dict.insert(
              profiles,
              url,
              codegen_helpers.Resource(
                ..resource,
                id: codegen_helpers.to_snake_case(name),
                name:,
                url:,
                kind: Some("complex-type"),
                type_: Some(datatype.code),
                base_definition: Some(
                  "http://hl7.org/fhir/StructureDefinition/" <> datatype.code,
                ),
                snapshot: Some(
                  codegen_helpers.Snapshot(element: [
                    codegen_helpers.Element(
                      ..base,
                      type_: [codegen_helpers.Type(..datatype, profile: [])],
                      constraint: root.constraint,
                      binding: root.binding,
                      pattern_coding: root.pattern_coding,
                      pattern_codeableconcept: root.pattern_codeableconcept,
                      pattern_identifier: root.pattern_identifier,
                    ),
                    ..elements
                  ]),
                ),
              ),
            )
          })
        let elements =
          snapshot.element
          |> list.filter(fn(child) {
            !list.any(roots, fn(root) {
              string.starts_with(child.id, root.id <> ".")
            })
          })
          |> list.map(fn(element) {
            case
              list.any(roots, fn(root) { root.id == element.id }),
              element.type_
            {
              True, [datatype] ->
                codegen_helpers.Element(..element, type_: [
                  codegen_helpers.Type(..datatype, profile: [
                    "urn:gleam-fhir:inline:" <> resource.id <> ":" <> element.id,
                  ]),
                ])
              _, _ -> element
            }
          })
        #(
          [
            codegen_helpers.Resource(
              ..resource,
              snapshot: Some(codegen_helpers.Snapshot(element: elements)),
            ),
            ..resources
          ],
          profiles,
        )
      },
    )
  let profile_structures =
    ProfileFiles(
      resources: list.reverse(resources),
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
          discriminator_elements,
        ) =
          prepare_profile_slices(
            resource.id,
            profile_elements,
            available_slice_valuesets,
            profile_structures.datatype_profiles,
            base_elements,
            profile_structures.extensions,
          )
        let inline_datatypes =
          profile_elements
          |> list.filter_map(fn(element) {
            case element.type_ {
              [codegen_helpers.Type(profile: [url], ..)] ->
                case string.starts_with(url, "urn:gleam-fhir:inline:") {
                  True -> Ok(element.id)
                  False -> Error(Nil)
                }
              _ -> Error(Nil)
            }
          })
        let profile_elements =
          remove_element_trees(profile_elements, inline_datatypes, False)
        let slice_helpers =
          list.append(
            dict.values(slice_type_overrides),
            dict.values(slice_discriminator_checks),
          )
          |> list.fold(slice_helpers, fn(helpers, override) {
            case override {
              FixedSliceType(type_name, ..) ->
                case
                  string.starts_with(type_name, "ct.")
                  && {
                    string.contains(type_name, "Fixed")
                    || string.contains(type_name, "Required")
                  }
                {
                  True -> set.insert(helpers, type_name)
                  False -> helpers
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
              TypeSlicePlan(children: [_, ..], ..) -> Ok(plan)
              _ -> Error(Nil)
            }
          })
          |> list.sort(fn(a, b) { string.compare(a.root_id, b.root_id) })
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
            let sliced_name =
              dict.get(names, sliced_name)
              |> result.unwrap(sliced_name)
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
        let profile_elements =
          nested_type_slices
          |> list.flat_map(fn(plan) {
            let assert TypeSlicePlan(children:, descendants:, ..) = plan
            list.append(children, descendants)
          })
          |> list.append(profile_elements)
          |> list.map(fn(element) { #(element.id, element) })
          |> dict.from_list
          |> dict.values
          |> list.sort(fn(a, b) { string.compare(a.id, b.id) })

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
                    { codegen_helpers.constant(element) == None }
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
                    let field_name = codegen_helpers.field_name(element)
                    let choice_type =
                      gleam_type
                      <> codegen_helpers.to_camel_case(json_field_name)

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
                    let stored_max = case element.pattern_literals {
                      [] -> element.max
                      _ -> "*"
                    }
                    let cardinality = case card_min, stored_max {
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
                          stored_max,
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
                        stored_max,
                        is_primitive,
                      )
                    let #(newfunc_arg, newfunc_field, required_argument) = case
                      element.pattern_match,
                      element.slice_name,
                      dict.get(slice_type_overrides, element.id)
                    {
                      True, Some(_), Ok(FixedSliceType(type_name, ..)) -> {
                        let assert Ok(value) =
                          codegen_slice_complex_type.discriminator_new_call(
                            current_bucket,
                            type_name,
                            base_elements,
                            codegen_profile_json.constructor_placeholder(
                              constructors,
                              base_elements,
                              current_bucket,
                              _,
                              set.new(),
                              codegen_helpers.ComplexTypes,
                            ),
                          )
                        let value = case is_resource_slice_elt {
                          True ->
                            complex_prefix <> "SliceElt(" <> value <> ", None)"
                          False -> value
                        }
                        #(
                          "",
                          field_name
                            <> ": "
                            <> complex_prefix
                            <> "List1(first: "
                            <> value
                            <> ", rest: []),",
                          None,
                        )
                      }
                      _, _, _ -> #(
                        newfunc_arg,
                        newfunc_field,
                        required_argument,
                      )
                    }
                    let newfunc_field = case meta_profile {
                      None -> newfunc_field
                      Some(#(profile_field, profile_type, _)) -> {
                        let assert Ok(codegen_profile_json.RecordConstructor(
                          _,
                          _,
                          meta_fields,
                        )) =
                          dict.get(
                            constructors,
                            codegen_profile_json.constructor_key(
                              current_bucket,
                              field_type,
                            ),
                          )
                        let meta_field_names =
                          list.map(meta_fields, fn(field) {
                            codegen_helpers.field_name(field.0)
                          })
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
                            case constructor_min {
                              0 -> "[" <> url <> "]"
                              _ -> "[" <> url <> ", .." <> profile_value <> "]"
                            },
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
                        let tagged = case profiles, constructor_min {
                          "", _ | _, 0 -> tagged
                          _, _ ->
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
                        <> codegen_helpers.record_update_source(
                          field_type,
                          "meta",
                          meta_field_names,
                          [#(profile_field, tagged)],
                        )
                        <> " }"
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
                                Ok(TypeSlicePlan(children: [_, ..], ..)) -> #(
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
                    let pattern_indexes = case preserve_slice_order {
                      False -> []
                      True ->
                        list.index_map(element.pattern_literals, fn(_, index) {
                          "internal_gleam_fhir_"
                          <> case string.ends_with(field_name, "_others") {
                            True ->
                              string.drop_end(
                                field_name,
                                string.length("_others"),
                              )
                            False -> field_name
                          }
                          <> case list.length(element.pattern_literals) {
                            1 -> ""
                            _ -> "_" <> int.to_string(index)
                          }
                          <> "_index"
                        })
                    }
                    #(
                      fields_acc
                        <> string.concat(
                        list.map(pattern_indexes, fn(name) {
                          "    " <> name <> ": Option(Int),\n"
                        }),
                      )
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
                      newfunc_fields_acc
                        <> string.concat(
                        list.map(pattern_indexes, fn(name) { name <> ": None," }),
                      )
                        <> newfunc_field,
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
                <> case newfunc_fields {
                  "" -> ""
                  _ -> "(" <> newfunc_fields <> ")"
                }
                <> "\n}\n\n"
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
            discriminator_elements,
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
            snapshot_elements: discriminator_elements,
            discriminator_elements:,
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
  let slice_types =
    slice_helpers
    |> set.to_list
    |> list.sort(string.compare)
    |> list.flat_map(fn(type_name) {
      codegen_slice_complex_type.shared_type(
        type_name,
        base_elements,
        preserve_slice_order,
        codegen_profile_json.constructor_placeholder(
          constructors,
          base_elements,
          codegen_helpers.ComplexTypes,
          _,
          set.new(),
          codegen_helpers.ComplexTypes,
        ),
      )
    })
    |> dict.from_list
    |> dict.to_list
    |> list.sort(fn(a, b) { string.compare(a.0, b.0) })
    |> list.map(fn(entry) { entry.1 })
    |> string.concat
  let profile_complex_types =
    codegen_profile_json.discriminator_match_type_source
    <> slice_types
    <> profile_complex_types
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
    constructors,
  )
}
