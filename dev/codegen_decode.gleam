import codegen_bound_coding
import codegen_helpers
import gleam/list
import gleam/option.{None, Some}
import gleam/string

pub const result_or_decode_failure = "fn result_or_decode_failure(
  result: Result(a, String),
  placeholder placeholder: a,
  then next: fn(a) -> Decoder(b),
) -> Decoder(b) {
  case result {
    Ok(value) -> next(value)
    Error(reason) -> {
      use failed <- decode.then(decode.failure(placeholder, reason))
      next(failed)
    }
  }
}
"

pub const array_cardinality_decoders = "
pub fn one_from_array_decoder(
  name: String,
  inner: decode.Decoder(a),
  next: fn(a) -> decode.Decoder(b),
) -> decode.Decoder(b) {
  use values <- decode.field(name, decode.list(inner))
  case values {
    [value] -> next(value)
    _ -> {
      use impossible_value <- decode.field(name, inner)
      next(impossible_value)
    }
  }
}

pub fn optional_one_from_array_decoder(
  name: String,
  inner: decode.Decoder(a),
  next: fn(Option(a)) -> decode.Decoder(b),
) -> decode.Decoder(b) {
  use values <- decode.optional_field(name, [], decode.list(inner))
  case values {
    [] -> next(None)
    [value] -> next(Some(value))
    _ -> {
      use impossible_value <- decode.field(name, inner)
      next(Some(impossible_value))
    }
  }
}
"

pub fn string_to_decoder_type(
  fhir_type: String,
  allparts: List(String),
  _fhir_version: String,
  elt: codegen_helpers.Element,
  current: codegen_helpers.Category,
) -> String {
  case fhir_type {
    "BackboneElement" ->
      allparts
      |> list.map(string.capitalise)
      |> string.concat()
      |> codegen_helpers.to_snake_case()
      <> "_decoder()"
    "Element" ->
      allparts
      |> list.map(string.capitalise)
      |> string.concat()
      |> codegen_helpers.to_snake_case()
      <> "_decoder()"
    "base64Binary" -> "decode.string"
    "boolean" -> "decode.bool"
    "canonical" -> "decode.string"
    "Coding" -> {
      let prefix = codegen_helpers.bucket_prefix("Coding", current)
      case codegen_bound_coding.bound_valueset_function_name(elt) {
        Some(valueset) ->
          codegen_bound_coding.bound_coding_decoder_source(prefix, valueset)
        None -> prefix <> "coding_decoder()"
      }
    }
    "CodeableConcept" -> {
      let prefix = codegen_helpers.bucket_prefix("Codeableconcept", current)
      case codegen_bound_coding.bound_valueset_function_name(elt) {
        Some(valueset) ->
          codegen_bound_coding.bound_codeableconcept_decoder_source(
            prefix,
            valueset,
          )
        None -> prefix <> "codeableconcept_decoder()"
      }
    }
    "CodeableReference" -> {
      let prefix = codegen_helpers.bucket_prefix("Codeablereference", current)
      case codegen_bound_coding.bound_valueset_function_name(elt) {
        Some(valueset) ->
          codegen_bound_coding.bound_codeablereference_decoder_source(
            prefix,
            valueset,
          )
        None -> prefix <> "codeablereference_decoder()"
      }
    }
    "Quantity" -> {
      let prefix = codegen_helpers.bucket_prefix("Quantity", current)
      case codegen_bound_coding.bound_valueset_function_name(elt) {
        Some(valueset) ->
          codegen_bound_coding.bound_quantity_decoder_source(prefix, valueset)
        None -> prefix <> "quantity_decoder()"
      }
    }
    "code" -> {
      let s = allparts |> string.concat()
      case s {
        "somehow this is used in [x] for any type (int, bool, code, etc) and ofc that code has no defined binding" ->
          "String"
        _ -> {
          case elt.binding {
            Some(x) ->
              case x.strength {
                "required" -> {
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
                        True -> "decode.string"
                        False ->
                          "valuesets."
                          <> url
                          |> codegen_helpers.concept_name_from_url()
                          |> codegen_helpers.to_snake_case
                          <> "_decoder()"
                      }
                    }
                    _ -> panic as "huh idk 2"
                  }
                }
                _ -> "decode.string"
              }
            None -> "decode.string"
          }
        }
      }
    }
    "date" -> "pt.date_decoder()"
    "dateTime" -> "pt.datetime_decoder()"
    "decimal" -> "decode_number()"
    "id" -> "decode.string"
    "instant" -> "pt.instant_decoder()"
    "integer" -> "decode.int"
    "integer64" -> "decode.string"
    "markdown" -> "decode.string"
    "oid" -> "decode.string"
    "positiveInt" -> "decode.int"
    "string" -> "decode.string"
    "time" -> "pt.time_decoder()"
    "unsignedInt" -> "decode.int"
    "uri" -> "decode.string"
    "url" -> "decode.string"
    "uuid" -> "decode.string"
    "xhtml" -> "decode.string"
    "http://hl7.org/fhirpath/System.String" -> "decode.string"
    _ -> {
      let camel = codegen_helpers.to_camel_case(fhir_type)
      codegen_helpers.bucket_prefix(camel, current)
      <> { fhir_type |> string.lowercase() }
      <> "_decoder()"
    }
  }
}

