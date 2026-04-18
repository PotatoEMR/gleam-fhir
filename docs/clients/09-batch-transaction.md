# Batch/Transaction

While other interactions such as Create go one http request/response at a time, [batch/transaction](https://build.fhir.org/http.html#transaction) can include multiple requests in a single bundle. The server processes the bundle either as a **batch**, meaning a request can fail independently and others can still succeed, or as a **transaction**, meaning if one request in the bundle fails then they all fail.

In Gleam, `r4_httpc.batch` takes `List(Request(Option(Json)))`, i.e. a list of http requests to include in one bundle, each of which has an optional json body. To ensure these requests are valid, get them from sansio functions, for instance `r4_sansio.patient_update_req`. The batch function also takes either `r4_sansio.Batch` or `r4_sansio.Transaction`.

```gleam
import fhir/r4
import fhir/r4_httpc
import fhir/r4_sansio
import fhir/r4_valuesets
import gleam/int
import gleam/io
import gleam/json
import gleam/list
import gleam/option.{Some}
import gleam/time/timestamp

pub fn main() {
  // going to create a patient and hapi seems unhappy with one identical to a previously created resource
  // so throw some random time in there
  let now = timestamp.system_time() |> timestamp.to_unix_seconds_and_nanoseconds
  let pat_id = "gleam-fhir-joe-" <> int.to_string(now.0)
  let joe =
    r4.Patient(
      ..r4.patient_new(),
      id: Some(pat_id),
      name: [
        r4.Humanname(
          ..r4.humanname_new(),
          given: ["Joe", "Leslie"],
          family: Some("Armstrong"),
        ),
      ],
      telecom: [
        r4.Contactpoint(
          ..r4.contactpoint_new(),
          system: Some(r4_valuesets.ContactpointsystemPhone),
          value: Some(int.to_string(now.0)),
        ),
      ],
      gender: Some(r4_valuesets.AdministrativegenderMale),
    )

  let assert Ok(client) =
    r4_httpc.fhirclient_new("r4.smarthealthit.org")

  // When processing a batch or transaction, a server MAY
  // choose to honor existing logical ids
  // (e.g., Observation/1234 remains as Observation/1234 on the server),
  // but since this is only safe in controlled circumstances,
  // servers may choose to assign new ids to all submitted resources,
  // irrespective of any claimed logical id in the resource
  let assert Ok(upsert_req) = r4_sansio.patient_update_req(joe, client)
  let read_req = r4_sansio.patient_read_req(pat_id, client)
  let assert Ok(batch_bundle) =
    r4_httpc.batch(
      [upsert_req, read_req],
      r4_sansio.Transaction,
      client,
    )
  batch_bundle |> r4.bundle_to_json |> json.to_string |> io.println

  let batch_response = batch_bundle.entry

  // find response to update with status 201 created
  let assert Ok(_) =
    list.find(batch_response, fn(entry) {
      case entry.response {
        Some(resp) ->
          case resp.status {
            "201" <> _ -> True
            _ -> False
          }
        _ -> False
      }
    })

  // find response to read with status 200 ok
  let assert Ok(_) =
    list.find(batch_response, fn(entry) {
      case entry.response {
        Some(resp) ->
          case resp.status {
            "200" <> _ -> True
            _ -> False
          }
        _ -> False
      }
    })

  // if we did this delete as part of the transaction,
  // the server would process it *before* the update and read
  // rather than after
  let assert Ok(_) = r4_httpc.patient_delete(joe, client)
}
```
