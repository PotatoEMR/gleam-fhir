# code

[code](https://hl7.org/fhir/R4/datatypes.html#code) elements must be [one of a set of strings](https://hl7.org/fhir/R4/terminologies.html). The string itself is the *code* and the set it comes from is the *system* which is needed to disambiguate in case the same string is a code in two different systems. For example the code "M" means Male in [https://terminology.hl7.org/7.3.0/en/CodeSystem-v2-0001.html](https://terminology.hl7.org/7.3.0/en/CodeSystem-v2-0001.html) but the same code "M" means Married in [https://terminology.hl7.org/7.3.0/en/CodeSystem-v3-MaritalStatus.html](https://terminology.hl7.org/7.3.0/en/CodeSystem-v3-MaritalStatus.html).

Resource code elements are bound to a valueset, i.e. a set of codes that the code field must be one of. For some code elements users can choose which valueset to take codes from, but for others code elements FHIR requires a certain valueset. For example, Patient.gender requires [AdministrativeGender](https://hl7.org/fhir/R4/valueset-administrative-gender.html). In Gleam, code elements with a required binding use an enum from `fhir/r4/valuesets`).

![Patient.gender](https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/PatientGender.png)

Required valueset bindings simplify interoperability and are easy to work with in Gleam as they are simple enums, rather than `String`.

[Coding](https://fhir.hexdocs.pm/resources/coding.html) allows specifying system and display along with code.

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
