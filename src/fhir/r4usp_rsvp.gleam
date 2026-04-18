////[https://hl7.org/fhir/r4usp](https://hl7.org/fhir/r4usp) r4usp client using rsvp

import fhir/r4usp
import fhir/r4usp_sansio
import gleam/dynamic/decode.{type Decoder}
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/json.{type Json}
import gleam/option.{type Option, None, Some}
import lustre/effect.{type Effect}
import rsvp

/// FHIR client for sending http requests to server such as
/// `let read_pat_effect = r4usp_rsvp.patient_read("123", client, msg)`
///
/// create client from server base url with fhirclient_new(baseurl)`
///
/// `let assert Ok(client) = r4usp_rsvp.fhirclient_new("r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = r4usp_rsvp.fhirclient_new("https://r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = r4usp_rsvp.fhirclient_new("https://hapi.fhir.org/baseR4")`
///
/// `let assert Ok(client) = r4usp_rsvp.fhirclient_new("127.0.0.1:8000")`
pub type FhirClient =
  r4usp_sansio.FhirClient

/// creates a new client from server base url
///
/// `let assert Ok(client) = r4usp_rsvp.fhirclient_new("r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = r4usp_rsvp.fhirclient_new("https://r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = r4usp_rsvp.fhirclient_new("https://hapi.fhir.org/baseR4")`
///
/// `let assert Ok(client) = r4usp_rsvp.fhirclient_new("127.0.0.1:8000")`
pub fn fhirclient_new(
  baseurl: String,
) -> Result(FhirClient, r4usp_sansio.ErrBaseUrl) {
  r4usp_sansio.fhirclient_new(baseurl)
}

pub type Err {
  ErrRsvp(err: rsvp.Error)
  ErrSansio(err: r4usp_sansio.ErrResp)
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
  let req = r4usp_sansio.any_create_req(resource, res_type, client)
  sendreq_handleresponse(req, resource_dec, res_type, handle_response)
}

fn any_read(
  id: String,
  res_type: String,
  resource_dec: Decoder(r),
  client: FhirClient,
  handle_response: fn(Result(r, Err)) -> a,
) -> Effect(a) {
  let req = r4usp_sansio.any_read_req(id, res_type, client)
  sendreq_handleresponse(req, resource_dec, res_type, handle_response)
}

fn any_update(
  id: Option(String),
  resource: Json,
  res_type: String,
  resource_dec: Decoder(r),
  client: FhirClient,
  handle_response: fn(Result(r, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  let req = r4usp_sansio.any_update_req(id, resource, res_type, client)
  case req {
    Ok(req) ->
      Ok(sendreq_handleresponse(req, resource_dec, res_type, handle_response))
    // from rsvp's point of view it would make more sense to split sansio error into 2 separate errors
    // since user creates request and gets effect or error, then sends and gets response or error
    // ie you know first error must be creating error, and second must be http or parsing error
    // that said, currently you can only get error creating request from calling update/delete on resource with no id
    // so maybe it's easy to ignore all of this
    Error(_) -> Error(ErrNoId)
  }
}

fn any_delete(
  id: String,
  res_type: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Effect(a) {
  let req = r4usp_sansio.any_delete_req(id, res_type, client)
  let handle_read = fn(resp_res: Result(Response(String), rsvp.Error)) {
    handle_response(case resp_res {
      Error(err) -> Error(ErrRsvp(err))
      Ok(resp) ->
        case r4usp_sansio.http_or_operationoutcome_resp(resp) {
          Ok(oo_or_http) -> Ok(oo_or_http)
          Error(err) -> Error(ErrSansio(err))
        }
    })
  }
  let handler = rsvp.expect_any_response(handle_read)
  req
  |> request.set_body(case req.body {
    None -> ""
    Some(body) -> json.to_string(body)
  })
  |> rsvp.send(handler)
}

/// write out search string manually, in case typed search params don't work
pub fn search_any(
  search_string: String,
  res_type: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.any_search_req(search_string, res_type, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

// run any operation string on any resource string, optionally using Parameters
pub fn operation_any(
  params params: Option(r4usp.Parameters),
  operation_name operation_name: String,
  res_type res_type: String,
  res_id res_id: Option(String),
  res_decoder res_decoder: Decoder(res),
  client client: FhirClient,
  handle_response handle_response: fn(Result(res, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.any_operation_req(
      res_type,
      res_id,
      operation_name,
      params,
      client,
    )
  sendreq_handleresponse(req, res_decoder, "Bundle", handle_response)
}

pub fn batch(
  reqs: List(Request(Option(Json))),
  bundle_type: r4usp_sansio.PostBundleType,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.batch_req(reqs, bundle_type, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

fn sendreq_handleresponse(
  req: Request(Option(Json)),
  res_dec: Decoder(r),
  res_type: String,
  handle_response: fn(Result(r, Err)) -> a,
) -> Effect(a) {
  sendreq_handleresponse_andprocess(
    req,
    res_dec,
    res_type,
    handle_response,
    fn(a) { a },
  )
}

fn sendreq_handleresponse_andprocess(
  req: Request(Option(Json)),
  res_dec: Decoder(r),
  res_type: String,
  handle_response: fn(Result(b, Err)) -> a,
  process_res: fn(r) -> b,
) -> Effect(a) {
  let handle_read = fn(resp_res: Result(Response(String), rsvp.Error)) {
    handle_response(case resp_res {
      Error(err) -> Error(ErrRsvp(err))
      Ok(resp_res) -> {
        case r4usp_sansio.any_resp(resp_res, res_dec, res_type) {
          Ok(res) -> Ok(process_res(res))
          Error(err) -> Error(ErrSansio(err))
        }
      }
    })
  }
  let handler = rsvp.expect_any_response(handle_read)
  req
  |> request.set_body(case req.body {
    None -> ""
    Some(body) -> json.to_string(body)
  })
  |> rsvp.send(handler)
}

pub fn account_create(
  resource: r4usp.Account,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Account, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.account_to_json(resource),
    "Account",
    r4usp.account_decoder(),
    client,
    handle_response,
  )
}

pub fn account_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Account, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Account", r4usp.account_decoder(), client, handle_response)
}

pub fn account_update(
  resource: r4usp.Account,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Account, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.account_to_json(resource),
    "Account",
    r4usp.account_decoder(),
    client,
    handle_response,
  )
}

pub fn account_delete(
  resource: r4usp.Account,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Account", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn account_search_bundled(
  search_for search_args: r4usp_sansio.SpAccount,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.account_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn account_search(
  search_for search_args: r4usp_sansio.SpAccount,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Account), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.account_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> r4usp_sansio.bundle_to_groupedresources }.account },
  )
}

pub fn activitydefinition_create(
  resource: r4usp.Activitydefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Activitydefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.activitydefinition_to_json(resource),
    "ActivityDefinition",
    r4usp.activitydefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn activitydefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Activitydefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ActivityDefinition",
    r4usp.activitydefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn activitydefinition_update(
  resource: r4usp.Activitydefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Activitydefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.activitydefinition_to_json(resource),
    "ActivityDefinition",
    r4usp.activitydefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn activitydefinition_delete(
  resource: r4usp.Activitydefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "ActivityDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn activitydefinition_search_bundled(
  search_for search_args: r4usp_sansio.SpActivitydefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.activitydefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn activitydefinition_search(
  search_for search_args: r4usp_sansio.SpActivitydefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Activitydefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.activitydefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.activitydefinition
    },
  )
}

pub fn adverseevent_create(
  resource: r4usp.Adverseevent,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Adverseevent, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.adverseevent_to_json(resource),
    "AdverseEvent",
    r4usp.adverseevent_decoder(),
    client,
    handle_response,
  )
}

pub fn adverseevent_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Adverseevent, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "AdverseEvent",
    r4usp.adverseevent_decoder(),
    client,
    handle_response,
  )
}

pub fn adverseevent_update(
  resource: r4usp.Adverseevent,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Adverseevent, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.adverseevent_to_json(resource),
    "AdverseEvent",
    r4usp.adverseevent_decoder(),
    client,
    handle_response,
  )
}

pub fn adverseevent_delete(
  resource: r4usp.Adverseevent,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "AdverseEvent", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn adverseevent_search_bundled(
  search_for search_args: r4usp_sansio.SpAdverseevent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.adverseevent_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn adverseevent_search(
  search_for search_args: r4usp_sansio.SpAdverseevent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Adverseevent), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.adverseevent_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.adverseevent
    },
  )
}

pub fn allergyintolerance_create(
  resource: r4usp.Allergyintolerance,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Allergyintolerance, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    r4usp.allergyintolerance_decoder(),
    client,
    handle_response,
  )
}

pub fn allergyintolerance_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Allergyintolerance, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "AllergyIntolerance",
    r4usp.allergyintolerance_decoder(),
    client,
    handle_response,
  )
}

pub fn allergyintolerance_update(
  resource: r4usp.Allergyintolerance,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Allergyintolerance, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    r4usp.allergyintolerance_decoder(),
    client,
    handle_response,
  )
}

pub fn allergyintolerance_delete(
  resource: r4usp.Allergyintolerance,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "AllergyIntolerance", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn allergyintolerance_search_bundled(
  search_for search_args: r4usp_sansio.SpAllergyintolerance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.allergyintolerance_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn allergyintolerance_search(
  search_for search_args: r4usp_sansio.SpAllergyintolerance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Allergyintolerance), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.allergyintolerance_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.allergyintolerance
    },
  )
}

pub fn appointment_create(
  resource: r4usp.Appointment,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Appointment, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.appointment_to_json(resource),
    "Appointment",
    r4usp.appointment_decoder(),
    client,
    handle_response,
  )
}

pub fn appointment_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Appointment, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Appointment",
    r4usp.appointment_decoder(),
    client,
    handle_response,
  )
}

pub fn appointment_update(
  resource: r4usp.Appointment,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Appointment, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.appointment_to_json(resource),
    "Appointment",
    r4usp.appointment_decoder(),
    client,
    handle_response,
  )
}

pub fn appointment_delete(
  resource: r4usp.Appointment,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Appointment", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn appointment_search_bundled(
  search_for search_args: r4usp_sansio.SpAppointment,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.appointment_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn appointment_search(
  search_for search_args: r4usp_sansio.SpAppointment,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Appointment), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.appointment_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.appointment
    },
  )
}

pub fn appointmentresponse_create(
  resource: r4usp.Appointmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Appointmentresponse, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.appointmentresponse_to_json(resource),
    "AppointmentResponse",
    r4usp.appointmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn appointmentresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Appointmentresponse, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "AppointmentResponse",
    r4usp.appointmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn appointmentresponse_update(
  resource: r4usp.Appointmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Appointmentresponse, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.appointmentresponse_to_json(resource),
    "AppointmentResponse",
    r4usp.appointmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn appointmentresponse_delete(
  resource: r4usp.Appointmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "AppointmentResponse", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn appointmentresponse_search_bundled(
  search_for search_args: r4usp_sansio.SpAppointmentresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.appointmentresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn appointmentresponse_search(
  search_for search_args: r4usp_sansio.SpAppointmentresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Appointmentresponse), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.appointmentresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.appointmentresponse
    },
  )
}

pub fn auditevent_create(
  resource: r4usp.Auditevent,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Auditevent, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.auditevent_to_json(resource),
    "AuditEvent",
    r4usp.auditevent_decoder(),
    client,
    handle_response,
  )
}

pub fn auditevent_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Auditevent, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "AuditEvent",
    r4usp.auditevent_decoder(),
    client,
    handle_response,
  )
}

pub fn auditevent_update(
  resource: r4usp.Auditevent,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Auditevent, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.auditevent_to_json(resource),
    "AuditEvent",
    r4usp.auditevent_decoder(),
    client,
    handle_response,
  )
}

pub fn auditevent_delete(
  resource: r4usp.Auditevent,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "AuditEvent", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn auditevent_search_bundled(
  search_for search_args: r4usp_sansio.SpAuditevent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.auditevent_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn auditevent_search(
  search_for search_args: r4usp_sansio.SpAuditevent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Auditevent), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.auditevent_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.auditevent
    },
  )
}

pub fn basic_create(
  resource: r4usp.Basic,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Basic, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.basic_to_json(resource),
    "Basic",
    r4usp.basic_decoder(),
    client,
    handle_response,
  )
}

pub fn basic_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Basic, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Basic", r4usp.basic_decoder(), client, handle_response)
}

pub fn basic_update(
  resource: r4usp.Basic,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Basic, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.basic_to_json(resource),
    "Basic",
    r4usp.basic_decoder(),
    client,
    handle_response,
  )
}

pub fn basic_delete(
  resource: r4usp.Basic,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Basic", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn basic_search_bundled(
  search_for search_args: r4usp_sansio.SpBasic,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.basic_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn basic_search(
  search_for search_args: r4usp_sansio.SpBasic,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Basic), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.basic_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> r4usp_sansio.bundle_to_groupedresources }.basic },
  )
}

pub fn binary_create(
  resource: r4usp.Binary,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Binary, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.binary_to_json(resource),
    "Binary",
    r4usp.binary_decoder(),
    client,
    handle_response,
  )
}

pub fn binary_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Binary, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Binary", r4usp.binary_decoder(), client, handle_response)
}

pub fn binary_update(
  resource: r4usp.Binary,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Binary, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.binary_to_json(resource),
    "Binary",
    r4usp.binary_decoder(),
    client,
    handle_response,
  )
}

pub fn binary_delete(
  resource: r4usp.Binary,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Binary", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn binary_search_bundled(
  search_for search_args: r4usp_sansio.SpBinary,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.binary_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn binary_search(
  search_for search_args: r4usp_sansio.SpBinary,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Binary), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.binary_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> r4usp_sansio.bundle_to_groupedresources }.binary },
  )
}

pub fn biologicallyderivedproduct_create(
  resource: r4usp.Biologicallyderivedproduct,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Biologicallyderivedproduct, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.biologicallyderivedproduct_to_json(resource),
    "BiologicallyDerivedProduct",
    r4usp.biologicallyderivedproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn biologicallyderivedproduct_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Biologicallyderivedproduct, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "BiologicallyDerivedProduct",
    r4usp.biologicallyderivedproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn biologicallyderivedproduct_update(
  resource: r4usp.Biologicallyderivedproduct,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Biologicallyderivedproduct, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.biologicallyderivedproduct_to_json(resource),
    "BiologicallyDerivedProduct",
    r4usp.biologicallyderivedproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn biologicallyderivedproduct_delete(
  resource: r4usp.Biologicallyderivedproduct,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "BiologicallyDerivedProduct", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn biologicallyderivedproduct_search_bundled(
  search_for search_args: r4usp_sansio.SpBiologicallyderivedproduct,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.biologicallyderivedproduct_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn biologicallyderivedproduct_search(
  search_for search_args: r4usp_sansio.SpBiologicallyderivedproduct,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Biologicallyderivedproduct), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.biologicallyderivedproduct_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.biologicallyderivedproduct
    },
  )
}

pub fn bodystructure_create(
  resource: r4usp.Bodystructure,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Bodystructure, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.bodystructure_to_json(resource),
    "BodyStructure",
    r4usp.bodystructure_decoder(),
    client,
    handle_response,
  )
}

pub fn bodystructure_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Bodystructure, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "BodyStructure",
    r4usp.bodystructure_decoder(),
    client,
    handle_response,
  )
}

pub fn bodystructure_update(
  resource: r4usp.Bodystructure,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Bodystructure, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.bodystructure_to_json(resource),
    "BodyStructure",
    r4usp.bodystructure_decoder(),
    client,
    handle_response,
  )
}

pub fn bodystructure_delete(
  resource: r4usp.Bodystructure,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "BodyStructure", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn bodystructure_search_bundled(
  search_for search_args: r4usp_sansio.SpBodystructure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.bodystructure_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn bodystructure_search(
  search_for search_args: r4usp_sansio.SpBodystructure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Bodystructure), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.bodystructure_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.bodystructure
    },
  )
}

pub fn bundle_create(
  resource: r4usp.Bundle,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Bundle, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.bundle_to_json(resource),
    "Bundle",
    r4usp.bundle_decoder(),
    client,
    handle_response,
  )
}

pub fn bundle_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Bundle, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Bundle", r4usp.bundle_decoder(), client, handle_response)
}

pub fn bundle_update(
  resource: r4usp.Bundle,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Bundle, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.bundle_to_json(resource),
    "Bundle",
    r4usp.bundle_decoder(),
    client,
    handle_response,
  )
}

pub fn bundle_delete(
  resource: r4usp.Bundle,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Bundle", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn bundle_search_bundled(
  search_for search_args: r4usp_sansio.SpBundle,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.bundle_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn bundle_search(
  search_for search_args: r4usp_sansio.SpBundle,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Bundle), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.bundle_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> r4usp_sansio.bundle_to_groupedresources }.bundle },
  )
}

pub fn capabilitystatement_create(
  resource: r4usp.Capabilitystatement,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Capabilitystatement, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.capabilitystatement_to_json(resource),
    "CapabilityStatement",
    r4usp.capabilitystatement_decoder(),
    client,
    handle_response,
  )
}

pub fn capabilitystatement_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Capabilitystatement, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CapabilityStatement",
    r4usp.capabilitystatement_decoder(),
    client,
    handle_response,
  )
}

pub fn capabilitystatement_update(
  resource: r4usp.Capabilitystatement,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Capabilitystatement, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.capabilitystatement_to_json(resource),
    "CapabilityStatement",
    r4usp.capabilitystatement_decoder(),
    client,
    handle_response,
  )
}

pub fn capabilitystatement_delete(
  resource: r4usp.Capabilitystatement,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "CapabilityStatement", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn capabilitystatement_search_bundled(
  search_for search_args: r4usp_sansio.SpCapabilitystatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.capabilitystatement_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn capabilitystatement_search(
  search_for search_args: r4usp_sansio.SpCapabilitystatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Capabilitystatement), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.capabilitystatement_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.capabilitystatement
    },
  )
}

