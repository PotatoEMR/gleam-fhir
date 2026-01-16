import fhir/r5
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
  ErrOperationcome(r5.Operationoutcome)
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
      True -> r5.operationoutcome_decoder() |> decode.map(fn(x) { Error(x) })
    })
  case decoded_resource {
    Ok(Ok(resource)) -> Ok(resource)
    Ok(Error(op_outcome)) -> Error(ErrOperationcome(op_outcome))
    Error(dec_err) -> Error(ErrDecode(dec_err))
  }
}

pub fn account_create_req(
  resource: r5.Account,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.account_to_json(resource), "Account", client)
}

pub fn account_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Account", client)
}

pub fn account_update_req(
  resource: r5.Account,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.account_to_json(resource), "Account", client)
}

pub fn account_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Account", client)
}

pub fn account_resp(resp: Response(String)) -> Result(r5.Account, Err) {
  any_resp(resp, r5.account_decoder())
}

pub fn activitydefinition_create_req(
  resource: r5.Activitydefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.activitydefinition_to_json(resource),
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
  resource: r5.Activitydefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.activitydefinition_to_json(resource),
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
) -> Result(r5.Activitydefinition, Err) {
  any_resp(resp, r5.activitydefinition_decoder())
}

pub fn actordefinition_create_req(
  resource: r5.Actordefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.actordefinition_to_json(resource),
    "ActorDefinition",
    client,
  )
}

pub fn actordefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "ActorDefinition", client)
}

pub fn actordefinition_update_req(
  resource: r5.Actordefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.actordefinition_to_json(resource),
    "ActorDefinition",
    client,
  )
}

pub fn actordefinition_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "ActorDefinition", client)
}

pub fn actordefinition_resp(
  resp: Response(String),
) -> Result(r5.Actordefinition, Err) {
  any_resp(resp, r5.actordefinition_decoder())
}

pub fn administrableproductdefinition_create_req(
  resource: r5.Administrableproductdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.administrableproductdefinition_to_json(resource),
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
  resource: r5.Administrableproductdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.administrableproductdefinition_to_json(resource),
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
) -> Result(r5.Administrableproductdefinition, Err) {
  any_resp(resp, r5.administrableproductdefinition_decoder())
}

pub fn adverseevent_create_req(
  resource: r5.Adverseevent,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.adverseevent_to_json(resource), "AdverseEvent", client)
}

pub fn adverseevent_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "AdverseEvent", client)
}

pub fn adverseevent_update_req(
  resource: r5.Adverseevent,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.adverseevent_to_json(resource),
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

pub fn adverseevent_resp(resp: Response(String)) -> Result(r5.Adverseevent, Err) {
  any_resp(resp, r5.adverseevent_decoder())
}

pub fn allergyintolerance_create_req(
  resource: r5.Allergyintolerance,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.allergyintolerance_to_json(resource),
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
  resource: r5.Allergyintolerance,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.allergyintolerance_to_json(resource),
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
) -> Result(r5.Allergyintolerance, Err) {
  any_resp(resp, r5.allergyintolerance_decoder())
}

pub fn appointment_create_req(
  resource: r5.Appointment,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.appointment_to_json(resource), "Appointment", client)
}

pub fn appointment_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Appointment", client)
}

pub fn appointment_update_req(
  resource: r5.Appointment,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.appointment_to_json(resource),
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

pub fn appointment_resp(resp: Response(String)) -> Result(r5.Appointment, Err) {
  any_resp(resp, r5.appointment_decoder())
}

pub fn appointmentresponse_create_req(
  resource: r5.Appointmentresponse,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.appointmentresponse_to_json(resource),
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
  resource: r5.Appointmentresponse,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.appointmentresponse_to_json(resource),
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
) -> Result(r5.Appointmentresponse, Err) {
  any_resp(resp, r5.appointmentresponse_decoder())
}

pub fn artifactassessment_create_req(
  resource: r5.Artifactassessment,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.artifactassessment_to_json(resource),
    "ArtifactAssessment",
    client,
  )
}

pub fn artifactassessment_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "ArtifactAssessment", client)
}

pub fn artifactassessment_update_req(
  resource: r5.Artifactassessment,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.artifactassessment_to_json(resource),
    "ArtifactAssessment",
    client,
  )
}

pub fn artifactassessment_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "ArtifactAssessment", client)
}

pub fn artifactassessment_resp(
  resp: Response(String),
) -> Result(r5.Artifactassessment, Err) {
  any_resp(resp, r5.artifactassessment_decoder())
}

pub fn auditevent_create_req(
  resource: r5.Auditevent,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.auditevent_to_json(resource), "AuditEvent", client)
}

pub fn auditevent_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "AuditEvent", client)
}

pub fn auditevent_update_req(
  resource: r5.Auditevent,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.auditevent_to_json(resource),
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

pub fn auditevent_resp(resp: Response(String)) -> Result(r5.Auditevent, Err) {
  any_resp(resp, r5.auditevent_decoder())
}

pub fn basic_create_req(
  resource: r5.Basic,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.basic_to_json(resource), "Basic", client)
}

pub fn basic_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Basic", client)
}

pub fn basic_update_req(
  resource: r5.Basic,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.basic_to_json(resource), "Basic", client)
}

pub fn basic_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Basic", client)
}

pub fn basic_resp(resp: Response(String)) -> Result(r5.Basic, Err) {
  any_resp(resp, r5.basic_decoder())
}

pub fn binary_create_req(
  resource: r5.Binary,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.binary_to_json(resource), "Binary", client)
}

pub fn binary_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Binary", client)
}

pub fn binary_update_req(
  resource: r5.Binary,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.binary_to_json(resource), "Binary", client)
}

pub fn binary_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Binary", client)
}

pub fn binary_resp(resp: Response(String)) -> Result(r5.Binary, Err) {
  any_resp(resp, r5.binary_decoder())
}

pub fn biologicallyderivedproduct_create_req(
  resource: r5.Biologicallyderivedproduct,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.biologicallyderivedproduct_to_json(resource),
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
  resource: r5.Biologicallyderivedproduct,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.biologicallyderivedproduct_to_json(resource),
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
) -> Result(r5.Biologicallyderivedproduct, Err) {
  any_resp(resp, r5.biologicallyderivedproduct_decoder())
}

pub fn biologicallyderivedproductdispense_create_req(
  resource: r5.Biologicallyderivedproductdispense,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.biologicallyderivedproductdispense_to_json(resource),
    "BiologicallyDerivedProductDispense",
    client,
  )
}

pub fn biologicallyderivedproductdispense_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "BiologicallyDerivedProductDispense", client)
}

pub fn biologicallyderivedproductdispense_update_req(
  resource: r5.Biologicallyderivedproductdispense,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.biologicallyderivedproductdispense_to_json(resource),
    "BiologicallyDerivedProductDispense",
    client,
  )
}

pub fn biologicallyderivedproductdispense_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "BiologicallyDerivedProductDispense", client)
}

pub fn biologicallyderivedproductdispense_resp(
  resp: Response(String),
) -> Result(r5.Biologicallyderivedproductdispense, Err) {
  any_resp(resp, r5.biologicallyderivedproductdispense_decoder())
}

pub fn bodystructure_create_req(
  resource: r5.Bodystructure,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.bodystructure_to_json(resource), "BodyStructure", client)
}

pub fn bodystructure_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "BodyStructure", client)
}

pub fn bodystructure_update_req(
  resource: r5.Bodystructure,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.bodystructure_to_json(resource),
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
) -> Result(r5.Bodystructure, Err) {
  any_resp(resp, r5.bodystructure_decoder())
}

pub fn bundle_create_req(
  resource: r5.Bundle,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.bundle_to_json(resource), "Bundle", client)
}

pub fn bundle_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Bundle", client)
}

pub fn bundle_update_req(
  resource: r5.Bundle,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.bundle_to_json(resource), "Bundle", client)
}

pub fn bundle_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Bundle", client)
}

pub fn bundle_resp(resp: Response(String)) -> Result(r5.Bundle, Err) {
  any_resp(resp, r5.bundle_decoder())
}

pub fn canonicalresource_create_req(
  resource: r5.Canonicalresource,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.canonicalresource_to_json(resource),
    "CanonicalResource",
    client,
  )
}

pub fn canonicalresource_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "CanonicalResource", client)
}

pub fn canonicalresource_update_req(
  resource: r5.Canonicalresource,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.canonicalresource_to_json(resource),
    "CanonicalResource",
    client,
  )
}

pub fn canonicalresource_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "CanonicalResource", client)
}

pub fn canonicalresource_resp(
  resp: Response(String),
) -> Result(r5.Canonicalresource, Err) {
  any_resp(resp, r5.canonicalresource_decoder())
}

pub fn capabilitystatement_create_req(
  resource: r5.Capabilitystatement,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.capabilitystatement_to_json(resource),
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
  resource: r5.Capabilitystatement,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.capabilitystatement_to_json(resource),
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
) -> Result(r5.Capabilitystatement, Err) {
  any_resp(resp, r5.capabilitystatement_decoder())
}

pub fn careplan_create_req(
  resource: r5.Careplan,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.careplan_to_json(resource), "CarePlan", client)
}

pub fn careplan_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "CarePlan", client)
}

pub fn careplan_update_req(
  resource: r5.Careplan,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.careplan_to_json(resource), "CarePlan", client)
}

pub fn careplan_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "CarePlan", client)
}

pub fn careplan_resp(resp: Response(String)) -> Result(r5.Careplan, Err) {
  any_resp(resp, r5.careplan_decoder())
}

pub fn careteam_create_req(
  resource: r5.Careteam,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.careteam_to_json(resource), "CareTeam", client)
}

pub fn careteam_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "CareTeam", client)
}

pub fn careteam_update_req(
  resource: r5.Careteam,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.careteam_to_json(resource), "CareTeam", client)
}

pub fn careteam_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "CareTeam", client)
}

pub fn careteam_resp(resp: Response(String)) -> Result(r5.Careteam, Err) {
  any_resp(resp, r5.careteam_decoder())
}

pub fn chargeitem_create_req(
  resource: r5.Chargeitem,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.chargeitem_to_json(resource), "ChargeItem", client)
}

pub fn chargeitem_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "ChargeItem", client)
}

pub fn chargeitem_update_req(
  resource: r5.Chargeitem,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.chargeitem_to_json(resource),
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

pub fn chargeitem_resp(resp: Response(String)) -> Result(r5.Chargeitem, Err) {
  any_resp(resp, r5.chargeitem_decoder())
}

pub fn chargeitemdefinition_create_req(
  resource: r5.Chargeitemdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.chargeitemdefinition_to_json(resource),
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
  resource: r5.Chargeitemdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.chargeitemdefinition_to_json(resource),
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
) -> Result(r5.Chargeitemdefinition, Err) {
  any_resp(resp, r5.chargeitemdefinition_decoder())
}

pub fn citation_create_req(
  resource: r5.Citation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.citation_to_json(resource), "Citation", client)
}

pub fn citation_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Citation", client)
}

pub fn citation_update_req(
  resource: r5.Citation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.citation_to_json(resource), "Citation", client)
}

pub fn citation_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Citation", client)
}

pub fn citation_resp(resp: Response(String)) -> Result(r5.Citation, Err) {
  any_resp(resp, r5.citation_decoder())
}

pub fn claim_create_req(
  resource: r5.Claim,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.claim_to_json(resource), "Claim", client)
}

pub fn claim_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Claim", client)
}

pub fn claim_update_req(
  resource: r5.Claim,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.claim_to_json(resource), "Claim", client)
}

pub fn claim_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Claim", client)
}

pub fn claim_resp(resp: Response(String)) -> Result(r5.Claim, Err) {
  any_resp(resp, r5.claim_decoder())
}

pub fn claimresponse_create_req(
  resource: r5.Claimresponse,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.claimresponse_to_json(resource), "ClaimResponse", client)
}

pub fn claimresponse_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "ClaimResponse", client)
}

pub fn claimresponse_update_req(
  resource: r5.Claimresponse,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.claimresponse_to_json(resource),
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
) -> Result(r5.Claimresponse, Err) {
  any_resp(resp, r5.claimresponse_decoder())
}

pub fn clinicalimpression_create_req(
  resource: r5.Clinicalimpression,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.clinicalimpression_to_json(resource),
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
  resource: r5.Clinicalimpression,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.clinicalimpression_to_json(resource),
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
) -> Result(r5.Clinicalimpression, Err) {
  any_resp(resp, r5.clinicalimpression_decoder())
}

pub fn clinicalusedefinition_create_req(
  resource: r5.Clinicalusedefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.clinicalusedefinition_to_json(resource),
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
  resource: r5.Clinicalusedefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.clinicalusedefinition_to_json(resource),
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
) -> Result(r5.Clinicalusedefinition, Err) {
  any_resp(resp, r5.clinicalusedefinition_decoder())
}

pub fn codesystem_create_req(
  resource: r5.Codesystem,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.codesystem_to_json(resource), "CodeSystem", client)
}

pub fn codesystem_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "CodeSystem", client)
}

pub fn codesystem_update_req(
  resource: r5.Codesystem,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.codesystem_to_json(resource),
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

pub fn codesystem_resp(resp: Response(String)) -> Result(r5.Codesystem, Err) {
  any_resp(resp, r5.codesystem_decoder())
}

pub fn communication_create_req(
  resource: r5.Communication,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.communication_to_json(resource), "Communication", client)
}

pub fn communication_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Communication", client)
}

pub fn communication_update_req(
  resource: r5.Communication,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.communication_to_json(resource),
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
) -> Result(r5.Communication, Err) {
  any_resp(resp, r5.communication_decoder())
}

pub fn communicationrequest_create_req(
  resource: r5.Communicationrequest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.communicationrequest_to_json(resource),
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
  resource: r5.Communicationrequest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.communicationrequest_to_json(resource),
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
) -> Result(r5.Communicationrequest, Err) {
  any_resp(resp, r5.communicationrequest_decoder())
}

pub fn compartmentdefinition_create_req(
  resource: r5.Compartmentdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.compartmentdefinition_to_json(resource),
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
  resource: r5.Compartmentdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.compartmentdefinition_to_json(resource),
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
) -> Result(r5.Compartmentdefinition, Err) {
  any_resp(resp, r5.compartmentdefinition_decoder())
}

pub fn composition_create_req(
  resource: r5.Composition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.composition_to_json(resource), "Composition", client)
}

pub fn composition_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Composition", client)
}

pub fn composition_update_req(
  resource: r5.Composition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.composition_to_json(resource),
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

pub fn composition_resp(resp: Response(String)) -> Result(r5.Composition, Err) {
  any_resp(resp, r5.composition_decoder())
}

pub fn conceptmap_create_req(
  resource: r5.Conceptmap,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.conceptmap_to_json(resource), "ConceptMap", client)
}

pub fn conceptmap_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "ConceptMap", client)
}

