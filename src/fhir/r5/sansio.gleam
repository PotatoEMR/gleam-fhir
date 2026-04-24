////[https://hl7.org/fhir/r5](https://hl7.org/fhir/r5) r5 sans-io request/response helpers suitable for building clients on top of, such as fhirclient_httpc.gleam and fhirclient_rsvp.gleam

import fhir/r5/resources
import fhir/r5/valuesets
import gleam/dynamic/decode
import gleam/http
import gleam/http/request.{type Request, Request}
import gleam/http/response.{type Response}
import gleam/json.{type Json}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import gleam/uri

/// a problem with your baseurl in `fhirclient_new(baseurl)`,
/// which you should only see if you have typo in server base url
pub type ErrBaseUrl {
  UriParseFail
  UriNoHttpOrHttps
  UriNoHost
}

/// FHIR client for sending http requests to server such as
/// `let pat = resources.patient_read("123", client)`
///
/// create client from server base url with fhirclient_new(baseurl)`
///
/// `let assert Ok(client) = sansio.fhirclient_new("r5.smarthealthit.org/")`
///
/// `let assert Ok(client) = sansio.fhirclient_new("https://r5.smarthealthit.org/")`
///
/// `let assert Ok(client) = sansio.fhirclient_new("https://hapi.fhir.org/baser5")`
///
/// `let assert Ok(client) = sansio.fhirclient_new("127.0.0.1:8000")`
pub type FhirClient {
  FhirClient(baseurl: uri.Uri, basereq: Request(Option(Json)))
}

/// creates a new client from server base url
///
/// `let assert Ok(client) = sansio.fhirclient_new("r5.smarthealthit.org/")`
///
/// `let assert Ok(client) = sansio.fhirclient_new("https://r5.smarthealthit.org/")`
///
/// `let assert Ok(client) = sansio.fhirclient_new("https://hapi.fhir.org/baser5")`
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

fn create_base_req(
  scheme: http.Scheme,
  host: String,
  baseurl: uri.Uri,
) -> FhirClient {
  let basereq =
    Request(
      method: http.Get,
      headers: [#("Accept", "application/fhir+json")],
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
  FhirClient(baseurl:, basereq:)
}

pub type ErrResp {
  ///got json but could not parse it, probably a missing required field
  ErrParseJson(json.DecodeError)
  ///did not get resource json, often server eg nginx gives basic html response
  ErrNotJson(Response(String))
  ///got operationoutcome error from fhir server
  ErrOperationoutcome(resources.Operationoutcome)
}

pub type ErrReq {
  ///could not make an update request because resource has no id
  ErrNoId
}

pub fn any_create_req(resource_json: Json, res_type: String, client: FhirClient) {
  client.basereq
  |> request.set_path(string.concat([client.basereq.path, "/", res_type]))
  |> request.set_header("Content-Type", "application/fhir+json")
  |> request.set_header("Prefer", "return=representation")
  |> request.set_body(Some(resource_json))
  |> request.set_method(http.Post)
}

pub fn any_read_req(id: String, res_type: String, client: FhirClient) {
  client.basereq
  |> request.set_path(
    string.concat([client.basereq.path, "/", res_type, "/", id]),
  )
}

pub fn any_update_req(
  id: Option(String),
  resource_json: Json,
  res_type: String,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  case id {
    None -> Error(ErrNoId)
    Some(id) ->
      Ok(
        client.basereq
        |> request.set_path(
          string.concat([client.basereq.path, "/", res_type, "/", id]),
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
  res_type: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  client.basereq
  |> request.set_path(
    string.concat([client.basereq.path, "/", res_type, "/", id]),
  )
  |> request.set_method(http.Delete)
}

pub fn any_search_req(
  search_string: String,
  res_type: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  client.basereq
  |> request.set_path(
    string.concat([client.basereq.path, "/", res_type, "?", search_string]),
  )
}

pub fn any_operation_req(
  res_type: String,
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
        res_type,
        "/",
        res_id,
        "/$",
        operation_name,
      ])
    None ->
      string.concat([client.basereq.path, "/", res_type, "/$", operation_name])
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

fn using_params(params) {
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

/// decodes an Ok(resource) of given decoder type
/// or Error(ErrOperationoutcome(operationoutcome))
///
/// if resp.body is not a JSON, returns Error(ErrNotJson(resp))
pub fn any_resp(
  resp: Response(String),
  resource_dec: decode.Decoder(a),
  resource_type: String,
) {
  case
    resp.body
    |> json.parse({
      use tag <- decode.field("resourceType", decode.string)
      case tag == resource_type {
        True -> resource_dec |> decode.map(Ok)
        False ->
          case tag == "OperationOutcome" {
            True ->
              resources.operationoutcome_decoder()
              |> decode.map(fn(oo) { Error(ErrOperationoutcome(oo)) })
            // if resourceType tag is neither desired res type or oo,
            // don't even bother trying to decode
            False ->
              decode.failure(Error(ErrNotJson(resp)), "")
              |> decode.map_errors(fn(_errs) {
                [
                  decode.DecodeError(
                    expected: resource_type <> " or OperationOutcome",
                    found: tag,
                    path: ["resourceType"],
                  ),
                ]
              })
          }
      }
    })
  {
    Ok(decoded) -> decoded
    Error(json_err) ->
      case json_err {
        json.UnableToDecode(_) -> Error(ErrParseJson(json_err))
        _ -> Error(ErrNotJson(resp))
      }
  }
}

pub type OperationoutcomeOrHTTP {
  SuccessOperationoutcome(resources.Operationoutcome)
  SuccessHttpResponse(Response(String))
}

/// returns Ok if http status code 200-299, otherwise Error,
/// and can return an OperationOutcome or HTTP response,
/// depending on if server sense OperationOutcome or empty body
pub fn http_or_operationoutcome_resp(
  resp: Response(String),
) -> Result(OperationoutcomeOrHTTP, ErrResp) {
  case resp.body {
    "" ->
      case resp.status < 300 {
        True -> Ok(SuccessHttpResponse(resp))
        False -> Error(ErrNotJson(resp))
      }
    _ -> {
      case resp.body |> json.parse(resources.operationoutcome_decoder()) {
        Ok(decoded_oo) ->
          case resp.status < 300 {
            True -> Ok(SuccessOperationoutcome(decoded_oo))
            False -> Error(ErrOperationoutcome(decoded_oo))
          }
        Error(json_err) ->
          case json_err {
            json.UnableToDecode(_) -> Error(ErrParseJson(json_err))
            _ -> Error(ErrNotJson(resp))
          }
      }
    }
  }
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
) {
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
          #("url", json.string(string.drop_start(req.path, base_len))),
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
  result.try(
    list.find(bundle.link, fn(l) {
      l.relation == valuesets.IanalinkrelationsNext
    }),
    fn(link) {
      result.try(uri.parse(link.url), fn(uri) {
        Ok(Request(..client.basereq, path: uri.path, query: uri.query))
      })
    },
  )
}

pub fn account_create_req(
  resource: resources.Account,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.account_to_json(resource), "Account", client)
}

pub fn account_read_req(id: String, client: FhirClient) -> Request(Option(Json)) {
  any_read_req(id, "Account", client)
}

pub fn account_update_req(
  resource: resources.Account,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.account_to_json(resource),
    "Account",
    client,
  )
}

pub fn account_resp(
  resp: Response(String),
) -> Result(resources.Account, ErrResp) {
  any_resp(resp, resources.account_decoder(), "Account")
}

pub fn activitydefinition_create_req(
  resource: resources.Activitydefinition,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.activitydefinition_to_json(resource),
    "ActivityDefinition",
    client,
  )
}

pub fn activitydefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "ActivityDefinition", client)
}

pub fn activitydefinition_update_req(
  resource: resources.Activitydefinition,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.activitydefinition_to_json(resource),
    "ActivityDefinition",
    client,
  )
}

pub fn activitydefinition_resp(
  resp: Response(String),
) -> Result(resources.Activitydefinition, ErrResp) {
  any_resp(resp, resources.activitydefinition_decoder(), "ActivityDefinition")
}

pub fn actordefinition_create_req(
  resource: resources.Actordefinition,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.actordefinition_to_json(resource),
    "ActorDefinition",
    client,
  )
}

pub fn actordefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "ActorDefinition", client)
}

pub fn actordefinition_update_req(
  resource: resources.Actordefinition,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.actordefinition_to_json(resource),
    "ActorDefinition",
    client,
  )
}

pub fn actordefinition_resp(
  resp: Response(String),
) -> Result(resources.Actordefinition, ErrResp) {
  any_resp(resp, resources.actordefinition_decoder(), "ActorDefinition")
}

pub fn administrableproductdefinition_create_req(
  resource: resources.Administrableproductdefinition,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.administrableproductdefinition_to_json(resource),
    "AdministrableProductDefinition",
    client,
  )
}

pub fn administrableproductdefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "AdministrableProductDefinition", client)
}

pub fn administrableproductdefinition_update_req(
  resource: resources.Administrableproductdefinition,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.administrableproductdefinition_to_json(resource),
    "AdministrableProductDefinition",
    client,
  )
}

pub fn administrableproductdefinition_resp(
  resp: Response(String),
) -> Result(resources.Administrableproductdefinition, ErrResp) {
  any_resp(
    resp,
    resources.administrableproductdefinition_decoder(),
    "AdministrableProductDefinition",
  )
}

pub fn adverseevent_create_req(
  resource: resources.Adverseevent,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.adverseevent_to_json(resource),
    "AdverseEvent",
    client,
  )
}

pub fn adverseevent_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "AdverseEvent", client)
}

pub fn adverseevent_update_req(
  resource: resources.Adverseevent,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.adverseevent_to_json(resource),
    "AdverseEvent",
    client,
  )
}

pub fn adverseevent_resp(
  resp: Response(String),
) -> Result(resources.Adverseevent, ErrResp) {
  any_resp(resp, resources.adverseevent_decoder(), "AdverseEvent")
}

pub fn allergyintolerance_create_req(
  resource: resources.Allergyintolerance,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    client,
  )
}

pub fn allergyintolerance_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "AllergyIntolerance", client)
}

pub fn allergyintolerance_update_req(
  resource: resources.Allergyintolerance,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    client,
  )
}

pub fn allergyintolerance_resp(
  resp: Response(String),
) -> Result(resources.Allergyintolerance, ErrResp) {
  any_resp(resp, resources.allergyintolerance_decoder(), "AllergyIntolerance")
}

pub fn appointment_create_req(
  resource: resources.Appointment,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.appointment_to_json(resource), "Appointment", client)
}

pub fn appointment_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "Appointment", client)
}

pub fn appointment_update_req(
  resource: resources.Appointment,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.appointment_to_json(resource),
    "Appointment",
    client,
  )
}

pub fn appointment_resp(
  resp: Response(String),
) -> Result(resources.Appointment, ErrResp) {
  any_resp(resp, resources.appointment_decoder(), "Appointment")
}

pub fn appointmentresponse_create_req(
  resource: resources.Appointmentresponse,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.appointmentresponse_to_json(resource),
    "AppointmentResponse",
    client,
  )
}

pub fn appointmentresponse_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "AppointmentResponse", client)
}

pub fn appointmentresponse_update_req(
  resource: resources.Appointmentresponse,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.appointmentresponse_to_json(resource),
    "AppointmentResponse",
    client,
  )
}

pub fn appointmentresponse_resp(
  resp: Response(String),
) -> Result(resources.Appointmentresponse, ErrResp) {
  any_resp(resp, resources.appointmentresponse_decoder(), "AppointmentResponse")
}

pub fn artifactassessment_create_req(
  resource: resources.Artifactassessment,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.artifactassessment_to_json(resource),
    "ArtifactAssessment",
    client,
  )
}

pub fn artifactassessment_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "ArtifactAssessment", client)
}

pub fn artifactassessment_update_req(
  resource: resources.Artifactassessment,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.artifactassessment_to_json(resource),
    "ArtifactAssessment",
    client,
  )
}

pub fn artifactassessment_resp(
  resp: Response(String),
) -> Result(resources.Artifactassessment, ErrResp) {
  any_resp(resp, resources.artifactassessment_decoder(), "ArtifactAssessment")
}

pub fn auditevent_create_req(
  resource: resources.Auditevent,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.auditevent_to_json(resource), "AuditEvent", client)
}

pub fn auditevent_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "AuditEvent", client)
}

pub fn auditevent_update_req(
  resource: resources.Auditevent,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.auditevent_to_json(resource),
    "AuditEvent",
    client,
  )
}

pub fn auditevent_resp(
  resp: Response(String),
) -> Result(resources.Auditevent, ErrResp) {
  any_resp(resp, resources.auditevent_decoder(), "AuditEvent")
}

pub fn basic_create_req(
  resource: resources.Basic,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.basic_to_json(resource), "Basic", client)
}

pub fn basic_read_req(id: String, client: FhirClient) -> Request(Option(Json)) {
  any_read_req(id, "Basic", client)
}

pub fn basic_update_req(
  resource: resources.Basic,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.basic_to_json(resource),
    "Basic",
    client,
  )
}

pub fn basic_resp(resp: Response(String)) -> Result(resources.Basic, ErrResp) {
  any_resp(resp, resources.basic_decoder(), "Basic")
}

pub fn binary_create_req(
  resource: resources.Binary,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.binary_to_json(resource), "Binary", client)
}

pub fn binary_read_req(id: String, client: FhirClient) -> Request(Option(Json)) {
  any_read_req(id, "Binary", client)
}

pub fn binary_update_req(
  resource: resources.Binary,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.binary_to_json(resource),
    "Binary",
    client,
  )
}

pub fn binary_resp(resp: Response(String)) -> Result(resources.Binary, ErrResp) {
  any_resp(resp, resources.binary_decoder(), "Binary")
}

pub fn biologicallyderivedproduct_create_req(
  resource: resources.Biologicallyderivedproduct,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.biologicallyderivedproduct_to_json(resource),
    "BiologicallyDerivedProduct",
    client,
  )
}

pub fn biologicallyderivedproduct_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "BiologicallyDerivedProduct", client)
}

pub fn biologicallyderivedproduct_update_req(
  resource: resources.Biologicallyderivedproduct,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.biologicallyderivedproduct_to_json(resource),
    "BiologicallyDerivedProduct",
    client,
  )
}

pub fn biologicallyderivedproduct_resp(
  resp: Response(String),
) -> Result(resources.Biologicallyderivedproduct, ErrResp) {
  any_resp(
    resp,
    resources.biologicallyderivedproduct_decoder(),
    "BiologicallyDerivedProduct",
  )
}

pub fn biologicallyderivedproductdispense_create_req(
  resource: resources.Biologicallyderivedproductdispense,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.biologicallyderivedproductdispense_to_json(resource),
    "BiologicallyDerivedProductDispense",
    client,
  )
}

pub fn biologicallyderivedproductdispense_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "BiologicallyDerivedProductDispense", client)
}

pub fn biologicallyderivedproductdispense_update_req(
  resource: resources.Biologicallyderivedproductdispense,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.biologicallyderivedproductdispense_to_json(resource),
    "BiologicallyDerivedProductDispense",
    client,
  )
}

pub fn biologicallyderivedproductdispense_resp(
  resp: Response(String),
) -> Result(resources.Biologicallyderivedproductdispense, ErrResp) {
  any_resp(
    resp,
    resources.biologicallyderivedproductdispense_decoder(),
    "BiologicallyDerivedProductDispense",
  )
}

pub fn bodystructure_create_req(
  resource: resources.Bodystructure,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.bodystructure_to_json(resource),
    "BodyStructure",
    client,
  )
}

pub fn bodystructure_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "BodyStructure", client)
}

pub fn bodystructure_update_req(
  resource: resources.Bodystructure,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.bodystructure_to_json(resource),
    "BodyStructure",
    client,
  )
}

pub fn bodystructure_resp(
  resp: Response(String),
) -> Result(resources.Bodystructure, ErrResp) {
  any_resp(resp, resources.bodystructure_decoder(), "BodyStructure")
}

pub fn bundle_create_req(
  resource: resources.Bundle,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.bundle_to_json(resource), "Bundle", client)
}

pub fn bundle_read_req(id: String, client: FhirClient) -> Request(Option(Json)) {
  any_read_req(id, "Bundle", client)
}

pub fn bundle_update_req(
  resource: resources.Bundle,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.bundle_to_json(resource),
    "Bundle",
    client,
  )
}

pub fn bundle_resp(resp: Response(String)) -> Result(resources.Bundle, ErrResp) {
  any_resp(resp, resources.bundle_decoder(), "Bundle")
}

pub fn capabilitystatement_create_req(
  resource: resources.Capabilitystatement,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.capabilitystatement_to_json(resource),
    "CapabilityStatement",
    client,
  )
}

pub fn capabilitystatement_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "CapabilityStatement", client)
}

pub fn capabilitystatement_update_req(
  resource: resources.Capabilitystatement,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.capabilitystatement_to_json(resource),
    "CapabilityStatement",
    client,
  )
}

pub fn capabilitystatement_resp(
  resp: Response(String),
) -> Result(resources.Capabilitystatement, ErrResp) {
  any_resp(resp, resources.capabilitystatement_decoder(), "CapabilityStatement")
}

pub fn careplan_create_req(
  resource: resources.Careplan,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.careplan_to_json(resource), "CarePlan", client)
}

pub fn careplan_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "CarePlan", client)
}

pub fn careplan_update_req(
  resource: resources.Careplan,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.careplan_to_json(resource),
    "CarePlan",
    client,
  )
}

pub fn careplan_resp(
  resp: Response(String),
) -> Result(resources.Careplan, ErrResp) {
  any_resp(resp, resources.careplan_decoder(), "CarePlan")
}

pub fn careteam_create_req(
  resource: resources.Careteam,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.careteam_to_json(resource), "CareTeam", client)
}

pub fn careteam_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "CareTeam", client)
}

pub fn careteam_update_req(
  resource: resources.Careteam,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.careteam_to_json(resource),
    "CareTeam",
    client,
  )
}

pub fn careteam_resp(
  resp: Response(String),
) -> Result(resources.Careteam, ErrResp) {
  any_resp(resp, resources.careteam_decoder(), "CareTeam")
}

pub fn chargeitem_create_req(
  resource: resources.Chargeitem,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.chargeitem_to_json(resource), "ChargeItem", client)
}

pub fn chargeitem_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "ChargeItem", client)
}

pub fn chargeitem_update_req(
  resource: resources.Chargeitem,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.chargeitem_to_json(resource),
    "ChargeItem",
    client,
  )
}

pub fn chargeitem_resp(
  resp: Response(String),
) -> Result(resources.Chargeitem, ErrResp) {
  any_resp(resp, resources.chargeitem_decoder(), "ChargeItem")
}

pub fn chargeitemdefinition_create_req(
  resource: resources.Chargeitemdefinition,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.chargeitemdefinition_to_json(resource),
    "ChargeItemDefinition",
    client,
  )
}

pub fn chargeitemdefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "ChargeItemDefinition", client)
}

pub fn chargeitemdefinition_update_req(
  resource: resources.Chargeitemdefinition,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.chargeitemdefinition_to_json(resource),
    "ChargeItemDefinition",
    client,
  )
}

pub fn chargeitemdefinition_resp(
  resp: Response(String),
) -> Result(resources.Chargeitemdefinition, ErrResp) {
  any_resp(
    resp,
    resources.chargeitemdefinition_decoder(),
    "ChargeItemDefinition",
  )
}

pub fn citation_create_req(
  resource: resources.Citation,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.citation_to_json(resource), "Citation", client)
}

pub fn citation_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "Citation", client)
}

pub fn citation_update_req(
  resource: resources.Citation,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.citation_to_json(resource),
    "Citation",
    client,
  )
}

pub fn citation_resp(
  resp: Response(String),
) -> Result(resources.Citation, ErrResp) {
  any_resp(resp, resources.citation_decoder(), "Citation")
}

pub fn claim_create_req(
  resource: resources.Claim,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.claim_to_json(resource), "Claim", client)
}

pub fn claim_read_req(id: String, client: FhirClient) -> Request(Option(Json)) {
  any_read_req(id, "Claim", client)
}

pub fn claim_update_req(
  resource: resources.Claim,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.claim_to_json(resource),
    "Claim",
    client,
  )
}

pub fn claim_resp(resp: Response(String)) -> Result(resources.Claim, ErrResp) {
  any_resp(resp, resources.claim_decoder(), "Claim")
}

pub fn claimresponse_create_req(
  resource: resources.Claimresponse,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.claimresponse_to_json(resource),
    "ClaimResponse",
    client,
  )
}

pub fn claimresponse_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "ClaimResponse", client)
}

pub fn claimresponse_update_req(
  resource: resources.Claimresponse,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.claimresponse_to_json(resource),
    "ClaimResponse",
    client,
  )
}

pub fn claimresponse_resp(
  resp: Response(String),
) -> Result(resources.Claimresponse, ErrResp) {
  any_resp(resp, resources.claimresponse_decoder(), "ClaimResponse")
}

pub fn clinicalimpression_create_req(
  resource: resources.Clinicalimpression,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.clinicalimpression_to_json(resource),
    "ClinicalImpression",
    client,
  )
}

pub fn clinicalimpression_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "ClinicalImpression", client)
}

pub fn clinicalimpression_update_req(
  resource: resources.Clinicalimpression,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.clinicalimpression_to_json(resource),
    "ClinicalImpression",
    client,
  )
}

pub fn clinicalimpression_resp(
  resp: Response(String),
) -> Result(resources.Clinicalimpression, ErrResp) {
  any_resp(resp, resources.clinicalimpression_decoder(), "ClinicalImpression")
}

pub fn clinicalusedefinition_create_req(
  resource: resources.Clinicalusedefinition,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.clinicalusedefinition_to_json(resource),
    "ClinicalUseDefinition",
    client,
  )
}

pub fn clinicalusedefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "ClinicalUseDefinition", client)
}

pub fn clinicalusedefinition_update_req(
  resource: resources.Clinicalusedefinition,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.clinicalusedefinition_to_json(resource),
    "ClinicalUseDefinition",
    client,
  )
}

pub fn clinicalusedefinition_resp(
  resp: Response(String),
) -> Result(resources.Clinicalusedefinition, ErrResp) {
  any_resp(
    resp,
    resources.clinicalusedefinition_decoder(),
    "ClinicalUseDefinition",
  )
}

pub fn codesystem_create_req(
  resource: resources.Codesystem,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.codesystem_to_json(resource), "CodeSystem", client)
}

pub fn codesystem_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "CodeSystem", client)
}

pub fn codesystem_update_req(
  resource: resources.Codesystem,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.codesystem_to_json(resource),
    "CodeSystem",
    client,
  )
}

pub fn codesystem_resp(
  resp: Response(String),
) -> Result(resources.Codesystem, ErrResp) {
  any_resp(resp, resources.codesystem_decoder(), "CodeSystem")
}

pub fn communication_create_req(
  resource: resources.Communication,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.communication_to_json(resource),
    "Communication",
    client,
  )
}

pub fn communication_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "Communication", client)
}

pub fn communication_update_req(
  resource: resources.Communication,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.communication_to_json(resource),
    "Communication",
    client,
  )
}

pub fn communication_resp(
  resp: Response(String),
) -> Result(resources.Communication, ErrResp) {
  any_resp(resp, resources.communication_decoder(), "Communication")
}

pub fn communicationrequest_create_req(
  resource: resources.Communicationrequest,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.communicationrequest_to_json(resource),
    "CommunicationRequest",
    client,
  )
}

pub fn communicationrequest_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "CommunicationRequest", client)
}

pub fn communicationrequest_update_req(
  resource: resources.Communicationrequest,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.communicationrequest_to_json(resource),
    "CommunicationRequest",
    client,
  )
}

pub fn communicationrequest_resp(
  resp: Response(String),
) -> Result(resources.Communicationrequest, ErrResp) {
  any_resp(
    resp,
    resources.communicationrequest_decoder(),
    "CommunicationRequest",
  )
}

pub fn compartmentdefinition_create_req(
  resource: resources.Compartmentdefinition,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.compartmentdefinition_to_json(resource),
    "CompartmentDefinition",
    client,
  )
}

pub fn compartmentdefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "CompartmentDefinition", client)
}

pub fn compartmentdefinition_update_req(
  resource: resources.Compartmentdefinition,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.compartmentdefinition_to_json(resource),
    "CompartmentDefinition",
    client,
  )
}

pub fn compartmentdefinition_resp(
  resp: Response(String),
) -> Result(resources.Compartmentdefinition, ErrResp) {
  any_resp(
    resp,
    resources.compartmentdefinition_decoder(),
    "CompartmentDefinition",
  )
}

pub fn composition_create_req(
  resource: resources.Composition,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.composition_to_json(resource), "Composition", client)
}

pub fn composition_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "Composition", client)
}

pub fn composition_update_req(
  resource: resources.Composition,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.composition_to_json(resource),
    "Composition",
    client,
  )
}

pub fn composition_resp(
  resp: Response(String),
) -> Result(resources.Composition, ErrResp) {
  any_resp(resp, resources.composition_decoder(), "Composition")
}

pub fn conceptmap_create_req(
  resource: resources.Conceptmap,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.conceptmap_to_json(resource), "ConceptMap", client)
}

pub fn conceptmap_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "ConceptMap", client)
}

pub fn conceptmap_update_req(
  resource: resources.Conceptmap,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.conceptmap_to_json(resource),
    "ConceptMap",
    client,
  )
}

pub fn conceptmap_resp(
  resp: Response(String),
) -> Result(resources.Conceptmap, ErrResp) {
  any_resp(resp, resources.conceptmap_decoder(), "ConceptMap")
}

pub fn condition_create_req(
  resource: resources.Condition,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.condition_to_json(resource), "Condition", client)
}

pub fn condition_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "Condition", client)
}

pub fn condition_update_req(
  resource: resources.Condition,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.condition_to_json(resource),
    "Condition",
    client,
  )
}

pub fn condition_resp(
  resp: Response(String),
) -> Result(resources.Condition, ErrResp) {
  any_resp(resp, resources.condition_decoder(), "Condition")
}

pub fn conditiondefinition_create_req(
  resource: resources.Conditiondefinition,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.conditiondefinition_to_json(resource),
    "ConditionDefinition",
    client,
  )
}

pub fn conditiondefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "ConditionDefinition", client)
}

pub fn conditiondefinition_update_req(
  resource: resources.Conditiondefinition,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.conditiondefinition_to_json(resource),
    "ConditionDefinition",
    client,
  )
}

pub fn conditiondefinition_resp(
  resp: Response(String),
) -> Result(resources.Conditiondefinition, ErrResp) {
  any_resp(resp, resources.conditiondefinition_decoder(), "ConditionDefinition")
}

pub fn consent_create_req(
  resource: resources.Consent,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.consent_to_json(resource), "Consent", client)
}

pub fn consent_read_req(id: String, client: FhirClient) -> Request(Option(Json)) {
  any_read_req(id, "Consent", client)
}

pub fn consent_update_req(
  resource: resources.Consent,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.consent_to_json(resource),
    "Consent",
    client,
  )
}

pub fn consent_resp(
  resp: Response(String),
) -> Result(resources.Consent, ErrResp) {
  any_resp(resp, resources.consent_decoder(), "Consent")
}

pub fn contract_create_req(
  resource: resources.Contract,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.contract_to_json(resource), "Contract", client)
}

pub fn contract_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "Contract", client)
}

pub fn contract_update_req(
  resource: resources.Contract,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.contract_to_json(resource),
    "Contract",
    client,
  )
}

pub fn contract_resp(
  resp: Response(String),
) -> Result(resources.Contract, ErrResp) {
  any_resp(resp, resources.contract_decoder(), "Contract")
}

pub fn coverage_create_req(
  resource: resources.Coverage,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.coverage_to_json(resource), "Coverage", client)
}

pub fn coverage_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "Coverage", client)
}

pub fn coverage_update_req(
  resource: resources.Coverage,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.coverage_to_json(resource),
    "Coverage",
    client,
  )
}

pub fn coverage_resp(
  resp: Response(String),
) -> Result(resources.Coverage, ErrResp) {
  any_resp(resp, resources.coverage_decoder(), "Coverage")
}

pub fn coverageeligibilityrequest_create_req(
  resource: resources.Coverageeligibilityrequest,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.coverageeligibilityrequest_to_json(resource),
    "CoverageEligibilityRequest",
    client,
  )
}

pub fn coverageeligibilityrequest_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "CoverageEligibilityRequest", client)
}

pub fn coverageeligibilityrequest_update_req(
  resource: resources.Coverageeligibilityrequest,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.coverageeligibilityrequest_to_json(resource),
    "CoverageEligibilityRequest",
    client,
  )
}

pub fn coverageeligibilityrequest_resp(
  resp: Response(String),
) -> Result(resources.Coverageeligibilityrequest, ErrResp) {
  any_resp(
    resp,
    resources.coverageeligibilityrequest_decoder(),
    "CoverageEligibilityRequest",
  )
}

pub fn coverageeligibilityresponse_create_req(
  resource: resources.Coverageeligibilityresponse,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.coverageeligibilityresponse_to_json(resource),
    "CoverageEligibilityResponse",
    client,
  )
}

pub fn coverageeligibilityresponse_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "CoverageEligibilityResponse", client)
}

pub fn coverageeligibilityresponse_update_req(
  resource: resources.Coverageeligibilityresponse,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.coverageeligibilityresponse_to_json(resource),
    "CoverageEligibilityResponse",
    client,
  )
}

pub fn coverageeligibilityresponse_resp(
  resp: Response(String),
) -> Result(resources.Coverageeligibilityresponse, ErrResp) {
  any_resp(
    resp,
    resources.coverageeligibilityresponse_decoder(),
    "CoverageEligibilityResponse",
  )
}

pub fn detectedissue_create_req(
  resource: resources.Detectedissue,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.detectedissue_to_json(resource),
    "DetectedIssue",
    client,
  )
}

pub fn detectedissue_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "DetectedIssue", client)
}

pub fn detectedissue_update_req(
  resource: resources.Detectedissue,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.detectedissue_to_json(resource),
    "DetectedIssue",
    client,
  )
}

pub fn detectedissue_resp(
  resp: Response(String),
) -> Result(resources.Detectedissue, ErrResp) {
  any_resp(resp, resources.detectedissue_decoder(), "DetectedIssue")
}

pub fn device_create_req(
  resource: resources.Device,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.device_to_json(resource), "Device", client)
}

pub fn device_read_req(id: String, client: FhirClient) -> Request(Option(Json)) {
  any_read_req(id, "Device", client)
}

pub fn device_update_req(
  resource: resources.Device,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.device_to_json(resource),
    "Device",
    client,
  )
}

pub fn device_resp(resp: Response(String)) -> Result(resources.Device, ErrResp) {
  any_resp(resp, resources.device_decoder(), "Device")
}

pub fn deviceassociation_create_req(
  resource: resources.Deviceassociation,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.deviceassociation_to_json(resource),
    "DeviceAssociation",
    client,
  )
}

pub fn deviceassociation_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "DeviceAssociation", client)
}

pub fn deviceassociation_update_req(
  resource: resources.Deviceassociation,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.deviceassociation_to_json(resource),
    "DeviceAssociation",
    client,
  )
}

pub fn deviceassociation_resp(
  resp: Response(String),
) -> Result(resources.Deviceassociation, ErrResp) {
  any_resp(resp, resources.deviceassociation_decoder(), "DeviceAssociation")
}

pub fn devicedefinition_create_req(
  resource: resources.Devicedefinition,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.devicedefinition_to_json(resource),
    "DeviceDefinition",
    client,
  )
}

pub fn devicedefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "DeviceDefinition", client)
}

pub fn devicedefinition_update_req(
  resource: resources.Devicedefinition,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.devicedefinition_to_json(resource),
    "DeviceDefinition",
    client,
  )
}

pub fn devicedefinition_resp(
  resp: Response(String),
) -> Result(resources.Devicedefinition, ErrResp) {
  any_resp(resp, resources.devicedefinition_decoder(), "DeviceDefinition")
}

pub fn devicedispense_create_req(
  resource: resources.Devicedispense,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.devicedispense_to_json(resource),
    "DeviceDispense",
    client,
  )
}

pub fn devicedispense_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "DeviceDispense", client)
}

pub fn devicedispense_update_req(
  resource: resources.Devicedispense,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.devicedispense_to_json(resource),
    "DeviceDispense",
    client,
  )
}

pub fn devicedispense_resp(
  resp: Response(String),
) -> Result(resources.Devicedispense, ErrResp) {
  any_resp(resp, resources.devicedispense_decoder(), "DeviceDispense")
}

pub fn devicemetric_create_req(
  resource: resources.Devicemetric,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.devicemetric_to_json(resource),
    "DeviceMetric",
    client,
  )
}

pub fn devicemetric_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "DeviceMetric", client)
}

pub fn devicemetric_update_req(
  resource: resources.Devicemetric,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.devicemetric_to_json(resource),
    "DeviceMetric",
    client,
  )
}

pub fn devicemetric_resp(
  resp: Response(String),
) -> Result(resources.Devicemetric, ErrResp) {
  any_resp(resp, resources.devicemetric_decoder(), "DeviceMetric")
}

pub fn devicerequest_create_req(
  resource: resources.Devicerequest,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.devicerequest_to_json(resource),
    "DeviceRequest",
    client,
  )
}

pub fn devicerequest_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "DeviceRequest", client)
}

pub fn devicerequest_update_req(
  resource: resources.Devicerequest,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.devicerequest_to_json(resource),
    "DeviceRequest",
    client,
  )
}

pub fn devicerequest_resp(
  resp: Response(String),
) -> Result(resources.Devicerequest, ErrResp) {
  any_resp(resp, resources.devicerequest_decoder(), "DeviceRequest")
}

pub fn deviceusage_create_req(
  resource: resources.Deviceusage,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.deviceusage_to_json(resource), "DeviceUsage", client)
}

pub fn deviceusage_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "DeviceUsage", client)
}

pub fn deviceusage_update_req(
  resource: resources.Deviceusage,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.deviceusage_to_json(resource),
    "DeviceUsage",
    client,
  )
}

pub fn deviceusage_resp(
  resp: Response(String),
) -> Result(resources.Deviceusage, ErrResp) {
  any_resp(resp, resources.deviceusage_decoder(), "DeviceUsage")
}

pub fn diagnosticreport_create_req(
  resource: resources.Diagnosticreport,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.diagnosticreport_to_json(resource),
    "DiagnosticReport",
    client,
  )
}

pub fn diagnosticreport_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "DiagnosticReport", client)
}

pub fn diagnosticreport_update_req(
  resource: resources.Diagnosticreport,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.diagnosticreport_to_json(resource),
    "DiagnosticReport",
    client,
  )
}

pub fn diagnosticreport_resp(
  resp: Response(String),
) -> Result(resources.Diagnosticreport, ErrResp) {
  any_resp(resp, resources.diagnosticreport_decoder(), "DiagnosticReport")
}

pub fn documentreference_create_req(
  resource: resources.Documentreference,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.documentreference_to_json(resource),
    "DocumentReference",
    client,
  )
}

pub fn documentreference_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "DocumentReference", client)
}

pub fn documentreference_update_req(
  resource: resources.Documentreference,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.documentreference_to_json(resource),
    "DocumentReference",
    client,
  )
}

pub fn documentreference_resp(
  resp: Response(String),
) -> Result(resources.Documentreference, ErrResp) {
  any_resp(resp, resources.documentreference_decoder(), "DocumentReference")
}

pub fn encounter_create_req(
  resource: resources.Encounter,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.encounter_to_json(resource), "Encounter", client)
}

pub fn encounter_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "Encounter", client)
}

pub fn encounter_update_req(
  resource: resources.Encounter,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.encounter_to_json(resource),
    "Encounter",
    client,
  )
}

pub fn encounter_resp(
  resp: Response(String),
) -> Result(resources.Encounter, ErrResp) {
  any_resp(resp, resources.encounter_decoder(), "Encounter")
}

pub fn encounterhistory_create_req(
  resource: resources.Encounterhistory,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.encounterhistory_to_json(resource),
    "EncounterHistory",
    client,
  )
}

pub fn encounterhistory_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "EncounterHistory", client)
}

pub fn encounterhistory_update_req(
  resource: resources.Encounterhistory,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.encounterhistory_to_json(resource),
    "EncounterHistory",
    client,
  )
}

pub fn encounterhistory_resp(
  resp: Response(String),
) -> Result(resources.Encounterhistory, ErrResp) {
  any_resp(resp, resources.encounterhistory_decoder(), "EncounterHistory")
}

pub fn endpoint_create_req(
  resource: resources.Endpoint,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.endpoint_to_json(resource), "Endpoint", client)
}

pub fn endpoint_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "Endpoint", client)
}

pub fn endpoint_update_req(
  resource: resources.Endpoint,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.endpoint_to_json(resource),
    "Endpoint",
    client,
  )
}

pub fn endpoint_resp(
  resp: Response(String),
) -> Result(resources.Endpoint, ErrResp) {
  any_resp(resp, resources.endpoint_decoder(), "Endpoint")
}

pub fn enrollmentrequest_create_req(
  resource: resources.Enrollmentrequest,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.enrollmentrequest_to_json(resource),
    "EnrollmentRequest",
    client,
  )
}

pub fn enrollmentrequest_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "EnrollmentRequest", client)
}

