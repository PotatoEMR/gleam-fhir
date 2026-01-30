////[https://hl7.org/fhir/r5](https://hl7.org/fhir/r5) r5 client using httpc

import fhir/r5
import fhir/r5_sansio.{type FhirClient}
import gleam/dynamic/decode.{type Decoder}
import gleam/http/request.{type Request}
import gleam/httpc
import gleam/json.{type Json}
import gleam/option.{type Option}

pub fn fhirclient_new(baseurl: String) -> FhirClient {
  r5_sansio.fhirclient_new(baseurl)
}

pub type Err {
  ErrHttpc(httpc.HttpError)
  ErrSansio(err: r5_sansio.Err)
}

fn any_create(
  resource: Json,
  res_type: String,
  resource_dec: Decoder(r),
  client: FhirClient,
) -> Result(r, Err) {
  let req = r5_sansio.any_create_req(resource, res_type, client)
  sendreq_parseresource(req, resource_dec)
}

fn any_read(
  id: String,
  client: FhirClient,
  res_type: String,
  resource_dec: Decoder(a),
) -> Result(a, Err) {
  let req = r5_sansio.any_read_req(id, res_type, client)
  sendreq_parseresource(req, resource_dec)
}

fn any_update(
  id: Option(String),
  resource: Json,
  res_type: String,
  res_dec: Decoder(r),
  client: FhirClient,
) -> Result(r, Err) {
  let req = r5_sansio.any_update_req(id, resource, res_type, client)
  case req {
    Ok(req) -> sendreq_parseresource(req, res_dec)
    Error(err) -> Error(ErrSansio(err))
    //can have error preparing update request if resource has no id
  }
}

fn any_delete(
  id: Option(String),
  res_type: String,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  let req = r5_sansio.any_delete_req(id, res_type, client)
  case req {
    Ok(req) -> sendreq_parseresource(req, r5.operationoutcome_decoder())
    Error(err) -> Error(ErrSansio(err))
    //can have error preparing delete request if resource has no id
  }
}

fn sendreq_parseresource(
  req: Request(String),
  res_dec: Decoder(r),
) -> Result(r, Err) {
  case httpc.send(req) {
    Error(err) -> Error(ErrHttpc(err))
    Ok(resp) ->
      case r5_sansio.any_resp(resp, res_dec) {
        Ok(resource) -> Ok(resource)
        Error(err) -> Error(ErrSansio(err))
      }
  }
}

pub fn account_create(
  resource: r5.Account,
  client: FhirClient,
) -> Result(r5.Account, Err) {
  any_create(
    r5.account_to_json(resource),
    "Account",
    r5.account_decoder(),
    client,
  )
}

pub fn account_read(id: String, client: FhirClient) -> Result(r5.Account, Err) {
  any_read(id, client, "Account", r5.account_decoder())
}

pub fn account_update(
  resource: r5.Account,
  client: FhirClient,
) -> Result(r5.Account, Err) {
  any_update(
    resource.id,
    r5.account_to_json(resource),
    "Account",
    r5.account_decoder(),
    client,
  )
}

pub fn account_delete(
  resource: r5.Account,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Account", client)
}

pub fn account_search(sp: r5_sansio.SpAccount, client: FhirClient) {
  let req = r5_sansio.account_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn activitydefinition_create(
  resource: r5.Activitydefinition,
  client: FhirClient,
) -> Result(r5.Activitydefinition, Err) {
  any_create(
    r5.activitydefinition_to_json(resource),
    "ActivityDefinition",
    r5.activitydefinition_decoder(),
    client,
  )
}

pub fn activitydefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Activitydefinition, Err) {
  any_read(id, client, "ActivityDefinition", r5.activitydefinition_decoder())
}

pub fn activitydefinition_update(
  resource: r5.Activitydefinition,
  client: FhirClient,
) -> Result(r5.Activitydefinition, Err) {
  any_update(
    resource.id,
    r5.activitydefinition_to_json(resource),
    "ActivityDefinition",
    r5.activitydefinition_decoder(),
    client,
  )
}

pub fn activitydefinition_delete(
  resource: r5.Activitydefinition,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "ActivityDefinition", client)
}

pub fn activitydefinition_search(
  sp: r5_sansio.SpActivitydefinition,
  client: FhirClient,
) {
  let req = r5_sansio.activitydefinition_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn actordefinition_create(
  resource: r5.Actordefinition,
  client: FhirClient,
) -> Result(r5.Actordefinition, Err) {
  any_create(
    r5.actordefinition_to_json(resource),
    "ActorDefinition",
    r5.actordefinition_decoder(),
    client,
  )
}

pub fn actordefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Actordefinition, Err) {
  any_read(id, client, "ActorDefinition", r5.actordefinition_decoder())
}

pub fn actordefinition_update(
  resource: r5.Actordefinition,
  client: FhirClient,
) -> Result(r5.Actordefinition, Err) {
  any_update(
    resource.id,
    r5.actordefinition_to_json(resource),
    "ActorDefinition",
    r5.actordefinition_decoder(),
    client,
  )
}

pub fn actordefinition_delete(
  resource: r5.Actordefinition,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "ActorDefinition", client)
}

pub fn actordefinition_search(
  sp: r5_sansio.SpActordefinition,
  client: FhirClient,
) {
  let req = r5_sansio.actordefinition_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn administrableproductdefinition_create(
  resource: r5.Administrableproductdefinition,
  client: FhirClient,
) -> Result(r5.Administrableproductdefinition, Err) {
  any_create(
    r5.administrableproductdefinition_to_json(resource),
    "AdministrableProductDefinition",
    r5.administrableproductdefinition_decoder(),
    client,
  )
}

pub fn administrableproductdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Administrableproductdefinition, Err) {
  any_read(
    id,
    client,
    "AdministrableProductDefinition",
    r5.administrableproductdefinition_decoder(),
  )
}

pub fn administrableproductdefinition_update(
  resource: r5.Administrableproductdefinition,
  client: FhirClient,
) -> Result(r5.Administrableproductdefinition, Err) {
  any_update(
    resource.id,
    r5.administrableproductdefinition_to_json(resource),
    "AdministrableProductDefinition",
    r5.administrableproductdefinition_decoder(),
    client,
  )
}

pub fn administrableproductdefinition_delete(
  resource: r5.Administrableproductdefinition,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "AdministrableProductDefinition", client)
}

pub fn administrableproductdefinition_search(
  sp: r5_sansio.SpAdministrableproductdefinition,
  client: FhirClient,
) {
  let req = r5_sansio.administrableproductdefinition_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn adverseevent_create(
  resource: r5.Adverseevent,
  client: FhirClient,
) -> Result(r5.Adverseevent, Err) {
  any_create(
    r5.adverseevent_to_json(resource),
    "AdverseEvent",
    r5.adverseevent_decoder(),
    client,
  )
}

pub fn adverseevent_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Adverseevent, Err) {
  any_read(id, client, "AdverseEvent", r5.adverseevent_decoder())
}

pub fn adverseevent_update(
  resource: r5.Adverseevent,
  client: FhirClient,
) -> Result(r5.Adverseevent, Err) {
  any_update(
    resource.id,
    r5.adverseevent_to_json(resource),
    "AdverseEvent",
    r5.adverseevent_decoder(),
    client,
  )
}

pub fn adverseevent_delete(
  resource: r5.Adverseevent,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "AdverseEvent", client)
}

pub fn adverseevent_search(sp: r5_sansio.SpAdverseevent, client: FhirClient) {
  let req = r5_sansio.adverseevent_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn allergyintolerance_create(
  resource: r5.Allergyintolerance,
  client: FhirClient,
) -> Result(r5.Allergyintolerance, Err) {
  any_create(
    r5.allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    r5.allergyintolerance_decoder(),
    client,
  )
}

pub fn allergyintolerance_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Allergyintolerance, Err) {
  any_read(id, client, "AllergyIntolerance", r5.allergyintolerance_decoder())
}

pub fn allergyintolerance_update(
  resource: r5.Allergyintolerance,
  client: FhirClient,
) -> Result(r5.Allergyintolerance, Err) {
  any_update(
    resource.id,
    r5.allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    r5.allergyintolerance_decoder(),
    client,
  )
}

pub fn allergyintolerance_delete(
  resource: r5.Allergyintolerance,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "AllergyIntolerance", client)
}

pub fn allergyintolerance_search(
  sp: r5_sansio.SpAllergyintolerance,
  client: FhirClient,
) {
  let req = r5_sansio.allergyintolerance_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn appointment_create(
  resource: r5.Appointment,
  client: FhirClient,
) -> Result(r5.Appointment, Err) {
  any_create(
    r5.appointment_to_json(resource),
    "Appointment",
    r5.appointment_decoder(),
    client,
  )
}

pub fn appointment_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Appointment, Err) {
  any_read(id, client, "Appointment", r5.appointment_decoder())
}

pub fn appointment_update(
  resource: r5.Appointment,
  client: FhirClient,
) -> Result(r5.Appointment, Err) {
  any_update(
    resource.id,
    r5.appointment_to_json(resource),
    "Appointment",
    r5.appointment_decoder(),
    client,
  )
}

pub fn appointment_delete(
  resource: r5.Appointment,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Appointment", client)
}

pub fn appointment_search(sp: r5_sansio.SpAppointment, client: FhirClient) {
  let req = r5_sansio.appointment_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn appointmentresponse_create(
  resource: r5.Appointmentresponse,
  client: FhirClient,
) -> Result(r5.Appointmentresponse, Err) {
  any_create(
    r5.appointmentresponse_to_json(resource),
    "AppointmentResponse",
    r5.appointmentresponse_decoder(),
    client,
  )
}

pub fn appointmentresponse_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Appointmentresponse, Err) {
  any_read(id, client, "AppointmentResponse", r5.appointmentresponse_decoder())
}

pub fn appointmentresponse_update(
  resource: r5.Appointmentresponse,
  client: FhirClient,
) -> Result(r5.Appointmentresponse, Err) {
  any_update(
    resource.id,
    r5.appointmentresponse_to_json(resource),
    "AppointmentResponse",
    r5.appointmentresponse_decoder(),
    client,
  )
}

pub fn appointmentresponse_delete(
  resource: r5.Appointmentresponse,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "AppointmentResponse", client)
}

pub fn appointmentresponse_search(
  sp: r5_sansio.SpAppointmentresponse,
  client: FhirClient,
) {
  let req = r5_sansio.appointmentresponse_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn artifactassessment_create(
  resource: r5.Artifactassessment,
  client: FhirClient,
) -> Result(r5.Artifactassessment, Err) {
  any_create(
    r5.artifactassessment_to_json(resource),
    "ArtifactAssessment",
    r5.artifactassessment_decoder(),
    client,
  )
}

pub fn artifactassessment_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Artifactassessment, Err) {
  any_read(id, client, "ArtifactAssessment", r5.artifactassessment_decoder())
}

pub fn artifactassessment_update(
  resource: r5.Artifactassessment,
  client: FhirClient,
) -> Result(r5.Artifactassessment, Err) {
  any_update(
    resource.id,
    r5.artifactassessment_to_json(resource),
    "ArtifactAssessment",
    r5.artifactassessment_decoder(),
    client,
  )
}

pub fn artifactassessment_delete(
  resource: r5.Artifactassessment,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "ArtifactAssessment", client)
}

pub fn artifactassessment_search(
  sp: r5_sansio.SpArtifactassessment,
  client: FhirClient,
) {
  let req = r5_sansio.artifactassessment_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn auditevent_create(
  resource: r5.Auditevent,
  client: FhirClient,
) -> Result(r5.Auditevent, Err) {
  any_create(
    r5.auditevent_to_json(resource),
    "AuditEvent",
    r5.auditevent_decoder(),
    client,
  )
}

pub fn auditevent_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Auditevent, Err) {
  any_read(id, client, "AuditEvent", r5.auditevent_decoder())
}

pub fn auditevent_update(
  resource: r5.Auditevent,
  client: FhirClient,
) -> Result(r5.Auditevent, Err) {
  any_update(
    resource.id,
    r5.auditevent_to_json(resource),
    "AuditEvent",
    r5.auditevent_decoder(),
    client,
  )
}

pub fn auditevent_delete(
  resource: r5.Auditevent,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "AuditEvent", client)
}

pub fn auditevent_search(sp: r5_sansio.SpAuditevent, client: FhirClient) {
  let req = r5_sansio.auditevent_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn basic_create(
  resource: r5.Basic,
  client: FhirClient,
) -> Result(r5.Basic, Err) {
  any_create(r5.basic_to_json(resource), "Basic", r5.basic_decoder(), client)
}

pub fn basic_read(id: String, client: FhirClient) -> Result(r5.Basic, Err) {
  any_read(id, client, "Basic", r5.basic_decoder())
}

pub fn basic_update(
  resource: r5.Basic,
  client: FhirClient,
) -> Result(r5.Basic, Err) {
  any_update(
    resource.id,
    r5.basic_to_json(resource),
    "Basic",
    r5.basic_decoder(),
    client,
  )
}

pub fn basic_delete(
  resource: r5.Basic,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Basic", client)
}

pub fn basic_search(sp: r5_sansio.SpBasic, client: FhirClient) {
  let req = r5_sansio.basic_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn binary_create(
  resource: r5.Binary,
  client: FhirClient,
) -> Result(r5.Binary, Err) {
  any_create(r5.binary_to_json(resource), "Binary", r5.binary_decoder(), client)
}

pub fn binary_read(id: String, client: FhirClient) -> Result(r5.Binary, Err) {
  any_read(id, client, "Binary", r5.binary_decoder())
}

pub fn binary_update(
  resource: r5.Binary,
  client: FhirClient,
) -> Result(r5.Binary, Err) {
  any_update(
    resource.id,
    r5.binary_to_json(resource),
    "Binary",
    r5.binary_decoder(),
    client,
  )
}

pub fn binary_delete(
  resource: r5.Binary,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Binary", client)
}

pub fn binary_search(sp: r5_sansio.SpBinary, client: FhirClient) {
  let req = r5_sansio.binary_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn biologicallyderivedproduct_create(
  resource: r5.Biologicallyderivedproduct,
  client: FhirClient,
) -> Result(r5.Biologicallyderivedproduct, Err) {
  any_create(
    r5.biologicallyderivedproduct_to_json(resource),
    "BiologicallyDerivedProduct",
    r5.biologicallyderivedproduct_decoder(),
    client,
  )
}

pub fn biologicallyderivedproduct_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Biologicallyderivedproduct, Err) {
  any_read(
    id,
    client,
    "BiologicallyDerivedProduct",
    r5.biologicallyderivedproduct_decoder(),
  )
}

pub fn biologicallyderivedproduct_update(
  resource: r5.Biologicallyderivedproduct,
  client: FhirClient,
) -> Result(r5.Biologicallyderivedproduct, Err) {
  any_update(
    resource.id,
    r5.biologicallyderivedproduct_to_json(resource),
    "BiologicallyDerivedProduct",
    r5.biologicallyderivedproduct_decoder(),
    client,
  )
}

pub fn biologicallyderivedproduct_delete(
  resource: r5.Biologicallyderivedproduct,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "BiologicallyDerivedProduct", client)
}

pub fn biologicallyderivedproduct_search(
  sp: r5_sansio.SpBiologicallyderivedproduct,
  client: FhirClient,
) {
  let req = r5_sansio.biologicallyderivedproduct_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn biologicallyderivedproductdispense_create(
  resource: r5.Biologicallyderivedproductdispense,
  client: FhirClient,
) -> Result(r5.Biologicallyderivedproductdispense, Err) {
  any_create(
    r5.biologicallyderivedproductdispense_to_json(resource),
    "BiologicallyDerivedProductDispense",
    r5.biologicallyderivedproductdispense_decoder(),
    client,
  )
}

pub fn biologicallyderivedproductdispense_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Biologicallyderivedproductdispense, Err) {
  any_read(
    id,
    client,
    "BiologicallyDerivedProductDispense",
    r5.biologicallyderivedproductdispense_decoder(),
  )
}

pub fn biologicallyderivedproductdispense_update(
  resource: r5.Biologicallyderivedproductdispense,
  client: FhirClient,
) -> Result(r5.Biologicallyderivedproductdispense, Err) {
  any_update(
    resource.id,
    r5.biologicallyderivedproductdispense_to_json(resource),
    "BiologicallyDerivedProductDispense",
    r5.biologicallyderivedproductdispense_decoder(),
    client,
  )
}

pub fn biologicallyderivedproductdispense_delete(
  resource: r5.Biologicallyderivedproductdispense,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "BiologicallyDerivedProductDispense", client)
}

pub fn biologicallyderivedproductdispense_search(
  sp: r5_sansio.SpBiologicallyderivedproductdispense,
  client: FhirClient,
) {
  let req = r5_sansio.biologicallyderivedproductdispense_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn bodystructure_create(
  resource: r5.Bodystructure,
  client: FhirClient,
) -> Result(r5.Bodystructure, Err) {
  any_create(
    r5.bodystructure_to_json(resource),
    "BodyStructure",
    r5.bodystructure_decoder(),
    client,
  )
}

pub fn bodystructure_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Bodystructure, Err) {
  any_read(id, client, "BodyStructure", r5.bodystructure_decoder())
}

pub fn bodystructure_update(
  resource: r5.Bodystructure,
  client: FhirClient,
) -> Result(r5.Bodystructure, Err) {
  any_update(
    resource.id,
    r5.bodystructure_to_json(resource),
    "BodyStructure",
    r5.bodystructure_decoder(),
    client,
  )
}

pub fn bodystructure_delete(
  resource: r5.Bodystructure,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "BodyStructure", client)
}

pub fn bodystructure_search(sp: r5_sansio.SpBodystructure, client: FhirClient) {
  let req = r5_sansio.bodystructure_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn bundle_create(
  resource: r5.Bundle,
  client: FhirClient,
) -> Result(r5.Bundle, Err) {
  any_create(r5.bundle_to_json(resource), "Bundle", r5.bundle_decoder(), client)
}

pub fn bundle_read(id: String, client: FhirClient) -> Result(r5.Bundle, Err) {
  any_read(id, client, "Bundle", r5.bundle_decoder())
}

pub fn bundle_update(
  resource: r5.Bundle,
  client: FhirClient,
) -> Result(r5.Bundle, Err) {
  any_update(
    resource.id,
    r5.bundle_to_json(resource),
    "Bundle",
    r5.bundle_decoder(),
    client,
  )
}

pub fn bundle_delete(
  resource: r5.Bundle,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Bundle", client)
}

pub fn bundle_search(sp: r5_sansio.SpBundle, client: FhirClient) {
  let req = r5_sansio.bundle_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn capabilitystatement_create(
  resource: r5.Capabilitystatement,
  client: FhirClient,
) -> Result(r5.Capabilitystatement, Err) {
  any_create(
    r5.capabilitystatement_to_json(resource),
    "CapabilityStatement",
    r5.capabilitystatement_decoder(),
    client,
  )
}

pub fn capabilitystatement_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Capabilitystatement, Err) {
  any_read(id, client, "CapabilityStatement", r5.capabilitystatement_decoder())
}

pub fn capabilitystatement_update(
  resource: r5.Capabilitystatement,
  client: FhirClient,
) -> Result(r5.Capabilitystatement, Err) {
  any_update(
    resource.id,
    r5.capabilitystatement_to_json(resource),
    "CapabilityStatement",
    r5.capabilitystatement_decoder(),
    client,
  )
}

pub fn capabilitystatement_delete(
  resource: r5.Capabilitystatement,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "CapabilityStatement", client)
}

