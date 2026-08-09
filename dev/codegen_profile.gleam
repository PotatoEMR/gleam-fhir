import codegen_helpers
import filepath
import gleam/dict
import gleam/dynamic/decode
import gleam/json
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/set.{type Set}
import gleam/string
import simplifile

type ProfileFiles {
  ProfileFiles(
    resources: List(codegen_helpers.Resource),
    extensions: dict.Dict(String, ExtensionDefinition),
  )
}

type ExtensionDefinition {
  ExtensionDefinition(name: String, kind: ExtensionKind)
}

type ExtensionKind {
  SimpleExtension(codegen_helpers.Element)
  ComplexExtension(List(codegen_helpers.Element))
}

type PackageIndexFile {
  PackageIndexFile(filename: String, url: Option(String), type_: Option(String))
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
  decode.success(PackageIndexFile(filename:, url:, type_:))
}

fn canonical_url(url: String) -> String {
  let assert [url, ..] = string.split(url, "|")
  url
}

fn read_structure_definition(path: String) -> codegen_helpers.Resource {
  let assert Ok(contents) = simplifile.read(path)
  let assert Ok(resource) =
    json.parse(contents, codegen_helpers.resource_decoder())
  resource
}

fn root_profile_resources(profiles_dir: String) {
  let assert Ok(files) = simplifile.read_directory(profiles_dir)
  files
  |> list.filter(fn(file) { string.starts_with(file, "StructureDefinition") })
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

fn package_directories(profiles_dir: String) {
  let package_store =
    profiles_dir
    |> filepath.directory_name
    |> filepath.directory_name
    |> filepath.directory_name
  let assert Ok(package_names) = simplifile.read_directory(package_store)

  package_names
  |> list.flat_map(fn(package_name) {
    let package_path = filepath.join(package_store, package_name)
    case simplifile.read_directory(package_path) {
      Error(_) -> []
      Ok(versions) ->
        list.filter_map(versions, fn(version) {
          let directory =
            package_path |> filepath.join(version) |> filepath.join("package")
          case simplifile.is_directory(directory) {
            Ok(True) -> Ok(directory)
            _ -> Error(Nil)
          }
        })
    }
  })
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
            _ -> Some(ComplexExtension([value]))
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
      Some(ComplexExtension(fields))
    }
  }
}

fn extension_definitions(
  profiles_dir: String,
  referenced_urls: Set(String),
) -> dict.Dict(String, ExtensionDefinition) {
  package_directories(profiles_dir)
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

fn load_profile_files(profiles_dir: String) -> ProfileFiles {
  let structures = root_profile_resources(profiles_dir)
  let resources =
    list.filter(structures, fn(resource) { resource.kind == Some("resource") })
  let extensions =
    structures
    |> referenced_extension_urls
    |> extension_definitions(profiles_dir, _)
  ProfileFiles(resources:, extensions:)
}

fn extension_field_name(element: codegen_helpers.Element) -> String {
  let assert Ok(name) = element.id |> string.split(".") |> list.last
  name
  |> string.replace("[x]", "")
  |> codegen_helpers.escape_field_name
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
      let #(variants, valueset_acc) =
        list.fold(types, #("", valueset_acc), fn(acc, type_) {
          let #(variants, valueset_acc) = acc
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
            valueset_acc,
          )
        })
      #(
        choice_name,
        "pub type " <> choice_name <> " {\n" <> variants <> "}\n\n",
        valueset_acc,
      )
    }
  }
}

fn generate_extension_types(
  extensions: dict.Dict(String, ExtensionDefinition),
  valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
) -> #(String, dict.Dict(String, codegen_helpers.ValuesetItem)) {
  extensions
  |> dict.values
  |> list.sort(fn(a, b) { string.compare(a.name, b.name) })
  |> list.fold(#("", valueset_acc), fn(acc, extension) {
    let #(source, valueset_acc) = acc
    case extension.kind {
      SimpleExtension(_) -> #(source, valueset_acc)
      ComplexExtension([]) -> #(source, valueset_acc)
      ComplexExtension(fields) -> {
        let #(field_source, choice_source, valueset_acc) =
          list.fold(fields, #("", "", valueset_acc), fn(acc, field) {
            let #(field_source, choice_source, valueset_acc) = acc
            let #(field_type, new_choice, valueset_acc) =
              extension_field_type(extension.name, field, valueset_acc)
            let field_name =
              field |> extension_field_name |> codegen_helpers.to_snake_case
            #(
              field_source
                <> "    "
                <> field_name
                <> ": "
                <> codegen_helpers.cardinality(field_type, field.min, field.max)
                <> ",\n",
              choice_source <> new_choice,
              valueset_acc,
            )
          })
        #(
          source
            <> "pub type "
            <> extension.name
            <> " {\n  "
            <> extension.name
            <> "(\n"
            <> field_source
            <> "  )\n}\n\n"
            <> choice_source,
          valueset_acc,
        )
      }
    }
  })
}

