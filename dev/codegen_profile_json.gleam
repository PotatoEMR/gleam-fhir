import codegen_decode
import codegen_helpers
import codegen_slice_complex_type
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
  slice_base_type_names: dict.Dict(String, String),
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
                  slice_base_type_names,
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
                    case dict.get(slice_base_type_names, link_type) {
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

pub fn aggregate_slice_type_name(
  choice_type: String,
  base_field_type: String,
) -> String {
  case choice_type == base_field_type {
    True -> choice_type <> "Component"
    False -> choice_type
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
      let #(system, code) = case element.pattern_codeableconcept {
        Some(codegen_helpers.DiscriminatorCodeableconceptValue(coding: [
          codegen_helpers.DiscriminatorCodingValue(
            system: Some(system),
            code: Some(code),
          ),
        ])) -> #(system, code)
        _ -> {
          let assert Ok(system_element) =
            find_element(snapshot_elements, element.id <> ".coding.system")
          let assert Ok(code_element) =
            find_element(snapshot_elements, element.id <> ".coding.code")
          let assert Some(system) = system_element.fixed_uri
          let assert Some(code) = code_element.fixed_code
          #(system, code)
        }
      }
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

type DecodeContext {
  DecodeContext(
    resource_type: String,
    profile_prefix: String,
    snapshot_elements: List(codegen_helpers.Element),
    type_order: List(String),
    type_fields: dict.Dict(String, List(codegen_helpers.Element)),
    extensions: dict.Dict(String, ExtensionDefinition),
    slice_base_type_names: dict.Dict(String, String),
    slice_type_overrides: dict.Dict(String, SliceFieldType),
    type_slice_overrides: dict.Dict(String, SlicePlan),
    all_primitive_ext: Bool,
    valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
    base_elements: dict.Dict(String, codegen_helpers.Element),
  )
}

type ConversionExpression {
  ConversionExpression(expression: String, helpers: String, fallible: Bool)
  IdentityConversion(expression: String, helpers: String, fallible: Bool)
}

fn profile_json_field_name(
  element: codegen_helpers.Element,
  fallback: String,
) -> String {
  let name =
    element.path
    |> string.split(".")
    |> list.last
    |> result.unwrap(fallback)
    |> string.replace("[x]", "")
  case string.ends_with(element.path, "[x]"), element.type_ {
    True, [only_type] -> {
      let assert [first, ..rest] = only_type.code |> string.to_graphemes
      name <> string.concat([string.uppercase(first), ..rest])
    }
    _, _ -> name
  }
}

fn conversion_is_identity(expression: ConversionExpression) -> Bool {
  case expression {
    IdentityConversion(..) -> True
    ConversionExpression(..) -> False
  }
}

type SliceMatch {
  SliceMatch(
    expression: String,
    matcher: Option(String),
    returns_found: Bool,
    target_type: String,
    constructor: String,
  )
}

type SliceGroupDecode {
  SliceGroupDecode(
    source: String,
    result_name: String,
    success_pattern: String,
    placeholder_fields: List(#(String, String)),
  )
}

type ResourceSliceMatch {
  ResourceSliceMatch(
    expression: String,
    returns_found: Bool,
    selected: String,
    fallible: Bool,
  )
}

fn slice_group_type_name(
  parent_type: String,
  group: codegen_helpers.Element,
) -> String {
  let assert Ok(name) = group.path |> string.split(".") |> list.last
  parent_type
  <> {
    name
    |> string.replace("[x]", "")
    |> codegen_helpers.escape_field_name
    |> string.capitalise
  }
}

fn slice_name_type_part(root: codegen_helpers.Element) -> String {
  let assert Some(slice_name) = root.slice_name
  slice_name
  |> string.replace("-", "_")
  |> codegen_helpers.to_camel_case
}

fn direct_slice_roots(
  group: codegen_helpers.Element,
  elements: List(codegen_helpers.Element),
) -> List(codegen_helpers.Element) {
  let prefix = group.id <> ":"
  list.filter(elements, fn(element) {
    element.path == group.path
    && element.slice_name != None
    && string.starts_with(element.id, prefix)
    && !string.contains(
      string.drop_start(element.id, string.length(prefix)),
      ".",
    )
  })
}

fn profile_element_names(
  context: DecodeContext,
  parent_type: String,
  element: codegen_helpers.Element,
) -> #(List(String), String, String, String, String) {
  let parts =
    element.id
    |> string.replace("-", "")
    |> string.replace(":", ".")
    |> string.split(".")
  let assert [_, ..rest] = parts
  let parts = [context.profile_prefix, ..rest]
  let assert Ok(last) = parts |> list.last
  let json_name = profile_json_field_name(element, last)
  let field_name =
    last
    |> string.replace("[x]", "")
    |> codegen_helpers.escape_field_name
    |> codegen_helpers.to_snake_case
  let field_path = string.join(parts, "_")
  let #(field_type, _) =
    profile_base_field_type(
      element,
      parts,
      field_path,
      parent_type <> string.capitalise(field_name),
      context.extensions,
      context.type_order,
      context.slice_base_type_names,
      context.slice_type_overrides,
      context.valueset_acc,
    )
  #(
    parts,
    field_path,
    json_name,
    field_name,
    string.replace(field_type, "_", ""),
  )
}

fn profile_type_name(
  context: DecodeContext,
  current_type: String,
  profile_type: String,
) -> String {
  let type_ = case current_type == context.profile_prefix {
    True -> profile_type
    False ->
      current_type
      |> string.replace("[x]", "")
      |> codegen_helpers.to_camel_case
  }
  case dict.get(context.slice_base_type_names, type_) {
    Ok(open_name) -> open_name
    Error(_) -> type_
  }
}

fn fields_for_profile_type(
  context: DecodeContext,
  target_type: String,
  profile_type: String,
) -> Result(List(codegen_helpers.Element), Nil) {
  let target_type = target_type |> string.replace("_", "") |> string.lowercase
  context.type_order
  |> list.find_map(fn(current_type) {
    let current_profile_type =
      profile_type_name(context, current_type, profile_type)
      |> string.replace("_", "")
      |> string.lowercase
    case current_profile_type == target_type {
      True -> dict.get(context.type_fields, current_type)
      False -> Error(Nil)
    }
  })
}

fn base_record_type(
  fields: List(codegen_helpers.Element),
) -> Result(String, Nil) {
  use first <- result.try(list.first(fields))
  let parts = first.base.path |> string.split(".")
  let parent = parts |> list.reverse |> list.drop(1) |> list.reverse
  case parent {
    [] -> Error(Nil)
    _ ->
      parent
      |> list.map(string.capitalise)
      |> string.concat
      |> Ok
  }
}

fn base_payload_type(
  element: codegen_helpers.Element,
  fhir_type: String,
) -> String {
  case fhir_type {
    "BackboneElement" | "Element" ->
      element.base.path
      |> string.split(".")
      |> list.map(string.capitalise)
      |> string.concat
    "base64Binary"
    | "canonical"
    | "code"
    | "id"
    | "integer64"
    | "markdown"
    | "oid"
    | "string"
    | "uri"
    | "url"
    | "uuid"
    | "xhtml"
    | "http://hl7.org/fhirpath/System.String" -> "String"
    "boolean" -> "Bool"
    "decimal" -> "Float"
    "integer" | "positiveInt" | "unsignedInt" -> "Int"
    "date" -> "Date"
    "dateTime" -> "DateTime"
    "instant" -> "Instant"
    "time" -> "Time"
    _ -> "ct." <> codegen_helpers.to_camel_case(fhir_type)
  }
}

fn discriminator_literals(
  context: DecodeContext,
  element: codegen_helpers.Element,
) -> Result(#(String, String), Nil) {
  case
    element.pattern_coding,
    element.pattern_codeableconcept,
    element.pattern_identifier
  {
    Some(codegen_helpers.DiscriminatorCodingValue(
      system: Some(system),
      code: Some(code),
    )),
      _,
      _
    -> Ok(#(system, code))
    _,
      Some(codegen_helpers.DiscriminatorCodeableconceptValue(coding: [
        codegen_helpers.DiscriminatorCodingValue(
          system: Some(system),
          code: Some(code),
        ),
      ])),
      _
    -> Ok(#(system, code))
    _,
      _,
      Some(codegen_helpers.DiscriminatorIdentifierValue(
        system: Some(system),
        ..,
      ))
    -> Ok(#(system, ""))
    _, _, _ -> {
      let descendants = context.snapshot_elements
      let system =
        descendants
        |> list.find(fn(child) { child.id == element.id <> ".system" })
        |> result.try(fn(child) { option.to_result(child.fixed_uri, Nil) })
      let code =
        descendants
        |> list.find(fn(child) { child.id == element.id <> ".code" })
        |> result.try(fn(child) { option.to_result(child.fixed_code, Nil) })
      case system, code {
        Ok(system), Ok(code) -> Ok(#(system, code))
        _, _ -> {
          let coding_system =
            descendants
            |> list.find(fn(child) {
              child.id == element.id <> ".coding.system"
            })
            |> result.try(fn(child) { option.to_result(child.fixed_uri, Nil) })
          let coding_code =
            descendants
            |> list.find(fn(child) { child.id == element.id <> ".coding.code" })
            |> result.try(fn(child) { option.to_result(child.fixed_code, Nil) })
          case coding_system, coding_code {
            Ok(system), Ok(code) -> Ok(#(system, code))
            _, _ -> {
              let type_element =
                descendants
                |> list.find(fn(child) { child.id == element.id <> ".type" })
              case type_element {
                Ok(type_element) ->
                  discriminator_literals(context, type_element)
                Error(_) -> {
                  case element.pattern_identifier {
                    Some(codegen_helpers.DiscriminatorIdentifierValue(
                      system: Some(system),
                      ..,
                    )) -> Ok(#(system, ""))
                    _ ->
                      panic as {
                        "missing discriminator literals for " <> element.id
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
}

fn bound_codeableconcept_conversion(
  element: codegen_helpers.Element,
  value: String,
) -> String {
  let assert Some(codegen_helpers.Binding(value_set: Some(value_set), ..)) =
    element.binding
  let valueset =
    value_set
    |> canonical_url
    |> codegen_helpers.concept_name_from_url
    |> codegen_helpers.to_snake_case
  "ct.bound_codeableconcept_from_codeableconcept("
  <> value
  <> ", valuesets."
  <> valueset
  <> "_from_code_and_system) |> result.replace_error(\"required ValueSet\")"
}

fn discriminator_conversion(
  context: DecodeContext,
  element: codegen_helpers.Element,
  discriminator_type: String,
  value: String,
) -> Result(#(ConversionExpression, Bool), Nil) {
  let assert Ok(#(system, code)) = discriminator_literals(context, element)
  use call <- result.try(
    codegen_slice_complex_type.discriminator_from_base_call(
      discriminator_type,
      value,
      system,
      code,
    ),
  )
  case call {
    codegen_slice_complex_type.ResultDiscriminatorCall(call) ->
      Ok(#(
        ConversionExpression(
          call <> " |> result.replace_error(\"discriminator\")",
          "",
          True,
        ),
        False,
      ))
    codegen_slice_complex_type.FoundDiscriminatorCall(call) ->
      Ok(#(
        ConversionExpression(
          "case "
            <> call
            <> " { ct.FoundValid(value) -> Ok(value) ct.FoundInvalid(reason) -> Error(reason) ct.NotFound -> Error(\"discriminator\") }",
          "",
          True,
        ),
        True,
      ))
  }
}

fn conversion_map(
  expression: ConversionExpression,
  wrap: fn(String) -> String,
) {
  case expression.fallible {
    True ->
      ConversionExpression(
        "result.map("
          <> expression.expression
          <> ", fn(value) { "
          <> wrap("value")
          <> " })",
        expression.helpers,
        True,
      )
    False ->
      ConversionExpression(
        wrap(expression.expression),
        expression.helpers,
        False,
      )
  }
}

fn conversion_for_cardinality(
  expression: ConversionExpression,
  element: codegen_helpers.Element,
  source: String,
  target_min: Int,
  is_primitive: Bool,
) -> ConversionExpression {
  case is_primitive {
    True -> IdentityConversion(source, expression.helpers, False)
    False -> {
      let identity = conversion_is_identity(expression)
      let source_is_list = element.base.max != "1"
      let target_is_list = element.max != "1"
      let source = case source_is_list, element.base.min {
        True, 1 ->
          "{ let ct.List1(first:, rest:) = " <> source <> " [first, ..rest] }"
        True, 2 ->
          "{ let ct.List2(first:, second:, rest:) = "
          <> source
          <> " [first, second, ..rest] }"
        True, 3 ->
          "{ let ct.List3(first:, second:, third:, rest:) = "
          <> source
          <> " [first, second, third, ..rest] }"
        _, _ -> source
      }
      case source_is_list, target_is_list, element.base.min, target_min {
        True, True, _, 0 if identity ->
          IdentityConversion(source, expression.helpers, False)
        True, True, _, 0 ->
          case expression.fallible {
            True ->
              ConversionExpression(
                "list.try_map("
                  <> source
                  <> ", fn(value) { "
                  <> expression.expression
                  <> " })",
                expression.helpers,
                True,
              )
            False ->
              ConversionExpression(
                "list.map("
                  <> source
                  <> ", fn(value) { "
                  <> expression.expression
                  <> " })",
                expression.helpers,
                False,
              )
          }
        True, True, _, minimum -> {
          let list_expression = case identity, expression.fallible {
            True, _ -> "let values = " <> source <> "\n"
            False, True ->
              "use values <- result.try(list.try_map("
              <> source
              <> ", fn(value) { "
              <> expression.expression
              <> " }))\n"
            False, False ->
              "let values = list.map("
              <> source
              <> ", fn(value) { "
              <> expression.expression
              <> " })\n"
          }
          let constructor = case minimum {
            1 ->
              "case values { [first, ..rest] -> Ok(ct.List1(first:, rest:)) _ -> Error(\"minimum cardinality 1\") }"
            2 ->
              "case values { [first, second, ..rest] -> Ok(ct.List2(first:, second:, rest:)) _ -> Error(\"minimum cardinality 2\") }"
            3 ->
              "case values { [first, second, third, ..rest] -> Ok(ct.List3(first:, second:, third:, rest:)) _ -> Error(\"minimum cardinality 3\") }"
            _ -> panic as "list min > 3 not supported"
          }
          ConversionExpression(
            "{ " <> list_expression <> constructor <> " }",
            expression.helpers,
            True,
          )
        }
        True, False, _, 0 ->
          ConversionExpression(
            "case "
              <> source
              <> " { [] -> Ok(None) [value] -> "
              <> {
              let converted =
                conversion_map(expression, fn(value) { "Some(" <> value <> ")" })
              case converted.fallible {
                True -> converted.expression
                False -> "Ok(" <> converted.expression <> ")"
              }
            }
              <> " _ -> Error(\"maximum cardinality 1\") }",
            expression.helpers,
            True,
          )
        True, False, _, _ ->
          ConversionExpression(
            "case "
              <> source
              <> " { [value] -> "
              <> case expression.fallible {
              True -> expression.expression
              False -> "Ok(" <> expression.expression <> ")"
            }
              <> " _ -> Error(\"cardinality 1..1\") }",
            expression.helpers,
            True,
          )
        False, False, 0, 0 ->
          ConversionExpression(
            "case "
              <> source
              <> " { None -> Ok(None) Some(value) -> "
              <> {
              let converted =
                conversion_map(expression, fn(value) { "Some(" <> value <> ")" })
              case converted.fallible {
                True -> converted.expression
                False -> "Ok(" <> converted.expression <> ")"
              }
            }
              <> " }",
            expression.helpers,
            True,
          )
        False, False, 0, _ ->
          ConversionExpression(
            "case "
              <> source
              <> " { None -> Error(\"required field\") Some(value) -> "
              <> case expression.fallible {
              True -> expression.expression
              False -> "Ok(" <> expression.expression <> ")"
            }
              <> " }",
            expression.helpers,
            True,
          )
        False, False, _, _ -> expression
        False, True, _, _ -> panic as "profile cannot widen base cardinality"
      }
    }
  }
}

fn base_choice_name(element: codegen_helpers.Element) -> String {
  element.base.path
  |> string.replace("[x]", "")
  |> string.split(".")
  |> list.map(string.capitalise)
  |> string.concat
}

fn base_record_reference(
  context: DecodeContext,
  fields,
) -> Result(String, Nil) {
  use base_type <- result.try(base_record_type(fields))
  let assert Ok(first) = list.first(fields)
  let assert [base_root, ..] = string.split(first.base.path, ".")
  Ok(case base_root == context.resource_type {
    True -> base_type
    False -> "ct." <> base_type
  })
}

fn required_binding_conversion(
  element: codegen_helpers.Element,
  fhir_type: String,
  value: String,
) -> Option(ConversionExpression) {
  case element.binding {
    Some(codegen_helpers.Binding(
      strength: "required",
      value_set: Some(value_set),
    )) -> {
      let valueset =
        value_set
        |> canonical_url
        |> codegen_helpers.concept_name_from_url
        |> codegen_helpers.to_snake_case
      let #(function, second_argument) = case fhir_type {
        "code" -> #("valuesets." <> valueset <> "_from_code", "")
        "Coding" -> #(
          "ct.bound_coding_from_coding",
          ", valuesets." <> valueset <> "_from_code_and_system",
        )
        "CodeableConcept" -> #(
          "ct.bound_codeableconcept_from_codeableconcept",
          ", valuesets." <> valueset <> "_from_code_and_system",
        )
        "Quantity" -> #(
          "ct.bound_quantity_from_quantity",
          ", valuesets." <> valueset <> "_from_code_and_system",
        )
        _ -> #("", "")
      }
      case function {
        "" -> None
        _ ->
          Some(ConversionExpression(
            function
              <> "("
              <> value
              <> second_argument
              <> ") |> result.replace_error(\"required ValueSet\")",
            "",
            True,
          ))
      }
    }
    _ -> None
  }
}

fn profile_record_conversion_function(
  context: DecodeContext,
  element: codegen_helpers.Element,
  field_path: String,
  field_type: String,
) -> Result(String, Nil) {
  let restricts_complex_type =
    does_profile_restrict_complex_type(context.type_order, field_path)
  let base_type = case
    fields_for_profile_type(context, field_type, ""),
    element.type_
  {
    Ok(fields), [_] | Ok(fields), [] -> base_record_reference(context, fields)
    Error(_), [_] if restricts_complex_type -> {
      let assert [type_] = element.type_
      Ok(base_payload_type(element, type_.code))
    }
    _, _ -> Error(Nil)
  }
  use base_type <- result.try(base_type)
  Ok(
    codegen_helpers.to_snake_case(field_type)
    <> "_try_from_"
    <> {
      base_type
      |> string.replace("ct.", "")
      |> codegen_helpers.to_snake_case
    },
  )
}

fn direct_profile_record_conversion_function(
  context: DecodeContext,
  element: codegen_helpers.Element,
  field_path: String,
  field_type: String,
) -> Result(String, Nil) {
  case
    dict.get(context.slice_type_overrides, element.id),
    string.ends_with(element.base.path, "[x]")
  {
    Error(_), False ->
      profile_record_conversion_function(
        context,
        element,
        field_path,
        field_type,
      )
    _, _ -> Error(Nil)
  }
}

fn field_inner_conversion(
  context: DecodeContext,
  element: codegen_helpers.Element,
  field_path: String,
  field_type: String,
  value: String,
  source_choice_type: Option(String),
) -> ConversionExpression {
  let narrows_choice =
    string.ends_with(element.base.path, "[x]")
    && list.length(element.type_) == 1
  let inner_value = case narrows_choice {
    True -> "choice_value"
    False -> value
  }
  let conversion = case dict.get(context.slice_type_overrides, element.id) {
    Ok(FixedSliceType(discriminator_type)) -> {
      let assert Ok(#(conversion, _)) =
        discriminator_conversion(
          context,
          element,
          discriminator_type,
          inner_value,
        )
      conversion
    }
    Ok(BoundCodeableconceptSlice) ->
      ConversionExpression(
        bound_codeableconcept_conversion(element, inner_value),
        "",
        True,
      )
    Error(_) ->
      case
        profile_record_conversion_function(
          context,
          element,
          field_path,
          field_type,
        )
      {
        Ok(function) ->
          ConversionExpression(function <> "(" <> inner_value <> ")", "", True)
        Error(_) ->
          case element.type_ {
            [] -> IdentityConversion(inner_value, "", False)
            [type_] ->
              required_binding_conversion(element, type_.code, inner_value)
              |> option.unwrap(IdentityConversion(inner_value, "", False))
            _ ->
              ConversionExpression(
                codegen_helpers.to_snake_case(field_type)
                  <> "_from_"
                  <> codegen_helpers.to_snake_case(base_choice_name(element))
                  <> "("
                  <> value
                  <> ")",
                "",
                True,
              )
          }
      }
  }
  case narrows_choice, element.type_ {
    True, [type_] -> {
      let constructor =
        option.unwrap(source_choice_type, base_choice_name(element))
        <> codegen_helpers.to_camel_case(type_.code)
      let successful = case conversion.fallible {
        True -> conversion.expression
        False -> "Ok(" <> conversion.expression <> ")"
      }
      ConversionExpression(
        "case "
          <> value
          <> " { "
          <> constructor
          <> "(choice_value) -> "
          <> successful
          <> " _ -> Error(\"expected "
          <> type_.code
          <> "\") }",
        conversion.helpers,
        True,
      )
    }
    _, _ -> conversion
  }
}

fn profile_fields(
  fields: List(codegen_helpers.Element),
) -> List(codegen_helpers.Element) {
  let aggregate_slice_groups =
    fields
    |> list.filter_map(fn(group) {
      case aggregate_value_slice_roots(group, fields) {
        Some(aggregate) -> Ok(#(group.id, aggregate))
        None -> Error(Nil)
      }
    })
    |> dict.from_list
  let omitted_slice_roots =
    aggregate_slice_groups
    |> dict.values
    |> list.flat_map(fn(aggregate) {
      let #(roots, _) = aggregate
      list.filter(roots, fn(root) { root.min == 0 })
    })
  list.filter(fields, fn(element) {
    element.max != "0"
    && !list.any(omitted_slice_roots, fn(root) { root.id == element.id })
    && case element.slicing {
      Some(slicing) ->
        slicing.rules != "closed"
        || string.contains(element.path, "[x]")
        || dict.has_key(aggregate_slice_groups, element.id)
      None -> True
    }
  })
}

fn record_conversion_from_fields(
  context: DecodeContext,
  target_type: String,
  base_type: String,
  fields: List(codegen_helpers.Element),
  source_profile_type: Option(String),
) -> String {
  let function_name =
    codegen_helpers.to_snake_case(target_type)
    <> "_try_from_"
    <> {
      base_type
      |> string.replace("ct.", "")
      |> codegen_helpers.to_snake_case
    }
  let discriminator =
    fields
    |> list.find(fn(field) {
      case dict.get(context.slice_type_overrides, field.id) {
        Ok(FixedSliceType(_)) -> True
        _ -> False
      }
    })
    |> option.from_result
  let discriminator_parameter = case discriminator {
    Some(discriminator) -> {
      let #(_, _, _, field_name, field_type) =
        profile_element_names(context, target_type, discriminator)
      ", " <> field_name <> " " <> field_name <> ": " <> field_type
    }
    None -> ""
  }
  let fixed_bindings =
    fields
    |> list.filter_map(fn(element) {
      let fixed = case element.fixed_code, element.fixed_uri {
        Some(value), _ | _, Some(value) -> Ok(value)
        _, _ -> Error(Nil)
      }
      use fixed <- result.try(fixed)
      let #(_, _, json_name, field_name, _) =
        profile_element_names(context, target_type, element)
      let check = case element.base.min, element.base.max {
        0, "1" ->
          "case source."
          <> field_name
          <> " { Some(\""
          <> fixed
          <> "\") -> Ok(Nil) Some(_) -> Error(\"invalid fixed "
          <> json_name
          <> "\") None -> Error(\"required fixed "
          <> json_name
          <> "\") }"
        _, "1" ->
          "case source."
          <> field_name
          <> " == \""
          <> fixed
          <> "\" { True -> Ok(Nil) False -> Error(\"invalid fixed "
          <> json_name
          <> "\") }"
        _, _ -> panic as "unsupported fixed field cardinality"
      }
      Ok("  use _ <- result.try(" <> check <> ")\n")
    })
    |> string.concat
  let #(bindings, arguments) =
    fields
    |> list.filter(fn(element) {
      element.fixed_code == None && element.fixed_uri == None
    })
    |> list.fold(#("", ""), fn(acc, element) {
      let #(bindings, arguments) = acc
      let #(_, field_path, json_name, field_name, field_type) =
        profile_element_names(context, target_type, element)
      let is_primitive =
        profile_field_is_primitive(
          element,
          json_name,
          context.all_primitive_ext,
        )
      let target_min = profile_field_min(element, is_primitive)
      let inner_value = case element.base.min, element.base.max {
        1, max if max != "*" -> "source." <> field_name
        _, _ -> "value"
      }
      let source_field_type = case source_profile_type {
        None ->
          case dict.get(context.base_elements, element.base.path) {
            Ok(base_element) ->
              case base_element.type_ {
                [base_field_type] -> {
                  let #(source_field_type, _) =
                    codegen_helpers.string_to_type(
                      base_field_type.code,
                      base_element.base.path |> string.split("."),
                      base_element,
                      codegen_helpers.Resources,
                      context.valueset_acc,
                    )
                  Some(source_field_type)
                }
                _ -> None
              }
            Error(_) -> None
          }
        Some(source_type) ->
          case fields_for_profile_type(context, source_type, "") {
            Error(_) -> None
            Ok(source_fields) ->
              source_fields
              |> list.find(fn(source_element) {
                source_element.slice_name == None
                && source_element.path == element.path
              })
              |> result.map(fn(source_element) {
                let #(_, _, _, _, source_field_type) =
                  profile_element_names(context, source_type, source_element)
                source_field_type
              })
              |> option.from_result
          }
      }
      let is_discriminator = case discriminator {
        Some(discriminator) -> discriminator.id == element.id
        None -> False
      }
      let inner = case source_field_type, is_discriminator {
        _, True -> IdentityConversion(field_name, "", False)
        Some(source_field_type), False if source_field_type == field_type ->
          IdentityConversion(inner_value, "", False)
        source_field_type, False ->
          field_inner_conversion(
            context,
            element,
            field_path,
            field_type,
            inner_value,
            source_field_type,
          )
      }
      let converted =
        conversion_for_cardinality(
          inner,
          element,
          "source." <> field_name,
          target_min,
          is_primitive,
        )
      let binding = case converted.fallible {
        True ->
          "  use "
          <> field_name
          <> " <- result.try("
          <> converted.expression
          <> ")\n"
        False -> "  let " <> field_name <> " = " <> converted.expression <> "\n"
      }
      #(
        bindings <> converted.helpers <> binding,
        arguments <> "    " <> field_name <> ":,\n",
      )
    })
  "fn "
  <> function_name
  <> "(source: "
  <> base_type
  <> discriminator_parameter
  <> ") -> Result("
  <> target_type
  <> ", String) {\n"
  <> fixed_bindings
  <> bindings
  <> "  Ok("
  <> target_type
  <> "(\n"
  <> arguments
  <> "  ))\n}\n\n"
}

fn record_conversion_source(
  context: DecodeContext,
  current_type: String,
  profile_type: String,
) -> String {
  let target_type = profile_type_name(context, current_type, profile_type)
  let assert Ok(raw_fields) = dict.get(context.type_fields, current_type)
  let fields = profile_fields(raw_fields)
  let #(base_type, source_profile_type) = case
    list.find(context.snapshot_elements, fn(element) {
      case
        element.slice_name,
        string.ends_with(element.path, "[x]"),
        element.type_
      {
        Some(_), False, [codegen_helpers.Type(code: "BackboneElement", ..)]
        | Some(_), False, [codegen_helpers.Type(code: "Element", ..)]
        | Some(_), False, []
        -> {
          let assert [_, ..rest] =
            element.id
            |> string.replace("-", "")
            |> string.replace(":", ".")
            |> string.split(".")
          string.join([context.profile_prefix, ..rest], "_") == current_type
        }
        _, _, _ -> False
      }
    })
  {
    Ok(slice_root) -> {
      let assert [_, ..rest] = slice_root.path |> string.split(".")
      let slice_base_current_type =
        string.join([context.profile_prefix, ..rest], "_")
      case list.contains(context.type_order, slice_base_current_type) {
        True -> {
          let source_type =
            profile_type_name(context, slice_base_current_type, profile_type)
          #(source_type, Some(source_type))
        }
        False -> {
          let assert Ok(base_type) = base_record_reference(context, fields)
          #(base_type, None)
        }
      }
    }
    Error(_) -> {
      let assert Ok(base_type) = base_record_reference(context, fields)
      #(base_type, None)
    }
  }
  record_conversion_from_fields(
    context,
    target_type,
    base_type,
    fields,
    source_profile_type,
  )
}

fn choice_conversion_source(
  context: DecodeContext,
  parent_type: String,
  element: codegen_helpers.Element,
) -> String {
  let #(_, _, _, _, choice_type) =
    profile_element_names(context, parent_type, element)
  let base_choice = base_choice_name(element)
  let #(cases, helpers) =
    list.fold(element.type_, #("", ""), fn(acc, choice) {
      let #(cases, helpers) = acc
      let constructor = choice_type <> string.capitalise(choice.code)
      let base_constructor = base_choice <> string.capitalise(choice.code)
      let #(conversion, new_helpers) = case
        dict.get(
          context.type_slice_overrides,
          type_slice_key(element.id, choice.code),
        )
      {
        Ok(TypeSlicePlan(children: [_, ..] as children, ..)) -> {
          let sliced_name = constructor <> "Sliced"
          let base_type = base_payload_type(element, choice.code)
          let conversion =
            ConversionExpression(
              codegen_helpers.to_snake_case(sliced_name)
                <> "_try_from_"
                <> {
                base_type
                |> string.replace("ct.", "")
                |> codegen_helpers.to_snake_case
              }
                <> "(value)",
              "",
              True,
            )
          let fields =
            list.filter(children, fn(child) {
              child.max != "0"
              && child.fixed_code == None
              && child.fixed_uri == None
            })
          #(
            conversion,
            record_conversion_from_fields(
              context,
              sliced_name,
              base_type,
              fields,
              None,
            ),
          )
        }
        Ok(TypeSlicePlan(slice:, children: [], ..)) -> {
          let conversion =
            required_binding_conversion(slice, choice.code, "value")
            |> option.unwrap(ConversionExpression("value", "", False))
          #(conversion, "")
        }
        _ -> {
          let conversion =
            required_binding_conversion(element, choice.code, "value")
            |> option.unwrap(ConversionExpression("value", "", False))
          #(conversion, "")
        }
      }
      let body = case conversion.fallible {
        True ->
          "      use value <- result.try("
          <> conversion.expression
          <> ")\n      Ok("
          <> constructor
          <> "(value))\n"
        False ->
          "      Ok(" <> constructor <> "(" <> conversion.expression <> "))\n"
      }
      #(
        cases
          <> "    "
          <> base_constructor
          <> "(value) -> {\n"
          <> body
          <> "    }\n",
        helpers <> new_helpers,
      )
    })
  helpers
  <> "fn "
  <> codegen_helpers.to_snake_case(choice_type)
  <> "_from_"
  <> codegen_helpers.to_snake_case(base_choice)
  <> "(value: "
  <> base_choice
  <> ") -> Result("
  <> choice_type
  <> ", String) {\n  case value {\n"
  <> cases
  <> "  }\n}\n\n"
}

fn field_decoder_expression(
  context: DecodeContext,
  parent_type: String,
  element: codegen_helpers.Element,
) -> String {
  let #(all_parts, field_path, json_name, _, field_type) =
    profile_element_names(context, parent_type, element)
  let is_primitive =
    profile_field_is_primitive(element, json_name, context.all_primitive_ext)
  let target_min = profile_field_min(element, is_primitive)
  let decoder = case dict.get(context.slice_type_overrides, element.id) {
    Ok(FixedSliceType(discriminator_type)) -> {
      let assert [type_] = element.type_
      let base_decoder =
        codegen_decode.string_to_decoder_type(
          type_.code,
          all_parts,
          "r4",
          element,
          codegen_helpers.Resources,
        )
      let assert Ok(#(system, code)) = discriminator_literals(context, element)
      let assert Ok(call) =
        codegen_slice_complex_type.discriminator_from_base_call(
          discriminator_type,
          "value",
          system,
          code,
        )
      let assert Ok(fallback) =
        codegen_slice_complex_type.discriminator_new_call(discriminator_type)
      let conversion = case call {
        codegen_slice_complex_type.ResultDiscriminatorCall(call) ->
          "case "
          <> call
          <> " { Ok(value) -> decode.success(value) Error(_) -> decode.failure("
          <> fallback
          <> ", \"discriminator\") }"
        codegen_slice_complex_type.FoundDiscriminatorCall(call) ->
          "case "
          <> call
          <> " { ct.FoundValid(value) -> decode.success(value) ct.FoundInvalid(reason) -> decode.failure("
          <> fallback
          <> ", reason) ct.NotFound -> decode.failure("
          <> fallback
          <> ", \"discriminator\") }"
      }
      base_decoder <> " |> decode.then(fn(value) { " <> conversion <> " })"
    }
    _ ->
      case element.type_ {
        [type_] ->
          case
            does_profile_restrict_complex_type(context.type_order, field_path)
          {
            True -> codegen_helpers.to_snake_case(field_type) <> "_decoder()"
            False ->
              codegen_decode.string_to_decoder_type(
                type_.code,
                all_parts,
                "r4",
                element,
                codegen_helpers.Resources,
              )
          }
        [] -> codegen_helpers.to_snake_case(field_type) <> "_decoder()"
        _ -> codegen_helpers.to_snake_case(field_type) <> "_decoder()"
      }
  }
  case element.type_, element.base.max, element.max, target_min, is_primitive {
    _, base_max, "1", 0, False if base_max != "1" ->
      "ct.optional_one_from_array_decoder(\""
      <> json_name
      <> "\", "
      <> decoder
      <> ")"
    _, base_max, "1", _, False if base_max != "1" ->
      "ct.one_from_array_decoder(\"" <> json_name <> "\", " <> decoder <> ")"
    [_, _, ..], _, _, 0, _ -> "decode.then(none_if_omitted(" <> decoder <> "))"
    [_, _, ..], _, _, _, _ -> "decode.then(" <> decoder <> ")"
    _, _, _, _, _ ->
      codegen_decode.field_decoder(
        json_name,
        decoder,
        target_min,
        case element.max == "1" {
          True -> "1"
          False -> "*"
        },
        is_primitive,
      )
  }
}

fn choice_decoder_source(
  context: DecodeContext,
  parent_type: String,
  element: codegen_helpers.Element,
) -> String {
  let #(all_parts, _, json_name, _, choice_type) =
    profile_element_names(context, parent_type, element)
  let decoders =
    list.map(element.type_, fn(choice) {
      let constructor = choice_type <> string.capitalise(choice.code)
      let decoder = case
        dict.get(
          context.type_slice_overrides,
          type_slice_key(element.id, choice.code),
        )
      {
        Ok(TypeSlicePlan(children: [_, ..], ..)) ->
          codegen_helpers.to_snake_case(constructor <> "Sliced") <> "_decoder()"
        Ok(TypeSlicePlan(slice:, children: [], ..)) ->
          codegen_decode.string_to_decoder_type(
            choice.code,
            all_parts,
            "r4",
            slice,
            codegen_helpers.Resources,
          )
        _ ->
          codegen_decode.string_to_decoder_type(
            choice.code,
            [
              "somehow this is used in [x] for any type (int, bool, code, etc) and ofc that code has no defined binding",
            ],
            "r4",
            element,
            codegen_helpers.Resources,
          )
      }
      let assert [first, ..rest] = choice.code |> string.to_graphemes
      "decode.field(\""
      <> json_name
      <> string.concat([string.uppercase(first), ..rest])
      <> "\", "
      <> decoder
      <> ", decode.success) |> decode.map("
      <> constructor
      <> ")"
    })
  let assert [first, ..rest] = decoders
  let sliced_decoders =
    list.fold(element.type_, "", fn(source, choice) {
      case
        dict.get(
          context.type_slice_overrides,
          type_slice_key(element.id, choice.code),
        )
      {
        Ok(TypeSlicePlan(children: [_, ..] as children, ..)) -> {
          let constructor = choice_type <> string.capitalise(choice.code)
          source
          <> record_decoder_from_fields(
            context,
            constructor <> "Sliced",
            children,
            None,
            True,
          )
        }
        _ -> source
      }
    })
  sliced_decoders
  <> "pub fn "
  <> codegen_helpers.to_snake_case(choice_type)
  <> "_decoder() -> Decoder("
  <> choice_type
  <> ") {\n  decode.one_of(\n    "
  <> first
  <> ",\n    ["
  <> string.join(rest, ",\n      ")
  <> "],\n  )\n}\n\n"
}

fn profile_record_base_expression(
  context: DecodeContext,
  profile_type: String,
  base_type: String,
  value: String,
) -> String {
  let assert Ok(fields) = fields_for_profile_type(context, profile_type, "")
  let arguments =
    fields
    |> profile_fields
    |> list.map(fn(field) {
      let #(_, _, json_name, field_name, _) =
        profile_element_names(context, profile_type, field)
      let source_min =
        profile_field_min(
          field,
          profile_field_is_primitive(
            field,
            json_name,
            context.all_primitive_ext,
          ),
        )
      let source = value <> "." <> field_name
      let expression = case
        field.base.min,
        field.base.max,
        source_min,
        field.max
      {
        0, "1", source_min, "1" if source_min > 0 -> "Some(" <> source <> ")"
        0, "*", 1, "*" ->
          "{ let ct.List1(first:, rest:) = " <> source <> " [first, ..rest] }"
        0, "*", 2, "*" ->
          "{ let ct.List2(first:, second:, rest:) = "
          <> source
          <> " [first, second, ..rest] }"
        0, "*", 3, "*" ->
          "{ let ct.List3(first:, second:, third:, rest:) = "
          <> source
          <> " [first, second, third, ..rest] }"
        _, _, _, _ -> source
      }
      field_name <> ": " <> expression
    })
    |> string.join(", ")
  base_type <> "(" <> arguments <> ")"
}

fn slice_match(
  context: DecodeContext,
  parent_type: String,
  group: codegen_helpers.Element,
  root: codegen_helpers.Element,
  value: String,
) -> SliceMatch {
  let #(_, _, _, _, root_type) =
    profile_element_names(context, parent_type, root)
  let #(_, slice_base_field_path, _, _, slice_base_type) =
    profile_element_names(context, parent_type, group)
  let use_profile_slice_base =
    list.contains(context.type_order, slice_base_field_path)
  let assert Some(slice_name) = root.slice_name
  let group_choice =
    parent_type
    <> {
      let assert Ok(name) = group.path |> string.split(".") |> list.last
      name
      |> string.replace("[x]", "")
      |> codegen_helpers.escape_field_name
      |> string.capitalise
    }
  let constructor =
    aggregate_slice_constructor(group_choice, slice_name, root_type)
  case profile_extension_definition(root, context.extensions) {
    Some(extension) -> {
      let matcher =
        codegen_helpers.to_snake_case(
          context.profile_prefix <> "_" <> extension.name,
        )
        <> "_from_extension"
      SliceMatch(
        matcher <> "(" <> value <> ")",
        Some(matcher),
        True,
        root_type,
        constructor,
      )
    }
    None ->
      case dict.get(context.slice_type_overrides, root.id) {
        Ok(FixedSliceType(discriminator_type)) -> {
          let assert Ok(#(system, code)) = discriminator_literals(context, root)
          let call = case use_profile_slice_base {
            True ->
              codegen_slice_complex_type.discriminator_from_required_profile_call(
                discriminator_type,
                value,
                system,
              )
            False -> Error(Nil)
          }
          let call = case call, group.type_ {
            Ok(call), _ -> call
            Error(_), [type_] if use_profile_slice_base -> {
              let discriminator_value =
                profile_record_base_expression(
                  context,
                  slice_base_type,
                  base_payload_type(group, type_.code),
                  value,
                )
              let assert Ok(call) =
                codegen_slice_complex_type.discriminator_from_base_call(
                  discriminator_type,
                  discriminator_value,
                  system,
                  code,
                )
              call
            }
            Error(_), _ -> {
              let assert Ok(call) =
                codegen_slice_complex_type.discriminator_from_base_call(
                  discriminator_type,
                  value,
                  system,
                  code,
                )
              call
            }
          }
          case call {
            codegen_slice_complex_type.ResultDiscriminatorCall(expression) ->
              SliceMatch(expression, None, False, root_type, constructor)
            codegen_slice_complex_type.FoundDiscriminatorCall(expression) ->
              SliceMatch(expression, None, True, root_type, constructor)
          }
        }
        Ok(BoundCodeableconceptSlice) -> {
          let assert Some(codegen_helpers.Binding(
            value_set: Some(value_set),
            ..,
          )) = root.binding
          let valueset =
            value_set
            |> canonical_url
            |> codegen_helpers.concept_name_from_url
            |> codegen_helpers.to_snake_case
          SliceMatch(
            "ct.bound_codeableconcept_from_codeableconcept("
              <> value
              <> ", valuesets."
              <> valueset
              <> "_from_code_and_system)",
            None,
            False,
            root_type,
            constructor,
          )
        }
        Error(_) -> {
          let classifier_base_type = case use_profile_slice_base {
            True -> slice_base_type
            False ->
              case group.type_ {
                [type_] -> base_payload_type(group, type_.code)
                [] ->
                  codegen_helpers.link_type_from(
                    group.content_reference,
                    context.resource_type,
                  )
                _ -> panic as "sliced group is unexpectedly a choice"
              }
          }
          let matcher =
            codegen_helpers.to_snake_case(root_type)
            <> "_from_"
            <> {
              classifier_base_type
              |> string.replace("ct.", "")
              |> codegen_helpers.to_snake_case
            }
          SliceMatch(
            matcher <> "(" <> value <> ")",
            Some(matcher),
            True,
            root_type,
            constructor,
          )
        }
      }
  }
}

fn slice_matcher(match: SliceMatch) -> String {
  case match.matcher {
    Some(matcher) -> matcher
    None -> "fn(value) { " <> match.expression <> " }"
  }
}

fn found_slice_matcher(match: SliceMatch) -> String {
  case match.returns_found {
    True -> slice_matcher(match)
    False ->
      "fn(value) { case "
      <> match.expression
      <> " { Ok(value) -> ct.FoundValid(value) Error(_) -> ct.NotFound } }"
  }
}

fn profile_record_placeholder(
  context: DecodeContext,
  target_type: String,
) -> String {
  let fields = case fields_for_profile_type(context, target_type, "") {
    Ok(fields) -> fields
    Error(_) -> panic as { "no fields for placeholder " <> target_type }
  }
  let arguments =
    fields
    |> profile_fields
    |> list.filter_map(fn(field) {
      let #(_, _, json_name, field_name, field_type) =
        profile_element_names(context, target_type, field)
      let is_primitive =
        profile_field_is_primitive(field, json_name, context.all_primitive_ext)
      let minimum = profile_field_min(field, is_primitive)
      case
        minimum > 0
        && !is_primitive
        && field.fixed_code == None
        && field.fixed_uri == None
      {
        False -> Error(Nil)
        True -> {
          let value = case dict.get(context.slice_type_overrides, field.id) {
            Ok(FixedSliceType(discriminator_type)) -> {
              let assert Ok(value) =
                codegen_slice_complex_type.discriminator_new_call(
                  discriminator_type,
                )
              value
            }
            Ok(BoundCodeableconceptSlice) -> {
              let assert Some(codegen_helpers.Binding(
                value_set: Some(value_set),
                ..,
              )) = field.binding
              "ct.bound_codeableconcept_new(valuesets."
              <> {
                value_set
                |> canonical_url
                |> codegen_helpers.concept_name_from_url
                |> codegen_helpers.to_snake_case
              }
              <> "_failure_variant)"
            }
            Error(_) ->
              case field_type {
                "String" -> "\"\""
                "Bool" -> "False"
                "Int" -> "0"
                "Float" -> "0.0"
                _ ->
                  case fields_for_profile_type(context, field_type, "") {
                    Ok(_) -> profile_record_placeholder(context, field_type)
                    Error(_) -> {
                      let type_parts = string.split(field_type, ".")
                      case type_parts {
                        [module, type_] ->
                          module
                          <> "."
                          <> codegen_helpers.to_snake_case(type_)
                          <> "_new()"
                        _ ->
                          codegen_helpers.to_snake_case(field_type) <> "_new()"
                      }
                    }
                  }
              }
          }
          let value = case minimum, field.max {
            1, "*" -> "ct.List1(first: " <> value <> ", rest: [])"
            2, "*" ->
              "ct.List2(first: "
              <> value
              <> ", second: "
              <> value
              <> ", rest: [])"
            3, "*" ->
              "ct.List3(first: "
              <> value
              <> ", second: "
              <> value
              <> ", third: "
              <> value
              <> ", rest: [])"
            _, _ -> value
          }
          Ok(field_name <> ": " <> value)
        }
      }
    })
    |> string.join(", ")
  codegen_helpers.to_snake_case(target_type) <> "_new(" <> arguments <> ")"
}

fn slice_placeholder(
  context: DecodeContext,
  root: codegen_helpers.Element,
  match: SliceMatch,
) -> String {
  case dict.get(context.slice_type_overrides, root.id) {
    Ok(FixedSliceType(discriminator_type)) -> {
      let assert Ok(placeholder) =
        codegen_slice_complex_type.discriminator_new_call(discriminator_type)
      placeholder
    }
    Ok(BoundCodeableconceptSlice) -> {
      let assert Some(codegen_helpers.Binding(value_set: Some(value_set), ..)) =
        root.binding
      let valueset =
        value_set
        |> canonical_url
        |> codegen_helpers.concept_name_from_url
        |> codegen_helpers.to_snake_case
      "ct.bound_codeableconcept_new(valuesets."
      <> valueset
      <> "_failure_variant)"
    }
    Error(_) ->
      case fields_for_profile_type(context, match.target_type, "") {
        Ok(_) -> profile_record_placeholder(context, match.target_type)
        Error(_) ->
          panic as {
            "no placeholder for slice "
            <> root.id
            <> " target "
            <> match.target_type
          }
      }
  }
}

fn required_single_slice_binding(
  context: DecodeContext,
  variable: String,
  remaining: String,
  root: codegen_helpers.Element,
  match: SliceMatch,
) -> String {
  let placeholder = slice_placeholder(context, root, match)
  "  use #("
  <> variable
  <> ", "
  <> remaining
  <> ") <- "
  <> case match.returns_found {
    True -> "find_required_elt_and_rest_found"
    False -> "find_required_elt_and_rest_result"
  }
  <> "(\n    in: "
  <> remaining
  <> ",\n    one_that: "
  <> slice_matcher(match)
  <> ",\n    placeholder: "
  <> placeholder
  <> ",\n    expected: \""
  <> match.target_type
  <> " discriminator\",\n  )\n"
}

fn slice_binding_source(
  context: DecodeContext,
  variable: String,
  remaining: String,
  root: codegen_helpers.Element,
  match: SliceMatch,
) -> String {
  let found_matcher = found_slice_matcher(match)
  case root.min, root.max {
    1, "1" ->
      required_single_slice_binding(context, variable, remaining, root, match)
    0, "1" ->
      "  use #("
      <> variable
      <> ", "
      <> remaining
      <> ") <- "
      <> case match.returns_found {
        True -> "find_optional_elt_and_rest_found"
        False -> "find_optional_elt_and_rest_result"
      }
      <> "(\n    in: "
      <> remaining
      <> ",\n    one_that: "
      <> case match.returns_found {
        True -> found_matcher
        False -> slice_matcher(match)
      }
      <> ",\n  )\n"
    minimum, "*" -> {
      let #(finder_placeholder, typed_placeholder, cardinality) = case minimum {
        0 -> #("[]", "[]", "")
        minimum -> {
          let placeholder = slice_placeholder(context, root, match)
          case minimum {
            1 -> #(
              "[" <> placeholder <> "]",
              "ct.List1(first: " <> placeholder <> ", rest: [])",
              "case values { [first, ..rest] -> Ok(ct.List1(first:, rest:)) _ -> Error(\"minimum cardinality 1\") }",
            )
            2 -> #(
              "[" <> placeholder <> ", " <> placeholder <> "]",
              "ct.List2(first: "
                <> placeholder
                <> ", second: "
                <> placeholder
                <> ", rest: [])",
              "case values { [first, second, ..rest] -> Ok(ct.List2(first:, second:, rest:)) _ -> Error(\"minimum cardinality 2\") }",
            )
            3 -> #(
              "["
                <> placeholder
                <> ", "
                <> placeholder
                <> ", "
                <> placeholder
                <> "]",
              "ct.List3(first: "
                <> placeholder
                <> ", second: "
                <> placeholder
                <> ", third: "
                <> placeholder
                <> ", rest: [])",
              "case values { [first, second, third, ..rest] -> Ok(ct.List3(first:, second:, third:, rest:)) _ -> Error(\"minimum cardinality 3\") }",
            )
            _ -> panic as "slice minimum > 3 not supported"
          }
        }
      }
      let values = case minimum {
        0 -> variable
        _ -> variable <> "_values"
      }
      let finder = case match.returns_found {
        True -> "find_at_least_n_elts_and_rest_found_or_failure"
        False -> "find_at_least_n_elts_and_rest_result_or_failure"
      }
      let matcher = case match.returns_found {
        True -> found_matcher
        False -> slice_matcher(match)
      }
      "  use #("
      <> values
      <> ", "
      <> remaining
      <> ") <- "
      <> finder
      <> "(\n    in: "
      <> remaining
      <> ",\n    items_that: "
      <> matcher
      <> ",\n    at_least: "
      <> int.to_string(minimum)
      <> ",\n    placeholder: "
      <> finder_placeholder
      <> ",\n    expected: \""
      <> match.target_type
      <> " discriminator\",\n  )\n"
      <> case minimum {
        0 -> ""
        _ ->
          "  use "
          <> variable
          <> " <- result_or_decode_failure(\n    { let values = "
          <> values
          <> " "
          <> cardinality
          <> " },\n    placeholder: "
          <> typed_placeholder
          <> ",\n  )\n"
      }
    }
    _, _ -> panic as "unsupported named slice cardinality"
  }
}

fn slice_value_list(
  variable: String,
  root: codegen_helpers.Element,
  constructor: String,
) -> String {
  let wrap = fn(value) { constructor <> "(" <> value <> ")" }
  case root.min, root.max {
    0, "1" ->
      "case "
      <> variable
      <> " { None -> [] Some(value) -> ["
      <> wrap("value")
      <> "] }"
    1, "1" -> "[" <> wrap(variable) <> "]"
    0, "*" -> "list.map(" <> variable <> ", " <> constructor <> ")"
    1, "*" ->
      "{ let ct.List1(first:, rest:) = "
      <> variable
      <> " ["
      <> wrap("first")
      <> ", ..list.map(rest, "
      <> constructor
      <> ")] }"
    2, "*" ->
      "{ let ct.List2(first:, second:, rest:) = "
      <> variable
      <> " ["
      <> wrap("first")
      <> ", "
      <> wrap("second")
      <> ", ..list.map(rest, "
      <> constructor
      <> ")] }"
    3, "*" ->
      "{ let ct.List3(first:, second:, third:, rest:) = "
      <> variable
      <> " ["
      <> wrap("first")
      <> ", "
      <> wrap("second")
      <> ", "
      <> wrap("third")
      <> ", ..list.map(rest, "
      <> constructor
      <> ")] }"
    _, _ -> panic as "unsupported slice cardinality"
  }
}

fn old_slice_group_bindings(
  context: DecodeContext,
  parent_type: String,
  group: codegen_helpers.Element,
  roots: List(codegen_helpers.Element),
  aggregate: Option(#(List(codegen_helpers.Element), Int)),
) -> String {
  let #(_, field_path, json_name, field_name, slice_base_type) =
    profile_element_names(context, parent_type, group)
  let use_profile_slice_base = list.contains(context.type_order, field_path)
  let base_decoder = case use_profile_slice_base {
    True -> codegen_helpers.to_snake_case(slice_base_type) <> "_decoder()"
    False ->
      case group.type_ {
        [type_] -> {
          let all_parts =
            group.base.path
            |> string.replace("[x]", "")
            |> string.split(".")
          codegen_decode.string_to_decoder_type(
            type_.code,
            all_parts,
            "r4",
            group,
            codegen_helpers.Resources,
          )
        }
        [] ->
          codegen_helpers.link_type_from(
            group.content_reference,
            context.resource_type,
          )
          |> codegen_helpers.to_snake_case
          |> fn(name) { name <> "_decoder()" }
        _ -> panic as "sliced group is unexpectedly a choice"
      }
  }
  let base_values = field_name <> "_base_values"
  let initial =
    "  use "
    <> base_values
    <> " <- decode.optional_field(\""
    <> json_name
    <> "\", [], decode.list("
    <> base_decoder
    <> "))\n"
  let #(bindings, remaining, matches) =
    list.fold(roots, #(initial, base_values, []), fn(acc, root) {
      let #(bindings, remaining, matches) = acc
      let #(_, _, _, variable, _) =
        profile_element_names(context, parent_type, root)
      let match = slice_match(context, parent_type, group, root, "value")
      #(
        bindings
          <> slice_binding_source(context, variable, remaining, root, match),
        remaining,
        [#(root, variable, match), ..matches],
      )
    })
  case aggregate {
    None -> {
      let assert Some(slicing) = group.slicing
      bindings
      <> case slicing.rules {
        "closed" ->
          "  use _ <- result_or_decode_failure(\n    case "
          <> remaining
          <> " { [] -> Ok(Nil) _ -> Error(\"element does not match any permitted closed slice\") },\n    placeholder: Nil,\n  )\n"
        "open" | "openAtEnd" ->
          case use_profile_slice_base {
            True -> "  let " <> field_name <> " = " <> remaining <> "\n"
            False -> {
              let open_conversion =
                field_inner_conversion(
                  context,
                  group,
                  field_path,
                  slice_base_type,
                  "value",
                  None,
                )
              let converted =
                conversion_for_cardinality(
                  open_conversion,
                  group,
                  remaining,
                  profile_field_min(group, False),
                  False,
                )
              let converted_expression = case
                direct_profile_record_conversion_function(
                  context,
                  group,
                  field_path,
                  slice_base_type,
                ),
                group.base.max != "1",
                group.max != "1",
                profile_field_min(group, False),
                open_conversion.fallible
              {
                Ok(function), True, True, 0, True ->
                  "list.try_map(" <> remaining <> ", " <> function <> ")"
                _, _, _, _, _ -> converted.expression
              }
              case converted.fallible {
                False ->
                  "  let "
                  <> field_name
                  <> " = "
                  <> converted.expression
                  <> "\n"
                True ->
                  "  use "
                  <> field_name
                  <> " <- result_or_decode_failure(\n    "
                  <> converted_expression
                  <> ",\n    placeholder: [],\n  )\n"
              }
            }
          }
        rules -> panic as { "unknown slicing rule " <> rules }
      }
    }
    Some(#(_, minimum)) -> {
      let group_choice =
        parent_type
        <> {
          let assert Ok(name) = group.path |> string.split(".") |> list.last
          name
          |> string.replace("[x]", "")
          |> codegen_helpers.escape_field_name
          |> string.capitalise
        }
      let open_constructor =
        aggregate_slice_constructor(group_choice, "Open", slice_base_type)
      let open_conversion = case use_profile_slice_base {
        True -> IdentityConversion("value", "", False)
        False ->
          field_inner_conversion(
            context,
            group,
            field_path,
            slice_base_type,
            "value",
            None,
          )
      }
      let open_conversion_function = case use_profile_slice_base {
        True -> Error(Nil)
        False ->
          direct_profile_record_conversion_function(
            context,
            group,
            field_path,
            slice_base_type,
          )
      }
      let open_values = case open_conversion.fallible {
        True -> {
          let mapper = case open_conversion_function {
            Ok(function) -> function
            Error(_) -> "fn(value) { " <> open_conversion.expression <> " }"
          }
          "list.try_map("
          <> remaining
          <> ", "
          <> mapper
          <> ")\n|> result.map(fn(values) { list.map(values, "
          <> open_constructor
          <> ") })"
        }
        False ->
          "list.map("
          <> remaining
          <> ", fn(value) { "
          <> open_constructor
          <> "("
          <> open_conversion.expression
          <> ") })"
      }
      let named_lists =
        matches
        |> list.reverse
        |> list.map(fn(item) {
          let #(root, variable, match) = item
          slice_value_list(variable, root, match.constructor)
        })
      let all_values =
        "list.flatten(["
        <> string.join(["open_values", ..named_lists], ", ")
        <> "])"
      let cardinality = case minimum {
        0 -> "Ok(values)"
        1 ->
          "case values { [first, ..rest] -> Ok(ct.List1(first:, rest:)) _ -> Error(\"minimum cardinality 1\") }"
        2 ->
          "case values { [first, second, ..rest] -> Ok(ct.List2(first:, second:, rest:)) _ -> Error(\"minimum cardinality 2\") }"
        3 ->
          "case values { [first, second, third, ..rest] -> Ok(ct.List3(first:, second:, third:, rest:)) _ -> Error(\"minimum cardinality 3\") }"
        _ -> panic as "aggregate minimum > 3 not supported"
      }
      let aggregate_placeholder = case minimum {
        0 -> "[]"
        _ -> {
          let assert [#(root, _, match), ..] = matches
          let first_placeholder =
            match.constructor
            <> "("
            <> slice_placeholder(context, root, match)
            <> ")"
          case minimum {
            1 -> "ct.List1(first: " <> first_placeholder <> ", rest: [])"
            2 ->
              "ct.List2(first: "
              <> first_placeholder
              <> ", second: "
              <> first_placeholder
              <> ", rest: [])"
            3 ->
              "ct.List3(first: "
              <> first_placeholder
              <> ", second: "
              <> first_placeholder
              <> ", third: "
              <> first_placeholder
              <> ", rest: [])"
            _ -> panic as "aggregate minimum > 3 not supported"
          }
        }
      }
      let finish =
        "  let values = "
        <> all_values
        <> "\n  use "
        <> field_name
        <> " <- result_or_decode_failure(\n    "
        <> cardinality
        <> ",\n    placeholder: "
        <> aggregate_placeholder
        <> ",\n  )\n"
      let open_binding = case open_conversion.fallible {
        False -> "  let open_values = " <> open_values <> "\n"
        True ->
          "  use open_values <- result_or_decode_failure(\n    "
          <> open_values
          <> ",\n    placeholder: [],\n  )\n"
      }
      bindings <> open_binding <> finish
    }
  }
}

fn slice_group_support_source(
  context: DecodeContext,
  parent_type: String,
  group: codegen_helpers.Element,
  roots: List(codegen_helpers.Element),
  aggregate: Option(#(List(codegen_helpers.Element), Int)),
) -> String {
  let natural_group_type = slice_group_type_name(parent_type, group)
  let #(_, _, _, _, base_type) =
    profile_element_names(context, parent_type, group)
  let group_type = case aggregate {
    Some(_) -> aggregate_slice_type_name(natural_group_type, base_type)
    None -> natural_group_type
  }
  let accumulator_type = group_type <> "SliceAccumulator"
  case aggregate {
    Some(_) ->
      "type "
      <> accumulator_type
      <> " {\n  "
      <> accumulator_type
      <> "(values: List("
      <> group_type
      <> "))\n}\n\n"
    None -> {
      let assert Some(slicing) = group.slicing
      let open = slicing.rules != "closed"
      let assert Ok(field_part) = group.path |> string.split(".") |> list.last
      let field_part =
        field_part
        |> string.replace("[x]", "")
        |> codegen_helpers.escape_field_name
        |> string.capitalise
      let parsed_type = parent_type <> "Parsed" <> field_part <> "Slice"
      let slices_type = group_type <> "Slices"
      let accumulator_fields =
        roots
        |> list.map(fn(root) {
          let #(_, _, _, field_name, field_type) =
            profile_element_names(context, parent_type, root)
          "    " <> field_name <> ": List(" <> field_type <> "),\n"
        })
        |> string.concat
      let accumulator_fields = case open {
        True -> accumulator_fields <> "    open: List(" <> base_type <> "),\n"
        False -> accumulator_fields
      }
      let parsed_variants =
        roots
        |> list.map(fn(root) {
          let #(_, _, _, _, field_type) =
            profile_element_names(context, parent_type, root)
          "  "
          <> parsed_type
          <> slice_name_type_part(root)
          <> "("
          <> field_type
          <> ")\n"
        })
        |> string.concat
      let parsed_variants = case open {
        True ->
          parsed_variants
          <> "  "
          <> parsed_type
          <> "Open("
          <> base_type
          <> ")\n"
        False -> parsed_variants
      }
      let result_fields =
        roots
        |> list.map(fn(root) {
          let #(_, _, _, field_name, field_type) =
            profile_element_names(context, parent_type, root)
          "    "
          <> field_name
          <> ": "
          <> codegen_helpers.cardinality(field_type, root.min, root.max)
          <> ",\n"
        })
        |> string.concat
      let result_fields = case open {
        True -> result_fields <> "    open: List(" <> base_type <> "),\n"
        False -> result_fields
      }
      "type "
      <> accumulator_type
      <> " {\n  "
      <> accumulator_type
      <> "(\n"
      <> accumulator_fields
      <> "  )\n}\n\n"
      <> "type "
      <> parsed_type
      <> " {\n"
      <> parsed_variants
      <> "}\n\n"
      <> "type "
      <> slices_type
      <> " {\n  "
      <> slices_type
      <> "(\n"
      <> result_fields
      <> "  )\n}\n\n"
    }
  }
}

fn slice_support_types(context: DecodeContext, profile_type: String) -> String {
  let groups =
    context.type_order
    |> list.flat_map(fn(current_type) {
      let assert Ok(fields) = dict.get(context.type_fields, current_type)
      let parent_type = profile_type_name(context, current_type, profile_type)
      fields
      |> list.filter_map(fn(group) {
        let roots = direct_slice_roots(group, fields)
        let is_choice = string.contains(group.id, "[x]")
        let is_extension =
          list.any(group.type_, fn(type_) { type_.code == "Extension" })
        case
          group.slicing,
          group.base.max,
          list.length(group.type_),
          is_choice,
          is_extension,
          roots
        {
          Some(_), base_max, type_count, False, False, [_, ..]
            if base_max != "1" && type_count <= 1
          ->
            Ok(#(
              parent_type,
              group,
              roots,
              aggregate_value_slice_roots(group, fields),
            ))
          _, _, _, _, _, _ -> Error(Nil)
        }
      })
    })
  groups
  |> list.map(fn(group) {
    let #(parent_type, group, roots, aggregate) = group
    slice_group_support_source(context, parent_type, group, roots, aggregate)
    <> {
      roots
      |> list.map(fn(root) {
        case dict.has_key(context.slice_type_overrides, root.id) {
          True -> ""
          False -> slice_converter_source(context, parent_type, group, root)
        }
      })
      |> string.concat
    }
  })
  |> string.concat
}

pub const slice_acc_errors_source = "fn slice_acc_errors(result: Result(a, List(decode.DecodeError))) -> List(decode.DecodeError) {\n  case result {\n    Ok(_) -> []\n    Error(errors) -> errors\n  }\n}\n\n"

fn slice_decode_error(
  expected: String,
  found: String,
  json_name: String,
  indexed: Bool,
) -> String {
  let path = case indexed {
    True -> "[\"" <> json_name <> "\", int.to_string(index)]"
    False -> "[\"" <> json_name <> "\"]"
  }
  "decode.DecodeError(expected: \""
  <> expected
  <> "\", found: \""
  <> found
  <> "\", path: "
  <> path
  <> ")"
}

fn slice_path(json_name: String, indexed: Bool) -> String {
  case indexed {
    True -> "[\"" <> json_name <> "\", int.to_string(index)]"
    False -> "[\"" <> json_name <> "\"]"
  }
}

fn direct_slice_record_expression(
  context: DecodeContext,
  target_type: String,
  base_type: String,
  discriminator: codegen_helpers.Element,
  source: String,
) -> Result(String, Nil) {
  use target_fields <- result.try(fields_for_profile_type(
    context,
    target_type,
    "",
  ))
  use source_fields <- result.try(fields_for_profile_type(
    context,
    base_type,
    "",
  ))
  let arguments =
    target_fields
    |> profile_fields
    |> list.try_map(fn(target) {
      let #(_, _, target_json_name, target_field_name, target_field_type) =
        profile_element_names(context, target_type, target)
      case target.id == discriminator.id {
        True -> Ok(target_field_name <> ": matched")
        False -> {
          use source_field <- result.try(
            list.find(source_fields, fn(candidate) {
              candidate.slice_name == None && candidate.path == target.path
            }),
          )
          let #(_, _, source_json_name, source_field_name, source_field_type) =
            profile_element_names(context, base_type, source_field)
          let target_min =
            profile_field_min(
              target,
              profile_field_is_primitive(
                target,
                target_json_name,
                context.all_primitive_ext,
              ),
            )
          let source_min =
            profile_field_min(
              source_field,
              profile_field_is_primitive(
                source_field,
                source_json_name,
                context.all_primitive_ext,
              ),
            )
          case
            target_field_type == source_field_type,
            target_min == source_min,
            target.max == source_field.max
          {
            True, True, True ->
              Ok(
                target_field_name <> ": " <> source <> "." <> source_field_name,
              )
            _, _, _ -> Error(Nil)
          }
        }
      }
    })
  use arguments <- result.try(arguments)
  Ok(target_type <> "(" <> string.join(arguments, ", ") <> ")")
}

fn validation_results_source(results: List(#(String, String))) -> String {
  case results {
    [] -> "Ok(Nil)"
    results -> {
      let bindings =
        results
        |> list.map(fn(result) {
          "let " <> result.0 <> " = " <> result.1 <> "\n"
        })
        |> string.concat
      let names = list.map(results, fn(result) { result.0 })
      let ok_patterns = list.map(names, fn(_) { "Ok(_)" })
      let errors =
        names
        |> list.map(fn(name) { "slice_acc_errors(" <> name <> ")" })
        |> string.join(", ")
      "{ "
      <> bindings
      <> "case "
      <> string.join(names, ", ")
      <> " { "
      <> string.join(ok_patterns, ", ")
      <> " -> Ok(Nil) "
      <> { names |> list.map(fn(_) { "_" }) |> string.join(", ") }
      <> " -> Error(list.flatten(["
      <> errors
      <> "])) } }"
    }
  }
}

fn restricted_record_validation(
  context: DecodeContext,
  target_type: String,
  source: String,
  path: String,
) -> String {
  let assert Ok(fields) = fields_for_profile_type(context, target_type, "")
  fields
  |> list.index_fold([], fn(results, field, field_index) {
    let #(_, _, json_name, field_name, _) =
      profile_element_names(context, target_type, field)
    let field_path = "list.append(" <> path <> ", [\"" <> json_name <> "\"])"
    let result_name = "constraint_" <> int.to_string(field_index)
    let cardinality_name = case json_name, field.type_ {
      "value", [codegen_helpers.Type(code:, ..)] -> code <> " value"
      _, _ -> json_name
    }
    case field.fixed_code, field.fixed_uri, field.base.min, field.base.max {
      Some(fixed), _, 0, "1" | _, Some(fixed), 0, "1" -> [
        #(
          result_name,
          "case "
            <> source
            <> "."
            <> field_name
            <> " { Some(\""
            <> fixed
            <> "\") -> Ok(Nil) Some(found) -> Error([decode.DecodeError(expected: \""
            <> fixed
            <> "\", found:, path: "
            <> field_path
            <> ")]) None -> Error([decode.DecodeError(expected: \""
            <> fixed
            <> "\", found: \"omitted\", path: "
            <> field_path
            <> ")]) }",
        ),
        ..results
      ]
      Some(fixed), _, _, "1" | _, Some(fixed), _, "1" -> [
        #(
          result_name,
          "case "
            <> source
            <> "."
            <> field_name
            <> " { \""
            <> fixed
            <> "\" -> Ok(Nil) found -> Error([decode.DecodeError(expected: \""
            <> fixed
            <> "\", found:, path: "
            <> field_path
            <> ")]) }",
        ),
        ..results
      ]
      None, None, 0, "1" if field.min > 0 -> [
        #(
          result_name,
          "case "
            <> source
            <> "."
            <> field_name
            <> " { Some(_) -> Ok(Nil) None -> Error([decode.DecodeError(expected: \"1 "
            <> cardinality_name
            <> "\", found: \"0 "
            <> cardinality_name
            <> "s\", path: "
            <> field_path
            <> ")]) }",
        ),
        ..results
      ]
      _, _, _, _ -> results
    }
  })
  |> list.reverse
  |> validation_results_source
}

fn slice_record_validation(
  context: DecodeContext,
  target_type: String,
  base_type: String,
  source: String,
  json_name: String,
) -> String {
  let assert Ok(target_fields) =
    fields_for_profile_type(context, target_type, "")
  let assert Ok(source_fields) = fields_for_profile_type(context, base_type, "")
  target_fields
  |> profile_fields
  |> list.index_fold([], fn(results, target, field_index) {
    let narrowed_choice =
      string.ends_with(target.base.path, "[x]")
      && list.length(target.type_) == 1
    case narrowed_choice {
      False -> results
      True -> {
        let assert [choice] = target.type_
        let assert Ok(source_field) =
          list.find(source_fields, fn(candidate) {
            candidate.slice_name == None && candidate.path == target.path
          })
        let #(_, _, _, source_field_name, source_field_type) =
          profile_element_names(context, base_type, source_field)
        let #(_, _, choice_json_name, _, target_field_type) =
          profile_element_names(context, target_type, target)
        let base_json_name =
          target.path
          |> string.split(".")
          |> list.last
          |> result.unwrap(choice_json_name)
        let choice_path =
          "[\""
          <> json_name
          <> "\", int.to_string(index), \""
          <> choice_json_name
          <> "\"]"
        let wrong_path =
          "[\""
          <> json_name
          <> "\", int.to_string(index), \""
          <> base_json_name
          <> "\"]"
        let constructor =
          source_field_type <> codegen_helpers.to_camel_case(choice.code)
        let nested = case
          fields_for_profile_type(context, target_field_type, "")
        {
          Ok(_) ->
            restricted_record_validation(
              context,
              target_field_type,
              "choice_value",
              choice_path,
            )
          Error(_) -> "Ok(Nil)"
        }
        let choice_value_pattern = case nested {
          "Ok(Nil)" -> "_choice_value"
          _ -> "choice_value"
        }
        let expected =
          choice.code
          <> case target.min == 0 {
            True -> " or omitted"
            False -> ""
          }
        let none = case target.min {
          0 -> "Ok(Nil)"
          _ ->
            "Error([decode.DecodeError(expected: \""
            <> expected
            <> "\", found: \"omitted\", path: "
            <> wrong_path
            <> ")])"
        }
        let expression =
          "case "
          <> source
          <> "."
          <> source_field_name
          <> " { None -> "
          <> none
          <> " Some("
          <> constructor
          <> "("
          <> choice_value_pattern
          <> ")) -> "
          <> nested
          <> " Some(_) -> Error([decode.DecodeError(expected: \""
          <> expected
          <> "\", found: \"another "
          <> base_json_name
          <> " type\", path: "
          <> wrong_path
          <> ")]) }"
        [
          #("field_constraint_" <> int.to_string(field_index), expression),
          ..results
        ]
      }
    }
  })
  |> list.reverse
  |> validation_results_source
}

fn slice_converter_name(target_type: String, base_type: String) -> String {
  codegen_helpers.to_snake_case(target_type)
  <> "_slice_try_from_"
  <> { base_type |> string.replace("ct.", "") |> codegen_helpers.to_snake_case }
}

fn slice_converter_source(
  context: DecodeContext,
  parent_type: String,
  group: codegen_helpers.Element,
  root: codegen_helpers.Element,
) -> String {
  let #(_, _, json_name, _, base_type) =
    profile_element_names(context, parent_type, group)
  let #(_, _, _, _, target_type) =
    profile_element_names(context, parent_type, root)
  let assert Ok(target_fields) =
    fields_for_profile_type(context, target_type, "")
  let assert Ok(discriminator) =
    list.find(target_fields, fn(field) {
      dict.has_key(context.slice_type_overrides, field.id)
    })
  case
    direct_slice_record_expression(
      context,
      target_type,
      base_type,
      discriminator,
      "source",
    )
  {
    Ok(_) -> ""
    Error(_) -> {
      let #(_, _, _, discriminator_field, discriminator_type) =
        profile_element_names(context, target_type, discriminator)
      let record_converter =
        codegen_helpers.to_snake_case(target_type)
        <> "_try_from_"
        <> {
          base_type
          |> string.replace("ct.", "")
          |> codegen_helpers.to_snake_case
        }
      "fn "
      <> slice_converter_name(target_type, base_type)
      <> "(source: "
      <> base_type
      <> ", index: Int, "
      <> discriminator_field
      <> " "
      <> discriminator_field
      <> ": "
      <> discriminator_type
      <> ") -> Result("
      <> target_type
      <> ", List(decode.DecodeError)) {\n  case "
      <> slice_record_validation(
        context,
        target_type,
        base_type,
        "source",
        json_name,
      )
      <> " {\n    Error(errors) -> Error(errors)\n    Ok(_) ->\n      case "
      <> record_converter
      <> "(source, "
      <> discriminator_field
      <> ") {\n        Ok(value) -> Ok(value)\n        Error(reason) -> Error([decode.DecodeError(expected: \""
      <> target_type
      <> "\", found: reason, path: [\""
      <> json_name
      <> "\", int.to_string(index)])])\n      }\n  }\n}\n\n"
    }
  }
}

fn resource_slice_match(
  context: DecodeContext,
  parent_type: String,
  group: codegen_helpers.Element,
  root: codegen_helpers.Element,
  source: String,
  constructor: String,
) -> ResourceSliceMatch {
  let #(_, _, _, _, target_type) =
    profile_element_names(context, parent_type, root)
  let #(_, _, _, _, base_type) =
    profile_element_names(context, parent_type, group)
  case dict.get(context.slice_type_overrides, root.id) {
    Ok(_) -> {
      let match = slice_match(context, parent_type, group, root, source)
      ResourceSliceMatch(
        expression: match.expression,
        returns_found: match.returns_found,
        selected: "Ok(" <> constructor <> "(matched))",
        fallible: match.returns_found,
      )
    }
    Error(_) -> {
      let assert Ok(target_fields) =
        fields_for_profile_type(context, target_type, "")
      let assert Ok(discriminator) =
        list.find(target_fields, fn(field) {
          dict.has_key(context.slice_type_overrides, field.id)
        })
      let assert Ok(FixedSliceType(discriminator_type)) =
        dict.get(context.slice_type_overrides, discriminator.id)
      let #(_, _, _, discriminator_field, _) =
        profile_element_names(context, target_type, discriminator)
      let assert Ok(#(system, code)) =
        discriminator_literals(context, discriminator)
      let discriminator_value = source <> "." <> discriminator_field
      let discriminator_value = case
        discriminator.base.min,
        discriminator.base.max
      {
        0, "1" -> "value"
        _, _ -> discriminator_value
      }
      let assert Ok(call) =
        codegen_slice_complex_type.discriminator_from_base_call(
          discriminator_type,
          discriminator_value,
          system,
          code,
        )
      let #(expression, returns_found) = case call {
        codegen_slice_complex_type.ResultDiscriminatorCall(expression) -> #(
          expression,
          False,
        )
        codegen_slice_complex_type.FoundDiscriminatorCall(expression) -> #(
          expression,
          True,
        )
      }
      let expression = case discriminator.base.min, discriminator.base.max {
        0, "1" ->
          "case "
          <> source
          <> "."
          <> discriminator_field
          <> " { Some(value) -> "
          <> expression
          <> " None -> Error(Nil) }"
        _, _ -> expression
      }
      case
        direct_slice_record_expression(
          context,
          target_type,
          base_type,
          discriminator,
          source,
        )
      {
        Ok(record) ->
          ResourceSliceMatch(
            expression:,
            returns_found:,
            selected: "Ok(" <> constructor <> "(" <> record <> "))",
            fallible: returns_found,
          )
        Error(_) -> {
          let converter = slice_converter_name(target_type, base_type)
          let selected =
            converter
            <> "("
            <> source
            <> ", index, matched) |> result.map("
            <> constructor
            <> ")"
          ResourceSliceMatch(
            expression:,
            returns_found:,
            selected:,
            fallible: True,
          )
        }
      }
    }
  }
}

fn parsed_slice_constructor(
  parent_type: String,
  group: codegen_helpers.Element,
  root: codegen_helpers.Element,
) -> String {
  let assert Ok(field_part) = group.path |> string.split(".") |> list.last
  parent_type
  <> "Parsed"
  <> {
    field_part
    |> string.replace("[x]", "")
    |> codegen_helpers.escape_field_name
    |> string.capitalise
  }
  <> "Slice"
  <> slice_name_type_part(root)
}

fn slice_classifier_case(
  context: DecodeContext,
  parent_type: String,
  group: codegen_helpers.Element,
  root: codegen_helpers.Element,
  value: String,
  unmatched: String,
  aggregate: Bool,
  indexed: Bool,
) -> String {
  let constructor = case aggregate {
    True -> {
      let #(_, _, _, _, root_type) =
        profile_element_names(context, parent_type, root)
      aggregate_slice_constructor(
        aggregate_slice_type_name(slice_group_type_name(parent_type, group), {
          let #(_, _, _, _, base_type) =
            profile_element_names(context, parent_type, group)
          base_type
        }),
        option.unwrap(root.slice_name, ""),
        root_type,
      )
    }
    False -> parsed_slice_constructor(parent_type, group, root)
  }
  let match =
    resource_slice_match(context, parent_type, group, root, value, constructor)
  case match.returns_found {
    False ->
      "case "
      <> match.expression
      <> " {\n          Ok(matched) -> "
      <> match.selected
      <> "\n          Error(_) -> "
      <> unmatched
      <> "\n        }"
    True -> {
      let #(_, _, json_name, _, _) =
        profile_element_names(context, parent_type, group)
      "case "
      <> match.expression
      <> " {\n          ct.FoundValid(matched) -> "
      <> match.selected
      <> "\n          ct.FoundInvalid(reason) -> Error([decode.DecodeError(expected: \""
      <> {
        let #(_, _, _, _, target_type) =
          profile_element_names(context, parent_type, root)
        target_type
      }
      <> "\", found: reason, path: "
      <> slice_path(json_name, indexed)
      <> ")])\n          ct.NotFound -> "
      <> unmatched
      <> "\n        }"
    }
  }
}

fn slice_cardinality_expression(
  root: codegen_helpers.Element,
  values: String,
  json_name: String,
  aggregate: Bool,
) -> String {
  let slice_name = option.unwrap(root.slice_name, json_name)
  let missing = case aggregate {
    True ->
      "Error([decode.DecodeError(expected: \"at least "
      <> int.to_string(root.min)
      <> " "
      <> json_name
      <> "\", found: int.to_string(list.length("
      <> values
      <> ")) <> \" "
      <> json_name
      <> "s\", path: [\""
      <> json_name
      <> "\"])])"
    False ->
      "Error([decode.DecodeError(expected: \""
      <> int.to_string(root.min)
      <> " "
      <> slice_name
      <> " "
      <> json_name
      <> case root.min == 1 {
        True -> "\", found: \"0 " <> slice_name <> " " <> json_name <> "s\""
        False ->
          "s\", found: \"fewer than "
          <> int.to_string(root.min)
          <> " "
          <> slice_name
          <> " "
          <> json_name
          <> "s\""
      }
      <> ", path: [\""
      <> json_name
      <> "\", \""
      <> slice_name
      <> "\"])])"
  }
  case root.min, root.max {
    0, "1" ->
      "case " <> values <> " { [value, ..] -> Ok(Some(value)) [] -> Ok(None) }"
    1, "1" ->
      "case "
      <> values
      <> " { [value, ..] -> Ok(value) [] -> "
      <> missing
      <> " }"
    0, "*" -> "Ok(" <> values <> ")"
    1, "*" ->
      "case "
      <> values
      <> " { [first, ..rest] -> Ok(ct.List1(first:, rest:)) [] -> "
      <> missing
      <> " }"
    2, "*" ->
      "case "
      <> values
      <> " { [first, second, ..rest] -> Ok(ct.List2(first:, second:, rest:)) _ -> "
      <> missing
      <> " }"
    3, "*" ->
      "case "
      <> values
      <> " { [first, second, third, ..rest] -> Ok(ct.List3(first:, second:, third:, rest:)) _ -> "
      <> missing
      <> " }"
    _, _ -> panic as "unsupported slice cardinality"
  }
}

fn slice_cardinality_placeholder(
  root: codegen_helpers.Element,
  placeholder: String,
) -> String {
  case root.min, root.max {
    0, "1" -> "None"
    1, "1" -> placeholder
    0, "*" -> "[]"
    1, "*" -> "ct.List1(first: " <> placeholder <> ", rest: [])"
    2, "*" ->
      "ct.List2(first: "
      <> placeholder
      <> ", second: "
      <> placeholder
      <> ", rest: [])"
    3, "*" ->
      "ct.List3(first: "
      <> placeholder
      <> ", second: "
      <> placeholder
      <> ", third: "
      <> placeholder
      <> ", rest: [])"
    _, _ -> panic as "unsupported slice cardinality"
  }
}

fn base_slice_placeholder(context: DecodeContext, base_type: String) -> String {
  case fields_for_profile_type(context, base_type, "") {
    Ok(_) -> profile_record_placeholder(context, base_type)
    Error(_) -> {
      let parts = string.split(base_type, ".")
      case parts {
        [module, type_] ->
          module <> "." <> codegen_helpers.to_snake_case(type_) <> "_new()"
        _ -> codegen_helpers.to_snake_case(base_type) <> "_new()"
      }
    }
  }
}

fn slice_fold_source(
  context: DecodeContext,
  parent_type: String,
  group: codegen_helpers.Element,
  roots: List(codegen_helpers.Element),
  aggregate: Option(#(List(codegen_helpers.Element), Int)),
) -> SliceGroupDecode {
  let #(_, field_path, json_name, field_name, base_type) =
    profile_element_names(context, parent_type, group)
  let use_profile_slice_base = list.contains(context.type_order, field_path)
  let base_decoder = case use_profile_slice_base {
    True -> codegen_helpers.to_snake_case(base_type) <> "_decoder()"
    False ->
      case group.type_ {
        [type_] -> {
          let all_parts =
            group.base.path
            |> string.replace("[x]", "")
            |> string.split(".")
          codegen_decode.string_to_decoder_type(
            type_.code,
            all_parts,
            "r4",
            group,
            codegen_helpers.Resources,
          )
        }
        [] ->
          codegen_helpers.link_type_from(
            group.content_reference,
            context.resource_type,
          )
          |> codegen_helpers.to_snake_case
          |> fn(name) { name <> "_decoder()" }
        _ -> panic as "sliced group is unexpectedly a choice"
      }
  }
  let indexed =
    list.any(roots, fn(root) {
      resource_slice_match(
        context,
        parent_type,
        group,
        root,
        field_name,
        "Slice",
      ).fallible
    })
  let is_aggregate = aggregate != None
  let natural_group_type = slice_group_type_name(parent_type, group)
  let group_type = case aggregate {
    Some(_) -> aggregate_slice_type_name(natural_group_type, base_type)
    None -> natural_group_type
  }
  let accumulator_type = group_type <> "SliceAccumulator"
  let parsed_type = case is_aggregate {
    True -> group_type
    False -> {
      let assert Ok(field_part) = group.path |> string.split(".") |> list.last
      parent_type
      <> "Parsed"
      <> {
        field_part
        |> string.replace("[x]", "")
        |> codegen_helpers.escape_field_name
        |> string.capitalise
      }
      <> "Slice"
    }
  }
  let assert Some(slicing) = group.slicing
  let unmatched = case slicing.rules {
    "open" | "openAtEnd" -> {
      let constructor = case is_aggregate {
        True -> aggregate_slice_constructor(group_type, "Open", base_type)
        False -> parsed_type <> "Open"
      }
      "Ok(" <> constructor <> "(" <> field_name <> "))"
    }
    "closed" ->
      "Error(["
      <> slice_decode_error(
        "one permitted slice",
        "unmatched element",
        json_name,
        indexed,
      )
      <> "])"
    rules -> panic as { "unknown slicing rule " <> rules }
  }
  let classifier =
    roots
    |> list.reverse
    |> list.fold(unmatched, fn(unmatched, root) {
      slice_classifier_case(
        context,
        parent_type,
        group,
        root,
        field_name,
        unmatched,
        is_aggregate,
        indexed,
      )
    })
  let initial_values = case is_aggregate {
    True -> "[]"
    False -> {
      let values = list.map(roots, fn(_) { "[]" })
      let values = case slicing.rules {
        "open" | "openAtEnd" -> list.append(values, ["[]"])
        "closed" -> values
        _ -> values
      }
      string.join(values, ", ")
    }
  }
  let accumulate_cases = case is_aggregate {
    True ->
      "          Ok(accumulator), Ok(value) ->\n            Ok("
      <> accumulator_type
      <> "([value, ..accumulator.values]))\n"
    False -> {
      let named =
        roots
        |> list.map(fn(root) {
          let #(_, _, _, root_field, _) =
            profile_element_names(context, parent_type, root)
          "          Ok(accumulator), Ok("
          <> parsed_slice_constructor(parent_type, group, root)
          <> "(value)) ->\n            Ok("
          <> accumulator_type
          <> "(..accumulator, "
          <> root_field
          <> ": [value, ..accumulator."
          <> root_field
          <> "]))\n"
        })
        |> string.concat
      let open = case slicing.rules {
        "open" | "openAtEnd" ->
          "          Ok(accumulator), Ok("
          <> parsed_type
          <> "Open(value)) ->\n            Ok("
          <> accumulator_type
          <> "(..accumulator, open: [value, ..accumulator.open]))\n"
        "closed" -> ""
        _ -> ""
      }
      named <> open
    }
  }
  let base_values = field_name <> "_base_values"
  let accumulator = field_name <> "_accumulator"
  let result_name = field_name <> "_slices"
  let fold_function = case indexed {
    True -> "list.index_fold"
    False -> "list.fold"
  }
  let index_parameter = case indexed {
    True -> ", index"
    False -> ""
  }
  let fold_source =
    "  use "
    <> base_values
    <> " <- decode.optional_field(\""
    <> json_name
    <> "\", [], decode.list("
    <> base_decoder
    <> "))\n  let "
    <> accumulator
    <> ": Result("
    <> accumulator_type
    <> ", List(decode.DecodeError)) =\n    "
    <> fold_function
    <> "(\n      "
    <> base_values
    <> ",\n      Ok("
    <> accumulator_type
    <> "("
    <> initial_values
    <> ")),\n      fn(accumulator_result, "
    <> field_name
    <> index_parameter
    <> ") {\n        let parsed: Result("
    <> parsed_type
    <> ", List(decode.DecodeError)) =\n          "
    <> classifier
    <> "\n        case accumulator_result, parsed {\n"
    <> accumulate_cases
    <> "          Ok(_), Error(errors) -> Error(errors)\n          Error(errors), Ok(_) -> Error(errors)\n          Error(errors), Error(new_errors) -> Error(list.append(new_errors, errors))\n        }\n      },\n    )\n"
  case aggregate {
    Some(#(_, minimum)) -> {
      let cardinality =
        slice_cardinality_expression(
          codegen_helpers.Element(..group, min: minimum),
          "list.reverse(values)",
          json_name,
          True,
        )
      let result_source =
        "  let "
        <> result_name
        <> " = case "
        <> accumulator
        <> " {\n    Ok("
        <> accumulator_type
        <> "(values:)) -> "
        <> cardinality
        <> "\n    Error(errors) -> Error(errors)\n  }\n"
      let open_constructor =
        aggregate_slice_constructor(group_type, "Open", base_type)
      let open_placeholder =
        open_constructor
        <> "("
        <> base_slice_placeholder(context, base_type)
        <> ")"
      let placeholder =
        slice_cardinality_placeholder(
          codegen_helpers.Element(..group, min: minimum),
          open_placeholder,
        )
      SliceGroupDecode(
        source: fold_source <> result_source,
        result_name:,
        success_pattern: "Ok(" <> field_name <> ")",
        placeholder_fields: [#(field_name, placeholder)],
      )
    }
    None -> {
      let cardinalities =
        roots
        |> list.map(fn(root) {
          let #(_, _, _, root_field, _) =
            profile_element_names(context, parent_type, root)
          #(
            root,
            root_field,
            slice_cardinality_expression(
              root,
              "list.reverse(accumulator." <> root_field <> ")",
              json_name,
              False,
            ),
          )
        })
      let result_bindings =
        cardinalities
        |> list.map(fn(item) {
          "      let " <> item.1 <> " = " <> item.2 <> "\n"
        })
        |> string.concat
      let result_values = cardinalities |> list.map(fn(item) { item.1 })
      let success_pattern =
        result_values |> list.map(fn(value) { "Ok(" <> value <> ")" })
      let result_case = case result_values {
        [only] ->
          "      case "
          <> only
          <> " {\n        Ok("
          <> only
          <> ") -> Ok("
          <> group_type
          <> "Slices("
          <> only
          <> ":,"
          <> case slicing.rules {
            "open" | "openAtEnd" -> " open: list.reverse(accumulator.open),"
            _ -> ""
          }
          <> "))\n        Error(errors) -> Error(errors)\n      }\n"
        _ ->
          "      case "
          <> string.join(result_values, ", ")
          <> " {\n        "
          <> string.join(success_pattern, ", ")
          <> " -> Ok("
          <> group_type
          <> "Slices("
          <> {
            result_values
            |> list.map(fn(value) { value <> ":" })
            |> string.join(", ")
          }
          <> case slicing.rules {
            "open" | "openAtEnd" -> ", open: list.reverse(accumulator.open)"
            _ -> ""
          }
          <> "))\n        "
          <> { result_values |> list.map(fn(_) { "_" }) |> string.join(", ") }
          <> " -> Error(list.flatten(["
          <> {
            result_values
            |> list.map(fn(value) { "slice_acc_errors(" <> value <> ")" })
            |> string.join(", ")
          }
          <> "]))\n      }\n"
      }
      let result_source = case
        list.all(roots, fn(root) { root.min == 0 && root.max == "*" })
      {
        True ->
          "  let "
          <> result_name
          <> " = case "
          <> accumulator
          <> " {\n    Ok(accumulator) -> Ok("
          <> group_type
          <> "Slices("
          <> {
            result_values
            |> list.map(fn(value) {
              value <> ": list.reverse(accumulator." <> value <> ")"
            })
            |> string.join(", ")
          }
          <> case slicing.rules {
            "open" | "openAtEnd" -> ", open: list.reverse(accumulator.open)"
            _ -> ""
          }
          <> "))\n    Error(errors) -> Error(errors)\n  }\n"
        False ->
          "  let "
          <> result_name
          <> " = case "
          <> accumulator
          <> " {\n    Ok(accumulator) -> {\n"
          <> result_bindings
          <> result_case
          <> "    }\n    Error(errors) -> Error(errors)\n  }\n"
      }
      let success_fields =
        result_values
        |> list.map(fn(value) { value <> ":" })
        |> string.join(", ")
      let success_fields = case slicing.rules {
        "open" | "openAtEnd" -> success_fields <> ", open: " <> field_name
        _ -> success_fields
      }
      let placeholder_fields =
        cardinalities
        |> list.map(fn(item) {
          let #(root, root_field, _) = item
          let match = slice_match(context, parent_type, group, root, field_name)
          #(
            root_field,
            slice_cardinality_placeholder(
              root,
              slice_placeholder(context, root, match),
            ),
          )
        })
      let placeholder_fields = case slicing.rules {
        "open" | "openAtEnd" -> [#(field_name, "[]"), ..placeholder_fields]
        _ -> placeholder_fields
      }
      SliceGroupDecode(
        source: fold_source <> result_source,
        result_name:,
        success_pattern: "Ok("
          <> group_type
          <> "Slices("
          <> success_fields
          <> "))",
        placeholder_fields:,
      )
    }
  }
}

fn slice_group_bindings(
  context: DecodeContext,
  parent_type: String,
  group: codegen_helpers.Element,
  roots: List(codegen_helpers.Element),
  aggregate: Option(#(List(codegen_helpers.Element), Int)),
) -> SliceGroupDecode {
  slice_fold_source(context, parent_type, group, roots, aggregate)
}

fn record_decoder_from_fields(
  context: DecodeContext,
  target_type: String,
  fields: List(codegen_helpers.Element),
  resource_type: Option(String),
  omit_fixed: Bool,
) -> String {
  let constructor_fields =
    profile_fields(fields)
    |> list.filter(fn(element) {
      !omit_fixed || { element.fixed_code == None && element.fixed_uri == None }
    })
  let slice_groups =
    fields
    |> list.filter_map(fn(group) {
      let roots =
        list.filter(fields, fn(candidate) {
          let prefix = group.id <> ":"
          candidate.path == group.path
          && candidate.slice_name != None
          && string.starts_with(candidate.id, prefix)
          && !string.contains(
            string.drop_start(candidate.id, string.length(prefix)),
            ".",
          )
        })
      let is_choice = string.contains(group.id, "[x]")
      case
        group.slicing,
        group.base.max,
        list.length(group.type_),
        is_choice,
        roots
      {
        Some(_), base_max, type_count, False, [_, ..]
          if base_max != "1" && type_count <= 1
        -> Ok(#(group.id, roots))
        _, _, _, _, _ -> Error(Nil)
      }
    })
    |> dict.from_list
  let slice_root_ids =
    slice_groups
    |> dict.values
    |> list.flatten
    |> list.map(fn(root) { root.id })
  let #(bindings, choices, slice_decodes) =
    list.fold(fields, #("", "", []), fn(acc, element) {
      let #(bindings, choices, slice_decodes) = acc
      case dict.get(slice_groups, element.id) {
        Ok(roots) -> {
          let aggregate = aggregate_value_slice_roots(element, fields)
          let is_extension =
            list.any(element.type_, fn(type_) { type_.code == "Extension" })
          case is_extension {
            True -> #(
              bindings
                <> old_slice_group_bindings(
                context,
                target_type,
                element,
                roots,
                aggregate,
              ),
              choices,
              slice_decodes,
            )
            False -> {
              let slice_decode =
                slice_group_bindings(
                  context,
                  target_type,
                  element,
                  roots,
                  aggregate,
                )
              #(bindings <> slice_decode.source, choices, [
                slice_decode,
                ..slice_decodes
              ])
            }
          }
        }
        Error(_) ->
          case
            list.contains(slice_root_ids, element.id),
            list.any(constructor_fields, fn(field) { field.id == element.id }),
            omit_fixed
            && { element.fixed_code != None || element.fixed_uri != None }
          {
            True, _, _ | _, False, False -> #(bindings, choices, slice_decodes)
            _, _, True -> {
              let assert Ok(json_name) =
                element.path |> string.split(".") |> list.last
              let variable =
                json_name
                |> codegen_helpers.escape_field_name
                |> codegen_helpers.to_snake_case
              #(
                bindings
                  <> "  use "
                  <> variable
                  <> "_fixed <- decode.field(\""
                  <> json_name
                  <> "\", decode.string)\n",
                choices,
                slice_decodes,
              )
            }
            _, True, False -> {
              let #(_, _, _, field_name, _) =
                profile_element_names(context, target_type, element)
              #(
                bindings
                  <> "  use "
                  <> field_name
                  <> " <- "
                  <> field_decoder_expression(context, target_type, element)
                  <> "\n",
                choices
                  <> case element.type_ {
                  [_, _, ..] ->
                    choice_decoder_source(context, target_type, element)
                  _ -> ""
                },
                slice_decodes,
              )
            }
          }
      }
    })
  let placeholder_fields =
    slice_decodes
    |> list.flat_map(fn(slice_decode) { slice_decode.placeholder_fields })
    |> dict.from_list
  let placeholder_arguments =
    list.fold(constructor_fields, "", fn(arguments, element) {
      let #(_, _, _, field_name, _) =
        profile_element_names(context, target_type, element)
      arguments
      <> "    "
      <> field_name
      <> case dict.get(placeholder_fields, field_name) {
        Ok(value) -> ": " <> value
        Error(_) -> ":"
      }
      <> ",\n"
    })
  let arguments =
    list.fold(constructor_fields, "", fn(arguments, element) {
      let #(_, _, _, field_name, _) =
        profile_element_names(context, target_type, element)
      arguments <> "    " <> field_name <> ":,\n"
    })
  let placeholder =
    "  let placeholder = "
    <> target_type
    <> "(\n"
    <> placeholder_arguments
    <> "  )\n"
  let fixed_guards = case omit_fixed {
    False -> ""
    True ->
      list.fold(fields, "", fn(source, element) {
        case element.fixed_code, element.fixed_uri {
          None, None -> source
          fixed_code, fixed_uri -> {
            let assert Ok(json_name) =
              element.path |> string.split(".") |> list.last
            let variable =
              json_name
              |> codegen_helpers.escape_field_name
              |> codegen_helpers.to_snake_case
            let fixed = case fixed_code, fixed_uri {
              Some(fixed), _ | _, Some(fixed) -> fixed
              _, _ -> ""
            }
            source
            <> "  use <- bool.guard("
            <> variable
            <> "_fixed != \""
            <> fixed
            <> "\", decode.failure(placeholder, \"fixed "
            <> json_name
            <> "\"))\n"
          }
        }
      })
  }
  let resource_guard = case resource_type {
    None -> ""
    Some(resource_type) ->
      "  use actual_resource_type <- decode.field(\"resourceType\", decode.string)\n  use <- bool.guard(actual_resource_type != \""
      <> resource_type
      <> "\", decode.failure(placeholder, \"resourceType\"))\n"
  }
  let result = case slice_decodes {
    [] -> "  decode.success(placeholder)\n"
    slice_decodes -> {
      let result_names =
        slice_decodes |> list.map(fn(slice_decode) { slice_decode.result_name })
      let success_patterns =
        slice_decodes
        |> list.map(fn(slice_decode) { slice_decode.success_pattern })
      let failure_patterns =
        slice_decodes |> list.map(fn(_) { "_" }) |> string.join(", ")
      "  case "
      <> string.join(result_names, ", ")
      <> " {\n    "
      <> string.join(success_patterns, ", ")
      <> " -> decode.success("
      <> target_type
      <> "(\n"
      <> arguments
      <> "    ))\n    "
      <> failure_patterns
      <> " ->\n      decode.failure(placeholder, \""
      <> target_type
      <> " slices\")\n      |> decode.map_errors(fn(_) { list.flatten(["
      <> {
        result_names
        |> list.map(fn(name) { "slice_acc_errors(" <> name <> ")" })
        |> string.join(", ")
      }
      <> "]) })\n  }\n"
    }
  }
  choices
  <> "pub fn "
  <> codegen_helpers.to_snake_case(target_type)
  <> "_decoder() -> Decoder("
  <> target_type
  <> ") {\n  use <- decode.recursive\n"
  <> bindings
  <> placeholder
  <> fixed_guards
  <> resource_guard
  <> result
  <> "}\n\n"
}

fn extension_value_classifier(
  function_prefix: String,
  extension_name: String,
  field: codegen_helpers.Element,
  expected_url: String,
  valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
) -> #(String, String) {
  let field_name = extension_field_name(field) |> codegen_helpers.to_snake_case
  let function_name =
    codegen_helpers.to_snake_case(function_prefix)
    <> "_"
    <> field_name
    <> "_from_extension"
  let #(target_type, cases) = case field.type_ {
    [type_] -> {
      let #(target_type, _) =
        codegen_helpers.string_to_type(
          type_.code,
          [extension_name, field_name],
          field,
          codegen_helpers.Resources,
          valueset_acc,
        )
      let conversion =
        required_binding_conversion(field, type_.code, "value")
        |> option.unwrap(ConversionExpression("value", "", False))
      let valid = case conversion.fallible {
        True ->
          "case "
          <> conversion.expression
          <> " { Ok(value) -> ct.FoundValid(value) Error(_) -> ct.FoundInvalid(\"invalid extension value\") }"
        False -> "ct.FoundValid(" <> conversion.expression <> ")"
      }
      #(
        target_type,
        "ct.ExtSimple(ct.ExtensionValue"
          <> codegen_helpers.to_camel_case(type_.code)
          <> "(value)) -> "
          <> valid,
      )
    }
    types -> {
      let target_type = extension_name <> string.capitalise(field_name)
      let cases =
        types
        |> list.map(fn(type_) {
          "ct.ExtSimple(ct.ExtensionValue"
          <> codegen_helpers.to_camel_case(type_.code)
          <> "(value)) -> ct.FoundValid(ct."
          <> target_type
          <> string.capitalise(type_.code)
          <> "(value))"
        })
        |> string.join(" ")
      #("ct." <> target_type, cases)
    }
  }
  #(
    function_name,
    "fn "
      <> function_name
      <> "(extension: ct.Extension) -> ct.Found("
      <> target_type
      <> ") {\n  case extension.url == \""
      <> expected_url
      <> "\" {\n    False -> ct.NotFound\n    True -> case extension.ext {\n      "
      <> cases
      <> "\n      _ -> ct.FoundInvalid(\"extension "
      <> expected_url
      <> " has invalid value\")\n    }\n  }\n}\n\n",
  )
}

