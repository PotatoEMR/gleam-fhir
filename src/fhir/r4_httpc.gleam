////[https://hl7.org/fhir/r4](https://hl7.org/fhir/r4) r4 client using httpc

import fhir/r4
import fhir/r4_sansio
import gleam/dynamic/decode.{type Decoder}
import gleam/http/request.{type Request}
import gleam/httpc
import gleam/json.{type Json}
import gleam/option.{type Option}
import gleam/result

/// FHIR client for sending http requests to server such as
/// `let pat = r4.patient_read("123", client)`
///
/// create client from server base url with fhirclient_new(baseurl)`
///
/// `let assert Ok(client) = r4_httpc.fhirclient_new("r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = r4_httpc.fhirclient_new("https://r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = r4_httpc.fhirclient_new("https://hapi.fhir.org/baseR4")`
///
/// `let assert Ok(client) = r4_httpc.fhirclient_new("127.0.0.1:8000")`
pub type FhirClient =
  r4_sansio.FhirClient

/// creates a new client from server base url
///
/// `let assert Ok(client) = r4_httpc.fhirclient_new("r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = r4_httpc.fhirclient_new("https://r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = r4_httpc.fhirclient_new("https://hapi.fhir.org/baseR4")`
///
/// `let assert Ok(client) = r4_httpc.fhirclient_new("127.0.0.1:8000")`
pub fn fhirclient_new(
  baseurl: String,
) -> Result(FhirClient, r4_sansio.ErrBaseUrl) {
  r4_sansio.fhirclient_new(baseurl)
}

pub type Err {
  ErrHttpc(httpc.HttpError)
  ErrSansio(err: r4_sansio.Err)
}

fn any_create(
  resource: Json,
  res_type: String,
  resource_dec: Decoder(r),
  client: FhirClient,
) -> Result(r, Err) {
  let req = r4_sansio.any_create_req(resource, res_type, client)
  sendreq_parseresource(req, resource_dec)
}

fn any_read(
  id: String,
  client: FhirClient,
  res_type: String,
  resource_dec: Decoder(a),
) -> Result(a, Err) {
  let req = r4_sansio.any_read_req(id, res_type, client)
  sendreq_parseresource(req, resource_dec)
}

fn any_update(
  id: Option(String),
  resource: Json,
  res_type: String,
  res_dec: Decoder(r),
  client: FhirClient,
) -> Result(r, Err) {
  let req = r4_sansio.any_update_req(id, resource, res_type, client)
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
) -> Result(r4.Operationoutcome, Err) {
  let req = r4_sansio.any_delete_req(id, res_type, client)
  case req {
    Ok(req) -> sendreq_parseresource(req, r4.operationoutcome_decoder())
    Error(err) -> Error(ErrSansio(err))
    //can have error preparing delete request if resource has no id
  }
}

/// write out search string manually, in case typed search params don't work
pub fn search_any(
  search_string: String,
  res_type: String,
  client: FhirClient,
) -> Result(r4.Bundle, Err) {
  let req = r4_sansio.any_search_req(search_string, res_type, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

/// run any operation string on any resource string, optionally using Parameters
pub fn operation_any(
  params params: Option(r4.Parameters),
  operation_name operation_name: String,
  res_type res_type: String,
  res_id res_id: Option(String),
  res_decoder res_decoder: Decoder(res),
  client client: FhirClient,
) -> Result(res, Err) {
  let req =
    r4_sansio.any_operation_req(
      res_type,
      res_id,
      operation_name,
      params,
      client,
    )
  sendreq_parseresource(req, res_decoder)
}

fn sendreq_parseresource(
  req: Request(String),
  res_dec: Decoder(r),
) -> Result(r, Err) {
  case httpc.send(req) {
    Error(err) -> Error(ErrHttpc(err))
    Ok(resp) ->
      case r4_sansio.any_resp(resp, res_dec) {
        Ok(resource) -> Ok(resource)
        Error(err) -> Error(ErrSansio(err))
      }
  }
}

pub fn account_create(
  resource: r4.Account,
  client: FhirClient,
) -> Result(r4.Account, Err) {
  any_create(
    r4.account_to_json(resource),
    "Account",
    r4.account_decoder(),
    client,
  )
}

pub fn account_read(id: String, client: FhirClient) -> Result(r4.Account, Err) {
  any_read(id, client, "Account", r4.account_decoder())
}

pub fn account_update(
  resource: r4.Account,
  client: FhirClient,
) -> Result(r4.Account, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Account", client)
}

pub fn account_search_bundled(sp: r4_sansio.SpAccount, client: FhirClient) {
  let req = r4_sansio.account_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn account_search(
  sp: r4_sansio.SpAccount,
  client: FhirClient,
) -> Result(List(r4.Account), Err) {
  let req = r4_sansio.account_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.account
  })
}

pub fn activitydefinition_create(
  resource: r4.Activitydefinition,
  client: FhirClient,
) -> Result(r4.Activitydefinition, Err) {
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
) -> Result(r4.Activitydefinition, Err) {
  any_read(id, client, "ActivityDefinition", r4.activitydefinition_decoder())
}

pub fn activitydefinition_update(
  resource: r4.Activitydefinition,
  client: FhirClient,
) -> Result(r4.Activitydefinition, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "ActivityDefinition", client)
}

pub fn activitydefinition_search_bundled(
  sp: r4_sansio.SpActivitydefinition,
  client: FhirClient,
) {
  let req = r4_sansio.activitydefinition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn activitydefinition_search(
  sp: r4_sansio.SpActivitydefinition,
  client: FhirClient,
) -> Result(List(r4.Activitydefinition), Err) {
  let req = r4_sansio.activitydefinition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.activitydefinition
  })
}

pub fn adverseevent_create(
  resource: r4.Adverseevent,
  client: FhirClient,
) -> Result(r4.Adverseevent, Err) {
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
) -> Result(r4.Adverseevent, Err) {
  any_read(id, client, "AdverseEvent", r4.adverseevent_decoder())
}

pub fn adverseevent_update(
  resource: r4.Adverseevent,
  client: FhirClient,
) -> Result(r4.Adverseevent, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "AdverseEvent", client)
}

pub fn adverseevent_search_bundled(
  sp: r4_sansio.SpAdverseevent,
  client: FhirClient,
) {
  let req = r4_sansio.adverseevent_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn adverseevent_search(
  sp: r4_sansio.SpAdverseevent,
  client: FhirClient,
) -> Result(List(r4.Adverseevent), Err) {
  let req = r4_sansio.adverseevent_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.adverseevent
  })
}

pub fn allergyintolerance_create(
  resource: r4.Allergyintolerance,
  client: FhirClient,
) -> Result(r4.Allergyintolerance, Err) {
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
) -> Result(r4.Allergyintolerance, Err) {
  any_read(id, client, "AllergyIntolerance", r4.allergyintolerance_decoder())
}

pub fn allergyintolerance_update(
  resource: r4.Allergyintolerance,
  client: FhirClient,
) -> Result(r4.Allergyintolerance, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "AllergyIntolerance", client)
}

pub fn allergyintolerance_search_bundled(
  sp: r4_sansio.SpAllergyintolerance,
  client: FhirClient,
) {
  let req = r4_sansio.allergyintolerance_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn allergyintolerance_search(
  sp: r4_sansio.SpAllergyintolerance,
  client: FhirClient,
) -> Result(List(r4.Allergyintolerance), Err) {
  let req = r4_sansio.allergyintolerance_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.allergyintolerance
  })
}

pub fn appointment_create(
  resource: r4.Appointment,
  client: FhirClient,
) -> Result(r4.Appointment, Err) {
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
) -> Result(r4.Appointment, Err) {
  any_read(id, client, "Appointment", r4.appointment_decoder())
}

pub fn appointment_update(
  resource: r4.Appointment,
  client: FhirClient,
) -> Result(r4.Appointment, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Appointment", client)
}

pub fn appointment_search_bundled(
  sp: r4_sansio.SpAppointment,
  client: FhirClient,
) {
  let req = r4_sansio.appointment_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn appointment_search(
  sp: r4_sansio.SpAppointment,
  client: FhirClient,
) -> Result(List(r4.Appointment), Err) {
  let req = r4_sansio.appointment_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.appointment
  })
}

pub fn appointmentresponse_create(
  resource: r4.Appointmentresponse,
  client: FhirClient,
) -> Result(r4.Appointmentresponse, Err) {
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
) -> Result(r4.Appointmentresponse, Err) {
  any_read(id, client, "AppointmentResponse", r4.appointmentresponse_decoder())
}

pub fn appointmentresponse_update(
  resource: r4.Appointmentresponse,
  client: FhirClient,
) -> Result(r4.Appointmentresponse, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "AppointmentResponse", client)
}

pub fn appointmentresponse_search_bundled(
  sp: r4_sansio.SpAppointmentresponse,
  client: FhirClient,
) {
  let req = r4_sansio.appointmentresponse_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn appointmentresponse_search(
  sp: r4_sansio.SpAppointmentresponse,
  client: FhirClient,
) -> Result(List(r4.Appointmentresponse), Err) {
  let req = r4_sansio.appointmentresponse_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.appointmentresponse
  })
}

pub fn auditevent_create(
  resource: r4.Auditevent,
  client: FhirClient,
) -> Result(r4.Auditevent, Err) {
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
) -> Result(r4.Auditevent, Err) {
  any_read(id, client, "AuditEvent", r4.auditevent_decoder())
}

pub fn auditevent_update(
  resource: r4.Auditevent,
  client: FhirClient,
) -> Result(r4.Auditevent, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "AuditEvent", client)
}

pub fn auditevent_search_bundled(sp: r4_sansio.SpAuditevent, client: FhirClient) {
  let req = r4_sansio.auditevent_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn auditevent_search(
  sp: r4_sansio.SpAuditevent,
  client: FhirClient,
) -> Result(List(r4.Auditevent), Err) {
  let req = r4_sansio.auditevent_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.auditevent
  })
}

pub fn basic_create(
  resource: r4.Basic,
  client: FhirClient,
) -> Result(r4.Basic, Err) {
  any_create(r4.basic_to_json(resource), "Basic", r4.basic_decoder(), client)
}

pub fn basic_read(id: String, client: FhirClient) -> Result(r4.Basic, Err) {
  any_read(id, client, "Basic", r4.basic_decoder())
}

pub fn basic_update(
  resource: r4.Basic,
  client: FhirClient,
) -> Result(r4.Basic, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Basic", client)
}

pub fn basic_search_bundled(sp: r4_sansio.SpBasic, client: FhirClient) {
  let req = r4_sansio.basic_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn basic_search(
  sp: r4_sansio.SpBasic,
  client: FhirClient,
) -> Result(List(r4.Basic), Err) {
  let req = r4_sansio.basic_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.basic
  })
}

pub fn binary_create(
  resource: r4.Binary,
  client: FhirClient,
) -> Result(r4.Binary, Err) {
  any_create(r4.binary_to_json(resource), "Binary", r4.binary_decoder(), client)
}

pub fn binary_read(id: String, client: FhirClient) -> Result(r4.Binary, Err) {
  any_read(id, client, "Binary", r4.binary_decoder())
}

pub fn binary_update(
  resource: r4.Binary,
  client: FhirClient,
) -> Result(r4.Binary, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Binary", client)
}

pub fn binary_search_bundled(sp: r4_sansio.SpBinary, client: FhirClient) {
  let req = r4_sansio.binary_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn binary_search(
  sp: r4_sansio.SpBinary,
  client: FhirClient,
) -> Result(List(r4.Binary), Err) {
  let req = r4_sansio.binary_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.binary
  })
}

pub fn biologicallyderivedproduct_create(
  resource: r4.Biologicallyderivedproduct,
  client: FhirClient,
) -> Result(r4.Biologicallyderivedproduct, Err) {
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
) -> Result(r4.Biologicallyderivedproduct, Err) {
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
) -> Result(r4.Biologicallyderivedproduct, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "BiologicallyDerivedProduct", client)
}

pub fn biologicallyderivedproduct_search_bundled(
  sp: r4_sansio.SpBiologicallyderivedproduct,
  client: FhirClient,
) {
  let req = r4_sansio.biologicallyderivedproduct_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn biologicallyderivedproduct_search(
  sp: r4_sansio.SpBiologicallyderivedproduct,
  client: FhirClient,
) -> Result(List(r4.Biologicallyderivedproduct), Err) {
  let req = r4_sansio.biologicallyderivedproduct_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.biologicallyderivedproduct
  })
}

pub fn bodystructure_create(
  resource: r4.Bodystructure,
  client: FhirClient,
) -> Result(r4.Bodystructure, Err) {
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
) -> Result(r4.Bodystructure, Err) {
  any_read(id, client, "BodyStructure", r4.bodystructure_decoder())
}

pub fn bodystructure_update(
  resource: r4.Bodystructure,
  client: FhirClient,
) -> Result(r4.Bodystructure, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "BodyStructure", client)
}

pub fn bodystructure_search_bundled(
  sp: r4_sansio.SpBodystructure,
  client: FhirClient,
) {
  let req = r4_sansio.bodystructure_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn bodystructure_search(
  sp: r4_sansio.SpBodystructure,
  client: FhirClient,
) -> Result(List(r4.Bodystructure), Err) {
  let req = r4_sansio.bodystructure_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.bodystructure
  })
}

pub fn bundle_create(
  resource: r4.Bundle,
  client: FhirClient,
) -> Result(r4.Bundle, Err) {
  any_create(r4.bundle_to_json(resource), "Bundle", r4.bundle_decoder(), client)
}

pub fn bundle_read(id: String, client: FhirClient) -> Result(r4.Bundle, Err) {
  any_read(id, client, "Bundle", r4.bundle_decoder())
}

pub fn bundle_update(
  resource: r4.Bundle,
  client: FhirClient,
) -> Result(r4.Bundle, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Bundle", client)
}

pub fn bundle_search_bundled(sp: r4_sansio.SpBundle, client: FhirClient) {
  let req = r4_sansio.bundle_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn bundle_search(
  sp: r4_sansio.SpBundle,
  client: FhirClient,
) -> Result(List(r4.Bundle), Err) {
  let req = r4_sansio.bundle_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.bundle
  })
}

pub fn capabilitystatement_create(
  resource: r4.Capabilitystatement,
  client: FhirClient,
) -> Result(r4.Capabilitystatement, Err) {
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
) -> Result(r4.Capabilitystatement, Err) {
  any_read(id, client, "CapabilityStatement", r4.capabilitystatement_decoder())
}

pub fn capabilitystatement_update(
  resource: r4.Capabilitystatement,
  client: FhirClient,
) -> Result(r4.Capabilitystatement, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "CapabilityStatement", client)
}

pub fn capabilitystatement_search_bundled(
  sp: r4_sansio.SpCapabilitystatement,
  client: FhirClient,
) {
  let req = r4_sansio.capabilitystatement_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn capabilitystatement_search(
  sp: r4_sansio.SpCapabilitystatement,
  client: FhirClient,
) -> Result(List(r4.Capabilitystatement), Err) {
  let req = r4_sansio.capabilitystatement_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.capabilitystatement
  })
}

pub fn careplan_create(
  resource: r4.Careplan,
  client: FhirClient,
) -> Result(r4.Careplan, Err) {
  any_create(
    r4.careplan_to_json(resource),
    "CarePlan",
    r4.careplan_decoder(),
    client,
  )
}

pub fn careplan_read(id: String, client: FhirClient) -> Result(r4.Careplan, Err) {
  any_read(id, client, "CarePlan", r4.careplan_decoder())
}

pub fn careplan_update(
  resource: r4.Careplan,
  client: FhirClient,
) -> Result(r4.Careplan, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "CarePlan", client)
}

