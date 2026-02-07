# Handling Errors

Attempting to get a resource from a FHIR server over http has a number of possible results, including but definitely not limited to `Ok`. Generally there are 2 kinds of errors:
- from sansio, for problems parsing FHIR resources eg json decode error
- from http client, for problems on http layer eg can't connect to url

Note FHIR servers will return an `OperationOutcome` resource with details for an error, so `OperationOutcome` is a sansio error variant. For instance you can get an `OperationOutcome` by trying to read a patient with an id that does not exist on the server. Many of the ways an operation can fail probably don't matter, but they're all there if needed, and it probably is worth handling the `OperationOutcome` case.

```gleam
pub fn main() {
  let assert Ok(client) = r4_httpc.fhirclient_new("https://r4.smarthealthit.org/")
  let pat = r4_httpc.patient_read("87a339d0-8cae-418e-89c7-8651e6aab3c6", client)
  io.println(case pat {
    Ok(pat) -> {
      case pat.id {
        Some(id) -> "happy path! id is " <> id
        None -> panic as "server should always set patient id"
      }
    }
    Error(err) ->
      case err {
        r4_httpc.ErrHttpc(err) ->
          case err {
            httpc.InvalidUtf8Response -> "InvalidUtf8Response"
            httpc.FailedToConnect(ip4:, ip6:) ->
              "failed to connect: ip4 " <> ip4.code <> ", ip6 " <> ip6.code
            httpc.ResponseTimeout -> "Timeout"
          }
        r4_httpc.ErrSansio(err) ->
          case err {
            r4_sansio.ErrOperationcome(err) ->
              "OperationOutcome: "
              <> list.map(err.issue, fn(issue) {
                case issue.diagnostics {
                  Some(err) -> err
                  None -> "issue without diagnostics"
                }
                <> string.join(issue.expression, "at ")
                <> string.join(issue.location, "at ")
              })
              |> string.join("\n")
            r4_sansio.ErrNotJson(err) -> "not json: " <> err.body
            r4_sansio.ErrNoId ->
              panic as "only update/delete should hit this as it comes from calling fn with a resource"
            r4_sansio.ErrParseJson(err) ->
              case err {
                json.UnexpectedEndOfInput -> "UnexpectedEndOfInput"
                json.UnexpectedByte(err) -> "UnexpectedByte " <> err
                json.UnexpectedSequence(err) -> "UnexpectedSequence " <> err
                json.UnableToDecode(errors) ->
                  "UnableToDecode "
                  <> list.map(errors, fn(error) {
                    let decode.DecodeError(expected:, found:, path:) = error
                    "expected "
                    <> expected
                    <> " found "
                    <> found
                    <> " at "
                    <> string.join(path, "/")
                  })
                  |> string.join("\n")
              }
          }
      }
  })
}
```
