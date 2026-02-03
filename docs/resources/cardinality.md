# Cardinality

[https://build.fhir.org/conformance-rules.html#cardinality](Cardinality) refers to how many of an element there can or must be.

| Cardinality | Definition | Gleam |
|------------|--------|-------------|
| `1..1` | One mandatory element | `x` |
| `0..1` | One optional element | `Option(x)` |
| `0..*` | Any number of elements | `List(x)` |
| `1..*` | Any >0 number of elements | `List(x)` |

Gleam's type system enforces that a `1..1` element must exist, so attempting to decode a JSON that does not have a `1..1` element will fail. Note this is not true for `1..*`, although in practice `1..1`, `0..1`, and `0..*` elements are far more common.

For example, a patient may have multiple Communication backbone elements, so the communication field in r4.Patient is a `List(PatientCommunication)`.

![PatientCommunication](https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/PatientCommunication.png)

```gleam
pub type Patient {
  Patient(
    ...
    communication: List(PatientCommunication),
    ...
  )
}
```

A communication may optionally (but is not required to) have a preferred element if the patient prefers that language, so the `preferred` field in r4.PatientCommunication is wrapped in an `Option`. Whereas a communication must have exactly one language, so the `language` field is not in an `Option`.

```gleam
pub type PatientCommunication {
  PatientCommunication(
    ...
    language: Codeableconcept,
    preferred: Option(Bool),
  )
}
```
