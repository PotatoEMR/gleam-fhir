import fhir/r4
import fhir/r4_valuesets
import gleam/json
import gleam/option.{Some}

pub fn resources_docs_15_json_3_test() {
  let json_could_be_any_resource =
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

  let assert Ok(r4.ResourceAllergyintolerance(shellfish_allergy)) =
    json_could_be_any_resource |> json.parse(r4.resource_decoder())
  assert shellfish_allergy.criticality
    == Some(r4_valuesets.AllergyintolerancecriticalityLow)
}