pub fn careplan_search_bundled(sp: r4_sansio.SpCareplan, client: FhirClient) {
  let req = r4_sansio.careplan_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn careplan_search(
  sp: r4_sansio.SpCareplan,
  client: FhirClient,
) -> Result(List(r4.Careplan), Err) {
  let req = r4_sansio.careplan_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.careplan
  })
}

pub fn careteam_create(
  resource: r4.Careteam,
  client: FhirClient,
) -> Result(r4.Careteam, Err) {
  any_create(
    r4.careteam_to_json(resource),
    "CareTeam",
    r4.careteam_decoder(),
    client,
  )
}

pub fn careteam_read(id: String, client: FhirClient) -> Result(r4.Careteam, Err) {
  any_read(id, client, "CareTeam", r4.careteam_decoder())
}

pub fn careteam_update(
  resource: r4.Careteam,
  client: FhirClient,
) -> Result(r4.Careteam, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "CareTeam", client)
}

pub fn careteam_search_bundled(sp: r4_sansio.SpCareteam, client: FhirClient) {
  let req = r4_sansio.careteam_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn careteam_search(
  sp: r4_sansio.SpCareteam,
  client: FhirClient,
) -> Result(List(r4.Careteam), Err) {
  let req = r4_sansio.careteam_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.careteam
  })
}

pub fn catalogentry_create(
  resource: r4.Catalogentry,
  client: FhirClient,
) -> Result(r4.Catalogentry, Err) {
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
) -> Result(r4.Catalogentry, Err) {
  any_read(id, client, "CatalogEntry", r4.catalogentry_decoder())
}

pub fn catalogentry_update(
  resource: r4.Catalogentry,
  client: FhirClient,
) -> Result(r4.Catalogentry, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "CatalogEntry", client)
}

pub fn catalogentry_search_bundled(
  sp: r4_sansio.SpCatalogentry,
  client: FhirClient,
) {
  let req = r4_sansio.catalogentry_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn catalogentry_search(
  sp: r4_sansio.SpCatalogentry,
  client: FhirClient,
) -> Result(List(r4.Catalogentry), Err) {
  let req = r4_sansio.catalogentry_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.catalogentry
  })
}

pub fn chargeitem_create(
  resource: r4.Chargeitem,
  client: FhirClient,
) -> Result(r4.Chargeitem, Err) {
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
) -> Result(r4.Chargeitem, Err) {
  any_read(id, client, "ChargeItem", r4.chargeitem_decoder())
}

pub fn chargeitem_update(
  resource: r4.Chargeitem,
  client: FhirClient,
) -> Result(r4.Chargeitem, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "ChargeItem", client)
}

pub fn chargeitem_search_bundled(sp: r4_sansio.SpChargeitem, client: FhirClient) {
  let req = r4_sansio.chargeitem_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn chargeitem_search(
  sp: r4_sansio.SpChargeitem,
  client: FhirClient,
) -> Result(List(r4.Chargeitem), Err) {
  let req = r4_sansio.chargeitem_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.chargeitem
  })
}

pub fn chargeitemdefinition_create(
  resource: r4.Chargeitemdefinition,
  client: FhirClient,
) -> Result(r4.Chargeitemdefinition, Err) {
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
) -> Result(r4.Chargeitemdefinition, Err) {
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
) -> Result(r4.Chargeitemdefinition, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "ChargeItemDefinition", client)
}

pub fn chargeitemdefinition_search_bundled(
  sp: r4_sansio.SpChargeitemdefinition,
  client: FhirClient,
) {
  let req = r4_sansio.chargeitemdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn chargeitemdefinition_search(
  sp: r4_sansio.SpChargeitemdefinition,
  client: FhirClient,
) -> Result(List(r4.Chargeitemdefinition), Err) {
  let req = r4_sansio.chargeitemdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.chargeitemdefinition
  })
}

pub fn claim_create(
  resource: r4.Claim,
  client: FhirClient,
) -> Result(r4.Claim, Err) {
  any_create(r4.claim_to_json(resource), "Claim", r4.claim_decoder(), client)
}

pub fn claim_read(id: String, client: FhirClient) -> Result(r4.Claim, Err) {
  any_read(id, client, "Claim", r4.claim_decoder())
}

pub fn claim_update(
  resource: r4.Claim,
  client: FhirClient,
) -> Result(r4.Claim, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Claim", client)
}

pub fn claim_search_bundled(sp: r4_sansio.SpClaim, client: FhirClient) {
  let req = r4_sansio.claim_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn claim_search(
  sp: r4_sansio.SpClaim,
  client: FhirClient,
) -> Result(List(r4.Claim), Err) {
  let req = r4_sansio.claim_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.claim
  })
}

pub fn claimresponse_create(
  resource: r4.Claimresponse,
  client: FhirClient,
) -> Result(r4.Claimresponse, Err) {
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
) -> Result(r4.Claimresponse, Err) {
  any_read(id, client, "ClaimResponse", r4.claimresponse_decoder())
}

pub fn claimresponse_update(
  resource: r4.Claimresponse,
  client: FhirClient,
) -> Result(r4.Claimresponse, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "ClaimResponse", client)
}

pub fn claimresponse_search_bundled(
  sp: r4_sansio.SpClaimresponse,
  client: FhirClient,
) {
  let req = r4_sansio.claimresponse_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn claimresponse_search(
  sp: r4_sansio.SpClaimresponse,
  client: FhirClient,
) -> Result(List(r4.Claimresponse), Err) {
  let req = r4_sansio.claimresponse_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.claimresponse
  })
}

pub fn clinicalimpression_create(
  resource: r4.Clinicalimpression,
  client: FhirClient,
) -> Result(r4.Clinicalimpression, Err) {
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
) -> Result(r4.Clinicalimpression, Err) {
  any_read(id, client, "ClinicalImpression", r4.clinicalimpression_decoder())
}

pub fn clinicalimpression_update(
  resource: r4.Clinicalimpression,
  client: FhirClient,
) -> Result(r4.Clinicalimpression, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "ClinicalImpression", client)
}

pub fn clinicalimpression_search_bundled(
  sp: r4_sansio.SpClinicalimpression,
  client: FhirClient,
) {
  let req = r4_sansio.clinicalimpression_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn clinicalimpression_search(
  sp: r4_sansio.SpClinicalimpression,
  client: FhirClient,
) -> Result(List(r4.Clinicalimpression), Err) {
  let req = r4_sansio.clinicalimpression_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.clinicalimpression
  })
}

pub fn codesystem_create(
  resource: r4.Codesystem,
  client: FhirClient,
) -> Result(r4.Codesystem, Err) {
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
) -> Result(r4.Codesystem, Err) {
  any_read(id, client, "CodeSystem", r4.codesystem_decoder())
}

pub fn codesystem_update(
  resource: r4.Codesystem,
  client: FhirClient,
) -> Result(r4.Codesystem, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "CodeSystem", client)
}

pub fn codesystem_search_bundled(sp: r4_sansio.SpCodesystem, client: FhirClient) {
  let req = r4_sansio.codesystem_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn codesystem_search(
  sp: r4_sansio.SpCodesystem,
  client: FhirClient,
) -> Result(List(r4.Codesystem), Err) {
  let req = r4_sansio.codesystem_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.codesystem
  })
}

pub fn communication_create(
  resource: r4.Communication,
  client: FhirClient,
) -> Result(r4.Communication, Err) {
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
) -> Result(r4.Communication, Err) {
  any_read(id, client, "Communication", r4.communication_decoder())
}

pub fn communication_update(
  resource: r4.Communication,
  client: FhirClient,
) -> Result(r4.Communication, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Communication", client)
}

pub fn communication_search_bundled(
  sp: r4_sansio.SpCommunication,
  client: FhirClient,
) {
  let req = r4_sansio.communication_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn communication_search(
  sp: r4_sansio.SpCommunication,
  client: FhirClient,
) -> Result(List(r4.Communication), Err) {
  let req = r4_sansio.communication_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.communication
  })
}

pub fn communicationrequest_create(
  resource: r4.Communicationrequest,
  client: FhirClient,
) -> Result(r4.Communicationrequest, Err) {
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
) -> Result(r4.Communicationrequest, Err) {
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
) -> Result(r4.Communicationrequest, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "CommunicationRequest", client)
}

pub fn communicationrequest_search_bundled(
  sp: r4_sansio.SpCommunicationrequest,
  client: FhirClient,
) {
  let req = r4_sansio.communicationrequest_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn communicationrequest_search(
  sp: r4_sansio.SpCommunicationrequest,
  client: FhirClient,
) -> Result(List(r4.Communicationrequest), Err) {
  let req = r4_sansio.communicationrequest_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.communicationrequest
  })
}

pub fn compartmentdefinition_create(
  resource: r4.Compartmentdefinition,
  client: FhirClient,
) -> Result(r4.Compartmentdefinition, Err) {
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
) -> Result(r4.Compartmentdefinition, Err) {
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
) -> Result(r4.Compartmentdefinition, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "CompartmentDefinition", client)
}

pub fn compartmentdefinition_search_bundled(
  sp: r4_sansio.SpCompartmentdefinition,
  client: FhirClient,
) {
  let req = r4_sansio.compartmentdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn compartmentdefinition_search(
  sp: r4_sansio.SpCompartmentdefinition,
  client: FhirClient,
) -> Result(List(r4.Compartmentdefinition), Err) {
  let req = r4_sansio.compartmentdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.compartmentdefinition
  })
}

pub fn composition_create(
  resource: r4.Composition,
  client: FhirClient,
) -> Result(r4.Composition, Err) {
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
) -> Result(r4.Composition, Err) {
  any_read(id, client, "Composition", r4.composition_decoder())
}

pub fn composition_update(
  resource: r4.Composition,
  client: FhirClient,
) -> Result(r4.Composition, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Composition", client)
}

pub fn composition_search_bundled(
  sp: r4_sansio.SpComposition,
  client: FhirClient,
) {
  let req = r4_sansio.composition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn composition_search(
  sp: r4_sansio.SpComposition,
  client: FhirClient,
) -> Result(List(r4.Composition), Err) {
  let req = r4_sansio.composition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.composition
  })
}

pub fn conceptmap_create(
  resource: r4.Conceptmap,
  client: FhirClient,
) -> Result(r4.Conceptmap, Err) {
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
) -> Result(r4.Conceptmap, Err) {
  any_read(id, client, "ConceptMap", r4.conceptmap_decoder())
}

pub fn conceptmap_update(
  resource: r4.Conceptmap,
  client: FhirClient,
) -> Result(r4.Conceptmap, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "ConceptMap", client)
}

pub fn conceptmap_search_bundled(sp: r4_sansio.SpConceptmap, client: FhirClient) {
  let req = r4_sansio.conceptmap_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn conceptmap_search(
  sp: r4_sansio.SpConceptmap,
  client: FhirClient,
) -> Result(List(r4.Conceptmap), Err) {
  let req = r4_sansio.conceptmap_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.conceptmap
  })
}

pub fn condition_create(
  resource: r4.Condition,
  client: FhirClient,
) -> Result(r4.Condition, Err) {
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
) -> Result(r4.Condition, Err) {
  any_read(id, client, "Condition", r4.condition_decoder())
}

pub fn condition_update(
  resource: r4.Condition,
  client: FhirClient,
) -> Result(r4.Condition, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Condition", client)
}

pub fn condition_search_bundled(sp: r4_sansio.SpCondition, client: FhirClient) {
  let req = r4_sansio.condition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn condition_search(
  sp: r4_sansio.SpCondition,
  client: FhirClient,
) -> Result(List(r4.Condition), Err) {
  let req = r4_sansio.condition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.condition
  })
}

pub fn consent_create(
  resource: r4.Consent,
  client: FhirClient,
) -> Result(r4.Consent, Err) {
  any_create(
    r4.consent_to_json(resource),
    "Consent",
    r4.consent_decoder(),
    client,
  )
}

pub fn consent_read(id: String, client: FhirClient) -> Result(r4.Consent, Err) {
  any_read(id, client, "Consent", r4.consent_decoder())
}

pub fn consent_update(
  resource: r4.Consent,
  client: FhirClient,
) -> Result(r4.Consent, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Consent", client)
}

pub fn consent_search_bundled(sp: r4_sansio.SpConsent, client: FhirClient) {
  let req = r4_sansio.consent_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn consent_search(
  sp: r4_sansio.SpConsent,
  client: FhirClient,
) -> Result(List(r4.Consent), Err) {
  let req = r4_sansio.consent_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.consent
  })
}

pub fn contract_create(
  resource: r4.Contract,
  client: FhirClient,
) -> Result(r4.Contract, Err) {
  any_create(
    r4.contract_to_json(resource),
    "Contract",
    r4.contract_decoder(),
    client,
  )
}

pub fn contract_read(id: String, client: FhirClient) -> Result(r4.Contract, Err) {
  any_read(id, client, "Contract", r4.contract_decoder())
}

pub fn contract_update(
  resource: r4.Contract,
  client: FhirClient,
) -> Result(r4.Contract, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Contract", client)
}

pub fn contract_search_bundled(sp: r4_sansio.SpContract, client: FhirClient) {
  let req = r4_sansio.contract_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn contract_search(
  sp: r4_sansio.SpContract,
  client: FhirClient,
) -> Result(List(r4.Contract), Err) {
  let req = r4_sansio.contract_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.contract
  })
}

pub fn coverage_create(
  resource: r4.Coverage,
  client: FhirClient,
) -> Result(r4.Coverage, Err) {
  any_create(
    r4.coverage_to_json(resource),
    "Coverage",
    r4.coverage_decoder(),
    client,
  )
}

pub fn coverage_read(id: String, client: FhirClient) -> Result(r4.Coverage, Err) {
  any_read(id, client, "Coverage", r4.coverage_decoder())
}

pub fn coverage_update(
  resource: r4.Coverage,
  client: FhirClient,
) -> Result(r4.Coverage, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Coverage", client)
}

pub fn coverage_search_bundled(sp: r4_sansio.SpCoverage, client: FhirClient) {
  let req = r4_sansio.coverage_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn coverage_search(
  sp: r4_sansio.SpCoverage,
  client: FhirClient,
) -> Result(List(r4.Coverage), Err) {
  let req = r4_sansio.coverage_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.coverage
  })
}

pub fn coverageeligibilityrequest_create(
  resource: r4.Coverageeligibilityrequest,
  client: FhirClient,
) -> Result(r4.Coverageeligibilityrequest, Err) {
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
) -> Result(r4.Coverageeligibilityrequest, Err) {
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
) -> Result(r4.Coverageeligibilityrequest, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "CoverageEligibilityRequest", client)
}

pub fn coverageeligibilityrequest_search_bundled(
  sp: r4_sansio.SpCoverageeligibilityrequest,
  client: FhirClient,
) {
  let req = r4_sansio.coverageeligibilityrequest_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn coverageeligibilityrequest_search(
  sp: r4_sansio.SpCoverageeligibilityrequest,
  client: FhirClient,
) -> Result(List(r4.Coverageeligibilityrequest), Err) {
  let req = r4_sansio.coverageeligibilityrequest_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.coverageeligibilityrequest
  })
}

pub fn coverageeligibilityresponse_create(
  resource: r4.Coverageeligibilityresponse,
  client: FhirClient,
) -> Result(r4.Coverageeligibilityresponse, Err) {
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
) -> Result(r4.Coverageeligibilityresponse, Err) {
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
) -> Result(r4.Coverageeligibilityresponse, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "CoverageEligibilityResponse", client)
}

pub fn coverageeligibilityresponse_search_bundled(
  sp: r4_sansio.SpCoverageeligibilityresponse,
  client: FhirClient,
) {
  let req = r4_sansio.coverageeligibilityresponse_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn coverageeligibilityresponse_search(
  sp: r4_sansio.SpCoverageeligibilityresponse,
  client: FhirClient,
) -> Result(List(r4.Coverageeligibilityresponse), Err) {
  let req = r4_sansio.coverageeligibilityresponse_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.coverageeligibilityresponse
  })
}

