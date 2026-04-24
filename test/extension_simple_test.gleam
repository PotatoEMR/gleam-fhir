import fhir/r4us/complex_types as ct
import fhir/r4us/resources

import check_roundtrip
import gleam/json

pub fn extension_simple_test() {
  let birthsex_json =
    "{
      \"url\": \"http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex\",
      \"valueCode\": \"M\"
    }"
  let assert Ok(Ok(_)) =
    json.parse(birthsex_json, ct.us_core_birthsex_decoder())

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
    resources.patient_decoder(),
    resources.patient_to_json,
    "extension_simple_patient",
  )
  let assert Ok(p) = json.parse(patient, resources.patient_decoder())
  let assert [_bs] = p.us_core_birthsex
  let assert [] = p.extension
}
