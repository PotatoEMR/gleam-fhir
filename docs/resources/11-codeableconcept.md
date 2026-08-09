# Codeable Concept

There are many different systems of codes for healthcare data, with many overlapping concepts. Hypothetically,
- system http://snomed.info/sct has code "260385009" meaning negative
- system https://acme.lab/resultcodes has code "NEG" meaning negative

Both mean negative, so we want a way to represent that single concept in multiple systems.

[CodeableConcept](https://hl7.org/fhir/R4/datatypes.html#CodeableConcept) represents one concept with multiple Codings, for when different systems have different codes for the same concept. CodeableConcept also has an optional string element for the text the user selected. In Gleam, CodeableConcept.coding is type `List(Coding)` and CodeableConcept.text is type `Option(String)`.

For example, AllergyIntolerance.code can identify lactose intolerance in both SNOMED and ICD-10. As opposed to the previous example with two separate Codings, this example puts the two Codings in one single CodeableConcept, meaning they both represent the same lactose intolerance in SNOMED and ICD-10.

When a CodeableConcept is bound to valueset with strength required, one of the list of codings must come from the valueset. In Gleam, `BoundCodeableconcept(required_binding)` represents this with two fields:
- `required: required_binding` which is a coding from the required valueset
- `more: List(Coding)` which can be any codings that represent the same concept.

```gleam
import fhir/r4/complex_types as ct
import fhir/r4/valuesets

import gleam/option.{None, Some}

pub fn main() {
  let terrible_news =
    ct.Codeableconcept(
      id: None,
      extension: [],
      coding: [
        ct.Coding(
          ..ct.coding_new(),
          system: Some("http://snomed.info/sct"),
          code: Some("267425008"),
          display: Some("Lactose intolerance"),
        ),
        ct.Coding(
          ..ct.coding_new(),
          system: Some("http://hl7.org/fhir/sid/icd-10-cm"),
          code: Some("E73.9"),
        ),
      ],
      text: Some("Lactose intolerance"),
    )
  echo terrible_news

  let allergy_active: ct.BoundCodeableconcept(
    valuesets.Allergyintoleranceclinical,
  ) = ct.bound_codeableconcept_new(valuesets.AllergyintoleranceclinicalActive)
  echo allergy_active.required.code
  echo valuesets.allergyintoleranceclinical_system(allergy_active.required.code)

  let other_coding_1 = ct.Coding(..ct.coding_new(), code: Some("current"), system: Some("my-made-up-system-1"))
  let other_coding_2 = ct.Coding(..ct.coding_new(), code: Some("in-progress"), system: Some("my-made-up-system-2"))
  let allergy_active = ct.BoundCodeableconcept(..allergy_active, more: [other_coding_1, other_coding_2])
  echo allergy_active
}
```
