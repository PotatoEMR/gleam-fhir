////[https://hl7.org/fhir/r4us](https://hl7.org/fhir/r4us) r4us client using rsvp

import fhir/r4us
import fhir/r4us_sansio
import gleam/dynamic/decode.{type Decoder}
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/json.{type Json}
import gleam/option.{type Option}
import lustre/effect.{type Effect}
import rsvp

/// FHIR client for sending http requests to server such as
/// `let read_pat_effect = r4us_rsvp.patient_read("123", client, msg)`
///
/// create client from server base url with fhirclient_new(baseurl)`
///
/// `let assert Ok(client) = r4us_rsvp.fhirclient_new("r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = r4us_rsvp.fhirclient_new("https://r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = r4us_rsvp.fhirclient_new("https://hapi.fhir.org/baseR4")`
///
/// `let assert Ok(client) = r4us_rsvp.fhirclient_new("127.0.0.1:8000")`
pub type FhirClient =
  r4us_sansio.FhirClient

/// creates a new client from server base url
///
/// `let assert Ok(client) = r4us_rsvp.fhirclient_new("r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = r4us_rsvp.fhirclient_new("https://r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = r4us_rsvp.fhirclient_new("https://hapi.fhir.org/baseR4")`
///
/// `let assert Ok(client) = r4us_rsvp.fhirclient_new("127.0.0.1:8000")`
pub fn fhirclient_new(
  baseurl: String,
) -> Result(FhirClient, r4us_sansio.ErrBaseUrl) {
  r4us_sansio.fhirclient_new(baseurl)
}

pub type Err {
  ErrRsvp(err: rsvp.Error)
  ErrSansio(err: r4us_sansio.Err)
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
  let req = r4us_sansio.any_create_req(resource, res_type, client)
  sendreq_handleresponse(req, resource_dec, handle_response)
}

fn any_read(
  id: String,
  res_type: String,
  resource_dec: Decoder(r),
  client: FhirClient,
  handle_response: fn(Result(r, Err)) -> a,
) -> Effect(a) {
  let req = r4us_sansio.any_read_req(id, res_type, client)
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
  let req = r4us_sansio.any_update_req(id, resource, res_type, client)
  case req {
    Ok(req) -> Ok(sendreq_handleresponse(req, resource_dec, handle_response))
    // from rsvp's point of view it would make more sense to split sansio error into 2 separate errors
    // since user creates request and gets effect or error, then sends and gets response or error
    // ie you know first error must be creating error, and second must be http or parsing error
    // that said, currently you can only get error creating request from calling update/delete on resource with no id
    // so maybe it's easy to ignore all of this
    Error(_) -> Error(ErrNoId)
  }
}

fn any_delete(
  id: Option(String),
  res_type: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  let req = r4us_sansio.any_delete_req(id, res_type, client)
  case req {
    Ok(req) ->
      Ok(sendreq_handleresponse(
        req,
        r4us.operationoutcome_decoder(),
        handle_response,
      ))
    // from rsvp's point of view it would make more sense to split sansio error into 2 separate errors
    // since user creates request and gets effect or error, then sends and gets response or error
    // ie you know first error must be creating error, and second must be http or parsing error
    // that said, currently you can only get error creating request from calling update/delete on resource with no id
    // so maybe it's easy to ignore all of this
    Error(_) -> Error(ErrNoId)
  }
}

/// write out search string manually, in case typed search params don't work
pub fn search_any(
  search_string: String,
  res_type: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.any_search_req(search_string, res_type, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

// run any operation string on any resource string, optionally using Parameters
pub fn operation_any(
  params params: Option(r4us.Parameters),
  operation_name operation_name: String,
  res_type res_type: String,
  res_id res_id: Option(String),
  res_decoder res_decoder: Decoder(res),
  client client: FhirClient,
  handle_response handle_response: fn(Result(res, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.any_operation_req(
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
        case r4us_sansio.any_resp(resp_res, res_dec) {
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
  resource: r4us.Account,
  client: FhirClient,
  handle_response: fn(Result(r4us.Account, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.account_to_json(resource),
    "Account",
    r4us.account_decoder(),
    client,
    handle_response,
  )
}

pub fn account_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Account, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Account", r4us.account_decoder(), client, handle_response)
}

pub fn account_update(
  resource: r4us.Account,
  client: FhirClient,
  handle_response: fn(Result(r4us.Account, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.account_to_json(resource),
    "Account",
    r4us.account_decoder(),
    client,
    handle_response,
  )
}

pub fn account_delete(
  resource: r4us.Account,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Account", client, handle_response)
}

pub fn account_search_bundled(
  search_for search_args: r4us_sansio.SpAccount,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.account_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn account_search(
  search_for search_args: r4us_sansio.SpAccount,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Account), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.account_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4us_sansio.bundle_to_groupedresources }.account },
  )
}

pub fn activitydefinition_create(
  resource: r4us.Activitydefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Activitydefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.activitydefinition_to_json(resource),
    "ActivityDefinition",
    r4us.activitydefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn activitydefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Activitydefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ActivityDefinition",
    r4us.activitydefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn activitydefinition_update(
  resource: r4us.Activitydefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Activitydefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.activitydefinition_to_json(resource),
    "ActivityDefinition",
    r4us.activitydefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn activitydefinition_delete(
  resource: r4us.Activitydefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ActivityDefinition", client, handle_response)
}

pub fn activitydefinition_search_bundled(
  search_for search_args: r4us_sansio.SpActivitydefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.activitydefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn activitydefinition_search(
  search_for search_args: r4us_sansio.SpActivitydefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Activitydefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.activitydefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.activitydefinition
    },
  )
}

pub fn adverseevent_create(
  resource: r4us.Adverseevent,
  client: FhirClient,
  handle_response: fn(Result(r4us.Adverseevent, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.adverseevent_to_json(resource),
    "AdverseEvent",
    r4us.adverseevent_decoder(),
    client,
    handle_response,
  )
}

pub fn adverseevent_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Adverseevent, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "AdverseEvent",
    r4us.adverseevent_decoder(),
    client,
    handle_response,
  )
}

pub fn adverseevent_update(
  resource: r4us.Adverseevent,
  client: FhirClient,
  handle_response: fn(Result(r4us.Adverseevent, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.adverseevent_to_json(resource),
    "AdverseEvent",
    r4us.adverseevent_decoder(),
    client,
    handle_response,
  )
}

pub fn adverseevent_delete(
  resource: r4us.Adverseevent,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "AdverseEvent", client, handle_response)
}

pub fn adverseevent_search_bundled(
  search_for search_args: r4us_sansio.SpAdverseevent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.adverseevent_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn adverseevent_search(
  search_for search_args: r4us_sansio.SpAdverseevent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Adverseevent), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.adverseevent_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.adverseevent
    },
  )
}

pub fn us_core_allergyintolerance_create(
  resource: r4us.UsCoreAllergyintolerance,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreAllergyintolerance, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    r4us.us_core_allergyintolerance_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_allergyintolerance_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreAllergyintolerance, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "AllergyIntolerance",
    r4us.us_core_allergyintolerance_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_allergyintolerance_update(
  resource: r4us.UsCoreAllergyintolerance,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreAllergyintolerance, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    r4us.us_core_allergyintolerance_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_allergyintolerance_delete(
  resource: r4us.UsCoreAllergyintolerance,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "AllergyIntolerance", client, handle_response)
}

pub fn us_core_allergyintolerance_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreAllergyintolerance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_allergyintolerance_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_allergyintolerance_search(
  search_for search_args: r4us_sansio.SpUsCoreAllergyintolerance,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.UsCoreAllergyintolerance), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_allergyintolerance_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_allergyintolerance
    },
  )
}

pub fn appointment_create(
  resource: r4us.Appointment,
  client: FhirClient,
  handle_response: fn(Result(r4us.Appointment, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.appointment_to_json(resource),
    "Appointment",
    r4us.appointment_decoder(),
    client,
    handle_response,
  )
}

pub fn appointment_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Appointment, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Appointment",
    r4us.appointment_decoder(),
    client,
    handle_response,
  )
}

pub fn appointment_update(
  resource: r4us.Appointment,
  client: FhirClient,
  handle_response: fn(Result(r4us.Appointment, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.appointment_to_json(resource),
    "Appointment",
    r4us.appointment_decoder(),
    client,
    handle_response,
  )
}

pub fn appointment_delete(
  resource: r4us.Appointment,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Appointment", client, handle_response)
}

pub fn appointment_search_bundled(
  search_for search_args: r4us_sansio.SpAppointment,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.appointment_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn appointment_search(
  search_for search_args: r4us_sansio.SpAppointment,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Appointment), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.appointment_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.appointment
    },
  )
}

pub fn appointmentresponse_create(
  resource: r4us.Appointmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r4us.Appointmentresponse, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.appointmentresponse_to_json(resource),
    "AppointmentResponse",
    r4us.appointmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn appointmentresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Appointmentresponse, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "AppointmentResponse",
    r4us.appointmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn appointmentresponse_update(
  resource: r4us.Appointmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r4us.Appointmentresponse, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.appointmentresponse_to_json(resource),
    "AppointmentResponse",
    r4us.appointmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn appointmentresponse_delete(
  resource: r4us.Appointmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "AppointmentResponse", client, handle_response)
}

pub fn appointmentresponse_search_bundled(
  search_for search_args: r4us_sansio.SpAppointmentresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.appointmentresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn appointmentresponse_search(
  search_for search_args: r4us_sansio.SpAppointmentresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Appointmentresponse), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.appointmentresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.appointmentresponse
    },
  )
}

pub fn auditevent_create(
  resource: r4us.Auditevent,
  client: FhirClient,
  handle_response: fn(Result(r4us.Auditevent, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.auditevent_to_json(resource),
    "AuditEvent",
    r4us.auditevent_decoder(),
    client,
    handle_response,
  )
}

pub fn auditevent_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Auditevent, Err)) -> a,
) -> Effect(a) {
  any_read(id, "AuditEvent", r4us.auditevent_decoder(), client, handle_response)
}

pub fn auditevent_update(
  resource: r4us.Auditevent,
  client: FhirClient,
  handle_response: fn(Result(r4us.Auditevent, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.auditevent_to_json(resource),
    "AuditEvent",
    r4us.auditevent_decoder(),
    client,
    handle_response,
  )
}

pub fn auditevent_delete(
  resource: r4us.Auditevent,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "AuditEvent", client, handle_response)
}

pub fn auditevent_search_bundled(
  search_for search_args: r4us_sansio.SpAuditevent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.auditevent_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn auditevent_search(
  search_for search_args: r4us_sansio.SpAuditevent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Auditevent), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.auditevent_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.auditevent
    },
  )
}

pub fn basic_create(
  resource: r4us.Basic,
  client: FhirClient,
  handle_response: fn(Result(r4us.Basic, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.basic_to_json(resource),
    "Basic",
    r4us.basic_decoder(),
    client,
    handle_response,
  )
}

pub fn basic_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Basic, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Basic", r4us.basic_decoder(), client, handle_response)
}

pub fn basic_update(
  resource: r4us.Basic,
  client: FhirClient,
  handle_response: fn(Result(r4us.Basic, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.basic_to_json(resource),
    "Basic",
    r4us.basic_decoder(),
    client,
    handle_response,
  )
}

pub fn basic_delete(
  resource: r4us.Basic,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Basic", client, handle_response)
}

pub fn basic_search_bundled(
  search_for search_args: r4us_sansio.SpBasic,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.basic_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn basic_search(
  search_for search_args: r4us_sansio.SpBasic,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Basic), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.basic_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4us_sansio.bundle_to_groupedresources }.basic },
  )
}

pub fn binary_create(
  resource: r4us.Binary,
  client: FhirClient,
  handle_response: fn(Result(r4us.Binary, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.binary_to_json(resource),
    "Binary",
    r4us.binary_decoder(),
    client,
    handle_response,
  )
}

pub fn binary_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Binary, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Binary", r4us.binary_decoder(), client, handle_response)
}

pub fn binary_update(
  resource: r4us.Binary,
  client: FhirClient,
  handle_response: fn(Result(r4us.Binary, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.binary_to_json(resource),
    "Binary",
    r4us.binary_decoder(),
    client,
    handle_response,
  )
}

pub fn binary_delete(
  resource: r4us.Binary,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Binary", client, handle_response)
}

pub fn binary_search_bundled(
  search_for search_args: r4us_sansio.SpBinary,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.binary_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn binary_search(
  search_for search_args: r4us_sansio.SpBinary,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Binary), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.binary_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4us_sansio.bundle_to_groupedresources }.binary },
  )
}

pub fn biologicallyderivedproduct_create(
  resource: r4us.Biologicallyderivedproduct,
  client: FhirClient,
  handle_response: fn(Result(r4us.Biologicallyderivedproduct, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.biologicallyderivedproduct_to_json(resource),
    "BiologicallyDerivedProduct",
    r4us.biologicallyderivedproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn biologicallyderivedproduct_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Biologicallyderivedproduct, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "BiologicallyDerivedProduct",
    r4us.biologicallyderivedproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn biologicallyderivedproduct_update(
  resource: r4us.Biologicallyderivedproduct,
  client: FhirClient,
  handle_response: fn(Result(r4us.Biologicallyderivedproduct, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.biologicallyderivedproduct_to_json(resource),
    "BiologicallyDerivedProduct",
    r4us.biologicallyderivedproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn biologicallyderivedproduct_delete(
  resource: r4us.Biologicallyderivedproduct,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "BiologicallyDerivedProduct", client, handle_response)
}

pub fn biologicallyderivedproduct_search_bundled(
  search_for search_args: r4us_sansio.SpBiologicallyderivedproduct,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.biologicallyderivedproduct_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn biologicallyderivedproduct_search(
  search_for search_args: r4us_sansio.SpBiologicallyderivedproduct,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.Biologicallyderivedproduct), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.biologicallyderivedproduct_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.biologicallyderivedproduct
    },
  )
}

pub fn bodystructure_create(
  resource: r4us.Bodystructure,
  client: FhirClient,
  handle_response: fn(Result(r4us.Bodystructure, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.bodystructure_to_json(resource),
    "BodyStructure",
    r4us.bodystructure_decoder(),
    client,
    handle_response,
  )
}

pub fn bodystructure_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Bodystructure, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "BodyStructure",
    r4us.bodystructure_decoder(),
    client,
    handle_response,
  )
}

pub fn bodystructure_update(
  resource: r4us.Bodystructure,
  client: FhirClient,
  handle_response: fn(Result(r4us.Bodystructure, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.bodystructure_to_json(resource),
    "BodyStructure",
    r4us.bodystructure_decoder(),
    client,
    handle_response,
  )
}

pub fn bodystructure_delete(
  resource: r4us.Bodystructure,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "BodyStructure", client, handle_response)
}

pub fn bodystructure_search_bundled(
  search_for search_args: r4us_sansio.SpBodystructure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.bodystructure_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn bodystructure_search(
  search_for search_args: r4us_sansio.SpBodystructure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Bodystructure), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.bodystructure_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.bodystructure
    },
  )
}

pub fn bundle_create(
  resource: r4us.Bundle,
  client: FhirClient,
  handle_response: fn(Result(r4us.Bundle, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.bundle_to_json(resource),
    "Bundle",
    r4us.bundle_decoder(),
    client,
    handle_response,
  )
}

pub fn bundle_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Bundle, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Bundle", r4us.bundle_decoder(), client, handle_response)
}

pub fn bundle_update(
  resource: r4us.Bundle,
  client: FhirClient,
  handle_response: fn(Result(r4us.Bundle, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.bundle_to_json(resource),
    "Bundle",
    r4us.bundle_decoder(),
    client,
    handle_response,
  )
}

pub fn bundle_delete(
  resource: r4us.Bundle,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Bundle", client, handle_response)
}

pub fn bundle_search_bundled(
  search_for search_args: r4us_sansio.SpBundle,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.bundle_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn bundle_search(
  search_for search_args: r4us_sansio.SpBundle,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Bundle), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.bundle_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4us_sansio.bundle_to_groupedresources }.bundle },
  )
}

pub fn capabilitystatement_create(
  resource: r4us.Capabilitystatement,
  client: FhirClient,
  handle_response: fn(Result(r4us.Capabilitystatement, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.capabilitystatement_to_json(resource),
    "CapabilityStatement",
    r4us.capabilitystatement_decoder(),
    client,
    handle_response,
  )
}

pub fn capabilitystatement_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Capabilitystatement, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CapabilityStatement",
    r4us.capabilitystatement_decoder(),
    client,
    handle_response,
  )
}

pub fn capabilitystatement_update(
  resource: r4us.Capabilitystatement,
  client: FhirClient,
  handle_response: fn(Result(r4us.Capabilitystatement, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.capabilitystatement_to_json(resource),
    "CapabilityStatement",
    r4us.capabilitystatement_decoder(),
    client,
    handle_response,
  )
}

pub fn capabilitystatement_delete(
  resource: r4us.Capabilitystatement,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CapabilityStatement", client, handle_response)
}

pub fn capabilitystatement_search_bundled(
  search_for search_args: r4us_sansio.SpCapabilitystatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.capabilitystatement_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn capabilitystatement_search(
  search_for search_args: r4us_sansio.SpCapabilitystatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Capabilitystatement), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.capabilitystatement_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.capabilitystatement
    },
  )
}

pub fn us_core_careplan_create(
  resource: r4us.UsCoreCareplan,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreCareplan, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_careplan_to_json(resource),
    "CarePlan",
    r4us.us_core_careplan_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_careplan_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreCareplan, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CarePlan",
    r4us.us_core_careplan_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_careplan_update(
  resource: r4us.UsCoreCareplan,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreCareplan, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_careplan_to_json(resource),
    "CarePlan",
    r4us.us_core_careplan_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_careplan_delete(
  resource: r4us.UsCoreCareplan,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CarePlan", client, handle_response)
}

pub fn us_core_careplan_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreCareplan,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_careplan_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_careplan_search(
  search_for search_args: r4us_sansio.SpUsCoreCareplan,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.UsCoreCareplan), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_careplan_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_careplan
    },
  )
}

pub fn us_core_careteam_create(
  resource: r4us.UsCoreCareteam,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreCareteam, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_careteam_to_json(resource),
    "CareTeam",
    r4us.us_core_careteam_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_careteam_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreCareteam, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CareTeam",
    r4us.us_core_careteam_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_careteam_update(
  resource: r4us.UsCoreCareteam,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreCareteam, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_careteam_to_json(resource),
    "CareTeam",
    r4us.us_core_careteam_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_careteam_delete(
  resource: r4us.UsCoreCareteam,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CareTeam", client, handle_response)
}

pub fn us_core_careteam_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreCareteam,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_careteam_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_careteam_search(
  search_for search_args: r4us_sansio.SpUsCoreCareteam,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.UsCoreCareteam), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_careteam_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_careteam
    },
  )
}

pub fn catalogentry_create(
  resource: r4us.Catalogentry,
  client: FhirClient,
  handle_response: fn(Result(r4us.Catalogentry, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.catalogentry_to_json(resource),
    "CatalogEntry",
    r4us.catalogentry_decoder(),
    client,
    handle_response,
  )
}

pub fn catalogentry_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Catalogentry, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CatalogEntry",
    r4us.catalogentry_decoder(),
    client,
    handle_response,
  )
}

pub fn catalogentry_update(
  resource: r4us.Catalogentry,
  client: FhirClient,
  handle_response: fn(Result(r4us.Catalogentry, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.catalogentry_to_json(resource),
    "CatalogEntry",
    r4us.catalogentry_decoder(),
    client,
    handle_response,
  )
}

pub fn catalogentry_delete(
  resource: r4us.Catalogentry,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CatalogEntry", client, handle_response)
}

pub fn catalogentry_search_bundled(
  search_for search_args: r4us_sansio.SpCatalogentry,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.catalogentry_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn catalogentry_search(
  search_for search_args: r4us_sansio.SpCatalogentry,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Catalogentry), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.catalogentry_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.catalogentry
    },
  )
}

pub fn chargeitem_create(
  resource: r4us.Chargeitem,
  client: FhirClient,
  handle_response: fn(Result(r4us.Chargeitem, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.chargeitem_to_json(resource),
    "ChargeItem",
    r4us.chargeitem_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitem_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Chargeitem, Err)) -> a,
) -> Effect(a) {
  any_read(id, "ChargeItem", r4us.chargeitem_decoder(), client, handle_response)
}

pub fn chargeitem_update(
  resource: r4us.Chargeitem,
  client: FhirClient,
  handle_response: fn(Result(r4us.Chargeitem, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.chargeitem_to_json(resource),
    "ChargeItem",
    r4us.chargeitem_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitem_delete(
  resource: r4us.Chargeitem,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ChargeItem", client, handle_response)
}

pub fn chargeitem_search_bundled(
  search_for search_args: r4us_sansio.SpChargeitem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.chargeitem_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn chargeitem_search(
  search_for search_args: r4us_sansio.SpChargeitem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Chargeitem), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.chargeitem_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.chargeitem
    },
  )
}

pub fn chargeitemdefinition_create(
  resource: r4us.Chargeitemdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Chargeitemdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.chargeitemdefinition_to_json(resource),
    "ChargeItemDefinition",
    r4us.chargeitemdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitemdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Chargeitemdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ChargeItemDefinition",
    r4us.chargeitemdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitemdefinition_update(
  resource: r4us.Chargeitemdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Chargeitemdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.chargeitemdefinition_to_json(resource),
    "ChargeItemDefinition",
    r4us.chargeitemdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitemdefinition_delete(
  resource: r4us.Chargeitemdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ChargeItemDefinition", client, handle_response)
}

pub fn chargeitemdefinition_search_bundled(
  search_for search_args: r4us_sansio.SpChargeitemdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.chargeitemdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn chargeitemdefinition_search(
  search_for search_args: r4us_sansio.SpChargeitemdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Chargeitemdefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.chargeitemdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.chargeitemdefinition
    },
  )
}

pub fn claim_create(
  resource: r4us.Claim,
  client: FhirClient,
  handle_response: fn(Result(r4us.Claim, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.claim_to_json(resource),
    "Claim",
    r4us.claim_decoder(),
    client,
    handle_response,
  )
}

pub fn claim_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Claim, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Claim", r4us.claim_decoder(), client, handle_response)
}

pub fn claim_update(
  resource: r4us.Claim,
  client: FhirClient,
  handle_response: fn(Result(r4us.Claim, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.claim_to_json(resource),
    "Claim",
    r4us.claim_decoder(),
    client,
    handle_response,
  )
}

pub fn claim_delete(
  resource: r4us.Claim,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Claim", client, handle_response)
}

pub fn claim_search_bundled(
  search_for search_args: r4us_sansio.SpClaim,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.claim_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn claim_search(
  search_for search_args: r4us_sansio.SpClaim,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Claim), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.claim_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4us_sansio.bundle_to_groupedresources }.claim },
  )
}