pub fn detectedissue_create(
  resource: r4.Detectedissue,
  client: FhirClient,
) -> Result(r4.Detectedissue, Err) {
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
) -> Result(r4.Detectedissue, Err) {
  any_read(id, client, "DetectedIssue", r4.detectedissue_decoder())
}

pub fn detectedissue_update(
  resource: r4.Detectedissue,
  client: FhirClient,
) -> Result(r4.Detectedissue, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "DetectedIssue", client)
}

pub fn detectedissue_search_bundled(
  sp: r4_sansio.SpDetectedissue,
  client: FhirClient,
) {
  let req = r4_sansio.detectedissue_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn detectedissue_search(
  sp: r4_sansio.SpDetectedissue,
  client: FhirClient,
) -> Result(List(r4.Detectedissue), Err) {
  let req = r4_sansio.detectedissue_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.detectedissue
  })
}

pub fn device_create(
  resource: r4.Device,
  client: FhirClient,
) -> Result(r4.Device, Err) {
  any_create(r4.device_to_json(resource), "Device", r4.device_decoder(), client)
}

pub fn device_read(id: String, client: FhirClient) -> Result(r4.Device, Err) {
  any_read(id, client, "Device", r4.device_decoder())
}

pub fn device_update(
  resource: r4.Device,
  client: FhirClient,
) -> Result(r4.Device, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Device", client)
}

pub fn device_search_bundled(sp: r4_sansio.SpDevice, client: FhirClient) {
  let req = r4_sansio.device_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn device_search(
  sp: r4_sansio.SpDevice,
  client: FhirClient,
) -> Result(List(r4.Device), Err) {
  let req = r4_sansio.device_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.device
  })
}

pub fn devicedefinition_create(
  resource: r4.Devicedefinition,
  client: FhirClient,
) -> Result(r4.Devicedefinition, Err) {
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
) -> Result(r4.Devicedefinition, Err) {
  any_read(id, client, "DeviceDefinition", r4.devicedefinition_decoder())
}

pub fn devicedefinition_update(
  resource: r4.Devicedefinition,
  client: FhirClient,
) -> Result(r4.Devicedefinition, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "DeviceDefinition", client)
}

pub fn devicedefinition_search_bundled(
  sp: r4_sansio.SpDevicedefinition,
  client: FhirClient,
) {
  let req = r4_sansio.devicedefinition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn devicedefinition_search(
  sp: r4_sansio.SpDevicedefinition,
  client: FhirClient,
) -> Result(List(r4.Devicedefinition), Err) {
  let req = r4_sansio.devicedefinition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.devicedefinition
  })
}

pub fn devicemetric_create(
  resource: r4.Devicemetric,
  client: FhirClient,
) -> Result(r4.Devicemetric, Err) {
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
) -> Result(r4.Devicemetric, Err) {
  any_read(id, client, "DeviceMetric", r4.devicemetric_decoder())
}

pub fn devicemetric_update(
  resource: r4.Devicemetric,
  client: FhirClient,
) -> Result(r4.Devicemetric, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "DeviceMetric", client)
}

pub fn devicemetric_search_bundled(
  sp: r4_sansio.SpDevicemetric,
  client: FhirClient,
) {
  let req = r4_sansio.devicemetric_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn devicemetric_search(
  sp: r4_sansio.SpDevicemetric,
  client: FhirClient,
) -> Result(List(r4.Devicemetric), Err) {
  let req = r4_sansio.devicemetric_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.devicemetric
  })
}

pub fn devicerequest_create(
  resource: r4.Devicerequest,
  client: FhirClient,
) -> Result(r4.Devicerequest, Err) {
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
) -> Result(r4.Devicerequest, Err) {
  any_read(id, client, "DeviceRequest", r4.devicerequest_decoder())
}

pub fn devicerequest_update(
  resource: r4.Devicerequest,
  client: FhirClient,
) -> Result(r4.Devicerequest, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "DeviceRequest", client)
}

pub fn devicerequest_search_bundled(
  sp: r4_sansio.SpDevicerequest,
  client: FhirClient,
) {
  let req = r4_sansio.devicerequest_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn devicerequest_search(
  sp: r4_sansio.SpDevicerequest,
  client: FhirClient,
) -> Result(List(r4.Devicerequest), Err) {
  let req = r4_sansio.devicerequest_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.devicerequest
  })
}

pub fn deviceusestatement_create(
  resource: r4.Deviceusestatement,
  client: FhirClient,
) -> Result(r4.Deviceusestatement, Err) {
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
) -> Result(r4.Deviceusestatement, Err) {
  any_read(id, client, "DeviceUseStatement", r4.deviceusestatement_decoder())
}

pub fn deviceusestatement_update(
  resource: r4.Deviceusestatement,
  client: FhirClient,
) -> Result(r4.Deviceusestatement, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "DeviceUseStatement", client)
}

pub fn deviceusestatement_search_bundled(
  sp: r4_sansio.SpDeviceusestatement,
  client: FhirClient,
) {
  let req = r4_sansio.deviceusestatement_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn deviceusestatement_search(
  sp: r4_sansio.SpDeviceusestatement,
  client: FhirClient,
) -> Result(List(r4.Deviceusestatement), Err) {
  let req = r4_sansio.deviceusestatement_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.deviceusestatement
  })
}

pub fn diagnosticreport_create(
  resource: r4.Diagnosticreport,
  client: FhirClient,
) -> Result(r4.Diagnosticreport, Err) {
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
) -> Result(r4.Diagnosticreport, Err) {
  any_read(id, client, "DiagnosticReport", r4.diagnosticreport_decoder())
}

pub fn diagnosticreport_update(
  resource: r4.Diagnosticreport,
  client: FhirClient,
) -> Result(r4.Diagnosticreport, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "DiagnosticReport", client)
}

pub fn diagnosticreport_search_bundled(
  sp: r4_sansio.SpDiagnosticreport,
  client: FhirClient,
) {
  let req = r4_sansio.diagnosticreport_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn diagnosticreport_search(
  sp: r4_sansio.SpDiagnosticreport,
  client: FhirClient,
) -> Result(List(r4.Diagnosticreport), Err) {
  let req = r4_sansio.diagnosticreport_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.diagnosticreport
  })
}

pub fn documentmanifest_create(
  resource: r4.Documentmanifest,
  client: FhirClient,
) -> Result(r4.Documentmanifest, Err) {
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
) -> Result(r4.Documentmanifest, Err) {
  any_read(id, client, "DocumentManifest", r4.documentmanifest_decoder())
}

pub fn documentmanifest_update(
  resource: r4.Documentmanifest,
  client: FhirClient,
) -> Result(r4.Documentmanifest, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "DocumentManifest", client)
}

pub fn documentmanifest_search_bundled(
  sp: r4_sansio.SpDocumentmanifest,
  client: FhirClient,
) {
  let req = r4_sansio.documentmanifest_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn documentmanifest_search(
  sp: r4_sansio.SpDocumentmanifest,
  client: FhirClient,
) -> Result(List(r4.Documentmanifest), Err) {
  let req = r4_sansio.documentmanifest_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.documentmanifest
  })
}

pub fn documentreference_create(
  resource: r4.Documentreference,
  client: FhirClient,
) -> Result(r4.Documentreference, Err) {
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
) -> Result(r4.Documentreference, Err) {
  any_read(id, client, "DocumentReference", r4.documentreference_decoder())
}

pub fn documentreference_update(
  resource: r4.Documentreference,
  client: FhirClient,
) -> Result(r4.Documentreference, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "DocumentReference", client)
}

pub fn documentreference_search_bundled(
  sp: r4_sansio.SpDocumentreference,
  client: FhirClient,
) {
  let req = r4_sansio.documentreference_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn documentreference_search(
  sp: r4_sansio.SpDocumentreference,
  client: FhirClient,
) -> Result(List(r4.Documentreference), Err) {
  let req = r4_sansio.documentreference_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.documentreference
  })
}

pub fn effectevidencesynthesis_create(
  resource: r4.Effectevidencesynthesis,
  client: FhirClient,
) -> Result(r4.Effectevidencesynthesis, Err) {
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
) -> Result(r4.Effectevidencesynthesis, Err) {
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
) -> Result(r4.Effectevidencesynthesis, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "EffectEvidenceSynthesis", client)
}

pub fn effectevidencesynthesis_search_bundled(
  sp: r4_sansio.SpEffectevidencesynthesis,
  client: FhirClient,
) {
  let req = r4_sansio.effectevidencesynthesis_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn effectevidencesynthesis_search(
  sp: r4_sansio.SpEffectevidencesynthesis,
  client: FhirClient,
) -> Result(List(r4.Effectevidencesynthesis), Err) {
  let req = r4_sansio.effectevidencesynthesis_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.effectevidencesynthesis
  })
}

pub fn encounter_create(
  resource: r4.Encounter,
  client: FhirClient,
) -> Result(r4.Encounter, Err) {
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
) -> Result(r4.Encounter, Err) {
  any_read(id, client, "Encounter", r4.encounter_decoder())
}

pub fn encounter_update(
  resource: r4.Encounter,
  client: FhirClient,
) -> Result(r4.Encounter, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Encounter", client)
}

pub fn encounter_search_bundled(sp: r4_sansio.SpEncounter, client: FhirClient) {
  let req = r4_sansio.encounter_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn encounter_search(
  sp: r4_sansio.SpEncounter,
  client: FhirClient,
) -> Result(List(r4.Encounter), Err) {
  let req = r4_sansio.encounter_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.encounter
  })
}

pub fn endpoint_create(
  resource: r4.Endpoint,
  client: FhirClient,
) -> Result(r4.Endpoint, Err) {
  any_create(
    r4.endpoint_to_json(resource),
    "Endpoint",
    r4.endpoint_decoder(),
    client,
  )
}

pub fn endpoint_read(id: String, client: FhirClient) -> Result(r4.Endpoint, Err) {
  any_read(id, client, "Endpoint", r4.endpoint_decoder())
}

pub fn endpoint_update(
  resource: r4.Endpoint,
  client: FhirClient,
) -> Result(r4.Endpoint, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Endpoint", client)
}

pub fn endpoint_search_bundled(sp: r4_sansio.SpEndpoint, client: FhirClient) {
  let req = r4_sansio.endpoint_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn endpoint_search(
  sp: r4_sansio.SpEndpoint,
  client: FhirClient,
) -> Result(List(r4.Endpoint), Err) {
  let req = r4_sansio.endpoint_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.endpoint
  })
}

pub fn enrollmentrequest_create(
  resource: r4.Enrollmentrequest,
  client: FhirClient,
) -> Result(r4.Enrollmentrequest, Err) {
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
) -> Result(r4.Enrollmentrequest, Err) {
  any_read(id, client, "EnrollmentRequest", r4.enrollmentrequest_decoder())
}

pub fn enrollmentrequest_update(
  resource: r4.Enrollmentrequest,
  client: FhirClient,
) -> Result(r4.Enrollmentrequest, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "EnrollmentRequest", client)
}

pub fn enrollmentrequest_search_bundled(
  sp: r4_sansio.SpEnrollmentrequest,
  client: FhirClient,
) {
  let req = r4_sansio.enrollmentrequest_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn enrollmentrequest_search(
  sp: r4_sansio.SpEnrollmentrequest,
  client: FhirClient,
) -> Result(List(r4.Enrollmentrequest), Err) {
  let req = r4_sansio.enrollmentrequest_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.enrollmentrequest
  })
}

pub fn enrollmentresponse_create(
  resource: r4.Enrollmentresponse,
  client: FhirClient,
) -> Result(r4.Enrollmentresponse, Err) {
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
) -> Result(r4.Enrollmentresponse, Err) {
  any_read(id, client, "EnrollmentResponse", r4.enrollmentresponse_decoder())
}

pub fn enrollmentresponse_update(
  resource: r4.Enrollmentresponse,
  client: FhirClient,
) -> Result(r4.Enrollmentresponse, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "EnrollmentResponse", client)
}

pub fn enrollmentresponse_search_bundled(
  sp: r4_sansio.SpEnrollmentresponse,
  client: FhirClient,
) {
  let req = r4_sansio.enrollmentresponse_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn enrollmentresponse_search(
  sp: r4_sansio.SpEnrollmentresponse,
  client: FhirClient,
) -> Result(List(r4.Enrollmentresponse), Err) {
  let req = r4_sansio.enrollmentresponse_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.enrollmentresponse
  })
}

pub fn episodeofcare_create(
  resource: r4.Episodeofcare,
  client: FhirClient,
) -> Result(r4.Episodeofcare, Err) {
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
) -> Result(r4.Episodeofcare, Err) {
  any_read(id, client, "EpisodeOfCare", r4.episodeofcare_decoder())
}

pub fn episodeofcare_update(
  resource: r4.Episodeofcare,
  client: FhirClient,
) -> Result(r4.Episodeofcare, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "EpisodeOfCare", client)
}

pub fn episodeofcare_search_bundled(
  sp: r4_sansio.SpEpisodeofcare,
  client: FhirClient,
) {
  let req = r4_sansio.episodeofcare_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn episodeofcare_search(
  sp: r4_sansio.SpEpisodeofcare,
  client: FhirClient,
) -> Result(List(r4.Episodeofcare), Err) {
  let req = r4_sansio.episodeofcare_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.episodeofcare
  })
}

pub fn eventdefinition_create(
  resource: r4.Eventdefinition,
  client: FhirClient,
) -> Result(r4.Eventdefinition, Err) {
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
) -> Result(r4.Eventdefinition, Err) {
  any_read(id, client, "EventDefinition", r4.eventdefinition_decoder())
}

pub fn eventdefinition_update(
  resource: r4.Eventdefinition,
  client: FhirClient,
) -> Result(r4.Eventdefinition, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "EventDefinition", client)
}

pub fn eventdefinition_search_bundled(
  sp: r4_sansio.SpEventdefinition,
  client: FhirClient,
) {
  let req = r4_sansio.eventdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn eventdefinition_search(
  sp: r4_sansio.SpEventdefinition,
  client: FhirClient,
) -> Result(List(r4.Eventdefinition), Err) {
  let req = r4_sansio.eventdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.eventdefinition
  })
}

pub fn evidence_create(
  resource: r4.Evidence,
  client: FhirClient,
) -> Result(r4.Evidence, Err) {
  any_create(
    r4.evidence_to_json(resource),
    "Evidence",
    r4.evidence_decoder(),
    client,
  )
}

pub fn evidence_read(id: String, client: FhirClient) -> Result(r4.Evidence, Err) {
  any_read(id, client, "Evidence", r4.evidence_decoder())
}

pub fn evidence_update(
  resource: r4.Evidence,
  client: FhirClient,
) -> Result(r4.Evidence, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Evidence", client)
}

pub fn evidence_search_bundled(sp: r4_sansio.SpEvidence, client: FhirClient) {
  let req = r4_sansio.evidence_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn evidence_search(
  sp: r4_sansio.SpEvidence,
  client: FhirClient,
) -> Result(List(r4.Evidence), Err) {
  let req = r4_sansio.evidence_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.evidence
  })
}

pub fn evidencevariable_create(
  resource: r4.Evidencevariable,
  client: FhirClient,
) -> Result(r4.Evidencevariable, Err) {
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
) -> Result(r4.Evidencevariable, Err) {
  any_read(id, client, "EvidenceVariable", r4.evidencevariable_decoder())
}

pub fn evidencevariable_update(
  resource: r4.Evidencevariable,
  client: FhirClient,
) -> Result(r4.Evidencevariable, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "EvidenceVariable", client)
}

pub fn evidencevariable_search_bundled(
  sp: r4_sansio.SpEvidencevariable,
  client: FhirClient,
) {
  let req = r4_sansio.evidencevariable_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn evidencevariable_search(
  sp: r4_sansio.SpEvidencevariable,
  client: FhirClient,
) -> Result(List(r4.Evidencevariable), Err) {
  let req = r4_sansio.evidencevariable_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.evidencevariable
  })
}