pub fn careplan_create(
  resource: r4usp.Careplan,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Careplan, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.careplan_to_json(resource),
    "CarePlan",
    r4usp.careplan_decoder(),
    client,
    handle_response,
  )
}

pub fn careplan_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Careplan, Err)) -> a,
) -> Effect(a) {
  any_read(id, "CarePlan", r4usp.careplan_decoder(), client, handle_response)
}

pub fn careplan_update(
  resource: r4usp.Careplan,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Careplan, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.careplan_to_json(resource),
    "CarePlan",
    r4usp.careplan_decoder(),
    client,
    handle_response,
  )
}

pub fn careplan_delete(
  resource: r4usp.Careplan,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "CarePlan", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn careplan_search_bundled(
  search_for search_args: r4usp_sansio.SpCareplan,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.careplan_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn careplan_search(
  search_for search_args: r4usp_sansio.SpCareplan,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Careplan), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.careplan_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.careplan
    },
  )
}

pub fn careteam_create(
  resource: r4usp.Careteam,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Careteam, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.careteam_to_json(resource),
    "CareTeam",
    r4usp.careteam_decoder(),
    client,
    handle_response,
  )
}

pub fn careteam_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Careteam, Err)) -> a,
) -> Effect(a) {
  any_read(id, "CareTeam", r4usp.careteam_decoder(), client, handle_response)
}

pub fn careteam_update(
  resource: r4usp.Careteam,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Careteam, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.careteam_to_json(resource),
    "CareTeam",
    r4usp.careteam_decoder(),
    client,
    handle_response,
  )
}

pub fn careteam_delete(
  resource: r4usp.Careteam,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "CareTeam", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn careteam_search_bundled(
  search_for search_args: r4usp_sansio.SpCareteam,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.careteam_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn careteam_search(
  search_for search_args: r4usp_sansio.SpCareteam,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Careteam), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.careteam_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.careteam
    },
  )
}

pub fn catalogentry_create(
  resource: r4usp.Catalogentry,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Catalogentry, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.catalogentry_to_json(resource),
    "CatalogEntry",
    r4usp.catalogentry_decoder(),
    client,
    handle_response,
  )
}

pub fn catalogentry_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Catalogentry, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CatalogEntry",
    r4usp.catalogentry_decoder(),
    client,
    handle_response,
  )
}

pub fn catalogentry_update(
  resource: r4usp.Catalogentry,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Catalogentry, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.catalogentry_to_json(resource),
    "CatalogEntry",
    r4usp.catalogentry_decoder(),
    client,
    handle_response,
  )
}

pub fn catalogentry_delete(
  resource: r4usp.Catalogentry,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "CatalogEntry", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn catalogentry_search_bundled(
  search_for search_args: r4usp_sansio.SpCatalogentry,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.catalogentry_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn catalogentry_search(
  search_for search_args: r4usp_sansio.SpCatalogentry,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Catalogentry), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.catalogentry_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.catalogentry
    },
  )
}

pub fn chargeitem_create(
  resource: r4usp.Chargeitem,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Chargeitem, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.chargeitem_to_json(resource),
    "ChargeItem",
    r4usp.chargeitem_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitem_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Chargeitem, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ChargeItem",
    r4usp.chargeitem_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitem_update(
  resource: r4usp.Chargeitem,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Chargeitem, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.chargeitem_to_json(resource),
    "ChargeItem",
    r4usp.chargeitem_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitem_delete(
  resource: r4usp.Chargeitem,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "ChargeItem", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn chargeitem_search_bundled(
  search_for search_args: r4usp_sansio.SpChargeitem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.chargeitem_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn chargeitem_search(
  search_for search_args: r4usp_sansio.SpChargeitem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Chargeitem), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.chargeitem_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.chargeitem
    },
  )
}

pub fn chargeitemdefinition_create(
  resource: r4usp.Chargeitemdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Chargeitemdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.chargeitemdefinition_to_json(resource),
    "ChargeItemDefinition",
    r4usp.chargeitemdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitemdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Chargeitemdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ChargeItemDefinition",
    r4usp.chargeitemdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitemdefinition_update(
  resource: r4usp.Chargeitemdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Chargeitemdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.chargeitemdefinition_to_json(resource),
    "ChargeItemDefinition",
    r4usp.chargeitemdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitemdefinition_delete(
  resource: r4usp.Chargeitemdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "ChargeItemDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn chargeitemdefinition_search_bundled(
  search_for search_args: r4usp_sansio.SpChargeitemdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.chargeitemdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn chargeitemdefinition_search(
  search_for search_args: r4usp_sansio.SpChargeitemdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Chargeitemdefinition), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.chargeitemdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.chargeitemdefinition
    },
  )
}

pub fn claim_create(
  resource: r4usp.Claim,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Claim, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.claim_to_json(resource),
    "Claim",
    r4usp.claim_decoder(),
    client,
    handle_response,
  )
}

pub fn claim_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Claim, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Claim", r4usp.claim_decoder(), client, handle_response)
}

pub fn claim_update(
  resource: r4usp.Claim,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Claim, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.claim_to_json(resource),
    "Claim",
    r4usp.claim_decoder(),
    client,
    handle_response,
  )
}

pub fn claim_delete(
  resource: r4usp.Claim,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Claim", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn claim_search_bundled(
  search_for search_args: r4usp_sansio.SpClaim,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.claim_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn claim_search(
  search_for search_args: r4usp_sansio.SpClaim,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Claim), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.claim_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> r4usp_sansio.bundle_to_groupedresources }.claim },
  )
}

pub fn claimresponse_create(
  resource: r4usp.Claimresponse,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Claimresponse, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.claimresponse_to_json(resource),
    "ClaimResponse",
    r4usp.claimresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn claimresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Claimresponse, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ClaimResponse",
    r4usp.claimresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn claimresponse_update(
  resource: r4usp.Claimresponse,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Claimresponse, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.claimresponse_to_json(resource),
    "ClaimResponse",
    r4usp.claimresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn claimresponse_delete(
  resource: r4usp.Claimresponse,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "ClaimResponse", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn claimresponse_search_bundled(
  search_for search_args: r4usp_sansio.SpClaimresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.claimresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn claimresponse_search(
  search_for search_args: r4usp_sansio.SpClaimresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Claimresponse), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.claimresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.claimresponse
    },
  )
}

pub fn clinicalimpression_create(
  resource: r4usp.Clinicalimpression,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Clinicalimpression, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.clinicalimpression_to_json(resource),
    "ClinicalImpression",
    r4usp.clinicalimpression_decoder(),
    client,
    handle_response,
  )
}

pub fn clinicalimpression_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Clinicalimpression, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ClinicalImpression",
    r4usp.clinicalimpression_decoder(),
    client,
    handle_response,
  )
}

pub fn clinicalimpression_update(
  resource: r4usp.Clinicalimpression,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Clinicalimpression, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.clinicalimpression_to_json(resource),
    "ClinicalImpression",
    r4usp.clinicalimpression_decoder(),
    client,
    handle_response,
  )
}

pub fn clinicalimpression_delete(
  resource: r4usp.Clinicalimpression,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "ClinicalImpression", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn clinicalimpression_search_bundled(
  search_for search_args: r4usp_sansio.SpClinicalimpression,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.clinicalimpression_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn clinicalimpression_search(
  search_for search_args: r4usp_sansio.SpClinicalimpression,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Clinicalimpression), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.clinicalimpression_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.clinicalimpression
    },
  )
}

pub fn codesystem_create(
  resource: r4usp.Codesystem,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Codesystem, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.codesystem_to_json(resource),
    "CodeSystem",
    r4usp.codesystem_decoder(),
    client,
    handle_response,
  )
}

pub fn codesystem_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Codesystem, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CodeSystem",
    r4usp.codesystem_decoder(),
    client,
    handle_response,
  )
}

pub fn codesystem_update(
  resource: r4usp.Codesystem,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Codesystem, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.codesystem_to_json(resource),
    "CodeSystem",
    r4usp.codesystem_decoder(),
    client,
    handle_response,
  )
}

pub fn codesystem_delete(
  resource: r4usp.Codesystem,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "CodeSystem", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn codesystem_search_bundled(
  search_for search_args: r4usp_sansio.SpCodesystem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.codesystem_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn codesystem_search(
  search_for search_args: r4usp_sansio.SpCodesystem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Codesystem), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.codesystem_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.codesystem
    },
  )
}

pub fn communication_create(
  resource: r4usp.Communication,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Communication, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.communication_to_json(resource),
    "Communication",
    r4usp.communication_decoder(),
    client,
    handle_response,
  )
}

pub fn communication_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Communication, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Communication",
    r4usp.communication_decoder(),
    client,
    handle_response,
  )
}

pub fn communication_update(
  resource: r4usp.Communication,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Communication, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.communication_to_json(resource),
    "Communication",
    r4usp.communication_decoder(),
    client,
    handle_response,
  )
}

pub fn communication_delete(
  resource: r4usp.Communication,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Communication", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn communication_search_bundled(
  search_for search_args: r4usp_sansio.SpCommunication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.communication_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn communication_search(
  search_for search_args: r4usp_sansio.SpCommunication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Communication), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.communication_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.communication
    },
  )
}

pub fn communicationrequest_create(
  resource: r4usp.Communicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Communicationrequest, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.communicationrequest_to_json(resource),
    "CommunicationRequest",
    r4usp.communicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn communicationrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Communicationrequest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CommunicationRequest",
    r4usp.communicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn communicationrequest_update(
  resource: r4usp.Communicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Communicationrequest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.communicationrequest_to_json(resource),
    "CommunicationRequest",
    r4usp.communicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn communicationrequest_delete(
  resource: r4usp.Communicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "CommunicationRequest", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn communicationrequest_search_bundled(
  search_for search_args: r4usp_sansio.SpCommunicationrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.communicationrequest_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn communicationrequest_search(
  search_for search_args: r4usp_sansio.SpCommunicationrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Communicationrequest), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.communicationrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.communicationrequest
    },
  )
}

pub fn compartmentdefinition_create(
  resource: r4usp.Compartmentdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Compartmentdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.compartmentdefinition_to_json(resource),
    "CompartmentDefinition",
    r4usp.compartmentdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn compartmentdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Compartmentdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CompartmentDefinition",
    r4usp.compartmentdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn compartmentdefinition_update(
  resource: r4usp.Compartmentdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Compartmentdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.compartmentdefinition_to_json(resource),
    "CompartmentDefinition",
    r4usp.compartmentdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn compartmentdefinition_delete(
  resource: r4usp.Compartmentdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "CompartmentDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn compartmentdefinition_search_bundled(
  search_for search_args: r4usp_sansio.SpCompartmentdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.compartmentdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn compartmentdefinition_search(
  search_for search_args: r4usp_sansio.SpCompartmentdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Compartmentdefinition), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.compartmentdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.compartmentdefinition
    },
  )
}

pub fn composition_create(
  resource: r4usp.Composition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Composition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.composition_to_json(resource),
    "Composition",
    r4usp.composition_decoder(),
    client,
    handle_response,
  )
}

pub fn composition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Composition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Composition",
    r4usp.composition_decoder(),
    client,
    handle_response,
  )
}

pub fn composition_update(
  resource: r4usp.Composition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Composition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.composition_to_json(resource),
    "Composition",
    r4usp.composition_decoder(),
    client,
    handle_response,
  )
}

pub fn composition_delete(
  resource: r4usp.Composition,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Composition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn composition_search_bundled(
  search_for search_args: r4usp_sansio.SpComposition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.composition_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn composition_search(
  search_for search_args: r4usp_sansio.SpComposition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Composition), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.composition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.composition
    },
  )
}

pub fn conceptmap_create(
  resource: r4usp.Conceptmap,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Conceptmap, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.conceptmap_to_json(resource),
    "ConceptMap",
    r4usp.conceptmap_decoder(),
    client,
    handle_response,
  )
}

pub fn conceptmap_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Conceptmap, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ConceptMap",
    r4usp.conceptmap_decoder(),
    client,
    handle_response,
  )
}

pub fn conceptmap_update(
  resource: r4usp.Conceptmap,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Conceptmap, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.conceptmap_to_json(resource),
    "ConceptMap",
    r4usp.conceptmap_decoder(),
    client,
    handle_response,
  )
}

pub fn conceptmap_delete(
  resource: r4usp.Conceptmap,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "ConceptMap", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn conceptmap_search_bundled(
  search_for search_args: r4usp_sansio.SpConceptmap,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.conceptmap_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn conceptmap_search(
  search_for search_args: r4usp_sansio.SpConceptmap,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Conceptmap), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.conceptmap_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.conceptmap
    },
  )
}

pub fn condition_create(
  resource: r4usp.Condition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Condition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.condition_to_json(resource),
    "Condition",
    r4usp.condition_decoder(),
    client,
    handle_response,
  )
}

pub fn condition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Condition, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Condition", r4usp.condition_decoder(), client, handle_response)
}

pub fn condition_update(
  resource: r4usp.Condition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Condition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.condition_to_json(resource),
    "Condition",
    r4usp.condition_decoder(),
    client,
    handle_response,
  )
}

pub fn condition_delete(
  resource: r4usp.Condition,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Condition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn condition_search_bundled(
  search_for search_args: r4usp_sansio.SpCondition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.condition_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn condition_search(
  search_for search_args: r4usp_sansio.SpCondition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Condition), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.condition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.condition
    },
  )
}

pub fn consent_create(
  resource: r4usp.Consent,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Consent, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.consent_to_json(resource),
    "Consent",
    r4usp.consent_decoder(),
    client,
    handle_response,
  )
}

pub fn consent_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Consent, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Consent", r4usp.consent_decoder(), client, handle_response)
}

pub fn consent_update(
  resource: r4usp.Consent,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Consent, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.consent_to_json(resource),
    "Consent",
    r4usp.consent_decoder(),
    client,
    handle_response,
  )
}

pub fn consent_delete(
  resource: r4usp.Consent,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Consent", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn consent_search_bundled(
  search_for search_args: r4usp_sansio.SpConsent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.consent_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn consent_search(
  search_for search_args: r4usp_sansio.SpConsent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Consent), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.consent_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> r4usp_sansio.bundle_to_groupedresources }.consent },
  )
}

pub fn contract_create(
  resource: r4usp.Contract,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Contract, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.contract_to_json(resource),
    "Contract",
    r4usp.contract_decoder(),
    client,
    handle_response,
  )
}

pub fn contract_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Contract, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Contract", r4usp.contract_decoder(), client, handle_response)
}

pub fn contract_update(
  resource: r4usp.Contract,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Contract, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.contract_to_json(resource),
    "Contract",
    r4usp.contract_decoder(),
    client,
    handle_response,
  )
}

pub fn contract_delete(
  resource: r4usp.Contract,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Contract", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn contract_search_bundled(
  search_for search_args: r4usp_sansio.SpContract,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.contract_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn contract_search(
  search_for search_args: r4usp_sansio.SpContract,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Contract), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.contract_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.contract
    },
  )
}

pub fn coverage_create(
  resource: r4usp.Coverage,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Coverage, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.coverage_to_json(resource),
    "Coverage",
    r4usp.coverage_decoder(),
    client,
    handle_response,
  )
}

pub fn coverage_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Coverage, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Coverage", r4usp.coverage_decoder(), client, handle_response)
}

pub fn coverage_update(
  resource: r4usp.Coverage,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Coverage, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.coverage_to_json(resource),
    "Coverage",
    r4usp.coverage_decoder(),
    client,
    handle_response,
  )
}

pub fn coverage_delete(
  resource: r4usp.Coverage,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Coverage", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn coverage_search_bundled(
  search_for search_args: r4usp_sansio.SpCoverage,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.coverage_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn coverage_search(
  search_for search_args: r4usp_sansio.SpCoverage,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Coverage), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.coverage_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.coverage
    },
  )
}

pub fn coverageeligibilityrequest_create(
  resource: r4usp.Coverageeligibilityrequest,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Coverageeligibilityrequest, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.coverageeligibilityrequest_to_json(resource),
    "CoverageEligibilityRequest",
    r4usp.coverageeligibilityrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Coverageeligibilityrequest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CoverageEligibilityRequest",
    r4usp.coverageeligibilityrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityrequest_update(
  resource: r4usp.Coverageeligibilityrequest,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Coverageeligibilityrequest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.coverageeligibilityrequest_to_json(resource),
    "CoverageEligibilityRequest",
    r4usp.coverageeligibilityrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityrequest_delete(
  resource: r4usp.Coverageeligibilityrequest,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "CoverageEligibilityRequest", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn coverageeligibilityrequest_search_bundled(
  search_for search_args: r4usp_sansio.SpCoverageeligibilityrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.coverageeligibilityrequest_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn coverageeligibilityrequest_search(
  search_for search_args: r4usp_sansio.SpCoverageeligibilityrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Coverageeligibilityrequest), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.coverageeligibilityrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.coverageeligibilityrequest
    },
  )
}

pub fn coverageeligibilityresponse_create(
  resource: r4usp.Coverageeligibilityresponse,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Coverageeligibilityresponse, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.coverageeligibilityresponse_to_json(resource),
    "CoverageEligibilityResponse",
    r4usp.coverageeligibilityresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Coverageeligibilityresponse, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CoverageEligibilityResponse",
    r4usp.coverageeligibilityresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityresponse_update(
  resource: r4usp.Coverageeligibilityresponse,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Coverageeligibilityresponse, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.coverageeligibilityresponse_to_json(resource),
    "CoverageEligibilityResponse",
    r4usp.coverageeligibilityresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityresponse_delete(
  resource: r4usp.Coverageeligibilityresponse,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "CoverageEligibilityResponse", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn coverageeligibilityresponse_search_bundled(
  search_for search_args: r4usp_sansio.SpCoverageeligibilityresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.coverageeligibilityresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn coverageeligibilityresponse_search(
  search_for search_args: r4usp_sansio.SpCoverageeligibilityresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Coverageeligibilityresponse), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.coverageeligibilityresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.coverageeligibilityresponse
    },
  )
}

pub fn detectedissue_create(
  resource: r4usp.Detectedissue,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Detectedissue, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.detectedissue_to_json(resource),
    "DetectedIssue",
    r4usp.detectedissue_decoder(),
    client,
    handle_response,
  )
}

pub fn detectedissue_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Detectedissue, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DetectedIssue",
    r4usp.detectedissue_decoder(),
    client,
    handle_response,
  )
}