pub fn capabilitystatement_search(
  sp: r5_sansio.SpCapabilitystatement,
  client: FhirClient,
) {
  let req = r5_sansio.capabilitystatement_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn careplan_create(
  resource: r5.Careplan,
  client: FhirClient,
) -> Result(r5.Careplan, Err) {
  any_create(
    r5.careplan_to_json(resource),
    "CarePlan",
    r5.careplan_decoder(),
    client,
  )
}

pub fn careplan_read(id: String, client: FhirClient) -> Result(r5.Careplan, Err) {
  any_read(id, client, "CarePlan", r5.careplan_decoder())
}

pub fn careplan_update(
  resource: r5.Careplan,
  client: FhirClient,
) -> Result(r5.Careplan, Err) {
  any_update(
    resource.id,
    r5.careplan_to_json(resource),
    "CarePlan",
    r5.careplan_decoder(),
    client,
  )
}

pub fn careplan_delete(
  resource: r5.Careplan,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "CarePlan", client)
}

pub fn careplan_search(sp: r5_sansio.SpCareplan, client: FhirClient) {
  let req = r5_sansio.careplan_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn careteam_create(
  resource: r5.Careteam,
  client: FhirClient,
) -> Result(r5.Careteam, Err) {
  any_create(
    r5.careteam_to_json(resource),
    "CareTeam",
    r5.careteam_decoder(),
    client,
  )
}

pub fn careteam_read(id: String, client: FhirClient) -> Result(r5.Careteam, Err) {
  any_read(id, client, "CareTeam", r5.careteam_decoder())
}

pub fn careteam_update(
  resource: r5.Careteam,
  client: FhirClient,
) -> Result(r5.Careteam, Err) {
  any_update(
    resource.id,
    r5.careteam_to_json(resource),
    "CareTeam",
    r5.careteam_decoder(),
    client,
  )
}

pub fn careteam_delete(
  resource: r5.Careteam,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "CareTeam", client)
}

pub fn careteam_search(sp: r5_sansio.SpCareteam, client: FhirClient) {
  let req = r5_sansio.careteam_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn chargeitem_create(
  resource: r5.Chargeitem,
  client: FhirClient,
) -> Result(r5.Chargeitem, Err) {
  any_create(
    r5.chargeitem_to_json(resource),
    "ChargeItem",
    r5.chargeitem_decoder(),
    client,
  )
}

pub fn chargeitem_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Chargeitem, Err) {
  any_read(id, client, "ChargeItem", r5.chargeitem_decoder())
}

pub fn chargeitem_update(
  resource: r5.Chargeitem,
  client: FhirClient,
) -> Result(r5.Chargeitem, Err) {
  any_update(
    resource.id,
    r5.chargeitem_to_json(resource),
    "ChargeItem",
    r5.chargeitem_decoder(),
    client,
  )
}

pub fn chargeitem_delete(
  resource: r5.Chargeitem,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "ChargeItem", client)
}

pub fn chargeitem_search(sp: r5_sansio.SpChargeitem, client: FhirClient) {
  let req = r5_sansio.chargeitem_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn chargeitemdefinition_create(
  resource: r5.Chargeitemdefinition,
  client: FhirClient,
) -> Result(r5.Chargeitemdefinition, Err) {
  any_create(
    r5.chargeitemdefinition_to_json(resource),
    "ChargeItemDefinition",
    r5.chargeitemdefinition_decoder(),
    client,
  )
}

pub fn chargeitemdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Chargeitemdefinition, Err) {
  any_read(
    id,
    client,
    "ChargeItemDefinition",
    r5.chargeitemdefinition_decoder(),
  )
}

pub fn chargeitemdefinition_update(
  resource: r5.Chargeitemdefinition,
  client: FhirClient,
) -> Result(r5.Chargeitemdefinition, Err) {
  any_update(
    resource.id,
    r5.chargeitemdefinition_to_json(resource),
    "ChargeItemDefinition",
    r5.chargeitemdefinition_decoder(),
    client,
  )
}

pub fn chargeitemdefinition_delete(
  resource: r5.Chargeitemdefinition,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "ChargeItemDefinition", client)
}

pub fn chargeitemdefinition_search(
  sp: r5_sansio.SpChargeitemdefinition,
  client: FhirClient,
) {
  let req = r5_sansio.chargeitemdefinition_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn citation_create(
  resource: r5.Citation,
  client: FhirClient,
) -> Result(r5.Citation, Err) {
  any_create(
    r5.citation_to_json(resource),
    "Citation",
    r5.citation_decoder(),
    client,
  )
}

pub fn citation_read(id: String, client: FhirClient) -> Result(r5.Citation, Err) {
  any_read(id, client, "Citation", r5.citation_decoder())
}

pub fn citation_update(
  resource: r5.Citation,
  client: FhirClient,
) -> Result(r5.Citation, Err) {
  any_update(
    resource.id,
    r5.citation_to_json(resource),
    "Citation",
    r5.citation_decoder(),
    client,
  )
}

pub fn citation_delete(
  resource: r5.Citation,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Citation", client)
}

pub fn citation_search(sp: r5_sansio.SpCitation, client: FhirClient) {
  let req = r5_sansio.citation_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn claim_create(
  resource: r5.Claim,
  client: FhirClient,
) -> Result(r5.Claim, Err) {
  any_create(r5.claim_to_json(resource), "Claim", r5.claim_decoder(), client)
}

pub fn claim_read(id: String, client: FhirClient) -> Result(r5.Claim, Err) {
  any_read(id, client, "Claim", r5.claim_decoder())
}

pub fn claim_update(
  resource: r5.Claim,
  client: FhirClient,
) -> Result(r5.Claim, Err) {
  any_update(
    resource.id,
    r5.claim_to_json(resource),
    "Claim",
    r5.claim_decoder(),
    client,
  )
}

pub fn claim_delete(
  resource: r5.Claim,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Claim", client)
}

pub fn claim_search(sp: r5_sansio.SpClaim, client: FhirClient) {
  let req = r5_sansio.claim_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn claimresponse_create(
  resource: r5.Claimresponse,
  client: FhirClient,
) -> Result(r5.Claimresponse, Err) {
  any_create(
    r5.claimresponse_to_json(resource),
    "ClaimResponse",
    r5.claimresponse_decoder(),
    client,
  )
}

pub fn claimresponse_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Claimresponse, Err) {
  any_read(id, client, "ClaimResponse", r5.claimresponse_decoder())
}

pub fn claimresponse_update(
  resource: r5.Claimresponse,
  client: FhirClient,
) -> Result(r5.Claimresponse, Err) {
  any_update(
    resource.id,
    r5.claimresponse_to_json(resource),
    "ClaimResponse",
    r5.claimresponse_decoder(),
    client,
  )
}

pub fn claimresponse_delete(
  resource: r5.Claimresponse,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "ClaimResponse", client)
}

pub fn claimresponse_search(sp: r5_sansio.SpClaimresponse, client: FhirClient) {
  let req = r5_sansio.claimresponse_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn clinicalimpression_create(
  resource: r5.Clinicalimpression,
  client: FhirClient,
) -> Result(r5.Clinicalimpression, Err) {
  any_create(
    r5.clinicalimpression_to_json(resource),
    "ClinicalImpression",
    r5.clinicalimpression_decoder(),
    client,
  )
}

pub fn clinicalimpression_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Clinicalimpression, Err) {
  any_read(id, client, "ClinicalImpression", r5.clinicalimpression_decoder())
}

pub fn clinicalimpression_update(
  resource: r5.Clinicalimpression,
  client: FhirClient,
) -> Result(r5.Clinicalimpression, Err) {
  any_update(
    resource.id,
    r5.clinicalimpression_to_json(resource),
    "ClinicalImpression",
    r5.clinicalimpression_decoder(),
    client,
  )
}

pub fn clinicalimpression_delete(
  resource: r5.Clinicalimpression,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "ClinicalImpression", client)
}

pub fn clinicalimpression_search(
  sp: r5_sansio.SpClinicalimpression,
  client: FhirClient,
) {
  let req = r5_sansio.clinicalimpression_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn clinicalusedefinition_create(
  resource: r5.Clinicalusedefinition,
  client: FhirClient,
) -> Result(r5.Clinicalusedefinition, Err) {
  any_create(
    r5.clinicalusedefinition_to_json(resource),
    "ClinicalUseDefinition",
    r5.clinicalusedefinition_decoder(),
    client,
  )
}

pub fn clinicalusedefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Clinicalusedefinition, Err) {
  any_read(
    id,
    client,
    "ClinicalUseDefinition",
    r5.clinicalusedefinition_decoder(),
  )
}

pub fn clinicalusedefinition_update(
  resource: r5.Clinicalusedefinition,
  client: FhirClient,
) -> Result(r5.Clinicalusedefinition, Err) {
  any_update(
    resource.id,
    r5.clinicalusedefinition_to_json(resource),
    "ClinicalUseDefinition",
    r5.clinicalusedefinition_decoder(),
    client,
  )
}

pub fn clinicalusedefinition_delete(
  resource: r5.Clinicalusedefinition,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "ClinicalUseDefinition", client)
}

pub fn clinicalusedefinition_search(
  sp: r5_sansio.SpClinicalusedefinition,
  client: FhirClient,
) {
  let req = r5_sansio.clinicalusedefinition_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn codesystem_create(
  resource: r5.Codesystem,
  client: FhirClient,
) -> Result(r5.Codesystem, Err) {
  any_create(
    r5.codesystem_to_json(resource),
    "CodeSystem",
    r5.codesystem_decoder(),
    client,
  )
}

pub fn codesystem_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Codesystem, Err) {
  any_read(id, client, "CodeSystem", r5.codesystem_decoder())
}

pub fn codesystem_update(
  resource: r5.Codesystem,
  client: FhirClient,
) -> Result(r5.Codesystem, Err) {
  any_update(
    resource.id,
    r5.codesystem_to_json(resource),
    "CodeSystem",
    r5.codesystem_decoder(),
    client,
  )
}

pub fn codesystem_delete(
  resource: r5.Codesystem,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "CodeSystem", client)
}

pub fn codesystem_search(sp: r5_sansio.SpCodesystem, client: FhirClient) {
  let req = r5_sansio.codesystem_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn communication_create(
  resource: r5.Communication,
  client: FhirClient,
) -> Result(r5.Communication, Err) {
  any_create(
    r5.communication_to_json(resource),
    "Communication",
    r5.communication_decoder(),
    client,
  )
}

pub fn communication_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Communication, Err) {
  any_read(id, client, "Communication", r5.communication_decoder())
}

pub fn communication_update(
  resource: r5.Communication,
  client: FhirClient,
) -> Result(r5.Communication, Err) {
  any_update(
    resource.id,
    r5.communication_to_json(resource),
    "Communication",
    r5.communication_decoder(),
    client,
  )
}

pub fn communication_delete(
  resource: r5.Communication,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Communication", client)
}

pub fn communication_search(sp: r5_sansio.SpCommunication, client: FhirClient) {
  let req = r5_sansio.communication_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn communicationrequest_create(
  resource: r5.Communicationrequest,
  client: FhirClient,
) -> Result(r5.Communicationrequest, Err) {
  any_create(
    r5.communicationrequest_to_json(resource),
    "CommunicationRequest",
    r5.communicationrequest_decoder(),
    client,
  )
}

pub fn communicationrequest_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Communicationrequest, Err) {
  any_read(
    id,
    client,
    "CommunicationRequest",
    r5.communicationrequest_decoder(),
  )
}

pub fn communicationrequest_update(
  resource: r5.Communicationrequest,
  client: FhirClient,
) -> Result(r5.Communicationrequest, Err) {
  any_update(
    resource.id,
    r5.communicationrequest_to_json(resource),
    "CommunicationRequest",
    r5.communicationrequest_decoder(),
    client,
  )
}

pub fn communicationrequest_delete(
  resource: r5.Communicationrequest,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "CommunicationRequest", client)
}

pub fn communicationrequest_search(
  sp: r5_sansio.SpCommunicationrequest,
  client: FhirClient,
) {
  let req = r5_sansio.communicationrequest_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn compartmentdefinition_create(
  resource: r5.Compartmentdefinition,
  client: FhirClient,
) -> Result(r5.Compartmentdefinition, Err) {
  any_create(
    r5.compartmentdefinition_to_json(resource),
    "CompartmentDefinition",
    r5.compartmentdefinition_decoder(),
    client,
  )
}

pub fn compartmentdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Compartmentdefinition, Err) {
  any_read(
    id,
    client,
    "CompartmentDefinition",
    r5.compartmentdefinition_decoder(),
  )
}

pub fn compartmentdefinition_update(
  resource: r5.Compartmentdefinition,
  client: FhirClient,
) -> Result(r5.Compartmentdefinition, Err) {
  any_update(
    resource.id,
    r5.compartmentdefinition_to_json(resource),
    "CompartmentDefinition",
    r5.compartmentdefinition_decoder(),
    client,
  )
}

pub fn compartmentdefinition_delete(
  resource: r5.Compartmentdefinition,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "CompartmentDefinition", client)
}

pub fn compartmentdefinition_search(
  sp: r5_sansio.SpCompartmentdefinition,
  client: FhirClient,
) {
  let req = r5_sansio.compartmentdefinition_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn composition_create(
  resource: r5.Composition,
  client: FhirClient,
) -> Result(r5.Composition, Err) {
  any_create(
    r5.composition_to_json(resource),
    "Composition",
    r5.composition_decoder(),
    client,
  )
}

pub fn composition_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Composition, Err) {
  any_read(id, client, "Composition", r5.composition_decoder())
}

pub fn composition_update(
  resource: r5.Composition,
  client: FhirClient,
) -> Result(r5.Composition, Err) {
  any_update(
    resource.id,
    r5.composition_to_json(resource),
    "Composition",
    r5.composition_decoder(),
    client,
  )
}

pub fn composition_delete(
  resource: r5.Composition,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Composition", client)
}

pub fn composition_search(sp: r5_sansio.SpComposition, client: FhirClient) {
  let req = r5_sansio.composition_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn conceptmap_create(
  resource: r5.Conceptmap,
  client: FhirClient,
) -> Result(r5.Conceptmap, Err) {
  any_create(
    r5.conceptmap_to_json(resource),
    "ConceptMap",
    r5.conceptmap_decoder(),
    client,
  )
}

pub fn conceptmap_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Conceptmap, Err) {
  any_read(id, client, "ConceptMap", r5.conceptmap_decoder())
}

pub fn conceptmap_update(
  resource: r5.Conceptmap,
  client: FhirClient,
) -> Result(r5.Conceptmap, Err) {
  any_update(
    resource.id,
    r5.conceptmap_to_json(resource),
    "ConceptMap",
    r5.conceptmap_decoder(),
    client,
  )
}

pub fn conceptmap_delete(
  resource: r5.Conceptmap,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "ConceptMap", client)
}

pub fn conceptmap_search(sp: r5_sansio.SpConceptmap, client: FhirClient) {
  let req = r5_sansio.conceptmap_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn condition_create(
  resource: r5.Condition,
  client: FhirClient,
) -> Result(r5.Condition, Err) {
  any_create(
    r5.condition_to_json(resource),
    "Condition",
    r5.condition_decoder(),
    client,
  )
}

pub fn condition_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Condition, Err) {
  any_read(id, client, "Condition", r5.condition_decoder())
}

pub fn condition_update(
  resource: r5.Condition,
  client: FhirClient,
) -> Result(r5.Condition, Err) {
  any_update(
    resource.id,
    r5.condition_to_json(resource),
    "Condition",
    r5.condition_decoder(),
    client,
  )
}

pub fn condition_delete(
  resource: r5.Condition,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Condition", client)
}

pub fn condition_search(sp: r5_sansio.SpCondition, client: FhirClient) {
  let req = r5_sansio.condition_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn conditiondefinition_create(
  resource: r5.Conditiondefinition,
  client: FhirClient,
) -> Result(r5.Conditiondefinition, Err) {
  any_create(
    r5.conditiondefinition_to_json(resource),
    "ConditionDefinition",
    r5.conditiondefinition_decoder(),
    client,
  )
}

pub fn conditiondefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Conditiondefinition, Err) {
  any_read(id, client, "ConditionDefinition", r5.conditiondefinition_decoder())
}

pub fn conditiondefinition_update(
  resource: r5.Conditiondefinition,
  client: FhirClient,
) -> Result(r5.Conditiondefinition, Err) {
  any_update(
    resource.id,
    r5.conditiondefinition_to_json(resource),
    "ConditionDefinition",
    r5.conditiondefinition_decoder(),
    client,
  )
}

pub fn conditiondefinition_delete(
  resource: r5.Conditiondefinition,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "ConditionDefinition", client)
}

pub fn conditiondefinition_search(
  sp: r5_sansio.SpConditiondefinition,
  client: FhirClient,
) {
  let req = r5_sansio.conditiondefinition_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn consent_create(
  resource: r5.Consent,
  client: FhirClient,
) -> Result(r5.Consent, Err) {
  any_create(
    r5.consent_to_json(resource),
    "Consent",
    r5.consent_decoder(),
    client,
  )
}

pub fn consent_read(id: String, client: FhirClient) -> Result(r5.Consent, Err) {
  any_read(id, client, "Consent", r5.consent_decoder())
}

pub fn consent_update(
  resource: r5.Consent,
  client: FhirClient,
) -> Result(r5.Consent, Err) {
  any_update(
    resource.id,
    r5.consent_to_json(resource),
    "Consent",
    r5.consent_decoder(),
    client,
  )
}

pub fn consent_delete(
  resource: r5.Consent,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Consent", client)
}

pub fn consent_search(sp: r5_sansio.SpConsent, client: FhirClient) {
  let req = r5_sansio.consent_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn contract_create(
  resource: r5.Contract,
  client: FhirClient,
) -> Result(r5.Contract, Err) {
  any_create(
    r5.contract_to_json(resource),
    "Contract",
    r5.contract_decoder(),
    client,
  )
}

pub fn contract_read(id: String, client: FhirClient) -> Result(r5.Contract, Err) {
  any_read(id, client, "Contract", r5.contract_decoder())
}

pub fn contract_update(
  resource: r5.Contract,
  client: FhirClient,
) -> Result(r5.Contract, Err) {
  any_update(
    resource.id,
    r5.contract_to_json(resource),
    "Contract",
    r5.contract_decoder(),
    client,
  )
}

pub fn contract_delete(
  resource: r5.Contract,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Contract", client)
}

pub fn contract_search(sp: r5_sansio.SpContract, client: FhirClient) {
  let req = r5_sansio.contract_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn coverage_create(
  resource: r5.Coverage,
  client: FhirClient,
) -> Result(r5.Coverage, Err) {
  any_create(
    r5.coverage_to_json(resource),
    "Coverage",
    r5.coverage_decoder(),
    client,
  )
}

pub fn coverage_read(id: String, client: FhirClient) -> Result(r5.Coverage, Err) {
  any_read(id, client, "Coverage", r5.coverage_decoder())
}

pub fn coverage_update(
  resource: r5.Coverage,
  client: FhirClient,
) -> Result(r5.Coverage, Err) {
  any_update(
    resource.id,
    r5.coverage_to_json(resource),
    "Coverage",
    r5.coverage_decoder(),
    client,
  )
}

pub fn coverage_delete(
  resource: r5.Coverage,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Coverage", client)
}

pub fn coverage_search(sp: r5_sansio.SpCoverage, client: FhirClient) {
  let req = r5_sansio.coverage_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn coverageeligibilityrequest_create(
  resource: r5.Coverageeligibilityrequest,
  client: FhirClient,
) -> Result(r5.Coverageeligibilityrequest, Err) {
  any_create(
    r5.coverageeligibilityrequest_to_json(resource),
    "CoverageEligibilityRequest",
    r5.coverageeligibilityrequest_decoder(),
    client,
  )
}

pub fn coverageeligibilityrequest_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Coverageeligibilityrequest, Err) {
  any_read(
    id,
    client,
    "CoverageEligibilityRequest",
    r5.coverageeligibilityrequest_decoder(),
  )
}

pub fn coverageeligibilityrequest_update(
  resource: r5.Coverageeligibilityrequest,
  client: FhirClient,
) -> Result(r5.Coverageeligibilityrequest, Err) {
  any_update(
    resource.id,
    r5.coverageeligibilityrequest_to_json(resource),
    "CoverageEligibilityRequest",
    r5.coverageeligibilityrequest_decoder(),
    client,
  )
}

pub fn coverageeligibilityrequest_delete(
  resource: r5.Coverageeligibilityrequest,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "CoverageEligibilityRequest", client)
}

pub fn coverageeligibilityrequest_search(
  sp: r5_sansio.SpCoverageeligibilityrequest,
  client: FhirClient,
) {
  let req = r5_sansio.coverageeligibilityrequest_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn coverageeligibilityresponse_create(
  resource: r5.Coverageeligibilityresponse,
  client: FhirClient,
) -> Result(r5.Coverageeligibilityresponse, Err) {
  any_create(
    r5.coverageeligibilityresponse_to_json(resource),
    "CoverageEligibilityResponse",
    r5.coverageeligibilityresponse_decoder(),
    client,
  )
}

pub fn coverageeligibilityresponse_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Coverageeligibilityresponse, Err) {
  any_read(
    id,
    client,
    "CoverageEligibilityResponse",
    r5.coverageeligibilityresponse_decoder(),
  )
}

pub fn coverageeligibilityresponse_update(
  resource: r5.Coverageeligibilityresponse,
  client: FhirClient,
) -> Result(r5.Coverageeligibilityresponse, Err) {
  any_update(
    resource.id,
    r5.coverageeligibilityresponse_to_json(resource),
    "CoverageEligibilityResponse",
    r5.coverageeligibilityresponse_decoder(),
    client,
  )
}

pub fn coverageeligibilityresponse_delete(
  resource: r5.Coverageeligibilityresponse,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "CoverageEligibilityResponse", client)
}

pub fn coverageeligibilityresponse_search(
  sp: r5_sansio.SpCoverageeligibilityresponse,
  client: FhirClient,
) {
  let req = r5_sansio.coverageeligibilityresponse_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn detectedissue_create(
  resource: r5.Detectedissue,
  client: FhirClient,
) -> Result(r5.Detectedissue, Err) {
  any_create(
    r5.detectedissue_to_json(resource),
    "DetectedIssue",
    r5.detectedissue_decoder(),
    client,
  )
}

pub fn detectedissue_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Detectedissue, Err) {
  any_read(id, client, "DetectedIssue", r5.detectedissue_decoder())
}

pub fn detectedissue_update(
  resource: r5.Detectedissue,
  client: FhirClient,
) -> Result(r5.Detectedissue, Err) {
  any_update(
    resource.id,
    r5.detectedissue_to_json(resource),
    "DetectedIssue",
    r5.detectedissue_decoder(),
    client,
  )
}

pub fn detectedissue_delete(
  resource: r5.Detectedissue,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "DetectedIssue", client)
}

