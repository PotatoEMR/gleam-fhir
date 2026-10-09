import codegen_bound_coding
import codegen_constraint
import codegen_decode
import codegen_helpers
import codegen_slice_complex_type
import codegen_to_json
import gleam/bool
import gleam/dict
import gleam/int
import gleam/json
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/set.{type Set}
import gleam/string

fn canonical_url(url: String) -> String {
  let assert [url, ..] = string.split(url, "|")
  url
}

fn type_slice_key(root_id: String, fhir_type: String) -> String {
  root_id <> "|" <> fhir_type
}

pub fn constructor_key(
  bucket: codegen_helpers.Category,
  type_name: String,
) -> String {
  let bucket = case string.starts_with(type_name, "ct.") {
    True -> codegen_helpers.ComplexTypes
    False -> bucket
  }
  let module = case bucket {
    codegen_helpers.ComplexTypes -> "complex_types."
    codegen_helpers.Resources -> "resources."
  }
  module <> string.replace(type_name, "ct.", "")
}

pub type ConstructorDefinition {
  RecordConstructor(
    bucket: codegen_helpers.Category,
    arguments: List(#(String, String)),
    fields: List(#(codegen_helpers.Element, String)),
  )
  ChoiceConstructor(
    bucket: codegen_helpers.Category,
    variant: String,
    payload_type: String,
  )
}

pub type ExtensionDefinition {
  ExtensionDefinition(
    name: String,
    url: String,
    kind: ExtensionKind,
    primitive_values: dict.Dict(String, PrimitiveExtensionValue),
  )
}

pub type PrimitiveExtensionValue {
  PrimitiveExtensionValue(name: String, elements: List(codegen_helpers.Element))
}

pub type ExtensionKind {
  SimpleExtension(codegen_helpers.Element)
  ComplexExtension(fields: List(codegen_helpers.Element), slicing_rules: String)
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
  id: Option(String),
  primitive_values: dict.Dict(String, PrimitiveExtensionValue),
  nested_definition: Option(ExtensionDefinition),
  datatype_types: dict.Dict(String, String),
) -> String {
  let assert Ok(extension_url) = field.id |> string.split(".") |> list.last
  case field.type_ {
    [codegen_helpers.Type(code: "Extension", ..)] -> {
      let assert Some(nested) = nested_definition
      profile_extension_encoder_call(
        codegen_helpers.ComplexTypes,
        ExtensionDefinition(..nested, url: extension_url),
        value,
        id,
        id != None,
        datatype_types,
      )
    }
    [_, _, ..] -> {
      "case "
      <> value
      <> " {"
      <> list.map(field.type_, fn(type_) {
        let narrowed = codegen_helpers.Element(..field, type_: [type_])
        let primitive_values = case
          dict.get(primitive_values, field.id <> "|" <> type_.code)
        {
          Ok(value) -> dict.insert(primitive_values, field.id, value)
          Error(_) -> primitive_values
        }
        field_type
        <> string.capitalise(type_.code)
        <> "(choice_value) -> "
        <> extension_field_to_json_call(
          extension_name,
          narrowed,
          field_type,
          "choice_value",
          id,
          primitive_values,
          None,
          datatype_types,
        )
      })
      |> string.join(" ")
      <> "}"
    }
    _ -> {
      let assert [type_] = field.type_
      let primitive_value =
        dict.get(primitive_values, field.id)
        |> result.map(Some)
        |> result.unwrap(None)
      let field_name = extension_field_name(field)
      let assert [first, ..rest] = type_.code |> string.to_graphemes
      let value_key =
        "\"value" <> string.concat([string.uppercase(first), ..rest]) <> "\""
      let fields = case primitive_value {
        Some(PrimitiveExtensionValue(name:, ..)) -> {
          "primitive_slice_to_json([#(\"url\", json.string(\""
          <> extension_url
          <> "\"))], "
          <> value
          <> ", "
          <> codegen_helpers.to_snake_case(name)
          <> "_value_to_json, "
          <> codegen_helpers.to_snake_case(name)
          <> "_rest_to_json, "
          <> value_key
          <> ")"
        }
        None -> {
          let value_json =
            {
              let #(resolved_type, _) =
                profile_value_type(
                  type_,
                  field,
                  [extension_name, field_name],
                  codegen_helpers.ComplexTypes,
                  datatype_types,
                  dict.new(),
                )
              profile_element_encoder_type(
                codegen_helpers.ComplexTypes,
                field,
                resolved_type,
                [extension_name, field_name],
                "",
                [],
                dict.new(),
                datatype_types,
                [],
              )
            }
            <> "("
            <> value
            <> ")"
          "[#(\"url\", json.string(\""
          <> extension_url
          <> "\")), #("
          <> value_key
          <> ", "
          <> value_json
          <> ")]"
        }
      }
      case id {
        None -> "json.object(" <> fields <> ")"
        Some(id) ->
          "{ let fields = "
          <> fields
          <> " let fields = case "
          <> id
          <> " { Some(id) -> [#(\"id\", json.string(id)), ..fields] None -> fields } json.object(fields) }"
      }
    }
  }
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

pub fn profile_extension_type(
  current_bucket: codegen_helpers.Category,
  element: codegen_helpers.Element,
  extensions: dict.Dict(String, ExtensionDefinition),
  valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
  datatype_types: dict.Dict(String, String),
) -> Option(#(String, dict.Dict(String, codegen_helpers.ValuesetItem))) {
  let complex_prefix = codegen_helpers.bucket_prefix("Quantity", current_bucket)
  case profile_extension_definition(element, extensions) {
    None -> None
    Some(ExtensionDefinition(name:, kind: ComplexExtension(..), ..)) ->
      Some(#(complex_prefix <> name, valueset_acc))
    Some(ExtensionDefinition(
      kind: SimpleExtension(value),
      primitive_values:,
      ..,
    )) -> {
      let assert [type_] = value.type_
      let #(gleam_type, valueset_acc) =
        profile_value_type(
          type_,
          value,
          ["Extension", "value"],
          current_bucket,
          datatype_types,
          valueset_acc,
        )
      let gleam_type = case dict.get(primitive_values, value.id) {
        Ok(PrimitiveExtensionValue(name:, ..)) -> complex_prefix <> name
        Error(_) -> gleam_type
      }
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

// Both constraint inheritance and type selection resolve the same alternatives.
pub fn resolve_datatype_profiles(
  type_: codegen_helpers.Type,
  profiles: dict.Dict(String, a),
) -> List(a) {
  case
    list.contains(["Extension", "Resource", "DomainResource"], type_.code)
    || list.any(type_.profile, fn(profile) {
      canonical_url(profile)
      == "http://hl7.org/fhir/StructureDefinition/" <> type_.code
    })
  {
    True -> []
    False ->
      case type_.profile {
        [_, _, ..] ->
          list.map(type_.profile, fn(url) {
            let assert Ok(profile) = dict.get(profiles, canonical_url(url))
              as { "unable to resolve datatype profile alternative " <> url }
            profile
          })
        _ ->
          type_.profile
          |> list.filter_map(fn(url) { dict.get(profiles, canonical_url(url)) })
      }
  }
}

// A single profile has its own type; alternatives use a generated union.
pub fn profile_value_type(
  type_: codegen_helpers.Type,
  element: codegen_helpers.Element,
  all_parts: List(String),
  current_bucket: codegen_helpers.Category,
  datatype_types: dict.Dict(String, String),
  valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
) -> #(String, dict.Dict(String, codegen_helpers.ValuesetItem)) {
  case resolve_datatype_profiles(type_, datatype_types) {
    [profile_type] -> #(
      codegen_helpers.bucket_prefix("Quantity", current_bucket) <> profile_type,
      valueset_acc,
    )
    [_, _, ..] -> #(
      all_parts
        |> string.join("_")
        |> string.replace("[x]", "")
        |> codegen_helpers.to_camel_case,
      valueset_acc,
    )
    _ ->
      codegen_helpers.string_to_type(
        type_.code,
        all_parts,
        element,
        current_bucket,
        valueset_acc,
      )
  }
}

pub fn profile_base_field_type(
  current_bucket: codegen_helpers.Category,
  element: codegen_helpers.Element,
  all_parts: List(String),
  field_path: String,
  choice_type: String,
  extensions: dict.Dict(String, ExtensionDefinition),
  type_order: List(String),
  slice_base_type_names: dict.Dict(String, String),
  slice_type_overrides: dict.Dict(String, SliceFieldType),
  datatype_types: dict.Dict(String, String),
  valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
) -> #(String, dict.Dict(String, codegen_helpers.ValuesetItem)) {
  let complex_prefix = codegen_helpers.bucket_prefix("Quantity", current_bucket)
  case
    profile_extension_type(
      current_bucket,
      element,
      extensions,
      valueset_acc,
      datatype_types,
    )
  {
    Some(extension_type) -> extension_type
    None ->
      case dict.get(slice_type_overrides, element.id) {
        Ok(FixedSliceType(slice_type, _, _, _, _)) -> #(
          case current_bucket {
            codegen_helpers.Resources -> slice_type
            codegen_helpers.ComplexTypes ->
              string.replace(slice_type, "ct.", "")
          },
          valueset_acc,
        )
        Ok(BoundCodeableconceptSlice) ->
          codegen_helpers.string_to_type(
            "CodeableConcept",
            all_parts,
            element,
            current_bucket,
            valueset_acc,
          )
        Ok(BoundCodingSlice) ->
          codegen_helpers.string_to_type(
            "Coding",
            all_parts,
            element,
            current_bucket,
            valueset_acc,
          )
        Error(_) | Ok(FixedValueDiscriminator(_)) ->
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
                [codegen_helpers.Type(code: "Element", ..)] -> #(
                  complex_prefix
                    <> base_payload_type(current_bucket, element, "Element"),
                  valueset_acc,
                )
                [only_type] -> {
                  profile_value_type(
                    only_type,
                    element,
                    all_parts,
                    current_bucket,
                    datatype_types,
                    valueset_acc,
                  )
                }
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

pub fn profile_field_has_primitive_type(
  element: codegen_helpers.Element,
  json_field_name: String,
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
    _ -> False
  }
}

pub fn profile_field_is_primitive_slice(
  element: codegen_helpers.Element,
  json_field_name: String,
  type_order: List(String),
  field_path: String,
) -> Bool {
  profile_field_has_primitive_type(element, json_field_name)
  && does_profile_restrict_complex_type(type_order, field_path)
}

pub fn profile_field_min(element: codegen_helpers.Element) -> Int {
  let min = int.max(0, element.min - list.length(element.pattern_literals))
  case element.slicing {
    Some(slicing) ->
      case slicing.rules == "open" && !string.ends_with(element.path, "[x]") {
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
    string.ends_with(group.path, "[x]"),
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
  ValueSlicePlan(
    root_id: String,
    overrides: List(#(String, SliceFieldType)),
    nested: List(SlicePlan),
  )
  TypeSlicePlan(
    root_id: String,
    fhir_type: String,
    slice: codegen_helpers.Element,
    children: List(codegen_helpers.Element),
    descendants: List(codegen_helpers.Element),
  )
}

pub type SliceFieldType {
  FixedSliceType(
    String,
    List(codegen_helpers.Element),
    String,
    String,
    Option(String),
  )
  FixedValueDiscriminator(String)
  BoundCodeableconceptSlice
  BoundCodingSlice
}

pub fn find_element(
  elements: List(codegen_helpers.Element),
  id: String,
) -> Result(codegen_helpers.Element, Nil) {
  list.find(elements, fn(element) { element.id == id })
}

pub fn profile_field_to_json_source(
  current_bucket: codegen_helpers.Category,
  element: codegen_helpers.Element,
  field_name: String,
  json_name: String,
  json_suffix: String,
  encoder: String,
  encoder_call: fn(String) -> String,
  card_min: Int,
) -> #(String, String) {
  let complex_prefix = codegen_helpers.bucket_prefix("Quantity", current_bucket)
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
  let maximum = case element.max {
    "0" | "1" -> element.max
    _ -> "*"
  }
  case maximum, element.base.max, card_min {
    "*", _, 0 -> #(
      "",
      optional(
        "[] -> fields",
        present("values", "json.array(values, " <> encoder <> ")"),
      ),
    )
    "*", _, 1 -> #(
      always("list1_to_json(" <> field_name <> ", " <> encoder <> ")"),
      "",
    )
    "*", _, 2 -> #(
      always(
        complex_prefix
        <> "list2_to_json("
        <> field_name
        <> ", "
        <> encoder
        <> ")",
      ),
      "",
    )
    "*", _, 3 -> #(
      always(
        complex_prefix
        <> "list3_to_json("
        <> field_name
        <> ", "
        <> encoder
        <> ")",
      ),
      "",
    )
    "1", "1", 0 -> #(
      "",
      optional(present("Some(v)", encoder_call("v")), "None -> fields"),
    )
    "1", "1", 1 -> #(always(encoder_call(field_name)), "")
    "1", _, 0 -> #(
      "",
      optional(
        present("Some(v)", "json.array([v], " <> encoder <> ")"),
        "None -> fields",
      ),
    )
    "1", _, 1 -> #(
      always("json.array([" <> field_name <> "], " <> encoder <> ")"),
      "",
    )
    _, "*", 0 -> #(
      "",
      optional(
        "[] -> fields",
        present("values", "json.array(values, " <> encoder <> ")"),
      ),
    )
    _, _, _ ->
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

pub fn profile_element_encoder_type(
  current_bucket: codegen_helpers.Category,
  element: codegen_helpers.Element,
  base_field_type: String,
  all_parts: List(String),
  field_path: String,
  type_order: List(String),
  slice_type_overrides: dict.Dict(String, SliceFieldType),
  datatype_types: dict.Dict(String, String),
  _snapshot_elements: List(codegen_helpers.Element),
) -> String {
  let complex_prefix = codegen_helpers.bucket_prefix("Quantity", current_bucket)
  case
    list.contains(
      dict.values(datatype_types),
      string.replace(base_field_type, "ct.", ""),
    )
  {
    True ->
      complex_prefix
      <> codegen_helpers.to_snake_case(string.replace(
        base_field_type,
        "ct.",
        "",
      ))
      <> "_to_json"
    False -> {
      let has_profile_union = case element.type_ {
        [type_] ->
          list.length(resolve_datatype_profiles(type_, datatype_types)) > 1
        _ -> False
      }
      case has_profile_union {
        True -> codegen_helpers.to_snake_case(base_field_type) <> "_to_json"
        False -> {
          case dict.get(slice_type_overrides, element.id) {
            Ok(FixedSliceType(slice_type, _, system, code, display)) ->
              "fn(value) { "
              <> codegen_slice_complex_type.discriminator_to_json_call(
                current_bucket,
                slice_type,
                system,
                code,
                display,
                "value",
              )
              <> " }"
            _ ->
              case
                does_profile_restrict_complex_type(type_order, field_path),
                element.type_
              {
                False, [codegen_helpers.Type(code: "Element", ..)] ->
                  complex_prefix
                  <> codegen_helpers.to_snake_case(base_payload_type(
                    current_bucket,
                    element,
                    "Element",
                  ))
                  <> "_to_json"
                False, [only_type] ->
                  codegen_to_json.string_to_encoder_type(
                    only_type.code,
                    all_parts,
                    element,
                    current_bucket,
                  )
                _, _ ->
                  codegen_helpers.to_snake_case(base_field_type) <> "_to_json"
              }
          }
        }
      }
    }
  }
}

pub fn profile_element_encoder_call(
  current_bucket: codegen_helpers.Category,
  element: codegen_helpers.Element,
  base_field_type: String,
  all_parts: List(String),
  field_path: String,
  type_order: List(String),
  slice_type_overrides: dict.Dict(String, SliceFieldType),
  datatype_types: dict.Dict(String, String),
  snapshot_elements: List(codegen_helpers.Element),
  value: String,
) -> String {
  let complex_prefix = codegen_helpers.bucket_prefix("Quantity", current_bucket)
  case
    list.contains(
      dict.values(datatype_types),
      string.replace(base_field_type, "ct.", ""),
    )
  {
    True ->
      complex_prefix
      <> codegen_helpers.to_snake_case(string.replace(
        base_field_type,
        "ct.",
        "",
      ))
      <> "_to_json("
      <> value
      <> ")"
    False -> {
      let has_profile_union = case element.type_ {
        [type_] ->
          list.length(resolve_datatype_profiles(type_, datatype_types)) > 1
        _ -> False
      }
      case has_profile_union {
        True ->
          codegen_helpers.to_snake_case(base_field_type)
          <> "_to_json("
          <> value
          <> ")"
        False -> {
          case dict.get(slice_type_overrides, element.id) {
            Ok(FixedSliceType(slice_type, _, system, code, display)) ->
              codegen_slice_complex_type.discriminator_to_json_call(
                current_bucket,
                slice_type,
                system,
                code,
                display,
                value,
              )
            _ ->
              case
                does_profile_restrict_complex_type(type_order, field_path),
                element.type_
              {
                False, [codegen_helpers.Type(code: "Element", ..)] ->
                  complex_prefix
                  <> codegen_helpers.to_snake_case(base_payload_type(
                    current_bucket,
                    element,
                    "Element",
                  ))
                  <> "_to_json("
                  <> value
                  <> ")"
                False, [only_type] ->
                  codegen_to_json.string_to_encoder_call(
                    only_type.code,
                    all_parts,
                    element,
                    current_bucket,
                    value,
                  )
                _, _ ->
                  profile_element_encoder_type(
                    current_bucket,
                    element,
                    base_field_type,
                    all_parts,
                    field_path,
                    type_order,
                    slice_type_overrides,
                    datatype_types,
                    snapshot_elements,
                  )
                  <> "("
                  <> value
                  <> ")"
              }
          }
        }
      }
    }
  }
}

pub fn profile_extension_encoder_call(
  current_bucket: codegen_helpers.Category,
  extension: ExtensionDefinition,
  value: String,
  id: Option(String),
  preserve_slice_order: Bool,
  datatype_types: dict.Dict(String, String),
) -> String {
  let complex_prefix = codegen_helpers.bucket_prefix("Quantity", current_bucket)
  let url = extension.url
  case extension.kind {
    SimpleExtension(extension_value) -> {
      let assert [value_type] = extension_value.type_
      let assert [first, ..rest] = value_type.code |> string.to_graphemes
      let suffix = string.concat([string.uppercase(first), ..rest])
      let fields = case
        dict.get(extension.primitive_values, extension_value.id)
      {
        Ok(PrimitiveExtensionValue(name:, ..)) ->
          "primitive_slice_to_json([#(\"url\", json.string(\""
          <> canonical_url(url)
          <> "\"))], "
          <> value
          <> ", "
          <> complex_prefix
          <> codegen_helpers.to_snake_case(name)
          <> "_value_to_json, "
          <> complex_prefix
          <> codegen_helpers.to_snake_case(name)
          <> "_rest_to_json, \"value"
          <> suffix
          <> "\")"
        Error(_) ->
          "[#(\"url\", json.string(\""
          <> canonical_url(url)
          <> "\")), #(\"value"
          <> suffix
          <> "\", "
          <> {
            let #(resolved_type, _) =
              profile_value_type(
                value_type,
                extension_value,
                ["Extension", "value"],
                current_bucket,
                datatype_types,
                dict.new(),
              )
            profile_element_encoder_type(
              current_bucket,
              extension_value,
              resolved_type,
              ["Extension", "value"],
              "",
              [],
              dict.new(),
              datatype_types,
              [],
            )
          }
          <> "("
          <> value
          <> "))]"
      }
      case id {
        None -> "json.object(" <> fields <> ")"
        Some(id) ->
          "{ let fields = "
          <> fields
          <> " let fields = case "
          <> id
          <> " { Some(id) -> [#(\"id\", json.string(id)), ..fields] None -> fields } json.object(fields) }"
      }
    }
    ComplexExtension(..) -> {
      let encoder =
        complex_prefix
        <> codegen_helpers.to_snake_case(extension.name)
        <> "_to_json"
      case preserve_slice_order {
        True ->
          encoder
          <> "("
          <> value
          <> ", \""
          <> canonical_url(url)
          <> "\", "
          <> case id {
            None -> "None"
            Some(id) -> id
          }
          <> ")"
        False ->
          encoder <> "(" <> value <> ", \"" <> canonical_url(url) <> "\")"
      }
    }
  }
}

fn slice_group_to_json_source(
  current_bucket: codegen_helpers.Category,
  element: codegen_helpers.Element,
  slice_roots: List(codegen_helpers.Element),
  indexed_slice_group: Bool,
  aggregate_encoder: String,
  profile_prefix: String,
  extensions: dict.Dict(String, ExtensionDefinition),
  type_order: List(String),
  slice_base_type_names: dict.Dict(String, String),
  slice_type_overrides: dict.Dict(String, SliceFieldType),
  datatype_types: dict.Dict(String, String),
  valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
  snapshot_elements: List(codegen_helpers.Element),
  base_field_type: String,
  all_parts: List(String),
  field_path: String,
  record_name: String,
  field_name: String,
  json_field_name: String,
  card_min: Int,
) -> String {
  let complex_prefix = codegen_helpers.bucket_prefix("Quantity", current_bucket)
  let open_encoder = case aggregate_encoder {
    "" ->
      profile_element_encoder_type(
        current_bucket,
        element,
        base_field_type,
        all_parts,
        field_path,
        type_order,
        slice_type_overrides,
        datatype_types,
        snapshot_elements,
      )
    _ -> codegen_helpers.to_snake_case(base_field_type) <> "_to_json"
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

      let root_field_name = codegen_helpers.field_name(root)
      let root_field_value = record_name <> "." <> root_field_name
      let root_field_path = string.join(root_parts, "_")
      let root_type_name = root_field_path |> codegen_helpers.to_camel_case
      let #(root_type, _) =
        profile_base_field_type(
          current_bucket,
          root,
          root_parts,
          root_field_path,
          root_type_name,
          extensions,
          type_order,
          slice_base_type_names,
          slice_type_overrides,
          datatype_types,
          valueset_acc,
        )
      let extension = profile_extension_definition(root, extensions)
      let root_call = fn(value, id) {
        case extension {
          Some(extension) ->
            profile_extension_encoder_call(
              current_bucket,
              extension,
              value,
              id,
              indexed_slice_group,
              datatype_types,
            )
          None ->
            profile_element_encoder_call(
              current_bucket,
              root,
              root_type,
              root_parts,
              root_field_path,
              type_order,
              slice_type_overrides,
              datatype_types,
              snapshot_elements,
              value,
            )
        }
      }
      let indexed_root_call = fn(value) {
        case indexed_slice_group, extension {
          True, Some(_) ->
            complex_prefix
            <> "SliceElt("
            <> root_call(value <> ".value", Some(value <> ".id"))
            <> ", "
            <> value
            <> ".internal_gleam_fhir_index)"
          True, None ->
            complex_prefix
            <> "SliceElt("
            <> root_call(value <> ".value", None)
            <> ", "
            <> value
            <> ".internal_gleam_fhir_index)"
          False, _ -> root_call(value, None)
        }
      }
      let #(value, is_single) = case root.min, root.max {
        0, "1" -> #(
          "case "
            <> root_field_value
            <> " { Some(value) -> ["
            <> indexed_root_call("value")
            <> "] None -> [] }",
          False,
        )
        1, "1" -> #(indexed_root_call(root_field_value), True)
        1, _ -> #(
          "["
            <> indexed_root_call(root_field_value <> ".first")
            <> ", ..list.map("
            <> root_field_value
            <> ".rest, fn(value) { "
            <> indexed_root_call("value")
            <> " })]",
          False,
        )
        2, _ -> #(
          "["
            <> indexed_root_call(root_field_value <> ".first")
            <> ", "
            <> indexed_root_call(root_field_value <> ".second")
            <> ", ..list.map("
            <> root_field_value
            <> ".rest, fn(value) { "
            <> indexed_root_call("value")
            <> " })]",
          False,
        )
        3, _ -> #(
          "["
            <> indexed_root_call(root_field_value <> ".first")
            <> ", "
            <> indexed_root_call(root_field_value <> ".second")
            <> ", "
            <> indexed_root_call(root_field_value <> ".third")
            <> ", ..list.map("
            <> root_field_value
            <> ".rest, fn(value) { "
            <> indexed_root_call("value")
            <> " })]",
          False,
        )
        0, _ -> #(
          "list.map("
            <> root_field_value
            <> ", fn(value) { "
            <> indexed_root_call("value")
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
  let open_indexed_call = fn(value) {
    case indexed_slice_group {
      True ->
        complex_prefix
        <> "SliceElt("
        <> open_encoder
        <> "("
        <> value
        <> ".value), "
        <> value
        <> ".internal_gleam_fhir_index)"
      False -> open_encoder <> "(" <> value <> ")"
    }
  }
  let maximum = case element.max {
    "0" | "1" -> element.max
    _ -> "*"
  }
  let open_values = case maximum, card_min {
    "*", 0 ->
      "list.map("
      <> field_name
      <> ", fn(value) { "
      <> open_indexed_call("value")
      <> " })"
    "*", 1 ->
      "["
      <> open_indexed_call(field_name <> ".first")
      <> ", ..list.map("
      <> field_name
      <> ".rest, fn(value) { "
      <> open_indexed_call("value")
      <> " })]"
    "*", 2 ->
      "["
      <> open_indexed_call(field_name <> ".first")
      <> ", "
      <> open_indexed_call(field_name <> ".second")
      <> ", ..list.map("
      <> field_name
      <> ".rest, fn(value) { "
      <> open_indexed_call("value")
      <> " })]"
    "*", 3 ->
      "["
      <> open_indexed_call(field_name <> ".first")
      <> ", "
      <> open_indexed_call(field_name <> ".second")
      <> ", "
      <> open_indexed_call(field_name <> ".third")
      <> ", ..list.map("
      <> field_name
      <> ".rest, fn(value) { "
      <> open_indexed_call("value")
      <> " })]"
    "1", 0 ->
      "case "
      <> field_name
      <> " { Some(value) -> ["
      <> open_indexed_call("value")
      <> "] None -> [] }"
    _, _ -> panic as "unsupported open slice cardinality"
  }
  let open_values = case element.slicing {
    Some(codegen_helpers.Slicing(rules: "closed", ..)) -> "[]"
    _ -> open_values
  }
  let single_values = list.reverse(single_values)
  let list_values = list.reverse([open_values, ..list_values])
  let slice_values = case single_values, list_values {
    [], [only] -> only
    [], lists -> "list.flatten([" <> string.join(lists, ",") <> "])"
    singles, [only] -> "[" <> string.join(singles, ",") <> ", .." <> only <> "]"
    singles, lists ->
      "["
      <> string.join(singles, ",")
      <> ", ..list.flatten(["
      <> string.join(lists, ",")
      <> "])]"
  }
  "\nlet slice_values = "
  <> slice_values
  <> case indexed_slice_group {
    True ->
      "\nlet slice_values = "
      <> complex_prefix
      <> "slice_elts_to_values(slice_values)"

    False -> ""
  }
  <> "\nlet fields = case slice_values {\n  [] -> fields\n  values -> [#(\""
  <> json_field_name
  <> "\", json.preprocessed_array(values)), ..fields]\n}"
}