pub fn claimresponse_create(
  resource: r4us.Claimresponse,
  client: FhirClient,
  handle_response: fn(Result(r4us.Claimresponse, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.claimresponse_to_json(resource),
    "ClaimResponse",
    r4us.claimresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn claimresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Claimresponse, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ClaimResponse",
    r4us.claimresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn claimresponse_update(
  resource: r4us.Claimresponse,
  client: FhirClient,
  handle_response: fn(Result(r4us.Claimresponse, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.claimresponse_to_json(resource),
    "ClaimResponse",
    r4us.claimresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn claimresponse_delete(
  resource: r4us.Claimresponse,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ClaimResponse", client, handle_response)
}

pub fn claimresponse_search_bundled(
  search_for search_args: r4us_sansio.SpClaimresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.claimresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn claimresponse_search(
  search_for search_args: r4us_sansio.SpClaimresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Claimresponse), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.claimresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.claimresponse
    },
  )
}

pub fn clinicalimpression_create(
  resource: r4us.Clinicalimpression,
  client: FhirClient,
  handle_response: fn(Result(r4us.Clinicalimpression, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.clinicalimpression_to_json(resource),
    "ClinicalImpression",
    r4us.clinicalimpression_decoder(),
    client,
    handle_response,
  )
}

pub fn clinicalimpression_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Clinicalimpression, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ClinicalImpression",
    r4us.clinicalimpression_decoder(),
    client,
    handle_response,
  )
}

pub fn clinicalimpression_update(
  resource: r4us.Clinicalimpression,
  client: FhirClient,
  handle_response: fn(Result(r4us.Clinicalimpression, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.clinicalimpression_to_json(resource),
    "ClinicalImpression",
    r4us.clinicalimpression_decoder(),
    client,
    handle_response,
  )
}

pub fn clinicalimpression_delete(
  resource: r4us.Clinicalimpression,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ClinicalImpression", client, handle_response)
}

pub fn clinicalimpression_search_bundled(
  search_for search_args: r4us_sansio.SpClinicalimpression,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.clinicalimpression_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn clinicalimpression_search(
  search_for search_args: r4us_sansio.SpClinicalimpression,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Clinicalimpression), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.clinicalimpression_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.clinicalimpression
    },
  )
}

pub fn codesystem_create(
  resource: r4us.Codesystem,
  client: FhirClient,
  handle_response: fn(Result(r4us.Codesystem, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.codesystem_to_json(resource),
    "CodeSystem",
    r4us.codesystem_decoder(),
    client,
    handle_response,
  )
}

pub fn codesystem_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Codesystem, Err)) -> a,
) -> Effect(a) {
  any_read(id, "CodeSystem", r4us.codesystem_decoder(), client, handle_response)
}

pub fn codesystem_update(
  resource: r4us.Codesystem,
  client: FhirClient,
  handle_response: fn(Result(r4us.Codesystem, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.codesystem_to_json(resource),
    "CodeSystem",
    r4us.codesystem_decoder(),
    client,
    handle_response,
  )
}

pub fn codesystem_delete(
  resource: r4us.Codesystem,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CodeSystem", client, handle_response)
}

pub fn codesystem_search_bundled(
  search_for search_args: r4us_sansio.SpCodesystem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.codesystem_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn codesystem_search(
  search_for search_args: r4us_sansio.SpCodesystem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Codesystem), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.codesystem_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.codesystem
    },
  )
}

pub fn communication_create(
  resource: r4us.Communication,
  client: FhirClient,
  handle_response: fn(Result(r4us.Communication, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.communication_to_json(resource),
    "Communication",
    r4us.communication_decoder(),
    client,
    handle_response,
  )
}

pub fn communication_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Communication, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Communication",
    r4us.communication_decoder(),
    client,
    handle_response,
  )
}

pub fn communication_update(
  resource: r4us.Communication,
  client: FhirClient,
  handle_response: fn(Result(r4us.Communication, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.communication_to_json(resource),
    "Communication",
    r4us.communication_decoder(),
    client,
    handle_response,
  )
}

pub fn communication_delete(
  resource: r4us.Communication,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Communication", client, handle_response)
}

pub fn communication_search_bundled(
  search_for search_args: r4us_sansio.SpCommunication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.communication_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn communication_search(
  search_for search_args: r4us_sansio.SpCommunication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Communication), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.communication_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.communication
    },
  )
}

pub fn communicationrequest_create(
  resource: r4us.Communicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r4us.Communicationrequest, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.communicationrequest_to_json(resource),
    "CommunicationRequest",
    r4us.communicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn communicationrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Communicationrequest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CommunicationRequest",
    r4us.communicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn communicationrequest_update(
  resource: r4us.Communicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r4us.Communicationrequest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.communicationrequest_to_json(resource),
    "CommunicationRequest",
    r4us.communicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn communicationrequest_delete(
  resource: r4us.Communicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CommunicationRequest", client, handle_response)
}

pub fn communicationrequest_search_bundled(
  search_for search_args: r4us_sansio.SpCommunicationrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.communicationrequest_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn communicationrequest_search(
  search_for search_args: r4us_sansio.SpCommunicationrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Communicationrequest), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.communicationrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.communicationrequest
    },
  )
}

pub fn compartmentdefinition_create(
  resource: r4us.Compartmentdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Compartmentdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.compartmentdefinition_to_json(resource),
    "CompartmentDefinition",
    r4us.compartmentdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn compartmentdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Compartmentdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CompartmentDefinition",
    r4us.compartmentdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn compartmentdefinition_update(
  resource: r4us.Compartmentdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Compartmentdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.compartmentdefinition_to_json(resource),
    "CompartmentDefinition",
    r4us.compartmentdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn compartmentdefinition_delete(
  resource: r4us.Compartmentdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CompartmentDefinition", client, handle_response)
}

pub fn compartmentdefinition_search_bundled(
  search_for search_args: r4us_sansio.SpCompartmentdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.compartmentdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn compartmentdefinition_search(
  search_for search_args: r4us_sansio.SpCompartmentdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.Compartmentdefinition), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.compartmentdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.compartmentdefinition
    },
  )
}

pub fn composition_create(
  resource: r4us.Composition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Composition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.composition_to_json(resource),
    "Composition",
    r4us.composition_decoder(),
    client,
    handle_response,
  )
}

pub fn composition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Composition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Composition",
    r4us.composition_decoder(),
    client,
    handle_response,
  )
}

pub fn composition_update(
  resource: r4us.Composition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Composition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.composition_to_json(resource),
    "Composition",
    r4us.composition_decoder(),
    client,
    handle_response,
  )
}

pub fn composition_delete(
  resource: r4us.Composition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Composition", client, handle_response)
}

pub fn composition_search_bundled(
  search_for search_args: r4us_sansio.SpComposition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.composition_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn composition_search(
  search_for search_args: r4us_sansio.SpComposition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Composition), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.composition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.composition
    },
  )
}

pub fn conceptmap_create(
  resource: r4us.Conceptmap,
  client: FhirClient,
  handle_response: fn(Result(r4us.Conceptmap, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.conceptmap_to_json(resource),
    "ConceptMap",
    r4us.conceptmap_decoder(),
    client,
    handle_response,
  )
}

pub fn conceptmap_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Conceptmap, Err)) -> a,
) -> Effect(a) {
  any_read(id, "ConceptMap", r4us.conceptmap_decoder(), client, handle_response)
}

pub fn conceptmap_update(
  resource: r4us.Conceptmap,
  client: FhirClient,
  handle_response: fn(Result(r4us.Conceptmap, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.conceptmap_to_json(resource),
    "ConceptMap",
    r4us.conceptmap_decoder(),
    client,
    handle_response,
  )
}

pub fn conceptmap_delete(
  resource: r4us.Conceptmap,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ConceptMap", client, handle_response)
}

pub fn conceptmap_search_bundled(
  search_for search_args: r4us_sansio.SpConceptmap,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.conceptmap_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn conceptmap_search(
  search_for search_args: r4us_sansio.SpConceptmap,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Conceptmap), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.conceptmap_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.conceptmap
    },
  )
}

pub fn us_core_condition_encounter_diagnosis_create(
  resource: r4us.UsCoreConditionEncounterDiagnosis,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreConditionEncounterDiagnosis, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_condition_encounter_diagnosis_to_json(resource),
    "Condition",
    r4us.us_core_condition_encounter_diagnosis_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_condition_encounter_diagnosis_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreConditionEncounterDiagnosis, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Condition",
    r4us.us_core_condition_encounter_diagnosis_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_condition_encounter_diagnosis_update(
  resource: r4us.UsCoreConditionEncounterDiagnosis,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreConditionEncounterDiagnosis, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_condition_encounter_diagnosis_to_json(resource),
    "Condition",
    r4us.us_core_condition_encounter_diagnosis_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_condition_encounter_diagnosis_delete(
  resource: r4us.UsCoreConditionEncounterDiagnosis,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Condition", client, handle_response)
}

pub fn us_core_condition_encounter_diagnosis_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreConditionEncounterDiagnosis,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_condition_encounter_diagnosis_search_req(
      search_args,
      client,
    )
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_condition_encounter_diagnosis_search(
  search_for search_args: r4us_sansio.SpUsCoreConditionEncounterDiagnosis,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.UsCoreConditionEncounterDiagnosis), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_condition_encounter_diagnosis_search_req(
      search_args,
      client,
    )
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_condition_encounter_diagnosis
    },
  )
}

pub fn us_core_condition_problems_health_concerns_create(
  resource: r4us.UsCoreConditionProblemsHealthConcerns,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreConditionProblemsHealthConcerns, Err)) ->
    a,
) -> Effect(a) {
  any_create(
    r4us.us_core_condition_problems_health_concerns_to_json(resource),
    "Condition",
    r4us.us_core_condition_problems_health_concerns_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_condition_problems_health_concerns_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreConditionProblemsHealthConcerns, Err)) ->
    a,
) -> Effect(a) {
  any_read(
    id,
    "Condition",
    r4us.us_core_condition_problems_health_concerns_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_condition_problems_health_concerns_update(
  resource: r4us.UsCoreConditionProblemsHealthConcerns,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreConditionProblemsHealthConcerns, Err)) ->
    a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_condition_problems_health_concerns_to_json(resource),
    "Condition",
    r4us.us_core_condition_problems_health_concerns_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_condition_problems_health_concerns_delete(
  resource: r4us.UsCoreConditionProblemsHealthConcerns,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Condition", client, handle_response)
}

pub fn us_core_condition_problems_health_concerns_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreConditionProblemsHealthConcerns,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_condition_problems_health_concerns_search_req(
      search_args,
      client,
    )
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_condition_problems_health_concerns_search(
  search_for search_args: r4us_sansio.SpUsCoreConditionProblemsHealthConcerns,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.UsCoreConditionProblemsHealthConcerns), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_condition_problems_health_concerns_search_req(
      search_args,
      client,
    )
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_condition_problems_health_concerns
    },
  )
}

pub fn consent_create(
  resource: r4us.Consent,
  client: FhirClient,
  handle_response: fn(Result(r4us.Consent, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.consent_to_json(resource),
    "Consent",
    r4us.consent_decoder(),
    client,
    handle_response,
  )
}

pub fn consent_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Consent, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Consent", r4us.consent_decoder(), client, handle_response)
}

pub fn consent_update(
  resource: r4us.Consent,
  client: FhirClient,
  handle_response: fn(Result(r4us.Consent, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.consent_to_json(resource),
    "Consent",
    r4us.consent_decoder(),
    client,
    handle_response,
  )
}

pub fn consent_delete(
  resource: r4us.Consent,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Consent", client, handle_response)
}

pub fn consent_search_bundled(
  search_for search_args: r4us_sansio.SpConsent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.consent_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn consent_search(
  search_for search_args: r4us_sansio.SpConsent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Consent), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.consent_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4us_sansio.bundle_to_groupedresources }.consent },
  )
}

pub fn contract_create(
  resource: r4us.Contract,
  client: FhirClient,
  handle_response: fn(Result(r4us.Contract, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.contract_to_json(resource),
    "Contract",
    r4us.contract_decoder(),
    client,
    handle_response,
  )
}

pub fn contract_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Contract, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Contract", r4us.contract_decoder(), client, handle_response)
}

pub fn contract_update(
  resource: r4us.Contract,
  client: FhirClient,
  handle_response: fn(Result(r4us.Contract, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.contract_to_json(resource),
    "Contract",
    r4us.contract_decoder(),
    client,
    handle_response,
  )
}

pub fn contract_delete(
  resource: r4us.Contract,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Contract", client, handle_response)
}

pub fn contract_search_bundled(
  search_for search_args: r4us_sansio.SpContract,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.contract_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn contract_search(
  search_for search_args: r4us_sansio.SpContract,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Contract), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.contract_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4us_sansio.bundle_to_groupedresources }.contract },
  )
}

pub fn us_core_coverage_create(
  resource: r4us.UsCoreCoverage,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreCoverage, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_coverage_to_json(resource),
    "Coverage",
    r4us.us_core_coverage_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_coverage_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreCoverage, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Coverage",
    r4us.us_core_coverage_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_coverage_update(
  resource: r4us.UsCoreCoverage,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreCoverage, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_coverage_to_json(resource),
    "Coverage",
    r4us.us_core_coverage_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_coverage_delete(
  resource: r4us.UsCoreCoverage,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Coverage", client, handle_response)
}

pub fn us_core_coverage_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreCoverage,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_coverage_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_coverage_search(
  search_for search_args: r4us_sansio.SpUsCoreCoverage,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.UsCoreCoverage), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_coverage_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_coverage
    },
  )
}

pub fn coverageeligibilityrequest_create(
  resource: r4us.Coverageeligibilityrequest,
  client: FhirClient,
  handle_response: fn(Result(r4us.Coverageeligibilityrequest, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.coverageeligibilityrequest_to_json(resource),
    "CoverageEligibilityRequest",
    r4us.coverageeligibilityrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Coverageeligibilityrequest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CoverageEligibilityRequest",
    r4us.coverageeligibilityrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityrequest_update(
  resource: r4us.Coverageeligibilityrequest,
  client: FhirClient,
  handle_response: fn(Result(r4us.Coverageeligibilityrequest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.coverageeligibilityrequest_to_json(resource),
    "CoverageEligibilityRequest",
    r4us.coverageeligibilityrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityrequest_delete(
  resource: r4us.Coverageeligibilityrequest,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CoverageEligibilityRequest", client, handle_response)
}

pub fn coverageeligibilityrequest_search_bundled(
  search_for search_args: r4us_sansio.SpCoverageeligibilityrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.coverageeligibilityrequest_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn coverageeligibilityrequest_search(
  search_for search_args: r4us_sansio.SpCoverageeligibilityrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.Coverageeligibilityrequest), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.coverageeligibilityrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.coverageeligibilityrequest
    },
  )
}

pub fn coverageeligibilityresponse_create(
  resource: r4us.Coverageeligibilityresponse,
  client: FhirClient,
  handle_response: fn(Result(r4us.Coverageeligibilityresponse, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.coverageeligibilityresponse_to_json(resource),
    "CoverageEligibilityResponse",
    r4us.coverageeligibilityresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Coverageeligibilityresponse, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CoverageEligibilityResponse",
    r4us.coverageeligibilityresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityresponse_update(
  resource: r4us.Coverageeligibilityresponse,
  client: FhirClient,
  handle_response: fn(Result(r4us.Coverageeligibilityresponse, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.coverageeligibilityresponse_to_json(resource),
    "CoverageEligibilityResponse",
    r4us.coverageeligibilityresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityresponse_delete(
  resource: r4us.Coverageeligibilityresponse,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(
    resource.id,
    "CoverageEligibilityResponse",
    client,
    handle_response,
  )
}

pub fn coverageeligibilityresponse_search_bundled(
  search_for search_args: r4us_sansio.SpCoverageeligibilityresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.coverageeligibilityresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn coverageeligibilityresponse_search(
  search_for search_args: r4us_sansio.SpCoverageeligibilityresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.Coverageeligibilityresponse), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.coverageeligibilityresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.coverageeligibilityresponse
    },
  )
}

pub fn detectedissue_create(
  resource: r4us.Detectedissue,
  client: FhirClient,
  handle_response: fn(Result(r4us.Detectedissue, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.detectedissue_to_json(resource),
    "DetectedIssue",
    r4us.detectedissue_decoder(),
    client,
    handle_response,
  )
}

pub fn detectedissue_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Detectedissue, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DetectedIssue",
    r4us.detectedissue_decoder(),
    client,
    handle_response,
  )
}

pub fn detectedissue_update(
  resource: r4us.Detectedissue,
  client: FhirClient,
  handle_response: fn(Result(r4us.Detectedissue, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.detectedissue_to_json(resource),
    "DetectedIssue",
    r4us.detectedissue_decoder(),
    client,
    handle_response,
  )
}

pub fn detectedissue_delete(
  resource: r4us.Detectedissue,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DetectedIssue", client, handle_response)
}

pub fn detectedissue_search_bundled(
  search_for search_args: r4us_sansio.SpDetectedissue,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.detectedissue_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn detectedissue_search(
  search_for search_args: r4us_sansio.SpDetectedissue,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Detectedissue), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.detectedissue_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.detectedissue
    },
  )
}

pub fn us_core_device_create(
  resource: r4us.UsCoreDevice,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreDevice, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_device_to_json(resource),
    "Device",
    r4us.us_core_device_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_device_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreDevice, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Device", r4us.us_core_device_decoder(), client, handle_response)
}

pub fn us_core_device_update(
  resource: r4us.UsCoreDevice,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreDevice, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_device_to_json(resource),
    "Device",
    r4us.us_core_device_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_device_delete(
  resource: r4us.UsCoreDevice,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Device", client, handle_response)
}

pub fn us_core_device_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreDevice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_device_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_device_search(
  search_for search_args: r4us_sansio.SpUsCoreDevice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.UsCoreDevice), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_device_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_device
    },
  )
}

pub fn devicedefinition_create(
  resource: r4us.Devicedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Devicedefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.devicedefinition_to_json(resource),
    "DeviceDefinition",
    r4us.devicedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn devicedefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Devicedefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DeviceDefinition",
    r4us.devicedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn devicedefinition_update(
  resource: r4us.Devicedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Devicedefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.devicedefinition_to_json(resource),
    "DeviceDefinition",
    r4us.devicedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn devicedefinition_delete(
  resource: r4us.Devicedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DeviceDefinition", client, handle_response)
}

pub fn devicedefinition_search_bundled(
  search_for search_args: r4us_sansio.SpDevicedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.devicedefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn devicedefinition_search(
  search_for search_args: r4us_sansio.SpDevicedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Devicedefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.devicedefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.devicedefinition
    },
  )
}

pub fn devicemetric_create(
  resource: r4us.Devicemetric,
  client: FhirClient,
  handle_response: fn(Result(r4us.Devicemetric, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.devicemetric_to_json(resource),
    "DeviceMetric",
    r4us.devicemetric_decoder(),
    client,
    handle_response,
  )
}

pub fn devicemetric_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Devicemetric, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DeviceMetric",
    r4us.devicemetric_decoder(),
    client,
    handle_response,
  )
}

pub fn devicemetric_update(
  resource: r4us.Devicemetric,
  client: FhirClient,
  handle_response: fn(Result(r4us.Devicemetric, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.devicemetric_to_json(resource),
    "DeviceMetric",
    r4us.devicemetric_decoder(),
    client,
    handle_response,
  )
}

pub fn devicemetric_delete(
  resource: r4us.Devicemetric,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DeviceMetric", client, handle_response)
}

pub fn devicemetric_search_bundled(
  search_for search_args: r4us_sansio.SpDevicemetric,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.devicemetric_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn devicemetric_search(
  search_for search_args: r4us_sansio.SpDevicemetric,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Devicemetric), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.devicemetric_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.devicemetric
    },
  )
}

pub fn devicerequest_create(
  resource: r4us.Devicerequest,
  client: FhirClient,
  handle_response: fn(Result(r4us.Devicerequest, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.devicerequest_to_json(resource),
    "DeviceRequest",
    r4us.devicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn devicerequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Devicerequest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DeviceRequest",
    r4us.devicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn devicerequest_update(
  resource: r4us.Devicerequest,
  client: FhirClient,
  handle_response: fn(Result(r4us.Devicerequest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.devicerequest_to_json(resource),
    "DeviceRequest",
    r4us.devicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn devicerequest_delete(
  resource: r4us.Devicerequest,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DeviceRequest", client, handle_response)
}

pub fn devicerequest_search_bundled(
  search_for search_args: r4us_sansio.SpDevicerequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.devicerequest_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn devicerequest_search(
  search_for search_args: r4us_sansio.SpDevicerequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Devicerequest), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.devicerequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.devicerequest
    },
  )
}

pub fn deviceusestatement_create(
  resource: r4us.Deviceusestatement,
  client: FhirClient,
  handle_response: fn(Result(r4us.Deviceusestatement, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.deviceusestatement_to_json(resource),
    "DeviceUseStatement",
    r4us.deviceusestatement_decoder(),
    client,
    handle_response,
  )
}

pub fn deviceusestatement_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Deviceusestatement, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DeviceUseStatement",
    r4us.deviceusestatement_decoder(),
    client,
    handle_response,
  )
}

pub fn deviceusestatement_update(
  resource: r4us.Deviceusestatement,
  client: FhirClient,
  handle_response: fn(Result(r4us.Deviceusestatement, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.deviceusestatement_to_json(resource),
    "DeviceUseStatement",
    r4us.deviceusestatement_decoder(),
    client,
    handle_response,
  )
}

pub fn deviceusestatement_delete(
  resource: r4us.Deviceusestatement,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DeviceUseStatement", client, handle_response)
}

pub fn deviceusestatement_search_bundled(
  search_for search_args: r4us_sansio.SpDeviceusestatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.deviceusestatement_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn deviceusestatement_search(
  search_for search_args: r4us_sansio.SpDeviceusestatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Deviceusestatement), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.deviceusestatement_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.deviceusestatement
    },
  )
}

pub fn us_core_diagnosticreport_lab_create(
  resource: r4us.UsCoreDiagnosticreportLab,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreDiagnosticreportLab, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_diagnosticreport_lab_to_json(resource),
    "DiagnosticReport",
    r4us.us_core_diagnosticreport_lab_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_diagnosticreport_lab_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreDiagnosticreportLab, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DiagnosticReport",
    r4us.us_core_diagnosticreport_lab_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_diagnosticreport_lab_update(
  resource: r4us.UsCoreDiagnosticreportLab,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreDiagnosticreportLab, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_diagnosticreport_lab_to_json(resource),
    "DiagnosticReport",
    r4us.us_core_diagnosticreport_lab_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_diagnosticreport_lab_delete(
  resource: r4us.UsCoreDiagnosticreportLab,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DiagnosticReport", client, handle_response)
}

pub fn us_core_diagnosticreport_lab_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreDiagnosticreportLab,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_diagnosticreport_lab_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_diagnosticreport_lab_search(
  search_for search_args: r4us_sansio.SpUsCoreDiagnosticreportLab,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.UsCoreDiagnosticreportLab), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_diagnosticreport_lab_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_diagnosticreport_lab
    },
  )
}

pub fn us_core_diagnosticreport_note_create(
  resource: r4us.UsCoreDiagnosticreportNote,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreDiagnosticreportNote, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_diagnosticreport_note_to_json(resource),
    "DiagnosticReport",
    r4us.us_core_diagnosticreport_note_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_diagnosticreport_note_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreDiagnosticreportNote, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DiagnosticReport",
    r4us.us_core_diagnosticreport_note_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_diagnosticreport_note_update(
  resource: r4us.UsCoreDiagnosticreportNote,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreDiagnosticreportNote, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_diagnosticreport_note_to_json(resource),
    "DiagnosticReport",
    r4us.us_core_diagnosticreport_note_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_diagnosticreport_note_delete(
  resource: r4us.UsCoreDiagnosticreportNote,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DiagnosticReport", client, handle_response)
}

pub fn us_core_diagnosticreport_note_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreDiagnosticreportNote,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_diagnosticreport_note_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_diagnosticreport_note_search(
  search_for search_args: r4us_sansio.SpUsCoreDiagnosticreportNote,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.UsCoreDiagnosticreportNote), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_diagnosticreport_note_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_diagnosticreport_note
    },
  )
}

pub fn documentmanifest_create(
  resource: r4us.Documentmanifest,
  client: FhirClient,
  handle_response: fn(Result(r4us.Documentmanifest, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.documentmanifest_to_json(resource),
    "DocumentManifest",
    r4us.documentmanifest_decoder(),
    client,
    handle_response,
  )
}

pub fn documentmanifest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Documentmanifest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DocumentManifest",
    r4us.documentmanifest_decoder(),
    client,
    handle_response,
  )
}

pub fn documentmanifest_update(
  resource: r4us.Documentmanifest,
  client: FhirClient,
  handle_response: fn(Result(r4us.Documentmanifest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.documentmanifest_to_json(resource),
    "DocumentManifest",
    r4us.documentmanifest_decoder(),
    client,
    handle_response,
  )
}

pub fn documentmanifest_delete(
  resource: r4us.Documentmanifest,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DocumentManifest", client, handle_response)
}

pub fn documentmanifest_search_bundled(
  search_for search_args: r4us_sansio.SpDocumentmanifest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.documentmanifest_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn documentmanifest_search(
  search_for search_args: r4us_sansio.SpDocumentmanifest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Documentmanifest), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.documentmanifest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.documentmanifest
    },
  )
}

pub fn us_core_documentreference_create(
  resource: r4us.UsCoreDocumentreference,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreDocumentreference, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_documentreference_to_json(resource),
    "DocumentReference",
    r4us.us_core_documentreference_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_documentreference_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreDocumentreference, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DocumentReference",
    r4us.us_core_documentreference_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_documentreference_update(
  resource: r4us.UsCoreDocumentreference,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreDocumentreference, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_documentreference_to_json(resource),
    "DocumentReference",
    r4us.us_core_documentreference_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_documentreference_delete(
  resource: r4us.UsCoreDocumentreference,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DocumentReference", client, handle_response)
}

pub fn us_core_documentreference_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreDocumentreference,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_documentreference_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_documentreference_search(
  search_for search_args: r4us_sansio.SpUsCoreDocumentreference,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.UsCoreDocumentreference), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_documentreference_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_documentreference
    },
  )
}

