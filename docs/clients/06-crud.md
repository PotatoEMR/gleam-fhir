# CRUD

## Create

[Create](https://build.fhir.org/http.html#create) resource, which the server assigns an id to and creates. In Gleam, `patient_create` (or any resource) returns an `Ok(Patient)` or error.

## Read

[Read](https://build.fhir.org/http.html#read) resource by id. In Gleam, `patient_read` (or any resource) returns an `Ok(Patient)` or error.

## Update

[Update](https://build.fhir.org/http.html#update) resource on server to be sent resource (by id, which is required in sent resource). If server allows client defined ids, update can be used to create a new resource on server at specific id (vs create, which lets the server assign id). In Gleam, `patient_update` (or any resource) returns an `Ok(Patient)` or error.

## Delete

[Delete](https://build.fhir.org/http.html#delete) resource on server (by id, which is required in sent resource). In Gleam, `patient_delete` (or any resource), no matter what type of resource is deleted, returns `Ok(Operationoutcome)` or an http status indicating success (on success, servers may send back an OperationOutcome but may also send only http status with empty body), or error.

```gleam
import fhir/r4/client_httpc
import fhir/r4/complex_types as ct
import fhir/r4/resources
import gleam/option.{Some}

pub fn main() {
  let assert Ok(client) =
    client_httpc.fhirclient_new("https://r4.smarthealthit.org/")

  // Create
  let pat =
    resources.Patient(..resources.patient_new(), name: [
      ct.Humanname(..ct.humanname_new(), given: ["Joe"]),
    ])
  let assert Ok(created) = client_httpc.patient_create(pat, client)
  echo created

  // Read
  let assert Some(c_id) = created.id
  let assert Ok(pat) = client_httpc.patient_read(c_id, client)
  echo pat

  // Update
  let pat =
    resources.Patient(..resources.patient_new(), id: Some("sgfdsgfdgfd"), name: [
      ct.Humanname(..ct.humanname_new(), given: ["Mike"]),
    ])
  let assert Ok(updated) = client_httpc.patient_update(pat, client)
  echo updated

  // Delete
  let pat =
    resources.Patient(..resources.patient_new(), id: Some("sgfdsgfdgfd"), name: [
      ct.Humanname(..ct.humanname_new(), given: ["Mike"]),
    ])
  let assert Ok(deleted) = client_httpc.patient_delete(pat, client)
  echo deleted
}
```
