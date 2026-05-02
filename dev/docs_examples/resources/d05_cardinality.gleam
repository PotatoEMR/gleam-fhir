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
