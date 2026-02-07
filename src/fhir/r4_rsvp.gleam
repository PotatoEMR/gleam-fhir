////[https://hl7.org/fhir/r4](https://hl7.org/fhir/r4) r4 client using rsvp

import fhir/r4
import fhir/r4_sansio
import gleam/dynamic/decode.{type Decoder}
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/json.{type Json}
import gleam/option.{type Option}
import lustre/effect.{type Effect}
import rsvp

/// FHIR client for sending http requests to server such as
/// `let read_pat_effect = r4_rsvp.patient_read("123", client, msg)`
///
/// create client from server base url with fhirclient_new(baseurl)`
///
/// `let assert Ok(client) = r4_rsvp.fhirclient_new("r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = r4_rsvp.fhirclient_new("https://r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = r4_rsvp.fhirclient_new("https://hapi.fhir.org/baseR4")`
///
/// `let assert Ok(client) = r4_rsvp.fhirclient_new("127.0.0.1:8000")`
pub type FhirClient =
  r4_sansio.FhirClient

/// creates a new client from server base url
///
/// `let assert Ok(client) = r4_rsvp.fhirclient_new("r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = r4_rsvp.fhirclient_new("https://r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = r4_rsvp.fhirclient_new("https://hapi.fhir.org/baseR4")`
///
/// `let assert Ok(client) = r4_rsvp.fhirclient_new("127.0.0.1:8000")`
pub fn fhirclient_new(
  baseurl: String,
) -> Result(FhirClient, r4_sansio.ErrBaseUrl) {
  r4_sansio.fhirclient_new(baseurl)
}

pub type Err {
  ErrRsvp(err: rsvp.Error)
  ErrSansio(err: r4_sansio.Err)
}

/// When using rsvp, if you attempt update or delete a resource with no id,
/// we do not even send the request or give you an effect to use.
/// Instead of an effect you get just Error(ErrNoId)
pub type ErrNoId {
  ErrNoId
}

fn any_create(
  resource: Json,
  res_type: String,
  resource_dec: Decoder(r),
  client: FhirClient,
  handle_response: fn(Result(r, Err)) -> a,
) -> Effect(a) {
  let req = r4_sansio.any_create_req(resource, res_type, client)
  sendreq_handleresponse(req, resource_dec, handle_response)
}

fn any_read(
  id: String,
  res_type: String,
  resource_dec: Decoder(r),
  client: FhirClient,
  handle_response: fn(Result(r, Err)) -> a,
) -> Effect(a) {
  let req = r4_sansio.any_read_req(id, res_type, client)
  sendreq_handleresponse(req, resource_dec, handle_response)
}

fn any_update(
  id: Option(String),
  resource: Json,
  res_type: String,
  resource_dec: Decoder(r),
  client: FhirClient,
  handle_response: fn(Result(r, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  let req = r4_sansio.any_update_req(id, resource, res_type, client)
  case req {
    Ok(req) -> Ok(sendreq_handleresponse(req, resource_dec, handle_response))
    Error(r4_sansio.ErrNoId) -> Error(ErrNoId)
    Error(_) ->
      panic as "should never get any errors besides NoId before making request"
  }
}

fn any_delete(
  id: Option(String),
  res_type: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  let req = r4_sansio.any_delete_req(id, res_type, client)
  case req {
    Ok(req) ->
      Ok(sendreq_handleresponse(
        req,
        r4.operationoutcome_decoder(),
        handle_response,
      ))
    Error(r4_sansio.ErrNoId) -> Error(ErrNoId)
    Error(_) ->
      panic as "should never get any errors besides NoId before making request"
  }
}

/// write out search string manually, in case typed search params don't work
pub fn search_any(
  search_string: String,
  res_type: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.any_search_req(search_string, res_type, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

// run any operation string on any resource string, optionally using Parameters
pub fn operation_any(
  params params: Option(r4.Parameters),
  operation_name operation_name: String,
  res_type res_type: String,
  res_id res_id: Option(String),
  res_decoder res_decoder: Decoder(res),
  client client: FhirClient,
  handle_response handle_response: fn(Result(res, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4_sansio.any_operation_req(
      res_type,
      res_id,
      operation_name,
      params,
      client,
    )
  sendreq_handleresponse(req, res_decoder, handle_response)
}

fn sendreq_handleresponse(
  req: Request(String),
  res_dec: Decoder(r),
  handle_response: fn(Result(r, Err)) -> a,
) -> Effect(a) {
  sendreq_handleresponse_andprocess(req, res_dec, handle_response, fn(a) { a })
}

fn sendreq_handleresponse_andprocess(
  req: Request(String),
  res_dec: Decoder(r),
  handle_response: fn(Result(b, Err)) -> a,
  process_res: fn(r) -> b,
) -> Effect(a) {
  let handle_read = fn(resp_res: Result(Response(String), rsvp.Error)) {
    handle_response(case resp_res {
      Error(err) -> Error(ErrRsvp(err))
      Ok(resp_res) -> {
        case r4_sansio.any_resp(resp_res, res_dec) {
          Ok(res) -> Ok(process_res(res))
          Error(err) -> Error(ErrSansio(err))
        }
      }
    })
  }
  let handler = rsvp.expect_any_response(handle_read)
  rsvp.send(req, handler)
}

pub fn account_create(
  resource: r4.Account,
  client: FhirClient,
  handle_response: fn(Result(r4.Account, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.account_to_json(resource),
    "Account",
    r4.account_decoder(),
    client,
    handle_response,
  )
}

pub fn account_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Account, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Account", r4.account_decoder(), client, handle_response)
}

pub fn account_update(
  resource: r4.Account,
  client: FhirClient,
  handle_response: fn(Result(r4.Account, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.account_to_json(resource),
    "Account",
    r4.account_decoder(),
    client,
    handle_response,
  )
}

pub fn account_delete(
  resource: r4.Account,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Account", client, handle_response)
}

pub fn account_search_bundled(
  search_for search_args: r4_sansio.SpAccount,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.account_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn account_search(
  search_for search_args: r4_sansio.SpAccount,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Account), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.account_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.account },
  )
}

pub fn activitydefinition_create(
  resource: r4.Activitydefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Activitydefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.activitydefinition_to_json(resource),
    "ActivityDefinition",
    r4.activitydefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn activitydefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Activitydefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ActivityDefinition",
    r4.activitydefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn activitydefinition_update(
  resource: r4.Activitydefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Activitydefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.activitydefinition_to_json(resource),
    "ActivityDefinition",
    r4.activitydefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn activitydefinition_delete(
  resource: r4.Activitydefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ActivityDefinition", client, handle_response)
}

pub fn activitydefinition_search_bundled(
  search_for search_args: r4_sansio.SpActivitydefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.activitydefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn activitydefinition_search(
  search_for search_args: r4_sansio.SpActivitydefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Activitydefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.activitydefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.activitydefinition
    },
  )
}

pub fn adverseevent_create(
  resource: r4.Adverseevent,
  client: FhirClient,
  handle_response: fn(Result(r4.Adverseevent, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.adverseevent_to_json(resource),
    "AdverseEvent",
    r4.adverseevent_decoder(),
    client,
    handle_response,
  )
}

pub fn adverseevent_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Adverseevent, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "AdverseEvent",
    r4.adverseevent_decoder(),
    client,
    handle_response,
  )
}

pub fn adverseevent_update(
  resource: r4.Adverseevent,
  client: FhirClient,
  handle_response: fn(Result(r4.Adverseevent, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.adverseevent_to_json(resource),
    "AdverseEvent",
    r4.adverseevent_decoder(),
    client,
    handle_response,
  )
}

pub fn adverseevent_delete(
  resource: r4.Adverseevent,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "AdverseEvent", client, handle_response)
}

pub fn adverseevent_search_bundled(
  search_for search_args: r4_sansio.SpAdverseevent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.adverseevent_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn adverseevent_search(
  search_for search_args: r4_sansio.SpAdverseevent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Adverseevent), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.adverseevent_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.adverseevent
    },
  )
}

pub fn allergyintolerance_create(
  resource: r4.Allergyintolerance,
  client: FhirClient,
  handle_response: fn(Result(r4.Allergyintolerance, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    r4.allergyintolerance_decoder(),
    client,
    handle_response,
  )
}

pub fn allergyintolerance_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Allergyintolerance, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "AllergyIntolerance",
    r4.allergyintolerance_decoder(),
    client,
    handle_response,
  )
}

pub fn allergyintolerance_update(
  resource: r4.Allergyintolerance,
  client: FhirClient,
  handle_response: fn(Result(r4.Allergyintolerance, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    r4.allergyintolerance_decoder(),
    client,
    handle_response,
  )
}

pub fn allergyintolerance_delete(
  resource: r4.Allergyintolerance,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "AllergyIntolerance", client, handle_response)
}

pub fn allergyintolerance_search_bundled(
  search_for search_args: r4_sansio.SpAllergyintolerance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.allergyintolerance_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn allergyintolerance_search(
  search_for search_args: r4_sansio.SpAllergyintolerance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Allergyintolerance), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.allergyintolerance_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.allergyintolerance
    },
  )
}

pub fn appointment_create(
  resource: r4.Appointment,
  client: FhirClient,
  handle_response: fn(Result(r4.Appointment, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.appointment_to_json(resource),
    "Appointment",
    r4.appointment_decoder(),
    client,
    handle_response,
  )
}

pub fn appointment_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Appointment, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Appointment", r4.appointment_decoder(), client, handle_response)
}

pub fn appointment_update(
  resource: r4.Appointment,
  client: FhirClient,
  handle_response: fn(Result(r4.Appointment, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.appointment_to_json(resource),
    "Appointment",
    r4.appointment_decoder(),
    client,
    handle_response,
  )
}

pub fn appointment_delete(
  resource: r4.Appointment,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Appointment", client, handle_response)
}

pub fn appointment_search_bundled(
  search_for search_args: r4_sansio.SpAppointment,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.appointment_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn appointment_search(
  search_for search_args: r4_sansio.SpAppointment,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Appointment), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.appointment_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.appointment
    },
  )
}

pub fn appointmentresponse_create(
  resource: r4.Appointmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r4.Appointmentresponse, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.appointmentresponse_to_json(resource),
    "AppointmentResponse",
    r4.appointmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn appointmentresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Appointmentresponse, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "AppointmentResponse",
    r4.appointmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn appointmentresponse_update(
  resource: r4.Appointmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r4.Appointmentresponse, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.appointmentresponse_to_json(resource),
    "AppointmentResponse",
    r4.appointmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn appointmentresponse_delete(
  resource: r4.Appointmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "AppointmentResponse", client, handle_response)
}

pub fn appointmentresponse_search_bundled(
  search_for search_args: r4_sansio.SpAppointmentresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.appointmentresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn appointmentresponse_search(
  search_for search_args: r4_sansio.SpAppointmentresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Appointmentresponse), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.appointmentresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.appointmentresponse
    },
  )
}

pub fn auditevent_create(
  resource: r4.Auditevent,
  client: FhirClient,
  handle_response: fn(Result(r4.Auditevent, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.auditevent_to_json(resource),
    "AuditEvent",
    r4.auditevent_decoder(),
    client,
    handle_response,
  )
}

pub fn auditevent_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Auditevent, Err)) -> a,
) -> Effect(a) {
  any_read(id, "AuditEvent", r4.auditevent_decoder(), client, handle_response)
}

pub fn auditevent_update(
  resource: r4.Auditevent,
  client: FhirClient,
  handle_response: fn(Result(r4.Auditevent, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.auditevent_to_json(resource),
    "AuditEvent",
    r4.auditevent_decoder(),
    client,
    handle_response,
  )
}

pub fn auditevent_delete(
  resource: r4.Auditevent,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "AuditEvent", client, handle_response)
}

pub fn auditevent_search_bundled(
  search_for search_args: r4_sansio.SpAuditevent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.auditevent_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn auditevent_search(
  search_for search_args: r4_sansio.SpAuditevent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Auditevent), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.auditevent_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.auditevent },
  )
}

pub fn basic_create(
  resource: r4.Basic,
  client: FhirClient,
  handle_response: fn(Result(r4.Basic, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.basic_to_json(resource),
    "Basic",
    r4.basic_decoder(),
    client,
    handle_response,
  )
}

pub fn basic_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Basic, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Basic", r4.basic_decoder(), client, handle_response)
}

pub fn basic_update(
  resource: r4.Basic,
  client: FhirClient,
  handle_response: fn(Result(r4.Basic, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.basic_to_json(resource),
    "Basic",
    r4.basic_decoder(),
    client,
    handle_response,
  )
}

pub fn basic_delete(
  resource: r4.Basic,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Basic", client, handle_response)
}

pub fn basic_search_bundled(
  search_for search_args: r4_sansio.SpBasic,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.basic_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn basic_search(
  search_for search_args: r4_sansio.SpBasic,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Basic), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.basic_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.basic },
  )
}

pub fn binary_create(
  resource: r4.Binary,
  client: FhirClient,
  handle_response: fn(Result(r4.Binary, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.binary_to_json(resource),
    "Binary",
    r4.binary_decoder(),
    client,
    handle_response,
  )
}

pub fn binary_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Binary, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Binary", r4.binary_decoder(), client, handle_response)
}

pub fn binary_update(
  resource: r4.Binary,
  client: FhirClient,
  handle_response: fn(Result(r4.Binary, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.binary_to_json(resource),
    "Binary",
    r4.binary_decoder(),
    client,
    handle_response,
  )
}

pub fn binary_delete(
  resource: r4.Binary,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Binary", client, handle_response)
}

pub fn binary_search_bundled(
  search_for search_args: r4_sansio.SpBinary,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.binary_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn binary_search(
  search_for search_args: r4_sansio.SpBinary,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Binary), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.binary_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.binary },
  )
}

pub fn biologicallyderivedproduct_create(
  resource: r4.Biologicallyderivedproduct,
  client: FhirClient,
  handle_response: fn(Result(r4.Biologicallyderivedproduct, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.biologicallyderivedproduct_to_json(resource),
    "BiologicallyDerivedProduct",
    r4.biologicallyderivedproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn biologicallyderivedproduct_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Biologicallyderivedproduct, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "BiologicallyDerivedProduct",
    r4.biologicallyderivedproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn biologicallyderivedproduct_update(
  resource: r4.Biologicallyderivedproduct,
  client: FhirClient,
  handle_response: fn(Result(r4.Biologicallyderivedproduct, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.biologicallyderivedproduct_to_json(resource),
    "BiologicallyDerivedProduct",
    r4.biologicallyderivedproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn biologicallyderivedproduct_delete(
  resource: r4.Biologicallyderivedproduct,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "BiologicallyDerivedProduct", client, handle_response)
}

pub fn biologicallyderivedproduct_search_bundled(
  search_for search_args: r4_sansio.SpBiologicallyderivedproduct,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.biologicallyderivedproduct_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn biologicallyderivedproduct_search(
  search_for search_args: r4_sansio.SpBiologicallyderivedproduct,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4.Biologicallyderivedproduct), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.biologicallyderivedproduct_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.biologicallyderivedproduct
    },
  )
}

pub fn bodystructure_create(
  resource: r4.Bodystructure,
  client: FhirClient,
  handle_response: fn(Result(r4.Bodystructure, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.bodystructure_to_json(resource),
    "BodyStructure",
    r4.bodystructure_decoder(),
    client,
    handle_response,
  )
}

pub fn bodystructure_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Bodystructure, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "BodyStructure",
    r4.bodystructure_decoder(),
    client,
    handle_response,
  )
}

pub fn bodystructure_update(
  resource: r4.Bodystructure,
  client: FhirClient,
  handle_response: fn(Result(r4.Bodystructure, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.bodystructure_to_json(resource),
    "BodyStructure",
    r4.bodystructure_decoder(),
    client,
    handle_response,
  )
}

pub fn bodystructure_delete(
  resource: r4.Bodystructure,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "BodyStructure", client, handle_response)
}

pub fn bodystructure_search_bundled(
  search_for search_args: r4_sansio.SpBodystructure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.bodystructure_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn bodystructure_search(
  search_for search_args: r4_sansio.SpBodystructure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Bodystructure), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.bodystructure_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.bodystructure
    },
  )
}

pub fn bundle_create(
  resource: r4.Bundle,
  client: FhirClient,
  handle_response: fn(Result(r4.Bundle, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.bundle_to_json(resource),
    "Bundle",
    r4.bundle_decoder(),
    client,
    handle_response,
  )
}

pub fn bundle_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Bundle, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Bundle", r4.bundle_decoder(), client, handle_response)
}

pub fn bundle_update(
  resource: r4.Bundle,
  client: FhirClient,
  handle_response: fn(Result(r4.Bundle, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.bundle_to_json(resource),
    "Bundle",
    r4.bundle_decoder(),
    client,
    handle_response,
  )
}

pub fn bundle_delete(
  resource: r4.Bundle,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Bundle", client, handle_response)
}

pub fn bundle_search_bundled(
  search_for search_args: r4_sansio.SpBundle,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.bundle_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn bundle_search(
  search_for search_args: r4_sansio.SpBundle,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Bundle), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.bundle_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.bundle },
  )
}

pub fn capabilitystatement_create(
  resource: r4.Capabilitystatement,
  client: FhirClient,
  handle_response: fn(Result(r4.Capabilitystatement, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.capabilitystatement_to_json(resource),
    "CapabilityStatement",
    r4.capabilitystatement_decoder(),
    client,
    handle_response,
  )
}

pub fn capabilitystatement_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Capabilitystatement, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CapabilityStatement",
    r4.capabilitystatement_decoder(),
    client,
    handle_response,
  )
}

pub fn capabilitystatement_update(
  resource: r4.Capabilitystatement,
  client: FhirClient,
  handle_response: fn(Result(r4.Capabilitystatement, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.capabilitystatement_to_json(resource),
    "CapabilityStatement",
    r4.capabilitystatement_decoder(),
    client,
    handle_response,
  )
}

pub fn capabilitystatement_delete(
  resource: r4.Capabilitystatement,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CapabilityStatement", client, handle_response)
}

pub fn capabilitystatement_search_bundled(
  search_for search_args: r4_sansio.SpCapabilitystatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.capabilitystatement_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn capabilitystatement_search(
  search_for search_args: r4_sansio.SpCapabilitystatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Capabilitystatement), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.capabilitystatement_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.capabilitystatement
    },
  )
}

pub fn careplan_create(
  resource: r4.Careplan,
  client: FhirClient,
  handle_response: fn(Result(r4.Careplan, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.careplan_to_json(resource),
    "CarePlan",
    r4.careplan_decoder(),
    client,
    handle_response,
  )
}

pub fn careplan_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Careplan, Err)) -> a,
) -> Effect(a) {
  any_read(id, "CarePlan", r4.careplan_decoder(), client, handle_response)
}

pub fn careplan_update(
  resource: r4.Careplan,
  client: FhirClient,
  handle_response: fn(Result(r4.Careplan, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.careplan_to_json(resource),
    "CarePlan",
    r4.careplan_decoder(),
    client,
    handle_response,
  )
}

pub fn careplan_delete(
  resource: r4.Careplan,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CarePlan", client, handle_response)
}

pub fn careplan_search_bundled(
  search_for search_args: r4_sansio.SpCareplan,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.careplan_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn careplan_search(
  search_for search_args: r4_sansio.SpCareplan,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Careplan), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.careplan_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.careplan },
  )
}

