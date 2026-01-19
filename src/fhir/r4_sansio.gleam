import fhir/r4
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
  ErrOperationcome(r4.Operationoutcome)
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
  echo req.path
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
      True -> r4.operationoutcome_decoder() |> decode.map(fn(x) { Error(x) })
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
  resource: r4.Account,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.account_to_json(resource), "Account", client)
}

pub fn account_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Account", client)
}

pub fn account_update_req(
  resource: r4.Account,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.account_to_json(resource), "Account", client)
}

pub fn account_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Account", client)
}

pub fn account_resp(resp: Response(String)) -> Result(r4.Account, Err) {
  any_resp(resp, r4.account_decoder())
}

pub fn activitydefinition_create_req(
  resource: r4.Activitydefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.activitydefinition_to_json(resource),
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
  resource: r4.Activitydefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.activitydefinition_to_json(resource),
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
) -> Result(r4.Activitydefinition, Err) {
  any_resp(resp, r4.activitydefinition_decoder())
}

pub fn adverseevent_create_req(
  resource: r4.Adverseevent,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.adverseevent_to_json(resource), "AdverseEvent", client)
}

pub fn adverseevent_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "AdverseEvent", client)
}

pub fn adverseevent_update_req(
  resource: r4.Adverseevent,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.adverseevent_to_json(resource),
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

pub fn adverseevent_resp(resp: Response(String)) -> Result(r4.Adverseevent, Err) {
  any_resp(resp, r4.adverseevent_decoder())
}

pub fn allergyintolerance_create_req(
  resource: r4.Allergyintolerance,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.allergyintolerance_to_json(resource),
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
  resource: r4.Allergyintolerance,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.allergyintolerance_to_json(resource),
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
) -> Result(r4.Allergyintolerance, Err) {
  any_resp(resp, r4.allergyintolerance_decoder())
}

pub fn appointment_create_req(
  resource: r4.Appointment,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.appointment_to_json(resource), "Appointment", client)
}

pub fn appointment_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Appointment", client)
}

pub fn appointment_update_req(
  resource: r4.Appointment,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.appointment_to_json(resource),
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

pub fn appointment_resp(resp: Response(String)) -> Result(r4.Appointment, Err) {
  any_resp(resp, r4.appointment_decoder())
}

pub fn appointmentresponse_create_req(
  resource: r4.Appointmentresponse,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.appointmentresponse_to_json(resource),
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
  resource: r4.Appointmentresponse,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.appointmentresponse_to_json(resource),
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
) -> Result(r4.Appointmentresponse, Err) {
  any_resp(resp, r4.appointmentresponse_decoder())
}

pub fn auditevent_create_req(
  resource: r4.Auditevent,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.auditevent_to_json(resource), "AuditEvent", client)
}

pub fn auditevent_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "AuditEvent", client)
}

pub fn auditevent_update_req(
  resource: r4.Auditevent,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.auditevent_to_json(resource),
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

pub fn auditevent_resp(resp: Response(String)) -> Result(r4.Auditevent, Err) {
  any_resp(resp, r4.auditevent_decoder())
}

pub fn basic_create_req(
  resource: r4.Basic,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.basic_to_json(resource), "Basic", client)
}

pub fn basic_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Basic", client)
}

pub fn basic_update_req(
  resource: r4.Basic,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.basic_to_json(resource), "Basic", client)
}

pub fn basic_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Basic", client)
}

pub fn basic_resp(resp: Response(String)) -> Result(r4.Basic, Err) {
  any_resp(resp, r4.basic_decoder())
}

pub fn binary_create_req(
  resource: r4.Binary,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.binary_to_json(resource), "Binary", client)
}

pub fn binary_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Binary", client)
}

pub fn binary_update_req(
  resource: r4.Binary,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.binary_to_json(resource), "Binary", client)
}

pub fn binary_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Binary", client)
}

pub fn binary_resp(resp: Response(String)) -> Result(r4.Binary, Err) {
  any_resp(resp, r4.binary_decoder())
}

pub fn biologicallyderivedproduct_create_req(
  resource: r4.Biologicallyderivedproduct,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.biologicallyderivedproduct_to_json(resource),
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
  resource: r4.Biologicallyderivedproduct,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.biologicallyderivedproduct_to_json(resource),
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
) -> Result(r4.Biologicallyderivedproduct, Err) {
  any_resp(resp, r4.biologicallyderivedproduct_decoder())
}

pub fn bodystructure_create_req(
  resource: r4.Bodystructure,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.bodystructure_to_json(resource), "BodyStructure", client)
}

pub fn bodystructure_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "BodyStructure", client)
}

pub fn bodystructure_update_req(
  resource: r4.Bodystructure,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.bodystructure_to_json(resource),
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
) -> Result(r4.Bodystructure, Err) {
  any_resp(resp, r4.bodystructure_decoder())
}

pub fn bundle_create_req(
  resource: r4.Bundle,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.bundle_to_json(resource), "Bundle", client)
}

pub fn bundle_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Bundle", client)
}

pub fn bundle_update_req(
  resource: r4.Bundle,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.bundle_to_json(resource), "Bundle", client)
}

pub fn bundle_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Bundle", client)
}

pub fn bundle_resp(resp: Response(String)) -> Result(r4.Bundle, Err) {
  any_resp(resp, r4.bundle_decoder())
}

pub fn capabilitystatement_create_req(
  resource: r4.Capabilitystatement,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.capabilitystatement_to_json(resource),
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
  resource: r4.Capabilitystatement,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.capabilitystatement_to_json(resource),
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
) -> Result(r4.Capabilitystatement, Err) {
  any_resp(resp, r4.capabilitystatement_decoder())
}

pub fn careplan_create_req(
  resource: r4.Careplan,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.careplan_to_json(resource), "CarePlan", client)
}

pub fn careplan_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "CarePlan", client)
}

pub fn careplan_update_req(
  resource: r4.Careplan,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.careplan_to_json(resource), "CarePlan", client)
}

pub fn careplan_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "CarePlan", client)
}

pub fn careplan_resp(resp: Response(String)) -> Result(r4.Careplan, Err) {
  any_resp(resp, r4.careplan_decoder())
}

pub fn careteam_create_req(
  resource: r4.Careteam,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.careteam_to_json(resource), "CareTeam", client)
}

pub fn careteam_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "CareTeam", client)
}

pub fn careteam_update_req(
  resource: r4.Careteam,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.careteam_to_json(resource), "CareTeam", client)
}

pub fn careteam_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "CareTeam", client)
}

pub fn careteam_resp(resp: Response(String)) -> Result(r4.Careteam, Err) {
  any_resp(resp, r4.careteam_decoder())
}

pub fn catalogentry_create_req(
  resource: r4.Catalogentry,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.catalogentry_to_json(resource), "CatalogEntry", client)
}

pub fn catalogentry_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "CatalogEntry", client)
}

pub fn catalogentry_update_req(
  resource: r4.Catalogentry,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.catalogentry_to_json(resource),
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

pub fn catalogentry_resp(resp: Response(String)) -> Result(r4.Catalogentry, Err) {
  any_resp(resp, r4.catalogentry_decoder())
}

pub fn chargeitem_create_req(
  resource: r4.Chargeitem,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.chargeitem_to_json(resource), "ChargeItem", client)
}

pub fn chargeitem_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "ChargeItem", client)
}

pub fn chargeitem_update_req(
  resource: r4.Chargeitem,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.chargeitem_to_json(resource),
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

pub fn chargeitem_resp(resp: Response(String)) -> Result(r4.Chargeitem, Err) {
  any_resp(resp, r4.chargeitem_decoder())
}

pub fn chargeitemdefinition_create_req(
  resource: r4.Chargeitemdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.chargeitemdefinition_to_json(resource),
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
  resource: r4.Chargeitemdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.chargeitemdefinition_to_json(resource),
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
) -> Result(r4.Chargeitemdefinition, Err) {
  any_resp(resp, r4.chargeitemdefinition_decoder())
}

pub fn claim_create_req(
  resource: r4.Claim,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.claim_to_json(resource), "Claim", client)
}

pub fn claim_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Claim", client)
}

pub fn claim_update_req(
  resource: r4.Claim,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.claim_to_json(resource), "Claim", client)
}

pub fn claim_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Claim", client)
}

pub fn claim_resp(resp: Response(String)) -> Result(r4.Claim, Err) {
  any_resp(resp, r4.claim_decoder())
}

pub fn claimresponse_create_req(
  resource: r4.Claimresponse,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.claimresponse_to_json(resource), "ClaimResponse", client)
}

pub fn claimresponse_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "ClaimResponse", client)
}

pub fn claimresponse_update_req(
  resource: r4.Claimresponse,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.claimresponse_to_json(resource),
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
) -> Result(r4.Claimresponse, Err) {
  any_resp(resp, r4.claimresponse_decoder())
}

pub fn clinicalimpression_create_req(
  resource: r4.Clinicalimpression,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.clinicalimpression_to_json(resource),
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
  resource: r4.Clinicalimpression,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.clinicalimpression_to_json(resource),
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
) -> Result(r4.Clinicalimpression, Err) {
  any_resp(resp, r4.clinicalimpression_decoder())
}

pub fn codesystem_create_req(
  resource: r4.Codesystem,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.codesystem_to_json(resource), "CodeSystem", client)
}

pub fn codesystem_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "CodeSystem", client)
}

pub fn codesystem_update_req(
  resource: r4.Codesystem,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.codesystem_to_json(resource),
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

pub fn codesystem_resp(resp: Response(String)) -> Result(r4.Codesystem, Err) {
  any_resp(resp, r4.codesystem_decoder())
}

pub fn communication_create_req(
  resource: r4.Communication,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.communication_to_json(resource), "Communication", client)
}

pub fn communication_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Communication", client)
}

pub fn communication_update_req(
  resource: r4.Communication,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.communication_to_json(resource),
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
) -> Result(r4.Communication, Err) {
  any_resp(resp, r4.communication_decoder())
}

pub fn communicationrequest_create_req(
  resource: r4.Communicationrequest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.communicationrequest_to_json(resource),
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
  resource: r4.Communicationrequest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.communicationrequest_to_json(resource),
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
) -> Result(r4.Communicationrequest, Err) {
  any_resp(resp, r4.communicationrequest_decoder())
}

pub fn compartmentdefinition_create_req(
  resource: r4.Compartmentdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.compartmentdefinition_to_json(resource),
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
  resource: r4.Compartmentdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.compartmentdefinition_to_json(resource),
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
) -> Result(r4.Compartmentdefinition, Err) {
  any_resp(resp, r4.compartmentdefinition_decoder())
}

pub fn composition_create_req(
  resource: r4.Composition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.composition_to_json(resource), "Composition", client)
}

pub fn composition_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Composition", client)
}

pub fn composition_update_req(
  resource: r4.Composition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.composition_to_json(resource),
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

pub fn composition_resp(resp: Response(String)) -> Result(r4.Composition, Err) {
  any_resp(resp, r4.composition_decoder())
}

pub fn conceptmap_create_req(
  resource: r4.Conceptmap,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.conceptmap_to_json(resource), "ConceptMap", client)
}

pub fn conceptmap_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "ConceptMap", client)
}

pub fn conceptmap_update_req(
  resource: r4.Conceptmap,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.conceptmap_to_json(resource),
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

pub fn conceptmap_resp(resp: Response(String)) -> Result(r4.Conceptmap, Err) {
  any_resp(resp, r4.conceptmap_decoder())
}

pub fn condition_create_req(
  resource: r4.Condition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.condition_to_json(resource), "Condition", client)
}

pub fn condition_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Condition", client)
}

pub fn condition_update_req(
  resource: r4.Condition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.condition_to_json(resource),
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

pub fn condition_resp(resp: Response(String)) -> Result(r4.Condition, Err) {
  any_resp(resp, r4.condition_decoder())
}

pub fn consent_create_req(
  resource: r4.Consent,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.consent_to_json(resource), "Consent", client)
}

pub fn consent_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Consent", client)
}

pub fn consent_update_req(
  resource: r4.Consent,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.consent_to_json(resource), "Consent", client)
}

pub fn consent_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Consent", client)
}

pub fn consent_resp(resp: Response(String)) -> Result(r4.Consent, Err) {
  any_resp(resp, r4.consent_decoder())
}

pub fn contract_create_req(
  resource: r4.Contract,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.contract_to_json(resource), "Contract", client)
}

pub fn contract_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Contract", client)
}

pub fn contract_update_req(
  resource: r4.Contract,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.contract_to_json(resource), "Contract", client)
}

pub fn contract_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Contract", client)
}

pub fn contract_resp(resp: Response(String)) -> Result(r4.Contract, Err) {
  any_resp(resp, r4.contract_decoder())
}

pub fn coverage_create_req(
  resource: r4.Coverage,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.coverage_to_json(resource), "Coverage", client)
}

pub fn coverage_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Coverage", client)
}

pub fn coverage_update_req(
  resource: r4.Coverage,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.coverage_to_json(resource), "Coverage", client)
}

pub fn coverage_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Coverage", client)
}

pub fn coverage_resp(resp: Response(String)) -> Result(r4.Coverage, Err) {
  any_resp(resp, r4.coverage_decoder())
}

pub fn coverageeligibilityrequest_create_req(
  resource: r4.Coverageeligibilityrequest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.coverageeligibilityrequest_to_json(resource),
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
  resource: r4.Coverageeligibilityrequest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.coverageeligibilityrequest_to_json(resource),
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
) -> Result(r4.Coverageeligibilityrequest, Err) {
  any_resp(resp, r4.coverageeligibilityrequest_decoder())
}

pub fn coverageeligibilityresponse_create_req(
  resource: r4.Coverageeligibilityresponse,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.coverageeligibilityresponse_to_json(resource),
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
  resource: r4.Coverageeligibilityresponse,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.coverageeligibilityresponse_to_json(resource),
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
) -> Result(r4.Coverageeligibilityresponse, Err) {
  any_resp(resp, r4.coverageeligibilityresponse_decoder())
}

pub fn detectedissue_create_req(
  resource: r4.Detectedissue,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.detectedissue_to_json(resource), "DetectedIssue", client)
}

pub fn detectedissue_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "DetectedIssue", client)
}

pub fn detectedissue_update_req(
  resource: r4.Detectedissue,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.detectedissue_to_json(resource),
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
) -> Result(r4.Detectedissue, Err) {
  any_resp(resp, r4.detectedissue_decoder())
}

pub fn device_create_req(
  resource: r4.Device,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.device_to_json(resource), "Device", client)
}

pub fn device_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Device", client)
}

pub fn device_update_req(
  resource: r4.Device,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.device_to_json(resource), "Device", client)
}

