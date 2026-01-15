import fhir/r4
import fhir/r4_sansio
import gleam/dynamic/decode.{type Decoder}
import gleam/http/request.{type Request}
import gleam/httpc
import gleam/json.{type Json}
import gleam/option.{type Option}

pub type FhirClient =
  r4_sansio.FhirClient

pub fn fhirclient_new(baseurl: String) -> FhirClient {
  r4_sansio.fhirclient_new(baseurl)
}

pub type ReqError {
  ReqErrOperationcome(r4.Operationoutcome)
  ReqErrDecode(json.DecodeError)
  ReqErrHttp(httpc.HttpError)
  ReqErrNoId
}

fn any_create(
  resource: Json,
  res_type: String,
  resource_dec: Decoder(r),
  client: FhirClient,
) -> Result(r, ReqError) {
  let req = r4_sansio.any_create_req(resource, res_type, client)
  sendreq_parseresource(req, resource_dec)
}

fn any_read(
  id: String,
  client: FhirClient,
  res_type: String,
  resource_dec: Decoder(a),
) -> Result(a, ReqError) {
  let req = r4_sansio.any_read_req(id, res_type, client)
  sendreq_parseresource(req, resource_dec)
}

fn any_update(
  id: Option(String),
  resource: Json,
  res_type: String,
  res_dec: Decoder(r),
  client: FhirClient,
) -> Result(r, ReqError) {
  let req = r4_sansio.any_update_req(id, resource, res_type, client)
  case req {
    Ok(req) -> sendreq_parseresource(req, res_dec)
    Error(r4_sansio.ErrNoId) -> Error(ReqErrNoId)
    Error(_) ->
      panic as "should never get any errors besides NoId before making request"
  }
}

fn any_delete(
  id: Option(String),
  res_type: String,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  let req = r4_sansio.any_delete_req(id, res_type, client)
  case req {
    Ok(req) -> sendreq_parseresource(req, r4.operationoutcome_decoder())
    Error(r4_sansio.ErrNoId) -> Error(ReqErrNoId)
    Error(_) ->
      panic as "should never get any errors besides NoId before making request"
  }
}

fn sendreq_parseresource(
  req: Request(String),
  res_dec: Decoder(r),
) -> Result(r, ReqError) {
  case httpc.send(req) {
    Error(err) -> Error(ReqErrHttp(err))
    Ok(resp) ->
      case r4_sansio.any_resp(resp, res_dec) {
        Ok(resource) -> Ok(resource)
        Error(r4_sansio.ErrOperationcome(oo)) -> Error(ReqErrOperationcome(oo))
        Error(r4_sansio.ErrDecode(dec_err)) -> Error(ReqErrDecode(dec_err))
        Error(r4_sansio.ErrNoId) -> Error(ReqErrNoId)
      }
  }
}

pub fn account_create(
  resource: r4.Account,
  client: FhirClient,
) -> Result(r4.Account, ReqError) {
  any_create(
    r4.account_to_json(resource),
    "Account",
    r4.account_decoder(),
    client,
  )
}

pub fn account_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Account, ReqError) {
  any_read(id, client, "Account", r4.account_decoder())
}

pub fn account_update(
  resource: r4.Account,
  client: FhirClient,
) -> Result(r4.Account, ReqError) {
  any_update(
    resource.id,
    r4.account_to_json(resource),
    "Account",
    r4.account_decoder(),
    client,
  )
}

pub fn account_delete(
  resource: r4.Account,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Account", client)
}

pub fn activitydefinition_create(
  resource: r4.Activitydefinition,
  client: FhirClient,
) -> Result(r4.Activitydefinition, ReqError) {
  any_create(
    r4.activitydefinition_to_json(resource),
    "ActivityDefinition",
    r4.activitydefinition_decoder(),
    client,
  )
}

pub fn activitydefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Activitydefinition, ReqError) {
  any_read(id, client, "ActivityDefinition", r4.activitydefinition_decoder())
}

pub fn activitydefinition_update(
  resource: r4.Activitydefinition,
  client: FhirClient,
) -> Result(r4.Activitydefinition, ReqError) {
  any_update(
    resource.id,
    r4.activitydefinition_to_json(resource),
    "ActivityDefinition",
    r4.activitydefinition_decoder(),
    client,
  )
}

pub fn activitydefinition_delete(
  resource: r4.Activitydefinition,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "ActivityDefinition", client)
}

pub fn adverseevent_create(
  resource: r4.Adverseevent,
  client: FhirClient,
) -> Result(r4.Adverseevent, ReqError) {
  any_create(
    r4.adverseevent_to_json(resource),
    "AdverseEvent",
    r4.adverseevent_decoder(),
    client,
  )
}

pub fn adverseevent_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Adverseevent, ReqError) {
  any_read(id, client, "AdverseEvent", r4.adverseevent_decoder())
}

pub fn adverseevent_update(
  resource: r4.Adverseevent,
  client: FhirClient,
) -> Result(r4.Adverseevent, ReqError) {
  any_update(
    resource.id,
    r4.adverseevent_to_json(resource),
    "AdverseEvent",
    r4.adverseevent_decoder(),
    client,
  )
}

pub fn adverseevent_delete(
  resource: r4.Adverseevent,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "AdverseEvent", client)
}

pub fn allergyintolerance_create(
  resource: r4.Allergyintolerance,
  client: FhirClient,
) -> Result(r4.Allergyintolerance, ReqError) {
  any_create(
    r4.allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    r4.allergyintolerance_decoder(),
    client,
  )
}

pub fn allergyintolerance_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Allergyintolerance, ReqError) {
  any_read(id, client, "AllergyIntolerance", r4.allergyintolerance_decoder())
}

pub fn allergyintolerance_update(
  resource: r4.Allergyintolerance,
  client: FhirClient,
) -> Result(r4.Allergyintolerance, ReqError) {
  any_update(
    resource.id,
    r4.allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    r4.allergyintolerance_decoder(),
    client,
  )
}

pub fn allergyintolerance_delete(
  resource: r4.Allergyintolerance,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "AllergyIntolerance", client)
}

pub fn appointment_create(
  resource: r4.Appointment,
  client: FhirClient,
) -> Result(r4.Appointment, ReqError) {
  any_create(
    r4.appointment_to_json(resource),
    "Appointment",
    r4.appointment_decoder(),
    client,
  )
}

pub fn appointment_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Appointment, ReqError) {
  any_read(id, client, "Appointment", r4.appointment_decoder())
}

pub fn appointment_update(
  resource: r4.Appointment,
  client: FhirClient,
) -> Result(r4.Appointment, ReqError) {
  any_update(
    resource.id,
    r4.appointment_to_json(resource),
    "Appointment",
    r4.appointment_decoder(),
    client,
  )
}

pub fn appointment_delete(
  resource: r4.Appointment,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Appointment", client)
}

pub fn appointmentresponse_create(
  resource: r4.Appointmentresponse,
  client: FhirClient,
) -> Result(r4.Appointmentresponse, ReqError) {
  any_create(
    r4.appointmentresponse_to_json(resource),
    "AppointmentResponse",
    r4.appointmentresponse_decoder(),
    client,
  )
}

pub fn appointmentresponse_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Appointmentresponse, ReqError) {
  any_read(id, client, "AppointmentResponse", r4.appointmentresponse_decoder())
}

pub fn appointmentresponse_update(
  resource: r4.Appointmentresponse,
  client: FhirClient,
) -> Result(r4.Appointmentresponse, ReqError) {
  any_update(
    resource.id,
    r4.appointmentresponse_to_json(resource),
    "AppointmentResponse",
    r4.appointmentresponse_decoder(),
    client,
  )
}

pub fn appointmentresponse_delete(
  resource: r4.Appointmentresponse,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "AppointmentResponse", client)
}

pub fn auditevent_create(
  resource: r4.Auditevent,
  client: FhirClient,
) -> Result(r4.Auditevent, ReqError) {
  any_create(
    r4.auditevent_to_json(resource),
    "AuditEvent",
    r4.auditevent_decoder(),
    client,
  )
}

pub fn auditevent_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Auditevent, ReqError) {
  any_read(id, client, "AuditEvent", r4.auditevent_decoder())
}

pub fn auditevent_update(
  resource: r4.Auditevent,
  client: FhirClient,
) -> Result(r4.Auditevent, ReqError) {
  any_update(
    resource.id,
    r4.auditevent_to_json(resource),
    "AuditEvent",
    r4.auditevent_decoder(),
    client,
  )
}

pub fn auditevent_delete(
  resource: r4.Auditevent,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "AuditEvent", client)
}

pub fn basic_create(
  resource: r4.Basic,
  client: FhirClient,
) -> Result(r4.Basic, ReqError) {
  any_create(r4.basic_to_json(resource), "Basic", r4.basic_decoder(), client)
}

pub fn basic_read(id: String, client: FhirClient) -> Result(r4.Basic, ReqError) {
  any_read(id, client, "Basic", r4.basic_decoder())
}

pub fn basic_update(
  resource: r4.Basic,
  client: FhirClient,
) -> Result(r4.Basic, ReqError) {
  any_update(
    resource.id,
    r4.basic_to_json(resource),
    "Basic",
    r4.basic_decoder(),
    client,
  )
}

pub fn basic_delete(
  resource: r4.Basic,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Basic", client)
}

pub fn binary_create(
  resource: r4.Binary,
  client: FhirClient,
) -> Result(r4.Binary, ReqError) {
  any_create(r4.binary_to_json(resource), "Binary", r4.binary_decoder(), client)
}

pub fn binary_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Binary, ReqError) {
  any_read(id, client, "Binary", r4.binary_decoder())
}

pub fn binary_update(
  resource: r4.Binary,
  client: FhirClient,
) -> Result(r4.Binary, ReqError) {
  any_update(
    resource.id,
    r4.binary_to_json(resource),
    "Binary",
    r4.binary_decoder(),
    client,
  )
}

pub fn binary_delete(
  resource: r4.Binary,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Binary", client)
}

pub fn biologicallyderivedproduct_create(
  resource: r4.Biologicallyderivedproduct,
  client: FhirClient,
) -> Result(r4.Biologicallyderivedproduct, ReqError) {
  any_create(
    r4.biologicallyderivedproduct_to_json(resource),
    "BiologicallyDerivedProduct",
    r4.biologicallyderivedproduct_decoder(),
    client,
  )
}

pub fn biologicallyderivedproduct_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Biologicallyderivedproduct, ReqError) {
  any_read(
    id,
    client,
    "BiologicallyDerivedProduct",
    r4.biologicallyderivedproduct_decoder(),
  )
}

pub fn biologicallyderivedproduct_update(
  resource: r4.Biologicallyderivedproduct,
  client: FhirClient,
) -> Result(r4.Biologicallyderivedproduct, ReqError) {
  any_update(
    resource.id,
    r4.biologicallyderivedproduct_to_json(resource),
    "BiologicallyDerivedProduct",
    r4.biologicallyderivedproduct_decoder(),
    client,
  )
}

pub fn biologicallyderivedproduct_delete(
  resource: r4.Biologicallyderivedproduct,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "BiologicallyDerivedProduct", client)
}

pub fn bodystructure_create(
  resource: r4.Bodystructure,
  client: FhirClient,
) -> Result(r4.Bodystructure, ReqError) {
  any_create(
    r4.bodystructure_to_json(resource),
    "BodyStructure",
    r4.bodystructure_decoder(),
    client,
  )
}

pub fn bodystructure_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Bodystructure, ReqError) {
  any_read(id, client, "BodyStructure", r4.bodystructure_decoder())
}

pub fn bodystructure_update(
  resource: r4.Bodystructure,
  client: FhirClient,
) -> Result(r4.Bodystructure, ReqError) {
  any_update(
    resource.id,
    r4.bodystructure_to_json(resource),
    "BodyStructure",
    r4.bodystructure_decoder(),
    client,
  )
}

pub fn bodystructure_delete(
  resource: r4.Bodystructure,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "BodyStructure", client)
}

pub fn bundle_create(
  resource: r4.Bundle,
  client: FhirClient,
) -> Result(r4.Bundle, ReqError) {
  any_create(r4.bundle_to_json(resource), "Bundle", r4.bundle_decoder(), client)
}

pub fn bundle_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Bundle, ReqError) {
  any_read(id, client, "Bundle", r4.bundle_decoder())
}

pub fn bundle_update(
  resource: r4.Bundle,
  client: FhirClient,
) -> Result(r4.Bundle, ReqError) {
  any_update(
    resource.id,
    r4.bundle_to_json(resource),
    "Bundle",
    r4.bundle_decoder(),
    client,
  )
}

pub fn bundle_delete(
  resource: r4.Bundle,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Bundle", client)
}

pub fn capabilitystatement_create(
  resource: r4.Capabilitystatement,
  client: FhirClient,
) -> Result(r4.Capabilitystatement, ReqError) {
  any_create(
    r4.capabilitystatement_to_json(resource),
    "CapabilityStatement",
    r4.capabilitystatement_decoder(),
    client,
  )
}

pub fn capabilitystatement_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Capabilitystatement, ReqError) {
  any_read(id, client, "CapabilityStatement", r4.capabilitystatement_decoder())
}

pub fn capabilitystatement_update(
  resource: r4.Capabilitystatement,
  client: FhirClient,
) -> Result(r4.Capabilitystatement, ReqError) {
  any_update(
    resource.id,
    r4.capabilitystatement_to_json(resource),
    "CapabilityStatement",
    r4.capabilitystatement_decoder(),
    client,
  )
}

pub fn capabilitystatement_delete(
  resource: r4.Capabilitystatement,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "CapabilityStatement", client)
}

pub fn careplan_create(
  resource: r4.Careplan,
  client: FhirClient,
) -> Result(r4.Careplan, ReqError) {
  any_create(
    r4.careplan_to_json(resource),
    "CarePlan",
    r4.careplan_decoder(),
    client,
  )
}

pub fn careplan_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Careplan, ReqError) {
  any_read(id, client, "CarePlan", r4.careplan_decoder())
}

pub fn careplan_update(
  resource: r4.Careplan,
  client: FhirClient,
) -> Result(r4.Careplan, ReqError) {
  any_update(
    resource.id,
    r4.careplan_to_json(resource),
    "CarePlan",
    r4.careplan_decoder(),
    client,
  )
}

pub fn careplan_delete(
  resource: r4.Careplan,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "CarePlan", client)
}

pub fn careteam_create(
  resource: r4.Careteam,
  client: FhirClient,
) -> Result(r4.Careteam, ReqError) {
  any_create(
    r4.careteam_to_json(resource),
    "CareTeam",
    r4.careteam_decoder(),
    client,
  )
}

pub fn careteam_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Careteam, ReqError) {
  any_read(id, client, "CareTeam", r4.careteam_decoder())
}

pub fn careteam_update(
  resource: r4.Careteam,
  client: FhirClient,
) -> Result(r4.Careteam, ReqError) {
  any_update(
    resource.id,
    r4.careteam_to_json(resource),
    "CareTeam",
    r4.careteam_decoder(),
    client,
  )
}

pub fn careteam_delete(
  resource: r4.Careteam,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "CareTeam", client)
}

pub fn catalogentry_create(
  resource: r4.Catalogentry,
  client: FhirClient,
) -> Result(r4.Catalogentry, ReqError) {
  any_create(
    r4.catalogentry_to_json(resource),
    "CatalogEntry",
    r4.catalogentry_decoder(),
    client,
  )
}

pub fn catalogentry_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Catalogentry, ReqError) {
  any_read(id, client, "CatalogEntry", r4.catalogentry_decoder())
}

pub fn catalogentry_update(
  resource: r4.Catalogentry,
  client: FhirClient,
) -> Result(r4.Catalogentry, ReqError) {
  any_update(
    resource.id,
    r4.catalogentry_to_json(resource),
    "CatalogEntry",
    r4.catalogentry_decoder(),
    client,
  )
}

pub fn catalogentry_delete(
  resource: r4.Catalogentry,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "CatalogEntry", client)
}

pub fn chargeitem_create(
  resource: r4.Chargeitem,
  client: FhirClient,
) -> Result(r4.Chargeitem, ReqError) {
  any_create(
    r4.chargeitem_to_json(resource),
    "ChargeItem",
    r4.chargeitem_decoder(),
    client,
  )
}

pub fn chargeitem_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Chargeitem, ReqError) {
  any_read(id, client, "ChargeItem", r4.chargeitem_decoder())
}

