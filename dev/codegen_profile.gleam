import codegen_helpers
import filepath
import gleam/dict
import gleam/json
import gleam/list
import gleam/option.{None, Some}
import gleam/set.{type Set}
import gleam/string
import simplifile

type ProfileFiles {
  ProfileFiles(
    resources: List(codegen_helpers.Resource),
    extensions: dict.Dict(String, List(#(String, String))),
    // simple_exts: ext_name -> value[x] Element, for simple extensions
    // (those with a value[x] directly on Extension, no child slices)
    simple_exts: dict.Dict(String, codegen_helpers.Element),
  )
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
  profiles_dir: String,
  all_primitive_ext: Bool,
  valueset_acc: Set(String),
) -> #(String, Set(String)) {
  let assert Ok(files) = simplifile.read_directory(profiles_dir)
  let profile_structures =
    files
    |> list.filter(fn(f) { string.starts_with(f, "StructureDefinition") })
    |> list.fold(ProfileFiles([], dict.new(), dict.new()), fn(acc, f) {
      let fname = profiles_dir |> filepath.join(f)
      let assert Ok(profile_structuredef) = simplifile.read(fname)
      let assert Ok(r) =
        json.parse(
          from: profile_structuredef,
          using: codegen_helpers.resource_decoder(),
        )
      let assert Some(type_) = r.type_
      let #(ext, new_simple_exts) = case type_ {
        "Extension" -> {
          let assert Some(snapshot) = r.snapshot
          let slices =
            list.filter(snapshot.element, fn(e) {
              case string.split(e.id, ":") {
                [_, _] -> True
                _ -> False
              }
            })
          let new_simple_exts = case slices {
            [] ->
              case
                list.find(snapshot.element, fn(e) {
                  e.id == "Extension.value[x]"
                })
              {
                Ok(velt) ->
                  case velt.type_ {
                    [_] ->
                      dict.insert(
                        acc.simple_exts,
                        r.id |> string.replace("-", "_"),
                        velt,
                      )
                    _ -> acc.simple_exts
                  }
                Error(_) -> acc.simple_exts
              }
            _ -> acc.simple_exts
          }
          let new_ext =
            list.fold(
              from: acc.extensions,
              over: r.context,
              with: fn(ext_acc, ext_ctx) {
                let entry = #(r.url, r.id |> string.replace("-", "_"))
                case dict.get(ext_acc, ext_ctx.expression) {
                  Ok(exprs) ->
                    dict.insert(ext_acc, ext_ctx.expression, [entry, ..exprs])
                  Error(_) -> dict.insert(ext_acc, ext_ctx.expression, [entry])
                }
              },
            )
          #(new_ext, new_simple_exts)
        }
        _ -> #(acc.extensions, acc.simple_exts)
      }
      let resources = case r.kind {
        Some("resource") -> [r, ..acc.resources]
        _ -> acc.resources
      }
      ProfileFiles(resources, ext, new_simple_exts)
    })
  let profile_resources =
    profile_structures.resources
    |> list.sort(fn(a, b) { string.compare(a.id, b.id) })

  list.fold(
    over: profile_resources,
    from: #("", valueset_acc),
    with: fn(acc, resource) {
      let #(generated_acc, valueset_acc) = acc
      let assert Some(snapshot) = resource.snapshot
      let profile_prefix = string.replace(resource.id, "-", "_")
      let profile_type = case codegen_helpers.to_camel_case(profile_prefix) {
        "List" -> "Listfhir"
        profile_type -> profile_type
      }

      let #(type_fields, type_order) =
        snapshot.element
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
        list.fold(snapshot.element, dict.new(), fn(acc, slice) {
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
                  let safe_field_name = case json_field_name {
                    "type" -> "type_"
                    "use" -> "use_"
                    "case" -> "case_"
                    "const" -> "const_"
                    "import" -> "import_"
                    "test" -> "test_"
                    "assert" -> "assert_"
                    _ -> json_field_name
                  }
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
                    does_profile_restrict_complex_type(type_order, field_path)
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

      #(generated_acc <> generated_profile, valueset_acc)
    },
  )
}
