# Search

[Search](https://www.hl7.org/fhir/search.html) for a resource on server, which will return a [bundle](https://hexdocs.pm/fhir/resources.html#bundle) with a list of resources. In Gleam, `patient_search` will return just a list of patient resources, whereas `patient_search_bundled` will return the entire bundle, which can have other resource types. Use search parameters to narrow searches, such as patient [name](https://build.fhir.org/patient-search.html#hcPatient-name). In Gleam, `SpPatient` contains the search params for a patient, and `sp_patient_new` creates an `SpPatient` with no params set.

TODO include/revinclude

```gleam
import fhir/r4
import fhir/r4_httpc
import fhir/r4_sansio
import gleam/option.{Some}

pub fn main() {
  let assert Ok(client) = r4_httpc.fhirclient_new("https://hapi.fhir.org/baseR4")

  //get patient list
  let patients: Result(List(r4.Patient), r4_httpc.Err) =
    r4_httpc.patient_search(
      r4_sansio.SpPatient(..r4_sansio.sp_patient_new(), name: Some("Mike")),
      client,
    )
  let assert Ok(pats1) = patients

  //get bundle and convert to patient list
  let pat_bundle: Result(r4.Bundle, r4_httpc.Err) =
    r4_httpc.patient_search_bundled(
      r4_sansio.SpPatient(..r4_sansio.sp_patient_new(), name: Some("Mike")),
      client,
    )
  let assert Ok(bundle) = pat_bundle
  let resources = r4_sansio.bundle_to_groupedresources(bundle)
  let pats2: List(r4.Patient) = resources.patient

  echo pats1 == pats2
}
```

`search_any` takes a `String`, which is more error prone but supports complex [search params](https://build.fhir.org/search.html#ptypes)

```gleam
  let assert Ok(bundle) =
    r4_httpc.search_any("name=Armstrong", "Patient", client)
  let pats = { bundle |> r4_sansio.bundle_to_groupedresources }.patient
```
