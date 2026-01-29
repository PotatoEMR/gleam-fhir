import fhir/r4_httpc

pub fn main() {
  let fc = r4_httpc.fhirclient_new("https://r4.smarthealthit.org/")
  let assert Ok(pat) =
    r4_httpc.patient_read("2cda5aad-e409-4070-9a15-e1c35c46ed5a", fc)
}