pub fn device_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Device", client)
}

pub fn device_resp(resp: Response(String)) -> Result(r4.Device, Err) {
  any_resp(resp, r4.device_decoder())
}

pub fn devicedefinition_create_req(
  resource: r4.Devicedefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.devicedefinition_to_json(resource),
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
  resource: r4.Devicedefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.devicedefinition_to_json(resource),
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
) -> Result(r4.Devicedefinition, Err) {
  any_resp(resp, r4.devicedefinition_decoder())
}

pub fn devicemetric_create_req(
  resource: r4.Devicemetric,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.devicemetric_to_json(resource), "DeviceMetric", client)
}

pub fn devicemetric_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "DeviceMetric", client)
}

pub fn devicemetric_update_req(
  resource: r4.Devicemetric,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.devicemetric_to_json(resource),
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

pub fn devicemetric_resp(resp: Response(String)) -> Result(r4.Devicemetric, Err) {
  any_resp(resp, r4.devicemetric_decoder())
}

pub fn devicerequest_create_req(
  resource: r4.Devicerequest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.devicerequest_to_json(resource), "DeviceRequest", client)
}

pub fn devicerequest_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "DeviceRequest", client)
}

pub fn devicerequest_update_req(
  resource: r4.Devicerequest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.devicerequest_to_json(resource),
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
) -> Result(r4.Devicerequest, Err) {
  any_resp(resp, r4.devicerequest_decoder())
}

pub fn deviceusestatement_create_req(
  resource: r4.Deviceusestatement,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.deviceusestatement_to_json(resource),
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
  resource: r4.Deviceusestatement,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.deviceusestatement_to_json(resource),
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
) -> Result(r4.Deviceusestatement, Err) {
  any_resp(resp, r4.deviceusestatement_decoder())
}

pub fn diagnosticreport_create_req(
  resource: r4.Diagnosticreport,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.diagnosticreport_to_json(resource),
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
  resource: r4.Diagnosticreport,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.diagnosticreport_to_json(resource),
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
) -> Result(r4.Diagnosticreport, Err) {
  any_resp(resp, r4.diagnosticreport_decoder())
}

pub fn documentmanifest_create_req(
  resource: r4.Documentmanifest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.documentmanifest_to_json(resource),
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
  resource: r4.Documentmanifest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.documentmanifest_to_json(resource),
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
) -> Result(r4.Documentmanifest, Err) {
  any_resp(resp, r4.documentmanifest_decoder())
}

pub fn documentreference_create_req(
  resource: r4.Documentreference,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.documentreference_to_json(resource),
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
  resource: r4.Documentreference,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.documentreference_to_json(resource),
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
) -> Result(r4.Documentreference, Err) {
  any_resp(resp, r4.documentreference_decoder())
}

pub fn effectevidencesynthesis_create_req(
  resource: r4.Effectevidencesynthesis,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.effectevidencesynthesis_to_json(resource),
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
  resource: r4.Effectevidencesynthesis,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.effectevidencesynthesis_to_json(resource),
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
) -> Result(r4.Effectevidencesynthesis, Err) {
  any_resp(resp, r4.effectevidencesynthesis_decoder())
}

pub fn encounter_create_req(
  resource: r4.Encounter,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.encounter_to_json(resource), "Encounter", client)
}

pub fn encounter_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Encounter", client)
}

pub fn encounter_update_req(
  resource: r4.Encounter,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.encounter_to_json(resource),
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

pub fn encounter_resp(resp: Response(String)) -> Result(r4.Encounter, Err) {
  any_resp(resp, r4.encounter_decoder())
}

pub fn endpoint_create_req(
  resource: r4.Endpoint,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.endpoint_to_json(resource), "Endpoint", client)
}

pub fn endpoint_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Endpoint", client)
}

pub fn endpoint_update_req(
  resource: r4.Endpoint,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.endpoint_to_json(resource), "Endpoint", client)
}

pub fn endpoint_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Endpoint", client)
}

pub fn endpoint_resp(resp: Response(String)) -> Result(r4.Endpoint, Err) {
  any_resp(resp, r4.endpoint_decoder())
}

pub fn enrollmentrequest_create_req(
  resource: r4.Enrollmentrequest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.enrollmentrequest_to_json(resource),
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
  resource: r4.Enrollmentrequest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.enrollmentrequest_to_json(resource),
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
) -> Result(r4.Enrollmentrequest, Err) {
  any_resp(resp, r4.enrollmentrequest_decoder())
}

pub fn enrollmentresponse_create_req(
  resource: r4.Enrollmentresponse,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.enrollmentresponse_to_json(resource),
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
  resource: r4.Enrollmentresponse,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.enrollmentresponse_to_json(resource),
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
) -> Result(r4.Enrollmentresponse, Err) {
  any_resp(resp, r4.enrollmentresponse_decoder())
}

pub fn episodeofcare_create_req(
  resource: r4.Episodeofcare,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.episodeofcare_to_json(resource), "EpisodeOfCare", client)
}

pub fn episodeofcare_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "EpisodeOfCare", client)
}

pub fn episodeofcare_update_req(
  resource: r4.Episodeofcare,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.episodeofcare_to_json(resource),
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
) -> Result(r4.Episodeofcare, Err) {
  any_resp(resp, r4.episodeofcare_decoder())
}

pub fn eventdefinition_create_req(
  resource: r4.Eventdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.eventdefinition_to_json(resource),
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
  resource: r4.Eventdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.eventdefinition_to_json(resource),
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
) -> Result(r4.Eventdefinition, Err) {
  any_resp(resp, r4.eventdefinition_decoder())
}

pub fn evidence_create_req(
  resource: r4.Evidence,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.evidence_to_json(resource), "Evidence", client)
}

pub fn evidence_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Evidence", client)
}

pub fn evidence_update_req(
  resource: r4.Evidence,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.evidence_to_json(resource), "Evidence", client)
}

pub fn evidence_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Evidence", client)
}

pub fn evidence_resp(resp: Response(String)) -> Result(r4.Evidence, Err) {
  any_resp(resp, r4.evidence_decoder())
}

pub fn evidencevariable_create_req(
  resource: r4.Evidencevariable,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.evidencevariable_to_json(resource),
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
  resource: r4.Evidencevariable,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.evidencevariable_to_json(resource),
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
) -> Result(r4.Evidencevariable, Err) {
  any_resp(resp, r4.evidencevariable_decoder())
}

pub fn examplescenario_create_req(
  resource: r4.Examplescenario,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.examplescenario_to_json(resource),
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
  resource: r4.Examplescenario,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.examplescenario_to_json(resource),
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
) -> Result(r4.Examplescenario, Err) {
  any_resp(resp, r4.examplescenario_decoder())
}

pub fn explanationofbenefit_create_req(
  resource: r4.Explanationofbenefit,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.explanationofbenefit_to_json(resource),
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
  resource: r4.Explanationofbenefit,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.explanationofbenefit_to_json(resource),
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
) -> Result(r4.Explanationofbenefit, Err) {
  any_resp(resp, r4.explanationofbenefit_decoder())
}

pub fn familymemberhistory_create_req(
  resource: r4.Familymemberhistory,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.familymemberhistory_to_json(resource),
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
  resource: r4.Familymemberhistory,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.familymemberhistory_to_json(resource),
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
) -> Result(r4.Familymemberhistory, Err) {
  any_resp(resp, r4.familymemberhistory_decoder())
}

pub fn flag_create_req(resource: r4.Flag, client: FhirClient) -> Request(String) {
  any_create_req(r4.flag_to_json(resource), "Flag", client)
}

pub fn flag_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Flag", client)
}

pub fn flag_update_req(
  resource: r4.Flag,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.flag_to_json(resource), "Flag", client)
}

pub fn flag_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Flag", client)
}

pub fn flag_resp(resp: Response(String)) -> Result(r4.Flag, Err) {
  any_resp(resp, r4.flag_decoder())
}

pub fn goal_create_req(resource: r4.Goal, client: FhirClient) -> Request(String) {
  any_create_req(r4.goal_to_json(resource), "Goal", client)
}

pub fn goal_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Goal", client)
}

pub fn goal_update_req(
  resource: r4.Goal,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.goal_to_json(resource), "Goal", client)
}

pub fn goal_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Goal", client)
}

pub fn goal_resp(resp: Response(String)) -> Result(r4.Goal, Err) {
  any_resp(resp, r4.goal_decoder())
}

pub fn graphdefinition_create_req(
  resource: r4.Graphdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.graphdefinition_to_json(resource),
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
  resource: r4.Graphdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.graphdefinition_to_json(resource),
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
) -> Result(r4.Graphdefinition, Err) {
  any_resp(resp, r4.graphdefinition_decoder())
}

pub fn group_create_req(
  resource: r4.Group,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.group_to_json(resource), "Group", client)
}

pub fn group_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Group", client)
}

pub fn group_update_req(
  resource: r4.Group,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.group_to_json(resource), "Group", client)
}

pub fn group_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Group", client)
}

pub fn group_resp(resp: Response(String)) -> Result(r4.Group, Err) {
  any_resp(resp, r4.group_decoder())
}

pub fn guidanceresponse_create_req(
  resource: r4.Guidanceresponse,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.guidanceresponse_to_json(resource),
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
  resource: r4.Guidanceresponse,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.guidanceresponse_to_json(resource),
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
) -> Result(r4.Guidanceresponse, Err) {
  any_resp(resp, r4.guidanceresponse_decoder())
}

pub fn healthcareservice_create_req(
  resource: r4.Healthcareservice,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.healthcareservice_to_json(resource),
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
  resource: r4.Healthcareservice,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.healthcareservice_to_json(resource),
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
) -> Result(r4.Healthcareservice, Err) {
  any_resp(resp, r4.healthcareservice_decoder())
}

pub fn imagingstudy_create_req(
  resource: r4.Imagingstudy,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.imagingstudy_to_json(resource), "ImagingStudy", client)
}

pub fn imagingstudy_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "ImagingStudy", client)
}

pub fn imagingstudy_update_req(
  resource: r4.Imagingstudy,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.imagingstudy_to_json(resource),
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

pub fn imagingstudy_resp(resp: Response(String)) -> Result(r4.Imagingstudy, Err) {
  any_resp(resp, r4.imagingstudy_decoder())
}

pub fn immunization_create_req(
  resource: r4.Immunization,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.immunization_to_json(resource), "Immunization", client)
}

pub fn immunization_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Immunization", client)
}

pub fn immunization_update_req(
  resource: r4.Immunization,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.immunization_to_json(resource),
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

pub fn immunization_resp(resp: Response(String)) -> Result(r4.Immunization, Err) {
  any_resp(resp, r4.immunization_decoder())
}

pub fn immunizationevaluation_create_req(
  resource: r4.Immunizationevaluation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.immunizationevaluation_to_json(resource),
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
  resource: r4.Immunizationevaluation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.immunizationevaluation_to_json(resource),
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
) -> Result(r4.Immunizationevaluation, Err) {
  any_resp(resp, r4.immunizationevaluation_decoder())
}

pub fn immunizationrecommendation_create_req(
  resource: r4.Immunizationrecommendation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.immunizationrecommendation_to_json(resource),
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
  resource: r4.Immunizationrecommendation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.immunizationrecommendation_to_json(resource),
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
) -> Result(r4.Immunizationrecommendation, Err) {
  any_resp(resp, r4.immunizationrecommendation_decoder())
}

pub fn implementationguide_create_req(
  resource: r4.Implementationguide,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.implementationguide_to_json(resource),
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
  resource: r4.Implementationguide,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.implementationguide_to_json(resource),
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
) -> Result(r4.Implementationguide, Err) {
  any_resp(resp, r4.implementationguide_decoder())
}

pub fn insuranceplan_create_req(
  resource: r4.Insuranceplan,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.insuranceplan_to_json(resource), "InsurancePlan", client)
}

pub fn insuranceplan_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "InsurancePlan", client)
}

pub fn insuranceplan_update_req(
  resource: r4.Insuranceplan,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.insuranceplan_to_json(resource),
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
) -> Result(r4.Insuranceplan, Err) {
  any_resp(resp, r4.insuranceplan_decoder())
}

pub fn invoice_create_req(
  resource: r4.Invoice,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.invoice_to_json(resource), "Invoice", client)
}

pub fn invoice_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Invoice", client)
}

pub fn invoice_update_req(
  resource: r4.Invoice,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.invoice_to_json(resource), "Invoice", client)
}

pub fn invoice_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Invoice", client)
}

pub fn invoice_resp(resp: Response(String)) -> Result(r4.Invoice, Err) {
  any_resp(resp, r4.invoice_decoder())
}

pub fn library_create_req(
  resource: r4.Library,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.library_to_json(resource), "Library", client)
}

pub fn library_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Library", client)
}

pub fn library_update_req(
  resource: r4.Library,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.library_to_json(resource), "Library", client)
}

pub fn library_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Library", client)
}

pub fn library_resp(resp: Response(String)) -> Result(r4.Library, Err) {
  any_resp(resp, r4.library_decoder())
}

pub fn linkage_create_req(
  resource: r4.Linkage,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.linkage_to_json(resource), "Linkage", client)
}

pub fn linkage_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Linkage", client)
}

pub fn linkage_update_req(
  resource: r4.Linkage,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.linkage_to_json(resource), "Linkage", client)
}

pub fn linkage_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Linkage", client)
}

pub fn linkage_resp(resp: Response(String)) -> Result(r4.Linkage, Err) {
  any_resp(resp, r4.linkage_decoder())
}

pub fn listfhir_create_req(
  resource: r4.Listfhir,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.listfhir_to_json(resource), "List", client)
}

pub fn listfhir_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "List", client)
}

pub fn listfhir_update_req(
  resource: r4.Listfhir,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.listfhir_to_json(resource), "List", client)
}

pub fn listfhir_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "List", client)
}

pub fn listfhir_resp(resp: Response(String)) -> Result(r4.Listfhir, Err) {
  any_resp(resp, r4.listfhir_decoder())
}

pub fn location_create_req(
  resource: r4.Location,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.location_to_json(resource), "Location", client)
}

pub fn location_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Location", client)
}

pub fn location_update_req(
  resource: r4.Location,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.location_to_json(resource), "Location", client)
}

pub fn location_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Location", client)
}

pub fn location_resp(resp: Response(String)) -> Result(r4.Location, Err) {
  any_resp(resp, r4.location_decoder())
}

pub fn measure_create_req(
  resource: r4.Measure,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.measure_to_json(resource), "Measure", client)
}

pub fn measure_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Measure", client)
}

pub fn measure_update_req(
  resource: r4.Measure,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.measure_to_json(resource), "Measure", client)
}