pub fn detectedissue_update(
  resource: r4usp.Detectedissue,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Detectedissue, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.detectedissue_to_json(resource),
    "DetectedIssue",
    r4usp.detectedissue_decoder(),
    client,
    handle_response,
  )
}

pub fn detectedissue_delete(
  resource: r4usp.Detectedissue,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "DetectedIssue", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn detectedissue_search_bundled(
  search_for search_args: r4usp_sansio.SpDetectedissue,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.detectedissue_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn detectedissue_search(
  search_for search_args: r4usp_sansio.SpDetectedissue,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Detectedissue), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.detectedissue_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.detectedissue
    },
  )
}

pub fn device_create(
  resource: r4usp.Device,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Device, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.device_to_json(resource),
    "Device",
    r4usp.device_decoder(),
    client,
    handle_response,
  )
}

pub fn device_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Device, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Device", r4usp.device_decoder(), client, handle_response)
}

pub fn device_update(
  resource: r4usp.Device,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Device, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.device_to_json(resource),
    "Device",
    r4usp.device_decoder(),
    client,
    handle_response,
  )
}

pub fn device_delete(
  resource: r4usp.Device,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Device", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn device_search_bundled(
  search_for search_args: r4usp_sansio.SpDevice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.device_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn device_search(
  search_for search_args: r4usp_sansio.SpDevice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Device), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.device_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> r4usp_sansio.bundle_to_groupedresources }.device },
  )
}

pub fn devicedefinition_create(
  resource: r4usp.Devicedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Devicedefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.devicedefinition_to_json(resource),
    "DeviceDefinition",
    r4usp.devicedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn devicedefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Devicedefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DeviceDefinition",
    r4usp.devicedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn devicedefinition_update(
  resource: r4usp.Devicedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Devicedefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.devicedefinition_to_json(resource),
    "DeviceDefinition",
    r4usp.devicedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn devicedefinition_delete(
  resource: r4usp.Devicedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "DeviceDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn devicedefinition_search_bundled(
  search_for search_args: r4usp_sansio.SpDevicedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.devicedefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn devicedefinition_search(
  search_for search_args: r4usp_sansio.SpDevicedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Devicedefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.devicedefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.devicedefinition
    },
  )
}

pub fn devicemetric_create(
  resource: r4usp.Devicemetric,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Devicemetric, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.devicemetric_to_json(resource),
    "DeviceMetric",
    r4usp.devicemetric_decoder(),
    client,
    handle_response,
  )
}

pub fn devicemetric_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Devicemetric, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DeviceMetric",
    r4usp.devicemetric_decoder(),
    client,
    handle_response,
  )
}

pub fn devicemetric_update(
  resource: r4usp.Devicemetric,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Devicemetric, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.devicemetric_to_json(resource),
    "DeviceMetric",
    r4usp.devicemetric_decoder(),
    client,
    handle_response,
  )
}

pub fn devicemetric_delete(
  resource: r4usp.Devicemetric,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "DeviceMetric", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn devicemetric_search_bundled(
  search_for search_args: r4usp_sansio.SpDevicemetric,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.devicemetric_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn devicemetric_search(
  search_for search_args: r4usp_sansio.SpDevicemetric,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Devicemetric), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.devicemetric_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.devicemetric
    },
  )
}

pub fn devicerequest_create(
  resource: r4usp.Devicerequest,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Devicerequest, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.devicerequest_to_json(resource),
    "DeviceRequest",
    r4usp.devicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn devicerequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Devicerequest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DeviceRequest",
    r4usp.devicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn devicerequest_update(
  resource: r4usp.Devicerequest,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Devicerequest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.devicerequest_to_json(resource),
    "DeviceRequest",
    r4usp.devicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn devicerequest_delete(
  resource: r4usp.Devicerequest,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "DeviceRequest", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn devicerequest_search_bundled(
  search_for search_args: r4usp_sansio.SpDevicerequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.devicerequest_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn devicerequest_search(
  search_for search_args: r4usp_sansio.SpDevicerequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Devicerequest), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.devicerequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.devicerequest
    },
  )
}

pub fn deviceusestatement_create(
  resource: r4usp.Deviceusestatement,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Deviceusestatement, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.deviceusestatement_to_json(resource),
    "DeviceUseStatement",
    r4usp.deviceusestatement_decoder(),
    client,
    handle_response,
  )
}

pub fn deviceusestatement_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Deviceusestatement, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DeviceUseStatement",
    r4usp.deviceusestatement_decoder(),
    client,
    handle_response,
  )
}

pub fn deviceusestatement_update(
  resource: r4usp.Deviceusestatement,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Deviceusestatement, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.deviceusestatement_to_json(resource),
    "DeviceUseStatement",
    r4usp.deviceusestatement_decoder(),
    client,
    handle_response,
  )
}

pub fn deviceusestatement_delete(
  resource: r4usp.Deviceusestatement,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "DeviceUseStatement", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn deviceusestatement_search_bundled(
  search_for search_args: r4usp_sansio.SpDeviceusestatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.deviceusestatement_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn deviceusestatement_search(
  search_for search_args: r4usp_sansio.SpDeviceusestatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Deviceusestatement), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.deviceusestatement_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.deviceusestatement
    },
  )
}

pub fn diagnosticreport_create(
  resource: r4usp.Diagnosticreport,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Diagnosticreport, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.diagnosticreport_to_json(resource),
    "DiagnosticReport",
    r4usp.diagnosticreport_decoder(),
    client,
    handle_response,
  )
}

pub fn diagnosticreport_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Diagnosticreport, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DiagnosticReport",
    r4usp.diagnosticreport_decoder(),
    client,
    handle_response,
  )
}

pub fn diagnosticreport_update(
  resource: r4usp.Diagnosticreport,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Diagnosticreport, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.diagnosticreport_to_json(resource),
    "DiagnosticReport",
    r4usp.diagnosticreport_decoder(),
    client,
    handle_response,
  )
}

pub fn diagnosticreport_delete(
  resource: r4usp.Diagnosticreport,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "DiagnosticReport", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn diagnosticreport_search_bundled(
  search_for search_args: r4usp_sansio.SpDiagnosticreport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.diagnosticreport_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn diagnosticreport_search(
  search_for search_args: r4usp_sansio.SpDiagnosticreport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Diagnosticreport), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.diagnosticreport_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.diagnosticreport
    },
  )
}

pub fn documentmanifest_create(
  resource: r4usp.Documentmanifest,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Documentmanifest, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.documentmanifest_to_json(resource),
    "DocumentManifest",
    r4usp.documentmanifest_decoder(),
    client,
    handle_response,
  )
}

pub fn documentmanifest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Documentmanifest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DocumentManifest",
    r4usp.documentmanifest_decoder(),
    client,
    handle_response,
  )
}

pub fn documentmanifest_update(
  resource: r4usp.Documentmanifest,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Documentmanifest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.documentmanifest_to_json(resource),
    "DocumentManifest",
    r4usp.documentmanifest_decoder(),
    client,
    handle_response,
  )
}

pub fn documentmanifest_delete(
  resource: r4usp.Documentmanifest,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "DocumentManifest", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn documentmanifest_search_bundled(
  search_for search_args: r4usp_sansio.SpDocumentmanifest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.documentmanifest_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn documentmanifest_search(
  search_for search_args: r4usp_sansio.SpDocumentmanifest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Documentmanifest), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.documentmanifest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.documentmanifest
    },
  )
}

pub fn documentreference_create(
  resource: r4usp.Documentreference,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Documentreference, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.documentreference_to_json(resource),
    "DocumentReference",
    r4usp.documentreference_decoder(),
    client,
    handle_response,
  )
}

pub fn documentreference_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Documentreference, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DocumentReference",
    r4usp.documentreference_decoder(),
    client,
    handle_response,
  )
}

pub fn documentreference_update(
  resource: r4usp.Documentreference,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Documentreference, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.documentreference_to_json(resource),
    "DocumentReference",
    r4usp.documentreference_decoder(),
    client,
    handle_response,
  )
}

pub fn documentreference_delete(
  resource: r4usp.Documentreference,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "DocumentReference", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn documentreference_search_bundled(
  search_for search_args: r4usp_sansio.SpDocumentreference,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.documentreference_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn documentreference_search(
  search_for search_args: r4usp_sansio.SpDocumentreference,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Documentreference), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.documentreference_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.documentreference
    },
  )
}

pub fn effectevidencesynthesis_create(
  resource: r4usp.Effectevidencesynthesis,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Effectevidencesynthesis, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.effectevidencesynthesis_to_json(resource),
    "EffectEvidenceSynthesis",
    r4usp.effectevidencesynthesis_decoder(),
    client,
    handle_response,
  )
}

pub fn effectevidencesynthesis_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Effectevidencesynthesis, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EffectEvidenceSynthesis",
    r4usp.effectevidencesynthesis_decoder(),
    client,
    handle_response,
  )
}

pub fn effectevidencesynthesis_update(
  resource: r4usp.Effectevidencesynthesis,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Effectevidencesynthesis, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.effectevidencesynthesis_to_json(resource),
    "EffectEvidenceSynthesis",
    r4usp.effectevidencesynthesis_decoder(),
    client,
    handle_response,
  )
}

pub fn effectevidencesynthesis_delete(
  resource: r4usp.Effectevidencesynthesis,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "EffectEvidenceSynthesis", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn effectevidencesynthesis_search_bundled(
  search_for search_args: r4usp_sansio.SpEffectevidencesynthesis,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.effectevidencesynthesis_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn effectevidencesynthesis_search(
  search_for search_args: r4usp_sansio.SpEffectevidencesynthesis,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Effectevidencesynthesis), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.effectevidencesynthesis_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.effectevidencesynthesis
    },
  )
}

pub fn encounter_create(
  resource: r4usp.Encounter,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Encounter, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.encounter_to_json(resource),
    "Encounter",
    r4usp.encounter_decoder(),
    client,
    handle_response,
  )
}

pub fn encounter_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Encounter, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Encounter", r4usp.encounter_decoder(), client, handle_response)
}

pub fn encounter_update(
  resource: r4usp.Encounter,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Encounter, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.encounter_to_json(resource),
    "Encounter",
    r4usp.encounter_decoder(),
    client,
    handle_response,
  )
}

pub fn encounter_delete(
  resource: r4usp.Encounter,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Encounter", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn encounter_search_bundled(
  search_for search_args: r4usp_sansio.SpEncounter,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.encounter_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn encounter_search(
  search_for search_args: r4usp_sansio.SpEncounter,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Encounter), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.encounter_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.encounter
    },
  )
}

pub fn endpoint_create(
  resource: r4usp.Endpoint,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Endpoint, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.endpoint_to_json(resource),
    "Endpoint",
    r4usp.endpoint_decoder(),
    client,
    handle_response,
  )
}

pub fn endpoint_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Endpoint, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Endpoint", r4usp.endpoint_decoder(), client, handle_response)
}

pub fn endpoint_update(
  resource: r4usp.Endpoint,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Endpoint, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.endpoint_to_json(resource),
    "Endpoint",
    r4usp.endpoint_decoder(),
    client,
    handle_response,
  )
}

pub fn endpoint_delete(
  resource: r4usp.Endpoint,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Endpoint", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn endpoint_search_bundled(
  search_for search_args: r4usp_sansio.SpEndpoint,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.endpoint_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn endpoint_search(
  search_for search_args: r4usp_sansio.SpEndpoint,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Endpoint), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.endpoint_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.endpoint
    },
  )
}

pub fn enrollmentrequest_create(
  resource: r4usp.Enrollmentrequest,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Enrollmentrequest, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.enrollmentrequest_to_json(resource),
    "EnrollmentRequest",
    r4usp.enrollmentrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Enrollmentrequest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EnrollmentRequest",
    r4usp.enrollmentrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentrequest_update(
  resource: r4usp.Enrollmentrequest,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Enrollmentrequest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.enrollmentrequest_to_json(resource),
    "EnrollmentRequest",
    r4usp.enrollmentrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentrequest_delete(
  resource: r4usp.Enrollmentrequest,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "EnrollmentRequest", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn enrollmentrequest_search_bundled(
  search_for search_args: r4usp_sansio.SpEnrollmentrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.enrollmentrequest_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn enrollmentrequest_search(
  search_for search_args: r4usp_sansio.SpEnrollmentrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Enrollmentrequest), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.enrollmentrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.enrollmentrequest
    },
  )
}

pub fn enrollmentresponse_create(
  resource: r4usp.Enrollmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Enrollmentresponse, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.enrollmentresponse_to_json(resource),
    "EnrollmentResponse",
    r4usp.enrollmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Enrollmentresponse, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EnrollmentResponse",
    r4usp.enrollmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentresponse_update(
  resource: r4usp.Enrollmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Enrollmentresponse, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.enrollmentresponse_to_json(resource),
    "EnrollmentResponse",
    r4usp.enrollmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentresponse_delete(
  resource: r4usp.Enrollmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "EnrollmentResponse", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn enrollmentresponse_search_bundled(
  search_for search_args: r4usp_sansio.SpEnrollmentresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.enrollmentresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn enrollmentresponse_search(
  search_for search_args: r4usp_sansio.SpEnrollmentresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Enrollmentresponse), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.enrollmentresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.enrollmentresponse
    },
  )
}

pub fn episodeofcare_create(
  resource: r4usp.Episodeofcare,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Episodeofcare, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.episodeofcare_to_json(resource),
    "EpisodeOfCare",
    r4usp.episodeofcare_decoder(),
    client,
    handle_response,
  )
}

pub fn episodeofcare_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Episodeofcare, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EpisodeOfCare",
    r4usp.episodeofcare_decoder(),
    client,
    handle_response,
  )
}

pub fn episodeofcare_update(
  resource: r4usp.Episodeofcare,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Episodeofcare, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.episodeofcare_to_json(resource),
    "EpisodeOfCare",
    r4usp.episodeofcare_decoder(),
    client,
    handle_response,
  )
}

pub fn episodeofcare_delete(
  resource: r4usp.Episodeofcare,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "EpisodeOfCare", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn episodeofcare_search_bundled(
  search_for search_args: r4usp_sansio.SpEpisodeofcare,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.episodeofcare_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn episodeofcare_search(
  search_for search_args: r4usp_sansio.SpEpisodeofcare,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Episodeofcare), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.episodeofcare_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.episodeofcare
    },
  )
}

pub fn eventdefinition_create(
  resource: r4usp.Eventdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Eventdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.eventdefinition_to_json(resource),
    "EventDefinition",
    r4usp.eventdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn eventdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Eventdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EventDefinition",
    r4usp.eventdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn eventdefinition_update(
  resource: r4usp.Eventdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Eventdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.eventdefinition_to_json(resource),
    "EventDefinition",
    r4usp.eventdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn eventdefinition_delete(
  resource: r4usp.Eventdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "EventDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn eventdefinition_search_bundled(
  search_for search_args: r4usp_sansio.SpEventdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.eventdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn eventdefinition_search(
  search_for search_args: r4usp_sansio.SpEventdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Eventdefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.eventdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.eventdefinition
    },
  )
}

pub fn evidence_create(
  resource: r4usp.Evidence,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Evidence, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.evidence_to_json(resource),
    "Evidence",
    r4usp.evidence_decoder(),
    client,
    handle_response,
  )
}

pub fn evidence_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Evidence, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Evidence", r4usp.evidence_decoder(), client, handle_response)
}

pub fn evidence_update(
  resource: r4usp.Evidence,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Evidence, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.evidence_to_json(resource),
    "Evidence",
    r4usp.evidence_decoder(),
    client,
    handle_response,
  )
}

pub fn evidence_delete(
  resource: r4usp.Evidence,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Evidence", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn evidence_search_bundled(
  search_for search_args: r4usp_sansio.SpEvidence,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.evidence_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn evidence_search(
  search_for search_args: r4usp_sansio.SpEvidence,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Evidence), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.evidence_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.evidence
    },
  )
}

pub fn evidencevariable_create(
  resource: r4usp.Evidencevariable,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Evidencevariable, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.evidencevariable_to_json(resource),
    "EvidenceVariable",
    r4usp.evidencevariable_decoder(),
    client,
    handle_response,
  )
}

pub fn evidencevariable_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Evidencevariable, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EvidenceVariable",
    r4usp.evidencevariable_decoder(),
    client,
    handle_response,
  )
}

pub fn evidencevariable_update(
  resource: r4usp.Evidencevariable,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Evidencevariable, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.evidencevariable_to_json(resource),
    "EvidenceVariable",
    r4usp.evidencevariable_decoder(),
    client,
    handle_response,
  )
}

pub fn evidencevariable_delete(
  resource: r4usp.Evidencevariable,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "EvidenceVariable", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn evidencevariable_search_bundled(
  search_for search_args: r4usp_sansio.SpEvidencevariable,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.evidencevariable_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn evidencevariable_search(
  search_for search_args: r4usp_sansio.SpEvidencevariable,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Evidencevariable), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.evidencevariable_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.evidencevariable
    },
  )
}

pub fn examplescenario_create(
  resource: r4usp.Examplescenario,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Examplescenario, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.examplescenario_to_json(resource),
    "ExampleScenario",
    r4usp.examplescenario_decoder(),
    client,
    handle_response,
  )
}

pub fn examplescenario_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Examplescenario, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ExampleScenario",
    r4usp.examplescenario_decoder(),
    client,
    handle_response,
  )
}

