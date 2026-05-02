# httpc 

`fhir/r4/client_httpc` makes requests using httpc, and is the easiest client to use. 

```gleam
import fhir/r4/client_httpc

pub fn main() {
  let assert Ok(client) =
    client_httpc.fhirclient_new("https://r4.smarthealthit.org/")
  let assert Ok(pat) =
    client_httpc.patient_read("87a339d0-8cae-418e-89c7-8651e6aab3c6", client)
  echo pat
}
```