pub fn chargeitem_update(
  resource: r4.Chargeitem,
  client: FhirClient,
) -> Result(r4.Chargeitem, ReqError) {
  any_update(
    resource.id,
    r4.chargeitem_to_json(resource),
    "ChargeItem",
    r4.chargeitem_decoder(),
    client,
  )
}

pub fn chargeitem_delete(
  resource: r4.Chargeitem,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "ChargeItem", client)
}

pub fn chargeitemdefinition_create(
  resource: r4.Chargeitemdefinition,
  client: FhirClient,
) -> Result(r4.Chargeitemdefinition, ReqError) {
  any_create(
    r4.chargeitemdefinition_to_json(resource),
    "ChargeItemDefinition",
    r4.chargeitemdefinition_decoder(),
    client,
  )
}

pub fn chargeitemdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Chargeitemdefinition, ReqError) {
  any_read(
    id,
    client,
    "ChargeItemDefinition",
    r4.chargeitemdefinition_decoder(),
  )
}

pub fn chargeitemdefinition_update(
  resource: r4.Chargeitemdefinition,
  client: FhirClient,
) -> Result(r4.Chargeitemdefinition, ReqError) {
  any_update(
    resource.id,
    r4.chargeitemdefinition_to_json(resource),
    "ChargeItemDefinition",
    r4.chargeitemdefinition_decoder(),
    client,
  )
}

pub fn chargeitemdefinition_delete(
  resource: r4.Chargeitemdefinition,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "ChargeItemDefinition", client)
}

pub fn claim_create(
  resource: r4.Claim,
  client: FhirClient,
) -> Result(r4.Claim, ReqError) {
  any_create(r4.claim_to_json(resource), "Claim", r4.claim_decoder(), client)
}

pub fn claim_read(id: String, client: FhirClient) -> Result(r4.Claim, ReqError) {
  any_read(id, client, "Claim", r4.claim_decoder())
}

pub fn claim_update(
  resource: r4.Claim,
  client: FhirClient,
) -> Result(r4.Claim, ReqError) {
  any_update(
    resource.id,
    r4.claim_to_json(resource),
    "Claim",
    r4.claim_decoder(),
    client,
  )
}

pub fn claim_delete(
  resource: r4.Claim,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Claim", client)
}

pub fn claimresponse_create(
  resource: r4.Claimresponse,
  client: FhirClient,
) -> Result(r4.Claimresponse, ReqError) {
  any_create(
    r4.claimresponse_to_json(resource),
    "ClaimResponse",
    r4.claimresponse_decoder(),
    client,
  )
}

pub fn claimresponse_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Claimresponse, ReqError) {
  any_read(id, client, "ClaimResponse", r4.claimresponse_decoder())
}

pub fn claimresponse_update(
  resource: r4.Claimresponse,
  client: FhirClient,
) -> Result(r4.Claimresponse, ReqError) {
  any_update(
    resource.id,
    r4.claimresponse_to_json(resource),
    "ClaimResponse",
    r4.claimresponse_decoder(),
    client,
  )
}

pub fn claimresponse_delete(
  resource: r4.Claimresponse,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "ClaimResponse", client)
}

pub fn clinicalimpression_create(
  resource: r4.Clinicalimpression,
  client: FhirClient,
) -> Result(r4.Clinicalimpression, ReqError) {
  any_create(
    r4.clinicalimpression_to_json(resource),
    "ClinicalImpression",
    r4.clinicalimpression_decoder(),
    client,
  )
}

pub fn clinicalimpression_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Clinicalimpression, ReqError) {
  any_read(id, client, "ClinicalImpression", r4.clinicalimpression_decoder())
}

pub fn clinicalimpression_update(
  resource: r4.Clinicalimpression,
  client: FhirClient,
) -> Result(r4.Clinicalimpression, ReqError) {
  any_update(
    resource.id,
    r4.clinicalimpression_to_json(resource),
    "ClinicalImpression",
    r4.clinicalimpression_decoder(),
    client,
  )
}

pub fn clinicalimpression_delete(
  resource: r4.Clinicalimpression,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "ClinicalImpression", client)
}

pub fn codesystem_create(
  resource: r4.Codesystem,
  client: FhirClient,
) -> Result(r4.Codesystem, ReqError) {
  any_create(
    r4.codesystem_to_json(resource),
    "CodeSystem",
    r4.codesystem_decoder(),
    client,
  )
}

pub fn codesystem_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Codesystem, ReqError) {
  any_read(id, client, "CodeSystem", r4.codesystem_decoder())
}

pub fn codesystem_update(
  resource: r4.Codesystem,
  client: FhirClient,
) -> Result(r4.Codesystem, ReqError) {
  any_update(
    resource.id,
    r4.codesystem_to_json(resource),
    "CodeSystem",
    r4.codesystem_decoder(),
    client,
  )
}

pub fn codesystem_delete(
  resource: r4.Codesystem,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "CodeSystem", client)
}

pub fn communication_create(
  resource: r4.Communication,
  client: FhirClient,
) -> Result(r4.Communication, ReqError) {
  any_create(
    r4.communication_to_json(resource),
    "Communication",
    r4.communication_decoder(),
    client,
  )
}

pub fn communication_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Communication, ReqError) {
  any_read(id, client, "Communication", r4.communication_decoder())
}

pub fn communication_update(
  resource: r4.Communication,
  client: FhirClient,
) -> Result(r4.Communication, ReqError) {
  any_update(
    resource.id,
    r4.communication_to_json(resource),
    "Communication",
    r4.communication_decoder(),
    client,
  )
}

pub fn communication_delete(
  resource: r4.Communication,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Communication", client)
}

pub fn communicationrequest_create(
  resource: r4.Communicationrequest,
  client: FhirClient,
) -> Result(r4.Communicationrequest, ReqError) {
  any_create(
    r4.communicationrequest_to_json(resource),
    "CommunicationRequest",
    r4.communicationrequest_decoder(),
    client,
  )
}

pub fn communicationrequest_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Communicationrequest, ReqError) {
  any_read(
    id,
    client,
    "CommunicationRequest",
    r4.communicationrequest_decoder(),
  )
}

pub fn communicationrequest_update(
  resource: r4.Communicationrequest,
  client: FhirClient,
) -> Result(r4.Communicationrequest, ReqError) {
  any_update(
    resource.id,
    r4.communicationrequest_to_json(resource),
    "CommunicationRequest",
    r4.communicationrequest_decoder(),
    client,
  )
}

pub fn communicationrequest_delete(
  resource: r4.Communicationrequest,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "CommunicationRequest", client)
}

pub fn compartmentdefinition_create(
  resource: r4.Compartmentdefinition,
  client: FhirClient,
) -> Result(r4.Compartmentdefinition, ReqError) {
  any_create(
    r4.compartmentdefinition_to_json(resource),
    "CompartmentDefinition",
    r4.compartmentdefinition_decoder(),
    client,
  )
}

pub fn compartmentdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Compartmentdefinition, ReqError) {
  any_read(
    id,
    client,
    "CompartmentDefinition",
    r4.compartmentdefinition_decoder(),
  )
}

pub fn compartmentdefinition_update(
  resource: r4.Compartmentdefinition,
  client: FhirClient,
) -> Result(r4.Compartmentdefinition, ReqError) {
  any_update(
    resource.id,
    r4.compartmentdefinition_to_json(resource),
    "CompartmentDefinition",
    r4.compartmentdefinition_decoder(),
    client,
  )
}

pub fn compartmentdefinition_delete(
  resource: r4.Compartmentdefinition,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "CompartmentDefinition", client)
}

pub fn composition_create(
  resource: r4.Composition,
  client: FhirClient,
) -> Result(r4.Composition, ReqError) {
  any_create(
    r4.composition_to_json(resource),
    "Composition",
    r4.composition_decoder(),
    client,
  )
}

pub fn composition_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Composition, ReqError) {
  any_read(id, client, "Composition", r4.composition_decoder())
}

pub fn composition_update(
  resource: r4.Composition,
  client: FhirClient,
) -> Result(r4.Composition, ReqError) {
  any_update(
    resource.id,
    r4.composition_to_json(resource),
    "Composition",
    r4.composition_decoder(),
    client,
  )
}

pub fn composition_delete(
  resource: r4.Composition,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Composition", client)
}

pub fn conceptmap_create(
  resource: r4.Conceptmap,
  client: FhirClient,
) -> Result(r4.Conceptmap, ReqError) {
  any_create(
    r4.conceptmap_to_json(resource),
    "ConceptMap",
    r4.conceptmap_decoder(),
    client,
  )
}

pub fn conceptmap_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Conceptmap, ReqError) {
  any_read(id, client, "ConceptMap", r4.conceptmap_decoder())
}

pub fn conceptmap_update(
  resource: r4.Conceptmap,
  client: FhirClient,
) -> Result(r4.Conceptmap, ReqError) {
  any_update(
    resource.id,
    r4.conceptmap_to_json(resource),
    "ConceptMap",
    r4.conceptmap_decoder(),
    client,
  )
}

pub fn conceptmap_delete(
  resource: r4.Conceptmap,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "ConceptMap", client)
}

pub fn condition_create(
  resource: r4.Condition,
  client: FhirClient,
) -> Result(r4.Condition, ReqError) {
  any_create(
    r4.condition_to_json(resource),
    "Condition",
    r4.condition_decoder(),
    client,
  )
}

pub fn condition_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Condition, ReqError) {
  any_read(id, client, "Condition", r4.condition_decoder())
}

pub fn condition_update(
  resource: r4.Condition,
  client: FhirClient,
) -> Result(r4.Condition, ReqError) {
  any_update(
    resource.id,
    r4.condition_to_json(resource),
    "Condition",
    r4.condition_decoder(),
    client,
  )
}

pub fn condition_delete(
  resource: r4.Condition,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Condition", client)
}

pub fn consent_create(
  resource: r4.Consent,
  client: FhirClient,
) -> Result(r4.Consent, ReqError) {
  any_create(
    r4.consent_to_json(resource),
    "Consent",
    r4.consent_decoder(),
    client,
  )
}

pub fn consent_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Consent, ReqError) {
  any_read(id, client, "Consent", r4.consent_decoder())
}

pub fn consent_update(
  resource: r4.Consent,
  client: FhirClient,
) -> Result(r4.Consent, ReqError) {
  any_update(
    resource.id,
    r4.consent_to_json(resource),
    "Consent",
    r4.consent_decoder(),
    client,
  )
}

pub fn consent_delete(
  resource: r4.Consent,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Consent", client)
}

pub fn contract_create(
  resource: r4.Contract,
  client: FhirClient,
) -> Result(r4.Contract, ReqError) {
  any_create(
    r4.contract_to_json(resource),
    "Contract",
    r4.contract_decoder(),
    client,
  )
}

pub fn contract_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Contract, ReqError) {
  any_read(id, client, "Contract", r4.contract_decoder())
}

pub fn contract_update(
  resource: r4.Contract,
  client: FhirClient,
) -> Result(r4.Contract, ReqError) {
  any_update(
    resource.id,
    r4.contract_to_json(resource),
    "Contract",
    r4.contract_decoder(),
    client,
  )
}

pub fn contract_delete(
  resource: r4.Contract,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Contract", client)
}

pub fn coverage_create(
  resource: r4.Coverage,
  client: FhirClient,
) -> Result(r4.Coverage, ReqError) {
  any_create(
    r4.coverage_to_json(resource),
    "Coverage",
    r4.coverage_decoder(),
    client,
  )
}

pub fn coverage_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Coverage, ReqError) {
  any_read(id, client, "Coverage", r4.coverage_decoder())
}

pub fn coverage_update(
  resource: r4.Coverage,
  client: FhirClient,
) -> Result(r4.Coverage, ReqError) {
  any_update(
    resource.id,
    r4.coverage_to_json(resource),
    "Coverage",
    r4.coverage_decoder(),
    client,
  )
}

pub fn coverage_delete(
  resource: r4.Coverage,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Coverage", client)
}

pub fn coverageeligibilityrequest_create(
  resource: r4.Coverageeligibilityrequest,
  client: FhirClient,
) -> Result(r4.Coverageeligibilityrequest, ReqError) {
  any_create(
    r4.coverageeligibilityrequest_to_json(resource),
    "CoverageEligibilityRequest",
    r4.coverageeligibilityrequest_decoder(),
    client,
  )
}

pub fn coverageeligibilityrequest_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Coverageeligibilityrequest, ReqError) {
  any_read(
    id,
    client,
    "CoverageEligibilityRequest",
    r4.coverageeligibilityrequest_decoder(),
  )
}

pub fn coverageeligibilityrequest_update(
  resource: r4.Coverageeligibilityrequest,
  client: FhirClient,
) -> Result(r4.Coverageeligibilityrequest, ReqError) {
  any_update(
    resource.id,
    r4.coverageeligibilityrequest_to_json(resource),
    "CoverageEligibilityRequest",
    r4.coverageeligibilityrequest_decoder(),
    client,
  )
}

pub fn coverageeligibilityrequest_delete(
  resource: r4.Coverageeligibilityrequest,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "CoverageEligibilityRequest", client)
}

pub fn coverageeligibilityresponse_create(
  resource: r4.Coverageeligibilityresponse,
  client: FhirClient,
) -> Result(r4.Coverageeligibilityresponse, ReqError) {
  any_create(
    r4.coverageeligibilityresponse_to_json(resource),
    "CoverageEligibilityResponse",
    r4.coverageeligibilityresponse_decoder(),
    client,
  )
}

pub fn coverageeligibilityresponse_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Coverageeligibilityresponse, ReqError) {
  any_read(
    id,
    client,
    "CoverageEligibilityResponse",
    r4.coverageeligibilityresponse_decoder(),
  )
}

pub fn coverageeligibilityresponse_update(
  resource: r4.Coverageeligibilityresponse,
  client: FhirClient,
) -> Result(r4.Coverageeligibilityresponse, ReqError) {
  any_update(
    resource.id,
    r4.coverageeligibilityresponse_to_json(resource),
    "CoverageEligibilityResponse",
    r4.coverageeligibilityresponse_decoder(),
    client,
  )
}

pub fn coverageeligibilityresponse_delete(
  resource: r4.Coverageeligibilityresponse,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "CoverageEligibilityResponse", client)
}

pub fn detectedissue_create(
  resource: r4.Detectedissue,
  client: FhirClient,
) -> Result(r4.Detectedissue, ReqError) {
  any_create(
    r4.detectedissue_to_json(resource),
    "DetectedIssue",
    r4.detectedissue_decoder(),
    client,
  )
}

pub fn detectedissue_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Detectedissue, ReqError) {
  any_read(id, client, "DetectedIssue", r4.detectedissue_decoder())
}

pub fn detectedissue_update(
  resource: r4.Detectedissue,
  client: FhirClient,
) -> Result(r4.Detectedissue, ReqError) {
  any_update(
    resource.id,
    r4.detectedissue_to_json(resource),
    "DetectedIssue",
    r4.detectedissue_decoder(),
    client,
  )
}

pub fn detectedissue_delete(
  resource: r4.Detectedissue,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "DetectedIssue", client)
}

pub fn device_create(
  resource: r4.Device,
  client: FhirClient,
) -> Result(r4.Device, ReqError) {
  any_create(r4.device_to_json(resource), "Device", r4.device_decoder(), client)
}

pub fn device_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Device, ReqError) {
  any_read(id, client, "Device", r4.device_decoder())
}

pub fn device_update(
  resource: r4.Device,
  client: FhirClient,
) -> Result(r4.Device, ReqError) {
  any_update(
    resource.id,
    r4.device_to_json(resource),
    "Device",
    r4.device_decoder(),
    client,
  )
}

pub fn device_delete(
  resource: r4.Device,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Device", client)
}

pub fn devicedefinition_create(
  resource: r4.Devicedefinition,
  client: FhirClient,
) -> Result(r4.Devicedefinition, ReqError) {
  any_create(
    r4.devicedefinition_to_json(resource),
    "DeviceDefinition",
    r4.devicedefinition_decoder(),
    client,
  )
}

pub fn devicedefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Devicedefinition, ReqError) {
  any_read(id, client, "DeviceDefinition", r4.devicedefinition_decoder())
}

