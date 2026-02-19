////[https://hl7.org/fhir/r4us](https://hl7.org/fhir/r4us) r4us sans-io request/response helpers suitable for building clients on top of, such as r4us_httpc.gleam and r4us_rsvp.gleam

import fhir/r4us
import gleam/dynamic/decode
import gleam/http
import gleam/http/request.{type Request, Request}
import gleam/http/response.{type Response}
import gleam/json.{type Json}
import gleam/list
import gleam/option.{type Option, None, Some}
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
/// `let pat = r4us.patient_read("123", client)`
///
/// create client from server base url with fhirclient_new(baseurl)`
///
/// `let assert Ok(client) = r4us_sansio.fhirclient_new("r4us.smarthealthit.org/")`
///
/// `let assert Ok(client) = r4us_sansio.fhirclient_new("https://r4us.smarthealthit.org/")`
///
/// `let assert Ok(client) = r4us_sansio.fhirclient_new("https://hapi.fhir.org/baser4us")`
///
/// `let assert Ok(client) = r4us_sansio.fhirclient_new("127.0.0.1:8000")`
pub type FhirClient {
  FhirClient(baseurl: uri.Uri, basereq: Request(String))
}

/// creates a new client from server base url
///
/// `let assert Ok(client) = r4us_sansio.fhirclient_new("r4us.smarthealthit.org/")`
///
/// `let assert Ok(client) = r4us_sansio.fhirclient_new("https://r4us.smarthealthit.org/")`
///
/// `let assert Ok(client) = r4us_sansio.fhirclient_new("https://hapi.fhir.org/baser4us")`
///
/// `let assert Ok(client) = r4us_sansio.fhirclient_new("127.0.0.1:8000")`
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
            Some("http") -> create_base_req(http.Http, host, baseurl)
            Some("https") -> create_base_req(http.Https, host, baseurl)
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
) -> Result(FhirClient, a) {
  let basereq =
    Request(
      method: http.Get,
      headers: [#("Accept", "application/fhir+json")],
      body: "",
      scheme:,
      host:,
      port: baseurl.port,
      path: baseurl.path,
      query: None,
    )
  Ok(FhirClient(baseurl:, basereq:))
}

pub type Err {
  ///could not make a delete or update request because resource has no id
  ErrNoId
  ///got json but could not parse it, probably a missing required field
  ErrParseJson(json.DecodeError)
  ///did not get resource json, often server eg nginx gives basic html response
  ErrNotJson(Response(String))
  ///got operationoutcome error from fhir server
  ErrOperationcome(r4us.Operationoutcome)
}

pub fn any_create_req(resource_json: Json, res_type: String, client: FhirClient) {
  client.basereq
  |> request.set_path(string.concat([client.basereq.path, "/", res_type]))
  |> request.set_header("Content-Type", "application/fhir+json")
  |> request.set_header("Prefer", "return=representation")
  |> request.set_body(resource_json |> json.to_string)
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
) -> Result(Request(String), Err) {
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
        |> request.set_body(resource_json |> json.to_string)
        |> request.set_method(http.Put),
      )
  }
}

pub fn any_delete_req(
  id: Option(String),
  res_type: String,
  client: FhirClient,
) -> Result(Request(String), Err) {
  case id {
    None -> Error(ErrNoId)
    Some(id) ->
      Ok(
        client.basereq
        |> request.set_path(
          string.concat([client.basereq.path, "/", res_type, "/", id]),
        )
        |> request.set_header("Accept", "application/fhir+json")
        |> request.set_method(http.Delete),
      )
  }
}

pub fn any_search_req(
  search_string: String,
  res_type: String,
  client: FhirClient,
) -> Request(String) {
  client.basereq
  |> request.set_path(
    string.concat([client.basereq.path, "/", res_type, "?", search_string]),
  )
}

pub fn any_operation_req(
  res_type: String,
  res_id: Option(String),
  operation_name: String,
  params: Option(r4us.Parameters),
  client: FhirClient,
) -> Request(String) {
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
      |> request.set_body(params |> r4us.parameters_to_json |> json.to_string)
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

//decodes a resource (with type based on given decoder) or operationoutcome
pub fn any_resp(resp: Response(String), resource_dec: decode.Decoder(a)) {
  let decoded_resource =
    resp.body
    |> json.parse(case resp.status >= 300 {
      False -> resource_dec |> decode.map(fn(x) { Ok(x) })
      True -> r4us.operationoutcome_decoder() |> decode.map(fn(x) { Error(x) })
    })
  case decoded_resource {
    Ok(Ok(resource)) -> Ok(resource)
    Ok(Error(op_outcome)) -> Error(ErrOperationcome(op_outcome))
    Error(dec_err) ->
      case dec_err {
        json.UnableToDecode(_) -> Error(ErrParseJson(dec_err))
        _ -> Error(ErrNotJson(resp))
      }
  }
}

pub fn account_create_req(
  resource: r4us.Account,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.account_to_json(resource), "Account", client)
}

pub fn account_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Account", client)
}

pub fn account_update_req(
  resource: r4us.Account,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4us.account_to_json(resource), "Account", client)
}

pub fn account_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Account", client)
}

pub fn account_resp(resp: Response(String)) -> Result(r4us.Account, Err) {
  any_resp(resp, r4us.account_decoder())
}

pub fn activitydefinition_create_req(
  resource: r4us.Activitydefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.activitydefinition_to_json(resource),
    "ActivityDefinition",
    client,
  )
}

pub fn activitydefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "ActivityDefinition", client)
}

pub fn activitydefinition_update_req(
  resource: r4us.Activitydefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.activitydefinition_to_json(resource),
    "ActivityDefinition",
    client,
  )
}

pub fn activitydefinition_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "ActivityDefinition", client)
}

pub fn activitydefinition_resp(
  resp: Response(String),
) -> Result(r4us.Activitydefinition, Err) {
  any_resp(resp, r4us.activitydefinition_decoder())
}

pub fn adverseevent_create_req(
  resource: r4us.Adverseevent,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.adverseevent_to_json(resource), "AdverseEvent", client)
}

pub fn adverseevent_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "AdverseEvent", client)
}

pub fn adverseevent_update_req(
  resource: r4us.Adverseevent,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.adverseevent_to_json(resource),
    "AdverseEvent",
    client,
  )
}

pub fn adverseevent_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "AdverseEvent", client)
}

pub fn adverseevent_resp(
  resp: Response(String),
) -> Result(r4us.Adverseevent, Err) {
  any_resp(resp, r4us.adverseevent_decoder())
}

pub fn us_core_allergyintolerance_create_req(
  resource: r4us.UsCoreAllergyintolerance,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    client,
  )
}

pub fn us_core_allergyintolerance_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "AllergyIntolerance", client)
}

pub fn us_core_allergyintolerance_update_req(
  resource: r4us.UsCoreAllergyintolerance,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    client,
  )
}

pub fn us_core_allergyintolerance_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "AllergyIntolerance", client)
}

pub fn us_core_allergyintolerance_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreAllergyintolerance, Err) {
  any_resp(resp, r4us.us_core_allergyintolerance_decoder())
}

pub fn appointment_create_req(
  resource: r4us.Appointment,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.appointment_to_json(resource), "Appointment", client)
}

pub fn appointment_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Appointment", client)
}

pub fn appointment_update_req(
  resource: r4us.Appointment,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.appointment_to_json(resource),
    "Appointment",
    client,
  )
}

pub fn appointment_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Appointment", client)
}

pub fn appointment_resp(resp: Response(String)) -> Result(r4us.Appointment, Err) {
  any_resp(resp, r4us.appointment_decoder())
}

pub fn appointmentresponse_create_req(
  resource: r4us.Appointmentresponse,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.appointmentresponse_to_json(resource),
    "AppointmentResponse",
    client,
  )
}

pub fn appointmentresponse_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "AppointmentResponse", client)
}

pub fn appointmentresponse_update_req(
  resource: r4us.Appointmentresponse,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.appointmentresponse_to_json(resource),
    "AppointmentResponse",
    client,
  )
}

pub fn appointmentresponse_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "AppointmentResponse", client)
}

pub fn appointmentresponse_resp(
  resp: Response(String),
) -> Result(r4us.Appointmentresponse, Err) {
  any_resp(resp, r4us.appointmentresponse_decoder())
}

pub fn auditevent_create_req(
  resource: r4us.Auditevent,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.auditevent_to_json(resource), "AuditEvent", client)
}

pub fn auditevent_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "AuditEvent", client)
}

pub fn auditevent_update_req(
  resource: r4us.Auditevent,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.auditevent_to_json(resource),
    "AuditEvent",
    client,
  )
}

pub fn auditevent_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "AuditEvent", client)
}

pub fn auditevent_resp(resp: Response(String)) -> Result(r4us.Auditevent, Err) {
  any_resp(resp, r4us.auditevent_decoder())
}

pub fn basic_create_req(
  resource: r4us.Basic,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.basic_to_json(resource), "Basic", client)
}

pub fn basic_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Basic", client)
}

pub fn basic_update_req(
  resource: r4us.Basic,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4us.basic_to_json(resource), "Basic", client)
}

pub fn basic_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Basic", client)
}

pub fn basic_resp(resp: Response(String)) -> Result(r4us.Basic, Err) {
  any_resp(resp, r4us.basic_decoder())
}

pub fn binary_create_req(
  resource: r4us.Binary,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.binary_to_json(resource), "Binary", client)
}

pub fn binary_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Binary", client)
}

pub fn binary_update_req(
  resource: r4us.Binary,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4us.binary_to_json(resource), "Binary", client)
}

pub fn binary_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Binary", client)
}

pub fn binary_resp(resp: Response(String)) -> Result(r4us.Binary, Err) {
  any_resp(resp, r4us.binary_decoder())
}

pub fn biologicallyderivedproduct_create_req(
  resource: r4us.Biologicallyderivedproduct,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.biologicallyderivedproduct_to_json(resource),
    "BiologicallyDerivedProduct",
    client,
  )
}

pub fn biologicallyderivedproduct_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "BiologicallyDerivedProduct", client)
}

pub fn biologicallyderivedproduct_update_req(
  resource: r4us.Biologicallyderivedproduct,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.biologicallyderivedproduct_to_json(resource),
    "BiologicallyDerivedProduct",
    client,
  )
}

pub fn biologicallyderivedproduct_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "BiologicallyDerivedProduct", client)
}

pub fn biologicallyderivedproduct_resp(
  resp: Response(String),
) -> Result(r4us.Biologicallyderivedproduct, Err) {
  any_resp(resp, r4us.biologicallyderivedproduct_decoder())
}

pub fn bodystructure_create_req(
  resource: r4us.Bodystructure,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.bodystructure_to_json(resource), "BodyStructure", client)
}

pub fn bodystructure_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "BodyStructure", client)
}

pub fn bodystructure_update_req(
  resource: r4us.Bodystructure,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.bodystructure_to_json(resource),
    "BodyStructure",
    client,
  )
}

pub fn bodystructure_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "BodyStructure", client)
}

pub fn bodystructure_resp(
  resp: Response(String),
) -> Result(r4us.Bodystructure, Err) {
  any_resp(resp, r4us.bodystructure_decoder())
}

pub fn bundle_create_req(
  resource: r4us.Bundle,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.bundle_to_json(resource), "Bundle", client)
}

pub fn bundle_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Bundle", client)
}

pub fn bundle_update_req(
  resource: r4us.Bundle,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4us.bundle_to_json(resource), "Bundle", client)
}

pub fn bundle_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Bundle", client)
}

pub fn bundle_resp(resp: Response(String)) -> Result(r4us.Bundle, Err) {
  any_resp(resp, r4us.bundle_decoder())
}

pub fn capabilitystatement_create_req(
  resource: r4us.Capabilitystatement,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.capabilitystatement_to_json(resource),
    "CapabilityStatement",
    client,
  )
}

pub fn capabilitystatement_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "CapabilityStatement", client)
}

pub fn capabilitystatement_update_req(
  resource: r4us.Capabilitystatement,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.capabilitystatement_to_json(resource),
    "CapabilityStatement",
    client,
  )
}

pub fn capabilitystatement_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "CapabilityStatement", client)
}

pub fn capabilitystatement_resp(
  resp: Response(String),
) -> Result(r4us.Capabilitystatement, Err) {
  any_resp(resp, r4us.capabilitystatement_decoder())
}

pub fn us_core_careplan_create_req(
  resource: r4us.UsCoreCareplan,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.us_core_careplan_to_json(resource), "CarePlan", client)
}

pub fn us_core_careplan_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "CarePlan", client)
}

pub fn us_core_careplan_update_req(
  resource: r4us.UsCoreCareplan,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_careplan_to_json(resource),
    "CarePlan",
    client,
  )
}

pub fn us_core_careplan_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "CarePlan", client)
}

pub fn us_core_careplan_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreCareplan, Err) {
  any_resp(resp, r4us.us_core_careplan_decoder())
}

pub fn us_core_careteam_create_req(
  resource: r4us.UsCoreCareteam,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.us_core_careteam_to_json(resource), "CareTeam", client)
}

pub fn us_core_careteam_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "CareTeam", client)
}

pub fn us_core_careteam_update_req(
  resource: r4us.UsCoreCareteam,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_careteam_to_json(resource),
    "CareTeam",
    client,
  )
}

pub fn us_core_careteam_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "CareTeam", client)
}

pub fn us_core_careteam_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreCareteam, Err) {
  any_resp(resp, r4us.us_core_careteam_decoder())
}

pub fn catalogentry_create_req(
  resource: r4us.Catalogentry,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.catalogentry_to_json(resource), "CatalogEntry", client)
}

pub fn catalogentry_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "CatalogEntry", client)
}

pub fn catalogentry_update_req(
  resource: r4us.Catalogentry,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.catalogentry_to_json(resource),
    "CatalogEntry",
    client,
  )
}

pub fn catalogentry_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "CatalogEntry", client)
}

pub fn catalogentry_resp(
  resp: Response(String),
) -> Result(r4us.Catalogentry, Err) {
  any_resp(resp, r4us.catalogentry_decoder())
}

pub fn chargeitem_create_req(
  resource: r4us.Chargeitem,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.chargeitem_to_json(resource), "ChargeItem", client)
}

pub fn chargeitem_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "ChargeItem", client)
}

pub fn chargeitem_update_req(
  resource: r4us.Chargeitem,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.chargeitem_to_json(resource),
    "ChargeItem",
    client,
  )
}

pub fn chargeitem_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "ChargeItem", client)
}

pub fn chargeitem_resp(resp: Response(String)) -> Result(r4us.Chargeitem, Err) {
  any_resp(resp, r4us.chargeitem_decoder())
}

pub fn chargeitemdefinition_create_req(
  resource: r4us.Chargeitemdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.chargeitemdefinition_to_json(resource),
    "ChargeItemDefinition",
    client,
  )
}

pub fn chargeitemdefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "ChargeItemDefinition", client)
}

pub fn chargeitemdefinition_update_req(
  resource: r4us.Chargeitemdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.chargeitemdefinition_to_json(resource),
    "ChargeItemDefinition",
    client,
  )
}

pub fn chargeitemdefinition_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "ChargeItemDefinition", client)
}

pub fn chargeitemdefinition_resp(
  resp: Response(String),
) -> Result(r4us.Chargeitemdefinition, Err) {
  any_resp(resp, r4us.chargeitemdefinition_decoder())
}

pub fn claim_create_req(
  resource: r4us.Claim,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.claim_to_json(resource), "Claim", client)
}

pub fn claim_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Claim", client)
}

pub fn claim_update_req(
  resource: r4us.Claim,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4us.claim_to_json(resource), "Claim", client)
}

pub fn claim_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Claim", client)
}

pub fn claim_resp(resp: Response(String)) -> Result(r4us.Claim, Err) {
  any_resp(resp, r4us.claim_decoder())
}

pub fn claimresponse_create_req(
  resource: r4us.Claimresponse,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.claimresponse_to_json(resource), "ClaimResponse", client)
}

pub fn claimresponse_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "ClaimResponse", client)
}

pub fn claimresponse_update_req(
  resource: r4us.Claimresponse,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.claimresponse_to_json(resource),
    "ClaimResponse",
    client,
  )
}

pub fn claimresponse_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "ClaimResponse", client)
}

pub fn claimresponse_resp(
  resp: Response(String),
) -> Result(r4us.Claimresponse, Err) {
  any_resp(resp, r4us.claimresponse_decoder())
}

pub fn clinicalimpression_create_req(
  resource: r4us.Clinicalimpression,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.clinicalimpression_to_json(resource),
    "ClinicalImpression",
    client,
  )
}

pub fn clinicalimpression_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "ClinicalImpression", client)
}

pub fn clinicalimpression_update_req(
  resource: r4us.Clinicalimpression,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.clinicalimpression_to_json(resource),
    "ClinicalImpression",
    client,
  )
}

pub fn clinicalimpression_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "ClinicalImpression", client)
}

pub fn clinicalimpression_resp(
  resp: Response(String),
) -> Result(r4us.Clinicalimpression, Err) {
  any_resp(resp, r4us.clinicalimpression_decoder())
}

pub fn codesystem_create_req(
  resource: r4us.Codesystem,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.codesystem_to_json(resource), "CodeSystem", client)
}

pub fn codesystem_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "CodeSystem", client)
}

pub fn codesystem_update_req(
  resource: r4us.Codesystem,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.codesystem_to_json(resource),
    "CodeSystem",
    client,
  )
}

pub fn codesystem_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "CodeSystem", client)
}

pub fn codesystem_resp(resp: Response(String)) -> Result(r4us.Codesystem, Err) {
  any_resp(resp, r4us.codesystem_decoder())
}

pub fn communication_create_req(
  resource: r4us.Communication,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.communication_to_json(resource), "Communication", client)
}

pub fn communication_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Communication", client)
}

pub fn communication_update_req(
  resource: r4us.Communication,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.communication_to_json(resource),
    "Communication",
    client,
  )
}

pub fn communication_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Communication", client)
}

pub fn communication_resp(
  resp: Response(String),
) -> Result(r4us.Communication, Err) {
  any_resp(resp, r4us.communication_decoder())
}

pub fn communicationrequest_create_req(
  resource: r4us.Communicationrequest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.communicationrequest_to_json(resource),
    "CommunicationRequest",
    client,
  )
}

pub fn communicationrequest_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "CommunicationRequest", client)
}

pub fn communicationrequest_update_req(
  resource: r4us.Communicationrequest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.communicationrequest_to_json(resource),
    "CommunicationRequest",
    client,
  )
}

pub fn communicationrequest_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "CommunicationRequest", client)
}

pub fn communicationrequest_resp(
  resp: Response(String),
) -> Result(r4us.Communicationrequest, Err) {
  any_resp(resp, r4us.communicationrequest_decoder())
}

pub fn compartmentdefinition_create_req(
  resource: r4us.Compartmentdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.compartmentdefinition_to_json(resource),
    "CompartmentDefinition",
    client,
  )
}

pub fn compartmentdefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "CompartmentDefinition", client)
}

pub fn compartmentdefinition_update_req(
  resource: r4us.Compartmentdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.compartmentdefinition_to_json(resource),
    "CompartmentDefinition",
    client,
  )
}

pub fn compartmentdefinition_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "CompartmentDefinition", client)
}

pub fn compartmentdefinition_resp(
  resp: Response(String),
) -> Result(r4us.Compartmentdefinition, Err) {
  any_resp(resp, r4us.compartmentdefinition_decoder())
}

pub fn composition_create_req(
  resource: r4us.Composition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.composition_to_json(resource), "Composition", client)
}

pub fn composition_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Composition", client)
}

pub fn composition_update_req(
  resource: r4us.Composition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.composition_to_json(resource),
    "Composition",
    client,
  )
}

pub fn composition_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Composition", client)
}

pub fn composition_resp(resp: Response(String)) -> Result(r4us.Composition, Err) {
  any_resp(resp, r4us.composition_decoder())
}

pub fn conceptmap_create_req(
  resource: r4us.Conceptmap,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.conceptmap_to_json(resource), "ConceptMap", client)
}

pub fn conceptmap_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "ConceptMap", client)
}

pub fn conceptmap_update_req(
  resource: r4us.Conceptmap,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.conceptmap_to_json(resource),
    "ConceptMap",
    client,
  )
}

pub fn conceptmap_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "ConceptMap", client)
}

pub fn conceptmap_resp(resp: Response(String)) -> Result(r4us.Conceptmap, Err) {
  any_resp(resp, r4us.conceptmap_decoder())
}

pub fn us_core_condition_encounter_diagnosis_create_req(
  resource: r4us.UsCoreConditionEncounterDiagnosis,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_condition_encounter_diagnosis_to_json(resource),
    "Condition",
    client,
  )
}

pub fn us_core_condition_encounter_diagnosis_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Condition", client)
}

pub fn us_core_condition_encounter_diagnosis_update_req(
  resource: r4us.UsCoreConditionEncounterDiagnosis,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_condition_encounter_diagnosis_to_json(resource),
    "Condition",
    client,
  )
}

pub fn us_core_condition_encounter_diagnosis_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Condition", client)
}

pub fn us_core_condition_encounter_diagnosis_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreConditionEncounterDiagnosis, Err) {
  any_resp(resp, r4us.us_core_condition_encounter_diagnosis_decoder())
}

pub fn us_core_condition_problems_health_concerns_create_req(
  resource: r4us.UsCoreConditionProblemsHealthConcerns,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_condition_problems_health_concerns_to_json(resource),
    "Condition",
    client,
  )
}

pub fn us_core_condition_problems_health_concerns_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Condition", client)
}

pub fn us_core_condition_problems_health_concerns_update_req(
  resource: r4us.UsCoreConditionProblemsHealthConcerns,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_condition_problems_health_concerns_to_json(resource),
    "Condition",
    client,
  )
}

pub fn us_core_condition_problems_health_concerns_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Condition", client)
}

pub fn us_core_condition_problems_health_concerns_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreConditionProblemsHealthConcerns, Err) {
  any_resp(resp, r4us.us_core_condition_problems_health_concerns_decoder())
}

pub fn consent_create_req(
  resource: r4us.Consent,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.consent_to_json(resource), "Consent", client)
}

pub fn consent_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Consent", client)
}

pub fn consent_update_req(
  resource: r4us.Consent,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4us.consent_to_json(resource), "Consent", client)
}

pub fn consent_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Consent", client)
}

pub fn consent_resp(resp: Response(String)) -> Result(r4us.Consent, Err) {
  any_resp(resp, r4us.consent_decoder())
}

pub fn contract_create_req(
  resource: r4us.Contract,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.contract_to_json(resource), "Contract", client)
}

pub fn contract_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Contract", client)
}

pub fn contract_update_req(
  resource: r4us.Contract,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.contract_to_json(resource),
    "Contract",
    client,
  )
}

pub fn contract_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Contract", client)
}

pub fn contract_resp(resp: Response(String)) -> Result(r4us.Contract, Err) {
  any_resp(resp, r4us.contract_decoder())
}

pub fn us_core_coverage_create_req(
  resource: r4us.UsCoreCoverage,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.us_core_coverage_to_json(resource), "Coverage", client)
}

pub fn us_core_coverage_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Coverage", client)
}

pub fn us_core_coverage_update_req(
  resource: r4us.UsCoreCoverage,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_coverage_to_json(resource),
    "Coverage",
    client,
  )
}

pub fn us_core_coverage_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Coverage", client)
}

pub fn us_core_coverage_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreCoverage, Err) {
  any_resp(resp, r4us.us_core_coverage_decoder())
}

pub fn coverageeligibilityrequest_create_req(
  resource: r4us.Coverageeligibilityrequest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.coverageeligibilityrequest_to_json(resource),
    "CoverageEligibilityRequest",
    client,
  )
}

pub fn coverageeligibilityrequest_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "CoverageEligibilityRequest", client)
}

pub fn coverageeligibilityrequest_update_req(
  resource: r4us.Coverageeligibilityrequest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.coverageeligibilityrequest_to_json(resource),
    "CoverageEligibilityRequest",
    client,
  )
}

pub fn coverageeligibilityrequest_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "CoverageEligibilityRequest", client)
}

pub fn coverageeligibilityrequest_resp(
  resp: Response(String),
) -> Result(r4us.Coverageeligibilityrequest, Err) {
  any_resp(resp, r4us.coverageeligibilityrequest_decoder())
}

pub fn coverageeligibilityresponse_create_req(
  resource: r4us.Coverageeligibilityresponse,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.coverageeligibilityresponse_to_json(resource),
    "CoverageEligibilityResponse",
    client,
  )
}

pub fn coverageeligibilityresponse_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "CoverageEligibilityResponse", client)
}

pub fn coverageeligibilityresponse_update_req(
  resource: r4us.Coverageeligibilityresponse,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.coverageeligibilityresponse_to_json(resource),
    "CoverageEligibilityResponse",
    client,
  )
}

pub fn coverageeligibilityresponse_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "CoverageEligibilityResponse", client)
}

pub fn coverageeligibilityresponse_resp(
  resp: Response(String),
) -> Result(r4us.Coverageeligibilityresponse, Err) {
  any_resp(resp, r4us.coverageeligibilityresponse_decoder())
}

pub fn detectedissue_create_req(
  resource: r4us.Detectedissue,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.detectedissue_to_json(resource), "DetectedIssue", client)
}

pub fn detectedissue_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "DetectedIssue", client)
}

pub fn detectedissue_update_req(
  resource: r4us.Detectedissue,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.detectedissue_to_json(resource),
    "DetectedIssue",
    client,
  )
}

pub fn detectedissue_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "DetectedIssue", client)
}

pub fn detectedissue_resp(
  resp: Response(String),
) -> Result(r4us.Detectedissue, Err) {
  any_resp(resp, r4us.detectedissue_decoder())
}

pub fn us_core_device_create_req(
  resource: r4us.UsCoreDevice,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.us_core_device_to_json(resource), "Device", client)
}

pub fn us_core_device_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Device", client)
}

pub fn us_core_device_update_req(
  resource: r4us.UsCoreDevice,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_device_to_json(resource),
    "Device",
    client,
  )
}

pub fn us_core_device_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Device", client)
}

pub fn us_core_device_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreDevice, Err) {
  any_resp(resp, r4us.us_core_device_decoder())
}

pub fn devicedefinition_create_req(
  resource: r4us.Devicedefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.devicedefinition_to_json(resource),
    "DeviceDefinition",
    client,
  )
}

pub fn devicedefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "DeviceDefinition", client)
}

pub fn devicedefinition_update_req(
  resource: r4us.Devicedefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.devicedefinition_to_json(resource),
    "DeviceDefinition",
    client,
  )
}

pub fn devicedefinition_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "DeviceDefinition", client)
}

pub fn devicedefinition_resp(
  resp: Response(String),
) -> Result(r4us.Devicedefinition, Err) {
  any_resp(resp, r4us.devicedefinition_decoder())
}

pub fn devicemetric_create_req(
  resource: r4us.Devicemetric,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.devicemetric_to_json(resource), "DeviceMetric", client)
}

pub fn devicemetric_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "DeviceMetric", client)
}

pub fn devicemetric_update_req(
  resource: r4us.Devicemetric,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.devicemetric_to_json(resource),
    "DeviceMetric",
    client,
  )
}

pub fn devicemetric_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "DeviceMetric", client)
}

pub fn devicemetric_resp(
  resp: Response(String),
) -> Result(r4us.Devicemetric, Err) {
  any_resp(resp, r4us.devicemetric_decoder())
}

pub fn devicerequest_create_req(
  resource: r4us.Devicerequest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.devicerequest_to_json(resource), "DeviceRequest", client)
}

pub fn devicerequest_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "DeviceRequest", client)
}

pub fn devicerequest_update_req(
  resource: r4us.Devicerequest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.devicerequest_to_json(resource),
    "DeviceRequest",
    client,
  )
}

pub fn devicerequest_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "DeviceRequest", client)
}

pub fn devicerequest_resp(
  resp: Response(String),
) -> Result(r4us.Devicerequest, Err) {
  any_resp(resp, r4us.devicerequest_decoder())
}

pub fn deviceusestatement_create_req(
  resource: r4us.Deviceusestatement,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.deviceusestatement_to_json(resource),
    "DeviceUseStatement",
    client,
  )
}

pub fn deviceusestatement_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "DeviceUseStatement", client)
}

pub fn deviceusestatement_update_req(
  resource: r4us.Deviceusestatement,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.deviceusestatement_to_json(resource),
    "DeviceUseStatement",
    client,
  )
}

pub fn deviceusestatement_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "DeviceUseStatement", client)
}

pub fn deviceusestatement_resp(
  resp: Response(String),
) -> Result(r4us.Deviceusestatement, Err) {
  any_resp(resp, r4us.deviceusestatement_decoder())
}

pub fn us_core_diagnosticreport_lab_create_req(
  resource: r4us.UsCoreDiagnosticreportLab,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_diagnosticreport_lab_to_json(resource),
    "DiagnosticReport",
    client,
  )
}

pub fn us_core_diagnosticreport_lab_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "DiagnosticReport", client)
}

pub fn us_core_diagnosticreport_lab_update_req(
  resource: r4us.UsCoreDiagnosticreportLab,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_diagnosticreport_lab_to_json(resource),
    "DiagnosticReport",
    client,
  )
}

pub fn us_core_diagnosticreport_lab_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "DiagnosticReport", client)
}

pub fn us_core_diagnosticreport_lab_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreDiagnosticreportLab, Err) {
  any_resp(resp, r4us.us_core_diagnosticreport_lab_decoder())
}

pub fn us_core_diagnosticreport_note_create_req(
  resource: r4us.UsCoreDiagnosticreportNote,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_diagnosticreport_note_to_json(resource),
    "DiagnosticReport",
    client,
  )
}

pub fn us_core_diagnosticreport_note_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "DiagnosticReport", client)
}

pub fn us_core_diagnosticreport_note_update_req(
  resource: r4us.UsCoreDiagnosticreportNote,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_diagnosticreport_note_to_json(resource),
    "DiagnosticReport",
    client,
  )
}

pub fn us_core_diagnosticreport_note_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "DiagnosticReport", client)
}

pub fn us_core_diagnosticreport_note_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreDiagnosticreportNote, Err) {
  any_resp(resp, r4us.us_core_diagnosticreport_note_decoder())
}

pub fn documentmanifest_create_req(
  resource: r4us.Documentmanifest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.documentmanifest_to_json(resource),
    "DocumentManifest",
    client,
  )
}

pub fn documentmanifest_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "DocumentManifest", client)
}

pub fn documentmanifest_update_req(
  resource: r4us.Documentmanifest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.documentmanifest_to_json(resource),
    "DocumentManifest",
    client,
  )
}

pub fn documentmanifest_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "DocumentManifest", client)
}

pub fn documentmanifest_resp(
  resp: Response(String),
) -> Result(r4us.Documentmanifest, Err) {
  any_resp(resp, r4us.documentmanifest_decoder())
}

pub fn us_core_documentreference_create_req(
  resource: r4us.UsCoreDocumentreference,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_documentreference_to_json(resource),
    "DocumentReference",
    client,
  )
}

pub fn us_core_documentreference_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "DocumentReference", client)
}

pub fn us_core_documentreference_update_req(
  resource: r4us.UsCoreDocumentreference,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_documentreference_to_json(resource),
    "DocumentReference",
    client,
  )
}

pub fn us_core_documentreference_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "DocumentReference", client)
}

pub fn us_core_documentreference_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreDocumentreference, Err) {
  any_resp(resp, r4us.us_core_documentreference_decoder())
}

pub fn us_core_adi_documentreference_create_req(
  resource: r4us.UsCoreAdiDocumentreference,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_adi_documentreference_to_json(resource),
    "DocumentReference",
    client,
  )
}

pub fn us_core_adi_documentreference_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "DocumentReference", client)
}

pub fn us_core_adi_documentreference_update_req(
  resource: r4us.UsCoreAdiDocumentreference,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_adi_documentreference_to_json(resource),
    "DocumentReference",
    client,
  )
}

pub fn us_core_adi_documentreference_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "DocumentReference", client)
}

pub fn us_core_adi_documentreference_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreAdiDocumentreference, Err) {
  any_resp(resp, r4us.us_core_adi_documentreference_decoder())
}

pub fn effectevidencesynthesis_create_req(
  resource: r4us.Effectevidencesynthesis,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.effectevidencesynthesis_to_json(resource),
    "EffectEvidenceSynthesis",
    client,
  )
}

pub fn effectevidencesynthesis_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "EffectEvidenceSynthesis", client)
}

pub fn effectevidencesynthesis_update_req(
  resource: r4us.Effectevidencesynthesis,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.effectevidencesynthesis_to_json(resource),
    "EffectEvidenceSynthesis",
    client,
  )
}

pub fn effectevidencesynthesis_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "EffectEvidenceSynthesis", client)
}

pub fn effectevidencesynthesis_resp(
  resp: Response(String),
) -> Result(r4us.Effectevidencesynthesis, Err) {
  any_resp(resp, r4us.effectevidencesynthesis_decoder())
}

pub fn us_core_encounter_create_req(
  resource: r4us.UsCoreEncounter,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.us_core_encounter_to_json(resource), "Encounter", client)
}

pub fn us_core_encounter_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Encounter", client)
}

pub fn us_core_encounter_update_req(
  resource: r4us.UsCoreEncounter,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_encounter_to_json(resource),
    "Encounter",
    client,
  )
}

