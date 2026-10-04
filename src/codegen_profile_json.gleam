import codegen_bound_coding
import codegen_decode
import codegen_helpers
import codegen_slice_complex_type
import codegen_to_json
import gleam/dict
import gleam/int
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
            codegen_to_json.string_to_encoder_type(
              type_.code,
              [extension_name, field_name],
              field,
              codegen_helpers.ComplexTypes,
            )
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
        codegen_helpers.string_to_type(
          type_.code,
          ["Extension", "value"],
          value,
          current_bucket,
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
    profile_extension_type(current_bucket, element, extensions, valueset_acc)
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
                  // A base datatype permits the unrestricted representation.
                  let profiles = case
                    list.any(only_type.profile, fn(profile) {
                      canonical_url(profile)
                      == "http://hl7.org/fhir/StructureDefinition/"
                      <> only_type.code
                    })
                  {
                    True -> []
                    False -> only_type.profile
                  }
                  case
                    list.find_map(profiles, fn(url) {
                      dict.get(datatype_types, canonical_url(url))
                    })
                  {
                    Ok(profile_type) -> #(
                      codegen_helpers.bucket_prefix("Quantity", current_bucket)
                        <> profile_type,
                      valueset_acc,
                    )
                    Error(_) ->
                      codegen_helpers.string_to_type(
                        only_type.code,
                        all_parts,
                        element,
                        current_bucket,
                        valueset_acc,
                      )
                  }
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
  let min = element.min
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

