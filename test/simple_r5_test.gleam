import gleam/json
import gleam/option.{Some}

import fhir/r5 as fhirversion
import fhir/r5valuesets as fhirversionvaluesets

pub fn fhirversion_allergy_test() {
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
            fhirversion.Codeablereference(
              ..fhirversion.codeablereference_new(),
              concept: Some(
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
              ),
            ),
          ],
        ),
      ],
    )
  let json =
    myallergy |> fhirversion.allergyintolerance_to_json() |> json.to_string()
  let assert Ok(parsed_allergy) =
    json |> json.parse(fhirversion.allergyintolerance_decoder())
  echo parsed_allergy
  assert parsed_allergy.id == myallergy.id
  let assert Some(fhirversion.AllergyintoleranceOnsetAge(onset)) =
    parsed_allergy.onset
  assert onset.value == Some(4.0)
  let assert [reaction] = parsed_allergy.reaction
  let assert [manifestation] = reaction.manifestation
  let assert Some(cc) = manifestation.concept
  let assert [coding] = cc.coding
  assert coding.system == Some("http://snomed.info/sct")
  assert coding.code == Some("247472004")
  //last assert catches everything but already wrote previous asserts plus they give more granular print if fail
  assert parsed_allergy == myallergy
}
