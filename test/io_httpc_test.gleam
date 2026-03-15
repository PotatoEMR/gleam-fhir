import fhir/r4
import fhir/r4_httpc
import fhir/r4_sansio
import fhir/r4_valuesets
import fhir/r4us
import fhir/r4us_httpc
import fhir/r4us_sansio
import fhir/r4us_valuesets
import gleam/list
import gleam/option.{None, Some}

// these tests run against an external fhir server
// so they are good to check against the real world
// but may fail just because the server falls over!
// not necessarily because they're wrong
// also, there may be some request timing involved on the server side
// I have seen these pass sometimes and fail sometimes
// so idk
// this doesn't end in _test so it isn't run as part of gleam test
pub fn main() {
  normal_r4()
  us_core()
}

pub fn normal_r4() {
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
      client:,
    )

  let assert Ok(created) = r4_httpc.patient_create(joe, client)
  let assert Some(id) = created.id
  let assert Ok(read) = r4_httpc.patient_read(id, client)
  let rip = r4.Patient(..read, deceased: Some(r4.PatientDeceasedBoolean(True)))
  let assert Ok(updated) = r4_httpc.patient_update(rip, client)
  let assert Ok(pats) =
    r4_httpc.patient_search(
      r4_sansio.SpPatient(..r4_sansio.sp_patient_new(), name: Some("Armstrong")),
      client,
    )
  let assert Ok(_) = list.find(pats, fn(pat) { pat.id == Some(id) })

  let assert Ok(bundle) =
    r4_httpc.search_any("name=Armstrong", "Patient", client)
  let pats = { bundle |> r4_sansio.bundle_to_groupedresources }.patient
  let assert Ok(_) = list.find(pats, fn(pat) { pat.id == Some(id) })

  let assert Ok(_) =
    r4_httpc.operation_any(
      params: None,
      operation_name: "everything",
      res_type: "Patient",
      res_id: created.id,
      res_decoder: r4.bundle_decoder(),
      client:,
    )
  let assert Ok(_) = r4_httpc.patient_delete(updated, client)
  Nil
}

pub fn us_core() {
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
  echo pats
  echo id
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
  Nil
}
