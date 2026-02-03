# Primitive Type

FHIR [primitive types](https://hl7.org/fhir/datatypes.html#primitive) are a single value. In Gleam, primitive types are record fields with a single value, rather than with child fields. For example, the [Patient](https://hl7.org/fhir/R4/patient.html) resource has a Patient.active boolean element, which in Gleam is a `Bool` in [r4.Patient](https://hexdocs.pm/fhir/fhir/r4.html#Patient).

![Patient.active](https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/PatientActive.JPG)

```gleam
pub type Patient {
  Patient(
    ...
    active: Option(Bool),
    ...
  )
}
```
