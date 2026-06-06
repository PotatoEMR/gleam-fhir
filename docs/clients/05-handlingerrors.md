# Handling Errors

Attempting to get a resource from a FHIR server over http has a number of possible results, including but definitely not limited to `Ok`. Generally there are 2 kinds of errors:
- from sansio, for problems parsing FHIR resources eg json decode error
- specific to http client, for problems on http layer eg can't connect to url

Note FHIR servers will return an OperationOutcome resource with details for an error, such as trying to read a patient that does not exist on the server, so `ErrOperationoutcome` is a sansio error variant. A mostly valid FHIR JSON that fails to decode will return the JSON decode error(s), such as missing `1..1` AllergyIntolerance.patient element. Other server errors such as nginx internal server error will return the whole http response including http status, headers, and body string.

Many of the ways an operation can fail probably don't matter, but they're all there if needed, and it probably is worth handling the `OperationOutcome` case.

```gleam
import fhir/r4/client_httpc
import fhir/r4/sansio
import gleam/dynamic/decode
import gleam/io
import gleam/json
import gleam/list
import gleam/option.{None, Some}
import gleam/string

pub fn main() {
  let assert Ok(client) = sansio.fhirclient_new("https://r4.smarthealthit.org/")
  let pat =
    client_httpc.patient_read("87a339d0-8cae-418e-89c7-8651e6aab3c6", client)
  io.println(case pat {
    Ok(pat) -> {
      case pat.id {
        Some(id) -> "happy path! id is " <> id
        None -> panic as "server should always set patient id"
      }
    }
    Error(err) ->
      case err {
        client_httpc.ErrHttpc(_err) ->
          "httpc client couldn't connect to the server, maybe fhir client baseurl is wrong"
        client_httpc.ErrSansio(err) ->
          case err {
            client_httpc.ErrServer(err) ->
              "server responded but not with the json we asked for, instead got "
              <> err.body
            client_httpc.ErrOperationoutcome(err) ->
              "server sent an OperationOutcome "
              <> err.issue.first.diagnostics
              |> option.unwrap(" without diagnostics")
            client_httpc.ErrNoId ->
              panic as "only update/delete should hit this as it comes from calling fn with a resource"
            client_httpc.ErrParseJson(err) ->
              case err {
                json.UnableToDecode(errors) ->
                  "error parsing json from server: "
                  <> list.map(errors, fn(error) {
                    let decode.DecodeError(expected:, found:, path:) = error
                    "expected "
                    <> expected
                    <> " but found "
                    <> found
                    <> " at "
                    <> string.join(path, "/")
                  })
                  |> string.join(";")
                _ -> "server sent bad json"
              }
          }
      }
  })
}
```