pub fn examplescenario_update(
  resource: r4usp.Examplescenario,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Examplescenario, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.examplescenario_to_json(resource),
    "ExampleScenario",
    r4usp.examplescenario_decoder(),
    client,
    handle_response,
  )
}

pub fn examplescenario_delete(
  resource: r4usp.Examplescenario,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "ExampleScenario", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn examplescenario_search_bundled(
  search_for search_args: r4usp_sansio.SpExamplescenario,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.examplescenario_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn examplescenario_search(
  search_for search_args: r4usp_sansio.SpExamplescenario,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Examplescenario), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.examplescenario_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.examplescenario
    },
  )
}

pub fn explanationofbenefit_create(
  resource: r4usp.Explanationofbenefit,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Explanationofbenefit, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.explanationofbenefit_to_json(resource),
    "ExplanationOfBenefit",
    r4usp.explanationofbenefit_decoder(),
    client,
    handle_response,
  )
}

pub fn explanationofbenefit_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Explanationofbenefit, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ExplanationOfBenefit",
    r4usp.explanationofbenefit_decoder(),
    client,
    handle_response,
  )
}

pub fn explanationofbenefit_update(
  resource: r4usp.Explanationofbenefit,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Explanationofbenefit, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.explanationofbenefit_to_json(resource),
    "ExplanationOfBenefit",
    r4usp.explanationofbenefit_decoder(),
    client,
    handle_response,
  )
}

pub fn explanationofbenefit_delete(
  resource: r4usp.Explanationofbenefit,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "ExplanationOfBenefit", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn explanationofbenefit_search_bundled(
  search_for search_args: r4usp_sansio.SpExplanationofbenefit,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.explanationofbenefit_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn explanationofbenefit_search(
  search_for search_args: r4usp_sansio.SpExplanationofbenefit,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Explanationofbenefit), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.explanationofbenefit_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.explanationofbenefit
    },
  )
}

pub fn familymemberhistory_create(
  resource: r4usp.Familymemberhistory,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Familymemberhistory, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    r4usp.familymemberhistory_decoder(),
    client,
    handle_response,
  )
}

pub fn familymemberhistory_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Familymemberhistory, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "FamilyMemberHistory",
    r4usp.familymemberhistory_decoder(),
    client,
    handle_response,
  )
}

pub fn familymemberhistory_update(
  resource: r4usp.Familymemberhistory,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Familymemberhistory, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    r4usp.familymemberhistory_decoder(),
    client,
    handle_response,
  )
}

pub fn familymemberhistory_delete(
  resource: r4usp.Familymemberhistory,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "FamilyMemberHistory", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn familymemberhistory_search_bundled(
  search_for search_args: r4usp_sansio.SpFamilymemberhistory,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.familymemberhistory_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn familymemberhistory_search(
  search_for search_args: r4usp_sansio.SpFamilymemberhistory,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Familymemberhistory), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.familymemberhistory_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.familymemberhistory
    },
  )
}

pub fn flag_create(
  resource: r4usp.Flag,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Flag, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.flag_to_json(resource),
    "Flag",
    r4usp.flag_decoder(),
    client,
    handle_response,
  )
}

pub fn flag_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Flag, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Flag", r4usp.flag_decoder(), client, handle_response)
}

pub fn flag_update(
  resource: r4usp.Flag,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Flag, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.flag_to_json(resource),
    "Flag",
    r4usp.flag_decoder(),
    client,
    handle_response,
  )
}

pub fn flag_delete(
  resource: r4usp.Flag,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Flag", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn flag_search_bundled(
  search_for search_args: r4usp_sansio.SpFlag,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.flag_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn flag_search(
  search_for search_args: r4usp_sansio.SpFlag,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Flag), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.flag_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> r4usp_sansio.bundle_to_groupedresources }.flag },
  )
}

pub fn goal_create(
  resource: r4usp.Goal,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Goal, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.goal_to_json(resource),
    "Goal",
    r4usp.goal_decoder(),
    client,
    handle_response,
  )
}

pub fn goal_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Goal, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Goal", r4usp.goal_decoder(), client, handle_response)
}

pub fn goal_update(
  resource: r4usp.Goal,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Goal, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.goal_to_json(resource),
    "Goal",
    r4usp.goal_decoder(),
    client,
    handle_response,
  )
}

pub fn goal_delete(
  resource: r4usp.Goal,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Goal", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn goal_search_bundled(
  search_for search_args: r4usp_sansio.SpGoal,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.goal_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn goal_search(
  search_for search_args: r4usp_sansio.SpGoal,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Goal), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.goal_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> r4usp_sansio.bundle_to_groupedresources }.goal },
  )
}

pub fn graphdefinition_create(
  resource: r4usp.Graphdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Graphdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.graphdefinition_to_json(resource),
    "GraphDefinition",
    r4usp.graphdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn graphdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Graphdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "GraphDefinition",
    r4usp.graphdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn graphdefinition_update(
  resource: r4usp.Graphdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Graphdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.graphdefinition_to_json(resource),
    "GraphDefinition",
    r4usp.graphdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn graphdefinition_delete(
  resource: r4usp.Graphdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "GraphDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn graphdefinition_search_bundled(
  search_for search_args: r4usp_sansio.SpGraphdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.graphdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn graphdefinition_search(
  search_for search_args: r4usp_sansio.SpGraphdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Graphdefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.graphdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.graphdefinition
    },
  )
}

pub fn group_create(
  resource: r4usp.Group,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Group, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.group_to_json(resource),
    "Group",
    r4usp.group_decoder(),
    client,
    handle_response,
  )
}

pub fn group_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Group, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Group", r4usp.group_decoder(), client, handle_response)
}

pub fn group_update(
  resource: r4usp.Group,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Group, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.group_to_json(resource),
    "Group",
    r4usp.group_decoder(),
    client,
    handle_response,
  )
}

pub fn group_delete(
  resource: r4usp.Group,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Group", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn group_search_bundled(
  search_for search_args: r4usp_sansio.SpGroup,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.group_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn group_search(
  search_for search_args: r4usp_sansio.SpGroup,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Group), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.group_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> r4usp_sansio.bundle_to_groupedresources }.group },
  )
}

pub fn guidanceresponse_create(
  resource: r4usp.Guidanceresponse,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Guidanceresponse, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.guidanceresponse_to_json(resource),
    "GuidanceResponse",
    r4usp.guidanceresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn guidanceresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Guidanceresponse, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "GuidanceResponse",
    r4usp.guidanceresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn guidanceresponse_update(
  resource: r4usp.Guidanceresponse,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Guidanceresponse, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.guidanceresponse_to_json(resource),
    "GuidanceResponse",
    r4usp.guidanceresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn guidanceresponse_delete(
  resource: r4usp.Guidanceresponse,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "GuidanceResponse", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn guidanceresponse_search_bundled(
  search_for search_args: r4usp_sansio.SpGuidanceresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.guidanceresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn guidanceresponse_search(
  search_for search_args: r4usp_sansio.SpGuidanceresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Guidanceresponse), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.guidanceresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.guidanceresponse
    },
  )
}

pub fn healthcareservice_create(
  resource: r4usp.Healthcareservice,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Healthcareservice, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.healthcareservice_to_json(resource),
    "HealthcareService",
    r4usp.healthcareservice_decoder(),
    client,
    handle_response,
  )
}

pub fn healthcareservice_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Healthcareservice, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "HealthcareService",
    r4usp.healthcareservice_decoder(),
    client,
    handle_response,
  )
}

pub fn healthcareservice_update(
  resource: r4usp.Healthcareservice,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Healthcareservice, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.healthcareservice_to_json(resource),
    "HealthcareService",
    r4usp.healthcareservice_decoder(),
    client,
    handle_response,
  )
}

pub fn healthcareservice_delete(
  resource: r4usp.Healthcareservice,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "HealthcareService", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn healthcareservice_search_bundled(
  search_for search_args: r4usp_sansio.SpHealthcareservice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.healthcareservice_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn healthcareservice_search(
  search_for search_args: r4usp_sansio.SpHealthcareservice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Healthcareservice), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.healthcareservice_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.healthcareservice
    },
  )
}

pub fn imagingstudy_create(
  resource: r4usp.Imagingstudy,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Imagingstudy, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.imagingstudy_to_json(resource),
    "ImagingStudy",
    r4usp.imagingstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn imagingstudy_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Imagingstudy, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ImagingStudy",
    r4usp.imagingstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn imagingstudy_update(
  resource: r4usp.Imagingstudy,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Imagingstudy, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.imagingstudy_to_json(resource),
    "ImagingStudy",
    r4usp.imagingstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn imagingstudy_delete(
  resource: r4usp.Imagingstudy,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "ImagingStudy", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn imagingstudy_search_bundled(
  search_for search_args: r4usp_sansio.SpImagingstudy,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.imagingstudy_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn imagingstudy_search(
  search_for search_args: r4usp_sansio.SpImagingstudy,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Imagingstudy), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.imagingstudy_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.imagingstudy
    },
  )
}

pub fn immunization_create(
  resource: r4usp.Immunization,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Immunization, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.immunization_to_json(resource),
    "Immunization",
    r4usp.immunization_decoder(),
    client,
    handle_response,
  )
}

pub fn immunization_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Immunization, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Immunization",
    r4usp.immunization_decoder(),
    client,
    handle_response,
  )
}

pub fn immunization_update(
  resource: r4usp.Immunization,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Immunization, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.immunization_to_json(resource),
    "Immunization",
    r4usp.immunization_decoder(),
    client,
    handle_response,
  )
}

pub fn immunization_delete(
  resource: r4usp.Immunization,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Immunization", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn immunization_search_bundled(
  search_for search_args: r4usp_sansio.SpImmunization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.immunization_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn immunization_search(
  search_for search_args: r4usp_sansio.SpImmunization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Immunization), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.immunization_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.immunization
    },
  )
}

pub fn immunizationevaluation_create(
  resource: r4usp.Immunizationevaluation,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Immunizationevaluation, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.immunizationevaluation_to_json(resource),
    "ImmunizationEvaluation",
    r4usp.immunizationevaluation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationevaluation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Immunizationevaluation, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ImmunizationEvaluation",
    r4usp.immunizationevaluation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationevaluation_update(
  resource: r4usp.Immunizationevaluation,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Immunizationevaluation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.immunizationevaluation_to_json(resource),
    "ImmunizationEvaluation",
    r4usp.immunizationevaluation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationevaluation_delete(
  resource: r4usp.Immunizationevaluation,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "ImmunizationEvaluation", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn immunizationevaluation_search_bundled(
  search_for search_args: r4usp_sansio.SpImmunizationevaluation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.immunizationevaluation_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn immunizationevaluation_search(
  search_for search_args: r4usp_sansio.SpImmunizationevaluation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Immunizationevaluation), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.immunizationevaluation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.immunizationevaluation
    },
  )
}

pub fn immunizationrecommendation_create(
  resource: r4usp.Immunizationrecommendation,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Immunizationrecommendation, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.immunizationrecommendation_to_json(resource),
    "ImmunizationRecommendation",
    r4usp.immunizationrecommendation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationrecommendation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Immunizationrecommendation, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ImmunizationRecommendation",
    r4usp.immunizationrecommendation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationrecommendation_update(
  resource: r4usp.Immunizationrecommendation,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Immunizationrecommendation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.immunizationrecommendation_to_json(resource),
    "ImmunizationRecommendation",
    r4usp.immunizationrecommendation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationrecommendation_delete(
  resource: r4usp.Immunizationrecommendation,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "ImmunizationRecommendation", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn immunizationrecommendation_search_bundled(
  search_for search_args: r4usp_sansio.SpImmunizationrecommendation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.immunizationrecommendation_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn immunizationrecommendation_search(
  search_for search_args: r4usp_sansio.SpImmunizationrecommendation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Immunizationrecommendation), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.immunizationrecommendation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.immunizationrecommendation
    },
  )
}

pub fn implementationguide_create(
  resource: r4usp.Implementationguide,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Implementationguide, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.implementationguide_to_json(resource),
    "ImplementationGuide",
    r4usp.implementationguide_decoder(),
    client,
    handle_response,
  )
}

pub fn implementationguide_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Implementationguide, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ImplementationGuide",
    r4usp.implementationguide_decoder(),
    client,
    handle_response,
  )
}

pub fn implementationguide_update(
  resource: r4usp.Implementationguide,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Implementationguide, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.implementationguide_to_json(resource),
    "ImplementationGuide",
    r4usp.implementationguide_decoder(),
    client,
    handle_response,
  )
}

pub fn implementationguide_delete(
  resource: r4usp.Implementationguide,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "ImplementationGuide", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn implementationguide_search_bundled(
  search_for search_args: r4usp_sansio.SpImplementationguide,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.implementationguide_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn implementationguide_search(
  search_for search_args: r4usp_sansio.SpImplementationguide,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Implementationguide), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.implementationguide_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.implementationguide
    },
  )
}

pub fn insuranceplan_create(
  resource: r4usp.Insuranceplan,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Insuranceplan, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.insuranceplan_to_json(resource),
    "InsurancePlan",
    r4usp.insuranceplan_decoder(),
    client,
    handle_response,
  )
}

pub fn insuranceplan_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Insuranceplan, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "InsurancePlan",
    r4usp.insuranceplan_decoder(),
    client,
    handle_response,
  )
}

pub fn insuranceplan_update(
  resource: r4usp.Insuranceplan,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Insuranceplan, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.insuranceplan_to_json(resource),
    "InsurancePlan",
    r4usp.insuranceplan_decoder(),
    client,
    handle_response,
  )
}

pub fn insuranceplan_delete(
  resource: r4usp.Insuranceplan,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "InsurancePlan", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn insuranceplan_search_bundled(
  search_for search_args: r4usp_sansio.SpInsuranceplan,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.insuranceplan_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn insuranceplan_search(
  search_for search_args: r4usp_sansio.SpInsuranceplan,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Insuranceplan), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.insuranceplan_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.insuranceplan
    },
  )
}

pub fn invoice_create(
  resource: r4usp.Invoice,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Invoice, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.invoice_to_json(resource),
    "Invoice",
    r4usp.invoice_decoder(),
    client,
    handle_response,
  )
}

pub fn invoice_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Invoice, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Invoice", r4usp.invoice_decoder(), client, handle_response)
}

pub fn invoice_update(
  resource: r4usp.Invoice,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Invoice, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.invoice_to_json(resource),
    "Invoice",
    r4usp.invoice_decoder(),
    client,
    handle_response,
  )
}

pub fn invoice_delete(
  resource: r4usp.Invoice,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Invoice", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn invoice_search_bundled(
  search_for search_args: r4usp_sansio.SpInvoice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.invoice_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn invoice_search(
  search_for search_args: r4usp_sansio.SpInvoice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Invoice), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.invoice_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> r4usp_sansio.bundle_to_groupedresources }.invoice },
  )
}

pub fn library_create(
  resource: r4usp.Library,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Library, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.library_to_json(resource),
    "Library",
    r4usp.library_decoder(),
    client,
    handle_response,
  )
}

pub fn library_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Library, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Library", r4usp.library_decoder(), client, handle_response)
}

pub fn library_update(
  resource: r4usp.Library,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Library, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.library_to_json(resource),
    "Library",
    r4usp.library_decoder(),
    client,
    handle_response,
  )
}

pub fn library_delete(
  resource: r4usp.Library,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Library", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn library_search_bundled(
  search_for search_args: r4usp_sansio.SpLibrary,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.library_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn library_search(
  search_for search_args: r4usp_sansio.SpLibrary,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Library), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.library_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> r4usp_sansio.bundle_to_groupedresources }.library },
  )
}

pub fn linkage_create(
  resource: r4usp.Linkage,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Linkage, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.linkage_to_json(resource),
    "Linkage",
    r4usp.linkage_decoder(),
    client,
    handle_response,
  )
}

pub fn linkage_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Linkage, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Linkage", r4usp.linkage_decoder(), client, handle_response)
}

pub fn linkage_update(
  resource: r4usp.Linkage,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Linkage, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.linkage_to_json(resource),
    "Linkage",
    r4usp.linkage_decoder(),
    client,
    handle_response,
  )
}

pub fn linkage_delete(
  resource: r4usp.Linkage,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Linkage", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn linkage_search_bundled(
  search_for search_args: r4usp_sansio.SpLinkage,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.linkage_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn linkage_search(
  search_for search_args: r4usp_sansio.SpLinkage,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Linkage), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.linkage_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> r4usp_sansio.bundle_to_groupedresources }.linkage },
  )
}

pub fn listfhir_create(
  resource: r4usp.Listfhir,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Listfhir, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.listfhir_to_json(resource),
    "List",
    r4usp.listfhir_decoder(),
    client,
    handle_response,
  )
}

pub fn listfhir_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Listfhir, Err)) -> a,
) -> Effect(a) {
  any_read(id, "List", r4usp.listfhir_decoder(), client, handle_response)
}

pub fn listfhir_update(
  resource: r4usp.Listfhir,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Listfhir, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.listfhir_to_json(resource),
    "List",
    r4usp.listfhir_decoder(),
    client,
    handle_response,
  )
}

pub fn listfhir_delete(
  resource: r4usp.Listfhir,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "List", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn listfhir_search_bundled(
  search_for search_args: r4usp_sansio.SpListfhir,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.listfhir_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn listfhir_search(
  search_for search_args: r4usp_sansio.SpListfhir,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Listfhir), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.listfhir_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.listfhir
    },
  )
}

pub fn location_create(
  resource: r4usp.Location,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Location, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.location_to_json(resource),
    "Location",
    r4usp.location_decoder(),
    client,
    handle_response,
  )
}

pub fn location_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Location, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Location", r4usp.location_decoder(), client, handle_response)
}

pub fn location_update(
  resource: r4usp.Location,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Location, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.location_to_json(resource),
    "Location",
    r4usp.location_decoder(),
    client,
    handle_response,
  )
}

