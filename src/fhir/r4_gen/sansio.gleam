////[https://hl7.org/fhir/r4](https://hl7.org/fhir/r4) r4 sans-io request/response helpers suitable for building clients on top of, such as fhirclient_httpc.gleam and fhirclient_rsvp.gleam

import fhir/r4_gen/resources
import gleam/dynamic/decode
import gleam/http
import gleam/http/request.{type Request, Request}
import gleam/http/response.{type Response}
import gleam/int
import gleam/json.{type Json}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import gleam/uri

import fhir/r4_gen/complex_types
import gleam/bool
import gleam/set

/// FHIR client for sending http requests to server such as
/// `let pat = resources.patient_read("123", client)`
///
/// create client from server base url with fhirclient_new(baseurl)`
///
/// `let assert Ok(client) = sansio.fhirclient_new("r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = sansio.fhirclient_new("https://r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = sansio.fhirclient_new("https://hapi.fhir.org/baser4")`
///
/// `let assert Ok(client) = sansio.fhirclient_new("127.0.0.1:8000")`
pub type FhirClient {
  FhirClient(
    baseurl: uri.Uri,
    basereq: Request(Option(Json)),
    print_sent_requests: Logging,
    print_received_responses: Logging,
  )
}

/// creates a new client from server base url
///
/// `let assert Ok(client) = sansio.fhirclient_new("r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = sansio.fhirclient_new("https://r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = sansio.fhirclient_new("https://hapi.fhir.org/baser4")`
///
/// `let assert Ok(client) = sansio.fhirclient_new("127.0.0.1:8000")`
pub fn fhirclient_new(
  server_base_url in_url: String,
) -> Result(FhirClient, ErrBaseUrl) {
  let in_url = case
    string.starts_with(in_url, "localhost")
    || string.starts_with(in_url, "127.0.0.1")
  {
    False -> in_url
    True -> "http://" <> in_url
  }
  let in_url = case string.starts_with(in_url, "http") {
    True -> in_url
    False -> "https://" <> in_url
  }
  case uri.parse(in_url) {
    Error(_) -> Error(UriParseFail)
    Ok(baseurl) ->
      case baseurl.host {
        None -> Error(UriNoHost)
        Some(host) -> {
          case baseurl.scheme {
            Some("http") -> Ok(create_base_req(http.Http, host, baseurl))
            Some("https") -> Ok(create_base_req(http.Https, host, baseurl))
            _ -> Error(UriNoHttpOrHttps)
          }
        }
      }
  }
}

/// use SMART app access token when making requests with client
pub fn set_access_token(client: FhirClient, token: String) -> FhirClient {
  FhirClient(
    ..client,
    basereq: client.basereq
      |> request.set_header("authorization", "Bearer " <> token),
  )
}

/// a problem with your baseurl in `fhirclient_new(baseurl)`,
/// which you should only see if you have typo in server base url
pub type ErrBaseUrl {
  UriParseFail
  UriNoHttpOrHttps
  UriNoHost
}

pub type Logging {
  LoggingOn
  LoggingOff
}

