import argv
import fhir/r4_gen/client_httpc
import fhir/r4_gen/resources
import fhir/r4_gen/sansio
import gleam/io
import gleam/json
import simplifile

pub fn main() {
  let #(filename, server) = case argv.load().arguments {
    [] -> #(
      "downloads/profile_package/hl7.fhir.us.core/7.0.0/package/ValueSet-us-core-narrative-status.json",
      "https://tx.fhir.org/r4",
    )
    [filename, server] -> #(filename, server)
    _ ->
      panic as "Usage: gleam run -m valueset_expansion [valueset.json server_url]"
  }
  let assert Ok(contents) = simplifile.read(filename)
  let assert Ok(definition) = json.parse(contents, resources.valueset_decoder())
  let assert Ok(client) = sansio.fhirclient_new(server)
  case expand(definition, client) {
    Ok(expanded) ->
      expanded |> resources.valueset_to_json |> json.to_string |> io.println
    Error(err) -> panic as client_httpc.err_valueset_to_string(err)
  }
}

/// Ask a terminology server to expand the supplied ValueSet definition.
/// Collect every page into the returned ValueSet.
pub fn expand(
  value_set: resources.Valueset,
  client: sansio.FhirClient,
) -> Result(resources.Valueset, client_httpc.ErrValueset) {
  client_httpc.valueset_expand(value_set, client)
}
