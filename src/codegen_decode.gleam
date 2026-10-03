import codegen_bound_coding
import codegen_helpers
import gleam/dict
import gleam/list
import gleam/option.{Some}
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
      codegen_bound_coding.bound_coding_decoder_source(prefix, valueset)
    "CodeableConcept", Some(valueset) ->
      codegen_bound_coding.bound_codeableconcept_decoder_source(
        prefix,
        valueset,
      )
    "CodeableReference", Some(valueset) ->
      codegen_bound_coding.bound_codeablereference_decoder_source(
        prefix,
        valueset,
      )
    "Quantity", Some(valueset) ->
      codegen_bound_coding.bound_quantity_decoder_source(prefix, valueset)
    _, _ ->
      case gleam_type {
        "String" -> "decode.string"
        "Bool" -> "decode.bool"
        "Int" -> "decode.int"
        "Float" -> "decode_number()"
        "Date" -> "pt.date_decoder()"
        "DateTime" -> "pt.datetime_decoder()"
        "Instant" -> "pt.instant_decoder()"
        "Time" -> "pt.time_decoder()"
        _ ->
          gleam_type
          |> string.split(".")
          |> list.map(codegen_helpers.to_snake_case)
          |> string.join(".")
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
    "*", 0, True ->
      "primitives_decoder(\""
      <> name
      <> "\", "
      <> decoder
      <> ", extension_decoder())"
    "*", 0, False ->
      "decode.optional_field(\""
      <> name
      <> "\", [], decode.list("
      <> decoder
      <> "))"
    "*", 1, True ->
      "primitives_decoder(\""
      <> name
      <> "\", "
      <> decoder
      <> ", extension_decoder())"
    "*", 1, False -> "list1_decoder(\"" <> name <> "\", " <> decoder <> ")"
    "*", 2, _ -> "list2_decoder(\"" <> name <> "\", " <> decoder <> ")"
    "*", 3, _ -> "list3_decoder(\"" <> name <> "\", " <> decoder <> ")"
    _, 0, True ->
      "primitive_decoder(\""
      <> name
      <> "\", "
      <> decoder
      <> ", extension_decoder())"
    _, 0, False ->
      "decode.optional_field(\""
      <> name
      <> "\", None, decode.optional("
      <> decoder
      <> "))"
    _, 1, True ->
      "primitive_decoder(\""
      <> name
      <> "\", "
      <> decoder
      <> ", extension_decoder())"
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