pub fn devicedefinition_update(
  resource: r4.Devicedefinition,
  client: FhirClient,
) -> Result(r4.Devicedefinition, ReqError) {
  any_update(
    resource.id,
    r4.devicedefinition_to_json(resource),
    "DeviceDefinition",
    r4.devicedefinition_decoder(),
    client,
  )
}

pub fn devicedefinition_delete(
  resource: r4.Devicedefinition,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "DeviceDefinition", client)
}

pub fn devicemetric_create(
  resource: r4.Devicemetric,
  client: FhirClient,
) -> Result(r4.Devicemetric, ReqError) {
  any_create(
    r4.devicemetric_to_json(resource),
    "DeviceMetric",
    r4.devicemetric_decoder(),
    client,
  )
}

pub fn devicemetric_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Devicemetric, ReqError) {
  any_read(id, client, "DeviceMetric", r4.devicemetric_decoder())
}

pub fn devicemetric_update(
  resource: r4.Devicemetric,
  client: FhirClient,
) -> Result(r4.Devicemetric, ReqError) {
  any_update(
    resource.id,
    r4.devicemetric_to_json(resource),
    "DeviceMetric",
    r4.devicemetric_decoder(),
    client,
  )
}

pub fn devicemetric_delete(
  resource: r4.Devicemetric,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "DeviceMetric", client)
}

pub fn devicerequest_create(
  resource: r4.Devicerequest,
  client: FhirClient,
) -> Result(r4.Devicerequest, ReqError) {
  any_create(
    r4.devicerequest_to_json(resource),
    "DeviceRequest",
    r4.devicerequest_decoder(),
    client,
  )
}

pub fn devicerequest_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Devicerequest, ReqError) {
  any_read(id, client, "DeviceRequest", r4.devicerequest_decoder())
}

pub fn devicerequest_update(
  resource: r4.Devicerequest,
  client: FhirClient,
) -> Result(r4.Devicerequest, ReqError) {
  any_update(
    resource.id,
    r4.devicerequest_to_json(resource),
    "DeviceRequest",
    r4.devicerequest_decoder(),
    client,
  )
}

pub fn devicerequest_delete(
  resource: r4.Devicerequest,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "DeviceRequest", client)
}

pub fn deviceusestatement_create(
  resource: r4.Deviceusestatement,
  client: FhirClient,
) -> Result(r4.Deviceusestatement, ReqError) {
  any_create(
    r4.deviceusestatement_to_json(resource),
    "DeviceUseStatement",
    r4.deviceusestatement_decoder(),
    client,
  )
}

pub fn deviceusestatement_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Deviceusestatement, ReqError) {
  any_read(id, client, "DeviceUseStatement", r4.deviceusestatement_decoder())
}

pub fn deviceusestatement_update(
  resource: r4.Deviceusestatement,
  client: FhirClient,
) -> Result(r4.Deviceusestatement, ReqError) {
  any_update(
    resource.id,
    r4.deviceusestatement_to_json(resource),
    "DeviceUseStatement",
    r4.deviceusestatement_decoder(),
    client,
  )
}

pub fn deviceusestatement_delete(
  resource: r4.Deviceusestatement,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "DeviceUseStatement", client)
}

pub fn diagnosticreport_create(
  resource: r4.Diagnosticreport,
  client: FhirClient,
) -> Result(r4.Diagnosticreport, ReqError) {
  any_create(
    r4.diagnosticreport_to_json(resource),
    "DiagnosticReport",
    r4.diagnosticreport_decoder(),
    client,
  )
}

pub fn diagnosticreport_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Diagnosticreport, ReqError) {
  any_read(id, client, "DiagnosticReport", r4.diagnosticreport_decoder())
}

pub fn diagnosticreport_update(
  resource: r4.Diagnosticreport,
  client: FhirClient,
) -> Result(r4.Diagnosticreport, ReqError) {
  any_update(
    resource.id,
    r4.diagnosticreport_to_json(resource),
    "DiagnosticReport",
    r4.diagnosticreport_decoder(),
    client,
  )
}

pub fn diagnosticreport_delete(
  resource: r4.Diagnosticreport,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "DiagnosticReport", client)
}

pub fn documentmanifest_create(
  resource: r4.Documentmanifest,
  client: FhirClient,
) -> Result(r4.Documentmanifest, ReqError) {
  any_create(
    r4.documentmanifest_to_json(resource),
    "DocumentManifest",
    r4.documentmanifest_decoder(),
    client,
  )
}

pub fn documentmanifest_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Documentmanifest, ReqError) {
  any_read(id, client, "DocumentManifest", r4.documentmanifest_decoder())
}

pub fn documentmanifest_update(
  resource: r4.Documentmanifest,
  client: FhirClient,
) -> Result(r4.Documentmanifest, ReqError) {
  any_update(
    resource.id,
    r4.documentmanifest_to_json(resource),
    "DocumentManifest",
    r4.documentmanifest_decoder(),
    client,
  )
}

pub fn documentmanifest_delete(
  resource: r4.Documentmanifest,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "DocumentManifest", client)
}

pub fn documentreference_create(
  resource: r4.Documentreference,
  client: FhirClient,
) -> Result(r4.Documentreference, ReqError) {
  any_create(
    r4.documentreference_to_json(resource),
    "DocumentReference",
    r4.documentreference_decoder(),
    client,
  )
}

pub fn documentreference_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Documentreference, ReqError) {
  any_read(id, client, "DocumentReference", r4.documentreference_decoder())
}

pub fn documentreference_update(
  resource: r4.Documentreference,
  client: FhirClient,
) -> Result(r4.Documentreference, ReqError) {
  any_update(
    resource.id,
    r4.documentreference_to_json(resource),
    "DocumentReference",
    r4.documentreference_decoder(),
    client,
  )
}

pub fn documentreference_delete(
  resource: r4.Documentreference,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "DocumentReference", client)
}

pub fn domainresource_create(
  resource: r4.Domainresource,
  client: FhirClient,
) -> Result(r4.Domainresource, ReqError) {
  any_create(
    r4.domainresource_to_json(resource),
    "DomainResource",
    r4.domainresource_decoder(),
    client,
  )
}

pub fn domainresource_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Domainresource, ReqError) {
  any_read(id, client, "DomainResource", r4.domainresource_decoder())
}

pub fn domainresource_update(
  resource: r4.Domainresource,
  client: FhirClient,
) -> Result(r4.Domainresource, ReqError) {
  any_update(
    resource.id,
    r4.domainresource_to_json(resource),
    "DomainResource",
    r4.domainresource_decoder(),
    client,
  )
}

pub fn domainresource_delete(
  resource: r4.Domainresource,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "DomainResource", client)
}

pub fn effectevidencesynthesis_create(
  resource: r4.Effectevidencesynthesis,
  client: FhirClient,
) -> Result(r4.Effectevidencesynthesis, ReqError) {
  any_create(
    r4.effectevidencesynthesis_to_json(resource),
    "EffectEvidenceSynthesis",
    r4.effectevidencesynthesis_decoder(),
    client,
  )
}

pub fn effectevidencesynthesis_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Effectevidencesynthesis, ReqError) {
  any_read(
    id,
    client,
    "EffectEvidenceSynthesis",
    r4.effectevidencesynthesis_decoder(),
  )
}

pub fn effectevidencesynthesis_update(
  resource: r4.Effectevidencesynthesis,
  client: FhirClient,
) -> Result(r4.Effectevidencesynthesis, ReqError) {
  any_update(
    resource.id,
    r4.effectevidencesynthesis_to_json(resource),
    "EffectEvidenceSynthesis",
    r4.effectevidencesynthesis_decoder(),
    client,
  )
}

pub fn effectevidencesynthesis_delete(
  resource: r4.Effectevidencesynthesis,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "EffectEvidenceSynthesis", client)
}

pub fn encounter_create(
  resource: r4.Encounter,
  client: FhirClient,
) -> Result(r4.Encounter, ReqError) {
  any_create(
    r4.encounter_to_json(resource),
    "Encounter",
    r4.encounter_decoder(),
    client,
  )
}

pub fn encounter_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Encounter, ReqError) {
  any_read(id, client, "Encounter", r4.encounter_decoder())
}

pub fn encounter_update(
  resource: r4.Encounter,
  client: FhirClient,
) -> Result(r4.Encounter, ReqError) {
  any_update(
    resource.id,
    r4.encounter_to_json(resource),
    "Encounter",
    r4.encounter_decoder(),
    client,
  )
}

pub fn encounter_delete(
  resource: r4.Encounter,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Encounter", client)
}

pub fn endpoint_create(
  resource: r4.Endpoint,
  client: FhirClient,
) -> Result(r4.Endpoint, ReqError) {
  any_create(
    r4.endpoint_to_json(resource),
    "Endpoint",
    r4.endpoint_decoder(),
    client,
  )
}

pub fn endpoint_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Endpoint, ReqError) {
  any_read(id, client, "Endpoint", r4.endpoint_decoder())
}

pub fn endpoint_update(
  resource: r4.Endpoint,
  client: FhirClient,
) -> Result(r4.Endpoint, ReqError) {
  any_update(
    resource.id,
    r4.endpoint_to_json(resource),
    "Endpoint",
    r4.endpoint_decoder(),
    client,
  )
}

pub fn endpoint_delete(
  resource: r4.Endpoint,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Endpoint", client)
}

pub fn enrollmentrequest_create(
  resource: r4.Enrollmentrequest,
  client: FhirClient,
) -> Result(r4.Enrollmentrequest, ReqError) {
  any_create(
    r4.enrollmentrequest_to_json(resource),
    "EnrollmentRequest",
    r4.enrollmentrequest_decoder(),
    client,
  )
}

pub fn enrollmentrequest_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Enrollmentrequest, ReqError) {
  any_read(id, client, "EnrollmentRequest", r4.enrollmentrequest_decoder())
}

pub fn enrollmentrequest_update(
  resource: r4.Enrollmentrequest,
  client: FhirClient,
) -> Result(r4.Enrollmentrequest, ReqError) {
  any_update(
    resource.id,
    r4.enrollmentrequest_to_json(resource),
    "EnrollmentRequest",
    r4.enrollmentrequest_decoder(),
    client,
  )
}

pub fn enrollmentrequest_delete(
  resource: r4.Enrollmentrequest,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "EnrollmentRequest", client)
}

pub fn enrollmentresponse_create(
  resource: r4.Enrollmentresponse,
  client: FhirClient,
) -> Result(r4.Enrollmentresponse, ReqError) {
  any_create(
    r4.enrollmentresponse_to_json(resource),
    "EnrollmentResponse",
    r4.enrollmentresponse_decoder(),
    client,
  )
}

pub fn enrollmentresponse_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Enrollmentresponse, ReqError) {
  any_read(id, client, "EnrollmentResponse", r4.enrollmentresponse_decoder())
}

pub fn enrollmentresponse_update(
  resource: r4.Enrollmentresponse,
  client: FhirClient,
) -> Result(r4.Enrollmentresponse, ReqError) {
  any_update(
    resource.id,
    r4.enrollmentresponse_to_json(resource),
    "EnrollmentResponse",
    r4.enrollmentresponse_decoder(),
    client,
  )
}

pub fn enrollmentresponse_delete(
  resource: r4.Enrollmentresponse,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "EnrollmentResponse", client)
}

pub fn episodeofcare_create(
  resource: r4.Episodeofcare,
  client: FhirClient,
) -> Result(r4.Episodeofcare, ReqError) {
  any_create(
    r4.episodeofcare_to_json(resource),
    "EpisodeOfCare",
    r4.episodeofcare_decoder(),
    client,
  )
}

pub fn episodeofcare_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Episodeofcare, ReqError) {
  any_read(id, client, "EpisodeOfCare", r4.episodeofcare_decoder())
}

pub fn episodeofcare_update(
  resource: r4.Episodeofcare,
  client: FhirClient,
) -> Result(r4.Episodeofcare, ReqError) {
  any_update(
    resource.id,
    r4.episodeofcare_to_json(resource),
    "EpisodeOfCare",
    r4.episodeofcare_decoder(),
    client,
  )
}

pub fn episodeofcare_delete(
  resource: r4.Episodeofcare,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "EpisodeOfCare", client)
}

pub fn eventdefinition_create(
  resource: r4.Eventdefinition,
  client: FhirClient,
) -> Result(r4.Eventdefinition, ReqError) {
  any_create(
    r4.eventdefinition_to_json(resource),
    "EventDefinition",
    r4.eventdefinition_decoder(),
    client,
  )
}

pub fn eventdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Eventdefinition, ReqError) {
  any_read(id, client, "EventDefinition", r4.eventdefinition_decoder())
}

pub fn eventdefinition_update(
  resource: r4.Eventdefinition,
  client: FhirClient,
) -> Result(r4.Eventdefinition, ReqError) {
  any_update(
    resource.id,
    r4.eventdefinition_to_json(resource),
    "EventDefinition",
    r4.eventdefinition_decoder(),
    client,
  )
}

pub fn eventdefinition_delete(
  resource: r4.Eventdefinition,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "EventDefinition", client)
}

pub fn evidence_create(
  resource: r4.Evidence,
  client: FhirClient,
) -> Result(r4.Evidence, ReqError) {
  any_create(
    r4.evidence_to_json(resource),
    "Evidence",
    r4.evidence_decoder(),
    client,
  )
}

pub fn evidence_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Evidence, ReqError) {
  any_read(id, client, "Evidence", r4.evidence_decoder())
}

pub fn evidence_update(
  resource: r4.Evidence,
  client: FhirClient,
) -> Result(r4.Evidence, ReqError) {
  any_update(
    resource.id,
    r4.evidence_to_json(resource),
    "Evidence",
    r4.evidence_decoder(),
    client,
  )
}

pub fn evidence_delete(
  resource: r4.Evidence,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Evidence", client)
}

pub fn evidencevariable_create(
  resource: r4.Evidencevariable,
  client: FhirClient,
) -> Result(r4.Evidencevariable, ReqError) {
  any_create(
    r4.evidencevariable_to_json(resource),
    "EvidenceVariable",
    r4.evidencevariable_decoder(),
    client,
  )
}

pub fn evidencevariable_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Evidencevariable, ReqError) {
  any_read(id, client, "EvidenceVariable", r4.evidencevariable_decoder())
}

pub fn evidencevariable_update(
  resource: r4.Evidencevariable,
  client: FhirClient,
) -> Result(r4.Evidencevariable, ReqError) {
  any_update(
    resource.id,
    r4.evidencevariable_to_json(resource),
    "EvidenceVariable",
    r4.evidencevariable_decoder(),
    client,
  )
}

pub fn evidencevariable_delete(
  resource: r4.Evidencevariable,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "EvidenceVariable", client)
}

pub fn examplescenario_create(
  resource: r4.Examplescenario,
  client: FhirClient,
) -> Result(r4.Examplescenario, ReqError) {
  any_create(
    r4.examplescenario_to_json(resource),
    "ExampleScenario",
    r4.examplescenario_decoder(),
    client,
  )
}

pub fn examplescenario_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Examplescenario, ReqError) {
  any_read(id, client, "ExampleScenario", r4.examplescenario_decoder())
}

pub fn examplescenario_update(
  resource: r4.Examplescenario,
  client: FhirClient,
) -> Result(r4.Examplescenario, ReqError) {
  any_update(
    resource.id,
    r4.examplescenario_to_json(resource),
    "ExampleScenario",
    r4.examplescenario_decoder(),
    client,
  )
}

pub fn examplescenario_delete(
  resource: r4.Examplescenario,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "ExampleScenario", client)
}

pub fn explanationofbenefit_create(
  resource: r4.Explanationofbenefit,
  client: FhirClient,
) -> Result(r4.Explanationofbenefit, ReqError) {
  any_create(
    r4.explanationofbenefit_to_json(resource),
    "ExplanationOfBenefit",
    r4.explanationofbenefit_decoder(),
    client,
  )
}

pub fn explanationofbenefit_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Explanationofbenefit, ReqError) {
  any_read(
    id,
    client,
    "ExplanationOfBenefit",
    r4.explanationofbenefit_decoder(),
  )
}

pub fn explanationofbenefit_update(
  resource: r4.Explanationofbenefit,
  client: FhirClient,
) -> Result(r4.Explanationofbenefit, ReqError) {
  any_update(
    resource.id,
    r4.explanationofbenefit_to_json(resource),
    "ExplanationOfBenefit",
    r4.explanationofbenefit_decoder(),
    client,
  )
}

