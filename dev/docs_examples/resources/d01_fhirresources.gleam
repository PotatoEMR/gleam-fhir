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
