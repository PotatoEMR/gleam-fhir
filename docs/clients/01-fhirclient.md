# Client

FHIR defines [REST operations](https://build.fhir.org/http.html) for interacting with a server. 

In Gleam, for r4, r4b, r5:
- [r4_httpc](https://hexdocs.pm/fhir/fhir/r4_httpc.html) for Gleam's default Erlang target
- [r4_rsvp](https://hexdocs.pm/fhir/fhir/r4_rsvp.html) for [Lustre](https://hexdocs.pm/lustre/lustre.html) apps
- [r4_sansio](https://hexdocs.pm/fhir/fhir/r4_sansio.html) to bring your own http client

On any compilation target, the first step is to create a client with the FHIR server base url.

```gleam
import fhir/r4_httpc

pub fn main() {
  //creating a client for a public FHIR server and reading a patient
  let assert Ok(client) = r4_httpc.fhirclient_new("https://r4.smarthealthit.org/")
  let assert Ok(pat) =
    r4_httpc.patient_read("87a339d0-8cae-418e-89c7-8651e6aab3c6", client)
  echo pat
}
```