fn fixed_slice_encoder_call(
  current_bucket: codegen_helpers.Category,
  slice_type: String,
  system: String,
  code: String,
  display: Option(String),
  value: String,
) -> String {
  let complex_prefix = codegen_helpers.bucket_prefix("Quantity", current_bucket)
  case slice_type {
    "ct.CodingFixedSystem" ->
      complex_prefix
      <> "coding_fixed_system_to_json("
      <> value
      <> ", \""
      <> system
      <> "\")"
    "ct.CodingFixedSystemCode" ->
      complex_prefix
      <> "coding_fixed_system_code_to_json("
      <> value
      <> ", \""
      <> system
      <> "\", \""
      <> code
      <> "\")"
    "ct.CodingFixedSystemCodeDisplay" -> {
      let assert Some(display) = display
      complex_prefix
      <> "coding_fixed_system_code_display_to_json("
      <> value
      <> ", \""
      <> system
      <> "\", \""
      <> code
      <> "\", \""
      <> display
      <> "\")"
    }
    "ct.CodingFixedSystemRequiredCodeDisplay" ->
      complex_prefix
      <> "coding_fixed_system_required_code_display_to_json("
      <> value
      <> ", \""
      <> system
      <> "\")"
    "ct.CodeableconceptList1FixedSystem" ->
      complex_prefix
      <> "codeableconcept_list1_fixed_system_to_json("
      <> value
      <> ", \""
      <> system
      <> "\""
      <> ")"
    "ct.CodeableconceptFixedSystem" ->
      complex_prefix
      <> "codeableconcept_fixed_system_to_json("
      <> value
      <> ", \""
      <> system
      <> "\")"
    "ct.CodeableconceptList1FixedSystemCode" ->
      complex_prefix
      <> "codeableconcept_list1_fixed_system_code_to_json("
      <> value
      <> ", \""
      <> system
      <> "\""
      <> ", \""
      <> code
      <> "\""
      <> ")"
    "ct.CodeableconceptFixedSystemCode" ->
      complex_prefix
      <> "codeableconcept_fixed_system_code_to_json("
      <> value
      <> ", \""
      <> system
      <> "\", \""
      <> code
      <> "\")"
    "ct.CodeableconceptList1FixedSystemCodeDisplay" -> {
      let assert Some(display) = display

      complex_prefix
      <> "codeableconcept_list1_fixed_system_code_display_to_json("
      <> value
      <> ", \""
      <> system
      <> "\""
      <> ", \""
      <> code
      <> "\""
      <> ", \""
      <> display
      <> "\""
      <> ")"
    }
    "ct.CodeableconceptFixedSystemCodeDisplay" -> {
      let assert Some(display) = display
      complex_prefix
      <> "codeableconcept_fixed_system_code_display_to_json("
      <> value
      <> ", \""
      <> system
      <> "\", \""
      <> code
      <> "\", \""
      <> display
      <> "\")"
    }
    _ -> panic as "unknown fixed slice type"
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
      case dict.get(slice_type_overrides, element.id) {
        Ok(FixedSliceType(slice_type, _, system, code, display)) ->
          "fn(value) { "
          <> fixed_slice_encoder_call(
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
            _, _ -> codegen_helpers.to_snake_case(base_field_type) <> "_to_json"
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
      case dict.get(slice_type_overrides, element.id) {
        Ok(FixedSliceType(slice_type, _, system, code, display)) ->
          fixed_slice_encoder_call(
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
              <> "("
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

pub fn profile_extension_encoder_call(
  current_bucket: codegen_helpers.Category,
  extension: ExtensionDefinition,
  value: String,
  id: Option(String),
  preserve_slice_order: Bool,
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
          <> codegen_to_json.string_to_encoder_type(
            value_type.code,
            ["Extension", "value"],
            extension_value,
            current_bucket,
          )
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
      let assert Ok(root_last) = root_parts |> list.last
      let root_field_name =
        option.unwrap(root.slice_name, root_last)
        |> codegen_helpers.escape_field_name
        |> codegen_helpers.to_snake_case
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
      case child.fixed_code, child.fixed_uri {
        Some(value), _ | _, Some(value) -> {
          let value_json = "json.string(\"" <> value <> "\")"
          #(
            always
              <> "#(\""
              <> json_name
              <> "\", "
              <> case child.base.max {
              "1" -> value_json
              _ -> "json.preprocessed_array([" <> value_json <> "])"
            }
              <> "),",
            optional,
          )
        }
        None, None -> {
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

type DecodeContext {
  DecodeContext(
    resource_type: String,
    current_bucket: codegen_helpers.Category,
    is_resource: Bool,
    profile_prefix: String,
    snapshot_elements: List(codegen_helpers.Element),
    type_order: List(String),
    type_fields: dict.Dict(String, List(codegen_helpers.Element)),
    extensions: dict.Dict(String, ExtensionDefinition),
    slice_base_type_names: dict.Dict(String, String),
    slice_type_overrides: dict.Dict(String, SliceFieldType),
    datatype_types: dict.Dict(String, String),
    nested_value_discriminators: Set(String),
    slice_discriminator_checks: dict.Dict(String, SliceFieldType),
    type_slice_overrides: dict.Dict(String, SlicePlan),
    preserve_slice_order: Bool,
    valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
    available_valuesets: dict.Dict(String, codegen_helpers.VsOrCs),
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
  )
}

type ResourceSliceMatch {
  ResourceSliceMatch(
    expression: String,
    success_pattern: String,
    selected: String,
    fallible: Bool,
  )
}

type DirectSliceRecordExpression {
  DirectSliceRecordExpression(expression: String, consumes_discriminator: Bool)
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
    option.unwrap(element.slice_name, last)
    |> string.replace("[x]", "")
    |> codegen_helpers.escape_field_name
    |> codegen_helpers.to_snake_case
  let field_path = string.join(parts, "_")
  let #(field_type, _) =
    profile_base_field_type(
      context.current_bucket,
      element,
      parts,
      field_path,
      parent_type <> string.capitalise(field_name),
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
          call <> " |> result.replace_error(\"discriminator\")",
          "",
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
        True -> IdentityConversion(source, expression.helpers, False)
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
                expression.helpers,
                fallible,
              )
            False, True ->
              ConversionExpression(
                "list.try_map("
                  <> source
                  <> ", fn(primitive) { "
                  <> convert_primitive("primitive")
                  <> " })",
                expression.helpers,
                True,
              )
            False, False ->
              ConversionExpression(
                "list.map("
                  <> source
                  <> ", fn(primitive) { "
                  <> convert_primitive("primitive")
                  <> " })",
                expression.helpers,
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
              <> " _ -> "
              <> failure("\"maximum cardinality 1\"")
              <> " }",
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
              <> " _ -> "
              <> failure("\"cardinality 1..1\"")
              <> " }",
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
              <> " { None -> "
              <> failure("\"required field\"")
              <> " Some(value) -> "
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
  Ok(
    codegen_helpers.to_snake_case(field_type)
    <> "_try_from_"
    <> {
      base_type
      |> string.replace(complex_prefix, "")
      |> codegen_helpers.to_snake_case
    },
  )
}

fn field_inner_conversion(
  context: DecodeContext,
  element: codegen_helpers.Element,
  field_path: String,
  field_type: String,
  value: String,
  source_choice_type: Option(String),
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
  let conversion = case dict.get(context.slice_type_overrides, element.id) {
    Ok(FixedSliceType(discriminator_type, _, system, code, display)) -> {
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
    Ok(BoundCodeableconceptSlice) | Ok(BoundCodingSlice) -> {
      let assert [type_] = element.type_
      required_binding_conversion(
        context.current_bucket,
        element,
        type_.code,
        inner_value,
      )
      |> option.unwrap(IdentityConversion(inner_value, "", False))
    }
    Error(_) | Ok(FixedValueDiscriminator(_)) ->
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
              required_binding_conversion(
                context.current_bucket,
                element,
                type_.code,
                inner_value,
              )
              |> option.unwrap(IdentityConversion(inner_value, "", False))
            _ -> {
              let source_type =
                option.unwrap(source_choice_type, base_choice_name(element))
              ConversionExpression(
                codegen_helpers.to_snake_case(field_type)
                  <> "_from_"
                  <> codegen_helpers.to_snake_case(source_type)
                  <> "("
                  <> value
                  <> ")",
                choice_conversion_source(
                  context,
                  field_type,
                  element,
                  source_type,
                ),
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
        conversion.helpers,
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
        || string.ends_with(element.path, "[x]")
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
  slice_json_name: Option(String),
) -> String {
  let complex_prefix =
    codegen_helpers.bucket_prefix("Quantity", context.current_bucket)
  let function_name =
    codegen_helpers.to_snake_case(target_type)
    <> case slice_json_name {
      None -> "_try_from_"
      Some(_) -> "_slice_try_from_"
    }
    <> {
      base_type
      |> string.replace(complex_prefix, "")
      |> codegen_helpers.to_snake_case
    }
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
        None, None -> field_name
        _, _ -> "_" <> field_name
      }
      ", " <> field_name <> " " <> parameter_name <> ": " <> parameter_type
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
      let failure = fn(reason) {
        case slice_json_name {
          None -> "Error(" <> reason <> ")"
          Some(group) ->
            "Error([decode.DecodeError(expected: \""
            <> fixed
            <> "\", found: "
            <> reason
            <> ", path: [\""
            <> group
            <> "\", int.to_string(index), \""
            <> json_name
            <> "\"])])"
        }
      }
      let check = case element.base.min, element.base.max {
        0, "1" ->
          "case source."
          <> field_name
          <> " { Some(\""
          <> fixed
          <> "\") -> Ok(Nil) Some(_) -> "
          <> failure("\"invalid fixed " <> json_name <> "\"")
          <> " None -> "
          <> failure("\"required fixed " <> json_name <> "\"")
          <> " }"
        _, "1" ->
          "case source."
          <> field_name
          <> " == \""
          <> fixed
          <> "\" { True -> Ok(Nil) False -> "
          <> failure("\"invalid fixed " <> json_name <> "\"")
          <> " }"
        _, _ -> panic as "unsupported fixed field cardinality"
      }
      Ok("  use _ <- result.try(" <> check <> ")\n")
    })
    |> string.concat
  let #(bindings, arguments, helpers) =
    fields
    |> list.filter(fn(element) {
      element.fixed_code == None && element.fixed_uri == None
    })
    |> list.fold(#("", "", ""), fn(acc, element) {
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
        Some(source_type) ->
          fields_for_profile_type(context, source_type, "")
          |> result.try(fn(source_fields) {
            list.find(source_fields, fn(source_field) {
              source_field.slice_name == None
              && source_field.path == element.path
            })
          })
          |> option.from_result
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
        1, "1" -> "source." <> field_name
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
            validation_path,
            failure,
          )
      }
      let converted = case is_discriminator, element.max, slice_json_name {
        True, "1", Some(_) if target_min == 0 ->
          ConversionExpression("Some(" <> field_name <> ")", "", False)
        True, max, _ if max != "1" -> IdentityConversion(field_name, "", False)
        True, "1", Some(_) -> IdentityConversion(field_name, "", False)
        _, _, _ ->
          conversion_for_cardinality(
            context.current_bucket,
            inner,
            element,
            "source." <> field_name,
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
        helpers <> converted.helpers,
      )
    })
  case slice_json_name {
    None -> helpers
    Some(_) -> ""
  }
  <> "fn "
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
  let has_sliced_extensions =
    list.any(fields, fn(field) {
      field.slicing != None
      && list.any(field.type_, fn(type_) { type_.code == "Extension" })
    })
  case base_type, has_sliced_extensions {
    "ct.Identifier", True | "Identifier", True -> ""
    _, _ ->
      record_conversion_from_fields(
        context,
        target_type,
        base_type,
        fields,
        source_profile_type,
        None,
      )
  }
}

fn choice_conversion_source(
  context: DecodeContext,
  choice_type: String,
  element: codegen_helpers.Element,
  source_choice_type: String,
) -> String {
  let complex_prefix =
    codegen_helpers.bucket_prefix("Quantity", context.current_bucket)
  let base_choice = source_choice_type
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
        Ok(TypeSlicePlan(descendants: [_, ..], ..)) -> {
          let sliced_name = constructor <> "Sliced"
          let base_encoder =
            complex_prefix
            <> codegen_helpers.to_snake_case(choice.code)
            <> "_to_json"
          #(
            ConversionExpression(
              "json.parse(json.to_string("
                <> base_encoder
                <> "(value)), "
                <> codegen_helpers.to_snake_case(sliced_name)
                <> "_decoder()) |> result.replace_error(\"invalid choice slice\")",
              "",
              True,
            ),
            "",
          )
        }
        Ok(TypeSlicePlan(children: [_, ..] as children, ..)) -> {
          let sliced_name = constructor <> "Sliced"
          let base_type =
            base_payload_type(context.current_bucket, element, choice.code)
          let conversion =
            ConversionExpression(
              codegen_helpers.to_snake_case(sliced_name)
                <> "_try_from_"
                <> {
                base_type
                |> string.replace(complex_prefix, "")
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
              None,
            ),
          )
        }
        Ok(TypeSlicePlan(slice:, children: [], ..)) -> {
          let conversion =
            required_binding_conversion(
              context.current_bucket,
              slice,
              choice.code,
              "value",
            )
            |> option.unwrap(ConversionExpression("value", "", False))
          #(conversion, "")
        }
        _ -> {
          let conversion =
            required_binding_conversion(
              context.current_bucket,
              element,
              choice.code,
              "value",
            )
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
          element,
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
        )
      let conversion = case call {
        codegen_slice_complex_type.ResultDiscriminatorCall(call) ->
          "case "
          <> call
          <> " { Ok(value) -> decode.success(value) Error(_) -> decode.failure("
          <> fallback
          <> ", \"discriminator\") }"
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
              codegen_decode.string_to_decoder_type(
                type_.code,
                all_parts,
                "r4",
                element,
                context.current_bucket,
              )
          }
        [] -> codegen_helpers.to_snake_case(field_type) <> "_decoder()"
        _ -> codegen_helpers.to_snake_case(field_type) <> "_decoder()"
      }
  }
  let decoder = case element.type_, element.binding {
    [codegen_helpers.Type(code: "code", ..)],
      Some(codegen_helpers.Binding(
        strength: "required",
        value_set: Some(value_set),
        available: True,
      ))
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
                    codegen_helpers.concept_name_from_url(url)
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
    _, _ -> decoder
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
          element,
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
      <> " { Ok(_) -> decode.success(value) Error(_) -> decode.failure(value, \"discriminator\") } Error(_) -> decode.failure(value, \"discriminator\") } })"
    }
    _ -> decoder
  }
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
) -> String {
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
  let sliced_decoders =
    list.fold(element.type_, "", fn(source, choice) {
      case
        dict.get(
          context.type_slice_overrides,
          type_slice_key(element.id, choice.code),
        )
      {
        Ok(TypeSlicePlan(descendants: [_, ..], ..)) -> source
        Ok(TypeSlicePlan(slice:, children: [_, ..] as children, ..)) -> {
          let constructor = choice_type <> string.capitalise(choice.code)
          let sliced_type = constructor <> "Sliced"
          source
          <> slice_support_types_from_fields(context, sliced_type, children)
          <> record_decoder_from_fields(
            context,
            sliced_type,
            children,
            None,
            True,
            profile_field_has_primitive_type(slice, ""),
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
      let #(_, _, _json_name, field_name, _) =
        profile_element_names(context, profile_type, field)
      let source_min = profile_field_min(field)
      let source = value <> "." <> field_name
      let expression = case
        field.base.min,
        field.base.max,
        source_min,
        field.max
      {
        0, "1", source_min, "1" if source_min > 0 -> "Some(" <> source <> ")"
        0, "*", 1, max if max != "1" ->
          "[" <> source <> ".first" <> ", .." <> source <> ".rest]"
        0, "*", 2, max if max != "1" ->
          "["
          <> source
          <> ".first"
          <> ", "
          <> source
          <> ".second"
          <> ", .."
          <> source
          <> ".rest]"
        0, "*", 3, max if max != "1" ->
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
) -> String {
  let complex_prefix =
    codegen_helpers.bucket_prefix("Quantity", context.current_bucket)
  let #(_, slice_base_field_path, _, _, slice_base_type) =
    profile_element_names(context, parent_type, group)
  let use_profile_slice_base =
    list.contains(context.type_order, slice_base_field_path)
  case
    list.contains(
      dict.values(context.datatype_types),
      string.replace(slice_base_type, "ct.", ""),
    )
  {
    True -> {
      let assert [type_] = group.type_
      let base_decoder =
        codegen_decode.string_to_decoder_type(
          type_.code,
          string.split(group.base.path, "."),
          "r4",
          group,
          context.current_bucket,
        )
      let expression =
        slice_match(
          DecodeContext(..context, datatype_types: dict.new()),
          parent_type,
          group,
          root,
          "base_value",
        )
      "case json.parse(json.to_string("
      <> complex_prefix
      <> codegen_helpers.to_snake_case(string.replace(
        slice_base_type,
        "ct.",
        "",
      ))
      <> "_to_json("
      <> value
      <> ")), "
      <> base_decoder
      <> ") { Ok(base_value) -> "
      <> expression
      <> " Error(_) -> Error(Nil) }"
    }
    False -> {
      case profile_extension_definition(root, context.extensions) {
        Some(_) -> panic as "extension slice must use extension fold"
        None ->
          case dict.get(context.slice_type_overrides, root.id) {
            Ok(FixedSliceType(discriminator_type, _, system, code, display)) -> {
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
                      base_payload_type(
                        context.current_bucket,
                        group,
                        type_.code,
                      ),
                      value,
                    )
                  let assert Ok(call) =
                    codegen_slice_complex_type.discriminator_from_base_call(
                      context.current_bucket,
                      discriminator_type,
                      discriminator_value,
                      system,
                      code,
                      display,
                    )
                  call
                }
                Error(_), _ -> {
                  let assert Ok(call) =
                    codegen_slice_complex_type.discriminator_from_base_call(
                      context.current_bucket,
                      discriminator_type,
                      value,
                      system,
                      code,
                      display,
                    )
                  call
                }
              }
              case call {
                codegen_slice_complex_type.ResultDiscriminatorCall(expression) ->
                  expression
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
              let conversion =
                complex_prefix
                <> "bound_codeableconcept_from_codeableconcept(value, valuesets."
                <> valueset
                <> "_from_code_and_system)"
              case use_profile_slice_base {
                True ->
                  "case json.parse(json.to_string("
                  <> codegen_helpers.to_snake_case(slice_base_type)
                  <> "_to_json("
                  <> value
                  <> ")), "
                  <> complex_prefix
                  <> "codeableconcept_decoder()) { Ok(value) -> "
                  <> conversion
                  <> " Error(_) -> Error(Nil) }"
                False ->
                  complex_prefix
                  <> "bound_codeableconcept_from_codeableconcept("
                  <> value
                  <> ", valuesets."
                  <> valueset
                  <> "_from_code_and_system)"
              }
            }
            Ok(BoundCodingSlice) -> {
              let assert Some(codegen_helpers.Binding(
                value_set: Some(value_set),
                ..,
              )) = root.binding
              let valueset =
                value_set
                |> canonical_url
                |> codegen_helpers.concept_name_from_url
                |> codegen_helpers.to_snake_case
              let conversion =
                complex_prefix
                <> "bound_coding_from_coding(value, valuesets."
                <> valueset
                <> "_from_code_and_system)"
              case use_profile_slice_base {
                True ->
                  "case json.parse(json.to_string("
                  <> codegen_helpers.to_snake_case(slice_base_type)
                  <> "_to_json("
                  <> value
                  <> ")), "
                  <> complex_prefix
                  <> "coding_decoder()) { Ok(value) -> "
                  <> conversion
                  <> " Error(_) -> Error(Nil) }"
                False ->
                  complex_prefix
                  <> "bound_coding_from_coding("
                  <> value
                  <> ", valuesets."
                  <> valueset
                  <> "_from_code_and_system)"
              }
            }
            Error(_) | Ok(FixedValueDiscriminator(_)) ->
              panic as { "slice has no discriminator type " <> root.id }
          }
      }
    }
  }
}

fn profile_record_placeholder(
  context: DecodeContext,
  target_type: String,
) -> String {
  let complex_prefix =
    codegen_helpers.bucket_prefix("Quantity", context.current_bucket)
  let complex_extension_record =
    context.extensions
    |> dict.values
    |> list.any(fn(extension) {
      extension.name == string.replace(target_type, complex_prefix, "")
      && case extension.kind {
        ComplexExtension(..) -> True
        _ -> False
      }
    })
  let fields = case fields_for_profile_type(context, target_type, "") {
    Ok(fields) -> fields
    Error(_) -> panic as { "no fields for placeholder " <> target_type }
  }
  let aggregate_slice_groups =
    fields
    |> list.filter_map(fn(group) {
      case aggregate_value_slice_roots(group, fields) {
        Some(aggregate) -> Ok(#(group.id, aggregate))
        None -> Error(Nil)
      }
    })
    |> dict.from_list
  let arguments =
    fields
    |> profile_fields
    |> list.filter_map(fn(field) {
      let #(_, _field_path, _json_name, field_name, field_type) =
        profile_element_names(context, target_type, field)
      let is_primitive = False
      let minimum = profile_field_min(field)
      case
        minimum > 0
        && !is_primitive
        && field.fixed_code == None
        && field.fixed_uri == None
      {
        False -> Error(Nil)
        True -> {
          let choice = case field.type_ {
            [first, _, ..] -> Some(first)
            _ -> None
          }
          let choice_type = case choice {
            None -> None
            Some(first) -> {
              let primitive =
                context.extensions
                |> dict.values
                |> list.find_map(fn(extension) {
                  case target_type == complex_prefix <> extension.name {
                    False -> Error(Nil)
                    True ->
                      dict.get(
                        extension.primitive_values,
                        field.id <> "|" <> first.code,
                      )
                  }
                })
              let #(scalar_type, _) =
                codegen_helpers.string_to_type(
                  first.code,
                  [target_type, field_name],
                  codegen_helpers.Element(..field, type_: [first]),
                  context.current_bucket,
                  context.valueset_acc,
                )
              Some(
                #(first.code, case primitive {
                  Ok(value) -> complex_prefix <> value.name
                  Error(_) -> scalar_type
                }),
              )
            }
          }
          let value = case dict.get(context.slice_type_overrides, field.id) {
            Ok(FixedSliceType(discriminator_type, _, _, _, _)) -> {
              let assert Ok(value) =
                codegen_slice_complex_type.discriminator_new_call(
                  context.current_bucket,
                  discriminator_type,
                )
              value
            }
            Ok(BoundCodeableconceptSlice) -> {
              let assert Some(codegen_helpers.Binding(
                value_set: Some(value_set),
                ..,
              )) = field.binding
              complex_prefix
              <> "bound_codeableconcept_new(valuesets."
              <> {
                value_set
                |> canonical_url
                |> codegen_helpers.concept_name_from_url
                |> codegen_helpers.to_snake_case
              }
              <> "_failure_variant)"
            }
            Ok(BoundCodingSlice) -> {
              let assert Some(codegen_helpers.Binding(
                value_set: Some(value_set),
                ..,
              )) = field.binding
              complex_prefix
              <> "bound_coding_new(valuesets."
              <> {
                value_set
                |> canonical_url
                |> codegen_helpers.concept_name_from_url
                |> codegen_helpers.to_snake_case
              }
              <> "_failure_variant)"
            }
            Error(_) | Ok(FixedValueDiscriminator(_)) ->
              case field_type {
                "String" -> "\"\""
                "Bool" -> "False"
                "Int" -> "0"
                "Float" -> "0.0"
                _ -> base_slice_placeholder(context, field_type)
              }
          }
          let value = case choice_type {
            None -> value
            Some(#(code, scalar_type)) ->
              field_type
              <> string.capitalise(code)
              <> "("
              <> base_slice_placeholder(context, scalar_type)
              <> ")"
          }
          let is_slice_elt =
            context.preserve_slice_order
            && {
              complex_extension_record
              || {
                field.base.max != "1"
                && !dict.has_key(aggregate_slice_groups, field.id)
                && !string.ends_with(field.path, "[x]")
                && {
                  let extension_group =
                    list.any(field.type_, fn(type_) {
                      type_.code == "Extension"
                    })
                  !extension_group
                  || field.slice_name != None
                  || list.any(fields, fn(candidate) {
                    candidate.path == field.path && candidate.slice_name != None
                  })
                }
                && case field.slice_name, field.slicing {
                  Some(_), _ | _, Some(_) -> True
                  None, None -> False
                }
              }
            }
          let value = case is_slice_elt {
            True ->
              case
                complex_extension_record
                || profile_extension_definition(field, context.extensions)
                != None
              {
                True ->
                  complex_prefix
                  <> "ExtensionSliceElt(value: "
                  <> value
                  <> ", id: None, internal_gleam_fhir_index: None)"
                False -> complex_prefix <> "SliceElt(" <> value <> ", None)"
              }
            False -> value
          }
          let value = case minimum, field.max {
            1, max if max != "1" ->
              complex_prefix <> "List1(first: " <> value <> ", rest: [])"
            2, max if max != "1" ->
              complex_prefix
              <> "List2(first: "
              <> value
              <> ", second: "
              <> value
              <> ", rest: [])"
            3, max if max != "1" ->
              complex_prefix
              <> "List3(first: "
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
  let constructor = case string.split(target_type, ".") {
    [module, type_] -> module <> "." <> codegen_helpers.to_snake_case(type_)
    _ -> codegen_helpers.to_snake_case(target_type)
  }
  constructor <> "_new(" <> arguments <> ")"
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
      case fields_for_profile_type(context, target_type, "") {
        Ok(_) -> profile_record_placeholder(context, target_type)
        Error(_) ->
          panic as {
            "no placeholder for slice " <> root.id <> " target " <> target_type
          }
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
  let complex_prefix =
    codegen_helpers.bucket_prefix("Quantity", context.current_bucket)
  let extension_group =
    list.any(group.type_, fn(type_) { type_.code == "Extension" })
  let named_slice_elt_type = fn(type_) {
    case context.preserve_slice_order, extension_group {
      True, True -> complex_prefix <> "ExtensionSliceElt(" <> type_ <> ")"
      True, False -> complex_prefix <> "SliceElt(" <> type_ <> ")"
      False, _ -> type_
    }
  }
  let open_slice_elt_type = fn(type_) {
    case context.preserve_slice_order {
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
        |> codegen_helpers.escape_field_name
        |> string.capitalise
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
  |> list.map(fn(group) {
    let #(group, roots, aggregate) = group
    slice_group_support_source(context, parent_type, group, roots, aggregate)
    <> {
      roots
      |> list.map(fn(root) {
        case
          profile_extension_definition(root, context.extensions),
          dict.has_key(context.slice_type_overrides, root.id)
          || set.contains(context.nested_value_discriminators, root.id)
        {
          Some(_), _ | _, True -> ""
          None, False ->
            slice_converter_source(context, parent_type, group, root)
        }
      })
      |> string.concat
    }
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

fn direct_slice_record_expression(
  context: DecodeContext,
  target_type: String,
  base_type: String,
  discriminator: codegen_helpers.Element,
  source: String,
) -> Result(DirectSliceRecordExpression, Nil) {
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
    |> list.filter(fn(field) {
      field.fixed_code == None && field.fixed_uri == None
    })
    |> list.try_map(fn(target) {
      let #(_, _, _target_json_name, target_field_name, target_field_type) =
        profile_element_names(context, target_type, target)
      case target.id == discriminator.id {
        True -> Ok(#(target_field_name <> ": matched", True))
        False -> {
          use source_field <- result.try(
            list.find(source_fields, fn(candidate) {
              candidate.slice_name == None && candidate.path == target.path
            }),
          )
          let #(_, _, _source_json_name, source_field_name, source_field_type) =
            profile_element_names(context, base_type, source_field)
          let target_min = profile_field_min(target)
          let source_min = profile_field_min(source_field)
          case
            target_field_type == source_field_type,
            target_min == source_min,
            target.max == source_field.max
          {
            True, True, True ->
              Ok(#(
                target_field_name <> ": " <> source <> "." <> source_field_name,
                False,
              ))
            _, _, _ -> Error(Nil)
          }
        }
      }
    })
  use arguments <- result.try(arguments)
  Ok(DirectSliceRecordExpression(
    expression: target_type
      <> "("
      <> {
      arguments |> list.map(fn(argument) { argument.0 }) |> string.join(", ")
    }
      <> ")",
    consumes_discriminator: list.any(arguments, fn(argument) { argument.1 }),
  ))
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

fn slice_converter_name(
  current_bucket: codegen_helpers.Category,
  target_type: String,
  base_type: String,
) -> String {
  let complex_prefix = codegen_helpers.bucket_prefix("Quantity", current_bucket)
  codegen_helpers.to_snake_case(target_type)
  <> "_slice_try_from_"
  <> {
    base_type
    |> string.replace(complex_prefix, "")
    |> codegen_helpers.to_snake_case
  }
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
          "fn "
          <> slice_converter_name(
            context.current_bucket,
            target_type,
            base_type,
          )
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
          <> "\", int.to_string(index)])])\n  }\n}\n\n"
        False ->
          record_conversion_from_fields(
            context,
            target_type,
            base_type,
            profile_fields(target_fields),
            Some(base_type),
            Some(json_name),
          )
      }
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
  let complex_prefix =
    codegen_helpers.bucket_prefix("Quantity", context.current_bucket)
  let #(_, _, _, _, target_type) =
    profile_element_names(context, parent_type, root)
  let #(_, _, _, _, base_type) =
    profile_element_names(context, parent_type, group)
  case profile_extension_definition(root, context.extensions) {
    Some(_) -> panic as "extension slice must use extension fold"
    None ->
      case
        set.contains(context.nested_value_discriminators, root.id),
        dict.get(context.slice_type_overrides, root.id)
      {
        True, _ -> {
          let base_encoder = case string.starts_with(base_type, "ct.") {
            True ->
              complex_prefix
              <> {
                base_type
                |> string.drop_start(3)
                |> codegen_helpers.to_snake_case
              }
              <> "_to_json"
            False -> codegen_helpers.to_snake_case(base_type) <> "_to_json"
          }
          ResourceSliceMatch(
            expression: "case json.parse(json.to_string("
              <> base_encoder
              <> "("
              <> source
              <> ")), "
              <> {
              target_type
              |> string.split(".")
              |> list.map(codegen_helpers.to_snake_case)
              |> string.join(".")
            }
              <> "_decoder()) { Ok(matched) -> Ok(matched) Error(_) -> Error(Nil) }",
            success_pattern: "matched",
            selected: "Ok(" <> constructor <> "(matched))",
            fallible: False,
          )
        }
        False, Ok(_) -> {
          let expression =
            slice_match(context, parent_type, group, root, source)
          ResourceSliceMatch(
            expression:,
            success_pattern: "matched",
            selected: "Ok(" <> constructor <> "(matched))",
            fallible: False,
          )
        }
        False, Error(_) -> {
          let target_fields = case
            fields_for_profile_type(context, target_type, "")
          {
            Ok(fields) -> fields
            Error(_) ->
              panic as { "missing slice target fields " <> target_type }
          }
          let assert Ok(discriminator) =
            list.find(target_fields, fn(field) {
              dict.has_key(context.slice_type_overrides, field.id)
            })
          let assert Ok(discriminator_override) =
            dict.get(context.slice_type_overrides, discriminator.id)
          let discriminator_type = case discriminator_override {
            FixedSliceType(discriminator_type, _, _, _, _) -> discriminator_type
            FixedValueDiscriminator(_) -> "FixedValueDiscriminator"
            BoundCodeableconceptSlice -> "BoundCodeableconcept"
            BoundCodingSlice -> "BoundCoding"
          }
          let #(_, _, _, discriminator_field, _) =
            profile_element_names(context, target_type, discriminator)
          let #(source_min, source_max, source_discriminator) = case
            string.starts_with(base_type, "ct.")
            || {
              context.current_bucket == codegen_helpers.ComplexTypes
              && result.is_error(fields_for_profile_type(context, base_type, ""))
            }
          {
            True -> {
              let base_element = case
                dict.get(context.base_elements, discriminator.base.path)
              {
                Ok(base_element) -> base_element
                Error(_) ->
                  panic as {
                    "missing base slice discriminator "
                    <> discriminator.base.path
                  }
              }
              #(profile_field_min(base_element), base_element.max, base_element)
            }
            False -> {
              let source_fields = case
                fields_for_profile_type(context, base_type, "")
              {
                Ok(fields) -> fields
                Error(_) ->
                  panic as { "missing slice source fields " <> base_type }
              }
              let source_discriminator = case
                list.find(source_fields, fn(field) {
                  field.base.path == discriminator.base.path
                })
              {
                Ok(field) -> field
                Error(_) ->
                  panic as {
                    "missing slice source discriminator "
                    <> discriminator.base.path
                    <> " in "
                    <> base_type
                  }
              }
              #(
                profile_field_min(source_discriminator),
                source_discriminator.max,
                source_discriminator,
              )
            }
          }
          let repeated_fixed_coding =
            source_min == 0
            && source_max == "*"
            && discriminator.min == 0
            && discriminator.max == "*"
            && discriminator.base.path == "CodeableConcept.coding"
            && discriminator.pattern_coding == None
            && string.starts_with(discriminator_type, "ct.CodingFixed")
          case source_min, source_max, repeated_fixed_coding {
            0, "1", _ | 1, "1", _ | 0, "*", True -> Nil
            _, _, _ ->
              panic as {
                "unsupported slice source discriminator cardinality "
                <> int.to_string(source_min)
                <> ".."
                <> source_max
                <> " for "
                <> base_type
                <> "."
                <> discriminator_field
              }
          }
          let #(system, code, display) = case discriminator_override {
            FixedSliceType(_, _, system, code, display) -> #(
              system,
              code,
              display,
            )
            FixedValueDiscriminator(expected) -> #(expected, "", None)
            BoundCodeableconceptSlice | BoundCodingSlice -> #("", "", None)
          }
          let discriminator_value = source <> "." <> discriminator_field
          let discriminator_value = case source_min, source_max {
            0, "1" -> "value"
            _, _ -> discriminator_value
          }
          let expression = case repeated_fixed_coding, discriminator_override {
            True, FixedSliceType(..) -> {
              let assert Ok(codegen_slice_complex_type.ResultDiscriminatorCall(
                check,
              )) =
                codegen_slice_complex_type.discriminator_from_base_call(
                  context.current_bucket,
                  discriminator_type,
                  "coding",
                  system,
                  code,
                  display,
                )
              "case "
              <> source
              <> "."
              <> discriminator_field
              <> " { [] -> Error(Nil) codings -> list.try_map(codings, fn(coding) { "
              <> check
              <> " }) }"
            }
            _, FixedSliceType(..)
            | _, BoundCodeableconceptSlice
            | _, BoundCodingSlice
            ->
              slice_match(
                context,
                base_type,
                source_discriminator,
                discriminator,
                discriminator_value,
              )
            _, _ -> {
              let assert Ok(call) =
                codegen_slice_complex_type.discriminator_from_base_call(
                  context.current_bucket,
                  discriminator_type,
                  discriminator_value,
                  system,
                  code,
                  display,
                )
              let codegen_slice_complex_type.ResultDiscriminatorCall(expression) =
                call
              expression
            }
          }
          let expression = case source_min, source_max {
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
            Ok(DirectSliceRecordExpression(
              expression: record,
              consumes_discriminator:,
            )) ->
              ResourceSliceMatch(
                expression:,
                success_pattern: case consumes_discriminator {
                  True -> "matched"
                  False -> "_"
                },
                selected: "Ok(" <> constructor <> "(" <> record <> "))",
                fallible: False,
              )
            Error(_) -> {
              let converter =
                slice_converter_name(
                  context.current_bucket,
                  target_type,
                  base_type,
                )
              let selected =
                converter
                <> "("
                <> source
                <> ", index, matched) |> result.map("
                <> constructor
                <> ")"
              ResourceSliceMatch(
                expression:,
                success_pattern: "matched",
                selected:,
                fallible: True,
              )
            }
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
  "case "
  <> match.expression
  <> " {\n          Ok("
  <> match.success_pattern
  <> ") -> "
  <> match.selected
  <> "\n          Error(_) -> "
  <> unmatched
  <> "\n        }"
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

fn base_slice_placeholder(context: DecodeContext, base_type: String) -> String {
  case fields_for_profile_type(context, base_type, "") {
    Ok(_) -> profile_record_placeholder(context, base_type)
    Error(_) -> {
      let parts = string.split(base_type, ".")
      case base_type, parts {
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
        _, [module, type_] ->
          module <> "." <> codegen_helpers.to_snake_case(type_) <> "_new()"
        _, _ -> codegen_helpers.to_snake_case(base_type) <> "_new()"
      }
    }
  }
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
  let group_type = slice_group_type_name(parent_type, group)
  let accumulator_type = group_type <> "SliceAccumulator"
  let assert Ok(field_part) = group.path |> string.split(".") |> list.last
  let parsed_type =
    parent_type <> "Parsed" <> string.capitalise(field_part) <> "Slice"
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
        <> accumulator_type
        <> case roots, slicing.rules {
          [_], "closed" -> "("
          _, _ -> "(..accumulator, "
        }
        <> root_field
        <> ": "
        <> stored_value
        <> "))\n"
      #(decode_branch, fold_branch)
    })
  let unmatched_decoder = case slicing.rules {
    "open" | "openAtEnd" ->
      complex_prefix
      <> "extension_decoder() |> decode.map(fn(value) { Ok("
      <> parsed_type
      <> "Open(value)) })"
    "closed" ->
      "decode.failure(Error(\"unmatched extension\"), \"one permitted slice\")"
    rules -> panic as { "unknown slicing rule " <> rules }
  }
  let unmatched_fold = case slicing.rules {
    "open" | "openAtEnd" ->
      "                  "
      <> parsed_type
      <> "Open(value) -> Ok("
      <> accumulator_type
      <> "(..accumulator, open: ["
      <> stored_open_value
      <> ", ..accumulator.open]))\n"
    _ -> ""
  }
  let support_source =
    "pub fn "
    <> entry_decoder
    <> "() -> Decoder(Result("
    <> parsed_type
    <> ", String)) {\n"
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
    <> case roots, slicing.rules {
      [codegen_helpers.Element(max: "1", ..)], "closed" -> "_accumulator"
      _, _ -> "accumulator"
    }
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
  let decoder_source = case decoder_placeholder {
    None -> ""
    Some(placeholder) ->
      "  let "
      <> result_name
      <> "_decoder = case "
      <> result_name
      <> " {\n    Ok("
      <> result_name
      <> ") -> decode.success("
      <> result_name
      <> ")\n    Error(errors) ->\n      decode.failure("
      <> placeholder
      <> ", \""
      <> parent_type
      <> " slices\")\n      |> decode.map_errors(fn(_) { errors })\n  }\n"
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
    source: fold_source <> result_source <> decoder_source,
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
  let base_decoder = case use_profile_slice_base {
    True ->
      case string.starts_with(base_type, "ct.") {
        True ->
          complex_prefix
          <> codegen_helpers.to_snake_case(string.drop_start(base_type, 3))
          <> "_decoder()"
        False -> codegen_helpers.to_snake_case(base_type) <> "_decoder()"
      }
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
  let indexed =
    context.preserve_slice_order
    && !is_aggregate
    || list.any(roots, fn(root) {
      resource_slice_match(
        context,
        parent_type,
        group,
        root,
        field_name,
        "Slice",
      ).fallible
    })
  let extension_group =
    list.any(group.type_, fn(type_) { type_.code == "Extension" })
  let stored_named_value = fn(value) {
    case context.preserve_slice_order, extension_group {
      True, True -> value
      True, False -> complex_prefix <> "SliceElt(" <> value <> ", Some(index))"
      False, _ -> value
    }
  }
  let stored_open_value = fn(value) {
    case context.preserve_slice_order {
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
  let decode_raw =
    list.any(roots, fn(root) {
      set.contains(context.nested_value_discriminators, root.id)
    })
  let classifier =
    roots
    |> list.reverse
    |> list.fold(unmatched, fn(unmatched, root) {
      case
        decode_raw && set.contains(context.nested_value_discriminators, root.id)
      {
        True -> {
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
          let decoded =
            "case decode.run("
            <> field_name
            <> "_raw, "
            <> {
              root_type
              |> string.split(".")
              |> list.map(codegen_helpers.to_snake_case)
              |> string.join(".")
            }
            <> "_decoder()) { Ok(matched) -> Ok("
            <> constructor
            <> "(matched)) Error(_) -> "
            <> unmatched
            <> " }"
          case dict.get(context.slice_discriminator_checks, root.id) {
            Ok(check) -> {
              let checked_context =
                DecodeContext(
                  ..context,
                  slice_type_overrides: dict.insert(
                    context.slice_type_overrides,
                    root.id,
                    check,
                  ),
                )
              "case "
              <> slice_match(
                checked_context,
                parent_type,
                group,
                root,
                field_name,
              )
              <> " { Ok(_) -> "
              <> decoded
              <> " Error(_) -> "
              <> unmatched
              <> " }"
            }
            Error(_) -> decoded
          }
        }
        False ->
          slice_classifier_case(
            context,
            parent_type,
            group,
            root,
            field_name,
            unmatched,
            is_aggregate,
          )
      }
    })
  let classifier = case decode_raw {
    False -> classifier
    True ->
      "case decode.run("
      <> field_name
      <> "_raw, "
      <> base_decoder
      <> ") { Ok("
      <> field_name
      <> ") -> "
      <> classifier
      <> " Error(errors) -> Error(errors) }"
  }
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
          <> ": ["
          <> stored_named_value("value")
          <> ", ..accumulator."
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
          <> "(..accumulator, open: ["
          <> stored_open_value("value")
          <> ", ..accumulator.open]))\n"
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
    <> case decode_raw {
      True -> "decode.dynamic"
      False -> base_decoder
    }
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
    <> case decode_raw {
      True -> "_raw"
      False -> ""
    }
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
      let decoder_source =
        "  let "
        <> result_name
        <> "_decoder = case "
        <> result_name
        <> " {\n    Ok("
        <> result_name
        <> ") -> decode.success("
        <> result_name
        <> ")\n    Error(errors) ->\n      decode.failure("
        <> placeholder
        <> ", \""
        <> parent_type
        <> " slices\")\n      |> decode.map_errors(fn(_) { errors })\n  }\n"
      SliceGroupDecode(
        source: fold_source <> result_source <> decoder_source,
        support_source: "",
        result_name:,
        success_pattern: "Ok(" <> field_name <> ")",
        decoded_fields: [#(field_name, result_name)],
        decoder_placeholder: Some(placeholder),
        placeholder_fields: [#(field_name, placeholder)],
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
              case context.preserve_slice_order, extension_group {
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
      let decoder_source =
        "  let "
        <> result_name
        <> "_decoder = case "
        <> result_name
        <> " {\n    Ok("
        <> result_name
        <> ") -> decode.success("
        <> result_name
        <> ")\n    Error(errors) ->\n      decode.failure("
        <> decoder_placeholder
        <> ", \""
        <> parent_type
        <> " slices\")\n      |> decode.map_errors(fn(_) { errors })\n  }\n"
      let placeholder_fields = case slicing.rules {
        "open" | "openAtEnd" -> [
          #(field_name, open_placeholder),
          ..named_placeholder_fields
        ]
        _ -> named_placeholder_fields
      }
      SliceGroupDecode(
        source: fold_source <> result_source <> decoder_source,
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
) -> String {
  let constructor_fields =
    profile_fields(fields)
    |> list.filter(fn(element) {
      let #(_, field_path, json_name, _, _) =
        profile_element_names(context, target_type, element)
      !omit_fixed
      || { element.fixed_code == None && element.fixed_uri == None }
      || profile_field_is_primitive_slice(
        element,
        json_name,
        context.type_order,
        field_path,
      )
    })
  let slice_groups =
    fields
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
  let #(bindings, choices, slice_decodes) =
    list.fold(fields, #("", "", []), fn(acc, element) {
      let #(bindings, choices, slice_decodes) = acc
      let #(_, field_path, json_name, field_name, _) =
        profile_element_names(context, target_type, element)
      case dict.get(slice_groups, element.id) {
        Ok(roots) -> {
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
            choices <> slice_decode.support_source,
            [slice_decode, ..slice_decodes],
          )
        }
        Error(_) ->
          case
            primitive && { json_name == "value" || json_name == "id" },
            list.contains(slice_root_ids, element.id),
            list.any(constructor_fields, fn(field) { field.id == element.id }),
            omit_fixed
            && { element.fixed_code != None || element.fixed_uri != None }
          {
            True, _, _, _ | _, True, _, _ | _, _, False, False -> #(
              bindings,
              choices,
              slice_decodes,
            )
            _, _, _, True -> {
              let variable =
                json_name
                |> codegen_helpers.escape_field_name
                |> codegen_helpers.to_snake_case
              #(
                bindings
                  <> case
                  profile_field_is_primitive_slice(
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
                    <> field_decoder_expression(context, target_type, element)
                    <> "\n"
                  False -> ""
                }
                  <> "  use "
                  <> variable
                  <> "_fixed <- "
                  <> case element.base.max, element.max {
                  "1", _ ->
                    "decode.field(\"" <> json_name <> "\", decode.string)"
                  _, "1" ->
                    codegen_helpers.bucket_prefix(
                      "Quantity",
                      context.current_bucket,
                    )
                    <> "one_from_array_decoder(\""
                    <> json_name
                    <> "\", decode.string)"
                  _, _ ->
                    "decode.field(\""
                    <> json_name
                    <> "\", decode.list(decode.string))"
                }
                  <> "\n",
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
      let #(_, _, json_name, field_name, _) =
        profile_element_names(context, target_type, element)
      arguments
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
      arguments
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
    <> "(\n"
    <> placeholder_arguments
    <> "  )\n"
  let slice_decoder_bindings = case typed_slice_decoders {
    False | True -> ""
  }
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
            let matches = case element.base.max, element.max {
              "1", _ | _, "1" -> variable <> "_fixed == \"" <> fixed <> "\""
              _, _ ->
                "list.all("
                <> variable
                <> "_fixed, fn(value) { value == \""
                <> fixed
                <> "\" })"
            }
            let mismatch = case element.base.max, element.max {
              "1", _ | _, "1" -> variable <> "_fixed != \"" <> fixed <> "\""
              _, _ -> "!" <> matches
            }
            source
            <> case typed_slice_decoders {
              False ->
                "  use <- bool.guard("
                <> mismatch
                <> ", decode.failure(placeholder, \"fixed "
                <> json_name
                <> "\"))\n"
              True ->
                "  use _ <- decode.then(case "
                <> matches
                <> " { True -> decode.success("
                <> variable
                <> "_fixed) False -> decode.failure("
                <> variable
                <> "_fixed, \"fixed "
                <> json_name
                <> "\") })\n"
            }
          }
        }
      })
  }
  let resource_guard = case resource_type {
    None -> ""
    Some(resource_type) ->
      case typed_slice_decoders {
        False ->
          "  use resource_type_value <- decode.field(\"resourceType\", decode.string)\n  use <- bool.guard(resource_type_value != \""
          <> resource_type
          <> "\", decode.failure(placeholder, \"resourceType\"))\n"
        True ->
          "  use _ <- decode.field(\n    \"resourceType\",\n    decode.then(decode.string, fn(resource_type) {\n      case resource_type {\n        \""
          <> resource_type
          <> "\" -> decode.success(resource_type)\n        _ -> decode.failure(resource_type, \""
          <> resource_type
          <> "\")\n      }\n    }),\n  )\n"
      }
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
        list.find(constructor_fields, fn(element) {
          profile_json_field_name(element, "") == "value"
        })
      let #(_, _, _, _, field_type) =
        profile_element_names(context, target_type, value_field)
      let assert [scalar_type] = value_field.type_
      let #(parts, _, _, _, _) =
        profile_element_names(context, target_type, value_field)
      let scalar_decoder =
        codegen_decode.string_to_decoder_type(
          scalar_type.code,
          parts,
          "r4",
          value_field,
          context.current_bucket,
        )
      #(field_type, case value_field.min {
        0 -> "  let value = primitive.value\n"
        _ ->
          "  use value <- decode.then(case primitive.value { Some(value) -> decode.success(value) None -> "
          <> scalar_decoder
          <> " |> decode.then(fn(value) { decode.failure(value, \"primitive scalar value is required\") }) })\n"
      })
    }
  }
  choices
  <> "pub fn "
  <> codegen_helpers.to_snake_case(target_type)
  <> case primitive {
    True ->
      "_from_primitive(\n  primitive: Primitive("
      <> primitive_value_type
      <> ", Result("
      <> target_type
      <> "ParsedExtensionSlice, String)),\n) -> Decoder("
      <> target_type
      <> ") {\n"
    False ->
      "_decoder() -> Decoder("
      <> target_type
      <> ") {\n  use <- decode.recursive\n"
  }
  <> primitive_value_binding
  <> bindings
  <> slice_decoder_bindings
  <> case typed_slice_decoders {
    True -> ""
    False -> placeholder
  }
  <> fixed_guards
  <> resource_guard
  <> result
  <> "}\n\n"
}

fn extension_value_branch(
  current_bucket: codegen_helpers.Category,
  extension_name: String,
  field: codegen_helpers.Element,
  valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
  _available_valuesets: dict.Dict(String, codegen_helpers.VsOrCs),
  primitive_values: dict.Dict(String, PrimitiveExtensionValue),
) -> #(String, String) {
  let complex_prefix = codegen_helpers.bucket_prefix("Quantity", current_bucket)
  let raw_field_name = extension_field_name(field)
  let field_name = raw_field_name |> codegen_helpers.to_snake_case
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
        codegen_helpers.string_to_type(
          type_.code,
          [extension_name, field_name],
          narrowed,
          current_bucket,
          valueset_acc,
        )
      let scalar_decoder =
        codegen_decode.string_to_decoder_type(
          type_.code,
          [extension_name, field_name],
          "r4",
          narrowed,
          current_bucket,
        )
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
) -> String {
  let complex_prefix = codegen_helpers.bucket_prefix("Quantity", current_bucket)
  case extension.kind {
    SimpleExtension(_) -> ""
    ComplexExtension(
      [codegen_helpers.Element(path: "Extension.value[x]", ..) as field],
      _,
    ) -> {
      let field_name =
        extension_field_name(field) |> codegen_helpers.to_snake_case
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
      let branches =
        list.map(fields, fn(field) {
          let assert Ok(field_url) = field.id |> string.split(".") |> list.last
          let field_name =
            extension_field_name(field) |> codegen_helpers.to_snake_case
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
            <> accumulator_name
            <> "(..accumulator, "
            <> field_name
            <> ": "
            <> stored_value
            <> "))"
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
          let field_name =
            extension_field_name(field) |> codegen_helpers.to_snake_case
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
          <> accumulator_name
          <> "(..accumulator, open: ["
          <> complex_prefix
          <> "SliceElt(child, Some(index)), ..accumulator.open]))\n"
        True, False ->
          "                      "
          <> parsed_type
          <> "Open(child) -> Ok("
          <> accumulator_name
          <> "(..accumulator, open: [child, ..accumulator.open]))\n"
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
          let name =
            extension_field_name(field) |> codegen_helpers.to_snake_case
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
          let field_name =
            extension_field_name(field) |> codegen_helpers.to_snake_case
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
          dict.has_key(context.slice_type_overrides, root.id)
          || set.contains(context.nested_value_discriminators, root.id),
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
    // Slice converters construct their records directly.
    |> list.flat_map(fn(current_type) {
      conversion_dependencies(context, profile_type, current_type)
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
  nested_value_discriminators: Set(String),
  slice_discriminator_checks: dict.Dict(String, SliceFieldType),
  type_slice_overrides: dict.Dict(String, SlicePlan),
  preserve_slice_order: Bool,
  valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
  available_valuesets: dict.Dict(String, codegen_helpers.VsOrCs),
  base_elements: dict.Dict(String, codegen_helpers.Element),
  generated_extension_classifiers: Set(String),
) -> #(String, Set(String)) {
  let context =
    DecodeContext(
      resource_type:,
      current_bucket:,
      is_resource:,
      profile_prefix:,
      snapshot_elements:,
      type_order:,
      type_fields:,
      extensions:,
      slice_base_type_names:,
      slice_type_overrides:,
      datatype_types:,
      nested_value_discriminators:,
      slice_discriminator_checks:,
      type_slice_overrides:,
      preserve_slice_order:,
      valueset_acc:,
      available_valuesets:,
      base_elements:,
    )
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
      )
    })
  let generated_extension_classifiers =
    extension_items
    |> list.map(fn(item) { item.0 })
    |> set.from_list
    |> set.union(generated_extension_classifiers)
  let conversion_types = conversion_types(context, profile_type)
  let conversions =
    list.fold(type_order, "", fn(source, current_type) {
      case list.contains(conversion_types, current_type) {
        False -> source
        True ->
          source
          <> record_conversion_source(context, current_type, profile_type)
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
    })
  #(
    extension_classifiers
      <> slice_support_types(context, profile_type)
      <> conversions
      <> decoders,
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
          case element.fixed_code, element.fixed_uri {
            _, _ if primitive_slice_record && json_name == "value" -> Error(Nil)
            Some(value), _ | _, Some(value) -> {
              let value_json = "json.string(\"" <> value <> "\")"
              Ok(
                "#(\""
                <> json_name
                <> "\", "
                <> case element.base.max {
                  "1" -> value_json
                  _ -> "json.preprocessed_array([" <> value_json <> "])"
                }
                <> "),",
              )
            }
            _, _ -> Error(Nil)
          }
        })
        |> string.concat
      let fields =
        list.filter(fields, fn(element) {
          {
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
            let safe_field_name =
              last_part
              |> string.replace("[x]", "")
              |> codegen_helpers.escape_field_name
            let field_name =
              option.unwrap(element.slice_name, safe_field_name)
              |> codegen_helpers.escape_field_name
              |> codegen_helpers.to_snake_case
            let record_name = case primitive_slice_record {
              True -> "primitive"
              False -> codegen_helpers.to_snake_case(gleam_type)
            }
            let field_value = record_name <> "." <> field_name
            let choice_type = gleam_type <> string.capitalise(safe_field_name)
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

            case element.slice_name, slice_roots, is_primitive_slice {
              Some(_), _, _ -> #(
                json_always,
                json_optional,
                choice_encoders,
                valueset_acc,
              )
              None, _, True -> {
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
              None, [_, ..], False if !is_choice_path -> {
                let indexed_slice_group = preserve_slice_order
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
                    let assert Ok(root_last) = root_parts |> list.last
                    let root_field_name =
                      option.unwrap(root.slice_name, root_last)
                      |> codegen_helpers.escape_field_name
                      |> codegen_helpers.to_snake_case
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
              None, _, False -> {
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
