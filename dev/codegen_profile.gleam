import codegen_bound_coding
import codegen_decode
import codegen_helpers
import codegen_profile_json.{
  type ExtensionDefinition, type SliceFieldType, type SlicePlan,
  BoundCodeableconceptSlice, ComplexExtension, ExtensionDefinition,
  FixedSliceType, SimpleExtension, TypeSlicePlan, ValueSlicePlan,
  aggregate_slice_constructor, aggregate_value_slice_roots,
  does_profile_restrict_complex_type, extension_field_name,
  extension_field_to_json_call, find_element, profile_base_field_type,
  profile_extension_definition, profile_field_is_primitive, profile_field_min,
}
import codegen_slice_complex_type
import codegen_to_json
import filepath
import gleam/dict
import gleam/dynamic/decode
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
  )
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
            let field_name =
              field |> extension_field_name |> codegen_helpers.to_snake_case
            let #(newfunc_arg, newfunc_field) =
              codegen_helpers.new_fn_arg_and_field(
                field_name,
                field_type,
                field.min,
                field.max,
                False,
              )
            let to_json = fn(value) {
              extension_field_to_json_call(
                extension.name,
                field,
                field_type,
                value,
              )
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
                <> codegen_helpers.cardinality(field_type, field.min, field.max)
                <> ",\n",
              choice_source <> new_choice,
              newfunc_args <> newfunc_arg,
              newfunc_fields <> newfunc_field,
              encoder_args <> field_name <> ":,",
              children_source <> new_children_source,
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
            <> "  )\n}\n\npub fn "
            <> codegen_helpers.to_snake_case(extension.name)
            <> "_new("
            <> newfunc_args
            <> ") -> "
            <> extension.name
            <> " {\n  "
            <> extension.name
            <> "("
            <> newfunc_fields
            <> ")\n}\n\npub fn "
            <> codegen_helpers.to_snake_case(extension.name)
            <> "_to_json(value: "
            <> extension.name
            <> ", url: String) -> Json {\n  let "
            <> extension.name
            <> "("
            <> encoder_args
            <> ") = value\n  let children = []"
            <> children_source
            <> "\n  json.object([#(\"url\", json.string(url)), #(\"extension\", json.preprocessed_array(children))])\n}\n\n"
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

fn has_system_and_code(
  value: codegen_helpers.DiscriminatorCodingValue,
) -> Bool {
  value.system != None && value.code != None
}

fn is_single_coding_pattern(
  value: codegen_helpers.DiscriminatorCodeableconceptValue,
) -> Bool {
  case value.coding {
    [coding] -> has_system_and_code(coding)
    _ -> False
  }
}

fn discriminator_paths(slicing: codegen_helpers.Slicing) -> List(String) {
  slicing.discriminator
  |> list.filter_map(fn(discriminator) {
    case discriminator.type_ {
      "value" -> Ok(discriminator.path)
      _ -> Error(Nil)
    }
  })
  |> list.sort(string.compare)
}

fn only_value_discriminators(slicing: codegen_helpers.Slicing) -> Bool {
  list.length(discriminator_paths(slicing))
  == list.length(slicing.discriminator)
}

fn plan_whole_value_slice(
  root: codegen_helpers.Element,
  elements: List(codegen_helpers.Element),
  available_valuesets: dict.Dict(String, codegen_helpers.VsOrCs),
) -> Result(SlicePlan, String) {
  case
    root.type_,
    root.pattern_coding,
    root.pattern_codeableconcept,
    root.pattern_identifier
  {
    [codegen_helpers.Type(code: "Coding", ..)], Some(pattern), _, _ ->
      case has_system_and_code(pattern) {
        True ->
          Ok(
            ValueSlicePlan([
              #(root.id, FixedSliceType("ct.CodingDiscriminator")),
            ]),
          )
        False -> Error("Coding pattern does not fix system and code")
      }
    [codegen_helpers.Type(code: "CodeableConcept", ..)], _, Some(pattern), _ ->
      case is_single_coding_pattern(pattern) {
        True ->
          Ok(
            ValueSlicePlan([
              #(root.id, FixedSliceType("ct.CodeableconceptDiscriminator")),
            ]),
          )
        False -> Error("CodeableConcept pattern is not one system/code pair")
      }
    [codegen_helpers.Type(code: "Identifier", ..)],
      _,
      _,
      Some(codegen_helpers.DiscriminatorIdentifierValue(
        system: Some(_),
        value: None,
      ))
    -> {
      let requires_value = case find_element(elements, root.id <> ".value") {
        Ok(value) -> value.min > 0
        Error(_) -> False
      }
      let type_ = case requires_value {
        True -> "ct.IdentifierDiscriminatorSystemRequiredValue"
        False -> "ct.IdentifierDiscriminatorSystem"
      }
      Ok(ValueSlicePlan([#(root.id, FixedSliceType(type_))]))
    }
    [codegen_helpers.Type(code: "CodeableConcept", ..)], _, _, _ ->
      case root.binding {
        Some(codegen_helpers.Binding(
          strength: "required",
          value_set: Some(value_set),
        )) -> {
          let value_set = canonical_url(value_set)
          case
            codegen_helpers.valueset_can_generate_system(
              value_set,
              available_valuesets,
            )
          {
            True -> Ok(ValueSlicePlan([#(root.id, BoundCodeableconceptSlice)]))
            False -> Error("can't expand valueset " <> value_set)
          }
        }
        _ -> Error("unsupported $this value pattern")
      }
    _, _, _, _ -> Error("unsupported $this value pattern")
  }
}

fn plan_system_code_slice(
  root: codegen_helpers.Element,
  elements: List(codegen_helpers.Element),
) -> Result(SlicePlan, String) {
  let coding_id = root.id <> ".coding"
  let code_id = coding_id <> ".code"
  let system_id = coding_id <> ".system"
  case
    find_element(elements, coding_id),
    find_element(elements, code_id),
    find_element(elements, system_id)
  {
    Ok(coding), Ok(code), Ok(system) ->
      case
        element_type_is(coding, "Coding"),
        code.fixed_code,
        system.fixed_uri
      {
        True, Some(_), Some(_) ->
          Ok(
            ValueSlicePlan([
              #(coding_id, FixedSliceType("ct.CodingDiscriminator")),
            ]),
          )
        _, _, _ -> Error("coding.system and coding.code are not fixed literals")
      }
    _, _, _ -> Error("coding.system and coding.code are not fixed literals")
  }
}

fn plan_child_value_slice(
  root: codegen_helpers.Element,
  path: String,
  elements: List(codegen_helpers.Element),
) -> Result(SlicePlan, String) {
  let child_id = root.id <> "." <> path
  use child <- result.try(
    find_element(elements, child_id)
    |> result.replace_error("missing discriminator element " <> child_id),
  )
  case
    root.type_,
    path,
    child.type_,
    child.pattern_codeableconcept,
    child.pattern_coding
  {
    [codegen_helpers.Type(code: "Identifier", ..)], "type", _, Some(pattern), _
    ->
      case is_single_coding_pattern(pattern) {
        True ->
          Ok(
            ValueSlicePlan([
              #(root.id, FixedSliceType("ct.IdentifierDiscriminatorType")),
            ]),
          )
        False -> Error("Identifier.type pattern is not one system/code pair")
      }
    _, _, [codegen_helpers.Type(code: "CodeableConcept", ..)], Some(pattern), _
    ->
      case is_single_coding_pattern(pattern) {
        True ->
          Ok(
            ValueSlicePlan([
              #(child_id, FixedSliceType("ct.CodeableconceptDiscriminator")),
            ]),
          )
        False -> Error("CodeableConcept pattern is not one system/code pair")
      }
    _, _, [codegen_helpers.Type(code: "Coding", ..)], _, Some(pattern) ->
      case has_system_and_code(pattern) {
        True ->
          Ok(
            ValueSlicePlan([
              #(child_id, FixedSliceType("ct.CodingDiscriminator")),
            ]),
          )
        False -> Error("Coding pattern does not fix system and code")
      }
    _, _, _, _, _ -> Error("unsupported value pattern at " <> child_id)
  }
}

fn plan_value_slice(
  slicing: codegen_helpers.Slicing,
  root: codegen_helpers.Element,
  elements: List(codegen_helpers.Element),
  available_valuesets: dict.Dict(String, codegen_helpers.VsOrCs),
) -> Result(SlicePlan, String) {
  case only_value_discriminators(slicing), discriminator_paths(slicing) {
    True, ["$this"] ->
      plan_whole_value_slice(root, elements, available_valuesets)
    True, ["coding.code", "coding.system"] ->
      plan_system_code_slice(root, elements)
    True, [path] if path == "code" || path == "type" ->
      plan_child_value_slice(root, path, elements)
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
) -> Result(SlicePlan, String) {
  case slicing.discriminator, root.type_ {
    [codegen_helpers.Discriminator(type_: "type", path: "$this")],
      [codegen_helpers.Type(code:, ..)]
    ->
      Ok(TypeSlicePlan(
        root_id: group.id,
        fhir_type: code,
        slice: root,
        children: list.filter(elements, fn(element) {
          let prefix = root.id <> "."
          string.starts_with(element.id, prefix)
          && !string.contains(
            string.drop_start(element.id, string.length(prefix)),
            ".",
          )
        }),
      ))
    _, _ -> plan_value_slice(slicing, root, elements, available_valuesets)
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
      && only_value_discriminators(slicing)
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
) -> #(
  List(codegen_helpers.Element),
  dict.Dict(String, SliceFieldType),
  dict.Dict(String, SlicePlan),
) {
  let groups =
    elements
    |> list.filter(fn(element) {
      element.slicing != None && !is_extension_slicing(element)
    })
    |> list.sort(fn(a, b) { string.compare(a.id, b.id) })

  list.fold(groups, #(elements, dict.new(), dict.new()), fn(acc, group) {
    let #(current_elements, overrides, type_slice_overrides) = acc
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
          )
        {
          Ok(plan) -> #([plan, ..plans], unsupported_ids)
          Error(reason) -> {
            io.println(
              "not slicing "
              <> discriminator_type
              <> " discriminator "
              <> resource_id
              <> " "
              <> root.id
              <> case reason {
                "" -> ""
                _ -> " because " <> reason
              },
            )
            #(plans, [root.id, ..unsupported_ids])
          }
        }
      })
    let current_elements =
      remove_element_trees(current_elements, unsupported_ids, True)
    let type_slice_ids =
      plans
      |> list.filter_map(fn(plan) {
        case plan {
          TypeSlicePlan(slice:, ..) -> Ok(slice.id)
          ValueSlicePlan(_) -> Error(Nil)
        }
      })
    let current_elements =
      remove_element_trees(current_elements, type_slice_ids, True)
    let replacement_ids =
      plans
      |> list.flat_map(fn(plan) {
        case plan {
          ValueSlicePlan(pairs) -> list.map(pairs, fn(pair) { pair.0 })
          TypeSlicePlan(..) -> []
        }
      })
    let current_elements =
      remove_element_trees(current_elements, replacement_ids, False)
    let overrides =
      plans
      |> list.flat_map(fn(plan) {
        case plan {
          ValueSlicePlan(pairs) -> pairs
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
            dict.insert(overrides, type_slice_key(root_id, fhir_type), plan)
          ValueSlicePlan(_) -> overrides
        }
      })
    let current_elements = case plans {
      [] ->
        list.map(current_elements, fn(element) {
          case element.id == group.id {
            True -> codegen_helpers.Element(..element, slicing: None)
            False -> element
          }
        })
      _ -> current_elements
    }
    #(current_elements, overrides, type_slice_overrides)
  })
}

pub fn profile_files_to_types(
  profiles_dir: String,
  all_primitive_ext: Bool,
  valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
) -> #(
  String,
  String,
  dict.Dict(String, codegen_helpers.ValuesetItem),
  dict.Dict(String, codegen_helpers.VsOrCs),
) {
  let profile_structures = load_profile_files(profiles_dir)
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
        -> Ok(canonical_url(value_set))
        _, _ -> Error(Nil)
      }
    })
    |> set.from_list
  }
  let resource_elements =
    profile_structures.resources
    |> list.flat_map(fn(resource) {
      case resource.snapshot {
        None -> []
        Some(snapshot) -> snapshot.element
      }
    })
  let extension_elements =
    profile_structures.extensions
    |> dict.values
    |> list.flat_map(fn(extension) {
      case extension.kind {
        SimpleExtension(element) -> [element]
        ComplexExtension(elements) -> elements
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
  let #(extension_types, valueset_acc) =
    generate_extension_types(profile_structures.extensions, valueset_acc)
  let slice_types =
    codegen_bound_coding.found_result
    <> codegen_slice_complex_type.slice_coding
    <> codegen_slice_complex_type.slice_codeableconcept
    <> codegen_slice_complex_type.slice_identifier_type
    <> codegen_slice_complex_type.slice_identifier_system
    <> codegen_slice_complex_type.slice_identifier_system_reqvalue

  let #(profile_complex_types, profile_resources, valueset_acc) =
    list.fold(
      over: profile_resources,
      from: #(slice_types <> extension_types, "", valueset_acc),
      with: fn(acc, resource) {
        let #(extension_types, generated_acc, valueset_acc) = acc
        let assert Some(snapshot) = resource.snapshot
        let profile_elements =
          remove_profile_extension_children(
            snapshot.element,
            profile_structures.extensions,
          )
        let #(profile_elements, slice_type_overrides, type_slice_overrides) =
          prepare_profile_slices(
            resource.id,
            profile_elements,
            available_slice_valuesets,
          )
        let profile_prefix = string.replace(resource.id, "-", "_")
        let profile_type = case codegen_helpers.to_camel_case(profile_prefix) {
          "List" -> "Listfhir"
          profile_type -> profile_type
        }
        let open_slice_type_names =
          profile_elements
          |> list.filter_map(fn(element) {
            case element.slicing, string.ends_with(element.path, "[x]") {
              Some(codegen_helpers.Slicing(rules: "open", ..)), False -> {
                let assert [_, ..rest] =
                  element.id
                  |> string.replace("-", "")
                  |> string.replace(":", ".")
                  |> string.split(".")
                let base_name =
                  [profile_prefix, ..rest]
                  |> string.join("_")
                  |> codegen_helpers.to_camel_case
                Ok(#(base_name, base_name <> "Open"))
              }
              _, _ -> Error(Nil)
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
                  case dict.has_key(slice_type_overrides, element.id) {
                    True -> set.insert(type_order, field_parent)
                    False ->
                      type_order
                      |> set.insert(field_parent)
                      |> set.insert(field_path)
                  }
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
                dict.get(open_slice_type_names, gleam_type)
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
                  && !set.contains(aggregate_slice_root_ids, element.id)
                  && case element.slicing {
                    Some(slicing) ->
                      slicing.rules != "closed"
                      || string.contains(element.path, "[x]")
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
                      codegen_helpers.to_snake_case(safe_field_name)
                    let choice_type =
                      gleam_type <> string.capitalise(safe_field_name)

                    let is_primitive =
                      profile_field_is_primitive(
                        element,
                        json_field_name,
                        all_primitive_ext,
                      )

                    let #(base_field_type, valueset_acc) =
                      profile_base_field_type(
                        element,
                        all_parts,
                        field_path,
                        choice_type,
                        profile_structures.extensions,
                        type_order,
                        open_slice_type_names,
                        slice_type_overrides,
                        valueset_acc,
                      )
                    // for example identifier slice in https://build.fhir.org/ig/HL7/US-Core/StructureDefinition-us-core-practitioner.html
                    // has identifier 1..* with 2 sliced identifiers NPI and NCSBNID plus open slice
                    // so we make the whole identifier field a List1
                    // unfortunately that means you cant directly access one identifier
                    // but it does enforce minimum 1 identifier overall
                    //
                    // and what if parent is 7..* but one sliced child is 3..* ?
                    // well then need 4..* slice variants plus 3..* specific slice child
                    let #(base_field_type, aggregate_slice_source, valueset_acc) = case
                      dict.get(aggregate_slice_groups, element.id)
                    {
                      Error(_) -> #(base_field_type, "", valueset_acc)
                      Ok(#(roots, _)) -> {
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
                                choice_type,
                                profile_structures.extensions,
                                type_order,
                                open_slice_type_names,
                                slice_type_overrides,
                                valueset_acc,
                              )
                            #(
                              variants
                                <> "  "
                                <> aggregate_slice_constructor(
                                choice_type,
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
                            choice_type,
                            "Open",
                            base_field_type,
                          )
                          <> "(value: "
                          <> base_field_type
                          <> ")\n"
                        #(
                          choice_type,
                          "pub type "
                            <> choice_type
                            <> " {\n"
                            <> variants
                            <> "}\n\n",
                          valueset_acc,
                        )
                      }
                    }
                    let field_type = case is_primitive {
                      True -> "Primitive(" <> base_field_type <> ")"
                      False -> base_field_type
                    }
                    let card_min = case
                      dict.get(aggregate_slice_groups, element.id)
                    {
                      Ok(#(_, remaining_minimum)) -> remaining_minimum
                      Error(_) -> profile_field_min(element, is_primitive)
                    }
                    let cardinality =
                      codegen_helpers.cardinality(
                        field_type,
                        card_min,
                        element.max,
                      )
                    let #(newfunc_arg, newfunc_field) =
                      codegen_helpers.new_fn_arg_and_field(
                        field_name,
                        field_type,
                        card_min,
                        element.max,
                        is_primitive,
                      )

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
                                Ok(TypeSlicePlan(children:, ..)) -> {
                                  let sliced_name =
                                    choice_type
                                    <> string.capitalise(choice.code)
                                    <> "Sliced"
                                  let #(
                                    fields,
                                    newfunc_args,
                                    newfunc_fields,
                                    valueset_acc,
                                  ) =
                                    children
                                    |> list.filter(fn(child) {
                                      child.max != "0"
                                      && child.fixed_code == None
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
                                        let assert [child_type] = child.type_
                                        let assert Ok(field_name) =
                                          child.path
                                          |> string.split(".")
                                          |> list.last
                                        let field_name =
                                          codegen_helpers.escape_field_name(
                                            field_name,
                                          )
                                        let field_name =
                                          codegen_helpers.to_snake_case(
                                            field_name,
                                          )
                                        let #(gleam_type, valueset_acc) =
                                          codegen_helpers.string_to_type(
                                            child_type.code,
                                            [sliced_name, field_name],
                                            child,
                                            codegen_helpers.Resources,
                                            valueset_acc,
                                          )
                                        let #(newfunc_arg, newfunc_field) =
                                          codegen_helpers.new_fn_arg_and_field(
                                            field_name,
                                            gleam_type,
                                            child.min,
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
                                            child.min,
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
                                Error(_) | Ok(ValueSlicePlan(_)) -> {
                                  let #(variant_type, valueset_acc) =
                                    codegen_helpers.string_to_type(
                                      choice.code,
                                      [
                                        "somehow this is used in [x] for any type (int, bool, code, etc) and ofc that code has no defined binding",
                                      ],
                                      element,
                                      codegen_helpers.Resources,
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
            snapshot.element,
            profile_prefix,
            profile_type,
            type_order,
            type_fields,
            profile_structures.extensions,
            open_slice_type_names,
            slice_type_overrides,
            type_slice_overrides,
            all_primitive_ext,
            valueset_acc,
          )
        let profile_decoders =
          codegen_profile_json.generate_decoders(
            resource_type,
            snapshot.element,
            profile_prefix,
            profile_type,
            type_order,
            type_fields,
            profile_structures.extensions,
            open_slice_type_names,
            slice_type_overrides,
            type_slice_overrides,
            all_primitive_ext,
            valueset_acc,
          )

        #(
          extension_types,
          generated_acc
            <> generated_profile
            <> profile_encoders
            <> profile_decoders,
          valueset_acc,
        )
      },
    )
  #(
    profile_complex_types,
    codegen_decode.result_or_decode_failure
      <> codegen_bound_coding.find_elt_and_rest_result
      <> codegen_bound_coding.find_required_elt_and_rest_result
      <> codegen_bound_coding.find_optional_elt_and_rest_result
      <> codegen_bound_coding.find_elt_and_rest_found
      <> codegen_bound_coding.find_required_elt_and_rest_found
      <> codegen_bound_coding.find_optional_elt_and_rest_found
      <> codegen_bound_coding.find_at_least_n_elts_and_rest_result
      <> codegen_bound_coding.find_at_least_n_elts_and_rest_result_or_failure
      <> codegen_bound_coding.find_at_least_n_elts_and_rest_found
      <> codegen_bound_coding.find_at_least_n_elts_and_rest_found_or_failure
      <> profile_resources,
    valueset_acc,
    available_slice_valuesets,
  )
}
