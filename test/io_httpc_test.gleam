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
}
