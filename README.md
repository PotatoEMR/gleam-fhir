# fhir

[![Package Version](https://img.shields.io/hexpm/v/fhir)](https://hex.pm/packages/fhir)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/fhir/)

```sh
gleam add fhir
```
```gleam
import fhir

pub fn main() {
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
  let assert Ok(parsed_allergy) =
    json |> json.parse(fhirversion.allergyintolerance_decoder())
  assert parsed_allergy.id == myallergy.id
}
```

<https://hexdocs.pm/fhir>

https://github.com/PotatoEMR/gleam-fhir/issues