pub fn explanationofbenefit_delete(
  resource: r4.Explanationofbenefit,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "ExplanationOfBenefit", client)
}

pub fn familymemberhistory_create(
  resource: r4.Familymemberhistory,
  client: FhirClient,
) -> Result(r4.Familymemberhistory, ReqError) {
  any_create(
    r4.familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    r4.familymemberhistory_decoder(),
    client,
  )
}

pub fn familymemberhistory_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Familymemberhistory, ReqError) {
  any_read(id, client, "FamilyMemberHistory", r4.familymemberhistory_decoder())
}

pub fn familymemberhistory_update(
  resource: r4.Familymemberhistory,
  client: FhirClient,
) -> Result(r4.Familymemberhistory, ReqError) {
  any_update(
    resource.id,
    r4.familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    r4.familymemberhistory_decoder(),
    client,
  )
}

pub fn familymemberhistory_delete(
  resource: r4.Familymemberhistory,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "FamilyMemberHistory", client)
}

pub fn flag_create(
  resource: r4.Flag,
  client: FhirClient,
) -> Result(r4.Flag, ReqError) {
  any_create(r4.flag_to_json(resource), "Flag", r4.flag_decoder(), client)
}

pub fn flag_read(id: String, client: FhirClient) -> Result(r4.Flag, ReqError) {
  any_read(id, client, "Flag", r4.flag_decoder())
}

pub fn flag_update(
  resource: r4.Flag,
  client: FhirClient,
) -> Result(r4.Flag, ReqError) {
  any_update(
    resource.id,
    r4.flag_to_json(resource),
    "Flag",
    r4.flag_decoder(),
    client,
  )
}

pub fn flag_delete(
  resource: r4.Flag,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Flag", client)
}

pub fn goal_create(
  resource: r4.Goal,
  client: FhirClient,
) -> Result(r4.Goal, ReqError) {
  any_create(r4.goal_to_json(resource), "Goal", r4.goal_decoder(), client)
}

pub fn goal_read(id: String, client: FhirClient) -> Result(r4.Goal, ReqError) {
  any_read(id, client, "Goal", r4.goal_decoder())
}

pub fn goal_update(
  resource: r4.Goal,
  client: FhirClient,
) -> Result(r4.Goal, ReqError) {
  any_update(
    resource.id,
    r4.goal_to_json(resource),
    "Goal",
    r4.goal_decoder(),
    client,
  )
}

pub fn goal_delete(
  resource: r4.Goal,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Goal", client)
}

pub fn graphdefinition_create(
  resource: r4.Graphdefinition,
  client: FhirClient,
) -> Result(r4.Graphdefinition, ReqError) {
  any_create(
    r4.graphdefinition_to_json(resource),
    "GraphDefinition",
    r4.graphdefinition_decoder(),
    client,
  )
}

pub fn graphdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Graphdefinition, ReqError) {
  any_read(id, client, "GraphDefinition", r4.graphdefinition_decoder())
}

pub fn graphdefinition_update(
  resource: r4.Graphdefinition,
  client: FhirClient,
) -> Result(r4.Graphdefinition, ReqError) {
  any_update(
    resource.id,
    r4.graphdefinition_to_json(resource),
    "GraphDefinition",
    r4.graphdefinition_decoder(),
    client,
  )
}

pub fn graphdefinition_delete(
  resource: r4.Graphdefinition,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "GraphDefinition", client)
}

pub fn group_create(
  resource: r4.Group,
  client: FhirClient,
) -> Result(r4.Group, ReqError) {
  any_create(r4.group_to_json(resource), "Group", r4.group_decoder(), client)
}

pub fn group_read(id: String, client: FhirClient) -> Result(r4.Group, ReqError) {
  any_read(id, client, "Group", r4.group_decoder())
}

pub fn group_update(
  resource: r4.Group,
  client: FhirClient,
) -> Result(r4.Group, ReqError) {
  any_update(
    resource.id,
    r4.group_to_json(resource),
    "Group",
    r4.group_decoder(),
    client,
  )
}

pub fn group_delete(
  resource: r4.Group,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Group", client)
}

pub fn guidanceresponse_create(
  resource: r4.Guidanceresponse,
  client: FhirClient,
) -> Result(r4.Guidanceresponse, ReqError) {
  any_create(
    r4.guidanceresponse_to_json(resource),
    "GuidanceResponse",
    r4.guidanceresponse_decoder(),
    client,
  )
}

pub fn guidanceresponse_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Guidanceresponse, ReqError) {
  any_read(id, client, "GuidanceResponse", r4.guidanceresponse_decoder())
}

pub fn guidanceresponse_update(
  resource: r4.Guidanceresponse,
  client: FhirClient,
) -> Result(r4.Guidanceresponse, ReqError) {
  any_update(
    resource.id,
    r4.guidanceresponse_to_json(resource),
    "GuidanceResponse",
    r4.guidanceresponse_decoder(),
    client,
  )
}

pub fn guidanceresponse_delete(
  resource: r4.Guidanceresponse,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "GuidanceResponse", client)
}

pub fn healthcareservice_create(
  resource: r4.Healthcareservice,
  client: FhirClient,
) -> Result(r4.Healthcareservice, ReqError) {
  any_create(
    r4.healthcareservice_to_json(resource),
    "HealthcareService",
    r4.healthcareservice_decoder(),
    client,
  )
}

pub fn healthcareservice_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Healthcareservice, ReqError) {
  any_read(id, client, "HealthcareService", r4.healthcareservice_decoder())
}

pub fn healthcareservice_update(
  resource: r4.Healthcareservice,
  client: FhirClient,
) -> Result(r4.Healthcareservice, ReqError) {
  any_update(
    resource.id,
    r4.healthcareservice_to_json(resource),
    "HealthcareService",
    r4.healthcareservice_decoder(),
    client,
  )
}

pub fn healthcareservice_delete(
  resource: r4.Healthcareservice,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "HealthcareService", client)
}

pub fn imagingstudy_create(
  resource: r4.Imagingstudy,
  client: FhirClient,
) -> Result(r4.Imagingstudy, ReqError) {
  any_create(
    r4.imagingstudy_to_json(resource),
    "ImagingStudy",
    r4.imagingstudy_decoder(),
    client,
  )
}

pub fn imagingstudy_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Imagingstudy, ReqError) {
  any_read(id, client, "ImagingStudy", r4.imagingstudy_decoder())
}

pub fn imagingstudy_update(
  resource: r4.Imagingstudy,
  client: FhirClient,
) -> Result(r4.Imagingstudy, ReqError) {
  any_update(
    resource.id,
    r4.imagingstudy_to_json(resource),
    "ImagingStudy",
    r4.imagingstudy_decoder(),
    client,
  )
}

pub fn imagingstudy_delete(
  resource: r4.Imagingstudy,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "ImagingStudy", client)
}

pub fn immunization_create(
  resource: r4.Immunization,
  client: FhirClient,
) -> Result(r4.Immunization, ReqError) {
  any_create(
    r4.immunization_to_json(resource),
    "Immunization",
    r4.immunization_decoder(),
    client,
  )
}

pub fn immunization_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Immunization, ReqError) {
  any_read(id, client, "Immunization", r4.immunization_decoder())
}

pub fn immunization_update(
  resource: r4.Immunization,
  client: FhirClient,
) -> Result(r4.Immunization, ReqError) {
  any_update(
    resource.id,
    r4.immunization_to_json(resource),
    "Immunization",
    r4.immunization_decoder(),
    client,
  )
}

pub fn immunization_delete(
  resource: r4.Immunization,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Immunization", client)
}

pub fn immunizationevaluation_create(
  resource: r4.Immunizationevaluation,
  client: FhirClient,
) -> Result(r4.Immunizationevaluation, ReqError) {
  any_create(
    r4.immunizationevaluation_to_json(resource),
    "ImmunizationEvaluation",
    r4.immunizationevaluation_decoder(),
    client,
  )
}

pub fn immunizationevaluation_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Immunizationevaluation, ReqError) {
  any_read(
    id,
    client,
    "ImmunizationEvaluation",
    r4.immunizationevaluation_decoder(),
  )
}

pub fn immunizationevaluation_update(
  resource: r4.Immunizationevaluation,
  client: FhirClient,
) -> Result(r4.Immunizationevaluation, ReqError) {
  any_update(
    resource.id,
    r4.immunizationevaluation_to_json(resource),
    "ImmunizationEvaluation",
    r4.immunizationevaluation_decoder(),
    client,
  )
}

pub fn immunizationevaluation_delete(
  resource: r4.Immunizationevaluation,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "ImmunizationEvaluation", client)
}

pub fn immunizationrecommendation_create(
  resource: r4.Immunizationrecommendation,
  client: FhirClient,
) -> Result(r4.Immunizationrecommendation, ReqError) {
  any_create(
    r4.immunizationrecommendation_to_json(resource),
    "ImmunizationRecommendation",
    r4.immunizationrecommendation_decoder(),
    client,
  )
}

pub fn immunizationrecommendation_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Immunizationrecommendation, ReqError) {
  any_read(
    id,
    client,
    "ImmunizationRecommendation",
    r4.immunizationrecommendation_decoder(),
  )
}

pub fn immunizationrecommendation_update(
  resource: r4.Immunizationrecommendation,
  client: FhirClient,
) -> Result(r4.Immunizationrecommendation, ReqError) {
  any_update(
    resource.id,
    r4.immunizationrecommendation_to_json(resource),
    "ImmunizationRecommendation",
    r4.immunizationrecommendation_decoder(),
    client,
  )
}

pub fn immunizationrecommendation_delete(
  resource: r4.Immunizationrecommendation,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "ImmunizationRecommendation", client)
}

pub fn implementationguide_create(
  resource: r4.Implementationguide,
  client: FhirClient,
) -> Result(r4.Implementationguide, ReqError) {
  any_create(
    r4.implementationguide_to_json(resource),
    "ImplementationGuide",
    r4.implementationguide_decoder(),
    client,
  )
}

pub fn implementationguide_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Implementationguide, ReqError) {
  any_read(id, client, "ImplementationGuide", r4.implementationguide_decoder())
}

pub fn implementationguide_update(
  resource: r4.Implementationguide,
  client: FhirClient,
) -> Result(r4.Implementationguide, ReqError) {
  any_update(
    resource.id,
    r4.implementationguide_to_json(resource),
    "ImplementationGuide",
    r4.implementationguide_decoder(),
    client,
  )
}

pub fn implementationguide_delete(
  resource: r4.Implementationguide,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "ImplementationGuide", client)
}

pub fn insuranceplan_create(
  resource: r4.Insuranceplan,
  client: FhirClient,
) -> Result(r4.Insuranceplan, ReqError) {
  any_create(
    r4.insuranceplan_to_json(resource),
    "InsurancePlan",
    r4.insuranceplan_decoder(),
    client,
  )
}

pub fn insuranceplan_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Insuranceplan, ReqError) {
  any_read(id, client, "InsurancePlan", r4.insuranceplan_decoder())
}

pub fn insuranceplan_update(
  resource: r4.Insuranceplan,
  client: FhirClient,
) -> Result(r4.Insuranceplan, ReqError) {
  any_update(
    resource.id,
    r4.insuranceplan_to_json(resource),
    "InsurancePlan",
    r4.insuranceplan_decoder(),
    client,
  )
}

pub fn insuranceplan_delete(
  resource: r4.Insuranceplan,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "InsurancePlan", client)
}

pub fn invoice_create(
  resource: r4.Invoice,
  client: FhirClient,
) -> Result(r4.Invoice, ReqError) {
  any_create(
    r4.invoice_to_json(resource),
    "Invoice",
    r4.invoice_decoder(),
    client,
  )
}

pub fn invoice_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Invoice, ReqError) {
  any_read(id, client, "Invoice", r4.invoice_decoder())
}

pub fn invoice_update(
  resource: r4.Invoice,
  client: FhirClient,
) -> Result(r4.Invoice, ReqError) {
  any_update(
    resource.id,
    r4.invoice_to_json(resource),
    "Invoice",
    r4.invoice_decoder(),
    client,
  )
}

pub fn invoice_delete(
  resource: r4.Invoice,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Invoice", client)
}

pub fn library_create(
  resource: r4.Library,
  client: FhirClient,
) -> Result(r4.Library, ReqError) {
  any_create(
    r4.library_to_json(resource),
    "Library",
    r4.library_decoder(),
    client,
  )
}

pub fn library_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Library, ReqError) {
  any_read(id, client, "Library", r4.library_decoder())
}

pub fn library_update(
  resource: r4.Library,
  client: FhirClient,
) -> Result(r4.Library, ReqError) {
  any_update(
    resource.id,
    r4.library_to_json(resource),
    "Library",
    r4.library_decoder(),
    client,
  )
}

pub fn library_delete(
  resource: r4.Library,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Library", client)
}

pub fn linkage_create(
  resource: r4.Linkage,
  client: FhirClient,
) -> Result(r4.Linkage, ReqError) {
  any_create(
    r4.linkage_to_json(resource),
    "Linkage",
    r4.linkage_decoder(),
    client,
  )
}

pub fn linkage_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Linkage, ReqError) {
  any_read(id, client, "Linkage", r4.linkage_decoder())
}

pub fn linkage_update(
  resource: r4.Linkage,
  client: FhirClient,
) -> Result(r4.Linkage, ReqError) {
  any_update(
    resource.id,
    r4.linkage_to_json(resource),
    "Linkage",
    r4.linkage_decoder(),
    client,
  )
}

pub fn linkage_delete(
  resource: r4.Linkage,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Linkage", client)
}

pub fn listfhir_create(
  resource: r4.Listfhir,
  client: FhirClient,
) -> Result(r4.Listfhir, ReqError) {
  any_create(
    r4.listfhir_to_json(resource),
    "List",
    r4.listfhir_decoder(),
    client,
  )
}

pub fn listfhir_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Listfhir, ReqError) {
  any_read(id, client, "List", r4.listfhir_decoder())
}

pub fn listfhir_update(
  resource: r4.Listfhir,
  client: FhirClient,
) -> Result(r4.Listfhir, ReqError) {
  any_update(
    resource.id,
    r4.listfhir_to_json(resource),
    "List",
    r4.listfhir_decoder(),
    client,
  )
}

pub fn listfhir_delete(
  resource: r4.Listfhir,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "List", client)
}

pub fn location_create(
  resource: r4.Location,
  client: FhirClient,
) -> Result(r4.Location, ReqError) {
  any_create(
    r4.location_to_json(resource),
    "Location",
    r4.location_decoder(),
    client,
  )
}

pub fn location_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Location, ReqError) {
  any_read(id, client, "Location", r4.location_decoder())
}

pub fn location_update(
  resource: r4.Location,
  client: FhirClient,
) -> Result(r4.Location, ReqError) {
  any_update(
    resource.id,
    r4.location_to_json(resource),
    "Location",
    r4.location_decoder(),
    client,
  )
}

pub fn location_delete(
  resource: r4.Location,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Location", client)
}

pub fn measure_create(
  resource: r4.Measure,
  client: FhirClient,
) -> Result(r4.Measure, ReqError) {
  any_create(
    r4.measure_to_json(resource),
    "Measure",
    r4.measure_decoder(),
    client,
  )
}

pub fn measure_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Measure, ReqError) {
  any_read(id, client, "Measure", r4.measure_decoder())
}

pub fn measure_update(
  resource: r4.Measure,
  client: FhirClient,
) -> Result(r4.Measure, ReqError) {
  any_update(
    resource.id,
    r4.measure_to_json(resource),
    "Measure",
    r4.measure_decoder(),
    client,
  )
}

pub fn measure_delete(
  resource: r4.Measure,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Measure", client)
}

pub fn measurereport_create(
  resource: r4.Measurereport,
  client: FhirClient,
) -> Result(r4.Measurereport, ReqError) {
  any_create(
    r4.measurereport_to_json(resource),
    "MeasureReport",
    r4.measurereport_decoder(),
    client,
  )
}

pub fn measurereport_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Measurereport, ReqError) {
  any_read(id, client, "MeasureReport", r4.measurereport_decoder())
}

pub fn measurereport_update(
  resource: r4.Measurereport,
  client: FhirClient,
) -> Result(r4.Measurereport, ReqError) {
  any_update(
    resource.id,
    r4.measurereport_to_json(resource),
    "MeasureReport",
    r4.measurereport_decoder(),
    client,
  )
}

