# Clients

## [FHIR Client](#client){#client}

FHIR defines [REST operations](https://build.fhir.org/http.html) for interacting with a server. In Gleam, client modules provide these CRUD operations.

(for r4, r4b, r5) For Gleam's default Erlang target, use r4_httpc; for [Lustre](https://hexdocs.pm/lustre/lustre.html) apps, use r4_rsvp; for other http clients, use r4_sansio. Examples on this page use r4_httpc unless stated otherwise.

```gleam
import fhir/r4_httpc

pub fn main() {
  //creating a client for a public FHIR server
  let client = r4_httpc.fhirclient_new("https://r4.smarthealthit.org/")
}
```

## [Client for httpc](#httpc){#httpc}

[r4_rsvp](https://hexdocs.pm/fhir/fhir/r4_rsvp.html) (or r4b/r5)

```gleam
import fhir/r4_httpc

pub fn main() {
  let client = r4_httpc.fhirclient_new("https://r4.smarthealthit.org/")
  let assert Ok(pat) =
    r4_httpc.patient_read("87a339d0-8cae-418e-89c7-8651e6aab3c6", client)
  echo pat
}
```

## [Client for rsvp](#rsvp){#rsvp}

## [sansio](#sansio){#sansio}

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

## [Handling Errors](#handlingerrors){handlingerrors}

Attempting to get a resource from a FHIR server over http has a number of possible results, including but definitely not limited to `Ok`. Generally there are 2 kinds of errors:
- from sansio, for problems parsing FHIR resources eg json decode error
- from http client, for problems on http layer eg can't connect to url

Note FHIR servers will return an `OperationOutcome` resource with details for an error, so `OperationOutcome` is a sansio error variant. For instance you can get an `OperationOutcome` by trying to read a patient with an id that does not exist on the server. Many of the ways an operation can fail probably don't matter, but they're all there if needed, and it probably is worth handling the `OperationOutcome` case.

```gleam
pub fn main() {
  let client = r4_httpc.fhirclient_new("https://r4.smarthealthit.org/")
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


## [Create](#create){#create}

[Create](https://build.fhir.org/http.html#create) - POST resource, which the server assigns an id to and creates. 

```gleam
  let pat =
    r4.Patient(..r4.patient_new(), name: [
      r4.Humanname(..r4.humanname_new(), given: ["Joe"]),
    ])
  let assert Ok(created) = r4_httpc.patient_create(pat, client)
  echo created
```

## [Read](#read){#read}

[Read](https://build.fhir.org/http.html#read) - GET resource by id.  

```gleam
  let assert Ok(pat) =
    r4_httpc.patient_read("87a339d0-8cae-418e-89c7-8651e6aab3c6", client)
  echo pat
```

## [Update](#update){#update}

[Update](https://build.fhir.org/http.html#update) - PUT resource, updating resource on server to sent resource (by id, which is required in sent resource). If server allows client defined ids, update can be used to create a new resource on server at specific id, rather than id assigned by server.

```gleam
  let pat =
    r4.Patient(..r4.patient_new(), id: Some("73180176"), name: [
      r4.Humanname(..r4.humanname_new(), given: ["Mike"]),
    ])
  let assert Ok(updated) = r4_httpc.patient_update(pat, client)
  echo updated
```

## [Delete](#delete){#delete}

[Delete](https://build.fhir.org/http.html#delete) - DELETE resource, deleting resource on server (by id, which is required in sent resource). Delete will return an `Ok(OperationOutcome)` on success, no matter what type of resource is deleted.

```gleam
  let pat =
    r4.Patient(..r4.patient_new(), id: Some("73365109"), name: [
      r4.Humanname(..r4.humanname_new(), given: ["Mike"]),
    ])
  let assert Ok(deleted) = r4_httpc.patient_delete(pat, client)
  echo deleted
```

## [Patch](patch){#patch}

TODO

## [Search](#search){#search}

## [Operations](#operations){#operations}

TODO

## [Transactions](#transactions){#transactions}

TODO

## [History](#history){#history}

TODO

## [Pagination](#transactions){#transactions}

TODO
