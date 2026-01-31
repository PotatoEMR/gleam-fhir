# Clients

## [FHIR Client](#client){#client}

FHIR defines [REST operations](https://build.fhir.org/http.html) for interacting with a server. 

In Gleam, for r4, r4b, r5:
- [r4_httpc](https://hexdocs.pm/fhir/fhir/r4_httpc.html) for Gleam's default Erlang target
- [r4_rsvp](https://hexdocs.pm/fhir/fhir/r4_rsvp.html) for [Lustre](https://hexdocs.pm/lustre/lustre.html) apps
- [r4_sansio](https://hexdocs.pm/fhir/fhir/r4_sansio.html) for other http clients

The examples of operations (Create, Read, etc.) on this page use r4_httpc; similar operations exist in rsvp and sansio.

Regardless of compilation target, the first step is to create a client with the FHIR server base url.

```gleam
import fhir/r4_httpc

pub fn main() {
  //creating a client for a public FHIR server
  let client = r4_httpc.fhirclient_new("https://r4.smarthealthit.org/")
}
```

## [Client for httpc](#httpc){#httpc}

[r4_httpc](https://hexdocs.pm/fhir/fhir/r4_httpc.html) makes requests using httpc, and is the easiest to use.

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

[r4_rsvp](https://hexdocs.pm/fhir/fhir/r4_rsvp.html) creates an `Effect` to give to Lustre, which will go make the request and come back with a message. This example has much more going on, in order to run in a browser using [Model-View-Update](https://hexdocs.pm/lustre/guide/02-state-management.html).

```gleam

// IMPORTS ---------------------------------------------------------------------

import fhir/r4
import fhir/r4_rsvp
import fhir/r4_sansio
import gleam/option.{type Option, None, Some}
import lustre
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import rsvp

// MAIN ------------------------------------------------------------------------

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

// MODEL -----------------------------------------------------------------------

type Model {
  Model(client: r4_rsvp.FhirClient, curr_pat: Option(r4.Patient))
}

fn init(_) -> #(Model, Effect(Msg)) {
  let model =
    Model(
      client: r4_sansio.fhirclient_new("https://r4.smarthealthit.org"),
      curr_pat: None,
    )
  let read: Effect(Msg) =
    r4_rsvp.patient_read(
      "87a339d0-8cae-418e-89c7-8651e6aab3c6",
      model.client,
      ServerReturnedPatient,
    )
  #(model, read)
}

// UPDATE ----------------------------------------------------------------------

type Msg {
  ServerReturnedPatient(Result(r4.Patient, r4_rsvp.Err))
}

fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    ServerReturnedPatient(Ok(pat)) -> {
      #(Model(..model, curr_pat: Some(pat)), effect.none())
    }
    ServerReturnedPatient(Error(err)) -> {
      #(model, effect.none())
    }
  }
}

// VIEW ------------------------------------------------------------------------

fn view(model: Model) -> Element(Msg) {
  case model.curr_pat {
    None -> html.p([], [html.text("none")])
    Some(pat) -> {
      html.p([], [
        html.text(
          "patient id: "
          <> case pat.id {
            None -> "none"
            Some(id) -> id
          },
        ),
      ])
    }
  }
}
```

## [sansio](#sansio){#sansio}

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

[Create](https://build.fhir.org/http.html#create) resource, which the server assigns an id to and creates. In Gleam, `patient_create` (or any resource).

```gleam
  let pat =
    r4.Patient(..r4.patient_new(), name: [
      r4.Humanname(..r4.humanname_new(), given: ["Joe"]),
    ])
  let assert Ok(created) = r4_httpc.patient_create(pat, client)
  echo created
```

## [Read](#read){#read}

[Read](https://build.fhir.org/http.html#read) resource by id. In Gleam, `patient_read` (or any resource).

```gleam
  let assert Ok(pat) =
    r4_httpc.patient_read("87a339d0-8cae-418e-89c7-8651e6aab3c6", client)
  echo pat
```

## [Update](#update){#update}

[Update](https://build.fhir.org/http.html#update) resource on server to be sent resource (by id, which is required in sent resource). If server allows client defined ids, update can be used to create a new resource on server at specific id, rather than id assigned by server. In Gleam, `patient_update` (or any resource).

```gleam
  let pat =
    r4.Patient(..r4.patient_new(), id: Some("73180176"), name: [
      r4.Humanname(..r4.humanname_new(), given: ["Mike"]),
    ])
  let assert Ok(updated) = r4_httpc.patient_update(pat, client)
  echo updated
```

## [Delete](#delete){#delete}

[Delete](https://build.fhir.org/http.html#delete) resource on server (by id, which is required in sent resource). Delete will return an `Ok(OperationOutcome)` on success, no matter what type of resource is deleted. In Gleam, `patient_delete` (or any resource).

```gleam
  let pat =
    r4.Patient(..r4.patient_new(), id: Some("73365109"), name: [
      r4.Humanname(..r4.humanname_new(), given: ["Mike"]),
    ])
  let assert Ok(deleted) = r4_httpc.patient_delete(pat, client)
  echo deleted
```

## [Patch](#patch){#patch}

TODO

## [Search](#search){#search}

[Search](https://www.hl7.org/fhir/search.html) for a resource on server, which will return a [bundle](https://hexdocs.pm/fhir//resources.html#bundle) with a list of resources. In Gleam, `patient_search` will return just a list of patient resources, whereas `patient_search_bundled` will return the entire bundle, which can have other resource types. Use search parameters to narrow searches, such as patient [name](https://build.fhir.org/patient-search.html#hcPatient-name). In Gleam, `SpPatient` contains the search params for a patient, and `sp_patient_new` creates an `SpPatient` with no params set.

TODO include/revinclude

```gleam
import fhir/r4
import fhir/r4_httpc
import fhir/r4_sansio
import gleam/option.{Some}

pub fn main() {
  let client = r4_httpc.fhirclient_new("https://hapi.fhir.org/baseR4")

  //get patient list
  let patients: Result(List(r4.Patient), r4_httpc.Err) =
    r4_httpc.patient_search(
      r4_sansio.SpPatient(..r4_sansio.sp_patient_new(), name: Some("Mike")),
      client,
    )
  let assert Ok(pats1) = patients

  //get bundle and convert to patient list
  let pat_bundle: Result(r4.Bundle, r4_httpc.Err) =
    r4_httpc.patient_search_bundled(
      r4_sansio.SpPatient(..r4_sansio.sp_patient_new(), name: Some("Mike")),
      client,
    )
  let assert Ok(bundle) = pat_bundle
  let resources = r4_sansio.bundle_to_groupedresources(bundle)
  let pats2: List(r4.Patient) = resources.patient

  echo pats1 == pats2
}
```

## [Operations](#operations){#operations}

TODO

## [Transactions](#transactions){#transactions}

TODO

## [History](#history){#history}

TODO

## [Pagination](#transactions){#transactions}

TODO