pub fn us_core_adi_documentreference_create(
  resource: r4us.UsCoreAdiDocumentreference,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreAdiDocumentreference, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_adi_documentreference_to_json(resource),
    "DocumentReference",
    r4us.us_core_adi_documentreference_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_adi_documentreference_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreAdiDocumentreference, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DocumentReference",
    r4us.us_core_adi_documentreference_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_adi_documentreference_update(
  resource: r4us.UsCoreAdiDocumentreference,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreAdiDocumentreference, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_adi_documentreference_to_json(resource),
    "DocumentReference",
    r4us.us_core_adi_documentreference_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_adi_documentreference_delete(
  resource: r4us.UsCoreAdiDocumentreference,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DocumentReference", client, handle_response)
}

pub fn us_core_adi_documentreference_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreAdiDocumentreference,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_adi_documentreference_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_adi_documentreference_search(
  search_for search_args: r4us_sansio.SpUsCoreAdiDocumentreference,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.UsCoreAdiDocumentreference), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_adi_documentreference_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_adi_documentreference
    },
  )
}

pub fn effectevidencesynthesis_create(
  resource: r4us.Effectevidencesynthesis,
  client: FhirClient,
  handle_response: fn(Result(r4us.Effectevidencesynthesis, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.effectevidencesynthesis_to_json(resource),
    "EffectEvidenceSynthesis",
    r4us.effectevidencesynthesis_decoder(),
    client,
    handle_response,
  )
}

pub fn effectevidencesynthesis_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Effectevidencesynthesis, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EffectEvidenceSynthesis",
    r4us.effectevidencesynthesis_decoder(),
    client,
    handle_response,
  )
}

pub fn effectevidencesynthesis_update(
  resource: r4us.Effectevidencesynthesis,
  client: FhirClient,
  handle_response: fn(Result(r4us.Effectevidencesynthesis, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.effectevidencesynthesis_to_json(resource),
    "EffectEvidenceSynthesis",
    r4us.effectevidencesynthesis_decoder(),
    client,
    handle_response,
  )
}

pub fn effectevidencesynthesis_delete(
  resource: r4us.Effectevidencesynthesis,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "EffectEvidenceSynthesis", client, handle_response)
}

pub fn effectevidencesynthesis_search_bundled(
  search_for search_args: r4us_sansio.SpEffectevidencesynthesis,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.effectevidencesynthesis_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn effectevidencesynthesis_search(
  search_for search_args: r4us_sansio.SpEffectevidencesynthesis,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.Effectevidencesynthesis), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.effectevidencesynthesis_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.effectevidencesynthesis
    },
  )
}

pub fn us_core_encounter_create(
  resource: r4us.UsCoreEncounter,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreEncounter, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_encounter_to_json(resource),
    "Encounter",
    r4us.us_core_encounter_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_encounter_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreEncounter, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Encounter",
    r4us.us_core_encounter_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_encounter_update(
  resource: r4us.UsCoreEncounter,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreEncounter, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_encounter_to_json(resource),
    "Encounter",
    r4us.us_core_encounter_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_encounter_delete(
  resource: r4us.UsCoreEncounter,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Encounter", client, handle_response)
}

pub fn us_core_encounter_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreEncounter,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_encounter_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_encounter_search(
  search_for search_args: r4us_sansio.SpUsCoreEncounter,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.UsCoreEncounter), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_encounter_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_encounter
    },
  )
}

pub fn endpoint_create(
  resource: r4us.Endpoint,
  client: FhirClient,
  handle_response: fn(Result(r4us.Endpoint, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.endpoint_to_json(resource),
    "Endpoint",
    r4us.endpoint_decoder(),
    client,
    handle_response,
  )
}

pub fn endpoint_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Endpoint, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Endpoint", r4us.endpoint_decoder(), client, handle_response)
}

pub fn endpoint_update(
  resource: r4us.Endpoint,
  client: FhirClient,
  handle_response: fn(Result(r4us.Endpoint, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.endpoint_to_json(resource),
    "Endpoint",
    r4us.endpoint_decoder(),
    client,
    handle_response,
  )
}

pub fn endpoint_delete(
  resource: r4us.Endpoint,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Endpoint", client, handle_response)
}

pub fn endpoint_search_bundled(
  search_for search_args: r4us_sansio.SpEndpoint,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.endpoint_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn endpoint_search(
  search_for search_args: r4us_sansio.SpEndpoint,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Endpoint), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.endpoint_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4us_sansio.bundle_to_groupedresources }.endpoint },
  )
}

pub fn enrollmentrequest_create(
  resource: r4us.Enrollmentrequest,
  client: FhirClient,
  handle_response: fn(Result(r4us.Enrollmentrequest, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.enrollmentrequest_to_json(resource),
    "EnrollmentRequest",
    r4us.enrollmentrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Enrollmentrequest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EnrollmentRequest",
    r4us.enrollmentrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentrequest_update(
  resource: r4us.Enrollmentrequest,
  client: FhirClient,
  handle_response: fn(Result(r4us.Enrollmentrequest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.enrollmentrequest_to_json(resource),
    "EnrollmentRequest",
    r4us.enrollmentrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentrequest_delete(
  resource: r4us.Enrollmentrequest,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "EnrollmentRequest", client, handle_response)
}

pub fn enrollmentrequest_search_bundled(
  search_for search_args: r4us_sansio.SpEnrollmentrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.enrollmentrequest_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn enrollmentrequest_search(
  search_for search_args: r4us_sansio.SpEnrollmentrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Enrollmentrequest), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.enrollmentrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.enrollmentrequest
    },
  )
}

pub fn enrollmentresponse_create(
  resource: r4us.Enrollmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r4us.Enrollmentresponse, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.enrollmentresponse_to_json(resource),
    "EnrollmentResponse",
    r4us.enrollmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Enrollmentresponse, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EnrollmentResponse",
    r4us.enrollmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentresponse_update(
  resource: r4us.Enrollmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r4us.Enrollmentresponse, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.enrollmentresponse_to_json(resource),
    "EnrollmentResponse",
    r4us.enrollmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentresponse_delete(
  resource: r4us.Enrollmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "EnrollmentResponse", client, handle_response)
}

pub fn enrollmentresponse_search_bundled(
  search_for search_args: r4us_sansio.SpEnrollmentresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.enrollmentresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn enrollmentresponse_search(
  search_for search_args: r4us_sansio.SpEnrollmentresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Enrollmentresponse), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.enrollmentresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.enrollmentresponse
    },
  )
}

pub fn episodeofcare_create(
  resource: r4us.Episodeofcare,
  client: FhirClient,
  handle_response: fn(Result(r4us.Episodeofcare, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.episodeofcare_to_json(resource),
    "EpisodeOfCare",
    r4us.episodeofcare_decoder(),
    client,
    handle_response,
  )
}

pub fn episodeofcare_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Episodeofcare, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EpisodeOfCare",
    r4us.episodeofcare_decoder(),
    client,
    handle_response,
  )
}

pub fn episodeofcare_update(
  resource: r4us.Episodeofcare,
  client: FhirClient,
  handle_response: fn(Result(r4us.Episodeofcare, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.episodeofcare_to_json(resource),
    "EpisodeOfCare",
    r4us.episodeofcare_decoder(),
    client,
    handle_response,
  )
}

pub fn episodeofcare_delete(
  resource: r4us.Episodeofcare,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "EpisodeOfCare", client, handle_response)
}

pub fn episodeofcare_search_bundled(
  search_for search_args: r4us_sansio.SpEpisodeofcare,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.episodeofcare_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn episodeofcare_search(
  search_for search_args: r4us_sansio.SpEpisodeofcare,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Episodeofcare), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.episodeofcare_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.episodeofcare
    },
  )
}

pub fn eventdefinition_create(
  resource: r4us.Eventdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Eventdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.eventdefinition_to_json(resource),
    "EventDefinition",
    r4us.eventdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn eventdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Eventdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EventDefinition",
    r4us.eventdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn eventdefinition_update(
  resource: r4us.Eventdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Eventdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.eventdefinition_to_json(resource),
    "EventDefinition",
    r4us.eventdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn eventdefinition_delete(
  resource: r4us.Eventdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "EventDefinition", client, handle_response)
}

pub fn eventdefinition_search_bundled(
  search_for search_args: r4us_sansio.SpEventdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.eventdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn eventdefinition_search(
  search_for search_args: r4us_sansio.SpEventdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Eventdefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.eventdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.eventdefinition
    },
  )
}

pub fn evidence_create(
  resource: r4us.Evidence,
  client: FhirClient,
  handle_response: fn(Result(r4us.Evidence, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.evidence_to_json(resource),
    "Evidence",
    r4us.evidence_decoder(),
    client,
    handle_response,
  )
}

pub fn evidence_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Evidence, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Evidence", r4us.evidence_decoder(), client, handle_response)
}

pub fn evidence_update(
  resource: r4us.Evidence,
  client: FhirClient,
  handle_response: fn(Result(r4us.Evidence, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.evidence_to_json(resource),
    "Evidence",
    r4us.evidence_decoder(),
    client,
    handle_response,
  )
}

pub fn evidence_delete(
  resource: r4us.Evidence,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Evidence", client, handle_response)
}

pub fn evidence_search_bundled(
  search_for search_args: r4us_sansio.SpEvidence,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.evidence_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn evidence_search(
  search_for search_args: r4us_sansio.SpEvidence,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Evidence), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.evidence_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4us_sansio.bundle_to_groupedresources }.evidence },
  )
}

pub fn evidencevariable_create(
  resource: r4us.Evidencevariable,
  client: FhirClient,
  handle_response: fn(Result(r4us.Evidencevariable, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.evidencevariable_to_json(resource),
    "EvidenceVariable",
    r4us.evidencevariable_decoder(),
    client,
    handle_response,
  )
}

pub fn evidencevariable_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Evidencevariable, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EvidenceVariable",
    r4us.evidencevariable_decoder(),
    client,
    handle_response,
  )
}

pub fn evidencevariable_update(
  resource: r4us.Evidencevariable,
  client: FhirClient,
  handle_response: fn(Result(r4us.Evidencevariable, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.evidencevariable_to_json(resource),
    "EvidenceVariable",
    r4us.evidencevariable_decoder(),
    client,
    handle_response,
  )
}

pub fn evidencevariable_delete(
  resource: r4us.Evidencevariable,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "EvidenceVariable", client, handle_response)
}

pub fn evidencevariable_search_bundled(
  search_for search_args: r4us_sansio.SpEvidencevariable,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.evidencevariable_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn evidencevariable_search(
  search_for search_args: r4us_sansio.SpEvidencevariable,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Evidencevariable), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.evidencevariable_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.evidencevariable
    },
  )
}

pub fn examplescenario_create(
  resource: r4us.Examplescenario,
  client: FhirClient,
  handle_response: fn(Result(r4us.Examplescenario, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.examplescenario_to_json(resource),
    "ExampleScenario",
    r4us.examplescenario_decoder(),
    client,
    handle_response,
  )
}

pub fn examplescenario_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Examplescenario, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ExampleScenario",
    r4us.examplescenario_decoder(),
    client,
    handle_response,
  )
}

pub fn examplescenario_update(
  resource: r4us.Examplescenario,
  client: FhirClient,
  handle_response: fn(Result(r4us.Examplescenario, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.examplescenario_to_json(resource),
    "ExampleScenario",
    r4us.examplescenario_decoder(),
    client,
    handle_response,
  )
}

pub fn examplescenario_delete(
  resource: r4us.Examplescenario,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ExampleScenario", client, handle_response)
}

pub fn examplescenario_search_bundled(
  search_for search_args: r4us_sansio.SpExamplescenario,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.examplescenario_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn examplescenario_search(
  search_for search_args: r4us_sansio.SpExamplescenario,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Examplescenario), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.examplescenario_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.examplescenario
    },
  )
}

pub fn explanationofbenefit_create(
  resource: r4us.Explanationofbenefit,
  client: FhirClient,
  handle_response: fn(Result(r4us.Explanationofbenefit, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.explanationofbenefit_to_json(resource),
    "ExplanationOfBenefit",
    r4us.explanationofbenefit_decoder(),
    client,
    handle_response,
  )
}

pub fn explanationofbenefit_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Explanationofbenefit, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ExplanationOfBenefit",
    r4us.explanationofbenefit_decoder(),
    client,
    handle_response,
  )
}

pub fn explanationofbenefit_update(
  resource: r4us.Explanationofbenefit,
  client: FhirClient,
  handle_response: fn(Result(r4us.Explanationofbenefit, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.explanationofbenefit_to_json(resource),
    "ExplanationOfBenefit",
    r4us.explanationofbenefit_decoder(),
    client,
    handle_response,
  )
}

pub fn explanationofbenefit_delete(
  resource: r4us.Explanationofbenefit,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ExplanationOfBenefit", client, handle_response)
}

pub fn explanationofbenefit_search_bundled(
  search_for search_args: r4us_sansio.SpExplanationofbenefit,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.explanationofbenefit_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn explanationofbenefit_search(
  search_for search_args: r4us_sansio.SpExplanationofbenefit,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Explanationofbenefit), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.explanationofbenefit_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.explanationofbenefit
    },
  )
}

pub fn us_core_familymemberhistory_create(
  resource: r4us.UsCoreFamilymemberhistory,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreFamilymemberhistory, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    r4us.us_core_familymemberhistory_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_familymemberhistory_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreFamilymemberhistory, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "FamilyMemberHistory",
    r4us.us_core_familymemberhistory_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_familymemberhistory_update(
  resource: r4us.UsCoreFamilymemberhistory,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreFamilymemberhistory, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    r4us.us_core_familymemberhistory_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_familymemberhistory_delete(
  resource: r4us.UsCoreFamilymemberhistory,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "FamilyMemberHistory", client, handle_response)
}

pub fn us_core_familymemberhistory_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreFamilymemberhistory,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_familymemberhistory_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_familymemberhistory_search(
  search_for search_args: r4us_sansio.SpUsCoreFamilymemberhistory,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.UsCoreFamilymemberhistory), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_familymemberhistory_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_familymemberhistory
    },
  )
}

pub fn flag_create(
  resource: r4us.Flag,
  client: FhirClient,
  handle_response: fn(Result(r4us.Flag, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.flag_to_json(resource),
    "Flag",
    r4us.flag_decoder(),
    client,
    handle_response,
  )
}

pub fn flag_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Flag, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Flag", r4us.flag_decoder(), client, handle_response)
}

pub fn flag_update(
  resource: r4us.Flag,
  client: FhirClient,
  handle_response: fn(Result(r4us.Flag, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.flag_to_json(resource),
    "Flag",
    r4us.flag_decoder(),
    client,
    handle_response,
  )
}

pub fn flag_delete(
  resource: r4us.Flag,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Flag", client, handle_response)
}

pub fn flag_search_bundled(
  search_for search_args: r4us_sansio.SpFlag,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.flag_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn flag_search(
  search_for search_args: r4us_sansio.SpFlag,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Flag), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.flag_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4us_sansio.bundle_to_groupedresources }.flag },
  )
}

pub fn us_core_goal_create(
  resource: r4us.UsCoreGoal,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreGoal, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_goal_to_json(resource),
    "Goal",
    r4us.us_core_goal_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_goal_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreGoal, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Goal", r4us.us_core_goal_decoder(), client, handle_response)
}

pub fn us_core_goal_update(
  resource: r4us.UsCoreGoal,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreGoal, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_goal_to_json(resource),
    "Goal",
    r4us.us_core_goal_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_goal_delete(
  resource: r4us.UsCoreGoal,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Goal", client, handle_response)
}

pub fn us_core_goal_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreGoal,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_goal_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_goal_search(
  search_for search_args: r4us_sansio.SpUsCoreGoal,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.UsCoreGoal), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_goal_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_goal
    },
  )
}

pub fn graphdefinition_create(
  resource: r4us.Graphdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Graphdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.graphdefinition_to_json(resource),
    "GraphDefinition",
    r4us.graphdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn graphdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Graphdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "GraphDefinition",
    r4us.graphdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn graphdefinition_update(
  resource: r4us.Graphdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Graphdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.graphdefinition_to_json(resource),
    "GraphDefinition",
    r4us.graphdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn graphdefinition_delete(
  resource: r4us.Graphdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "GraphDefinition", client, handle_response)
}

pub fn graphdefinition_search_bundled(
  search_for search_args: r4us_sansio.SpGraphdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.graphdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn graphdefinition_search(
  search_for search_args: r4us_sansio.SpGraphdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Graphdefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.graphdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.graphdefinition
    },
  )
}

pub fn group_create(
  resource: r4us.Group,
  client: FhirClient,
  handle_response: fn(Result(r4us.Group, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.group_to_json(resource),
    "Group",
    r4us.group_decoder(),
    client,
    handle_response,
  )
}

pub fn group_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Group, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Group", r4us.group_decoder(), client, handle_response)
}

pub fn group_update(
  resource: r4us.Group,
  client: FhirClient,
  handle_response: fn(Result(r4us.Group, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.group_to_json(resource),
    "Group",
    r4us.group_decoder(),
    client,
    handle_response,
  )
}

pub fn group_delete(
  resource: r4us.Group,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Group", client, handle_response)
}

pub fn group_search_bundled(
  search_for search_args: r4us_sansio.SpGroup,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.group_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn group_search(
  search_for search_args: r4us_sansio.SpGroup,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Group), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.group_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4us_sansio.bundle_to_groupedresources }.group },
  )
}

pub fn guidanceresponse_create(
  resource: r4us.Guidanceresponse,
  client: FhirClient,
  handle_response: fn(Result(r4us.Guidanceresponse, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.guidanceresponse_to_json(resource),
    "GuidanceResponse",
    r4us.guidanceresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn guidanceresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Guidanceresponse, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "GuidanceResponse",
    r4us.guidanceresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn guidanceresponse_update(
  resource: r4us.Guidanceresponse,
  client: FhirClient,
  handle_response: fn(Result(r4us.Guidanceresponse, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.guidanceresponse_to_json(resource),
    "GuidanceResponse",
    r4us.guidanceresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn guidanceresponse_delete(
  resource: r4us.Guidanceresponse,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "GuidanceResponse", client, handle_response)
}

pub fn guidanceresponse_search_bundled(
  search_for search_args: r4us_sansio.SpGuidanceresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.guidanceresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn guidanceresponse_search(
  search_for search_args: r4us_sansio.SpGuidanceresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Guidanceresponse), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.guidanceresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.guidanceresponse
    },
  )
}

pub fn healthcareservice_create(
  resource: r4us.Healthcareservice,
  client: FhirClient,
  handle_response: fn(Result(r4us.Healthcareservice, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.healthcareservice_to_json(resource),
    "HealthcareService",
    r4us.healthcareservice_decoder(),
    client,
    handle_response,
  )
}

pub fn healthcareservice_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Healthcareservice, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "HealthcareService",
    r4us.healthcareservice_decoder(),
    client,
    handle_response,
  )
}

pub fn healthcareservice_update(
  resource: r4us.Healthcareservice,
  client: FhirClient,
  handle_response: fn(Result(r4us.Healthcareservice, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.healthcareservice_to_json(resource),
    "HealthcareService",
    r4us.healthcareservice_decoder(),
    client,
    handle_response,
  )
}

pub fn healthcareservice_delete(
  resource: r4us.Healthcareservice,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "HealthcareService", client, handle_response)
}

pub fn healthcareservice_search_bundled(
  search_for search_args: r4us_sansio.SpHealthcareservice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.healthcareservice_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn healthcareservice_search(
  search_for search_args: r4us_sansio.SpHealthcareservice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Healthcareservice), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.healthcareservice_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.healthcareservice
    },
  )
}