pub fn conceptmap_update_req(
  resource: r5.Conceptmap,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.conceptmap_to_json(resource),
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

pub fn conceptmap_resp(resp: Response(String)) -> Result(r5.Conceptmap, Err) {
  any_resp(resp, r5.conceptmap_decoder())
}

pub fn condition_create_req(
  resource: r5.Condition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.condition_to_json(resource), "Condition", client)
}

pub fn condition_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Condition", client)
}

pub fn condition_update_req(
  resource: r5.Condition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.condition_to_json(resource),
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

pub fn condition_resp(resp: Response(String)) -> Result(r5.Condition, Err) {
  any_resp(resp, r5.condition_decoder())
}

pub fn conditiondefinition_create_req(
  resource: r5.Conditiondefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.conditiondefinition_to_json(resource),
    "ConditionDefinition",
    client,
  )
}

pub fn conditiondefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "ConditionDefinition", client)
}

pub fn conditiondefinition_update_req(
  resource: r5.Conditiondefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.conditiondefinition_to_json(resource),
    "ConditionDefinition",
    client,
  )
}

pub fn conditiondefinition_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "ConditionDefinition", client)
}

pub fn conditiondefinition_resp(
  resp: Response(String),
) -> Result(r5.Conditiondefinition, Err) {
  any_resp(resp, r5.conditiondefinition_decoder())
}

pub fn consent_create_req(
  resource: r5.Consent,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.consent_to_json(resource), "Consent", client)
}

pub fn consent_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Consent", client)
}

pub fn consent_update_req(
  resource: r5.Consent,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.consent_to_json(resource), "Consent", client)
}

pub fn consent_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Consent", client)
}

pub fn consent_resp(resp: Response(String)) -> Result(r5.Consent, Err) {
  any_resp(resp, r5.consent_decoder())
}

pub fn contract_create_req(
  resource: r5.Contract,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.contract_to_json(resource), "Contract", client)
}

pub fn contract_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Contract", client)
}

pub fn contract_update_req(
  resource: r5.Contract,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.contract_to_json(resource), "Contract", client)
}

pub fn contract_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Contract", client)
}

pub fn contract_resp(resp: Response(String)) -> Result(r5.Contract, Err) {
  any_resp(resp, r5.contract_decoder())
}

pub fn coverage_create_req(
  resource: r5.Coverage,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.coverage_to_json(resource), "Coverage", client)
}

pub fn coverage_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Coverage", client)
}

pub fn coverage_update_req(
  resource: r5.Coverage,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.coverage_to_json(resource), "Coverage", client)
}

pub fn coverage_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Coverage", client)
}

pub fn coverage_resp(resp: Response(String)) -> Result(r5.Coverage, Err) {
  any_resp(resp, r5.coverage_decoder())
}

pub fn coverageeligibilityrequest_create_req(
  resource: r5.Coverageeligibilityrequest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.coverageeligibilityrequest_to_json(resource),
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
  resource: r5.Coverageeligibilityrequest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.coverageeligibilityrequest_to_json(resource),
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
) -> Result(r5.Coverageeligibilityrequest, Err) {
  any_resp(resp, r5.coverageeligibilityrequest_decoder())
}

pub fn coverageeligibilityresponse_create_req(
  resource: r5.Coverageeligibilityresponse,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.coverageeligibilityresponse_to_json(resource),
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
  resource: r5.Coverageeligibilityresponse,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.coverageeligibilityresponse_to_json(resource),
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
) -> Result(r5.Coverageeligibilityresponse, Err) {
  any_resp(resp, r5.coverageeligibilityresponse_decoder())
}

pub fn detectedissue_create_req(
  resource: r5.Detectedissue,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.detectedissue_to_json(resource), "DetectedIssue", client)
}

pub fn detectedissue_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "DetectedIssue", client)
}

pub fn detectedissue_update_req(
  resource: r5.Detectedissue,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.detectedissue_to_json(resource),
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
) -> Result(r5.Detectedissue, Err) {
  any_resp(resp, r5.detectedissue_decoder())
}

pub fn device_create_req(
  resource: r5.Device,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.device_to_json(resource), "Device", client)
}

pub fn device_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Device", client)
}

pub fn device_update_req(
  resource: r5.Device,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.device_to_json(resource), "Device", client)
}

pub fn device_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Device", client)
}

pub fn device_resp(resp: Response(String)) -> Result(r5.Device, Err) {
  any_resp(resp, r5.device_decoder())
}

pub fn deviceassociation_create_req(
  resource: r5.Deviceassociation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.deviceassociation_to_json(resource),
    "DeviceAssociation",
    client,
  )
}

pub fn deviceassociation_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "DeviceAssociation", client)
}

pub fn deviceassociation_update_req(
  resource: r5.Deviceassociation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.deviceassociation_to_json(resource),
    "DeviceAssociation",
    client,
  )
}

pub fn deviceassociation_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "DeviceAssociation", client)
}

pub fn deviceassociation_resp(
  resp: Response(String),
) -> Result(r5.Deviceassociation, Err) {
  any_resp(resp, r5.deviceassociation_decoder())
}

pub fn devicedefinition_create_req(
  resource: r5.Devicedefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.devicedefinition_to_json(resource),
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
  resource: r5.Devicedefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.devicedefinition_to_json(resource),
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
) -> Result(r5.Devicedefinition, Err) {
  any_resp(resp, r5.devicedefinition_decoder())
}

pub fn devicedispense_create_req(
  resource: r5.Devicedispense,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.devicedispense_to_json(resource), "DeviceDispense", client)
}

pub fn devicedispense_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "DeviceDispense", client)
}

pub fn devicedispense_update_req(
  resource: r5.Devicedispense,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.devicedispense_to_json(resource),
    "DeviceDispense",
    client,
  )
}

pub fn devicedispense_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "DeviceDispense", client)
}

pub fn devicedispense_resp(
  resp: Response(String),
) -> Result(r5.Devicedispense, Err) {
  any_resp(resp, r5.devicedispense_decoder())
}

pub fn devicemetric_create_req(
  resource: r5.Devicemetric,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.devicemetric_to_json(resource), "DeviceMetric", client)
}

pub fn devicemetric_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "DeviceMetric", client)
}

pub fn devicemetric_update_req(
  resource: r5.Devicemetric,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.devicemetric_to_json(resource),
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

pub fn devicemetric_resp(resp: Response(String)) -> Result(r5.Devicemetric, Err) {
  any_resp(resp, r5.devicemetric_decoder())
}

pub fn devicerequest_create_req(
  resource: r5.Devicerequest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.devicerequest_to_json(resource), "DeviceRequest", client)
}

pub fn devicerequest_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "DeviceRequest", client)
}

pub fn devicerequest_update_req(
  resource: r5.Devicerequest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.devicerequest_to_json(resource),
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
) -> Result(r5.Devicerequest, Err) {
  any_resp(resp, r5.devicerequest_decoder())
}

pub fn deviceusage_create_req(
  resource: r5.Deviceusage,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.deviceusage_to_json(resource), "DeviceUsage", client)
}

pub fn deviceusage_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "DeviceUsage", client)
}

pub fn deviceusage_update_req(
  resource: r5.Deviceusage,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.deviceusage_to_json(resource),
    "DeviceUsage",
    client,
  )
}

pub fn deviceusage_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "DeviceUsage", client)
}

pub fn deviceusage_resp(resp: Response(String)) -> Result(r5.Deviceusage, Err) {
  any_resp(resp, r5.deviceusage_decoder())
}

pub fn diagnosticreport_create_req(
  resource: r5.Diagnosticreport,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.diagnosticreport_to_json(resource),
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
  resource: r5.Diagnosticreport,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.diagnosticreport_to_json(resource),
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
) -> Result(r5.Diagnosticreport, Err) {
  any_resp(resp, r5.diagnosticreport_decoder())
}

pub fn documentreference_create_req(
  resource: r5.Documentreference,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.documentreference_to_json(resource),
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
  resource: r5.Documentreference,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.documentreference_to_json(resource),
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
) -> Result(r5.Documentreference, Err) {
  any_resp(resp, r5.documentreference_decoder())
}

pub fn domainresource_create_req(
  resource: r5.Domainresource,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.domainresource_to_json(resource), "DomainResource", client)
}

pub fn domainresource_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "DomainResource", client)
}

pub fn domainresource_update_req(
  resource: r5.Domainresource,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.domainresource_to_json(resource),
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
) -> Result(r5.Domainresource, Err) {
  any_resp(resp, r5.domainresource_decoder())
}

pub fn encounter_create_req(
  resource: r5.Encounter,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.encounter_to_json(resource), "Encounter", client)
}

pub fn encounter_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Encounter", client)
}

pub fn encounter_update_req(
  resource: r5.Encounter,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.encounter_to_json(resource),
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

pub fn encounter_resp(resp: Response(String)) -> Result(r5.Encounter, Err) {
  any_resp(resp, r5.encounter_decoder())
}

pub fn encounterhistory_create_req(
  resource: r5.Encounterhistory,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.encounterhistory_to_json(resource),
    "EncounterHistory",
    client,
  )
}

pub fn encounterhistory_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "EncounterHistory", client)
}

pub fn encounterhistory_update_req(
  resource: r5.Encounterhistory,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.encounterhistory_to_json(resource),
    "EncounterHistory",
    client,
  )
}

pub fn encounterhistory_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "EncounterHistory", client)
}

pub fn encounterhistory_resp(
  resp: Response(String),
) -> Result(r5.Encounterhistory, Err) {
  any_resp(resp, r5.encounterhistory_decoder())
}

pub fn endpoint_create_req(
  resource: r5.Endpoint,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.endpoint_to_json(resource), "Endpoint", client)
}

pub fn endpoint_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Endpoint", client)
}

pub fn endpoint_update_req(
  resource: r5.Endpoint,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.endpoint_to_json(resource), "Endpoint", client)
}

pub fn endpoint_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Endpoint", client)
}

pub fn endpoint_resp(resp: Response(String)) -> Result(r5.Endpoint, Err) {
  any_resp(resp, r5.endpoint_decoder())
}

pub fn enrollmentrequest_create_req(
  resource: r5.Enrollmentrequest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.enrollmentrequest_to_json(resource),
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
  resource: r5.Enrollmentrequest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.enrollmentrequest_to_json(resource),
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
) -> Result(r5.Enrollmentrequest, Err) {
  any_resp(resp, r5.enrollmentrequest_decoder())
}

pub fn enrollmentresponse_create_req(
  resource: r5.Enrollmentresponse,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.enrollmentresponse_to_json(resource),
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
  resource: r5.Enrollmentresponse,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.enrollmentresponse_to_json(resource),
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
) -> Result(r5.Enrollmentresponse, Err) {
  any_resp(resp, r5.enrollmentresponse_decoder())
}

pub fn episodeofcare_create_req(
  resource: r5.Episodeofcare,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.episodeofcare_to_json(resource), "EpisodeOfCare", client)
}

pub fn episodeofcare_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "EpisodeOfCare", client)
}

pub fn episodeofcare_update_req(
  resource: r5.Episodeofcare,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.episodeofcare_to_json(resource),
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
) -> Result(r5.Episodeofcare, Err) {
  any_resp(resp, r5.episodeofcare_decoder())
}

pub fn eventdefinition_create_req(
  resource: r5.Eventdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.eventdefinition_to_json(resource),
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
  resource: r5.Eventdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.eventdefinition_to_json(resource),
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
) -> Result(r5.Eventdefinition, Err) {
  any_resp(resp, r5.eventdefinition_decoder())
}

pub fn evidence_create_req(
  resource: r5.Evidence,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.evidence_to_json(resource), "Evidence", client)
}

pub fn evidence_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Evidence", client)
}

pub fn evidence_update_req(
  resource: r5.Evidence,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.evidence_to_json(resource), "Evidence", client)
}

pub fn evidence_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Evidence", client)
}

pub fn evidence_resp(resp: Response(String)) -> Result(r5.Evidence, Err) {
  any_resp(resp, r5.evidence_decoder())
}

pub fn evidencereport_create_req(
  resource: r5.Evidencereport,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.evidencereport_to_json(resource), "EvidenceReport", client)
}

pub fn evidencereport_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "EvidenceReport", client)
}

pub fn evidencereport_update_req(
  resource: r5.Evidencereport,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.evidencereport_to_json(resource),
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
) -> Result(r5.Evidencereport, Err) {
  any_resp(resp, r5.evidencereport_decoder())
}

pub fn evidencevariable_create_req(
  resource: r5.Evidencevariable,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.evidencevariable_to_json(resource),
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
  resource: r5.Evidencevariable,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.evidencevariable_to_json(resource),
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
) -> Result(r5.Evidencevariable, Err) {
  any_resp(resp, r5.evidencevariable_decoder())
}

pub fn examplescenario_create_req(
  resource: r5.Examplescenario,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.examplescenario_to_json(resource),
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
  resource: r5.Examplescenario,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.examplescenario_to_json(resource),
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
) -> Result(r5.Examplescenario, Err) {
  any_resp(resp, r5.examplescenario_decoder())
}

pub fn explanationofbenefit_create_req(
  resource: r5.Explanationofbenefit,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.explanationofbenefit_to_json(resource),
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
  resource: r5.Explanationofbenefit,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.explanationofbenefit_to_json(resource),
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
) -> Result(r5.Explanationofbenefit, Err) {
  any_resp(resp, r5.explanationofbenefit_decoder())
}

pub fn familymemberhistory_create_req(
  resource: r5.Familymemberhistory,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.familymemberhistory_to_json(resource),
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
  resource: r5.Familymemberhistory,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.familymemberhistory_to_json(resource),
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
) -> Result(r5.Familymemberhistory, Err) {
  any_resp(resp, r5.familymemberhistory_decoder())
}

pub fn flag_create_req(resource: r5.Flag, client: FhirClient) -> Request(String) {
  any_create_req(r5.flag_to_json(resource), "Flag", client)
}

pub fn flag_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Flag", client)
}

pub fn flag_update_req(
  resource: r5.Flag,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.flag_to_json(resource), "Flag", client)
}

pub fn flag_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Flag", client)
}

pub fn flag_resp(resp: Response(String)) -> Result(r5.Flag, Err) {
  any_resp(resp, r5.flag_decoder())
}

pub fn formularyitem_create_req(
  resource: r5.Formularyitem,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.formularyitem_to_json(resource), "FormularyItem", client)
}

pub fn formularyitem_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "FormularyItem", client)
}

pub fn formularyitem_update_req(
  resource: r5.Formularyitem,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.formularyitem_to_json(resource),
    "FormularyItem",
    client,
  )
}

pub fn formularyitem_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "FormularyItem", client)
}

pub fn formularyitem_resp(
  resp: Response(String),
) -> Result(r5.Formularyitem, Err) {
  any_resp(resp, r5.formularyitem_decoder())
}

pub fn genomicstudy_create_req(
  resource: r5.Genomicstudy,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.genomicstudy_to_json(resource), "GenomicStudy", client)
}

pub fn genomicstudy_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "GenomicStudy", client)
}

pub fn genomicstudy_update_req(
  resource: r5.Genomicstudy,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.genomicstudy_to_json(resource),
    "GenomicStudy",
    client,
  )
}