pub fn measure_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Measure", client)
}

pub fn measure_resp(resp: Response(String)) -> Result(r4.Measure, Err) {
  any_resp(resp, r4.measure_decoder())
}

pub fn measurereport_create_req(
  resource: r4.Measurereport,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.measurereport_to_json(resource), "MeasureReport", client)
}

pub fn measurereport_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "MeasureReport", client)
}

pub fn measurereport_update_req(
  resource: r4.Measurereport,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.measurereport_to_json(resource),
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
) -> Result(r4.Measurereport, Err) {
  any_resp(resp, r4.measurereport_decoder())
}

pub fn media_create_req(
  resource: r4.Media,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.media_to_json(resource), "Media", client)
}

pub fn media_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Media", client)
}

pub fn media_update_req(
  resource: r4.Media,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.media_to_json(resource), "Media", client)
}

pub fn media_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Media", client)
}

pub fn media_resp(resp: Response(String)) -> Result(r4.Media, Err) {
  any_resp(resp, r4.media_decoder())
}

pub fn medication_create_req(
  resource: r4.Medication,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.medication_to_json(resource), "Medication", client)
}

pub fn medication_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Medication", client)
}

pub fn medication_update_req(
  resource: r4.Medication,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.medication_to_json(resource),
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

pub fn medication_resp(resp: Response(String)) -> Result(r4.Medication, Err) {
  any_resp(resp, r4.medication_decoder())
}

pub fn medicationadministration_create_req(
  resource: r4.Medicationadministration,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.medicationadministration_to_json(resource),
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
  resource: r4.Medicationadministration,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.medicationadministration_to_json(resource),
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
) -> Result(r4.Medicationadministration, Err) {
  any_resp(resp, r4.medicationadministration_decoder())
}

pub fn medicationdispense_create_req(
  resource: r4.Medicationdispense,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.medicationdispense_to_json(resource),
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
  resource: r4.Medicationdispense,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.medicationdispense_to_json(resource),
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
) -> Result(r4.Medicationdispense, Err) {
  any_resp(resp, r4.medicationdispense_decoder())
}

pub fn medicationknowledge_create_req(
  resource: r4.Medicationknowledge,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.medicationknowledge_to_json(resource),
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
  resource: r4.Medicationknowledge,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.medicationknowledge_to_json(resource),
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
) -> Result(r4.Medicationknowledge, Err) {
  any_resp(resp, r4.medicationknowledge_decoder())
}

pub fn medicationrequest_create_req(
  resource: r4.Medicationrequest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.medicationrequest_to_json(resource),
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
  resource: r4.Medicationrequest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.medicationrequest_to_json(resource),
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
) -> Result(r4.Medicationrequest, Err) {
  any_resp(resp, r4.medicationrequest_decoder())
}

pub fn medicationstatement_create_req(
  resource: r4.Medicationstatement,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.medicationstatement_to_json(resource),
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
  resource: r4.Medicationstatement,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.medicationstatement_to_json(resource),
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
) -> Result(r4.Medicationstatement, Err) {
  any_resp(resp, r4.medicationstatement_decoder())
}

pub fn medicinalproduct_create_req(
  resource: r4.Medicinalproduct,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.medicinalproduct_to_json(resource),
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
  resource: r4.Medicinalproduct,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.medicinalproduct_to_json(resource),
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
) -> Result(r4.Medicinalproduct, Err) {
  any_resp(resp, r4.medicinalproduct_decoder())
}

pub fn medicinalproductauthorization_create_req(
  resource: r4.Medicinalproductauthorization,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.medicinalproductauthorization_to_json(resource),
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
  resource: r4.Medicinalproductauthorization,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.medicinalproductauthorization_to_json(resource),
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
) -> Result(r4.Medicinalproductauthorization, Err) {
  any_resp(resp, r4.medicinalproductauthorization_decoder())
}

pub fn medicinalproductcontraindication_create_req(
  resource: r4.Medicinalproductcontraindication,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.medicinalproductcontraindication_to_json(resource),
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
  resource: r4.Medicinalproductcontraindication,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.medicinalproductcontraindication_to_json(resource),
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
) -> Result(r4.Medicinalproductcontraindication, Err) {
  any_resp(resp, r4.medicinalproductcontraindication_decoder())
}

pub fn medicinalproductindication_create_req(
  resource: r4.Medicinalproductindication,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.medicinalproductindication_to_json(resource),
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
  resource: r4.Medicinalproductindication,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.medicinalproductindication_to_json(resource),
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
) -> Result(r4.Medicinalproductindication, Err) {
  any_resp(resp, r4.medicinalproductindication_decoder())
}

pub fn medicinalproductingredient_create_req(
  resource: r4.Medicinalproductingredient,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.medicinalproductingredient_to_json(resource),
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
  resource: r4.Medicinalproductingredient,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.medicinalproductingredient_to_json(resource),
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
) -> Result(r4.Medicinalproductingredient, Err) {
  any_resp(resp, r4.medicinalproductingredient_decoder())
}

pub fn medicinalproductinteraction_create_req(
  resource: r4.Medicinalproductinteraction,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.medicinalproductinteraction_to_json(resource),
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
  resource: r4.Medicinalproductinteraction,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.medicinalproductinteraction_to_json(resource),
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
) -> Result(r4.Medicinalproductinteraction, Err) {
  any_resp(resp, r4.medicinalproductinteraction_decoder())
}

pub fn medicinalproductmanufactured_create_req(
  resource: r4.Medicinalproductmanufactured,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.medicinalproductmanufactured_to_json(resource),
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
  resource: r4.Medicinalproductmanufactured,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.medicinalproductmanufactured_to_json(resource),
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
) -> Result(r4.Medicinalproductmanufactured, Err) {
  any_resp(resp, r4.medicinalproductmanufactured_decoder())
}

pub fn medicinalproductpackaged_create_req(
  resource: r4.Medicinalproductpackaged,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.medicinalproductpackaged_to_json(resource),
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
  resource: r4.Medicinalproductpackaged,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.medicinalproductpackaged_to_json(resource),
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
) -> Result(r4.Medicinalproductpackaged, Err) {
  any_resp(resp, r4.medicinalproductpackaged_decoder())
}

pub fn medicinalproductpharmaceutical_create_req(
  resource: r4.Medicinalproductpharmaceutical,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.medicinalproductpharmaceutical_to_json(resource),
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
  resource: r4.Medicinalproductpharmaceutical,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.medicinalproductpharmaceutical_to_json(resource),
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
) -> Result(r4.Medicinalproductpharmaceutical, Err) {
  any_resp(resp, r4.medicinalproductpharmaceutical_decoder())
}

pub fn medicinalproductundesirableeffect_create_req(
  resource: r4.Medicinalproductundesirableeffect,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.medicinalproductundesirableeffect_to_json(resource),
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
  resource: r4.Medicinalproductundesirableeffect,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.medicinalproductundesirableeffect_to_json(resource),
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
) -> Result(r4.Medicinalproductundesirableeffect, Err) {
  any_resp(resp, r4.medicinalproductundesirableeffect_decoder())
}

pub fn messagedefinition_create_req(
  resource: r4.Messagedefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.messagedefinition_to_json(resource),
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
  resource: r4.Messagedefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.messagedefinition_to_json(resource),
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
) -> Result(r4.Messagedefinition, Err) {
  any_resp(resp, r4.messagedefinition_decoder())
}

pub fn messageheader_create_req(
  resource: r4.Messageheader,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.messageheader_to_json(resource), "MessageHeader", client)
}

pub fn messageheader_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "MessageHeader", client)
}

pub fn messageheader_update_req(
  resource: r4.Messageheader,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.messageheader_to_json(resource),
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
) -> Result(r4.Messageheader, Err) {
  any_resp(resp, r4.messageheader_decoder())
}

pub fn molecularsequence_create_req(
  resource: r4.Molecularsequence,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.molecularsequence_to_json(resource),
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
  resource: r4.Molecularsequence,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.molecularsequence_to_json(resource),
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
) -> Result(r4.Molecularsequence, Err) {
  any_resp(resp, r4.molecularsequence_decoder())
}

pub fn namingsystem_create_req(
  resource: r4.Namingsystem,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.namingsystem_to_json(resource), "NamingSystem", client)
}

pub fn namingsystem_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "NamingSystem", client)
}

pub fn namingsystem_update_req(
  resource: r4.Namingsystem,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.namingsystem_to_json(resource),
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

pub fn namingsystem_resp(resp: Response(String)) -> Result(r4.Namingsystem, Err) {
  any_resp(resp, r4.namingsystem_decoder())
}

pub fn nutritionorder_create_req(
  resource: r4.Nutritionorder,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.nutritionorder_to_json(resource), "NutritionOrder", client)
}

pub fn nutritionorder_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "NutritionOrder", client)
}

pub fn nutritionorder_update_req(
  resource: r4.Nutritionorder,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.nutritionorder_to_json(resource),
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
) -> Result(r4.Nutritionorder, Err) {
  any_resp(resp, r4.nutritionorder_decoder())
}

pub fn observation_create_req(
  resource: r4.Observation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.observation_to_json(resource), "Observation", client)
}

pub fn observation_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Observation", client)
}

pub fn observation_update_req(
  resource: r4.Observation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.observation_to_json(resource),
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

pub fn observation_resp(resp: Response(String)) -> Result(r4.Observation, Err) {
  any_resp(resp, r4.observation_decoder())
}

pub fn observationdefinition_create_req(
  resource: r4.Observationdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.observationdefinition_to_json(resource),
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
  resource: r4.Observationdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.observationdefinition_to_json(resource),
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
) -> Result(r4.Observationdefinition, Err) {
  any_resp(resp, r4.observationdefinition_decoder())
}

pub fn operationdefinition_create_req(
  resource: r4.Operationdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.operationdefinition_to_json(resource),
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
  resource: r4.Operationdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.operationdefinition_to_json(resource),
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
) -> Result(r4.Operationdefinition, Err) {
  any_resp(resp, r4.operationdefinition_decoder())
}

pub fn operationoutcome_create_req(
  resource: r4.Operationoutcome,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.operationoutcome_to_json(resource),
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
  resource: r4.Operationoutcome,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.operationoutcome_to_json(resource),
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
) -> Result(r4.Operationoutcome, Err) {
  any_resp(resp, r4.operationoutcome_decoder())
}

pub fn organization_create_req(
  resource: r4.Organization,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.organization_to_json(resource), "Organization", client)
}

pub fn organization_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Organization", client)
}

pub fn organization_update_req(
  resource: r4.Organization,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.organization_to_json(resource),
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

pub fn organization_resp(resp: Response(String)) -> Result(r4.Organization, Err) {
  any_resp(resp, r4.organization_decoder())
}

pub fn organizationaffiliation_create_req(
  resource: r4.Organizationaffiliation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.organizationaffiliation_to_json(resource),
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
  resource: r4.Organizationaffiliation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.organizationaffiliation_to_json(resource),
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
) -> Result(r4.Organizationaffiliation, Err) {
  any_resp(resp, r4.organizationaffiliation_decoder())
}

pub fn patient_create_req(
  resource: r4.Patient,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.patient_to_json(resource), "Patient", client)
}

pub fn patient_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Patient", client)
}

pub fn patient_update_req(
  resource: r4.Patient,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.patient_to_json(resource), "Patient", client)
}

pub fn patient_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Patient", client)
}

pub fn patient_resp(resp: Response(String)) -> Result(r4.Patient, Err) {
  any_resp(resp, r4.patient_decoder())
}

pub fn paymentnotice_create_req(
  resource: r4.Paymentnotice,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.paymentnotice_to_json(resource), "PaymentNotice", client)
}

pub fn paymentnotice_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "PaymentNotice", client)
}

pub fn paymentnotice_update_req(
  resource: r4.Paymentnotice,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.paymentnotice_to_json(resource),
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
) -> Result(r4.Paymentnotice, Err) {
  any_resp(resp, r4.paymentnotice_decoder())
}

pub fn paymentreconciliation_create_req(
  resource: r4.Paymentreconciliation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.paymentreconciliation_to_json(resource),
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
  resource: r4.Paymentreconciliation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.paymentreconciliation_to_json(resource),
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
) -> Result(r4.Paymentreconciliation, Err) {
  any_resp(resp, r4.paymentreconciliation_decoder())
}

pub fn person_create_req(
  resource: r4.Person,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.person_to_json(resource), "Person", client)
}

pub fn person_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Person", client)
}

pub fn person_update_req(
  resource: r4.Person,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.person_to_json(resource), "Person", client)
}

pub fn person_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Person", client)
}

pub fn person_resp(resp: Response(String)) -> Result(r4.Person, Err) {
  any_resp(resp, r4.person_decoder())
}

pub fn plandefinition_create_req(
  resource: r4.Plandefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.plandefinition_to_json(resource), "PlanDefinition", client)
}

pub fn plandefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "PlanDefinition", client)
}

pub fn plandefinition_update_req(
  resource: r4.Plandefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.plandefinition_to_json(resource),
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
) -> Result(r4.Plandefinition, Err) {
  any_resp(resp, r4.plandefinition_decoder())
}

pub fn practitioner_create_req(
  resource: r4.Practitioner,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.practitioner_to_json(resource), "Practitioner", client)
}

pub fn practitioner_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Practitioner", client)
}

pub fn practitioner_update_req(
  resource: r4.Practitioner,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.practitioner_to_json(resource),
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

pub fn practitioner_resp(resp: Response(String)) -> Result(r4.Practitioner, Err) {
  any_resp(resp, r4.practitioner_decoder())
}

pub fn practitionerrole_create_req(
  resource: r4.Practitionerrole,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.practitionerrole_to_json(resource),
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
  resource: r4.Practitionerrole,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.practitionerrole_to_json(resource),
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
) -> Result(r4.Practitionerrole, Err) {
  any_resp(resp, r4.practitionerrole_decoder())
}

pub fn procedure_create_req(
  resource: r4.Procedure,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.procedure_to_json(resource), "Procedure", client)
}

pub fn procedure_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Procedure", client)
}

pub fn procedure_update_req(
  resource: r4.Procedure,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.procedure_to_json(resource),
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

pub fn procedure_resp(resp: Response(String)) -> Result(r4.Procedure, Err) {
  any_resp(resp, r4.procedure_decoder())
}

pub fn provenance_create_req(
  resource: r4.Provenance,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.provenance_to_json(resource), "Provenance", client)
}

pub fn provenance_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Provenance", client)
}

pub fn provenance_update_req(
  resource: r4.Provenance,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.provenance_to_json(resource),
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

pub fn provenance_resp(resp: Response(String)) -> Result(r4.Provenance, Err) {
  any_resp(resp, r4.provenance_decoder())
}

pub fn questionnaire_create_req(
  resource: r4.Questionnaire,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.questionnaire_to_json(resource), "Questionnaire", client)
}