pub fn us_core_encounter_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Encounter", client)
}

pub fn us_core_encounter_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreEncounter, Err) {
  any_resp(resp, r4us.us_core_encounter_decoder())
}

pub fn endpoint_create_req(
  resource: r4us.Endpoint,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.endpoint_to_json(resource), "Endpoint", client)
}

pub fn endpoint_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Endpoint", client)
}

pub fn endpoint_update_req(
  resource: r4us.Endpoint,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.endpoint_to_json(resource),
    "Endpoint",
    client,
  )
}

pub fn endpoint_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Endpoint", client)
}

pub fn endpoint_resp(resp: Response(String)) -> Result(r4us.Endpoint, Err) {
  any_resp(resp, r4us.endpoint_decoder())
}

pub fn enrollmentrequest_create_req(
  resource: r4us.Enrollmentrequest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.enrollmentrequest_to_json(resource),
    "EnrollmentRequest",
    client,
  )
}

pub fn enrollmentrequest_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "EnrollmentRequest", client)
}

pub fn enrollmentrequest_update_req(
  resource: r4us.Enrollmentrequest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.enrollmentrequest_to_json(resource),
    "EnrollmentRequest",
    client,
  )
}

pub fn enrollmentrequest_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "EnrollmentRequest", client)
}

pub fn enrollmentrequest_resp(
  resp: Response(String),
) -> Result(r4us.Enrollmentrequest, Err) {
  any_resp(resp, r4us.enrollmentrequest_decoder())
}

pub fn enrollmentresponse_create_req(
  resource: r4us.Enrollmentresponse,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.enrollmentresponse_to_json(resource),
    "EnrollmentResponse",
    client,
  )
}

pub fn enrollmentresponse_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "EnrollmentResponse", client)
}

pub fn enrollmentresponse_update_req(
  resource: r4us.Enrollmentresponse,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.enrollmentresponse_to_json(resource),
    "EnrollmentResponse",
    client,
  )
}

pub fn enrollmentresponse_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "EnrollmentResponse", client)
}

pub fn enrollmentresponse_resp(
  resp: Response(String),
) -> Result(r4us.Enrollmentresponse, Err) {
  any_resp(resp, r4us.enrollmentresponse_decoder())
}

pub fn episodeofcare_create_req(
  resource: r4us.Episodeofcare,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.episodeofcare_to_json(resource), "EpisodeOfCare", client)
}

pub fn episodeofcare_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "EpisodeOfCare", client)
}

pub fn episodeofcare_update_req(
  resource: r4us.Episodeofcare,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.episodeofcare_to_json(resource),
    "EpisodeOfCare",
    client,
  )
}

pub fn episodeofcare_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "EpisodeOfCare", client)
}

pub fn episodeofcare_resp(
  resp: Response(String),
) -> Result(r4us.Episodeofcare, Err) {
  any_resp(resp, r4us.episodeofcare_decoder())
}

pub fn eventdefinition_create_req(
  resource: r4us.Eventdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.eventdefinition_to_json(resource),
    "EventDefinition",
    client,
  )
}

pub fn eventdefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "EventDefinition", client)
}

pub fn eventdefinition_update_req(
  resource: r4us.Eventdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.eventdefinition_to_json(resource),
    "EventDefinition",
    client,
  )
}

pub fn eventdefinition_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "EventDefinition", client)
}

pub fn eventdefinition_resp(
  resp: Response(String),
) -> Result(r4us.Eventdefinition, Err) {
  any_resp(resp, r4us.eventdefinition_decoder())
}

pub fn evidence_create_req(
  resource: r4us.Evidence,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.evidence_to_json(resource), "Evidence", client)
}

pub fn evidence_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Evidence", client)
}

pub fn evidence_update_req(
  resource: r4us.Evidence,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.evidence_to_json(resource),
    "Evidence",
    client,
  )
}

pub fn evidence_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Evidence", client)
}

pub fn evidence_resp(resp: Response(String)) -> Result(r4us.Evidence, Err) {
  any_resp(resp, r4us.evidence_decoder())
}

pub fn evidencevariable_create_req(
  resource: r4us.Evidencevariable,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.evidencevariable_to_json(resource),
    "EvidenceVariable",
    client,
  )
}

pub fn evidencevariable_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "EvidenceVariable", client)
}

pub fn evidencevariable_update_req(
  resource: r4us.Evidencevariable,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.evidencevariable_to_json(resource),
    "EvidenceVariable",
    client,
  )
}

pub fn evidencevariable_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "EvidenceVariable", client)
}

pub fn evidencevariable_resp(
  resp: Response(String),
) -> Result(r4us.Evidencevariable, Err) {
  any_resp(resp, r4us.evidencevariable_decoder())
}

pub fn examplescenario_create_req(
  resource: r4us.Examplescenario,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.examplescenario_to_json(resource),
    "ExampleScenario",
    client,
  )
}

pub fn examplescenario_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "ExampleScenario", client)
}

pub fn examplescenario_update_req(
  resource: r4us.Examplescenario,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.examplescenario_to_json(resource),
    "ExampleScenario",
    client,
  )
}

pub fn examplescenario_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "ExampleScenario", client)
}

pub fn examplescenario_resp(
  resp: Response(String),
) -> Result(r4us.Examplescenario, Err) {
  any_resp(resp, r4us.examplescenario_decoder())
}

pub fn explanationofbenefit_create_req(
  resource: r4us.Explanationofbenefit,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.explanationofbenefit_to_json(resource),
    "ExplanationOfBenefit",
    client,
  )
}

pub fn explanationofbenefit_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "ExplanationOfBenefit", client)
}

pub fn explanationofbenefit_update_req(
  resource: r4us.Explanationofbenefit,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.explanationofbenefit_to_json(resource),
    "ExplanationOfBenefit",
    client,
  )
}

pub fn explanationofbenefit_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "ExplanationOfBenefit", client)
}

pub fn explanationofbenefit_resp(
  resp: Response(String),
) -> Result(r4us.Explanationofbenefit, Err) {
  any_resp(resp, r4us.explanationofbenefit_decoder())
}

pub fn us_core_familymemberhistory_create_req(
  resource: r4us.UsCoreFamilymemberhistory,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    client,
  )
}

pub fn us_core_familymemberhistory_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "FamilyMemberHistory", client)
}

pub fn us_core_familymemberhistory_update_req(
  resource: r4us.UsCoreFamilymemberhistory,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    client,
  )
}

pub fn us_core_familymemberhistory_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "FamilyMemberHistory", client)
}

pub fn us_core_familymemberhistory_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreFamilymemberhistory, Err) {
  any_resp(resp, r4us.us_core_familymemberhistory_decoder())
}

pub fn flag_create_req(
  resource: r4us.Flag,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.flag_to_json(resource), "Flag", client)
}

pub fn flag_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Flag", client)
}

pub fn flag_update_req(
  resource: r4us.Flag,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4us.flag_to_json(resource), "Flag", client)
}

pub fn flag_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Flag", client)
}

pub fn flag_resp(resp: Response(String)) -> Result(r4us.Flag, Err) {
  any_resp(resp, r4us.flag_decoder())
}

pub fn us_core_goal_create_req(
  resource: r4us.UsCoreGoal,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.us_core_goal_to_json(resource), "Goal", client)
}

pub fn us_core_goal_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Goal", client)
}

pub fn us_core_goal_update_req(
  resource: r4us.UsCoreGoal,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_goal_to_json(resource),
    "Goal",
    client,
  )
}

pub fn us_core_goal_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Goal", client)
}

pub fn us_core_goal_resp(resp: Response(String)) -> Result(r4us.UsCoreGoal, Err) {
  any_resp(resp, r4us.us_core_goal_decoder())
}

pub fn graphdefinition_create_req(
  resource: r4us.Graphdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.graphdefinition_to_json(resource),
    "GraphDefinition",
    client,
  )
}

pub fn graphdefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "GraphDefinition", client)
}

pub fn graphdefinition_update_req(
  resource: r4us.Graphdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.graphdefinition_to_json(resource),
    "GraphDefinition",
    client,
  )
}

pub fn graphdefinition_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "GraphDefinition", client)
}

pub fn graphdefinition_resp(
  resp: Response(String),
) -> Result(r4us.Graphdefinition, Err) {
  any_resp(resp, r4us.graphdefinition_decoder())
}

pub fn group_create_req(
  resource: r4us.Group,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.group_to_json(resource), "Group", client)
}

pub fn group_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Group", client)
}

pub fn group_update_req(
  resource: r4us.Group,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4us.group_to_json(resource), "Group", client)
}

pub fn group_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Group", client)
}

pub fn group_resp(resp: Response(String)) -> Result(r4us.Group, Err) {
  any_resp(resp, r4us.group_decoder())
}

pub fn guidanceresponse_create_req(
  resource: r4us.Guidanceresponse,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.guidanceresponse_to_json(resource),
    "GuidanceResponse",
    client,
  )
}

pub fn guidanceresponse_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "GuidanceResponse", client)
}

pub fn guidanceresponse_update_req(
  resource: r4us.Guidanceresponse,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.guidanceresponse_to_json(resource),
    "GuidanceResponse",
    client,
  )
}

pub fn guidanceresponse_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "GuidanceResponse", client)
}

pub fn guidanceresponse_resp(
  resp: Response(String),
) -> Result(r4us.Guidanceresponse, Err) {
  any_resp(resp, r4us.guidanceresponse_decoder())
}

pub fn healthcareservice_create_req(
  resource: r4us.Healthcareservice,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.healthcareservice_to_json(resource),
    "HealthcareService",
    client,
  )
}

pub fn healthcareservice_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "HealthcareService", client)
}

pub fn healthcareservice_update_req(
  resource: r4us.Healthcareservice,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.healthcareservice_to_json(resource),
    "HealthcareService",
    client,
  )
}

pub fn healthcareservice_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "HealthcareService", client)
}

pub fn healthcareservice_resp(
  resp: Response(String),
) -> Result(r4us.Healthcareservice, Err) {
  any_resp(resp, r4us.healthcareservice_decoder())
}

pub fn imagingstudy_create_req(
  resource: r4us.Imagingstudy,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.imagingstudy_to_json(resource), "ImagingStudy", client)
}

pub fn imagingstudy_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "ImagingStudy", client)
}

pub fn imagingstudy_update_req(
  resource: r4us.Imagingstudy,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.imagingstudy_to_json(resource),
    "ImagingStudy",
    client,
  )
}

pub fn imagingstudy_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "ImagingStudy", client)
}

pub fn imagingstudy_resp(
  resp: Response(String),
) -> Result(r4us.Imagingstudy, Err) {
  any_resp(resp, r4us.imagingstudy_decoder())
}

pub fn us_core_immunization_create_req(
  resource: r4us.UsCoreImmunization,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_immunization_to_json(resource),
    "Immunization",
    client,
  )
}

pub fn us_core_immunization_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Immunization", client)
}

pub fn us_core_immunization_update_req(
  resource: r4us.UsCoreImmunization,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_immunization_to_json(resource),
    "Immunization",
    client,
  )
}

pub fn us_core_immunization_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Immunization", client)
}

pub fn us_core_immunization_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreImmunization, Err) {
  any_resp(resp, r4us.us_core_immunization_decoder())
}

pub fn immunizationevaluation_create_req(
  resource: r4us.Immunizationevaluation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.immunizationevaluation_to_json(resource),
    "ImmunizationEvaluation",
    client,
  )
}

pub fn immunizationevaluation_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "ImmunizationEvaluation", client)
}

pub fn immunizationevaluation_update_req(
  resource: r4us.Immunizationevaluation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.immunizationevaluation_to_json(resource),
    "ImmunizationEvaluation",
    client,
  )
}

pub fn immunizationevaluation_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "ImmunizationEvaluation", client)
}

pub fn immunizationevaluation_resp(
  resp: Response(String),
) -> Result(r4us.Immunizationevaluation, Err) {
  any_resp(resp, r4us.immunizationevaluation_decoder())
}

pub fn immunizationrecommendation_create_req(
  resource: r4us.Immunizationrecommendation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.immunizationrecommendation_to_json(resource),
    "ImmunizationRecommendation",
    client,
  )
}

pub fn immunizationrecommendation_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "ImmunizationRecommendation", client)
}

pub fn immunizationrecommendation_update_req(
  resource: r4us.Immunizationrecommendation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.immunizationrecommendation_to_json(resource),
    "ImmunizationRecommendation",
    client,
  )
}

pub fn immunizationrecommendation_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "ImmunizationRecommendation", client)
}

pub fn immunizationrecommendation_resp(
  resp: Response(String),
) -> Result(r4us.Immunizationrecommendation, Err) {
  any_resp(resp, r4us.immunizationrecommendation_decoder())
}

pub fn implementationguide_create_req(
  resource: r4us.Implementationguide,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.implementationguide_to_json(resource),
    "ImplementationGuide",
    client,
  )
}

pub fn implementationguide_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "ImplementationGuide", client)
}

pub fn implementationguide_update_req(
  resource: r4us.Implementationguide,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.implementationguide_to_json(resource),
    "ImplementationGuide",
    client,
  )
}

pub fn implementationguide_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "ImplementationGuide", client)
}

pub fn implementationguide_resp(
  resp: Response(String),
) -> Result(r4us.Implementationguide, Err) {
  any_resp(resp, r4us.implementationguide_decoder())
}

pub fn insuranceplan_create_req(
  resource: r4us.Insuranceplan,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.insuranceplan_to_json(resource), "InsurancePlan", client)
}

pub fn insuranceplan_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "InsurancePlan", client)
}

pub fn insuranceplan_update_req(
  resource: r4us.Insuranceplan,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.insuranceplan_to_json(resource),
    "InsurancePlan",
    client,
  )
}

pub fn insuranceplan_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "InsurancePlan", client)
}

pub fn insuranceplan_resp(
  resp: Response(String),
) -> Result(r4us.Insuranceplan, Err) {
  any_resp(resp, r4us.insuranceplan_decoder())
}

pub fn invoice_create_req(
  resource: r4us.Invoice,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.invoice_to_json(resource), "Invoice", client)
}

pub fn invoice_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Invoice", client)
}

pub fn invoice_update_req(
  resource: r4us.Invoice,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4us.invoice_to_json(resource), "Invoice", client)
}

pub fn invoice_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Invoice", client)
}

pub fn invoice_resp(resp: Response(String)) -> Result(r4us.Invoice, Err) {
  any_resp(resp, r4us.invoice_decoder())
}

pub fn library_create_req(
  resource: r4us.Library,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.library_to_json(resource), "Library", client)
}

pub fn library_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Library", client)
}

pub fn library_update_req(
  resource: r4us.Library,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4us.library_to_json(resource), "Library", client)
}

pub fn library_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Library", client)
}

pub fn library_resp(resp: Response(String)) -> Result(r4us.Library, Err) {
  any_resp(resp, r4us.library_decoder())
}

pub fn linkage_create_req(
  resource: r4us.Linkage,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.linkage_to_json(resource), "Linkage", client)
}

pub fn linkage_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Linkage", client)
}

pub fn linkage_update_req(
  resource: r4us.Linkage,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4us.linkage_to_json(resource), "Linkage", client)
}

pub fn linkage_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Linkage", client)
}

pub fn linkage_resp(resp: Response(String)) -> Result(r4us.Linkage, Err) {
  any_resp(resp, r4us.linkage_decoder())
}

pub fn listfhir_create_req(
  resource: r4us.Listfhir,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.listfhir_to_json(resource), "List", client)
}

pub fn listfhir_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "List", client)
}

pub fn listfhir_update_req(
  resource: r4us.Listfhir,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4us.listfhir_to_json(resource), "List", client)
}

pub fn listfhir_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "List", client)
}

pub fn listfhir_resp(resp: Response(String)) -> Result(r4us.Listfhir, Err) {
  any_resp(resp, r4us.listfhir_decoder())
}

pub fn us_core_location_create_req(
  resource: r4us.UsCoreLocation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.us_core_location_to_json(resource), "Location", client)
}

pub fn us_core_location_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Location", client)
}

pub fn us_core_location_update_req(
  resource: r4us.UsCoreLocation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_location_to_json(resource),
    "Location",
    client,
  )
}

pub fn us_core_location_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Location", client)
}

pub fn us_core_location_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreLocation, Err) {
  any_resp(resp, r4us.us_core_location_decoder())
}

pub fn measure_create_req(
  resource: r4us.Measure,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.measure_to_json(resource), "Measure", client)
}

pub fn measure_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Measure", client)
}

pub fn measure_update_req(
  resource: r4us.Measure,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4us.measure_to_json(resource), "Measure", client)
}

pub fn measure_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Measure", client)
}

pub fn measure_resp(resp: Response(String)) -> Result(r4us.Measure, Err) {
  any_resp(resp, r4us.measure_decoder())
}

pub fn measurereport_create_req(
  resource: r4us.Measurereport,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.measurereport_to_json(resource), "MeasureReport", client)
}

pub fn measurereport_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "MeasureReport", client)
}

pub fn measurereport_update_req(
  resource: r4us.Measurereport,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.measurereport_to_json(resource),
    "MeasureReport",
    client,
  )
}

pub fn measurereport_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "MeasureReport", client)
}

pub fn measurereport_resp(
  resp: Response(String),
) -> Result(r4us.Measurereport, Err) {
  any_resp(resp, r4us.measurereport_decoder())
}

pub fn media_create_req(
  resource: r4us.Media,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.media_to_json(resource), "Media", client)
}

pub fn media_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Media", client)
}

pub fn media_update_req(
  resource: r4us.Media,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4us.media_to_json(resource), "Media", client)
}

pub fn media_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Media", client)
}

pub fn media_resp(resp: Response(String)) -> Result(r4us.Media, Err) {
  any_resp(resp, r4us.media_decoder())
}

pub fn us_core_medication_create_req(
  resource: r4us.UsCoreMedication,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_medication_to_json(resource),
    "Medication",
    client,
  )
}

pub fn us_core_medication_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Medication", client)
}

pub fn us_core_medication_update_req(
  resource: r4us.UsCoreMedication,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_medication_to_json(resource),
    "Medication",
    client,
  )
}

pub fn us_core_medication_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Medication", client)
}

pub fn us_core_medication_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreMedication, Err) {
  any_resp(resp, r4us.us_core_medication_decoder())
}

pub fn medicationadministration_create_req(
  resource: r4us.Medicationadministration,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.medicationadministration_to_json(resource),
    "MedicationAdministration",
    client,
  )
}

pub fn medicationadministration_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "MedicationAdministration", client)
}

pub fn medicationadministration_update_req(
  resource: r4us.Medicationadministration,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.medicationadministration_to_json(resource),
    "MedicationAdministration",
    client,
  )
}

pub fn medicationadministration_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "MedicationAdministration", client)
}

pub fn medicationadministration_resp(
  resp: Response(String),
) -> Result(r4us.Medicationadministration, Err) {
  any_resp(resp, r4us.medicationadministration_decoder())
}

pub fn us_core_medicationdispense_create_req(
  resource: r4us.UsCoreMedicationdispense,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_medicationdispense_to_json(resource),
    "MedicationDispense",
    client,
  )
}

pub fn us_core_medicationdispense_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "MedicationDispense", client)
}

pub fn us_core_medicationdispense_update_req(
  resource: r4us.UsCoreMedicationdispense,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_medicationdispense_to_json(resource),
    "MedicationDispense",
    client,
  )
}

pub fn us_core_medicationdispense_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "MedicationDispense", client)
}

pub fn us_core_medicationdispense_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreMedicationdispense, Err) {
  any_resp(resp, r4us.us_core_medicationdispense_decoder())
}

pub fn medicationknowledge_create_req(
  resource: r4us.Medicationknowledge,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.medicationknowledge_to_json(resource),
    "MedicationKnowledge",
    client,
  )
}

pub fn medicationknowledge_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "MedicationKnowledge", client)
}

pub fn medicationknowledge_update_req(
  resource: r4us.Medicationknowledge,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.medicationknowledge_to_json(resource),
    "MedicationKnowledge",
    client,
  )
}

pub fn medicationknowledge_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "MedicationKnowledge", client)
}

pub fn medicationknowledge_resp(
  resp: Response(String),
) -> Result(r4us.Medicationknowledge, Err) {
  any_resp(resp, r4us.medicationknowledge_decoder())
}

pub fn us_core_medicationrequest_create_req(
  resource: r4us.UsCoreMedicationrequest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_medicationrequest_to_json(resource),
    "MedicationRequest",
    client,
  )
}

pub fn us_core_medicationrequest_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "MedicationRequest", client)
}

pub fn us_core_medicationrequest_update_req(
  resource: r4us.UsCoreMedicationrequest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_medicationrequest_to_json(resource),
    "MedicationRequest",
    client,
  )
}

pub fn us_core_medicationrequest_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "MedicationRequest", client)
}

pub fn us_core_medicationrequest_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreMedicationrequest, Err) {
  any_resp(resp, r4us.us_core_medicationrequest_decoder())
}

pub fn medicationstatement_create_req(
  resource: r4us.Medicationstatement,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.medicationstatement_to_json(resource),
    "MedicationStatement",
    client,
  )
}

pub fn medicationstatement_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "MedicationStatement", client)
}

pub fn medicationstatement_update_req(
  resource: r4us.Medicationstatement,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.medicationstatement_to_json(resource),
    "MedicationStatement",
    client,
  )
}

pub fn medicationstatement_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "MedicationStatement", client)
}

pub fn medicationstatement_resp(
  resp: Response(String),
) -> Result(r4us.Medicationstatement, Err) {
  any_resp(resp, r4us.medicationstatement_decoder())
}

pub fn medicinalproduct_create_req(
  resource: r4us.Medicinalproduct,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.medicinalproduct_to_json(resource),
    "MedicinalProduct",
    client,
  )
}

pub fn medicinalproduct_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "MedicinalProduct", client)
}

pub fn medicinalproduct_update_req(
  resource: r4us.Medicinalproduct,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.medicinalproduct_to_json(resource),
    "MedicinalProduct",
    client,
  )
}

pub fn medicinalproduct_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "MedicinalProduct", client)
}

pub fn medicinalproduct_resp(
  resp: Response(String),
) -> Result(r4us.Medicinalproduct, Err) {
  any_resp(resp, r4us.medicinalproduct_decoder())
}

pub fn medicinalproductauthorization_create_req(
  resource: r4us.Medicinalproductauthorization,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.medicinalproductauthorization_to_json(resource),
    "MedicinalProductAuthorization",
    client,
  )
}

pub fn medicinalproductauthorization_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "MedicinalProductAuthorization", client)
}

pub fn medicinalproductauthorization_update_req(
  resource: r4us.Medicinalproductauthorization,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.medicinalproductauthorization_to_json(resource),
    "MedicinalProductAuthorization",
    client,
  )
}

pub fn medicinalproductauthorization_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "MedicinalProductAuthorization", client)
}

pub fn medicinalproductauthorization_resp(
  resp: Response(String),
) -> Result(r4us.Medicinalproductauthorization, Err) {
  any_resp(resp, r4us.medicinalproductauthorization_decoder())
}

pub fn medicinalproductcontraindication_create_req(
  resource: r4us.Medicinalproductcontraindication,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.medicinalproductcontraindication_to_json(resource),
    "MedicinalProductContraindication",
    client,
  )
}

pub fn medicinalproductcontraindication_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "MedicinalProductContraindication", client)
}

pub fn medicinalproductcontraindication_update_req(
  resource: r4us.Medicinalproductcontraindication,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.medicinalproductcontraindication_to_json(resource),
    "MedicinalProductContraindication",
    client,
  )
}

pub fn medicinalproductcontraindication_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "MedicinalProductContraindication", client)
}

pub fn medicinalproductcontraindication_resp(
  resp: Response(String),
) -> Result(r4us.Medicinalproductcontraindication, Err) {
  any_resp(resp, r4us.medicinalproductcontraindication_decoder())
}

pub fn medicinalproductindication_create_req(
  resource: r4us.Medicinalproductindication,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.medicinalproductindication_to_json(resource),
    "MedicinalProductIndication",
    client,
  )
}

pub fn medicinalproductindication_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "MedicinalProductIndication", client)
}

pub fn medicinalproductindication_update_req(
  resource: r4us.Medicinalproductindication,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.medicinalproductindication_to_json(resource),
    "MedicinalProductIndication",
    client,
  )
}

pub fn medicinalproductindication_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "MedicinalProductIndication", client)
}

pub fn medicinalproductindication_resp(
  resp: Response(String),
) -> Result(r4us.Medicinalproductindication, Err) {
  any_resp(resp, r4us.medicinalproductindication_decoder())
}

pub fn medicinalproductingredient_create_req(
  resource: r4us.Medicinalproductingredient,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.medicinalproductingredient_to_json(resource),
    "MedicinalProductIngredient",
    client,
  )
}

pub fn medicinalproductingredient_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "MedicinalProductIngredient", client)
}

pub fn medicinalproductingredient_update_req(
  resource: r4us.Medicinalproductingredient,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.medicinalproductingredient_to_json(resource),
    "MedicinalProductIngredient",
    client,
  )
}

pub fn medicinalproductingredient_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "MedicinalProductIngredient", client)
}

pub fn medicinalproductingredient_resp(
  resp: Response(String),
) -> Result(r4us.Medicinalproductingredient, Err) {
  any_resp(resp, r4us.medicinalproductingredient_decoder())
}

pub fn medicinalproductinteraction_create_req(
  resource: r4us.Medicinalproductinteraction,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.medicinalproductinteraction_to_json(resource),
    "MedicinalProductInteraction",
    client,
  )
}

pub fn medicinalproductinteraction_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "MedicinalProductInteraction", client)
}

pub fn medicinalproductinteraction_update_req(
  resource: r4us.Medicinalproductinteraction,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.medicinalproductinteraction_to_json(resource),
    "MedicinalProductInteraction",
    client,
  )
}

pub fn medicinalproductinteraction_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "MedicinalProductInteraction", client)
}

pub fn medicinalproductinteraction_resp(
  resp: Response(String),
) -> Result(r4us.Medicinalproductinteraction, Err) {
  any_resp(resp, r4us.medicinalproductinteraction_decoder())
}

pub fn medicinalproductmanufactured_create_req(
  resource: r4us.Medicinalproductmanufactured,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.medicinalproductmanufactured_to_json(resource),
    "MedicinalProductManufactured",
    client,
  )
}

pub fn medicinalproductmanufactured_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "MedicinalProductManufactured", client)
}

pub fn medicinalproductmanufactured_update_req(
  resource: r4us.Medicinalproductmanufactured,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.medicinalproductmanufactured_to_json(resource),
    "MedicinalProductManufactured",
    client,
  )
}

pub fn medicinalproductmanufactured_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "MedicinalProductManufactured", client)
}

pub fn medicinalproductmanufactured_resp(
  resp: Response(String),
) -> Result(r4us.Medicinalproductmanufactured, Err) {
  any_resp(resp, r4us.medicinalproductmanufactured_decoder())
}

pub fn medicinalproductpackaged_create_req(
  resource: r4us.Medicinalproductpackaged,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.medicinalproductpackaged_to_json(resource),
    "MedicinalProductPackaged",
    client,
  )
}

pub fn medicinalproductpackaged_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "MedicinalProductPackaged", client)
}

pub fn medicinalproductpackaged_update_req(
  resource: r4us.Medicinalproductpackaged,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.medicinalproductpackaged_to_json(resource),
    "MedicinalProductPackaged",
    client,
  )
}

pub fn medicinalproductpackaged_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "MedicinalProductPackaged", client)
}

pub fn medicinalproductpackaged_resp(
  resp: Response(String),
) -> Result(r4us.Medicinalproductpackaged, Err) {
  any_resp(resp, r4us.medicinalproductpackaged_decoder())
}

pub fn medicinalproductpharmaceutical_create_req(
  resource: r4us.Medicinalproductpharmaceutical,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.medicinalproductpharmaceutical_to_json(resource),
    "MedicinalProductPharmaceutical",
    client,
  )
}

pub fn medicinalproductpharmaceutical_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "MedicinalProductPharmaceutical", client)
}

pub fn medicinalproductpharmaceutical_update_req(
  resource: r4us.Medicinalproductpharmaceutical,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.medicinalproductpharmaceutical_to_json(resource),
    "MedicinalProductPharmaceutical",
    client,
  )
}

pub fn medicinalproductpharmaceutical_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "MedicinalProductPharmaceutical", client)
}

pub fn medicinalproductpharmaceutical_resp(
  resp: Response(String),
) -> Result(r4us.Medicinalproductpharmaceutical, Err) {
  any_resp(resp, r4us.medicinalproductpharmaceutical_decoder())
}

pub fn medicinalproductundesirableeffect_create_req(
  resource: r4us.Medicinalproductundesirableeffect,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.medicinalproductundesirableeffect_to_json(resource),
    "MedicinalProductUndesirableEffect",
    client,
  )
}

pub fn medicinalproductundesirableeffect_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "MedicinalProductUndesirableEffect", client)
}

pub fn medicinalproductundesirableeffect_update_req(
  resource: r4us.Medicinalproductundesirableeffect,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.medicinalproductundesirableeffect_to_json(resource),
    "MedicinalProductUndesirableEffect",
    client,
  )
}

pub fn medicinalproductundesirableeffect_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "MedicinalProductUndesirableEffect", client)
}

pub fn medicinalproductundesirableeffect_resp(
  resp: Response(String),
) -> Result(r4us.Medicinalproductundesirableeffect, Err) {
  any_resp(resp, r4us.medicinalproductundesirableeffect_decoder())
}

pub fn messagedefinition_create_req(
  resource: r4us.Messagedefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.messagedefinition_to_json(resource),
    "MessageDefinition",
    client,
  )
}

pub fn messagedefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "MessageDefinition", client)
}

pub fn messagedefinition_update_req(
  resource: r4us.Messagedefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.messagedefinition_to_json(resource),
    "MessageDefinition",
    client,
  )
}

pub fn messagedefinition_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "MessageDefinition", client)
}

pub fn messagedefinition_resp(
  resp: Response(String),
) -> Result(r4us.Messagedefinition, Err) {
  any_resp(resp, r4us.messagedefinition_decoder())
}

pub fn messageheader_create_req(
  resource: r4us.Messageheader,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.messageheader_to_json(resource), "MessageHeader", client)
}

pub fn messageheader_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "MessageHeader", client)
}

pub fn messageheader_update_req(
  resource: r4us.Messageheader,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.messageheader_to_json(resource),
    "MessageHeader",
    client,
  )
}

pub fn messageheader_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "MessageHeader", client)
}

pub fn messageheader_resp(
  resp: Response(String),
) -> Result(r4us.Messageheader, Err) {
  any_resp(resp, r4us.messageheader_decoder())
}

pub fn molecularsequence_create_req(
  resource: r4us.Molecularsequence,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.molecularsequence_to_json(resource),
    "MolecularSequence",
    client,
  )
}

pub fn molecularsequence_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "MolecularSequence", client)
}

pub fn molecularsequence_update_req(
  resource: r4us.Molecularsequence,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.molecularsequence_to_json(resource),
    "MolecularSequence",
    client,
  )
}

pub fn molecularsequence_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "MolecularSequence", client)
}

pub fn molecularsequence_resp(
  resp: Response(String),
) -> Result(r4us.Molecularsequence, Err) {
  any_resp(resp, r4us.molecularsequence_decoder())
}

pub fn namingsystem_create_req(
  resource: r4us.Namingsystem,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.namingsystem_to_json(resource), "NamingSystem", client)
}

pub fn namingsystem_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "NamingSystem", client)
}

pub fn namingsystem_update_req(
  resource: r4us.Namingsystem,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.namingsystem_to_json(resource),
    "NamingSystem",
    client,
  )
}

pub fn namingsystem_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "NamingSystem", client)
}

pub fn namingsystem_resp(
  resp: Response(String),
) -> Result(r4us.Namingsystem, Err) {
  any_resp(resp, r4us.namingsystem_decoder())
}

pub fn nutritionorder_create_req(
  resource: r4us.Nutritionorder,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.nutritionorder_to_json(resource),
    "NutritionOrder",
    client,
  )
}

pub fn nutritionorder_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "NutritionOrder", client)
}

pub fn nutritionorder_update_req(
  resource: r4us.Nutritionorder,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.nutritionorder_to_json(resource),
    "NutritionOrder",
    client,
  )
}

pub fn nutritionorder_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "NutritionOrder", client)
}

pub fn nutritionorder_resp(
  resp: Response(String),
) -> Result(r4us.Nutritionorder, Err) {
  any_resp(resp, r4us.nutritionorder_decoder())
}

pub fn us_core_body_temperature_create_req(
  resource: r4us.UsCoreBodyTemperature,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_body_temperature_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_body_temperature_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Observation", client)
}

pub fn us_core_body_temperature_update_req(
  resource: r4us.UsCoreBodyTemperature,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_body_temperature_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_body_temperature_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Observation", client)
}

pub fn us_core_body_temperature_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreBodyTemperature, Err) {
  any_resp(resp, r4us.us_core_body_temperature_decoder())
}

pub fn us_core_observation_clinical_result_create_req(
  resource: r4us.UsCoreObservationClinicalResult,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_observation_clinical_result_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_observation_clinical_result_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Observation", client)
}