pub fn imagingstudy_create(
  resource: r4us.Imagingstudy,
  client: FhirClient,
  handle_response: fn(Result(r4us.Imagingstudy, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.imagingstudy_to_json(resource),
    "ImagingStudy",
    r4us.imagingstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn imagingstudy_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Imagingstudy, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ImagingStudy",
    r4us.imagingstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn imagingstudy_update(
  resource: r4us.Imagingstudy,
  client: FhirClient,
  handle_response: fn(Result(r4us.Imagingstudy, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.imagingstudy_to_json(resource),
    "ImagingStudy",
    r4us.imagingstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn imagingstudy_delete(
  resource: r4us.Imagingstudy,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ImagingStudy", client, handle_response)
}

pub fn imagingstudy_search_bundled(
  search_for search_args: r4us_sansio.SpImagingstudy,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.imagingstudy_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn imagingstudy_search(
  search_for search_args: r4us_sansio.SpImagingstudy,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Imagingstudy), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.imagingstudy_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.imagingstudy
    },
  )
}

pub fn us_core_immunization_create(
  resource: r4us.UsCoreImmunization,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreImmunization, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_immunization_to_json(resource),
    "Immunization",
    r4us.us_core_immunization_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_immunization_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreImmunization, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Immunization",
    r4us.us_core_immunization_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_immunization_update(
  resource: r4us.UsCoreImmunization,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreImmunization, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_immunization_to_json(resource),
    "Immunization",
    r4us.us_core_immunization_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_immunization_delete(
  resource: r4us.UsCoreImmunization,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Immunization", client, handle_response)
}

pub fn us_core_immunization_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreImmunization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_immunization_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_immunization_search(
  search_for search_args: r4us_sansio.SpUsCoreImmunization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.UsCoreImmunization), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_immunization_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_immunization
    },
  )
}

pub fn immunizationevaluation_create(
  resource: r4us.Immunizationevaluation,
  client: FhirClient,
  handle_response: fn(Result(r4us.Immunizationevaluation, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.immunizationevaluation_to_json(resource),
    "ImmunizationEvaluation",
    r4us.immunizationevaluation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationevaluation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Immunizationevaluation, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ImmunizationEvaluation",
    r4us.immunizationevaluation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationevaluation_update(
  resource: r4us.Immunizationevaluation,
  client: FhirClient,
  handle_response: fn(Result(r4us.Immunizationevaluation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.immunizationevaluation_to_json(resource),
    "ImmunizationEvaluation",
    r4us.immunizationevaluation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationevaluation_delete(
  resource: r4us.Immunizationevaluation,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ImmunizationEvaluation", client, handle_response)
}

pub fn immunizationevaluation_search_bundled(
  search_for search_args: r4us_sansio.SpImmunizationevaluation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.immunizationevaluation_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn immunizationevaluation_search(
  search_for search_args: r4us_sansio.SpImmunizationevaluation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.Immunizationevaluation), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.immunizationevaluation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.immunizationevaluation
    },
  )
}

pub fn immunizationrecommendation_create(
  resource: r4us.Immunizationrecommendation,
  client: FhirClient,
  handle_response: fn(Result(r4us.Immunizationrecommendation, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.immunizationrecommendation_to_json(resource),
    "ImmunizationRecommendation",
    r4us.immunizationrecommendation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationrecommendation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Immunizationrecommendation, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ImmunizationRecommendation",
    r4us.immunizationrecommendation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationrecommendation_update(
  resource: r4us.Immunizationrecommendation,
  client: FhirClient,
  handle_response: fn(Result(r4us.Immunizationrecommendation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.immunizationrecommendation_to_json(resource),
    "ImmunizationRecommendation",
    r4us.immunizationrecommendation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationrecommendation_delete(
  resource: r4us.Immunizationrecommendation,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ImmunizationRecommendation", client, handle_response)
}

pub fn immunizationrecommendation_search_bundled(
  search_for search_args: r4us_sansio.SpImmunizationrecommendation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.immunizationrecommendation_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn immunizationrecommendation_search(
  search_for search_args: r4us_sansio.SpImmunizationrecommendation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.Immunizationrecommendation), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.immunizationrecommendation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.immunizationrecommendation
    },
  )
}

pub fn implementationguide_create(
  resource: r4us.Implementationguide,
  client: FhirClient,
  handle_response: fn(Result(r4us.Implementationguide, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.implementationguide_to_json(resource),
    "ImplementationGuide",
    r4us.implementationguide_decoder(),
    client,
    handle_response,
  )
}

pub fn implementationguide_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Implementationguide, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ImplementationGuide",
    r4us.implementationguide_decoder(),
    client,
    handle_response,
  )
}

pub fn implementationguide_update(
  resource: r4us.Implementationguide,
  client: FhirClient,
  handle_response: fn(Result(r4us.Implementationguide, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.implementationguide_to_json(resource),
    "ImplementationGuide",
    r4us.implementationguide_decoder(),
    client,
    handle_response,
  )
}

pub fn implementationguide_delete(
  resource: r4us.Implementationguide,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ImplementationGuide", client, handle_response)
}

pub fn implementationguide_search_bundled(
  search_for search_args: r4us_sansio.SpImplementationguide,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.implementationguide_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn implementationguide_search(
  search_for search_args: r4us_sansio.SpImplementationguide,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Implementationguide), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.implementationguide_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.implementationguide
    },
  )
}

pub fn insuranceplan_create(
  resource: r4us.Insuranceplan,
  client: FhirClient,
  handle_response: fn(Result(r4us.Insuranceplan, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.insuranceplan_to_json(resource),
    "InsurancePlan",
    r4us.insuranceplan_decoder(),
    client,
    handle_response,
  )
}

pub fn insuranceplan_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Insuranceplan, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "InsurancePlan",
    r4us.insuranceplan_decoder(),
    client,
    handle_response,
  )
}

pub fn insuranceplan_update(
  resource: r4us.Insuranceplan,
  client: FhirClient,
  handle_response: fn(Result(r4us.Insuranceplan, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.insuranceplan_to_json(resource),
    "InsurancePlan",
    r4us.insuranceplan_decoder(),
    client,
    handle_response,
  )
}

pub fn insuranceplan_delete(
  resource: r4us.Insuranceplan,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "InsurancePlan", client, handle_response)
}

pub fn insuranceplan_search_bundled(
  search_for search_args: r4us_sansio.SpInsuranceplan,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.insuranceplan_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn insuranceplan_search(
  search_for search_args: r4us_sansio.SpInsuranceplan,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Insuranceplan), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.insuranceplan_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.insuranceplan
    },
  )
}

pub fn invoice_create(
  resource: r4us.Invoice,
  client: FhirClient,
  handle_response: fn(Result(r4us.Invoice, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.invoice_to_json(resource),
    "Invoice",
    r4us.invoice_decoder(),
    client,
    handle_response,
  )
}

pub fn invoice_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Invoice, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Invoice", r4us.invoice_decoder(), client, handle_response)
}

pub fn invoice_update(
  resource: r4us.Invoice,
  client: FhirClient,
  handle_response: fn(Result(r4us.Invoice, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.invoice_to_json(resource),
    "Invoice",
    r4us.invoice_decoder(),
    client,
    handle_response,
  )
}

pub fn invoice_delete(
  resource: r4us.Invoice,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Invoice", client, handle_response)
}

pub fn invoice_search_bundled(
  search_for search_args: r4us_sansio.SpInvoice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.invoice_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn invoice_search(
  search_for search_args: r4us_sansio.SpInvoice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Invoice), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.invoice_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4us_sansio.bundle_to_groupedresources }.invoice },
  )
}

pub fn library_create(
  resource: r4us.Library,
  client: FhirClient,
  handle_response: fn(Result(r4us.Library, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.library_to_json(resource),
    "Library",
    r4us.library_decoder(),
    client,
    handle_response,
  )
}

pub fn library_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Library, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Library", r4us.library_decoder(), client, handle_response)
}

pub fn library_update(
  resource: r4us.Library,
  client: FhirClient,
  handle_response: fn(Result(r4us.Library, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.library_to_json(resource),
    "Library",
    r4us.library_decoder(),
    client,
    handle_response,
  )
}

pub fn library_delete(
  resource: r4us.Library,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Library", client, handle_response)
}

pub fn library_search_bundled(
  search_for search_args: r4us_sansio.SpLibrary,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.library_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn library_search(
  search_for search_args: r4us_sansio.SpLibrary,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Library), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.library_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4us_sansio.bundle_to_groupedresources }.library },
  )
}

pub fn linkage_create(
  resource: r4us.Linkage,
  client: FhirClient,
  handle_response: fn(Result(r4us.Linkage, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.linkage_to_json(resource),
    "Linkage",
    r4us.linkage_decoder(),
    client,
    handle_response,
  )
}

pub fn linkage_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Linkage, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Linkage", r4us.linkage_decoder(), client, handle_response)
}

pub fn linkage_update(
  resource: r4us.Linkage,
  client: FhirClient,
  handle_response: fn(Result(r4us.Linkage, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.linkage_to_json(resource),
    "Linkage",
    r4us.linkage_decoder(),
    client,
    handle_response,
  )
}

pub fn linkage_delete(
  resource: r4us.Linkage,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Linkage", client, handle_response)
}

pub fn linkage_search_bundled(
  search_for search_args: r4us_sansio.SpLinkage,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.linkage_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn linkage_search(
  search_for search_args: r4us_sansio.SpLinkage,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Linkage), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.linkage_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4us_sansio.bundle_to_groupedresources }.linkage },
  )
}

pub fn listfhir_create(
  resource: r4us.Listfhir,
  client: FhirClient,
  handle_response: fn(Result(r4us.Listfhir, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.listfhir_to_json(resource),
    "List",
    r4us.listfhir_decoder(),
    client,
    handle_response,
  )
}

pub fn listfhir_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Listfhir, Err)) -> a,
) -> Effect(a) {
  any_read(id, "List", r4us.listfhir_decoder(), client, handle_response)
}

pub fn listfhir_update(
  resource: r4us.Listfhir,
  client: FhirClient,
  handle_response: fn(Result(r4us.Listfhir, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.listfhir_to_json(resource),
    "List",
    r4us.listfhir_decoder(),
    client,
    handle_response,
  )
}

pub fn listfhir_delete(
  resource: r4us.Listfhir,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "List", client, handle_response)
}

pub fn listfhir_search_bundled(
  search_for search_args: r4us_sansio.SpListfhir,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.listfhir_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn listfhir_search(
  search_for search_args: r4us_sansio.SpListfhir,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Listfhir), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.listfhir_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4us_sansio.bundle_to_groupedresources }.listfhir },
  )
}

pub fn us_core_location_create(
  resource: r4us.UsCoreLocation,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreLocation, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_location_to_json(resource),
    "Location",
    r4us.us_core_location_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_location_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreLocation, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Location",
    r4us.us_core_location_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_location_update(
  resource: r4us.UsCoreLocation,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreLocation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_location_to_json(resource),
    "Location",
    r4us.us_core_location_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_location_delete(
  resource: r4us.UsCoreLocation,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Location", client, handle_response)
}

pub fn us_core_location_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreLocation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_location_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_location_search(
  search_for search_args: r4us_sansio.SpUsCoreLocation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.UsCoreLocation), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_location_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_location
    },
  )
}

pub fn measure_create(
  resource: r4us.Measure,
  client: FhirClient,
  handle_response: fn(Result(r4us.Measure, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.measure_to_json(resource),
    "Measure",
    r4us.measure_decoder(),
    client,
    handle_response,
  )
}

pub fn measure_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Measure, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Measure", r4us.measure_decoder(), client, handle_response)
}

pub fn measure_update(
  resource: r4us.Measure,
  client: FhirClient,
  handle_response: fn(Result(r4us.Measure, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.measure_to_json(resource),
    "Measure",
    r4us.measure_decoder(),
    client,
    handle_response,
  )
}

pub fn measure_delete(
  resource: r4us.Measure,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Measure", client, handle_response)
}

pub fn measure_search_bundled(
  search_for search_args: r4us_sansio.SpMeasure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.measure_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn measure_search(
  search_for search_args: r4us_sansio.SpMeasure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Measure), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.measure_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4us_sansio.bundle_to_groupedresources }.measure },
  )
}

pub fn measurereport_create(
  resource: r4us.Measurereport,
  client: FhirClient,
  handle_response: fn(Result(r4us.Measurereport, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.measurereport_to_json(resource),
    "MeasureReport",
    r4us.measurereport_decoder(),
    client,
    handle_response,
  )
}

pub fn measurereport_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Measurereport, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MeasureReport",
    r4us.measurereport_decoder(),
    client,
    handle_response,
  )
}

pub fn measurereport_update(
  resource: r4us.Measurereport,
  client: FhirClient,
  handle_response: fn(Result(r4us.Measurereport, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.measurereport_to_json(resource),
    "MeasureReport",
    r4us.measurereport_decoder(),
    client,
    handle_response,
  )
}

pub fn measurereport_delete(
  resource: r4us.Measurereport,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MeasureReport", client, handle_response)
}

pub fn measurereport_search_bundled(
  search_for search_args: r4us_sansio.SpMeasurereport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.measurereport_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn measurereport_search(
  search_for search_args: r4us_sansio.SpMeasurereport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Measurereport), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.measurereport_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.measurereport
    },
  )
}

pub fn media_create(
  resource: r4us.Media,
  client: FhirClient,
  handle_response: fn(Result(r4us.Media, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.media_to_json(resource),
    "Media",
    r4us.media_decoder(),
    client,
    handle_response,
  )
}

pub fn media_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Media, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Media", r4us.media_decoder(), client, handle_response)
}

pub fn media_update(
  resource: r4us.Media,
  client: FhirClient,
  handle_response: fn(Result(r4us.Media, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.media_to_json(resource),
    "Media",
    r4us.media_decoder(),
    client,
    handle_response,
  )
}

pub fn media_delete(
  resource: r4us.Media,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Media", client, handle_response)
}

pub fn media_search_bundled(
  search_for search_args: r4us_sansio.SpMedia,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.media_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn media_search(
  search_for search_args: r4us_sansio.SpMedia,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Media), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.media_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4us_sansio.bundle_to_groupedresources }.media },
  )
}

pub fn us_core_medication_create(
  resource: r4us.UsCoreMedication,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreMedication, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_medication_to_json(resource),
    "Medication",
    r4us.us_core_medication_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_medication_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreMedication, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Medication",
    r4us.us_core_medication_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_medication_update(
  resource: r4us.UsCoreMedication,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreMedication, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_medication_to_json(resource),
    "Medication",
    r4us.us_core_medication_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_medication_delete(
  resource: r4us.UsCoreMedication,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Medication", client, handle_response)
}

pub fn us_core_medication_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreMedication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_medication_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_medication_search(
  search_for search_args: r4us_sansio.SpUsCoreMedication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.UsCoreMedication), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_medication_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_medication
    },
  )
}

pub fn medicationadministration_create(
  resource: r4us.Medicationadministration,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicationadministration, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.medicationadministration_to_json(resource),
    "MedicationAdministration",
    r4us.medicationadministration_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationadministration_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicationadministration, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationAdministration",
    r4us.medicationadministration_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationadministration_update(
  resource: r4us.Medicationadministration,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicationadministration, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.medicationadministration_to_json(resource),
    "MedicationAdministration",
    r4us.medicationadministration_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationadministration_delete(
  resource: r4us.Medicationadministration,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicationAdministration", client, handle_response)
}

pub fn medicationadministration_search_bundled(
  search_for search_args: r4us_sansio.SpMedicationadministration,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.medicationadministration_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn medicationadministration_search(
  search_for search_args: r4us_sansio.SpMedicationadministration,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.Medicationadministration), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.medicationadministration_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.medicationadministration
    },
  )
}

pub fn us_core_medicationdispense_create(
  resource: r4us.UsCoreMedicationdispense,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreMedicationdispense, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_medicationdispense_to_json(resource),
    "MedicationDispense",
    r4us.us_core_medicationdispense_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_medicationdispense_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreMedicationdispense, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationDispense",
    r4us.us_core_medicationdispense_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_medicationdispense_update(
  resource: r4us.UsCoreMedicationdispense,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreMedicationdispense, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_medicationdispense_to_json(resource),
    "MedicationDispense",
    r4us.us_core_medicationdispense_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_medicationdispense_delete(
  resource: r4us.UsCoreMedicationdispense,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicationDispense", client, handle_response)
}

pub fn us_core_medicationdispense_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreMedicationdispense,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_medicationdispense_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_medicationdispense_search(
  search_for search_args: r4us_sansio.SpUsCoreMedicationdispense,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.UsCoreMedicationdispense), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_medicationdispense_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_medicationdispense
    },
  )
}

pub fn medicationknowledge_create(
  resource: r4us.Medicationknowledge,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicationknowledge, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.medicationknowledge_to_json(resource),
    "MedicationKnowledge",
    r4us.medicationknowledge_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationknowledge_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicationknowledge, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationKnowledge",
    r4us.medicationknowledge_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationknowledge_update(
  resource: r4us.Medicationknowledge,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicationknowledge, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.medicationknowledge_to_json(resource),
    "MedicationKnowledge",
    r4us.medicationknowledge_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationknowledge_delete(
  resource: r4us.Medicationknowledge,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicationKnowledge", client, handle_response)
}

pub fn medicationknowledge_search_bundled(
  search_for search_args: r4us_sansio.SpMedicationknowledge,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.medicationknowledge_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn medicationknowledge_search(
  search_for search_args: r4us_sansio.SpMedicationknowledge,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Medicationknowledge), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.medicationknowledge_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.medicationknowledge
    },
  )
}

pub fn us_core_medicationrequest_create(
  resource: r4us.UsCoreMedicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreMedicationrequest, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_medicationrequest_to_json(resource),
    "MedicationRequest",
    r4us.us_core_medicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_medicationrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreMedicationrequest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationRequest",
    r4us.us_core_medicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_medicationrequest_update(
  resource: r4us.UsCoreMedicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreMedicationrequest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_medicationrequest_to_json(resource),
    "MedicationRequest",
    r4us.us_core_medicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_medicationrequest_delete(
  resource: r4us.UsCoreMedicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicationRequest", client, handle_response)
}

pub fn us_core_medicationrequest_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreMedicationrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_medicationrequest_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_medicationrequest_search(
  search_for search_args: r4us_sansio.SpUsCoreMedicationrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.UsCoreMedicationrequest), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_medicationrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_medicationrequest
    },
  )
}

pub fn medicationstatement_create(
  resource: r4us.Medicationstatement,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicationstatement, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.medicationstatement_to_json(resource),
    "MedicationStatement",
    r4us.medicationstatement_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationstatement_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicationstatement, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationStatement",
    r4us.medicationstatement_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationstatement_update(
  resource: r4us.Medicationstatement,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicationstatement, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.medicationstatement_to_json(resource),
    "MedicationStatement",
    r4us.medicationstatement_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationstatement_delete(
  resource: r4us.Medicationstatement,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicationStatement", client, handle_response)
}

pub fn medicationstatement_search_bundled(
  search_for search_args: r4us_sansio.SpMedicationstatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.medicationstatement_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn medicationstatement_search(
  search_for search_args: r4us_sansio.SpMedicationstatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Medicationstatement), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.medicationstatement_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.medicationstatement
    },
  )
}

pub fn medicinalproduct_create(
  resource: r4us.Medicinalproduct,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproduct, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.medicinalproduct_to_json(resource),
    "MedicinalProduct",
    r4us.medicinalproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproduct_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproduct, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProduct",
    r4us.medicinalproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproduct_update(
  resource: r4us.Medicinalproduct,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproduct, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.medicinalproduct_to_json(resource),
    "MedicinalProduct",
    r4us.medicinalproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproduct_delete(
  resource: r4us.Medicinalproduct,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicinalProduct", client, handle_response)
}

pub fn medicinalproduct_search_bundled(
  search_for search_args: r4us_sansio.SpMedicinalproduct,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.medicinalproduct_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn medicinalproduct_search(
  search_for search_args: r4us_sansio.SpMedicinalproduct,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Medicinalproduct), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.medicinalproduct_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.medicinalproduct
    },
  )
}

pub fn medicinalproductauthorization_create(
  resource: r4us.Medicinalproductauthorization,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproductauthorization, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.medicinalproductauthorization_to_json(resource),
    "MedicinalProductAuthorization",
    r4us.medicinalproductauthorization_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductauthorization_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproductauthorization, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductAuthorization",
    r4us.medicinalproductauthorization_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductauthorization_update(
  resource: r4us.Medicinalproductauthorization,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproductauthorization, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.medicinalproductauthorization_to_json(resource),
    "MedicinalProductAuthorization",
    r4us.medicinalproductauthorization_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductauthorization_delete(
  resource: r4us.Medicinalproductauthorization,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(
    resource.id,
    "MedicinalProductAuthorization",
    client,
    handle_response,
  )
}

pub fn medicinalproductauthorization_search_bundled(
  search_for search_args: r4us_sansio.SpMedicinalproductauthorization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.medicinalproductauthorization_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn medicinalproductauthorization_search(
  search_for search_args: r4us_sansio.SpMedicinalproductauthorization,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.Medicinalproductauthorization), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.medicinalproductauthorization_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.medicinalproductauthorization
    },
  )
}

pub fn medicinalproductcontraindication_create(
  resource: r4us.Medicinalproductcontraindication,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproductcontraindication, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.medicinalproductcontraindication_to_json(resource),
    "MedicinalProductContraindication",
    r4us.medicinalproductcontraindication_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductcontraindication_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproductcontraindication, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductContraindication",
    r4us.medicinalproductcontraindication_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductcontraindication_update(
  resource: r4us.Medicinalproductcontraindication,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproductcontraindication, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.medicinalproductcontraindication_to_json(resource),
    "MedicinalProductContraindication",
    r4us.medicinalproductcontraindication_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductcontraindication_delete(
  resource: r4us.Medicinalproductcontraindication,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(
    resource.id,
    "MedicinalProductContraindication",
    client,
    handle_response,
  )
}

pub fn medicinalproductcontraindication_search_bundled(
  search_for search_args: r4us_sansio.SpMedicinalproductcontraindication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.medicinalproductcontraindication_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn medicinalproductcontraindication_search(
  search_for search_args: r4us_sansio.SpMedicinalproductcontraindication,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.Medicinalproductcontraindication), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.medicinalproductcontraindication_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.medicinalproductcontraindication
    },
  )
}

pub fn medicinalproductindication_create(
  resource: r4us.Medicinalproductindication,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproductindication, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.medicinalproductindication_to_json(resource),
    "MedicinalProductIndication",
    r4us.medicinalproductindication_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductindication_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproductindication, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductIndication",
    r4us.medicinalproductindication_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductindication_update(
  resource: r4us.Medicinalproductindication,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproductindication, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.medicinalproductindication_to_json(resource),
    "MedicinalProductIndication",
    r4us.medicinalproductindication_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductindication_delete(
  resource: r4us.Medicinalproductindication,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicinalProductIndication", client, handle_response)
}

pub fn medicinalproductindication_search_bundled(
  search_for search_args: r4us_sansio.SpMedicinalproductindication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.medicinalproductindication_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn medicinalproductindication_search(
  search_for search_args: r4us_sansio.SpMedicinalproductindication,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.Medicinalproductindication), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.medicinalproductindication_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.medicinalproductindication
    },
  )
}