pub fn gen_choice_field_decoder(
  type_code,
  allparts,
  fhir_version,
  elt,
  choice_option_caps,
  choicetype_last_part,
  current: codegen_helpers.Category,
) -> String {
  let assert [fst, ..rest] = type_code |> string.to_graphemes
  let choicetype_parse_label =
    choicetype_last_part <> string.uppercase(fst) <> string.concat(rest)
  let type_decoder =
    string_to_decoder_type(type_code, allparts, fhir_version, elt, current)
  "decode.field(\""
  <> choicetype_parse_label
  <> "\", "
  <> type_decoder
  <> ", decode.success) |> decode.map("
  <> choice_option_caps
  <> "),"
}

pub fn field_decoder(
  name: String,
  decoder: String,
  min: Int,
  max: String,
  is_primitive: Bool,
) -> String {
  case max, min, is_primitive {
    "*", 0, True -> "primitives_decoder(\"" <> name <> "\", " <> decoder <> ")"
    "*", 0, False ->
      "decode.optional_field(\""
      <> name
      <> "\", [], decode.list("
      <> decoder
      <> "))"
    "*", 1, True -> "primitives_decoder(\"" <> name <> "\", " <> decoder <> ")"
    "*", 1, False -> "list1_decoder(\"" <> name <> "\", " <> decoder <> ")"
    "*", 2, _ -> "list2_decoder(\"" <> name <> "\", " <> decoder <> ")"
    "*", 3, _ -> "list3_decoder(\"" <> name <> "\", " <> decoder <> ")"
    _, 0, True -> "primitive_decoder(\"" <> name <> "\", " <> decoder <> ")"
    _, 0, False ->
      "decode.optional_field(\""
      <> name
      <> "\", None, decode.optional("
      <> decoder
      <> "))"
    _, 1, True -> "primitive_decoder(\"" <> name <> "\", " <> decoder <> ")"
    _, 1, False -> "decode.field(\"" <> name <> "\", " <> decoder <> ")"
    "*", _, _ -> panic as "list min > 3 not supported"
    _, _, _ -> panic as "unsupported field cardinality"
  }
}

pub fn gen_res_decoder(
  respascal: String,
  rescamel: String,
  reslower: String,
  use_list: String,
  success_list: String,
  is_domainresource: Bool,
  decoder_always_failure_fordr: String,
) {
  let resource_type = case is_domainresource {
    True -> "\n    use rt <- decode.field(\"resourceType\", decode.string)
      use <- bool.guard(rt != \"" <> respascal <> "\", decode.failure(RESNAMELOWER_new(" <> decoder_always_failure_fordr <> "), \"resourceType\"))"
    False -> ""
  }
  let template = "pub fn RESNAMELOWER_decoder() -> Decoder(RESNAMECAMEL) {
     use <- decode.recursive\n" <> use_list <> resource_type <> "decode.success(RESNAMECAMEL(" <> success_list <> "))}"
  template
  |> string.replace("RESNAMELOWER", reslower)
  |> string.replace("RESNAMECAMEL", rescamel)
}
