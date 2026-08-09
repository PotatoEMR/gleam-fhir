# Coding

[Coding](https://hl7.org/fhir/R4/datatypes.html#Coding) contains both a code element and system element, which is a uri identifying the set that the code comes from. The display element provides a nicer string to show humans. 

In Gleam, both Coding.system and Coding.code are type `String`, meaning the compiler does not enforce that a code is valid in some system. A Coding is bound to a valueset, ie set of code+system.

When the binding strength is required, meaning the user cannot choose to use a different valueset, Gleam represents this with the generic type `complex_types.BoundCoding(required_binding)`, where required_binding is the bound valueset. In that case the `code` field comes from the `required_binding` type, and the valueset `[type]_get_code` and `[type]_system` convert the enum to strings for its code and system.

When the binding strength is weaker, codings will be type `complex_types.Coding` which leaves code and system as `String` fields.

Coding will often be part of a list in a [CodeableConcept](https://fhir.hexdocs.pm/resources/codeableconcept.html), which allows multiple codes in different systems to represent the same thing.

```gleam
import fhir/r4/complex_types as ct
import fhir/r4/valuesets
import gleam/option.{Some}

pub fn main() {
  let terrible_news =
    ct.Coding(
      ..ct.coding_new(),
      system: Some("http://snomed.info/sct"),
      code: Some("267425008"),
      display: Some("Lactose intolerance"),
    )
  echo terrible_news
  let another_way_to_put_it =
    ct.Coding(
      ..ct.coding_new(),
      system: Some("http://hl7.org/fhir/sid/icd-10-cm"),
      code: Some("E73.9"),
    )
  echo another_way_to_put_it

  let allergy_active: ct.BoundCoding(valuesets.Allergyintoleranceclinical) =
    ct.bound_coding_new(valuesets.AllergyintoleranceclinicalActive)
  echo allergy_active.code
  echo valuesets.allergyintoleranceclinical_to_code(allergy_active.code)
  echo valuesets.allergyintoleranceclinical_system(allergy_active.code)

  let assert Ok(inactive_code) =
    valuesets.allergyintoleranceclinical_from_code_and_system(
      code: "inactive",
      system: "http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical",
    )
  let allergy_inactive = ct.bound_coding_new(inactive_code)
  echo allergy_inactive.code
}
```
