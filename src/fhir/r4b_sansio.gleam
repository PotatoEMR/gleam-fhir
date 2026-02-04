////[https://hl7.org/fhir/r4b](https://hl7.org/fhir/r4b) r4b sans-io request/response helpers suitable for building clients on top of, such as r4b_httpc.gleam and r4b_rsvp.gleam

import fhir/r4b
import gleam/dynamic/decode
import gleam/http
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/json.{type Json}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import gleam/uri

pub type FhirClient {
  FhirClient(baseurl: uri.Uri)
}

//todo some tests to make sure no reasonable base url will panic
pub fn fhirclient_new(baseurl: String) {
  let assert Ok(b) = uri.parse(baseurl)
  FhirClient(b)
}

pub type Err {
  //could not make a delete or update request because resource has no id
  ErrNoId
  //got json but could not parse it, probably a missing required field
  ErrParseJson(json.DecodeError)
  //did not get resource json, often server eg nginx gives basic html response
  ErrNotJson(Response(String))
  //got operationoutcome error from fhir server
  ErrOperationcome(r4b.Operationoutcome)
}

pub fn any_create_req(resource_json: Json, res_type: String, client: FhirClient) {
  let assert Ok(req) =
    request.to(string.join([client.baseurl |> uri.to_string, res_type], "/"))
  req
  |> request.set_header("Accept", "application/fhir+json")
  |> request.set_header("Content-Type", "application/fhir+json")
  |> request.set_header("Prefer", "return=representation")
  |> request.set_body(resource_json |> json.to_string)
  |> request.set_method(http.Post)
}

pub fn any_read_req(id: String, res_type: String, client: FhirClient) {
  let assert Ok(req) =
    request.to(string.join([client.baseurl |> uri.to_string, res_type, id], "/"))
  req
  |> request.set_header("Accept", "application/fhir+json")
}

pub fn any_update_req(
  id: Option(String),
  resource_json: Json,
  res_type: String,
  client: FhirClient,
) -> Result(Request(String), Err) {
  case id {
    None -> Error(ErrNoId)
    Some(id) -> {
      let assert Ok(req) =
        request.to(string.join(
          [client.baseurl |> uri.to_string, res_type, id],
          "/",
        ))
      Ok(
        req
        |> request.set_header("Accept", "application/fhir+json")
        |> request.set_header("Content-Type", "application/fhir+json")
        |> request.set_header("Prefer", "return=representation")
        |> request.set_body(resource_json |> json.to_string)
        |> request.set_method(http.Put),
      )
    }
  }
}

pub fn any_delete_req(
  id: Option(String),
  res_type: String,
  client: FhirClient,
) -> Result(Request(String), Err) {
  case id {
    None -> Error(ErrNoId)
    Some(id) -> {
      let assert Ok(req) =
        request.to(string.join(
          [client.baseurl |> uri.to_string, res_type, id],
          "/",
        ))
      Ok(
        req
        |> request.set_header("Accept", "application/fhir+json")
        |> request.set_method(http.Delete),
      )
    }
  }
}

pub fn any_search_req(
  search_string: String,
  res_type: String,
  client: FhirClient,
) -> Request(String) {
  let assert Ok(req) =
    request.to(
      string.concat([
        client.baseurl |> uri.to_string,
        "/",
        res_type,
        "?",
        search_string,
      ]),
    )
  req
  |> request.set_header("Accept", "application/fhir+json")
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
      True -> r4b.operationoutcome_decoder() |> decode.map(fn(x) { Error(x) })
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
  resource: r4b.Account,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.account_to_json(resource), "Account", client)
}

pub fn account_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Account", client)
}

pub fn account_update_req(
  resource: r4b.Account,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4b.account_to_json(resource), "Account", client)
}

pub fn account_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Account", client)
}

pub fn account_resp(resp: Response(String)) -> Result(r4b.Account, Err) {
  any_resp(resp, r4b.account_decoder())
}

pub fn activitydefinition_create_req(
  resource: r4b.Activitydefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.activitydefinition_to_json(resource),
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
  resource: r4b.Activitydefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.activitydefinition_to_json(resource),
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
) -> Result(r4b.Activitydefinition, Err) {
  any_resp(resp, r4b.activitydefinition_decoder())
}

pub fn administrableproductdefinition_create_req(
  resource: r4b.Administrableproductdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.administrableproductdefinition_to_json(resource),
    "AdministrableProductDefinition",
    client,
  )
}

pub fn administrableproductdefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "AdministrableProductDefinition", client)
}

pub fn administrableproductdefinition_update_req(
  resource: r4b.Administrableproductdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.administrableproductdefinition_to_json(resource),
    "AdministrableProductDefinition",
    client,
  )
}

pub fn administrableproductdefinition_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "AdministrableProductDefinition", client)
}

pub fn administrableproductdefinition_resp(
  resp: Response(String),
) -> Result(r4b.Administrableproductdefinition, Err) {
  any_resp(resp, r4b.administrableproductdefinition_decoder())
}

pub fn adverseevent_create_req(
  resource: r4b.Adverseevent,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.adverseevent_to_json(resource), "AdverseEvent", client)
}

pub fn adverseevent_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "AdverseEvent", client)
}

pub fn adverseevent_update_req(
  resource: r4b.Adverseevent,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.adverseevent_to_json(resource),
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
) -> Result(r4b.Adverseevent, Err) {
  any_resp(resp, r4b.adverseevent_decoder())
}

pub fn allergyintolerance_create_req(
  resource: r4b.Allergyintolerance,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    client,
  )
}

pub fn allergyintolerance_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "AllergyIntolerance", client)
}

pub fn allergyintolerance_update_req(
  resource: r4b.Allergyintolerance,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    client,
  )
}

pub fn allergyintolerance_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "AllergyIntolerance", client)
}

pub fn allergyintolerance_resp(
  resp: Response(String),
) -> Result(r4b.Allergyintolerance, Err) {
  any_resp(resp, r4b.allergyintolerance_decoder())
}

pub fn appointment_create_req(
  resource: r4b.Appointment,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.appointment_to_json(resource), "Appointment", client)
}

pub fn appointment_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Appointment", client)
}

pub fn appointment_update_req(
  resource: r4b.Appointment,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.appointment_to_json(resource),
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

pub fn appointment_resp(resp: Response(String)) -> Result(r4b.Appointment, Err) {
  any_resp(resp, r4b.appointment_decoder())
}

pub fn appointmentresponse_create_req(
  resource: r4b.Appointmentresponse,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.appointmentresponse_to_json(resource),
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
  resource: r4b.Appointmentresponse,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.appointmentresponse_to_json(resource),
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
) -> Result(r4b.Appointmentresponse, Err) {
  any_resp(resp, r4b.appointmentresponse_decoder())
}

pub fn auditevent_create_req(
  resource: r4b.Auditevent,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.auditevent_to_json(resource), "AuditEvent", client)
}

pub fn auditevent_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "AuditEvent", client)
}

pub fn auditevent_update_req(
  resource: r4b.Auditevent,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.auditevent_to_json(resource),
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

pub fn auditevent_resp(resp: Response(String)) -> Result(r4b.Auditevent, Err) {
  any_resp(resp, r4b.auditevent_decoder())
}

pub fn basic_create_req(
  resource: r4b.Basic,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.basic_to_json(resource), "Basic", client)
}

pub fn basic_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Basic", client)
}

pub fn basic_update_req(
  resource: r4b.Basic,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4b.basic_to_json(resource), "Basic", client)
}

pub fn basic_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Basic", client)
}

pub fn basic_resp(resp: Response(String)) -> Result(r4b.Basic, Err) {
  any_resp(resp, r4b.basic_decoder())
}

pub fn binary_create_req(
  resource: r4b.Binary,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.binary_to_json(resource), "Binary", client)
}

pub fn binary_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Binary", client)
}

pub fn binary_update_req(
  resource: r4b.Binary,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4b.binary_to_json(resource), "Binary", client)
}

pub fn binary_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Binary", client)
}

pub fn binary_resp(resp: Response(String)) -> Result(r4b.Binary, Err) {
  any_resp(resp, r4b.binary_decoder())
}

pub fn biologicallyderivedproduct_create_req(
  resource: r4b.Biologicallyderivedproduct,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.biologicallyderivedproduct_to_json(resource),
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
  resource: r4b.Biologicallyderivedproduct,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.biologicallyderivedproduct_to_json(resource),
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
) -> Result(r4b.Biologicallyderivedproduct, Err) {
  any_resp(resp, r4b.biologicallyderivedproduct_decoder())
}

pub fn bodystructure_create_req(
  resource: r4b.Bodystructure,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.bodystructure_to_json(resource), "BodyStructure", client)
}

pub fn bodystructure_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "BodyStructure", client)
}

pub fn bodystructure_update_req(
  resource: r4b.Bodystructure,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.bodystructure_to_json(resource),
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
) -> Result(r4b.Bodystructure, Err) {
  any_resp(resp, r4b.bodystructure_decoder())
}

pub fn bundle_create_req(
  resource: r4b.Bundle,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.bundle_to_json(resource), "Bundle", client)
}

pub fn bundle_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Bundle", client)
}

pub fn bundle_update_req(
  resource: r4b.Bundle,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4b.bundle_to_json(resource), "Bundle", client)
}

pub fn bundle_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Bundle", client)
}

pub fn bundle_resp(resp: Response(String)) -> Result(r4b.Bundle, Err) {
  any_resp(resp, r4b.bundle_decoder())
}

pub fn capabilitystatement_create_req(
  resource: r4b.Capabilitystatement,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.capabilitystatement_to_json(resource),
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
  resource: r4b.Capabilitystatement,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.capabilitystatement_to_json(resource),
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
) -> Result(r4b.Capabilitystatement, Err) {
  any_resp(resp, r4b.capabilitystatement_decoder())
}

pub fn careplan_create_req(
  resource: r4b.Careplan,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.careplan_to_json(resource), "CarePlan", client)
}

pub fn careplan_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "CarePlan", client)
}

pub fn careplan_update_req(
  resource: r4b.Careplan,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.careplan_to_json(resource),
    "CarePlan",
    client,
  )
}

pub fn careplan_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "CarePlan", client)
}

pub fn careplan_resp(resp: Response(String)) -> Result(r4b.Careplan, Err) {
  any_resp(resp, r4b.careplan_decoder())
}

pub fn careteam_create_req(
  resource: r4b.Careteam,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.careteam_to_json(resource), "CareTeam", client)
}

pub fn careteam_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "CareTeam", client)
}

pub fn careteam_update_req(
  resource: r4b.Careteam,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.careteam_to_json(resource),
    "CareTeam",
    client,
  )
}

pub fn careteam_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "CareTeam", client)
}

pub fn careteam_resp(resp: Response(String)) -> Result(r4b.Careteam, Err) {
  any_resp(resp, r4b.careteam_decoder())
}

pub fn catalogentry_create_req(
  resource: r4b.Catalogentry,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.catalogentry_to_json(resource), "CatalogEntry", client)
}

pub fn catalogentry_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "CatalogEntry", client)
}

pub fn catalogentry_update_req(
  resource: r4b.Catalogentry,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.catalogentry_to_json(resource),
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
) -> Result(r4b.Catalogentry, Err) {
  any_resp(resp, r4b.catalogentry_decoder())
}

pub fn chargeitem_create_req(
  resource: r4b.Chargeitem,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.chargeitem_to_json(resource), "ChargeItem", client)
}

pub fn chargeitem_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "ChargeItem", client)
}

pub fn chargeitem_update_req(
  resource: r4b.Chargeitem,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.chargeitem_to_json(resource),
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

pub fn chargeitem_resp(resp: Response(String)) -> Result(r4b.Chargeitem, Err) {
  any_resp(resp, r4b.chargeitem_decoder())
}

pub fn chargeitemdefinition_create_req(
  resource: r4b.Chargeitemdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.chargeitemdefinition_to_json(resource),
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
  resource: r4b.Chargeitemdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.chargeitemdefinition_to_json(resource),
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
) -> Result(r4b.Chargeitemdefinition, Err) {
  any_resp(resp, r4b.chargeitemdefinition_decoder())
}

pub fn citation_create_req(
  resource: r4b.Citation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.citation_to_json(resource), "Citation", client)
}

pub fn citation_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Citation", client)
}

pub fn citation_update_req(
  resource: r4b.Citation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.citation_to_json(resource),
    "Citation",
    client,
  )
}

pub fn citation_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Citation", client)
}

pub fn citation_resp(resp: Response(String)) -> Result(r4b.Citation, Err) {
  any_resp(resp, r4b.citation_decoder())
}

pub fn claim_create_req(
  resource: r4b.Claim,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.claim_to_json(resource), "Claim", client)
}

pub fn claim_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Claim", client)
}

pub fn claim_update_req(
  resource: r4b.Claim,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4b.claim_to_json(resource), "Claim", client)
}

pub fn claim_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Claim", client)
}

pub fn claim_resp(resp: Response(String)) -> Result(r4b.Claim, Err) {
  any_resp(resp, r4b.claim_decoder())
}

pub fn claimresponse_create_req(
  resource: r4b.Claimresponse,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.claimresponse_to_json(resource), "ClaimResponse", client)
}

pub fn claimresponse_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "ClaimResponse", client)
}

pub fn claimresponse_update_req(
  resource: r4b.Claimresponse,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.claimresponse_to_json(resource),
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
) -> Result(r4b.Claimresponse, Err) {
  any_resp(resp, r4b.claimresponse_decoder())
}

pub fn clinicalimpression_create_req(
  resource: r4b.Clinicalimpression,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.clinicalimpression_to_json(resource),
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
  resource: r4b.Clinicalimpression,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.clinicalimpression_to_json(resource),
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
) -> Result(r4b.Clinicalimpression, Err) {
  any_resp(resp, r4b.clinicalimpression_decoder())
}

pub fn clinicalusedefinition_create_req(
  resource: r4b.Clinicalusedefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.clinicalusedefinition_to_json(resource),
    "ClinicalUseDefinition",
    client,
  )
}

pub fn clinicalusedefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "ClinicalUseDefinition", client)
}

pub fn clinicalusedefinition_update_req(
  resource: r4b.Clinicalusedefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.clinicalusedefinition_to_json(resource),
    "ClinicalUseDefinition",
    client,
  )
}

pub fn clinicalusedefinition_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "ClinicalUseDefinition", client)
}

pub fn clinicalusedefinition_resp(
  resp: Response(String),
) -> Result(r4b.Clinicalusedefinition, Err) {
  any_resp(resp, r4b.clinicalusedefinition_decoder())
}

pub fn codesystem_create_req(
  resource: r4b.Codesystem,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.codesystem_to_json(resource), "CodeSystem", client)
}

pub fn codesystem_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "CodeSystem", client)
}

pub fn codesystem_update_req(
  resource: r4b.Codesystem,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.codesystem_to_json(resource),
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

pub fn codesystem_resp(resp: Response(String)) -> Result(r4b.Codesystem, Err) {
  any_resp(resp, r4b.codesystem_decoder())
}

pub fn communication_create_req(
  resource: r4b.Communication,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.communication_to_json(resource), "Communication", client)
}

pub fn communication_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Communication", client)
}

pub fn communication_update_req(
  resource: r4b.Communication,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.communication_to_json(resource),
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
) -> Result(r4b.Communication, Err) {
  any_resp(resp, r4b.communication_decoder())
}

