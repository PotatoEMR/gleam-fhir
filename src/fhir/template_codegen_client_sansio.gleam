pub const source =
  "////[https://hl7.org/fhir/FHIRVERSION](https://hl7.org/fhir/FHIRVERSION) FHIRVERSION sans-io request/response helpers suitable for building clients on top of, such as fhirclient_httpc.gleam and fhirclient_rsvp.gleam

import fhir/FHIRVERSION/resource
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
//FHIR_VERSION_IMPORTS

/// FHIR client for sending http requests to server such as
/// `let pat = resource.patient_read(\"123\", client)`
///
/// create client from server base url with fhirclient_new(base_url)`
///
/// `let assert Ok(client) = sansio.fhirclient_new(\"FHIRVERSION.smarthealthit.org/\")`
///
/// `let assert Ok(client) = sansio.fhirclient_new(\"https://FHIRVERSION.smarthealthit.org/\")`
///
/// `let assert Ok(client) = sansio.fhirclient_new(\"https://hapi.fhir.org/baseFHIRVERSION\")`
///
/// `let assert Ok(client) = sansio.fhirclient_new(\"127.0.0.1:8000\")`
pub type FhirClient {
  FhirClient(
    base_url: uri.Uri,
    base_request: Request(Option(Json)),
    print_sent_requests: Logging,
    print_received_responses: Logging,
  )
}

