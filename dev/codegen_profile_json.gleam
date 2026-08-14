import codegen_helpers
import codegen_to_json
import gleam/dict
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string

fn canonical_url(url: String) -> String {
  let assert [url, ..] = string.split(url, "|")
  url
}

fn type_slice_key(root_id: String, fhir_type: String) -> String {
  root_id <> "|" <> fhir_type
}

pub type ExtensionDefinition {
  ExtensionDefinition(name: String, kind: ExtensionKind)
}

pub type ExtensionKind {
  SimpleExtension(codegen_helpers.Element)
  ComplexExtension(List(codegen_helpers.Element))
}

pub fn extension_field_name(element: codegen_helpers.Element) -> String {
  let assert Ok(name) = element.id |> string.split(".") |> list.last
  name
  |> string.replace("[x]", "")
  |> codegen_helpers.escape_field_name
}

pub fn extension_field_to_json_call(
  extension_name: String,
  field: codegen_helpers.Element,
  field_type: String,
  value: String,
) -> String {
  let field_name = extension_field_name(field)
  let assert Ok(extension_url) = field.id |> string.split(".") |> list.last
  let value_json = case field.type_ {
    [type_] ->
      codegen_to_json.string_to_encoder_type(
        type_.code,
        [extension_name, field_name],
        field,
        codegen_helpers.ComplexTypes,
      )
      <> "("
      <> value
      <> ")"
    _ ->
      codegen_helpers.to_snake_case(field_type) <> "_to_json(" <> value <> ")"
  }
  let value_key = case field.type_ {
    [type_] -> {
      let assert [first, ..rest] = type_.code |> string.to_graphemes
      "\"value" <> string.concat([string.uppercase(first), ..rest]) <> "\""
    }
    _ ->
      "\"value\" <> case "
      <> value
      <> " {"
      <> list.fold(field.type_, "", fn(acc, type_) {
        acc
        <> field_type
        <> string.capitalise(type_.code)
        <> "(_) -> \""
        <> {
          let assert [first, ..rest] = type_.code |> string.to_graphemes
          string.concat([string.uppercase(first), ..rest])
        }
        <> "\"\n"
      })
      <> "}"
  }
  "json.object([#(\"url\", json.string(\""
  <> extension_url
  <> "\")), #("
  <> value_key
  <> ", "
  <> value_json
  <> ")])"
}

pub fn profile_extension_definition(
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
pub fn does_profile_restrict_complex_type(
  type_order: List(String),
  field_path: String,
) -> Bool {
  list.contains(type_order, field_path)
}

pub fn profile_base_field_type(
  element: codegen_helpers.Element,
  all_parts: List(String),
  field_path: String,
  choice_type: String,
  extensions: dict.Dict(String, ExtensionDefinition),
  type_order: List(String),
  open_slice_type_names: dict.Dict(String, String),
  slice_type_overrides: dict.Dict(String, SliceFieldType),
  valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
) -> #(String, dict.Dict(String, codegen_helpers.ValuesetItem)) {
  case profile_extension_type(element, extensions, valueset_acc) {
    Some(extension_type) -> extension_type
    None ->
      case dict.get(slice_type_overrides, element.id) {
        Ok(FixedSliceType(slice_type)) -> #(slice_type, valueset_acc)
        Ok(BoundCodeableconceptSlice) ->
          codegen_helpers.string_to_type(
            "CodeableConcept",
            all_parts,
            element,
            codegen_helpers.Resources,
            valueset_acc,
          )
        Error(_) ->
          case does_profile_restrict_complex_type(type_order, field_path) {
            True -> #(
              case
                dict.get(
                  open_slice_type_names,
                  field_path
                    |> string.replace("[x]", "")
                    |> codegen_helpers.to_camel_case,
                )
              {
                Ok(open_name) -> open_name
                Error(_) ->
                  field_path
                  |> string.replace("[x]", "")
                  |> codegen_helpers.to_camel_case
              },
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
                [] -> {
                  let assert [profile_prefix, ..] = all_parts
                  let link_type =
                    codegen_helpers.link_type_from(
                      element.content_reference,
                      profile_prefix,
                    )
                    |> codegen_helpers.to_camel_case
                  #(
                    case dict.get(open_slice_type_names, link_type) {
                      Ok(open_name) -> open_name
                      Error(_) -> link_type
                    },
                    valueset_acc,
                  )
                }
                _ -> #(choice_type, valueset_acc)
              }
          }
      }
  }
}

