import fhir/r5
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
