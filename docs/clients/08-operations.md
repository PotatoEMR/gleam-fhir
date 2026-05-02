# Operations

In addition to the standard Create, Read, etc., functions, FHIR servers support [Operations](https://build.fhir.org/operations.html): named functions that the client can ask the server to execute. FHIR defines a list of operations, but implementations can name and define their own operations too. Operations can have a [Parameters](https://build.fhir.org/parameters.html) resource as the body of the request, carrying primitive types, complex types, or whole resources.

In Gleam, `operation_any` is flexible but makes you construct the operation yourself, including some maybe error prone strings. It takes an `Option(reseources.Parameters)` to send parameters, but that can also be `None`. For example, here $everything is called with no parameters, whereas $validate is called on a Patient resource parameter. $everything returns a Bundle, so it's called with `resources.bundle_decoder()`; $validate returns an OperationOutcome, so it's called with `reseources.operationoutcome_decoder()`. Of course `client_httpc.operation_any` returns `Result(res, client_httpc.Err)`, so either operation could return a `client_httpc.Err` containing an OperationOutcome.

```gleam
import fhir/r4/client_httpc
import fhir/r4/complex_types as ct
import fhir/r4/resources
import fhir/r4/valuesets
import gleam/option.{None, Some}

pub fn main() {
  let joe =
    resources.Patient(
      ..resources.patient_new(),
      identifier: [
        ct.Identifier(
          ..ct.identifier_new(),
          system: Some("https://fhir.nhs.uk/Id/nhs-number"),
          value: Some("0123456789"),
        ),
      ],
      name: [
        ct.Humanname(
          ..ct.humanname_new(),
          given: ["Joe"],
          family: Some("Armstrong"),
        ),
      ],
      gender: Some(valuesets.AdministrativegenderMale),
      marital_status: Some(
        ct.Codeableconcept(..ct.codeableconcept_new(), coding: [
          ct.Coding(
            ..ct.coding_new(),
            system: Some(
              "http://terminology.hl7.org/CodeSystem/v3-MaritalStatus",
            ),
            code: Some("M"),
            display: Some("Married"),
          ),
        ]),
      ),
    )

  let assert Ok(client) =
    client_httpc.fhirclient_new("https://hapi.fhir.org/baseR4")

  let params =
    resources.Parameters(..resources.parameters_new(), parameter: [
      resources.ParametersParameter(
        ..resources.parameters_parameter_new("resource"),
        resource: Some(resources.ResourcePatient(joe)),
      ),
    ])

  let assert Ok(_) =
    client_httpc.operation_any(
      params: Some(params),
      operation_name: "validate",
      res_type: "Patient",
      res_id: None,
      res_decoder: resources.operationoutcome_decoder(),
      return_res_type: "OperationOutcome",
      client:,
    )

  let assert Ok(created) = client_httpc.patient_create(joe, client)

  let assert Ok(_) =
    client_httpc.operation_any(
      params: None,
      operation_name: "everything",
      res_type: "Patient",
      res_id: created.id,
      res_decoder: resources.bundle_decoder(),
      return_res_type: "Bundle",
      client:,
    )
}
```
