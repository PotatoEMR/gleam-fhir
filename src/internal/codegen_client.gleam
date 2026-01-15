import filepath
import gleam/dynamic/decode
import gleam/json
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import simplifile

type Bundle {
  Bundle(entry: List(Entry))
}

fn bundle_decoder() -> decode.Decoder(Bundle) {
  use entry <- decode.field("entry", decode.list(entry_decoder()))
  decode.success(Bundle(entry:))
}

type Entry {
  Entry(resource: Resource)
}

fn entry_decoder() -> decode.Decoder(Entry) {
  use resource <- decode.field("resource", resource_decoder())
  decode.success(Entry(resource:))
}

type Resource {
  Resource(name: String, kind: Option(String))
}

fn resource_decoder() -> decode.Decoder(Resource) {
  use name <- decode.field("name", decode.string)
  use kind <- decode.optional_field(
    "kind",
    None,
    decode.optional(decode.string),
  )
  decode.success(Resource(name:, kind:))
}

pub fn gen(spec_file spec_file: String, fv fhir_version: String) {
  let assert Ok(spec) = simplifile.read(spec_file)
    as "spec files should all be downloaded in src/internal/downloads/{r4 r4b r5}, run with download arg if not"
  // you could use generated bundle decoder here
  // however actordefinition in r4 but not r5
  // and it is much slower than this
  // both real downsides, oh well
  let assert Ok(bundle) = json.parse(from: spec, using: bundle_decoder())
  let entries =
    list.filter(bundle.entry, fn(e) {
      case e.resource.kind, e.resource.name {
        // _, "AllergyIntolerance" -> True
        // _, _ -> False
        // debug: uncomment to try just allergyintolerance
        _, "Base" -> False
        _, "BackboneElement" -> False
        _, "Resource" -> False
        _, "Element" -> False
        Some("complex-type"), _ -> True
        Some("resource"), _ -> True
        _, _ -> False
      }
    })

  let res_specific_fns =
    gen_specific_fns(
      entries,
      "
          pub fn NAMELOWER_create_req(resource: FHIRVERSION.NAMECAPITAL, client: FhirClient) -> Request(String) {
            any_create_req(FHIRVERSION.NAMELOWER_to_json(resource), \"NAMEUPPER\", client)
          }

          pub fn NAMELOWER_read_req(id: String, client: FhirClient) -> Request(String) {
            any_read_req(id, \"NAMEUPPER\", client)
          }

          pub fn NAMELOWER_update_req(resource: FHIRVERSION.NAMECAPITAL, client: FhirClient) -> Result(Request(String), Err) {
            any_update_req(resource.id, FHIRVERSION.NAMELOWER_to_json(resource), \"NAMEUPPER\", client)
          }

          pub fn NAMELOWER_delete_req(id: Option(String), client: FhirClient) -> Result(Request(String), Err) {
            any_delete_req(id, \"NAMEUPPER\", client)
          }

          pub fn NAMELOWER_resp(resp: Response(String)) -> Result(FHIRVERSION.NAMECAPITAL, Err) {
            any_resp(resp, FHIRVERSION.NAMELOWER_decoder())
          }
          ",
    )
  let assert Ok(file_text) =
    "src"
    |> filepath.join("internal")
    |> filepath.join("codegen_client_sansio.txt")
    |> simplifile.read
  let sansio =
    string.concat([file_text, ..res_specific_fns])
    |> string.replace("FHIRVERSION", fhir_version)

  let res_specific_fns =
    gen_specific_fns(
      entries,
      "
            pub fn NAMELOWER_create(
              resource: FHIRVERSION.NAMECAPITAL,
              client: FhirClient,
            ) -> Result(FHIRVERSION.NAMECAPITAL, ReqError) {
              any_create(
                FHIRVERSION.NAMELOWER_to_json(resource),
                \"NAMEUPPER\",
                FHIRVERSION.NAMELOWER_decoder(),
                client,
              )
            }
            
            pub fn NAMELOWER_read(
              id: String,
              client: FhirClient,
            ) -> Result(FHIRVERSION.NAMECAPITAL, ReqError) {
              any_read(id, client, \"NAMEUPPER\", FHIRVERSION.NAMELOWER_decoder())
            }
            
            pub fn NAMELOWER_update(
              resource: FHIRVERSION.NAMECAPITAL,
              client: FhirClient,
            ) -> Result(FHIRVERSION.NAMECAPITAL, ReqError) {
              any_update(
                resource.id,
                FHIRVERSION.NAMELOWER_to_json(resource),
                \"NAMEUPPER\",
                FHIRVERSION.NAMELOWER_decoder(),
                client,
              )
            }
  
            pub fn NAMELOWER_delete(
              resource: FHIRVERSION.NAMECAPITAL,
              client: FhirClient,
            ) -> Result(FHIRVERSION.Operationoutcome, ReqError) {
              any_delete(resource.id, \"NAMEUPPER\", client)
            }
            ",
    )
  let assert Ok(file_text) =
    "src"
    |> filepath.join("internal")
    |> filepath.join("codegen_client_httpc.txt")
    |> simplifile.read
  let httpc_layer =
    string.concat([file_text, ..res_specific_fns])
    |> string.replace("FHIRVERSION", fhir_version)

  #(sansio, httpc_layer)
}

// most of the client stuff is generic so you can just write it in codegen_client.txt
// only the wrappers are resource specific, to be type safe rather than strings, and need to be generated
fn gen_specific_fns(entries: List(Entry), template: String) -> List(String) {
  list.map(entries, fn(entry) {
    let name = entry.resource.name
    let #(name_lower, name_capital) = case name {
      "List" -> #("listfhir", "Listfhir")
      _ -> #(string.lowercase(name), string.capitalise(name))
    }
    template
    |> string.replace("NAMELOWER", name_lower)
    |> string.replace("NAMEUPPER", name)
    |> string.replace("NAMECAPITAL", name_capital)
  })
}
