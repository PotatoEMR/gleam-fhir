# Logging

`sansio.FhirClient` has `print_sent_requests` and `print_received_responses` which clients such as the example httpc and rsvp clients can use to log requests going out to FHIR server and/or responses coming back in from FHIR server.

```gleam
import fhir/r4/client_httpc
import fhir/r4/sansio

pub fn main() {
  let assert Ok(client) = sansio.fhirclient_new("https://r4.smarthealthit.org/")
  let client =
    sansio.FhirClient(
      ..client,
      print_sent_requests: sansio.LoggingOn,
      print_received_responses: sansio.LoggingOn,
    )
  let assert Ok(_pat) =
    client_httpc.patient_read("87a339d0-8cae-418e-89c7-8651e6aab3c6", client)
}
```