pub fn detectedissue_search(sp: r5_sansio.SpDetectedissue, client: FhirClient) {
  let req = r5_sansio.detectedissue_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn device_create(
  resource: r5.Device,
  client: FhirClient,
) -> Result(r5.Device, Err) {
  any_create(r5.device_to_json(resource), "Device", r5.device_decoder(), client)
}

pub fn device_read(id: String, client: FhirClient) -> Result(r5.Device, Err) {
  any_read(id, client, "Device", r5.device_decoder())
}

pub fn device_update(
  resource: r5.Device,
  client: FhirClient,
) -> Result(r5.Device, Err) {
  any_update(
    resource.id,
    r5.device_to_json(resource),
    "Device",
    r5.device_decoder(),
    client,
  )
}

pub fn device_delete(
  resource: r5.Device,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Device", client)
}

pub fn device_search(sp: r5_sansio.SpDevice, client: FhirClient) {
  let req = r5_sansio.device_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn deviceassociation_create(
  resource: r5.Deviceassociation,
  client: FhirClient,
) -> Result(r5.Deviceassociation, Err) {
  any_create(
    r5.deviceassociation_to_json(resource),
    "DeviceAssociation",
    r5.deviceassociation_decoder(),
    client,
  )
}

pub fn deviceassociation_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Deviceassociation, Err) {
  any_read(id, client, "DeviceAssociation", r5.deviceassociation_decoder())
}

pub fn deviceassociation_update(
  resource: r5.Deviceassociation,
  client: FhirClient,
) -> Result(r5.Deviceassociation, Err) {
  any_update(
    resource.id,
    r5.deviceassociation_to_json(resource),
    "DeviceAssociation",
    r5.deviceassociation_decoder(),
    client,
  )
}

pub fn deviceassociation_delete(
  resource: r5.Deviceassociation,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "DeviceAssociation", client)
}

pub fn deviceassociation_search(
  sp: r5_sansio.SpDeviceassociation,
  client: FhirClient,
) {
  let req = r5_sansio.deviceassociation_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn devicedefinition_create(
  resource: r5.Devicedefinition,
  client: FhirClient,
) -> Result(r5.Devicedefinition, Err) {
  any_create(
    r5.devicedefinition_to_json(resource),
    "DeviceDefinition",
    r5.devicedefinition_decoder(),
    client,
  )
}

pub fn devicedefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Devicedefinition, Err) {
  any_read(id, client, "DeviceDefinition", r5.devicedefinition_decoder())
}

pub fn devicedefinition_update(
  resource: r5.Devicedefinition,
  client: FhirClient,
) -> Result(r5.Devicedefinition, Err) {
  any_update(
    resource.id,
    r5.devicedefinition_to_json(resource),
    "DeviceDefinition",
    r5.devicedefinition_decoder(),
    client,
  )
}

pub fn devicedefinition_delete(
  resource: r5.Devicedefinition,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "DeviceDefinition", client)
}

pub fn devicedefinition_search(
  sp: r5_sansio.SpDevicedefinition,
  client: FhirClient,
) {
  let req = r5_sansio.devicedefinition_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn devicedispense_create(
  resource: r5.Devicedispense,
  client: FhirClient,
) -> Result(r5.Devicedispense, Err) {
  any_create(
    r5.devicedispense_to_json(resource),
    "DeviceDispense",
    r5.devicedispense_decoder(),
    client,
  )
}

pub fn devicedispense_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Devicedispense, Err) {
  any_read(id, client, "DeviceDispense", r5.devicedispense_decoder())
}

pub fn devicedispense_update(
  resource: r5.Devicedispense,
  client: FhirClient,
) -> Result(r5.Devicedispense, Err) {
  any_update(
    resource.id,
    r5.devicedispense_to_json(resource),
    "DeviceDispense",
    r5.devicedispense_decoder(),
    client,
  )
}

pub fn devicedispense_delete(
  resource: r5.Devicedispense,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "DeviceDispense", client)
}

pub fn devicedispense_search(sp: r5_sansio.SpDevicedispense, client: FhirClient) {
  let req = r5_sansio.devicedispense_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn devicemetric_create(
  resource: r5.Devicemetric,
  client: FhirClient,
) -> Result(r5.Devicemetric, Err) {
  any_create(
    r5.devicemetric_to_json(resource),
    "DeviceMetric",
    r5.devicemetric_decoder(),
    client,
  )
}

pub fn devicemetric_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Devicemetric, Err) {
  any_read(id, client, "DeviceMetric", r5.devicemetric_decoder())
}

pub fn devicemetric_update(
  resource: r5.Devicemetric,
  client: FhirClient,
) -> Result(r5.Devicemetric, Err) {
  any_update(
    resource.id,
    r5.devicemetric_to_json(resource),
    "DeviceMetric",
    r5.devicemetric_decoder(),
    client,
  )
}

pub fn devicemetric_delete(
  resource: r5.Devicemetric,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "DeviceMetric", client)
}

pub fn devicemetric_search(sp: r5_sansio.SpDevicemetric, client: FhirClient) {
  let req = r5_sansio.devicemetric_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn devicerequest_create(
  resource: r5.Devicerequest,
  client: FhirClient,
) -> Result(r5.Devicerequest, Err) {
  any_create(
    r5.devicerequest_to_json(resource),
    "DeviceRequest",
    r5.devicerequest_decoder(),
    client,
  )
}

pub fn devicerequest_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Devicerequest, Err) {
  any_read(id, client, "DeviceRequest", r5.devicerequest_decoder())
}

pub fn devicerequest_update(
  resource: r5.Devicerequest,
  client: FhirClient,
) -> Result(r5.Devicerequest, Err) {
  any_update(
    resource.id,
    r5.devicerequest_to_json(resource),
    "DeviceRequest",
    r5.devicerequest_decoder(),
    client,
  )
}

pub fn devicerequest_delete(
  resource: r5.Devicerequest,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "DeviceRequest", client)
}

pub fn devicerequest_search(sp: r5_sansio.SpDevicerequest, client: FhirClient) {
  let req = r5_sansio.devicerequest_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn deviceusage_create(
  resource: r5.Deviceusage,
  client: FhirClient,
) -> Result(r5.Deviceusage, Err) {
  any_create(
    r5.deviceusage_to_json(resource),
    "DeviceUsage",
    r5.deviceusage_decoder(),
    client,
  )
}

pub fn deviceusage_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Deviceusage, Err) {
  any_read(id, client, "DeviceUsage", r5.deviceusage_decoder())
}

pub fn deviceusage_update(
  resource: r5.Deviceusage,
  client: FhirClient,
) -> Result(r5.Deviceusage, Err) {
  any_update(
    resource.id,
    r5.deviceusage_to_json(resource),
    "DeviceUsage",
    r5.deviceusage_decoder(),
    client,
  )
}

pub fn deviceusage_delete(
  resource: r5.Deviceusage,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "DeviceUsage", client)
}

pub fn deviceusage_search(sp: r5_sansio.SpDeviceusage, client: FhirClient) {
  let req = r5_sansio.deviceusage_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn diagnosticreport_create(
  resource: r5.Diagnosticreport,
  client: FhirClient,
) -> Result(r5.Diagnosticreport, Err) {
  any_create(
    r5.diagnosticreport_to_json(resource),
    "DiagnosticReport",
    r5.diagnosticreport_decoder(),
    client,
  )
}

pub fn diagnosticreport_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Diagnosticreport, Err) {
  any_read(id, client, "DiagnosticReport", r5.diagnosticreport_decoder())
}

pub fn diagnosticreport_update(
  resource: r5.Diagnosticreport,
  client: FhirClient,
) -> Result(r5.Diagnosticreport, Err) {
  any_update(
    resource.id,
    r5.diagnosticreport_to_json(resource),
    "DiagnosticReport",
    r5.diagnosticreport_decoder(),
    client,
  )
}

pub fn diagnosticreport_delete(
  resource: r5.Diagnosticreport,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "DiagnosticReport", client)
}

pub fn diagnosticreport_search(
  sp: r5_sansio.SpDiagnosticreport,
  client: FhirClient,
) {
  let req = r5_sansio.diagnosticreport_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn documentreference_create(
  resource: r5.Documentreference,
  client: FhirClient,
) -> Result(r5.Documentreference, Err) {
  any_create(
    r5.documentreference_to_json(resource),
    "DocumentReference",
    r5.documentreference_decoder(),
    client,
  )
}

pub fn documentreference_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Documentreference, Err) {
  any_read(id, client, "DocumentReference", r5.documentreference_decoder())
}

pub fn documentreference_update(
  resource: r5.Documentreference,
  client: FhirClient,
) -> Result(r5.Documentreference, Err) {
  any_update(
    resource.id,
    r5.documentreference_to_json(resource),
    "DocumentReference",
    r5.documentreference_decoder(),
    client,
  )
}

pub fn documentreference_delete(
  resource: r5.Documentreference,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "DocumentReference", client)
}

pub fn documentreference_search(
  sp: r5_sansio.SpDocumentreference,
  client: FhirClient,
) {
  let req = r5_sansio.documentreference_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn encounter_create(
  resource: r5.Encounter,
  client: FhirClient,
) -> Result(r5.Encounter, Err) {
  any_create(
    r5.encounter_to_json(resource),
    "Encounter",
    r5.encounter_decoder(),
    client,
  )
}

pub fn encounter_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Encounter, Err) {
  any_read(id, client, "Encounter", r5.encounter_decoder())
}

pub fn encounter_update(
  resource: r5.Encounter,
  client: FhirClient,
) -> Result(r5.Encounter, Err) {
  any_update(
    resource.id,
    r5.encounter_to_json(resource),
    "Encounter",
    r5.encounter_decoder(),
    client,
  )
}

pub fn encounter_delete(
  resource: r5.Encounter,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Encounter", client)
}

pub fn encounter_search(sp: r5_sansio.SpEncounter, client: FhirClient) {
  let req = r5_sansio.encounter_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn encounterhistory_create(
  resource: r5.Encounterhistory,
  client: FhirClient,
) -> Result(r5.Encounterhistory, Err) {
  any_create(
    r5.encounterhistory_to_json(resource),
    "EncounterHistory",
    r5.encounterhistory_decoder(),
    client,
  )
}

pub fn encounterhistory_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Encounterhistory, Err) {
  any_read(id, client, "EncounterHistory", r5.encounterhistory_decoder())
}

pub fn encounterhistory_update(
  resource: r5.Encounterhistory,
  client: FhirClient,
) -> Result(r5.Encounterhistory, Err) {
  any_update(
    resource.id,
    r5.encounterhistory_to_json(resource),
    "EncounterHistory",
    r5.encounterhistory_decoder(),
    client,
  )
}

pub fn encounterhistory_delete(
  resource: r5.Encounterhistory,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "EncounterHistory", client)
}

pub fn encounterhistory_search(
  sp: r5_sansio.SpEncounterhistory,
  client: FhirClient,
) {
  let req = r5_sansio.encounterhistory_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn endpoint_create(
  resource: r5.Endpoint,
  client: FhirClient,
) -> Result(r5.Endpoint, Err) {
  any_create(
    r5.endpoint_to_json(resource),
    "Endpoint",
    r5.endpoint_decoder(),
    client,
  )
}

pub fn endpoint_read(id: String, client: FhirClient) -> Result(r5.Endpoint, Err) {
  any_read(id, client, "Endpoint", r5.endpoint_decoder())
}

pub fn endpoint_update(
  resource: r5.Endpoint,
  client: FhirClient,
) -> Result(r5.Endpoint, Err) {
  any_update(
    resource.id,
    r5.endpoint_to_json(resource),
    "Endpoint",
    r5.endpoint_decoder(),
    client,
  )
}

pub fn endpoint_delete(
  resource: r5.Endpoint,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Endpoint", client)
}

pub fn endpoint_search(sp: r5_sansio.SpEndpoint, client: FhirClient) {
  let req = r5_sansio.endpoint_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn enrollmentrequest_create(
  resource: r5.Enrollmentrequest,
  client: FhirClient,
) -> Result(r5.Enrollmentrequest, Err) {
  any_create(
    r5.enrollmentrequest_to_json(resource),
    "EnrollmentRequest",
    r5.enrollmentrequest_decoder(),
    client,
  )
}

pub fn enrollmentrequest_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Enrollmentrequest, Err) {
  any_read(id, client, "EnrollmentRequest", r5.enrollmentrequest_decoder())
}

pub fn enrollmentrequest_update(
  resource: r5.Enrollmentrequest,
  client: FhirClient,
) -> Result(r5.Enrollmentrequest, Err) {
  any_update(
    resource.id,
    r5.enrollmentrequest_to_json(resource),
    "EnrollmentRequest",
    r5.enrollmentrequest_decoder(),
    client,
  )
}

pub fn enrollmentrequest_delete(
  resource: r5.Enrollmentrequest,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "EnrollmentRequest", client)
}

pub fn enrollmentrequest_search(
  sp: r5_sansio.SpEnrollmentrequest,
  client: FhirClient,
) {
  let req = r5_sansio.enrollmentrequest_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn enrollmentresponse_create(
  resource: r5.Enrollmentresponse,
  client: FhirClient,
) -> Result(r5.Enrollmentresponse, Err) {
  any_create(
    r5.enrollmentresponse_to_json(resource),
    "EnrollmentResponse",
    r5.enrollmentresponse_decoder(),
    client,
  )
}

pub fn enrollmentresponse_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Enrollmentresponse, Err) {
  any_read(id, client, "EnrollmentResponse", r5.enrollmentresponse_decoder())
}

pub fn enrollmentresponse_update(
  resource: r5.Enrollmentresponse,
  client: FhirClient,
) -> Result(r5.Enrollmentresponse, Err) {
  any_update(
    resource.id,
    r5.enrollmentresponse_to_json(resource),
    "EnrollmentResponse",
    r5.enrollmentresponse_decoder(),
    client,
  )
}

pub fn enrollmentresponse_delete(
  resource: r5.Enrollmentresponse,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "EnrollmentResponse", client)
}

pub fn enrollmentresponse_search(
  sp: r5_sansio.SpEnrollmentresponse,
  client: FhirClient,
) {
  let req = r5_sansio.enrollmentresponse_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn episodeofcare_create(
  resource: r5.Episodeofcare,
  client: FhirClient,
) -> Result(r5.Episodeofcare, Err) {
  any_create(
    r5.episodeofcare_to_json(resource),
    "EpisodeOfCare",
    r5.episodeofcare_decoder(),
    client,
  )
}

pub fn episodeofcare_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Episodeofcare, Err) {
  any_read(id, client, "EpisodeOfCare", r5.episodeofcare_decoder())
}

pub fn episodeofcare_update(
  resource: r5.Episodeofcare,
  client: FhirClient,
) -> Result(r5.Episodeofcare, Err) {
  any_update(
    resource.id,
    r5.episodeofcare_to_json(resource),
    "EpisodeOfCare",
    r5.episodeofcare_decoder(),
    client,
  )
}

pub fn episodeofcare_delete(
  resource: r5.Episodeofcare,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "EpisodeOfCare", client)
}

pub fn episodeofcare_search(sp: r5_sansio.SpEpisodeofcare, client: FhirClient) {
  let req = r5_sansio.episodeofcare_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn eventdefinition_create(
  resource: r5.Eventdefinition,
  client: FhirClient,
) -> Result(r5.Eventdefinition, Err) {
  any_create(
    r5.eventdefinition_to_json(resource),
    "EventDefinition",
    r5.eventdefinition_decoder(),
    client,
  )
}

pub fn eventdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Eventdefinition, Err) {
  any_read(id, client, "EventDefinition", r5.eventdefinition_decoder())
}

pub fn eventdefinition_update(
  resource: r5.Eventdefinition,
  client: FhirClient,
) -> Result(r5.Eventdefinition, Err) {
  any_update(
    resource.id,
    r5.eventdefinition_to_json(resource),
    "EventDefinition",
    r5.eventdefinition_decoder(),
    client,
  )
}

pub fn eventdefinition_delete(
  resource: r5.Eventdefinition,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "EventDefinition", client)
}

pub fn eventdefinition_search(
  sp: r5_sansio.SpEventdefinition,
  client: FhirClient,
) {
  let req = r5_sansio.eventdefinition_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn evidence_create(
  resource: r5.Evidence,
  client: FhirClient,
) -> Result(r5.Evidence, Err) {
  any_create(
    r5.evidence_to_json(resource),
    "Evidence",
    r5.evidence_decoder(),
    client,
  )
}

pub fn evidence_read(id: String, client: FhirClient) -> Result(r5.Evidence, Err) {
  any_read(id, client, "Evidence", r5.evidence_decoder())
}

pub fn evidence_update(
  resource: r5.Evidence,
  client: FhirClient,
) -> Result(r5.Evidence, Err) {
  any_update(
    resource.id,
    r5.evidence_to_json(resource),
    "Evidence",
    r5.evidence_decoder(),
    client,
  )
}

pub fn evidence_delete(
  resource: r5.Evidence,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Evidence", client)
}

pub fn evidence_search(sp: r5_sansio.SpEvidence, client: FhirClient) {
  let req = r5_sansio.evidence_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn evidencereport_create(
  resource: r5.Evidencereport,
  client: FhirClient,
) -> Result(r5.Evidencereport, Err) {
  any_create(
    r5.evidencereport_to_json(resource),
    "EvidenceReport",
    r5.evidencereport_decoder(),
    client,
  )
}

pub fn evidencereport_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Evidencereport, Err) {
  any_read(id, client, "EvidenceReport", r5.evidencereport_decoder())
}

pub fn evidencereport_update(
  resource: r5.Evidencereport,
  client: FhirClient,
) -> Result(r5.Evidencereport, Err) {
  any_update(
    resource.id,
    r5.evidencereport_to_json(resource),
    "EvidenceReport",
    r5.evidencereport_decoder(),
    client,
  )
}

pub fn evidencereport_delete(
  resource: r5.Evidencereport,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "EvidenceReport", client)
}

