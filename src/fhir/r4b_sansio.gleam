import fhir/r4b
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