pub fn communicationrequest_create_req(
  resource: r4b.Communicationrequest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.communicationrequest_to_json(resource),
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
  resource: r4b.Communicationrequest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.communicationrequest_to_json(resource),
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
) -> Result(r4b.Communicationrequest, Err) {
  any_resp(resp, r4b.communicationrequest_decoder())
}

pub fn compartmentdefinition_create_req(
  resource: r4b.Compartmentdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.compartmentdefinition_to_json(resource),
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
  resource: r4b.Compartmentdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.compartmentdefinition_to_json(resource),
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
) -> Result(r4b.Compartmentdefinition, Err) {
  any_resp(resp, r4b.compartmentdefinition_decoder())
}

pub fn composition_create_req(
  resource: r4b.Composition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.composition_to_json(resource), "Composition", client)
}

pub fn composition_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Composition", client)
}

pub fn composition_update_req(
  resource: r4b.Composition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.composition_to_json(resource),
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

pub fn composition_resp(resp: Response(String)) -> Result(r4b.Composition, Err) {
  any_resp(resp, r4b.composition_decoder())
}

pub fn conceptmap_create_req(
  resource: r4b.Conceptmap,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.conceptmap_to_json(resource), "ConceptMap", client)
}

pub fn conceptmap_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "ConceptMap", client)
}

pub fn conceptmap_update_req(
  resource: r4b.Conceptmap,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.conceptmap_to_json(resource),
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

pub fn conceptmap_resp(resp: Response(String)) -> Result(r4b.Conceptmap, Err) {
  any_resp(resp, r4b.conceptmap_decoder())
}

pub fn condition_create_req(
  resource: r4b.Condition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.condition_to_json(resource), "Condition", client)
}

pub fn condition_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Condition", client)
}

pub fn condition_update_req(
  resource: r4b.Condition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.condition_to_json(resource),
    "Condition",
    client,
  )
}

pub fn condition_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Condition", client)
}

pub fn condition_resp(resp: Response(String)) -> Result(r4b.Condition, Err) {
  any_resp(resp, r4b.condition_decoder())
}

pub fn consent_create_req(
  resource: r4b.Consent,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.consent_to_json(resource), "Consent", client)
}

pub fn consent_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Consent", client)
}

pub fn consent_update_req(
  resource: r4b.Consent,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4b.consent_to_json(resource), "Consent", client)
}

pub fn consent_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Consent", client)
}

pub fn consent_resp(resp: Response(String)) -> Result(r4b.Consent, Err) {
  any_resp(resp, r4b.consent_decoder())
}

pub fn contract_create_req(
  resource: r4b.Contract,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.contract_to_json(resource), "Contract", client)
}

pub fn contract_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Contract", client)
}

pub fn contract_update_req(
  resource: r4b.Contract,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.contract_to_json(resource),
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

pub fn contract_resp(resp: Response(String)) -> Result(r4b.Contract, Err) {
  any_resp(resp, r4b.contract_decoder())
}

pub fn coverage_create_req(
  resource: r4b.Coverage,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.coverage_to_json(resource), "Coverage", client)
}

pub fn coverage_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Coverage", client)
}

pub fn coverage_update_req(
  resource: r4b.Coverage,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.coverage_to_json(resource),
    "Coverage",
    client,
  )
}

pub fn coverage_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Coverage", client)
}

pub fn coverage_resp(resp: Response(String)) -> Result(r4b.Coverage, Err) {
  any_resp(resp, r4b.coverage_decoder())
}

pub fn coverageeligibilityrequest_create_req(
  resource: r4b.Coverageeligibilityrequest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.coverageeligibilityrequest_to_json(resource),
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
  resource: r4b.Coverageeligibilityrequest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.coverageeligibilityrequest_to_json(resource),
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
) -> Result(r4b.Coverageeligibilityrequest, Err) {
  any_resp(resp, r4b.coverageeligibilityrequest_decoder())
}

pub fn coverageeligibilityresponse_create_req(
  resource: r4b.Coverageeligibilityresponse,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.coverageeligibilityresponse_to_json(resource),
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
  resource: r4b.Coverageeligibilityresponse,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.coverageeligibilityresponse_to_json(resource),
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
) -> Result(r4b.Coverageeligibilityresponse, Err) {
  any_resp(resp, r4b.coverageeligibilityresponse_decoder())
}

pub fn detectedissue_create_req(
  resource: r4b.Detectedissue,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.detectedissue_to_json(resource), "DetectedIssue", client)
}

pub fn detectedissue_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "DetectedIssue", client)
}

pub fn detectedissue_update_req(
  resource: r4b.Detectedissue,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.detectedissue_to_json(resource),
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
) -> Result(r4b.Detectedissue, Err) {
  any_resp(resp, r4b.detectedissue_decoder())
}

pub fn device_create_req(
  resource: r4b.Device,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.device_to_json(resource), "Device", client)
}

pub fn device_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Device", client)
}

pub fn device_update_req(
  resource: r4b.Device,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4b.device_to_json(resource), "Device", client)
}

pub fn device_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Device", client)
}

pub fn device_resp(resp: Response(String)) -> Result(r4b.Device, Err) {
  any_resp(resp, r4b.device_decoder())
}

pub fn devicedefinition_create_req(
  resource: r4b.Devicedefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.devicedefinition_to_json(resource),
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
  resource: r4b.Devicedefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.devicedefinition_to_json(resource),
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
) -> Result(r4b.Devicedefinition, Err) {
  any_resp(resp, r4b.devicedefinition_decoder())
}

pub fn devicemetric_create_req(
  resource: r4b.Devicemetric,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.devicemetric_to_json(resource), "DeviceMetric", client)
}

pub fn devicemetric_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "DeviceMetric", client)
}

pub fn devicemetric_update_req(
  resource: r4b.Devicemetric,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.devicemetric_to_json(resource),
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
) -> Result(r4b.Devicemetric, Err) {
  any_resp(resp, r4b.devicemetric_decoder())
}

pub fn devicerequest_create_req(
  resource: r4b.Devicerequest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.devicerequest_to_json(resource), "DeviceRequest", client)
}

pub fn devicerequest_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "DeviceRequest", client)
}

pub fn devicerequest_update_req(
  resource: r4b.Devicerequest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.devicerequest_to_json(resource),
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
) -> Result(r4b.Devicerequest, Err) {
  any_resp(resp, r4b.devicerequest_decoder())
}

pub fn deviceusestatement_create_req(
  resource: r4b.Deviceusestatement,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.deviceusestatement_to_json(resource),
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
  resource: r4b.Deviceusestatement,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.deviceusestatement_to_json(resource),
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
) -> Result(r4b.Deviceusestatement, Err) {
  any_resp(resp, r4b.deviceusestatement_decoder())
}

pub fn diagnosticreport_create_req(
  resource: r4b.Diagnosticreport,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.diagnosticreport_to_json(resource),
    "DiagnosticReport",
    client,
  )
}

pub fn diagnosticreport_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "DiagnosticReport", client)
}

pub fn diagnosticreport_update_req(
  resource: r4b.Diagnosticreport,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.diagnosticreport_to_json(resource),
    "DiagnosticReport",
    client,
  )
}

pub fn diagnosticreport_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "DiagnosticReport", client)
}

pub fn diagnosticreport_resp(
  resp: Response(String),
) -> Result(r4b.Diagnosticreport, Err) {
  any_resp(resp, r4b.diagnosticreport_decoder())
}

pub fn documentmanifest_create_req(
  resource: r4b.Documentmanifest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.documentmanifest_to_json(resource),
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
  resource: r4b.Documentmanifest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.documentmanifest_to_json(resource),
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
) -> Result(r4b.Documentmanifest, Err) {
  any_resp(resp, r4b.documentmanifest_decoder())
}

pub fn documentreference_create_req(
  resource: r4b.Documentreference,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.documentreference_to_json(resource),
    "DocumentReference",
    client,
  )
}

pub fn documentreference_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "DocumentReference", client)
}

pub fn documentreference_update_req(
  resource: r4b.Documentreference,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.documentreference_to_json(resource),
    "DocumentReference",
    client,
  )
}

pub fn documentreference_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "DocumentReference", client)
}

pub fn documentreference_resp(
  resp: Response(String),
) -> Result(r4b.Documentreference, Err) {
  any_resp(resp, r4b.documentreference_decoder())
}

pub fn encounter_create_req(
  resource: r4b.Encounter,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.encounter_to_json(resource), "Encounter", client)
}

pub fn encounter_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Encounter", client)
}

pub fn encounter_update_req(
  resource: r4b.Encounter,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.encounter_to_json(resource),
    "Encounter",
    client,
  )
}

pub fn encounter_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Encounter", client)
}

pub fn encounter_resp(resp: Response(String)) -> Result(r4b.Encounter, Err) {
  any_resp(resp, r4b.encounter_decoder())
}

pub fn endpoint_create_req(
  resource: r4b.Endpoint,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.endpoint_to_json(resource), "Endpoint", client)
}

pub fn endpoint_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Endpoint", client)
}

pub fn endpoint_update_req(
  resource: r4b.Endpoint,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.endpoint_to_json(resource),
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

pub fn endpoint_resp(resp: Response(String)) -> Result(r4b.Endpoint, Err) {
  any_resp(resp, r4b.endpoint_decoder())
}

pub fn enrollmentrequest_create_req(
  resource: r4b.Enrollmentrequest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.enrollmentrequest_to_json(resource),
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
  resource: r4b.Enrollmentrequest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.enrollmentrequest_to_json(resource),
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
) -> Result(r4b.Enrollmentrequest, Err) {
  any_resp(resp, r4b.enrollmentrequest_decoder())
}

pub fn enrollmentresponse_create_req(
  resource: r4b.Enrollmentresponse,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.enrollmentresponse_to_json(resource),
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
  resource: r4b.Enrollmentresponse,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.enrollmentresponse_to_json(resource),
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
) -> Result(r4b.Enrollmentresponse, Err) {
  any_resp(resp, r4b.enrollmentresponse_decoder())
}

pub fn episodeofcare_create_req(
  resource: r4b.Episodeofcare,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.episodeofcare_to_json(resource), "EpisodeOfCare", client)
}

pub fn episodeofcare_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "EpisodeOfCare", client)
}

pub fn episodeofcare_update_req(
  resource: r4b.Episodeofcare,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.episodeofcare_to_json(resource),
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
) -> Result(r4b.Episodeofcare, Err) {
  any_resp(resp, r4b.episodeofcare_decoder())
}

pub fn eventdefinition_create_req(
  resource: r4b.Eventdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.eventdefinition_to_json(resource),
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
  resource: r4b.Eventdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.eventdefinition_to_json(resource),
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
) -> Result(r4b.Eventdefinition, Err) {
  any_resp(resp, r4b.eventdefinition_decoder())
}

pub fn evidence_create_req(
  resource: r4b.Evidence,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.evidence_to_json(resource), "Evidence", client)
}

pub fn evidence_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Evidence", client)
}

pub fn evidence_update_req(
  resource: r4b.Evidence,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.evidence_to_json(resource),
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

pub fn evidence_resp(resp: Response(String)) -> Result(r4b.Evidence, Err) {
  any_resp(resp, r4b.evidence_decoder())
}

pub fn evidencereport_create_req(
  resource: r4b.Evidencereport,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.evidencereport_to_json(resource), "EvidenceReport", client)
}

pub fn evidencereport_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "EvidenceReport", client)
}

pub fn evidencereport_update_req(
  resource: r4b.Evidencereport,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.evidencereport_to_json(resource),
    "EvidenceReport",
    client,
  )
}

pub fn evidencereport_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "EvidenceReport", client)
}

pub fn evidencereport_resp(
  resp: Response(String),
) -> Result(r4b.Evidencereport, Err) {
  any_resp(resp, r4b.evidencereport_decoder())
}

pub fn evidencevariable_create_req(
  resource: r4b.Evidencevariable,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.evidencevariable_to_json(resource),
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
  resource: r4b.Evidencevariable,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.evidencevariable_to_json(resource),
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
) -> Result(r4b.Evidencevariable, Err) {
  any_resp(resp, r4b.evidencevariable_decoder())
}

pub fn examplescenario_create_req(
  resource: r4b.Examplescenario,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.examplescenario_to_json(resource),
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
  resource: r4b.Examplescenario,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.examplescenario_to_json(resource),
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
) -> Result(r4b.Examplescenario, Err) {
  any_resp(resp, r4b.examplescenario_decoder())
}

pub fn explanationofbenefit_create_req(
  resource: r4b.Explanationofbenefit,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.explanationofbenefit_to_json(resource),
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
  resource: r4b.Explanationofbenefit,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.explanationofbenefit_to_json(resource),
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
) -> Result(r4b.Explanationofbenefit, Err) {
  any_resp(resp, r4b.explanationofbenefit_decoder())
}

pub fn familymemberhistory_create_req(
  resource: r4b.Familymemberhistory,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    client,
  )
}

pub fn familymemberhistory_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "FamilyMemberHistory", client)
}

pub fn familymemberhistory_update_req(
  resource: r4b.Familymemberhistory,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    client,
  )
}

pub fn familymemberhistory_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "FamilyMemberHistory", client)
}

pub fn familymemberhistory_resp(
  resp: Response(String),
) -> Result(r4b.Familymemberhistory, Err) {
  any_resp(resp, r4b.familymemberhistory_decoder())
}

pub fn flag_create_req(
  resource: r4b.Flag,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.flag_to_json(resource), "Flag", client)
}

pub fn flag_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Flag", client)
}

pub fn flag_update_req(
  resource: r4b.Flag,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4b.flag_to_json(resource), "Flag", client)
}

pub fn flag_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Flag", client)
}

pub fn flag_resp(resp: Response(String)) -> Result(r4b.Flag, Err) {
  any_resp(resp, r4b.flag_decoder())
}

pub fn goal_create_req(
  resource: r4b.Goal,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.goal_to_json(resource), "Goal", client)
}

pub fn goal_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Goal", client)
}

pub fn goal_update_req(
  resource: r4b.Goal,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4b.goal_to_json(resource), "Goal", client)
}

pub fn goal_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Goal", client)
}

pub fn goal_resp(resp: Response(String)) -> Result(r4b.Goal, Err) {
  any_resp(resp, r4b.goal_decoder())
}

pub fn graphdefinition_create_req(
  resource: r4b.Graphdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.graphdefinition_to_json(resource),
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
  resource: r4b.Graphdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.graphdefinition_to_json(resource),
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
) -> Result(r4b.Graphdefinition, Err) {
  any_resp(resp, r4b.graphdefinition_decoder())
}

pub fn group_create_req(
  resource: r4b.Group,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.group_to_json(resource), "Group", client)
}

pub fn group_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Group", client)
}

pub fn group_update_req(
  resource: r4b.Group,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4b.group_to_json(resource), "Group", client)
}

pub fn group_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Group", client)
}

pub fn group_resp(resp: Response(String)) -> Result(r4b.Group, Err) {
  any_resp(resp, r4b.group_decoder())
}

pub fn guidanceresponse_create_req(
  resource: r4b.Guidanceresponse,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.guidanceresponse_to_json(resource),
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
  resource: r4b.Guidanceresponse,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.guidanceresponse_to_json(resource),
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
) -> Result(r4b.Guidanceresponse, Err) {
  any_resp(resp, r4b.guidanceresponse_decoder())
}