pub fn careteam_create(
  resource: r4.Careteam,
  client: FhirClient,
  handle_response: fn(Result(r4.Careteam, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.careteam_to_json(resource),
    "CareTeam",
    r4.careteam_decoder(),
    client,
    handle_response,
  )
}

pub fn careteam_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Careteam, Err)) -> a,
) -> Effect(a) {
  any_read(id, "CareTeam", r4.careteam_decoder(), client, handle_response)
}

pub fn careteam_update(
  resource: r4.Careteam,
  client: FhirClient,
  handle_response: fn(Result(r4.Careteam, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.careteam_to_json(resource),
    "CareTeam",
    r4.careteam_decoder(),
    client,
    handle_response,
  )
}

pub fn careteam_delete(
  resource: r4.Careteam,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CareTeam", client, handle_response)
}

pub fn careteam_search_bundled(
  search_for search_args: r4_sansio.SpCareteam,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.careteam_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn careteam_search(
  search_for search_args: r4_sansio.SpCareteam,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Careteam), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.careteam_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.careteam },
  )
}

pub fn catalogentry_create(
  resource: r4.Catalogentry,
  client: FhirClient,
  handle_response: fn(Result(r4.Catalogentry, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.catalogentry_to_json(resource),
    "CatalogEntry",
    r4.catalogentry_decoder(),
    client,
    handle_response,
  )
}

pub fn catalogentry_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Catalogentry, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CatalogEntry",
    r4.catalogentry_decoder(),
    client,
    handle_response,
  )
}

pub fn catalogentry_update(
  resource: r4.Catalogentry,
  client: FhirClient,
  handle_response: fn(Result(r4.Catalogentry, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.catalogentry_to_json(resource),
    "CatalogEntry",
    r4.catalogentry_decoder(),
    client,
    handle_response,
  )
}

pub fn catalogentry_delete(
  resource: r4.Catalogentry,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CatalogEntry", client, handle_response)
}

pub fn catalogentry_search_bundled(
  search_for search_args: r4_sansio.SpCatalogentry,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.catalogentry_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn catalogentry_search(
  search_for search_args: r4_sansio.SpCatalogentry,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Catalogentry), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.catalogentry_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.catalogentry
    },
  )
}

pub fn chargeitem_create(
  resource: r4.Chargeitem,
  client: FhirClient,
  handle_response: fn(Result(r4.Chargeitem, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.chargeitem_to_json(resource),
    "ChargeItem",
    r4.chargeitem_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitem_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Chargeitem, Err)) -> a,
) -> Effect(a) {
  any_read(id, "ChargeItem", r4.chargeitem_decoder(), client, handle_response)
}

pub fn chargeitem_update(
  resource: r4.Chargeitem,
  client: FhirClient,
  handle_response: fn(Result(r4.Chargeitem, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.chargeitem_to_json(resource),
    "ChargeItem",
    r4.chargeitem_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitem_delete(
  resource: r4.Chargeitem,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ChargeItem", client, handle_response)
}

pub fn chargeitem_search_bundled(
  search_for search_args: r4_sansio.SpChargeitem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.chargeitem_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn chargeitem_search(
  search_for search_args: r4_sansio.SpChargeitem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Chargeitem), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.chargeitem_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.chargeitem },
  )
}

pub fn chargeitemdefinition_create(
  resource: r4.Chargeitemdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Chargeitemdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.chargeitemdefinition_to_json(resource),
    "ChargeItemDefinition",
    r4.chargeitemdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitemdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Chargeitemdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ChargeItemDefinition",
    r4.chargeitemdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitemdefinition_update(
  resource: r4.Chargeitemdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Chargeitemdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.chargeitemdefinition_to_json(resource),
    "ChargeItemDefinition",
    r4.chargeitemdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitemdefinition_delete(
  resource: r4.Chargeitemdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ChargeItemDefinition", client, handle_response)
}

pub fn chargeitemdefinition_search_bundled(
  search_for search_args: r4_sansio.SpChargeitemdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.chargeitemdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn chargeitemdefinition_search(
  search_for search_args: r4_sansio.SpChargeitemdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Chargeitemdefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.chargeitemdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.chargeitemdefinition
    },
  )
}

pub fn claim_create(
  resource: r4.Claim,
  client: FhirClient,
  handle_response: fn(Result(r4.Claim, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.claim_to_json(resource),
    "Claim",
    r4.claim_decoder(),
    client,
    handle_response,
  )
}

pub fn claim_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Claim, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Claim", r4.claim_decoder(), client, handle_response)
}

pub fn claim_update(
  resource: r4.Claim,
  client: FhirClient,
  handle_response: fn(Result(r4.Claim, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.claim_to_json(resource),
    "Claim",
    r4.claim_decoder(),
    client,
    handle_response,
  )
}

pub fn claim_delete(
  resource: r4.Claim,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Claim", client, handle_response)
}

pub fn claim_search_bundled(
  search_for search_args: r4_sansio.SpClaim,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.claim_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn claim_search(
  search_for search_args: r4_sansio.SpClaim,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Claim), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.claim_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.claim },
  )
}

pub fn claimresponse_create(
  resource: r4.Claimresponse,
  client: FhirClient,
  handle_response: fn(Result(r4.Claimresponse, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.claimresponse_to_json(resource),
    "ClaimResponse",
    r4.claimresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn claimresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Claimresponse, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ClaimResponse",
    r4.claimresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn claimresponse_update(
  resource: r4.Claimresponse,
  client: FhirClient,
  handle_response: fn(Result(r4.Claimresponse, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.claimresponse_to_json(resource),
    "ClaimResponse",
    r4.claimresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn claimresponse_delete(
  resource: r4.Claimresponse,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ClaimResponse", client, handle_response)
}

pub fn claimresponse_search_bundled(
  search_for search_args: r4_sansio.SpClaimresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.claimresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn claimresponse_search(
  search_for search_args: r4_sansio.SpClaimresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Claimresponse), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.claimresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.claimresponse
    },
  )
}

pub fn clinicalimpression_create(
  resource: r4.Clinicalimpression,
  client: FhirClient,
  handle_response: fn(Result(r4.Clinicalimpression, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.clinicalimpression_to_json(resource),
    "ClinicalImpression",
    r4.clinicalimpression_decoder(),
    client,
    handle_response,
  )
}

pub fn clinicalimpression_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Clinicalimpression, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ClinicalImpression",
    r4.clinicalimpression_decoder(),
    client,
    handle_response,
  )
}

pub fn clinicalimpression_update(
  resource: r4.Clinicalimpression,
  client: FhirClient,
  handle_response: fn(Result(r4.Clinicalimpression, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.clinicalimpression_to_json(resource),
    "ClinicalImpression",
    r4.clinicalimpression_decoder(),
    client,
    handle_response,
  )
}

pub fn clinicalimpression_delete(
  resource: r4.Clinicalimpression,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ClinicalImpression", client, handle_response)
}

pub fn clinicalimpression_search_bundled(
  search_for search_args: r4_sansio.SpClinicalimpression,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.clinicalimpression_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn clinicalimpression_search(
  search_for search_args: r4_sansio.SpClinicalimpression,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Clinicalimpression), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.clinicalimpression_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.clinicalimpression
    },
  )
}

pub fn codesystem_create(
  resource: r4.Codesystem,
  client: FhirClient,
  handle_response: fn(Result(r4.Codesystem, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.codesystem_to_json(resource),
    "CodeSystem",
    r4.codesystem_decoder(),
    client,
    handle_response,
  )
}

pub fn codesystem_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Codesystem, Err)) -> a,
) -> Effect(a) {
  any_read(id, "CodeSystem", r4.codesystem_decoder(), client, handle_response)
}

pub fn codesystem_update(
  resource: r4.Codesystem,
  client: FhirClient,
  handle_response: fn(Result(r4.Codesystem, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.codesystem_to_json(resource),
    "CodeSystem",
    r4.codesystem_decoder(),
    client,
    handle_response,
  )
}

pub fn codesystem_delete(
  resource: r4.Codesystem,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CodeSystem", client, handle_response)
}

pub fn codesystem_search_bundled(
  search_for search_args: r4_sansio.SpCodesystem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.codesystem_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn codesystem_search(
  search_for search_args: r4_sansio.SpCodesystem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Codesystem), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.codesystem_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.codesystem },
  )
}

pub fn communication_create(
  resource: r4.Communication,
  client: FhirClient,
  handle_response: fn(Result(r4.Communication, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.communication_to_json(resource),
    "Communication",
    r4.communication_decoder(),
    client,
    handle_response,
  )
}

pub fn communication_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Communication, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Communication",
    r4.communication_decoder(),
    client,
    handle_response,
  )
}

pub fn communication_update(
  resource: r4.Communication,
  client: FhirClient,
  handle_response: fn(Result(r4.Communication, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.communication_to_json(resource),
    "Communication",
    r4.communication_decoder(),
    client,
    handle_response,
  )
}

pub fn communication_delete(
  resource: r4.Communication,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Communication", client, handle_response)
}

pub fn communication_search_bundled(
  search_for search_args: r4_sansio.SpCommunication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.communication_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn communication_search(
  search_for search_args: r4_sansio.SpCommunication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Communication), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.communication_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.communication
    },
  )
}

pub fn communicationrequest_create(
  resource: r4.Communicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r4.Communicationrequest, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.communicationrequest_to_json(resource),
    "CommunicationRequest",
    r4.communicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn communicationrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Communicationrequest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CommunicationRequest",
    r4.communicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn communicationrequest_update(
  resource: r4.Communicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r4.Communicationrequest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.communicationrequest_to_json(resource),
    "CommunicationRequest",
    r4.communicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn communicationrequest_delete(
  resource: r4.Communicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CommunicationRequest", client, handle_response)
}

pub fn communicationrequest_search_bundled(
  search_for search_args: r4_sansio.SpCommunicationrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.communicationrequest_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn communicationrequest_search(
  search_for search_args: r4_sansio.SpCommunicationrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Communicationrequest), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.communicationrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.communicationrequest
    },
  )
}

pub fn compartmentdefinition_create(
  resource: r4.Compartmentdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Compartmentdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.compartmentdefinition_to_json(resource),
    "CompartmentDefinition",
    r4.compartmentdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn compartmentdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Compartmentdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CompartmentDefinition",
    r4.compartmentdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn compartmentdefinition_update(
  resource: r4.Compartmentdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Compartmentdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.compartmentdefinition_to_json(resource),
    "CompartmentDefinition",
    r4.compartmentdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn compartmentdefinition_delete(
  resource: r4.Compartmentdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CompartmentDefinition", client, handle_response)
}

pub fn compartmentdefinition_search_bundled(
  search_for search_args: r4_sansio.SpCompartmentdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.compartmentdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn compartmentdefinition_search(
  search_for search_args: r4_sansio.SpCompartmentdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Compartmentdefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.compartmentdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.compartmentdefinition
    },
  )
}

pub fn composition_create(
  resource: r4.Composition,
  client: FhirClient,
  handle_response: fn(Result(r4.Composition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.composition_to_json(resource),
    "Composition",
    r4.composition_decoder(),
    client,
    handle_response,
  )
}

pub fn composition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Composition, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Composition", r4.composition_decoder(), client, handle_response)
}

pub fn composition_update(
  resource: r4.Composition,
  client: FhirClient,
  handle_response: fn(Result(r4.Composition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.composition_to_json(resource),
    "Composition",
    r4.composition_decoder(),
    client,
    handle_response,
  )
}

pub fn composition_delete(
  resource: r4.Composition,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Composition", client, handle_response)
}

pub fn composition_search_bundled(
  search_for search_args: r4_sansio.SpComposition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.composition_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn composition_search(
  search_for search_args: r4_sansio.SpComposition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Composition), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.composition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.composition
    },
  )
}

pub fn conceptmap_create(
  resource: r4.Conceptmap,
  client: FhirClient,
  handle_response: fn(Result(r4.Conceptmap, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.conceptmap_to_json(resource),
    "ConceptMap",
    r4.conceptmap_decoder(),
    client,
    handle_response,
  )
}

pub fn conceptmap_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Conceptmap, Err)) -> a,
) -> Effect(a) {
  any_read(id, "ConceptMap", r4.conceptmap_decoder(), client, handle_response)
}

pub fn conceptmap_update(
  resource: r4.Conceptmap,
  client: FhirClient,
  handle_response: fn(Result(r4.Conceptmap, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.conceptmap_to_json(resource),
    "ConceptMap",
    r4.conceptmap_decoder(),
    client,
    handle_response,
  )
}

pub fn conceptmap_delete(
  resource: r4.Conceptmap,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ConceptMap", client, handle_response)
}

pub fn conceptmap_search_bundled(
  search_for search_args: r4_sansio.SpConceptmap,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.conceptmap_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn conceptmap_search(
  search_for search_args: r4_sansio.SpConceptmap,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Conceptmap), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.conceptmap_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.conceptmap },
  )
}

pub fn condition_create(
  resource: r4.Condition,
  client: FhirClient,
  handle_response: fn(Result(r4.Condition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.condition_to_json(resource),
    "Condition",
    r4.condition_decoder(),
    client,
    handle_response,
  )
}

pub fn condition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Condition, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Condition", r4.condition_decoder(), client, handle_response)
}

pub fn condition_update(
  resource: r4.Condition,
  client: FhirClient,
  handle_response: fn(Result(r4.Condition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.condition_to_json(resource),
    "Condition",
    r4.condition_decoder(),
    client,
    handle_response,
  )
}

pub fn condition_delete(
  resource: r4.Condition,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Condition", client, handle_response)
}

pub fn condition_search_bundled(
  search_for search_args: r4_sansio.SpCondition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.condition_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn condition_search(
  search_for search_args: r4_sansio.SpCondition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Condition), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.condition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.condition },
  )
}

pub fn consent_create(
  resource: r4.Consent,
  client: FhirClient,
  handle_response: fn(Result(r4.Consent, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.consent_to_json(resource),
    "Consent",
    r4.consent_decoder(),
    client,
    handle_response,
  )
}

pub fn consent_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Consent, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Consent", r4.consent_decoder(), client, handle_response)
}

pub fn consent_update(
  resource: r4.Consent,
  client: FhirClient,
  handle_response: fn(Result(r4.Consent, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.consent_to_json(resource),
    "Consent",
    r4.consent_decoder(),
    client,
    handle_response,
  )
}

pub fn consent_delete(
  resource: r4.Consent,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Consent", client, handle_response)
}

pub fn consent_search_bundled(
  search_for search_args: r4_sansio.SpConsent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.consent_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn consent_search(
  search_for search_args: r4_sansio.SpConsent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Consent), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.consent_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.consent },
  )
}

pub fn contract_create(
  resource: r4.Contract,
  client: FhirClient,
  handle_response: fn(Result(r4.Contract, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.contract_to_json(resource),
    "Contract",
    r4.contract_decoder(),
    client,
    handle_response,
  )
}

pub fn contract_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Contract, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Contract", r4.contract_decoder(), client, handle_response)
}

pub fn contract_update(
  resource: r4.Contract,
  client: FhirClient,
  handle_response: fn(Result(r4.Contract, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.contract_to_json(resource),
    "Contract",
    r4.contract_decoder(),
    client,
    handle_response,
  )
}

pub fn contract_delete(
  resource: r4.Contract,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Contract", client, handle_response)
}

pub fn contract_search_bundled(
  search_for search_args: r4_sansio.SpContract,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.contract_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn contract_search(
  search_for search_args: r4_sansio.SpContract,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Contract), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.contract_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.contract },
  )
}

pub fn coverage_create(
  resource: r4.Coverage,
  client: FhirClient,
  handle_response: fn(Result(r4.Coverage, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.coverage_to_json(resource),
    "Coverage",
    r4.coverage_decoder(),
    client,
    handle_response,
  )
}

pub fn coverage_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Coverage, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Coverage", r4.coverage_decoder(), client, handle_response)
}

pub fn coverage_update(
  resource: r4.Coverage,
  client: FhirClient,
  handle_response: fn(Result(r4.Coverage, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.coverage_to_json(resource),
    "Coverage",
    r4.coverage_decoder(),
    client,
    handle_response,
  )
}

pub fn coverage_delete(
  resource: r4.Coverage,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Coverage", client, handle_response)
}

pub fn coverage_search_bundled(
  search_for search_args: r4_sansio.SpCoverage,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.coverage_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn coverage_search(
  search_for search_args: r4_sansio.SpCoverage,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Coverage), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.coverage_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.coverage },
  )
}

