import fhir/r4
import fhir/r4_httpc
import fhir/r4_sansio
import fhir/r4_valuesets
import gleam/list
import gleam/option.{Some}

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

  echo joe

  let client = r4_httpc.fhirclient_new("https://r4.smarthealthit.org/")

  let assert Ok(created) = r4_httpc.patient_create(joe, client)
  let assert Some(id) = created.id
  let assert Ok(read) = r4_httpc.patient_read(id, client)
  echo read
  let rip = r4.Patient(..read, deceased: Some(r4.PatientDeceasedBoolean(True)))
  let assert Ok(updated) = r4_httpc.patient_update(rip, client)
  echo updated
  let assert Ok(pats) =
    r4_httpc.patient_search(
      r4_sansio.SpPatient(..r4_sansio.sp_patient_new(), name: Some("Armstrong")),
      client,
    )
  let assert Ok(found) = list.find(pats, fn(pat) { pat.id == Some(id) })
  echo found
  let assert Ok(_) = r4_httpc.patient_delete(updated, client)
}
