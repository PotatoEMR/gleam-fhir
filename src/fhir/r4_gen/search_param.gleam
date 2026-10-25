////[https://hl7.org/fhir/r4](https://hl7.org/fhir/r4) r4 search params

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string

pub fn to_string(params: List(#(String, Option(String)))) -> String {
  list.fold(
    from: [],
    over: params,
    with: fn(acc, param: #(String, Option(String))) {
      case param.1 {
        None -> acc
        Some(p) -> [param.0 <> "=" <> p, ..acc]
      }
    },
  )
  |> string.join("&")
}

pub type Bundle {
  Bundle(
    identifier: Option(String),
    composition: Option(String),
    type_: Option(String),
    message: Option(String),
    timestamp: Option(String),
  )
}

pub type Codesystem {
  Codesystem(
    date: Option(String),
    identifier: Option(String),
    code: Option(String),
    context_type_value: Option(String),
    content_mode: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    context_type: Option(String),
    language: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    supplements: Option(String),
    system: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type Operationoutcome {
  Operationoutcome
}

pub type Valueset {
  Valueset(
    date: Option(String),
    identifier: Option(String),
    code: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    context_type: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    expansion: Option(String),
    reference: Option(String),
    context_quantity: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub fn bundle_new() -> Bundle {
  Bundle(None, None, None, None, None)
}

pub fn codesystem_new() -> Codesystem {
  Codesystem(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn operationoutcome_new() -> Operationoutcome {
  Operationoutcome
}

pub fn valueset_new() -> Valueset {
  Valueset(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}
