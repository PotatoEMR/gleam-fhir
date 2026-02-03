# codeablereference

[CodeableReference](https://build.fhir.org/references.html#codeablereference) exists only in R5; it does *not* exist in R4/R4B. 

>A common pattern in healthcare records is that a single element may refer to either a concept in principle, or a specific instance of the concept as seen in practice.

CodeableReference has both CodeableConcept and Reference, so it can refer to a general concept or a specific resource. For example, AllergyIntolerance.reaction.manifestation can have
- code "2070002" in the SNOMED CT clinical finding valueset, representing the general concept of burning sensation in eye
- Reference to an Observation resource, recording a specific instance of when someone had a burning sensation in their eye

![Manifestation](https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/Manifestation.JPG)

```gleam
let manifestation_1 =
  r5.Codeablereference(
    id: None,
    extension: [],
    concept: None,
    reference: Some(r5.Reference(
      id: None,
      extension: [],
      reference: Some("Observation/123"),
      type_: None,
      identifier: None,
      display: None,
    )),
  )

let manifestation_2 =
  r5.Codeablereference(
    id: None,
    extension: [],
    concept: Some(r5.Codeableconcept(
      id: None,
      extension: [],
      coding: [
        r5.Coding(
          id: None,
          extension: [],
          system: Some("http://snomed.info/sct"),
          version: None,
          code: Some("310008"),
          display: None,
          user_selected: None,
        ),
      ],
      text: None,
    )),
    reference: None,
  )
```

To recap, [code](https://hl7.org/fhir/R4/datatypes.html#code) comes from a set of values. [Coding](https://hl7.org/fhir/R4/datatypes.html#Coding) has code plus system the code comes from. [CodeableConcept](https://hl7.org/fhir/R4/datatypes.html#CodeableConcept) represents a concept in different systems using Coding list. [CodeableReference](https://build.fhir.org/references.html#codeablereference) can have a CodeableConcept with a general concept, or a Reference with a specific instance.