pub fn healthcareservice_create_req(
  resource: r4b.Healthcareservice,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.healthcareservice_to_json(resource),
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
  resource: r4b.Healthcareservice,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.healthcareservice_to_json(resource),
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
) -> Result(r4b.Healthcareservice, Err) {
  any_resp(resp, r4b.healthcareservice_decoder())
}

pub fn imagingstudy_create_req(
  resource: r4b.Imagingstudy,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.imagingstudy_to_json(resource), "ImagingStudy", client)
}

pub fn imagingstudy_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "ImagingStudy", client)
}

pub fn imagingstudy_update_req(
  resource: r4b.Imagingstudy,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.imagingstudy_to_json(resource),
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
) -> Result(r4b.Imagingstudy, Err) {
  any_resp(resp, r4b.imagingstudy_decoder())
}

pub fn immunization_create_req(
  resource: r4b.Immunization,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.immunization_to_json(resource), "Immunization", client)
}

pub fn immunization_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Immunization", client)
}

pub fn immunization_update_req(
  resource: r4b.Immunization,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.immunization_to_json(resource),
    "Immunization",
    client,
  )
}

pub fn immunization_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Immunization", client)
}

pub fn immunization_resp(
  resp: Response(String),
) -> Result(r4b.Immunization, Err) {
  any_resp(resp, r4b.immunization_decoder())
}

pub fn immunizationevaluation_create_req(
  resource: r4b.Immunizationevaluation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.immunizationevaluation_to_json(resource),
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
  resource: r4b.Immunizationevaluation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.immunizationevaluation_to_json(resource),
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
) -> Result(r4b.Immunizationevaluation, Err) {
  any_resp(resp, r4b.immunizationevaluation_decoder())
}

pub fn immunizationrecommendation_create_req(
  resource: r4b.Immunizationrecommendation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.immunizationrecommendation_to_json(resource),
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
  resource: r4b.Immunizationrecommendation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.immunizationrecommendation_to_json(resource),
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
) -> Result(r4b.Immunizationrecommendation, Err) {
  any_resp(resp, r4b.immunizationrecommendation_decoder())
}

pub fn implementationguide_create_req(
  resource: r4b.Implementationguide,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.implementationguide_to_json(resource),
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
  resource: r4b.Implementationguide,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.implementationguide_to_json(resource),
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
) -> Result(r4b.Implementationguide, Err) {
  any_resp(resp, r4b.implementationguide_decoder())
}

pub fn ingredient_create_req(
  resource: r4b.Ingredient,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.ingredient_to_json(resource), "Ingredient", client)
}

pub fn ingredient_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Ingredient", client)
}

pub fn ingredient_update_req(
  resource: r4b.Ingredient,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.ingredient_to_json(resource),
    "Ingredient",
    client,
  )
}

pub fn ingredient_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Ingredient", client)
}

pub fn ingredient_resp(resp: Response(String)) -> Result(r4b.Ingredient, Err) {
  any_resp(resp, r4b.ingredient_decoder())
}

pub fn insuranceplan_create_req(
  resource: r4b.Insuranceplan,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.insuranceplan_to_json(resource), "InsurancePlan", client)
}

pub fn insuranceplan_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "InsurancePlan", client)
}

pub fn insuranceplan_update_req(
  resource: r4b.Insuranceplan,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.insuranceplan_to_json(resource),
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
) -> Result(r4b.Insuranceplan, Err) {
  any_resp(resp, r4b.insuranceplan_decoder())
}

pub fn invoice_create_req(
  resource: r4b.Invoice,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.invoice_to_json(resource), "Invoice", client)
}

pub fn invoice_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Invoice", client)
}

pub fn invoice_update_req(
  resource: r4b.Invoice,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4b.invoice_to_json(resource), "Invoice", client)
}

pub fn invoice_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Invoice", client)
}

pub fn invoice_resp(resp: Response(String)) -> Result(r4b.Invoice, Err) {
  any_resp(resp, r4b.invoice_decoder())
}

pub fn library_create_req(
  resource: r4b.Library,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.library_to_json(resource), "Library", client)
}

pub fn library_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Library", client)
}

pub fn library_update_req(
  resource: r4b.Library,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4b.library_to_json(resource), "Library", client)
}

pub fn library_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Library", client)
}

pub fn library_resp(resp: Response(String)) -> Result(r4b.Library, Err) {
  any_resp(resp, r4b.library_decoder())
}

pub fn linkage_create_req(
  resource: r4b.Linkage,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.linkage_to_json(resource), "Linkage", client)
}

pub fn linkage_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Linkage", client)
}

pub fn linkage_update_req(
  resource: r4b.Linkage,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4b.linkage_to_json(resource), "Linkage", client)
}

pub fn linkage_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Linkage", client)
}

pub fn linkage_resp(resp: Response(String)) -> Result(r4b.Linkage, Err) {
  any_resp(resp, r4b.linkage_decoder())
}

pub fn listfhir_create_req(
  resource: r4b.Listfhir,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.listfhir_to_json(resource), "List", client)
}

pub fn listfhir_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "List", client)
}

pub fn listfhir_update_req(
  resource: r4b.Listfhir,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4b.listfhir_to_json(resource), "List", client)
}

pub fn listfhir_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "List", client)
}

pub fn listfhir_resp(resp: Response(String)) -> Result(r4b.Listfhir, Err) {
  any_resp(resp, r4b.listfhir_decoder())
}

pub fn location_create_req(
  resource: r4b.Location,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.location_to_json(resource), "Location", client)
}

pub fn location_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Location", client)
}

pub fn location_update_req(
  resource: r4b.Location,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.location_to_json(resource),
    "Location",
    client,
  )
}

pub fn location_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Location", client)
}

pub fn location_resp(resp: Response(String)) -> Result(r4b.Location, Err) {
  any_resp(resp, r4b.location_decoder())
}

pub fn manufactureditemdefinition_create_req(
  resource: r4b.Manufactureditemdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.manufactureditemdefinition_to_json(resource),
    "ManufacturedItemDefinition",
    client,
  )
}

pub fn manufactureditemdefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "ManufacturedItemDefinition", client)
}

pub fn manufactureditemdefinition_update_req(
  resource: r4b.Manufactureditemdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.manufactureditemdefinition_to_json(resource),
    "ManufacturedItemDefinition",
    client,
  )
}

pub fn manufactureditemdefinition_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "ManufacturedItemDefinition", client)
}

pub fn manufactureditemdefinition_resp(
  resp: Response(String),
) -> Result(r4b.Manufactureditemdefinition, Err) {
  any_resp(resp, r4b.manufactureditemdefinition_decoder())
}

pub fn measure_create_req(
  resource: r4b.Measure,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.measure_to_json(resource), "Measure", client)
}

pub fn measure_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Measure", client)
}

pub fn measure_update_req(
  resource: r4b.Measure,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4b.measure_to_json(resource), "Measure", client)
}

pub fn measure_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Measure", client)
}

pub fn measure_resp(resp: Response(String)) -> Result(r4b.Measure, Err) {
  any_resp(resp, r4b.measure_decoder())
}

pub fn measurereport_create_req(
  resource: r4b.Measurereport,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.measurereport_to_json(resource), "MeasureReport", client)
}

pub fn measurereport_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "MeasureReport", client)
}

pub fn measurereport_update_req(
  resource: r4b.Measurereport,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.measurereport_to_json(resource),
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
) -> Result(r4b.Measurereport, Err) {
  any_resp(resp, r4b.measurereport_decoder())
}

pub fn media_create_req(
  resource: r4b.Media,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.media_to_json(resource), "Media", client)
}

pub fn media_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Media", client)
}

pub fn media_update_req(
  resource: r4b.Media,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4b.media_to_json(resource), "Media", client)
}

pub fn media_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Media", client)
}

pub fn media_resp(resp: Response(String)) -> Result(r4b.Media, Err) {
  any_resp(resp, r4b.media_decoder())
}

pub fn medication_create_req(
  resource: r4b.Medication,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.medication_to_json(resource), "Medication", client)
}

pub fn medication_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Medication", client)
}

pub fn medication_update_req(
  resource: r4b.Medication,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.medication_to_json(resource),
    "Medication",
    client,
  )
}

pub fn medication_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Medication", client)
}

pub fn medication_resp(resp: Response(String)) -> Result(r4b.Medication, Err) {
  any_resp(resp, r4b.medication_decoder())
}

pub fn medicationadministration_create_req(
  resource: r4b.Medicationadministration,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.medicationadministration_to_json(resource),
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
  resource: r4b.Medicationadministration,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.medicationadministration_to_json(resource),
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
) -> Result(r4b.Medicationadministration, Err) {
  any_resp(resp, r4b.medicationadministration_decoder())
}

pub fn medicationdispense_create_req(
  resource: r4b.Medicationdispense,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.medicationdispense_to_json(resource),
    "MedicationDispense",
    client,
  )
}

pub fn medicationdispense_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "MedicationDispense", client)
}

pub fn medicationdispense_update_req(
  resource: r4b.Medicationdispense,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.medicationdispense_to_json(resource),
    "MedicationDispense",
    client,
  )
}

pub fn medicationdispense_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "MedicationDispense", client)
}

pub fn medicationdispense_resp(
  resp: Response(String),
) -> Result(r4b.Medicationdispense, Err) {
  any_resp(resp, r4b.medicationdispense_decoder())
}

pub fn medicationknowledge_create_req(
  resource: r4b.Medicationknowledge,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.medicationknowledge_to_json(resource),
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
  resource: r4b.Medicationknowledge,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.medicationknowledge_to_json(resource),
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
) -> Result(r4b.Medicationknowledge, Err) {
  any_resp(resp, r4b.medicationknowledge_decoder())
}

pub fn medicationrequest_create_req(
  resource: r4b.Medicationrequest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.medicationrequest_to_json(resource),
    "MedicationRequest",
    client,
  )
}

pub fn medicationrequest_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "MedicationRequest", client)
}

pub fn medicationrequest_update_req(
  resource: r4b.Medicationrequest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.medicationrequest_to_json(resource),
    "MedicationRequest",
    client,
  )
}

pub fn medicationrequest_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "MedicationRequest", client)
}

pub fn medicationrequest_resp(
  resp: Response(String),
) -> Result(r4b.Medicationrequest, Err) {
  any_resp(resp, r4b.medicationrequest_decoder())
}

pub fn medicationstatement_create_req(
  resource: r4b.Medicationstatement,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.medicationstatement_to_json(resource),
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
  resource: r4b.Medicationstatement,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.medicationstatement_to_json(resource),
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
) -> Result(r4b.Medicationstatement, Err) {
  any_resp(resp, r4b.medicationstatement_decoder())
}

pub fn medicinalproductdefinition_create_req(
  resource: r4b.Medicinalproductdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.medicinalproductdefinition_to_json(resource),
    "MedicinalProductDefinition",
    client,
  )
}

pub fn medicinalproductdefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "MedicinalProductDefinition", client)
}

pub fn medicinalproductdefinition_update_req(
  resource: r4b.Medicinalproductdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.medicinalproductdefinition_to_json(resource),
    "MedicinalProductDefinition",
    client,
  )
}

pub fn medicinalproductdefinition_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "MedicinalProductDefinition", client)
}

pub fn medicinalproductdefinition_resp(
  resp: Response(String),
) -> Result(r4b.Medicinalproductdefinition, Err) {
  any_resp(resp, r4b.medicinalproductdefinition_decoder())
}

pub fn messagedefinition_create_req(
  resource: r4b.Messagedefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.messagedefinition_to_json(resource),
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
  resource: r4b.Messagedefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.messagedefinition_to_json(resource),
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
) -> Result(r4b.Messagedefinition, Err) {
  any_resp(resp, r4b.messagedefinition_decoder())
}

pub fn messageheader_create_req(
  resource: r4b.Messageheader,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.messageheader_to_json(resource), "MessageHeader", client)
}

pub fn messageheader_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "MessageHeader", client)
}

pub fn messageheader_update_req(
  resource: r4b.Messageheader,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.messageheader_to_json(resource),
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
) -> Result(r4b.Messageheader, Err) {
  any_resp(resp, r4b.messageheader_decoder())
}

pub fn molecularsequence_create_req(
  resource: r4b.Molecularsequence,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.molecularsequence_to_json(resource),
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
  resource: r4b.Molecularsequence,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.molecularsequence_to_json(resource),
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
) -> Result(r4b.Molecularsequence, Err) {
  any_resp(resp, r4b.molecularsequence_decoder())
}

pub fn namingsystem_create_req(
  resource: r4b.Namingsystem,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.namingsystem_to_json(resource), "NamingSystem", client)
}

pub fn namingsystem_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "NamingSystem", client)
}

pub fn namingsystem_update_req(
  resource: r4b.Namingsystem,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.namingsystem_to_json(resource),
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
) -> Result(r4b.Namingsystem, Err) {
  any_resp(resp, r4b.namingsystem_decoder())
}

pub fn nutritionorder_create_req(
  resource: r4b.Nutritionorder,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.nutritionorder_to_json(resource), "NutritionOrder", client)
}

pub fn nutritionorder_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "NutritionOrder", client)
}

pub fn nutritionorder_update_req(
  resource: r4b.Nutritionorder,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.nutritionorder_to_json(resource),
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
) -> Result(r4b.Nutritionorder, Err) {
  any_resp(resp, r4b.nutritionorder_decoder())
}

pub fn nutritionproduct_create_req(
  resource: r4b.Nutritionproduct,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.nutritionproduct_to_json(resource),
    "NutritionProduct",
    client,
  )
}

pub fn nutritionproduct_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "NutritionProduct", client)
}

pub fn nutritionproduct_update_req(
  resource: r4b.Nutritionproduct,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.nutritionproduct_to_json(resource),
    "NutritionProduct",
    client,
  )
}

pub fn nutritionproduct_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "NutritionProduct", client)
}

pub fn nutritionproduct_resp(
  resp: Response(String),
) -> Result(r4b.Nutritionproduct, Err) {
  any_resp(resp, r4b.nutritionproduct_decoder())
}

pub fn observation_create_req(
  resource: r4b.Observation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.observation_to_json(resource), "Observation", client)
}

pub fn observation_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Observation", client)
}

pub fn observation_update_req(
  resource: r4b.Observation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.observation_to_json(resource),
    "Observation",
    client,
  )
}

pub fn observation_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Observation", client)
}

pub fn observation_resp(resp: Response(String)) -> Result(r4b.Observation, Err) {
  any_resp(resp, r4b.observation_decoder())
}

pub fn observationdefinition_create_req(
  resource: r4b.Observationdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.observationdefinition_to_json(resource),
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
  resource: r4b.Observationdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.observationdefinition_to_json(resource),
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
) -> Result(r4b.Observationdefinition, Err) {
  any_resp(resp, r4b.observationdefinition_decoder())
}

pub fn operationdefinition_create_req(
  resource: r4b.Operationdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.operationdefinition_to_json(resource),
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
  resource: r4b.Operationdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.operationdefinition_to_json(resource),
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
) -> Result(r4b.Operationdefinition, Err) {
  any_resp(resp, r4b.operationdefinition_decoder())
}