pub fn enrollmentrequest_update_req(
  resource: resources.Enrollmentrequest,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.enrollmentrequest_to_json(resource),
    "EnrollmentRequest",
    client,
  )
}

pub fn enrollmentrequest_resp(
  resp: Response(String),
) -> Result(resources.Enrollmentrequest, ErrResp) {
  any_resp(resp, resources.enrollmentrequest_decoder(), "EnrollmentRequest")
}

pub fn enrollmentresponse_create_req(
  resource: resources.Enrollmentresponse,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.enrollmentresponse_to_json(resource),
    "EnrollmentResponse",
    client,
  )
}

pub fn enrollmentresponse_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "EnrollmentResponse", client)
}

pub fn enrollmentresponse_update_req(
  resource: resources.Enrollmentresponse,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.enrollmentresponse_to_json(resource),
    "EnrollmentResponse",
    client,
  )
}

pub fn enrollmentresponse_resp(
  resp: Response(String),
) -> Result(resources.Enrollmentresponse, ErrResp) {
  any_resp(resp, resources.enrollmentresponse_decoder(), "EnrollmentResponse")
}

pub fn episodeofcare_create_req(
  resource: resources.Episodeofcare,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.episodeofcare_to_json(resource),
    "EpisodeOfCare",
    client,
  )
}

pub fn episodeofcare_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "EpisodeOfCare", client)
}

pub fn episodeofcare_update_req(
  resource: resources.Episodeofcare,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.episodeofcare_to_json(resource),
    "EpisodeOfCare",
    client,
  )
}

pub fn episodeofcare_resp(
  resp: Response(String),
) -> Result(resources.Episodeofcare, ErrResp) {
  any_resp(resp, resources.episodeofcare_decoder(), "EpisodeOfCare")
}

pub fn eventdefinition_create_req(
  resource: resources.Eventdefinition,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.eventdefinition_to_json(resource),
    "EventDefinition",
    client,
  )
}

pub fn eventdefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "EventDefinition", client)
}

pub fn eventdefinition_update_req(
  resource: resources.Eventdefinition,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.eventdefinition_to_json(resource),
    "EventDefinition",
    client,
  )
}

pub fn eventdefinition_resp(
  resp: Response(String),
) -> Result(resources.Eventdefinition, ErrResp) {
  any_resp(resp, resources.eventdefinition_decoder(), "EventDefinition")
}

pub fn evidence_create_req(
  resource: resources.Evidence,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.evidence_to_json(resource), "Evidence", client)
}

pub fn evidence_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "Evidence", client)
}

pub fn evidence_update_req(
  resource: resources.Evidence,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.evidence_to_json(resource),
    "Evidence",
    client,
  )
}

pub fn evidence_resp(
  resp: Response(String),
) -> Result(resources.Evidence, ErrResp) {
  any_resp(resp, resources.evidence_decoder(), "Evidence")
}

pub fn evidencereport_create_req(
  resource: resources.Evidencereport,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.evidencereport_to_json(resource),
    "EvidenceReport",
    client,
  )
}

pub fn evidencereport_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "EvidenceReport", client)
}

pub fn evidencereport_update_req(
  resource: resources.Evidencereport,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.evidencereport_to_json(resource),
    "EvidenceReport",
    client,
  )
}

pub fn evidencereport_resp(
  resp: Response(String),
) -> Result(resources.Evidencereport, ErrResp) {
  any_resp(resp, resources.evidencereport_decoder(), "EvidenceReport")
}

pub fn evidencevariable_create_req(
  resource: resources.Evidencevariable,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.evidencevariable_to_json(resource),
    "EvidenceVariable",
    client,
  )
}

pub fn evidencevariable_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "EvidenceVariable", client)
}

pub fn evidencevariable_update_req(
  resource: resources.Evidencevariable,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.evidencevariable_to_json(resource),
    "EvidenceVariable",
    client,
  )
}

pub fn evidencevariable_resp(
  resp: Response(String),
) -> Result(resources.Evidencevariable, ErrResp) {
  any_resp(resp, resources.evidencevariable_decoder(), "EvidenceVariable")
}

pub fn examplescenario_create_req(
  resource: resources.Examplescenario,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.examplescenario_to_json(resource),
    "ExampleScenario",
    client,
  )
}

pub fn examplescenario_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "ExampleScenario", client)
}

pub fn examplescenario_update_req(
  resource: resources.Examplescenario,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.examplescenario_to_json(resource),
    "ExampleScenario",
    client,
  )
}

pub fn examplescenario_resp(
  resp: Response(String),
) -> Result(resources.Examplescenario, ErrResp) {
  any_resp(resp, resources.examplescenario_decoder(), "ExampleScenario")
}

pub fn explanationofbenefit_create_req(
  resource: resources.Explanationofbenefit,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.explanationofbenefit_to_json(resource),
    "ExplanationOfBenefit",
    client,
  )
}

pub fn explanationofbenefit_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "ExplanationOfBenefit", client)
}

pub fn explanationofbenefit_update_req(
  resource: resources.Explanationofbenefit,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.explanationofbenefit_to_json(resource),
    "ExplanationOfBenefit",
    client,
  )
}

pub fn explanationofbenefit_resp(
  resp: Response(String),
) -> Result(resources.Explanationofbenefit, ErrResp) {
  any_resp(
    resp,
    resources.explanationofbenefit_decoder(),
    "ExplanationOfBenefit",
  )
}

pub fn familymemberhistory_create_req(
  resource: resources.Familymemberhistory,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    client,
  )
}

pub fn familymemberhistory_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "FamilyMemberHistory", client)
}

pub fn familymemberhistory_update_req(
  resource: resources.Familymemberhistory,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    client,
  )
}

pub fn familymemberhistory_resp(
  resp: Response(String),
) -> Result(resources.Familymemberhistory, ErrResp) {
  any_resp(resp, resources.familymemberhistory_decoder(), "FamilyMemberHistory")
}

pub fn flag_create_req(
  resource: resources.Flag,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.flag_to_json(resource), "Flag", client)
}

pub fn flag_read_req(id: String, client: FhirClient) -> Request(Option(Json)) {
  any_read_req(id, "Flag", client)
}

pub fn flag_update_req(
  resource: resources.Flag,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(resource.id, resources.flag_to_json(resource), "Flag", client)
}

pub fn flag_resp(resp: Response(String)) -> Result(resources.Flag, ErrResp) {
  any_resp(resp, resources.flag_decoder(), "Flag")
}

pub fn formularyitem_create_req(
  resource: resources.Formularyitem,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.formularyitem_to_json(resource),
    "FormularyItem",
    client,
  )
}

pub fn formularyitem_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "FormularyItem", client)
}

pub fn formularyitem_update_req(
  resource: resources.Formularyitem,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.formularyitem_to_json(resource),
    "FormularyItem",
    client,
  )
}

pub fn formularyitem_resp(
  resp: Response(String),
) -> Result(resources.Formularyitem, ErrResp) {
  any_resp(resp, resources.formularyitem_decoder(), "FormularyItem")
}

pub fn genomicstudy_create_req(
  resource: resources.Genomicstudy,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.genomicstudy_to_json(resource),
    "GenomicStudy",
    client,
  )
}

pub fn genomicstudy_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "GenomicStudy", client)
}

pub fn genomicstudy_update_req(
  resource: resources.Genomicstudy,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.genomicstudy_to_json(resource),
    "GenomicStudy",
    client,
  )
}

pub fn genomicstudy_resp(
  resp: Response(String),
) -> Result(resources.Genomicstudy, ErrResp) {
  any_resp(resp, resources.genomicstudy_decoder(), "GenomicStudy")
}

pub fn goal_create_req(
  resource: resources.Goal,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.goal_to_json(resource), "Goal", client)
}

pub fn goal_read_req(id: String, client: FhirClient) -> Request(Option(Json)) {
  any_read_req(id, "Goal", client)
}

pub fn goal_update_req(
  resource: resources.Goal,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(resource.id, resources.goal_to_json(resource), "Goal", client)
}

pub fn goal_resp(resp: Response(String)) -> Result(resources.Goal, ErrResp) {
  any_resp(resp, resources.goal_decoder(), "Goal")
}

pub fn graphdefinition_create_req(
  resource: resources.Graphdefinition,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.graphdefinition_to_json(resource),
    "GraphDefinition",
    client,
  )
}

pub fn graphdefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "GraphDefinition", client)
}

pub fn graphdefinition_update_req(
  resource: resources.Graphdefinition,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.graphdefinition_to_json(resource),
    "GraphDefinition",
    client,
  )
}

pub fn graphdefinition_resp(
  resp: Response(String),
) -> Result(resources.Graphdefinition, ErrResp) {
  any_resp(resp, resources.graphdefinition_decoder(), "GraphDefinition")
}

pub fn group_create_req(
  resource: resources.Group,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.group_to_json(resource), "Group", client)
}

pub fn group_read_req(id: String, client: FhirClient) -> Request(Option(Json)) {
  any_read_req(id, "Group", client)
}

pub fn group_update_req(
  resource: resources.Group,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.group_to_json(resource),
    "Group",
    client,
  )
}

pub fn group_resp(resp: Response(String)) -> Result(resources.Group, ErrResp) {
  any_resp(resp, resources.group_decoder(), "Group")
}

pub fn guidanceresponse_create_req(
  resource: resources.Guidanceresponse,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.guidanceresponse_to_json(resource),
    "GuidanceResponse",
    client,
  )
}

pub fn guidanceresponse_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "GuidanceResponse", client)
}

pub fn guidanceresponse_update_req(
  resource: resources.Guidanceresponse,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.guidanceresponse_to_json(resource),
    "GuidanceResponse",
    client,
  )
}

pub fn guidanceresponse_resp(
  resp: Response(String),
) -> Result(resources.Guidanceresponse, ErrResp) {
  any_resp(resp, resources.guidanceresponse_decoder(), "GuidanceResponse")
}

pub fn healthcareservice_create_req(
  resource: resources.Healthcareservice,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.healthcareservice_to_json(resource),
    "HealthcareService",
    client,
  )
}

pub fn healthcareservice_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "HealthcareService", client)
}

pub fn healthcareservice_update_req(
  resource: resources.Healthcareservice,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.healthcareservice_to_json(resource),
    "HealthcareService",
    client,
  )
}

pub fn healthcareservice_resp(
  resp: Response(String),
) -> Result(resources.Healthcareservice, ErrResp) {
  any_resp(resp, resources.healthcareservice_decoder(), "HealthcareService")
}

pub fn imagingselection_create_req(
  resource: resources.Imagingselection,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.imagingselection_to_json(resource),
    "ImagingSelection",
    client,
  )
}

pub fn imagingselection_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "ImagingSelection", client)
}

pub fn imagingselection_update_req(
  resource: resources.Imagingselection,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.imagingselection_to_json(resource),
    "ImagingSelection",
    client,
  )
}

pub fn imagingselection_resp(
  resp: Response(String),
) -> Result(resources.Imagingselection, ErrResp) {
  any_resp(resp, resources.imagingselection_decoder(), "ImagingSelection")
}

pub fn imagingstudy_create_req(
  resource: resources.Imagingstudy,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.imagingstudy_to_json(resource),
    "ImagingStudy",
    client,
  )
}

pub fn imagingstudy_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "ImagingStudy", client)
}

pub fn imagingstudy_update_req(
  resource: resources.Imagingstudy,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.imagingstudy_to_json(resource),
    "ImagingStudy",
    client,
  )
}

pub fn imagingstudy_resp(
  resp: Response(String),
) -> Result(resources.Imagingstudy, ErrResp) {
  any_resp(resp, resources.imagingstudy_decoder(), "ImagingStudy")
}

pub fn immunization_create_req(
  resource: resources.Immunization,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.immunization_to_json(resource),
    "Immunization",
    client,
  )
}

pub fn immunization_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "Immunization", client)
}

pub fn immunization_update_req(
  resource: resources.Immunization,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.immunization_to_json(resource),
    "Immunization",
    client,
  )
}

pub fn immunization_resp(
  resp: Response(String),
) -> Result(resources.Immunization, ErrResp) {
  any_resp(resp, resources.immunization_decoder(), "Immunization")
}

pub fn immunizationevaluation_create_req(
  resource: resources.Immunizationevaluation,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.immunizationevaluation_to_json(resource),
    "ImmunizationEvaluation",
    client,
  )
}

pub fn immunizationevaluation_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "ImmunizationEvaluation", client)
}

pub fn immunizationevaluation_update_req(
  resource: resources.Immunizationevaluation,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.immunizationevaluation_to_json(resource),
    "ImmunizationEvaluation",
    client,
  )
}

pub fn immunizationevaluation_resp(
  resp: Response(String),
) -> Result(resources.Immunizationevaluation, ErrResp) {
  any_resp(
    resp,
    resources.immunizationevaluation_decoder(),
    "ImmunizationEvaluation",
  )
}

pub fn immunizationrecommendation_create_req(
  resource: resources.Immunizationrecommendation,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.immunizationrecommendation_to_json(resource),
    "ImmunizationRecommendation",
    client,
  )
}

pub fn immunizationrecommendation_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "ImmunizationRecommendation", client)
}

pub fn immunizationrecommendation_update_req(
  resource: resources.Immunizationrecommendation,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.immunizationrecommendation_to_json(resource),
    "ImmunizationRecommendation",
    client,
  )
}

pub fn immunizationrecommendation_resp(
  resp: Response(String),
) -> Result(resources.Immunizationrecommendation, ErrResp) {
  any_resp(
    resp,
    resources.immunizationrecommendation_decoder(),
    "ImmunizationRecommendation",
  )
}

pub fn implementationguide_create_req(
  resource: resources.Implementationguide,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.implementationguide_to_json(resource),
    "ImplementationGuide",
    client,
  )
}

pub fn implementationguide_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "ImplementationGuide", client)
}

pub fn implementationguide_update_req(
  resource: resources.Implementationguide,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.implementationguide_to_json(resource),
    "ImplementationGuide",
    client,
  )
}

pub fn implementationguide_resp(
  resp: Response(String),
) -> Result(resources.Implementationguide, ErrResp) {
  any_resp(resp, resources.implementationguide_decoder(), "ImplementationGuide")
}

pub fn ingredient_create_req(
  resource: resources.Ingredient,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.ingredient_to_json(resource), "Ingredient", client)
}

pub fn ingredient_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "Ingredient", client)
}

pub fn ingredient_update_req(
  resource: resources.Ingredient,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.ingredient_to_json(resource),
    "Ingredient",
    client,
  )
}

pub fn ingredient_resp(
  resp: Response(String),
) -> Result(resources.Ingredient, ErrResp) {
  any_resp(resp, resources.ingredient_decoder(), "Ingredient")
}

pub fn insuranceplan_create_req(
  resource: resources.Insuranceplan,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.insuranceplan_to_json(resource),
    "InsurancePlan",
    client,
  )
}

pub fn insuranceplan_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "InsurancePlan", client)
}

pub fn insuranceplan_update_req(
  resource: resources.Insuranceplan,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.insuranceplan_to_json(resource),
    "InsurancePlan",
    client,
  )
}

pub fn insuranceplan_resp(
  resp: Response(String),
) -> Result(resources.Insuranceplan, ErrResp) {
  any_resp(resp, resources.insuranceplan_decoder(), "InsurancePlan")
}

pub fn inventoryitem_create_req(
  resource: resources.Inventoryitem,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.inventoryitem_to_json(resource),
    "InventoryItem",
    client,
  )
}

pub fn inventoryitem_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "InventoryItem", client)
}

pub fn inventoryitem_update_req(
  resource: resources.Inventoryitem,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.inventoryitem_to_json(resource),
    "InventoryItem",
    client,
  )
}

pub fn inventoryitem_resp(
  resp: Response(String),
) -> Result(resources.Inventoryitem, ErrResp) {
  any_resp(resp, resources.inventoryitem_decoder(), "InventoryItem")
}

pub fn inventoryreport_create_req(
  resource: resources.Inventoryreport,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.inventoryreport_to_json(resource),
    "InventoryReport",
    client,
  )
}

pub fn inventoryreport_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "InventoryReport", client)
}

pub fn inventoryreport_update_req(
  resource: resources.Inventoryreport,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.inventoryreport_to_json(resource),
    "InventoryReport",
    client,
  )
}

pub fn inventoryreport_resp(
  resp: Response(String),
) -> Result(resources.Inventoryreport, ErrResp) {
  any_resp(resp, resources.inventoryreport_decoder(), "InventoryReport")
}

pub fn invoice_create_req(
  resource: resources.Invoice,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.invoice_to_json(resource), "Invoice", client)
}

pub fn invoice_read_req(id: String, client: FhirClient) -> Request(Option(Json)) {
  any_read_req(id, "Invoice", client)
}

pub fn invoice_update_req(
  resource: resources.Invoice,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.invoice_to_json(resource),
    "Invoice",
    client,
  )
}

pub fn invoice_resp(
  resp: Response(String),
) -> Result(resources.Invoice, ErrResp) {
  any_resp(resp, resources.invoice_decoder(), "Invoice")
}

pub fn library_create_req(
  resource: resources.Library,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.library_to_json(resource), "Library", client)
}

pub fn library_read_req(id: String, client: FhirClient) -> Request(Option(Json)) {
  any_read_req(id, "Library", client)
}

pub fn library_update_req(
  resource: resources.Library,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.library_to_json(resource),
    "Library",
    client,
  )
}

pub fn library_resp(
  resp: Response(String),
) -> Result(resources.Library, ErrResp) {
  any_resp(resp, resources.library_decoder(), "Library")
}

pub fn linkage_create_req(
  resource: resources.Linkage,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.linkage_to_json(resource), "Linkage", client)
}

pub fn linkage_read_req(id: String, client: FhirClient) -> Request(Option(Json)) {
  any_read_req(id, "Linkage", client)
}

pub fn linkage_update_req(
  resource: resources.Linkage,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.linkage_to_json(resource),
    "Linkage",
    client,
  )
}

pub fn linkage_resp(
  resp: Response(String),
) -> Result(resources.Linkage, ErrResp) {
  any_resp(resp, resources.linkage_decoder(), "Linkage")
}

pub fn listfhir_create_req(
  resource: resources.Listfhir,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.listfhir_to_json(resource), "List", client)
}

pub fn listfhir_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "List", client)
}

pub fn listfhir_update_req(
  resource: resources.Listfhir,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.listfhir_to_json(resource),
    "List",
    client,
  )
}

pub fn listfhir_resp(
  resp: Response(String),
) -> Result(resources.Listfhir, ErrResp) {
  any_resp(resp, resources.listfhir_decoder(), "List")
}

pub fn location_create_req(
  resource: resources.Location,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.location_to_json(resource), "Location", client)
}

pub fn location_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "Location", client)
}

pub fn location_update_req(
  resource: resources.Location,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.location_to_json(resource),
    "Location",
    client,
  )
}

pub fn location_resp(
  resp: Response(String),
) -> Result(resources.Location, ErrResp) {
  any_resp(resp, resources.location_decoder(), "Location")
}

pub fn manufactureditemdefinition_create_req(
  resource: resources.Manufactureditemdefinition,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.manufactureditemdefinition_to_json(resource),
    "ManufacturedItemDefinition",
    client,
  )
}

pub fn manufactureditemdefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "ManufacturedItemDefinition", client)
}

pub fn manufactureditemdefinition_update_req(
  resource: resources.Manufactureditemdefinition,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.manufactureditemdefinition_to_json(resource),
    "ManufacturedItemDefinition",
    client,
  )
}

pub fn manufactureditemdefinition_resp(
  resp: Response(String),
) -> Result(resources.Manufactureditemdefinition, ErrResp) {
  any_resp(
    resp,
    resources.manufactureditemdefinition_decoder(),
    "ManufacturedItemDefinition",
  )
}

pub fn measure_create_req(
  resource: resources.Measure,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.measure_to_json(resource), "Measure", client)
}

pub fn measure_read_req(id: String, client: FhirClient) -> Request(Option(Json)) {
  any_read_req(id, "Measure", client)
}

pub fn measure_update_req(
  resource: resources.Measure,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.measure_to_json(resource),
    "Measure",
    client,
  )
}

pub fn measure_resp(
  resp: Response(String),
) -> Result(resources.Measure, ErrResp) {
  any_resp(resp, resources.measure_decoder(), "Measure")
}

pub fn measurereport_create_req(
  resource: resources.Measurereport,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.measurereport_to_json(resource),
    "MeasureReport",
    client,
  )
}

pub fn measurereport_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "MeasureReport", client)
}

pub fn measurereport_update_req(
  resource: resources.Measurereport,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.measurereport_to_json(resource),
    "MeasureReport",
    client,
  )
}

pub fn measurereport_resp(
  resp: Response(String),
) -> Result(resources.Measurereport, ErrResp) {
  any_resp(resp, resources.measurereport_decoder(), "MeasureReport")
}

pub fn medication_create_req(
  resource: resources.Medication,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.medication_to_json(resource), "Medication", client)
}

pub fn medication_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "Medication", client)
}

pub fn medication_update_req(
  resource: resources.Medication,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.medication_to_json(resource),
    "Medication",
    client,
  )
}

pub fn medication_resp(
  resp: Response(String),
) -> Result(resources.Medication, ErrResp) {
  any_resp(resp, resources.medication_decoder(), "Medication")
}

pub fn medicationadministration_create_req(
  resource: resources.Medicationadministration,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.medicationadministration_to_json(resource),
    "MedicationAdministration",
    client,
  )
}

pub fn medicationadministration_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "MedicationAdministration", client)
}

pub fn medicationadministration_update_req(
  resource: resources.Medicationadministration,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.medicationadministration_to_json(resource),
    "MedicationAdministration",
    client,
  )
}

pub fn medicationadministration_resp(
  resp: Response(String),
) -> Result(resources.Medicationadministration, ErrResp) {
  any_resp(
    resp,
    resources.medicationadministration_decoder(),
    "MedicationAdministration",
  )
}

pub fn medicationdispense_create_req(
  resource: resources.Medicationdispense,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.medicationdispense_to_json(resource),
    "MedicationDispense",
    client,
  )
}

pub fn medicationdispense_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "MedicationDispense", client)
}

pub fn medicationdispense_update_req(
  resource: resources.Medicationdispense,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.medicationdispense_to_json(resource),
    "MedicationDispense",
    client,
  )
}

pub fn medicationdispense_resp(
  resp: Response(String),
) -> Result(resources.Medicationdispense, ErrResp) {
  any_resp(resp, resources.medicationdispense_decoder(), "MedicationDispense")
}

pub fn medicationknowledge_create_req(
  resource: resources.Medicationknowledge,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.medicationknowledge_to_json(resource),
    "MedicationKnowledge",
    client,
  )
}

pub fn medicationknowledge_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "MedicationKnowledge", client)
}

pub fn medicationknowledge_update_req(
  resource: resources.Medicationknowledge,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.medicationknowledge_to_json(resource),
    "MedicationKnowledge",
    client,
  )
}

pub fn medicationknowledge_resp(
  resp: Response(String),
) -> Result(resources.Medicationknowledge, ErrResp) {
  any_resp(resp, resources.medicationknowledge_decoder(), "MedicationKnowledge")
}

pub fn medicationrequest_create_req(
  resource: resources.Medicationrequest,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.medicationrequest_to_json(resource),
    "MedicationRequest",
    client,
  )
}

pub fn medicationrequest_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "MedicationRequest", client)
}

pub fn medicationrequest_update_req(
  resource: resources.Medicationrequest,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.medicationrequest_to_json(resource),
    "MedicationRequest",
    client,
  )
}

pub fn medicationrequest_resp(
  resp: Response(String),
) -> Result(resources.Medicationrequest, ErrResp) {
  any_resp(resp, resources.medicationrequest_decoder(), "MedicationRequest")
}

pub fn medicationstatement_create_req(
  resource: resources.Medicationstatement,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.medicationstatement_to_json(resource),
    "MedicationStatement",
    client,
  )
}

pub fn medicationstatement_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "MedicationStatement", client)
}

pub fn medicationstatement_update_req(
  resource: resources.Medicationstatement,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.medicationstatement_to_json(resource),
    "MedicationStatement",
    client,
  )
}

pub fn medicationstatement_resp(
  resp: Response(String),
) -> Result(resources.Medicationstatement, ErrResp) {
  any_resp(resp, resources.medicationstatement_decoder(), "MedicationStatement")
}

pub fn medicinalproductdefinition_create_req(
  resource: resources.Medicinalproductdefinition,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.medicinalproductdefinition_to_json(resource),
    "MedicinalProductDefinition",
    client,
  )
}

pub fn medicinalproductdefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "MedicinalProductDefinition", client)
}

pub fn medicinalproductdefinition_update_req(
  resource: resources.Medicinalproductdefinition,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.medicinalproductdefinition_to_json(resource),
    "MedicinalProductDefinition",
    client,
  )
}

pub fn medicinalproductdefinition_resp(
  resp: Response(String),
) -> Result(resources.Medicinalproductdefinition, ErrResp) {
  any_resp(
    resp,
    resources.medicinalproductdefinition_decoder(),
    "MedicinalProductDefinition",
  )
}

pub fn messagedefinition_create_req(
  resource: resources.Messagedefinition,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.messagedefinition_to_json(resource),
    "MessageDefinition",
    client,
  )
}

pub fn messagedefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "MessageDefinition", client)
}

pub fn messagedefinition_update_req(
  resource: resources.Messagedefinition,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.messagedefinition_to_json(resource),
    "MessageDefinition",
    client,
  )
}

pub fn messagedefinition_resp(
  resp: Response(String),
) -> Result(resources.Messagedefinition, ErrResp) {
  any_resp(resp, resources.messagedefinition_decoder(), "MessageDefinition")
}

pub fn messageheader_create_req(
  resource: resources.Messageheader,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.messageheader_to_json(resource),
    "MessageHeader",
    client,
  )
}

pub fn messageheader_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "MessageHeader", client)
}

pub fn messageheader_update_req(
  resource: resources.Messageheader,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.messageheader_to_json(resource),
    "MessageHeader",
    client,
  )
}

pub fn messageheader_resp(
  resp: Response(String),
) -> Result(resources.Messageheader, ErrResp) {
  any_resp(resp, resources.messageheader_decoder(), "MessageHeader")
}

pub fn molecularsequence_create_req(
  resource: resources.Molecularsequence,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.molecularsequence_to_json(resource),
    "MolecularSequence",
    client,
  )
}

pub fn molecularsequence_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "MolecularSequence", client)
}

pub fn molecularsequence_update_req(
  resource: resources.Molecularsequence,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.molecularsequence_to_json(resource),
    "MolecularSequence",
    client,
  )
}

pub fn molecularsequence_resp(
  resp: Response(String),
) -> Result(resources.Molecularsequence, ErrResp) {
  any_resp(resp, resources.molecularsequence_decoder(), "MolecularSequence")
}

pub fn namingsystem_create_req(
  resource: resources.Namingsystem,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.namingsystem_to_json(resource),
    "NamingSystem",
    client,
  )
}

pub fn namingsystem_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "NamingSystem", client)
}

pub fn namingsystem_update_req(
  resource: resources.Namingsystem,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.namingsystem_to_json(resource),
    "NamingSystem",
    client,
  )
}

pub fn namingsystem_resp(
  resp: Response(String),
) -> Result(resources.Namingsystem, ErrResp) {
  any_resp(resp, resources.namingsystem_decoder(), "NamingSystem")
}

pub fn nutritionintake_create_req(
  resource: resources.Nutritionintake,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.nutritionintake_to_json(resource),
    "NutritionIntake",
    client,
  )
}

pub fn nutritionintake_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "NutritionIntake", client)
}

pub fn nutritionintake_update_req(
  resource: resources.Nutritionintake,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.nutritionintake_to_json(resource),
    "NutritionIntake",
    client,
  )
}

pub fn nutritionintake_resp(
  resp: Response(String),
) -> Result(resources.Nutritionintake, ErrResp) {
  any_resp(resp, resources.nutritionintake_decoder(), "NutritionIntake")
}

pub fn nutritionorder_create_req(
  resource: resources.Nutritionorder,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.nutritionorder_to_json(resource),
    "NutritionOrder",
    client,
  )
}

pub fn nutritionorder_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "NutritionOrder", client)
}

pub fn nutritionorder_update_req(
  resource: resources.Nutritionorder,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.nutritionorder_to_json(resource),
    "NutritionOrder",
    client,
  )
}

pub fn nutritionorder_resp(
  resp: Response(String),
) -> Result(resources.Nutritionorder, ErrResp) {
  any_resp(resp, resources.nutritionorder_decoder(), "NutritionOrder")
}

pub fn nutritionproduct_create_req(
  resource: resources.Nutritionproduct,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.nutritionproduct_to_json(resource),
    "NutritionProduct",
    client,
  )
}

pub fn nutritionproduct_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "NutritionProduct", client)
}

pub fn nutritionproduct_update_req(
  resource: resources.Nutritionproduct,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.nutritionproduct_to_json(resource),
    "NutritionProduct",
    client,
  )
}

pub fn nutritionproduct_resp(
  resp: Response(String),
) -> Result(resources.Nutritionproduct, ErrResp) {
  any_resp(resp, resources.nutritionproduct_decoder(), "NutritionProduct")
}

pub fn observation_create_req(
  resource: resources.Observation,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.observation_to_json(resource), "Observation", client)
}

pub fn observation_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "Observation", client)
}

pub fn observation_update_req(
  resource: resources.Observation,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.observation_to_json(resource),
    "Observation",
    client,
  )
}

pub fn observation_resp(
  resp: Response(String),
) -> Result(resources.Observation, ErrResp) {
  any_resp(resp, resources.observation_decoder(), "Observation")
}

pub fn observationdefinition_create_req(
  resource: resources.Observationdefinition,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.observationdefinition_to_json(resource),
    "ObservationDefinition",
    client,
  )
}

pub fn observationdefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "ObservationDefinition", client)
}

pub fn observationdefinition_update_req(
  resource: resources.Observationdefinition,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.observationdefinition_to_json(resource),
    "ObservationDefinition",
    client,
  )
}

pub fn observationdefinition_resp(
  resp: Response(String),
) -> Result(resources.Observationdefinition, ErrResp) {
  any_resp(
    resp,
    resources.observationdefinition_decoder(),
    "ObservationDefinition",
  )
}

pub fn operationdefinition_create_req(
  resource: resources.Operationdefinition,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.operationdefinition_to_json(resource),
    "OperationDefinition",
    client,
  )
}

pub fn operationdefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "OperationDefinition", client)
}

pub fn operationdefinition_update_req(
  resource: resources.Operationdefinition,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.operationdefinition_to_json(resource),
    "OperationDefinition",
    client,
  )
}

pub fn operationdefinition_resp(
  resp: Response(String),
) -> Result(resources.Operationdefinition, ErrResp) {
  any_resp(resp, resources.operationdefinition_decoder(), "OperationDefinition")
}

pub fn operationoutcome_create_req(
  resource: resources.Operationoutcome,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.operationoutcome_to_json(resource),
    "OperationOutcome",
    client,
  )
}

pub fn operationoutcome_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "OperationOutcome", client)
}

pub fn operationoutcome_update_req(
  resource: resources.Operationoutcome,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.operationoutcome_to_json(resource),
    "OperationOutcome",
    client,
  )
}

pub fn operationoutcome_resp(
  resp: Response(String),
) -> Result(resources.Operationoutcome, ErrResp) {
  any_resp(resp, resources.operationoutcome_decoder(), "OperationOutcome")
}

pub fn organization_create_req(
  resource: resources.Organization,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.organization_to_json(resource),
    "Organization",
    client,
  )
}

pub fn organization_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "Organization", client)
}

pub fn organization_update_req(
  resource: resources.Organization,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.organization_to_json(resource),
    "Organization",
    client,
  )
}

pub fn organization_resp(
  resp: Response(String),
) -> Result(resources.Organization, ErrResp) {
  any_resp(resp, resources.organization_decoder(), "Organization")
}

pub fn organizationaffiliation_create_req(
  resource: resources.Organizationaffiliation,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.organizationaffiliation_to_json(resource),
    "OrganizationAffiliation",
    client,
  )
}

pub fn organizationaffiliation_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "OrganizationAffiliation", client)
}

pub fn organizationaffiliation_update_req(
  resource: resources.Organizationaffiliation,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.organizationaffiliation_to_json(resource),
    "OrganizationAffiliation",
    client,
  )
}

pub fn organizationaffiliation_resp(
  resp: Response(String),
) -> Result(resources.Organizationaffiliation, ErrResp) {
  any_resp(
    resp,
    resources.organizationaffiliation_decoder(),
    "OrganizationAffiliation",
  )
}

pub fn packagedproductdefinition_create_req(
  resource: resources.Packagedproductdefinition,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.packagedproductdefinition_to_json(resource),
    "PackagedProductDefinition",
    client,
  )
}

pub fn packagedproductdefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "PackagedProductDefinition", client)
}

pub fn packagedproductdefinition_update_req(
  resource: resources.Packagedproductdefinition,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.packagedproductdefinition_to_json(resource),
    "PackagedProductDefinition",
    client,
  )
}

pub fn packagedproductdefinition_resp(
  resp: Response(String),
) -> Result(resources.Packagedproductdefinition, ErrResp) {
  any_resp(
    resp,
    resources.packagedproductdefinition_decoder(),
    "PackagedProductDefinition",
  )
}

pub fn patient_create_req(
  resource: resources.Patient,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.patient_to_json(resource), "Patient", client)
}

pub fn patient_read_req(id: String, client: FhirClient) -> Request(Option(Json)) {
  any_read_req(id, "Patient", client)
}

pub fn patient_update_req(
  resource: resources.Patient,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.patient_to_json(resource),
    "Patient",
    client,
  )
}

pub fn patient_resp(
  resp: Response(String),
) -> Result(resources.Patient, ErrResp) {
  any_resp(resp, resources.patient_decoder(), "Patient")
}

pub fn paymentnotice_create_req(
  resource: resources.Paymentnotice,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.paymentnotice_to_json(resource),
    "PaymentNotice",
    client,
  )
}

pub fn paymentnotice_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "PaymentNotice", client)
}

pub fn paymentnotice_update_req(
  resource: resources.Paymentnotice,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.paymentnotice_to_json(resource),
    "PaymentNotice",
    client,
  )
}

pub fn paymentnotice_resp(
  resp: Response(String),
) -> Result(resources.Paymentnotice, ErrResp) {
  any_resp(resp, resources.paymentnotice_decoder(), "PaymentNotice")
}

pub fn paymentreconciliation_create_req(
  resource: resources.Paymentreconciliation,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.paymentreconciliation_to_json(resource),
    "PaymentReconciliation",
    client,
  )
}

pub fn paymentreconciliation_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "PaymentReconciliation", client)
}

pub fn paymentreconciliation_update_req(
  resource: resources.Paymentreconciliation,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.paymentreconciliation_to_json(resource),
    "PaymentReconciliation",
    client,
  )
}

pub fn paymentreconciliation_resp(
  resp: Response(String),
) -> Result(resources.Paymentreconciliation, ErrResp) {
  any_resp(
    resp,
    resources.paymentreconciliation_decoder(),
    "PaymentReconciliation",
  )
}

pub fn permission_create_req(
  resource: resources.Permission,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.permission_to_json(resource), "Permission", client)
}

pub fn permission_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "Permission", client)
}

pub fn permission_update_req(
  resource: resources.Permission,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.permission_to_json(resource),
    "Permission",
    client,
  )
}

pub fn permission_resp(
  resp: Response(String),
) -> Result(resources.Permission, ErrResp) {
  any_resp(resp, resources.permission_decoder(), "Permission")
}

pub fn person_create_req(
  resource: resources.Person,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.person_to_json(resource), "Person", client)
}

pub fn person_read_req(id: String, client: FhirClient) -> Request(Option(Json)) {
  any_read_req(id, "Person", client)
}

pub fn person_update_req(
  resource: resources.Person,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.person_to_json(resource),
    "Person",
    client,
  )
}

pub fn person_resp(resp: Response(String)) -> Result(resources.Person, ErrResp) {
  any_resp(resp, resources.person_decoder(), "Person")
}

pub fn plandefinition_create_req(
  resource: resources.Plandefinition,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.plandefinition_to_json(resource),
    "PlanDefinition",
    client,
  )
}

pub fn plandefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "PlanDefinition", client)
}

pub fn plandefinition_update_req(
  resource: resources.Plandefinition,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.plandefinition_to_json(resource),
    "PlanDefinition",
    client,
  )
}

pub fn plandefinition_resp(
  resp: Response(String),
) -> Result(resources.Plandefinition, ErrResp) {
  any_resp(resp, resources.plandefinition_decoder(), "PlanDefinition")
}

pub fn practitioner_create_req(
  resource: resources.Practitioner,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.practitioner_to_json(resource),
    "Practitioner",
    client,
  )
}

pub fn practitioner_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "Practitioner", client)
}

pub fn practitioner_update_req(
  resource: resources.Practitioner,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.practitioner_to_json(resource),
    "Practitioner",
    client,
  )
}

pub fn practitioner_resp(
  resp: Response(String),
) -> Result(resources.Practitioner, ErrResp) {
  any_resp(resp, resources.practitioner_decoder(), "Practitioner")
}

pub fn practitionerrole_create_req(
  resource: resources.Practitionerrole,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.practitionerrole_to_json(resource),
    "PractitionerRole",
    client,
  )
}

