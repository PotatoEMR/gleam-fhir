////[https://hl7.org/fhir/r5](https://hl7.org/fhir/r5) r5 sans-io request/response helpers suitable for building clients on top of, such as r5_httpc.gleam and r5_rsvp.gleam

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
  //got json but could not parse it, probably a missing required field
  ErrParseJson(json.DecodeError)
  //did not get resource json, often server eg nginx gives basic html response
  ErrNotJson(Response(String))
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
      True -> r5.operationoutcome_decoder() |> decode.map(fn(x) { Error(x) })
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
    account: List(r5.Account),
    activitydefinition: List(r5.Activitydefinition),
    actordefinition: List(r5.Actordefinition),
    administrableproductdefinition: List(r5.Administrableproductdefinition),
    adverseevent: List(r5.Adverseevent),
    allergyintolerance: List(r5.Allergyintolerance),
    appointment: List(r5.Appointment),
    appointmentresponse: List(r5.Appointmentresponse),
    artifactassessment: List(r5.Artifactassessment),
    auditevent: List(r5.Auditevent),
    basic: List(r5.Basic),
    binary: List(r5.Binary),
    biologicallyderivedproduct: List(r5.Biologicallyderivedproduct),
    biologicallyderivedproductdispense: List(
      r5.Biologicallyderivedproductdispense,
    ),
    bodystructure: List(r5.Bodystructure),
    bundle: List(r5.Bundle),
    capabilitystatement: List(r5.Capabilitystatement),
    careplan: List(r5.Careplan),
    careteam: List(r5.Careteam),
    chargeitem: List(r5.Chargeitem),
    chargeitemdefinition: List(r5.Chargeitemdefinition),
    citation: List(r5.Citation),
    claim: List(r5.Claim),
    claimresponse: List(r5.Claimresponse),
    clinicalimpression: List(r5.Clinicalimpression),
    clinicalusedefinition: List(r5.Clinicalusedefinition),
    codesystem: List(r5.Codesystem),
    communication: List(r5.Communication),
    communicationrequest: List(r5.Communicationrequest),
    compartmentdefinition: List(r5.Compartmentdefinition),
    composition: List(r5.Composition),
    conceptmap: List(r5.Conceptmap),
    condition: List(r5.Condition),
    conditiondefinition: List(r5.Conditiondefinition),
    consent: List(r5.Consent),
    contract: List(r5.Contract),
    coverage: List(r5.Coverage),
    coverageeligibilityrequest: List(r5.Coverageeligibilityrequest),
    coverageeligibilityresponse: List(r5.Coverageeligibilityresponse),
    detectedissue: List(r5.Detectedissue),
    device: List(r5.Device),
    deviceassociation: List(r5.Deviceassociation),
    devicedefinition: List(r5.Devicedefinition),
    devicedispense: List(r5.Devicedispense),
    devicemetric: List(r5.Devicemetric),
    devicerequest: List(r5.Devicerequest),
    deviceusage: List(r5.Deviceusage),
    diagnosticreport: List(r5.Diagnosticreport),
    documentreference: List(r5.Documentreference),
    encounter: List(r5.Encounter),
    encounterhistory: List(r5.Encounterhistory),
    endpoint: List(r5.Endpoint),
    enrollmentrequest: List(r5.Enrollmentrequest),
    enrollmentresponse: List(r5.Enrollmentresponse),
    episodeofcare: List(r5.Episodeofcare),
    eventdefinition: List(r5.Eventdefinition),
    evidence: List(r5.Evidence),
    evidencereport: List(r5.Evidencereport),
    evidencevariable: List(r5.Evidencevariable),
    examplescenario: List(r5.Examplescenario),
    explanationofbenefit: List(r5.Explanationofbenefit),
    familymemberhistory: List(r5.Familymemberhistory),
    flag: List(r5.Flag),
    formularyitem: List(r5.Formularyitem),
    genomicstudy: List(r5.Genomicstudy),
    goal: List(r5.Goal),
    graphdefinition: List(r5.Graphdefinition),
    group: List(r5.Group),
    guidanceresponse: List(r5.Guidanceresponse),
    healthcareservice: List(r5.Healthcareservice),
    imagingselection: List(r5.Imagingselection),
    imagingstudy: List(r5.Imagingstudy),
    immunization: List(r5.Immunization),
    immunizationevaluation: List(r5.Immunizationevaluation),
    immunizationrecommendation: List(r5.Immunizationrecommendation),
    implementationguide: List(r5.Implementationguide),
    ingredient: List(r5.Ingredient),
    insuranceplan: List(r5.Insuranceplan),
    inventoryitem: List(r5.Inventoryitem),
    inventoryreport: List(r5.Inventoryreport),
    invoice: List(r5.Invoice),
    library: List(r5.Library),
    linkage: List(r5.Linkage),
    listfhir: List(r5.Listfhir),
    location: List(r5.Location),
    manufactureditemdefinition: List(r5.Manufactureditemdefinition),
    measure: List(r5.Measure),
    measurereport: List(r5.Measurereport),
    medication: List(r5.Medication),
    medicationadministration: List(r5.Medicationadministration),
    medicationdispense: List(r5.Medicationdispense),
    medicationknowledge: List(r5.Medicationknowledge),
    medicationrequest: List(r5.Medicationrequest),
    medicationstatement: List(r5.Medicationstatement),
    medicinalproductdefinition: List(r5.Medicinalproductdefinition),
    messagedefinition: List(r5.Messagedefinition),
    messageheader: List(r5.Messageheader),
    molecularsequence: List(r5.Molecularsequence),
    namingsystem: List(r5.Namingsystem),
    nutritionintake: List(r5.Nutritionintake),
    nutritionorder: List(r5.Nutritionorder),
    nutritionproduct: List(r5.Nutritionproduct),
    observation: List(r5.Observation),
    observationdefinition: List(r5.Observationdefinition),
    operationdefinition: List(r5.Operationdefinition),
    operationoutcome: List(r5.Operationoutcome),
    organization: List(r5.Organization),
    organizationaffiliation: List(r5.Organizationaffiliation),
    packagedproductdefinition: List(r5.Packagedproductdefinition),
    patient: List(r5.Patient),
    paymentnotice: List(r5.Paymentnotice),
    paymentreconciliation: List(r5.Paymentreconciliation),
    permission: List(r5.Permission),
    person: List(r5.Person),
    plandefinition: List(r5.Plandefinition),
    practitioner: List(r5.Practitioner),
    practitionerrole: List(r5.Practitionerrole),
    procedure: List(r5.Procedure),
    provenance: List(r5.Provenance),
    questionnaire: List(r5.Questionnaire),
    questionnaireresponse: List(r5.Questionnaireresponse),
    regulatedauthorization: List(r5.Regulatedauthorization),
    relatedperson: List(r5.Relatedperson),
    requestorchestration: List(r5.Requestorchestration),
    requirements: List(r5.Requirements),
    researchstudy: List(r5.Researchstudy),
    researchsubject: List(r5.Researchsubject),
    riskassessment: List(r5.Riskassessment),
    schedule: List(r5.Schedule),
    searchparameter: List(r5.Searchparameter),
    servicerequest: List(r5.Servicerequest),
    slot: List(r5.Slot),
    specimen: List(r5.Specimen),
    specimendefinition: List(r5.Specimendefinition),
    structuredefinition: List(r5.Structuredefinition),
    structuremap: List(r5.Structuremap),
    subscription: List(r5.Subscription),
    subscriptionstatus: List(r5.Subscriptionstatus),
    subscriptiontopic: List(r5.Subscriptiontopic),
    substance: List(r5.Substance),
    substancedefinition: List(r5.Substancedefinition),
    substancenucleicacid: List(r5.Substancenucleicacid),
    substancepolymer: List(r5.Substancepolymer),
    substanceprotein: List(r5.Substanceprotein),
    substancereferenceinformation: List(r5.Substancereferenceinformation),
    substancesourcematerial: List(r5.Substancesourcematerial),
    supplydelivery: List(r5.Supplydelivery),
    supplyrequest: List(r5.Supplyrequest),
    task: List(r5.Task),
    terminologycapabilities: List(r5.Terminologycapabilities),
    testplan: List(r5.Testplan),
    testreport: List(r5.Testreport),
    testscript: List(r5.Testscript),
    transport: List(r5.Transport),
    valueset: List(r5.Valueset),
    verificationresult: List(r5.Verificationresult),
    visionprescription: List(r5.Visionprescription),
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

