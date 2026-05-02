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
          given: ["Samuel"],
          family: Some("Vimes"),
        ),
      ],
      contact: [
        resources.PatientContact(
          ..resources.patient_contact_new(),
          relationship: [
            ct.Codeableconcept(..ct.codeableconcept_new(), coding: [
              ct.Coding(
                ..ct.coding_new(),
                system: Some("http://terminology.hl7.org/CodeSystem/v2-0131"),
                code: Some("N"),
              ),
            ]),
          ],
          name: Some(
            ct.Humanname(
              ..ct.humanname_new(),
              given: ["Sybil"],
              family: Some("Ramkin"),
            ),
          ),
          telecom: [
            ct.Contactpoint(
              ..ct.contactpoint_new(),
              system: Some(valuesets.ContactpointsystemPhone),
              value: Some("555-0100"),
              use_: Some(valuesets.ContactpointuseHome),
            ),
          ],
          gender: Some(valuesets.AdministrativegenderFemale),
        ),
      ],
    )
  echo pat
}