pub fn medicinalproductingredient_create(
  resource: r4us.Medicinalproductingredient,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproductingredient, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.medicinalproductingredient_to_json(resource),
    "MedicinalProductIngredient",
    r4us.medicinalproductingredient_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductingredient_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproductingredient, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductIngredient",
    r4us.medicinalproductingredient_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductingredient_update(
  resource: r4us.Medicinalproductingredient,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproductingredient, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.medicinalproductingredient_to_json(resource),
    "MedicinalProductIngredient",
    r4us.medicinalproductingredient_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductingredient_delete(
  resource: r4us.Medicinalproductingredient,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicinalProductIngredient", client, handle_response)
}

pub fn medicinalproductingredient_search_bundled(
  search_for search_args: r4us_sansio.SpMedicinalproductingredient,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.medicinalproductingredient_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn medicinalproductingredient_search(
  search_for search_args: r4us_sansio.SpMedicinalproductingredient,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.Medicinalproductingredient), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.medicinalproductingredient_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.medicinalproductingredient
    },
  )
}

pub fn medicinalproductinteraction_create(
  resource: r4us.Medicinalproductinteraction,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproductinteraction, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.medicinalproductinteraction_to_json(resource),
    "MedicinalProductInteraction",
    r4us.medicinalproductinteraction_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductinteraction_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproductinteraction, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductInteraction",
    r4us.medicinalproductinteraction_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductinteraction_update(
  resource: r4us.Medicinalproductinteraction,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproductinteraction, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.medicinalproductinteraction_to_json(resource),
    "MedicinalProductInteraction",
    r4us.medicinalproductinteraction_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductinteraction_delete(
  resource: r4us.Medicinalproductinteraction,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(
    resource.id,
    "MedicinalProductInteraction",
    client,
    handle_response,
  )
}

pub fn medicinalproductinteraction_search_bundled(
  search_for search_args: r4us_sansio.SpMedicinalproductinteraction,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.medicinalproductinteraction_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn medicinalproductinteraction_search(
  search_for search_args: r4us_sansio.SpMedicinalproductinteraction,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.Medicinalproductinteraction), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.medicinalproductinteraction_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.medicinalproductinteraction
    },
  )
}

pub fn medicinalproductmanufactured_create(
  resource: r4us.Medicinalproductmanufactured,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproductmanufactured, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.medicinalproductmanufactured_to_json(resource),
    "MedicinalProductManufactured",
    r4us.medicinalproductmanufactured_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductmanufactured_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproductmanufactured, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductManufactured",
    r4us.medicinalproductmanufactured_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductmanufactured_update(
  resource: r4us.Medicinalproductmanufactured,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproductmanufactured, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.medicinalproductmanufactured_to_json(resource),
    "MedicinalProductManufactured",
    r4us.medicinalproductmanufactured_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductmanufactured_delete(
  resource: r4us.Medicinalproductmanufactured,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(
    resource.id,
    "MedicinalProductManufactured",
    client,
    handle_response,
  )
}

pub fn medicinalproductmanufactured_search_bundled(
  search_for search_args: r4us_sansio.SpMedicinalproductmanufactured,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.medicinalproductmanufactured_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn medicinalproductmanufactured_search(
  search_for search_args: r4us_sansio.SpMedicinalproductmanufactured,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.Medicinalproductmanufactured), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.medicinalproductmanufactured_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.medicinalproductmanufactured
    },
  )
}

pub fn medicinalproductpackaged_create(
  resource: r4us.Medicinalproductpackaged,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproductpackaged, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.medicinalproductpackaged_to_json(resource),
    "MedicinalProductPackaged",
    r4us.medicinalproductpackaged_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductpackaged_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproductpackaged, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductPackaged",
    r4us.medicinalproductpackaged_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductpackaged_update(
  resource: r4us.Medicinalproductpackaged,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproductpackaged, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.medicinalproductpackaged_to_json(resource),
    "MedicinalProductPackaged",
    r4us.medicinalproductpackaged_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductpackaged_delete(
  resource: r4us.Medicinalproductpackaged,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicinalProductPackaged", client, handle_response)
}

pub fn medicinalproductpackaged_search_bundled(
  search_for search_args: r4us_sansio.SpMedicinalproductpackaged,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.medicinalproductpackaged_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn medicinalproductpackaged_search(
  search_for search_args: r4us_sansio.SpMedicinalproductpackaged,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.Medicinalproductpackaged), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.medicinalproductpackaged_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.medicinalproductpackaged
    },
  )
}

pub fn medicinalproductpharmaceutical_create(
  resource: r4us.Medicinalproductpharmaceutical,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproductpharmaceutical, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.medicinalproductpharmaceutical_to_json(resource),
    "MedicinalProductPharmaceutical",
    r4us.medicinalproductpharmaceutical_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductpharmaceutical_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproductpharmaceutical, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductPharmaceutical",
    r4us.medicinalproductpharmaceutical_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductpharmaceutical_update(
  resource: r4us.Medicinalproductpharmaceutical,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproductpharmaceutical, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.medicinalproductpharmaceutical_to_json(resource),
    "MedicinalProductPharmaceutical",
    r4us.medicinalproductpharmaceutical_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductpharmaceutical_delete(
  resource: r4us.Medicinalproductpharmaceutical,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(
    resource.id,
    "MedicinalProductPharmaceutical",
    client,
    handle_response,
  )
}

pub fn medicinalproductpharmaceutical_search_bundled(
  search_for search_args: r4us_sansio.SpMedicinalproductpharmaceutical,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.medicinalproductpharmaceutical_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn medicinalproductpharmaceutical_search(
  search_for search_args: r4us_sansio.SpMedicinalproductpharmaceutical,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.Medicinalproductpharmaceutical), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.medicinalproductpharmaceutical_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.medicinalproductpharmaceutical
    },
  )
}

pub fn medicinalproductundesirableeffect_create(
  resource: r4us.Medicinalproductundesirableeffect,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproductundesirableeffect, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.medicinalproductundesirableeffect_to_json(resource),
    "MedicinalProductUndesirableEffect",
    r4us.medicinalproductundesirableeffect_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductundesirableeffect_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproductundesirableeffect, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductUndesirableEffect",
    r4us.medicinalproductundesirableeffect_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductundesirableeffect_update(
  resource: r4us.Medicinalproductundesirableeffect,
  client: FhirClient,
  handle_response: fn(Result(r4us.Medicinalproductundesirableeffect, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.medicinalproductundesirableeffect_to_json(resource),
    "MedicinalProductUndesirableEffect",
    r4us.medicinalproductundesirableeffect_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductundesirableeffect_delete(
  resource: r4us.Medicinalproductundesirableeffect,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(
    resource.id,
    "MedicinalProductUndesirableEffect",
    client,
    handle_response,
  )
}

pub fn medicinalproductundesirableeffect_search_bundled(
  search_for search_args: r4us_sansio.SpMedicinalproductundesirableeffect,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.medicinalproductundesirableeffect_search_req(
      search_args,
      client,
    )
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn medicinalproductundesirableeffect_search(
  search_for search_args: r4us_sansio.SpMedicinalproductundesirableeffect,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.Medicinalproductundesirableeffect), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.medicinalproductundesirableeffect_search_req(
      search_args,
      client,
    )
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.medicinalproductundesirableeffect
    },
  )
}

pub fn messagedefinition_create(
  resource: r4us.Messagedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Messagedefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.messagedefinition_to_json(resource),
    "MessageDefinition",
    r4us.messagedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn messagedefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Messagedefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MessageDefinition",
    r4us.messagedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn messagedefinition_update(
  resource: r4us.Messagedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Messagedefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.messagedefinition_to_json(resource),
    "MessageDefinition",
    r4us.messagedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn messagedefinition_delete(
  resource: r4us.Messagedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MessageDefinition", client, handle_response)
}

pub fn messagedefinition_search_bundled(
  search_for search_args: r4us_sansio.SpMessagedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.messagedefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn messagedefinition_search(
  search_for search_args: r4us_sansio.SpMessagedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Messagedefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.messagedefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.messagedefinition
    },
  )
}

pub fn messageheader_create(
  resource: r4us.Messageheader,
  client: FhirClient,
  handle_response: fn(Result(r4us.Messageheader, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.messageheader_to_json(resource),
    "MessageHeader",
    r4us.messageheader_decoder(),
    client,
    handle_response,
  )
}

pub fn messageheader_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Messageheader, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MessageHeader",
    r4us.messageheader_decoder(),
    client,
    handle_response,
  )
}

pub fn messageheader_update(
  resource: r4us.Messageheader,
  client: FhirClient,
  handle_response: fn(Result(r4us.Messageheader, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.messageheader_to_json(resource),
    "MessageHeader",
    r4us.messageheader_decoder(),
    client,
    handle_response,
  )
}

pub fn messageheader_delete(
  resource: r4us.Messageheader,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MessageHeader", client, handle_response)
}

pub fn messageheader_search_bundled(
  search_for search_args: r4us_sansio.SpMessageheader,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.messageheader_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn messageheader_search(
  search_for search_args: r4us_sansio.SpMessageheader,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Messageheader), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.messageheader_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.messageheader
    },
  )
}

pub fn molecularsequence_create(
  resource: r4us.Molecularsequence,
  client: FhirClient,
  handle_response: fn(Result(r4us.Molecularsequence, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.molecularsequence_to_json(resource),
    "MolecularSequence",
    r4us.molecularsequence_decoder(),
    client,
    handle_response,
  )
}

pub fn molecularsequence_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Molecularsequence, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MolecularSequence",
    r4us.molecularsequence_decoder(),
    client,
    handle_response,
  )
}

pub fn molecularsequence_update(
  resource: r4us.Molecularsequence,
  client: FhirClient,
  handle_response: fn(Result(r4us.Molecularsequence, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.molecularsequence_to_json(resource),
    "MolecularSequence",
    r4us.molecularsequence_decoder(),
    client,
    handle_response,
  )
}

pub fn molecularsequence_delete(
  resource: r4us.Molecularsequence,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MolecularSequence", client, handle_response)
}

pub fn molecularsequence_search_bundled(
  search_for search_args: r4us_sansio.SpMolecularsequence,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.molecularsequence_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn molecularsequence_search(
  search_for search_args: r4us_sansio.SpMolecularsequence,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Molecularsequence), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.molecularsequence_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.molecularsequence
    },
  )
}

pub fn namingsystem_create(
  resource: r4us.Namingsystem,
  client: FhirClient,
  handle_response: fn(Result(r4us.Namingsystem, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.namingsystem_to_json(resource),
    "NamingSystem",
    r4us.namingsystem_decoder(),
    client,
    handle_response,
  )
}

pub fn namingsystem_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Namingsystem, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "NamingSystem",
    r4us.namingsystem_decoder(),
    client,
    handle_response,
  )
}

pub fn namingsystem_update(
  resource: r4us.Namingsystem,
  client: FhirClient,
  handle_response: fn(Result(r4us.Namingsystem, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.namingsystem_to_json(resource),
    "NamingSystem",
    r4us.namingsystem_decoder(),
    client,
    handle_response,
  )
}

pub fn namingsystem_delete(
  resource: r4us.Namingsystem,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "NamingSystem", client, handle_response)
}

pub fn namingsystem_search_bundled(
  search_for search_args: r4us_sansio.SpNamingsystem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.namingsystem_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn namingsystem_search(
  search_for search_args: r4us_sansio.SpNamingsystem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Namingsystem), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.namingsystem_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.namingsystem
    },
  )
}

pub fn nutritionorder_create(
  resource: r4us.Nutritionorder,
  client: FhirClient,
  handle_response: fn(Result(r4us.Nutritionorder, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.nutritionorder_to_json(resource),
    "NutritionOrder",
    r4us.nutritionorder_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionorder_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Nutritionorder, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "NutritionOrder",
    r4us.nutritionorder_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionorder_update(
  resource: r4us.Nutritionorder,
  client: FhirClient,
  handle_response: fn(Result(r4us.Nutritionorder, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.nutritionorder_to_json(resource),
    "NutritionOrder",
    r4us.nutritionorder_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionorder_delete(
  resource: r4us.Nutritionorder,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "NutritionOrder", client, handle_response)
}

pub fn nutritionorder_search_bundled(
  search_for search_args: r4us_sansio.SpNutritionorder,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.nutritionorder_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn nutritionorder_search(
  search_for search_args: r4us_sansio.SpNutritionorder,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Nutritionorder), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.nutritionorder_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.nutritionorder
    },
  )
}

pub fn us_core_body_temperature_create(
  resource: r4us.UsCoreBodyTemperature,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreBodyTemperature, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_body_temperature_to_json(resource),
    "Observation",
    r4us.us_core_body_temperature_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_body_temperature_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreBodyTemperature, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Observation",
    r4us.us_core_body_temperature_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_body_temperature_update(
  resource: r4us.UsCoreBodyTemperature,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreBodyTemperature, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_body_temperature_to_json(resource),
    "Observation",
    r4us.us_core_body_temperature_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_body_temperature_delete(
  resource: r4us.UsCoreBodyTemperature,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Observation", client, handle_response)
}

pub fn us_core_body_temperature_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreBodyTemperature,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_body_temperature_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_body_temperature_search(
  search_for search_args: r4us_sansio.SpUsCoreBodyTemperature,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.UsCoreBodyTemperature), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_body_temperature_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_body_temperature
    },
  )
}

pub fn us_core_observation_clinical_result_create(
  resource: r4us.UsCoreObservationClinicalResult,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreObservationClinicalResult, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_observation_clinical_result_to_json(resource),
    "Observation",
    r4us.us_core_observation_clinical_result_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_observation_clinical_result_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreObservationClinicalResult, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Observation",
    r4us.us_core_observation_clinical_result_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_observation_clinical_result_update(
  resource: r4us.UsCoreObservationClinicalResult,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreObservationClinicalResult, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_observation_clinical_result_to_json(resource),
    "Observation",
    r4us.us_core_observation_clinical_result_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_observation_clinical_result_delete(
  resource: r4us.UsCoreObservationClinicalResult,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Observation", client, handle_response)
}

pub fn us_core_observation_clinical_result_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreObservationClinicalResult,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_observation_clinical_result_search_req(
      search_args,
      client,
    )
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_observation_clinical_result_search(
  search_for search_args: r4us_sansio.SpUsCoreObservationClinicalResult,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.UsCoreObservationClinicalResult), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_observation_clinical_result_search_req(
      search_args,
      client,
    )
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_observation_clinical_result
    },
  )
}

pub fn us_core_observation_lab_create(
  resource: r4us.UsCoreObservationLab,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreObservationLab, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_observation_lab_to_json(resource),
    "Observation",
    r4us.us_core_observation_lab_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_observation_lab_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreObservationLab, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Observation",
    r4us.us_core_observation_lab_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_observation_lab_update(
  resource: r4us.UsCoreObservationLab,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreObservationLab, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_observation_lab_to_json(resource),
    "Observation",
    r4us.us_core_observation_lab_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_observation_lab_delete(
  resource: r4us.UsCoreObservationLab,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Observation", client, handle_response)
}

pub fn us_core_observation_lab_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreObservationLab,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_observation_lab_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_observation_lab_search(
  search_for search_args: r4us_sansio.SpUsCoreObservationLab,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.UsCoreObservationLab), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_observation_lab_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_observation_lab
    },
  )
}

pub fn us_core_treatment_intervention_preference_create(
  resource: r4us.UsCoreTreatmentInterventionPreference,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreTreatmentInterventionPreference, Err)) ->
    a,
) -> Effect(a) {
  any_create(
    r4us.us_core_treatment_intervention_preference_to_json(resource),
    "Observation",
    r4us.us_core_treatment_intervention_preference_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_treatment_intervention_preference_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreTreatmentInterventionPreference, Err)) ->
    a,
) -> Effect(a) {
  any_read(
    id,
    "Observation",
    r4us.us_core_treatment_intervention_preference_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_treatment_intervention_preference_update(
  resource: r4us.UsCoreTreatmentInterventionPreference,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreTreatmentInterventionPreference, Err)) ->
    a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_treatment_intervention_preference_to_json(resource),
    "Observation",
    r4us.us_core_treatment_intervention_preference_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_treatment_intervention_preference_delete(
  resource: r4us.UsCoreTreatmentInterventionPreference,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Observation", client, handle_response)
}

pub fn us_core_treatment_intervention_preference_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreTreatmentInterventionPreference,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_treatment_intervention_preference_search_req(
      search_args,
      client,
    )
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_treatment_intervention_preference_search(
  search_for search_args: r4us_sansio.SpUsCoreTreatmentInterventionPreference,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.UsCoreTreatmentInterventionPreference), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_treatment_intervention_preference_search_req(
      search_args,
      client,
    )
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_treatment_intervention_preference
    },
  )
}

pub fn us_core_observation_pregnancyintent_create(
  resource: r4us.UsCoreObservationPregnancyintent,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreObservationPregnancyintent, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_observation_pregnancyintent_to_json(resource),
    "Observation",
    r4us.us_core_observation_pregnancyintent_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_observation_pregnancyintent_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreObservationPregnancyintent, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Observation",
    r4us.us_core_observation_pregnancyintent_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_observation_pregnancyintent_update(
  resource: r4us.UsCoreObservationPregnancyintent,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreObservationPregnancyintent, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_observation_pregnancyintent_to_json(resource),
    "Observation",
    r4us.us_core_observation_pregnancyintent_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_observation_pregnancyintent_delete(
  resource: r4us.UsCoreObservationPregnancyintent,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Observation", client, handle_response)
}

pub fn us_core_observation_pregnancyintent_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreObservationPregnancyintent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_observation_pregnancyintent_search_req(
      search_args,
      client,
    )
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_observation_pregnancyintent_search(
  search_for search_args: r4us_sansio.SpUsCoreObservationPregnancyintent,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.UsCoreObservationPregnancyintent), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_observation_pregnancyintent_search_req(
      search_args,
      client,
    )
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_observation_pregnancyintent
    },
  )
}

pub fn us_core_simple_observation_create(
  resource: r4us.UsCoreSimpleObservation,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreSimpleObservation, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_simple_observation_to_json(resource),
    "Observation",
    r4us.us_core_simple_observation_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_simple_observation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreSimpleObservation, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Observation",
    r4us.us_core_simple_observation_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_simple_observation_update(
  resource: r4us.UsCoreSimpleObservation,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreSimpleObservation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_simple_observation_to_json(resource),
    "Observation",
    r4us.us_core_simple_observation_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_simple_observation_delete(
  resource: r4us.UsCoreSimpleObservation,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Observation", client, handle_response)
}

pub fn us_core_simple_observation_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreSimpleObservation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_simple_observation_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_simple_observation_search(
  search_for search_args: r4us_sansio.SpUsCoreSimpleObservation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.UsCoreSimpleObservation), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_simple_observation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_simple_observation
    },
  )
}

pub fn us_core_respiratory_rate_create(
  resource: r4us.UsCoreRespiratoryRate,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreRespiratoryRate, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_respiratory_rate_to_json(resource),
    "Observation",
    r4us.us_core_respiratory_rate_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_respiratory_rate_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreRespiratoryRate, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Observation",
    r4us.us_core_respiratory_rate_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_respiratory_rate_update(
  resource: r4us.UsCoreRespiratoryRate,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreRespiratoryRate, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_respiratory_rate_to_json(resource),
    "Observation",
    r4us.us_core_respiratory_rate_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_respiratory_rate_delete(
  resource: r4us.UsCoreRespiratoryRate,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Observation", client, handle_response)
}

pub fn us_core_respiratory_rate_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreRespiratoryRate,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_respiratory_rate_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_respiratory_rate_search(
  search_for search_args: r4us_sansio.SpUsCoreRespiratoryRate,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.UsCoreRespiratoryRate), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_respiratory_rate_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_respiratory_rate
    },
  )
}

pub fn us_core_observation_occupation_create(
  resource: r4us.UsCoreObservationOccupation,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreObservationOccupation, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_observation_occupation_to_json(resource),
    "Observation",
    r4us.us_core_observation_occupation_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_observation_occupation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreObservationOccupation, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Observation",
    r4us.us_core_observation_occupation_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_observation_occupation_update(
  resource: r4us.UsCoreObservationOccupation,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreObservationOccupation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_observation_occupation_to_json(resource),
    "Observation",
    r4us.us_core_observation_occupation_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_observation_occupation_delete(
  resource: r4us.UsCoreObservationOccupation,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Observation", client, handle_response)
}

pub fn us_core_observation_occupation_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreObservationOccupation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_observation_occupation_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_observation_occupation_search(
  search_for search_args: r4us_sansio.SpUsCoreObservationOccupation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.UsCoreObservationOccupation), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_observation_occupation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_observation_occupation
    },
  )
}

pub fn us_core_vital_signs_create(
  resource: r4us.UsCoreVitalSigns,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreVitalSigns, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_vital_signs_to_json(resource),
    "Observation",
    r4us.us_core_vital_signs_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_vital_signs_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreVitalSigns, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Observation",
    r4us.us_core_vital_signs_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_vital_signs_update(
  resource: r4us.UsCoreVitalSigns,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreVitalSigns, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_vital_signs_to_json(resource),
    "Observation",
    r4us.us_core_vital_signs_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_vital_signs_delete(
  resource: r4us.UsCoreVitalSigns,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Observation", client, handle_response)
}

pub fn us_core_vital_signs_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreVitalSigns,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_vital_signs_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_vital_signs_search(
  search_for search_args: r4us_sansio.SpUsCoreVitalSigns,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.UsCoreVitalSigns), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_vital_signs_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_vital_signs
    },
  )
}

pub fn us_core_body_weight_create(
  resource: r4us.UsCoreBodyWeight,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreBodyWeight, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_body_weight_to_json(resource),
    "Observation",
    r4us.us_core_body_weight_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_body_weight_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreBodyWeight, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Observation",
    r4us.us_core_body_weight_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_body_weight_update(
  resource: r4us.UsCoreBodyWeight,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreBodyWeight, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_body_weight_to_json(resource),
    "Observation",
    r4us.us_core_body_weight_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_body_weight_delete(
  resource: r4us.UsCoreBodyWeight,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Observation", client, handle_response)
}

pub fn us_core_body_weight_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreBodyWeight,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_body_weight_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_body_weight_search(
  search_for search_args: r4us_sansio.SpUsCoreBodyWeight,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.UsCoreBodyWeight), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_body_weight_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_body_weight
    },
  )
}