pub fn evidencereport_search(sp: r5_sansio.SpEvidencereport, client: FhirClient) {
  let req = r5_sansio.evidencereport_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn evidencevariable_create(
  resource: r5.Evidencevariable,
  client: FhirClient,
) -> Result(r5.Evidencevariable, Err) {
  any_create(
    r5.evidencevariable_to_json(resource),
    "EvidenceVariable",
    r5.evidencevariable_decoder(),
    client,
  )
}

pub fn evidencevariable_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Evidencevariable, Err) {
  any_read(id, client, "EvidenceVariable", r5.evidencevariable_decoder())
}

pub fn evidencevariable_update(
  resource: r5.Evidencevariable,
  client: FhirClient,
) -> Result(r5.Evidencevariable, Err) {
  any_update(
    resource.id,
    r5.evidencevariable_to_json(resource),
    "EvidenceVariable",
    r5.evidencevariable_decoder(),
    client,
  )
}

pub fn evidencevariable_delete(
  resource: r5.Evidencevariable,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "EvidenceVariable", client)
}

pub fn evidencevariable_search(
  sp: r5_sansio.SpEvidencevariable,
  client: FhirClient,
) {
  let req = r5_sansio.evidencevariable_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn examplescenario_create(
  resource: r5.Examplescenario,
  client: FhirClient,
) -> Result(r5.Examplescenario, Err) {
  any_create(
    r5.examplescenario_to_json(resource),
    "ExampleScenario",
    r5.examplescenario_decoder(),
    client,
  )
}

pub fn examplescenario_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Examplescenario, Err) {
  any_read(id, client, "ExampleScenario", r5.examplescenario_decoder())
}

pub fn examplescenario_update(
  resource: r5.Examplescenario,
  client: FhirClient,
) -> Result(r5.Examplescenario, Err) {
  any_update(
    resource.id,
    r5.examplescenario_to_json(resource),
    "ExampleScenario",
    r5.examplescenario_decoder(),
    client,
  )
}

pub fn examplescenario_delete(
  resource: r5.Examplescenario,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "ExampleScenario", client)
}

pub fn examplescenario_search(
  sp: r5_sansio.SpExamplescenario,
  client: FhirClient,
) {
  let req = r5_sansio.examplescenario_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn explanationofbenefit_create(
  resource: r5.Explanationofbenefit,
  client: FhirClient,
) -> Result(r5.Explanationofbenefit, Err) {
  any_create(
    r5.explanationofbenefit_to_json(resource),
    "ExplanationOfBenefit",
    r5.explanationofbenefit_decoder(),
    client,
  )
}

pub fn explanationofbenefit_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Explanationofbenefit, Err) {
  any_read(
    id,
    client,
    "ExplanationOfBenefit",
    r5.explanationofbenefit_decoder(),
  )
}

pub fn explanationofbenefit_update(
  resource: r5.Explanationofbenefit,
  client: FhirClient,
) -> Result(r5.Explanationofbenefit, Err) {
  any_update(
    resource.id,
    r5.explanationofbenefit_to_json(resource),
    "ExplanationOfBenefit",
    r5.explanationofbenefit_decoder(),
    client,
  )
}

pub fn explanationofbenefit_delete(
  resource: r5.Explanationofbenefit,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "ExplanationOfBenefit", client)
}

pub fn explanationofbenefit_search(
  sp: r5_sansio.SpExplanationofbenefit,
  client: FhirClient,
) {
  let req = r5_sansio.explanationofbenefit_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn familymemberhistory_create(
  resource: r5.Familymemberhistory,
  client: FhirClient,
) -> Result(r5.Familymemberhistory, Err) {
  any_create(
    r5.familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    r5.familymemberhistory_decoder(),
    client,
  )
}

pub fn familymemberhistory_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Familymemberhistory, Err) {
  any_read(id, client, "FamilyMemberHistory", r5.familymemberhistory_decoder())
}

pub fn familymemberhistory_update(
  resource: r5.Familymemberhistory,
  client: FhirClient,
) -> Result(r5.Familymemberhistory, Err) {
  any_update(
    resource.id,
    r5.familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    r5.familymemberhistory_decoder(),
    client,
  )
}

pub fn familymemberhistory_delete(
  resource: r5.Familymemberhistory,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "FamilyMemberHistory", client)
}

pub fn familymemberhistory_search(
  sp: r5_sansio.SpFamilymemberhistory,
  client: FhirClient,
) {
  let req = r5_sansio.familymemberhistory_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn flag_create(
  resource: r5.Flag,
  client: FhirClient,
) -> Result(r5.Flag, Err) {
  any_create(r5.flag_to_json(resource), "Flag", r5.flag_decoder(), client)
}

pub fn flag_read(id: String, client: FhirClient) -> Result(r5.Flag, Err) {
  any_read(id, client, "Flag", r5.flag_decoder())
}

pub fn flag_update(
  resource: r5.Flag,
  client: FhirClient,
) -> Result(r5.Flag, Err) {
  any_update(
    resource.id,
    r5.flag_to_json(resource),
    "Flag",
    r5.flag_decoder(),
    client,
  )
}

pub fn flag_delete(
  resource: r5.Flag,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Flag", client)
}

pub fn flag_search(sp: r5_sansio.SpFlag, client: FhirClient) {
  let req = r5_sansio.flag_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn formularyitem_create(
  resource: r5.Formularyitem,
  client: FhirClient,
) -> Result(r5.Formularyitem, Err) {
  any_create(
    r5.formularyitem_to_json(resource),
    "FormularyItem",
    r5.formularyitem_decoder(),
    client,
  )
}

pub fn formularyitem_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Formularyitem, Err) {
  any_read(id, client, "FormularyItem", r5.formularyitem_decoder())
}

pub fn formularyitem_update(
  resource: r5.Formularyitem,
  client: FhirClient,
) -> Result(r5.Formularyitem, Err) {
  any_update(
    resource.id,
    r5.formularyitem_to_json(resource),
    "FormularyItem",
    r5.formularyitem_decoder(),
    client,
  )
}

pub fn formularyitem_delete(
  resource: r5.Formularyitem,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "FormularyItem", client)
}

pub fn formularyitem_search(sp: r5_sansio.SpFormularyitem, client: FhirClient) {
  let req = r5_sansio.formularyitem_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn genomicstudy_create(
  resource: r5.Genomicstudy,
  client: FhirClient,
) -> Result(r5.Genomicstudy, Err) {
  any_create(
    r5.genomicstudy_to_json(resource),
    "GenomicStudy",
    r5.genomicstudy_decoder(),
    client,
  )
}

pub fn genomicstudy_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Genomicstudy, Err) {
  any_read(id, client, "GenomicStudy", r5.genomicstudy_decoder())
}

pub fn genomicstudy_update(
  resource: r5.Genomicstudy,
  client: FhirClient,
) -> Result(r5.Genomicstudy, Err) {
  any_update(
    resource.id,
    r5.genomicstudy_to_json(resource),
    "GenomicStudy",
    r5.genomicstudy_decoder(),
    client,
  )
}

pub fn genomicstudy_delete(
  resource: r5.Genomicstudy,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "GenomicStudy", client)
}

pub fn genomicstudy_search(sp: r5_sansio.SpGenomicstudy, client: FhirClient) {
  let req = r5_sansio.genomicstudy_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn goal_create(
  resource: r5.Goal,
  client: FhirClient,
) -> Result(r5.Goal, Err) {
  any_create(r5.goal_to_json(resource), "Goal", r5.goal_decoder(), client)
}

pub fn goal_read(id: String, client: FhirClient) -> Result(r5.Goal, Err) {
  any_read(id, client, "Goal", r5.goal_decoder())
}

pub fn goal_update(
  resource: r5.Goal,
  client: FhirClient,
) -> Result(r5.Goal, Err) {
  any_update(
    resource.id,
    r5.goal_to_json(resource),
    "Goal",
    r5.goal_decoder(),
    client,
  )
}

pub fn goal_delete(
  resource: r5.Goal,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Goal", client)
}

pub fn goal_search(sp: r5_sansio.SpGoal, client: FhirClient) {
  let req = r5_sansio.goal_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn graphdefinition_create(
  resource: r5.Graphdefinition,
  client: FhirClient,
) -> Result(r5.Graphdefinition, Err) {
  any_create(
    r5.graphdefinition_to_json(resource),
    "GraphDefinition",
    r5.graphdefinition_decoder(),
    client,
  )
}

pub fn graphdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Graphdefinition, Err) {
  any_read(id, client, "GraphDefinition", r5.graphdefinition_decoder())
}

pub fn graphdefinition_update(
  resource: r5.Graphdefinition,
  client: FhirClient,
) -> Result(r5.Graphdefinition, Err) {
  any_update(
    resource.id,
    r5.graphdefinition_to_json(resource),
    "GraphDefinition",
    r5.graphdefinition_decoder(),
    client,
  )
}

pub fn graphdefinition_delete(
  resource: r5.Graphdefinition,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "GraphDefinition", client)
}

pub fn graphdefinition_search(
  sp: r5_sansio.SpGraphdefinition,
  client: FhirClient,
) {
  let req = r5_sansio.graphdefinition_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn group_create(
  resource: r5.Group,
  client: FhirClient,
) -> Result(r5.Group, Err) {
  any_create(r5.group_to_json(resource), "Group", r5.group_decoder(), client)
}

pub fn group_read(id: String, client: FhirClient) -> Result(r5.Group, Err) {
  any_read(id, client, "Group", r5.group_decoder())
}

pub fn group_update(
  resource: r5.Group,
  client: FhirClient,
) -> Result(r5.Group, Err) {
  any_update(
    resource.id,
    r5.group_to_json(resource),
    "Group",
    r5.group_decoder(),
    client,
  )
}

pub fn group_delete(
  resource: r5.Group,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Group", client)
}

pub fn group_search(sp: r5_sansio.SpGroup, client: FhirClient) {
  let req = r5_sansio.group_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn guidanceresponse_create(
  resource: r5.Guidanceresponse,
  client: FhirClient,
) -> Result(r5.Guidanceresponse, Err) {
  any_create(
    r5.guidanceresponse_to_json(resource),
    "GuidanceResponse",
    r5.guidanceresponse_decoder(),
    client,
  )
}

pub fn guidanceresponse_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Guidanceresponse, Err) {
  any_read(id, client, "GuidanceResponse", r5.guidanceresponse_decoder())
}

pub fn guidanceresponse_update(
  resource: r5.Guidanceresponse,
  client: FhirClient,
) -> Result(r5.Guidanceresponse, Err) {
  any_update(
    resource.id,
    r5.guidanceresponse_to_json(resource),
    "GuidanceResponse",
    r5.guidanceresponse_decoder(),
    client,
  )
}

pub fn guidanceresponse_delete(
  resource: r5.Guidanceresponse,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "GuidanceResponse", client)
}

pub fn guidanceresponse_search(
  sp: r5_sansio.SpGuidanceresponse,
  client: FhirClient,
) {
  let req = r5_sansio.guidanceresponse_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn healthcareservice_create(
  resource: r5.Healthcareservice,
  client: FhirClient,
) -> Result(r5.Healthcareservice, Err) {
  any_create(
    r5.healthcareservice_to_json(resource),
    "HealthcareService",
    r5.healthcareservice_decoder(),
    client,
  )
}

pub fn healthcareservice_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Healthcareservice, Err) {
  any_read(id, client, "HealthcareService", r5.healthcareservice_decoder())
}

pub fn healthcareservice_update(
  resource: r5.Healthcareservice,
  client: FhirClient,
) -> Result(r5.Healthcareservice, Err) {
  any_update(
    resource.id,
    r5.healthcareservice_to_json(resource),
    "HealthcareService",
    r5.healthcareservice_decoder(),
    client,
  )
}

pub fn healthcareservice_delete(
  resource: r5.Healthcareservice,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "HealthcareService", client)
}

pub fn healthcareservice_search(
  sp: r5_sansio.SpHealthcareservice,
  client: FhirClient,
) {
  let req = r5_sansio.healthcareservice_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn imagingselection_create(
  resource: r5.Imagingselection,
  client: FhirClient,
) -> Result(r5.Imagingselection, Err) {
  any_create(
    r5.imagingselection_to_json(resource),
    "ImagingSelection",
    r5.imagingselection_decoder(),
    client,
  )
}

pub fn imagingselection_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Imagingselection, Err) {
  any_read(id, client, "ImagingSelection", r5.imagingselection_decoder())
}

pub fn imagingselection_update(
  resource: r5.Imagingselection,
  client: FhirClient,
) -> Result(r5.Imagingselection, Err) {
  any_update(
    resource.id,
    r5.imagingselection_to_json(resource),
    "ImagingSelection",
    r5.imagingselection_decoder(),
    client,
  )
}

pub fn imagingselection_delete(
  resource: r5.Imagingselection,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "ImagingSelection", client)
}

pub fn imagingselection_search(
  sp: r5_sansio.SpImagingselection,
  client: FhirClient,
) {
  let req = r5_sansio.imagingselection_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn imagingstudy_create(
  resource: r5.Imagingstudy,
  client: FhirClient,
) -> Result(r5.Imagingstudy, Err) {
  any_create(
    r5.imagingstudy_to_json(resource),
    "ImagingStudy",
    r5.imagingstudy_decoder(),
    client,
  )
}

pub fn imagingstudy_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Imagingstudy, Err) {
  any_read(id, client, "ImagingStudy", r5.imagingstudy_decoder())
}

pub fn imagingstudy_update(
  resource: r5.Imagingstudy,
  client: FhirClient,
) -> Result(r5.Imagingstudy, Err) {
  any_update(
    resource.id,
    r5.imagingstudy_to_json(resource),
    "ImagingStudy",
    r5.imagingstudy_decoder(),
    client,
  )
}

pub fn imagingstudy_delete(
  resource: r5.Imagingstudy,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "ImagingStudy", client)
}

pub fn imagingstudy_search(sp: r5_sansio.SpImagingstudy, client: FhirClient) {
  let req = r5_sansio.imagingstudy_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn immunization_create(
  resource: r5.Immunization,
  client: FhirClient,
) -> Result(r5.Immunization, Err) {
  any_create(
    r5.immunization_to_json(resource),
    "Immunization",
    r5.immunization_decoder(),
    client,
  )
}

pub fn immunization_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Immunization, Err) {
  any_read(id, client, "Immunization", r5.immunization_decoder())
}

pub fn immunization_update(
  resource: r5.Immunization,
  client: FhirClient,
) -> Result(r5.Immunization, Err) {
  any_update(
    resource.id,
    r5.immunization_to_json(resource),
    "Immunization",
    r5.immunization_decoder(),
    client,
  )
}

pub fn immunization_delete(
  resource: r5.Immunization,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Immunization", client)
}

pub fn immunization_search(sp: r5_sansio.SpImmunization, client: FhirClient) {
  let req = r5_sansio.immunization_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn immunizationevaluation_create(
  resource: r5.Immunizationevaluation,
  client: FhirClient,
) -> Result(r5.Immunizationevaluation, Err) {
  any_create(
    r5.immunizationevaluation_to_json(resource),
    "ImmunizationEvaluation",
    r5.immunizationevaluation_decoder(),
    client,
  )
}

pub fn immunizationevaluation_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Immunizationevaluation, Err) {
  any_read(
    id,
    client,
    "ImmunizationEvaluation",
    r5.immunizationevaluation_decoder(),
  )
}

pub fn immunizationevaluation_update(
  resource: r5.Immunizationevaluation,
  client: FhirClient,
) -> Result(r5.Immunizationevaluation, Err) {
  any_update(
    resource.id,
    r5.immunizationevaluation_to_json(resource),
    "ImmunizationEvaluation",
    r5.immunizationevaluation_decoder(),
    client,
  )
}

pub fn immunizationevaluation_delete(
  resource: r5.Immunizationevaluation,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "ImmunizationEvaluation", client)
}

pub fn immunizationevaluation_search(
  sp: r5_sansio.SpImmunizationevaluation,
  client: FhirClient,
) {
  let req = r5_sansio.immunizationevaluation_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn immunizationrecommendation_create(
  resource: r5.Immunizationrecommendation,
  client: FhirClient,
) -> Result(r5.Immunizationrecommendation, Err) {
  any_create(
    r5.immunizationrecommendation_to_json(resource),
    "ImmunizationRecommendation",
    r5.immunizationrecommendation_decoder(),
    client,
  )
}

pub fn immunizationrecommendation_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Immunizationrecommendation, Err) {
  any_read(
    id,
    client,
    "ImmunizationRecommendation",
    r5.immunizationrecommendation_decoder(),
  )
}

pub fn immunizationrecommendation_update(
  resource: r5.Immunizationrecommendation,
  client: FhirClient,
) -> Result(r5.Immunizationrecommendation, Err) {
  any_update(
    resource.id,
    r5.immunizationrecommendation_to_json(resource),
    "ImmunizationRecommendation",
    r5.immunizationrecommendation_decoder(),
    client,
  )
}

pub fn immunizationrecommendation_delete(
  resource: r5.Immunizationrecommendation,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "ImmunizationRecommendation", client)
}

pub fn immunizationrecommendation_search(
  sp: r5_sansio.SpImmunizationrecommendation,
  client: FhirClient,
) {
  let req = r5_sansio.immunizationrecommendation_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn implementationguide_create(
  resource: r5.Implementationguide,
  client: FhirClient,
) -> Result(r5.Implementationguide, Err) {
  any_create(
    r5.implementationguide_to_json(resource),
    "ImplementationGuide",
    r5.implementationguide_decoder(),
    client,
  )
}

pub fn implementationguide_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Implementationguide, Err) {
  any_read(id, client, "ImplementationGuide", r5.implementationguide_decoder())
}

pub fn implementationguide_update(
  resource: r5.Implementationguide,
  client: FhirClient,
) -> Result(r5.Implementationguide, Err) {
  any_update(
    resource.id,
    r5.implementationguide_to_json(resource),
    "ImplementationGuide",
    r5.implementationguide_decoder(),
    client,
  )
}

pub fn implementationguide_delete(
  resource: r5.Implementationguide,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "ImplementationGuide", client)
}

pub fn implementationguide_search(
  sp: r5_sansio.SpImplementationguide,
  client: FhirClient,
) {
  let req = r5_sansio.implementationguide_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn ingredient_create(
  resource: r5.Ingredient,
  client: FhirClient,
) -> Result(r5.Ingredient, Err) {
  any_create(
    r5.ingredient_to_json(resource),
    "Ingredient",
    r5.ingredient_decoder(),
    client,
  )
}

pub fn ingredient_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Ingredient, Err) {
  any_read(id, client, "Ingredient", r5.ingredient_decoder())
}

pub fn ingredient_update(
  resource: r5.Ingredient,
  client: FhirClient,
) -> Result(r5.Ingredient, Err) {
  any_update(
    resource.id,
    r5.ingredient_to_json(resource),
    "Ingredient",
    r5.ingredient_decoder(),
    client,
  )
}

pub fn ingredient_delete(
  resource: r5.Ingredient,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Ingredient", client)
}

