import fhir/r4/resources
import gleam/option.{Some}

pub fn main() {
  let pat = resources.patient_new()
  let pat = resources.Patient(..pat, active: Some(False))
  echo pat.active
}
