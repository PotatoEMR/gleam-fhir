# Search

[Search](https://www.hl7.org/fhir/search.html) for a resource on server, which will return a [bundle](https://hexdocs.pm/fhir/resources.html#bundle) with a list of resources. In Gleam, `patient_search` will return just a list of patient resources, whereas `patient_search_bundled` will return the entire bundle, which can have other resource types.

Use search parameters to narrow searches, such as patient [name](https://build.fhir.org/patient-search.html#hcPatient-name). In Gleam, `SpPatient` contains the search params for a patient, and `sp_patient_new` creates an `SpPatient` with no params set. `search_any` takes a `String`, which is more error prone but supports complex [search params](https://build.fhir.org/search.html#ptypes) such as `_revinclude`.

The FHIR sever may choose to paginate the search results into multiple bundles, returning only the first bundle and a link to the next bundle. In Gleam, the sansio fn `bundle_next_page_req` takes a bundle and, if it has a link to next bundle, returns a `Request` to get the next bundle. `fhir/r4/client_httpc` (but not `fhir/r4/client_rsvp`) has an `all_pages` fn to get all pages and return a single unpaginated bundle.

```gleam
import fhir/r4/client_httpc
import fhir/r4/resources
import fhir/r4/sansio
import gleam/http/request.{type Request}
import gleam/httpc
import gleam/int
import gleam/io
import gleam/json.{type Json}
import gleam/list
import gleam/option.{type Option, None, Some}

pub fn main() {
  let assert Ok(client) =
    client_httpc.fhirclient_new("https://hapi.fhir.org/baseR4")

  //get patient list
  let patients: Result(List(resources.Patient), client_httpc.Err) =
    client_httpc.patient_search(
      sansio.SpPatient(..sansio.sp_patient_new(), name: Some("Mike")),
      client,
    )
  let assert Ok(pats1) = patients

  //get bundle and convert to patient list
  let pat_bundle: Result(resources.Bundle, client_httpc.Err) =
    client_httpc.patient_search_bundled(
      sansio.SpPatient(..sansio.sp_patient_new(), name: Some("Mike")),
      client,
    )
  let assert Ok(bundle) = pat_bundle
  let grouped = sansio.bundle_to_groupedresources(bundle)
  let pats2: List(resources.Patient) = grouped.patient

  echo pats1 == pats2

  let assert Ok(client) =
    client_httpc.fhirclient_new("https://r4.smarthealthit.org")

  // limit each bundle to 10 patients with _count=10
  // and keep getting bundles as long as the server has more with all_pages
  let assert Ok(bundle) =
    client_httpc.search_any("name=e&_count=10", "Patient", client)
    |> client_httpc.all_pages(client)
  bundle |> resources.bundle_to_json |> json.to_string |> io.println
  bundle.entry |> list.length |> int.to_string |> io.println

  // same thing using sansio.bundle_next_page_req,
  // returning a List(Bundle) instead of pretending we get just one Bundle
  let first =
    sansio.any_search_req("name=e&_count=10", "Patient", client)
    |> send_bundle_req
  let assert Ok(bundles) = all_pages_loop(first, [], client)
  bundles
  |> list.fold(from: 0, with: fn(acc, bundle) {
    acc + list.length(bundle.entry)
  })
  |> int.to_string
  |> io.println
}

/// search each bundle and return list of all bundles
pub fn all_pages_loop(
  curr_bundle: Result(resources.Bundle, String),
  acc_bundles: List(resources.Bundle),
  client: sansio.FhirClient,
) -> Result(List(resources.Bundle), String) {
  case curr_bundle {
    Error(err) -> Error(err)
    Ok(curr_bundle) -> {
      let acc_bundles = [curr_bundle, ..acc_bundles]
      case sansio.bundle_next_page_req(curr_bundle, client) {
        // Error(_) -> reached last page
        Error(_) -> Ok(acc_bundles)
        Ok(req) -> {
          let next = send_bundle_req(req)
          all_pages_loop(next, acc_bundles, client)
        }
      }
    }
  }
}

fn send_bundle_req(
  req: Request(Option(Json)),
) -> Result(resources.Bundle, String) {
  case
    req
    |> request.set_body(case req.body {
      None -> ""
      Some(body) -> json.to_string(body)
    })
    |> httpc.send
  {
    Error(_) -> Error("http error")
    Ok(resp) ->
      case sansio.bundle_resp(resp) {
        Error(_) -> Error("parse error")
        Ok(bundle) -> Ok(bundle)
      }
  }
}
```
