# Primitive Type

FHIR [primitive types](https://hl7.org/fhir/datatypes.html#primitive) are a single value. In Gleam, primitive types are record fields with a single value, rather than with child fields. For example, the `Patient` resource has a Patient.active boolean element, which in Gleam is a `Bool` in `resources.Patient`.

![Patient.active](https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/PatientActive.JPG)

```gleam
import fhir/r4/resources
import gleam/option.{Some}

pub fn main() {
  let pat = resources.patient_new()
  let pat = resources.Patient(..pat, active: Some(False))
  echo pat.active
}
```

Time is represented in valid FHIR formats with primitive types for date, dateTime, instant, and time. 

A code field can be either an enum from valuesets if the field has a required binding, or a String if not.

| Primitive Type | In Gleam |
| ------------ | ------------------------------------------ |
| base64Binary | String                                     |
| boolean      | Bool                                       |
| canonical    | String                                     |
| code         | enum if required binding, otherwise String |
| date         | fhir/primitive_types.Date                  |
| dateTime     | fhir/primitive_types.DateTime              |
| decimal      | Float                                      |
| id           | String                                     |
| instant      | fhir/primitive_types.Instant               |
| integer      | Int                                        |
| integer64    | String                                     |
| markdown     | String                                     |
| oid          | String                                     |
| string       | String                                     |
| positiveInt  | Int                                        |
| time         | fhir/primitive_types.Time                  |
| unsignedInt  | Int                                        |
| uri          | String                                     |
| url          | String                                     |
| uuid         | String                                     |