pub fn location_delete(
  resource: r4usp.Location,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Location", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn location_search_bundled(
  search_for search_args: r4usp_sansio.SpLocation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.location_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn location_search(
  search_for search_args: r4usp_sansio.SpLocation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Location), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.location_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.location
    },
  )
}

pub fn measure_create(
  resource: r4usp.Measure,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Measure, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.measure_to_json(resource),
    "Measure",
    r4usp.measure_decoder(),
    client,
    handle_response,
  )
}

pub fn measure_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Measure, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Measure", r4usp.measure_decoder(), client, handle_response)
}

pub fn measure_update(
  resource: r4usp.Measure,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Measure, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.measure_to_json(resource),
    "Measure",
    r4usp.measure_decoder(),
    client,
    handle_response,
  )
}

pub fn measure_delete(
  resource: r4usp.Measure,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Measure", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn measure_search_bundled(
  search_for search_args: r4usp_sansio.SpMeasure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.measure_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn measure_search(
  search_for search_args: r4usp_sansio.SpMeasure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Measure), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.measure_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> r4usp_sansio.bundle_to_groupedresources }.measure },
  )
}

pub fn measurereport_create(
  resource: r4usp.Measurereport,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Measurereport, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.measurereport_to_json(resource),
    "MeasureReport",
    r4usp.measurereport_decoder(),
    client,
    handle_response,
  )
}

pub fn measurereport_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Measurereport, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MeasureReport",
    r4usp.measurereport_decoder(),
    client,
    handle_response,
  )
}

pub fn measurereport_update(
  resource: r4usp.Measurereport,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Measurereport, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.measurereport_to_json(resource),
    "MeasureReport",
    r4usp.measurereport_decoder(),
    client,
    handle_response,
  )
}

pub fn measurereport_delete(
  resource: r4usp.Measurereport,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "MeasureReport", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn measurereport_search_bundled(
  search_for search_args: r4usp_sansio.SpMeasurereport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.measurereport_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn measurereport_search(
  search_for search_args: r4usp_sansio.SpMeasurereport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Measurereport), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.measurereport_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.measurereport
    },
  )
}

pub fn media_create(
  resource: r4usp.Media,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Media, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.media_to_json(resource),
    "Media",
    r4usp.media_decoder(),
    client,
    handle_response,
  )
}

pub fn media_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Media, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Media", r4usp.media_decoder(), client, handle_response)
}

pub fn media_update(
  resource: r4usp.Media,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Media, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.media_to_json(resource),
    "Media",
    r4usp.media_decoder(),
    client,
    handle_response,
  )
}

pub fn media_delete(
  resource: r4usp.Media,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Media", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn media_search_bundled(
  search_for search_args: r4usp_sansio.SpMedia,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.media_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn media_search(
  search_for search_args: r4usp_sansio.SpMedia,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Media), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.media_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> r4usp_sansio.bundle_to_groupedresources }.media },
  )
}

pub fn medication_create(
  resource: r4usp.Medication,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medication, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.medication_to_json(resource),
    "Medication",
    r4usp.medication_decoder(),
    client,
    handle_response,
  )
}

pub fn medication_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medication, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Medication",
    r4usp.medication_decoder(),
    client,
    handle_response,
  )
}

pub fn medication_update(
  resource: r4usp.Medication,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medication, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.medication_to_json(resource),
    "Medication",
    r4usp.medication_decoder(),
    client,
    handle_response,
  )
}

pub fn medication_delete(
  resource: r4usp.Medication,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Medication", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn medication_search_bundled(
  search_for search_args: r4usp_sansio.SpMedication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.medication_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn medication_search(
  search_for search_args: r4usp_sansio.SpMedication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Medication), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.medication_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.medication
    },
  )
}

pub fn medicationadministration_create(
  resource: r4usp.Medicationadministration,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicationadministration, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.medicationadministration_to_json(resource),
    "MedicationAdministration",
    r4usp.medicationadministration_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationadministration_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicationadministration, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationAdministration",
    r4usp.medicationadministration_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationadministration_update(
  resource: r4usp.Medicationadministration,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicationadministration, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.medicationadministration_to_json(resource),
    "MedicationAdministration",
    r4usp.medicationadministration_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationadministration_delete(
  resource: r4usp.Medicationadministration,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "MedicationAdministration", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn medicationadministration_search_bundled(
  search_for search_args: r4usp_sansio.SpMedicationadministration,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.medicationadministration_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn medicationadministration_search(
  search_for search_args: r4usp_sansio.SpMedicationadministration,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Medicationadministration), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.medicationadministration_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.medicationadministration
    },
  )
}

pub fn medicationdispense_create(
  resource: r4usp.Medicationdispense,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicationdispense, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.medicationdispense_to_json(resource),
    "MedicationDispense",
    r4usp.medicationdispense_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationdispense_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicationdispense, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationDispense",
    r4usp.medicationdispense_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationdispense_update(
  resource: r4usp.Medicationdispense,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicationdispense, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.medicationdispense_to_json(resource),
    "MedicationDispense",
    r4usp.medicationdispense_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationdispense_delete(
  resource: r4usp.Medicationdispense,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "MedicationDispense", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn medicationdispense_search_bundled(
  search_for search_args: r4usp_sansio.SpMedicationdispense,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.medicationdispense_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn medicationdispense_search(
  search_for search_args: r4usp_sansio.SpMedicationdispense,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Medicationdispense), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.medicationdispense_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.medicationdispense
    },
  )
}

pub fn medicationknowledge_create(
  resource: r4usp.Medicationknowledge,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicationknowledge, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.medicationknowledge_to_json(resource),
    "MedicationKnowledge",
    r4usp.medicationknowledge_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationknowledge_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicationknowledge, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationKnowledge",
    r4usp.medicationknowledge_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationknowledge_update(
  resource: r4usp.Medicationknowledge,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicationknowledge, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.medicationknowledge_to_json(resource),
    "MedicationKnowledge",
    r4usp.medicationknowledge_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationknowledge_delete(
  resource: r4usp.Medicationknowledge,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "MedicationKnowledge", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn medicationknowledge_search_bundled(
  search_for search_args: r4usp_sansio.SpMedicationknowledge,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.medicationknowledge_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn medicationknowledge_search(
  search_for search_args: r4usp_sansio.SpMedicationknowledge,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Medicationknowledge), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.medicationknowledge_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.medicationknowledge
    },
  )
}

pub fn medicationrequest_create(
  resource: r4usp.Medicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicationrequest, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.medicationrequest_to_json(resource),
    "MedicationRequest",
    r4usp.medicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicationrequest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationRequest",
    r4usp.medicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationrequest_update(
  resource: r4usp.Medicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicationrequest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.medicationrequest_to_json(resource),
    "MedicationRequest",
    r4usp.medicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationrequest_delete(
  resource: r4usp.Medicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "MedicationRequest", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn medicationrequest_search_bundled(
  search_for search_args: r4usp_sansio.SpMedicationrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.medicationrequest_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn medicationrequest_search(
  search_for search_args: r4usp_sansio.SpMedicationrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Medicationrequest), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.medicationrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.medicationrequest
    },
  )
}

pub fn medicationstatement_create(
  resource: r4usp.Medicationstatement,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicationstatement, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.medicationstatement_to_json(resource),
    "MedicationStatement",
    r4usp.medicationstatement_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationstatement_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicationstatement, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationStatement",
    r4usp.medicationstatement_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationstatement_update(
  resource: r4usp.Medicationstatement,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicationstatement, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.medicationstatement_to_json(resource),
    "MedicationStatement",
    r4usp.medicationstatement_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationstatement_delete(
  resource: r4usp.Medicationstatement,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "MedicationStatement", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn medicationstatement_search_bundled(
  search_for search_args: r4usp_sansio.SpMedicationstatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.medicationstatement_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn medicationstatement_search(
  search_for search_args: r4usp_sansio.SpMedicationstatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Medicationstatement), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.medicationstatement_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.medicationstatement
    },
  )
}

pub fn medicinalproduct_create(
  resource: r4usp.Medicinalproduct,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproduct, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.medicinalproduct_to_json(resource),
    "MedicinalProduct",
    r4usp.medicinalproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproduct_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproduct, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProduct",
    r4usp.medicinalproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproduct_update(
  resource: r4usp.Medicinalproduct,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproduct, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.medicinalproduct_to_json(resource),
    "MedicinalProduct",
    r4usp.medicinalproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproduct_delete(
  resource: r4usp.Medicinalproduct,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "MedicinalProduct", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn medicinalproduct_search_bundled(
  search_for search_args: r4usp_sansio.SpMedicinalproduct,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.medicinalproduct_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn medicinalproduct_search(
  search_for search_args: r4usp_sansio.SpMedicinalproduct,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Medicinalproduct), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.medicinalproduct_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.medicinalproduct
    },
  )
}

pub fn medicinalproductauthorization_create(
  resource: r4usp.Medicinalproductauthorization,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproductauthorization, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.medicinalproductauthorization_to_json(resource),
    "MedicinalProductAuthorization",
    r4usp.medicinalproductauthorization_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductauthorization_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproductauthorization, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductAuthorization",
    r4usp.medicinalproductauthorization_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductauthorization_update(
  resource: r4usp.Medicinalproductauthorization,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproductauthorization, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.medicinalproductauthorization_to_json(resource),
    "MedicinalProductAuthorization",
    r4usp.medicinalproductauthorization_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductauthorization_delete(
  resource: r4usp.Medicinalproductauthorization,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(
        id,
        "MedicinalProductAuthorization",
        client,
        handle_response,
      ))
    None -> Error(ErrNoId)
  }
}

pub fn medicinalproductauthorization_search_bundled(
  search_for search_args: r4usp_sansio.SpMedicinalproductauthorization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.medicinalproductauthorization_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn medicinalproductauthorization_search(
  search_for search_args: r4usp_sansio.SpMedicinalproductauthorization,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Medicinalproductauthorization), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.medicinalproductauthorization_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.medicinalproductauthorization
    },
  )
}

pub fn medicinalproductcontraindication_create(
  resource: r4usp.Medicinalproductcontraindication,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproductcontraindication, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.medicinalproductcontraindication_to_json(resource),
    "MedicinalProductContraindication",
    r4usp.medicinalproductcontraindication_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductcontraindication_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproductcontraindication, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductContraindication",
    r4usp.medicinalproductcontraindication_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductcontraindication_update(
  resource: r4usp.Medicinalproductcontraindication,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproductcontraindication, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.medicinalproductcontraindication_to_json(resource),
    "MedicinalProductContraindication",
    r4usp.medicinalproductcontraindication_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductcontraindication_delete(
  resource: r4usp.Medicinalproductcontraindication,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(
        id,
        "MedicinalProductContraindication",
        client,
        handle_response,
      ))
    None -> Error(ErrNoId)
  }
}

pub fn medicinalproductcontraindication_search_bundled(
  search_for search_args: r4usp_sansio.SpMedicinalproductcontraindication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.medicinalproductcontraindication_search_req(
      search_args,
      client,
    )
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn medicinalproductcontraindication_search(
  search_for search_args: r4usp_sansio.SpMedicinalproductcontraindication,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Medicinalproductcontraindication), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.medicinalproductcontraindication_search_req(
      search_args,
      client,
    )
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.medicinalproductcontraindication
    },
  )
}

pub fn medicinalproductindication_create(
  resource: r4usp.Medicinalproductindication,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproductindication, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.medicinalproductindication_to_json(resource),
    "MedicinalProductIndication",
    r4usp.medicinalproductindication_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductindication_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproductindication, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductIndication",
    r4usp.medicinalproductindication_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductindication_update(
  resource: r4usp.Medicinalproductindication,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproductindication, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.medicinalproductindication_to_json(resource),
    "MedicinalProductIndication",
    r4usp.medicinalproductindication_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductindication_delete(
  resource: r4usp.Medicinalproductindication,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "MedicinalProductIndication", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn medicinalproductindication_search_bundled(
  search_for search_args: r4usp_sansio.SpMedicinalproductindication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.medicinalproductindication_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn medicinalproductindication_search(
  search_for search_args: r4usp_sansio.SpMedicinalproductindication,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Medicinalproductindication), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.medicinalproductindication_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.medicinalproductindication
    },
  )
}

pub fn medicinalproductingredient_create(
  resource: r4usp.Medicinalproductingredient,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproductingredient, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.medicinalproductingredient_to_json(resource),
    "MedicinalProductIngredient",
    r4usp.medicinalproductingredient_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductingredient_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproductingredient, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductIngredient",
    r4usp.medicinalproductingredient_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductingredient_update(
  resource: r4usp.Medicinalproductingredient,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproductingredient, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.medicinalproductingredient_to_json(resource),
    "MedicinalProductIngredient",
    r4usp.medicinalproductingredient_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductingredient_delete(
  resource: r4usp.Medicinalproductingredient,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "MedicinalProductIngredient", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn medicinalproductingredient_search_bundled(
  search_for search_args: r4usp_sansio.SpMedicinalproductingredient,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.medicinalproductingredient_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn medicinalproductingredient_search(
  search_for search_args: r4usp_sansio.SpMedicinalproductingredient,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Medicinalproductingredient), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.medicinalproductingredient_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.medicinalproductingredient
    },
  )
}

pub fn medicinalproductinteraction_create(
  resource: r4usp.Medicinalproductinteraction,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproductinteraction, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.medicinalproductinteraction_to_json(resource),
    "MedicinalProductInteraction",
    r4usp.medicinalproductinteraction_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductinteraction_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproductinteraction, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductInteraction",
    r4usp.medicinalproductinteraction_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductinteraction_update(
  resource: r4usp.Medicinalproductinteraction,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproductinteraction, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.medicinalproductinteraction_to_json(resource),
    "MedicinalProductInteraction",
    r4usp.medicinalproductinteraction_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductinteraction_delete(
  resource: r4usp.Medicinalproductinteraction,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "MedicinalProductInteraction", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn medicinalproductinteraction_search_bundled(
  search_for search_args: r4usp_sansio.SpMedicinalproductinteraction,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.medicinalproductinteraction_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn medicinalproductinteraction_search(
  search_for search_args: r4usp_sansio.SpMedicinalproductinteraction,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Medicinalproductinteraction), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.medicinalproductinteraction_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.medicinalproductinteraction
    },
  )
}

pub fn medicinalproductmanufactured_create(
  resource: r4usp.Medicinalproductmanufactured,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproductmanufactured, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.medicinalproductmanufactured_to_json(resource),
    "MedicinalProductManufactured",
    r4usp.medicinalproductmanufactured_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductmanufactured_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproductmanufactured, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductManufactured",
    r4usp.medicinalproductmanufactured_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductmanufactured_update(
  resource: r4usp.Medicinalproductmanufactured,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproductmanufactured, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.medicinalproductmanufactured_to_json(resource),
    "MedicinalProductManufactured",
    r4usp.medicinalproductmanufactured_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductmanufactured_delete(
  resource: r4usp.Medicinalproductmanufactured,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "MedicinalProductManufactured", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn medicinalproductmanufactured_search_bundled(
  search_for search_args: r4usp_sansio.SpMedicinalproductmanufactured,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.medicinalproductmanufactured_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn medicinalproductmanufactured_search(
  search_for search_args: r4usp_sansio.SpMedicinalproductmanufactured,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Medicinalproductmanufactured), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.medicinalproductmanufactured_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.medicinalproductmanufactured
    },
  )
}

pub fn medicinalproductpackaged_create(
  resource: r4usp.Medicinalproductpackaged,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproductpackaged, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.medicinalproductpackaged_to_json(resource),
    "MedicinalProductPackaged",
    r4usp.medicinalproductpackaged_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductpackaged_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproductpackaged, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductPackaged",
    r4usp.medicinalproductpackaged_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductpackaged_update(
  resource: r4usp.Medicinalproductpackaged,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproductpackaged, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.medicinalproductpackaged_to_json(resource),
    "MedicinalProductPackaged",
    r4usp.medicinalproductpackaged_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductpackaged_delete(
  resource: r4usp.Medicinalproductpackaged,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "MedicinalProductPackaged", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn medicinalproductpackaged_search_bundled(
  search_for search_args: r4usp_sansio.SpMedicinalproductpackaged,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.medicinalproductpackaged_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn medicinalproductpackaged_search(
  search_for search_args: r4usp_sansio.SpMedicinalproductpackaged,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Medicinalproductpackaged), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.medicinalproductpackaged_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.medicinalproductpackaged
    },
  )
}

pub fn medicinalproductpharmaceutical_create(
  resource: r4usp.Medicinalproductpharmaceutical,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproductpharmaceutical, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.medicinalproductpharmaceutical_to_json(resource),
    "MedicinalProductPharmaceutical",
    r4usp.medicinalproductpharmaceutical_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductpharmaceutical_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproductpharmaceutical, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductPharmaceutical",
    r4usp.medicinalproductpharmaceutical_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductpharmaceutical_update(
  resource: r4usp.Medicinalproductpharmaceutical,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproductpharmaceutical, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.medicinalproductpharmaceutical_to_json(resource),
    "MedicinalProductPharmaceutical",
    r4usp.medicinalproductpharmaceutical_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductpharmaceutical_delete(
  resource: r4usp.Medicinalproductpharmaceutical,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(
        id,
        "MedicinalProductPharmaceutical",
        client,
        handle_response,
      ))
    None -> Error(ErrNoId)
  }
}

pub fn medicinalproductpharmaceutical_search_bundled(
  search_for search_args: r4usp_sansio.SpMedicinalproductpharmaceutical,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.medicinalproductpharmaceutical_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn medicinalproductpharmaceutical_search(
  search_for search_args: r4usp_sansio.SpMedicinalproductpharmaceutical,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Medicinalproductpharmaceutical), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.medicinalproductpharmaceutical_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.medicinalproductpharmaceutical
    },
  )
}

pub fn medicinalproductundesirableeffect_create(
  resource: r4usp.Medicinalproductundesirableeffect,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproductundesirableeffect, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.medicinalproductundesirableeffect_to_json(resource),
    "MedicinalProductUndesirableEffect",
    r4usp.medicinalproductundesirableeffect_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductundesirableeffect_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproductundesirableeffect, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductUndesirableEffect",
    r4usp.medicinalproductundesirableeffect_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductundesirableeffect_update(
  resource: r4usp.Medicinalproductundesirableeffect,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Medicinalproductundesirableeffect, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.medicinalproductundesirableeffect_to_json(resource),
    "MedicinalProductUndesirableEffect",
    r4usp.medicinalproductundesirableeffect_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductundesirableeffect_delete(
  resource: r4usp.Medicinalproductundesirableeffect,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(
        id,
        "MedicinalProductUndesirableEffect",
        client,
        handle_response,
      ))
    None -> Error(ErrNoId)
  }
}

pub fn medicinalproductundesirableeffect_search_bundled(
  search_for search_args: r4usp_sansio.SpMedicinalproductundesirableeffect,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.medicinalproductundesirableeffect_search_req(
      search_args,
      client,
    )
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn medicinalproductundesirableeffect_search(
  search_for search_args: r4usp_sansio.SpMedicinalproductundesirableeffect,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Medicinalproductundesirableeffect), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.medicinalproductundesirableeffect_search_req(
      search_args,
      client,
    )
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.medicinalproductundesirableeffect
    },
  )
}

pub fn messagedefinition_create(
  resource: r4usp.Messagedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Messagedefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.messagedefinition_to_json(resource),
    "MessageDefinition",
    r4usp.messagedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn messagedefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Messagedefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MessageDefinition",
    r4usp.messagedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn messagedefinition_update(
  resource: r4usp.Messagedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Messagedefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.messagedefinition_to_json(resource),
    "MessageDefinition",
    r4usp.messagedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn messagedefinition_delete(
  resource: r4usp.Messagedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "MessageDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn messagedefinition_search_bundled(
  search_for search_args: r4usp_sansio.SpMessagedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.messagedefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn messagedefinition_search(
  search_for search_args: r4usp_sansio.SpMessagedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Messagedefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.messagedefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.messagedefinition
    },
  )
}

pub fn messageheader_create(
  resource: r4usp.Messageheader,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Messageheader, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.messageheader_to_json(resource),
    "MessageHeader",
    r4usp.messageheader_decoder(),
    client,
    handle_response,
  )
}

pub fn messageheader_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Messageheader, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MessageHeader",
    r4usp.messageheader_decoder(),
    client,
    handle_response,
  )
}

pub fn messageheader_update(
  resource: r4usp.Messageheader,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Messageheader, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.messageheader_to_json(resource),
    "MessageHeader",
    r4usp.messageheader_decoder(),
    client,
    handle_response,
  )
}