pub fn operationoutcome_create_req(
  resource: r4b.Operationoutcome,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.operationoutcome_to_json(resource),
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
  resource: r4b.Operationoutcome,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.operationoutcome_to_json(resource),
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
) -> Result(r4b.Operationoutcome, Err) {
  any_resp(resp, r4b.operationoutcome_decoder())
}

pub fn organization_create_req(
  resource: r4b.Organization,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.organization_to_json(resource), "Organization", client)
}

pub fn organization_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Organization", client)
}

pub fn organization_update_req(
  resource: r4b.Organization,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.organization_to_json(resource),
    "Organization",
    client,
  )
}

pub fn organization_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Organization", client)
}

pub fn organization_resp(
  resp: Response(String),
) -> Result(r4b.Organization, Err) {
  any_resp(resp, r4b.organization_decoder())
}

pub fn organizationaffiliation_create_req(
  resource: r4b.Organizationaffiliation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.organizationaffiliation_to_json(resource),
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
  resource: r4b.Organizationaffiliation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.organizationaffiliation_to_json(resource),
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
) -> Result(r4b.Organizationaffiliation, Err) {
  any_resp(resp, r4b.organizationaffiliation_decoder())
}

pub fn packagedproductdefinition_create_req(
  resource: r4b.Packagedproductdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.packagedproductdefinition_to_json(resource),
    "PackagedProductDefinition",
    client,
  )
}

pub fn packagedproductdefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "PackagedProductDefinition", client)
}

pub fn packagedproductdefinition_update_req(
  resource: r4b.Packagedproductdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.packagedproductdefinition_to_json(resource),
    "PackagedProductDefinition",
    client,
  )
}

pub fn packagedproductdefinition_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "PackagedProductDefinition", client)
}

pub fn packagedproductdefinition_resp(
  resp: Response(String),
) -> Result(r4b.Packagedproductdefinition, Err) {
  any_resp(resp, r4b.packagedproductdefinition_decoder())
}

pub fn patient_create_req(
  resource: r4b.Patient,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.patient_to_json(resource), "Patient", client)
}

pub fn patient_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Patient", client)
}

pub fn patient_update_req(
  resource: r4b.Patient,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4b.patient_to_json(resource), "Patient", client)
}

pub fn patient_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Patient", client)
}

pub fn patient_resp(resp: Response(String)) -> Result(r4b.Patient, Err) {
  any_resp(resp, r4b.patient_decoder())
}

pub fn paymentnotice_create_req(
  resource: r4b.Paymentnotice,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.paymentnotice_to_json(resource), "PaymentNotice", client)
}

pub fn paymentnotice_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "PaymentNotice", client)
}

pub fn paymentnotice_update_req(
  resource: r4b.Paymentnotice,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.paymentnotice_to_json(resource),
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
) -> Result(r4b.Paymentnotice, Err) {
  any_resp(resp, r4b.paymentnotice_decoder())
}

pub fn paymentreconciliation_create_req(
  resource: r4b.Paymentreconciliation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.paymentreconciliation_to_json(resource),
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
  resource: r4b.Paymentreconciliation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.paymentreconciliation_to_json(resource),
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
) -> Result(r4b.Paymentreconciliation, Err) {
  any_resp(resp, r4b.paymentreconciliation_decoder())
}

pub fn person_create_req(
  resource: r4b.Person,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.person_to_json(resource), "Person", client)
}

pub fn person_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Person", client)
}

pub fn person_update_req(
  resource: r4b.Person,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4b.person_to_json(resource), "Person", client)
}

pub fn person_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Person", client)
}

pub fn person_resp(resp: Response(String)) -> Result(r4b.Person, Err) {
  any_resp(resp, r4b.person_decoder())
}

pub fn plandefinition_create_req(
  resource: r4b.Plandefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.plandefinition_to_json(resource), "PlanDefinition", client)
}

pub fn plandefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "PlanDefinition", client)
}

pub fn plandefinition_update_req(
  resource: r4b.Plandefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.plandefinition_to_json(resource),
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
) -> Result(r4b.Plandefinition, Err) {
  any_resp(resp, r4b.plandefinition_decoder())
}

pub fn practitioner_create_req(
  resource: r4b.Practitioner,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.practitioner_to_json(resource), "Practitioner", client)
}

pub fn practitioner_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Practitioner", client)
}

pub fn practitioner_update_req(
  resource: r4b.Practitioner,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.practitioner_to_json(resource),
    "Practitioner",
    client,
  )
}

pub fn practitioner_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Practitioner", client)
}

pub fn practitioner_resp(
  resp: Response(String),
) -> Result(r4b.Practitioner, Err) {
  any_resp(resp, r4b.practitioner_decoder())
}

pub fn practitionerrole_create_req(
  resource: r4b.Practitionerrole,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.practitionerrole_to_json(resource),
    "PractitionerRole",
    client,
  )
}

pub fn practitionerrole_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "PractitionerRole", client)
}

pub fn practitionerrole_update_req(
  resource: r4b.Practitionerrole,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.practitionerrole_to_json(resource),
    "PractitionerRole",
    client,
  )
}

pub fn practitionerrole_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "PractitionerRole", client)
}

pub fn practitionerrole_resp(
  resp: Response(String),
) -> Result(r4b.Practitionerrole, Err) {
  any_resp(resp, r4b.practitionerrole_decoder())
}

pub fn procedure_create_req(
  resource: r4b.Procedure,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.procedure_to_json(resource), "Procedure", client)
}

pub fn procedure_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Procedure", client)
}

pub fn procedure_update_req(
  resource: r4b.Procedure,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.procedure_to_json(resource),
    "Procedure",
    client,
  )
}

pub fn procedure_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Procedure", client)
}

pub fn procedure_resp(resp: Response(String)) -> Result(r4b.Procedure, Err) {
  any_resp(resp, r4b.procedure_decoder())
}

pub fn provenance_create_req(
  resource: r4b.Provenance,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.provenance_to_json(resource), "Provenance", client)
}

pub fn provenance_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Provenance", client)
}

pub fn provenance_update_req(
  resource: r4b.Provenance,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.provenance_to_json(resource),
    "Provenance",
    client,
  )
}

pub fn provenance_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Provenance", client)
}

pub fn provenance_resp(resp: Response(String)) -> Result(r4b.Provenance, Err) {
  any_resp(resp, r4b.provenance_decoder())
}

pub fn questionnaire_create_req(
  resource: r4b.Questionnaire,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.questionnaire_to_json(resource), "Questionnaire", client)
}

pub fn questionnaire_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Questionnaire", client)
}

pub fn questionnaire_update_req(
  resource: r4b.Questionnaire,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.questionnaire_to_json(resource),
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
) -> Result(r4b.Questionnaire, Err) {
  any_resp(resp, r4b.questionnaire_decoder())
}

pub fn questionnaireresponse_create_req(
  resource: r4b.Questionnaireresponse,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    client,
  )
}

pub fn questionnaireresponse_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "QuestionnaireResponse", client)
}

pub fn questionnaireresponse_update_req(
  resource: r4b.Questionnaireresponse,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    client,
  )
}

pub fn questionnaireresponse_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "QuestionnaireResponse", client)
}

pub fn questionnaireresponse_resp(
  resp: Response(String),
) -> Result(r4b.Questionnaireresponse, Err) {
  any_resp(resp, r4b.questionnaireresponse_decoder())
}

pub fn regulatedauthorization_create_req(
  resource: r4b.Regulatedauthorization,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.regulatedauthorization_to_json(resource),
    "RegulatedAuthorization",
    client,
  )
}

pub fn regulatedauthorization_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "RegulatedAuthorization", client)
}

pub fn regulatedauthorization_update_req(
  resource: r4b.Regulatedauthorization,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.regulatedauthorization_to_json(resource),
    "RegulatedAuthorization",
    client,
  )
}

pub fn regulatedauthorization_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "RegulatedAuthorization", client)
}

pub fn regulatedauthorization_resp(
  resp: Response(String),
) -> Result(r4b.Regulatedauthorization, Err) {
  any_resp(resp, r4b.regulatedauthorization_decoder())
}

pub fn relatedperson_create_req(
  resource: r4b.Relatedperson,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.relatedperson_to_json(resource), "RelatedPerson", client)
}

pub fn relatedperson_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "RelatedPerson", client)
}

pub fn relatedperson_update_req(
  resource: r4b.Relatedperson,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.relatedperson_to_json(resource),
    "RelatedPerson",
    client,
  )
}

pub fn relatedperson_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "RelatedPerson", client)
}

pub fn relatedperson_resp(
  resp: Response(String),
) -> Result(r4b.Relatedperson, Err) {
  any_resp(resp, r4b.relatedperson_decoder())
}

pub fn requestgroup_create_req(
  resource: r4b.Requestgroup,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.requestgroup_to_json(resource), "RequestGroup", client)
}

pub fn requestgroup_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "RequestGroup", client)
}

pub fn requestgroup_update_req(
  resource: r4b.Requestgroup,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.requestgroup_to_json(resource),
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
) -> Result(r4b.Requestgroup, Err) {
  any_resp(resp, r4b.requestgroup_decoder())
}

pub fn researchdefinition_create_req(
  resource: r4b.Researchdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.researchdefinition_to_json(resource),
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
  resource: r4b.Researchdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.researchdefinition_to_json(resource),
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
) -> Result(r4b.Researchdefinition, Err) {
  any_resp(resp, r4b.researchdefinition_decoder())
}

pub fn researchelementdefinition_create_req(
  resource: r4b.Researchelementdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.researchelementdefinition_to_json(resource),
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
  resource: r4b.Researchelementdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.researchelementdefinition_to_json(resource),
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
) -> Result(r4b.Researchelementdefinition, Err) {
  any_resp(resp, r4b.researchelementdefinition_decoder())
}

pub fn researchstudy_create_req(
  resource: r4b.Researchstudy,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.researchstudy_to_json(resource), "ResearchStudy", client)
}

pub fn researchstudy_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "ResearchStudy", client)
}

pub fn researchstudy_update_req(
  resource: r4b.Researchstudy,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.researchstudy_to_json(resource),
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
) -> Result(r4b.Researchstudy, Err) {
  any_resp(resp, r4b.researchstudy_decoder())
}

pub fn researchsubject_create_req(
  resource: r4b.Researchsubject,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.researchsubject_to_json(resource),
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
  resource: r4b.Researchsubject,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.researchsubject_to_json(resource),
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
) -> Result(r4b.Researchsubject, Err) {
  any_resp(resp, r4b.researchsubject_decoder())
}

pub fn riskassessment_create_req(
  resource: r4b.Riskassessment,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.riskassessment_to_json(resource), "RiskAssessment", client)
}

pub fn riskassessment_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "RiskAssessment", client)
}

pub fn riskassessment_update_req(
  resource: r4b.Riskassessment,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.riskassessment_to_json(resource),
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
) -> Result(r4b.Riskassessment, Err) {
  any_resp(resp, r4b.riskassessment_decoder())
}

pub fn schedule_create_req(
  resource: r4b.Schedule,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.schedule_to_json(resource), "Schedule", client)
}

pub fn schedule_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Schedule", client)
}

pub fn schedule_update_req(
  resource: r4b.Schedule,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.schedule_to_json(resource),
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

pub fn schedule_resp(resp: Response(String)) -> Result(r4b.Schedule, Err) {
  any_resp(resp, r4b.schedule_decoder())
}

pub fn searchparameter_create_req(
  resource: r4b.Searchparameter,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.searchparameter_to_json(resource),
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
  resource: r4b.Searchparameter,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.searchparameter_to_json(resource),
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
) -> Result(r4b.Searchparameter, Err) {
  any_resp(resp, r4b.searchparameter_decoder())
}

pub fn servicerequest_create_req(
  resource: r4b.Servicerequest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.servicerequest_to_json(resource), "ServiceRequest", client)
}

pub fn servicerequest_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "ServiceRequest", client)
}

pub fn servicerequest_update_req(
  resource: r4b.Servicerequest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.servicerequest_to_json(resource),
    "ServiceRequest",
    client,
  )
}

pub fn servicerequest_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "ServiceRequest", client)
}

pub fn servicerequest_resp(
  resp: Response(String),
) -> Result(r4b.Servicerequest, Err) {
  any_resp(resp, r4b.servicerequest_decoder())
}

pub fn slot_create_req(
  resource: r4b.Slot,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.slot_to_json(resource), "Slot", client)
}

pub fn slot_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Slot", client)
}

pub fn slot_update_req(
  resource: r4b.Slot,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4b.slot_to_json(resource), "Slot", client)
}

pub fn slot_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Slot", client)
}

pub fn slot_resp(resp: Response(String)) -> Result(r4b.Slot, Err) {
  any_resp(resp, r4b.slot_decoder())
}

pub fn specimen_create_req(
  resource: r4b.Specimen,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.specimen_to_json(resource), "Specimen", client)
}

pub fn specimen_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Specimen", client)
}

pub fn specimen_update_req(
  resource: r4b.Specimen,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.specimen_to_json(resource),
    "Specimen",
    client,
  )
}

pub fn specimen_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Specimen", client)
}

pub fn specimen_resp(resp: Response(String)) -> Result(r4b.Specimen, Err) {
  any_resp(resp, r4b.specimen_decoder())
}

pub fn specimendefinition_create_req(
  resource: r4b.Specimendefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.specimendefinition_to_json(resource),
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
  resource: r4b.Specimendefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.specimendefinition_to_json(resource),
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
) -> Result(r4b.Specimendefinition, Err) {
  any_resp(resp, r4b.specimendefinition_decoder())
}

pub fn structuredefinition_create_req(
  resource: r4b.Structuredefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.structuredefinition_to_json(resource),
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
  resource: r4b.Structuredefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.structuredefinition_to_json(resource),
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
) -> Result(r4b.Structuredefinition, Err) {
  any_resp(resp, r4b.structuredefinition_decoder())
}

pub fn structuremap_create_req(
  resource: r4b.Structuremap,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.structuremap_to_json(resource), "StructureMap", client)
}

pub fn structuremap_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "StructureMap", client)
}

pub fn structuremap_update_req(
  resource: r4b.Structuremap,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.structuremap_to_json(resource),
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
) -> Result(r4b.Structuremap, Err) {
  any_resp(resp, r4b.structuremap_decoder())
}

pub fn subscription_create_req(
  resource: r4b.Subscription,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.subscription_to_json(resource), "Subscription", client)
}

pub fn subscription_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Subscription", client)
}

pub fn subscription_update_req(
  resource: r4b.Subscription,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.subscription_to_json(resource),
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
) -> Result(r4b.Subscription, Err) {
  any_resp(resp, r4b.subscription_decoder())
}

pub fn subscriptionstatus_create_req(
  resource: r4b.Subscriptionstatus,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.subscriptionstatus_to_json(resource),
    "SubscriptionStatus",
    client,
  )
}

pub fn subscriptionstatus_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "SubscriptionStatus", client)
}

pub fn subscriptionstatus_update_req(
  resource: r4b.Subscriptionstatus,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.subscriptionstatus_to_json(resource),
    "SubscriptionStatus",
    client,
  )
}

pub fn subscriptionstatus_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "SubscriptionStatus", client)
}

pub fn subscriptionstatus_resp(
  resp: Response(String),
) -> Result(r4b.Subscriptionstatus, Err) {
  any_resp(resp, r4b.subscriptionstatus_decoder())
}