/// creates a new client from server base url
///
/// `let assert Ok(client) = sansio.fhirclient_new(\"FHIRVERSION.smarthealthit.org/\")`
///
/// `let assert Ok(client) = sansio.fhirclient_new(\"https://FHIRVERSION.smarthealthit.org/\")`
///
/// `let assert Ok(client) = sansio.fhirclient_new(\"https://hapi.fhir.org/baseFHIRVERSION\")`
///
/// `let assert Ok(client) = sansio.fhirclient_new(\"127.0.0.1:8000\")`
pub fn fhirclient_new(
  server_base_url in_url: String,
) -> Result(FhirClient, ErrBaseUrl) {
  let in_url = case
    string.starts_with(in_url, \"localhost\")
    || string.starts_with(in_url, \"127.0.0.1\")
  {
    False -> in_url
    True -> \"http://\" <> in_url
  }
  let in_url = case string.starts_with(in_url, \"http\") {
    True -> in_url
    False -> \"https://\" <> in_url
  }
  case uri.parse(in_url) {
    Error(_) -> Error(UriParseFail)
    Ok(base_url) ->
      case base_url.host {
        None -> Error(UriNoHost)
        Some(host) -> {
          case base_url.scheme {
            Some(\"http\") -> Ok(create_base_request(http.Http, host, base_url))
            Some(\"https\") -> Ok(create_base_request(http.Https, host, base_url))
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
    base_request: client.base_request
      |> request.set_header(\"authorization\", \"Bearer \" <> token),
  )
}

/// a problem with your base_url in `fhirclient_new(base_url)`,
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

fn create_base_request(
  scheme: http.Scheme,
  host: String,
  base_url: uri.Uri,
) -> FhirClient {
  let base_request =
    Request(
      method: http.Get,
      headers: [#(\"accept\", \"application/fhir+json\")],
      body: None,
      scheme:,
      host:,
      port: base_url.port,
      path: case string.ends_with(base_url.path, \"/\") {
        True -> string.drop_end(base_url.path, 1)
        False -> base_url.path
      },
      query: None,
    )
  FhirClient(
    base_url:,
    base_request:,
    print_sent_requests: LoggingOff,
    print_received_responses: LoggingOff,
  )
}

pub type ErrResponse {
  ///got json but could not parse it, probably a missing required field
  ErrParseJson(json.DecodeError)
  ///did not get resource json, often server eg nginx gives basic html response or empty body with http headers/status code
  ErrServer(Response(String))
  ///got operationoutcome error from fhir server
  ErrOperationoutcome(resource.Operationoutcome)
}

/// convert error response to string,
/// either from a server error response
/// or problem parsing server's returned resource
pub fn err_response_to_string(err: ErrResponse) -> String {
  case err {
    ErrServer(err) -> \"server error: \" <> response_to_string(err)
    ErrOperationoutcome(err) ->
      case err.issue.rest {
        [] ->
          \"OperationOutcome: \"
          <> err.issue.first
          |> resource.operationoutcome_issue_to_json
          |> json.to_string
        _ ->
          \"OperationOutcome issues: \"
          <> [err.issue.first, ..err.issue.rest]
          |> list.map(resource.operationoutcome_issue_to_json)
          |> json.preprocessed_array
          |> json.to_string
      }
    ErrParseJson(err) ->
      \"Error parsing returned resource: \"
      <> case err {
        json.UnexpectedEndOfInput -> \"unexpected end of input\"
        json.UnexpectedByte(err) -> \"unexpected byte: \" <> err
        json.UnexpectedSequence(err) -> \"unexpected sequence: \" <> err
        json.UnableToDecode(errors) ->
          list.map(errors, fn(error) {
            let decode.DecodeError(expected:, found:, path:) = error
            \"expected \"
            <> expected
            <> \" but found \"
            <> found
            <> \" at \"
            <> string.join(path, \"/\")
          })
          |> string.join(\";\")
      }
  }
}

pub type ErrRequest {
  ///could not make an update request because resource has no id
  ErrNoId
}

pub const err_request_to_string = \"the resource you're using has no id, but a resource id is needed for this operation\"

pub fn any_create_request(
  resource_json: Json,
  resource_type: resource.ResourceType,
  client: FhirClient,
) -> Request(Option(Json)) {
  client.base_request
  |> request.set_path(
    string.concat([
      client.base_request.path,
      \"/\",
      resource.resource_type_to_string(resource_type),
    ]),
  )
  |> request.set_header(\"Content-Type\", \"application/fhir+json\")
  |> request.set_header(\"Prefer\", \"return=representation\")
  |> request.set_body(Some(resource_json))
  |> request.set_method(http.Post)
}

pub fn any_read_request(
  id: String,
  resource_type: resource.ResourceType,
  client: FhirClient,
) -> Request(Option(Json)) {
  client.base_request
  |> request.set_path(
    string.concat([
      client.base_request.path,
      \"/\",
      resource.resource_type_to_string(resource_type),
      \"/\",
      id,
    ]),
  )
}

pub fn any_update_request(
  id: Option(String),
  resource_json: Json,
  resource_type: resource.ResourceType,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrRequest) {
  case id {
    None -> Error(ErrNoId)
    Some(id) ->
      Ok(
        client.base_request
        |> request.set_path(
          string.concat([
            client.base_request.path,
            \"/\",
            resource.resource_type_to_string(resource_type),
            \"/\",
            id,
          ]),
        )
        |> request.set_header(\"Content-Type\", \"application/fhir+json\")
        |> request.set_header(\"Prefer\", \"return=representation\")
        |> request.set_body(Some(resource_json))
        |> request.set_method(http.Put),
      )
  }
}

pub fn any_delete_request(
  id: String,
  resource_type: resource.ResourceType,
  client: FhirClient,
) -> Request(Option(Json)) {
  client.base_request
  |> request.set_path(
    string.concat([
      client.base_request.path,
      \"/\",
      resource.resource_type_to_string(resource_type),
      \"/\",
      id,
    ]),
  )
  |> request.set_method(http.Delete)
}

pub fn any_search_request(
  search_string: String,
  resource_type: resource.ResourceType,
  client: FhirClient,
) -> Request(Option(Json)) {
  Request(
    ..client.base_request,
    path: string.concat([
      client.base_request.path,
      \"/\",
      resource.resource_type_to_string(resource_type),
    ]),
    query: Some(search_string),
  )
}

pub fn any_operation_request(
  resource_type: resource.ResourceType,
  resource_id: Option(String),
  operation_name: String,
  params: Option(resource.Parameters),
  client: FhirClient,
) -> Request(Option(Json)) {
  let path = case resource_id {
    Some(resource_id) ->
      string.concat([
        client.base_request.path,
        \"/\",
        resource.resource_type_to_string(resource_type),
        \"/\",
        resource_id,
        \"/$\",
        operation_name,
      ])
    None ->
      string.concat([
        client.base_request.path,
        \"/\",
        resource.resource_type_to_string(resource_type),
        \"/$\",
        operation_name,
      ])
  }
  let http_request =
    client.base_request
    |> request.set_path(path)
    |> request.set_header(\"Content-Type\", \"application/fhir+json\")
    |> request.set_header(\"Prefer\", \"return=representation\")
  case params {
    None -> http_request
    Some(params) ->
      http_request
      |> request.set_body(params |> resource.parameters_to_json |> Some)
      |> request.set_method(http.Post)
  }
}

/// decodes an Ok(resource) of given decoder type
/// or an Error:
/// - decoder error attempting to decode resource
/// - Operationoutcome error
/// - non json http response
pub fn any_response(
  http_response: Response(String),
  resource_decoder: decode.Decoder(resource_type),
) -> Result(resource_type, ErrResponse) {
  case http_response.status < 300 {
    True ->
      http_response.body
      |> json.parse(resource_decoder)
      |> result.map_error(ErrParseJson)
    False ->
      Error(case http_response.body |> json.parse(resource.operationoutcome_decoder()) {
        Ok(decoded_operation_outcome) -> ErrOperationoutcome(decoded_operation_outcome)
        Error(_) -> ErrServer(http_response)
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
  http_response: Response(String),
) -> Result(OperationoutcomeOrHttp, ErrResponse) {
  case http_response.status < 300 {
    True ->
      Ok(case http_response.body |> json.parse(resource.operationoutcome_decoder()) {
        Ok(decoded_operation_outcome) -> SuccessOperationoutcome(decoded_operation_outcome)
        Error(_) -> SuccessHttpResponse(response.Response(..http_response, body: Nil))
      })
    False ->
      Error(case http_response.body |> json.parse(resource.operationoutcome_decoder()) {
        Ok(decoded_operation_outcome) -> ErrOperationoutcome(decoded_operation_outcome)
        Error(_) -> ErrServer(http_response)
      })
  }
}

pub type OperationoutcomeOrHttp {
  SuccessOperationoutcome(resource.Operationoutcome)
  SuccessHttpResponse(Response(Nil))
}

pub type PostBundleType {
  /// server executes all operations in transaction as one atomic operation
  Transaction
  /// server executes each operation in batch independently
  /// meaning an operation can fail without stopping other operations
  Batch
}

pub fn batch_request(
  http_requests: List(Request(Option(Json))),
  bundle_type: PostBundleType,
  client: FhirClient,
) -> Request(Option(Json)) {
  // each request in list already has serialized json body
  // so we have to construct bundle json as json
  // rather than type safe bundle Bundle variable then serialize
  let base_path_length = string.length(client.base_request.path) + 1
  // request path is minus server base part
  // eg http://hapi.fhir.org/baseR4/Immunization/123 -> Immunization/123
  let entries =
    http_requests
    |> list.map(fn(http_request) {
      let entry_request =
        json.object([
          #(
            \"method\",
            case http_request.method {
              http.Get -> \"GET\"
              http.Post -> \"POST\"
              http.Put -> \"PUT\"
              http.Delete -> \"DELETE\"
              http.Patch -> \"PATCH\"
              _ ->
                \"invalid http verb which should never happen, you probably called batch_request with http_requests created or modified by something other than this module\"
            }
              |> json.string,
          ),
          #(\"url\", json.string(
            string.drop_start(http_request.path, base_path_length) <> case http_request.query {
              None -> \"\"
              Some(query) -> \"?\" <> query
            },
          )),
        ])
      let entry_fields = [#(\"request\", entry_request)]
      let entry_fields = case http_request.body {
        None -> entry_fields
        Some(resource) -> [#(\"resource\", resource), ..entry_fields]
      }
      json.object(entry_fields)
    })
  let bundle_type = case bundle_type {
    Transaction -> \"transaction\"
    Batch -> \"batch\"
  }
  let batch_bundle =
    json.object([
      #(\"resourceType\", json.string(\"Bundle\")),
      #(\"type\", json.string(bundle_type)),
      #(\"entry\", json.preprocessed_array(entries)),
    ])
  client.base_request
  |> request.set_header(\"Prefer\", \"return=representation\")
  |> request.set_header(\"Content-Type\", \"application/fhir+json\")
  |> request.set_body(Some(batch_bundle))
  |> request.set_method(http.Post)
}

pub fn bundle_next_page_request(
  bundle: resource.Bundle,
  client: FhirClient,
) -> Result(Request(Option(Json)), Nil) {
  result.try(list.find(bundle.link, fn(l) { NEXTRELATION == \"next\" }), fn(link) {
    result.try(uri.parse(link.url), fn(uri) {
      Ok(Request(..client.base_request, path: uri.path, query: uri.query))
    })
  })
}

pub fn bundle_next_page_request_forgiving(
  bundle: resource.BundleForgiving,
  client: FhirClient,
) -> Result(Request(Option(Json)), Nil) {
  result.try(list.find(bundle.link, fn(l) { NEXTRELATION == \"next\" }), fn(link) {
    result.try(uri.parse(link.url), fn(uri) {
      Ok(Request(..client.base_request, path: uri.path, query: uri.query))
    })
  })
}

pub fn request_to_string(http_request: Request(Option(Json))) -> String {
  let to_uri = http_request |> request.to_uri |> uri.to_string
  let method = http_request.method |> http.method_to_string
  let headers =
    http_request.headers
    |> list.map(fn(header) { header.0 <> \": \" <> header.1 })
    |> string.join(\"; \")

  //kind of duplicating but want to put body at end and maybe this performs better? idk maybe doesn't matter
  case http_request.body {
    Some(body) -> [
      \"to uri:  \" <> to_uri,
      \"method:  \" <> method,
      \"headers: \" <> headers,
      \"body:    \" <> json.to_string(body),
    ]
    None -> [
      \"to uri:  \" <> to_uri,
      \"method:  \" <> method,
      \"headers: \" <> headers,
    ]
  }
  |> string.join(\"\\n\")
}

pub fn response_to_string(http_response: Response(String)) -> String {
  let status = http_response.status |> int.to_string
  let headers =
    http_response.headers
    |> list.map(fn(header) { header.0 <> \": \" <> header.1 })
    |> string.join(\"; \")
  [
    \"status:  \" <> status,
    \"headers: \" <> headers,
    \"body:    \" <> http_response.body,
  ]
  |> string.join(\"\\n\")
}
"

pub const valueset_expand =
  "
pub type SansioValuesetErr {
  ValuesetResponseError(ErrResponse)
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
    params: resource.Parameters,
    offset: Int,
    total: Option(Int),
    pages: List(List(resource.ValuesetExpansionContains)),
    codes: set.Set(#(String, String)),
    versions: set.Set(#(String, Option(resource.ValuesetExpansionParameterValue))),
  )
}

pub type ValuesetExpandStep {
  ValuesetExpandNext(
    request: Request(Option(Json)),
    state: ValuesetExpandState,
  )
  ValuesetExpandDone(value_set: resource.Valueset)
}

/// Start expanding a supplied ValueSet definition, requesting flat pages.
pub fn valueset_expand_request(
  value_set: resource.Valueset,
  client: FhirClient,
) -> ValuesetExpandStep {
  let target = case value_set.compose, value_set.url {
    None, Some(url) -> [
      resource.ParametersParameter(
        ..resource.parameters_parameter_new(\"url\"),
        value: Some(resource.ParametersParameterValueUri(url)),
      ),
      ..case value_set.version {
        None -> []
        Some(version) -> [resource.ParametersParameter(
          ..resource.parameters_parameter_new(\"valueSetVersion\"),
          value: Some(resource.ParametersParameterValueString(version)),
        )]
      }
    ]
    _, _ -> [resource.ParametersParameter(
      ..resource.parameters_parameter_new(\"valueSet\"),
      resource: Some(resource.ResourceValueset(value_set)),
    )]
  }
  let params = resource.Parameters(
    ..resource.parameters_new(),
    parameter: [
      resource.ParametersParameter(
        ..resource.parameters_parameter_new(\"count\"),
        value: Some(resource.ParametersParameterValueInteger(1000)),
      ),
      resource.ParametersParameter(
        ..resource.parameters_parameter_new(\"excludeNested\"),
        value: Some(resource.ParametersParameterValueBoolean(True)),
      ),
      ..target
    ],
  )
  ValuesetExpandNext(
    any_operation_request(resource.ResourceTypeValueset, None, \"expand\", Some(params), client),
    ValuesetExpandState(
      params:, offset: 0, total: None, pages: [],
      codes: set.new(), versions: set.new(),
    ),
  )
}

/// Check a decoded page and return the next request or the combined ValueSet.
pub fn valueset_expand_response(
  value_set: resource.Valueset,
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
      extension.url == \"http://hl7.org/fhir/StructureDefinition/valueset-unclosed\"
      && extension.extension == complex_type.ExtensionSimple(complex_type.ExtensionValueBoolean(True))
    }),
    Error(ValuesetIncompleteExpansion),
  )

  let versions = expansion.parameter
    |> list.filter(fn(parameter) {
      parameter.name == \"used-codesystem\" || parameter.name == \"used-valueset\"
    })
    |> list.map(fn(parameter) { #(parameter.name, parameter.value) })
    |> set.from_list
  use <- bool.guard(
    state.offset > 0 && versions != state.versions,
    Error(ValuesetTerminologyChanged),
  )
  use codes <- result.try(list.try_fold(expansion.contains, state.codes, fn(codes, concept) {
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
  }))

  let received = list.length(expansion.contains)
  let next_offset = state.offset + received
  use <- bool.guard(
    state.total != None && expansion.total != None && state.total != expansion.total,
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
      let params = resource.Parameters(
        ..state.params,
        parameter: [
          resource.ParametersParameter(
            ..resource.parameters_parameter_new(\"offset\"),
            value: Some(resource.ParametersParameterValueInteger(next_offset)),
          ),
          ..state.params.parameter
        ],
      )
      Ok(ValuesetExpandNext(
        any_operation_request(resource.ResourceTypeValueset, None, \"expand\", Some(params), client),
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
      let contains = list.fold(pages, [], fn(acc, items) {
        list.append(items, acc)
      })
      Ok(ValuesetExpandDone(resource.Valueset(
        ..value_set,
        expansion: Some(resource.ValuesetExpansion(
          ..expansion,
          contains:,
          total: Some(next_offset),
          offset: None,
          parameter: list.filter(expansion.parameter, fn(parameter) {
            parameter.name != \"offset\" && parameter.name != \"count\"
          }),
        )),
      )))
    }
  }
}
"