pub fn bundle_to_groupedresources(from bundle: r5.Bundle) {
  list.fold(
    from: groupedresources_new(),
    over: bundle.entry,
    with: fn(acc, entry) {
      case entry.resource {
        None -> acc
        Some(res) ->
          case res {
            r5.ResourceAccount(r) ->
              GroupedResources(..acc, account: [r, ..acc.account])
            r5.ResourceActivitydefinition(r) ->
              GroupedResources(..acc, activitydefinition: [
                r,
                ..acc.activitydefinition
              ])
            r5.ResourceActordefinition(r) ->
              GroupedResources(..acc, actordefinition: [
                r,
                ..acc.actordefinition
              ])
            r5.ResourceAdministrableproductdefinition(r) ->
              GroupedResources(..acc, administrableproductdefinition: [
                r,
                ..acc.administrableproductdefinition
              ])
            r5.ResourceAdverseevent(r) ->
              GroupedResources(..acc, adverseevent: [r, ..acc.adverseevent])
            r5.ResourceAllergyintolerance(r) ->
              GroupedResources(..acc, allergyintolerance: [
                r,
                ..acc.allergyintolerance
              ])
            r5.ResourceAppointment(r) ->
              GroupedResources(..acc, appointment: [r, ..acc.appointment])
            r5.ResourceAppointmentresponse(r) ->
              GroupedResources(..acc, appointmentresponse: [
                r,
                ..acc.appointmentresponse
              ])
            r5.ResourceArtifactassessment(r) ->
              GroupedResources(..acc, artifactassessment: [
                r,
                ..acc.artifactassessment
              ])
            r5.ResourceAuditevent(r) ->
              GroupedResources(..acc, auditevent: [r, ..acc.auditevent])
            r5.ResourceBasic(r) ->
              GroupedResources(..acc, basic: [r, ..acc.basic])
            r5.ResourceBinary(r) ->
              GroupedResources(..acc, binary: [r, ..acc.binary])
            r5.ResourceBiologicallyderivedproduct(r) ->
              GroupedResources(..acc, biologicallyderivedproduct: [
                r,
                ..acc.biologicallyderivedproduct
              ])
            r5.ResourceBiologicallyderivedproductdispense(r) ->
              GroupedResources(..acc, biologicallyderivedproductdispense: [
                r,
                ..acc.biologicallyderivedproductdispense
              ])
            r5.ResourceBodystructure(r) ->
              GroupedResources(..acc, bodystructure: [r, ..acc.bodystructure])
            r5.ResourceBundle(r) ->
              GroupedResources(..acc, bundle: [r, ..acc.bundle])
            r5.ResourceCapabilitystatement(r) ->
              GroupedResources(..acc, capabilitystatement: [
                r,
                ..acc.capabilitystatement
              ])
            r5.ResourceCareplan(r) ->
              GroupedResources(..acc, careplan: [r, ..acc.careplan])
            r5.ResourceCareteam(r) ->
              GroupedResources(..acc, careteam: [r, ..acc.careteam])
            r5.ResourceChargeitem(r) ->
              GroupedResources(..acc, chargeitem: [r, ..acc.chargeitem])
            r5.ResourceChargeitemdefinition(r) ->
              GroupedResources(..acc, chargeitemdefinition: [
                r,
                ..acc.chargeitemdefinition
              ])
            r5.ResourceCitation(r) ->
              GroupedResources(..acc, citation: [r, ..acc.citation])
            r5.ResourceClaim(r) ->
              GroupedResources(..acc, claim: [r, ..acc.claim])
            r5.ResourceClaimresponse(r) ->
              GroupedResources(..acc, claimresponse: [r, ..acc.claimresponse])
            r5.ResourceClinicalimpression(r) ->
              GroupedResources(..acc, clinicalimpression: [
                r,
                ..acc.clinicalimpression
              ])
            r5.ResourceClinicalusedefinition(r) ->
              GroupedResources(..acc, clinicalusedefinition: [
                r,
                ..acc.clinicalusedefinition
              ])
            r5.ResourceCodesystem(r) ->
              GroupedResources(..acc, codesystem: [r, ..acc.codesystem])
            r5.ResourceCommunication(r) ->
              GroupedResources(..acc, communication: [r, ..acc.communication])
            r5.ResourceCommunicationrequest(r) ->
              GroupedResources(..acc, communicationrequest: [
                r,
                ..acc.communicationrequest
              ])
            r5.ResourceCompartmentdefinition(r) ->
              GroupedResources(..acc, compartmentdefinition: [
                r,
                ..acc.compartmentdefinition
              ])
            r5.ResourceComposition(r) ->
              GroupedResources(..acc, composition: [r, ..acc.composition])
            r5.ResourceConceptmap(r) ->
              GroupedResources(..acc, conceptmap: [r, ..acc.conceptmap])
            r5.ResourceCondition(r) ->
              GroupedResources(..acc, condition: [r, ..acc.condition])
            r5.ResourceConditiondefinition(r) ->
              GroupedResources(..acc, conditiondefinition: [
                r,
                ..acc.conditiondefinition
              ])
            r5.ResourceConsent(r) ->
              GroupedResources(..acc, consent: [r, ..acc.consent])
            r5.ResourceContract(r) ->
              GroupedResources(..acc, contract: [r, ..acc.contract])
            r5.ResourceCoverage(r) ->
              GroupedResources(..acc, coverage: [r, ..acc.coverage])
            r5.ResourceCoverageeligibilityrequest(r) ->
              GroupedResources(..acc, coverageeligibilityrequest: [
                r,
                ..acc.coverageeligibilityrequest
              ])
            r5.ResourceCoverageeligibilityresponse(r) ->
              GroupedResources(..acc, coverageeligibilityresponse: [
                r,
                ..acc.coverageeligibilityresponse
              ])
            r5.ResourceDetectedissue(r) ->
              GroupedResources(..acc, detectedissue: [r, ..acc.detectedissue])
            r5.ResourceDevice(r) ->
              GroupedResources(..acc, device: [r, ..acc.device])
            r5.ResourceDeviceassociation(r) ->
              GroupedResources(..acc, deviceassociation: [
                r,
                ..acc.deviceassociation
              ])
            r5.ResourceDevicedefinition(r) ->
              GroupedResources(..acc, devicedefinition: [
                r,
                ..acc.devicedefinition
              ])
            r5.ResourceDevicedispense(r) ->
              GroupedResources(..acc, devicedispense: [r, ..acc.devicedispense])
            r5.ResourceDevicemetric(r) ->
              GroupedResources(..acc, devicemetric: [r, ..acc.devicemetric])
            r5.ResourceDevicerequest(r) ->
              GroupedResources(..acc, devicerequest: [r, ..acc.devicerequest])
            r5.ResourceDeviceusage(r) ->
              GroupedResources(..acc, deviceusage: [r, ..acc.deviceusage])
            r5.ResourceDiagnosticreport(r) ->
              GroupedResources(..acc, diagnosticreport: [
                r,
                ..acc.diagnosticreport
              ])
            r5.ResourceDocumentreference(r) ->
              GroupedResources(..acc, documentreference: [
                r,
                ..acc.documentreference
              ])
            r5.ResourceEncounter(r) ->
              GroupedResources(..acc, encounter: [r, ..acc.encounter])
            r5.ResourceEncounterhistory(r) ->
              GroupedResources(..acc, encounterhistory: [
                r,
                ..acc.encounterhistory
              ])
            r5.ResourceEndpoint(r) ->
              GroupedResources(..acc, endpoint: [r, ..acc.endpoint])
            r5.ResourceEnrollmentrequest(r) ->
              GroupedResources(..acc, enrollmentrequest: [
                r,
                ..acc.enrollmentrequest
              ])
            r5.ResourceEnrollmentresponse(r) ->
              GroupedResources(..acc, enrollmentresponse: [
                r,
                ..acc.enrollmentresponse
              ])
            r5.ResourceEpisodeofcare(r) ->
              GroupedResources(..acc, episodeofcare: [r, ..acc.episodeofcare])
            r5.ResourceEventdefinition(r) ->
              GroupedResources(..acc, eventdefinition: [
                r,
                ..acc.eventdefinition
              ])
            r5.ResourceEvidence(r) ->
              GroupedResources(..acc, evidence: [r, ..acc.evidence])
            r5.ResourceEvidencereport(r) ->
              GroupedResources(..acc, evidencereport: [r, ..acc.evidencereport])
            r5.ResourceEvidencevariable(r) ->
              GroupedResources(..acc, evidencevariable: [
                r,
                ..acc.evidencevariable
              ])
            r5.ResourceExamplescenario(r) ->
              GroupedResources(..acc, examplescenario: [
                r,
                ..acc.examplescenario
              ])
            r5.ResourceExplanationofbenefit(r) ->
              GroupedResources(..acc, explanationofbenefit: [
                r,
                ..acc.explanationofbenefit
              ])
            r5.ResourceFamilymemberhistory(r) ->
              GroupedResources(..acc, familymemberhistory: [
                r,
                ..acc.familymemberhistory
              ])
            r5.ResourceFlag(r) -> GroupedResources(..acc, flag: [r, ..acc.flag])
            r5.ResourceFormularyitem(r) ->
              GroupedResources(..acc, formularyitem: [r, ..acc.formularyitem])
            r5.ResourceGenomicstudy(r) ->
              GroupedResources(..acc, genomicstudy: [r, ..acc.genomicstudy])
            r5.ResourceGoal(r) -> GroupedResources(..acc, goal: [r, ..acc.goal])
            r5.ResourceGraphdefinition(r) ->
              GroupedResources(..acc, graphdefinition: [
                r,
                ..acc.graphdefinition
              ])
            r5.ResourceGroup(r) ->
              GroupedResources(..acc, group: [r, ..acc.group])
            r5.ResourceGuidanceresponse(r) ->
              GroupedResources(..acc, guidanceresponse: [
                r,
                ..acc.guidanceresponse
              ])
            r5.ResourceHealthcareservice(r) ->
              GroupedResources(..acc, healthcareservice: [
                r,
                ..acc.healthcareservice
              ])
            r5.ResourceImagingselection(r) ->
              GroupedResources(..acc, imagingselection: [
                r,
                ..acc.imagingselection
              ])
            r5.ResourceImagingstudy(r) ->
              GroupedResources(..acc, imagingstudy: [r, ..acc.imagingstudy])
            r5.ResourceImmunization(r) ->
              GroupedResources(..acc, immunization: [r, ..acc.immunization])
            r5.ResourceImmunizationevaluation(r) ->
              GroupedResources(..acc, immunizationevaluation: [
                r,
                ..acc.immunizationevaluation
              ])
            r5.ResourceImmunizationrecommendation(r) ->
              GroupedResources(..acc, immunizationrecommendation: [
                r,
                ..acc.immunizationrecommendation
              ])
            r5.ResourceImplementationguide(r) ->
              GroupedResources(..acc, implementationguide: [
                r,
                ..acc.implementationguide
              ])
            r5.ResourceIngredient(r) ->
              GroupedResources(..acc, ingredient: [r, ..acc.ingredient])
            r5.ResourceInsuranceplan(r) ->
              GroupedResources(..acc, insuranceplan: [r, ..acc.insuranceplan])
            r5.ResourceInventoryitem(r) ->
              GroupedResources(..acc, inventoryitem: [r, ..acc.inventoryitem])
            r5.ResourceInventoryreport(r) ->
              GroupedResources(..acc, inventoryreport: [
                r,
                ..acc.inventoryreport
              ])
            r5.ResourceInvoice(r) ->
              GroupedResources(..acc, invoice: [r, ..acc.invoice])
            r5.ResourceLibrary(r) ->
              GroupedResources(..acc, library: [r, ..acc.library])
            r5.ResourceLinkage(r) ->
              GroupedResources(..acc, linkage: [r, ..acc.linkage])
            r5.ResourceListfhir(r) ->
              GroupedResources(..acc, listfhir: [r, ..acc.listfhir])
            r5.ResourceLocation(r) ->
              GroupedResources(..acc, location: [r, ..acc.location])
            r5.ResourceManufactureditemdefinition(r) ->
              GroupedResources(..acc, manufactureditemdefinition: [
                r,
                ..acc.manufactureditemdefinition
              ])
            r5.ResourceMeasure(r) ->
              GroupedResources(..acc, measure: [r, ..acc.measure])
            r5.ResourceMeasurereport(r) ->
              GroupedResources(..acc, measurereport: [r, ..acc.measurereport])
            r5.ResourceMedication(r) ->
              GroupedResources(..acc, medication: [r, ..acc.medication])
            r5.ResourceMedicationadministration(r) ->
              GroupedResources(..acc, medicationadministration: [
                r,
                ..acc.medicationadministration
              ])
            r5.ResourceMedicationdispense(r) ->
              GroupedResources(..acc, medicationdispense: [
                r,
                ..acc.medicationdispense
              ])
            r5.ResourceMedicationknowledge(r) ->
              GroupedResources(..acc, medicationknowledge: [
                r,
                ..acc.medicationknowledge
              ])
            r5.ResourceMedicationrequest(r) ->
              GroupedResources(..acc, medicationrequest: [
                r,
                ..acc.medicationrequest
              ])
            r5.ResourceMedicationstatement(r) ->
              GroupedResources(..acc, medicationstatement: [
                r,
                ..acc.medicationstatement
              ])
            r5.ResourceMedicinalproductdefinition(r) ->
              GroupedResources(..acc, medicinalproductdefinition: [
                r,
                ..acc.medicinalproductdefinition
              ])
            r5.ResourceMessagedefinition(r) ->
              GroupedResources(..acc, messagedefinition: [
                r,
                ..acc.messagedefinition
              ])
            r5.ResourceMessageheader(r) ->
              GroupedResources(..acc, messageheader: [r, ..acc.messageheader])
            r5.ResourceMolecularsequence(r) ->
              GroupedResources(..acc, molecularsequence: [
                r,
                ..acc.molecularsequence
              ])
            r5.ResourceNamingsystem(r) ->
              GroupedResources(..acc, namingsystem: [r, ..acc.namingsystem])
            r5.ResourceNutritionintake(r) ->
              GroupedResources(..acc, nutritionintake: [
                r,
                ..acc.nutritionintake
              ])
            r5.ResourceNutritionorder(r) ->
              GroupedResources(..acc, nutritionorder: [r, ..acc.nutritionorder])
            r5.ResourceNutritionproduct(r) ->
              GroupedResources(..acc, nutritionproduct: [
                r,
                ..acc.nutritionproduct
              ])
            r5.ResourceObservation(r) ->
              GroupedResources(..acc, observation: [r, ..acc.observation])
            r5.ResourceObservationdefinition(r) ->
              GroupedResources(..acc, observationdefinition: [
                r,
                ..acc.observationdefinition
              ])
            r5.ResourceOperationdefinition(r) ->
              GroupedResources(..acc, operationdefinition: [
                r,
                ..acc.operationdefinition
              ])
            r5.ResourceOperationoutcome(r) ->
              GroupedResources(..acc, operationoutcome: [
                r,
                ..acc.operationoutcome
              ])
            r5.ResourceOrganization(r) ->
              GroupedResources(..acc, organization: [r, ..acc.organization])
            r5.ResourceOrganizationaffiliation(r) ->
              GroupedResources(..acc, organizationaffiliation: [
                r,
                ..acc.organizationaffiliation
              ])
            r5.ResourcePackagedproductdefinition(r) ->
              GroupedResources(..acc, packagedproductdefinition: [
                r,
                ..acc.packagedproductdefinition
              ])
            r5.ResourcePatient(r) ->
              GroupedResources(..acc, patient: [r, ..acc.patient])
            r5.ResourcePaymentnotice(r) ->
              GroupedResources(..acc, paymentnotice: [r, ..acc.paymentnotice])
            r5.ResourcePaymentreconciliation(r) ->
              GroupedResources(..acc, paymentreconciliation: [
                r,
                ..acc.paymentreconciliation
              ])
            r5.ResourcePermission(r) ->
              GroupedResources(..acc, permission: [r, ..acc.permission])
            r5.ResourcePerson(r) ->
              GroupedResources(..acc, person: [r, ..acc.person])
            r5.ResourcePlandefinition(r) ->
              GroupedResources(..acc, plandefinition: [r, ..acc.plandefinition])
            r5.ResourcePractitioner(r) ->
              GroupedResources(..acc, practitioner: [r, ..acc.practitioner])
            r5.ResourcePractitionerrole(r) ->
              GroupedResources(..acc, practitionerrole: [
                r,
                ..acc.practitionerrole
              ])
            r5.ResourceProcedure(r) ->
              GroupedResources(..acc, procedure: [r, ..acc.procedure])
            r5.ResourceProvenance(r) ->
              GroupedResources(..acc, provenance: [r, ..acc.provenance])
            r5.ResourceQuestionnaire(r) ->
              GroupedResources(..acc, questionnaire: [r, ..acc.questionnaire])
            r5.ResourceQuestionnaireresponse(r) ->
              GroupedResources(..acc, questionnaireresponse: [
                r,
                ..acc.questionnaireresponse
              ])
            r5.ResourceRegulatedauthorization(r) ->
              GroupedResources(..acc, regulatedauthorization: [
                r,
                ..acc.regulatedauthorization
              ])
            r5.ResourceRelatedperson(r) ->
              GroupedResources(..acc, relatedperson: [r, ..acc.relatedperson])
            r5.ResourceRequestorchestration(r) ->
              GroupedResources(..acc, requestorchestration: [
                r,
                ..acc.requestorchestration
              ])
            r5.ResourceRequirements(r) ->
              GroupedResources(..acc, requirements: [r, ..acc.requirements])
            r5.ResourceResearchstudy(r) ->
              GroupedResources(..acc, researchstudy: [r, ..acc.researchstudy])
            r5.ResourceResearchsubject(r) ->
              GroupedResources(..acc, researchsubject: [
                r,
                ..acc.researchsubject
              ])
            r5.ResourceRiskassessment(r) ->
              GroupedResources(..acc, riskassessment: [r, ..acc.riskassessment])
            r5.ResourceSchedule(r) ->
              GroupedResources(..acc, schedule: [r, ..acc.schedule])
            r5.ResourceSearchparameter(r) ->
              GroupedResources(..acc, searchparameter: [
                r,
                ..acc.searchparameter
              ])
            r5.ResourceServicerequest(r) ->
              GroupedResources(..acc, servicerequest: [r, ..acc.servicerequest])
            r5.ResourceSlot(r) -> GroupedResources(..acc, slot: [r, ..acc.slot])
            r5.ResourceSpecimen(r) ->
              GroupedResources(..acc, specimen: [r, ..acc.specimen])
            r5.ResourceSpecimendefinition(r) ->
              GroupedResources(..acc, specimendefinition: [
                r,
                ..acc.specimendefinition
              ])
            r5.ResourceStructuredefinition(r) ->
              GroupedResources(..acc, structuredefinition: [
                r,
                ..acc.structuredefinition
              ])
            r5.ResourceStructuremap(r) ->
              GroupedResources(..acc, structuremap: [r, ..acc.structuremap])
            r5.ResourceSubscription(r) ->
              GroupedResources(..acc, subscription: [r, ..acc.subscription])
            r5.ResourceSubscriptionstatus(r) ->
              GroupedResources(..acc, subscriptionstatus: [
                r,
                ..acc.subscriptionstatus
              ])
            r5.ResourceSubscriptiontopic(r) ->
              GroupedResources(..acc, subscriptiontopic: [
                r,
                ..acc.subscriptiontopic
              ])
            r5.ResourceSubstance(r) ->
              GroupedResources(..acc, substance: [r, ..acc.substance])
            r5.ResourceSubstancedefinition(r) ->
              GroupedResources(..acc, substancedefinition: [
                r,
                ..acc.substancedefinition
              ])
            r5.ResourceSubstancenucleicacid(r) ->
              GroupedResources(..acc, substancenucleicacid: [
                r,
                ..acc.substancenucleicacid
              ])
            r5.ResourceSubstancepolymer(r) ->
              GroupedResources(..acc, substancepolymer: [
                r,
                ..acc.substancepolymer
              ])
            r5.ResourceSubstanceprotein(r) ->
              GroupedResources(..acc, substanceprotein: [
                r,
                ..acc.substanceprotein
              ])
            r5.ResourceSubstancereferenceinformation(r) ->
              GroupedResources(..acc, substancereferenceinformation: [
                r,
                ..acc.substancereferenceinformation
              ])
            r5.ResourceSubstancesourcematerial(r) ->
              GroupedResources(..acc, substancesourcematerial: [
                r,
                ..acc.substancesourcematerial
              ])
            r5.ResourceSupplydelivery(r) ->
              GroupedResources(..acc, supplydelivery: [r, ..acc.supplydelivery])
            r5.ResourceSupplyrequest(r) ->
              GroupedResources(..acc, supplyrequest: [r, ..acc.supplyrequest])
            r5.ResourceTask(r) -> GroupedResources(..acc, task: [r, ..acc.task])
            r5.ResourceTerminologycapabilities(r) ->
              GroupedResources(..acc, terminologycapabilities: [
                r,
                ..acc.terminologycapabilities
              ])
            r5.ResourceTestplan(r) ->
              GroupedResources(..acc, testplan: [r, ..acc.testplan])
            r5.ResourceTestreport(r) ->
              GroupedResources(..acc, testreport: [r, ..acc.testreport])
            r5.ResourceTestscript(r) ->
              GroupedResources(..acc, testscript: [r, ..acc.testscript])
            r5.ResourceTransport(r) ->
              GroupedResources(..acc, transport: [r, ..acc.transport])
            r5.ResourceValueset(r) ->
              GroupedResources(..acc, valueset: [r, ..acc.valueset])
            r5.ResourceVerificationresult(r) ->
              GroupedResources(..acc, verificationresult: [
                r,
                ..acc.verificationresult
              ])
            r5.ResourceVisionprescription(r) ->
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
