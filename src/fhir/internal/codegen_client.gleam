import filepath
import gleam/dynamic/decode
import gleam/json
import gleam/list
import gleam/option.{type Option, None, Some}

//import gleam/set
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
  let type_ = case type_ {
    "List" -> "Listfhir"
    _ -> type_
  }
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

// pub type Operationdefinition {
//   Operationdefinition(
//     url: Option(String),
//     name: String,
//     parameter: List(OperationdefinitionParameter),
//   )
// }

// fn operationdefinition_decoder() -> decode.Decoder(Operationdefinition) {
//   use rt <- decode.field("resourceType", decode.string)
//   case rt {
//     "OperationDefinition" -> {
//       use url <- decode.field("url", decode.optional(decode.string))
//       use name <- decode.field("name", decode.string)
//       use parameter <- decode.field(
//         "parameter",
//         decode.list(operationdefinition_parameter_decoder()),
//       )
//       decode.success(Operationdefinition(url:, name:, parameter:))
//     }
//     _ -> decode.success(Operationdefinition(url: None, name: "", parameter: []))
//   }
// }

// pub type OperationdefinitionParameter {
//   OperationdefinitionParameter(
//     name: String,
//     use_: String,
//     min: Int,
//     max: String,
//     type_: Option(String),
//   )
// }

// fn operationdefinition_parameter_decoder() -> decode.Decoder(
//   OperationdefinitionParameter,
// ) {
//   use name <- decode.field("name", decode.string)
//   use use_ <- decode.field("use", decode.string)
//   use min <- decode.field("min", decode.int)
//   use max <- decode.field("max", decode.string)
//   use type_ <- decode.optional_field(
//     "type",
//     None,
//     decode.optional(decode.string),
//   )
//   decode.success(OperationdefinitionParameter(name:, use_:, min:, max:, type_:))
// }

// type OpdefBundle {
//   OpdefBundle(entry: List(OpdefEntry))
// }

// fn opdef_bundle_decoder() -> decode.Decoder(OpdefBundle) {
//   use entry <- decode.field("entry", decode.list(opdef_entry_decoder()))
//   decode.success(OpdefBundle(entry:))
// }

// type OpdefEntry {
//   OpdefEntry(resource: Operationdefinition)
// }

// fn opdef_entry_decoder() -> decode.Decoder(OpdefEntry) {
//   use resource <- decode.field("resource", operationdefinition_decoder())
//   decode.success(OpdefEntry(resource:))
// }

