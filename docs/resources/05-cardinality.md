# Cardinality

[https://build.fhir.org/conformance-rules.html#cardinality](Cardinality) refers to how many of an element there can or must be.

| Cardinality | Definition | Gleam |
|------------|--------|-------------|
| `1..1` | One mandatory element | `x` |
| `0..1` | One optional element | `Option(x)` |
| `0..*` | Any number of elements | `List(x)` |
| `1..*` | Any >0 number of elements | `List1(x)` |

Gleam's type system enforces that a `1..1` element must exist, so attempting to decode a JSON that does not have a `1..1` element will fail. `1..1`, `0..1`, and `0..*` elements are most common. `1..*` uses a custom type with a required first element and a list of the rest.

For example, a patient may have multiple Communication backbone elements, so the communication field in `resources.Patient` is a `List(PatientCommunication)`.

![PatientCommunication](https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/PatientCommunication.png)

A communication may optionally (but is not required to) have a preferred element if the patient prefers that language, so the `preferred` field in `resources.PatientCommunication` is wrapped in an `Option`. Whereas a communication must have exactly one language, so the `language` field is not in an `Option`. So `patient_communication_new` function requires a `language` because a patient communication needs a language to exist, whereas patient communication without preference makes sense so `preferred` is not an argument in `patient_communication_new`.

```gleam
import fhir/r4/complex_types as ct
import fhir/r4/resources

import gleam/option.{Some}

pub fn main() {
  let pat =
    resources.Patient(..resources.patient_new(), communication: [
      resources.PatientCommunication(
        ..resources.patient_communication_new(
          language: ct.Codeableconcept(..ct.codeableconcept_new(), coding: [
            ct.Coding(
              ..ct.coding_new(),
              system: Some("urn:ietf:bcp:47"),
              code: Some("en"),
              display: Some("English"),
            ),
          ]),
        ),
        preferred: Some(True),
      ),
      resources.patient_communication_new(
        language: ct.Codeableconcept(..ct.codeableconcept_new(), coding: [
          ct.Coding(
            ..ct.coding_new(),
            system: Some("urn:ietf:bcp:47"),
            code: Some("es"),
            display: Some("Spanish"),
          ),
        ]),
      ),
    ])
  echo pat
}
```