pub fn questionnaire_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Questionnaire", client)
}

pub fn questionnaire_update_req(
  resource: r4.Questionnaire,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.questionnaire_to_json(resource),
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
) -> Result(r4.Questionnaire, Err) {
  any_resp(resp, r4.questionnaire_decoder())
}

pub fn questionnaireresponse_create_req(
  resource: r4.Questionnaireresponse,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.questionnaireresponse_to_json(resource),
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
  resource: r4.Questionnaireresponse,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.questionnaireresponse_to_json(resource),
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
) -> Result(r4.Questionnaireresponse, Err) {
  any_resp(resp, r4.questionnaireresponse_decoder())
}

pub fn relatedperson_create_req(
  resource: r4.Relatedperson,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.relatedperson_to_json(resource), "RelatedPerson", client)
}

pub fn relatedperson_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "RelatedPerson", client)
}

pub fn relatedperson_update_req(
  resource: r4.Relatedperson,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.relatedperson_to_json(resource),
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
) -> Result(r4.Relatedperson, Err) {
  any_resp(resp, r4.relatedperson_decoder())
}

pub fn requestgroup_create_req(
  resource: r4.Requestgroup,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.requestgroup_to_json(resource), "RequestGroup", client)
}

pub fn requestgroup_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "RequestGroup", client)
}

pub fn requestgroup_update_req(
  resource: r4.Requestgroup,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.requestgroup_to_json(resource),
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

pub fn requestgroup_resp(resp: Response(String)) -> Result(r4.Requestgroup, Err) {
  any_resp(resp, r4.requestgroup_decoder())
}

pub fn researchdefinition_create_req(
  resource: r4.Researchdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.researchdefinition_to_json(resource),
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
  resource: r4.Researchdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.researchdefinition_to_json(resource),
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
) -> Result(r4.Researchdefinition, Err) {
  any_resp(resp, r4.researchdefinition_decoder())
}

pub fn researchelementdefinition_create_req(
  resource: r4.Researchelementdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.researchelementdefinition_to_json(resource),
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
  resource: r4.Researchelementdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.researchelementdefinition_to_json(resource),
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
) -> Result(r4.Researchelementdefinition, Err) {
  any_resp(resp, r4.researchelementdefinition_decoder())
}

pub fn researchstudy_create_req(
  resource: r4.Researchstudy,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.researchstudy_to_json(resource), "ResearchStudy", client)
}

pub fn researchstudy_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "ResearchStudy", client)
}

pub fn researchstudy_update_req(
  resource: r4.Researchstudy,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.researchstudy_to_json(resource),
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
) -> Result(r4.Researchstudy, Err) {
  any_resp(resp, r4.researchstudy_decoder())
}

pub fn researchsubject_create_req(
  resource: r4.Researchsubject,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.researchsubject_to_json(resource),
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
  resource: r4.Researchsubject,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.researchsubject_to_json(resource),
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
) -> Result(r4.Researchsubject, Err) {
  any_resp(resp, r4.researchsubject_decoder())
}

pub fn riskassessment_create_req(
  resource: r4.Riskassessment,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.riskassessment_to_json(resource), "RiskAssessment", client)
}

pub fn riskassessment_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "RiskAssessment", client)
}

pub fn riskassessment_update_req(
  resource: r4.Riskassessment,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.riskassessment_to_json(resource),
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
) -> Result(r4.Riskassessment, Err) {
  any_resp(resp, r4.riskassessment_decoder())
}

pub fn riskevidencesynthesis_create_req(
  resource: r4.Riskevidencesynthesis,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.riskevidencesynthesis_to_json(resource),
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
  resource: r4.Riskevidencesynthesis,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.riskevidencesynthesis_to_json(resource),
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
) -> Result(r4.Riskevidencesynthesis, Err) {
  any_resp(resp, r4.riskevidencesynthesis_decoder())
}

pub fn schedule_create_req(
  resource: r4.Schedule,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.schedule_to_json(resource), "Schedule", client)
}

pub fn schedule_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Schedule", client)
}

pub fn schedule_update_req(
  resource: r4.Schedule,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.schedule_to_json(resource), "Schedule", client)
}

pub fn schedule_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Schedule", client)
}

pub fn schedule_resp(resp: Response(String)) -> Result(r4.Schedule, Err) {
  any_resp(resp, r4.schedule_decoder())
}

pub fn searchparameter_create_req(
  resource: r4.Searchparameter,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.searchparameter_to_json(resource),
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
  resource: r4.Searchparameter,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.searchparameter_to_json(resource),
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
) -> Result(r4.Searchparameter, Err) {
  any_resp(resp, r4.searchparameter_decoder())
}

pub fn servicerequest_create_req(
  resource: r4.Servicerequest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.servicerequest_to_json(resource), "ServiceRequest", client)
}

pub fn servicerequest_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "ServiceRequest", client)
}

pub fn servicerequest_update_req(
  resource: r4.Servicerequest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.servicerequest_to_json(resource),
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
) -> Result(r4.Servicerequest, Err) {
  any_resp(resp, r4.servicerequest_decoder())
}

pub fn slot_create_req(resource: r4.Slot, client: FhirClient) -> Request(String) {
  any_create_req(r4.slot_to_json(resource), "Slot", client)
}

pub fn slot_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Slot", client)
}

pub fn slot_update_req(
  resource: r4.Slot,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.slot_to_json(resource), "Slot", client)
}

pub fn slot_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Slot", client)
}

pub fn slot_resp(resp: Response(String)) -> Result(r4.Slot, Err) {
  any_resp(resp, r4.slot_decoder())
}

pub fn specimen_create_req(
  resource: r4.Specimen,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.specimen_to_json(resource), "Specimen", client)
}

pub fn specimen_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Specimen", client)
}

pub fn specimen_update_req(
  resource: r4.Specimen,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.specimen_to_json(resource), "Specimen", client)
}

pub fn specimen_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Specimen", client)
}

pub fn specimen_resp(resp: Response(String)) -> Result(r4.Specimen, Err) {
  any_resp(resp, r4.specimen_decoder())
}

pub fn specimendefinition_create_req(
  resource: r4.Specimendefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.specimendefinition_to_json(resource),
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
  resource: r4.Specimendefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.specimendefinition_to_json(resource),
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
) -> Result(r4.Specimendefinition, Err) {
  any_resp(resp, r4.specimendefinition_decoder())
}

pub fn structuredefinition_create_req(
  resource: r4.Structuredefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.structuredefinition_to_json(resource),
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
  resource: r4.Structuredefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.structuredefinition_to_json(resource),
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
) -> Result(r4.Structuredefinition, Err) {
  any_resp(resp, r4.structuredefinition_decoder())
}

pub fn structuremap_create_req(
  resource: r4.Structuremap,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.structuremap_to_json(resource), "StructureMap", client)
}

pub fn structuremap_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "StructureMap", client)
}

pub fn structuremap_update_req(
  resource: r4.Structuremap,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.structuremap_to_json(resource),
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

pub fn structuremap_resp(resp: Response(String)) -> Result(r4.Structuremap, Err) {
  any_resp(resp, r4.structuremap_decoder())
}

pub fn subscription_create_req(
  resource: r4.Subscription,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.subscription_to_json(resource), "Subscription", client)
}

pub fn subscription_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Subscription", client)
}

pub fn subscription_update_req(
  resource: r4.Subscription,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.subscription_to_json(resource),
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

pub fn subscription_resp(resp: Response(String)) -> Result(r4.Subscription, Err) {
  any_resp(resp, r4.subscription_decoder())
}

pub fn substance_create_req(
  resource: r4.Substance,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.substance_to_json(resource), "Substance", client)
}

pub fn substance_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Substance", client)
}

pub fn substance_update_req(
  resource: r4.Substance,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.substance_to_json(resource),
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

pub fn substance_resp(resp: Response(String)) -> Result(r4.Substance, Err) {
  any_resp(resp, r4.substance_decoder())
}

pub fn substancenucleicacid_create_req(
  resource: r4.Substancenucleicacid,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.substancenucleicacid_to_json(resource),
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
  resource: r4.Substancenucleicacid,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.substancenucleicacid_to_json(resource),
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
) -> Result(r4.Substancenucleicacid, Err) {
  any_resp(resp, r4.substancenucleicacid_decoder())
}

pub fn substancepolymer_create_req(
  resource: r4.Substancepolymer,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.substancepolymer_to_json(resource),
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
  resource: r4.Substancepolymer,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.substancepolymer_to_json(resource),
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
) -> Result(r4.Substancepolymer, Err) {
  any_resp(resp, r4.substancepolymer_decoder())
}

pub fn substanceprotein_create_req(
  resource: r4.Substanceprotein,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.substanceprotein_to_json(resource),
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
  resource: r4.Substanceprotein,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.substanceprotein_to_json(resource),
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
) -> Result(r4.Substanceprotein, Err) {
  any_resp(resp, r4.substanceprotein_decoder())
}

pub fn substancereferenceinformation_create_req(
  resource: r4.Substancereferenceinformation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.substancereferenceinformation_to_json(resource),
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
  resource: r4.Substancereferenceinformation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.substancereferenceinformation_to_json(resource),
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
) -> Result(r4.Substancereferenceinformation, Err) {
  any_resp(resp, r4.substancereferenceinformation_decoder())
}

pub fn substancesourcematerial_create_req(
  resource: r4.Substancesourcematerial,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.substancesourcematerial_to_json(resource),
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
  resource: r4.Substancesourcematerial,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.substancesourcematerial_to_json(resource),
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
) -> Result(r4.Substancesourcematerial, Err) {
  any_resp(resp, r4.substancesourcematerial_decoder())
}

pub fn substancespecification_create_req(
  resource: r4.Substancespecification,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.substancespecification_to_json(resource),
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
  resource: r4.Substancespecification,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.substancespecification_to_json(resource),
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
) -> Result(r4.Substancespecification, Err) {
  any_resp(resp, r4.substancespecification_decoder())
}

pub fn supplydelivery_create_req(
  resource: r4.Supplydelivery,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.supplydelivery_to_json(resource), "SupplyDelivery", client)
}

pub fn supplydelivery_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "SupplyDelivery", client)
}

pub fn supplydelivery_update_req(
  resource: r4.Supplydelivery,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.supplydelivery_to_json(resource),
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
) -> Result(r4.Supplydelivery, Err) {
  any_resp(resp, r4.supplydelivery_decoder())
}

pub fn supplyrequest_create_req(
  resource: r4.Supplyrequest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.supplyrequest_to_json(resource), "SupplyRequest", client)
}

pub fn supplyrequest_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "SupplyRequest", client)
}

pub fn supplyrequest_update_req(
  resource: r4.Supplyrequest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.supplyrequest_to_json(resource),
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
) -> Result(r4.Supplyrequest, Err) {
  any_resp(resp, r4.supplyrequest_decoder())
}

pub fn task_create_req(resource: r4.Task, client: FhirClient) -> Request(String) {
  any_create_req(r4.task_to_json(resource), "Task", client)
}

pub fn task_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Task", client)
}

pub fn task_update_req(
  resource: r4.Task,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.task_to_json(resource), "Task", client)
}

pub fn task_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Task", client)
}

pub fn task_resp(resp: Response(String)) -> Result(r4.Task, Err) {
  any_resp(resp, r4.task_decoder())
}

pub fn terminologycapabilities_create_req(
  resource: r4.Terminologycapabilities,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.terminologycapabilities_to_json(resource),
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
  resource: r4.Terminologycapabilities,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.terminologycapabilities_to_json(resource),
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
) -> Result(r4.Terminologycapabilities, Err) {
  any_resp(resp, r4.terminologycapabilities_decoder())
}

pub fn testreport_create_req(
  resource: r4.Testreport,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.testreport_to_json(resource), "TestReport", client)
}

pub fn testreport_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "TestReport", client)
}

pub fn testreport_update_req(
  resource: r4.Testreport,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.testreport_to_json(resource),
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

pub fn testreport_resp(resp: Response(String)) -> Result(r4.Testreport, Err) {
  any_resp(resp, r4.testreport_decoder())
}

pub fn testscript_create_req(
  resource: r4.Testscript,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.testscript_to_json(resource), "TestScript", client)
}

pub fn testscript_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "TestScript", client)
}

pub fn testscript_update_req(
  resource: r4.Testscript,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.testscript_to_json(resource),
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

pub fn testscript_resp(resp: Response(String)) -> Result(r4.Testscript, Err) {
  any_resp(resp, r4.testscript_decoder())
}

pub fn valueset_create_req(
  resource: r4.Valueset,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.valueset_to_json(resource), "ValueSet", client)
}

pub fn valueset_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "ValueSet", client)
}

pub fn valueset_update_req(
  resource: r4.Valueset,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r4.valueset_to_json(resource), "ValueSet", client)
}

pub fn valueset_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "ValueSet", client)
}

pub fn valueset_resp(resp: Response(String)) -> Result(r4.Valueset, Err) {
  any_resp(resp, r4.valueset_decoder())
}

pub fn verificationresult_create_req(
  resource: r4.Verificationresult,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.verificationresult_to_json(resource),
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
  resource: r4.Verificationresult,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.verificationresult_to_json(resource),
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
) -> Result(r4.Verificationresult, Err) {
  any_resp(resp, r4.verificationresult_decoder())
}

pub fn visionprescription_create_req(
  resource: r4.Visionprescription,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r4.visionprescription_to_json(resource),
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
  resource: r4.Visionprescription,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.visionprescription_to_json(resource),
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
) -> Result(r4.Visionprescription, Err) {
  any_resp(resp, r4.visionprescription_decoder())
}

pub type SpAccount {
  SpAccount(
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
    severity: Option(String),
    date: Option(String),
    identifier: Option(String),
    manifestation: Option(String),
    recorder: Option(String),
    code: Option(String),
    verification_status: Option(String),
    criticality: Option(String),
    clinical_status: Option(String),
    type_: Option(String),
    onset: Option(String),
    route: Option(String),
    asserter: Option(String),
    patient: Option(String),
    category: Option(String),
    last_date: Option(String),
  )
}

pub type SpAppointment {
  SpAppointment(
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
    identifier: Option(String),
    code: Option(String),
    subject: Option(String),
    created: Option(String),
    patient: Option(String),
    author: Option(String),
  )
}

pub type SpBinary {
  SpBinary(include: Option(SpInclude))
}

pub type SpBiologicallyderivedproduct {
  SpBiologicallyderivedproduct(include: Option(SpInclude))
}