pub fn messageheader_delete(
  resource: r4usp.Messageheader,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "MessageHeader", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn messageheader_search_bundled(
  search_for search_args: r4usp_sansio.SpMessageheader,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.messageheader_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn messageheader_search(
  search_for search_args: r4usp_sansio.SpMessageheader,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Messageheader), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.messageheader_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.messageheader
    },
  )
}

pub fn molecularsequence_create(
  resource: r4usp.Molecularsequence,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Molecularsequence, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.molecularsequence_to_json(resource),
    "MolecularSequence",
    r4usp.molecularsequence_decoder(),
    client,
    handle_response,
  )
}

pub fn molecularsequence_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Molecularsequence, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MolecularSequence",
    r4usp.molecularsequence_decoder(),
    client,
    handle_response,
  )
}

pub fn molecularsequence_update(
  resource: r4usp.Molecularsequence,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Molecularsequence, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.molecularsequence_to_json(resource),
    "MolecularSequence",
    r4usp.molecularsequence_decoder(),
    client,
    handle_response,
  )
}

pub fn molecularsequence_delete(
  resource: r4usp.Molecularsequence,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "MolecularSequence", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn molecularsequence_search_bundled(
  search_for search_args: r4usp_sansio.SpMolecularsequence,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.molecularsequence_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn molecularsequence_search(
  search_for search_args: r4usp_sansio.SpMolecularsequence,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Molecularsequence), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.molecularsequence_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.molecularsequence
    },
  )
}

pub fn namingsystem_create(
  resource: r4usp.Namingsystem,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Namingsystem, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.namingsystem_to_json(resource),
    "NamingSystem",
    r4usp.namingsystem_decoder(),
    client,
    handle_response,
  )
}

pub fn namingsystem_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Namingsystem, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "NamingSystem",
    r4usp.namingsystem_decoder(),
    client,
    handle_response,
  )
}

pub fn namingsystem_update(
  resource: r4usp.Namingsystem,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Namingsystem, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.namingsystem_to_json(resource),
    "NamingSystem",
    r4usp.namingsystem_decoder(),
    client,
    handle_response,
  )
}

pub fn namingsystem_delete(
  resource: r4usp.Namingsystem,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "NamingSystem", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn namingsystem_search_bundled(
  search_for search_args: r4usp_sansio.SpNamingsystem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.namingsystem_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn namingsystem_search(
  search_for search_args: r4usp_sansio.SpNamingsystem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Namingsystem), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.namingsystem_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.namingsystem
    },
  )
}

pub fn nutritionorder_create(
  resource: r4usp.Nutritionorder,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Nutritionorder, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.nutritionorder_to_json(resource),
    "NutritionOrder",
    r4usp.nutritionorder_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionorder_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Nutritionorder, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "NutritionOrder",
    r4usp.nutritionorder_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionorder_update(
  resource: r4usp.Nutritionorder,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Nutritionorder, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.nutritionorder_to_json(resource),
    "NutritionOrder",
    r4usp.nutritionorder_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionorder_delete(
  resource: r4usp.Nutritionorder,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "NutritionOrder", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn nutritionorder_search_bundled(
  search_for search_args: r4usp_sansio.SpNutritionorder,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.nutritionorder_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn nutritionorder_search(
  search_for search_args: r4usp_sansio.SpNutritionorder,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Nutritionorder), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.nutritionorder_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.nutritionorder
    },
  )
}

pub fn observation_create(
  resource: r4usp.Observation,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Observation, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.observation_to_json(resource),
    "Observation",
    r4usp.observation_decoder(),
    client,
    handle_response,
  )
}

pub fn observation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Observation, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Observation",
    r4usp.observation_decoder(),
    client,
    handle_response,
  )
}

pub fn observation_update(
  resource: r4usp.Observation,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Observation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.observation_to_json(resource),
    "Observation",
    r4usp.observation_decoder(),
    client,
    handle_response,
  )
}

pub fn observation_delete(
  resource: r4usp.Observation,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Observation", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn observation_search_bundled(
  search_for search_args: r4usp_sansio.SpObservation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.observation_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn observation_search(
  search_for search_args: r4usp_sansio.SpObservation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Observation), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.observation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.observation
    },
  )
}

pub fn observationdefinition_create(
  resource: r4usp.Observationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Observationdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.observationdefinition_to_json(resource),
    "ObservationDefinition",
    r4usp.observationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn observationdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Observationdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ObservationDefinition",
    r4usp.observationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn observationdefinition_update(
  resource: r4usp.Observationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Observationdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.observationdefinition_to_json(resource),
    "ObservationDefinition",
    r4usp.observationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn observationdefinition_delete(
  resource: r4usp.Observationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "ObservationDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn observationdefinition_search_bundled(
  search_for search_args: r4usp_sansio.SpObservationdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.observationdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn observationdefinition_search(
  search_for search_args: r4usp_sansio.SpObservationdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Observationdefinition), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.observationdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.observationdefinition
    },
  )
}

pub fn operationdefinition_create(
  resource: r4usp.Operationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Operationdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.operationdefinition_to_json(resource),
    "OperationDefinition",
    r4usp.operationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn operationdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Operationdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "OperationDefinition",
    r4usp.operationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn operationdefinition_update(
  resource: r4usp.Operationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Operationdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.operationdefinition_to_json(resource),
    "OperationDefinition",
    r4usp.operationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn operationdefinition_delete(
  resource: r4usp.Operationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "OperationDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn operationdefinition_search_bundled(
  search_for search_args: r4usp_sansio.SpOperationdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.operationdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn operationdefinition_search(
  search_for search_args: r4usp_sansio.SpOperationdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Operationdefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.operationdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.operationdefinition
    },
  )
}

pub fn operationoutcome_create(
  resource: r4usp.Operationoutcome,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Operationoutcome, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.operationoutcome_to_json(resource),
    "OperationOutcome",
    r4usp.operationoutcome_decoder(),
    client,
    handle_response,
  )
}

pub fn operationoutcome_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Operationoutcome, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "OperationOutcome",
    r4usp.operationoutcome_decoder(),
    client,
    handle_response,
  )
}

pub fn operationoutcome_update(
  resource: r4usp.Operationoutcome,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.operationoutcome_to_json(resource),
    "OperationOutcome",
    r4usp.operationoutcome_decoder(),
    client,
    handle_response,
  )
}

pub fn operationoutcome_delete(
  resource: r4usp.Operationoutcome,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "OperationOutcome", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn operationoutcome_search_bundled(
  search_for search_args: r4usp_sansio.SpOperationoutcome,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.operationoutcome_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn operationoutcome_search(
  search_for search_args: r4usp_sansio.SpOperationoutcome,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Operationoutcome), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.operationoutcome_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.operationoutcome
    },
  )
}

pub fn organization_create(
  resource: r4usp.Organization,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Organization, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.organization_to_json(resource),
    "Organization",
    r4usp.organization_decoder(),
    client,
    handle_response,
  )
}

pub fn organization_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Organization, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Organization",
    r4usp.organization_decoder(),
    client,
    handle_response,
  )
}

pub fn organization_update(
  resource: r4usp.Organization,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Organization, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.organization_to_json(resource),
    "Organization",
    r4usp.organization_decoder(),
    client,
    handle_response,
  )
}

pub fn organization_delete(
  resource: r4usp.Organization,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Organization", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn organization_search_bundled(
  search_for search_args: r4usp_sansio.SpOrganization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.organization_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn organization_search(
  search_for search_args: r4usp_sansio.SpOrganization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Organization), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.organization_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.organization
    },
  )
}

pub fn organizationaffiliation_create(
  resource: r4usp.Organizationaffiliation,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Organizationaffiliation, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.organizationaffiliation_to_json(resource),
    "OrganizationAffiliation",
    r4usp.organizationaffiliation_decoder(),
    client,
    handle_response,
  )
}

pub fn organizationaffiliation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Organizationaffiliation, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "OrganizationAffiliation",
    r4usp.organizationaffiliation_decoder(),
    client,
    handle_response,
  )
}

pub fn organizationaffiliation_update(
  resource: r4usp.Organizationaffiliation,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Organizationaffiliation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.organizationaffiliation_to_json(resource),
    "OrganizationAffiliation",
    r4usp.organizationaffiliation_decoder(),
    client,
    handle_response,
  )
}

pub fn organizationaffiliation_delete(
  resource: r4usp.Organizationaffiliation,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "OrganizationAffiliation", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn organizationaffiliation_search_bundled(
  search_for search_args: r4usp_sansio.SpOrganizationaffiliation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.organizationaffiliation_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn organizationaffiliation_search(
  search_for search_args: r4usp_sansio.SpOrganizationaffiliation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Organizationaffiliation), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.organizationaffiliation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.organizationaffiliation
    },
  )
}

pub fn patient_create(
  resource: r4usp.Patient,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Patient, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.patient_to_json(resource),
    "Patient",
    r4usp.patient_decoder(),
    client,
    handle_response,
  )
}

pub fn patient_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Patient, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Patient", r4usp.patient_decoder(), client, handle_response)
}

pub fn patient_update(
  resource: r4usp.Patient,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Patient, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.patient_to_json(resource),
    "Patient",
    r4usp.patient_decoder(),
    client,
    handle_response,
  )
}

pub fn patient_delete(
  resource: r4usp.Patient,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Patient", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn patient_search_bundled(
  search_for search_args: r4usp_sansio.SpPatient,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.patient_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn patient_search(
  search_for search_args: r4usp_sansio.SpPatient,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Patient), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.patient_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> r4usp_sansio.bundle_to_groupedresources }.patient },
  )
}

pub fn paymentnotice_create(
  resource: r4usp.Paymentnotice,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Paymentnotice, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.paymentnotice_to_json(resource),
    "PaymentNotice",
    r4usp.paymentnotice_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentnotice_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Paymentnotice, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "PaymentNotice",
    r4usp.paymentnotice_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentnotice_update(
  resource: r4usp.Paymentnotice,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Paymentnotice, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.paymentnotice_to_json(resource),
    "PaymentNotice",
    r4usp.paymentnotice_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentnotice_delete(
  resource: r4usp.Paymentnotice,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "PaymentNotice", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn paymentnotice_search_bundled(
  search_for search_args: r4usp_sansio.SpPaymentnotice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.paymentnotice_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn paymentnotice_search(
  search_for search_args: r4usp_sansio.SpPaymentnotice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Paymentnotice), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.paymentnotice_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.paymentnotice
    },
  )
}

pub fn paymentreconciliation_create(
  resource: r4usp.Paymentreconciliation,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Paymentreconciliation, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.paymentreconciliation_to_json(resource),
    "PaymentReconciliation",
    r4usp.paymentreconciliation_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentreconciliation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Paymentreconciliation, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "PaymentReconciliation",
    r4usp.paymentreconciliation_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentreconciliation_update(
  resource: r4usp.Paymentreconciliation,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Paymentreconciliation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.paymentreconciliation_to_json(resource),
    "PaymentReconciliation",
    r4usp.paymentreconciliation_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentreconciliation_delete(
  resource: r4usp.Paymentreconciliation,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "PaymentReconciliation", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn paymentreconciliation_search_bundled(
  search_for search_args: r4usp_sansio.SpPaymentreconciliation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.paymentreconciliation_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn paymentreconciliation_search(
  search_for search_args: r4usp_sansio.SpPaymentreconciliation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Paymentreconciliation), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.paymentreconciliation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.paymentreconciliation
    },
  )
}

pub fn person_create(
  resource: r4usp.Person,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Person, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.person_to_json(resource),
    "Person",
    r4usp.person_decoder(),
    client,
    handle_response,
  )
}

pub fn person_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Person, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Person", r4usp.person_decoder(), client, handle_response)
}

pub fn person_update(
  resource: r4usp.Person,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Person, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.person_to_json(resource),
    "Person",
    r4usp.person_decoder(),
    client,
    handle_response,
  )
}

pub fn person_delete(
  resource: r4usp.Person,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Person", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn person_search_bundled(
  search_for search_args: r4usp_sansio.SpPerson,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.person_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn person_search(
  search_for search_args: r4usp_sansio.SpPerson,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Person), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.person_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> r4usp_sansio.bundle_to_groupedresources }.person },
  )
}

pub fn plandefinition_create(
  resource: r4usp.Plandefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Plandefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.plandefinition_to_json(resource),
    "PlanDefinition",
    r4usp.plandefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn plandefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Plandefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "PlanDefinition",
    r4usp.plandefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn plandefinition_update(
  resource: r4usp.Plandefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Plandefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.plandefinition_to_json(resource),
    "PlanDefinition",
    r4usp.plandefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn plandefinition_delete(
  resource: r4usp.Plandefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "PlanDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn plandefinition_search_bundled(
  search_for search_args: r4usp_sansio.SpPlandefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.plandefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn plandefinition_search(
  search_for search_args: r4usp_sansio.SpPlandefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Plandefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.plandefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.plandefinition
    },
  )
}

pub fn practitioner_create(
  resource: r4usp.Practitioner,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Practitioner, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.practitioner_to_json(resource),
    "Practitioner",
    r4usp.practitioner_decoder(),
    client,
    handle_response,
  )
}

pub fn practitioner_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Practitioner, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Practitioner",
    r4usp.practitioner_decoder(),
    client,
    handle_response,
  )
}

pub fn practitioner_update(
  resource: r4usp.Practitioner,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Practitioner, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.practitioner_to_json(resource),
    "Practitioner",
    r4usp.practitioner_decoder(),
    client,
    handle_response,
  )
}

pub fn practitioner_delete(
  resource: r4usp.Practitioner,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Practitioner", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn practitioner_search_bundled(
  search_for search_args: r4usp_sansio.SpPractitioner,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.practitioner_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn practitioner_search(
  search_for search_args: r4usp_sansio.SpPractitioner,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Practitioner), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.practitioner_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.practitioner
    },
  )
}

pub fn practitionerrole_create(
  resource: r4usp.Practitionerrole,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Practitionerrole, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.practitionerrole_to_json(resource),
    "PractitionerRole",
    r4usp.practitionerrole_decoder(),
    client,
    handle_response,
  )
}

pub fn practitionerrole_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Practitionerrole, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "PractitionerRole",
    r4usp.practitionerrole_decoder(),
    client,
    handle_response,
  )
}

pub fn practitionerrole_update(
  resource: r4usp.Practitionerrole,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Practitionerrole, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.practitionerrole_to_json(resource),
    "PractitionerRole",
    r4usp.practitionerrole_decoder(),
    client,
    handle_response,
  )
}

pub fn practitionerrole_delete(
  resource: r4usp.Practitionerrole,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "PractitionerRole", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn practitionerrole_search_bundled(
  search_for search_args: r4usp_sansio.SpPractitionerrole,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.practitionerrole_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn practitionerrole_search(
  search_for search_args: r4usp_sansio.SpPractitionerrole,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Practitionerrole), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.practitionerrole_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.practitionerrole
    },
  )
}

pub fn procedure_create(
  resource: r4usp.Procedure,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Procedure, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.procedure_to_json(resource),
    "Procedure",
    r4usp.procedure_decoder(),
    client,
    handle_response,
  )
}