pub fn practitionerrole_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "PractitionerRole", client)
}

pub fn practitionerrole_update_req(
  resource: resources.Practitionerrole,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.practitionerrole_to_json(resource),
    "PractitionerRole",
    client,
  )
}

pub fn practitionerrole_resp(
  resp: Response(String),
) -> Result(resources.Practitionerrole, ErrResp) {
  any_resp(resp, resources.practitionerrole_decoder(), "PractitionerRole")
}

pub fn procedure_create_req(
  resource: resources.Procedure,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.procedure_to_json(resource), "Procedure", client)
}

pub fn procedure_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "Procedure", client)
}

pub fn procedure_update_req(
  resource: resources.Procedure,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.procedure_to_json(resource),
    "Procedure",
    client,
  )
}

pub fn procedure_resp(
  resp: Response(String),
) -> Result(resources.Procedure, ErrResp) {
  any_resp(resp, resources.procedure_decoder(), "Procedure")
}

pub fn provenance_create_req(
  resource: resources.Provenance,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.provenance_to_json(resource), "Provenance", client)
}

pub fn provenance_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "Provenance", client)
}

pub fn provenance_update_req(
  resource: resources.Provenance,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.provenance_to_json(resource),
    "Provenance",
    client,
  )
}

pub fn provenance_resp(
  resp: Response(String),
) -> Result(resources.Provenance, ErrResp) {
  any_resp(resp, resources.provenance_decoder(), "Provenance")
}

pub fn questionnaire_create_req(
  resource: resources.Questionnaire,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.questionnaire_to_json(resource),
    "Questionnaire",
    client,
  )
}

pub fn questionnaire_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "Questionnaire", client)
}

pub fn questionnaire_update_req(
  resource: resources.Questionnaire,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.questionnaire_to_json(resource),
    "Questionnaire",
    client,
  )
}

pub fn questionnaire_resp(
  resp: Response(String),
) -> Result(resources.Questionnaire, ErrResp) {
  any_resp(resp, resources.questionnaire_decoder(), "Questionnaire")
}

pub fn questionnaireresponse_create_req(
  resource: resources.Questionnaireresponse,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    client,
  )
}

pub fn questionnaireresponse_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "QuestionnaireResponse", client)
}

pub fn questionnaireresponse_update_req(
  resource: resources.Questionnaireresponse,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    client,
  )
}

pub fn questionnaireresponse_resp(
  resp: Response(String),
) -> Result(resources.Questionnaireresponse, ErrResp) {
  any_resp(
    resp,
    resources.questionnaireresponse_decoder(),
    "QuestionnaireResponse",
  )
}

pub fn regulatedauthorization_create_req(
  resource: resources.Regulatedauthorization,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.regulatedauthorization_to_json(resource),
    "RegulatedAuthorization",
    client,
  )
}

pub fn regulatedauthorization_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "RegulatedAuthorization", client)
}

pub fn regulatedauthorization_update_req(
  resource: resources.Regulatedauthorization,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.regulatedauthorization_to_json(resource),
    "RegulatedAuthorization",
    client,
  )
}

pub fn regulatedauthorization_resp(
  resp: Response(String),
) -> Result(resources.Regulatedauthorization, ErrResp) {
  any_resp(
    resp,
    resources.regulatedauthorization_decoder(),
    "RegulatedAuthorization",
  )
}

pub fn relatedperson_create_req(
  resource: resources.Relatedperson,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.relatedperson_to_json(resource),
    "RelatedPerson",
    client,
  )
}

pub fn relatedperson_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "RelatedPerson", client)
}

pub fn relatedperson_update_req(
  resource: resources.Relatedperson,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.relatedperson_to_json(resource),
    "RelatedPerson",
    client,
  )
}

pub fn relatedperson_resp(
  resp: Response(String),
) -> Result(resources.Relatedperson, ErrResp) {
  any_resp(resp, resources.relatedperson_decoder(), "RelatedPerson")
}

pub fn requestorchestration_create_req(
  resource: resources.Requestorchestration,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.requestorchestration_to_json(resource),
    "RequestOrchestration",
    client,
  )
}

pub fn requestorchestration_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "RequestOrchestration", client)
}

pub fn requestorchestration_update_req(
  resource: resources.Requestorchestration,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.requestorchestration_to_json(resource),
    "RequestOrchestration",
    client,
  )
}

pub fn requestorchestration_resp(
  resp: Response(String),
) -> Result(resources.Requestorchestration, ErrResp) {
  any_resp(
    resp,
    resources.requestorchestration_decoder(),
    "RequestOrchestration",
  )
}

pub fn requirements_create_req(
  resource: resources.Requirements,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.requirements_to_json(resource),
    "Requirements",
    client,
  )
}

pub fn requirements_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "Requirements", client)
}

pub fn requirements_update_req(
  resource: resources.Requirements,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.requirements_to_json(resource),
    "Requirements",
    client,
  )
}

pub fn requirements_resp(
  resp: Response(String),
) -> Result(resources.Requirements, ErrResp) {
  any_resp(resp, resources.requirements_decoder(), "Requirements")
}

pub fn researchstudy_create_req(
  resource: resources.Researchstudy,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.researchstudy_to_json(resource),
    "ResearchStudy",
    client,
  )
}

pub fn researchstudy_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "ResearchStudy", client)
}

pub fn researchstudy_update_req(
  resource: resources.Researchstudy,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.researchstudy_to_json(resource),
    "ResearchStudy",
    client,
  )
}

pub fn researchstudy_resp(
  resp: Response(String),
) -> Result(resources.Researchstudy, ErrResp) {
  any_resp(resp, resources.researchstudy_decoder(), "ResearchStudy")
}

pub fn researchsubject_create_req(
  resource: resources.Researchsubject,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.researchsubject_to_json(resource),
    "ResearchSubject",
    client,
  )
}

pub fn researchsubject_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "ResearchSubject", client)
}

pub fn researchsubject_update_req(
  resource: resources.Researchsubject,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.researchsubject_to_json(resource),
    "ResearchSubject",
    client,
  )
}

pub fn researchsubject_resp(
  resp: Response(String),
) -> Result(resources.Researchsubject, ErrResp) {
  any_resp(resp, resources.researchsubject_decoder(), "ResearchSubject")
}

pub fn riskassessment_create_req(
  resource: resources.Riskassessment,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.riskassessment_to_json(resource),
    "RiskAssessment",
    client,
  )
}

pub fn riskassessment_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "RiskAssessment", client)
}

pub fn riskassessment_update_req(
  resource: resources.Riskassessment,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.riskassessment_to_json(resource),
    "RiskAssessment",
    client,
  )
}

pub fn riskassessment_resp(
  resp: Response(String),
) -> Result(resources.Riskassessment, ErrResp) {
  any_resp(resp, resources.riskassessment_decoder(), "RiskAssessment")
}

pub fn schedule_create_req(
  resource: resources.Schedule,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.schedule_to_json(resource), "Schedule", client)
}

pub fn schedule_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "Schedule", client)
}

pub fn schedule_update_req(
  resource: resources.Schedule,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.schedule_to_json(resource),
    "Schedule",
    client,
  )
}

pub fn schedule_resp(
  resp: Response(String),
) -> Result(resources.Schedule, ErrResp) {
  any_resp(resp, resources.schedule_decoder(), "Schedule")
}

pub fn searchparameter_create_req(
  resource: resources.Searchparameter,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.searchparameter_to_json(resource),
    "SearchParameter",
    client,
  )
}

pub fn searchparameter_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "SearchParameter", client)
}

pub fn searchparameter_update_req(
  resource: resources.Searchparameter,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.searchparameter_to_json(resource),
    "SearchParameter",
    client,
  )
}

pub fn searchparameter_resp(
  resp: Response(String),
) -> Result(resources.Searchparameter, ErrResp) {
  any_resp(resp, resources.searchparameter_decoder(), "SearchParameter")
}

pub fn servicerequest_create_req(
  resource: resources.Servicerequest,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.servicerequest_to_json(resource),
    "ServiceRequest",
    client,
  )
}

pub fn servicerequest_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "ServiceRequest", client)
}

pub fn servicerequest_update_req(
  resource: resources.Servicerequest,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.servicerequest_to_json(resource),
    "ServiceRequest",
    client,
  )
}

pub fn servicerequest_resp(
  resp: Response(String),
) -> Result(resources.Servicerequest, ErrResp) {
  any_resp(resp, resources.servicerequest_decoder(), "ServiceRequest")
}

pub fn slot_create_req(
  resource: resources.Slot,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.slot_to_json(resource), "Slot", client)
}

pub fn slot_read_req(id: String, client: FhirClient) -> Request(Option(Json)) {
  any_read_req(id, "Slot", client)
}

pub fn slot_update_req(
  resource: resources.Slot,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(resource.id, resources.slot_to_json(resource), "Slot", client)
}

pub fn slot_resp(resp: Response(String)) -> Result(resources.Slot, ErrResp) {
  any_resp(resp, resources.slot_decoder(), "Slot")
}

pub fn specimen_create_req(
  resource: resources.Specimen,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.specimen_to_json(resource), "Specimen", client)
}

pub fn specimen_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "Specimen", client)
}

pub fn specimen_update_req(
  resource: resources.Specimen,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.specimen_to_json(resource),
    "Specimen",
    client,
  )
}

pub fn specimen_resp(
  resp: Response(String),
) -> Result(resources.Specimen, ErrResp) {
  any_resp(resp, resources.specimen_decoder(), "Specimen")
}

pub fn specimendefinition_create_req(
  resource: resources.Specimendefinition,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.specimendefinition_to_json(resource),
    "SpecimenDefinition",
    client,
  )
}

pub fn specimendefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "SpecimenDefinition", client)
}

pub fn specimendefinition_update_req(
  resource: resources.Specimendefinition,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.specimendefinition_to_json(resource),
    "SpecimenDefinition",
    client,
  )
}

pub fn specimendefinition_resp(
  resp: Response(String),
) -> Result(resources.Specimendefinition, ErrResp) {
  any_resp(resp, resources.specimendefinition_decoder(), "SpecimenDefinition")
}

pub fn structuredefinition_create_req(
  resource: resources.Structuredefinition,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.structuredefinition_to_json(resource),
    "StructureDefinition",
    client,
  )
}

pub fn structuredefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "StructureDefinition", client)
}

pub fn structuredefinition_update_req(
  resource: resources.Structuredefinition,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.structuredefinition_to_json(resource),
    "StructureDefinition",
    client,
  )
}

pub fn structuredefinition_resp(
  resp: Response(String),
) -> Result(resources.Structuredefinition, ErrResp) {
  any_resp(resp, resources.structuredefinition_decoder(), "StructureDefinition")
}

pub fn structuremap_create_req(
  resource: resources.Structuremap,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.structuremap_to_json(resource),
    "StructureMap",
    client,
  )
}

pub fn structuremap_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "StructureMap", client)
}

pub fn structuremap_update_req(
  resource: resources.Structuremap,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.structuremap_to_json(resource),
    "StructureMap",
    client,
  )
}

pub fn structuremap_resp(
  resp: Response(String),
) -> Result(resources.Structuremap, ErrResp) {
  any_resp(resp, resources.structuremap_decoder(), "StructureMap")
}

pub fn subscription_create_req(
  resource: resources.Subscription,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.subscription_to_json(resource),
    "Subscription",
    client,
  )
}

pub fn subscription_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "Subscription", client)
}

pub fn subscription_update_req(
  resource: resources.Subscription,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.subscription_to_json(resource),
    "Subscription",
    client,
  )
}

pub fn subscription_resp(
  resp: Response(String),
) -> Result(resources.Subscription, ErrResp) {
  any_resp(resp, resources.subscription_decoder(), "Subscription")
}

pub fn subscriptionstatus_create_req(
  resource: resources.Subscriptionstatus,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.subscriptionstatus_to_json(resource),
    "SubscriptionStatus",
    client,
  )
}

pub fn subscriptionstatus_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "SubscriptionStatus", client)
}

pub fn subscriptionstatus_update_req(
  resource: resources.Subscriptionstatus,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.subscriptionstatus_to_json(resource),
    "SubscriptionStatus",
    client,
  )
}

pub fn subscriptionstatus_resp(
  resp: Response(String),
) -> Result(resources.Subscriptionstatus, ErrResp) {
  any_resp(resp, resources.subscriptionstatus_decoder(), "SubscriptionStatus")
}

pub fn subscriptiontopic_create_req(
  resource: resources.Subscriptiontopic,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.subscriptiontopic_to_json(resource),
    "SubscriptionTopic",
    client,
  )
}

pub fn subscriptiontopic_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "SubscriptionTopic", client)
}

pub fn subscriptiontopic_update_req(
  resource: resources.Subscriptiontopic,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.subscriptiontopic_to_json(resource),
    "SubscriptionTopic",
    client,
  )
}

pub fn subscriptiontopic_resp(
  resp: Response(String),
) -> Result(resources.Subscriptiontopic, ErrResp) {
  any_resp(resp, resources.subscriptiontopic_decoder(), "SubscriptionTopic")
}

pub fn substance_create_req(
  resource: resources.Substance,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.substance_to_json(resource), "Substance", client)
}

pub fn substance_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "Substance", client)
}

pub fn substance_update_req(
  resource: resources.Substance,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.substance_to_json(resource),
    "Substance",
    client,
  )
}

pub fn substance_resp(
  resp: Response(String),
) -> Result(resources.Substance, ErrResp) {
  any_resp(resp, resources.substance_decoder(), "Substance")
}

pub fn substancedefinition_create_req(
  resource: resources.Substancedefinition,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.substancedefinition_to_json(resource),
    "SubstanceDefinition",
    client,
  )
}

pub fn substancedefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "SubstanceDefinition", client)
}

pub fn substancedefinition_update_req(
  resource: resources.Substancedefinition,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.substancedefinition_to_json(resource),
    "SubstanceDefinition",
    client,
  )
}

pub fn substancedefinition_resp(
  resp: Response(String),
) -> Result(resources.Substancedefinition, ErrResp) {
  any_resp(resp, resources.substancedefinition_decoder(), "SubstanceDefinition")
}

pub fn substancenucleicacid_create_req(
  resource: resources.Substancenucleicacid,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.substancenucleicacid_to_json(resource),
    "SubstanceNucleicAcid",
    client,
  )
}

pub fn substancenucleicacid_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "SubstanceNucleicAcid", client)
}

pub fn substancenucleicacid_update_req(
  resource: resources.Substancenucleicacid,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.substancenucleicacid_to_json(resource),
    "SubstanceNucleicAcid",
    client,
  )
}

pub fn substancenucleicacid_resp(
  resp: Response(String),
) -> Result(resources.Substancenucleicacid, ErrResp) {
  any_resp(
    resp,
    resources.substancenucleicacid_decoder(),
    "SubstanceNucleicAcid",
  )
}

pub fn substancepolymer_create_req(
  resource: resources.Substancepolymer,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.substancepolymer_to_json(resource),
    "SubstancePolymer",
    client,
  )
}

pub fn substancepolymer_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "SubstancePolymer", client)
}

pub fn substancepolymer_update_req(
  resource: resources.Substancepolymer,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.substancepolymer_to_json(resource),
    "SubstancePolymer",
    client,
  )
}

pub fn substancepolymer_resp(
  resp: Response(String),
) -> Result(resources.Substancepolymer, ErrResp) {
  any_resp(resp, resources.substancepolymer_decoder(), "SubstancePolymer")
}

pub fn substanceprotein_create_req(
  resource: resources.Substanceprotein,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.substanceprotein_to_json(resource),
    "SubstanceProtein",
    client,
  )
}

pub fn substanceprotein_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "SubstanceProtein", client)
}

pub fn substanceprotein_update_req(
  resource: resources.Substanceprotein,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.substanceprotein_to_json(resource),
    "SubstanceProtein",
    client,
  )
}

pub fn substanceprotein_resp(
  resp: Response(String),
) -> Result(resources.Substanceprotein, ErrResp) {
  any_resp(resp, resources.substanceprotein_decoder(), "SubstanceProtein")
}

pub fn substancereferenceinformation_create_req(
  resource: resources.Substancereferenceinformation,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.substancereferenceinformation_to_json(resource),
    "SubstanceReferenceInformation",
    client,
  )
}

pub fn substancereferenceinformation_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "SubstanceReferenceInformation", client)
}

pub fn substancereferenceinformation_update_req(
  resource: resources.Substancereferenceinformation,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.substancereferenceinformation_to_json(resource),
    "SubstanceReferenceInformation",
    client,
  )
}

pub fn substancereferenceinformation_resp(
  resp: Response(String),
) -> Result(resources.Substancereferenceinformation, ErrResp) {
  any_resp(
    resp,
    resources.substancereferenceinformation_decoder(),
    "SubstanceReferenceInformation",
  )
}

pub fn substancesourcematerial_create_req(
  resource: resources.Substancesourcematerial,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.substancesourcematerial_to_json(resource),
    "SubstanceSourceMaterial",
    client,
  )
}

pub fn substancesourcematerial_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "SubstanceSourceMaterial", client)
}

pub fn substancesourcematerial_update_req(
  resource: resources.Substancesourcematerial,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.substancesourcematerial_to_json(resource),
    "SubstanceSourceMaterial",
    client,
  )
}

pub fn substancesourcematerial_resp(
  resp: Response(String),
) -> Result(resources.Substancesourcematerial, ErrResp) {
  any_resp(
    resp,
    resources.substancesourcematerial_decoder(),
    "SubstanceSourceMaterial",
  )
}

pub fn supplydelivery_create_req(
  resource: resources.Supplydelivery,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.supplydelivery_to_json(resource),
    "SupplyDelivery",
    client,
  )
}

pub fn supplydelivery_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "SupplyDelivery", client)
}

pub fn supplydelivery_update_req(
  resource: resources.Supplydelivery,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.supplydelivery_to_json(resource),
    "SupplyDelivery",
    client,
  )
}

pub fn supplydelivery_resp(
  resp: Response(String),
) -> Result(resources.Supplydelivery, ErrResp) {
  any_resp(resp, resources.supplydelivery_decoder(), "SupplyDelivery")
}

pub fn supplyrequest_create_req(
  resource: resources.Supplyrequest,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.supplyrequest_to_json(resource),
    "SupplyRequest",
    client,
  )
}

pub fn supplyrequest_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "SupplyRequest", client)
}

pub fn supplyrequest_update_req(
  resource: resources.Supplyrequest,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.supplyrequest_to_json(resource),
    "SupplyRequest",
    client,
  )
}

pub fn supplyrequest_resp(
  resp: Response(String),
) -> Result(resources.Supplyrequest, ErrResp) {
  any_resp(resp, resources.supplyrequest_decoder(), "SupplyRequest")
}

pub fn task_create_req(
  resource: resources.Task,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.task_to_json(resource), "Task", client)
}

pub fn task_read_req(id: String, client: FhirClient) -> Request(Option(Json)) {
  any_read_req(id, "Task", client)
}

pub fn task_update_req(
  resource: resources.Task,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(resource.id, resources.task_to_json(resource), "Task", client)
}

pub fn task_resp(resp: Response(String)) -> Result(resources.Task, ErrResp) {
  any_resp(resp, resources.task_decoder(), "Task")
}

pub fn terminologycapabilities_create_req(
  resource: resources.Terminologycapabilities,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.terminologycapabilities_to_json(resource),
    "TerminologyCapabilities",
    client,
  )
}

pub fn terminologycapabilities_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "TerminologyCapabilities", client)
}

pub fn terminologycapabilities_update_req(
  resource: resources.Terminologycapabilities,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.terminologycapabilities_to_json(resource),
    "TerminologyCapabilities",
    client,
  )
}

pub fn terminologycapabilities_resp(
  resp: Response(String),
) -> Result(resources.Terminologycapabilities, ErrResp) {
  any_resp(
    resp,
    resources.terminologycapabilities_decoder(),
    "TerminologyCapabilities",
  )
}

pub fn testplan_create_req(
  resource: resources.Testplan,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.testplan_to_json(resource), "TestPlan", client)
}

pub fn testplan_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "TestPlan", client)
}

pub fn testplan_update_req(
  resource: resources.Testplan,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.testplan_to_json(resource),
    "TestPlan",
    client,
  )
}

pub fn testplan_resp(
  resp: Response(String),
) -> Result(resources.Testplan, ErrResp) {
  any_resp(resp, resources.testplan_decoder(), "TestPlan")
}

pub fn testreport_create_req(
  resource: resources.Testreport,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.testreport_to_json(resource), "TestReport", client)
}

pub fn testreport_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "TestReport", client)
}

pub fn testreport_update_req(
  resource: resources.Testreport,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.testreport_to_json(resource),
    "TestReport",
    client,
  )
}

pub fn testreport_resp(
  resp: Response(String),
) -> Result(resources.Testreport, ErrResp) {
  any_resp(resp, resources.testreport_decoder(), "TestReport")
}

pub fn testscript_create_req(
  resource: resources.Testscript,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.testscript_to_json(resource), "TestScript", client)
}

pub fn testscript_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "TestScript", client)
}

pub fn testscript_update_req(
  resource: resources.Testscript,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.testscript_to_json(resource),
    "TestScript",
    client,
  )
}

pub fn testscript_resp(
  resp: Response(String),
) -> Result(resources.Testscript, ErrResp) {
  any_resp(resp, resources.testscript_decoder(), "TestScript")
}

pub fn transport_create_req(
  resource: resources.Transport,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.transport_to_json(resource), "Transport", client)
}

pub fn transport_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "Transport", client)
}

pub fn transport_update_req(
  resource: resources.Transport,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.transport_to_json(resource),
    "Transport",
    client,
  )
}

pub fn transport_resp(
  resp: Response(String),
) -> Result(resources.Transport, ErrResp) {
  any_resp(resp, resources.transport_decoder(), "Transport")
}

pub fn valueset_create_req(
  resource: resources.Valueset,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(resources.valueset_to_json(resource), "ValueSet", client)
}

pub fn valueset_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "ValueSet", client)
}

pub fn valueset_update_req(
  resource: resources.Valueset,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.valueset_to_json(resource),
    "ValueSet",
    client,
  )
}

pub fn valueset_resp(
  resp: Response(String),
) -> Result(resources.Valueset, ErrResp) {
  any_resp(resp, resources.valueset_decoder(), "ValueSet")
}

pub fn verificationresult_create_req(
  resource: resources.Verificationresult,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.verificationresult_to_json(resource),
    "VerificationResult",
    client,
  )
}

pub fn verificationresult_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "VerificationResult", client)
}

pub fn verificationresult_update_req(
  resource: resources.Verificationresult,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.verificationresult_to_json(resource),
    "VerificationResult",
    client,
  )
}

pub fn verificationresult_resp(
  resp: Response(String),
) -> Result(resources.Verificationresult, ErrResp) {
  any_resp(resp, resources.verificationresult_decoder(), "VerificationResult")
}

pub fn visionprescription_create_req(
  resource: resources.Visionprescription,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_create_req(
    resources.visionprescription_to_json(resource),
    "VisionPrescription",
    client,
  )
}

pub fn visionprescription_read_req(
  id: String,
  client: FhirClient,
) -> Request(Option(Json)) {
  any_read_req(id, "VisionPrescription", client)
}

pub fn visionprescription_update_req(
  resource: resources.Visionprescription,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  any_update_req(
    resource.id,
    resources.visionprescription_to_json(resource),
    "VisionPrescription",
    client,
  )
}

pub fn visionprescription_resp(
  resp: Response(String),
) -> Result(resources.Visionprescription, ErrResp) {
  any_resp(resp, resources.visionprescription_decoder(), "VisionPrescription")
}

pub type SpAccount {
  SpAccount(
    owner: Option(String),
    identifier: Option(String),
    period: Option(String),
    patient: Option(String),
    subject: Option(String),
    name: Option(String),
    guarantor: Option(String),
    type_: Option(String),
    relatedaccount: Option(String),
    status: Option(String),
  )
}