fn profile_extension_definition(
  element: codegen_helpers.Element,
  extensions: dict.Dict(String, ExtensionDefinition),
) -> Option(ExtensionDefinition) {
  case element.type_ {
    [codegen_helpers.Type(code: "Extension", profile: [url, ..], ..), ..] ->
      case dict.get(extensions, canonical_url(url)) {
        Error(_) -> None
        Ok(extension) -> Some(extension)
      }
    _ -> None
  }
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

fn profile_extension_type(
  element: codegen_helpers.Element,
  extensions: dict.Dict(String, ExtensionDefinition),
  valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
) -> Option(#(String, dict.Dict(String, codegen_helpers.ValuesetItem))) {
  case profile_extension_definition(element, extensions) {
    None -> None
    Some(ExtensionDefinition(name:, kind: ComplexExtension(_))) ->
      Some(#("ct." <> name, valueset_acc))
    Some(ExtensionDefinition(kind: SimpleExtension(value), ..)) -> {
      let assert [type_] = value.type_
      let #(gleam_type, valueset_acc) =
        codegen_helpers.string_to_type(
          type_.code,
          ["Extension", "value"],
          value,
          codegen_helpers.Resources,
          valueset_acc,
        )
      Some(#(gleam_type, valueset_acc))
    }
  }
}

// profile may not restrict a complex type
// eg us core medicationrequest dosage is just normal dosage with mustsupport
// in that case can just use ct.Dosage instead of generating some shit
// so a) don't generate new type b) use normal ct.Dosage in UsCoreMedicationrequest
fn does_profile_restrict_complex_type(
  type_order: List(String),
  field_path: String,
) -> Bool {
  list.contains(type_order, field_path)
}

pub fn profile_files_to_types(
  profiles_dir: Option(String),
  all_primitive_ext: Bool,
  valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
) -> #(String, String, dict.Dict(String, codegen_helpers.ValuesetItem)) {
  let assert Some(profiles_dir) = profiles_dir
    as "if custom profile should have profiles dir"
  let profile_structures = load_profile_files(profiles_dir)
  let profile_resources =
    profile_structures.resources
    |> list.sort(fn(a, b) { string.compare(a.id, b.id) })
  let #(extension_types, valueset_acc) =
    generate_extension_types(profile_structures.extensions, valueset_acc)

  list.fold(
    over: profile_resources,
    from: #(extension_types, "", valueset_acc),
    with: fn(acc, resource) {
      let #(extension_types, generated_acc, valueset_acc) = acc
      let assert Some(snapshot) = resource.snapshot
      let profile_elements =
        remove_profile_extension_children(
          snapshot.element,
          profile_structures.extensions,
        )
      let profile_prefix = string.replace(resource.id, "-", "_")
      let profile_type = case codegen_helpers.to_camel_case(profile_prefix) {
        "List" -> "Listfhir"
        profile_type -> profile_type
      }

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
                type_order
                |> set.insert(field_parent)
                |> set.insert(field_path)
              Some(_), True -> set.insert(type_order, field_path)
              None, _ -> type_order
            }
            #(type_fields, type_order)
          },
        )
      let type_order =
        type_order
        |> set.to_list
        |> list.filter(fn(type_) { dict.has_key(type_fields, type_) })
        |> list.sort(fn(a, b) { string.compare(b, a) })
      let choice_slice_types =
        list.fold(profile_elements, dict.new(), fn(acc, slice) {
          case slice.slice_name, slice.type_ {
            Some(_), [slice_type] -> {
              let slice_parts =
                slice.id
                |> string.replace("-", "")
                |> string.replace(":", ".")
                |> string.split(".")
              let assert [_, ..slice_rest] = slice_parts
              let slice_path =
                [profile_prefix, ..slice_rest]
                |> string.join("_")
              case
                string.ends_with(slice.path, "[x]"),
                does_profile_restrict_complex_type(type_order, slice_path)
              {
                True, True ->
                  dict.insert(
                    acc,
                    #(slice.path, slice_type.code),
                    slice_path
                      |> string.replace("[x]", "")
                      |> codegen_helpers.to_camel_case,
                  )
                _, _ -> acc
              }
            }
            _, _ -> acc
          }
        })

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
            let assert Ok(fields) = dict.get(type_fields, current_type)
            let fields =
              list.filter(fields, fn(element) {
                element.max != "0"
                && case element.slicing {
                  Some(slicing) ->
                    slicing.rules != "closed"
                    || string.contains(element.path, "[x]")
                  None -> True
                }
              })

            let #(field_source, choice_source, valueset_acc) =
              list.fold(
                over: fields,
                from: #("", "", valueset_acc),
                with: fn(acc, element) {
                  let #(fields_acc, choices_acc, valueset_acc) = acc
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
                    codegen_helpers.to_snake_case(safe_field_name)
                  let choice_type =
                    gleam_type <> string.capitalise(safe_field_name)

                  let is_primitive = case element.type_ {
                    [only_type] ->
                      case only_type.code {
                        "base64Binary"
                        | "boolean"
                        | "canonical"
                        | "code"
                        | "date"
                        | "dateTime"
                        | "decimal"
                        | "id"
                        | "instant"
                        | "integer"
                        | "integer64"
                        | "markdown"
                        | "oid"
                        | "positiveInt"
                        | "string"
                        | "time"
                        | "unsignedInt"
                        | "uri"
                        | "url"
                        | "uuid"
                        | "xhtml"
                        | "http://hl7.org/fhirpath/System.String" ->
                          json_field_name != "id" && all_primitive_ext
                        _ -> False
                      }
                    _ -> False
                  }

                  let #(base_field_type, valueset_acc) = case
                    profile_extension_type(
                      element,
                      profile_structures.extensions,
                      valueset_acc,
                    )
                  {
                    Some(extension_type) -> extension_type
                    None ->
                      case
                        does_profile_restrict_complex_type(
                          type_order,
                          field_path,
                        )
                      {
                        True -> #(
                          field_path
                            |> string.replace("[x]", "")
                            |> codegen_helpers.to_camel_case,
                          valueset_acc,
                        )
                        False ->
                          case element.type_ {
                            [only_type] ->
                              codegen_helpers.string_to_type(
                                only_type.code,
                                all_parts,
                                element,
                                codegen_helpers.Resources,
                                valueset_acc,
                              )
                            [] -> #(
                              codegen_helpers.link_type_from(
                                element.content_reference,
                                profile_prefix,
                              )
                                |> codegen_helpers.to_camel_case,
                              valueset_acc,
                            )
                            _ -> #(choice_type, valueset_acc)
                          }
                      }
                  }
                  let field_type = case is_primitive {
                    True -> "Primitive(" <> base_field_type <> ")"
                    False -> base_field_type
                  }
                  let card_min = case is_primitive, element.max {
                    True, "*" -> 0
                    True, _ -> 1
                    False, _ -> element.min
                  }
                  let card_min = case element.slicing {
                    Some(slicing) ->
                      case
                        slicing.rules == "open"
                        && !string.contains(element.path, "[x]")
                      {
                        True -> 0
                        False -> card_min
                      }
                    None -> card_min
                  }
                  let cardinality =
                    codegen_helpers.cardinality(
                      field_type,
                      card_min,
                      element.max,
                    )

                  let #(new_choice_source, valueset_acc) = case element.type_ {
                    [] | [_] -> #("", valueset_acc)
                    choice_types -> {
                      let #(variants, valueset_acc) =
                        list.fold(
                          over: choice_types,
                          from: #("", valueset_acc),
                          with: fn(acc, choice) {
                            let #(variants_acc, valueset_acc) = acc
                            let #(variant_type, valueset_acc) = case
                              dict.get(choice_slice_types, #(
                                element.path,
                                choice.code,
                              ))
                            {
                              Ok(slice_type) -> #(slice_type, valueset_acc)
                              Error(_) ->
                                codegen_helpers.string_to_type(
                                  choice.code,
                                  [
                                    "somehow this is used in [x] for any type (int, bool, code, etc) and ofc that code has no defined binding",
                                  ],
                                  element,
                                  codegen_helpers.Resources,
                                  valueset_acc,
                                )
                            }
                            #(
                              variants_acc
                                <> "  "
                                <> choice_type
                                <> string.capitalise(choice.code)
                                <> "(value: "
                                <> variant_type
                                <> ")\n",
                              valueset_acc,
                            )
                          },
                        )
                      #(
                        "pub type "
                          <> choice_type
                          <> " {\n"
                          <> variants
                          <> "}\n\n",
                        valueset_acc,
                      )
                    }
                  }

                  #(
                    fields_acc
                      <> "    "
                      <> field_name
                      <> ": "
                      <> cardinality
                      <> ",\n",
                    new_choice_source <> choices_acc,
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
              <> choice_source
            #(declaration <> types_acc, valueset_acc)
          },
        )

      #(extension_types, generated_acc <> generated_profile, valueset_acc)
    },
  )
}