pub fn ingredient_search(sp: r5_sansio.SpIngredient, client: FhirClient) {
  let req = r5_sansio.ingredient_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn insuranceplan_create(
  resource: r5.Insuranceplan,
  client: FhirClient,
) -> Result(r5.Insuranceplan, Err) {
  any_create(
    r5.insuranceplan_to_json(resource),
    "InsurancePlan",
    r5.insuranceplan_decoder(),
    client,
  )
}

pub fn insuranceplan_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Insuranceplan, Err) {
  any_read(id, client, "InsurancePlan", r5.insuranceplan_decoder())
}

pub fn insuranceplan_update(
  resource: r5.Insuranceplan,
  client: FhirClient,
) -> Result(r5.Insuranceplan, Err) {
  any_update(
    resource.id,
    r5.insuranceplan_to_json(resource),
    "InsurancePlan",
    r5.insuranceplan_decoder(),
    client,
  )
}

pub fn insuranceplan_delete(
  resource: r5.Insuranceplan,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "InsurancePlan", client)
}

pub fn insuranceplan_search(sp: r5_sansio.SpInsuranceplan, client: FhirClient) {
  let req = r5_sansio.insuranceplan_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn inventoryitem_create(
  resource: r5.Inventoryitem,
  client: FhirClient,
) -> Result(r5.Inventoryitem, Err) {
  any_create(
    r5.inventoryitem_to_json(resource),
    "InventoryItem",
    r5.inventoryitem_decoder(),
    client,
  )
}

pub fn inventoryitem_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Inventoryitem, Err) {
  any_read(id, client, "InventoryItem", r5.inventoryitem_decoder())
}

pub fn inventoryitem_update(
  resource: r5.Inventoryitem,
  client: FhirClient,
) -> Result(r5.Inventoryitem, Err) {
  any_update(
    resource.id,
    r5.inventoryitem_to_json(resource),
    "InventoryItem",
    r5.inventoryitem_decoder(),
    client,
  )
}

pub fn inventoryitem_delete(
  resource: r5.Inventoryitem,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "InventoryItem", client)
}

pub fn inventoryitem_search(sp: r5_sansio.SpInventoryitem, client: FhirClient) {
  let req = r5_sansio.inventoryitem_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn inventoryreport_create(
  resource: r5.Inventoryreport,
  client: FhirClient,
) -> Result(r5.Inventoryreport, Err) {
  any_create(
    r5.inventoryreport_to_json(resource),
    "InventoryReport",
    r5.inventoryreport_decoder(),
    client,
  )
}

pub fn inventoryreport_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Inventoryreport, Err) {
  any_read(id, client, "InventoryReport", r5.inventoryreport_decoder())
}

pub fn inventoryreport_update(
  resource: r5.Inventoryreport,
  client: FhirClient,
) -> Result(r5.Inventoryreport, Err) {
  any_update(
    resource.id,
    r5.inventoryreport_to_json(resource),
    "InventoryReport",
    r5.inventoryreport_decoder(),
    client,
  )
}

pub fn inventoryreport_delete(
  resource: r5.Inventoryreport,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "InventoryReport", client)
}

pub fn inventoryreport_search(
  sp: r5_sansio.SpInventoryreport,
  client: FhirClient,
) {
  let req = r5_sansio.inventoryreport_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn invoice_create(
  resource: r5.Invoice,
  client: FhirClient,
) -> Result(r5.Invoice, Err) {
  any_create(
    r5.invoice_to_json(resource),
    "Invoice",
    r5.invoice_decoder(),
    client,
  )
}

pub fn invoice_read(id: String, client: FhirClient) -> Result(r5.Invoice, Err) {
  any_read(id, client, "Invoice", r5.invoice_decoder())
}

pub fn invoice_update(
  resource: r5.Invoice,
  client: FhirClient,
) -> Result(r5.Invoice, Err) {
  any_update(
    resource.id,
    r5.invoice_to_json(resource),
    "Invoice",
    r5.invoice_decoder(),
    client,
  )
}

pub fn invoice_delete(
  resource: r5.Invoice,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Invoice", client)
}

pub fn invoice_search(sp: r5_sansio.SpInvoice, client: FhirClient) {
  let req = r5_sansio.invoice_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn library_create(
  resource: r5.Library,
  client: FhirClient,
) -> Result(r5.Library, Err) {
  any_create(
    r5.library_to_json(resource),
    "Library",
    r5.library_decoder(),
    client,
  )
}

pub fn library_read(id: String, client: FhirClient) -> Result(r5.Library, Err) {
  any_read(id, client, "Library", r5.library_decoder())
}

pub fn library_update(
  resource: r5.Library,
  client: FhirClient,
) -> Result(r5.Library, Err) {
  any_update(
    resource.id,
    r5.library_to_json(resource),
    "Library",
    r5.library_decoder(),
    client,
  )
}

pub fn library_delete(
  resource: r5.Library,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Library", client)
}

pub fn library_search(sp: r5_sansio.SpLibrary, client: FhirClient) {
  let req = r5_sansio.library_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn linkage_create(
  resource: r5.Linkage,
  client: FhirClient,
) -> Result(r5.Linkage, Err) {
  any_create(
    r5.linkage_to_json(resource),
    "Linkage",
    r5.linkage_decoder(),
    client,
  )
}

pub fn linkage_read(id: String, client: FhirClient) -> Result(r5.Linkage, Err) {
  any_read(id, client, "Linkage", r5.linkage_decoder())
}

pub fn linkage_update(
  resource: r5.Linkage,
  client: FhirClient,
) -> Result(r5.Linkage, Err) {
  any_update(
    resource.id,
    r5.linkage_to_json(resource),
    "Linkage",
    r5.linkage_decoder(),
    client,
  )
}

pub fn linkage_delete(
  resource: r5.Linkage,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Linkage", client)
}

pub fn linkage_search(sp: r5_sansio.SpLinkage, client: FhirClient) {
  let req = r5_sansio.linkage_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn listfhir_create(
  resource: r5.Listfhir,
  client: FhirClient,
) -> Result(r5.Listfhir, Err) {
  any_create(
    r5.listfhir_to_json(resource),
    "List",
    r5.listfhir_decoder(),
    client,
  )
}

pub fn listfhir_read(id: String, client: FhirClient) -> Result(r5.Listfhir, Err) {
  any_read(id, client, "List", r5.listfhir_decoder())
}

pub fn listfhir_update(
  resource: r5.Listfhir,
  client: FhirClient,
) -> Result(r5.Listfhir, Err) {
  any_update(
    resource.id,
    r5.listfhir_to_json(resource),
    "List",
    r5.listfhir_decoder(),
    client,
  )
}

pub fn listfhir_delete(
  resource: r5.Listfhir,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "List", client)
}

pub fn listfhir_search(sp: r5_sansio.SpListfhir, client: FhirClient) {
  let req = r5_sansio.listfhir_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn location_create(
  resource: r5.Location,
  client: FhirClient,
) -> Result(r5.Location, Err) {
  any_create(
    r5.location_to_json(resource),
    "Location",
    r5.location_decoder(),
    client,
  )
}

pub fn location_read(id: String, client: FhirClient) -> Result(r5.Location, Err) {
  any_read(id, client, "Location", r5.location_decoder())
}

pub fn location_update(
  resource: r5.Location,
  client: FhirClient,
) -> Result(r5.Location, Err) {
  any_update(
    resource.id,
    r5.location_to_json(resource),
    "Location",
    r5.location_decoder(),
    client,
  )
}

pub fn location_delete(
  resource: r5.Location,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Location", client)
}

pub fn location_search(sp: r5_sansio.SpLocation, client: FhirClient) {
  let req = r5_sansio.location_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn manufactureditemdefinition_create(
  resource: r5.Manufactureditemdefinition,
  client: FhirClient,
) -> Result(r5.Manufactureditemdefinition, Err) {
  any_create(
    r5.manufactureditemdefinition_to_json(resource),
    "ManufacturedItemDefinition",
    r5.manufactureditemdefinition_decoder(),
    client,
  )
}

pub fn manufactureditemdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Manufactureditemdefinition, Err) {
  any_read(
    id,
    client,
    "ManufacturedItemDefinition",
    r5.manufactureditemdefinition_decoder(),
  )
}

pub fn manufactureditemdefinition_update(
  resource: r5.Manufactureditemdefinition,
  client: FhirClient,
) -> Result(r5.Manufactureditemdefinition, Err) {
  any_update(
    resource.id,
    r5.manufactureditemdefinition_to_json(resource),
    "ManufacturedItemDefinition",
    r5.manufactureditemdefinition_decoder(),
    client,
  )
}

pub fn manufactureditemdefinition_delete(
  resource: r5.Manufactureditemdefinition,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "ManufacturedItemDefinition", client)
}

pub fn manufactureditemdefinition_search(
  sp: r5_sansio.SpManufactureditemdefinition,
  client: FhirClient,
) {
  let req = r5_sansio.manufactureditemdefinition_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn measure_create(
  resource: r5.Measure,
  client: FhirClient,
) -> Result(r5.Measure, Err) {
  any_create(
    r5.measure_to_json(resource),
    "Measure",
    r5.measure_decoder(),
    client,
  )
}

pub fn measure_read(id: String, client: FhirClient) -> Result(r5.Measure, Err) {
  any_read(id, client, "Measure", r5.measure_decoder())
}

pub fn measure_update(
  resource: r5.Measure,
  client: FhirClient,
) -> Result(r5.Measure, Err) {
  any_update(
    resource.id,
    r5.measure_to_json(resource),
    "Measure",
    r5.measure_decoder(),
    client,
  )
}

pub fn measure_delete(
  resource: r5.Measure,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Measure", client)
}

pub fn measure_search(sp: r5_sansio.SpMeasure, client: FhirClient) {
  let req = r5_sansio.measure_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn measurereport_create(
  resource: r5.Measurereport,
  client: FhirClient,
) -> Result(r5.Measurereport, Err) {
  any_create(
    r5.measurereport_to_json(resource),
    "MeasureReport",
    r5.measurereport_decoder(),
    client,
  )
}

pub fn measurereport_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Measurereport, Err) {
  any_read(id, client, "MeasureReport", r5.measurereport_decoder())
}

pub fn measurereport_update(
  resource: r5.Measurereport,
  client: FhirClient,
) -> Result(r5.Measurereport, Err) {
  any_update(
    resource.id,
    r5.measurereport_to_json(resource),
    "MeasureReport",
    r5.measurereport_decoder(),
    client,
  )
}

pub fn measurereport_delete(
  resource: r5.Measurereport,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "MeasureReport", client)
}

pub fn measurereport_search(sp: r5_sansio.SpMeasurereport, client: FhirClient) {
  let req = r5_sansio.measurereport_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn medication_create(
  resource: r5.Medication,
  client: FhirClient,
) -> Result(r5.Medication, Err) {
  any_create(
    r5.medication_to_json(resource),
    "Medication",
    r5.medication_decoder(),
    client,
  )
}

pub fn medication_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Medication, Err) {
  any_read(id, client, "Medication", r5.medication_decoder())
}

pub fn medication_update(
  resource: r5.Medication,
  client: FhirClient,
) -> Result(r5.Medication, Err) {
  any_update(
    resource.id,
    r5.medication_to_json(resource),
    "Medication",
    r5.medication_decoder(),
    client,
  )
}

pub fn medication_delete(
  resource: r5.Medication,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Medication", client)
}

pub fn medication_search(sp: r5_sansio.SpMedication, client: FhirClient) {
  let req = r5_sansio.medication_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn medicationadministration_create(
  resource: r5.Medicationadministration,
  client: FhirClient,
) -> Result(r5.Medicationadministration, Err) {
  any_create(
    r5.medicationadministration_to_json(resource),
    "MedicationAdministration",
    r5.medicationadministration_decoder(),
    client,
  )
}

pub fn medicationadministration_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Medicationadministration, Err) {
  any_read(
    id,
    client,
    "MedicationAdministration",
    r5.medicationadministration_decoder(),
  )
}

pub fn medicationadministration_update(
  resource: r5.Medicationadministration,
  client: FhirClient,
) -> Result(r5.Medicationadministration, Err) {
  any_update(
    resource.id,
    r5.medicationadministration_to_json(resource),
    "MedicationAdministration",
    r5.medicationadministration_decoder(),
    client,
  )
}

pub fn medicationadministration_delete(
  resource: r5.Medicationadministration,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "MedicationAdministration", client)
}

pub fn medicationadministration_search(
  sp: r5_sansio.SpMedicationadministration,
  client: FhirClient,
) {
  let req = r5_sansio.medicationadministration_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn medicationdispense_create(
  resource: r5.Medicationdispense,
  client: FhirClient,
) -> Result(r5.Medicationdispense, Err) {
  any_create(
    r5.medicationdispense_to_json(resource),
    "MedicationDispense",
    r5.medicationdispense_decoder(),
    client,
  )
}

pub fn medicationdispense_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Medicationdispense, Err) {
  any_read(id, client, "MedicationDispense", r5.medicationdispense_decoder())
}

pub fn medicationdispense_update(
  resource: r5.Medicationdispense,
  client: FhirClient,
) -> Result(r5.Medicationdispense, Err) {
  any_update(
    resource.id,
    r5.medicationdispense_to_json(resource),
    "MedicationDispense",
    r5.medicationdispense_decoder(),
    client,
  )
}

pub fn medicationdispense_delete(
  resource: r5.Medicationdispense,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "MedicationDispense", client)
}

pub fn medicationdispense_search(
  sp: r5_sansio.SpMedicationdispense,
  client: FhirClient,
) {
  let req = r5_sansio.medicationdispense_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn medicationknowledge_create(
  resource: r5.Medicationknowledge,
  client: FhirClient,
) -> Result(r5.Medicationknowledge, Err) {
  any_create(
    r5.medicationknowledge_to_json(resource),
    "MedicationKnowledge",
    r5.medicationknowledge_decoder(),
    client,
  )
}

pub fn medicationknowledge_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Medicationknowledge, Err) {
  any_read(id, client, "MedicationKnowledge", r5.medicationknowledge_decoder())
}

pub fn medicationknowledge_update(
  resource: r5.Medicationknowledge,
  client: FhirClient,
) -> Result(r5.Medicationknowledge, Err) {
  any_update(
    resource.id,
    r5.medicationknowledge_to_json(resource),
    "MedicationKnowledge",
    r5.medicationknowledge_decoder(),
    client,
  )
}

pub fn medicationknowledge_delete(
  resource: r5.Medicationknowledge,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "MedicationKnowledge", client)
}

pub fn medicationknowledge_search(
  sp: r5_sansio.SpMedicationknowledge,
  client: FhirClient,
) {
  let req = r5_sansio.medicationknowledge_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn medicationrequest_create(
  resource: r5.Medicationrequest,
  client: FhirClient,
) -> Result(r5.Medicationrequest, Err) {
  any_create(
    r5.medicationrequest_to_json(resource),
    "MedicationRequest",
    r5.medicationrequest_decoder(),
    client,
  )
}

pub fn medicationrequest_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Medicationrequest, Err) {
  any_read(id, client, "MedicationRequest", r5.medicationrequest_decoder())
}

pub fn medicationrequest_update(
  resource: r5.Medicationrequest,
  client: FhirClient,
) -> Result(r5.Medicationrequest, Err) {
  any_update(
    resource.id,
    r5.medicationrequest_to_json(resource),
    "MedicationRequest",
    r5.medicationrequest_decoder(),
    client,
  )
}

pub fn medicationrequest_delete(
  resource: r5.Medicationrequest,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "MedicationRequest", client)
}

pub fn medicationrequest_search(
  sp: r5_sansio.SpMedicationrequest,
  client: FhirClient,
) {
  let req = r5_sansio.medicationrequest_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn medicationstatement_create(
  resource: r5.Medicationstatement,
  client: FhirClient,
) -> Result(r5.Medicationstatement, Err) {
  any_create(
    r5.medicationstatement_to_json(resource),
    "MedicationStatement",
    r5.medicationstatement_decoder(),
    client,
  )
}

pub fn medicationstatement_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Medicationstatement, Err) {
  any_read(id, client, "MedicationStatement", r5.medicationstatement_decoder())
}

pub fn medicationstatement_update(
  resource: r5.Medicationstatement,
  client: FhirClient,
) -> Result(r5.Medicationstatement, Err) {
  any_update(
    resource.id,
    r5.medicationstatement_to_json(resource),
    "MedicationStatement",
    r5.medicationstatement_decoder(),
    client,
  )
}

pub fn medicationstatement_delete(
  resource: r5.Medicationstatement,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "MedicationStatement", client)
}

pub fn medicationstatement_search(
  sp: r5_sansio.SpMedicationstatement,
  client: FhirClient,
) {
  let req = r5_sansio.medicationstatement_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn medicinalproductdefinition_create(
  resource: r5.Medicinalproductdefinition,
  client: FhirClient,
) -> Result(r5.Medicinalproductdefinition, Err) {
  any_create(
    r5.medicinalproductdefinition_to_json(resource),
    "MedicinalProductDefinition",
    r5.medicinalproductdefinition_decoder(),
    client,
  )
}

pub fn medicinalproductdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Medicinalproductdefinition, Err) {
  any_read(
    id,
    client,
    "MedicinalProductDefinition",
    r5.medicinalproductdefinition_decoder(),
  )
}

pub fn medicinalproductdefinition_update(
  resource: r5.Medicinalproductdefinition,
  client: FhirClient,
) -> Result(r5.Medicinalproductdefinition, Err) {
  any_update(
    resource.id,
    r5.medicinalproductdefinition_to_json(resource),
    "MedicinalProductDefinition",
    r5.medicinalproductdefinition_decoder(),
    client,
  )
}

pub fn medicinalproductdefinition_delete(
  resource: r5.Medicinalproductdefinition,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "MedicinalProductDefinition", client)
}

pub fn medicinalproductdefinition_search(
  sp: r5_sansio.SpMedicinalproductdefinition,
  client: FhirClient,
) {
  let req = r5_sansio.medicinalproductdefinition_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn messagedefinition_create(
  resource: r5.Messagedefinition,
  client: FhirClient,
) -> Result(r5.Messagedefinition, Err) {
  any_create(
    r5.messagedefinition_to_json(resource),
    "MessageDefinition",
    r5.messagedefinition_decoder(),
    client,
  )
}

pub fn messagedefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Messagedefinition, Err) {
  any_read(id, client, "MessageDefinition", r5.messagedefinition_decoder())
}

pub fn messagedefinition_update(
  resource: r5.Messagedefinition,
  client: FhirClient,
) -> Result(r5.Messagedefinition, Err) {
  any_update(
    resource.id,
    r5.messagedefinition_to_json(resource),
    "MessageDefinition",
    r5.messagedefinition_decoder(),
    client,
  )
}

pub fn messagedefinition_delete(
  resource: r5.Messagedefinition,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "MessageDefinition", client)
}

pub fn messagedefinition_search(
  sp: r5_sansio.SpMessagedefinition,
  client: FhirClient,
) {
  let req = r5_sansio.messagedefinition_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn messageheader_create(
  resource: r5.Messageheader,
  client: FhirClient,
) -> Result(r5.Messageheader, Err) {
  any_create(
    r5.messageheader_to_json(resource),
    "MessageHeader",
    r5.messageheader_decoder(),
    client,
  )
}

pub fn messageheader_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Messageheader, Err) {
  any_read(id, client, "MessageHeader", r5.messageheader_decoder())
}

pub fn messageheader_update(
  resource: r5.Messageheader,
  client: FhirClient,
) -> Result(r5.Messageheader, Err) {
  any_update(
    resource.id,
    r5.messageheader_to_json(resource),
    "MessageHeader",
    r5.messageheader_decoder(),
    client,
  )
}

pub fn messageheader_delete(
  resource: r5.Messageheader,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "MessageHeader", client)
}

