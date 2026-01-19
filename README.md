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
    r4.Allergyintolerance(
      ..r4.allergyintolerance_new(patient: r4.reference_new()),
      id: Some("abc"),
      criticality: Some(r4valuesets.AllergyintolerancecriticalityHigh),
      code: Some(
        r4.Codeableconcept(
          ..r4.codeableconcept_new(),
          coding: [
            r4.Coding(
              ..r4.coding_new(),
              system: Some("http://snomed.info/sct"),
              code: Some("91930004"),
              display: Some("Allergy to eggs"),
            ),
          ],
        ),
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
            r4.Codeableconcept(
              ..r4.codeableconcept_new(),
              coding: [
                r4.Coding(
                  ..r4.coding_new(),
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
    myallergy |> r4.allergyintolerance_to_json() |> json.to_string()
  let assert Ok(parsed_allergy) =
    json |> json.parse(r4.allergyintolerance_decoder())
  assert parsed_allergy.id == myallergy.id
}
```

<https://hexdocs.pm/fhir>

https://github.com/PotatoEMR/gleam-fhir/issues