pub fn sliced_type_to_json_source(
  current_bucket: codegen_helpers.Category,
  sliced_name: String,
  children: List(codegen_helpers.Element),
  profile_prefix: String,
  extensions: dict.Dict(String, ExtensionDefinition),
  type_order: List(String),
  slice_base_type_names: dict.Dict(String, String),
  slice_type_overrides: dict.Dict(String, SliceFieldType),
  datatype_types: dict.Dict(String, String),
  valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
  snapshot_elements: List(codegen_helpers.Element),
  preserve_slice_order: Bool,
) -> String {
  let children =
    name_profile_record_fields(children, profile_prefix, type_order)
  let aggregate_slice_groups =
    children
    |> list.filter_map(fn(group) {
      case aggregate_value_slice_roots(group, children) {
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
  let type_fields =
    list.filter(children, fn(child) {
      child.max != "0"
      && !list.any(omitted_slice_roots, fn(root) { root.id == child.id })
      && case child.slicing {
        Some(slicing) ->
          slicing.rules != "closed"
          || string.ends_with(child.path, "[x]")
          || dict.has_key(aggregate_slice_groups, child.id)
        None -> True
      }
    })
  let slice_groups =
    children
    |> list.filter_map(fn(group) {
      let roots =
        list.filter(children, fn(candidate) {
          let prefix = group.id <> ":"
          candidate.path == group.path
          && candidate.slice_name != None
          && string.starts_with(candidate.id, prefix)
          && !string.contains(
            string.drop_start(candidate.id, string.length(prefix)),
            ".",
          )
        })
      case group.slicing, group.base.max, list.length(group.type_), roots {
        Some(_), base_max, type_count, [_, ..]
          if base_max != "1" && type_count <= 1
        -> Ok(#(group.id, roots))
        _, _, _, _ -> Error(Nil)
      }
    })
    |> dict.from_list
  let slice_root_ids =
    slice_groups
    |> dict.values
    |> list.flatten
    |> list.map(fn(root) { root.id })
  let #(always, optional) =
    type_fields
    |> list.fold(#("", ""), fn(acc, child) {
      let #(always, optional) = acc
      let assert Ok(json_name) = child.path |> string.split(".") |> list.last
      case codegen_helpers.constant(child), child.min, child.max {
        Some(value), minimum, "1" if minimum > 0 -> {
          let value_json = codegen_constraint.json_source(value)
          #(
            always
              <> "#(\""
              <> json_name
              <> "\", "
              <> case child.base.max, value {
              "1", _ | _, codegen_constraint.Array(_) -> value_json
              _, _ -> "json.preprocessed_array([" <> value_json <> "])"
            }
              <> "),",
            optional,
          )
        }
        _, _, _ -> {
          let field_name = case child.slice_name {
            Some(slice_name) -> slice_name
            None -> json_name
          }
          let field_name =
            field_name
            |> codegen_helpers.escape_field_name
            |> codegen_helpers.to_snake_case
          let all_parts = [sliced_name, field_name]
          let field_path = string.join(all_parts, "_")
          let child_type_name = field_path |> codegen_helpers.to_camel_case
          let field_name = codegen_helpers.field_name(child)
          let #(base_field_type, _) =
            profile_base_field_type(
              current_bucket,
              child,
              all_parts,
              field_path,
              child_type_name,
              extensions,
              type_order,
              slice_base_type_names,
              slice_type_overrides,
              datatype_types,
              valueset_acc,
            )
          let encoder =
            profile_element_encoder_type(
              current_bucket,
              child,
              base_field_type,
              all_parts,
              field_path,
              type_order,
              slice_type_overrides,
              datatype_types,
              snapshot_elements,
            )
          let encoder_call = fn(value) {
            profile_element_encoder_call(
              current_bucket,
              child,
              base_field_type,
              all_parts,
              field_path,
              type_order,
              slice_type_overrides,
              datatype_types,
              snapshot_elements,
              value,
            )
          }
          let field_value =
            codegen_helpers.to_snake_case(sliced_name) <> "." <> field_name
          case
            dict.get(slice_groups, child.id),
            list.contains(slice_root_ids, child.id)
          {
            Ok(slice_roots), _ -> {
              let card_min = case dict.get(aggregate_slice_groups, child.id) {
                Ok(#(_, remaining_minimum)) -> remaining_minimum
                Error(_) -> profile_field_min(child)
              }
              #(
                always,
                optional
                  <> slice_group_to_json_source(
                  current_bucket,
                  child,
                  slice_roots,
                  preserve_slice_order,
                  "",
                  profile_prefix,
                  extensions,
                  type_order,
                  slice_base_type_names,
                  slice_type_overrides,
                  datatype_types,
                  valueset_acc,
                  snapshot_elements,
                  base_field_type,
                  all_parts,
                  field_path,
                  codegen_helpers.to_snake_case(sliced_name),
                  field_value,
                  json_name,
                  card_min,
                ),
              )
            }
            Error(_), True -> #(always, optional)
            Error(_), False -> {
              let #(new_always, new_optional) =
                profile_field_to_json_source(
                  current_bucket,
                  child,
                  field_value,
                  json_name,
                  "",
                  encoder,
                  encoder_call,
                  profile_field_min(child),
                )
              #(always <> new_always, optional <> new_optional)
            }
          }
        }
      }
    })
  codegen_helpers.gen_res_encoder(
    "",
    sliced_name,
    codegen_helpers.to_snake_case(sliced_name),
    always,
    optional,
    False,
  )
}

pub type DecodeContext {
  DecodeContext(
    resource_type: String,
    current_bucket: codegen_helpers.Category,
    is_resource: Bool,
    profile_prefix: String,
    snapshot_elements: List(codegen_helpers.Element),
    discriminator_elements: List(codegen_helpers.Element),
    type_order: List(String),
    type_fields: dict.Dict(String, List(codegen_helpers.Element)),
    extensions: dict.Dict(String, ExtensionDefinition),
    slice_base_type_names: dict.Dict(String, String),
    slice_type_overrides: dict.Dict(String, SliceFieldType),
    datatype_types: dict.Dict(String, String),
    profile_unions: dict.Dict(String, List(String)),
    nested_value_discriminators: Set(String),
    slice_discriminator_checks: dict.Dict(String, SliceFieldType),
    type_slice_overrides: dict.Dict(String, SlicePlan),
    preserve_slice_order: Bool,
    valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
    available_valuesets: dict.Dict(String, codegen_helpers.VsOrCs),
    base_elements: dict.Dict(String, codegen_helpers.Element),
    constructors: dict.Dict(String, ConstructorDefinition),
  )
}

type ConversionRequest {
  RecordConversion(
    function_name: String,
    base_type: String,
    target_type: String,
  )
  SliceConversion(
    function_name: String,
    parent_type: String,
    group: codegen_helpers.Element,
    root: codegen_helpers.Element,
  )
  ChoiceConversion(
    function_name: String,
    choice_type: String,
    element: codegen_helpers.Element,
    source_type: String,
    source_element: Option(codegen_helpers.Element),
  )
  ChoiceRecordConversion(
    function_name: String,
    target_type: String,
    base_type: String,
    fields: List(codegen_helpers.Element),
  )
}

type ConversionSupport {
  ConversionSupport(
    source: String,
    conversions: dict.Dict(String, ConversionRequest),
  )
}

type ConversionExpression {
  ConversionExpression(
    expression: String,
    conversions: dict.Dict(String, ConversionRequest),
    fallible: Bool,
  )
  IdentityConversion(
    expression: String,
    conversions: dict.Dict(String, ConversionRequest),
    fallible: Bool,
  )
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

fn is_primitive_slice_record(
  snapshot_elements: List(codegen_helpers.Element),
  profile_prefix: String,
  type_order: List(String),
  current_type: String,
) -> Bool {
  list.any(snapshot_elements, fn(element) {
    let parts =
      element.id
      |> string.replace("-", "")
      |> string.replace(":", ".")
      |> string.split(".")
    let assert [_, ..rest] = parts
    let field_path = string.join([profile_prefix, ..rest], "_")
    profile_field_is_primitive_slice(
      element,
      profile_json_field_name(element, ""),
      type_order,
      field_path,
    )
    && field_path == current_type
  })
}

fn conversion_is_identity(expression: ConversionExpression) -> Bool {
  case expression {
    IdentityConversion(..) -> True
    ConversionExpression(..) -> False
  }
}

type SliceGroupDecode {
  SliceGroupDecode(
    source: String,
    support_source: String,
    result_name: String,
    success_pattern: String,
    decoded_fields: List(#(String, String)),
    decoder_placeholder: Option(String),
    placeholder_fields: List(#(String, String)),
    extension_decoder: Option(#(String, String)),
    conversions: dict.Dict(String, ConversionRequest),
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
    |> codegen_helpers.to_camel_case
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
  let type_field_name =
    option.unwrap(element.slice_name, last)
    |> string.replace("[x]", "")
    |> codegen_helpers.escape_field_name
    |> codegen_helpers.to_snake_case
  let field_name = case element.gleam_field_name {
    Some(name) -> name
    None -> {
      fields_for_profile_type(context, parent_type, "")
      |> result.try(fn(fields) {
        list.find_map(fields, fn(field) {
          case field.id == element.id, field.gleam_field_name {
            True, Some(name) -> Ok(name)
            _, _ -> Error(Nil)
          }
        })
      })
      |> result.unwrap(codegen_helpers.field_name(element))
    }
  }
  let field_path = string.join(parts, "_")
  let #(field_type, _) =
    profile_base_field_type(
      context.current_bucket,
      element,
      parts,
      field_path,
      parent_type <> string.capitalise(type_field_name),
      context.extensions,
      context.type_order,
      context.slice_base_type_names,
      context.slice_type_overrides,
      context.datatype_types,
      context.valueset_acc,
    )
  let complex_prefix =
    codegen_helpers.bucket_prefix("Quantity", context.current_bucket)
  let field_type =
    context.extensions
    |> dict.values
    |> list.find_map(fn(extension) {
      case parent_type == complex_prefix <> extension.name {
        False -> Error(Nil)
        True ->
          dict.get(extension.primitive_values, element.id)
          |> result.map(fn(value) { complex_prefix <> value.name })
      }
    })
    |> result.unwrap(field_type)
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
  |> fn(found) {
    case found {
      Ok(_) -> found
      Error(_) -> {
        context.extensions
        |> dict.values
        |> list.find_map(fn(extension) {
          let complex_prefix =
            codegen_helpers.bucket_prefix("Quantity", context.current_bucket)
          case
            extension.kind,
            target_type == string.lowercase(complex_prefix <> extension.name)
          {
            ComplexExtension(fields, _), True -> Ok(fields)
            _, _ -> {
              extension.primitive_values
              |> dict.values
              |> list.find_map(fn(value) {
                let name =
                  value.name |> string.replace("_", "") |> string.lowercase
                let complex_prefix =
                  codegen_helpers.bucket_prefix(
                    "Quantity",
                    context.current_bucket,
                  )
                case target_type == string.lowercase(complex_prefix) <> name {
                  False -> Error(Nil)
                  True -> {
                    let assert [root, ..children] = value.elements
                    Ok(
                      children
                      |> list.filter(fn(field) {
                        case string.split(field.id, ".") {
                          [parent, _] -> parent == value.name
                          _ -> False
                        }
                      })
                      |> list.map(fn(field) {
                        case string.ends_with(field.id, ".value") {
                          True ->
                            codegen_helpers.Element(
                              ..field,
                              type_: root.type_,
                              binding: root.binding,
                            )
                          False -> field
                        }
                      }),
                    )
                  }
                }
              })
            }
          }
        })
      }
    }
  }
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
  current_bucket: codegen_helpers.Category,
  element: codegen_helpers.Element,
  fhir_type: String,
) -> String {
  let bucket = case fhir_type {
    "BackboneElement" | "Element" -> codegen_helpers.ComplexTypes
    _ -> current_bucket
  }
  let #(gleam_type, _) =
    codegen_helpers.string_to_type(
      fhir_type,
      string.split(element.base.path, "."),
      codegen_helpers.Element(..element, binding: None),
      bucket,
      dict.new(),
    )
  gleam_type
}

pub fn discriminator_literals(
  element: codegen_helpers.Element,
  constraint_elements: List(codegen_helpers.Element),
) -> Result(#(String, String, Option(String)), Nil) {
  case element.fixed_uri {
    Some(uri) -> Ok(#(uri, "", None))
    None ->
      case
        element.pattern_coding,
        element.pattern_codeableconcept,
        element.pattern_identifier,
        find_element(constraint_elements, element.id <> ".coding")
      {
        Some(codegen_helpers.DiscriminatorCodingValue(
          system: Some(system),
          code: Some(code),
          display:,
        )),
          _,
          _,
          _
        -> Ok(#(system, code, display))
        _,
          Some(codegen_helpers.DiscriminatorCodeableconceptValue(coding: [
            codegen_helpers.DiscriminatorCodingValue(
              system: Some(system),
              code: Some(code),
              display:,
            ),
          ])),
          _,
          _
        -> Ok(#(system, code, display))
        _,
          _,
          Some(codegen_helpers.DiscriminatorIdentifierValue(
            system: Some(system),
            ..,
          )),
          _
        -> Ok(#(system, "", None))
        _,
          _,
          _,
          Ok(codegen_helpers.Element(
            pattern_coding: Some(codegen_helpers.DiscriminatorCodingValue(
              system: Some(system),
              code: Some(code),
              display:,
            )),
            ..,
          ))
        -> Ok(#(system, code, display))
        _, _, _, _ -> {
          let descendants = constraint_elements
          let system_id = element.id <> ".system"
          let system_element = case
            list.find(descendants, fn(child) { child.id == system_id })
          {
            Ok(child) -> Ok(child)
            Error(_) -> Error(Nil)
          }
          let system =
            system_element
            |> result.try(fn(child) { option.to_result(child.fixed_uri, Nil) })
          let code =
            descendants
            |> list.find(fn(child) { child.id == element.id <> ".code" })
            |> result.try(fn(child) { option.to_result(child.fixed_code, Nil) })
          case system, code {
            Ok(system), Ok(code) -> Ok(#(system, code, None))
            Ok(system), Error(_) -> Ok(#(system, "", None))
            _, _ -> {
              let coding_system =
                descendants
                |> list.find(fn(child) {
                  child.id == element.id <> ".coding.system"
                })
                |> result.try(fn(child) {
                  option.to_result(child.fixed_uri, Nil)
                })
              let coding_code =
                descendants
                |> list.find(fn(child) {
                  child.id == element.id <> ".coding.code"
                })
                |> result.try(fn(child) {
                  option.to_result(child.fixed_code, Nil)
                })
              case coding_system, coding_code {
                Ok(system), Ok(code) -> Ok(#(system, code, None))
                Ok(system), Error(_) -> Ok(#(system, "", None))
                _, _ -> {
                  let type_element =
                    descendants
                    |> list.find(fn(child) { child.id == element.id <> ".type" })
                  case type_element {
                    Ok(type_element) ->
                      discriminator_literals(type_element, constraint_elements)
                    Error(_) -> Error(Nil)
                  }
                }
              }
            }
          }
        }
      }
  }
}

fn discriminator_conversion(
  current_bucket: codegen_helpers.Category,
  discriminator_type: String,
  system: String,
  code: String,
  display: Option(String),
  value: String,
) -> Result(#(ConversionExpression, Bool), Nil) {
  use call <- result.try(
    codegen_slice_complex_type.discriminator_from_base_call(
      current_bucket,
      discriminator_type,
      value,
      system,
      code,
      display,
    ),
  )
  case call {
    codegen_slice_complex_type.ResultDiscriminatorCall(call) ->
      Ok(#(
        ConversionExpression(
          call
            <> " |> result.replace_error("
            <> json.to_string(json.string("expected " <> discriminator_type))
            <> ")",
          dict.new(),
          True,
        ),
        False,
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
        expression.conversions,
        True,
      )
    False ->
      ConversionExpression(
        wrap(expression.expression),
        expression.conversions,
        False,
      )
  }
}

fn conversion_for_cardinality(
  current_bucket: codegen_helpers.Category,
  expression: ConversionExpression,
  element: codegen_helpers.Element,
  source: String,
  target_min: Int,
  is_primitive: Bool,
  failure: fn(String) -> String,
) -> ConversionExpression {
  let complex_prefix = codegen_helpers.bucket_prefix("Quantity", current_bucket)
  case is_primitive {
    True -> {
      case conversion_is_identity(expression) {
        True -> IdentityConversion(source, expression.conversions, False)
        False -> {
          let convert_primitive = fn(primitive: String) {
            case expression.fallible {
              True ->
                "case "
                <> primitive
                <> ".value { None -> Ok(Primitive(.."
                <> primitive
                <> ", value: None)) Some(primitive_value) -> result.map("
                <> expression.expression
                <> ", fn(converted) { Primitive(.."
                <> primitive
                <> ", value: Some(converted)) }) }"
              False ->
                "Primitive(.."
                <> primitive
                <> ", value: option.map("
                <> primitive
                <> ".value, fn(primitive_value) { "
                <> expression.expression
                <> " }))"
            }
          }
          case element.base.max == "1", expression.fallible {
            True, fallible ->
              ConversionExpression(
                convert_primitive(source),
                expression.conversions,
                fallible,
              )
            False, True ->
              ConversionExpression(
                "list.try_map("
                  <> source
                  <> ", fn(primitive) { "
                  <> convert_primitive("primitive")
                  <> " })",
                expression.conversions,
                True,
              )
            False, False ->
              ConversionExpression(
                "list.map("
                  <> source
                  <> ", fn(primitive) { "
                  <> convert_primitive("primitive")
                  <> " })",
                expression.conversions,
                False,
              )
          }
        }
      }
    }
    False -> {
      let identity = conversion_is_identity(expression)
      let source_is_list = element.base.max != "1"
      let target_is_list = element.max != "1"
      let source = case source_is_list, element.base.min {
        True, 1 -> "[" <> source <> ".first" <> ", .." <> source <> ".rest]"
        True, 2 ->
          "["
          <> source
          <> ".first"
          <> ", "
          <> source
          <> ".second"
          <> ", .."
          <> source
          <> ".rest]"
        True, 3 ->
          "["
          <> source
          <> ".first"
          <> ", "
          <> source
          <> ".second"
          <> ", "
          <> source
          <> ".third"
          <> ", .."
          <> source
          <> ".rest]"
        _, _ -> source
      }
      case source_is_list, target_is_list, element.base.min, target_min {
        True, True, _, 0 if identity ->
          IdentityConversion(source, expression.conversions, False)
        True, True, _, 0 ->
          case expression.fallible {
            True ->
              ConversionExpression(
                "list.try_map("
                  <> source
                  <> ", fn(value) { "
                  <> expression.expression
                  <> " })",
                expression.conversions,
                True,
              )
            False ->
              ConversionExpression(
                "list.map("
                  <> source
                  <> ", fn(value) { "
                  <> expression.expression
                  <> " })",
                expression.conversions,
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
              "case values { [first, ..rest] -> Ok("
              <> complex_prefix
              <> "List1(first:, rest:)) _ -> "
              <> failure("\"minimum cardinality 1\"")
              <> " }"

            2 ->
              "case values { [first, second, ..rest] -> Ok("
              <> complex_prefix
              <> "List2(first:, second:, rest:)) _ -> "
              <> failure("\"minimum cardinality 2\"")
              <> " }"

            3 ->
              "case values { [first, second, third, ..rest] -> Ok("
              <> complex_prefix
              <> "List3(first:, second:, third:, rest:)) _ -> "
              <> failure("\"minimum cardinality 3\"")
              <> " }"

            _ -> panic as "list min > 3 not supported"
          }
          ConversionExpression(
            "{ " <> list_expression <> constructor <> " }",
            expression.conversions,
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
              <> " _ -> "
              <> failure("\"maximum cardinality 1\"")
              <> " }",
            expression.conversions,
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
              <> " _ -> "
              <> failure("\"cardinality 1..1\"")
              <> " }",
            expression.conversions,
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
            expression.conversions,
            True,
          )
        False, False, 0, _ ->
          ConversionExpression(
            "case "
              <> source
              <> " { None -> "
              <> failure("\"required field\"")
              <> " Some(value) -> "
              <> case expression.fallible {
              True -> expression.expression
              False -> "Ok(" <> expression.expression <> ")"
            }
              <> " }",
            expression.conversions,
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
  let complex_prefix =
    codegen_helpers.bucket_prefix("Quantity", context.current_bucket)
  use base_type <- result.try(base_record_type(fields))
  let assert Ok(first) = list.first(fields)
  let assert [base_root, ..] = string.split(first.base.path, ".")
  Ok(case base_root == context.resource_type && context.is_resource {
    True -> base_type
    False -> complex_prefix <> base_type
  })
}

fn required_binding_conversion(
  current_bucket: codegen_helpers.Category,
  element: codegen_helpers.Element,
  fhir_type: String,
  value: String,
) -> Option(ConversionExpression) {
  let #(gleam_type, _) =
    codegen_helpers.string_to_type(
      fhir_type,
      [],
      element,
      current_bucket,
      dict.new(),
    )
  let complex_prefix = codegen_helpers.bucket_prefix("Quantity", current_bucket)
  let valueset = case fhir_type {
    "code" ->
      case string.starts_with(gleam_type, "valuesets.") {
        True ->
          Some(
            gleam_type |> string.drop_start(10) |> codegen_helpers.to_snake_case,
          )
        False -> None
      }
    _ -> codegen_bound_coding.bound_valueset_function_name(gleam_type)
  }
  case valueset {
    Some(valueset) -> {
      let #(function, second_argument) = case fhir_type {
        "code" -> #("valuesets." <> valueset <> "_from_code", "")
        "Coding" -> #(
          complex_prefix <> "bound_coding_from_coding",
          ", valuesets." <> valueset <> "_from_code_and_system",
        )
        "CodeableConcept" -> #(
          complex_prefix <> "bound_codeableconcept_from_codeableconcept",
          ", valuesets." <> valueset <> "_from_code_and_system",
        )
        "Quantity" -> #(
          complex_prefix <> "bound_quantity_from_quantity",
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
            dict.new(),
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
) -> Result(ConversionRequest, Nil) {
  let complex_prefix =
    codegen_helpers.bucket_prefix("Quantity", context.current_bucket)
  let restricts_complex_type =
    does_profile_restrict_complex_type(context.type_order, field_path)
  let base_type = case
    fields_for_profile_type(context, field_type, ""),
    element.type_
  {
    Ok(fields), [_] | Ok(fields), [] -> base_record_reference(context, fields)
    Error(_), [_] if restricts_complex_type -> {
      let assert [type_] = element.type_
      Ok(base_payload_type(context.current_bucket, element, type_.code))
    }
    _, _ -> Error(Nil)
  }
  use base_type <- result.try(base_type)
  let function_name =
    codegen_helpers.to_snake_case(field_type)
    <> "_try_from_"
    <> {
      base_type
      |> string.replace(complex_prefix, "")
      |> codegen_helpers.to_snake_case
    }
  Ok(RecordConversion(function_name, base_type, field_type))
}

fn datatype_profile_conversion(
  context: DecodeContext,
  source_element: codegen_helpers.Element,
  source_type: String,
  target_type: String,
  value: String,
) -> ConversionExpression {
  case source_type == target_type {
    True -> IdentityConversion(value, dict.new(), False)
    False -> {
      let encoder = case
        dict.has_key(
          context.constructors,
          constructor_key(context.current_bucket, source_type),
        )
      {
        True ->
          source_type
          |> string.split(".")
          |> list.map(codegen_helpers.to_snake_case)
          |> string.join(".")
          |> string.append("_to_json")
        False ->
          profile_element_encoder_type(
            context.current_bucket,
            source_element,
            source_type,
            string.split(source_element.base.path, "."),
            "",
            [],
            dict.new(),
            context.datatype_types,
            context.snapshot_elements,
          )
      }
      let decoder =
        target_type
        |> string.split(".")
        |> list.map(codegen_helpers.to_snake_case)
        |> string.join(".")
        |> string.append("_decoder()")
      ConversionExpression(
        "json.parse(json.to_string("
          <> encoder
          <> "("
          <> value
          <> ")), "
          <> decoder
          <> ") |> result.replace_error(\"invalid datatype profile\")",
        dict.new(),
        True,
      )
    }
  }
}

fn field_inner_conversion(
  context: DecodeContext,
  element: codegen_helpers.Element,
  field_path: String,
  field_type: String,
  value: String,
  source_choice_type: Option(String),
  source_element: Option(codegen_helpers.Element),
  validation_path: Option(String),
  failure: fn(String) -> String,
) -> ConversionExpression {
  let narrows_choice =
    string.ends_with(element.base.path, "[x]")
    && list.length(element.type_) == 1
  let inner_value = case narrows_choice {
    True -> "choice_value"
    False -> value
  }
  let #(source_value_type, source_value_element) = case
    narrows_choice,
    element.type_
  {
    True, [type_] -> {
      let assert Some(source) = source_element
        as { "missing source definition for " <> element.id }
      let assert Ok(source_type) =
        list.find(source.type_, fn(candidate) { candidate.code == type_.code })
        as { "missing source choice " <> type_.code <> " for " <> element.id }
      let narrowed = codegen_helpers.Element(..source, type_: [source_type])
      let #(type_name, _) =
        profile_value_type(
          source_type,
          narrowed,
          string.split(source.base.path, "."),
          context.current_bucket,
          context.datatype_types,
          context.valueset_acc,
        )
      #(Some(type_name), Some(narrowed))
    }
    _, _ -> #(source_choice_type, source_element)
  }
  let target_is_datatype_profile =
    list.contains(
      dict.values(context.datatype_types),
      string.replace(field_type, "ct.", ""),
    )
  let target_is_datatype_profile =
    target_is_datatype_profile
    || list.any(dict.keys(context.profile_unions), fn(path) {
      path |> string.replace("[x]", "") |> codegen_helpers.to_camel_case
      == field_type
    })
  let conversion = case
    dict.get(context.slice_type_overrides, element.id),
    target_is_datatype_profile
  {
    Ok(FixedSliceType(discriminator_type, _, system, code, display)), _ -> {
      let assert Ok(#(conversion, _)) =
        discriminator_conversion(
          context.current_bucket,
          discriminator_type,
          system,
          code,
          display,
          inner_value,
        )
      conversion
    }
    Ok(BoundCodeableconceptSlice), _ | Ok(BoundCodingSlice), _ -> {
      let assert [type_] = element.type_
      required_binding_conversion(
        context.current_bucket,
        element,
        type_.code,
        inner_value,
      )
      |> fn(conversion) {
        case conversion {
          Some(conversion) -> conversion
          None -> {
            let assert True = source_value_type == Some(field_type)
              as {
                "cannot convert field " <> element.id <> " to " <> field_type
              }
            IdentityConversion(inner_value, dict.new(), False)
          }
        }
      }
    }
    Error(_), True | Ok(FixedValueDiscriminator(_)), True -> {
      let assert Some(source_type) = source_value_type
        as { "missing source type for " <> element.id }
      let assert Some(source_element) = source_value_element
        as { "missing source definition for " <> element.id }
      datatype_profile_conversion(
        context,
        source_element,
        source_type,
        field_type,
        inner_value,
      )
    }
    Error(_), False | Ok(FixedValueDiscriminator(_)), False ->
      case
        profile_record_conversion_function(
          context,
          element,
          field_path,
          field_type,
        )
      {
        Ok(conversion) ->
          ConversionExpression(
            conversion.function_name <> "(" <> inner_value <> ")",
            dict.from_list([#(conversion.function_name, conversion)]),
            True,
          )
        Error(_) ->
          case element.type_ {
            [] -> {
              let assert True = source_value_type == Some(field_type)
                as {
                  "cannot convert field " <> element.id <> " to " <> field_type
                }
              IdentityConversion(inner_value, dict.new(), False)
            }
            [type_] ->
              required_binding_conversion(
                context.current_bucket,
                element,
                type_.code,
                inner_value,
              )
              |> fn(conversion) {
                case conversion {
                  Some(conversion) -> conversion
                  None -> {
                    let assert True = source_value_type == Some(field_type)
                      as {
                        "cannot convert field "
                        <> element.id
                        <> " to "
                        <> field_type
                      }
                    IdentityConversion(inner_value, dict.new(), False)
                  }
                }
              }
            _ -> {
              let source_type =
                option.unwrap(source_choice_type, base_choice_name(element))
              let function_name =
                codegen_helpers.to_snake_case(field_type)
                <> "_from_"
                <> codegen_helpers.to_snake_case(source_type)
              let conversion =
                ChoiceConversion(
                  function_name,
                  field_type,
                  element,
                  source_type,
                  source_element,
                )
              ConversionExpression(
                function_name <> "(" <> value <> ")",
                dict.from_list([#(function_name, conversion)]),
                True,
              )
            }
          }
      }
  }
  let conversion = case validation_path, conversion.fallible {
    Some(_), True ->
      ConversionExpression(
        "case "
          <> conversion.expression
          <> " { Ok(value) -> Ok(value) Error(reason) -> "
          <> failure("reason")
          <> " }",
        conversion.conversions,
        True,
      )
    _, _ -> conversion
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
      let successful = case
        validation_path,
        fields_for_profile_type(context, field_type, "")
      {
        Some(path), Ok(_) ->
          "{ use _ <- result.try("
          <> restricted_record_validation(
            context,
            field_type,
            "choice_value",
            path,
          )
          <> ") "
          <> successful
          <> " }"
        _, _ -> successful
      }
      ConversionExpression(
        "case "
          <> value
          <> " { "
          <> constructor
          <> "(choice_value) -> "
          <> successful
          <> " _ -> "
          <> failure("\"expected " <> type_.code <> "\"")
          <> " }",
        conversion.conversions,
        True,
      )
    }
    _, _ -> conversion
  }
}

// Only fields with named slices need an index to preserve their ordering.
// Declarations and codecs share this decision, including groups with no slices.
pub fn profile_field_is_slice_elt(
  element: codegen_helpers.Element,
  fields: List(codegen_helpers.Element),
  preserve_slice_order: Bool,
) -> Bool {
  preserve_slice_order
  && element.pattern_literals != []
  || {
    { preserve_slice_order || element.pattern_match }
    && element.base.max != "1"
    && !string.ends_with(element.path, "[x]")
    && aggregate_value_slice_roots(element, fields) == None
    && {
      element.slice_name != None
      || element.slicing != None
      && list.any(fields, fn(candidate) {
        candidate.path == element.path && candidate.slice_name != None
      })
    }
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
        || string.ends_with(element.path, "[x]")
        || dict.has_key(aggregate_slice_groups, element.id)
      None -> True
    }
  })
}

pub fn name_profile_record_fields(
  fields: List(codegen_helpers.Element),
  profile_prefix: String,
  type_order: List(String),
) -> List(codegen_helpers.Element) {
  let emitted_fields =
    fields
    |> profile_fields
    |> list.filter(fn(element) {
      let assert [_, ..rest] =
        element.id
        |> string.replace("-", "")
        |> string.replace(":", ".")
        |> string.split(".")
      { codegen_helpers.constant(element) == None }
      || element.min == 0
      || element.max != "1"
      || profile_field_is_primitive_slice(
        element,
        "",
        type_order,
        string.join([profile_prefix, ..rest], "_"),
      )
    })
  codegen_helpers.name_record_fields(fields, emitted_fields)
}

fn record_conversion_from_fields(
  context: DecodeContext,
  target_type: String,
  base_type: String,
  fields: List(codegen_helpers.Element),
  source_profile_type: Option(String),
  slice_json_name: Option(String),
  function_name: String,
) -> ConversionSupport {
  let discriminator =
    fields
    |> list.find(fn(field) {
      case slice_json_name, dict.get(context.slice_type_overrides, field.id) {
        _, Ok(FixedSliceType(_, _, _, _, _)) | Some(_), Ok(_) -> True
        _, _ -> False
      }
    })
    |> option.from_result
  let discriminator_parameter = case discriminator {
    Some(discriminator) -> {
      let #(_, _, _, field_name, field_type) =
        profile_element_names(context, target_type, discriminator)
      let parameter_type = case discriminator.max {
        "1" -> field_type
        _ ->
          codegen_helpers.cardinality(
            field_type,
            profile_field_min(discriminator),
            discriminator.max,
          )
      }
      let parameter_name = case
        discriminator.fixed_code,
        discriminator.fixed_uri
      {
        _, _ if discriminator.min == 0 || discriminator.max != "1" -> field_name
        None, None -> field_name
        _, _ -> "_" <> field_name
      }
      ", " <> field_name <> " " <> parameter_name <> ": " <> parameter_type
    }
    None -> ""
  }
  let fixed_bindings =
    fields
    |> list.filter(fn(element) { element.max != "0" })
    |> list.filter_map(fn(element) {
      let fixed = case element.fixed_code, element.fixed_uri {
        Some(value), _ | _, Some(value) -> Ok(value)
        _, _ -> Error(Nil)
      }
      use fixed <- result.try(fixed)
      let #(_, _, json_name, _, _) =
        profile_element_names(context, target_type, element)
      let #(source_field_name, source_min, source_max) = case
        source_profile_type
      {
        Some(source_type) -> {
          let assert Ok(source_field) =
            fields_for_profile_type(context, source_type, "")
            |> result.try(fn(fields) {
              list.find(fields, fn(field) {
                field.slice_name == None && field.path == element.path
              })
            })
            as {
              "missing source field " <> element.path <> " in " <> source_type
            }
          #(
            codegen_helpers.field_name(source_field),
            profile_field_min(source_field),
            source_field.max,
          )
        }
        None -> #(
          codegen_helpers.field_name(
            codegen_helpers.Element(
              ..element,
              id: element.base.path,
              slice_name: None,
              gleam_field_name: None,
            ),
          ),
          element.base.min,
          element.base.max,
        )
      }
      let failure = fn(expected, found, extra_path) {
        case slice_json_name {
          None ->
            "Error(\"expected \" <> "
            <> expected
            <> " <> \", found \" <> "
            <> found
            <> ")"
          Some(group) ->
            "Error([decode.DecodeError(expected: "
            <> expected
            <> ", found: "
            <> found
            <> ", path: ["
            <> json.to_string(json.string(group))
            <> ", int.to_string(index), "
            <> json.to_string(json.string(json_name))
            <> extra_path
            <> "])])"
        }
      }
      let expected = json.to_string(json.string(fixed))
      let check = case source_min, source_max {
        0, "1" ->
          "case source."
          <> source_field_name
          <> " { Some(\""
          <> fixed
          <> "\") -> Ok(Nil) Some(found) -> "
          <> failure(expected, "found", "")
          <> " None -> "
          <> case element.min {
            0 -> "Ok(Nil)"
            _ -> failure("\"Field\"", "\"Nothing\"", "")
          }
          <> " }"
        _, "1" ->
          "case source."
          <> source_field_name
          <> " { "
          <> expected
          <> " -> Ok(Nil) found -> "
          <> failure(expected, "found", "")
          <> " }"
        minimum, _ -> {
          let source = "source." <> source_field_name
          let values = case minimum {
            0 -> source
            1 -> "[" <> source <> ".first, .." <> source <> ".rest]"
            2 ->
              "["
              <> source
              <> ".first, "
              <> source
              <> ".second, .."
              <> source
              <> ".rest]"
            3 ->
              "["
              <> source
              <> ".first, "
              <> source
              <> ".second, "
              <> source
              <> ".third, .."
              <> source
              <> ".rest]"
            _ -> panic as "list min > 3 not supported"
          }
          "list.try_map(list.index_map("
          <> values
          <> ", fn(value, item_index) { #(value, item_index) }), fn(item) { let #(found, "
          <> case slice_json_name {
            None -> "_item_index"
            Some(_) -> "item_index"
          }
          <> ") = item case found == "
          <> expected
          <> " { True -> Ok(Nil) False -> "
          <> failure(expected, "found", ", int.to_string(item_index)")
          <> " } }) |> result.map(fn(_) { Nil })"
        }
      }
      Ok("  use _ <- result.try(" <> check <> ")\n")
    })
    |> string.concat
  let empty_support = dict.new()
  let #(bindings, arguments, helpers) =
    fields
    |> list.filter(fn(element) {
      { codegen_helpers.constant(element) == None }
      || element.min == 0
      || element.max != "1"
    })
    |> list.fold(#("", "", empty_support), fn(acc, element) {
      let #(bindings, arguments, helpers) = acc
      let #(_, field_path, json_name, field_name, field_type) =
        profile_element_names(context, target_type, element)
      let validation_path =
        option.map(slice_json_name, fn(group) {
          "[\"" <> group <> "\", int.to_string(index), \"" <> json_name <> "\"]"
        })
      let failure = fn(reason) {
        case slice_json_name {
          None -> "Error(" <> reason <> ")"
          Some(group) -> {
            let expected = case element.type_ {
              [type_] -> type_.code
              _ -> field_type
            }
            let name = case string.ends_with(element.base.path, "[x]") {
              True ->
                element.path
                |> string.split(".")
                |> list.last
                |> result.unwrap(json_name)
              False -> json_name
            }
            "Error([decode.DecodeError(expected: \""
            <> expected
            <> "\", found: "
            <> reason
            <> ", path: [\""
            <> group
            <> "\", int.to_string(index), \""
            <> name
            <> "\"])])"
          }
        }
      }
      let source_field = case source_profile_type {
        None -> None
        Some(source_type) -> {
          let assert Ok(source_field) =
            fields_for_profile_type(context, source_type, "")
            |> result.try(fn(source_fields) {
              list.find(source_fields, fn(source_field) {
                source_field.slice_name == None
                && source_field.path == element.path
              })
            })
            as {
              "missing source field " <> element.path <> " in " <> source_type
            }
          Some(source_field)
        }
      }
      let source_definition = case source_field {
        Some(_) -> source_field
        None ->
          dict.get(context.base_elements, element.base.path)
          |> option.from_result
      }
      let source_field_name = case source_field {
        Some(source_field) -> codegen_helpers.field_name(source_field)
        None ->
          codegen_helpers.field_name(
            codegen_helpers.Element(
              ..element,
              id: element.base.path,
              slice_name: None,
              gleam_field_name: None,
            ),
          )
      }
      let element = case source_field {
        None -> element
        Some(source_field) ->
          codegen_helpers.Element(
            ..element,
            base: codegen_helpers.ElementBase(
              ..element.base,
              min: profile_field_min(source_field),
              max: source_field.max,
            ),
          )
      }
      let is_primitive = False
      let target_min = profile_field_min(element)
      let inner_value = case element.base.min, element.base.max {
        1, "1" -> "source." <> source_field_name
        _, _ -> "value"
      }
      let source_field_type = case source_profile_type, source_field {
        None, _ ->
          case dict.get(context.base_elements, element.base.path) {
            Ok(base_element) ->
              case base_element.type_ {
                [base_field_type] -> {
                  let #(source_field_type, _) =
                    codegen_helpers.string_to_type(
                      base_field_type.code,
                      base_element.base.path |> string.split("."),
                      base_element,
                      context.current_bucket,
                      context.valueset_acc,
                    )
                  Some(source_field_type)
                }
                _ -> None
              }
            Error(_) -> None
          }
        Some(source_type), Some(source_field) -> {
          let #(_, _, _, _, source_field_type) =
            profile_element_names(context, source_type, source_field)
          Some(source_field_type)
        }
        _, _ -> None
      }
      let is_discriminator = case discriminator {
        Some(discriminator) -> discriminator.id == element.id
        None -> False
      }
      let inner = case source_field_type, is_discriminator {
        _, True -> IdentityConversion(field_name, dict.new(), False)
        Some(source_field_type), False if source_field_type == field_type ->
          IdentityConversion(inner_value, dict.new(), False)
        source_field_type, False ->
          field_inner_conversion(
            context,
            element,
            field_path,
            field_type,
            inner_value,
            source_field_type,
            source_definition,
            validation_path,
            failure,
          )
      }
      let converted = case is_discriminator, element.max, slice_json_name {
        True, "1", Some(_) if target_min == 0 ->
          ConversionExpression("Some(" <> field_name <> ")", dict.new(), False)
        True, max, _ if max != "1" ->
          IdentityConversion(field_name, dict.new(), False)
        True, "1", Some(_) -> IdentityConversion(field_name, dict.new(), False)
        _, _, _ ->
          conversion_for_cardinality(
            context.current_bucket,
            inner,
            element,
            "source." <> source_field_name,
            target_min,
            is_primitive,
            failure,
          )
      }
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
        bindings <> binding,
        arguments <> "    " <> field_name <> ":,\n",
        dict.merge(helpers, converted.conversions),
      )
    })
  ConversionSupport(
    source: "fn "
      <> function_name
      <> "(source: "
      <> base_type
      <> case slice_json_name {
      None -> ""
      Some(_) -> ", index: Int"
    }
      <> discriminator_parameter
      <> ") -> Result("
      <> target_type
      <> case slice_json_name {
      None -> ", String) {\n"
      Some(_) -> ", List(decode.DecodeError)) {\n"
    }
      <> fixed_bindings
      <> bindings
      <> "  Ok("
      <> target_type
      <> "(\n"
      <> arguments
      <> "  ))\n}\n\n",
    conversions: helpers,
  )
}

fn generate_conversions(
  context: DecodeContext,
  needed: dict.Dict(String, ConversionRequest),
  generated: dict.Dict(String, String),
) -> dict.Dict(String, String) {
  case dict.to_list(needed) {
    [] -> generated
    [#(function_name, conversion), ..] -> {
      let needed = dict.delete(needed, function_name)
      case dict.has_key(generated, function_name) {
        True -> generate_conversions(context, needed, generated)
        False -> {
          let support = case conversion {
            RecordConversion(function_name, base_type, target_type) -> {
              let encoder =
                base_type
                |> string.split(".")
                |> list.map(codegen_helpers.to_snake_case)
                |> string.join(".")
                |> string.append("_to_json")
              let source =
                "fn "
                <> function_name
                <> "(source: "
                <> base_type
                <> ") -> Result("
                <> target_type
                <> ", String) {\n"
                <> "  json.parse(json.to_string("
                <> encoder
                <> "(source)), "
                <> codegen_helpers.to_snake_case(target_type)
                <> "_decoder()) |> result.replace_error(\"invalid "
                <> target_type
                <> "\")\n}\n\n"
              ConversionSupport(source, dict.new())
            }
            SliceConversion(function_name, parent_type, group, root) ->
              slice_converter_source(
                context,
                parent_type,
                group,
                root,
                function_name,
              )
            ChoiceConversion(
              function_name,
              choice_type,
              element,
              source_type,
              source_element,
            ) ->
              choice_conversion_source(
                context,
                choice_type,
                element,
                source_type,
                source_element,
                function_name,
              )
            ChoiceRecordConversion(
              function_name,
              target_type,
              base_type,
              fields,
            ) ->
              record_conversion_from_fields(
                context,
                target_type,
                base_type,
                fields,
                None,
                None,
                function_name,
              )
          }
          generate_conversions(
            context,
            dict.merge(needed, support.conversions),
            dict.insert(generated, function_name, support.source),
          )
        }
      }
    }
  }
}

fn choice_conversion_source(
  context: DecodeContext,
  choice_type: String,
  element: codegen_helpers.Element,
  source_choice_type: String,
  source_element: Option(codegen_helpers.Element),
  function_name: String,
) -> ConversionSupport {
  let complex_prefix =
    codegen_helpers.bucket_prefix("Quantity", context.current_bucket)
  let base_choice = source_choice_type
  let empty_support = dict.new()
  let #(cases, helpers) =
    list.fold(element.type_, #("", empty_support), fn(acc, choice) {
      let #(cases, helpers) = acc
      let constructor = choice_type <> string.capitalise(choice.code)
      let base_constructor = base_choice <> string.capitalise(choice.code)
      let assert Some(source) = source_element
        as { "missing source definition for " <> element.id }
      let assert Ok(source_choice) =
        list.find(source.type_, fn(candidate) { candidate.code == choice.code })
        as { "missing source choice " <> choice.code <> " for " <> element.id }
      let source_payload =
        codegen_helpers.Element(..source, type_: [source_choice])
      let #(source_type, _) =
        profile_value_type(
          source_choice,
          source_payload,
          string.split(source.base.path, "."),
          context.current_bucket,
          context.datatype_types,
          context.valueset_acc,
        )
      let conversion = case
        dict.get(
          context.type_slice_overrides,
          type_slice_key(element.id, choice.code),
        )
      {
        Ok(TypeSlicePlan(descendants: [_, ..], ..)) -> {
          let sliced_name = constructor <> "Sliced"
          let base_encoder =
            complex_prefix
            <> codegen_helpers.to_snake_case(choice.code)
            <> "_to_json"
          ConversionExpression(
            "json.parse(json.to_string("
              <> base_encoder
              <> "(value)), "
              <> codegen_helpers.to_snake_case(sliced_name)
              <> "_decoder()) |> result.replace_error(\"invalid choice slice\")",
            dict.new(),
            True,
          )
        }
        Ok(TypeSlicePlan(children: [_, ..] as children, ..)) -> {
          let sliced_name = constructor <> "Sliced"
          let base_type =
            base_payload_type(context.current_bucket, element, choice.code)
          let function_name =
            codegen_helpers.to_snake_case(sliced_name)
            <> "_try_from_"
            <> {
              base_type
              |> string.replace(complex_prefix, "")
              |> codegen_helpers.to_snake_case
            }
          let fields =
            list.filter(children, fn(child) {
              child.max != "0"
              && {
                child.fixed_code == None
                && child.fixed_uri == None
                || child.min == 0
                || child.max != "1"
              }
            })
          let conversion =
            ChoiceRecordConversion(
              function_name,
              sliced_name,
              base_type,
              fields,
            )
          ConversionExpression(
            function_name <> "(value)",
            dict.from_list([#(function_name, conversion)]),
            True,
          )
        }
        plan -> {
          let target = case plan {
            Ok(TypeSlicePlan(slice:, children: [], ..)) -> slice
            _ -> codegen_helpers.Element(..element, type_: [choice])
          }
          let #(target_type, _) =
            profile_value_type(
              choice,
              target,
              string.split(element.id, "."),
              context.current_bucket,
              context.datatype_types,
              context.valueset_acc,
            )
          let conversion = case
            list.contains(
              dict.values(context.datatype_types),
              string.replace(target_type, "ct.", ""),
            )
          {
            True ->
              datatype_profile_conversion(
                context,
                source_payload,
                source_type,
                target_type,
                "value",
              )
            False ->
              case
                required_binding_conversion(
                  context.current_bucket,
                  target,
                  choice.code,
                  "value",
                )
              {
                Some(conversion) -> conversion
                None -> {
                  let assert True = source_type == target_type
                    as {
                      "cannot convert choice "
                      <> element.id
                      <> " to "
                      <> target_type
                    }
                  IdentityConversion("value", dict.new(), False)
                }
              }
          }
          conversion
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
        dict.merge(helpers, conversion.conversions),
      )
    })
  ConversionSupport(
    source: "fn "
      <> function_name
      <> "(value: "
      <> base_choice
      <> ") -> Result("
      <> choice_type
      <> ", String) {\n  case value {\n"
      <> cases
      <> "  }\n}\n\n",
    conversions: helpers,
  )
}

fn field_decoder_expression(
  context: DecodeContext,
  parent_type: String,
  element: codegen_helpers.Element,
  whole_field: Bool,
) -> String {
  let complex_prefix =
    codegen_helpers.bucket_prefix("Quantity", context.current_bucket)
  let #(all_parts, field_path, json_name, _, field_type) =
    profile_element_names(context, parent_type, element)
  let is_primitive_slice =
    profile_field_is_primitive_slice(
      element,
      json_name,
      context.type_order,
      field_path,
    )
  let is_primitive = False
  let target_min = profile_field_min(element)
  let restricts_complex_type =
    does_profile_restrict_complex_type(context.type_order, field_path)
  let decoder = case dict.get(context.slice_type_overrides, element.id) {
    Ok(FixedSliceType(discriminator_type, _, system, code, display)) -> {
      let assert [type_] = element.type_
      let base_decoder =
        codegen_decode.string_to_decoder_type(
          type_.code,
          all_parts,
          "r4",
          codegen_helpers.Element(..element, binding: None),
          context.current_bucket,
        )
      let assert Ok(call) =
        codegen_slice_complex_type.discriminator_from_base_call(
          context.current_bucket,
          discriminator_type,
          "value",
          system,
          code,
          display,
        )
      let assert Ok(fallback) =
        codegen_slice_complex_type.discriminator_new_call(
          context.current_bucket,
          discriminator_type,
          context.base_elements,
        )
      let conversion = case call {
        codegen_slice_complex_type.ResultDiscriminatorCall(call) ->
          "case "
          <> call
          <> " { Ok(value) -> decode.success(value) Error(_) -> decode.failure("
          <> fallback
          <> ", \""
          <> discriminator_type
          <> "\") }"
      }
      base_decoder <> " |> decode.then(fn(value) { " <> conversion <> " })"
    }
    _ ->
      case element.type_ {
        [type_] ->
          case
            list.contains(
              dict.values(context.datatype_types),
              string.replace(field_type, "ct.", ""),
            )
          {
            True ->
              complex_prefix
              <> codegen_helpers.to_snake_case(string.replace(
                field_type,
                "ct.",
                "",
              ))
              <> "_decoder()"
            False if restricts_complex_type ->
              codegen_helpers.to_snake_case(field_type) <> "_decoder()"
            False if type_.code == "Element" ->
              complex_prefix
              <> codegen_helpers.to_snake_case(base_payload_type(
                context.current_bucket,
                element,
                "Element",
              ))
              <> "_decoder()"
            False ->
              codegen_decode.decoder_for_type(
                type_.code,
                field_type,
                context.current_bucket,
              )
          }
        [] -> codegen_helpers.to_snake_case(field_type) <> "_decoder()"
        _ -> codegen_helpers.to_snake_case(field_type) <> "_decoder()"
      }
  }
  let decoder = case
    element.type_,
    element.binding,
    string.starts_with(field_type, "valuesets.")
  {
    [codegen_helpers.Type(code: "code", ..)],
      Some(codegen_helpers.Binding(
        strength: "required",
        value_set: Some(value_set),
        available: True,
      )),
      True
    -> {
      let url = canonical_url(value_set)
      let system_id =
        element.id
        |> string.split(".")
        |> list.reverse
        |> list.drop(1)
        |> list.reverse
        |> string.join(".")
        |> string.append(".system")
      let wrapper = {
        use system_element <- result.try(
          list.find(context.snapshot_elements, fn(field) {
            field.id == system_id
          }),
        )
        use system <- result.try(option.to_result(system_element.fixed_uri, Nil))
        use definition <- result.try(dict.get(context.available_valuesets, url))
        case definition {
          codegen_helpers.VocValueset(valueset, package_dir) -> {
            use compose <- result.try(option.to_result(valueset.compose, Nil))
            use _ <- result.try(
              case compose.include.rest, dict.get(context.valueset_acc, url) {
                [], _ -> Ok(Nil)
                _, Ok(codegen_helpers.ValuesetBoundCodingOrCcNeedsSystem) ->
                  Ok(Nil)
                _, _ -> Error(Nil)
              },
            )
            [compose.include.first, ..compose.include.rest]
            |> list.index_map(fn(include, index) { #(include, index + 1) })
            |> list.find_map(fn(entry) {
              let #(include, index) = entry
              case
                codegen_bound_coding.valueset_include_codes(
                  include,
                  codegen_helpers.valueset_codesystems(
                    package_dir,
                    context.available_valuesets,
                  ),
                  False,
                )
              {
                codegen_bound_coding.ValuesetIncludeString(include_system)
                  if include_system == system
                ->
                  Ok(
                    string.drop_start(field_type, string.length("valuesets."))
                    <> codegen_bound_coding.valueset_include_name(
                      include,
                      index,
                    ),
                  )
                _ -> Error(Nil)
              }
            })
          }
          _ -> Error(Nil)
        }
      }
      case wrapper {
        Ok(constructor) ->
          "decode.string |> decode.map(valuesets." <> constructor <> ")"
        Error(_) -> decoder
      }
    }
    _, _, _ -> decoder
  }
  let decoder = case dict.get(context.slice_discriminator_checks, element.id) {
    Ok(FixedSliceType(discriminator_type, _, system, code, display)) -> {
      let assert [type_] = element.type_
      let encoder_call =
        profile_element_encoder_call(
          context.current_bucket,
          element,
          field_type,
          all_parts,
          field_path,
          context.type_order,
          context.slice_type_overrides,
          context.datatype_types,
          context.snapshot_elements,
          "value",
        )
      let base_decoder =
        codegen_decode.string_to_decoder_type(
          type_.code,
          all_parts,
          "r4",
          codegen_helpers.Element(..element, binding: None),
          context.current_bucket,
        )
      let assert Ok(codegen_slice_complex_type.ResultDiscriminatorCall(check)) =
        codegen_slice_complex_type.discriminator_from_base_call(
          context.current_bucket,
          discriminator_type,
          "base_value",
          system,
          code,
          display,
        )
      decoder
      <> " |> decode.then(fn(value) { case json.parse(json.to_string("
      <> encoder_call
      <> "), "
      <> base_decoder
      <> ") { Ok(base_value) -> case "
      <> check
      <> " { Ok(_) -> decode.success(value) Error(_) -> decode.failure(value, \""
      <> discriminator_type
      <> "\") } Error(_) -> decode.failure(value, \""
      <> type_.code
      <> "\") } })"
    }
    _ -> decoder
  }
  let decoder = case
    dict.get(context.slice_type_overrides, element.id)
    |> result.or(dict.get(context.slice_discriminator_checks, element.id))
  {
    Ok(FixedSliceType(discriminator_type, _, system, code, display)) -> {
      let assert [type_] = element.type_
      let fields =
        codegen_slice_complex_type.datatype_fields(
          type_.code,
          context.base_elements,
        )
      let assert Ok(#(_, _, fixed, _)) =
        codegen_slice_complex_type.helper_fields(discriminator_type)
      let direct =
        list.all(fixed, fn(name) {
          list.any(fields, fn(field) {
            codegen_helpers.field_name(field) == name
          })
        })
      let member = case direct {
        True -> None
        False -> {
          let assert Ok(member) =
            list.find(fields, fn(field) {
              case field.type_, field.max {
                [type_], max if max != "1" && max != "0" ->
                  list.all(fixed, fn(name) {
                    list.any(
                      codegen_slice_complex_type.datatype_fields(
                        type_.code,
                        context.base_elements,
                      ),
                      fn(field) { codegen_helpers.field_name(field) == name },
                    )
                  })
                _, _ -> False
              }
            })
          Some(member)
        }
      }
      let parameter_fields = case member {
        None -> fields
        Some(member) -> {
          let assert [type_] = member.type_
          codegen_slice_complex_type.datatype_fields(
            type_.code,
            context.base_elements,
          )
        }
      }
      let pattern =
        codegen_constraint.Object(
          list.map(fixed, fn(name) {
            let literal = case name {
              "system" -> system
              "code" -> code
              "display" -> {
                let assert Some(value) = display
                value
              }
              _ -> panic as { "unknown shared constraint field " <> name }
            }
            #(name, codegen_constraint.Text(literal))
          }),
        )
      let required =
        codegen_slice_complex_type.required_fields(
          discriminator_type,
          parameter_fields,
        )
      let required_checks =
        required
        |> list.map(fn(name) {
          let assert Ok(field) =
            list.find(parameter_fields, fn(field) {
              codegen_helpers.field_name(field) == name
            })
          let assert [type_] = field.type_
          let inner =
            codegen_decode.string_to_decoder_type(
              type_.code,
              string.split(field.path, "."),
              "r4",
              field,
              context.current_bucket,
            )
          "use _ <- decode.field("
          <> json.to_string(json.string(profile_json_field_name(field, "")))
          <> ", "
          <> inner
          <> ")\n"
        })
        |> string.concat
      let validation =
        "{ use _ <- decode.then("
        <> codegen_constraint.sources(pattern, False, "value").1
        <> ")\n"
        <> required_checks
        <> "decode.success(Nil) }"
      let validation = case member {
        None -> validation
        Some(member) -> {
          let name =
            json.to_string(json.string(profile_json_field_name(member, "")))
          let function = codegen_helpers.to_snake_case(discriminator_type)
          case
            string.contains(function, "_list1_"),
            string.contains(function, "_all_")
          {
            True, _ ->
              complex_prefix
              <> "list1_decoder("
              <> name
              <> ", "
              <> validation
              <> ", decode.success)"
            _, True ->
              "decode.optional_field("
              <> name
              <> ", [], decode.list("
              <> validation
              <> "), decode.success)"
            _, _ ->
              "{ use values <- decode.field("
              <> name
              <> ", decode.list(decode.dynamic))\n"
              <> "decode.then({ let candidates = list.index_map(values, fn(value, index) { #({ "
              <> codegen_constraint.sources(pattern, False, "value").0
              <> " }, decode.run(value, "
              <> validation
              <> ") |> result.map_error(fn(errors) { list.map(errors, fn(error) { decode.DecodeError(..error, path: ["
              <> name
              <> ", int.to_string(index), ..error.path]) }) })) })\n"
              <> "case list.any(candidates, fn(candidate) { result.is_ok(candidate.1) }) { True -> decode.success(Nil) False -> { let matching = list.filter(candidates, fn(candidate) { candidate.0 })\n"
              <> "let errors = case list.filter_map(case matching { [] -> candidates _ -> matching }, fn(candidate) { case candidate.1 { Error(errors) -> Ok(errors) Ok(_) -> Error(Nil) } }) { [errors, ..] -> errors [] -> [decode.DecodeError(expected: json.to_string("
              <> codegen_constraint.json_source(pattern)
              <> "), found: \"no matching element\", path: ["
              <> name
              <> "])] }\n"
              <> "decode.failure(Nil, \"matching element\") |> decode.map_errors(fn(_) { errors }) } } }, decode.success) }"
          }
        }
      }
      let fallback = case dict.get(context.slice_type_overrides, element.id) {
        Ok(FixedSliceType(_, _, _, _, _)) -> {
          let assert Ok(fallback) =
            codegen_slice_complex_type.discriminator_new_call(
              context.current_bucket,
              discriminator_type,
              context.base_elements,
            )
          fallback
        }
        _ -> base_slice_placeholder(context, field_type)
      }
      "decode.then(decode.dynamic, fn(raw) { case decode.run(raw, "
      <> validation
      <> ") { Ok(_) -> "
      <> decoder
      <> " Error(errors) -> decode.failure("
      <> fallback
      <> ", "
      <> json.to_string(json.string(field_type))
      <> ") |> decode.map_errors(fn(_) { errors }) } })"
    }
    _ -> decoder
  }
  let decoder = case element.type_ {
    [type_] ->
      case resolve_datatype_profiles(type_, context.datatype_types) {
        [_, _, ..] -> codegen_helpers.to_snake_case(field_type) <> "_decoder()"
        _ -> decoder
      }
    _ -> decoder
  }
  use <- bool.guard(!whole_field, decoder)
  case is_primitive_slice {
    True -> {
      let assert [type_] = element.type_
      let primitive_decoder =
        codegen_decode.string_to_decoder_type(
          type_.code,
          all_parts,
          "r4",
          element,
          context.current_bucket,
        )
      let extension_decoder =
        codegen_helpers.to_snake_case(field_type)
        <> "_extension_slice_decoder()"
      let conversion =
        codegen_helpers.to_snake_case(field_type) <> "_from_primitive"
      case element.base.max, element.max, target_min {
        base_max, "1", minimum if base_max != "1" -> {
          let list_decoder =
            "primitive_slice_list_decoder(\""
            <> json_name
            <> "\", "
            <> primitive_decoder
            <> ", "
            <> extension_decoder
            <> ", "
            <> conversion
          let #(empty, single, failure) = case minimum {
            0 -> #("[] -> decode.success(None) ", "Some(value)", "None")
            _ -> #("", "value", base_slice_placeholder(context, field_type))
          }
          "decode.then("
          <> list_decoder
          <> ", decode.success) |> decode.then(fn(values) { case values { "
          <> empty
          <> "[value] -> decode.success("
          <> single
          <> ") _ -> decode.failure("
          <> failure
          <> ", \""
          <> case minimum {
            0 -> "at most one "
            _ -> "one "
          }
          <> json_name
          <> "\") } }))"
        }
        _, "1", 0 ->
          "decode.then(primitive_decoder(\""
          <> json_name
          <> "\", "
          <> primitive_decoder
          <> ", "
          <> extension_decoder
          <> ", decode.success) |> decode.then(fn(primitive) { case primitive.value, primitive.id, primitive.ext {"
          <> " None, None, [] -> decode.success(None) _, _, _ -> "
          <> conversion
          <> "(primitive) |> decode.map(Some) } }))"
        _, "1", _ ->
          "primitive_choice_slice_decoder(\""
          <> json_name
          <> "\", "
          <> primitive_decoder
          <> ", "
          <> extension_decoder
          <> ", "
          <> conversion
          <> ")"
        _, _, minimum -> {
          let list_decoder =
            "primitive_slice_list_decoder(\""
            <> json_name
            <> "\", "
            <> primitive_decoder
            <> ", "
            <> extension_decoder
            <> ", "
            <> conversion
          case minimum {
            0 -> list_decoder <> ")"
            _ -> {
              let cardinality =
                slice_cardinality_expression(
                  context.current_bucket,
                  element,
                  "values",
                  json_name,
                  False,
                )
              let placeholder =
                slice_cardinality_placeholder(
                  context.current_bucket,
                  element,
                  fn() { base_slice_placeholder(context, field_type) },
                )
              "decode.then("
              <> list_decoder
              <> ", decode.success) |> decode.then(fn(values) { case "
              <> cardinality
              <> " { Ok(values) -> decode.success(values) Error(_) -> decode.failure("
              <> placeholder
              <> ", \"primitive list minimum\") } }))"
            }
          }
        }
      }
    }
    False ->
      case
        element.type_,
        element.base.max,
        element.max,
        target_min,
        is_primitive
      {
        _, base_max, "1", 0, False if base_max != "1" ->
          complex_prefix
          <> "optional_one_from_array_decoder(\""
          <> json_name
          <> "\", "
          <> decoder
          <> ")"
        _, base_max, "1", _, False if base_max != "1" ->
          complex_prefix
          <> "one_from_array_decoder(\""
          <> json_name
          <> "\", "
          <> decoder
          <> ")"
        [_, _, ..], _, _, 0, _ ->
          "decode.then(none_if_omitted(" <> decoder <> "))"
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
}

fn choice_decoder_source(
  context: DecodeContext,
  parent_type: String,
  element: codegen_helpers.Element,
) -> ConversionSupport {
  let #(all_parts, _, json_name, _, choice_type) =
    profile_element_names(context, parent_type, element)
  let decoders =
    list.map(element.type_, fn(choice) {
      let constructor = choice_type <> string.capitalise(choice.code)
      let choice_json_name = {
        let assert [first, ..rest] = choice.code |> string.to_graphemes
        json_name <> string.concat([string.uppercase(first), ..rest])
      }
      let decoder_expression = case
        dict.get(
          context.type_slice_overrides,
          type_slice_key(element.id, choice.code),
        )
      {
        Ok(TypeSlicePlan(slice:, children: [_, ..], ..)) -> {
          let sliced_type =
            codegen_helpers.to_snake_case(constructor <> "Sliced")
          case profile_field_has_primitive_type(slice, "") {
            True ->
              "primitive_choice_slice_decoder(\""
              <> choice_json_name
              <> "\", "
              <> codegen_decode.string_to_decoder_type(
                choice.code,
                all_parts,
                "r4",
                slice,
                context.current_bucket,
              )
              <> ", "
              <> sliced_type
              <> "_extension_slice_decoder(), "
              <> sliced_type
              <> "_from_primitive, decode.success)"
            False ->
              "decode.field(\""
              <> choice_json_name
              <> "\", "
              <> sliced_type
              <> "_decoder(), decode.success)"
          }
        }
        Ok(TypeSlicePlan(slice:, children: [], ..)) ->
          "decode.field(\""
          <> choice_json_name
          <> "\", "
          <> codegen_decode.string_to_decoder_type(
            choice.code,
            all_parts,
            "r4",
            slice,
            context.current_bucket,
          )
          <> ", decode.success)"
        _ -> {
          let #(payload_type, _) =
            profile_base_field_type(
              context.current_bucket,
              codegen_helpers.Element(..element, type_: [choice]),
              all_parts,
              "",
              choice_type,
              context.extensions,
              context.type_order,
              context.slice_base_type_names,
              context.slice_type_overrides,
              context.datatype_types,
              context.valueset_acc,
            )
          let decoder = case
            list.contains(
              dict.values(context.datatype_types),
              string.replace(payload_type, "ct.", ""),
            )
          {
            True ->
              codegen_helpers.bucket_prefix("Quantity", context.current_bucket)
              <> codegen_helpers.to_snake_case(string.replace(
                payload_type,
                "ct.",
                "",
              ))
              <> "_decoder()"
            False ->
              codegen_decode.string_to_decoder_type(
                choice.code,
                all_parts,
                "r4",
                element,
                context.current_bucket,
              )
          }
          "decode.field(\""
          <> choice_json_name
          <> "\", "
          <> decoder
          <> ", decode.success)"
        }
      }
      decoder_expression <> " |> decode.map(" <> constructor <> ")"
    })
  let assert [first, ..rest] = decoders
  let empty_support = ConversionSupport("", dict.new())
  let sliced_decoders =
    list.fold(element.type_, empty_support, fn(source, choice) {
      case
        dict.get(
          context.type_slice_overrides,
          type_slice_key(element.id, choice.code),
        )
      {
        Ok(TypeSlicePlan(descendants: [_, ..], ..)) -> source
        Ok(TypeSlicePlan(slice:, children: [_, ..] as children, ..)) -> {
          let children =
            name_profile_record_fields(
              children,
              context.profile_prefix,
              context.type_order,
            )
          let constructor = choice_type <> string.capitalise(choice.code)
          let sliced_type = constructor <> "Sliced"
          let support =
            slice_support_types_from_fields(context, sliced_type, children)
          let decoder =
            record_decoder_from_fields(
              context,
              sliced_type,
              children,
              None,
              True,
              profile_field_has_primitive_type(slice, ""),
            )
          ConversionSupport(
            source.source <> support <> decoder.source,
            dict.merge(source.conversions, decoder.conversions),
          )
        }
        _ -> source
      }
    })
  ConversionSupport(
    source: sliced_decoders.source
      <> "pub fn "
      <> codegen_helpers.to_snake_case(choice_type)
      <> "_decoder() -> Decoder("
      <> choice_type
      <> ") {\n  decode.one_of(\n    "
      <> first
      <> ",\n    ["
      <> string.join(rest, ",\n      ")
      <> "],\n  )\n}\n\n",
    conversions: sliced_decoders.conversions,
  )
}

fn slice_placeholder(
  context: DecodeContext,
  root: codegen_helpers.Element,
  target_type: String,
) -> String {
  let complex_prefix =
    codegen_helpers.bucket_prefix("Quantity", context.current_bucket)
  case dict.get(context.slice_type_overrides, root.id) {
    Ok(FixedSliceType(discriminator_type, _, _, _, _)) -> {
      let assert Ok(placeholder) =
        codegen_slice_complex_type.discriminator_new_call(
          context.current_bucket,
          discriminator_type,
          context.base_elements,
        )
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
      complex_prefix
      <> "bound_codeableconcept_new(valuesets."
      <> valueset
      <> "_failure_variant)"
    }
    Ok(BoundCodingSlice) -> {
      let assert Some(codegen_helpers.Binding(value_set: Some(value_set), ..)) =
        root.binding
      let valueset =
        value_set
        |> canonical_url
        |> codegen_helpers.concept_name_from_url
        |> codegen_helpers.to_snake_case
      complex_prefix
      <> "bound_coding_new(valuesets."
      <> valueset
      <> "_failure_variant)"
    }
    Error(_) | Ok(FixedValueDiscriminator(_)) ->
      constructor_placeholder(
        context,
        target_type,
        set.new(),
        context.current_bucket,
      )
  }
}

fn slice_group_support_source(
  context: DecodeContext,
  parent_type: String,
  group: codegen_helpers.Element,
  roots: List(codegen_helpers.Element),
  aggregate: Option(#(List(codegen_helpers.Element), Int)),
) -> String {
  let complex_prefix =
    codegen_helpers.bucket_prefix("Quantity", context.current_bucket)
  let extension_group =
    list.any(group.type_, fn(type_) { type_.code == "Extension" })
  let indexed_values =
    profile_field_is_slice_elt(group, roots, context.preserve_slice_order)
  let named_slice_elt_type = fn(type_) {
    case indexed_values, extension_group {
      True, True -> complex_prefix <> "ExtensionSliceElt(" <> type_ <> ")"
      True, False -> complex_prefix <> "SliceElt(" <> type_ <> ")"
      False, _ -> type_
    }
  }
  let open_slice_elt_type = fn(type_) {
    case indexed_values {
      True -> complex_prefix <> "SliceElt(" <> type_ <> ")"
      False -> type_
    }
  }
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
        |> codegen_helpers.to_camel_case
      let parsed_type = parent_type <> "Parsed" <> field_part <> "Slice"
      let slices_type = group_type <> "Slices"
      let accumulator_fields =
        roots
        |> list.map(fn(root) {
          let #(_, _, _, field_name, field_type) =
            profile_element_names(context, parent_type, root)
          "    "
          <> field_name
          <> ": "
          <> case extension_group, root.max {
            True, "1" -> "Option(" <> named_slice_elt_type(field_type) <> ")"
            _, _ -> "List(" <> named_slice_elt_type(field_type) <> ")"
          }
          <> ",\n"
        })
        |> string.concat
      let accumulator_fields = case open {
        True ->
          accumulator_fields
          <> "    open: List("
          <> open_slice_elt_type(base_type)
          <> "),\n"
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
          <> case context.preserve_slice_order, extension_group {
            True, True ->
              complex_prefix <> "ExtensionSliceElt(" <> field_type <> ")"
            _, _ -> field_type
          }
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
        False if extension_group ->
          parsed_variants <> "  " <> parsed_type <> "Ignored\n"
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
          <> codegen_helpers.cardinality(
            named_slice_elt_type(field_type),
            root.min,
            root.max,
          )
          <> ",\n"
        })
        |> string.concat
      let result_fields = case open {
        True ->
          result_fields
          <> "    open: "
          <> codegen_helpers.cardinality(
            open_slice_elt_type(base_type),
            profile_field_min(group),
            group.max,
          )
          <> ",\n"
        False -> result_fields
      }
      "type "
      <> accumulator_type
      <> " {\n  "
      <> accumulator_type
      <> "(\n"
      <> accumulator_fields
      <> "  )\n}\n\n"
      <> case extension_group {
        True ->
          "pub type " <> parsed_type <> " {\n" <> parsed_variants <> "}\n\n"
        False -> "type " <> parsed_type <> " {\n" <> parsed_variants <> "}\n\n"
      }
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

fn slice_support_types_from_fields(
  context: DecodeContext,
  parent_type: String,
  fields: List(codegen_helpers.Element),
) -> String {
  let groups =
    fields
    |> list.filter(fn(group) { group.max != "0" })
    |> list.filter_map(fn(group) {
      let roots = direct_slice_roots(group, fields)
      let is_choice = string.ends_with(group.path, "[x]")
      case
        group.slicing,
        group.base.max,
        list.length(group.type_),
        is_choice,
        roots
      {
        Some(_), base_max, type_count, False, [_, ..]
          if base_max != "1" && type_count <= 1
        -> Ok(#(group, roots, aggregate_value_slice_roots(group, fields)))
        _, _, _, _, _ -> Error(Nil)
      }
    })
  groups
  |> list.map(fn(item) {
    let #(group, roots, aggregate) = item
    slice_group_support_source(context, parent_type, group, roots, aggregate)
  })
  |> string.concat
}

fn slice_support_types(context: DecodeContext, profile_type: String) -> String {
  context.type_order
  |> list.map(fn(current_type) {
    let assert Ok(fields) = dict.get(context.type_fields, current_type)
    let parent_type = profile_type_name(context, current_type, profile_type)
    slice_support_types_from_fields(context, parent_type, fields)
  })
  |> string.concat
}

pub const slice_acc_errors_source =
  "fn slice_acc_errors(result: Result(a, List(decode.DecodeError))) -> List(decode.DecodeError) {\n  case result {\n    Ok(_) -> []\n    Error(errors) -> errors\n  }\n}\n\n"

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
            <> ")]) None -> "
            <> case field.min {
            0 -> "Ok(Nil)"
            _ ->
              "Error([decode.DecodeError(expected: \"Field\", found: \"Nothing\", path: "
              <> field_path
              <> ")])"
          }
            <> " }",
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
      Some(fixed), _, minimum, _ | _, Some(fixed), minimum, _ -> {
        let source = source <> "." <> field_name
        let values = case minimum {
          0 -> source
          1 -> "[" <> source <> ".first, .." <> source <> ".rest]"
          2 ->
            "["
            <> source
            <> ".first, "
            <> source
            <> ".second, .."
            <> source
            <> ".rest]"
          3 ->
            "["
            <> source
            <> ".first, "
            <> source
            <> ".second, "
            <> source
            <> ".third, .."
            <> source
            <> ".rest]"
          _ -> panic as "list min > 3 not supported"
        }
        [
          #(
            result_name,
            "{ let errors = list.index_map("
              <> values
              <> ", fn(found, index) { case found == "
              <> json.to_string(json.string(fixed))
              <> " { True -> [] False -> [decode.DecodeError(expected: "
              <> json.to_string(json.string(fixed))
              <> ", found:, path: list.append("
              <> field_path
              <> ", [int.to_string(index)]))] } }) |> list.flatten\n"
              <> "case errors { [] -> Ok(Nil) _ -> Error(errors) } }",
          ),
          ..results
        ]
      }
      None, None, 0, "1" if field.min > 0 -> [
        #(
          result_name,
          "case "
            <> source
            <> "."
            <> field_name
            <> " { Some(_) -> Ok(Nil) None -> Error([decode.DecodeError(expected: \"Field\", found: \"Nothing\", path: "
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

fn slice_converter_source(
  context: DecodeContext,
  parent_type: String,
  group: codegen_helpers.Element,
  root: codegen_helpers.Element,
  function_name: String,
) -> ConversionSupport {
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
  let #(_, _, _, discriminator_field, discriminator_type) =
    profile_element_names(context, target_type, discriminator)
  let discriminator_parameter_type = case discriminator.max {
    "1" -> discriminator_type
    _ ->
      codegen_helpers.cardinality(
        discriminator_type,
        profile_field_min(discriminator),
        discriminator.max,
      )
  }
  let has_sliced_extensions =
    list.any(target_fields, fn(field) {
      field.slicing != None
      && list.any(field.type_, fn(type_) { type_.code == "Extension" })
    })
  case has_sliced_extensions {
    True ->
      ConversionSupport(
        source: "fn "
          <> function_name
          <> "(source: "
          <> base_type
          <> ", index: Int, "
          <> discriminator_field
          <> " _"
          <> discriminator_field
          <> ": "
          <> discriminator_parameter_type
          <> ") -> Result("
          <> target_type
          <> ", List(decode.DecodeError)) {\n"
          <> "  case json.parse(json.to_string("
          <> {
          base_type
          |> string.split(".")
          |> list.map(codegen_helpers.to_snake_case)
          |> string.join(".")
        }
          <> "_to_json(source)), "
          <> codegen_helpers.to_snake_case(target_type)
          <> "_decoder()) {\n    Ok(value) -> Ok(value)\n    Error(json.UnableToDecode(errors)) -> Error(list.map(errors, fn(error) { decode.DecodeError(..error, path: list.append([\""
          <> json_name
          <> "\", int.to_string(index)], error.path)) }))\n    Error(_) -> Error([decode.DecodeError(expected: \""
          <> target_type
          <> "\", found: \"invalid JSON\", path: [\""
          <> json_name
          <> "\", int.to_string(index)])])\n  }\n}\n\n",
        conversions: dict.new(),
      )
    False ->
      record_conversion_from_fields(
        context,
        target_type,
        base_type,
        profile_fields(target_fields),
        Some(base_type),
        Some(json_name),
        function_name,
      )
  }
}

// Follow only the nominated discriminator path; required fields elsewhere are
// checked by the selected slice's decoder.
fn discriminator_path_source(
  context: DecodeContext,
  element: codegen_helpers.Element,
  parts: List(String),
  input: String,
) -> String {
  case parts {
    [name, ..rest] -> {
      let child = case
        find_element(context.snapshot_elements, element.id <> "." <> name)
      {
        Ok(child) -> child
        Error(_) -> {
          let assert [type_] = element.type_
          let assert Ok(child) =
            dict.get(context.base_elements, type_.code <> "." <> name)
          codegen_helpers.Element(
            ..child,
            id: element.id <> "." <> name,
            path: element.path <> "." <> name,
          )
        }
      }
      let child = case child.constraint, element.constraint {
        None, Some(parent) ->
          case codegen_constraint.field(parent.value, name) {
            Some(value) ->
              codegen_helpers.Element(
                ..child,
                constraint: Some(
                  codegen_constraint.Constraint(..parent, value:),
                ),
              )
            None -> child
          }
        _, _ -> child
      }
      let check = discriminator_path_source(context, child, rest, "value")
      let check = case child.base.max, child.constraint, rest {
        _,
          Some(
            codegen_constraint.Constraint(
              value: codegen_constraint.Array(values),
              fixed:,
              ..,
            ) as constraint,
          ),
          [_, ..]
        -> {
          let checks =
            list.index_map(values, fn(pattern, index) {
              let check =
                discriminator_path_source(
                  context,
                  codegen_helpers.Element(
                    ..child,
                    constraint: Some(
                      codegen_constraint.Constraint(
                        ..constraint,
                        value: pattern,
                      ),
                    ),
                  ),
                  rest,
                  "value",
                )
              case fixed {
                False -> "list.any(values, fn(value) { " <> check <> " })"
                True ->
                  "case list.first(list.drop(values, "
                  <> int.to_string(index)
                  <> ")) { Ok(value) -> { "
                  <> check
                  <> " } Error(_) -> False }"
              }
            })
          let checks = case fixed {
            True -> [
              "list.length(values) == " <> int.to_string(list.length(values)),
              ..checks
            ]
            False -> checks
          }
          "case decode.run(value, decode.list(decode.dynamic)) { Ok(values) -> { "
          <> case checks {
            [] -> "True"
            _ -> string.join(checks, " && ")
          }
          <> " } Error(_) -> False }"
        }
        "1", _, _
        | _,
          Some(codegen_constraint.Constraint(
            value: codegen_constraint.Array(_),
            ..,
          )),
          []
        -> check
        _, _, _ ->
          "case decode.run(value, decode.list(decode.dynamic)) { Ok([]) -> False Ok(values) -> list.all(values, fn(value) { "
          <> check
          <> " }) Error(_) -> False }"
      }
      "case decode.run("
      <> input
      <> ", decode.dict(decode.string, decode.dynamic)) { Ok(fields) -> case dict.get(fields, "
      <> json.to_string(json.string(name))
      <> ") { Ok(value) -> { "
      <> check
      <> " } Error(_) -> False } Error(_) -> False }"
    }
    [] -> {
      case element.constraint, codegen_helpers.constant(element) {
        Some(constraint), _ ->
          codegen_constraint.sources(constraint.value, constraint.fixed, input).0
        _, Some(value) -> codegen_constraint.sources(value, False, input).0
        _, _ -> {
          let prefix = element.id <> "."
          let children =
            list.filter(context.snapshot_elements, fn(child) {
              string.starts_with(child.id, prefix)
              && !string.contains(
                string.drop_start(child.id, string.length(prefix)),
                ".",
              )
              && {
                codegen_helpers.constant(child) != None
                || list.any(context.snapshot_elements, fn(descendant) {
                  string.starts_with(descendant.id, child.id <> ".")
                  && codegen_helpers.constant(descendant) != None
                })
              }
            })
          case children {
            [] ->
              case element.binding {
                Some(codegen_helpers.Binding(
                  strength: "required",
                  available: True,
                  ..,
                )) -> {
                  let decoder =
                    field_decoder_expression(
                      DecodeContext(
                        ..context,
                        type_order: [],
                        slice_type_overrides: dict.new(),
                        slice_discriminator_checks: dict.new(),
                      ),
                      "",
                      codegen_helpers.Element(
                        ..element,
                        type_: list.map(element.type_, fn(type_) {
                          codegen_helpers.Type(..type_, profile: [])
                        }),
                      ),
                      False,
                    )
                  "case decode.run("
                  <> input
                  <> ", "
                  <> decoder
                  <> ") { Ok(_) -> True Error(_) -> False }"
                }
                _ -> "False"
              }
            _ ->
              children
              |> list.map(fn(child) {
                discriminator_path_source(
                  context,
                  element,
                  [string.drop_start(child.id, string.length(prefix))],
                  input,
                )
              })
              |> string.join(" && ")
          }
        }
      }
    }
  }
}

fn slice_discriminator_match_source(
  context: DecodeContext,
  group: codegen_helpers.Element,
  root: codegen_helpers.Element,
  input: String,
) -> String {
  let context =
    DecodeContext(..context, snapshot_elements: context.discriminator_elements)
  let assert Some(slicing) = group.slicing
  let prefix = codegen_helpers.bucket_prefix("Quantity", context.current_bucket)
  let checks =
    slicing.discriminator
    |> list.map(fn(discriminator) {
      case discriminator.type_, discriminator.path {
        "value", path | "pattern", path ->
          discriminator_path_source(
            context,
            root,
            case path {
              "$this" -> []
              path -> string.split(path, ".")
            },
            "value",
          )
        "profile", "$this" -> {
          let assert [codegen_helpers.Type(profile: [url], ..)] = root.type_
          let assert Ok(type_) =
            dict.get(context.datatype_types, canonical_url(url))
          "case decode.run(value, "
          <> prefix
          <> codegen_helpers.to_snake_case(type_)
          <> "_decoder()) { Ok(_) -> True Error(_) -> False }"
        }
        _, _ -> panic as { "unsupported discriminator " <> discriminator.type_ }
      }
    })
    |> string.join(" && ")
  "case decode.run("
  <> input
  <> ", decode.then(decode.dynamic, fn(value) { use <- bool.guard(!{ "
  <> checks
  <> " }, decode.success("
  <> prefix
  <> "DiscriminatorDifferent)) decode.success("
  <> prefix
  <> "DiscriminatorMatches) })) { Ok(matched) -> matched Error(_) -> "
  <> prefix
  <> "DiscriminatorDifferent }"
}

pub const discriminator_match_type_source =
  "pub type DiscriminatorMatch { DiscriminatorMatches DiscriminatorDifferent }\n\n"

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
    |> codegen_helpers.to_camel_case
  }
  <> "Slice"
  <> slice_name_type_part(root)
}

fn slice_cardinality_expression(
  current_bucket: codegen_helpers.Category,
  root: codegen_helpers.Element,
  values: String,
  json_name: String,
  aggregate: Bool,
) -> String {
  let complex_prefix = codegen_helpers.bucket_prefix("Quantity", current_bucket)
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
  let maximum = case root.max {
    "0" | "1" -> root.max
    _ -> "*"
  }
  case root.min, maximum {
    0, "0" ->
      "case "
      <> values
      <> " { [] -> Ok([]) _ -> Error([decode.DecodeError(expected: \"at most 0 "
      <> slice_name
      <> "\", found: int.to_string(list.length("
      <> values
      <> ")), path: [\""
      <> json_name
      <> "\", \""
      <> slice_name
      <> "\"])]) }"
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
      <> " { [first, ..rest] -> Ok("
      <> complex_prefix
      <> "List1(first:, rest:)) [] -> "
      <> missing
      <> " }"
    2, "*" ->
      "case "
      <> values
      <> " { [first, second, ..rest] -> Ok("
      <> complex_prefix
      <> "List2(first:, second:, rest:)) _ -> "
      <> missing
      <> " }"
    3, "*" ->
      "case "
      <> values
      <> " { [first, second, third, ..rest] -> Ok("
      <> complex_prefix
      <> "List3(first:, second:, third:, rest:)) _ -> "
      <> missing
      <> " }"
    _, _ -> panic as "unsupported slice cardinality"
  }
}

fn slice_cardinality_placeholder(
  current_bucket: codegen_helpers.Category,
  root: codegen_helpers.Element,
  placeholder: fn() -> String,
) -> String {
  let complex_prefix = codegen_helpers.bucket_prefix("Quantity", current_bucket)
  let maximum = case root.max {
    "0" | "1" -> root.max
    _ -> "*"
  }
  case root.min, maximum {
    0, "0" -> "[]"
    0, "1" -> "None"
    1, "1" -> placeholder()
    0, "*" -> "[]"
    minimum, "*" -> {
      let placeholder = placeholder()
      case minimum {
        1 -> complex_prefix <> "List1(first: " <> placeholder <> ", rest: [])"
        2 ->
          complex_prefix
          <> "List2(first: "
          <> placeholder
          <> ", second: "
          <> placeholder
          <> ", rest: [])"
        3 ->
          complex_prefix
          <> "List3(first: "
          <> placeholder
          <> ", second: "
          <> placeholder
          <> ", third: "
          <> placeholder
          <> ", rest: [])"
        _ -> panic as "unsupported slice cardinality"
      }
    }
    _, _ -> panic as "unsupported slice cardinality"
  }
}

// Constructor arguments are recorded when their declarations are emitted.
// Decode failures use those arguments instead of inferring a signature.
fn constructor_placeholder(
  context: DecodeContext,
  target_type: String,
  visiting: Set(String),
  definition_bucket: codegen_helpers.Category,
) -> String {
  let name = case string.starts_with(target_type, "ct.") {
    True -> string.drop_start(target_type, 3)
    False -> target_type
  }
  let complex_prefix =
    codegen_helpers.bucket_prefix("Quantity", context.current_bucket)
  let key = constructor_key(definition_bucket, target_type)
  case dict.get(context.constructors, key) {
    Ok(definition) -> {
      let assert False = set.contains(visiting, key)
        as { "recursive required constructor arguments for " <> target_type }
      let visiting = set.insert(visiting, key)
      case definition {
        RecordConstructor(bucket, arguments, _) -> {
          let prefix = case bucket {
            codegen_helpers.ComplexTypes -> complex_prefix
            codegen_helpers.Resources -> ""
          }
          let arguments =
            arguments
            |> list.map(fn(argument) {
              argument.0
              <> ": "
              <> constructor_placeholder(context, argument.1, visiting, bucket)
            })
            |> string.join(", ")
          prefix
          <> codegen_helpers.to_snake_case(name)
          <> "_new("
          <> arguments
          <> ")"
        }
        ChoiceConstructor(bucket, variant, payload_type) -> {
          let prefix = case bucket {
            codegen_helpers.ComplexTypes -> complex_prefix
            codegen_helpers.Resources -> ""
          }
          prefix
          <> variant
          <> "("
          <> constructor_placeholder(context, payload_type, visiting, bucket)
          <> ")"
        }
      }
    }
    Error(_) -> {
      case string.split_once(name, "(") {
        Ok(#(wrapper, payload)) -> {
          let payload = string.drop_end(payload, 1)
          let value = fn() {
            constructor_placeholder(
              context,
              payload,
              visiting,
              definition_bucket,
            )
          }
          case wrapper {
            "List1" ->
              complex_prefix <> "List1(first: " <> value() <> ", rest: [])"
            "List2" ->
              complex_prefix
              <> "List2(first: "
              <> value()
              <> ", second: "
              <> value()
              <> ", rest: [])"
            "List3" ->
              complex_prefix
              <> "List3(first: "
              <> value()
              <> ", second: "
              <> value()
              <> ", third: "
              <> value()
              <> ", rest: [])"
            "ExtensionSliceElt" ->
              complex_prefix
              <> "ExtensionSliceElt(value: "
              <> value()
              <> ", id: None, internal_gleam_fhir_index: None)"
            "SliceElt" -> complex_prefix <> "SliceElt(" <> value() <> ", None)"
            "BoundCoding" ->
              complex_prefix <> "bound_coding_new(" <> value() <> ")"
            "BoundCodeableconcept" ->
              complex_prefix <> "bound_codeableconcept_new(" <> value() <> ")"
            "BoundCodeablereference" ->
              complex_prefix <> "bound_codeablereference_new()"
            "BoundQuantity" -> complex_prefix <> "bound_quantity_new()"
            _ -> panic as { "no constructor default for " <> target_type }
          }
        }
        Error(_) -> {
          case
            codegen_slice_complex_type.discriminator_new_call(
              context.current_bucket,
              "ct." <> name,
              context.base_elements,
            )
          {
            Ok(default) -> default
            Error(_) -> {
              let parts = string.split(target_type, ".")
              case target_type, parts {
                "String", _ -> "\"\""
                "Bool", _ -> "False"
                "Int", _ -> "0"
                "Float", _ -> "0.0"
                "Date", _ -> "pt.Year(1)"
                "DateTime", _ -> "pt.DateNoTime(pt.Year(1))"
                "Time", _ -> "pt.Time(0, 0, 0, None)"
                "Instant", _ ->
                  "pt.Instant(calendar.Date(1, calendar.January, 1), pt.Time(0, 0, 0, None), pt.Z)"
                _, ["valuesets", type_] ->
                  "valuesets." <> string.lowercase(type_) <> "_failure_variant"
                _, _ -> panic as { "missing constructor definition for " <> key }
              }
            }
          }
        }
      }
    }
  }
}

fn base_slice_placeholder(context: DecodeContext, base_type: String) -> String {
  constructor_placeholder(context, base_type, set.new(), context.current_bucket)
}

fn extension_slice_fold_source(
  context: DecodeContext,
  parent_type: String,
  group: codegen_helpers.Element,
  roots: List(codegen_helpers.Element),
  primitive: Bool,
) -> SliceGroupDecode {
  let complex_prefix =
    codegen_helpers.bucket_prefix("Quantity", context.current_bucket)
  let #(_, _, json_name, field_name, base_type) =
    profile_element_names(context, parent_type, group)
  let assert Some(slicing) = group.slicing
  let accumulator_field_names =
    list.map(roots, fn(root) {
      let #(_, _, _, field_name, _) =
        profile_element_names(context, parent_type, root)
      field_name
    })
  let accumulator_field_names = case slicing.rules {
    "open" | "openAtEnd" -> ["open", ..accumulator_field_names]
    _ -> accumulator_field_names
  }
  let group_type = slice_group_type_name(parent_type, group)
  let accumulator_type = group_type <> "SliceAccumulator"
  let assert Ok(field_part) = group.path |> string.split(".") |> list.last
  let parsed_type =
    parent_type <> "Parsed" <> string.capitalise(field_part) <> "Slice"
  let decoder_payload_type = "Result(" <> parsed_type <> ", String)"
  let entry_decoder =
    codegen_helpers.to_snake_case(parent_type)
    <> "_"
    <> field_name
    <> "_slice_decoder"
  let stored_open_value = case context.preserve_slice_order {
    True -> complex_prefix <> "SliceElt(value, Some(index))"
    False -> "value"
  }
  let initial_values =
    roots
    |> list.map(fn(root) {
      case root.max {
        "1" -> "None"
        _ -> "[]"
      }
    })
  let initial_values = case slicing.rules {
    "open" | "openAtEnd" -> list.append(initial_values, ["[]"])
    "closed" -> initial_values
    rules -> panic as { "unknown slicing rule " <> rules }
  }
  let branches =
    roots
    |> list.map(fn(root) {
      let assert Some(extension) =
        profile_extension_definition(root, context.extensions)
        as {
          "Extension slice "
          <> root.id
          <> " requires a referenced Extension profile"
        }
      let #(_, _, _, root_field, _) =
        profile_element_names(context, parent_type, root)
      let variant = parsed_type <> slice_name_type_part(root)
      let decoder = case extension.kind {
        SimpleExtension(value) -> {
          let #(_, decoder) =
            extension_value_branch(
              context.current_bucket,
              extension.name,
              value,
              context.valueset_acc,
              context.available_valuesets,
              extension.primitive_values,
              context.datatype_types,
            )
          decoder <> " |> decode.map(Ok)"
        }
        ComplexExtension(..) ->
          "parse_" <> codegen_helpers.to_snake_case(extension.name) <> "()"
      }
      let named_value = case context.preserve_slice_order {
        True ->
          complex_prefix
          <> "ExtensionSliceElt(value:, id:, internal_gleam_fhir_index: None)"
        False -> "value"
      }
      let decode_branch =
        "      \""
        <> canonical_url(extension.url)
        <> "\" -> "
        <> decoder
        <> " |> decode.map(fn(parsed) { result.map(parsed, fn(value) { "
        <> variant
        <> "("
        <> named_value
        <> ") }) })\n"
      let stored_value = case context.preserve_slice_order {
        True ->
          complex_prefix
          <> "ExtensionSliceElt(..value, internal_gleam_fhir_index: Some(index))"
        False -> "value"
      }
      let stored_value = case root.max {
        "1" -> "Some(" <> stored_value <> ")"
        _ -> "[" <> stored_value <> ", ..accumulator." <> root_field <> "]"
      }
      let fold_branch =
        "                  "
        <> variant
        <> "(value) -> Ok("
        <> codegen_helpers.record_update_source(
          accumulator_type,
          "accumulator",
          accumulator_field_names,
          [#(root_field, stored_value)],
        )
        <> ")\n"
      #(decode_branch, fold_branch)
    })
  let unmatched_decoder = case slicing.rules {
    "open" | "openAtEnd" ->
      complex_prefix
      <> "extension_decoder() |> decode.map(fn(value) { Ok("
      <> parsed_type
      <> "Open(value)) })"
    "closed" -> "decode.success(Ok(" <> parsed_type <> "Ignored))"
    rules -> panic as { "unknown slicing rule " <> rules }
  }
  let unmatched_fold = case slicing.rules {
    "open" | "openAtEnd" ->
      "                  "
      <> parsed_type
      <> "Open(value) -> Ok("
      <> codegen_helpers.record_update_source(
        accumulator_type,
        "accumulator",
        accumulator_field_names,
        [#("open", "[" <> stored_open_value <> ", ..accumulator.open]")],
      )
      <> ")\n"
    "closed" ->
      "                  " <> parsed_type <> "Ignored -> Ok(accumulator)\n"
    _ -> ""
  }
  let support_source =
    "pub fn "
    <> entry_decoder
    <> "() -> Decoder("
    <> decoder_payload_type
    <> ") {\n"
    <> "  use url <- decode.field(\"url\", decode.string)\n"
    <> "  use "
    <> case context.preserve_slice_order {
      True -> "id"
      False -> "_id"
    }
    <> " <- decode.optional_field(\"id\", None, decode.optional(decode.string))\n"
    <> "  decode.then(case url {\n"
    <> string.concat(list.map(branches, fn(branch) { branch.0 }))
    <> "      _ -> "
    <> unmatched_decoder
    <> "\n  }, decode.success)\n}\n\n"
  let base_values = field_name <> "_base_values"
  let accumulator = field_name <> "_accumulator"
  let result_name = field_name <> "_slices"
  let base_values_source = case primitive {
    True -> "  let " <> base_values <> " = primitive.ext\n"
    False ->
      "  use "
      <> base_values
      <> " <- decode.optional_field(\""
      <> json_name
      <> "\", [], decode.list("
      <> entry_decoder
      <> "()))\n"
  }
  let fold_source =
    base_values_source
    <> "  let "
    <> accumulator
    <> " =\n    list.index_fold(\n      "
    <> base_values
    <> ",\n      Ok("
    <> accumulator_type
    <> "("
    <> string.join(initial_values, ", ")
    <> ")),\n"
    <> "      fn(accumulator_result, parsed, index) {\n        case accumulator_result {\n          Error(errors) -> Error(errors)\n          Ok("
    <> "accumulator"
    <> ") ->\n            case parsed {\n              Error(reason) -> Error([decode.DecodeError(expected: \"profile extension\", found: reason, path: [\""
    <> json_name
    <> "\", int.to_string(index)])])\n              Ok(slice) ->\n                case slice {\n"
    <> string.concat(list.map(branches, fn(branch) { branch.1 }))
    <> unmatched_fold
    <> "                }\n            }\n        }\n      },\n    )\n"
  let open_group =
    codegen_helpers.Element(..group, min: profile_field_min(group))
  let open_value = case open_group.min, open_group.max {
    0, "1" ->
      "case list.reverse(accumulator.open) { [value, ..] -> Some(value) [] -> None }"
    _, _ -> "list.reverse(accumulator.open)"
  }
  let open_placeholder = case slicing.rules {
    "open" | "openAtEnd" ->
      slice_cardinality_placeholder(context.current_bucket, open_group, fn() {
        let value = base_slice_placeholder(context, base_type)
        case context.preserve_slice_order {
          True -> complex_prefix <> "SliceElt(" <> value <> ", None)"
          False -> value
        }
      })
    _ -> ""
  }
  let all_optional =
    list.all(roots, fn(root) { root.min == 0 })
    && case slicing.rules {
      "open" | "openAtEnd" -> open_group.min == 0
      _ -> True
    }
  let result_values =
    roots
    |> list.map(fn(root) {
      let #(_, _, _, root_field, _) =
        profile_element_names(context, parent_type, root)
      root_field
    })
  let constructor_fields =
    result_values
    |> list.map(fn(value) {
      let assert Ok(root) =
        list.find(roots, fn(root) {
          let #(_, _, _, root_field, _) =
            profile_element_names(context, parent_type, root)
          root_field == value
        })
      value
      <> ": "
      <> case root.max {
        "1" -> "accumulator." <> value
        _ -> "list.reverse(accumulator." <> value <> ")"
      }
    })
  let constructor_fields = case slicing.rules {
    "open" | "openAtEnd" ->
      list.append(constructor_fields, [
        "open: " <> open_value,
      ])
    "closed" -> constructor_fields
    _ -> constructor_fields
  }
  let result_source = case all_optional {
    True ->
      "  let "
      <> result_name
      <> " = case "
      <> accumulator
      <> " {\n    Ok(accumulator) ->\n      Ok("
      <> group_type
      <> "Slices("
      <> string.join(constructor_fields, ", ")
      <> "))\n    Error(errors) -> Error(errors)\n  }\n"
    False -> {
      let cardinalities =
        roots
        |> list.map(fn(root) {
          let #(_, _, _, root_field, _) =
            profile_element_names(context, parent_type, root)
          #(
            root_field,
            slice_cardinality_expression(
              context.current_bucket,
              root,
              case root.max {
                "1" ->
                  "case accumulator."
                  <> root_field
                  <> " { Some(value) -> [value] None -> [] }"
                _ -> "list.reverse(accumulator." <> root_field <> ")"
              },
              json_name,
              False,
            ),
          )
        })
      let cardinalities = case slicing.rules {
        "open" | "openAtEnd" ->
          list.append(cardinalities, [
            #(
              "open",
              slice_cardinality_expression(
                context.current_bucket,
                open_group,
                "list.reverse(accumulator.open)",
                json_name,
                False,
              ),
            ),
          ])
        _ -> cardinalities
      }
      let bindings =
        cardinalities
        |> list.map(fn(item) {
          "      let " <> item.0 <> " = " <> item.1 <> "\n"
        })
        |> string.concat
      let names = list.map(cardinalities, fn(item) { item.0 })
      let patterns = list.map(names, fn(name) { "Ok(" <> name <> ")" })
      "  let "
      <> result_name
      <> " = case "
      <> accumulator
      <> " {\n    Ok(accumulator) -> {\n"
      <> bindings
      <> "      case "
      <> string.join(names, ", ")
      <> " {\n        "
      <> string.join(patterns, ", ")
      <> " -> Ok("
      <> group_type
      <> "Slices("
      <> { names |> list.map(fn(name) { name <> ":" }) |> string.join(", ") }
      <> "))\n        "
      <> { names |> list.map(fn(_) { "_" }) |> string.join(", ") }
      <> " -> Error(list.flatten(["
      <> {
        names
        |> list.map(fn(name) { "slice_acc_errors(" <> name <> ")" })
        |> string.join(", ")
      }
      <> "]))\n      }\n    }\n    Error(errors) -> Error(errors)\n  }\n"
    }
  }
  let value_fields =
    result_values |> list.map(fn(value) { value <> ":" }) |> string.join(", ")
  let value_fields = case slicing.rules {
    "open" | "openAtEnd" -> value_fields <> ", open: " <> field_name
    _ -> value_fields
  }
  let decoder_placeholder = case all_optional {
    False -> None
    True -> {
      let values =
        roots
        |> list.map(fn(root) {
          case root.max {
            "1" -> "None"
            _ -> "[]"
          }
        })
      let values = case slicing.rules {
        "open" | "openAtEnd" -> list.append(values, [open_placeholder])
        _ -> values
      }
      Some(group_type <> "Slices(" <> string.join(values, ", ") <> ")")
    }
  }
  let placeholder_fields =
    roots
    |> list.map(fn(root) {
      let #(_, _, _, root_field, field_type) =
        profile_element_names(context, parent_type, root)
      let placeholder =
        slice_cardinality_placeholder(context.current_bucket, root, fn() {
          let value = case field_type {
            "String" -> "\"\""
            "Bool" -> "False"
            "Int" -> "0"
            "Float" -> "0.0"
            _ -> base_slice_placeholder(context, field_type)
          }
          case context.preserve_slice_order {
            True ->
              complex_prefix
              <> "ExtensionSliceElt(value: "
              <> value
              <> ", id: None, internal_gleam_fhir_index: None)"
            False -> value
          }
        })
      #(root_field, placeholder)
    })
  let placeholder_fields = case slicing.rules {
    "open" | "openAtEnd" -> [
      #(field_name, open_placeholder),
      ..placeholder_fields
    ]
    _ -> placeholder_fields
  }
  SliceGroupDecode(
    source: fold_source <> result_source,
    conversions: dict.new(),
    support_source:,
    result_name:,
    success_pattern: "Ok(" <> group_type <> "Slices(" <> value_fields <> "))",
    decoded_fields: list.map(placeholder_fields, fn(field) {
      #(
        field.0,
        result_name
          <> "."
          <> case field.0 == field_name {
          True -> "open"
          False -> field.0
        },
      )
    }),
    decoder_placeholder:,
    placeholder_fields:,
    extension_decoder: Some(#(entry_decoder, decoder_payload_type)),
  )
}

fn ordinary_slice_fold_source(
  context: DecodeContext,
  parent_type: String,
  group: codegen_helpers.Element,
  roots: List(codegen_helpers.Element),
  aggregate: Option(#(List(codegen_helpers.Element), Int)),
) -> SliceGroupDecode {
  let complex_prefix =
    codegen_helpers.bucket_prefix("Quantity", context.current_bucket)
  let #(_, field_path, json_name, field_name, base_type) =
    profile_element_names(context, parent_type, group)
  let use_profile_slice_base =
    list.contains(context.type_order, field_path)
    || list.contains(
      dict.values(context.datatype_types),
      string.replace(base_type, "ct.", ""),
    )
  let base_decoder = case
    dict.get(context.slice_type_overrides, group.id),
    use_profile_slice_base
  {
    Ok(FixedSliceType(..)), _ ->
      field_decoder_expression(context, parent_type, group, False)
    _, True ->
      case string.starts_with(base_type, "ct.") {
        True ->
          complex_prefix
          <> codegen_helpers.to_snake_case(string.drop_start(base_type, 3))
          <> "_decoder()"
        False -> codegen_helpers.to_snake_case(base_type) <> "_decoder()"
      }
    _, False ->
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
            context.current_bucket,
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
  let is_aggregate = aggregate != None
  let indexed_values =
    profile_field_is_slice_elt(group, roots, context.preserve_slice_order)
  let indexed = True
  let extension_group =
    list.any(group.type_, fn(type_) { type_.code == "Extension" })
  let stored_named_value = fn(value) {
    case indexed_values, extension_group {
      True, True -> value
      True, False -> complex_prefix <> "SliceElt(" <> value <> ", Some(index))"
      False, _ -> value
    }
  }
  let stored_open_value = fn(value) {
    case indexed_values {
      True -> complex_prefix <> "SliceElt(" <> value <> ", Some(index))"
      False -> value
    }
  }
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
        |> codegen_helpers.to_camel_case
      }
      <> "Slice"
    }
  }
  let assert Some(slicing) = group.slicing
  let accumulator_field_names =
    list.map(roots, fn(root) {
      let #(_, _, _, field_name, _) =
        profile_element_names(context, parent_type, root)
      field_name
    })
  let accumulator_field_names = case slicing.rules {
    "open" | "openAtEnd" -> ["open", ..accumulator_field_names]
    _ -> accumulator_field_names
  }
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
  // Keep the input so selected slice decoders can preserve every profiled field.
  let classifier =
    roots
    |> list.reverse
    |> list.fold(ConversionSupport(unmatched, dict.new()), fn(unmatched, root) {
      let #(_, _, _, _, root_type) =
        profile_element_names(context, parent_type, root)
      let constructor = case is_aggregate {
        True ->
          aggregate_slice_constructor(
            group_type,
            option.unwrap(root.slice_name, ""),
            root_type,
          )
        False -> parsed_slice_constructor(parent_type, group, root)
      }
      let prefix =
        codegen_helpers.bucket_prefix("Quantity", context.current_bucket)
      ConversionSupport(
        source: "case "
          <> slice_discriminator_match_source(
          context,
          group,
          root,
          field_name <> "_raw",
        )
          <> " { "
          <> prefix
          <> "DiscriminatorMatches -> case decode.run("
          <> field_name
          <> "_raw, "
          <> field_decoder_expression(context, parent_type, root, False)
          <> ") { Ok(value) -> Ok("
          <> constructor
          <> "(value)) Error(errors) -> Error(list.map(errors, fn(error) { decode.DecodeError(..error, path: list.append([\""
          <> json_name
          <> "\", int.to_string(index)], error.path)) })) } "
          <> prefix
          <> "DiscriminatorDifferent -> "
          <> unmatched.source
          <> " }",
        conversions: unmatched.conversions,
      )
    })
  let classifier_source =
    "case decode.run("
    <> field_name
    <> "_raw, "
    <> base_decoder
    <> ") { Ok("
    <> field_name
    <> ") -> "
    <> classifier.source
    <> " Error(errors) -> Error(errors) }"
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
          <> codegen_helpers.record_update_source(
            accumulator_type,
            "accumulator",
            accumulator_field_names,
            [
              #(
                root_field,
                "["
                  <> stored_named_value("value")
                  <> ", ..accumulator."
                  <> root_field
                  <> "]",
              ),
            ],
          )
          <> ")\n"
        })
        |> string.concat
      let open = case slicing.rules {
        "open" | "openAtEnd" ->
          "          Ok(accumulator), Ok("
          <> parsed_type
          <> "Open(value)) ->\n            Ok("
          <> codegen_helpers.record_update_source(
            accumulator_type,
            "accumulator",
            accumulator_field_names,
            [
              #(
                "open",
                "[" <> stored_open_value("value") <> ", ..accumulator.open]",
              ),
            ],
          )
          <> ")\n"
        "closed" -> ""
        _ -> ""
      }
      named <> open
    }
  }
  let base_values = field_name <> "_base_values"
  let accumulator = field_name <> "_accumulator"
  let result_name = field_name <> "_slices"
  let fold_function = "list.index_fold"
  let index_parameter = ", index"
  let fold_source =
    "  use "
    <> base_values
    <> " <- decode.optional_field(\""
    <> json_name
    <> "\", [], decode.list("
    <> "decode.dynamic"
    <> "))\n  let "
    <> accumulator
    <> " =\n    "
    <> fold_function
    <> "(\n      "
    <> base_values
    <> ",\n      Ok("
    <> accumulator_type
    <> "("
    <> initial_values
    <> ")),\n      fn(accumulator_result, "
    <> field_name
    <> "_raw"
    <> index_parameter
    <> ") {\n        let parsed: Result("
    <> parsed_type
    <> ", List(decode.DecodeError)) =\n          "
    <> classifier_source
    <> "\n        case accumulator_result, parsed {\n"
    <> accumulate_cases
    <> "          Ok(_), Error(errors) -> Error(errors)\n          Error(errors), Ok(_) -> Error(errors)\n          Error(errors), Error(new_errors) -> Error(list.append(new_errors, errors))\n        }\n      },\n    )\n"
  case aggregate {
    Some(#(_, minimum)) -> {
      let cardinality =
        slice_cardinality_expression(
          context.current_bucket,
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
          context.current_bucket,
          codegen_helpers.Element(..group, min: minimum),
          fn() { open_placeholder },
        )

      SliceGroupDecode(
        source: fold_source <> result_source,
        conversions: classifier.conversions,
        support_source: "",
        result_name:,
        success_pattern: "Ok(" <> field_name <> ")",
        decoded_fields: [#(field_name, result_name)],
        decoder_placeholder: Some(placeholder),
        placeholder_fields: [#(field_name, placeholder)],
        extension_decoder: None,
      )
    }
    None -> {
      let named_cardinalities =
        roots
        |> list.map(fn(root) {
          let #(_, _, _, root_field, _) =
            profile_element_names(context, parent_type, root)
          #(
            root,
            root_field,
            slice_cardinality_expression(
              context.current_bucket,
              root,
              "list.reverse(accumulator." <> root_field <> ")",
              json_name,
              False,
            ),
          )
        })
      let open_group =
        codegen_helpers.Element(..group, min: profile_field_min(group))
      let cardinalities = case slicing.rules {
        "open" | "openAtEnd" ->
          list.append(named_cardinalities, [
            #(
              open_group,
              "open",
              slice_cardinality_expression(
                context.current_bucket,
                open_group,
                "list.reverse(accumulator.open)",
                json_name,
                False,
              ),
            ),
          ])
        _ -> named_cardinalities
      }
      let open_placeholder = case slicing.rules {
        "open" | "openAtEnd" ->
          slice_cardinality_placeholder(
            context.current_bucket,
            open_group,
            fn() {
              let value = base_slice_placeholder(context, base_type)
              stored_open_value(value)
            },
          )
        _ -> ""
      }
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
        list.all(cardinalities, fn(item) {
          item.0.min == 0 && item.0.max == "*"
        })
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
        |> list.map(fn(value) {
          case value {
            "open" -> "open: " <> field_name
            _ -> value <> ":"
          }
        })
        |> string.join(", ")
      let named_placeholder_fields =
        named_cardinalities
        |> list.map(fn(item) {
          let #(root, root_field, _) = item
          #(
            root_field,
            slice_cardinality_placeholder(context.current_bucket, root, fn() {
              let #(_, _, _, _, target_type) =
                profile_element_names(context, parent_type, root)
              let value = slice_placeholder(context, root, target_type)
              case indexed_values, extension_group {
                True, True ->
                  complex_prefix
                  <> "ExtensionSliceElt(value: "
                  <> value
                  <> ", id: None, internal_gleam_fhir_index: None)"
                True, False ->
                  complex_prefix <> "SliceElt(" <> value <> ", None)"
                False, _ -> value
              }
            }),
          )
        })
      let decoder_fields =
        named_placeholder_fields
        |> list.map(fn(field) { field.0 <> ": " <> field.1 })
      let decoder_fields = case slicing.rules {
        "open" | "openAtEnd" ->
          list.append(decoder_fields, ["open: " <> open_placeholder])
        _ -> decoder_fields
      }
      let decoder_placeholder =
        group_type <> "Slices(" <> string.join(decoder_fields, ", ") <> ")"

      let placeholder_fields = case slicing.rules {
        "open" | "openAtEnd" -> [
          #(field_name, open_placeholder),
          ..named_placeholder_fields
        ]
        _ -> named_placeholder_fields
      }
      SliceGroupDecode(
        source: fold_source <> result_source,
        conversions: classifier.conversions,
        support_source: "",
        result_name:,
        success_pattern: "Ok("
          <> group_type
          <> "Slices("
          <> success_fields
          <> "))",
        decoded_fields: list.map(placeholder_fields, fn(field) {
          #(
            field.0,
            result_name
              <> "."
              <> case field.0 == field_name {
              True -> "open"
              False -> field.0
            },
          )
        }),
        decoder_placeholder: Some(decoder_placeholder),
        placeholder_fields:,
        extension_decoder: None,
      )
    }
  }
}

fn slice_fold_source(
  context: DecodeContext,
  parent_type: String,
  group: codegen_helpers.Element,
  roots: List(codegen_helpers.Element),
  aggregate: Option(#(List(codegen_helpers.Element), Int)),
  primitive: Bool,
) -> SliceGroupDecode {
  case
    list.any(group.type_, fn(type_) { type_.code == "Extension" }),
    aggregate
  {
    True, None ->
      extension_slice_fold_source(context, parent_type, group, roots, primitive)
    _, _ ->
      ordinary_slice_fold_source(context, parent_type, group, roots, aggregate)
  }
}

fn slice_group_bindings(
  context: DecodeContext,
  parent_type: String,
  group: codegen_helpers.Element,
  roots: List(codegen_helpers.Element),
  aggregate: Option(#(List(codegen_helpers.Element), Int)),
  primitive: Bool,
) -> SliceGroupDecode {
  slice_fold_source(context, parent_type, group, roots, aggregate, primitive)
}

fn record_decoder_from_fields(
  context: DecodeContext,
  target_type: String,
  fields: List(codegen_helpers.Element),
  resource_type: Option(String),
  omit_fixed: Bool,
  primitive: Bool,
) -> ConversionSupport {
  let primitive_name = case primitive {
    False -> ""
    True -> {
      let assert Ok(root) =
        fields
        |> list.first
        |> result.try(fn(field) {
          let assert Ok(last) = field.id |> string.split(".") |> list.last
          find_element(
            context.snapshot_elements,
            string.drop_end(field.id, string.length(last) + 1),
          )
        })
      profile_json_field_name(root, "")
    }
  }
  let raw_constraints =
    fields
    |> list.filter(fn(field) {
      field.slice_name == None
      && field.max != "0"
      && field.pattern_literals == []
      && codegen_helpers.constraint_needs_check(field)
    })
  let parent =
    fields
    |> list.first
    |> result.try(fn(field) {
      let assert Ok(last) = field.id |> string.split(".") |> list.last
      find_element(
        context.snapshot_elements,
        string.drop_end(field.id, string.length(last) + 1),
      )
    })
  let parent = case parent {
    Ok(parent) ->
      case codegen_helpers.constraint_needs_check(parent) {
        True -> [parent]
        False -> []
      }
    _ -> []
  }
  let constraint_guards =
    list.append(parent, raw_constraints)
    |> list.map(fn(element) {
      let assert Some(constraint) = element.constraint
      let is_parent = list.any(parent, fn(parent) { parent.id == element.id })
      let name = profile_json_field_name(element, "")
      let scalar =
        codegen_constraint.sources(constraint.value, constraint.fixed, "value").1
      let scalar = case is_parent, element.base.max, constraint.value {
        True, _, _ | _, "1", _ | _, _, codegen_constraint.Array(_) -> scalar
        _, _, _ -> "decode.list(" <> scalar <> ") |> decode.map(fn(_) { Nil })"
      }
      let scalar = case primitive && { is_parent || name == "value" } {
        True -> {
          let assert [scalar_type] = element.type_
          let encoded =
            codegen_to_json.string_to_encoder_call(
              scalar_type.code,
              string.split(element.path, "."),
              element,
              context.current_bucket,
              "value",
            )
          "case primitive.value { Some(value) -> case json.parse(json.to_string("
          <> encoded
          <> "), "
          <> scalar
          <> ") { Ok(_) -> decode.success(Nil) Error(json.UnableToDecode(errors)) -> decode.failure(Nil, \"primitive constraint\") |> decode.map_errors(fn(_) { errors }) Error(_) -> decode.failure(Nil, \"primitive constraint JSON\") } None -> "
          <> "decode.failure(Nil, \"Field\") |> decode.map_errors(fn(_) { [decode.DecodeError(expected: \"Field\", found: \"Nothing\", path: [])] })"
          <> " } |> decode.map_errors(fn(errors) { list.map(errors, fn(error) { decode.DecodeError(..error, path: ["
          <> json.to_string(json.string(primitive_name))
          <> ", ..error.path]) }) })"
        }
        False -> scalar
      }
      "  use _ <- "
      <> case primitive && name == "value", is_parent, element.min {
        True, _, _ | _, True, _ -> "decode.then(" <> scalar <> ")"
        _, _, 0 ->
          "decode.optional_field(\"" <> name <> "\", Nil, " <> scalar <> ")"
        _, _, _ -> "decode.field(\"" <> name <> "\", " <> scalar <> ")"
      }
      <> "\n"
    })
    |> string.concat
  let constructor_fields =
    profile_fields(fields)
    |> list.filter(fn(element) {
      let #(_, field_path, json_name, _, _) =
        profile_element_names(context, target_type, element)
      !omit_fixed
      || {
        { codegen_helpers.constant(element) == None }
        || element.min == 0
        || element.max != "1"
      }
      || profile_field_is_primitive_slice(
        element,
        json_name,
        context.type_order,
        field_path,
      )
    })
  let slice_groups =
    fields
    |> list.filter(fn(group) { group.max != "0" })
    |> list.filter_map(fn(group) {
      let roots = direct_slice_roots(group, fields)
      let is_choice = string.ends_with(group.path, "[x]")
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
  let empty_support = ConversionSupport("", dict.new())
  let #(bindings, choices, slice_decodes) =
    list.fold(fields, #("", empty_support, []), fn(acc, element) {
      let #(bindings, choices, slice_decodes) = acc
      let #(_, field_path, json_name, field_name, _) =
        profile_element_names(context, target_type, element)
      case element.pattern_literals, dict.get(slice_groups, element.id) {
        [_, ..], _ -> {
          let entries = field_name <> "_entries"
          let scalar_decoder =
            field_decoder_expression(context, target_type, element, False)
          let source =
            "  use "
            <> entries
            <> " <- decode.field(\""
            <> json_name
            <> "\", decode.list(decode.then(decode.dynamic, fn(raw) { "
            <> scalar_decoder
            <> " |> decode.map(fn(value) { #(value, raw) }) })))\n"
            <> "  let "
            <> entries
            <> " = list.index_map("
            <> entries
            <> ", fn(entry, index) { #(entry, index) })\n"
          let #(source, remaining) =
            list.index_fold(
              element.pattern_literals,
              #(source, entries),
              fn(acc, literal, index) {
                let #(source, previous) = acc
                let index_name =
                  "internal_gleam_fhir_"
                  <> case string.ends_with(field_name, "_others") {
                    True ->
                      string.drop_end(field_name, string.length("_others"))
                    False -> field_name
                  }
                  <> case list.length(element.pattern_literals) {
                    1 -> ""
                    _ -> "_" <> int.to_string(index)
                  }
                  <> "_index"
                let remaining = entries <> "_" <> int.to_string(index)
                let matches =
                  codegen_constraint.sources(literal, False, "entry.0.1").0
                let literal_decoder =
                  codegen_constraint.sources(literal, False, "value").1
                let expected = case literal {
                  codegen_constraint.Text(value) ->
                    json.to_string(json.string(value))
                  _ ->
                    "json.to_string("
                    <> codegen_constraint.json_source(literal)
                    <> ")"
                }
                #(
                  source
                    <> "  let #("
                    <> index_name
                    <> ", "
                    <> remaining
                    <> ") = list.fold("
                    <> previous
                    <> ", #(None, []), fn(acc, entry) { case acc.0 { None -> case { "
                    <> matches
                    <> " } { True -> #(Some(entry.1), acc.1) False -> #(None, [entry, ..acc.1]) } Some(_) -> #(acc.0, [entry, ..acc.1]) } })\n"
                    <> "  use _ <- decode.then(case "
                    <> index_name
                    <> " { Some(_) -> decode.success(Nil) None -> { let errors = case "
                    <> previous
                    <> " { [entry, ..] -> case decode.run(entry.0.1, "
                    <> literal_decoder
                    <> ") { Error(errors) -> list.map(errors, fn(error) { decode.DecodeError(..error, path: ["
                    <> json.to_string(json.string(json_name))
                    <> ", int.to_string(entry.1), ..error.path]) }) Ok(_) -> [decode.DecodeError(expected: "
                    <> expected
                    <> ", found: \"no matching element\", path: ["
                    <> json.to_string(json.string(json_name))
                    <> "])] } [] -> [decode.DecodeError(expected: "
                    <> expected
                    <> ", found: \"no matching element\", path: ["
                    <> json.to_string(json.string(json_name))
                    <> "])] }\n"
                    <> "decode.failure(Nil, "
                    <> expected
                    <> ") |> decode.map_errors(fn(_) { errors }) } })\n"
                    <> "  let "
                    <> remaining
                    <> " = list.reverse("
                    <> remaining
                    <> ")\n",
                  remaining,
                )
              },
            )
          let complex_prefix =
            codegen_helpers.bucket_prefix("Quantity", context.current_bucket)
          let values =
            "list.map("
            <> remaining
            <> ", fn(entry) { "
            <> case context.preserve_slice_order {
              True -> complex_prefix <> "SliceElt(entry.0.0, Some(entry.1))"
              False -> "entry.0.0"
            }
            <> " })"
          let remainder =
            codegen_helpers.Element(
              ..element,
              min: profile_field_min(element),
              max: "*",
              pattern_literals: [],
            )
          let #(_, _, _, _, field_type) =
            profile_element_names(context, target_type, element)
          let placeholder =
            slice_cardinality_placeholder(
              context.current_bucket,
              remainder,
              fn() {
                let value = base_slice_placeholder(context, field_type)
                case context.preserve_slice_order {
                  True -> complex_prefix <> "SliceElt(" <> value <> ", None)"
                  False -> value
                }
              },
            )
          let cardinality =
            slice_cardinality_expression(
              context.current_bucket,
              remainder,
              values,
              json_name,
              False,
            )
          let remainder_binding = case remainder.min {
            0 -> "  let " <> field_name <> " = " <> values <> "\n"
            _ ->
              "  use "
              <> field_name
              <> " <- decode.then(case "
              <> cardinality
              <> " { Ok(value) -> decode.success(value) Error(errors) -> decode.failure("
              <> placeholder
              <> ", \"pattern remainder cardinality\") |> decode.map_errors(fn(_) { errors }) })\n"
          }
          #(bindings <> source <> remainder_binding, choices, slice_decodes)
        }
        [], Ok(roots) -> {
          let aggregate = aggregate_value_slice_roots(element, fields)
          let slice_decode =
            slice_group_bindings(
              context,
              target_type,
              element,
              roots,
              aggregate,
              primitive,
            )
          #(
            bindings <> slice_decode.source,
            ConversionSupport(
              source: choices.source <> slice_decode.support_source,
              conversions: dict.merge(
                choices.conversions,
                slice_decode.conversions,
              ),
            ),
            [slice_decode, ..slice_decodes],
          )
        }
        [], Error(_) ->
          case
            primitive
            && {
              json_name == "value"
              || json_name == "id"
              || json_name == "extension"
            },
            list.contains(slice_root_ids, element.id),
            list.any(constructor_fields, fn(field) { field.id == element.id }),
            omit_fixed
            && element.max != "0"
            && { element.fixed_code != None || element.fixed_uri != None }
          {
            True, _, _, _ | _, True, _, _ | _, _, False, False -> #(
              bindings,
              choices,
              slice_decodes,
            )
            _, _, _, True -> {
              #(
                bindings
                  <> case
                  list.any(constructor_fields, fn(field) {
                    field.id == element.id
                  })
                  || profile_field_is_primitive_slice(
                    element,
                    json_name,
                    context.type_order,
                    field_path,
                  )
                {
                  True ->
                    "  use "
                    <> field_name
                    <> " <- "
                    <> field_decoder_expression(
                      context,
                      target_type,
                      element,
                      True,
                    )
                    <> "\n"
                  False -> ""
                },
                choices,
                slice_decodes,
              )
            }
            _, _, True, False -> {
              #(
                bindings
                  <> "  use "
                  <> field_name
                  <> " <- "
                  <> field_decoder_expression(
                  context,
                  target_type,
                  element,
                  True,
                )
                  <> "\n",
                case element.type_ {
                  [_, _, ..] -> {
                    let generated =
                      choice_decoder_source(context, target_type, element)
                    ConversionSupport(
                      choices.source <> generated.source,
                      dict.merge(choices.conversions, generated.conversions),
                    )
                  }
                  _ -> choices
                },
                slice_decodes,
              )
            }
          }
      }
    })
  // The emitted extension decoder supplies the payload type used below.
  // Every primitive record supplies a decoder, including records with no slices.
  let #(
    primitive_extension_type,
    primitive_extension_source,
    primitive_extension_bindings,
  ) = case primitive {
    False -> #("", "", "")
    True -> {
      let decoder_name =
        codegen_helpers.to_snake_case(target_type) <> "_extension_slice_decoder"
      let extension_decoders =
        list.filter_map(slice_decodes, fn(slice_decode) {
          option.to_result(slice_decode.extension_decoder, Nil)
        })
      case extension_decoders {
        [#(name, payload_type)] -> #(
          payload_type,
          case name == decoder_name {
            True -> ""
            False ->
              "pub fn "
              <> decoder_name
              <> "() -> Decoder("
              <> payload_type
              <> ") {\n  "
              <> name
              <> "()\n}\n\n"
          },
          "",
        )
        [] -> {
          let extension_field =
            list.find(constructor_fields, fn(field) {
              profile_json_field_name(field, "") == "extension"
            })
          let #(payload_type, decoder, bindings) = case extension_field {
            Error(_) -> #("Nil", "decode.success(Nil)", "")
            Ok(field) -> {
              let #(_, _, json_name, field_name, field_type) =
                profile_element_names(context, target_type, field)
              let cardinality =
                slice_cardinality_expression(
                  context.current_bucket,
                  field,
                  "primitive.ext",
                  json_name,
                  False,
                )
              let placeholder =
                slice_cardinality_placeholder(
                  context.current_bucket,
                  field,
                  fn() { base_slice_placeholder(context, field_type) },
                )
              #(
                field_type,
                codegen_decode.decoder_for_type(
                  "Extension",
                  field_type,
                  context.current_bucket,
                ),
                "  use "
                  <> field_name
                  <> " <- decode.then(case "
                  <> cardinality
                  <> " { Ok(value) -> decode.success(value) Error(errors) -> decode.failure("
                  <> placeholder
                  <> ", \"primitive extension cardinality\") |> decode.map_errors(fn(_) { errors }) })\n",
              )
            }
          }
          #(
            payload_type,
            "pub fn "
              <> decoder_name
              <> "() -> Decoder("
              <> payload_type
              <> ") {\n  "
              <> decoder
              <> "\n}\n\n",
            bindings,
          )
        }
        _ ->
          panic as {
            "multiple primitive extension decoders for " <> target_type
          }
      }
    }
  }
  let placeholder_fields =
    slice_decodes
    |> list.flat_map(fn(slice_decode) { slice_decode.placeholder_fields })
    |> dict.from_list
  let placeholder_arguments =
    list.fold(constructor_fields, "", fn(arguments, element) {
      let #(_, _, json_name, field_name, _) =
        profile_element_names(context, target_type, element)
      let indexes = case context.preserve_slice_order {
        False -> ""
        True ->
          element.pattern_literals
          |> list.index_map(fn(_, index) {
            "    internal_gleam_fhir_"
            <> case string.ends_with(field_name, "_others") {
              True -> string.drop_end(field_name, string.length("_others"))
              False -> field_name
            }
            <> case list.length(element.pattern_literals) {
              1 -> ""
              _ -> "_" <> int.to_string(index)
            }
            <> "_index:,\n"
          })
          |> string.concat
      }
      arguments
      <> indexes
      <> "    "
      <> field_name
      <> case primitive, json_name {
        True, "value" -> ": value"
        True, "id" -> ": primitive.id"
        _, _ ->
          case dict.get(placeholder_fields, field_name) {
            Ok(value) -> ": " <> value
            Error(_) -> ":"
          }
      }
      <> ",\n"
    })
  let typed_slice_decoders =
    slice_decodes != []
    && list.all(slice_decodes, fn(slice_decode) {
      slice_decode.decoder_placeholder != None
    })
  let decoded_fields =
    slice_decodes
    |> list.flat_map(fn(slice_decode) { slice_decode.decoded_fields })
    |> dict.from_list
  let arguments =
    list.fold(constructor_fields, "", fn(arguments, element) {
      let #(_, _, json_name, field_name, _) =
        profile_element_names(context, target_type, element)
      let indexes = case context.preserve_slice_order {
        False -> ""
        True ->
          element.pattern_literals
          |> list.index_map(fn(_, index) {
            "    internal_gleam_fhir_"
            <> case string.ends_with(field_name, "_others") {
              True -> string.drop_end(field_name, string.length("_others"))
              False -> field_name
            }
            <> case list.length(element.pattern_literals) {
              1 -> ""
              _ -> "_" <> int.to_string(index)
            }
            <> "_index:,\n"
          })
          |> string.concat
      }
      arguments
      <> indexes
      <> "    "
      <> field_name
      <> case primitive, json_name {
        True, "value" -> ": value"
        True, "id" -> ": primitive.id"
        _, _ ->
          case typed_slice_decoders, dict.get(decoded_fields, field_name) {
            True, Ok(value) -> ": " <> value
            _, _ -> ":"
          }
      }
      <> ",\n"
    })
  let placeholder =
    "  let placeholder = "
    <> target_type
    <> case placeholder_arguments {
      "" -> "\n"
      _ -> "(\n" <> placeholder_arguments <> "  )\n"
    }
  let slice_decoder_bindings = case typed_slice_decoders {
    False -> ""
    True ->
      slice_decodes
      |> list.map(fn(slice_decode) {
        let assert Some(placeholder) = slice_decode.decoder_placeholder
        "  let "
        <> slice_decode.result_name
        <> "_decoder = case "
        <> slice_decode.result_name
        <> " {\n    Ok(value) -> decode.success(value)\n    Error(errors) ->\n      decode.failure("
        <> placeholder
        <> ", \""
        <> target_type
        <> " slices\")\n      |> decode.map_errors(fn(_) { errors })\n  }\n"
      })
      |> string.concat
  }
  let fixed_guards = case omit_fixed {
    False -> ""
    True ->
      fields
      |> list.filter(fn(field) { field.max != "0" })
      |> list.filter_map(fn(element) {
        let fixed = case element.fixed_code, element.fixed_uri {
          Some(fixed), _ | _, Some(fixed) -> Ok(fixed)
          _, _ -> Error(Nil)
        }
        use fixed <- result.try(fixed)
        let json_name = profile_json_field_name(element, "")
        let scalar =
          codegen_constraint.sources(
            codegen_constraint.Text(fixed),
            True,
            "value",
          ).1
        let check = case primitive, json_name {
          True, "value" -> {
            let name = json.to_string(json.string(primitive_name))
            "decode.then(case primitive.value { Some(value) -> case value == "
            <> json.to_string(json.string(fixed))
            <> " { True -> decode.success(Nil) False -> decode.failure(Nil, "
            <> json.to_string(json.string(fixed))
            <> ") |> decode.map_errors(fn(_) { [decode.DecodeError(expected: "
            <> json.to_string(json.string(fixed))
            <> ", found: value, path: ["
            <> name
            <> "])] }) } None -> "
            <> case element.min {
              0 -> "decode.success(Nil)"
              _ ->
                "decode.failure(Nil, \"Field\") |> decode.map_errors(fn(_) { [decode.DecodeError(expected: \"Field\", found: \"Nothing\", path: ["
                <> name
                <> "])] })"
            }
            <> " })"
          }
          _, _ ->
            case element.base.max, element.max, element.min {
              "1", _, 0 ->
                "decode.optional_field("
                <> json.to_string(json.string(json_name))
                <> ", None, decode.optional("
                <> scalar
                <> "))"
              "1", _, _ ->
                "decode.field("
                <> json.to_string(json.string(json_name))
                <> ", "
                <> scalar
                <> ")"
              _, "1", minimum if minimum > 0 ->
                codegen_helpers.bucket_prefix(
                  "Quantity",
                  context.current_bucket,
                )
                <> "one_from_array_decoder("
                <> json.to_string(json.string(json_name))
                <> ", "
                <> scalar
                <> ")"
              _, _, 0 ->
                "decode.optional_field("
                <> json.to_string(json.string(json_name))
                <> ", [], decode.list("
                <> scalar
                <> "))"
              _, _, _ ->
                "decode.field("
                <> json.to_string(json.string(json_name))
                <> ", decode.list("
                <> scalar
                <> "))"
            }
        }
        Ok("  use _ <- " <> check <> "\n")
      })
      |> string.concat
  }
  let resource_guard = case resource_type {
    None -> ""
    Some(resource_type) ->
      "  use _ <- decode.field(\"resourceType\", "
      <> codegen_constraint.sources(
        codegen_constraint.Text(resource_type),
        True,
        "value",
      ).1
      <> ")\n"
  }
  let result = case typed_slice_decoders, slice_decodes {
    True, slice_decodes -> {
      let decoder_uses =
        slice_decodes
        |> list.map(fn(slice_decode) {
          "  use "
          <> slice_decode.result_name
          <> " <- decode.then("
          <> slice_decode.result_name
          <> "_decoder)\n"
        })
        |> string.concat
      decoder_uses
      <> "  decode.success("
      <> target_type
      <> "(\n"
      <> arguments
      <> "  ))\n"
    }
    False, [] -> "  decode.success(placeholder)\n"
    False, slice_decodes -> {
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
  let #(primitive_value_type, primitive_value_binding) = case primitive {
    False -> #("", "")
    True -> {
      let assert Ok(value_field) =
        list.find(fields, fn(element) {
          profile_json_field_name(element, "") == "value"
        })
      let #(_, _, _, _, field_type) =
        profile_element_names(context, target_type, value_field)
      let assert [scalar_type] = value_field.type_
      let scalar_decoder =
        codegen_decode.decoder_for_type(
          scalar_type.code,
          field_type,
          context.current_bucket,
        )
      #(field_type, case value_field.min {
        0 -> "  let value = primitive.value\n"
        _ ->
          "  use value <- decode.then(case primitive.value { Some(value) -> decode.success(value) None -> decode.field("
          <> json.to_string(json.string(primitive_name))
          <> ", "
          <> scalar_decoder
          <> ", decode.success) })\n"
      })
    }
  }
  ConversionSupport(
    source: primitive_extension_source
      <> choices.source
      <> "pub fn "
      <> codegen_helpers.to_snake_case(target_type)
      <> case primitive {
      True ->
        "_from_primitive(\n  primitive: Primitive("
        <> primitive_value_type
        <> ", "
        <> primitive_extension_type
        <> "),\n) -> Decoder("
        <> target_type
        <> ") {\n"
      False ->
        "_decoder() -> Decoder("
        <> target_type
        <> ") {\n  use <- decode.recursive\n"
    }
      <> constraint_guards
      <> primitive_value_binding
      <> primitive_extension_bindings
      <> bindings
      <> slice_decoder_bindings
      <> case typed_slice_decoders {
      True -> ""
      False -> placeholder
    }
      <> fixed_guards
      <> resource_guard
      <> result
      <> "}\n\n",
    conversions: choices.conversions,
  )
}

fn extension_value_branch(
  current_bucket: codegen_helpers.Category,
  extension_name: String,
  field: codegen_helpers.Element,
  valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
  _available_valuesets: dict.Dict(String, codegen_helpers.VsOrCs),
  primitive_values: dict.Dict(String, PrimitiveExtensionValue),
  datatype_types: dict.Dict(String, String),
) -> #(String, String) {
  let complex_prefix = codegen_helpers.bucket_prefix("Quantity", current_bucket)
  let raw_field_name = extension_field_name(field)
  let field_name = codegen_helpers.field_name(field)
  let choice_name = extension_name <> string.capitalise(raw_field_name)
  let alternatives =
    list.map(field.type_, fn(type_) {
      let key = case field.type_ {
        [_] -> field.id
        _ -> field.id <> "|" <> type_.code
      }
      let primitive_value = dict.get(primitive_values, key)
      let narrowed = case primitive_value {
        Ok(profile) -> {
          let assert [root, ..] = profile.elements
          codegen_helpers.Element(..root, id: field.id, path: field.path)
        }
        Error(_) -> codegen_helpers.Element(..field, type_: [type_])
      }
      let #(target_type, _) =
        profile_value_type(
          type_,
          narrowed,
          [extension_name, field_name],
          current_bucket,
          datatype_types,
          valueset_acc,
        )
      let scalar_decoder = case
        list.contains(
          dict.values(datatype_types),
          string.replace(target_type, "ct.", ""),
        )
      {
        True ->
          complex_prefix
          <> codegen_helpers.to_snake_case(string.replace(
            target_type,
            "ct.",
            "",
          ))
          <> "_decoder()"
        False ->
          codegen_decode.string_to_decoder_type(
            type_.code,
            [extension_name, field_name],
            "r4",
            narrowed,
            current_bucket,
          )
      }
      let assert [first, ..rest] = string.to_graphemes(type_.code)
      let value_name = "value" <> string.uppercase(first) <> string.concat(rest)
      let #(target_type, decoder) = case primitive_value {
        Ok(profile) -> #(
          complex_prefix <> profile.name,
          complex_prefix
            <> "primitive_choice_slice_decoder(\""
            <> value_name
            <> "\", "
            <> scalar_decoder
            <> ", "
            <> complex_prefix
            <> codegen_helpers.to_snake_case(profile.name)
            <> "_extension_slice_decoder(), "
            <> complex_prefix
            <> codegen_helpers.to_snake_case(profile.name)
            <> "_from_primitive, decode.success)",
        )
        Error(_) -> #(
          target_type,
          "decode.field(\""
            <> value_name
            <> "\", "
            <> scalar_decoder
            <> ", decode.success)",
        )
      }
      case field.type_ {
        [_] -> #(target_type, decoder)
        _ -> #(
          complex_prefix <> choice_name,
          decoder
            <> " |> decode.map("
            <> complex_prefix
            <> choice_name
            <> string.capitalise(type_.code)
            <> ")",
        )
      }
    })
  let assert [#(target_type, first), ..rest] = alternatives
  let decoder = case rest {
    [] -> first
    _ ->
      "decode.one_of("
      <> first
      <> ", ["
      <> string.join(list.map(rest, fn(alternative) { alternative.1 }), ", ")
      <> "])"
  }
  #(target_type, decoder)
}

fn extension_classifier_source(
  current_bucket: codegen_helpers.Category,
  extension: ExtensionDefinition,
  valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
  available_valuesets: dict.Dict(String, codegen_helpers.VsOrCs),
  extensions: dict.Dict(String, ExtensionDefinition),
  preserve_slice_order: Bool,
  datatype_types: dict.Dict(String, String),
) -> String {
  let complex_prefix = codegen_helpers.bucket_prefix("Quantity", current_bucket)
  case extension.kind {
    SimpleExtension(_) -> ""
    ComplexExtension(
      [codegen_helpers.Element(path: "Extension.value[x]", ..) as field],
      _,
    ) -> {
      let field_name = codegen_helpers.field_name(field)
      let store = fn(value) {
        let stored_value = case preserve_slice_order {
          True ->
            complex_prefix
            <> "ExtensionSliceElt(value: "
            <> value
            <> ", id: None, internal_gleam_fhir_index: None)"
          False -> value
        }
        let stored_value = case field.min {
          0 -> "Some(" <> stored_value <> ")"
          _ -> stored_value
        }
        "Ok("
        <> complex_prefix
        <> extension.name
        <> "("
        <> field_name
        <> ": "
        <> stored_value
        <> "))"
      }
      let #(_, decoder) =
        extension_value_branch(
          current_bucket,
          extension.name,
          field,
          valueset_acc,
          available_valuesets,
          extension.primitive_values,
          datatype_types,
        )
      "fn parse_"
      <> codegen_helpers.to_snake_case(extension.name)
      <> "() -> Decoder(Result("
      <> complex_prefix
      <> extension.name
      <> ", String)) {\n  "
      <> decoder
      <> " |> decode.map(fn(value) { "
      <> store("value")
      <> " })\n}\n\n"
    }
    ComplexExtension(fields, slicing_rules) -> {
      let open = slicing_rules != "closed"
      let accumulator_name = extension.name <> "ExtensionAccumulator"
      let parsed_type = extension.name <> "ParsedExtensionSlice"
      let child_decoder =
        "parse_" <> codegen_helpers.to_snake_case(extension.name) <> "_child"
      let accumulator_field_names = list.map(fields, codegen_helpers.field_name)
      let accumulator_field_names = case open {
        True -> ["open", ..accumulator_field_names]
        False -> accumulator_field_names
      }
      let branches =
        list.map(fields, fn(field) {
          let assert Ok(field_url) = field.id |> string.split(".") |> list.last
          let field_name = codegen_helpers.field_name(field)
          let store = fn(value) {
            let stored_value = case preserve_slice_order {
              True ->
                complex_prefix
                <> "ExtensionSliceElt("
                <> case value {
                  "value" -> "value:"
                  _ -> "value: " <> value
                }
                <> ", id: id, internal_gleam_fhir_index: Some(index))"
              False -> value
            }
            let stored_value = case field.max {
              "1" -> "Some(" <> stored_value <> ")"
              _ ->
                "[" <> stored_value <> ", ..accumulator." <> field_name <> "]"
            }
            "Ok("
            <> codegen_helpers.record_update_source(
              accumulator_name,
              "accumulator",
              accumulator_field_names,
              [#(field_name, stored_value)],
            )
            <> ")"
          }
          let #(field_type, decoder) = case
            profile_extension_definition(field, extensions)
          {
            Some(
              ExtensionDefinition(kind: SimpleExtension(value), ..) as nested,
            ) -> {
              let #(type_, decoder) =
                extension_value_branch(
                  current_bucket,
                  nested.name,
                  value,
                  valueset_acc,
                  available_valuesets,
                  nested.primitive_values,
                  datatype_types,
                )
              #(type_, decoder <> " |> decode.map(Ok)")
            }
            Some(nested) -> #(
              complex_prefix <> nested.name,
              "parse_" <> codegen_helpers.to_snake_case(nested.name) <> "()",
            )
            None -> {
              let #(type_, decoder) =
                extension_value_branch(
                  current_bucket,
                  extension.name,
                  field,
                  valueset_acc,
                  available_valuesets,
                  extension.primitive_values,
                  datatype_types,
                )
              #(type_, decoder <> " |> decode.map(Ok)")
            }
          }
          let variant =
            parsed_type
            <> codegen_helpers.to_camel_case(extension_field_name(field))
          let decode_branch =
            "      \""
            <> field_url
            <> "\" -> "
            <> decoder
            <> " |> decode.map(fn(parsed) { result.map(parsed, fn(value) { "
            <> variant
            <> "(id, value) }) })\n"
          let fold_branch =
            "                      "
            <> variant
            <> "("
            <> case preserve_slice_order {
              True -> "id"
              False -> "_id"
            }
            <> ", value) -> "
            <> store("value")
            <> "\n"
          #(field_type, #(decode_branch, fold_branch))
        })
      let accumulator_fields =
        fields
        |> list.zip(branches)
        |> list.map(fn(item) {
          let #(field, #(field_type, _)) = item
          let field_name = codegen_helpers.field_name(field)
          let stored_type = case preserve_slice_order {
            True -> complex_prefix <> "ExtensionSliceElt(" <> field_type <> ")"
            False -> field_type
          }
          let stored_type = case field.max {
            "1" -> "Option(" <> stored_type <> ")"
            _ -> "List(" <> stored_type <> ")"
          }
          "    " <> field_name <> ": " <> stored_type <> ",\n"
        })
        |> string.concat
      let accumulator_fields = case open {
        True -> {
          let open_type = case preserve_slice_order {
            True ->
              complex_prefix <> "SliceElt(" <> complex_prefix <> "Extension)"

            False -> complex_prefix <> "Extension"
          }
          accumulator_fields <> "    open: List(" <> open_type <> "),\n"
        }
        False -> accumulator_fields
      }
      let initial_values =
        fields
        |> list.map(fn(field) {
          case field.max {
            "1" -> "None"
            _ -> "[]"
          }
        })
        |> fn(values) {
          case open {
            True -> list.append(values, ["[]"])
            False -> values
          }
        }
        |> string.join(", ")
      let unmatched = case open, preserve_slice_order {
        True, True ->
          "                      "
          <> parsed_type
          <> "Open(child) -> Ok("
          <> codegen_helpers.record_update_source(
            accumulator_name,
            "accumulator",
            accumulator_field_names,
            [
              #(
                "open",
                "["
                  <> complex_prefix
                  <> "SliceElt(child, Some(index))"
                  <> ", ..accumulator.open]",
              ),
            ],
          )
          <> ")\n"
        True, False ->
          "                      "
          <> parsed_type
          <> "Open(child) -> Ok("
          <> codegen_helpers.record_update_source(
            accumulator_name,
            "accumulator",
            accumulator_field_names,
            [#("open", "[child, ..accumulator.open]")],
          )
          <> ")\n"
        False, _ -> ""
      }
      let child_cases =
        string.concat(list.map(branches, fn(branch) { branch.1.1 }))
        <> unmatched
      let variants =
        fields
        |> list.zip(branches)
        |> list.map(fn(item) {
          let #(field, #(field_type, _)) = item
          "  "
          <> parsed_type
          <> codegen_helpers.to_camel_case(extension_field_name(field))
          <> "(Option(String), "
          <> field_type
          <> ")\n"
        })
        |> string.concat
      let variants = case open {
        True ->
          variants
          <> "  "
          <> parsed_type
          <> "Open("
          <> complex_prefix
          <> "Extension)\n"
        False -> variants
      }
      let unmatched_decoder = case open {
        True ->
          complex_prefix
          <> "extension_decoder() |> decode.map(fn(value) { Ok("
          <> parsed_type
          <> "Open(value)) })"
        False ->
          "decode.failure(Error(\"unmatched extension\"), \"one permitted slice\")"
      }
      let child_decoder_source =
        "type "
        <> parsed_type
        <> " {\n"
        <> variants
        <> "}\n\n"
        <> "fn "
        <> child_decoder
        <> "() -> Decoder(Result("
        <> parsed_type
        <> ", String)) {\n"
        <> "  use url <- decode.field(\"url\", decode.string)\n"
        <> "  use id <- decode.optional_field(\"id\", None, decode.optional(decode.string))\n"
        <> "  decode.then(case url {\n"
        <> string.concat(list.map(branches, fn(branch) { branch.1.0 }))
        <> "      _ -> "
        <> unmatched_decoder
        <> "\n  }, decode.success)\n}\n\n"
      let constructor_fields =
        fields
        |> list.map(fn(field) {
          let name = codegen_helpers.field_name(field)
          case field.min, field.max {
            0, "1" -> name <> ": accumulator." <> name
            0, _ -> name <> ": list.reverse(accumulator." <> name <> ")"
            _, _ -> name <> ":"
          }
        })
      let constructor_fields = case open {
        True -> [
          "extension: list.reverse(accumulator.open)",
          ..constructor_fields
        ]
        False -> constructor_fields
      }
      let finish =
        "Ok("
        <> complex_prefix
        <> ""
        <> extension.name
        <> "("
        <> string.join(constructor_fields, ", ")
        <> "))"
      let finish =
        fields
        |> list.reverse
        |> list.fold(finish, fn(finish, field) {
          let field_name = codegen_helpers.field_name(field)
          case field.min, field.max {
            0, "1" -> finish
            1, "1" ->
              "case accumulator."
              <> field_name
              <> " { None -> Error(\"required extension "
              <> field_name
              <> "\") Some("
              <> field_name
              <> ") -> "
              <> finish
              <> " }"
            0, _ -> finish
            minimum, "*" -> {
              let pattern = case minimum {
                1 -> "[first, ..rest]"
                2 -> "[first, second, ..rest]"
                3 -> "[first, second, third, ..rest]"
                _ -> panic as "unsupported extension cardinality"
              }
              let value = case minimum {
                1 -> complex_prefix <> "List1(first:, rest:)"

                2 -> complex_prefix <> "List2(first:, second:, rest:)"

                3 -> complex_prefix <> "List3(first:, second:, third:, rest:)"

                _ -> panic as "unsupported extension cardinality"
              }
              "case list.reverse(accumulator."
              <> field_name
              <> ") { "
              <> pattern
              <> " -> { let "
              <> field_name
              <> " = "
              <> value
              <> " "
              <> finish
              <> " } _ -> Error(\"required extension "
              <> field_name
              <> "\") }"
            }
            _, _ -> panic as "unsupported extension cardinality"
          }
        })
      let fold_function = case preserve_slice_order {
        True -> "list.index_fold"
        False -> "list.fold"
      }
      let index_parameter = case preserve_slice_order {
        True -> ", index"
        False -> ""
      }
      let body =
        "{\n      let accumulator: Result("
        <> accumulator_name
        <> ", String) =\n        "
        <> fold_function
        <> "(\n          children,\n          Ok("
        <> accumulator_name
        <> "("
        <> initial_values
        <> ")),\n          fn(accumulator_result, child"
        <> index_parameter
        <> ") {\n            case accumulator_result {\n              Error(reason) -> Error(reason)\n              Ok(accumulator) ->\n                case child {\n                  Error(reason) -> Error(reason)\n                  Ok(slice) ->\n                    case slice {\n"
        <> child_cases
        <> "                    }\n                }\n            }\n          },\n        )\n      case accumulator {\n        Error(reason) -> Error(reason)\n        Ok(accumulator) ->\n          "
        <> finish
        <> "\n      }\n    }"
      let support_source =
        "type "
        <> accumulator_name
        <> " {\n  "
        <> accumulator_name
        <> "(\n"
        <> accumulator_fields
        <> "  )\n}\n\n"
      support_source
      <> child_decoder_source
      <> "fn parse_"
      <> codegen_helpers.to_snake_case(extension.name)
      <> "() -> Decoder(Result("
      <> complex_prefix
      <> extension.name
      <> ", String)) {\n"
      <> "  use children <- decode.field(\"extension\", decode.list("
      <> child_decoder
      <> "()))\n"
      <> "  decode.success("
      <> body
      <> ")\n}\n\n"
    }
  }
}

pub fn generate_decoders(
  context: DecodeContext,
  profile_type: String,
  generated_extension_classifiers: Set(String),
) -> #(String, Set(String)) {
  let DecodeContext(
    current_bucket:,
    resource_type:,
    is_resource:,
    discriminator_elements: _,
    snapshot_elements:,
    profile_prefix:,
    type_order:,
    type_fields:,
    extensions:,
    slice_base_type_names: _,
    slice_type_overrides: _,
    datatype_types:,
    profile_unions:,
    nested_value_discriminators: _,
    slice_discriminator_checks: _,
    type_slice_overrides: _,
    preserve_slice_order:,
    valueset_acc:,
    available_valuesets:,
    base_elements: _,
    constructors: _,
  ) = context
  let referenced_urls =
    snapshot_elements
    |> list.flat_map(fn(element) {
      element.type_
      |> list.flat_map(fn(type_) {
        case type_.code {
          "Extension" -> list.map(type_.profile, canonical_url)
          _ -> []
        }
      })
    })
    |> set.from_list
  let referenced_urls =
    dict.values(extensions)
    |> list.fold(referenced_urls, fn(urls, _) {
      dict.fold(extensions, urls, fn(urls, url, extension) {
        case set.contains(urls, url) {
          False -> urls
          True -> {
            let fields = case extension.kind {
              SimpleExtension(field) -> [field]
              ComplexExtension(fields, _) -> fields
            }
            fields
            |> list.fold(urls, fn(urls, field) {
              field.type_
              |> list.fold(urls, fn(urls, type_) {
                set.union(
                  urls,
                  set.from_list(list.map(type_.profile, canonical_url)),
                )
              })
            })
          }
        }
      })
    })
  let extension_items =
    context.extensions
    |> dict.to_list
    |> list.filter(fn(item) {
      !set.contains(generated_extension_classifiers, item.0)
      && set.contains(referenced_urls, item.0)
    })
    |> list.sort(fn(a, b) { string.compare(a.0, b.0) })
  let extension_classifiers =
    extension_items
    |> list.fold("", fn(source, item) {
      source
      <> extension_classifier_source(
        current_bucket,
        item.1,
        valueset_acc,
        available_valuesets,
        extensions,
        preserve_slice_order,
        datatype_types,
      )
    })
  let generated_extension_classifiers =
    extension_items
    |> list.map(fn(item) { item.0 })
    |> set.from_list
    |> set.union(generated_extension_classifiers)
  let union_decoders =
    profile_unions
    |> dict.to_list
    |> list.sort(fn(a, b) { string.compare(a.0, b.0) })
    |> list.map(fn(item) {
      let #(path, profiles) = item
      let name =
        path |> string.replace("[x]", "") |> codegen_helpers.to_camel_case
      let prefix = codegen_helpers.bucket_prefix("Quantity", current_bucket)
      let checks =
        dict.get(type_fields, path)
        |> result.unwrap([])
        |> list.filter(fn(field) {
          field.max != "0" && field.slice_name == None
        })
        |> list.map(fn(field) {
          let #(_, _, json_name, _, _) =
            profile_element_names(context, name, field)
          let expression = case field.fixed_code, field.fixed_uri {
            None, None -> field_decoder_expression(context, name, field, True)
            Some(fixed), _ | _, Some(fixed) -> {
              let scalar =
                codegen_constraint.sources(
                  codegen_constraint.Text(fixed),
                  True,
                  "value",
                ).1
              case field.base.max, field.max, field.min {
                base_max, "1", 0 if base_max != "1" ->
                  prefix
                  <> "optional_one_from_array_decoder(\""
                  <> json_name
                  <> "\", "
                  <> scalar
                  <> ")"
                base_max, "1", _ if base_max != "1" ->
                  prefix
                  <> "one_from_array_decoder(\""
                  <> json_name
                  <> "\", "
                  <> scalar
                  <> ")"
                _, _, _ ->
                  codegen_decode.field_decoder(
                    json_name,
                    scalar,
                    field.min,
                    field.max,
                    False,
                  )
              }
            }
          }
          "  use _ <- " <> expression <> "\n"
        })
        |> string.concat
      let branches =
        list.map(profiles, fn(profile) {
          prefix
          <> codegen_helpers.to_snake_case(profile)
          <> "_decoder() |> decode.map("
          <> name
          <> profile
          <> ")"
        })
      let assert [first, ..rest] = branches
      "pub fn "
      <> codegen_helpers.to_snake_case(name)
      <> "_decoder() -> Decoder("
      <> name
      <> ") {\n  use <- decode.recursive\n"
      <> checks
      <> "  decode.one_of("
      <> first
      <> ", ["
      <> string.join(rest, ", ")
      <> "])\n}\n\n"
    })
    |> string.concat
  let empty_support = ConversionSupport("", dict.new())
  let decoders =
    list.fold(type_order, empty_support, fn(source, current_type) {
      let assert Ok(fields) = dict.get(type_fields, current_type)
      let target_type = profile_type_name(context, current_type, profile_type)
      let omit_fixed =
        list.any(fields, fn(field) { codegen_helpers.constant(field) != None })
      let generated =
        record_decoder_from_fields(
          context,
          target_type,
          fields,
          case current_type == profile_prefix && is_resource {
            True -> Some(resource_type)
            False -> None
          },
          omit_fixed,
          is_primitive_slice_record(
            snapshot_elements,
            profile_prefix,
            type_order,
            current_type,
          ),
        )
      ConversionSupport(
        source.source <> generated.source,
        dict.merge(source.conversions, generated.conversions),
      )
    })
  let support = slice_support_types(context, profile_type)
  let conversions =
    generate_conversions(context, decoders.conversions, dict.new())
    |> dict.to_list
    |> list.sort(fn(left, right) { string.compare(left.0, right.0) })
    |> list.map(fn(item) { item.1 })
    |> string.concat
  #(
    extension_classifiers
      <> union_decoders
      <> support
      <> conversions
      <> decoders.source,
    generated_extension_classifiers,
  )
}

pub fn generate_to_json(
  current_bucket: codegen_helpers.Category,
  resource_type: String,
  is_resource: Bool,
  snapshot_elements: List(codegen_helpers.Element),
  profile_prefix: String,
  profile_type: String,
  type_order: List(String),
  type_fields: dict.Dict(String, List(codegen_helpers.Element)),
  extensions: dict.Dict(String, ExtensionDefinition),
  slice_base_type_names: dict.Dict(String, String),
  slice_type_overrides: dict.Dict(String, SliceFieldType),
  datatype_types: dict.Dict(String, String),
  type_slice_overrides: dict.Dict(String, SlicePlan),
  preserve_slice_order: Bool,
  valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
) -> #(String, dict.Dict(String, codegen_helpers.ValuesetItem)) {
  let complex_prefix = codegen_helpers.bucket_prefix("Quantity", current_bucket)
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
      let primitive_slice_record =
        is_primitive_slice_record(
          snapshot_elements,
          profile_prefix,
          type_order,
          current_type,
        )
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
              || string.ends_with(element.path, "[x]")
              || dict.has_key(aggregate_slice_groups, element.id)
              || list.any(fields, fn(root) {
                root.path == element.path && root.slice_name != None
              })
            None -> True
          }
        })
      let fixed_json_always =
        fields
        |> list.filter_map(fn(element) {
          let json_name = profile_json_field_name(element, "")
          case codegen_helpers.constant(element), element.min, element.max {
            _, _, _ if primitive_slice_record && json_name == "value" ->
              Error(Nil)
            Some(value), minimum, "1" if minimum > 0 -> {
              let value_json = codegen_constraint.json_source(value)
              Ok(
                "#(\""
                <> json_name
                <> "\", "
                <> case element.base.max, value {
                  "1", _ | _, codegen_constraint.Array(_) -> value_json
                  _, _ -> "json.preprocessed_array([" <> value_json <> "])"
                }
                <> "),",
              )
            }
            _, _, _ -> Error(Nil)
          }
        })
        |> string.concat
      let fields =
        list.filter(fields, fn(element) {
          {
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
          && {
            !primitive_slice_record
            || profile_json_field_name(element, "") != "value"
          }
        })
      let #(json_always, json_optional, choice_encoders, valueset_acc) =
        list.fold(
          fields,
          #(fixed_json_always, "", "", valueset_acc),
          fn(acc, element) {
            let #(json_always, json_optional, choice_encoders, valueset_acc) =
              acc
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
            let choice_type =
              gleam_type
              <> {
                last_part
                |> string.replace("[x]", "")
                |> codegen_helpers.to_camel_case
              }
            let field_name = codegen_helpers.field_name(element)
            let record_name = case primitive_slice_record {
              True -> "primitive"
              False -> codegen_helpers.to_snake_case(gleam_type)
            }
            let field_value = record_name <> "." <> field_name
            let #(open_field_type, valueset_acc) =
              profile_base_field_type(
                current_bucket,
                element,
                all_parts,
                field_path,
                choice_type,
                extensions,
                type_order,
                slice_base_type_names,
                slice_type_overrides,
                datatype_types,
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
                        current_bucket,
                        root,
                        root_parts,
                        root_field_path,
                        root_type_name,
                        extensions,
                        type_order,
                        slice_base_type_names,
                        slice_type_overrides,
                        datatype_types,
                        valueset_acc,
                      )
                    let call =
                      profile_element_encoder_call(
                        current_bucket,
                        root,
                        root_type,
                        root_parts,
                        root_field_path,
                        type_order,
                        slice_type_overrides,
                        datatype_types,
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
                    current_bucket,
                    element,
                    open_field_type,
                    all_parts,
                    field_path,
                    type_order,
                    slice_type_overrides,
                    datatype_types,
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
            let is_primitive_slice =
              profile_field_is_primitive_slice(
                element,
                json_field_name,
                type_order,
                field_path,
              )
            let card_min = case
              dict.has_key(aggregate_slice_groups, element.id)
            {
              True -> {
                let assert Ok(#(_, remaining_minimum)) =
                  dict.get(aggregate_slice_groups, element.id)
                remaining_minimum
              }
              False -> profile_field_min(element)
            }
            let slice_roots =
              list.filter(fields, fn(candidate) {
                candidate.path == element.path && candidate.slice_name != None
              })
            let is_choice_path = string.ends_with(element.path, "[x]")

            case
              element.pattern_literals,
              element.slice_name,
              slice_roots,
              is_primitive_slice
            {
              [_, ..], _, _, _ -> {
                let remaining = case card_min {
                  0 -> field_value
                  1 ->
                    "["
                    <> field_value
                    <> ".first, .."
                    <> field_value
                    <> ".rest]"
                  2 ->
                    "["
                    <> field_value
                    <> ".first, "
                    <> field_value
                    <> ".second, .."
                    <> field_value
                    <> ".rest]"
                  3 ->
                    "["
                    <> field_value
                    <> ".first, "
                    <> field_value
                    <> ".second, "
                    <> field_value
                    <> ".third, .."
                    <> field_value
                    <> ".rest]"
                  _ -> panic as "unsupported pattern remainder cardinality"
                }
                let encoder =
                  profile_element_encoder_type(
                    current_bucket,
                    element,
                    base_field_type,
                    all_parts,
                    field_path,
                    type_order,
                    slice_type_overrides,
                    datatype_types,
                    snapshot_elements,
                  )
                let literals =
                  element.pattern_literals
                  |> list.index_map(fn(literal, index) {
                    let encoded = codegen_constraint.json_source(literal)
                    case preserve_slice_order {
                      False -> encoded
                      True -> {
                        let index_name =
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
                        complex_prefix
                        <> "SliceElt("
                        <> encoded
                        <> ", "
                        <> record_name
                        <> "."
                        <> index_name
                        <> ")"
                      }
                    }
                  })
                  |> string.join(", ")
                let others =
                  "list.map("
                  <> remaining
                  <> ", fn(value) { "
                  <> case preserve_slice_order {
                    False -> "{" <> encoder <> "}(value)"
                    True ->
                      complex_prefix
                      <> "SliceElt({"
                      <> encoder
                      <> "}(value.value), value.internal_gleam_fhir_index)"
                  }
                  <> " })"
                let values = "[" <> literals <> ", .." <> others <> "]"
                let values = case preserve_slice_order {
                  False -> values
                  True ->
                    complex_prefix <> "slice_elts_to_values(" <> values <> ")"
                }
                #(
                  json_always
                    <> "#(\""
                    <> json_field_name
                    <> "\", json.preprocessed_array("
                    <> values
                    <> ")),",
                  json_optional,
                  choice_encoders,
                  valueset_acc,
                )
              }
              [], Some(_), _, _ -> #(
                json_always,
                json_optional,
                choice_encoders,
                valueset_acc,
              )
              [], None, _, True -> {
                let encoder = codegen_helpers.to_snake_case(base_field_type)
                let helper = case element.base.max {
                  "1" -> "primitive_slice_to_json"
                  _ -> "primitive_slice_list_to_json"
                }
                #(
                  json_always,
                  json_optional
                    <> "\nlet fields = "
                    <> case element.max, card_min {
                    "1", 0 ->
                      "case "
                      <> field_value
                      <> " { None -> fields Some(value) -> "
                    _, _ -> ""
                  }
                    <> helper
                    <> "(fields, "
                    <> case element.max, card_min {
                    "1", 0 ->
                      case element.base.max {
                        "1" -> "value"
                        _ -> "[value]"
                      }
                    "1", _ if element.base.max != "1" ->
                      "[" <> field_value <> "]"
                    "*", 1 ->
                      "["
                      <> field_value
                      <> ".first"
                      <> ", .."
                      <> field_value
                      <> ".rest]"
                    "*", 2 ->
                      "["
                      <> field_value
                      <> ".first"
                      <> ", "
                      <> field_value
                      <> ".second"
                      <> ", .."
                      <> field_value
                      <> ".rest]"
                    "*", 3 ->
                      "["
                      <> field_value
                      <> ".first"
                      <> ", "
                      <> field_value
                      <> ".second"
                      <> ", "
                      <> field_value
                      <> ".third"
                      <> ", .."
                      <> field_value
                      <> ".rest]"
                    _, _ -> field_value
                  }
                    <> ", "
                    <> case element.fixed_code, element.fixed_uri {
                    _, _ if element.min == 0 -> encoder <> "_value_to_json"
                    None, None -> encoder <> "_value_to_json"
                    _, _ -> "fn(_) { None }"
                  }
                    <> ", "
                    <> encoder
                    <> "_rest_to_json, \""
                    <> json_field_name
                    <> "\")"
                    <> case element.max, card_min {
                    "1", 0 -> " }"
                    _, _ -> ""
                  },
                  aggregate_encoder <> choice_encoders,
                  valueset_acc,
                )
              }
              [], None, [_, ..], False if !is_choice_path -> {
                let indexed_slice_group =
                  profile_field_is_slice_elt(
                    element,
                    fields,
                    preserve_slice_order,
                  )
                let open_encoder = case aggregate_encoder {
                  "" ->
                    profile_element_encoder_type(
                      current_bucket,
                      element,
                      base_field_type,
                      all_parts,
                      field_path,
                      type_order,
                      slice_type_overrides,
                      datatype_types,
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

                    let root_field_name = codegen_helpers.field_name(root)
                    let root_field_path = string.join(root_parts, "_")
                    let root_type_name =
                      root_field_path |> codegen_helpers.to_camel_case
                    let #(root_type, _) =
                      profile_base_field_type(
                        current_bucket,
                        root,
                        root_parts,
                        root_field_path,
                        root_type_name,
                        extensions,
                        type_order,
                        slice_base_type_names,
                        slice_type_overrides,
                        datatype_types,
                        valueset_acc,
                      )
                    let extension =
                      profile_extension_definition(root, extensions)
                    let root_call = fn(value, id) {
                      case extension {
                        Some(extension) ->
                          profile_extension_encoder_call(
                            current_bucket,
                            extension,
                            value,
                            id,
                            preserve_slice_order,
                            datatype_types,
                          )
                        None ->
                          profile_element_encoder_call(
                            current_bucket,
                            root,
                            root_type,
                            root_parts,
                            root_field_path,
                            type_order,
                            slice_type_overrides,
                            datatype_types,
                            snapshot_elements,
                            value,
                          )
                      }
                    }
                    let indexed_root_call = fn(value) {
                      case indexed_slice_group, extension {
                        True, Some(_) ->
                          complex_prefix
                          <> "SliceElt("
                          <> root_call(value <> ".value", Some(value <> ".id"))
                          <> ", "
                          <> value
                          <> ".internal_gleam_fhir_index)"
                        True, None ->
                          complex_prefix
                          <> "SliceElt("
                          <> root_call(value <> ".value", None)
                          <> ", "
                          <> value
                          <> ".internal_gleam_fhir_index)"
                        False, _ -> root_call(value, None)
                      }
                    }
                    let #(value, is_single) = case root.min, root.max {
                      0, "1" -> #(
                        "case "
                          <> root_field_name
                          <> " { Some(value) -> ["
                          <> indexed_root_call("value")
                          <> "] None -> [] }",
                        False,
                      )
                      1, "1" -> #(indexed_root_call(root_field_name), True)
                      1, _ -> #(
                        "fn(values) { let "
                          <> complex_prefix
                          <> "List1(first, rest) = values ["
                          <> indexed_root_call("first")
                          <> ", ..list.map(rest, fn(value) { "
                          <> indexed_root_call("value")
                          <> " })] }("
                          <> root_field_name
                          <> ")",
                        False,
                      )
                      2, _ -> #(
                        "fn(values) { let "
                          <> complex_prefix
                          <> "List2(first, second, rest) = values ["
                          <> indexed_root_call("first")
                          <> ", "
                          <> indexed_root_call("second")
                          <> ", ..list.map(rest, fn(value) { "
                          <> indexed_root_call("value")
                          <> " })] }("
                          <> root_field_name
                          <> ")",
                        False,
                      )
                      3, _ -> #(
                        "fn(values) { let "
                          <> complex_prefix
                          <> "List3(first, second, third, rest) = values ["
                          <> indexed_root_call("first")
                          <> ", "
                          <> indexed_root_call("second")
                          <> ", "
                          <> indexed_root_call("third")
                          <> ", ..list.map(rest, fn(value) { "
                          <> indexed_root_call("value")
                          <> " })] }("
                          <> root_field_name
                          <> ")",
                        False,
                      )
                      0, _ -> #(
                        "list.map("
                          <> root_field_name
                          <> ", fn(value) { "
                          <> indexed_root_call("value")
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
                let open_indexed_call = fn(value) {
                  case indexed_slice_group {
                    True ->
                      complex_prefix
                      <> "SliceElt("
                      <> open_encoder
                      <> "("
                      <> value
                      <> ".value), "
                      <> value
                      <> ".internal_gleam_fhir_index)"
                    False -> open_encoder <> "(" <> value <> ")"
                  }
                }
                let maximum = case element.max {
                  "0" | "1" -> element.max
                  _ -> "*"
                }
                let open_values = case maximum, card_min {
                  "*", 0 ->
                    "list.map("
                    <> field_name
                    <> ", fn(value) { "
                    <> open_indexed_call("value")
                    <> " })"
                  "*", 1 ->
                    "fn(values) { let "
                    <> complex_prefix
                    <> "List1(first, rest) = values ["
                    <> open_indexed_call("first")
                    <> ", ..list.map(rest, fn(value) { "
                    <> open_indexed_call("value")
                    <> " })] }("
                    <> field_name
                    <> ")"
                  "*", 2 ->
                    "fn(values) { let "
                    <> complex_prefix
                    <> "List2(first, second, rest) = values ["
                    <> open_indexed_call("first")
                    <> ", "
                    <> open_indexed_call("second")
                    <> ", ..list.map(rest, fn(value) { "
                    <> open_indexed_call("value")
                    <> " })] }("
                    <> field_name
                    <> ")"
                  "*", 3 ->
                    "fn(values) { let "
                    <> complex_prefix
                    <> "List3(first, second, third, rest) = values ["
                    <> open_indexed_call("first")
                    <> ", "
                    <> open_indexed_call("second")
                    <> ", "
                    <> open_indexed_call("third")
                    <> ", ..list.map(rest, fn(value) { "
                    <> open_indexed_call("value")
                    <> " })] }("
                    <> field_name
                    <> ")"
                  "1", 0 ->
                    "case "
                    <> field_name
                    <> " { Some(value) -> ["
                    <> open_indexed_call("value")
                    <> "] None -> [] }"
                  _, _ -> panic as "unsupported open slice cardinality"
                }
                let single_values = list.reverse(single_values)
                let list_values = list.reverse([open_values, ..list_values])
                let _slice_values = case single_values, list_values {
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
                  <> slice_group_to_json_source(
                    current_bucket,
                    element,
                    slice_roots,
                    indexed_slice_group,
                    aggregate_encoder,
                    profile_prefix,
                    extensions,
                    type_order,
                    slice_base_type_names,
                    slice_type_overrides,
                    datatype_types,
                    valueset_acc,
                    snapshot_elements,
                    base_field_type,
                    all_parts,
                    field_path,
                    record_name,
                    field_value,
                    json_field_name,
                    card_min,
                  )
                #(
                  json_always,
                  optional,
                  aggregate_encoder <> choice_encoders,
                  valueset_acc,
                )
              }
              [], None, _, False -> {
                let encoder = case aggregate_encoder {
                  "" ->
                    profile_element_encoder_type(
                      current_bucket,
                      element,
                      base_field_type,
                      all_parts,
                      field_path,
                      type_order,
                      slice_type_overrides,
                      datatype_types,
                      snapshot_elements,
                    )
                  _ ->
                    codegen_helpers.to_snake_case(base_field_type) <> "_to_json"
                }
                let encoder_call = fn(value) {
                  case aggregate_encoder {
                    "" ->
                      profile_element_encoder_call(
                        current_bucket,
                        element,
                        base_field_type,
                        all_parts,
                        field_path,
                        type_order,
                        slice_type_overrides,
                        datatype_types,
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
                      _ -> field_value
                    },
                    element.type_,
                    choice_type,
                  )
                let #(new_always, new_optional) =
                  profile_field_to_json_source(
                    current_bucket,
                    element,
                    field_value,
                    json_field_name,
                    suffix,
                    encoder,
                    encoder_call,
                    card_min,
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
                              current_bucket,
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
                          _ -> {
                            let choice_element =
                              codegen_helpers.Element(..element, type_: [choice])
                            let #(payload_type, _) =
                              profile_base_field_type(
                                current_bucket,
                                choice_element,
                                all_parts,
                                "",
                                choice_type,
                                extensions,
                                type_order,
                                slice_base_type_names,
                                slice_type_overrides,
                                datatype_types,
                                valueset_acc,
                              )
                            profile_element_encoder_call(
                              current_bucket,
                              choice_element,
                              payload_type,
                              all_parts,
                              "",
                              type_order,
                              slice_type_overrides,
                              datatype_types,
                              snapshot_elements,
                              "value",
                            )
                          }
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
                          Ok(TypeSlicePlan(descendants: [_, ..], ..)) -> source
                          Ok(TypeSlicePlan(
                            slice: _,
                            children: [_, ..] as children,
                            ..,
                          )) -> {
                            let sliced_name =
                              choice_type
                              <> string.capitalise(choice.code)
                              <> "Sliced"
                            source
                            <> sliced_type_to_json_source(
                              current_bucket,
                              sliced_name,
                              children,
                              profile_prefix,
                              extensions,
                              type_order,
                              slice_base_type_names,
                              slice_type_overrides,
                              datatype_types,
                              valueset_acc,
                              snapshot_elements,
                              preserve_slice_order,
                            )
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
                  json_always <> new_always,
                  json_optional <> new_optional,
                  aggregate_encoder <> new_choice_encoders <> choice_encoders,
                  valueset_acc,
                )
              }
            }
          },
        )
      let encoder = case primitive_slice_record {
        False ->
          codegen_helpers.gen_res_encoder(
            resource_type,
            gleam_type,
            codegen_helpers.to_snake_case(gleam_type),
            json_always,
            json_optional,
            current_type == profile_prefix && is_resource,
          )
        True -> {
          let assert Ok(value_fields) = dict.get(type_fields, current_type)
          let assert Ok(value_field) =
            list.find(value_fields, fn(element) {
              profile_json_field_name(element, "") == "value"
            })
          let assert [value_type] = value_field.type_
          let value_parts =
            value_field.id
            |> string.replace("-", "")
            |> string.replace(":", ".")
            |> string.split(".")
          let assert [_, ..value_rest] = value_parts
          let value_parts = [profile_prefix, ..value_rest]
          let value_call =
            codegen_to_json.string_to_encoder_call(
              value_type.code,
              value_parts,
              value_field,
              current_bucket,
              "value",
            )
          let encoder_name = codegen_helpers.to_snake_case(gleam_type)
          "pub fn "
          <> encoder_name
          <> "_value_to_json(primitive: "
          <> gleam_type
          <> ") -> Option(Json) {\n"
          <> case value_field.min {
            0 ->
              "  case primitive.value { Some(value) -> Some("
              <> value_call
              <> ") None -> None }"
            _ -> "  let value = primitive.value\n  Some(" <> value_call <> ")"
          }
          <> "\n}\n\npub fn "
          <> encoder_name
          <> "_rest_to_json(primitive: "
          <> gleam_type
          <> ") -> Option(Json) {\n  let fields = ["
          <> json_always
          <> "]"
          <> json_optional
          <> "\n  case fields {\n    [] -> None\n    _ -> Some(json.object(fields))\n  }\n}\n\n"
        }
      }
      #(encoder <> choice_encoders <> encoders_acc, valueset_acc)
    },
  )
}
