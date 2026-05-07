# Client

FHIR defines [REST operations](https://build.fhir.org/http.html) for interacting with a server. 

In Gleam, use [fhir_client_httpc](https://hexdocs.pm/fhir_client_httpc/), [fhir_client_rsvp](https://hexdocs.pm/fhir_client_rsvp/index.html), or create requests with sansio and send them with another client.

`fhir/r4/sansio` creates requests and parses response, but does not actually send http requests. Different targets require different http clients, so the sansio package leaves handling the http request to whatever http client. `fhir/r4/client_httpc` uses sansio to create and send requests on Gleam's default Erlang target using httpc, and `fhir/r4/client_rsvp` uses sansio to create and send requests in Lustre apps using rsvp. Any Gleam http client that takes a request and returns a response can also be used with sansio, which takes a bit more effort than the premade client libraries using httpc or rsvp, but allows for any particular http handling needs.

On any compilation target, the first step is to create a client with the FHIR server base url.

```gleam
// most examples use httpc as it's the easiest to start with
import fhir/r4/client_httpc

pub fn main() {
  let assert Ok(client) =
    client_httpc.fhirclient_new("https://r4.smarthealthit.org/")
  let assert Ok(pat) =
    client_httpc.patient_read("87a339d0-8cae-418e-89c7-8651e6aab3c6", client)
  echo pat
}
```