pub fn profile_field_is_primitive(
  element: codegen_helpers.Element,
  json_field_name: String,
  all_primitive_ext: Bool,
) -> Bool {
  case element.type_ {
    [only_type] ->
      list.contains(
        [
          "base64Binary",
          "boolean",
          "canonical",
          "code",
          "date",
          "dateTime",
          "decimal",
          "id",
          "instant",
          "integer",
          "integer64",
          "markdown",
          "oid",
          "positiveInt",
          "string",
          "time",
          "unsignedInt",
          "uri",
          "url",
          "uuid",
          "xhtml",
          "http://hl7.org/fhirpath/System.String",
        ],
        only_type.code,
      )
      && json_field_name != "id"
      && all_primitive_ext
    _ -> False
  }
}

pub fn profile_field_min(
  element: codegen_helpers.Element,
  is_primitive: Bool,
) -> Int {
  let min = case is_primitive, element.max {
    True, "*" -> 0
    True, _ -> 1
    False, _ -> element.min
  }
  case element.slicing {
    Some(slicing) ->
      case slicing.rules == "open" && !string.contains(element.path, "[x]") {
        True -> 0
        False -> min
      }
    None -> min
  }
}

pub fn aggregate_value_slice_roots(
  group: codegen_helpers.Element,
  fields: List(codegen_helpers.Element),
) -> Option(#(List(codegen_helpers.Element), Int)) {
  let roots =
    list.filter(fields, fn(candidate) {
      candidate.path == group.path && candidate.slice_name != None
    })
  let named_minimum =
    roots |> list.fold(0, fn(total, root) { total + root.min })
  let remaining_minimum = group.min - named_minimum
  case
    group.slicing,
    string.contains(group.path, "[x]"),
    remaining_minimum > 0,
    roots
  {
    Some(codegen_helpers.Slicing(rules: "open", ..)), False, True, [_, ..] ->
      Some(#(roots, remaining_minimum))
    _, _, _, _ -> None
  }
}

pub fn aggregate_slice_constructor(
  choice_type: String,
  slice_name: String,
  payload_type: String,
) -> String {
  let constructor =
    choice_type
    <> {
      slice_name
      |> string.replace("-", "_")
      |> codegen_helpers.to_camel_case
    }
  case constructor == payload_type {
    True -> constructor <> "Slice"
    False -> constructor
  }
}

pub type SlicePlan {
  ValueSlicePlan(overrides: List(#(String, SliceFieldType)))
  TypeSlicePlan(
    root_id: String,
    fhir_type: String,
    slice: codegen_helpers.Element,
    children: List(codegen_helpers.Element),
  )
}

pub type SliceFieldType {
  FixedSliceType(String)
  BoundCodeableconceptSlice
}

pub fn find_element(
  elements: List(codegen_helpers.Element),
  id: String,
) -> Result(codegen_helpers.Element, Nil) {
  list.find(elements, fn(element) { element.id == id })
}

pub fn profile_field_to_json_source(
  element: codegen_helpers.Element,
  field_name: String,
  json_name: String,
  json_suffix: String,
  encoder: String,
  encoder_call: fn(String) -> String,
  card_min: Int,
  is_primitive: Bool,
) -> #(String, String) {
  let key = "\"" <> json_name <> "\"" <> json_suffix
  let always = fn(value) { "#(" <> key <> ", " <> value <> ")," }
  let present = fn(pattern, value) {
    pattern <> " -> [#(" <> key <> ", " <> value <> "), ..fields]"
  }
  let optional = fn(first, second) {
    "\nlet fields = case "
    <> field_name
    <> " {\n  "
    <> first
    <> "\n  "
    <> second
    <> "\n}"
  }
  case is_primitive, element.max, element.base.max, card_min {
    True, _, "*", _ -> #(
      "",
      "\nlet fields = primitives_to_json(fields, "
        <> field_name
        <> ", "
        <> encoder
        <> ", "
        <> key
        <> ")",
    )
    True, _, _, _ -> #(
      "",
      "\nlet fields = primitive_to_json(fields, "
        <> field_name
        <> ", "
        <> encoder
        <> ", "
        <> key
        <> ")",
    )
    False, "*", _, 0 -> #(
      "",
      optional(
        "[] -> fields",
        present("values", "json.array(values, " <> encoder <> ")"),
      ),
    )
    False, "*", _, 1 -> #(
      always("list1_to_json(" <> field_name <> ", " <> encoder <> ")"),
      "",
    )
    False, "*", _, 2 -> #(
      always("ct.list2_to_json(" <> field_name <> ", " <> encoder <> ")"),
      "",
    )
    False, "*", _, 3 -> #(
      always("ct.list3_to_json(" <> field_name <> ", " <> encoder <> ")"),
      "",
    )
    False, "1", "1", 0 -> #(
      "",
      optional(present("Some(v)", encoder_call("v")), "None -> fields"),
    )
    False, "1", "1", 1 -> #(always(encoder_call(field_name)), "")
    False, "1", _, 0 -> #(
      "",
      optional(
        present("Some(v)", "json.array([v], " <> encoder <> ")"),
        "None -> fields",
      ),
    )
    False, "1", _, 1 -> #(
      always("json.array([" <> field_name <> "], " <> encoder <> ")"),
      "",
    )
    False, _, "*", 0 -> #(
      "",
      optional(
        "[] -> fields",
        present("values", "json.array(values, " <> encoder <> ")"),
      ),
    )
    _, _, _, _ ->
      panic as {
        "unsupported profile JSON cardinality "
        <> element.id
        <> " "
        <> int.to_string(card_min)
        <> ".."
        <> element.max
        <> " base max "
        <> element.base.max
      }
  }
}