pub fn gen(spec_file spec_file: String, fv fhir_version: String) {
  let assert Ok(spec) = simplifile.read(spec_file)
    as "spec files should all be downloaded in src/fhir/internal/downloads/{r4 r4b r5}, run with download arg if not"
  // you could use generated bundle decoder here
  // however actordefinition in r4 but not r5
  // and it is much slower than this
  // both real downsides, oh well
  let assert Ok(bundle) = json.parse(from: spec, using: bundle_decoder())

  // will use res_names for operation parameters
  // as each param is value (primitive, lowercase), Resource (in set), or part
  // let res_names =
  //   list.filter_map(bundle.entry, fn(e) {
  //     case e.resource.kind {
  //       Some("resource") -> Ok(e.resource.name)
  //       _ -> Error(Nil)
  //     }
  //   })
  //   |> set.from_list
  // let assert Ok(opdef_bundle) =
  //   json.parse(from: spec, using: opdef_bundle_decoder())
  // let opdef_entries =
  //   list.filter(opdef_bundle.entry, fn(e) { e.resource.url != None })
  // let droplen = string.length("http://hl7.org/fhir/OperationDefinition/")
  // let idk =
  //   list.map(opdef_entries, fn(e) {
  //     let assert Some(url) = e.resource.url
  //     let assert Ok(op) =
  //       url |> string.drop_start(droplen) |> string.split_once("-")
  //     echo url
  //     list.map(e.resource.parameter, fn(param) {
  //       echo param.name
  //       echo param.type_
  //       echo "ok"
  //       let param_type = case is_capital(param.name) {
  //         True -> {
  //           let assert Some(typ) = param.type_
  //           "value" <> typ
  //         }
  //         False ->
  //           case set.contains(res_names, param.name) {
  //             True -> {
  //               echo param.name
  //               "resource"
  //             }
  //             False -> {
  //               //echo param.name
  //               "part"
  //             }
  //           }
  //       }
  //     })
  //   })
  //struggling atm with providing typed parameter list, but could maybe use this to generate it

  let entries =
    list.filter(bundle.entry, fn(e) {
      case e.resource.kind, e.resource.name {
        // _, "AllergyIntolerance" -> True
        // _, _ -> False
        // debug: uncomment to try just allergyintolerance
        _, "Base" -> False
        _, "BackboneElement" -> False
        _, "Resource" -> False
        _, "CanonicalResource" -> False
        _, "MetadataResource" -> False
        _, "DomainResource" -> False
        _, "Parameters" -> False
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
    |> filepath.join("fhir")
    |> filepath.join("internal")
    |> filepath.join("codegen_client_sansio.txt")
    |> simplifile.read

  //first entry in bundle has all the search param info
  let assert [first_entry, ..] = bundle.entry
  let search_encode =
    list.map(first_entry.resource.rest, fn(rest) {
      list.map(rest.resource, fn(res) {
        let #(name_lower, name_capital) = #(
          string.lowercase(res.type_),
          string.capitalise(res.type_),
        )
        let sp_arg = case res.search_param {
          [] -> "_sp"
          _ -> "sp"
        }
        string.concat([
          "pub fn ",
          name_lower,
          "_search_req(",
          sp_arg,
          ": Sp",
          name_capital,
          ", client: FhirClient) {
            let params = using_params([",
          string.concat(
            list.map(res.search_param, fn(sp) {
              "#(\"" <> sp.name <> "\", sp." <> escape_spname(sp.name) <> "),"
            }),
          ),
          "])
            any_search_req(params, \"",
          res.type_,
          "\", client)
          }",
        ])
      })
      |> string.concat
    })
    |> string.concat

  let search_type =
    list.map(first_entry.resource.rest, fn(rest) {
      list.map(rest.resource, fn(res) {
        let name_capital = string.capitalise(res.type_)
        "pub type Sp"
        <> name_capital
        <> "{"
        <> "Sp"
        <> name_capital
        <> "("
        //        <> "include: Option(SpInclude),"
        // ngl not sure how to do everything for type safe search params; might wait until someone asks
        // providing search_any_string pub fns in httpc and rsvp clients for now
        <> string.concat(
          list.map(res.search_param, fn(sp) {
            escape_spname(sp.name) <> ": Option(String),"
          }),
        )
        <> ")}"
      })
      |> string.concat
    })
    |> string.concat

  let search_type_new =
    list.map(first_entry.resource.rest, fn(rest) {
      list.map(rest.resource, fn(res) {
        let #(name_lower, name_capital) = #(
          string.lowercase(res.type_),
          string.capitalise(res.type_),
        )
        "pub fn sp_"
        <> name_lower
        <> "_new(){Sp"
        <> name_capital
        //+1 to list.length(res.search_param) if you want includes
        <> {
          let len = list.length(res.search_param)
          case len {
            0 -> ""
            len -> "(" <> string.concat(list.repeat("None,", len)) <> ")"
          }
        }
        <> "}"
      })
      |> string.concat
    })
    |> string.concat

  let include_type =
    string.concat(
      list.map(first_entry.resource.rest, fn(rest) {
        string.concat(
          list.map(rest.resource, fn(res) {
            string.concat([
              "inc_",
              string.lowercase(res.type_),
              ": Option(SpInclude),revinc_",
              string.lowercase(res.type_),
              ": Option(SpInclude),",
            ])
          }),
        )
      }),
    )
  let include_type = "pub type SpInclude {SpInclude(" <> include_type <> ")}"

  let grouped_type =
    string.concat(
      list.map(first_entry.resource.rest, fn(rest) {
        string.concat(
          list.map(rest.resource, fn(res) {
            let #(name_lower, name_capital) = #(
              string.lowercase(res.type_),
              string.capitalise(res.type_),
            )
            name_lower <> ": List(FHIRVERSION." <> name_capital <> "),"
          }),
        )
      }),
    )
  let grouped_type = "
  pub type GroupedResources{
    GroupedResources(" <> grouped_type <> ")
  }"

  let grouped_type_new =
    string.concat(
      list.map(first_entry.resource.rest, fn(rest) {
        string.concat(
          list.map(rest.resource, fn(res) {
            let name_lower = string.lowercase(res.type_)
            name_lower <> ": [],"
          }),
        )
      }),
    )
  let grouped_type_new =
    "pub fn groupedresources_new(){GroupedResources("
    <> grouped_type_new
    <> ")}"

  let bundle_to_gt =
    string.concat(
      list.map(first_entry.resource.rest, fn(rest) {
        string.concat(
          list.map(rest.resource, fn(res) {
            let #(name_lower, name_capital) = #(
              string.lowercase(res.type_),
              string.capitalise(res.type_),
            )
            "FHIRVERSION.Resource"
            <> name_capital
            <> "(r) -> GroupedResources(..acc, "
            <> name_lower
            <> ": [r, ..acc. "
            <> name_lower
            <> "])"
          }),
        )
      }),
    )

  // "r4.ResourceAccount(r) ->
  //   GroupedResources(..acc, account: [r, ..acc.account])"
  let bundle_to_gt =
    "pub fn bundle_to_groupedresources(from bundle: FHIRVERSION.Bundle) {
      list.fold(from: groupedresources_new(), over: bundle.entry, with: fn(acc, entry) {
        case entry.resource {
          None -> acc
          Some(res) ->
            case res {" <> bundle_to_gt <> "
            _ -> acc
            }
        }
      })
    }"

  let sansio =
    string.concat([
      file_text,
      res_specific_crud,
      search_type,
      search_type_new,
      include_type,
      grouped_type,
      grouped_type_new,
      search_encode,
      bundle_to_gt,
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
            ) -> Result(FHIRVERSION.NAMECAPITAL, Err) {
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
            ) -> Result(FHIRVERSION.NAMECAPITAL, Err) {
              any_read(id, client, \"NAMEUPPER\", FHIRVERSION.NAMELOWER_decoder())
            }

            pub fn NAMELOWER_update(
              resource: FHIRVERSION.NAMECAPITAL,
              client: FhirClient,
            ) -> Result(FHIRVERSION.NAMECAPITAL, Err) {
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
            ) -> Result(FHIRVERSION.Operationoutcome, Err) {
              any_delete(resource.id, \"NAMEUPPER\", client)
            }

            pub fn NAMELOWER_search_bundled(sp: FHIRVERSION_sansio.SpNAMECAPITAL, client: FhirClient) {
              let req = FHIRVERSION_sansio.NAMELOWER_search_req(sp, client)
              sendreq_parseresource(req, FHIRVERSION.bundle_decoder())
            }

            pub fn NAMELOWER_search(sp: FHIRVERSION_sansio.SpNAMECAPITAL, client: FhirClient) -> Result(List(FHIRVERSION.NAMECAPITAL), Err) {
              let req = FHIRVERSION_sansio.NAMELOWER_search_req(sp, client)
              sendreq_parseresource(req, FHIRVERSION.bundle_decoder())
              |> result.map(fn(bundle) {
                { bundle |> FHIRVERSION_sansio.bundle_to_groupedresources }.NAMELOWER
              })
            }
            ",
    )

  let assert Ok(file_text) =
    "src"
    |> filepath.join("fhir")
    |> filepath.join("internal")
    |> filepath.join("codegen_client_httpc.txt")
    |> simplifile.read
  let httpc_layer =
    string.concat([file_text, res_specific_crud])
    |> string.replace("FHIRVERSION", fhir_version)

  let rsvp_res_specific_crud =
    gen_specific_crud(
      entries,
      "
            pub fn NAMELOWER_create(
              resource: FHIRVERSION.NAMECAPITAL,
              client: FhirClient,
              handle_response: fn(Result(FHIRVERSION.NAMECAPITAL, Err)) -> a,
            ) -> Effect(a) {
              any_create(
                FHIRVERSION.NAMELOWER_to_json(resource),
                \"NAMEUPPER\",
                FHIRVERSION.NAMELOWER_decoder(),
                client,
                handle_response,
              )
            }

            pub fn NAMELOWER_read(
              id: String,
              client: FhirClient,
              handle_response: fn(Result(FHIRVERSION.NAMECAPITAL, Err)) -> a,
            ) -> Effect(a) {
              any_read(id, \"NAMEUPPER\", FHIRVERSION.NAMELOWER_decoder(), client, handle_response)
            }

            pub fn NAMELOWER_update(
              resource: FHIRVERSION.NAMECAPITAL,
              client: FhirClient,
              handle_response: fn(Result(FHIRVERSION.NAMECAPITAL, Err)) -> a,
            ) -> Result(Effect(a), ErrNoId) {
              any_update(
                resource.id,
                FHIRVERSION.NAMELOWER_to_json(resource),
                \"NAMEUPPER\",
                FHIRVERSION.NAMELOWER_decoder(),
                client,
                handle_response,
              )
            }

            pub fn NAMELOWER_delete(
              resource: FHIRVERSION.NAMECAPITAL,
              client: FhirClient,
              handle_response: fn(Result(FHIRVERSION.Operationoutcome, Err)) -> a,
            ) -> Result(Effect(a), ErrNoId) {
              any_delete(resource.id, \"NAMEUPPER\", client, handle_response)
            }

            pub fn NAMELOWER_search_bundled(
              search_for search_args: FHIRVERSION_sansio.SpNAMECAPITAL,
              with_client client: FhirClient,
              response_msg handle_response: fn(Result(FHIRVERSION.Bundle, Err)) -> msg,
            ) -> Effect(msg) {
              let req = FHIRVERSION_sansio.NAMELOWER_search_req(search_args, client)
              sendreq_handleresponse(req, FHIRVERSION.bundle_decoder(), handle_response)
            }

            pub fn NAMELOWER_search(
              search_for search_args: FHIRVERSION_sansio.SpNAMECAPITAL,
              with_client client: FhirClient,
              response_msg handle_response: fn(Result(List(FHIRVERSION.NAMECAPITAL), Err)) -> msg,
            ) -> Effect(msg) {
              let req = FHIRVERSION_sansio.NAMELOWER_search_req(search_args, client)
              sendreq_handleresponse_andprocess(
                req,
                FHIRVERSION.bundle_decoder(),
                handle_response,
                fn(bundle) { { bundle |> FHIRVERSION_sansio.bundle_to_groupedresources }.NAMELOWER },
              )
            }
            ",
    )

  let assert Ok(file_text) =
    "src"
    |> filepath.join("fhir")
    |> filepath.join("internal")
    |> filepath.join("codegen_client_rsvp.txt")
    |> simplifile.read
  let rsvp_layer =
    string.concat([file_text, rsvp_res_specific_crud])
    |> string.replace("FHIRVERSION", fhir_version)

  #(sansio, httpc_layer, rsvp_layer)
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

pub fn is_capital(s: String) -> Bool {
  let assert [first, ..] = string.to_graphemes(s)
  string.capitalise(first) == first
}
