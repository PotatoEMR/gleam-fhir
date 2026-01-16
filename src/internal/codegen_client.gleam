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
  Resource(rest: List(Rest), name: String, kind: Option(String))
}

fn resource_decoder() -> decode.Decoder(Resource) {
  use rest <- decode.optional_field("rest", [], decode.list(rest_decoder()))
  use name <- decode.field("name", decode.string)
  use kind <- decode.optional_field(
    "kind",
    None,
    decode.optional(decode.string),
  )
  decode.success(Resource(rest:, name:, kind:))
}

type Rest {
  Rest(resource: List(RestResource))
}

fn rest_decoder() -> decode.Decoder(Rest) {
  use resource <- decode.optional_field(
    "resource",
    [],
    decode.list(rest_resource_decoder()),
  )
  decode.success(Rest(resource:))
}

type RestResource {
  RestResource(
    type_: String,
    search_include: List(String),
    search_rev_include: List(String),
    search_param: List(SearchParam),
  )
}

fn rest_resource_decoder() -> decode.Decoder(RestResource) {
  use type_ <- decode.field("type", decode.string)
  use search_include <- decode.optional_field(
    "searchInclude",
    [],
    decode.list(decode.string),
  )
  use search_rev_include <- decode.optional_field(
    "searchRevInclude",
    [],
    decode.list(decode.string),
  )
  use search_param <- decode.optional_field(
    "searchParam",
    [],
    decode.list(search_param_decoder()),
  )
  decode.success(RestResource(
    type_:,
    search_include:,
    search_rev_include:,
    search_param:,
  ))
}

type SearchParam {
  SearchParam(name: String)
}

fn search_param_decoder() -> decode.Decoder(SearchParam) {
  use name <- decode.field("name", decode.string)
  decode.success(SearchParam(name:))
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

  //region sansio
  let res_specific_crud =
    gen_specific_crud(
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

  //first entry in bundle has all the search param info
  let assert [first_entry, ..] = bundle.entry
  let search_encode =
    list.map(first_entry.resource.rest, fn(rest) {
      list.map(rest.resource, fn(res) {
        string.concat([
          "Sp",
          string.capitalise(res.type_),
          "(",
          string.concat(
            list.map(res.search_param, fn(sp) { escape_spname(sp.name) <> "," }),
          ),
          ") -> #(\"",
          res.type_,
          "\", using_params([",
          string.concat(
            list.map(res.search_param, fn(sp) {
              "#(\"" <> sp.name <> "\"," <> escape_spname(sp.name) <> "),"
            }),
          ),
          "]))\n",
        ])
      })
      |> string.concat
    })
    |> string.concat

  let search_type =
    list.map(first_entry.resource.rest, fn(rest) {
      list.map(rest.resource, fn(res) {
        "Sp"
        <> string.capitalise(res.type_)
        <> "("
        <> string.concat(
          list.map(res.search_param, fn(sp) {
            escape_spname(sp.name) <> ": Option(String),"
          }),
        )
        <> ")"
      })
      |> string.concat
    })
    |> string.concat

  let sansio =
    string.concat([
      file_text,
      res_specific_crud,
      "pub type SearchParams {",
      search_type,
      "}",
      "pub fn any_search_req(sp: SearchParams, client: FhirClient) -> Request(String) {
        let #(res_type, params_to_encode) = case sp {",
      search_encode,
      "  }
        let assert Ok(req) =
          request.to(
            string.concat([
              client.baseurl |> uri.to_string,
              \"/\",
              res_type,
              \"?\",
              string.join(params_to_encode, \"&\"),
            ]),
          )
        req
        |> request.set_header(\"Accept\", \"application/fhir+json\")}
        
        fn using_params(params) {
          list.fold(
            from: [],
            over: params,
            with: fn(acc, param: #(String, Option(String))) {
              case param.1 {
                None -> acc
                Some(p) -> [param.0 <> \":\" <> p, ..acc]
              }
            },
          )
        }",
    ])
    |> string.replace("FHIRVERSION", fhir_version)

  //region httpc
  let res_specific_crud =
    gen_specific_crud(
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
    string.concat([file_text, res_specific_crud])
    |> string.replace("FHIRVERSION", fhir_version)

  #(sansio, httpc_layer)
}

// most of the client stuff is generic so you can just write it in codegen_client.txt
// only the wrappers are resource specific, to be type safe rather than strings, and need to be generated
fn gen_specific_crud(entries: List(Entry), template: String) -> String {
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
  |> string.concat
}

fn escape_spname(name: String) -> String {
  string.lowercase(case name {
    "type" -> "type_"
    "use" -> "use_"
    "case" -> "case_"
    _ -> name
  })
  |> string.replace("-", "_")
}