pub fn coverageeligibilityrequest_create(
  resource: r4.Coverageeligibilityrequest,
  client: FhirClient,
  handle_response: fn(Result(r4.Coverageeligibilityrequest, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.coverageeligibilityrequest_to_json(resource),
    "CoverageEligibilityRequest",
    r4.coverageeligibilityrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Coverageeligibilityrequest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CoverageEligibilityRequest",
    r4.coverageeligibilityrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityrequest_update(
  resource: r4.Coverageeligibilityrequest,
  client: FhirClient,
  handle_response: fn(Result(r4.Coverageeligibilityrequest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.coverageeligibilityrequest_to_json(resource),
    "CoverageEligibilityRequest",
    r4.coverageeligibilityrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityrequest_delete(
  resource: r4.Coverageeligibilityrequest,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CoverageEligibilityRequest", client, handle_response)
}

pub fn coverageeligibilityrequest_search_bundled(
  search_for search_args: r4_sansio.SpCoverageeligibilityrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.coverageeligibilityrequest_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn coverageeligibilityrequest_search(
  search_for search_args: r4_sansio.SpCoverageeligibilityrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4.Coverageeligibilityrequest), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.coverageeligibilityrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.coverageeligibilityrequest
    },
  )
}

pub fn coverageeligibilityresponse_create(
  resource: r4.Coverageeligibilityresponse,
  client: FhirClient,
  handle_response: fn(Result(r4.Coverageeligibilityresponse, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.coverageeligibilityresponse_to_json(resource),
    "CoverageEligibilityResponse",
    r4.coverageeligibilityresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Coverageeligibilityresponse, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CoverageEligibilityResponse",
    r4.coverageeligibilityresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityresponse_update(
  resource: r4.Coverageeligibilityresponse,
  client: FhirClient,
  handle_response: fn(Result(r4.Coverageeligibilityresponse, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.coverageeligibilityresponse_to_json(resource),
    "CoverageEligibilityResponse",
    r4.coverageeligibilityresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityresponse_delete(
  resource: r4.Coverageeligibilityresponse,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(
    resource.id,
    "CoverageEligibilityResponse",
    client,
    handle_response,
  )
}

pub fn coverageeligibilityresponse_search_bundled(
  search_for search_args: r4_sansio.SpCoverageeligibilityresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4_sansio.coverageeligibilityresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn coverageeligibilityresponse_search(
  search_for search_args: r4_sansio.SpCoverageeligibilityresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4.Coverageeligibilityresponse), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4_sansio.coverageeligibilityresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.coverageeligibilityresponse
    },
  )
}

pub fn detectedissue_create(
  resource: r4.Detectedissue,
  client: FhirClient,
  handle_response: fn(Result(r4.Detectedissue, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.detectedissue_to_json(resource),
    "DetectedIssue",
    r4.detectedissue_decoder(),
    client,
    handle_response,
  )
}

pub fn detectedissue_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Detectedissue, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DetectedIssue",
    r4.detectedissue_decoder(),
    client,
    handle_response,
  )
}

pub fn detectedissue_update(
  resource: r4.Detectedissue,
  client: FhirClient,
  handle_response: fn(Result(r4.Detectedissue, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.detectedissue_to_json(resource),
    "DetectedIssue",
    r4.detectedissue_decoder(),
    client,
    handle_response,
  )
}

pub fn detectedissue_delete(
  resource: r4.Detectedissue,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DetectedIssue", client, handle_response)
}

pub fn detectedissue_search_bundled(
  search_for search_args: r4_sansio.SpDetectedissue,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.detectedissue_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn detectedissue_search(
  search_for search_args: r4_sansio.SpDetectedissue,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Detectedissue), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.detectedissue_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.detectedissue
    },
  )
}

pub fn device_create(
  resource: r4.Device,
  client: FhirClient,
  handle_response: fn(Result(r4.Device, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.device_to_json(resource),
    "Device",
    r4.device_decoder(),
    client,
    handle_response,
  )
}

pub fn device_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Device, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Device", r4.device_decoder(), client, handle_response)
}

pub fn device_update(
  resource: r4.Device,
  client: FhirClient,
  handle_response: fn(Result(r4.Device, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.device_to_json(resource),
    "Device",
    r4.device_decoder(),
    client,
    handle_response,
  )
}

pub fn device_delete(
  resource: r4.Device,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Device", client, handle_response)
}

pub fn device_search_bundled(
  search_for search_args: r4_sansio.SpDevice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.device_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn device_search(
  search_for search_args: r4_sansio.SpDevice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Device), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.device_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.device },
  )
}

pub fn devicedefinition_create(
  resource: r4.Devicedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Devicedefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.devicedefinition_to_json(resource),
    "DeviceDefinition",
    r4.devicedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn devicedefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Devicedefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DeviceDefinition",
    r4.devicedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn devicedefinition_update(
  resource: r4.Devicedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Devicedefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.devicedefinition_to_json(resource),
    "DeviceDefinition",
    r4.devicedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn devicedefinition_delete(
  resource: r4.Devicedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DeviceDefinition", client, handle_response)
}

pub fn devicedefinition_search_bundled(
  search_for search_args: r4_sansio.SpDevicedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.devicedefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn devicedefinition_search(
  search_for search_args: r4_sansio.SpDevicedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Devicedefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.devicedefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.devicedefinition
    },
  )
}

pub fn devicemetric_create(
  resource: r4.Devicemetric,
  client: FhirClient,
  handle_response: fn(Result(r4.Devicemetric, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.devicemetric_to_json(resource),
    "DeviceMetric",
    r4.devicemetric_decoder(),
    client,
    handle_response,
  )
}

pub fn devicemetric_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Devicemetric, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DeviceMetric",
    r4.devicemetric_decoder(),
    client,
    handle_response,
  )
}

pub fn devicemetric_update(
  resource: r4.Devicemetric,
  client: FhirClient,
  handle_response: fn(Result(r4.Devicemetric, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.devicemetric_to_json(resource),
    "DeviceMetric",
    r4.devicemetric_decoder(),
    client,
    handle_response,
  )
}

pub fn devicemetric_delete(
  resource: r4.Devicemetric,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DeviceMetric", client, handle_response)
}

pub fn devicemetric_search_bundled(
  search_for search_args: r4_sansio.SpDevicemetric,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.devicemetric_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn devicemetric_search(
  search_for search_args: r4_sansio.SpDevicemetric,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Devicemetric), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.devicemetric_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.devicemetric
    },
  )
}

pub fn devicerequest_create(
  resource: r4.Devicerequest,
  client: FhirClient,
  handle_response: fn(Result(r4.Devicerequest, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.devicerequest_to_json(resource),
    "DeviceRequest",
    r4.devicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn devicerequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Devicerequest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DeviceRequest",
    r4.devicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn devicerequest_update(
  resource: r4.Devicerequest,
  client: FhirClient,
  handle_response: fn(Result(r4.Devicerequest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.devicerequest_to_json(resource),
    "DeviceRequest",
    r4.devicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn devicerequest_delete(
  resource: r4.Devicerequest,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DeviceRequest", client, handle_response)
}

pub fn devicerequest_search_bundled(
  search_for search_args: r4_sansio.SpDevicerequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.devicerequest_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn devicerequest_search(
  search_for search_args: r4_sansio.SpDevicerequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Devicerequest), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.devicerequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.devicerequest
    },
  )
}

pub fn deviceusestatement_create(
  resource: r4.Deviceusestatement,
  client: FhirClient,
  handle_response: fn(Result(r4.Deviceusestatement, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.deviceusestatement_to_json(resource),
    "DeviceUseStatement",
    r4.deviceusestatement_decoder(),
    client,
    handle_response,
  )
}

pub fn deviceusestatement_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Deviceusestatement, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DeviceUseStatement",
    r4.deviceusestatement_decoder(),
    client,
    handle_response,
  )
}

pub fn deviceusestatement_update(
  resource: r4.Deviceusestatement,
  client: FhirClient,
  handle_response: fn(Result(r4.Deviceusestatement, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.deviceusestatement_to_json(resource),
    "DeviceUseStatement",
    r4.deviceusestatement_decoder(),
    client,
    handle_response,
  )
}

pub fn deviceusestatement_delete(
  resource: r4.Deviceusestatement,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DeviceUseStatement", client, handle_response)
}

pub fn deviceusestatement_search_bundled(
  search_for search_args: r4_sansio.SpDeviceusestatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.deviceusestatement_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn deviceusestatement_search(
  search_for search_args: r4_sansio.SpDeviceusestatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Deviceusestatement), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.deviceusestatement_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.deviceusestatement
    },
  )
}

pub fn diagnosticreport_create(
  resource: r4.Diagnosticreport,
  client: FhirClient,
  handle_response: fn(Result(r4.Diagnosticreport, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.diagnosticreport_to_json(resource),
    "DiagnosticReport",
    r4.diagnosticreport_decoder(),
    client,
    handle_response,
  )
}

pub fn diagnosticreport_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Diagnosticreport, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DiagnosticReport",
    r4.diagnosticreport_decoder(),
    client,
    handle_response,
  )
}

pub fn diagnosticreport_update(
  resource: r4.Diagnosticreport,
  client: FhirClient,
  handle_response: fn(Result(r4.Diagnosticreport, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.diagnosticreport_to_json(resource),
    "DiagnosticReport",
    r4.diagnosticreport_decoder(),
    client,
    handle_response,
  )
}

pub fn diagnosticreport_delete(
  resource: r4.Diagnosticreport,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DiagnosticReport", client, handle_response)
}

pub fn diagnosticreport_search_bundled(
  search_for search_args: r4_sansio.SpDiagnosticreport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.diagnosticreport_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn diagnosticreport_search(
  search_for search_args: r4_sansio.SpDiagnosticreport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Diagnosticreport), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.diagnosticreport_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.diagnosticreport
    },
  )
}

pub fn documentmanifest_create(
  resource: r4.Documentmanifest,
  client: FhirClient,
  handle_response: fn(Result(r4.Documentmanifest, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.documentmanifest_to_json(resource),
    "DocumentManifest",
    r4.documentmanifest_decoder(),
    client,
    handle_response,
  )
}

pub fn documentmanifest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Documentmanifest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DocumentManifest",
    r4.documentmanifest_decoder(),
    client,
    handle_response,
  )
}

pub fn documentmanifest_update(
  resource: r4.Documentmanifest,
  client: FhirClient,
  handle_response: fn(Result(r4.Documentmanifest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.documentmanifest_to_json(resource),
    "DocumentManifest",
    r4.documentmanifest_decoder(),
    client,
    handle_response,
  )
}

pub fn documentmanifest_delete(
  resource: r4.Documentmanifest,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DocumentManifest", client, handle_response)
}

pub fn documentmanifest_search_bundled(
  search_for search_args: r4_sansio.SpDocumentmanifest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.documentmanifest_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn documentmanifest_search(
  search_for search_args: r4_sansio.SpDocumentmanifest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Documentmanifest), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.documentmanifest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.documentmanifest
    },
  )
}

pub fn documentreference_create(
  resource: r4.Documentreference,
  client: FhirClient,
  handle_response: fn(Result(r4.Documentreference, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.documentreference_to_json(resource),
    "DocumentReference",
    r4.documentreference_decoder(),
    client,
    handle_response,
  )
}

pub fn documentreference_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Documentreference, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DocumentReference",
    r4.documentreference_decoder(),
    client,
    handle_response,
  )
}

pub fn documentreference_update(
  resource: r4.Documentreference,
  client: FhirClient,
  handle_response: fn(Result(r4.Documentreference, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.documentreference_to_json(resource),
    "DocumentReference",
    r4.documentreference_decoder(),
    client,
    handle_response,
  )
}

pub fn documentreference_delete(
  resource: r4.Documentreference,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DocumentReference", client, handle_response)
}

pub fn documentreference_search_bundled(
  search_for search_args: r4_sansio.SpDocumentreference,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.documentreference_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn documentreference_search(
  search_for search_args: r4_sansio.SpDocumentreference,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Documentreference), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.documentreference_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.documentreference
    },
  )
}

pub fn effectevidencesynthesis_create(
  resource: r4.Effectevidencesynthesis,
  client: FhirClient,
  handle_response: fn(Result(r4.Effectevidencesynthesis, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.effectevidencesynthesis_to_json(resource),
    "EffectEvidenceSynthesis",
    r4.effectevidencesynthesis_decoder(),
    client,
    handle_response,
  )
}

pub fn effectevidencesynthesis_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Effectevidencesynthesis, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EffectEvidenceSynthesis",
    r4.effectevidencesynthesis_decoder(),
    client,
    handle_response,
  )
}

pub fn effectevidencesynthesis_update(
  resource: r4.Effectevidencesynthesis,
  client: FhirClient,
  handle_response: fn(Result(r4.Effectevidencesynthesis, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.effectevidencesynthesis_to_json(resource),
    "EffectEvidenceSynthesis",
    r4.effectevidencesynthesis_decoder(),
    client,
    handle_response,
  )
}

pub fn effectevidencesynthesis_delete(
  resource: r4.Effectevidencesynthesis,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "EffectEvidenceSynthesis", client, handle_response)
}

pub fn effectevidencesynthesis_search_bundled(
  search_for search_args: r4_sansio.SpEffectevidencesynthesis,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.effectevidencesynthesis_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn effectevidencesynthesis_search(
  search_for search_args: r4_sansio.SpEffectevidencesynthesis,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4.Effectevidencesynthesis), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.effectevidencesynthesis_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.effectevidencesynthesis
    },
  )
}

pub fn encounter_create(
  resource: r4.Encounter,
  client: FhirClient,
  handle_response: fn(Result(r4.Encounter, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.encounter_to_json(resource),
    "Encounter",
    r4.encounter_decoder(),
    client,
    handle_response,
  )
}

pub fn encounter_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Encounter, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Encounter", r4.encounter_decoder(), client, handle_response)
}

pub fn encounter_update(
  resource: r4.Encounter,
  client: FhirClient,
  handle_response: fn(Result(r4.Encounter, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.encounter_to_json(resource),
    "Encounter",
    r4.encounter_decoder(),
    client,
    handle_response,
  )
}

pub fn encounter_delete(
  resource: r4.Encounter,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Encounter", client, handle_response)
}

pub fn encounter_search_bundled(
  search_for search_args: r4_sansio.SpEncounter,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.encounter_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn encounter_search(
  search_for search_args: r4_sansio.SpEncounter,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Encounter), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.encounter_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.encounter },
  )
}

pub fn endpoint_create(
  resource: r4.Endpoint,
  client: FhirClient,
  handle_response: fn(Result(r4.Endpoint, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.endpoint_to_json(resource),
    "Endpoint",
    r4.endpoint_decoder(),
    client,
    handle_response,
  )
}

pub fn endpoint_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Endpoint, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Endpoint", r4.endpoint_decoder(), client, handle_response)
}

pub fn endpoint_update(
  resource: r4.Endpoint,
  client: FhirClient,
  handle_response: fn(Result(r4.Endpoint, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.endpoint_to_json(resource),
    "Endpoint",
    r4.endpoint_decoder(),
    client,
    handle_response,
  )
}

pub fn endpoint_delete(
  resource: r4.Endpoint,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Endpoint", client, handle_response)
}

pub fn endpoint_search_bundled(
  search_for search_args: r4_sansio.SpEndpoint,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.endpoint_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn endpoint_search(
  search_for search_args: r4_sansio.SpEndpoint,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Endpoint), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.endpoint_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.endpoint },
  )
}

pub fn enrollmentrequest_create(
  resource: r4.Enrollmentrequest,
  client: FhirClient,
  handle_response: fn(Result(r4.Enrollmentrequest, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.enrollmentrequest_to_json(resource),
    "EnrollmentRequest",
    r4.enrollmentrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Enrollmentrequest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EnrollmentRequest",
    r4.enrollmentrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentrequest_update(
  resource: r4.Enrollmentrequest,
  client: FhirClient,
  handle_response: fn(Result(r4.Enrollmentrequest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.enrollmentrequest_to_json(resource),
    "EnrollmentRequest",
    r4.enrollmentrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentrequest_delete(
  resource: r4.Enrollmentrequest,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "EnrollmentRequest", client, handle_response)
}

pub fn enrollmentrequest_search_bundled(
  search_for search_args: r4_sansio.SpEnrollmentrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.enrollmentrequest_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn enrollmentrequest_search(
  search_for search_args: r4_sansio.SpEnrollmentrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Enrollmentrequest), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.enrollmentrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.enrollmentrequest
    },
  )
}

pub fn enrollmentresponse_create(
  resource: r4.Enrollmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r4.Enrollmentresponse, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.enrollmentresponse_to_json(resource),
    "EnrollmentResponse",
    r4.enrollmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Enrollmentresponse, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EnrollmentResponse",
    r4.enrollmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentresponse_update(
  resource: r4.Enrollmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r4.Enrollmentresponse, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.enrollmentresponse_to_json(resource),
    "EnrollmentResponse",
    r4.enrollmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentresponse_delete(
  resource: r4.Enrollmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "EnrollmentResponse", client, handle_response)
}

pub fn enrollmentresponse_search_bundled(
  search_for search_args: r4_sansio.SpEnrollmentresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.enrollmentresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn enrollmentresponse_search(
  search_for search_args: r4_sansio.SpEnrollmentresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Enrollmentresponse), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.enrollmentresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.enrollmentresponse
    },
  )
}

pub fn episodeofcare_create(
  resource: r4.Episodeofcare,
  client: FhirClient,
  handle_response: fn(Result(r4.Episodeofcare, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.episodeofcare_to_json(resource),
    "EpisodeOfCare",
    r4.episodeofcare_decoder(),
    client,
    handle_response,
  )
}

pub fn episodeofcare_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Episodeofcare, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EpisodeOfCare",
    r4.episodeofcare_decoder(),
    client,
    handle_response,
  )
}

pub fn episodeofcare_update(
  resource: r4.Episodeofcare,
  client: FhirClient,
  handle_response: fn(Result(r4.Episodeofcare, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.episodeofcare_to_json(resource),
    "EpisodeOfCare",
    r4.episodeofcare_decoder(),
    client,
    handle_response,
  )
}

pub fn episodeofcare_delete(
  resource: r4.Episodeofcare,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "EpisodeOfCare", client, handle_response)
}

pub fn episodeofcare_search_bundled(
  search_for search_args: r4_sansio.SpEpisodeofcare,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.episodeofcare_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn episodeofcare_search(
  search_for search_args: r4_sansio.SpEpisodeofcare,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Episodeofcare), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.episodeofcare_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.episodeofcare
    },
  )
}

pub fn eventdefinition_create(
  resource: r4.Eventdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Eventdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.eventdefinition_to_json(resource),
    "EventDefinition",
    r4.eventdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn eventdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Eventdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EventDefinition",
    r4.eventdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn eventdefinition_update(
  resource: r4.Eventdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Eventdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.eventdefinition_to_json(resource),
    "EventDefinition",
    r4.eventdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn eventdefinition_delete(
  resource: r4.Eventdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "EventDefinition", client, handle_response)
}

pub fn eventdefinition_search_bundled(
  search_for search_args: r4_sansio.SpEventdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.eventdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn eventdefinition_search(
  search_for search_args: r4_sansio.SpEventdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Eventdefinition), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.eventdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.eventdefinition
    },
  )
}

pub fn evidence_create(
  resource: r4.Evidence,
  client: FhirClient,
  handle_response: fn(Result(r4.Evidence, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.evidence_to_json(resource),
    "Evidence",
    r4.evidence_decoder(),
    client,
    handle_response,
  )
}

pub fn evidence_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Evidence, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Evidence", r4.evidence_decoder(), client, handle_response)
}

pub fn evidence_update(
  resource: r4.Evidence,
  client: FhirClient,
  handle_response: fn(Result(r4.Evidence, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.evidence_to_json(resource),
    "Evidence",
    r4.evidence_decoder(),
    client,
    handle_response,
  )
}

pub fn evidence_delete(
  resource: r4.Evidence,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Evidence", client, handle_response)
}

pub fn evidence_search_bundled(
  search_for search_args: r4_sansio.SpEvidence,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.evidence_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn evidence_search(
  search_for search_args: r4_sansio.SpEvidence,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Evidence), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.evidence_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.evidence },
  )
}

pub fn evidencevariable_create(
  resource: r4.Evidencevariable,
  client: FhirClient,
  handle_response: fn(Result(r4.Evidencevariable, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.evidencevariable_to_json(resource),
    "EvidenceVariable",
    r4.evidencevariable_decoder(),
    client,
    handle_response,
  )
}

pub fn evidencevariable_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Evidencevariable, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EvidenceVariable",
    r4.evidencevariable_decoder(),
    client,
    handle_response,
  )
}

pub fn evidencevariable_update(
  resource: r4.Evidencevariable,
  client: FhirClient,
  handle_response: fn(Result(r4.Evidencevariable, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.evidencevariable_to_json(resource),
    "EvidenceVariable",
    r4.evidencevariable_decoder(),
    client,
    handle_response,
  )
}

pub fn evidencevariable_delete(
  resource: r4.Evidencevariable,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "EvidenceVariable", client, handle_response)
}

pub fn evidencevariable_search_bundled(
  search_for search_args: r4_sansio.SpEvidencevariable,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.evidencevariable_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn evidencevariable_search(
  search_for search_args: r4_sansio.SpEvidencevariable,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Evidencevariable), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.evidencevariable_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.evidencevariable
    },
  )
}