pub fn procedure_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Procedure, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Procedure", r4usp.procedure_decoder(), client, handle_response)
}

pub fn procedure_update(
  resource: r4usp.Procedure,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Procedure, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.procedure_to_json(resource),
    "Procedure",
    r4usp.procedure_decoder(),
    client,
    handle_response,
  )
}

pub fn procedure_delete(
  resource: r4usp.Procedure,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Procedure", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn procedure_search_bundled(
  search_for search_args: r4usp_sansio.SpProcedure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.procedure_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn procedure_search(
  search_for search_args: r4usp_sansio.SpProcedure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Procedure), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.procedure_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.procedure
    },
  )
}

pub fn provenance_create(
  resource: r4usp.Provenance,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Provenance, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.provenance_to_json(resource),
    "Provenance",
    r4usp.provenance_decoder(),
    client,
    handle_response,
  )
}

pub fn provenance_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Provenance, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Provenance",
    r4usp.provenance_decoder(),
    client,
    handle_response,
  )
}

pub fn provenance_update(
  resource: r4usp.Provenance,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Provenance, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.provenance_to_json(resource),
    "Provenance",
    r4usp.provenance_decoder(),
    client,
    handle_response,
  )
}

pub fn provenance_delete(
  resource: r4usp.Provenance,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Provenance", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn provenance_search_bundled(
  search_for search_args: r4usp_sansio.SpProvenance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.provenance_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn provenance_search(
  search_for search_args: r4usp_sansio.SpProvenance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Provenance), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.provenance_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.provenance
    },
  )
}

pub fn questionnaire_create(
  resource: r4usp.Questionnaire,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Questionnaire, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.questionnaire_to_json(resource),
    "Questionnaire",
    r4usp.questionnaire_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaire_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Questionnaire, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Questionnaire",
    r4usp.questionnaire_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaire_update(
  resource: r4usp.Questionnaire,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Questionnaire, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.questionnaire_to_json(resource),
    "Questionnaire",
    r4usp.questionnaire_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaire_delete(
  resource: r4usp.Questionnaire,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Questionnaire", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn questionnaire_search_bundled(
  search_for search_args: r4usp_sansio.SpQuestionnaire,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.questionnaire_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn questionnaire_search(
  search_for search_args: r4usp_sansio.SpQuestionnaire,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Questionnaire), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.questionnaire_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.questionnaire
    },
  )
}

pub fn questionnaireresponse_create(
  resource: r4usp.Questionnaireresponse,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Questionnaireresponse, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    r4usp.questionnaireresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaireresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Questionnaireresponse, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "QuestionnaireResponse",
    r4usp.questionnaireresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaireresponse_update(
  resource: r4usp.Questionnaireresponse,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Questionnaireresponse, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    r4usp.questionnaireresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaireresponse_delete(
  resource: r4usp.Questionnaireresponse,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "QuestionnaireResponse", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn questionnaireresponse_search_bundled(
  search_for search_args: r4usp_sansio.SpQuestionnaireresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.questionnaireresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn questionnaireresponse_search(
  search_for search_args: r4usp_sansio.SpQuestionnaireresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Questionnaireresponse), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.questionnaireresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.questionnaireresponse
    },
  )
}

pub fn relatedperson_create(
  resource: r4usp.Relatedperson,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Relatedperson, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.relatedperson_to_json(resource),
    "RelatedPerson",
    r4usp.relatedperson_decoder(),
    client,
    handle_response,
  )
}

pub fn relatedperson_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Relatedperson, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "RelatedPerson",
    r4usp.relatedperson_decoder(),
    client,
    handle_response,
  )
}

pub fn relatedperson_update(
  resource: r4usp.Relatedperson,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Relatedperson, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.relatedperson_to_json(resource),
    "RelatedPerson",
    r4usp.relatedperson_decoder(),
    client,
    handle_response,
  )
}

pub fn relatedperson_delete(
  resource: r4usp.Relatedperson,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "RelatedPerson", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn relatedperson_search_bundled(
  search_for search_args: r4usp_sansio.SpRelatedperson,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.relatedperson_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn relatedperson_search(
  search_for search_args: r4usp_sansio.SpRelatedperson,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Relatedperson), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.relatedperson_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.relatedperson
    },
  )
}

pub fn requestgroup_create(
  resource: r4usp.Requestgroup,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Requestgroup, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.requestgroup_to_json(resource),
    "RequestGroup",
    r4usp.requestgroup_decoder(),
    client,
    handle_response,
  )
}

pub fn requestgroup_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Requestgroup, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "RequestGroup",
    r4usp.requestgroup_decoder(),
    client,
    handle_response,
  )
}

pub fn requestgroup_update(
  resource: r4usp.Requestgroup,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Requestgroup, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.requestgroup_to_json(resource),
    "RequestGroup",
    r4usp.requestgroup_decoder(),
    client,
    handle_response,
  )
}

pub fn requestgroup_delete(
  resource: r4usp.Requestgroup,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "RequestGroup", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn requestgroup_search_bundled(
  search_for search_args: r4usp_sansio.SpRequestgroup,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.requestgroup_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn requestgroup_search(
  search_for search_args: r4usp_sansio.SpRequestgroup,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Requestgroup), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.requestgroup_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.requestgroup
    },
  )
}

pub fn researchdefinition_create(
  resource: r4usp.Researchdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Researchdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.researchdefinition_to_json(resource),
    "ResearchDefinition",
    r4usp.researchdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn researchdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Researchdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ResearchDefinition",
    r4usp.researchdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn researchdefinition_update(
  resource: r4usp.Researchdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Researchdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.researchdefinition_to_json(resource),
    "ResearchDefinition",
    r4usp.researchdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn researchdefinition_delete(
  resource: r4usp.Researchdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "ResearchDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn researchdefinition_search_bundled(
  search_for search_args: r4usp_sansio.SpResearchdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.researchdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn researchdefinition_search(
  search_for search_args: r4usp_sansio.SpResearchdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Researchdefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.researchdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.researchdefinition
    },
  )
}

pub fn researchelementdefinition_create(
  resource: r4usp.Researchelementdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Researchelementdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.researchelementdefinition_to_json(resource),
    "ResearchElementDefinition",
    r4usp.researchelementdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn researchelementdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Researchelementdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ResearchElementDefinition",
    r4usp.researchelementdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn researchelementdefinition_update(
  resource: r4usp.Researchelementdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Researchelementdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.researchelementdefinition_to_json(resource),
    "ResearchElementDefinition",
    r4usp.researchelementdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn researchelementdefinition_delete(
  resource: r4usp.Researchelementdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "ResearchElementDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn researchelementdefinition_search_bundled(
  search_for search_args: r4usp_sansio.SpResearchelementdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.researchelementdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn researchelementdefinition_search(
  search_for search_args: r4usp_sansio.SpResearchelementdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Researchelementdefinition), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.researchelementdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.researchelementdefinition
    },
  )
}

pub fn researchstudy_create(
  resource: r4usp.Researchstudy,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Researchstudy, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.researchstudy_to_json(resource),
    "ResearchStudy",
    r4usp.researchstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn researchstudy_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Researchstudy, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ResearchStudy",
    r4usp.researchstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn researchstudy_update(
  resource: r4usp.Researchstudy,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Researchstudy, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.researchstudy_to_json(resource),
    "ResearchStudy",
    r4usp.researchstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn researchstudy_delete(
  resource: r4usp.Researchstudy,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "ResearchStudy", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn researchstudy_search_bundled(
  search_for search_args: r4usp_sansio.SpResearchstudy,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.researchstudy_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn researchstudy_search(
  search_for search_args: r4usp_sansio.SpResearchstudy,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Researchstudy), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.researchstudy_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.researchstudy
    },
  )
}

pub fn researchsubject_create(
  resource: r4usp.Researchsubject,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Researchsubject, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.researchsubject_to_json(resource),
    "ResearchSubject",
    r4usp.researchsubject_decoder(),
    client,
    handle_response,
  )
}

pub fn researchsubject_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Researchsubject, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ResearchSubject",
    r4usp.researchsubject_decoder(),
    client,
    handle_response,
  )
}

pub fn researchsubject_update(
  resource: r4usp.Researchsubject,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Researchsubject, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.researchsubject_to_json(resource),
    "ResearchSubject",
    r4usp.researchsubject_decoder(),
    client,
    handle_response,
  )
}

pub fn researchsubject_delete(
  resource: r4usp.Researchsubject,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "ResearchSubject", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn researchsubject_search_bundled(
  search_for search_args: r4usp_sansio.SpResearchsubject,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.researchsubject_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn researchsubject_search(
  search_for search_args: r4usp_sansio.SpResearchsubject,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Researchsubject), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.researchsubject_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.researchsubject
    },
  )
}

pub fn riskassessment_create(
  resource: r4usp.Riskassessment,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Riskassessment, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.riskassessment_to_json(resource),
    "RiskAssessment",
    r4usp.riskassessment_decoder(),
    client,
    handle_response,
  )
}

pub fn riskassessment_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Riskassessment, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "RiskAssessment",
    r4usp.riskassessment_decoder(),
    client,
    handle_response,
  )
}

pub fn riskassessment_update(
  resource: r4usp.Riskassessment,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Riskassessment, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.riskassessment_to_json(resource),
    "RiskAssessment",
    r4usp.riskassessment_decoder(),
    client,
    handle_response,
  )
}

pub fn riskassessment_delete(
  resource: r4usp.Riskassessment,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "RiskAssessment", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn riskassessment_search_bundled(
  search_for search_args: r4usp_sansio.SpRiskassessment,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.riskassessment_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn riskassessment_search(
  search_for search_args: r4usp_sansio.SpRiskassessment,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Riskassessment), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.riskassessment_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.riskassessment
    },
  )
}

pub fn riskevidencesynthesis_create(
  resource: r4usp.Riskevidencesynthesis,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Riskevidencesynthesis, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.riskevidencesynthesis_to_json(resource),
    "RiskEvidenceSynthesis",
    r4usp.riskevidencesynthesis_decoder(),
    client,
    handle_response,
  )
}

pub fn riskevidencesynthesis_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Riskevidencesynthesis, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "RiskEvidenceSynthesis",
    r4usp.riskevidencesynthesis_decoder(),
    client,
    handle_response,
  )
}

pub fn riskevidencesynthesis_update(
  resource: r4usp.Riskevidencesynthesis,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Riskevidencesynthesis, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.riskevidencesynthesis_to_json(resource),
    "RiskEvidenceSynthesis",
    r4usp.riskevidencesynthesis_decoder(),
    client,
    handle_response,
  )
}

pub fn riskevidencesynthesis_delete(
  resource: r4usp.Riskevidencesynthesis,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "RiskEvidenceSynthesis", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn riskevidencesynthesis_search_bundled(
  search_for search_args: r4usp_sansio.SpRiskevidencesynthesis,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.riskevidencesynthesis_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn riskevidencesynthesis_search(
  search_for search_args: r4usp_sansio.SpRiskevidencesynthesis,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Riskevidencesynthesis), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.riskevidencesynthesis_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.riskevidencesynthesis
    },
  )
}

pub fn schedule_create(
  resource: r4usp.Schedule,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Schedule, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.schedule_to_json(resource),
    "Schedule",
    r4usp.schedule_decoder(),
    client,
    handle_response,
  )
}

pub fn schedule_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Schedule, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Schedule", r4usp.schedule_decoder(), client, handle_response)
}

pub fn schedule_update(
  resource: r4usp.Schedule,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Schedule, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.schedule_to_json(resource),
    "Schedule",
    r4usp.schedule_decoder(),
    client,
    handle_response,
  )
}

pub fn schedule_delete(
  resource: r4usp.Schedule,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Schedule", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn schedule_search_bundled(
  search_for search_args: r4usp_sansio.SpSchedule,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.schedule_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn schedule_search(
  search_for search_args: r4usp_sansio.SpSchedule,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Schedule), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.schedule_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.schedule
    },
  )
}

pub fn searchparameter_create(
  resource: r4usp.Searchparameter,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Searchparameter, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.searchparameter_to_json(resource),
    "SearchParameter",
    r4usp.searchparameter_decoder(),
    client,
    handle_response,
  )
}

pub fn searchparameter_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Searchparameter, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SearchParameter",
    r4usp.searchparameter_decoder(),
    client,
    handle_response,
  )
}

pub fn searchparameter_update(
  resource: r4usp.Searchparameter,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Searchparameter, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.searchparameter_to_json(resource),
    "SearchParameter",
    r4usp.searchparameter_decoder(),
    client,
    handle_response,
  )
}

pub fn searchparameter_delete(
  resource: r4usp.Searchparameter,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "SearchParameter", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn searchparameter_search_bundled(
  search_for search_args: r4usp_sansio.SpSearchparameter,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.searchparameter_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn searchparameter_search(
  search_for search_args: r4usp_sansio.SpSearchparameter,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Searchparameter), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.searchparameter_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.searchparameter
    },
  )
}

pub fn servicerequest_create(
  resource: r4usp.Servicerequest,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Servicerequest, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.servicerequest_to_json(resource),
    "ServiceRequest",
    r4usp.servicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn servicerequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Servicerequest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ServiceRequest",
    r4usp.servicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn servicerequest_update(
  resource: r4usp.Servicerequest,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Servicerequest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.servicerequest_to_json(resource),
    "ServiceRequest",
    r4usp.servicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn servicerequest_delete(
  resource: r4usp.Servicerequest,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "ServiceRequest", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn servicerequest_search_bundled(
  search_for search_args: r4usp_sansio.SpServicerequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.servicerequest_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn servicerequest_search(
  search_for search_args: r4usp_sansio.SpServicerequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Servicerequest), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.servicerequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.servicerequest
    },
  )
}

pub fn slot_create(
  resource: r4usp.Slot,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Slot, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.slot_to_json(resource),
    "Slot",
    r4usp.slot_decoder(),
    client,
    handle_response,
  )
}

pub fn slot_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Slot, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Slot", r4usp.slot_decoder(), client, handle_response)
}

pub fn slot_update(
  resource: r4usp.Slot,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Slot, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.slot_to_json(resource),
    "Slot",
    r4usp.slot_decoder(),
    client,
    handle_response,
  )
}

pub fn slot_delete(
  resource: r4usp.Slot,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Slot", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn slot_search_bundled(
  search_for search_args: r4usp_sansio.SpSlot,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.slot_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn slot_search(
  search_for search_args: r4usp_sansio.SpSlot,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Slot), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.slot_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> r4usp_sansio.bundle_to_groupedresources }.slot },
  )
}

pub fn specimen_create(
  resource: r4usp.Specimen,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Specimen, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.specimen_to_json(resource),
    "Specimen",
    r4usp.specimen_decoder(),
    client,
    handle_response,
  )
}

pub fn specimen_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Specimen, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Specimen", r4usp.specimen_decoder(), client, handle_response)
}

pub fn specimen_update(
  resource: r4usp.Specimen,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Specimen, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.specimen_to_json(resource),
    "Specimen",
    r4usp.specimen_decoder(),
    client,
    handle_response,
  )
}

pub fn specimen_delete(
  resource: r4usp.Specimen,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Specimen", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn specimen_search_bundled(
  search_for search_args: r4usp_sansio.SpSpecimen,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.specimen_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn specimen_search(
  search_for search_args: r4usp_sansio.SpSpecimen,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Specimen), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.specimen_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.specimen
    },
  )
}

pub fn specimendefinition_create(
  resource: r4usp.Specimendefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Specimendefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.specimendefinition_to_json(resource),
    "SpecimenDefinition",
    r4usp.specimendefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn specimendefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Specimendefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SpecimenDefinition",
    r4usp.specimendefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn specimendefinition_update(
  resource: r4usp.Specimendefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Specimendefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.specimendefinition_to_json(resource),
    "SpecimenDefinition",
    r4usp.specimendefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn specimendefinition_delete(
  resource: r4usp.Specimendefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "SpecimenDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn specimendefinition_search_bundled(
  search_for search_args: r4usp_sansio.SpSpecimendefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.specimendefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn specimendefinition_search(
  search_for search_args: r4usp_sansio.SpSpecimendefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Specimendefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.specimendefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.specimendefinition
    },
  )
}

pub fn structuredefinition_create(
  resource: r4usp.Structuredefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Structuredefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.structuredefinition_to_json(resource),
    "StructureDefinition",
    r4usp.structuredefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn structuredefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Structuredefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "StructureDefinition",
    r4usp.structuredefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn structuredefinition_update(
  resource: r4usp.Structuredefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Structuredefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.structuredefinition_to_json(resource),
    "StructureDefinition",
    r4usp.structuredefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn structuredefinition_delete(
  resource: r4usp.Structuredefinition,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "StructureDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn structuredefinition_search_bundled(
  search_for search_args: r4usp_sansio.SpStructuredefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.structuredefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn structuredefinition_search(
  search_for search_args: r4usp_sansio.SpStructuredefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Structuredefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.structuredefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.structuredefinition
    },
  )
}

pub fn structuremap_create(
  resource: r4usp.Structuremap,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Structuremap, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.structuremap_to_json(resource),
    "StructureMap",
    r4usp.structuremap_decoder(),
    client,
    handle_response,
  )
}

pub fn structuremap_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Structuremap, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "StructureMap",
    r4usp.structuremap_decoder(),
    client,
    handle_response,
  )
}

pub fn structuremap_update(
  resource: r4usp.Structuremap,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Structuremap, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.structuremap_to_json(resource),
    "StructureMap",
    r4usp.structuremap_decoder(),
    client,
    handle_response,
  )
}

pub fn structuremap_delete(
  resource: r4usp.Structuremap,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "StructureMap", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn structuremap_search_bundled(
  search_for search_args: r4usp_sansio.SpStructuremap,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.structuremap_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn structuremap_search(
  search_for search_args: r4usp_sansio.SpStructuremap,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Structuremap), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.structuremap_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.structuremap
    },
  )
}