fn extension_field_cardinality(
  field: codegen_helpers.Element,
  values: String,
) -> String {
  case field.min, field.max {
    0, "1" ->
      "case " <> values <> " { [] -> None [value] -> Some(value) _ -> panic }"
    1, "1" -> "case " <> values <> " { [value] -> value _ -> panic }"
    0, "*" -> values
    1, "*" ->
      "case "
      <> values
      <> " { [first, ..rest] -> ct.List1(first:, rest:) _ -> panic }"
    2, "*" ->
      "case "
      <> values
      <> " { [first, second, ..rest] -> ct.List2(first:, second:, rest:) _ -> panic }"
    3, "*" ->
      "case "
      <> values
      <> " { [first, second, third, ..rest] -> ct.List3(first:, second:, third:, rest:) _ -> panic }"
    0, _ -> values
    _, _ ->
      panic as {
        "unsupported extension cardinality "
        <> field.id
        <> " "
        <> int.to_string(field.min)
        <> ".."
        <> field.max
      }
  }
}

fn extension_classifier_source(
  profile_prefix: String,
  url: String,
  extension: ExtensionDefinition,
  valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
) -> String {
  let function_name =
    codegen_helpers.to_snake_case(profile_prefix <> "_" <> extension.name)
    <> "_from_extension"
  let function_prefix = profile_prefix <> "_" <> extension.name
  case extension.kind {
    SimpleExtension(value) -> {
      let #(value_function, value_source) =
        extension_value_classifier(
          function_prefix,
          extension.name,
          value,
          url,
          valueset_acc,
        )
      value_source
      |> string.replace("fn " <> value_function, "fn " <> function_name)
    }
    ComplexExtension(fields) -> {
      let classifiers =
        list.map(fields, fn(field) {
          let assert Ok(field_url) = field.id |> string.split(".") |> list.last
          extension_value_classifier(
            function_prefix,
            extension.name,
            field,
            field_url,
            valueset_acc,
          )
        })
      let #(body, _) =
        fields
        |> list.zip(classifiers)
        |> list.reverse
        |> list.fold(
          #(
            "ct.FoundValid(ct."
              <> extension.name
              <> "("
              <> {
              fields
              |> list.map(fn(field) {
                let name =
                  extension_field_name(field)
                  |> codegen_helpers.to_snake_case
                name <> ":"
              })
              |> string.join(", ")
            }
              <> "))",
            False,
          ),
          fn(acc, item) {
            let #(body, body_uses_children) = acc
            let #(field, classifier) = item
            let #(classifier_name, _) = classifier
            let field_name =
              extension_field_name(field) |> codegen_helpers.to_snake_case
            let minimum = field.min
            let remaining_name = case body_uses_children {
              True -> "children"
              False -> "_children"
            }
            let valid_values =
              "{\n          let "
              <> field_name
              <> " = "
              <> extension_field_cardinality(field, "values")
              <> "\n          "
              <> body
              <> "\n        }"
            let valid_values = case field.max {
              "*" -> valid_values
              maximum ->
                "case list.length(values) <= "
                <> maximum
                <> " {\n        False -> ct.FoundInvalid(\"maximum cardinality exceeded for extension "
                <> field_name
                <> "\")\n        True -> "
                <> valid_values
                <> "\n      }"
            }
            #(
              "case find_at_least_n_elts_and_rest_found(in: children, items_that: "
                <> classifier_name
                <> ", at_least: "
                <> int.to_string(minimum)
                <> ") {\n      ct.FoundInvalid(reason) -> ct.FoundInvalid(reason)\n      ct.NotFound -> ct.FoundInvalid(\"required extension "
                <> field_name
                <> "\")\n      ct.FoundValid(#(values, "
                <> remaining_name
                <> ")) -> "
                <> valid_values
                <> "\n    }",
              True,
            )
          },
        )
      classifiers
      |> list.fold("", fn(source, classifier) { source <> classifier.1 })
      |> fn(classifier_sources) {
        classifier_sources
        <> "fn "
        <> function_name
        <> "(extension: ct.Extension) -> ct.Found(ct."
        <> extension.name
        <> ") {\n  case extension.url == \""
        <> url
        <> "\" {\n    False -> ct.NotFound\n    True -> case extension.ext {\n      ct.ExtComplex(children) -> "
        <> body
        <> "\n      _ -> ct.FoundInvalid(\"extension should contain child extensions\")\n    }\n  }\n}\n\n"
      }
    }
  }
}