pub fn us_core_observation_clinical_result_update_req(
  resource: r4us.UsCoreObservationClinicalResult,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_observation_clinical_result_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_observation_clinical_result_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Observation", client)
}

pub fn us_core_observation_clinical_result_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreObservationClinicalResult, Err) {
  any_resp(resp, r4us.us_core_observation_clinical_result_decoder())
}

pub fn us_core_observation_lab_create_req(
  resource: r4us.UsCoreObservationLab,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_observation_lab_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_observation_lab_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Observation", client)
}

pub fn us_core_observation_lab_update_req(
  resource: r4us.UsCoreObservationLab,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_observation_lab_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_observation_lab_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Observation", client)
}

pub fn us_core_observation_lab_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreObservationLab, Err) {
  any_resp(resp, r4us.us_core_observation_lab_decoder())
}

pub fn us_core_treatment_intervention_preference_create_req(
  resource: r4us.UsCoreTreatmentInterventionPreference,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_treatment_intervention_preference_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_treatment_intervention_preference_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Observation", client)
}

pub fn us_core_treatment_intervention_preference_update_req(
  resource: r4us.UsCoreTreatmentInterventionPreference,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_treatment_intervention_preference_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_treatment_intervention_preference_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Observation", client)
}

pub fn us_core_treatment_intervention_preference_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreTreatmentInterventionPreference, Err) {
  any_resp(resp, r4us.us_core_treatment_intervention_preference_decoder())
}

pub fn us_core_observation_pregnancyintent_create_req(
  resource: r4us.UsCoreObservationPregnancyintent,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_observation_pregnancyintent_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_observation_pregnancyintent_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Observation", client)
}

pub fn us_core_observation_pregnancyintent_update_req(
  resource: r4us.UsCoreObservationPregnancyintent,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_observation_pregnancyintent_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_observation_pregnancyintent_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Observation", client)
}

pub fn us_core_observation_pregnancyintent_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreObservationPregnancyintent, Err) {
  any_resp(resp, r4us.us_core_observation_pregnancyintent_decoder())
}

pub fn us_core_simple_observation_create_req(
  resource: r4us.UsCoreSimpleObservation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_simple_observation_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_simple_observation_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Observation", client)
}

pub fn us_core_simple_observation_update_req(
  resource: r4us.UsCoreSimpleObservation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_simple_observation_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_simple_observation_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Observation", client)
}

pub fn us_core_simple_observation_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreSimpleObservation, Err) {
  any_resp(resp, r4us.us_core_simple_observation_decoder())
}

pub fn us_core_respiratory_rate_create_req(
  resource: r4us.UsCoreRespiratoryRate,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_respiratory_rate_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_respiratory_rate_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Observation", client)
}

pub fn us_core_respiratory_rate_update_req(
  resource: r4us.UsCoreRespiratoryRate,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_respiratory_rate_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_respiratory_rate_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Observation", client)
}

pub fn us_core_respiratory_rate_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreRespiratoryRate, Err) {
  any_resp(resp, r4us.us_core_respiratory_rate_decoder())
}

pub fn us_core_observation_occupation_create_req(
  resource: r4us.UsCoreObservationOccupation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_observation_occupation_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_observation_occupation_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Observation", client)
}

pub fn us_core_observation_occupation_update_req(
  resource: r4us.UsCoreObservationOccupation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_observation_occupation_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_observation_occupation_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Observation", client)
}

pub fn us_core_observation_occupation_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreObservationOccupation, Err) {
  any_resp(resp, r4us.us_core_observation_occupation_decoder())
}

pub fn us_core_vital_signs_create_req(
  resource: r4us.UsCoreVitalSigns,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_vital_signs_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_vital_signs_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Observation", client)
}

pub fn us_core_vital_signs_update_req(
  resource: r4us.UsCoreVitalSigns,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_vital_signs_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_vital_signs_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Observation", client)
}

pub fn us_core_vital_signs_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreVitalSigns, Err) {
  any_resp(resp, r4us.us_core_vital_signs_decoder())
}

pub fn us_core_body_weight_create_req(
  resource: r4us.UsCoreBodyWeight,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_body_weight_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_body_weight_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Observation", client)
}

pub fn us_core_body_weight_update_req(
  resource: r4us.UsCoreBodyWeight,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_body_weight_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_body_weight_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Observation", client)
}

pub fn us_core_body_weight_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreBodyWeight, Err) {
  any_resp(resp, r4us.us_core_body_weight_decoder())
}

pub fn us_core_observation_pregnancystatus_create_req(
  resource: r4us.UsCoreObservationPregnancystatus,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_observation_pregnancystatus_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_observation_pregnancystatus_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Observation", client)
}

pub fn us_core_observation_pregnancystatus_update_req(
  resource: r4us.UsCoreObservationPregnancystatus,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_observation_pregnancystatus_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_observation_pregnancystatus_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Observation", client)
}

pub fn us_core_observation_pregnancystatus_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreObservationPregnancystatus, Err) {
  any_resp(resp, r4us.us_core_observation_pregnancystatus_decoder())
}

pub fn us_core_blood_pressure_create_req(
  resource: r4us.UsCoreBloodPressure,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_blood_pressure_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_blood_pressure_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Observation", client)
}

pub fn us_core_blood_pressure_update_req(
  resource: r4us.UsCoreBloodPressure,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_blood_pressure_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_blood_pressure_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Observation", client)
}

pub fn us_core_blood_pressure_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreBloodPressure, Err) {
  any_resp(resp, r4us.us_core_blood_pressure_decoder())
}

pub fn pediatric_bmi_for_age_create_req(
  resource: r4us.PediatricBmiForAge,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.pediatric_bmi_for_age_to_json(resource),
    "Observation",
    client,
  )
}

pub fn pediatric_bmi_for_age_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Observation", client)
}

pub fn pediatric_bmi_for_age_update_req(
  resource: r4us.PediatricBmiForAge,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.pediatric_bmi_for_age_to_json(resource),
    "Observation",
    client,
  )
}

pub fn pediatric_bmi_for_age_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Observation", client)
}

pub fn pediatric_bmi_for_age_resp(
  resp: Response(String),
) -> Result(r4us.PediatricBmiForAge, Err) {
  any_resp(resp, r4us.pediatric_bmi_for_age_decoder())
}

pub fn us_core_care_experience_preference_create_req(
  resource: r4us.UsCoreCareExperiencePreference,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_care_experience_preference_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_care_experience_preference_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Observation", client)
}

pub fn us_core_care_experience_preference_update_req(
  resource: r4us.UsCoreCareExperiencePreference,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_care_experience_preference_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_care_experience_preference_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Observation", client)
}

pub fn us_core_care_experience_preference_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreCareExperiencePreference, Err) {
  any_resp(resp, r4us.us_core_care_experience_preference_decoder())
}

pub fn us_core_observation_screening_assessment_create_req(
  resource: r4us.UsCoreObservationScreeningAssessment,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_observation_screening_assessment_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_observation_screening_assessment_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Observation", client)
}

pub fn us_core_observation_screening_assessment_update_req(
  resource: r4us.UsCoreObservationScreeningAssessment,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_observation_screening_assessment_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_observation_screening_assessment_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Observation", client)
}

pub fn us_core_observation_screening_assessment_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreObservationScreeningAssessment, Err) {
  any_resp(resp, r4us.us_core_observation_screening_assessment_decoder())
}

pub fn us_core_head_circumference_create_req(
  resource: r4us.UsCoreHeadCircumference,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_head_circumference_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_head_circumference_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Observation", client)
}

pub fn us_core_head_circumference_update_req(
  resource: r4us.UsCoreHeadCircumference,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_head_circumference_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_head_circumference_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Observation", client)
}

pub fn us_core_head_circumference_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreHeadCircumference, Err) {
  any_resp(resp, r4us.us_core_head_circumference_decoder())
}

pub fn us_core_heart_rate_create_req(
  resource: r4us.UsCoreHeartRate,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_heart_rate_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_heart_rate_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Observation", client)
}

pub fn us_core_heart_rate_update_req(
  resource: r4us.UsCoreHeartRate,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_heart_rate_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_heart_rate_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Observation", client)
}

pub fn us_core_heart_rate_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreHeartRate, Err) {
  any_resp(resp, r4us.us_core_heart_rate_decoder())
}

pub fn us_core_observation_sexual_orientation_create_req(
  resource: r4us.UsCoreObservationSexualOrientation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_observation_sexual_orientation_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_observation_sexual_orientation_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Observation", client)
}

pub fn us_core_observation_sexual_orientation_update_req(
  resource: r4us.UsCoreObservationSexualOrientation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_observation_sexual_orientation_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_observation_sexual_orientation_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Observation", client)
}

pub fn us_core_observation_sexual_orientation_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreObservationSexualOrientation, Err) {
  any_resp(resp, r4us.us_core_observation_sexual_orientation_decoder())
}

pub fn pediatric_weight_for_height_create_req(
  resource: r4us.PediatricWeightForHeight,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.pediatric_weight_for_height_to_json(resource),
    "Observation",
    client,
  )
}

pub fn pediatric_weight_for_height_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Observation", client)
}

pub fn pediatric_weight_for_height_update_req(
  resource: r4us.PediatricWeightForHeight,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.pediatric_weight_for_height_to_json(resource),
    "Observation",
    client,
  )
}

pub fn pediatric_weight_for_height_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Observation", client)
}

pub fn pediatric_weight_for_height_resp(
  resp: Response(String),
) -> Result(r4us.PediatricWeightForHeight, Err) {
  any_resp(resp, r4us.pediatric_weight_for_height_decoder())
}

pub fn us_core_bmi_create_req(
  resource: r4us.UsCoreBmi,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.us_core_bmi_to_json(resource), "Observation", client)
}

pub fn us_core_bmi_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Observation", client)
}

pub fn us_core_bmi_update_req(
  resource: r4us.UsCoreBmi,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_bmi_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_bmi_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Observation", client)
}

pub fn us_core_bmi_resp(resp: Response(String)) -> Result(r4us.UsCoreBmi, Err) {
  any_resp(resp, r4us.us_core_bmi_decoder())
}

pub fn us_core_body_height_create_req(
  resource: r4us.UsCoreBodyHeight,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_body_height_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_body_height_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Observation", client)
}

pub fn us_core_body_height_update_req(
  resource: r4us.UsCoreBodyHeight,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_body_height_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_body_height_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Observation", client)
}

pub fn us_core_body_height_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreBodyHeight, Err) {
  any_resp(resp, r4us.us_core_body_height_decoder())
}

pub fn us_core_smokingstatus_create_req(
  resource: r4us.UsCoreSmokingstatus,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_smokingstatus_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_smokingstatus_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Observation", client)
}

pub fn us_core_smokingstatus_update_req(
  resource: r4us.UsCoreSmokingstatus,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_smokingstatus_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_smokingstatus_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Observation", client)
}

pub fn us_core_smokingstatus_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreSmokingstatus, Err) {
  any_resp(resp, r4us.us_core_smokingstatus_decoder())
}

pub fn us_core_pulse_oximetry_create_req(
  resource: r4us.UsCorePulseOximetry,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_pulse_oximetry_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_pulse_oximetry_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Observation", client)
}

pub fn us_core_pulse_oximetry_update_req(
  resource: r4us.UsCorePulseOximetry,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_pulse_oximetry_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_pulse_oximetry_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Observation", client)
}

pub fn us_core_pulse_oximetry_resp(
  resp: Response(String),
) -> Result(r4us.UsCorePulseOximetry, Err) {
  any_resp(resp, r4us.us_core_pulse_oximetry_decoder())
}

pub fn head_occipital_frontal_circumference_percentile_create_req(
  resource: r4us.HeadOccipitalFrontalCircumferencePercentile,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.head_occipital_frontal_circumference_percentile_to_json(resource),
    "Observation",
    client,
  )
}

pub fn head_occipital_frontal_circumference_percentile_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Observation", client)
}

pub fn head_occipital_frontal_circumference_percentile_update_req(
  resource: r4us.HeadOccipitalFrontalCircumferencePercentile,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.head_occipital_frontal_circumference_percentile_to_json(resource),
    "Observation",
    client,
  )
}

pub fn head_occipital_frontal_circumference_percentile_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Observation", client)
}

pub fn head_occipital_frontal_circumference_percentile_resp(
  resp: Response(String),
) -> Result(r4us.HeadOccipitalFrontalCircumferencePercentile, Err) {
  any_resp(resp, r4us.head_occipital_frontal_circumference_percentile_decoder())
}

pub fn us_core_average_blood_pressure_create_req(
  resource: r4us.UsCoreAverageBloodPressure,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_average_blood_pressure_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_average_blood_pressure_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Observation", client)
}

pub fn us_core_average_blood_pressure_update_req(
  resource: r4us.UsCoreAverageBloodPressure,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_average_blood_pressure_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_average_blood_pressure_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Observation", client)
}

pub fn us_core_average_blood_pressure_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreAverageBloodPressure, Err) {
  any_resp(resp, r4us.us_core_average_blood_pressure_decoder())
}

pub fn us_core_observation_adi_documentation_create_req(
  resource: r4us.UsCoreObservationAdiDocumentation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_observation_adi_documentation_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_observation_adi_documentation_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Observation", client)
}

pub fn us_core_observation_adi_documentation_update_req(
  resource: r4us.UsCoreObservationAdiDocumentation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_observation_adi_documentation_to_json(resource),
    "Observation",
    client,
  )
}

pub fn us_core_observation_adi_documentation_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Observation", client)
}

pub fn us_core_observation_adi_documentation_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreObservationAdiDocumentation, Err) {
  any_resp(resp, r4us.us_core_observation_adi_documentation_decoder())
}

pub fn observationdefinition_create_req(
  resource: r4us.Observationdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.observationdefinition_to_json(resource),
    "ObservationDefinition",
    client,
  )
}

pub fn observationdefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "ObservationDefinition", client)
}

pub fn observationdefinition_update_req(
  resource: r4us.Observationdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.observationdefinition_to_json(resource),
    "ObservationDefinition",
    client,
  )
}

pub fn observationdefinition_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "ObservationDefinition", client)
}

pub fn observationdefinition_resp(
  resp: Response(String),
) -> Result(r4us.Observationdefinition, Err) {
  any_resp(resp, r4us.observationdefinition_decoder())
}

pub fn operationdefinition_create_req(
  resource: r4us.Operationdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.operationdefinition_to_json(resource),
    "OperationDefinition",
    client,
  )
}

pub fn operationdefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "OperationDefinition", client)
}

pub fn operationdefinition_update_req(
  resource: r4us.Operationdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.operationdefinition_to_json(resource),
    "OperationDefinition",
    client,
  )
}

pub fn operationdefinition_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "OperationDefinition", client)
}

pub fn operationdefinition_resp(
  resp: Response(String),
) -> Result(r4us.Operationdefinition, Err) {
  any_resp(resp, r4us.operationdefinition_decoder())
}

pub fn operationoutcome_create_req(
  resource: r4us.Operationoutcome,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.operationoutcome_to_json(resource),
    "OperationOutcome",
    client,
  )
}

pub fn operationoutcome_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "OperationOutcome", client)
}

pub fn operationoutcome_update_req(
  resource: r4us.Operationoutcome,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.operationoutcome_to_json(resource),
    "OperationOutcome",
    client,
  )
}

pub fn operationoutcome_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "OperationOutcome", client)
}

pub fn operationoutcome_resp(
  resp: Response(String),
) -> Result(r4us.Operationoutcome, Err) {
  any_resp(resp, r4us.operationoutcome_decoder())
}

pub fn us_core_organization_create_req(
  resource: r4us.UsCoreOrganization,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_organization_to_json(resource),
    "Organization",
    client,
  )
}

pub fn us_core_organization_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Organization", client)
}

pub fn us_core_organization_update_req(
  resource: r4us.UsCoreOrganization,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_organization_to_json(resource),
    "Organization",
    client,
  )
}

pub fn us_core_organization_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Organization", client)
}

pub fn us_core_organization_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreOrganization, Err) {
  any_resp(resp, r4us.us_core_organization_decoder())
}

pub fn organizationaffiliation_create_req(
  resource: r4us.Organizationaffiliation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.organizationaffiliation_to_json(resource),
    "OrganizationAffiliation",
    client,
  )
}

pub fn organizationaffiliation_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "OrganizationAffiliation", client)
}

pub fn organizationaffiliation_update_req(
  resource: r4us.Organizationaffiliation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.organizationaffiliation_to_json(resource),
    "OrganizationAffiliation",
    client,
  )
}

pub fn organizationaffiliation_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "OrganizationAffiliation", client)
}

pub fn organizationaffiliation_resp(
  resp: Response(String),
) -> Result(r4us.Organizationaffiliation, Err) {
  any_resp(resp, r4us.organizationaffiliation_decoder())
}

pub fn us_core_patient_create_req(
  resource: r4us.UsCorePatient,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.us_core_patient_to_json(resource), "Patient", client)
}

pub fn us_core_patient_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Patient", client)
}

pub fn us_core_patient_update_req(
  resource: r4us.UsCorePatient,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_patient_to_json(resource),
    "Patient",
    client,
  )
}

pub fn us_core_patient_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Patient", client)
}

pub fn us_core_patient_resp(
  resp: Response(String),
) -> Result(r4us.UsCorePatient, Err) {
  any_resp(resp, r4us.us_core_patient_decoder())
}

pub fn paymentnotice_create_req(
  resource: r4us.Paymentnotice,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.paymentnotice_to_json(resource), "PaymentNotice", client)
}

pub fn paymentnotice_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "PaymentNotice", client)
}

pub fn paymentnotice_update_req(
  resource: r4us.Paymentnotice,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.paymentnotice_to_json(resource),
    "PaymentNotice",
    client,
  )
}

pub fn paymentnotice_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "PaymentNotice", client)
}

pub fn paymentnotice_resp(
  resp: Response(String),
) -> Result(r4us.Paymentnotice, Err) {
  any_resp(resp, r4us.paymentnotice_decoder())
}

pub fn paymentreconciliation_create_req(
  resource: r4us.Paymentreconciliation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.paymentreconciliation_to_json(resource),
    "PaymentReconciliation",
    client,
  )
}

pub fn paymentreconciliation_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "PaymentReconciliation", client)
}

pub fn paymentreconciliation_update_req(
  resource: r4us.Paymentreconciliation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.paymentreconciliation_to_json(resource),
    "PaymentReconciliation",
    client,
  )
}

pub fn paymentreconciliation_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "PaymentReconciliation", client)
}

pub fn paymentreconciliation_resp(
  resp: Response(String),
) -> Result(r4us.Paymentreconciliation, Err) {
  any_resp(resp, r4us.paymentreconciliation_decoder())
}

pub fn person_create_req(
  resource: r4us.Person,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.person_to_json(resource), "Person", client)
}

pub fn person_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Person", client)
}

pub fn person_update_req(
  resource: r4us.Person,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4us.person_to_json(resource), "Person", client)
}

pub fn person_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Person", client)
}

pub fn person_resp(resp: Response(String)) -> Result(r4us.Person, Err) {
  any_resp(resp, r4us.person_decoder())
}

pub fn plandefinition_create_req(
  resource: r4us.Plandefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.plandefinition_to_json(resource),
    "PlanDefinition",
    client,
  )
}

pub fn plandefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "PlanDefinition", client)
}

pub fn plandefinition_update_req(
  resource: r4us.Plandefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.plandefinition_to_json(resource),
    "PlanDefinition",
    client,
  )
}

pub fn plandefinition_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "PlanDefinition", client)
}

pub fn plandefinition_resp(
  resp: Response(String),
) -> Result(r4us.Plandefinition, Err) {
  any_resp(resp, r4us.plandefinition_decoder())
}

pub fn us_core_practitioner_create_req(
  resource: r4us.UsCorePractitioner,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_practitioner_to_json(resource),
    "Practitioner",
    client,
  )
}

pub fn us_core_practitioner_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Practitioner", client)
}

pub fn us_core_practitioner_update_req(
  resource: r4us.UsCorePractitioner,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_practitioner_to_json(resource),
    "Practitioner",
    client,
  )
}

pub fn us_core_practitioner_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Practitioner", client)
}

pub fn us_core_practitioner_resp(
  resp: Response(String),
) -> Result(r4us.UsCorePractitioner, Err) {
  any_resp(resp, r4us.us_core_practitioner_decoder())
}

pub fn us_core_practitionerrole_create_req(
  resource: r4us.UsCorePractitionerrole,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_practitionerrole_to_json(resource),
    "PractitionerRole",
    client,
  )
}

pub fn us_core_practitionerrole_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "PractitionerRole", client)
}

pub fn us_core_practitionerrole_update_req(
  resource: r4us.UsCorePractitionerrole,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_practitionerrole_to_json(resource),
    "PractitionerRole",
    client,
  )
}

pub fn us_core_practitionerrole_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "PractitionerRole", client)
}

pub fn us_core_practitionerrole_resp(
  resp: Response(String),
) -> Result(r4us.UsCorePractitionerrole, Err) {
  any_resp(resp, r4us.us_core_practitionerrole_decoder())
}

pub fn us_core_procedure_create_req(
  resource: r4us.UsCoreProcedure,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.us_core_procedure_to_json(resource), "Procedure", client)
}

pub fn us_core_procedure_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Procedure", client)
}

pub fn us_core_procedure_update_req(
  resource: r4us.UsCoreProcedure,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_procedure_to_json(resource),
    "Procedure",
    client,
  )
}

pub fn us_core_procedure_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Procedure", client)
}

pub fn us_core_procedure_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreProcedure, Err) {
  any_resp(resp, r4us.us_core_procedure_decoder())
}

pub fn us_core_provenance_create_req(
  resource: r4us.UsCoreProvenance,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_provenance_to_json(resource),
    "Provenance",
    client,
  )
}

pub fn us_core_provenance_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Provenance", client)
}

pub fn us_core_provenance_update_req(
  resource: r4us.UsCoreProvenance,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_provenance_to_json(resource),
    "Provenance",
    client,
  )
}

pub fn us_core_provenance_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Provenance", client)
}

pub fn us_core_provenance_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreProvenance, Err) {
  any_resp(resp, r4us.us_core_provenance_decoder())
}

pub fn questionnaire_create_req(
  resource: r4us.Questionnaire,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.questionnaire_to_json(resource), "Questionnaire", client)
}

pub fn questionnaire_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Questionnaire", client)
}

pub fn questionnaire_update_req(
  resource: r4us.Questionnaire,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.questionnaire_to_json(resource),
    "Questionnaire",
    client,
  )
}

pub fn questionnaire_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Questionnaire", client)
}

pub fn questionnaire_resp(
  resp: Response(String),
) -> Result(r4us.Questionnaire, Err) {
  any_resp(resp, r4us.questionnaire_decoder())
}

pub fn us_core_questionnaireresponse_create_req(
  resource: r4us.UsCoreQuestionnaireresponse,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    client,
  )
}

pub fn us_core_questionnaireresponse_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "QuestionnaireResponse", client)
}

pub fn us_core_questionnaireresponse_update_req(
  resource: r4us.UsCoreQuestionnaireresponse,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    client,
  )
}

pub fn us_core_questionnaireresponse_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "QuestionnaireResponse", client)
}

pub fn us_core_questionnaireresponse_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreQuestionnaireresponse, Err) {
  any_resp(resp, r4us.us_core_questionnaireresponse_decoder())
}

pub fn us_core_relatedperson_create_req(
  resource: r4us.UsCoreRelatedperson,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_relatedperson_to_json(resource),
    "RelatedPerson",
    client,
  )
}

pub fn us_core_relatedperson_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "RelatedPerson", client)
}

pub fn us_core_relatedperson_update_req(
  resource: r4us.UsCoreRelatedperson,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_relatedperson_to_json(resource),
    "RelatedPerson",
    client,
  )
}

pub fn us_core_relatedperson_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "RelatedPerson", client)
}

pub fn us_core_relatedperson_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreRelatedperson, Err) {
  any_resp(resp, r4us.us_core_relatedperson_decoder())
}

pub fn requestgroup_create_req(
  resource: r4us.Requestgroup,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.requestgroup_to_json(resource), "RequestGroup", client)
}

pub fn requestgroup_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "RequestGroup", client)
}

pub fn requestgroup_update_req(
  resource: r4us.Requestgroup,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.requestgroup_to_json(resource),
    "RequestGroup",
    client,
  )
}

pub fn requestgroup_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "RequestGroup", client)
}

pub fn requestgroup_resp(
  resp: Response(String),
) -> Result(r4us.Requestgroup, Err) {
  any_resp(resp, r4us.requestgroup_decoder())
}

pub fn researchdefinition_create_req(
  resource: r4us.Researchdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.researchdefinition_to_json(resource),
    "ResearchDefinition",
    client,
  )
}

pub fn researchdefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "ResearchDefinition", client)
}

pub fn researchdefinition_update_req(
  resource: r4us.Researchdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.researchdefinition_to_json(resource),
    "ResearchDefinition",
    client,
  )
}

pub fn researchdefinition_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "ResearchDefinition", client)
}

pub fn researchdefinition_resp(
  resp: Response(String),
) -> Result(r4us.Researchdefinition, Err) {
  any_resp(resp, r4us.researchdefinition_decoder())
}

pub fn researchelementdefinition_create_req(
  resource: r4us.Researchelementdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.researchelementdefinition_to_json(resource),
    "ResearchElementDefinition",
    client,
  )
}

pub fn researchelementdefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "ResearchElementDefinition", client)
}

pub fn researchelementdefinition_update_req(
  resource: r4us.Researchelementdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.researchelementdefinition_to_json(resource),
    "ResearchElementDefinition",
    client,
  )
}

pub fn researchelementdefinition_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "ResearchElementDefinition", client)
}

pub fn researchelementdefinition_resp(
  resp: Response(String),
) -> Result(r4us.Researchelementdefinition, Err) {
  any_resp(resp, r4us.researchelementdefinition_decoder())
}

pub fn researchstudy_create_req(
  resource: r4us.Researchstudy,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.researchstudy_to_json(resource), "ResearchStudy", client)
}

pub fn researchstudy_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "ResearchStudy", client)
}

pub fn researchstudy_update_req(
  resource: r4us.Researchstudy,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.researchstudy_to_json(resource),
    "ResearchStudy",
    client,
  )
}

pub fn researchstudy_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "ResearchStudy", client)
}

pub fn researchstudy_resp(
  resp: Response(String),
) -> Result(r4us.Researchstudy, Err) {
  any_resp(resp, r4us.researchstudy_decoder())
}

pub fn researchsubject_create_req(
  resource: r4us.Researchsubject,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.researchsubject_to_json(resource),
    "ResearchSubject",
    client,
  )
}

pub fn researchsubject_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "ResearchSubject", client)
}

pub fn researchsubject_update_req(
  resource: r4us.Researchsubject,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.researchsubject_to_json(resource),
    "ResearchSubject",
    client,
  )
}

pub fn researchsubject_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "ResearchSubject", client)
}

pub fn researchsubject_resp(
  resp: Response(String),
) -> Result(r4us.Researchsubject, Err) {
  any_resp(resp, r4us.researchsubject_decoder())
}

pub fn riskassessment_create_req(
  resource: r4us.Riskassessment,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.riskassessment_to_json(resource),
    "RiskAssessment",
    client,
  )
}

pub fn riskassessment_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "RiskAssessment", client)
}

pub fn riskassessment_update_req(
  resource: r4us.Riskassessment,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.riskassessment_to_json(resource),
    "RiskAssessment",
    client,
  )
}

pub fn riskassessment_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "RiskAssessment", client)
}

pub fn riskassessment_resp(
  resp: Response(String),
) -> Result(r4us.Riskassessment, Err) {
  any_resp(resp, r4us.riskassessment_decoder())
}

pub fn riskevidencesynthesis_create_req(
  resource: r4us.Riskevidencesynthesis,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.riskevidencesynthesis_to_json(resource),
    "RiskEvidenceSynthesis",
    client,
  )
}

pub fn riskevidencesynthesis_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "RiskEvidenceSynthesis", client)
}

pub fn riskevidencesynthesis_update_req(
  resource: r4us.Riskevidencesynthesis,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.riskevidencesynthesis_to_json(resource),
    "RiskEvidenceSynthesis",
    client,
  )
}

pub fn riskevidencesynthesis_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "RiskEvidenceSynthesis", client)
}

pub fn riskevidencesynthesis_resp(
  resp: Response(String),
) -> Result(r4us.Riskevidencesynthesis, Err) {
  any_resp(resp, r4us.riskevidencesynthesis_decoder())
}

pub fn schedule_create_req(
  resource: r4us.Schedule,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.schedule_to_json(resource), "Schedule", client)
}

pub fn schedule_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Schedule", client)
}

pub fn schedule_update_req(
  resource: r4us.Schedule,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.schedule_to_json(resource),
    "Schedule",
    client,
  )
}

pub fn schedule_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Schedule", client)
}

pub fn schedule_resp(resp: Response(String)) -> Result(r4us.Schedule, Err) {
  any_resp(resp, r4us.schedule_decoder())
}

pub fn searchparameter_create_req(
  resource: r4us.Searchparameter,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.searchparameter_to_json(resource),
    "SearchParameter",
    client,
  )
}

pub fn searchparameter_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "SearchParameter", client)
}

pub fn searchparameter_update_req(
  resource: r4us.Searchparameter,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.searchparameter_to_json(resource),
    "SearchParameter",
    client,
  )
}

pub fn searchparameter_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "SearchParameter", client)
}

pub fn searchparameter_resp(
  resp: Response(String),
) -> Result(r4us.Searchparameter, Err) {
  any_resp(resp, r4us.searchparameter_decoder())
}

pub fn us_core_servicerequest_create_req(
  resource: r4us.UsCoreServicerequest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.us_core_servicerequest_to_json(resource),
    "ServiceRequest",
    client,
  )
}

pub fn us_core_servicerequest_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "ServiceRequest", client)
}

pub fn us_core_servicerequest_update_req(
  resource: r4us.UsCoreServicerequest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_servicerequest_to_json(resource),
    "ServiceRequest",
    client,
  )
}

pub fn us_core_servicerequest_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "ServiceRequest", client)
}

pub fn us_core_servicerequest_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreServicerequest, Err) {
  any_resp(resp, r4us.us_core_servicerequest_decoder())
}

pub fn slot_create_req(
  resource: r4us.Slot,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.slot_to_json(resource), "Slot", client)
}

pub fn slot_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Slot", client)
}

pub fn slot_update_req(
  resource: r4us.Slot,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4us.slot_to_json(resource), "Slot", client)
}

pub fn slot_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Slot", client)
}

pub fn slot_resp(resp: Response(String)) -> Result(r4us.Slot, Err) {
  any_resp(resp, r4us.slot_decoder())
}

pub fn us_core_specimen_create_req(
  resource: r4us.UsCoreSpecimen,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.us_core_specimen_to_json(resource), "Specimen", client)
}

pub fn us_core_specimen_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "Specimen", client)
}

pub fn us_core_specimen_update_req(
  resource: r4us.UsCoreSpecimen,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.us_core_specimen_to_json(resource),
    "Specimen",
    client,
  )
}

pub fn us_core_specimen_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Specimen", client)
}

pub fn us_core_specimen_resp(
  resp: Response(String),
) -> Result(r4us.UsCoreSpecimen, Err) {
  any_resp(resp, r4us.us_core_specimen_decoder())
}

pub fn specimendefinition_create_req(
  resource: r4us.Specimendefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.specimendefinition_to_json(resource),
    "SpecimenDefinition",
    client,
  )
}

pub fn specimendefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "SpecimenDefinition", client)
}

pub fn specimendefinition_update_req(
  resource: r4us.Specimendefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.specimendefinition_to_json(resource),
    "SpecimenDefinition",
    client,
  )
}

pub fn specimendefinition_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "SpecimenDefinition", client)
}

pub fn specimendefinition_resp(
  resp: Response(String),
) -> Result(r4us.Specimendefinition, Err) {
  any_resp(resp, r4us.specimendefinition_decoder())
}

pub fn structuredefinition_create_req(
  resource: r4us.Structuredefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.structuredefinition_to_json(resource),
    "StructureDefinition",
    client,
  )
}

pub fn structuredefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "StructureDefinition", client)
}

pub fn structuredefinition_update_req(
  resource: r4us.Structuredefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.structuredefinition_to_json(resource),
    "StructureDefinition",
    client,
  )
}

pub fn structuredefinition_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "StructureDefinition", client)
}

pub fn structuredefinition_resp(
  resp: Response(String),
) -> Result(r4us.Structuredefinition, Err) {
  any_resp(resp, r4us.structuredefinition_decoder())
}

pub fn structuremap_create_req(
  resource: r4us.Structuremap,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.structuremap_to_json(resource), "StructureMap", client)
}

pub fn structuremap_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "StructureMap", client)
}

pub fn structuremap_update_req(
  resource: r4us.Structuremap,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.structuremap_to_json(resource),
    "StructureMap",
    client,
  )
}

pub fn structuremap_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "StructureMap", client)
}

pub fn structuremap_resp(
  resp: Response(String),
) -> Result(r4us.Structuremap, Err) {
  any_resp(resp, r4us.structuremap_decoder())
}

pub fn subscription_create_req(
  resource: r4us.Subscription,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.subscription_to_json(resource), "Subscription", client)
}

pub fn subscription_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Subscription", client)
}

pub fn subscription_update_req(
  resource: r4us.Subscription,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.subscription_to_json(resource),
    "Subscription",
    client,
  )
}