pub type SpActivitydefinition {
  SpActivitydefinition(
    date: Option(String),
    identifier: Option(String),
    successor: Option(String),
    context_type_value: Option(String),
    kind: Option(String),
    jurisdiction: Option(String),
    derived_from: Option(String),
    description: Option(String),
    context_type: Option(String),
    predecessor: Option(String),
    composed_of: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    depends_on: Option(String),
    effective: Option(String),
    context: Option(String),
    name: Option(String),
    publisher: Option(String),
    topic: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpActordefinition {
  SpActordefinition(
    date: Option(String),
    identifier: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    context_type: Option(String),
    title: Option(String),
    type_: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpAdministrableproductdefinition {
  SpAdministrableproductdefinition(
    identifier: Option(String),
    manufactured_item: Option(String),
    ingredient: Option(String),
    route: Option(String),
    dose_form: Option(String),
    device: Option(String),
    form_of: Option(String),
    target_species: Option(String),
    status: Option(String),
  )
}

pub type SpAdverseevent {
  SpAdverseevent(
    date: Option(String),
    identifier: Option(String),
    recorder: Option(String),
    study: Option(String),
    code: Option(String),
    actuality: Option(String),
    subject: Option(String),
    substance: Option(String),
    patient: Option(String),
    resultingeffect: Option(String),
    seriousness: Option(String),
    location: Option(String),
    category: Option(String),
    status: Option(String),
  )
}

pub type SpAllergyintolerance {
  SpAllergyintolerance(
    date: Option(String),
    severity: Option(String),
    identifier: Option(String),
    code: Option(String),
    verification_status: Option(String),
    criticality: Option(String),
    manifestation_reference: Option(String),
    clinical_status: Option(String),
    type_: Option(String),
    participant: Option(String),
    manifestation_code: Option(String),
    route: Option(String),
    patient: Option(String),
    category: Option(String),
    last_date: Option(String),
  )
}

pub type SpAppointment {
  SpAppointment(
    date: Option(String),
    identifier: Option(String),
    specialty: Option(String),
    service_category: Option(String),
    practitioner: Option(String),
    appointment_type: Option(String),
    part_status: Option(String),
    subject: Option(String),
    service_type: Option(String),
    slot: Option(String),
    reason_code: Option(String),
    actor: Option(String),
    based_on: Option(String),
    patient: Option(String),
    reason_reference: Option(String),
    supporting_info: Option(String),
    requested_period: Option(String),
    location: Option(String),
    group: Option(String),
    service_type_reference: Option(String),
    status: Option(String),
  )
}

pub type SpAppointmentresponse {
  SpAppointmentresponse(
    actor: Option(String),
    identifier: Option(String),
    practitioner: Option(String),
    part_status: Option(String),
    patient: Option(String),
    appointment: Option(String),
    location: Option(String),
    group: Option(String),
  )
}

pub type SpArtifactassessment {
  SpArtifactassessment(date: Option(String), identifier: Option(String))
}

pub type SpAuditevent {
  SpAuditevent(
    date: Option(String),
    agent: Option(String),
    entity_role: Option(String),
    code: Option(String),
    purpose: Option(String),
    encounter: Option(String),
    source: Option(String),
    based_on: Option(String),
    patient: Option(String),
    action: Option(String),
    agent_role: Option(String),
    category: Option(String),
    entity: Option(String),
    outcome: Option(String),
    policy: Option(String),
  )
}

pub type SpBasic {
  SpBasic(
    identifier: Option(String),
    code: Option(String),
    author: Option(String),
    created: Option(String),
    patient: Option(String),
    subject: Option(String),
  )
}

pub type SpBinary {
  SpBinary
}

pub type SpBiologicallyderivedproduct {
  SpBiologicallyderivedproduct(
    identifier: Option(String),
    request: Option(String),
    code: Option(String),
    product_status: Option(String),
    serial_number: Option(String),
    biological_source_event: Option(String),
    product_category: Option(String),
    collector: Option(String),
  )
}

pub type SpBiologicallyderivedproductdispense {
  SpBiologicallyderivedproductdispense(
    identifier: Option(String),
    product: Option(String),
    performer: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpBodystructure {
  SpBodystructure(
    identifier: Option(String),
    included_structure: Option(String),
    excluded_structure: Option(String),
    morphology: Option(String),
    patient: Option(String),
  )
}

pub type SpBundle {
  SpBundle(
    identifier: Option(String),
    composition: Option(String),
    message: Option(String),
    type_: Option(String),
    timestamp: Option(String),
  )
}

pub type SpCapabilitystatement {
  SpCapabilitystatement(
    date: Option(String),
    identifier: Option(String),
    resource_profile: Option(String),
    context_type_value: Option(String),
    software: Option(String),
    resource: Option(String),
    jurisdiction: Option(String),
    format: Option(String),
    description: Option(String),
    context_type: Option(String),
    fhirversion: Option(String),
    title: Option(String),
    version: Option(String),
    supported_profile: Option(String),
    url: Option(String),
    mode: Option(String),
    context_quantity: Option(String),
    security_service: Option(String),
    context: Option(String),
    name: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    guide: Option(String),
    status: Option(String),
  )
}

pub type SpCareplan {
  SpCareplan(
    care_team: Option(String),
    date: Option(String),
    identifier: Option(String),
    goal: Option(String),
    custodian: Option(String),
    replaces: Option(String),
    subject: Option(String),
    instantiates_canonical: Option(String),
    part_of: Option(String),
    encounter: Option(String),
    intent: Option(String),
    activity_reference: Option(String),
    condition: Option(String),
    based_on: Option(String),
    patient: Option(String),
    instantiates_uri: Option(String),
    category: Option(String),
    status: Option(String),
  )
}

pub type SpCareteam {
  SpCareteam(
    date: Option(String),
    identifier: Option(String),
    patient: Option(String),
    subject: Option(String),
    name: Option(String),
    category: Option(String),
    participant: Option(String),
    status: Option(String),
  )
}

pub type SpChargeitem {
  SpChargeitem(
    identifier: Option(String),
    performing_organization: Option(String),
    code: Option(String),
    quantity: Option(String),
    subject: Option(String),
    encounter: Option(String),
    occurrence: Option(String),
    entered_date: Option(String),
    performer_function: Option(String),
    factor_override: Option(String),
    patient: Option(String),
    service: Option(String),
    price_override: Option(String),
    enterer: Option(String),
    performer_actor: Option(String),
    account: Option(String),
    requesting_organization: Option(String),
    status: Option(String),
  )
}

pub type SpChargeitemdefinition {
  SpChargeitemdefinition(
    date: Option(String),
    identifier: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    context_type: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    effective: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpCitation {
  SpCitation(
    date: Option(String),
    identifier: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    classification_type: Option(String),
    context_type: Option(String),
    title: Option(String),
    classification: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    effective: Option(String),
    context: Option(String),
    name: Option(String),
    classifier: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpClaim {
  SpClaim(
    care_team: Option(String),
    identifier: Option(String),
    created: Option(String),
    use_: Option(String),
    encounter: Option(String),
    priority: Option(String),
    payee: Option(String),
    provider: Option(String),
    insurer: Option(String),
    patient: Option(String),
    detail_udi: Option(String),
    enterer: Option(String),
    procedure_udi: Option(String),
    subdetail_udi: Option(String),
    facility: Option(String),
    item_udi: Option(String),
    status: Option(String),
  )
}

pub type SpClaimresponse {
  SpClaimresponse(
    identifier: Option(String),
    request: Option(String),
    disposition: Option(String),
    created: Option(String),
    insurer: Option(String),
    patient: Option(String),
    use_: Option(String),
    payment_date: Option(String),
    outcome: Option(String),
    requestor: Option(String),
    status: Option(String),
  )
}

pub type SpClinicalimpression {
  SpClinicalimpression(
    date: Option(String),
    identifier: Option(String),
    performer: Option(String),
    problem: Option(String),
    previous: Option(String),
    finding_code: Option(String),
    patient: Option(String),
    subject: Option(String),
    supporting_info: Option(String),
    encounter: Option(String),
    finding_ref: Option(String),
    status: Option(String),
  )
}

pub type SpClinicalusedefinition {
  SpClinicalusedefinition(
    contraindication_reference: Option(String),
    identifier: Option(String),
    indication_reference: Option(String),
    product: Option(String),
    subject: Option(String),
    effect: Option(String),
    interaction: Option(String),
    indication: Option(String),
    type_: Option(String),
    contraindication: Option(String),
    effect_reference: Option(String),
    status: Option(String),
  )
}

pub type SpCodesystem {
  SpCodesystem(
    date: Option(String),
    identifier: Option(String),
    code: Option(String),
    context_type_value: Option(String),
    content_mode: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    derived_from: Option(String),
    context_type: Option(String),
    language: Option(String),
    predecessor: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    supplements: Option(String),
    effective: Option(String),
    system: Option(String),
    context: Option(String),
    name: Option(String),
    publisher: Option(String),
    topic: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpCommunication {
  SpCommunication(
    identifier: Option(String),
    subject: Option(String),
    instantiates_canonical: Option(String),
    part_of: Option(String),
    received: Option(String),
    encounter: Option(String),
    medium: Option(String),
    sent: Option(String),
    based_on: Option(String),
    sender: Option(String),
    patient: Option(String),
    recipient: Option(String),
    topic: Option(String),
    instantiates_uri: Option(String),
    category: Option(String),
    status: Option(String),
  )
}

pub type SpCommunicationrequest {
  SpCommunicationrequest(
    authored: Option(String),
    requester: Option(String),
    identifier: Option(String),
    replaces: Option(String),
    subject: Option(String),
    encounter: Option(String),
    medium: Option(String),
    occurrence: Option(String),
    priority: Option(String),
    group_identifier: Option(String),
    based_on: Option(String),
    patient: Option(String),
    recipient: Option(String),
    information_provider: Option(String),
    category: Option(String),
    status: Option(String),
  )
}

pub type SpCompartmentdefinition {
  SpCompartmentdefinition(
    date: Option(String),
    code: Option(String),
    context_type_value: Option(String),
    resource: Option(String),
    description: Option(String),
    context_type: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    context: Option(String),
    name: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpComposition {
  SpComposition(
    date: Option(String),
    identifier: Option(String),
    period: Option(String),
    event_code: Option(String),
    author: Option(String),
    subject: Option(String),
    section: Option(String),
    encounter: Option(String),
    title: Option(String),
    type_: Option(String),
    version: Option(String),
    attester: Option(String),
    url: Option(String),
    event_reference: Option(String),
    section_text: Option(String),
    entry: Option(String),
    related: Option(String),
    patient: Option(String),
    category: Option(String),
    section_code_text: Option(String),
    status: Option(String),
  )
}

pub type SpConceptmap {
  SpConceptmap(
    date: Option(String),
    target_scope: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    target_group_system: Option(String),
    derived_from: Option(String),
    context_type: Option(String),
    predecessor: Option(String),
    title: Option(String),
    context_quantity: Option(String),
    effective: Option(String),
    source_scope: Option(String),
    context: Option(String),
    context_type_quantity: Option(String),
    target_code: Option(String),
    identifier: Option(String),
    source_scope_uri: Option(String),
    source_group_system: Option(String),
    mapping_property: Option(String),
    other_map: Option(String),
    version: Option(String),
    url: Option(String),
    source_code: Option(String),
    target_scope_uri: Option(String),
    name: Option(String),
    publisher: Option(String),
    topic: Option(String),
    status: Option(String),
  )
}

pub type SpCondition {
  SpCondition(
    evidence_detail: Option(String),
    severity: Option(String),
    identifier: Option(String),
    onset_info: Option(String),
    recorded_date: Option(String),
    code: Option(String),
    evidence: Option(String),
    participant_function: Option(String),
    subject: Option(String),
    participant_actor: Option(String),
    verification_status: Option(String),
    clinical_status: Option(String),
    encounter: Option(String),
    onset_date: Option(String),
    abatement_date: Option(String),
    stage: Option(String),
    abatement_string: Option(String),
    patient: Option(String),
    abatement_age: Option(String),
    onset_age: Option(String),
    body_site: Option(String),
    category: Option(String),
  )
}

pub type SpConditiondefinition {
  SpConditiondefinition(
    date: Option(String),
    identifier: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    context_type: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    context: Option(String),
    name: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpConsent {
  SpConsent(
    date: Option(String),
    identifier: Option(String),
    controller: Option(String),
    period: Option(String),
    data: Option(String),
    manager: Option(String),
    purpose: Option(String),
    subject: Option(String),
    verified_date: Option(String),
    grantee: Option(String),
    source_reference: Option(String),
    verified: Option(String),
    actor: Option(String),
    security_label: Option(String),
    patient: Option(String),
    action: Option(String),
    category: Option(String),
    status: Option(String),
  )
}

pub type SpContract {
  SpContract(
    identifier: Option(String),
    instantiates: Option(String),
    patient: Option(String),
    subject: Option(String),
    authority: Option(String),
    domain: Option(String),
    issued: Option(String),
    url: Option(String),
    signer: Option(String),
    status: Option(String),
  )
}

pub type SpCoverage {
  SpCoverage(
    identifier: Option(String),
    subscriber: Option(String),
    subscriberid: Option(String),
    type_: Option(String),
    beneficiary: Option(String),
    patient: Option(String),
    insurer: Option(String),
    class_value: Option(String),
    paymentby_party: Option(String),
    class_type: Option(String),
    dependent: Option(String),
    policy_holder: Option(String),
    status: Option(String),
  )
}

pub type SpCoverageeligibilityrequest {
  SpCoverageeligibilityrequest(
    identifier: Option(String),
    provider: Option(String),
    created: Option(String),
    patient: Option(String),
    enterer: Option(String),
    facility: Option(String),
    status: Option(String),
  )
}

pub type SpCoverageeligibilityresponse {
  SpCoverageeligibilityresponse(
    identifier: Option(String),
    request: Option(String),
    disposition: Option(String),
    created: Option(String),
    insurer: Option(String),
    patient: Option(String),
    outcome: Option(String),
    requestor: Option(String),
    status: Option(String),
  )
}

pub type SpDetectedissue {
  SpDetectedissue(
    identifier: Option(String),
    code: Option(String),
    identified: Option(String),
    author: Option(String),
    subject: Option(String),
    patient: Option(String),
    implicated: Option(String),
    category: Option(String),
    status: Option(String),
  )
}

pub type SpDevice {
  SpDevice(
    udi_di: Option(String),
    identifier: Option(String),
    parent: Option(String),
    manufacture_date: Option(String),
    udi_carrier: Option(String),
    code: Option(String),
    device_name: Option(String),
    lot_number: Option(String),
    serial_number: Option(String),
    specification: Option(String),
    type_: Option(String),
    version: Option(String),
    url: Option(String),
    manufacturer: Option(String),
    code_value_concept: Option(String),
    organization: Option(String),
    biological_source_event: Option(String),
    definition: Option(String),
    location: Option(String),
    model: Option(String),
    expiration_date: Option(String),
    specification_version: Option(String),
    status: Option(String),
  )
}

pub type SpDeviceassociation {
  SpDeviceassociation(
    identifier: Option(String),
    subject: Option(String),
    patient: Option(String),
    device: Option(String),
    operator: Option(String),
    status: Option(String),
  )
}

pub type SpDevicedefinition {
  SpDevicedefinition(
    identifier: Option(String),
    device_name: Option(String),
    organization: Option(String),
    specification: Option(String),
    type_: Option(String),
    specification_version: Option(String),
    manufacturer: Option(String),
  )
}

pub type SpDevicedispense {
  SpDevicedispense(
    identifier: Option(String),
    code: Option(String),
    subject: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpDevicemetric {
  SpDevicemetric(
    identifier: Option(String),
    category: Option(String),
    type_: Option(String),
    device: Option(String),
  )
}

pub type SpDevicerequest {
  SpDevicerequest(
    insurance: Option(String),
    performer_code: Option(String),
    requester: Option(String),
    identifier: Option(String),
    code: Option(String),
    performer: Option(String),
    event_date: Option(String),
    subject: Option(String),
    instantiates_canonical: Option(String),
    encounter: Option(String),
    authored_on: Option(String),
    intent: Option(String),
    group_identifier: Option(String),
    based_on: Option(String),
    patient: Option(String),
    instantiates_uri: Option(String),
    device: Option(String),
    prior_request: Option(String),
    status: Option(String),
  )
}

pub type SpDeviceusage {
  SpDeviceusage(
    identifier: Option(String),
    patient: Option(String),
    device: Option(String),
    status: Option(String),
  )
}

pub type SpDiagnosticreport {
  SpDiagnosticreport(
    date: Option(String),
    identifier: Option(String),
    study: Option(String),
    code: Option(String),
    performer: Option(String),
    subject: Option(String),
    encounter: Option(String),
    media: Option(String),
    conclusion: Option(String),
    result: Option(String),
    based_on: Option(String),
    patient: Option(String),
    specimen: Option(String),
    category: Option(String),
    issued: Option(String),
    results_interpreter: Option(String),
    status: Option(String),
  )
}

pub type SpDocumentreference {
  SpDocumentreference(
    date: Option(String),
    modality: Option(String),
    subject: Option(String),
    description: Option(String),
    language: Option(String),
    type_: Option(String),
    relation: Option(String),
    setting: Option(String),
    doc_status: Option(String),
    based_on: Option(String),
    format_canonical: Option(String),
    patient: Option(String),
    context: Option(String),
    relationship: Option(String),
    creation: Option(String),
    identifier: Option(String),
    period: Option(String),
    event_code: Option(String),
    bodysite: Option(String),
    custodian: Option(String),
    author: Option(String),
    format_code: Option(String),
    bodysite_reference: Option(String),
    format_uri: Option(String),
    version: Option(String),
    attester: Option(String),
    contenttype: Option(String),
    event_reference: Option(String),
    security_label: Option(String),
    location: Option(String),
    category: Option(String),
    relatesto: Option(String),
    facility: Option(String),
    status: Option(String),
  )
}

pub type SpEncounter {
  SpEncounter(
    date: Option(String),
    participant_type: Option(String),
    subject: Option(String),
    subject_status: Option(String),
    appointment: Option(String),
    part_of: Option(String),
    type_: Option(String),
    participant: Option(String),
    reason_code: Option(String),
    based_on: Option(String),
    date_start: Option(String),
    patient: Option(String),
    location_period: Option(String),
    special_arrangement: Option(String),
    class: Option(String),
    identifier: Option(String),
    diagnosis_code: Option(String),
    practitioner: Option(String),
    episode_of_care: Option(String),
    length: Option(String),
    careteam: Option(String),
    end_date: Option(String),
    diagnosis_reference: Option(String),
    reason_reference: Option(String),
    location: Option(String),
    service_provider: Option(String),
    account: Option(String),
    status: Option(String),
  )
}

pub type SpEncounterhistory {
  SpEncounterhistory(
    identifier: Option(String),
    patient: Option(String),
    subject: Option(String),
    encounter: Option(String),
    status: Option(String),
  )
}

pub type SpEndpoint {
  SpEndpoint(
    payload_type: Option(String),
    identifier: Option(String),
    connection_type: Option(String),
    organization: Option(String),
    name: Option(String),
    status: Option(String),
  )
}

pub type SpEnrollmentrequest {
  SpEnrollmentrequest(
    identifier: Option(String),
    patient: Option(String),
    subject: Option(String),
    status: Option(String),
  )
}

pub type SpEnrollmentresponse {
  SpEnrollmentresponse(
    identifier: Option(String),
    request: Option(String),
    status: Option(String),
  )
}

pub type SpEpisodeofcare {
  SpEpisodeofcare(
    date: Option(String),
    identifier: Option(String),
    diagnosis_code: Option(String),
    diagnosis_reference: Option(String),
    patient: Option(String),
    organization: Option(String),
    reason_reference: Option(String),
    type_: Option(String),
    care_manager: Option(String),
    reason_code: Option(String),
    incoming_referral: Option(String),
    status: Option(String),
  )
}

pub type SpEventdefinition {
  SpEventdefinition(
    date: Option(String),
    identifier: Option(String),
    successor: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    derived_from: Option(String),
    description: Option(String),
    context_type: Option(String),
    predecessor: Option(String),
    composed_of: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    depends_on: Option(String),
    effective: Option(String),
    context: Option(String),
    name: Option(String),
    publisher: Option(String),
    topic: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpEvidence {
  SpEvidence(
    date: Option(String),
    identifier: Option(String),
    context_type_value: Option(String),
    description: Option(String),
    context_type: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpEvidencereport {
  SpEvidencereport(
    context_quantity: Option(String),
    identifier: Option(String),
    context_type_value: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type: Option(String),
    context_type_quantity: Option(String),
    url: Option(String),
    status: Option(String),
  )
}

pub type SpEvidencevariable {
  SpEvidencevariable(
    date: Option(String),
    identifier: Option(String),
    successor: Option(String),
    context_type_value: Option(String),
    derived_from: Option(String),
    description: Option(String),
    context_type: Option(String),
    predecessor: Option(String),
    composed_of: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    depends_on: Option(String),
    context: Option(String),
    name: Option(String),
    publisher: Option(String),
    topic: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpExamplescenario {
  SpExamplescenario(
    date: Option(String),
    identifier: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    context_type: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    context: Option(String),
    name: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpExplanationofbenefit {
  SpExplanationofbenefit(
    care_team: Option(String),
    coverage: Option(String),
    identifier: Option(String),
    created: Option(String),
    encounter: Option(String),
    payee: Option(String),
    disposition: Option(String),
    provider: Option(String),
    patient: Option(String),
    detail_udi: Option(String),
    claim: Option(String),
    enterer: Option(String),
    procedure_udi: Option(String),
    subdetail_udi: Option(String),
    facility: Option(String),
    item_udi: Option(String),
    status: Option(String),
  )
}

pub type SpFamilymemberhistory {
  SpFamilymemberhistory(
    date: Option(String),
    identifier: Option(String),
    code: Option(String),
    patient: Option(String),
    sex: Option(String),
    instantiates_canonical: Option(String),
    instantiates_uri: Option(String),
    relationship: Option(String),
    status: Option(String),
  )
}

pub type SpFlag {
  SpFlag(
    date: Option(String),
    identifier: Option(String),
    author: Option(String),
    patient: Option(String),
    subject: Option(String),
    encounter: Option(String),
    category: Option(String),
    status: Option(String),
  )
}

pub type SpFormularyitem {
  SpFormularyitem(identifier: Option(String), code: Option(String))
}

pub type SpGenomicstudy {
  SpGenomicstudy(
    identifier: Option(String),
    patient: Option(String),
    subject: Option(String),
    focus: Option(String),
    status: Option(String),
  )
}

pub type SpGoal {
  SpGoal(
    target_measure: Option(String),
    identifier: Option(String),
    addresses: Option(String),
    lifecycle_status: Option(String),
    achievement_status: Option(String),
    patient: Option(String),
    subject: Option(String),
    description: Option(String),
    start_date: Option(String),
    category: Option(String),
    target_date: Option(String),
  )
}

pub type SpGraphdefinition {
  SpGraphdefinition(
    date: Option(String),
    identifier: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    start: Option(String),
    description: Option(String),
    context_type: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    context: Option(String),
    name: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpGroup {
  SpGroup(
    identifier: Option(String),
    characteristic_value: Option(String),
    managing_entity: Option(String),
    code: Option(String),
    member: Option(String),
    name: Option(String),
    exclude: Option(String),
    membership: Option(String),
    type_: Option(String),
    characteristic_reference: Option(String),
    value: Option(String),
    characteristic: Option(String),
  )
}

pub type SpGuidanceresponse {
  SpGuidanceresponse(
    identifier: Option(String),
    request: Option(String),
    patient: Option(String),
    subject: Option(String),
    status: Option(String),
  )
}

pub type SpHealthcareservice {
  SpHealthcareservice(
    identifier: Option(String),
    specialty: Option(String),
    service_category: Option(String),
    service_type: Option(String),
    active: Option(String),
    eligibility: Option(String),
    program: Option(String),
    characteristic: Option(String),
    endpoint: Option(String),
    coverage_area: Option(String),
    organization: Option(String),
    offered_in: Option(String),
    name: Option(String),
    location: Option(String),
    communication: Option(String),
  )
}

pub type SpImagingselection {
  SpImagingselection(
    identifier: Option(String),
    body_structure: Option(String),
    based_on: Option(String),
    code: Option(String),
    subject: Option(String),
    patient: Option(String),
    derived_from: Option(String),
    issued: Option(String),
    body_site: Option(String),
    study_uid: Option(String),
    status: Option(String),
  )
}

pub type SpImagingstudy {
  SpImagingstudy(
    identifier: Option(String),
    reason: Option(String),
    dicom_class: Option(String),
    instance: Option(String),
    modality: Option(String),
    performer: Option(String),
    subject: Option(String),
    started: Option(String),
    encounter: Option(String),
    referrer: Option(String),
    body_structure: Option(String),
    endpoint: Option(String),
    based_on: Option(String),
    patient: Option(String),
    series: Option(String),
    body_site: Option(String),
    status: Option(String),
  )
}

pub type SpImmunization {
  SpImmunization(
    date: Option(String),
    identifier: Option(String),
    performer: Option(String),
    reaction: Option(String),
    lot_number: Option(String),
    status_reason: Option(String),
    reason_code: Option(String),
    manufacturer: Option(String),
    target_disease: Option(String),
    patient: Option(String),
    series: Option(String),
    vaccine_code: Option(String),
    reason_reference: Option(String),
    location: Option(String),
    reaction_date: Option(String),
    status: Option(String),
  )
}

pub type SpImmunizationevaluation {
  SpImmunizationevaluation(
    date: Option(String),
    identifier: Option(String),
    target_disease: Option(String),
    patient: Option(String),
    dose_status: Option(String),
    immunization_event: Option(String),
    status: Option(String),
  )
}

pub type SpImmunizationrecommendation {
  SpImmunizationrecommendation(
    date: Option(String),
    identifier: Option(String),
    target_disease: Option(String),
    patient: Option(String),
    vaccine_type: Option(String),
    information: Option(String),
    support: Option(String),
    status: Option(String),
  )
}

pub type SpImplementationguide {
  SpImplementationguide(
    date: Option(String),
    identifier: Option(String),
    context_type_value: Option(String),
    resource: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    context_type: Option(String),
    experimental: Option(String),
    global: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    depends_on: Option(String),
    context: Option(String),
    name: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpIngredient {
  SpIngredient(
    identifier: Option(String),
    role: Option(String),
    substance: Option(String),
    strength_concentration_ratio: Option(String),
    for: Option(String),
    substance_code: Option(String),
    strength_concentration_quantity: Option(String),
    manufacturer: Option(String),
    substance_definition: Option(String),
    function: Option(String),
    strength_presentation_ratio: Option(String),
    strength_presentation_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpInsuranceplan {
  SpInsuranceplan(
    identifier: Option(String),
    address: Option(String),
    address_state: Option(String),
    owned_by: Option(String),
    type_: Option(String),
    address_postalcode: Option(String),
    address_country: Option(String),
    administered_by: Option(String),
    endpoint: Option(String),
    phonetic: Option(String),
    address_use: Option(String),
    name: Option(String),
    address_city: Option(String),
    status: Option(String),
  )
}

pub type SpInventoryitem {
  SpInventoryitem(
    identifier: Option(String),
    code: Option(String),
    subject: Option(String),
    status: Option(String),
  )
}

pub type SpInventoryreport {
  SpInventoryreport(
    item_reference: Option(String),
    identifier: Option(String),
    item: Option(String),
    status: Option(String),
  )
}

pub type SpInvoice {
  SpInvoice(
    date: Option(String),
    identifier: Option(String),
    totalgross: Option(String),
    participant_role: Option(String),
    subject: Option(String),
    type_: Option(String),
    issuer: Option(String),
    participant: Option(String),
    totalnet: Option(String),
    patient: Option(String),
    recipient: Option(String),
    account: Option(String),
    status: Option(String),
  )
}

pub type SpLibrary {
  SpLibrary(
    date: Option(String),
    identifier: Option(String),
    successor: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    derived_from: Option(String),
    description: Option(String),
    context_type: Option(String),
    predecessor: Option(String),
    composed_of: Option(String),
    title: Option(String),
    type_: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    depends_on: Option(String),
    effective: Option(String),
    context: Option(String),
    name: Option(String),
    publisher: Option(String),
    topic: Option(String),
    content_type: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpLinkage {
  SpLinkage(
    item: Option(String),
    author: Option(String),
    source: Option(String),
  )
}

pub type SpListfhir {
  SpListfhir(
    date: Option(String),
    identifier: Option(String),
    empty_reason: Option(String),
    item: Option(String),
    code: Option(String),
    notes: Option(String),
    patient: Option(String),
    subject: Option(String),
    encounter: Option(String),
    source: Option(String),
    title: Option(String),
    status: Option(String),
  )
}

pub type SpLocation {
  SpLocation(
    identifier: Option(String),
    partof: Option(String),
    address: Option(String),
    address_state: Option(String),
    operational_status: Option(String),
    type_: Option(String),
    address_postalcode: Option(String),
    characteristic: Option(String),
    address_country: Option(String),
    endpoint: Option(String),
    contains: Option(String),
    organization: Option(String),
    address_use: Option(String),
    name: Option(String),
    near: Option(String),
    address_city: Option(String),
    status: Option(String),
  )
}

pub type SpManufactureditemdefinition {
  SpManufactureditemdefinition(
    identifier: Option(String),
    ingredient: Option(String),
    name: Option(String),
    dose_form: Option(String),
    status: Option(String),
  )
}

pub type SpMeasure {
  SpMeasure(
    date: Option(String),
    identifier: Option(String),
    successor: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    derived_from: Option(String),
    description: Option(String),
    context_type: Option(String),
    predecessor: Option(String),
    composed_of: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    depends_on: Option(String),
    effective: Option(String),
    context: Option(String),
    name: Option(String),
    publisher: Option(String),
    topic: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpMeasurereport {
  SpMeasurereport(
    date: Option(String),
    identifier: Option(String),
    period: Option(String),
    measure: Option(String),
    patient: Option(String),
    subject: Option(String),
    reporter: Option(String),
    location: Option(String),
    evaluated_resource: Option(String),
    status: Option(String),
  )
}

pub type SpMedication {
  SpMedication(
    ingredient_code: Option(String),
    identifier: Option(String),
    code: Option(String),
    ingredient: Option(String),
    form: Option(String),
    lot_number: Option(String),
    serial_number: Option(String),
    expiration_date: Option(String),
    marketingauthorizationholder: Option(String),
    status: Option(String),
  )
}

pub type SpMedicationadministration {
  SpMedicationadministration(
    date: Option(String),
    identifier: Option(String),
    request: Option(String),
    code: Option(String),
    performer: Option(String),
    performer_device_code: Option(String),
    subject: Option(String),
    medication: Option(String),
    reason_given: Option(String),
    encounter: Option(String),
    reason_given_code: Option(String),
    patient: Option(String),
    reason_not_given: Option(String),
    device: Option(String),
    status: Option(String),
  )
}

pub type SpMedicationdispense {
  SpMedicationdispense(
    identifier: Option(String),
    code: Option(String),
    performer: Option(String),
    receiver: Option(String),
    subject: Option(String),
    destination: Option(String),
    medication: Option(String),
    responsibleparty: Option(String),
    encounter: Option(String),
    type_: Option(String),
    recorded: Option(String),
    whenhandedover: Option(String),
    whenprepared: Option(String),
    prescription: Option(String),
    patient: Option(String),
    location: Option(String),
    status: Option(String),
  )
}

pub type SpMedicationknowledge {
  SpMedicationknowledge(
    product_type: Option(String),
    identifier: Option(String),
    code: Option(String),
    ingredient: Option(String),
    doseform: Option(String),
    classification_type: Option(String),
    monograph_type: Option(String),
    classification: Option(String),
    ingredient_code: Option(String),
    packaging_cost_concept: Option(String),
    source_cost: Option(String),
    monitoring_program_name: Option(String),
    monograph: Option(String),
    monitoring_program_type: Option(String),
    packaging_cost: Option(String),
    status: Option(String),
  )
}

pub type SpMedicationrequest {
  SpMedicationrequest(
    requester: Option(String),
    identifier: Option(String),
    intended_dispenser: Option(String),
    authoredon: Option(String),
    code: Option(String),
    combo_date: Option(String),
    subject: Option(String),
    medication: Option(String),
    encounter: Option(String),
    priority: Option(String),
    intent: Option(String),
    group_identifier: Option(String),
    intended_performer: Option(String),
    patient: Option(String),
    intended_performertype: Option(String),
    category: Option(String),
    status: Option(String),
  )
}

pub type SpMedicationstatement {
  SpMedicationstatement(
    effective: Option(String),
    identifier: Option(String),
    code: Option(String),
    adherence: Option(String),
    patient: Option(String),
    subject: Option(String),
    medication: Option(String),
    encounter: Option(String),
    source: Option(String),
    category: Option(String),
    status: Option(String),
  )
}

pub type SpMedicinalproductdefinition {
  SpMedicinalproductdefinition(
    identifier: Option(String),
    ingredient: Option(String),
    master_file: Option(String),
    contact: Option(String),
    domain: Option(String),
    name: Option(String),
    name_language: Option(String),
    type_: Option(String),
    characteristic: Option(String),
    characteristic_type: Option(String),
    product_classification: Option(String),
    status: Option(String),
  )
}

pub type SpMessagedefinition {
  SpMessagedefinition(
    date: Option(String),
    identifier: Option(String),
    parent: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    focus: Option(String),
    context_type: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    context: Option(String),
    name: Option(String),
    publisher: Option(String),
    category: Option(String),
    event: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpMessageheader {
  SpMessageheader(
    code: Option(String),
    receiver: Option(String),
    sender: Option(String),
    author: Option(String),
    responsible: Option(String),
    destination: Option(String),
    focus: Option(String),
    response_id: Option(String),
    source: Option(String),
    event: Option(String),
    target: Option(String),
  )
}

pub type SpMolecularsequence {
  SpMolecularsequence(
    identifier: Option(String),
    subject: Option(String),
    patient: Option(String),
    focus: Option(String),
    type_: Option(String),
  )
}

pub type SpNamingsystem {
  SpNamingsystem(
    date: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    derived_from: Option(String),
    context_type: Option(String),
    predecessor: Option(String),
    type_: Option(String),
    context_quantity: Option(String),
    effective: Option(String),
    contact: Option(String),
    responsible: Option(String),
    context: Option(String),
    telecom: Option(String),
    value: Option(String),
    context_type_quantity: Option(String),
    identifier: Option(String),
    period: Option(String),
    kind: Option(String),
    version: Option(String),
    url: Option(String),
    id_type: Option(String),
    name: Option(String),
    publisher: Option(String),
    topic: Option(String),
    status: Option(String),
  )
}

pub type SpNutritionintake {
  SpNutritionintake(
    date: Option(String),
    identifier: Option(String),
    nutrition: Option(String),
    code: Option(String),
    patient: Option(String),
    subject: Option(String),
    encounter: Option(String),
    source: Option(String),
    status: Option(String),
  )
}

pub type SpNutritionorder {
  SpNutritionorder(
    identifier: Option(String),
    group_identifier: Option(String),
    datetime: Option(String),
    provider: Option(String),
    subject: Option(String),
    patient: Option(String),
    supplement: Option(String),
    formula: Option(String),
    encounter: Option(String),
    oraldiet: Option(String),
    additive: Option(String),
    status: Option(String),
  )
}

pub type SpNutritionproduct {
  SpNutritionproduct(
    identifier: Option(String),
    code: Option(String),
    lot_number: Option(String),
    serial_number: Option(String),
    status: Option(String),
  )
}

pub type SpObservation {
  SpObservation(
    date: Option(String),
    combo_data_absent_reason: Option(String),
    code: Option(String),
    combo_code_value_quantity: Option(String),
    component_data_absent_reason: Option(String),
    subject: Option(String),
    value_concept: Option(String),
    value_date: Option(String),
    derived_from: Option(String),
    focus: Option(String),
    part_of: Option(String),
    component_value_canonical: Option(String),
    has_member: Option(String),
    value_reference: Option(String),
    code_value_string: Option(String),
    component_code_value_quantity: Option(String),
    based_on: Option(String),
    code_value_date: Option(String),
    patient: Option(String),
    specimen: Option(String),
    code_value_quantity: Option(String),
    component_code: Option(String),
    value_markdown: Option(String),
    combo_code_value_concept: Option(String),
    identifier: Option(String),
    component_value_reference: Option(String),
    performer: Option(String),
    combo_code: Option(String),
    method: Option(String),
    value_quantity: Option(String),
    component_value_quantity: Option(String),
    data_absent_reason: Option(String),
    combo_value_quantity: Option(String),
    encounter: Option(String),
    code_value_concept: Option(String),
    component_code_value_concept: Option(String),
    component_value_concept: Option(String),
    category: Option(String),
    device: Option(String),
    combo_value_concept: Option(String),
    value_canonical: Option(String),
    status: Option(String),
  )
}

pub type SpObservationdefinition {
  SpObservationdefinition(
    identifier: Option(String),
    code: Option(String),
    method: Option(String),
    experimental: Option(String),
    category: Option(String),
    title: Option(String),
    url: Option(String),
    status: Option(String),
  )
}

pub type SpOperationdefinition {
  SpOperationdefinition(
    date: Option(String),
    identifier: Option(String),
    code: Option(String),
    instance: Option(String),
    context_type_value: Option(String),
    kind: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    context_type: Option(String),
    title: Option(String),
    type_: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    input_profile: Option(String),
    output_profile: Option(String),
    system: Option(String),
    context: Option(String),
    name: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    base: Option(String),
    status: Option(String),
  )
}

pub type SpOperationoutcome {
  SpOperationoutcome
}

pub type SpOrganization {
  SpOrganization(
    identifier: Option(String),
    partof: Option(String),
    address: Option(String),
    address_state: Option(String),
    active: Option(String),
    type_: Option(String),
    address_postalcode: Option(String),
    address_country: Option(String),
    endpoint: Option(String),
    phonetic: Option(String),
    address_use: Option(String),
    name: Option(String),
    address_city: Option(String),
  )
}

pub type SpOrganizationaffiliation {
  SpOrganizationaffiliation(
    date: Option(String),
    identifier: Option(String),
    specialty: Option(String),
    role: Option(String),
    active: Option(String),
    primary_organization: Option(String),
    network: Option(String),
    endpoint: Option(String),
    phone: Option(String),
    service: Option(String),
    participating_organization: Option(String),
    location: Option(String),
    telecom: Option(String),
    email: Option(String),
  )
}

pub type SpPackagedproductdefinition {
  SpPackagedproductdefinition(
    identifier: Option(String),
    manufactured_item: Option(String),
    nutrition: Option(String),
    package: Option(String),
    name: Option(String),
    biological: Option(String),
    package_for: Option(String),
    contained_item: Option(String),
    medication: Option(String),
    device: Option(String),
    status: Option(String),
  )
}

pub type SpPatient {
  SpPatient(
    given: Option(String),
    identifier: Option(String),
    address: Option(String),
    birthdate: Option(String),
    deceased: Option(String),
    address_state: Option(String),
    gender: Option(String),
    general_practitioner: Option(String),
    link: Option(String),
    active: Option(String),
    language: Option(String),
    address_postalcode: Option(String),
    address_country: Option(String),
    death_date: Option(String),
    phonetic: Option(String),
    phone: Option(String),
    organization: Option(String),
    address_use: Option(String),
    name: Option(String),
    telecom: Option(String),
    address_city: Option(String),
    family: Option(String),
    email: Option(String),
  )
}

pub type SpPaymentnotice {
  SpPaymentnotice(
    identifier: Option(String),
    request: Option(String),
    created: Option(String),
    response: Option(String),
    reporter: Option(String),
    payment_status: Option(String),
    status: Option(String),
  )
}

pub type SpPaymentreconciliation {
  SpPaymentreconciliation(
    identifier: Option(String),
    request: Option(String),
    disposition: Option(String),
    created: Option(String),
    allocation_encounter: Option(String),
    allocation_account: Option(String),
    outcome: Option(String),
    payment_issuer: Option(String),
    requestor: Option(String),
    status: Option(String),
  )
}

pub type SpPermission {
  SpPermission(status: Option(String))
}

pub type SpPerson {
  SpPerson(
    identifier: Option(String),
    given: Option(String),
    address: Option(String),
    birthdate: Option(String),
    deceased: Option(String),
    address_state: Option(String),
    gender: Option(String),
    practitioner: Option(String),
    link: Option(String),
    relatedperson: Option(String),
    address_postalcode: Option(String),
    address_country: Option(String),
    death_date: Option(String),
    phonetic: Option(String),
    phone: Option(String),
    patient: Option(String),
    organization: Option(String),
    address_use: Option(String),
    name: Option(String),
    telecom: Option(String),
    address_city: Option(String),
    family: Option(String),
    email: Option(String),
  )
}

pub type SpPlandefinition {
  SpPlandefinition(
    date: Option(String),
    identifier: Option(String),
    successor: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    derived_from: Option(String),
    description: Option(String),
    context_type: Option(String),
    predecessor: Option(String),
    composed_of: Option(String),
    title: Option(String),
    type_: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    depends_on: Option(String),
    effective: Option(String),
    context: Option(String),
    name: Option(String),
    publisher: Option(String),
    topic: Option(String),
    definition: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpPractitioner {
  SpPractitioner(
    given: Option(String),
    identifier: Option(String),
    address: Option(String),
    deceased: Option(String),
    address_state: Option(String),
    gender: Option(String),
    qualification_period: Option(String),
    active: Option(String),
    address_postalcode: Option(String),
    address_country: Option(String),
    death_date: Option(String),
    phonetic: Option(String),
    phone: Option(String),
    address_use: Option(String),
    name: Option(String),
    telecom: Option(String),
    address_city: Option(String),
    communication: Option(String),
    family: Option(String),
    email: Option(String),
  )
}

pub type SpPractitionerrole {
  SpPractitionerrole(
    date: Option(String),
    identifier: Option(String),
    specialty: Option(String),
    role: Option(String),
    practitioner: Option(String),
    active: Option(String),
    characteristic: Option(String),
    endpoint: Option(String),
    phone: Option(String),
    service: Option(String),
    organization: Option(String),
    location: Option(String),
    telecom: Option(String),
    communication: Option(String),
    email: Option(String),
  )
}

pub type SpProcedure {
  SpProcedure(
    date: Option(String),
    identifier: Option(String),
    code: Option(String),
    performer: Option(String),
    subject: Option(String),
    instantiates_canonical: Option(String),
    part_of: Option(String),
    encounter: Option(String),
    reason_code: Option(String),
    based_on: Option(String),
    patient: Option(String),
    reason_reference: Option(String),
    report: Option(String),
    instantiates_uri: Option(String),
    location: Option(String),
    category: Option(String),
    status: Option(String),
  )
}

pub type SpProvenance {
  SpProvenance(
    agent_type: Option(String),
    agent: Option(String),
    signature_type: Option(String),
    activity: Option(String),
    encounter: Option(String),
    recorded: Option(String),
    when: Option(String),
    target: Option(String),
    based_on: Option(String),
    patient: Option(String),
    location: Option(String),
    agent_role: Option(String),
    entity: Option(String),
  )
}

pub type SpQuestionnaire {
  SpQuestionnaire(
    date: Option(String),
    identifier: Option(String),
    combo_code: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    context_type: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    effective: Option(String),
    subject_type: Option(String),
    context: Option(String),
    name: Option(String),
    publisher: Option(String),
    questionnaire_code: Option(String),
    definition: Option(String),
    context_type_quantity: Option(String),
    item_code: Option(String),
    status: Option(String),
  )
}

pub type SpQuestionnaireresponse {
  SpQuestionnaireresponse(
    authored: Option(String),
    identifier: Option(String),
    questionnaire: Option(String),
    based_on: Option(String),
    author: Option(String),
    patient: Option(String),
    subject: Option(String),
    part_of: Option(String),
    encounter: Option(String),
    source: Option(String),
    item_subject: Option(String),
    status: Option(String),
  )
}

pub type SpRegulatedauthorization {
  SpRegulatedauthorization(
    identifier: Option(String),
    subject: Option(String),
    case_type: Option(String),
    holder: Option(String),
    region: Option(String),
    case_: Option(String),
    status: Option(String),
  )
}

pub type SpRelatedperson {
  SpRelatedperson(
    identifier: Option(String),
    given: Option(String),
    address: Option(String),
    birthdate: Option(String),
    address_state: Option(String),
    gender: Option(String),
    active: Option(String),
    address_postalcode: Option(String),
    address_country: Option(String),
    phonetic: Option(String),
    phone: Option(String),
    patient: Option(String),
    address_use: Option(String),
    name: Option(String),
    telecom: Option(String),
    address_city: Option(String),
    family: Option(String),
    relationship: Option(String),
    email: Option(String),
  )
}

pub type SpRequestorchestration {
  SpRequestorchestration(
    authored: Option(String),
    identifier: Option(String),
    code: Option(String),
    author: Option(String),
    subject: Option(String),
    instantiates_canonical: Option(String),
    encounter: Option(String),
    priority: Option(String),
    intent: Option(String),
    participant: Option(String),
    group_identifier: Option(String),
    based_on: Option(String),
    patient: Option(String),
    instantiates_uri: Option(String),
    status: Option(String),
  )
}

pub type SpRequirements {
  SpRequirements(
    date: Option(String),
    identifier: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    derived_from: Option(String),
    context_type: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    actor: Option(String),
    context_quantity: Option(String),
    context: Option(String),
    name: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpResearchstudy {
  SpResearchstudy(
    date: Option(String),
    objective_type: Option(String),
    study_design: Option(String),
    description: Option(String),
    eligibility: Option(String),
    part_of: Option(String),
    title: Option(String),
    progress_status_state_period_actual: Option(String),
    recruitment_target: Option(String),
    protocol: Option(String),
    classifier: Option(String),
    keyword: Option(String),
    focus_code: Option(String),
    phase: Option(String),
    identifier: Option(String),
    progress_status_state_actual: Option(String),
    focus_reference: Option(String),
    objective_description: Option(String),
    progress_status_state_period: Option(String),
    condition: Option(String),
    site: Option(String),
    name: Option(String),
    recruitment_actual: Option(String),
    region: Option(String),
    status: Option(String),
  )
}

pub type SpResearchsubject {
  SpResearchsubject(
    date: Option(String),
    identifier: Option(String),
    subject_state: Option(String),
    study: Option(String),
    subject: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpRiskassessment {
  SpRiskassessment(
    date: Option(String),
    identifier: Option(String),
    condition: Option(String),
    performer: Option(String),
    method: Option(String),
    patient: Option(String),
    probability: Option(String),
    subject: Option(String),
    risk: Option(String),
    encounter: Option(String),
  )
}

pub type SpSchedule {
  SpSchedule(
    actor: Option(String),
    date: Option(String),
    identifier: Option(String),
    specialty: Option(String),
    service_category: Option(String),
    service_type: Option(String),
    name: Option(String),
    active: Option(String),
    service_type_reference: Option(String),
  )
}

pub type SpSearchparameter {
  SpSearchparameter(
    date: Option(String),
    identifier: Option(String),
    code: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    derived_from: Option(String),
    description: Option(String),
    context_type: Option(String),
    type_: Option(String),
    version: Option(String),
    url: Option(String),
    target: Option(String),
    context_quantity: Option(String),
    component: Option(String),
    context: Option(String),
    name: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    base: Option(String),
    status: Option(String),
  )
}

pub type SpServicerequest {
  SpServicerequest(
    authored: Option(String),
    requester: Option(String),
    identifier: Option(String),
    performer: Option(String),
    requisition: Option(String),
    replaces: Option(String),
    subject: Option(String),
    instantiates_canonical: Option(String),
    encounter: Option(String),
    occurrence: Option(String),
    priority: Option(String),
    intent: Option(String),
    performer_type: Option(String),
    body_structure: Option(String),
    based_on: Option(String),
    code_reference: Option(String),
    patient: Option(String),
    specimen: Option(String),
    code_concept: Option(String),
    instantiates_uri: Option(String),
    body_site: Option(String),
    category: Option(String),
    status: Option(String),
  )
}

pub type SpSlot {
  SpSlot(
    identifier: Option(String),
    schedule: Option(String),
    specialty: Option(String),
    service_category: Option(String),
    appointment_type: Option(String),
    service_type: Option(String),
    start: Option(String),
    service_type_reference: Option(String),
    status: Option(String),
  )
}

pub type SpSpecimen {
  SpSpecimen(
    identifier: Option(String),
    parent: Option(String),
    bodysite: Option(String),
    patient: Option(String),
    subject: Option(String),
    collected: Option(String),
    accession: Option(String),
    procedure: Option(String),
    type_: Option(String),
    collector: Option(String),
    container_device: Option(String),
    status: Option(String),
  )
}

pub type SpSpecimendefinition {
  SpSpecimendefinition(
    container: Option(String),
    identifier: Option(String),
    is_derived: Option(String),
    experimental: Option(String),
    type_tested: Option(String),
    title: Option(String),
    type_: Option(String),
    url: Option(String),
    status: Option(String),
  )
}

pub type SpStructuredefinition {
  SpStructuredefinition(
    date: Option(String),
    context_type_value: Option(String),
    ext_context_type: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    context_type: Option(String),
    experimental: Option(String),
    title: Option(String),
    type_: Option(String),
    context_quantity: Option(String),
    path: Option(String),
    base_path: Option(String),
    context: Option(String),
    keyword: Option(String),
    context_type_quantity: Option(String),
    ext_context_expression: Option(String),
    identifier: Option(String),
    valueset: Option(String),
    kind: Option(String),
    abstract: Option(String),
    version: Option(String),
    url: Option(String),
    ext_context: Option(String),
    name: Option(String),
    publisher: Option(String),
    derivation: Option(String),
    base: Option(String),
    status: Option(String),
  )
}

pub type SpStructuremap {
  SpStructuremap(
    date: Option(String),
    identifier: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    context_type: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    context: Option(String),
    name: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpSubscription {
  SpSubscription(
    owner: Option(String),
    identifier: Option(String),
    payload: Option(String),
    contact: Option(String),
    name: Option(String),
    topic: Option(String),
    filter_value: Option(String),
    type_: Option(String),
    content_level: Option(String),
    url: Option(String),
    status: Option(String),
  )
}

pub type SpSubscriptionstatus {
  SpSubscriptionstatus
}

pub type SpSubscriptiontopic {
  SpSubscriptiontopic(
    date: Option(String),
    effective: Option(String),
    identifier: Option(String),
    resource: Option(String),
    derived_or_self: Option(String),
    event: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    status: Option(String),
    trigger_description: Option(String),
  )
}

pub type SpSubstance {
  SpSubstance(
    identifier: Option(String),
    code: Option(String),
    code_reference: Option(String),
    quantity: Option(String),
    substance_reference: Option(String),
    expiry: Option(String),
    category: Option(String),
    status: Option(String),
  )
}

pub type SpSubstancedefinition {
  SpSubstancedefinition(
    identifier: Option(String),
    code: Option(String),
    domain: Option(String),
    name: Option(String),
    classification: Option(String),
  )
}

pub type SpSubstancenucleicacid {
  SpSubstancenucleicacid
}

pub type SpSubstancepolymer {
  SpSubstancepolymer
}

pub type SpSubstanceprotein {
  SpSubstanceprotein
}

pub type SpSubstancereferenceinformation {
  SpSubstancereferenceinformation
}

pub type SpSubstancesourcematerial {
  SpSubstancesourcematerial
}

pub type SpSupplydelivery {
  SpSupplydelivery(
    identifier: Option(String),
    receiver: Option(String),
    patient: Option(String),
    supplier: Option(String),
    status: Option(String),
  )
}

pub type SpSupplyrequest {
  SpSupplyrequest(
    date: Option(String),
    requester: Option(String),
    identifier: Option(String),
    patient: Option(String),
    subject: Option(String),
    supplier: Option(String),
    category: Option(String),
    status: Option(String),
  )
}

pub type SpTask {
  SpTask(
    owner: Option(String),
    requestedperformer_reference: Option(String),
    requester: Option(String),
    business_status: Option(String),
    identifier: Option(String),
    period: Option(String),
    code: Option(String),
    performer: Option(String),
    subject: Option(String),
    focus: Option(String),
    part_of: Option(String),
    encounter: Option(String),
    authored_on: Option(String),
    priority: Option(String),
    intent: Option(String),
    output: Option(String),
    actor: Option(String),
    group_identifier: Option(String),
    based_on: Option(String),
    patient: Option(String),
    modified: Option(String),
    status: Option(String),
  )
}

pub type SpTerminologycapabilities {
  SpTerminologycapabilities(
    date: Option(String),
    identifier: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    context_type: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    context: Option(String),
    name: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpTestplan {
  SpTestplan(
    identifier: Option(String),
    scope: Option(String),
    url: Option(String),
    status: Option(String),
  )
}

pub type SpTestreport {
  SpTestreport(
    result: Option(String),
    identifier: Option(String),
    tester: Option(String),
    testscript: Option(String),
    issued: Option(String),
    participant: Option(String),
    status: Option(String),
  )
}

pub type SpTestscript {
  SpTestscript(
    date: Option(String),
    identifier: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    testscript_capability: Option(String),
    context_type: Option(String),
    scope_artifact_phase: Option(String),
    title: Option(String),
    scope_artifact_conformance: Option(String),
    version: Option(String),
    scope_artifact: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    context: Option(String),
    name: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpTransport {
  SpTransport(identifier: Option(String), status: Option(String))
}

pub type SpValueset {
  SpValueset(
    date: Option(String),
    identifier: Option(String),
    code: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    derived_from: Option(String),
    context_type: Option(String),
    predecessor: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    expansion: Option(String),
    reference: Option(String),
    context_quantity: Option(String),
    effective: Option(String),
    context: Option(String),
    name: Option(String),
    publisher: Option(String),
    topic: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpVerificationresult {
  SpVerificationresult(
    status_date: Option(String),
    primarysource_who: Option(String),
    primarysource_date: Option(String),
    validator_organization: Option(String),
    attestation_method: Option(String),
    attestation_onbehalfof: Option(String),
    target: Option(String),
    attestation_who: Option(String),
    primarysource_type: Option(String),
    status: Option(String),
  )
}

pub type SpVisionprescription {
  SpVisionprescription(
    prescriber: Option(String),
    identifier: Option(String),
    patient: Option(String),
    datewritten: Option(String),
    encounter: Option(String),
    status: Option(String),
  )
}

pub fn sp_account_new() {
  SpAccount(None, None, None, None, None, None, None, None, None, None)
}

pub fn sp_activitydefinition_new() {
  SpActivitydefinition(
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
    None,
    None,
    None,
  )
}

pub fn sp_actordefinition_new() {
  SpActordefinition(
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

pub fn sp_administrableproductdefinition_new() {
  SpAdministrableproductdefinition(
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

pub fn sp_adverseevent_new() {
  SpAdverseevent(
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

pub fn sp_allergyintolerance_new() {
  SpAllergyintolerance(
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

pub fn sp_appointment_new() {
  SpAppointment(
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
    None,
  )
}

pub fn sp_appointmentresponse_new() {
  SpAppointmentresponse(None, None, None, None, None, None, None, None)
}

pub fn sp_artifactassessment_new() {
  SpArtifactassessment(None, None)
}

pub fn sp_auditevent_new() {
  SpAuditevent(
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

pub fn sp_basic_new() {
  SpBasic(None, None, None, None, None, None)
}

pub fn sp_binary_new() {
  SpBinary
}

pub fn sp_biologicallyderivedproduct_new() {
  SpBiologicallyderivedproduct(None, None, None, None, None, None, None, None)
}

pub fn sp_biologicallyderivedproductdispense_new() {
  SpBiologicallyderivedproductdispense(None, None, None, None, None)
}

pub fn sp_bodystructure_new() {
  SpBodystructure(None, None, None, None, None)
}

pub fn sp_bundle_new() {
  SpBundle(None, None, None, None, None)
}

pub fn sp_capabilitystatement_new() {
  SpCapabilitystatement(
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
    None,
    None,
    None,
    None,
  )
}

pub fn sp_careplan_new() {
  SpCareplan(
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

pub fn sp_careteam_new() {
  SpCareteam(None, None, None, None, None, None, None, None)
}

pub fn sp_chargeitem_new() {
  SpChargeitem(
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

pub fn sp_chargeitemdefinition_new() {
  SpChargeitemdefinition(
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

pub fn sp_citation_new() {
  SpCitation(
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

pub fn sp_claim_new() {
  SpClaim(
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

pub fn sp_claimresponse_new() {
  SpClaimresponse(
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

pub fn sp_clinicalimpression_new() {
  SpClinicalimpression(
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

pub fn sp_clinicalusedefinition_new() {
  SpClinicalusedefinition(
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

pub fn sp_codesystem_new() {
  SpCodesystem(
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
    None,
    None,
    None,
    None,
  )
}

pub fn sp_communication_new() {
  SpCommunication(
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

pub fn sp_communicationrequest_new() {
  SpCommunicationrequest(
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

pub fn sp_compartmentdefinition_new() {
  SpCompartmentdefinition(
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

pub fn sp_composition_new() {
  SpComposition(
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
    None,
  )
}

pub fn sp_conceptmap_new() {
  SpConceptmap(
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

pub fn sp_condition_new() {
  SpCondition(
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
    None,
    None,
  )
}

pub fn sp_conditiondefinition_new() {
  SpConditiondefinition(
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

pub fn sp_consent_new() {
  SpConsent(
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

pub fn sp_contract_new() {
  SpContract(None, None, None, None, None, None, None, None, None, None)
}

pub fn sp_coverage_new() {
  SpCoverage(
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

pub fn sp_coverageeligibilityrequest_new() {
  SpCoverageeligibilityrequest(None, None, None, None, None, None, None)
}

pub fn sp_coverageeligibilityresponse_new() {
  SpCoverageeligibilityresponse(
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

pub fn sp_detectedissue_new() {
  SpDetectedissue(None, None, None, None, None, None, None, None, None)
}

pub fn sp_device_new() {
  SpDevice(
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
    None,
    None,
    None,
  )
}

pub fn sp_deviceassociation_new() {
  SpDeviceassociation(None, None, None, None, None, None)
}

pub fn sp_devicedefinition_new() {
  SpDevicedefinition(None, None, None, None, None, None, None)
}

pub fn sp_devicedispense_new() {
  SpDevicedispense(None, None, None, None, None)
}

pub fn sp_devicemetric_new() {
  SpDevicemetric(None, None, None, None)
}

pub fn sp_devicerequest_new() {
  SpDevicerequest(
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

pub fn sp_deviceusage_new() {
  SpDeviceusage(None, None, None, None)
}

pub fn sp_diagnosticreport_new() {
  SpDiagnosticreport(
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

pub fn sp_documentreference_new() {
  SpDocumentreference(
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

pub fn sp_encounter_new() {
  SpEncounter(
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

pub fn sp_encounterhistory_new() {
  SpEncounterhistory(None, None, None, None, None)
}

pub fn sp_endpoint_new() {
  SpEndpoint(None, None, None, None, None, None)
}

pub fn sp_enrollmentrequest_new() {
  SpEnrollmentrequest(None, None, None, None)
}

pub fn sp_enrollmentresponse_new() {
  SpEnrollmentresponse(None, None, None)
}

pub fn sp_episodeofcare_new() {
  SpEpisodeofcare(
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

pub fn sp_eventdefinition_new() {
  SpEventdefinition(
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
    None,
    None,
  )
}

pub fn sp_evidence_new() {
  SpEvidence(
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

pub fn sp_evidencereport_new() {
  SpEvidencereport(None, None, None, None, None, None, None, None, None)
}

pub fn sp_evidencevariable_new() {
  SpEvidencevariable(
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

pub fn sp_examplescenario_new() {
  SpExamplescenario(
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

pub fn sp_explanationofbenefit_new() {
  SpExplanationofbenefit(
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

pub fn sp_familymemberhistory_new() {
  SpFamilymemberhistory(None, None, None, None, None, None, None, None, None)
}

pub fn sp_flag_new() {
  SpFlag(None, None, None, None, None, None, None, None)
}

pub fn sp_formularyitem_new() {
  SpFormularyitem(None, None)
}

pub fn sp_genomicstudy_new() {
  SpGenomicstudy(None, None, None, None, None)
}

pub fn sp_goal_new() {
  SpGoal(None, None, None, None, None, None, None, None, None, None, None)
}

pub fn sp_graphdefinition_new() {
  SpGraphdefinition(
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

pub fn sp_group_new() {
  SpGroup(
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

pub fn sp_guidanceresponse_new() {
  SpGuidanceresponse(None, None, None, None, None)
}

pub fn sp_healthcareservice_new() {
  SpHealthcareservice(
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

pub fn sp_imagingselection_new() {
  SpImagingselection(
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

pub fn sp_imagingstudy_new() {
  SpImagingstudy(
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

pub fn sp_immunization_new() {
  SpImmunization(
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

pub fn sp_immunizationevaluation_new() {
  SpImmunizationevaluation(None, None, None, None, None, None, None)
}

pub fn sp_immunizationrecommendation_new() {
  SpImmunizationrecommendation(None, None, None, None, None, None, None, None)
}

pub fn sp_implementationguide_new() {
  SpImplementationguide(
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

pub fn sp_ingredient_new() {
  SpIngredient(
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

pub fn sp_insuranceplan_new() {
  SpInsuranceplan(
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

pub fn sp_inventoryitem_new() {
  SpInventoryitem(None, None, None, None)
}

pub fn sp_inventoryreport_new() {
  SpInventoryreport(None, None, None, None)
}

pub fn sp_invoice_new() {
  SpInvoice(
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

pub fn sp_library_new() {
  SpLibrary(
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
    None,
    None,
    None,
    None,
  )
}

pub fn sp_linkage_new() {
  SpLinkage(None, None, None)
}

pub fn sp_listfhir_new() {
  SpListfhir(
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

pub fn sp_location_new() {
  SpLocation(
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

pub fn sp_manufactureditemdefinition_new() {
  SpManufactureditemdefinition(None, None, None, None, None)
}

pub fn sp_measure_new() {
  SpMeasure(
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
    None,
    None,
  )
}

pub fn sp_measurereport_new() {
  SpMeasurereport(None, None, None, None, None, None, None, None, None, None)
}

pub fn sp_medication_new() {
  SpMedication(None, None, None, None, None, None, None, None, None, None)
}

pub fn sp_medicationadministration_new() {
  SpMedicationadministration(
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

pub fn sp_medicationdispense_new() {
  SpMedicationdispense(
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

pub fn sp_medicationknowledge_new() {
  SpMedicationknowledge(
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

pub fn sp_medicationrequest_new() {
  SpMedicationrequest(
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

pub fn sp_medicationstatement_new() {
  SpMedicationstatement(
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

pub fn sp_medicinalproductdefinition_new() {
  SpMedicinalproductdefinition(
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

pub fn sp_messagedefinition_new() {
  SpMessagedefinition(
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

pub fn sp_messageheader_new() {
  SpMessageheader(
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

pub fn sp_molecularsequence_new() {
  SpMolecularsequence(None, None, None, None, None)
}

pub fn sp_namingsystem_new() {
  SpNamingsystem(
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
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn sp_nutritionintake_new() {
  SpNutritionintake(None, None, None, None, None, None, None, None, None)
}

pub fn sp_nutritionorder_new() {
  SpNutritionorder(
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

pub fn sp_nutritionproduct_new() {
  SpNutritionproduct(None, None, None, None, None)
}

pub fn sp_observation_new() {
  SpObservation(
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
    None,
    None,
  )
}

pub fn sp_observationdefinition_new() {
  SpObservationdefinition(None, None, None, None, None, None, None, None)
}

pub fn sp_operationdefinition_new() {
  SpOperationdefinition(
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
    None,
    None,
    None,
  )
}

pub fn sp_operationoutcome_new() {
  SpOperationoutcome
}

pub fn sp_organization_new() {
  SpOrganization(
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

pub fn sp_organizationaffiliation_new() {
  SpOrganizationaffiliation(
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

pub fn sp_packagedproductdefinition_new() {
  SpPackagedproductdefinition(
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

pub fn sp_patient_new() {
  SpPatient(
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
    None,
    None,
    None,
  )
}

pub fn sp_paymentnotice_new() {
  SpPaymentnotice(None, None, None, None, None, None, None)
}

pub fn sp_paymentreconciliation_new() {
  SpPaymentreconciliation(
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

pub fn sp_permission_new() {
  SpPermission(None)
}

pub fn sp_person_new() {
  SpPerson(
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
    None,
    None,
    None,
  )
}

pub fn sp_plandefinition_new() {
  SpPlandefinition(
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
    None,
    None,
    None,
    None,
  )
}

pub fn sp_practitioner_new() {
  SpPractitioner(
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

pub fn sp_practitionerrole_new() {
  SpPractitionerrole(
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

pub fn sp_procedure_new() {
  SpProcedure(
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

pub fn sp_provenance_new() {
  SpProvenance(
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

pub fn sp_questionnaire_new() {
  SpQuestionnaire(
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
    None,
  )
}

pub fn sp_questionnaireresponse_new() {
  SpQuestionnaireresponse(
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

pub fn sp_regulatedauthorization_new() {
  SpRegulatedauthorization(None, None, None, None, None, None, None)
}

pub fn sp_relatedperson_new() {
  SpRelatedperson(
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

pub fn sp_requestorchestration_new() {
  SpRequestorchestration(
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

pub fn sp_requirements_new() {
  SpRequirements(
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

pub fn sp_researchstudy_new() {
  SpResearchstudy(
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
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn sp_researchsubject_new() {
  SpResearchsubject(None, None, None, None, None, None, None)
}

pub fn sp_riskassessment_new() {
  SpRiskassessment(None, None, None, None, None, None, None, None, None, None)
}

pub fn sp_schedule_new() {
  SpSchedule(None, None, None, None, None, None, None, None, None)
}

pub fn sp_searchparameter_new() {
  SpSearchparameter(
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

pub fn sp_servicerequest_new() {
  SpServicerequest(
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
    None,
    None,
    None,
  )
}

pub fn sp_slot_new() {
  SpSlot(None, None, None, None, None, None, None, None, None)
}

pub fn sp_specimen_new() {
  SpSpecimen(
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

pub fn sp_specimendefinition_new() {
  SpSpecimendefinition(None, None, None, None, None, None, None, None, None)
}

pub fn sp_structuredefinition_new() {
  SpStructuredefinition(
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

pub fn sp_structuremap_new() {
  SpStructuremap(
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

pub fn sp_subscription_new() {
  SpSubscription(
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

pub fn sp_subscriptionstatus_new() {
  SpSubscriptionstatus
}

pub fn sp_subscriptiontopic_new() {
  SpSubscriptiontopic(
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

pub fn sp_substance_new() {
  SpSubstance(None, None, None, None, None, None, None, None)
}

pub fn sp_substancedefinition_new() {
  SpSubstancedefinition(None, None, None, None, None)
}

pub fn sp_substancenucleicacid_new() {
  SpSubstancenucleicacid
}

pub fn sp_substancepolymer_new() {
  SpSubstancepolymer
}

pub fn sp_substanceprotein_new() {
  SpSubstanceprotein
}

pub fn sp_substancereferenceinformation_new() {
  SpSubstancereferenceinformation
}

pub fn sp_substancesourcematerial_new() {
  SpSubstancesourcematerial
}

pub fn sp_supplydelivery_new() {
  SpSupplydelivery(None, None, None, None, None)
}

pub fn sp_supplyrequest_new() {
  SpSupplyrequest(None, None, None, None, None, None, None, None)
}

pub fn sp_task_new() {
  SpTask(
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
    None,
    None,
  )
}

pub fn sp_terminologycapabilities_new() {
  SpTerminologycapabilities(
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

pub fn sp_testplan_new() {
  SpTestplan(None, None, None, None)
}

pub fn sp_testreport_new() {
  SpTestreport(None, None, None, None, None, None, None)
}

pub fn sp_testscript_new() {
  SpTestscript(
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

pub fn sp_transport_new() {
  SpTransport(None, None)
}

pub fn sp_valueset_new() {
  SpValueset(
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
    None,
    None,
  )
}

pub fn sp_verificationresult_new() {
  SpVerificationresult(
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

pub fn sp_visionprescription_new() {
  SpVisionprescription(None, None, None, None, None, None)
}

pub type SpInclude {
  SpInclude(
    inc_account: Option(SpInclude),
    revinc_account: Option(SpInclude),
    inc_activitydefinition: Option(SpInclude),
    revinc_activitydefinition: Option(SpInclude),
    inc_actordefinition: Option(SpInclude),
    revinc_actordefinition: Option(SpInclude),
    inc_administrableproductdefinition: Option(SpInclude),
    revinc_administrableproductdefinition: Option(SpInclude),
    inc_adverseevent: Option(SpInclude),
    revinc_adverseevent: Option(SpInclude),
    inc_allergyintolerance: Option(SpInclude),
    revinc_allergyintolerance: Option(SpInclude),
    inc_appointment: Option(SpInclude),
    revinc_appointment: Option(SpInclude),
    inc_appointmentresponse: Option(SpInclude),
    revinc_appointmentresponse: Option(SpInclude),
    inc_artifactassessment: Option(SpInclude),
    revinc_artifactassessment: Option(SpInclude),
    inc_auditevent: Option(SpInclude),
    revinc_auditevent: Option(SpInclude),
    inc_basic: Option(SpInclude),
    revinc_basic: Option(SpInclude),
    inc_binary: Option(SpInclude),
    revinc_binary: Option(SpInclude),
    inc_biologicallyderivedproduct: Option(SpInclude),
    revinc_biologicallyderivedproduct: Option(SpInclude),
    inc_biologicallyderivedproductdispense: Option(SpInclude),
    revinc_biologicallyderivedproductdispense: Option(SpInclude),
    inc_bodystructure: Option(SpInclude),
    revinc_bodystructure: Option(SpInclude),
    inc_bundle: Option(SpInclude),
    revinc_bundle: Option(SpInclude),
    inc_capabilitystatement: Option(SpInclude),
    revinc_capabilitystatement: Option(SpInclude),
    inc_careplan: Option(SpInclude),
    revinc_careplan: Option(SpInclude),
    inc_careteam: Option(SpInclude),
    revinc_careteam: Option(SpInclude),
    inc_chargeitem: Option(SpInclude),
    revinc_chargeitem: Option(SpInclude),
    inc_chargeitemdefinition: Option(SpInclude),
    revinc_chargeitemdefinition: Option(SpInclude),
    inc_citation: Option(SpInclude),
    revinc_citation: Option(SpInclude),
    inc_claim: Option(SpInclude),
    revinc_claim: Option(SpInclude),
    inc_claimresponse: Option(SpInclude),
    revinc_claimresponse: Option(SpInclude),
    inc_clinicalimpression: Option(SpInclude),
    revinc_clinicalimpression: Option(SpInclude),
    inc_clinicalusedefinition: Option(SpInclude),
    revinc_clinicalusedefinition: Option(SpInclude),
    inc_codesystem: Option(SpInclude),
    revinc_codesystem: Option(SpInclude),
    inc_communication: Option(SpInclude),
    revinc_communication: Option(SpInclude),
    inc_communicationrequest: Option(SpInclude),
    revinc_communicationrequest: Option(SpInclude),
    inc_compartmentdefinition: Option(SpInclude),
    revinc_compartmentdefinition: Option(SpInclude),
    inc_composition: Option(SpInclude),
    revinc_composition: Option(SpInclude),
    inc_conceptmap: Option(SpInclude),
    revinc_conceptmap: Option(SpInclude),
    inc_condition: Option(SpInclude),
    revinc_condition: Option(SpInclude),
    inc_conditiondefinition: Option(SpInclude),
    revinc_conditiondefinition: Option(SpInclude),
    inc_consent: Option(SpInclude),
    revinc_consent: Option(SpInclude),
    inc_contract: Option(SpInclude),
    revinc_contract: Option(SpInclude),
    inc_coverage: Option(SpInclude),
    revinc_coverage: Option(SpInclude),
    inc_coverageeligibilityrequest: Option(SpInclude),
    revinc_coverageeligibilityrequest: Option(SpInclude),
    inc_coverageeligibilityresponse: Option(SpInclude),
    revinc_coverageeligibilityresponse: Option(SpInclude),
    inc_detectedissue: Option(SpInclude),
    revinc_detectedissue: Option(SpInclude),
    inc_device: Option(SpInclude),
    revinc_device: Option(SpInclude),
    inc_deviceassociation: Option(SpInclude),
    revinc_deviceassociation: Option(SpInclude),
    inc_devicedefinition: Option(SpInclude),
    revinc_devicedefinition: Option(SpInclude),
    inc_devicedispense: Option(SpInclude),
    revinc_devicedispense: Option(SpInclude),
    inc_devicemetric: Option(SpInclude),
    revinc_devicemetric: Option(SpInclude),
    inc_devicerequest: Option(SpInclude),
    revinc_devicerequest: Option(SpInclude),
    inc_deviceusage: Option(SpInclude),
    revinc_deviceusage: Option(SpInclude),
    inc_diagnosticreport: Option(SpInclude),
    revinc_diagnosticreport: Option(SpInclude),
    inc_documentreference: Option(SpInclude),
    revinc_documentreference: Option(SpInclude),
    inc_encounter: Option(SpInclude),
    revinc_encounter: Option(SpInclude),
    inc_encounterhistory: Option(SpInclude),
    revinc_encounterhistory: Option(SpInclude),
    inc_endpoint: Option(SpInclude),
    revinc_endpoint: Option(SpInclude),
    inc_enrollmentrequest: Option(SpInclude),
    revinc_enrollmentrequest: Option(SpInclude),
    inc_enrollmentresponse: Option(SpInclude),
    revinc_enrollmentresponse: Option(SpInclude),
    inc_episodeofcare: Option(SpInclude),
    revinc_episodeofcare: Option(SpInclude),
    inc_eventdefinition: Option(SpInclude),
    revinc_eventdefinition: Option(SpInclude),
    inc_evidence: Option(SpInclude),
    revinc_evidence: Option(SpInclude),
    inc_evidencereport: Option(SpInclude),
    revinc_evidencereport: Option(SpInclude),
    inc_evidencevariable: Option(SpInclude),
    revinc_evidencevariable: Option(SpInclude),
    inc_examplescenario: Option(SpInclude),
    revinc_examplescenario: Option(SpInclude),
    inc_explanationofbenefit: Option(SpInclude),
    revinc_explanationofbenefit: Option(SpInclude),
    inc_familymemberhistory: Option(SpInclude),
    revinc_familymemberhistory: Option(SpInclude),
    inc_flag: Option(SpInclude),
    revinc_flag: Option(SpInclude),
    inc_formularyitem: Option(SpInclude),
    revinc_formularyitem: Option(SpInclude),
    inc_genomicstudy: Option(SpInclude),
    revinc_genomicstudy: Option(SpInclude),
    inc_goal: Option(SpInclude),
    revinc_goal: Option(SpInclude),
    inc_graphdefinition: Option(SpInclude),
    revinc_graphdefinition: Option(SpInclude),
    inc_group: Option(SpInclude),
    revinc_group: Option(SpInclude),
    inc_guidanceresponse: Option(SpInclude),
    revinc_guidanceresponse: Option(SpInclude),
    inc_healthcareservice: Option(SpInclude),
    revinc_healthcareservice: Option(SpInclude),
    inc_imagingselection: Option(SpInclude),
    revinc_imagingselection: Option(SpInclude),
    inc_imagingstudy: Option(SpInclude),
    revinc_imagingstudy: Option(SpInclude),
    inc_immunization: Option(SpInclude),
    revinc_immunization: Option(SpInclude),
    inc_immunizationevaluation: Option(SpInclude),
    revinc_immunizationevaluation: Option(SpInclude),
    inc_immunizationrecommendation: Option(SpInclude),
    revinc_immunizationrecommendation: Option(SpInclude),
    inc_implementationguide: Option(SpInclude),
    revinc_implementationguide: Option(SpInclude),
    inc_ingredient: Option(SpInclude),
    revinc_ingredient: Option(SpInclude),
    inc_insuranceplan: Option(SpInclude),
    revinc_insuranceplan: Option(SpInclude),
    inc_inventoryitem: Option(SpInclude),
    revinc_inventoryitem: Option(SpInclude),
    inc_inventoryreport: Option(SpInclude),
    revinc_inventoryreport: Option(SpInclude),
    inc_invoice: Option(SpInclude),
    revinc_invoice: Option(SpInclude),
    inc_library: Option(SpInclude),
    revinc_library: Option(SpInclude),
    inc_linkage: Option(SpInclude),
    revinc_linkage: Option(SpInclude),
    inc_listfhir: Option(SpInclude),
    revinc_listfhir: Option(SpInclude),
    inc_location: Option(SpInclude),
    revinc_location: Option(SpInclude),
    inc_manufactureditemdefinition: Option(SpInclude),
    revinc_manufactureditemdefinition: Option(SpInclude),
    inc_measure: Option(SpInclude),
    revinc_measure: Option(SpInclude),
    inc_measurereport: Option(SpInclude),
    revinc_measurereport: Option(SpInclude),
    inc_medication: Option(SpInclude),
    revinc_medication: Option(SpInclude),
    inc_medicationadministration: Option(SpInclude),
    revinc_medicationadministration: Option(SpInclude),
    inc_medicationdispense: Option(SpInclude),
    revinc_medicationdispense: Option(SpInclude),
    inc_medicationknowledge: Option(SpInclude),
    revinc_medicationknowledge: Option(SpInclude),
    inc_medicationrequest: Option(SpInclude),
    revinc_medicationrequest: Option(SpInclude),
    inc_medicationstatement: Option(SpInclude),
    revinc_medicationstatement: Option(SpInclude),
    inc_medicinalproductdefinition: Option(SpInclude),
    revinc_medicinalproductdefinition: Option(SpInclude),
    inc_messagedefinition: Option(SpInclude),
    revinc_messagedefinition: Option(SpInclude),
    inc_messageheader: Option(SpInclude),
    revinc_messageheader: Option(SpInclude),
    inc_molecularsequence: Option(SpInclude),
    revinc_molecularsequence: Option(SpInclude),
    inc_namingsystem: Option(SpInclude),
    revinc_namingsystem: Option(SpInclude),
    inc_nutritionintake: Option(SpInclude),
    revinc_nutritionintake: Option(SpInclude),
    inc_nutritionorder: Option(SpInclude),
    revinc_nutritionorder: Option(SpInclude),
    inc_nutritionproduct: Option(SpInclude),
    revinc_nutritionproduct: Option(SpInclude),
    inc_observation: Option(SpInclude),
    revinc_observation: Option(SpInclude),
    inc_observationdefinition: Option(SpInclude),
    revinc_observationdefinition: Option(SpInclude),
    inc_operationdefinition: Option(SpInclude),
    revinc_operationdefinition: Option(SpInclude),
    inc_operationoutcome: Option(SpInclude),
    revinc_operationoutcome: Option(SpInclude),
    inc_organization: Option(SpInclude),
    revinc_organization: Option(SpInclude),
    inc_organizationaffiliation: Option(SpInclude),
    revinc_organizationaffiliation: Option(SpInclude),
    inc_packagedproductdefinition: Option(SpInclude),
    revinc_packagedproductdefinition: Option(SpInclude),
    inc_patient: Option(SpInclude),
    revinc_patient: Option(SpInclude),
    inc_paymentnotice: Option(SpInclude),
    revinc_paymentnotice: Option(SpInclude),
    inc_paymentreconciliation: Option(SpInclude),
    revinc_paymentreconciliation: Option(SpInclude),
    inc_permission: Option(SpInclude),
    revinc_permission: Option(SpInclude),
    inc_person: Option(SpInclude),
    revinc_person: Option(SpInclude),
    inc_plandefinition: Option(SpInclude),
    revinc_plandefinition: Option(SpInclude),
    inc_practitioner: Option(SpInclude),
    revinc_practitioner: Option(SpInclude),
    inc_practitionerrole: Option(SpInclude),
    revinc_practitionerrole: Option(SpInclude),
    inc_procedure: Option(SpInclude),
    revinc_procedure: Option(SpInclude),
    inc_provenance: Option(SpInclude),
    revinc_provenance: Option(SpInclude),
    inc_questionnaire: Option(SpInclude),
    revinc_questionnaire: Option(SpInclude),
    inc_questionnaireresponse: Option(SpInclude),
    revinc_questionnaireresponse: Option(SpInclude),
    inc_regulatedauthorization: Option(SpInclude),
    revinc_regulatedauthorization: Option(SpInclude),
    inc_relatedperson: Option(SpInclude),
    revinc_relatedperson: Option(SpInclude),
    inc_requestorchestration: Option(SpInclude),
    revinc_requestorchestration: Option(SpInclude),
    inc_requirements: Option(SpInclude),
    revinc_requirements: Option(SpInclude),
    inc_researchstudy: Option(SpInclude),
    revinc_researchstudy: Option(SpInclude),
    inc_researchsubject: Option(SpInclude),
    revinc_researchsubject: Option(SpInclude),
    inc_riskassessment: Option(SpInclude),
    revinc_riskassessment: Option(SpInclude),
    inc_schedule: Option(SpInclude),
    revinc_schedule: Option(SpInclude),
    inc_searchparameter: Option(SpInclude),
    revinc_searchparameter: Option(SpInclude),
    inc_servicerequest: Option(SpInclude),
    revinc_servicerequest: Option(SpInclude),
    inc_slot: Option(SpInclude),
    revinc_slot: Option(SpInclude),
    inc_specimen: Option(SpInclude),
    revinc_specimen: Option(SpInclude),
    inc_specimendefinition: Option(SpInclude),
    revinc_specimendefinition: Option(SpInclude),
    inc_structuredefinition: Option(SpInclude),
    revinc_structuredefinition: Option(SpInclude),
    inc_structuremap: Option(SpInclude),
    revinc_structuremap: Option(SpInclude),
    inc_subscription: Option(SpInclude),
    revinc_subscription: Option(SpInclude),
    inc_subscriptionstatus: Option(SpInclude),
    revinc_subscriptionstatus: Option(SpInclude),
    inc_subscriptiontopic: Option(SpInclude),
    revinc_subscriptiontopic: Option(SpInclude),
    inc_substance: Option(SpInclude),
    revinc_substance: Option(SpInclude),
    inc_substancedefinition: Option(SpInclude),
    revinc_substancedefinition: Option(SpInclude),
    inc_substancenucleicacid: Option(SpInclude),
    revinc_substancenucleicacid: Option(SpInclude),
    inc_substancepolymer: Option(SpInclude),
    revinc_substancepolymer: Option(SpInclude),
    inc_substanceprotein: Option(SpInclude),
    revinc_substanceprotein: Option(SpInclude),
    inc_substancereferenceinformation: Option(SpInclude),
    revinc_substancereferenceinformation: Option(SpInclude),
    inc_substancesourcematerial: Option(SpInclude),
    revinc_substancesourcematerial: Option(SpInclude),
    inc_supplydelivery: Option(SpInclude),
    revinc_supplydelivery: Option(SpInclude),
    inc_supplyrequest: Option(SpInclude),
    revinc_supplyrequest: Option(SpInclude),
    inc_task: Option(SpInclude),
    revinc_task: Option(SpInclude),
    inc_terminologycapabilities: Option(SpInclude),
    revinc_terminologycapabilities: Option(SpInclude),
    inc_testplan: Option(SpInclude),
    revinc_testplan: Option(SpInclude),
    inc_testreport: Option(SpInclude),
    revinc_testreport: Option(SpInclude),
    inc_testscript: Option(SpInclude),
    revinc_testscript: Option(SpInclude),
    inc_transport: Option(SpInclude),
    revinc_transport: Option(SpInclude),
    inc_valueset: Option(SpInclude),
    revinc_valueset: Option(SpInclude),
    inc_verificationresult: Option(SpInclude),
    revinc_verificationresult: Option(SpInclude),
    inc_visionprescription: Option(SpInclude),
    revinc_visionprescription: Option(SpInclude),
  )
}

pub type GroupedResources {
  GroupedResources(
    account: List(resources.Account),
    activitydefinition: List(resources.Activitydefinition),
    actordefinition: List(resources.Actordefinition),
    administrableproductdefinition: List(
      resources.Administrableproductdefinition,
    ),
    adverseevent: List(resources.Adverseevent),
    allergyintolerance: List(resources.Allergyintolerance),
    appointment: List(resources.Appointment),
    appointmentresponse: List(resources.Appointmentresponse),
    artifactassessment: List(resources.Artifactassessment),
    auditevent: List(resources.Auditevent),
    basic: List(resources.Basic),
    binary: List(resources.Binary),
    biologicallyderivedproduct: List(resources.Biologicallyderivedproduct),
    biologicallyderivedproductdispense: List(
      resources.Biologicallyderivedproductdispense,
    ),
    bodystructure: List(resources.Bodystructure),
    bundle: List(resources.Bundle),
    capabilitystatement: List(resources.Capabilitystatement),
    careplan: List(resources.Careplan),
    careteam: List(resources.Careteam),
    chargeitem: List(resources.Chargeitem),
    chargeitemdefinition: List(resources.Chargeitemdefinition),
    citation: List(resources.Citation),
    claim: List(resources.Claim),
    claimresponse: List(resources.Claimresponse),
    clinicalimpression: List(resources.Clinicalimpression),
    clinicalusedefinition: List(resources.Clinicalusedefinition),
    codesystem: List(resources.Codesystem),
    communication: List(resources.Communication),
    communicationrequest: List(resources.Communicationrequest),
    compartmentdefinition: List(resources.Compartmentdefinition),
    composition: List(resources.Composition),
    conceptmap: List(resources.Conceptmap),
    condition: List(resources.Condition),
    conditiondefinition: List(resources.Conditiondefinition),
    consent: List(resources.Consent),
    contract: List(resources.Contract),
    coverage: List(resources.Coverage),
    coverageeligibilityrequest: List(resources.Coverageeligibilityrequest),
    coverageeligibilityresponse: List(resources.Coverageeligibilityresponse),
    detectedissue: List(resources.Detectedissue),
    device: List(resources.Device),
    deviceassociation: List(resources.Deviceassociation),
    devicedefinition: List(resources.Devicedefinition),
    devicedispense: List(resources.Devicedispense),
    devicemetric: List(resources.Devicemetric),
    devicerequest: List(resources.Devicerequest),
    deviceusage: List(resources.Deviceusage),
    diagnosticreport: List(resources.Diagnosticreport),
    documentreference: List(resources.Documentreference),
    encounter: List(resources.Encounter),
    encounterhistory: List(resources.Encounterhistory),
    endpoint: List(resources.Endpoint),
    enrollmentrequest: List(resources.Enrollmentrequest),
    enrollmentresponse: List(resources.Enrollmentresponse),
    episodeofcare: List(resources.Episodeofcare),
    eventdefinition: List(resources.Eventdefinition),
    evidence: List(resources.Evidence),
    evidencereport: List(resources.Evidencereport),
    evidencevariable: List(resources.Evidencevariable),
    examplescenario: List(resources.Examplescenario),
    explanationofbenefit: List(resources.Explanationofbenefit),
    familymemberhistory: List(resources.Familymemberhistory),
    flag: List(resources.Flag),
    formularyitem: List(resources.Formularyitem),
    genomicstudy: List(resources.Genomicstudy),
    goal: List(resources.Goal),
    graphdefinition: List(resources.Graphdefinition),
    group: List(resources.Group),
    guidanceresponse: List(resources.Guidanceresponse),
    healthcareservice: List(resources.Healthcareservice),
    imagingselection: List(resources.Imagingselection),
    imagingstudy: List(resources.Imagingstudy),
    immunization: List(resources.Immunization),
    immunizationevaluation: List(resources.Immunizationevaluation),
    immunizationrecommendation: List(resources.Immunizationrecommendation),
    implementationguide: List(resources.Implementationguide),
    ingredient: List(resources.Ingredient),
    insuranceplan: List(resources.Insuranceplan),
    inventoryitem: List(resources.Inventoryitem),
    inventoryreport: List(resources.Inventoryreport),
    invoice: List(resources.Invoice),
    library: List(resources.Library),
    linkage: List(resources.Linkage),
    listfhir: List(resources.Listfhir),
    location: List(resources.Location),
    manufactureditemdefinition: List(resources.Manufactureditemdefinition),
    measure: List(resources.Measure),
    measurereport: List(resources.Measurereport),
    medication: List(resources.Medication),
    medicationadministration: List(resources.Medicationadministration),
    medicationdispense: List(resources.Medicationdispense),
    medicationknowledge: List(resources.Medicationknowledge),
    medicationrequest: List(resources.Medicationrequest),
    medicationstatement: List(resources.Medicationstatement),
    medicinalproductdefinition: List(resources.Medicinalproductdefinition),
    messagedefinition: List(resources.Messagedefinition),
    messageheader: List(resources.Messageheader),
    molecularsequence: List(resources.Molecularsequence),
    namingsystem: List(resources.Namingsystem),
    nutritionintake: List(resources.Nutritionintake),
    nutritionorder: List(resources.Nutritionorder),
    nutritionproduct: List(resources.Nutritionproduct),
    observation: List(resources.Observation),
    observationdefinition: List(resources.Observationdefinition),
    operationdefinition: List(resources.Operationdefinition),
    operationoutcome: List(resources.Operationoutcome),
    organization: List(resources.Organization),
    organizationaffiliation: List(resources.Organizationaffiliation),
    packagedproductdefinition: List(resources.Packagedproductdefinition),
    patient: List(resources.Patient),
    paymentnotice: List(resources.Paymentnotice),
    paymentreconciliation: List(resources.Paymentreconciliation),
    permission: List(resources.Permission),
    person: List(resources.Person),
    plandefinition: List(resources.Plandefinition),
    practitioner: List(resources.Practitioner),
    practitionerrole: List(resources.Practitionerrole),
    procedure: List(resources.Procedure),
    provenance: List(resources.Provenance),
    questionnaire: List(resources.Questionnaire),
    questionnaireresponse: List(resources.Questionnaireresponse),
    regulatedauthorization: List(resources.Regulatedauthorization),
    relatedperson: List(resources.Relatedperson),
    requestorchestration: List(resources.Requestorchestration),
    requirements: List(resources.Requirements),
    researchstudy: List(resources.Researchstudy),
    researchsubject: List(resources.Researchsubject),
    riskassessment: List(resources.Riskassessment),
    schedule: List(resources.Schedule),
    searchparameter: List(resources.Searchparameter),
    servicerequest: List(resources.Servicerequest),
    slot: List(resources.Slot),
    specimen: List(resources.Specimen),
    specimendefinition: List(resources.Specimendefinition),
    structuredefinition: List(resources.Structuredefinition),
    structuremap: List(resources.Structuremap),
    subscription: List(resources.Subscription),
    subscriptionstatus: List(resources.Subscriptionstatus),
    subscriptiontopic: List(resources.Subscriptiontopic),
    substance: List(resources.Substance),
    substancedefinition: List(resources.Substancedefinition),
    substancenucleicacid: List(resources.Substancenucleicacid),
    substancepolymer: List(resources.Substancepolymer),
    substanceprotein: List(resources.Substanceprotein),
    substancereferenceinformation: List(resources.Substancereferenceinformation),
    substancesourcematerial: List(resources.Substancesourcematerial),
    supplydelivery: List(resources.Supplydelivery),
    supplyrequest: List(resources.Supplyrequest),
    task: List(resources.Task),
    terminologycapabilities: List(resources.Terminologycapabilities),
    testplan: List(resources.Testplan),
    testreport: List(resources.Testreport),
    testscript: List(resources.Testscript),
    transport: List(resources.Transport),
    valueset: List(resources.Valueset),
    verificationresult: List(resources.Verificationresult),
    visionprescription: List(resources.Visionprescription),
  )
}

pub fn groupedresources_new() {
  GroupedResources(
    account: [],
    activitydefinition: [],
    actordefinition: [],
    administrableproductdefinition: [],
    adverseevent: [],
    allergyintolerance: [],
    appointment: [],
    appointmentresponse: [],
    artifactassessment: [],
    auditevent: [],
    basic: [],
    binary: [],
    biologicallyderivedproduct: [],
    biologicallyderivedproductdispense: [],
    bodystructure: [],
    bundle: [],
    capabilitystatement: [],
    careplan: [],
    careteam: [],
    chargeitem: [],
    chargeitemdefinition: [],
    citation: [],
    claim: [],
    claimresponse: [],
    clinicalimpression: [],
    clinicalusedefinition: [],
    codesystem: [],
    communication: [],
    communicationrequest: [],
    compartmentdefinition: [],
    composition: [],
    conceptmap: [],
    condition: [],
    conditiondefinition: [],
    consent: [],
    contract: [],
    coverage: [],
    coverageeligibilityrequest: [],
    coverageeligibilityresponse: [],
    detectedissue: [],
    device: [],
    deviceassociation: [],
    devicedefinition: [],
    devicedispense: [],
    devicemetric: [],
    devicerequest: [],
    deviceusage: [],
    diagnosticreport: [],
    documentreference: [],
    encounter: [],
    encounterhistory: [],
    endpoint: [],
    enrollmentrequest: [],
    enrollmentresponse: [],
    episodeofcare: [],
    eventdefinition: [],
    evidence: [],
    evidencereport: [],
    evidencevariable: [],
    examplescenario: [],
    explanationofbenefit: [],
    familymemberhistory: [],
    flag: [],
    formularyitem: [],
    genomicstudy: [],
    goal: [],
    graphdefinition: [],
    group: [],
    guidanceresponse: [],
    healthcareservice: [],
    imagingselection: [],
    imagingstudy: [],
    immunization: [],
    immunizationevaluation: [],
    immunizationrecommendation: [],
    implementationguide: [],
    ingredient: [],
    insuranceplan: [],
    inventoryitem: [],
    inventoryreport: [],
    invoice: [],
    library: [],
    linkage: [],
    listfhir: [],
    location: [],
    manufactureditemdefinition: [],
    measure: [],
    measurereport: [],
    medication: [],
    medicationadministration: [],
    medicationdispense: [],
    medicationknowledge: [],
    medicationrequest: [],
    medicationstatement: [],
    medicinalproductdefinition: [],
    messagedefinition: [],
    messageheader: [],
    molecularsequence: [],
    namingsystem: [],
    nutritionintake: [],
    nutritionorder: [],
    nutritionproduct: [],
    observation: [],
    observationdefinition: [],
    operationdefinition: [],
    operationoutcome: [],
    organization: [],
    organizationaffiliation: [],
    packagedproductdefinition: [],
    patient: [],
    paymentnotice: [],
    paymentreconciliation: [],
    permission: [],
    person: [],
    plandefinition: [],
    practitioner: [],
    practitionerrole: [],
    procedure: [],
    provenance: [],
    questionnaire: [],
    questionnaireresponse: [],
    regulatedauthorization: [],
    relatedperson: [],
    requestorchestration: [],
    requirements: [],
    researchstudy: [],
    researchsubject: [],
    riskassessment: [],
    schedule: [],
    searchparameter: [],
    servicerequest: [],
    slot: [],
    specimen: [],
    specimendefinition: [],
    structuredefinition: [],
    structuremap: [],
    subscription: [],
    subscriptionstatus: [],
    subscriptiontopic: [],
    substance: [],
    substancedefinition: [],
    substancenucleicacid: [],
    substancepolymer: [],
    substanceprotein: [],
    substancereferenceinformation: [],
    substancesourcematerial: [],
    supplydelivery: [],
    supplyrequest: [],
    task: [],
    terminologycapabilities: [],
    testplan: [],
    testreport: [],
    testscript: [],
    transport: [],
    valueset: [],
    verificationresult: [],
    visionprescription: [],
  )
}

pub fn account_search_req(sp: SpAccount, client: FhirClient) {
  let params =
    using_params([
      #("owner", sp.owner),
      #("identifier", sp.identifier),
      #("period", sp.period),
      #("patient", sp.patient),
      #("subject", sp.subject),
      #("name", sp.name),
      #("guarantor", sp.guarantor),
      #("type", sp.type_),
      #("relatedaccount", sp.relatedaccount),
      #("status", sp.status),
    ])
  any_search_req(params, "Account", client)
}

pub fn activitydefinition_search_req(
  sp: SpActivitydefinition,
  client: FhirClient,
) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("successor", sp.successor),
      #("context-type-value", sp.context_type_value),
      #("kind", sp.kind),
      #("jurisdiction", sp.jurisdiction),
      #("derived-from", sp.derived_from),
      #("description", sp.description),
      #("context-type", sp.context_type),
      #("predecessor", sp.predecessor),
      #("composed-of", sp.composed_of),
      #("title", sp.title),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("depends-on", sp.depends_on),
      #("effective", sp.effective),
      #("context", sp.context),
      #("name", sp.name),
      #("publisher", sp.publisher),
      #("topic", sp.topic),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "ActivityDefinition", client)
}

pub fn actordefinition_search_req(sp: SpActordefinition, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("context-type-value", sp.context_type_value),
      #("jurisdiction", sp.jurisdiction),
      #("description", sp.description),
      #("context-type", sp.context_type),
      #("title", sp.title),
      #("type", sp.type_),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("context", sp.context),
      #("publisher", sp.publisher),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "ActorDefinition", client)
}

pub fn administrableproductdefinition_search_req(
  sp: SpAdministrableproductdefinition,
  client: FhirClient,
) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("manufactured-item", sp.manufactured_item),
      #("ingredient", sp.ingredient),
      #("route", sp.route),
      #("dose-form", sp.dose_form),
      #("device", sp.device),
      #("form-of", sp.form_of),
      #("target-species", sp.target_species),
      #("status", sp.status),
    ])
  any_search_req(params, "AdministrableProductDefinition", client)
}

pub fn adverseevent_search_req(sp: SpAdverseevent, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("recorder", sp.recorder),
      #("study", sp.study),
      #("code", sp.code),
      #("actuality", sp.actuality),
      #("subject", sp.subject),
      #("substance", sp.substance),
      #("patient", sp.patient),
      #("resultingeffect", sp.resultingeffect),
      #("seriousness", sp.seriousness),
      #("location", sp.location),
      #("category", sp.category),
      #("status", sp.status),
    ])
  any_search_req(params, "AdverseEvent", client)
}

pub fn allergyintolerance_search_req(
  sp: SpAllergyintolerance,
  client: FhirClient,
) {
  let params =
    using_params([
      #("date", sp.date),
      #("severity", sp.severity),
      #("identifier", sp.identifier),
      #("code", sp.code),
      #("verification-status", sp.verification_status),
      #("criticality", sp.criticality),
      #("manifestation-reference", sp.manifestation_reference),
      #("clinical-status", sp.clinical_status),
      #("type", sp.type_),
      #("participant", sp.participant),
      #("manifestation-code", sp.manifestation_code),
      #("route", sp.route),
      #("patient", sp.patient),
      #("category", sp.category),
      #("last-date", sp.last_date),
    ])
  any_search_req(params, "AllergyIntolerance", client)
}

pub fn appointment_search_req(sp: SpAppointment, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("specialty", sp.specialty),
      #("service-category", sp.service_category),
      #("practitioner", sp.practitioner),
      #("appointment-type", sp.appointment_type),
      #("part-status", sp.part_status),
      #("subject", sp.subject),
      #("service-type", sp.service_type),
      #("slot", sp.slot),
      #("reason-code", sp.reason_code),
      #("actor", sp.actor),
      #("based-on", sp.based_on),
      #("patient", sp.patient),
      #("reason-reference", sp.reason_reference),
      #("supporting-info", sp.supporting_info),
      #("requested-period", sp.requested_period),
      #("location", sp.location),
      #("group", sp.group),
      #("service-type-reference", sp.service_type_reference),
      #("status", sp.status),
    ])
  any_search_req(params, "Appointment", client)
}

pub fn appointmentresponse_search_req(
  sp: SpAppointmentresponse,
  client: FhirClient,
) {
  let params =
    using_params([
      #("actor", sp.actor),
      #("identifier", sp.identifier),
      #("practitioner", sp.practitioner),
      #("part-status", sp.part_status),
      #("patient", sp.patient),
      #("appointment", sp.appointment),
      #("location", sp.location),
      #("group", sp.group),
    ])
  any_search_req(params, "AppointmentResponse", client)
}

pub fn artifactassessment_search_req(
  sp: SpArtifactassessment,
  client: FhirClient,
) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
    ])
  any_search_req(params, "ArtifactAssessment", client)
}

pub fn auditevent_search_req(sp: SpAuditevent, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("agent", sp.agent),
      #("entity-role", sp.entity_role),
      #("code", sp.code),
      #("purpose", sp.purpose),
      #("encounter", sp.encounter),
      #("source", sp.source),
      #("based-on", sp.based_on),
      #("patient", sp.patient),
      #("action", sp.action),
      #("agent-role", sp.agent_role),
      #("category", sp.category),
      #("entity", sp.entity),
      #("outcome", sp.outcome),
      #("policy", sp.policy),
    ])
  any_search_req(params, "AuditEvent", client)
}

pub fn basic_search_req(sp: SpBasic, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("code", sp.code),
      #("author", sp.author),
      #("created", sp.created),
      #("patient", sp.patient),
      #("subject", sp.subject),
    ])
  any_search_req(params, "Basic", client)
}

pub fn binary_search_req(_sp: SpBinary, client: FhirClient) {
  let params = using_params([])
  any_search_req(params, "Binary", client)
}

pub fn biologicallyderivedproduct_search_req(
  sp: SpBiologicallyderivedproduct,
  client: FhirClient,
) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("request", sp.request),
      #("code", sp.code),
      #("product-status", sp.product_status),
      #("serial-number", sp.serial_number),
      #("biological-source-event", sp.biological_source_event),
      #("product-category", sp.product_category),
      #("collector", sp.collector),
    ])
  any_search_req(params, "BiologicallyDerivedProduct", client)
}

pub fn biologicallyderivedproductdispense_search_req(
  sp: SpBiologicallyderivedproductdispense,
  client: FhirClient,
) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("product", sp.product),
      #("performer", sp.performer),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "BiologicallyDerivedProductDispense", client)
}

pub fn bodystructure_search_req(sp: SpBodystructure, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("included_structure", sp.included_structure),
      #("excluded_structure", sp.excluded_structure),
      #("morphology", sp.morphology),
      #("patient", sp.patient),
    ])
  any_search_req(params, "BodyStructure", client)
}

pub fn bundle_search_req(sp: SpBundle, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("composition", sp.composition),
      #("message", sp.message),
      #("type", sp.type_),
      #("timestamp", sp.timestamp),
    ])
  any_search_req(params, "Bundle", client)
}

pub fn capabilitystatement_search_req(
  sp: SpCapabilitystatement,
  client: FhirClient,
) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("resource-profile", sp.resource_profile),
      #("context-type-value", sp.context_type_value),
      #("software", sp.software),
      #("resource", sp.resource),
      #("jurisdiction", sp.jurisdiction),
      #("format", sp.format),
      #("description", sp.description),
      #("context-type", sp.context_type),
      #("fhirversion", sp.fhirversion),
      #("title", sp.title),
      #("version", sp.version),
      #("supported-profile", sp.supported_profile),
      #("url", sp.url),
      #("mode", sp.mode),
      #("context-quantity", sp.context_quantity),
      #("security-service", sp.security_service),
      #("context", sp.context),
      #("name", sp.name),
      #("publisher", sp.publisher),
      #("context-type-quantity", sp.context_type_quantity),
      #("guide", sp.guide),
      #("status", sp.status),
    ])
  any_search_req(params, "CapabilityStatement", client)
}

pub fn careplan_search_req(sp: SpCareplan, client: FhirClient) {
  let params =
    using_params([
      #("care-team", sp.care_team),
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("goal", sp.goal),
      #("custodian", sp.custodian),
      #("replaces", sp.replaces),
      #("subject", sp.subject),
      #("instantiates-canonical", sp.instantiates_canonical),
      #("part-of", sp.part_of),
      #("encounter", sp.encounter),
      #("intent", sp.intent),
      #("activity-reference", sp.activity_reference),
      #("condition", sp.condition),
      #("based-on", sp.based_on),
      #("patient", sp.patient),
      #("instantiates-uri", sp.instantiates_uri),
      #("category", sp.category),
      #("status", sp.status),
    ])
  any_search_req(params, "CarePlan", client)
}

pub fn careteam_search_req(sp: SpCareteam, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("patient", sp.patient),
      #("subject", sp.subject),
      #("name", sp.name),
      #("category", sp.category),
      #("participant", sp.participant),
      #("status", sp.status),
    ])
  any_search_req(params, "CareTeam", client)
}

pub fn chargeitem_search_req(sp: SpChargeitem, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("performing-organization", sp.performing_organization),
      #("code", sp.code),
      #("quantity", sp.quantity),
      #("subject", sp.subject),
      #("encounter", sp.encounter),
      #("occurrence", sp.occurrence),
      #("entered-date", sp.entered_date),
      #("performer-function", sp.performer_function),
      #("factor-override", sp.factor_override),
      #("patient", sp.patient),
      #("service", sp.service),
      #("price-override", sp.price_override),
      #("enterer", sp.enterer),
      #("performer-actor", sp.performer_actor),
      #("account", sp.account),
      #("requesting-organization", sp.requesting_organization),
      #("status", sp.status),
    ])
  any_search_req(params, "ChargeItem", client)
}

pub fn chargeitemdefinition_search_req(
  sp: SpChargeitemdefinition,
  client: FhirClient,
) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("context-type-value", sp.context_type_value),
      #("jurisdiction", sp.jurisdiction),
      #("description", sp.description),
      #("context-type", sp.context_type),
      #("title", sp.title),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("effective", sp.effective),
      #("context", sp.context),
      #("publisher", sp.publisher),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "ChargeItemDefinition", client)
}

pub fn citation_search_req(sp: SpCitation, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("context-type-value", sp.context_type_value),
      #("jurisdiction", sp.jurisdiction),
      #("description", sp.description),
      #("classification-type", sp.classification_type),
      #("context-type", sp.context_type),
      #("title", sp.title),
      #("classification", sp.classification),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("effective", sp.effective),
      #("context", sp.context),
      #("name", sp.name),
      #("classifier", sp.classifier),
      #("publisher", sp.publisher),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "Citation", client)
}

pub fn claim_search_req(sp: SpClaim, client: FhirClient) {
  let params =
    using_params([
      #("care-team", sp.care_team),
      #("identifier", sp.identifier),
      #("created", sp.created),
      #("use", sp.use_),
      #("encounter", sp.encounter),
      #("priority", sp.priority),
      #("payee", sp.payee),
      #("provider", sp.provider),
      #("insurer", sp.insurer),
      #("patient", sp.patient),
      #("detail-udi", sp.detail_udi),
      #("enterer", sp.enterer),
      #("procedure-udi", sp.procedure_udi),
      #("subdetail-udi", sp.subdetail_udi),
      #("facility", sp.facility),
      #("item-udi", sp.item_udi),
      #("status", sp.status),
    ])
  any_search_req(params, "Claim", client)
}

pub fn claimresponse_search_req(sp: SpClaimresponse, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("request", sp.request),
      #("disposition", sp.disposition),
      #("created", sp.created),
      #("insurer", sp.insurer),
      #("patient", sp.patient),
      #("use", sp.use_),
      #("payment-date", sp.payment_date),
      #("outcome", sp.outcome),
      #("requestor", sp.requestor),
      #("status", sp.status),
    ])
  any_search_req(params, "ClaimResponse", client)
}

pub fn clinicalimpression_search_req(
  sp: SpClinicalimpression,
  client: FhirClient,
) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("performer", sp.performer),
      #("problem", sp.problem),
      #("previous", sp.previous),
      #("finding-code", sp.finding_code),
      #("patient", sp.patient),
      #("subject", sp.subject),
      #("supporting-info", sp.supporting_info),
      #("encounter", sp.encounter),
      #("finding-ref", sp.finding_ref),
      #("status", sp.status),
    ])
  any_search_req(params, "ClinicalImpression", client)
}

pub fn clinicalusedefinition_search_req(
  sp: SpClinicalusedefinition,
  client: FhirClient,
) {
  let params =
    using_params([
      #("contraindication-reference", sp.contraindication_reference),
      #("identifier", sp.identifier),
      #("indication-reference", sp.indication_reference),
      #("product", sp.product),
      #("subject", sp.subject),
      #("effect", sp.effect),
      #("interaction", sp.interaction),
      #("indication", sp.indication),
      #("type", sp.type_),
      #("contraindication", sp.contraindication),
      #("effect-reference", sp.effect_reference),
      #("status", sp.status),
    ])
  any_search_req(params, "ClinicalUseDefinition", client)
}

pub fn codesystem_search_req(sp: SpCodesystem, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("code", sp.code),
      #("context-type-value", sp.context_type_value),
      #("content-mode", sp.content_mode),
      #("jurisdiction", sp.jurisdiction),
      #("description", sp.description),
      #("derived-from", sp.derived_from),
      #("context-type", sp.context_type),
      #("language", sp.language),
      #("predecessor", sp.predecessor),
      #("title", sp.title),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("supplements", sp.supplements),
      #("effective", sp.effective),
      #("system", sp.system),
      #("context", sp.context),
      #("name", sp.name),
      #("publisher", sp.publisher),
      #("topic", sp.topic),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "CodeSystem", client)
}

pub fn communication_search_req(sp: SpCommunication, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("subject", sp.subject),
      #("instantiates-canonical", sp.instantiates_canonical),
      #("part-of", sp.part_of),
      #("received", sp.received),
      #("encounter", sp.encounter),
      #("medium", sp.medium),
      #("sent", sp.sent),
      #("based-on", sp.based_on),
      #("sender", sp.sender),
      #("patient", sp.patient),
      #("recipient", sp.recipient),
      #("topic", sp.topic),
      #("instantiates-uri", sp.instantiates_uri),
      #("category", sp.category),
      #("status", sp.status),
    ])
  any_search_req(params, "Communication", client)
}

pub fn communicationrequest_search_req(
  sp: SpCommunicationrequest,
  client: FhirClient,
) {
  let params =
    using_params([
      #("authored", sp.authored),
      #("requester", sp.requester),
      #("identifier", sp.identifier),
      #("replaces", sp.replaces),
      #("subject", sp.subject),
      #("encounter", sp.encounter),
      #("medium", sp.medium),
      #("occurrence", sp.occurrence),
      #("priority", sp.priority),
      #("group-identifier", sp.group_identifier),
      #("based-on", sp.based_on),
      #("patient", sp.patient),
      #("recipient", sp.recipient),
      #("information-provider", sp.information_provider),
      #("category", sp.category),
      #("status", sp.status),
    ])
  any_search_req(params, "CommunicationRequest", client)
}

pub fn compartmentdefinition_search_req(
  sp: SpCompartmentdefinition,
  client: FhirClient,
) {
  let params =
    using_params([
      #("date", sp.date),
      #("code", sp.code),
      #("context-type-value", sp.context_type_value),
      #("resource", sp.resource),
      #("description", sp.description),
      #("context-type", sp.context_type),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("context", sp.context),
      #("name", sp.name),
      #("publisher", sp.publisher),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "CompartmentDefinition", client)
}

pub fn composition_search_req(sp: SpComposition, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("period", sp.period),
      #("event-code", sp.event_code),
      #("author", sp.author),
      #("subject", sp.subject),
      #("section", sp.section),
      #("encounter", sp.encounter),
      #("title", sp.title),
      #("type", sp.type_),
      #("version", sp.version),
      #("attester", sp.attester),
      #("url", sp.url),
      #("event-reference", sp.event_reference),
      #("section-text", sp.section_text),
      #("entry", sp.entry),
      #("related", sp.related),
      #("patient", sp.patient),
      #("category", sp.category),
      #("section-code-text", sp.section_code_text),
      #("status", sp.status),
    ])
  any_search_req(params, "Composition", client)
}

pub fn conceptmap_search_req(sp: SpConceptmap, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("target-scope", sp.target_scope),
      #("context-type-value", sp.context_type_value),
      #("jurisdiction", sp.jurisdiction),
      #("description", sp.description),
      #("target-group-system", sp.target_group_system),
      #("derived-from", sp.derived_from),
      #("context-type", sp.context_type),
      #("predecessor", sp.predecessor),
      #("title", sp.title),
      #("context-quantity", sp.context_quantity),
      #("effective", sp.effective),
      #("source-scope", sp.source_scope),
      #("context", sp.context),
      #("context-type-quantity", sp.context_type_quantity),
      #("target-code", sp.target_code),
      #("identifier", sp.identifier),
      #("source-scope-uri", sp.source_scope_uri),
      #("source-group-system", sp.source_group_system),
      #("mapping-property", sp.mapping_property),
      #("other-map", sp.other_map),
      #("version", sp.version),
      #("url", sp.url),
      #("source-code", sp.source_code),
      #("target-scope-uri", sp.target_scope_uri),
      #("name", sp.name),
      #("publisher", sp.publisher),
      #("topic", sp.topic),
      #("status", sp.status),
    ])
  any_search_req(params, "ConceptMap", client)
}

pub fn condition_search_req(sp: SpCondition, client: FhirClient) {
  let params =
    using_params([
      #("evidence-detail", sp.evidence_detail),
      #("severity", sp.severity),
      #("identifier", sp.identifier),
      #("onset-info", sp.onset_info),
      #("recorded-date", sp.recorded_date),
      #("code", sp.code),
      #("evidence", sp.evidence),
      #("participant-function", sp.participant_function),
      #("subject", sp.subject),
      #("participant-actor", sp.participant_actor),
      #("verification-status", sp.verification_status),
      #("clinical-status", sp.clinical_status),
      #("encounter", sp.encounter),
      #("onset-date", sp.onset_date),
      #("abatement-date", sp.abatement_date),
      #("stage", sp.stage),
      #("abatement-string", sp.abatement_string),
      #("patient", sp.patient),
      #("abatement-age", sp.abatement_age),
      #("onset-age", sp.onset_age),
      #("body-site", sp.body_site),
      #("category", sp.category),
    ])
  any_search_req(params, "Condition", client)
}

pub fn conditiondefinition_search_req(
  sp: SpConditiondefinition,
  client: FhirClient,
) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("context-type-value", sp.context_type_value),
      #("jurisdiction", sp.jurisdiction),
      #("description", sp.description),
      #("context-type", sp.context_type),
      #("title", sp.title),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("context", sp.context),
      #("name", sp.name),
      #("publisher", sp.publisher),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "ConditionDefinition", client)
}

pub fn consent_search_req(sp: SpConsent, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("controller", sp.controller),
      #("period", sp.period),
      #("data", sp.data),
      #("manager", sp.manager),
      #("purpose", sp.purpose),
      #("subject", sp.subject),
      #("verified-date", sp.verified_date),
      #("grantee", sp.grantee),
      #("source-reference", sp.source_reference),
      #("verified", sp.verified),
      #("actor", sp.actor),
      #("security-label", sp.security_label),
      #("patient", sp.patient),
      #("action", sp.action),
      #("category", sp.category),
      #("status", sp.status),
    ])
  any_search_req(params, "Consent", client)
}

pub fn contract_search_req(sp: SpContract, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("instantiates", sp.instantiates),
      #("patient", sp.patient),
      #("subject", sp.subject),
      #("authority", sp.authority),
      #("domain", sp.domain),
      #("issued", sp.issued),
      #("url", sp.url),
      #("signer", sp.signer),
      #("status", sp.status),
    ])
  any_search_req(params, "Contract", client)
}

pub fn coverage_search_req(sp: SpCoverage, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("subscriber", sp.subscriber),
      #("subscriberid", sp.subscriberid),
      #("type", sp.type_),
      #("beneficiary", sp.beneficiary),
      #("patient", sp.patient),
      #("insurer", sp.insurer),
      #("class-value", sp.class_value),
      #("paymentby-party", sp.paymentby_party),
      #("class-type", sp.class_type),
      #("dependent", sp.dependent),
      #("policy-holder", sp.policy_holder),
      #("status", sp.status),
    ])
  any_search_req(params, "Coverage", client)
}

pub fn coverageeligibilityrequest_search_req(
  sp: SpCoverageeligibilityrequest,
  client: FhirClient,
) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("provider", sp.provider),
      #("created", sp.created),
      #("patient", sp.patient),
      #("enterer", sp.enterer),
      #("facility", sp.facility),
      #("status", sp.status),
    ])
  any_search_req(params, "CoverageEligibilityRequest", client)
}

pub fn coverageeligibilityresponse_search_req(
  sp: SpCoverageeligibilityresponse,
  client: FhirClient,
) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("request", sp.request),
      #("disposition", sp.disposition),
      #("created", sp.created),
      #("insurer", sp.insurer),
      #("patient", sp.patient),
      #("outcome", sp.outcome),
      #("requestor", sp.requestor),
      #("status", sp.status),
    ])
  any_search_req(params, "CoverageEligibilityResponse", client)
}

pub fn detectedissue_search_req(sp: SpDetectedissue, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("code", sp.code),
      #("identified", sp.identified),
      #("author", sp.author),
      #("subject", sp.subject),
      #("patient", sp.patient),
      #("implicated", sp.implicated),
      #("category", sp.category),
      #("status", sp.status),
    ])
  any_search_req(params, "DetectedIssue", client)
}

pub fn device_search_req(sp: SpDevice, client: FhirClient) {
  let params =
    using_params([
      #("udi-di", sp.udi_di),
      #("identifier", sp.identifier),
      #("parent", sp.parent),
      #("manufacture-date", sp.manufacture_date),
      #("udi-carrier", sp.udi_carrier),
      #("code", sp.code),
      #("device-name", sp.device_name),
      #("lot-number", sp.lot_number),
      #("serial-number", sp.serial_number),
      #("specification", sp.specification),
      #("type", sp.type_),
      #("version", sp.version),
      #("url", sp.url),
      #("manufacturer", sp.manufacturer),
      #("code-value-concept", sp.code_value_concept),
      #("organization", sp.organization),
      #("biological-source-event", sp.biological_source_event),
      #("definition", sp.definition),
      #("location", sp.location),
      #("model", sp.model),
      #("expiration-date", sp.expiration_date),
      #("specification-version", sp.specification_version),
      #("status", sp.status),
    ])
  any_search_req(params, "Device", client)
}

pub fn deviceassociation_search_req(sp: SpDeviceassociation, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("subject", sp.subject),
      #("patient", sp.patient),
      #("device", sp.device),
      #("operator", sp.operator),
      #("status", sp.status),
    ])
  any_search_req(params, "DeviceAssociation", client)
}

pub fn devicedefinition_search_req(sp: SpDevicedefinition, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("device-name", sp.device_name),
      #("organization", sp.organization),
      #("specification", sp.specification),
      #("type", sp.type_),
      #("specification-version", sp.specification_version),
      #("manufacturer", sp.manufacturer),
    ])
  any_search_req(params, "DeviceDefinition", client)
}

pub fn devicedispense_search_req(sp: SpDevicedispense, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("code", sp.code),
      #("subject", sp.subject),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "DeviceDispense", client)
}

pub fn devicemetric_search_req(sp: SpDevicemetric, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("category", sp.category),
      #("type", sp.type_),
      #("device", sp.device),
    ])
  any_search_req(params, "DeviceMetric", client)
}

pub fn devicerequest_search_req(sp: SpDevicerequest, client: FhirClient) {
  let params =
    using_params([
      #("insurance", sp.insurance),
      #("performer-code", sp.performer_code),
      #("requester", sp.requester),
      #("identifier", sp.identifier),
      #("code", sp.code),
      #("performer", sp.performer),
      #("event-date", sp.event_date),
      #("subject", sp.subject),
      #("instantiates-canonical", sp.instantiates_canonical),
      #("encounter", sp.encounter),
      #("authored-on", sp.authored_on),
      #("intent", sp.intent),
      #("group-identifier", sp.group_identifier),
      #("based-on", sp.based_on),
      #("patient", sp.patient),
      #("instantiates-uri", sp.instantiates_uri),
      #("device", sp.device),
      #("prior-request", sp.prior_request),
      #("status", sp.status),
    ])
  any_search_req(params, "DeviceRequest", client)
}

pub fn deviceusage_search_req(sp: SpDeviceusage, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("patient", sp.patient),
      #("device", sp.device),
      #("status", sp.status),
    ])
  any_search_req(params, "DeviceUsage", client)
}

pub fn diagnosticreport_search_req(sp: SpDiagnosticreport, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("study", sp.study),
      #("code", sp.code),
      #("performer", sp.performer),
      #("subject", sp.subject),
      #("encounter", sp.encounter),
      #("media", sp.media),
      #("conclusion", sp.conclusion),
      #("result", sp.result),
      #("based-on", sp.based_on),
      #("patient", sp.patient),
      #("specimen", sp.specimen),
      #("category", sp.category),
      #("issued", sp.issued),
      #("results-interpreter", sp.results_interpreter),
      #("status", sp.status),
    ])
  any_search_req(params, "DiagnosticReport", client)
}

pub fn documentreference_search_req(sp: SpDocumentreference, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("modality", sp.modality),
      #("subject", sp.subject),
      #("description", sp.description),
      #("language", sp.language),
      #("type", sp.type_),
      #("relation", sp.relation),
      #("setting", sp.setting),
      #("doc-status", sp.doc_status),
      #("based-on", sp.based_on),
      #("format-canonical", sp.format_canonical),
      #("patient", sp.patient),
      #("context", sp.context),
      #("relationship", sp.relationship),
      #("creation", sp.creation),
      #("identifier", sp.identifier),
      #("period", sp.period),
      #("event-code", sp.event_code),
      #("bodysite", sp.bodysite),
      #("custodian", sp.custodian),
      #("author", sp.author),
      #("format-code", sp.format_code),
      #("bodysite-reference", sp.bodysite_reference),
      #("format-uri", sp.format_uri),
      #("version", sp.version),
      #("attester", sp.attester),
      #("contenttype", sp.contenttype),
      #("event-reference", sp.event_reference),
      #("security-label", sp.security_label),
      #("location", sp.location),
      #("category", sp.category),
      #("relatesto", sp.relatesto),
      #("facility", sp.facility),
      #("status", sp.status),
    ])
  any_search_req(params, "DocumentReference", client)
}

pub fn encounter_search_req(sp: SpEncounter, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("participant-type", sp.participant_type),
      #("subject", sp.subject),
      #("subject-status", sp.subject_status),
      #("appointment", sp.appointment),
      #("part-of", sp.part_of),
      #("type", sp.type_),
      #("participant", sp.participant),
      #("reason-code", sp.reason_code),
      #("based-on", sp.based_on),
      #("date-start", sp.date_start),
      #("patient", sp.patient),
      #("location-period", sp.location_period),
      #("special-arrangement", sp.special_arrangement),
      #("class", sp.class),
      #("identifier", sp.identifier),
      #("diagnosis-code", sp.diagnosis_code),
      #("practitioner", sp.practitioner),
      #("episode-of-care", sp.episode_of_care),
      #("length", sp.length),
      #("careteam", sp.careteam),
      #("end-date", sp.end_date),
      #("diagnosis-reference", sp.diagnosis_reference),
      #("reason-reference", sp.reason_reference),
      #("location", sp.location),
      #("service-provider", sp.service_provider),
      #("account", sp.account),
      #("status", sp.status),
    ])
  any_search_req(params, "Encounter", client)
}

pub fn encounterhistory_search_req(sp: SpEncounterhistory, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("patient", sp.patient),
      #("subject", sp.subject),
      #("encounter", sp.encounter),
      #("status", sp.status),
    ])
  any_search_req(params, "EncounterHistory", client)
}

pub fn endpoint_search_req(sp: SpEndpoint, client: FhirClient) {
  let params =
    using_params([
      #("payload-type", sp.payload_type),
      #("identifier", sp.identifier),
      #("connection-type", sp.connection_type),
      #("organization", sp.organization),
      #("name", sp.name),
      #("status", sp.status),
    ])
  any_search_req(params, "Endpoint", client)
}

pub fn enrollmentrequest_search_req(sp: SpEnrollmentrequest, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("patient", sp.patient),
      #("subject", sp.subject),
      #("status", sp.status),
    ])
  any_search_req(params, "EnrollmentRequest", client)
}

pub fn enrollmentresponse_search_req(
  sp: SpEnrollmentresponse,
  client: FhirClient,
) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("request", sp.request),
      #("status", sp.status),
    ])
  any_search_req(params, "EnrollmentResponse", client)
}

pub fn episodeofcare_search_req(sp: SpEpisodeofcare, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("diagnosis-code", sp.diagnosis_code),
      #("diagnosis-reference", sp.diagnosis_reference),
      #("patient", sp.patient),
      #("organization", sp.organization),
      #("reason-reference", sp.reason_reference),
      #("type", sp.type_),
      #("care-manager", sp.care_manager),
      #("reason-code", sp.reason_code),
      #("incoming-referral", sp.incoming_referral),
      #("status", sp.status),
    ])
  any_search_req(params, "EpisodeOfCare", client)
}

pub fn eventdefinition_search_req(sp: SpEventdefinition, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("successor", sp.successor),
      #("context-type-value", sp.context_type_value),
      #("jurisdiction", sp.jurisdiction),
      #("derived-from", sp.derived_from),
      #("description", sp.description),
      #("context-type", sp.context_type),
      #("predecessor", sp.predecessor),
      #("composed-of", sp.composed_of),
      #("title", sp.title),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("depends-on", sp.depends_on),
      #("effective", sp.effective),
      #("context", sp.context),
      #("name", sp.name),
      #("publisher", sp.publisher),
      #("topic", sp.topic),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "EventDefinition", client)
}

pub fn evidence_search_req(sp: SpEvidence, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("context-type-value", sp.context_type_value),
      #("description", sp.description),
      #("context-type", sp.context_type),
      #("title", sp.title),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("context", sp.context),
      #("publisher", sp.publisher),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "Evidence", client)
}

pub fn evidencereport_search_req(sp: SpEvidencereport, client: FhirClient) {
  let params =
    using_params([
      #("context-quantity", sp.context_quantity),
      #("identifier", sp.identifier),
      #("context-type-value", sp.context_type_value),
      #("context", sp.context),
      #("publisher", sp.publisher),
      #("context-type", sp.context_type),
      #("context-type-quantity", sp.context_type_quantity),
      #("url", sp.url),
      #("status", sp.status),
    ])
  any_search_req(params, "EvidenceReport", client)
}

pub fn evidencevariable_search_req(sp: SpEvidencevariable, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("successor", sp.successor),
      #("context-type-value", sp.context_type_value),
      #("derived-from", sp.derived_from),
      #("description", sp.description),
      #("context-type", sp.context_type),
      #("predecessor", sp.predecessor),
      #("composed-of", sp.composed_of),
      #("title", sp.title),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("depends-on", sp.depends_on),
      #("context", sp.context),
      #("name", sp.name),
      #("publisher", sp.publisher),
      #("topic", sp.topic),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "EvidenceVariable", client)
}

pub fn examplescenario_search_req(sp: SpExamplescenario, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("context-type-value", sp.context_type_value),
      #("jurisdiction", sp.jurisdiction),
      #("context-type", sp.context_type),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("context", sp.context),
      #("name", sp.name),
      #("publisher", sp.publisher),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "ExampleScenario", client)
}

pub fn explanationofbenefit_search_req(
  sp: SpExplanationofbenefit,
  client: FhirClient,
) {
  let params =
    using_params([
      #("care-team", sp.care_team),
      #("coverage", sp.coverage),
      #("identifier", sp.identifier),
      #("created", sp.created),
      #("encounter", sp.encounter),
      #("payee", sp.payee),
      #("disposition", sp.disposition),
      #("provider", sp.provider),
      #("patient", sp.patient),
      #("detail-udi", sp.detail_udi),
      #("claim", sp.claim),
      #("enterer", sp.enterer),
      #("procedure-udi", sp.procedure_udi),
      #("subdetail-udi", sp.subdetail_udi),
      #("facility", sp.facility),
      #("item-udi", sp.item_udi),
      #("status", sp.status),
    ])
  any_search_req(params, "ExplanationOfBenefit", client)
}

pub fn familymemberhistory_search_req(
  sp: SpFamilymemberhistory,
  client: FhirClient,
) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("code", sp.code),
      #("patient", sp.patient),
      #("sex", sp.sex),
      #("instantiates-canonical", sp.instantiates_canonical),
      #("instantiates-uri", sp.instantiates_uri),
      #("relationship", sp.relationship),
      #("status", sp.status),
    ])
  any_search_req(params, "FamilyMemberHistory", client)
}

pub fn flag_search_req(sp: SpFlag, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("author", sp.author),
      #("patient", sp.patient),
      #("subject", sp.subject),
      #("encounter", sp.encounter),
      #("category", sp.category),
      #("status", sp.status),
    ])
  any_search_req(params, "Flag", client)
}

pub fn formularyitem_search_req(sp: SpFormularyitem, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("code", sp.code),
    ])
  any_search_req(params, "FormularyItem", client)
}

pub fn genomicstudy_search_req(sp: SpGenomicstudy, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("patient", sp.patient),
      #("subject", sp.subject),
      #("focus", sp.focus),
      #("status", sp.status),
    ])
  any_search_req(params, "GenomicStudy", client)
}

pub fn goal_search_req(sp: SpGoal, client: FhirClient) {
  let params =
    using_params([
      #("target-measure", sp.target_measure),
      #("identifier", sp.identifier),
      #("addresses", sp.addresses),
      #("lifecycle-status", sp.lifecycle_status),
      #("achievement-status", sp.achievement_status),
      #("patient", sp.patient),
      #("subject", sp.subject),
      #("description", sp.description),
      #("start-date", sp.start_date),
      #("category", sp.category),
      #("target-date", sp.target_date),
    ])
  any_search_req(params, "Goal", client)
}

pub fn graphdefinition_search_req(sp: SpGraphdefinition, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("context-type-value", sp.context_type_value),
      #("jurisdiction", sp.jurisdiction),
      #("start", sp.start),
      #("description", sp.description),
      #("context-type", sp.context_type),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("context", sp.context),
      #("name", sp.name),
      #("publisher", sp.publisher),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "GraphDefinition", client)
}

pub fn group_search_req(sp: SpGroup, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("characteristic-value", sp.characteristic_value),
      #("managing-entity", sp.managing_entity),
      #("code", sp.code),
      #("member", sp.member),
      #("name", sp.name),
      #("exclude", sp.exclude),
      #("membership", sp.membership),
      #("type", sp.type_),
      #("characteristic-reference", sp.characteristic_reference),
      #("value", sp.value),
      #("characteristic", sp.characteristic),
    ])
  any_search_req(params, "Group", client)
}

pub fn guidanceresponse_search_req(sp: SpGuidanceresponse, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("request", sp.request),
      #("patient", sp.patient),
      #("subject", sp.subject),
      #("status", sp.status),
    ])
  any_search_req(params, "GuidanceResponse", client)
}

pub fn healthcareservice_search_req(sp: SpHealthcareservice, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("specialty", sp.specialty),
      #("service-category", sp.service_category),
      #("service-type", sp.service_type),
      #("active", sp.active),
      #("eligibility", sp.eligibility),
      #("program", sp.program),
      #("characteristic", sp.characteristic),
      #("endpoint", sp.endpoint),
      #("coverage-area", sp.coverage_area),
      #("organization", sp.organization),
      #("offered-in", sp.offered_in),
      #("name", sp.name),
      #("location", sp.location),
      #("communication", sp.communication),
    ])
  any_search_req(params, "HealthcareService", client)
}

pub fn imagingselection_search_req(sp: SpImagingselection, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("body-structure", sp.body_structure),
      #("based-on", sp.based_on),
      #("code", sp.code),
      #("subject", sp.subject),
      #("patient", sp.patient),
      #("derived-from", sp.derived_from),
      #("issued", sp.issued),
      #("body-site", sp.body_site),
      #("study-uid", sp.study_uid),
      #("status", sp.status),
    ])
  any_search_req(params, "ImagingSelection", client)
}

pub fn imagingstudy_search_req(sp: SpImagingstudy, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("reason", sp.reason),
      #("dicom-class", sp.dicom_class),
      #("instance", sp.instance),
      #("modality", sp.modality),
      #("performer", sp.performer),
      #("subject", sp.subject),
      #("started", sp.started),
      #("encounter", sp.encounter),
      #("referrer", sp.referrer),
      #("body-structure", sp.body_structure),
      #("endpoint", sp.endpoint),
      #("based-on", sp.based_on),
      #("patient", sp.patient),
      #("series", sp.series),
      #("body-site", sp.body_site),
      #("status", sp.status),
    ])
  any_search_req(params, "ImagingStudy", client)
}

pub fn immunization_search_req(sp: SpImmunization, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("performer", sp.performer),
      #("reaction", sp.reaction),
      #("lot-number", sp.lot_number),
      #("status-reason", sp.status_reason),
      #("reason-code", sp.reason_code),
      #("manufacturer", sp.manufacturer),
      #("target-disease", sp.target_disease),
      #("patient", sp.patient),
      #("series", sp.series),
      #("vaccine-code", sp.vaccine_code),
      #("reason-reference", sp.reason_reference),
      #("location", sp.location),
      #("reaction-date", sp.reaction_date),
      #("status", sp.status),
    ])
  any_search_req(params, "Immunization", client)
}

pub fn immunizationevaluation_search_req(
  sp: SpImmunizationevaluation,
  client: FhirClient,
) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("target-disease", sp.target_disease),
      #("patient", sp.patient),
      #("dose-status", sp.dose_status),
      #("immunization-event", sp.immunization_event),
      #("status", sp.status),
    ])
  any_search_req(params, "ImmunizationEvaluation", client)
}

pub fn immunizationrecommendation_search_req(
  sp: SpImmunizationrecommendation,
  client: FhirClient,
) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("target-disease", sp.target_disease),
      #("patient", sp.patient),
      #("vaccine-type", sp.vaccine_type),
      #("information", sp.information),
      #("support", sp.support),
      #("status", sp.status),
    ])
  any_search_req(params, "ImmunizationRecommendation", client)
}

pub fn implementationguide_search_req(
  sp: SpImplementationguide,
  client: FhirClient,
) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("context-type-value", sp.context_type_value),
      #("resource", sp.resource),
      #("jurisdiction", sp.jurisdiction),
      #("description", sp.description),
      #("context-type", sp.context_type),
      #("experimental", sp.experimental),
      #("global", sp.global),
      #("title", sp.title),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("depends-on", sp.depends_on),
      #("context", sp.context),
      #("name", sp.name),
      #("publisher", sp.publisher),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "ImplementationGuide", client)
}

pub fn ingredient_search_req(sp: SpIngredient, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("role", sp.role),
      #("substance", sp.substance),
      #("strength-concentration-ratio", sp.strength_concentration_ratio),
      #("for", sp.for),
      #("substance-code", sp.substance_code),
      #("strength-concentration-quantity", sp.strength_concentration_quantity),
      #("manufacturer", sp.manufacturer),
      #("substance-definition", sp.substance_definition),
      #("function", sp.function),
      #("strength-presentation-ratio", sp.strength_presentation_ratio),
      #("strength-presentation-quantity", sp.strength_presentation_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "Ingredient", client)
}

pub fn insuranceplan_search_req(sp: SpInsuranceplan, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("address", sp.address),
      #("address-state", sp.address_state),
      #("owned-by", sp.owned_by),
      #("type", sp.type_),
      #("address-postalcode", sp.address_postalcode),
      #("address-country", sp.address_country),
      #("administered-by", sp.administered_by),
      #("endpoint", sp.endpoint),
      #("phonetic", sp.phonetic),
      #("address-use", sp.address_use),
      #("name", sp.name),
      #("address-city", sp.address_city),
      #("status", sp.status),
    ])
  any_search_req(params, "InsurancePlan", client)
}

pub fn inventoryitem_search_req(sp: SpInventoryitem, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("code", sp.code),
      #("subject", sp.subject),
      #("status", sp.status),
    ])
  any_search_req(params, "InventoryItem", client)
}

pub fn inventoryreport_search_req(sp: SpInventoryreport, client: FhirClient) {
  let params =
    using_params([
      #("item-reference", sp.item_reference),
      #("identifier", sp.identifier),
      #("item", sp.item),
      #("status", sp.status),
    ])
  any_search_req(params, "InventoryReport", client)
}

pub fn invoice_search_req(sp: SpInvoice, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("totalgross", sp.totalgross),
      #("participant-role", sp.participant_role),
      #("subject", sp.subject),
      #("type", sp.type_),
      #("issuer", sp.issuer),
      #("participant", sp.participant),
      #("totalnet", sp.totalnet),
      #("patient", sp.patient),
      #("recipient", sp.recipient),
      #("account", sp.account),
      #("status", sp.status),
    ])
  any_search_req(params, "Invoice", client)
}

pub fn library_search_req(sp: SpLibrary, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("successor", sp.successor),
      #("context-type-value", sp.context_type_value),
      #("jurisdiction", sp.jurisdiction),
      #("derived-from", sp.derived_from),
      #("description", sp.description),
      #("context-type", sp.context_type),
      #("predecessor", sp.predecessor),
      #("composed-of", sp.composed_of),
      #("title", sp.title),
      #("type", sp.type_),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("depends-on", sp.depends_on),
      #("effective", sp.effective),
      #("context", sp.context),
      #("name", sp.name),
      #("publisher", sp.publisher),
      #("topic", sp.topic),
      #("content-type", sp.content_type),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "Library", client)
}

pub fn linkage_search_req(sp: SpLinkage, client: FhirClient) {
  let params =
    using_params([
      #("item", sp.item),
      #("author", sp.author),
      #("source", sp.source),
    ])
  any_search_req(params, "Linkage", client)
}

pub fn listfhir_search_req(sp: SpListfhir, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("empty-reason", sp.empty_reason),
      #("item", sp.item),
      #("code", sp.code),
      #("notes", sp.notes),
      #("patient", sp.patient),
      #("subject", sp.subject),
      #("encounter", sp.encounter),
      #("source", sp.source),
      #("title", sp.title),
      #("status", sp.status),
    ])
  any_search_req(params, "List", client)
}

pub fn location_search_req(sp: SpLocation, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("partof", sp.partof),
      #("address", sp.address),
      #("address-state", sp.address_state),
      #("operational-status", sp.operational_status),
      #("type", sp.type_),
      #("address-postalcode", sp.address_postalcode),
      #("characteristic", sp.characteristic),
      #("address-country", sp.address_country),
      #("endpoint", sp.endpoint),
      #("contains", sp.contains),
      #("organization", sp.organization),
      #("address-use", sp.address_use),
      #("name", sp.name),
      #("near", sp.near),
      #("address-city", sp.address_city),
      #("status", sp.status),
    ])
  any_search_req(params, "Location", client)
}

pub fn manufactureditemdefinition_search_req(
  sp: SpManufactureditemdefinition,
  client: FhirClient,
) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("ingredient", sp.ingredient),
      #("name", sp.name),
      #("dose-form", sp.dose_form),
      #("status", sp.status),
    ])
  any_search_req(params, "ManufacturedItemDefinition", client)
}

pub fn measure_search_req(sp: SpMeasure, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("successor", sp.successor),
      #("context-type-value", sp.context_type_value),
      #("jurisdiction", sp.jurisdiction),
      #("derived-from", sp.derived_from),
      #("description", sp.description),
      #("context-type", sp.context_type),
      #("predecessor", sp.predecessor),
      #("composed-of", sp.composed_of),
      #("title", sp.title),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("depends-on", sp.depends_on),
      #("effective", sp.effective),
      #("context", sp.context),
      #("name", sp.name),
      #("publisher", sp.publisher),
      #("topic", sp.topic),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "Measure", client)
}

pub fn measurereport_search_req(sp: SpMeasurereport, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("period", sp.period),
      #("measure", sp.measure),
      #("patient", sp.patient),
      #("subject", sp.subject),
      #("reporter", sp.reporter),
      #("location", sp.location),
      #("evaluated-resource", sp.evaluated_resource),
      #("status", sp.status),
    ])
  any_search_req(params, "MeasureReport", client)
}

pub fn medication_search_req(sp: SpMedication, client: FhirClient) {
  let params =
    using_params([
      #("ingredient-code", sp.ingredient_code),
      #("identifier", sp.identifier),
      #("code", sp.code),
      #("ingredient", sp.ingredient),
      #("form", sp.form),
      #("lot-number", sp.lot_number),
      #("serial-number", sp.serial_number),
      #("expiration-date", sp.expiration_date),
      #("marketingauthorizationholder", sp.marketingauthorizationholder),
      #("status", sp.status),
    ])
  any_search_req(params, "Medication", client)
}

pub fn medicationadministration_search_req(
  sp: SpMedicationadministration,
  client: FhirClient,
) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("request", sp.request),
      #("code", sp.code),
      #("performer", sp.performer),
      #("performer-device-code", sp.performer_device_code),
      #("subject", sp.subject),
      #("medication", sp.medication),
      #("reason-given", sp.reason_given),
      #("encounter", sp.encounter),
      #("reason-given-code", sp.reason_given_code),
      #("patient", sp.patient),
      #("reason-not-given", sp.reason_not_given),
      #("device", sp.device),
      #("status", sp.status),
    ])
  any_search_req(params, "MedicationAdministration", client)
}

pub fn medicationdispense_search_req(
  sp: SpMedicationdispense,
  client: FhirClient,
) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("code", sp.code),
      #("performer", sp.performer),
      #("receiver", sp.receiver),
      #("subject", sp.subject),
      #("destination", sp.destination),
      #("medication", sp.medication),
      #("responsibleparty", sp.responsibleparty),
      #("encounter", sp.encounter),
      #("type", sp.type_),
      #("recorded", sp.recorded),
      #("whenhandedover", sp.whenhandedover),
      #("whenprepared", sp.whenprepared),
      #("prescription", sp.prescription),
      #("patient", sp.patient),
      #("location", sp.location),
      #("status", sp.status),
    ])
  any_search_req(params, "MedicationDispense", client)
}

pub fn medicationknowledge_search_req(
  sp: SpMedicationknowledge,
  client: FhirClient,
) {
  let params =
    using_params([
      #("product-type", sp.product_type),
      #("identifier", sp.identifier),
      #("code", sp.code),
      #("ingredient", sp.ingredient),
      #("doseform", sp.doseform),
      #("classification-type", sp.classification_type),
      #("monograph-type", sp.monograph_type),
      #("classification", sp.classification),
      #("ingredient-code", sp.ingredient_code),
      #("packaging-cost-concept", sp.packaging_cost_concept),
      #("source-cost", sp.source_cost),
      #("monitoring-program-name", sp.monitoring_program_name),
      #("monograph", sp.monograph),
      #("monitoring-program-type", sp.monitoring_program_type),
      #("packaging-cost", sp.packaging_cost),
      #("status", sp.status),
    ])
  any_search_req(params, "MedicationKnowledge", client)
}

pub fn medicationrequest_search_req(sp: SpMedicationrequest, client: FhirClient) {
  let params =
    using_params([
      #("requester", sp.requester),
      #("identifier", sp.identifier),
      #("intended-dispenser", sp.intended_dispenser),
      #("authoredon", sp.authoredon),
      #("code", sp.code),
      #("combo-date", sp.combo_date),
      #("subject", sp.subject),
      #("medication", sp.medication),
      #("encounter", sp.encounter),
      #("priority", sp.priority),
      #("intent", sp.intent),
      #("group-identifier", sp.group_identifier),
      #("intended-performer", sp.intended_performer),
      #("patient", sp.patient),
      #("intended-performertype", sp.intended_performertype),
      #("category", sp.category),
      #("status", sp.status),
    ])
  any_search_req(params, "MedicationRequest", client)
}

pub fn medicationstatement_search_req(
  sp: SpMedicationstatement,
  client: FhirClient,
) {
  let params =
    using_params([
      #("effective", sp.effective),
      #("identifier", sp.identifier),
      #("code", sp.code),
      #("adherence", sp.adherence),
      #("patient", sp.patient),
      #("subject", sp.subject),
      #("medication", sp.medication),
      #("encounter", sp.encounter),
      #("source", sp.source),
      #("category", sp.category),
      #("status", sp.status),
    ])
  any_search_req(params, "MedicationStatement", client)
}

pub fn medicinalproductdefinition_search_req(
  sp: SpMedicinalproductdefinition,
  client: FhirClient,
) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("ingredient", sp.ingredient),
      #("master-file", sp.master_file),
      #("contact", sp.contact),
      #("domain", sp.domain),
      #("name", sp.name),
      #("name-language", sp.name_language),
      #("type", sp.type_),
      #("characteristic", sp.characteristic),
      #("characteristic-type", sp.characteristic_type),
      #("product-classification", sp.product_classification),
      #("status", sp.status),
    ])
  any_search_req(params, "MedicinalProductDefinition", client)
}

pub fn messagedefinition_search_req(sp: SpMessagedefinition, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("parent", sp.parent),
      #("context-type-value", sp.context_type_value),
      #("jurisdiction", sp.jurisdiction),
      #("description", sp.description),
      #("focus", sp.focus),
      #("context-type", sp.context_type),
      #("title", sp.title),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("context", sp.context),
      #("name", sp.name),
      #("publisher", sp.publisher),
      #("category", sp.category),
      #("event", sp.event),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "MessageDefinition", client)
}

pub fn messageheader_search_req(sp: SpMessageheader, client: FhirClient) {
  let params =
    using_params([
      #("code", sp.code),
      #("receiver", sp.receiver),
      #("sender", sp.sender),
      #("author", sp.author),
      #("responsible", sp.responsible),
      #("destination", sp.destination),
      #("focus", sp.focus),
      #("response-id", sp.response_id),
      #("source", sp.source),
      #("event", sp.event),
      #("target", sp.target),
    ])
  any_search_req(params, "MessageHeader", client)
}

pub fn molecularsequence_search_req(sp: SpMolecularsequence, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("subject", sp.subject),
      #("patient", sp.patient),
      #("focus", sp.focus),
      #("type", sp.type_),
    ])
  any_search_req(params, "MolecularSequence", client)
}

pub fn namingsystem_search_req(sp: SpNamingsystem, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("context-type-value", sp.context_type_value),
      #("jurisdiction", sp.jurisdiction),
      #("description", sp.description),
      #("derived-from", sp.derived_from),
      #("context-type", sp.context_type),
      #("predecessor", sp.predecessor),
      #("type", sp.type_),
      #("context-quantity", sp.context_quantity),
      #("effective", sp.effective),
      #("contact", sp.contact),
      #("responsible", sp.responsible),
      #("context", sp.context),
      #("telecom", sp.telecom),
      #("value", sp.value),
      #("context-type-quantity", sp.context_type_quantity),
      #("identifier", sp.identifier),
      #("period", sp.period),
      #("kind", sp.kind),
      #("version", sp.version),
      #("url", sp.url),
      #("id-type", sp.id_type),
      #("name", sp.name),
      #("publisher", sp.publisher),
      #("topic", sp.topic),
      #("status", sp.status),
    ])
  any_search_req(params, "NamingSystem", client)
}

pub fn nutritionintake_search_req(sp: SpNutritionintake, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("nutrition", sp.nutrition),
      #("code", sp.code),
      #("patient", sp.patient),
      #("subject", sp.subject),
      #("encounter", sp.encounter),
      #("source", sp.source),
      #("status", sp.status),
    ])
  any_search_req(params, "NutritionIntake", client)
}

pub fn nutritionorder_search_req(sp: SpNutritionorder, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("group-identifier", sp.group_identifier),
      #("datetime", sp.datetime),
      #("provider", sp.provider),
      #("subject", sp.subject),
      #("patient", sp.patient),
      #("supplement", sp.supplement),
      #("formula", sp.formula),
      #("encounter", sp.encounter),
      #("oraldiet", sp.oraldiet),
      #("additive", sp.additive),
      #("status", sp.status),
    ])
  any_search_req(params, "NutritionOrder", client)
}

pub fn nutritionproduct_search_req(sp: SpNutritionproduct, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("code", sp.code),
      #("lot-number", sp.lot_number),
      #("serial-number", sp.serial_number),
      #("status", sp.status),
    ])
  any_search_req(params, "NutritionProduct", client)
}

pub fn observation_search_req(sp: SpObservation, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("combo-data-absent-reason", sp.combo_data_absent_reason),
      #("code", sp.code),
      #("combo-code-value-quantity", sp.combo_code_value_quantity),
      #("component-data-absent-reason", sp.component_data_absent_reason),
      #("subject", sp.subject),
      #("value-concept", sp.value_concept),
      #("value-date", sp.value_date),
      #("derived-from", sp.derived_from),
      #("focus", sp.focus),
      #("part-of", sp.part_of),
      #("component-value-canonical", sp.component_value_canonical),
      #("has-member", sp.has_member),
      #("value-reference", sp.value_reference),
      #("code-value-string", sp.code_value_string),
      #("component-code-value-quantity", sp.component_code_value_quantity),
      #("based-on", sp.based_on),
      #("code-value-date", sp.code_value_date),
      #("patient", sp.patient),
      #("specimen", sp.specimen),
      #("code-value-quantity", sp.code_value_quantity),
      #("component-code", sp.component_code),
      #("value-markdown", sp.value_markdown),
      #("combo-code-value-concept", sp.combo_code_value_concept),
      #("identifier", sp.identifier),
      #("component-value-reference", sp.component_value_reference),
      #("performer", sp.performer),
      #("combo-code", sp.combo_code),
      #("method", sp.method),
      #("value-quantity", sp.value_quantity),
      #("component-value-quantity", sp.component_value_quantity),
      #("data-absent-reason", sp.data_absent_reason),
      #("combo-value-quantity", sp.combo_value_quantity),
      #("encounter", sp.encounter),
      #("code-value-concept", sp.code_value_concept),
      #("component-code-value-concept", sp.component_code_value_concept),
      #("component-value-concept", sp.component_value_concept),
      #("category", sp.category),
      #("device", sp.device),
      #("combo-value-concept", sp.combo_value_concept),
      #("value-canonical", sp.value_canonical),
      #("status", sp.status),
    ])
  any_search_req(params, "Observation", client)
}

pub fn observationdefinition_search_req(
  sp: SpObservationdefinition,
  client: FhirClient,
) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("code", sp.code),
      #("method", sp.method),
      #("experimental", sp.experimental),
      #("category", sp.category),
      #("title", sp.title),
      #("url", sp.url),
      #("status", sp.status),
    ])
  any_search_req(params, "ObservationDefinition", client)
}

pub fn operationdefinition_search_req(
  sp: SpOperationdefinition,
  client: FhirClient,
) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("code", sp.code),
      #("instance", sp.instance),
      #("context-type-value", sp.context_type_value),
      #("kind", sp.kind),
      #("jurisdiction", sp.jurisdiction),
      #("description", sp.description),
      #("context-type", sp.context_type),
      #("title", sp.title),
      #("type", sp.type_),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("input-profile", sp.input_profile),
      #("output-profile", sp.output_profile),
      #("system", sp.system),
      #("context", sp.context),
      #("name", sp.name),
      #("publisher", sp.publisher),
      #("context-type-quantity", sp.context_type_quantity),
      #("base", sp.base),
      #("status", sp.status),
    ])
  any_search_req(params, "OperationDefinition", client)
}

pub fn operationoutcome_search_req(_sp: SpOperationoutcome, client: FhirClient) {
  let params = using_params([])
  any_search_req(params, "OperationOutcome", client)
}

pub fn organization_search_req(sp: SpOrganization, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("partof", sp.partof),
      #("address", sp.address),
      #("address-state", sp.address_state),
      #("active", sp.active),
      #("type", sp.type_),
      #("address-postalcode", sp.address_postalcode),
      #("address-country", sp.address_country),
      #("endpoint", sp.endpoint),
      #("phonetic", sp.phonetic),
      #("address-use", sp.address_use),
      #("name", sp.name),
      #("address-city", sp.address_city),
    ])
  any_search_req(params, "Organization", client)
}

pub fn organizationaffiliation_search_req(
  sp: SpOrganizationaffiliation,
  client: FhirClient,
) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("specialty", sp.specialty),
      #("role", sp.role),
      #("active", sp.active),
      #("primary-organization", sp.primary_organization),
      #("network", sp.network),
      #("endpoint", sp.endpoint),
      #("phone", sp.phone),
      #("service", sp.service),
      #("participating-organization", sp.participating_organization),
      #("location", sp.location),
      #("telecom", sp.telecom),
      #("email", sp.email),
    ])
  any_search_req(params, "OrganizationAffiliation", client)
}

pub fn packagedproductdefinition_search_req(
  sp: SpPackagedproductdefinition,
  client: FhirClient,
) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("manufactured-item", sp.manufactured_item),
      #("nutrition", sp.nutrition),
      #("package", sp.package),
      #("name", sp.name),
      #("biological", sp.biological),
      #("package-for", sp.package_for),
      #("contained-item", sp.contained_item),
      #("medication", sp.medication),
      #("device", sp.device),
      #("status", sp.status),
    ])
  any_search_req(params, "PackagedProductDefinition", client)
}

pub fn patient_search_req(sp: SpPatient, client: FhirClient) {
  let params =
    using_params([
      #("given", sp.given),
      #("identifier", sp.identifier),
      #("address", sp.address),
      #("birthdate", sp.birthdate),
      #("deceased", sp.deceased),
      #("address-state", sp.address_state),
      #("gender", sp.gender),
      #("general-practitioner", sp.general_practitioner),
      #("link", sp.link),
      #("active", sp.active),
      #("language", sp.language),
      #("address-postalcode", sp.address_postalcode),
      #("address-country", sp.address_country),
      #("death-date", sp.death_date),
      #("phonetic", sp.phonetic),
      #("phone", sp.phone),
      #("organization", sp.organization),
      #("address-use", sp.address_use),
      #("name", sp.name),
      #("telecom", sp.telecom),
      #("address-city", sp.address_city),
      #("family", sp.family),
      #("email", sp.email),
    ])
  any_search_req(params, "Patient", client)
}

pub fn paymentnotice_search_req(sp: SpPaymentnotice, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("request", sp.request),
      #("created", sp.created),
      #("response", sp.response),
      #("reporter", sp.reporter),
      #("payment-status", sp.payment_status),
      #("status", sp.status),
    ])
  any_search_req(params, "PaymentNotice", client)
}

pub fn paymentreconciliation_search_req(
  sp: SpPaymentreconciliation,
  client: FhirClient,
) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("request", sp.request),
      #("disposition", sp.disposition),
      #("created", sp.created),
      #("allocation-encounter", sp.allocation_encounter),
      #("allocation-account", sp.allocation_account),
      #("outcome", sp.outcome),
      #("payment-issuer", sp.payment_issuer),
      #("requestor", sp.requestor),
      #("status", sp.status),
    ])
  any_search_req(params, "PaymentReconciliation", client)
}

pub fn permission_search_req(sp: SpPermission, client: FhirClient) {
  let params =
    using_params([
      #("status", sp.status),
    ])
  any_search_req(params, "Permission", client)
}

pub fn person_search_req(sp: SpPerson, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("given", sp.given),
      #("address", sp.address),
      #("birthdate", sp.birthdate),
      #("deceased", sp.deceased),
      #("address-state", sp.address_state),
      #("gender", sp.gender),
      #("practitioner", sp.practitioner),
      #("link", sp.link),
      #("relatedperson", sp.relatedperson),
      #("address-postalcode", sp.address_postalcode),
      #("address-country", sp.address_country),
      #("death-date", sp.death_date),
      #("phonetic", sp.phonetic),
      #("phone", sp.phone),
      #("patient", sp.patient),
      #("organization", sp.organization),
      #("address-use", sp.address_use),
      #("name", sp.name),
      #("telecom", sp.telecom),
      #("address-city", sp.address_city),
      #("family", sp.family),
      #("email", sp.email),
    ])
  any_search_req(params, "Person", client)
}

pub fn plandefinition_search_req(sp: SpPlandefinition, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("successor", sp.successor),
      #("context-type-value", sp.context_type_value),
      #("jurisdiction", sp.jurisdiction),
      #("derived-from", sp.derived_from),
      #("description", sp.description),
      #("context-type", sp.context_type),
      #("predecessor", sp.predecessor),
      #("composed-of", sp.composed_of),
      #("title", sp.title),
      #("type", sp.type_),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("depends-on", sp.depends_on),
      #("effective", sp.effective),
      #("context", sp.context),
      #("name", sp.name),
      #("publisher", sp.publisher),
      #("topic", sp.topic),
      #("definition", sp.definition),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "PlanDefinition", client)
}

pub fn practitioner_search_req(sp: SpPractitioner, client: FhirClient) {
  let params =
    using_params([
      #("given", sp.given),
      #("identifier", sp.identifier),
      #("address", sp.address),
      #("deceased", sp.deceased),
      #("address-state", sp.address_state),
      #("gender", sp.gender),
      #("qualification-period", sp.qualification_period),
      #("active", sp.active),
      #("address-postalcode", sp.address_postalcode),
      #("address-country", sp.address_country),
      #("death-date", sp.death_date),
      #("phonetic", sp.phonetic),
      #("phone", sp.phone),
      #("address-use", sp.address_use),
      #("name", sp.name),
      #("telecom", sp.telecom),
      #("address-city", sp.address_city),
      #("communication", sp.communication),
      #("family", sp.family),
      #("email", sp.email),
    ])
  any_search_req(params, "Practitioner", client)
}

pub fn practitionerrole_search_req(sp: SpPractitionerrole, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("specialty", sp.specialty),
      #("role", sp.role),
      #("practitioner", sp.practitioner),
      #("active", sp.active),
      #("characteristic", sp.characteristic),
      #("endpoint", sp.endpoint),
      #("phone", sp.phone),
      #("service", sp.service),
      #("organization", sp.organization),
      #("location", sp.location),
      #("telecom", sp.telecom),
      #("communication", sp.communication),
      #("email", sp.email),
    ])
  any_search_req(params, "PractitionerRole", client)
}

pub fn procedure_search_req(sp: SpProcedure, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("code", sp.code),
      #("performer", sp.performer),
      #("subject", sp.subject),
      #("instantiates-canonical", sp.instantiates_canonical),
      #("part-of", sp.part_of),
      #("encounter", sp.encounter),
      #("reason-code", sp.reason_code),
      #("based-on", sp.based_on),
      #("patient", sp.patient),
      #("reason-reference", sp.reason_reference),
      #("report", sp.report),
      #("instantiates-uri", sp.instantiates_uri),
      #("location", sp.location),
      #("category", sp.category),
      #("status", sp.status),
    ])
  any_search_req(params, "Procedure", client)
}

pub fn provenance_search_req(sp: SpProvenance, client: FhirClient) {
  let params =
    using_params([
      #("agent-type", sp.agent_type),
      #("agent", sp.agent),
      #("signature-type", sp.signature_type),
      #("activity", sp.activity),
      #("encounter", sp.encounter),
      #("recorded", sp.recorded),
      #("when", sp.when),
      #("target", sp.target),
      #("based-on", sp.based_on),
      #("patient", sp.patient),
      #("location", sp.location),
      #("agent-role", sp.agent_role),
      #("entity", sp.entity),
    ])
  any_search_req(params, "Provenance", client)
}

pub fn questionnaire_search_req(sp: SpQuestionnaire, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("combo-code", sp.combo_code),
      #("context-type-value", sp.context_type_value),
      #("jurisdiction", sp.jurisdiction),
      #("description", sp.description),
      #("context-type", sp.context_type),
      #("title", sp.title),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("effective", sp.effective),
      #("subject-type", sp.subject_type),
      #("context", sp.context),
      #("name", sp.name),
      #("publisher", sp.publisher),
      #("questionnaire-code", sp.questionnaire_code),
      #("definition", sp.definition),
      #("context-type-quantity", sp.context_type_quantity),
      #("item-code", sp.item_code),
      #("status", sp.status),
    ])
  any_search_req(params, "Questionnaire", client)
}

pub fn questionnaireresponse_search_req(
  sp: SpQuestionnaireresponse,
  client: FhirClient,
) {
  let params =
    using_params([
      #("authored", sp.authored),
      #("identifier", sp.identifier),
      #("questionnaire", sp.questionnaire),
      #("based-on", sp.based_on),
      #("author", sp.author),
      #("patient", sp.patient),
      #("subject", sp.subject),
      #("part-of", sp.part_of),
      #("encounter", sp.encounter),
      #("source", sp.source),
      #("item-subject", sp.item_subject),
      #("status", sp.status),
    ])
  any_search_req(params, "QuestionnaireResponse", client)
}

pub fn regulatedauthorization_search_req(
  sp: SpRegulatedauthorization,
  client: FhirClient,
) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("subject", sp.subject),
      #("case-type", sp.case_type),
      #("holder", sp.holder),
      #("region", sp.region),
      #("case", sp.case_),
      #("status", sp.status),
    ])
  any_search_req(params, "RegulatedAuthorization", client)
}

pub fn relatedperson_search_req(sp: SpRelatedperson, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("given", sp.given),
      #("address", sp.address),
      #("birthdate", sp.birthdate),
      #("address-state", sp.address_state),
      #("gender", sp.gender),
      #("active", sp.active),
      #("address-postalcode", sp.address_postalcode),
      #("address-country", sp.address_country),
      #("phonetic", sp.phonetic),
      #("phone", sp.phone),
      #("patient", sp.patient),
      #("address-use", sp.address_use),
      #("name", sp.name),
      #("telecom", sp.telecom),
      #("address-city", sp.address_city),
      #("family", sp.family),
      #("relationship", sp.relationship),
      #("email", sp.email),
    ])
  any_search_req(params, "RelatedPerson", client)
}

pub fn requestorchestration_search_req(
  sp: SpRequestorchestration,
  client: FhirClient,
) {
  let params =
    using_params([
      #("authored", sp.authored),
      #("identifier", sp.identifier),
      #("code", sp.code),
      #("author", sp.author),
      #("subject", sp.subject),
      #("instantiates-canonical", sp.instantiates_canonical),
      #("encounter", sp.encounter),
      #("priority", sp.priority),
      #("intent", sp.intent),
      #("participant", sp.participant),
      #("group-identifier", sp.group_identifier),
      #("based-on", sp.based_on),
      #("patient", sp.patient),
      #("instantiates-uri", sp.instantiates_uri),
      #("status", sp.status),
    ])
  any_search_req(params, "RequestOrchestration", client)
}

pub fn requirements_search_req(sp: SpRequirements, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("context-type-value", sp.context_type_value),
      #("jurisdiction", sp.jurisdiction),
      #("description", sp.description),
      #("derived-from", sp.derived_from),
      #("context-type", sp.context_type),
      #("title", sp.title),
      #("version", sp.version),
      #("url", sp.url),
      #("actor", sp.actor),
      #("context-quantity", sp.context_quantity),
      #("context", sp.context),
      #("name", sp.name),
      #("publisher", sp.publisher),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "Requirements", client)
}

pub fn researchstudy_search_req(sp: SpResearchstudy, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("objective-type", sp.objective_type),
      #("study-design", sp.study_design),
      #("description", sp.description),
      #("eligibility", sp.eligibility),
      #("part-of", sp.part_of),
      #("title", sp.title),
      #(
        "progress-status-state-period-actual",
        sp.progress_status_state_period_actual,
      ),
      #("recruitment-target", sp.recruitment_target),
      #("protocol", sp.protocol),
      #("classifier", sp.classifier),
      #("keyword", sp.keyword),
      #("focus-code", sp.focus_code),
      #("phase", sp.phase),
      #("identifier", sp.identifier),
      #("progress-status-state-actual", sp.progress_status_state_actual),
      #("focus-reference", sp.focus_reference),
      #("objective-description", sp.objective_description),
      #("progress-status-state-period", sp.progress_status_state_period),
      #("condition", sp.condition),
      #("site", sp.site),
      #("name", sp.name),
      #("recruitment-actual", sp.recruitment_actual),
      #("region", sp.region),
      #("status", sp.status),
    ])
  any_search_req(params, "ResearchStudy", client)
}

pub fn researchsubject_search_req(sp: SpResearchsubject, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("subject_state", sp.subject_state),
      #("study", sp.study),
      #("subject", sp.subject),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "ResearchSubject", client)
}

pub fn riskassessment_search_req(sp: SpRiskassessment, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("condition", sp.condition),
      #("performer", sp.performer),
      #("method", sp.method),
      #("patient", sp.patient),
      #("probability", sp.probability),
      #("subject", sp.subject),
      #("risk", sp.risk),
      #("encounter", sp.encounter),
    ])
  any_search_req(params, "RiskAssessment", client)
}

pub fn schedule_search_req(sp: SpSchedule, client: FhirClient) {
  let params =
    using_params([
      #("actor", sp.actor),
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("specialty", sp.specialty),
      #("service-category", sp.service_category),
      #("service-type", sp.service_type),
      #("name", sp.name),
      #("active", sp.active),
      #("service-type-reference", sp.service_type_reference),
    ])
  any_search_req(params, "Schedule", client)
}

pub fn searchparameter_search_req(sp: SpSearchparameter, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("code", sp.code),
      #("context-type-value", sp.context_type_value),
      #("jurisdiction", sp.jurisdiction),
      #("derived-from", sp.derived_from),
      #("description", sp.description),
      #("context-type", sp.context_type),
      #("type", sp.type_),
      #("version", sp.version),
      #("url", sp.url),
      #("target", sp.target),
      #("context-quantity", sp.context_quantity),
      #("component", sp.component),
      #("context", sp.context),
      #("name", sp.name),
      #("publisher", sp.publisher),
      #("context-type-quantity", sp.context_type_quantity),
      #("base", sp.base),
      #("status", sp.status),
    ])
  any_search_req(params, "SearchParameter", client)
}

pub fn servicerequest_search_req(sp: SpServicerequest, client: FhirClient) {
  let params =
    using_params([
      #("authored", sp.authored),
      #("requester", sp.requester),
      #("identifier", sp.identifier),
      #("performer", sp.performer),
      #("requisition", sp.requisition),
      #("replaces", sp.replaces),
      #("subject", sp.subject),
      #("instantiates-canonical", sp.instantiates_canonical),
      #("encounter", sp.encounter),
      #("occurrence", sp.occurrence),
      #("priority", sp.priority),
      #("intent", sp.intent),
      #("performer-type", sp.performer_type),
      #("body-structure", sp.body_structure),
      #("based-on", sp.based_on),
      #("code-reference", sp.code_reference),
      #("patient", sp.patient),
      #("specimen", sp.specimen),
      #("code-concept", sp.code_concept),
      #("instantiates-uri", sp.instantiates_uri),
      #("body-site", sp.body_site),
      #("category", sp.category),
      #("status", sp.status),
    ])
  any_search_req(params, "ServiceRequest", client)
}

pub fn slot_search_req(sp: SpSlot, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("schedule", sp.schedule),
      #("specialty", sp.specialty),
      #("service-category", sp.service_category),
      #("appointment-type", sp.appointment_type),
      #("service-type", sp.service_type),
      #("start", sp.start),
      #("service-type-reference", sp.service_type_reference),
      #("status", sp.status),
    ])
  any_search_req(params, "Slot", client)
}

pub fn specimen_search_req(sp: SpSpecimen, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("parent", sp.parent),
      #("bodysite", sp.bodysite),
      #("patient", sp.patient),
      #("subject", sp.subject),
      #("collected", sp.collected),
      #("accession", sp.accession),
      #("procedure", sp.procedure),
      #("type", sp.type_),
      #("collector", sp.collector),
      #("container-device", sp.container_device),
      #("status", sp.status),
    ])
  any_search_req(params, "Specimen", client)
}

pub fn specimendefinition_search_req(
  sp: SpSpecimendefinition,
  client: FhirClient,
) {
  let params =
    using_params([
      #("container", sp.container),
      #("identifier", sp.identifier),
      #("is-derived", sp.is_derived),
      #("experimental", sp.experimental),
      #("type-tested", sp.type_tested),
      #("title", sp.title),
      #("type", sp.type_),
      #("url", sp.url),
      #("status", sp.status),
    ])
  any_search_req(params, "SpecimenDefinition", client)
}

pub fn structuredefinition_search_req(
  sp: SpStructuredefinition,
  client: FhirClient,
) {
  let params =
    using_params([
      #("date", sp.date),
      #("context-type-value", sp.context_type_value),
      #("ext-context-type", sp.ext_context_type),
      #("jurisdiction", sp.jurisdiction),
      #("description", sp.description),
      #("context-type", sp.context_type),
      #("experimental", sp.experimental),
      #("title", sp.title),
      #("type", sp.type_),
      #("context-quantity", sp.context_quantity),
      #("path", sp.path),
      #("base-path", sp.base_path),
      #("context", sp.context),
      #("keyword", sp.keyword),
      #("context-type-quantity", sp.context_type_quantity),
      #("ext-context-expression", sp.ext_context_expression),
      #("identifier", sp.identifier),
      #("valueset", sp.valueset),
      #("kind", sp.kind),
      #("abstract", sp.abstract),
      #("version", sp.version),
      #("url", sp.url),
      #("ext-context", sp.ext_context),
      #("name", sp.name),
      #("publisher", sp.publisher),
      #("derivation", sp.derivation),
      #("base", sp.base),
      #("status", sp.status),
    ])
  any_search_req(params, "StructureDefinition", client)
}

pub fn structuremap_search_req(sp: SpStructuremap, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("context-type-value", sp.context_type_value),
      #("jurisdiction", sp.jurisdiction),
      #("description", sp.description),
      #("context-type", sp.context_type),
      #("title", sp.title),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("context", sp.context),
      #("name", sp.name),
      #("publisher", sp.publisher),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "StructureMap", client)
}

pub fn subscription_search_req(sp: SpSubscription, client: FhirClient) {
  let params =
    using_params([
      #("owner", sp.owner),
      #("identifier", sp.identifier),
      #("payload", sp.payload),
      #("contact", sp.contact),
      #("name", sp.name),
      #("topic", sp.topic),
      #("filter-value", sp.filter_value),
      #("type", sp.type_),
      #("content-level", sp.content_level),
      #("url", sp.url),
      #("status", sp.status),
    ])
  any_search_req(params, "Subscription", client)
}

pub fn subscriptionstatus_search_req(
  _sp: SpSubscriptionstatus,
  client: FhirClient,
) {
  let params = using_params([])
  any_search_req(params, "SubscriptionStatus", client)
}

pub fn subscriptiontopic_search_req(sp: SpSubscriptiontopic, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("effective", sp.effective),
      #("identifier", sp.identifier),
      #("resource", sp.resource),
      #("derived-or-self", sp.derived_or_self),
      #("event", sp.event),
      #("title", sp.title),
      #("version", sp.version),
      #("url", sp.url),
      #("status", sp.status),
      #("trigger-description", sp.trigger_description),
    ])
  any_search_req(params, "SubscriptionTopic", client)
}

pub fn substance_search_req(sp: SpSubstance, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("code", sp.code),
      #("code-reference", sp.code_reference),
      #("quantity", sp.quantity),
      #("substance-reference", sp.substance_reference),
      #("expiry", sp.expiry),
      #("category", sp.category),
      #("status", sp.status),
    ])
  any_search_req(params, "Substance", client)
}

pub fn substancedefinition_search_req(
  sp: SpSubstancedefinition,
  client: FhirClient,
) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("code", sp.code),
      #("domain", sp.domain),
      #("name", sp.name),
      #("classification", sp.classification),
    ])
  any_search_req(params, "SubstanceDefinition", client)
}

pub fn substancenucleicacid_search_req(
  _sp: SpSubstancenucleicacid,
  client: FhirClient,
) {
  let params = using_params([])
  any_search_req(params, "SubstanceNucleicAcid", client)
}

pub fn substancepolymer_search_req(_sp: SpSubstancepolymer, client: FhirClient) {
  let params = using_params([])
  any_search_req(params, "SubstancePolymer", client)
}

pub fn substanceprotein_search_req(_sp: SpSubstanceprotein, client: FhirClient) {
  let params = using_params([])
  any_search_req(params, "SubstanceProtein", client)
}

pub fn substancereferenceinformation_search_req(
  _sp: SpSubstancereferenceinformation,
  client: FhirClient,
) {
  let params = using_params([])
  any_search_req(params, "SubstanceReferenceInformation", client)
}

pub fn substancesourcematerial_search_req(
  _sp: SpSubstancesourcematerial,
  client: FhirClient,
) {
  let params = using_params([])
  any_search_req(params, "SubstanceSourceMaterial", client)
}

pub fn supplydelivery_search_req(sp: SpSupplydelivery, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("receiver", sp.receiver),
      #("patient", sp.patient),
      #("supplier", sp.supplier),
      #("status", sp.status),
    ])
  any_search_req(params, "SupplyDelivery", client)
}

pub fn supplyrequest_search_req(sp: SpSupplyrequest, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("requester", sp.requester),
      #("identifier", sp.identifier),
      #("patient", sp.patient),
      #("subject", sp.subject),
      #("supplier", sp.supplier),
      #("category", sp.category),
      #("status", sp.status),
    ])
  any_search_req(params, "SupplyRequest", client)
}

pub fn task_search_req(sp: SpTask, client: FhirClient) {
  let params =
    using_params([
      #("owner", sp.owner),
      #("requestedperformer-reference", sp.requestedperformer_reference),
      #("requester", sp.requester),
      #("business-status", sp.business_status),
      #("identifier", sp.identifier),
      #("period", sp.period),
      #("code", sp.code),
      #("performer", sp.performer),
      #("subject", sp.subject),
      #("focus", sp.focus),
      #("part-of", sp.part_of),
      #("encounter", sp.encounter),
      #("authored-on", sp.authored_on),
      #("priority", sp.priority),
      #("intent", sp.intent),
      #("output", sp.output),
      #("actor", sp.actor),
      #("group-identifier", sp.group_identifier),
      #("based-on", sp.based_on),
      #("patient", sp.patient),
      #("modified", sp.modified),
      #("status", sp.status),
    ])
  any_search_req(params, "Task", client)
}

pub fn terminologycapabilities_search_req(
  sp: SpTerminologycapabilities,
  client: FhirClient,
) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("context-type-value", sp.context_type_value),
      #("jurisdiction", sp.jurisdiction),
      #("description", sp.description),
      #("context-type", sp.context_type),
      #("title", sp.title),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("context", sp.context),
      #("name", sp.name),
      #("publisher", sp.publisher),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "TerminologyCapabilities", client)
}

pub fn testplan_search_req(sp: SpTestplan, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("scope", sp.scope),
      #("url", sp.url),
      #("status", sp.status),
    ])
  any_search_req(params, "TestPlan", client)
}

pub fn testreport_search_req(sp: SpTestreport, client: FhirClient) {
  let params =
    using_params([
      #("result", sp.result),
      #("identifier", sp.identifier),
      #("tester", sp.tester),
      #("testscript", sp.testscript),
      #("issued", sp.issued),
      #("participant", sp.participant),
      #("status", sp.status),
    ])
  any_search_req(params, "TestReport", client)
}

pub fn testscript_search_req(sp: SpTestscript, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("context-type-value", sp.context_type_value),
      #("jurisdiction", sp.jurisdiction),
      #("description", sp.description),
      #("testscript-capability", sp.testscript_capability),
      #("context-type", sp.context_type),
      #("scope-artifact-phase", sp.scope_artifact_phase),
      #("title", sp.title),
      #("scope-artifact-conformance", sp.scope_artifact_conformance),
      #("version", sp.version),
      #("scope-artifact", sp.scope_artifact),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("context", sp.context),
      #("name", sp.name),
      #("publisher", sp.publisher),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "TestScript", client)
}

pub fn transport_search_req(sp: SpTransport, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("status", sp.status),
    ])
  any_search_req(params, "Transport", client)
}