fn normalized_type_name(name: String) -> String {
  name |> string.replace("_", "") |> string.lowercase
}

fn current_type_for_profile_type(
  context: DecodeContext,
  profile_type: String,
  target_type: String,
) -> Result(String, Nil) {
  let target_type = normalized_type_name(target_type)
  list.find(context.type_order, fn(current_type) {
    profile_type_name(context, current_type, profile_type)
    |> normalized_type_name
    |> fn(name) { name == target_type }
  })
}

fn conversion_dependencies(
  context: DecodeContext,
  profile_type: String,
  current_type: String,
) -> List(String) {
  let assert Ok(fields) = dict.get(context.type_fields, current_type)
  let parent_type = profile_type_name(context, current_type, profile_type)
  let source_profile_fields = case
    list.find(context.snapshot_elements, fn(element) {
      case
        element.slice_name,
        string.ends_with(element.path, "[x]"),
        element.type_
      {
        Some(_), False, [codegen_helpers.Type(code: "BackboneElement", ..)]
        | Some(_), False, [codegen_helpers.Type(code: "Element", ..)]
        | Some(_), False, []
        -> {
          let assert [_, ..rest] =
            element.id
            |> string.replace("-", "")
            |> string.replace(":", ".")
            |> string.split(".")
          string.join([context.profile_prefix, ..rest], "_") == current_type
        }
        _, _, _ -> False
      }
    })
  {
    Error(_) -> None
    Ok(slice_root) -> {
      let assert [_, ..rest] = slice_root.path |> string.split(".")
      let slice_base_current_type =
        string.join([context.profile_prefix, ..rest], "_")
      case list.contains(context.type_order, slice_base_current_type) {
        False -> None
        True -> {
          let source_type =
            profile_type_name(context, slice_base_current_type, profile_type)
          case fields_for_profile_type(context, source_type, "") {
            Ok(source_fields) -> Some(#(source_type, source_fields))
            Error(_) -> None
          }
        }
      }
    }
  }
  fields
  |> profile_fields
  |> list.filter_map(fn(element) {
    let #(_, _, _, _, field_type) =
      profile_element_names(context, parent_type, element)
    let source_field_type = case source_profile_fields {
      None -> None
      Some(#(source_type, source_fields)) ->
        source_fields
        |> list.find(fn(source_element) {
          source_element.slice_name == None
          && source_element.path == element.path
        })
        |> result.map(fn(source_element) {
          let #(_, _, _, _, source_field_type) =
            profile_element_names(context, source_type, source_element)
          source_field_type
        })
        |> option.from_result
    }
    case element.type_, source_field_type == Some(field_type) {
      _, True | [_, _, ..], _ -> Error(Nil)
      _, False ->
        current_type_for_profile_type(context, profile_type, field_type)
    }
  })
}

fn conversion_types(
  context: DecodeContext,
  profile_type: String,
) -> List(String) {
  let selected_conversion_types =
    context.type_order
    |> list.flat_map(fn(parent_current_type) {
      let assert Ok(fields) = dict.get(context.type_fields, parent_current_type)
      let parent_type =
        profile_type_name(context, parent_current_type, profile_type)
      fields
      |> list.filter_map(fn(root) {
        case
          root.slice_name,
          dict.has_key(context.slice_type_overrides, root.id),
          profile_extension_definition(root, context.extensions)
        {
          Some(_), False, None -> {
            let #(_, _, _, _, target_type) =
              profile_element_names(context, parent_type, root)
            use target_current_type <- result.try(current_type_for_profile_type(
              context,
              profile_type,
              target_type,
            ))
            use target_fields <- result.try(fields_for_profile_type(
              context,
              target_type,
              "",
            ))
            use discriminator <- result.try(
              list.find(target_fields, fn(field) {
                dict.has_key(context.slice_type_overrides, field.id)
              }),
            )
            use group <- result.try(
              list.find(fields, fn(candidate) {
                candidate.path == root.path
                && candidate.slice_name == None
                && candidate.slicing != None
              }),
            )
            let #(_, _, _, _, base_type) =
              profile_element_names(context, parent_type, group)
            case
              direct_slice_record_expression(
                context,
                target_type,
                base_type,
                discriminator,
                "source",
              )
            {
              Ok(_) -> Error(Nil)
              Error(_) -> Ok(target_current_type)
            }
          }
          _, _, _ -> Error(Nil)
        }
      })
    })
  let seeds =
    list.filter(context.type_order, fn(current_type) {
      current_type != context.profile_prefix
      && list.contains(selected_conversion_types, current_type)
    })
  conversion_types_loop(
    context,
    profile_type,
    seeds,
    list.length(context.type_order),
  )
}

fn conversion_types_loop(
  context: DecodeContext,
  profile_type: String,
  needed: List(String),
  passes_left: Int,
) -> List(String) {
  case passes_left <= 0 {
    True -> needed
    False -> {
      let next =
        list.fold(needed, needed, fn(acc, current_type) {
          conversion_dependencies(context, profile_type, current_type)
          |> list.fold(acc, fn(acc, dependency) {
            case list.contains(acc, dependency) {
              True -> acc
              False -> [dependency, ..acc]
            }
          })
        })
      case list.length(next) == list.length(needed) {
        True -> next
        False ->
          conversion_types_loop(context, profile_type, next, passes_left - 1)
      }
    }
  }
}

pub fn generate_decoders(
  resource_type: String,
  snapshot_elements: List(codegen_helpers.Element),
  profile_prefix: String,
  profile_type: String,
  type_order: List(String),
  type_fields: dict.Dict(String, List(codegen_helpers.Element)),
  extensions: dict.Dict(String, ExtensionDefinition),
  slice_base_type_names: dict.Dict(String, String),
  slice_type_overrides: dict.Dict(String, SliceFieldType),
  type_slice_overrides: dict.Dict(String, SlicePlan),
  all_primitive_ext: Bool,
  valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
  base_elements: dict.Dict(String, codegen_helpers.Element),
) -> String {
  let context =
    DecodeContext(
      resource_type:,
      profile_prefix:,
      snapshot_elements:,
      type_order:,
      type_fields:,
      extensions:,
      slice_base_type_names:,
      slice_type_overrides:,
      type_slice_overrides:,
      all_primitive_ext:,
      valueset_acc:,
      base_elements:,
    )
  let extension_classifiers =
    context.extensions
    |> dict.to_list
    |> list.filter(fn(item) {
      list.any(snapshot_elements, fn(element) {
        list.any(element.type_, fn(type_) {
          type_.code == "Extension"
          && list.any(type_.profile, fn(url) { canonical_url(url) == item.0 })
        })
      })
    })
    |> list.sort(fn(a, b) { string.compare(a.0, b.0) })
    |> list.fold("", fn(source, item) {
      source
      <> extension_classifier_source(
        profile_prefix,
        item.0,
        item.1,
        valueset_acc,
      )
    })
  let conversion_types = conversion_types(context, profile_type)
  let conversions =
    list.fold(type_order, "", fn(source, current_type) {
      case list.contains(conversion_types, current_type) {
        False -> source
        True ->
          source
          <> {
            let assert Ok(fields) = dict.get(type_fields, current_type)
            let target_type =
              profile_type_name(context, current_type, profile_type)
            let choice_conversions =
              fields
              |> list.filter(fn(element) { list.length(element.type_) > 1 })
              |> list.fold("", fn(source, element) {
                source
                <> choice_conversion_source(context, target_type, element)
              })
            record_conversion_source(context, current_type, profile_type)
            <> choice_conversions
          }
      }
    })
  let decoders =
    list.fold(type_order, "", fn(source, current_type) {
      let assert Ok(fields) = dict.get(type_fields, current_type)
      let target_type = profile_type_name(context, current_type, profile_type)
      let omit_fixed =
        list.any(fields, fn(field) {
          field.fixed_code != None || field.fixed_uri != None
        })
      source
      <> record_decoder_from_fields(
        context,
        target_type,
        fields,
        case current_type == profile_prefix {
          True -> Some(resource_type)
          False -> None
        },
        omit_fixed,
      )
    })
  extension_classifiers
  <> slice_support_types(context, profile_type)
  <> conversions
  <> decoders
}

pub fn generate_to_json(
  resource_type: String,
  snapshot_elements: List(codegen_helpers.Element),
  profile_prefix: String,
  profile_type: String,
  type_order: List(String),
  type_fields: dict.Dict(String, List(codegen_helpers.Element)),
  extensions: dict.Dict(String, ExtensionDefinition),
  slice_base_type_names: dict.Dict(String, String),
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
      let gleam_type = case dict.get(slice_base_type_names, gleam_type) {
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
      let fixed_json_always =
        fields
        |> list.filter_map(fn(element) {
          case element.fixed_code, element.fixed_uri {
            Some(value), _ | _, Some(value) -> {
              let json_name = profile_json_field_name(element, "")
              Ok(
                "#(\"" <> json_name <> "\", json.string(\"" <> value <> "\")),",
              )
            }
            _, _ -> Error(Nil)
          }
        })
        |> string.concat
      let fields =
        list.filter(fields, fn(element) {
          element.fixed_code == None && element.fixed_uri == None
        })
      let #(
        encoder_args,
        json_always,
        json_optional,
        choice_encoders,
        valueset_acc,
      ) =
        list.fold(
          fields,
          #("", fixed_json_always, "", "", valueset_acc),
          fn(acc, element) {
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
            let json_field_name = profile_json_field_name(element, last_part)
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
                slice_base_type_names,
                slice_type_overrides,
                valueset_acc,
              )
            let #(base_field_type, aggregate_encoder, valueset_acc) = case
              dict.get(aggregate_slice_groups, element.id)
            {
              Error(_) -> #(open_field_type, "", valueset_acc)
              Ok(#(roots, _)) -> {
                let aggregate_type =
                  aggregate_slice_type_name(choice_type, open_field_type)
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
                        slice_base_type_names,
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
                        aggregate_type,
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
                    aggregate_type,
                    "Open",
                    open_field_type,
                  )
                  <> "(value) -> "
                  <> open_call
                  <> "\n"
                #(
                  aggregate_type,
                  "pub fn "
                    <> codegen_helpers.to_snake_case(aggregate_type)
                    <> "_to_json(value: "
                    <> aggregate_type
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
            let card_min = case
              dict.has_key(aggregate_slice_groups, element.id)
            {
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
                  _ ->
                    codegen_helpers.to_snake_case(base_field_type) <> "_to_json"
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
                        slice_base_type_names,
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
                  [], lists ->
                    "list.flatten([" <> string.join(lists, ",") <> "])"
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
                  _ ->
                    codegen_helpers.to_snake_case(base_field_type) <> "_to_json"
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
                      codegen_helpers.to_snake_case(base_field_type)
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
          },
        )
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
