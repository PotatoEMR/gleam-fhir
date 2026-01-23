import fhir/r4
import fhir/r4_rsvp
import gleam/option.{Some}

pub fn main() {
  patient_test()
}

fn patient_test() {
  let fc = r4_rsvp.fhirclient_new("https://hapi.fhir.org/baseR4")

  let patient = r4.Patient(..r4.patient_new(), active: Some(True))

  echo "hi"
  // use create_result <- r4_rsvp.patient_create(patient, fc)
  // let assert Ok(created) = create_result
  // echo created.id
}
