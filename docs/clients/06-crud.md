# CRUD

## Create

[Create](https://build.fhir.org/http.html#create) resource, which the server assigns an id to and creates. In Gleam, `patient_create` (or any resource).

```gleam
  let pat =
    r4.Patient(..r4.patient_new(), name: [
      r4.Humanname(..r4.humanname_new(), given: ["Joe"]),
    ])
  let assert Ok(created) = r4_httpc.patient_create(pat, client)
  echo created
```

## Read

[Read](https://build.fhir.org/http.html#read) resource by id. In Gleam, `patient_read` (or any resource).

```gleam
  let assert Ok(pat) =
    r4_httpc.patient_read("87a339d0-8cae-418e-89c7-8651e6aab3c6", client)
  echo pat
```

## Update

[Update](https://build.fhir.org/http.html#update) resource on server to be sent resource (by id, which is required in sent resource). If server allows client defined ids, update can be used to create a new resource on server at specific id, rather than id assigned by server. In Gleam, `patient_update` (or any resource).

```gleam
  let pat =
    r4.Patient(..r4.patient_new(), id: Some("73180176"), name: [
      r4.Humanname(..r4.humanname_new(), given: ["Mike"]),
    ])
  let assert Ok(updated) = r4_httpc.patient_update(pat, client)
  echo updated
```

## Delete

[Delete](https://build.fhir.org/http.html#delete) resource on server (by id, which is required in sent resource). Delete will return an `Ok(OperationOutcome)` on success, no matter what type of resource is deleted. In Gleam, `patient_delete` (or any resource).

```gleam
  let pat =
    r4.Patient(..r4.patient_new(), id: Some("73365109"), name: [
      r4.Humanname(..r4.humanname_new(), given: ["Mike"]),
    ])
  let assert Ok(deleted) = r4_httpc.patient_delete(pat, client)
  echo deleted
```