pub fn examplescenario_create(
  resource: r4.Examplescenario,
  client: FhirClient,
) -> Result(r4.Examplescenario, Err) {
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
) -> Result(r4.Examplescenario, Err) {
  any_read(id, client, "ExampleScenario", r4.examplescenario_decoder())
}

pub fn examplescenario_update(
  resource: r4.Examplescenario,
  client: FhirClient,
) -> Result(r4.Examplescenario, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "ExampleScenario", client)
}

pub fn examplescenario_search_bundled(
  sp: r4_sansio.SpExamplescenario,
  client: FhirClient,
) {
  let req = r4_sansio.examplescenario_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn examplescenario_search(
  sp: r4_sansio.SpExamplescenario,
  client: FhirClient,
) -> Result(List(r4.Examplescenario), Err) {
  let req = r4_sansio.examplescenario_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.examplescenario
  })
}

pub fn explanationofbenefit_create(
  resource: r4.Explanationofbenefit,
  client: FhirClient,
) -> Result(r4.Explanationofbenefit, Err) {
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
) -> Result(r4.Explanationofbenefit, Err) {
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
) -> Result(r4.Explanationofbenefit, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "ExplanationOfBenefit", client)
}

pub fn explanationofbenefit_search_bundled(
  sp: r4_sansio.SpExplanationofbenefit,
  client: FhirClient,
) {
  let req = r4_sansio.explanationofbenefit_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn explanationofbenefit_search(
  sp: r4_sansio.SpExplanationofbenefit,
  client: FhirClient,
) -> Result(List(r4.Explanationofbenefit), Err) {
  let req = r4_sansio.explanationofbenefit_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.explanationofbenefit
  })
}

pub fn familymemberhistory_create(
  resource: r4.Familymemberhistory,
  client: FhirClient,
) -> Result(r4.Familymemberhistory, Err) {
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
) -> Result(r4.Familymemberhistory, Err) {
  any_read(id, client, "FamilyMemberHistory", r4.familymemberhistory_decoder())
}

pub fn familymemberhistory_update(
  resource: r4.Familymemberhistory,
  client: FhirClient,
) -> Result(r4.Familymemberhistory, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "FamilyMemberHistory", client)
}

pub fn familymemberhistory_search_bundled(
  sp: r4_sansio.SpFamilymemberhistory,
  client: FhirClient,
) {
  let req = r4_sansio.familymemberhistory_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn familymemberhistory_search(
  sp: r4_sansio.SpFamilymemberhistory,
  client: FhirClient,
) -> Result(List(r4.Familymemberhistory), Err) {
  let req = r4_sansio.familymemberhistory_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.familymemberhistory
  })
}

pub fn flag_create(
  resource: r4.Flag,
  client: FhirClient,
) -> Result(r4.Flag, Err) {
  any_create(r4.flag_to_json(resource), "Flag", r4.flag_decoder(), client)
}

pub fn flag_read(id: String, client: FhirClient) -> Result(r4.Flag, Err) {
  any_read(id, client, "Flag", r4.flag_decoder())
}

pub fn flag_update(
  resource: r4.Flag,
  client: FhirClient,
) -> Result(r4.Flag, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Flag", client)
}

pub fn flag_search_bundled(sp: r4_sansio.SpFlag, client: FhirClient) {
  let req = r4_sansio.flag_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn flag_search(
  sp: r4_sansio.SpFlag,
  client: FhirClient,
) -> Result(List(r4.Flag), Err) {
  let req = r4_sansio.flag_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.flag
  })
}

pub fn goal_create(
  resource: r4.Goal,
  client: FhirClient,
) -> Result(r4.Goal, Err) {
  any_create(r4.goal_to_json(resource), "Goal", r4.goal_decoder(), client)
}

pub fn goal_read(id: String, client: FhirClient) -> Result(r4.Goal, Err) {
  any_read(id, client, "Goal", r4.goal_decoder())
}

pub fn goal_update(
  resource: r4.Goal,
  client: FhirClient,
) -> Result(r4.Goal, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Goal", client)
}

pub fn goal_search_bundled(sp: r4_sansio.SpGoal, client: FhirClient) {
  let req = r4_sansio.goal_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn goal_search(
  sp: r4_sansio.SpGoal,
  client: FhirClient,
) -> Result(List(r4.Goal), Err) {
  let req = r4_sansio.goal_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.goal
  })
}

pub fn graphdefinition_create(
  resource: r4.Graphdefinition,
  client: FhirClient,
) -> Result(r4.Graphdefinition, Err) {
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
) -> Result(r4.Graphdefinition, Err) {
  any_read(id, client, "GraphDefinition", r4.graphdefinition_decoder())
}

pub fn graphdefinition_update(
  resource: r4.Graphdefinition,
  client: FhirClient,
) -> Result(r4.Graphdefinition, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "GraphDefinition", client)
}

pub fn graphdefinition_search_bundled(
  sp: r4_sansio.SpGraphdefinition,
  client: FhirClient,
) {
  let req = r4_sansio.graphdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn graphdefinition_search(
  sp: r4_sansio.SpGraphdefinition,
  client: FhirClient,
) -> Result(List(r4.Graphdefinition), Err) {
  let req = r4_sansio.graphdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.graphdefinition
  })
}

pub fn group_create(
  resource: r4.Group,
  client: FhirClient,
) -> Result(r4.Group, Err) {
  any_create(r4.group_to_json(resource), "Group", r4.group_decoder(), client)
}

pub fn group_read(id: String, client: FhirClient) -> Result(r4.Group, Err) {
  any_read(id, client, "Group", r4.group_decoder())
}

pub fn group_update(
  resource: r4.Group,
  client: FhirClient,
) -> Result(r4.Group, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Group", client)
}

pub fn group_search_bundled(sp: r4_sansio.SpGroup, client: FhirClient) {
  let req = r4_sansio.group_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn group_search(
  sp: r4_sansio.SpGroup,
  client: FhirClient,
) -> Result(List(r4.Group), Err) {
  let req = r4_sansio.group_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.group
  })
}

pub fn guidanceresponse_create(
  resource: r4.Guidanceresponse,
  client: FhirClient,
) -> Result(r4.Guidanceresponse, Err) {
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
) -> Result(r4.Guidanceresponse, Err) {
  any_read(id, client, "GuidanceResponse", r4.guidanceresponse_decoder())
}

pub fn guidanceresponse_update(
  resource: r4.Guidanceresponse,
  client: FhirClient,
) -> Result(r4.Guidanceresponse, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "GuidanceResponse", client)
}

pub fn guidanceresponse_search_bundled(
  sp: r4_sansio.SpGuidanceresponse,
  client: FhirClient,
) {
  let req = r4_sansio.guidanceresponse_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn guidanceresponse_search(
  sp: r4_sansio.SpGuidanceresponse,
  client: FhirClient,
) -> Result(List(r4.Guidanceresponse), Err) {
  let req = r4_sansio.guidanceresponse_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.guidanceresponse
  })
}

pub fn healthcareservice_create(
  resource: r4.Healthcareservice,
  client: FhirClient,
) -> Result(r4.Healthcareservice, Err) {
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
) -> Result(r4.Healthcareservice, Err) {
  any_read(id, client, "HealthcareService", r4.healthcareservice_decoder())
}

pub fn healthcareservice_update(
  resource: r4.Healthcareservice,
  client: FhirClient,
) -> Result(r4.Healthcareservice, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "HealthcareService", client)
}

pub fn healthcareservice_search_bundled(
  sp: r4_sansio.SpHealthcareservice,
  client: FhirClient,
) {
  let req = r4_sansio.healthcareservice_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn healthcareservice_search(
  sp: r4_sansio.SpHealthcareservice,
  client: FhirClient,
) -> Result(List(r4.Healthcareservice), Err) {
  let req = r4_sansio.healthcareservice_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.healthcareservice
  })
}

pub fn imagingstudy_create(
  resource: r4.Imagingstudy,
  client: FhirClient,
) -> Result(r4.Imagingstudy, Err) {
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
) -> Result(r4.Imagingstudy, Err) {
  any_read(id, client, "ImagingStudy", r4.imagingstudy_decoder())
}

pub fn imagingstudy_update(
  resource: r4.Imagingstudy,
  client: FhirClient,
) -> Result(r4.Imagingstudy, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "ImagingStudy", client)
}

pub fn imagingstudy_search_bundled(
  sp: r4_sansio.SpImagingstudy,
  client: FhirClient,
) {
  let req = r4_sansio.imagingstudy_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn imagingstudy_search(
  sp: r4_sansio.SpImagingstudy,
  client: FhirClient,
) -> Result(List(r4.Imagingstudy), Err) {
  let req = r4_sansio.imagingstudy_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.imagingstudy
  })
}

pub fn immunization_create(
  resource: r4.Immunization,
  client: FhirClient,
) -> Result(r4.Immunization, Err) {
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
) -> Result(r4.Immunization, Err) {
  any_read(id, client, "Immunization", r4.immunization_decoder())
}

pub fn immunization_update(
  resource: r4.Immunization,
  client: FhirClient,
) -> Result(r4.Immunization, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Immunization", client)
}

pub fn immunization_search_bundled(
  sp: r4_sansio.SpImmunization,
  client: FhirClient,
) {
  let req = r4_sansio.immunization_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn immunization_search(
  sp: r4_sansio.SpImmunization,
  client: FhirClient,
) -> Result(List(r4.Immunization), Err) {
  let req = r4_sansio.immunization_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.immunization
  })
}

pub fn immunizationevaluation_create(
  resource: r4.Immunizationevaluation,
  client: FhirClient,
) -> Result(r4.Immunizationevaluation, Err) {
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
) -> Result(r4.Immunizationevaluation, Err) {
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
) -> Result(r4.Immunizationevaluation, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "ImmunizationEvaluation", client)
}

pub fn immunizationevaluation_search_bundled(
  sp: r4_sansio.SpImmunizationevaluation,
  client: FhirClient,
) {
  let req = r4_sansio.immunizationevaluation_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn immunizationevaluation_search(
  sp: r4_sansio.SpImmunizationevaluation,
  client: FhirClient,
) -> Result(List(r4.Immunizationevaluation), Err) {
  let req = r4_sansio.immunizationevaluation_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.immunizationevaluation
  })
}

pub fn immunizationrecommendation_create(
  resource: r4.Immunizationrecommendation,
  client: FhirClient,
) -> Result(r4.Immunizationrecommendation, Err) {
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
) -> Result(r4.Immunizationrecommendation, Err) {
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
) -> Result(r4.Immunizationrecommendation, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "ImmunizationRecommendation", client)
}

pub fn immunizationrecommendation_search_bundled(
  sp: r4_sansio.SpImmunizationrecommendation,
  client: FhirClient,
) {
  let req = r4_sansio.immunizationrecommendation_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn immunizationrecommendation_search(
  sp: r4_sansio.SpImmunizationrecommendation,
  client: FhirClient,
) -> Result(List(r4.Immunizationrecommendation), Err) {
  let req = r4_sansio.immunizationrecommendation_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.immunizationrecommendation
  })
}

pub fn implementationguide_create(
  resource: r4.Implementationguide,
  client: FhirClient,
) -> Result(r4.Implementationguide, Err) {
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
) -> Result(r4.Implementationguide, Err) {
  any_read(id, client, "ImplementationGuide", r4.implementationguide_decoder())
}

pub fn implementationguide_update(
  resource: r4.Implementationguide,
  client: FhirClient,
) -> Result(r4.Implementationguide, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "ImplementationGuide", client)
}

pub fn implementationguide_search_bundled(
  sp: r4_sansio.SpImplementationguide,
  client: FhirClient,
) {
  let req = r4_sansio.implementationguide_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn implementationguide_search(
  sp: r4_sansio.SpImplementationguide,
  client: FhirClient,
) -> Result(List(r4.Implementationguide), Err) {
  let req = r4_sansio.implementationguide_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.implementationguide
  })
}

pub fn insuranceplan_create(
  resource: r4.Insuranceplan,
  client: FhirClient,
) -> Result(r4.Insuranceplan, Err) {
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
) -> Result(r4.Insuranceplan, Err) {
  any_read(id, client, "InsurancePlan", r4.insuranceplan_decoder())
}

pub fn insuranceplan_update(
  resource: r4.Insuranceplan,
  client: FhirClient,
) -> Result(r4.Insuranceplan, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "InsurancePlan", client)
}

pub fn insuranceplan_search_bundled(
  sp: r4_sansio.SpInsuranceplan,
  client: FhirClient,
) {
  let req = r4_sansio.insuranceplan_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn insuranceplan_search(
  sp: r4_sansio.SpInsuranceplan,
  client: FhirClient,
) -> Result(List(r4.Insuranceplan), Err) {
  let req = r4_sansio.insuranceplan_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.insuranceplan
  })
}

pub fn invoice_create(
  resource: r4.Invoice,
  client: FhirClient,
) -> Result(r4.Invoice, Err) {
  any_create(
    r4.invoice_to_json(resource),
    "Invoice",
    r4.invoice_decoder(),
    client,
  )
}

pub fn invoice_read(id: String, client: FhirClient) -> Result(r4.Invoice, Err) {
  any_read(id, client, "Invoice", r4.invoice_decoder())
}

pub fn invoice_update(
  resource: r4.Invoice,
  client: FhirClient,
) -> Result(r4.Invoice, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Invoice", client)
}

pub fn invoice_search_bundled(sp: r4_sansio.SpInvoice, client: FhirClient) {
  let req = r4_sansio.invoice_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn invoice_search(
  sp: r4_sansio.SpInvoice,
  client: FhirClient,
) -> Result(List(r4.Invoice), Err) {
  let req = r4_sansio.invoice_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.invoice
  })
}

pub fn library_create(
  resource: r4.Library,
  client: FhirClient,
) -> Result(r4.Library, Err) {
  any_create(
    r4.library_to_json(resource),
    "Library",
    r4.library_decoder(),
    client,
  )
}

pub fn library_read(id: String, client: FhirClient) -> Result(r4.Library, Err) {
  any_read(id, client, "Library", r4.library_decoder())
}

pub fn library_update(
  resource: r4.Library,
  client: FhirClient,
) -> Result(r4.Library, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Library", client)
}

pub fn library_search_bundled(sp: r4_sansio.SpLibrary, client: FhirClient) {
  let req = r4_sansio.library_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn library_search(
  sp: r4_sansio.SpLibrary,
  client: FhirClient,
) -> Result(List(r4.Library), Err) {
  let req = r4_sansio.library_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.library
  })
}

pub fn linkage_create(
  resource: r4.Linkage,
  client: FhirClient,
) -> Result(r4.Linkage, Err) {
  any_create(
    r4.linkage_to_json(resource),
    "Linkage",
    r4.linkage_decoder(),
    client,
  )
}

pub fn linkage_read(id: String, client: FhirClient) -> Result(r4.Linkage, Err) {
  any_read(id, client, "Linkage", r4.linkage_decoder())
}

pub fn linkage_update(
  resource: r4.Linkage,
  client: FhirClient,
) -> Result(r4.Linkage, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Linkage", client)
}

pub fn linkage_search_bundled(sp: r4_sansio.SpLinkage, client: FhirClient) {
  let req = r4_sansio.linkage_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn linkage_search(
  sp: r4_sansio.SpLinkage,
  client: FhirClient,
) -> Result(List(r4.Linkage), Err) {
  let req = r4_sansio.linkage_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.linkage
  })
}

pub fn listfhir_create(
  resource: r4.Listfhir,
  client: FhirClient,
) -> Result(r4.Listfhir, Err) {
  any_create(
    r4.listfhir_to_json(resource),
    "List",
    r4.listfhir_decoder(),
    client,
  )
}

