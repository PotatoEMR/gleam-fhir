import codegen_bound_coding
import codegen_helpers
import gleam/dict
import gleam/json
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
  case elt.gleam_arguments, elt.gleam_type {
    Some(arguments), Some(name) -> {
      let call =
        codegen_helpers.bucket_prefix("Quantity", current)
        <> codegen_helpers.to_snake_case(name)
        <> "_to_json("
      let arguments =
        string.concat(
          list.map(arguments, fn(value) {
            ", " <> json.to_string(json.string(value))
          }),
        )
      call <> value <> arguments <> ")"
    }
    _, _ -> {
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
        "Coding", Some(valueset) -> {
          let assert [name, ..] = string.split(gleam_type, "(")
          let name =
            string.replace(name, prefix, "") |> codegen_helpers.to_snake_case
          prefix
          <> name
          <> "_to_json("
          <> value
          <> ", valuesets."
          <> valueset
          <> "_to_code, valuesets."
          <> valueset
          <> "_system)"
        }
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
  }
}

pub fn string_to_encoder_type(
  fhir_type: String,
  allparts: List(String),
  elt: codegen_helpers.Element,
  current: codegen_helpers.Category,
) -> String {
  case elt.gleam_arguments, elt.gleam_type {
    Some(arguments), Some(name) -> {
      let call =
        codegen_helpers.bucket_prefix("Quantity", current)
        <> codegen_helpers.to_snake_case(name)
        <> "_to_json("
      let arguments =
        string.concat(
          list.map(arguments, fn(value) {
            ", " <> json.to_string(json.string(value))
          }),
        )
      "{ fn(value) { " <> call <> "value" <> arguments <> ") } }"
    }
    _, _ -> {
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
        "Coding", Some(valueset) -> {
          let assert [name, ..] = string.split(gleam_type, "(")
          let name =
            string.replace(name, prefix, "") |> codegen_helpers.to_snake_case
          "fn(coding) { "
          <> prefix
          <> name
          <> "_to_json(coding, valuesets."
          <> valueset
          <> "_to_code, valuesets."
          <> valueset
          <> "_system) }"
        }
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
  }
}
