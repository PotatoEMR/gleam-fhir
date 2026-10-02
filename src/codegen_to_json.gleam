import codegen_bound_coding
import codegen_helpers
import gleam/dict
import gleam/list
import gleam/option.{Some}
import gleam/string

pub fn string_to_encoder_call(
  fhir_type: String,
  allparts: List(String),
  elt: codegen_helpers.Element,
  current: codegen_helpers.Category,
  value: String,
) -> String {
  let #(gleam_type, _) =
    codegen_helpers.string_to_type(
      fhir_type,
      allparts,
      elt,
      current,
      dict.new(),
    )
  let prefix = codegen_helpers.bucket_prefix("Coding", current)
  case
    fhir_type,
    codegen_bound_coding.bound_valueset_function_name(gleam_type)
  {
    "Coding", Some(valueset) ->
      codegen_bound_coding.bound_coding_encoder_call_source(
        prefix,
        valueset,
        value,
      )
    "CodeableConcept", Some(valueset) ->
      codegen_bound_coding.bound_codeableconcept_encoder_call_source(
        prefix,
        valueset,
        value,
      )
    "CodeableReference", Some(valueset) ->
      codegen_bound_coding.bound_codeablereference_encoder_call_source(
        prefix,
        valueset,
        value,
      )
    "Quantity", Some(valueset) ->
      codegen_bound_coding.bound_quantity_encoder_call_source(
        prefix,
        valueset,
        value,
      )
    _, _ ->
      string_to_encoder_type(fhir_type, allparts, elt, current)
      <> "("
      <> value
      <> ")"
  }
}

pub fn string_to_encoder_type(
  fhir_type: String,
  allparts: List(String),
  elt: codegen_helpers.Element,
  current: codegen_helpers.Category,
) -> String {
  let #(gleam_type, _) =
    codegen_helpers.string_to_type(
      fhir_type,
      allparts,
      elt,
      current,
      dict.new(),
    )
  let prefix = codegen_helpers.bucket_prefix("Coding", current)
  case
    fhir_type,
    codegen_bound_coding.bound_valueset_function_name(gleam_type)
  {
    "Coding", Some(valueset) ->
      codegen_bound_coding.bound_coding_encoder_source(prefix, valueset)
    "CodeableConcept", Some(valueset) ->
      codegen_bound_coding.bound_codeableconcept_encoder_source(
        prefix,
        valueset,
      )
    "CodeableReference", Some(valueset) ->
      codegen_bound_coding.bound_codeablereference_encoder_source(
        prefix,
        valueset,
      )
    "Quantity", Some(valueset) ->
      codegen_bound_coding.bound_quantity_encoder_source(prefix, valueset)
    _, _ ->
      case gleam_type {
        "String" -> "json.string"
        "Bool" -> "json.bool"
        "Int" -> "json.int"
        "Float" -> "json.float"
        "Date" -> "pt.date_to_json"
        "DateTime" -> "pt.datetime_to_json"
        "Instant" -> "pt.instant_to_json"
        "Time" -> "pt.time_to_json"
        _ ->
          gleam_type
          |> string.split(".")
          |> list.map(codegen_helpers.to_snake_case)
          |> string.join(".")
          <> "_to_json"
      }
  }
}