pub fn subscriptiontopic_create_req(
  resource: r4b.Subscriptiontopic,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.subscriptiontopic_to_json(resource),
    "SubscriptionTopic",
    client,
  )
}

pub fn subscriptiontopic_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "SubscriptionTopic", client)
}

pub fn subscriptiontopic_update_req(
  resource: r4b.Subscriptiontopic,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.subscriptiontopic_to_json(resource),
    "SubscriptionTopic",
    client,
  )
}

pub fn subscriptiontopic_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "SubscriptionTopic", client)
}

pub fn subscriptiontopic_resp(
  resp: Response(String),
) -> Result(r4b.Subscriptiontopic, Err) {
  any_resp(resp, r4b.subscriptiontopic_decoder())
}

pub fn substance_create_req(
  resource: r4b.Substance,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.substance_to_json(resource), "Substance", client)
}

pub fn substance_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Substance", client)
}

pub fn substance_update_req(
  resource: r4b.Substance,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.substance_to_json(resource),
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

pub fn substance_resp(resp: Response(String)) -> Result(r4b.Substance, Err) {
  any_resp(resp, r4b.substance_decoder())
}

pub fn substancedefinition_create_req(
  resource: r4b.Substancedefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.substancedefinition_to_json(resource),
    "SubstanceDefinition",
    client,
  )
}

pub fn substancedefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "SubstanceDefinition", client)
}

pub fn substancedefinition_update_req(
  resource: r4b.Substancedefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.substancedefinition_to_json(resource),
    "SubstanceDefinition",
    client,
  )
}

pub fn substancedefinition_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "SubstanceDefinition", client)
}

pub fn substancedefinition_resp(
  resp: Response(String),
) -> Result(r4b.Substancedefinition, Err) {
  any_resp(resp, r4b.substancedefinition_decoder())
}

pub fn supplydelivery_create_req(
  resource: r4b.Supplydelivery,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.supplydelivery_to_json(resource), "SupplyDelivery", client)
}

pub fn supplydelivery_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "SupplyDelivery", client)
}

pub fn supplydelivery_update_req(
  resource: r4b.Supplydelivery,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.supplydelivery_to_json(resource),
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
) -> Result(r4b.Supplydelivery, Err) {
  any_resp(resp, r4b.supplydelivery_decoder())
}

pub fn supplyrequest_create_req(
  resource: r4b.Supplyrequest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.supplyrequest_to_json(resource), "SupplyRequest", client)
}

pub fn supplyrequest_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "SupplyRequest", client)
}

pub fn supplyrequest_update_req(
  resource: r4b.Supplyrequest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.supplyrequest_to_json(resource),
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
) -> Result(r4b.Supplyrequest, Err) {
  any_resp(resp, r4b.supplyrequest_decoder())
}

pub fn task_create_req(
  resource: r4b.Task,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.task_to_json(resource), "Task", client)
}

pub fn task_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Task", client)
}

pub fn task_update_req(
  resource: r4b.Task,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4b.task_to_json(resource), "Task", client)
}

pub fn task_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Task", client)
}

pub fn task_resp(resp: Response(String)) -> Result(r4b.Task, Err) {
  any_resp(resp, r4b.task_decoder())
}

pub fn terminologycapabilities_create_req(
  resource: r4b.Terminologycapabilities,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.terminologycapabilities_to_json(resource),
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
  resource: r4b.Terminologycapabilities,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.terminologycapabilities_to_json(resource),
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
) -> Result(r4b.Terminologycapabilities, Err) {
  any_resp(resp, r4b.terminologycapabilities_decoder())
}

pub fn testreport_create_req(
  resource: r4b.Testreport,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.testreport_to_json(resource), "TestReport", client)
}

pub fn testreport_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "TestReport", client)
}

pub fn testreport_update_req(
  resource: r4b.Testreport,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.testreport_to_json(resource),
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

pub fn testreport_resp(resp: Response(String)) -> Result(r4b.Testreport, Err) {
  any_resp(resp, r4b.testreport_decoder())
}

pub fn testscript_create_req(
  resource: r4b.Testscript,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.testscript_to_json(resource), "TestScript", client)
}

pub fn testscript_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "TestScript", client)
}

pub fn testscript_update_req(
  resource: r4b.Testscript,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.testscript_to_json(resource),
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

pub fn testscript_resp(resp: Response(String)) -> Result(r4b.Testscript, Err) {
  any_resp(resp, r4b.testscript_decoder())
}

pub fn valueset_create_req(
  resource: r4b.Valueset,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.valueset_to_json(resource), "ValueSet", client)
}

pub fn valueset_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "ValueSet", client)
}