pub fn us_core_observation_pregnancystatus_create(
  resource: r4us.UsCoreObservationPregnancystatus,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreObservationPregnancystatus, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_observation_pregnancystatus_to_json(resource),
    "Observation",
    r4us.us_core_observation_pregnancystatus_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_observation_pregnancystatus_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreObservationPregnancystatus, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Observation",
    r4us.us_core_observation_pregnancystatus_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_observation_pregnancystatus_update(
  resource: r4us.UsCoreObservationPregnancystatus,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreObservationPregnancystatus, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_observation_pregnancystatus_to_json(resource),
    "Observation",
    r4us.us_core_observation_pregnancystatus_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_observation_pregnancystatus_delete(
  resource: r4us.UsCoreObservationPregnancystatus,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Observation", client, handle_response)
}

pub fn us_core_observation_pregnancystatus_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreObservationPregnancystatus,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_observation_pregnancystatus_search_req(
      search_args,
      client,
    )
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_observation_pregnancystatus_search(
  search_for search_args: r4us_sansio.SpUsCoreObservationPregnancystatus,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.UsCoreObservationPregnancystatus), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_observation_pregnancystatus_search_req(
      search_args,
      client,
    )
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_observation_pregnancystatus
    },
  )
}

pub fn us_core_blood_pressure_create(
  resource: r4us.UsCoreBloodPressure,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreBloodPressure, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_blood_pressure_to_json(resource),
    "Observation",
    r4us.us_core_blood_pressure_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_blood_pressure_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreBloodPressure, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Observation",
    r4us.us_core_blood_pressure_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_blood_pressure_update(
  resource: r4us.UsCoreBloodPressure,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreBloodPressure, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_blood_pressure_to_json(resource),
    "Observation",
    r4us.us_core_blood_pressure_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_blood_pressure_delete(
  resource: r4us.UsCoreBloodPressure,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Observation", client, handle_response)
}

pub fn us_core_blood_pressure_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreBloodPressure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_blood_pressure_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_blood_pressure_search(
  search_for search_args: r4us_sansio.SpUsCoreBloodPressure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.UsCoreBloodPressure), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_blood_pressure_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_blood_pressure
    },
  )
}

pub fn pediatric_bmi_for_age_create(
  resource: r4us.PediatricBmiForAge,
  client: FhirClient,
  handle_response: fn(Result(r4us.PediatricBmiForAge, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.pediatric_bmi_for_age_to_json(resource),
    "Observation",
    r4us.pediatric_bmi_for_age_decoder(),
    client,
    handle_response,
  )
}

pub fn pediatric_bmi_for_age_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.PediatricBmiForAge, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Observation",
    r4us.pediatric_bmi_for_age_decoder(),
    client,
    handle_response,
  )
}

pub fn pediatric_bmi_for_age_update(
  resource: r4us.PediatricBmiForAge,
  client: FhirClient,
  handle_response: fn(Result(r4us.PediatricBmiForAge, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.pediatric_bmi_for_age_to_json(resource),
    "Observation",
    r4us.pediatric_bmi_for_age_decoder(),
    client,
    handle_response,
  )
}

pub fn pediatric_bmi_for_age_delete(
  resource: r4us.PediatricBmiForAge,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Observation", client, handle_response)
}

pub fn pediatric_bmi_for_age_search_bundled(
  search_for search_args: r4us_sansio.SpPediatricBmiForAge,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.pediatric_bmi_for_age_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn pediatric_bmi_for_age_search(
  search_for search_args: r4us_sansio.SpPediatricBmiForAge,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.PediatricBmiForAge), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.pediatric_bmi_for_age_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.pediatric_bmi_for_age
    },
  )
}

pub fn us_core_care_experience_preference_create(
  resource: r4us.UsCoreCareExperiencePreference,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreCareExperiencePreference, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_care_experience_preference_to_json(resource),
    "Observation",
    r4us.us_core_care_experience_preference_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_care_experience_preference_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreCareExperiencePreference, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Observation",
    r4us.us_core_care_experience_preference_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_care_experience_preference_update(
  resource: r4us.UsCoreCareExperiencePreference,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreCareExperiencePreference, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_care_experience_preference_to_json(resource),
    "Observation",
    r4us.us_core_care_experience_preference_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_care_experience_preference_delete(
  resource: r4us.UsCoreCareExperiencePreference,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Observation", client, handle_response)
}

pub fn us_core_care_experience_preference_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreCareExperiencePreference,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_care_experience_preference_search_req(
      search_args,
      client,
    )
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_care_experience_preference_search(
  search_for search_args: r4us_sansio.SpUsCoreCareExperiencePreference,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.UsCoreCareExperiencePreference), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_care_experience_preference_search_req(
      search_args,
      client,
    )
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_care_experience_preference
    },
  )
}

pub fn us_core_observation_screening_assessment_create(
  resource: r4us.UsCoreObservationScreeningAssessment,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreObservationScreeningAssessment, Err)) ->
    a,
) -> Effect(a) {
  any_create(
    r4us.us_core_observation_screening_assessment_to_json(resource),
    "Observation",
    r4us.us_core_observation_screening_assessment_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_observation_screening_assessment_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreObservationScreeningAssessment, Err)) ->
    a,
) -> Effect(a) {
  any_read(
    id,
    "Observation",
    r4us.us_core_observation_screening_assessment_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_observation_screening_assessment_update(
  resource: r4us.UsCoreObservationScreeningAssessment,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreObservationScreeningAssessment, Err)) ->
    a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_observation_screening_assessment_to_json(resource),
    "Observation",
    r4us.us_core_observation_screening_assessment_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_observation_screening_assessment_delete(
  resource: r4us.UsCoreObservationScreeningAssessment,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Observation", client, handle_response)
}

pub fn us_core_observation_screening_assessment_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreObservationScreeningAssessment,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_observation_screening_assessment_search_req(
      search_args,
      client,
    )
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_observation_screening_assessment_search(
  search_for search_args: r4us_sansio.SpUsCoreObservationScreeningAssessment,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.UsCoreObservationScreeningAssessment), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_observation_screening_assessment_search_req(
      search_args,
      client,
    )
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_observation_screening_assessment
    },
  )
}

pub fn us_core_head_circumference_create(
  resource: r4us.UsCoreHeadCircumference,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreHeadCircumference, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_head_circumference_to_json(resource),
    "Observation",
    r4us.us_core_head_circumference_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_head_circumference_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreHeadCircumference, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Observation",
    r4us.us_core_head_circumference_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_head_circumference_update(
  resource: r4us.UsCoreHeadCircumference,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreHeadCircumference, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_head_circumference_to_json(resource),
    "Observation",
    r4us.us_core_head_circumference_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_head_circumference_delete(
  resource: r4us.UsCoreHeadCircumference,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Observation", client, handle_response)
}

pub fn us_core_head_circumference_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreHeadCircumference,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_head_circumference_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_head_circumference_search(
  search_for search_args: r4us_sansio.SpUsCoreHeadCircumference,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.UsCoreHeadCircumference), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_head_circumference_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_head_circumference
    },
  )
}

pub fn us_core_heart_rate_create(
  resource: r4us.UsCoreHeartRate,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreHeartRate, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_heart_rate_to_json(resource),
    "Observation",
    r4us.us_core_heart_rate_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_heart_rate_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreHeartRate, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Observation",
    r4us.us_core_heart_rate_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_heart_rate_update(
  resource: r4us.UsCoreHeartRate,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreHeartRate, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_heart_rate_to_json(resource),
    "Observation",
    r4us.us_core_heart_rate_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_heart_rate_delete(
  resource: r4us.UsCoreHeartRate,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Observation", client, handle_response)
}

pub fn us_core_heart_rate_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreHeartRate,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_heart_rate_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_heart_rate_search(
  search_for search_args: r4us_sansio.SpUsCoreHeartRate,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.UsCoreHeartRate), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_heart_rate_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_heart_rate
    },
  )
}

pub fn us_core_observation_sexual_orientation_create(
  resource: r4us.UsCoreObservationSexualOrientation,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreObservationSexualOrientation, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_observation_sexual_orientation_to_json(resource),
    "Observation",
    r4us.us_core_observation_sexual_orientation_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_observation_sexual_orientation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreObservationSexualOrientation, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Observation",
    r4us.us_core_observation_sexual_orientation_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_observation_sexual_orientation_update(
  resource: r4us.UsCoreObservationSexualOrientation,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreObservationSexualOrientation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_observation_sexual_orientation_to_json(resource),
    "Observation",
    r4us.us_core_observation_sexual_orientation_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_observation_sexual_orientation_delete(
  resource: r4us.UsCoreObservationSexualOrientation,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Observation", client, handle_response)
}

pub fn us_core_observation_sexual_orientation_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreObservationSexualOrientation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_observation_sexual_orientation_search_req(
      search_args,
      client,
    )
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_observation_sexual_orientation_search(
  search_for search_args: r4us_sansio.SpUsCoreObservationSexualOrientation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.UsCoreObservationSexualOrientation), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_observation_sexual_orientation_search_req(
      search_args,
      client,
    )
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_observation_sexual_orientation
    },
  )
}

pub fn pediatric_weight_for_height_create(
  resource: r4us.PediatricWeightForHeight,
  client: FhirClient,
  handle_response: fn(Result(r4us.PediatricWeightForHeight, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.pediatric_weight_for_height_to_json(resource),
    "Observation",
    r4us.pediatric_weight_for_height_decoder(),
    client,
    handle_response,
  )
}

pub fn pediatric_weight_for_height_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.PediatricWeightForHeight, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Observation",
    r4us.pediatric_weight_for_height_decoder(),
    client,
    handle_response,
  )
}

pub fn pediatric_weight_for_height_update(
  resource: r4us.PediatricWeightForHeight,
  client: FhirClient,
  handle_response: fn(Result(r4us.PediatricWeightForHeight, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.pediatric_weight_for_height_to_json(resource),
    "Observation",
    r4us.pediatric_weight_for_height_decoder(),
    client,
    handle_response,
  )
}

pub fn pediatric_weight_for_height_delete(
  resource: r4us.PediatricWeightForHeight,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Observation", client, handle_response)
}

pub fn pediatric_weight_for_height_search_bundled(
  search_for search_args: r4us_sansio.SpPediatricWeightForHeight,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.pediatric_weight_for_height_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn pediatric_weight_for_height_search(
  search_for search_args: r4us_sansio.SpPediatricWeightForHeight,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.PediatricWeightForHeight), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.pediatric_weight_for_height_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.pediatric_weight_for_height
    },
  )
}

pub fn us_core_bmi_create(
  resource: r4us.UsCoreBmi,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreBmi, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_bmi_to_json(resource),
    "Observation",
    r4us.us_core_bmi_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_bmi_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreBmi, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Observation",
    r4us.us_core_bmi_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_bmi_update(
  resource: r4us.UsCoreBmi,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreBmi, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_bmi_to_json(resource),
    "Observation",
    r4us.us_core_bmi_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_bmi_delete(
  resource: r4us.UsCoreBmi,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Observation", client, handle_response)
}

pub fn us_core_bmi_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreBmi,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_bmi_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_bmi_search(
  search_for search_args: r4us_sansio.SpUsCoreBmi,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.UsCoreBmi), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_bmi_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_bmi
    },
  )
}

pub fn us_core_body_height_create(
  resource: r4us.UsCoreBodyHeight,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreBodyHeight, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_body_height_to_json(resource),
    "Observation",
    r4us.us_core_body_height_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_body_height_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreBodyHeight, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Observation",
    r4us.us_core_body_height_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_body_height_update(
  resource: r4us.UsCoreBodyHeight,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreBodyHeight, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_body_height_to_json(resource),
    "Observation",
    r4us.us_core_body_height_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_body_height_delete(
  resource: r4us.UsCoreBodyHeight,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Observation", client, handle_response)
}

pub fn us_core_body_height_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreBodyHeight,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_body_height_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_body_height_search(
  search_for search_args: r4us_sansio.SpUsCoreBodyHeight,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.UsCoreBodyHeight), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_body_height_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_body_height
    },
  )
}

pub fn us_core_smokingstatus_create(
  resource: r4us.UsCoreSmokingstatus,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreSmokingstatus, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_smokingstatus_to_json(resource),
    "Observation",
    r4us.us_core_smokingstatus_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_smokingstatus_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreSmokingstatus, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Observation",
    r4us.us_core_smokingstatus_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_smokingstatus_update(
  resource: r4us.UsCoreSmokingstatus,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreSmokingstatus, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_smokingstatus_to_json(resource),
    "Observation",
    r4us.us_core_smokingstatus_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_smokingstatus_delete(
  resource: r4us.UsCoreSmokingstatus,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Observation", client, handle_response)
}

pub fn us_core_smokingstatus_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreSmokingstatus,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_smokingstatus_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_smokingstatus_search(
  search_for search_args: r4us_sansio.SpUsCoreSmokingstatus,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.UsCoreSmokingstatus), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_smokingstatus_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_smokingstatus
    },
  )
}

pub fn us_core_pulse_oximetry_create(
  resource: r4us.UsCorePulseOximetry,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCorePulseOximetry, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_pulse_oximetry_to_json(resource),
    "Observation",
    r4us.us_core_pulse_oximetry_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_pulse_oximetry_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCorePulseOximetry, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Observation",
    r4us.us_core_pulse_oximetry_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_pulse_oximetry_update(
  resource: r4us.UsCorePulseOximetry,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCorePulseOximetry, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_pulse_oximetry_to_json(resource),
    "Observation",
    r4us.us_core_pulse_oximetry_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_pulse_oximetry_delete(
  resource: r4us.UsCorePulseOximetry,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Observation", client, handle_response)
}

pub fn us_core_pulse_oximetry_search_bundled(
  search_for search_args: r4us_sansio.SpUsCorePulseOximetry,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_pulse_oximetry_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_pulse_oximetry_search(
  search_for search_args: r4us_sansio.SpUsCorePulseOximetry,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.UsCorePulseOximetry), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_pulse_oximetry_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_pulse_oximetry
    },
  )
}

pub fn head_occipital_frontal_circumference_percentile_create(
  resource: r4us.HeadOccipitalFrontalCircumferencePercentile,
  client: FhirClient,
  handle_response: fn(
    Result(r4us.HeadOccipitalFrontalCircumferencePercentile, Err),
  ) ->
    a,
) -> Effect(a) {
  any_create(
    r4us.head_occipital_frontal_circumference_percentile_to_json(resource),
    "Observation",
    r4us.head_occipital_frontal_circumference_percentile_decoder(),
    client,
    handle_response,
  )
}

pub fn head_occipital_frontal_circumference_percentile_read(
  id: String,
  client: FhirClient,
  handle_response: fn(
    Result(r4us.HeadOccipitalFrontalCircumferencePercentile, Err),
  ) ->
    a,
) -> Effect(a) {
  any_read(
    id,
    "Observation",
    r4us.head_occipital_frontal_circumference_percentile_decoder(),
    client,
    handle_response,
  )
}

pub fn head_occipital_frontal_circumference_percentile_update(
  resource: r4us.HeadOccipitalFrontalCircumferencePercentile,
  client: FhirClient,
  handle_response: fn(
    Result(r4us.HeadOccipitalFrontalCircumferencePercentile, Err),
  ) ->
    a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.head_occipital_frontal_circumference_percentile_to_json(resource),
    "Observation",
    r4us.head_occipital_frontal_circumference_percentile_decoder(),
    client,
    handle_response,
  )
}

pub fn head_occipital_frontal_circumference_percentile_delete(
  resource: r4us.HeadOccipitalFrontalCircumferencePercentile,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Observation", client, handle_response)
}

pub fn head_occipital_frontal_circumference_percentile_search_bundled(
  search_for search_args: r4us_sansio.SpHeadOccipitalFrontalCircumferencePercentile,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.head_occipital_frontal_circumference_percentile_search_req(
      search_args,
      client,
    )
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn head_occipital_frontal_circumference_percentile_search(
  search_for search_args: r4us_sansio.SpHeadOccipitalFrontalCircumferencePercentile,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.HeadOccipitalFrontalCircumferencePercentile), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.head_occipital_frontal_circumference_percentile_search_req(
      search_args,
      client,
    )
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.head_occipital_frontal_circumference_percentile
    },
  )
}

pub fn us_core_average_blood_pressure_create(
  resource: r4us.UsCoreAverageBloodPressure,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreAverageBloodPressure, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_average_blood_pressure_to_json(resource),
    "Observation",
    r4us.us_core_average_blood_pressure_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_average_blood_pressure_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreAverageBloodPressure, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Observation",
    r4us.us_core_average_blood_pressure_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_average_blood_pressure_update(
  resource: r4us.UsCoreAverageBloodPressure,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreAverageBloodPressure, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_average_blood_pressure_to_json(resource),
    "Observation",
    r4us.us_core_average_blood_pressure_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_average_blood_pressure_delete(
  resource: r4us.UsCoreAverageBloodPressure,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Observation", client, handle_response)
}

pub fn us_core_average_blood_pressure_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreAverageBloodPressure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_average_blood_pressure_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_average_blood_pressure_search(
  search_for search_args: r4us_sansio.SpUsCoreAverageBloodPressure,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.UsCoreAverageBloodPressure), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_average_blood_pressure_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_average_blood_pressure
    },
  )
}

pub fn us_core_observation_adi_documentation_create(
  resource: r4us.UsCoreObservationAdiDocumentation,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreObservationAdiDocumentation, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_observation_adi_documentation_to_json(resource),
    "Observation",
    r4us.us_core_observation_adi_documentation_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_observation_adi_documentation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreObservationAdiDocumentation, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Observation",
    r4us.us_core_observation_adi_documentation_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_observation_adi_documentation_update(
  resource: r4us.UsCoreObservationAdiDocumentation,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreObservationAdiDocumentation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_observation_adi_documentation_to_json(resource),
    "Observation",
    r4us.us_core_observation_adi_documentation_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_observation_adi_documentation_delete(
  resource: r4us.UsCoreObservationAdiDocumentation,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Observation", client, handle_response)
}

pub fn us_core_observation_adi_documentation_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreObservationAdiDocumentation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_observation_adi_documentation_search_req(
      search_args,
      client,
    )
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_observation_adi_documentation_search(
  search_for search_args: r4us_sansio.SpUsCoreObservationAdiDocumentation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.UsCoreObservationAdiDocumentation), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_observation_adi_documentation_search_req(
      search_args,
      client,
    )
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_observation_adi_documentation
    },
  )
}

pub fn observationdefinition_create(
  resource: r4us.Observationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Observationdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.observationdefinition_to_json(resource),
    "ObservationDefinition",
    r4us.observationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn observationdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Observationdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ObservationDefinition",
    r4us.observationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn observationdefinition_update(
  resource: r4us.Observationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Observationdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.observationdefinition_to_json(resource),
    "ObservationDefinition",
    r4us.observationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn observationdefinition_delete(
  resource: r4us.Observationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ObservationDefinition", client, handle_response)
}

pub fn observationdefinition_search_bundled(
  search_for search_args: r4us_sansio.SpObservationdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.observationdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn observationdefinition_search(
  search_for search_args: r4us_sansio.SpObservationdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.Observationdefinition), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.observationdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.observationdefinition
    },
  )
}

pub fn operationdefinition_create(
  resource: r4us.Operationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.operationdefinition_to_json(resource),
    "OperationDefinition",
    r4us.operationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn operationdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "OperationDefinition",
    r4us.operationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn operationdefinition_update(
  resource: r4us.Operationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.operationdefinition_to_json(resource),
    "OperationDefinition",
    r4us.operationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn operationdefinition_delete(
  resource: r4us.Operationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "OperationDefinition", client, handle_response)
}

pub fn operationdefinition_search_bundled(
  search_for search_args: r4us_sansio.SpOperationdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.operationdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn operationdefinition_search(
  search_for search_args: r4us_sansio.SpOperationdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Operationdefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.operationdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.operationdefinition
    },
  )
}

pub fn operationoutcome_create(
  resource: r4us.Operationoutcome,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.operationoutcome_to_json(resource),
    "OperationOutcome",
    r4us.operationoutcome_decoder(),
    client,
    handle_response,
  )
}

pub fn operationoutcome_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "OperationOutcome",
    r4us.operationoutcome_decoder(),
    client,
    handle_response,
  )
}

pub fn operationoutcome_update(
  resource: r4us.Operationoutcome,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.operationoutcome_to_json(resource),
    "OperationOutcome",
    r4us.operationoutcome_decoder(),
    client,
    handle_response,
  )
}

pub fn operationoutcome_delete(
  resource: r4us.Operationoutcome,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "OperationOutcome", client, handle_response)
}

pub fn operationoutcome_search_bundled(
  search_for search_args: r4us_sansio.SpOperationoutcome,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.operationoutcome_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn operationoutcome_search(
  search_for search_args: r4us_sansio.SpOperationoutcome,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Operationoutcome), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.operationoutcome_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.operationoutcome
    },
  )
}

pub fn us_core_organization_create(
  resource: r4us.UsCoreOrganization,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreOrganization, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_organization_to_json(resource),
    "Organization",
    r4us.us_core_organization_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_organization_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreOrganization, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Organization",
    r4us.us_core_organization_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_organization_update(
  resource: r4us.UsCoreOrganization,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreOrganization, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_organization_to_json(resource),
    "Organization",
    r4us.us_core_organization_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_organization_delete(
  resource: r4us.UsCoreOrganization,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Organization", client, handle_response)
}

pub fn us_core_organization_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreOrganization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_organization_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_organization_search(
  search_for search_args: r4us_sansio.SpUsCoreOrganization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.UsCoreOrganization), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_organization_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_organization
    },
  )
}

pub fn organizationaffiliation_create(
  resource: r4us.Organizationaffiliation,
  client: FhirClient,
  handle_response: fn(Result(r4us.Organizationaffiliation, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.organizationaffiliation_to_json(resource),
    "OrganizationAffiliation",
    r4us.organizationaffiliation_decoder(),
    client,
    handle_response,
  )
}

pub fn organizationaffiliation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Organizationaffiliation, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "OrganizationAffiliation",
    r4us.organizationaffiliation_decoder(),
    client,
    handle_response,
  )
}

pub fn organizationaffiliation_update(
  resource: r4us.Organizationaffiliation,
  client: FhirClient,
  handle_response: fn(Result(r4us.Organizationaffiliation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.organizationaffiliation_to_json(resource),
    "OrganizationAffiliation",
    r4us.organizationaffiliation_decoder(),
    client,
    handle_response,
  )
}

pub fn organizationaffiliation_delete(
  resource: r4us.Organizationaffiliation,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "OrganizationAffiliation", client, handle_response)
}

pub fn organizationaffiliation_search_bundled(
  search_for search_args: r4us_sansio.SpOrganizationaffiliation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.organizationaffiliation_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn organizationaffiliation_search(
  search_for search_args: r4us_sansio.SpOrganizationaffiliation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.Organizationaffiliation), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.organizationaffiliation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.organizationaffiliation
    },
  )
}

