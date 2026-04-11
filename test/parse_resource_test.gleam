import fhir/r4usp
import gleam/json
import gleam/string

const imm_json_no_restype = "{
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

const imm_json_weird_restype = "{
  \"resourceType\": \"xd\",
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

const imm_json_missing_field = "{
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
  \"primarySource\": true
}"

pub fn main() {
  let assert Error(json.UnableToDecode([_, dec_err])) =
    imm_json_no_restype |> json.parse(r4usp.resource_decoder())
  assert dec_err.expected |> string.contains("one of Account,")
  let assert Error(json.UnableToDecode([dec_err])) =
    imm_json_weird_restype |> json.parse(r4usp.resource_decoder())
  //make it clear resource missing valid resource name
  assert dec_err.expected |> string.contains("one of Account,")
  let assert Error(json.UnableToDecode([dec_err])) =
    imm_json_missing_field |> json.parse(r4usp.resource_decoder())
  // mention name of resource that failed to decode
  // at beginning of its path, which technically is not part of its path
  // but probably helpful for debugging/logging and maybe showing user
  // to know which resource type had the error (with rest of path)
  let assert [fst, ..] = dec_err.path
  assert fst |> string.contains("(Immunization)")
}
