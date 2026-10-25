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
    codegen_helpers.ComplexTypes -> "complex_type."
    codegen_helpers.Resources -> "resource."
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
    payload_types: List(String),
  )
}

pub fn record_choice(
  constructors: dict.Dict(String, ConstructorDefinition),
  bucket: codegen_helpers.Category,
  name: String,
  variant: String,
  payload_type: String,
) -> dict.Dict(String, ConstructorDefinition) {
  let key = constructor_key(bucket, name)
  let definition = case dict.get(constructors, key) {
    Ok(ChoiceConstructor(..) as previous) ->
      ChoiceConstructor(..previous, payload_types: [
        payload_type,
        ..previous.payload_types
      ])
    _ -> ChoiceConstructor(bucket, variant, payload_type, [payload_type])
  }
  dict.insert(constructors, key, definition)
}

pub fn constructor_requirements(
  constructors: dict.Dict(String, ConstructorDefinition),
  current_bucket: codegen_helpers.Category,
) -> codegen_helpers.RequiredCode {
  constructors
  |> dict.values
  |> list.fold(codegen_helpers.required_code(), fn(required, constructor) {
    case constructor {
      RecordConstructor(bucket, arguments, fields) if bucket == current_bucket -> {
        let required =
          list.fold(fields, required, fn(required, field) {
            let required = codegen_helpers.require_type(required, field.1)
            case field.0.type_, field.1 {
              [_, _, ..], _ -> required
              _, "Option(String)" ->
                codegen_helpers.require_function(
                  required,
                  "decode_optional_string",
                )
              _, "Option(Bool)" ->
                codegen_helpers.require_function(
                  required,
                  "decode_optional_bool",
                )
              _, _ -> required
            }
          })
        list.fold(arguments, required, fn(required, argument) {
          codegen_helpers.require_type(required, argument.1)
        })
      }
      ChoiceConstructor(bucket, _, _, payload_types)
        if bucket == current_bucket
      -> list.fold(payload_types, required, codegen_helpers.require_type)
      _ -> required
    }
  })
}