pub fn us_core_patient_create(
  resource: r4us.UsCorePatient,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCorePatient, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_patient_to_json(resource),
    "Patient",
    r4us.us_core_patient_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_patient_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCorePatient, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Patient",
    r4us.us_core_patient_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_patient_update(
  resource: r4us.UsCorePatient,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCorePatient, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_patient_to_json(resource),
    "Patient",
    r4us.us_core_patient_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_patient_delete(
  resource: r4us.UsCorePatient,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Patient", client, handle_response)
}

pub fn us_core_patient_search_bundled(
  search_for search_args: r4us_sansio.SpUsCorePatient,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_patient_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_patient_search(
  search_for search_args: r4us_sansio.SpUsCorePatient,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.UsCorePatient), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_patient_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_patient
    },
  )
}

pub fn paymentnotice_create(
  resource: r4us.Paymentnotice,
  client: FhirClient,
  handle_response: fn(Result(r4us.Paymentnotice, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.paymentnotice_to_json(resource),
    "PaymentNotice",
    r4us.paymentnotice_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentnotice_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Paymentnotice, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "PaymentNotice",
    r4us.paymentnotice_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentnotice_update(
  resource: r4us.Paymentnotice,
  client: FhirClient,
  handle_response: fn(Result(r4us.Paymentnotice, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.paymentnotice_to_json(resource),
    "PaymentNotice",
    r4us.paymentnotice_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentnotice_delete(
  resource: r4us.Paymentnotice,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "PaymentNotice", client, handle_response)
}

pub fn paymentnotice_search_bundled(
  search_for search_args: r4us_sansio.SpPaymentnotice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.paymentnotice_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn paymentnotice_search(
  search_for search_args: r4us_sansio.SpPaymentnotice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Paymentnotice), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.paymentnotice_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.paymentnotice
    },
  )
}

pub fn paymentreconciliation_create(
  resource: r4us.Paymentreconciliation,
  client: FhirClient,
  handle_response: fn(Result(r4us.Paymentreconciliation, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.paymentreconciliation_to_json(resource),
    "PaymentReconciliation",
    r4us.paymentreconciliation_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentreconciliation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Paymentreconciliation, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "PaymentReconciliation",
    r4us.paymentreconciliation_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentreconciliation_update(
  resource: r4us.Paymentreconciliation,
  client: FhirClient,
  handle_response: fn(Result(r4us.Paymentreconciliation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.paymentreconciliation_to_json(resource),
    "PaymentReconciliation",
    r4us.paymentreconciliation_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentreconciliation_delete(
  resource: r4us.Paymentreconciliation,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "PaymentReconciliation", client, handle_response)
}

pub fn paymentreconciliation_search_bundled(
  search_for search_args: r4us_sansio.SpPaymentreconciliation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.paymentreconciliation_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn paymentreconciliation_search(
  search_for search_args: r4us_sansio.SpPaymentreconciliation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.Paymentreconciliation), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.paymentreconciliation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.paymentreconciliation
    },
  )
}

pub fn person_create(
  resource: r4us.Person,
  client: FhirClient,
  handle_response: fn(Result(r4us.Person, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.person_to_json(resource),
    "Person",
    r4us.person_decoder(),
    client,
    handle_response,
  )
}

pub fn person_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Person, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Person", r4us.person_decoder(), client, handle_response)
}

pub fn person_update(
  resource: r4us.Person,
  client: FhirClient,
  handle_response: fn(Result(r4us.Person, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.person_to_json(resource),
    "Person",
    r4us.person_decoder(),
    client,
    handle_response,
  )
}

pub fn person_delete(
  resource: r4us.Person,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Person", client, handle_response)
}

pub fn person_search_bundled(
  search_for search_args: r4us_sansio.SpPerson,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.person_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn person_search(
  search_for search_args: r4us_sansio.SpPerson,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Person), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.person_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4us_sansio.bundle_to_groupedresources }.person },
  )
}

pub fn plandefinition_create(
  resource: r4us.Plandefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Plandefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.plandefinition_to_json(resource),
    "PlanDefinition",
    r4us.plandefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn plandefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Plandefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "PlanDefinition",
    r4us.plandefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn plandefinition_update(
  resource: r4us.Plandefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Plandefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.plandefinition_to_json(resource),
    "PlanDefinition",
    r4us.plandefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn plandefinition_delete(
  resource: r4us.Plandefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "PlanDefinition", client, handle_response)
}

pub fn plandefinition_search_bundled(
  search_for search_args: r4us_sansio.SpPlandefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.plandefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn plandefinition_search(
  search_for search_args: r4us_sansio.SpPlandefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Plandefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.plandefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.plandefinition
    },
  )
}

pub fn us_core_practitioner_create(
  resource: r4us.UsCorePractitioner,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCorePractitioner, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_practitioner_to_json(resource),
    "Practitioner",
    r4us.us_core_practitioner_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_practitioner_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCorePractitioner, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Practitioner",
    r4us.us_core_practitioner_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_practitioner_update(
  resource: r4us.UsCorePractitioner,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCorePractitioner, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_practitioner_to_json(resource),
    "Practitioner",
    r4us.us_core_practitioner_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_practitioner_delete(
  resource: r4us.UsCorePractitioner,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Practitioner", client, handle_response)
}

pub fn us_core_practitioner_search_bundled(
  search_for search_args: r4us_sansio.SpUsCorePractitioner,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_practitioner_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_practitioner_search(
  search_for search_args: r4us_sansio.SpUsCorePractitioner,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.UsCorePractitioner), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_practitioner_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_practitioner
    },
  )
}

pub fn us_core_practitionerrole_create(
  resource: r4us.UsCorePractitionerrole,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCorePractitionerrole, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_practitionerrole_to_json(resource),
    "PractitionerRole",
    r4us.us_core_practitionerrole_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_practitionerrole_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCorePractitionerrole, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "PractitionerRole",
    r4us.us_core_practitionerrole_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_practitionerrole_update(
  resource: r4us.UsCorePractitionerrole,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCorePractitionerrole, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_practitionerrole_to_json(resource),
    "PractitionerRole",
    r4us.us_core_practitionerrole_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_practitionerrole_delete(
  resource: r4us.UsCorePractitionerrole,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "PractitionerRole", client, handle_response)
}

pub fn us_core_practitionerrole_search_bundled(
  search_for search_args: r4us_sansio.SpUsCorePractitionerrole,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_practitionerrole_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_practitionerrole_search(
  search_for search_args: r4us_sansio.SpUsCorePractitionerrole,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.UsCorePractitionerrole), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_practitionerrole_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_practitionerrole
    },
  )
}

pub fn us_core_procedure_create(
  resource: r4us.UsCoreProcedure,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreProcedure, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_procedure_to_json(resource),
    "Procedure",
    r4us.us_core_procedure_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_procedure_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreProcedure, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Procedure",
    r4us.us_core_procedure_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_procedure_update(
  resource: r4us.UsCoreProcedure,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreProcedure, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_procedure_to_json(resource),
    "Procedure",
    r4us.us_core_procedure_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_procedure_delete(
  resource: r4us.UsCoreProcedure,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Procedure", client, handle_response)
}

pub fn us_core_procedure_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreProcedure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_procedure_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_procedure_search(
  search_for search_args: r4us_sansio.SpUsCoreProcedure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.UsCoreProcedure), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_procedure_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_procedure
    },
  )
}

pub fn us_core_provenance_create(
  resource: r4us.UsCoreProvenance,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreProvenance, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_provenance_to_json(resource),
    "Provenance",
    r4us.us_core_provenance_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_provenance_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreProvenance, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Provenance",
    r4us.us_core_provenance_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_provenance_update(
  resource: r4us.UsCoreProvenance,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreProvenance, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_provenance_to_json(resource),
    "Provenance",
    r4us.us_core_provenance_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_provenance_delete(
  resource: r4us.UsCoreProvenance,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Provenance", client, handle_response)
}

pub fn us_core_provenance_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreProvenance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_provenance_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_provenance_search(
  search_for search_args: r4us_sansio.SpUsCoreProvenance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.UsCoreProvenance), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_provenance_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_provenance
    },
  )
}

pub fn questionnaire_create(
  resource: r4us.Questionnaire,
  client: FhirClient,
  handle_response: fn(Result(r4us.Questionnaire, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.questionnaire_to_json(resource),
    "Questionnaire",
    r4us.questionnaire_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaire_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Questionnaire, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Questionnaire",
    r4us.questionnaire_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaire_update(
  resource: r4us.Questionnaire,
  client: FhirClient,
  handle_response: fn(Result(r4us.Questionnaire, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.questionnaire_to_json(resource),
    "Questionnaire",
    r4us.questionnaire_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaire_delete(
  resource: r4us.Questionnaire,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Questionnaire", client, handle_response)
}

pub fn questionnaire_search_bundled(
  search_for search_args: r4us_sansio.SpQuestionnaire,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.questionnaire_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn questionnaire_search(
  search_for search_args: r4us_sansio.SpQuestionnaire,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Questionnaire), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.questionnaire_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.questionnaire
    },
  )
}

pub fn us_core_questionnaireresponse_create(
  resource: r4us.UsCoreQuestionnaireresponse,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreQuestionnaireresponse, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    r4us.us_core_questionnaireresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_questionnaireresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreQuestionnaireresponse, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "QuestionnaireResponse",
    r4us.us_core_questionnaireresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_questionnaireresponse_update(
  resource: r4us.UsCoreQuestionnaireresponse,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreQuestionnaireresponse, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    r4us.us_core_questionnaireresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_questionnaireresponse_delete(
  resource: r4us.UsCoreQuestionnaireresponse,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "QuestionnaireResponse", client, handle_response)
}

pub fn us_core_questionnaireresponse_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreQuestionnaireresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_questionnaireresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_questionnaireresponse_search(
  search_for search_args: r4us_sansio.SpUsCoreQuestionnaireresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.UsCoreQuestionnaireresponse), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.us_core_questionnaireresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_questionnaireresponse
    },
  )
}

pub fn us_core_relatedperson_create(
  resource: r4us.UsCoreRelatedperson,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreRelatedperson, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_relatedperson_to_json(resource),
    "RelatedPerson",
    r4us.us_core_relatedperson_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_relatedperson_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreRelatedperson, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "RelatedPerson",
    r4us.us_core_relatedperson_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_relatedperson_update(
  resource: r4us.UsCoreRelatedperson,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreRelatedperson, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_relatedperson_to_json(resource),
    "RelatedPerson",
    r4us.us_core_relatedperson_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_relatedperson_delete(
  resource: r4us.UsCoreRelatedperson,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "RelatedPerson", client, handle_response)
}

pub fn us_core_relatedperson_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreRelatedperson,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_relatedperson_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_relatedperson_search(
  search_for search_args: r4us_sansio.SpUsCoreRelatedperson,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.UsCoreRelatedperson), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_relatedperson_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_relatedperson
    },
  )
}

pub fn requestgroup_create(
  resource: r4us.Requestgroup,
  client: FhirClient,
  handle_response: fn(Result(r4us.Requestgroup, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.requestgroup_to_json(resource),
    "RequestGroup",
    r4us.requestgroup_decoder(),
    client,
    handle_response,
  )
}

pub fn requestgroup_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Requestgroup, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "RequestGroup",
    r4us.requestgroup_decoder(),
    client,
    handle_response,
  )
}

pub fn requestgroup_update(
  resource: r4us.Requestgroup,
  client: FhirClient,
  handle_response: fn(Result(r4us.Requestgroup, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.requestgroup_to_json(resource),
    "RequestGroup",
    r4us.requestgroup_decoder(),
    client,
    handle_response,
  )
}

pub fn requestgroup_delete(
  resource: r4us.Requestgroup,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "RequestGroup", client, handle_response)
}

pub fn requestgroup_search_bundled(
  search_for search_args: r4us_sansio.SpRequestgroup,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.requestgroup_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn requestgroup_search(
  search_for search_args: r4us_sansio.SpRequestgroup,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Requestgroup), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.requestgroup_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.requestgroup
    },
  )
}

pub fn researchdefinition_create(
  resource: r4us.Researchdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Researchdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.researchdefinition_to_json(resource),
    "ResearchDefinition",
    r4us.researchdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn researchdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Researchdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ResearchDefinition",
    r4us.researchdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn researchdefinition_update(
  resource: r4us.Researchdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Researchdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.researchdefinition_to_json(resource),
    "ResearchDefinition",
    r4us.researchdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn researchdefinition_delete(
  resource: r4us.Researchdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ResearchDefinition", client, handle_response)
}

pub fn researchdefinition_search_bundled(
  search_for search_args: r4us_sansio.SpResearchdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.researchdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn researchdefinition_search(
  search_for search_args: r4us_sansio.SpResearchdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Researchdefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.researchdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.researchdefinition
    },
  )
}

pub fn researchelementdefinition_create(
  resource: r4us.Researchelementdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Researchelementdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.researchelementdefinition_to_json(resource),
    "ResearchElementDefinition",
    r4us.researchelementdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn researchelementdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Researchelementdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ResearchElementDefinition",
    r4us.researchelementdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn researchelementdefinition_update(
  resource: r4us.Researchelementdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Researchelementdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.researchelementdefinition_to_json(resource),
    "ResearchElementDefinition",
    r4us.researchelementdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn researchelementdefinition_delete(
  resource: r4us.Researchelementdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ResearchElementDefinition", client, handle_response)
}

pub fn researchelementdefinition_search_bundled(
  search_for search_args: r4us_sansio.SpResearchelementdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.researchelementdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn researchelementdefinition_search(
  search_for search_args: r4us_sansio.SpResearchelementdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.Researchelementdefinition), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.researchelementdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.researchelementdefinition
    },
  )
}

pub fn researchstudy_create(
  resource: r4us.Researchstudy,
  client: FhirClient,
  handle_response: fn(Result(r4us.Researchstudy, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.researchstudy_to_json(resource),
    "ResearchStudy",
    r4us.researchstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn researchstudy_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Researchstudy, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ResearchStudy",
    r4us.researchstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn researchstudy_update(
  resource: r4us.Researchstudy,
  client: FhirClient,
  handle_response: fn(Result(r4us.Researchstudy, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.researchstudy_to_json(resource),
    "ResearchStudy",
    r4us.researchstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn researchstudy_delete(
  resource: r4us.Researchstudy,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ResearchStudy", client, handle_response)
}

pub fn researchstudy_search_bundled(
  search_for search_args: r4us_sansio.SpResearchstudy,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.researchstudy_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn researchstudy_search(
  search_for search_args: r4us_sansio.SpResearchstudy,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Researchstudy), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.researchstudy_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.researchstudy
    },
  )
}

pub fn researchsubject_create(
  resource: r4us.Researchsubject,
  client: FhirClient,
  handle_response: fn(Result(r4us.Researchsubject, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.researchsubject_to_json(resource),
    "ResearchSubject",
    r4us.researchsubject_decoder(),
    client,
    handle_response,
  )
}

pub fn researchsubject_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Researchsubject, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ResearchSubject",
    r4us.researchsubject_decoder(),
    client,
    handle_response,
  )
}

pub fn researchsubject_update(
  resource: r4us.Researchsubject,
  client: FhirClient,
  handle_response: fn(Result(r4us.Researchsubject, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.researchsubject_to_json(resource),
    "ResearchSubject",
    r4us.researchsubject_decoder(),
    client,
    handle_response,
  )
}

pub fn researchsubject_delete(
  resource: r4us.Researchsubject,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ResearchSubject", client, handle_response)
}

pub fn researchsubject_search_bundled(
  search_for search_args: r4us_sansio.SpResearchsubject,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.researchsubject_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn researchsubject_search(
  search_for search_args: r4us_sansio.SpResearchsubject,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Researchsubject), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.researchsubject_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.researchsubject
    },
  )
}

pub fn riskassessment_create(
  resource: r4us.Riskassessment,
  client: FhirClient,
  handle_response: fn(Result(r4us.Riskassessment, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.riskassessment_to_json(resource),
    "RiskAssessment",
    r4us.riskassessment_decoder(),
    client,
    handle_response,
  )
}

pub fn riskassessment_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Riskassessment, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "RiskAssessment",
    r4us.riskassessment_decoder(),
    client,
    handle_response,
  )
}

pub fn riskassessment_update(
  resource: r4us.Riskassessment,
  client: FhirClient,
  handle_response: fn(Result(r4us.Riskassessment, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.riskassessment_to_json(resource),
    "RiskAssessment",
    r4us.riskassessment_decoder(),
    client,
    handle_response,
  )
}

pub fn riskassessment_delete(
  resource: r4us.Riskassessment,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "RiskAssessment", client, handle_response)
}

pub fn riskassessment_search_bundled(
  search_for search_args: r4us_sansio.SpRiskassessment,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.riskassessment_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn riskassessment_search(
  search_for search_args: r4us_sansio.SpRiskassessment,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Riskassessment), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.riskassessment_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.riskassessment
    },
  )
}

pub fn riskevidencesynthesis_create(
  resource: r4us.Riskevidencesynthesis,
  client: FhirClient,
  handle_response: fn(Result(r4us.Riskevidencesynthesis, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.riskevidencesynthesis_to_json(resource),
    "RiskEvidenceSynthesis",
    r4us.riskevidencesynthesis_decoder(),
    client,
    handle_response,
  )
}

pub fn riskevidencesynthesis_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Riskevidencesynthesis, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "RiskEvidenceSynthesis",
    r4us.riskevidencesynthesis_decoder(),
    client,
    handle_response,
  )
}

pub fn riskevidencesynthesis_update(
  resource: r4us.Riskevidencesynthesis,
  client: FhirClient,
  handle_response: fn(Result(r4us.Riskevidencesynthesis, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.riskevidencesynthesis_to_json(resource),
    "RiskEvidenceSynthesis",
    r4us.riskevidencesynthesis_decoder(),
    client,
    handle_response,
  )
}

pub fn riskevidencesynthesis_delete(
  resource: r4us.Riskevidencesynthesis,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "RiskEvidenceSynthesis", client, handle_response)
}

pub fn riskevidencesynthesis_search_bundled(
  search_for search_args: r4us_sansio.SpRiskevidencesynthesis,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.riskevidencesynthesis_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn riskevidencesynthesis_search(
  search_for search_args: r4us_sansio.SpRiskevidencesynthesis,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.Riskevidencesynthesis), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.riskevidencesynthesis_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.riskevidencesynthesis
    },
  )
}

pub fn schedule_create(
  resource: r4us.Schedule,
  client: FhirClient,
  handle_response: fn(Result(r4us.Schedule, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.schedule_to_json(resource),
    "Schedule",
    r4us.schedule_decoder(),
    client,
    handle_response,
  )
}

pub fn schedule_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Schedule, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Schedule", r4us.schedule_decoder(), client, handle_response)
}

pub fn schedule_update(
  resource: r4us.Schedule,
  client: FhirClient,
  handle_response: fn(Result(r4us.Schedule, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.schedule_to_json(resource),
    "Schedule",
    r4us.schedule_decoder(),
    client,
    handle_response,
  )
}

pub fn schedule_delete(
  resource: r4us.Schedule,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Schedule", client, handle_response)
}

pub fn schedule_search_bundled(
  search_for search_args: r4us_sansio.SpSchedule,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.schedule_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn schedule_search(
  search_for search_args: r4us_sansio.SpSchedule,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Schedule), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.schedule_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4us_sansio.bundle_to_groupedresources }.schedule },
  )
}

pub fn searchparameter_create(
  resource: r4us.Searchparameter,
  client: FhirClient,
  handle_response: fn(Result(r4us.Searchparameter, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.searchparameter_to_json(resource),
    "SearchParameter",
    r4us.searchparameter_decoder(),
    client,
    handle_response,
  )
}

pub fn searchparameter_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Searchparameter, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SearchParameter",
    r4us.searchparameter_decoder(),
    client,
    handle_response,
  )
}

pub fn searchparameter_update(
  resource: r4us.Searchparameter,
  client: FhirClient,
  handle_response: fn(Result(r4us.Searchparameter, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.searchparameter_to_json(resource),
    "SearchParameter",
    r4us.searchparameter_decoder(),
    client,
    handle_response,
  )
}

pub fn searchparameter_delete(
  resource: r4us.Searchparameter,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SearchParameter", client, handle_response)
}

pub fn searchparameter_search_bundled(
  search_for search_args: r4us_sansio.SpSearchparameter,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.searchparameter_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn searchparameter_search(
  search_for search_args: r4us_sansio.SpSearchparameter,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Searchparameter), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.searchparameter_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.searchparameter
    },
  )
}

pub fn us_core_servicerequest_create(
  resource: r4us.UsCoreServicerequest,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreServicerequest, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_servicerequest_to_json(resource),
    "ServiceRequest",
    r4us.us_core_servicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_servicerequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreServicerequest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ServiceRequest",
    r4us.us_core_servicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_servicerequest_update(
  resource: r4us.UsCoreServicerequest,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreServicerequest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_servicerequest_to_json(resource),
    "ServiceRequest",
    r4us.us_core_servicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_servicerequest_delete(
  resource: r4us.UsCoreServicerequest,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ServiceRequest", client, handle_response)
}

pub fn us_core_servicerequest_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreServicerequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_servicerequest_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_servicerequest_search(
  search_for search_args: r4us_sansio.SpUsCoreServicerequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.UsCoreServicerequest), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_servicerequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_servicerequest
    },
  )
}

pub fn slot_create(
  resource: r4us.Slot,
  client: FhirClient,
  handle_response: fn(Result(r4us.Slot, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.slot_to_json(resource),
    "Slot",
    r4us.slot_decoder(),
    client,
    handle_response,
  )
}

pub fn slot_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Slot, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Slot", r4us.slot_decoder(), client, handle_response)
}

pub fn slot_update(
  resource: r4us.Slot,
  client: FhirClient,
  handle_response: fn(Result(r4us.Slot, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.slot_to_json(resource),
    "Slot",
    r4us.slot_decoder(),
    client,
    handle_response,
  )
}

pub fn slot_delete(
  resource: r4us.Slot,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Slot", client, handle_response)
}

pub fn slot_search_bundled(
  search_for search_args: r4us_sansio.SpSlot,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.slot_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn slot_search(
  search_for search_args: r4us_sansio.SpSlot,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Slot), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.slot_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4us_sansio.bundle_to_groupedresources }.slot },
  )
}

pub fn us_core_specimen_create(
  resource: r4us.UsCoreSpecimen,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreSpecimen, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.us_core_specimen_to_json(resource),
    "Specimen",
    r4us.us_core_specimen_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_specimen_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreSpecimen, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Specimen",
    r4us.us_core_specimen_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_specimen_update(
  resource: r4us.UsCoreSpecimen,
  client: FhirClient,
  handle_response: fn(Result(r4us.UsCoreSpecimen, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.us_core_specimen_to_json(resource),
    "Specimen",
    r4us.us_core_specimen_decoder(),
    client,
    handle_response,
  )
}

pub fn us_core_specimen_delete(
  resource: r4us.UsCoreSpecimen,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Specimen", client, handle_response)
}

pub fn us_core_specimen_search_bundled(
  search_for search_args: r4us_sansio.SpUsCoreSpecimen,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_specimen_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn us_core_specimen_search(
  search_for search_args: r4us_sansio.SpUsCoreSpecimen,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.UsCoreSpecimen), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.us_core_specimen_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_specimen
    },
  )
}