pub fn measurereport_delete(
  resource: r4.Measurereport,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "MeasureReport", client)
}

pub fn media_create(
  resource: r4.Media,
  client: FhirClient,
) -> Result(r4.Media, ReqError) {
  any_create(r4.media_to_json(resource), "Media", r4.media_decoder(), client)
}

pub fn media_read(id: String, client: FhirClient) -> Result(r4.Media, ReqError) {
  any_read(id, client, "Media", r4.media_decoder())
}

pub fn media_update(
  resource: r4.Media,
  client: FhirClient,
) -> Result(r4.Media, ReqError) {
  any_update(
    resource.id,
    r4.media_to_json(resource),
    "Media",
    r4.media_decoder(),
    client,
  )
}

pub fn media_delete(
  resource: r4.Media,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Media", client)
}

pub fn medication_create(
  resource: r4.Medication,
  client: FhirClient,
) -> Result(r4.Medication, ReqError) {
  any_create(
    r4.medication_to_json(resource),
    "Medication",
    r4.medication_decoder(),
    client,
  )
}

pub fn medication_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Medication, ReqError) {
  any_read(id, client, "Medication", r4.medication_decoder())
}

pub fn medication_update(
  resource: r4.Medication,
  client: FhirClient,
) -> Result(r4.Medication, ReqError) {
  any_update(
    resource.id,
    r4.medication_to_json(resource),
    "Medication",
    r4.medication_decoder(),
    client,
  )
}

pub fn medication_delete(
  resource: r4.Medication,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Medication", client)
}

pub fn medicationadministration_create(
  resource: r4.Medicationadministration,
  client: FhirClient,
) -> Result(r4.Medicationadministration, ReqError) {
  any_create(
    r4.medicationadministration_to_json(resource),
    "MedicationAdministration",
    r4.medicationadministration_decoder(),
    client,
  )
}

pub fn medicationadministration_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Medicationadministration, ReqError) {
  any_read(
    id,
    client,
    "MedicationAdministration",
    r4.medicationadministration_decoder(),
  )
}

pub fn medicationadministration_update(
  resource: r4.Medicationadministration,
  client: FhirClient,
) -> Result(r4.Medicationadministration, ReqError) {
  any_update(
    resource.id,
    r4.medicationadministration_to_json(resource),
    "MedicationAdministration",
    r4.medicationadministration_decoder(),
    client,
  )
}

pub fn medicationadministration_delete(
  resource: r4.Medicationadministration,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "MedicationAdministration", client)
}

pub fn medicationdispense_create(
  resource: r4.Medicationdispense,
  client: FhirClient,
) -> Result(r4.Medicationdispense, ReqError) {
  any_create(
    r4.medicationdispense_to_json(resource),
    "MedicationDispense",
    r4.medicationdispense_decoder(),
    client,
  )
}

pub fn medicationdispense_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Medicationdispense, ReqError) {
  any_read(id, client, "MedicationDispense", r4.medicationdispense_decoder())
}

pub fn medicationdispense_update(
  resource: r4.Medicationdispense,
  client: FhirClient,
) -> Result(r4.Medicationdispense, ReqError) {
  any_update(
    resource.id,
    r4.medicationdispense_to_json(resource),
    "MedicationDispense",
    r4.medicationdispense_decoder(),
    client,
  )
}

pub fn medicationdispense_delete(
  resource: r4.Medicationdispense,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "MedicationDispense", client)
}

pub fn medicationknowledge_create(
  resource: r4.Medicationknowledge,
  client: FhirClient,
) -> Result(r4.Medicationknowledge, ReqError) {
  any_create(
    r4.medicationknowledge_to_json(resource),
    "MedicationKnowledge",
    r4.medicationknowledge_decoder(),
    client,
  )
}

pub fn medicationknowledge_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Medicationknowledge, ReqError) {
  any_read(id, client, "MedicationKnowledge", r4.medicationknowledge_decoder())
}

pub fn medicationknowledge_update(
  resource: r4.Medicationknowledge,
  client: FhirClient,
) -> Result(r4.Medicationknowledge, ReqError) {
  any_update(
    resource.id,
    r4.medicationknowledge_to_json(resource),
    "MedicationKnowledge",
    r4.medicationknowledge_decoder(),
    client,
  )
}

pub fn medicationknowledge_delete(
  resource: r4.Medicationknowledge,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "MedicationKnowledge", client)
}

pub fn medicationrequest_create(
  resource: r4.Medicationrequest,
  client: FhirClient,
) -> Result(r4.Medicationrequest, ReqError) {
  any_create(
    r4.medicationrequest_to_json(resource),
    "MedicationRequest",
    r4.medicationrequest_decoder(),
    client,
  )
}

pub fn medicationrequest_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Medicationrequest, ReqError) {
  any_read(id, client, "MedicationRequest", r4.medicationrequest_decoder())
}

pub fn medicationrequest_update(
  resource: r4.Medicationrequest,
  client: FhirClient,
) -> Result(r4.Medicationrequest, ReqError) {
  any_update(
    resource.id,
    r4.medicationrequest_to_json(resource),
    "MedicationRequest",
    r4.medicationrequest_decoder(),
    client,
  )
}

pub fn medicationrequest_delete(
  resource: r4.Medicationrequest,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "MedicationRequest", client)
}

pub fn medicationstatement_create(
  resource: r4.Medicationstatement,
  client: FhirClient,
) -> Result(r4.Medicationstatement, ReqError) {
  any_create(
    r4.medicationstatement_to_json(resource),
    "MedicationStatement",
    r4.medicationstatement_decoder(),
    client,
  )
}

pub fn medicationstatement_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Medicationstatement, ReqError) {
  any_read(id, client, "MedicationStatement", r4.medicationstatement_decoder())
}

pub fn medicationstatement_update(
  resource: r4.Medicationstatement,
  client: FhirClient,
) -> Result(r4.Medicationstatement, ReqError) {
  any_update(
    resource.id,
    r4.medicationstatement_to_json(resource),
    "MedicationStatement",
    r4.medicationstatement_decoder(),
    client,
  )
}

pub fn medicationstatement_delete(
  resource: r4.Medicationstatement,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "MedicationStatement", client)
}

pub fn medicinalproduct_create(
  resource: r4.Medicinalproduct,
  client: FhirClient,
) -> Result(r4.Medicinalproduct, ReqError) {
  any_create(
    r4.medicinalproduct_to_json(resource),
    "MedicinalProduct",
    r4.medicinalproduct_decoder(),
    client,
  )
}

pub fn medicinalproduct_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Medicinalproduct, ReqError) {
  any_read(id, client, "MedicinalProduct", r4.medicinalproduct_decoder())
}

pub fn medicinalproduct_update(
  resource: r4.Medicinalproduct,
  client: FhirClient,
) -> Result(r4.Medicinalproduct, ReqError) {
  any_update(
    resource.id,
    r4.medicinalproduct_to_json(resource),
    "MedicinalProduct",
    r4.medicinalproduct_decoder(),
    client,
  )
}

pub fn medicinalproduct_delete(
  resource: r4.Medicinalproduct,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "MedicinalProduct", client)
}

pub fn medicinalproductauthorization_create(
  resource: r4.Medicinalproductauthorization,
  client: FhirClient,
) -> Result(r4.Medicinalproductauthorization, ReqError) {
  any_create(
    r4.medicinalproductauthorization_to_json(resource),
    "MedicinalProductAuthorization",
    r4.medicinalproductauthorization_decoder(),
    client,
  )
}

pub fn medicinalproductauthorization_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Medicinalproductauthorization, ReqError) {
  any_read(
    id,
    client,
    "MedicinalProductAuthorization",
    r4.medicinalproductauthorization_decoder(),
  )
}

pub fn medicinalproductauthorization_update(
  resource: r4.Medicinalproductauthorization,
  client: FhirClient,
) -> Result(r4.Medicinalproductauthorization, ReqError) {
  any_update(
    resource.id,
    r4.medicinalproductauthorization_to_json(resource),
    "MedicinalProductAuthorization",
    r4.medicinalproductauthorization_decoder(),
    client,
  )
}

pub fn medicinalproductauthorization_delete(
  resource: r4.Medicinalproductauthorization,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "MedicinalProductAuthorization", client)
}

pub fn medicinalproductcontraindication_create(
  resource: r4.Medicinalproductcontraindication,
  client: FhirClient,
) -> Result(r4.Medicinalproductcontraindication, ReqError) {
  any_create(
    r4.medicinalproductcontraindication_to_json(resource),
    "MedicinalProductContraindication",
    r4.medicinalproductcontraindication_decoder(),
    client,
  )
}

pub fn medicinalproductcontraindication_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Medicinalproductcontraindication, ReqError) {
  any_read(
    id,
    client,
    "MedicinalProductContraindication",
    r4.medicinalproductcontraindication_decoder(),
  )
}

pub fn medicinalproductcontraindication_update(
  resource: r4.Medicinalproductcontraindication,
  client: FhirClient,
) -> Result(r4.Medicinalproductcontraindication, ReqError) {
  any_update(
    resource.id,
    r4.medicinalproductcontraindication_to_json(resource),
    "MedicinalProductContraindication",
    r4.medicinalproductcontraindication_decoder(),
    client,
  )
}

pub fn medicinalproductcontraindication_delete(
  resource: r4.Medicinalproductcontraindication,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "MedicinalProductContraindication", client)
}

pub fn medicinalproductindication_create(
  resource: r4.Medicinalproductindication,
  client: FhirClient,
) -> Result(r4.Medicinalproductindication, ReqError) {
  any_create(
    r4.medicinalproductindication_to_json(resource),
    "MedicinalProductIndication",
    r4.medicinalproductindication_decoder(),
    client,
  )
}

pub fn medicinalproductindication_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Medicinalproductindication, ReqError) {
  any_read(
    id,
    client,
    "MedicinalProductIndication",
    r4.medicinalproductindication_decoder(),
  )
}

pub fn medicinalproductindication_update(
  resource: r4.Medicinalproductindication,
  client: FhirClient,
) -> Result(r4.Medicinalproductindication, ReqError) {
  any_update(
    resource.id,
    r4.medicinalproductindication_to_json(resource),
    "MedicinalProductIndication",
    r4.medicinalproductindication_decoder(),
    client,
  )
}

pub fn medicinalproductindication_delete(
  resource: r4.Medicinalproductindication,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "MedicinalProductIndication", client)
}

pub fn medicinalproductingredient_create(
  resource: r4.Medicinalproductingredient,
  client: FhirClient,
) -> Result(r4.Medicinalproductingredient, ReqError) {
  any_create(
    r4.medicinalproductingredient_to_json(resource),
    "MedicinalProductIngredient",
    r4.medicinalproductingredient_decoder(),
    client,
  )
}

pub fn medicinalproductingredient_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Medicinalproductingredient, ReqError) {
  any_read(
    id,
    client,
    "MedicinalProductIngredient",
    r4.medicinalproductingredient_decoder(),
  )
}

pub fn medicinalproductingredient_update(
  resource: r4.Medicinalproductingredient,
  client: FhirClient,
) -> Result(r4.Medicinalproductingredient, ReqError) {
  any_update(
    resource.id,
    r4.medicinalproductingredient_to_json(resource),
    "MedicinalProductIngredient",
    r4.medicinalproductingredient_decoder(),
    client,
  )
}

pub fn medicinalproductingredient_delete(
  resource: r4.Medicinalproductingredient,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "MedicinalProductIngredient", client)
}

pub fn medicinalproductinteraction_create(
  resource: r4.Medicinalproductinteraction,
  client: FhirClient,
) -> Result(r4.Medicinalproductinteraction, ReqError) {
  any_create(
    r4.medicinalproductinteraction_to_json(resource),
    "MedicinalProductInteraction",
    r4.medicinalproductinteraction_decoder(),
    client,
  )
}

pub fn medicinalproductinteraction_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Medicinalproductinteraction, ReqError) {
  any_read(
    id,
    client,
    "MedicinalProductInteraction",
    r4.medicinalproductinteraction_decoder(),
  )
}

pub fn medicinalproductinteraction_update(
  resource: r4.Medicinalproductinteraction,
  client: FhirClient,
) -> Result(r4.Medicinalproductinteraction, ReqError) {
  any_update(
    resource.id,
    r4.medicinalproductinteraction_to_json(resource),
    "MedicinalProductInteraction",
    r4.medicinalproductinteraction_decoder(),
    client,
  )
}

pub fn medicinalproductinteraction_delete(
  resource: r4.Medicinalproductinteraction,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "MedicinalProductInteraction", client)
}

pub fn medicinalproductmanufactured_create(
  resource: r4.Medicinalproductmanufactured,
  client: FhirClient,
) -> Result(r4.Medicinalproductmanufactured, ReqError) {
  any_create(
    r4.medicinalproductmanufactured_to_json(resource),
    "MedicinalProductManufactured",
    r4.medicinalproductmanufactured_decoder(),
    client,
  )
}

pub fn medicinalproductmanufactured_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Medicinalproductmanufactured, ReqError) {
  any_read(
    id,
    client,
    "MedicinalProductManufactured",
    r4.medicinalproductmanufactured_decoder(),
  )
}

pub fn medicinalproductmanufactured_update(
  resource: r4.Medicinalproductmanufactured,
  client: FhirClient,
) -> Result(r4.Medicinalproductmanufactured, ReqError) {
  any_update(
    resource.id,
    r4.medicinalproductmanufactured_to_json(resource),
    "MedicinalProductManufactured",
    r4.medicinalproductmanufactured_decoder(),
    client,
  )
}

pub fn medicinalproductmanufactured_delete(
  resource: r4.Medicinalproductmanufactured,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "MedicinalProductManufactured", client)
}

pub fn medicinalproductpackaged_create(
  resource: r4.Medicinalproductpackaged,
  client: FhirClient,
) -> Result(r4.Medicinalproductpackaged, ReqError) {
  any_create(
    r4.medicinalproductpackaged_to_json(resource),
    "MedicinalProductPackaged",
    r4.medicinalproductpackaged_decoder(),
    client,
  )
}

pub fn medicinalproductpackaged_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Medicinalproductpackaged, ReqError) {
  any_read(
    id,
    client,
    "MedicinalProductPackaged",
    r4.medicinalproductpackaged_decoder(),
  )
}

pub fn medicinalproductpackaged_update(
  resource: r4.Medicinalproductpackaged,
  client: FhirClient,
) -> Result(r4.Medicinalproductpackaged, ReqError) {
  any_update(
    resource.id,
    r4.medicinalproductpackaged_to_json(resource),
    "MedicinalProductPackaged",
    r4.medicinalproductpackaged_decoder(),
    client,
  )
}

pub fn medicinalproductpackaged_delete(
  resource: r4.Medicinalproductpackaged,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "MedicinalProductPackaged", client)
}

pub fn medicinalproductpharmaceutical_create(
  resource: r4.Medicinalproductpharmaceutical,
  client: FhirClient,
) -> Result(r4.Medicinalproductpharmaceutical, ReqError) {
  any_create(
    r4.medicinalproductpharmaceutical_to_json(resource),
    "MedicinalProductPharmaceutical",
    r4.medicinalproductpharmaceutical_decoder(),
    client,
  )
}

pub fn medicinalproductpharmaceutical_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Medicinalproductpharmaceutical, ReqError) {
  any_read(
    id,
    client,
    "MedicinalProductPharmaceutical",
    r4.medicinalproductpharmaceutical_decoder(),
  )
}

pub fn medicinalproductpharmaceutical_update(
  resource: r4.Medicinalproductpharmaceutical,
  client: FhirClient,
) -> Result(r4.Medicinalproductpharmaceutical, ReqError) {
  any_update(
    resource.id,
    r4.medicinalproductpharmaceutical_to_json(resource),
    "MedicinalProductPharmaceutical",
    r4.medicinalproductpharmaceutical_decoder(),
    client,
  )
}

pub fn medicinalproductpharmaceutical_delete(
  resource: r4.Medicinalproductpharmaceutical,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "MedicinalProductPharmaceutical", client)
}

pub fn medicinalproductundesirableeffect_create(
  resource: r4.Medicinalproductundesirableeffect,
  client: FhirClient,
) -> Result(r4.Medicinalproductundesirableeffect, ReqError) {
  any_create(
    r4.medicinalproductundesirableeffect_to_json(resource),
    "MedicinalProductUndesirableEffect",
    r4.medicinalproductundesirableeffect_decoder(),
    client,
  )
}