pub fn messageheader_search(sp: r5_sansio.SpMessageheader, client: FhirClient) {
  let req = r5_sansio.messageheader_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn molecularsequence_create(
  resource: r5.Molecularsequence,
  client: FhirClient,
) -> Result(r5.Molecularsequence, Err) {
  any_create(
    r5.molecularsequence_to_json(resource),
    "MolecularSequence",
    r5.molecularsequence_decoder(),
    client,
  )
}

pub fn molecularsequence_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Molecularsequence, Err) {
  any_read(id, client, "MolecularSequence", r5.molecularsequence_decoder())
}

pub fn molecularsequence_update(
  resource: r5.Molecularsequence,
  client: FhirClient,
) -> Result(r5.Molecularsequence, Err) {
  any_update(
    resource.id,
    r5.molecularsequence_to_json(resource),
    "MolecularSequence",
    r5.molecularsequence_decoder(),
    client,
  )
}

pub fn molecularsequence_delete(
  resource: r5.Molecularsequence,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "MolecularSequence", client)
}

pub fn molecularsequence_search(
  sp: r5_sansio.SpMolecularsequence,
  client: FhirClient,
) {
  let req = r5_sansio.molecularsequence_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn namingsystem_create(
  resource: r5.Namingsystem,
  client: FhirClient,
) -> Result(r5.Namingsystem, Err) {
  any_create(
    r5.namingsystem_to_json(resource),
    "NamingSystem",
    r5.namingsystem_decoder(),
    client,
  )
}

pub fn namingsystem_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Namingsystem, Err) {
  any_read(id, client, "NamingSystem", r5.namingsystem_decoder())
}

pub fn namingsystem_update(
  resource: r5.Namingsystem,
  client: FhirClient,
) -> Result(r5.Namingsystem, Err) {
  any_update(
    resource.id,
    r5.namingsystem_to_json(resource),
    "NamingSystem",
    r5.namingsystem_decoder(),
    client,
  )
}

pub fn namingsystem_delete(
  resource: r5.Namingsystem,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "NamingSystem", client)
}

pub fn namingsystem_search(sp: r5_sansio.SpNamingsystem, client: FhirClient) {
  let req = r5_sansio.namingsystem_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn nutritionintake_create(
  resource: r5.Nutritionintake,
  client: FhirClient,
) -> Result(r5.Nutritionintake, Err) {
  any_create(
    r5.nutritionintake_to_json(resource),
    "NutritionIntake",
    r5.nutritionintake_decoder(),
    client,
  )
}

pub fn nutritionintake_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Nutritionintake, Err) {
  any_read(id, client, "NutritionIntake", r5.nutritionintake_decoder())
}

pub fn nutritionintake_update(
  resource: r5.Nutritionintake,
  client: FhirClient,
) -> Result(r5.Nutritionintake, Err) {
  any_update(
    resource.id,
    r5.nutritionintake_to_json(resource),
    "NutritionIntake",
    r5.nutritionintake_decoder(),
    client,
  )
}

pub fn nutritionintake_delete(
  resource: r5.Nutritionintake,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "NutritionIntake", client)
}

pub fn nutritionintake_search(
  sp: r5_sansio.SpNutritionintake,
  client: FhirClient,
) {
  let req = r5_sansio.nutritionintake_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn nutritionorder_create(
  resource: r5.Nutritionorder,
  client: FhirClient,
) -> Result(r5.Nutritionorder, Err) {
  any_create(
    r5.nutritionorder_to_json(resource),
    "NutritionOrder",
    r5.nutritionorder_decoder(),
    client,
  )
}

pub fn nutritionorder_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Nutritionorder, Err) {
  any_read(id, client, "NutritionOrder", r5.nutritionorder_decoder())
}

pub fn nutritionorder_update(
  resource: r5.Nutritionorder,
  client: FhirClient,
) -> Result(r5.Nutritionorder, Err) {
  any_update(
    resource.id,
    r5.nutritionorder_to_json(resource),
    "NutritionOrder",
    r5.nutritionorder_decoder(),
    client,
  )
}

pub fn nutritionorder_delete(
  resource: r5.Nutritionorder,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "NutritionOrder", client)
}

pub fn nutritionorder_search(sp: r5_sansio.SpNutritionorder, client: FhirClient) {
  let req = r5_sansio.nutritionorder_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn nutritionproduct_create(
  resource: r5.Nutritionproduct,
  client: FhirClient,
) -> Result(r5.Nutritionproduct, Err) {
  any_create(
    r5.nutritionproduct_to_json(resource),
    "NutritionProduct",
    r5.nutritionproduct_decoder(),
    client,
  )
}

pub fn nutritionproduct_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Nutritionproduct, Err) {
  any_read(id, client, "NutritionProduct", r5.nutritionproduct_decoder())
}

pub fn nutritionproduct_update(
  resource: r5.Nutritionproduct,
  client: FhirClient,
) -> Result(r5.Nutritionproduct, Err) {
  any_update(
    resource.id,
    r5.nutritionproduct_to_json(resource),
    "NutritionProduct",
    r5.nutritionproduct_decoder(),
    client,
  )
}

pub fn nutritionproduct_delete(
  resource: r5.Nutritionproduct,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "NutritionProduct", client)
}

pub fn nutritionproduct_search(
  sp: r5_sansio.SpNutritionproduct,
  client: FhirClient,
) {
  let req = r5_sansio.nutritionproduct_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn observation_create(
  resource: r5.Observation,
  client: FhirClient,
) -> Result(r5.Observation, Err) {
  any_create(
    r5.observation_to_json(resource),
    "Observation",
    r5.observation_decoder(),
    client,
  )
}

pub fn observation_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Observation, Err) {
  any_read(id, client, "Observation", r5.observation_decoder())
}

pub fn observation_update(
  resource: r5.Observation,
  client: FhirClient,
) -> Result(r5.Observation, Err) {
  any_update(
    resource.id,
    r5.observation_to_json(resource),
    "Observation",
    r5.observation_decoder(),
    client,
  )
}

pub fn observation_delete(
  resource: r5.Observation,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Observation", client)
}

pub fn observation_search(sp: r5_sansio.SpObservation, client: FhirClient) {
  let req = r5_sansio.observation_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn observationdefinition_create(
  resource: r5.Observationdefinition,
  client: FhirClient,
) -> Result(r5.Observationdefinition, Err) {
  any_create(
    r5.observationdefinition_to_json(resource),
    "ObservationDefinition",
    r5.observationdefinition_decoder(),
    client,
  )
}

pub fn observationdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Observationdefinition, Err) {
  any_read(
    id,
    client,
    "ObservationDefinition",
    r5.observationdefinition_decoder(),
  )
}

pub fn observationdefinition_update(
  resource: r5.Observationdefinition,
  client: FhirClient,
) -> Result(r5.Observationdefinition, Err) {
  any_update(
    resource.id,
    r5.observationdefinition_to_json(resource),
    "ObservationDefinition",
    r5.observationdefinition_decoder(),
    client,
  )
}

pub fn observationdefinition_delete(
  resource: r5.Observationdefinition,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "ObservationDefinition", client)
}

pub fn observationdefinition_search(
  sp: r5_sansio.SpObservationdefinition,
  client: FhirClient,
) {
  let req = r5_sansio.observationdefinition_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn operationdefinition_create(
  resource: r5.Operationdefinition,
  client: FhirClient,
) -> Result(r5.Operationdefinition, Err) {
  any_create(
    r5.operationdefinition_to_json(resource),
    "OperationDefinition",
    r5.operationdefinition_decoder(),
    client,
  )
}

pub fn operationdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Operationdefinition, Err) {
  any_read(id, client, "OperationDefinition", r5.operationdefinition_decoder())
}

pub fn operationdefinition_update(
  resource: r5.Operationdefinition,
  client: FhirClient,
) -> Result(r5.Operationdefinition, Err) {
  any_update(
    resource.id,
    r5.operationdefinition_to_json(resource),
    "OperationDefinition",
    r5.operationdefinition_decoder(),
    client,
  )
}

pub fn operationdefinition_delete(
  resource: r5.Operationdefinition,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "OperationDefinition", client)
}

pub fn operationdefinition_search(
  sp: r5_sansio.SpOperationdefinition,
  client: FhirClient,
) {
  let req = r5_sansio.operationdefinition_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn operationoutcome_create(
  resource: r5.Operationoutcome,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_create(
    r5.operationoutcome_to_json(resource),
    "OperationOutcome",
    r5.operationoutcome_decoder(),
    client,
  )
}

pub fn operationoutcome_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_read(id, client, "OperationOutcome", r5.operationoutcome_decoder())
}

pub fn operationoutcome_update(
  resource: r5.Operationoutcome,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_update(
    resource.id,
    r5.operationoutcome_to_json(resource),
    "OperationOutcome",
    r5.operationoutcome_decoder(),
    client,
  )
}

pub fn operationoutcome_delete(
  resource: r5.Operationoutcome,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "OperationOutcome", client)
}

pub fn operationoutcome_search(
  sp: r5_sansio.SpOperationoutcome,
  client: FhirClient,
) {
  let req = r5_sansio.operationoutcome_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn organization_create(
  resource: r5.Organization,
  client: FhirClient,
) -> Result(r5.Organization, Err) {
  any_create(
    r5.organization_to_json(resource),
    "Organization",
    r5.organization_decoder(),
    client,
  )
}

pub fn organization_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Organization, Err) {
  any_read(id, client, "Organization", r5.organization_decoder())
}

pub fn organization_update(
  resource: r5.Organization,
  client: FhirClient,
) -> Result(r5.Organization, Err) {
  any_update(
    resource.id,
    r5.organization_to_json(resource),
    "Organization",
    r5.organization_decoder(),
    client,
  )
}

pub fn organization_delete(
  resource: r5.Organization,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Organization", client)
}

pub fn organization_search(sp: r5_sansio.SpOrganization, client: FhirClient) {
  let req = r5_sansio.organization_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn organizationaffiliation_create(
  resource: r5.Organizationaffiliation,
  client: FhirClient,
) -> Result(r5.Organizationaffiliation, Err) {
  any_create(
    r5.organizationaffiliation_to_json(resource),
    "OrganizationAffiliation",
    r5.organizationaffiliation_decoder(),
    client,
  )
}

pub fn organizationaffiliation_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Organizationaffiliation, Err) {
  any_read(
    id,
    client,
    "OrganizationAffiliation",
    r5.organizationaffiliation_decoder(),
  )
}

pub fn organizationaffiliation_update(
  resource: r5.Organizationaffiliation,
  client: FhirClient,
) -> Result(r5.Organizationaffiliation, Err) {
  any_update(
    resource.id,
    r5.organizationaffiliation_to_json(resource),
    "OrganizationAffiliation",
    r5.organizationaffiliation_decoder(),
    client,
  )
}

pub fn organizationaffiliation_delete(
  resource: r5.Organizationaffiliation,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "OrganizationAffiliation", client)
}

pub fn organizationaffiliation_search(
  sp: r5_sansio.SpOrganizationaffiliation,
  client: FhirClient,
) {
  let req = r5_sansio.organizationaffiliation_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn packagedproductdefinition_create(
  resource: r5.Packagedproductdefinition,
  client: FhirClient,
) -> Result(r5.Packagedproductdefinition, Err) {
  any_create(
    r5.packagedproductdefinition_to_json(resource),
    "PackagedProductDefinition",
    r5.packagedproductdefinition_decoder(),
    client,
  )
}

pub fn packagedproductdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Packagedproductdefinition, Err) {
  any_read(
    id,
    client,
    "PackagedProductDefinition",
    r5.packagedproductdefinition_decoder(),
  )
}

pub fn packagedproductdefinition_update(
  resource: r5.Packagedproductdefinition,
  client: FhirClient,
) -> Result(r5.Packagedproductdefinition, Err) {
  any_update(
    resource.id,
    r5.packagedproductdefinition_to_json(resource),
    "PackagedProductDefinition",
    r5.packagedproductdefinition_decoder(),
    client,
  )
}

pub fn packagedproductdefinition_delete(
  resource: r5.Packagedproductdefinition,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "PackagedProductDefinition", client)
}

pub fn packagedproductdefinition_search(
  sp: r5_sansio.SpPackagedproductdefinition,
  client: FhirClient,
) {
  let req = r5_sansio.packagedproductdefinition_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn patient_create(
  resource: r5.Patient,
  client: FhirClient,
) -> Result(r5.Patient, Err) {
  any_create(
    r5.patient_to_json(resource),
    "Patient",
    r5.patient_decoder(),
    client,
  )
}

pub fn patient_read(id: String, client: FhirClient) -> Result(r5.Patient, Err) {
  any_read(id, client, "Patient", r5.patient_decoder())
}

pub fn patient_update(
  resource: r5.Patient,
  client: FhirClient,
) -> Result(r5.Patient, Err) {
  any_update(
    resource.id,
    r5.patient_to_json(resource),
    "Patient",
    r5.patient_decoder(),
    client,
  )
}

pub fn patient_delete(
  resource: r5.Patient,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Patient", client)
}

pub fn patient_search(sp: r5_sansio.SpPatient, client: FhirClient) {
  let req = r5_sansio.patient_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn paymentnotice_create(
  resource: r5.Paymentnotice,
  client: FhirClient,
) -> Result(r5.Paymentnotice, Err) {
  any_create(
    r5.paymentnotice_to_json(resource),
    "PaymentNotice",
    r5.paymentnotice_decoder(),
    client,
  )
}

pub fn paymentnotice_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Paymentnotice, Err) {
  any_read(id, client, "PaymentNotice", r5.paymentnotice_decoder())
}

pub fn paymentnotice_update(
  resource: r5.Paymentnotice,
  client: FhirClient,
) -> Result(r5.Paymentnotice, Err) {
  any_update(
    resource.id,
    r5.paymentnotice_to_json(resource),
    "PaymentNotice",
    r5.paymentnotice_decoder(),
    client,
  )
}

pub fn paymentnotice_delete(
  resource: r5.Paymentnotice,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "PaymentNotice", client)
}

pub fn paymentnotice_search(sp: r5_sansio.SpPaymentnotice, client: FhirClient) {
  let req = r5_sansio.paymentnotice_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn paymentreconciliation_create(
  resource: r5.Paymentreconciliation,
  client: FhirClient,
) -> Result(r5.Paymentreconciliation, Err) {
  any_create(
    r5.paymentreconciliation_to_json(resource),
    "PaymentReconciliation",
    r5.paymentreconciliation_decoder(),
    client,
  )
}

pub fn paymentreconciliation_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Paymentreconciliation, Err) {
  any_read(
    id,
    client,
    "PaymentReconciliation",
    r5.paymentreconciliation_decoder(),
  )
}

pub fn paymentreconciliation_update(
  resource: r5.Paymentreconciliation,
  client: FhirClient,
) -> Result(r5.Paymentreconciliation, Err) {
  any_update(
    resource.id,
    r5.paymentreconciliation_to_json(resource),
    "PaymentReconciliation",
    r5.paymentreconciliation_decoder(),
    client,
  )
}

pub fn paymentreconciliation_delete(
  resource: r5.Paymentreconciliation,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "PaymentReconciliation", client)
}

pub fn paymentreconciliation_search(
  sp: r5_sansio.SpPaymentreconciliation,
  client: FhirClient,
) {
  let req = r5_sansio.paymentreconciliation_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn permission_create(
  resource: r5.Permission,
  client: FhirClient,
) -> Result(r5.Permission, Err) {
  any_create(
    r5.permission_to_json(resource),
    "Permission",
    r5.permission_decoder(),
    client,
  )
}

pub fn permission_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Permission, Err) {
  any_read(id, client, "Permission", r5.permission_decoder())
}

pub fn permission_update(
  resource: r5.Permission,
  client: FhirClient,
) -> Result(r5.Permission, Err) {
  any_update(
    resource.id,
    r5.permission_to_json(resource),
    "Permission",
    r5.permission_decoder(),
    client,
  )
}

pub fn permission_delete(
  resource: r5.Permission,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Permission", client)
}

pub fn permission_search(sp: r5_sansio.SpPermission, client: FhirClient) {
  let req = r5_sansio.permission_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn person_create(
  resource: r5.Person,
  client: FhirClient,
) -> Result(r5.Person, Err) {
  any_create(r5.person_to_json(resource), "Person", r5.person_decoder(), client)
}

pub fn person_read(id: String, client: FhirClient) -> Result(r5.Person, Err) {
  any_read(id, client, "Person", r5.person_decoder())
}

pub fn person_update(
  resource: r5.Person,
  client: FhirClient,
) -> Result(r5.Person, Err) {
  any_update(
    resource.id,
    r5.person_to_json(resource),
    "Person",
    r5.person_decoder(),
    client,
  )
}

pub fn person_delete(
  resource: r5.Person,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Person", client)
}

pub fn person_search(sp: r5_sansio.SpPerson, client: FhirClient) {
  let req = r5_sansio.person_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn plandefinition_create(
  resource: r5.Plandefinition,
  client: FhirClient,
) -> Result(r5.Plandefinition, Err) {
  any_create(
    r5.plandefinition_to_json(resource),
    "PlanDefinition",
    r5.plandefinition_decoder(),
    client,
  )
}

pub fn plandefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Plandefinition, Err) {
  any_read(id, client, "PlanDefinition", r5.plandefinition_decoder())
}

pub fn plandefinition_update(
  resource: r5.Plandefinition,
  client: FhirClient,
) -> Result(r5.Plandefinition, Err) {
  any_update(
    resource.id,
    r5.plandefinition_to_json(resource),
    "PlanDefinition",
    r5.plandefinition_decoder(),
    client,
  )
}

pub fn plandefinition_delete(
  resource: r5.Plandefinition,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "PlanDefinition", client)
}

pub fn plandefinition_search(sp: r5_sansio.SpPlandefinition, client: FhirClient) {
  let req = r5_sansio.plandefinition_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn practitioner_create(
  resource: r5.Practitioner,
  client: FhirClient,
) -> Result(r5.Practitioner, Err) {
  any_create(
    r5.practitioner_to_json(resource),
    "Practitioner",
    r5.practitioner_decoder(),
    client,
  )
}

pub fn practitioner_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Practitioner, Err) {
  any_read(id, client, "Practitioner", r5.practitioner_decoder())
}

pub fn practitioner_update(
  resource: r5.Practitioner,
  client: FhirClient,
) -> Result(r5.Practitioner, Err) {
  any_update(
    resource.id,
    r5.practitioner_to_json(resource),
    "Practitioner",
    r5.practitioner_decoder(),
    client,
  )
}

pub fn practitioner_delete(
  resource: r5.Practitioner,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Practitioner", client)
}

pub fn practitioner_search(sp: r5_sansio.SpPractitioner, client: FhirClient) {
  let req = r5_sansio.practitioner_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn practitionerrole_create(
  resource: r5.Practitionerrole,
  client: FhirClient,
) -> Result(r5.Practitionerrole, Err) {
  any_create(
    r5.practitionerrole_to_json(resource),
    "PractitionerRole",
    r5.practitionerrole_decoder(),
    client,
  )
}

pub fn practitionerrole_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Practitionerrole, Err) {
  any_read(id, client, "PractitionerRole", r5.practitionerrole_decoder())
}

pub fn practitionerrole_update(
  resource: r5.Practitionerrole,
  client: FhirClient,
) -> Result(r5.Practitionerrole, Err) {
  any_update(
    resource.id,
    r5.practitionerrole_to_json(resource),
    "PractitionerRole",
    r5.practitionerrole_decoder(),
    client,
  )
}

pub fn practitionerrole_delete(
  resource: r5.Practitionerrole,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "PractitionerRole", client)
}

pub fn practitionerrole_search(
  sp: r5_sansio.SpPractitionerrole,
  client: FhirClient,
) {
  let req = r5_sansio.practitionerrole_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn procedure_create(
  resource: r5.Procedure,
  client: FhirClient,
) -> Result(r5.Procedure, Err) {
  any_create(
    r5.procedure_to_json(resource),
    "Procedure",
    r5.procedure_decoder(),
    client,
  )
}

pub fn procedure_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Procedure, Err) {
  any_read(id, client, "Procedure", r5.procedure_decoder())
}