pub fn valueset_update_req(
  resource: r4b.Valueset,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.valueset_to_json(resource),
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

pub fn valueset_resp(resp: Response(String)) -> Result(r4b.Valueset, Err) {
  any_resp(resp, r4b.valueset_decoder())
}

pub fn verificationresult_create_req(
  resource: r4b.Verificationresult,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.verificationresult_to_json(resource),
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
  resource: r4b.Verificationresult,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.verificationresult_to_json(resource),
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
) -> Result(r4b.Verificationresult, Err) {
  any_resp(resp, r4b.verificationresult_decoder())
}

pub fn visionprescription_create_req(
  resource: r4b.Visionprescription,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4b.visionprescription_to_json(resource),
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
  resource: r4b.Visionprescription,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.visionprescription_to_json(resource),
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
) -> Result(r4b.Visionprescription, Err) {
  any_resp(resp, r4b.visionprescription_decoder())
}

pub type SpAccount {
  SpAccount(
    owner: Option(String),
    identifier: Option(String),
    period: Option(String),
    patient: Option(String),
    subject: Option(String),
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

pub type SpAllergyintolerance {
  SpAllergyintolerance(
    date: Option(String),
    severity: Option(String),
    identifier: Option(String),
    manifestation: Option(String),
    recorder: Option(String),
    code: Option(String),
    verification_status: Option(String),
    criticality: Option(String),
    clinical_status: Option(String),
    onset: Option(String),
    type_: Option(String),
    asserter: Option(String),
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
    message: Option(String),
    type_: Option(String),
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
    performer: Option(String),
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
    activity_date: Option(String),
    instantiates_uri: Option(String),
    category: Option(String),
    activity_code: Option(String),
    status: Option(String),
  )
}

pub type SpCareteam {
  SpCareteam(
    date: Option(String),
    identifier: Option(String),
    patient: Option(String),
    subject: Option(String),
    encounter: Option(String),
    category: Option(String),
    participant: Option(String),
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
    factor_override: Option(String),
    patient: Option(String),
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

pub type SpCitation {
  SpCitation(
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
    name: Option(String),
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
    context: Option(String),
    name: Option(String),
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
    part_of: Option(String),
    received: Option(String),
    encounter: Option(String),
    medium: Option(String),
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
    related_id: Option(String),
    author: Option(String),
    subject: Option(String),
    confidentiality: Option(String),
    section: Option(String),
    encounter: Option(String),
    title: Option(String),
    type_: Option(String),
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
    dependson: Option(String),
    target_system: Option(String),
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

pub type SpCondition {
  SpCondition(
    evidence_detail: Option(String),
    severity: Option(String),
    identifier: Option(String),
    onset_info: Option(String),
    recorded_date: Option(String),
    code: Option(String),
    evidence: Option(String),
    subject: Option(String),
    verification_status: Option(String),
    clinical_status: Option(String),
    encounter: Option(String),
    onset_date: Option(String),
    abatement_date: Option(String),
    asserter: Option(String),
    stage: Option(String),
    abatement_string: Option(String),
    patient: Option(String),
    abatement_age: Option(String),
    onset_age: Option(String),
    body_site: Option(String),
    category: Option(String),
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

pub type SpCoverage {
  SpCoverage(
    identifier: Option(String),
    payor: Option(String),
    subscriber: Option(String),
    beneficiary: Option(String),
    patient: Option(String),
    class_value: Option(String),
    type_: Option(String),
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
    patient: Option(String),
    implicated: Option(String),
  )
}

pub type SpDevice {
  SpDevice(
    udi_di: Option(String),
    identifier: Option(String),
    udi_carrier: Option(String),
    device_name: Option(String),
    patient: Option(String),
    organization: Option(String),
    location: Option(String),
    model: Option(String),
    type_: Option(String),
    url: Option(String),
    manufacturer: Option(String),
    status: Option(String),
  )
}

pub type SpDevicedefinition {
  SpDevicedefinition(
    identifier: Option(String),
    parent: Option(String),
    type_: Option(String),
  )
}

pub type SpDevicemetric {
  SpDevicemetric(
    identifier: Option(String),
    parent: Option(String),
    source: Option(String),
    category: Option(String),
    type_: Option(String),
  )
}

pub type SpDevicerequest {
  SpDevicerequest(
    insurance: Option(String),
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

pub type SpDeviceusestatement {
  SpDeviceusestatement(
    identifier: Option(String),
    patient: Option(String),
    subject: Option(String),
    device: Option(String),
  )
}

pub type SpDiagnosticreport {
  SpDiagnosticreport(
    date: Option(String),
    identifier: Option(String),
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

pub type SpDocumentmanifest {
  SpDocumentmanifest(
    identifier: Option(String),
    item: Option(String),
    related_id: Option(String),
    author: Option(String),
    created: Option(String),
    subject: Option(String),
    description: Option(String),
    source: Option(String),
    type_: Option(String),
    related_ref: Option(String),
    patient: Option(String),
    recipient: Option(String),
    status: Option(String),
  )
}

pub type SpDocumentreference {
  SpDocumentreference(
    date: Option(String),
    subject: Option(String),
    description: Option(String),
    language: Option(String),
    type_: Option(String),
    relation: Option(String),
    setting: Option(String),
    related: Option(String),
    patient: Option(String),
    event: Option(String),
    relationship: Option(String),
    authenticator: Option(String),
    identifier: Option(String),
    period: Option(String),
    custodian: Option(String),
    author: Option(String),
    format: Option(String),
    encounter: Option(String),
    contenttype: Option(String),
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
    identifier: Option(String),
    participant_type: Option(String),
    practitioner: Option(String),
    subject: Option(String),
    episode_of_care: Option(String),
    length: Option(String),
    diagnosis: Option(String),
    appointment: Option(String),
    part_of: Option(String),
    type_: Option(String),
    participant: Option(String),
    reason_code: Option(String),
    based_on: Option(String),
    patient: Option(String),
    reason_reference: Option(String),
    location_period: Option(String),
    location: Option(String),
    service_provider: Option(String),
    special_arrangement: Option(String),
    class: Option(String),
    account: Option(String),
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
    condition: Option(String),
    patient: Option(String),
    organization: Option(String),
    type_: Option(String),
    care_manager: Option(String),
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
    context_type_value: Option(String),
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
  )
}

pub type SpGoal {
  SpGoal(
    identifier: Option(String),
    lifecycle_status: Option(String),
    achievement_status: Option(String),
    patient: Option(String),
    subject: Option(String),
    start_date: Option(String),
    category: Option(String),
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
    context: Option(String),
    name: Option(String),
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
    identifier: Option(String),
    request: Option(String),
    patient: Option(String),
    subject: Option(String),
  )
}

pub type SpHealthcareservice {
  SpHealthcareservice(
    identifier: Option(String),
    endpoint: Option(String),
    specialty: Option(String),
    service_category: Option(String),
    coverage_area: Option(String),
    organization: Option(String),
    service_type: Option(String),
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
    bodysite: Option(String),
    instance: Option(String),
    modality: Option(String),
    performer: Option(String),
    subject: Option(String),
    interpreter: Option(String),
    started: Option(String),
    encounter: Option(String),
    referrer: Option(String),
    endpoint: Option(String),
    patient: Option(String),
    series: Option(String),
    basedon: Option(String),
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
    substance_definition: Option(String),
    identifier: Option(String),
    role: Option(String),
    function: Option(String),
    substance: Option(String),
    for: Option(String),
    substance_code: Option(String),
    manufacturer: Option(String),
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
    address_country: Option(String),
    endpoint: Option(String),
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
    dose_form: Option(String),
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
    evaluated_resource: Option(String),
    status: Option(String),
  )
}

pub type SpMedia {
  SpMedia(
    identifier: Option(String),
    modality: Option(String),
    created: Option(String),
    subject: Option(String),
    encounter: Option(String),
    type_: Option(String),
    operator: Option(String),
    site: Option(String),
    view: Option(String),
    based_on: Option(String),
    patient: Option(String),
    device: Option(String),
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
    expiration_date: Option(String),
    manufacturer: Option(String),
    status: Option(String),
  )
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
    effective_time: Option(String),
    patient: Option(String),
    context: Option(String),
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
    type_: Option(String),
    whenhandedover: Option(String),
    whenprepared: Option(String),
    prescription: Option(String),
    patient: Option(String),
    context: Option(String),
    status: Option(String),
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
    monitoring_program_name: Option(String),
    monograph: Option(String),
    monitoring_program_type: Option(String),
    status: Option(String),
  )
}

pub type SpMedicationrequest {
  SpMedicationrequest(
    date: Option(String),
    requester: Option(String),
    identifier: Option(String),
    intended_dispenser: Option(String),
    authoredon: Option(String),
    code: Option(String),
    subject: Option(String),
    medication: Option(String),
    encounter: Option(String),
    priority: Option(String),
    intent: Option(String),
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
    patient: Option(String),
    subject: Option(String),
    context: Option(String),
    medication: Option(String),
    part_of: Option(String),
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
    author: Option(String),
    destination: Option(String),
    focus: Option(String),
    source: Option(String),
    target: Option(String),
    destination_uri: Option(String),
    sender: Option(String),
    source_uri: Option(String),
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
    type_: Option(String),
    window_end: Option(String),
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
    contact: Option(String),
    responsible: Option(String),
    context: Option(String),
    name: Option(String),
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
    additive: Option(String),
    status: Option(String),
  )
}

pub type SpNutritionproduct {
  SpNutritionproduct(identifier: Option(String), status: Option(String))
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
    has_member: Option(String),
    code_value_string: Option(String),
    component_code_value_quantity: Option(String),
    based_on: Option(String),
    code_value_date: Option(String),
    patient: Option(String),
    specimen: Option(String),
    code_value_quantity: Option(String),
    component_code: Option(String),
    combo_code_value_concept: Option(String),
    value_string: Option(String),
    identifier: Option(String),
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
    outcome: Option(String),
    payment_issuer: Option(String),
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
    address_use: Option(String),
    name: Option(String),
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
    address_state: Option(String),
    gender: Option(String),
    active: Option(String),
    address_postalcode: Option(String),
    address_country: Option(String),
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
    endpoint: Option(String),
    phone: Option(String),
    service: Option(String),
    organization: Option(String),
    location: Option(String),
    telecom: Option(String),
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
    patient: Option(String),
    location: Option(String),
    agent_role: Option(String),
    recorded: Option(String),
    when: Option(String),
    entity: Option(String),
    target: Option(String),
  )
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
    context: Option(String),
    name: Option(String),
    publisher: Option(String),
    definition: Option(String),
    context_type_quantity: Option(String),
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
    relationship: Option(String),
    email: Option(String),
  )
}

pub type SpRequestgroup {
  SpRequestgroup(
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

pub type SpResearchelementdefinition {
  SpResearchelementdefinition(
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
    active: Option(String),
  )
}

pub type SpSearchparameter {
  SpSearchparameter(
    date: Option(String),
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
    code: Option(String),
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
    based_on: Option(String),
    patient: Option(String),
    specimen: Option(String),
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
    status: Option(String),
  )
}

pub type SpSpecimen {
  SpSpecimen(
    container: Option(String),
    container_id: Option(String),
    identifier: Option(String),
    parent: Option(String),
    bodysite: Option(String),
    patient: Option(String),
    subject: Option(String),
    collected: Option(String),
    accession: Option(String),
    type_: Option(String),
    collector: Option(String),
    status: Option(String),
  )
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
    base_path: Option(String),
    context: Option(String),
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
    payload: Option(String),
    criteria: Option(String),
    contact: Option(String),
    type_: Option(String),
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
    identifier: Option(String),
    resource: Option(String),
    derived_or_self: Option(String),
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
    container_identifier: Option(String),
    code: Option(String),
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
    context: Option(String),
    name: Option(String),
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
    context: Option(String),
    name: Option(String),
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
    context: Option(String),
    name: Option(String),
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
    None,
    None,
  )
}

pub fn sp_careteam_new() {
  SpCareteam(None, None, None, None, None, None, None, None)
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

pub fn sp_coverage_new() {
  SpCoverage(None, None, None, None, None, None, None, None, None, None, None)
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
  )
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
  )
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
  )
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
  SpFlag(None, None, None, None, None, None)
}

pub fn sp_goal_new() {
  SpGoal(None, None, None, None, None, None, None, None)
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
  )
}

pub fn sp_ingredient_new() {
  SpIngredient(None, None, None, None, None, None, None, None)
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
  )
}

pub fn sp_manufactureditemdefinition_new() {
  SpManufactureditemdefinition(None, None, None)
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

pub fn sp_medication_new() {
  SpMedication(None, None, None, None, None, None, None, None, None)
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

pub fn sp_nutritionproduct_new() {
  SpNutritionproduct(None, None)
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
  )
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
  )
}

pub fn sp_provenance_new() {
  SpProvenance(None, None, None, None, None, None, None, None, None, None)
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
  )
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
  )
}

pub fn sp_slot_new() {
  SpSlot(None, None, None, None, None, None, None, None)
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

pub fn sp_subscriptionstatus_new() {
  SpSubscriptionstatus
}

pub fn sp_subscriptiontopic_new() {
  SpSubscriptiontopic(None, None, None, None, None, None, None, None, None)
}

pub fn sp_substance_new() {
  SpSubstance(None, None, None, None, None, None, None, None)
}

pub fn sp_substancedefinition_new() {
  SpSubstancedefinition(None, None, None, None, None)
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
    inc_careplan: Option(SpInclude),
    revinc_careplan: Option(SpInclude),
    inc_careteam: Option(SpInclude),
    revinc_careteam: Option(SpInclude),
    inc_catalogentry: Option(SpInclude),
    revinc_catalogentry: Option(SpInclude),
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
    inc_devicedefinition: Option(SpInclude),
    revinc_devicedefinition: Option(SpInclude),
    inc_devicemetric: Option(SpInclude),
    revinc_devicemetric: Option(SpInclude),
    inc_devicerequest: Option(SpInclude),
    revinc_devicerequest: Option(SpInclude),
    inc_deviceusestatement: Option(SpInclude),
    revinc_deviceusestatement: Option(SpInclude),
    inc_diagnosticreport: Option(SpInclude),
    revinc_diagnosticreport: Option(SpInclude),
    inc_documentmanifest: Option(SpInclude),
    revinc_documentmanifest: Option(SpInclude),
    inc_documentreference: Option(SpInclude),
    revinc_documentreference: Option(SpInclude),
    inc_encounter: Option(SpInclude),
    revinc_encounter: Option(SpInclude),
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
    inc_media: Option(SpInclude),
    revinc_media: Option(SpInclude),
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
    account: List(r4b.Account),
    activitydefinition: List(r4b.Activitydefinition),
    administrableproductdefinition: List(r4b.Administrableproductdefinition),
    adverseevent: List(r4b.Adverseevent),
    allergyintolerance: List(r4b.Allergyintolerance),
    appointment: List(r4b.Appointment),
    appointmentresponse: List(r4b.Appointmentresponse),
    auditevent: List(r4b.Auditevent),
    basic: List(r4b.Basic),
    binary: List(r4b.Binary),
    biologicallyderivedproduct: List(r4b.Biologicallyderivedproduct),
    bodystructure: List(r4b.Bodystructure),
    bundle: List(r4b.Bundle),
    capabilitystatement: List(r4b.Capabilitystatement),
    careplan: List(r4b.Careplan),
    careteam: List(r4b.Careteam),
    catalogentry: List(r4b.Catalogentry),
    chargeitem: List(r4b.Chargeitem),
    chargeitemdefinition: List(r4b.Chargeitemdefinition),
    citation: List(r4b.Citation),
    claim: List(r4b.Claim),
    claimresponse: List(r4b.Claimresponse),
    clinicalimpression: List(r4b.Clinicalimpression),
    clinicalusedefinition: List(r4b.Clinicalusedefinition),
    codesystem: List(r4b.Codesystem),
    communication: List(r4b.Communication),
    communicationrequest: List(r4b.Communicationrequest),
    compartmentdefinition: List(r4b.Compartmentdefinition),
    composition: List(r4b.Composition),
    conceptmap: List(r4b.Conceptmap),
    condition: List(r4b.Condition),
    consent: List(r4b.Consent),
    contract: List(r4b.Contract),
    coverage: List(r4b.Coverage),
    coverageeligibilityrequest: List(r4b.Coverageeligibilityrequest),
    coverageeligibilityresponse: List(r4b.Coverageeligibilityresponse),
    detectedissue: List(r4b.Detectedissue),
    device: List(r4b.Device),
    devicedefinition: List(r4b.Devicedefinition),
    devicemetric: List(r4b.Devicemetric),
    devicerequest: List(r4b.Devicerequest),
    deviceusestatement: List(r4b.Deviceusestatement),
    diagnosticreport: List(r4b.Diagnosticreport),
    documentmanifest: List(r4b.Documentmanifest),
    documentreference: List(r4b.Documentreference),
    encounter: List(r4b.Encounter),
    endpoint: List(r4b.Endpoint),
    enrollmentrequest: List(r4b.Enrollmentrequest),
    enrollmentresponse: List(r4b.Enrollmentresponse),
    episodeofcare: List(r4b.Episodeofcare),
    eventdefinition: List(r4b.Eventdefinition),
    evidence: List(r4b.Evidence),
    evidencereport: List(r4b.Evidencereport),
    evidencevariable: List(r4b.Evidencevariable),
    examplescenario: List(r4b.Examplescenario),
    explanationofbenefit: List(r4b.Explanationofbenefit),
    familymemberhistory: List(r4b.Familymemberhistory),
    flag: List(r4b.Flag),
    goal: List(r4b.Goal),
    graphdefinition: List(r4b.Graphdefinition),
    group: List(r4b.Group),
    guidanceresponse: List(r4b.Guidanceresponse),
    healthcareservice: List(r4b.Healthcareservice),
    imagingstudy: List(r4b.Imagingstudy),
    immunization: List(r4b.Immunization),
    immunizationevaluation: List(r4b.Immunizationevaluation),
    immunizationrecommendation: List(r4b.Immunizationrecommendation),
    implementationguide: List(r4b.Implementationguide),
    ingredient: List(r4b.Ingredient),
    insuranceplan: List(r4b.Insuranceplan),
    invoice: List(r4b.Invoice),
    library: List(r4b.Library),
    linkage: List(r4b.Linkage),
    listfhir: List(r4b.Listfhir),
    location: List(r4b.Location),
    manufactureditemdefinition: List(r4b.Manufactureditemdefinition),
    measure: List(r4b.Measure),
    measurereport: List(r4b.Measurereport),
    media: List(r4b.Media),
    medication: List(r4b.Medication),
    medicationadministration: List(r4b.Medicationadministration),
    medicationdispense: List(r4b.Medicationdispense),
    medicationknowledge: List(r4b.Medicationknowledge),
    medicationrequest: List(r4b.Medicationrequest),
    medicationstatement: List(r4b.Medicationstatement),
    medicinalproductdefinition: List(r4b.Medicinalproductdefinition),
    messagedefinition: List(r4b.Messagedefinition),
    messageheader: List(r4b.Messageheader),
    molecularsequence: List(r4b.Molecularsequence),
    namingsystem: List(r4b.Namingsystem),
    nutritionorder: List(r4b.Nutritionorder),
    nutritionproduct: List(r4b.Nutritionproduct),
    observation: List(r4b.Observation),
    observationdefinition: List(r4b.Observationdefinition),
    operationdefinition: List(r4b.Operationdefinition),
    operationoutcome: List(r4b.Operationoutcome),
    organization: List(r4b.Organization),
    organizationaffiliation: List(r4b.Organizationaffiliation),
    packagedproductdefinition: List(r4b.Packagedproductdefinition),
    patient: List(r4b.Patient),
    paymentnotice: List(r4b.Paymentnotice),
    paymentreconciliation: List(r4b.Paymentreconciliation),
    person: List(r4b.Person),
    plandefinition: List(r4b.Plandefinition),
    practitioner: List(r4b.Practitioner),
    practitionerrole: List(r4b.Practitionerrole),
    procedure: List(r4b.Procedure),
    provenance: List(r4b.Provenance),
    questionnaire: List(r4b.Questionnaire),
    questionnaireresponse: List(r4b.Questionnaireresponse),
    regulatedauthorization: List(r4b.Regulatedauthorization),
    relatedperson: List(r4b.Relatedperson),
    requestgroup: List(r4b.Requestgroup),
    researchdefinition: List(r4b.Researchdefinition),
    researchelementdefinition: List(r4b.Researchelementdefinition),
    researchstudy: List(r4b.Researchstudy),
    researchsubject: List(r4b.Researchsubject),
    riskassessment: List(r4b.Riskassessment),
    schedule: List(r4b.Schedule),
    searchparameter: List(r4b.Searchparameter),
    servicerequest: List(r4b.Servicerequest),
    slot: List(r4b.Slot),
    specimen: List(r4b.Specimen),
    specimendefinition: List(r4b.Specimendefinition),
    structuredefinition: List(r4b.Structuredefinition),
    structuremap: List(r4b.Structuremap),
    subscription: List(r4b.Subscription),
    subscriptionstatus: List(r4b.Subscriptionstatus),
    subscriptiontopic: List(r4b.Subscriptiontopic),
    substance: List(r4b.Substance),
    substancedefinition: List(r4b.Substancedefinition),
    supplydelivery: List(r4b.Supplydelivery),
    supplyrequest: List(r4b.Supplyrequest),
    task: List(r4b.Task),
    terminologycapabilities: List(r4b.Terminologycapabilities),
    testreport: List(r4b.Testreport),
    testscript: List(r4b.Testscript),
    valueset: List(r4b.Valueset),
    verificationresult: List(r4b.Verificationresult),
    visionprescription: List(r4b.Visionprescription),
  )
}

pub fn groupedresources_new() {
  GroupedResources(
    account: [],
    activitydefinition: [],
    administrableproductdefinition: [],
    adverseevent: [],
    allergyintolerance: [],
    appointment: [],
    appointmentresponse: [],
    auditevent: [],
    basic: [],
    binary: [],
    biologicallyderivedproduct: [],
    bodystructure: [],
    bundle: [],
    capabilitystatement: [],
    careplan: [],
    careteam: [],
    catalogentry: [],
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
    consent: [],
    contract: [],
    coverage: [],
    coverageeligibilityrequest: [],
    coverageeligibilityresponse: [],
    detectedissue: [],
    device: [],
    devicedefinition: [],
    devicemetric: [],
    devicerequest: [],
    deviceusestatement: [],
    diagnosticreport: [],
    documentmanifest: [],
    documentreference: [],
    encounter: [],
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
    goal: [],
    graphdefinition: [],
    group: [],
    guidanceresponse: [],
    healthcareservice: [],
    imagingstudy: [],
    immunization: [],
    immunizationevaluation: [],
    immunizationrecommendation: [],
    implementationguide: [],
    ingredient: [],
    insuranceplan: [],
    invoice: [],
    library: [],
    linkage: [],
    listfhir: [],
    location: [],
    manufactureditemdefinition: [],
    measure: [],
    measurereport: [],
    media: [],
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
    requestgroup: [],
    researchdefinition: [],
    researchelementdefinition: [],
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
      #("patient", sp.patient),
      #("subject", sp.subject),
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
    ])
  any_search_req(params, "AdministrableProductDefinition", client)
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

pub fn allergyintolerance_search_req(
  sp: SpAllergyintolerance,
  client: FhirClient,
) {
  let params =
    using_params([
      #("date", sp.date),
      #("severity", sp.severity),
      #("identifier", sp.identifier),
      #("manifestation", sp.manifestation),
      #("recorder", sp.recorder),
      #("code", sp.code),
      #("verification-status", sp.verification_status),
      #("criticality", sp.criticality),
      #("clinical-status", sp.clinical_status),
      #("onset", sp.onset),
      #("type", sp.type_),
      #("asserter", sp.asserter),
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
      #("performer", sp.performer),
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
      #("activity-date", sp.activity_date),
      #("instantiates-uri", sp.instantiates_uri),
      #("category", sp.category),
      #("activity-code", sp.activity_code),
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
      #("encounter", sp.encounter),
      #("category", sp.category),
      #("participant", sp.participant),
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
      #("factor-override", sp.factor_override),
      #("patient", sp.patient),
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

pub fn citation_search_req(sp: SpCitation, client: FhirClient) {
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
      #("name", sp.name),
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
      #("context-type", sp.context_type),
      #("language", sp.language),
      #("title", sp.title),
      #("version", sp.version),
      #("url", sp.url),
      #("context-quantity", sp.context_quantity),
      #("supplements", sp.supplements),
      #("system", sp.system),
      #("context", sp.context),
      #("name", sp.name),
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
      #("part-of", sp.part_of),
      #("received", sp.received),
      #("encounter", sp.encounter),
      #("medium", sp.medium),
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
      #("related-id", sp.related_id),
      #("author", sp.author),
      #("subject", sp.subject),
      #("confidentiality", sp.confidentiality),
      #("section", sp.section),
      #("encounter", sp.encounter),
      #("title", sp.title),
      #("type", sp.type_),
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
      #("dependson", sp.dependson),
      #("target-system", sp.target_system),
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
      #("subject", sp.subject),
      #("verification-status", sp.verification_status),
      #("clinical-status", sp.clinical_status),
      #("encounter", sp.encounter),
      #("onset-date", sp.onset_date),
      #("abatement-date", sp.abatement_date),
      #("asserter", sp.asserter),
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

pub fn coverage_search_req(sp: SpCoverage, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("payor", sp.payor),
      #("subscriber", sp.subscriber),
      #("beneficiary", sp.beneficiary),
      #("patient", sp.patient),
      #("class-value", sp.class_value),
      #("type", sp.type_),
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
      #("patient", sp.patient),
      #("implicated", sp.implicated),
    ])
  any_search_req(params, "DetectedIssue", client)
}

pub fn device_search_req(sp: SpDevice, client: FhirClient) {
  let params =
    using_params([
      #("udi-di", sp.udi_di),
      #("identifier", sp.identifier),
      #("udi-carrier", sp.udi_carrier),
      #("device-name", sp.device_name),
      #("patient", sp.patient),
      #("organization", sp.organization),
      #("location", sp.location),
      #("model", sp.model),
      #("type", sp.type_),
      #("url", sp.url),
      #("manufacturer", sp.manufacturer),
      #("status", sp.status),
    ])
  any_search_req(params, "Device", client)
}

pub fn devicedefinition_search_req(sp: SpDevicedefinition, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("parent", sp.parent),
      #("type", sp.type_),
    ])
  any_search_req(params, "DeviceDefinition", client)
}

pub fn devicemetric_search_req(sp: SpDevicemetric, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("parent", sp.parent),
      #("source", sp.source),
      #("category", sp.category),
      #("type", sp.type_),
    ])
  any_search_req(params, "DeviceMetric", client)
}

pub fn devicerequest_search_req(sp: SpDevicerequest, client: FhirClient) {
  let params =
    using_params([
      #("insurance", sp.insurance),
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

pub fn deviceusestatement_search_req(
  sp: SpDeviceusestatement,
  client: FhirClient,
) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("patient", sp.patient),
      #("subject", sp.subject),
      #("device", sp.device),
    ])
  any_search_req(params, "DeviceUseStatement", client)
}

pub fn diagnosticreport_search_req(sp: SpDiagnosticreport, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
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

pub fn documentmanifest_search_req(sp: SpDocumentmanifest, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("item", sp.item),
      #("related-id", sp.related_id),
      #("author", sp.author),
      #("created", sp.created),
      #("subject", sp.subject),
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

pub fn documentreference_search_req(sp: SpDocumentreference, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("subject", sp.subject),
      #("description", sp.description),
      #("language", sp.language),
      #("type", sp.type_),
      #("relation", sp.relation),
      #("setting", sp.setting),
      #("related", sp.related),
      #("patient", sp.patient),
      #("event", sp.event),
      #("relationship", sp.relationship),
      #("authenticator", sp.authenticator),
      #("identifier", sp.identifier),
      #("period", sp.period),
      #("custodian", sp.custodian),
      #("author", sp.author),
      #("format", sp.format),
      #("encounter", sp.encounter),
      #("contenttype", sp.contenttype),
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
      #("identifier", sp.identifier),
      #("participant-type", sp.participant_type),
      #("practitioner", sp.practitioner),
      #("subject", sp.subject),
      #("episode-of-care", sp.episode_of_care),
      #("length", sp.length),
      #("diagnosis", sp.diagnosis),
      #("appointment", sp.appointment),
      #("part-of", sp.part_of),
      #("type", sp.type_),
      #("participant", sp.participant),
      #("reason-code", sp.reason_code),
      #("based-on", sp.based_on),
      #("patient", sp.patient),
      #("reason-reference", sp.reason_reference),
      #("location-period", sp.location_period),
      #("location", sp.location),
      #("service-provider", sp.service_provider),
      #("special-arrangement", sp.special_arrangement),
      #("class", sp.class),
      #("account", sp.account),
      #("status", sp.status),
    ])
  any_search_req(params, "Encounter", client)
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
      #("condition", sp.condition),
      #("patient", sp.patient),
      #("organization", sp.organization),
      #("type", sp.type_),
      #("care-manager", sp.care_manager),
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
      #("context-type-value", sp.context_type_value),
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
    ])
  any_search_req(params, "Flag", client)
}

pub fn goal_search_req(sp: SpGoal, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("lifecycle-status", sp.lifecycle_status),
      #("achievement-status", sp.achievement_status),
      #("patient", sp.patient),
      #("subject", sp.subject),
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
      #("identifier", sp.identifier),
      #("request", sp.request),
      #("patient", sp.patient),
      #("subject", sp.subject),
    ])
  any_search_req(params, "GuidanceResponse", client)
}