pub fn examplescenario_create(
  resource: r4.Examplescenario,
  client: FhirClient,
  handle_response: fn(Result(r4.Examplescenario, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.examplescenario_to_json(resource),
    "ExampleScenario",
    r4.examplescenario_decoder(),
    client,
    handle_response,
  )
}

pub fn examplescenario_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Examplescenario, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ExampleScenario",
    r4.examplescenario_decoder(),
    client,
    handle_response,
  )
}

pub fn examplescenario_update(
  resource: r4.Examplescenario,
  client: FhirClient,
  handle_response: fn(Result(r4.Examplescenario, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.examplescenario_to_json(resource),
    "ExampleScenario",
    r4.examplescenario_decoder(),
    client,
    handle_response,
  )
}

pub fn examplescenario_delete(
  resource: r4.Examplescenario,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ExampleScenario", client, handle_response)
}

pub fn examplescenario_search_bundled(
  search_for search_args: r4_sansio.SpExamplescenario,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.examplescenario_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn examplescenario_search(
  search_for search_args: r4_sansio.SpExamplescenario,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Examplescenario), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.examplescenario_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.examplescenario
    },
  )
}

pub fn explanationofbenefit_create(
  resource: r4.Explanationofbenefit,
  client: FhirClient,
  handle_response: fn(Result(r4.Explanationofbenefit, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.explanationofbenefit_to_json(resource),
    "ExplanationOfBenefit",
    r4.explanationofbenefit_decoder(),
    client,
    handle_response,
  )
}

pub fn explanationofbenefit_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Explanationofbenefit, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ExplanationOfBenefit",
    r4.explanationofbenefit_decoder(),
    client,
    handle_response,
  )
}

pub fn explanationofbenefit_update(
  resource: r4.Explanationofbenefit,
  client: FhirClient,
  handle_response: fn(Result(r4.Explanationofbenefit, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.explanationofbenefit_to_json(resource),
    "ExplanationOfBenefit",
    r4.explanationofbenefit_decoder(),
    client,
    handle_response,
  )
}

pub fn explanationofbenefit_delete(
  resource: r4.Explanationofbenefit,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ExplanationOfBenefit", client, handle_response)
}

pub fn explanationofbenefit_search_bundled(
  search_for search_args: r4_sansio.SpExplanationofbenefit,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.explanationofbenefit_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn explanationofbenefit_search(
  search_for search_args: r4_sansio.SpExplanationofbenefit,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Explanationofbenefit), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.explanationofbenefit_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.explanationofbenefit
    },
  )
}

pub fn familymemberhistory_create(
  resource: r4.Familymemberhistory,
  client: FhirClient,
  handle_response: fn(Result(r4.Familymemberhistory, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    r4.familymemberhistory_decoder(),
    client,
    handle_response,
  )
}

pub fn familymemberhistory_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Familymemberhistory, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "FamilyMemberHistory",
    r4.familymemberhistory_decoder(),
    client,
    handle_response,
  )
}

pub fn familymemberhistory_update(
  resource: r4.Familymemberhistory,
  client: FhirClient,
  handle_response: fn(Result(r4.Familymemberhistory, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    r4.familymemberhistory_decoder(),
    client,
    handle_response,
  )
}

pub fn familymemberhistory_delete(
  resource: r4.Familymemberhistory,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "FamilyMemberHistory", client, handle_response)
}

pub fn familymemberhistory_search_bundled(
  search_for search_args: r4_sansio.SpFamilymemberhistory,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.familymemberhistory_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn familymemberhistory_search(
  search_for search_args: r4_sansio.SpFamilymemberhistory,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Familymemberhistory), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.familymemberhistory_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.familymemberhistory
    },
  )
}

pub fn flag_create(
  resource: r4.Flag,
  client: FhirClient,
  handle_response: fn(Result(r4.Flag, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.flag_to_json(resource),
    "Flag",
    r4.flag_decoder(),
    client,
    handle_response,
  )
}

pub fn flag_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Flag, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Flag", r4.flag_decoder(), client, handle_response)
}

pub fn flag_update(
  resource: r4.Flag,
  client: FhirClient,
  handle_response: fn(Result(r4.Flag, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.flag_to_json(resource),
    "Flag",
    r4.flag_decoder(),
    client,
    handle_response,
  )
}

pub fn flag_delete(
  resource: r4.Flag,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Flag", client, handle_response)
}

pub fn flag_search_bundled(
  search_for search_args: r4_sansio.SpFlag,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.flag_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn flag_search(
  search_for search_args: r4_sansio.SpFlag,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Flag), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.flag_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.flag },
  )
}

pub fn goal_create(
  resource: r4.Goal,
  client: FhirClient,
  handle_response: fn(Result(r4.Goal, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.goal_to_json(resource),
    "Goal",
    r4.goal_decoder(),
    client,
    handle_response,
  )
}

pub fn goal_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Goal, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Goal", r4.goal_decoder(), client, handle_response)
}

pub fn goal_update(
  resource: r4.Goal,
  client: FhirClient,
  handle_response: fn(Result(r4.Goal, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.goal_to_json(resource),
    "Goal",
    r4.goal_decoder(),
    client,
    handle_response,
  )
}

pub fn goal_delete(
  resource: r4.Goal,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Goal", client, handle_response)
}

pub fn goal_search_bundled(
  search_for search_args: r4_sansio.SpGoal,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.goal_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn goal_search(
  search_for search_args: r4_sansio.SpGoal,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Goal), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.goal_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.goal },
  )
}

pub fn graphdefinition_create(
  resource: r4.Graphdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Graphdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.graphdefinition_to_json(resource),
    "GraphDefinition",
    r4.graphdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn graphdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Graphdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "GraphDefinition",
    r4.graphdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn graphdefinition_update(
  resource: r4.Graphdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Graphdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.graphdefinition_to_json(resource),
    "GraphDefinition",
    r4.graphdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn graphdefinition_delete(
  resource: r4.Graphdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "GraphDefinition", client, handle_response)
}

pub fn graphdefinition_search_bundled(
  search_for search_args: r4_sansio.SpGraphdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.graphdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn graphdefinition_search(
  search_for search_args: r4_sansio.SpGraphdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Graphdefinition), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.graphdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.graphdefinition
    },
  )
}

pub fn group_create(
  resource: r4.Group,
  client: FhirClient,
  handle_response: fn(Result(r4.Group, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.group_to_json(resource),
    "Group",
    r4.group_decoder(),
    client,
    handle_response,
  )
}

pub fn group_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Group, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Group", r4.group_decoder(), client, handle_response)
}

pub fn group_update(
  resource: r4.Group,
  client: FhirClient,
  handle_response: fn(Result(r4.Group, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.group_to_json(resource),
    "Group",
    r4.group_decoder(),
    client,
    handle_response,
  )
}

pub fn group_delete(
  resource: r4.Group,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Group", client, handle_response)
}

pub fn group_search_bundled(
  search_for search_args: r4_sansio.SpGroup,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.group_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn group_search(
  search_for search_args: r4_sansio.SpGroup,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Group), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.group_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.group },
  )
}

pub fn guidanceresponse_create(
  resource: r4.Guidanceresponse,
  client: FhirClient,
  handle_response: fn(Result(r4.Guidanceresponse, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.guidanceresponse_to_json(resource),
    "GuidanceResponse",
    r4.guidanceresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn guidanceresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Guidanceresponse, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "GuidanceResponse",
    r4.guidanceresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn guidanceresponse_update(
  resource: r4.Guidanceresponse,
  client: FhirClient,
  handle_response: fn(Result(r4.Guidanceresponse, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.guidanceresponse_to_json(resource),
    "GuidanceResponse",
    r4.guidanceresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn guidanceresponse_delete(
  resource: r4.Guidanceresponse,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "GuidanceResponse", client, handle_response)
}

pub fn guidanceresponse_search_bundled(
  search_for search_args: r4_sansio.SpGuidanceresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.guidanceresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn guidanceresponse_search(
  search_for search_args: r4_sansio.SpGuidanceresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Guidanceresponse), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.guidanceresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.guidanceresponse
    },
  )
}

pub fn healthcareservice_create(
  resource: r4.Healthcareservice,
  client: FhirClient,
  handle_response: fn(Result(r4.Healthcareservice, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.healthcareservice_to_json(resource),
    "HealthcareService",
    r4.healthcareservice_decoder(),
    client,
    handle_response,
  )
}

pub fn healthcareservice_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Healthcareservice, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "HealthcareService",
    r4.healthcareservice_decoder(),
    client,
    handle_response,
  )
}

pub fn healthcareservice_update(
  resource: r4.Healthcareservice,
  client: FhirClient,
  handle_response: fn(Result(r4.Healthcareservice, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.healthcareservice_to_json(resource),
    "HealthcareService",
    r4.healthcareservice_decoder(),
    client,
    handle_response,
  )
}

pub fn healthcareservice_delete(
  resource: r4.Healthcareservice,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "HealthcareService", client, handle_response)
}

pub fn healthcareservice_search_bundled(
  search_for search_args: r4_sansio.SpHealthcareservice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.healthcareservice_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn healthcareservice_search(
  search_for search_args: r4_sansio.SpHealthcareservice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Healthcareservice), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.healthcareservice_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.healthcareservice
    },
  )
}

pub fn imagingstudy_create(
  resource: r4.Imagingstudy,
  client: FhirClient,
  handle_response: fn(Result(r4.Imagingstudy, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.imagingstudy_to_json(resource),
    "ImagingStudy",
    r4.imagingstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn imagingstudy_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Imagingstudy, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ImagingStudy",
    r4.imagingstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn imagingstudy_update(
  resource: r4.Imagingstudy,
  client: FhirClient,
  handle_response: fn(Result(r4.Imagingstudy, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.imagingstudy_to_json(resource),
    "ImagingStudy",
    r4.imagingstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn imagingstudy_delete(
  resource: r4.Imagingstudy,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ImagingStudy", client, handle_response)
}

pub fn imagingstudy_search_bundled(
  search_for search_args: r4_sansio.SpImagingstudy,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.imagingstudy_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn imagingstudy_search(
  search_for search_args: r4_sansio.SpImagingstudy,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Imagingstudy), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.imagingstudy_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.imagingstudy
    },
  )
}

pub fn immunization_create(
  resource: r4.Immunization,
  client: FhirClient,
  handle_response: fn(Result(r4.Immunization, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.immunization_to_json(resource),
    "Immunization",
    r4.immunization_decoder(),
    client,
    handle_response,
  )
}

pub fn immunization_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Immunization, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Immunization",
    r4.immunization_decoder(),
    client,
    handle_response,
  )
}

pub fn immunization_update(
  resource: r4.Immunization,
  client: FhirClient,
  handle_response: fn(Result(r4.Immunization, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.immunization_to_json(resource),
    "Immunization",
    r4.immunization_decoder(),
    client,
    handle_response,
  )
}

pub fn immunization_delete(
  resource: r4.Immunization,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Immunization", client, handle_response)
}

pub fn immunization_search_bundled(
  search_for search_args: r4_sansio.SpImmunization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.immunization_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn immunization_search(
  search_for search_args: r4_sansio.SpImmunization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Immunization), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.immunization_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.immunization
    },
  )
}

pub fn immunizationevaluation_create(
  resource: r4.Immunizationevaluation,
  client: FhirClient,
  handle_response: fn(Result(r4.Immunizationevaluation, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.immunizationevaluation_to_json(resource),
    "ImmunizationEvaluation",
    r4.immunizationevaluation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationevaluation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Immunizationevaluation, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ImmunizationEvaluation",
    r4.immunizationevaluation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationevaluation_update(
  resource: r4.Immunizationevaluation,
  client: FhirClient,
  handle_response: fn(Result(r4.Immunizationevaluation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.immunizationevaluation_to_json(resource),
    "ImmunizationEvaluation",
    r4.immunizationevaluation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationevaluation_delete(
  resource: r4.Immunizationevaluation,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ImmunizationEvaluation", client, handle_response)
}

pub fn immunizationevaluation_search_bundled(
  search_for search_args: r4_sansio.SpImmunizationevaluation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.immunizationevaluation_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn immunizationevaluation_search(
  search_for search_args: r4_sansio.SpImmunizationevaluation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Immunizationevaluation), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.immunizationevaluation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.immunizationevaluation
    },
  )
}

pub fn immunizationrecommendation_create(
  resource: r4.Immunizationrecommendation,
  client: FhirClient,
  handle_response: fn(Result(r4.Immunizationrecommendation, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.immunizationrecommendation_to_json(resource),
    "ImmunizationRecommendation",
    r4.immunizationrecommendation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationrecommendation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Immunizationrecommendation, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ImmunizationRecommendation",
    r4.immunizationrecommendation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationrecommendation_update(
  resource: r4.Immunizationrecommendation,
  client: FhirClient,
  handle_response: fn(Result(r4.Immunizationrecommendation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.immunizationrecommendation_to_json(resource),
    "ImmunizationRecommendation",
    r4.immunizationrecommendation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationrecommendation_delete(
  resource: r4.Immunizationrecommendation,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ImmunizationRecommendation", client, handle_response)
}

pub fn immunizationrecommendation_search_bundled(
  search_for search_args: r4_sansio.SpImmunizationrecommendation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.immunizationrecommendation_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn immunizationrecommendation_search(
  search_for search_args: r4_sansio.SpImmunizationrecommendation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4.Immunizationrecommendation), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.immunizationrecommendation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.immunizationrecommendation
    },
  )
}

pub fn implementationguide_create(
  resource: r4.Implementationguide,
  client: FhirClient,
  handle_response: fn(Result(r4.Implementationguide, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.implementationguide_to_json(resource),
    "ImplementationGuide",
    r4.implementationguide_decoder(),
    client,
    handle_response,
  )
}

pub fn implementationguide_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Implementationguide, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ImplementationGuide",
    r4.implementationguide_decoder(),
    client,
    handle_response,
  )
}

pub fn implementationguide_update(
  resource: r4.Implementationguide,
  client: FhirClient,
  handle_response: fn(Result(r4.Implementationguide, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.implementationguide_to_json(resource),
    "ImplementationGuide",
    r4.implementationguide_decoder(),
    client,
    handle_response,
  )
}

pub fn implementationguide_delete(
  resource: r4.Implementationguide,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ImplementationGuide", client, handle_response)
}

pub fn implementationguide_search_bundled(
  search_for search_args: r4_sansio.SpImplementationguide,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.implementationguide_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn implementationguide_search(
  search_for search_args: r4_sansio.SpImplementationguide,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Implementationguide), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.implementationguide_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.implementationguide
    },
  )
}

pub fn insuranceplan_create(
  resource: r4.Insuranceplan,
  client: FhirClient,
  handle_response: fn(Result(r4.Insuranceplan, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.insuranceplan_to_json(resource),
    "InsurancePlan",
    r4.insuranceplan_decoder(),
    client,
    handle_response,
  )
}

pub fn insuranceplan_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Insuranceplan, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "InsurancePlan",
    r4.insuranceplan_decoder(),
    client,
    handle_response,
  )
}

pub fn insuranceplan_update(
  resource: r4.Insuranceplan,
  client: FhirClient,
  handle_response: fn(Result(r4.Insuranceplan, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.insuranceplan_to_json(resource),
    "InsurancePlan",
    r4.insuranceplan_decoder(),
    client,
    handle_response,
  )
}

pub fn insuranceplan_delete(
  resource: r4.Insuranceplan,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "InsurancePlan", client, handle_response)
}

pub fn insuranceplan_search_bundled(
  search_for search_args: r4_sansio.SpInsuranceplan,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.insuranceplan_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn insuranceplan_search(
  search_for search_args: r4_sansio.SpInsuranceplan,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Insuranceplan), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.insuranceplan_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.insuranceplan
    },
  )
}

pub fn invoice_create(
  resource: r4.Invoice,
  client: FhirClient,
  handle_response: fn(Result(r4.Invoice, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.invoice_to_json(resource),
    "Invoice",
    r4.invoice_decoder(),
    client,
    handle_response,
  )
}

pub fn invoice_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Invoice, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Invoice", r4.invoice_decoder(), client, handle_response)
}

pub fn invoice_update(
  resource: r4.Invoice,
  client: FhirClient,
  handle_response: fn(Result(r4.Invoice, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.invoice_to_json(resource),
    "Invoice",
    r4.invoice_decoder(),
    client,
    handle_response,
  )
}

pub fn invoice_delete(
  resource: r4.Invoice,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Invoice", client, handle_response)
}

pub fn invoice_search_bundled(
  search_for search_args: r4_sansio.SpInvoice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.invoice_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn invoice_search(
  search_for search_args: r4_sansio.SpInvoice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Invoice), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.invoice_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.invoice },
  )
}

pub fn library_create(
  resource: r4.Library,
  client: FhirClient,
  handle_response: fn(Result(r4.Library, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.library_to_json(resource),
    "Library",
    r4.library_decoder(),
    client,
    handle_response,
  )
}

pub fn library_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Library, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Library", r4.library_decoder(), client, handle_response)
}

pub fn library_update(
  resource: r4.Library,
  client: FhirClient,
  handle_response: fn(Result(r4.Library, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.library_to_json(resource),
    "Library",
    r4.library_decoder(),
    client,
    handle_response,
  )
}

pub fn library_delete(
  resource: r4.Library,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Library", client, handle_response)
}

pub fn library_search_bundled(
  search_for search_args: r4_sansio.SpLibrary,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.library_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn library_search(
  search_for search_args: r4_sansio.SpLibrary,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Library), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.library_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.library },
  )
}

pub fn linkage_create(
  resource: r4.Linkage,
  client: FhirClient,
  handle_response: fn(Result(r4.Linkage, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.linkage_to_json(resource),
    "Linkage",
    r4.linkage_decoder(),
    client,
    handle_response,
  )
}

pub fn linkage_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Linkage, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Linkage", r4.linkage_decoder(), client, handle_response)
}

pub fn linkage_update(
  resource: r4.Linkage,
  client: FhirClient,
  handle_response: fn(Result(r4.Linkage, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.linkage_to_json(resource),
    "Linkage",
    r4.linkage_decoder(),
    client,
    handle_response,
  )
}

pub fn linkage_delete(
  resource: r4.Linkage,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Linkage", client, handle_response)
}

pub fn linkage_search_bundled(
  search_for search_args: r4_sansio.SpLinkage,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.linkage_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn linkage_search(
  search_for search_args: r4_sansio.SpLinkage,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Linkage), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.linkage_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.linkage },
  )
}

pub fn listfhir_create(
  resource: r4.Listfhir,
  client: FhirClient,
  handle_response: fn(Result(r4.Listfhir, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.listfhir_to_json(resource),
    "List",
    r4.listfhir_decoder(),
    client,
    handle_response,
  )
}

pub fn listfhir_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Listfhir, Err)) -> a,
) -> Effect(a) {
  any_read(id, "List", r4.listfhir_decoder(), client, handle_response)
}

pub fn listfhir_update(
  resource: r4.Listfhir,
  client: FhirClient,
  handle_response: fn(Result(r4.Listfhir, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.listfhir_to_json(resource),
    "List",
    r4.listfhir_decoder(),
    client,
    handle_response,
  )
}

pub fn listfhir_delete(
  resource: r4.Listfhir,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "List", client, handle_response)
}