pub type SpBodystructure {
  SpBodystructure(
    include: Option(SpInclude),
    identifier: Option(String),
    morphology: Option(String),
    patient: Option(String),
    location: Option(String),
  )
}

pub type SpBundle {
  SpBundle(
    include: Option(SpInclude),
    identifier: Option(String),
    composition: Option(String),
    type_: Option(String),
    message: Option(String),
    timestamp: Option(String),
  )
}

pub type SpCapabilitystatement {
  SpCapabilitystatement(
    include: Option(SpInclude),
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

pub type SpCareplan {
  SpCareplan(
    include: Option(SpInclude),
    date: Option(String),
    care_team: Option(String),
    identifier: Option(String),
    performer: Option(String),
    goal: Option(String),
    subject: Option(String),
    replaces: Option(String),
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
    include: Option(SpInclude),
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
  SpCatalogentry(include: Option(SpInclude))
}

pub type SpChargeitem {
  SpChargeitem(
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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

pub type SpCondition {
  SpCondition(
    include: Option(SpInclude),
    severity: Option(String),
    evidence_detail: Option(String),
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
    onset_age: Option(String),
    abatement_age: Option(String),
    category: Option(String),
    body_site: Option(String),
  )
}

pub type SpConsent {
  SpConsent(
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
    identifier: Option(String),
    payor: Option(String),
    subscriber: Option(String),
    beneficiary: Option(String),
    patient: Option(String),
    class_value: Option(String),
    type_: Option(String),
    dependent: Option(String),
    class_type: Option(String),
    policy_holder: Option(String),
    status: Option(String),
  )
}

pub type SpCoverageeligibilityrequest {
  SpCoverageeligibilityrequest(
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
    identifier: Option(String),
    code: Option(String),
    identified: Option(String),
    patient: Option(String),
    author: Option(String),
    implicated: Option(String),
  )
}

pub type SpDevice {
  SpDevice(
    include: Option(SpInclude),
    udi_di: Option(String),
    identifier: Option(String),
    udi_carrier: Option(String),
    device_name: Option(String),
    patient: Option(String),
    organization: Option(String),
    model: Option(String),
    location: Option(String),
    type_: Option(String),
    url: Option(String),
    manufacturer: Option(String),
    status: Option(String),
  )
}

pub type SpDevicedefinition {
  SpDevicedefinition(
    include: Option(SpInclude),
    parent: Option(String),
    identifier: Option(String),
    type_: Option(String),
  )
}

pub type SpDevicemetric {
  SpDevicemetric(
    include: Option(SpInclude),
    parent: Option(String),
    identifier: Option(String),
    source: Option(String),
    type_: Option(String),
    category: Option(String),
  )
}

pub type SpDevicerequest {
  SpDevicerequest(
    include: Option(SpInclude),
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
    include: Option(SpInclude),
    identifier: Option(String),
    subject: Option(String),
    patient: Option(String),
    device: Option(String),
  )
}

pub type SpDiagnosticreport {
  SpDiagnosticreport(
    include: Option(SpInclude),
    date: Option(String),
    identifier: Option(String),
    performer: Option(String),
    code: Option(String),
    subject: Option(String),
    media: Option(String),
    encounter: Option(String),
    result: Option(String),
    conclusion: Option(String),
    based_on: Option(String),
    patient: Option(String),
    specimen: Option(String),
    issued: Option(String),
    category: Option(String),
    results_interpreter: Option(String),
    status: Option(String),
  )
}

pub type SpDocumentmanifest {
  SpDocumentmanifest(
    include: Option(SpInclude),
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

pub type SpDocumentreference {
  SpDocumentreference(
    include: Option(SpInclude),
    date: Option(String),
    subject: Option(String),
    description: Option(String),
    language: Option(String),
    type_: Option(String),
    relation: Option(String),
    setting: Option(String),
    related: Option(String),
    patient: Option(String),
    relationship: Option(String),
    event: Option(String),
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

pub type SpEffectevidencesynthesis {
  SpEffectevidencesynthesis(
    include: Option(SpInclude),
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

pub type SpEncounter {
  SpEncounter(
    include: Option(SpInclude),
    date: Option(String),
    identifier: Option(String),
    participant_type: Option(String),
    practitioner: Option(String),
    subject: Option(String),
    length: Option(String),
    episode_of_care: Option(String),
    diagnosis: Option(String),
    appointment: Option(String),
    part_of: Option(String),
    type_: Option(String),
    reason_code: Option(String),
    participant: Option(String),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
    identifier: Option(String),
    subject: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type SpEnrollmentresponse {
  SpEnrollmentresponse(
    include: Option(SpInclude),
    identifier: Option(String),
    request: Option(String),
    status: Option(String),
  )
}

pub type SpEpisodeofcare {
  SpEpisodeofcare(
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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

pub type SpFamilymemberhistory {
  SpFamilymemberhistory(
    include: Option(SpInclude),
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
    include: Option(SpInclude),
    date: Option(String),
    identifier: Option(String),
    subject: Option(String),
    patient: Option(String),
    author: Option(String),
    encounter: Option(String),
  )
}

pub type SpGoal {
  SpGoal(
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
    request: Option(String),
    identifier: Option(String),
    patient: Option(String),
    subject: Option(String),
  )
}

pub type SpHealthcareservice {
  SpHealthcareservice(
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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

pub type SpImmunization {
  SpImmunization(
    include: Option(SpInclude),
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
    status: Option(String),
    reaction_date: Option(String),
  )
}

pub type SpImmunizationevaluation {
  SpImmunizationevaluation(
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
    item: Option(String),
    author: Option(String),
    source: Option(String),
  )
}

pub type SpListfhir {
  SpListfhir(
    include: Option(SpInclude),
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

pub type SpLocation {
  SpLocation(
    include: Option(SpInclude),
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
    name: Option(String),
    address_use: Option(String),
    near: Option(String),
    address_city: Option(String),
    status: Option(String),
  )
}

pub type SpMeasure {
  SpMeasure(
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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

pub type SpMedication {
  SpMedication(
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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

pub type SpMedicationdispense {
  SpMedicationdispense(
    include: Option(SpInclude),
    identifier: Option(String),
    performer: Option(String),
    code: Option(String),
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
    include: Option(SpInclude),
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

pub type SpMedicationrequest {
  SpMedicationrequest(
    include: Option(SpInclude),
    requester: Option(String),
    date: Option(String),
    identifier: Option(String),
    intended_dispenser: Option(String),
    authoredon: Option(String),
    code: Option(String),
    subject: Option(String),
    medication: Option(String),
    encounter: Option(String),
    priority: Option(String),
    intent: Option(String),
    patient: Option(String),
    intended_performer: Option(String),
    intended_performertype: Option(String),
    category: Option(String),
    status: Option(String),
  )
}

pub type SpMedicationstatement {
  SpMedicationstatement(
    include: Option(SpInclude),
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
    include: Option(SpInclude),
    identifier: Option(String),
    name: Option(String),
    name_language: Option(String),
  )
}

pub type SpMedicinalproductauthorization {
  SpMedicinalproductauthorization(
    include: Option(SpInclude),
    identifier: Option(String),
    country: Option(String),
    subject: Option(String),
    holder: Option(String),
    status: Option(String),
  )
}

pub type SpMedicinalproductcontraindication {
  SpMedicinalproductcontraindication(
    include: Option(SpInclude),
    subject: Option(String),
  )
}

pub type SpMedicinalproductindication {
  SpMedicinalproductindication(
    include: Option(SpInclude),
    subject: Option(String),
  )
}

pub type SpMedicinalproductingredient {
  SpMedicinalproductingredient(include: Option(SpInclude))
}

pub type SpMedicinalproductinteraction {
  SpMedicinalproductinteraction(
    include: Option(SpInclude),
    subject: Option(String),
  )
}

pub type SpMedicinalproductmanufactured {
  SpMedicinalproductmanufactured(include: Option(SpInclude))
}

pub type SpMedicinalproductpackaged {
  SpMedicinalproductpackaged(
    include: Option(SpInclude),
    identifier: Option(String),
    subject: Option(String),
  )
}

pub type SpMedicinalproductpharmaceutical {
  SpMedicinalproductpharmaceutical(
    include: Option(SpInclude),
    identifier: Option(String),
    route: Option(String),
    target_species: Option(String),
  )
}

pub type SpMedicinalproductundesirableeffect {
  SpMedicinalproductundesirableeffect(
    include: Option(SpInclude),
    subject: Option(String),
  )
}

pub type SpMessagedefinition {
  SpMessagedefinition(
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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

pub type SpObservation {
  SpObservation(
    include: Option(SpInclude),
    date: Option(String),
    combo_data_absent_reason: Option(String),
    code: Option(String),
    combo_code_value_quantity: Option(String),
    subject: Option(String),
    component_data_absent_reason: Option(String),
    value_concept: Option(String),
    value_date: Option(String),
    focus: Option(String),
    derived_from: Option(String),
    part_of: Option(String),
    has_member: Option(String),
    code_value_string: Option(String),
    component_code_value_quantity: Option(String),
    based_on: Option(String),
    code_value_date: Option(String),
    patient: Option(String),
    specimen: Option(String),
    component_code: Option(String),
    code_value_quantity: Option(String),
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
  SpObservationdefinition(include: Option(SpInclude))
}

pub type SpOperationdefinition {
  SpOperationdefinition(
    include: Option(SpInclude),
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
  SpOperationoutcome(include: Option(SpInclude))
}

pub type SpOrganization {
  SpOrganization(
    include: Option(SpInclude),
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
    name: Option(String),
    address_use: Option(String),
    address_city: Option(String),
  )
}

pub type SpOrganizationaffiliation {
  SpOrganizationaffiliation(
    include: Option(SpInclude),
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

pub type SpPatient {
  SpPatient(
    include: Option(SpInclude),
    identifier: Option(String),
    given: Option(String),
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
    name: Option(String),
    address_use: Option(String),
    telecom: Option(String),
    family: Option(String),
    address_city: Option(String),
    email: Option(String),
  )
}

pub type SpPaymentnotice {
  SpPaymentnotice(
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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

pub type SpPractitioner {
  SpPractitioner(
    include: Option(SpInclude),
    identifier: Option(String),
    given: Option(String),
    address: Option(String),
    address_state: Option(String),
    gender: Option(String),
    active: Option(String),
    address_postalcode: Option(String),
    address_country: Option(String),
    phonetic: Option(String),
    phone: Option(String),
    name: Option(String),
    address_use: Option(String),
    telecom: Option(String),
    family: Option(String),
    address_city: Option(String),
    communication: Option(String),
    email: Option(String),
  )
}

pub type SpPractitionerrole {
  SpPractitionerrole(
    include: Option(SpInclude),
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
    telecom: Option(String),
    location: Option(String),
    email: Option(String),
  )
}

pub type SpProcedure {
  SpProcedure(
    include: Option(SpInclude),
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
    location: Option(String),
    instantiates_uri: Option(String),
    category: Option(String),
    status: Option(String),
  )
}

pub type SpProvenance {
  SpProvenance(
    include: Option(SpInclude),
    agent_type: Option(String),
    agent: Option(String),
    signature_type: Option(String),
    patient: Option(String),
    location: Option(String),
    recorded: Option(String),
    agent_role: Option(String),
    when: Option(String),
    entity: Option(String),
    target: Option(String),
  )
}

pub type SpQuestionnaire {
  SpQuestionnaire(
    include: Option(SpInclude),
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

pub type SpQuestionnaireresponse {
  SpQuestionnaireresponse(
    include: Option(SpInclude),
    authored: Option(String),
    identifier: Option(String),
    questionnaire: Option(String),
    based_on: Option(String),
    subject: Option(String),
    author: Option(String),
    patient: Option(String),
    part_of: Option(String),
    encounter: Option(String),
    source: Option(String),
    status: Option(String),
  )
}

pub type SpRelatedperson {
  SpRelatedperson(
    include: Option(SpInclude),
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
    name: Option(String),
    address_use: Option(String),
    telecom: Option(String),
    address_city: Option(String),
    relationship: Option(String),
    email: Option(String),
  )
}

pub type SpRequestgroup {
  SpRequestgroup(
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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

pub type SpServicerequest {
  SpServicerequest(
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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

pub type SpSpecimen {
  SpSpecimen(
    include: Option(SpInclude),
    container: Option(String),
    identifier: Option(String),
    parent: Option(String),
    container_id: Option(String),
    bodysite: Option(String),
    subject: Option(String),
    patient: Option(String),
    collected: Option(String),
    accession: Option(String),
    type_: Option(String),
    collector: Option(String),
    status: Option(String),
  )
}

pub type SpSpecimendefinition {
  SpSpecimendefinition(
    include: Option(SpInclude),
    container: Option(String),
    identifier: Option(String),
    type_: Option(String),
  )
}

pub type SpStructuredefinition {
  SpStructuredefinition(
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
  SpSubstancenucleicacid(include: Option(SpInclude))
}

pub type SpSubstancepolymer {
  SpSubstancepolymer(include: Option(SpInclude))
}

pub type SpSubstanceprotein {
  SpSubstanceprotein(include: Option(SpInclude))
}

pub type SpSubstancereferenceinformation {
  SpSubstancereferenceinformation(include: Option(SpInclude))
}

pub type SpSubstancesourcematerial {
  SpSubstancesourcematerial(include: Option(SpInclude))
}

pub type SpSubstancespecification {
  SpSubstancespecification(include: Option(SpInclude), code: Option(String))
}

pub type SpSupplydelivery {
  SpSupplydelivery(
    include: Option(SpInclude),
    identifier: Option(String),
    receiver: Option(String),
    patient: Option(String),
    supplier: Option(String),
    status: Option(String),
  )
}

pub type SpSupplyrequest {
  SpSupplyrequest(
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
    include: Option(SpInclude),
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
  SpVerificationresult(include: Option(SpInclude), target: Option(String))
}

pub type SpVisionprescription {
  SpVisionprescription(
    include: Option(SpInclude),
    prescriber: Option(String),
    identifier: Option(String),
    patient: Option(String),
    datewritten: Option(String),
    encounter: Option(String),
    status: Option(String),
  )
}

pub fn sp_account_new() {
  SpAccount(None, None, None, None, None, None, None, None, None)
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
  )
}

pub fn sp_appointmentresponse_new() {
  SpAppointmentresponse(None, None, None, None, None, None, None, None)
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
    None,
  )
}

pub fn sp_basic_new() {
  SpBasic(None, None, None, None, None, None, None)
}

pub fn sp_binary_new() {
  SpBinary(None)
}

pub fn sp_biologicallyderivedproduct_new() {
  SpBiologicallyderivedproduct(None)
}

pub fn sp_bodystructure_new() {
  SpBodystructure(None, None, None, None, None)
}

pub fn sp_bundle_new() {
  SpBundle(None, None, None, None, None, None)
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
    None,
    None,
    None,
  )
}

pub fn sp_careteam_new() {
  SpCareteam(None, None, None, None, None, None, None, None, None)
}

pub fn sp_catalogentry_new() {
  SpCatalogentry(None)
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
  )
}

pub fn sp_contract_new() {
  SpContract(None, None, None, None, None, None, None, None, None, None, None)
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
  )
}

pub fn sp_coverageeligibilityrequest_new() {
  SpCoverageeligibilityrequest(None, None, None, None, None, None, None, None)
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
    None,
  )
}

pub fn sp_detectedissue_new() {
  SpDetectedissue(None, None, None, None, None, None, None)
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
  )
}

pub fn sp_devicedefinition_new() {
  SpDevicedefinition(None, None, None, None)
}

pub fn sp_devicemetric_new() {
  SpDevicemetric(None, None, None, None, None, None)
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

pub fn sp_deviceusestatement_new() {
  SpDeviceusestatement(None, None, None, None, None)
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
  )
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
  )
}

pub fn sp_endpoint_new() {
  SpEndpoint(None, None, None, None, None, None, None)
}

pub fn sp_enrollmentrequest_new() {
  SpEnrollmentrequest(None, None, None, None, None)
}

pub fn sp_enrollmentresponse_new() {
  SpEnrollmentresponse(None, None, None, None)
}

pub fn sp_episodeofcare_new() {
  SpEpisodeofcare(None, None, None, None, None, None, None, None, None, None)
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
    None,
  )
}

pub fn sp_familymemberhistory_new() {
  SpFamilymemberhistory(
    None,
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

pub fn sp_flag_new() {
  SpFlag(None, None, None, None, None, None, None)
}

pub fn sp_goal_new() {
  SpGoal(None, None, None, None, None, None, None, None, None)
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
  SpGroup(None, None, None, None, None, None, None, None, None, None, None)
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
    None,
  )
}

pub fn sp_immunizationevaluation_new() {
  SpImmunizationevaluation(None, None, None, None, None, None, None, None)
}

pub fn sp_immunizationrecommendation_new() {
  SpImmunizationrecommendation(
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
    None,
  )
}

pub fn sp_linkage_new() {
  SpLinkage(None, None, None, None)
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
  )
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
    None,
  )
}

pub fn sp_measurereport_new() {
  SpMeasurereport(None, None, None, None, None, None, None, None, None, None)
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
    None,
  )
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
    None,
  )
}

pub fn sp_medicinalproduct_new() {
  SpMedicinalproduct(None, None, None, None)
}

pub fn sp_medicinalproductauthorization_new() {
  SpMedicinalproductauthorization(None, None, None, None, None, None)
}

pub fn sp_medicinalproductcontraindication_new() {
  SpMedicinalproductcontraindication(None, None)
}

pub fn sp_medicinalproductindication_new() {
  SpMedicinalproductindication(None, None)
}

pub fn sp_medicinalproductingredient_new() {
  SpMedicinalproductingredient(None)
}

pub fn sp_medicinalproductinteraction_new() {
  SpMedicinalproductinteraction(None, None)
}

pub fn sp_medicinalproductmanufactured_new() {
  SpMedicinalproductmanufactured(None)
}

pub fn sp_medicinalproductpackaged_new() {
  SpMedicinalproductpackaged(None, None, None)
}

pub fn sp_medicinalproductpharmaceutical_new() {
  SpMedicinalproductpharmaceutical(None, None, None, None)
}

pub fn sp_medicinalproductundesirableeffect_new() {
  SpMedicinalproductundesirableeffect(None, None)
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
    None,
  )
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
  )
}

pub fn sp_observationdefinition_new() {
  SpObservationdefinition(None)
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
  SpOperationoutcome(None)
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
    None,
  )
}

pub fn sp_paymentnotice_new() {
  SpPaymentnotice(None, None, None, None, None, None, None, None)
}

pub fn sp_paymentreconciliation_new() {
  SpPaymentreconciliation(None, None, None, None, None, None, None, None, None)
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
  SpProvenance(None, None, None, None, None, None, None, None, None, None, None)
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
  )
}

pub fn sp_researchsubject_new() {
  SpResearchsubject(None, None, None, None, None, None, None)
}

pub fn sp_riskassessment_new() {
  SpRiskassessment(
    None,
    None,
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
    None,
  )
}

pub fn sp_schedule_new() {
  SpSchedule(None, None, None, None, None, None, None, None)
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
    None,
  )
}

pub fn sp_specimendefinition_new() {
  SpSpecimendefinition(None, None, None, None)
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
    None,
  )
}

pub fn sp_subscription_new() {
  SpSubscription(None, None, None, None, None, None, None)
}

pub fn sp_substance_new() {
  SpSubstance(None, None, None, None, None, None, None, None, None)
}

pub fn sp_substancenucleicacid_new() {
  SpSubstancenucleicacid(None)
}

pub fn sp_substancepolymer_new() {
  SpSubstancepolymer(None)
}

pub fn sp_substanceprotein_new() {
  SpSubstanceprotein(None)
}

pub fn sp_substancereferenceinformation_new() {
  SpSubstancereferenceinformation(None)
}

pub fn sp_substancesourcematerial_new() {
  SpSubstancesourcematerial(None)
}

pub fn sp_substancespecification_new() {
  SpSubstancespecification(None, None)
}

pub fn sp_supplydelivery_new() {
  SpSupplydelivery(None, None, None, None, None, None)
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
    None,
  )
}

pub fn sp_verificationresult_new() {
  SpVerificationresult(None, None)
}

pub fn sp_visionprescription_new() {
  SpVisionprescription(None, None, None, None, None, None, None)
}

pub type SpInclude {
  SpInclude(
    inc_account: Option(SpInclude),
    revinc_account: Option(SpInclude),
    inc_activitydefinition: Option(SpInclude),
    revinc_activitydefinition: Option(SpInclude),
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
    inc_effectevidencesynthesis: Option(SpInclude),
    revinc_effectevidencesynthesis: Option(SpInclude),
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
    inc_riskevidencesynthesis: Option(SpInclude),
    revinc_riskevidencesynthesis: Option(SpInclude),
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
    account: List(r4.Account),
    activitydefinition: List(r4.Activitydefinition),
    adverseevent: List(r4.Adverseevent),
    allergyintolerance: List(r4.Allergyintolerance),
    appointment: List(r4.Appointment),
    appointmentresponse: List(r4.Appointmentresponse),
    auditevent: List(r4.Auditevent),
    basic: List(r4.Basic),
    binary: List(r4.Binary),
    biologicallyderivedproduct: List(r4.Biologicallyderivedproduct),
    bodystructure: List(r4.Bodystructure),
    bundle: List(r4.Bundle),
    capabilitystatement: List(r4.Capabilitystatement),
    careplan: List(r4.Careplan),
    careteam: List(r4.Careteam),
    catalogentry: List(r4.Catalogentry),
    chargeitem: List(r4.Chargeitem),
    chargeitemdefinition: List(r4.Chargeitemdefinition),
    claim: List(r4.Claim),
    claimresponse: List(r4.Claimresponse),
    clinicalimpression: List(r4.Clinicalimpression),
    codesystem: List(r4.Codesystem),
    communication: List(r4.Communication),
    communicationrequest: List(r4.Communicationrequest),
    compartmentdefinition: List(r4.Compartmentdefinition),
    composition: List(r4.Composition),
    conceptmap: List(r4.Conceptmap),
    condition: List(r4.Condition),
    consent: List(r4.Consent),
    contract: List(r4.Contract),
    coverage: List(r4.Coverage),
    coverageeligibilityrequest: List(r4.Coverageeligibilityrequest),
    coverageeligibilityresponse: List(r4.Coverageeligibilityresponse),
    detectedissue: List(r4.Detectedissue),
    device: List(r4.Device),
    devicedefinition: List(r4.Devicedefinition),
    devicemetric: List(r4.Devicemetric),
    devicerequest: List(r4.Devicerequest),
    deviceusestatement: List(r4.Deviceusestatement),
    diagnosticreport: List(r4.Diagnosticreport),
    documentmanifest: List(r4.Documentmanifest),
    documentreference: List(r4.Documentreference),
    effectevidencesynthesis: List(r4.Effectevidencesynthesis),
    encounter: List(r4.Encounter),
    endpoint: List(r4.Endpoint),
    enrollmentrequest: List(r4.Enrollmentrequest),
    enrollmentresponse: List(r4.Enrollmentresponse),
    episodeofcare: List(r4.Episodeofcare),
    eventdefinition: List(r4.Eventdefinition),
    evidence: List(r4.Evidence),
    evidencevariable: List(r4.Evidencevariable),
    examplescenario: List(r4.Examplescenario),
    explanationofbenefit: List(r4.Explanationofbenefit),
    familymemberhistory: List(r4.Familymemberhistory),
    flag: List(r4.Flag),
    goal: List(r4.Goal),
    graphdefinition: List(r4.Graphdefinition),
    group: List(r4.Group),
    guidanceresponse: List(r4.Guidanceresponse),
    healthcareservice: List(r4.Healthcareservice),
    imagingstudy: List(r4.Imagingstudy),
    immunization: List(r4.Immunization),
    immunizationevaluation: List(r4.Immunizationevaluation),
    immunizationrecommendation: List(r4.Immunizationrecommendation),
    implementationguide: List(r4.Implementationguide),
    insuranceplan: List(r4.Insuranceplan),
    invoice: List(r4.Invoice),
    library: List(r4.Library),
    linkage: List(r4.Linkage),
    listfhir: List(r4.Listfhir),
    location: List(r4.Location),
    measure: List(r4.Measure),
    measurereport: List(r4.Measurereport),
    media: List(r4.Media),
    medication: List(r4.Medication),
    medicationadministration: List(r4.Medicationadministration),
    medicationdispense: List(r4.Medicationdispense),
    medicationknowledge: List(r4.Medicationknowledge),
    medicationrequest: List(r4.Medicationrequest),
    medicationstatement: List(r4.Medicationstatement),
    medicinalproduct: List(r4.Medicinalproduct),
    medicinalproductauthorization: List(r4.Medicinalproductauthorization),
    medicinalproductcontraindication: List(r4.Medicinalproductcontraindication),
    medicinalproductindication: List(r4.Medicinalproductindication),
    medicinalproductingredient: List(r4.Medicinalproductingredient),
    medicinalproductinteraction: List(r4.Medicinalproductinteraction),
    medicinalproductmanufactured: List(r4.Medicinalproductmanufactured),
    medicinalproductpackaged: List(r4.Medicinalproductpackaged),
    medicinalproductpharmaceutical: List(r4.Medicinalproductpharmaceutical),
    medicinalproductundesirableeffect: List(
      r4.Medicinalproductundesirableeffect,
    ),
    messagedefinition: List(r4.Messagedefinition),
    messageheader: List(r4.Messageheader),
    molecularsequence: List(r4.Molecularsequence),
    namingsystem: List(r4.Namingsystem),
    nutritionorder: List(r4.Nutritionorder),
    observation: List(r4.Observation),
    observationdefinition: List(r4.Observationdefinition),
    operationdefinition: List(r4.Operationdefinition),
    operationoutcome: List(r4.Operationoutcome),
    organization: List(r4.Organization),
    organizationaffiliation: List(r4.Organizationaffiliation),
    patient: List(r4.Patient),
    paymentnotice: List(r4.Paymentnotice),
    paymentreconciliation: List(r4.Paymentreconciliation),
    person: List(r4.Person),
    plandefinition: List(r4.Plandefinition),
    practitioner: List(r4.Practitioner),
    practitionerrole: List(r4.Practitionerrole),
    procedure: List(r4.Procedure),
    provenance: List(r4.Provenance),
    questionnaire: List(r4.Questionnaire),
    questionnaireresponse: List(r4.Questionnaireresponse),
    relatedperson: List(r4.Relatedperson),
    requestgroup: List(r4.Requestgroup),
    researchdefinition: List(r4.Researchdefinition),
    researchelementdefinition: List(r4.Researchelementdefinition),
    researchstudy: List(r4.Researchstudy),
    researchsubject: List(r4.Researchsubject),
    riskassessment: List(r4.Riskassessment),
    riskevidencesynthesis: List(r4.Riskevidencesynthesis),
    schedule: List(r4.Schedule),
    searchparameter: List(r4.Searchparameter),
    servicerequest: List(r4.Servicerequest),
    slot: List(r4.Slot),
    specimen: List(r4.Specimen),
    specimendefinition: List(r4.Specimendefinition),
    structuredefinition: List(r4.Structuredefinition),
    structuremap: List(r4.Structuremap),
    subscription: List(r4.Subscription),
    substance: List(r4.Substance),
    substancenucleicacid: List(r4.Substancenucleicacid),
    substancepolymer: List(r4.Substancepolymer),
    substanceprotein: List(r4.Substanceprotein),
    substancereferenceinformation: List(r4.Substancereferenceinformation),
    substancesourcematerial: List(r4.Substancesourcematerial),
    substancespecification: List(r4.Substancespecification),
    supplydelivery: List(r4.Supplydelivery),
    supplyrequest: List(r4.Supplyrequest),
    task: List(r4.Task),
    terminologycapabilities: List(r4.Terminologycapabilities),
    testreport: List(r4.Testreport),
    testscript: List(r4.Testscript),
    valueset: List(r4.Valueset),
    verificationresult: List(r4.Verificationresult),
    visionprescription: List(r4.Visionprescription),
  )
}

pub fn groupedresources_new() {
  GroupedResources(
    account: [],
    activitydefinition: [],
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
    claim: [],
    claimresponse: [],
    clinicalimpression: [],
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
    effectevidencesynthesis: [],
    encounter: [],
    endpoint: [],
    enrollmentrequest: [],
    enrollmentresponse: [],
    episodeofcare: [],
    eventdefinition: [],
    evidence: [],
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
    insuranceplan: [],
    invoice: [],
    library: [],
    linkage: [],
    listfhir: [],
    location: [],
    measure: [],
    measurereport: [],
    media: [],
    medication: [],
    medicationadministration: [],
    medicationdispense: [],
    medicationknowledge: [],
    medicationrequest: [],
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
    observation: [],
    observationdefinition: [],
    operationdefinition: [],
    operationoutcome: [],
    organization: [],
    organizationaffiliation: [],
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
    relatedperson: [],
    requestgroup: [],
    researchdefinition: [],
    researchelementdefinition: [],
    researchstudy: [],
    researchsubject: [],
    riskassessment: [],
    riskevidencesynthesis: [],
    schedule: [],
    searchparameter: [],
    servicerequest: [],
    slot: [],
    specimen: [],
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

pub fn allergyintolerance_search_req(
  sp: SpAllergyintolerance,
  client: FhirClient,
) {
  let params =
    using_params([
      #("severity", sp.severity),
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("manifestation", sp.manifestation),
      #("recorder", sp.recorder),
      #("code", sp.code),
      #("verification-status", sp.verification_status),
      #("criticality", sp.criticality),
      #("clinical-status", sp.clinical_status),
      #("type", sp.type_),
      #("onset", sp.onset),
      #("route", sp.route),
      #("asserter", sp.asserter),
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

pub fn binary_search_req(sp: SpBinary, client: FhirClient) {
  let params = using_params([])
  any_search_req(params, "Binary", client)
}

pub fn biologicallyderivedproduct_search_req(
  sp: SpBiologicallyderivedproduct,
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

pub fn careplan_search_req(sp: SpCareplan, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("care-team", sp.care_team),
      #("identifier", sp.identifier),
      #("performer", sp.performer),
      #("goal", sp.goal),
      #("subject", sp.subject),
      #("replaces", sp.replaces),
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

pub fn catalogentry_search_req(sp: SpCatalogentry, client: FhirClient) {
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

pub fn condition_search_req(sp: SpCondition, client: FhirClient) {
  let params =
    using_params([
      #("severity", sp.severity),
      #("evidence-detail", sp.evidence_detail),
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
      #("onset-age", sp.onset_age),
      #("abatement-age", sp.abatement_age),
      #("category", sp.category),
      #("body-site", sp.body_site),
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
      #("dependent", sp.dependent),
      #("class-type", sp.class_type),
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

pub fn device_search_req(sp: SpDevice, client: FhirClient) {
  let params =
    using_params([
      #("udi-di", sp.udi_di),
      #("identifier", sp.identifier),
      #("udi-carrier", sp.udi_carrier),
      #("device-name", sp.device_name),
      #("patient", sp.patient),
      #("organization", sp.organization),
      #("model", sp.model),
      #("location", sp.location),
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

pub fn diagnosticreport_search_req(sp: SpDiagnosticreport, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("performer", sp.performer),
      #("code", sp.code),
      #("subject", sp.subject),
      #("media", sp.media),
      #("encounter", sp.encounter),
      #("result", sp.result),
      #("conclusion", sp.conclusion),
      #("based-on", sp.based_on),
      #("patient", sp.patient),
      #("specimen", sp.specimen),
      #("issued", sp.issued),
      #("category", sp.category),
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
      #("relationship", sp.relationship),
      #("event", sp.event),
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

pub fn encounter_search_req(sp: SpEncounter, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("participant-type", sp.participant_type),
      #("practitioner", sp.practitioner),
      #("subject", sp.subject),
      #("length", sp.length),
      #("episode-of-care", sp.episode_of_care),
      #("diagnosis", sp.diagnosis),
      #("appointment", sp.appointment),
      #("part-of", sp.part_of),
      #("type", sp.type_),
      #("reason-code", sp.reason_code),
      #("participant", sp.participant),
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
      #("subject", sp.subject),
      #("patient", sp.patient),
      #("author", sp.author),
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
      #("status", sp.status),
      #("reaction-date", sp.reaction_date),
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
      #("name", sp.name),
      #("address-use", sp.address_use),
      #("near", sp.near),
      #("address-city", sp.address_city),
      #("status", sp.status),
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
      #("patient", sp.patient),
      #("effective-time", sp.effective_time),
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
      #("performer", sp.performer),
      #("code", sp.code),
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
      #("monograph", sp.monograph),
      #("monitoring-program-name", sp.monitoring_program_name),
      #("monitoring-program-type", sp.monitoring_program_type),
      #("status", sp.status),
    ])
  any_search_req(params, "MedicationKnowledge", client)
}

pub fn medicationrequest_search_req(sp: SpMedicationrequest, client: FhirClient) {
  let params =
    using_params([
      #("requester", sp.requester),
      #("date", sp.date),
      #("identifier", sp.identifier),
      #("intended-dispenser", sp.intended_dispenser),
      #("authoredon", sp.authoredon),
      #("code", sp.code),
      #("subject", sp.subject),
      #("medication", sp.medication),
      #("encounter", sp.encounter),
      #("priority", sp.priority),
      #("intent", sp.intent),
      #("patient", sp.patient),
      #("intended-performer", sp.intended_performer),
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
  sp: SpMedicinalproductingredient,
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
  sp: SpMedicinalproductmanufactured,
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

pub fn observation_search_req(sp: SpObservation, client: FhirClient) {
  let params =
    using_params([
      #("date", sp.date),
      #("combo-data-absent-reason", sp.combo_data_absent_reason),
      #("code", sp.code),
      #("combo-code-value-quantity", sp.combo_code_value_quantity),
      #("subject", sp.subject),
      #("component-data-absent-reason", sp.component_data_absent_reason),
      #("value-concept", sp.value_concept),
      #("value-date", sp.value_date),
      #("focus", sp.focus),
      #("derived-from", sp.derived_from),
      #("part-of", sp.part_of),
      #("has-member", sp.has_member),
      #("code-value-string", sp.code_value_string),
      #("component-code-value-quantity", sp.component_code_value_quantity),
      #("based-on", sp.based_on),
      #("code-value-date", sp.code_value_date),
      #("patient", sp.patient),
      #("specimen", sp.specimen),
      #("component-code", sp.component_code),
      #("code-value-quantity", sp.code_value_quantity),
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
  sp: SpObservationdefinition,
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

pub fn operationoutcome_search_req(sp: SpOperationoutcome, client: FhirClient) {
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
      #("name", sp.name),
      #("address-use", sp.address_use),
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
      #("telecom", sp.telecom),
      #("location", sp.location),
      #("email", sp.email),
    ])
  any_search_req(params, "OrganizationAffiliation", client)
}

pub fn patient_search_req(sp: SpPatient, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("given", sp.given),
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
      #("name", sp.name),
      #("address-use", sp.address_use),
      #("telecom", sp.telecom),
      #("family", sp.family),
      #("address-city", sp.address_city),
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

pub fn practitioner_search_req(sp: SpPractitioner, client: FhirClient) {
  let params =
    using_params([
      #("identifier", sp.identifier),
      #("given", sp.given),
      #("address", sp.address),
      #("address-state", sp.address_state),
      #("gender", sp.gender),
      #("active", sp.active),
      #("address-postalcode", sp.address_postalcode),
      #("address-country", sp.address_country),
      #("phonetic", sp.phonetic),
      #("phone", sp.phone),
      #("name", sp.name),
      #("address-use", sp.address_use),
      #("telecom", sp.telecom),
      #("family", sp.family),
      #("address-city", sp.address_city),
      #("communication", sp.communication),
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
      #("telecom", sp.telecom),
      #("location", sp.location),
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
      #("location", sp.location),
      #("instantiates-uri", sp.instantiates_uri),
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
      #("recorded", sp.recorded),
      #("agent-role", sp.agent_role),
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
      #("name", sp.name),
      #("context", sp.context),
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
      #("subject", sp.subject),
      #("author", sp.author),
      #("patient", sp.patient),
      #("part-of", sp.part_of),
      #("encounter", sp.encounter),
      #("source", sp.source),
      #("status", sp.status),
    ])
  any_search_req(params, "QuestionnaireResponse", client)
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
      #("name", sp.name),
      #("address-use", sp.address_use),
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

pub fn specimen_search_req(sp: SpSpecimen, client: FhirClient) {
  let params =
    using_params([
      #("container", sp.container),
      #("identifier", sp.identifier),
      #("parent", sp.parent),
      #("container-id", sp.container_id),
      #("bodysite", sp.bodysite),
      #("subject", sp.subject),
      #("patient", sp.patient),
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
  sp: SpSubstancenucleicacid,
  client: FhirClient,
) {
  let params = using_params([])
  any_search_req(params, "SubstanceNucleicAcid", client)
}

pub fn substancepolymer_search_req(sp: SpSubstancepolymer, client: FhirClient) {
  let params = using_params([])
  any_search_req(params, "SubstancePolymer", client)
}

pub fn substanceprotein_search_req(sp: SpSubstanceprotein, client: FhirClient) {
  let params = using_params([])
  any_search_req(params, "SubstanceProtein", client)
}

pub fn substancereferenceinformation_search_req(
  sp: SpSubstancereferenceinformation,
  client: FhirClient,
) {
  let params = using_params([])
  any_search_req(params, "SubstanceReferenceInformation", client)
}

pub fn substancesourcematerial_search_req(
  sp: SpSubstancesourcematerial,
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

pub fn bundle_to_groupedresources(from bundle: r4.Bundle) {
  list.fold(
    from: groupedresources_new(),
    over: bundle.entry,
    with: fn(acc, entry) {
      case entry.resource {
        None -> acc
        Some(res) ->
          case res {
            r4.ResourceAccount(r) ->
              GroupedResources(..acc, account: [r, ..acc.account])
            r4.ResourceActivitydefinition(r) ->
              GroupedResources(..acc, activitydefinition: [
                r,
                ..acc.activitydefinition
              ])
            r4.ResourceAdverseevent(r) ->
              GroupedResources(..acc, adverseevent: [r, ..acc.adverseevent])
            r4.ResourceAllergyintolerance(r) ->
              GroupedResources(..acc, allergyintolerance: [
                r,
                ..acc.allergyintolerance
              ])
            r4.ResourceAppointment(r) ->
              GroupedResources(..acc, appointment: [r, ..acc.appointment])
            r4.ResourceAppointmentresponse(r) ->
              GroupedResources(..acc, appointmentresponse: [
                r,
                ..acc.appointmentresponse
              ])
            r4.ResourceAuditevent(r) ->
              GroupedResources(..acc, auditevent: [r, ..acc.auditevent])
            r4.ResourceBasic(r) ->
              GroupedResources(..acc, basic: [r, ..acc.basic])
            r4.ResourceBinary(r) ->
              GroupedResources(..acc, binary: [r, ..acc.binary])
            r4.ResourceBiologicallyderivedproduct(r) ->
              GroupedResources(..acc, biologicallyderivedproduct: [
                r,
                ..acc.biologicallyderivedproduct
              ])
            r4.ResourceBodystructure(r) ->
              GroupedResources(..acc, bodystructure: [r, ..acc.bodystructure])
            r4.ResourceBundle(r) ->
              GroupedResources(..acc, bundle: [r, ..acc.bundle])
            r4.ResourceCapabilitystatement(r) ->
              GroupedResources(..acc, capabilitystatement: [
                r,
                ..acc.capabilitystatement
              ])
            r4.ResourceCareplan(r) ->
              GroupedResources(..acc, careplan: [r, ..acc.careplan])
            r4.ResourceCareteam(r) ->
              GroupedResources(..acc, careteam: [r, ..acc.careteam])
            r4.ResourceCatalogentry(r) ->
              GroupedResources(..acc, catalogentry: [r, ..acc.catalogentry])
            r4.ResourceChargeitem(r) ->
              GroupedResources(..acc, chargeitem: [r, ..acc.chargeitem])
            r4.ResourceChargeitemdefinition(r) ->
              GroupedResources(..acc, chargeitemdefinition: [
                r,
                ..acc.chargeitemdefinition
              ])
            r4.ResourceClaim(r) ->
              GroupedResources(..acc, claim: [r, ..acc.claim])
            r4.ResourceClaimresponse(r) ->
              GroupedResources(..acc, claimresponse: [r, ..acc.claimresponse])
            r4.ResourceClinicalimpression(r) ->
              GroupedResources(..acc, clinicalimpression: [
                r,
                ..acc.clinicalimpression
              ])
            r4.ResourceCodesystem(r) ->
              GroupedResources(..acc, codesystem: [r, ..acc.codesystem])
            r4.ResourceCommunication(r) ->
              GroupedResources(..acc, communication: [r, ..acc.communication])
            r4.ResourceCommunicationrequest(r) ->
              GroupedResources(..acc, communicationrequest: [
                r,
                ..acc.communicationrequest
              ])
            r4.ResourceCompartmentdefinition(r) ->
              GroupedResources(..acc, compartmentdefinition: [
                r,
                ..acc.compartmentdefinition
              ])
            r4.ResourceComposition(r) ->
              GroupedResources(..acc, composition: [r, ..acc.composition])
            r4.ResourceConceptmap(r) ->
              GroupedResources(..acc, conceptmap: [r, ..acc.conceptmap])
            r4.ResourceCondition(r) ->
              GroupedResources(..acc, condition: [r, ..acc.condition])
            r4.ResourceConsent(r) ->
              GroupedResources(..acc, consent: [r, ..acc.consent])
            r4.ResourceContract(r) ->
              GroupedResources(..acc, contract: [r, ..acc.contract])
            r4.ResourceCoverage(r) ->
              GroupedResources(..acc, coverage: [r, ..acc.coverage])
            r4.ResourceCoverageeligibilityrequest(r) ->
              GroupedResources(..acc, coverageeligibilityrequest: [
                r,
                ..acc.coverageeligibilityrequest
              ])
            r4.ResourceCoverageeligibilityresponse(r) ->
              GroupedResources(..acc, coverageeligibilityresponse: [
                r,
                ..acc.coverageeligibilityresponse
              ])
            r4.ResourceDetectedissue(r) ->
              GroupedResources(..acc, detectedissue: [r, ..acc.detectedissue])
            r4.ResourceDevice(r) ->
              GroupedResources(..acc, device: [r, ..acc.device])
            r4.ResourceDevicedefinition(r) ->
              GroupedResources(..acc, devicedefinition: [
                r,
                ..acc.devicedefinition
              ])
            r4.ResourceDevicemetric(r) ->
              GroupedResources(..acc, devicemetric: [r, ..acc.devicemetric])
            r4.ResourceDevicerequest(r) ->
              GroupedResources(..acc, devicerequest: [r, ..acc.devicerequest])
            r4.ResourceDeviceusestatement(r) ->
              GroupedResources(..acc, deviceusestatement: [
                r,
                ..acc.deviceusestatement
              ])
            r4.ResourceDiagnosticreport(r) ->
              GroupedResources(..acc, diagnosticreport: [
                r,
                ..acc.diagnosticreport
              ])
            r4.ResourceDocumentmanifest(r) ->
              GroupedResources(..acc, documentmanifest: [
                r,
                ..acc.documentmanifest
              ])
            r4.ResourceDocumentreference(r) ->
              GroupedResources(..acc, documentreference: [
                r,
                ..acc.documentreference
              ])
            r4.ResourceEffectevidencesynthesis(r) ->
              GroupedResources(..acc, effectevidencesynthesis: [
                r,
                ..acc.effectevidencesynthesis
              ])
            r4.ResourceEncounter(r) ->
              GroupedResources(..acc, encounter: [r, ..acc.encounter])
            r4.ResourceEndpoint(r) ->
              GroupedResources(..acc, endpoint: [r, ..acc.endpoint])
            r4.ResourceEnrollmentrequest(r) ->
              GroupedResources(..acc, enrollmentrequest: [
                r,
                ..acc.enrollmentrequest
              ])
            r4.ResourceEnrollmentresponse(r) ->
              GroupedResources(..acc, enrollmentresponse: [
                r,
                ..acc.enrollmentresponse
              ])
            r4.ResourceEpisodeofcare(r) ->
              GroupedResources(..acc, episodeofcare: [r, ..acc.episodeofcare])
            r4.ResourceEventdefinition(r) ->
              GroupedResources(..acc, eventdefinition: [
                r,
                ..acc.eventdefinition
              ])
            r4.ResourceEvidence(r) ->
              GroupedResources(..acc, evidence: [r, ..acc.evidence])
            r4.ResourceEvidencevariable(r) ->
              GroupedResources(..acc, evidencevariable: [
                r,
                ..acc.evidencevariable
              ])
            r4.ResourceExamplescenario(r) ->
              GroupedResources(..acc, examplescenario: [
                r,
                ..acc.examplescenario
              ])
            r4.ResourceExplanationofbenefit(r) ->
              GroupedResources(..acc, explanationofbenefit: [
                r,
                ..acc.explanationofbenefit
              ])
            r4.ResourceFamilymemberhistory(r) ->
              GroupedResources(..acc, familymemberhistory: [
                r,
                ..acc.familymemberhistory
              ])
            r4.ResourceFlag(r) -> GroupedResources(..acc, flag: [r, ..acc.flag])
            r4.ResourceGoal(r) -> GroupedResources(..acc, goal: [r, ..acc.goal])
            r4.ResourceGraphdefinition(r) ->
              GroupedResources(..acc, graphdefinition: [
                r,
                ..acc.graphdefinition
              ])
            r4.ResourceGroup(r) ->
              GroupedResources(..acc, group: [r, ..acc.group])
            r4.ResourceGuidanceresponse(r) ->
              GroupedResources(..acc, guidanceresponse: [
                r,
                ..acc.guidanceresponse
              ])
            r4.ResourceHealthcareservice(r) ->
              GroupedResources(..acc, healthcareservice: [
                r,
                ..acc.healthcareservice
              ])
            r4.ResourceImagingstudy(r) ->
              GroupedResources(..acc, imagingstudy: [r, ..acc.imagingstudy])
            r4.ResourceImmunization(r) ->
              GroupedResources(..acc, immunization: [r, ..acc.immunization])
            r4.ResourceImmunizationevaluation(r) ->
              GroupedResources(..acc, immunizationevaluation: [
                r,
                ..acc.immunizationevaluation
              ])
            r4.ResourceImmunizationrecommendation(r) ->
              GroupedResources(..acc, immunizationrecommendation: [
                r,
                ..acc.immunizationrecommendation
              ])
            r4.ResourceImplementationguide(r) ->
              GroupedResources(..acc, implementationguide: [
                r,
                ..acc.implementationguide
              ])
            r4.ResourceInsuranceplan(r) ->
              GroupedResources(..acc, insuranceplan: [r, ..acc.insuranceplan])
            r4.ResourceInvoice(r) ->
              GroupedResources(..acc, invoice: [r, ..acc.invoice])
            r4.ResourceLibrary(r) ->
              GroupedResources(..acc, library: [r, ..acc.library])
            r4.ResourceLinkage(r) ->
              GroupedResources(..acc, linkage: [r, ..acc.linkage])
            r4.ResourceListfhir(r) ->
              GroupedResources(..acc, listfhir: [r, ..acc.listfhir])
            r4.ResourceLocation(r) ->
              GroupedResources(..acc, location: [r, ..acc.location])
            r4.ResourceMeasure(r) ->
              GroupedResources(..acc, measure: [r, ..acc.measure])
            r4.ResourceMeasurereport(r) ->
              GroupedResources(..acc, measurereport: [r, ..acc.measurereport])
            r4.ResourceMedia(r) ->
              GroupedResources(..acc, media: [r, ..acc.media])
            r4.ResourceMedication(r) ->
              GroupedResources(..acc, medication: [r, ..acc.medication])
            r4.ResourceMedicationadministration(r) ->
              GroupedResources(..acc, medicationadministration: [
                r,
                ..acc.medicationadministration
              ])
            r4.ResourceMedicationdispense(r) ->
              GroupedResources(..acc, medicationdispense: [
                r,
                ..acc.medicationdispense
              ])
            r4.ResourceMedicationknowledge(r) ->
              GroupedResources(..acc, medicationknowledge: [
                r,
                ..acc.medicationknowledge
              ])
            r4.ResourceMedicationrequest(r) ->
              GroupedResources(..acc, medicationrequest: [
                r,
                ..acc.medicationrequest
              ])
            r4.ResourceMedicationstatement(r) ->
              GroupedResources(..acc, medicationstatement: [
                r,
                ..acc.medicationstatement
              ])
            r4.ResourceMedicinalproduct(r) ->
              GroupedResources(..acc, medicinalproduct: [
                r,
                ..acc.medicinalproduct
              ])
            r4.ResourceMedicinalproductauthorization(r) ->
              GroupedResources(..acc, medicinalproductauthorization: [
                r,
                ..acc.medicinalproductauthorization
              ])
            r4.ResourceMedicinalproductcontraindication(r) ->
              GroupedResources(..acc, medicinalproductcontraindication: [
                r,
                ..acc.medicinalproductcontraindication
              ])
            r4.ResourceMedicinalproductindication(r) ->
              GroupedResources(..acc, medicinalproductindication: [
                r,
                ..acc.medicinalproductindication
              ])
            r4.ResourceMedicinalproductingredient(r) ->
              GroupedResources(..acc, medicinalproductingredient: [
                r,
                ..acc.medicinalproductingredient
              ])
            r4.ResourceMedicinalproductinteraction(r) ->
              GroupedResources(..acc, medicinalproductinteraction: [
                r,
                ..acc.medicinalproductinteraction
              ])
            r4.ResourceMedicinalproductmanufactured(r) ->
              GroupedResources(..acc, medicinalproductmanufactured: [
                r,
                ..acc.medicinalproductmanufactured
              ])
            r4.ResourceMedicinalproductpackaged(r) ->
              GroupedResources(..acc, medicinalproductpackaged: [
                r,
                ..acc.medicinalproductpackaged
              ])
            r4.ResourceMedicinalproductpharmaceutical(r) ->
              GroupedResources(..acc, medicinalproductpharmaceutical: [
                r,
                ..acc.medicinalproductpharmaceutical
              ])
            r4.ResourceMedicinalproductundesirableeffect(r) ->
              GroupedResources(..acc, medicinalproductundesirableeffect: [
                r,
                ..acc.medicinalproductundesirableeffect
              ])
            r4.ResourceMessagedefinition(r) ->
              GroupedResources(..acc, messagedefinition: [
                r,
                ..acc.messagedefinition
              ])
            r4.ResourceMessageheader(r) ->
              GroupedResources(..acc, messageheader: [r, ..acc.messageheader])
            r4.ResourceMolecularsequence(r) ->
              GroupedResources(..acc, molecularsequence: [
                r,
                ..acc.molecularsequence
              ])
            r4.ResourceNamingsystem(r) ->
              GroupedResources(..acc, namingsystem: [r, ..acc.namingsystem])
            r4.ResourceNutritionorder(r) ->
              GroupedResources(..acc, nutritionorder: [r, ..acc.nutritionorder])
            r4.ResourceObservation(r) ->
              GroupedResources(..acc, observation: [r, ..acc.observation])
            r4.ResourceObservationdefinition(r) ->
              GroupedResources(..acc, observationdefinition: [
                r,
                ..acc.observationdefinition
              ])
            r4.ResourceOperationdefinition(r) ->
              GroupedResources(..acc, operationdefinition: [
                r,
                ..acc.operationdefinition
              ])
            r4.ResourceOperationoutcome(r) ->
              GroupedResources(..acc, operationoutcome: [
                r,
                ..acc.operationoutcome
              ])
            r4.ResourceOrganization(r) ->
              GroupedResources(..acc, organization: [r, ..acc.organization])
            r4.ResourceOrganizationaffiliation(r) ->
              GroupedResources(..acc, organizationaffiliation: [
                r,
                ..acc.organizationaffiliation
              ])
            r4.ResourcePatient(r) ->
              GroupedResources(..acc, patient: [r, ..acc.patient])
            r4.ResourcePaymentnotice(r) ->
              GroupedResources(..acc, paymentnotice: [r, ..acc.paymentnotice])
            r4.ResourcePaymentreconciliation(r) ->
              GroupedResources(..acc, paymentreconciliation: [
                r,
                ..acc.paymentreconciliation
              ])
            r4.ResourcePerson(r) ->
              GroupedResources(..acc, person: [r, ..acc.person])
            r4.ResourcePlandefinition(r) ->
              GroupedResources(..acc, plandefinition: [r, ..acc.plandefinition])
            r4.ResourcePractitioner(r) ->
              GroupedResources(..acc, practitioner: [r, ..acc.practitioner])
            r4.ResourcePractitionerrole(r) ->
              GroupedResources(..acc, practitionerrole: [
                r,
                ..acc.practitionerrole
              ])
            r4.ResourceProcedure(r) ->
              GroupedResources(..acc, procedure: [r, ..acc.procedure])
            r4.ResourceProvenance(r) ->
              GroupedResources(..acc, provenance: [r, ..acc.provenance])
            r4.ResourceQuestionnaire(r) ->
              GroupedResources(..acc, questionnaire: [r, ..acc.questionnaire])
            r4.ResourceQuestionnaireresponse(r) ->
              GroupedResources(..acc, questionnaireresponse: [
                r,
                ..acc.questionnaireresponse
              ])
            r4.ResourceRelatedperson(r) ->
              GroupedResources(..acc, relatedperson: [r, ..acc.relatedperson])
            r4.ResourceRequestgroup(r) ->
              GroupedResources(..acc, requestgroup: [r, ..acc.requestgroup])
            r4.ResourceResearchdefinition(r) ->
              GroupedResources(..acc, researchdefinition: [
                r,
                ..acc.researchdefinition
              ])
            r4.ResourceResearchelementdefinition(r) ->
              GroupedResources(..acc, researchelementdefinition: [
                r,
                ..acc.researchelementdefinition
              ])
            r4.ResourceResearchstudy(r) ->
              GroupedResources(..acc, researchstudy: [r, ..acc.researchstudy])
            r4.ResourceResearchsubject(r) ->
              GroupedResources(..acc, researchsubject: [
                r,
                ..acc.researchsubject
              ])
            r4.ResourceRiskassessment(r) ->
              GroupedResources(..acc, riskassessment: [r, ..acc.riskassessment])
            r4.ResourceRiskevidencesynthesis(r) ->
              GroupedResources(..acc, riskevidencesynthesis: [
                r,
                ..acc.riskevidencesynthesis
              ])
            r4.ResourceSchedule(r) ->
              GroupedResources(..acc, schedule: [r, ..acc.schedule])
            r4.ResourceSearchparameter(r) ->
              GroupedResources(..acc, searchparameter: [
                r,
                ..acc.searchparameter
              ])
            r4.ResourceServicerequest(r) ->
              GroupedResources(..acc, servicerequest: [r, ..acc.servicerequest])
            r4.ResourceSlot(r) -> GroupedResources(..acc, slot: [r, ..acc.slot])
            r4.ResourceSpecimen(r) ->
              GroupedResources(..acc, specimen: [r, ..acc.specimen])
            r4.ResourceSpecimendefinition(r) ->
              GroupedResources(..acc, specimendefinition: [
                r,
                ..acc.specimendefinition
              ])
            r4.ResourceStructuredefinition(r) ->
              GroupedResources(..acc, structuredefinition: [
                r,
                ..acc.structuredefinition
              ])
            r4.ResourceStructuremap(r) ->
              GroupedResources(..acc, structuremap: [r, ..acc.structuremap])
            r4.ResourceSubscription(r) ->
              GroupedResources(..acc, subscription: [r, ..acc.subscription])
            r4.ResourceSubstance(r) ->
              GroupedResources(..acc, substance: [r, ..acc.substance])
            r4.ResourceSubstancenucleicacid(r) ->
              GroupedResources(..acc, substancenucleicacid: [
                r,
                ..acc.substancenucleicacid
              ])
            r4.ResourceSubstancepolymer(r) ->
              GroupedResources(..acc, substancepolymer: [
                r,
                ..acc.substancepolymer
              ])
            r4.ResourceSubstanceprotein(r) ->
              GroupedResources(..acc, substanceprotein: [
                r,
                ..acc.substanceprotein
              ])
            r4.ResourceSubstancereferenceinformation(r) ->
              GroupedResources(..acc, substancereferenceinformation: [
                r,
                ..acc.substancereferenceinformation
              ])
            r4.ResourceSubstancesourcematerial(r) ->
              GroupedResources(..acc, substancesourcematerial: [
                r,
                ..acc.substancesourcematerial
              ])
            r4.ResourceSubstancespecification(r) ->
              GroupedResources(..acc, substancespecification: [
                r,
                ..acc.substancespecification
              ])
            r4.ResourceSupplydelivery(r) ->
              GroupedResources(..acc, supplydelivery: [r, ..acc.supplydelivery])
            r4.ResourceSupplyrequest(r) ->
              GroupedResources(..acc, supplyrequest: [r, ..acc.supplyrequest])
            r4.ResourceTask(r) -> GroupedResources(..acc, task: [r, ..acc.task])
            r4.ResourceTerminologycapabilities(r) ->
              GroupedResources(..acc, terminologycapabilities: [
                r,
                ..acc.terminologycapabilities
              ])
            r4.ResourceTestreport(r) ->
              GroupedResources(..acc, testreport: [r, ..acc.testreport])
            r4.ResourceTestscript(r) ->
              GroupedResources(..acc, testscript: [r, ..acc.testscript])
            r4.ResourceValueset(r) ->
              GroupedResources(..acc, valueset: [r, ..acc.valueset])
            r4.ResourceVerificationresult(r) ->
              GroupedResources(..acc, verificationresult: [
                r,
                ..acc.verificationresult
              ])
            r4.ResourceVisionprescription(r) ->
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
