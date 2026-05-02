import fhir/r4/complex_types as ct
import fhir/r4/resources

import gleam/option.{Some}

pub fn main() {
  let mrn_type =
    ct.Codeableconcept(..ct.codeableconcept_new(), coding: [
      ct.Coding(
        ..ct.coding_new(),
        system: Some("http://terminology.hl7.org/CodeSystem/v2-0203"),
        code: Some("MR"),
        display: Some("Medical Record Number"),
      ),
    ])
  let ssn_type =
    ct.Codeableconcept(..ct.codeableconcept_new(), coding: [
      ct.Coding(
        ..ct.coding_new(),
        system: Some("http://terminology.hl7.org/CodeSystem/v2-0203"),
        code: Some("SS"),
        display: Some("Social Security Number"),
      ),
    ])
  let pat =
    resources.Patient(..resources.patient_new(), identifier: [
      ct.Identifier(
        ..ct.identifier_new(),
        type_: Some(mrn_type),
        system: Some("http://hospital.smarthealthit.org"),
        value: Some("73a7d6b7-0310-4fff-9b0b-7891a5e390f5"),
      ),
      ct.Identifier(
        ..ct.identifier_new(),
        type_: Some(ssn_type),
        system: Some("http://hl7.org/fhir/sid/us-ssn"),
        value: Some("999-91-2751"),
      ),
    ])
  echo pat
}