pub fn listfhir_search_bundled(
  search_for search_args: r4_sansio.SpListfhir,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.listfhir_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn listfhir_search(
  search_for search_args: r4_sansio.SpListfhir,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Listfhir), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.listfhir_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.listfhir },
  )
}

pub fn location_create(
  resource: r4.Location,
  client: FhirClient,
  handle_response: fn(Result(r4.Location, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.location_to_json(resource),
    "Location",
    r4.location_decoder(),
    client,
    handle_response,
  )
}

pub fn location_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Location, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Location", r4.location_decoder(), client, handle_response)
}

pub fn location_update(
  resource: r4.Location,
  client: FhirClient,
  handle_response: fn(Result(r4.Location, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.location_to_json(resource),
    "Location",
    r4.location_decoder(),
    client,
    handle_response,
  )
}

pub fn location_delete(
  resource: r4.Location,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Location", client, handle_response)
}

pub fn location_search_bundled(
  search_for search_args: r4_sansio.SpLocation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.location_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn location_search(
  search_for search_args: r4_sansio.SpLocation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Location), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.location_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.location },
  )
}

pub fn measure_create(
  resource: r4.Measure,
  client: FhirClient,
  handle_response: fn(Result(r4.Measure, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.measure_to_json(resource),
    "Measure",
    r4.measure_decoder(),
    client,
    handle_response,
  )
}

pub fn measure_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Measure, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Measure", r4.measure_decoder(), client, handle_response)
}

pub fn measure_update(
  resource: r4.Measure,
  client: FhirClient,
  handle_response: fn(Result(r4.Measure, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.measure_to_json(resource),
    "Measure",
    r4.measure_decoder(),
    client,
    handle_response,
  )
}

pub fn measure_delete(
  resource: r4.Measure,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Measure", client, handle_response)
}

pub fn measure_search_bundled(
  search_for search_args: r4_sansio.SpMeasure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.measure_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn measure_search(
  search_for search_args: r4_sansio.SpMeasure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Measure), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.measure_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.measure },
  )
}

pub fn measurereport_create(
  resource: r4.Measurereport,
  client: FhirClient,
  handle_response: fn(Result(r4.Measurereport, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.measurereport_to_json(resource),
    "MeasureReport",
    r4.measurereport_decoder(),
    client,
    handle_response,
  )
}

pub fn measurereport_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Measurereport, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MeasureReport",
    r4.measurereport_decoder(),
    client,
    handle_response,
  )
}

pub fn measurereport_update(
  resource: r4.Measurereport,
  client: FhirClient,
  handle_response: fn(Result(r4.Measurereport, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.measurereport_to_json(resource),
    "MeasureReport",
    r4.measurereport_decoder(),
    client,
    handle_response,
  )
}

pub fn measurereport_delete(
  resource: r4.Measurereport,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MeasureReport", client, handle_response)
}

pub fn measurereport_search_bundled(
  search_for search_args: r4_sansio.SpMeasurereport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.measurereport_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn measurereport_search(
  search_for search_args: r4_sansio.SpMeasurereport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Measurereport), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.measurereport_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.measurereport
    },
  )
}

pub fn media_create(
  resource: r4.Media,
  client: FhirClient,
  handle_response: fn(Result(r4.Media, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.media_to_json(resource),
    "Media",
    r4.media_decoder(),
    client,
    handle_response,
  )
}

pub fn media_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Media, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Media", r4.media_decoder(), client, handle_response)
}

pub fn media_update(
  resource: r4.Media,
  client: FhirClient,
  handle_response: fn(Result(r4.Media, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.media_to_json(resource),
    "Media",
    r4.media_decoder(),
    client,
    handle_response,
  )
}

pub fn media_delete(
  resource: r4.Media,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Media", client, handle_response)
}

pub fn media_search_bundled(
  search_for search_args: r4_sansio.SpMedia,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.media_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn media_search(
  search_for search_args: r4_sansio.SpMedia,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Media), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.media_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.media },
  )
}

pub fn medication_create(
  resource: r4.Medication,
  client: FhirClient,
  handle_response: fn(Result(r4.Medication, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.medication_to_json(resource),
    "Medication",
    r4.medication_decoder(),
    client,
    handle_response,
  )
}

pub fn medication_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Medication, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Medication", r4.medication_decoder(), client, handle_response)
}

pub fn medication_update(
  resource: r4.Medication,
  client: FhirClient,
  handle_response: fn(Result(r4.Medication, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.medication_to_json(resource),
    "Medication",
    r4.medication_decoder(),
    client,
    handle_response,
  )
}

pub fn medication_delete(
  resource: r4.Medication,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Medication", client, handle_response)
}

pub fn medication_search_bundled(
  search_for search_args: r4_sansio.SpMedication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.medication_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn medication_search(
  search_for search_args: r4_sansio.SpMedication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Medication), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.medication_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.medication },
  )
}

pub fn medicationadministration_create(
  resource: r4.Medicationadministration,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicationadministration, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.medicationadministration_to_json(resource),
    "MedicationAdministration",
    r4.medicationadministration_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationadministration_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicationadministration, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationAdministration",
    r4.medicationadministration_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationadministration_update(
  resource: r4.Medicationadministration,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicationadministration, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.medicationadministration_to_json(resource),
    "MedicationAdministration",
    r4.medicationadministration_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationadministration_delete(
  resource: r4.Medicationadministration,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicationAdministration", client, handle_response)
}

pub fn medicationadministration_search_bundled(
  search_for search_args: r4_sansio.SpMedicationadministration,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.medicationadministration_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn medicationadministration_search(
  search_for search_args: r4_sansio.SpMedicationadministration,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4.Medicationadministration), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.medicationadministration_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.medicationadministration
    },
  )
}

pub fn medicationdispense_create(
  resource: r4.Medicationdispense,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicationdispense, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.medicationdispense_to_json(resource),
    "MedicationDispense",
    r4.medicationdispense_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationdispense_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicationdispense, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationDispense",
    r4.medicationdispense_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationdispense_update(
  resource: r4.Medicationdispense,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicationdispense, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.medicationdispense_to_json(resource),
    "MedicationDispense",
    r4.medicationdispense_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationdispense_delete(
  resource: r4.Medicationdispense,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicationDispense", client, handle_response)
}

pub fn medicationdispense_search_bundled(
  search_for search_args: r4_sansio.SpMedicationdispense,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.medicationdispense_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn medicationdispense_search(
  search_for search_args: r4_sansio.SpMedicationdispense,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Medicationdispense), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.medicationdispense_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.medicationdispense
    },
  )
}

pub fn medicationknowledge_create(
  resource: r4.Medicationknowledge,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicationknowledge, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.medicationknowledge_to_json(resource),
    "MedicationKnowledge",
    r4.medicationknowledge_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationknowledge_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicationknowledge, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationKnowledge",
    r4.medicationknowledge_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationknowledge_update(
  resource: r4.Medicationknowledge,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicationknowledge, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.medicationknowledge_to_json(resource),
    "MedicationKnowledge",
    r4.medicationknowledge_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationknowledge_delete(
  resource: r4.Medicationknowledge,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicationKnowledge", client, handle_response)
}

pub fn medicationknowledge_search_bundled(
  search_for search_args: r4_sansio.SpMedicationknowledge,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.medicationknowledge_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn medicationknowledge_search(
  search_for search_args: r4_sansio.SpMedicationknowledge,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Medicationknowledge), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.medicationknowledge_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.medicationknowledge
    },
  )
}

pub fn medicationrequest_create(
  resource: r4.Medicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicationrequest, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.medicationrequest_to_json(resource),
    "MedicationRequest",
    r4.medicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicationrequest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationRequest",
    r4.medicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationrequest_update(
  resource: r4.Medicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicationrequest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.medicationrequest_to_json(resource),
    "MedicationRequest",
    r4.medicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationrequest_delete(
  resource: r4.Medicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicationRequest", client, handle_response)
}

pub fn medicationrequest_search_bundled(
  search_for search_args: r4_sansio.SpMedicationrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.medicationrequest_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn medicationrequest_search(
  search_for search_args: r4_sansio.SpMedicationrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Medicationrequest), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.medicationrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.medicationrequest
    },
  )
}

pub fn medicationstatement_create(
  resource: r4.Medicationstatement,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicationstatement, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.medicationstatement_to_json(resource),
    "MedicationStatement",
    r4.medicationstatement_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationstatement_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicationstatement, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationStatement",
    r4.medicationstatement_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationstatement_update(
  resource: r4.Medicationstatement,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicationstatement, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.medicationstatement_to_json(resource),
    "MedicationStatement",
    r4.medicationstatement_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationstatement_delete(
  resource: r4.Medicationstatement,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicationStatement", client, handle_response)
}

pub fn medicationstatement_search_bundled(
  search_for search_args: r4_sansio.SpMedicationstatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.medicationstatement_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn medicationstatement_search(
  search_for search_args: r4_sansio.SpMedicationstatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Medicationstatement), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.medicationstatement_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.medicationstatement
    },
  )
}

pub fn medicinalproduct_create(
  resource: r4.Medicinalproduct,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproduct, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.medicinalproduct_to_json(resource),
    "MedicinalProduct",
    r4.medicinalproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproduct_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproduct, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProduct",
    r4.medicinalproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproduct_update(
  resource: r4.Medicinalproduct,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproduct, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.medicinalproduct_to_json(resource),
    "MedicinalProduct",
    r4.medicinalproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproduct_delete(
  resource: r4.Medicinalproduct,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicinalProduct", client, handle_response)
}

pub fn medicinalproduct_search_bundled(
  search_for search_args: r4_sansio.SpMedicinalproduct,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.medicinalproduct_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn medicinalproduct_search(
  search_for search_args: r4_sansio.SpMedicinalproduct,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Medicinalproduct), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.medicinalproduct_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.medicinalproduct
    },
  )
}

pub fn medicinalproductauthorization_create(
  resource: r4.Medicinalproductauthorization,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproductauthorization, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.medicinalproductauthorization_to_json(resource),
    "MedicinalProductAuthorization",
    r4.medicinalproductauthorization_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductauthorization_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproductauthorization, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductAuthorization",
    r4.medicinalproductauthorization_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductauthorization_update(
  resource: r4.Medicinalproductauthorization,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproductauthorization, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.medicinalproductauthorization_to_json(resource),
    "MedicinalProductAuthorization",
    r4.medicinalproductauthorization_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductauthorization_delete(
  resource: r4.Medicinalproductauthorization,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(
    resource.id,
    "MedicinalProductAuthorization",
    client,
    handle_response,
  )
}

pub fn medicinalproductauthorization_search_bundled(
  search_for search_args: r4_sansio.SpMedicinalproductauthorization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4_sansio.medicinalproductauthorization_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn medicinalproductauthorization_search(
  search_for search_args: r4_sansio.SpMedicinalproductauthorization,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4.Medicinalproductauthorization), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4_sansio.medicinalproductauthorization_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.medicinalproductauthorization
    },
  )
}

pub fn medicinalproductcontraindication_create(
  resource: r4.Medicinalproductcontraindication,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproductcontraindication, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.medicinalproductcontraindication_to_json(resource),
    "MedicinalProductContraindication",
    r4.medicinalproductcontraindication_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductcontraindication_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproductcontraindication, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductContraindication",
    r4.medicinalproductcontraindication_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductcontraindication_update(
  resource: r4.Medicinalproductcontraindication,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproductcontraindication, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.medicinalproductcontraindication_to_json(resource),
    "MedicinalProductContraindication",
    r4.medicinalproductcontraindication_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductcontraindication_delete(
  resource: r4.Medicinalproductcontraindication,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(
    resource.id,
    "MedicinalProductContraindication",
    client,
    handle_response,
  )
}

pub fn medicinalproductcontraindication_search_bundled(
  search_for search_args: r4_sansio.SpMedicinalproductcontraindication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4_sansio.medicinalproductcontraindication_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn medicinalproductcontraindication_search(
  search_for search_args: r4_sansio.SpMedicinalproductcontraindication,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4.Medicinalproductcontraindication), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4_sansio.medicinalproductcontraindication_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.medicinalproductcontraindication
    },
  )
}

pub fn medicinalproductindication_create(
  resource: r4.Medicinalproductindication,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproductindication, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.medicinalproductindication_to_json(resource),
    "MedicinalProductIndication",
    r4.medicinalproductindication_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductindication_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproductindication, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductIndication",
    r4.medicinalproductindication_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductindication_update(
  resource: r4.Medicinalproductindication,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproductindication, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.medicinalproductindication_to_json(resource),
    "MedicinalProductIndication",
    r4.medicinalproductindication_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductindication_delete(
  resource: r4.Medicinalproductindication,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicinalProductIndication", client, handle_response)
}

pub fn medicinalproductindication_search_bundled(
  search_for search_args: r4_sansio.SpMedicinalproductindication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.medicinalproductindication_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn medicinalproductindication_search(
  search_for search_args: r4_sansio.SpMedicinalproductindication,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4.Medicinalproductindication), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.medicinalproductindication_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.medicinalproductindication
    },
  )
}

pub fn medicinalproductingredient_create(
  resource: r4.Medicinalproductingredient,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproductingredient, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.medicinalproductingredient_to_json(resource),
    "MedicinalProductIngredient",
    r4.medicinalproductingredient_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductingredient_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproductingredient, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductIngredient",
    r4.medicinalproductingredient_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductingredient_update(
  resource: r4.Medicinalproductingredient,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproductingredient, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.medicinalproductingredient_to_json(resource),
    "MedicinalProductIngredient",
    r4.medicinalproductingredient_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductingredient_delete(
  resource: r4.Medicinalproductingredient,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicinalProductIngredient", client, handle_response)
}

pub fn medicinalproductingredient_search_bundled(
  search_for search_args: r4_sansio.SpMedicinalproductingredient,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.medicinalproductingredient_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn medicinalproductingredient_search(
  search_for search_args: r4_sansio.SpMedicinalproductingredient,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4.Medicinalproductingredient), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.medicinalproductingredient_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.medicinalproductingredient
    },
  )
}

pub fn medicinalproductinteraction_create(
  resource: r4.Medicinalproductinteraction,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproductinteraction, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.medicinalproductinteraction_to_json(resource),
    "MedicinalProductInteraction",
    r4.medicinalproductinteraction_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductinteraction_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproductinteraction, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductInteraction",
    r4.medicinalproductinteraction_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductinteraction_update(
  resource: r4.Medicinalproductinteraction,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproductinteraction, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.medicinalproductinteraction_to_json(resource),
    "MedicinalProductInteraction",
    r4.medicinalproductinteraction_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductinteraction_delete(
  resource: r4.Medicinalproductinteraction,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(
    resource.id,
    "MedicinalProductInteraction",
    client,
    handle_response,
  )
}

pub fn medicinalproductinteraction_search_bundled(
  search_for search_args: r4_sansio.SpMedicinalproductinteraction,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4_sansio.medicinalproductinteraction_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn medicinalproductinteraction_search(
  search_for search_args: r4_sansio.SpMedicinalproductinteraction,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4.Medicinalproductinteraction), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4_sansio.medicinalproductinteraction_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.medicinalproductinteraction
    },
  )
}

pub fn medicinalproductmanufactured_create(
  resource: r4.Medicinalproductmanufactured,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproductmanufactured, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.medicinalproductmanufactured_to_json(resource),
    "MedicinalProductManufactured",
    r4.medicinalproductmanufactured_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductmanufactured_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproductmanufactured, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductManufactured",
    r4.medicinalproductmanufactured_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductmanufactured_update(
  resource: r4.Medicinalproductmanufactured,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproductmanufactured, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.medicinalproductmanufactured_to_json(resource),
    "MedicinalProductManufactured",
    r4.medicinalproductmanufactured_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductmanufactured_delete(
  resource: r4.Medicinalproductmanufactured,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(
    resource.id,
    "MedicinalProductManufactured",
    client,
    handle_response,
  )
}

pub fn medicinalproductmanufactured_search_bundled(
  search_for search_args: r4_sansio.SpMedicinalproductmanufactured,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4_sansio.medicinalproductmanufactured_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn medicinalproductmanufactured_search(
  search_for search_args: r4_sansio.SpMedicinalproductmanufactured,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4.Medicinalproductmanufactured), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4_sansio.medicinalproductmanufactured_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.medicinalproductmanufactured
    },
  )
}

pub fn medicinalproductpackaged_create(
  resource: r4.Medicinalproductpackaged,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproductpackaged, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.medicinalproductpackaged_to_json(resource),
    "MedicinalProductPackaged",
    r4.medicinalproductpackaged_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductpackaged_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproductpackaged, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductPackaged",
    r4.medicinalproductpackaged_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductpackaged_update(
  resource: r4.Medicinalproductpackaged,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproductpackaged, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.medicinalproductpackaged_to_json(resource),
    "MedicinalProductPackaged",
    r4.medicinalproductpackaged_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductpackaged_delete(
  resource: r4.Medicinalproductpackaged,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicinalProductPackaged", client, handle_response)
}

pub fn medicinalproductpackaged_search_bundled(
  search_for search_args: r4_sansio.SpMedicinalproductpackaged,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.medicinalproductpackaged_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn medicinalproductpackaged_search(
  search_for search_args: r4_sansio.SpMedicinalproductpackaged,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4.Medicinalproductpackaged), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.medicinalproductpackaged_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.medicinalproductpackaged
    },
  )
}

pub fn medicinalproductpharmaceutical_create(
  resource: r4.Medicinalproductpharmaceutical,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproductpharmaceutical, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.medicinalproductpharmaceutical_to_json(resource),
    "MedicinalProductPharmaceutical",
    r4.medicinalproductpharmaceutical_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductpharmaceutical_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproductpharmaceutical, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductPharmaceutical",
    r4.medicinalproductpharmaceutical_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductpharmaceutical_update(
  resource: r4.Medicinalproductpharmaceutical,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproductpharmaceutical, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.medicinalproductpharmaceutical_to_json(resource),
    "MedicinalProductPharmaceutical",
    r4.medicinalproductpharmaceutical_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductpharmaceutical_delete(
  resource: r4.Medicinalproductpharmaceutical,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(
    resource.id,
    "MedicinalProductPharmaceutical",
    client,
    handle_response,
  )
}

pub fn medicinalproductpharmaceutical_search_bundled(
  search_for search_args: r4_sansio.SpMedicinalproductpharmaceutical,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4_sansio.medicinalproductpharmaceutical_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn medicinalproductpharmaceutical_search(
  search_for search_args: r4_sansio.SpMedicinalproductpharmaceutical,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4.Medicinalproductpharmaceutical), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4_sansio.medicinalproductpharmaceutical_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.medicinalproductpharmaceutical
    },
  )
}