fn fixed_slice_encoder_call(
  slice_type: String,
  element: codegen_helpers.Element,
  snapshot_elements: List(codegen_helpers.Element),
  value: String,
) -> String {
  case slice_type {
    "ct.CodingDiscriminator" -> {
      let #(system, code) = case element.pattern_coding {
        Some(codegen_helpers.DiscriminatorCodingValue(
          system: Some(system),
          code: Some(code),
        )) -> #(system, code)
        _ -> {
          let assert Ok(system_element) =
            find_element(snapshot_elements, element.id <> ".system")
          let assert Ok(code_element) =
            find_element(snapshot_elements, element.id <> ".code")
          let assert Some(system) = system_element.fixed_uri
          let assert Some(code) = code_element.fixed_code
          #(system, code)
        }
      }
      "ct.coding_discriminator_to_json("
      <> value
      <> ", \""
      <> system
      <> "\", \""
      <> code
      <> "\")"
    }
    "ct.CodeableconceptDiscriminator" -> {
      let assert Some(pattern) = element.pattern_codeableconcept
      let assert [
        codegen_helpers.DiscriminatorCodingValue(
          system: Some(system),
          code: Some(code),
        ),
      ] = pattern.coding
      "ct.codeableconcept_discriminator_to_json("
      <> value
      <> ", \""
      <> system
      <> "\", \""
      <> code
      <> "\")"
    }
    "ct.IdentifierDiscriminatorSystem"
    | "ct.IdentifierDiscriminatorSystemRequiredValue" -> {
      let assert Some(codegen_helpers.DiscriminatorIdentifierValue(
        system: Some(system),
        ..,
      )) = element.pattern_identifier
      let function_name = case slice_type {
        "ct.IdentifierDiscriminatorSystem" ->
          "ct.identifier_discriminator_system_to_json"
        _ -> "ct.identifier_discriminator_system_required_value_to_json"
      }
      function_name <> "(" <> value <> ", \"" <> system <> "\")"
    }
    "ct.IdentifierDiscriminatorType" -> {
      let assert Ok(type_element) =
        find_element(snapshot_elements, element.id <> ".type")
      let assert Some(pattern) = type_element.pattern_codeableconcept
      let assert [
        codegen_helpers.DiscriminatorCodingValue(
          system: Some(system),
          code: Some(code),
        ),
      ] = pattern.coding
      "ct.identifier_discriminator_type_to_json("
      <> value
      <> ", \""
      <> system
      <> "\", \""
      <> code
      <> "\")"
    }
    _ -> panic as "unknown fixed slice type"
  }
}

