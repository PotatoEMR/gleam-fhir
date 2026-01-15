import fhir/r4
import gleam/dynamic/decode
import gleam/http
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/json.{type Json}
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
  //could not decode resource json
  ErrDecode(json.DecodeError)
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
  |> request.set_header("Prefer", "return=representation")
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
        |> request.set_header("Prefer", "return=representation")
        |> request.set_method(http.Delete),
      )
    }
  }
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
    Error(dec_err) -> Error(ErrDecode(dec_err))
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

pub fn domainresource_create_req(
  resource: r4.Domainresource,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.domainresource_to_json(resource), "DomainResource", client)
}

pub fn domainresource_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "DomainResource", client)
}

pub fn domainresource_update_req(
  resource: r4.Domainresource,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.domainresource_to_json(resource),
    "DomainResource",
    client,
  )
}

pub fn domainresource_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "DomainResource", client)
}

pub fn domainresource_resp(
  resp: Response(String),
) -> Result(r4.Domainresource, Err) {
  any_resp(resp, r4.domainresource_decoder())
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

pub fn parameters_create_req(
  resource: r4.Parameters,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4.parameters_to_json(resource), "Parameters", client)
}

pub fn parameters_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Parameters", client)
}

pub fn parameters_update_req(
  resource: r4.Parameters,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4.parameters_to_json(resource),
    "Parameters",
    client,
  )
}

pub fn parameters_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Parameters", client)
}

pub fn parameters_resp(resp: Response(String)) -> Result(r4.Parameters, Err) {
  any_resp(resp, r4.parameters_decoder())
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
