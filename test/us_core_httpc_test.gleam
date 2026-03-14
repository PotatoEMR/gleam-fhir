import fhir/r4us
import fhir/r4us_httpc
import fhir/r4us_sansio
import fhir/r4us_valuesets
import gleam/list
import gleam/option.{None, Some}

pub fn main() {
  let one_id =
    r4us.Identifier(
      ..r4us.identifier_new(),
      system: Some("https://fhir.nhs.uk/Id/nhs-number"),
      value: Some("0123456789"),
    )
  let one_name =
    r4us.Humanname(
      ..r4us.humanname_new(),
      given: ["Joseph", "Leslie"],
      family: Some("Armstrong"),
    )
  let joe =
    r4us.Patient(
      ..r4us.patient_new(),
      identifier: [one_id],
      name: [one_name],
      gender: Some(r4us_valuesets.AdministrativegenderMale),
      marital_status: Some(
        r4us.Codeableconcept(..r4us.codeableconcept_new(), coding: [
          r4us.Coding(
            ..r4us.coding_new(),
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
    r4us_httpc.fhirclient_new("https://r4.smarthealthit.org/")

  let params =
    r4us.Parameters(..r4us.parameters_new(), parameter: [
      r4us.ParametersParameter(
        ..r4us.parameters_parameter_new("resource"),
        resource: Some(r4us.ResourcePatient(joe)),
      ),
    ])
  let assert Ok(_) =
    r4us_httpc.operation_any(
      params: Some(params),
      operation_name: "validate",
      res_type: "Patient",
      res_id: None,
      res_decoder: r4us.operationoutcome_decoder(),
      client:,
    )

  let assert Ok(created) = r4us_httpc.patient_create(joe, client)
  let assert Some(id) = created.id
  let assert Ok(read) = r4us_httpc.patient_read(id, client)
  let rip =
    r4us.Patient(..read, deceased: Some(r4us.PatientDeceasedBoolean(True)))
  let assert Ok(updated) = r4us_httpc.patient_update(rip, client)
  let assert Ok(pats) =
    r4us_httpc.patient_search(
      r4us_sansio.SpPatient(
        ..r4us_sansio.sp_patient_new(),
        name: Some("Armstrong"),
      ),
      client,
    )
  let assert Ok(_) = list.find(pats, fn(pat) { pat.id == Some(id) })

  let assert Ok(bundle) =
    r4us_httpc.search_any("name=Armstrong", "Patient", client)
  let pats = { bundle |> r4us_sansio.bundle_to_groupedresources }.patient
  let assert Ok(_) = list.find(pats, fn(pat) { pat.id == Some(id) })

  let assert Ok(_) =
    r4us_httpc.operation_any(
      params: None,
      operation_name: "everything",
      res_type: "Patient",
      res_id: created.id,
      res_decoder: r4us.bundle_decoder(),
      client:,
    )
  let assert Ok(_) = r4us_httpc.patient_delete(updated, client)
}
