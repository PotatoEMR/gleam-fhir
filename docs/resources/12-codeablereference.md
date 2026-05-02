# Codeable Reference

[CodeableReference](https://build.fhir.org/references.html#codeablereference) exists only in R5; it does *not* exist in R4/R4B. The closest equivalent in R4/R4B is a choice type with either a CodeableConcept or a Reference. 

>A common pattern in healthcare records is that a single element may refer to either a concept in principle, or a specific instance of the concept as seen in practice.

CodeableReference has both CodeableConcept and Reference, so it can refer to a general concept or a specific resource. For example, AllergyIntolerance.reaction.manifestation can have
- code "2070002" in the SNOMED CT clinical finding valueset, representing the general concept of burning sensation in eye
- Reference to an Observation resource, recording a specific instance of when someone had a burning sensation in their eye

![Manifestation](https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/Manifestation.JPG)

To recap, [code](https://hl7.org/fhir/R4/datatypes.html#code) comes from a set of values. [Coding](https://hl7.org/fhir/R4/datatypes.html#Coding) has code plus system the code comes from. [CodeableConcept](https://hl7.org/fhir/R4/datatypes.html#CodeableConcept) represents a concept in different systems using Coding list. [CodeableReference](https://build.fhir.org/references.html#codeablereference) can have a CodeableConcept with a general concept, or a Reference to a specific instance.

```gleam
import fhir/r5/complex_types as ct
import gleam/option.{Some}

pub fn main() {
  let manifestation_1 =
    ct.Codeablereference(
      ..ct.codeablereference_new(),
      reference: Some(
        ct.Reference(..ct.reference_new(), reference: Some("Observation/123")),
      ),
    )
  echo manifestation_1

  let manifestation_2 =
    ct.Codeablereference(
      ..ct.codeablereference_new(),
      concept: Some(
        ct.Codeableconcept(..ct.codeableconcept_new(), coding: [
          ct.Coding(
            ..ct.coding_new(),
            system: Some("http://snomed.info/sct"),
            code: Some("310008"),
          ),
        ]),
      ),
    )
  echo manifestation_2
}
```