pub fn listfhir_read(id: String, client: FhirClient) -> Result(r4.Listfhir, Err) {
  any_read(id, client, "List", r4.listfhir_decoder())
}

pub fn listfhir_update(
  resource: r4.Listfhir,
  client: FhirClient,
) -> Result(r4.Listfhir, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "List", client)
}

pub fn listfhir_search_bundled(sp: r4_sansio.SpListfhir, client: FhirClient) {
  let req = r4_sansio.listfhir_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn listfhir_search(
  sp: r4_sansio.SpListfhir,
  client: FhirClient,
) -> Result(List(r4.Listfhir), Err) {
  let req = r4_sansio.listfhir_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.listfhir
  })
}

pub fn location_create(
  resource: r4.Location,
  client: FhirClient,
) -> Result(r4.Location, Err) {
  any_create(
    r4.location_to_json(resource),
    "Location",
    r4.location_decoder(),
    client,
  )
}

pub fn location_read(id: String, client: FhirClient) -> Result(r4.Location, Err) {
  any_read(id, client, "Location", r4.location_decoder())
}

pub fn location_update(
  resource: r4.Location,
  client: FhirClient,
) -> Result(r4.Location, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Location", client)
}

pub fn location_search_bundled(sp: r4_sansio.SpLocation, client: FhirClient) {
  let req = r4_sansio.location_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn location_search(
  sp: r4_sansio.SpLocation,
  client: FhirClient,
) -> Result(List(r4.Location), Err) {
  let req = r4_sansio.location_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.location
  })
}

pub fn measure_create(
  resource: r4.Measure,
  client: FhirClient,
) -> Result(r4.Measure, Err) {
  any_create(
    r4.measure_to_json(resource),
    "Measure",
    r4.measure_decoder(),
    client,
  )
}

pub fn measure_read(id: String, client: FhirClient) -> Result(r4.Measure, Err) {
  any_read(id, client, "Measure", r4.measure_decoder())
}

pub fn measure_update(
  resource: r4.Measure,
  client: FhirClient,
) -> Result(r4.Measure, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Measure", client)
}

pub fn measure_search_bundled(sp: r4_sansio.SpMeasure, client: FhirClient) {
  let req = r4_sansio.measure_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn measure_search(
  sp: r4_sansio.SpMeasure,
  client: FhirClient,
) -> Result(List(r4.Measure), Err) {
  let req = r4_sansio.measure_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.measure
  })
}

pub fn measurereport_create(
  resource: r4.Measurereport,
  client: FhirClient,
) -> Result(r4.Measurereport, Err) {
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
) -> Result(r4.Measurereport, Err) {
  any_read(id, client, "MeasureReport", r4.measurereport_decoder())
}

pub fn measurereport_update(
  resource: r4.Measurereport,
  client: FhirClient,
) -> Result(r4.Measurereport, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "MeasureReport", client)
}

pub fn measurereport_search_bundled(
  sp: r4_sansio.SpMeasurereport,
  client: FhirClient,
) {
  let req = r4_sansio.measurereport_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn measurereport_search(
  sp: r4_sansio.SpMeasurereport,
  client: FhirClient,
) -> Result(List(r4.Measurereport), Err) {
  let req = r4_sansio.measurereport_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.measurereport
  })
}

pub fn media_create(
  resource: r4.Media,
  client: FhirClient,
) -> Result(r4.Media, Err) {
  any_create(r4.media_to_json(resource), "Media", r4.media_decoder(), client)
}

pub fn media_read(id: String, client: FhirClient) -> Result(r4.Media, Err) {
  any_read(id, client, "Media", r4.media_decoder())
}

pub fn media_update(
  resource: r4.Media,
  client: FhirClient,
) -> Result(r4.Media, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Media", client)
}

pub fn media_search_bundled(sp: r4_sansio.SpMedia, client: FhirClient) {
  let req = r4_sansio.media_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn media_search(
  sp: r4_sansio.SpMedia,
  client: FhirClient,
) -> Result(List(r4.Media), Err) {
  let req = r4_sansio.media_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.media
  })
}

pub fn medication_create(
  resource: r4.Medication,
  client: FhirClient,
) -> Result(r4.Medication, Err) {
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
) -> Result(r4.Medication, Err) {
  any_read(id, client, "Medication", r4.medication_decoder())
}

pub fn medication_update(
  resource: r4.Medication,
  client: FhirClient,
) -> Result(r4.Medication, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Medication", client)
}

pub fn medication_search_bundled(sp: r4_sansio.SpMedication, client: FhirClient) {
  let req = r4_sansio.medication_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn medication_search(
  sp: r4_sansio.SpMedication,
  client: FhirClient,
) -> Result(List(r4.Medication), Err) {
  let req = r4_sansio.medication_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.medication
  })
}

pub fn medicationadministration_create(
  resource: r4.Medicationadministration,
  client: FhirClient,
) -> Result(r4.Medicationadministration, Err) {
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
) -> Result(r4.Medicationadministration, Err) {
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
) -> Result(r4.Medicationadministration, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "MedicationAdministration", client)
}

pub fn medicationadministration_search_bundled(
  sp: r4_sansio.SpMedicationadministration,
  client: FhirClient,
) {
  let req = r4_sansio.medicationadministration_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn medicationadministration_search(
  sp: r4_sansio.SpMedicationadministration,
  client: FhirClient,
) -> Result(List(r4.Medicationadministration), Err) {
  let req = r4_sansio.medicationadministration_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.medicationadministration
  })
}

pub fn medicationdispense_create(
  resource: r4.Medicationdispense,
  client: FhirClient,
) -> Result(r4.Medicationdispense, Err) {
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
) -> Result(r4.Medicationdispense, Err) {
  any_read(id, client, "MedicationDispense", r4.medicationdispense_decoder())
}

pub fn medicationdispense_update(
  resource: r4.Medicationdispense,
  client: FhirClient,
) -> Result(r4.Medicationdispense, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "MedicationDispense", client)
}

pub fn medicationdispense_search_bundled(
  sp: r4_sansio.SpMedicationdispense,
  client: FhirClient,
) {
  let req = r4_sansio.medicationdispense_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn medicationdispense_search(
  sp: r4_sansio.SpMedicationdispense,
  client: FhirClient,
) -> Result(List(r4.Medicationdispense), Err) {
  let req = r4_sansio.medicationdispense_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.medicationdispense
  })
}

pub fn medicationknowledge_create(
  resource: r4.Medicationknowledge,
  client: FhirClient,
) -> Result(r4.Medicationknowledge, Err) {
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
) -> Result(r4.Medicationknowledge, Err) {
  any_read(id, client, "MedicationKnowledge", r4.medicationknowledge_decoder())
}

pub fn medicationknowledge_update(
  resource: r4.Medicationknowledge,
  client: FhirClient,
) -> Result(r4.Medicationknowledge, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "MedicationKnowledge", client)
}

pub fn medicationknowledge_search_bundled(
  sp: r4_sansio.SpMedicationknowledge,
  client: FhirClient,
) {
  let req = r4_sansio.medicationknowledge_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn medicationknowledge_search(
  sp: r4_sansio.SpMedicationknowledge,
  client: FhirClient,
) -> Result(List(r4.Medicationknowledge), Err) {
  let req = r4_sansio.medicationknowledge_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.medicationknowledge
  })
}

pub fn medicationrequest_create(
  resource: r4.Medicationrequest,
  client: FhirClient,
) -> Result(r4.Medicationrequest, Err) {
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
) -> Result(r4.Medicationrequest, Err) {
  any_read(id, client, "MedicationRequest", r4.medicationrequest_decoder())
}

pub fn medicationrequest_update(
  resource: r4.Medicationrequest,
  client: FhirClient,
) -> Result(r4.Medicationrequest, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "MedicationRequest", client)
}

pub fn medicationrequest_search_bundled(
  sp: r4_sansio.SpMedicationrequest,
  client: FhirClient,
) {
  let req = r4_sansio.medicationrequest_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn medicationrequest_search(
  sp: r4_sansio.SpMedicationrequest,
  client: FhirClient,
) -> Result(List(r4.Medicationrequest), Err) {
  let req = r4_sansio.medicationrequest_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.medicationrequest
  })
}

pub fn medicationstatement_create(
  resource: r4.Medicationstatement,
  client: FhirClient,
) -> Result(r4.Medicationstatement, Err) {
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
) -> Result(r4.Medicationstatement, Err) {
  any_read(id, client, "MedicationStatement", r4.medicationstatement_decoder())
}

pub fn medicationstatement_update(
  resource: r4.Medicationstatement,
  client: FhirClient,
) -> Result(r4.Medicationstatement, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "MedicationStatement", client)
}

pub fn medicationstatement_search_bundled(
  sp: r4_sansio.SpMedicationstatement,
  client: FhirClient,
) {
  let req = r4_sansio.medicationstatement_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn medicationstatement_search(
  sp: r4_sansio.SpMedicationstatement,
  client: FhirClient,
) -> Result(List(r4.Medicationstatement), Err) {
  let req = r4_sansio.medicationstatement_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.medicationstatement
  })
}

pub fn medicinalproduct_create(
  resource: r4.Medicinalproduct,
  client: FhirClient,
) -> Result(r4.Medicinalproduct, Err) {
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
) -> Result(r4.Medicinalproduct, Err) {
  any_read(id, client, "MedicinalProduct", r4.medicinalproduct_decoder())
}

pub fn medicinalproduct_update(
  resource: r4.Medicinalproduct,
  client: FhirClient,
) -> Result(r4.Medicinalproduct, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "MedicinalProduct", client)
}

pub fn medicinalproduct_search_bundled(
  sp: r4_sansio.SpMedicinalproduct,
  client: FhirClient,
) {
  let req = r4_sansio.medicinalproduct_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn medicinalproduct_search(
  sp: r4_sansio.SpMedicinalproduct,
  client: FhirClient,
) -> Result(List(r4.Medicinalproduct), Err) {
  let req = r4_sansio.medicinalproduct_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.medicinalproduct
  })
}

pub fn medicinalproductauthorization_create(
  resource: r4.Medicinalproductauthorization,
  client: FhirClient,
) -> Result(r4.Medicinalproductauthorization, Err) {
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
) -> Result(r4.Medicinalproductauthorization, Err) {
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
) -> Result(r4.Medicinalproductauthorization, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "MedicinalProductAuthorization", client)
}

pub fn medicinalproductauthorization_search_bundled(
  sp: r4_sansio.SpMedicinalproductauthorization,
  client: FhirClient,
) {
  let req = r4_sansio.medicinalproductauthorization_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn medicinalproductauthorization_search(
  sp: r4_sansio.SpMedicinalproductauthorization,
  client: FhirClient,
) -> Result(List(r4.Medicinalproductauthorization), Err) {
  let req = r4_sansio.medicinalproductauthorization_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.medicinalproductauthorization
  })
}

pub fn medicinalproductcontraindication_create(
  resource: r4.Medicinalproductcontraindication,
  client: FhirClient,
) -> Result(r4.Medicinalproductcontraindication, Err) {
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
) -> Result(r4.Medicinalproductcontraindication, Err) {
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
) -> Result(r4.Medicinalproductcontraindication, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "MedicinalProductContraindication", client)
}

pub fn medicinalproductcontraindication_search_bundled(
  sp: r4_sansio.SpMedicinalproductcontraindication,
  client: FhirClient,
) {
  let req = r4_sansio.medicinalproductcontraindication_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn medicinalproductcontraindication_search(
  sp: r4_sansio.SpMedicinalproductcontraindication,
  client: FhirClient,
) -> Result(List(r4.Medicinalproductcontraindication), Err) {
  let req = r4_sansio.medicinalproductcontraindication_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.medicinalproductcontraindication
  })
}

pub fn medicinalproductindication_create(
  resource: r4.Medicinalproductindication,
  client: FhirClient,
) -> Result(r4.Medicinalproductindication, Err) {
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
) -> Result(r4.Medicinalproductindication, Err) {
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
) -> Result(r4.Medicinalproductindication, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "MedicinalProductIndication", client)
}

pub fn medicinalproductindication_search_bundled(
  sp: r4_sansio.SpMedicinalproductindication,
  client: FhirClient,
) {
  let req = r4_sansio.medicinalproductindication_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn medicinalproductindication_search(
  sp: r4_sansio.SpMedicinalproductindication,
  client: FhirClient,
) -> Result(List(r4.Medicinalproductindication), Err) {
  let req = r4_sansio.medicinalproductindication_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.medicinalproductindication
  })
}

pub fn medicinalproductingredient_create(
  resource: r4.Medicinalproductingredient,
  client: FhirClient,
) -> Result(r4.Medicinalproductingredient, Err) {
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
) -> Result(r4.Medicinalproductingredient, Err) {
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
) -> Result(r4.Medicinalproductingredient, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "MedicinalProductIngredient", client)
}

pub fn medicinalproductingredient_search_bundled(
  sp: r4_sansio.SpMedicinalproductingredient,
  client: FhirClient,
) {
  let req = r4_sansio.medicinalproductingredient_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn medicinalproductingredient_search(
  sp: r4_sansio.SpMedicinalproductingredient,
  client: FhirClient,
) -> Result(List(r4.Medicinalproductingredient), Err) {
  let req = r4_sansio.medicinalproductingredient_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.medicinalproductingredient
  })
}

pub fn medicinalproductinteraction_create(
  resource: r4.Medicinalproductinteraction,
  client: FhirClient,
) -> Result(r4.Medicinalproductinteraction, Err) {
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
) -> Result(r4.Medicinalproductinteraction, Err) {
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
) -> Result(r4.Medicinalproductinteraction, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "MedicinalProductInteraction", client)
}

pub fn medicinalproductinteraction_search_bundled(
  sp: r4_sansio.SpMedicinalproductinteraction,
  client: FhirClient,
) {
  let req = r4_sansio.medicinalproductinteraction_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn medicinalproductinteraction_search(
  sp: r4_sansio.SpMedicinalproductinteraction,
  client: FhirClient,
) -> Result(List(r4.Medicinalproductinteraction), Err) {
  let req = r4_sansio.medicinalproductinteraction_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.medicinalproductinteraction
  })
}

pub fn medicinalproductmanufactured_create(
  resource: r4.Medicinalproductmanufactured,
  client: FhirClient,
) -> Result(r4.Medicinalproductmanufactured, Err) {
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
) -> Result(r4.Medicinalproductmanufactured, Err) {
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
) -> Result(r4.Medicinalproductmanufactured, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "MedicinalProductManufactured", client)
}

pub fn medicinalproductmanufactured_search_bundled(
  sp: r4_sansio.SpMedicinalproductmanufactured,
  client: FhirClient,
) {
  let req = r4_sansio.medicinalproductmanufactured_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn medicinalproductmanufactured_search(
  sp: r4_sansio.SpMedicinalproductmanufactured,
  client: FhirClient,
) -> Result(List(r4.Medicinalproductmanufactured), Err) {
  let req = r4_sansio.medicinalproductmanufactured_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.medicinalproductmanufactured
  })
}

pub fn medicinalproductpackaged_create(
  resource: r4.Medicinalproductpackaged,
  client: FhirClient,
) -> Result(r4.Medicinalproductpackaged, Err) {
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
) -> Result(r4.Medicinalproductpackaged, Err) {
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
) -> Result(r4.Medicinalproductpackaged, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "MedicinalProductPackaged", client)
}

pub fn medicinalproductpackaged_search_bundled(
  sp: r4_sansio.SpMedicinalproductpackaged,
  client: FhirClient,
) {
  let req = r4_sansio.medicinalproductpackaged_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn medicinalproductpackaged_search(
  sp: r4_sansio.SpMedicinalproductpackaged,
  client: FhirClient,
) -> Result(List(r4.Medicinalproductpackaged), Err) {
  let req = r4_sansio.medicinalproductpackaged_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.medicinalproductpackaged
  })
}

