# Resources

The [r4](https://hexdocs.pm/fhir/fhir/r4.html)/[r4b](https://hexdocs.pm/fhir/fhir/r4b.html)/[r5](https://hexdocs.pm/fhir/fhir/r5.html) packages provide Gleam types for FHIR [resources](https://www.hl7.org/fhir/resourcelist.html) and their elements. They also provide `[resource]_encoder()` and `[resource]_to_json()` functions for each resource, and a `[resource]_new()` that creates a new resource with `Option` fields as `None` and `List` fields as `[]`. The [r4_valuesets][r4](https://hexdocs.pm/fhir/fhir/r4_valuesets.html) (or r4b/r5) package provides enums for required valuesets.

The [Patient](https://hl7.org/fhir/R4/patient.html) resource has no required fields, so in Gleam `patient_new()` takes no arguments. By contrast, resources with elements of cardinality `1..1` require arguments as those elements cannot be `None`, for instance `allergyintolerance_new(reference_to_my_patient)` requires a reference to a patient resource (not an `r4.Patient` but an `r4.Reference`). The next pages explain everything in this example. 

```gleam
import fhir/r4
import fhir/r4_valuesets
import gleam/option.{Some}

pub fn main() {
  let pat =
    r4.Patient(
      ..r4.patient_new(),
      name: [
        r4.Humanname(
          ..r4.humanname_new(),
          given: ["Anakin"],
          family: Some("Skywalker"),
        ),
      ],
      deceased: Some(r4.PatientDeceasedBoolean(False)),
    )
  echo pat
  let pat =
    r4.Patient(..pat, deceased: Some(r4.PatientDeceasedBoolean(True)), contact: [
      r4.PatientContact(
        ..r4.patient_contact_new(),
        relationship: [
          r4.Codeableconcept(..r4.codeableconcept_new(), coding: [
            r4.Coding(
              ..r4.coding_new(),
              code: Some("N"),
              system: Some("http://terminology.hl7.org/CodeSystem/v2-0131"),
            ),
          ]),
        ],
        name: Some(
          r4.Humanname(
            ..r4.humanname_new(),
            given: ["Luke"],
            family: Some("Skywalker"),
          ),
        ),
        telecom: [
          r4.Contactpoint(
            ..r4.contactpoint_new(),
            system: Some(r4_valuesets.ContactpointsystemFax),
            value: Some("0123456789"),
            use_: Some(r4_valuesets.ContactpointuseWork),
          ),
        ],
      ),
    ])
  echo pat
}
```