fn create_base_req(
  scheme: http.Scheme,
  host: String,
  baseurl: uri.Uri,
) -> FhirClient {
  let basereq =
    Request(
      method: http.Get,
      headers: [#("accept", "application/fhir+json")],
      body: None,
      scheme:,
      host:,
      port: baseurl.port,
      path: case string.ends_with(baseurl.path, "/") {
        True -> string.drop_end(baseurl.path, 1)
        False -> baseurl.path
      },
      query: None,
    )
  FhirClient(
    baseurl:,
    basereq:,
    print_sent_requests: LoggingOff,
    print_received_responses: LoggingOff,
  )
}

pub type ErrResp {
  ///got json but could not parse it, probably a missing required field
  ErrParseJson(json.DecodeError)
  ///did not get resource json, often server eg nginx gives basic html response or empty body with http headers/status code
  ErrServer(Response(String))
  ///got operationoutcome error from fhir server
  ErrOperationoutcome(resources.Operationoutcome)
}

/// convert error response to string,
/// either from a server error response
/// or problem parsing server's returned resource
pub fn err_resp_to_string(err: ErrResp) -> String {
  case err {
    ErrServer(err) -> "server error: " <> resp_to_string(err)
    ErrOperationoutcome(err) ->
      case err.issue.rest {
        [] ->
          "OperationOutcome: "
          <> err.issue.first
          |> resources.operationoutcome_issue_to_json
          |> json.to_string
        _ ->
          "OperationOutcome issues: "
          <> [err.issue.first, ..err.issue.rest]
          |> list.map(resources.operationoutcome_issue_to_json)
          |> json.preprocessed_array
          |> json.to_string
      }
    ErrParseJson(err) ->
      "Error parsing returned resource: "
      <> case err {
        json.UnexpectedEndOfInput -> "unexpected end of input"
        json.UnexpectedByte(err) -> "unexpected byte: " <> err
        json.UnexpectedSequence(err) -> "unexpected sequence: " <> err
        json.UnableToDecode(errors) ->
          list.map(errors, fn(error) {
            let decode.DecodeError(expected:, found:, path:) = error
            "expected "
            <> expected
            <> " but found "
            <> found
            <> " at "
            <> string.join(path, "/")
          })
          |> string.join(";")
      }
  }
}

pub type ErrReq {
  ///could not make an update request because resource has no id
  ErrNoId
}

pub const err_req_to_string =
  "the resource you're using has no id, but a resource id is needed for this operation"

pub fn any_create_req(
  resource_json: Json,
  res_type: resources.ResourceType,
  client: FhirClient,
) -> Request(Option(Json)) {
  client.basereq
  |> request.set_path(
    string.concat([
      client.basereq.path,
      "/",
      resources.resource_type_to_string(res_type),
    ]),
  )
  |> request.set_header("Content-Type", "application/fhir+json")
  |> request.set_header("Prefer", "return=representation")
  |> request.set_body(Some(resource_json))
  |> request.set_method(http.Post)
}

pub fn any_read_req(
  id: String,
  res_type: resources.ResourceType,
  client: FhirClient,
) -> Request(Option(Json)) {
  client.basereq
  |> request.set_path(
    string.concat([
      client.basereq.path,
      "/",
      resources.resource_type_to_string(res_type),
      "/",
      id,
    ]),
  )
}

pub fn any_update_req(
  id: Option(String),
  resource_json: Json,
  res_type: resources.ResourceType,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  case id {
    None -> Error(ErrNoId)
    Some(id) ->
      Ok(
        client.basereq
        |> request.set_path(
          string.concat([
            client.basereq.path,
            "/",
            resources.resource_type_to_string(res_type),
            "/",
            id,
          ]),
        )
        |> request.set_header("Content-Type", "application/fhir+json")
        |> request.set_header("Prefer", "return=representation")
        |> request.set_body(Some(resource_json))
        |> request.set_method(http.Put),
      )
  }
}

pub fn any_delete_req(
  id: String,
  res_type: resources.ResourceType,
  client: FhirClient,
) -> Request(Option(Json)) {
  client.basereq
  |> request.set_path(
    string.concat([
      client.basereq.path,
      "/",
      resources.resource_type_to_string(res_type),
      "/",
      id,
    ]),
  )
  |> request.set_method(http.Delete)
}

pub fn any_search_req(
  search_string: String,
  res_type: resources.ResourceType,
  client: FhirClient,
) -> Request(Option(Json)) {
  Request(
    ..client.basereq,
    path: string.concat([
      client.basereq.path,
      "/",
      resources.resource_type_to_string(res_type),
    ]),
    query: Some(search_string),
  )
}

pub fn any_operation_req(
  res_type: resources.ResourceType,
  res_id: Option(String),
  operation_name: String,
  params: Option(resources.Parameters),
  client: FhirClient,
) -> Request(Option(Json)) {
  let path = case res_id {
    Some(res_id) ->
      string.concat([
        client.basereq.path,
        "/",
        resources.resource_type_to_string(res_type),
        "/",
        res_id,
        "/$",
        operation_name,
      ])
    None ->
      string.concat([
        client.basereq.path,
        "/",
        resources.resource_type_to_string(res_type),
        "/$",
        operation_name,
      ])
  }
  let req =
    client.basereq
    |> request.set_path(path)
    |> request.set_header("Content-Type", "application/fhir+json")
    |> request.set_header("Prefer", "return=representation")
  case params {
    None -> req
    Some(params) ->
      req
      |> request.set_body(params |> resources.parameters_to_json |> Some)
      |> request.set_method(http.Post)
  }
}

/// decodes an Ok(resource) of given decoder type
/// or an Error:
/// - decoder error attempting to decode resource
/// - Operationoutcome error
/// - non json http response
pub fn any_response(
  resp: Response(String),
  resource_decoder: decode.Decoder(resource_type),
) -> Result(resource_type, ErrResp) {
  case resp.status < 300 {
    True ->
      resp.body
      |> json.parse(resource_decoder)
      |> result.map_error(ErrParseJson)
    False ->
      Error(case resp.body |> json.parse(resources.operationoutcome_decoder()) {
        Ok(decoded_oo) -> ErrOperationoutcome(decoded_oo)
        Error(_) -> ErrServer(resp)
      })
    // here if operationoutcome fails to decode, we discard the error
    // and instead return response with body as string
    // technically, body might have been a malformed operationoutcome
    // which we could maybe check for with Content-Type header
    // and if it's application/fhir+json then keep operationdecoder outcome
    // that seems fiddly though whereas this is pretty clean
    // and I mean if you have a literal malformed operationoutcome error idk
    // it's an error on an error what are you even going to do with that
  }
}

//
pub fn delete_response(
  resp: Response(String),
) -> Result(OperationoutcomeOrHTTP, ErrResp) {
  case resp.status < 300 {
    True ->
      Ok(case resp.body |> json.parse(resources.operationoutcome_decoder()) {
        Ok(decoded_oo) -> SuccessOperationoutcome(decoded_oo)
        Error(_) -> SuccessHttpResponse(response.Response(..resp, body: Nil))
      })
    False ->
      Error(case resp.body |> json.parse(resources.operationoutcome_decoder()) {
        Ok(decoded_oo) -> ErrOperationoutcome(decoded_oo)
        Error(_) -> ErrServer(resp)
      })
  }
}

pub type OperationoutcomeOrHTTP {
  SuccessOperationoutcome(resources.Operationoutcome)
  SuccessHttpResponse(Response(Nil))
}

pub type PostBundleType {
  /// server executes all operations in transaction as one atomic operation
  Transaction
  /// server executes each operation in batch independently
  /// meaning an operation can fail without stopping other operations
  Batch
}

pub fn batch_req(
  reqs: List(Request(Option(Json))),
  bundle_type: PostBundleType,
  client: FhirClient,
) -> Request(Option(Json)) {
  // each request in list already has serialized json body
  // so we have to construct bundle json as json
  // rather than type safe bundle Bundle variable then serialize
  let base_len = string.length(client.basereq.path) + 1
  // request path is minus server base part
  // eg http://hapi.fhir.org/baseR4/Immunization/123 -> Immunization/123
  let entries =
    reqs
    |> list.map(fn(req) {
      let entry_req =
        json.object([
          #(
            "method",
            case req.method {
              http.Get -> "GET"
              http.Post -> "POST"
              http.Put -> "PUT"
              http.Delete -> "DELETE"
              http.Patch -> "PATCH"
              _ ->
                "invalid http verb which should never happen, you probably called batch_req with reqs created or modified by something other than this module"
            }
              |> json.string,
          ),
          #(
            "url",
            json.string(
              string.drop_start(req.path, base_len)
              <> case req.query {
                None -> ""
                Some(query) -> "?" <> query
              },
            ),
          ),
        ])
      let obj = [#("request", entry_req)]
      let obj = case req.body {
        None -> obj
        Some(resource) -> [#("resource", resource), ..obj]
      }
      json.object(obj)
    })
  let bundle_type = case bundle_type {
    Transaction -> "transaction"
    Batch -> "batch"
  }
  let batch_bundle =
    json.object([
      #("resourceType", json.string("Bundle")),
      #("type", json.string(bundle_type)),
      #("entry", json.preprocessed_array(entries)),
    ])
  client.basereq
  |> request.set_header("Prefer", "return=representation")
  |> request.set_header("Content-Type", "application/fhir+json")
  |> request.set_body(Some(batch_bundle))
  |> request.set_method(http.Post)
}

pub fn bundle_next_page_req(
  bundle: resources.Bundle,
  client: FhirClient,
) -> Result(Request(Option(Json)), Nil) {
  result.try(list.find(bundle.link, fn(l) { l.relation == "next" }), fn(link) {
    result.try(uri.parse(link.url), fn(uri) {
      Ok(Request(..client.basereq, path: uri.path, query: uri.query))
    })
  })
}

pub fn bundle_next_page_req_forgiving(
  bundle: resources.BundleForgiving,
  client: FhirClient,
) -> Result(Request(Option(Json)), Nil) {
  result.try(list.find(bundle.link, fn(l) { l.relation == "next" }), fn(link) {
    result.try(uri.parse(link.url), fn(uri) {
      Ok(Request(..client.basereq, path: uri.path, query: uri.query))
    })
  })
}

pub fn req_to_string(req: Request(Option(Json))) -> String {
  let to_uri = req |> request.to_uri |> uri.to_string
  let method = req.method |> http.method_to_string
  let headers =
    req.headers
    |> list.map(fn(hdr) { hdr.0 <> ": " <> hdr.1 })
    |> string.join("; ")

  //kind of duplicating but want to put body at end and maybe this performs better? idk maybe doesn't matter
  case req.body {
    Some(body) -> [
      "to uri:  " <> to_uri,
      "method:  " <> method,
      "headers: " <> headers,
      "body:    " <> json.to_string(body),
    ]
    None -> [
      "to uri:  " <> to_uri,
      "method:  " <> method,
      "headers: " <> headers,
    ]
  }
  |> string.join("\n")
}

pub fn resp_to_string(resp: Response(String)) -> String {
  let status = resp.status |> int.to_string
  let headers =
    resp.headers
    |> list.map(fn(hdr) { hdr.0 <> ": " <> hdr.1 })
    |> string.join("; ")
  [
    "status:  " <> status,
    "headers: " <> headers,
    "body:    " <> resp.body,
  ]
  |> string.join("\n")
}

pub type SansioValuesetErr {
  ValuesetResponseError(ErrResp)
  ValuesetMissingExpansion
  ValuesetUnexpectedOffset
  ValuesetNestedEntries
  ValuesetIncompleteExpansion
  ValuesetTerminologyChanged
  ValuesetRepeatedCode
  ValuesetMissingSystem
  ValuesetTotalChanged
  ValuesetTotalMismatch
}

/// Progress while collecting a flat ValueSet expansion.
pub opaque type ValuesetExpandState {
  ValuesetExpandState(
    params: resources.Parameters,
    offset: Int,
    total: Option(Int),
    pages: List(List(resources.ValuesetExpansionContains)),
    codes: set.Set(#(String, String)),
    versions: set.Set(
      #(String, Option(resources.ValuesetExpansionParameterValue)),
    ),
  )
}

pub type ValuesetExpandStep {
  ValuesetExpandNext(request: Request(Option(Json)), state: ValuesetExpandState)
  ValuesetExpandDone(value_set: resources.Valueset)
}

/// Start expanding a supplied ValueSet definition, requesting flat pages.
pub fn valueset_expand_req(
  value_set: resources.Valueset,
  client: FhirClient,
) -> ValuesetExpandStep {
  let target = case value_set.compose, value_set.url {
    None, Some(url) -> [
      resources.ParametersParameter(
        ..resources.parameters_parameter_new("url"),
        value: Some(resources.ParametersParameterValueUri(url)),
      ),
      ..case value_set.version {
        None -> []
        Some(version) -> [
          resources.ParametersParameter(
            ..resources.parameters_parameter_new("valueSetVersion"),
            value: Some(resources.ParametersParameterValueString(version)),
          ),
        ]
      }
    ]
    _, _ -> [
      resources.ParametersParameter(
        ..resources.parameters_parameter_new("valueSet"),
        resource: Some(resources.ResourceValueset(value_set)),
      ),
    ]
  }
  let params =
    resources.Parameters(..resources.parameters_new(), parameter: [
      resources.ParametersParameter(
        ..resources.parameters_parameter_new("count"),
        value: Some(resources.ParametersParameterValueInteger(1000)),
      ),
      resources.ParametersParameter(
        ..resources.parameters_parameter_new("excludeNested"),
        value: Some(resources.ParametersParameterValueBoolean(True)),
      ),
      ..target
    ])
  ValuesetExpandNext(
    any_operation_req(
      resources.RtValueset,
      None,
      "expand",
      Some(params),
      client,
    ),
    ValuesetExpandState(
      params:,
      offset: 0,
      total: None,
      pages: [],
      codes: set.new(),
      versions: set.new(),
    ),
  )
}

/// Check a decoded page and return the next request or the combined ValueSet.
pub fn valueset_expand_response(
  value_set: resources.Valueset,
  state: ValuesetExpandState,
  client: FhirClient,
) -> Result(ValuesetExpandStep, SansioValuesetErr) {
  use expansion <- result.try(case value_set.expansion {
    Some(expansion) -> Ok(expansion)
    None -> Error(ValuesetMissingExpansion)
  })
  use <- bool.guard(
    option.unwrap(expansion.offset, state.offset) != state.offset,
    Error(ValuesetUnexpectedOffset),
  )
  use <- bool.guard(
    list.any(expansion.contains, fn(item) { item.contains != [] }),
    Error(ValuesetNestedEntries),
  )
  use <- bool.guard(
    list.any(expansion.extension, fn(extension) {
      extension.url
      == "http://hl7.org/fhir/StructureDefinition/valueset-unclosed"
      && extension.ext
      == complex_types.ExtSimple(complex_types.ExtensionValueBoolean(True))
    }),
    Error(ValuesetIncompleteExpansion),
  )

  let versions =
    expansion.parameter
    |> list.filter(fn(parameter) {
      parameter.name == "used-codesystem" || parameter.name == "used-valueset"
    })
    |> list.map(fn(parameter) { #(parameter.name, parameter.value) })
    |> set.from_list
  use <- bool.guard(
    state.offset > 0 && versions != state.versions,
    Error(ValuesetTerminologyChanged),
  )
  use codes <- result.try(
    list.try_fold(expansion.contains, state.codes, fn(codes, concept) {
      case concept.system, concept.code {
        Some(system), Some(code) -> {
          use <- bool.guard(
            set.contains(codes, #(system, code)),
            Error(ValuesetRepeatedCode),
          )
          Ok(set.insert(codes, #(system, code)))
        }
        None, Some(_) -> Error(ValuesetMissingSystem)
        _, None -> Ok(codes)
      }
    }),
  )

  let received = list.length(expansion.contains)
  let next_offset = state.offset + received
  use <- bool.guard(
    state.total != None
      && expansion.total != None
      && state.total != expansion.total,
    Error(ValuesetTotalChanged),
  )
  let total = case expansion.total {
    Some(_) -> expansion.total
    None -> state.total
  }
  use more <- result.try(case total {
    Some(total) -> {
      use <- bool.guard(
        next_offset > total || { received == 0 && next_offset < total },
        Error(ValuesetTotalMismatch),
      )
      Ok(next_offset < total)
    }
    None -> Ok(received > 0)
  })

  let pages = [expansion.contains, ..state.pages]
  case more {
    True -> {
      let params =
        resources.Parameters(..state.params, parameter: [
          resources.ParametersParameter(
            ..resources.parameters_parameter_new("offset"),
            value: Some(resources.ParametersParameterValueInteger(next_offset)),
          ),
          ..state.params.parameter
        ])
      Ok(ValuesetExpandNext(
        any_operation_req(
          resources.RtValueset,
          None,
          "expand",
          Some(params),
          client,
        ),
        ValuesetExpandState(
          ..state,
          offset: next_offset,
          total:,
          pages:,
          codes:,
          versions:,
        ),
      ))
    }
    False -> {
      let contains =
        list.fold(pages, [], fn(acc, items) { list.append(items, acc) })
      Ok(ValuesetExpandDone(
        resources.Valueset(
          ..value_set,
          expansion: Some(
            resources.ValuesetExpansion(
              ..expansion,
              contains:,
              total: Some(next_offset),
              offset: None,
              parameter: list.filter(expansion.parameter, fn(parameter) {
                parameter.name != "offset" && parameter.name != "count"
              }),
            ),
          ),
        ),
      ))
    }
  }
}

pub type GroupedResources {
  GroupedResources(
    bundle: List(resources.Bundle),
    codesystem: List(resources.Codesystem),
    operationoutcome: List(resources.Operationoutcome),
    valueset: List(resources.Valueset),
  )
}

pub fn groupedresources_new() -> GroupedResources {
  GroupedResources(
    bundle: [],
    codesystem: [],
    operationoutcome: [],
    valueset: [],
  )
}

pub fn bundle_to_groupedresources(
  from bundle: resources.Bundle,
) -> GroupedResources {
  list.fold(
    from: groupedresources_new(),
    over: bundle.entry,
    with: fn(acc, entry) {
      case entry.resource {
        None -> acc
        Some(res) ->
          case res {
            resources.ResourceBundle(r) ->
              GroupedResources(..acc, bundle: [r, ..acc.bundle])
            resources.ResourceCodesystem(r) ->
              GroupedResources(..acc, codesystem: [r, ..acc.codesystem])
            resources.ResourceOperationoutcome(r) ->
              GroupedResources(..acc, operationoutcome: [
                r,
                ..acc.operationoutcome
              ])
            resources.ResourceValueset(r) ->
              GroupedResources(..acc, valueset: [r, ..acc.valueset])
            _ -> acc
          }
      }
    },
  )
}