pub fn medicinalproductpharmaceutical_create(
  resource: r4.Medicinalproductpharmaceutical,
  client: FhirClient,
) -> Result(r4.Medicinalproductpharmaceutical, Err) {
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
) -> Result(r4.Medicinalproductpharmaceutical, Err) {
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
) -> Result(r4.Medicinalproductpharmaceutical, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "MedicinalProductPharmaceutical", client)
}

pub fn medicinalproductpharmaceutical_search_bundled(
  sp: r4_sansio.SpMedicinalproductpharmaceutical,
  client: FhirClient,
) {
  let req = r4_sansio.medicinalproductpharmaceutical_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn medicinalproductpharmaceutical_search(
  sp: r4_sansio.SpMedicinalproductpharmaceutical,
  client: FhirClient,
) -> Result(List(r4.Medicinalproductpharmaceutical), Err) {
  let req = r4_sansio.medicinalproductpharmaceutical_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.medicinalproductpharmaceutical
  })
}

pub fn medicinalproductundesirableeffect_create(
  resource: r4.Medicinalproductundesirableeffect,
  client: FhirClient,
) -> Result(r4.Medicinalproductundesirableeffect, Err) {
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
) -> Result(r4.Medicinalproductundesirableeffect, Err) {
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
) -> Result(r4.Medicinalproductundesirableeffect, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "MedicinalProductUndesirableEffect", client)
}

pub fn medicinalproductundesirableeffect_search_bundled(
  sp: r4_sansio.SpMedicinalproductundesirableeffect,
  client: FhirClient,
) {
  let req = r4_sansio.medicinalproductundesirableeffect_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn medicinalproductundesirableeffect_search(
  sp: r4_sansio.SpMedicinalproductundesirableeffect,
  client: FhirClient,
) -> Result(List(r4.Medicinalproductundesirableeffect), Err) {
  let req = r4_sansio.medicinalproductundesirableeffect_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.medicinalproductundesirableeffect
  })
}

pub fn messagedefinition_create(
  resource: r4.Messagedefinition,
  client: FhirClient,
) -> Result(r4.Messagedefinition, Err) {
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
) -> Result(r4.Messagedefinition, Err) {
  any_read(id, client, "MessageDefinition", r4.messagedefinition_decoder())
}

pub fn messagedefinition_update(
  resource: r4.Messagedefinition,
  client: FhirClient,
) -> Result(r4.Messagedefinition, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "MessageDefinition", client)
}

pub fn messagedefinition_search_bundled(
  sp: r4_sansio.SpMessagedefinition,
  client: FhirClient,
) {
  let req = r4_sansio.messagedefinition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn messagedefinition_search(
  sp: r4_sansio.SpMessagedefinition,
  client: FhirClient,
) -> Result(List(r4.Messagedefinition), Err) {
  let req = r4_sansio.messagedefinition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.messagedefinition
  })
}

pub fn messageheader_create(
  resource: r4.Messageheader,
  client: FhirClient,
) -> Result(r4.Messageheader, Err) {
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
) -> Result(r4.Messageheader, Err) {
  any_read(id, client, "MessageHeader", r4.messageheader_decoder())
}

pub fn messageheader_update(
  resource: r4.Messageheader,
  client: FhirClient,
) -> Result(r4.Messageheader, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "MessageHeader", client)
}

pub fn messageheader_search_bundled(
  sp: r4_sansio.SpMessageheader,
  client: FhirClient,
) {
  let req = r4_sansio.messageheader_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn messageheader_search(
  sp: r4_sansio.SpMessageheader,
  client: FhirClient,
) -> Result(List(r4.Messageheader), Err) {
  let req = r4_sansio.messageheader_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.messageheader
  })
}

pub fn molecularsequence_create(
  resource: r4.Molecularsequence,
  client: FhirClient,
) -> Result(r4.Molecularsequence, Err) {
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
) -> Result(r4.Molecularsequence, Err) {
  any_read(id, client, "MolecularSequence", r4.molecularsequence_decoder())
}

pub fn molecularsequence_update(
  resource: r4.Molecularsequence,
  client: FhirClient,
) -> Result(r4.Molecularsequence, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "MolecularSequence", client)
}

pub fn molecularsequence_search_bundled(
  sp: r4_sansio.SpMolecularsequence,
  client: FhirClient,
) {
  let req = r4_sansio.molecularsequence_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn molecularsequence_search(
  sp: r4_sansio.SpMolecularsequence,
  client: FhirClient,
) -> Result(List(r4.Molecularsequence), Err) {
  let req = r4_sansio.molecularsequence_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.molecularsequence
  })
}

pub fn namingsystem_create(
  resource: r4.Namingsystem,
  client: FhirClient,
) -> Result(r4.Namingsystem, Err) {
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
) -> Result(r4.Namingsystem, Err) {
  any_read(id, client, "NamingSystem", r4.namingsystem_decoder())
}

pub fn namingsystem_update(
  resource: r4.Namingsystem,
  client: FhirClient,
) -> Result(r4.Namingsystem, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "NamingSystem", client)
}

pub fn namingsystem_search_bundled(
  sp: r4_sansio.SpNamingsystem,
  client: FhirClient,
) {
  let req = r4_sansio.namingsystem_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn namingsystem_search(
  sp: r4_sansio.SpNamingsystem,
  client: FhirClient,
) -> Result(List(r4.Namingsystem), Err) {
  let req = r4_sansio.namingsystem_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.namingsystem
  })
}

pub fn nutritionorder_create(
  resource: r4.Nutritionorder,
  client: FhirClient,
) -> Result(r4.Nutritionorder, Err) {
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
) -> Result(r4.Nutritionorder, Err) {
  any_read(id, client, "NutritionOrder", r4.nutritionorder_decoder())
}

pub fn nutritionorder_update(
  resource: r4.Nutritionorder,
  client: FhirClient,
) -> Result(r4.Nutritionorder, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "NutritionOrder", client)
}

pub fn nutritionorder_search_bundled(
  sp: r4_sansio.SpNutritionorder,
  client: FhirClient,
) {
  let req = r4_sansio.nutritionorder_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn nutritionorder_search(
  sp: r4_sansio.SpNutritionorder,
  client: FhirClient,
) -> Result(List(r4.Nutritionorder), Err) {
  let req = r4_sansio.nutritionorder_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.nutritionorder
  })
}

pub fn observation_create(
  resource: r4.Observation,
  client: FhirClient,
) -> Result(r4.Observation, Err) {
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
) -> Result(r4.Observation, Err) {
  any_read(id, client, "Observation", r4.observation_decoder())
}

pub fn observation_update(
  resource: r4.Observation,
  client: FhirClient,
) -> Result(r4.Observation, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Observation", client)
}

pub fn observation_search_bundled(
  sp: r4_sansio.SpObservation,
  client: FhirClient,
) {
  let req = r4_sansio.observation_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn observation_search(
  sp: r4_sansio.SpObservation,
  client: FhirClient,
) -> Result(List(r4.Observation), Err) {
  let req = r4_sansio.observation_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.observation
  })
}

pub fn observationdefinition_create(
  resource: r4.Observationdefinition,
  client: FhirClient,
) -> Result(r4.Observationdefinition, Err) {
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
) -> Result(r4.Observationdefinition, Err) {
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
) -> Result(r4.Observationdefinition, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "ObservationDefinition", client)
}

pub fn observationdefinition_search_bundled(
  sp: r4_sansio.SpObservationdefinition,
  client: FhirClient,
) {
  let req = r4_sansio.observationdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn observationdefinition_search(
  sp: r4_sansio.SpObservationdefinition,
  client: FhirClient,
) -> Result(List(r4.Observationdefinition), Err) {
  let req = r4_sansio.observationdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.observationdefinition
  })
}

pub fn operationdefinition_create(
  resource: r4.Operationdefinition,
  client: FhirClient,
) -> Result(r4.Operationdefinition, Err) {
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
) -> Result(r4.Operationdefinition, Err) {
  any_read(id, client, "OperationDefinition", r4.operationdefinition_decoder())
}

pub fn operationdefinition_update(
  resource: r4.Operationdefinition,
  client: FhirClient,
) -> Result(r4.Operationdefinition, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "OperationDefinition", client)
}

pub fn operationdefinition_search_bundled(
  sp: r4_sansio.SpOperationdefinition,
  client: FhirClient,
) {
  let req = r4_sansio.operationdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn operationdefinition_search(
  sp: r4_sansio.SpOperationdefinition,
  client: FhirClient,
) -> Result(List(r4.Operationdefinition), Err) {
  let req = r4_sansio.operationdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.operationdefinition
  })
}

pub fn operationoutcome_create(
  resource: r4.Operationoutcome,
  client: FhirClient,
) -> Result(r4.Operationoutcome, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_read(id, client, "OperationOutcome", r4.operationoutcome_decoder())
}

pub fn operationoutcome_update(
  resource: r4.Operationoutcome,
  client: FhirClient,
) -> Result(r4.Operationoutcome, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "OperationOutcome", client)
}

pub fn operationoutcome_search_bundled(
  sp: r4_sansio.SpOperationoutcome,
  client: FhirClient,
) {
  let req = r4_sansio.operationoutcome_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn operationoutcome_search(
  sp: r4_sansio.SpOperationoutcome,
  client: FhirClient,
) -> Result(List(r4.Operationoutcome), Err) {
  let req = r4_sansio.operationoutcome_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.operationoutcome
  })
}

pub fn organization_create(
  resource: r4.Organization,
  client: FhirClient,
) -> Result(r4.Organization, Err) {
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
) -> Result(r4.Organization, Err) {
  any_read(id, client, "Organization", r4.organization_decoder())
}

pub fn organization_update(
  resource: r4.Organization,
  client: FhirClient,
) -> Result(r4.Organization, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Organization", client)
}

pub fn organization_search_bundled(
  sp: r4_sansio.SpOrganization,
  client: FhirClient,
) {
  let req = r4_sansio.organization_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn organization_search(
  sp: r4_sansio.SpOrganization,
  client: FhirClient,
) -> Result(List(r4.Organization), Err) {
  let req = r4_sansio.organization_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.organization
  })
}

pub fn organizationaffiliation_create(
  resource: r4.Organizationaffiliation,
  client: FhirClient,
) -> Result(r4.Organizationaffiliation, Err) {
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
) -> Result(r4.Organizationaffiliation, Err) {
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
) -> Result(r4.Organizationaffiliation, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "OrganizationAffiliation", client)
}

pub fn organizationaffiliation_search_bundled(
  sp: r4_sansio.SpOrganizationaffiliation,
  client: FhirClient,
) {
  let req = r4_sansio.organizationaffiliation_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn organizationaffiliation_search(
  sp: r4_sansio.SpOrganizationaffiliation,
  client: FhirClient,
) -> Result(List(r4.Organizationaffiliation), Err) {
  let req = r4_sansio.organizationaffiliation_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.organizationaffiliation
  })
}

pub fn patient_create(
  resource: r4.Patient,
  client: FhirClient,
) -> Result(r4.Patient, Err) {
  any_create(
    r4.patient_to_json(resource),
    "Patient",
    r4.patient_decoder(),
    client,
  )
}

pub fn patient_read(id: String, client: FhirClient) -> Result(r4.Patient, Err) {
  any_read(id, client, "Patient", r4.patient_decoder())
}

pub fn patient_update(
  resource: r4.Patient,
  client: FhirClient,
) -> Result(r4.Patient, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Patient", client)
}

pub fn patient_search_bundled(sp: r4_sansio.SpPatient, client: FhirClient) {
  let req = r4_sansio.patient_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn patient_search(
  sp: r4_sansio.SpPatient,
  client: FhirClient,
) -> Result(List(r4.Patient), Err) {
  let req = r4_sansio.patient_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.patient
  })
}

pub fn paymentnotice_create(
  resource: r4.Paymentnotice,
  client: FhirClient,
) -> Result(r4.Paymentnotice, Err) {
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
) -> Result(r4.Paymentnotice, Err) {
  any_read(id, client, "PaymentNotice", r4.paymentnotice_decoder())
}

pub fn paymentnotice_update(
  resource: r4.Paymentnotice,
  client: FhirClient,
) -> Result(r4.Paymentnotice, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "PaymentNotice", client)
}

pub fn paymentnotice_search_bundled(
  sp: r4_sansio.SpPaymentnotice,
  client: FhirClient,
) {
  let req = r4_sansio.paymentnotice_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn paymentnotice_search(
  sp: r4_sansio.SpPaymentnotice,
  client: FhirClient,
) -> Result(List(r4.Paymentnotice), Err) {
  let req = r4_sansio.paymentnotice_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.paymentnotice
  })
}

pub fn paymentreconciliation_create(
  resource: r4.Paymentreconciliation,
  client: FhirClient,
) -> Result(r4.Paymentreconciliation, Err) {
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
) -> Result(r4.Paymentreconciliation, Err) {
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
) -> Result(r4.Paymentreconciliation, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "PaymentReconciliation", client)
}

pub fn paymentreconciliation_search_bundled(
  sp: r4_sansio.SpPaymentreconciliation,
  client: FhirClient,
) {
  let req = r4_sansio.paymentreconciliation_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn paymentreconciliation_search(
  sp: r4_sansio.SpPaymentreconciliation,
  client: FhirClient,
) -> Result(List(r4.Paymentreconciliation), Err) {
  let req = r4_sansio.paymentreconciliation_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.paymentreconciliation
  })
}

pub fn person_create(
  resource: r4.Person,
  client: FhirClient,
) -> Result(r4.Person, Err) {
  any_create(r4.person_to_json(resource), "Person", r4.person_decoder(), client)
}

pub fn person_read(id: String, client: FhirClient) -> Result(r4.Person, Err) {
  any_read(id, client, "Person", r4.person_decoder())
}

pub fn person_update(
  resource: r4.Person,
  client: FhirClient,
) -> Result(r4.Person, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Person", client)
}

pub fn person_search_bundled(sp: r4_sansio.SpPerson, client: FhirClient) {
  let req = r4_sansio.person_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn person_search(
  sp: r4_sansio.SpPerson,
  client: FhirClient,
) -> Result(List(r4.Person), Err) {
  let req = r4_sansio.person_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.person
  })
}

pub fn plandefinition_create(
  resource: r4.Plandefinition,
  client: FhirClient,
) -> Result(r4.Plandefinition, Err) {
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
) -> Result(r4.Plandefinition, Err) {
  any_read(id, client, "PlanDefinition", r4.plandefinition_decoder())
}

pub fn plandefinition_update(
  resource: r4.Plandefinition,
  client: FhirClient,
) -> Result(r4.Plandefinition, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "PlanDefinition", client)
}

pub fn plandefinition_search_bundled(
  sp: r4_sansio.SpPlandefinition,
  client: FhirClient,
) {
  let req = r4_sansio.plandefinition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn plandefinition_search(
  sp: r4_sansio.SpPlandefinition,
  client: FhirClient,
) -> Result(List(r4.Plandefinition), Err) {
  let req = r4_sansio.plandefinition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.plandefinition
  })
}

pub fn practitioner_create(
  resource: r4.Practitioner,
  client: FhirClient,
) -> Result(r4.Practitioner, Err) {
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
) -> Result(r4.Practitioner, Err) {
  any_read(id, client, "Practitioner", r4.practitioner_decoder())
}

pub fn practitioner_update(
  resource: r4.Practitioner,
  client: FhirClient,
) -> Result(r4.Practitioner, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Practitioner", client)
}

pub fn practitioner_search_bundled(
  sp: r4_sansio.SpPractitioner,
  client: FhirClient,
) {
  let req = r4_sansio.practitioner_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn practitioner_search(
  sp: r4_sansio.SpPractitioner,
  client: FhirClient,
) -> Result(List(r4.Practitioner), Err) {
  let req = r4_sansio.practitioner_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.practitioner
  })
}

