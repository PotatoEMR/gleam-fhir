import gleam/json
import gleam/option.{Some}
import gleam/string

import fhir/r4
import fhir/r4_valuesets

pub fn some_resource_test() {
  let myallergy =
    r4.Allergyintolerance(
      ..r4.allergyintolerance_new(patient: r4.reference_new()),
      id: Some("abc"),
      criticality: Some(r4_valuesets.AllergyintolerancecriticalityHigh),
      code: Some(
        r4.Codeableconcept(..r4.codeableconcept_new(), coding: [
          r4.Coding(
            ..r4.coding_new(),
            system: Some("http://snomed.info/sct"),
            code: Some("91930004"),
            display: Some("Allergy to eggs"),
          ),
        ]),
      ),
      onset: Some(r4.AllergyintoleranceOnsetAge(
        r4.Age(
          ..r4.age_new(),
          value: Some(4.0),
          unit: Some("year"),
          system: Some("http://unitsofmeasure.org"),
        ),
      )),
      reaction: [
        r4.AllergyintoleranceReaction(
          ..r4.allergyintolerance_reaction_new(),
          manifestation: [
            r4.Codeableconcept(..r4.codeableconcept_new(), coding: [
              r4.Coding(
                ..r4.coding_new(),
                system: Some("http://snomed.info/sct"),
                code: Some("247472004"),
                display: Some("Hives"),
              ),
            ]),
          ],
        ),
      ],
    )
  let json = myallergy |> r4.allergyintolerance_to_json() |> json.to_string()
  let assert Ok(parse_resource) = json |> json.parse(r4.resource_decoder())
  let assert r4.ResourceAllergyintolerance(parsed_allergy) = parse_resource
  assert parsed_allergy.id == myallergy.id
  let assert Some(r4.AllergyintoleranceOnsetAge(onset)) = parsed_allergy.onset
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
  let assert Error(_) = bad_json |> json.parse(r4.resource_decoder())
  let bad_json2 =
    json
    |> string.replace(
      "\"resourceType\":\"AllergyIntolerance\",",
      "\"resourceType\":\"xdd\",",
    )
  let assert Error(_) = bad_json2 |> json.parse(r4.resource_decoder())
  let bad_json3 =
    json
    |> string.replace(
      "\"resourceType\":\"AllergyIntolerance\",",
      "\"resourceType\":\"Immunization\",",
    )
  let assert Error(_) = bad_json3 |> json.parse(r4.resource_decoder())
}
