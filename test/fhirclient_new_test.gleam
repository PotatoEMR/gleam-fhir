import fhir/r4/sansio

pub fn fhirclient_new_test() {
  let assert Ok(_) = sansio.fhirclient_new("r4.smarthealthit.org/")
  let assert Ok(_) = sansio.fhirclient_new("https://r4.smarthealthit.org/")
  let assert Ok(_) = sansio.fhirclient_new("https://hapi.fhir.org/baseR4")
  let assert Ok(_) = sansio.fhirclient_new("127.0.0.1:8000")
}