pub fn practitionerrole_create(
  resource: r4.Practitionerrole,
  client: FhirClient,
) -> Result(r4.Practitionerrole, Err) {
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
) -> Result(r4.Practitionerrole, Err) {
  any_read(id, client, "PractitionerRole", r4.practitionerrole_decoder())
}

pub fn practitionerrole_update(
  resource: r4.Practitionerrole,
  client: FhirClient,
) -> Result(r4.Practitionerrole, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "PractitionerRole", client)
}

pub fn practitionerrole_search_bundled(
  sp: r4_sansio.SpPractitionerrole,
  client: FhirClient,
) {
  let req = r4_sansio.practitionerrole_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn practitionerrole_search(
  sp: r4_sansio.SpPractitionerrole,
  client: FhirClient,
) -> Result(List(r4.Practitionerrole), Err) {
  let req = r4_sansio.practitionerrole_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.practitionerrole
  })
}

pub fn procedure_create(
  resource: r4.Procedure,
  client: FhirClient,
) -> Result(r4.Procedure, Err) {
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
) -> Result(r4.Procedure, Err) {
  any_read(id, client, "Procedure", r4.procedure_decoder())
}

pub fn procedure_update(
  resource: r4.Procedure,
  client: FhirClient,
) -> Result(r4.Procedure, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Procedure", client)
}

pub fn procedure_search_bundled(sp: r4_sansio.SpProcedure, client: FhirClient) {
  let req = r4_sansio.procedure_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn procedure_search(
  sp: r4_sansio.SpProcedure,
  client: FhirClient,
) -> Result(List(r4.Procedure), Err) {
  let req = r4_sansio.procedure_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.procedure
  })
}

pub fn provenance_create(
  resource: r4.Provenance,
  client: FhirClient,
) -> Result(r4.Provenance, Err) {
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
) -> Result(r4.Provenance, Err) {
  any_read(id, client, "Provenance", r4.provenance_decoder())
}

pub fn provenance_update(
  resource: r4.Provenance,
  client: FhirClient,
) -> Result(r4.Provenance, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Provenance", client)
}

pub fn provenance_search_bundled(sp: r4_sansio.SpProvenance, client: FhirClient) {
  let req = r4_sansio.provenance_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn provenance_search(
  sp: r4_sansio.SpProvenance,
  client: FhirClient,
) -> Result(List(r4.Provenance), Err) {
  let req = r4_sansio.provenance_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.provenance
  })
}

pub fn questionnaire_create(
  resource: r4.Questionnaire,
  client: FhirClient,
) -> Result(r4.Questionnaire, Err) {
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
) -> Result(r4.Questionnaire, Err) {
  any_read(id, client, "Questionnaire", r4.questionnaire_decoder())
}

pub fn questionnaire_update(
  resource: r4.Questionnaire,
  client: FhirClient,
) -> Result(r4.Questionnaire, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Questionnaire", client)
}

pub fn questionnaire_search_bundled(
  sp: r4_sansio.SpQuestionnaire,
  client: FhirClient,
) {
  let req = r4_sansio.questionnaire_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn questionnaire_search(
  sp: r4_sansio.SpQuestionnaire,
  client: FhirClient,
) -> Result(List(r4.Questionnaire), Err) {
  let req = r4_sansio.questionnaire_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.questionnaire
  })
}

pub fn questionnaireresponse_create(
  resource: r4.Questionnaireresponse,
  client: FhirClient,
) -> Result(r4.Questionnaireresponse, Err) {
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
) -> Result(r4.Questionnaireresponse, Err) {
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
) -> Result(r4.Questionnaireresponse, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "QuestionnaireResponse", client)
}

pub fn questionnaireresponse_search_bundled(
  sp: r4_sansio.SpQuestionnaireresponse,
  client: FhirClient,
) {
  let req = r4_sansio.questionnaireresponse_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn questionnaireresponse_search(
  sp: r4_sansio.SpQuestionnaireresponse,
  client: FhirClient,
) -> Result(List(r4.Questionnaireresponse), Err) {
  let req = r4_sansio.questionnaireresponse_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.questionnaireresponse
  })
}

pub fn relatedperson_create(
  resource: r4.Relatedperson,
  client: FhirClient,
) -> Result(r4.Relatedperson, Err) {
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
) -> Result(r4.Relatedperson, Err) {
  any_read(id, client, "RelatedPerson", r4.relatedperson_decoder())
}

pub fn relatedperson_update(
  resource: r4.Relatedperson,
  client: FhirClient,
) -> Result(r4.Relatedperson, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "RelatedPerson", client)
}

pub fn relatedperson_search_bundled(
  sp: r4_sansio.SpRelatedperson,
  client: FhirClient,
) {
  let req = r4_sansio.relatedperson_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn relatedperson_search(
  sp: r4_sansio.SpRelatedperson,
  client: FhirClient,
) -> Result(List(r4.Relatedperson), Err) {
  let req = r4_sansio.relatedperson_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.relatedperson
  })
}

pub fn requestgroup_create(
  resource: r4.Requestgroup,
  client: FhirClient,
) -> Result(r4.Requestgroup, Err) {
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
) -> Result(r4.Requestgroup, Err) {
  any_read(id, client, "RequestGroup", r4.requestgroup_decoder())
}

pub fn requestgroup_update(
  resource: r4.Requestgroup,
  client: FhirClient,
) -> Result(r4.Requestgroup, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "RequestGroup", client)
}

pub fn requestgroup_search_bundled(
  sp: r4_sansio.SpRequestgroup,
  client: FhirClient,
) {
  let req = r4_sansio.requestgroup_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn requestgroup_search(
  sp: r4_sansio.SpRequestgroup,
  client: FhirClient,
) -> Result(List(r4.Requestgroup), Err) {
  let req = r4_sansio.requestgroup_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.requestgroup
  })
}

pub fn researchdefinition_create(
  resource: r4.Researchdefinition,
  client: FhirClient,
) -> Result(r4.Researchdefinition, Err) {
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
) -> Result(r4.Researchdefinition, Err) {
  any_read(id, client, "ResearchDefinition", r4.researchdefinition_decoder())
}

pub fn researchdefinition_update(
  resource: r4.Researchdefinition,
  client: FhirClient,
) -> Result(r4.Researchdefinition, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "ResearchDefinition", client)
}

pub fn researchdefinition_search_bundled(
  sp: r4_sansio.SpResearchdefinition,
  client: FhirClient,
) {
  let req = r4_sansio.researchdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn researchdefinition_search(
  sp: r4_sansio.SpResearchdefinition,
  client: FhirClient,
) -> Result(List(r4.Researchdefinition), Err) {
  let req = r4_sansio.researchdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.researchdefinition
  })
}

pub fn researchelementdefinition_create(
  resource: r4.Researchelementdefinition,
  client: FhirClient,
) -> Result(r4.Researchelementdefinition, Err) {
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
) -> Result(r4.Researchelementdefinition, Err) {
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
) -> Result(r4.Researchelementdefinition, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "ResearchElementDefinition", client)
}

pub fn researchelementdefinition_search_bundled(
  sp: r4_sansio.SpResearchelementdefinition,
  client: FhirClient,
) {
  let req = r4_sansio.researchelementdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn researchelementdefinition_search(
  sp: r4_sansio.SpResearchelementdefinition,
  client: FhirClient,
) -> Result(List(r4.Researchelementdefinition), Err) {
  let req = r4_sansio.researchelementdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.researchelementdefinition
  })
}

pub fn researchstudy_create(
  resource: r4.Researchstudy,
  client: FhirClient,
) -> Result(r4.Researchstudy, Err) {
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
) -> Result(r4.Researchstudy, Err) {
  any_read(id, client, "ResearchStudy", r4.researchstudy_decoder())
}

pub fn researchstudy_update(
  resource: r4.Researchstudy,
  client: FhirClient,
) -> Result(r4.Researchstudy, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "ResearchStudy", client)
}

pub fn researchstudy_search_bundled(
  sp: r4_sansio.SpResearchstudy,
  client: FhirClient,
) {
  let req = r4_sansio.researchstudy_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn researchstudy_search(
  sp: r4_sansio.SpResearchstudy,
  client: FhirClient,
) -> Result(List(r4.Researchstudy), Err) {
  let req = r4_sansio.researchstudy_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.researchstudy
  })
}

pub fn researchsubject_create(
  resource: r4.Researchsubject,
  client: FhirClient,
) -> Result(r4.Researchsubject, Err) {
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
) -> Result(r4.Researchsubject, Err) {
  any_read(id, client, "ResearchSubject", r4.researchsubject_decoder())
}

pub fn researchsubject_update(
  resource: r4.Researchsubject,
  client: FhirClient,
) -> Result(r4.Researchsubject, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "ResearchSubject", client)
}

pub fn researchsubject_search_bundled(
  sp: r4_sansio.SpResearchsubject,
  client: FhirClient,
) {
  let req = r4_sansio.researchsubject_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn researchsubject_search(
  sp: r4_sansio.SpResearchsubject,
  client: FhirClient,
) -> Result(List(r4.Researchsubject), Err) {
  let req = r4_sansio.researchsubject_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.researchsubject
  })
}

pub fn riskassessment_create(
  resource: r4.Riskassessment,
  client: FhirClient,
) -> Result(r4.Riskassessment, Err) {
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
) -> Result(r4.Riskassessment, Err) {
  any_read(id, client, "RiskAssessment", r4.riskassessment_decoder())
}

pub fn riskassessment_update(
  resource: r4.Riskassessment,
  client: FhirClient,
) -> Result(r4.Riskassessment, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "RiskAssessment", client)
}

pub fn riskassessment_search_bundled(
  sp: r4_sansio.SpRiskassessment,
  client: FhirClient,
) {
  let req = r4_sansio.riskassessment_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn riskassessment_search(
  sp: r4_sansio.SpRiskassessment,
  client: FhirClient,
) -> Result(List(r4.Riskassessment), Err) {
  let req = r4_sansio.riskassessment_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.riskassessment
  })
}

pub fn riskevidencesynthesis_create(
  resource: r4.Riskevidencesynthesis,
  client: FhirClient,
) -> Result(r4.Riskevidencesynthesis, Err) {
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
) -> Result(r4.Riskevidencesynthesis, Err) {
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
) -> Result(r4.Riskevidencesynthesis, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "RiskEvidenceSynthesis", client)
}

pub fn riskevidencesynthesis_search_bundled(
  sp: r4_sansio.SpRiskevidencesynthesis,
  client: FhirClient,
) {
  let req = r4_sansio.riskevidencesynthesis_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn riskevidencesynthesis_search(
  sp: r4_sansio.SpRiskevidencesynthesis,
  client: FhirClient,
) -> Result(List(r4.Riskevidencesynthesis), Err) {
  let req = r4_sansio.riskevidencesynthesis_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.riskevidencesynthesis
  })
}

pub fn schedule_create(
  resource: r4.Schedule,
  client: FhirClient,
) -> Result(r4.Schedule, Err) {
  any_create(
    r4.schedule_to_json(resource),
    "Schedule",
    r4.schedule_decoder(),
    client,
  )
}

pub fn schedule_read(id: String, client: FhirClient) -> Result(r4.Schedule, Err) {
  any_read(id, client, "Schedule", r4.schedule_decoder())
}

pub fn schedule_update(
  resource: r4.Schedule,
  client: FhirClient,
) -> Result(r4.Schedule, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Schedule", client)
}

pub fn schedule_search_bundled(sp: r4_sansio.SpSchedule, client: FhirClient) {
  let req = r4_sansio.schedule_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn schedule_search(
  sp: r4_sansio.SpSchedule,
  client: FhirClient,
) -> Result(List(r4.Schedule), Err) {
  let req = r4_sansio.schedule_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.schedule
  })
}

pub fn searchparameter_create(
  resource: r4.Searchparameter,
  client: FhirClient,
) -> Result(r4.Searchparameter, Err) {
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
) -> Result(r4.Searchparameter, Err) {
  any_read(id, client, "SearchParameter", r4.searchparameter_decoder())
}

pub fn searchparameter_update(
  resource: r4.Searchparameter,
  client: FhirClient,
) -> Result(r4.Searchparameter, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "SearchParameter", client)
}

pub fn searchparameter_search_bundled(
  sp: r4_sansio.SpSearchparameter,
  client: FhirClient,
) {
  let req = r4_sansio.searchparameter_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn searchparameter_search(
  sp: r4_sansio.SpSearchparameter,
  client: FhirClient,
) -> Result(List(r4.Searchparameter), Err) {
  let req = r4_sansio.searchparameter_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.searchparameter
  })
}

pub fn servicerequest_create(
  resource: r4.Servicerequest,
  client: FhirClient,
) -> Result(r4.Servicerequest, Err) {
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
) -> Result(r4.Servicerequest, Err) {
  any_read(id, client, "ServiceRequest", r4.servicerequest_decoder())
}

pub fn servicerequest_update(
  resource: r4.Servicerequest,
  client: FhirClient,
) -> Result(r4.Servicerequest, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "ServiceRequest", client)
}

pub fn servicerequest_search_bundled(
  sp: r4_sansio.SpServicerequest,
  client: FhirClient,
) {
  let req = r4_sansio.servicerequest_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn servicerequest_search(
  sp: r4_sansio.SpServicerequest,
  client: FhirClient,
) -> Result(List(r4.Servicerequest), Err) {
  let req = r4_sansio.servicerequest_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.servicerequest
  })
}

pub fn slot_create(
  resource: r4.Slot,
  client: FhirClient,
) -> Result(r4.Slot, Err) {
  any_create(r4.slot_to_json(resource), "Slot", r4.slot_decoder(), client)
}

pub fn slot_read(id: String, client: FhirClient) -> Result(r4.Slot, Err) {
  any_read(id, client, "Slot", r4.slot_decoder())
}

pub fn slot_update(
  resource: r4.Slot,
  client: FhirClient,
) -> Result(r4.Slot, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Slot", client)
}

pub fn slot_search_bundled(sp: r4_sansio.SpSlot, client: FhirClient) {
  let req = r4_sansio.slot_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn slot_search(
  sp: r4_sansio.SpSlot,
  client: FhirClient,
) -> Result(List(r4.Slot), Err) {
  let req = r4_sansio.slot_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.slot
  })
}

pub fn specimen_create(
  resource: r4.Specimen,
  client: FhirClient,
) -> Result(r4.Specimen, Err) {
  any_create(
    r4.specimen_to_json(resource),
    "Specimen",
    r4.specimen_decoder(),
    client,
  )
}

pub fn specimen_read(id: String, client: FhirClient) -> Result(r4.Specimen, Err) {
  any_read(id, client, "Specimen", r4.specimen_decoder())
}

pub fn specimen_update(
  resource: r4.Specimen,
  client: FhirClient,
) -> Result(r4.Specimen, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Specimen", client)
}

pub fn specimen_search_bundled(sp: r4_sansio.SpSpecimen, client: FhirClient) {
  let req = r4_sansio.specimen_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn specimen_search(
  sp: r4_sansio.SpSpecimen,
  client: FhirClient,
) -> Result(List(r4.Specimen), Err) {
  let req = r4_sansio.specimen_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.specimen
  })
}

pub fn specimendefinition_create(
  resource: r4.Specimendefinition,
  client: FhirClient,
) -> Result(r4.Specimendefinition, Err) {
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
) -> Result(r4.Specimendefinition, Err) {
  any_read(id, client, "SpecimenDefinition", r4.specimendefinition_decoder())
}

pub fn specimendefinition_update(
  resource: r4.Specimendefinition,
  client: FhirClient,
) -> Result(r4.Specimendefinition, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "SpecimenDefinition", client)
}

pub fn specimendefinition_search_bundled(
  sp: r4_sansio.SpSpecimendefinition,
  client: FhirClient,
) {
  let req = r4_sansio.specimendefinition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn specimendefinition_search(
  sp: r4_sansio.SpSpecimendefinition,
  client: FhirClient,
) -> Result(List(r4.Specimendefinition), Err) {
  let req = r4_sansio.specimendefinition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.specimendefinition
  })
}

