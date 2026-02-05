import fhir/r4_sansio
import gleam/http
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/httpc
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import gleam/uri

pub type OpPatientEverything {
  OpPatientEverything(
    start: Option(String),
    end: Option(String),
    since_: Option(String),
    type_: Option(String),
    count_: Option(String),
  )
}

pub fn op_patient_everything_new() {
  OpPatientEverything(
    start: None,
    end: None,
    since_: None,
    type_: None,
    count_: None,
  )
}

pub fn main() {
  let client = r4_sansio.fhirclient_new("https://r4.smarthealthit.org/")
  let res_type = "Patient"
  let operation = "$everything"
  let id = "0b8d3c83-93f8-4f9a-b711-96b7d2e13264"
  let op_params =
    OpPatientEverything(
      ..op_patient_everything_new(),
      start: Some("2013-04-23"),
    )
  let params =
    using_params([
      #("start", op_params.start),
      #("end", op_params.end),
      #("_since", op_params.since_),
      #("_type", op_params.type_),
      #("_count", op_params.count_),
    ])
  let assert Ok(req) =
    request.to(string.join(
      [client.baseurl |> uri.to_string, res_type, id, operation],
      "/",
    ))
  let req = req |> request.set_query(params)

  let resp = httpc.send(req)
  echo resp
}

// create a ParametersParameter list from the given name + string from value/resource/part
// requiring string to come in as a string because it would be too many types to
fn using_params(
  params: List(#(String, Option(String))),
) -> List(#(String, String)) {
  list.fold(
    from: [],
    over: params,
    with: fn(acc, param: #(String, Option(String))) {
      case param.1 {
        None -> acc
        Some(p) -> [#(param.0, p), ..acc]
      }
    },
  )
}
// technically this would work too
// fn using_params(
//   params: List(#(String, Option(String))),
// ) -> List(#(String, String)) {
//   list.filter_map(params, fn(param: #(String, Option(String))) {
//     case param.1 {
//       None -> Error(Nil)
//       Some(p) -> Ok(#(param.0, p))
//     }
//   })
// }