pub fn subscription_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Subscription", client)
}

pub fn subscription_resp(
  resp: Response(String),
) -> Result(r4us.Subscription, Err) {
  any_resp(resp, r4us.subscription_decoder())
}

pub fn substance_create_req(
  resource: r4us.Substance,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.substance_to_json(resource), "Substance", client)
}

pub fn substance_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Substance", client)
}

pub fn substance_update_req(
  resource: r4us.Substance,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.substance_to_json(resource),
    "Substance",
    client,
  )
}

pub fn substance_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Substance", client)
}

pub fn substance_resp(resp: Response(String)) -> Result(r4us.Substance, Err) {
  any_resp(resp, r4us.substance_decoder())
}

pub fn substancenucleicacid_create_req(
  resource: r4us.Substancenucleicacid,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.substancenucleicacid_to_json(resource),
    "SubstanceNucleicAcid",
    client,
  )
}

pub fn substancenucleicacid_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "SubstanceNucleicAcid", client)
}

pub fn substancenucleicacid_update_req(
  resource: r4us.Substancenucleicacid,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.substancenucleicacid_to_json(resource),
    "SubstanceNucleicAcid",
    client,
  )
}

pub fn substancenucleicacid_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "SubstanceNucleicAcid", client)
}

pub fn substancenucleicacid_resp(
  resp: Response(String),
) -> Result(r4us.Substancenucleicacid, Err) {
  any_resp(resp, r4us.substancenucleicacid_decoder())
}

pub fn substancepolymer_create_req(
  resource: r4us.Substancepolymer,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.substancepolymer_to_json(resource),
    "SubstancePolymer",
    client,
  )
}

pub fn substancepolymer_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "SubstancePolymer", client)
}

pub fn substancepolymer_update_req(
  resource: r4us.Substancepolymer,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.substancepolymer_to_json(resource),
    "SubstancePolymer",
    client,
  )
}

pub fn substancepolymer_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "SubstancePolymer", client)
}

pub fn substancepolymer_resp(
  resp: Response(String),
) -> Result(r4us.Substancepolymer, Err) {
  any_resp(resp, r4us.substancepolymer_decoder())
}

pub fn substanceprotein_create_req(
  resource: r4us.Substanceprotein,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.substanceprotein_to_json(resource),
    "SubstanceProtein",
    client,
  )
}

pub fn substanceprotein_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "SubstanceProtein", client)
}

pub fn substanceprotein_update_req(
  resource: r4us.Substanceprotein,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.substanceprotein_to_json(resource),
    "SubstanceProtein",
    client,
  )
}

pub fn substanceprotein_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "SubstanceProtein", client)
}

pub fn substanceprotein_resp(
  resp: Response(String),
) -> Result(r4us.Substanceprotein, Err) {
  any_resp(resp, r4us.substanceprotein_decoder())
}

pub fn substancereferenceinformation_create_req(
  resource: r4us.Substancereferenceinformation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.substancereferenceinformation_to_json(resource),
    "SubstanceReferenceInformation",
    client,
  )
}

pub fn substancereferenceinformation_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "SubstanceReferenceInformation", client)
}

pub fn substancereferenceinformation_update_req(
  resource: r4us.Substancereferenceinformation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.substancereferenceinformation_to_json(resource),
    "SubstanceReferenceInformation",
    client,
  )
}

pub fn substancereferenceinformation_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "SubstanceReferenceInformation", client)
}

pub fn substancereferenceinformation_resp(
  resp: Response(String),
) -> Result(r4us.Substancereferenceinformation, Err) {
  any_resp(resp, r4us.substancereferenceinformation_decoder())
}

pub fn substancesourcematerial_create_req(
  resource: r4us.Substancesourcematerial,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.substancesourcematerial_to_json(resource),
    "SubstanceSourceMaterial",
    client,
  )
}

pub fn substancesourcematerial_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "SubstanceSourceMaterial", client)
}

pub fn substancesourcematerial_update_req(
  resource: r4us.Substancesourcematerial,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.substancesourcematerial_to_json(resource),
    "SubstanceSourceMaterial",
    client,
  )
}

pub fn substancesourcematerial_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "SubstanceSourceMaterial", client)
}

pub fn substancesourcematerial_resp(
  resp: Response(String),
) -> Result(r4us.Substancesourcematerial, Err) {
  any_resp(resp, r4us.substancesourcematerial_decoder())
}

pub fn substancespecification_create_req(
  resource: r4us.Substancespecification,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.substancespecification_to_json(resource),
    "SubstanceSpecification",
    client,
  )
}

pub fn substancespecification_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "SubstanceSpecification", client)
}

pub fn substancespecification_update_req(
  resource: r4us.Substancespecification,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.substancespecification_to_json(resource),
    "SubstanceSpecification",
    client,
  )
}

pub fn substancespecification_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "SubstanceSpecification", client)
}

pub fn substancespecification_resp(
  resp: Response(String),
) -> Result(r4us.Substancespecification, Err) {
  any_resp(resp, r4us.substancespecification_decoder())
}

pub fn supplydelivery_create_req(
  resource: r4us.Supplydelivery,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.supplydelivery_to_json(resource),
    "SupplyDelivery",
    client,
  )
}

pub fn supplydelivery_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "SupplyDelivery", client)
}

pub fn supplydelivery_update_req(
  resource: r4us.Supplydelivery,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.supplydelivery_to_json(resource),
    "SupplyDelivery",
    client,
  )
}

pub fn supplydelivery_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "SupplyDelivery", client)
}

pub fn supplydelivery_resp(
  resp: Response(String),
) -> Result(r4us.Supplydelivery, Err) {
  any_resp(resp, r4us.supplydelivery_decoder())
}

pub fn supplyrequest_create_req(
  resource: r4us.Supplyrequest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.supplyrequest_to_json(resource), "SupplyRequest", client)
}

pub fn supplyrequest_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "SupplyRequest", client)
}

pub fn supplyrequest_update_req(
  resource: r4us.Supplyrequest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.supplyrequest_to_json(resource),
    "SupplyRequest",
    client,
  )
}

pub fn supplyrequest_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "SupplyRequest", client)
}

pub fn supplyrequest_resp(
  resp: Response(String),
) -> Result(r4us.Supplyrequest, Err) {
  any_resp(resp, r4us.supplyrequest_decoder())
}

pub fn task_create_req(
  resource: r4us.Task,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.task_to_json(resource), "Task", client)
}

pub fn task_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Task", client)
}

pub fn task_update_req(
  resource: r4us.Task,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4us.task_to_json(resource), "Task", client)
}

pub fn task_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Task", client)
}

pub fn task_resp(resp: Response(String)) -> Result(r4us.Task, Err) {
  any_resp(resp, r4us.task_decoder())
}

pub fn terminologycapabilities_create_req(
  resource: r4us.Terminologycapabilities,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.terminologycapabilities_to_json(resource),
    "TerminologyCapabilities",
    client,
  )
}

pub fn terminologycapabilities_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "TerminologyCapabilities", client)
}

pub fn terminologycapabilities_update_req(
  resource: r4us.Terminologycapabilities,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.terminologycapabilities_to_json(resource),
    "TerminologyCapabilities",
    client,
  )
}

pub fn terminologycapabilities_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "TerminologyCapabilities", client)
}

pub fn terminologycapabilities_resp(
  resp: Response(String),
) -> Result(r4us.Terminologycapabilities, Err) {
  any_resp(resp, r4us.terminologycapabilities_decoder())
}

pub fn testreport_create_req(
  resource: r4us.Testreport,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.testreport_to_json(resource), "TestReport", client)
}

pub fn testreport_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "TestReport", client)
}

pub fn testreport_update_req(
  resource: r4us.Testreport,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.testreport_to_json(resource),
    "TestReport",
    client,
  )
}

pub fn testreport_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "TestReport", client)
}

pub fn testreport_resp(resp: Response(String)) -> Result(r4us.Testreport, Err) {
  any_resp(resp, r4us.testreport_decoder())
}

pub fn testscript_create_req(
  resource: r4us.Testscript,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.testscript_to_json(resource), "TestScript", client)
}

pub fn testscript_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "TestScript", client)
}

pub fn testscript_update_req(
  resource: r4us.Testscript,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.testscript_to_json(resource),
    "TestScript",
    client,
  )
}

pub fn testscript_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "TestScript", client)
}

pub fn testscript_resp(resp: Response(String)) -> Result(r4us.Testscript, Err) {
  any_resp(resp, r4us.testscript_decoder())
}

pub fn valueset_create_req(
  resource: r4us.Valueset,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4us.valueset_to_json(resource), "ValueSet", client)
}

pub fn valueset_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "ValueSet", client)
}

pub fn valueset_update_req(
  resource: r4us.Valueset,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.valueset_to_json(resource),
    "ValueSet",
    client,
  )
}

pub fn valueset_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "ValueSet", client)
}

pub fn valueset_resp(resp: Response(String)) -> Result(r4us.Valueset, Err) {
  any_resp(resp, r4us.valueset_decoder())
}

pub fn verificationresult_create_req(
  resource: r4us.Verificationresult,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.verificationresult_to_json(resource),
    "VerificationResult",
    client,
  )
}

pub fn verificationresult_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "VerificationResult", client)
}

pub fn verificationresult_update_req(
  resource: r4us.Verificationresult,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.verificationresult_to_json(resource),
    "VerificationResult",
    client,
  )
}

pub fn verificationresult_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "VerificationResult", client)
}

pub fn verificationresult_resp(
  resp: Response(String),
) -> Result(r4us.Verificationresult, Err) {
  any_resp(resp, r4us.verificationresult_decoder())
}

pub fn visionprescription_create_req(
  resource: r4us.Visionprescription,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4us.visionprescription_to_json(resource),
    "VisionPrescription",
    client,
  )
}

pub fn visionprescription_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "VisionPrescription", client)
}

pub fn visionprescription_update_req(
  resource: r4us.Visionprescription,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4us.visionprescription_to_json(resource),
    "VisionPrescription",
    client,
  )
}

pub fn visionprescription_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "VisionPrescription", client)
}

pub fn visionprescription_resp(
  resp: Response(String),
) -> Result(r4us.Visionprescription, Err) {
  any_resp(resp, r4us.visionprescription_decoder())
}

pub type SpAccount {
  SpAccount(
    owner: Option(String),
    identifier: Option(String),
    period: Option(String),
    subject: Option(String),
    patient: Option(String),
    name: Option(String),
    type_: Option(String),
    status: Option(String),
  )
}

