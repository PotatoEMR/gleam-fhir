import fhir/r4/complex_types as ct
import fhir/r4/resources
import fhir/r4/valuesets

import gleam/json
import gleam/option.{Some}
import gleam/string

pub fn some_resource_test() {
  let myallergy =
    resources.Allergyintolerance(
      ..resources.allergyintolerance_new(patient: ct.reference_new()),
      id: Some("abc"),
      criticality: Some(valuesets.AllergyintolerancecriticalityHigh),
      code: Some(
        ct.Codeableconcept(..ct.codeableconcept_new(), coding: [
          ct.Coding(
            ..ct.coding_new(),
            system: Some("http://snomed.info/sct"),
            code: Some("91930004"),
            display: Some("Allergy to eggs"),
          ),
        ]),
      ),
      onset: Some(resources.AllergyintoleranceOnsetAge(
        ct.Age(
          ..ct.age_new(),
          value: Some(4.0),
          unit: Some("year"),
          system: Some("http://unitsofmeasure.org"),
        ),
      )),
      reaction: [
        resources.allergyintolerance_reaction_new(
          manifestation: ct.List1(
            ct.Codeableconcept(..ct.codeableconcept_new(), coding: [
              ct.Coding(
                ..ct.coding_new(),
                system: Some("http://snomed.info/sct"),
                code: Some("247472004"),
                display: Some("Hives"),
              ),
            ]),
            [],
          ),
        ),
      ],
    )
  let json =
    myallergy |> resources.allergyintolerance_to_json() |> json.to_string()
  let assert Ok(parse_resource) =
    json |> json.parse(resources.resource_decoder())
  let assert resources.ResourceAllergyintolerance(parsed_allergy) =
    parse_resource
  assert parsed_allergy.id == myallergy.id
  let assert Some(resources.AllergyintoleranceOnsetAge(onset)) =
    parsed_allergy.onset
  assert onset.value == Some(4.0)
  let assert [reaction] = parsed_allergy.reaction
  let ct.List1(manifestation, _) = reaction.manifestation
  let assert [coding] = manifestation.coding
  assert coding.system == Some("http://snomed.info/sct")
  assert coding.code == Some("247472004")
  //last assert catches everything but already wrote previous asserts plus they give more granular print if fail
  assert parsed_allergy == myallergy
  let bad_json =
    json |> string.replace("\"resourceType\":\"AllergyIntolerance\",", "")
  let assert Error(_) = bad_json |> json.parse(resources.resource_decoder())
  let bad_json2 =
    json
    |> string.replace(
      "\"resourceType\":\"AllergyIntolerance\",",
      "\"resourceType\":\"xdd\",",
    )
  let assert Error(_) = bad_json2 |> json.parse(resources.resource_decoder())
  let bad_json3 =
    json
    |> string.replace(
      "\"resourceType\":\"AllergyIntolerance\",",
      "\"resourceType\":\"Immunization\",",
    )
  let assert Error(_) = bad_json3 |> json.parse(resources.resource_decoder())
}