pub fn valueset_search_req(sp: SpValueset, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("code", sp.code),
      #("context-type-value", sp.context_type_value),
      #("jurisdiction", sp.jurisdiction),
      #("description", sp.description),
      #("derived-from", sp.derived_from),
      #("context-type", sp.context_type),
      #("predecessor", sp.predecessor),
      #("title", sp.title),
      #("version", sp.version),
      #("url", sp.url),
      #("expansion", sp.expansion),
      #("reference", sp.reference),
      #("context-quantity", sp.context_quantity),
      #("effective", sp.effective),
      #("context", sp.context),
      #("name", sp.name),
      #("publisher", sp.publisher),
      #("topic", sp.topic),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "ValueSet", client)
}

pub fn verificationresult_search_req(
  sp: SpVerificationresult,
  client: FhirClient,
) {
  let params =
    using_params([
      #("status-date", sp.status_date),
      #("primarysource-who", sp.primarysource_who),
      #("primarysource-date", sp.primarysource_date),
      #("validator-organization", sp.validator_organization),
      #("attestation-method", sp.attestation_method),
      #("attestation-onbehalfof", sp.attestation_onbehalfof),
      #("target", sp.target),
      #("attestation-who", sp.attestation_who),
      #("primarysource-type", sp.primarysource_type),
      #("status", sp.status),
    ])
  any_search_req(params, "VerificationResult", client)
}