pub fn medicinalproductundesirableeffect_create(
  resource: r4.Medicinalproductundesirableeffect,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproductundesirableeffect, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.medicinalproductundesirableeffect_to_json(resource),
    "MedicinalProductUndesirableEffect",
    r4.medicinalproductundesirableeffect_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductundesirableeffect_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproductundesirableeffect, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductUndesirableEffect",
    r4.medicinalproductundesirableeffect_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductundesirableeffect_update(
  resource: r4.Medicinalproductundesirableeffect,
  client: FhirClient,
  handle_response: fn(Result(r4.Medicinalproductundesirableeffect, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.medicinalproductundesirableeffect_to_json(resource),
    "MedicinalProductUndesirableEffect",
    r4.medicinalproductundesirableeffect_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductundesirableeffect_delete(
  resource: r4.Medicinalproductundesirableeffect,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(
    resource.id,
    "MedicinalProductUndesirableEffect",
    client,
    handle_response,
  )
}

pub fn medicinalproductundesirableeffect_search_bundled(
  search_for search_args: r4_sansio.SpMedicinalproductundesirableeffect,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4_sansio.medicinalproductundesirableeffect_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn medicinalproductundesirableeffect_search(
  search_for search_args: r4_sansio.SpMedicinalproductundesirableeffect,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4.Medicinalproductundesirableeffect), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4_sansio.medicinalproductundesirableeffect_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.medicinalproductundesirableeffect
    },
  )
}

pub fn messagedefinition_create(
  resource: r4.Messagedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Messagedefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.messagedefinition_to_json(resource),
    "MessageDefinition",
    r4.messagedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn messagedefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Messagedefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MessageDefinition",
    r4.messagedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn messagedefinition_update(
  resource: r4.Messagedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Messagedefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.messagedefinition_to_json(resource),
    "MessageDefinition",
    r4.messagedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn messagedefinition_delete(
  resource: r4.Messagedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MessageDefinition", client, handle_response)
}

pub fn messagedefinition_search_bundled(
  search_for search_args: r4_sansio.SpMessagedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.messagedefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn messagedefinition_search(
  search_for search_args: r4_sansio.SpMessagedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Messagedefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.messagedefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.messagedefinition
    },
  )
}

pub fn messageheader_create(
  resource: r4.Messageheader,
  client: FhirClient,
  handle_response: fn(Result(r4.Messageheader, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.messageheader_to_json(resource),
    "MessageHeader",
    r4.messageheader_decoder(),
    client,
    handle_response,
  )
}

pub fn messageheader_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Messageheader, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MessageHeader",
    r4.messageheader_decoder(),
    client,
    handle_response,
  )
}

pub fn messageheader_update(
  resource: r4.Messageheader,
  client: FhirClient,
  handle_response: fn(Result(r4.Messageheader, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.messageheader_to_json(resource),
    "MessageHeader",
    r4.messageheader_decoder(),
    client,
    handle_response,
  )
}

pub fn messageheader_delete(
  resource: r4.Messageheader,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MessageHeader", client, handle_response)
}

pub fn messageheader_search_bundled(
  search_for search_args: r4_sansio.SpMessageheader,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.messageheader_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn messageheader_search(
  search_for search_args: r4_sansio.SpMessageheader,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Messageheader), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.messageheader_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.messageheader
    },
  )
}

pub fn molecularsequence_create(
  resource: r4.Molecularsequence,
  client: FhirClient,
  handle_response: fn(Result(r4.Molecularsequence, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.molecularsequence_to_json(resource),
    "MolecularSequence",
    r4.molecularsequence_decoder(),
    client,
    handle_response,
  )
}

pub fn molecularsequence_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Molecularsequence, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MolecularSequence",
    r4.molecularsequence_decoder(),
    client,
    handle_response,
  )
}

pub fn molecularsequence_update(
  resource: r4.Molecularsequence,
  client: FhirClient,
  handle_response: fn(Result(r4.Molecularsequence, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.molecularsequence_to_json(resource),
    "MolecularSequence",
    r4.molecularsequence_decoder(),
    client,
    handle_response,
  )
}

pub fn molecularsequence_delete(
  resource: r4.Molecularsequence,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MolecularSequence", client, handle_response)
}

pub fn molecularsequence_search_bundled(
  search_for search_args: r4_sansio.SpMolecularsequence,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.molecularsequence_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn molecularsequence_search(
  search_for search_args: r4_sansio.SpMolecularsequence,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Molecularsequence), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.molecularsequence_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.molecularsequence
    },
  )
}

pub fn namingsystem_create(
  resource: r4.Namingsystem,
  client: FhirClient,
  handle_response: fn(Result(r4.Namingsystem, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.namingsystem_to_json(resource),
    "NamingSystem",
    r4.namingsystem_decoder(),
    client,
    handle_response,
  )
}

pub fn namingsystem_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Namingsystem, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "NamingSystem",
    r4.namingsystem_decoder(),
    client,
    handle_response,
  )
}

pub fn namingsystem_update(
  resource: r4.Namingsystem,
  client: FhirClient,
  handle_response: fn(Result(r4.Namingsystem, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.namingsystem_to_json(resource),
    "NamingSystem",
    r4.namingsystem_decoder(),
    client,
    handle_response,
  )
}

pub fn namingsystem_delete(
  resource: r4.Namingsystem,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "NamingSystem", client, handle_response)
}

pub fn namingsystem_search_bundled(
  search_for search_args: r4_sansio.SpNamingsystem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.namingsystem_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn namingsystem_search(
  search_for search_args: r4_sansio.SpNamingsystem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Namingsystem), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.namingsystem_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.namingsystem
    },
  )
}

pub fn nutritionorder_create(
  resource: r4.Nutritionorder,
  client: FhirClient,
  handle_response: fn(Result(r4.Nutritionorder, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.nutritionorder_to_json(resource),
    "NutritionOrder",
    r4.nutritionorder_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionorder_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Nutritionorder, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "NutritionOrder",
    r4.nutritionorder_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionorder_update(
  resource: r4.Nutritionorder,
  client: FhirClient,
  handle_response: fn(Result(r4.Nutritionorder, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.nutritionorder_to_json(resource),
    "NutritionOrder",
    r4.nutritionorder_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionorder_delete(
  resource: r4.Nutritionorder,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "NutritionOrder", client, handle_response)
}

pub fn nutritionorder_search_bundled(
  search_for search_args: r4_sansio.SpNutritionorder,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.nutritionorder_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn nutritionorder_search(
  search_for search_args: r4_sansio.SpNutritionorder,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Nutritionorder), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.nutritionorder_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.nutritionorder
    },
  )
}

pub fn observation_create(
  resource: r4.Observation,
  client: FhirClient,
  handle_response: fn(Result(r4.Observation, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.observation_to_json(resource),
    "Observation",
    r4.observation_decoder(),
    client,
    handle_response,
  )
}

pub fn observation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Observation, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Observation", r4.observation_decoder(), client, handle_response)
}

pub fn observation_update(
  resource: r4.Observation,
  client: FhirClient,
  handle_response: fn(Result(r4.Observation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.observation_to_json(resource),
    "Observation",
    r4.observation_decoder(),
    client,
    handle_response,
  )
}

pub fn observation_delete(
  resource: r4.Observation,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Observation", client, handle_response)
}

pub fn observation_search_bundled(
  search_for search_args: r4_sansio.SpObservation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.observation_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn observation_search(
  search_for search_args: r4_sansio.SpObservation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Observation), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.observation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.observation
    },
  )
}

pub fn observationdefinition_create(
  resource: r4.Observationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Observationdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.observationdefinition_to_json(resource),
    "ObservationDefinition",
    r4.observationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn observationdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Observationdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ObservationDefinition",
    r4.observationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn observationdefinition_update(
  resource: r4.Observationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Observationdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.observationdefinition_to_json(resource),
    "ObservationDefinition",
    r4.observationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn observationdefinition_delete(
  resource: r4.Observationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ObservationDefinition", client, handle_response)
}

pub fn observationdefinition_search_bundled(
  search_for search_args: r4_sansio.SpObservationdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.observationdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn observationdefinition_search(
  search_for search_args: r4_sansio.SpObservationdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Observationdefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.observationdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.observationdefinition
    },
  )
}

pub fn operationdefinition_create(
  resource: r4.Operationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.operationdefinition_to_json(resource),
    "OperationDefinition",
    r4.operationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn operationdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "OperationDefinition",
    r4.operationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn operationdefinition_update(
  resource: r4.Operationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.operationdefinition_to_json(resource),
    "OperationDefinition",
    r4.operationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn operationdefinition_delete(
  resource: r4.Operationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "OperationDefinition", client, handle_response)
}

pub fn operationdefinition_search_bundled(
  search_for search_args: r4_sansio.SpOperationdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.operationdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn operationdefinition_search(
  search_for search_args: r4_sansio.SpOperationdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Operationdefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.operationdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.operationdefinition
    },
  )
}

pub fn operationoutcome_create(
  resource: r4.Operationoutcome,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.operationoutcome_to_json(resource),
    "OperationOutcome",
    r4.operationoutcome_decoder(),
    client,
    handle_response,
  )
}

pub fn operationoutcome_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "OperationOutcome",
    r4.operationoutcome_decoder(),
    client,
    handle_response,
  )
}

pub fn operationoutcome_update(
  resource: r4.Operationoutcome,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.operationoutcome_to_json(resource),
    "OperationOutcome",
    r4.operationoutcome_decoder(),
    client,
    handle_response,
  )
}

pub fn operationoutcome_delete(
  resource: r4.Operationoutcome,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "OperationOutcome", client, handle_response)
}

pub fn operationoutcome_search_bundled(
  search_for search_args: r4_sansio.SpOperationoutcome,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.operationoutcome_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn operationoutcome_search(
  search_for search_args: r4_sansio.SpOperationoutcome,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Operationoutcome), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.operationoutcome_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.operationoutcome
    },
  )
}

pub fn organization_create(
  resource: r4.Organization,
  client: FhirClient,
  handle_response: fn(Result(r4.Organization, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.organization_to_json(resource),
    "Organization",
    r4.organization_decoder(),
    client,
    handle_response,
  )
}

pub fn organization_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Organization, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Organization",
    r4.organization_decoder(),
    client,
    handle_response,
  )
}

pub fn organization_update(
  resource: r4.Organization,
  client: FhirClient,
  handle_response: fn(Result(r4.Organization, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.organization_to_json(resource),
    "Organization",
    r4.organization_decoder(),
    client,
    handle_response,
  )
}

pub fn organization_delete(
  resource: r4.Organization,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Organization", client, handle_response)
}

pub fn organization_search_bundled(
  search_for search_args: r4_sansio.SpOrganization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.organization_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn organization_search(
  search_for search_args: r4_sansio.SpOrganization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Organization), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.organization_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.organization
    },
  )
}

pub fn organizationaffiliation_create(
  resource: r4.Organizationaffiliation,
  client: FhirClient,
  handle_response: fn(Result(r4.Organizationaffiliation, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.organizationaffiliation_to_json(resource),
    "OrganizationAffiliation",
    r4.organizationaffiliation_decoder(),
    client,
    handle_response,
  )
}

pub fn organizationaffiliation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Organizationaffiliation, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "OrganizationAffiliation",
    r4.organizationaffiliation_decoder(),
    client,
    handle_response,
  )
}

pub fn organizationaffiliation_update(
  resource: r4.Organizationaffiliation,
  client: FhirClient,
  handle_response: fn(Result(r4.Organizationaffiliation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.organizationaffiliation_to_json(resource),
    "OrganizationAffiliation",
    r4.organizationaffiliation_decoder(),
    client,
    handle_response,
  )
}

pub fn organizationaffiliation_delete(
  resource: r4.Organizationaffiliation,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "OrganizationAffiliation", client, handle_response)
}

pub fn organizationaffiliation_search_bundled(
  search_for search_args: r4_sansio.SpOrganizationaffiliation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.organizationaffiliation_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn organizationaffiliation_search(
  search_for search_args: r4_sansio.SpOrganizationaffiliation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4.Organizationaffiliation), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.organizationaffiliation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.organizationaffiliation
    },
  )
}

pub fn patient_create(
  resource: r4.Patient,
  client: FhirClient,
  handle_response: fn(Result(r4.Patient, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.patient_to_json(resource),
    "Patient",
    r4.patient_decoder(),
    client,
    handle_response,
  )
}

pub fn patient_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Patient, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Patient", r4.patient_decoder(), client, handle_response)
}

pub fn patient_update(
  resource: r4.Patient,
  client: FhirClient,
  handle_response: fn(Result(r4.Patient, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.patient_to_json(resource),
    "Patient",
    r4.patient_decoder(),
    client,
    handle_response,
  )
}

pub fn patient_delete(
  resource: r4.Patient,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Patient", client, handle_response)
}

pub fn patient_search_bundled(
  search_for search_args: r4_sansio.SpPatient,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.patient_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn patient_search(
  search_for search_args: r4_sansio.SpPatient,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Patient), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.patient_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.patient },
  )
}

pub fn paymentnotice_create(
  resource: r4.Paymentnotice,
  client: FhirClient,
  handle_response: fn(Result(r4.Paymentnotice, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.paymentnotice_to_json(resource),
    "PaymentNotice",
    r4.paymentnotice_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentnotice_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Paymentnotice, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "PaymentNotice",
    r4.paymentnotice_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentnotice_update(
  resource: r4.Paymentnotice,
  client: FhirClient,
  handle_response: fn(Result(r4.Paymentnotice, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.paymentnotice_to_json(resource),
    "PaymentNotice",
    r4.paymentnotice_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentnotice_delete(
  resource: r4.Paymentnotice,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "PaymentNotice", client, handle_response)
}

pub fn paymentnotice_search_bundled(
  search_for search_args: r4_sansio.SpPaymentnotice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.paymentnotice_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn paymentnotice_search(
  search_for search_args: r4_sansio.SpPaymentnotice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Paymentnotice), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.paymentnotice_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.paymentnotice
    },
  )
}

pub fn paymentreconciliation_create(
  resource: r4.Paymentreconciliation,
  client: FhirClient,
  handle_response: fn(Result(r4.Paymentreconciliation, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.paymentreconciliation_to_json(resource),
    "PaymentReconciliation",
    r4.paymentreconciliation_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentreconciliation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Paymentreconciliation, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "PaymentReconciliation",
    r4.paymentreconciliation_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentreconciliation_update(
  resource: r4.Paymentreconciliation,
  client: FhirClient,
  handle_response: fn(Result(r4.Paymentreconciliation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.paymentreconciliation_to_json(resource),
    "PaymentReconciliation",
    r4.paymentreconciliation_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentreconciliation_delete(
  resource: r4.Paymentreconciliation,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "PaymentReconciliation", client, handle_response)
}

pub fn paymentreconciliation_search_bundled(
  search_for search_args: r4_sansio.SpPaymentreconciliation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.paymentreconciliation_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn paymentreconciliation_search(
  search_for search_args: r4_sansio.SpPaymentreconciliation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Paymentreconciliation), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.paymentreconciliation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.paymentreconciliation
    },
  )
}

pub fn person_create(
  resource: r4.Person,
  client: FhirClient,
  handle_response: fn(Result(r4.Person, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.person_to_json(resource),
    "Person",
    r4.person_decoder(),
    client,
    handle_response,
  )
}

pub fn person_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Person, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Person", r4.person_decoder(), client, handle_response)
}

pub fn person_update(
  resource: r4.Person,
  client: FhirClient,
  handle_response: fn(Result(r4.Person, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.person_to_json(resource),
    "Person",
    r4.person_decoder(),
    client,
    handle_response,
  )
}

pub fn person_delete(
  resource: r4.Person,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Person", client, handle_response)
}

pub fn person_search_bundled(
  search_for search_args: r4_sansio.SpPerson,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.person_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn person_search(
  search_for search_args: r4_sansio.SpPerson,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Person), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.person_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.person },
  )
}

pub fn plandefinition_create(
  resource: r4.Plandefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Plandefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.plandefinition_to_json(resource),
    "PlanDefinition",
    r4.plandefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn plandefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Plandefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "PlanDefinition",
    r4.plandefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn plandefinition_update(
  resource: r4.Plandefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Plandefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.plandefinition_to_json(resource),
    "PlanDefinition",
    r4.plandefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn plandefinition_delete(
  resource: r4.Plandefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "PlanDefinition", client, handle_response)
}

pub fn plandefinition_search_bundled(
  search_for search_args: r4_sansio.SpPlandefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.plandefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn plandefinition_search(
  search_for search_args: r4_sansio.SpPlandefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Plandefinition), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.plandefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.plandefinition
    },
  )
}

pub fn practitioner_create(
  resource: r4.Practitioner,
  client: FhirClient,
  handle_response: fn(Result(r4.Practitioner, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.practitioner_to_json(resource),
    "Practitioner",
    r4.practitioner_decoder(),
    client,
    handle_response,
  )
}

pub fn practitioner_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Practitioner, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Practitioner",
    r4.practitioner_decoder(),
    client,
    handle_response,
  )
}

pub fn practitioner_update(
  resource: r4.Practitioner,
  client: FhirClient,
  handle_response: fn(Result(r4.Practitioner, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.practitioner_to_json(resource),
    "Practitioner",
    r4.practitioner_decoder(),
    client,
    handle_response,
  )
}

pub fn practitioner_delete(
  resource: r4.Practitioner,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Practitioner", client, handle_response)
}

pub fn practitioner_search_bundled(
  search_for search_args: r4_sansio.SpPractitioner,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.practitioner_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn practitioner_search(
  search_for search_args: r4_sansio.SpPractitioner,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Practitioner), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.practitioner_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.practitioner
    },
  )
}

pub fn practitionerrole_create(
  resource: r4.Practitionerrole,
  client: FhirClient,
  handle_response: fn(Result(r4.Practitionerrole, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.practitionerrole_to_json(resource),
    "PractitionerRole",
    r4.practitionerrole_decoder(),
    client,
    handle_response,
  )
}

pub fn practitionerrole_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Practitionerrole, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "PractitionerRole",
    r4.practitionerrole_decoder(),
    client,
    handle_response,
  )
}

pub fn practitionerrole_update(
  resource: r4.Practitionerrole,
  client: FhirClient,
  handle_response: fn(Result(r4.Practitionerrole, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.practitionerrole_to_json(resource),
    "PractitionerRole",
    r4.practitionerrole_decoder(),
    client,
    handle_response,
  )
}

pub fn practitionerrole_delete(
  resource: r4.Practitionerrole,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "PractitionerRole", client, handle_response)
}

pub fn practitionerrole_search_bundled(
  search_for search_args: r4_sansio.SpPractitionerrole,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.practitionerrole_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn practitionerrole_search(
  search_for search_args: r4_sansio.SpPractitionerrole,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Practitionerrole), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.practitionerrole_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.practitionerrole
    },
  )
}

pub fn procedure_create(
  resource: r4.Procedure,
  client: FhirClient,
  handle_response: fn(Result(r4.Procedure, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.procedure_to_json(resource),
    "Procedure",
    r4.procedure_decoder(),
    client,
    handle_response,
  )
}

pub fn procedure_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Procedure, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Procedure", r4.procedure_decoder(), client, handle_response)
}

pub fn procedure_update(
  resource: r4.Procedure,
  client: FhirClient,
  handle_response: fn(Result(r4.Procedure, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.procedure_to_json(resource),
    "Procedure",
    r4.procedure_decoder(),
    client,
    handle_response,
  )
}

pub fn procedure_delete(
  resource: r4.Procedure,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Procedure", client, handle_response)
}

pub fn procedure_search_bundled(
  search_for search_args: r4_sansio.SpProcedure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.procedure_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn procedure_search(
  search_for search_args: r4_sansio.SpProcedure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Procedure), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.procedure_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.procedure },
  )
}

