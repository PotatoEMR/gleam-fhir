# httpc

[r4_httpc](https://hexdocs.pm/fhir/fhir/r4_httpc.html) makes requests using httpc, and is the easiest client to use.

```gleam
import fhir/r4_httpc

pub fn main() {
  let client = r4_httpc.fhirclient_new("https://r4.smarthealthit.org/")
  let assert Ok(pat) =
    r4_httpc.patient_read("87a339d0-8cae-418e-89c7-8651e6aab3c6", client)
  echo pat
}
```
