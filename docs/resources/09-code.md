# code

[code](https://hl7.org/fhir/R4/datatypes.html#code) elements must be [one of a set of strings](https://hl7.org/fhir/R4/terminologies.html)

Many code elements require using a specific ValueSet to draw from. For example, Patient.gender requires [AdministrativeGender](https://hl7.org/fhir/R4/valueset-administrative-gender.html). In Gleam, code elements with a required binding use an enum from r4_valuesets (or r4b/r5).

Other code elements do not have a required binding to a specific ValueSet. In Gleam these have no enum, and are defined as `String`.

Having stronger and weaker bindings lets FHIR keep interoperability simple and practical but also stay flexible enough to meet many terminology requirements. Required bindings to a specific valueset make it possible to use a type-safe enum, which makes them easy to work with in Gleam. [Coding](#coding) code elements are more powerful in that they can use any system of codes, and in Gleam are not type-safe.

[Extension](#extension) elements similarly let FHIR keep core elements relatively simple by allowing users to define new elements. 

![Patient.gender](https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/PatientGender.png)

```gleam
//In r4.gleam
pub type Patient {
  Patient(
    ...
    gender: Option(r4_valuesets.Administrativegender),
    ...
  )
}
```

```gleam
//In r4_valuesets.gleam
pub type Administrativegender {
  AdministrativegenderMale
  AdministrativegenderFemale
  AdministrativegenderOther
  AdministrativegenderUnknown
}
```