pub fn procedure_update(
  resource: r5.Procedure,
  client: FhirClient,
) -> Result(r5.Procedure, Err) {
  any_update(
    resource.id,
    r5.procedure_to_json(resource),
    "Procedure",
    r5.procedure_decoder(),
    client,
  )
}

pub fn procedure_delete(
  resource: r5.Procedure,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Procedure", client)
}

pub fn procedure_search(sp: r5_sansio.SpProcedure, client: FhirClient) {
  let req = r5_sansio.procedure_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn provenance_create(
  resource: r5.Provenance,
  client: FhirClient,
) -> Result(r5.Provenance, Err) {
  any_create(
    r5.provenance_to_json(resource),
    "Provenance",
    r5.provenance_decoder(),
    client,
  )
}

pub fn provenance_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Provenance, Err) {
  any_read(id, client, "Provenance", r5.provenance_decoder())
}

pub fn provenance_update(
  resource: r5.Provenance,
  client: FhirClient,
) -> Result(r5.Provenance, Err) {
  any_update(
    resource.id,
    r5.provenance_to_json(resource),
    "Provenance",
    r5.provenance_decoder(),
    client,
  )
}

pub fn provenance_delete(
  resource: r5.Provenance,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Provenance", client)
}

pub fn provenance_search(sp: r5_sansio.SpProvenance, client: FhirClient) {
  let req = r5_sansio.provenance_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn questionnaire_create(
  resource: r5.Questionnaire,
  client: FhirClient,
) -> Result(r5.Questionnaire, Err) {
  any_create(
    r5.questionnaire_to_json(resource),
    "Questionnaire",
    r5.questionnaire_decoder(),
    client,
  )
}

pub fn questionnaire_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Questionnaire, Err) {
  any_read(id, client, "Questionnaire", r5.questionnaire_decoder())
}

pub fn questionnaire_update(
  resource: r5.Questionnaire,
  client: FhirClient,
) -> Result(r5.Questionnaire, Err) {
  any_update(
    resource.id,
    r5.questionnaire_to_json(resource),
    "Questionnaire",
    r5.questionnaire_decoder(),
    client,
  )
}

pub fn questionnaire_delete(
  resource: r5.Questionnaire,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Questionnaire", client)
}

pub fn questionnaire_search(sp: r5_sansio.SpQuestionnaire, client: FhirClient) {
  let req = r5_sansio.questionnaire_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn questionnaireresponse_create(
  resource: r5.Questionnaireresponse,
  client: FhirClient,
) -> Result(r5.Questionnaireresponse, Err) {
  any_create(
    r5.questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    r5.questionnaireresponse_decoder(),
    client,
  )
}

pub fn questionnaireresponse_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Questionnaireresponse, Err) {
  any_read(
    id,
    client,
    "QuestionnaireResponse",
    r5.questionnaireresponse_decoder(),
  )
}

pub fn questionnaireresponse_update(
  resource: r5.Questionnaireresponse,
  client: FhirClient,
) -> Result(r5.Questionnaireresponse, Err) {
  any_update(
    resource.id,
    r5.questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    r5.questionnaireresponse_decoder(),
    client,
  )
}

pub fn questionnaireresponse_delete(
  resource: r5.Questionnaireresponse,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "QuestionnaireResponse", client)
}

pub fn questionnaireresponse_search(
  sp: r5_sansio.SpQuestionnaireresponse,
  client: FhirClient,
) {
  let req = r5_sansio.questionnaireresponse_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn regulatedauthorization_create(
  resource: r5.Regulatedauthorization,
  client: FhirClient,
) -> Result(r5.Regulatedauthorization, Err) {
  any_create(
    r5.regulatedauthorization_to_json(resource),
    "RegulatedAuthorization",
    r5.regulatedauthorization_decoder(),
    client,
  )
}

pub fn regulatedauthorization_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Regulatedauthorization, Err) {
  any_read(
    id,
    client,
    "RegulatedAuthorization",
    r5.regulatedauthorization_decoder(),
  )
}

pub fn regulatedauthorization_update(
  resource: r5.Regulatedauthorization,
  client: FhirClient,
) -> Result(r5.Regulatedauthorization, Err) {
  any_update(
    resource.id,
    r5.regulatedauthorization_to_json(resource),
    "RegulatedAuthorization",
    r5.regulatedauthorization_decoder(),
    client,
  )
}

pub fn regulatedauthorization_delete(
  resource: r5.Regulatedauthorization,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "RegulatedAuthorization", client)
}

pub fn regulatedauthorization_search(
  sp: r5_sansio.SpRegulatedauthorization,
  client: FhirClient,
) {
  let req = r5_sansio.regulatedauthorization_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn relatedperson_create(
  resource: r5.Relatedperson,
  client: FhirClient,
) -> Result(r5.Relatedperson, Err) {
  any_create(
    r5.relatedperson_to_json(resource),
    "RelatedPerson",
    r5.relatedperson_decoder(),
    client,
  )
}

pub fn relatedperson_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Relatedperson, Err) {
  any_read(id, client, "RelatedPerson", r5.relatedperson_decoder())
}

pub fn relatedperson_update(
  resource: r5.Relatedperson,
  client: FhirClient,
) -> Result(r5.Relatedperson, Err) {
  any_update(
    resource.id,
    r5.relatedperson_to_json(resource),
    "RelatedPerson",
    r5.relatedperson_decoder(),
    client,
  )
}

pub fn relatedperson_delete(
  resource: r5.Relatedperson,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "RelatedPerson", client)
}

pub fn relatedperson_search(sp: r5_sansio.SpRelatedperson, client: FhirClient) {
  let req = r5_sansio.relatedperson_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn requestorchestration_create(
  resource: r5.Requestorchestration,
  client: FhirClient,
) -> Result(r5.Requestorchestration, Err) {
  any_create(
    r5.requestorchestration_to_json(resource),
    "RequestOrchestration",
    r5.requestorchestration_decoder(),
    client,
  )
}

pub fn requestorchestration_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Requestorchestration, Err) {
  any_read(
    id,
    client,
    "RequestOrchestration",
    r5.requestorchestration_decoder(),
  )
}

pub fn requestorchestration_update(
  resource: r5.Requestorchestration,
  client: FhirClient,
) -> Result(r5.Requestorchestration, Err) {
  any_update(
    resource.id,
    r5.requestorchestration_to_json(resource),
    "RequestOrchestration",
    r5.requestorchestration_decoder(),
    client,
  )
}

pub fn requestorchestration_delete(
  resource: r5.Requestorchestration,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "RequestOrchestration", client)
}

pub fn requestorchestration_search(
  sp: r5_sansio.SpRequestorchestration,
  client: FhirClient,
) {
  let req = r5_sansio.requestorchestration_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn requirements_create(
  resource: r5.Requirements,
  client: FhirClient,
) -> Result(r5.Requirements, Err) {
  any_create(
    r5.requirements_to_json(resource),
    "Requirements",
    r5.requirements_decoder(),
    client,
  )
}

pub fn requirements_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Requirements, Err) {
  any_read(id, client, "Requirements", r5.requirements_decoder())
}

pub fn requirements_update(
  resource: r5.Requirements,
  client: FhirClient,
) -> Result(r5.Requirements, Err) {
  any_update(
    resource.id,
    r5.requirements_to_json(resource),
    "Requirements",
    r5.requirements_decoder(),
    client,
  )
}

pub fn requirements_delete(
  resource: r5.Requirements,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Requirements", client)
}

pub fn requirements_search(sp: r5_sansio.SpRequirements, client: FhirClient) {
  let req = r5_sansio.requirements_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn researchstudy_create(
  resource: r5.Researchstudy,
  client: FhirClient,
) -> Result(r5.Researchstudy, Err) {
  any_create(
    r5.researchstudy_to_json(resource),
    "ResearchStudy",
    r5.researchstudy_decoder(),
    client,
  )
}

pub fn researchstudy_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Researchstudy, Err) {
  any_read(id, client, "ResearchStudy", r5.researchstudy_decoder())
}

pub fn researchstudy_update(
  resource: r5.Researchstudy,
  client: FhirClient,
) -> Result(r5.Researchstudy, Err) {
  any_update(
    resource.id,
    r5.researchstudy_to_json(resource),
    "ResearchStudy",
    r5.researchstudy_decoder(),
    client,
  )
}

pub fn researchstudy_delete(
  resource: r5.Researchstudy,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "ResearchStudy", client)
}

pub fn researchstudy_search(sp: r5_sansio.SpResearchstudy, client: FhirClient) {
  let req = r5_sansio.researchstudy_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn researchsubject_create(
  resource: r5.Researchsubject,
  client: FhirClient,
) -> Result(r5.Researchsubject, Err) {
  any_create(
    r5.researchsubject_to_json(resource),
    "ResearchSubject",
    r5.researchsubject_decoder(),
    client,
  )
}

pub fn researchsubject_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Researchsubject, Err) {
  any_read(id, client, "ResearchSubject", r5.researchsubject_decoder())
}

pub fn researchsubject_update(
  resource: r5.Researchsubject,
  client: FhirClient,
) -> Result(r5.Researchsubject, Err) {
  any_update(
    resource.id,
    r5.researchsubject_to_json(resource),
    "ResearchSubject",
    r5.researchsubject_decoder(),
    client,
  )
}

pub fn researchsubject_delete(
  resource: r5.Researchsubject,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "ResearchSubject", client)
}

pub fn researchsubject_search(
  sp: r5_sansio.SpResearchsubject,
  client: FhirClient,
) {
  let req = r5_sansio.researchsubject_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn riskassessment_create(
  resource: r5.Riskassessment,
  client: FhirClient,
) -> Result(r5.Riskassessment, Err) {
  any_create(
    r5.riskassessment_to_json(resource),
    "RiskAssessment",
    r5.riskassessment_decoder(),
    client,
  )
}

pub fn riskassessment_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Riskassessment, Err) {
  any_read(id, client, "RiskAssessment", r5.riskassessment_decoder())
}

pub fn riskassessment_update(
  resource: r5.Riskassessment,
  client: FhirClient,
) -> Result(r5.Riskassessment, Err) {
  any_update(
    resource.id,
    r5.riskassessment_to_json(resource),
    "RiskAssessment",
    r5.riskassessment_decoder(),
    client,
  )
}

pub fn riskassessment_delete(
  resource: r5.Riskassessment,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "RiskAssessment", client)
}

pub fn riskassessment_search(sp: r5_sansio.SpRiskassessment, client: FhirClient) {
  let req = r5_sansio.riskassessment_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn schedule_create(
  resource: r5.Schedule,
  client: FhirClient,
) -> Result(r5.Schedule, Err) {
  any_create(
    r5.schedule_to_json(resource),
    "Schedule",
    r5.schedule_decoder(),
    client,
  )
}

pub fn schedule_read(id: String, client: FhirClient) -> Result(r5.Schedule, Err) {
  any_read(id, client, "Schedule", r5.schedule_decoder())
}

pub fn schedule_update(
  resource: r5.Schedule,
  client: FhirClient,
) -> Result(r5.Schedule, Err) {
  any_update(
    resource.id,
    r5.schedule_to_json(resource),
    "Schedule",
    r5.schedule_decoder(),
    client,
  )
}

pub fn schedule_delete(
  resource: r5.Schedule,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Schedule", client)
}

pub fn schedule_search(sp: r5_sansio.SpSchedule, client: FhirClient) {
  let req = r5_sansio.schedule_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn searchparameter_create(
  resource: r5.Searchparameter,
  client: FhirClient,
) -> Result(r5.Searchparameter, Err) {
  any_create(
    r5.searchparameter_to_json(resource),
    "SearchParameter",
    r5.searchparameter_decoder(),
    client,
  )
}

pub fn searchparameter_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Searchparameter, Err) {
  any_read(id, client, "SearchParameter", r5.searchparameter_decoder())
}

pub fn searchparameter_update(
  resource: r5.Searchparameter,
  client: FhirClient,
) -> Result(r5.Searchparameter, Err) {
  any_update(
    resource.id,
    r5.searchparameter_to_json(resource),
    "SearchParameter",
    r5.searchparameter_decoder(),
    client,
  )
}

pub fn searchparameter_delete(
  resource: r5.Searchparameter,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "SearchParameter", client)
}

pub fn searchparameter_search(
  sp: r5_sansio.SpSearchparameter,
  client: FhirClient,
) {
  let req = r5_sansio.searchparameter_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn servicerequest_create(
  resource: r5.Servicerequest,
  client: FhirClient,
) -> Result(r5.Servicerequest, Err) {
  any_create(
    r5.servicerequest_to_json(resource),
    "ServiceRequest",
    r5.servicerequest_decoder(),
    client,
  )
}

pub fn servicerequest_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Servicerequest, Err) {
  any_read(id, client, "ServiceRequest", r5.servicerequest_decoder())
}

pub fn servicerequest_update(
  resource: r5.Servicerequest,
  client: FhirClient,
) -> Result(r5.Servicerequest, Err) {
  any_update(
    resource.id,
    r5.servicerequest_to_json(resource),
    "ServiceRequest",
    r5.servicerequest_decoder(),
    client,
  )
}

pub fn servicerequest_delete(
  resource: r5.Servicerequest,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "ServiceRequest", client)
}

pub fn servicerequest_search(sp: r5_sansio.SpServicerequest, client: FhirClient) {
  let req = r5_sansio.servicerequest_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn slot_create(
  resource: r5.Slot,
  client: FhirClient,
) -> Result(r5.Slot, Err) {
  any_create(r5.slot_to_json(resource), "Slot", r5.slot_decoder(), client)
}

pub fn slot_read(id: String, client: FhirClient) -> Result(r5.Slot, Err) {
  any_read(id, client, "Slot", r5.slot_decoder())
}

pub fn slot_update(
  resource: r5.Slot,
  client: FhirClient,
) -> Result(r5.Slot, Err) {
  any_update(
    resource.id,
    r5.slot_to_json(resource),
    "Slot",
    r5.slot_decoder(),
    client,
  )
}

pub fn slot_delete(
  resource: r5.Slot,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Slot", client)
}

pub fn slot_search(sp: r5_sansio.SpSlot, client: FhirClient) {
  let req = r5_sansio.slot_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn specimen_create(
  resource: r5.Specimen,
  client: FhirClient,
) -> Result(r5.Specimen, Err) {
  any_create(
    r5.specimen_to_json(resource),
    "Specimen",
    r5.specimen_decoder(),
    client,
  )
}

pub fn specimen_read(id: String, client: FhirClient) -> Result(r5.Specimen, Err) {
  any_read(id, client, "Specimen", r5.specimen_decoder())
}

pub fn specimen_update(
  resource: r5.Specimen,
  client: FhirClient,
) -> Result(r5.Specimen, Err) {
  any_update(
    resource.id,
    r5.specimen_to_json(resource),
    "Specimen",
    r5.specimen_decoder(),
    client,
  )
}

pub fn specimen_delete(
  resource: r5.Specimen,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Specimen", client)
}

pub fn specimen_search(sp: r5_sansio.SpSpecimen, client: FhirClient) {
  let req = r5_sansio.specimen_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn specimendefinition_create(
  resource: r5.Specimendefinition,
  client: FhirClient,
) -> Result(r5.Specimendefinition, Err) {
  any_create(
    r5.specimendefinition_to_json(resource),
    "SpecimenDefinition",
    r5.specimendefinition_decoder(),
    client,
  )
}

pub fn specimendefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Specimendefinition, Err) {
  any_read(id, client, "SpecimenDefinition", r5.specimendefinition_decoder())
}

pub fn specimendefinition_update(
  resource: r5.Specimendefinition,
  client: FhirClient,
) -> Result(r5.Specimendefinition, Err) {
  any_update(
    resource.id,
    r5.specimendefinition_to_json(resource),
    "SpecimenDefinition",
    r5.specimendefinition_decoder(),
    client,
  )
}

pub fn specimendefinition_delete(
  resource: r5.Specimendefinition,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "SpecimenDefinition", client)
}

pub fn specimendefinition_search(
  sp: r5_sansio.SpSpecimendefinition,
  client: FhirClient,
) {
  let req = r5_sansio.specimendefinition_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn structuredefinition_create(
  resource: r5.Structuredefinition,
  client: FhirClient,
) -> Result(r5.Structuredefinition, Err) {
  any_create(
    r5.structuredefinition_to_json(resource),
    "StructureDefinition",
    r5.structuredefinition_decoder(),
    client,
  )
}

pub fn structuredefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Structuredefinition, Err) {
  any_read(id, client, "StructureDefinition", r5.structuredefinition_decoder())
}

pub fn structuredefinition_update(
  resource: r5.Structuredefinition,
  client: FhirClient,
) -> Result(r5.Structuredefinition, Err) {
  any_update(
    resource.id,
    r5.structuredefinition_to_json(resource),
    "StructureDefinition",
    r5.structuredefinition_decoder(),
    client,
  )
}

pub fn structuredefinition_delete(
  resource: r5.Structuredefinition,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "StructureDefinition", client)
}

pub fn structuredefinition_search(
  sp: r5_sansio.SpStructuredefinition,
  client: FhirClient,
) {
  let req = r5_sansio.structuredefinition_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn structuremap_create(
  resource: r5.Structuremap,
  client: FhirClient,
) -> Result(r5.Structuremap, Err) {
  any_create(
    r5.structuremap_to_json(resource),
    "StructureMap",
    r5.structuremap_decoder(),
    client,
  )
}

pub fn structuremap_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Structuremap, Err) {
  any_read(id, client, "StructureMap", r5.structuremap_decoder())
}

pub fn structuremap_update(
  resource: r5.Structuremap,
  client: FhirClient,
) -> Result(r5.Structuremap, Err) {
  any_update(
    resource.id,
    r5.structuremap_to_json(resource),
    "StructureMap",
    r5.structuremap_decoder(),
    client,
  )
}

pub fn structuremap_delete(
  resource: r5.Structuremap,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "StructureMap", client)
}

pub fn structuremap_search(sp: r5_sansio.SpStructuremap, client: FhirClient) {
  let req = r5_sansio.structuremap_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn subscription_create(
  resource: r5.Subscription,
  client: FhirClient,
) -> Result(r5.Subscription, Err) {
  any_create(
    r5.subscription_to_json(resource),
    "Subscription",
    r5.subscription_decoder(),
    client,
  )
}

pub fn subscription_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Subscription, Err) {
  any_read(id, client, "Subscription", r5.subscription_decoder())
}

pub fn subscription_update(
  resource: r5.Subscription,
  client: FhirClient,
) -> Result(r5.Subscription, Err) {
  any_update(
    resource.id,
    r5.subscription_to_json(resource),
    "Subscription",
    r5.subscription_decoder(),
    client,
  )
}

pub fn subscription_delete(
  resource: r5.Subscription,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Subscription", client)
}

pub fn subscription_search(sp: r5_sansio.SpSubscription, client: FhirClient) {
  let req = r5_sansio.subscription_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn subscriptionstatus_create(
  resource: r5.Subscriptionstatus,
  client: FhirClient,
) -> Result(r5.Subscriptionstatus, Err) {
  any_create(
    r5.subscriptionstatus_to_json(resource),
    "SubscriptionStatus",
    r5.subscriptionstatus_decoder(),
    client,
  )
}

pub fn subscriptionstatus_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Subscriptionstatus, Err) {
  any_read(id, client, "SubscriptionStatus", r5.subscriptionstatus_decoder())
}

pub fn subscriptionstatus_update(
  resource: r5.Subscriptionstatus,
  client: FhirClient,
) -> Result(r5.Subscriptionstatus, Err) {
  any_update(
    resource.id,
    r5.subscriptionstatus_to_json(resource),
    "SubscriptionStatus",
    r5.subscriptionstatus_decoder(),
    client,
  )
}