pub fn medicinalproductundesirableeffect_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Medicinalproductundesirableeffect, ReqError) {
  any_read(
    id,
    client,
    "MedicinalProductUndesirableEffect",
    r4.medicinalproductundesirableeffect_decoder(),
  )
}

pub fn medicinalproductundesirableeffect_update(
  resource: r4.Medicinalproductundesirableeffect,
  client: FhirClient,
) -> Result(r4.Medicinalproductundesirableeffect, ReqError) {
  any_update(
    resource.id,
    r4.medicinalproductundesirableeffect_to_json(resource),
    "MedicinalProductUndesirableEffect",
    r4.medicinalproductundesirableeffect_decoder(),
    client,
  )
}

pub fn medicinalproductundesirableeffect_delete(
  resource: r4.Medicinalproductundesirableeffect,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "MedicinalProductUndesirableEffect", client)
}

pub fn messagedefinition_create(
  resource: r4.Messagedefinition,
  client: FhirClient,
) -> Result(r4.Messagedefinition, ReqError) {
  any_create(
    r4.messagedefinition_to_json(resource),
    "MessageDefinition",
    r4.messagedefinition_decoder(),
    client,
  )
}

pub fn messagedefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Messagedefinition, ReqError) {
  any_read(id, client, "MessageDefinition", r4.messagedefinition_decoder())
}

pub fn messagedefinition_update(
  resource: r4.Messagedefinition,
  client: FhirClient,
) -> Result(r4.Messagedefinition, ReqError) {
  any_update(
    resource.id,
    r4.messagedefinition_to_json(resource),
    "MessageDefinition",
    r4.messagedefinition_decoder(),
    client,
  )
}

pub fn messagedefinition_delete(
  resource: r4.Messagedefinition,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "MessageDefinition", client)
}

pub fn messageheader_create(
  resource: r4.Messageheader,
  client: FhirClient,
) -> Result(r4.Messageheader, ReqError) {
  any_create(
    r4.messageheader_to_json(resource),
    "MessageHeader",
    r4.messageheader_decoder(),
    client,
  )
}

pub fn messageheader_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Messageheader, ReqError) {
  any_read(id, client, "MessageHeader", r4.messageheader_decoder())
}

pub fn messageheader_update(
  resource: r4.Messageheader,
  client: FhirClient,
) -> Result(r4.Messageheader, ReqError) {
  any_update(
    resource.id,
    r4.messageheader_to_json(resource),
    "MessageHeader",
    r4.messageheader_decoder(),
    client,
  )
}

pub fn messageheader_delete(
  resource: r4.Messageheader,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "MessageHeader", client)
}

pub fn molecularsequence_create(
  resource: r4.Molecularsequence,
  client: FhirClient,
) -> Result(r4.Molecularsequence, ReqError) {
  any_create(
    r4.molecularsequence_to_json(resource),
    "MolecularSequence",
    r4.molecularsequence_decoder(),
    client,
  )
}

pub fn molecularsequence_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Molecularsequence, ReqError) {
  any_read(id, client, "MolecularSequence", r4.molecularsequence_decoder())
}

pub fn molecularsequence_update(
  resource: r4.Molecularsequence,
  client: FhirClient,
) -> Result(r4.Molecularsequence, ReqError) {
  any_update(
    resource.id,
    r4.molecularsequence_to_json(resource),
    "MolecularSequence",
    r4.molecularsequence_decoder(),
    client,
  )
}

pub fn molecularsequence_delete(
  resource: r4.Molecularsequence,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "MolecularSequence", client)
}

pub fn namingsystem_create(
  resource: r4.Namingsystem,
  client: FhirClient,
) -> Result(r4.Namingsystem, ReqError) {
  any_create(
    r4.namingsystem_to_json(resource),
    "NamingSystem",
    r4.namingsystem_decoder(),
    client,
  )
}

pub fn namingsystem_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Namingsystem, ReqError) {
  any_read(id, client, "NamingSystem", r4.namingsystem_decoder())
}

pub fn namingsystem_update(
  resource: r4.Namingsystem,
  client: FhirClient,
) -> Result(r4.Namingsystem, ReqError) {
  any_update(
    resource.id,
    r4.namingsystem_to_json(resource),
    "NamingSystem",
    r4.namingsystem_decoder(),
    client,
  )
}

pub fn namingsystem_delete(
  resource: r4.Namingsystem,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "NamingSystem", client)
}

pub fn nutritionorder_create(
  resource: r4.Nutritionorder,
  client: FhirClient,
) -> Result(r4.Nutritionorder, ReqError) {
  any_create(
    r4.nutritionorder_to_json(resource),
    "NutritionOrder",
    r4.nutritionorder_decoder(),
    client,
  )
}

pub fn nutritionorder_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Nutritionorder, ReqError) {
  any_read(id, client, "NutritionOrder", r4.nutritionorder_decoder())
}

pub fn nutritionorder_update(
  resource: r4.Nutritionorder,
  client: FhirClient,
) -> Result(r4.Nutritionorder, ReqError) {
  any_update(
    resource.id,
    r4.nutritionorder_to_json(resource),
    "NutritionOrder",
    r4.nutritionorder_decoder(),
    client,
  )
}

pub fn nutritionorder_delete(
  resource: r4.Nutritionorder,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "NutritionOrder", client)
}

pub fn observation_create(
  resource: r4.Observation,
  client: FhirClient,
) -> Result(r4.Observation, ReqError) {
  any_create(
    r4.observation_to_json(resource),
    "Observation",
    r4.observation_decoder(),
    client,
  )
}

pub fn observation_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Observation, ReqError) {
  any_read(id, client, "Observation", r4.observation_decoder())
}

pub fn observation_update(
  resource: r4.Observation,
  client: FhirClient,
) -> Result(r4.Observation, ReqError) {
  any_update(
    resource.id,
    r4.observation_to_json(resource),
    "Observation",
    r4.observation_decoder(),
    client,
  )
}

pub fn observation_delete(
  resource: r4.Observation,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Observation", client)
}

pub fn observationdefinition_create(
  resource: r4.Observationdefinition,
  client: FhirClient,
) -> Result(r4.Observationdefinition, ReqError) {
  any_create(
    r4.observationdefinition_to_json(resource),
    "ObservationDefinition",
    r4.observationdefinition_decoder(),
    client,
  )
}

pub fn observationdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Observationdefinition, ReqError) {
  any_read(
    id,
    client,
    "ObservationDefinition",
    r4.observationdefinition_decoder(),
  )
}

pub fn observationdefinition_update(
  resource: r4.Observationdefinition,
  client: FhirClient,
) -> Result(r4.Observationdefinition, ReqError) {
  any_update(
    resource.id,
    r4.observationdefinition_to_json(resource),
    "ObservationDefinition",
    r4.observationdefinition_decoder(),
    client,
  )
}

pub fn observationdefinition_delete(
  resource: r4.Observationdefinition,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "ObservationDefinition", client)
}

pub fn operationdefinition_create(
  resource: r4.Operationdefinition,
  client: FhirClient,
) -> Result(r4.Operationdefinition, ReqError) {
  any_create(
    r4.operationdefinition_to_json(resource),
    "OperationDefinition",
    r4.operationdefinition_decoder(),
    client,
  )
}

pub fn operationdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Operationdefinition, ReqError) {
  any_read(id, client, "OperationDefinition", r4.operationdefinition_decoder())
}

pub fn operationdefinition_update(
  resource: r4.Operationdefinition,
  client: FhirClient,
) -> Result(r4.Operationdefinition, ReqError) {
  any_update(
    resource.id,
    r4.operationdefinition_to_json(resource),
    "OperationDefinition",
    r4.operationdefinition_decoder(),
    client,
  )
}

pub fn operationdefinition_delete(
  resource: r4.Operationdefinition,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "OperationDefinition", client)
}

pub fn operationoutcome_create(
  resource: r4.Operationoutcome,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_create(
    r4.operationoutcome_to_json(resource),
    "OperationOutcome",
    r4.operationoutcome_decoder(),
    client,
  )
}

pub fn operationoutcome_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_read(id, client, "OperationOutcome", r4.operationoutcome_decoder())
}

pub fn operationoutcome_update(
  resource: r4.Operationoutcome,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_update(
    resource.id,
    r4.operationoutcome_to_json(resource),
    "OperationOutcome",
    r4.operationoutcome_decoder(),
    client,
  )
}

pub fn operationoutcome_delete(
  resource: r4.Operationoutcome,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "OperationOutcome", client)
}

pub fn organization_create(
  resource: r4.Organization,
  client: FhirClient,
) -> Result(r4.Organization, ReqError) {
  any_create(
    r4.organization_to_json(resource),
    "Organization",
    r4.organization_decoder(),
    client,
  )
}

pub fn organization_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Organization, ReqError) {
  any_read(id, client, "Organization", r4.organization_decoder())
}

pub fn organization_update(
  resource: r4.Organization,
  client: FhirClient,
) -> Result(r4.Organization, ReqError) {
  any_update(
    resource.id,
    r4.organization_to_json(resource),
    "Organization",
    r4.organization_decoder(),
    client,
  )
}

pub fn organization_delete(
  resource: r4.Organization,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Organization", client)
}

pub fn organizationaffiliation_create(
  resource: r4.Organizationaffiliation,
  client: FhirClient,
) -> Result(r4.Organizationaffiliation, ReqError) {
  any_create(
    r4.organizationaffiliation_to_json(resource),
    "OrganizationAffiliation",
    r4.organizationaffiliation_decoder(),
    client,
  )
}

pub fn organizationaffiliation_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Organizationaffiliation, ReqError) {
  any_read(
    id,
    client,
    "OrganizationAffiliation",
    r4.organizationaffiliation_decoder(),
  )
}

pub fn organizationaffiliation_update(
  resource: r4.Organizationaffiliation,
  client: FhirClient,
) -> Result(r4.Organizationaffiliation, ReqError) {
  any_update(
    resource.id,
    r4.organizationaffiliation_to_json(resource),
    "OrganizationAffiliation",
    r4.organizationaffiliation_decoder(),
    client,
  )
}

pub fn organizationaffiliation_delete(
  resource: r4.Organizationaffiliation,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "OrganizationAffiliation", client)
}

pub fn parameters_create(
  resource: r4.Parameters,
  client: FhirClient,
) -> Result(r4.Parameters, ReqError) {
  any_create(
    r4.parameters_to_json(resource),
    "Parameters",
    r4.parameters_decoder(),
    client,
  )
}

pub fn parameters_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Parameters, ReqError) {
  any_read(id, client, "Parameters", r4.parameters_decoder())
}

pub fn parameters_update(
  resource: r4.Parameters,
  client: FhirClient,
) -> Result(r4.Parameters, ReqError) {
  any_update(
    resource.id,
    r4.parameters_to_json(resource),
    "Parameters",
    r4.parameters_decoder(),
    client,
  )
}

pub fn parameters_delete(
  resource: r4.Parameters,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Parameters", client)
}

pub fn patient_create(
  resource: r4.Patient,
  client: FhirClient,
) -> Result(r4.Patient, ReqError) {
  any_create(
    r4.patient_to_json(resource),
    "Patient",
    r4.patient_decoder(),
    client,
  )
}

pub fn patient_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Patient, ReqError) {
  any_read(id, client, "Patient", r4.patient_decoder())
}

pub fn patient_update(
  resource: r4.Patient,
  client: FhirClient,
) -> Result(r4.Patient, ReqError) {
  any_update(
    resource.id,
    r4.patient_to_json(resource),
    "Patient",
    r4.patient_decoder(),
    client,
  )
}

pub fn patient_delete(
  resource: r4.Patient,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Patient", client)
}

pub fn paymentnotice_create(
  resource: r4.Paymentnotice,
  client: FhirClient,
) -> Result(r4.Paymentnotice, ReqError) {
  any_create(
    r4.paymentnotice_to_json(resource),
    "PaymentNotice",
    r4.paymentnotice_decoder(),
    client,
  )
}

pub fn paymentnotice_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Paymentnotice, ReqError) {
  any_read(id, client, "PaymentNotice", r4.paymentnotice_decoder())
}

pub fn paymentnotice_update(
  resource: r4.Paymentnotice,
  client: FhirClient,
) -> Result(r4.Paymentnotice, ReqError) {
  any_update(
    resource.id,
    r4.paymentnotice_to_json(resource),
    "PaymentNotice",
    r4.paymentnotice_decoder(),
    client,
  )
}

pub fn paymentnotice_delete(
  resource: r4.Paymentnotice,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "PaymentNotice", client)
}

pub fn paymentreconciliation_create(
  resource: r4.Paymentreconciliation,
  client: FhirClient,
) -> Result(r4.Paymentreconciliation, ReqError) {
  any_create(
    r4.paymentreconciliation_to_json(resource),
    "PaymentReconciliation",
    r4.paymentreconciliation_decoder(),
    client,
  )
}

pub fn paymentreconciliation_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Paymentreconciliation, ReqError) {
  any_read(
    id,
    client,
    "PaymentReconciliation",
    r4.paymentreconciliation_decoder(),
  )
}

pub fn paymentreconciliation_update(
  resource: r4.Paymentreconciliation,
  client: FhirClient,
) -> Result(r4.Paymentreconciliation, ReqError) {
  any_update(
    resource.id,
    r4.paymentreconciliation_to_json(resource),
    "PaymentReconciliation",
    r4.paymentreconciliation_decoder(),
    client,
  )
}

pub fn paymentreconciliation_delete(
  resource: r4.Paymentreconciliation,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "PaymentReconciliation", client)
}

pub fn person_create(
  resource: r4.Person,
  client: FhirClient,
) -> Result(r4.Person, ReqError) {
  any_create(r4.person_to_json(resource), "Person", r4.person_decoder(), client)
}

pub fn person_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Person, ReqError) {
  any_read(id, client, "Person", r4.person_decoder())
}

pub fn person_update(
  resource: r4.Person,
  client: FhirClient,
) -> Result(r4.Person, ReqError) {
  any_update(
    resource.id,
    r4.person_to_json(resource),
    "Person",
    r4.person_decoder(),
    client,
  )
}

pub fn person_delete(
  resource: r4.Person,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Person", client)
}

pub fn plandefinition_create(
  resource: r4.Plandefinition,
  client: FhirClient,
) -> Result(r4.Plandefinition, ReqError) {
  any_create(
    r4.plandefinition_to_json(resource),
    "PlanDefinition",
    r4.plandefinition_decoder(),
    client,
  )
}

pub fn plandefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Plandefinition, ReqError) {
  any_read(id, client, "PlanDefinition", r4.plandefinition_decoder())
}

pub fn plandefinition_update(
  resource: r4.Plandefinition,
  client: FhirClient,
) -> Result(r4.Plandefinition, ReqError) {
  any_update(
    resource.id,
    r4.plandefinition_to_json(resource),
    "PlanDefinition",
    r4.plandefinition_decoder(),
    client,
  )
}

pub fn plandefinition_delete(
  resource: r4.Plandefinition,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "PlanDefinition", client)
}

pub fn practitioner_create(
  resource: r4.Practitioner,
  client: FhirClient,
) -> Result(r4.Practitioner, ReqError) {
  any_create(
    r4.practitioner_to_json(resource),
    "Practitioner",
    r4.practitioner_decoder(),
    client,
  )
}

pub fn practitioner_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Practitioner, ReqError) {
  any_read(id, client, "Practitioner", r4.practitioner_decoder())
}

pub fn practitioner_update(
  resource: r4.Practitioner,
  client: FhirClient,
) -> Result(r4.Practitioner, ReqError) {
  any_update(
    resource.id,
    r4.practitioner_to_json(resource),
    "Practitioner",
    r4.practitioner_decoder(),
    client,
  )
}

pub fn practitioner_delete(
  resource: r4.Practitioner,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Practitioner", client)
}

pub fn practitionerrole_create(
  resource: r4.Practitionerrole,
  client: FhirClient,
) -> Result(r4.Practitionerrole, ReqError) {
  any_create(
    r4.practitionerrole_to_json(resource),
    "PractitionerRole",
    r4.practitionerrole_decoder(),
    client,
  )
}

pub fn practitionerrole_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Practitionerrole, ReqError) {
  any_read(id, client, "PractitionerRole", r4.practitionerrole_decoder())
}

