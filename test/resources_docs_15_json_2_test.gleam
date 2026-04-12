import fhir/r4
import gleam/dynamic/decode
import gleam/json
import gleam/option.{Some}
import gleam/string

pub fn resources_docs_15_json_2_test() {
  let good_json =
    "
{
    \"resourceType\"      : \"AllergyIntolerance\",
    \"id\"                : \"9b6a76f1-ee00-4efc-828d-ffbae3cb4220\",
    \"meta\"              : {
        \"versionId\"  : \"4\",
        \"lastUpdated\": \"2021-04-07T02:57:18.833-04:00\",
        \"tag\"        : [ {\"system\": \"https://smarthealthit.org/tags\", \"code\": \"synthea-5-2019\"} ]
    },
    \"clinicalStatus\"    : {
        \"coding\": [
            {
                \"system\": \"http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical\",
                \"code\"  : \"active\"
            }
        ]
    },
    \"verificationStatus\": {
        \"coding\": [
            {
                \"system\": \"http://terminology.hl7.org/CodeSystem/allergyintolerance-verification\",
                \"code\"  : \"confirmed\"
            }
        ]
    },
    \"type\"              : \"allergy\",
    \"category\"          : [\"food\"],
    \"criticality\"       : \"low\",
    \"code\"              : {
        \"coding\": [
            {
                \"system\" : \"http://snomed.info/sct\",
                \"code\"   : \"300913006\",
                \"display\": \"Shellfish allergy\"
            }
        ],
        \"text\"  : \"Shellfish allergy\"
    },
    \"patient\"           : {\"reference\": \"Patient/10fe9427-a075-4d8c-8af7-1d4d24f72112\"},
    \"recordedDate\"      : \"1990-06-07T22:39:54+00:00\"
}
"

  let assert Error(json.UnableToDecode([
    decode.DecodeError("Field", "Nothing", ["patient"]),
  ])) =
    good_json
    |> string.replace(
      "\"patient\"           : {\"reference\": \"Patient/10fe9427-a075-4d8c-8af7-1d4d24f72112\"},",
      "",
    )
    |> json.parse(r4.allergyintolerance_decoder())

  let assert Error(json.UnableToDecode([
    decode.DecodeError(
      "Allergyintolerancecriticality",
      "String",
      ["criticality"],
    ),
  ])) =
    good_json
    |> string.replace("\"low\"", "\"super-serious\"")
    |> json.parse(r4.allergyintolerance_decoder())

  let assert Error(json.UnableToDecode([
    decode.DecodeError("String", "Int", ["id"]),
  ])) =
    good_json
    |> string.replace("\"9b6a76f1-ee00-4efc-828d-ffbae3cb4220\"", "123")
    |> json.parse(r4.allergyintolerance_decoder())

  let assert Ok(shellfish_allergy) =
    good_json |> json.parse(r4.allergyintolerance_decoder())
  assert shellfish_allergy.id == Some("9b6a76f1-ee00-4efc-828d-ffbae3cb4220")
}