pub fn subscriptionstatus_delete(
  resource: r5.Subscriptionstatus,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "SubscriptionStatus", client)
}

pub fn subscriptionstatus_search(
  sp: r5_sansio.SpSubscriptionstatus,
  client: FhirClient,
) {
  let req = r5_sansio.subscriptionstatus_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn subscriptiontopic_create(
  resource: r5.Subscriptiontopic,
  client: FhirClient,
) -> Result(r5.Subscriptiontopic, Err) {
  any_create(
    r5.subscriptiontopic_to_json(resource),
    "SubscriptionTopic",
    r5.subscriptiontopic_decoder(),
    client,
  )
}

pub fn subscriptiontopic_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Subscriptiontopic, Err) {
  any_read(id, client, "SubscriptionTopic", r5.subscriptiontopic_decoder())
}

pub fn subscriptiontopic_update(
  resource: r5.Subscriptiontopic,
  client: FhirClient,
) -> Result(r5.Subscriptiontopic, Err) {
  any_update(
    resource.id,
    r5.subscriptiontopic_to_json(resource),
    "SubscriptionTopic",
    r5.subscriptiontopic_decoder(),
    client,
  )
}

pub fn subscriptiontopic_delete(
  resource: r5.Subscriptiontopic,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "SubscriptionTopic", client)
}

pub fn subscriptiontopic_search(
  sp: r5_sansio.SpSubscriptiontopic,
  client: FhirClient,
) {
  let req = r5_sansio.subscriptiontopic_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn substance_create(
  resource: r5.Substance,
  client: FhirClient,
) -> Result(r5.Substance, Err) {
  any_create(
    r5.substance_to_json(resource),
    "Substance",
    r5.substance_decoder(),
    client,
  )
}

pub fn substance_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Substance, Err) {
  any_read(id, client, "Substance", r5.substance_decoder())
}

pub fn substance_update(
  resource: r5.Substance,
  client: FhirClient,
) -> Result(r5.Substance, Err) {
  any_update(
    resource.id,
    r5.substance_to_json(resource),
    "Substance",
    r5.substance_decoder(),
    client,
  )
}

pub fn substance_delete(
  resource: r5.Substance,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Substance", client)
}

pub fn substance_search(sp: r5_sansio.SpSubstance, client: FhirClient) {
  let req = r5_sansio.substance_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn substancedefinition_create(
  resource: r5.Substancedefinition,
  client: FhirClient,
) -> Result(r5.Substancedefinition, Err) {
  any_create(
    r5.substancedefinition_to_json(resource),
    "SubstanceDefinition",
    r5.substancedefinition_decoder(),
    client,
  )
}

pub fn substancedefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Substancedefinition, Err) {
  any_read(id, client, "SubstanceDefinition", r5.substancedefinition_decoder())
}

pub fn substancedefinition_update(
  resource: r5.Substancedefinition,
  client: FhirClient,
) -> Result(r5.Substancedefinition, Err) {
  any_update(
    resource.id,
    r5.substancedefinition_to_json(resource),
    "SubstanceDefinition",
    r5.substancedefinition_decoder(),
    client,
  )
}

pub fn substancedefinition_delete(
  resource: r5.Substancedefinition,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "SubstanceDefinition", client)
}

pub fn substancedefinition_search(
  sp: r5_sansio.SpSubstancedefinition,
  client: FhirClient,
) {
  let req = r5_sansio.substancedefinition_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn substancenucleicacid_create(
  resource: r5.Substancenucleicacid,
  client: FhirClient,
) -> Result(r5.Substancenucleicacid, Err) {
  any_create(
    r5.substancenucleicacid_to_json(resource),
    "SubstanceNucleicAcid",
    r5.substancenucleicacid_decoder(),
    client,
  )
}

pub fn substancenucleicacid_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Substancenucleicacid, Err) {
  any_read(
    id,
    client,
    "SubstanceNucleicAcid",
    r5.substancenucleicacid_decoder(),
  )
}

pub fn substancenucleicacid_update(
  resource: r5.Substancenucleicacid,
  client: FhirClient,
) -> Result(r5.Substancenucleicacid, Err) {
  any_update(
    resource.id,
    r5.substancenucleicacid_to_json(resource),
    "SubstanceNucleicAcid",
    r5.substancenucleicacid_decoder(),
    client,
  )
}

pub fn substancenucleicacid_delete(
  resource: r5.Substancenucleicacid,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "SubstanceNucleicAcid", client)
}

pub fn substancenucleicacid_search(
  sp: r5_sansio.SpSubstancenucleicacid,
  client: FhirClient,
) {
  let req = r5_sansio.substancenucleicacid_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn substancepolymer_create(
  resource: r5.Substancepolymer,
  client: FhirClient,
) -> Result(r5.Substancepolymer, Err) {
  any_create(
    r5.substancepolymer_to_json(resource),
    "SubstancePolymer",
    r5.substancepolymer_decoder(),
    client,
  )
}

pub fn substancepolymer_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Substancepolymer, Err) {
  any_read(id, client, "SubstancePolymer", r5.substancepolymer_decoder())
}

pub fn substancepolymer_update(
  resource: r5.Substancepolymer,
  client: FhirClient,
) -> Result(r5.Substancepolymer, Err) {
  any_update(
    resource.id,
    r5.substancepolymer_to_json(resource),
    "SubstancePolymer",
    r5.substancepolymer_decoder(),
    client,
  )
}

pub fn substancepolymer_delete(
  resource: r5.Substancepolymer,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "SubstancePolymer", client)
}

pub fn substancepolymer_search(
  sp: r5_sansio.SpSubstancepolymer,
  client: FhirClient,
) {
  let req = r5_sansio.substancepolymer_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn substanceprotein_create(
  resource: r5.Substanceprotein,
  client: FhirClient,
) -> Result(r5.Substanceprotein, Err) {
  any_create(
    r5.substanceprotein_to_json(resource),
    "SubstanceProtein",
    r5.substanceprotein_decoder(),
    client,
  )
}

pub fn substanceprotein_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Substanceprotein, Err) {
  any_read(id, client, "SubstanceProtein", r5.substanceprotein_decoder())
}

pub fn substanceprotein_update(
  resource: r5.Substanceprotein,
  client: FhirClient,
) -> Result(r5.Substanceprotein, Err) {
  any_update(
    resource.id,
    r5.substanceprotein_to_json(resource),
    "SubstanceProtein",
    r5.substanceprotein_decoder(),
    client,
  )
}

pub fn substanceprotein_delete(
  resource: r5.Substanceprotein,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "SubstanceProtein", client)
}

pub fn substanceprotein_search(
  sp: r5_sansio.SpSubstanceprotein,
  client: FhirClient,
) {
  let req = r5_sansio.substanceprotein_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn substancereferenceinformation_create(
  resource: r5.Substancereferenceinformation,
  client: FhirClient,
) -> Result(r5.Substancereferenceinformation, Err) {
  any_create(
    r5.substancereferenceinformation_to_json(resource),
    "SubstanceReferenceInformation",
    r5.substancereferenceinformation_decoder(),
    client,
  )
}

pub fn substancereferenceinformation_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Substancereferenceinformation, Err) {
  any_read(
    id,
    client,
    "SubstanceReferenceInformation",
    r5.substancereferenceinformation_decoder(),
  )
}

pub fn substancereferenceinformation_update(
  resource: r5.Substancereferenceinformation,
  client: FhirClient,
) -> Result(r5.Substancereferenceinformation, Err) {
  any_update(
    resource.id,
    r5.substancereferenceinformation_to_json(resource),
    "SubstanceReferenceInformation",
    r5.substancereferenceinformation_decoder(),
    client,
  )
}

pub fn substancereferenceinformation_delete(
  resource: r5.Substancereferenceinformation,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "SubstanceReferenceInformation", client)
}

pub fn substancereferenceinformation_search(
  sp: r5_sansio.SpSubstancereferenceinformation,
  client: FhirClient,
) {
  let req = r5_sansio.substancereferenceinformation_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn substancesourcematerial_create(
  resource: r5.Substancesourcematerial,
  client: FhirClient,
) -> Result(r5.Substancesourcematerial, Err) {
  any_create(
    r5.substancesourcematerial_to_json(resource),
    "SubstanceSourceMaterial",
    r5.substancesourcematerial_decoder(),
    client,
  )
}

pub fn substancesourcematerial_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Substancesourcematerial, Err) {
  any_read(
    id,
    client,
    "SubstanceSourceMaterial",
    r5.substancesourcematerial_decoder(),
  )
}

pub fn substancesourcematerial_update(
  resource: r5.Substancesourcematerial,
  client: FhirClient,
) -> Result(r5.Substancesourcematerial, Err) {
  any_update(
    resource.id,
    r5.substancesourcematerial_to_json(resource),
    "SubstanceSourceMaterial",
    r5.substancesourcematerial_decoder(),
    client,
  )
}

pub fn substancesourcematerial_delete(
  resource: r5.Substancesourcematerial,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "SubstanceSourceMaterial", client)
}

pub fn substancesourcematerial_search(
  sp: r5_sansio.SpSubstancesourcematerial,
  client: FhirClient,
) {
  let req = r5_sansio.substancesourcematerial_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn supplydelivery_create(
  resource: r5.Supplydelivery,
  client: FhirClient,
) -> Result(r5.Supplydelivery, Err) {
  any_create(
    r5.supplydelivery_to_json(resource),
    "SupplyDelivery",
    r5.supplydelivery_decoder(),
    client,
  )
}

pub fn supplydelivery_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Supplydelivery, Err) {
  any_read(id, client, "SupplyDelivery", r5.supplydelivery_decoder())
}

pub fn supplydelivery_update(
  resource: r5.Supplydelivery,
  client: FhirClient,
) -> Result(r5.Supplydelivery, Err) {
  any_update(
    resource.id,
    r5.supplydelivery_to_json(resource),
    "SupplyDelivery",
    r5.supplydelivery_decoder(),
    client,
  )
}

pub fn supplydelivery_delete(
  resource: r5.Supplydelivery,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "SupplyDelivery", client)
}

pub fn supplydelivery_search(sp: r5_sansio.SpSupplydelivery, client: FhirClient) {
  let req = r5_sansio.supplydelivery_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn supplyrequest_create(
  resource: r5.Supplyrequest,
  client: FhirClient,
) -> Result(r5.Supplyrequest, Err) {
  any_create(
    r5.supplyrequest_to_json(resource),
    "SupplyRequest",
    r5.supplyrequest_decoder(),
    client,
  )
}

pub fn supplyrequest_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Supplyrequest, Err) {
  any_read(id, client, "SupplyRequest", r5.supplyrequest_decoder())
}

pub fn supplyrequest_update(
  resource: r5.Supplyrequest,
  client: FhirClient,
) -> Result(r5.Supplyrequest, Err) {
  any_update(
    resource.id,
    r5.supplyrequest_to_json(resource),
    "SupplyRequest",
    r5.supplyrequest_decoder(),
    client,
  )
}

pub fn supplyrequest_delete(
  resource: r5.Supplyrequest,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "SupplyRequest", client)
}

pub fn supplyrequest_search(sp: r5_sansio.SpSupplyrequest, client: FhirClient) {
  let req = r5_sansio.supplyrequest_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn task_create(
  resource: r5.Task,
  client: FhirClient,
) -> Result(r5.Task, Err) {
  any_create(r5.task_to_json(resource), "Task", r5.task_decoder(), client)
}

pub fn task_read(id: String, client: FhirClient) -> Result(r5.Task, Err) {
  any_read(id, client, "Task", r5.task_decoder())
}

pub fn task_update(
  resource: r5.Task,
  client: FhirClient,
) -> Result(r5.Task, Err) {
  any_update(
    resource.id,
    r5.task_to_json(resource),
    "Task",
    r5.task_decoder(),
    client,
  )
}

pub fn task_delete(
  resource: r5.Task,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Task", client)
}

pub fn task_search(sp: r5_sansio.SpTask, client: FhirClient) {
  let req = r5_sansio.task_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn terminologycapabilities_create(
  resource: r5.Terminologycapabilities,
  client: FhirClient,
) -> Result(r5.Terminologycapabilities, Err) {
  any_create(
    r5.terminologycapabilities_to_json(resource),
    "TerminologyCapabilities",
    r5.terminologycapabilities_decoder(),
    client,
  )
}

pub fn terminologycapabilities_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Terminologycapabilities, Err) {
  any_read(
    id,
    client,
    "TerminologyCapabilities",
    r5.terminologycapabilities_decoder(),
  )
}

pub fn terminologycapabilities_update(
  resource: r5.Terminologycapabilities,
  client: FhirClient,
) -> Result(r5.Terminologycapabilities, Err) {
  any_update(
    resource.id,
    r5.terminologycapabilities_to_json(resource),
    "TerminologyCapabilities",
    r5.terminologycapabilities_decoder(),
    client,
  )
}

pub fn terminologycapabilities_delete(
  resource: r5.Terminologycapabilities,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "TerminologyCapabilities", client)
}

pub fn terminologycapabilities_search(
  sp: r5_sansio.SpTerminologycapabilities,
  client: FhirClient,
) {
  let req = r5_sansio.terminologycapabilities_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn testplan_create(
  resource: r5.Testplan,
  client: FhirClient,
) -> Result(r5.Testplan, Err) {
  any_create(
    r5.testplan_to_json(resource),
    "TestPlan",
    r5.testplan_decoder(),
    client,
  )
}

pub fn testplan_read(id: String, client: FhirClient) -> Result(r5.Testplan, Err) {
  any_read(id, client, "TestPlan", r5.testplan_decoder())
}

pub fn testplan_update(
  resource: r5.Testplan,
  client: FhirClient,
) -> Result(r5.Testplan, Err) {
  any_update(
    resource.id,
    r5.testplan_to_json(resource),
    "TestPlan",
    r5.testplan_decoder(),
    client,
  )
}

pub fn testplan_delete(
  resource: r5.Testplan,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "TestPlan", client)
}

pub fn testplan_search(sp: r5_sansio.SpTestplan, client: FhirClient) {
  let req = r5_sansio.testplan_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn testreport_create(
  resource: r5.Testreport,
  client: FhirClient,
) -> Result(r5.Testreport, Err) {
  any_create(
    r5.testreport_to_json(resource),
    "TestReport",
    r5.testreport_decoder(),
    client,
  )
}

pub fn testreport_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Testreport, Err) {
  any_read(id, client, "TestReport", r5.testreport_decoder())
}

pub fn testreport_update(
  resource: r5.Testreport,
  client: FhirClient,
) -> Result(r5.Testreport, Err) {
  any_update(
    resource.id,
    r5.testreport_to_json(resource),
    "TestReport",
    r5.testreport_decoder(),
    client,
  )
}

pub fn testreport_delete(
  resource: r5.Testreport,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "TestReport", client)
}

pub fn testreport_search(sp: r5_sansio.SpTestreport, client: FhirClient) {
  let req = r5_sansio.testreport_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn testscript_create(
  resource: r5.Testscript,
  client: FhirClient,
) -> Result(r5.Testscript, Err) {
  any_create(
    r5.testscript_to_json(resource),
    "TestScript",
    r5.testscript_decoder(),
    client,
  )
}

pub fn testscript_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Testscript, Err) {
  any_read(id, client, "TestScript", r5.testscript_decoder())
}

pub fn testscript_update(
  resource: r5.Testscript,
  client: FhirClient,
) -> Result(r5.Testscript, Err) {
  any_update(
    resource.id,
    r5.testscript_to_json(resource),
    "TestScript",
    r5.testscript_decoder(),
    client,
  )
}

pub fn testscript_delete(
  resource: r5.Testscript,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "TestScript", client)
}

pub fn testscript_search(sp: r5_sansio.SpTestscript, client: FhirClient) {
  let req = r5_sansio.testscript_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn transport_create(
  resource: r5.Transport,
  client: FhirClient,
) -> Result(r5.Transport, Err) {
  any_create(
    r5.transport_to_json(resource),
    "Transport",
    r5.transport_decoder(),
    client,
  )
}

pub fn transport_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Transport, Err) {
  any_read(id, client, "Transport", r5.transport_decoder())
}

pub fn transport_update(
  resource: r5.Transport,
  client: FhirClient,
) -> Result(r5.Transport, Err) {
  any_update(
    resource.id,
    r5.transport_to_json(resource),
    "Transport",
    r5.transport_decoder(),
    client,
  )
}

pub fn transport_delete(
  resource: r5.Transport,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "Transport", client)
}

pub fn transport_search(sp: r5_sansio.SpTransport, client: FhirClient) {
  let req = r5_sansio.transport_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn valueset_create(
  resource: r5.Valueset,
  client: FhirClient,
) -> Result(r5.Valueset, Err) {
  any_create(
    r5.valueset_to_json(resource),
    "ValueSet",
    r5.valueset_decoder(),
    client,
  )
}

pub fn valueset_read(id: String, client: FhirClient) -> Result(r5.Valueset, Err) {
  any_read(id, client, "ValueSet", r5.valueset_decoder())
}

pub fn valueset_update(
  resource: r5.Valueset,
  client: FhirClient,
) -> Result(r5.Valueset, Err) {
  any_update(
    resource.id,
    r5.valueset_to_json(resource),
    "ValueSet",
    r5.valueset_decoder(),
    client,
  )
}

pub fn valueset_delete(
  resource: r5.Valueset,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "ValueSet", client)
}

pub fn valueset_search(sp: r5_sansio.SpValueset, client: FhirClient) {
  let req = r5_sansio.valueset_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn verificationresult_create(
  resource: r5.Verificationresult,
  client: FhirClient,
) -> Result(r5.Verificationresult, Err) {
  any_create(
    r5.verificationresult_to_json(resource),
    "VerificationResult",
    r5.verificationresult_decoder(),
    client,
  )
}

pub fn verificationresult_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Verificationresult, Err) {
  any_read(id, client, "VerificationResult", r5.verificationresult_decoder())
}

pub fn verificationresult_update(
  resource: r5.Verificationresult,
  client: FhirClient,
) -> Result(r5.Verificationresult, Err) {
  any_update(
    resource.id,
    r5.verificationresult_to_json(resource),
    "VerificationResult",
    r5.verificationresult_decoder(),
    client,
  )
}

pub fn verificationresult_delete(
  resource: r5.Verificationresult,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "VerificationResult", client)
}

pub fn verificationresult_search(
  sp: r5_sansio.SpVerificationresult,
  client: FhirClient,
) {
  let req = r5_sansio.verificationresult_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}

pub fn visionprescription_create(
  resource: r5.Visionprescription,
  client: FhirClient,
) -> Result(r5.Visionprescription, Err) {
  any_create(
    r5.visionprescription_to_json(resource),
    "VisionPrescription",
    r5.visionprescription_decoder(),
    client,
  )
}

pub fn visionprescription_read(
  id: String,
  client: FhirClient,
) -> Result(r5.Visionprescription, Err) {
  any_read(id, client, "VisionPrescription", r5.visionprescription_decoder())
}

pub fn visionprescription_update(
  resource: r5.Visionprescription,
  client: FhirClient,
) -> Result(r5.Visionprescription, Err) {
  any_update(
    resource.id,
    r5.visionprescription_to_json(resource),
    "VisionPrescription",
    r5.visionprescription_decoder(),
    client,
  )
}

pub fn visionprescription_delete(
  resource: r5.Visionprescription,
  client: FhirClient,
) -> Result(r5.Operationoutcome, Err) {
  any_delete(resource.id, "VisionPrescription", client)
}

pub fn visionprescription_search(
  sp: r5_sansio.SpVisionprescription,
  client: FhirClient,
) {
  let req = r5_sansio.visionprescription_search_req(sp, client)
  sendreq_parseresource(req, r5.bundle_decoder())
}