pub fn healthcareservice_search_req(sp: SpHealthcareservice, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("endpoint", sp.endpoint),
      #("specialty", sp.specialty),
      #("service-category", sp.service_category),
      #("coverage-area", sp.coverage_area),
      #("organization", sp.organization),
      #("service-type", sp.service_type),
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
      #("bodysite", sp.bodysite),
      #("instance", sp.instance),
      #("modality", sp.modality),
      #("performer", sp.performer),
      #("subject", sp.subject),
      #("interpreter", sp.interpreter),
      #("started", sp.started),
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
      #("substance-definition", sp.substance_definition),
      #("identifier", sp.identifier),
      #("role", sp.role),
      #("function", sp.function),
      #("substance", sp.substance),
      #("for", sp.for),
      #("substance-code", sp.substance_code),
      #("manufacturer", sp.manufacturer),
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
  any_search_req(params, "Listfhir", client)
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
      #("address-country", sp.address_country),
      #("endpoint", sp.endpoint),
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
      #("dose-form", sp.dose_form),
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
      #("evaluated-resource", sp.evaluated_resource),
      #("status", sp.status),
    ])
  any_search_req(params, "MeasureReport", client)
}

pub fn media_search_req(sp: SpMedia, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("modality", sp.modality),
      #("created", sp.created),
      #("subject", sp.subject),
      #("encounter", sp.encounter),
      #("type", sp.type_),
      #("operator", sp.operator),
      #("site", sp.site),
      #("view", sp.view),
      #("based-on", sp.based_on),
      #("patient", sp.patient),
      #("device", sp.device),
      #("status", sp.status),
    ])
  any_search_req(params, "Media", client)
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
      #("expiration-date", sp.expiration_date),
      #("manufacturer", sp.manufacturer),
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
      #("identifier", sp.identifier),
      #("request", sp.request),
      #("code", sp.code),
      #("performer", sp.performer),
      #("subject", sp.subject),
      #("medication", sp.medication),
      #("reason-given", sp.reason_given),
      #("effective-time", sp.effective_time),
      #("patient", sp.patient),
      #("context", sp.context),
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
      #("type", sp.type_),
      #("whenhandedover", sp.whenhandedover),
      #("whenprepared", sp.whenprepared),
      #("prescription", sp.prescription),
      #("patient", sp.patient),
      #("context", sp.context),
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
      #("code", sp.code),
      #("ingredient", sp.ingredient),
      #("doseform", sp.doseform),
      #("classification-type", sp.classification_type),
      #("monograph-type", sp.monograph_type),
      #("classification", sp.classification),
      #("manufacturer", sp.manufacturer),
      #("ingredient-code", sp.ingredient_code),
      #("source-cost", sp.source_cost),
      #("monitoring-program-name", sp.monitoring_program_name),
      #("monograph", sp.monograph),
      #("monitoring-program-type", sp.monitoring_program_type),
      #("status", sp.status),
    ])
  any_search_req(params, "MedicationKnowledge", client)
}

pub fn medicationrequest_search_req(sp: SpMedicationrequest, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("requester", sp.requester),
      #("identifier", sp.identifier),
      #("intended-dispenser", sp.intended_dispenser),
      #("authoredon", sp.authoredon),
      #("code", sp.code),
      #("subject", sp.subject),
      #("medication", sp.medication),
      #("encounter", sp.encounter),
      #("priority", sp.priority),
      #("intent", sp.intent),
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
      #("patient", sp.patient),
      #("subject", sp.subject),
      #("context", sp.context),
      #("medication", sp.medication),
      #("part-of", sp.part_of),
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
      #("author", sp.author),
      #("destination", sp.destination),
      #("focus", sp.focus),
      #("source", sp.source),
      #("target", sp.target),
      #("destination-uri", sp.destination_uri),
      #("sender", sp.sender),
      #("source-uri", sp.source_uri),
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
      #("type", sp.type_),
      #("window-end", sp.window_end),
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
      #("contact", sp.contact),
      #("responsible", sp.responsible),
      #("context", sp.context),
      #("name", sp.name),
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
      #("additive", sp.additive),
      #("status", sp.status),
    ])
  any_search_req(params, "NutritionOrder", client)
}

pub fn nutritionproduct_search_req(sp: SpNutritionproduct, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
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
      #("has-member", sp.has_member),
      #("code-value-string", sp.code_value_string),
      #("component-code-value-quantity", sp.component_code_value_quantity),
      #("based-on", sp.based_on),
      #("code-value-date", sp.code_value_date),
      #("patient", sp.patient),
      #("specimen", sp.specimen),
      #("code-value-quantity", sp.code_value_quantity),
      #("component-code", sp.component_code),
      #("combo-code-value-concept", sp.combo_code_value_concept),
      #("value-string", sp.value_string),
      #("identifier", sp.identifier),
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
      #("outcome", sp.outcome),
      #("payment-issuer", sp.payment_issuer),
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
      #("address-use", sp.address_use),
      #("name", sp.name),
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
      #("address-state", sp.address_state),
      #("gender", sp.gender),
      #("active", sp.active),
      #("address-postalcode", sp.address_postalcode),
      #("address-country", sp.address_country),
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
      #("endpoint", sp.endpoint),
      #("phone", sp.phone),
      #("service", sp.service),
      #("organization", sp.organization),
      #("location", sp.location),
      #("telecom", sp.telecom),
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
      #("patient", sp.patient),
      #("location", sp.location),
      #("agent-role", sp.agent_role),
      #("recorded", sp.recorded),
      #("when", sp.when),
      #("entity", sp.entity),
      #("target", sp.target),
    ])
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
      #("context", sp.context),
      #("name", sp.name),
      #("publisher", sp.publisher),
      #("definition", sp.definition),
      #("context-type-quantity", sp.context_type_quantity),
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
      #("relationship", sp.relationship),
      #("email", sp.email),
    ])
  any_search_req(params, "RelatedPerson", client)
}

pub fn requestgroup_search_req(sp: SpRequestgroup, client: FhirClient) {
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
      #("code", sp.code),
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
      #("based-on", sp.based_on),
      #("patient", sp.patient),
      #("specimen", sp.specimen),
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
      #("status", sp.status),
    ])
  any_search_req(params, "Slot", client)
}