pub fn provenance_create(
  resource: r4.Provenance,
  client: FhirClient,
  handle_response: fn(Result(r4.Provenance, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.provenance_to_json(resource),
    "Provenance",
    r4.provenance_decoder(),
    client,
    handle_response,
  )
}

pub fn provenance_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Provenance, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Provenance", r4.provenance_decoder(), client, handle_response)
}

pub fn provenance_update(
  resource: r4.Provenance,
  client: FhirClient,
  handle_response: fn(Result(r4.Provenance, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.provenance_to_json(resource),
    "Provenance",
    r4.provenance_decoder(),
    client,
    handle_response,
  )
}

pub fn provenance_delete(
  resource: r4.Provenance,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Provenance", client, handle_response)
}

pub fn provenance_search_bundled(
  search_for search_args: r4_sansio.SpProvenance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.provenance_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn provenance_search(
  search_for search_args: r4_sansio.SpProvenance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Provenance), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.provenance_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.provenance },
  )
}

pub fn questionnaire_create(
  resource: r4.Questionnaire,
  client: FhirClient,
  handle_response: fn(Result(r4.Questionnaire, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.questionnaire_to_json(resource),
    "Questionnaire",
    r4.questionnaire_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaire_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Questionnaire, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Questionnaire",
    r4.questionnaire_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaire_update(
  resource: r4.Questionnaire,
  client: FhirClient,
  handle_response: fn(Result(r4.Questionnaire, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.questionnaire_to_json(resource),
    "Questionnaire",
    r4.questionnaire_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaire_delete(
  resource: r4.Questionnaire,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Questionnaire", client, handle_response)
}

pub fn questionnaire_search_bundled(
  search_for search_args: r4_sansio.SpQuestionnaire,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.questionnaire_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn questionnaire_search(
  search_for search_args: r4_sansio.SpQuestionnaire,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Questionnaire), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.questionnaire_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.questionnaire
    },
  )
}

pub fn questionnaireresponse_create(
  resource: r4.Questionnaireresponse,
  client: FhirClient,
  handle_response: fn(Result(r4.Questionnaireresponse, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    r4.questionnaireresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaireresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Questionnaireresponse, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "QuestionnaireResponse",
    r4.questionnaireresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaireresponse_update(
  resource: r4.Questionnaireresponse,
  client: FhirClient,
  handle_response: fn(Result(r4.Questionnaireresponse, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    r4.questionnaireresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaireresponse_delete(
  resource: r4.Questionnaireresponse,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "QuestionnaireResponse", client, handle_response)
}

pub fn questionnaireresponse_search_bundled(
  search_for search_args: r4_sansio.SpQuestionnaireresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.questionnaireresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn questionnaireresponse_search(
  search_for search_args: r4_sansio.SpQuestionnaireresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Questionnaireresponse), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.questionnaireresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.questionnaireresponse
    },
  )
}

pub fn relatedperson_create(
  resource: r4.Relatedperson,
  client: FhirClient,
  handle_response: fn(Result(r4.Relatedperson, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.relatedperson_to_json(resource),
    "RelatedPerson",
    r4.relatedperson_decoder(),
    client,
    handle_response,
  )
}

pub fn relatedperson_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Relatedperson, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "RelatedPerson",
    r4.relatedperson_decoder(),
    client,
    handle_response,
  )
}

pub fn relatedperson_update(
  resource: r4.Relatedperson,
  client: FhirClient,
  handle_response: fn(Result(r4.Relatedperson, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.relatedperson_to_json(resource),
    "RelatedPerson",
    r4.relatedperson_decoder(),
    client,
    handle_response,
  )
}

pub fn relatedperson_delete(
  resource: r4.Relatedperson,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "RelatedPerson", client, handle_response)
}

pub fn relatedperson_search_bundled(
  search_for search_args: r4_sansio.SpRelatedperson,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.relatedperson_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn relatedperson_search(
  search_for search_args: r4_sansio.SpRelatedperson,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Relatedperson), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.relatedperson_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.relatedperson
    },
  )
}

pub fn requestgroup_create(
  resource: r4.Requestgroup,
  client: FhirClient,
  handle_response: fn(Result(r4.Requestgroup, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.requestgroup_to_json(resource),
    "RequestGroup",
    r4.requestgroup_decoder(),
    client,
    handle_response,
  )
}

pub fn requestgroup_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Requestgroup, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "RequestGroup",
    r4.requestgroup_decoder(),
    client,
    handle_response,
  )
}

pub fn requestgroup_update(
  resource: r4.Requestgroup,
  client: FhirClient,
  handle_response: fn(Result(r4.Requestgroup, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.requestgroup_to_json(resource),
    "RequestGroup",
    r4.requestgroup_decoder(),
    client,
    handle_response,
  )
}

pub fn requestgroup_delete(
  resource: r4.Requestgroup,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "RequestGroup", client, handle_response)
}

pub fn requestgroup_search_bundled(
  search_for search_args: r4_sansio.SpRequestgroup,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.requestgroup_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn requestgroup_search(
  search_for search_args: r4_sansio.SpRequestgroup,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Requestgroup), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.requestgroup_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.requestgroup
    },
  )
}

pub fn researchdefinition_create(
  resource: r4.Researchdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Researchdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.researchdefinition_to_json(resource),
    "ResearchDefinition",
    r4.researchdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn researchdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Researchdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ResearchDefinition",
    r4.researchdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn researchdefinition_update(
  resource: r4.Researchdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Researchdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.researchdefinition_to_json(resource),
    "ResearchDefinition",
    r4.researchdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn researchdefinition_delete(
  resource: r4.Researchdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ResearchDefinition", client, handle_response)
}

pub fn researchdefinition_search_bundled(
  search_for search_args: r4_sansio.SpResearchdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.researchdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn researchdefinition_search(
  search_for search_args: r4_sansio.SpResearchdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Researchdefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.researchdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.researchdefinition
    },
  )
}

pub fn researchelementdefinition_create(
  resource: r4.Researchelementdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Researchelementdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.researchelementdefinition_to_json(resource),
    "ResearchElementDefinition",
    r4.researchelementdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn researchelementdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Researchelementdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ResearchElementDefinition",
    r4.researchelementdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn researchelementdefinition_update(
  resource: r4.Researchelementdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Researchelementdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.researchelementdefinition_to_json(resource),
    "ResearchElementDefinition",
    r4.researchelementdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn researchelementdefinition_delete(
  resource: r4.Researchelementdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ResearchElementDefinition", client, handle_response)
}

pub fn researchelementdefinition_search_bundled(
  search_for search_args: r4_sansio.SpResearchelementdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.researchelementdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn researchelementdefinition_search(
  search_for search_args: r4_sansio.SpResearchelementdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4.Researchelementdefinition), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.researchelementdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.researchelementdefinition
    },
  )
}

pub fn researchstudy_create(
  resource: r4.Researchstudy,
  client: FhirClient,
  handle_response: fn(Result(r4.Researchstudy, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.researchstudy_to_json(resource),
    "ResearchStudy",
    r4.researchstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn researchstudy_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Researchstudy, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ResearchStudy",
    r4.researchstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn researchstudy_update(
  resource: r4.Researchstudy,
  client: FhirClient,
  handle_response: fn(Result(r4.Researchstudy, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.researchstudy_to_json(resource),
    "ResearchStudy",
    r4.researchstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn researchstudy_delete(
  resource: r4.Researchstudy,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ResearchStudy", client, handle_response)
}

pub fn researchstudy_search_bundled(
  search_for search_args: r4_sansio.SpResearchstudy,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.researchstudy_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn researchstudy_search(
  search_for search_args: r4_sansio.SpResearchstudy,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Researchstudy), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.researchstudy_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.researchstudy
    },
  )
}

pub fn researchsubject_create(
  resource: r4.Researchsubject,
  client: FhirClient,
  handle_response: fn(Result(r4.Researchsubject, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.researchsubject_to_json(resource),
    "ResearchSubject",
    r4.researchsubject_decoder(),
    client,
    handle_response,
  )
}

pub fn researchsubject_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Researchsubject, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ResearchSubject",
    r4.researchsubject_decoder(),
    client,
    handle_response,
  )
}

pub fn researchsubject_update(
  resource: r4.Researchsubject,
  client: FhirClient,
  handle_response: fn(Result(r4.Researchsubject, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.researchsubject_to_json(resource),
    "ResearchSubject",
    r4.researchsubject_decoder(),
    client,
    handle_response,
  )
}

pub fn researchsubject_delete(
  resource: r4.Researchsubject,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ResearchSubject", client, handle_response)
}

pub fn researchsubject_search_bundled(
  search_for search_args: r4_sansio.SpResearchsubject,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.researchsubject_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn researchsubject_search(
  search_for search_args: r4_sansio.SpResearchsubject,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Researchsubject), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.researchsubject_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.researchsubject
    },
  )
}

pub fn riskassessment_create(
  resource: r4.Riskassessment,
  client: FhirClient,
  handle_response: fn(Result(r4.Riskassessment, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.riskassessment_to_json(resource),
    "RiskAssessment",
    r4.riskassessment_decoder(),
    client,
    handle_response,
  )
}

pub fn riskassessment_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Riskassessment, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "RiskAssessment",
    r4.riskassessment_decoder(),
    client,
    handle_response,
  )
}

pub fn riskassessment_update(
  resource: r4.Riskassessment,
  client: FhirClient,
  handle_response: fn(Result(r4.Riskassessment, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.riskassessment_to_json(resource),
    "RiskAssessment",
    r4.riskassessment_decoder(),
    client,
    handle_response,
  )
}

pub fn riskassessment_delete(
  resource: r4.Riskassessment,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "RiskAssessment", client, handle_response)
}

pub fn riskassessment_search_bundled(
  search_for search_args: r4_sansio.SpRiskassessment,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.riskassessment_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn riskassessment_search(
  search_for search_args: r4_sansio.SpRiskassessment,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Riskassessment), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.riskassessment_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.riskassessment
    },
  )
}

pub fn riskevidencesynthesis_create(
  resource: r4.Riskevidencesynthesis,
  client: FhirClient,
  handle_response: fn(Result(r4.Riskevidencesynthesis, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.riskevidencesynthesis_to_json(resource),
    "RiskEvidenceSynthesis",
    r4.riskevidencesynthesis_decoder(),
    client,
    handle_response,
  )
}

pub fn riskevidencesynthesis_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Riskevidencesynthesis, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "RiskEvidenceSynthesis",
    r4.riskevidencesynthesis_decoder(),
    client,
    handle_response,
  )
}

pub fn riskevidencesynthesis_update(
  resource: r4.Riskevidencesynthesis,
  client: FhirClient,
  handle_response: fn(Result(r4.Riskevidencesynthesis, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.riskevidencesynthesis_to_json(resource),
    "RiskEvidenceSynthesis",
    r4.riskevidencesynthesis_decoder(),
    client,
    handle_response,
  )
}

pub fn riskevidencesynthesis_delete(
  resource: r4.Riskevidencesynthesis,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "RiskEvidenceSynthesis", client, handle_response)
}

pub fn riskevidencesynthesis_search_bundled(
  search_for search_args: r4_sansio.SpRiskevidencesynthesis,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.riskevidencesynthesis_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn riskevidencesynthesis_search(
  search_for search_args: r4_sansio.SpRiskevidencesynthesis,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Riskevidencesynthesis), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.riskevidencesynthesis_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.riskevidencesynthesis
    },
  )
}

pub fn schedule_create(
  resource: r4.Schedule,
  client: FhirClient,
  handle_response: fn(Result(r4.Schedule, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.schedule_to_json(resource),
    "Schedule",
    r4.schedule_decoder(),
    client,
    handle_response,
  )
}

pub fn schedule_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Schedule, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Schedule", r4.schedule_decoder(), client, handle_response)
}

pub fn schedule_update(
  resource: r4.Schedule,
  client: FhirClient,
  handle_response: fn(Result(r4.Schedule, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.schedule_to_json(resource),
    "Schedule",
    r4.schedule_decoder(),
    client,
    handle_response,
  )
}

pub fn schedule_delete(
  resource: r4.Schedule,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Schedule", client, handle_response)
}

pub fn schedule_search_bundled(
  search_for search_args: r4_sansio.SpSchedule,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.schedule_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn schedule_search(
  search_for search_args: r4_sansio.SpSchedule,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Schedule), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.schedule_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.schedule },
  )
}

pub fn searchparameter_create(
  resource: r4.Searchparameter,
  client: FhirClient,
  handle_response: fn(Result(r4.Searchparameter, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.searchparameter_to_json(resource),
    "SearchParameter",
    r4.searchparameter_decoder(),
    client,
    handle_response,
  )
}

pub fn searchparameter_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Searchparameter, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SearchParameter",
    r4.searchparameter_decoder(),
    client,
    handle_response,
  )
}

pub fn searchparameter_update(
  resource: r4.Searchparameter,
  client: FhirClient,
  handle_response: fn(Result(r4.Searchparameter, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.searchparameter_to_json(resource),
    "SearchParameter",
    r4.searchparameter_decoder(),
    client,
    handle_response,
  )
}

pub fn searchparameter_delete(
  resource: r4.Searchparameter,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SearchParameter", client, handle_response)
}

pub fn searchparameter_search_bundled(
  search_for search_args: r4_sansio.SpSearchparameter,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.searchparameter_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn searchparameter_search(
  search_for search_args: r4_sansio.SpSearchparameter,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Searchparameter), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.searchparameter_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.searchparameter
    },
  )
}

pub fn servicerequest_create(
  resource: r4.Servicerequest,
  client: FhirClient,
  handle_response: fn(Result(r4.Servicerequest, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.servicerequest_to_json(resource),
    "ServiceRequest",
    r4.servicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn servicerequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Servicerequest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ServiceRequest",
    r4.servicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn servicerequest_update(
  resource: r4.Servicerequest,
  client: FhirClient,
  handle_response: fn(Result(r4.Servicerequest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.servicerequest_to_json(resource),
    "ServiceRequest",
    r4.servicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn servicerequest_delete(
  resource: r4.Servicerequest,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ServiceRequest", client, handle_response)
}

pub fn servicerequest_search_bundled(
  search_for search_args: r4_sansio.SpServicerequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.servicerequest_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn servicerequest_search(
  search_for search_args: r4_sansio.SpServicerequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Servicerequest), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.servicerequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.servicerequest
    },
  )
}

pub fn slot_create(
  resource: r4.Slot,
  client: FhirClient,
  handle_response: fn(Result(r4.Slot, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.slot_to_json(resource),
    "Slot",
    r4.slot_decoder(),
    client,
    handle_response,
  )
}

pub fn slot_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Slot, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Slot", r4.slot_decoder(), client, handle_response)
}

pub fn slot_update(
  resource: r4.Slot,
  client: FhirClient,
  handle_response: fn(Result(r4.Slot, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.slot_to_json(resource),
    "Slot",
    r4.slot_decoder(),
    client,
    handle_response,
  )
}

pub fn slot_delete(
  resource: r4.Slot,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Slot", client, handle_response)
}

pub fn slot_search_bundled(
  search_for search_args: r4_sansio.SpSlot,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.slot_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn slot_search(
  search_for search_args: r4_sansio.SpSlot,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Slot), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.slot_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.slot },
  )
}

pub fn specimen_create(
  resource: r4.Specimen,
  client: FhirClient,
  handle_response: fn(Result(r4.Specimen, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.specimen_to_json(resource),
    "Specimen",
    r4.specimen_decoder(),
    client,
    handle_response,
  )
}

pub fn specimen_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Specimen, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Specimen", r4.specimen_decoder(), client, handle_response)
}

pub fn specimen_update(
  resource: r4.Specimen,
  client: FhirClient,
  handle_response: fn(Result(r4.Specimen, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.specimen_to_json(resource),
    "Specimen",
    r4.specimen_decoder(),
    client,
    handle_response,
  )
}

pub fn specimen_delete(
  resource: r4.Specimen,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Specimen", client, handle_response)
}

pub fn specimen_search_bundled(
  search_for search_args: r4_sansio.SpSpecimen,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.specimen_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn specimen_search(
  search_for search_args: r4_sansio.SpSpecimen,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Specimen), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.specimen_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.specimen },
  )
}

pub fn specimendefinition_create(
  resource: r4.Specimendefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Specimendefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.specimendefinition_to_json(resource),
    "SpecimenDefinition",
    r4.specimendefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn specimendefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Specimendefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SpecimenDefinition",
    r4.specimendefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn specimendefinition_update(
  resource: r4.Specimendefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Specimendefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.specimendefinition_to_json(resource),
    "SpecimenDefinition",
    r4.specimendefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn specimendefinition_delete(
  resource: r4.Specimendefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SpecimenDefinition", client, handle_response)
}

pub fn specimendefinition_search_bundled(
  search_for search_args: r4_sansio.SpSpecimendefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.specimendefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn specimendefinition_search(
  search_for search_args: r4_sansio.SpSpecimendefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Specimendefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.specimendefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.specimendefinition
    },
  )
}

pub fn structuredefinition_create(
  resource: r4.Structuredefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Structuredefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.structuredefinition_to_json(resource),
    "StructureDefinition",
    r4.structuredefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn structuredefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Structuredefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "StructureDefinition",
    r4.structuredefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn structuredefinition_update(
  resource: r4.Structuredefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Structuredefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.structuredefinition_to_json(resource),
    "StructureDefinition",
    r4.structuredefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn structuredefinition_delete(
  resource: r4.Structuredefinition,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "StructureDefinition", client, handle_response)
}

pub fn structuredefinition_search_bundled(
  search_for search_args: r4_sansio.SpStructuredefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.structuredefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn structuredefinition_search(
  search_for search_args: r4_sansio.SpStructuredefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Structuredefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.structuredefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.structuredefinition
    },
  )
}

pub fn structuremap_create(
  resource: r4.Structuremap,
  client: FhirClient,
  handle_response: fn(Result(r4.Structuremap, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.structuremap_to_json(resource),
    "StructureMap",
    r4.structuremap_decoder(),
    client,
    handle_response,
  )
}

pub fn structuremap_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Structuremap, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "StructureMap",
    r4.structuremap_decoder(),
    client,
    handle_response,
  )
}

pub fn structuremap_update(
  resource: r4.Structuremap,
  client: FhirClient,
  handle_response: fn(Result(r4.Structuremap, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.structuremap_to_json(resource),
    "StructureMap",
    r4.structuremap_decoder(),
    client,
    handle_response,
  )
}

pub fn structuremap_delete(
  resource: r4.Structuremap,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "StructureMap", client, handle_response)
}

pub fn structuremap_search_bundled(
  search_for search_args: r4_sansio.SpStructuremap,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.structuremap_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn structuremap_search(
  search_for search_args: r4_sansio.SpStructuremap,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Structuremap), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.structuremap_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.structuremap
    },
  )
}

