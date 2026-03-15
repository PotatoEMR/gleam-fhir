import check_roundtrip
import fhir/r4us
import gleam/json

pub fn extension_simple_test() {
  let birthsex_json =
    "{
      \"url\": \"http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex\",
      \"valueCode\": \"M\"
    }"
  let assert Ok(Ok(_)) =
    json.parse(birthsex_json, r4us.us_core_birthsex_decoder())

  let patient =
    "{
      \"resourceType\": \"Patient\",
      \"id\": \"example\",
      \"extension\": [
        {
          \"url\": \"http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex\",
          \"valueCode\": \"M\"
        }
      ],
      \"name\": [{ \"family\": \"Shaw\", \"given\": [\"Amy\"] }],
      \"gender\": \"female\"
    }"
  check_roundtrip.check_roundtrip(
    patient,
    r4us.patient_decoder(),
    r4us.patient_to_json,
    "extension_simple_patient",
  )
  let assert Ok(p) = json.parse(patient, r4us.patient_decoder())
  let assert [_bs] = p.us_core_birthsex
  let assert [] = p.extension
}
