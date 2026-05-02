# code

[code](https://hl7.org/fhir/R4/datatypes.html#code) elements must be [one of a set of strings](https://hl7.org/fhir/R4/terminologies.html)

Many code elements require using a specific ValueSet to draw from. For example, Patient.gender requires [AdministrativeGender](https://hl7.org/fhir/R4/valueset-administrative-gender.html). In Gleam, code elements with a required binding use an enum from `fhir/r4/valuesets`).

![Patient.gender](https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/PatientGender.png)

Other code elements do not have a required binding to a specific ValueSet. In Gleam these have no enum, and are defined as `String`.

Having stronger and weaker bindings lets FHIR keep interoperability simple and some elements and meet flexible terminology requirements for others. Required bindings to a specific valueset make it possible for code to use an enum, which makes them simpler and safer to work with in Gleam. Coding code elements are more powerful in that they can use any system of codes, and in Gleam are a `String` that should be one of the codes defined in the Coding's system.

```gleam
import fhir/r4/resources
import fhir/r4/valuesets

import gleam/option.{Some}

pub fn main() {
  let pat =
    resources.Patient(
      ..resources.patient_new(),
      gender: Some(valuesets.AdministrativegenderMale),
    )
  echo pat.gender
}
```
