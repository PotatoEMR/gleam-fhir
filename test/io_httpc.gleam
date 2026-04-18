import fhir/r4
import fhir/r4_httpc
import fhir/r4_sansio
import fhir/r4_valuesets
import fhir/r4us
import fhir/r4us_httpc
import fhir/r4us_sansio
import fhir/r4us_valuesets

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
      text: Some(r4.narrative_new(
        div: "<div xmlns=\"http://www.w3.org/1999/xhtml\">Joe Armstrong</div>",
        status: r4_valuesets.NarrativestatusGenerated,
      )),
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

  let batch_id = "gleam-fhir-joe"
  let joe_with_id = r4.Patient(..joe, id: Some(batch_id))
  let assert Ok(upsert_req) = r4_sansio.patient_update_req(joe_with_id, client)
  let assert Ok(batch_bundle) =
    r4_httpc.batch(
      [upsert_req, r4_sansio.patient_read_req(batch_id, client)],
      r4_sansio.Batch,
      client,
    )
  let assert [_, _] = batch_bundle.entry
  let assert Ok(_) = r4_httpc.patient_delete(joe_with_id, client)

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
