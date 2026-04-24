import fhir/r4/client_httpc
import fhir/r4/complex_types as ct
import fhir/r4/resources
import fhir/r4/valuesets

import gleam/option.{None, Some}

// runs against an external fhir server, does not end in _test so
// not run as part of gleam test
//
// exercises operation_any with different return_res_type values:
// - $validate returns OperationOutcome
// - $everything returns Bundle
pub fn main() {
  let joe =
    resources.Patient(
      ..resources.patient_new(),
      text: Some(ct.narrative_new(
        div: "<div xmlns=\"http://www.w3.org/1999/xhtml\">Joe Armstrong</div>",
        status: valuesets.NarrativestatusGenerated,
      )),
      name: [
        ct.Humanname(
          ..ct.humanname_new(),
          given: ["Joe"],
          family: Some("Armstrong"),
        ),
      ],
      gender: Some(valuesets.AdministrativegenderMale),
    )

  let assert Ok(client) =
    client_httpc.fhirclient_new("https://r4.smarthealthit.org/")

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
  let assert Ok(_) = client_httpc.patient_delete(created, client)
  Nil
}