pub fn specimen_search_req(sp: SpSpecimen, client: FhirClient) {
  let params =
    using_params([
      #("container", sp.container),
      #("container-id", sp.container_id),
      #("identifier", sp.identifier),
      #("parent", sp.parent),
      #("bodysite", sp.bodysite),
      #("patient", sp.patient),
      #("subject", sp.subject),
      #("collected", sp.collected),
      #("accession", sp.accession),
      #("type", sp.type_),
      #("collector", sp.collector),
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
      #("base-path", sp.base_path),
      #("context", sp.context),
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
      #("payload", sp.payload),
      #("criteria", sp.criteria),
      #("contact", sp.contact),
      #("type", sp.type_),
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
      #("identifier", sp.identifier),
      #("resource", sp.resource),
      #("derived-or-self", sp.derived_or_self),
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
      #("context", sp.context),
      #("name", sp.name),
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
      #("context", sp.context),
      #("name", sp.name),
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
      #("context", sp.context),
      #("name", sp.name),
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

pub fn bundle_to_groupedresources(from bundle: r4b.Bundle) {
  list.fold(
    from: groupedresources_new(),
    over: bundle.entry,
    with: fn(acc, entry) {
      case entry.resource {
        None -> acc
        Some(res) ->
          case res {
            r4b.ResourceAccount(r) ->
              GroupedResources(..acc, account: [r, ..acc.account])
            r4b.ResourceActivitydefinition(r) ->
              GroupedResources(..acc, activitydefinition: [
                r,
                ..acc.activitydefinition
              ])
            r4b.ResourceAdministrableproductdefinition(r) ->
              GroupedResources(..acc, administrableproductdefinition: [
                r,
                ..acc.administrableproductdefinition
              ])
            r4b.ResourceAdverseevent(r) ->
              GroupedResources(..acc, adverseevent: [r, ..acc.adverseevent])
            r4b.ResourceAllergyintolerance(r) ->
              GroupedResources(..acc, allergyintolerance: [
                r,
                ..acc.allergyintolerance
              ])
            r4b.ResourceAppointment(r) ->
              GroupedResources(..acc, appointment: [r, ..acc.appointment])
            r4b.ResourceAppointmentresponse(r) ->
              GroupedResources(..acc, appointmentresponse: [
                r,
                ..acc.appointmentresponse
              ])
            r4b.ResourceAuditevent(r) ->
              GroupedResources(..acc, auditevent: [r, ..acc.auditevent])
            r4b.ResourceBasic(r) ->
              GroupedResources(..acc, basic: [r, ..acc.basic])
            r4b.ResourceBinary(r) ->
              GroupedResources(..acc, binary: [r, ..acc.binary])
            r4b.ResourceBiologicallyderivedproduct(r) ->
              GroupedResources(..acc, biologicallyderivedproduct: [
                r,
                ..acc.biologicallyderivedproduct
              ])
            r4b.ResourceBodystructure(r) ->
              GroupedResources(..acc, bodystructure: [r, ..acc.bodystructure])
            r4b.ResourceBundle(r) ->
              GroupedResources(..acc, bundle: [r, ..acc.bundle])
            r4b.ResourceCapabilitystatement(r) ->
              GroupedResources(..acc, capabilitystatement: [
                r,
                ..acc.capabilitystatement
              ])
            r4b.ResourceCareplan(r) ->
              GroupedResources(..acc, careplan: [r, ..acc.careplan])
            r4b.ResourceCareteam(r) ->
              GroupedResources(..acc, careteam: [r, ..acc.careteam])
            r4b.ResourceCatalogentry(r) ->
              GroupedResources(..acc, catalogentry: [r, ..acc.catalogentry])
            r4b.ResourceChargeitem(r) ->
              GroupedResources(..acc, chargeitem: [r, ..acc.chargeitem])
            r4b.ResourceChargeitemdefinition(r) ->
              GroupedResources(..acc, chargeitemdefinition: [
                r,
                ..acc.chargeitemdefinition
              ])
            r4b.ResourceCitation(r) ->
              GroupedResources(..acc, citation: [r, ..acc.citation])
            r4b.ResourceClaim(r) ->
              GroupedResources(..acc, claim: [r, ..acc.claim])
            r4b.ResourceClaimresponse(r) ->
              GroupedResources(..acc, claimresponse: [r, ..acc.claimresponse])
            r4b.ResourceClinicalimpression(r) ->
              GroupedResources(..acc, clinicalimpression: [
                r,
                ..acc.clinicalimpression
              ])
            r4b.ResourceClinicalusedefinition(r) ->
              GroupedResources(..acc, clinicalusedefinition: [
                r,
                ..acc.clinicalusedefinition
              ])
            r4b.ResourceCodesystem(r) ->
              GroupedResources(..acc, codesystem: [r, ..acc.codesystem])
            r4b.ResourceCommunication(r) ->
              GroupedResources(..acc, communication: [r, ..acc.communication])
            r4b.ResourceCommunicationrequest(r) ->
              GroupedResources(..acc, communicationrequest: [
                r,
                ..acc.communicationrequest
              ])
            r4b.ResourceCompartmentdefinition(r) ->
              GroupedResources(..acc, compartmentdefinition: [
                r,
                ..acc.compartmentdefinition
              ])
            r4b.ResourceComposition(r) ->
              GroupedResources(..acc, composition: [r, ..acc.composition])
            r4b.ResourceConceptmap(r) ->
              GroupedResources(..acc, conceptmap: [r, ..acc.conceptmap])
            r4b.ResourceCondition(r) ->
              GroupedResources(..acc, condition: [r, ..acc.condition])
            r4b.ResourceConsent(r) ->
              GroupedResources(..acc, consent: [r, ..acc.consent])
            r4b.ResourceContract(r) ->
              GroupedResources(..acc, contract: [r, ..acc.contract])
            r4b.ResourceCoverage(r) ->
              GroupedResources(..acc, coverage: [r, ..acc.coverage])
            r4b.ResourceCoverageeligibilityrequest(r) ->
              GroupedResources(..acc, coverageeligibilityrequest: [
                r,
                ..acc.coverageeligibilityrequest
              ])
            r4b.ResourceCoverageeligibilityresponse(r) ->
              GroupedResources(..acc, coverageeligibilityresponse: [
                r,
                ..acc.coverageeligibilityresponse
              ])
            r4b.ResourceDetectedissue(r) ->
              GroupedResources(..acc, detectedissue: [r, ..acc.detectedissue])
            r4b.ResourceDevice(r) ->
              GroupedResources(..acc, device: [r, ..acc.device])
            r4b.ResourceDevicedefinition(r) ->
              GroupedResources(..acc, devicedefinition: [
                r,
                ..acc.devicedefinition
              ])
            r4b.ResourceDevicemetric(r) ->
              GroupedResources(..acc, devicemetric: [r, ..acc.devicemetric])
            r4b.ResourceDevicerequest(r) ->
              GroupedResources(..acc, devicerequest: [r, ..acc.devicerequest])
            r4b.ResourceDeviceusestatement(r) ->
              GroupedResources(..acc, deviceusestatement: [
                r,
                ..acc.deviceusestatement
              ])
            r4b.ResourceDiagnosticreport(r) ->
              GroupedResources(..acc, diagnosticreport: [
                r,
                ..acc.diagnosticreport
              ])
            r4b.ResourceDocumentmanifest(r) ->
              GroupedResources(..acc, documentmanifest: [
                r,
                ..acc.documentmanifest
              ])
            r4b.ResourceDocumentreference(r) ->
              GroupedResources(..acc, documentreference: [
                r,
                ..acc.documentreference
              ])
            r4b.ResourceEncounter(r) ->
              GroupedResources(..acc, encounter: [r, ..acc.encounter])
            r4b.ResourceEndpoint(r) ->
              GroupedResources(..acc, endpoint: [r, ..acc.endpoint])
            r4b.ResourceEnrollmentrequest(r) ->
              GroupedResources(..acc, enrollmentrequest: [
                r,
                ..acc.enrollmentrequest
              ])
            r4b.ResourceEnrollmentresponse(r) ->
              GroupedResources(..acc, enrollmentresponse: [
                r,
                ..acc.enrollmentresponse
              ])
            r4b.ResourceEpisodeofcare(r) ->
              GroupedResources(..acc, episodeofcare: [r, ..acc.episodeofcare])
            r4b.ResourceEventdefinition(r) ->
              GroupedResources(..acc, eventdefinition: [
                r,
                ..acc.eventdefinition
              ])
            r4b.ResourceEvidence(r) ->
              GroupedResources(..acc, evidence: [r, ..acc.evidence])
            r4b.ResourceEvidencereport(r) ->
              GroupedResources(..acc, evidencereport: [r, ..acc.evidencereport])
            r4b.ResourceEvidencevariable(r) ->
              GroupedResources(..acc, evidencevariable: [
                r,
                ..acc.evidencevariable
              ])
            r4b.ResourceExamplescenario(r) ->
              GroupedResources(..acc, examplescenario: [
                r,
                ..acc.examplescenario
              ])
            r4b.ResourceExplanationofbenefit(r) ->
              GroupedResources(..acc, explanationofbenefit: [
                r,
                ..acc.explanationofbenefit
              ])
            r4b.ResourceFamilymemberhistory(r) ->
              GroupedResources(..acc, familymemberhistory: [
                r,
                ..acc.familymemberhistory
              ])
            r4b.ResourceFlag(r) ->
              GroupedResources(..acc, flag: [r, ..acc.flag])
            r4b.ResourceGoal(r) ->
              GroupedResources(..acc, goal: [r, ..acc.goal])
            r4b.ResourceGraphdefinition(r) ->
              GroupedResources(..acc, graphdefinition: [
                r,
                ..acc.graphdefinition
              ])
            r4b.ResourceGroup(r) ->
              GroupedResources(..acc, group: [r, ..acc.group])
            r4b.ResourceGuidanceresponse(r) ->
              GroupedResources(..acc, guidanceresponse: [
                r,
                ..acc.guidanceresponse
              ])
            r4b.ResourceHealthcareservice(r) ->
              GroupedResources(..acc, healthcareservice: [
                r,
                ..acc.healthcareservice
              ])
            r4b.ResourceImagingstudy(r) ->
              GroupedResources(..acc, imagingstudy: [r, ..acc.imagingstudy])
            r4b.ResourceImmunization(r) ->
              GroupedResources(..acc, immunization: [r, ..acc.immunization])
            r4b.ResourceImmunizationevaluation(r) ->
              GroupedResources(..acc, immunizationevaluation: [
                r,
                ..acc.immunizationevaluation
              ])
            r4b.ResourceImmunizationrecommendation(r) ->
              GroupedResources(..acc, immunizationrecommendation: [
                r,
                ..acc.immunizationrecommendation
              ])
            r4b.ResourceImplementationguide(r) ->
              GroupedResources(..acc, implementationguide: [
                r,
                ..acc.implementationguide
              ])
            r4b.ResourceIngredient(r) ->
              GroupedResources(..acc, ingredient: [r, ..acc.ingredient])
            r4b.ResourceInsuranceplan(r) ->
              GroupedResources(..acc, insuranceplan: [r, ..acc.insuranceplan])
            r4b.ResourceInvoice(r) ->
              GroupedResources(..acc, invoice: [r, ..acc.invoice])
            r4b.ResourceLibrary(r) ->
              GroupedResources(..acc, library: [r, ..acc.library])
            r4b.ResourceLinkage(r) ->
              GroupedResources(..acc, linkage: [r, ..acc.linkage])
            r4b.ResourceListfhir(r) ->
              GroupedResources(..acc, listfhir: [r, ..acc.listfhir])
            r4b.ResourceLocation(r) ->
              GroupedResources(..acc, location: [r, ..acc.location])
            r4b.ResourceManufactureditemdefinition(r) ->
              GroupedResources(..acc, manufactureditemdefinition: [
                r,
                ..acc.manufactureditemdefinition
              ])
            r4b.ResourceMeasure(r) ->
              GroupedResources(..acc, measure: [r, ..acc.measure])
            r4b.ResourceMeasurereport(r) ->
              GroupedResources(..acc, measurereport: [r, ..acc.measurereport])
            r4b.ResourceMedia(r) ->
              GroupedResources(..acc, media: [r, ..acc.media])
            r4b.ResourceMedication(r) ->
              GroupedResources(..acc, medication: [r, ..acc.medication])
            r4b.ResourceMedicationadministration(r) ->
              GroupedResources(..acc, medicationadministration: [
                r,
                ..acc.medicationadministration
              ])
            r4b.ResourceMedicationdispense(r) ->
              GroupedResources(..acc, medicationdispense: [
                r,
                ..acc.medicationdispense
              ])
            r4b.ResourceMedicationknowledge(r) ->
              GroupedResources(..acc, medicationknowledge: [
                r,
                ..acc.medicationknowledge
              ])
            r4b.ResourceMedicationrequest(r) ->
              GroupedResources(..acc, medicationrequest: [
                r,
                ..acc.medicationrequest
              ])
            r4b.ResourceMedicationstatement(r) ->
              GroupedResources(..acc, medicationstatement: [
                r,
                ..acc.medicationstatement
              ])
            r4b.ResourceMedicinalproductdefinition(r) ->
              GroupedResources(..acc, medicinalproductdefinition: [
                r,
                ..acc.medicinalproductdefinition
              ])
            r4b.ResourceMessagedefinition(r) ->
              GroupedResources(..acc, messagedefinition: [
                r,
                ..acc.messagedefinition
              ])
            r4b.ResourceMessageheader(r) ->
              GroupedResources(..acc, messageheader: [r, ..acc.messageheader])
            r4b.ResourceMolecularsequence(r) ->
              GroupedResources(..acc, molecularsequence: [
                r,
                ..acc.molecularsequence
              ])
            r4b.ResourceNamingsystem(r) ->
              GroupedResources(..acc, namingsystem: [r, ..acc.namingsystem])
            r4b.ResourceNutritionorder(r) ->
              GroupedResources(..acc, nutritionorder: [r, ..acc.nutritionorder])
            r4b.ResourceNutritionproduct(r) ->
              GroupedResources(..acc, nutritionproduct: [
                r,
                ..acc.nutritionproduct
              ])
            r4b.ResourceObservation(r) ->
              GroupedResources(..acc, observation: [r, ..acc.observation])
            r4b.ResourceObservationdefinition(r) ->
              GroupedResources(..acc, observationdefinition: [
                r,
                ..acc.observationdefinition
              ])
            r4b.ResourceOperationdefinition(r) ->
              GroupedResources(..acc, operationdefinition: [
                r,
                ..acc.operationdefinition
              ])
            r4b.ResourceOperationoutcome(r) ->
              GroupedResources(..acc, operationoutcome: [
                r,
                ..acc.operationoutcome
              ])
            r4b.ResourceOrganization(r) ->
              GroupedResources(..acc, organization: [r, ..acc.organization])
            r4b.ResourceOrganizationaffiliation(r) ->
              GroupedResources(..acc, organizationaffiliation: [
                r,
                ..acc.organizationaffiliation
              ])
            r4b.ResourcePackagedproductdefinition(r) ->
              GroupedResources(..acc, packagedproductdefinition: [
                r,
                ..acc.packagedproductdefinition
              ])
            r4b.ResourcePatient(r) ->
              GroupedResources(..acc, patient: [r, ..acc.patient])
            r4b.ResourcePaymentnotice(r) ->
              GroupedResources(..acc, paymentnotice: [r, ..acc.paymentnotice])
            r4b.ResourcePaymentreconciliation(r) ->
              GroupedResources(..acc, paymentreconciliation: [
                r,
                ..acc.paymentreconciliation
              ])
            r4b.ResourcePerson(r) ->
              GroupedResources(..acc, person: [r, ..acc.person])
            r4b.ResourcePlandefinition(r) ->
              GroupedResources(..acc, plandefinition: [r, ..acc.plandefinition])
            r4b.ResourcePractitioner(r) ->
              GroupedResources(..acc, practitioner: [r, ..acc.practitioner])
            r4b.ResourcePractitionerrole(r) ->
              GroupedResources(..acc, practitionerrole: [
                r,
                ..acc.practitionerrole
              ])
            r4b.ResourceProcedure(r) ->
              GroupedResources(..acc, procedure: [r, ..acc.procedure])
            r4b.ResourceProvenance(r) ->
              GroupedResources(..acc, provenance: [r, ..acc.provenance])
            r4b.ResourceQuestionnaire(r) ->
              GroupedResources(..acc, questionnaire: [r, ..acc.questionnaire])
            r4b.ResourceQuestionnaireresponse(r) ->
              GroupedResources(..acc, questionnaireresponse: [
                r,
                ..acc.questionnaireresponse
              ])
            r4b.ResourceRegulatedauthorization(r) ->
              GroupedResources(..acc, regulatedauthorization: [
                r,
                ..acc.regulatedauthorization
              ])
            r4b.ResourceRelatedperson(r) ->
              GroupedResources(..acc, relatedperson: [r, ..acc.relatedperson])
            r4b.ResourceRequestgroup(r) ->
              GroupedResources(..acc, requestgroup: [r, ..acc.requestgroup])
            r4b.ResourceResearchdefinition(r) ->
              GroupedResources(..acc, researchdefinition: [
                r,
                ..acc.researchdefinition
              ])
            r4b.ResourceResearchelementdefinition(r) ->
              GroupedResources(..acc, researchelementdefinition: [
                r,
                ..acc.researchelementdefinition
              ])
            r4b.ResourceResearchstudy(r) ->
              GroupedResources(..acc, researchstudy: [r, ..acc.researchstudy])
            r4b.ResourceResearchsubject(r) ->
              GroupedResources(..acc, researchsubject: [
                r,
                ..acc.researchsubject
              ])
            r4b.ResourceRiskassessment(r) ->
              GroupedResources(..acc, riskassessment: [r, ..acc.riskassessment])
            r4b.ResourceSchedule(r) ->
              GroupedResources(..acc, schedule: [r, ..acc.schedule])
            r4b.ResourceSearchparameter(r) ->
              GroupedResources(..acc, searchparameter: [
                r,
                ..acc.searchparameter
              ])
            r4b.ResourceServicerequest(r) ->
              GroupedResources(..acc, servicerequest: [r, ..acc.servicerequest])
            r4b.ResourceSlot(r) ->
              GroupedResources(..acc, slot: [r, ..acc.slot])
            r4b.ResourceSpecimen(r) ->
              GroupedResources(..acc, specimen: [r, ..acc.specimen])
            r4b.ResourceSpecimendefinition(r) ->
              GroupedResources(..acc, specimendefinition: [
                r,
                ..acc.specimendefinition
              ])
            r4b.ResourceStructuredefinition(r) ->
              GroupedResources(..acc, structuredefinition: [
                r,
                ..acc.structuredefinition
              ])
            r4b.ResourceStructuremap(r) ->
              GroupedResources(..acc, structuremap: [r, ..acc.structuremap])
            r4b.ResourceSubscription(r) ->
              GroupedResources(..acc, subscription: [r, ..acc.subscription])
            r4b.ResourceSubscriptionstatus(r) ->
              GroupedResources(..acc, subscriptionstatus: [
                r,
                ..acc.subscriptionstatus
              ])
            r4b.ResourceSubscriptiontopic(r) ->
              GroupedResources(..acc, subscriptiontopic: [
                r,
                ..acc.subscriptiontopic
              ])
            r4b.ResourceSubstance(r) ->
              GroupedResources(..acc, substance: [r, ..acc.substance])
            r4b.ResourceSubstancedefinition(r) ->
              GroupedResources(..acc, substancedefinition: [
                r,
                ..acc.substancedefinition
              ])
            r4b.ResourceSupplydelivery(r) ->
              GroupedResources(..acc, supplydelivery: [r, ..acc.supplydelivery])
            r4b.ResourceSupplyrequest(r) ->
              GroupedResources(..acc, supplyrequest: [r, ..acc.supplyrequest])
            r4b.ResourceTask(r) ->
              GroupedResources(..acc, task: [r, ..acc.task])
            r4b.ResourceTerminologycapabilities(r) ->
              GroupedResources(..acc, terminologycapabilities: [
                r,
                ..acc.terminologycapabilities
              ])
            r4b.ResourceTestreport(r) ->
              GroupedResources(..acc, testreport: [r, ..acc.testreport])
            r4b.ResourceTestscript(r) ->
              GroupedResources(..acc, testscript: [r, ..acc.testscript])
            r4b.ResourceValueset(r) ->
              GroupedResources(..acc, valueset: [r, ..acc.valueset])
            r4b.ResourceVerificationresult(r) ->
              GroupedResources(..acc, verificationresult: [
                r,
                ..acc.verificationresult
              ])
            r4b.ResourceVisionprescription(r) ->
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
