# sans-io

To send using some other http client, use [r4_sansio](https://hexdocs.pm/fhir/fhir/r4_sansio.html) to create a `Request(String)` and parse the `Response(String)`.

```gleam
import fhir/r4_sansio
import gleam/httpc

pub fn main() {
  let client = r4_sansio.fhirclient_new("https://r4.smarthealthit.org/")
  let pat_req =
    r4_sansio.patient_read_req("87a339d0-8cae-418e-89c7-8651e6aab3c6", client)
  let assert Ok(pat_resp) = httpc.send(pat_req)
  let assert Ok(pat) = r4_sansio.patient_resp(pat_resp)
  echo pat
}
```

todo maybe fetch
