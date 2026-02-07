import fhir/r4_sansio

pub fn main() {
  let assert Ok(_) = r4_sansio.fhirclient_new("r4.smarthealthit.org/")
  let assert Ok(_) = r4_sansio.fhirclient_new("https://r4.smarthealthit.org/")
  let assert Ok(_) = r4_sansio.fhirclient_new("https://hapi.fhir.org/baseR4")
  let assert Ok(_) = r4_sansio.fhirclient_new("127.0.0.1:8000")
}