pub fn visionprescription_search_req(
  sp: SpVisionprescription,
  client: FhirClient,
) {
  let params =
    using_params([
      #("prescriber", sp.prescriber),
      #("identifier", sp.identifier),
      #("patient", sp.patient),
      #("datewritten", sp.datewritten),
      #("encounter", sp.encounter),
      #("status", sp.status),
    ])
  any_search_req(params, "VisionPrescription", client)
}

pub fn bundle_to_groupedresources(from bundle: resources.Bundle) {
  list.fold(
    from: groupedresources_new(),
    over: bundle.entry,
    with: fn(acc, entry) {
      case entry.resource {
        None -> acc
        Some(res) ->
          case res {
            resources.ResourceAccount(r) ->
              GroupedResources(..acc, account: [r, ..acc.account])
            resources.ResourceActivitydefinition(r) ->
              GroupedResources(..acc, activitydefinition: [
                r,
                ..acc.activitydefinition
              ])
            resources.ResourceActordefinition(r) ->
              GroupedResources(..acc, actordefinition: [
                r,
                ..acc.actordefinition
              ])
            resources.ResourceAdministrableproductdefinition(r) ->
              GroupedResources(..acc, administrableproductdefinition: [
                r,
                ..acc.administrableproductdefinition
              ])
            resources.ResourceAdverseevent(r) ->
              GroupedResources(..acc, adverseevent: [r, ..acc.adverseevent])
            resources.ResourceAllergyintolerance(r) ->
              GroupedResources(..acc, allergyintolerance: [
                r,
                ..acc.allergyintolerance
              ])
            resources.ResourceAppointment(r) ->
              GroupedResources(..acc, appointment: [r, ..acc.appointment])
            resources.ResourceAppointmentresponse(r) ->
              GroupedResources(..acc, appointmentresponse: [
                r,
                ..acc.appointmentresponse
              ])
            resources.ResourceArtifactassessment(r) ->
              GroupedResources(..acc, artifactassessment: [
                r,
                ..acc.artifactassessment
              ])
            resources.ResourceAuditevent(r) ->
              GroupedResources(..acc, auditevent: [r, ..acc.auditevent])
            resources.ResourceBasic(r) ->
              GroupedResources(..acc, basic: [r, ..acc.basic])
            resources.ResourceBinary(r) ->
              GroupedResources(..acc, binary: [r, ..acc.binary])
            resources.ResourceBiologicallyderivedproduct(r) ->
              GroupedResources(..acc, biologicallyderivedproduct: [
                r,
                ..acc.biologicallyderivedproduct
              ])
            resources.ResourceBiologicallyderivedproductdispense(r) ->
              GroupedResources(..acc, biologicallyderivedproductdispense: [
                r,
                ..acc.biologicallyderivedproductdispense
              ])
            resources.ResourceBodystructure(r) ->
              GroupedResources(..acc, bodystructure: [r, ..acc.bodystructure])
            resources.ResourceBundle(r) ->
              GroupedResources(..acc, bundle: [r, ..acc.bundle])
            resources.ResourceCapabilitystatement(r) ->
              GroupedResources(..acc, capabilitystatement: [
                r,
                ..acc.capabilitystatement
              ])
            resources.ResourceCareplan(r) ->
              GroupedResources(..acc, careplan: [r, ..acc.careplan])
            resources.ResourceCareteam(r) ->
              GroupedResources(..acc, careteam: [r, ..acc.careteam])
            resources.ResourceChargeitem(r) ->
              GroupedResources(..acc, chargeitem: [r, ..acc.chargeitem])
            resources.ResourceChargeitemdefinition(r) ->
              GroupedResources(..acc, chargeitemdefinition: [
                r,
                ..acc.chargeitemdefinition
              ])
            resources.ResourceCitation(r) ->
              GroupedResources(..acc, citation: [r, ..acc.citation])
            resources.ResourceClaim(r) ->
              GroupedResources(..acc, claim: [r, ..acc.claim])
            resources.ResourceClaimresponse(r) ->
              GroupedResources(..acc, claimresponse: [r, ..acc.claimresponse])
            resources.ResourceClinicalimpression(r) ->
              GroupedResources(..acc, clinicalimpression: [
                r,
                ..acc.clinicalimpression
              ])
            resources.ResourceClinicalusedefinition(r) ->
              GroupedResources(..acc, clinicalusedefinition: [
                r,
                ..acc.clinicalusedefinition
              ])
            resources.ResourceCodesystem(r) ->
              GroupedResources(..acc, codesystem: [r, ..acc.codesystem])
            resources.ResourceCommunication(r) ->
              GroupedResources(..acc, communication: [r, ..acc.communication])
            resources.ResourceCommunicationrequest(r) ->
              GroupedResources(..acc, communicationrequest: [
                r,
                ..acc.communicationrequest
              ])
            resources.ResourceCompartmentdefinition(r) ->
              GroupedResources(..acc, compartmentdefinition: [
                r,
                ..acc.compartmentdefinition
              ])
            resources.ResourceComposition(r) ->
              GroupedResources(..acc, composition: [r, ..acc.composition])
            resources.ResourceConceptmap(r) ->
              GroupedResources(..acc, conceptmap: [r, ..acc.conceptmap])
            resources.ResourceCondition(r) ->
              GroupedResources(..acc, condition: [r, ..acc.condition])
            resources.ResourceConditiondefinition(r) ->
              GroupedResources(..acc, conditiondefinition: [
                r,
                ..acc.conditiondefinition
              ])
            resources.ResourceConsent(r) ->
              GroupedResources(..acc, consent: [r, ..acc.consent])
            resources.ResourceContract(r) ->
              GroupedResources(..acc, contract: [r, ..acc.contract])
            resources.ResourceCoverage(r) ->
              GroupedResources(..acc, coverage: [r, ..acc.coverage])
            resources.ResourceCoverageeligibilityrequest(r) ->
              GroupedResources(..acc, coverageeligibilityrequest: [
                r,
                ..acc.coverageeligibilityrequest
              ])
            resources.ResourceCoverageeligibilityresponse(r) ->
              GroupedResources(..acc, coverageeligibilityresponse: [
                r,
                ..acc.coverageeligibilityresponse
              ])
            resources.ResourceDetectedissue(r) ->
              GroupedResources(..acc, detectedissue: [r, ..acc.detectedissue])
            resources.ResourceDevice(r) ->
              GroupedResources(..acc, device: [r, ..acc.device])
            resources.ResourceDeviceassociation(r) ->
              GroupedResources(..acc, deviceassociation: [
                r,
                ..acc.deviceassociation
              ])
            resources.ResourceDevicedefinition(r) ->
              GroupedResources(..acc, devicedefinition: [
                r,
                ..acc.devicedefinition
              ])
            resources.ResourceDevicedispense(r) ->
              GroupedResources(..acc, devicedispense: [r, ..acc.devicedispense])
            resources.ResourceDevicemetric(r) ->
              GroupedResources(..acc, devicemetric: [r, ..acc.devicemetric])
            resources.ResourceDevicerequest(r) ->
              GroupedResources(..acc, devicerequest: [r, ..acc.devicerequest])
            resources.ResourceDeviceusage(r) ->
              GroupedResources(..acc, deviceusage: [r, ..acc.deviceusage])
            resources.ResourceDiagnosticreport(r) ->
              GroupedResources(..acc, diagnosticreport: [
                r,
                ..acc.diagnosticreport
              ])
            resources.ResourceDocumentreference(r) ->
              GroupedResources(..acc, documentreference: [
                r,
                ..acc.documentreference
              ])
            resources.ResourceEncounter(r) ->
              GroupedResources(..acc, encounter: [r, ..acc.encounter])
            resources.ResourceEncounterhistory(r) ->
              GroupedResources(..acc, encounterhistory: [
                r,
                ..acc.encounterhistory
              ])
            resources.ResourceEndpoint(r) ->
              GroupedResources(..acc, endpoint: [r, ..acc.endpoint])
            resources.ResourceEnrollmentrequest(r) ->
              GroupedResources(..acc, enrollmentrequest: [
                r,
                ..acc.enrollmentrequest
              ])
            resources.ResourceEnrollmentresponse(r) ->
              GroupedResources(..acc, enrollmentresponse: [
                r,
                ..acc.enrollmentresponse
              ])
            resources.ResourceEpisodeofcare(r) ->
              GroupedResources(..acc, episodeofcare: [r, ..acc.episodeofcare])
            resources.ResourceEventdefinition(r) ->
              GroupedResources(..acc, eventdefinition: [
                r,
                ..acc.eventdefinition
              ])
            resources.ResourceEvidence(r) ->
              GroupedResources(..acc, evidence: [r, ..acc.evidence])
            resources.ResourceEvidencereport(r) ->
              GroupedResources(..acc, evidencereport: [r, ..acc.evidencereport])
            resources.ResourceEvidencevariable(r) ->
              GroupedResources(..acc, evidencevariable: [
                r,
                ..acc.evidencevariable
              ])
            resources.ResourceExamplescenario(r) ->
              GroupedResources(..acc, examplescenario: [
                r,
                ..acc.examplescenario
              ])
            resources.ResourceExplanationofbenefit(r) ->
              GroupedResources(..acc, explanationofbenefit: [
                r,
                ..acc.explanationofbenefit
              ])
            resources.ResourceFamilymemberhistory(r) ->
              GroupedResources(..acc, familymemberhistory: [
                r,
                ..acc.familymemberhistory
              ])
            resources.ResourceFlag(r) ->
              GroupedResources(..acc, flag: [r, ..acc.flag])
            resources.ResourceFormularyitem(r) ->
              GroupedResources(..acc, formularyitem: [r, ..acc.formularyitem])
            resources.ResourceGenomicstudy(r) ->
              GroupedResources(..acc, genomicstudy: [r, ..acc.genomicstudy])
            resources.ResourceGoal(r) ->
              GroupedResources(..acc, goal: [r, ..acc.goal])
            resources.ResourceGraphdefinition(r) ->
              GroupedResources(..acc, graphdefinition: [
                r,
                ..acc.graphdefinition
              ])
            resources.ResourceGroup(r) ->
              GroupedResources(..acc, group: [r, ..acc.group])
            resources.ResourceGuidanceresponse(r) ->
              GroupedResources(..acc, guidanceresponse: [
                r,
                ..acc.guidanceresponse
              ])
            resources.ResourceHealthcareservice(r) ->
              GroupedResources(..acc, healthcareservice: [
                r,
                ..acc.healthcareservice
              ])
            resources.ResourceImagingselection(r) ->
              GroupedResources(..acc, imagingselection: [
                r,
                ..acc.imagingselection
              ])
            resources.ResourceImagingstudy(r) ->
              GroupedResources(..acc, imagingstudy: [r, ..acc.imagingstudy])
            resources.ResourceImmunization(r) ->
              GroupedResources(..acc, immunization: [r, ..acc.immunization])
            resources.ResourceImmunizationevaluation(r) ->
              GroupedResources(..acc, immunizationevaluation: [
                r,
                ..acc.immunizationevaluation
              ])
            resources.ResourceImmunizationrecommendation(r) ->
              GroupedResources(..acc, immunizationrecommendation: [
                r,
                ..acc.immunizationrecommendation
              ])
            resources.ResourceImplementationguide(r) ->
              GroupedResources(..acc, implementationguide: [
                r,
                ..acc.implementationguide
              ])
            resources.ResourceIngredient(r) ->
              GroupedResources(..acc, ingredient: [r, ..acc.ingredient])
            resources.ResourceInsuranceplan(r) ->
              GroupedResources(..acc, insuranceplan: [r, ..acc.insuranceplan])
            resources.ResourceInventoryitem(r) ->
              GroupedResources(..acc, inventoryitem: [r, ..acc.inventoryitem])
            resources.ResourceInventoryreport(r) ->
              GroupedResources(..acc, inventoryreport: [
                r,
                ..acc.inventoryreport
              ])
            resources.ResourceInvoice(r) ->
              GroupedResources(..acc, invoice: [r, ..acc.invoice])
            resources.ResourceLibrary(r) ->
              GroupedResources(..acc, library: [r, ..acc.library])
            resources.ResourceLinkage(r) ->
              GroupedResources(..acc, linkage: [r, ..acc.linkage])
            resources.ResourceListfhir(r) ->
              GroupedResources(..acc, listfhir: [r, ..acc.listfhir])
            resources.ResourceLocation(r) ->
              GroupedResources(..acc, location: [r, ..acc.location])
            resources.ResourceManufactureditemdefinition(r) ->
              GroupedResources(..acc, manufactureditemdefinition: [
                r,
                ..acc.manufactureditemdefinition
              ])
            resources.ResourceMeasure(r) ->
              GroupedResources(..acc, measure: [r, ..acc.measure])
            resources.ResourceMeasurereport(r) ->
              GroupedResources(..acc, measurereport: [r, ..acc.measurereport])
            resources.ResourceMedication(r) ->
              GroupedResources(..acc, medication: [r, ..acc.medication])
            resources.ResourceMedicationadministration(r) ->
              GroupedResources(..acc, medicationadministration: [
                r,
                ..acc.medicationadministration
              ])
            resources.ResourceMedicationdispense(r) ->
              GroupedResources(..acc, medicationdispense: [
                r,
                ..acc.medicationdispense
              ])
            resources.ResourceMedicationknowledge(r) ->
              GroupedResources(..acc, medicationknowledge: [
                r,
                ..acc.medicationknowledge
              ])
            resources.ResourceMedicationrequest(r) ->
              GroupedResources(..acc, medicationrequest: [
                r,
                ..acc.medicationrequest
              ])
            resources.ResourceMedicationstatement(r) ->
              GroupedResources(..acc, medicationstatement: [
                r,
                ..acc.medicationstatement
              ])
            resources.ResourceMedicinalproductdefinition(r) ->
              GroupedResources(..acc, medicinalproductdefinition: [
                r,
                ..acc.medicinalproductdefinition
              ])
            resources.ResourceMessagedefinition(r) ->
              GroupedResources(..acc, messagedefinition: [
                r,
                ..acc.messagedefinition
              ])
            resources.ResourceMessageheader(r) ->
              GroupedResources(..acc, messageheader: [r, ..acc.messageheader])
            resources.ResourceMolecularsequence(r) ->
              GroupedResources(..acc, molecularsequence: [
                r,
                ..acc.molecularsequence
              ])
            resources.ResourceNamingsystem(r) ->
              GroupedResources(..acc, namingsystem: [r, ..acc.namingsystem])
            resources.ResourceNutritionintake(r) ->
              GroupedResources(..acc, nutritionintake: [
                r,
                ..acc.nutritionintake
              ])
            resources.ResourceNutritionorder(r) ->
              GroupedResources(..acc, nutritionorder: [r, ..acc.nutritionorder])
            resources.ResourceNutritionproduct(r) ->
              GroupedResources(..acc, nutritionproduct: [
                r,
                ..acc.nutritionproduct
              ])
            resources.ResourceObservation(r) ->
              GroupedResources(..acc, observation: [r, ..acc.observation])
            resources.ResourceObservationdefinition(r) ->
              GroupedResources(..acc, observationdefinition: [
                r,
                ..acc.observationdefinition
              ])
            resources.ResourceOperationdefinition(r) ->
              GroupedResources(..acc, operationdefinition: [
                r,
                ..acc.operationdefinition
              ])
            resources.ResourceOperationoutcome(r) ->
              GroupedResources(..acc, operationoutcome: [
                r,
                ..acc.operationoutcome
              ])
            resources.ResourceOrganization(r) ->
              GroupedResources(..acc, organization: [r, ..acc.organization])
            resources.ResourceOrganizationaffiliation(r) ->
              GroupedResources(..acc, organizationaffiliation: [
                r,
                ..acc.organizationaffiliation
              ])
            resources.ResourcePackagedproductdefinition(r) ->
              GroupedResources(..acc, packagedproductdefinition: [
                r,
                ..acc.packagedproductdefinition
              ])
            resources.ResourcePatient(r) ->
              GroupedResources(..acc, patient: [r, ..acc.patient])
            resources.ResourcePaymentnotice(r) ->
              GroupedResources(..acc, paymentnotice: [r, ..acc.paymentnotice])
            resources.ResourcePaymentreconciliation(r) ->
              GroupedResources(..acc, paymentreconciliation: [
                r,
                ..acc.paymentreconciliation
              ])
            resources.ResourcePermission(r) ->
              GroupedResources(..acc, permission: [r, ..acc.permission])
            resources.ResourcePerson(r) ->
              GroupedResources(..acc, person: [r, ..acc.person])
            resources.ResourcePlandefinition(r) ->
              GroupedResources(..acc, plandefinition: [r, ..acc.plandefinition])
            resources.ResourcePractitioner(r) ->
              GroupedResources(..acc, practitioner: [r, ..acc.practitioner])
            resources.ResourcePractitionerrole(r) ->
              GroupedResources(..acc, practitionerrole: [
                r,
                ..acc.practitionerrole
              ])
            resources.ResourceProcedure(r) ->
              GroupedResources(..acc, procedure: [r, ..acc.procedure])
            resources.ResourceProvenance(r) ->
              GroupedResources(..acc, provenance: [r, ..acc.provenance])
            resources.ResourceQuestionnaire(r) ->
              GroupedResources(..acc, questionnaire: [r, ..acc.questionnaire])
            resources.ResourceQuestionnaireresponse(r) ->
              GroupedResources(..acc, questionnaireresponse: [
                r,
                ..acc.questionnaireresponse
              ])
            resources.ResourceRegulatedauthorization(r) ->
              GroupedResources(..acc, regulatedauthorization: [
                r,
                ..acc.regulatedauthorization
              ])
            resources.ResourceRelatedperson(r) ->
              GroupedResources(..acc, relatedperson: [r, ..acc.relatedperson])
            resources.ResourceRequestorchestration(r) ->
              GroupedResources(..acc, requestorchestration: [
                r,
                ..acc.requestorchestration
              ])
            resources.ResourceRequirements(r) ->
              GroupedResources(..acc, requirements: [r, ..acc.requirements])
            resources.ResourceResearchstudy(r) ->
              GroupedResources(..acc, researchstudy: [r, ..acc.researchstudy])
            resources.ResourceResearchsubject(r) ->
              GroupedResources(..acc, researchsubject: [
                r,
                ..acc.researchsubject
              ])
            resources.ResourceRiskassessment(r) ->
              GroupedResources(..acc, riskassessment: [r, ..acc.riskassessment])
            resources.ResourceSchedule(r) ->
              GroupedResources(..acc, schedule: [r, ..acc.schedule])
            resources.ResourceSearchparameter(r) ->
              GroupedResources(..acc, searchparameter: [
                r,
                ..acc.searchparameter
              ])
            resources.ResourceServicerequest(r) ->
              GroupedResources(..acc, servicerequest: [r, ..acc.servicerequest])
            resources.ResourceSlot(r) ->
              GroupedResources(..acc, slot: [r, ..acc.slot])
            resources.ResourceSpecimen(r) ->
              GroupedResources(..acc, specimen: [r, ..acc.specimen])
            resources.ResourceSpecimendefinition(r) ->
              GroupedResources(..acc, specimendefinition: [
                r,
                ..acc.specimendefinition
              ])
            resources.ResourceStructuredefinition(r) ->
              GroupedResources(..acc, structuredefinition: [
                r,
                ..acc.structuredefinition
              ])
            resources.ResourceStructuremap(r) ->
              GroupedResources(..acc, structuremap: [r, ..acc.structuremap])
            resources.ResourceSubscription(r) ->
              GroupedResources(..acc, subscription: [r, ..acc.subscription])
            resources.ResourceSubscriptionstatus(r) ->
              GroupedResources(..acc, subscriptionstatus: [
                r,
                ..acc.subscriptionstatus
              ])
            resources.ResourceSubscriptiontopic(r) ->
              GroupedResources(..acc, subscriptiontopic: [
                r,
                ..acc.subscriptiontopic
              ])
            resources.ResourceSubstance(r) ->
              GroupedResources(..acc, substance: [r, ..acc.substance])
            resources.ResourceSubstancedefinition(r) ->
              GroupedResources(..acc, substancedefinition: [
                r,
                ..acc.substancedefinition
              ])
            resources.ResourceSubstancenucleicacid(r) ->
              GroupedResources(..acc, substancenucleicacid: [
                r,
                ..acc.substancenucleicacid
              ])
            resources.ResourceSubstancepolymer(r) ->
              GroupedResources(..acc, substancepolymer: [
                r,
                ..acc.substancepolymer
              ])
            resources.ResourceSubstanceprotein(r) ->
              GroupedResources(..acc, substanceprotein: [
                r,
                ..acc.substanceprotein
              ])
            resources.ResourceSubstancereferenceinformation(r) ->
              GroupedResources(..acc, substancereferenceinformation: [
                r,
                ..acc.substancereferenceinformation
              ])
            resources.ResourceSubstancesourcematerial(r) ->
              GroupedResources(..acc, substancesourcematerial: [
                r,
                ..acc.substancesourcematerial
              ])
            resources.ResourceSupplydelivery(r) ->
              GroupedResources(..acc, supplydelivery: [r, ..acc.supplydelivery])
            resources.ResourceSupplyrequest(r) ->
              GroupedResources(..acc, supplyrequest: [r, ..acc.supplyrequest])
            resources.ResourceTask(r) ->
              GroupedResources(..acc, task: [r, ..acc.task])
            resources.ResourceTerminologycapabilities(r) ->
              GroupedResources(..acc, terminologycapabilities: [
                r,
                ..acc.terminologycapabilities
              ])
            resources.ResourceTestplan(r) ->
              GroupedResources(..acc, testplan: [r, ..acc.testplan])
            resources.ResourceTestreport(r) ->
              GroupedResources(..acc, testreport: [r, ..acc.testreport])
            resources.ResourceTestscript(r) ->
              GroupedResources(..acc, testscript: [r, ..acc.testscript])
            resources.ResourceTransport(r) ->
              GroupedResources(..acc, transport: [r, ..acc.transport])
            resources.ResourceValueset(r) ->
              GroupedResources(..acc, valueset: [r, ..acc.valueset])
            resources.ResourceVerificationresult(r) ->
              GroupedResources(..acc, verificationresult: [
                r,
                ..acc.verificationresult
              ])
            resources.ResourceVisionprescription(r) ->
              GroupedResources(..acc, visionprescription: [
                r,
                ..acc.visionprescription
              ])
            _ -> acc
          }
      }
    },
  )
}
