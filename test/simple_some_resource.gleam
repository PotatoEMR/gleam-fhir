import gleam/json
import gleam/option.{Some}
import gleam/string

import fhir/r4 as fhirversion
import fhir/r4valuesets as fhirversionvaluesets

pub fn some_resource_test() {
  let myallergy =
    fhirversion.Allergyintolerance(
      ..fhirversion.allergyintolerance_new(patient: fhirversion.reference_new()),
      id: Some("abc"),
      criticality: Some(fhirversionvaluesets.AllergyintolerancecriticalityHigh),
      code: Some(
        fhirversion.Codeableconcept(
          ..fhirversion.codeableconcept_new(),
          coding: [
            fhirversion.Coding(
              ..fhirversion.coding_new(),
              system: Some("http://snomed.info/sct"),
              code: Some("91930004"),
              display: Some("Allergy to eggs"),
            ),
          ],
        ),
      ),
      onset: Some(fhirversion.AllergyintoleranceOnsetAge(
        fhirversion.Age(
          ..fhirversion.age_new(),
          value: Some(4.0),
          unit: Some("year"),
          system: Some("http://unitsofmeasure.org"),
        ),
      )),
      reaction: [
        fhirversion.AllergyintoleranceReaction(
          ..fhirversion.allergyintolerance_reaction_new(),
          manifestation: [
            fhirversion.Codeableconcept(
              ..fhirversion.codeableconcept_new(),
              coding: [
                fhirversion.Coding(
                  ..fhirversion.coding_new(),
                  system: Some("http://snomed.info/sct"),
                  code: Some("247472004"),
                  display: Some("Hives"),
                ),
              ],
            ),
          ],
        ),
      ],
    )
  let json =
    myallergy |> fhirversion.allergyintolerance_to_json() |> json.to_string()
  let assert Ok(parse_resource) =
    json |> json.parse(fhirversion.resource_decoder())
  let assert fhirversion.ResourceAllergyintolerance(parsed_allergy) =
    parse_resource
  assert parsed_allergy.id == myallergy.id
  let assert Some(fhirversion.AllergyintoleranceOnsetAge(onset)) =
    parsed_allergy.onset
  assert onset.value == Some(4.0)
  let assert [reaction] = parsed_allergy.reaction
  let assert [manifestation] = reaction.manifestation
  let assert [coding] = manifestation.coding
  assert coding.system == Some("http://snomed.info/sct")
  assert coding.code == Some("247472004")
  //last assert catches everything but already wrote previous asserts plus they give more granular print if fail
  assert parsed_allergy == myallergy
  let bad_json =
    json |> string.replace("\"resourceType\":\"AllergyIntolerance\",", "")
  let assert Error(_) = bad_json |> json.parse(fhirversion.resource_decoder())
  let bad_json2 =
    json
    |> string.replace(
      "\"resourceType\":\"AllergyIntolerance\",",
      "\"resourceType\":\"xdd\",",
    )
  let assert Error(_) = bad_json2 |> json.parse(fhirversion.resource_decoder())
  let bad_json3 =
    json
    |> string.replace(
      "\"resourceType\":\"AllergyIntolerance\",",
      "\"resourceType\":\"Immunization\",",
    )
  let assert Error(_) = bad_json3 |> json.parse(fhirversion.resource_decoder())
}
