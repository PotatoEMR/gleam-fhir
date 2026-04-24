import fhir/r4/client_httpc as r4_httpc
import fhir/r4/complex_types as ct_r4
import fhir/r4/resources as r4
import fhir/r4/sansio as r4_sansio
import fhir/r4/valuesets as r4_valuesets
import fhir/r4us/client_httpc as r4us_httpc
import fhir/r4us/complex_types as ct_r4us
import fhir/r4us/resources as r4us
import fhir/r4us/sansio as r4us_sansio
import fhir/r4us/valuesets as r4us_valuesets

// import gleam/erlang/process
import gleam/io
import gleam/json
import gleam/list
import gleam/option.{Some}

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
      text: Some(ct_r4.narrative_new(
        div: "<div xmlns=\"http://www.w3.org/1999/xhtml\">Joe Armstrong</div>",
        status: r4_valuesets.NarrativestatusGenerated,
      )),
      identifier: [
        ct_r4.Identifier(
          ..ct_r4.identifier_new(),
          system: Some("https://fhir.nhs.uk/Id/nhs-number"),
          value: Some("0123456789"),
        ),
      ],
      name: [
        ct_r4.Humanname(
          ..ct_r4.humanname_new(),
          given: ["Joe"],
          family: Some("Armstrong"),
        ),
      ],
      gender: Some(r4_valuesets.AdministrativegenderMale),
      marital_status: Some(
        ct_r4.Codeableconcept(..ct_r4.codeableconcept_new(), coding: [
          ct_r4.Coding(
            ..ct_r4.coding_new(),
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
    r4_httpc.fhirclient_new("https://hapi.fhir.org/baseR4/")

  let assert Ok(created) = r4_httpc.patient_create(joe, client)
  let assert Some(id) = created.id
  let assert Ok(read) = r4_httpc.patient_read(id, client)
  let rip = r4.Patient(..read, deceased: Some(r4.PatientDeceasedBoolean(True)))
  let assert Ok(updated) = r4_httpc.patient_update(rip, client)
  let assert Ok(bundle) =
    r4_httpc.patient_search_bundled(
      r4_sansio.SpPatient(..r4_sansio.sp_patient_new(), name: Some("Armstrong")),
      client,
    )
    |> r4_httpc.all_pages(client)
  let pats = { bundle |> r4_sansio.bundle_to_groupedresources }.patient
  echo bundle.total
  let assert Ok(_) = list.find(pats, fn(pat) { pat.id == Some(id) })

  let assert Ok(bundle) =
    r4_httpc.search_any("name=Armstrong", "Patient", client)
    |> r4_httpc.all_pages(client)
  let pats = { bundle |> r4_sansio.bundle_to_groupedresources }.patient
  let assert Ok(_) = list.find(pats, fn(pat) { pat.id == Some(id) })
    as { "search 1 did not find " <> id }

  let assert Ok(_) = r4_httpc.patient_delete(updated, client)
  Nil
}

pub fn us_core() {
  let one_id =
    ct_r4us.Identifier(
      ..ct_r4us.identifier_new(),
      system: Some("https://fhir.nhs.uk/Id/nhs-number"),
      value: Some("0123456789"),
    )
  let one_name =
    ct_r4us.Humanname(
      ..ct_r4us.humanname_new(),
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
        ct_r4us.Codeableconcept(..ct_r4us.codeableconcept_new(), coding: [
          ct_r4us.Coding(
            ..ct_r4us.coding_new(),
            system: Some(
              "http://terminology.hl7.org/CodeSystem/v3-MaritalStatus",
            ),
            code: Some("M"),
            display: Some("Married"),
          ),
        ]),
      ),
    )

  // let assert Ok(client) =
  //   r4us_httpc.fhirclient_new("https://r4.smarthealthit.org/")
  let assert Ok(client) =
    r4us_httpc.fhirclient_new("https://hapi.fhir.org/baseR4")

  let assert Ok(created) = r4us_httpc.patient_create(joe, client)
  let assert Some(id) = created.id
  let assert Ok(read) = r4us_httpc.patient_read(id, client)
  let rip =
    r4us.Patient(..read, deceased: Some(r4us.PatientDeceasedBoolean(True)))
  let assert Ok(_) = r4us_httpc.patient_update(rip, client)

  //this seems to not work often but did at one point, maybe also doing request in browser while waiting here kicks it somehow, or not idk...
  // process.sleep(30_000)
  let assert Ok(bundle) =
    r4us_httpc.patient_search_bundled(
      r4us_sansio.SpPatient(
        ..r4us_sansio.sp_patient_new(),
        name: Some("Armstrong"),
      ),
      client,
    )
    |> r4us_httpc.all_pages(client)
  bundle |> r4us.bundle_to_json |> json.to_string |> io.println
  echo bundle.total
  echo id
  let pats = { bundle |> r4us_sansio.bundle_to_groupedresources }.patient
  let assert Ok(_) = list.find(pats, fn(pat) { pat.id == Some(id) })

  let assert Ok(bundle) =
    r4us_httpc.search_any("name=Armstrong", "Patient", client)
    |> r4us_httpc.all_pages(client)
  let pats = { bundle |> r4us_sansio.bundle_to_groupedresources }.patient
  let assert Ok(_) = list.find(pats, fn(pat) { pat.id == Some(id) })
    as { "search 2 did not find " <> id }
}
