import fhir/r4/complex_types as ct
import fhir/r4/primitive_types as pt
import fhir/r4/resources
import fhir/r4/valuesets
import gleam/dynamic/decode
import gleam/string

import gleam/json
import gleam/option.{None, Some}
import gleam/time/calendar

pub fn main() {
  let last_updated_instant =
    pt.Instant(
      pt.YearMonthDay(2021, calendar.April, 7),
      pt.Time(2, 57, 18, Some(pt.NanosecWithPrecision(833_000_000, Some(3)))),
      pt.Offset(pt.Minus, 4, 0),
    )
  let recorded_dt =
    pt.DateTime(
      pt.YearMonthDay(1990, calendar.June, 7),
      Some(pt.TimeAndZone(pt.Time(22, 39, 54, None), pt.Offset(pt.Plus, 0, 0))),
    )

  let original_allergy =
    resources.Allergyintolerance(
      ..resources.allergyintolerance_new(
        patient: ct.Reference(
          ..ct.reference_new(),
          reference: Some("Patient/10fe9427-a075-4d8c-8af7-1d4d24f72112"),
        ),
      ),
      id: Some("9b6a76f1-ee00-4efc-828d-ffbae3cb4220"),
      meta: Some(
        ct.Meta(
          ..ct.meta_new(),
          version_id: Some("4"),
          last_updated: Some(last_updated_instant),
          tag: [
            ct.Coding(
              ..ct.coding_new(),
              system: Some("https://smarthealthit.org/tags"),
              code: Some("synthea-5-2019"),
            ),
          ],
        ),
      ),
      clinical_status: Some(
        ct.Codeableconcept(..ct.codeableconcept_new(), coding: [
          ct.Coding(
            ..ct.coding_new(),
            system: Some(
              "http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical",
            ),
            code: Some("active"),
          ),
        ]),
      ),
      verification_status: Some(
        ct.Codeableconcept(..ct.codeableconcept_new(), coding: [
          ct.Coding(
            ..ct.coding_new(),
            system: Some(
              "http://terminology.hl7.org/CodeSystem/allergyintolerance-verification",
            ),
            code: Some("confirmed"),
          ),
        ]),
      ),
      type_: Some(valuesets.AllergyintolerancetypeAllergy),
      category: [valuesets.AllergyintolerancecategoryFood],
      criticality: Some(valuesets.AllergyintolerancecriticalityLow),
      code: Some(
        ct.Codeableconcept(
          ..ct.codeableconcept_new(),
          coding: [
            ct.Coding(
              ..ct.coding_new(),
              system: Some("http://snomed.info/sct"),
              code: Some("300913006"),
              display: Some("Shellfish allergy"),
            ),
          ],
          text: Some("Shellfish allergy"),
        ),
      ),
      recorded_date: Some(recorded_dt),
    )

  // encode and decode example

  let shellfish_allergy_json =
    resources.allergyintolerance_to_json(original_allergy)
  let assert Ok(parsed) =
    shellfish_allergy_json
    |> json.to_string
    |> json.parse(resources.allergyintolerance_decoder())
  assert parsed == original_allergy

  // decoding examples

  let assert Error(json.UnableToDecode([
    decode.DecodeError("Field", "Nothing", ["patient"]),
  ])) =
    json_example
    |> string.replace(
      "\"patient\"           : {\"reference\": \"Patient/10fe9427-a075-4d8c-8af7-1d4d24f72112\"},",
      "",
    )
    |> json.parse(resources.allergyintolerance_decoder())

  let assert Error(json.UnableToDecode([
    decode.DecodeError(
      "Allergyintolerancecriticality",
      "String",
      ["criticality"],
    ),
  ])) =
    json_example
    |> string.replace("\"low\"", "\"super-serious\"")
    |> json.parse(resources.allergyintolerance_decoder())

  let assert Error(json.UnableToDecode([
    decode.DecodeError("String", "Int", ["id"]),
  ])) =
    json_example
    |> string.replace("\"9b6a76f1-ee00-4efc-828d-ffbae3cb4220\"", "123")
    |> json.parse(resources.allergyintolerance_decoder())

  let assert Ok(shellfish_allergy) =
    json_example |> json.parse(resources.allergyintolerance_decoder())
  assert shellfish_allergy.id == Some("9b6a76f1-ee00-4efc-828d-ffbae3cb4220")

  // decode could be any resource example

  let assert Ok(resources.ResourceAllergyintolerance(shellfish_allergy)) =
    json_example |> json.parse(resources.resource_decoder())
  assert shellfish_allergy.criticality
    == Some(valuesets.AllergyintolerancecriticalityLow)
}

const json_example = "
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
