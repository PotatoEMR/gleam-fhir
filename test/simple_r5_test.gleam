import fhir/r5/complex_types as ct
import fhir/r5/resources
import fhir/r5/valuesets

import gleam/json
import gleam/option.{Some}

pub fn r5_allergy_test() {
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
            ct.Codeablereference(
              ..ct.codeablereference_new(),
              concept: Some(
                ct.Codeableconcept(..ct.codeableconcept_new(), coding: [
                  ct.Coding(
                    ..ct.coding_new(),
                    system: Some("http://snomed.info/sct"),
                    code: Some("247472004"),
                    display: Some("Hives"),
                  ),
                ]),
              ),
            ),
            [],
          ),
        ),
      ],
    )
  let json =
    myallergy |> resources.allergyintolerance_to_json() |> json.to_string()
  let assert Ok(parsed_allergy) =
    json |> json.parse(resources.allergyintolerance_decoder())
  assert parsed_allergy.id == myallergy.id
  let assert Some(resources.AllergyintoleranceOnsetAge(onset)) =
    parsed_allergy.onset
  assert onset.value == Some(4.0)
  let assert [reaction] = parsed_allergy.reaction
  let ct.List1(manifestation, _) = reaction.manifestation
  let assert Some(cc) = manifestation.concept
  let assert [coding] = cc.coding
  assert coding.system == Some("http://snomed.info/sct")
  assert coding.code == Some("247472004")
  //last assert catches everything but already wrote previous asserts plus they give more granular print if fail
  assert parsed_allergy == myallergy
}
