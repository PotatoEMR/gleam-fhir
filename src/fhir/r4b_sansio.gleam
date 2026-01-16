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
  //could not decode resource json
  ErrDecode(json.DecodeError)
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
    Error(dec_err) -> Error(ErrDecode(dec_err))
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

pub fn domainresource_create_req(
  resource: r4b.Domainresource,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.domainresource_to_json(resource), "DomainResource", client)
}

pub fn domainresource_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "DomainResource", client)
}

pub fn domainresource_update_req(
  resource: r4b.Domainresource,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.domainresource_to_json(resource),
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
) -> Result(r4b.Domainresource, Err) {
  any_resp(resp, r4b.domainresource_decoder())
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

pub fn parameters_create_req(
  resource: r4b.Parameters,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r4b.parameters_to_json(resource), "Parameters", client)
}

pub fn parameters_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Parameters", client)
}

pub fn parameters_update_req(
  resource: r4b.Parameters,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r4b.parameters_to_json(resource),
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

pub fn parameters_resp(resp: Response(String)) -> Result(r4b.Parameters, Err) {
  any_resp(resp, r4b.parameters_decoder())
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

pub type SearchParams {
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
  SpAppointmentresponse(
    actor: Option(String),
    identifier: Option(String),
    practitioner: Option(String),
    part_status: Option(String),
    patient: Option(String),
    appointment: Option(String),
    location: Option(String),
  )
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
  SpBasic(
    identifier: Option(String),
    code: Option(String),
    author: Option(String),
    created: Option(String),
    patient: Option(String),
    subject: Option(String),
  )
  SpBinary
  SpBiologicallyderivedproduct
  SpBodystructure(
    identifier: Option(String),
    morphology: Option(String),
    patient: Option(String),
    location: Option(String),
  )
  SpBundle(
    identifier: Option(String),
    composition: Option(String),
    message: Option(String),
    type_: Option(String),
    timestamp: Option(String),
  )
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
  SpCatalogentry
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
  SpCoverageeligibilityrequest(
    identifier: Option(String),
    provider: Option(String),
    created: Option(String),
    patient: Option(String),
    enterer: Option(String),
    facility: Option(String),
    status: Option(String),
  )
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
  SpDetectedissue(
    identifier: Option(String),
    code: Option(String),
    identified: Option(String),
    author: Option(String),
    patient: Option(String),
    implicated: Option(String),
  )
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
  SpDevicedefinition(
    identifier: Option(String),
    parent: Option(String),
    type_: Option(String),
  )
  SpDevicemetric(
    identifier: Option(String),
    parent: Option(String),
    source: Option(String),
    category: Option(String),
    type_: Option(String),
  )
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
  SpDeviceusestatement(
    identifier: Option(String),
    patient: Option(String),
    subject: Option(String),
    device: Option(String),
  )
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
  SpEndpoint(
    payload_type: Option(String),
    identifier: Option(String),
    connection_type: Option(String),
    organization: Option(String),
    name: Option(String),
    status: Option(String),
  )
  SpEnrollmentrequest(
    identifier: Option(String),
    patient: Option(String),
    subject: Option(String),
    status: Option(String),
  )
  SpEnrollmentresponse(
    identifier: Option(String),
    request: Option(String),
    status: Option(String),
  )
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
  SpFlag(
    date: Option(String),
    identifier: Option(String),
    author: Option(String),
    patient: Option(String),
    subject: Option(String),
    encounter: Option(String),
  )
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
  SpGuidanceresponse(
    identifier: Option(String),
    request: Option(String),
    patient: Option(String),
    subject: Option(String),
  )
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
  SpImmunizationevaluation(
    date: Option(String),
    identifier: Option(String),
    target_disease: Option(String),
    patient: Option(String),
    dose_status: Option(String),
    immunization_event: Option(String),
    status: Option(String),
  )
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
  SpLinkage(
    item: Option(String),
    author: Option(String),
    source: Option(String),
  )
  SpList(
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
  SpManufactureditemdefinition(
    identifier: Option(String),
    ingredient: Option(String),
    dose_form: Option(String),
  )
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
  SpNutritionproduct(identifier: Option(String), status: Option(String))
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
  SpObservationdefinition
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
  SpOperationoutcome
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
  SpPaymentnotice(
    identifier: Option(String),
    request: Option(String),
    provider: Option(String),
    created: Option(String),
    response: Option(String),
    payment_status: Option(String),
    status: Option(String),
  )
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
  SpRegulatedauthorization(
    identifier: Option(String),
    subject: Option(String),
    case_type: Option(String),
    holder: Option(String),
    region: Option(String),
    case_: Option(String),
    status: Option(String),
  )
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
  SpResearchsubject(
    date: Option(String),
    identifier: Option(String),
    study: Option(String),
    individual: Option(String),
    patient: Option(String),
    status: Option(String),
  )
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
  SpSchedule(
    actor: Option(String),
    date: Option(String),
    identifier: Option(String),
    specialty: Option(String),
    service_category: Option(String),
    service_type: Option(String),
    active: Option(String),
  )
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
  SpSpecimendefinition(
    container: Option(String),
    identifier: Option(String),
    type_: Option(String),
  )
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
  SpSubscription(
    payload: Option(String),
    criteria: Option(String),
    contact: Option(String),
    type_: Option(String),
    url: Option(String),
    status: Option(String),
  )
  SpSubscriptionstatus
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
  SpSubstancedefinition(
    identifier: Option(String),
    code: Option(String),
    domain: Option(String),
    name: Option(String),
    classification: Option(String),
  )
  SpSupplydelivery(
    identifier: Option(String),
    receiver: Option(String),
    patient: Option(String),
    supplier: Option(String),
    status: Option(String),
  )
  SpSupplyrequest(
    date: Option(String),
    requester: Option(String),
    identifier: Option(String),
    subject: Option(String),
    supplier: Option(String),
    category: Option(String),
    status: Option(String),
  )
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
  SpTestreport(
    result: Option(String),
    identifier: Option(String),
    tester: Option(String),
    testscript: Option(String),
    issued: Option(String),
    participant: Option(String),
  )
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
  SpVerificationresult(target: Option(String))
  SpVisionprescription(
    prescriber: Option(String),
    identifier: Option(String),
    patient: Option(String),
    datewritten: Option(String),
    encounter: Option(String),
    status: Option(String),
  )
}

pub fn any_search_req(sp: SearchParams, client: FhirClient) -> Request(String) {
  let #(res_type, params_to_encode) = case sp {
    SpAccount(owner, identifier, period, patient, subject, name, type_, status) -> #(
      "Account",
      using_params([
        #("owner", owner),
        #("identifier", identifier),
        #("period", period),
        #("patient", patient),
        #("subject", subject),
        #("name", name),
        #("type", type_),
        #("status", status),
      ]),
    )
    SpActivitydefinition(
      date,
      identifier,
      successor,
      context_type_value,
      jurisdiction,
      derived_from,
      description,
      context_type,
      predecessor,
      composed_of,
      title,
      version,
      url,
      context_quantity,
      depends_on,
      effective,
      context,
      name,
      publisher,
      topic,
      context_type_quantity,
      status,
    ) -> #(
      "ActivityDefinition",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("successor", successor),
        #("context-type-value", context_type_value),
        #("jurisdiction", jurisdiction),
        #("derived-from", derived_from),
        #("description", description),
        #("context-type", context_type),
        #("predecessor", predecessor),
        #("composed-of", composed_of),
        #("title", title),
        #("version", version),
        #("url", url),
        #("context-quantity", context_quantity),
        #("depends-on", depends_on),
        #("effective", effective),
        #("context", context),
        #("name", name),
        #("publisher", publisher),
        #("topic", topic),
        #("context-type-quantity", context_type_quantity),
        #("status", status),
      ]),
    )
    SpAdministrableproductdefinition(
      identifier,
      manufactured_item,
      ingredient,
      route,
      dose_form,
      device,
      form_of,
      target_species,
    ) -> #(
      "AdministrableProductDefinition",
      using_params([
        #("identifier", identifier),
        #("manufactured-item", manufactured_item),
        #("ingredient", ingredient),
        #("route", route),
        #("dose-form", dose_form),
        #("device", device),
        #("form-of", form_of),
        #("target-species", target_species),
      ]),
    )
    SpAdverseevent(
      date,
      severity,
      recorder,
      study,
      actuality,
      seriousness,
      subject,
      resultingcondition,
      substance,
      location,
      category,
      event,
    ) -> #(
      "AdverseEvent",
      using_params([
        #("date", date),
        #("severity", severity),
        #("recorder", recorder),
        #("study", study),
        #("actuality", actuality),
        #("seriousness", seriousness),
        #("subject", subject),
        #("resultingcondition", resultingcondition),
        #("substance", substance),
        #("location", location),
        #("category", category),
        #("event", event),
      ]),
    )
    SpAllergyintolerance(
      date,
      severity,
      identifier,
      manifestation,
      recorder,
      code,
      verification_status,
      criticality,
      clinical_status,
      onset,
      type_,
      asserter,
      route,
      patient,
      category,
      last_date,
    ) -> #(
      "AllergyIntolerance",
      using_params([
        #("date", date),
        #("severity", severity),
        #("identifier", identifier),
        #("manifestation", manifestation),
        #("recorder", recorder),
        #("code", code),
        #("verification-status", verification_status),
        #("criticality", criticality),
        #("clinical-status", clinical_status),
        #("onset", onset),
        #("type", type_),
        #("asserter", asserter),
        #("route", route),
        #("patient", patient),
        #("category", category),
        #("last-date", last_date),
      ]),
    )
    SpAppointment(
      date,
      identifier,
      specialty,
      service_category,
      practitioner,
      appointment_type,
      part_status,
      service_type,
      slot,
      reason_code,
      actor,
      based_on,
      patient,
      reason_reference,
      supporting_info,
      location,
      status,
    ) -> #(
      "Appointment",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("specialty", specialty),
        #("service-category", service_category),
        #("practitioner", practitioner),
        #("appointment-type", appointment_type),
        #("part-status", part_status),
        #("service-type", service_type),
        #("slot", slot),
        #("reason-code", reason_code),
        #("actor", actor),
        #("based-on", based_on),
        #("patient", patient),
        #("reason-reference", reason_reference),
        #("supporting-info", supporting_info),
        #("location", location),
        #("status", status),
      ]),
    )
    SpAppointmentresponse(
      actor,
      identifier,
      practitioner,
      part_status,
      patient,
      appointment,
      location,
    ) -> #(
      "AppointmentResponse",
      using_params([
        #("actor", actor),
        #("identifier", identifier),
        #("practitioner", practitioner),
        #("part-status", part_status),
        #("patient", patient),
        #("appointment", appointment),
        #("location", location),
      ]),
    )
    SpAuditevent(
      date,
      entity_type,
      agent,
      address,
      entity_role,
      source,
      type_,
      altid,
      site,
      agent_name,
      entity_name,
      subtype,
      patient,
      action,
      agent_role,
      entity,
      outcome,
      policy,
    ) -> #(
      "AuditEvent",
      using_params([
        #("date", date),
        #("entity-type", entity_type),
        #("agent", agent),
        #("address", address),
        #("entity-role", entity_role),
        #("source", source),
        #("type", type_),
        #("altid", altid),
        #("site", site),
        #("agent-name", agent_name),
        #("entity-name", entity_name),
        #("subtype", subtype),
        #("patient", patient),
        #("action", action),
        #("agent-role", agent_role),
        #("entity", entity),
        #("outcome", outcome),
        #("policy", policy),
      ]),
    )
    SpBasic(identifier, code, author, created, patient, subject) -> #(
      "Basic",
      using_params([
        #("identifier", identifier),
        #("code", code),
        #("author", author),
        #("created", created),
        #("patient", patient),
        #("subject", subject),
      ]),
    )
    SpBinary -> #("Binary", using_params([]))
    SpBiologicallyderivedproduct -> #(
      "BiologicallyDerivedProduct",
      using_params([]),
    )
    SpBodystructure(identifier, morphology, patient, location) -> #(
      "BodyStructure",
      using_params([
        #("identifier", identifier),
        #("morphology", morphology),
        #("patient", patient),
        #("location", location),
      ]),
    )
    SpBundle(identifier, composition, message, type_, timestamp) -> #(
      "Bundle",
      using_params([
        #("identifier", identifier),
        #("composition", composition),
        #("message", message),
        #("type", type_),
        #("timestamp", timestamp),
      ]),
    )
    SpCapabilitystatement(
      date,
      resource_profile,
      context_type_value,
      software,
      resource,
      jurisdiction,
      format,
      description,
      context_type,
      fhirversion,
      title,
      version,
      supported_profile,
      url,
      mode,
      context_quantity,
      security_service,
      context,
      name,
      publisher,
      context_type_quantity,
      guide,
      status,
    ) -> #(
      "CapabilityStatement",
      using_params([
        #("date", date),
        #("resource-profile", resource_profile),
        #("context-type-value", context_type_value),
        #("software", software),
        #("resource", resource),
        #("jurisdiction", jurisdiction),
        #("format", format),
        #("description", description),
        #("context-type", context_type),
        #("fhirversion", fhirversion),
        #("title", title),
        #("version", version),
        #("supported-profile", supported_profile),
        #("url", url),
        #("mode", mode),
        #("context-quantity", context_quantity),
        #("security-service", security_service),
        #("context", context),
        #("name", name),
        #("publisher", publisher),
        #("context-type-quantity", context_type_quantity),
        #("guide", guide),
        #("status", status),
      ]),
    )
    SpCareplan(
      care_team,
      date,
      identifier,
      goal,
      performer,
      replaces,
      subject,
      instantiates_canonical,
      part_of,
      encounter,
      intent,
      activity_reference,
      condition,
      based_on,
      patient,
      activity_date,
      instantiates_uri,
      category,
      activity_code,
      status,
    ) -> #(
      "CarePlan",
      using_params([
        #("care-team", care_team),
        #("date", date),
        #("identifier", identifier),
        #("goal", goal),
        #("performer", performer),
        #("replaces", replaces),
        #("subject", subject),
        #("instantiates-canonical", instantiates_canonical),
        #("part-of", part_of),
        #("encounter", encounter),
        #("intent", intent),
        #("activity-reference", activity_reference),
        #("condition", condition),
        #("based-on", based_on),
        #("patient", patient),
        #("activity-date", activity_date),
        #("instantiates-uri", instantiates_uri),
        #("category", category),
        #("activity-code", activity_code),
        #("status", status),
      ]),
    )
    SpCareteam(
      date,
      identifier,
      patient,
      subject,
      encounter,
      category,
      participant,
      status,
    ) -> #(
      "CareTeam",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("patient", patient),
        #("subject", subject),
        #("encounter", encounter),
        #("category", category),
        #("participant", participant),
        #("status", status),
      ]),
    )
    SpCatalogentry -> #("CatalogEntry", using_params([]))
    SpChargeitem(
      identifier,
      performing_organization,
      code,
      quantity,
      subject,
      occurrence,
      entered_date,
      performer_function,
      factor_override,
      patient,
      service,
      price_override,
      context,
      enterer,
      performer_actor,
      account,
      requesting_organization,
    ) -> #(
      "ChargeItem",
      using_params([
        #("identifier", identifier),
        #("performing-organization", performing_organization),
        #("code", code),
        #("quantity", quantity),
        #("subject", subject),
        #("occurrence", occurrence),
        #("entered-date", entered_date),
        #("performer-function", performer_function),
        #("factor-override", factor_override),
        #("patient", patient),
        #("service", service),
        #("price-override", price_override),
        #("context", context),
        #("enterer", enterer),
        #("performer-actor", performer_actor),
        #("account", account),
        #("requesting-organization", requesting_organization),
      ]),
    )
    SpChargeitemdefinition(
      date,
      identifier,
      context_type_value,
      jurisdiction,
      description,
      context_type,
      title,
      version,
      url,
      context_quantity,
      effective,
      context,
      publisher,
      context_type_quantity,
      status,
    ) -> #(
      "ChargeItemDefinition",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("context-type-value", context_type_value),
        #("jurisdiction", jurisdiction),
        #("description", description),
        #("context-type", context_type),
        #("title", title),
        #("version", version),
        #("url", url),
        #("context-quantity", context_quantity),
        #("effective", effective),
        #("context", context),
        #("publisher", publisher),
        #("context-type-quantity", context_type_quantity),
        #("status", status),
      ]),
    )
    SpCitation(
      date,
      identifier,
      context_type_value,
      jurisdiction,
      description,
      context_type,
      title,
      version,
      url,
      context_quantity,
      effective,
      context,
      name,
      publisher,
      context_type_quantity,
      status,
    ) -> #(
      "Citation",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("context-type-value", context_type_value),
        #("jurisdiction", jurisdiction),
        #("description", description),
        #("context-type", context_type),
        #("title", title),
        #("version", version),
        #("url", url),
        #("context-quantity", context_quantity),
        #("effective", effective),
        #("context", context),
        #("name", name),
        #("publisher", publisher),
        #("context-type-quantity", context_type_quantity),
        #("status", status),
      ]),
    )
    SpClaim(
      care_team,
      identifier,
      created,
      use_,
      encounter,
      priority,
      payee,
      provider,
      insurer,
      patient,
      detail_udi,
      enterer,
      procedure_udi,
      subdetail_udi,
      facility,
      item_udi,
      status,
    ) -> #(
      "Claim",
      using_params([
        #("care-team", care_team),
        #("identifier", identifier),
        #("created", created),
        #("use", use_),
        #("encounter", encounter),
        #("priority", priority),
        #("payee", payee),
        #("provider", provider),
        #("insurer", insurer),
        #("patient", patient),
        #("detail-udi", detail_udi),
        #("enterer", enterer),
        #("procedure-udi", procedure_udi),
        #("subdetail-udi", subdetail_udi),
        #("facility", facility),
        #("item-udi", item_udi),
        #("status", status),
      ]),
    )
    SpClaimresponse(
      identifier,
      request,
      disposition,
      created,
      insurer,
      patient,
      use_,
      payment_date,
      outcome,
      requestor,
      status,
    ) -> #(
      "ClaimResponse",
      using_params([
        #("identifier", identifier),
        #("request", request),
        #("disposition", disposition),
        #("created", created),
        #("insurer", insurer),
        #("patient", patient),
        #("use", use_),
        #("payment-date", payment_date),
        #("outcome", outcome),
        #("requestor", requestor),
        #("status", status),
      ]),
    )
    SpClinicalimpression(
      date,
      identifier,
      previous,
      finding_code,
      assessor,
      subject,
      encounter,
      finding_ref,
      problem,
      patient,
      supporting_info,
      investigation,
      status,
    ) -> #(
      "ClinicalImpression",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("previous", previous),
        #("finding-code", finding_code),
        #("assessor", assessor),
        #("subject", subject),
        #("encounter", encounter),
        #("finding-ref", finding_ref),
        #("problem", problem),
        #("patient", patient),
        #("supporting-info", supporting_info),
        #("investigation", investigation),
        #("status", status),
      ]),
    )
    SpClinicalusedefinition(
      contraindication_reference,
      identifier,
      indication_reference,
      product,
      subject,
      effect,
      interaction,
      indication,
      type_,
      contraindication,
      effect_reference,
    ) -> #(
      "ClinicalUseDefinition",
      using_params([
        #("contraindication-reference", contraindication_reference),
        #("identifier", identifier),
        #("indication-reference", indication_reference),
        #("product", product),
        #("subject", subject),
        #("effect", effect),
        #("interaction", interaction),
        #("indication", indication),
        #("type", type_),
        #("contraindication", contraindication),
        #("effect-reference", effect_reference),
      ]),
    )
    SpCodesystem(
      date,
      identifier,
      code,
      context_type_value,
      content_mode,
      jurisdiction,
      description,
      context_type,
      language,
      title,
      version,
      url,
      context_quantity,
      supplements,
      system,
      context,
      name,
      publisher,
      context_type_quantity,
      status,
    ) -> #(
      "CodeSystem",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("code", code),
        #("context-type-value", context_type_value),
        #("content-mode", content_mode),
        #("jurisdiction", jurisdiction),
        #("description", description),
        #("context-type", context_type),
        #("language", language),
        #("title", title),
        #("version", version),
        #("url", url),
        #("context-quantity", context_quantity),
        #("supplements", supplements),
        #("system", system),
        #("context", context),
        #("name", name),
        #("publisher", publisher),
        #("context-type-quantity", context_type_quantity),
        #("status", status),
      ]),
    )
    SpCommunication(
      identifier,
      subject,
      instantiates_canonical,
      part_of,
      received,
      encounter,
      medium,
      sent,
      based_on,
      sender,
      patient,
      recipient,
      instantiates_uri,
      category,
      status,
    ) -> #(
      "Communication",
      using_params([
        #("identifier", identifier),
        #("subject", subject),
        #("instantiates-canonical", instantiates_canonical),
        #("part-of", part_of),
        #("received", received),
        #("encounter", encounter),
        #("medium", medium),
        #("sent", sent),
        #("based-on", based_on),
        #("sender", sender),
        #("patient", patient),
        #("recipient", recipient),
        #("instantiates-uri", instantiates_uri),
        #("category", category),
        #("status", status),
      ]),
    )
    SpCommunicationrequest(
      authored,
      requester,
      identifier,
      replaces,
      subject,
      encounter,
      medium,
      occurrence,
      priority,
      group_identifier,
      based_on,
      sender,
      patient,
      recipient,
      category,
      status,
    ) -> #(
      "CommunicationRequest",
      using_params([
        #("authored", authored),
        #("requester", requester),
        #("identifier", identifier),
        #("replaces", replaces),
        #("subject", subject),
        #("encounter", encounter),
        #("medium", medium),
        #("occurrence", occurrence),
        #("priority", priority),
        #("group-identifier", group_identifier),
        #("based-on", based_on),
        #("sender", sender),
        #("patient", patient),
        #("recipient", recipient),
        #("category", category),
        #("status", status),
      ]),
    )
    SpCompartmentdefinition(
      date,
      code,
      context_type_value,
      resource,
      description,
      context_type,
      version,
      url,
      context_quantity,
      context,
      name,
      publisher,
      context_type_quantity,
      status,
    ) -> #(
      "CompartmentDefinition",
      using_params([
        #("date", date),
        #("code", code),
        #("context-type-value", context_type_value),
        #("resource", resource),
        #("description", description),
        #("context-type", context_type),
        #("version", version),
        #("url", url),
        #("context-quantity", context_quantity),
        #("context", context),
        #("name", name),
        #("publisher", publisher),
        #("context-type-quantity", context_type_quantity),
        #("status", status),
      ]),
    )
    SpComposition(
      date,
      identifier,
      period,
      related_id,
      author,
      subject,
      confidentiality,
      section,
      encounter,
      title,
      type_,
      attester,
      entry,
      related_ref,
      patient,
      context,
      category,
      status,
    ) -> #(
      "Composition",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("period", period),
        #("related-id", related_id),
        #("author", author),
        #("subject", subject),
        #("confidentiality", confidentiality),
        #("section", section),
        #("encounter", encounter),
        #("title", title),
        #("type", type_),
        #("attester", attester),
        #("entry", entry),
        #("related-ref", related_ref),
        #("patient", patient),
        #("context", context),
        #("category", category),
        #("status", status),
      ]),
    )
    SpConceptmap(
      date,
      other,
      context_type_value,
      dependson,
      target_system,
      jurisdiction,
      description,
      context_type,
      source,
      title,
      context_quantity,
      source_uri,
      context,
      context_type_quantity,
      source_system,
      target_code,
      target_uri,
      identifier,
      product,
      version,
      url,
      target,
      source_code,
      name,
      publisher,
      status,
    ) -> #(
      "ConceptMap",
      using_params([
        #("date", date),
        #("other", other),
        #("context-type-value", context_type_value),
        #("dependson", dependson),
        #("target-system", target_system),
        #("jurisdiction", jurisdiction),
        #("description", description),
        #("context-type", context_type),
        #("source", source),
        #("title", title),
        #("context-quantity", context_quantity),
        #("source-uri", source_uri),
        #("context", context),
        #("context-type-quantity", context_type_quantity),
        #("source-system", source_system),
        #("target-code", target_code),
        #("target-uri", target_uri),
        #("identifier", identifier),
        #("product", product),
        #("version", version),
        #("url", url),
        #("target", target),
        #("source-code", source_code),
        #("name", name),
        #("publisher", publisher),
        #("status", status),
      ]),
    )
    SpCondition(
      evidence_detail,
      severity,
      identifier,
      onset_info,
      recorded_date,
      code,
      evidence,
      subject,
      verification_status,
      clinical_status,
      encounter,
      onset_date,
      abatement_date,
      asserter,
      stage,
      abatement_string,
      patient,
      abatement_age,
      onset_age,
      body_site,
      category,
    ) -> #(
      "Condition",
      using_params([
        #("evidence-detail", evidence_detail),
        #("severity", severity),
        #("identifier", identifier),
        #("onset-info", onset_info),
        #("recorded-date", recorded_date),
        #("code", code),
        #("evidence", evidence),
        #("subject", subject),
        #("verification-status", verification_status),
        #("clinical-status", clinical_status),
        #("encounter", encounter),
        #("onset-date", onset_date),
        #("abatement-date", abatement_date),
        #("asserter", asserter),
        #("stage", stage),
        #("abatement-string", abatement_string),
        #("patient", patient),
        #("abatement-age", abatement_age),
        #("onset-age", onset_age),
        #("body-site", body_site),
        #("category", category),
      ]),
    )
    SpConsent(
      date,
      identifier,
      period,
      data,
      purpose,
      source_reference,
      actor,
      security_label,
      patient,
      organization,
      scope,
      action,
      consentor,
      category,
      status,
    ) -> #(
      "Consent",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("period", period),
        #("data", data),
        #("purpose", purpose),
        #("source-reference", source_reference),
        #("actor", actor),
        #("security-label", security_label),
        #("patient", patient),
        #("organization", organization),
        #("scope", scope),
        #("action", action),
        #("consentor", consentor),
        #("category", category),
        #("status", status),
      ]),
    )
    SpContract(
      identifier,
      instantiates,
      patient,
      subject,
      authority,
      domain,
      issued,
      url,
      signer,
      status,
    ) -> #(
      "Contract",
      using_params([
        #("identifier", identifier),
        #("instantiates", instantiates),
        #("patient", patient),
        #("subject", subject),
        #("authority", authority),
        #("domain", domain),
        #("issued", issued),
        #("url", url),
        #("signer", signer),
        #("status", status),
      ]),
    )
    SpCoverage(
      identifier,
      payor,
      subscriber,
      beneficiary,
      patient,
      class_value,
      type_,
      class_type,
      dependent,
      policy_holder,
      status,
    ) -> #(
      "Coverage",
      using_params([
        #("identifier", identifier),
        #("payor", payor),
        #("subscriber", subscriber),
        #("beneficiary", beneficiary),
        #("patient", patient),
        #("class-value", class_value),
        #("type", type_),
        #("class-type", class_type),
        #("dependent", dependent),
        #("policy-holder", policy_holder),
        #("status", status),
      ]),
    )
    SpCoverageeligibilityrequest(
      identifier,
      provider,
      created,
      patient,
      enterer,
      facility,
      status,
    ) -> #(
      "CoverageEligibilityRequest",
      using_params([
        #("identifier", identifier),
        #("provider", provider),
        #("created", created),
        #("patient", patient),
        #("enterer", enterer),
        #("facility", facility),
        #("status", status),
      ]),
    )
    SpCoverageeligibilityresponse(
      identifier,
      request,
      disposition,
      created,
      insurer,
      patient,
      outcome,
      requestor,
      status,
    ) -> #(
      "CoverageEligibilityResponse",
      using_params([
        #("identifier", identifier),
        #("request", request),
        #("disposition", disposition),
        #("created", created),
        #("insurer", insurer),
        #("patient", patient),
        #("outcome", outcome),
        #("requestor", requestor),
        #("status", status),
      ]),
    )
    SpDetectedissue(identifier, code, identified, author, patient, implicated) -> #(
      "DetectedIssue",
      using_params([
        #("identifier", identifier),
        #("code", code),
        #("identified", identified),
        #("author", author),
        #("patient", patient),
        #("implicated", implicated),
      ]),
    )
    SpDevice(
      udi_di,
      identifier,
      udi_carrier,
      device_name,
      patient,
      organization,
      location,
      model,
      type_,
      url,
      manufacturer,
      status,
    ) -> #(
      "Device",
      using_params([
        #("udi-di", udi_di),
        #("identifier", identifier),
        #("udi-carrier", udi_carrier),
        #("device-name", device_name),
        #("patient", patient),
        #("organization", organization),
        #("location", location),
        #("model", model),
        #("type", type_),
        #("url", url),
        #("manufacturer", manufacturer),
        #("status", status),
      ]),
    )
    SpDevicedefinition(identifier, parent, type_) -> #(
      "DeviceDefinition",
      using_params([
        #("identifier", identifier),
        #("parent", parent),
        #("type", type_),
      ]),
    )
    SpDevicemetric(identifier, parent, source, category, type_) -> #(
      "DeviceMetric",
      using_params([
        #("identifier", identifier),
        #("parent", parent),
        #("source", source),
        #("category", category),
        #("type", type_),
      ]),
    )
    SpDevicerequest(
      insurance,
      requester,
      identifier,
      code,
      performer,
      event_date,
      subject,
      instantiates_canonical,
      encounter,
      authored_on,
      intent,
      group_identifier,
      based_on,
      patient,
      instantiates_uri,
      device,
      prior_request,
      status,
    ) -> #(
      "DeviceRequest",
      using_params([
        #("insurance", insurance),
        #("requester", requester),
        #("identifier", identifier),
        #("code", code),
        #("performer", performer),
        #("event-date", event_date),
        #("subject", subject),
        #("instantiates-canonical", instantiates_canonical),
        #("encounter", encounter),
        #("authored-on", authored_on),
        #("intent", intent),
        #("group-identifier", group_identifier),
        #("based-on", based_on),
        #("patient", patient),
        #("instantiates-uri", instantiates_uri),
        #("device", device),
        #("prior-request", prior_request),
        #("status", status),
      ]),
    )
    SpDeviceusestatement(identifier, patient, subject, device) -> #(
      "DeviceUseStatement",
      using_params([
        #("identifier", identifier),
        #("patient", patient),
        #("subject", subject),
        #("device", device),
      ]),
    )
    SpDiagnosticreport(
      date,
      identifier,
      code,
      performer,
      subject,
      encounter,
      media,
      conclusion,
      result,
      based_on,
      patient,
      specimen,
      category,
      issued,
      results_interpreter,
      status,
    ) -> #(
      "DiagnosticReport",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("code", code),
        #("performer", performer),
        #("subject", subject),
        #("encounter", encounter),
        #("media", media),
        #("conclusion", conclusion),
        #("result", result),
        #("based-on", based_on),
        #("patient", patient),
        #("specimen", specimen),
        #("category", category),
        #("issued", issued),
        #("results-interpreter", results_interpreter),
        #("status", status),
      ]),
    )
    SpDocumentmanifest(
      identifier,
      item,
      related_id,
      author,
      created,
      subject,
      description,
      source,
      type_,
      related_ref,
      patient,
      recipient,
      status,
    ) -> #(
      "DocumentManifest",
      using_params([
        #("identifier", identifier),
        #("item", item),
        #("related-id", related_id),
        #("author", author),
        #("created", created),
        #("subject", subject),
        #("description", description),
        #("source", source),
        #("type", type_),
        #("related-ref", related_ref),
        #("patient", patient),
        #("recipient", recipient),
        #("status", status),
      ]),
    )
    SpDocumentreference(
      date,
      subject,
      description,
      language,
      type_,
      relation,
      setting,
      related,
      patient,
      event,
      relationship,
      authenticator,
      identifier,
      period,
      custodian,
      author,
      format,
      encounter,
      contenttype,
      security_label,
      location,
      category,
      relatesto,
      facility,
      status,
    ) -> #(
      "DocumentReference",
      using_params([
        #("date", date),
        #("subject", subject),
        #("description", description),
        #("language", language),
        #("type", type_),
        #("relation", relation),
        #("setting", setting),
        #("related", related),
        #("patient", patient),
        #("event", event),
        #("relationship", relationship),
        #("authenticator", authenticator),
        #("identifier", identifier),
        #("period", period),
        #("custodian", custodian),
        #("author", author),
        #("format", format),
        #("encounter", encounter),
        #("contenttype", contenttype),
        #("security-label", security_label),
        #("location", location),
        #("category", category),
        #("relatesto", relatesto),
        #("facility", facility),
        #("status", status),
      ]),
    )
    SpEncounter(
      date,
      identifier,
      participant_type,
      practitioner,
      subject,
      episode_of_care,
      length,
      diagnosis,
      appointment,
      part_of,
      type_,
      participant,
      reason_code,
      based_on,
      patient,
      reason_reference,
      location_period,
      location,
      service_provider,
      special_arrangement,
      class,
      account,
      status,
    ) -> #(
      "Encounter",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("participant-type", participant_type),
        #("practitioner", practitioner),
        #("subject", subject),
        #("episode-of-care", episode_of_care),
        #("length", length),
        #("diagnosis", diagnosis),
        #("appointment", appointment),
        #("part-of", part_of),
        #("type", type_),
        #("participant", participant),
        #("reason-code", reason_code),
        #("based-on", based_on),
        #("patient", patient),
        #("reason-reference", reason_reference),
        #("location-period", location_period),
        #("location", location),
        #("service-provider", service_provider),
        #("special-arrangement", special_arrangement),
        #("class", class),
        #("account", account),
        #("status", status),
      ]),
    )
    SpEndpoint(
      payload_type,
      identifier,
      connection_type,
      organization,
      name,
      status,
    ) -> #(
      "Endpoint",
      using_params([
        #("payload-type", payload_type),
        #("identifier", identifier),
        #("connection-type", connection_type),
        #("organization", organization),
        #("name", name),
        #("status", status),
      ]),
    )
    SpEnrollmentrequest(identifier, patient, subject, status) -> #(
      "EnrollmentRequest",
      using_params([
        #("identifier", identifier),
        #("patient", patient),
        #("subject", subject),
        #("status", status),
      ]),
    )
    SpEnrollmentresponse(identifier, request, status) -> #(
      "EnrollmentResponse",
      using_params([
        #("identifier", identifier),
        #("request", request),
        #("status", status),
      ]),
    )
    SpEpisodeofcare(
      date,
      identifier,
      condition,
      patient,
      organization,
      type_,
      care_manager,
      incoming_referral,
      status,
    ) -> #(
      "EpisodeOfCare",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("condition", condition),
        #("patient", patient),
        #("organization", organization),
        #("type", type_),
        #("care-manager", care_manager),
        #("incoming-referral", incoming_referral),
        #("status", status),
      ]),
    )
    SpEventdefinition(
      date,
      identifier,
      successor,
      context_type_value,
      jurisdiction,
      derived_from,
      description,
      context_type,
      predecessor,
      composed_of,
      title,
      version,
      url,
      context_quantity,
      depends_on,
      effective,
      context,
      name,
      publisher,
      topic,
      context_type_quantity,
      status,
    ) -> #(
      "EventDefinition",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("successor", successor),
        #("context-type-value", context_type_value),
        #("jurisdiction", jurisdiction),
        #("derived-from", derived_from),
        #("description", description),
        #("context-type", context_type),
        #("predecessor", predecessor),
        #("composed-of", composed_of),
        #("title", title),
        #("version", version),
        #("url", url),
        #("context-quantity", context_quantity),
        #("depends-on", depends_on),
        #("effective", effective),
        #("context", context),
        #("name", name),
        #("publisher", publisher),
        #("topic", topic),
        #("context-type-quantity", context_type_quantity),
        #("status", status),
      ]),
    )
    SpEvidence(
      date,
      identifier,
      context_type_value,
      description,
      context_type,
      title,
      version,
      url,
      context_quantity,
      context,
      publisher,
      context_type_quantity,
      status,
    ) -> #(
      "Evidence",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("context-type-value", context_type_value),
        #("description", description),
        #("context-type", context_type),
        #("title", title),
        #("version", version),
        #("url", url),
        #("context-quantity", context_quantity),
        #("context", context),
        #("publisher", publisher),
        #("context-type-quantity", context_type_quantity),
        #("status", status),
      ]),
    )
    SpEvidencereport(
      context_quantity,
      identifier,
      context_type_value,
      context,
      publisher,
      context_type,
      context_type_quantity,
      url,
      status,
    ) -> #(
      "EvidenceReport",
      using_params([
        #("context-quantity", context_quantity),
        #("identifier", identifier),
        #("context-type-value", context_type_value),
        #("context", context),
        #("publisher", publisher),
        #("context-type", context_type),
        #("context-type-quantity", context_type_quantity),
        #("url", url),
        #("status", status),
      ]),
    )
    SpEvidencevariable(
      date,
      identifier,
      context_type_value,
      description,
      context_type,
      title,
      version,
      url,
      context_quantity,
      context,
      name,
      publisher,
      context_type_quantity,
      status,
    ) -> #(
      "EvidenceVariable",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("context-type-value", context_type_value),
        #("description", description),
        #("context-type", context_type),
        #("title", title),
        #("version", version),
        #("url", url),
        #("context-quantity", context_quantity),
        #("context", context),
        #("name", name),
        #("publisher", publisher),
        #("context-type-quantity", context_type_quantity),
        #("status", status),
      ]),
    )
    SpExamplescenario(
      date,
      identifier,
      context_type_value,
      jurisdiction,
      context_type,
      version,
      url,
      context_quantity,
      context,
      name,
      publisher,
      context_type_quantity,
      status,
    ) -> #(
      "ExampleScenario",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("context-type-value", context_type_value),
        #("jurisdiction", jurisdiction),
        #("context-type", context_type),
        #("version", version),
        #("url", url),
        #("context-quantity", context_quantity),
        #("context", context),
        #("name", name),
        #("publisher", publisher),
        #("context-type-quantity", context_type_quantity),
        #("status", status),
      ]),
    )
    SpExplanationofbenefit(
      care_team,
      coverage,
      identifier,
      created,
      encounter,
      payee,
      disposition,
      provider,
      patient,
      detail_udi,
      claim,
      enterer,
      procedure_udi,
      subdetail_udi,
      facility,
      item_udi,
      status,
    ) -> #(
      "ExplanationOfBenefit",
      using_params([
        #("care-team", care_team),
        #("coverage", coverage),
        #("identifier", identifier),
        #("created", created),
        #("encounter", encounter),
        #("payee", payee),
        #("disposition", disposition),
        #("provider", provider),
        #("patient", patient),
        #("detail-udi", detail_udi),
        #("claim", claim),
        #("enterer", enterer),
        #("procedure-udi", procedure_udi),
        #("subdetail-udi", subdetail_udi),
        #("facility", facility),
        #("item-udi", item_udi),
        #("status", status),
      ]),
    )
    SpFamilymemberhistory(
      date,
      identifier,
      code,
      patient,
      sex,
      instantiates_canonical,
      instantiates_uri,
      relationship,
      status,
    ) -> #(
      "FamilyMemberHistory",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("code", code),
        #("patient", patient),
        #("sex", sex),
        #("instantiates-canonical", instantiates_canonical),
        #("instantiates-uri", instantiates_uri),
        #("relationship", relationship),
        #("status", status),
      ]),
    )
    SpFlag(date, identifier, author, patient, subject, encounter) -> #(
      "Flag",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("author", author),
        #("patient", patient),
        #("subject", subject),
        #("encounter", encounter),
      ]),
    )
    SpGoal(
      identifier,
      lifecycle_status,
      achievement_status,
      patient,
      subject,
      start_date,
      category,
      target_date,
    ) -> #(
      "Goal",
      using_params([
        #("identifier", identifier),
        #("lifecycle-status", lifecycle_status),
        #("achievement-status", achievement_status),
        #("patient", patient),
        #("subject", subject),
        #("start-date", start_date),
        #("category", category),
        #("target-date", target_date),
      ]),
    )
    SpGraphdefinition(
      date,
      context_type_value,
      jurisdiction,
      start,
      description,
      context_type,
      version,
      url,
      context_quantity,
      context,
      name,
      publisher,
      context_type_quantity,
      status,
    ) -> #(
      "GraphDefinition",
      using_params([
        #("date", date),
        #("context-type-value", context_type_value),
        #("jurisdiction", jurisdiction),
        #("start", start),
        #("description", description),
        #("context-type", context_type),
        #("version", version),
        #("url", url),
        #("context-quantity", context_quantity),
        #("context", context),
        #("name", name),
        #("publisher", publisher),
        #("context-type-quantity", context_type_quantity),
        #("status", status),
      ]),
    )
    SpGroup(
      actual,
      identifier,
      characteristic_value,
      managing_entity,
      code,
      member,
      exclude,
      type_,
      value,
      characteristic,
    ) -> #(
      "Group",
      using_params([
        #("actual", actual),
        #("identifier", identifier),
        #("characteristic-value", characteristic_value),
        #("managing-entity", managing_entity),
        #("code", code),
        #("member", member),
        #("exclude", exclude),
        #("type", type_),
        #("value", value),
        #("characteristic", characteristic),
      ]),
    )
    SpGuidanceresponse(identifier, request, patient, subject) -> #(
      "GuidanceResponse",
      using_params([
        #("identifier", identifier),
        #("request", request),
        #("patient", patient),
        #("subject", subject),
      ]),
    )
    SpHealthcareservice(
      identifier,
      endpoint,
      specialty,
      service_category,
      coverage_area,
      organization,
      service_type,
      name,
      active,
      location,
      program,
      characteristic,
    ) -> #(
      "HealthcareService",
      using_params([
        #("identifier", identifier),
        #("endpoint", endpoint),
        #("specialty", specialty),
        #("service-category", service_category),
        #("coverage-area", coverage_area),
        #("organization", organization),
        #("service-type", service_type),
        #("name", name),
        #("active", active),
        #("location", location),
        #("program", program),
        #("characteristic", characteristic),
      ]),
    )
    SpImagingstudy(
      identifier,
      reason,
      dicom_class,
      bodysite,
      instance,
      modality,
      performer,
      subject,
      interpreter,
      started,
      encounter,
      referrer,
      endpoint,
      patient,
      series,
      basedon,
      status,
    ) -> #(
      "ImagingStudy",
      using_params([
        #("identifier", identifier),
        #("reason", reason),
        #("dicom-class", dicom_class),
        #("bodysite", bodysite),
        #("instance", instance),
        #("modality", modality),
        #("performer", performer),
        #("subject", subject),
        #("interpreter", interpreter),
        #("started", started),
        #("encounter", encounter),
        #("referrer", referrer),
        #("endpoint", endpoint),
        #("patient", patient),
        #("series", series),
        #("basedon", basedon),
        #("status", status),
      ]),
    )
    SpImmunization(
      date,
      identifier,
      performer,
      reaction,
      lot_number,
      status_reason,
      reason_code,
      manufacturer,
      target_disease,
      patient,
      series,
      vaccine_code,
      reason_reference,
      location,
      reaction_date,
      status,
    ) -> #(
      "Immunization",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("performer", performer),
        #("reaction", reaction),
        #("lot-number", lot_number),
        #("status-reason", status_reason),
        #("reason-code", reason_code),
        #("manufacturer", manufacturer),
        #("target-disease", target_disease),
        #("patient", patient),
        #("series", series),
        #("vaccine-code", vaccine_code),
        #("reason-reference", reason_reference),
        #("location", location),
        #("reaction-date", reaction_date),
        #("status", status),
      ]),
    )
    SpImmunizationevaluation(
      date,
      identifier,
      target_disease,
      patient,
      dose_status,
      immunization_event,
      status,
    ) -> #(
      "ImmunizationEvaluation",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("target-disease", target_disease),
        #("patient", patient),
        #("dose-status", dose_status),
        #("immunization-event", immunization_event),
        #("status", status),
      ]),
    )
    SpImmunizationrecommendation(
      date,
      identifier,
      target_disease,
      patient,
      vaccine_type,
      information,
      support,
      status,
    ) -> #(
      "ImmunizationRecommendation",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("target-disease", target_disease),
        #("patient", patient),
        #("vaccine-type", vaccine_type),
        #("information", information),
        #("support", support),
        #("status", status),
      ]),
    )
    SpImplementationguide(
      date,
      context_type_value,
      resource,
      jurisdiction,
      description,
      context_type,
      experimental,
      global,
      title,
      version,
      url,
      context_quantity,
      depends_on,
      context,
      name,
      publisher,
      context_type_quantity,
      status,
    ) -> #(
      "ImplementationGuide",
      using_params([
        #("date", date),
        #("context-type-value", context_type_value),
        #("resource", resource),
        #("jurisdiction", jurisdiction),
        #("description", description),
        #("context-type", context_type),
        #("experimental", experimental),
        #("global", global),
        #("title", title),
        #("version", version),
        #("url", url),
        #("context-quantity", context_quantity),
        #("depends-on", depends_on),
        #("context", context),
        #("name", name),
        #("publisher", publisher),
        #("context-type-quantity", context_type_quantity),
        #("status", status),
      ]),
    )
    SpIngredient(
      substance_definition,
      identifier,
      role,
      function,
      substance,
      for,
      substance_code,
      manufacturer,
    ) -> #(
      "Ingredient",
      using_params([
        #("substance-definition", substance_definition),
        #("identifier", identifier),
        #("role", role),
        #("function", function),
        #("substance", substance),
        #("for", for),
        #("substance-code", substance_code),
        #("manufacturer", manufacturer),
      ]),
    )
    SpInsuranceplan(
      identifier,
      address,
      address_state,
      owned_by,
      type_,
      address_postalcode,
      address_country,
      administered_by,
      endpoint,
      phonetic,
      address_use,
      name,
      address_city,
      status,
    ) -> #(
      "InsurancePlan",
      using_params([
        #("identifier", identifier),
        #("address", address),
        #("address-state", address_state),
        #("owned-by", owned_by),
        #("type", type_),
        #("address-postalcode", address_postalcode),
        #("address-country", address_country),
        #("administered-by", administered_by),
        #("endpoint", endpoint),
        #("phonetic", phonetic),
        #("address-use", address_use),
        #("name", name),
        #("address-city", address_city),
        #("status", status),
      ]),
    )
    SpInvoice(
      date,
      identifier,
      totalgross,
      participant_role,
      subject,
      type_,
      issuer,
      participant,
      totalnet,
      patient,
      recipient,
      account,
      status,
    ) -> #(
      "Invoice",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("totalgross", totalgross),
        #("participant-role", participant_role),
        #("subject", subject),
        #("type", type_),
        #("issuer", issuer),
        #("participant", participant),
        #("totalnet", totalnet),
        #("patient", patient),
        #("recipient", recipient),
        #("account", account),
        #("status", status),
      ]),
    )
    SpLibrary(
      date,
      identifier,
      successor,
      context_type_value,
      jurisdiction,
      derived_from,
      description,
      context_type,
      predecessor,
      composed_of,
      title,
      type_,
      version,
      url,
      context_quantity,
      depends_on,
      effective,
      context,
      name,
      publisher,
      topic,
      content_type,
      context_type_quantity,
      status,
    ) -> #(
      "Library",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("successor", successor),
        #("context-type-value", context_type_value),
        #("jurisdiction", jurisdiction),
        #("derived-from", derived_from),
        #("description", description),
        #("context-type", context_type),
        #("predecessor", predecessor),
        #("composed-of", composed_of),
        #("title", title),
        #("type", type_),
        #("version", version),
        #("url", url),
        #("context-quantity", context_quantity),
        #("depends-on", depends_on),
        #("effective", effective),
        #("context", context),
        #("name", name),
        #("publisher", publisher),
        #("topic", topic),
        #("content-type", content_type),
        #("context-type-quantity", context_type_quantity),
        #("status", status),
      ]),
    )
    SpLinkage(item, author, source) -> #(
      "Linkage",
      using_params([
        #("item", item),
        #("author", author),
        #("source", source),
      ]),
    )
    SpList(
      date,
      identifier,
      empty_reason,
      item,
      code,
      notes,
      patient,
      subject,
      encounter,
      source,
      title,
      status,
    ) -> #(
      "List",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("empty-reason", empty_reason),
        #("item", item),
        #("code", code),
        #("notes", notes),
        #("patient", patient),
        #("subject", subject),
        #("encounter", encounter),
        #("source", source),
        #("title", title),
        #("status", status),
      ]),
    )
    SpLocation(
      identifier,
      partof,
      address,
      address_state,
      operational_status,
      type_,
      address_postalcode,
      address_country,
      endpoint,
      organization,
      address_use,
      name,
      near,
      address_city,
      status,
    ) -> #(
      "Location",
      using_params([
        #("identifier", identifier),
        #("partof", partof),
        #("address", address),
        #("address-state", address_state),
        #("operational-status", operational_status),
        #("type", type_),
        #("address-postalcode", address_postalcode),
        #("address-country", address_country),
        #("endpoint", endpoint),
        #("organization", organization),
        #("address-use", address_use),
        #("name", name),
        #("near", near),
        #("address-city", address_city),
        #("status", status),
      ]),
    )
    SpManufactureditemdefinition(identifier, ingredient, dose_form) -> #(
      "ManufacturedItemDefinition",
      using_params([
        #("identifier", identifier),
        #("ingredient", ingredient),
        #("dose-form", dose_form),
      ]),
    )
    SpMeasure(
      date,
      identifier,
      successor,
      context_type_value,
      jurisdiction,
      derived_from,
      description,
      context_type,
      predecessor,
      composed_of,
      title,
      version,
      url,
      context_quantity,
      depends_on,
      effective,
      context,
      name,
      publisher,
      topic,
      context_type_quantity,
      status,
    ) -> #(
      "Measure",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("successor", successor),
        #("context-type-value", context_type_value),
        #("jurisdiction", jurisdiction),
        #("derived-from", derived_from),
        #("description", description),
        #("context-type", context_type),
        #("predecessor", predecessor),
        #("composed-of", composed_of),
        #("title", title),
        #("version", version),
        #("url", url),
        #("context-quantity", context_quantity),
        #("depends-on", depends_on),
        #("effective", effective),
        #("context", context),
        #("name", name),
        #("publisher", publisher),
        #("topic", topic),
        #("context-type-quantity", context_type_quantity),
        #("status", status),
      ]),
    )
    SpMeasurereport(
      date,
      identifier,
      period,
      measure,
      patient,
      subject,
      reporter,
      evaluated_resource,
      status,
    ) -> #(
      "MeasureReport",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("period", period),
        #("measure", measure),
        #("patient", patient),
        #("subject", subject),
        #("reporter", reporter),
        #("evaluated-resource", evaluated_resource),
        #("status", status),
      ]),
    )
    SpMedia(
      identifier,
      modality,
      created,
      subject,
      encounter,
      type_,
      operator,
      site,
      view,
      based_on,
      patient,
      device,
      status,
    ) -> #(
      "Media",
      using_params([
        #("identifier", identifier),
        #("modality", modality),
        #("created", created),
        #("subject", subject),
        #("encounter", encounter),
        #("type", type_),
        #("operator", operator),
        #("site", site),
        #("view", view),
        #("based-on", based_on),
        #("patient", patient),
        #("device", device),
        #("status", status),
      ]),
    )
    SpMedication(
      ingredient_code,
      identifier,
      code,
      ingredient,
      form,
      lot_number,
      expiration_date,
      manufacturer,
      status,
    ) -> #(
      "Medication",
      using_params([
        #("ingredient-code", ingredient_code),
        #("identifier", identifier),
        #("code", code),
        #("ingredient", ingredient),
        #("form", form),
        #("lot-number", lot_number),
        #("expiration-date", expiration_date),
        #("manufacturer", manufacturer),
        #("status", status),
      ]),
    )
    SpMedicationadministration(
      identifier,
      request,
      code,
      performer,
      subject,
      medication,
      reason_given,
      effective_time,
      patient,
      context,
      reason_not_given,
      device,
      status,
    ) -> #(
      "MedicationAdministration",
      using_params([
        #("identifier", identifier),
        #("request", request),
        #("code", code),
        #("performer", performer),
        #("subject", subject),
        #("medication", medication),
        #("reason-given", reason_given),
        #("effective-time", effective_time),
        #("patient", patient),
        #("context", context),
        #("reason-not-given", reason_not_given),
        #("device", device),
        #("status", status),
      ]),
    )
    SpMedicationdispense(
      identifier,
      code,
      performer,
      receiver,
      subject,
      destination,
      medication,
      responsibleparty,
      type_,
      whenhandedover,
      whenprepared,
      prescription,
      patient,
      context,
      status,
    ) -> #(
      "MedicationDispense",
      using_params([
        #("identifier", identifier),
        #("code", code),
        #("performer", performer),
        #("receiver", receiver),
        #("subject", subject),
        #("destination", destination),
        #("medication", medication),
        #("responsibleparty", responsibleparty),
        #("type", type_),
        #("whenhandedover", whenhandedover),
        #("whenprepared", whenprepared),
        #("prescription", prescription),
        #("patient", patient),
        #("context", context),
        #("status", status),
      ]),
    )
    SpMedicationknowledge(
      code,
      ingredient,
      doseform,
      classification_type,
      monograph_type,
      classification,
      manufacturer,
      ingredient_code,
      source_cost,
      monitoring_program_name,
      monograph,
      monitoring_program_type,
      status,
    ) -> #(
      "MedicationKnowledge",
      using_params([
        #("code", code),
        #("ingredient", ingredient),
        #("doseform", doseform),
        #("classification-type", classification_type),
        #("monograph-type", monograph_type),
        #("classification", classification),
        #("manufacturer", manufacturer),
        #("ingredient-code", ingredient_code),
        #("source-cost", source_cost),
        #("monitoring-program-name", monitoring_program_name),
        #("monograph", monograph),
        #("monitoring-program-type", monitoring_program_type),
        #("status", status),
      ]),
    )
    SpMedicationrequest(
      date,
      requester,
      identifier,
      intended_dispenser,
      authoredon,
      code,
      subject,
      medication,
      encounter,
      priority,
      intent,
      intended_performer,
      patient,
      intended_performertype,
      category,
      status,
    ) -> #(
      "MedicationRequest",
      using_params([
        #("date", date),
        #("requester", requester),
        #("identifier", identifier),
        #("intended-dispenser", intended_dispenser),
        #("authoredon", authoredon),
        #("code", code),
        #("subject", subject),
        #("medication", medication),
        #("encounter", encounter),
        #("priority", priority),
        #("intent", intent),
        #("intended-performer", intended_performer),
        #("patient", patient),
        #("intended-performertype", intended_performertype),
        #("category", category),
        #("status", status),
      ]),
    )
    SpMedicationstatement(
      effective,
      identifier,
      code,
      patient,
      subject,
      context,
      medication,
      part_of,
      source,
      category,
      status,
    ) -> #(
      "MedicationStatement",
      using_params([
        #("effective", effective),
        #("identifier", identifier),
        #("code", code),
        #("patient", patient),
        #("subject", subject),
        #("context", context),
        #("medication", medication),
        #("part-of", part_of),
        #("source", source),
        #("category", category),
        #("status", status),
      ]),
    )
    SpMedicinalproductdefinition(
      identifier,
      ingredient,
      master_file,
      contact,
      domain,
      name,
      name_language,
      type_,
      characteristic,
      characteristic_type,
      product_classification,
      status,
    ) -> #(
      "MedicinalProductDefinition",
      using_params([
        #("identifier", identifier),
        #("ingredient", ingredient),
        #("master-file", master_file),
        #("contact", contact),
        #("domain", domain),
        #("name", name),
        #("name-language", name_language),
        #("type", type_),
        #("characteristic", characteristic),
        #("characteristic-type", characteristic_type),
        #("product-classification", product_classification),
        #("status", status),
      ]),
    )
    SpMessagedefinition(
      date,
      identifier,
      parent,
      context_type_value,
      jurisdiction,
      description,
      focus,
      context_type,
      title,
      version,
      url,
      context_quantity,
      context,
      name,
      publisher,
      category,
      event,
      context_type_quantity,
      status,
    ) -> #(
      "MessageDefinition",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("parent", parent),
        #("context-type-value", context_type_value),
        #("jurisdiction", jurisdiction),
        #("description", description),
        #("focus", focus),
        #("context-type", context_type),
        #("title", title),
        #("version", version),
        #("url", url),
        #("context-quantity", context_quantity),
        #("context", context),
        #("name", name),
        #("publisher", publisher),
        #("category", category),
        #("event", event),
        #("context-type-quantity", context_type_quantity),
        #("status", status),
      ]),
    )
    SpMessageheader(
      code,
      receiver,
      author,
      destination,
      focus,
      source,
      target,
      destination_uri,
      sender,
      source_uri,
      responsible,
      enterer,
      response_id,
      event,
    ) -> #(
      "MessageHeader",
      using_params([
        #("code", code),
        #("receiver", receiver),
        #("author", author),
        #("destination", destination),
        #("focus", focus),
        #("source", source),
        #("target", target),
        #("destination-uri", destination_uri),
        #("sender", sender),
        #("source-uri", source_uri),
        #("responsible", responsible),
        #("enterer", enterer),
        #("response-id", response_id),
        #("event", event),
      ]),
    )
    SpMolecularsequence(
      identifier,
      referenceseqid_variant_coordinate,
      chromosome,
      type_,
      window_end,
      window_start,
      variant_end,
      chromosome_variant_coordinate,
      patient,
      variant_start,
      chromosome_window_coordinate,
      referenceseqid_window_coordinate,
      referenceseqid,
    ) -> #(
      "MolecularSequence",
      using_params([
        #("identifier", identifier),
        #(
          "referenceseqid-variant-coordinate",
          referenceseqid_variant_coordinate,
        ),
        #("chromosome", chromosome),
        #("type", type_),
        #("window-end", window_end),
        #("window-start", window_start),
        #("variant-end", variant_end),
        #("chromosome-variant-coordinate", chromosome_variant_coordinate),
        #("patient", patient),
        #("variant-start", variant_start),
        #("chromosome-window-coordinate", chromosome_window_coordinate),
        #("referenceseqid-window-coordinate", referenceseqid_window_coordinate),
        #("referenceseqid", referenceseqid),
      ]),
    )
    SpNamingsystem(
      date,
      period,
      context_type_value,
      kind,
      jurisdiction,
      description,
      context_type,
      type_,
      id_type,
      context_quantity,
      contact,
      responsible,
      context,
      name,
      publisher,
      telecom,
      value,
      context_type_quantity,
      status,
    ) -> #(
      "NamingSystem",
      using_params([
        #("date", date),
        #("period", period),
        #("context-type-value", context_type_value),
        #("kind", kind),
        #("jurisdiction", jurisdiction),
        #("description", description),
        #("context-type", context_type),
        #("type", type_),
        #("id-type", id_type),
        #("context-quantity", context_quantity),
        #("contact", contact),
        #("responsible", responsible),
        #("context", context),
        #("name", name),
        #("publisher", publisher),
        #("telecom", telecom),
        #("value", value),
        #("context-type-quantity", context_type_quantity),
        #("status", status),
      ]),
    )
    SpNutritionorder(
      identifier,
      datetime,
      provider,
      patient,
      supplement,
      formula,
      instantiates_canonical,
      instantiates_uri,
      encounter,
      oraldiet,
      additive,
      status,
    ) -> #(
      "NutritionOrder",
      using_params([
        #("identifier", identifier),
        #("datetime", datetime),
        #("provider", provider),
        #("patient", patient),
        #("supplement", supplement),
        #("formula", formula),
        #("instantiates-canonical", instantiates_canonical),
        #("instantiates-uri", instantiates_uri),
        #("encounter", encounter),
        #("oraldiet", oraldiet),
        #("additive", additive),
        #("status", status),
      ]),
    )
    SpNutritionproduct(identifier, status) -> #(
      "NutritionProduct",
      using_params([
        #("identifier", identifier),
        #("status", status),
      ]),
    )
    SpObservation(
      date,
      combo_data_absent_reason,
      code,
      combo_code_value_quantity,
      component_data_absent_reason,
      subject,
      value_concept,
      value_date,
      derived_from,
      focus,
      part_of,
      has_member,
      code_value_string,
      component_code_value_quantity,
      based_on,
      code_value_date,
      patient,
      specimen,
      code_value_quantity,
      component_code,
      combo_code_value_concept,
      value_string,
      identifier,
      performer,
      combo_code,
      method,
      value_quantity,
      component_value_quantity,
      data_absent_reason,
      combo_value_quantity,
      encounter,
      code_value_concept,
      component_code_value_concept,
      component_value_concept,
      category,
      device,
      combo_value_concept,
      status,
    ) -> #(
      "Observation",
      using_params([
        #("date", date),
        #("combo-data-absent-reason", combo_data_absent_reason),
        #("code", code),
        #("combo-code-value-quantity", combo_code_value_quantity),
        #("component-data-absent-reason", component_data_absent_reason),
        #("subject", subject),
        #("value-concept", value_concept),
        #("value-date", value_date),
        #("derived-from", derived_from),
        #("focus", focus),
        #("part-of", part_of),
        #("has-member", has_member),
        #("code-value-string", code_value_string),
        #("component-code-value-quantity", component_code_value_quantity),
        #("based-on", based_on),
        #("code-value-date", code_value_date),
        #("patient", patient),
        #("specimen", specimen),
        #("code-value-quantity", code_value_quantity),
        #("component-code", component_code),
        #("combo-code-value-concept", combo_code_value_concept),
        #("value-string", value_string),
        #("identifier", identifier),
        #("performer", performer),
        #("combo-code", combo_code),
        #("method", method),
        #("value-quantity", value_quantity),
        #("component-value-quantity", component_value_quantity),
        #("data-absent-reason", data_absent_reason),
        #("combo-value-quantity", combo_value_quantity),
        #("encounter", encounter),
        #("code-value-concept", code_value_concept),
        #("component-code-value-concept", component_code_value_concept),
        #("component-value-concept", component_value_concept),
        #("category", category),
        #("device", device),
        #("combo-value-concept", combo_value_concept),
        #("status", status),
      ]),
    )
    SpObservationdefinition -> #("ObservationDefinition", using_params([]))
    SpOperationdefinition(
      date,
      code,
      instance,
      context_type_value,
      kind,
      jurisdiction,
      description,
      context_type,
      title,
      type_,
      version,
      url,
      context_quantity,
      input_profile,
      output_profile,
      system,
      context,
      name,
      publisher,
      context_type_quantity,
      base,
      status,
    ) -> #(
      "OperationDefinition",
      using_params([
        #("date", date),
        #("code", code),
        #("instance", instance),
        #("context-type-value", context_type_value),
        #("kind", kind),
        #("jurisdiction", jurisdiction),
        #("description", description),
        #("context-type", context_type),
        #("title", title),
        #("type", type_),
        #("version", version),
        #("url", url),
        #("context-quantity", context_quantity),
        #("input-profile", input_profile),
        #("output-profile", output_profile),
        #("system", system),
        #("context", context),
        #("name", name),
        #("publisher", publisher),
        #("context-type-quantity", context_type_quantity),
        #("base", base),
        #("status", status),
      ]),
    )
    SpOperationoutcome -> #("OperationOutcome", using_params([]))
    SpOrganization(
      identifier,
      partof,
      address,
      address_state,
      active,
      type_,
      address_postalcode,
      address_country,
      endpoint,
      phonetic,
      address_use,
      name,
      address_city,
    ) -> #(
      "Organization",
      using_params([
        #("identifier", identifier),
        #("partof", partof),
        #("address", address),
        #("address-state", address_state),
        #("active", active),
        #("type", type_),
        #("address-postalcode", address_postalcode),
        #("address-country", address_country),
        #("endpoint", endpoint),
        #("phonetic", phonetic),
        #("address-use", address_use),
        #("name", name),
        #("address-city", address_city),
      ]),
    )
    SpOrganizationaffiliation(
      date,
      identifier,
      specialty,
      role,
      active,
      primary_organization,
      network,
      endpoint,
      phone,
      service,
      participating_organization,
      location,
      telecom,
      email,
    ) -> #(
      "OrganizationAffiliation",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("specialty", specialty),
        #("role", role),
        #("active", active),
        #("primary-organization", primary_organization),
        #("network", network),
        #("endpoint", endpoint),
        #("phone", phone),
        #("service", service),
        #("participating-organization", participating_organization),
        #("location", location),
        #("telecom", telecom),
        #("email", email),
      ]),
    )
    SpPackagedproductdefinition(
      identifier,
      manufactured_item,
      nutrition,
      package,
      name,
      biological,
      package_for,
      contained_item,
      medication,
      device,
      status,
    ) -> #(
      "PackagedProductDefinition",
      using_params([
        #("identifier", identifier),
        #("manufactured-item", manufactured_item),
        #("nutrition", nutrition),
        #("package", package),
        #("name", name),
        #("biological", biological),
        #("package-for", package_for),
        #("contained-item", contained_item),
        #("medication", medication),
        #("device", device),
        #("status", status),
      ]),
    )
    SpPatient(
      given,
      identifier,
      address,
      birthdate,
      deceased,
      address_state,
      gender,
      general_practitioner,
      link,
      active,
      language,
      address_postalcode,
      address_country,
      death_date,
      phonetic,
      phone,
      organization,
      address_use,
      name,
      telecom,
      address_city,
      family,
      email,
    ) -> #(
      "Patient",
      using_params([
        #("given", given),
        #("identifier", identifier),
        #("address", address),
        #("birthdate", birthdate),
        #("deceased", deceased),
        #("address-state", address_state),
        #("gender", gender),
        #("general-practitioner", general_practitioner),
        #("link", link),
        #("active", active),
        #("language", language),
        #("address-postalcode", address_postalcode),
        #("address-country", address_country),
        #("death-date", death_date),
        #("phonetic", phonetic),
        #("phone", phone),
        #("organization", organization),
        #("address-use", address_use),
        #("name", name),
        #("telecom", telecom),
        #("address-city", address_city),
        #("family", family),
        #("email", email),
      ]),
    )
    SpPaymentnotice(
      identifier,
      request,
      provider,
      created,
      response,
      payment_status,
      status,
    ) -> #(
      "PaymentNotice",
      using_params([
        #("identifier", identifier),
        #("request", request),
        #("provider", provider),
        #("created", created),
        #("response", response),
        #("payment-status", payment_status),
        #("status", status),
      ]),
    )
    SpPaymentreconciliation(
      identifier,
      request,
      disposition,
      created,
      outcome,
      payment_issuer,
      requestor,
      status,
    ) -> #(
      "PaymentReconciliation",
      using_params([
        #("identifier", identifier),
        #("request", request),
        #("disposition", disposition),
        #("created", created),
        #("outcome", outcome),
        #("payment-issuer", payment_issuer),
        #("requestor", requestor),
        #("status", status),
      ]),
    )
    SpPerson(
      identifier,
      address,
      birthdate,
      address_state,
      gender,
      practitioner,
      link,
      relatedperson,
      address_postalcode,
      address_country,
      phonetic,
      phone,
      patient,
      organization,
      address_use,
      name,
      telecom,
      address_city,
      email,
    ) -> #(
      "Person",
      using_params([
        #("identifier", identifier),
        #("address", address),
        #("birthdate", birthdate),
        #("address-state", address_state),
        #("gender", gender),
        #("practitioner", practitioner),
        #("link", link),
        #("relatedperson", relatedperson),
        #("address-postalcode", address_postalcode),
        #("address-country", address_country),
        #("phonetic", phonetic),
        #("phone", phone),
        #("patient", patient),
        #("organization", organization),
        #("address-use", address_use),
        #("name", name),
        #("telecom", telecom),
        #("address-city", address_city),
        #("email", email),
      ]),
    )
    SpPlandefinition(
      date,
      identifier,
      successor,
      context_type_value,
      jurisdiction,
      derived_from,
      description,
      context_type,
      predecessor,
      composed_of,
      title,
      type_,
      version,
      url,
      context_quantity,
      depends_on,
      effective,
      context,
      name,
      publisher,
      topic,
      definition,
      context_type_quantity,
      status,
    ) -> #(
      "PlanDefinition",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("successor", successor),
        #("context-type-value", context_type_value),
        #("jurisdiction", jurisdiction),
        #("derived-from", derived_from),
        #("description", description),
        #("context-type", context_type),
        #("predecessor", predecessor),
        #("composed-of", composed_of),
        #("title", title),
        #("type", type_),
        #("version", version),
        #("url", url),
        #("context-quantity", context_quantity),
        #("depends-on", depends_on),
        #("effective", effective),
        #("context", context),
        #("name", name),
        #("publisher", publisher),
        #("topic", topic),
        #("definition", definition),
        #("context-type-quantity", context_type_quantity),
        #("status", status),
      ]),
    )
    SpPractitioner(
      given,
      identifier,
      address,
      address_state,
      gender,
      active,
      address_postalcode,
      address_country,
      phonetic,
      phone,
      address_use,
      name,
      telecom,
      address_city,
      communication,
      family,
      email,
    ) -> #(
      "Practitioner",
      using_params([
        #("given", given),
        #("identifier", identifier),
        #("address", address),
        #("address-state", address_state),
        #("gender", gender),
        #("active", active),
        #("address-postalcode", address_postalcode),
        #("address-country", address_country),
        #("phonetic", phonetic),
        #("phone", phone),
        #("address-use", address_use),
        #("name", name),
        #("telecom", telecom),
        #("address-city", address_city),
        #("communication", communication),
        #("family", family),
        #("email", email),
      ]),
    )
    SpPractitionerrole(
      date,
      identifier,
      specialty,
      role,
      practitioner,
      active,
      endpoint,
      phone,
      service,
      organization,
      location,
      telecom,
      email,
    ) -> #(
      "PractitionerRole",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("specialty", specialty),
        #("role", role),
        #("practitioner", practitioner),
        #("active", active),
        #("endpoint", endpoint),
        #("phone", phone),
        #("service", service),
        #("organization", organization),
        #("location", location),
        #("telecom", telecom),
        #("email", email),
      ]),
    )
    SpProcedure(
      date,
      identifier,
      code,
      performer,
      subject,
      instantiates_canonical,
      part_of,
      encounter,
      reason_code,
      based_on,
      patient,
      reason_reference,
      instantiates_uri,
      location,
      category,
      status,
    ) -> #(
      "Procedure",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("code", code),
        #("performer", performer),
        #("subject", subject),
        #("instantiates-canonical", instantiates_canonical),
        #("part-of", part_of),
        #("encounter", encounter),
        #("reason-code", reason_code),
        #("based-on", based_on),
        #("patient", patient),
        #("reason-reference", reason_reference),
        #("instantiates-uri", instantiates_uri),
        #("location", location),
        #("category", category),
        #("status", status),
      ]),
    )
    SpProvenance(
      agent_type,
      agent,
      signature_type,
      patient,
      location,
      agent_role,
      recorded,
      when,
      entity,
      target,
    ) -> #(
      "Provenance",
      using_params([
        #("agent-type", agent_type),
        #("agent", agent),
        #("signature-type", signature_type),
        #("patient", patient),
        #("location", location),
        #("agent-role", agent_role),
        #("recorded", recorded),
        #("when", when),
        #("entity", entity),
        #("target", target),
      ]),
    )
    SpQuestionnaire(
      date,
      identifier,
      code,
      context_type_value,
      jurisdiction,
      description,
      context_type,
      title,
      version,
      url,
      context_quantity,
      effective,
      subject_type,
      context,
      name,
      publisher,
      definition,
      context_type_quantity,
      status,
    ) -> #(
      "Questionnaire",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("code", code),
        #("context-type-value", context_type_value),
        #("jurisdiction", jurisdiction),
        #("description", description),
        #("context-type", context_type),
        #("title", title),
        #("version", version),
        #("url", url),
        #("context-quantity", context_quantity),
        #("effective", effective),
        #("subject-type", subject_type),
        #("context", context),
        #("name", name),
        #("publisher", publisher),
        #("definition", definition),
        #("context-type-quantity", context_type_quantity),
        #("status", status),
      ]),
    )
    SpQuestionnaireresponse(
      authored,
      identifier,
      questionnaire,
      based_on,
      author,
      patient,
      subject,
      part_of,
      encounter,
      source,
      status,
    ) -> #(
      "QuestionnaireResponse",
      using_params([
        #("authored", authored),
        #("identifier", identifier),
        #("questionnaire", questionnaire),
        #("based-on", based_on),
        #("author", author),
        #("patient", patient),
        #("subject", subject),
        #("part-of", part_of),
        #("encounter", encounter),
        #("source", source),
        #("status", status),
      ]),
    )
    SpRegulatedauthorization(
      identifier,
      subject,
      case_type,
      holder,
      region,
      case_,
      status,
    ) -> #(
      "RegulatedAuthorization",
      using_params([
        #("identifier", identifier),
        #("subject", subject),
        #("case-type", case_type),
        #("holder", holder),
        #("region", region),
        #("case", case_),
        #("status", status),
      ]),
    )
    SpRelatedperson(
      identifier,
      address,
      birthdate,
      address_state,
      gender,
      active,
      address_postalcode,
      address_country,
      phonetic,
      phone,
      patient,
      address_use,
      name,
      telecom,
      address_city,
      relationship,
      email,
    ) -> #(
      "RelatedPerson",
      using_params([
        #("identifier", identifier),
        #("address", address),
        #("birthdate", birthdate),
        #("address-state", address_state),
        #("gender", gender),
        #("active", active),
        #("address-postalcode", address_postalcode),
        #("address-country", address_country),
        #("phonetic", phonetic),
        #("phone", phone),
        #("patient", patient),
        #("address-use", address_use),
        #("name", name),
        #("telecom", telecom),
        #("address-city", address_city),
        #("relationship", relationship),
        #("email", email),
      ]),
    )
    SpRequestgroup(
      authored,
      identifier,
      code,
      author,
      subject,
      instantiates_canonical,
      encounter,
      priority,
      intent,
      participant,
      group_identifier,
      patient,
      instantiates_uri,
      status,
    ) -> #(
      "RequestGroup",
      using_params([
        #("authored", authored),
        #("identifier", identifier),
        #("code", code),
        #("author", author),
        #("subject", subject),
        #("instantiates-canonical", instantiates_canonical),
        #("encounter", encounter),
        #("priority", priority),
        #("intent", intent),
        #("participant", participant),
        #("group-identifier", group_identifier),
        #("patient", patient),
        #("instantiates-uri", instantiates_uri),
        #("status", status),
      ]),
    )
    SpResearchdefinition(
      date,
      identifier,
      successor,
      context_type_value,
      jurisdiction,
      derived_from,
      description,
      context_type,
      predecessor,
      composed_of,
      title,
      version,
      url,
      context_quantity,
      depends_on,
      effective,
      context,
      name,
      publisher,
      topic,
      context_type_quantity,
      status,
    ) -> #(
      "ResearchDefinition",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("successor", successor),
        #("context-type-value", context_type_value),
        #("jurisdiction", jurisdiction),
        #("derived-from", derived_from),
        #("description", description),
        #("context-type", context_type),
        #("predecessor", predecessor),
        #("composed-of", composed_of),
        #("title", title),
        #("version", version),
        #("url", url),
        #("context-quantity", context_quantity),
        #("depends-on", depends_on),
        #("effective", effective),
        #("context", context),
        #("name", name),
        #("publisher", publisher),
        #("topic", topic),
        #("context-type-quantity", context_type_quantity),
        #("status", status),
      ]),
    )
    SpResearchelementdefinition(
      date,
      identifier,
      successor,
      context_type_value,
      jurisdiction,
      derived_from,
      description,
      context_type,
      predecessor,
      composed_of,
      title,
      version,
      url,
      context_quantity,
      depends_on,
      effective,
      context,
      name,
      publisher,
      topic,
      context_type_quantity,
      status,
    ) -> #(
      "ResearchElementDefinition",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("successor", successor),
        #("context-type-value", context_type_value),
        #("jurisdiction", jurisdiction),
        #("derived-from", derived_from),
        #("description", description),
        #("context-type", context_type),
        #("predecessor", predecessor),
        #("composed-of", composed_of),
        #("title", title),
        #("version", version),
        #("url", url),
        #("context-quantity", context_quantity),
        #("depends-on", depends_on),
        #("effective", effective),
        #("context", context),
        #("name", name),
        #("publisher", publisher),
        #("topic", topic),
        #("context-type-quantity", context_type_quantity),
        #("status", status),
      ]),
    )
    SpResearchstudy(
      date,
      identifier,
      partof,
      sponsor,
      focus,
      principalinvestigator,
      title,
      protocol,
      site,
      location,
      category,
      keyword,
      status,
    ) -> #(
      "ResearchStudy",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("partof", partof),
        #("sponsor", sponsor),
        #("focus", focus),
        #("principalinvestigator", principalinvestigator),
        #("title", title),
        #("protocol", protocol),
        #("site", site),
        #("location", location),
        #("category", category),
        #("keyword", keyword),
        #("status", status),
      ]),
    )
    SpResearchsubject(date, identifier, study, individual, patient, status) -> #(
      "ResearchSubject",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("study", study),
        #("individual", individual),
        #("patient", patient),
        #("status", status),
      ]),
    )
    SpRiskassessment(
      date,
      identifier,
      condition,
      performer,
      method,
      patient,
      probability,
      subject,
      risk,
      encounter,
    ) -> #(
      "RiskAssessment",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("condition", condition),
        #("performer", performer),
        #("method", method),
        #("patient", patient),
        #("probability", probability),
        #("subject", subject),
        #("risk", risk),
        #("encounter", encounter),
      ]),
    )
    SpSchedule(
      actor,
      date,
      identifier,
      specialty,
      service_category,
      service_type,
      active,
    ) -> #(
      "Schedule",
      using_params([
        #("actor", actor),
        #("date", date),
        #("identifier", identifier),
        #("specialty", specialty),
        #("service-category", service_category),
        #("service-type", service_type),
        #("active", active),
      ]),
    )
    SpSearchparameter(
      date,
      code,
      context_type_value,
      jurisdiction,
      derived_from,
      description,
      context_type,
      type_,
      version,
      url,
      target,
      context_quantity,
      component,
      context,
      name,
      publisher,
      context_type_quantity,
      base,
      status,
    ) -> #(
      "SearchParameter",
      using_params([
        #("date", date),
        #("code", code),
        #("context-type-value", context_type_value),
        #("jurisdiction", jurisdiction),
        #("derived-from", derived_from),
        #("description", description),
        #("context-type", context_type),
        #("type", type_),
        #("version", version),
        #("url", url),
        #("target", target),
        #("context-quantity", context_quantity),
        #("component", component),
        #("context", context),
        #("name", name),
        #("publisher", publisher),
        #("context-type-quantity", context_type_quantity),
        #("base", base),
        #("status", status),
      ]),
    )
    SpServicerequest(
      authored,
      requester,
      identifier,
      code,
      performer,
      requisition,
      replaces,
      subject,
      instantiates_canonical,
      encounter,
      occurrence,
      priority,
      intent,
      performer_type,
      based_on,
      patient,
      specimen,
      instantiates_uri,
      body_site,
      category,
      status,
    ) -> #(
      "ServiceRequest",
      using_params([
        #("authored", authored),
        #("requester", requester),
        #("identifier", identifier),
        #("code", code),
        #("performer", performer),
        #("requisition", requisition),
        #("replaces", replaces),
        #("subject", subject),
        #("instantiates-canonical", instantiates_canonical),
        #("encounter", encounter),
        #("occurrence", occurrence),
        #("priority", priority),
        #("intent", intent),
        #("performer-type", performer_type),
        #("based-on", based_on),
        #("patient", patient),
        #("specimen", specimen),
        #("instantiates-uri", instantiates_uri),
        #("body-site", body_site),
        #("category", category),
        #("status", status),
      ]),
    )
    SpSlot(
      identifier,
      schedule,
      specialty,
      service_category,
      appointment_type,
      service_type,
      start,
      status,
    ) -> #(
      "Slot",
      using_params([
        #("identifier", identifier),
        #("schedule", schedule),
        #("specialty", specialty),
        #("service-category", service_category),
        #("appointment-type", appointment_type),
        #("service-type", service_type),
        #("start", start),
        #("status", status),
      ]),
    )
    SpSpecimen(
      container,
      container_id,
      identifier,
      parent,
      bodysite,
      patient,
      subject,
      collected,
      accession,
      type_,
      collector,
      status,
    ) -> #(
      "Specimen",
      using_params([
        #("container", container),
        #("container-id", container_id),
        #("identifier", identifier),
        #("parent", parent),
        #("bodysite", bodysite),
        #("patient", patient),
        #("subject", subject),
        #("collected", collected),
        #("accession", accession),
        #("type", type_),
        #("collector", collector),
        #("status", status),
      ]),
    )
    SpSpecimendefinition(container, identifier, type_) -> #(
      "SpecimenDefinition",
      using_params([
        #("container", container),
        #("identifier", identifier),
        #("type", type_),
      ]),
    )
    SpStructuredefinition(
      date,
      context_type_value,
      jurisdiction,
      description,
      context_type,
      experimental,
      title,
      type_,
      context_quantity,
      path,
      base_path,
      context,
      keyword,
      context_type_quantity,
      identifier,
      valueset,
      kind,
      abstract,
      version,
      url,
      ext_context,
      name,
      publisher,
      derivation,
      base,
      status,
    ) -> #(
      "StructureDefinition",
      using_params([
        #("date", date),
        #("context-type-value", context_type_value),
        #("jurisdiction", jurisdiction),
        #("description", description),
        #("context-type", context_type),
        #("experimental", experimental),
        #("title", title),
        #("type", type_),
        #("context-quantity", context_quantity),
        #("path", path),
        #("base-path", base_path),
        #("context", context),
        #("keyword", keyword),
        #("context-type-quantity", context_type_quantity),
        #("identifier", identifier),
        #("valueset", valueset),
        #("kind", kind),
        #("abstract", abstract),
        #("version", version),
        #("url", url),
        #("ext-context", ext_context),
        #("name", name),
        #("publisher", publisher),
        #("derivation", derivation),
        #("base", base),
        #("status", status),
      ]),
    )
    SpStructuremap(
      date,
      identifier,
      context_type_value,
      jurisdiction,
      description,
      context_type,
      title,
      version,
      url,
      context_quantity,
      context,
      name,
      publisher,
      context_type_quantity,
      status,
    ) -> #(
      "StructureMap",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("context-type-value", context_type_value),
        #("jurisdiction", jurisdiction),
        #("description", description),
        #("context-type", context_type),
        #("title", title),
        #("version", version),
        #("url", url),
        #("context-quantity", context_quantity),
        #("context", context),
        #("name", name),
        #("publisher", publisher),
        #("context-type-quantity", context_type_quantity),
        #("status", status),
      ]),
    )
    SpSubscription(payload, criteria, contact, type_, url, status) -> #(
      "Subscription",
      using_params([
        #("payload", payload),
        #("criteria", criteria),
        #("contact", contact),
        #("type", type_),
        #("url", url),
        #("status", status),
      ]),
    )
    SpSubscriptionstatus -> #("SubscriptionStatus", using_params([]))
    SpSubscriptiontopic(
      date,
      identifier,
      resource,
      derived_or_self,
      title,
      version,
      url,
      status,
      trigger_description,
    ) -> #(
      "SubscriptionTopic",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("resource", resource),
        #("derived-or-self", derived_or_self),
        #("title", title),
        #("version", version),
        #("url", url),
        #("status", status),
        #("trigger-description", trigger_description),
      ]),
    )
    SpSubstance(
      identifier,
      container_identifier,
      code,
      quantity,
      substance_reference,
      expiry,
      category,
      status,
    ) -> #(
      "Substance",
      using_params([
        #("identifier", identifier),
        #("container-identifier", container_identifier),
        #("code", code),
        #("quantity", quantity),
        #("substance-reference", substance_reference),
        #("expiry", expiry),
        #("category", category),
        #("status", status),
      ]),
    )
    SpSubstancedefinition(identifier, code, domain, name, classification) -> #(
      "SubstanceDefinition",
      using_params([
        #("identifier", identifier),
        #("code", code),
        #("domain", domain),
        #("name", name),
        #("classification", classification),
      ]),
    )
    SpSupplydelivery(identifier, receiver, patient, supplier, status) -> #(
      "SupplyDelivery",
      using_params([
        #("identifier", identifier),
        #("receiver", receiver),
        #("patient", patient),
        #("supplier", supplier),
        #("status", status),
      ]),
    )
    SpSupplyrequest(
      date,
      requester,
      identifier,
      subject,
      supplier,
      category,
      status,
    ) -> #(
      "SupplyRequest",
      using_params([
        #("date", date),
        #("requester", requester),
        #("identifier", identifier),
        #("subject", subject),
        #("supplier", supplier),
        #("category", category),
        #("status", status),
      ]),
    )
    SpTask(
      owner,
      requester,
      business_status,
      identifier,
      period,
      code,
      performer,
      subject,
      focus,
      part_of,
      encounter,
      authored_on,
      priority,
      intent,
      group_identifier,
      based_on,
      patient,
      modified,
      status,
    ) -> #(
      "Task",
      using_params([
        #("owner", owner),
        #("requester", requester),
        #("business-status", business_status),
        #("identifier", identifier),
        #("period", period),
        #("code", code),
        #("performer", performer),
        #("subject", subject),
        #("focus", focus),
        #("part-of", part_of),
        #("encounter", encounter),
        #("authored-on", authored_on),
        #("priority", priority),
        #("intent", intent),
        #("group-identifier", group_identifier),
        #("based-on", based_on),
        #("patient", patient),
        #("modified", modified),
        #("status", status),
      ]),
    )
    SpTerminologycapabilities(
      date,
      context_type_value,
      jurisdiction,
      description,
      context_type,
      title,
      version,
      url,
      context_quantity,
      context,
      name,
      publisher,
      context_type_quantity,
      status,
    ) -> #(
      "TerminologyCapabilities",
      using_params([
        #("date", date),
        #("context-type-value", context_type_value),
        #("jurisdiction", jurisdiction),
        #("description", description),
        #("context-type", context_type),
        #("title", title),
        #("version", version),
        #("url", url),
        #("context-quantity", context_quantity),
        #("context", context),
        #("name", name),
        #("publisher", publisher),
        #("context-type-quantity", context_type_quantity),
        #("status", status),
      ]),
    )
    SpTestreport(result, identifier, tester, testscript, issued, participant) -> #(
      "TestReport",
      using_params([
        #("result", result),
        #("identifier", identifier),
        #("tester", tester),
        #("testscript", testscript),
        #("issued", issued),
        #("participant", participant),
      ]),
    )
    SpTestscript(
      date,
      identifier,
      context_type_value,
      jurisdiction,
      description,
      testscript_capability,
      context_type,
      title,
      version,
      url,
      context_quantity,
      context,
      name,
      publisher,
      context_type_quantity,
      status,
    ) -> #(
      "TestScript",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("context-type-value", context_type_value),
        #("jurisdiction", jurisdiction),
        #("description", description),
        #("testscript-capability", testscript_capability),
        #("context-type", context_type),
        #("title", title),
        #("version", version),
        #("url", url),
        #("context-quantity", context_quantity),
        #("context", context),
        #("name", name),
        #("publisher", publisher),
        #("context-type-quantity", context_type_quantity),
        #("status", status),
      ]),
    )
    SpValueset(
      date,
      identifier,
      code,
      context_type_value,
      jurisdiction,
      description,
      context_type,
      title,
      version,
      url,
      expansion,
      reference,
      context_quantity,
      context,
      name,
      publisher,
      context_type_quantity,
      status,
    ) -> #(
      "ValueSet",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("code", code),
        #("context-type-value", context_type_value),
        #("jurisdiction", jurisdiction),
        #("description", description),
        #("context-type", context_type),
        #("title", title),
        #("version", version),
        #("url", url),
        #("expansion", expansion),
        #("reference", reference),
        #("context-quantity", context_quantity),
        #("context", context),
        #("name", name),
        #("publisher", publisher),
        #("context-type-quantity", context_type_quantity),
        #("status", status),
      ]),
    )
    SpVerificationresult(target) -> #(
      "VerificationResult",
      using_params([
        #("target", target),
      ]),
    )
    SpVisionprescription(
      prescriber,
      identifier,
      patient,
      datewritten,
      encounter,
      status,
    ) -> #(
      "VisionPrescription",
      using_params([
        #("prescriber", prescriber),
        #("identifier", identifier),
        #("patient", patient),
        #("datewritten", datewritten),
        #("encounter", encounter),
        #("status", status),
      ]),
    )
  }
  let assert Ok(req) =
    request.to(
      string.concat([
        client.baseurl |> uri.to_string,
        "/",
        res_type,
        "?",
        string.join(params_to_encode, "&"),
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
        Some(p) -> [param.0 <> ":" <> p, ..acc]
      }
    },
  )
}