pub fn specimendefinition_create(
  resource: r4us.Specimendefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Specimendefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.specimendefinition_to_json(resource),
    "SpecimenDefinition",
    r4us.specimendefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn specimendefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Specimendefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SpecimenDefinition",
    r4us.specimendefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn specimendefinition_update(
  resource: r4us.Specimendefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Specimendefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.specimendefinition_to_json(resource),
    "SpecimenDefinition",
    r4us.specimendefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn specimendefinition_delete(
  resource: r4us.Specimendefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SpecimenDefinition", client, handle_response)
}

pub fn specimendefinition_search_bundled(
  search_for search_args: r4us_sansio.SpSpecimendefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.specimendefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn specimendefinition_search(
  search_for search_args: r4us_sansio.SpSpecimendefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Specimendefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.specimendefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.specimendefinition
    },
  )
}

pub fn structuredefinition_create(
  resource: r4us.Structuredefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Structuredefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.structuredefinition_to_json(resource),
    "StructureDefinition",
    r4us.structuredefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn structuredefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Structuredefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "StructureDefinition",
    r4us.structuredefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn structuredefinition_update(
  resource: r4us.Structuredefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Structuredefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.structuredefinition_to_json(resource),
    "StructureDefinition",
    r4us.structuredefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn structuredefinition_delete(
  resource: r4us.Structuredefinition,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "StructureDefinition", client, handle_response)
}

pub fn structuredefinition_search_bundled(
  search_for search_args: r4us_sansio.SpStructuredefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.structuredefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn structuredefinition_search(
  search_for search_args: r4us_sansio.SpStructuredefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Structuredefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.structuredefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.structuredefinition
    },
  )
}

pub fn structuremap_create(
  resource: r4us.Structuremap,
  client: FhirClient,
  handle_response: fn(Result(r4us.Structuremap, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.structuremap_to_json(resource),
    "StructureMap",
    r4us.structuremap_decoder(),
    client,
    handle_response,
  )
}

pub fn structuremap_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Structuremap, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "StructureMap",
    r4us.structuremap_decoder(),
    client,
    handle_response,
  )
}

pub fn structuremap_update(
  resource: r4us.Structuremap,
  client: FhirClient,
  handle_response: fn(Result(r4us.Structuremap, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.structuremap_to_json(resource),
    "StructureMap",
    r4us.structuremap_decoder(),
    client,
    handle_response,
  )
}

pub fn structuremap_delete(
  resource: r4us.Structuremap,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "StructureMap", client, handle_response)
}

pub fn structuremap_search_bundled(
  search_for search_args: r4us_sansio.SpStructuremap,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.structuremap_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn structuremap_search(
  search_for search_args: r4us_sansio.SpStructuremap,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Structuremap), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.structuremap_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.structuremap
    },
  )
}

pub fn subscription_create(
  resource: r4us.Subscription,
  client: FhirClient,
  handle_response: fn(Result(r4us.Subscription, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.subscription_to_json(resource),
    "Subscription",
    r4us.subscription_decoder(),
    client,
    handle_response,
  )
}

pub fn subscription_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Subscription, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Subscription",
    r4us.subscription_decoder(),
    client,
    handle_response,
  )
}

pub fn subscription_update(
  resource: r4us.Subscription,
  client: FhirClient,
  handle_response: fn(Result(r4us.Subscription, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.subscription_to_json(resource),
    "Subscription",
    r4us.subscription_decoder(),
    client,
    handle_response,
  )
}

pub fn subscription_delete(
  resource: r4us.Subscription,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Subscription", client, handle_response)
}

pub fn subscription_search_bundled(
  search_for search_args: r4us_sansio.SpSubscription,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.subscription_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn subscription_search(
  search_for search_args: r4us_sansio.SpSubscription,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Subscription), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.subscription_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.subscription
    },
  )
}

pub fn substance_create(
  resource: r4us.Substance,
  client: FhirClient,
  handle_response: fn(Result(r4us.Substance, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.substance_to_json(resource),
    "Substance",
    r4us.substance_decoder(),
    client,
    handle_response,
  )
}

pub fn substance_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Substance, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Substance", r4us.substance_decoder(), client, handle_response)
}

pub fn substance_update(
  resource: r4us.Substance,
  client: FhirClient,
  handle_response: fn(Result(r4us.Substance, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.substance_to_json(resource),
    "Substance",
    r4us.substance_decoder(),
    client,
    handle_response,
  )
}

pub fn substance_delete(
  resource: r4us.Substance,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Substance", client, handle_response)
}

pub fn substance_search_bundled(
  search_for search_args: r4us_sansio.SpSubstance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.substance_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn substance_search(
  search_for search_args: r4us_sansio.SpSubstance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Substance), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.substance_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.substance
    },
  )
}

pub fn substancenucleicacid_create(
  resource: r4us.Substancenucleicacid,
  client: FhirClient,
  handle_response: fn(Result(r4us.Substancenucleicacid, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.substancenucleicacid_to_json(resource),
    "SubstanceNucleicAcid",
    r4us.substancenucleicacid_decoder(),
    client,
    handle_response,
  )
}

pub fn substancenucleicacid_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Substancenucleicacid, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstanceNucleicAcid",
    r4us.substancenucleicacid_decoder(),
    client,
    handle_response,
  )
}

pub fn substancenucleicacid_update(
  resource: r4us.Substancenucleicacid,
  client: FhirClient,
  handle_response: fn(Result(r4us.Substancenucleicacid, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.substancenucleicacid_to_json(resource),
    "SubstanceNucleicAcid",
    r4us.substancenucleicacid_decoder(),
    client,
    handle_response,
  )
}

pub fn substancenucleicacid_delete(
  resource: r4us.Substancenucleicacid,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SubstanceNucleicAcid", client, handle_response)
}

pub fn substancenucleicacid_search_bundled(
  search_for search_args: r4us_sansio.SpSubstancenucleicacid,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.substancenucleicacid_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn substancenucleicacid_search(
  search_for search_args: r4us_sansio.SpSubstancenucleicacid,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Substancenucleicacid), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.substancenucleicacid_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.substancenucleicacid
    },
  )
}

pub fn substancepolymer_create(
  resource: r4us.Substancepolymer,
  client: FhirClient,
  handle_response: fn(Result(r4us.Substancepolymer, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.substancepolymer_to_json(resource),
    "SubstancePolymer",
    r4us.substancepolymer_decoder(),
    client,
    handle_response,
  )
}

pub fn substancepolymer_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Substancepolymer, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstancePolymer",
    r4us.substancepolymer_decoder(),
    client,
    handle_response,
  )
}

pub fn substancepolymer_update(
  resource: r4us.Substancepolymer,
  client: FhirClient,
  handle_response: fn(Result(r4us.Substancepolymer, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.substancepolymer_to_json(resource),
    "SubstancePolymer",
    r4us.substancepolymer_decoder(),
    client,
    handle_response,
  )
}

pub fn substancepolymer_delete(
  resource: r4us.Substancepolymer,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SubstancePolymer", client, handle_response)
}

pub fn substancepolymer_search_bundled(
  search_for search_args: r4us_sansio.SpSubstancepolymer,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.substancepolymer_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn substancepolymer_search(
  search_for search_args: r4us_sansio.SpSubstancepolymer,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Substancepolymer), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.substancepolymer_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.substancepolymer
    },
  )
}

pub fn substanceprotein_create(
  resource: r4us.Substanceprotein,
  client: FhirClient,
  handle_response: fn(Result(r4us.Substanceprotein, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.substanceprotein_to_json(resource),
    "SubstanceProtein",
    r4us.substanceprotein_decoder(),
    client,
    handle_response,
  )
}

pub fn substanceprotein_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Substanceprotein, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstanceProtein",
    r4us.substanceprotein_decoder(),
    client,
    handle_response,
  )
}

pub fn substanceprotein_update(
  resource: r4us.Substanceprotein,
  client: FhirClient,
  handle_response: fn(Result(r4us.Substanceprotein, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.substanceprotein_to_json(resource),
    "SubstanceProtein",
    r4us.substanceprotein_decoder(),
    client,
    handle_response,
  )
}

pub fn substanceprotein_delete(
  resource: r4us.Substanceprotein,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SubstanceProtein", client, handle_response)
}

pub fn substanceprotein_search_bundled(
  search_for search_args: r4us_sansio.SpSubstanceprotein,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.substanceprotein_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn substanceprotein_search(
  search_for search_args: r4us_sansio.SpSubstanceprotein,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Substanceprotein), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.substanceprotein_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.substanceprotein
    },
  )
}

pub fn substancereferenceinformation_create(
  resource: r4us.Substancereferenceinformation,
  client: FhirClient,
  handle_response: fn(Result(r4us.Substancereferenceinformation, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.substancereferenceinformation_to_json(resource),
    "SubstanceReferenceInformation",
    r4us.substancereferenceinformation_decoder(),
    client,
    handle_response,
  )
}

pub fn substancereferenceinformation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Substancereferenceinformation, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstanceReferenceInformation",
    r4us.substancereferenceinformation_decoder(),
    client,
    handle_response,
  )
}

pub fn substancereferenceinformation_update(
  resource: r4us.Substancereferenceinformation,
  client: FhirClient,
  handle_response: fn(Result(r4us.Substancereferenceinformation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.substancereferenceinformation_to_json(resource),
    "SubstanceReferenceInformation",
    r4us.substancereferenceinformation_decoder(),
    client,
    handle_response,
  )
}

pub fn substancereferenceinformation_delete(
  resource: r4us.Substancereferenceinformation,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(
    resource.id,
    "SubstanceReferenceInformation",
    client,
    handle_response,
  )
}

pub fn substancereferenceinformation_search_bundled(
  search_for search_args: r4us_sansio.SpSubstancereferenceinformation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.substancereferenceinformation_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn substancereferenceinformation_search(
  search_for search_args: r4us_sansio.SpSubstancereferenceinformation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.Substancereferenceinformation), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4us_sansio.substancereferenceinformation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.substancereferenceinformation
    },
  )
}

pub fn substancesourcematerial_create(
  resource: r4us.Substancesourcematerial,
  client: FhirClient,
  handle_response: fn(Result(r4us.Substancesourcematerial, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.substancesourcematerial_to_json(resource),
    "SubstanceSourceMaterial",
    r4us.substancesourcematerial_decoder(),
    client,
    handle_response,
  )
}

pub fn substancesourcematerial_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Substancesourcematerial, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstanceSourceMaterial",
    r4us.substancesourcematerial_decoder(),
    client,
    handle_response,
  )
}

pub fn substancesourcematerial_update(
  resource: r4us.Substancesourcematerial,
  client: FhirClient,
  handle_response: fn(Result(r4us.Substancesourcematerial, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.substancesourcematerial_to_json(resource),
    "SubstanceSourceMaterial",
    r4us.substancesourcematerial_decoder(),
    client,
    handle_response,
  )
}

pub fn substancesourcematerial_delete(
  resource: r4us.Substancesourcematerial,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SubstanceSourceMaterial", client, handle_response)
}

pub fn substancesourcematerial_search_bundled(
  search_for search_args: r4us_sansio.SpSubstancesourcematerial,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.substancesourcematerial_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn substancesourcematerial_search(
  search_for search_args: r4us_sansio.SpSubstancesourcematerial,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.Substancesourcematerial), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.substancesourcematerial_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.substancesourcematerial
    },
  )
}

pub fn substancespecification_create(
  resource: r4us.Substancespecification,
  client: FhirClient,
  handle_response: fn(Result(r4us.Substancespecification, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.substancespecification_to_json(resource),
    "SubstanceSpecification",
    r4us.substancespecification_decoder(),
    client,
    handle_response,
  )
}

pub fn substancespecification_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Substancespecification, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstanceSpecification",
    r4us.substancespecification_decoder(),
    client,
    handle_response,
  )
}

pub fn substancespecification_update(
  resource: r4us.Substancespecification,
  client: FhirClient,
  handle_response: fn(Result(r4us.Substancespecification, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.substancespecification_to_json(resource),
    "SubstanceSpecification",
    r4us.substancespecification_decoder(),
    client,
    handle_response,
  )
}

pub fn substancespecification_delete(
  resource: r4us.Substancespecification,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SubstanceSpecification", client, handle_response)
}

pub fn substancespecification_search_bundled(
  search_for search_args: r4us_sansio.SpSubstancespecification,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.substancespecification_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn substancespecification_search(
  search_for search_args: r4us_sansio.SpSubstancespecification,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.Substancespecification), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.substancespecification_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.substancespecification
    },
  )
}

pub fn supplydelivery_create(
  resource: r4us.Supplydelivery,
  client: FhirClient,
  handle_response: fn(Result(r4us.Supplydelivery, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.supplydelivery_to_json(resource),
    "SupplyDelivery",
    r4us.supplydelivery_decoder(),
    client,
    handle_response,
  )
}

pub fn supplydelivery_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Supplydelivery, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SupplyDelivery",
    r4us.supplydelivery_decoder(),
    client,
    handle_response,
  )
}

pub fn supplydelivery_update(
  resource: r4us.Supplydelivery,
  client: FhirClient,
  handle_response: fn(Result(r4us.Supplydelivery, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.supplydelivery_to_json(resource),
    "SupplyDelivery",
    r4us.supplydelivery_decoder(),
    client,
    handle_response,
  )
}

pub fn supplydelivery_delete(
  resource: r4us.Supplydelivery,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SupplyDelivery", client, handle_response)
}

pub fn supplydelivery_search_bundled(
  search_for search_args: r4us_sansio.SpSupplydelivery,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.supplydelivery_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn supplydelivery_search(
  search_for search_args: r4us_sansio.SpSupplydelivery,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Supplydelivery), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.supplydelivery_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.supplydelivery
    },
  )
}

pub fn supplyrequest_create(
  resource: r4us.Supplyrequest,
  client: FhirClient,
  handle_response: fn(Result(r4us.Supplyrequest, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.supplyrequest_to_json(resource),
    "SupplyRequest",
    r4us.supplyrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn supplyrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Supplyrequest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SupplyRequest",
    r4us.supplyrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn supplyrequest_update(
  resource: r4us.Supplyrequest,
  client: FhirClient,
  handle_response: fn(Result(r4us.Supplyrequest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.supplyrequest_to_json(resource),
    "SupplyRequest",
    r4us.supplyrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn supplyrequest_delete(
  resource: r4us.Supplyrequest,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SupplyRequest", client, handle_response)
}

pub fn supplyrequest_search_bundled(
  search_for search_args: r4us_sansio.SpSupplyrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.supplyrequest_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn supplyrequest_search(
  search_for search_args: r4us_sansio.SpSupplyrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Supplyrequest), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.supplyrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.supplyrequest
    },
  )
}

pub fn task_create(
  resource: r4us.Task,
  client: FhirClient,
  handle_response: fn(Result(r4us.Task, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.task_to_json(resource),
    "Task",
    r4us.task_decoder(),
    client,
    handle_response,
  )
}

pub fn task_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Task, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Task", r4us.task_decoder(), client, handle_response)
}

pub fn task_update(
  resource: r4us.Task,
  client: FhirClient,
  handle_response: fn(Result(r4us.Task, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.task_to_json(resource),
    "Task",
    r4us.task_decoder(),
    client,
    handle_response,
  )
}

pub fn task_delete(
  resource: r4us.Task,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Task", client, handle_response)
}

pub fn task_search_bundled(
  search_for search_args: r4us_sansio.SpTask,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.task_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn task_search(
  search_for search_args: r4us_sansio.SpTask,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Task), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.task_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4us_sansio.bundle_to_groupedresources }.task },
  )
}

pub fn terminologycapabilities_create(
  resource: r4us.Terminologycapabilities,
  client: FhirClient,
  handle_response: fn(Result(r4us.Terminologycapabilities, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.terminologycapabilities_to_json(resource),
    "TerminologyCapabilities",
    r4us.terminologycapabilities_decoder(),
    client,
    handle_response,
  )
}

pub fn terminologycapabilities_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Terminologycapabilities, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "TerminologyCapabilities",
    r4us.terminologycapabilities_decoder(),
    client,
    handle_response,
  )
}

pub fn terminologycapabilities_update(
  resource: r4us.Terminologycapabilities,
  client: FhirClient,
  handle_response: fn(Result(r4us.Terminologycapabilities, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.terminologycapabilities_to_json(resource),
    "TerminologyCapabilities",
    r4us.terminologycapabilities_decoder(),
    client,
    handle_response,
  )
}

pub fn terminologycapabilities_delete(
  resource: r4us.Terminologycapabilities,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "TerminologyCapabilities", client, handle_response)
}

pub fn terminologycapabilities_search_bundled(
  search_for search_args: r4us_sansio.SpTerminologycapabilities,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.terminologycapabilities_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn terminologycapabilities_search(
  search_for search_args: r4us_sansio.SpTerminologycapabilities,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4us.Terminologycapabilities), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.terminologycapabilities_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.terminologycapabilities
    },
  )
}

pub fn testreport_create(
  resource: r4us.Testreport,
  client: FhirClient,
  handle_response: fn(Result(r4us.Testreport, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.testreport_to_json(resource),
    "TestReport",
    r4us.testreport_decoder(),
    client,
    handle_response,
  )
}

pub fn testreport_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Testreport, Err)) -> a,
) -> Effect(a) {
  any_read(id, "TestReport", r4us.testreport_decoder(), client, handle_response)
}

pub fn testreport_update(
  resource: r4us.Testreport,
  client: FhirClient,
  handle_response: fn(Result(r4us.Testreport, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.testreport_to_json(resource),
    "TestReport",
    r4us.testreport_decoder(),
    client,
    handle_response,
  )
}

pub fn testreport_delete(
  resource: r4us.Testreport,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "TestReport", client, handle_response)
}

pub fn testreport_search_bundled(
  search_for search_args: r4us_sansio.SpTestreport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.testreport_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn testreport_search(
  search_for search_args: r4us_sansio.SpTestreport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Testreport), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.testreport_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.testreport
    },
  )
}

pub fn testscript_create(
  resource: r4us.Testscript,
  client: FhirClient,
  handle_response: fn(Result(r4us.Testscript, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.testscript_to_json(resource),
    "TestScript",
    r4us.testscript_decoder(),
    client,
    handle_response,
  )
}

pub fn testscript_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Testscript, Err)) -> a,
) -> Effect(a) {
  any_read(id, "TestScript", r4us.testscript_decoder(), client, handle_response)
}

pub fn testscript_update(
  resource: r4us.Testscript,
  client: FhirClient,
  handle_response: fn(Result(r4us.Testscript, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.testscript_to_json(resource),
    "TestScript",
    r4us.testscript_decoder(),
    client,
    handle_response,
  )
}

pub fn testscript_delete(
  resource: r4us.Testscript,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "TestScript", client, handle_response)
}

pub fn testscript_search_bundled(
  search_for search_args: r4us_sansio.SpTestscript,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.testscript_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn testscript_search(
  search_for search_args: r4us_sansio.SpTestscript,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Testscript), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.testscript_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.testscript
    },
  )
}

pub fn valueset_create(
  resource: r4us.Valueset,
  client: FhirClient,
  handle_response: fn(Result(r4us.Valueset, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.valueset_to_json(resource),
    "ValueSet",
    r4us.valueset_decoder(),
    client,
    handle_response,
  )
}

pub fn valueset_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Valueset, Err)) -> a,
) -> Effect(a) {
  any_read(id, "ValueSet", r4us.valueset_decoder(), client, handle_response)
}

pub fn valueset_update(
  resource: r4us.Valueset,
  client: FhirClient,
  handle_response: fn(Result(r4us.Valueset, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.valueset_to_json(resource),
    "ValueSet",
    r4us.valueset_decoder(),
    client,
    handle_response,
  )
}

pub fn valueset_delete(
  resource: r4us.Valueset,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ValueSet", client, handle_response)
}

pub fn valueset_search_bundled(
  search_for search_args: r4us_sansio.SpValueset,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.valueset_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn valueset_search(
  search_for search_args: r4us_sansio.SpValueset,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Valueset), Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.valueset_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4us_sansio.bundle_to_groupedresources }.valueset },
  )
}

pub fn verificationresult_create(
  resource: r4us.Verificationresult,
  client: FhirClient,
  handle_response: fn(Result(r4us.Verificationresult, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.verificationresult_to_json(resource),
    "VerificationResult",
    r4us.verificationresult_decoder(),
    client,
    handle_response,
  )
}

pub fn verificationresult_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Verificationresult, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "VerificationResult",
    r4us.verificationresult_decoder(),
    client,
    handle_response,
  )
}

pub fn verificationresult_update(
  resource: r4us.Verificationresult,
  client: FhirClient,
  handle_response: fn(Result(r4us.Verificationresult, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.verificationresult_to_json(resource),
    "VerificationResult",
    r4us.verificationresult_decoder(),
    client,
    handle_response,
  )
}

pub fn verificationresult_delete(
  resource: r4us.Verificationresult,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "VerificationResult", client, handle_response)
}

pub fn verificationresult_search_bundled(
  search_for search_args: r4us_sansio.SpVerificationresult,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.verificationresult_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn verificationresult_search(
  search_for search_args: r4us_sansio.SpVerificationresult,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Verificationresult), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.verificationresult_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.verificationresult
    },
  )
}

pub fn visionprescription_create(
  resource: r4us.Visionprescription,
  client: FhirClient,
  handle_response: fn(Result(r4us.Visionprescription, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4us.visionprescription_to_json(resource),
    "VisionPrescription",
    r4us.visionprescription_decoder(),
    client,
    handle_response,
  )
}

pub fn visionprescription_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4us.Visionprescription, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "VisionPrescription",
    r4us.visionprescription_decoder(),
    client,
    handle_response,
  )
}

pub fn visionprescription_update(
  resource: r4us.Visionprescription,
  client: FhirClient,
  handle_response: fn(Result(r4us.Visionprescription, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4us.visionprescription_to_json(resource),
    "VisionPrescription",
    r4us.visionprescription_decoder(),
    client,
    handle_response,
  )
}

pub fn visionprescription_delete(
  resource: r4us.Visionprescription,
  client: FhirClient,
  handle_response: fn(Result(r4us.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "VisionPrescription", client, handle_response)
}

pub fn visionprescription_search_bundled(
  search_for search_args: r4us_sansio.SpVisionprescription,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4us.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4us_sansio.visionprescription_search_req(search_args, client)
  sendreq_handleresponse(req, r4us.bundle_decoder(), handle_response)
}

pub fn visionprescription_search(
  search_for search_args: r4us_sansio.SpVisionprescription,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4us.Visionprescription), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4us_sansio.visionprescription_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4us.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4us_sansio.bundle_to_groupedresources }.visionprescription
    },
  )
}
