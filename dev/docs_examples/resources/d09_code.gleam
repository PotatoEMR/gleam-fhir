import fhir/r4/resources
import fhir/r4/valuesets

import gleam/option.{Some}

pub fn main() {
  let pat =
    resources.Patient(
      ..resources.patient_new(),
      gender: Some(valuesets.AdministrativegenderMale),
    )
  echo pat.gender
}
