////[https://hl7.org/fhir/r5](https://hl7.org/fhir/r5) r5 client using rsvp

import fhir/r5/resources
import fhir/r5/sansio
import gleam/dynamic/decode.{type Decoder}
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/json.{type Json}
import gleam/option.{type Option, None, Some}
import lustre/effect.{type Effect}
import rsvp

/// FHIR client for sending http requests to server such as
/// `let read_pat_effect = fhirclient_rsvp.patient_read("123", client, msg)`
///
/// create client from server base url with fhirclient_new(baseurl)`
///
/// `let assert Ok(client) = fhirclient_rsvp.fhirclient_new("r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = fhirclient_rsvp.fhirclient_new("https://r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = fhirclient_rsvp.fhirclient_new("https://hapi.fhir.org/baseR4")`
///
/// `let assert Ok(client) = fhirclient_rsvp.fhirclient_new("127.0.0.1:8000")`
pub type FhirClient =
  sansio.FhirClient

/// creates a new client from server base url
///
/// `let assert Ok(client) = fhirclient_rsvp.fhirclient_new("r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = fhirclient_rsvp.fhirclient_new("https://r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = fhirclient_rsvp.fhirclient_new("https://hapi.fhir.org/baseR4")`
///
/// `let assert Ok(client) = fhirclient_rsvp.fhirclient_new("127.0.0.1:8000")`
pub fn fhirclient_new(baseurl: String) -> Result(FhirClient, sansio.ErrBaseUrl) {
  sansio.fhirclient_new(baseurl)
}

pub type Err {
  ErrRsvp(err: rsvp.Error)
  ErrSansio(err: sansio.ErrResp)
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
  let req = sansio.any_create_req(resource, res_type, client)
  sendreq_handleresponse(req, resource_dec, res_type, handle_response)
}

fn any_read(
  id: String,
  res_type: String,
  resource_dec: Decoder(r),
  client: FhirClient,
  handle_response: fn(Result(r, Err)) -> a,
) -> Effect(a) {
  let req = sansio.any_read_req(id, res_type, client)
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
  let req = sansio.any_update_req(id, resource, res_type, client)
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
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Effect(a) {
  let req = sansio.any_delete_req(id, res_type, client)
  let handle_read = fn(resp_res: Result(Response(String), rsvp.Error)) {
    handle_response(case resp_res {
      Error(err) -> Error(ErrRsvp(err))
      Ok(resp) ->
        case sansio.http_or_operationoutcome_resp(resp) {
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
  handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.any_search_req(search_string, res_type, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

// run any operation string on any resource string, optionally using Parameters
pub fn operation_any(
  params params: Option(resources.Parameters),
  operation_name operation_name: String,
  res_type res_type: String,
  res_id res_id: Option(String),
  res_decoder res_decoder: Decoder(res),
  return_res_type return_res_type: String,
  client client: FhirClient,
  handle_response handle_response: fn(Result(res, Err)) -> msg,
) -> Effect(msg) {
  let req =
    sansio.any_operation_req(res_type, res_id, operation_name, params, client)
  sendreq_handleresponse(req, res_decoder, return_res_type, handle_response)
}

pub fn batch(
  reqs: List(Request(Option(Json))),
  bundle_type: sansio.PostBundleType,
  client: FhirClient,
  handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.batch_req(reqs, bundle_type, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
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
        case sansio.any_resp(resp_res, res_dec, res_type) {
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
  resource: resources.Account,
  client: FhirClient,
  handle_response: fn(Result(resources.Account, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.account_to_json(resource),
    "Account",
    resources.account_decoder(),
    client,
    handle_response,
  )
}

pub fn account_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Account, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Account", resources.account_decoder(), client, handle_response)
}

pub fn account_update(
  resource: resources.Account,
  client: FhirClient,
  handle_response: fn(Result(resources.Account, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.account_to_json(resource),
    "Account",
    resources.account_decoder(),
    client,
    handle_response,
  )
}

pub fn account_delete(
  resource: resources.Account,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Account", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn account_search_bundled(
  search_for search_args: sansio.SpAccount,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.account_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn account_search(
  search_for search_args: sansio.SpAccount,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Account), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.account_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.account },
  )
}

pub fn activitydefinition_create(
  resource: resources.Activitydefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Activitydefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.activitydefinition_to_json(resource),
    "ActivityDefinition",
    resources.activitydefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn activitydefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Activitydefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ActivityDefinition",
    resources.activitydefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn activitydefinition_update(
  resource: resources.Activitydefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Activitydefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.activitydefinition_to_json(resource),
    "ActivityDefinition",
    resources.activitydefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn activitydefinition_delete(
  resource: resources.Activitydefinition,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "ActivityDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn activitydefinition_search_bundled(
  search_for search_args: sansio.SpActivitydefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.activitydefinition_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn activitydefinition_search(
  search_for search_args: sansio.SpActivitydefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Activitydefinition), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.activitydefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.activitydefinition
    },
  )
}

pub fn actordefinition_create(
  resource: resources.Actordefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Actordefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.actordefinition_to_json(resource),
    "ActorDefinition",
    resources.actordefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn actordefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Actordefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ActorDefinition",
    resources.actordefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn actordefinition_update(
  resource: resources.Actordefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Actordefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.actordefinition_to_json(resource),
    "ActorDefinition",
    resources.actordefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn actordefinition_delete(
  resource: resources.Actordefinition,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "ActorDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn actordefinition_search_bundled(
  search_for search_args: sansio.SpActordefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.actordefinition_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn actordefinition_search(
  search_for search_args: sansio.SpActordefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Actordefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.actordefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.actordefinition
    },
  )
}

pub fn administrableproductdefinition_create(
  resource: resources.Administrableproductdefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Administrableproductdefinition, Err)) ->
    a,
) -> Effect(a) {
  any_create(
    resources.administrableproductdefinition_to_json(resource),
    "AdministrableProductDefinition",
    resources.administrableproductdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn administrableproductdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Administrableproductdefinition, Err)) ->
    a,
) -> Effect(a) {
  any_read(
    id,
    "AdministrableProductDefinition",
    resources.administrableproductdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn administrableproductdefinition_update(
  resource: resources.Administrableproductdefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Administrableproductdefinition, Err)) ->
    a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.administrableproductdefinition_to_json(resource),
    "AdministrableProductDefinition",
    resources.administrableproductdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn administrableproductdefinition_delete(
  resource: resources.Administrableproductdefinition,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(
        id,
        "AdministrableProductDefinition",
        client,
        handle_response,
      ))
    None -> Error(ErrNoId)
  }
}

pub fn administrableproductdefinition_search_bundled(
  search_for search_args: sansio.SpAdministrableproductdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    sansio.administrableproductdefinition_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn administrableproductdefinition_search(
  search_for search_args: sansio.SpAdministrableproductdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Administrableproductdefinition), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    sansio.administrableproductdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.administrableproductdefinition
    },
  )
}

pub fn adverseevent_create(
  resource: resources.Adverseevent,
  client: FhirClient,
  handle_response: fn(Result(resources.Adverseevent, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.adverseevent_to_json(resource),
    "AdverseEvent",
    resources.adverseevent_decoder(),
    client,
    handle_response,
  )
}

pub fn adverseevent_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Adverseevent, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "AdverseEvent",
    resources.adverseevent_decoder(),
    client,
    handle_response,
  )
}

pub fn adverseevent_update(
  resource: resources.Adverseevent,
  client: FhirClient,
  handle_response: fn(Result(resources.Adverseevent, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.adverseevent_to_json(resource),
    "AdverseEvent",
    resources.adverseevent_decoder(),
    client,
    handle_response,
  )
}

pub fn adverseevent_delete(
  resource: resources.Adverseevent,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "AdverseEvent", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn adverseevent_search_bundled(
  search_for search_args: sansio.SpAdverseevent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.adverseevent_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn adverseevent_search(
  search_for search_args: sansio.SpAdverseevent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Adverseevent), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.adverseevent_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.adverseevent },
  )
}

pub fn allergyintolerance_create(
  resource: resources.Allergyintolerance,
  client: FhirClient,
  handle_response: fn(Result(resources.Allergyintolerance, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    resources.allergyintolerance_decoder(),
    client,
    handle_response,
  )
}

pub fn allergyintolerance_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Allergyintolerance, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "AllergyIntolerance",
    resources.allergyintolerance_decoder(),
    client,
    handle_response,
  )
}

pub fn allergyintolerance_update(
  resource: resources.Allergyintolerance,
  client: FhirClient,
  handle_response: fn(Result(resources.Allergyintolerance, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    resources.allergyintolerance_decoder(),
    client,
    handle_response,
  )
}

pub fn allergyintolerance_delete(
  resource: resources.Allergyintolerance,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "AllergyIntolerance", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn allergyintolerance_search_bundled(
  search_for search_args: sansio.SpAllergyintolerance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.allergyintolerance_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn allergyintolerance_search(
  search_for search_args: sansio.SpAllergyintolerance,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Allergyintolerance), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.allergyintolerance_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.allergyintolerance
    },
  )
}

pub fn appointment_create(
  resource: resources.Appointment,
  client: FhirClient,
  handle_response: fn(Result(resources.Appointment, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.appointment_to_json(resource),
    "Appointment",
    resources.appointment_decoder(),
    client,
    handle_response,
  )
}

pub fn appointment_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Appointment, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Appointment",
    resources.appointment_decoder(),
    client,
    handle_response,
  )
}

pub fn appointment_update(
  resource: resources.Appointment,
  client: FhirClient,
  handle_response: fn(Result(resources.Appointment, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.appointment_to_json(resource),
    "Appointment",
    resources.appointment_decoder(),
    client,
    handle_response,
  )
}

pub fn appointment_delete(
  resource: resources.Appointment,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Appointment", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn appointment_search_bundled(
  search_for search_args: sansio.SpAppointment,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.appointment_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn appointment_search(
  search_for search_args: sansio.SpAppointment,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Appointment), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.appointment_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.appointment },
  )
}

pub fn appointmentresponse_create(
  resource: resources.Appointmentresponse,
  client: FhirClient,
  handle_response: fn(Result(resources.Appointmentresponse, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.appointmentresponse_to_json(resource),
    "AppointmentResponse",
    resources.appointmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn appointmentresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Appointmentresponse, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "AppointmentResponse",
    resources.appointmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn appointmentresponse_update(
  resource: resources.Appointmentresponse,
  client: FhirClient,
  handle_response: fn(Result(resources.Appointmentresponse, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.appointmentresponse_to_json(resource),
    "AppointmentResponse",
    resources.appointmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn appointmentresponse_delete(
  resource: resources.Appointmentresponse,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "AppointmentResponse", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn appointmentresponse_search_bundled(
  search_for search_args: sansio.SpAppointmentresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.appointmentresponse_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn appointmentresponse_search(
  search_for search_args: sansio.SpAppointmentresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Appointmentresponse), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.appointmentresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.appointmentresponse
    },
  )
}

pub fn artifactassessment_create(
  resource: resources.Artifactassessment,
  client: FhirClient,
  handle_response: fn(Result(resources.Artifactassessment, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.artifactassessment_to_json(resource),
    "ArtifactAssessment",
    resources.artifactassessment_decoder(),
    client,
    handle_response,
  )
}

pub fn artifactassessment_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Artifactassessment, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ArtifactAssessment",
    resources.artifactassessment_decoder(),
    client,
    handle_response,
  )
}

pub fn artifactassessment_update(
  resource: resources.Artifactassessment,
  client: FhirClient,
  handle_response: fn(Result(resources.Artifactassessment, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.artifactassessment_to_json(resource),
    "ArtifactAssessment",
    resources.artifactassessment_decoder(),
    client,
    handle_response,
  )
}

pub fn artifactassessment_delete(
  resource: resources.Artifactassessment,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "ArtifactAssessment", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn artifactassessment_search_bundled(
  search_for search_args: sansio.SpArtifactassessment,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.artifactassessment_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn artifactassessment_search(
  search_for search_args: sansio.SpArtifactassessment,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Artifactassessment), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.artifactassessment_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.artifactassessment
    },
  )
}

pub fn auditevent_create(
  resource: resources.Auditevent,
  client: FhirClient,
  handle_response: fn(Result(resources.Auditevent, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.auditevent_to_json(resource),
    "AuditEvent",
    resources.auditevent_decoder(),
    client,
    handle_response,
  )
}

pub fn auditevent_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Auditevent, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "AuditEvent",
    resources.auditevent_decoder(),
    client,
    handle_response,
  )
}

pub fn auditevent_update(
  resource: resources.Auditevent,
  client: FhirClient,
  handle_response: fn(Result(resources.Auditevent, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.auditevent_to_json(resource),
    "AuditEvent",
    resources.auditevent_decoder(),
    client,
    handle_response,
  )
}

pub fn auditevent_delete(
  resource: resources.Auditevent,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "AuditEvent", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn auditevent_search_bundled(
  search_for search_args: sansio.SpAuditevent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.auditevent_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn auditevent_search(
  search_for search_args: sansio.SpAuditevent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Auditevent), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.auditevent_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.auditevent },
  )
}

pub fn basic_create(
  resource: resources.Basic,
  client: FhirClient,
  handle_response: fn(Result(resources.Basic, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.basic_to_json(resource),
    "Basic",
    resources.basic_decoder(),
    client,
    handle_response,
  )
}

pub fn basic_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Basic, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Basic", resources.basic_decoder(), client, handle_response)
}

pub fn basic_update(
  resource: resources.Basic,
  client: FhirClient,
  handle_response: fn(Result(resources.Basic, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.basic_to_json(resource),
    "Basic",
    resources.basic_decoder(),
    client,
    handle_response,
  )
}

pub fn basic_delete(
  resource: resources.Basic,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Basic", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn basic_search_bundled(
  search_for search_args: sansio.SpBasic,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.basic_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn basic_search(
  search_for search_args: sansio.SpBasic,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Basic), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.basic_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.basic },
  )
}

pub fn binary_create(
  resource: resources.Binary,
  client: FhirClient,
  handle_response: fn(Result(resources.Binary, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.binary_to_json(resource),
    "Binary",
    resources.binary_decoder(),
    client,
    handle_response,
  )
}

pub fn binary_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Binary, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Binary", resources.binary_decoder(), client, handle_response)
}

pub fn binary_update(
  resource: resources.Binary,
  client: FhirClient,
  handle_response: fn(Result(resources.Binary, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.binary_to_json(resource),
    "Binary",
    resources.binary_decoder(),
    client,
    handle_response,
  )
}

pub fn binary_delete(
  resource: resources.Binary,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Binary", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn binary_search_bundled(
  search_for search_args: sansio.SpBinary,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.binary_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn binary_search(
  search_for search_args: sansio.SpBinary,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Binary), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.binary_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.binary },
  )
}

pub fn biologicallyderivedproduct_create(
  resource: resources.Biologicallyderivedproduct,
  client: FhirClient,
  handle_response: fn(Result(resources.Biologicallyderivedproduct, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.biologicallyderivedproduct_to_json(resource),
    "BiologicallyDerivedProduct",
    resources.biologicallyderivedproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn biologicallyderivedproduct_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Biologicallyderivedproduct, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "BiologicallyDerivedProduct",
    resources.biologicallyderivedproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn biologicallyderivedproduct_update(
  resource: resources.Biologicallyderivedproduct,
  client: FhirClient,
  handle_response: fn(Result(resources.Biologicallyderivedproduct, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.biologicallyderivedproduct_to_json(resource),
    "BiologicallyDerivedProduct",
    resources.biologicallyderivedproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn biologicallyderivedproduct_delete(
  resource: resources.Biologicallyderivedproduct,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "BiologicallyDerivedProduct", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn biologicallyderivedproduct_search_bundled(
  search_for search_args: sansio.SpBiologicallyderivedproduct,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.biologicallyderivedproduct_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn biologicallyderivedproduct_search(
  search_for search_args: sansio.SpBiologicallyderivedproduct,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Biologicallyderivedproduct), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.biologicallyderivedproduct_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.biologicallyderivedproduct
    },
  )
}

pub fn biologicallyderivedproductdispense_create(
  resource: resources.Biologicallyderivedproductdispense,
  client: FhirClient,
  handle_response: fn(Result(resources.Biologicallyderivedproductdispense, Err)) ->
    a,
) -> Effect(a) {
  any_create(
    resources.biologicallyderivedproductdispense_to_json(resource),
    "BiologicallyDerivedProductDispense",
    resources.biologicallyderivedproductdispense_decoder(),
    client,
    handle_response,
  )
}

pub fn biologicallyderivedproductdispense_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Biologicallyderivedproductdispense, Err)) ->
    a,
) -> Effect(a) {
  any_read(
    id,
    "BiologicallyDerivedProductDispense",
    resources.biologicallyderivedproductdispense_decoder(),
    client,
    handle_response,
  )
}

pub fn biologicallyderivedproductdispense_update(
  resource: resources.Biologicallyderivedproductdispense,
  client: FhirClient,
  handle_response: fn(Result(resources.Biologicallyderivedproductdispense, Err)) ->
    a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.biologicallyderivedproductdispense_to_json(resource),
    "BiologicallyDerivedProductDispense",
    resources.biologicallyderivedproductdispense_decoder(),
    client,
    handle_response,
  )
}

pub fn biologicallyderivedproductdispense_delete(
  resource: resources.Biologicallyderivedproductdispense,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(
        id,
        "BiologicallyDerivedProductDispense",
        client,
        handle_response,
      ))
    None -> Error(ErrNoId)
  }
}

pub fn biologicallyderivedproductdispense_search_bundled(
  search_for search_args: sansio.SpBiologicallyderivedproductdispense,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req =
    sansio.biologicallyderivedproductdispense_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn biologicallyderivedproductdispense_search(
  search_for search_args: sansio.SpBiologicallyderivedproductdispense,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Biologicallyderivedproductdispense), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    sansio.biologicallyderivedproductdispense_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.biologicallyderivedproductdispense
    },
  )
}

pub fn bodystructure_create(
  resource: resources.Bodystructure,
  client: FhirClient,
  handle_response: fn(Result(resources.Bodystructure, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.bodystructure_to_json(resource),
    "BodyStructure",
    resources.bodystructure_decoder(),
    client,
    handle_response,
  )
}

pub fn bodystructure_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Bodystructure, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "BodyStructure",
    resources.bodystructure_decoder(),
    client,
    handle_response,
  )
}

pub fn bodystructure_update(
  resource: resources.Bodystructure,
  client: FhirClient,
  handle_response: fn(Result(resources.Bodystructure, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.bodystructure_to_json(resource),
    "BodyStructure",
    resources.bodystructure_decoder(),
    client,
    handle_response,
  )
}

pub fn bodystructure_delete(
  resource: resources.Bodystructure,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "BodyStructure", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn bodystructure_search_bundled(
  search_for search_args: sansio.SpBodystructure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.bodystructure_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn bodystructure_search(
  search_for search_args: sansio.SpBodystructure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Bodystructure), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.bodystructure_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.bodystructure },
  )
}

pub fn bundle_create(
  resource: resources.Bundle,
  client: FhirClient,
  handle_response: fn(Result(resources.Bundle, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.bundle_to_json(resource),
    "Bundle",
    resources.bundle_decoder(),
    client,
    handle_response,
  )
}

pub fn bundle_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Bundle, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Bundle", resources.bundle_decoder(), client, handle_response)
}

pub fn bundle_update(
  resource: resources.Bundle,
  client: FhirClient,
  handle_response: fn(Result(resources.Bundle, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.bundle_to_json(resource),
    "Bundle",
    resources.bundle_decoder(),
    client,
    handle_response,
  )
}

pub fn bundle_delete(
  resource: resources.Bundle,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Bundle", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn bundle_search_bundled(
  search_for search_args: sansio.SpBundle,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.bundle_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn bundle_search(
  search_for search_args: sansio.SpBundle,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Bundle), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.bundle_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.bundle },
  )
}