pub type SpActivitydefinition {
  SpActivitydefinition(
    date: Option(String),
    identifier: Option(String),
    successor: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    derived_from: Option(String),
    context_type: Option(String),
    predecessor: Option(String),
    title: Option(String),
    composed_of: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    effective: Option(String),
    depends_on: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    topic: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpAdverseevent {
  SpAdverseevent(
    date: Option(String),
    severity: Option(String),
    recorder: Option(String),
    study: Option(String),
    actuality: Option(String),
    seriousness: Option(String),
    subject: Option(String),
    resultingcondition: Option(String),
    substance: Option(String),
    location: Option(String),
    category: Option(String),
    event: Option(String),
  )
}

pub type SpUsCoreAllergyintolerance {
  SpUsCoreAllergyintolerance(
    clinical_status: Option(String),
    patient: Option(String),
  )
}

pub type SpAppointment {
  SpAppointment(
    date: Option(String),
    identifier: Option(String),
    specialty: Option(String),
    service_category: Option(String),
    practitioner: Option(String),
    part_status: Option(String),
    appointment_type: Option(String),
    service_type: Option(String),
    slot: Option(String),
    reason_code: Option(String),
    actor: Option(String),
    based_on: Option(String),
    patient: Option(String),
    reason_reference: Option(String),
    supporting_info: Option(String),
    location: Option(String),
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
  )
}

pub type SpAuditevent {
  SpAuditevent(
    date: Option(String),
    entity_type: Option(String),
    agent: Option(String),
    address: Option(String),
    entity_role: Option(String),
    source: Option(String),
    type_: Option(String),
    altid: Option(String),
    site: Option(String),
    agent_name: Option(String),
    entity_name: Option(String),
    subtype: Option(String),
    patient: Option(String),
    action: Option(String),
    agent_role: Option(String),
    entity: Option(String),
    outcome: Option(String),
    policy: Option(String),
  )
}

pub type SpBasic {
  SpBasic(
    identifier: Option(String),
    code: Option(String),
    subject: Option(String),
    created: Option(String),
    patient: Option(String),
    author: Option(String),
  )
}

pub type SpBinary {
  SpBinary
}

pub type SpBiologicallyderivedproduct {
  SpBiologicallyderivedproduct
}

pub type SpBodystructure {
  SpBodystructure(
    identifier: Option(String),
    morphology: Option(String),
    patient: Option(String),
    location: Option(String),
  )
}

pub type SpBundle {
  SpBundle(
    identifier: Option(String),
    composition: Option(String),
    type_: Option(String),
    message: Option(String),
    timestamp: Option(String),
  )
}

pub type SpCapabilitystatement {
  SpCapabilitystatement(
    date: Option(String),
    resource_profile: Option(String),
    context_type_value: Option(String),
    software: Option(String),
    resource: Option(String),
    jurisdiction: Option(String),
    format: Option(String),
    description: Option(String),
    context_type: Option(String),
    title: Option(String),
    fhirversion: Option(String),
    version: Option(String),
    url: Option(String),
    supported_profile: Option(String),
    mode: Option(String),
    context_quantity: Option(String),
    security_service: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    guide: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreCareplan {
  SpUsCoreCareplan(
    category: Option(String),
    date: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreCareteam {
  SpUsCoreCareteam(
    patient: Option(String),
    role: Option(String),
    status: Option(String),
  )
}

pub type SpCatalogentry {
  SpCatalogentry
}

pub type SpChargeitem {
  SpChargeitem(
    identifier: Option(String),
    performing_organization: Option(String),
    code: Option(String),
    quantity: Option(String),
    subject: Option(String),
    occurrence: Option(String),
    entered_date: Option(String),
    performer_function: Option(String),
    patient: Option(String),
    factor_override: Option(String),
    service: Option(String),
    price_override: Option(String),
    context: Option(String),
    enterer: Option(String),
    performer_actor: Option(String),
    account: Option(String),
    requesting_organization: Option(String),
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

pub type SpClaim {
  SpClaim(
    care_team: Option(String),
    identifier: Option(String),
    use_: Option(String),
    created: Option(String),
    encounter: Option(String),
    priority: Option(String),
    payee: Option(String),
    provider: Option(String),
    patient: Option(String),
    insurer: Option(String),
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
    insurer: Option(String),
    created: Option(String),
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
    previous: Option(String),
    finding_code: Option(String),
    assessor: Option(String),
    subject: Option(String),
    encounter: Option(String),
    finding_ref: Option(String),
    problem: Option(String),
    patient: Option(String),
    supporting_info: Option(String),
    investigation: Option(String),
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

pub type SpCommunication {
  SpCommunication(
    identifier: Option(String),
    subject: Option(String),
    instantiates_canonical: Option(String),
    received: Option(String),
    part_of: Option(String),
    medium: Option(String),
    encounter: Option(String),
    sent: Option(String),
    based_on: Option(String),
    sender: Option(String),
    patient: Option(String),
    recipient: Option(String),
    instantiates_uri: Option(String),
    category: Option(String),
    status: Option(String),
  )
}

pub type SpCommunicationrequest {
  SpCommunicationrequest(
    requester: Option(String),
    authored: Option(String),
    identifier: Option(String),
    subject: Option(String),
    replaces: Option(String),
    medium: Option(String),
    encounter: Option(String),
    occurrence: Option(String),
    priority: Option(String),
    group_identifier: Option(String),
    based_on: Option(String),
    sender: Option(String),
    patient: Option(String),
    recipient: Option(String),
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
    name: Option(String),
    context: Option(String),
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
    related_id: Option(String),
    subject: Option(String),
    author: Option(String),
    confidentiality: Option(String),
    section: Option(String),
    encounter: Option(String),
    type_: Option(String),
    title: Option(String),
    attester: Option(String),
    entry: Option(String),
    related_ref: Option(String),
    patient: Option(String),
    context: Option(String),
    category: Option(String),
    status: Option(String),
  )
}

pub type SpConceptmap {
  SpConceptmap(
    date: Option(String),
    other: Option(String),
    context_type_value: Option(String),
    target_system: Option(String),
    dependson: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    context_type: Option(String),
    source: Option(String),
    title: Option(String),
    context_quantity: Option(String),
    source_uri: Option(String),
    context: Option(String),
    context_type_quantity: Option(String),
    source_system: Option(String),
    target_code: Option(String),
    target_uri: Option(String),
    identifier: Option(String),
    product: Option(String),
    version: Option(String),
    url: Option(String),
    target: Option(String),
    source_code: Option(String),
    name: Option(String),
    publisher: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreConditionEncounterDiagnosis {
  SpUsCoreConditionEncounterDiagnosis(
    abatement_date: Option(String),
    asserted_date: Option(String),
    category: Option(String),
    clinical_status: Option(String),
    code: Option(String),
    encounter: Option(String),
    onset_date: Option(String),
    patient: Option(String),
    recorded_date: Option(String),
    lastupdated: Option(String),
  )
}

pub type SpUsCoreConditionProblemsHealthConcerns {
  SpUsCoreConditionProblemsHealthConcerns(
    abatement_date: Option(String),
    asserted_date: Option(String),
    category: Option(String),
    clinical_status: Option(String),
    code: Option(String),
    encounter: Option(String),
    onset_date: Option(String),
    patient: Option(String),
    recorded_date: Option(String),
    lastupdated: Option(String),
  )
}

pub type SpConsent {
  SpConsent(
    date: Option(String),
    identifier: Option(String),
    period: Option(String),
    data: Option(String),
    purpose: Option(String),
    source_reference: Option(String),
    actor: Option(String),
    security_label: Option(String),
    patient: Option(String),
    organization: Option(String),
    scope: Option(String),
    action: Option(String),
    consentor: Option(String),
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

pub type SpUsCoreCoverage {
  SpUsCoreCoverage(patient: Option(String))
}

pub type SpCoverageeligibilityrequest {
  SpCoverageeligibilityrequest(
    identifier: Option(String),
    provider: Option(String),
    patient: Option(String),
    created: Option(String),
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
    patient: Option(String),
    insurer: Option(String),
    created: Option(String),
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
    patient: Option(String),
    author: Option(String),
    implicated: Option(String),
  )
}

pub type SpUsCoreDevice {
  SpUsCoreDevice(
    patient: Option(String),
    status: Option(String),
    type_: Option(String),
  )
}

pub type SpDevicedefinition {
  SpDevicedefinition(
    parent: Option(String),
    identifier: Option(String),
    type_: Option(String),
  )
}

pub type SpDevicemetric {
  SpDevicemetric(
    parent: Option(String),
    identifier: Option(String),
    source: Option(String),
    type_: Option(String),
    category: Option(String),
  )
}

pub type SpDevicerequest {
  SpDevicerequest(
    requester: Option(String),
    insurance: Option(String),
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
    prior_request: Option(String),
    device: Option(String),
    status: Option(String),
  )
}

pub type SpDeviceusestatement {
  SpDeviceusestatement(
    identifier: Option(String),
    subject: Option(String),
    patient: Option(String),
    device: Option(String),
  )
}

pub type SpUsCoreDiagnosticreportLab {
  SpUsCoreDiagnosticreportLab(
    category: Option(String),
    code: Option(String),
    date: Option(String),
    lastupdated: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreDiagnosticreportNote {
  SpUsCoreDiagnosticreportNote(
    category: Option(String),
    code: Option(String),
    date: Option(String),
    lastupdated: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpDocumentmanifest {
  SpDocumentmanifest(
    identifier: Option(String),
    item: Option(String),
    related_id: Option(String),
    subject: Option(String),
    author: Option(String),
    created: Option(String),
    description: Option(String),
    source: Option(String),
    type_: Option(String),
    related_ref: Option(String),
    patient: Option(String),
    recipient: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreDocumentreference {
  SpUsCoreDocumentreference(
    id: Option(String),
    category: Option(String),
    date: Option(String),
    patient: Option(String),
    period: Option(String),
    status: Option(String),
    type_: Option(String),
  )
}

pub type SpUsCoreAdiDocumentreference {
  SpUsCoreAdiDocumentreference(
    id: Option(String),
    category: Option(String),
    date: Option(String),
    patient: Option(String),
    period: Option(String),
    status: Option(String),
    type_: Option(String),
  )
}

pub type SpEffectevidencesynthesis {
  SpEffectevidencesynthesis(
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
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreEncounter {
  SpUsCoreEncounter(
    id: Option(String),
    class: Option(String),
    date: Option(String),
    lastupdated: Option(String),
    discharge_disposition: Option(String),
    identifier: Option(String),
    location: Option(String),
    patient: Option(String),
    status: Option(String),
    type_: Option(String),
  )
}

pub type SpEndpoint {
  SpEndpoint(
    payload_type: Option(String),
    identifier: Option(String),
    organization: Option(String),
    connection_type: Option(String),
    name: Option(String),
    status: Option(String),
  )
}

pub type SpEnrollmentrequest {
  SpEnrollmentrequest(
    identifier: Option(String),
    subject: Option(String),
    patient: Option(String),
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
    condition: Option(String),
    patient: Option(String),
    organization: Option(String),
    type_: Option(String),
    care_manager: Option(String),
    status: Option(String),
    incoming_referral: Option(String),
  )
}

pub type SpEventdefinition {
  SpEventdefinition(
    date: Option(String),
    identifier: Option(String),
    successor: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    derived_from: Option(String),
    context_type: Option(String),
    predecessor: Option(String),
    title: Option(String),
    composed_of: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    effective: Option(String),
    depends_on: Option(String),
    name: Option(String),
    context: Option(String),
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
    successor: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    derived_from: Option(String),
    context_type: Option(String),
    predecessor: Option(String),
    title: Option(String),
    composed_of: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    effective: Option(String),
    depends_on: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    topic: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpEvidencevariable {
  SpEvidencevariable(
    date: Option(String),
    identifier: Option(String),
    successor: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    derived_from: Option(String),
    context_type: Option(String),
    predecessor: Option(String),
    title: Option(String),
    composed_of: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    effective: Option(String),
    depends_on: Option(String),
    name: Option(String),
    context: Option(String),
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
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpExplanationofbenefit {
  SpExplanationofbenefit(
    coverage: Option(String),
    care_team: Option(String),
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

pub type SpUsCoreFamilymemberhistory {
  SpUsCoreFamilymemberhistory(patient: Option(String), code: Option(String))
}

pub type SpFlag {
  SpFlag(
    date: Option(String),
    identifier: Option(String),
    subject: Option(String),
    patient: Option(String),
    author: Option(String),
    encounter: Option(String),
  )
}

pub type SpUsCoreGoal {
  SpUsCoreGoal(
    description: Option(String),
    lifecycle_status: Option(String),
    patient: Option(String),
    target_date: Option(String),
  )
}

pub type SpGraphdefinition {
  SpGraphdefinition(
    date: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    start: Option(String),
    description: Option(String),
    context_type: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpGroup {
  SpGroup(
    actual: Option(String),
    identifier: Option(String),
    characteristic_value: Option(String),
    managing_entity: Option(String),
    code: Option(String),
    member: Option(String),
    exclude: Option(String),
    type_: Option(String),
    value: Option(String),
    characteristic: Option(String),
  )
}

pub type SpGuidanceresponse {
  SpGuidanceresponse(
    request: Option(String),
    identifier: Option(String),
    patient: Option(String),
    subject: Option(String),
  )
}

pub type SpHealthcareservice {
  SpHealthcareservice(
    identifier: Option(String),
    specialty: Option(String),
    endpoint: Option(String),
    service_category: Option(String),
    coverage_area: Option(String),
    service_type: Option(String),
    organization: Option(String),
    name: Option(String),
    active: Option(String),
    location: Option(String),
    program: Option(String),
    characteristic: Option(String),
  )
}

pub type SpImagingstudy {
  SpImagingstudy(
    identifier: Option(String),
    reason: Option(String),
    dicom_class: Option(String),
    modality: Option(String),
    bodysite: Option(String),
    instance: Option(String),
    performer: Option(String),
    subject: Option(String),
    started: Option(String),
    interpreter: Option(String),
    encounter: Option(String),
    referrer: Option(String),
    endpoint: Option(String),
    patient: Option(String),
    series: Option(String),
    basedon: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreImmunization {
  SpUsCoreImmunization(
    date: Option(String),
    patient: Option(String),
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
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
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
    administered_by: Option(String),
    address_country: Option(String),
    endpoint: Option(String),
    phonetic: Option(String),
    name: Option(String),
    address_use: Option(String),
    address_city: Option(String),
    status: Option(String),
  )
}

pub type SpInvoice {
  SpInvoice(
    date: Option(String),
    identifier: Option(String),
    totalgross: Option(String),
    subject: Option(String),
    participant_role: Option(String),
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
    description: Option(String),
    derived_from: Option(String),
    context_type: Option(String),
    predecessor: Option(String),
    title: Option(String),
    composed_of: Option(String),
    type_: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    effective: Option(String),
    depends_on: Option(String),
    name: Option(String),
    context: Option(String),
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
    item: Option(String),
    empty_reason: Option(String),
    code: Option(String),
    notes: Option(String),
    subject: Option(String),
    patient: Option(String),
    source: Option(String),
    encounter: Option(String),
    title: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreLocation {
  SpUsCoreLocation(
    address: Option(String),
    address_city: Option(String),
    address_postalcode: Option(String),
    address_state: Option(String),
    name: Option(String),
  )
}

pub type SpMeasure {
  SpMeasure(
    date: Option(String),
    identifier: Option(String),
    successor: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    derived_from: Option(String),
    context_type: Option(String),
    predecessor: Option(String),
    title: Option(String),
    composed_of: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    effective: Option(String),
    depends_on: Option(String),
    name: Option(String),
    context: Option(String),
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
    status: Option(String),
    evaluated_resource: Option(String),
  )
}

pub type SpMedia {
  SpMedia(
    identifier: Option(String),
    modality: Option(String),
    subject: Option(String),
    created: Option(String),
    encounter: Option(String),
    type_: Option(String),
    operator: Option(String),
    view: Option(String),
    site: Option(String),
    based_on: Option(String),
    patient: Option(String),
    device: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreMedication {
  SpUsCoreMedication
}

pub type SpMedicationadministration {
  SpMedicationadministration(
    identifier: Option(String),
    request: Option(String),
    code: Option(String),
    performer: Option(String),
    subject: Option(String),
    medication: Option(String),
    reason_given: Option(String),
    patient: Option(String),
    effective_time: Option(String),
    context: Option(String),
    reason_not_given: Option(String),
    device: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreMedicationdispense {
  SpUsCoreMedicationdispense(
    patient: Option(String),
    status: Option(String),
    type_: Option(String),
  )
}

pub type SpMedicationknowledge {
  SpMedicationknowledge(
    code: Option(String),
    ingredient: Option(String),
    doseform: Option(String),
    classification_type: Option(String),
    monograph_type: Option(String),
    classification: Option(String),
    manufacturer: Option(String),
    ingredient_code: Option(String),
    source_cost: Option(String),
    monograph: Option(String),
    monitoring_program_name: Option(String),
    monitoring_program_type: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreMedicationrequest {
  SpUsCoreMedicationrequest(
    authoredon: Option(String),
    encounter: Option(String),
    intent: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpMedicationstatement {
  SpMedicationstatement(
    identifier: Option(String),
    effective: Option(String),
    code: Option(String),
    subject: Option(String),
    patient: Option(String),
    context: Option(String),
    medication: Option(String),
    part_of: Option(String),
    source: Option(String),
    category: Option(String),
    status: Option(String),
  )
}

pub type SpMedicinalproduct {
  SpMedicinalproduct(
    identifier: Option(String),
    name: Option(String),
    name_language: Option(String),
  )
}

pub type SpMedicinalproductauthorization {
  SpMedicinalproductauthorization(
    identifier: Option(String),
    country: Option(String),
    subject: Option(String),
    holder: Option(String),
    status: Option(String),
  )
}

pub type SpMedicinalproductcontraindication {
  SpMedicinalproductcontraindication(subject: Option(String))
}

pub type SpMedicinalproductindication {
  SpMedicinalproductindication(subject: Option(String))
}

pub type SpMedicinalproductingredient {
  SpMedicinalproductingredient
}

pub type SpMedicinalproductinteraction {
  SpMedicinalproductinteraction(subject: Option(String))
}

pub type SpMedicinalproductmanufactured {
  SpMedicinalproductmanufactured
}

pub type SpMedicinalproductpackaged {
  SpMedicinalproductpackaged(
    identifier: Option(String),
    subject: Option(String),
  )
}

pub type SpMedicinalproductpharmaceutical {
  SpMedicinalproductpharmaceutical(
    identifier: Option(String),
    route: Option(String),
    target_species: Option(String),
  )
}

pub type SpMedicinalproductundesirableeffect {
  SpMedicinalproductundesirableeffect(subject: Option(String))
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
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    event: Option(String),
    category: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpMessageheader {
  SpMessageheader(
    code: Option(String),
    receiver: Option(String),
    author: Option(String),
    destination: Option(String),
    focus: Option(String),
    source: Option(String),
    target: Option(String),
    destination_uri: Option(String),
    source_uri: Option(String),
    sender: Option(String),
    responsible: Option(String),
    enterer: Option(String),
    response_id: Option(String),
    event: Option(String),
  )
}

pub type SpMolecularsequence {
  SpMolecularsequence(
    identifier: Option(String),
    referenceseqid_variant_coordinate: Option(String),
    chromosome: Option(String),
    window_end: Option(String),
    type_: Option(String),
    window_start: Option(String),
    variant_end: Option(String),
    chromosome_variant_coordinate: Option(String),
    patient: Option(String),
    variant_start: Option(String),
    chromosome_window_coordinate: Option(String),
    referenceseqid_window_coordinate: Option(String),
    referenceseqid: Option(String),
  )
}

pub type SpNamingsystem {
  SpNamingsystem(
    date: Option(String),
    period: Option(String),
    context_type_value: Option(String),
    kind: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    context_type: Option(String),
    type_: Option(String),
    id_type: Option(String),
    context_quantity: Option(String),
    responsible: Option(String),
    contact: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    telecom: Option(String),
    value: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpNutritionorder {
  SpNutritionorder(
    identifier: Option(String),
    datetime: Option(String),
    provider: Option(String),
    patient: Option(String),
    supplement: Option(String),
    formula: Option(String),
    instantiates_canonical: Option(String),
    instantiates_uri: Option(String),
    encounter: Option(String),
    oraldiet: Option(String),
    status: Option(String),
    additive: Option(String),
  )
}

pub type SpUsCoreBodyTemperature {
  SpUsCoreBodyTemperature(
    category: Option(String),
    code: Option(String),
    date: Option(String),
    lastupdated: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreObservationClinicalResult {
  SpUsCoreObservationClinicalResult(
    category: Option(String),
    code: Option(String),
    date: Option(String),
    lastupdated: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreObservationLab {
  SpUsCoreObservationLab(
    category: Option(String),
    code: Option(String),
    date: Option(String),
    lastupdated: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreTreatmentInterventionPreference {
  SpUsCoreTreatmentInterventionPreference(
    category: Option(String),
    code: Option(String),
    date: Option(String),
    lastupdated: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreObservationPregnancyintent {
  SpUsCoreObservationPregnancyintent(
    category: Option(String),
    code: Option(String),
    date: Option(String),
    lastupdated: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreSimpleObservation {
  SpUsCoreSimpleObservation(
    category: Option(String),
    code: Option(String),
    date: Option(String),
    lastupdated: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreRespiratoryRate {
  SpUsCoreRespiratoryRate(
    category: Option(String),
    code: Option(String),
    date: Option(String),
    lastupdated: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreObservationOccupation {
  SpUsCoreObservationOccupation(
    category: Option(String),
    code: Option(String),
    date: Option(String),
    lastupdated: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreVitalSigns {
  SpUsCoreVitalSigns(
    category: Option(String),
    code: Option(String),
    date: Option(String),
    lastupdated: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreBodyWeight {
  SpUsCoreBodyWeight(
    category: Option(String),
    code: Option(String),
    date: Option(String),
    lastupdated: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreObservationPregnancystatus {
  SpUsCoreObservationPregnancystatus(
    category: Option(String),
    code: Option(String),
    date: Option(String),
    lastupdated: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreBloodPressure {
  SpUsCoreBloodPressure(
    category: Option(String),
    code: Option(String),
    date: Option(String),
    lastupdated: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpPediatricBmiForAge {
  SpPediatricBmiForAge(
    category: Option(String),
    code: Option(String),
    date: Option(String),
    lastupdated: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreCareExperiencePreference {
  SpUsCoreCareExperiencePreference(
    category: Option(String),
    code: Option(String),
    date: Option(String),
    lastupdated: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreObservationScreeningAssessment {
  SpUsCoreObservationScreeningAssessment(
    category: Option(String),
    code: Option(String),
    date: Option(String),
    lastupdated: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreHeadCircumference {
  SpUsCoreHeadCircumference(
    category: Option(String),
    code: Option(String),
    date: Option(String),
    lastupdated: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreHeartRate {
  SpUsCoreHeartRate(
    category: Option(String),
    code: Option(String),
    date: Option(String),
    lastupdated: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreObservationSexualOrientation {
  SpUsCoreObservationSexualOrientation(
    category: Option(String),
    code: Option(String),
    date: Option(String),
    lastupdated: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpPediatricWeightForHeight {
  SpPediatricWeightForHeight(
    category: Option(String),
    code: Option(String),
    date: Option(String),
    lastupdated: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreBmi {
  SpUsCoreBmi(
    category: Option(String),
    code: Option(String),
    date: Option(String),
    lastupdated: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreBodyHeight {
  SpUsCoreBodyHeight(
    category: Option(String),
    code: Option(String),
    date: Option(String),
    lastupdated: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreSmokingstatus {
  SpUsCoreSmokingstatus(
    category: Option(String),
    code: Option(String),
    date: Option(String),
    lastupdated: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpUsCorePulseOximetry {
  SpUsCorePulseOximetry(
    category: Option(String),
    code: Option(String),
    date: Option(String),
    lastupdated: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpHeadOccipitalFrontalCircumferencePercentile {
  SpHeadOccipitalFrontalCircumferencePercentile(
    category: Option(String),
    code: Option(String),
    date: Option(String),
    lastupdated: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreAverageBloodPressure {
  SpUsCoreAverageBloodPressure(
    category: Option(String),
    code: Option(String),
    date: Option(String),
    lastupdated: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreObservationAdiDocumentation {
  SpUsCoreObservationAdiDocumentation(
    category: Option(String),
    code: Option(String),
    date: Option(String),
    lastupdated: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpObservationdefinition {
  SpObservationdefinition
}

pub type SpOperationdefinition {
  SpOperationdefinition(
    date: Option(String),
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
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
    base: Option(String),
  )
}

pub type SpOperationoutcome {
  SpOperationoutcome
}

pub type SpUsCoreOrganization {
  SpUsCoreOrganization(address: Option(String), name: Option(String))
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
    telecom: Option(String),
    location: Option(String),
    email: Option(String),
  )
}

pub type SpUsCorePatient {
  SpUsCorePatient(
    id: Option(String),
    birthdate: Option(String),
    death_date: Option(String),
    family: Option(String),
    given: Option(String),
    identifier: Option(String),
    name: Option(String),
  )
}

pub type SpPaymentnotice {
  SpPaymentnotice(
    identifier: Option(String),
    request: Option(String),
    provider: Option(String),
    created: Option(String),
    response: Option(String),
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
    payment_issuer: Option(String),
    outcome: Option(String),
    requestor: Option(String),
    status: Option(String),
  )
}

pub type SpPerson {
  SpPerson(
    identifier: Option(String),
    address: Option(String),
    birthdate: Option(String),
    address_state: Option(String),
    gender: Option(String),
    practitioner: Option(String),
    link: Option(String),
    relatedperson: Option(String),
    address_postalcode: Option(String),
    address_country: Option(String),
    phonetic: Option(String),
    phone: Option(String),
    patient: Option(String),
    organization: Option(String),
    name: Option(String),
    address_use: Option(String),
    telecom: Option(String),
    address_city: Option(String),
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
    description: Option(String),
    derived_from: Option(String),
    context_type: Option(String),
    predecessor: Option(String),
    title: Option(String),
    composed_of: Option(String),
    type_: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    effective: Option(String),
    depends_on: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    topic: Option(String),
    definition: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpUsCorePractitioner {
  SpUsCorePractitioner(
    id: Option(String),
    identifier: Option(String),
    name: Option(String),
  )
}

pub type SpUsCorePractitionerrole {
  SpUsCorePractitionerrole(
    practitioner: Option(String),
    specialty: Option(String),
  )
}

pub type SpUsCoreProcedure {
  SpUsCoreProcedure(
    code: Option(String),
    date: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreProvenance {
  SpUsCoreProvenance
}

pub type SpQuestionnaire {
  SpQuestionnaire(
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
    context_quantity: Option(String),
    effective: Option(String),
    subject_type: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    definition: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreQuestionnaireresponse {
  SpUsCoreQuestionnaireresponse(
    id: Option(String),
    authored: Option(String),
    patient: Option(String),
    questionnaire: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreRelatedperson {
  SpUsCoreRelatedperson(
    id: Option(String),
    name: Option(String),
    patient: Option(String),
  )
}

pub type SpRequestgroup {
  SpRequestgroup(
    authored: Option(String),
    identifier: Option(String),
    code: Option(String),
    subject: Option(String),
    author: Option(String),
    instantiates_canonical: Option(String),
    encounter: Option(String),
    priority: Option(String),
    intent: Option(String),
    participant: Option(String),
    group_identifier: Option(String),
    patient: Option(String),
    instantiates_uri: Option(String),
    status: Option(String),
  )
}

pub type SpResearchdefinition {
  SpResearchdefinition(
    date: Option(String),
    identifier: Option(String),
    successor: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    derived_from: Option(String),
    context_type: Option(String),
    predecessor: Option(String),
    title: Option(String),
    composed_of: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    effective: Option(String),
    depends_on: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    topic: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpResearchelementdefinition {
  SpResearchelementdefinition(
    date: Option(String),
    identifier: Option(String),
    successor: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    derived_from: Option(String),
    context_type: Option(String),
    predecessor: Option(String),
    title: Option(String),
    composed_of: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    effective: Option(String),
    depends_on: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    topic: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpResearchstudy {
  SpResearchstudy(
    date: Option(String),
    identifier: Option(String),
    partof: Option(String),
    sponsor: Option(String),
    focus: Option(String),
    principalinvestigator: Option(String),
    title: Option(String),
    protocol: Option(String),
    site: Option(String),
    location: Option(String),
    category: Option(String),
    keyword: Option(String),
    status: Option(String),
  )
}

pub type SpResearchsubject {
  SpResearchsubject(
    date: Option(String),
    identifier: Option(String),
    study: Option(String),
    individual: Option(String),
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
    subject: Option(String),
    patient: Option(String),
    probability: Option(String),
    risk: Option(String),
    encounter: Option(String),
  )
}

pub type SpRiskevidencesynthesis {
  SpRiskevidencesynthesis(
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
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
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
    active: Option(String),
  )
}

pub type SpSearchparameter {
  SpSearchparameter(
    date: Option(String),
    code: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    derived_from: Option(String),
    context_type: Option(String),
    type_: Option(String),
    version: Option(String),
    url: Option(String),
    target: Option(String),
    context_quantity: Option(String),
    component: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
    base: Option(String),
  )
}

pub type SpUsCoreServicerequest {
  SpUsCoreServicerequest(
    id: Option(String),
    authored: Option(String),
    category: Option(String),
    code: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpSlot {
  SpSlot(
    schedule: Option(String),
    identifier: Option(String),
    specialty: Option(String),
    service_category: Option(String),
    appointment_type: Option(String),
    service_type: Option(String),
    start: Option(String),
    status: Option(String),
  )
}

pub type SpUsCoreSpecimen {
  SpUsCoreSpecimen(id: Option(String), patient: Option(String))
}

pub type SpSpecimendefinition {
  SpSpecimendefinition(
    container: Option(String),
    identifier: Option(String),
    type_: Option(String),
  )
}

pub type SpStructuredefinition {
  SpStructuredefinition(
    date: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    context_type: Option(String),
    experimental: Option(String),
    title: Option(String),
    type_: Option(String),
    context_quantity: Option(String),
    path: Option(String),
    context: Option(String),
    base_path: Option(String),
    keyword: Option(String),
    context_type_quantity: Option(String),
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
    status: Option(String),
    base: Option(String),
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
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpSubscription {
  SpSubscription(
    payload: Option(String),
    criteria: Option(String),
    contact: Option(String),
    type_: Option(String),
    url: Option(String),
    status: Option(String),
  )
}

pub type SpSubstance {
  SpSubstance(
    identifier: Option(String),
    container_identifier: Option(String),
    code: Option(String),
    quantity: Option(String),
    substance_reference: Option(String),
    expiry: Option(String),
    category: Option(String),
    status: Option(String),
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

pub type SpSubstancespecification {
  SpSubstancespecification(code: Option(String))
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
    requester: Option(String),
    date: Option(String),
    identifier: Option(String),
    subject: Option(String),
    supplier: Option(String),
    category: Option(String),
    status: Option(String),
  )
}

pub type SpTask {
  SpTask(
    owner: Option(String),
    requester: Option(String),
    identifier: Option(String),
    business_status: Option(String),
    period: Option(String),
    code: Option(String),
    performer: Option(String),
    subject: Option(String),
    focus: Option(String),
    part_of: Option(String),
    encounter: Option(String),
    priority: Option(String),
    authored_on: Option(String),
    intent: Option(String),
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
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    context_type: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
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
    title: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type SpValueset {
  SpValueset(
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

pub type SpVerificationresult {
  SpVerificationresult(target: Option(String))
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
  SpAccount(None, None, None, None, None, None, None, None)
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
  )
}

pub fn sp_us_core_allergyintolerance_new() {
  SpUsCoreAllergyintolerance(None, None)
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
  )
}

pub fn sp_appointmentresponse_new() {
  SpAppointmentresponse(None, None, None, None, None, None, None)
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
  SpBiologicallyderivedproduct
}

pub fn sp_bodystructure_new() {
  SpBodystructure(None, None, None, None)
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
  )
}

pub fn sp_us_core_careplan_new() {
  SpUsCoreCareplan(None, None, None, None)
}

pub fn sp_us_core_careteam_new() {
  SpUsCoreCareteam(None, None, None)
}

pub fn sp_catalogentry_new() {
  SpCatalogentry
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
  )
}

pub fn sp_us_core_condition_encounter_diagnosis_new() {
  SpUsCoreConditionEncounterDiagnosis(
    None,
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

pub fn sp_us_core_condition_problems_health_concerns_new() {
  SpUsCoreConditionProblemsHealthConcerns(
    None,
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
  )
}

pub fn sp_contract_new() {
  SpContract(None, None, None, None, None, None, None, None, None, None)
}

pub fn sp_us_core_coverage_new() {
  SpUsCoreCoverage(None)
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
  SpDetectedissue(None, None, None, None, None, None)
}

pub fn sp_us_core_device_new() {
  SpUsCoreDevice(None, None, None)
}

pub fn sp_devicedefinition_new() {
  SpDevicedefinition(None, None, None)
}

pub fn sp_devicemetric_new() {
  SpDevicemetric(None, None, None, None, None)
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
  )
}

pub fn sp_deviceusestatement_new() {
  SpDeviceusestatement(None, None, None, None)
}

pub fn sp_us_core_diagnosticreport_lab_new() {
  SpUsCoreDiagnosticreportLab(None, None, None, None, None, None)
}

pub fn sp_us_core_diagnosticreport_note_new() {
  SpUsCoreDiagnosticreportNote(None, None, None, None, None, None)
}

pub fn sp_documentmanifest_new() {
  SpDocumentmanifest(
    None,
    None,
    None,
    None,
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

pub fn sp_us_core_documentreference_new() {
  SpUsCoreDocumentreference(None, None, None, None, None, None, None)
}

pub fn sp_us_core_adi_documentreference_new() {
  SpUsCoreAdiDocumentreference(None, None, None, None, None, None, None)
}

pub fn sp_effectevidencesynthesis_new() {
  SpEffectevidencesynthesis(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
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

pub fn sp_us_core_encounter_new() {
  SpUsCoreEncounter(None, None, None, None, None, None, None, None, None, None)
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
  SpEpisodeofcare(None, None, None, None, None, None, None, None, None)
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

pub fn sp_us_core_familymemberhistory_new() {
  SpUsCoreFamilymemberhistory(None, None)
}

pub fn sp_flag_new() {
  SpFlag(None, None, None, None, None, None)
}

pub fn sp_us_core_goal_new() {
  SpUsCoreGoal(None, None, None, None)
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
  )
}

pub fn sp_group_new() {
  SpGroup(None, None, None, None, None, None, None, None, None, None)
}

pub fn sp_guidanceresponse_new() {
  SpGuidanceresponse(None, None, None, None)
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

pub fn sp_us_core_immunization_new() {
  SpUsCoreImmunization(None, None, None)
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

pub fn sp_us_core_location_new() {
  SpUsCoreLocation(None, None, None, None, None)
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
  SpMeasurereport(None, None, None, None, None, None, None, None, None)
}

pub fn sp_media_new() {
  SpMedia(
    None,
    None,
    None,
    None,
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

pub fn sp_us_core_medication_new() {
  SpUsCoreMedication
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
  )
}

pub fn sp_us_core_medicationdispense_new() {
  SpUsCoreMedicationdispense(None, None, None)
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
  )
}

pub fn sp_us_core_medicationrequest_new() {
  SpUsCoreMedicationrequest(None, None, None, None, None)
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

pub fn sp_medicinalproduct_new() {
  SpMedicinalproduct(None, None, None)
}

pub fn sp_medicinalproductauthorization_new() {
  SpMedicinalproductauthorization(None, None, None, None, None)
}

pub fn sp_medicinalproductcontraindication_new() {
  SpMedicinalproductcontraindication(None)
}

pub fn sp_medicinalproductindication_new() {
  SpMedicinalproductindication(None)
}

pub fn sp_medicinalproductingredient_new() {
  SpMedicinalproductingredient
}

pub fn sp_medicinalproductinteraction_new() {
  SpMedicinalproductinteraction(None)
}

pub fn sp_medicinalproductmanufactured_new() {
  SpMedicinalproductmanufactured
}

pub fn sp_medicinalproductpackaged_new() {
  SpMedicinalproductpackaged(None, None)
}

pub fn sp_medicinalproductpharmaceutical_new() {
  SpMedicinalproductpharmaceutical(None, None, None)
}

pub fn sp_medicinalproductundesirableeffect_new() {
  SpMedicinalproductundesirableeffect(None)
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
    None,
    None,
    None,
  )
}

pub fn sp_molecularsequence_new() {
  SpMolecularsequence(
    None,
    None,
    None,
    None,
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
  )
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

pub fn sp_us_core_body_temperature_new() {
  SpUsCoreBodyTemperature(None, None, None, None, None, None)
}

pub fn sp_us_core_observation_clinical_result_new() {
  SpUsCoreObservationClinicalResult(None, None, None, None, None, None)
}

pub fn sp_us_core_observation_lab_new() {
  SpUsCoreObservationLab(None, None, None, None, None, None)
}

pub fn sp_us_core_treatment_intervention_preference_new() {
  SpUsCoreTreatmentInterventionPreference(None, None, None, None, None, None)
}

pub fn sp_us_core_observation_pregnancyintent_new() {
  SpUsCoreObservationPregnancyintent(None, None, None, None, None, None)
}

pub fn sp_us_core_simple_observation_new() {
  SpUsCoreSimpleObservation(None, None, None, None, None, None)
}

pub fn sp_us_core_respiratory_rate_new() {
  SpUsCoreRespiratoryRate(None, None, None, None, None, None)
}

pub fn sp_us_core_observation_occupation_new() {
  SpUsCoreObservationOccupation(None, None, None, None, None, None)
}

pub fn sp_us_core_vital_signs_new() {
  SpUsCoreVitalSigns(None, None, None, None, None, None)
}

pub fn sp_us_core_body_weight_new() {
  SpUsCoreBodyWeight(None, None, None, None, None, None)
}

pub fn sp_us_core_observation_pregnancystatus_new() {
  SpUsCoreObservationPregnancystatus(None, None, None, None, None, None)
}

pub fn sp_us_core_blood_pressure_new() {
  SpUsCoreBloodPressure(None, None, None, None, None, None)
}

pub fn sp_pediatric_bmi_for_age_new() {
  SpPediatricBmiForAge(None, None, None, None, None, None)
}

pub fn sp_us_core_care_experience_preference_new() {
  SpUsCoreCareExperiencePreference(None, None, None, None, None, None)
}

pub fn sp_us_core_observation_screening_assessment_new() {
  SpUsCoreObservationScreeningAssessment(None, None, None, None, None, None)
}

pub fn sp_us_core_head_circumference_new() {
  SpUsCoreHeadCircumference(None, None, None, None, None, None)
}

pub fn sp_us_core_heart_rate_new() {
  SpUsCoreHeartRate(None, None, None, None, None, None)
}

pub fn sp_us_core_observation_sexual_orientation_new() {
  SpUsCoreObservationSexualOrientation(None, None, None, None, None, None)
}

pub fn sp_pediatric_weight_for_height_new() {
  SpPediatricWeightForHeight(None, None, None, None, None, None)
}

pub fn sp_us_core_bmi_new() {
  SpUsCoreBmi(None, None, None, None, None, None)
}

pub fn sp_us_core_body_height_new() {
  SpUsCoreBodyHeight(None, None, None, None, None, None)
}

pub fn sp_us_core_smokingstatus_new() {
  SpUsCoreSmokingstatus(None, None, None, None, None, None)
}

pub fn sp_us_core_pulse_oximetry_new() {
  SpUsCorePulseOximetry(None, None, None, None, None, None)
}

pub fn sp_head_occipital_frontal_circumference_percentile_new() {
  SpHeadOccipitalFrontalCircumferencePercentile(
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn sp_us_core_average_blood_pressure_new() {
  SpUsCoreAverageBloodPressure(None, None, None, None, None, None)
}

pub fn sp_us_core_observation_adi_documentation_new() {
  SpUsCoreObservationAdiDocumentation(None, None, None, None, None, None)
}

pub fn sp_observationdefinition_new() {
  SpObservationdefinition
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
  )
}

pub fn sp_operationoutcome_new() {
  SpOperationoutcome
}

pub fn sp_us_core_organization_new() {
  SpUsCoreOrganization(None, None)
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

pub fn sp_us_core_patient_new() {
  SpUsCorePatient(None, None, None, None, None, None, None)
}

pub fn sp_paymentnotice_new() {
  SpPaymentnotice(None, None, None, None, None, None, None)
}

pub fn sp_paymentreconciliation_new() {
  SpPaymentreconciliation(None, None, None, None, None, None, None, None)
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

pub fn sp_us_core_practitioner_new() {
  SpUsCorePractitioner(None, None, None)
}

pub fn sp_us_core_practitionerrole_new() {
  SpUsCorePractitionerrole(None, None)
}

pub fn sp_us_core_procedure_new() {
  SpUsCoreProcedure(None, None, None, None)
}

pub fn sp_us_core_provenance_new() {
  SpUsCoreProvenance
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
  )
}

pub fn sp_us_core_questionnaireresponse_new() {
  SpUsCoreQuestionnaireresponse(None, None, None, None, None)
}

pub fn sp_us_core_relatedperson_new() {
  SpUsCoreRelatedperson(None, None, None)
}

pub fn sp_requestgroup_new() {
  SpRequestgroup(
    None,
    None,
    None,
    None,
    None,
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

pub fn sp_researchdefinition_new() {
  SpResearchdefinition(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
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

pub fn sp_researchelementdefinition_new() {
  SpResearchelementdefinition(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
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
  )
}

pub fn sp_researchsubject_new() {
  SpResearchsubject(None, None, None, None, None, None)
}

pub fn sp_riskassessment_new() {
  SpRiskassessment(None, None, None, None, None, None, None, None, None, None)
}

pub fn sp_riskevidencesynthesis_new() {
  SpRiskevidencesynthesis(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
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

pub fn sp_schedule_new() {
  SpSchedule(None, None, None, None, None, None, None)
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
  )
}

pub fn sp_us_core_servicerequest_new() {
  SpUsCoreServicerequest(None, None, None, None, None, None)
}

pub fn sp_slot_new() {
  SpSlot(None, None, None, None, None, None, None, None)
}

pub fn sp_us_core_specimen_new() {
  SpUsCoreSpecimen(None, None)
}

pub fn sp_specimendefinition_new() {
  SpSpecimendefinition(None, None, None)
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
  SpSubscription(None, None, None, None, None, None)
}

pub fn sp_substance_new() {
  SpSubstance(None, None, None, None, None, None, None, None)
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

pub fn sp_substancespecification_new() {
  SpSubstancespecification(None)
}

pub fn sp_supplydelivery_new() {
  SpSupplydelivery(None, None, None, None, None)
}

pub fn sp_supplyrequest_new() {
  SpSupplyrequest(None, None, None, None, None, None, None)
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
  )
}

pub fn sp_testreport_new() {
  SpTestreport(None, None, None, None, None, None)
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
  )
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
  )
}

pub fn sp_verificationresult_new() {
  SpVerificationresult(None)
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
    inc_adverseevent: Option(SpInclude),
    revinc_adverseevent: Option(SpInclude),
    inc_us_core_allergyintolerance: Option(SpInclude),
    revinc_us_core_allergyintolerance: Option(SpInclude),
    inc_appointment: Option(SpInclude),
    revinc_appointment: Option(SpInclude),
    inc_appointmentresponse: Option(SpInclude),
    revinc_appointmentresponse: Option(SpInclude),
    inc_auditevent: Option(SpInclude),
    revinc_auditevent: Option(SpInclude),
    inc_basic: Option(SpInclude),
    revinc_basic: Option(SpInclude),
    inc_binary: Option(SpInclude),
    revinc_binary: Option(SpInclude),
    inc_biologicallyderivedproduct: Option(SpInclude),
    revinc_biologicallyderivedproduct: Option(SpInclude),
    inc_bodystructure: Option(SpInclude),
    revinc_bodystructure: Option(SpInclude),
    inc_bundle: Option(SpInclude),
    revinc_bundle: Option(SpInclude),
    inc_capabilitystatement: Option(SpInclude),
    revinc_capabilitystatement: Option(SpInclude),
    inc_us_core_careplan: Option(SpInclude),
    revinc_us_core_careplan: Option(SpInclude),
    inc_us_core_careteam: Option(SpInclude),
    revinc_us_core_careteam: Option(SpInclude),
    inc_catalogentry: Option(SpInclude),
    revinc_catalogentry: Option(SpInclude),
    inc_chargeitem: Option(SpInclude),
    revinc_chargeitem: Option(SpInclude),
    inc_chargeitemdefinition: Option(SpInclude),
    revinc_chargeitemdefinition: Option(SpInclude),
    inc_claim: Option(SpInclude),
    revinc_claim: Option(SpInclude),
    inc_claimresponse: Option(SpInclude),
    revinc_claimresponse: Option(SpInclude),
    inc_clinicalimpression: Option(SpInclude),
    revinc_clinicalimpression: Option(SpInclude),
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
    inc_us_core_condition_encounter_diagnosis: Option(SpInclude),
    revinc_us_core_condition_encounter_diagnosis: Option(SpInclude),
    inc_us_core_condition_problems_health_concerns: Option(SpInclude),
    revinc_us_core_condition_problems_health_concerns: Option(SpInclude),
    inc_consent: Option(SpInclude),
    revinc_consent: Option(SpInclude),
    inc_contract: Option(SpInclude),
    revinc_contract: Option(SpInclude),
    inc_us_core_coverage: Option(SpInclude),
    revinc_us_core_coverage: Option(SpInclude),
    inc_coverageeligibilityrequest: Option(SpInclude),
    revinc_coverageeligibilityrequest: Option(SpInclude),
    inc_coverageeligibilityresponse: Option(SpInclude),
    revinc_coverageeligibilityresponse: Option(SpInclude),
    inc_detectedissue: Option(SpInclude),
    revinc_detectedissue: Option(SpInclude),
    inc_us_core_device: Option(SpInclude),
    revinc_us_core_device: Option(SpInclude),
    inc_devicedefinition: Option(SpInclude),
    revinc_devicedefinition: Option(SpInclude),
    inc_devicemetric: Option(SpInclude),
    revinc_devicemetric: Option(SpInclude),
    inc_devicerequest: Option(SpInclude),
    revinc_devicerequest: Option(SpInclude),
    inc_deviceusestatement: Option(SpInclude),
    revinc_deviceusestatement: Option(SpInclude),
    inc_us_core_diagnosticreport_lab: Option(SpInclude),
    revinc_us_core_diagnosticreport_lab: Option(SpInclude),
    inc_us_core_diagnosticreport_note: Option(SpInclude),
    revinc_us_core_diagnosticreport_note: Option(SpInclude),
    inc_documentmanifest: Option(SpInclude),
    revinc_documentmanifest: Option(SpInclude),
    inc_us_core_documentreference: Option(SpInclude),
    revinc_us_core_documentreference: Option(SpInclude),
    inc_us_core_adi_documentreference: Option(SpInclude),
    revinc_us_core_adi_documentreference: Option(SpInclude),
    inc_effectevidencesynthesis: Option(SpInclude),
    revinc_effectevidencesynthesis: Option(SpInclude),
    inc_us_core_encounter: Option(SpInclude),
    revinc_us_core_encounter: Option(SpInclude),
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
    inc_evidencevariable: Option(SpInclude),
    revinc_evidencevariable: Option(SpInclude),
    inc_examplescenario: Option(SpInclude),
    revinc_examplescenario: Option(SpInclude),
    inc_explanationofbenefit: Option(SpInclude),
    revinc_explanationofbenefit: Option(SpInclude),
    inc_us_core_familymemberhistory: Option(SpInclude),
    revinc_us_core_familymemberhistory: Option(SpInclude),
    inc_flag: Option(SpInclude),
    revinc_flag: Option(SpInclude),
    inc_us_core_goal: Option(SpInclude),
    revinc_us_core_goal: Option(SpInclude),
    inc_graphdefinition: Option(SpInclude),
    revinc_graphdefinition: Option(SpInclude),
    inc_group: Option(SpInclude),
    revinc_group: Option(SpInclude),
    inc_guidanceresponse: Option(SpInclude),
    revinc_guidanceresponse: Option(SpInclude),
    inc_healthcareservice: Option(SpInclude),
    revinc_healthcareservice: Option(SpInclude),
    inc_imagingstudy: Option(SpInclude),
    revinc_imagingstudy: Option(SpInclude),
    inc_us_core_immunization: Option(SpInclude),
    revinc_us_core_immunization: Option(SpInclude),
    inc_immunizationevaluation: Option(SpInclude),
    revinc_immunizationevaluation: Option(SpInclude),
    inc_immunizationrecommendation: Option(SpInclude),
    revinc_immunizationrecommendation: Option(SpInclude),
    inc_implementationguide: Option(SpInclude),
    revinc_implementationguide: Option(SpInclude),
    inc_insuranceplan: Option(SpInclude),
    revinc_insuranceplan: Option(SpInclude),
    inc_invoice: Option(SpInclude),
    revinc_invoice: Option(SpInclude),
    inc_library: Option(SpInclude),
    revinc_library: Option(SpInclude),
    inc_linkage: Option(SpInclude),
    revinc_linkage: Option(SpInclude),
    inc_listfhir: Option(SpInclude),
    revinc_listfhir: Option(SpInclude),
    inc_us_core_location: Option(SpInclude),
    revinc_us_core_location: Option(SpInclude),
    inc_measure: Option(SpInclude),
    revinc_measure: Option(SpInclude),
    inc_measurereport: Option(SpInclude),
    revinc_measurereport: Option(SpInclude),
    inc_media: Option(SpInclude),
    revinc_media: Option(SpInclude),
    inc_us_core_medication: Option(SpInclude),
    revinc_us_core_medication: Option(SpInclude),
    inc_medicationadministration: Option(SpInclude),
    revinc_medicationadministration: Option(SpInclude),
    inc_us_core_medicationdispense: Option(SpInclude),
    revinc_us_core_medicationdispense: Option(SpInclude),
    inc_medicationknowledge: Option(SpInclude),
    revinc_medicationknowledge: Option(SpInclude),
    inc_us_core_medicationrequest: Option(SpInclude),
    revinc_us_core_medicationrequest: Option(SpInclude),
    inc_medicationstatement: Option(SpInclude),
    revinc_medicationstatement: Option(SpInclude),
    inc_medicinalproduct: Option(SpInclude),
    revinc_medicinalproduct: Option(SpInclude),
    inc_medicinalproductauthorization: Option(SpInclude),
    revinc_medicinalproductauthorization: Option(SpInclude),
    inc_medicinalproductcontraindication: Option(SpInclude),
    revinc_medicinalproductcontraindication: Option(SpInclude),
    inc_medicinalproductindication: Option(SpInclude),
    revinc_medicinalproductindication: Option(SpInclude),
    inc_medicinalproductingredient: Option(SpInclude),
    revinc_medicinalproductingredient: Option(SpInclude),
    inc_medicinalproductinteraction: Option(SpInclude),
    revinc_medicinalproductinteraction: Option(SpInclude),
    inc_medicinalproductmanufactured: Option(SpInclude),
    revinc_medicinalproductmanufactured: Option(SpInclude),
    inc_medicinalproductpackaged: Option(SpInclude),
    revinc_medicinalproductpackaged: Option(SpInclude),
    inc_medicinalproductpharmaceutical: Option(SpInclude),
    revinc_medicinalproductpharmaceutical: Option(SpInclude),
    inc_medicinalproductundesirableeffect: Option(SpInclude),
    revinc_medicinalproductundesirableeffect: Option(SpInclude),
    inc_messagedefinition: Option(SpInclude),
    revinc_messagedefinition: Option(SpInclude),
    inc_messageheader: Option(SpInclude),
    revinc_messageheader: Option(SpInclude),
    inc_molecularsequence: Option(SpInclude),
    revinc_molecularsequence: Option(SpInclude),
    inc_namingsystem: Option(SpInclude),
    revinc_namingsystem: Option(SpInclude),
    inc_nutritionorder: Option(SpInclude),
    revinc_nutritionorder: Option(SpInclude),
    inc_us_core_body_temperature: Option(SpInclude),
    revinc_us_core_body_temperature: Option(SpInclude),
    inc_us_core_observation_clinical_result: Option(SpInclude),
    revinc_us_core_observation_clinical_result: Option(SpInclude),
    inc_us_core_observation_lab: Option(SpInclude),
    revinc_us_core_observation_lab: Option(SpInclude),
    inc_us_core_treatment_intervention_preference: Option(SpInclude),
    revinc_us_core_treatment_intervention_preference: Option(SpInclude),
    inc_us_core_observation_pregnancyintent: Option(SpInclude),
    revinc_us_core_observation_pregnancyintent: Option(SpInclude),
    inc_us_core_simple_observation: Option(SpInclude),
    revinc_us_core_simple_observation: Option(SpInclude),
    inc_us_core_respiratory_rate: Option(SpInclude),
    revinc_us_core_respiratory_rate: Option(SpInclude),
    inc_us_core_observation_occupation: Option(SpInclude),
    revinc_us_core_observation_occupation: Option(SpInclude),
    inc_us_core_vital_signs: Option(SpInclude),
    revinc_us_core_vital_signs: Option(SpInclude),
    inc_us_core_body_weight: Option(SpInclude),
    revinc_us_core_body_weight: Option(SpInclude),
    inc_us_core_observation_pregnancystatus: Option(SpInclude),
    revinc_us_core_observation_pregnancystatus: Option(SpInclude),
    inc_us_core_blood_pressure: Option(SpInclude),
    revinc_us_core_blood_pressure: Option(SpInclude),
    inc_pediatric_bmi_for_age: Option(SpInclude),
    revinc_pediatric_bmi_for_age: Option(SpInclude),
    inc_us_core_care_experience_preference: Option(SpInclude),
    revinc_us_core_care_experience_preference: Option(SpInclude),
    inc_us_core_observation_screening_assessment: Option(SpInclude),
    revinc_us_core_observation_screening_assessment: Option(SpInclude),
    inc_us_core_head_circumference: Option(SpInclude),
    revinc_us_core_head_circumference: Option(SpInclude),
    inc_us_core_heart_rate: Option(SpInclude),
    revinc_us_core_heart_rate: Option(SpInclude),
    inc_us_core_observation_sexual_orientation: Option(SpInclude),
    revinc_us_core_observation_sexual_orientation: Option(SpInclude),
    inc_pediatric_weight_for_height: Option(SpInclude),
    revinc_pediatric_weight_for_height: Option(SpInclude),
    inc_us_core_bmi: Option(SpInclude),
    revinc_us_core_bmi: Option(SpInclude),
    inc_us_core_body_height: Option(SpInclude),
    revinc_us_core_body_height: Option(SpInclude),
    inc_us_core_smokingstatus: Option(SpInclude),
    revinc_us_core_smokingstatus: Option(SpInclude),
    inc_us_core_pulse_oximetry: Option(SpInclude),
    revinc_us_core_pulse_oximetry: Option(SpInclude),
    inc_head_occipital_frontal_circumference_percentile: Option(SpInclude),
    revinc_head_occipital_frontal_circumference_percentile: Option(SpInclude),
    inc_us_core_average_blood_pressure: Option(SpInclude),
    revinc_us_core_average_blood_pressure: Option(SpInclude),
    inc_us_core_observation_adi_documentation: Option(SpInclude),
    revinc_us_core_observation_adi_documentation: Option(SpInclude),
    inc_observationdefinition: Option(SpInclude),
    revinc_observationdefinition: Option(SpInclude),
    inc_operationdefinition: Option(SpInclude),
    revinc_operationdefinition: Option(SpInclude),
    inc_operationoutcome: Option(SpInclude),
    revinc_operationoutcome: Option(SpInclude),
    inc_us_core_organization: Option(SpInclude),
    revinc_us_core_organization: Option(SpInclude),
    inc_organizationaffiliation: Option(SpInclude),
    revinc_organizationaffiliation: Option(SpInclude),
    inc_us_core_patient: Option(SpInclude),
    revinc_us_core_patient: Option(SpInclude),
    inc_paymentnotice: Option(SpInclude),
    revinc_paymentnotice: Option(SpInclude),
    inc_paymentreconciliation: Option(SpInclude),
    revinc_paymentreconciliation: Option(SpInclude),
    inc_person: Option(SpInclude),
    revinc_person: Option(SpInclude),
    inc_plandefinition: Option(SpInclude),
    revinc_plandefinition: Option(SpInclude),
    inc_us_core_practitioner: Option(SpInclude),
    revinc_us_core_practitioner: Option(SpInclude),
    inc_us_core_practitionerrole: Option(SpInclude),
    revinc_us_core_practitionerrole: Option(SpInclude),
    inc_us_core_procedure: Option(SpInclude),
    revinc_us_core_procedure: Option(SpInclude),
    inc_us_core_provenance: Option(SpInclude),
    revinc_us_core_provenance: Option(SpInclude),
    inc_questionnaire: Option(SpInclude),
    revinc_questionnaire: Option(SpInclude),
    inc_us_core_questionnaireresponse: Option(SpInclude),
    revinc_us_core_questionnaireresponse: Option(SpInclude),
    inc_us_core_relatedperson: Option(SpInclude),
    revinc_us_core_relatedperson: Option(SpInclude),
    inc_requestgroup: Option(SpInclude),
    revinc_requestgroup: Option(SpInclude),
    inc_researchdefinition: Option(SpInclude),
    revinc_researchdefinition: Option(SpInclude),
    inc_researchelementdefinition: Option(SpInclude),
    revinc_researchelementdefinition: Option(SpInclude),
    inc_researchstudy: Option(SpInclude),
    revinc_researchstudy: Option(SpInclude),
    inc_researchsubject: Option(SpInclude),
    revinc_researchsubject: Option(SpInclude),
    inc_riskassessment: Option(SpInclude),
    revinc_riskassessment: Option(SpInclude),
    inc_riskevidencesynthesis: Option(SpInclude),
    revinc_riskevidencesynthesis: Option(SpInclude),
    inc_schedule: Option(SpInclude),
    revinc_schedule: Option(SpInclude),
    inc_searchparameter: Option(SpInclude),
    revinc_searchparameter: Option(SpInclude),
    inc_us_core_servicerequest: Option(SpInclude),
    revinc_us_core_servicerequest: Option(SpInclude),
    inc_slot: Option(SpInclude),
    revinc_slot: Option(SpInclude),
    inc_us_core_specimen: Option(SpInclude),
    revinc_us_core_specimen: Option(SpInclude),
    inc_specimendefinition: Option(SpInclude),
    revinc_specimendefinition: Option(SpInclude),
    inc_structuredefinition: Option(SpInclude),
    revinc_structuredefinition: Option(SpInclude),
    inc_structuremap: Option(SpInclude),
    revinc_structuremap: Option(SpInclude),
    inc_subscription: Option(SpInclude),
    revinc_subscription: Option(SpInclude),
    inc_substance: Option(SpInclude),
    revinc_substance: Option(SpInclude),
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
    inc_substancespecification: Option(SpInclude),
    revinc_substancespecification: Option(SpInclude),
    inc_supplydelivery: Option(SpInclude),
    revinc_supplydelivery: Option(SpInclude),
    inc_supplyrequest: Option(SpInclude),
    revinc_supplyrequest: Option(SpInclude),
    inc_task: Option(SpInclude),
    revinc_task: Option(SpInclude),
    inc_terminologycapabilities: Option(SpInclude),
    revinc_terminologycapabilities: Option(SpInclude),
    inc_testreport: Option(SpInclude),
    revinc_testreport: Option(SpInclude),
    inc_testscript: Option(SpInclude),
    revinc_testscript: Option(SpInclude),
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
    account: List(r4us.Account),
    activitydefinition: List(r4us.Activitydefinition),
    adverseevent: List(r4us.Adverseevent),
    us_core_allergyintolerance: List(r4us.UsCoreAllergyintolerance),
    appointment: List(r4us.Appointment),
    appointmentresponse: List(r4us.Appointmentresponse),
    auditevent: List(r4us.Auditevent),
    basic: List(r4us.Basic),
    binary: List(r4us.Binary),
    biologicallyderivedproduct: List(r4us.Biologicallyderivedproduct),
    bodystructure: List(r4us.Bodystructure),
    bundle: List(r4us.Bundle),
    capabilitystatement: List(r4us.Capabilitystatement),
    us_core_careplan: List(r4us.UsCoreCareplan),
    us_core_careteam: List(r4us.UsCoreCareteam),
    catalogentry: List(r4us.Catalogentry),
    chargeitem: List(r4us.Chargeitem),
    chargeitemdefinition: List(r4us.Chargeitemdefinition),
    claim: List(r4us.Claim),
    claimresponse: List(r4us.Claimresponse),
    clinicalimpression: List(r4us.Clinicalimpression),
    codesystem: List(r4us.Codesystem),
    communication: List(r4us.Communication),
    communicationrequest: List(r4us.Communicationrequest),
    compartmentdefinition: List(r4us.Compartmentdefinition),
    composition: List(r4us.Composition),
    conceptmap: List(r4us.Conceptmap),
    us_core_condition_encounter_diagnosis: List(
      r4us.UsCoreConditionEncounterDiagnosis,
    ),
    us_core_condition_problems_health_concerns: List(
      r4us.UsCoreConditionProblemsHealthConcerns,
    ),
    consent: List(r4us.Consent),
    contract: List(r4us.Contract),
    us_core_coverage: List(r4us.UsCoreCoverage),
    coverageeligibilityrequest: List(r4us.Coverageeligibilityrequest),
    coverageeligibilityresponse: List(r4us.Coverageeligibilityresponse),
    detectedissue: List(r4us.Detectedissue),
    us_core_device: List(r4us.UsCoreDevice),
    devicedefinition: List(r4us.Devicedefinition),
    devicemetric: List(r4us.Devicemetric),
    devicerequest: List(r4us.Devicerequest),
    deviceusestatement: List(r4us.Deviceusestatement),
    us_core_diagnosticreport_lab: List(r4us.UsCoreDiagnosticreportLab),
    us_core_diagnosticreport_note: List(r4us.UsCoreDiagnosticreportNote),
    documentmanifest: List(r4us.Documentmanifest),
    us_core_documentreference: List(r4us.UsCoreDocumentreference),
    us_core_adi_documentreference: List(r4us.UsCoreAdiDocumentreference),
    effectevidencesynthesis: List(r4us.Effectevidencesynthesis),
    us_core_encounter: List(r4us.UsCoreEncounter),
    endpoint: List(r4us.Endpoint),
    enrollmentrequest: List(r4us.Enrollmentrequest),
    enrollmentresponse: List(r4us.Enrollmentresponse),
    episodeofcare: List(r4us.Episodeofcare),
    eventdefinition: List(r4us.Eventdefinition),
    evidence: List(r4us.Evidence),
    evidencevariable: List(r4us.Evidencevariable),
    examplescenario: List(r4us.Examplescenario),
    explanationofbenefit: List(r4us.Explanationofbenefit),
    us_core_familymemberhistory: List(r4us.UsCoreFamilymemberhistory),
    flag: List(r4us.Flag),
    us_core_goal: List(r4us.UsCoreGoal),
    graphdefinition: List(r4us.Graphdefinition),
    group: List(r4us.Group),
    guidanceresponse: List(r4us.Guidanceresponse),
    healthcareservice: List(r4us.Healthcareservice),
    imagingstudy: List(r4us.Imagingstudy),
    us_core_immunization: List(r4us.UsCoreImmunization),
    immunizationevaluation: List(r4us.Immunizationevaluation),
    immunizationrecommendation: List(r4us.Immunizationrecommendation),
    implementationguide: List(r4us.Implementationguide),
    insuranceplan: List(r4us.Insuranceplan),
    invoice: List(r4us.Invoice),
    library: List(r4us.Library),
    linkage: List(r4us.Linkage),
    listfhir: List(r4us.Listfhir),
    us_core_location: List(r4us.UsCoreLocation),
    measure: List(r4us.Measure),
    measurereport: List(r4us.Measurereport),
    media: List(r4us.Media),
    us_core_medication: List(r4us.UsCoreMedication),
    medicationadministration: List(r4us.Medicationadministration),
    us_core_medicationdispense: List(r4us.UsCoreMedicationdispense),
    medicationknowledge: List(r4us.Medicationknowledge),
    us_core_medicationrequest: List(r4us.UsCoreMedicationrequest),
    medicationstatement: List(r4us.Medicationstatement),
    medicinalproduct: List(r4us.Medicinalproduct),
    medicinalproductauthorization: List(r4us.Medicinalproductauthorization),
    medicinalproductcontraindication: List(
      r4us.Medicinalproductcontraindication,
    ),
    medicinalproductindication: List(r4us.Medicinalproductindication),
    medicinalproductingredient: List(r4us.Medicinalproductingredient),
    medicinalproductinteraction: List(r4us.Medicinalproductinteraction),
    medicinalproductmanufactured: List(r4us.Medicinalproductmanufactured),
    medicinalproductpackaged: List(r4us.Medicinalproductpackaged),
    medicinalproductpharmaceutical: List(r4us.Medicinalproductpharmaceutical),
    medicinalproductundesirableeffect: List(
      r4us.Medicinalproductundesirableeffect,
    ),
    messagedefinition: List(r4us.Messagedefinition),
    messageheader: List(r4us.Messageheader),
    molecularsequence: List(r4us.Molecularsequence),
    namingsystem: List(r4us.Namingsystem),
    nutritionorder: List(r4us.Nutritionorder),
    us_core_body_temperature: List(r4us.UsCoreBodyTemperature),
    us_core_observation_clinical_result: List(
      r4us.UsCoreObservationClinicalResult,
    ),
    us_core_observation_lab: List(r4us.UsCoreObservationLab),
    us_core_treatment_intervention_preference: List(
      r4us.UsCoreTreatmentInterventionPreference,
    ),
    us_core_observation_pregnancyintent: List(
      r4us.UsCoreObservationPregnancyintent,
    ),
    us_core_simple_observation: List(r4us.UsCoreSimpleObservation),
    us_core_respiratory_rate: List(r4us.UsCoreRespiratoryRate),
    us_core_observation_occupation: List(r4us.UsCoreObservationOccupation),
    us_core_vital_signs: List(r4us.UsCoreVitalSigns),
    us_core_body_weight: List(r4us.UsCoreBodyWeight),
    us_core_observation_pregnancystatus: List(
      r4us.UsCoreObservationPregnancystatus,
    ),
    us_core_blood_pressure: List(r4us.UsCoreBloodPressure),
    pediatric_bmi_for_age: List(r4us.PediatricBmiForAge),
    us_core_care_experience_preference: List(
      r4us.UsCoreCareExperiencePreference,
    ),
    us_core_observation_screening_assessment: List(
      r4us.UsCoreObservationScreeningAssessment,
    ),
    us_core_head_circumference: List(r4us.UsCoreHeadCircumference),
    us_core_heart_rate: List(r4us.UsCoreHeartRate),
    us_core_observation_sexual_orientation: List(
      r4us.UsCoreObservationSexualOrientation,
    ),
    pediatric_weight_for_height: List(r4us.PediatricWeightForHeight),
    us_core_bmi: List(r4us.UsCoreBmi),
    us_core_body_height: List(r4us.UsCoreBodyHeight),
    us_core_smokingstatus: List(r4us.UsCoreSmokingstatus),
    us_core_pulse_oximetry: List(r4us.UsCorePulseOximetry),
    head_occipital_frontal_circumference_percentile: List(
      r4us.HeadOccipitalFrontalCircumferencePercentile,
    ),
    us_core_average_blood_pressure: List(r4us.UsCoreAverageBloodPressure),
    us_core_observation_adi_documentation: List(
      r4us.UsCoreObservationAdiDocumentation,
    ),
    observationdefinition: List(r4us.Observationdefinition),
    operationdefinition: List(r4us.Operationdefinition),
    operationoutcome: List(r4us.Operationoutcome),
    us_core_organization: List(r4us.UsCoreOrganization),
    organizationaffiliation: List(r4us.Organizationaffiliation),
    us_core_patient: List(r4us.UsCorePatient),
    paymentnotice: List(r4us.Paymentnotice),
    paymentreconciliation: List(r4us.Paymentreconciliation),
    person: List(r4us.Person),
    plandefinition: List(r4us.Plandefinition),
    us_core_practitioner: List(r4us.UsCorePractitioner),
    us_core_practitionerrole: List(r4us.UsCorePractitionerrole),
    us_core_procedure: List(r4us.UsCoreProcedure),
    us_core_provenance: List(r4us.UsCoreProvenance),
    questionnaire: List(r4us.Questionnaire),
    us_core_questionnaireresponse: List(r4us.UsCoreQuestionnaireresponse),
    us_core_relatedperson: List(r4us.UsCoreRelatedperson),
    requestgroup: List(r4us.Requestgroup),
    researchdefinition: List(r4us.Researchdefinition),
    researchelementdefinition: List(r4us.Researchelementdefinition),
    researchstudy: List(r4us.Researchstudy),
    researchsubject: List(r4us.Researchsubject),
    riskassessment: List(r4us.Riskassessment),
    riskevidencesynthesis: List(r4us.Riskevidencesynthesis),
    schedule: List(r4us.Schedule),
    searchparameter: List(r4us.Searchparameter),
    us_core_servicerequest: List(r4us.UsCoreServicerequest),
    slot: List(r4us.Slot),
    us_core_specimen: List(r4us.UsCoreSpecimen),
    specimendefinition: List(r4us.Specimendefinition),
    structuredefinition: List(r4us.Structuredefinition),
    structuremap: List(r4us.Structuremap),
    subscription: List(r4us.Subscription),
    substance: List(r4us.Substance),
    substancenucleicacid: List(r4us.Substancenucleicacid),
    substancepolymer: List(r4us.Substancepolymer),
    substanceprotein: List(r4us.Substanceprotein),
    substancereferenceinformation: List(r4us.Substancereferenceinformation),
    substancesourcematerial: List(r4us.Substancesourcematerial),
    substancespecification: List(r4us.Substancespecification),
    supplydelivery: List(r4us.Supplydelivery),
    supplyrequest: List(r4us.Supplyrequest),
    task: List(r4us.Task),
    terminologycapabilities: List(r4us.Terminologycapabilities),
    testreport: List(r4us.Testreport),
    testscript: List(r4us.Testscript),
    valueset: List(r4us.Valueset),
    verificationresult: List(r4us.Verificationresult),
    visionprescription: List(r4us.Visionprescription),
  )
}

pub fn groupedresources_new() {
  GroupedResources(
    account: [],
    activitydefinition: [],
    adverseevent: [],
    us_core_allergyintolerance: [],
    appointment: [],
    appointmentresponse: [],
    auditevent: [],
    basic: [],
    binary: [],
    biologicallyderivedproduct: [],
    bodystructure: [],
    bundle: [],
    capabilitystatement: [],
    us_core_careplan: [],
    us_core_careteam: [],
    catalogentry: [],
    chargeitem: [],
    chargeitemdefinition: [],
    claim: [],
    claimresponse: [],
    clinicalimpression: [],
    codesystem: [],
    communication: [],
    communicationrequest: [],
    compartmentdefinition: [],
    composition: [],
    conceptmap: [],
    us_core_condition_encounter_diagnosis: [],
    us_core_condition_problems_health_concerns: [],
    consent: [],
    contract: [],
    us_core_coverage: [],
    coverageeligibilityrequest: [],
    coverageeligibilityresponse: [],
    detectedissue: [],
    us_core_device: [],
    devicedefinition: [],
    devicemetric: [],
    devicerequest: [],
    deviceusestatement: [],
    us_core_diagnosticreport_lab: [],
    us_core_diagnosticreport_note: [],
    documentmanifest: [],
    us_core_documentreference: [],
    us_core_adi_documentreference: [],
    effectevidencesynthesis: [],
    us_core_encounter: [],
    endpoint: [],
    enrollmentrequest: [],
    enrollmentresponse: [],
    episodeofcare: [],
    eventdefinition: [],
    evidence: [],
    evidencevariable: [],
    examplescenario: [],
    explanationofbenefit: [],
    us_core_familymemberhistory: [],
    flag: [],
    us_core_goal: [],
    graphdefinition: [],
    group: [],
    guidanceresponse: [],
    healthcareservice: [],
    imagingstudy: [],
    us_core_immunization: [],
    immunizationevaluation: [],
    immunizationrecommendation: [],
    implementationguide: [],
    insuranceplan: [],
    invoice: [],
    library: [],
    linkage: [],
    listfhir: [],
    us_core_location: [],
    measure: [],
    measurereport: [],
    media: [],
    us_core_medication: [],
    medicationadministration: [],
    us_core_medicationdispense: [],
    medicationknowledge: [],
    us_core_medicationrequest: [],
    medicationstatement: [],
    medicinalproduct: [],
    medicinalproductauthorization: [],
    medicinalproductcontraindication: [],
    medicinalproductindication: [],
    medicinalproductingredient: [],
    medicinalproductinteraction: [],
    medicinalproductmanufactured: [],
    medicinalproductpackaged: [],
    medicinalproductpharmaceutical: [],
    medicinalproductundesirableeffect: [],
    messagedefinition: [],
    messageheader: [],
    molecularsequence: [],
    namingsystem: [],
    nutritionorder: [],
    us_core_body_temperature: [],
    us_core_observation_clinical_result: [],
    us_core_observation_lab: [],
    us_core_treatment_intervention_preference: [],
    us_core_observation_pregnancyintent: [],
    us_core_simple_observation: [],
    us_core_respiratory_rate: [],
    us_core_observation_occupation: [],
    us_core_vital_signs: [],
    us_core_body_weight: [],
    us_core_observation_pregnancystatus: [],
    us_core_blood_pressure: [],
    pediatric_bmi_for_age: [],
    us_core_care_experience_preference: [],
    us_core_observation_screening_assessment: [],
    us_core_head_circumference: [],
    us_core_heart_rate: [],
    us_core_observation_sexual_orientation: [],
    pediatric_weight_for_height: [],
    us_core_bmi: [],
    us_core_body_height: [],
    us_core_smokingstatus: [],
    us_core_pulse_oximetry: [],
    head_occipital_frontal_circumference_percentile: [],
    us_core_average_blood_pressure: [],
    us_core_observation_adi_documentation: [],
    observationdefinition: [],
    operationdefinition: [],
    operationoutcome: [],
    us_core_organization: [],
    organizationaffiliation: [],
    us_core_patient: [],
    paymentnotice: [],
    paymentreconciliation: [],
    person: [],
    plandefinition: [],
    us_core_practitioner: [],
    us_core_practitionerrole: [],
    us_core_procedure: [],
    us_core_provenance: [],
    questionnaire: [],
    us_core_questionnaireresponse: [],
    us_core_relatedperson: [],
    requestgroup: [],
    researchdefinition: [],
    researchelementdefinition: [],
    researchstudy: [],
    researchsubject: [],
    riskassessment: [],
    riskevidencesynthesis: [],
    schedule: [],
    searchparameter: [],
    us_core_servicerequest: [],
    slot: [],
    us_core_specimen: [],
    specimendefinition: [],
    structuredefinition: [],
    structuremap: [],
    subscription: [],
    substance: [],
    substancenucleicacid: [],
    substancepolymer: [],
    substanceprotein: [],
    substancereferenceinformation: [],
    substancesourcematerial: [],
    substancespecification: [],
    supplydelivery: [],
    supplyrequest: [],
    task: [],
    terminologycapabilities: [],
    testreport: [],
    testscript: [],
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
      #("subject", sp.subject),
      #("patient", sp.patient),
      #("name", sp.name),
      #("type", sp.type_),
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
      #("jurisdiction", sp.jurisdiction),
      #("description", sp.description),
      #("derived-from", sp.derived_from),
      #("context-type", sp.context_type),
      #("predecessor", sp.predecessor),
      #("title", sp.title),
      #("composed-of", sp.composed_of),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("effective", sp.effective),
      #("depends-on", sp.depends_on),
      #("name", sp.name),
      #("context", sp.context),
      #("publisher", sp.publisher),
      #("topic", sp.topic),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "ActivityDefinition", client)
}

pub fn adverseevent_search_req(sp: SpAdverseevent, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("severity", sp.severity),
      #("recorder", sp.recorder),
      #("study", sp.study),
      #("actuality", sp.actuality),
      #("seriousness", sp.seriousness),
      #("subject", sp.subject),
      #("resultingcondition", sp.resultingcondition),
      #("substance", sp.substance),
      #("location", sp.location),
      #("category", sp.category),
      #("event", sp.event),
    ])
  any_search_req(params, "AdverseEvent", client)
}

pub fn us_core_allergyintolerance_search_req(
  sp: SpUsCoreAllergyintolerance,
  client: FhirClient,
) {
  let params =
    using_params([
      #("clinical-status", sp.clinical_status),
      #("patient", sp.patient),
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
      #("part-status", sp.part_status),
      #("appointment-type", sp.appointment_type),
      #("service-type", sp.service_type),
      #("slot", sp.slot),
      #("reason-code", sp.reason_code),
      #("actor", sp.actor),
      #("based-on", sp.based_on),
      #("patient", sp.patient),
      #("reason-reference", sp.reason_reference),
      #("supporting-info", sp.supporting_info),
      #("location", sp.location),
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
    ])
  any_search_req(params, "AppointmentResponse", client)
}

pub fn auditevent_search_req(sp: SpAuditevent, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("entity-type", sp.entity_type),
      #("agent", sp.agent),
      #("address", sp.address),
      #("entity-role", sp.entity_role),
      #("source", sp.source),
      #("type", sp.type_),
      #("altid", sp.altid),
      #("site", sp.site),
      #("agent-name", sp.agent_name),
      #("entity-name", sp.entity_name),
      #("subtype", sp.subtype),
      #("patient", sp.patient),
      #("action", sp.action),
      #("agent-role", sp.agent_role),
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
      #("subject", sp.subject),
      #("created", sp.created),
      #("patient", sp.patient),
      #("author", sp.author),
    ])
  any_search_req(params, "Basic", client)
}

pub fn binary_search_req(_sp: SpBinary, client: FhirClient) {
  let params = using_params([])
  any_search_req(params, "Binary", client)
}

pub fn biologicallyderivedproduct_search_req(
  _sp: SpBiologicallyderivedproduct,
  client: FhirClient,
) {
  let params = using_params([])
  any_search_req(params, "BiologicallyDerivedProduct", client)
}

pub fn bodystructure_search_req(sp: SpBodystructure, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("morphology", sp.morphology),
      #("patient", sp.patient),
      #("location", sp.location),
    ])
  any_search_req(params, "BodyStructure", client)
}

pub fn bundle_search_req(sp: SpBundle, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("composition", sp.composition),
      #("type", sp.type_),
      #("message", sp.message),
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
      #("resource-profile", sp.resource_profile),
      #("context-type-value", sp.context_type_value),
      #("software", sp.software),
      #("resource", sp.resource),
      #("jurisdiction", sp.jurisdiction),
      #("format", sp.format),
      #("description", sp.description),
      #("context-type", sp.context_type),
      #("title", sp.title),
      #("fhirversion", sp.fhirversion),
      #("version", sp.version),
      #("url", sp.url),
      #("supported-profile", sp.supported_profile),
      #("mode", sp.mode),
      #("context-quantity", sp.context_quantity),
      #("security-service", sp.security_service),
      #("name", sp.name),
      #("context", sp.context),
      #("publisher", sp.publisher),
      #("context-type-quantity", sp.context_type_quantity),
      #("guide", sp.guide),
      #("status", sp.status),
    ])
  any_search_req(params, "CapabilityStatement", client)
}

pub fn us_core_careplan_search_req(sp: SpUsCoreCareplan, client: FhirClient) {
  let params =
    using_params([
      #("category", sp.category),
      #("date", sp.date),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "CarePlan", client)
}

pub fn us_core_careteam_search_req(sp: SpUsCoreCareteam, client: FhirClient) {
  let params =
    using_params([
      #("patient", sp.patient),
      #("role", sp.role),
      #("status", sp.status),
    ])
  any_search_req(params, "CareTeam", client)
}

pub fn catalogentry_search_req(_sp: SpCatalogentry, client: FhirClient) {
  let params = using_params([])
  any_search_req(params, "CatalogEntry", client)
}

pub fn chargeitem_search_req(sp: SpChargeitem, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("performing-organization", sp.performing_organization),
      #("code", sp.code),
      #("quantity", sp.quantity),
      #("subject", sp.subject),
      #("occurrence", sp.occurrence),
      #("entered-date", sp.entered_date),
      #("performer-function", sp.performer_function),
      #("patient", sp.patient),
      #("factor-override", sp.factor_override),
      #("service", sp.service),
      #("price-override", sp.price_override),
      #("context", sp.context),
      #("enterer", sp.enterer),
      #("performer-actor", sp.performer_actor),
      #("account", sp.account),
      #("requesting-organization", sp.requesting_organization),
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

pub fn claim_search_req(sp: SpClaim, client: FhirClient) {
  let params =
    using_params([
      #("care-team", sp.care_team),
      #("identifier", sp.identifier),
      #("use", sp.use_),
      #("created", sp.created),
      #("encounter", sp.encounter),
      #("priority", sp.priority),
      #("payee", sp.payee),
      #("provider", sp.provider),
      #("patient", sp.patient),
      #("insurer", sp.insurer),
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
      #("insurer", sp.insurer),
      #("created", sp.created),
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
      #("previous", sp.previous),
      #("finding-code", sp.finding_code),
      #("assessor", sp.assessor),
      #("subject", sp.subject),
      #("encounter", sp.encounter),
      #("finding-ref", sp.finding_ref),
      #("problem", sp.problem),
      #("patient", sp.patient),
      #("supporting-info", sp.supporting_info),
      #("investigation", sp.investigation),
      #("status", sp.status),
    ])
  any_search_req(params, "ClinicalImpression", client)
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
      #("context-type", sp.context_type),
      #("language", sp.language),
      #("title", sp.title),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("supplements", sp.supplements),
      #("system", sp.system),
      #("name", sp.name),
      #("context", sp.context),
      #("publisher", sp.publisher),
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
      #("received", sp.received),
      #("part-of", sp.part_of),
      #("medium", sp.medium),
      #("encounter", sp.encounter),
      #("sent", sp.sent),
      #("based-on", sp.based_on),
      #("sender", sp.sender),
      #("patient", sp.patient),
      #("recipient", sp.recipient),
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
      #("requester", sp.requester),
      #("authored", sp.authored),
      #("identifier", sp.identifier),
      #("subject", sp.subject),
      #("replaces", sp.replaces),
      #("medium", sp.medium),
      #("encounter", sp.encounter),
      #("occurrence", sp.occurrence),
      #("priority", sp.priority),
      #("group-identifier", sp.group_identifier),
      #("based-on", sp.based_on),
      #("sender", sp.sender),
      #("patient", sp.patient),
      #("recipient", sp.recipient),
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
      #("name", sp.name),
      #("context", sp.context),
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
      #("related-id", sp.related_id),
      #("subject", sp.subject),
      #("author", sp.author),
      #("confidentiality", sp.confidentiality),
      #("section", sp.section),
      #("encounter", sp.encounter),
      #("type", sp.type_),
      #("title", sp.title),
      #("attester", sp.attester),
      #("entry", sp.entry),
      #("related-ref", sp.related_ref),
      #("patient", sp.patient),
      #("context", sp.context),
      #("category", sp.category),
      #("status", sp.status),
    ])
  any_search_req(params, "Composition", client)
}

pub fn conceptmap_search_req(sp: SpConceptmap, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("other", sp.other),
      #("context-type-value", sp.context_type_value),
      #("target-system", sp.target_system),
      #("dependson", sp.dependson),
      #("jurisdiction", sp.jurisdiction),
      #("description", sp.description),
      #("context-type", sp.context_type),
      #("source", sp.source),
      #("title", sp.title),
      #("context-quantity", sp.context_quantity),
      #("source-uri", sp.source_uri),
      #("context", sp.context),
      #("context-type-quantity", sp.context_type_quantity),
      #("source-system", sp.source_system),
      #("target-code", sp.target_code),
      #("target-uri", sp.target_uri),
      #("identifier", sp.identifier),
      #("product", sp.product),
      #("version", sp.version),
      #("url", sp.url),
      #("target", sp.target),
      #("source-code", sp.source_code),
      #("name", sp.name),
      #("publisher", sp.publisher),
      #("status", sp.status),
    ])
  any_search_req(params, "ConceptMap", client)
}

pub fn us_core_condition_encounter_diagnosis_search_req(
  sp: SpUsCoreConditionEncounterDiagnosis,
  client: FhirClient,
) {
  let params =
    using_params([
      #("abatement-date", sp.abatement_date),
      #("asserted-date", sp.asserted_date),
      #("category", sp.category),
      #("clinical-status", sp.clinical_status),
      #("code", sp.code),
      #("encounter", sp.encounter),
      #("onset-date", sp.onset_date),
      #("patient", sp.patient),
      #("recorded-date", sp.recorded_date),
      #("_lastUpdated", sp.lastupdated),
    ])
  any_search_req(params, "Condition", client)
}

pub fn us_core_condition_problems_health_concerns_search_req(
  sp: SpUsCoreConditionProblemsHealthConcerns,
  client: FhirClient,
) {
  let params =
    using_params([
      #("abatement-date", sp.abatement_date),
      #("asserted-date", sp.asserted_date),
      #("category", sp.category),
      #("clinical-status", sp.clinical_status),
      #("code", sp.code),
      #("encounter", sp.encounter),
      #("onset-date", sp.onset_date),
      #("patient", sp.patient),
      #("recorded-date", sp.recorded_date),
      #("_lastUpdated", sp.lastupdated),
    ])
  any_search_req(params, "Condition", client)
}

pub fn consent_search_req(sp: SpConsent, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("period", sp.period),
      #("data", sp.data),
      #("purpose", sp.purpose),
      #("source-reference", sp.source_reference),
      #("actor", sp.actor),
      #("security-label", sp.security_label),
      #("patient", sp.patient),
      #("organization", sp.organization),
      #("scope", sp.scope),
      #("action", sp.action),
      #("consentor", sp.consentor),
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

pub fn us_core_coverage_search_req(sp: SpUsCoreCoverage, client: FhirClient) {
  let params =
    using_params([
      #("patient", sp.patient),
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
      #("patient", sp.patient),
      #("created", sp.created),
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
      #("patient", sp.patient),
      #("insurer", sp.insurer),
      #("created", sp.created),
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
      #("patient", sp.patient),
      #("author", sp.author),
      #("implicated", sp.implicated),
    ])
  any_search_req(params, "DetectedIssue", client)
}

pub fn us_core_device_search_req(sp: SpUsCoreDevice, client: FhirClient) {
  let params =
    using_params([
      #("patient", sp.patient),
      #("status", sp.status),
      #("type", sp.type_),
    ])
  any_search_req(params, "Device", client)
}

pub fn devicedefinition_search_req(sp: SpDevicedefinition, client: FhirClient) {
  let params =
    using_params([
      #("parent", sp.parent),
      #("identifier", sp.identifier),
      #("type", sp.type_),
    ])
  any_search_req(params, "DeviceDefinition", client)
}

pub fn devicemetric_search_req(sp: SpDevicemetric, client: FhirClient) {
  let params =
    using_params([
      #("parent", sp.parent),
      #("identifier", sp.identifier),
      #("source", sp.source),
      #("type", sp.type_),
      #("category", sp.category),
    ])
  any_search_req(params, "DeviceMetric", client)
}

pub fn devicerequest_search_req(sp: SpDevicerequest, client: FhirClient) {
  let params =
    using_params([
      #("requester", sp.requester),
      #("insurance", sp.insurance),
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
      #("prior-request", sp.prior_request),
      #("device", sp.device),
      #("status", sp.status),
    ])
  any_search_req(params, "DeviceRequest", client)
}

pub fn deviceusestatement_search_req(
  sp: SpDeviceusestatement,
  client: FhirClient,
) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("subject", sp.subject),
      #("patient", sp.patient),
      #("device", sp.device),
    ])
  any_search_req(params, "DeviceUseStatement", client)
}

pub fn us_core_diagnosticreport_lab_search_req(
  sp: SpUsCoreDiagnosticreportLab,
  client: FhirClient,
) {
  let params =
    using_params([
      #("category", sp.category),
      #("code", sp.code),
      #("date", sp.date),
      #("_lastUpdated", sp.lastupdated),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "DiagnosticReport", client)
}

pub fn us_core_diagnosticreport_note_search_req(
  sp: SpUsCoreDiagnosticreportNote,
  client: FhirClient,
) {
  let params =
    using_params([
      #("category", sp.category),
      #("code", sp.code),
      #("date", sp.date),
      #("_lastUpdated", sp.lastupdated),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "DiagnosticReport", client)
}

pub fn documentmanifest_search_req(sp: SpDocumentmanifest, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("item", sp.item),
      #("related-id", sp.related_id),
      #("subject", sp.subject),
      #("author", sp.author),
      #("created", sp.created),
      #("description", sp.description),
      #("source", sp.source),
      #("type", sp.type_),
      #("related-ref", sp.related_ref),
      #("patient", sp.patient),
      #("recipient", sp.recipient),
      #("status", sp.status),
    ])
  any_search_req(params, "DocumentManifest", client)
}

pub fn us_core_documentreference_search_req(
  sp: SpUsCoreDocumentreference,
  client: FhirClient,
) {
  let params =
    using_params([
      #("_id", sp.id),
      #("category", sp.category),
      #("date", sp.date),
      #("patient", sp.patient),
      #("period", sp.period),
      #("status", sp.status),
      #("type", sp.type_),
    ])
  any_search_req(params, "DocumentReference", client)
}

pub fn us_core_adi_documentreference_search_req(
  sp: SpUsCoreAdiDocumentreference,
  client: FhirClient,
) {
  let params =
    using_params([
      #("_id", sp.id),
      #("category", sp.category),
      #("date", sp.date),
      #("patient", sp.patient),
      #("period", sp.period),
      #("status", sp.status),
      #("type", sp.type_),
    ])
  any_search_req(params, "DocumentReference", client)
}

pub fn effectevidencesynthesis_search_req(
  sp: SpEffectevidencesynthesis,
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
      #("name", sp.name),
      #("context", sp.context),
      #("publisher", sp.publisher),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "EffectEvidenceSynthesis", client)
}

pub fn us_core_encounter_search_req(sp: SpUsCoreEncounter, client: FhirClient) {
  let params =
    using_params([
      #("_id", sp.id),
      #("class", sp.class),
      #("date", sp.date),
      #("_lastUpdated", sp.lastupdated),
      #("discharge-disposition", sp.discharge_disposition),
      #("identifier", sp.identifier),
      #("location", sp.location),
      #("patient", sp.patient),
      #("status", sp.status),
      #("type", sp.type_),
    ])
  any_search_req(params, "Encounter", client)
}

pub fn endpoint_search_req(sp: SpEndpoint, client: FhirClient) {
  let params =
    using_params([
      #("payload-type", sp.payload_type),
      #("identifier", sp.identifier),
      #("organization", sp.organization),
      #("connection-type", sp.connection_type),
      #("name", sp.name),
      #("status", sp.status),
    ])
  any_search_req(params, "Endpoint", client)
}

pub fn enrollmentrequest_search_req(sp: SpEnrollmentrequest, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("subject", sp.subject),
      #("patient", sp.patient),
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
      #("condition", sp.condition),
      #("patient", sp.patient),
      #("organization", sp.organization),
      #("type", sp.type_),
      #("care-manager", sp.care_manager),
      #("status", sp.status),
      #("incoming-referral", sp.incoming_referral),
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
      #("description", sp.description),
      #("derived-from", sp.derived_from),
      #("context-type", sp.context_type),
      #("predecessor", sp.predecessor),
      #("title", sp.title),
      #("composed-of", sp.composed_of),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("effective", sp.effective),
      #("depends-on", sp.depends_on),
      #("name", sp.name),
      #("context", sp.context),
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
      #("successor", sp.successor),
      #("context-type-value", sp.context_type_value),
      #("jurisdiction", sp.jurisdiction),
      #("description", sp.description),
      #("derived-from", sp.derived_from),
      #("context-type", sp.context_type),
      #("predecessor", sp.predecessor),
      #("title", sp.title),
      #("composed-of", sp.composed_of),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("effective", sp.effective),
      #("depends-on", sp.depends_on),
      #("name", sp.name),
      #("context", sp.context),
      #("publisher", sp.publisher),
      #("topic", sp.topic),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "Evidence", client)
}

pub fn evidencevariable_search_req(sp: SpEvidencevariable, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("successor", sp.successor),
      #("context-type-value", sp.context_type_value),
      #("jurisdiction", sp.jurisdiction),
      #("description", sp.description),
      #("derived-from", sp.derived_from),
      #("context-type", sp.context_type),
      #("predecessor", sp.predecessor),
      #("title", sp.title),
      #("composed-of", sp.composed_of),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("effective", sp.effective),
      #("depends-on", sp.depends_on),
      #("name", sp.name),
      #("context", sp.context),
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
      #("name", sp.name),
      #("context", sp.context),
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
      #("coverage", sp.coverage),
      #("care-team", sp.care_team),
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

pub fn us_core_familymemberhistory_search_req(
  sp: SpUsCoreFamilymemberhistory,
  client: FhirClient,
) {
  let params =
    using_params([
      #("patient", sp.patient),
      #("code", sp.code),
    ])
  any_search_req(params, "FamilyMemberHistory", client)
}

pub fn flag_search_req(sp: SpFlag, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("subject", sp.subject),
      #("patient", sp.patient),
      #("author", sp.author),
      #("encounter", sp.encounter),
    ])
  any_search_req(params, "Flag", client)
}

pub fn us_core_goal_search_req(sp: SpUsCoreGoal, client: FhirClient) {
  let params =
    using_params([
      #("description", sp.description),
      #("lifecycle-status", sp.lifecycle_status),
      #("patient", sp.patient),
      #("target-date", sp.target_date),
    ])
  any_search_req(params, "Goal", client)
}

pub fn graphdefinition_search_req(sp: SpGraphdefinition, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("context-type-value", sp.context_type_value),
      #("jurisdiction", sp.jurisdiction),
      #("start", sp.start),
      #("description", sp.description),
      #("context-type", sp.context_type),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("name", sp.name),
      #("context", sp.context),
      #("publisher", sp.publisher),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "GraphDefinition", client)
}

pub fn group_search_req(sp: SpGroup, client: FhirClient) {
  let params =
    using_params([
      #("actual", sp.actual),
      #("identifier", sp.identifier),
      #("characteristic-value", sp.characteristic_value),
      #("managing-entity", sp.managing_entity),
      #("code", sp.code),
      #("member", sp.member),
      #("exclude", sp.exclude),
      #("type", sp.type_),
      #("value", sp.value),
      #("characteristic", sp.characteristic),
    ])
  any_search_req(params, "Group", client)
}

pub fn guidanceresponse_search_req(sp: SpGuidanceresponse, client: FhirClient) {
  let params =
    using_params([
      #("request", sp.request),
      #("identifier", sp.identifier),
      #("patient", sp.patient),
      #("subject", sp.subject),
    ])
  any_search_req(params, "GuidanceResponse", client)
}

pub fn healthcareservice_search_req(sp: SpHealthcareservice, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("specialty", sp.specialty),
      #("endpoint", sp.endpoint),
      #("service-category", sp.service_category),
      #("coverage-area", sp.coverage_area),
      #("service-type", sp.service_type),
      #("organization", sp.organization),
      #("name", sp.name),
      #("active", sp.active),
      #("location", sp.location),
      #("program", sp.program),
      #("characteristic", sp.characteristic),
    ])
  any_search_req(params, "HealthcareService", client)
}

pub fn imagingstudy_search_req(sp: SpImagingstudy, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("reason", sp.reason),
      #("dicom-class", sp.dicom_class),
      #("modality", sp.modality),
      #("bodysite", sp.bodysite),
      #("instance", sp.instance),
      #("performer", sp.performer),
      #("subject", sp.subject),
      #("started", sp.started),
      #("interpreter", sp.interpreter),
      #("encounter", sp.encounter),
      #("referrer", sp.referrer),
      #("endpoint", sp.endpoint),
      #("patient", sp.patient),
      #("series", sp.series),
      #("basedon", sp.basedon),
      #("status", sp.status),
    ])
  any_search_req(params, "ImagingStudy", client)
}

pub fn us_core_immunization_search_req(
  sp: SpUsCoreImmunization,
  client: FhirClient,
) {
  let params =
    using_params([
      #("date", sp.date),
      #("patient", sp.patient),
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
      #("name", sp.name),
      #("context", sp.context),
      #("publisher", sp.publisher),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "ImplementationGuide", client)
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
      #("administered-by", sp.administered_by),
      #("address-country", sp.address_country),
      #("endpoint", sp.endpoint),
      #("phonetic", sp.phonetic),
      #("name", sp.name),
      #("address-use", sp.address_use),
      #("address-city", sp.address_city),
      #("status", sp.status),
    ])
  any_search_req(params, "InsurancePlan", client)
}

pub fn invoice_search_req(sp: SpInvoice, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("totalgross", sp.totalgross),
      #("subject", sp.subject),
      #("participant-role", sp.participant_role),
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
      #("description", sp.description),
      #("derived-from", sp.derived_from),
      #("context-type", sp.context_type),
      #("predecessor", sp.predecessor),
      #("title", sp.title),
      #("composed-of", sp.composed_of),
      #("type", sp.type_),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("effective", sp.effective),
      #("depends-on", sp.depends_on),
      #("name", sp.name),
      #("context", sp.context),
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
      #("item", sp.item),
      #("empty-reason", sp.empty_reason),
      #("code", sp.code),
      #("notes", sp.notes),
      #("subject", sp.subject),
      #("patient", sp.patient),
      #("source", sp.source),
      #("encounter", sp.encounter),
      #("title", sp.title),
      #("status", sp.status),
    ])
  any_search_req(params, "List", client)
}

pub fn us_core_location_search_req(sp: SpUsCoreLocation, client: FhirClient) {
  let params =
    using_params([
      #("address", sp.address),
      #("address-city", sp.address_city),
      #("address-postalcode", sp.address_postalcode),
      #("address-state", sp.address_state),
      #("name", sp.name),
    ])
  any_search_req(params, "Location", client)
}

pub fn measure_search_req(sp: SpMeasure, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("successor", sp.successor),
      #("context-type-value", sp.context_type_value),
      #("jurisdiction", sp.jurisdiction),
      #("description", sp.description),
      #("derived-from", sp.derived_from),
      #("context-type", sp.context_type),
      #("predecessor", sp.predecessor),
      #("title", sp.title),
      #("composed-of", sp.composed_of),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("effective", sp.effective),
      #("depends-on", sp.depends_on),
      #("name", sp.name),
      #("context", sp.context),
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
      #("status", sp.status),
      #("evaluated-resource", sp.evaluated_resource),
    ])
  any_search_req(params, "MeasureReport", client)
}

pub fn media_search_req(sp: SpMedia, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("modality", sp.modality),
      #("subject", sp.subject),
      #("created", sp.created),
      #("encounter", sp.encounter),
      #("type", sp.type_),
      #("operator", sp.operator),
      #("view", sp.view),
      #("site", sp.site),
      #("based-on", sp.based_on),
      #("patient", sp.patient),
      #("device", sp.device),
      #("status", sp.status),
    ])
  any_search_req(params, "Media", client)
}

pub fn us_core_medication_search_req(
  _sp: SpUsCoreMedication,
  client: FhirClient,
) {
  let params = using_params([])
  any_search_req(params, "Medication", client)
}

pub fn medicationadministration_search_req(
  sp: SpMedicationadministration,
  client: FhirClient,
) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("request", sp.request),
      #("code", sp.code),
      #("performer", sp.performer),
      #("subject", sp.subject),
      #("medication", sp.medication),
      #("reason-given", sp.reason_given),
      #("patient", sp.patient),
      #("effective-time", sp.effective_time),
      #("context", sp.context),
      #("reason-not-given", sp.reason_not_given),
      #("device", sp.device),
      #("status", sp.status),
    ])
  any_search_req(params, "MedicationAdministration", client)
}

pub fn us_core_medicationdispense_search_req(
  sp: SpUsCoreMedicationdispense,
  client: FhirClient,
) {
  let params =
    using_params([
      #("patient", sp.patient),
      #("status", sp.status),
      #("type", sp.type_),
    ])
  any_search_req(params, "MedicationDispense", client)
}

pub fn medicationknowledge_search_req(
  sp: SpMedicationknowledge,
  client: FhirClient,
) {
  let params =
    using_params([
      #("code", sp.code),
      #("ingredient", sp.ingredient),
      #("doseform", sp.doseform),
      #("classification-type", sp.classification_type),
      #("monograph-type", sp.monograph_type),
      #("classification", sp.classification),
      #("manufacturer", sp.manufacturer),
      #("ingredient-code", sp.ingredient_code),
      #("source-cost", sp.source_cost),
      #("monograph", sp.monograph),
      #("monitoring-program-name", sp.monitoring_program_name),
      #("monitoring-program-type", sp.monitoring_program_type),
      #("status", sp.status),
    ])
  any_search_req(params, "MedicationKnowledge", client)
}

pub fn us_core_medicationrequest_search_req(
  sp: SpUsCoreMedicationrequest,
  client: FhirClient,
) {
  let params =
    using_params([
      #("authoredon", sp.authoredon),
      #("encounter", sp.encounter),
      #("intent", sp.intent),
      #("patient", sp.patient),
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
      #("identifier", sp.identifier),
      #("effective", sp.effective),
      #("code", sp.code),
      #("subject", sp.subject),
      #("patient", sp.patient),
      #("context", sp.context),
      #("medication", sp.medication),
      #("part-of", sp.part_of),
      #("source", sp.source),
      #("category", sp.category),
      #("status", sp.status),
    ])
  any_search_req(params, "MedicationStatement", client)
}

pub fn medicinalproduct_search_req(sp: SpMedicinalproduct, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("name", sp.name),
      #("name-language", sp.name_language),
    ])
  any_search_req(params, "MedicinalProduct", client)
}

pub fn medicinalproductauthorization_search_req(
  sp: SpMedicinalproductauthorization,
  client: FhirClient,
) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("country", sp.country),
      #("subject", sp.subject),
      #("holder", sp.holder),
      #("status", sp.status),
    ])
  any_search_req(params, "MedicinalProductAuthorization", client)
}

pub fn medicinalproductcontraindication_search_req(
  sp: SpMedicinalproductcontraindication,
  client: FhirClient,
) {
  let params =
    using_params([
      #("subject", sp.subject),
    ])
  any_search_req(params, "MedicinalProductContraindication", client)
}

pub fn medicinalproductindication_search_req(
  sp: SpMedicinalproductindication,
  client: FhirClient,
) {
  let params =
    using_params([
      #("subject", sp.subject),
    ])
  any_search_req(params, "MedicinalProductIndication", client)
}

pub fn medicinalproductingredient_search_req(
  _sp: SpMedicinalproductingredient,
  client: FhirClient,
) {
  let params = using_params([])
  any_search_req(params, "MedicinalProductIngredient", client)
}

pub fn medicinalproductinteraction_search_req(
  sp: SpMedicinalproductinteraction,
  client: FhirClient,
) {
  let params =
    using_params([
      #("subject", sp.subject),
    ])
  any_search_req(params, "MedicinalProductInteraction", client)
}

pub fn medicinalproductmanufactured_search_req(
  _sp: SpMedicinalproductmanufactured,
  client: FhirClient,
) {
  let params = using_params([])
  any_search_req(params, "MedicinalProductManufactured", client)
}

pub fn medicinalproductpackaged_search_req(
  sp: SpMedicinalproductpackaged,
  client: FhirClient,
) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("subject", sp.subject),
    ])
  any_search_req(params, "MedicinalProductPackaged", client)
}

pub fn medicinalproductpharmaceutical_search_req(
  sp: SpMedicinalproductpharmaceutical,
  client: FhirClient,
) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("route", sp.route),
      #("target-species", sp.target_species),
    ])
  any_search_req(params, "MedicinalProductPharmaceutical", client)
}

pub fn medicinalproductundesirableeffect_search_req(
  sp: SpMedicinalproductundesirableeffect,
  client: FhirClient,
) {
  let params =
    using_params([
      #("subject", sp.subject),
    ])
  any_search_req(params, "MedicinalProductUndesirableEffect", client)
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
      #("name", sp.name),
      #("context", sp.context),
      #("publisher", sp.publisher),
      #("event", sp.event),
      #("category", sp.category),
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
      #("author", sp.author),
      #("destination", sp.destination),
      #("focus", sp.focus),
      #("source", sp.source),
      #("target", sp.target),
      #("destination-uri", sp.destination_uri),
      #("source-uri", sp.source_uri),
      #("sender", sp.sender),
      #("responsible", sp.responsible),
      #("enterer", sp.enterer),
      #("response-id", sp.response_id),
      #("event", sp.event),
    ])
  any_search_req(params, "MessageHeader", client)
}

pub fn molecularsequence_search_req(sp: SpMolecularsequence, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #(
        "referenceseqid-variant-coordinate",
        sp.referenceseqid_variant_coordinate,
      ),
      #("chromosome", sp.chromosome),
      #("window-end", sp.window_end),
      #("type", sp.type_),
      #("window-start", sp.window_start),
      #("variant-end", sp.variant_end),
      #("chromosome-variant-coordinate", sp.chromosome_variant_coordinate),
      #("patient", sp.patient),
      #("variant-start", sp.variant_start),
      #("chromosome-window-coordinate", sp.chromosome_window_coordinate),
      #("referenceseqid-window-coordinate", sp.referenceseqid_window_coordinate),
      #("referenceseqid", sp.referenceseqid),
    ])
  any_search_req(params, "MolecularSequence", client)
}

pub fn namingsystem_search_req(sp: SpNamingsystem, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("period", sp.period),
      #("context-type-value", sp.context_type_value),
      #("kind", sp.kind),
      #("jurisdiction", sp.jurisdiction),
      #("description", sp.description),
      #("context-type", sp.context_type),
      #("type", sp.type_),
      #("id-type", sp.id_type),
      #("context-quantity", sp.context_quantity),
      #("responsible", sp.responsible),
      #("contact", sp.contact),
      #("name", sp.name),
      #("context", sp.context),
      #("publisher", sp.publisher),
      #("telecom", sp.telecom),
      #("value", sp.value),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "NamingSystem", client)
}

pub fn nutritionorder_search_req(sp: SpNutritionorder, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("datetime", sp.datetime),
      #("provider", sp.provider),
      #("patient", sp.patient),
      #("supplement", sp.supplement),
      #("formula", sp.formula),
      #("instantiates-canonical", sp.instantiates_canonical),
      #("instantiates-uri", sp.instantiates_uri),
      #("encounter", sp.encounter),
      #("oraldiet", sp.oraldiet),
      #("status", sp.status),
      #("additive", sp.additive),
    ])
  any_search_req(params, "NutritionOrder", client)
}

pub fn us_core_body_temperature_search_req(
  sp: SpUsCoreBodyTemperature,
  client: FhirClient,
) {
  let params =
    using_params([
      #("category", sp.category),
      #("code", sp.code),
      #("date", sp.date),
      #("_lastUpdated", sp.lastupdated),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "Observation", client)
}

pub fn us_core_observation_clinical_result_search_req(
  sp: SpUsCoreObservationClinicalResult,
  client: FhirClient,
) {
  let params =
    using_params([
      #("category", sp.category),
      #("code", sp.code),
      #("date", sp.date),
      #("_lastUpdated", sp.lastupdated),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "Observation", client)
}

pub fn us_core_observation_lab_search_req(
  sp: SpUsCoreObservationLab,
  client: FhirClient,
) {
  let params =
    using_params([
      #("category", sp.category),
      #("code", sp.code),
      #("date", sp.date),
      #("_lastUpdated", sp.lastupdated),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "Observation", client)
}

pub fn us_core_treatment_intervention_preference_search_req(
  sp: SpUsCoreTreatmentInterventionPreference,
  client: FhirClient,
) {
  let params =
    using_params([
      #("category", sp.category),
      #("code", sp.code),
      #("date", sp.date),
      #("_lastUpdated", sp.lastupdated),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "Observation", client)
}

pub fn us_core_observation_pregnancyintent_search_req(
  sp: SpUsCoreObservationPregnancyintent,
  client: FhirClient,
) {
  let params =
    using_params([
      #("category", sp.category),
      #("code", sp.code),
      #("date", sp.date),
      #("_lastUpdated", sp.lastupdated),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "Observation", client)
}

pub fn us_core_simple_observation_search_req(
  sp: SpUsCoreSimpleObservation,
  client: FhirClient,
) {
  let params =
    using_params([
      #("category", sp.category),
      #("code", sp.code),
      #("date", sp.date),
      #("_lastUpdated", sp.lastupdated),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "Observation", client)
}

pub fn us_core_respiratory_rate_search_req(
  sp: SpUsCoreRespiratoryRate,
  client: FhirClient,
) {
  let params =
    using_params([
      #("category", sp.category),
      #("code", sp.code),
      #("date", sp.date),
      #("_lastUpdated", sp.lastupdated),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "Observation", client)
}

pub fn us_core_observation_occupation_search_req(
  sp: SpUsCoreObservationOccupation,
  client: FhirClient,
) {
  let params =
    using_params([
      #("category", sp.category),
      #("code", sp.code),
      #("date", sp.date),
      #("_lastUpdated", sp.lastupdated),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "Observation", client)
}

pub fn us_core_vital_signs_search_req(
  sp: SpUsCoreVitalSigns,
  client: FhirClient,
) {
  let params =
    using_params([
      #("category", sp.category),
      #("code", sp.code),
      #("date", sp.date),
      #("_lastUpdated", sp.lastupdated),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "Observation", client)
}

pub fn us_core_body_weight_search_req(
  sp: SpUsCoreBodyWeight,
  client: FhirClient,
) {
  let params =
    using_params([
      #("category", sp.category),
      #("code", sp.code),
      #("date", sp.date),
      #("_lastUpdated", sp.lastupdated),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "Observation", client)
}

pub fn us_core_observation_pregnancystatus_search_req(
  sp: SpUsCoreObservationPregnancystatus,
  client: FhirClient,
) {
  let params =
    using_params([
      #("category", sp.category),
      #("code", sp.code),
      #("date", sp.date),
      #("_lastUpdated", sp.lastupdated),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "Observation", client)
}

pub fn us_core_blood_pressure_search_req(
  sp: SpUsCoreBloodPressure,
  client: FhirClient,
) {
  let params =
    using_params([
      #("category", sp.category),
      #("code", sp.code),
      #("date", sp.date),
      #("_lastUpdated", sp.lastupdated),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "Observation", client)
}

pub fn pediatric_bmi_for_age_search_req(
  sp: SpPediatricBmiForAge,
  client: FhirClient,
) {
  let params =
    using_params([
      #("category", sp.category),
      #("code", sp.code),
      #("date", sp.date),
      #("_lastUpdated", sp.lastupdated),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "Observation", client)
}

pub fn us_core_care_experience_preference_search_req(
  sp: SpUsCoreCareExperiencePreference,
  client: FhirClient,
) {
  let params =
    using_params([
      #("category", sp.category),
      #("code", sp.code),
      #("date", sp.date),
      #("_lastUpdated", sp.lastupdated),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "Observation", client)
}

pub fn us_core_observation_screening_assessment_search_req(
  sp: SpUsCoreObservationScreeningAssessment,
  client: FhirClient,
) {
  let params =
    using_params([
      #("category", sp.category),
      #("code", sp.code),
      #("date", sp.date),
      #("_lastUpdated", sp.lastupdated),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "Observation", client)
}

pub fn us_core_head_circumference_search_req(
  sp: SpUsCoreHeadCircumference,
  client: FhirClient,
) {
  let params =
    using_params([
      #("category", sp.category),
      #("code", sp.code),
      #("date", sp.date),
      #("_lastUpdated", sp.lastupdated),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "Observation", client)
}

pub fn us_core_heart_rate_search_req(sp: SpUsCoreHeartRate, client: FhirClient) {
  let params =
    using_params([
      #("category", sp.category),
      #("code", sp.code),
      #("date", sp.date),
      #("_lastUpdated", sp.lastupdated),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "Observation", client)
}

pub fn us_core_observation_sexual_orientation_search_req(
  sp: SpUsCoreObservationSexualOrientation,
  client: FhirClient,
) {
  let params =
    using_params([
      #("category", sp.category),
      #("code", sp.code),
      #("date", sp.date),
      #("_lastUpdated", sp.lastupdated),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "Observation", client)
}

pub fn pediatric_weight_for_height_search_req(
  sp: SpPediatricWeightForHeight,
  client: FhirClient,
) {
  let params =
    using_params([
      #("category", sp.category),
      #("code", sp.code),
      #("date", sp.date),
      #("_lastUpdated", sp.lastupdated),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "Observation", client)
}

pub fn us_core_bmi_search_req(sp: SpUsCoreBmi, client: FhirClient) {
  let params =
    using_params([
      #("category", sp.category),
      #("code", sp.code),
      #("date", sp.date),
      #("_lastUpdated", sp.lastupdated),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "Observation", client)
}

pub fn us_core_body_height_search_req(
  sp: SpUsCoreBodyHeight,
  client: FhirClient,
) {
  let params =
    using_params([
      #("category", sp.category),
      #("code", sp.code),
      #("date", sp.date),
      #("_lastUpdated", sp.lastupdated),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "Observation", client)
}

pub fn us_core_smokingstatus_search_req(
  sp: SpUsCoreSmokingstatus,
  client: FhirClient,
) {
  let params =
    using_params([
      #("category", sp.category),
      #("code", sp.code),
      #("date", sp.date),
      #("_lastUpdated", sp.lastupdated),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "Observation", client)
}

pub fn us_core_pulse_oximetry_search_req(
  sp: SpUsCorePulseOximetry,
  client: FhirClient,
) {
  let params =
    using_params([
      #("category", sp.category),
      #("code", sp.code),
      #("date", sp.date),
      #("_lastUpdated", sp.lastupdated),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "Observation", client)
}

pub fn head_occipital_frontal_circumference_percentile_search_req(
  sp: SpHeadOccipitalFrontalCircumferencePercentile,
  client: FhirClient,
) {
  let params =
    using_params([
      #("category", sp.category),
      #("code", sp.code),
      #("date", sp.date),
      #("_lastUpdated", sp.lastupdated),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "Observation", client)
}

pub fn us_core_average_blood_pressure_search_req(
  sp: SpUsCoreAverageBloodPressure,
  client: FhirClient,
) {
  let params =
    using_params([
      #("category", sp.category),
      #("code", sp.code),
      #("date", sp.date),
      #("_lastUpdated", sp.lastupdated),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "Observation", client)
}

pub fn us_core_observation_adi_documentation_search_req(
  sp: SpUsCoreObservationAdiDocumentation,
  client: FhirClient,
) {
  let params =
    using_params([
      #("category", sp.category),
      #("code", sp.code),
      #("date", sp.date),
      #("_lastUpdated", sp.lastupdated),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "Observation", client)
}

pub fn observationdefinition_search_req(
  _sp: SpObservationdefinition,
  client: FhirClient,
) {
  let params = using_params([])
  any_search_req(params, "ObservationDefinition", client)
}

pub fn operationdefinition_search_req(
  sp: SpOperationdefinition,
  client: FhirClient,
) {
  let params =
    using_params([
      #("date", sp.date),
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
      #("name", sp.name),
      #("context", sp.context),
      #("publisher", sp.publisher),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
      #("base", sp.base),
    ])
  any_search_req(params, "OperationDefinition", client)
}

pub fn operationoutcome_search_req(_sp: SpOperationoutcome, client: FhirClient) {
  let params = using_params([])
  any_search_req(params, "OperationOutcome", client)
}

pub fn us_core_organization_search_req(
  sp: SpUsCoreOrganization,
  client: FhirClient,
) {
  let params =
    using_params([
      #("address", sp.address),
      #("name", sp.name),
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
      #("telecom", sp.telecom),
      #("location", sp.location),
      #("email", sp.email),
    ])
  any_search_req(params, "OrganizationAffiliation", client)
}

pub fn us_core_patient_search_req(sp: SpUsCorePatient, client: FhirClient) {
  let params =
    using_params([
      #("_id", sp.id),
      #("birthdate", sp.birthdate),
      #("death-date", sp.death_date),
      #("family", sp.family),
      #("given", sp.given),
      #("identifier", sp.identifier),
      #("name", sp.name),
    ])
  any_search_req(params, "Patient", client)
}

pub fn paymentnotice_search_req(sp: SpPaymentnotice, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("request", sp.request),
      #("provider", sp.provider),
      #("created", sp.created),
      #("response", sp.response),
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
      #("payment-issuer", sp.payment_issuer),
      #("outcome", sp.outcome),
      #("requestor", sp.requestor),
      #("status", sp.status),
    ])
  any_search_req(params, "PaymentReconciliation", client)
}

pub fn person_search_req(sp: SpPerson, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("address", sp.address),
      #("birthdate", sp.birthdate),
      #("address-state", sp.address_state),
      #("gender", sp.gender),
      #("practitioner", sp.practitioner),
      #("link", sp.link),
      #("relatedperson", sp.relatedperson),
      #("address-postalcode", sp.address_postalcode),
      #("address-country", sp.address_country),
      #("phonetic", sp.phonetic),
      #("phone", sp.phone),
      #("patient", sp.patient),
      #("organization", sp.organization),
      #("name", sp.name),
      #("address-use", sp.address_use),
      #("telecom", sp.telecom),
      #("address-city", sp.address_city),
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
      #("description", sp.description),
      #("derived-from", sp.derived_from),
      #("context-type", sp.context_type),
      #("predecessor", sp.predecessor),
      #("title", sp.title),
      #("composed-of", sp.composed_of),
      #("type", sp.type_),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("effective", sp.effective),
      #("depends-on", sp.depends_on),
      #("name", sp.name),
      #("context", sp.context),
      #("publisher", sp.publisher),
      #("topic", sp.topic),
      #("definition", sp.definition),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "PlanDefinition", client)
}

pub fn us_core_practitioner_search_req(
  sp: SpUsCorePractitioner,
  client: FhirClient,
) {
  let params =
    using_params([
      #("_id", sp.id),
      #("identifier", sp.identifier),
      #("name", sp.name),
    ])
  any_search_req(params, "Practitioner", client)
}

pub fn us_core_practitionerrole_search_req(
  sp: SpUsCorePractitionerrole,
  client: FhirClient,
) {
  let params =
    using_params([
      #("practitioner", sp.practitioner),
      #("specialty", sp.specialty),
    ])
  any_search_req(params, "PractitionerRole", client)
}

pub fn us_core_procedure_search_req(sp: SpUsCoreProcedure, client: FhirClient) {
  let params =
    using_params([
      #("code", sp.code),
      #("date", sp.date),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "Procedure", client)
}

pub fn us_core_provenance_search_req(
  _sp: SpUsCoreProvenance,
  client: FhirClient,
) {
  let params = using_params([])
  any_search_req(params, "Provenance", client)
}

pub fn questionnaire_search_req(sp: SpQuestionnaire, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("code", sp.code),
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
      #("name", sp.name),
      #("context", sp.context),
      #("publisher", sp.publisher),
      #("definition", sp.definition),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "Questionnaire", client)
}

pub fn us_core_questionnaireresponse_search_req(
  sp: SpUsCoreQuestionnaireresponse,
  client: FhirClient,
) {
  let params =
    using_params([
      #("_id", sp.id),
      #("authored", sp.authored),
      #("patient", sp.patient),
      #("questionnaire", sp.questionnaire),
      #("status", sp.status),
    ])
  any_search_req(params, "QuestionnaireResponse", client)
}

pub fn us_core_relatedperson_search_req(
  sp: SpUsCoreRelatedperson,
  client: FhirClient,
) {
  let params =
    using_params([
      #("_id", sp.id),
      #("name", sp.name),
      #("patient", sp.patient),
    ])
  any_search_req(params, "RelatedPerson", client)
}

pub fn requestgroup_search_req(sp: SpRequestgroup, client: FhirClient) {
  let params =
    using_params([
      #("authored", sp.authored),
      #("identifier", sp.identifier),
      #("code", sp.code),
      #("subject", sp.subject),
      #("author", sp.author),
      #("instantiates-canonical", sp.instantiates_canonical),
      #("encounter", sp.encounter),
      #("priority", sp.priority),
      #("intent", sp.intent),
      #("participant", sp.participant),
      #("group-identifier", sp.group_identifier),
      #("patient", sp.patient),
      #("instantiates-uri", sp.instantiates_uri),
      #("status", sp.status),
    ])
  any_search_req(params, "RequestGroup", client)
}

pub fn researchdefinition_search_req(
  sp: SpResearchdefinition,
  client: FhirClient,
) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("successor", sp.successor),
      #("context-type-value", sp.context_type_value),
      #("jurisdiction", sp.jurisdiction),
      #("description", sp.description),
      #("derived-from", sp.derived_from),
      #("context-type", sp.context_type),
      #("predecessor", sp.predecessor),
      #("title", sp.title),
      #("composed-of", sp.composed_of),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("effective", sp.effective),
      #("depends-on", sp.depends_on),
      #("name", sp.name),
      #("context", sp.context),
      #("publisher", sp.publisher),
      #("topic", sp.topic),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "ResearchDefinition", client)
}

pub fn researchelementdefinition_search_req(
  sp: SpResearchelementdefinition,
  client: FhirClient,
) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("successor", sp.successor),
      #("context-type-value", sp.context_type_value),
      #("jurisdiction", sp.jurisdiction),
      #("description", sp.description),
      #("derived-from", sp.derived_from),
      #("context-type", sp.context_type),
      #("predecessor", sp.predecessor),
      #("title", sp.title),
      #("composed-of", sp.composed_of),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("effective", sp.effective),
      #("depends-on", sp.depends_on),
      #("name", sp.name),
      #("context", sp.context),
      #("publisher", sp.publisher),
      #("topic", sp.topic),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "ResearchElementDefinition", client)
}

pub fn researchstudy_search_req(sp: SpResearchstudy, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("partof", sp.partof),
      #("sponsor", sp.sponsor),
      #("focus", sp.focus),
      #("principalinvestigator", sp.principalinvestigator),
      #("title", sp.title),
      #("protocol", sp.protocol),
      #("site", sp.site),
      #("location", sp.location),
      #("category", sp.category),
      #("keyword", sp.keyword),
      #("status", sp.status),
    ])
  any_search_req(params, "ResearchStudy", client)
}

pub fn researchsubject_search_req(sp: SpResearchsubject, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("study", sp.study),
      #("individual", sp.individual),
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
      #("subject", sp.subject),
      #("patient", sp.patient),
      #("probability", sp.probability),
      #("risk", sp.risk),
      #("encounter", sp.encounter),
    ])
  any_search_req(params, "RiskAssessment", client)
}

pub fn riskevidencesynthesis_search_req(
  sp: SpRiskevidencesynthesis,
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
      #("name", sp.name),
      #("context", sp.context),
      #("publisher", sp.publisher),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "RiskEvidenceSynthesis", client)
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
      #("active", sp.active),
    ])
  any_search_req(params, "Schedule", client)
}

pub fn searchparameter_search_req(sp: SpSearchparameter, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("code", sp.code),
      #("context-type-value", sp.context_type_value),
      #("jurisdiction", sp.jurisdiction),
      #("description", sp.description),
      #("derived-from", sp.derived_from),
      #("context-type", sp.context_type),
      #("type", sp.type_),
      #("version", sp.version),
      #("url", sp.url),
      #("target", sp.target),
      #("context-quantity", sp.context_quantity),
      #("component", sp.component),
      #("name", sp.name),
      #("context", sp.context),
      #("publisher", sp.publisher),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
      #("base", sp.base),
    ])
  any_search_req(params, "SearchParameter", client)
}

pub fn us_core_servicerequest_search_req(
  sp: SpUsCoreServicerequest,
  client: FhirClient,
) {
  let params =
    using_params([
      #("_id", sp.id),
      #("authored", sp.authored),
      #("category", sp.category),
      #("code", sp.code),
      #("patient", sp.patient),
      #("status", sp.status),
    ])
  any_search_req(params, "ServiceRequest", client)
}

pub fn slot_search_req(sp: SpSlot, client: FhirClient) {
  let params =
    using_params([
      #("schedule", sp.schedule),
      #("identifier", sp.identifier),
      #("specialty", sp.specialty),
      #("service-category", sp.service_category),
      #("appointment-type", sp.appointment_type),
      #("service-type", sp.service_type),
      #("start", sp.start),
      #("status", sp.status),
    ])
  any_search_req(params, "Slot", client)
}

pub fn us_core_specimen_search_req(sp: SpUsCoreSpecimen, client: FhirClient) {
  let params =
    using_params([
      #("_id", sp.id),
      #("patient", sp.patient),
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
      #("type", sp.type_),
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
      #("jurisdiction", sp.jurisdiction),
      #("description", sp.description),
      #("context-type", sp.context_type),
      #("experimental", sp.experimental),
      #("title", sp.title),
      #("type", sp.type_),
      #("context-quantity", sp.context_quantity),
      #("path", sp.path),
      #("context", sp.context),
      #("base-path", sp.base_path),
      #("keyword", sp.keyword),
      #("context-type-quantity", sp.context_type_quantity),
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
      #("status", sp.status),
      #("base", sp.base),
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
      #("name", sp.name),
      #("context", sp.context),
      #("publisher", sp.publisher),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "StructureMap", client)
}

pub fn subscription_search_req(sp: SpSubscription, client: FhirClient) {
  let params =
    using_params([
      #("payload", sp.payload),
      #("criteria", sp.criteria),
      #("contact", sp.contact),
      #("type", sp.type_),
      #("url", sp.url),
      #("status", sp.status),
    ])
  any_search_req(params, "Subscription", client)
}

pub fn substance_search_req(sp: SpSubstance, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("container-identifier", sp.container_identifier),
      #("code", sp.code),
      #("quantity", sp.quantity),
      #("substance-reference", sp.substance_reference),
      #("expiry", sp.expiry),
      #("category", sp.category),
      #("status", sp.status),
    ])
  any_search_req(params, "Substance", client)
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

pub fn substancespecification_search_req(
  sp: SpSubstancespecification,
  client: FhirClient,
) {
  let params =
    using_params([
      #("code", sp.code),
    ])
  any_search_req(params, "SubstanceSpecification", client)
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
      #("requester", sp.requester),
      #("date", sp.date),
      #("identifier", sp.identifier),
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
      #("requester", sp.requester),
      #("identifier", sp.identifier),
      #("business-status", sp.business_status),
      #("period", sp.period),
      #("code", sp.code),
      #("performer", sp.performer),
      #("subject", sp.subject),
      #("focus", sp.focus),
      #("part-of", sp.part_of),
      #("encounter", sp.encounter),
      #("priority", sp.priority),
      #("authored-on", sp.authored_on),
      #("intent", sp.intent),
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
      #("context-type-value", sp.context_type_value),
      #("jurisdiction", sp.jurisdiction),
      #("description", sp.description),
      #("context-type", sp.context_type),
      #("title", sp.title),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("name", sp.name),
      #("context", sp.context),
      #("publisher", sp.publisher),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "TerminologyCapabilities", client)
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
      #("title", sp.title),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("name", sp.name),
      #("context", sp.context),
      #("publisher", sp.publisher),
      #("context-type-quantity", sp.context_type_quantity),
      #("status", sp.status),
    ])
  any_search_req(params, "TestScript", client)
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
      #("context-type", sp.context_type),
      #("title", sp.title),
      #("version", sp.version),
      #("url", sp.url),
      #("expansion", sp.expansion),
      #("reference", sp.reference),
      #("context-quantity", sp.context_quantity),
      #("name", sp.name),
      #("context", sp.context),
      #("publisher", sp.publisher),
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
      #("target", sp.target),
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

pub fn bundle_to_groupedresources(from bundle: r4us.Bundle) {
  list.fold(
    from: groupedresources_new(),
    over: bundle.entry,
    with: fn(acc, entry) {
      case entry.resource {
        None -> acc
        Some(res) ->
          case res {
            r4us.ResourceAccount(r) ->
              GroupedResources(..acc, account: [r, ..acc.account])
            r4us.ResourceActivitydefinition(r) ->
              GroupedResources(..acc, activitydefinition: [
                r,
                ..acc.activitydefinition
              ])
            r4us.ResourceAdverseevent(r) ->
              GroupedResources(..acc, adverseevent: [r, ..acc.adverseevent])
            r4us.ResourceUsCoreAllergyintolerance(r) ->
              GroupedResources(..acc, us_core_allergyintolerance: [
                r,
                ..acc.us_core_allergyintolerance
              ])
            r4us.ResourceAppointment(r) ->
              GroupedResources(..acc, appointment: [r, ..acc.appointment])
            r4us.ResourceAppointmentresponse(r) ->
              GroupedResources(..acc, appointmentresponse: [
                r,
                ..acc.appointmentresponse
              ])
            r4us.ResourceAuditevent(r) ->
              GroupedResources(..acc, auditevent: [r, ..acc.auditevent])
            r4us.ResourceBasic(r) ->
              GroupedResources(..acc, basic: [r, ..acc.basic])
            r4us.ResourceBinary(r) ->
              GroupedResources(..acc, binary: [r, ..acc.binary])
            r4us.ResourceBiologicallyderivedproduct(r) ->
              GroupedResources(..acc, biologicallyderivedproduct: [
                r,
                ..acc.biologicallyderivedproduct
              ])
            r4us.ResourceBodystructure(r) ->
              GroupedResources(..acc, bodystructure: [r, ..acc.bodystructure])
            r4us.ResourceBundle(r) ->
              GroupedResources(..acc, bundle: [r, ..acc.bundle])
            r4us.ResourceCapabilitystatement(r) ->
              GroupedResources(..acc, capabilitystatement: [
                r,
                ..acc.capabilitystatement
              ])
            r4us.ResourceUsCoreCareplan(r) ->
              GroupedResources(..acc, us_core_careplan: [
                r,
                ..acc.us_core_careplan
              ])
            r4us.ResourceUsCoreCareteam(r) ->
              GroupedResources(..acc, us_core_careteam: [
                r,
                ..acc.us_core_careteam
              ])
            r4us.ResourceCatalogentry(r) ->
              GroupedResources(..acc, catalogentry: [r, ..acc.catalogentry])
            r4us.ResourceChargeitem(r) ->
              GroupedResources(..acc, chargeitem: [r, ..acc.chargeitem])
            r4us.ResourceChargeitemdefinition(r) ->
              GroupedResources(..acc, chargeitemdefinition: [
                r,
                ..acc.chargeitemdefinition
              ])
            r4us.ResourceClaim(r) ->
              GroupedResources(..acc, claim: [r, ..acc.claim])
            r4us.ResourceClaimresponse(r) ->
              GroupedResources(..acc, claimresponse: [r, ..acc.claimresponse])
            r4us.ResourceClinicalimpression(r) ->
              GroupedResources(..acc, clinicalimpression: [
                r,
                ..acc.clinicalimpression
              ])
            r4us.ResourceCodesystem(r) ->
              GroupedResources(..acc, codesystem: [r, ..acc.codesystem])
            r4us.ResourceCommunication(r) ->
              GroupedResources(..acc, communication: [r, ..acc.communication])
            r4us.ResourceCommunicationrequest(r) ->
              GroupedResources(..acc, communicationrequest: [
                r,
                ..acc.communicationrequest
              ])
            r4us.ResourceCompartmentdefinition(r) ->
              GroupedResources(..acc, compartmentdefinition: [
                r,
                ..acc.compartmentdefinition
              ])
            r4us.ResourceComposition(r) ->
              GroupedResources(..acc, composition: [r, ..acc.composition])
            r4us.ResourceConceptmap(r) ->
              GroupedResources(..acc, conceptmap: [r, ..acc.conceptmap])
            r4us.ResourceUsCoreConditionEncounterDiagnosis(r) ->
              GroupedResources(..acc, us_core_condition_encounter_diagnosis: [
                r,
                ..acc.us_core_condition_encounter_diagnosis
              ])
            r4us.ResourceUsCoreConditionProblemsHealthConcerns(r) ->
              GroupedResources(
                ..acc,
                us_core_condition_problems_health_concerns: [
                  r,
                  ..acc.us_core_condition_problems_health_concerns
                ],
              )
            r4us.ResourceConsent(r) ->
              GroupedResources(..acc, consent: [r, ..acc.consent])
            r4us.ResourceContract(r) ->
              GroupedResources(..acc, contract: [r, ..acc.contract])
            r4us.ResourceUsCoreCoverage(r) ->
              GroupedResources(..acc, us_core_coverage: [
                r,
                ..acc.us_core_coverage
              ])
            r4us.ResourceCoverageeligibilityrequest(r) ->
              GroupedResources(..acc, coverageeligibilityrequest: [
                r,
                ..acc.coverageeligibilityrequest
              ])
            r4us.ResourceCoverageeligibilityresponse(r) ->
              GroupedResources(..acc, coverageeligibilityresponse: [
                r,
                ..acc.coverageeligibilityresponse
              ])
            r4us.ResourceDetectedissue(r) ->
              GroupedResources(..acc, detectedissue: [r, ..acc.detectedissue])
            r4us.ResourceUsCoreDevice(r) ->
              GroupedResources(..acc, us_core_device: [r, ..acc.us_core_device])
            r4us.ResourceDevicedefinition(r) ->
              GroupedResources(..acc, devicedefinition: [
                r,
                ..acc.devicedefinition
              ])
            r4us.ResourceDevicemetric(r) ->
              GroupedResources(..acc, devicemetric: [r, ..acc.devicemetric])
            r4us.ResourceDevicerequest(r) ->
              GroupedResources(..acc, devicerequest: [r, ..acc.devicerequest])
            r4us.ResourceDeviceusestatement(r) ->
              GroupedResources(..acc, deviceusestatement: [
                r,
                ..acc.deviceusestatement
              ])
            r4us.ResourceUsCoreDiagnosticreportLab(r) ->
              GroupedResources(..acc, us_core_diagnosticreport_lab: [
                r,
                ..acc.us_core_diagnosticreport_lab
              ])
            r4us.ResourceUsCoreDiagnosticreportNote(r) ->
              GroupedResources(..acc, us_core_diagnosticreport_note: [
                r,
                ..acc.us_core_diagnosticreport_note
              ])
            r4us.ResourceDocumentmanifest(r) ->
              GroupedResources(..acc, documentmanifest: [
                r,
                ..acc.documentmanifest
              ])
            r4us.ResourceUsCoreDocumentreference(r) ->
              GroupedResources(..acc, us_core_documentreference: [
                r,
                ..acc.us_core_documentreference
              ])
            r4us.ResourceUsCoreAdiDocumentreference(r) ->
              GroupedResources(..acc, us_core_adi_documentreference: [
                r,
                ..acc.us_core_adi_documentreference
              ])
            r4us.ResourceEffectevidencesynthesis(r) ->
              GroupedResources(..acc, effectevidencesynthesis: [
                r,
                ..acc.effectevidencesynthesis
              ])
            r4us.ResourceUsCoreEncounter(r) ->
              GroupedResources(..acc, us_core_encounter: [
                r,
                ..acc.us_core_encounter
              ])
            r4us.ResourceEndpoint(r) ->
              GroupedResources(..acc, endpoint: [r, ..acc.endpoint])
            r4us.ResourceEnrollmentrequest(r) ->
              GroupedResources(..acc, enrollmentrequest: [
                r,
                ..acc.enrollmentrequest
              ])
            r4us.ResourceEnrollmentresponse(r) ->
              GroupedResources(..acc, enrollmentresponse: [
                r,
                ..acc.enrollmentresponse
              ])
            r4us.ResourceEpisodeofcare(r) ->
              GroupedResources(..acc, episodeofcare: [r, ..acc.episodeofcare])
            r4us.ResourceEventdefinition(r) ->
              GroupedResources(..acc, eventdefinition: [
                r,
                ..acc.eventdefinition
              ])
            r4us.ResourceEvidence(r) ->
              GroupedResources(..acc, evidence: [r, ..acc.evidence])
            r4us.ResourceEvidencevariable(r) ->
              GroupedResources(..acc, evidencevariable: [
                r,
                ..acc.evidencevariable
              ])
            r4us.ResourceExamplescenario(r) ->
              GroupedResources(..acc, examplescenario: [
                r,
                ..acc.examplescenario
              ])
            r4us.ResourceExplanationofbenefit(r) ->
              GroupedResources(..acc, explanationofbenefit: [
                r,
                ..acc.explanationofbenefit
              ])
            r4us.ResourceUsCoreFamilymemberhistory(r) ->
              GroupedResources(..acc, us_core_familymemberhistory: [
                r,
                ..acc.us_core_familymemberhistory
              ])
            r4us.ResourceFlag(r) ->
              GroupedResources(..acc, flag: [r, ..acc.flag])
            r4us.ResourceUsCoreGoal(r) ->
              GroupedResources(..acc, us_core_goal: [r, ..acc.us_core_goal])
            r4us.ResourceGraphdefinition(r) ->
              GroupedResources(..acc, graphdefinition: [
                r,
                ..acc.graphdefinition
              ])
            r4us.ResourceGroup(r) ->
              GroupedResources(..acc, group: [r, ..acc.group])
            r4us.ResourceGuidanceresponse(r) ->
              GroupedResources(..acc, guidanceresponse: [
                r,
                ..acc.guidanceresponse
              ])
            r4us.ResourceHealthcareservice(r) ->
              GroupedResources(..acc, healthcareservice: [
                r,
                ..acc.healthcareservice
              ])
            r4us.ResourceImagingstudy(r) ->
              GroupedResources(..acc, imagingstudy: [r, ..acc.imagingstudy])
            r4us.ResourceUsCoreImmunization(r) ->
              GroupedResources(..acc, us_core_immunization: [
                r,
                ..acc.us_core_immunization
              ])
            r4us.ResourceImmunizationevaluation(r) ->
              GroupedResources(..acc, immunizationevaluation: [
                r,
                ..acc.immunizationevaluation
              ])
            r4us.ResourceImmunizationrecommendation(r) ->
              GroupedResources(..acc, immunizationrecommendation: [
                r,
                ..acc.immunizationrecommendation
              ])
            r4us.ResourceImplementationguide(r) ->
              GroupedResources(..acc, implementationguide: [
                r,
                ..acc.implementationguide
              ])
            r4us.ResourceInsuranceplan(r) ->
              GroupedResources(..acc, insuranceplan: [r, ..acc.insuranceplan])
            r4us.ResourceInvoice(r) ->
              GroupedResources(..acc, invoice: [r, ..acc.invoice])
            r4us.ResourceLibrary(r) ->
              GroupedResources(..acc, library: [r, ..acc.library])
            r4us.ResourceLinkage(r) ->
              GroupedResources(..acc, linkage: [r, ..acc.linkage])
            r4us.ResourceListfhir(r) ->
              GroupedResources(..acc, listfhir: [r, ..acc.listfhir])
            r4us.ResourceUsCoreLocation(r) ->
              GroupedResources(..acc, us_core_location: [
                r,
                ..acc.us_core_location
              ])
            r4us.ResourceMeasure(r) ->
              GroupedResources(..acc, measure: [r, ..acc.measure])
            r4us.ResourceMeasurereport(r) ->
              GroupedResources(..acc, measurereport: [r, ..acc.measurereport])
            r4us.ResourceMedia(r) ->
              GroupedResources(..acc, media: [r, ..acc.media])
            r4us.ResourceUsCoreMedication(r) ->
              GroupedResources(..acc, us_core_medication: [
                r,
                ..acc.us_core_medication
              ])
            r4us.ResourceMedicationadministration(r) ->
              GroupedResources(..acc, medicationadministration: [
                r,
                ..acc.medicationadministration
              ])
            r4us.ResourceUsCoreMedicationdispense(r) ->
              GroupedResources(..acc, us_core_medicationdispense: [
                r,
                ..acc.us_core_medicationdispense
              ])
            r4us.ResourceMedicationknowledge(r) ->
              GroupedResources(..acc, medicationknowledge: [
                r,
                ..acc.medicationknowledge
              ])
            r4us.ResourceUsCoreMedicationrequest(r) ->
              GroupedResources(..acc, us_core_medicationrequest: [
                r,
                ..acc.us_core_medicationrequest
              ])
            r4us.ResourceMedicationstatement(r) ->
              GroupedResources(..acc, medicationstatement: [
                r,
                ..acc.medicationstatement
              ])
            r4us.ResourceMedicinalproduct(r) ->
              GroupedResources(..acc, medicinalproduct: [
                r,
                ..acc.medicinalproduct
              ])
            r4us.ResourceMedicinalproductauthorization(r) ->
              GroupedResources(..acc, medicinalproductauthorization: [
                r,
                ..acc.medicinalproductauthorization
              ])
            r4us.ResourceMedicinalproductcontraindication(r) ->
              GroupedResources(..acc, medicinalproductcontraindication: [
                r,
                ..acc.medicinalproductcontraindication
              ])
            r4us.ResourceMedicinalproductindication(r) ->
              GroupedResources(..acc, medicinalproductindication: [
                r,
                ..acc.medicinalproductindication
              ])
            r4us.ResourceMedicinalproductingredient(r) ->
              GroupedResources(..acc, medicinalproductingredient: [
                r,
                ..acc.medicinalproductingredient
              ])
            r4us.ResourceMedicinalproductinteraction(r) ->
              GroupedResources(..acc, medicinalproductinteraction: [
                r,
                ..acc.medicinalproductinteraction
              ])
            r4us.ResourceMedicinalproductmanufactured(r) ->
              GroupedResources(..acc, medicinalproductmanufactured: [
                r,
                ..acc.medicinalproductmanufactured
              ])
            r4us.ResourceMedicinalproductpackaged(r) ->
              GroupedResources(..acc, medicinalproductpackaged: [
                r,
                ..acc.medicinalproductpackaged
              ])
            r4us.ResourceMedicinalproductpharmaceutical(r) ->
              GroupedResources(..acc, medicinalproductpharmaceutical: [
                r,
                ..acc.medicinalproductpharmaceutical
              ])
            r4us.ResourceMedicinalproductundesirableeffect(r) ->
              GroupedResources(..acc, medicinalproductundesirableeffect: [
                r,
                ..acc.medicinalproductundesirableeffect
              ])
            r4us.ResourceMessagedefinition(r) ->
              GroupedResources(..acc, messagedefinition: [
                r,
                ..acc.messagedefinition
              ])
            r4us.ResourceMessageheader(r) ->
              GroupedResources(..acc, messageheader: [r, ..acc.messageheader])
            r4us.ResourceMolecularsequence(r) ->
              GroupedResources(..acc, molecularsequence: [
                r,
                ..acc.molecularsequence
              ])
            r4us.ResourceNamingsystem(r) ->
              GroupedResources(..acc, namingsystem: [r, ..acc.namingsystem])
            r4us.ResourceNutritionorder(r) ->
              GroupedResources(..acc, nutritionorder: [r, ..acc.nutritionorder])
            r4us.ResourceUsCoreBodyTemperature(r) ->
              GroupedResources(..acc, us_core_body_temperature: [
                r,
                ..acc.us_core_body_temperature
              ])
            r4us.ResourceUsCoreObservationClinicalResult(r) ->
              GroupedResources(..acc, us_core_observation_clinical_result: [
                r,
                ..acc.us_core_observation_clinical_result
              ])
            r4us.ResourceUsCoreObservationLab(r) ->
              GroupedResources(..acc, us_core_observation_lab: [
                r,
                ..acc.us_core_observation_lab
              ])
            r4us.ResourceUsCoreTreatmentInterventionPreference(r) ->
              GroupedResources(
                ..acc,
                us_core_treatment_intervention_preference: [
                  r,
                  ..acc.us_core_treatment_intervention_preference
                ],
              )
            r4us.ResourceUsCoreObservationPregnancyintent(r) ->
              GroupedResources(..acc, us_core_observation_pregnancyintent: [
                r,
                ..acc.us_core_observation_pregnancyintent
              ])
            r4us.ResourceUsCoreSimpleObservation(r) ->
              GroupedResources(..acc, us_core_simple_observation: [
                r,
                ..acc.us_core_simple_observation
              ])
            r4us.ResourceUsCoreRespiratoryRate(r) ->
              GroupedResources(..acc, us_core_respiratory_rate: [
                r,
                ..acc.us_core_respiratory_rate
              ])
            r4us.ResourceUsCoreObservationOccupation(r) ->
              GroupedResources(..acc, us_core_observation_occupation: [
                r,
                ..acc.us_core_observation_occupation
              ])
            r4us.ResourceUsCoreVitalSigns(r) ->
              GroupedResources(..acc, us_core_vital_signs: [
                r,
                ..acc.us_core_vital_signs
              ])
            r4us.ResourceUsCoreBodyWeight(r) ->
              GroupedResources(..acc, us_core_body_weight: [
                r,
                ..acc.us_core_body_weight
              ])
            r4us.ResourceUsCoreObservationPregnancystatus(r) ->
              GroupedResources(..acc, us_core_observation_pregnancystatus: [
                r,
                ..acc.us_core_observation_pregnancystatus
              ])
            r4us.ResourceUsCoreBloodPressure(r) ->
              GroupedResources(..acc, us_core_blood_pressure: [
                r,
                ..acc.us_core_blood_pressure
              ])
            r4us.ResourcePediatricBmiForAge(r) ->
              GroupedResources(..acc, pediatric_bmi_for_age: [
                r,
                ..acc.pediatric_bmi_for_age
              ])
            r4us.ResourceUsCoreCareExperiencePreference(r) ->
              GroupedResources(..acc, us_core_care_experience_preference: [
                r,
                ..acc.us_core_care_experience_preference
              ])
            r4us.ResourceUsCoreObservationScreeningAssessment(r) ->
              GroupedResources(..acc, us_core_observation_screening_assessment: [
                r,
                ..acc.us_core_observation_screening_assessment
              ])
            r4us.ResourceUsCoreHeadCircumference(r) ->
              GroupedResources(..acc, us_core_head_circumference: [
                r,
                ..acc.us_core_head_circumference
              ])
            r4us.ResourceUsCoreHeartRate(r) ->
              GroupedResources(..acc, us_core_heart_rate: [
                r,
                ..acc.us_core_heart_rate
              ])
            r4us.ResourceUsCoreObservationSexualOrientation(r) ->
              GroupedResources(..acc, us_core_observation_sexual_orientation: [
                r,
                ..acc.us_core_observation_sexual_orientation
              ])
            r4us.ResourcePediatricWeightForHeight(r) ->
              GroupedResources(..acc, pediatric_weight_for_height: [
                r,
                ..acc.pediatric_weight_for_height
              ])
            r4us.ResourceUsCoreBmi(r) ->
              GroupedResources(..acc, us_core_bmi: [r, ..acc.us_core_bmi])
            r4us.ResourceUsCoreBodyHeight(r) ->
              GroupedResources(..acc, us_core_body_height: [
                r,
                ..acc.us_core_body_height
              ])
            r4us.ResourceUsCoreSmokingstatus(r) ->
              GroupedResources(..acc, us_core_smokingstatus: [
                r,
                ..acc.us_core_smokingstatus
              ])
            r4us.ResourceUsCorePulseOximetry(r) ->
              GroupedResources(..acc, us_core_pulse_oximetry: [
                r,
                ..acc.us_core_pulse_oximetry
              ])
            r4us.ResourceHeadOccipitalFrontalCircumferencePercentile(r) ->
              GroupedResources(
                ..acc,
                head_occipital_frontal_circumference_percentile: [
                  r,
                  ..acc.head_occipital_frontal_circumference_percentile
                ],
              )
            r4us.ResourceUsCoreAverageBloodPressure(r) ->
              GroupedResources(..acc, us_core_average_blood_pressure: [
                r,
                ..acc.us_core_average_blood_pressure
              ])
            r4us.ResourceUsCoreObservationAdiDocumentation(r) ->
              GroupedResources(..acc, us_core_observation_adi_documentation: [
                r,
                ..acc.us_core_observation_adi_documentation
              ])
            r4us.ResourceObservationdefinition(r) ->
              GroupedResources(..acc, observationdefinition: [
                r,
                ..acc.observationdefinition
              ])
            r4us.ResourceOperationdefinition(r) ->
              GroupedResources(..acc, operationdefinition: [
                r,
                ..acc.operationdefinition
              ])
            r4us.ResourceOperationoutcome(r) ->
              GroupedResources(..acc, operationoutcome: [
                r,
                ..acc.operationoutcome
              ])
            r4us.ResourceUsCoreOrganization(r) ->
              GroupedResources(..acc, us_core_organization: [
                r,
                ..acc.us_core_organization
              ])
            r4us.ResourceOrganizationaffiliation(r) ->
              GroupedResources(..acc, organizationaffiliation: [
                r,
                ..acc.organizationaffiliation
              ])
            r4us.ResourceUsCorePatient(r) ->
              GroupedResources(..acc, us_core_patient: [
                r,
                ..acc.us_core_patient
              ])
            r4us.ResourcePaymentnotice(r) ->
              GroupedResources(..acc, paymentnotice: [r, ..acc.paymentnotice])
            r4us.ResourcePaymentreconciliation(r) ->
              GroupedResources(..acc, paymentreconciliation: [
                r,
                ..acc.paymentreconciliation
              ])
            r4us.ResourcePerson(r) ->
              GroupedResources(..acc, person: [r, ..acc.person])
            r4us.ResourcePlandefinition(r) ->
              GroupedResources(..acc, plandefinition: [r, ..acc.plandefinition])
            r4us.ResourceUsCorePractitioner(r) ->
              GroupedResources(..acc, us_core_practitioner: [
                r,
                ..acc.us_core_practitioner
              ])
            r4us.ResourceUsCorePractitionerrole(r) ->
              GroupedResources(..acc, us_core_practitionerrole: [
                r,
                ..acc.us_core_practitionerrole
              ])
            r4us.ResourceUsCoreProcedure(r) ->
              GroupedResources(..acc, us_core_procedure: [
                r,
                ..acc.us_core_procedure
              ])
            r4us.ResourceUsCoreProvenance(r) ->
              GroupedResources(..acc, us_core_provenance: [
                r,
                ..acc.us_core_provenance
              ])
            r4us.ResourceQuestionnaire(r) ->
              GroupedResources(..acc, questionnaire: [r, ..acc.questionnaire])
            r4us.ResourceUsCoreQuestionnaireresponse(r) ->
              GroupedResources(..acc, us_core_questionnaireresponse: [
                r,
                ..acc.us_core_questionnaireresponse
              ])
            r4us.ResourceUsCoreRelatedperson(r) ->
              GroupedResources(..acc, us_core_relatedperson: [
                r,
                ..acc.us_core_relatedperson
              ])
            r4us.ResourceRequestgroup(r) ->
              GroupedResources(..acc, requestgroup: [r, ..acc.requestgroup])
            r4us.ResourceResearchdefinition(r) ->
              GroupedResources(..acc, researchdefinition: [
                r,
                ..acc.researchdefinition
              ])
            r4us.ResourceResearchelementdefinition(r) ->
              GroupedResources(..acc, researchelementdefinition: [
                r,
                ..acc.researchelementdefinition
              ])
            r4us.ResourceResearchstudy(r) ->
              GroupedResources(..acc, researchstudy: [r, ..acc.researchstudy])
            r4us.ResourceResearchsubject(r) ->
              GroupedResources(..acc, researchsubject: [
                r,
                ..acc.researchsubject
              ])
            r4us.ResourceRiskassessment(r) ->
              GroupedResources(..acc, riskassessment: [r, ..acc.riskassessment])
            r4us.ResourceRiskevidencesynthesis(r) ->
              GroupedResources(..acc, riskevidencesynthesis: [
                r,
                ..acc.riskevidencesynthesis
              ])
            r4us.ResourceSchedule(r) ->
              GroupedResources(..acc, schedule: [r, ..acc.schedule])
            r4us.ResourceSearchparameter(r) ->
              GroupedResources(..acc, searchparameter: [
                r,
                ..acc.searchparameter
              ])
            r4us.ResourceUsCoreServicerequest(r) ->
              GroupedResources(..acc, us_core_servicerequest: [
                r,
                ..acc.us_core_servicerequest
              ])
            r4us.ResourceSlot(r) ->
              GroupedResources(..acc, slot: [r, ..acc.slot])
            r4us.ResourceUsCoreSpecimen(r) ->
              GroupedResources(..acc, us_core_specimen: [
                r,
                ..acc.us_core_specimen
              ])
            r4us.ResourceSpecimendefinition(r) ->
              GroupedResources(..acc, specimendefinition: [
                r,
                ..acc.specimendefinition
              ])
            r4us.ResourceStructuredefinition(r) ->
              GroupedResources(..acc, structuredefinition: [
                r,
                ..acc.structuredefinition
              ])
            r4us.ResourceStructuremap(r) ->
              GroupedResources(..acc, structuremap: [r, ..acc.structuremap])
            r4us.ResourceSubscription(r) ->
              GroupedResources(..acc, subscription: [r, ..acc.subscription])
            r4us.ResourceSubstance(r) ->
              GroupedResources(..acc, substance: [r, ..acc.substance])
            r4us.ResourceSubstancenucleicacid(r) ->
              GroupedResources(..acc, substancenucleicacid: [
                r,
                ..acc.substancenucleicacid
              ])
            r4us.ResourceSubstancepolymer(r) ->
              GroupedResources(..acc, substancepolymer: [
                r,
                ..acc.substancepolymer
              ])
            r4us.ResourceSubstanceprotein(r) ->
              GroupedResources(..acc, substanceprotein: [
                r,
                ..acc.substanceprotein
              ])
            r4us.ResourceSubstancereferenceinformation(r) ->
              GroupedResources(..acc, substancereferenceinformation: [
                r,
                ..acc.substancereferenceinformation
              ])
            r4us.ResourceSubstancesourcematerial(r) ->
              GroupedResources(..acc, substancesourcematerial: [
                r,
                ..acc.substancesourcematerial
              ])
            r4us.ResourceSubstancespecification(r) ->
              GroupedResources(..acc, substancespecification: [
                r,
                ..acc.substancespecification
              ])
            r4us.ResourceSupplydelivery(r) ->
              GroupedResources(..acc, supplydelivery: [r, ..acc.supplydelivery])
            r4us.ResourceSupplyrequest(r) ->
              GroupedResources(..acc, supplyrequest: [r, ..acc.supplyrequest])
            r4us.ResourceTask(r) ->
              GroupedResources(..acc, task: [r, ..acc.task])
            r4us.ResourceTerminologycapabilities(r) ->
              GroupedResources(..acc, terminologycapabilities: [
                r,
                ..acc.terminologycapabilities
              ])
            r4us.ResourceTestreport(r) ->
              GroupedResources(..acc, testreport: [r, ..acc.testreport])
            r4us.ResourceTestscript(r) ->
              GroupedResources(..acc, testscript: [r, ..acc.testscript])
            r4us.ResourceValueset(r) ->
              GroupedResources(..acc, valueset: [r, ..acc.valueset])
            r4us.ResourceVerificationresult(r) ->
              GroupedResources(..acc, verificationresult: [
                r,
                ..acc.verificationresult
              ])
            r4us.ResourceVisionprescription(r) ->
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
