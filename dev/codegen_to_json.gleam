import codegen_bound_coding
import codegen_helpers
import gleam/list
import gleam/option.{None, Some}
import gleam/string

pub fn string_to_encoder_call(
  fhir_type: String,
  allparts: List(String),
  elt: codegen_helpers.Element,
  current: codegen_helpers.Category,
  value: String,
) -> String {
  let prefix = codegen_helpers.bucket_prefix("Coding", current)
  case fhir_type, codegen_bound_coding.bound_valueset_function_name(elt) {
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
  case fhir_type {
    "BackboneElement" ->
      allparts
      |> list.map(string.capitalise)
      |> string.concat()
      |> codegen_helpers.to_snake_case()
      <> "_to_json"
    "Element" ->
      allparts
      |> list.map(string.capitalise)
      |> string.concat()
      |> codegen_helpers.to_snake_case()
      <> "_to_json"
    "base64Binary" -> "json.string"
    "boolean" -> "json.bool"
    "canonical" -> "json.string"
    "Coding" -> {
      let prefix = codegen_helpers.bucket_prefix("Coding", current)
      case codegen_bound_coding.bound_valueset_function_name(elt) {
        Some(valueset) ->
          codegen_bound_coding.bound_coding_encoder_source(prefix, valueset)
        None -> prefix <> "coding_to_json"
      }
    }
    "CodeableConcept" -> {
      let prefix = codegen_helpers.bucket_prefix("Codeableconcept", current)
      case codegen_bound_coding.bound_valueset_function_name(elt) {
        Some(valueset) ->
          codegen_bound_coding.bound_codeableconcept_encoder_source(
            prefix,
            valueset,
          )
        None -> prefix <> "codeableconcept_to_json"
      }
    }
    "CodeableReference" -> {
      let prefix = codegen_helpers.bucket_prefix("Codeablereference", current)
      case codegen_bound_coding.bound_valueset_function_name(elt) {
        Some(valueset) ->
          codegen_bound_coding.bound_codeablereference_encoder_source(
            prefix,
            valueset,
          )
        None -> prefix <> "codeablereference_to_json"
      }
    }
    "Quantity" -> {
      let prefix = codegen_helpers.bucket_prefix("Quantity", current)
      case codegen_bound_coding.bound_valueset_function_name(elt) {
        Some(valueset) ->
          codegen_bound_coding.bound_quantity_encoder_source(prefix, valueset)
        None -> prefix <> "quantity_to_json"
      }
    }
    "code" -> {
      let s = allparts |> string.concat()
      case s {
        "somehow this is used in [x] for any type (int, bool, code, etc) and ofc that code has no defined binding" ->
          "String"
        _ ->
          case elt.binding {
            Some(x) ->
              case x.strength {
                "required" ->
                  case x.value_set {
                    Some(vs) -> {
                      let assert [url, ..] = string.split(vs, "|")
                        as "split vs version"
                      case
                        string.contains(url, "v3-Confidentiality")
                        || string.contains(url, "mimetypes")
                        || string.contains(url, "currencies")
                        || string.contains(url, "all-languages")
                        || string.contains(url, "ucum-units")
                        || string.contains(url, "color-codes")
                      {
                        True -> "json.string"
                        False ->
                          "valuesets."
                          <> url
                          |> codegen_helpers.concept_name_from_url()
                          |> codegen_helpers.to_snake_case
                          <> "_to_json"
                      }
                    }
                    _ -> panic as "huh idk 2"
                  }
                _ -> "json.string"
              }
            None -> "json.string"
          }
      }
    }
    "date" -> "pt.date_to_json"
    "dateTime" -> "pt.datetime_to_json"
    "decimal" -> "json.float"
    "id" -> "json.string"
    "instant" -> "pt.instant_to_json"
    "integer" -> "json.int"
    "integer64" -> "json.string"
    "markdown" -> "json.string"
    "oid" -> "json.string"
    "positiveInt" -> "json.int"
    "string" -> "json.string"
    "time" -> "pt.time_to_json"
    "unsignedInt" -> "json.int"
    "uri" -> "json.string"
    "url" -> "json.string"
    "uuid" -> "json.string"
    "xhtml" -> "json.string"
    "http://hl7.org/fhirpath/System.String" -> "json.string"
    _ -> {
      let camel = codegen_helpers.to_camel_case(fhir_type)
      codegen_helpers.bucket_prefix(camel, current)
      <> { fhir_type |> string.lowercase() }
      <> "_to_json"
    }
  }
}