pub fn profile_element_encoder_type(
  element: codegen_helpers.Element,
  base_field_type: String,
  all_parts: List(String),
  field_path: String,
  type_order: List(String),
  slice_type_overrides: dict.Dict(String, SliceFieldType),
  snapshot_elements: List(codegen_helpers.Element),
) -> String {
  case dict.get(slice_type_overrides, element.id) {
    Ok(FixedSliceType(slice_type)) ->
      "fn(value) { "
      <> fixed_slice_encoder_call(
        slice_type,
        element,
        snapshot_elements,
        "value",
      )
      <> " }"
    _ ->
      case
        does_profile_restrict_complex_type(type_order, field_path),
        element.type_
      {
        False, [only_type] ->
          codegen_to_json.string_to_encoder_type(
            only_type.code,
            all_parts,
            element,
            codegen_helpers.Resources,
          )
        _, _ -> codegen_helpers.to_snake_case(base_field_type) <> "_to_json"
      }
  }
}

pub fn profile_element_encoder_call(
  element: codegen_helpers.Element,
  base_field_type: String,
  all_parts: List(String),
  field_path: String,
  type_order: List(String),
  slice_type_overrides: dict.Dict(String, SliceFieldType),
  snapshot_elements: List(codegen_helpers.Element),
  value: String,
) -> String {
  case dict.get(slice_type_overrides, element.id) {
    Ok(FixedSliceType(slice_type)) ->
      fixed_slice_encoder_call(slice_type, element, snapshot_elements, value)
    _ ->
      case
        does_profile_restrict_complex_type(type_order, field_path),
        element.type_
      {
        False, [only_type] ->
          codegen_to_json.string_to_encoder_call(
            only_type.code,
            all_parts,
            element,
            codegen_helpers.Resources,
            value,
          )
        _, _ ->
          profile_element_encoder_type(
            element,
            base_field_type,
            all_parts,
            field_path,
            type_order,
            slice_type_overrides,
            snapshot_elements,
          )
          <> "("
          <> value
          <> ")"
      }
  }
}

pub fn profile_extension_encoder_call(
  element: codegen_helpers.Element,
  extension: ExtensionDefinition,
  value: String,
) -> String {
  let assert [codegen_helpers.Type(profile: [url, ..], ..), ..] = element.type_
  case extension.kind {
    SimpleExtension(extension_value) -> {
      let assert [value_type] = extension_value.type_
      let assert [first, ..rest] = value_type.code |> string.to_graphemes
      let suffix = string.concat([string.uppercase(first), ..rest])
      "json.object([#(\"url\", json.string(\""
      <> canonical_url(url)
      <> "\")), #(\"value"
      <> suffix
      <> "\", "
      <> codegen_to_json.string_to_encoder_type(
        value_type.code,
        ["Extension", "value"],
        extension_value,
        codegen_helpers.Resources,
      )
      <> "("
      <> value
      <> "))])"
    }
    ComplexExtension(_) ->
      "ct."
      <> codegen_helpers.to_snake_case(extension.name)
      <> "_to_json("
      <> value
      <> ", \""
      <> canonical_url(url)
      <> "\")"
  }
}

pub fn sliced_type_to_json_source(
  sliced_name: String,
  children: List(codegen_helpers.Element),
) -> String {
  let #(encoder_args, always, optional) =
    children
    |> list.filter(fn(child) { child.max != "0" })
    |> list.fold(#("", "", ""), fn(acc, child) {
      let #(encoder_args, always, optional) = acc
      let assert Ok(json_name) = child.path |> string.split(".") |> list.last
      case child.fixed_code, child.fixed_uri {
        Some(value), _ | _, Some(value) -> #(
          encoder_args,
          always
            <> "#(\""
            <> json_name
            <> "\", json.string(\""
            <> value
            <> "\")),",
          optional,
        )
        None, None -> {
          let assert [child_type] = child.type_
          let field_name =
            json_name
            |> codegen_helpers.escape_field_name
            |> codegen_helpers.to_snake_case
          let encoder =
            codegen_to_json.string_to_encoder_type(
              child_type.code,
              [sliced_name, field_name],
              child,
              codegen_helpers.Resources,
            )
          let encoder_call = fn(value) {
            codegen_to_json.string_to_encoder_call(
              child_type.code,
              [sliced_name, field_name],
              child,
              codegen_helpers.Resources,
              value,
            )
          }
          let #(new_always, new_optional) =
            profile_field_to_json_source(
              child,
              field_name,
              json_name,
              "",
              encoder,
              encoder_call,
              child.min,
              False,
            )
          #(
            encoder_args <> field_name <> ":,",
            always <> new_always,
            optional <> new_optional,
          )
        }
      }
    })
  codegen_helpers.gen_res_encoder(
    "",
    sliced_name,
    codegen_helpers.to_snake_case(sliced_name),
    encoder_args,
    always,
    optional,
    False,
  )
}