pub fn practitionerrole_update(
  resource: r4.Practitionerrole,
  client: FhirClient,
) -> Result(r4.Practitionerrole, ReqError) {
  any_update(
    resource.id,
    r4.practitionerrole_to_json(resource),
    "PractitionerRole",
    r4.practitionerrole_decoder(),
    client,
  )
}

pub fn practitionerrole_delete(
  resource: r4.Practitionerrole,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "PractitionerRole", client)
}

pub fn procedure_create(
  resource: r4.Procedure,
  client: FhirClient,
) -> Result(r4.Procedure, ReqError) {
  any_create(
    r4.procedure_to_json(resource),
    "Procedure",
    r4.procedure_decoder(),
    client,
  )
}

pub fn procedure_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Procedure, ReqError) {
  any_read(id, client, "Procedure", r4.procedure_decoder())
}

pub fn procedure_update(
  resource: r4.Procedure,
  client: FhirClient,
) -> Result(r4.Procedure, ReqError) {
  any_update(
    resource.id,
    r4.procedure_to_json(resource),
    "Procedure",
    r4.procedure_decoder(),
    client,
  )
}

pub fn procedure_delete(
  resource: r4.Procedure,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Procedure", client)
}

pub fn provenance_create(
  resource: r4.Provenance,
  client: FhirClient,
) -> Result(r4.Provenance, ReqError) {
  any_create(
    r4.provenance_to_json(resource),
    "Provenance",
    r4.provenance_decoder(),
    client,
  )
}

pub fn provenance_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Provenance, ReqError) {
  any_read(id, client, "Provenance", r4.provenance_decoder())
}

pub fn provenance_update(
  resource: r4.Provenance,
  client: FhirClient,
) -> Result(r4.Provenance, ReqError) {
  any_update(
    resource.id,
    r4.provenance_to_json(resource),
    "Provenance",
    r4.provenance_decoder(),
    client,
  )
}

pub fn provenance_delete(
  resource: r4.Provenance,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Provenance", client)
}

pub fn questionnaire_create(
  resource: r4.Questionnaire,
  client: FhirClient,
) -> Result(r4.Questionnaire, ReqError) {
  any_create(
    r4.questionnaire_to_json(resource),
    "Questionnaire",
    r4.questionnaire_decoder(),
    client,
  )
}

pub fn questionnaire_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Questionnaire, ReqError) {
  any_read(id, client, "Questionnaire", r4.questionnaire_decoder())
}

pub fn questionnaire_update(
  resource: r4.Questionnaire,
  client: FhirClient,
) -> Result(r4.Questionnaire, ReqError) {
  any_update(
    resource.id,
    r4.questionnaire_to_json(resource),
    "Questionnaire",
    r4.questionnaire_decoder(),
    client,
  )
}

pub fn questionnaire_delete(
  resource: r4.Questionnaire,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Questionnaire", client)
}

pub fn questionnaireresponse_create(
  resource: r4.Questionnaireresponse,
  client: FhirClient,
) -> Result(r4.Questionnaireresponse, ReqError) {
  any_create(
    r4.questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    r4.questionnaireresponse_decoder(),
    client,
  )
}

pub fn questionnaireresponse_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Questionnaireresponse, ReqError) {
  any_read(
    id,
    client,
    "QuestionnaireResponse",
    r4.questionnaireresponse_decoder(),
  )
}

pub fn questionnaireresponse_update(
  resource: r4.Questionnaireresponse,
  client: FhirClient,
) -> Result(r4.Questionnaireresponse, ReqError) {
  any_update(
    resource.id,
    r4.questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    r4.questionnaireresponse_decoder(),
    client,
  )
}

pub fn questionnaireresponse_delete(
  resource: r4.Questionnaireresponse,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "QuestionnaireResponse", client)
}

pub fn relatedperson_create(
  resource: r4.Relatedperson,
  client: FhirClient,
) -> Result(r4.Relatedperson, ReqError) {
  any_create(
    r4.relatedperson_to_json(resource),
    "RelatedPerson",
    r4.relatedperson_decoder(),
    client,
  )
}

pub fn relatedperson_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Relatedperson, ReqError) {
  any_read(id, client, "RelatedPerson", r4.relatedperson_decoder())
}

pub fn relatedperson_update(
  resource: r4.Relatedperson,
  client: FhirClient,
) -> Result(r4.Relatedperson, ReqError) {
  any_update(
    resource.id,
    r4.relatedperson_to_json(resource),
    "RelatedPerson",
    r4.relatedperson_decoder(),
    client,
  )
}

pub fn relatedperson_delete(
  resource: r4.Relatedperson,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "RelatedPerson", client)
}

pub fn requestgroup_create(
  resource: r4.Requestgroup,
  client: FhirClient,
) -> Result(r4.Requestgroup, ReqError) {
  any_create(
    r4.requestgroup_to_json(resource),
    "RequestGroup",
    r4.requestgroup_decoder(),
    client,
  )
}

pub fn requestgroup_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Requestgroup, ReqError) {
  any_read(id, client, "RequestGroup", r4.requestgroup_decoder())
}

pub fn requestgroup_update(
  resource: r4.Requestgroup,
  client: FhirClient,
) -> Result(r4.Requestgroup, ReqError) {
  any_update(
    resource.id,
    r4.requestgroup_to_json(resource),
    "RequestGroup",
    r4.requestgroup_decoder(),
    client,
  )
}

pub fn requestgroup_delete(
  resource: r4.Requestgroup,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "RequestGroup", client)
}

pub fn researchdefinition_create(
  resource: r4.Researchdefinition,
  client: FhirClient,
) -> Result(r4.Researchdefinition, ReqError) {
  any_create(
    r4.researchdefinition_to_json(resource),
    "ResearchDefinition",
    r4.researchdefinition_decoder(),
    client,
  )
}

pub fn researchdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Researchdefinition, ReqError) {
  any_read(id, client, "ResearchDefinition", r4.researchdefinition_decoder())
}

pub fn researchdefinition_update(
  resource: r4.Researchdefinition,
  client: FhirClient,
) -> Result(r4.Researchdefinition, ReqError) {
  any_update(
    resource.id,
    r4.researchdefinition_to_json(resource),
    "ResearchDefinition",
    r4.researchdefinition_decoder(),
    client,
  )
}

pub fn researchdefinition_delete(
  resource: r4.Researchdefinition,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "ResearchDefinition", client)
}

pub fn researchelementdefinition_create(
  resource: r4.Researchelementdefinition,
  client: FhirClient,
) -> Result(r4.Researchelementdefinition, ReqError) {
  any_create(
    r4.researchelementdefinition_to_json(resource),
    "ResearchElementDefinition",
    r4.researchelementdefinition_decoder(),
    client,
  )
}

pub fn researchelementdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Researchelementdefinition, ReqError) {
  any_read(
    id,
    client,
    "ResearchElementDefinition",
    r4.researchelementdefinition_decoder(),
  )
}

pub fn researchelementdefinition_update(
  resource: r4.Researchelementdefinition,
  client: FhirClient,
) -> Result(r4.Researchelementdefinition, ReqError) {
  any_update(
    resource.id,
    r4.researchelementdefinition_to_json(resource),
    "ResearchElementDefinition",
    r4.researchelementdefinition_decoder(),
    client,
  )
}

pub fn researchelementdefinition_delete(
  resource: r4.Researchelementdefinition,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "ResearchElementDefinition", client)
}

pub fn researchstudy_create(
  resource: r4.Researchstudy,
  client: FhirClient,
) -> Result(r4.Researchstudy, ReqError) {
  any_create(
    r4.researchstudy_to_json(resource),
    "ResearchStudy",
    r4.researchstudy_decoder(),
    client,
  )
}

pub fn researchstudy_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Researchstudy, ReqError) {
  any_read(id, client, "ResearchStudy", r4.researchstudy_decoder())
}

pub fn researchstudy_update(
  resource: r4.Researchstudy,
  client: FhirClient,
) -> Result(r4.Researchstudy, ReqError) {
  any_update(
    resource.id,
    r4.researchstudy_to_json(resource),
    "ResearchStudy",
    r4.researchstudy_decoder(),
    client,
  )
}

pub fn researchstudy_delete(
  resource: r4.Researchstudy,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "ResearchStudy", client)
}

pub fn researchsubject_create(
  resource: r4.Researchsubject,
  client: FhirClient,
) -> Result(r4.Researchsubject, ReqError) {
  any_create(
    r4.researchsubject_to_json(resource),
    "ResearchSubject",
    r4.researchsubject_decoder(),
    client,
  )
}

pub fn researchsubject_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Researchsubject, ReqError) {
  any_read(id, client, "ResearchSubject", r4.researchsubject_decoder())
}

pub fn researchsubject_update(
  resource: r4.Researchsubject,
  client: FhirClient,
) -> Result(r4.Researchsubject, ReqError) {
  any_update(
    resource.id,
    r4.researchsubject_to_json(resource),
    "ResearchSubject",
    r4.researchsubject_decoder(),
    client,
  )
}

pub fn researchsubject_delete(
  resource: r4.Researchsubject,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "ResearchSubject", client)
}

pub fn riskassessment_create(
  resource: r4.Riskassessment,
  client: FhirClient,
) -> Result(r4.Riskassessment, ReqError) {
  any_create(
    r4.riskassessment_to_json(resource),
    "RiskAssessment",
    r4.riskassessment_decoder(),
    client,
  )
}

pub fn riskassessment_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Riskassessment, ReqError) {
  any_read(id, client, "RiskAssessment", r4.riskassessment_decoder())
}

pub fn riskassessment_update(
  resource: r4.Riskassessment,
  client: FhirClient,
) -> Result(r4.Riskassessment, ReqError) {
  any_update(
    resource.id,
    r4.riskassessment_to_json(resource),
    "RiskAssessment",
    r4.riskassessment_decoder(),
    client,
  )
}

pub fn riskassessment_delete(
  resource: r4.Riskassessment,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "RiskAssessment", client)
}

pub fn riskevidencesynthesis_create(
  resource: r4.Riskevidencesynthesis,
  client: FhirClient,
) -> Result(r4.Riskevidencesynthesis, ReqError) {
  any_create(
    r4.riskevidencesynthesis_to_json(resource),
    "RiskEvidenceSynthesis",
    r4.riskevidencesynthesis_decoder(),
    client,
  )
}

pub fn riskevidencesynthesis_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Riskevidencesynthesis, ReqError) {
  any_read(
    id,
    client,
    "RiskEvidenceSynthesis",
    r4.riskevidencesynthesis_decoder(),
  )
}

pub fn riskevidencesynthesis_update(
  resource: r4.Riskevidencesynthesis,
  client: FhirClient,
) -> Result(r4.Riskevidencesynthesis, ReqError) {
  any_update(
    resource.id,
    r4.riskevidencesynthesis_to_json(resource),
    "RiskEvidenceSynthesis",
    r4.riskevidencesynthesis_decoder(),
    client,
  )
}

pub fn riskevidencesynthesis_delete(
  resource: r4.Riskevidencesynthesis,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "RiskEvidenceSynthesis", client)
}

pub fn schedule_create(
  resource: r4.Schedule,
  client: FhirClient,
) -> Result(r4.Schedule, ReqError) {
  any_create(
    r4.schedule_to_json(resource),
    "Schedule",
    r4.schedule_decoder(),
    client,
  )
}

pub fn schedule_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Schedule, ReqError) {
  any_read(id, client, "Schedule", r4.schedule_decoder())
}

pub fn schedule_update(
  resource: r4.Schedule,
  client: FhirClient,
) -> Result(r4.Schedule, ReqError) {
  any_update(
    resource.id,
    r4.schedule_to_json(resource),
    "Schedule",
    r4.schedule_decoder(),
    client,
  )
}

pub fn schedule_delete(
  resource: r4.Schedule,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Schedule", client)
}

pub fn searchparameter_create(
  resource: r4.Searchparameter,
  client: FhirClient,
) -> Result(r4.Searchparameter, ReqError) {
  any_create(
    r4.searchparameter_to_json(resource),
    "SearchParameter",
    r4.searchparameter_decoder(),
    client,
  )
}

pub fn searchparameter_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Searchparameter, ReqError) {
  any_read(id, client, "SearchParameter", r4.searchparameter_decoder())
}

pub fn searchparameter_update(
  resource: r4.Searchparameter,
  client: FhirClient,
) -> Result(r4.Searchparameter, ReqError) {
  any_update(
    resource.id,
    r4.searchparameter_to_json(resource),
    "SearchParameter",
    r4.searchparameter_decoder(),
    client,
  )
}

pub fn searchparameter_delete(
  resource: r4.Searchparameter,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "SearchParameter", client)
}

pub fn servicerequest_create(
  resource: r4.Servicerequest,
  client: FhirClient,
) -> Result(r4.Servicerequest, ReqError) {
  any_create(
    r4.servicerequest_to_json(resource),
    "ServiceRequest",
    r4.servicerequest_decoder(),
    client,
  )
}

pub fn servicerequest_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Servicerequest, ReqError) {
  any_read(id, client, "ServiceRequest", r4.servicerequest_decoder())
}

pub fn servicerequest_update(
  resource: r4.Servicerequest,
  client: FhirClient,
) -> Result(r4.Servicerequest, ReqError) {
  any_update(
    resource.id,
    r4.servicerequest_to_json(resource),
    "ServiceRequest",
    r4.servicerequest_decoder(),
    client,
  )
}

pub fn servicerequest_delete(
  resource: r4.Servicerequest,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "ServiceRequest", client)
}

pub fn slot_create(
  resource: r4.Slot,
  client: FhirClient,
) -> Result(r4.Slot, ReqError) {
  any_create(r4.slot_to_json(resource), "Slot", r4.slot_decoder(), client)
}

pub fn slot_read(id: String, client: FhirClient) -> Result(r4.Slot, ReqError) {
  any_read(id, client, "Slot", r4.slot_decoder())
}

pub fn slot_update(
  resource: r4.Slot,
  client: FhirClient,
) -> Result(r4.Slot, ReqError) {
  any_update(
    resource.id,
    r4.slot_to_json(resource),
    "Slot",
    r4.slot_decoder(),
    client,
  )
}

pub fn slot_delete(
  resource: r4.Slot,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Slot", client)
}

pub fn specimen_create(
  resource: r4.Specimen,
  client: FhirClient,
) -> Result(r4.Specimen, ReqError) {
  any_create(
    r4.specimen_to_json(resource),
    "Specimen",
    r4.specimen_decoder(),
    client,
  )
}

pub fn specimen_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Specimen, ReqError) {
  any_read(id, client, "Specimen", r4.specimen_decoder())
}

pub fn specimen_update(
  resource: r4.Specimen,
  client: FhirClient,
) -> Result(r4.Specimen, ReqError) {
  any_update(
    resource.id,
    r4.specimen_to_json(resource),
    "Specimen",
    r4.specimen_decoder(),
    client,
  )
}

pub fn specimen_delete(
  resource: r4.Specimen,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Specimen", client)
}

pub fn specimendefinition_create(
  resource: r4.Specimendefinition,
  client: FhirClient,
) -> Result(r4.Specimendefinition, ReqError) {
  any_create(
    r4.specimendefinition_to_json(resource),
    "SpecimenDefinition",
    r4.specimendefinition_decoder(),
    client,
  )
}

pub fn specimendefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Specimendefinition, ReqError) {
  any_read(id, client, "SpecimenDefinition", r4.specimendefinition_decoder())
}

pub fn specimendefinition_update(
  resource: r4.Specimendefinition,
  client: FhirClient,
) -> Result(r4.Specimendefinition, ReqError) {
  any_update(
    resource.id,
    r4.specimendefinition_to_json(resource),
    "SpecimenDefinition",
    r4.specimendefinition_decoder(),
    client,
  )
}

pub fn specimendefinition_delete(
  resource: r4.Specimendefinition,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "SpecimenDefinition", client)
}

pub fn structuredefinition_create(
  resource: r4.Structuredefinition,
  client: FhirClient,
) -> Result(r4.Structuredefinition, ReqError) {
  any_create(
    r4.structuredefinition_to_json(resource),
    "StructureDefinition",
    r4.structuredefinition_decoder(),
    client,
  )
}

pub fn structuredefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Structuredefinition, ReqError) {
  any_read(id, client, "StructureDefinition", r4.structuredefinition_decoder())
}

