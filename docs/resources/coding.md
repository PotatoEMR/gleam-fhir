# coding

[Coding](https://hl7.org/fhir/R4/datatypes.html#Coding) contains both a code element and system element, which is a uri identifying the set that the code comes from. The display element provides a nicer string to show humans. In Gleam, both Coding.system and Coding.code are type `String`, meaning the compiler does not enforce that a code is valid in some system.

```gleam
let terrible_news =
  r4.Coding(
    ..r4.coding_new(),
    system: Some("http://snomed.info/sct"),
    code: Some("267425008"),
    display: Some("Lactose intolerance"),
  )
let another_way_to_put_it = r4.Coding(
    ..r4.coding_new(),
    system: Some("http://hl7.org/fhir/sid/icd-10-cm"),
    code: Some("E73.9"),
  ),
```