pub fn genomicstudy_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "GenomicStudy", client)
}

pub fn genomicstudy_resp(resp: Response(String)) -> Result(r5.Genomicstudy, Err) {
  any_resp(resp, r5.genomicstudy_decoder())
}

pub fn goal_create_req(resource: r5.Goal, client: FhirClient) -> Request(String) {
  any_create_req(r5.goal_to_json(resource), "Goal", client)
}

pub fn goal_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Goal", client)
}

pub fn goal_update_req(
  resource: r5.Goal,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.goal_to_json(resource), "Goal", client)
}

pub fn goal_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Goal", client)
}

pub fn goal_resp(resp: Response(String)) -> Result(r5.Goal, Err) {
  any_resp(resp, r5.goal_decoder())
}

pub fn graphdefinition_create_req(
  resource: r5.Graphdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.graphdefinition_to_json(resource),
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
  resource: r5.Graphdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.graphdefinition_to_json(resource),
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
) -> Result(r5.Graphdefinition, Err) {
  any_resp(resp, r5.graphdefinition_decoder())
}

pub fn group_create_req(
  resource: r5.Group,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.group_to_json(resource), "Group", client)
}

pub fn group_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Group", client)
}

pub fn group_update_req(
  resource: r5.Group,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.group_to_json(resource), "Group", client)
}

pub fn group_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Group", client)
}

pub fn group_resp(resp: Response(String)) -> Result(r5.Group, Err) {
  any_resp(resp, r5.group_decoder())
}

pub fn guidanceresponse_create_req(
  resource: r5.Guidanceresponse,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.guidanceresponse_to_json(resource),
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
  resource: r5.Guidanceresponse,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.guidanceresponse_to_json(resource),
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
) -> Result(r5.Guidanceresponse, Err) {
  any_resp(resp, r5.guidanceresponse_decoder())
}

pub fn healthcareservice_create_req(
  resource: r5.Healthcareservice,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.healthcareservice_to_json(resource),
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
  resource: r5.Healthcareservice,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.healthcareservice_to_json(resource),
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
) -> Result(r5.Healthcareservice, Err) {
  any_resp(resp, r5.healthcareservice_decoder())
}

pub fn imagingselection_create_req(
  resource: r5.Imagingselection,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.imagingselection_to_json(resource),
    "ImagingSelection",
    client,
  )
}

pub fn imagingselection_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "ImagingSelection", client)
}

pub fn imagingselection_update_req(
  resource: r5.Imagingselection,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.imagingselection_to_json(resource),
    "ImagingSelection",
    client,
  )
}

pub fn imagingselection_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "ImagingSelection", client)
}

pub fn imagingselection_resp(
  resp: Response(String),
) -> Result(r5.Imagingselection, Err) {
  any_resp(resp, r5.imagingselection_decoder())
}

pub fn imagingstudy_create_req(
  resource: r5.Imagingstudy,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.imagingstudy_to_json(resource), "ImagingStudy", client)
}

pub fn imagingstudy_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "ImagingStudy", client)
}

pub fn imagingstudy_update_req(
  resource: r5.Imagingstudy,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.imagingstudy_to_json(resource),
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

pub fn imagingstudy_resp(resp: Response(String)) -> Result(r5.Imagingstudy, Err) {
  any_resp(resp, r5.imagingstudy_decoder())
}

pub fn immunization_create_req(
  resource: r5.Immunization,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.immunization_to_json(resource), "Immunization", client)
}

pub fn immunization_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Immunization", client)
}

pub fn immunization_update_req(
  resource: r5.Immunization,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.immunization_to_json(resource),
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

pub fn immunization_resp(resp: Response(String)) -> Result(r5.Immunization, Err) {
  any_resp(resp, r5.immunization_decoder())
}

pub fn immunizationevaluation_create_req(
  resource: r5.Immunizationevaluation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.immunizationevaluation_to_json(resource),
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
  resource: r5.Immunizationevaluation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.immunizationevaluation_to_json(resource),
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
) -> Result(r5.Immunizationevaluation, Err) {
  any_resp(resp, r5.immunizationevaluation_decoder())
}

pub fn immunizationrecommendation_create_req(
  resource: r5.Immunizationrecommendation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.immunizationrecommendation_to_json(resource),
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
  resource: r5.Immunizationrecommendation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.immunizationrecommendation_to_json(resource),
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
) -> Result(r5.Immunizationrecommendation, Err) {
  any_resp(resp, r5.immunizationrecommendation_decoder())
}

pub fn implementationguide_create_req(
  resource: r5.Implementationguide,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.implementationguide_to_json(resource),
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
  resource: r5.Implementationguide,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.implementationguide_to_json(resource),
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
) -> Result(r5.Implementationguide, Err) {
  any_resp(resp, r5.implementationguide_decoder())
}

pub fn ingredient_create_req(
  resource: r5.Ingredient,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.ingredient_to_json(resource), "Ingredient", client)
}

pub fn ingredient_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Ingredient", client)
}

pub fn ingredient_update_req(
  resource: r5.Ingredient,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.ingredient_to_json(resource),
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

pub fn ingredient_resp(resp: Response(String)) -> Result(r5.Ingredient, Err) {
  any_resp(resp, r5.ingredient_decoder())
}

pub fn insuranceplan_create_req(
  resource: r5.Insuranceplan,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.insuranceplan_to_json(resource), "InsurancePlan", client)
}

pub fn insuranceplan_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "InsurancePlan", client)
}

pub fn insuranceplan_update_req(
  resource: r5.Insuranceplan,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.insuranceplan_to_json(resource),
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
) -> Result(r5.Insuranceplan, Err) {
  any_resp(resp, r5.insuranceplan_decoder())
}

pub fn inventoryitem_create_req(
  resource: r5.Inventoryitem,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.inventoryitem_to_json(resource), "InventoryItem", client)
}

pub fn inventoryitem_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "InventoryItem", client)
}

pub fn inventoryitem_update_req(
  resource: r5.Inventoryitem,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.inventoryitem_to_json(resource),
    "InventoryItem",
    client,
  )
}

pub fn inventoryitem_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "InventoryItem", client)
}

pub fn inventoryitem_resp(
  resp: Response(String),
) -> Result(r5.Inventoryitem, Err) {
  any_resp(resp, r5.inventoryitem_decoder())
}

pub fn inventoryreport_create_req(
  resource: r5.Inventoryreport,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.inventoryreport_to_json(resource),
    "InventoryReport",
    client,
  )
}

pub fn inventoryreport_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "InventoryReport", client)
}

pub fn inventoryreport_update_req(
  resource: r5.Inventoryreport,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.inventoryreport_to_json(resource),
    "InventoryReport",
    client,
  )
}

pub fn inventoryreport_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "InventoryReport", client)
}

pub fn inventoryreport_resp(
  resp: Response(String),
) -> Result(r5.Inventoryreport, Err) {
  any_resp(resp, r5.inventoryreport_decoder())
}

pub fn invoice_create_req(
  resource: r5.Invoice,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.invoice_to_json(resource), "Invoice", client)
}

pub fn invoice_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Invoice", client)
}

pub fn invoice_update_req(
  resource: r5.Invoice,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.invoice_to_json(resource), "Invoice", client)
}

pub fn invoice_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Invoice", client)
}

pub fn invoice_resp(resp: Response(String)) -> Result(r5.Invoice, Err) {
  any_resp(resp, r5.invoice_decoder())
}

pub fn library_create_req(
  resource: r5.Library,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.library_to_json(resource), "Library", client)
}

pub fn library_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Library", client)
}

pub fn library_update_req(
  resource: r5.Library,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.library_to_json(resource), "Library", client)
}

pub fn library_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Library", client)
}

pub fn library_resp(resp: Response(String)) -> Result(r5.Library, Err) {
  any_resp(resp, r5.library_decoder())
}

pub fn linkage_create_req(
  resource: r5.Linkage,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.linkage_to_json(resource), "Linkage", client)
}

pub fn linkage_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Linkage", client)
}

pub fn linkage_update_req(
  resource: r5.Linkage,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.linkage_to_json(resource), "Linkage", client)
}

pub fn linkage_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Linkage", client)
}

pub fn linkage_resp(resp: Response(String)) -> Result(r5.Linkage, Err) {
  any_resp(resp, r5.linkage_decoder())
}

pub fn listfhir_create_req(
  resource: r5.Listfhir,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.listfhir_to_json(resource), "List", client)
}

pub fn listfhir_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "List", client)
}

pub fn listfhir_update_req(
  resource: r5.Listfhir,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.listfhir_to_json(resource), "List", client)
}

pub fn listfhir_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "List", client)
}

pub fn listfhir_resp(resp: Response(String)) -> Result(r5.Listfhir, Err) {
  any_resp(resp, r5.listfhir_decoder())
}

pub fn location_create_req(
  resource: r5.Location,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.location_to_json(resource), "Location", client)
}

pub fn location_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Location", client)
}

pub fn location_update_req(
  resource: r5.Location,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.location_to_json(resource), "Location", client)
}

pub fn location_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Location", client)
}

pub fn location_resp(resp: Response(String)) -> Result(r5.Location, Err) {
  any_resp(resp, r5.location_decoder())
}

pub fn manufactureditemdefinition_create_req(
  resource: r5.Manufactureditemdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.manufactureditemdefinition_to_json(resource),
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
  resource: r5.Manufactureditemdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.manufactureditemdefinition_to_json(resource),
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
) -> Result(r5.Manufactureditemdefinition, Err) {
  any_resp(resp, r5.manufactureditemdefinition_decoder())
}

pub fn measure_create_req(
  resource: r5.Measure,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.measure_to_json(resource), "Measure", client)
}

pub fn measure_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Measure", client)
}

pub fn measure_update_req(
  resource: r5.Measure,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.measure_to_json(resource), "Measure", client)
}

pub fn measure_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Measure", client)
}

pub fn measure_resp(resp: Response(String)) -> Result(r5.Measure, Err) {
  any_resp(resp, r5.measure_decoder())
}

pub fn measurereport_create_req(
  resource: r5.Measurereport,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.measurereport_to_json(resource), "MeasureReport", client)
}

pub fn measurereport_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "MeasureReport", client)
}

pub fn measurereport_update_req(
  resource: r5.Measurereport,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.measurereport_to_json(resource),
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
) -> Result(r5.Measurereport, Err) {
  any_resp(resp, r5.measurereport_decoder())
}

pub fn medication_create_req(
  resource: r5.Medication,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.medication_to_json(resource), "Medication", client)
}

pub fn medication_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Medication", client)
}

pub fn medication_update_req(
  resource: r5.Medication,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.medication_to_json(resource),
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

pub fn medication_resp(resp: Response(String)) -> Result(r5.Medication, Err) {
  any_resp(resp, r5.medication_decoder())
}

pub fn medicationadministration_create_req(
  resource: r5.Medicationadministration,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.medicationadministration_to_json(resource),
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
  resource: r5.Medicationadministration,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.medicationadministration_to_json(resource),
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
) -> Result(r5.Medicationadministration, Err) {
  any_resp(resp, r5.medicationadministration_decoder())
}

pub fn medicationdispense_create_req(
  resource: r5.Medicationdispense,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.medicationdispense_to_json(resource),
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
  resource: r5.Medicationdispense,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.medicationdispense_to_json(resource),
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
) -> Result(r5.Medicationdispense, Err) {
  any_resp(resp, r5.medicationdispense_decoder())
}

pub fn medicationknowledge_create_req(
  resource: r5.Medicationknowledge,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.medicationknowledge_to_json(resource),
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
  resource: r5.Medicationknowledge,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.medicationknowledge_to_json(resource),
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
) -> Result(r5.Medicationknowledge, Err) {
  any_resp(resp, r5.medicationknowledge_decoder())
}

pub fn medicationrequest_create_req(
  resource: r5.Medicationrequest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.medicationrequest_to_json(resource),
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
  resource: r5.Medicationrequest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.medicationrequest_to_json(resource),
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
) -> Result(r5.Medicationrequest, Err) {
  any_resp(resp, r5.medicationrequest_decoder())
}

pub fn medicationstatement_create_req(
  resource: r5.Medicationstatement,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.medicationstatement_to_json(resource),
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
  resource: r5.Medicationstatement,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.medicationstatement_to_json(resource),
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
) -> Result(r5.Medicationstatement, Err) {
  any_resp(resp, r5.medicationstatement_decoder())
}

pub fn medicinalproductdefinition_create_req(
  resource: r5.Medicinalproductdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.medicinalproductdefinition_to_json(resource),
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
  resource: r5.Medicinalproductdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.medicinalproductdefinition_to_json(resource),
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
) -> Result(r5.Medicinalproductdefinition, Err) {
  any_resp(resp, r5.medicinalproductdefinition_decoder())
}

pub fn messagedefinition_create_req(
  resource: r5.Messagedefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.messagedefinition_to_json(resource),
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
  resource: r5.Messagedefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.messagedefinition_to_json(resource),
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
) -> Result(r5.Messagedefinition, Err) {
  any_resp(resp, r5.messagedefinition_decoder())
}

pub fn messageheader_create_req(
  resource: r5.Messageheader,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.messageheader_to_json(resource), "MessageHeader", client)
}

pub fn messageheader_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "MessageHeader", client)
}

pub fn messageheader_update_req(
  resource: r5.Messageheader,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.messageheader_to_json(resource),
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
) -> Result(r5.Messageheader, Err) {
  any_resp(resp, r5.messageheader_decoder())
}

pub fn metadataresource_create_req(
  resource: r5.Metadataresource,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.metadataresource_to_json(resource),
    "MetadataResource",
    client,
  )
}

pub fn metadataresource_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "MetadataResource", client)
}

pub fn metadataresource_update_req(
  resource: r5.Metadataresource,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.metadataresource_to_json(resource),
    "MetadataResource",
    client,
  )
}

pub fn metadataresource_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "MetadataResource", client)
}

pub fn metadataresource_resp(
  resp: Response(String),
) -> Result(r5.Metadataresource, Err) {
  any_resp(resp, r5.metadataresource_decoder())
}

pub fn molecularsequence_create_req(
  resource: r5.Molecularsequence,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.molecularsequence_to_json(resource),
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
  resource: r5.Molecularsequence,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.molecularsequence_to_json(resource),
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
) -> Result(r5.Molecularsequence, Err) {
  any_resp(resp, r5.molecularsequence_decoder())
}

pub fn namingsystem_create_req(
  resource: r5.Namingsystem,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.namingsystem_to_json(resource), "NamingSystem", client)
}

pub fn namingsystem_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "NamingSystem", client)
}

pub fn namingsystem_update_req(
  resource: r5.Namingsystem,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.namingsystem_to_json(resource),
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

pub fn namingsystem_resp(resp: Response(String)) -> Result(r5.Namingsystem, Err) {
  any_resp(resp, r5.namingsystem_decoder())
}

pub fn nutritionintake_create_req(
  resource: r5.Nutritionintake,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.nutritionintake_to_json(resource),
    "NutritionIntake",
    client,
  )
}

pub fn nutritionintake_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "NutritionIntake", client)
}

