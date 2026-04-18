import fhir/r4
import fhir/r4_httpc
import fhir/r4_valuesets
import gleam/option.{None, Some}

// runs against an external fhir server, does not end in _test so
// not run as part of gleam test
//
// exercises operation_any with different return_res_type values:
// - $validate returns OperationOutcome
// - $everything returns Bundle
pub fn main() {
  let joe =
    r4.Patient(
      ..r4.patient_new(),
      text: Some(r4.narrative_new(
        div: "<div xmlns=\"http://www.w3.org/1999/xhtml\">Joe Armstrong</div>",
        status: r4_valuesets.NarrativestatusGenerated,
      )),
      name: [
        r4.Humanname(
          ..r4.humanname_new(),
          given: ["Joe"],
          family: Some("Armstrong"),
        ),
      ],
      gender: Some(r4_valuesets.AdministrativegenderMale),
    )

  let assert Ok(client) =
    r4_httpc.fhirclient_new("https://r4.smarthealthit.org/")

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
      return_res_type: "OperationOutcome",
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
      return_res_type: "Bundle",
      client:,
    )
  let assert Ok(_) = r4_httpc.patient_delete(created, client)
  Nil
}
