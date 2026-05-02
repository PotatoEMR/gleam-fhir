# Resources

`fhir/r4/resources` provides Gleam types for FHIR [resources](https://www.hl7.org/fhir/resourcelist.html) and their elements. They also provide `[resource]_encoder()` and `[resource]_to_json()` functions for each resource, and a `[resource]_new()` that creates a new resource with `Option` fields as `None` and `List` fields as `[]`. `fhir/r4/valuesets` provides enums for required valuesets.

The `Patient` resource has no required fields, so in Gleam `patient_new()` takes no arguments. By contrast, resources with elements of cardinality `1..1` require arguments as those elements cannot be `None`, for instance `allergyintolerance_new(reference_to_my_patient)` requires a reference to a patient resource (not an `r4.Patient` but an `r4.Reference`). The next pages explain everything in this example. 

```gleam
import fhir/r4/complex_types as ct
import fhir/r4/resources
import fhir/r4/valuesets

import gleam/option.{Some}

pub fn main() {
  let pat =
    resources.Patient(
      ..resources.patient_new(),
      name: [
        ct.Humanname(
          ..ct.humanname_new(),
          given: ["Anakin"],
          family: Some("Skywalker"),
        ),
      ],
      deceased: Some(resources.PatientDeceasedBoolean(False)),
    )
  echo pat
  let pat =
    resources.Patient(
      ..pat,
      deceased: Some(resources.PatientDeceasedBoolean(True)),
      contact: [
        resources.PatientContact(
          ..resources.patient_contact_new(),
          relationship: [
            ct.Codeableconcept(..ct.codeableconcept_new(), coding: [
              ct.Coding(
                ..ct.coding_new(),
                code: Some("N"),
                system: Some("http://terminology.hl7.org/CodeSystem/v2-0131"),
              ),
            ]),
          ],
          name: Some(
            ct.Humanname(
              ..ct.humanname_new(),
              given: ["Luke"],
              family: Some("Skywalker"),
            ),
          ),
          telecom: [
            ct.Contactpoint(
              ..ct.contactpoint_new(),
              system: Some(valuesets.ContactpointsystemFax),
              value: Some("0123456789"),
              use_: Some(valuesets.ContactpointuseWork),
            ),
          ],
        ),
      ],
    )
  echo pat
}
```