pub type ExtensionDefinition {
  ExtensionDefinition(
    name: String,
    url: String,
    kind: ExtensionKind,
    primitive_values: dict.Dict(String, PrimitiveExtensionValue),
    elements: List(codegen_helpers.Element),
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
  use <- bool.guard(
    case element.constraint {
      Some(codegen_constraint.Constraint(fixed: True, ..)) -> True
      _ -> False
    },
    None,
  )
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
) -> List(Option(a)) {
  case list.contains(["Extension", "Resource", "DomainResource"], type_.code) {
    True -> []
    False -> {
      let #(base, profiles_) =
        list.partition(type_.profile, fn(url) {
          canonical_url(url)
          == "http://hl7.org/fhir/StructureDefinition/" <> type_.code
        })
      let alternatives = case type_.profile {
        [_, _, ..] ->
          list.map(profiles_, fn(url) {
            let assert Ok(profile) = dict.get(profiles, canonical_url(url))
              as { "unable to resolve datatype profile alternative " <> url }
            Some(profile)
          })
        _ ->
          profiles_
          |> list.filter_map(fn(url) {
            dict.get(profiles, canonical_url(url)) |> result.map(Some)
          })
      }
      list.append(alternatives, list.map(base, fn(_) { None }))
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
  let boolean_type = case codegen_helpers.constant(element) {
    Some(codegen_constraint.Boolean(False)) -> "ExplicitFalse"
    Some(codegen_constraint.Boolean(True)) -> "ExplicitTrue"
    _ -> ""
  }
  use <- bool.guard(
    boolean_type != "" && element.min == 0 && element.max == "1",
    #(
      codegen_helpers.bucket_prefix("Quantity", current_bucket) <> boolean_type,
      valueset_acc,
    ),
  )
  use <- bool.guard(
    case codegen_helpers.constant(element) {
      Some(codegen_constraint.Text(_))
      | Some(codegen_constraint.Integer(_))
      | Some(codegen_constraint.Decimal(_)) -> True
      Some(codegen_constraint.Boolean(_)) ->
        element.min != 0 || element.max != "1"
      _ -> False
    },
    #("Nil", valueset_acc),
  )
  case element.gleam_arguments, element.gleam_type {
    Some(_), Some(name) -> #(
      codegen_helpers.bucket_prefix("Quantity", current_bucket) <> name,
      valueset_acc,
    )
    _, _ ->
      case resolve_datatype_profiles(type_, datatype_types) {
        [Some(profile_type)] -> #(
          codegen_helpers.bucket_prefix("Quantity", current_bucket)
            <> profile_type,
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
  type_slice_overrides: dict.Dict(String, SlicePlan),
  valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
) -> #(
  String,
  codegen_helpers.Element,
  dict.Dict(String, codegen_helpers.ValuesetItem),
) {
  use <- bool.guard(
    case element.constraint {
      Some(codegen_constraint.Constraint(
        fixed: True,
        value: codegen_constraint.Object(_),
        ..,
      )) -> True
      _ -> False
    },
    #("Nil", element, valueset_acc),
  )
  let #(element, local_type) = case element.type_ {
    [type_] ->
      case
        dict.get(type_slice_overrides, type_slice_key(element.id, type_.code))
      {
        Ok(TypeSlicePlan(slice:, children:, ..)) -> {
          let source =
            codegen_helpers.Element(
              ..element,
              type_: slice.type_,
              binding: option.or(slice.binding, element.binding),
              constraint: option.or(slice.constraint, element.constraint),
              pattern_coding: option.or(
                slice.pattern_coding,
                element.pattern_coding,
              ),
              pattern_codeableconcept: option.or(
                slice.pattern_codeableconcept,
                element.pattern_codeableconcept,
              ),
              pattern_identifier: option.or(
                slice.pattern_identifier,
                element.pattern_identifier,
              ),
              gleam_type: option.or(slice.gleam_type, element.gleam_type),
              gleam_arguments: option.or(
                slice.gleam_arguments,
                element.gleam_arguments,
              ),
            )
          case children {
            [] -> #(source, None)
            _ -> {
              let assert [profile_prefix, ..] = all_parts
              let assert [_, ..parts] =
                slice.id
                |> string.replace("-", "")
                |> string.replace(":", ".")
                |> string.split(".")
              let key =
                string.join([profile_prefix, ..parts], "_")
                |> string.replace("[x]", "")
                |> codegen_helpers.to_camel_case
              let assert Ok(name) = dict.get(slice_base_type_names, key)
              #(
                codegen_helpers.Element(
                  ..source,
                  gleam_type: Some(name),
                  gleam_arguments: Some([]),
                ),
                Some(name),
              )
            }
          }
        }
        _ -> #(element, None)
      }
    _ -> #(element, None)
  }
  let #(field_type, valueset_acc) = case local_type {
    Some(name) -> #(name, valueset_acc)
    None -> {
      let complex_prefix =
        codegen_helpers.bucket_prefix("Quantity", current_bucket)
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
  }
  #(field_type, element, valueset_acc)
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
  && {
    element.gleam_arguments != None
    || does_profile_restrict_complex_type(type_order, field_path)
  }
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
  _current_bucket: codegen_helpers.Category,
  element: codegen_helpers.Element,
  field_name: String,
  json_name: String,
  json_suffix: String,
  encoder: String,
  encoder_call: fn(String) -> String,
  card_min: Int,
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
      always("list2_to_json(" <> field_name <> ", " <> encoder <> ")"),
      "",
    )
    "*", _, 3 -> #(
      always("list3_to_json(" <> field_name <> ", " <> encoder <> ")"),
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
  snapshot_elements: List(codegen_helpers.Element),
) -> String {
  let constant = case base_field_type, element.constraint {
    "Nil",
      Some(
        codegen_constraint.Constraint(value: codegen_constraint.Object(_), ..) as constraint,
      )
    -> "fn(_) { " <> codegen_constraint.json_source(constraint.value) <> " }"
    _, _ -> ""
  }
  use <- bool.guard(constant != "", constant)
  case element.gleam_arguments {
    Some(_) ->
      "{ fn(value) { "
      <> profile_element_encoder_call(
        current_bucket,
        element,
        base_field_type,
        all_parts,
        field_path,
        type_order,
        slice_type_overrides,
        datatype_types,
        snapshot_elements,
        "value",
      )
      <> " } }"
    None -> {
      let complex_prefix =
        codegen_helpers.bucket_prefix("Quantity", current_bucket)
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
          let has_profile_union = case
            element.type_,
            dict.has_key(slice_type_overrides, element.id)
          {
            [type_], False ->
              list.length(resolve_datatype_profiles(type_, datatype_types)) > 1
            _, _ -> False
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
                      codegen_helpers.to_snake_case(base_field_type)
                      <> "_to_json"
                  }
              }
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
  let constant = case base_field_type, element.constraint {
    "Nil",
      Some(
        codegen_constraint.Constraint(value: codegen_constraint.Object(_), ..) as constraint,
      )
    -> codegen_constraint.json_source(constraint.value)
    _, _ -> ""
  }
  use <- bool.guard(constant != "", constant)
  case element.gleam_arguments {
    Some(arguments) -> {
      let function =
        base_field_type
        |> string.split(".")
        |> list.map(codegen_helpers.to_snake_case)
        |> string.join(".")
      function
      <> "_to_json("
      <> value
      <> string.concat(
        list.map(arguments, fn(argument) {
          ", " <> json.to_string(json.string(argument))
        }),
      )
      <> ")"
    }
    None -> {
      let complex_prefix =
        codegen_helpers.bucket_prefix("Quantity", current_bucket)
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
          let has_profile_union = case
            element.type_,
            dict.has_key(slice_type_overrides, element.id)
          {
            [type_], False ->
              list.length(resolve_datatype_profiles(type_, datatype_types)) > 1
            _, _ -> False
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
  type_slice_overrides: dict.Dict(String, SlicePlan),
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
      let #(root_type, root, _) =
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
          type_slice_overrides,
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
            <> "SliceElement("
            <> root_call(value <> ".value", Some(value <> ".id"))
            <> ", "
            <> value
            <> ".internal_gleam_fhir_index)"
          True, None ->
            complex_prefix
            <> "SliceElement("
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
        <> "SliceElement("
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
      <> "slice_elements_to_values(slice_values)"

    False -> ""
  }
  <> "\nlet fields = case slice_values {\n  [] -> fields\n  values -> [#(\""
  <> json_field_name
  <> "\", json.preprocessed_array(values)), ..fields]\n}"
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
    slice_inputs: dict.Dict(String, List(codegen_helpers.Element)),
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
    binding_checks: dict.Dict(String, String),
    // available_valuesets: dict.Dict(String, codegen_helpers.VsOrCs),
    base_elements: dict.Dict(String, codegen_helpers.Element),
    constructors: dict.Dict(String, ConstructorDefinition),
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

type SliceGroupDecode {
  SliceGroupDecode(
    source: String,
    support_source: String,
    result_name: String,
    fallible: Bool,
    success_pattern: String,
    decoded_fields: List(#(String, String)),
    decoder_placeholder: Option(String),
    placeholder_fields: List(#(String, String)),
    extension_decoder: Option(#(String, String)),
  )
}

type NestedSliceCase {
  NestedSliceCase(
    root: codegen_helpers.Element,
    field: codegen_helpers.Element,
    type_name: String,
    fields: List(#(codegen_helpers.Element, String)),
    pattern: codegen_helpers.Element,
    member_type: String,
    constants: List(#(String, codegen_constraint.Value)),
    selector: List(#(String, codegen_constraint.Value)),
    fixed: List(String),
    required: List(String),
    omitted: List(String),
  )
}

type NestedSliceField {
  NestedSliceField(
    field: codegen_helpers.Element,
    base_type: String,
    base_fields: List(#(codegen_helpers.Element, String)),
    member: codegen_helpers.Element,
    member_fields: List(codegen_helpers.Element),
    cases: List(NestedSliceCase),
  )
}

fn nested_slice_field(
  context: DecodeContext,
  parent_type: String,
  group: codegen_helpers.Element,
  roots: List(codegen_helpers.Element),
) -> Option(NestedSliceField) {
  option.from_result({
    let assert Some(slicing) = group.slicing
    use first <- result.try(list.first(slicing.discriminator))
    let assert [name, ..] = string.split(first.path, ".")
    use _ <- result.try(
      case
        name != "$this"
        && list.all(slicing.discriminator, fn(discriminator) {
          let assert [first, ..] = string.split(discriminator.path, ".")
          first == name
          && {
            discriminator.type_ == "value" || discriminator.type_ == "pattern"
          }
        })
      {
        True -> Ok(Nil)
        False -> Error(Nil)
      },
    )
    let #(_, _, _, _, open_type, _) =
      profile_element_names(context, parent_type, group)
    use open_fields <- result.try(fields_for_profile_type(
      context,
      open_type,
      "",
    ))
    use field <- result.try(
      list.find(open_fields, fn(field) {
        profile_json_field_name(field, "") == name
      }),
    )
    let #(_, _, _, _, base_type, _) =
      profile_element_names(context, open_type, field)
    use definition <- result.try(dict.get(
      context.constructors,
      constructor_key(context.current_bucket, base_type),
    ))
    use base_fields <- result.try(case definition {
      RecordConstructor(_, _, fields) -> Ok(fields)
      _ -> Error(Nil)
    })
    use cases <- result.try(
      list.try_map(roots, fn(root) {
        let #(_, _, _, _, root_type, _) =
          profile_element_names(context, parent_type, root)
        use fields <- result.try(fields_for_profile_type(context, root_type, ""))
        use field <- result.try(
          list.find(fields, fn(field) {
            profile_json_field_name(field, "") == name
          }),
        )
        let #(_, _, _, _, type_name, _) =
          profile_element_names(context, root_type, field)
        use definition <- result.try(dict.get(
          context.constructors,
          constructor_key(context.current_bucket, type_name),
        ))
        use fields <- result.try(case definition {
          RecordConstructor(_, _, fields) -> Ok(fields)
          _ -> Error(Nil)
        })
        use #(pattern, stored_type) <- result.try(
          list.find(fields, fn(field) {
            field.0.pattern_match && field.0.slice_name != None
          }),
        )
        use _ <- result.try(
          case
            list.count(fields, fn(field) {
              field.0.pattern_match && field.0.slice_name != None
            })
            == 1
            && pattern.min == 1
            && pattern.max == "*"
          {
            True -> Ok(Nil)
            False -> Error(Nil)
          },
        )
        use constants <- result.try(case pattern.constraint {
          Some(codegen_constraint.Constraint(
            fixed: False,
            value: codegen_constraint.Object(constants),
            ..,
          )) -> Ok(constants)
          _ -> Error(Nil)
        })
        use _ <- result.try(
          case
            list.all(constants, fn(constant) {
              case constant.1 {
                codegen_constraint.Text(_) -> True
                _ -> False
              }
            })
          {
            True -> Ok(Nil)
            False -> Error(Nil)
          },
        )
        let assert [member_type, ..] =
          stored_type |> string.split("(") |> list.reverse
        let member_type = string.replace(member_type, ")", "")
        let assert Ok(#(_, _, fixed, _)) =
          codegen_slice_complex_type.helper_fields(member_type)
          as "no decoder includes all fields for all slices of element because a slice has primitive extension"
        let assert [datatype] = pattern.type_
        let member_fields =
          codegen_slice_complex_type.datatype_fields(
            datatype.code,
            context.base_elements,
          )
        let selector =
          list.filter(constants, fn(constant) {
            list.any(slicing.discriminator, fn(discriminator) {
              discriminator.path == name
              || string.ends_with(discriminator.path, "." <> constant.0)
            })
          })
        use _ <- result.try(case selector != [] && selector == constants {
          True -> Ok(Nil)
          False -> Error(Nil)
        })
        Ok(NestedSliceCase(
          root:,
          field:,
          type_name:,
          fields:,
          pattern:,
          member_type:,
          constants:,
          selector:,
          fixed:,
          required: codegen_slice_complex_type.constraint_fields(
            member_type,
            "Required",
            member_fields,
          ),
          omitted: codegen_slice_complex_type.constraint_fields(
            member_type,
            "Omit",
            member_fields,
          ),
        ))
      }),
    )
    use first <- result.try(list.first(cases))
    use member <- result.try(
      list.find(base_fields, fn(field) { field.0.path == first.pattern.path }),
    )
    let member = member.0
    let assert [datatype] = member.type_
    Ok(NestedSliceField(
      field:,
      base_type:,
      base_fields:,
      member:,
      member_fields: codegen_slice_complex_type.datatype_fields(
        datatype.code,
        context.base_elements,
      ),
      cases:,
    ))
  })
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
  let roots =
    list.filter(elements, fn(element) {
      element.path == group.path
      && element.slice_name != None
      && string.starts_with(element.id, prefix)
      && !string.contains(
        string.drop_start(element.id, string.length(prefix)),
        ".",
      )
    })
  let permitted = list.filter(roots, fn(root) { root.max != "0" })
  let assert False =
    permitted == []
    && roots != []
    && case group.slicing {
      Some(codegen_helpers.Slicing(rules: "closed", ..)) -> True
      _ -> False
    }
    as {
      "closed slicing with no permitted slices is unsupported: " <> group.id
    }
  permitted
}

fn profile_element_names(
  context: DecodeContext,
  parent_type: String,
  element: codegen_helpers.Element,
) -> #(List(String), String, String, String, String, codegen_helpers.Element) {
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
  let #(field_type, element, _) =
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
      context.type_slice_overrides,
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
    element,
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

fn constraint_decoder_source(
  context: DecodeContext,
  element: codegen_helpers.Element,
  constraint: codegen_constraint.Constraint,
) -> #(String, codegen_helpers.RequiredCode) {
  let expected =
    "json.to_string(" <> codegen_constraint.json_source(constraint.value) <> ")"
  case constraint.value {
    codegen_constraint.Object(values) -> {
      let fields =
        codegen_slice_complex_type.datatype_fields(
          constraint.type_name,
          context.base_elements,
        )
        |> list.flat_map(fn(field) {
          case field.type_ {
            [_, _, ..] ->
              list.map(field.type_, fn(type_) {
                codegen_helpers.Element(..field, type_: [type_])
              })
            _ -> [field]
          }
        })
      let assert True =
        list.all(values, fn(value) {
          list.any(fields, fn(field) {
            profile_json_field_name(field, "") == value.0
          })
        })
        as { "unknown fixed/pattern field: " <> element.id }
      let #(bindings, required) =
        list.fold(
          values,
          #("", codegen_helpers.required_code()),
          fn(acc, value) {
            let #(bindings, required) = acc
            let assert Ok(field) =
              list.find(fields, fn(field) {
                profile_json_field_name(field, "") == value.0
              })
            let assert [type_] = field.type_
            let #(decoder, usage) =
              constraint_decoder_source(
                context,
                field,
                codegen_constraint.Constraint(
                  fixed: constraint.fixed,
                  type_name: type_.code,
                  value: value.1,
                ),
              )
            #(
              bindings
                <> "use _ <- decode.field("
                <> json.to_string(json.string(value.0))
                <> ", "
                <> decoder
                <> ")\n",
              codegen_helpers.merge_required_code(required, usage),
            )
          },
        )
      #("{ " <> bindings <> "decode.success(Nil) }", required)
    }
    codegen_constraint.Array(values) -> {
      let assert True = constraint.fixed
        as { "array pattern must use typed slices: " <> element.id }
      let parts =
        list.index_map(values, fn(value, index) {
          let #(source, required) =
            constraint_decoder_source(
              context,
              element,
              codegen_constraint.Constraint(..constraint, value:),
            )
          #(
            "use _ <- decode.field("
              <> int.to_string(index)
              <> ", "
              <> source
              <> ")\n",
            required,
          )
        })
      let bindings = parts |> list.map(fn(part) { part.0 }) |> string.concat
      let required =
        list.fold(parts, codegen_helpers.required_code(), fn(required, part) {
          codegen_helpers.merge_required_code(required, part.1)
        })
      #(
        "{ use shape <- decode.then(decode.list(decode.success(Nil)))\ncase shape { ["
          <> string.join(list.map(values, fn(_) { "Nil" }), ", ")
          <> "] -> { "
          <> bindings
          <> "decode.success(Nil) } "
          <> "_ -> decode.failure(Nil, "
          <> expected
          <> ") } }",
        required,
      )
    }
    _ -> #(
      codegen_constraint.sources(constraint.value, constraint.fixed, "value").1,
      codegen_helpers.RequiredCode(
        ..codegen_helpers.required_code(),
        modules: codegen_constraint.required_modules(
            constraint.value,
            constraint.fixed,
          )
          |> set.insert("list"),
      ),
    )
  }
}

fn field_decoder_expression(
  context: DecodeContext,
  parent_type: String,
  element: codegen_helpers.Element,
  whole_field: Bool,
) -> String {
  let complex_prefix =
    codegen_helpers.bucket_prefix("Quantity", context.current_bucket)
  let #(all_parts, field_path, json_name, _, field_type, element) =
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
  let decoder = case
    string.replace(field_type, "ct.", ""),
    dict.get(context.slice_type_overrides, element.id)
  {
    "ExplicitFalse", _ | "ExplicitTrue", _ -> {
      let assert [type_] = element.type_
      codegen_decode.string_to_decoder_type(
        type_.code,
        all_parts,
        "r4",
        element,
        context.current_bucket,
      )
    }
    "Nil", _ -> {
      let assert Some(value) =
        option.or(
          codegen_helpers.constant(element),
          option.map(element.constraint, fn(constraint) { constraint.value }),
        )
      constraint_decoder_source(
        context,
        element,
        codegen_constraint.Constraint(
          fixed: True,
          type_name: case element.type_ {
            [type_] -> type_.code
            _ -> {
              let assert Some(constraint) = element.constraint
              constraint.type_name
            }
          },
          value:,
        ),
      ).0
    }
    _, Ok(FixedSliceType(discriminator_type, _, system, code, display)) -> {
      let assert Ok(#(_, function, fixed, _)) =
        codegen_slice_complex_type.helper_fields(discriminator_type)
      let arguments =
        list.map(fixed, fn(name) {
          let literal = case name {
            "system" -> system
            "code" -> code
            "display" -> {
              let assert Some(value) = display
              value
            }
            _ -> panic as { "unknown fixed field " <> name }
          }
          json.to_string(json.string(literal))
        })
        |> string.join(", ")
      complex_prefix <> function <> "_decoder(" <> arguments <> ")"
    }
    _, _ ->
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
  let decoder = case dict.get(context.slice_discriminator_checks, element.id) {
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
        codegen_slice_complex_type.constraint_fields(
          discriminator_type,
          "Required",
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
              constructor_placeholder(
                context.constructors,
                context.base_elements,
                context.current_bucket,
                _,
                set.new(),
                codegen_helpers.ComplexTypes,
              ),
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
  let decoder = case
    element.type_,
    dict.has_key(context.slice_type_overrides, element.id)
  {
    [type_], False ->
      case resolve_datatype_profiles(type_, context.datatype_types) {
        [_, _, ..] -> codegen_helpers.to_snake_case(field_type) <> "_decoder()"
        _ -> decoder
      }
    _, _ -> decoder
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
          codegen_helpers.Element(
            ..element,
            gleam_type: None,
            gleam_arguments: None,
            constraint: None,
            fixed_code: None,
            fixed_uri: None,
          ),
          context.current_bucket,
        )
      let extension_decoder =
        codegen_helpers.to_snake_case(field_type)
        <> "_extension_slice_decoder()"
      let conversion =
        codegen_helpers.to_snake_case(field_type) <> "_parse_primitive"
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
          <> ", decode.success) |> decode.then(fn(primitive) { case primitive.value, primitive.id, primitive.extension {"
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
  let #(_, _, _, _, choice_type, _) =
    profile_element_names(context, parent_type, element)
  let decoders =
    list.map(element.type_, fn(choice) {
      let constructor = choice_type <> string.capitalise(choice.code)
      "{ use value <- "
      <> field_decoder_expression(
        context,
        parent_type,
        codegen_helpers.Element(..element, type_: [choice], min: 1),
        True,
      )
      <> "\n decode.success("
      <> constructor
      <> "(value)) }"
    })
  let assert [first, ..rest] = decoders
  "pub fn "
  <> codegen_helpers.to_snake_case(choice_type)
  <> "_decoder() -> Decoder("
  <> choice_type
  <> ") {\n  decode.one_of(\n    "
  <> first
  <> ",\n    ["
  <> string.join(rest, ",\n      ")
  <> "],\n  )\n}\n\n"
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
          constructor_placeholder(
            context.constructors,
            context.base_elements,
            context.current_bucket,
            _,
            set.new(),
            codegen_helpers.ComplexTypes,
          ),
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
      <> "bound_codeableconcept_new(valueset."
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
      <> "bound_coding_new(valueset."
      <> valueset
      <> "_failure_variant)"
    }
    Error(_) | Ok(FixedValueDiscriminator(_)) ->
      constructor_placeholder(
        context.constructors,
        context.base_elements,
        context.current_bucket,
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
  let named_slice_elt_type = fn(root, type_) {
    case
      indexed_values,
      profile_extension_definition(root, context.extensions) != None
    {
      True, True -> complex_prefix <> "ExtensionSliceElement(" <> type_ <> ")"
      True, False -> complex_prefix <> "SliceElement(" <> type_ <> ")"
      False, _ -> type_
    }
  }
  let open_slice_elt_type = fn(type_) {
    case indexed_values {
      True -> complex_prefix <> "SliceElement(" <> type_ <> ")"
      False -> type_
    }
  }
  let natural_group_type = slice_group_type_name(parent_type, group)
  let #(_, _, _, _, base_type, _) =
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
          let #(_, _, _, field_name, field_type, _) =
            profile_element_names(context, parent_type, root)
          "    "
          <> field_name
          <> ": "
          <> case extension_group, root.max {
            True, "1" ->
              "Option(" <> named_slice_elt_type(root, field_type) <> ")"
            _, _ -> "List(" <> named_slice_elt_type(root, field_type) <> ")"
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
          let #(_, _, _, _, field_type, _) =
            profile_element_names(context, parent_type, root)
          "  "
          <> parsed_type
          <> slice_name_type_part(root)
          <> "("
          <> case
            context.preserve_slice_order,
            profile_extension_definition(root, context.extensions) != None
          {
            True, True ->
              complex_prefix <> "ExtensionSliceElement(" <> field_type <> ")"
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
          let #(_, _, _, field_name, field_type, _) =
            profile_element_names(context, parent_type, root)
          "    "
          <> field_name
          <> ": "
          <> codegen_helpers.cardinality(
            named_slice_elt_type(root, field_type),
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
      let roots =
        direct_slice_roots(child, context.snapshot_elements)
        |> list.filter(fn(root) { root.min > 0 })
      let check = discriminator_path_source(context, child, rest, "value")
      use <- bool.guard(
        check == "True" && roots == [] && child.constraint == None,
        "True",
      )
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
        _, _, _ if roots != [] -> {
          let checks =
            list.map(roots, fn(root) {
              let check =
                discriminator_path_source(context, root, rest, "value")
              "list.any(values, fn(value) { " <> check <> " })"
            })
          "case decode.run(value, decode.list(decode.dynamic)) { Ok(values) -> { "
          <> string.join(checks, " && ")
          <> " } Error(_) -> False }"
        }
        _, _, _ ->
          "case decode.run(value, decode.list(decode.dynamic)) { Ok([]) -> False Ok(values) -> list.all(values, fn(value) { "
          <> check
          <> " }) Error(_) -> False }"
      }
      use <- bool.guard(check == "True", "True")
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
                        slice_discriminator_checks: dict.new(),
                      ),
                      "",
                      element,
                      False,
                    )
                  "case decode.run("
                  <> input
                  <> ", "
                  <> decoder
                  <> ") { Ok(_) -> True Error(_) -> False }"
                }
                _ -> "True"
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
  profile_result: Option(String),
) -> String {
  let context =
    DecodeContext(..context, snapshot_elements: context.discriminator_elements)
  let assert Some(slicing) = group.slicing
  let prefix = codegen_helpers.bucket_prefix("Quantity", context.current_bucket)
  case slicing.discriminator {
    [codegen_helpers.Discriminator(type_: "exists", path:)] -> {
      let assert Ok(child) =
        find_element(context.snapshot_elements, root.id <> "." <> path)
      let assert True = child.min > 0 || child.max == "0"
      let #(absent, present) = case child.max {
        "0" -> #("DiscriminatorMatches", "DiscriminatorDifferent")
        _ -> #("DiscriminatorDifferent", "DiscriminatorMatches")
      }
      "case decode.run("
      <> input
      <> ", decode.optional_field("
      <> json.to_string(json.string(path))
      <> ", "
      <> prefix
      <> absent
      <> ", decode.success("
      <> prefix
      <> present
      <> "), decode.success)) { Ok(matched) -> matched Error(_) -> "
      <> prefix
      <> "DiscriminatorDifferent }"
    }
    _ -> {
      let checks =
        case dict.get(context.slice_type_overrides, root.id) {
          Ok(BoundCodingSlice) | Ok(BoundCodeableconceptSlice) -> [
            "case decode.run(value, "
            <> field_decoder_expression(context, "", root, False)
            <> ") { Ok(_) -> True Error(_) -> False }",
          ]
          _ ->
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
                  let assert [codegen_helpers.Type(profile: [url], ..)] =
                    root.type_
                  let assert Ok(type_) =
                    dict.get(context.datatype_types, canonical_url(url))
                  "case "
                  <> option.unwrap(
                    profile_result,
                    "decode.run(value, "
                      <> prefix
                      <> codegen_helpers.to_snake_case(type_)
                      <> "_decoder())",
                  )
                  <> " { Ok(_) -> True Error(_) -> False }"
                }
                _, _ ->
                  panic as {
                    "unsupported discriminator " <> discriminator.type_
                  }
              }
            })
        }
        |> list.filter(fn(check) { check != "True" })
      let assert [_, ..] = checks
        as { "no constraints for discriminator " <> root.id }
      let checks = string.join(checks, " && ")
      "case decode.run("
      <> input
      <> ", decode.then(decode.dynamic, fn("
      <> case profile_result {
        Some(_) -> "_value"
        None -> "value"
      }
      <> ") { use <- bool.guard(!{ "
      <> checks
      <> " }, decode.success("
      <> prefix
      <> "DiscriminatorDifferent)) decode.success("
      <> prefix
      <> "DiscriminatorMatches) })) { Ok(matched) -> matched Error(_) -> "
      <> prefix
      <> "DiscriminatorDifferent }"
    }
  }
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
pub fn constructor_placeholder(
  constructors: dict.Dict(String, ConstructorDefinition),
  base_elements: dict.Dict(String, codegen_helpers.Element),
  current_bucket: codegen_helpers.Category,
  target_type: String,
  visiting: Set(String),
  definition_bucket: codegen_helpers.Category,
) -> String {
  let name = case string.starts_with(target_type, "ct.") {
    True -> string.drop_start(target_type, 3)
    False -> target_type
  }
  let complex_prefix = codegen_helpers.bucket_prefix("Quantity", current_bucket)
  let key = constructor_key(definition_bucket, target_type)
  case dict.get(constructors, key) {
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
              <> constructor_placeholder(
                constructors,
                base_elements,
                current_bucket,
                argument.1,
                visiting,
                bucket,
              )
            })
            |> string.join(", ")
          prefix
          <> codegen_helpers.to_snake_case(name)
          <> "_new("
          <> arguments
          <> ")"
        }
        ChoiceConstructor(bucket, variant, payload_type, _) -> {
          let prefix = case bucket {
            codegen_helpers.ComplexTypes -> complex_prefix
            codegen_helpers.Resources -> ""
          }
          prefix
          <> variant
          <> "("
          <> constructor_placeholder(
            constructors,
            base_elements,
            current_bucket,
            payload_type,
            visiting,
            bucket,
          )
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
              constructors,
              base_elements,
              current_bucket,
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
            "ExtensionSliceElement" ->
              complex_prefix
              <> "ExtensionSliceElement(value: "
              <> value()
              <> ", id: None, internal_gleam_fhir_index: None)"
            "SliceElement" ->
              complex_prefix <> "SliceElement(" <> value() <> ", None)"
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
              current_bucket,
              "ct." <> name,
              base_elements,
              constructor_placeholder(
                constructors,
                base_elements,
                current_bucket,
                _,
                visiting,
                codegen_helpers.ComplexTypes,
              ),
            )
          {
            Ok(default) -> default
            Error(_) -> {
              let parts = string.split(target_type, ".")
              case target_type, parts {
                _, _ if name == "ExplicitFalse" || name == "ExplicitTrue" ->
                  complex_prefix <> name
                "Nil", _ -> "Nil"
                "String", _ -> "\"\""
                "Bool", _ -> "False"
                "Int", _ -> "0"
                "Float", _ -> "0.0"
                "Date", _ -> "pt.Year(1)"
                "DateTime", _ -> "pt.DateNoTime(pt.Year(1))"
                "Time", _ -> "pt.Time(0, 0, 0, None)"
                "Instant", _ -> "pt.instant_failure_variant"
                _, ["valueset", type_] ->
                  "valueset." <> string.lowercase(type_) <> "_failure_variant"
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
  constructor_placeholder(
    context.constructors,
    context.base_elements,
    context.current_bucket,
    base_type,
    set.new(),
    context.current_bucket,
  )
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
  let #(_, _, json_name, field_name, base_type, _) =
    profile_element_names(context, parent_type, group)
  let assert Some(slicing) = group.slicing
  let accumulator_field_names =
    list.map(roots, fn(root) {
      let #(_, _, _, field_name, _, _) =
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
    True -> complex_prefix <> "SliceElement(value, Some(index))"
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
      let #(_, _, _, root_field, _, _) =
        profile_element_names(context, parent_type, root)
      let variant = parsed_type <> slice_name_type_part(root)
      let extension = profile_extension_definition(root, context.extensions)
      let #(url, decoder) = case extension {
        None -> {
          let assert Some(codegen_constraint.Constraint(
            fixed: True,
            value: codegen_constraint.Object(fields) as value,
            ..,
          )) = root.constraint
          let assert Some(codegen_constraint.Text(url)) =
            codegen_constraint.field(value, "url")
          let bindings =
            fields
            |> list.filter(fn(field) { field.0 != "url" })
            |> list.map(fn(field) {
              let assert False = case field.1 {
                codegen_constraint.Object(_) | codegen_constraint.Array(_) ->
                  True
                _ -> False
              }
                as { "unsupported nested fixed Extension: " <> root.id }
              "use _ <- decode.field("
              <> json.to_string(json.string(field.0))
              <> ", "
              <> codegen_constraint.sources(field.1, True, "value").1
              <> ")\n"
            })
            |> string.concat
          #(url, "{ " <> bindings <> "decode.success(Ok(Nil)) }")
        }
        Some(extension) -> {
          let decoder = case extension.kind {
            SimpleExtension(value) -> {
              let #(_, decoder) =
                extension_value_branch(
                  context.current_bucket,
                  extension.name,
                  value,
                  context.valueset_acc,
                  // context.available_valuesets,
                  extension.primitive_values,
                  context.datatype_types,
                )
              decoder <> " |> decode.map(Ok)"
            }
            ComplexExtension(..) ->
              "parse_" <> codegen_helpers.to_snake_case(extension.name) <> "()"
          }
          #(extension.url, decoder)
        }
      }
      let named_value = case context.preserve_slice_order && extension != None {
        True ->
          complex_prefix
          <> "ExtensionSliceElement(value:, id:, internal_gleam_fhir_index: None)"
        False -> "value"
      }
      let decode_branch =
        "      \""
        <> canonical_url(url)
        <> "\" -> "
        <> decoder
        <> " |> decode.map(fn(parsed) { result.map(parsed, fn(value) { "
        <> variant
        <> "("
        <> named_value
        <> ") }) })\n"
      let stored_value = case context.preserve_slice_order, extension {
        True, None -> complex_prefix <> "SliceElement(value, Some(index))"
        True, _ ->
          complex_prefix
          <> "ExtensionSliceElement(..value, internal_gleam_fhir_index: Some(index))"
        False, _ -> "value"
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
      True ->
        case
          list.any(roots, fn(root) {
            profile_extension_definition(root, context.extensions) != None
          })
        {
          True -> "id"
          False -> "_id"
        }
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
    True -> "  let " <> base_values <> " = primitive.extension\n"
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
          True -> complex_prefix <> "SliceElement(" <> value <> ", None)"
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
      let #(_, _, _, root_field, _, _) =
        profile_element_names(context, parent_type, root)
      root_field
    })
  let constructor_fields =
    result_values
    |> list.map(fn(value) {
      let assert Ok(root) =
        list.find(roots, fn(root) {
          let #(_, _, _, root_field, _, _) =
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
          let #(_, _, _, root_field, _, _) =
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
        |> list.map(fn(name) { "result.unwrap_error(" <> name <> ", [])" })
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
      let #(_, _, _, root_field, field_type, _) =
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
          case
            context.preserve_slice_order,
            profile_extension_definition(root, context.extensions)
          {
            True, None ->
              complex_prefix <> "SliceElement(" <> value <> ", None)"
            True, _ ->
              complex_prefix
              <> "ExtensionSliceElement(value: "
              <> value
              <> ", id: None, internal_gleam_fhir_index: None)"
            False, _ -> value
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
    support_source:,
    result_name:,
    fallible: True,
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
  let #(_, field_path, json_name, field_name, base_type, _) =
    profile_element_names(context, parent_type, group)
  let use_profile_slice_base =
    list.contains(context.type_order, field_path)
    || dict.has_key(context.profile_unions, field_path)
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
  let extension_group =
    list.any(group.type_, fn(type_) { type_.code == "Extension" })
  let stored_named_value = fn(value) {
    case indexed_values, extension_group {
      True, True -> value
      True, False ->
        complex_prefix <> "SliceElement(" <> value <> ", Some(index))"
      False, _ -> value
    }
  }
  let stored_open_value = fn(value) {
    case indexed_values {
      True -> complex_prefix <> "SliceElement(" <> value <> ", Some(index))"
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
  let base_fields =
    fields_for_profile_type(context, base_type, "")
    |> result.lazy_or(fn() {
      case
        dict.get(
          context.constructors,
          constructor_key(context.current_bucket, base_type),
        )
      {
        Ok(RecordConstructor(_, _, fields)) ->
          Ok(list.map(fields, fn(field) { field.0 }))
        _ -> Error(Nil)
      }
    })
    |> result.unwrap([])
  let nested = nested_slice_field(context, parent_type, group, roots)
  let dispatch_fields =
    list.filter(base_fields, fn(field) {
      list.any(slicing.discriminator, fn(discriminator) {
        discriminator.path == profile_json_field_name(field, "")
      })
    })
  let selected_fields = case nested {
    Some(plan) -> [plan.field]
    None -> dispatch_fields
  }
  let direct =
    dispatch_fields != []
    && list.all(slicing.discriminator, fn(discriminator) {
      discriminator.type_ == "value"
      && !string.contains(discriminator.path, ".")
      && discriminator.path != "$this"
      && list.any(dispatch_fields, fn(field) {
        profile_json_field_name(field, "") == discriminator.path
        && {
          let #(_, _, _, _, type_, _) =
            profile_element_names(context, base_type, field)
          type_ == "String"
        }
      })
    })
    && list.all(roots, fn(root) {
      list.all(slicing.discriminator, fn(discriminator) {
        case
          find_element(
            context.discriminator_elements,
            root.id <> "." <> discriminator.path,
          )
        {
          Ok(field) ->
            case codegen_helpers.constant(field) {
              Some(codegen_constraint.Text(_)) -> field.min > 0
              _ -> False
            }
          Error(_) -> False
        }
      })
    })
  let accumulator_field_names =
    list.map(roots, fn(root) {
      let #(_, _, _, field_name, _, _) =
        profile_element_names(context, parent_type, root)
      field_name
    })
  let accumulator_field_names = case slicing.rules {
    "open" | "openAtEnd" -> ["open", ..accumulator_field_names]
    _ -> accumulator_field_names
  }
  let #(nested_decoder, nested_support) = case nested {
    None -> #("", "")
    Some(plan) -> {
      let discriminator_type = group_type <> "Discriminator"
      let #(_, _, nested_name, _, _, _) =
        profile_element_names(context, base_type, plan.field)
      let #(_, _, _, member_field, _, _) =
        profile_element_names(context, plan.base_type, plan.member)
      let member_name = profile_json_field_name(plan.member, "")
      let variables =
        list.index_map(plan.cases, fn(_, index) {
          let suffix = int.to_string(index)
          ["matching_" <> suffix, "other_" <> suffix]
        })
        |> list.flatten
      let accumulated =
        list.index_map(plan.cases, fn(_, index) {
          "values_" <> int.to_string(index)
        })
        |> list.append(["open_values"])
      let groups =
        list.index_map(plan.cases, fn(candidate, index) {
          let suffix = int.to_string(index)
          let names =
            list.map(candidate.selector, fn(field) {
              "value." <> codegen_helpers.to_snake_case(field.0)
            })
          let patterns =
            list.map(candidate.selector, fn(field) {
              let assert codegen_constraint.Text(value) = field.1
              "Some(" <> json.to_string(json.string(value)) <> ")"
            })
          "let #(matching_"
          <> suffix
          <> ", other_"
          <> suffix
          <> ") = case "
          <> string.join(names, ", ")
          <> " { "
          <> string.join(patterns, ", ")
          <> " -> #([#(value, index), ..matching_"
          <> suffix
          <> "], other_"
          <> suffix
          <> ") "
          <> string.join(list.map(names, fn(_) { "_" }), ", ")
          <> " -> #(matching_"
          <> suffix
          <> ", [#(value, index), ..other_"
          <> suffix
          <> "]) }\n"
        })
        |> string.concat
      let fold =
        "let members = nested_value."
        <> member_field
        <> "\nlet #("
        <> string.join(variables, ", ")
        <> ") = list.index_fold(members, #("
        <> string.join(list.map(variables, fn(_) { "[]" }), ", ")
        <> "), fn(acc, value, index) {\nlet #("
        <> string.join(variables, ", ")
        <> ") = acc\n"
        <> groups
        <> "#("
        <> string.join(variables, ", ")
        <> ")\n})\n"
        <> string.concat(
          list.map(variables, fn(name) {
            "let " <> name <> " = list.reverse(" <> name <> ")\n"
          }),
        )
      let fallback =
        "Ok(#("
        <> string.join(
          list.map(accumulated, fn(name) {
            case name {
              "open_values" -> "[nested_value, ..open_values]"
              _ -> name
            }
          }),
          ", ",
        )
        <> "))"
      let body =
        plan.cases
        |> list.index_map(fn(candidate, index) { #(candidate, index) })
        |> list.map(fn(item) {
          let #(candidate, index) = item
          let suffix = int.to_string(index)
          let #(_, _, _, pattern_name, _, _) =
            profile_element_names(
              context,
              candidate.type_name,
              candidate.pattern,
            )
          let assert Ok(pattern_type) =
            list.find(candidate.fields, fn(field) {
              field.0.id == candidate.pattern.id
            })
          let indexed_pattern = string.contains(pattern_type.1, "SliceElement(")
          let selector_names =
            list.map(candidate.selector, fn(field) { field.0 })
          let checks =
            list.filter(plan.member_fields, fn(field) {
              let name = codegen_helpers.field_name(field)
              { list.contains(candidate.required, name) && field.min == 0 }
              || {
                list.contains(candidate.fixed, name)
                && !list.contains(selector_names, name)
              }
            })
          let arguments =
            plan.member_fields
            |> list.filter(fn(field) {
              let name = codegen_helpers.field_name(field)
              !list.contains(candidate.fixed, name)
              && !list.contains(candidate.omitted, name)
            })
            |> list.map(fn(field) {
              let name = codegen_helpers.field_name(field)
              name
              <> ": "
              <> case
                list.contains(candidate.required, name) && field.min == 0
              {
                True -> name
                False -> "value." <> name
              }
            })
            |> string.join(", ")
          let payload_type = case context.current_bucket {
            codegen_helpers.Resources ->
              case string.starts_with(candidate.member_type, "ct.") {
                True -> candidate.member_type
                False -> "ct." <> candidate.member_type
              }
            _ -> string.replace(candidate.member_type, "ct.", "")
          }
          let payload = payload_type <> "(" <> arguments <> ")"
          let payload = case indexed_pattern {
            True ->
              complex_prefix <> "SliceElement(" <> payload <> ", Some(index))"
            False -> payload
          }
          let conversion =
            list.fold(checks, "Ok(" <> payload <> ")", fn(body, field) {
              let name = codegen_helpers.field_name(field)
              let quoted =
                json.to_string(json.string(profile_json_field_name(field, "")))
              let error =
                "Error([decode.DecodeError(expected: \""
                <> name
                <> "\", found: \"missing or different value\", path: ["
                <> json.to_string(json.string(member_name))
                <> ", json.to_string(json.int(index)), "
                <> quoted
                <> "])])"
              case list.contains(candidate.fixed, name) {
                True -> {
                  let assert Ok(codegen_constraint.Text(value)) =
                    list.key_find(
                      candidate.constants,
                      profile_json_field_name(field, ""),
                    )
                  "case value."
                  <> name
                  <> " { Some("
                  <> json.to_string(json.string(value))
                  <> ") -> "
                  <> body
                  <> " _ -> "
                  <> error
                  <> " }"
                }
                False if field.max == "1" ->
                  "case value."
                  <> name
                  <> " { Some("
                  <> name
                  <> ") -> "
                  <> body
                  <> " None -> "
                  <> error
                  <> " }"
                False ->
                  "case value."
                  <> name
                  <> " { [first, ..rest] -> { let "
                  <> name
                  <> " = "
                  <> complex_prefix
                  <> "List1(first:, rest:)\n"
                  <> body
                  <> " } [] -> "
                  <> error
                  <> " }"
              }
            })
          let index_name = case indexed_pattern || checks != [] {
            True -> "index"
            False -> "_index"
          }
          let binding = "let #(value, " <> index_name <> ") = "
          let pattern = case checks {
            [] ->
              "let "
              <> pattern_name
              <> " = "
              <> complex_prefix
              <> "List1(first: { "
              <> binding
              <> "first\n"
              <> payload
              <> " }, rest: list.map(rest, fn(entry) { "
              <> binding
              <> "entry\n"
              <> payload
              <> " }))\n"
            _ ->
              "let convert = fn(entry) { "
              <> binding
              <> "entry\n"
              <> conversion
              <> " }\n"
              <> "let converted = result.try(convert(first), fn(first) { "
              <> "list.try_map(rest, convert) |> result.map(fn(rest) { "
              <> complex_prefix
              <> "List1(first:, rest:) }) })\n"
          }
          let assert Ok(open_member) =
            list.find(candidate.fields, fn(field) {
              field.0.path == plan.member.path
              && field.0.id != candidate.pattern.id
            })
          let indexed_member = string.contains(open_member.1, "SliceElement(")
          let other_payload = case indexed_member {
            True -> complex_prefix <> "SliceElement(entry.0, Some(entry.1))"
            False -> "entry.0"
          }
          let #(_, _, _, open_member_name, _, _) =
            profile_element_names(context, candidate.type_name, open_member.0)
          let open_values =
            "let "
            <> open_member_name
            <> " = list.map(other_"
            <> suffix
            <> ", fn(entry) { "
            <> other_payload
            <> " })\n"
          let #(arguments, bindings) =
            list.fold(candidate.fields, #([], ""), fn(acc, entry) {
              let #(arguments, bindings) = acc
              let #(field, stored_type) = entry
              let #(_, _, _, name, _, _) =
                profile_element_names(context, candidate.type_name, field)
              use <- bool.guard(field.id == candidate.pattern.id, #(
                [name <> ": " <> pattern_name, ..arguments],
                bindings,
              ))
              let assert Ok(base_field) =
                list.find(plan.base_fields, fn(base) {
                  base.0.path == field.path
                })
                as "no decoder includes all fields for all slices of element because a slice has primitive extension"
              let assert [target, source] =
                list.map([stored_type, base_field.1], fn(type_) {
                  list.fold(
                    [
                      "Option(",
                      "List(",
                      "List1(",
                      "List2(",
                      "List3(",
                      "SliceElement(",
                    ],
                    string.replace(type_, "ct.", ""),
                    fn(type_, prefix) {
                      case string.starts_with(type_, prefix) {
                        True ->
                          string.drop_end(
                            string.drop_start(type_, string.length(prefix)),
                            1,
                          )
                        False -> type_
                      }
                    },
                  )
                })
              let assert True = target == source
                as "no decoder includes all fields for all slices of element because a slice has primitive extension"
              use <- bool.guard(field.path == plan.member.path, #(
                [name <> ": " <> open_member_name, ..arguments],
                bindings,
              ))
              let #(_, _, _, base_name, _, _) =
                profile_element_names(context, plan.base_type, base_field.0)
              let value = "nested_value." <> base_name
              case
                field.min == base_field.0.min && field.max == base_field.0.max
              {
                True -> #([name <> ": " <> value, ..arguments], bindings)
                False -> {
                  let values = case base_field.0.max, base_field.0.min {
                    "1", 0 ->
                      "case "
                      <> value
                      <> " { Some(value) -> [value] None -> [] }"
                    "1", _ -> "[" <> value <> "]"
                    _, 0 -> value
                    _, 1 -> "[" <> value <> ".first, .." <> value <> ".rest]"
                    _, 2 ->
                      "["
                      <> value
                      <> ".first, "
                      <> value
                      <> ".second, .."
                      <> value
                      <> ".rest]"
                    _, 3 ->
                      "["
                      <> value
                      <> ".first, "
                      <> value
                      <> ".second, "
                      <> value
                      <> ".third, .."
                      <> value
                      <> ".rest]"
                    _, _ -> panic as "unsupported nested field cardinality"
                  }
                  #(
                    [name <> ": " <> name, ..arguments],
                    bindings
                      <> "use "
                      <> name
                      <> " <- result.try("
                      <> slice_cardinality_expression(
                      context.current_bucket,
                      field,
                      values,
                      profile_json_field_name(field, ""),
                      True,
                    )
                      <> ")\n",
                  )
                }
              }
            })
          let constructed =
            candidate.type_name
            <> "("
            <> string.join(list.reverse(arguments), ", ")
            <> ")"
          let result =
            bindings
            <> "Ok(#("
            <> string.join(
              list.map(accumulated, fn(name) {
                case name == "values_" <> suffix {
                  True -> "[" <> constructed <> ", .." <> name <> "]"
                  False -> name
                }
              }),
              ", ",
            )
            <> "))"
          let selected = case checks {
            [] -> pattern <> open_values <> result
            _ ->
              pattern
              <> "use "
              <> pattern_name
              <> " <- result.try(converted)\n"
              <> open_values
              <> result
          }
          string.join(
            list.index_map(plan.cases, fn(_, i) {
              case i == index {
                True -> "[first, ..rest]"
                False -> "_"
              }
            }),
            ", ",
          )
          <> " -> { "
          <> selected
          <> " }\n"
        })
        |> string.concat
      let body =
        "case "
        <> string.join(
          list.index_map(plan.cases, fn(_, index) {
            "matching_" <> int.to_string(index)
          }),
          ", ",
        )
        <> " { "
        <> body
        <> string.join(list.map(plan.cases, fn(_) { "_" }), ", ")
        <> " -> "
        <> fallback
        <> " }"
      let field_decoder =
        field_decoder_expression(context, base_type, plan.field, True)
      let input = case plan.field.max, plan.field.min {
        "1", 0 -> "case nested_values { Some(value) -> [value] None -> [] }"
        "1", _ -> "[nested_values]"
        _, 0 -> "nested_values"
        _, 1 -> "[nested_values.first, ..nested_values.rest]"
        _, 2 ->
          "[nested_values.first, nested_values.second, ..nested_values.rest]"
        _, 3 ->
          "[nested_values.first, nested_values.second, nested_values.third, ..nested_values.rest]"
        _, _ -> panic as "unsupported nested field cardinality"
      }
      let error_path = case plan.field.base.max {
        "1" -> "[" <> json.to_string(json.string(nested_name)) <> "]"
        _ ->
          "["
          <> json.to_string(json.string(nested_name))
          <> ", json.to_string(json.int(nested_index))]"
      }
      let selected =
        plan.cases
        |> list.index_map(fn(candidate, index) {
          let variant =
            discriminator_type <> slice_name_type_part(candidate.root)
          let payload = case candidate.field.min, candidate.field.max {
            0, "1" -> "Some(first)"
            1, "1" -> "first"
            0, _ -> "[first, ..rest]"
            1, _ -> complex_prefix <> "List1(first:, rest:)"
            _, _ -> ""
          }
          let rest = case candidate.field.max {
            "1" -> ""
            _ -> "rest"
          }
          let patterns =
            list.index_map(plan.cases, fn(_, i) {
              case i == index {
                True -> "[first, .." <> rest <> "]"
                False -> "_"
              }
            })
          string.join(patterns, ", ")
          <> " -> "
          <> case payload {
            "" ->
              "result.map("
              <> slice_cardinality_expression(
                context.current_bucket,
                candidate.field,
                "[first, ..rest]",
                nested_name,
                True,
              )
              <> ", "
              <> variant
              <> ")"
            _ -> "Ok(" <> variant <> "(" <> payload <> "))"
          }
          <> "\n"
        })
        |> string.concat
      let selected =
        "case "
        <> string.join(
          list.index_map(plan.cases, fn(_, index) {
            "list.reverse(values_" <> int.to_string(index) <> ")"
          }),
          ", ",
        )
        <> " { "
        <> selected
        <> string.join(list.map(plan.cases, fn(_) { "_" }), ", ")
        <> " -> result.map("
        <> slice_cardinality_expression(
          context.current_bucket,
          plan.field,
          "list.reverse(open_values)",
          nested_name,
          True,
        )
        <> ", "
        <> discriminator_type
        <> "Open) }"
      let assert [first, ..] = plan.cases
      let placeholder =
        discriminator_type
        <> slice_name_type_part(first.root)
        <> "("
        <> slice_cardinality_placeholder(
          context.current_bucket,
          first.field,
          fn() { slice_placeholder(context, first.field, first.type_name) },
        )
        <> ")"
      let decoder =
        "{ use nested_values <- "
        <> field_decoder
        <> "\nlet converted = list.index_fold("
        <> input
        <> ", Ok(#("
        <> string.join(list.map(accumulated, fn(_) { "[]" }), ", ")
        <> ")), fn(acc, nested_value, "
        <> case plan.field.base.max {
          "1" -> "_nested_index"
          _ -> "nested_index"
        }
        <> ") {\nuse #("
        <> string.join(accumulated, ", ")
        <> ") <- result.try(acc)\n"
        <> fold
        <> "{ "
        <> body
        <> " } |> result.map_error(fn(errors) { list.map(errors, fn(error) { "
        <> "decode.DecodeError(..error, path: list.append("
        <> error_path
        <> ", error.path)) }) })\n})\n"
        <> "let selected = result.try(converted, fn(values) { let #("
        <> string.join(accumulated, ", ")
        <> ") = values\n"
        <> selected
        <> " })\ncase selected { Ok(value) -> decode.success(value)"
        <> " Error(errors) -> decode.failure("
        <> placeholder
        <> ", \"constrained field\") |> decode.map_errors(fn(_) { errors }) } }"
      let declarations =
        list.map(plan.cases, fn(candidate) {
          "  "
          <> discriminator_type
          <> slice_name_type_part(candidate.root)
          <> "("
          <> codegen_helpers.cardinality(
            candidate.type_name,
            candidate.field.min,
            candidate.field.max,
          )
          <> ")\n"
        })
        |> string.concat
      let support =
        "type "
        <> discriminator_type
        <> " {\n"
        <> declarations
        <> "  "
        <> discriminator_type
        <> "Open("
        <> codegen_helpers.cardinality(
          plan.base_type,
          plan.field.min,
          plan.field.max,
        )
        <> ")\n}\n\n"
      #(decoder, support)
    }
  }

  let unmatched = case slicing.rules {
    "open" | "openAtEnd" -> {
      let constructor = case is_aggregate {
        True -> aggregate_slice_constructor(group_type, "Open", base_type)
        False -> parsed_type <> "Open"
      }
      let has_slice_decoder = dict.has_key(context.slice_inputs, base_type)
      let decoder = case direct || nested != None {
        False -> base_decoder
        True if use_profile_slice_base && has_slice_decoder ->
          codegen_helpers.to_snake_case(base_type)
          <> "_slice_decoder("
          <> string.join(
            list.map(selected_fields, fn(field) {
              let #(_, _, _, name, _, _) =
                profile_element_names(context, base_type, field)
              name <> ": " <> name
            }),
            ", ",
          )
          <> ")"
        True ->
          record_decoder_from_fields(
            DecodeContext(
              ..context,
              slice_inputs: dict.insert(
                context.slice_inputs,
                base_type,
                selected_fields,
              ),
            ),
            base_type,
            base_fields,
            None,
            False,
            False,
            None,
            True,
          )
      }
      case direct, nested {
        True, _ ->
          string.join(list.map(dispatch_fields, fn(_) { "_" }), ", ") <> " -> "
        _, Some(plan) -> {
          let #(_, _, _, name, _, _) =
            profile_element_names(context, base_type, plan.field)
          group_type <> "DiscriminatorOpen(" <> name <> ") -> "
        }
        _, None -> ""
      }
      <> decoder
      <> " |> decode.map("
      <> constructor
      <> ")"
    }
    "closed" -> {
      let assert [root, ..] = roots
      let #(_, _, _, _, type_, _) =
        profile_element_names(context, parent_type, root)
      case direct, nested {
        True, _ ->
          string.join(list.map(dispatch_fields, fn(_) { "_" }), ", ") <> " -> "
        _, Some(_) -> group_type <> "DiscriminatorOpen(_) -> "
        _, None -> ""
      }
      <> "decode.failure("
      <> parsed_slice_constructor(parent_type, group, root)
      <> "("
      <> slice_placeholder(context, root, type_)
      <> "), \"one permitted slice\")"
    }
    rules -> panic as { "unknown slicing rule " <> rules }
  }
  // Keep the input so selected slice decoders can preserve every profiled field.
  let classifier =
    roots
    |> list.reverse
    |> list.fold(unmatched, fn(unmatched, root) {
      let #(_, _, _, _, root_type, _) =
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
      let decoder = case
        dict.get(context.slice_type_overrides, root.id),
        dict.get(context.slice_inputs, root_type)
      {
        Ok(FixedSliceType(name, _, system, code, display)), _ -> {
          let assert Ok(#(_, function, fixed, _)) =
            codegen_slice_complex_type.helper_fields(name)
          let remaining =
            list.filter(fixed, fn(name) {
              !list.any(slicing.discriminator, fn(discriminator) {
                discriminator.path == name || discriminator.path == "$this"
              })
            })
          let checks =
            remaining
            |> list.map(fn(name) {
              let value = case name {
                "system" -> system
                "code" -> code
                "display" -> {
                  let assert Some(value) = display
                  value
                }
                _ -> panic as { "unknown fixed field " <> name }
              }
              "use _ <- decode.field("
              <> json.to_string(json.string(name))
              <> ", "
              <> codegen_constraint.sources(
                codegen_constraint.Text(value),
                True,
                "value",
              ).1
              <> ")\n"
            })
            |> string.concat
          "{ "
          <> checks
          <> complex_prefix
          <> function
          <> case fixed {
            [] -> "_decoder()"
            _ -> "_slice_decoder()"
          }
          <> " }"
        }
        _, Error(_) ->
          field_decoder_expression(context, parent_type, root, False)
        _, Ok(inputs) -> {
          let inputs =
            list.filter(inputs, fn(field) {
              codegen_helpers.constant(field) == None
              || field.min == 0
              || field.max != "1"
            })
          let bindings =
            inputs
            |> list.map(fn(field) {
              let #(_, _, _, name, _, _) =
                profile_element_names(context, root_type, field)
              "use "
              <> name
              <> " <- "
              <> field_decoder_expression(context, root_type, field, True)
              <> "\n"
            })
            |> string.concat
          let arguments =
            inputs
            |> list.map(fn(field) {
              let #(_, _, _, name, _, _) =
                profile_element_names(context, root_type, field)
              name <> ": " <> name
            })
            |> string.join(", ")
          "{ "
          <> case direct || nested != None {
            True -> ""
            False -> bindings
          }
          <> codegen_helpers.to_snake_case(root_type)
          <> "_slice_decoder("
          <> arguments
          <> ") }"
        }
      }
      let prefix =
        codegen_helpers.bucket_prefix("Quantity", context.current_bucket)
      let profile_result = case slicing.discriminator, root.type_ {
        [codegen_helpers.Discriminator(type_: "profile", path: "$this")],
          [codegen_helpers.Type(profile: [url], ..)]
        -> {
          case dict.get(context.datatype_types, canonical_url(url)) {
            Ok(name) if root_type == prefix <> name -> Some("profile_result")
            _ -> None
          }
        }
        _, _ -> None
      }
      let ordinary = case direct {
        True -> {
          let patterns =
            dispatch_fields
            |> list.map(fn(input) {
              let name = profile_json_field_name(input, "")
              use <- bool.guard(
                !list.any(slicing.discriminator, fn(discriminator) {
                  discriminator.path == name
                }),
                "_",
              )
              let assert Ok(field) =
                find_element(
                  context.discriminator_elements,
                  root.id <> "." <> name,
                )
              let assert Some(codegen_constraint.Text(value)) =
                codegen_helpers.constant(field)
              case input.min {
                0 -> "Some(" <> json.to_string(json.string(value)) <> ")"
                _ -> json.to_string(json.string(value))
              }
            })
            |> string.join(", ")
          patterns
          <> " -> "
          <> decoder
          <> " |> decode.map("
          <> constructor
          <> ")\n"
          <> unmatched
        }
        False if nested != None -> {
          let assert Some(plan) = nested
          let #(_, _, _, name, _, _) =
            profile_element_names(context, base_type, plan.field)
          group_type
          <> "Discriminator"
          <> slice_name_type_part(root)
          <> "("
          <> name
          <> ") -> "
          <> decoder
          <> " |> decode.map("
          <> constructor
          <> ")\n"
          <> unmatched
        }
        False ->
          case profile_result {
            Some(_) ->
              "decode.one_of("
              <> decoder
              <> " |> decode.map("
              <> constructor
              <> "), ["
              <> unmatched
              <> "])"
            None ->
              "case "
              <> slice_discriminator_match_source(
                context,
                group,
                root,
                field_name <> "_raw",
                None,
              )
              <> " { "
              <> prefix
              <> "DiscriminatorMatches -> "
              <> decoder
              <> " |> decode.map("
              <> constructor
              <> ") "
              <> prefix
              <> "DiscriminatorDifferent -> "
              <> unmatched
              <> " }"
          }
      }
      case dict.get(context.slice_type_overrides, root.id) {
        Ok(BoundCodingSlice) as kind | Ok(BoundCodeableconceptSlice) as kind -> {
          let assert Some(valueset) =
            codegen_bound_coding.bound_valueset_function_name(root_type)
          let from_code = "valueset." <> valueset <> "_parse_code_and_system"
          let #(discriminator, matched, selected) = case kind {
            Ok(BoundCodingSlice) -> {
              let assert [name, ..] = string.split(root_type, "(")
              let name =
                name
                |> string.replace(complex_prefix, "")
                |> codegen_helpers.to_snake_case
              #(
                "{ use code <- decode.field(\"code\", decode.string) use system <- decode.field(\"system\", decode.string) decode.success("
                  <> from_code
                  <> "(code, system)) }",
                "Ok(code)",
                complex_prefix <> name <> "_slice_decoder(code)",
              )
            }
            _ -> #(
              complex_prefix
                <> "bound_codeableconcept_discriminator("
                <> from_code
                <> ")",
              "#(Some(#(required, coding_index)), codings)",
              complex_prefix
                <> "bound_codeableconcept_slice_decoder(required, coding_index, codings)",
            )
          }
          "{ use matched <- decode.then("
          <> discriminator
          <> ")\ncase matched { "
          <> matched
          <> " -> "
          <> selected
          <> " |> decode.map("
          <> constructor
          <> ") _ -> "
          <> unmatched
          <> " } }"
        }
        _ -> ordinary
      }
    })
  let classifier = case direct {
    False if nested != None ->
      "{ use selected <- decode.then("
      <> nested_decoder
      <> ")\ncase selected {\n"
      <> classifier
      <> "\n} }"
    False -> classifier
    True -> {
      let names =
        list.map(dispatch_fields, fn(field) {
          let #(_, _, _, name, _, _) =
            profile_element_names(context, base_type, field)
          name
        })
      "case " <> string.join(names, ", ") <> " {\n" <> classifier <> "\n}"
    }
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
      "          value ->\n            "
      <> accumulator_type
      <> "([value, ..accumulator.values])\n"
    False -> {
      let named =
        roots
        |> list.map(fn(root) {
          let #(_, _, _, root_field, _, _) =
            profile_element_names(context, parent_type, root)
          "          "
          <> parsed_slice_constructor(parent_type, group, root)
          <> "(value) ->\n            "
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
          <> "\n"
        })
        |> string.concat
      let open = case slicing.rules {
        "open" | "openAtEnd" ->
          "          "
          <> parsed_type
          <> "Open(value) ->\n            "
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
          <> "\n"
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
  let index_parameter = case !is_aggregate && indexed_values {
    True -> ", index"
    False -> ", _index"
  }
  let dispatch_bindings = case direct {
    True ->
      dispatch_fields
      |> list.map(fn(field) {
        let #(_, _, _, name, _, _) =
          profile_element_names(context, base_type, field)
        "use "
        <> name
        <> " <- "
        <> field_decoder_expression(context, base_type, field, True)
        <> "\n"
      })
      |> string.concat
    False ->
      case string.contains(classifier, field_name <> "_raw") {
        True -> "use " <> field_name <> "_raw <- decode.then(decode.dynamic)\n"
        False -> ""
      }
  }
  let fold_source =
    "  use "
    <> base_values
    <> " <- decode.optional_field(\""
    <> json_name
    <> "\", [], decode.list("
    <> "{ "
    <> dispatch_bindings
    <> classifier
    <> " }"
    <> "))\n  let "
    <> accumulator
    <> " =\n    "
    <> fold_function
    <> "(\n      "
    <> base_values
    <> ",\n      "
    <> accumulator_type
    <> "("
    <> initial_values
    <> "),\n      fn(accumulator, parsed"
    <> index_parameter
    <> ") {\n        case parsed {\n"
    <> accumulate_cases
    <> "        }\n      },\n    )\n"
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
        <> " {\n    "
        <> accumulator_type
        <> "(values:) -> "
        <> cardinality
        <> "\n  }\n"
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
        support_source: nested_support,
        result_name:,
        fallible: True,
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
          let #(_, _, _, root_field, _, _) =
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
            |> list.map(fn(value) { "result.unwrap_error(" <> value <> ", [])" })
            |> string.join(", ")
          }
          <> "]))\n      }\n"
      }
      let fallible =
        !list.all(cardinalities, fn(item) {
          item.0.min == 0 && item.0.max != "0" && item.0.max != "1"
        })
      let result_source = case
        list.all(cardinalities, fn(item) {
          item.0.min == 0 && item.0.max != "0" && item.0.max != "1"
        })
      {
        True ->
          "  let "
          <> result_name
          <> " = "
          <> group_type
          <> "Slices("
          <> {
            result_values
            |> list.map(fn(value) {
              value <> ": list.reverse(" <> accumulator <> "." <> value <> ")"
            })
            |> string.join(", ")
          }
          <> ")\n"
        False ->
          "  let "
          <> result_name
          <> " = {\n"
          <> "let accumulator = "
          <> accumulator
          <> "\n"
          <> result_bindings
          <> result_case
          <> "  }\n"
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
              let #(_, _, _, _, target_type, _) =
                profile_element_names(context, parent_type, root)
              let value = slice_placeholder(context, root, target_type)
              case indexed_values, extension_group {
                True, True ->
                  complex_prefix
                  <> "ExtensionSliceElement(value: "
                  <> value
                  <> ", id: None, internal_gleam_fhir_index: None)"
                True, False ->
                  complex_prefix <> "SliceElement(" <> value <> ", None)"
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
        support_source: nested_support,
        result_name:,
        fallible:,
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
  binding: Option(String),
  inline: Bool,
) -> String {
  let inputs = dict.get(context.slice_inputs, target_type) |> result.unwrap([])
  let retained_inputs =
    list.filter(inputs, fn(field) {
      codegen_helpers.constant(field) == None
      || field.min == 0
      || field.max != "1"
    })
  let input_bindings =
    retained_inputs
    |> list.map(fn(field) {
      let #(_, _, _, name, _, _) =
        profile_element_names(context, target_type, field)
      "  use "
      <> name
      <> " <- "
      <> field_decoder_expression(context, target_type, field, True)
      <> "\n"
    })
    |> string.concat
  let input_arguments =
    retained_inputs
    |> list.map(fn(field) {
      let #(_, _, _, name, type_, _) =
        profile_element_names(context, target_type, field)
      #(
        name,
        codegen_helpers.cardinality(type_, profile_field_min(field), field.max),
      )
    })
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
      && primitive
      && field.constraint != None
      && profile_json_field_name(field, "") == "value"
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
  let binding_datatype = case parent {
    Ok(root) ->
      case root.type_ {
        [type_] -> type_.code
        _ -> root.path
      }
    Error(_) -> ""
  }
  let binding_guard = case binding, binding_datatype {
    None, _ -> ""
    Some(url), "Coding" | Some(url), "Quantity" -> {
      "  use binding_code <- decode.optional_field(\"code\", None, decode.optional(decode.string))\n"
      <> "  use binding_system <- decode.optional_field(\"system\", None, decode.optional(decode.string))\n"
      <> "  use _ <- decode.then(case binding_code, binding_system {\n"
      <> "    Some(code), Some(system) -> case valueset."
      <> codegen_helpers.to_snake_case(
        codegen_helpers.concept_name_from_url(canonical_url(url)),
      )
      <> "_parse_code_and_system(code, system) { Ok(_) -> decode.success(Nil) Error(_) -> decode.failure(Nil, \"need code + system from required ValueSet\") }\n"
      <> case binding_datatype == "Quantity" {
        True -> "    None, _ -> decode.success(Nil)\n"
        False -> ""
      }
      <> "    _, _ -> decode.failure(Nil, \"need code + system from required ValueSet\")\n"
      <> "  })\n"
    }
    Some(url), _ ->
      "  use binding_matches <- decode.field(\"coding\", decode.list(decode.one_of({\n"
      <> "    use code <- decode.field(\"code\", decode.string)\n"
      <> "    use system <- decode.field(\"system\", decode.string)\n"
      <> "    decode.success(result.is_ok(valueset."
      <> codegen_helpers.to_snake_case(
        codegen_helpers.concept_name_from_url(canonical_url(url)),
      )
      <> "_parse_code_and_system(code, system)))\n"
      <> "  }, [decode.success(False)])))\n"
      <> "  use _ <- decode.then(case list.any(binding_matches, fn(matches) { matches }) {\n"
      <> "    True -> decode.success(Nil)\n"
      <> "    False -> decode.failure(Nil, \"need a coding with code + system from required ValueSet\")\n"
      <> "  })\n"
  }
  let parent = case parent {
    Ok(parent) ->
      case
        primitive
        && parent.constraint != None
        || {
          case parent.constraint {
            Some(codegen_constraint.Constraint(
              fixed: True,
              value: codegen_constraint.Object(_),
              ..,
            )) -> True
            _ -> False
          }
        }
      {
        True -> [parent]
        False -> []
      }
    _ -> []
  }
  let constraint_guards =
    list.append(parent, raw_constraints)
    |> list.filter(fn(element) {
      case codegen_helpers.constant(element) {
        Some(codegen_constraint.Boolean(_))
          if !primitive && element.min == 0 && element.max == "1"
        -> False
        _ ->
          !primitive
          || !list.any(parent, fn(root) {
            root.id <> ".value" == element.id
            && codegen_helpers.constant(root) != None
            && codegen_helpers.constant(root)
            == codegen_helpers.constant(element)
          })
      }
    })
    |> list.map(fn(element) {
      let assert Some(constraint) = element.constraint
      let is_parent = list.any(parent, fn(parent) { parent.id == element.id })
      let name = profile_json_field_name(element, "")
      let scalar = constraint_decoder_source(context, element, constraint).0
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
              codegen_helpers.Element(
                ..element,
                constraint: None,
                fixed_code: None,
                fixed_uri: None,
              ),
              context.current_bucket,
              "value",
            )
          "case primitive.value { Some(value) -> case json.parse(json.to_string("
          <> encoded
          <> "), "
          <> scalar
          <> ") { Ok(_) -> decode.success(Nil) Error(json.UnableToDecode(errors)) -> decode.failure(Nil, \"primitive constraint\") |> decode.map_errors(fn(_) { errors }) Error(_) -> decode.failure(Nil, \"primitive constraint JSON\") } None -> "
          <> case element.min {
            0 -> "decode.success(Nil)"
            _ ->
              "decode.failure(Nil, \"Field\") |> decode.map_errors(fn(_) { [decode.DecodeError(expected: \"Field\", found: \"Nothing\", path: [])] })"
          }
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
      let #(_, field_path, json_name, _, _, _) =
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
  let #(bindings, choices, slice_decodes) =
    list.fold(fields, #("", "", []), fn(acc, element) {
      let #(bindings, choices, slice_decodes) = acc
      use <- bool.guard(
        list.any(inputs, fn(field) { field.id == element.id }),
        acc,
      )
      let #(_, field_path, json_name, field_name, _, _) =
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
            <> "\", decode.list("
            <> scalar_decoder
            <> "))\n"
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
                let #(parts, _, _, _, field_type, _) =
                  profile_element_names(context, target_type, element)
                let matches = case literal, field_type {
                  codegen_constraint.Text(value), "String" ->
                    "entry.0 == " <> json.to_string(json.string(value))
                  codegen_constraint.Integer(value), "Int" ->
                    "entry.0 == " <> int.to_string(value)
                  codegen_constraint.Integer(value), "Float" ->
                    "entry.0 == " <> int.to_string(value) <> ".0"
                  codegen_constraint.Decimal(value), "Float" ->
                    "entry.0 == " <> json.to_string(json.float(value))
                  codegen_constraint.Boolean(value), "Bool" ->
                    "entry.0 == "
                    <> case value {
                      True -> "True"
                      False -> "False"
                    }
                  _, _ ->
                    profile_element_encoder_call(
                      context.current_bucket,
                      element,
                      field_type,
                      parts,
                      field_path,
                      context.type_order,
                      context.slice_type_overrides,
                      context.datatype_types,
                      context.snapshot_elements,
                      "entry.0",
                    )
                    <> " == "
                    <> codegen_constraint.json_source(literal)
                }
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
                    <> " { Some(_) -> decode.success(Nil) None -> { let errors = [decode.DecodeError(expected: "
                    <> expected
                    <> ", found: \"no matching element\", path: ["
                    <> json.to_string(json.string(json_name))
                    <> "])]\n"
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
              True -> complex_prefix <> "SliceElement(entry.0, Some(entry.1))"
              False -> "entry.0"
            }
            <> " })"
          let remainder =
            codegen_helpers.Element(
              ..element,
              min: profile_field_min(element),
              max: "*",
              pattern_literals: [],
            )
          let #(_, _, _, _, field_type, _) =
            profile_element_names(context, target_type, element)
          let placeholder =
            slice_cardinality_placeholder(
              context.current_bucket,
              remainder,
              fn() {
                let value = base_slice_placeholder(context, field_type)
                case context.preserve_slice_order {
                  True ->
                    complex_prefix <> "SliceElement(" <> value <> ", None)"
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
            choices <> slice_decode.support_source,
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
                    choices <> generated
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
              let #(_, _, json_name, field_name, field_type, _) =
                profile_element_names(context, target_type, field)
              let cardinality =
                slice_cardinality_expression(
                  context.current_bucket,
                  field,
                  "primitive.extension",
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
                case field.min, field.max {
                  0, "*" -> "  let " <> field_name <> " = primitive.extension\n"
                  _, _ ->
                    "  use "
                    <> field_name
                    <> " <- decode.then(case "
                    <> cardinality
                    <> " { Ok(value) -> decode.success(value) Error(errors) -> decode.failure("
                    <> placeholder
                    <> ", \"primitive extension cardinality\") |> decode.map_errors(fn(_) { errors }) })\n"
                },
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
      let #(_, _, json_name, field_name, _, _) =
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
      let #(_, _, json_name, field_name, _, _) =
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
        use <- bool.guard(!slice_decode.fallible, "")
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
    False -> []
    True ->
      fields
      |> list.filter(fn(field) {
        field.max != "0"
        && !{ primitive && profile_json_field_name(field, "") == "value" }
        && field.min > 0
        && field.max == "1"
        && !list.any(parent, fn(parent) {
          case parent.constraint {
            Some(codegen_constraint.Constraint(
              value: codegen_constraint.Object(_),
              ..,
            )) -> True
            _ -> False
          }
        })
      })
      |> list.filter_map(fn(element) {
        use fixed <- result.try(
          codegen_helpers.constant(element) |> option.to_result(Nil),
        )
        let json_name = profile_json_field_name(element, "")
        let scalar =
          constraint_decoder_source(
            context,
            element,
            codegen_constraint.Constraint(
              fixed: True,
              type_name: case element.type_ {
                [type_] -> type_.code
                _ -> {
                  let assert Some(constraint) = element.constraint
                  constraint.type_name
                }
              },
              value: fixed,
            ),
          ).0
        let check = case element.base.max, element.max, element.min {
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
            codegen_helpers.bucket_prefix("Quantity", context.current_bucket)
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
        Ok(#(
          list.any(inputs, fn(input) { input.id == element.id }),
          "  use _ <- " <> check <> "\n",
        ))
      })
  }
  let input_fixed_guards =
    fixed_guards
    |> list.filter(fn(guard) { guard.0 })
    |> list.map(fn(guard) { guard.1 })
    |> string.concat
  let fixed_guards =
    fixed_guards
    |> list.filter(fn(guard) { !guard.0 })
    |> list.map(fn(guard) { guard.1 })
    |> string.concat
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
          use <- bool.guard(!slice_decode.fallible, "")
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
        slice_decodes
        |> list.map(fn(slice_decode) {
          case slice_decode.fallible {
            True -> slice_decode.result_name
            False -> "Ok(" <> slice_decode.result_name <> ")"
          }
        })
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
        |> list.map(fn(name) { "result.unwrap_error(" <> name <> ", [])" })
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
      let #(_, _, _, _, field_type, _) =
        profile_element_names(context, target_type, value_field)
      let assert [scalar_type] = value_field.type_
      let #(scalar_field_type, _) =
        codegen_helpers.string_to_type(
          scalar_type.code,
          [],
          value_field,
          context.current_bucket,
          dict.new(),
        )
      let scalar_decoder =
        codegen_decode.decoder_for_type(
          scalar_type.code,
          scalar_field_type,
          context.current_bucket,
        )
      #(
        scalar_field_type,
        case codegen_helpers.constant(value_field), value_field.min {
          Some(_), minimum if omit_fixed && minimum > 0 -> ""
          Some(codegen_constraint.Boolean(_)), 0 ->
            "  let value = option.map(primitive.value, fn(_) { "
            <> field_type
            <> " })\n"
          Some(_), 0 if field_type == "Nil" ->
            "  let value = option.map(primitive.value, fn(_) { Nil })\n"
          _, 0 -> "  let value = primitive.value\n"
          _, _ ->
            "  use value <- decode.then(case primitive.value { Some(value) -> decode.success(value) None -> decode.field("
            <> json.to_string(json.string(primitive_name))
            <> ", "
            <> scalar_decoder
            <> ", decode.success) })\n"
        },
      )
    }
  }
  let body =
    binding_guard
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
  use <- bool.guard(inline, "{\n" <> body <> "}\n")
  primitive_extension_source
  <> choices
  <> case inputs {
    [] -> ""
    _ ->
      "pub fn "
      <> codegen_helpers.to_snake_case(target_type)
      <> "_decoder() -> Decoder("
      <> target_type
      <> ") {\n"
      <> input_bindings
      <> input_fixed_guards
      <> "  "
      <> codegen_helpers.to_snake_case(target_type)
      <> "_slice_decoder("
      <> string.join(
        list.map(input_arguments, fn(argument) {
          argument.0 <> ": " <> argument.0
        }),
        ", ",
      )
      <> ")\n}\n\n"
  }
  <> "pub fn "
  <> codegen_helpers.to_snake_case(target_type)
  <> case primitive {
    True ->
      "_parse_primitive(\n  primitive: Primitive("
      <> primitive_value_type
      <> ", "
      <> primitive_extension_type
      <> "),\n) -> Decoder("
      <> target_type
      <> ") {\n"
    False ->
      case inputs {
        [] -> "_decoder("
        _ -> "_slice_decoder("
      }
      <> string.join(
        list.map(input_arguments, fn(argument) {
          argument.0 <> " " <> argument.0 <> ": " <> argument.1
        }),
        ", ",
      )
      <> ") -> Decoder("
      <> target_type
      <> ") {\n  use <- decode.recursive\n"
  }
  <> body
  <> "}\n\n"
}

fn extension_value_branch(
  current_bucket: codegen_helpers.Category,
  extension_name: String,
  field: codegen_helpers.Element,
  valueset_acc: dict.Dict(String, codegen_helpers.ValuesetItem),
  // _available_valuesets: dict.Dict(String, codegen_helpers.VsOrCs),
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
            <> "_parse_primitive, decode.success)",
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
  // available_valuesets: dict.Dict(String, codegen_helpers.VsOrCs),
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
            <> "ExtensionSliceElement(value: "
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
          // available_valuesets,
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
                <> "ExtensionSliceElement("
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
                  // available_valuesets,
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
                  // available_valuesets,
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
            True ->
              complex_prefix <> "ExtensionSliceElement(" <> field_type <> ")"
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
              complex_prefix
              <> "SliceElement("
              <> complex_prefix
              <> "Extension)"

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
                  <> "SliceElement(child, Some(index))"
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

pub fn decoder_requirements(
  context: DecodeContext,
  profile_type: String,
) -> codegen_helpers.RequiredCode {
  list.fold(
    context.type_order,
    codegen_helpers.required_code(),
    fn(required, current_type) {
      let assert Ok(fields) = dict.get(context.type_fields, current_type)
      let target_type = profile_type_name(context, current_type, profile_type)
      let primitive =
        is_primitive_slice_record(
          context.snapshot_elements,
          context.profile_prefix,
          context.type_order,
          current_type,
        )
      let required = case
        fields
        |> list.first
        |> result.try(fn(field) {
          let assert Ok(last) = field.id |> string.split(".") |> list.last
          find_element(
            context.snapshot_elements,
            string.drop_end(field.id, string.length(last) + 1),
          )
        })
      {
        Ok(parent) ->
          case parent.constraint {
            Some(constraint) if primitive ->
              codegen_helpers.merge_required_code(
                required,
                constraint_decoder_source(context, parent, constraint).1,
              )
            Some(
              codegen_constraint.Constraint(
                fixed: True,
                value: codegen_constraint.Object(_),
                ..,
              ) as constraint,
            ) ->
              codegen_helpers.merge_required_code(
                required,
                constraint_decoder_source(context, parent, constraint).1,
              )
            _ -> required
          }
        _ -> required
      }
      let required = case primitive {
        True -> codegen_helpers.require_type(required, "Primitive")
        False -> required
      }
      let required = case dict.has_key(context.binding_checks, current_type) {
        True ->
          codegen_helpers.RequiredCode(
            ..required,
            modules: required.modules
              |> set.insert("list")
              |> set.insert("result")
              |> set.insert("valueset"),
          )
        False -> required
      }
      list.fold(fields, required, fn(required, element) {
        use <- bool.guard(element.max == "0", required)
        let #(_, field_path, json_name, _, _, element) =
          profile_element_names(context, target_type, element)
        let required = case element.constraint {
          Some(codegen_constraint.Constraint(fixed: True, ..) as constraint) ->
            codegen_helpers.merge_required_code(
              required,
              constraint_decoder_source(context, element, constraint).1,
            )
          Some(codegen_constraint.Constraint(
            value: codegen_constraint.Object(_),
            ..,
          ))
          | Some(codegen_constraint.Constraint(
              value: codegen_constraint.Array(_),
              ..,
            ))
          | None -> required
          Some(constraint) ->
            codegen_helpers.merge_required_code(
              required,
              constraint_decoder_source(context, element, constraint).1,
            )
        }
        let required = case
          element.slicing,
          direct_slice_roots(element, fields)
        {
          Some(slicing), [_, ..] as roots ->
            case nested_slice_field(context, target_type, element, roots) {
              Some(plan) ->
                codegen_helpers.require_type(required, plan.base_type)
              None -> {
                let #(_, _, _, _, base_type, _) =
                  profile_element_names(context, target_type, element)
                let base_fields =
                  fields_for_profile_type(context, base_type, "")
                  |> result.lazy_or(fn() {
                    case
                      dict.get(
                        context.constructors,
                        constructor_key(context.current_bucket, base_type),
                      )
                    {
                      Ok(RecordConstructor(_, _, fields)) ->
                        Ok(list.map(fields, fn(field) { field.0 }))
                      _ -> Error(Nil)
                    }
                  })
                  |> result.unwrap([])
                list.fold(base_fields, required, fn(required, field) {
                  case
                    list.any(slicing.discriminator, fn(discriminator) {
                      discriminator.path == profile_json_field_name(field, "")
                    })
                  {
                    True -> {
                      let #(_, _, _, _, field_type, _) =
                        profile_element_names(context, base_type, field)
                      codegen_helpers.require_type(required, field_type)
                    }
                    False -> required
                  }
                })
              }
            }
          _, _ -> required
        }

        let minimum = profile_field_min(element)
        let type_count = list.length(element.type_)
        let primitive_slice =
          profile_field_is_primitive_slice(
            element,
            json_name,
            context.type_order,
            field_path,
          )
        let complex_prefix =
          codegen_helpers.bucket_prefix("Quantity", context.current_bucket)
        let required = case
          profile_field_is_slice_elt(
            element,
            fields,
            context.preserve_slice_order,
          )
        {
          True ->
            codegen_helpers.require_function(
              required,
              complex_prefix <> "slice_elements_to_values",
            )
          False -> required
        }
        let whole_field =
          element.slice_name == None
          && element.pattern_literals == []
          && direct_slice_roots(element, fields) == []
          && !{
            primitive
            && {
              json_name == "value"
              || json_name == "id"
              || json_name == "extension"
            }
          }
        let required = case whole_field {
          False -> required
          True ->
            case primitive_slice, element.base.max, element.max, minimum {
              True, "1", "1", 0 ->
                codegen_helpers.require_function(required, "primitive_decoder")
              True, "1", "1", _ ->
                codegen_helpers.require_function(
                  required,
                  "primitive_choice_slice_decoder",
                )
              True, _, _, _ ->
                codegen_helpers.require_function(
                  required,
                  "primitive_slice_list_decoder",
                )
              False, base_max, "1", 0 if base_max != "1" ->
                codegen_helpers.require_function(
                  required,
                  complex_prefix <> "optional_one_from_array_decoder",
                )
              False, base_max, "1", _ if base_max != "1" ->
                codegen_helpers.require_function(
                  required,
                  complex_prefix <> "one_from_array_decoder",
                )
              False, _, _, 0 if type_count > 1 ->
                codegen_helpers.require_function(required, "none_if_omitted")
              False, _, max, n if max != "1" && n > 0 && n <= 3 ->
                codegen_helpers.require_function(
                  required,
                  "list" <> int.to_string(n) <> "_decoder",
                )
              _, _, _, _ -> required
            }
        }
        let fixed_primitive =
          element.min > 0
          && element.max == "1"
          && element.base.max == "1"
          && codegen_helpers.constant(element) != None
        let required = case primitive_slice, element.base.max, minimum {
          True, _, _ if fixed_primitive -> required
          True, "1", _ ->
            codegen_helpers.require_function(
              required,
              "primitive_slice_to_json",
            )
          True, _, _ ->
            codegen_helpers.require_function(
              required,
              "primitive_slice_list_to_json",
            )
          _, _, _ -> required
        }
        let required = case element.type_ {
          [_, _, ..] ->
            list.fold(element.type_, required, fn(required, type_) {
              let variant = codegen_helpers.Element(..element, type_: [type_])
              let #(_, variant_path, variant_json_name, _, _, variant) =
                profile_element_names(context, target_type, variant)
              case
                profile_field_is_primitive_slice(
                  variant,
                  variant_json_name,
                  context.type_order,
                  variant_path,
                )
              {
                True ->
                  required
                  |> codegen_helpers.require_function(
                    "primitive_choice_slice_decoder",
                  )
                  |> codegen_helpers.require_function("primitive_slice_to_json")
                False -> required
              }
            })
          _ -> required
        }
        let modules = case
          direct_slice_roots(element, fields),
          element.slice_name,
          element.pattern_literals
        {
          [], None, [] -> required.modules
          _, _, _ -> {
            let modules =
              required.modules
              |> set.insert("list")
              |> set.insert("result")
            case
              list.any(element.type_, fn(type_) { type_.code == "Extension" })
              || aggregate_value_slice_roots(element, fields) != None
              || list.any(direct_slice_roots(element, fields), fn(root) {
                root.max == "0"
              })
            {
              True -> set.insert(modules, "int")
              False -> modules
            }
          }
        }
        let required = case
          element.slicing,
          direct_slice_roots(element, fields)
        {
          Some(_), [_, ..] as roots ->
            case
              element.base.max != "1"
              && type_count <= 1
              && !string.ends_with(element.path, "[x]")
              && !list.any(element.type_, fn(type_) {
                type_.code == "Extension"
              })
              && list.any(roots, fn(root) {
                case dict.get(context.slice_type_overrides, root.id) {
                  Ok(BoundCodingSlice) | Ok(BoundCodeableconceptSlice) -> False
                  _ -> True
                }
              })
            {
              True -> {
                let required =
                  codegen_helpers.require_type(
                    required,
                    complex_prefix <> "DiscriminatorMatch",
                  )
                codegen_helpers.RequiredCode(
                  ..required,
                  modules: set.insert(required.modules, "bool"),
                )
              }
              False -> required
            }
          _, _ -> required
        }
        let modules = set.union(modules, required.modules)
        let modules = case
          element.slicing,
          direct_slice_roots(element, fields)
        {
          Some(_), [_, ..] as roots -> {
            case nested_slice_field(context, target_type, element, roots) {
              Some(plan) -> {
                let needs_int =
                  plan.field.min > 0
                  || list.any(plan.cases, fn(candidate) {
                    candidate.field.min > 1
                    || list.any(candidate.fields, fn(field) {
                      field.0.min > 0
                      && list.any(plan.base_fields, fn(base) {
                        base.0.path == field.0.path
                        && {
                          base.0.min != field.0.min || base.0.max != field.0.max
                        }
                      })
                    })
                  })
                case needs_int {
                  True -> set.insert(modules, "int")
                  False -> modules
                }
              }
              None -> modules
            }
          }
          _, _ -> modules
        }
        let modules = case element.slice_name {
          Some(_) ->
            case dict.get(context.slice_type_overrides, element.id) {
              Ok(FixedSliceType(..)) | Ok(FixedValueDiscriminator(_)) ->
                modules |> set.insert("dict") |> set.insert("bool")
              _ -> modules
            }
          None -> modules
        }
        let modules = case
          element.slicing,
          direct_slice_roots(element, fields)
        {
          Some(slicing), [_, ..] as roots -> {
            let #(_, _, _, _, base_type, _) =
              profile_element_names(context, target_type, element)
            let base_fields =
              fields_for_profile_type(context, base_type, "")
              |> result.lazy_or(fn() {
                case
                  dict.get(
                    context.constructors,
                    constructor_key(context.current_bucket, base_type),
                  )
                {
                  Ok(RecordConstructor(_, _, fields)) ->
                    Ok(list.map(fields, fn(field) { field.0 }))
                  _ -> Error(Nil)
                }
              })
              |> result.unwrap([])
            let direct =
              slicing.discriminator != []
              && list.all(slicing.discriminator, fn(discriminator) {
                discriminator.type_ == "value"
                && list.any(base_fields, fn(field) {
                  let #(_, _, name, _, type_, _) =
                    profile_element_names(context, base_type, field)
                  name == discriminator.path && type_ == "String"
                })
                && list.all(roots, fn(root) {
                  case
                    find_element(
                      context.discriminator_elements,
                      root.id <> "." <> discriminator.path,
                    )
                  {
                    Ok(field) ->
                      field.min > 0
                      && case codegen_helpers.constant(field) {
                        Some(codegen_constraint.Text(_)) -> True
                        _ -> False
                      }
                    Error(_) -> False
                  }
                })
              })
            let uses_fields =
              !list.any(element.type_, fn(type_) { type_.code == "Extension" })
              && list.any(slicing.discriminator, fn(discriminator) {
                {
                  discriminator.type_ == "value"
                  || discriminator.type_ == "pattern"
                }
                && discriminator.path != "$this"
              })
            case
              uses_fields
              && !direct
              && nested_slice_field(context, target_type, element, roots)
              == None
            {
              True -> set.insert(modules, "dict")
              False -> modules
            }
          }
          _, _ -> modules
        }
        let modules = case
          element.constraint,
          element.type_,
          element.slice_name
        {
          Some(codegen_constraint.Constraint(
            fixed: True,
            value: codegen_constraint.Object(fields),
            ..,
          )),
            [codegen_helpers.Type(code: "Extension", ..)],
            Some(_)
          ->
            list.fold(fields, modules, fn(modules, field) {
              set.union(
                modules,
                codegen_constraint.required_modules(field.1, True),
              )
            })
          Some(constraint), _, _ -> {
            let constraint_modules =
              codegen_constraint.required_modules(
                constraint.value,
                constraint.fixed,
              )
            let constraint_modules = case
              element.slice_name == None
              && !dict.has_key(context.slice_discriminator_checks, element.id)
            {
              True -> set.delete(constraint_modules, "dict")
              False -> constraint_modules
            }
            set.union(modules, constraint_modules)
          }
          None, _, _ -> modules
        }
        codegen_helpers.RequiredCode(..required, modules: modules)
      })
    },
  )
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
    slice_inputs: _,
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
    binding_checks: _,
    // available_valuesets:,
    base_elements: _,
    constructors: _,
  ) = context
  let referenced_urls =
    type_order
    |> list.flat_map(fn(path) {
      dict.get(type_fields, path) |> result.unwrap([])
    })
    |> list.filter(fn(element) { element.max != "0" })
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
        // available_valuesets,
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
          let #(_, _, json_name, _, _, _) =
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
  let slice_inputs =
    dict.values(context.type_fields)
    |> list.fold(dict.new(), fn(inputs, fields) {
      list.fold(fields, inputs, fn(inputs, group) {
        case group.slicing {
          Some(slicing) if group.base.max != "1" -> {
            [group, ..direct_slice_roots(group, fields)]
            |> list.fold(inputs, fn(inputs, root) {
              let #(_, _, _, _, target_type, _) =
                profile_element_names(context, "", root)
              case fields_for_profile_type(context, target_type, "") {
                Error(_) -> inputs
                Ok(fields) -> {
                  let fields =
                    list.filter(fields, fn(field) {
                      field.max != "0"
                      && list.any(slicing.discriminator, fn(discriminator) {
                        let assert [first, ..] =
                          string.split(discriminator.path, ".")
                        first == profile_json_field_name(field, "")
                      })
                    })
                  case fields {
                    [] -> inputs
                    _ -> {
                      let previous =
                        dict.get(inputs, target_type) |> result.unwrap([])
                      dict.insert(
                        inputs,
                        target_type,
                        list.append(previous, fields) |> list.unique,
                      )
                    }
                  }
                }
              }
            })
          }
          _ -> inputs
        }
      })
    })
  let context = DecodeContext(..context, slice_inputs:)
  let decoders =
    list.fold(type_order, "", fn(source, current_type) {
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
          dict.get(context.binding_checks, current_type) |> option.from_result,
          False,
        )
      source <> generated
    })
  let support = slice_support_types(context, profile_type)
  #(
    extension_classifiers <> union_decoders <> support <> decoders,
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
            let #(open_field_type, element, valueset_acc) =
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
                type_slice_overrides,
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
                    let #(root_type, root, valueset_acc) =
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
                        type_slice_overrides,
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
            let constant_primitive = codegen_helpers.constant(element) != None

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
                        <> "SliceElement("
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
                      <> "SliceElement({"
                      <> encoder
                      <> "}(value.value), value.internal_gleam_fhir_index)"
                  }
                  <> " })"
                let values = "[" <> literals <> ", .." <> others <> "]"
                let values = case preserve_slice_order {
                  False -> values
                  True ->
                    complex_prefix
                    <> "slice_elements_to_values("
                    <> values
                    <> ")"
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
              [], None, _, True
                if element.min > 0
                && element.max == "1"
                && element.base.max == "1"
                && constant_primitive
              -> #(
                json_always,
                json_optional
                  <> "\nlet fields = case "
                  <> codegen_helpers.to_snake_case(base_field_type)
                  <> "_rest_to_json("
                  <> field_value
                  <> ") { None -> fields Some(value) -> [#(\"_"
                  <> json_field_name
                  <> "\", value), ..fields] }",
                aggregate_encoder <> choice_encoders,
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
                    type_slice_overrides,
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
                let #(resolved_choices, valueset_acc) =
                  list.fold(
                    case element.type_ {
                      [_, _, ..] -> element.type_
                      _ -> []
                    },
                    #([], valueset_acc),
                    fn(acc, choice) {
                      let #(choices, valueset_acc) = acc
                      let #(payload_type, source, valueset_acc) =
                        profile_base_field_type(
                          current_bucket,
                          codegen_helpers.Element(..element, type_: [choice]),
                          all_parts,
                          "",
                          choice_type,
                          extensions,
                          type_order,
                          slice_base_type_names,
                          slice_type_overrides,
                          datatype_types,
                          type_slice_overrides,
                          valueset_acc,
                        )
                      #(
                        [#(choice, source, payload_type), ..choices],
                        valueset_acc,
                      )
                    },
                  )
                let resolved_choices = list.reverse(resolved_choices)
                let primitive_choices =
                  list.any(resolved_choices, fn(choice) {
                    profile_field_is_primitive_slice(
                      choice.1,
                      "",
                      type_order,
                      "",
                    )
                  })
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
                let #(new_always, new_optional) = case primitive_choices {
                  True -> {
                    let assert "1" = element.max
                      as {
                        "unsupported repeated primitive choice " <> element.id
                      }
                    let call =
                      codegen_helpers.to_snake_case(choice_type)
                      <> "_to_json_fields(fields, "
                    #(
                      "",
                      "\nlet fields = "
                        <> case card_min {
                        0 ->
                          "case "
                          <> field_value
                          <> " { None -> fields Some(value) -> "
                          <> call
                          <> "value) }"
                        _ -> call <> field_value <> ")"
                      },
                    )
                  }
                  False ->
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
                }
                let new_choice_encoders = case element.type_ {
                  [] | [_] -> ""
                  _ -> {
                    let cases =
                      list.fold(resolved_choices, "", fn(cases, resolved) {
                        let #(choice, source, payload_type) = resolved
                        let constructor =
                          choice_type <> string.capitalise(choice.code)
                        let call =
                          profile_element_encoder_call(
                            current_bucket,
                            source,
                            payload_type,
                            all_parts,
                            "",
                            type_order,
                            slice_type_overrides,
                            datatype_types,
                            snapshot_elements,
                            "value",
                          )
                        let call = case primitive_choices {
                          False -> call
                          True -> {
                            let json_name = profile_json_field_name(source, "")
                            case
                              profile_field_is_primitive_slice(
                                source,
                                "",
                                type_order,
                                "",
                              )
                            {
                              True -> {
                                let function =
                                  codegen_helpers.to_snake_case(payload_type)
                                "primitive_slice_to_json(fields, value, "
                                <> function
                                <> "_value_to_json, "
                                <> function
                                <> "_rest_to_json, \""
                                <> json_name
                                <> "\")"
                              }
                              False ->
                                "[#(\""
                                <> json_name
                                <> "\", "
                                <> call
                                <> "), ..fields]"
                            }
                          }
                        }
                        cases
                        <> "    "
                        <> constructor
                        <> "(value) -> "
                        <> call
                        <> "\n"
                      })
                    "pub fn "
                    <> codegen_helpers.to_snake_case(choice_type)
                    <> case primitive_choices {
                      True ->
                        "_to_json_fields(fields: List(#(String, Json)), value: "
                      False -> "_to_json(value: "
                    }
                    <> choice_type
                    <> case primitive_choices {
                      True -> ") -> List(#(String, Json)) {\n  case value {\n"
                      False -> ") -> Json {\n  case value {\n"
                    }
                    <> cases
                    <> "  }\n}\n\n"
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
            fields != [],
          )
        True -> {
          let assert Ok(value_fields) = dict.get(type_fields, current_type)
          let assert Ok(value_field) =
            list.find(value_fields, fn(element) {
              profile_json_field_name(element, "") == "value"
            })
            as { "primitive record has no value field: " <> current_type }
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
          let fixed_primitive =
            value_field.min > 0 && codegen_helpers.constant(value_field) != None
          case fixed_primitive {
            True -> {
              let assert Some(value) = codegen_helpers.constant(value_field)
              "pub fn "
              <> encoder_name
              <> "_value_to_json(_primitive: "
              <> gleam_type
              <> ") -> Option(Json) { Some("
              <> codegen_constraint.json_source(value)
              <> ") }\n\n"
            }
            False ->
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
                _ ->
                  "  let value = primitive.value\n  Some(" <> value_call <> ")"
              }
              <> "\n}\n\n"
          }
          <> "pub fn "
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