pub fn structuredefinition_update(
  resource: r4.Structuredefinition,
  client: FhirClient,
) -> Result(r4.Structuredefinition, ReqError) {
  any_update(
    resource.id,
    r4.structuredefinition_to_json(resource),
    "StructureDefinition",
    r4.structuredefinition_decoder(),
    client,
  )
}

pub fn structuredefinition_delete(
  resource: r4.Structuredefinition,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "StructureDefinition", client)
}

pub fn structuremap_create(
  resource: r4.Structuremap,
  client: FhirClient,
) -> Result(r4.Structuremap, ReqError) {
  any_create(
    r4.structuremap_to_json(resource),
    "StructureMap",
    r4.structuremap_decoder(),
    client,
  )
}

pub fn structuremap_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Structuremap, ReqError) {
  any_read(id, client, "StructureMap", r4.structuremap_decoder())
}

pub fn structuremap_update(
  resource: r4.Structuremap,
  client: FhirClient,
) -> Result(r4.Structuremap, ReqError) {
  any_update(
    resource.id,
    r4.structuremap_to_json(resource),
    "StructureMap",
    r4.structuremap_decoder(),
    client,
  )
}

pub fn structuremap_delete(
  resource: r4.Structuremap,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "StructureMap", client)
}

pub fn subscription_create(
  resource: r4.Subscription,
  client: FhirClient,
) -> Result(r4.Subscription, ReqError) {
  any_create(
    r4.subscription_to_json(resource),
    "Subscription",
    r4.subscription_decoder(),
    client,
  )
}

pub fn subscription_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Subscription, ReqError) {
  any_read(id, client, "Subscription", r4.subscription_decoder())
}

pub fn subscription_update(
  resource: r4.Subscription,
  client: FhirClient,
) -> Result(r4.Subscription, ReqError) {
  any_update(
    resource.id,
    r4.subscription_to_json(resource),
    "Subscription",
    r4.subscription_decoder(),
    client,
  )
}

pub fn subscription_delete(
  resource: r4.Subscription,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Subscription", client)
}

pub fn substance_create(
  resource: r4.Substance,
  client: FhirClient,
) -> Result(r4.Substance, ReqError) {
  any_create(
    r4.substance_to_json(resource),
    "Substance",
    r4.substance_decoder(),
    client,
  )
}

pub fn substance_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Substance, ReqError) {
  any_read(id, client, "Substance", r4.substance_decoder())
}

pub fn substance_update(
  resource: r4.Substance,
  client: FhirClient,
) -> Result(r4.Substance, ReqError) {
  any_update(
    resource.id,
    r4.substance_to_json(resource),
    "Substance",
    r4.substance_decoder(),
    client,
  )
}

pub fn substance_delete(
  resource: r4.Substance,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Substance", client)
}

pub fn substancenucleicacid_create(
  resource: r4.Substancenucleicacid,
  client: FhirClient,
) -> Result(r4.Substancenucleicacid, ReqError) {
  any_create(
    r4.substancenucleicacid_to_json(resource),
    "SubstanceNucleicAcid",
    r4.substancenucleicacid_decoder(),
    client,
  )
}

pub fn substancenucleicacid_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Substancenucleicacid, ReqError) {
  any_read(
    id,
    client,
    "SubstanceNucleicAcid",
    r4.substancenucleicacid_decoder(),
  )
}

pub fn substancenucleicacid_update(
  resource: r4.Substancenucleicacid,
  client: FhirClient,
) -> Result(r4.Substancenucleicacid, ReqError) {
  any_update(
    resource.id,
    r4.substancenucleicacid_to_json(resource),
    "SubstanceNucleicAcid",
    r4.substancenucleicacid_decoder(),
    client,
  )
}

pub fn substancenucleicacid_delete(
  resource: r4.Substancenucleicacid,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "SubstanceNucleicAcid", client)
}

pub fn substancepolymer_create(
  resource: r4.Substancepolymer,
  client: FhirClient,
) -> Result(r4.Substancepolymer, ReqError) {
  any_create(
    r4.substancepolymer_to_json(resource),
    "SubstancePolymer",
    r4.substancepolymer_decoder(),
    client,
  )
}

pub fn substancepolymer_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Substancepolymer, ReqError) {
  any_read(id, client, "SubstancePolymer", r4.substancepolymer_decoder())
}

pub fn substancepolymer_update(
  resource: r4.Substancepolymer,
  client: FhirClient,
) -> Result(r4.Substancepolymer, ReqError) {
  any_update(
    resource.id,
    r4.substancepolymer_to_json(resource),
    "SubstancePolymer",
    r4.substancepolymer_decoder(),
    client,
  )
}

pub fn substancepolymer_delete(
  resource: r4.Substancepolymer,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "SubstancePolymer", client)
}

pub fn substanceprotein_create(
  resource: r4.Substanceprotein,
  client: FhirClient,
) -> Result(r4.Substanceprotein, ReqError) {
  any_create(
    r4.substanceprotein_to_json(resource),
    "SubstanceProtein",
    r4.substanceprotein_decoder(),
    client,
  )
}

pub fn substanceprotein_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Substanceprotein, ReqError) {
  any_read(id, client, "SubstanceProtein", r4.substanceprotein_decoder())
}

pub fn substanceprotein_update(
  resource: r4.Substanceprotein,
  client: FhirClient,
) -> Result(r4.Substanceprotein, ReqError) {
  any_update(
    resource.id,
    r4.substanceprotein_to_json(resource),
    "SubstanceProtein",
    r4.substanceprotein_decoder(),
    client,
  )
}

pub fn substanceprotein_delete(
  resource: r4.Substanceprotein,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "SubstanceProtein", client)
}

pub fn substancereferenceinformation_create(
  resource: r4.Substancereferenceinformation,
  client: FhirClient,
) -> Result(r4.Substancereferenceinformation, ReqError) {
  any_create(
    r4.substancereferenceinformation_to_json(resource),
    "SubstanceReferenceInformation",
    r4.substancereferenceinformation_decoder(),
    client,
  )
}

pub fn substancereferenceinformation_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Substancereferenceinformation, ReqError) {
  any_read(
    id,
    client,
    "SubstanceReferenceInformation",
    r4.substancereferenceinformation_decoder(),
  )
}

pub fn substancereferenceinformation_update(
  resource: r4.Substancereferenceinformation,
  client: FhirClient,
) -> Result(r4.Substancereferenceinformation, ReqError) {
  any_update(
    resource.id,
    r4.substancereferenceinformation_to_json(resource),
    "SubstanceReferenceInformation",
    r4.substancereferenceinformation_decoder(),
    client,
  )
}

pub fn substancereferenceinformation_delete(
  resource: r4.Substancereferenceinformation,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "SubstanceReferenceInformation", client)
}

pub fn substancesourcematerial_create(
  resource: r4.Substancesourcematerial,
  client: FhirClient,
) -> Result(r4.Substancesourcematerial, ReqError) {
  any_create(
    r4.substancesourcematerial_to_json(resource),
    "SubstanceSourceMaterial",
    r4.substancesourcematerial_decoder(),
    client,
  )
}

pub fn substancesourcematerial_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Substancesourcematerial, ReqError) {
  any_read(
    id,
    client,
    "SubstanceSourceMaterial",
    r4.substancesourcematerial_decoder(),
  )
}

pub fn substancesourcematerial_update(
  resource: r4.Substancesourcematerial,
  client: FhirClient,
) -> Result(r4.Substancesourcematerial, ReqError) {
  any_update(
    resource.id,
    r4.substancesourcematerial_to_json(resource),
    "SubstanceSourceMaterial",
    r4.substancesourcematerial_decoder(),
    client,
  )
}

pub fn substancesourcematerial_delete(
  resource: r4.Substancesourcematerial,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "SubstanceSourceMaterial", client)
}

pub fn substancespecification_create(
  resource: r4.Substancespecification,
  client: FhirClient,
) -> Result(r4.Substancespecification, ReqError) {
  any_create(
    r4.substancespecification_to_json(resource),
    "SubstanceSpecification",
    r4.substancespecification_decoder(),
    client,
  )
}

pub fn substancespecification_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Substancespecification, ReqError) {
  any_read(
    id,
    client,
    "SubstanceSpecification",
    r4.substancespecification_decoder(),
  )
}

pub fn substancespecification_update(
  resource: r4.Substancespecification,
  client: FhirClient,
) -> Result(r4.Substancespecification, ReqError) {
  any_update(
    resource.id,
    r4.substancespecification_to_json(resource),
    "SubstanceSpecification",
    r4.substancespecification_decoder(),
    client,
  )
}

pub fn substancespecification_delete(
  resource: r4.Substancespecification,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "SubstanceSpecification", client)
}

pub fn supplydelivery_create(
  resource: r4.Supplydelivery,
  client: FhirClient,
) -> Result(r4.Supplydelivery, ReqError) {
  any_create(
    r4.supplydelivery_to_json(resource),
    "SupplyDelivery",
    r4.supplydelivery_decoder(),
    client,
  )
}

pub fn supplydelivery_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Supplydelivery, ReqError) {
  any_read(id, client, "SupplyDelivery", r4.supplydelivery_decoder())
}

pub fn supplydelivery_update(
  resource: r4.Supplydelivery,
  client: FhirClient,
) -> Result(r4.Supplydelivery, ReqError) {
  any_update(
    resource.id,
    r4.supplydelivery_to_json(resource),
    "SupplyDelivery",
    r4.supplydelivery_decoder(),
    client,
  )
}

pub fn supplydelivery_delete(
  resource: r4.Supplydelivery,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "SupplyDelivery", client)
}

pub fn supplyrequest_create(
  resource: r4.Supplyrequest,
  client: FhirClient,
) -> Result(r4.Supplyrequest, ReqError) {
  any_create(
    r4.supplyrequest_to_json(resource),
    "SupplyRequest",
    r4.supplyrequest_decoder(),
    client,
  )
}

pub fn supplyrequest_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Supplyrequest, ReqError) {
  any_read(id, client, "SupplyRequest", r4.supplyrequest_decoder())
}

pub fn supplyrequest_update(
  resource: r4.Supplyrequest,
  client: FhirClient,
) -> Result(r4.Supplyrequest, ReqError) {
  any_update(
    resource.id,
    r4.supplyrequest_to_json(resource),
    "SupplyRequest",
    r4.supplyrequest_decoder(),
    client,
  )
}

pub fn supplyrequest_delete(
  resource: r4.Supplyrequest,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "SupplyRequest", client)
}

pub fn task_create(
  resource: r4.Task,
  client: FhirClient,
) -> Result(r4.Task, ReqError) {
  any_create(r4.task_to_json(resource), "Task", r4.task_decoder(), client)
}

pub fn task_read(id: String, client: FhirClient) -> Result(r4.Task, ReqError) {
  any_read(id, client, "Task", r4.task_decoder())
}

pub fn task_update(
  resource: r4.Task,
  client: FhirClient,
) -> Result(r4.Task, ReqError) {
  any_update(
    resource.id,
    r4.task_to_json(resource),
    "Task",
    r4.task_decoder(),
    client,
  )
}

pub fn task_delete(
  resource: r4.Task,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "Task", client)
}

pub fn terminologycapabilities_create(
  resource: r4.Terminologycapabilities,
  client: FhirClient,
) -> Result(r4.Terminologycapabilities, ReqError) {
  any_create(
    r4.terminologycapabilities_to_json(resource),
    "TerminologyCapabilities",
    r4.terminologycapabilities_decoder(),
    client,
  )
}

pub fn terminologycapabilities_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Terminologycapabilities, ReqError) {
  any_read(
    id,
    client,
    "TerminologyCapabilities",
    r4.terminologycapabilities_decoder(),
  )
}

pub fn terminologycapabilities_update(
  resource: r4.Terminologycapabilities,
  client: FhirClient,
) -> Result(r4.Terminologycapabilities, ReqError) {
  any_update(
    resource.id,
    r4.terminologycapabilities_to_json(resource),
    "TerminologyCapabilities",
    r4.terminologycapabilities_decoder(),
    client,
  )
}

pub fn terminologycapabilities_delete(
  resource: r4.Terminologycapabilities,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "TerminologyCapabilities", client)
}

pub fn testreport_create(
  resource: r4.Testreport,
  client: FhirClient,
) -> Result(r4.Testreport, ReqError) {
  any_create(
    r4.testreport_to_json(resource),
    "TestReport",
    r4.testreport_decoder(),
    client,
  )
}

pub fn testreport_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Testreport, ReqError) {
  any_read(id, client, "TestReport", r4.testreport_decoder())
}

pub fn testreport_update(
  resource: r4.Testreport,
  client: FhirClient,
) -> Result(r4.Testreport, ReqError) {
  any_update(
    resource.id,
    r4.testreport_to_json(resource),
    "TestReport",
    r4.testreport_decoder(),
    client,
  )
}

pub fn testreport_delete(
  resource: r4.Testreport,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "TestReport", client)
}

pub fn testscript_create(
  resource: r4.Testscript,
  client: FhirClient,
) -> Result(r4.Testscript, ReqError) {
  any_create(
    r4.testscript_to_json(resource),
    "TestScript",
    r4.testscript_decoder(),
    client,
  )
}

pub fn testscript_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Testscript, ReqError) {
  any_read(id, client, "TestScript", r4.testscript_decoder())
}

pub fn testscript_update(
  resource: r4.Testscript,
  client: FhirClient,
) -> Result(r4.Testscript, ReqError) {
  any_update(
    resource.id,
    r4.testscript_to_json(resource),
    "TestScript",
    r4.testscript_decoder(),
    client,
  )
}

pub fn testscript_delete(
  resource: r4.Testscript,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "TestScript", client)
}

pub fn valueset_create(
  resource: r4.Valueset,
  client: FhirClient,
) -> Result(r4.Valueset, ReqError) {
  any_create(
    r4.valueset_to_json(resource),
    "ValueSet",
    r4.valueset_decoder(),
    client,
  )
}

pub fn valueset_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Valueset, ReqError) {
  any_read(id, client, "ValueSet", r4.valueset_decoder())
}

pub fn valueset_update(
  resource: r4.Valueset,
  client: FhirClient,
) -> Result(r4.Valueset, ReqError) {
  any_update(
    resource.id,
    r4.valueset_to_json(resource),
    "ValueSet",
    r4.valueset_decoder(),
    client,
  )
}

pub fn valueset_delete(
  resource: r4.Valueset,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "ValueSet", client)
}

pub fn verificationresult_create(
  resource: r4.Verificationresult,
  client: FhirClient,
) -> Result(r4.Verificationresult, ReqError) {
  any_create(
    r4.verificationresult_to_json(resource),
    "VerificationResult",
    r4.verificationresult_decoder(),
    client,
  )
}

pub fn verificationresult_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Verificationresult, ReqError) {
  any_read(id, client, "VerificationResult", r4.verificationresult_decoder())
}

pub fn verificationresult_update(
  resource: r4.Verificationresult,
  client: FhirClient,
) -> Result(r4.Verificationresult, ReqError) {
  any_update(
    resource.id,
    r4.verificationresult_to_json(resource),
    "VerificationResult",
    r4.verificationresult_decoder(),
    client,
  )
}

pub fn verificationresult_delete(
  resource: r4.Verificationresult,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "VerificationResult", client)
}

pub fn visionprescription_create(
  resource: r4.Visionprescription,
  client: FhirClient,
) -> Result(r4.Visionprescription, ReqError) {
  any_create(
    r4.visionprescription_to_json(resource),
    "VisionPrescription",
    r4.visionprescription_decoder(),
    client,
  )
}

pub fn visionprescription_read(
  id: String,
  client: FhirClient,
) -> Result(r4.Visionprescription, ReqError) {
  any_read(id, client, "VisionPrescription", r4.visionprescription_decoder())
}

pub fn visionprescription_update(
  resource: r4.Visionprescription,
  client: FhirClient,
) -> Result(r4.Visionprescription, ReqError) {
  any_update(
    resource.id,
    r4.visionprescription_to_json(resource),
    "VisionPrescription",
    r4.visionprescription_decoder(),
    client,
  )
}

pub fn visionprescription_delete(
  resource: r4.Visionprescription,
  client: FhirClient,
) -> Result(r4.Operationoutcome, ReqError) {
  any_delete(resource.id, "VisionPrescription", client)
}