pub fn subscription_create(
  resource: r4.Subscription,
  client: FhirClient,
  handle_response: fn(Result(r4.Subscription, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.subscription_to_json(resource),
    "Subscription",
    r4.subscription_decoder(),
    client,
    handle_response,
  )
}

pub fn subscription_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Subscription, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Subscription",
    r4.subscription_decoder(),
    client,
    handle_response,
  )
}

pub fn subscription_update(
  resource: r4.Subscription,
  client: FhirClient,
  handle_response: fn(Result(r4.Subscription, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.subscription_to_json(resource),
    "Subscription",
    r4.subscription_decoder(),
    client,
    handle_response,
  )
}

pub fn subscription_delete(
  resource: r4.Subscription,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Subscription", client, handle_response)
}

pub fn subscription_search_bundled(
  search_for search_args: r4_sansio.SpSubscription,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.subscription_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn subscription_search(
  search_for search_args: r4_sansio.SpSubscription,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Subscription), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.subscription_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.subscription
    },
  )
}

pub fn substance_create(
  resource: r4.Substance,
  client: FhirClient,
  handle_response: fn(Result(r4.Substance, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.substance_to_json(resource),
    "Substance",
    r4.substance_decoder(),
    client,
    handle_response,
  )
}

pub fn substance_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Substance, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Substance", r4.substance_decoder(), client, handle_response)
}

pub fn substance_update(
  resource: r4.Substance,
  client: FhirClient,
  handle_response: fn(Result(r4.Substance, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.substance_to_json(resource),
    "Substance",
    r4.substance_decoder(),
    client,
    handle_response,
  )
}

pub fn substance_delete(
  resource: r4.Substance,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Substance", client, handle_response)
}

pub fn substance_search_bundled(
  search_for search_args: r4_sansio.SpSubstance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.substance_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn substance_search(
  search_for search_args: r4_sansio.SpSubstance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Substance), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.substance_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.substance },
  )
}

pub fn substancenucleicacid_create(
  resource: r4.Substancenucleicacid,
  client: FhirClient,
  handle_response: fn(Result(r4.Substancenucleicacid, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.substancenucleicacid_to_json(resource),
    "SubstanceNucleicAcid",
    r4.substancenucleicacid_decoder(),
    client,
    handle_response,
  )
}

pub fn substancenucleicacid_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Substancenucleicacid, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstanceNucleicAcid",
    r4.substancenucleicacid_decoder(),
    client,
    handle_response,
  )
}

pub fn substancenucleicacid_update(
  resource: r4.Substancenucleicacid,
  client: FhirClient,
  handle_response: fn(Result(r4.Substancenucleicacid, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.substancenucleicacid_to_json(resource),
    "SubstanceNucleicAcid",
    r4.substancenucleicacid_decoder(),
    client,
    handle_response,
  )
}

pub fn substancenucleicacid_delete(
  resource: r4.Substancenucleicacid,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SubstanceNucleicAcid", client, handle_response)
}

pub fn substancenucleicacid_search_bundled(
  search_for search_args: r4_sansio.SpSubstancenucleicacid,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.substancenucleicacid_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn substancenucleicacid_search(
  search_for search_args: r4_sansio.SpSubstancenucleicacid,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Substancenucleicacid), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.substancenucleicacid_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.substancenucleicacid
    },
  )
}

pub fn substancepolymer_create(
  resource: r4.Substancepolymer,
  client: FhirClient,
  handle_response: fn(Result(r4.Substancepolymer, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.substancepolymer_to_json(resource),
    "SubstancePolymer",
    r4.substancepolymer_decoder(),
    client,
    handle_response,
  )
}

pub fn substancepolymer_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Substancepolymer, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstancePolymer",
    r4.substancepolymer_decoder(),
    client,
    handle_response,
  )
}

pub fn substancepolymer_update(
  resource: r4.Substancepolymer,
  client: FhirClient,
  handle_response: fn(Result(r4.Substancepolymer, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.substancepolymer_to_json(resource),
    "SubstancePolymer",
    r4.substancepolymer_decoder(),
    client,
    handle_response,
  )
}

pub fn substancepolymer_delete(
  resource: r4.Substancepolymer,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SubstancePolymer", client, handle_response)
}

pub fn substancepolymer_search_bundled(
  search_for search_args: r4_sansio.SpSubstancepolymer,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.substancepolymer_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn substancepolymer_search(
  search_for search_args: r4_sansio.SpSubstancepolymer,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Substancepolymer), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.substancepolymer_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.substancepolymer
    },
  )
}

pub fn substanceprotein_create(
  resource: r4.Substanceprotein,
  client: FhirClient,
  handle_response: fn(Result(r4.Substanceprotein, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.substanceprotein_to_json(resource),
    "SubstanceProtein",
    r4.substanceprotein_decoder(),
    client,
    handle_response,
  )
}

pub fn substanceprotein_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Substanceprotein, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstanceProtein",
    r4.substanceprotein_decoder(),
    client,
    handle_response,
  )
}

pub fn substanceprotein_update(
  resource: r4.Substanceprotein,
  client: FhirClient,
  handle_response: fn(Result(r4.Substanceprotein, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.substanceprotein_to_json(resource),
    "SubstanceProtein",
    r4.substanceprotein_decoder(),
    client,
    handle_response,
  )
}

pub fn substanceprotein_delete(
  resource: r4.Substanceprotein,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SubstanceProtein", client, handle_response)
}

pub fn substanceprotein_search_bundled(
  search_for search_args: r4_sansio.SpSubstanceprotein,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.substanceprotein_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn substanceprotein_search(
  search_for search_args: r4_sansio.SpSubstanceprotein,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Substanceprotein), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.substanceprotein_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.substanceprotein
    },
  )
}

pub fn substancereferenceinformation_create(
  resource: r4.Substancereferenceinformation,
  client: FhirClient,
  handle_response: fn(Result(r4.Substancereferenceinformation, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.substancereferenceinformation_to_json(resource),
    "SubstanceReferenceInformation",
    r4.substancereferenceinformation_decoder(),
    client,
    handle_response,
  )
}

pub fn substancereferenceinformation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Substancereferenceinformation, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstanceReferenceInformation",
    r4.substancereferenceinformation_decoder(),
    client,
    handle_response,
  )
}

pub fn substancereferenceinformation_update(
  resource: r4.Substancereferenceinformation,
  client: FhirClient,
  handle_response: fn(Result(r4.Substancereferenceinformation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.substancereferenceinformation_to_json(resource),
    "SubstanceReferenceInformation",
    r4.substancereferenceinformation_decoder(),
    client,
    handle_response,
  )
}

pub fn substancereferenceinformation_delete(
  resource: r4.Substancereferenceinformation,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(
    resource.id,
    "SubstanceReferenceInformation",
    client,
    handle_response,
  )
}

pub fn substancereferenceinformation_search_bundled(
  search_for search_args: r4_sansio.SpSubstancereferenceinformation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4_sansio.substancereferenceinformation_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn substancereferenceinformation_search(
  search_for search_args: r4_sansio.SpSubstancereferenceinformation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4.Substancereferenceinformation), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4_sansio.substancereferenceinformation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.substancereferenceinformation
    },
  )
}

pub fn substancesourcematerial_create(
  resource: r4.Substancesourcematerial,
  client: FhirClient,
  handle_response: fn(Result(r4.Substancesourcematerial, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.substancesourcematerial_to_json(resource),
    "SubstanceSourceMaterial",
    r4.substancesourcematerial_decoder(),
    client,
    handle_response,
  )
}

pub fn substancesourcematerial_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Substancesourcematerial, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstanceSourceMaterial",
    r4.substancesourcematerial_decoder(),
    client,
    handle_response,
  )
}

pub fn substancesourcematerial_update(
  resource: r4.Substancesourcematerial,
  client: FhirClient,
  handle_response: fn(Result(r4.Substancesourcematerial, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.substancesourcematerial_to_json(resource),
    "SubstanceSourceMaterial",
    r4.substancesourcematerial_decoder(),
    client,
    handle_response,
  )
}

pub fn substancesourcematerial_delete(
  resource: r4.Substancesourcematerial,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SubstanceSourceMaterial", client, handle_response)
}

pub fn substancesourcematerial_search_bundled(
  search_for search_args: r4_sansio.SpSubstancesourcematerial,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.substancesourcematerial_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn substancesourcematerial_search(
  search_for search_args: r4_sansio.SpSubstancesourcematerial,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4.Substancesourcematerial), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.substancesourcematerial_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.substancesourcematerial
    },
  )
}

pub fn substancespecification_create(
  resource: r4.Substancespecification,
  client: FhirClient,
  handle_response: fn(Result(r4.Substancespecification, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.substancespecification_to_json(resource),
    "SubstanceSpecification",
    r4.substancespecification_decoder(),
    client,
    handle_response,
  )
}

pub fn substancespecification_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Substancespecification, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstanceSpecification",
    r4.substancespecification_decoder(),
    client,
    handle_response,
  )
}

pub fn substancespecification_update(
  resource: r4.Substancespecification,
  client: FhirClient,
  handle_response: fn(Result(r4.Substancespecification, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.substancespecification_to_json(resource),
    "SubstanceSpecification",
    r4.substancespecification_decoder(),
    client,
    handle_response,
  )
}

pub fn substancespecification_delete(
  resource: r4.Substancespecification,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SubstanceSpecification", client, handle_response)
}

pub fn substancespecification_search_bundled(
  search_for search_args: r4_sansio.SpSubstancespecification,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.substancespecification_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn substancespecification_search(
  search_for search_args: r4_sansio.SpSubstancespecification,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Substancespecification), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.substancespecification_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.substancespecification
    },
  )
}

pub fn supplydelivery_create(
  resource: r4.Supplydelivery,
  client: FhirClient,
  handle_response: fn(Result(r4.Supplydelivery, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.supplydelivery_to_json(resource),
    "SupplyDelivery",
    r4.supplydelivery_decoder(),
    client,
    handle_response,
  )
}

pub fn supplydelivery_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Supplydelivery, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SupplyDelivery",
    r4.supplydelivery_decoder(),
    client,
    handle_response,
  )
}

pub fn supplydelivery_update(
  resource: r4.Supplydelivery,
  client: FhirClient,
  handle_response: fn(Result(r4.Supplydelivery, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.supplydelivery_to_json(resource),
    "SupplyDelivery",
    r4.supplydelivery_decoder(),
    client,
    handle_response,
  )
}

pub fn supplydelivery_delete(
  resource: r4.Supplydelivery,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SupplyDelivery", client, handle_response)
}

pub fn supplydelivery_search_bundled(
  search_for search_args: r4_sansio.SpSupplydelivery,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.supplydelivery_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn supplydelivery_search(
  search_for search_args: r4_sansio.SpSupplydelivery,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Supplydelivery), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.supplydelivery_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.supplydelivery
    },
  )
}

pub fn supplyrequest_create(
  resource: r4.Supplyrequest,
  client: FhirClient,
  handle_response: fn(Result(r4.Supplyrequest, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.supplyrequest_to_json(resource),
    "SupplyRequest",
    r4.supplyrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn supplyrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Supplyrequest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SupplyRequest",
    r4.supplyrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn supplyrequest_update(
  resource: r4.Supplyrequest,
  client: FhirClient,
  handle_response: fn(Result(r4.Supplyrequest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.supplyrequest_to_json(resource),
    "SupplyRequest",
    r4.supplyrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn supplyrequest_delete(
  resource: r4.Supplyrequest,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SupplyRequest", client, handle_response)
}

pub fn supplyrequest_search_bundled(
  search_for search_args: r4_sansio.SpSupplyrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.supplyrequest_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn supplyrequest_search(
  search_for search_args: r4_sansio.SpSupplyrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Supplyrequest), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.supplyrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.supplyrequest
    },
  )
}

pub fn task_create(
  resource: r4.Task,
  client: FhirClient,
  handle_response: fn(Result(r4.Task, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.task_to_json(resource),
    "Task",
    r4.task_decoder(),
    client,
    handle_response,
  )
}

pub fn task_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Task, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Task", r4.task_decoder(), client, handle_response)
}

pub fn task_update(
  resource: r4.Task,
  client: FhirClient,
  handle_response: fn(Result(r4.Task, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.task_to_json(resource),
    "Task",
    r4.task_decoder(),
    client,
    handle_response,
  )
}

pub fn task_delete(
  resource: r4.Task,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Task", client, handle_response)
}

pub fn task_search_bundled(
  search_for search_args: r4_sansio.SpTask,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.task_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn task_search(
  search_for search_args: r4_sansio.SpTask,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Task), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.task_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.task },
  )
}

pub fn terminologycapabilities_create(
  resource: r4.Terminologycapabilities,
  client: FhirClient,
  handle_response: fn(Result(r4.Terminologycapabilities, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.terminologycapabilities_to_json(resource),
    "TerminologyCapabilities",
    r4.terminologycapabilities_decoder(),
    client,
    handle_response,
  )
}

pub fn terminologycapabilities_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Terminologycapabilities, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "TerminologyCapabilities",
    r4.terminologycapabilities_decoder(),
    client,
    handle_response,
  )
}

pub fn terminologycapabilities_update(
  resource: r4.Terminologycapabilities,
  client: FhirClient,
  handle_response: fn(Result(r4.Terminologycapabilities, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.terminologycapabilities_to_json(resource),
    "TerminologyCapabilities",
    r4.terminologycapabilities_decoder(),
    client,
    handle_response,
  )
}

pub fn terminologycapabilities_delete(
  resource: r4.Terminologycapabilities,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "TerminologyCapabilities", client, handle_response)
}

pub fn terminologycapabilities_search_bundled(
  search_for search_args: r4_sansio.SpTerminologycapabilities,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.terminologycapabilities_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn terminologycapabilities_search(
  search_for search_args: r4_sansio.SpTerminologycapabilities,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4.Terminologycapabilities), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.terminologycapabilities_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.terminologycapabilities
    },
  )
}

pub fn testreport_create(
  resource: r4.Testreport,
  client: FhirClient,
  handle_response: fn(Result(r4.Testreport, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.testreport_to_json(resource),
    "TestReport",
    r4.testreport_decoder(),
    client,
    handle_response,
  )
}

pub fn testreport_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Testreport, Err)) -> a,
) -> Effect(a) {
  any_read(id, "TestReport", r4.testreport_decoder(), client, handle_response)
}

pub fn testreport_update(
  resource: r4.Testreport,
  client: FhirClient,
  handle_response: fn(Result(r4.Testreport, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.testreport_to_json(resource),
    "TestReport",
    r4.testreport_decoder(),
    client,
    handle_response,
  )
}

pub fn testreport_delete(
  resource: r4.Testreport,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "TestReport", client, handle_response)
}

pub fn testreport_search_bundled(
  search_for search_args: r4_sansio.SpTestreport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.testreport_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn testreport_search(
  search_for search_args: r4_sansio.SpTestreport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Testreport), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.testreport_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.testreport },
  )
}

pub fn testscript_create(
  resource: r4.Testscript,
  client: FhirClient,
  handle_response: fn(Result(r4.Testscript, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.testscript_to_json(resource),
    "TestScript",
    r4.testscript_decoder(),
    client,
    handle_response,
  )
}

pub fn testscript_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Testscript, Err)) -> a,
) -> Effect(a) {
  any_read(id, "TestScript", r4.testscript_decoder(), client, handle_response)
}

pub fn testscript_update(
  resource: r4.Testscript,
  client: FhirClient,
  handle_response: fn(Result(r4.Testscript, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.testscript_to_json(resource),
    "TestScript",
    r4.testscript_decoder(),
    client,
    handle_response,
  )
}

pub fn testscript_delete(
  resource: r4.Testscript,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "TestScript", client, handle_response)
}

pub fn testscript_search_bundled(
  search_for search_args: r4_sansio.SpTestscript,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.testscript_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn testscript_search(
  search_for search_args: r4_sansio.SpTestscript,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Testscript), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.testscript_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.testscript },
  )
}

pub fn valueset_create(
  resource: r4.Valueset,
  client: FhirClient,
  handle_response: fn(Result(r4.Valueset, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.valueset_to_json(resource),
    "ValueSet",
    r4.valueset_decoder(),
    client,
    handle_response,
  )
}

pub fn valueset_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Valueset, Err)) -> a,
) -> Effect(a) {
  any_read(id, "ValueSet", r4.valueset_decoder(), client, handle_response)
}

pub fn valueset_update(
  resource: r4.Valueset,
  client: FhirClient,
  handle_response: fn(Result(r4.Valueset, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.valueset_to_json(resource),
    "ValueSet",
    r4.valueset_decoder(),
    client,
    handle_response,
  )
}

pub fn valueset_delete(
  resource: r4.Valueset,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ValueSet", client, handle_response)
}

pub fn valueset_search_bundled(
  search_for search_args: r4_sansio.SpValueset,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.valueset_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn valueset_search(
  search_for search_args: r4_sansio.SpValueset,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Valueset), Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.valueset_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.valueset },
  )
}

pub fn verificationresult_create(
  resource: r4.Verificationresult,
  client: FhirClient,
  handle_response: fn(Result(r4.Verificationresult, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.verificationresult_to_json(resource),
    "VerificationResult",
    r4.verificationresult_decoder(),
    client,
    handle_response,
  )
}

pub fn verificationresult_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Verificationresult, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "VerificationResult",
    r4.verificationresult_decoder(),
    client,
    handle_response,
  )
}

pub fn verificationresult_update(
  resource: r4.Verificationresult,
  client: FhirClient,
  handle_response: fn(Result(r4.Verificationresult, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.verificationresult_to_json(resource),
    "VerificationResult",
    r4.verificationresult_decoder(),
    client,
    handle_response,
  )
}

pub fn verificationresult_delete(
  resource: r4.Verificationresult,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "VerificationResult", client, handle_response)
}

pub fn verificationresult_search_bundled(
  search_for search_args: r4_sansio.SpVerificationresult,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.verificationresult_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn verificationresult_search(
  search_for search_args: r4_sansio.SpVerificationresult,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Verificationresult), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.verificationresult_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.verificationresult
    },
  )
}

pub fn visionprescription_create(
  resource: r4.Visionprescription,
  client: FhirClient,
  handle_response: fn(Result(r4.Visionprescription, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4.visionprescription_to_json(resource),
    "VisionPrescription",
    r4.visionprescription_decoder(),
    client,
    handle_response,
  )
}

pub fn visionprescription_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4.Visionprescription, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "VisionPrescription",
    r4.visionprescription_decoder(),
    client,
    handle_response,
  )
}

pub fn visionprescription_update(
  resource: r4.Visionprescription,
  client: FhirClient,
  handle_response: fn(Result(r4.Visionprescription, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4.visionprescription_to_json(resource),
    "VisionPrescription",
    r4.visionprescription_decoder(),
    client,
    handle_response,
  )
}

pub fn visionprescription_delete(
  resource: r4.Visionprescription,
  client: FhirClient,
  handle_response: fn(Result(r4.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "VisionPrescription", client, handle_response)
}

pub fn visionprescription_search_bundled(
  search_for search_args: r4_sansio.SpVisionprescription,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.visionprescription_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn visionprescription_search(
  search_for search_args: r4_sansio.SpVisionprescription,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Visionprescription), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4_sansio.visionprescription_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4_sansio.bundle_to_groupedresources }.visionprescription
    },
  )
}