pub fn generate_to_json(
  resource_type: String,
  snapshot_elements: List(codegen_helpers.Element),
  profile_prefix: String,
  profile_type: String,
  type_order: List(String),
  type_fields: dict.Dict(String, List(codegen_helpers.Element)),
  extensions: dict.Dict(String, ExtensionDefinition),
  open_slice_type_names: dict.Dict(String, String),
  slice_type_overrides: dict.Dict(String, SliceFieldType),
  type_slice_overrides: dict.Dict(String, SlicePlan),
  all_primitive_ext: Bool,
  valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
) -> #(String, dict.Dict(String, codegen_helpers.ValuesetItem)) {
  list.fold(
    over: type_order,
    from: #("", valueset_acc),
    with: fn(acc, current_type) {
      let #(encoders_acc, valueset_acc) = acc
      let gleam_type = case current_type == profile_prefix {
        True -> profile_type
        False ->
          current_type
          |> string.replace("[x]", "")
          |> codegen_helpers.to_camel_case
      }
      let gleam_type = case dict.get(open_slice_type_names, gleam_type) {
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
          list.filter(roots, fn(root) { root.min == 0 })
        })
      let fields =
        list.filter(fields, fn(element) {
          element.max != "0"
          && !list.any(aggregate_slice_root_ids, fn(root) {
            root.id == element.id
          })
          && case element.slicing {
            Some(slicing) ->
              slicing.rules != "closed"
              || string.contains(element.path, "[x]")
              || dict.has_key(aggregate_slice_groups, element.id)
            None -> True
          }
        })
      let #(
        encoder_args,
        json_always,
        json_optional,
        choice_encoders,
        valueset_acc,
      ) =
        list.fold(fields, #("", "", "", "", valueset_acc), fn(acc, element) {
          let #(
            encoder_args,
            json_always,
            json_optional,
            choice_encoders,
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
          let json_field_name =
            element.path
            |> string.split(".")
            |> list.last
            |> result.unwrap(last_part)
            |> string.replace("[x]", "")
          let json_field_name = case
            string.ends_with(element.path, "[x]"),
            element.type_
          {
            True, [only_type] -> {
              let assert [first, ..rest] = only_type.code |> string.to_graphemes
              json_field_name
              <> string.concat([string.uppercase(first), ..rest])
            }
            _, _ -> json_field_name
          }
          let safe_field_name =
            last_part
            |> string.replace("[x]", "")
            |> codegen_helpers.escape_field_name
          let field_name = codegen_helpers.to_snake_case(safe_field_name)
          let choice_type = gleam_type <> string.capitalise(safe_field_name)
          let #(open_field_type, valueset_acc) =
            profile_base_field_type(
              element,
              all_parts,
              field_path,
              choice_type,
              extensions,
              type_order,
              open_slice_type_names,
              slice_type_overrides,
              valueset_acc,
            )
          let #(base_field_type, aggregate_encoder, valueset_acc) = case
            dict.get(aggregate_slice_groups, element.id)
          {
            Error(_) -> #(open_field_type, "", valueset_acc)
            Ok(#(roots, _)) -> {
              let #(cases, valueset_acc) =
                list.fold(roots, #("", valueset_acc), fn(acc, root) {
                  let #(cases, valueset_acc) = acc
                  let assert Some(slice_name) = root.slice_name
                  let root_parts =
                    root.id
                    |> string.replace("-", "")
                    |> string.replace(":", ".")
                    |> string.split(".")
                  let assert [_, ..root_rest] = root_parts
                  let root_parts = [profile_prefix, ..root_rest]
                  let root_field_path = string.join(root_parts, "_")
                  let root_type_name =
                    root_field_path |> codegen_helpers.to_camel_case
                  let #(root_type, valueset_acc) =
                    profile_base_field_type(
                      root,
                      root_parts,
                      root_field_path,
                      root_type_name,
                      extensions,
                      type_order,
                      open_slice_type_names,
                      slice_type_overrides,
                      valueset_acc,
                    )
                  let call =
                    profile_element_encoder_call(
                      root,
                      root_type,
                      root_parts,
                      root_field_path,
                      type_order,
                      slice_type_overrides,
                      snapshot_elements,
                      "value",
                    )
                  #(
                    cases
                      <> "    "
                      <> aggregate_slice_constructor(
                      choice_type,
                      slice_name,
                      root_type,
                    )
                      <> "(value) -> "
                      <> call
                      <> "\n",
                    valueset_acc,
                  )
                })
              let open_call =
                profile_element_encoder_call(
                  element,
                  open_field_type,
                  all_parts,
                  field_path,
                  type_order,
                  slice_type_overrides,
                  snapshot_elements,
                  "value",
                )
              let cases =
                cases
                <> "    "
                <> aggregate_slice_constructor(
                  choice_type,
                  "Open",
                  open_field_type,
                )
                <> "(value) -> "
                <> open_call
                <> "\n"
              #(
                choice_type,
                "pub fn "
                  <> codegen_helpers.to_snake_case(choice_type)
                  <> "_to_json(value: "
                  <> choice_type
                  <> ") -> Json {\n  case value {\n"
                  <> cases
                  <> "  }\n}\n\n",
                valueset_acc,
              )
            }
          }
          let is_primitive =
            profile_field_is_primitive(
              element,
              json_field_name,
              all_primitive_ext,
            )
          let card_min = case dict.has_key(aggregate_slice_groups, element.id) {
            True -> {
              let assert Ok(#(_, remaining_minimum)) =
                dict.get(aggregate_slice_groups, element.id)
              remaining_minimum
            }
            False -> profile_field_min(element, is_primitive)
          }
          let encoder_args = encoder_args <> field_name <> ":,"
          let slice_roots =
            list.filter(fields, fn(candidate) {
              candidate.path == element.path && candidate.slice_name != None
            })
          let is_choice_path = string.contains(element.path, "[x]")

          case element.slice_name, slice_roots {
            Some(_), _ -> #(
              encoder_args,
              json_always,
              json_optional,
              choice_encoders,
              valueset_acc,
            )
            None, [_, ..] if !is_choice_path -> {
              let open_encoder = case aggregate_encoder {
                "" ->
                  profile_element_encoder_type(
                    element,
                    base_field_type,
                    all_parts,
                    field_path,
                    type_order,
                    slice_type_overrides,
                    snapshot_elements,
                  )
                _ -> codegen_helpers.to_snake_case(choice_type) <> "_to_json"
              }
              let #(single_values, list_values) =
                list.fold(slice_roots, #([], []), fn(values, root) {
                  let #(single_values, list_values) = values
                  let root_parts =
                    root.id
                    |> string.replace("-", "")
                    |> string.replace(":", ".")
                    |> string.split(".")
                  let assert [_, ..root_rest] = root_parts
                  let root_parts = [profile_prefix, ..root_rest]
                  let assert Ok(root_last) = root_parts |> list.last
                  let root_field_name =
                    root_last
                    |> codegen_helpers.escape_field_name
                    |> codegen_helpers.to_snake_case
                  let root_field_path = string.join(root_parts, "_")
                  let root_type_name =
                    root_field_path |> codegen_helpers.to_camel_case
                  let #(root_type, _) =
                    profile_base_field_type(
                      root,
                      root_parts,
                      root_field_path,
                      root_type_name,
                      extensions,
                      type_order,
                      open_slice_type_names,
                      slice_type_overrides,
                      valueset_acc,
                    )
                  let root_call = fn(value) {
                    case profile_extension_definition(root, extensions) {
                      Some(extension) ->
                        profile_extension_encoder_call(root, extension, value)
                      None ->
                        profile_element_encoder_call(
                          root,
                          root_type,
                          root_parts,
                          root_field_path,
                          type_order,
                          slice_type_overrides,
                          snapshot_elements,
                          value,
                        )
                    }
                  }
                  let #(value, is_single) = case root.min, root.max {
                    0, "1" -> #(
                      "case "
                        <> root_field_name
                        <> " { Some(value) -> ["
                        <> root_call("value")
                        <> "] None -> [] }",
                      False,
                    )
                    1, "1" -> #(root_call(root_field_name), True)
                    1, "*" -> #(
                      "fn(values) { let ct.List1(first, rest) = values ["
                        <> root_call("first")
                        <> ", ..list.map(rest, fn(value) { "
                        <> root_call("value")
                        <> " })] }("
                        <> root_field_name
                        <> ")",
                      False,
                    )
                    2, "*" -> #(
                      "fn(values) { let ct.List2(first, second, rest) = values ["
                        <> root_call("first")
                        <> ", "
                        <> root_call("second")
                        <> ", ..list.map(rest, fn(value) { "
                        <> root_call("value")
                        <> " })] }("
                        <> root_field_name
                        <> ")",
                      False,
                    )
                    3, "*" -> #(
                      "fn(values) { let ct.List3(first, second, third, rest) = values ["
                        <> root_call("first")
                        <> ", "
                        <> root_call("second")
                        <> ", "
                        <> root_call("third")
                        <> ", ..list.map(rest, fn(value) { "
                        <> root_call("value")
                        <> " })] }("
                        <> root_field_name
                        <> ")",
                      False,
                    )
                    0, _ -> #(
                      "list.map("
                        <> root_field_name
                        <> ", fn(value) { "
                        <> root_call("value")
                        <> " })",
                      False,
                    )
                    _, _ -> panic as "unsupported named slice cardinality"
                  }
                  case is_single {
                    True -> #([value, ..single_values], list_values)
                    False -> #(single_values, [value, ..list_values])
                  }
                })
              let open_values = case element.max, card_min {
                "*", 0 ->
                  "list.map(" <> field_name <> ", " <> open_encoder <> ")"
                "*", 1 ->
                  "fn(values) { let ct.List1(first, rest) = values ["
                  <> open_encoder
                  <> "(first), ..list.map(rest, "
                  <> open_encoder
                  <> ")] }("
                  <> field_name
                  <> ")"
                "*", 2 ->
                  "fn(values) { let ct.List2(first, second, rest) = values ["
                  <> open_encoder
                  <> "(first), "
                  <> open_encoder
                  <> "(second), ..list.map(rest, "
                  <> open_encoder
                  <> ")] }("
                  <> field_name
                  <> ")"
                "*", 3 ->
                  "fn(values) { let ct.List3(first, second, third, rest) = values ["
                  <> open_encoder
                  <> "(first), "
                  <> open_encoder
                  <> "(second), "
                  <> open_encoder
                  <> "(third), ..list.map(rest, "
                  <> open_encoder
                  <> ")] }("
                  <> field_name
                  <> ")"
                "1", 0 ->
                  "case "
                  <> field_name
                  <> " { Some(value) -> ["
                  <> profile_element_encoder_call(
                    element,
                    base_field_type,
                    all_parts,
                    field_path,
                    type_order,
                    slice_type_overrides,
                    snapshot_elements,
                    "value",
                  )
                  <> "] None -> [] }"
                _, _ -> panic as "unsupported open slice cardinality"
              }
              let single_values = list.reverse(single_values)
              let list_values = list.reverse([open_values, ..list_values])
              let slice_values = case single_values, list_values {
                [], [only] -> only
                [], lists -> "list.flatten([" <> string.join(lists, ",") <> "])"
                singles, [only] ->
                  "[" <> string.join(singles, ",") <> ", .." <> only <> "]"
                singles, lists ->
                  "["
                  <> string.join(singles, ",")
                  <> ", ..list.flatten(["
                  <> string.join(lists, ",")
                  <> "])]"
              }
              let optional =
                json_optional
                <> "\nlet slice_values = "
                <> slice_values
                <> "\nlet fields = case slice_values {\n  [] -> fields\n  values -> [#(\""
                <> json_field_name
                <> "\", json.preprocessed_array(values)), ..fields]\n}"
              #(
                encoder_args,
                json_always,
                optional,
                aggregate_encoder <> choice_encoders,
                valueset_acc,
              )
            }
            None, _ -> {
              let encoder = case aggregate_encoder {
                "" ->
                  profile_element_encoder_type(
                    element,
                    base_field_type,
                    all_parts,
                    field_path,
                    type_order,
                    slice_type_overrides,
                    snapshot_elements,
                  )
                _ -> codegen_helpers.to_snake_case(choice_type) <> "_to_json"
              }
              let encoder_call = fn(value) {
                case aggregate_encoder {
                  "" ->
                    profile_element_encoder_call(
                      element,
                      base_field_type,
                      all_parts,
                      field_path,
                      type_order,
                      slice_type_overrides,
                      snapshot_elements,
                      value,
                    )
                  _ ->
                    codegen_helpers.to_snake_case(choice_type)
                    <> "_to_json("
                    <> value
                    <> ")"
                }
              }
              let suffix =
                codegen_helpers.gen_choicetype_suffixes(
                  case card_min {
                    0 -> "v"
                    _ -> field_name
                  },
                  element.type_,
                  choice_type,
                )
              let #(new_always, new_optional) =
                profile_field_to_json_source(
                  element,
                  field_name,
                  json_field_name,
                  suffix,
                  encoder,
                  encoder_call,
                  card_min,
                  is_primitive,
                )
              let new_choice_encoders = case element.type_ {
                [] | [_] -> ""
                choice_types -> {
                  let cases =
                    list.fold(choice_types, "", fn(cases, choice) {
                      let constructor =
                        choice_type <> string.capitalise(choice.code)
                      let call = case
                        dict.get(
                          type_slice_overrides,
                          type_slice_key(element.id, choice.code),
                        )
                      {
                        Ok(TypeSlicePlan(slice:, children: [], ..)) ->
                          codegen_to_json.string_to_encoder_call(
                            choice.code,
                            all_parts,
                            slice,
                            codegen_helpers.Resources,
                            "value",
                          )
                        Ok(TypeSlicePlan(children: _, ..)) -> {
                          let sliced_name =
                            choice_type
                            <> string.capitalise(choice.code)
                            <> "Sliced"
                          codegen_helpers.to_snake_case(sliced_name)
                          <> "_to_json(value)"
                        }
                        _ ->
                          codegen_to_json.string_to_encoder_call(
                            choice.code,
                            [
                              "somehow this is used in [x] for any type (int, bool, code, etc) and ofc that code has no defined binding",
                            ],
                            element,
                            codegen_helpers.Resources,
                            "value",
                          )
                      }
                      cases
                      <> "    "
                      <> constructor
                      <> "(value) -> "
                      <> call
                      <> "\n"
                    })
                  let sliced_encoders =
                    list.fold(choice_types, "", fn(source, choice) {
                      case
                        dict.get(
                          type_slice_overrides,
                          type_slice_key(element.id, choice.code),
                        )
                      {
                        Ok(TypeSlicePlan(children: [_, ..] as children, ..)) -> {
                          let sliced_name =
                            choice_type
                            <> string.capitalise(choice.code)
                            <> "Sliced"
                          source
                          <> sliced_type_to_json_source(sliced_name, children)
                        }
                        _ -> source
                      }
                    })
                  "pub fn "
                  <> codegen_helpers.to_snake_case(choice_type)
                  <> "_to_json(value: "
                  <> choice_type
                  <> ") -> Json {\n  case value {\n"
                  <> cases
                  <> "  }\n}\n\n"
                  <> sliced_encoders
                }
              }
              #(
                encoder_args,
                json_always <> new_always,
                json_optional <> new_optional,
                aggregate_encoder <> new_choice_encoders <> choice_encoders,
                valueset_acc,
              )
            }
          }
        })
      let encoder =
        codegen_helpers.gen_res_encoder(
          resource_type,
          gleam_type,
          codegen_helpers.to_snake_case(gleam_type),
          encoder_args,
          json_always,
          json_optional,
          current_type == profile_prefix,
        )
      #(encoder <> choice_encoders <> encoders_acc, valueset_acc)
    },
  )
}