pub fn nutritionintake_update_req(
  resource: r5.Nutritionintake,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.nutritionintake_to_json(resource),
    "NutritionIntake",
    client,
  )
}

pub fn nutritionintake_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "NutritionIntake", client)
}

pub fn nutritionintake_resp(
  resp: Response(String),
) -> Result(r5.Nutritionintake, Err) {
  any_resp(resp, r5.nutritionintake_decoder())
}

pub fn nutritionorder_create_req(
  resource: r5.Nutritionorder,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.nutritionorder_to_json(resource), "NutritionOrder", client)
}

pub fn nutritionorder_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "NutritionOrder", client)
}

pub fn nutritionorder_update_req(
  resource: r5.Nutritionorder,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.nutritionorder_to_json(resource),
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
) -> Result(r5.Nutritionorder, Err) {
  any_resp(resp, r5.nutritionorder_decoder())
}

pub fn nutritionproduct_create_req(
  resource: r5.Nutritionproduct,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.nutritionproduct_to_json(resource),
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
  resource: r5.Nutritionproduct,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.nutritionproduct_to_json(resource),
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
) -> Result(r5.Nutritionproduct, Err) {
  any_resp(resp, r5.nutritionproduct_decoder())
}

pub fn observation_create_req(
  resource: r5.Observation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.observation_to_json(resource), "Observation", client)
}

pub fn observation_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Observation", client)
}

pub fn observation_update_req(
  resource: r5.Observation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.observation_to_json(resource),
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

pub fn observation_resp(resp: Response(String)) -> Result(r5.Observation, Err) {
  any_resp(resp, r5.observation_decoder())
}

pub fn observationdefinition_create_req(
  resource: r5.Observationdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.observationdefinition_to_json(resource),
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
  resource: r5.Observationdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.observationdefinition_to_json(resource),
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
) -> Result(r5.Observationdefinition, Err) {
  any_resp(resp, r5.observationdefinition_decoder())
}

pub fn operationdefinition_create_req(
  resource: r5.Operationdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.operationdefinition_to_json(resource),
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
  resource: r5.Operationdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.operationdefinition_to_json(resource),
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
) -> Result(r5.Operationdefinition, Err) {
  any_resp(resp, r5.operationdefinition_decoder())
}

pub fn operationoutcome_create_req(
  resource: r5.Operationoutcome,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.operationoutcome_to_json(resource),
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
  resource: r5.Operationoutcome,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.operationoutcome_to_json(resource),
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
) -> Result(r5.Operationoutcome, Err) {
  any_resp(resp, r5.operationoutcome_decoder())
}

pub fn organization_create_req(
  resource: r5.Organization,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.organization_to_json(resource), "Organization", client)
}

pub fn organization_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Organization", client)
}

pub fn organization_update_req(
  resource: r5.Organization,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.organization_to_json(resource),
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

pub fn organization_resp(resp: Response(String)) -> Result(r5.Organization, Err) {
  any_resp(resp, r5.organization_decoder())
}

pub fn organizationaffiliation_create_req(
  resource: r5.Organizationaffiliation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.organizationaffiliation_to_json(resource),
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
  resource: r5.Organizationaffiliation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.organizationaffiliation_to_json(resource),
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
) -> Result(r5.Organizationaffiliation, Err) {
  any_resp(resp, r5.organizationaffiliation_decoder())
}

pub fn packagedproductdefinition_create_req(
  resource: r5.Packagedproductdefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.packagedproductdefinition_to_json(resource),
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
  resource: r5.Packagedproductdefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.packagedproductdefinition_to_json(resource),
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
) -> Result(r5.Packagedproductdefinition, Err) {
  any_resp(resp, r5.packagedproductdefinition_decoder())
}

pub fn parameters_create_req(
  resource: r5.Parameters,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.parameters_to_json(resource), "Parameters", client)
}

pub fn parameters_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Parameters", client)
}

pub fn parameters_update_req(
  resource: r5.Parameters,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.parameters_to_json(resource),
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

pub fn parameters_resp(resp: Response(String)) -> Result(r5.Parameters, Err) {
  any_resp(resp, r5.parameters_decoder())
}

pub fn patient_create_req(
  resource: r5.Patient,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.patient_to_json(resource), "Patient", client)
}

pub fn patient_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Patient", client)
}

pub fn patient_update_req(
  resource: r5.Patient,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.patient_to_json(resource), "Patient", client)
}

pub fn patient_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Patient", client)
}

pub fn patient_resp(resp: Response(String)) -> Result(r5.Patient, Err) {
  any_resp(resp, r5.patient_decoder())
}

pub fn paymentnotice_create_req(
  resource: r5.Paymentnotice,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.paymentnotice_to_json(resource), "PaymentNotice", client)
}

pub fn paymentnotice_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "PaymentNotice", client)
}

pub fn paymentnotice_update_req(
  resource: r5.Paymentnotice,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.paymentnotice_to_json(resource),
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
) -> Result(r5.Paymentnotice, Err) {
  any_resp(resp, r5.paymentnotice_decoder())
}

pub fn paymentreconciliation_create_req(
  resource: r5.Paymentreconciliation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.paymentreconciliation_to_json(resource),
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
  resource: r5.Paymentreconciliation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.paymentreconciliation_to_json(resource),
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
) -> Result(r5.Paymentreconciliation, Err) {
  any_resp(resp, r5.paymentreconciliation_decoder())
}

pub fn permission_create_req(
  resource: r5.Permission,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.permission_to_json(resource), "Permission", client)
}

pub fn permission_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Permission", client)
}

pub fn permission_update_req(
  resource: r5.Permission,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.permission_to_json(resource),
    "Permission",
    client,
  )
}

pub fn permission_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Permission", client)
}

pub fn permission_resp(resp: Response(String)) -> Result(r5.Permission, Err) {
  any_resp(resp, r5.permission_decoder())
}

pub fn person_create_req(
  resource: r5.Person,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.person_to_json(resource), "Person", client)
}

pub fn person_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Person", client)
}

pub fn person_update_req(
  resource: r5.Person,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.person_to_json(resource), "Person", client)
}

pub fn person_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Person", client)
}

pub fn person_resp(resp: Response(String)) -> Result(r5.Person, Err) {
  any_resp(resp, r5.person_decoder())
}

pub fn plandefinition_create_req(
  resource: r5.Plandefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.plandefinition_to_json(resource), "PlanDefinition", client)
}

pub fn plandefinition_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "PlanDefinition", client)
}

pub fn plandefinition_update_req(
  resource: r5.Plandefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.plandefinition_to_json(resource),
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
) -> Result(r5.Plandefinition, Err) {
  any_resp(resp, r5.plandefinition_decoder())
}

pub fn practitioner_create_req(
  resource: r5.Practitioner,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.practitioner_to_json(resource), "Practitioner", client)
}

pub fn practitioner_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Practitioner", client)
}

pub fn practitioner_update_req(
  resource: r5.Practitioner,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.practitioner_to_json(resource),
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

pub fn practitioner_resp(resp: Response(String)) -> Result(r5.Practitioner, Err) {
  any_resp(resp, r5.practitioner_decoder())
}

pub fn practitionerrole_create_req(
  resource: r5.Practitionerrole,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.practitionerrole_to_json(resource),
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
  resource: r5.Practitionerrole,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.practitionerrole_to_json(resource),
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
) -> Result(r5.Practitionerrole, Err) {
  any_resp(resp, r5.practitionerrole_decoder())
}

pub fn procedure_create_req(
  resource: r5.Procedure,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.procedure_to_json(resource), "Procedure", client)
}

pub fn procedure_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Procedure", client)
}

pub fn procedure_update_req(
  resource: r5.Procedure,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.procedure_to_json(resource),
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

pub fn procedure_resp(resp: Response(String)) -> Result(r5.Procedure, Err) {
  any_resp(resp, r5.procedure_decoder())
}

pub fn provenance_create_req(
  resource: r5.Provenance,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.provenance_to_json(resource), "Provenance", client)
}

pub fn provenance_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Provenance", client)
}

pub fn provenance_update_req(
  resource: r5.Provenance,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.provenance_to_json(resource),
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

pub fn provenance_resp(resp: Response(String)) -> Result(r5.Provenance, Err) {
  any_resp(resp, r5.provenance_decoder())
}

pub fn questionnaire_create_req(
  resource: r5.Questionnaire,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.questionnaire_to_json(resource), "Questionnaire", client)
}

pub fn questionnaire_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Questionnaire", client)
}

pub fn questionnaire_update_req(
  resource: r5.Questionnaire,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.questionnaire_to_json(resource),
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
) -> Result(r5.Questionnaire, Err) {
  any_resp(resp, r5.questionnaire_decoder())
}

pub fn questionnaireresponse_create_req(
  resource: r5.Questionnaireresponse,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.questionnaireresponse_to_json(resource),
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
  resource: r5.Questionnaireresponse,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.questionnaireresponse_to_json(resource),
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
) -> Result(r5.Questionnaireresponse, Err) {
  any_resp(resp, r5.questionnaireresponse_decoder())
}

pub fn regulatedauthorization_create_req(
  resource: r5.Regulatedauthorization,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.regulatedauthorization_to_json(resource),
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
  resource: r5.Regulatedauthorization,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.regulatedauthorization_to_json(resource),
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
) -> Result(r5.Regulatedauthorization, Err) {
  any_resp(resp, r5.regulatedauthorization_decoder())
}

pub fn relatedperson_create_req(
  resource: r5.Relatedperson,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.relatedperson_to_json(resource), "RelatedPerson", client)
}

pub fn relatedperson_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "RelatedPerson", client)
}

pub fn relatedperson_update_req(
  resource: r5.Relatedperson,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.relatedperson_to_json(resource),
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
) -> Result(r5.Relatedperson, Err) {
  any_resp(resp, r5.relatedperson_decoder())
}

pub fn requestorchestration_create_req(
  resource: r5.Requestorchestration,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.requestorchestration_to_json(resource),
    "RequestOrchestration",
    client,
  )
}

pub fn requestorchestration_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "RequestOrchestration", client)
}

pub fn requestorchestration_update_req(
  resource: r5.Requestorchestration,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.requestorchestration_to_json(resource),
    "RequestOrchestration",
    client,
  )
}

pub fn requestorchestration_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "RequestOrchestration", client)
}

pub fn requestorchestration_resp(
  resp: Response(String),
) -> Result(r5.Requestorchestration, Err) {
  any_resp(resp, r5.requestorchestration_decoder())
}

pub fn requirements_create_req(
  resource: r5.Requirements,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.requirements_to_json(resource), "Requirements", client)
}

pub fn requirements_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Requirements", client)
}

pub fn requirements_update_req(
  resource: r5.Requirements,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.requirements_to_json(resource),
    "Requirements",
    client,
  )
}

pub fn requirements_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Requirements", client)
}

pub fn requirements_resp(resp: Response(String)) -> Result(r5.Requirements, Err) {
  any_resp(resp, r5.requirements_decoder())
}

pub fn researchstudy_create_req(
  resource: r5.Researchstudy,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.researchstudy_to_json(resource), "ResearchStudy", client)
}

pub fn researchstudy_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "ResearchStudy", client)
}

pub fn researchstudy_update_req(
  resource: r5.Researchstudy,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.researchstudy_to_json(resource),
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
) -> Result(r5.Researchstudy, Err) {
  any_resp(resp, r5.researchstudy_decoder())
}

pub fn researchsubject_create_req(
  resource: r5.Researchsubject,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.researchsubject_to_json(resource),
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
  resource: r5.Researchsubject,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.researchsubject_to_json(resource),
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
) -> Result(r5.Researchsubject, Err) {
  any_resp(resp, r5.researchsubject_decoder())
}

pub fn riskassessment_create_req(
  resource: r5.Riskassessment,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.riskassessment_to_json(resource), "RiskAssessment", client)
}

pub fn riskassessment_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "RiskAssessment", client)
}

pub fn riskassessment_update_req(
  resource: r5.Riskassessment,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.riskassessment_to_json(resource),
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
) -> Result(r5.Riskassessment, Err) {
  any_resp(resp, r5.riskassessment_decoder())
}

pub fn schedule_create_req(
  resource: r5.Schedule,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.schedule_to_json(resource), "Schedule", client)
}

pub fn schedule_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Schedule", client)
}

pub fn schedule_update_req(
  resource: r5.Schedule,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.schedule_to_json(resource), "Schedule", client)
}

pub fn schedule_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Schedule", client)
}

pub fn schedule_resp(resp: Response(String)) -> Result(r5.Schedule, Err) {
  any_resp(resp, r5.schedule_decoder())
}

pub fn searchparameter_create_req(
  resource: r5.Searchparameter,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.searchparameter_to_json(resource),
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
  resource: r5.Searchparameter,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.searchparameter_to_json(resource),
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
) -> Result(r5.Searchparameter, Err) {
  any_resp(resp, r5.searchparameter_decoder())
}

pub fn servicerequest_create_req(
  resource: r5.Servicerequest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.servicerequest_to_json(resource), "ServiceRequest", client)
}

pub fn servicerequest_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "ServiceRequest", client)
}

pub fn servicerequest_update_req(
  resource: r5.Servicerequest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.servicerequest_to_json(resource),
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
) -> Result(r5.Servicerequest, Err) {
  any_resp(resp, r5.servicerequest_decoder())
}

pub fn slot_create_req(resource: r5.Slot, client: FhirClient) -> Request(String) {
  any_create_req(r5.slot_to_json(resource), "Slot", client)
}

pub fn slot_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Slot", client)
}

pub fn slot_update_req(
  resource: r5.Slot,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.slot_to_json(resource), "Slot", client)
}

pub fn slot_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Slot", client)
}

pub fn slot_resp(resp: Response(String)) -> Result(r5.Slot, Err) {
  any_resp(resp, r5.slot_decoder())
}

pub fn specimen_create_req(
  resource: r5.Specimen,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.specimen_to_json(resource), "Specimen", client)
}

pub fn specimen_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Specimen", client)
}

pub fn specimen_update_req(
  resource: r5.Specimen,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.specimen_to_json(resource), "Specimen", client)
}

pub fn specimen_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Specimen", client)
}

pub fn specimen_resp(resp: Response(String)) -> Result(r5.Specimen, Err) {
  any_resp(resp, r5.specimen_decoder())
}

pub fn specimendefinition_create_req(
  resource: r5.Specimendefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.specimendefinition_to_json(resource),
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
  resource: r5.Specimendefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.specimendefinition_to_json(resource),
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
) -> Result(r5.Specimendefinition, Err) {
  any_resp(resp, r5.specimendefinition_decoder())
}

pub fn structuredefinition_create_req(
  resource: r5.Structuredefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.structuredefinition_to_json(resource),
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
  resource: r5.Structuredefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.structuredefinition_to_json(resource),
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
) -> Result(r5.Structuredefinition, Err) {
  any_resp(resp, r5.structuredefinition_decoder())
}

pub fn structuremap_create_req(
  resource: r5.Structuremap,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.structuremap_to_json(resource), "StructureMap", client)
}