pub fn subscription_create(
  resource: r4usp.Subscription,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Subscription, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.subscription_to_json(resource),
    "Subscription",
    r4usp.subscription_decoder(),
    client,
    handle_response,
  )
}

pub fn subscription_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Subscription, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Subscription",
    r4usp.subscription_decoder(),
    client,
    handle_response,
  )
}

pub fn subscription_update(
  resource: r4usp.Subscription,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Subscription, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.subscription_to_json(resource),
    "Subscription",
    r4usp.subscription_decoder(),
    client,
    handle_response,
  )
}

pub fn subscription_delete(
  resource: r4usp.Subscription,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Subscription", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn subscription_search_bundled(
  search_for search_args: r4usp_sansio.SpSubscription,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.subscription_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn subscription_search(
  search_for search_args: r4usp_sansio.SpSubscription,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Subscription), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.subscription_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.subscription
    },
  )
}

pub fn substance_create(
  resource: r4usp.Substance,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Substance, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.substance_to_json(resource),
    "Substance",
    r4usp.substance_decoder(),
    client,
    handle_response,
  )
}

pub fn substance_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Substance, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Substance", r4usp.substance_decoder(), client, handle_response)
}

pub fn substance_update(
  resource: r4usp.Substance,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Substance, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.substance_to_json(resource),
    "Substance",
    r4usp.substance_decoder(),
    client,
    handle_response,
  )
}

pub fn substance_delete(
  resource: r4usp.Substance,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Substance", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn substance_search_bundled(
  search_for search_args: r4usp_sansio.SpSubstance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.substance_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn substance_search(
  search_for search_args: r4usp_sansio.SpSubstance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Substance), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.substance_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.substance
    },
  )
}

pub fn substancenucleicacid_create(
  resource: r4usp.Substancenucleicacid,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Substancenucleicacid, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.substancenucleicacid_to_json(resource),
    "SubstanceNucleicAcid",
    r4usp.substancenucleicacid_decoder(),
    client,
    handle_response,
  )
}

pub fn substancenucleicacid_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Substancenucleicacid, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstanceNucleicAcid",
    r4usp.substancenucleicacid_decoder(),
    client,
    handle_response,
  )
}

pub fn substancenucleicacid_update(
  resource: r4usp.Substancenucleicacid,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Substancenucleicacid, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.substancenucleicacid_to_json(resource),
    "SubstanceNucleicAcid",
    r4usp.substancenucleicacid_decoder(),
    client,
    handle_response,
  )
}

pub fn substancenucleicacid_delete(
  resource: r4usp.Substancenucleicacid,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "SubstanceNucleicAcid", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn substancenucleicacid_search_bundled(
  search_for search_args: r4usp_sansio.SpSubstancenucleicacid,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.substancenucleicacid_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn substancenucleicacid_search(
  search_for search_args: r4usp_sansio.SpSubstancenucleicacid,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Substancenucleicacid), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.substancenucleicacid_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.substancenucleicacid
    },
  )
}

pub fn substancepolymer_create(
  resource: r4usp.Substancepolymer,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Substancepolymer, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.substancepolymer_to_json(resource),
    "SubstancePolymer",
    r4usp.substancepolymer_decoder(),
    client,
    handle_response,
  )
}

pub fn substancepolymer_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Substancepolymer, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstancePolymer",
    r4usp.substancepolymer_decoder(),
    client,
    handle_response,
  )
}

pub fn substancepolymer_update(
  resource: r4usp.Substancepolymer,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Substancepolymer, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.substancepolymer_to_json(resource),
    "SubstancePolymer",
    r4usp.substancepolymer_decoder(),
    client,
    handle_response,
  )
}

pub fn substancepolymer_delete(
  resource: r4usp.Substancepolymer,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "SubstancePolymer", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn substancepolymer_search_bundled(
  search_for search_args: r4usp_sansio.SpSubstancepolymer,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.substancepolymer_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn substancepolymer_search(
  search_for search_args: r4usp_sansio.SpSubstancepolymer,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Substancepolymer), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.substancepolymer_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.substancepolymer
    },
  )
}

pub fn substanceprotein_create(
  resource: r4usp.Substanceprotein,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Substanceprotein, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.substanceprotein_to_json(resource),
    "SubstanceProtein",
    r4usp.substanceprotein_decoder(),
    client,
    handle_response,
  )
}

pub fn substanceprotein_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Substanceprotein, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstanceProtein",
    r4usp.substanceprotein_decoder(),
    client,
    handle_response,
  )
}

pub fn substanceprotein_update(
  resource: r4usp.Substanceprotein,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Substanceprotein, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.substanceprotein_to_json(resource),
    "SubstanceProtein",
    r4usp.substanceprotein_decoder(),
    client,
    handle_response,
  )
}

pub fn substanceprotein_delete(
  resource: r4usp.Substanceprotein,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "SubstanceProtein", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn substanceprotein_search_bundled(
  search_for search_args: r4usp_sansio.SpSubstanceprotein,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.substanceprotein_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn substanceprotein_search(
  search_for search_args: r4usp_sansio.SpSubstanceprotein,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Substanceprotein), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.substanceprotein_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.substanceprotein
    },
  )
}

pub fn substancereferenceinformation_create(
  resource: r4usp.Substancereferenceinformation,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Substancereferenceinformation, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.substancereferenceinformation_to_json(resource),
    "SubstanceReferenceInformation",
    r4usp.substancereferenceinformation_decoder(),
    client,
    handle_response,
  )
}

pub fn substancereferenceinformation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Substancereferenceinformation, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstanceReferenceInformation",
    r4usp.substancereferenceinformation_decoder(),
    client,
    handle_response,
  )
}

pub fn substancereferenceinformation_update(
  resource: r4usp.Substancereferenceinformation,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Substancereferenceinformation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.substancereferenceinformation_to_json(resource),
    "SubstanceReferenceInformation",
    r4usp.substancereferenceinformation_decoder(),
    client,
    handle_response,
  )
}

pub fn substancereferenceinformation_delete(
  resource: r4usp.Substancereferenceinformation,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(
        id,
        "SubstanceReferenceInformation",
        client,
        handle_response,
      ))
    None -> Error(ErrNoId)
  }
}

pub fn substancereferenceinformation_search_bundled(
  search_for search_args: r4usp_sansio.SpSubstancereferenceinformation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.substancereferenceinformation_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn substancereferenceinformation_search(
  search_for search_args: r4usp_sansio.SpSubstancereferenceinformation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Substancereferenceinformation), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4usp_sansio.substancereferenceinformation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.substancereferenceinformation
    },
  )
}

pub fn substancesourcematerial_create(
  resource: r4usp.Substancesourcematerial,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Substancesourcematerial, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.substancesourcematerial_to_json(resource),
    "SubstanceSourceMaterial",
    r4usp.substancesourcematerial_decoder(),
    client,
    handle_response,
  )
}

pub fn substancesourcematerial_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Substancesourcematerial, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstanceSourceMaterial",
    r4usp.substancesourcematerial_decoder(),
    client,
    handle_response,
  )
}

pub fn substancesourcematerial_update(
  resource: r4usp.Substancesourcematerial,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Substancesourcematerial, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.substancesourcematerial_to_json(resource),
    "SubstanceSourceMaterial",
    r4usp.substancesourcematerial_decoder(),
    client,
    handle_response,
  )
}

pub fn substancesourcematerial_delete(
  resource: r4usp.Substancesourcematerial,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "SubstanceSourceMaterial", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn substancesourcematerial_search_bundled(
  search_for search_args: r4usp_sansio.SpSubstancesourcematerial,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.substancesourcematerial_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn substancesourcematerial_search(
  search_for search_args: r4usp_sansio.SpSubstancesourcematerial,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Substancesourcematerial), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.substancesourcematerial_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.substancesourcematerial
    },
  )
}

pub fn substancespecification_create(
  resource: r4usp.Substancespecification,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Substancespecification, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.substancespecification_to_json(resource),
    "SubstanceSpecification",
    r4usp.substancespecification_decoder(),
    client,
    handle_response,
  )
}

pub fn substancespecification_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Substancespecification, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstanceSpecification",
    r4usp.substancespecification_decoder(),
    client,
    handle_response,
  )
}

pub fn substancespecification_update(
  resource: r4usp.Substancespecification,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Substancespecification, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.substancespecification_to_json(resource),
    "SubstanceSpecification",
    r4usp.substancespecification_decoder(),
    client,
    handle_response,
  )
}

pub fn substancespecification_delete(
  resource: r4usp.Substancespecification,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "SubstanceSpecification", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn substancespecification_search_bundled(
  search_for search_args: r4usp_sansio.SpSubstancespecification,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.substancespecification_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn substancespecification_search(
  search_for search_args: r4usp_sansio.SpSubstancespecification,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Substancespecification), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.substancespecification_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.substancespecification
    },
  )
}

pub fn supplydelivery_create(
  resource: r4usp.Supplydelivery,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Supplydelivery, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.supplydelivery_to_json(resource),
    "SupplyDelivery",
    r4usp.supplydelivery_decoder(),
    client,
    handle_response,
  )
}

pub fn supplydelivery_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Supplydelivery, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SupplyDelivery",
    r4usp.supplydelivery_decoder(),
    client,
    handle_response,
  )
}

pub fn supplydelivery_update(
  resource: r4usp.Supplydelivery,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Supplydelivery, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.supplydelivery_to_json(resource),
    "SupplyDelivery",
    r4usp.supplydelivery_decoder(),
    client,
    handle_response,
  )
}

pub fn supplydelivery_delete(
  resource: r4usp.Supplydelivery,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "SupplyDelivery", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn supplydelivery_search_bundled(
  search_for search_args: r4usp_sansio.SpSupplydelivery,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.supplydelivery_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn supplydelivery_search(
  search_for search_args: r4usp_sansio.SpSupplydelivery,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Supplydelivery), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.supplydelivery_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.supplydelivery
    },
  )
}

pub fn supplyrequest_create(
  resource: r4usp.Supplyrequest,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Supplyrequest, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.supplyrequest_to_json(resource),
    "SupplyRequest",
    r4usp.supplyrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn supplyrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Supplyrequest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SupplyRequest",
    r4usp.supplyrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn supplyrequest_update(
  resource: r4usp.Supplyrequest,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Supplyrequest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.supplyrequest_to_json(resource),
    "SupplyRequest",
    r4usp.supplyrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn supplyrequest_delete(
  resource: r4usp.Supplyrequest,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "SupplyRequest", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn supplyrequest_search_bundled(
  search_for search_args: r4usp_sansio.SpSupplyrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.supplyrequest_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn supplyrequest_search(
  search_for search_args: r4usp_sansio.SpSupplyrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Supplyrequest), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.supplyrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.supplyrequest
    },
  )
}

pub fn task_create(
  resource: r4usp.Task,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Task, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.task_to_json(resource),
    "Task",
    r4usp.task_decoder(),
    client,
    handle_response,
  )
}

pub fn task_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Task, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Task", r4usp.task_decoder(), client, handle_response)
}

pub fn task_update(
  resource: r4usp.Task,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Task, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.task_to_json(resource),
    "Task",
    r4usp.task_decoder(),
    client,
    handle_response,
  )
}

pub fn task_delete(
  resource: r4usp.Task,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Task", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn task_search_bundled(
  search_for search_args: r4usp_sansio.SpTask,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.task_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn task_search(
  search_for search_args: r4usp_sansio.SpTask,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Task), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.task_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> r4usp_sansio.bundle_to_groupedresources }.task },
  )
}

pub fn terminologycapabilities_create(
  resource: r4usp.Terminologycapabilities,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Terminologycapabilities, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.terminologycapabilities_to_json(resource),
    "TerminologyCapabilities",
    r4usp.terminologycapabilities_decoder(),
    client,
    handle_response,
  )
}

pub fn terminologycapabilities_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Terminologycapabilities, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "TerminologyCapabilities",
    r4usp.terminologycapabilities_decoder(),
    client,
    handle_response,
  )
}

pub fn terminologycapabilities_update(
  resource: r4usp.Terminologycapabilities,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Terminologycapabilities, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.terminologycapabilities_to_json(resource),
    "TerminologyCapabilities",
    r4usp.terminologycapabilities_decoder(),
    client,
    handle_response,
  )
}

pub fn terminologycapabilities_delete(
  resource: r4usp.Terminologycapabilities,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "TerminologyCapabilities", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn terminologycapabilities_search_bundled(
  search_for search_args: r4usp_sansio.SpTerminologycapabilities,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.terminologycapabilities_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn terminologycapabilities_search(
  search_for search_args: r4usp_sansio.SpTerminologycapabilities,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4usp.Terminologycapabilities), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.terminologycapabilities_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.terminologycapabilities
    },
  )
}

pub fn testreport_create(
  resource: r4usp.Testreport,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Testreport, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.testreport_to_json(resource),
    "TestReport",
    r4usp.testreport_decoder(),
    client,
    handle_response,
  )
}

pub fn testreport_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Testreport, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "TestReport",
    r4usp.testreport_decoder(),
    client,
    handle_response,
  )
}

pub fn testreport_update(
  resource: r4usp.Testreport,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Testreport, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.testreport_to_json(resource),
    "TestReport",
    r4usp.testreport_decoder(),
    client,
    handle_response,
  )
}

pub fn testreport_delete(
  resource: r4usp.Testreport,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "TestReport", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn testreport_search_bundled(
  search_for search_args: r4usp_sansio.SpTestreport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.testreport_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn testreport_search(
  search_for search_args: r4usp_sansio.SpTestreport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Testreport), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.testreport_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.testreport
    },
  )
}

pub fn testscript_create(
  resource: r4usp.Testscript,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Testscript, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.testscript_to_json(resource),
    "TestScript",
    r4usp.testscript_decoder(),
    client,
    handle_response,
  )
}

pub fn testscript_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Testscript, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "TestScript",
    r4usp.testscript_decoder(),
    client,
    handle_response,
  )
}

pub fn testscript_update(
  resource: r4usp.Testscript,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Testscript, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.testscript_to_json(resource),
    "TestScript",
    r4usp.testscript_decoder(),
    client,
    handle_response,
  )
}

pub fn testscript_delete(
  resource: r4usp.Testscript,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "TestScript", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn testscript_search_bundled(
  search_for search_args: r4usp_sansio.SpTestscript,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.testscript_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn testscript_search(
  search_for search_args: r4usp_sansio.SpTestscript,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Testscript), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.testscript_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.testscript
    },
  )
}

pub fn valueset_create(
  resource: r4usp.Valueset,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Valueset, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.valueset_to_json(resource),
    "ValueSet",
    r4usp.valueset_decoder(),
    client,
    handle_response,
  )
}

pub fn valueset_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Valueset, Err)) -> a,
) -> Effect(a) {
  any_read(id, "ValueSet", r4usp.valueset_decoder(), client, handle_response)
}

pub fn valueset_update(
  resource: r4usp.Valueset,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Valueset, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.valueset_to_json(resource),
    "ValueSet",
    r4usp.valueset_decoder(),
    client,
    handle_response,
  )
}

pub fn valueset_delete(
  resource: r4usp.Valueset,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "ValueSet", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn valueset_search_bundled(
  search_for search_args: r4usp_sansio.SpValueset,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.valueset_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn valueset_search(
  search_for search_args: r4usp_sansio.SpValueset,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Valueset), Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.valueset_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.valueset
    },
  )
}

pub fn verificationresult_create(
  resource: r4usp.Verificationresult,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Verificationresult, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.verificationresult_to_json(resource),
    "VerificationResult",
    r4usp.verificationresult_decoder(),
    client,
    handle_response,
  )
}

pub fn verificationresult_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Verificationresult, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "VerificationResult",
    r4usp.verificationresult_decoder(),
    client,
    handle_response,
  )
}

pub fn verificationresult_update(
  resource: r4usp.Verificationresult,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Verificationresult, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.verificationresult_to_json(resource),
    "VerificationResult",
    r4usp.verificationresult_decoder(),
    client,
    handle_response,
  )
}

pub fn verificationresult_delete(
  resource: r4usp.Verificationresult,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "VerificationResult", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn verificationresult_search_bundled(
  search_for search_args: r4usp_sansio.SpVerificationresult,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.verificationresult_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn verificationresult_search(
  search_for search_args: r4usp_sansio.SpVerificationresult,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Verificationresult), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.verificationresult_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.verificationresult
    },
  )
}

pub fn visionprescription_create(
  resource: r4usp.Visionprescription,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Visionprescription, Err)) -> a,
) -> Effect(a) {
  any_create(
    r4usp.visionprescription_to_json(resource),
    "VisionPrescription",
    r4usp.visionprescription_decoder(),
    client,
    handle_response,
  )
}

pub fn visionprescription_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Visionprescription, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "VisionPrescription",
    r4usp.visionprescription_decoder(),
    client,
    handle_response,
  )
}

pub fn visionprescription_update(
  resource: r4usp.Visionprescription,
  client: FhirClient,
  handle_response: fn(Result(r4usp.Visionprescription, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4usp.visionprescription_to_json(resource),
    "VisionPrescription",
    r4usp.visionprescription_decoder(),
    client,
    handle_response,
  )
}

pub fn visionprescription_delete(
  resource: r4usp.Visionprescription,
  client: FhirClient,
  handle_response: fn(Result(r4usp_sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "VisionPrescription", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn visionprescription_search_bundled(
  search_for search_args: r4usp_sansio.SpVisionprescription,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4usp.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = r4usp_sansio.visionprescription_search_req(search_args, client)
  sendreq_handleresponse(req, r4usp.bundle_decoder(), "Bundle", handle_response)
}

pub fn visionprescription_search(
  search_for search_args: r4usp_sansio.SpVisionprescription,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4usp.Visionprescription), Err)) ->
    msg,
) -> Effect(msg) {
  let req = r4usp_sansio.visionprescription_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4usp.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> r4usp_sansio.bundle_to_groupedresources }.visionprescription
    },
  )
}
