# Operations

In addition to the standard Create, Read, etc., functions, FHIR servers support [Operations](https://build.fhir.org/operations.html): named functions that the client can ask the server to execute. FHIR defines a list of operations, but implementations can name and define their own operations too. Operations can have a [Parameters](https://build.fhir.org/parameters.html) resource as the body of the request, carrying primitive types, complex types, or whole resources.

In Gleam, `operation_any` is flexible but makes you construct the operation yourself, including some maybe error prone strings. It takes an `Option(r4.Parameters)` to send parameters, but that can also be `None`. For example, here $everything is called with no parameters, whereas $validate is called on a Patient resource parameter. $everything returns a Bundle, so it's called with `r4.bundle_decoder()`; $validate returns an OperationOutcome, so it's called with `r4.operationoutcome_decoder()`. Of course `r4_httpc.operation_any` returns a `Result(res, r4_httpc.Err)`, so in either case you could still get `r4_httpc.Err` containing an OperationOutcome.

```gleam
import fhir/r4
import fhir/r4_httpc
import fhir/r4_sansio
import fhir/r4_valuesets
import gleam/list
import gleam/option.{None, Some}

pub fn main() {
  let joe =
    r4.Patient(
      ..r4.patient_new(),
      identifier: [
        r4.Identifier(
          ..r4.identifier_new(),
          system: Some("https://fhir.nhs.uk/Id/nhs-number"),
          value: Some("0123456789"),
        ),
      ],
      name: [
        r4.Humanname(
          ..r4.humanname_new(),
          given: ["Joe"],
          family: Some("Armstrong"),
        ),
      ],
      gender: Some(r4_valuesets.AdministrativegenderMale),
      marital_status: Some(
        r4.Codeableconcept(..r4.codeableconcept_new(), coding: [
          r4.Coding(
            ..r4.coding_new(),
            system: Some(
              "http://terminology.hl7.org/CodeSystem/v3-MaritalStatus",
            ),
            code: Some("M"),
            display: Some("Married"),
          ),
        ]),
      ),
    )

  let client = r4_httpc.fhirclient_new("https://r4.smarthealthit.org/")

  let params =
    r4.Parameters(..r4.parameters_new(), parameter: [
      r4.ParametersParameter(
        ..r4.parameters_parameter_new("resource"),
        resource: Some(r4.ResourcePatient(joe)),
      ),
    ])

  let assert Ok(_) =
    r4_httpc.operation_any(
      params: Some(params),
      operation_name: "validate",
      res_type: "Patient",
      res_id: None,
      res_decoder: r4.operationoutcome_decoder(),
      client:,
    )

  let assert Ok(created) = r4_httpc.patient_create(joe, client)

  let assert Ok(_) =
    r4_httpc.operation_any(
      params: None,
      operation_name: "everything",
      res_type: "Patient",
      res_id: created.id,
      res_decoder: r4.bundle_decoder(),
      client:,
    )
}
```