pub fn structuremap_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "StructureMap", client)
}

pub fn structuremap_update_req(
  resource: r5.Structuremap,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.structuremap_to_json(resource),
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

pub fn structuremap_resp(resp: Response(String)) -> Result(r5.Structuremap, Err) {
  any_resp(resp, r5.structuremap_decoder())
}

pub fn subscription_create_req(
  resource: r5.Subscription,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.subscription_to_json(resource), "Subscription", client)
}

pub fn subscription_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Subscription", client)
}

pub fn subscription_update_req(
  resource: r5.Subscription,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.subscription_to_json(resource),
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

pub fn subscription_resp(resp: Response(String)) -> Result(r5.Subscription, Err) {
  any_resp(resp, r5.subscription_decoder())
}

pub fn subscriptionstatus_create_req(
  resource: r5.Subscriptionstatus,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.subscriptionstatus_to_json(resource),
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
  resource: r5.Subscriptionstatus,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.subscriptionstatus_to_json(resource),
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
) -> Result(r5.Subscriptionstatus, Err) {
  any_resp(resp, r5.subscriptionstatus_decoder())
}

pub fn subscriptiontopic_create_req(
  resource: r5.Subscriptiontopic,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.subscriptiontopic_to_json(resource),
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
  resource: r5.Subscriptiontopic,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.subscriptiontopic_to_json(resource),
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
) -> Result(r5.Subscriptiontopic, Err) {
  any_resp(resp, r5.subscriptiontopic_decoder())
}

pub fn substance_create_req(
  resource: r5.Substance,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.substance_to_json(resource), "Substance", client)
}

pub fn substance_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Substance", client)
}

pub fn substance_update_req(
  resource: r5.Substance,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.substance_to_json(resource),
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

pub fn substance_resp(resp: Response(String)) -> Result(r5.Substance, Err) {
  any_resp(resp, r5.substance_decoder())
}

pub fn substancedefinition_create_req(
  resource: r5.Substancedefinition,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.substancedefinition_to_json(resource),
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
  resource: r5.Substancedefinition,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.substancedefinition_to_json(resource),
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
) -> Result(r5.Substancedefinition, Err) {
  any_resp(resp, r5.substancedefinition_decoder())
}

pub fn substancenucleicacid_create_req(
  resource: r5.Substancenucleicacid,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.substancenucleicacid_to_json(resource),
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
  resource: r5.Substancenucleicacid,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.substancenucleicacid_to_json(resource),
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
) -> Result(r5.Substancenucleicacid, Err) {
  any_resp(resp, r5.substancenucleicacid_decoder())
}

pub fn substancepolymer_create_req(
  resource: r5.Substancepolymer,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.substancepolymer_to_json(resource),
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
  resource: r5.Substancepolymer,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.substancepolymer_to_json(resource),
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
) -> Result(r5.Substancepolymer, Err) {
  any_resp(resp, r5.substancepolymer_decoder())
}

pub fn substanceprotein_create_req(
  resource: r5.Substanceprotein,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.substanceprotein_to_json(resource),
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
  resource: r5.Substanceprotein,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.substanceprotein_to_json(resource),
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
) -> Result(r5.Substanceprotein, Err) {
  any_resp(resp, r5.substanceprotein_decoder())
}

pub fn substancereferenceinformation_create_req(
  resource: r5.Substancereferenceinformation,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.substancereferenceinformation_to_json(resource),
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
  resource: r5.Substancereferenceinformation,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.substancereferenceinformation_to_json(resource),
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
) -> Result(r5.Substancereferenceinformation, Err) {
  any_resp(resp, r5.substancereferenceinformation_decoder())
}

pub fn substancesourcematerial_create_req(
  resource: r5.Substancesourcematerial,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.substancesourcematerial_to_json(resource),
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
  resource: r5.Substancesourcematerial,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.substancesourcematerial_to_json(resource),
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
) -> Result(r5.Substancesourcematerial, Err) {
  any_resp(resp, r5.substancesourcematerial_decoder())
}

pub fn supplydelivery_create_req(
  resource: r5.Supplydelivery,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.supplydelivery_to_json(resource), "SupplyDelivery", client)
}

pub fn supplydelivery_read_req(
  id: String,
  client: FhirClient,
) -> Request(String) {
  any_read_req(id, "SupplyDelivery", client)
}

pub fn supplydelivery_update_req(
  resource: r5.Supplydelivery,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.supplydelivery_to_json(resource),
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
) -> Result(r5.Supplydelivery, Err) {
  any_resp(resp, r5.supplydelivery_decoder())
}

pub fn supplyrequest_create_req(
  resource: r5.Supplyrequest,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.supplyrequest_to_json(resource), "SupplyRequest", client)
}

pub fn supplyrequest_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "SupplyRequest", client)
}

pub fn supplyrequest_update_req(
  resource: r5.Supplyrequest,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.supplyrequest_to_json(resource),
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
) -> Result(r5.Supplyrequest, Err) {
  any_resp(resp, r5.supplyrequest_decoder())
}

pub fn task_create_req(resource: r5.Task, client: FhirClient) -> Request(String) {
  any_create_req(r5.task_to_json(resource), "Task", client)
}

pub fn task_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Task", client)
}

pub fn task_update_req(
  resource: r5.Task,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.task_to_json(resource), "Task", client)
}

pub fn task_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Task", client)
}

pub fn task_resp(resp: Response(String)) -> Result(r5.Task, Err) {
  any_resp(resp, r5.task_decoder())
}

pub fn terminologycapabilities_create_req(
  resource: r5.Terminologycapabilities,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.terminologycapabilities_to_json(resource),
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
  resource: r5.Terminologycapabilities,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.terminologycapabilities_to_json(resource),
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
) -> Result(r5.Terminologycapabilities, Err) {
  any_resp(resp, r5.terminologycapabilities_decoder())
}

pub fn testplan_create_req(
  resource: r5.Testplan,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.testplan_to_json(resource), "TestPlan", client)
}

pub fn testplan_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "TestPlan", client)
}

pub fn testplan_update_req(
  resource: r5.Testplan,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.testplan_to_json(resource), "TestPlan", client)
}

pub fn testplan_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "TestPlan", client)
}

pub fn testplan_resp(resp: Response(String)) -> Result(r5.Testplan, Err) {
  any_resp(resp, r5.testplan_decoder())
}

pub fn testreport_create_req(
  resource: r5.Testreport,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.testreport_to_json(resource), "TestReport", client)
}

pub fn testreport_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "TestReport", client)
}

pub fn testreport_update_req(
  resource: r5.Testreport,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.testreport_to_json(resource),
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

pub fn testreport_resp(resp: Response(String)) -> Result(r5.Testreport, Err) {
  any_resp(resp, r5.testreport_decoder())
}

pub fn testscript_create_req(
  resource: r5.Testscript,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.testscript_to_json(resource), "TestScript", client)
}

pub fn testscript_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "TestScript", client)
}

pub fn testscript_update_req(
  resource: r5.Testscript,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.testscript_to_json(resource),
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

pub fn testscript_resp(resp: Response(String)) -> Result(r5.Testscript, Err) {
  any_resp(resp, r5.testscript_decoder())
}

pub fn transport_create_req(
  resource: r5.Transport,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.transport_to_json(resource), "Transport", client)
}

pub fn transport_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "Transport", client)
}

pub fn transport_update_req(
  resource: r5.Transport,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.transport_to_json(resource),
    "Transport",
    client,
  )
}

pub fn transport_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "Transport", client)
}

pub fn transport_resp(resp: Response(String)) -> Result(r5.Transport, Err) {
  any_resp(resp, r5.transport_decoder())
}

pub fn valueset_create_req(
  resource: r5.Valueset,
  client: FhirClient,
) -> Request(String) {
  any_create_req(r5.valueset_to_json(resource), "ValueSet", client)
}

pub fn valueset_read_req(id: String, client: FhirClient) -> Request(String) {
  any_read_req(id, "ValueSet", client)
}

pub fn valueset_update_req(
  resource: r5.Valueset,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(resource.id, r5.valueset_to_json(resource), "ValueSet", client)
}

pub fn valueset_delete_req(
  id: Option(String),
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_delete_req(id, "ValueSet", client)
}

pub fn valueset_resp(resp: Response(String)) -> Result(r5.Valueset, Err) {
  any_resp(resp, r5.valueset_decoder())
}

pub fn verificationresult_create_req(
  resource: r5.Verificationresult,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.verificationresult_to_json(resource),
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
  resource: r5.Verificationresult,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.verificationresult_to_json(resource),
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
) -> Result(r5.Verificationresult, Err) {
  any_resp(resp, r5.verificationresult_decoder())
}

