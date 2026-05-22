# sans-io

To send using any http client, use `fhir/r4/sansio` to create a `Request(Option(Json))` and parse the `Response(String)`.

http clients typically take a `Request(String)`, but fhir sansio keeps request body as JSON to more easily combine multiple requests into a batch.

```gleam
import fhir/r4/resources
import fhir/r4/sansio
import gleam/fetch
import gleam/http/request
import gleam/javascript/promise
import gleam/json
import gleam/option.{None, Some}

pub fn main() {
  let assert Ok(client) = sansio.fhirclient_new("https://r4.smarthealthit.org/")
  let pat_req =
    sansio.any_read_req(
      "87a339d0-8cae-418e-89c7-8651e6aab3c6",
      resources.RtPatient,
      client,
    )
  // sansio returns Request(Option(Json)), fetch wants Request(String)
  let pat_req_str =
    pat_req
    |> request.set_body(case pat_req.body {
      Some(body) -> json.to_string(body)
      None -> ""
    })
  use pat_resp <- promise.try_await(fetch.send(pat_req_str))
  use pat_resp_body <- promise.try_await(fetch.read_text_body(pat_resp))
  let assert Ok(pat) =
    sansio.any_resp(
      pat_resp_body,
      resources.patient_decoder(),
      resources.RtPatient,
    )
  echo pat
  promise.resolve(Ok(pat))
}
```
