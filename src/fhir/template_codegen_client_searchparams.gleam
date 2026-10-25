pub const source =
  "////[https://hl7.org/fhir/FHIRVERSION](https://hl7.org/fhir/FHIRVERSION) FHIRVERSION search params

import gleam/list
import gleam/uri
import gleam/option.{type Option, Some, None}

pub fn to_string(params: List(#(String, Option(String)))) -> String {
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
  |> list.reverse
  |> uri.query_to_string
}
"
