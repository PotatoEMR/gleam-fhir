import check_roundtrip
import fhir/r4usp
import fhir/r4usp_valuesets
import gleam/json
import gleam/list
import gleam/option.{Some}

const imm_json = "{
  \"resourceType\": \"Immunization\",
  \"id\": \"56c60611-48f4-40b9-8833-429ba36dc71f\",
  \"meta\": {
    \"versionId\": \"4\",
    \"lastUpdated\": \"2021-04-06T03:13:38.379-04:00\",
    \"tag\": [
      {
        \"system\": \"https://smarthealthit.org/tags\",
        \"code\": \"synthea-5-2019\"
      }
    ]
  },
  \"status\": \"completed\",
  \"vaccineCode\": {
    \"coding\": [
      {
        \"system\": \"http://hl7.org/fhir/sid/cvx\",
        \"code\": \"140\",
        \"display\": \"Influenza, seasonal, injectable, preservative free\"
      }
    ],
    \"text\": \"Influenza, seasonal, injectable, preservative free\"
  },
  \"patient\": {
    \"reference\": \"Patient/7c058fdc-75a9-4837-bedf-3bf1924311b7\"
  },
  \"encounter\": {
    \"reference\": \"Encounter/e7a83d18-2f12-407c-a08f-016bb0b84a77\"
  },
  \"occurrenceDateTime\": \"2016-09-02T09:24:03+00:00\",
  \"primarySource\": true
}"

pub fn main() {
  check_roundtrip.check_roundtrip(
    imm_json,
    r4usp.immunization_decoder(),
    r4usp.immunization_to_json,
    "immunization_choice_test",
  )
}