pub fn visionprescription_create_req(
  resource: r5.Visionprescription,
  client: FhirClient,
) -> Request(String) {
  any_create_req(
    r5.visionprescription_to_json(resource),
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
  resource: r5.Visionprescription,
  client: FhirClient,
) -> Result(Request(String), Err) {
  any_update_req(
    resource.id,
    r5.visionprescription_to_json(resource),
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
) -> Result(r5.Visionprescription, Err) {
  any_resp(resp, r5.visionprescription_decoder())
}

pub type SearchParams {
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
  SpArtifactassessment(date: Option(String), identifier: Option(String))
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
  SpBasic(
    identifier: Option(String),
    code: Option(String),
    author: Option(String),
    created: Option(String),
    patient: Option(String),
    subject: Option(String),
  )
  SpBinary
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
  SpBiologicallyderivedproductdispense(
    identifier: Option(String),
    product: Option(String),
    performer: Option(String),
    patient: Option(String),
    status: Option(String),
  )
  SpBodystructure(
    identifier: Option(String),
    included_structure: Option(String),
    excluded_structure: Option(String),
    morphology: Option(String),
    patient: Option(String),
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
    subject: Option(String),
    patient: Option(String),
    implicated: Option(String),
    category: Option(String),
    status: Option(String),
  )
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
  SpDeviceassociation(
    identifier: Option(String),
    subject: Option(String),
    patient: Option(String),
    device: Option(String),
    operator: Option(String),
    status: Option(String),
  )
  SpDevicedefinition(
    identifier: Option(String),
    device_name: Option(String),
    organization: Option(String),
    specification: Option(String),
    type_: Option(String),
    specification_version: Option(String),
    manufacturer: Option(String),
  )
  SpDevicedispense(
    identifier: Option(String),
    code: Option(String),
    subject: Option(String),
    patient: Option(String),
    status: Option(String),
  )
  SpDevicemetric(
    identifier: Option(String),
    category: Option(String),
    type_: Option(String),
    device: Option(String),
  )
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
  SpDeviceusage(
    identifier: Option(String),
    patient: Option(String),
    device: Option(String),
    status: Option(String),
  )
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
  SpEncounterhistory(
    identifier: Option(String),
    patient: Option(String),
    subject: Option(String),
    encounter: Option(String),
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
    category: Option(String),
    status: Option(String),
  )
  SpFormularyitem(identifier: Option(String), code: Option(String))
  SpGenomicstudy(
    identifier: Option(String),
    patient: Option(String),
    subject: Option(String),
    focus: Option(String),
    status: Option(String),
  )
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
  SpGuidanceresponse(
    identifier: Option(String),
    request: Option(String),
    patient: Option(String),
    subject: Option(String),
    status: Option(String),
  )
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
  SpInventoryitem(
    identifier: Option(String),
    code: Option(String),
    subject: Option(String),
    status: Option(String),
  )
  SpInventoryreport(
    item_reference: Option(String),
    identifier: Option(String),
    item: Option(String),
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
  SpManufactureditemdefinition(
    identifier: Option(String),
    ingredient: Option(String),
    name: Option(String),
    dose_form: Option(String),
    status: Option(String),
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
    location: Option(String),
    evaluated_resource: Option(String),
    status: Option(String),
  )
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
  SpMolecularsequence(
    identifier: Option(String),
    subject: Option(String),
    patient: Option(String),
    focus: Option(String),
    type_: Option(String),
  )
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
  SpNutritionproduct(
    identifier: Option(String),
    code: Option(String),
    lot_number: Option(String),
    serial_number: Option(String),
    status: Option(String),
  )
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
    created: Option(String),
    response: Option(String),
    reporter: Option(String),
    payment_status: Option(String),
    status: Option(String),
  )
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
  SpPermission(status: Option(String))
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
  SpResearchsubject(
    date: Option(String),
    identifier: Option(String),
    subject_state: Option(String),
    study: Option(String),
    subject: Option(String),
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
    name: Option(String),
    active: Option(String),
    service_type_reference: Option(String),
  )
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
  SpSubscriptionstatus
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
  SpSubstancedefinition(
    identifier: Option(String),
    code: Option(String),
    domain: Option(String),
    name: Option(String),
    classification: Option(String),
  )
  SpSubstancenucleicacid
  SpSubstancepolymer
  SpSubstanceprotein
  SpSubstancereferenceinformation
  SpSubstancesourcematerial
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
    patient: Option(String),
    subject: Option(String),
    supplier: Option(String),
    category: Option(String),
    status: Option(String),
  )
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
  SpTestplan(
    identifier: Option(String),
    scope: Option(String),
    url: Option(String),
    status: Option(String),
  )
  SpTestreport(
    result: Option(String),
    identifier: Option(String),
    tester: Option(String),
    testscript: Option(String),
    issued: Option(String),
    participant: Option(String),
    status: Option(String),
  )
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
  SpTransport(identifier: Option(String), status: Option(String))
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
    SpAccount(
      owner,
      identifier,
      period,
      patient,
      subject,
      name,
      guarantor,
      type_,
      relatedaccount,
      status,
    ) -> #(
      "Account",
      using_params([
        #("owner", owner),
        #("identifier", identifier),
        #("period", period),
        #("patient", patient),
        #("subject", subject),
        #("name", name),
        #("guarantor", guarantor),
        #("type", type_),
        #("relatedaccount", relatedaccount),
        #("status", status),
      ]),
    )
    SpActivitydefinition(
      date,
      identifier,
      successor,
      context_type_value,
      kind,
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
        #("kind", kind),
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
    SpActordefinition(
      date,
      identifier,
      context_type_value,
      jurisdiction,
      description,
      context_type,
      title,
      type_,
      version,
      url,
      context_quantity,
      context,
      publisher,
      context_type_quantity,
      status,
    ) -> #(
      "ActorDefinition",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("context-type-value", context_type_value),
        #("jurisdiction", jurisdiction),
        #("description", description),
        #("context-type", context_type),
        #("title", title),
        #("type", type_),
        #("version", version),
        #("url", url),
        #("context-quantity", context_quantity),
        #("context", context),
        #("publisher", publisher),
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
      status,
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
        #("status", status),
      ]),
    )
    SpAdverseevent(
      date,
      identifier,
      recorder,
      study,
      code,
      actuality,
      subject,
      substance,
      patient,
      resultingeffect,
      seriousness,
      location,
      category,
      status,
    ) -> #(
      "AdverseEvent",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("recorder", recorder),
        #("study", study),
        #("code", code),
        #("actuality", actuality),
        #("subject", subject),
        #("substance", substance),
        #("patient", patient),
        #("resultingeffect", resultingeffect),
        #("seriousness", seriousness),
        #("location", location),
        #("category", category),
        #("status", status),
      ]),
    )
    SpAllergyintolerance(
      date,
      severity,
      identifier,
      code,
      verification_status,
      criticality,
      manifestation_reference,
      clinical_status,
      type_,
      participant,
      manifestation_code,
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
        #("code", code),
        #("verification-status", verification_status),
        #("criticality", criticality),
        #("manifestation-reference", manifestation_reference),
        #("clinical-status", clinical_status),
        #("type", type_),
        #("participant", participant),
        #("manifestation-code", manifestation_code),
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
      subject,
      service_type,
      slot,
      reason_code,
      actor,
      based_on,
      patient,
      reason_reference,
      supporting_info,
      requested_period,
      location,
      group,
      service_type_reference,
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
        #("subject", subject),
        #("service-type", service_type),
        #("slot", slot),
        #("reason-code", reason_code),
        #("actor", actor),
        #("based-on", based_on),
        #("patient", patient),
        #("reason-reference", reason_reference),
        #("supporting-info", supporting_info),
        #("requested-period", requested_period),
        #("location", location),
        #("group", group),
        #("service-type-reference", service_type_reference),
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
      group,
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
        #("group", group),
      ]),
    )
    SpArtifactassessment(date, identifier) -> #(
      "ArtifactAssessment",
      using_params([
        #("date", date),
        #("identifier", identifier),
      ]),
    )
    SpAuditevent(
      date,
      agent,
      entity_role,
      code,
      purpose,
      encounter,
      source,
      based_on,
      patient,
      action,
      agent_role,
      category,
      entity,
      outcome,
      policy,
    ) -> #(
      "AuditEvent",
      using_params([
        #("date", date),
        #("agent", agent),
        #("entity-role", entity_role),
        #("code", code),
        #("purpose", purpose),
        #("encounter", encounter),
        #("source", source),
        #("based-on", based_on),
        #("patient", patient),
        #("action", action),
        #("agent-role", agent_role),
        #("category", category),
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
    SpBiologicallyderivedproduct(
      identifier,
      request,
      code,
      product_status,
      serial_number,
      biological_source_event,
      product_category,
      collector,
    ) -> #(
      "BiologicallyDerivedProduct",
      using_params([
        #("identifier", identifier),
        #("request", request),
        #("code", code),
        #("product-status", product_status),
        #("serial-number", serial_number),
        #("biological-source-event", biological_source_event),
        #("product-category", product_category),
        #("collector", collector),
      ]),
    )
    SpBiologicallyderivedproductdispense(
      identifier,
      product,
      performer,
      patient,
      status,
    ) -> #(
      "BiologicallyDerivedProductDispense",
      using_params([
        #("identifier", identifier),
        #("product", product),
        #("performer", performer),
        #("patient", patient),
        #("status", status),
      ]),
    )
    SpBodystructure(
      identifier,
      included_structure,
      excluded_structure,
      morphology,
      patient,
    ) -> #(
      "BodyStructure",
      using_params([
        #("identifier", identifier),
        #("included_structure", included_structure),
        #("excluded_structure", excluded_structure),
        #("morphology", morphology),
        #("patient", patient),
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
      identifier,
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
        #("identifier", identifier),
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
      custodian,
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
      instantiates_uri,
      category,
      status,
    ) -> #(
      "CarePlan",
      using_params([
        #("care-team", care_team),
        #("date", date),
        #("identifier", identifier),
        #("goal", goal),
        #("custodian", custodian),
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
        #("instantiates-uri", instantiates_uri),
        #("category", category),
        #("status", status),
      ]),
    )
    SpCareteam(
      date,
      identifier,
      patient,
      subject,
      name,
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
        #("name", name),
        #("category", category),
        #("participant", participant),
        #("status", status),
      ]),
    )
    SpChargeitem(
      identifier,
      performing_organization,
      code,
      quantity,
      subject,
      encounter,
      occurrence,
      entered_date,
      performer_function,
      factor_override,
      patient,
      service,
      price_override,
      enterer,
      performer_actor,
      account,
      requesting_organization,
      status,
    ) -> #(
      "ChargeItem",
      using_params([
        #("identifier", identifier),
        #("performing-organization", performing_organization),
        #("code", code),
        #("quantity", quantity),
        #("subject", subject),
        #("encounter", encounter),
        #("occurrence", occurrence),
        #("entered-date", entered_date),
        #("performer-function", performer_function),
        #("factor-override", factor_override),
        #("patient", patient),
        #("service", service),
        #("price-override", price_override),
        #("enterer", enterer),
        #("performer-actor", performer_actor),
        #("account", account),
        #("requesting-organization", requesting_organization),
        #("status", status),
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
      classification_type,
      context_type,
      title,
      classification,
      version,
      url,
      context_quantity,
      effective,
      context,
      name,
      classifier,
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
        #("classification-type", classification_type),
        #("context-type", context_type),
        #("title", title),
        #("classification", classification),
        #("version", version),
        #("url", url),
        #("context-quantity", context_quantity),
        #("effective", effective),
        #("context", context),
        #("name", name),
        #("classifier", classifier),
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
      performer,
      problem,
      previous,
      finding_code,
      patient,
      subject,
      supporting_info,
      encounter,
      finding_ref,
      status,
    ) -> #(
      "ClinicalImpression",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("performer", performer),
        #("problem", problem),
        #("previous", previous),
        #("finding-code", finding_code),
        #("patient", patient),
        #("subject", subject),
        #("supporting-info", supporting_info),
        #("encounter", encounter),
        #("finding-ref", finding_ref),
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
      status,
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
        #("status", status),
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
      derived_from,
      context_type,
      language,
      predecessor,
      title,
      version,
      url,
      context_quantity,
      supplements,
      effective,
      system,
      context,
      name,
      publisher,
      topic,
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
        #("derived-from", derived_from),
        #("context-type", context_type),
        #("language", language),
        #("predecessor", predecessor),
        #("title", title),
        #("version", version),
        #("url", url),
        #("context-quantity", context_quantity),
        #("supplements", supplements),
        #("effective", effective),
        #("system", system),
        #("context", context),
        #("name", name),
        #("publisher", publisher),
        #("topic", topic),
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
      topic,
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
        #("topic", topic),
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
      patient,
      recipient,
      information_provider,
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
        #("patient", patient),
        #("recipient", recipient),
        #("information-provider", information_provider),
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
      event_code,
      author,
      subject,
      section,
      encounter,
      title,
      type_,
      version,
      attester,
      url,
      event_reference,
      section_text,
      entry,
      related,
      patient,
      category,
      section_code_text,
      status,
    ) -> #(
      "Composition",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("period", period),
        #("event-code", event_code),
        #("author", author),
        #("subject", subject),
        #("section", section),
        #("encounter", encounter),
        #("title", title),
        #("type", type_),
        #("version", version),
        #("attester", attester),
        #("url", url),
        #("event-reference", event_reference),
        #("section-text", section_text),
        #("entry", entry),
        #("related", related),
        #("patient", patient),
        #("category", category),
        #("section-code-text", section_code_text),
        #("status", status),
      ]),
    )
    SpConceptmap(
      date,
      target_scope,
      context_type_value,
      jurisdiction,
      description,
      target_group_system,
      derived_from,
      context_type,
      predecessor,
      title,
      context_quantity,
      effective,
      source_scope,
      context,
      context_type_quantity,
      target_code,
      identifier,
      source_scope_uri,
      source_group_system,
      mapping_property,
      other_map,
      version,
      url,
      source_code,
      target_scope_uri,
      name,
      publisher,
      topic,
      status,
    ) -> #(
      "ConceptMap",
      using_params([
        #("date", date),
        #("target-scope", target_scope),
        #("context-type-value", context_type_value),
        #("jurisdiction", jurisdiction),
        #("description", description),
        #("target-group-system", target_group_system),
        #("derived-from", derived_from),
        #("context-type", context_type),
        #("predecessor", predecessor),
        #("title", title),
        #("context-quantity", context_quantity),
        #("effective", effective),
        #("source-scope", source_scope),
        #("context", context),
        #("context-type-quantity", context_type_quantity),
        #("target-code", target_code),
        #("identifier", identifier),
        #("source-scope-uri", source_scope_uri),
        #("source-group-system", source_group_system),
        #("mapping-property", mapping_property),
        #("other-map", other_map),
        #("version", version),
        #("url", url),
        #("source-code", source_code),
        #("target-scope-uri", target_scope_uri),
        #("name", name),
        #("publisher", publisher),
        #("topic", topic),
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
      participant_function,
      subject,
      participant_actor,
      verification_status,
      clinical_status,
      encounter,
      onset_date,
      abatement_date,
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
        #("participant-function", participant_function),
        #("subject", subject),
        #("participant-actor", participant_actor),
        #("verification-status", verification_status),
        #("clinical-status", clinical_status),
        #("encounter", encounter),
        #("onset-date", onset_date),
        #("abatement-date", abatement_date),
        #("stage", stage),
        #("abatement-string", abatement_string),
        #("patient", patient),
        #("abatement-age", abatement_age),
        #("onset-age", onset_age),
        #("body-site", body_site),
        #("category", category),
      ]),
    )
    SpConditiondefinition(
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
      "ConditionDefinition",
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
    SpConsent(
      date,
      identifier,
      controller,
      period,
      data,
      manager,
      purpose,
      subject,
      verified_date,
      grantee,
      source_reference,
      verified,
      actor,
      security_label,
      patient,
      action,
      category,
      status,
    ) -> #(
      "Consent",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("controller", controller),
        #("period", period),
        #("data", data),
        #("manager", manager),
        #("purpose", purpose),
        #("subject", subject),
        #("verified-date", verified_date),
        #("grantee", grantee),
        #("source-reference", source_reference),
        #("verified", verified),
        #("actor", actor),
        #("security-label", security_label),
        #("patient", patient),
        #("action", action),
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
      subscriber,
      subscriberid,
      type_,
      beneficiary,
      patient,
      insurer,
      class_value,
      paymentby_party,
      class_type,
      dependent,
      policy_holder,
      status,
    ) -> #(
      "Coverage",
      using_params([
        #("identifier", identifier),
        #("subscriber", subscriber),
        #("subscriberid", subscriberid),
        #("type", type_),
        #("beneficiary", beneficiary),
        #("patient", patient),
        #("insurer", insurer),
        #("class-value", class_value),
        #("paymentby-party", paymentby_party),
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
    SpDetectedissue(
      identifier,
      code,
      identified,
      author,
      subject,
      patient,
      implicated,
      category,
      status,
    ) -> #(
      "DetectedIssue",
      using_params([
        #("identifier", identifier),
        #("code", code),
        #("identified", identified),
        #("author", author),
        #("subject", subject),
        #("patient", patient),
        #("implicated", implicated),
        #("category", category),
        #("status", status),
      ]),
    )
    SpDevice(
      udi_di,
      identifier,
      parent,
      manufacture_date,
      udi_carrier,
      code,
      device_name,
      lot_number,
      serial_number,
      specification,
      type_,
      version,
      url,
      manufacturer,
      code_value_concept,
      organization,
      biological_source_event,
      definition,
      location,
      model,
      expiration_date,
      specification_version,
      status,
    ) -> #(
      "Device",
      using_params([
        #("udi-di", udi_di),
        #("identifier", identifier),
        #("parent", parent),
        #("manufacture-date", manufacture_date),
        #("udi-carrier", udi_carrier),
        #("code", code),
        #("device-name", device_name),
        #("lot-number", lot_number),
        #("serial-number", serial_number),
        #("specification", specification),
        #("type", type_),
        #("version", version),
        #("url", url),
        #("manufacturer", manufacturer),
        #("code-value-concept", code_value_concept),
        #("organization", organization),
        #("biological-source-event", biological_source_event),
        #("definition", definition),
        #("location", location),
        #("model", model),
        #("expiration-date", expiration_date),
        #("specification-version", specification_version),
        #("status", status),
      ]),
    )
    SpDeviceassociation(identifier, subject, patient, device, operator, status) -> #(
      "DeviceAssociation",
      using_params([
        #("identifier", identifier),
        #("subject", subject),
        #("patient", patient),
        #("device", device),
        #("operator", operator),
        #("status", status),
      ]),
    )
    SpDevicedefinition(
      identifier,
      device_name,
      organization,
      specification,
      type_,
      specification_version,
      manufacturer,
    ) -> #(
      "DeviceDefinition",
      using_params([
        #("identifier", identifier),
        #("device-name", device_name),
        #("organization", organization),
        #("specification", specification),
        #("type", type_),
        #("specification-version", specification_version),
        #("manufacturer", manufacturer),
      ]),
    )
    SpDevicedispense(identifier, code, subject, patient, status) -> #(
      "DeviceDispense",
      using_params([
        #("identifier", identifier),
        #("code", code),
        #("subject", subject),
        #("patient", patient),
        #("status", status),
      ]),
    )
    SpDevicemetric(identifier, category, type_, device) -> #(
      "DeviceMetric",
      using_params([
        #("identifier", identifier),
        #("category", category),
        #("type", type_),
        #("device", device),
      ]),
    )
    SpDevicerequest(
      insurance,
      performer_code,
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
        #("performer-code", performer_code),
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
    SpDeviceusage(identifier, patient, device, status) -> #(
      "DeviceUsage",
      using_params([
        #("identifier", identifier),
        #("patient", patient),
        #("device", device),
        #("status", status),
      ]),
    )
    SpDiagnosticreport(
      date,
      identifier,
      study,
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
        #("study", study),
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
    SpDocumentreference(
      date,
      modality,
      subject,
      description,
      language,
      type_,
      relation,
      setting,
      doc_status,
      based_on,
      format_canonical,
      patient,
      context,
      relationship,
      creation,
      identifier,
      period,
      event_code,
      bodysite,
      custodian,
      author,
      format_code,
      bodysite_reference,
      format_uri,
      version,
      attester,
      contenttype,
      event_reference,
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
        #("modality", modality),
        #("subject", subject),
        #("description", description),
        #("language", language),
        #("type", type_),
        #("relation", relation),
        #("setting", setting),
        #("doc-status", doc_status),
        #("based-on", based_on),
        #("format-canonical", format_canonical),
        #("patient", patient),
        #("context", context),
        #("relationship", relationship),
        #("creation", creation),
        #("identifier", identifier),
        #("period", period),
        #("event-code", event_code),
        #("bodysite", bodysite),
        #("custodian", custodian),
        #("author", author),
        #("format-code", format_code),
        #("bodysite-reference", bodysite_reference),
        #("format-uri", format_uri),
        #("version", version),
        #("attester", attester),
        #("contenttype", contenttype),
        #("event-reference", event_reference),
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
      participant_type,
      subject,
      subject_status,
      appointment,
      part_of,
      type_,
      participant,
      reason_code,
      based_on,
      date_start,
      patient,
      location_period,
      special_arrangement,
      class,
      identifier,
      diagnosis_code,
      practitioner,
      episode_of_care,
      length,
      careteam,
      end_date,
      diagnosis_reference,
      reason_reference,
      location,
      service_provider,
      account,
      status,
    ) -> #(
      "Encounter",
      using_params([
        #("date", date),
        #("participant-type", participant_type),
        #("subject", subject),
        #("subject-status", subject_status),
        #("appointment", appointment),
        #("part-of", part_of),
        #("type", type_),
        #("participant", participant),
        #("reason-code", reason_code),
        #("based-on", based_on),
        #("date-start", date_start),
        #("patient", patient),
        #("location-period", location_period),
        #("special-arrangement", special_arrangement),
        #("class", class),
        #("identifier", identifier),
        #("diagnosis-code", diagnosis_code),
        #("practitioner", practitioner),
        #("episode-of-care", episode_of_care),
        #("length", length),
        #("careteam", careteam),
        #("end-date", end_date),
        #("diagnosis-reference", diagnosis_reference),
        #("reason-reference", reason_reference),
        #("location", location),
        #("service-provider", service_provider),
        #("account", account),
        #("status", status),
      ]),
    )
    SpEncounterhistory(identifier, patient, subject, encounter, status) -> #(
      "EncounterHistory",
      using_params([
        #("identifier", identifier),
        #("patient", patient),
        #("subject", subject),
        #("encounter", encounter),
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
      diagnosis_code,
      diagnosis_reference,
      patient,
      organization,
      reason_reference,
      type_,
      care_manager,
      reason_code,
      incoming_referral,
      status,
    ) -> #(
      "EpisodeOfCare",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("diagnosis-code", diagnosis_code),
        #("diagnosis-reference", diagnosis_reference),
        #("patient", patient),
        #("organization", organization),
        #("reason-reference", reason_reference),
        #("type", type_),
        #("care-manager", care_manager),
        #("reason-code", reason_code),
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
      successor,
      context_type_value,
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
      context,
      name,
      publisher,
      topic,
      context_type_quantity,
      status,
    ) -> #(
      "EvidenceVariable",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("successor", successor),
        #("context-type-value", context_type_value),
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
        #("context", context),
        #("name", name),
        #("publisher", publisher),
        #("topic", topic),
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
    SpFlag(
      date,
      identifier,
      author,
      patient,
      subject,
      encounter,
      category,
      status,
    ) -> #(
      "Flag",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("author", author),
        #("patient", patient),
        #("subject", subject),
        #("encounter", encounter),
        #("category", category),
        #("status", status),
      ]),
    )
    SpFormularyitem(identifier, code) -> #(
      "FormularyItem",
      using_params([
        #("identifier", identifier),
        #("code", code),
      ]),
    )
    SpGenomicstudy(identifier, patient, subject, focus, status) -> #(
      "GenomicStudy",
      using_params([
        #("identifier", identifier),
        #("patient", patient),
        #("subject", subject),
        #("focus", focus),
        #("status", status),
      ]),
    )
    SpGoal(
      target_measure,
      identifier,
      addresses,
      lifecycle_status,
      achievement_status,
      patient,
      subject,
      description,
      start_date,
      category,
      target_date,
    ) -> #(
      "Goal",
      using_params([
        #("target-measure", target_measure),
        #("identifier", identifier),
        #("addresses", addresses),
        #("lifecycle-status", lifecycle_status),
        #("achievement-status", achievement_status),
        #("patient", patient),
        #("subject", subject),
        #("description", description),
        #("start-date", start_date),
        #("category", category),
        #("target-date", target_date),
      ]),
    )
    SpGraphdefinition(
      date,
      identifier,
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
        #("identifier", identifier),
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
      identifier,
      characteristic_value,
      managing_entity,
      code,
      member,
      name,
      exclude,
      membership,
      type_,
      characteristic_reference,
      value,
      characteristic,
    ) -> #(
      "Group",
      using_params([
        #("identifier", identifier),
        #("characteristic-value", characteristic_value),
        #("managing-entity", managing_entity),
        #("code", code),
        #("member", member),
        #("name", name),
        #("exclude", exclude),
        #("membership", membership),
        #("type", type_),
        #("characteristic-reference", characteristic_reference),
        #("value", value),
        #("characteristic", characteristic),
      ]),
    )
    SpGuidanceresponse(identifier, request, patient, subject, status) -> #(
      "GuidanceResponse",
      using_params([
        #("identifier", identifier),
        #("request", request),
        #("patient", patient),
        #("subject", subject),
        #("status", status),
      ]),
    )
    SpHealthcareservice(
      identifier,
      specialty,
      service_category,
      service_type,
      active,
      eligibility,
      program,
      characteristic,
      endpoint,
      coverage_area,
      organization,
      offered_in,
      name,
      location,
      communication,
    ) -> #(
      "HealthcareService",
      using_params([
        #("identifier", identifier),
        #("specialty", specialty),
        #("service-category", service_category),
        #("service-type", service_type),
        #("active", active),
        #("eligibility", eligibility),
        #("program", program),
        #("characteristic", characteristic),
        #("endpoint", endpoint),
        #("coverage-area", coverage_area),
        #("organization", organization),
        #("offered-in", offered_in),
        #("name", name),
        #("location", location),
        #("communication", communication),
      ]),
    )
    SpImagingselection(
      identifier,
      body_structure,
      based_on,
      code,
      subject,
      patient,
      derived_from,
      issued,
      body_site,
      study_uid,
      status,
    ) -> #(
      "ImagingSelection",
      using_params([
        #("identifier", identifier),
        #("body-structure", body_structure),
        #("based-on", based_on),
        #("code", code),
        #("subject", subject),
        #("patient", patient),
        #("derived-from", derived_from),
        #("issued", issued),
        #("body-site", body_site),
        #("study-uid", study_uid),
        #("status", status),
      ]),
    )
    SpImagingstudy(
      identifier,
      reason,
      dicom_class,
      instance,
      modality,
      performer,
      subject,
      started,
      encounter,
      referrer,
      body_structure,
      endpoint,
      based_on,
      patient,
      series,
      body_site,
      status,
    ) -> #(
      "ImagingStudy",
      using_params([
        #("identifier", identifier),
        #("reason", reason),
        #("dicom-class", dicom_class),
        #("instance", instance),
        #("modality", modality),
        #("performer", performer),
        #("subject", subject),
        #("started", started),
        #("encounter", encounter),
        #("referrer", referrer),
        #("body-structure", body_structure),
        #("endpoint", endpoint),
        #("based-on", based_on),
        #("patient", patient),
        #("series", series),
        #("body-site", body_site),
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
      identifier,
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
        #("identifier", identifier),
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
      identifier,
      role,
      substance,
      strength_concentration_ratio,
      for,
      substance_code,
      strength_concentration_quantity,
      manufacturer,
      substance_definition,
      function,
      strength_presentation_ratio,
      strength_presentation_quantity,
      status,
    ) -> #(
      "Ingredient",
      using_params([
        #("identifier", identifier),
        #("role", role),
        #("substance", substance),
        #("strength-concentration-ratio", strength_concentration_ratio),
        #("for", for),
        #("substance-code", substance_code),
        #("strength-concentration-quantity", strength_concentration_quantity),
        #("manufacturer", manufacturer),
        #("substance-definition", substance_definition),
        #("function", function),
        #("strength-presentation-ratio", strength_presentation_ratio),
        #("strength-presentation-quantity", strength_presentation_quantity),
        #("status", status),
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
    SpInventoryitem(identifier, code, subject, status) -> #(
      "InventoryItem",
      using_params([
        #("identifier", identifier),
        #("code", code),
        #("subject", subject),
        #("status", status),
      ]),
    )
    SpInventoryreport(item_reference, identifier, item, status) -> #(
      "InventoryReport",
      using_params([
        #("item-reference", item_reference),
        #("identifier", identifier),
        #("item", item),
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
      characteristic,
      address_country,
      endpoint,
      contains,
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
        #("characteristic", characteristic),
        #("address-country", address_country),
        #("endpoint", endpoint),
        #("contains", contains),
        #("organization", organization),
        #("address-use", address_use),
        #("name", name),
        #("near", near),
        #("address-city", address_city),
        #("status", status),
      ]),
    )
    SpManufactureditemdefinition(
      identifier,
      ingredient,
      name,
      dose_form,
      status,
    ) -> #(
      "ManufacturedItemDefinition",
      using_params([
        #("identifier", identifier),
        #("ingredient", ingredient),
        #("name", name),
        #("dose-form", dose_form),
        #("status", status),
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
      location,
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
        #("location", location),
        #("evaluated-resource", evaluated_resource),
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
      serial_number,
      expiration_date,
      marketingauthorizationholder,
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
        #("serial-number", serial_number),
        #("expiration-date", expiration_date),
        #("marketingauthorizationholder", marketingauthorizationholder),
        #("status", status),
      ]),
    )
    SpMedicationadministration(
      date,
      identifier,
      request,
      code,
      performer,
      performer_device_code,
      subject,
      medication,
      reason_given,
      encounter,
      reason_given_code,
      patient,
      reason_not_given,
      device,
      status,
    ) -> #(
      "MedicationAdministration",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("request", request),
        #("code", code),
        #("performer", performer),
        #("performer-device-code", performer_device_code),
        #("subject", subject),
        #("medication", medication),
        #("reason-given", reason_given),
        #("encounter", encounter),
        #("reason-given-code", reason_given_code),
        #("patient", patient),
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
      encounter,
      type_,
      recorded,
      whenhandedover,
      whenprepared,
      prescription,
      patient,
      location,
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
        #("encounter", encounter),
        #("type", type_),
        #("recorded", recorded),
        #("whenhandedover", whenhandedover),
        #("whenprepared", whenprepared),
        #("prescription", prescription),
        #("patient", patient),
        #("location", location),
        #("status", status),
      ]),
    )
    SpMedicationknowledge(
      product_type,
      identifier,
      code,
      ingredient,
      doseform,
      classification_type,
      monograph_type,
      classification,
      ingredient_code,
      packaging_cost_concept,
      source_cost,
      monitoring_program_name,
      monograph,
      monitoring_program_type,
      packaging_cost,
      status,
    ) -> #(
      "MedicationKnowledge",
      using_params([
        #("product-type", product_type),
        #("identifier", identifier),
        #("code", code),
        #("ingredient", ingredient),
        #("doseform", doseform),
        #("classification-type", classification_type),
        #("monograph-type", monograph_type),
        #("classification", classification),
        #("ingredient-code", ingredient_code),
        #("packaging-cost-concept", packaging_cost_concept),
        #("source-cost", source_cost),
        #("monitoring-program-name", monitoring_program_name),
        #("monograph", monograph),
        #("monitoring-program-type", monitoring_program_type),
        #("packaging-cost", packaging_cost),
        #("status", status),
      ]),
    )
    SpMedicationrequest(
      requester,
      identifier,
      intended_dispenser,
      authoredon,
      code,
      combo_date,
      subject,
      medication,
      encounter,
      priority,
      intent,
      group_identifier,
      intended_performer,
      patient,
      intended_performertype,
      category,
      status,
    ) -> #(
      "MedicationRequest",
      using_params([
        #("requester", requester),
        #("identifier", identifier),
        #("intended-dispenser", intended_dispenser),
        #("authoredon", authoredon),
        #("code", code),
        #("combo-date", combo_date),
        #("subject", subject),
        #("medication", medication),
        #("encounter", encounter),
        #("priority", priority),
        #("intent", intent),
        #("group-identifier", group_identifier),
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
      adherence,
      patient,
      subject,
      medication,
      encounter,
      source,
      category,
      status,
    ) -> #(
      "MedicationStatement",
      using_params([
        #("effective", effective),
        #("identifier", identifier),
        #("code", code),
        #("adherence", adherence),
        #("patient", patient),
        #("subject", subject),
        #("medication", medication),
        #("encounter", encounter),
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
      sender,
      author,
      responsible,
      destination,
      focus,
      response_id,
      source,
      event,
      target,
    ) -> #(
      "MessageHeader",
      using_params([
        #("code", code),
        #("receiver", receiver),
        #("sender", sender),
        #("author", author),
        #("responsible", responsible),
        #("destination", destination),
        #("focus", focus),
        #("response-id", response_id),
        #("source", source),
        #("event", event),
        #("target", target),
      ]),
    )
    SpMolecularsequence(identifier, subject, patient, focus, type_) -> #(
      "MolecularSequence",
      using_params([
        #("identifier", identifier),
        #("subject", subject),
        #("patient", patient),
        #("focus", focus),
        #("type", type_),
      ]),
    )
    SpNamingsystem(
      date,
      context_type_value,
      jurisdiction,
      description,
      derived_from,
      context_type,
      predecessor,
      type_,
      context_quantity,
      effective,
      contact,
      responsible,
      context,
      telecom,
      value,
      context_type_quantity,
      identifier,
      period,
      kind,
      version,
      url,
      id_type,
      name,
      publisher,
      topic,
      status,
    ) -> #(
      "NamingSystem",
      using_params([
        #("date", date),
        #("context-type-value", context_type_value),
        #("jurisdiction", jurisdiction),
        #("description", description),
        #("derived-from", derived_from),
        #("context-type", context_type),
        #("predecessor", predecessor),
        #("type", type_),
        #("context-quantity", context_quantity),
        #("effective", effective),
        #("contact", contact),
        #("responsible", responsible),
        #("context", context),
        #("telecom", telecom),
        #("value", value),
        #("context-type-quantity", context_type_quantity),
        #("identifier", identifier),
        #("period", period),
        #("kind", kind),
        #("version", version),
        #("url", url),
        #("id-type", id_type),
        #("name", name),
        #("publisher", publisher),
        #("topic", topic),
        #("status", status),
      ]),
    )
    SpNutritionintake(
      date,
      identifier,
      nutrition,
      code,
      patient,
      subject,
      encounter,
      source,
      status,
    ) -> #(
      "NutritionIntake",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("nutrition", nutrition),
        #("code", code),
        #("patient", patient),
        #("subject", subject),
        #("encounter", encounter),
        #("source", source),
        #("status", status),
      ]),
    )
    SpNutritionorder(
      identifier,
      group_identifier,
      datetime,
      provider,
      subject,
      patient,
      supplement,
      formula,
      encounter,
      oraldiet,
      additive,
      status,
    ) -> #(
      "NutritionOrder",
      using_params([
        #("identifier", identifier),
        #("group-identifier", group_identifier),
        #("datetime", datetime),
        #("provider", provider),
        #("subject", subject),
        #("patient", patient),
        #("supplement", supplement),
        #("formula", formula),
        #("encounter", encounter),
        #("oraldiet", oraldiet),
        #("additive", additive),
        #("status", status),
      ]),
    )
    SpNutritionproduct(identifier, code, lot_number, serial_number, status) -> #(
      "NutritionProduct",
      using_params([
        #("identifier", identifier),
        #("code", code),
        #("lot-number", lot_number),
        #("serial-number", serial_number),
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
      component_value_canonical,
      has_member,
      value_reference,
      code_value_string,
      component_code_value_quantity,
      based_on,
      code_value_date,
      patient,
      specimen,
      code_value_quantity,
      component_code,
      value_markdown,
      combo_code_value_concept,
      identifier,
      component_value_reference,
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
      value_canonical,
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
        #("component-value-canonical", component_value_canonical),
        #("has-member", has_member),
        #("value-reference", value_reference),
        #("code-value-string", code_value_string),
        #("component-code-value-quantity", component_code_value_quantity),
        #("based-on", based_on),
        #("code-value-date", code_value_date),
        #("patient", patient),
        #("specimen", specimen),
        #("code-value-quantity", code_value_quantity),
        #("component-code", component_code),
        #("value-markdown", value_markdown),
        #("combo-code-value-concept", combo_code_value_concept),
        #("identifier", identifier),
        #("component-value-reference", component_value_reference),
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
        #("value-canonical", value_canonical),
        #("status", status),
      ]),
    )
    SpObservationdefinition(
      identifier,
      code,
      method,
      experimental,
      category,
      title,
      url,
      status,
    ) -> #(
      "ObservationDefinition",
      using_params([
        #("identifier", identifier),
        #("code", code),
        #("method", method),
        #("experimental", experimental),
        #("category", category),
        #("title", title),
        #("url", url),
        #("status", status),
      ]),
    )
    SpOperationdefinition(
      date,
      identifier,
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
        #("identifier", identifier),
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
      created,
      response,
      reporter,
      payment_status,
      status,
    ) -> #(
      "PaymentNotice",
      using_params([
        #("identifier", identifier),
        #("request", request),
        #("created", created),
        #("response", response),
        #("reporter", reporter),
        #("payment-status", payment_status),
        #("status", status),
      ]),
    )
    SpPaymentreconciliation(
      identifier,
      request,
      disposition,
      created,
      allocation_encounter,
      allocation_account,
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
        #("allocation-encounter", allocation_encounter),
        #("allocation-account", allocation_account),
        #("outcome", outcome),
        #("payment-issuer", payment_issuer),
        #("requestor", requestor),
        #("status", status),
      ]),
    )
    SpPermission(status) -> #(
      "Permission",
      using_params([
        #("status", status),
      ]),
    )
    SpPerson(
      identifier,
      given,
      address,
      birthdate,
      deceased,
      address_state,
      gender,
      practitioner,
      link,
      relatedperson,
      address_postalcode,
      address_country,
      death_date,
      phonetic,
      phone,
      patient,
      organization,
      address_use,
      name,
      telecom,
      address_city,
      family,
      email,
    ) -> #(
      "Person",
      using_params([
        #("identifier", identifier),
        #("given", given),
        #("address", address),
        #("birthdate", birthdate),
        #("deceased", deceased),
        #("address-state", address_state),
        #("gender", gender),
        #("practitioner", practitioner),
        #("link", link),
        #("relatedperson", relatedperson),
        #("address-postalcode", address_postalcode),
        #("address-country", address_country),
        #("death-date", death_date),
        #("phonetic", phonetic),
        #("phone", phone),
        #("patient", patient),
        #("organization", organization),
        #("address-use", address_use),
        #("name", name),
        #("telecom", telecom),
        #("address-city", address_city),
        #("family", family),
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
      deceased,
      address_state,
      gender,
      qualification_period,
      active,
      address_postalcode,
      address_country,
      death_date,
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
        #("deceased", deceased),
        #("address-state", address_state),
        #("gender", gender),
        #("qualification-period", qualification_period),
        #("active", active),
        #("address-postalcode", address_postalcode),
        #("address-country", address_country),
        #("death-date", death_date),
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
      characteristic,
      endpoint,
      phone,
      service,
      organization,
      location,
      telecom,
      communication,
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
        #("characteristic", characteristic),
        #("endpoint", endpoint),
        #("phone", phone),
        #("service", service),
        #("organization", organization),
        #("location", location),
        #("telecom", telecom),
        #("communication", communication),
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
      report,
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
        #("report", report),
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
      activity,
      encounter,
      recorded,
      when,
      target,
      based_on,
      patient,
      location,
      agent_role,
      entity,
    ) -> #(
      "Provenance",
      using_params([
        #("agent-type", agent_type),
        #("agent", agent),
        #("signature-type", signature_type),
        #("activity", activity),
        #("encounter", encounter),
        #("recorded", recorded),
        #("when", when),
        #("target", target),
        #("based-on", based_on),
        #("patient", patient),
        #("location", location),
        #("agent-role", agent_role),
        #("entity", entity),
      ]),
    )
    SpQuestionnaire(
      date,
      identifier,
      combo_code,
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
      questionnaire_code,
      definition,
      context_type_quantity,
      item_code,
      status,
    ) -> #(
      "Questionnaire",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("combo-code", combo_code),
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
        #("questionnaire-code", questionnaire_code),
        #("definition", definition),
        #("context-type-quantity", context_type_quantity),
        #("item-code", item_code),
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
      item_subject,
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
        #("item-subject", item_subject),
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
      given,
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
      family,
      relationship,
      email,
    ) -> #(
      "RelatedPerson",
      using_params([
        #("identifier", identifier),
        #("given", given),
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
        #("family", family),
        #("relationship", relationship),
        #("email", email),
      ]),
    )
    SpRequestorchestration(
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
      based_on,
      patient,
      instantiates_uri,
      status,
    ) -> #(
      "RequestOrchestration",
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
        #("based-on", based_on),
        #("patient", patient),
        #("instantiates-uri", instantiates_uri),
        #("status", status),
      ]),
    )
    SpRequirements(
      date,
      identifier,
      context_type_value,
      jurisdiction,
      description,
      derived_from,
      context_type,
      title,
      version,
      url,
      actor,
      context_quantity,
      context,
      name,
      publisher,
      context_type_quantity,
      status,
    ) -> #(
      "Requirements",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("context-type-value", context_type_value),
        #("jurisdiction", jurisdiction),
        #("description", description),
        #("derived-from", derived_from),
        #("context-type", context_type),
        #("title", title),
        #("version", version),
        #("url", url),
        #("actor", actor),
        #("context-quantity", context_quantity),
        #("context", context),
        #("name", name),
        #("publisher", publisher),
        #("context-type-quantity", context_type_quantity),
        #("status", status),
      ]),
    )
    SpResearchstudy(
      date,
      objective_type,
      study_design,
      description,
      eligibility,
      part_of,
      title,
      progress_status_state_period_actual,
      recruitment_target,
      protocol,
      classifier,
      keyword,
      focus_code,
      phase,
      identifier,
      progress_status_state_actual,
      focus_reference,
      objective_description,
      progress_status_state_period,
      condition,
      site,
      name,
      recruitment_actual,
      region,
      status,
    ) -> #(
      "ResearchStudy",
      using_params([
        #("date", date),
        #("objective-type", objective_type),
        #("study-design", study_design),
        #("description", description),
        #("eligibility", eligibility),
        #("part-of", part_of),
        #("title", title),
        #(
          "progress-status-state-period-actual",
          progress_status_state_period_actual,
        ),
        #("recruitment-target", recruitment_target),
        #("protocol", protocol),
        #("classifier", classifier),
        #("keyword", keyword),
        #("focus-code", focus_code),
        #("phase", phase),
        #("identifier", identifier),
        #("progress-status-state-actual", progress_status_state_actual),
        #("focus-reference", focus_reference),
        #("objective-description", objective_description),
        #("progress-status-state-period", progress_status_state_period),
        #("condition", condition),
        #("site", site),
        #("name", name),
        #("recruitment-actual", recruitment_actual),
        #("region", region),
        #("status", status),
      ]),
    )
    SpResearchsubject(
      date,
      identifier,
      subject_state,
      study,
      subject,
      patient,
      status,
    ) -> #(
      "ResearchSubject",
      using_params([
        #("date", date),
        #("identifier", identifier),
        #("subject_state", subject_state),
        #("study", study),
        #("subject", subject),
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
      name,
      active,
      service_type_reference,
    ) -> #(
      "Schedule",
      using_params([
        #("actor", actor),
        #("date", date),
        #("identifier", identifier),
        #("specialty", specialty),
        #("service-category", service_category),
        #("service-type", service_type),
        #("name", name),
        #("active", active),
        #("service-type-reference", service_type_reference),
      ]),
    )
    SpSearchparameter(
      date,
      identifier,
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
        #("identifier", identifier),
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
      body_structure,
      based_on,
      code_reference,
      patient,
      specimen,
      code_concept,
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
        #("body-structure", body_structure),
        #("based-on", based_on),
        #("code-reference", code_reference),
        #("patient", patient),
        #("specimen", specimen),
        #("code-concept", code_concept),
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
      service_type_reference,
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
        #("service-type-reference", service_type_reference),
        #("status", status),
      ]),
    )
    SpSpecimen(
      identifier,
      parent,
      bodysite,
      patient,
      subject,
      collected,
      accession,
      procedure,
      type_,
      collector,
      container_device,
      status,
    ) -> #(
      "Specimen",
      using_params([
        #("identifier", identifier),
        #("parent", parent),
        #("bodysite", bodysite),
        #("patient", patient),
        #("subject", subject),
        #("collected", collected),
        #("accession", accession),
        #("procedure", procedure),
        #("type", type_),
        #("collector", collector),
        #("container-device", container_device),
        #("status", status),
      ]),
    )
    SpSpecimendefinition(
      container,
      identifier,
      is_derived,
      experimental,
      type_tested,
      title,
      type_,
      url,
      status,
    ) -> #(
      "SpecimenDefinition",
      using_params([
        #("container", container),
        #("identifier", identifier),
        #("is-derived", is_derived),
        #("experimental", experimental),
        #("type-tested", type_tested),
        #("title", title),
        #("type", type_),
        #("url", url),
        #("status", status),
      ]),
    )
    SpStructuredefinition(
      date,
      context_type_value,
      ext_context_type,
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
      ext_context_expression,
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
        #("ext-context-type", ext_context_type),
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
        #("ext-context-expression", ext_context_expression),
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
    SpSubscription(
      owner,
      identifier,
      payload,
      contact,
      name,
      topic,
      filter_value,
      type_,
      content_level,
      url,
      status,
    ) -> #(
      "Subscription",
      using_params([
        #("owner", owner),
        #("identifier", identifier),
        #("payload", payload),
        #("contact", contact),
        #("name", name),
        #("topic", topic),
        #("filter-value", filter_value),
        #("type", type_),
        #("content-level", content_level),
        #("url", url),
        #("status", status),
      ]),
    )
    SpSubscriptionstatus -> #("SubscriptionStatus", using_params([]))
    SpSubscriptiontopic(
      date,
      effective,
      identifier,
      resource,
      derived_or_self,
      event,
      title,
      version,
      url,
      status,
      trigger_description,
    ) -> #(
      "SubscriptionTopic",
      using_params([
        #("date", date),
        #("effective", effective),
        #("identifier", identifier),
        #("resource", resource),
        #("derived-or-self", derived_or_self),
        #("event", event),
        #("title", title),
        #("version", version),
        #("url", url),
        #("status", status),
        #("trigger-description", trigger_description),
      ]),
    )
    SpSubstance(
      identifier,
      code,
      code_reference,
      quantity,
      substance_reference,
      expiry,
      category,
      status,
    ) -> #(
      "Substance",
      using_params([
        #("identifier", identifier),
        #("code", code),
        #("code-reference", code_reference),
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
    SpSubstancenucleicacid -> #("SubstanceNucleicAcid", using_params([]))
    SpSubstancepolymer -> #("SubstancePolymer", using_params([]))
    SpSubstanceprotein -> #("SubstanceProtein", using_params([]))
    SpSubstancereferenceinformation -> #(
      "SubstanceReferenceInformation",
      using_params([]),
    )
    SpSubstancesourcematerial -> #("SubstanceSourceMaterial", using_params([]))
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
      patient,
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
        #("patient", patient),
        #("subject", subject),
        #("supplier", supplier),
        #("category", category),
        #("status", status),
      ]),
    )
    SpTask(
      owner,
      requestedperformer_reference,
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
      output,
      actor,
      group_identifier,
      based_on,
      patient,
      modified,
      status,
    ) -> #(
      "Task",
      using_params([
        #("owner", owner),
        #("requestedperformer-reference", requestedperformer_reference),
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
        #("output", output),
        #("actor", actor),
        #("group-identifier", group_identifier),
        #("based-on", based_on),
        #("patient", patient),
        #("modified", modified),
        #("status", status),
      ]),
    )
    SpTerminologycapabilities(
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
      "TerminologyCapabilities",
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
    SpTestplan(identifier, scope, url, status) -> #(
      "TestPlan",
      using_params([
        #("identifier", identifier),
        #("scope", scope),
        #("url", url),
        #("status", status),
      ]),
    )
    SpTestreport(
      result,
      identifier,
      tester,
      testscript,
      issued,
      participant,
      status,
    ) -> #(
      "TestReport",
      using_params([
        #("result", result),
        #("identifier", identifier),
        #("tester", tester),
        #("testscript", testscript),
        #("issued", issued),
        #("participant", participant),
        #("status", status),
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
      scope_artifact_phase,
      title,
      scope_artifact_conformance,
      version,
      scope_artifact,
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
        #("scope-artifact-phase", scope_artifact_phase),
        #("title", title),
        #("scope-artifact-conformance", scope_artifact_conformance),
        #("version", version),
        #("scope-artifact", scope_artifact),
        #("url", url),
        #("context-quantity", context_quantity),
        #("context", context),
        #("name", name),
        #("publisher", publisher),
        #("context-type-quantity", context_type_quantity),
        #("status", status),
      ]),
    )
    SpTransport(identifier, status) -> #(
      "Transport",
      using_params([
        #("identifier", identifier),
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
      derived_from,
      context_type,
      predecessor,
      title,
      version,
      url,
      expansion,
      reference,
      context_quantity,
      effective,
      context,
      name,
      publisher,
      topic,
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
        #("derived-from", derived_from),
        #("context-type", context_type),
        #("predecessor", predecessor),
        #("title", title),
        #("version", version),
        #("url", url),
        #("expansion", expansion),
        #("reference", reference),
        #("context-quantity", context_quantity),
        #("effective", effective),
        #("context", context),
        #("name", name),
        #("publisher", publisher),
        #("topic", topic),
        #("context-type-quantity", context_type_quantity),
        #("status", status),
      ]),
    )
    SpVerificationresult(
      status_date,
      primarysource_who,
      primarysource_date,
      validator_organization,
      attestation_method,
      attestation_onbehalfof,
      target,
      attestation_who,
      primarysource_type,
      status,
    ) -> #(
      "VerificationResult",
      using_params([
        #("status-date", status_date),
        #("primarysource-who", primarysource_who),
        #("primarysource-date", primarysource_date),
        #("validator-organization", validator_organization),
        #("attestation-method", attestation_method),
        #("attestation-onbehalfof", attestation_onbehalfof),
        #("target", target),
        #("attestation-who", attestation_who),
        #("primarysource-type", primarysource_type),
        #("status", status),
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