pub fn capabilitystatement_create(
  resource: resources.Capabilitystatement,
  client: FhirClient,
  handle_response: fn(Result(resources.Capabilitystatement, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.capabilitystatement_to_json(resource),
    "CapabilityStatement",
    resources.capabilitystatement_decoder(),
    client,
    handle_response,
  )
}

pub fn capabilitystatement_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Capabilitystatement, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CapabilityStatement",
    resources.capabilitystatement_decoder(),
    client,
    handle_response,
  )
}

pub fn capabilitystatement_update(
  resource: resources.Capabilitystatement,
  client: FhirClient,
  handle_response: fn(Result(resources.Capabilitystatement, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.capabilitystatement_to_json(resource),
    "CapabilityStatement",
    resources.capabilitystatement_decoder(),
    client,
    handle_response,
  )
}

pub fn capabilitystatement_delete(
  resource: resources.Capabilitystatement,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "CapabilityStatement", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn capabilitystatement_search_bundled(
  search_for search_args: sansio.SpCapabilitystatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.capabilitystatement_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn capabilitystatement_search(
  search_for search_args: sansio.SpCapabilitystatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Capabilitystatement), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.capabilitystatement_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.capabilitystatement
    },
  )
}

pub fn careplan_create(
  resource: resources.Careplan,
  client: FhirClient,
  handle_response: fn(Result(resources.Careplan, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.careplan_to_json(resource),
    "CarePlan",
    resources.careplan_decoder(),
    client,
    handle_response,
  )
}

pub fn careplan_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Careplan, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CarePlan",
    resources.careplan_decoder(),
    client,
    handle_response,
  )
}

pub fn careplan_update(
  resource: resources.Careplan,
  client: FhirClient,
  handle_response: fn(Result(resources.Careplan, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.careplan_to_json(resource),
    "CarePlan",
    resources.careplan_decoder(),
    client,
    handle_response,
  )
}

pub fn careplan_delete(
  resource: resources.Careplan,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "CarePlan", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn careplan_search_bundled(
  search_for search_args: sansio.SpCareplan,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.careplan_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn careplan_search(
  search_for search_args: sansio.SpCareplan,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Careplan), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.careplan_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.careplan },
  )
}

pub fn careteam_create(
  resource: resources.Careteam,
  client: FhirClient,
  handle_response: fn(Result(resources.Careteam, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.careteam_to_json(resource),
    "CareTeam",
    resources.careteam_decoder(),
    client,
    handle_response,
  )
}

pub fn careteam_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Careteam, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CareTeam",
    resources.careteam_decoder(),
    client,
    handle_response,
  )
}

pub fn careteam_update(
  resource: resources.Careteam,
  client: FhirClient,
  handle_response: fn(Result(resources.Careteam, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.careteam_to_json(resource),
    "CareTeam",
    resources.careteam_decoder(),
    client,
    handle_response,
  )
}

pub fn careteam_delete(
  resource: resources.Careteam,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "CareTeam", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn careteam_search_bundled(
  search_for search_args: sansio.SpCareteam,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.careteam_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn careteam_search(
  search_for search_args: sansio.SpCareteam,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Careteam), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.careteam_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.careteam },
  )
}