pub fn structuredefinition_create(
  resource: r4.Structuredefinition,
  client: FhirClient,
) -> Result(r4.Structuredefinition, Err) {
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
) -> Result(r4.Structuredefinition, Err) {
  any_read(id, client, "StructureDefinition", r4.structuredefinition_decoder())
}

pub fn structuredefinition_update(
  resource: r4.Structuredefinition,
  client: FhirClient,
) -> Result(r4.Structuredefinition, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "StructureDefinition", client)
}

pub fn structuredefinition_search_bundled(
  sp: r4_sansio.SpStructuredefinition,
  client: FhirClient,
) {
  let req = r4_sansio.structuredefinition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn structuredefinition_search(
  sp: r4_sansio.SpStructuredefinition,
  client: FhirClient,
) -> Result(List(r4.Structuredefinition), Err) {
  let req = r4_sansio.structuredefinition_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.structuredefinition
  })
}

pub fn structuremap_create(
  resource: r4.Structuremap,
  client: FhirClient,
) -> Result(r4.Structuremap, Err) {
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
) -> Result(r4.Structuremap, Err) {
  any_read(id, client, "StructureMap", r4.structuremap_decoder())
}

pub fn structuremap_update(
  resource: r4.Structuremap,
  client: FhirClient,
) -> Result(r4.Structuremap, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "StructureMap", client)
}

pub fn structuremap_search_bundled(
  sp: r4_sansio.SpStructuremap,
  client: FhirClient,
) {
  let req = r4_sansio.structuremap_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn structuremap_search(
  sp: r4_sansio.SpStructuremap,
  client: FhirClient,
) -> Result(List(r4.Structuremap), Err) {
  let req = r4_sansio.structuremap_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.structuremap
  })
}

pub fn subscription_create(
  resource: r4.Subscription,
  client: FhirClient,
) -> Result(r4.Subscription, Err) {
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
) -> Result(r4.Subscription, Err) {
  any_read(id, client, "Subscription", r4.subscription_decoder())
}

pub fn subscription_update(
  resource: r4.Subscription,
  client: FhirClient,
) -> Result(r4.Subscription, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Subscription", client)
}

pub fn subscription_search_bundled(
  sp: r4_sansio.SpSubscription,
  client: FhirClient,
) {
  let req = r4_sansio.subscription_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn subscription_search(
  sp: r4_sansio.SpSubscription,
  client: FhirClient,
) -> Result(List(r4.Subscription), Err) {
  let req = r4_sansio.subscription_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.subscription
  })
}

pub fn substance_create(
  resource: r4.Substance,
  client: FhirClient,
) -> Result(r4.Substance, Err) {
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
) -> Result(r4.Substance, Err) {
  any_read(id, client, "Substance", r4.substance_decoder())
}

pub fn substance_update(
  resource: r4.Substance,
  client: FhirClient,
) -> Result(r4.Substance, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Substance", client)
}

pub fn substance_search_bundled(sp: r4_sansio.SpSubstance, client: FhirClient) {
  let req = r4_sansio.substance_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn substance_search(
  sp: r4_sansio.SpSubstance,
  client: FhirClient,
) -> Result(List(r4.Substance), Err) {
  let req = r4_sansio.substance_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.substance
  })
}

pub fn substancenucleicacid_create(
  resource: r4.Substancenucleicacid,
  client: FhirClient,
) -> Result(r4.Substancenucleicacid, Err) {
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
) -> Result(r4.Substancenucleicacid, Err) {
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
) -> Result(r4.Substancenucleicacid, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "SubstanceNucleicAcid", client)
}

pub fn substancenucleicacid_search_bundled(
  sp: r4_sansio.SpSubstancenucleicacid,
  client: FhirClient,
) {
  let req = r4_sansio.substancenucleicacid_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn substancenucleicacid_search(
  sp: r4_sansio.SpSubstancenucleicacid,
  client: FhirClient,
) -> Result(List(r4.Substancenucleicacid), Err) {
  let req = r4_sansio.substancenucleicacid_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.substancenucleicacid
  })
}

pub fn substancepolymer_create(
  resource: r4.Substancepolymer,
  client: FhirClient,
) -> Result(r4.Substancepolymer, Err) {
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
) -> Result(r4.Substancepolymer, Err) {
  any_read(id, client, "SubstancePolymer", r4.substancepolymer_decoder())
}

pub fn substancepolymer_update(
  resource: r4.Substancepolymer,
  client: FhirClient,
) -> Result(r4.Substancepolymer, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "SubstancePolymer", client)
}

pub fn substancepolymer_search_bundled(
  sp: r4_sansio.SpSubstancepolymer,
  client: FhirClient,
) {
  let req = r4_sansio.substancepolymer_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn substancepolymer_search(
  sp: r4_sansio.SpSubstancepolymer,
  client: FhirClient,
) -> Result(List(r4.Substancepolymer), Err) {
  let req = r4_sansio.substancepolymer_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.substancepolymer
  })
}

pub fn substanceprotein_create(
  resource: r4.Substanceprotein,
  client: FhirClient,
) -> Result(r4.Substanceprotein, Err) {
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
) -> Result(r4.Substanceprotein, Err) {
  any_read(id, client, "SubstanceProtein", r4.substanceprotein_decoder())
}

pub fn substanceprotein_update(
  resource: r4.Substanceprotein,
  client: FhirClient,
) -> Result(r4.Substanceprotein, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "SubstanceProtein", client)
}

pub fn substanceprotein_search_bundled(
  sp: r4_sansio.SpSubstanceprotein,
  client: FhirClient,
) {
  let req = r4_sansio.substanceprotein_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn substanceprotein_search(
  sp: r4_sansio.SpSubstanceprotein,
  client: FhirClient,
) -> Result(List(r4.Substanceprotein), Err) {
  let req = r4_sansio.substanceprotein_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.substanceprotein
  })
}

pub fn substancereferenceinformation_create(
  resource: r4.Substancereferenceinformation,
  client: FhirClient,
) -> Result(r4.Substancereferenceinformation, Err) {
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
) -> Result(r4.Substancereferenceinformation, Err) {
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
) -> Result(r4.Substancereferenceinformation, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "SubstanceReferenceInformation", client)
}

pub fn substancereferenceinformation_search_bundled(
  sp: r4_sansio.SpSubstancereferenceinformation,
  client: FhirClient,
) {
  let req = r4_sansio.substancereferenceinformation_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn substancereferenceinformation_search(
  sp: r4_sansio.SpSubstancereferenceinformation,
  client: FhirClient,
) -> Result(List(r4.Substancereferenceinformation), Err) {
  let req = r4_sansio.substancereferenceinformation_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.substancereferenceinformation
  })
}

pub fn substancesourcematerial_create(
  resource: r4.Substancesourcematerial,
  client: FhirClient,
) -> Result(r4.Substancesourcematerial, Err) {
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
) -> Result(r4.Substancesourcematerial, Err) {
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
) -> Result(r4.Substancesourcematerial, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "SubstanceSourceMaterial", client)
}

pub fn substancesourcematerial_search_bundled(
  sp: r4_sansio.SpSubstancesourcematerial,
  client: FhirClient,
) {
  let req = r4_sansio.substancesourcematerial_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn substancesourcematerial_search(
  sp: r4_sansio.SpSubstancesourcematerial,
  client: FhirClient,
) -> Result(List(r4.Substancesourcematerial), Err) {
  let req = r4_sansio.substancesourcematerial_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.substancesourcematerial
  })
}

pub fn substancespecification_create(
  resource: r4.Substancespecification,
  client: FhirClient,
) -> Result(r4.Substancespecification, Err) {
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
) -> Result(r4.Substancespecification, Err) {
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
) -> Result(r4.Substancespecification, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "SubstanceSpecification", client)
}

pub fn substancespecification_search_bundled(
  sp: r4_sansio.SpSubstancespecification,
  client: FhirClient,
) {
  let req = r4_sansio.substancespecification_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn substancespecification_search(
  sp: r4_sansio.SpSubstancespecification,
  client: FhirClient,
) -> Result(List(r4.Substancespecification), Err) {
  let req = r4_sansio.substancespecification_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.substancespecification
  })
}

pub fn supplydelivery_create(
  resource: r4.Supplydelivery,
  client: FhirClient,
) -> Result(r4.Supplydelivery, Err) {
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
) -> Result(r4.Supplydelivery, Err) {
  any_read(id, client, "SupplyDelivery", r4.supplydelivery_decoder())
}

pub fn supplydelivery_update(
  resource: r4.Supplydelivery,
  client: FhirClient,
) -> Result(r4.Supplydelivery, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "SupplyDelivery", client)
}

pub fn supplydelivery_search_bundled(
  sp: r4_sansio.SpSupplydelivery,
  client: FhirClient,
) {
  let req = r4_sansio.supplydelivery_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn supplydelivery_search(
  sp: r4_sansio.SpSupplydelivery,
  client: FhirClient,
) -> Result(List(r4.Supplydelivery), Err) {
  let req = r4_sansio.supplydelivery_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.supplydelivery
  })
}

pub fn supplyrequest_create(
  resource: r4.Supplyrequest,
  client: FhirClient,
) -> Result(r4.Supplyrequest, Err) {
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
) -> Result(r4.Supplyrequest, Err) {
  any_read(id, client, "SupplyRequest", r4.supplyrequest_decoder())
}

pub fn supplyrequest_update(
  resource: r4.Supplyrequest,
  client: FhirClient,
) -> Result(r4.Supplyrequest, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "SupplyRequest", client)
}

pub fn supplyrequest_search_bundled(
  sp: r4_sansio.SpSupplyrequest,
  client: FhirClient,
) {
  let req = r4_sansio.supplyrequest_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn supplyrequest_search(
  sp: r4_sansio.SpSupplyrequest,
  client: FhirClient,
) -> Result(List(r4.Supplyrequest), Err) {
  let req = r4_sansio.supplyrequest_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.supplyrequest
  })
}

pub fn task_create(
  resource: r4.Task,
  client: FhirClient,
) -> Result(r4.Task, Err) {
  any_create(r4.task_to_json(resource), "Task", r4.task_decoder(), client)
}

pub fn task_read(id: String, client: FhirClient) -> Result(r4.Task, Err) {
  any_read(id, client, "Task", r4.task_decoder())
}

pub fn task_update(
  resource: r4.Task,
  client: FhirClient,
) -> Result(r4.Task, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "Task", client)
}

pub fn task_search_bundled(sp: r4_sansio.SpTask, client: FhirClient) {
  let req = r4_sansio.task_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn task_search(
  sp: r4_sansio.SpTask,
  client: FhirClient,
) -> Result(List(r4.Task), Err) {
  let req = r4_sansio.task_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.task
  })
}

pub fn terminologycapabilities_create(
  resource: r4.Terminologycapabilities,
  client: FhirClient,
) -> Result(r4.Terminologycapabilities, Err) {
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
) -> Result(r4.Terminologycapabilities, Err) {
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
) -> Result(r4.Terminologycapabilities, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "TerminologyCapabilities", client)
}

pub fn terminologycapabilities_search_bundled(
  sp: r4_sansio.SpTerminologycapabilities,
  client: FhirClient,
) {
  let req = r4_sansio.terminologycapabilities_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn terminologycapabilities_search(
  sp: r4_sansio.SpTerminologycapabilities,
  client: FhirClient,
) -> Result(List(r4.Terminologycapabilities), Err) {
  let req = r4_sansio.terminologycapabilities_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.terminologycapabilities
  })
}

pub fn testreport_create(
  resource: r4.Testreport,
  client: FhirClient,
) -> Result(r4.Testreport, Err) {
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
) -> Result(r4.Testreport, Err) {
  any_read(id, client, "TestReport", r4.testreport_decoder())
}

pub fn testreport_update(
  resource: r4.Testreport,
  client: FhirClient,
) -> Result(r4.Testreport, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "TestReport", client)
}

pub fn testreport_search_bundled(sp: r4_sansio.SpTestreport, client: FhirClient) {
  let req = r4_sansio.testreport_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn testreport_search(
  sp: r4_sansio.SpTestreport,
  client: FhirClient,
) -> Result(List(r4.Testreport), Err) {
  let req = r4_sansio.testreport_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.testreport
  })
}

pub fn testscript_create(
  resource: r4.Testscript,
  client: FhirClient,
) -> Result(r4.Testscript, Err) {
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
) -> Result(r4.Testscript, Err) {
  any_read(id, client, "TestScript", r4.testscript_decoder())
}

pub fn testscript_update(
  resource: r4.Testscript,
  client: FhirClient,
) -> Result(r4.Testscript, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "TestScript", client)
}

pub fn testscript_search_bundled(sp: r4_sansio.SpTestscript, client: FhirClient) {
  let req = r4_sansio.testscript_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn testscript_search(
  sp: r4_sansio.SpTestscript,
  client: FhirClient,
) -> Result(List(r4.Testscript), Err) {
  let req = r4_sansio.testscript_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.testscript
  })
}

pub fn valueset_create(
  resource: r4.Valueset,
  client: FhirClient,
) -> Result(r4.Valueset, Err) {
  any_create(
    r4.valueset_to_json(resource),
    "ValueSet",
    r4.valueset_decoder(),
    client,
  )
}

pub fn valueset_read(id: String, client: FhirClient) -> Result(r4.Valueset, Err) {
  any_read(id, client, "ValueSet", r4.valueset_decoder())
}

pub fn valueset_update(
  resource: r4.Valueset,
  client: FhirClient,
) -> Result(r4.Valueset, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "ValueSet", client)
}

pub fn valueset_search_bundled(sp: r4_sansio.SpValueset, client: FhirClient) {
  let req = r4_sansio.valueset_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn valueset_search(
  sp: r4_sansio.SpValueset,
  client: FhirClient,
) -> Result(List(r4.Valueset), Err) {
  let req = r4_sansio.valueset_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.valueset
  })
}

pub fn verificationresult_create(
  resource: r4.Verificationresult,
  client: FhirClient,
) -> Result(r4.Verificationresult, Err) {
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
) -> Result(r4.Verificationresult, Err) {
  any_read(id, client, "VerificationResult", r4.verificationresult_decoder())
}

pub fn verificationresult_update(
  resource: r4.Verificationresult,
  client: FhirClient,
) -> Result(r4.Verificationresult, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "VerificationResult", client)
}

pub fn verificationresult_search_bundled(
  sp: r4_sansio.SpVerificationresult,
  client: FhirClient,
) {
  let req = r4_sansio.verificationresult_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn verificationresult_search(
  sp: r4_sansio.SpVerificationresult,
  client: FhirClient,
) -> Result(List(r4.Verificationresult), Err) {
  let req = r4_sansio.verificationresult_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.verificationresult
  })
}

pub fn visionprescription_create(
  resource: r4.Visionprescription,
  client: FhirClient,
) -> Result(r4.Visionprescription, Err) {
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
) -> Result(r4.Visionprescription, Err) {
  any_read(id, client, "VisionPrescription", r4.visionprescription_decoder())
}

pub fn visionprescription_update(
  resource: r4.Visionprescription,
  client: FhirClient,
) -> Result(r4.Visionprescription, Err) {
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
) -> Result(r4.Operationoutcome, Err) {
  any_delete(resource.id, "VisionPrescription", client)
}

pub fn visionprescription_search_bundled(
  sp: r4_sansio.SpVisionprescription,
  client: FhirClient,
) {
  let req = r4_sansio.visionprescription_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
}

pub fn visionprescription_search(
  sp: r4_sansio.SpVisionprescription,
  client: FhirClient,
) -> Result(List(r4.Visionprescription), Err) {
  let req = r4_sansio.visionprescription_search_req(sp, client)
  sendreq_parseresource(req, r4.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4_sansio.bundle_to_groupedresources }.visionprescription
  })
}
