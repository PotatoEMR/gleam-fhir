import gleeunit

/// "gleam test" runs all the whatever_test.gleam files in this folder ending in _test
/// simple r4/r4b/r5 are basically same, except r5 uses codeablereference instead of codeableconcept
/// parse_json_examples decodes all of https://hl7.org/fhir/[R4, R4B, R5]/fhir.schema.json.zip
///   note that some examples fail to parse, but it seems like they don't comply with the spec?
pub fn main() -> Nil {
  gleeunit.main()
}