pub fn chargeitem_create(
  resource: resources.Chargeitem,
  client: FhirClient,
  handle_response: fn(Result(resources.Chargeitem, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.chargeitem_to_json(resource),
    "ChargeItem",
    resources.chargeitem_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitem_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Chargeitem, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ChargeItem",
    resources.chargeitem_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitem_update(
  resource: resources.Chargeitem,
  client: FhirClient,
  handle_response: fn(Result(resources.Chargeitem, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.chargeitem_to_json(resource),
    "ChargeItem",
    resources.chargeitem_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitem_delete(
  resource: resources.Chargeitem,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "ChargeItem", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn chargeitem_search_bundled(
  search_for search_args: sansio.SpChargeitem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.chargeitem_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn chargeitem_search(
  search_for search_args: sansio.SpChargeitem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Chargeitem), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.chargeitem_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.chargeitem },
  )
}

pub fn chargeitemdefinition_create(
  resource: resources.Chargeitemdefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Chargeitemdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.chargeitemdefinition_to_json(resource),
    "ChargeItemDefinition",
    resources.chargeitemdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitemdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Chargeitemdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ChargeItemDefinition",
    resources.chargeitemdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitemdefinition_update(
  resource: resources.Chargeitemdefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Chargeitemdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.chargeitemdefinition_to_json(resource),
    "ChargeItemDefinition",
    resources.chargeitemdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitemdefinition_delete(
  resource: resources.Chargeitemdefinition,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "ChargeItemDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn chargeitemdefinition_search_bundled(
  search_for search_args: sansio.SpChargeitemdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.chargeitemdefinition_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn chargeitemdefinition_search(
  search_for search_args: sansio.SpChargeitemdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Chargeitemdefinition), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.chargeitemdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.chargeitemdefinition
    },
  )
}

pub fn citation_create(
  resource: resources.Citation,
  client: FhirClient,
  handle_response: fn(Result(resources.Citation, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.citation_to_json(resource),
    "Citation",
    resources.citation_decoder(),
    client,
    handle_response,
  )
}

pub fn citation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Citation, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Citation",
    resources.citation_decoder(),
    client,
    handle_response,
  )
}

pub fn citation_update(
  resource: resources.Citation,
  client: FhirClient,
  handle_response: fn(Result(resources.Citation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.citation_to_json(resource),
    "Citation",
    resources.citation_decoder(),
    client,
    handle_response,
  )
}

pub fn citation_delete(
  resource: resources.Citation,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Citation", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn citation_search_bundled(
  search_for search_args: sansio.SpCitation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.citation_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn citation_search(
  search_for search_args: sansio.SpCitation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Citation), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.citation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.citation },
  )
}

pub fn claim_create(
  resource: resources.Claim,
  client: FhirClient,
  handle_response: fn(Result(resources.Claim, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.claim_to_json(resource),
    "Claim",
    resources.claim_decoder(),
    client,
    handle_response,
  )
}

pub fn claim_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Claim, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Claim", resources.claim_decoder(), client, handle_response)
}

pub fn claim_update(
  resource: resources.Claim,
  client: FhirClient,
  handle_response: fn(Result(resources.Claim, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.claim_to_json(resource),
    "Claim",
    resources.claim_decoder(),
    client,
    handle_response,
  )
}

pub fn claim_delete(
  resource: resources.Claim,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Claim", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn claim_search_bundled(
  search_for search_args: sansio.SpClaim,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.claim_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn claim_search(
  search_for search_args: sansio.SpClaim,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Claim), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.claim_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.claim },
  )
}

pub fn claimresponse_create(
  resource: resources.Claimresponse,
  client: FhirClient,
  handle_response: fn(Result(resources.Claimresponse, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.claimresponse_to_json(resource),
    "ClaimResponse",
    resources.claimresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn claimresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Claimresponse, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ClaimResponse",
    resources.claimresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn claimresponse_update(
  resource: resources.Claimresponse,
  client: FhirClient,
  handle_response: fn(Result(resources.Claimresponse, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.claimresponse_to_json(resource),
    "ClaimResponse",
    resources.claimresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn claimresponse_delete(
  resource: resources.Claimresponse,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "ClaimResponse", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn claimresponse_search_bundled(
  search_for search_args: sansio.SpClaimresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.claimresponse_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn claimresponse_search(
  search_for search_args: sansio.SpClaimresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Claimresponse), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.claimresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.claimresponse },
  )
}

pub fn clinicalimpression_create(
  resource: resources.Clinicalimpression,
  client: FhirClient,
  handle_response: fn(Result(resources.Clinicalimpression, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.clinicalimpression_to_json(resource),
    "ClinicalImpression",
    resources.clinicalimpression_decoder(),
    client,
    handle_response,
  )
}

pub fn clinicalimpression_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Clinicalimpression, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ClinicalImpression",
    resources.clinicalimpression_decoder(),
    client,
    handle_response,
  )
}

pub fn clinicalimpression_update(
  resource: resources.Clinicalimpression,
  client: FhirClient,
  handle_response: fn(Result(resources.Clinicalimpression, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.clinicalimpression_to_json(resource),
    "ClinicalImpression",
    resources.clinicalimpression_decoder(),
    client,
    handle_response,
  )
}

pub fn clinicalimpression_delete(
  resource: resources.Clinicalimpression,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "ClinicalImpression", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn clinicalimpression_search_bundled(
  search_for search_args: sansio.SpClinicalimpression,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.clinicalimpression_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn clinicalimpression_search(
  search_for search_args: sansio.SpClinicalimpression,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Clinicalimpression), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.clinicalimpression_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.clinicalimpression
    },
  )
}

pub fn clinicalusedefinition_create(
  resource: resources.Clinicalusedefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Clinicalusedefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.clinicalusedefinition_to_json(resource),
    "ClinicalUseDefinition",
    resources.clinicalusedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn clinicalusedefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Clinicalusedefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ClinicalUseDefinition",
    resources.clinicalusedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn clinicalusedefinition_update(
  resource: resources.Clinicalusedefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Clinicalusedefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.clinicalusedefinition_to_json(resource),
    "ClinicalUseDefinition",
    resources.clinicalusedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn clinicalusedefinition_delete(
  resource: resources.Clinicalusedefinition,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "ClinicalUseDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn clinicalusedefinition_search_bundled(
  search_for search_args: sansio.SpClinicalusedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.clinicalusedefinition_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn clinicalusedefinition_search(
  search_for search_args: sansio.SpClinicalusedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Clinicalusedefinition), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.clinicalusedefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.clinicalusedefinition
    },
  )
}

pub fn codesystem_create(
  resource: resources.Codesystem,
  client: FhirClient,
  handle_response: fn(Result(resources.Codesystem, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.codesystem_to_json(resource),
    "CodeSystem",
    resources.codesystem_decoder(),
    client,
    handle_response,
  )
}

pub fn codesystem_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Codesystem, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CodeSystem",
    resources.codesystem_decoder(),
    client,
    handle_response,
  )
}

pub fn codesystem_update(
  resource: resources.Codesystem,
  client: FhirClient,
  handle_response: fn(Result(resources.Codesystem, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.codesystem_to_json(resource),
    "CodeSystem",
    resources.codesystem_decoder(),
    client,
    handle_response,
  )
}

pub fn codesystem_delete(
  resource: resources.Codesystem,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "CodeSystem", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn codesystem_search_bundled(
  search_for search_args: sansio.SpCodesystem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.codesystem_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn codesystem_search(
  search_for search_args: sansio.SpCodesystem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Codesystem), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.codesystem_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.codesystem },
  )
}

pub fn communication_create(
  resource: resources.Communication,
  client: FhirClient,
  handle_response: fn(Result(resources.Communication, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.communication_to_json(resource),
    "Communication",
    resources.communication_decoder(),
    client,
    handle_response,
  )
}

pub fn communication_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Communication, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Communication",
    resources.communication_decoder(),
    client,
    handle_response,
  )
}

pub fn communication_update(
  resource: resources.Communication,
  client: FhirClient,
  handle_response: fn(Result(resources.Communication, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.communication_to_json(resource),
    "Communication",
    resources.communication_decoder(),
    client,
    handle_response,
  )
}

pub fn communication_delete(
  resource: resources.Communication,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Communication", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn communication_search_bundled(
  search_for search_args: sansio.SpCommunication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.communication_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn communication_search(
  search_for search_args: sansio.SpCommunication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Communication), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.communication_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.communication },
  )
}

pub fn communicationrequest_create(
  resource: resources.Communicationrequest,
  client: FhirClient,
  handle_response: fn(Result(resources.Communicationrequest, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.communicationrequest_to_json(resource),
    "CommunicationRequest",
    resources.communicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn communicationrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Communicationrequest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CommunicationRequest",
    resources.communicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn communicationrequest_update(
  resource: resources.Communicationrequest,
  client: FhirClient,
  handle_response: fn(Result(resources.Communicationrequest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.communicationrequest_to_json(resource),
    "CommunicationRequest",
    resources.communicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn communicationrequest_delete(
  resource: resources.Communicationrequest,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "CommunicationRequest", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn communicationrequest_search_bundled(
  search_for search_args: sansio.SpCommunicationrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.communicationrequest_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn communicationrequest_search(
  search_for search_args: sansio.SpCommunicationrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Communicationrequest), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.communicationrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.communicationrequest
    },
  )
}

pub fn compartmentdefinition_create(
  resource: resources.Compartmentdefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Compartmentdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.compartmentdefinition_to_json(resource),
    "CompartmentDefinition",
    resources.compartmentdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn compartmentdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Compartmentdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CompartmentDefinition",
    resources.compartmentdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn compartmentdefinition_update(
  resource: resources.Compartmentdefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Compartmentdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.compartmentdefinition_to_json(resource),
    "CompartmentDefinition",
    resources.compartmentdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn compartmentdefinition_delete(
  resource: resources.Compartmentdefinition,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "CompartmentDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn compartmentdefinition_search_bundled(
  search_for search_args: sansio.SpCompartmentdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.compartmentdefinition_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn compartmentdefinition_search(
  search_for search_args: sansio.SpCompartmentdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Compartmentdefinition), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.compartmentdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.compartmentdefinition
    },
  )
}

pub fn composition_create(
  resource: resources.Composition,
  client: FhirClient,
  handle_response: fn(Result(resources.Composition, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.composition_to_json(resource),
    "Composition",
    resources.composition_decoder(),
    client,
    handle_response,
  )
}

pub fn composition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Composition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Composition",
    resources.composition_decoder(),
    client,
    handle_response,
  )
}

pub fn composition_update(
  resource: resources.Composition,
  client: FhirClient,
  handle_response: fn(Result(resources.Composition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.composition_to_json(resource),
    "Composition",
    resources.composition_decoder(),
    client,
    handle_response,
  )
}

pub fn composition_delete(
  resource: resources.Composition,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Composition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn composition_search_bundled(
  search_for search_args: sansio.SpComposition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.composition_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn composition_search(
  search_for search_args: sansio.SpComposition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Composition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.composition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.composition },
  )
}

pub fn conceptmap_create(
  resource: resources.Conceptmap,
  client: FhirClient,
  handle_response: fn(Result(resources.Conceptmap, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.conceptmap_to_json(resource),
    "ConceptMap",
    resources.conceptmap_decoder(),
    client,
    handle_response,
  )
}

pub fn conceptmap_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Conceptmap, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ConceptMap",
    resources.conceptmap_decoder(),
    client,
    handle_response,
  )
}

pub fn conceptmap_update(
  resource: resources.Conceptmap,
  client: FhirClient,
  handle_response: fn(Result(resources.Conceptmap, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.conceptmap_to_json(resource),
    "ConceptMap",
    resources.conceptmap_decoder(),
    client,
    handle_response,
  )
}

pub fn conceptmap_delete(
  resource: resources.Conceptmap,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "ConceptMap", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn conceptmap_search_bundled(
  search_for search_args: sansio.SpConceptmap,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.conceptmap_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn conceptmap_search(
  search_for search_args: sansio.SpConceptmap,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Conceptmap), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.conceptmap_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.conceptmap },
  )
}

pub fn condition_create(
  resource: resources.Condition,
  client: FhirClient,
  handle_response: fn(Result(resources.Condition, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.condition_to_json(resource),
    "Condition",
    resources.condition_decoder(),
    client,
    handle_response,
  )
}

pub fn condition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Condition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Condition",
    resources.condition_decoder(),
    client,
    handle_response,
  )
}

pub fn condition_update(
  resource: resources.Condition,
  client: FhirClient,
  handle_response: fn(Result(resources.Condition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.condition_to_json(resource),
    "Condition",
    resources.condition_decoder(),
    client,
    handle_response,
  )
}

pub fn condition_delete(
  resource: resources.Condition,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Condition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn condition_search_bundled(
  search_for search_args: sansio.SpCondition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.condition_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn condition_search(
  search_for search_args: sansio.SpCondition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Condition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.condition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.condition },
  )
}

pub fn conditiondefinition_create(
  resource: resources.Conditiondefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Conditiondefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.conditiondefinition_to_json(resource),
    "ConditionDefinition",
    resources.conditiondefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn conditiondefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Conditiondefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ConditionDefinition",
    resources.conditiondefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn conditiondefinition_update(
  resource: resources.Conditiondefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Conditiondefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.conditiondefinition_to_json(resource),
    "ConditionDefinition",
    resources.conditiondefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn conditiondefinition_delete(
  resource: resources.Conditiondefinition,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "ConditionDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn conditiondefinition_search_bundled(
  search_for search_args: sansio.SpConditiondefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.conditiondefinition_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn conditiondefinition_search(
  search_for search_args: sansio.SpConditiondefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Conditiondefinition), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.conditiondefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.conditiondefinition
    },
  )
}

pub fn consent_create(
  resource: resources.Consent,
  client: FhirClient,
  handle_response: fn(Result(resources.Consent, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.consent_to_json(resource),
    "Consent",
    resources.consent_decoder(),
    client,
    handle_response,
  )
}

pub fn consent_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Consent, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Consent", resources.consent_decoder(), client, handle_response)
}

pub fn consent_update(
  resource: resources.Consent,
  client: FhirClient,
  handle_response: fn(Result(resources.Consent, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.consent_to_json(resource),
    "Consent",
    resources.consent_decoder(),
    client,
    handle_response,
  )
}

pub fn consent_delete(
  resource: resources.Consent,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Consent", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn consent_search_bundled(
  search_for search_args: sansio.SpConsent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.consent_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn consent_search(
  search_for search_args: sansio.SpConsent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Consent), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.consent_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.consent },
  )
}

pub fn contract_create(
  resource: resources.Contract,
  client: FhirClient,
  handle_response: fn(Result(resources.Contract, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.contract_to_json(resource),
    "Contract",
    resources.contract_decoder(),
    client,
    handle_response,
  )
}

pub fn contract_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Contract, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Contract",
    resources.contract_decoder(),
    client,
    handle_response,
  )
}

pub fn contract_update(
  resource: resources.Contract,
  client: FhirClient,
  handle_response: fn(Result(resources.Contract, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.contract_to_json(resource),
    "Contract",
    resources.contract_decoder(),
    client,
    handle_response,
  )
}

pub fn contract_delete(
  resource: resources.Contract,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Contract", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn contract_search_bundled(
  search_for search_args: sansio.SpContract,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.contract_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn contract_search(
  search_for search_args: sansio.SpContract,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Contract), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.contract_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.contract },
  )
}

pub fn coverage_create(
  resource: resources.Coverage,
  client: FhirClient,
  handle_response: fn(Result(resources.Coverage, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.coverage_to_json(resource),
    "Coverage",
    resources.coverage_decoder(),
    client,
    handle_response,
  )
}

pub fn coverage_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Coverage, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Coverage",
    resources.coverage_decoder(),
    client,
    handle_response,
  )
}

pub fn coverage_update(
  resource: resources.Coverage,
  client: FhirClient,
  handle_response: fn(Result(resources.Coverage, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.coverage_to_json(resource),
    "Coverage",
    resources.coverage_decoder(),
    client,
    handle_response,
  )
}

pub fn coverage_delete(
  resource: resources.Coverage,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Coverage", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn coverage_search_bundled(
  search_for search_args: sansio.SpCoverage,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.coverage_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn coverage_search(
  search_for search_args: sansio.SpCoverage,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Coverage), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.coverage_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.coverage },
  )
}

pub fn coverageeligibilityrequest_create(
  resource: resources.Coverageeligibilityrequest,
  client: FhirClient,
  handle_response: fn(Result(resources.Coverageeligibilityrequest, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.coverageeligibilityrequest_to_json(resource),
    "CoverageEligibilityRequest",
    resources.coverageeligibilityrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Coverageeligibilityrequest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CoverageEligibilityRequest",
    resources.coverageeligibilityrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityrequest_update(
  resource: resources.Coverageeligibilityrequest,
  client: FhirClient,
  handle_response: fn(Result(resources.Coverageeligibilityrequest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.coverageeligibilityrequest_to_json(resource),
    "CoverageEligibilityRequest",
    resources.coverageeligibilityrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityrequest_delete(
  resource: resources.Coverageeligibilityrequest,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "CoverageEligibilityRequest", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn coverageeligibilityrequest_search_bundled(
  search_for search_args: sansio.SpCoverageeligibilityrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.coverageeligibilityrequest_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn coverageeligibilityrequest_search(
  search_for search_args: sansio.SpCoverageeligibilityrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Coverageeligibilityrequest), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.coverageeligibilityrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.coverageeligibilityrequest
    },
  )
}

pub fn coverageeligibilityresponse_create(
  resource: resources.Coverageeligibilityresponse,
  client: FhirClient,
  handle_response: fn(Result(resources.Coverageeligibilityresponse, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.coverageeligibilityresponse_to_json(resource),
    "CoverageEligibilityResponse",
    resources.coverageeligibilityresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Coverageeligibilityresponse, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CoverageEligibilityResponse",
    resources.coverageeligibilityresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityresponse_update(
  resource: resources.Coverageeligibilityresponse,
  client: FhirClient,
  handle_response: fn(Result(resources.Coverageeligibilityresponse, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.coverageeligibilityresponse_to_json(resource),
    "CoverageEligibilityResponse",
    resources.coverageeligibilityresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityresponse_delete(
  resource: resources.Coverageeligibilityresponse,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "CoverageEligibilityResponse", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn coverageeligibilityresponse_search_bundled(
  search_for search_args: sansio.SpCoverageeligibilityresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.coverageeligibilityresponse_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn coverageeligibilityresponse_search(
  search_for search_args: sansio.SpCoverageeligibilityresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Coverageeligibilityresponse), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.coverageeligibilityresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.coverageeligibilityresponse
    },
  )
}

pub fn detectedissue_create(
  resource: resources.Detectedissue,
  client: FhirClient,
  handle_response: fn(Result(resources.Detectedissue, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.detectedissue_to_json(resource),
    "DetectedIssue",
    resources.detectedissue_decoder(),
    client,
    handle_response,
  )
}

pub fn detectedissue_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Detectedissue, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DetectedIssue",
    resources.detectedissue_decoder(),
    client,
    handle_response,
  )
}

pub fn detectedissue_update(
  resource: resources.Detectedissue,
  client: FhirClient,
  handle_response: fn(Result(resources.Detectedissue, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.detectedissue_to_json(resource),
    "DetectedIssue",
    resources.detectedissue_decoder(),
    client,
    handle_response,
  )
}

pub fn detectedissue_delete(
  resource: resources.Detectedissue,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "DetectedIssue", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn detectedissue_search_bundled(
  search_for search_args: sansio.SpDetectedissue,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.detectedissue_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn detectedissue_search(
  search_for search_args: sansio.SpDetectedissue,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Detectedissue), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.detectedissue_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.detectedissue },
  )
}

pub fn device_create(
  resource: resources.Device,
  client: FhirClient,
  handle_response: fn(Result(resources.Device, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.device_to_json(resource),
    "Device",
    resources.device_decoder(),
    client,
    handle_response,
  )
}

pub fn device_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Device, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Device", resources.device_decoder(), client, handle_response)
}

pub fn device_update(
  resource: resources.Device,
  client: FhirClient,
  handle_response: fn(Result(resources.Device, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.device_to_json(resource),
    "Device",
    resources.device_decoder(),
    client,
    handle_response,
  )
}

pub fn device_delete(
  resource: resources.Device,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Device", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn device_search_bundled(
  search_for search_args: sansio.SpDevice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.device_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn device_search(
  search_for search_args: sansio.SpDevice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Device), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.device_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.device },
  )
}

pub fn deviceassociation_create(
  resource: resources.Deviceassociation,
  client: FhirClient,
  handle_response: fn(Result(resources.Deviceassociation, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.deviceassociation_to_json(resource),
    "DeviceAssociation",
    resources.deviceassociation_decoder(),
    client,
    handle_response,
  )
}

pub fn deviceassociation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Deviceassociation, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DeviceAssociation",
    resources.deviceassociation_decoder(),
    client,
    handle_response,
  )
}

pub fn deviceassociation_update(
  resource: resources.Deviceassociation,
  client: FhirClient,
  handle_response: fn(Result(resources.Deviceassociation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.deviceassociation_to_json(resource),
    "DeviceAssociation",
    resources.deviceassociation_decoder(),
    client,
    handle_response,
  )
}

pub fn deviceassociation_delete(
  resource: resources.Deviceassociation,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "DeviceAssociation", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn deviceassociation_search_bundled(
  search_for search_args: sansio.SpDeviceassociation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.deviceassociation_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn deviceassociation_search(
  search_for search_args: sansio.SpDeviceassociation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Deviceassociation), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.deviceassociation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.deviceassociation
    },
  )
}

pub fn devicedefinition_create(
  resource: resources.Devicedefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Devicedefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.devicedefinition_to_json(resource),
    "DeviceDefinition",
    resources.devicedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn devicedefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Devicedefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DeviceDefinition",
    resources.devicedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn devicedefinition_update(
  resource: resources.Devicedefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Devicedefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.devicedefinition_to_json(resource),
    "DeviceDefinition",
    resources.devicedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn devicedefinition_delete(
  resource: resources.Devicedefinition,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "DeviceDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn devicedefinition_search_bundled(
  search_for search_args: sansio.SpDevicedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.devicedefinition_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn devicedefinition_search(
  search_for search_args: sansio.SpDevicedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Devicedefinition), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.devicedefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.devicedefinition
    },
  )
}

pub fn devicedispense_create(
  resource: resources.Devicedispense,
  client: FhirClient,
  handle_response: fn(Result(resources.Devicedispense, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.devicedispense_to_json(resource),
    "DeviceDispense",
    resources.devicedispense_decoder(),
    client,
    handle_response,
  )
}

pub fn devicedispense_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Devicedispense, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DeviceDispense",
    resources.devicedispense_decoder(),
    client,
    handle_response,
  )
}

pub fn devicedispense_update(
  resource: resources.Devicedispense,
  client: FhirClient,
  handle_response: fn(Result(resources.Devicedispense, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.devicedispense_to_json(resource),
    "DeviceDispense",
    resources.devicedispense_decoder(),
    client,
    handle_response,
  )
}

pub fn devicedispense_delete(
  resource: resources.Devicedispense,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "DeviceDispense", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn devicedispense_search_bundled(
  search_for search_args: sansio.SpDevicedispense,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.devicedispense_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn devicedispense_search(
  search_for search_args: sansio.SpDevicedispense,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Devicedispense), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.devicedispense_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.devicedispense
    },
  )
}

pub fn devicemetric_create(
  resource: resources.Devicemetric,
  client: FhirClient,
  handle_response: fn(Result(resources.Devicemetric, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.devicemetric_to_json(resource),
    "DeviceMetric",
    resources.devicemetric_decoder(),
    client,
    handle_response,
  )
}

pub fn devicemetric_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Devicemetric, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DeviceMetric",
    resources.devicemetric_decoder(),
    client,
    handle_response,
  )
}

pub fn devicemetric_update(
  resource: resources.Devicemetric,
  client: FhirClient,
  handle_response: fn(Result(resources.Devicemetric, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.devicemetric_to_json(resource),
    "DeviceMetric",
    resources.devicemetric_decoder(),
    client,
    handle_response,
  )
}

pub fn devicemetric_delete(
  resource: resources.Devicemetric,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "DeviceMetric", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn devicemetric_search_bundled(
  search_for search_args: sansio.SpDevicemetric,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.devicemetric_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn devicemetric_search(
  search_for search_args: sansio.SpDevicemetric,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Devicemetric), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.devicemetric_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.devicemetric },
  )
}

pub fn devicerequest_create(
  resource: resources.Devicerequest,
  client: FhirClient,
  handle_response: fn(Result(resources.Devicerequest, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.devicerequest_to_json(resource),
    "DeviceRequest",
    resources.devicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn devicerequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Devicerequest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DeviceRequest",
    resources.devicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn devicerequest_update(
  resource: resources.Devicerequest,
  client: FhirClient,
  handle_response: fn(Result(resources.Devicerequest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.devicerequest_to_json(resource),
    "DeviceRequest",
    resources.devicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn devicerequest_delete(
  resource: resources.Devicerequest,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "DeviceRequest", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn devicerequest_search_bundled(
  search_for search_args: sansio.SpDevicerequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.devicerequest_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn devicerequest_search(
  search_for search_args: sansio.SpDevicerequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Devicerequest), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.devicerequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.devicerequest },
  )
}

pub fn deviceusage_create(
  resource: resources.Deviceusage,
  client: FhirClient,
  handle_response: fn(Result(resources.Deviceusage, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.deviceusage_to_json(resource),
    "DeviceUsage",
    resources.deviceusage_decoder(),
    client,
    handle_response,
  )
}

pub fn deviceusage_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Deviceusage, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DeviceUsage",
    resources.deviceusage_decoder(),
    client,
    handle_response,
  )
}

pub fn deviceusage_update(
  resource: resources.Deviceusage,
  client: FhirClient,
  handle_response: fn(Result(resources.Deviceusage, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.deviceusage_to_json(resource),
    "DeviceUsage",
    resources.deviceusage_decoder(),
    client,
    handle_response,
  )
}

pub fn deviceusage_delete(
  resource: resources.Deviceusage,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "DeviceUsage", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn deviceusage_search_bundled(
  search_for search_args: sansio.SpDeviceusage,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.deviceusage_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn deviceusage_search(
  search_for search_args: sansio.SpDeviceusage,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Deviceusage), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.deviceusage_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.deviceusage },
  )
}

pub fn diagnosticreport_create(
  resource: resources.Diagnosticreport,
  client: FhirClient,
  handle_response: fn(Result(resources.Diagnosticreport, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.diagnosticreport_to_json(resource),
    "DiagnosticReport",
    resources.diagnosticreport_decoder(),
    client,
    handle_response,
  )
}

pub fn diagnosticreport_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Diagnosticreport, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DiagnosticReport",
    resources.diagnosticreport_decoder(),
    client,
    handle_response,
  )
}

pub fn diagnosticreport_update(
  resource: resources.Diagnosticreport,
  client: FhirClient,
  handle_response: fn(Result(resources.Diagnosticreport, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.diagnosticreport_to_json(resource),
    "DiagnosticReport",
    resources.diagnosticreport_decoder(),
    client,
    handle_response,
  )
}

pub fn diagnosticreport_delete(
  resource: resources.Diagnosticreport,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "DiagnosticReport", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn diagnosticreport_search_bundled(
  search_for search_args: sansio.SpDiagnosticreport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.diagnosticreport_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn diagnosticreport_search(
  search_for search_args: sansio.SpDiagnosticreport,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Diagnosticreport), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.diagnosticreport_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.diagnosticreport
    },
  )
}

pub fn documentreference_create(
  resource: resources.Documentreference,
  client: FhirClient,
  handle_response: fn(Result(resources.Documentreference, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.documentreference_to_json(resource),
    "DocumentReference",
    resources.documentreference_decoder(),
    client,
    handle_response,
  )
}

pub fn documentreference_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Documentreference, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DocumentReference",
    resources.documentreference_decoder(),
    client,
    handle_response,
  )
}

pub fn documentreference_update(
  resource: resources.Documentreference,
  client: FhirClient,
  handle_response: fn(Result(resources.Documentreference, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.documentreference_to_json(resource),
    "DocumentReference",
    resources.documentreference_decoder(),
    client,
    handle_response,
  )
}

pub fn documentreference_delete(
  resource: resources.Documentreference,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "DocumentReference", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn documentreference_search_bundled(
  search_for search_args: sansio.SpDocumentreference,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.documentreference_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn documentreference_search(
  search_for search_args: sansio.SpDocumentreference,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Documentreference), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.documentreference_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.documentreference
    },
  )
}

pub fn encounter_create(
  resource: resources.Encounter,
  client: FhirClient,
  handle_response: fn(Result(resources.Encounter, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.encounter_to_json(resource),
    "Encounter",
    resources.encounter_decoder(),
    client,
    handle_response,
  )
}

pub fn encounter_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Encounter, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Encounter",
    resources.encounter_decoder(),
    client,
    handle_response,
  )
}

pub fn encounter_update(
  resource: resources.Encounter,
  client: FhirClient,
  handle_response: fn(Result(resources.Encounter, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.encounter_to_json(resource),
    "Encounter",
    resources.encounter_decoder(),
    client,
    handle_response,
  )
}

pub fn encounter_delete(
  resource: resources.Encounter,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Encounter", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn encounter_search_bundled(
  search_for search_args: sansio.SpEncounter,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.encounter_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn encounter_search(
  search_for search_args: sansio.SpEncounter,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Encounter), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.encounter_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.encounter },
  )
}

pub fn encounterhistory_create(
  resource: resources.Encounterhistory,
  client: FhirClient,
  handle_response: fn(Result(resources.Encounterhistory, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.encounterhistory_to_json(resource),
    "EncounterHistory",
    resources.encounterhistory_decoder(),
    client,
    handle_response,
  )
}

pub fn encounterhistory_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Encounterhistory, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EncounterHistory",
    resources.encounterhistory_decoder(),
    client,
    handle_response,
  )
}

pub fn encounterhistory_update(
  resource: resources.Encounterhistory,
  client: FhirClient,
  handle_response: fn(Result(resources.Encounterhistory, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.encounterhistory_to_json(resource),
    "EncounterHistory",
    resources.encounterhistory_decoder(),
    client,
    handle_response,
  )
}

pub fn encounterhistory_delete(
  resource: resources.Encounterhistory,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "EncounterHistory", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn encounterhistory_search_bundled(
  search_for search_args: sansio.SpEncounterhistory,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.encounterhistory_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn encounterhistory_search(
  search_for search_args: sansio.SpEncounterhistory,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Encounterhistory), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.encounterhistory_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.encounterhistory
    },
  )
}

pub fn endpoint_create(
  resource: resources.Endpoint,
  client: FhirClient,
  handle_response: fn(Result(resources.Endpoint, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.endpoint_to_json(resource),
    "Endpoint",
    resources.endpoint_decoder(),
    client,
    handle_response,
  )
}

pub fn endpoint_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Endpoint, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Endpoint",
    resources.endpoint_decoder(),
    client,
    handle_response,
  )
}

pub fn endpoint_update(
  resource: resources.Endpoint,
  client: FhirClient,
  handle_response: fn(Result(resources.Endpoint, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.endpoint_to_json(resource),
    "Endpoint",
    resources.endpoint_decoder(),
    client,
    handle_response,
  )
}

pub fn endpoint_delete(
  resource: resources.Endpoint,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Endpoint", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn endpoint_search_bundled(
  search_for search_args: sansio.SpEndpoint,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.endpoint_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn endpoint_search(
  search_for search_args: sansio.SpEndpoint,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Endpoint), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.endpoint_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.endpoint },
  )
}

pub fn enrollmentrequest_create(
  resource: resources.Enrollmentrequest,
  client: FhirClient,
  handle_response: fn(Result(resources.Enrollmentrequest, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.enrollmentrequest_to_json(resource),
    "EnrollmentRequest",
    resources.enrollmentrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Enrollmentrequest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EnrollmentRequest",
    resources.enrollmentrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentrequest_update(
  resource: resources.Enrollmentrequest,
  client: FhirClient,
  handle_response: fn(Result(resources.Enrollmentrequest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.enrollmentrequest_to_json(resource),
    "EnrollmentRequest",
    resources.enrollmentrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentrequest_delete(
  resource: resources.Enrollmentrequest,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "EnrollmentRequest", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn enrollmentrequest_search_bundled(
  search_for search_args: sansio.SpEnrollmentrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.enrollmentrequest_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn enrollmentrequest_search(
  search_for search_args: sansio.SpEnrollmentrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Enrollmentrequest), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.enrollmentrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.enrollmentrequest
    },
  )
}

pub fn enrollmentresponse_create(
  resource: resources.Enrollmentresponse,
  client: FhirClient,
  handle_response: fn(Result(resources.Enrollmentresponse, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.enrollmentresponse_to_json(resource),
    "EnrollmentResponse",
    resources.enrollmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Enrollmentresponse, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EnrollmentResponse",
    resources.enrollmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentresponse_update(
  resource: resources.Enrollmentresponse,
  client: FhirClient,
  handle_response: fn(Result(resources.Enrollmentresponse, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.enrollmentresponse_to_json(resource),
    "EnrollmentResponse",
    resources.enrollmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentresponse_delete(
  resource: resources.Enrollmentresponse,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "EnrollmentResponse", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn enrollmentresponse_search_bundled(
  search_for search_args: sansio.SpEnrollmentresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.enrollmentresponse_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn enrollmentresponse_search(
  search_for search_args: sansio.SpEnrollmentresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Enrollmentresponse), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.enrollmentresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.enrollmentresponse
    },
  )
}

pub fn episodeofcare_create(
  resource: resources.Episodeofcare,
  client: FhirClient,
  handle_response: fn(Result(resources.Episodeofcare, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.episodeofcare_to_json(resource),
    "EpisodeOfCare",
    resources.episodeofcare_decoder(),
    client,
    handle_response,
  )
}

pub fn episodeofcare_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Episodeofcare, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EpisodeOfCare",
    resources.episodeofcare_decoder(),
    client,
    handle_response,
  )
}

pub fn episodeofcare_update(
  resource: resources.Episodeofcare,
  client: FhirClient,
  handle_response: fn(Result(resources.Episodeofcare, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.episodeofcare_to_json(resource),
    "EpisodeOfCare",
    resources.episodeofcare_decoder(),
    client,
    handle_response,
  )
}

pub fn episodeofcare_delete(
  resource: resources.Episodeofcare,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "EpisodeOfCare", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn episodeofcare_search_bundled(
  search_for search_args: sansio.SpEpisodeofcare,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.episodeofcare_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn episodeofcare_search(
  search_for search_args: sansio.SpEpisodeofcare,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Episodeofcare), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.episodeofcare_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.episodeofcare },
  )
}

pub fn eventdefinition_create(
  resource: resources.Eventdefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Eventdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.eventdefinition_to_json(resource),
    "EventDefinition",
    resources.eventdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn eventdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Eventdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EventDefinition",
    resources.eventdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn eventdefinition_update(
  resource: resources.Eventdefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Eventdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.eventdefinition_to_json(resource),
    "EventDefinition",
    resources.eventdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn eventdefinition_delete(
  resource: resources.Eventdefinition,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "EventDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn eventdefinition_search_bundled(
  search_for search_args: sansio.SpEventdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.eventdefinition_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn eventdefinition_search(
  search_for search_args: sansio.SpEventdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Eventdefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.eventdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.eventdefinition
    },
  )
}

pub fn evidence_create(
  resource: resources.Evidence,
  client: FhirClient,
  handle_response: fn(Result(resources.Evidence, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.evidence_to_json(resource),
    "Evidence",
    resources.evidence_decoder(),
    client,
    handle_response,
  )
}

pub fn evidence_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Evidence, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Evidence",
    resources.evidence_decoder(),
    client,
    handle_response,
  )
}

pub fn evidence_update(
  resource: resources.Evidence,
  client: FhirClient,
  handle_response: fn(Result(resources.Evidence, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.evidence_to_json(resource),
    "Evidence",
    resources.evidence_decoder(),
    client,
    handle_response,
  )
}

pub fn evidence_delete(
  resource: resources.Evidence,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Evidence", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn evidence_search_bundled(
  search_for search_args: sansio.SpEvidence,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.evidence_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn evidence_search(
  search_for search_args: sansio.SpEvidence,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Evidence), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.evidence_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.evidence },
  )
}

pub fn evidencereport_create(
  resource: resources.Evidencereport,
  client: FhirClient,
  handle_response: fn(Result(resources.Evidencereport, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.evidencereport_to_json(resource),
    "EvidenceReport",
    resources.evidencereport_decoder(),
    client,
    handle_response,
  )
}

pub fn evidencereport_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Evidencereport, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EvidenceReport",
    resources.evidencereport_decoder(),
    client,
    handle_response,
  )
}

pub fn evidencereport_update(
  resource: resources.Evidencereport,
  client: FhirClient,
  handle_response: fn(Result(resources.Evidencereport, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.evidencereport_to_json(resource),
    "EvidenceReport",
    resources.evidencereport_decoder(),
    client,
    handle_response,
  )
}

pub fn evidencereport_delete(
  resource: resources.Evidencereport,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "EvidenceReport", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn evidencereport_search_bundled(
  search_for search_args: sansio.SpEvidencereport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.evidencereport_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn evidencereport_search(
  search_for search_args: sansio.SpEvidencereport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Evidencereport), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.evidencereport_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.evidencereport
    },
  )
}

pub fn evidencevariable_create(
  resource: resources.Evidencevariable,
  client: FhirClient,
  handle_response: fn(Result(resources.Evidencevariable, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.evidencevariable_to_json(resource),
    "EvidenceVariable",
    resources.evidencevariable_decoder(),
    client,
    handle_response,
  )
}

pub fn evidencevariable_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Evidencevariable, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EvidenceVariable",
    resources.evidencevariable_decoder(),
    client,
    handle_response,
  )
}

pub fn evidencevariable_update(
  resource: resources.Evidencevariable,
  client: FhirClient,
  handle_response: fn(Result(resources.Evidencevariable, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.evidencevariable_to_json(resource),
    "EvidenceVariable",
    resources.evidencevariable_decoder(),
    client,
    handle_response,
  )
}

pub fn evidencevariable_delete(
  resource: resources.Evidencevariable,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "EvidenceVariable", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn evidencevariable_search_bundled(
  search_for search_args: sansio.SpEvidencevariable,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.evidencevariable_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn evidencevariable_search(
  search_for search_args: sansio.SpEvidencevariable,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Evidencevariable), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.evidencevariable_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.evidencevariable
    },
  )
}

pub fn examplescenario_create(
  resource: resources.Examplescenario,
  client: FhirClient,
  handle_response: fn(Result(resources.Examplescenario, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.examplescenario_to_json(resource),
    "ExampleScenario",
    resources.examplescenario_decoder(),
    client,
    handle_response,
  )
}

pub fn examplescenario_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Examplescenario, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ExampleScenario",
    resources.examplescenario_decoder(),
    client,
    handle_response,
  )
}

pub fn examplescenario_update(
  resource: resources.Examplescenario,
  client: FhirClient,
  handle_response: fn(Result(resources.Examplescenario, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.examplescenario_to_json(resource),
    "ExampleScenario",
    resources.examplescenario_decoder(),
    client,
    handle_response,
  )
}

pub fn examplescenario_delete(
  resource: resources.Examplescenario,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "ExampleScenario", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn examplescenario_search_bundled(
  search_for search_args: sansio.SpExamplescenario,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.examplescenario_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn examplescenario_search(
  search_for search_args: sansio.SpExamplescenario,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Examplescenario), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.examplescenario_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.examplescenario
    },
  )
}

pub fn explanationofbenefit_create(
  resource: resources.Explanationofbenefit,
  client: FhirClient,
  handle_response: fn(Result(resources.Explanationofbenefit, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.explanationofbenefit_to_json(resource),
    "ExplanationOfBenefit",
    resources.explanationofbenefit_decoder(),
    client,
    handle_response,
  )
}

pub fn explanationofbenefit_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Explanationofbenefit, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ExplanationOfBenefit",
    resources.explanationofbenefit_decoder(),
    client,
    handle_response,
  )
}

pub fn explanationofbenefit_update(
  resource: resources.Explanationofbenefit,
  client: FhirClient,
  handle_response: fn(Result(resources.Explanationofbenefit, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.explanationofbenefit_to_json(resource),
    "ExplanationOfBenefit",
    resources.explanationofbenefit_decoder(),
    client,
    handle_response,
  )
}

pub fn explanationofbenefit_delete(
  resource: resources.Explanationofbenefit,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "ExplanationOfBenefit", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn explanationofbenefit_search_bundled(
  search_for search_args: sansio.SpExplanationofbenefit,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.explanationofbenefit_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn explanationofbenefit_search(
  search_for search_args: sansio.SpExplanationofbenefit,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Explanationofbenefit), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.explanationofbenefit_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.explanationofbenefit
    },
  )
}

pub fn familymemberhistory_create(
  resource: resources.Familymemberhistory,
  client: FhirClient,
  handle_response: fn(Result(resources.Familymemberhistory, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    resources.familymemberhistory_decoder(),
    client,
    handle_response,
  )
}

pub fn familymemberhistory_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Familymemberhistory, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "FamilyMemberHistory",
    resources.familymemberhistory_decoder(),
    client,
    handle_response,
  )
}

pub fn familymemberhistory_update(
  resource: resources.Familymemberhistory,
  client: FhirClient,
  handle_response: fn(Result(resources.Familymemberhistory, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    resources.familymemberhistory_decoder(),
    client,
    handle_response,
  )
}

pub fn familymemberhistory_delete(
  resource: resources.Familymemberhistory,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "FamilyMemberHistory", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn familymemberhistory_search_bundled(
  search_for search_args: sansio.SpFamilymemberhistory,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.familymemberhistory_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn familymemberhistory_search(
  search_for search_args: sansio.SpFamilymemberhistory,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Familymemberhistory), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.familymemberhistory_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.familymemberhistory
    },
  )
}

pub fn flag_create(
  resource: resources.Flag,
  client: FhirClient,
  handle_response: fn(Result(resources.Flag, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.flag_to_json(resource),
    "Flag",
    resources.flag_decoder(),
    client,
    handle_response,
  )
}

pub fn flag_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Flag, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Flag", resources.flag_decoder(), client, handle_response)
}

pub fn flag_update(
  resource: resources.Flag,
  client: FhirClient,
  handle_response: fn(Result(resources.Flag, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.flag_to_json(resource),
    "Flag",
    resources.flag_decoder(),
    client,
    handle_response,
  )
}

pub fn flag_delete(
  resource: resources.Flag,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Flag", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn flag_search_bundled(
  search_for search_args: sansio.SpFlag,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.flag_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn flag_search(
  search_for search_args: sansio.SpFlag,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Flag), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.flag_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.flag },
  )
}

pub fn formularyitem_create(
  resource: resources.Formularyitem,
  client: FhirClient,
  handle_response: fn(Result(resources.Formularyitem, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.formularyitem_to_json(resource),
    "FormularyItem",
    resources.formularyitem_decoder(),
    client,
    handle_response,
  )
}

pub fn formularyitem_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Formularyitem, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "FormularyItem",
    resources.formularyitem_decoder(),
    client,
    handle_response,
  )
}

pub fn formularyitem_update(
  resource: resources.Formularyitem,
  client: FhirClient,
  handle_response: fn(Result(resources.Formularyitem, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.formularyitem_to_json(resource),
    "FormularyItem",
    resources.formularyitem_decoder(),
    client,
    handle_response,
  )
}

pub fn formularyitem_delete(
  resource: resources.Formularyitem,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "FormularyItem", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn formularyitem_search_bundled(
  search_for search_args: sansio.SpFormularyitem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.formularyitem_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn formularyitem_search(
  search_for search_args: sansio.SpFormularyitem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Formularyitem), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.formularyitem_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.formularyitem },
  )
}

pub fn genomicstudy_create(
  resource: resources.Genomicstudy,
  client: FhirClient,
  handle_response: fn(Result(resources.Genomicstudy, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.genomicstudy_to_json(resource),
    "GenomicStudy",
    resources.genomicstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn genomicstudy_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Genomicstudy, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "GenomicStudy",
    resources.genomicstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn genomicstudy_update(
  resource: resources.Genomicstudy,
  client: FhirClient,
  handle_response: fn(Result(resources.Genomicstudy, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.genomicstudy_to_json(resource),
    "GenomicStudy",
    resources.genomicstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn genomicstudy_delete(
  resource: resources.Genomicstudy,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "GenomicStudy", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn genomicstudy_search_bundled(
  search_for search_args: sansio.SpGenomicstudy,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.genomicstudy_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn genomicstudy_search(
  search_for search_args: sansio.SpGenomicstudy,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Genomicstudy), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.genomicstudy_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.genomicstudy },
  )
}

pub fn goal_create(
  resource: resources.Goal,
  client: FhirClient,
  handle_response: fn(Result(resources.Goal, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.goal_to_json(resource),
    "Goal",
    resources.goal_decoder(),
    client,
    handle_response,
  )
}

pub fn goal_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Goal, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Goal", resources.goal_decoder(), client, handle_response)
}

pub fn goal_update(
  resource: resources.Goal,
  client: FhirClient,
  handle_response: fn(Result(resources.Goal, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.goal_to_json(resource),
    "Goal",
    resources.goal_decoder(),
    client,
    handle_response,
  )
}

pub fn goal_delete(
  resource: resources.Goal,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Goal", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn goal_search_bundled(
  search_for search_args: sansio.SpGoal,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.goal_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn goal_search(
  search_for search_args: sansio.SpGoal,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Goal), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.goal_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.goal },
  )
}

pub fn graphdefinition_create(
  resource: resources.Graphdefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Graphdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.graphdefinition_to_json(resource),
    "GraphDefinition",
    resources.graphdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn graphdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Graphdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "GraphDefinition",
    resources.graphdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn graphdefinition_update(
  resource: resources.Graphdefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Graphdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.graphdefinition_to_json(resource),
    "GraphDefinition",
    resources.graphdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn graphdefinition_delete(
  resource: resources.Graphdefinition,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "GraphDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn graphdefinition_search_bundled(
  search_for search_args: sansio.SpGraphdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.graphdefinition_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn graphdefinition_search(
  search_for search_args: sansio.SpGraphdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Graphdefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.graphdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.graphdefinition
    },
  )
}

pub fn group_create(
  resource: resources.Group,
  client: FhirClient,
  handle_response: fn(Result(resources.Group, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.group_to_json(resource),
    "Group",
    resources.group_decoder(),
    client,
    handle_response,
  )
}

pub fn group_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Group, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Group", resources.group_decoder(), client, handle_response)
}

pub fn group_update(
  resource: resources.Group,
  client: FhirClient,
  handle_response: fn(Result(resources.Group, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.group_to_json(resource),
    "Group",
    resources.group_decoder(),
    client,
    handle_response,
  )
}

pub fn group_delete(
  resource: resources.Group,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Group", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn group_search_bundled(
  search_for search_args: sansio.SpGroup,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.group_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn group_search(
  search_for search_args: sansio.SpGroup,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Group), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.group_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.group },
  )
}

pub fn guidanceresponse_create(
  resource: resources.Guidanceresponse,
  client: FhirClient,
  handle_response: fn(Result(resources.Guidanceresponse, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.guidanceresponse_to_json(resource),
    "GuidanceResponse",
    resources.guidanceresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn guidanceresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Guidanceresponse, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "GuidanceResponse",
    resources.guidanceresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn guidanceresponse_update(
  resource: resources.Guidanceresponse,
  client: FhirClient,
  handle_response: fn(Result(resources.Guidanceresponse, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.guidanceresponse_to_json(resource),
    "GuidanceResponse",
    resources.guidanceresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn guidanceresponse_delete(
  resource: resources.Guidanceresponse,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "GuidanceResponse", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn guidanceresponse_search_bundled(
  search_for search_args: sansio.SpGuidanceresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.guidanceresponse_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn guidanceresponse_search(
  search_for search_args: sansio.SpGuidanceresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Guidanceresponse), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.guidanceresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.guidanceresponse
    },
  )
}

pub fn healthcareservice_create(
  resource: resources.Healthcareservice,
  client: FhirClient,
  handle_response: fn(Result(resources.Healthcareservice, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.healthcareservice_to_json(resource),
    "HealthcareService",
    resources.healthcareservice_decoder(),
    client,
    handle_response,
  )
}

pub fn healthcareservice_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Healthcareservice, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "HealthcareService",
    resources.healthcareservice_decoder(),
    client,
    handle_response,
  )
}

pub fn healthcareservice_update(
  resource: resources.Healthcareservice,
  client: FhirClient,
  handle_response: fn(Result(resources.Healthcareservice, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.healthcareservice_to_json(resource),
    "HealthcareService",
    resources.healthcareservice_decoder(),
    client,
    handle_response,
  )
}

pub fn healthcareservice_delete(
  resource: resources.Healthcareservice,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "HealthcareService", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn healthcareservice_search_bundled(
  search_for search_args: sansio.SpHealthcareservice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.healthcareservice_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn healthcareservice_search(
  search_for search_args: sansio.SpHealthcareservice,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Healthcareservice), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.healthcareservice_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.healthcareservice
    },
  )
}

pub fn imagingselection_create(
  resource: resources.Imagingselection,
  client: FhirClient,
  handle_response: fn(Result(resources.Imagingselection, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.imagingselection_to_json(resource),
    "ImagingSelection",
    resources.imagingselection_decoder(),
    client,
    handle_response,
  )
}

pub fn imagingselection_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Imagingselection, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ImagingSelection",
    resources.imagingselection_decoder(),
    client,
    handle_response,
  )
}

pub fn imagingselection_update(
  resource: resources.Imagingselection,
  client: FhirClient,
  handle_response: fn(Result(resources.Imagingselection, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.imagingselection_to_json(resource),
    "ImagingSelection",
    resources.imagingselection_decoder(),
    client,
    handle_response,
  )
}

pub fn imagingselection_delete(
  resource: resources.Imagingselection,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "ImagingSelection", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn imagingselection_search_bundled(
  search_for search_args: sansio.SpImagingselection,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.imagingselection_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn imagingselection_search(
  search_for search_args: sansio.SpImagingselection,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Imagingselection), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.imagingselection_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.imagingselection
    },
  )
}

pub fn imagingstudy_create(
  resource: resources.Imagingstudy,
  client: FhirClient,
  handle_response: fn(Result(resources.Imagingstudy, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.imagingstudy_to_json(resource),
    "ImagingStudy",
    resources.imagingstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn imagingstudy_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Imagingstudy, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ImagingStudy",
    resources.imagingstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn imagingstudy_update(
  resource: resources.Imagingstudy,
  client: FhirClient,
  handle_response: fn(Result(resources.Imagingstudy, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.imagingstudy_to_json(resource),
    "ImagingStudy",
    resources.imagingstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn imagingstudy_delete(
  resource: resources.Imagingstudy,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "ImagingStudy", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn imagingstudy_search_bundled(
  search_for search_args: sansio.SpImagingstudy,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.imagingstudy_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn imagingstudy_search(
  search_for search_args: sansio.SpImagingstudy,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Imagingstudy), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.imagingstudy_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.imagingstudy },
  )
}

pub fn immunization_create(
  resource: resources.Immunization,
  client: FhirClient,
  handle_response: fn(Result(resources.Immunization, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.immunization_to_json(resource),
    "Immunization",
    resources.immunization_decoder(),
    client,
    handle_response,
  )
}

pub fn immunization_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Immunization, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Immunization",
    resources.immunization_decoder(),
    client,
    handle_response,
  )
}

pub fn immunization_update(
  resource: resources.Immunization,
  client: FhirClient,
  handle_response: fn(Result(resources.Immunization, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.immunization_to_json(resource),
    "Immunization",
    resources.immunization_decoder(),
    client,
    handle_response,
  )
}

pub fn immunization_delete(
  resource: resources.Immunization,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Immunization", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn immunization_search_bundled(
  search_for search_args: sansio.SpImmunization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.immunization_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn immunization_search(
  search_for search_args: sansio.SpImmunization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Immunization), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.immunization_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.immunization },
  )
}

pub fn immunizationevaluation_create(
  resource: resources.Immunizationevaluation,
  client: FhirClient,
  handle_response: fn(Result(resources.Immunizationevaluation, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.immunizationevaluation_to_json(resource),
    "ImmunizationEvaluation",
    resources.immunizationevaluation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationevaluation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Immunizationevaluation, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ImmunizationEvaluation",
    resources.immunizationevaluation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationevaluation_update(
  resource: resources.Immunizationevaluation,
  client: FhirClient,
  handle_response: fn(Result(resources.Immunizationevaluation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.immunizationevaluation_to_json(resource),
    "ImmunizationEvaluation",
    resources.immunizationevaluation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationevaluation_delete(
  resource: resources.Immunizationevaluation,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "ImmunizationEvaluation", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn immunizationevaluation_search_bundled(
  search_for search_args: sansio.SpImmunizationevaluation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.immunizationevaluation_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn immunizationevaluation_search(
  search_for search_args: sansio.SpImmunizationevaluation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Immunizationevaluation), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.immunizationevaluation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.immunizationevaluation
    },
  )
}

pub fn immunizationrecommendation_create(
  resource: resources.Immunizationrecommendation,
  client: FhirClient,
  handle_response: fn(Result(resources.Immunizationrecommendation, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.immunizationrecommendation_to_json(resource),
    "ImmunizationRecommendation",
    resources.immunizationrecommendation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationrecommendation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Immunizationrecommendation, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ImmunizationRecommendation",
    resources.immunizationrecommendation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationrecommendation_update(
  resource: resources.Immunizationrecommendation,
  client: FhirClient,
  handle_response: fn(Result(resources.Immunizationrecommendation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.immunizationrecommendation_to_json(resource),
    "ImmunizationRecommendation",
    resources.immunizationrecommendation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationrecommendation_delete(
  resource: resources.Immunizationrecommendation,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "ImmunizationRecommendation", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn immunizationrecommendation_search_bundled(
  search_for search_args: sansio.SpImmunizationrecommendation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.immunizationrecommendation_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn immunizationrecommendation_search(
  search_for search_args: sansio.SpImmunizationrecommendation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Immunizationrecommendation), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.immunizationrecommendation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.immunizationrecommendation
    },
  )
}

pub fn implementationguide_create(
  resource: resources.Implementationguide,
  client: FhirClient,
  handle_response: fn(Result(resources.Implementationguide, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.implementationguide_to_json(resource),
    "ImplementationGuide",
    resources.implementationguide_decoder(),
    client,
    handle_response,
  )
}

pub fn implementationguide_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Implementationguide, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ImplementationGuide",
    resources.implementationguide_decoder(),
    client,
    handle_response,
  )
}

pub fn implementationguide_update(
  resource: resources.Implementationguide,
  client: FhirClient,
  handle_response: fn(Result(resources.Implementationguide, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.implementationguide_to_json(resource),
    "ImplementationGuide",
    resources.implementationguide_decoder(),
    client,
    handle_response,
  )
}

pub fn implementationguide_delete(
  resource: resources.Implementationguide,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "ImplementationGuide", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn implementationguide_search_bundled(
  search_for search_args: sansio.SpImplementationguide,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.implementationguide_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn implementationguide_search(
  search_for search_args: sansio.SpImplementationguide,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Implementationguide), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.implementationguide_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.implementationguide
    },
  )
}

pub fn ingredient_create(
  resource: resources.Ingredient,
  client: FhirClient,
  handle_response: fn(Result(resources.Ingredient, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.ingredient_to_json(resource),
    "Ingredient",
    resources.ingredient_decoder(),
    client,
    handle_response,
  )
}

pub fn ingredient_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Ingredient, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Ingredient",
    resources.ingredient_decoder(),
    client,
    handle_response,
  )
}

pub fn ingredient_update(
  resource: resources.Ingredient,
  client: FhirClient,
  handle_response: fn(Result(resources.Ingredient, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.ingredient_to_json(resource),
    "Ingredient",
    resources.ingredient_decoder(),
    client,
    handle_response,
  )
}

pub fn ingredient_delete(
  resource: resources.Ingredient,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Ingredient", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn ingredient_search_bundled(
  search_for search_args: sansio.SpIngredient,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.ingredient_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn ingredient_search(
  search_for search_args: sansio.SpIngredient,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Ingredient), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.ingredient_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.ingredient },
  )
}

pub fn insuranceplan_create(
  resource: resources.Insuranceplan,
  client: FhirClient,
  handle_response: fn(Result(resources.Insuranceplan, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.insuranceplan_to_json(resource),
    "InsurancePlan",
    resources.insuranceplan_decoder(),
    client,
    handle_response,
  )
}

pub fn insuranceplan_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Insuranceplan, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "InsurancePlan",
    resources.insuranceplan_decoder(),
    client,
    handle_response,
  )
}

pub fn insuranceplan_update(
  resource: resources.Insuranceplan,
  client: FhirClient,
  handle_response: fn(Result(resources.Insuranceplan, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.insuranceplan_to_json(resource),
    "InsurancePlan",
    resources.insuranceplan_decoder(),
    client,
    handle_response,
  )
}

pub fn insuranceplan_delete(
  resource: resources.Insuranceplan,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "InsurancePlan", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn insuranceplan_search_bundled(
  search_for search_args: sansio.SpInsuranceplan,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.insuranceplan_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn insuranceplan_search(
  search_for search_args: sansio.SpInsuranceplan,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Insuranceplan), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.insuranceplan_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.insuranceplan },
  )
}

pub fn inventoryitem_create(
  resource: resources.Inventoryitem,
  client: FhirClient,
  handle_response: fn(Result(resources.Inventoryitem, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.inventoryitem_to_json(resource),
    "InventoryItem",
    resources.inventoryitem_decoder(),
    client,
    handle_response,
  )
}

pub fn inventoryitem_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Inventoryitem, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "InventoryItem",
    resources.inventoryitem_decoder(),
    client,
    handle_response,
  )
}

pub fn inventoryitem_update(
  resource: resources.Inventoryitem,
  client: FhirClient,
  handle_response: fn(Result(resources.Inventoryitem, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.inventoryitem_to_json(resource),
    "InventoryItem",
    resources.inventoryitem_decoder(),
    client,
    handle_response,
  )
}

pub fn inventoryitem_delete(
  resource: resources.Inventoryitem,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "InventoryItem", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn inventoryitem_search_bundled(
  search_for search_args: sansio.SpInventoryitem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.inventoryitem_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn inventoryitem_search(
  search_for search_args: sansio.SpInventoryitem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Inventoryitem), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.inventoryitem_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.inventoryitem },
  )
}

pub fn inventoryreport_create(
  resource: resources.Inventoryreport,
  client: FhirClient,
  handle_response: fn(Result(resources.Inventoryreport, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.inventoryreport_to_json(resource),
    "InventoryReport",
    resources.inventoryreport_decoder(),
    client,
    handle_response,
  )
}

pub fn inventoryreport_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Inventoryreport, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "InventoryReport",
    resources.inventoryreport_decoder(),
    client,
    handle_response,
  )
}

pub fn inventoryreport_update(
  resource: resources.Inventoryreport,
  client: FhirClient,
  handle_response: fn(Result(resources.Inventoryreport, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.inventoryreport_to_json(resource),
    "InventoryReport",
    resources.inventoryreport_decoder(),
    client,
    handle_response,
  )
}

pub fn inventoryreport_delete(
  resource: resources.Inventoryreport,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "InventoryReport", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn inventoryreport_search_bundled(
  search_for search_args: sansio.SpInventoryreport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.inventoryreport_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn inventoryreport_search(
  search_for search_args: sansio.SpInventoryreport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Inventoryreport), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.inventoryreport_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.inventoryreport
    },
  )
}

pub fn invoice_create(
  resource: resources.Invoice,
  client: FhirClient,
  handle_response: fn(Result(resources.Invoice, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.invoice_to_json(resource),
    "Invoice",
    resources.invoice_decoder(),
    client,
    handle_response,
  )
}

pub fn invoice_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Invoice, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Invoice", resources.invoice_decoder(), client, handle_response)
}

pub fn invoice_update(
  resource: resources.Invoice,
  client: FhirClient,
  handle_response: fn(Result(resources.Invoice, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.invoice_to_json(resource),
    "Invoice",
    resources.invoice_decoder(),
    client,
    handle_response,
  )
}

pub fn invoice_delete(
  resource: resources.Invoice,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Invoice", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn invoice_search_bundled(
  search_for search_args: sansio.SpInvoice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.invoice_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn invoice_search(
  search_for search_args: sansio.SpInvoice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Invoice), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.invoice_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.invoice },
  )
}

pub fn library_create(
  resource: resources.Library,
  client: FhirClient,
  handle_response: fn(Result(resources.Library, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.library_to_json(resource),
    "Library",
    resources.library_decoder(),
    client,
    handle_response,
  )
}

pub fn library_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Library, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Library", resources.library_decoder(), client, handle_response)
}

pub fn library_update(
  resource: resources.Library,
  client: FhirClient,
  handle_response: fn(Result(resources.Library, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.library_to_json(resource),
    "Library",
    resources.library_decoder(),
    client,
    handle_response,
  )
}

pub fn library_delete(
  resource: resources.Library,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Library", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn library_search_bundled(
  search_for search_args: sansio.SpLibrary,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.library_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn library_search(
  search_for search_args: sansio.SpLibrary,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Library), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.library_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.library },
  )
}

pub fn linkage_create(
  resource: resources.Linkage,
  client: FhirClient,
  handle_response: fn(Result(resources.Linkage, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.linkage_to_json(resource),
    "Linkage",
    resources.linkage_decoder(),
    client,
    handle_response,
  )
}

pub fn linkage_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Linkage, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Linkage", resources.linkage_decoder(), client, handle_response)
}

pub fn linkage_update(
  resource: resources.Linkage,
  client: FhirClient,
  handle_response: fn(Result(resources.Linkage, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.linkage_to_json(resource),
    "Linkage",
    resources.linkage_decoder(),
    client,
    handle_response,
  )
}

pub fn linkage_delete(
  resource: resources.Linkage,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Linkage", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn linkage_search_bundled(
  search_for search_args: sansio.SpLinkage,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.linkage_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn linkage_search(
  search_for search_args: sansio.SpLinkage,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Linkage), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.linkage_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.linkage },
  )
}

pub fn listfhir_create(
  resource: resources.Listfhir,
  client: FhirClient,
  handle_response: fn(Result(resources.Listfhir, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.listfhir_to_json(resource),
    "List",
    resources.listfhir_decoder(),
    client,
    handle_response,
  )
}

pub fn listfhir_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Listfhir, Err)) -> a,
) -> Effect(a) {
  any_read(id, "List", resources.listfhir_decoder(), client, handle_response)
}

pub fn listfhir_update(
  resource: resources.Listfhir,
  client: FhirClient,
  handle_response: fn(Result(resources.Listfhir, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.listfhir_to_json(resource),
    "List",
    resources.listfhir_decoder(),
    client,
    handle_response,
  )
}

pub fn listfhir_delete(
  resource: resources.Listfhir,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "List", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn listfhir_search_bundled(
  search_for search_args: sansio.SpListfhir,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.listfhir_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn listfhir_search(
  search_for search_args: sansio.SpListfhir,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Listfhir), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.listfhir_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.listfhir },
  )
}

pub fn location_create(
  resource: resources.Location,
  client: FhirClient,
  handle_response: fn(Result(resources.Location, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.location_to_json(resource),
    "Location",
    resources.location_decoder(),
    client,
    handle_response,
  )
}

pub fn location_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Location, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Location",
    resources.location_decoder(),
    client,
    handle_response,
  )
}

pub fn location_update(
  resource: resources.Location,
  client: FhirClient,
  handle_response: fn(Result(resources.Location, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.location_to_json(resource),
    "Location",
    resources.location_decoder(),
    client,
    handle_response,
  )
}

pub fn location_delete(
  resource: resources.Location,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Location", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn location_search_bundled(
  search_for search_args: sansio.SpLocation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.location_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn location_search(
  search_for search_args: sansio.SpLocation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Location), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.location_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.location },
  )
}

pub fn manufactureditemdefinition_create(
  resource: resources.Manufactureditemdefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Manufactureditemdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.manufactureditemdefinition_to_json(resource),
    "ManufacturedItemDefinition",
    resources.manufactureditemdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn manufactureditemdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Manufactureditemdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ManufacturedItemDefinition",
    resources.manufactureditemdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn manufactureditemdefinition_update(
  resource: resources.Manufactureditemdefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Manufactureditemdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.manufactureditemdefinition_to_json(resource),
    "ManufacturedItemDefinition",
    resources.manufactureditemdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn manufactureditemdefinition_delete(
  resource: resources.Manufactureditemdefinition,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "ManufacturedItemDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn manufactureditemdefinition_search_bundled(
  search_for search_args: sansio.SpManufactureditemdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.manufactureditemdefinition_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn manufactureditemdefinition_search(
  search_for search_args: sansio.SpManufactureditemdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Manufactureditemdefinition), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.manufactureditemdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.manufactureditemdefinition
    },
  )
}

pub fn measure_create(
  resource: resources.Measure,
  client: FhirClient,
  handle_response: fn(Result(resources.Measure, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.measure_to_json(resource),
    "Measure",
    resources.measure_decoder(),
    client,
    handle_response,
  )
}

pub fn measure_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Measure, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Measure", resources.measure_decoder(), client, handle_response)
}

pub fn measure_update(
  resource: resources.Measure,
  client: FhirClient,
  handle_response: fn(Result(resources.Measure, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.measure_to_json(resource),
    "Measure",
    resources.measure_decoder(),
    client,
    handle_response,
  )
}

pub fn measure_delete(
  resource: resources.Measure,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Measure", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn measure_search_bundled(
  search_for search_args: sansio.SpMeasure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.measure_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn measure_search(
  search_for search_args: sansio.SpMeasure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Measure), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.measure_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.measure },
  )
}

pub fn measurereport_create(
  resource: resources.Measurereport,
  client: FhirClient,
  handle_response: fn(Result(resources.Measurereport, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.measurereport_to_json(resource),
    "MeasureReport",
    resources.measurereport_decoder(),
    client,
    handle_response,
  )
}

pub fn measurereport_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Measurereport, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MeasureReport",
    resources.measurereport_decoder(),
    client,
    handle_response,
  )
}

pub fn measurereport_update(
  resource: resources.Measurereport,
  client: FhirClient,
  handle_response: fn(Result(resources.Measurereport, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.measurereport_to_json(resource),
    "MeasureReport",
    resources.measurereport_decoder(),
    client,
    handle_response,
  )
}

pub fn measurereport_delete(
  resource: resources.Measurereport,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "MeasureReport", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn measurereport_search_bundled(
  search_for search_args: sansio.SpMeasurereport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.measurereport_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn measurereport_search(
  search_for search_args: sansio.SpMeasurereport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Measurereport), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.measurereport_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.measurereport },
  )
}

pub fn medication_create(
  resource: resources.Medication,
  client: FhirClient,
  handle_response: fn(Result(resources.Medication, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.medication_to_json(resource),
    "Medication",
    resources.medication_decoder(),
    client,
    handle_response,
  )
}

pub fn medication_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Medication, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Medication",
    resources.medication_decoder(),
    client,
    handle_response,
  )
}

pub fn medication_update(
  resource: resources.Medication,
  client: FhirClient,
  handle_response: fn(Result(resources.Medication, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.medication_to_json(resource),
    "Medication",
    resources.medication_decoder(),
    client,
    handle_response,
  )
}

pub fn medication_delete(
  resource: resources.Medication,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Medication", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn medication_search_bundled(
  search_for search_args: sansio.SpMedication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.medication_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn medication_search(
  search_for search_args: sansio.SpMedication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Medication), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.medication_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.medication },
  )
}

pub fn medicationadministration_create(
  resource: resources.Medicationadministration,
  client: FhirClient,
  handle_response: fn(Result(resources.Medicationadministration, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.medicationadministration_to_json(resource),
    "MedicationAdministration",
    resources.medicationadministration_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationadministration_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Medicationadministration, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationAdministration",
    resources.medicationadministration_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationadministration_update(
  resource: resources.Medicationadministration,
  client: FhirClient,
  handle_response: fn(Result(resources.Medicationadministration, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.medicationadministration_to_json(resource),
    "MedicationAdministration",
    resources.medicationadministration_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationadministration_delete(
  resource: resources.Medicationadministration,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "MedicationAdministration", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn medicationadministration_search_bundled(
  search_for search_args: sansio.SpMedicationadministration,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.medicationadministration_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn medicationadministration_search(
  search_for search_args: sansio.SpMedicationadministration,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Medicationadministration), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.medicationadministration_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.medicationadministration
    },
  )
}

pub fn medicationdispense_create(
  resource: resources.Medicationdispense,
  client: FhirClient,
  handle_response: fn(Result(resources.Medicationdispense, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.medicationdispense_to_json(resource),
    "MedicationDispense",
    resources.medicationdispense_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationdispense_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Medicationdispense, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationDispense",
    resources.medicationdispense_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationdispense_update(
  resource: resources.Medicationdispense,
  client: FhirClient,
  handle_response: fn(Result(resources.Medicationdispense, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.medicationdispense_to_json(resource),
    "MedicationDispense",
    resources.medicationdispense_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationdispense_delete(
  resource: resources.Medicationdispense,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "MedicationDispense", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn medicationdispense_search_bundled(
  search_for search_args: sansio.SpMedicationdispense,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.medicationdispense_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn medicationdispense_search(
  search_for search_args: sansio.SpMedicationdispense,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Medicationdispense), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.medicationdispense_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.medicationdispense
    },
  )
}

pub fn medicationknowledge_create(
  resource: resources.Medicationknowledge,
  client: FhirClient,
  handle_response: fn(Result(resources.Medicationknowledge, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.medicationknowledge_to_json(resource),
    "MedicationKnowledge",
    resources.medicationknowledge_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationknowledge_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Medicationknowledge, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationKnowledge",
    resources.medicationknowledge_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationknowledge_update(
  resource: resources.Medicationknowledge,
  client: FhirClient,
  handle_response: fn(Result(resources.Medicationknowledge, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.medicationknowledge_to_json(resource),
    "MedicationKnowledge",
    resources.medicationknowledge_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationknowledge_delete(
  resource: resources.Medicationknowledge,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "MedicationKnowledge", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn medicationknowledge_search_bundled(
  search_for search_args: sansio.SpMedicationknowledge,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.medicationknowledge_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn medicationknowledge_search(
  search_for search_args: sansio.SpMedicationknowledge,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Medicationknowledge), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.medicationknowledge_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.medicationknowledge
    },
  )
}

pub fn medicationrequest_create(
  resource: resources.Medicationrequest,
  client: FhirClient,
  handle_response: fn(Result(resources.Medicationrequest, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.medicationrequest_to_json(resource),
    "MedicationRequest",
    resources.medicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Medicationrequest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationRequest",
    resources.medicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationrequest_update(
  resource: resources.Medicationrequest,
  client: FhirClient,
  handle_response: fn(Result(resources.Medicationrequest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.medicationrequest_to_json(resource),
    "MedicationRequest",
    resources.medicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationrequest_delete(
  resource: resources.Medicationrequest,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "MedicationRequest", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn medicationrequest_search_bundled(
  search_for search_args: sansio.SpMedicationrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.medicationrequest_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn medicationrequest_search(
  search_for search_args: sansio.SpMedicationrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Medicationrequest), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.medicationrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.medicationrequest
    },
  )
}

pub fn medicationstatement_create(
  resource: resources.Medicationstatement,
  client: FhirClient,
  handle_response: fn(Result(resources.Medicationstatement, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.medicationstatement_to_json(resource),
    "MedicationStatement",
    resources.medicationstatement_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationstatement_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Medicationstatement, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationStatement",
    resources.medicationstatement_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationstatement_update(
  resource: resources.Medicationstatement,
  client: FhirClient,
  handle_response: fn(Result(resources.Medicationstatement, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.medicationstatement_to_json(resource),
    "MedicationStatement",
    resources.medicationstatement_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationstatement_delete(
  resource: resources.Medicationstatement,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "MedicationStatement", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn medicationstatement_search_bundled(
  search_for search_args: sansio.SpMedicationstatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.medicationstatement_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn medicationstatement_search(
  search_for search_args: sansio.SpMedicationstatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Medicationstatement), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.medicationstatement_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.medicationstatement
    },
  )
}

pub fn medicinalproductdefinition_create(
  resource: resources.Medicinalproductdefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Medicinalproductdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.medicinalproductdefinition_to_json(resource),
    "MedicinalProductDefinition",
    resources.medicinalproductdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Medicinalproductdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductDefinition",
    resources.medicinalproductdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductdefinition_update(
  resource: resources.Medicinalproductdefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Medicinalproductdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.medicinalproductdefinition_to_json(resource),
    "MedicinalProductDefinition",
    resources.medicinalproductdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductdefinition_delete(
  resource: resources.Medicinalproductdefinition,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "MedicinalProductDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn medicinalproductdefinition_search_bundled(
  search_for search_args: sansio.SpMedicinalproductdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.medicinalproductdefinition_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn medicinalproductdefinition_search(
  search_for search_args: sansio.SpMedicinalproductdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Medicinalproductdefinition), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.medicinalproductdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.medicinalproductdefinition
    },
  )
}

pub fn messagedefinition_create(
  resource: resources.Messagedefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Messagedefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.messagedefinition_to_json(resource),
    "MessageDefinition",
    resources.messagedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn messagedefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Messagedefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MessageDefinition",
    resources.messagedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn messagedefinition_update(
  resource: resources.Messagedefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Messagedefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.messagedefinition_to_json(resource),
    "MessageDefinition",
    resources.messagedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn messagedefinition_delete(
  resource: resources.Messagedefinition,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "MessageDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn messagedefinition_search_bundled(
  search_for search_args: sansio.SpMessagedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.messagedefinition_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn messagedefinition_search(
  search_for search_args: sansio.SpMessagedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Messagedefinition), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.messagedefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.messagedefinition
    },
  )
}

pub fn messageheader_create(
  resource: resources.Messageheader,
  client: FhirClient,
  handle_response: fn(Result(resources.Messageheader, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.messageheader_to_json(resource),
    "MessageHeader",
    resources.messageheader_decoder(),
    client,
    handle_response,
  )
}

pub fn messageheader_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Messageheader, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MessageHeader",
    resources.messageheader_decoder(),
    client,
    handle_response,
  )
}

pub fn messageheader_update(
  resource: resources.Messageheader,
  client: FhirClient,
  handle_response: fn(Result(resources.Messageheader, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.messageheader_to_json(resource),
    "MessageHeader",
    resources.messageheader_decoder(),
    client,
    handle_response,
  )
}

pub fn messageheader_delete(
  resource: resources.Messageheader,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "MessageHeader", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn messageheader_search_bundled(
  search_for search_args: sansio.SpMessageheader,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.messageheader_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn messageheader_search(
  search_for search_args: sansio.SpMessageheader,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Messageheader), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.messageheader_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.messageheader },
  )
}

pub fn molecularsequence_create(
  resource: resources.Molecularsequence,
  client: FhirClient,
  handle_response: fn(Result(resources.Molecularsequence, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.molecularsequence_to_json(resource),
    "MolecularSequence",
    resources.molecularsequence_decoder(),
    client,
    handle_response,
  )
}

pub fn molecularsequence_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Molecularsequence, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MolecularSequence",
    resources.molecularsequence_decoder(),
    client,
    handle_response,
  )
}

pub fn molecularsequence_update(
  resource: resources.Molecularsequence,
  client: FhirClient,
  handle_response: fn(Result(resources.Molecularsequence, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.molecularsequence_to_json(resource),
    "MolecularSequence",
    resources.molecularsequence_decoder(),
    client,
    handle_response,
  )
}

pub fn molecularsequence_delete(
  resource: resources.Molecularsequence,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "MolecularSequence", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn molecularsequence_search_bundled(
  search_for search_args: sansio.SpMolecularsequence,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.molecularsequence_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn molecularsequence_search(
  search_for search_args: sansio.SpMolecularsequence,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Molecularsequence), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.molecularsequence_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.molecularsequence
    },
  )
}

pub fn namingsystem_create(
  resource: resources.Namingsystem,
  client: FhirClient,
  handle_response: fn(Result(resources.Namingsystem, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.namingsystem_to_json(resource),
    "NamingSystem",
    resources.namingsystem_decoder(),
    client,
    handle_response,
  )
}

pub fn namingsystem_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Namingsystem, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "NamingSystem",
    resources.namingsystem_decoder(),
    client,
    handle_response,
  )
}

pub fn namingsystem_update(
  resource: resources.Namingsystem,
  client: FhirClient,
  handle_response: fn(Result(resources.Namingsystem, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.namingsystem_to_json(resource),
    "NamingSystem",
    resources.namingsystem_decoder(),
    client,
    handle_response,
  )
}

pub fn namingsystem_delete(
  resource: resources.Namingsystem,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "NamingSystem", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn namingsystem_search_bundled(
  search_for search_args: sansio.SpNamingsystem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.namingsystem_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn namingsystem_search(
  search_for search_args: sansio.SpNamingsystem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Namingsystem), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.namingsystem_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.namingsystem },
  )
}

pub fn nutritionintake_create(
  resource: resources.Nutritionintake,
  client: FhirClient,
  handle_response: fn(Result(resources.Nutritionintake, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.nutritionintake_to_json(resource),
    "NutritionIntake",
    resources.nutritionintake_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionintake_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Nutritionintake, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "NutritionIntake",
    resources.nutritionintake_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionintake_update(
  resource: resources.Nutritionintake,
  client: FhirClient,
  handle_response: fn(Result(resources.Nutritionintake, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.nutritionintake_to_json(resource),
    "NutritionIntake",
    resources.nutritionintake_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionintake_delete(
  resource: resources.Nutritionintake,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "NutritionIntake", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn nutritionintake_search_bundled(
  search_for search_args: sansio.SpNutritionintake,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.nutritionintake_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn nutritionintake_search(
  search_for search_args: sansio.SpNutritionintake,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Nutritionintake), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.nutritionintake_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.nutritionintake
    },
  )
}

pub fn nutritionorder_create(
  resource: resources.Nutritionorder,
  client: FhirClient,
  handle_response: fn(Result(resources.Nutritionorder, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.nutritionorder_to_json(resource),
    "NutritionOrder",
    resources.nutritionorder_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionorder_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Nutritionorder, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "NutritionOrder",
    resources.nutritionorder_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionorder_update(
  resource: resources.Nutritionorder,
  client: FhirClient,
  handle_response: fn(Result(resources.Nutritionorder, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.nutritionorder_to_json(resource),
    "NutritionOrder",
    resources.nutritionorder_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionorder_delete(
  resource: resources.Nutritionorder,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "NutritionOrder", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn nutritionorder_search_bundled(
  search_for search_args: sansio.SpNutritionorder,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.nutritionorder_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn nutritionorder_search(
  search_for search_args: sansio.SpNutritionorder,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Nutritionorder), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.nutritionorder_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.nutritionorder
    },
  )
}

pub fn nutritionproduct_create(
  resource: resources.Nutritionproduct,
  client: FhirClient,
  handle_response: fn(Result(resources.Nutritionproduct, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.nutritionproduct_to_json(resource),
    "NutritionProduct",
    resources.nutritionproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionproduct_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Nutritionproduct, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "NutritionProduct",
    resources.nutritionproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionproduct_update(
  resource: resources.Nutritionproduct,
  client: FhirClient,
  handle_response: fn(Result(resources.Nutritionproduct, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.nutritionproduct_to_json(resource),
    "NutritionProduct",
    resources.nutritionproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionproduct_delete(
  resource: resources.Nutritionproduct,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "NutritionProduct", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn nutritionproduct_search_bundled(
  search_for search_args: sansio.SpNutritionproduct,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.nutritionproduct_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn nutritionproduct_search(
  search_for search_args: sansio.SpNutritionproduct,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Nutritionproduct), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.nutritionproduct_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.nutritionproduct
    },
  )
}

pub fn observation_create(
  resource: resources.Observation,
  client: FhirClient,
  handle_response: fn(Result(resources.Observation, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.observation_to_json(resource),
    "Observation",
    resources.observation_decoder(),
    client,
    handle_response,
  )
}

pub fn observation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Observation, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Observation",
    resources.observation_decoder(),
    client,
    handle_response,
  )
}

pub fn observation_update(
  resource: resources.Observation,
  client: FhirClient,
  handle_response: fn(Result(resources.Observation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.observation_to_json(resource),
    "Observation",
    resources.observation_decoder(),
    client,
    handle_response,
  )
}

pub fn observation_delete(
  resource: resources.Observation,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Observation", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn observation_search_bundled(
  search_for search_args: sansio.SpObservation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.observation_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn observation_search(
  search_for search_args: sansio.SpObservation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Observation), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.observation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.observation },
  )
}

pub fn observationdefinition_create(
  resource: resources.Observationdefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Observationdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.observationdefinition_to_json(resource),
    "ObservationDefinition",
    resources.observationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn observationdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Observationdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ObservationDefinition",
    resources.observationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn observationdefinition_update(
  resource: resources.Observationdefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Observationdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.observationdefinition_to_json(resource),
    "ObservationDefinition",
    resources.observationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn observationdefinition_delete(
  resource: resources.Observationdefinition,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "ObservationDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn observationdefinition_search_bundled(
  search_for search_args: sansio.SpObservationdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.observationdefinition_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn observationdefinition_search(
  search_for search_args: sansio.SpObservationdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Observationdefinition), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.observationdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.observationdefinition
    },
  )
}

pub fn operationdefinition_create(
  resource: resources.Operationdefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Operationdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.operationdefinition_to_json(resource),
    "OperationDefinition",
    resources.operationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn operationdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Operationdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "OperationDefinition",
    resources.operationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn operationdefinition_update(
  resource: resources.Operationdefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Operationdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.operationdefinition_to_json(resource),
    "OperationDefinition",
    resources.operationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn operationdefinition_delete(
  resource: resources.Operationdefinition,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "OperationDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn operationdefinition_search_bundled(
  search_for search_args: sansio.SpOperationdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.operationdefinition_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn operationdefinition_search(
  search_for search_args: sansio.SpOperationdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Operationdefinition), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.operationdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.operationdefinition
    },
  )
}

pub fn operationoutcome_create(
  resource: resources.Operationoutcome,
  client: FhirClient,
  handle_response: fn(Result(resources.Operationoutcome, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.operationoutcome_to_json(resource),
    "OperationOutcome",
    resources.operationoutcome_decoder(),
    client,
    handle_response,
  )
}

pub fn operationoutcome_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Operationoutcome, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "OperationOutcome",
    resources.operationoutcome_decoder(),
    client,
    handle_response,
  )
}

pub fn operationoutcome_update(
  resource: resources.Operationoutcome,
  client: FhirClient,
  handle_response: fn(Result(resources.Operationoutcome, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.operationoutcome_to_json(resource),
    "OperationOutcome",
    resources.operationoutcome_decoder(),
    client,
    handle_response,
  )
}

pub fn operationoutcome_delete(
  resource: resources.Operationoutcome,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "OperationOutcome", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn operationoutcome_search_bundled(
  search_for search_args: sansio.SpOperationoutcome,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.operationoutcome_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn operationoutcome_search(
  search_for search_args: sansio.SpOperationoutcome,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Operationoutcome), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.operationoutcome_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.operationoutcome
    },
  )
}

pub fn organization_create(
  resource: resources.Organization,
  client: FhirClient,
  handle_response: fn(Result(resources.Organization, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.organization_to_json(resource),
    "Organization",
    resources.organization_decoder(),
    client,
    handle_response,
  )
}

pub fn organization_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Organization, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Organization",
    resources.organization_decoder(),
    client,
    handle_response,
  )
}

pub fn organization_update(
  resource: resources.Organization,
  client: FhirClient,
  handle_response: fn(Result(resources.Organization, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.organization_to_json(resource),
    "Organization",
    resources.organization_decoder(),
    client,
    handle_response,
  )
}

pub fn organization_delete(
  resource: resources.Organization,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Organization", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn organization_search_bundled(
  search_for search_args: sansio.SpOrganization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.organization_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn organization_search(
  search_for search_args: sansio.SpOrganization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Organization), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.organization_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.organization },
  )
}

pub fn organizationaffiliation_create(
  resource: resources.Organizationaffiliation,
  client: FhirClient,
  handle_response: fn(Result(resources.Organizationaffiliation, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.organizationaffiliation_to_json(resource),
    "OrganizationAffiliation",
    resources.organizationaffiliation_decoder(),
    client,
    handle_response,
  )
}

pub fn organizationaffiliation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Organizationaffiliation, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "OrganizationAffiliation",
    resources.organizationaffiliation_decoder(),
    client,
    handle_response,
  )
}

pub fn organizationaffiliation_update(
  resource: resources.Organizationaffiliation,
  client: FhirClient,
  handle_response: fn(Result(resources.Organizationaffiliation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.organizationaffiliation_to_json(resource),
    "OrganizationAffiliation",
    resources.organizationaffiliation_decoder(),
    client,
    handle_response,
  )
}

pub fn organizationaffiliation_delete(
  resource: resources.Organizationaffiliation,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "OrganizationAffiliation", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn organizationaffiliation_search_bundled(
  search_for search_args: sansio.SpOrganizationaffiliation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.organizationaffiliation_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn organizationaffiliation_search(
  search_for search_args: sansio.SpOrganizationaffiliation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Organizationaffiliation), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.organizationaffiliation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.organizationaffiliation
    },
  )
}

pub fn packagedproductdefinition_create(
  resource: resources.Packagedproductdefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Packagedproductdefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.packagedproductdefinition_to_json(resource),
    "PackagedProductDefinition",
    resources.packagedproductdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn packagedproductdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Packagedproductdefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "PackagedProductDefinition",
    resources.packagedproductdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn packagedproductdefinition_update(
  resource: resources.Packagedproductdefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Packagedproductdefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.packagedproductdefinition_to_json(resource),
    "PackagedProductDefinition",
    resources.packagedproductdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn packagedproductdefinition_delete(
  resource: resources.Packagedproductdefinition,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "PackagedProductDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn packagedproductdefinition_search_bundled(
  search_for search_args: sansio.SpPackagedproductdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.packagedproductdefinition_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn packagedproductdefinition_search(
  search_for search_args: sansio.SpPackagedproductdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Packagedproductdefinition), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.packagedproductdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.packagedproductdefinition
    },
  )
}

pub fn patient_create(
  resource: resources.Patient,
  client: FhirClient,
  handle_response: fn(Result(resources.Patient, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.patient_to_json(resource),
    "Patient",
    resources.patient_decoder(),
    client,
    handle_response,
  )
}

pub fn patient_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Patient, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Patient", resources.patient_decoder(), client, handle_response)
}

pub fn patient_update(
  resource: resources.Patient,
  client: FhirClient,
  handle_response: fn(Result(resources.Patient, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.patient_to_json(resource),
    "Patient",
    resources.patient_decoder(),
    client,
    handle_response,
  )
}

pub fn patient_delete(
  resource: resources.Patient,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Patient", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn patient_search_bundled(
  search_for search_args: sansio.SpPatient,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.patient_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn patient_search(
  search_for search_args: sansio.SpPatient,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Patient), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.patient_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.patient },
  )
}

pub fn paymentnotice_create(
  resource: resources.Paymentnotice,
  client: FhirClient,
  handle_response: fn(Result(resources.Paymentnotice, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.paymentnotice_to_json(resource),
    "PaymentNotice",
    resources.paymentnotice_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentnotice_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Paymentnotice, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "PaymentNotice",
    resources.paymentnotice_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentnotice_update(
  resource: resources.Paymentnotice,
  client: FhirClient,
  handle_response: fn(Result(resources.Paymentnotice, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.paymentnotice_to_json(resource),
    "PaymentNotice",
    resources.paymentnotice_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentnotice_delete(
  resource: resources.Paymentnotice,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "PaymentNotice", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn paymentnotice_search_bundled(
  search_for search_args: sansio.SpPaymentnotice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.paymentnotice_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn paymentnotice_search(
  search_for search_args: sansio.SpPaymentnotice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Paymentnotice), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.paymentnotice_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.paymentnotice },
  )
}

pub fn paymentreconciliation_create(
  resource: resources.Paymentreconciliation,
  client: FhirClient,
  handle_response: fn(Result(resources.Paymentreconciliation, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.paymentreconciliation_to_json(resource),
    "PaymentReconciliation",
    resources.paymentreconciliation_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentreconciliation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Paymentreconciliation, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "PaymentReconciliation",
    resources.paymentreconciliation_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentreconciliation_update(
  resource: resources.Paymentreconciliation,
  client: FhirClient,
  handle_response: fn(Result(resources.Paymentreconciliation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.paymentreconciliation_to_json(resource),
    "PaymentReconciliation",
    resources.paymentreconciliation_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentreconciliation_delete(
  resource: resources.Paymentreconciliation,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "PaymentReconciliation", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn paymentreconciliation_search_bundled(
  search_for search_args: sansio.SpPaymentreconciliation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.paymentreconciliation_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn paymentreconciliation_search(
  search_for search_args: sansio.SpPaymentreconciliation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Paymentreconciliation), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.paymentreconciliation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.paymentreconciliation
    },
  )
}

pub fn permission_create(
  resource: resources.Permission,
  client: FhirClient,
  handle_response: fn(Result(resources.Permission, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.permission_to_json(resource),
    "Permission",
    resources.permission_decoder(),
    client,
    handle_response,
  )
}

pub fn permission_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Permission, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Permission",
    resources.permission_decoder(),
    client,
    handle_response,
  )
}

pub fn permission_update(
  resource: resources.Permission,
  client: FhirClient,
  handle_response: fn(Result(resources.Permission, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.permission_to_json(resource),
    "Permission",
    resources.permission_decoder(),
    client,
    handle_response,
  )
}

pub fn permission_delete(
  resource: resources.Permission,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Permission", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn permission_search_bundled(
  search_for search_args: sansio.SpPermission,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.permission_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn permission_search(
  search_for search_args: sansio.SpPermission,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Permission), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.permission_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.permission },
  )
}

pub fn person_create(
  resource: resources.Person,
  client: FhirClient,
  handle_response: fn(Result(resources.Person, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.person_to_json(resource),
    "Person",
    resources.person_decoder(),
    client,
    handle_response,
  )
}

pub fn person_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Person, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Person", resources.person_decoder(), client, handle_response)
}

pub fn person_update(
  resource: resources.Person,
  client: FhirClient,
  handle_response: fn(Result(resources.Person, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.person_to_json(resource),
    "Person",
    resources.person_decoder(),
    client,
    handle_response,
  )
}

pub fn person_delete(
  resource: resources.Person,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Person", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn person_search_bundled(
  search_for search_args: sansio.SpPerson,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.person_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn person_search(
  search_for search_args: sansio.SpPerson,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Person), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.person_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.person },
  )
}

pub fn plandefinition_create(
  resource: resources.Plandefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Plandefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.plandefinition_to_json(resource),
    "PlanDefinition",
    resources.plandefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn plandefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Plandefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "PlanDefinition",
    resources.plandefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn plandefinition_update(
  resource: resources.Plandefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Plandefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.plandefinition_to_json(resource),
    "PlanDefinition",
    resources.plandefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn plandefinition_delete(
  resource: resources.Plandefinition,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "PlanDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn plandefinition_search_bundled(
  search_for search_args: sansio.SpPlandefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.plandefinition_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn plandefinition_search(
  search_for search_args: sansio.SpPlandefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Plandefinition), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.plandefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.plandefinition
    },
  )
}

pub fn practitioner_create(
  resource: resources.Practitioner,
  client: FhirClient,
  handle_response: fn(Result(resources.Practitioner, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.practitioner_to_json(resource),
    "Practitioner",
    resources.practitioner_decoder(),
    client,
    handle_response,
  )
}

pub fn practitioner_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Practitioner, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Practitioner",
    resources.practitioner_decoder(),
    client,
    handle_response,
  )
}

pub fn practitioner_update(
  resource: resources.Practitioner,
  client: FhirClient,
  handle_response: fn(Result(resources.Practitioner, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.practitioner_to_json(resource),
    "Practitioner",
    resources.practitioner_decoder(),
    client,
    handle_response,
  )
}

pub fn practitioner_delete(
  resource: resources.Practitioner,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Practitioner", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn practitioner_search_bundled(
  search_for search_args: sansio.SpPractitioner,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.practitioner_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn practitioner_search(
  search_for search_args: sansio.SpPractitioner,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Practitioner), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.practitioner_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.practitioner },
  )
}

pub fn practitionerrole_create(
  resource: resources.Practitionerrole,
  client: FhirClient,
  handle_response: fn(Result(resources.Practitionerrole, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.practitionerrole_to_json(resource),
    "PractitionerRole",
    resources.practitionerrole_decoder(),
    client,
    handle_response,
  )
}

pub fn practitionerrole_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Practitionerrole, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "PractitionerRole",
    resources.practitionerrole_decoder(),
    client,
    handle_response,
  )
}

pub fn practitionerrole_update(
  resource: resources.Practitionerrole,
  client: FhirClient,
  handle_response: fn(Result(resources.Practitionerrole, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.practitionerrole_to_json(resource),
    "PractitionerRole",
    resources.practitionerrole_decoder(),
    client,
    handle_response,
  )
}

pub fn practitionerrole_delete(
  resource: resources.Practitionerrole,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "PractitionerRole", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn practitionerrole_search_bundled(
  search_for search_args: sansio.SpPractitionerrole,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.practitionerrole_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn practitionerrole_search(
  search_for search_args: sansio.SpPractitionerrole,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Practitionerrole), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.practitionerrole_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.practitionerrole
    },
  )
}

pub fn procedure_create(
  resource: resources.Procedure,
  client: FhirClient,
  handle_response: fn(Result(resources.Procedure, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.procedure_to_json(resource),
    "Procedure",
    resources.procedure_decoder(),
    client,
    handle_response,
  )
}

pub fn procedure_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Procedure, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Procedure",
    resources.procedure_decoder(),
    client,
    handle_response,
  )
}

pub fn procedure_update(
  resource: resources.Procedure,
  client: FhirClient,
  handle_response: fn(Result(resources.Procedure, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.procedure_to_json(resource),
    "Procedure",
    resources.procedure_decoder(),
    client,
    handle_response,
  )
}

pub fn procedure_delete(
  resource: resources.Procedure,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Procedure", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn procedure_search_bundled(
  search_for search_args: sansio.SpProcedure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.procedure_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn procedure_search(
  search_for search_args: sansio.SpProcedure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Procedure), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.procedure_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.procedure },
  )
}

pub fn provenance_create(
  resource: resources.Provenance,
  client: FhirClient,
  handle_response: fn(Result(resources.Provenance, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.provenance_to_json(resource),
    "Provenance",
    resources.provenance_decoder(),
    client,
    handle_response,
  )
}

pub fn provenance_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Provenance, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Provenance",
    resources.provenance_decoder(),
    client,
    handle_response,
  )
}

pub fn provenance_update(
  resource: resources.Provenance,
  client: FhirClient,
  handle_response: fn(Result(resources.Provenance, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.provenance_to_json(resource),
    "Provenance",
    resources.provenance_decoder(),
    client,
    handle_response,
  )
}

pub fn provenance_delete(
  resource: resources.Provenance,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Provenance", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn provenance_search_bundled(
  search_for search_args: sansio.SpProvenance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.provenance_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn provenance_search(
  search_for search_args: sansio.SpProvenance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Provenance), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.provenance_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.provenance },
  )
}

pub fn questionnaire_create(
  resource: resources.Questionnaire,
  client: FhirClient,
  handle_response: fn(Result(resources.Questionnaire, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.questionnaire_to_json(resource),
    "Questionnaire",
    resources.questionnaire_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaire_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Questionnaire, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Questionnaire",
    resources.questionnaire_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaire_update(
  resource: resources.Questionnaire,
  client: FhirClient,
  handle_response: fn(Result(resources.Questionnaire, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.questionnaire_to_json(resource),
    "Questionnaire",
    resources.questionnaire_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaire_delete(
  resource: resources.Questionnaire,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Questionnaire", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn questionnaire_search_bundled(
  search_for search_args: sansio.SpQuestionnaire,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.questionnaire_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn questionnaire_search(
  search_for search_args: sansio.SpQuestionnaire,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Questionnaire), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.questionnaire_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.questionnaire },
  )
}

pub fn questionnaireresponse_create(
  resource: resources.Questionnaireresponse,
  client: FhirClient,
  handle_response: fn(Result(resources.Questionnaireresponse, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    resources.questionnaireresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaireresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Questionnaireresponse, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "QuestionnaireResponse",
    resources.questionnaireresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaireresponse_update(
  resource: resources.Questionnaireresponse,
  client: FhirClient,
  handle_response: fn(Result(resources.Questionnaireresponse, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    resources.questionnaireresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaireresponse_delete(
  resource: resources.Questionnaireresponse,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "QuestionnaireResponse", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn questionnaireresponse_search_bundled(
  search_for search_args: sansio.SpQuestionnaireresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.questionnaireresponse_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn questionnaireresponse_search(
  search_for search_args: sansio.SpQuestionnaireresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Questionnaireresponse), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.questionnaireresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.questionnaireresponse
    },
  )
}

pub fn regulatedauthorization_create(
  resource: resources.Regulatedauthorization,
  client: FhirClient,
  handle_response: fn(Result(resources.Regulatedauthorization, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.regulatedauthorization_to_json(resource),
    "RegulatedAuthorization",
    resources.regulatedauthorization_decoder(),
    client,
    handle_response,
  )
}

pub fn regulatedauthorization_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Regulatedauthorization, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "RegulatedAuthorization",
    resources.regulatedauthorization_decoder(),
    client,
    handle_response,
  )
}

pub fn regulatedauthorization_update(
  resource: resources.Regulatedauthorization,
  client: FhirClient,
  handle_response: fn(Result(resources.Regulatedauthorization, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.regulatedauthorization_to_json(resource),
    "RegulatedAuthorization",
    resources.regulatedauthorization_decoder(),
    client,
    handle_response,
  )
}

pub fn regulatedauthorization_delete(
  resource: resources.Regulatedauthorization,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "RegulatedAuthorization", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn regulatedauthorization_search_bundled(
  search_for search_args: sansio.SpRegulatedauthorization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.regulatedauthorization_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn regulatedauthorization_search(
  search_for search_args: sansio.SpRegulatedauthorization,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Regulatedauthorization), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.regulatedauthorization_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.regulatedauthorization
    },
  )
}

pub fn relatedperson_create(
  resource: resources.Relatedperson,
  client: FhirClient,
  handle_response: fn(Result(resources.Relatedperson, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.relatedperson_to_json(resource),
    "RelatedPerson",
    resources.relatedperson_decoder(),
    client,
    handle_response,
  )
}

pub fn relatedperson_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Relatedperson, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "RelatedPerson",
    resources.relatedperson_decoder(),
    client,
    handle_response,
  )
}

pub fn relatedperson_update(
  resource: resources.Relatedperson,
  client: FhirClient,
  handle_response: fn(Result(resources.Relatedperson, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.relatedperson_to_json(resource),
    "RelatedPerson",
    resources.relatedperson_decoder(),
    client,
    handle_response,
  )
}

pub fn relatedperson_delete(
  resource: resources.Relatedperson,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "RelatedPerson", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn relatedperson_search_bundled(
  search_for search_args: sansio.SpRelatedperson,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.relatedperson_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn relatedperson_search(
  search_for search_args: sansio.SpRelatedperson,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Relatedperson), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.relatedperson_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.relatedperson },
  )
}

pub fn requestorchestration_create(
  resource: resources.Requestorchestration,
  client: FhirClient,
  handle_response: fn(Result(resources.Requestorchestration, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.requestorchestration_to_json(resource),
    "RequestOrchestration",
    resources.requestorchestration_decoder(),
    client,
    handle_response,
  )
}

pub fn requestorchestration_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Requestorchestration, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "RequestOrchestration",
    resources.requestorchestration_decoder(),
    client,
    handle_response,
  )
}

pub fn requestorchestration_update(
  resource: resources.Requestorchestration,
  client: FhirClient,
  handle_response: fn(Result(resources.Requestorchestration, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.requestorchestration_to_json(resource),
    "RequestOrchestration",
    resources.requestorchestration_decoder(),
    client,
    handle_response,
  )
}

pub fn requestorchestration_delete(
  resource: resources.Requestorchestration,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "RequestOrchestration", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn requestorchestration_search_bundled(
  search_for search_args: sansio.SpRequestorchestration,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.requestorchestration_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn requestorchestration_search(
  search_for search_args: sansio.SpRequestorchestration,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Requestorchestration), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.requestorchestration_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.requestorchestration
    },
  )
}

pub fn requirements_create(
  resource: resources.Requirements,
  client: FhirClient,
  handle_response: fn(Result(resources.Requirements, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.requirements_to_json(resource),
    "Requirements",
    resources.requirements_decoder(),
    client,
    handle_response,
  )
}

pub fn requirements_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Requirements, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Requirements",
    resources.requirements_decoder(),
    client,
    handle_response,
  )
}

pub fn requirements_update(
  resource: resources.Requirements,
  client: FhirClient,
  handle_response: fn(Result(resources.Requirements, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.requirements_to_json(resource),
    "Requirements",
    resources.requirements_decoder(),
    client,
    handle_response,
  )
}

pub fn requirements_delete(
  resource: resources.Requirements,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Requirements", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn requirements_search_bundled(
  search_for search_args: sansio.SpRequirements,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.requirements_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn requirements_search(
  search_for search_args: sansio.SpRequirements,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Requirements), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.requirements_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.requirements },
  )
}

pub fn researchstudy_create(
  resource: resources.Researchstudy,
  client: FhirClient,
  handle_response: fn(Result(resources.Researchstudy, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.researchstudy_to_json(resource),
    "ResearchStudy",
    resources.researchstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn researchstudy_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Researchstudy, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ResearchStudy",
    resources.researchstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn researchstudy_update(
  resource: resources.Researchstudy,
  client: FhirClient,
  handle_response: fn(Result(resources.Researchstudy, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.researchstudy_to_json(resource),
    "ResearchStudy",
    resources.researchstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn researchstudy_delete(
  resource: resources.Researchstudy,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "ResearchStudy", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn researchstudy_search_bundled(
  search_for search_args: sansio.SpResearchstudy,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.researchstudy_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn researchstudy_search(
  search_for search_args: sansio.SpResearchstudy,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Researchstudy), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.researchstudy_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.researchstudy },
  )
}

pub fn researchsubject_create(
  resource: resources.Researchsubject,
  client: FhirClient,
  handle_response: fn(Result(resources.Researchsubject, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.researchsubject_to_json(resource),
    "ResearchSubject",
    resources.researchsubject_decoder(),
    client,
    handle_response,
  )
}

pub fn researchsubject_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Researchsubject, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ResearchSubject",
    resources.researchsubject_decoder(),
    client,
    handle_response,
  )
}

pub fn researchsubject_update(
  resource: resources.Researchsubject,
  client: FhirClient,
  handle_response: fn(Result(resources.Researchsubject, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.researchsubject_to_json(resource),
    "ResearchSubject",
    resources.researchsubject_decoder(),
    client,
    handle_response,
  )
}

pub fn researchsubject_delete(
  resource: resources.Researchsubject,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "ResearchSubject", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn researchsubject_search_bundled(
  search_for search_args: sansio.SpResearchsubject,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.researchsubject_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn researchsubject_search(
  search_for search_args: sansio.SpResearchsubject,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Researchsubject), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.researchsubject_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.researchsubject
    },
  )
}

pub fn riskassessment_create(
  resource: resources.Riskassessment,
  client: FhirClient,
  handle_response: fn(Result(resources.Riskassessment, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.riskassessment_to_json(resource),
    "RiskAssessment",
    resources.riskassessment_decoder(),
    client,
    handle_response,
  )
}

pub fn riskassessment_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Riskassessment, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "RiskAssessment",
    resources.riskassessment_decoder(),
    client,
    handle_response,
  )
}

pub fn riskassessment_update(
  resource: resources.Riskassessment,
  client: FhirClient,
  handle_response: fn(Result(resources.Riskassessment, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.riskassessment_to_json(resource),
    "RiskAssessment",
    resources.riskassessment_decoder(),
    client,
    handle_response,
  )
}

pub fn riskassessment_delete(
  resource: resources.Riskassessment,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "RiskAssessment", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn riskassessment_search_bundled(
  search_for search_args: sansio.SpRiskassessment,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.riskassessment_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn riskassessment_search(
  search_for search_args: sansio.SpRiskassessment,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Riskassessment), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.riskassessment_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.riskassessment
    },
  )
}

pub fn schedule_create(
  resource: resources.Schedule,
  client: FhirClient,
  handle_response: fn(Result(resources.Schedule, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.schedule_to_json(resource),
    "Schedule",
    resources.schedule_decoder(),
    client,
    handle_response,
  )
}

pub fn schedule_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Schedule, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Schedule",
    resources.schedule_decoder(),
    client,
    handle_response,
  )
}

pub fn schedule_update(
  resource: resources.Schedule,
  client: FhirClient,
  handle_response: fn(Result(resources.Schedule, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.schedule_to_json(resource),
    "Schedule",
    resources.schedule_decoder(),
    client,
    handle_response,
  )
}

pub fn schedule_delete(
  resource: resources.Schedule,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Schedule", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn schedule_search_bundled(
  search_for search_args: sansio.SpSchedule,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.schedule_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn schedule_search(
  search_for search_args: sansio.SpSchedule,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Schedule), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.schedule_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.schedule },
  )
}

pub fn searchparameter_create(
  resource: resources.Searchparameter,
  client: FhirClient,
  handle_response: fn(Result(resources.Searchparameter, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.searchparameter_to_json(resource),
    "SearchParameter",
    resources.searchparameter_decoder(),
    client,
    handle_response,
  )
}

pub fn searchparameter_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Searchparameter, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SearchParameter",
    resources.searchparameter_decoder(),
    client,
    handle_response,
  )
}

pub fn searchparameter_update(
  resource: resources.Searchparameter,
  client: FhirClient,
  handle_response: fn(Result(resources.Searchparameter, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.searchparameter_to_json(resource),
    "SearchParameter",
    resources.searchparameter_decoder(),
    client,
    handle_response,
  )
}

pub fn searchparameter_delete(
  resource: resources.Searchparameter,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "SearchParameter", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn searchparameter_search_bundled(
  search_for search_args: sansio.SpSearchparameter,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.searchparameter_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn searchparameter_search(
  search_for search_args: sansio.SpSearchparameter,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Searchparameter), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.searchparameter_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.searchparameter
    },
  )
}

pub fn servicerequest_create(
  resource: resources.Servicerequest,
  client: FhirClient,
  handle_response: fn(Result(resources.Servicerequest, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.servicerequest_to_json(resource),
    "ServiceRequest",
    resources.servicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn servicerequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Servicerequest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ServiceRequest",
    resources.servicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn servicerequest_update(
  resource: resources.Servicerequest,
  client: FhirClient,
  handle_response: fn(Result(resources.Servicerequest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.servicerequest_to_json(resource),
    "ServiceRequest",
    resources.servicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn servicerequest_delete(
  resource: resources.Servicerequest,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "ServiceRequest", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn servicerequest_search_bundled(
  search_for search_args: sansio.SpServicerequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.servicerequest_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn servicerequest_search(
  search_for search_args: sansio.SpServicerequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Servicerequest), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.servicerequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.servicerequest
    },
  )
}

pub fn slot_create(
  resource: resources.Slot,
  client: FhirClient,
  handle_response: fn(Result(resources.Slot, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.slot_to_json(resource),
    "Slot",
    resources.slot_decoder(),
    client,
    handle_response,
  )
}

pub fn slot_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Slot, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Slot", resources.slot_decoder(), client, handle_response)
}

pub fn slot_update(
  resource: resources.Slot,
  client: FhirClient,
  handle_response: fn(Result(resources.Slot, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.slot_to_json(resource),
    "Slot",
    resources.slot_decoder(),
    client,
    handle_response,
  )
}

pub fn slot_delete(
  resource: resources.Slot,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Slot", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn slot_search_bundled(
  search_for search_args: sansio.SpSlot,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.slot_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn slot_search(
  search_for search_args: sansio.SpSlot,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Slot), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.slot_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.slot },
  )
}

pub fn specimen_create(
  resource: resources.Specimen,
  client: FhirClient,
  handle_response: fn(Result(resources.Specimen, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.specimen_to_json(resource),
    "Specimen",
    resources.specimen_decoder(),
    client,
    handle_response,
  )
}

pub fn specimen_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Specimen, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Specimen",
    resources.specimen_decoder(),
    client,
    handle_response,
  )
}

pub fn specimen_update(
  resource: resources.Specimen,
  client: FhirClient,
  handle_response: fn(Result(resources.Specimen, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.specimen_to_json(resource),
    "Specimen",
    resources.specimen_decoder(),
    client,
    handle_response,
  )
}

pub fn specimen_delete(
  resource: resources.Specimen,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Specimen", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn specimen_search_bundled(
  search_for search_args: sansio.SpSpecimen,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.specimen_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn specimen_search(
  search_for search_args: sansio.SpSpecimen,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Specimen), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.specimen_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.specimen },
  )
}

pub fn specimendefinition_create(
  resource: resources.Specimendefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Specimendefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.specimendefinition_to_json(resource),
    "SpecimenDefinition",
    resources.specimendefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn specimendefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Specimendefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SpecimenDefinition",
    resources.specimendefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn specimendefinition_update(
  resource: resources.Specimendefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Specimendefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.specimendefinition_to_json(resource),
    "SpecimenDefinition",
    resources.specimendefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn specimendefinition_delete(
  resource: resources.Specimendefinition,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "SpecimenDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn specimendefinition_search_bundled(
  search_for search_args: sansio.SpSpecimendefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.specimendefinition_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn specimendefinition_search(
  search_for search_args: sansio.SpSpecimendefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Specimendefinition), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.specimendefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.specimendefinition
    },
  )
}

pub fn structuredefinition_create(
  resource: resources.Structuredefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Structuredefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.structuredefinition_to_json(resource),
    "StructureDefinition",
    resources.structuredefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn structuredefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Structuredefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "StructureDefinition",
    resources.structuredefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn structuredefinition_update(
  resource: resources.Structuredefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Structuredefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.structuredefinition_to_json(resource),
    "StructureDefinition",
    resources.structuredefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn structuredefinition_delete(
  resource: resources.Structuredefinition,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "StructureDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn structuredefinition_search_bundled(
  search_for search_args: sansio.SpStructuredefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.structuredefinition_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn structuredefinition_search(
  search_for search_args: sansio.SpStructuredefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Structuredefinition), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.structuredefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.structuredefinition
    },
  )
}

pub fn structuremap_create(
  resource: resources.Structuremap,
  client: FhirClient,
  handle_response: fn(Result(resources.Structuremap, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.structuremap_to_json(resource),
    "StructureMap",
    resources.structuremap_decoder(),
    client,
    handle_response,
  )
}

pub fn structuremap_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Structuremap, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "StructureMap",
    resources.structuremap_decoder(),
    client,
    handle_response,
  )
}

pub fn structuremap_update(
  resource: resources.Structuremap,
  client: FhirClient,
  handle_response: fn(Result(resources.Structuremap, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.structuremap_to_json(resource),
    "StructureMap",
    resources.structuremap_decoder(),
    client,
    handle_response,
  )
}

pub fn structuremap_delete(
  resource: resources.Structuremap,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "StructureMap", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn structuremap_search_bundled(
  search_for search_args: sansio.SpStructuremap,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.structuremap_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn structuremap_search(
  search_for search_args: sansio.SpStructuremap,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Structuremap), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.structuremap_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.structuremap },
  )
}

pub fn subscription_create(
  resource: resources.Subscription,
  client: FhirClient,
  handle_response: fn(Result(resources.Subscription, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.subscription_to_json(resource),
    "Subscription",
    resources.subscription_decoder(),
    client,
    handle_response,
  )
}

pub fn subscription_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Subscription, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Subscription",
    resources.subscription_decoder(),
    client,
    handle_response,
  )
}

pub fn subscription_update(
  resource: resources.Subscription,
  client: FhirClient,
  handle_response: fn(Result(resources.Subscription, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.subscription_to_json(resource),
    "Subscription",
    resources.subscription_decoder(),
    client,
    handle_response,
  )
}

pub fn subscription_delete(
  resource: resources.Subscription,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Subscription", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn subscription_search_bundled(
  search_for search_args: sansio.SpSubscription,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.subscription_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn subscription_search(
  search_for search_args: sansio.SpSubscription,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Subscription), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.subscription_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.subscription },
  )
}

pub fn subscriptionstatus_create(
  resource: resources.Subscriptionstatus,
  client: FhirClient,
  handle_response: fn(Result(resources.Subscriptionstatus, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.subscriptionstatus_to_json(resource),
    "SubscriptionStatus",
    resources.subscriptionstatus_decoder(),
    client,
    handle_response,
  )
}

pub fn subscriptionstatus_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Subscriptionstatus, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubscriptionStatus",
    resources.subscriptionstatus_decoder(),
    client,
    handle_response,
  )
}

pub fn subscriptionstatus_update(
  resource: resources.Subscriptionstatus,
  client: FhirClient,
  handle_response: fn(Result(resources.Subscriptionstatus, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.subscriptionstatus_to_json(resource),
    "SubscriptionStatus",
    resources.subscriptionstatus_decoder(),
    client,
    handle_response,
  )
}

pub fn subscriptionstatus_delete(
  resource: resources.Subscriptionstatus,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "SubscriptionStatus", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn subscriptionstatus_search_bundled(
  search_for search_args: sansio.SpSubscriptionstatus,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.subscriptionstatus_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn subscriptionstatus_search(
  search_for search_args: sansio.SpSubscriptionstatus,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Subscriptionstatus), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.subscriptionstatus_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.subscriptionstatus
    },
  )
}

pub fn subscriptiontopic_create(
  resource: resources.Subscriptiontopic,
  client: FhirClient,
  handle_response: fn(Result(resources.Subscriptiontopic, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.subscriptiontopic_to_json(resource),
    "SubscriptionTopic",
    resources.subscriptiontopic_decoder(),
    client,
    handle_response,
  )
}

pub fn subscriptiontopic_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Subscriptiontopic, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubscriptionTopic",
    resources.subscriptiontopic_decoder(),
    client,
    handle_response,
  )
}

pub fn subscriptiontopic_update(
  resource: resources.Subscriptiontopic,
  client: FhirClient,
  handle_response: fn(Result(resources.Subscriptiontopic, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.subscriptiontopic_to_json(resource),
    "SubscriptionTopic",
    resources.subscriptiontopic_decoder(),
    client,
    handle_response,
  )
}

pub fn subscriptiontopic_delete(
  resource: resources.Subscriptiontopic,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "SubscriptionTopic", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn subscriptiontopic_search_bundled(
  search_for search_args: sansio.SpSubscriptiontopic,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.subscriptiontopic_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn subscriptiontopic_search(
  search_for search_args: sansio.SpSubscriptiontopic,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Subscriptiontopic), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.subscriptiontopic_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.subscriptiontopic
    },
  )
}

pub fn substance_create(
  resource: resources.Substance,
  client: FhirClient,
  handle_response: fn(Result(resources.Substance, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.substance_to_json(resource),
    "Substance",
    resources.substance_decoder(),
    client,
    handle_response,
  )
}

pub fn substance_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Substance, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Substance",
    resources.substance_decoder(),
    client,
    handle_response,
  )
}

pub fn substance_update(
  resource: resources.Substance,
  client: FhirClient,
  handle_response: fn(Result(resources.Substance, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.substance_to_json(resource),
    "Substance",
    resources.substance_decoder(),
    client,
    handle_response,
  )
}

pub fn substance_delete(
  resource: resources.Substance,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Substance", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn substance_search_bundled(
  search_for search_args: sansio.SpSubstance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.substance_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn substance_search(
  search_for search_args: sansio.SpSubstance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Substance), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.substance_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.substance },
  )
}

pub fn substancedefinition_create(
  resource: resources.Substancedefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Substancedefinition, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.substancedefinition_to_json(resource),
    "SubstanceDefinition",
    resources.substancedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn substancedefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Substancedefinition, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstanceDefinition",
    resources.substancedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn substancedefinition_update(
  resource: resources.Substancedefinition,
  client: FhirClient,
  handle_response: fn(Result(resources.Substancedefinition, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.substancedefinition_to_json(resource),
    "SubstanceDefinition",
    resources.substancedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn substancedefinition_delete(
  resource: resources.Substancedefinition,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "SubstanceDefinition", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn substancedefinition_search_bundled(
  search_for search_args: sansio.SpSubstancedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.substancedefinition_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn substancedefinition_search(
  search_for search_args: sansio.SpSubstancedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Substancedefinition), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.substancedefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.substancedefinition
    },
  )
}

pub fn substancenucleicacid_create(
  resource: resources.Substancenucleicacid,
  client: FhirClient,
  handle_response: fn(Result(resources.Substancenucleicacid, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.substancenucleicacid_to_json(resource),
    "SubstanceNucleicAcid",
    resources.substancenucleicacid_decoder(),
    client,
    handle_response,
  )
}

pub fn substancenucleicacid_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Substancenucleicacid, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstanceNucleicAcid",
    resources.substancenucleicacid_decoder(),
    client,
    handle_response,
  )
}

pub fn substancenucleicacid_update(
  resource: resources.Substancenucleicacid,
  client: FhirClient,
  handle_response: fn(Result(resources.Substancenucleicacid, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.substancenucleicacid_to_json(resource),
    "SubstanceNucleicAcid",
    resources.substancenucleicacid_decoder(),
    client,
    handle_response,
  )
}

pub fn substancenucleicacid_delete(
  resource: resources.Substancenucleicacid,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "SubstanceNucleicAcid", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn substancenucleicacid_search_bundled(
  search_for search_args: sansio.SpSubstancenucleicacid,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.substancenucleicacid_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn substancenucleicacid_search(
  search_for search_args: sansio.SpSubstancenucleicacid,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Substancenucleicacid), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.substancenucleicacid_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.substancenucleicacid
    },
  )
}

pub fn substancepolymer_create(
  resource: resources.Substancepolymer,
  client: FhirClient,
  handle_response: fn(Result(resources.Substancepolymer, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.substancepolymer_to_json(resource),
    "SubstancePolymer",
    resources.substancepolymer_decoder(),
    client,
    handle_response,
  )
}

pub fn substancepolymer_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Substancepolymer, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstancePolymer",
    resources.substancepolymer_decoder(),
    client,
    handle_response,
  )
}

pub fn substancepolymer_update(
  resource: resources.Substancepolymer,
  client: FhirClient,
  handle_response: fn(Result(resources.Substancepolymer, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.substancepolymer_to_json(resource),
    "SubstancePolymer",
    resources.substancepolymer_decoder(),
    client,
    handle_response,
  )
}

pub fn substancepolymer_delete(
  resource: resources.Substancepolymer,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "SubstancePolymer", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn substancepolymer_search_bundled(
  search_for search_args: sansio.SpSubstancepolymer,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.substancepolymer_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn substancepolymer_search(
  search_for search_args: sansio.SpSubstancepolymer,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Substancepolymer), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.substancepolymer_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.substancepolymer
    },
  )
}

pub fn substanceprotein_create(
  resource: resources.Substanceprotein,
  client: FhirClient,
  handle_response: fn(Result(resources.Substanceprotein, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.substanceprotein_to_json(resource),
    "SubstanceProtein",
    resources.substanceprotein_decoder(),
    client,
    handle_response,
  )
}

pub fn substanceprotein_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Substanceprotein, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstanceProtein",
    resources.substanceprotein_decoder(),
    client,
    handle_response,
  )
}

pub fn substanceprotein_update(
  resource: resources.Substanceprotein,
  client: FhirClient,
  handle_response: fn(Result(resources.Substanceprotein, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.substanceprotein_to_json(resource),
    "SubstanceProtein",
    resources.substanceprotein_decoder(),
    client,
    handle_response,
  )
}

pub fn substanceprotein_delete(
  resource: resources.Substanceprotein,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "SubstanceProtein", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn substanceprotein_search_bundled(
  search_for search_args: sansio.SpSubstanceprotein,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.substanceprotein_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn substanceprotein_search(
  search_for search_args: sansio.SpSubstanceprotein,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Substanceprotein), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.substanceprotein_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.substanceprotein
    },
  )
}

pub fn substancereferenceinformation_create(
  resource: resources.Substancereferenceinformation,
  client: FhirClient,
  handle_response: fn(Result(resources.Substancereferenceinformation, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.substancereferenceinformation_to_json(resource),
    "SubstanceReferenceInformation",
    resources.substancereferenceinformation_decoder(),
    client,
    handle_response,
  )
}

pub fn substancereferenceinformation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Substancereferenceinformation, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstanceReferenceInformation",
    resources.substancereferenceinformation_decoder(),
    client,
    handle_response,
  )
}

pub fn substancereferenceinformation_update(
  resource: resources.Substancereferenceinformation,
  client: FhirClient,
  handle_response: fn(Result(resources.Substancereferenceinformation, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.substancereferenceinformation_to_json(resource),
    "SubstanceReferenceInformation",
    resources.substancereferenceinformation_decoder(),
    client,
    handle_response,
  )
}

pub fn substancereferenceinformation_delete(
  resource: resources.Substancereferenceinformation,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
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
  search_for search_args: sansio.SpSubstancereferenceinformation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.substancereferenceinformation_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn substancereferenceinformation_search(
  search_for search_args: sansio.SpSubstancereferenceinformation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Substancereferenceinformation), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.substancereferenceinformation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.substancereferenceinformation
    },
  )
}

pub fn substancesourcematerial_create(
  resource: resources.Substancesourcematerial,
  client: FhirClient,
  handle_response: fn(Result(resources.Substancesourcematerial, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.substancesourcematerial_to_json(resource),
    "SubstanceSourceMaterial",
    resources.substancesourcematerial_decoder(),
    client,
    handle_response,
  )
}

pub fn substancesourcematerial_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Substancesourcematerial, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstanceSourceMaterial",
    resources.substancesourcematerial_decoder(),
    client,
    handle_response,
  )
}

pub fn substancesourcematerial_update(
  resource: resources.Substancesourcematerial,
  client: FhirClient,
  handle_response: fn(Result(resources.Substancesourcematerial, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.substancesourcematerial_to_json(resource),
    "SubstanceSourceMaterial",
    resources.substancesourcematerial_decoder(),
    client,
    handle_response,
  )
}

pub fn substancesourcematerial_delete(
  resource: resources.Substancesourcematerial,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "SubstanceSourceMaterial", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn substancesourcematerial_search_bundled(
  search_for search_args: sansio.SpSubstancesourcematerial,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.substancesourcematerial_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn substancesourcematerial_search(
  search_for search_args: sansio.SpSubstancesourcematerial,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Substancesourcematerial), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.substancesourcematerial_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.substancesourcematerial
    },
  )
}

pub fn supplydelivery_create(
  resource: resources.Supplydelivery,
  client: FhirClient,
  handle_response: fn(Result(resources.Supplydelivery, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.supplydelivery_to_json(resource),
    "SupplyDelivery",
    resources.supplydelivery_decoder(),
    client,
    handle_response,
  )
}

pub fn supplydelivery_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Supplydelivery, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SupplyDelivery",
    resources.supplydelivery_decoder(),
    client,
    handle_response,
  )
}

pub fn supplydelivery_update(
  resource: resources.Supplydelivery,
  client: FhirClient,
  handle_response: fn(Result(resources.Supplydelivery, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.supplydelivery_to_json(resource),
    "SupplyDelivery",
    resources.supplydelivery_decoder(),
    client,
    handle_response,
  )
}

pub fn supplydelivery_delete(
  resource: resources.Supplydelivery,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "SupplyDelivery", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn supplydelivery_search_bundled(
  search_for search_args: sansio.SpSupplydelivery,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.supplydelivery_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn supplydelivery_search(
  search_for search_args: sansio.SpSupplydelivery,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Supplydelivery), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.supplydelivery_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.supplydelivery
    },
  )
}

pub fn supplyrequest_create(
  resource: resources.Supplyrequest,
  client: FhirClient,
  handle_response: fn(Result(resources.Supplyrequest, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.supplyrequest_to_json(resource),
    "SupplyRequest",
    resources.supplyrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn supplyrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Supplyrequest, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SupplyRequest",
    resources.supplyrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn supplyrequest_update(
  resource: resources.Supplyrequest,
  client: FhirClient,
  handle_response: fn(Result(resources.Supplyrequest, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.supplyrequest_to_json(resource),
    "SupplyRequest",
    resources.supplyrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn supplyrequest_delete(
  resource: resources.Supplyrequest,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "SupplyRequest", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn supplyrequest_search_bundled(
  search_for search_args: sansio.SpSupplyrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.supplyrequest_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn supplyrequest_search(
  search_for search_args: sansio.SpSupplyrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Supplyrequest), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.supplyrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.supplyrequest },
  )
}

pub fn task_create(
  resource: resources.Task,
  client: FhirClient,
  handle_response: fn(Result(resources.Task, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.task_to_json(resource),
    "Task",
    resources.task_decoder(),
    client,
    handle_response,
  )
}

pub fn task_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Task, Err)) -> a,
) -> Effect(a) {
  any_read(id, "Task", resources.task_decoder(), client, handle_response)
}

pub fn task_update(
  resource: resources.Task,
  client: FhirClient,
  handle_response: fn(Result(resources.Task, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.task_to_json(resource),
    "Task",
    resources.task_decoder(),
    client,
    handle_response,
  )
}

pub fn task_delete(
  resource: resources.Task,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Task", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn task_search_bundled(
  search_for search_args: sansio.SpTask,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.task_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn task_search(
  search_for search_args: sansio.SpTask,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Task), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.task_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.task },
  )
}

pub fn terminologycapabilities_create(
  resource: resources.Terminologycapabilities,
  client: FhirClient,
  handle_response: fn(Result(resources.Terminologycapabilities, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.terminologycapabilities_to_json(resource),
    "TerminologyCapabilities",
    resources.terminologycapabilities_decoder(),
    client,
    handle_response,
  )
}

pub fn terminologycapabilities_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Terminologycapabilities, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "TerminologyCapabilities",
    resources.terminologycapabilities_decoder(),
    client,
    handle_response,
  )
}

pub fn terminologycapabilities_update(
  resource: resources.Terminologycapabilities,
  client: FhirClient,
  handle_response: fn(Result(resources.Terminologycapabilities, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.terminologycapabilities_to_json(resource),
    "TerminologyCapabilities",
    resources.terminologycapabilities_decoder(),
    client,
    handle_response,
  )
}

pub fn terminologycapabilities_delete(
  resource: resources.Terminologycapabilities,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "TerminologyCapabilities", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn terminologycapabilities_search_bundled(
  search_for search_args: sansio.SpTerminologycapabilities,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.terminologycapabilities_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn terminologycapabilities_search(
  search_for search_args: sansio.SpTerminologycapabilities,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Terminologycapabilities), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.terminologycapabilities_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.terminologycapabilities
    },
  )
}

pub fn testplan_create(
  resource: resources.Testplan,
  client: FhirClient,
  handle_response: fn(Result(resources.Testplan, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.testplan_to_json(resource),
    "TestPlan",
    resources.testplan_decoder(),
    client,
    handle_response,
  )
}

pub fn testplan_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Testplan, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "TestPlan",
    resources.testplan_decoder(),
    client,
    handle_response,
  )
}

pub fn testplan_update(
  resource: resources.Testplan,
  client: FhirClient,
  handle_response: fn(Result(resources.Testplan, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.testplan_to_json(resource),
    "TestPlan",
    resources.testplan_decoder(),
    client,
    handle_response,
  )
}

pub fn testplan_delete(
  resource: resources.Testplan,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "TestPlan", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn testplan_search_bundled(
  search_for search_args: sansio.SpTestplan,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.testplan_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn testplan_search(
  search_for search_args: sansio.SpTestplan,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Testplan), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.testplan_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.testplan },
  )
}

pub fn testreport_create(
  resource: resources.Testreport,
  client: FhirClient,
  handle_response: fn(Result(resources.Testreport, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.testreport_to_json(resource),
    "TestReport",
    resources.testreport_decoder(),
    client,
    handle_response,
  )
}

pub fn testreport_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Testreport, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "TestReport",
    resources.testreport_decoder(),
    client,
    handle_response,
  )
}

pub fn testreport_update(
  resource: resources.Testreport,
  client: FhirClient,
  handle_response: fn(Result(resources.Testreport, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.testreport_to_json(resource),
    "TestReport",
    resources.testreport_decoder(),
    client,
    handle_response,
  )
}

pub fn testreport_delete(
  resource: resources.Testreport,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "TestReport", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn testreport_search_bundled(
  search_for search_args: sansio.SpTestreport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.testreport_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn testreport_search(
  search_for search_args: sansio.SpTestreport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Testreport), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.testreport_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.testreport },
  )
}

pub fn testscript_create(
  resource: resources.Testscript,
  client: FhirClient,
  handle_response: fn(Result(resources.Testscript, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.testscript_to_json(resource),
    "TestScript",
    resources.testscript_decoder(),
    client,
    handle_response,
  )
}

pub fn testscript_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Testscript, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "TestScript",
    resources.testscript_decoder(),
    client,
    handle_response,
  )
}

pub fn testscript_update(
  resource: resources.Testscript,
  client: FhirClient,
  handle_response: fn(Result(resources.Testscript, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.testscript_to_json(resource),
    "TestScript",
    resources.testscript_decoder(),
    client,
    handle_response,
  )
}

pub fn testscript_delete(
  resource: resources.Testscript,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "TestScript", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn testscript_search_bundled(
  search_for search_args: sansio.SpTestscript,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.testscript_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn testscript_search(
  search_for search_args: sansio.SpTestscript,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Testscript), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.testscript_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.testscript },
  )
}

pub fn transport_create(
  resource: resources.Transport,
  client: FhirClient,
  handle_response: fn(Result(resources.Transport, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.transport_to_json(resource),
    "Transport",
    resources.transport_decoder(),
    client,
    handle_response,
  )
}

pub fn transport_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Transport, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Transport",
    resources.transport_decoder(),
    client,
    handle_response,
  )
}

pub fn transport_update(
  resource: resources.Transport,
  client: FhirClient,
  handle_response: fn(Result(resources.Transport, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.transport_to_json(resource),
    "Transport",
    resources.transport_decoder(),
    client,
    handle_response,
  )
}

pub fn transport_delete(
  resource: resources.Transport,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "Transport", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn transport_search_bundled(
  search_for search_args: sansio.SpTransport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.transport_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn transport_search(
  search_for search_args: sansio.SpTransport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Transport), Err)) ->
    msg,
) -> Effect(msg) {
  let req = sansio.transport_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.transport },
  )
}

pub fn valueset_create(
  resource: resources.Valueset,
  client: FhirClient,
  handle_response: fn(Result(resources.Valueset, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.valueset_to_json(resource),
    "ValueSet",
    resources.valueset_decoder(),
    client,
    handle_response,
  )
}

pub fn valueset_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Valueset, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ValueSet",
    resources.valueset_decoder(),
    client,
    handle_response,
  )
}

pub fn valueset_update(
  resource: resources.Valueset,
  client: FhirClient,
  handle_response: fn(Result(resources.Valueset, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.valueset_to_json(resource),
    "ValueSet",
    resources.valueset_decoder(),
    client,
    handle_response,
  )
}

pub fn valueset_delete(
  resource: resources.Valueset,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) -> Ok(any_delete(id, "ValueSet", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn valueset_search_bundled(
  search_for search_args: sansio.SpValueset,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.valueset_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn valueset_search(
  search_for search_args: sansio.SpValueset,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(resources.Valueset), Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.valueset_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) { { bundle |> sansio.bundle_to_groupedresources }.valueset },
  )
}

pub fn verificationresult_create(
  resource: resources.Verificationresult,
  client: FhirClient,
  handle_response: fn(Result(resources.Verificationresult, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.verificationresult_to_json(resource),
    "VerificationResult",
    resources.verificationresult_decoder(),
    client,
    handle_response,
  )
}

pub fn verificationresult_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Verificationresult, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "VerificationResult",
    resources.verificationresult_decoder(),
    client,
    handle_response,
  )
}

pub fn verificationresult_update(
  resource: resources.Verificationresult,
  client: FhirClient,
  handle_response: fn(Result(resources.Verificationresult, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.verificationresult_to_json(resource),
    "VerificationResult",
    resources.verificationresult_decoder(),
    client,
    handle_response,
  )
}

pub fn verificationresult_delete(
  resource: resources.Verificationresult,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "VerificationResult", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn verificationresult_search_bundled(
  search_for search_args: sansio.SpVerificationresult,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.verificationresult_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn verificationresult_search(
  search_for search_args: sansio.SpVerificationresult,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Verificationresult), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.verificationresult_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.verificationresult
    },
  )
}

pub fn visionprescription_create(
  resource: resources.Visionprescription,
  client: FhirClient,
  handle_response: fn(Result(resources.Visionprescription, Err)) -> a,
) -> Effect(a) {
  any_create(
    resources.visionprescription_to_json(resource),
    "VisionPrescription",
    resources.visionprescription_decoder(),
    client,
    handle_response,
  )
}

pub fn visionprescription_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(resources.Visionprescription, Err)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "VisionPrescription",
    resources.visionprescription_decoder(),
    client,
    handle_response,
  )
}

pub fn visionprescription_update(
  resource: resources.Visionprescription,
  client: FhirClient,
  handle_response: fn(Result(resources.Visionprescription, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    resources.visionprescription_to_json(resource),
    "VisionPrescription",
    resources.visionprescription_decoder(),
    client,
    handle_response,
  )
}

pub fn visionprescription_delete(
  resource: resources.Visionprescription,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> a,
) -> Result(Effect(a), ErrNoId) {
  case resource.id {
    Some(id) ->
      Ok(any_delete(id, "VisionPrescription", client, handle_response))
    None -> Error(ErrNoId)
  }
}

pub fn visionprescription_search_bundled(
  search_for search_args: sansio.SpVisionprescription,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.visionprescription_search_req(search_args, client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
  )
}

pub fn visionprescription_search(
  search_for search_args: sansio.SpVisionprescription,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(resources.Visionprescription), Err),
  ) ->
    msg,
) -> Effect(msg) {
  let req = sansio.visionprescription_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    resources.bundle_decoder(),
    "Bundle",
    handle_response,
    fn(bundle) {
      { bundle |> sansio.bundle_to_groupedresources }.visionprescription
    },
  )
}
