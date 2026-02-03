# codeableconcept

There are many different systems of codes for healthcare data, with many overlapping concepts. Hypothetically,
- system http://snomed.info/sct has code "260385009" meaning negative
- system https://acme.lab/resultcodes has code "NEG" meaning negative
Both mean negative, so we want a way to represent that single concept in multiple systems.

[CodeableConcept](https://hl7.org/fhir/R4/datatypes.html#CodeableConcept) represents one concept with multiple Codings, so you can have the same concept as different codes in their respective systems. CodeableConcept also has an optional string element for the text the user selected. In Gleam, CodeableConcept.coding is type `List(Coding)` and CodeableConcept.text is type `Option(String)`.

For example, AllergyIntolerance.code can identify lactose intolerance in both SNOMED and ICD-10.

```gleam
let terrible_news =
  r4.Codeableconcept(
    id: None,
    extension: [],
    coding: [
      r4.Coding(
        ..r4.coding_new(),
        system: Some("http://snomed.info/sct"),
        code: Some("267425008"),
        display: Some("Lactose intolerance"),
      ),
      r4.Coding(
        ..r4.coding_new(),
        system: Some("http://hl7.org/fhir/sid/icd-10-cm"),
        code: Some("E73.9"),
      ),
    ],
    text: Some("Lactose intolerance"),
  )
```
