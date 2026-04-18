import fhir/r4_httpc
import fhir/r4usp_httpc
import fhir/r5
import fhir/r5_httpc
import gleam/io
import gleam/json

// runs against an external FHIR server, i.e. may fail because of server
// does not end in _test so not run by gleam test
pub fn main() {
  let assert Ok(client) =
    r4_httpc.fhirclient_new("https://r4.smarthealthit.org/")

  let assert Ok(_) =
    r4_httpc.search_any("name=e&_count=10", "Patient", client)
    |> r4_httpc.all_pages(client)
  //bundle |> r4.bundle_to_json |> json.to_string |> io.println

  let assert Ok(client) =
    r4usp_httpc.fhirclient_new("https://r4.smarthealthit.org/")

  let assert Ok(_) =
    r4usp_httpc.search_any("name=e&_count=10", "Patient", client)
    |> r4usp_httpc.all_pages(client)
  //bundle |> r4usp.bundle_to_json |> json.to_string |> io.println

  let assert Ok(client) =
    r5_httpc.fhirclient_new("https://r4.smarthealthit.org/")

  let assert Ok(bundle) =
    r5_httpc.search_any("name=e&_count=10", "Patient", client)
    |> r5_httpc.all_pages(client)
  bundle |> r5.bundle_to_json |> json.to_string |> io.println
}
