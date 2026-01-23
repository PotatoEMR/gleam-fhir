import fhir/r4b
import fhir/r4b_sansio
import gleam/dynamic/decode.{type Decoder}
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/json.{type Json}
import gleam/option.{type Option, None, Some}
import lustre/effect.{type Effect}
import rsvp

pub type FhirClient =
  r4b_sansio.FhirClient

pub fn fhirclient_new(baseurl: String) -> FhirClient {
  r4b_sansio.fhirclient_new(baseurl)
}

pub type ReqErr {
  ReqErrRsvp(err: rsvp.Error)
  ReqErrSansio(err: r4b_sansio.Err)
}

/// when using rsvp, if you attempt update or delete a resource with no id
/// we do not even send the request or give you an effect to use
/// instead just an Error(ErrNoId)
pub type ErrNoId {
  ErrNoId
}

fn any_create(
  resource: Json,
  res_type: String,
  resource_dec: Decoder(r),
  client: FhirClient,
  handle_response: fn(Result(r, ReqErr)) -> a,
) -> Effect(a) {
  let req = r4b_sansio.any_create_req(resource, res_type, client)
  sendreq_handleresponse(req, resource_dec, handle_response)
}

fn any_read(
  id: String,
  res_type: String,
  resource_dec: Decoder(r),
  client: FhirClient,
  handle_response: fn(Result(r, ReqErr)) -> a,
) -> Effect(a) {
  let req = r4b_sansio.any_read_req(id, res_type, client)
  sendreq_handleresponse(req, resource_dec, handle_response)
}

fn any_update(
  id: Option(String),
  resource: Json,
  res_type: String,
  resource_dec: Decoder(r),
  client: FhirClient,
  handle_response: fn(Result(r, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  let req = r4b_sansio.any_update_req(id, resource, res_type, client)
  case req {
    Ok(req) -> Ok(sendreq_handleresponse(req, resource_dec, handle_response))
    Error(r4b_sansio.ErrNoId) -> Error(ErrNoId)
    Error(_) ->
      panic as "should never get any errors besides NoId before making request"
  }
}

fn any_delete(
  id: Option(String),
  res_type: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  let req = r4b_sansio.any_delete_req(id, res_type, client)
  case req {
    Ok(req) ->
      Ok(sendreq_handleresponse(
        req,
        r4b.operationoutcome_decoder(),
        handle_response,
      ))
    Error(r4b_sansio.ErrNoId) -> Error(ErrNoId)
    Error(_) ->
      panic as "should never get any errors besides NoId before making request"
  }
}

fn sendreq_handleresponse(
  req: Request(String),
  res_dec: Decoder(r),
  handle_response: fn(Result(r, ReqErr)) -> a,
) -> Effect(a) {
  sendreq_handleresponse_andprocess(req, res_dec, handle_response, fn(a) { a })
}

fn sendreq_handleresponse_andprocess(
  req: Request(String),
  res_dec: Decoder(r),
  handle_response,
  process_res,
) -> Effect(a) {
  let handle_read = fn(resp_res: Result(Response(String), rsvp.Error)) {
    handle_response(case resp_res {
      Error(err) -> Error(ReqErrRsvp(err))
      Ok(resp_res) -> {
        case r4b_sansio.any_resp(resp_res, res_dec) {
          Ok(res) -> Ok(process_res(res))
          Error(err) -> Error(ReqErrSansio(err))
        }
      }
    })
  }
  let handler = rsvp.expect_any_response(handle_read)
  rsvp.send(req, handler)
}

pub fn account_create(
  resource: r4b.Account,
  client: FhirClient,
  handle_response: fn(Result(r4b.Account, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.account_to_json(resource),
    "Account",
    r4b.account_decoder(),
    client,
    handle_response,
  )
}

pub fn account_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Account, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Account", r4b.account_decoder(), client, handle_response)
}

pub fn account_update(
  resource: r4b.Account,
  client: FhirClient,
  handle_response: fn(Result(r4b.Account, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.account_to_json(resource),
    "Account",
    r4b.account_decoder(),
    client,
    handle_response,
  )
}

pub fn account_delete(
  resource: r4b.Account,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Account", client, handle_response)
}

pub fn account_search_bundled(
  search_for search_args: r4b_sansio.SpAccount,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.account_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn account_search(
  search_for search_args: r4b_sansio.SpAccount,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Account), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.account_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.account },
  )
}

pub fn activitydefinition_create(
  resource: r4b.Activitydefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Activitydefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.activitydefinition_to_json(resource),
    "ActivityDefinition",
    r4b.activitydefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn activitydefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Activitydefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ActivityDefinition",
    r4b.activitydefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn activitydefinition_update(
  resource: r4b.Activitydefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Activitydefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.activitydefinition_to_json(resource),
    "ActivityDefinition",
    r4b.activitydefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn activitydefinition_delete(
  resource: r4b.Activitydefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ActivityDefinition", client, handle_response)
}

pub fn activitydefinition_search_bundled(
  search_for search_args: r4b_sansio.SpActivitydefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.activitydefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn activitydefinition_search(
  search_for search_args: r4b_sansio.SpActivitydefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Activitydefinition), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.activitydefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.activitydefinition
    },
  )
}

pub fn administrableproductdefinition_create(
  resource: r4b.Administrableproductdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Administrableproductdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.administrableproductdefinition_to_json(resource),
    "AdministrableProductDefinition",
    r4b.administrableproductdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn administrableproductdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Administrableproductdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "AdministrableProductDefinition",
    r4b.administrableproductdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn administrableproductdefinition_update(
  resource: r4b.Administrableproductdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Administrableproductdefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.administrableproductdefinition_to_json(resource),
    "AdministrableProductDefinition",
    r4b.administrableproductdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn administrableproductdefinition_delete(
  resource: r4b.Administrableproductdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(
    resource.id,
    "AdministrableProductDefinition",
    client,
    handle_response,
  )
}

pub fn administrableproductdefinition_search_bundled(
  search_for search_args: r4b_sansio.SpAdministrableproductdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req =
    r4b_sansio.administrableproductdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn administrableproductdefinition_search(
  search_for search_args: r4b_sansio.SpAdministrableproductdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Administrableproductdefinition), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4b_sansio.administrableproductdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.administrableproductdefinition
    },
  )
}

pub fn adverseevent_create(
  resource: r4b.Adverseevent,
  client: FhirClient,
  handle_response: fn(Result(r4b.Adverseevent, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.adverseevent_to_json(resource),
    "AdverseEvent",
    r4b.adverseevent_decoder(),
    client,
    handle_response,
  )
}

pub fn adverseevent_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Adverseevent, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "AdverseEvent",
    r4b.adverseevent_decoder(),
    client,
    handle_response,
  )
}

pub fn adverseevent_update(
  resource: r4b.Adverseevent,
  client: FhirClient,
  handle_response: fn(Result(r4b.Adverseevent, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.adverseevent_to_json(resource),
    "AdverseEvent",
    r4b.adverseevent_decoder(),
    client,
    handle_response,
  )
}

pub fn adverseevent_delete(
  resource: r4b.Adverseevent,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "AdverseEvent", client, handle_response)
}

pub fn adverseevent_search_bundled(
  search_for search_args: r4b_sansio.SpAdverseevent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.adverseevent_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn adverseevent_search(
  search_for search_args: r4b_sansio.SpAdverseevent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Adverseevent), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.adverseevent_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.adverseevent
    },
  )
}

pub fn allergyintolerance_create(
  resource: r4b.Allergyintolerance,
  client: FhirClient,
  handle_response: fn(Result(r4b.Allergyintolerance, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    r4b.allergyintolerance_decoder(),
    client,
    handle_response,
  )
}

pub fn allergyintolerance_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Allergyintolerance, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "AllergyIntolerance",
    r4b.allergyintolerance_decoder(),
    client,
    handle_response,
  )
}

pub fn allergyintolerance_update(
  resource: r4b.Allergyintolerance,
  client: FhirClient,
  handle_response: fn(Result(r4b.Allergyintolerance, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    r4b.allergyintolerance_decoder(),
    client,
    handle_response,
  )
}

pub fn allergyintolerance_delete(
  resource: r4b.Allergyintolerance,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "AllergyIntolerance", client, handle_response)
}

pub fn allergyintolerance_search_bundled(
  search_for search_args: r4b_sansio.SpAllergyintolerance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.allergyintolerance_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn allergyintolerance_search(
  search_for search_args: r4b_sansio.SpAllergyintolerance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Allergyintolerance), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.allergyintolerance_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.allergyintolerance
    },
  )
}

pub fn appointment_create(
  resource: r4b.Appointment,
  client: FhirClient,
  handle_response: fn(Result(r4b.Appointment, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.appointment_to_json(resource),
    "Appointment",
    r4b.appointment_decoder(),
    client,
    handle_response,
  )
}

pub fn appointment_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Appointment, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Appointment",
    r4b.appointment_decoder(),
    client,
    handle_response,
  )
}

pub fn appointment_update(
  resource: r4b.Appointment,
  client: FhirClient,
  handle_response: fn(Result(r4b.Appointment, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.appointment_to_json(resource),
    "Appointment",
    r4b.appointment_decoder(),
    client,
    handle_response,
  )
}

pub fn appointment_delete(
  resource: r4b.Appointment,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Appointment", client, handle_response)
}

pub fn appointment_search_bundled(
  search_for search_args: r4b_sansio.SpAppointment,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.appointment_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn appointment_search(
  search_for search_args: r4b_sansio.SpAppointment,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Appointment), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.appointment_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.appointment
    },
  )
}

pub fn appointmentresponse_create(
  resource: r4b.Appointmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r4b.Appointmentresponse, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.appointmentresponse_to_json(resource),
    "AppointmentResponse",
    r4b.appointmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn appointmentresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Appointmentresponse, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "AppointmentResponse",
    r4b.appointmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn appointmentresponse_update(
  resource: r4b.Appointmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r4b.Appointmentresponse, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.appointmentresponse_to_json(resource),
    "AppointmentResponse",
    r4b.appointmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn appointmentresponse_delete(
  resource: r4b.Appointmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "AppointmentResponse", client, handle_response)
}

pub fn appointmentresponse_search_bundled(
  search_for search_args: r4b_sansio.SpAppointmentresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.appointmentresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn appointmentresponse_search(
  search_for search_args: r4b_sansio.SpAppointmentresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Appointmentresponse), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.appointmentresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.appointmentresponse
    },
  )
}

pub fn auditevent_create(
  resource: r4b.Auditevent,
  client: FhirClient,
  handle_response: fn(Result(r4b.Auditevent, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.auditevent_to_json(resource),
    "AuditEvent",
    r4b.auditevent_decoder(),
    client,
    handle_response,
  )
}

pub fn auditevent_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Auditevent, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "AuditEvent", r4b.auditevent_decoder(), client, handle_response)
}

pub fn auditevent_update(
  resource: r4b.Auditevent,
  client: FhirClient,
  handle_response: fn(Result(r4b.Auditevent, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.auditevent_to_json(resource),
    "AuditEvent",
    r4b.auditevent_decoder(),
    client,
    handle_response,
  )
}

pub fn auditevent_delete(
  resource: r4b.Auditevent,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "AuditEvent", client, handle_response)
}

pub fn auditevent_search_bundled(
  search_for search_args: r4b_sansio.SpAuditevent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.auditevent_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn auditevent_search(
  search_for search_args: r4b_sansio.SpAuditevent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Auditevent), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.auditevent_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.auditevent
    },
  )
}

pub fn basic_create(
  resource: r4b.Basic,
  client: FhirClient,
  handle_response: fn(Result(r4b.Basic, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.basic_to_json(resource),
    "Basic",
    r4b.basic_decoder(),
    client,
    handle_response,
  )
}

pub fn basic_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Basic, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Basic", r4b.basic_decoder(), client, handle_response)
}

pub fn basic_update(
  resource: r4b.Basic,
  client: FhirClient,
  handle_response: fn(Result(r4b.Basic, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.basic_to_json(resource),
    "Basic",
    r4b.basic_decoder(),
    client,
    handle_response,
  )
}

pub fn basic_delete(
  resource: r4b.Basic,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Basic", client, handle_response)
}

pub fn basic_search_bundled(
  search_for search_args: r4b_sansio.SpBasic,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.basic_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn basic_search(
  search_for search_args: r4b_sansio.SpBasic,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Basic), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.basic_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.basic },
  )
}

pub fn binary_create(
  resource: r4b.Binary,
  client: FhirClient,
  handle_response: fn(Result(r4b.Binary, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.binary_to_json(resource),
    "Binary",
    r4b.binary_decoder(),
    client,
    handle_response,
  )
}

pub fn binary_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Binary, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Binary", r4b.binary_decoder(), client, handle_response)
}

pub fn binary_update(
  resource: r4b.Binary,
  client: FhirClient,
  handle_response: fn(Result(r4b.Binary, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.binary_to_json(resource),
    "Binary",
    r4b.binary_decoder(),
    client,
    handle_response,
  )
}

pub fn binary_delete(
  resource: r4b.Binary,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Binary", client, handle_response)
}

pub fn binary_search_bundled(
  search_for search_args: r4b_sansio.SpBinary,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.binary_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn binary_search(
  search_for search_args: r4b_sansio.SpBinary,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Binary), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.binary_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.binary },
  )
}

pub fn biologicallyderivedproduct_create(
  resource: r4b.Biologicallyderivedproduct,
  client: FhirClient,
  handle_response: fn(Result(r4b.Biologicallyderivedproduct, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.biologicallyderivedproduct_to_json(resource),
    "BiologicallyDerivedProduct",
    r4b.biologicallyderivedproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn biologicallyderivedproduct_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Biologicallyderivedproduct, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "BiologicallyDerivedProduct",
    r4b.biologicallyderivedproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn biologicallyderivedproduct_update(
  resource: r4b.Biologicallyderivedproduct,
  client: FhirClient,
  handle_response: fn(Result(r4b.Biologicallyderivedproduct, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.biologicallyderivedproduct_to_json(resource),
    "BiologicallyDerivedProduct",
    r4b.biologicallyderivedproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn biologicallyderivedproduct_delete(
  resource: r4b.Biologicallyderivedproduct,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "BiologicallyDerivedProduct", client, handle_response)
}

pub fn biologicallyderivedproduct_search_bundled(
  search_for search_args: r4b_sansio.SpBiologicallyderivedproduct,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req =
    r4b_sansio.biologicallyderivedproduct_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn biologicallyderivedproduct_search(
  search_for search_args: r4b_sansio.SpBiologicallyderivedproduct,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Biologicallyderivedproduct), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4b_sansio.biologicallyderivedproduct_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.biologicallyderivedproduct
    },
  )
}

pub fn bodystructure_create(
  resource: r4b.Bodystructure,
  client: FhirClient,
  handle_response: fn(Result(r4b.Bodystructure, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.bodystructure_to_json(resource),
    "BodyStructure",
    r4b.bodystructure_decoder(),
    client,
    handle_response,
  )
}

pub fn bodystructure_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Bodystructure, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "BodyStructure",
    r4b.bodystructure_decoder(),
    client,
    handle_response,
  )
}

pub fn bodystructure_update(
  resource: r4b.Bodystructure,
  client: FhirClient,
  handle_response: fn(Result(r4b.Bodystructure, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.bodystructure_to_json(resource),
    "BodyStructure",
    r4b.bodystructure_decoder(),
    client,
    handle_response,
  )
}

pub fn bodystructure_delete(
  resource: r4b.Bodystructure,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "BodyStructure", client, handle_response)
}

pub fn bodystructure_search_bundled(
  search_for search_args: r4b_sansio.SpBodystructure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.bodystructure_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn bodystructure_search(
  search_for search_args: r4b_sansio.SpBodystructure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Bodystructure), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.bodystructure_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.bodystructure
    },
  )
}

pub fn bundle_create(
  resource: r4b.Bundle,
  client: FhirClient,
  handle_response: fn(Result(r4b.Bundle, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.bundle_to_json(resource),
    "Bundle",
    r4b.bundle_decoder(),
    client,
    handle_response,
  )
}

pub fn bundle_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Bundle, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Bundle", r4b.bundle_decoder(), client, handle_response)
}

pub fn bundle_update(
  resource: r4b.Bundle,
  client: FhirClient,
  handle_response: fn(Result(r4b.Bundle, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.bundle_to_json(resource),
    "Bundle",
    r4b.bundle_decoder(),
    client,
    handle_response,
  )
}

pub fn bundle_delete(
  resource: r4b.Bundle,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Bundle", client, handle_response)
}

pub fn bundle_search_bundled(
  search_for search_args: r4b_sansio.SpBundle,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.bundle_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn bundle_search(
  search_for search_args: r4b_sansio.SpBundle,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Bundle), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.bundle_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.bundle },
  )
}

pub fn capabilitystatement_create(
  resource: r4b.Capabilitystatement,
  client: FhirClient,
  handle_response: fn(Result(r4b.Capabilitystatement, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.capabilitystatement_to_json(resource),
    "CapabilityStatement",
    r4b.capabilitystatement_decoder(),
    client,
    handle_response,
  )
}

pub fn capabilitystatement_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Capabilitystatement, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CapabilityStatement",
    r4b.capabilitystatement_decoder(),
    client,
    handle_response,
  )
}

pub fn capabilitystatement_update(
  resource: r4b.Capabilitystatement,
  client: FhirClient,
  handle_response: fn(Result(r4b.Capabilitystatement, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.capabilitystatement_to_json(resource),
    "CapabilityStatement",
    r4b.capabilitystatement_decoder(),
    client,
    handle_response,
  )
}

pub fn capabilitystatement_delete(
  resource: r4b.Capabilitystatement,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CapabilityStatement", client, handle_response)
}

pub fn capabilitystatement_search_bundled(
  search_for search_args: r4b_sansio.SpCapabilitystatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.capabilitystatement_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn capabilitystatement_search(
  search_for search_args: r4b_sansio.SpCapabilitystatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Capabilitystatement), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.capabilitystatement_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.capabilitystatement
    },
  )
}

pub fn careplan_create(
  resource: r4b.Careplan,
  client: FhirClient,
  handle_response: fn(Result(r4b.Careplan, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.careplan_to_json(resource),
    "CarePlan",
    r4b.careplan_decoder(),
    client,
    handle_response,
  )
}

pub fn careplan_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Careplan, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "CarePlan", r4b.careplan_decoder(), client, handle_response)
}

pub fn careplan_update(
  resource: r4b.Careplan,
  client: FhirClient,
  handle_response: fn(Result(r4b.Careplan, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.careplan_to_json(resource),
    "CarePlan",
    r4b.careplan_decoder(),
    client,
    handle_response,
  )
}

pub fn careplan_delete(
  resource: r4b.Careplan,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CarePlan", client, handle_response)
}

pub fn careplan_search_bundled(
  search_for search_args: r4b_sansio.SpCareplan,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.careplan_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn careplan_search(
  search_for search_args: r4b_sansio.SpCareplan,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Careplan), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.careplan_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.careplan },
  )
}

pub fn careteam_create(
  resource: r4b.Careteam,
  client: FhirClient,
  handle_response: fn(Result(r4b.Careteam, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.careteam_to_json(resource),
    "CareTeam",
    r4b.careteam_decoder(),
    client,
    handle_response,
  )
}

pub fn careteam_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Careteam, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "CareTeam", r4b.careteam_decoder(), client, handle_response)
}

pub fn careteam_update(
  resource: r4b.Careteam,
  client: FhirClient,
  handle_response: fn(Result(r4b.Careteam, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.careteam_to_json(resource),
    "CareTeam",
    r4b.careteam_decoder(),
    client,
    handle_response,
  )
}

pub fn careteam_delete(
  resource: r4b.Careteam,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CareTeam", client, handle_response)
}

pub fn careteam_search_bundled(
  search_for search_args: r4b_sansio.SpCareteam,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.careteam_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn careteam_search(
  search_for search_args: r4b_sansio.SpCareteam,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Careteam), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.careteam_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.careteam },
  )
}

pub fn catalogentry_create(
  resource: r4b.Catalogentry,
  client: FhirClient,
  handle_response: fn(Result(r4b.Catalogentry, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.catalogentry_to_json(resource),
    "CatalogEntry",
    r4b.catalogentry_decoder(),
    client,
    handle_response,
  )
}

pub fn catalogentry_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Catalogentry, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CatalogEntry",
    r4b.catalogentry_decoder(),
    client,
    handle_response,
  )
}

pub fn catalogentry_update(
  resource: r4b.Catalogentry,
  client: FhirClient,
  handle_response: fn(Result(r4b.Catalogentry, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.catalogentry_to_json(resource),
    "CatalogEntry",
    r4b.catalogentry_decoder(),
    client,
    handle_response,
  )
}

pub fn catalogentry_delete(
  resource: r4b.Catalogentry,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CatalogEntry", client, handle_response)
}

pub fn catalogentry_search_bundled(
  search_for search_args: r4b_sansio.SpCatalogentry,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.catalogentry_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn catalogentry_search(
  search_for search_args: r4b_sansio.SpCatalogentry,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Catalogentry), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.catalogentry_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.catalogentry
    },
  )
}

pub fn chargeitem_create(
  resource: r4b.Chargeitem,
  client: FhirClient,
  handle_response: fn(Result(r4b.Chargeitem, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.chargeitem_to_json(resource),
    "ChargeItem",
    r4b.chargeitem_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitem_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Chargeitem, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "ChargeItem", r4b.chargeitem_decoder(), client, handle_response)
}

pub fn chargeitem_update(
  resource: r4b.Chargeitem,
  client: FhirClient,
  handle_response: fn(Result(r4b.Chargeitem, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.chargeitem_to_json(resource),
    "ChargeItem",
    r4b.chargeitem_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitem_delete(
  resource: r4b.Chargeitem,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ChargeItem", client, handle_response)
}

pub fn chargeitem_search_bundled(
  search_for search_args: r4b_sansio.SpChargeitem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.chargeitem_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn chargeitem_search(
  search_for search_args: r4b_sansio.SpChargeitem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Chargeitem), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.chargeitem_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.chargeitem
    },
  )
}

pub fn chargeitemdefinition_create(
  resource: r4b.Chargeitemdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Chargeitemdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.chargeitemdefinition_to_json(resource),
    "ChargeItemDefinition",
    r4b.chargeitemdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitemdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Chargeitemdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ChargeItemDefinition",
    r4b.chargeitemdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitemdefinition_update(
  resource: r4b.Chargeitemdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Chargeitemdefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.chargeitemdefinition_to_json(resource),
    "ChargeItemDefinition",
    r4b.chargeitemdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitemdefinition_delete(
  resource: r4b.Chargeitemdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ChargeItemDefinition", client, handle_response)
}

pub fn chargeitemdefinition_search_bundled(
  search_for search_args: r4b_sansio.SpChargeitemdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.chargeitemdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn chargeitemdefinition_search(
  search_for search_args: r4b_sansio.SpChargeitemdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Chargeitemdefinition), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.chargeitemdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.chargeitemdefinition
    },
  )
}

pub fn citation_create(
  resource: r4b.Citation,
  client: FhirClient,
  handle_response: fn(Result(r4b.Citation, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.citation_to_json(resource),
    "Citation",
    r4b.citation_decoder(),
    client,
    handle_response,
  )
}

pub fn citation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Citation, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Citation", r4b.citation_decoder(), client, handle_response)
}

pub fn citation_update(
  resource: r4b.Citation,
  client: FhirClient,
  handle_response: fn(Result(r4b.Citation, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.citation_to_json(resource),
    "Citation",
    r4b.citation_decoder(),
    client,
    handle_response,
  )
}

pub fn citation_delete(
  resource: r4b.Citation,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Citation", client, handle_response)
}

pub fn citation_search_bundled(
  search_for search_args: r4b_sansio.SpCitation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.citation_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn citation_search(
  search_for search_args: r4b_sansio.SpCitation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Citation), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.citation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.citation },
  )
}

pub fn claim_create(
  resource: r4b.Claim,
  client: FhirClient,
  handle_response: fn(Result(r4b.Claim, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.claim_to_json(resource),
    "Claim",
    r4b.claim_decoder(),
    client,
    handle_response,
  )
}

pub fn claim_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Claim, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Claim", r4b.claim_decoder(), client, handle_response)
}

pub fn claim_update(
  resource: r4b.Claim,
  client: FhirClient,
  handle_response: fn(Result(r4b.Claim, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.claim_to_json(resource),
    "Claim",
    r4b.claim_decoder(),
    client,
    handle_response,
  )
}

pub fn claim_delete(
  resource: r4b.Claim,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Claim", client, handle_response)
}

pub fn claim_search_bundled(
  search_for search_args: r4b_sansio.SpClaim,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.claim_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn claim_search(
  search_for search_args: r4b_sansio.SpClaim,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Claim), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.claim_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.claim },
  )
}

pub fn claimresponse_create(
  resource: r4b.Claimresponse,
  client: FhirClient,
  handle_response: fn(Result(r4b.Claimresponse, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.claimresponse_to_json(resource),
    "ClaimResponse",
    r4b.claimresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn claimresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Claimresponse, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ClaimResponse",
    r4b.claimresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn claimresponse_update(
  resource: r4b.Claimresponse,
  client: FhirClient,
  handle_response: fn(Result(r4b.Claimresponse, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.claimresponse_to_json(resource),
    "ClaimResponse",
    r4b.claimresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn claimresponse_delete(
  resource: r4b.Claimresponse,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ClaimResponse", client, handle_response)
}

pub fn claimresponse_search_bundled(
  search_for search_args: r4b_sansio.SpClaimresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.claimresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn claimresponse_search(
  search_for search_args: r4b_sansio.SpClaimresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Claimresponse), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.claimresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.claimresponse
    },
  )
}

pub fn clinicalimpression_create(
  resource: r4b.Clinicalimpression,
  client: FhirClient,
  handle_response: fn(Result(r4b.Clinicalimpression, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.clinicalimpression_to_json(resource),
    "ClinicalImpression",
    r4b.clinicalimpression_decoder(),
    client,
    handle_response,
  )
}

pub fn clinicalimpression_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Clinicalimpression, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ClinicalImpression",
    r4b.clinicalimpression_decoder(),
    client,
    handle_response,
  )
}

pub fn clinicalimpression_update(
  resource: r4b.Clinicalimpression,
  client: FhirClient,
  handle_response: fn(Result(r4b.Clinicalimpression, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.clinicalimpression_to_json(resource),
    "ClinicalImpression",
    r4b.clinicalimpression_decoder(),
    client,
    handle_response,
  )
}

pub fn clinicalimpression_delete(
  resource: r4b.Clinicalimpression,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ClinicalImpression", client, handle_response)
}

pub fn clinicalimpression_search_bundled(
  search_for search_args: r4b_sansio.SpClinicalimpression,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.clinicalimpression_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn clinicalimpression_search(
  search_for search_args: r4b_sansio.SpClinicalimpression,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Clinicalimpression), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.clinicalimpression_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.clinicalimpression
    },
  )
}

pub fn clinicalusedefinition_create(
  resource: r4b.Clinicalusedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Clinicalusedefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.clinicalusedefinition_to_json(resource),
    "ClinicalUseDefinition",
    r4b.clinicalusedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn clinicalusedefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Clinicalusedefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ClinicalUseDefinition",
    r4b.clinicalusedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn clinicalusedefinition_update(
  resource: r4b.Clinicalusedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Clinicalusedefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.clinicalusedefinition_to_json(resource),
    "ClinicalUseDefinition",
    r4b.clinicalusedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn clinicalusedefinition_delete(
  resource: r4b.Clinicalusedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ClinicalUseDefinition", client, handle_response)
}

pub fn clinicalusedefinition_search_bundled(
  search_for search_args: r4b_sansio.SpClinicalusedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.clinicalusedefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn clinicalusedefinition_search(
  search_for search_args: r4b_sansio.SpClinicalusedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Clinicalusedefinition), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.clinicalusedefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.clinicalusedefinition
    },
  )
}

pub fn codesystem_create(
  resource: r4b.Codesystem,
  client: FhirClient,
  handle_response: fn(Result(r4b.Codesystem, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.codesystem_to_json(resource),
    "CodeSystem",
    r4b.codesystem_decoder(),
    client,
    handle_response,
  )
}

pub fn codesystem_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Codesystem, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "CodeSystem", r4b.codesystem_decoder(), client, handle_response)
}

pub fn codesystem_update(
  resource: r4b.Codesystem,
  client: FhirClient,
  handle_response: fn(Result(r4b.Codesystem, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.codesystem_to_json(resource),
    "CodeSystem",
    r4b.codesystem_decoder(),
    client,
    handle_response,
  )
}

pub fn codesystem_delete(
  resource: r4b.Codesystem,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CodeSystem", client, handle_response)
}

pub fn codesystem_search_bundled(
  search_for search_args: r4b_sansio.SpCodesystem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.codesystem_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn codesystem_search(
  search_for search_args: r4b_sansio.SpCodesystem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Codesystem), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.codesystem_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.codesystem
    },
  )
}

pub fn communication_create(
  resource: r4b.Communication,
  client: FhirClient,
  handle_response: fn(Result(r4b.Communication, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.communication_to_json(resource),
    "Communication",
    r4b.communication_decoder(),
    client,
    handle_response,
  )
}

pub fn communication_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Communication, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Communication",
    r4b.communication_decoder(),
    client,
    handle_response,
  )
}

pub fn communication_update(
  resource: r4b.Communication,
  client: FhirClient,
  handle_response: fn(Result(r4b.Communication, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.communication_to_json(resource),
    "Communication",
    r4b.communication_decoder(),
    client,
    handle_response,
  )
}

pub fn communication_delete(
  resource: r4b.Communication,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Communication", client, handle_response)
}

pub fn communication_search_bundled(
  search_for search_args: r4b_sansio.SpCommunication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.communication_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn communication_search(
  search_for search_args: r4b_sansio.SpCommunication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Communication), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.communication_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.communication
    },
  )
}

pub fn communicationrequest_create(
  resource: r4b.Communicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r4b.Communicationrequest, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.communicationrequest_to_json(resource),
    "CommunicationRequest",
    r4b.communicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn communicationrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Communicationrequest, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CommunicationRequest",
    r4b.communicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn communicationrequest_update(
  resource: r4b.Communicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r4b.Communicationrequest, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.communicationrequest_to_json(resource),
    "CommunicationRequest",
    r4b.communicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn communicationrequest_delete(
  resource: r4b.Communicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CommunicationRequest", client, handle_response)
}

pub fn communicationrequest_search_bundled(
  search_for search_args: r4b_sansio.SpCommunicationrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.communicationrequest_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn communicationrequest_search(
  search_for search_args: r4b_sansio.SpCommunicationrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Communicationrequest), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.communicationrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.communicationrequest
    },
  )
}

pub fn compartmentdefinition_create(
  resource: r4b.Compartmentdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Compartmentdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.compartmentdefinition_to_json(resource),
    "CompartmentDefinition",
    r4b.compartmentdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn compartmentdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Compartmentdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CompartmentDefinition",
    r4b.compartmentdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn compartmentdefinition_update(
  resource: r4b.Compartmentdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Compartmentdefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.compartmentdefinition_to_json(resource),
    "CompartmentDefinition",
    r4b.compartmentdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn compartmentdefinition_delete(
  resource: r4b.Compartmentdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CompartmentDefinition", client, handle_response)
}

pub fn compartmentdefinition_search_bundled(
  search_for search_args: r4b_sansio.SpCompartmentdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.compartmentdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn compartmentdefinition_search(
  search_for search_args: r4b_sansio.SpCompartmentdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Compartmentdefinition), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.compartmentdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.compartmentdefinition
    },
  )
}

pub fn composition_create(
  resource: r4b.Composition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Composition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.composition_to_json(resource),
    "Composition",
    r4b.composition_decoder(),
    client,
    handle_response,
  )
}

pub fn composition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Composition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Composition",
    r4b.composition_decoder(),
    client,
    handle_response,
  )
}

pub fn composition_update(
  resource: r4b.Composition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Composition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.composition_to_json(resource),
    "Composition",
    r4b.composition_decoder(),
    client,
    handle_response,
  )
}

pub fn composition_delete(
  resource: r4b.Composition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Composition", client, handle_response)
}

pub fn composition_search_bundled(
  search_for search_args: r4b_sansio.SpComposition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.composition_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn composition_search(
  search_for search_args: r4b_sansio.SpComposition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Composition), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.composition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.composition
    },
  )
}

pub fn conceptmap_create(
  resource: r4b.Conceptmap,
  client: FhirClient,
  handle_response: fn(Result(r4b.Conceptmap, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.conceptmap_to_json(resource),
    "ConceptMap",
    r4b.conceptmap_decoder(),
    client,
    handle_response,
  )
}

pub fn conceptmap_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Conceptmap, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "ConceptMap", r4b.conceptmap_decoder(), client, handle_response)
}

pub fn conceptmap_update(
  resource: r4b.Conceptmap,
  client: FhirClient,
  handle_response: fn(Result(r4b.Conceptmap, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.conceptmap_to_json(resource),
    "ConceptMap",
    r4b.conceptmap_decoder(),
    client,
    handle_response,
  )
}

pub fn conceptmap_delete(
  resource: r4b.Conceptmap,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ConceptMap", client, handle_response)
}

pub fn conceptmap_search_bundled(
  search_for search_args: r4b_sansio.SpConceptmap,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.conceptmap_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn conceptmap_search(
  search_for search_args: r4b_sansio.SpConceptmap,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Conceptmap), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.conceptmap_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.conceptmap
    },
  )
}

pub fn condition_create(
  resource: r4b.Condition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Condition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.condition_to_json(resource),
    "Condition",
    r4b.condition_decoder(),
    client,
    handle_response,
  )
}

pub fn condition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Condition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Condition", r4b.condition_decoder(), client, handle_response)
}

pub fn condition_update(
  resource: r4b.Condition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Condition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.condition_to_json(resource),
    "Condition",
    r4b.condition_decoder(),
    client,
    handle_response,
  )
}

pub fn condition_delete(
  resource: r4b.Condition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Condition", client, handle_response)
}

pub fn condition_search_bundled(
  search_for search_args: r4b_sansio.SpCondition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.condition_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn condition_search(
  search_for search_args: r4b_sansio.SpCondition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Condition), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.condition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.condition },
  )
}

pub fn consent_create(
  resource: r4b.Consent,
  client: FhirClient,
  handle_response: fn(Result(r4b.Consent, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.consent_to_json(resource),
    "Consent",
    r4b.consent_decoder(),
    client,
    handle_response,
  )
}

pub fn consent_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Consent, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Consent", r4b.consent_decoder(), client, handle_response)
}

pub fn consent_update(
  resource: r4b.Consent,
  client: FhirClient,
  handle_response: fn(Result(r4b.Consent, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.consent_to_json(resource),
    "Consent",
    r4b.consent_decoder(),
    client,
    handle_response,
  )
}

pub fn consent_delete(
  resource: r4b.Consent,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Consent", client, handle_response)
}

pub fn consent_search_bundled(
  search_for search_args: r4b_sansio.SpConsent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.consent_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn consent_search(
  search_for search_args: r4b_sansio.SpConsent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Consent), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.consent_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.consent },
  )
}

pub fn contract_create(
  resource: r4b.Contract,
  client: FhirClient,
  handle_response: fn(Result(r4b.Contract, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.contract_to_json(resource),
    "Contract",
    r4b.contract_decoder(),
    client,
    handle_response,
  )
}

pub fn contract_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Contract, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Contract", r4b.contract_decoder(), client, handle_response)
}

pub fn contract_update(
  resource: r4b.Contract,
  client: FhirClient,
  handle_response: fn(Result(r4b.Contract, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.contract_to_json(resource),
    "Contract",
    r4b.contract_decoder(),
    client,
    handle_response,
  )
}

pub fn contract_delete(
  resource: r4b.Contract,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Contract", client, handle_response)
}

pub fn contract_search_bundled(
  search_for search_args: r4b_sansio.SpContract,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.contract_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn contract_search(
  search_for search_args: r4b_sansio.SpContract,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Contract), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.contract_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.contract },
  )
}

pub fn coverage_create(
  resource: r4b.Coverage,
  client: FhirClient,
  handle_response: fn(Result(r4b.Coverage, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.coverage_to_json(resource),
    "Coverage",
    r4b.coverage_decoder(),
    client,
    handle_response,
  )
}

pub fn coverage_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Coverage, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Coverage", r4b.coverage_decoder(), client, handle_response)
}

pub fn coverage_update(
  resource: r4b.Coverage,
  client: FhirClient,
  handle_response: fn(Result(r4b.Coverage, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.coverage_to_json(resource),
    "Coverage",
    r4b.coverage_decoder(),
    client,
    handle_response,
  )
}

pub fn coverage_delete(
  resource: r4b.Coverage,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Coverage", client, handle_response)
}

pub fn coverage_search_bundled(
  search_for search_args: r4b_sansio.SpCoverage,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.coverage_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn coverage_search(
  search_for search_args: r4b_sansio.SpCoverage,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Coverage), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.coverage_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.coverage },
  )
}

pub fn coverageeligibilityrequest_create(
  resource: r4b.Coverageeligibilityrequest,
  client: FhirClient,
  handle_response: fn(Result(r4b.Coverageeligibilityrequest, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.coverageeligibilityrequest_to_json(resource),
    "CoverageEligibilityRequest",
    r4b.coverageeligibilityrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Coverageeligibilityrequest, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CoverageEligibilityRequest",
    r4b.coverageeligibilityrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityrequest_update(
  resource: r4b.Coverageeligibilityrequest,
  client: FhirClient,
  handle_response: fn(Result(r4b.Coverageeligibilityrequest, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.coverageeligibilityrequest_to_json(resource),
    "CoverageEligibilityRequest",
    r4b.coverageeligibilityrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityrequest_delete(
  resource: r4b.Coverageeligibilityrequest,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CoverageEligibilityRequest", client, handle_response)
}

pub fn coverageeligibilityrequest_search_bundled(
  search_for search_args: r4b_sansio.SpCoverageeligibilityrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req =
    r4b_sansio.coverageeligibilityrequest_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn coverageeligibilityrequest_search(
  search_for search_args: r4b_sansio.SpCoverageeligibilityrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Coverageeligibilityrequest), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4b_sansio.coverageeligibilityrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.coverageeligibilityrequest
    },
  )
}

pub fn coverageeligibilityresponse_create(
  resource: r4b.Coverageeligibilityresponse,
  client: FhirClient,
  handle_response: fn(Result(r4b.Coverageeligibilityresponse, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.coverageeligibilityresponse_to_json(resource),
    "CoverageEligibilityResponse",
    r4b.coverageeligibilityresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Coverageeligibilityresponse, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CoverageEligibilityResponse",
    r4b.coverageeligibilityresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityresponse_update(
  resource: r4b.Coverageeligibilityresponse,
  client: FhirClient,
  handle_response: fn(Result(r4b.Coverageeligibilityresponse, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.coverageeligibilityresponse_to_json(resource),
    "CoverageEligibilityResponse",
    r4b.coverageeligibilityresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityresponse_delete(
  resource: r4b.Coverageeligibilityresponse,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(
    resource.id,
    "CoverageEligibilityResponse",
    client,
    handle_response,
  )
}

pub fn coverageeligibilityresponse_search_bundled(
  search_for search_args: r4b_sansio.SpCoverageeligibilityresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req =
    r4b_sansio.coverageeligibilityresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn coverageeligibilityresponse_search(
  search_for search_args: r4b_sansio.SpCoverageeligibilityresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Coverageeligibilityresponse), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4b_sansio.coverageeligibilityresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.coverageeligibilityresponse
    },
  )
}

pub fn detectedissue_create(
  resource: r4b.Detectedissue,
  client: FhirClient,
  handle_response: fn(Result(r4b.Detectedissue, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.detectedissue_to_json(resource),
    "DetectedIssue",
    r4b.detectedissue_decoder(),
    client,
    handle_response,
  )
}

pub fn detectedissue_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Detectedissue, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DetectedIssue",
    r4b.detectedissue_decoder(),
    client,
    handle_response,
  )
}

pub fn detectedissue_update(
  resource: r4b.Detectedissue,
  client: FhirClient,
  handle_response: fn(Result(r4b.Detectedissue, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.detectedissue_to_json(resource),
    "DetectedIssue",
    r4b.detectedissue_decoder(),
    client,
    handle_response,
  )
}

pub fn detectedissue_delete(
  resource: r4b.Detectedissue,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DetectedIssue", client, handle_response)
}

pub fn detectedissue_search_bundled(
  search_for search_args: r4b_sansio.SpDetectedissue,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.detectedissue_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn detectedissue_search(
  search_for search_args: r4b_sansio.SpDetectedissue,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Detectedissue), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.detectedissue_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.detectedissue
    },
  )
}

pub fn device_create(
  resource: r4b.Device,
  client: FhirClient,
  handle_response: fn(Result(r4b.Device, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.device_to_json(resource),
    "Device",
    r4b.device_decoder(),
    client,
    handle_response,
  )
}

pub fn device_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Device, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Device", r4b.device_decoder(), client, handle_response)
}

pub fn device_update(
  resource: r4b.Device,
  client: FhirClient,
  handle_response: fn(Result(r4b.Device, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.device_to_json(resource),
    "Device",
    r4b.device_decoder(),
    client,
    handle_response,
  )
}

pub fn device_delete(
  resource: r4b.Device,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Device", client, handle_response)
}

pub fn device_search_bundled(
  search_for search_args: r4b_sansio.SpDevice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.device_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn device_search(
  search_for search_args: r4b_sansio.SpDevice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Device), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.device_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.device },
  )
}

pub fn devicedefinition_create(
  resource: r4b.Devicedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Devicedefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.devicedefinition_to_json(resource),
    "DeviceDefinition",
    r4b.devicedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn devicedefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Devicedefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DeviceDefinition",
    r4b.devicedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn devicedefinition_update(
  resource: r4b.Devicedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Devicedefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.devicedefinition_to_json(resource),
    "DeviceDefinition",
    r4b.devicedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn devicedefinition_delete(
  resource: r4b.Devicedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DeviceDefinition", client, handle_response)
}

pub fn devicedefinition_search_bundled(
  search_for search_args: r4b_sansio.SpDevicedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.devicedefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn devicedefinition_search(
  search_for search_args: r4b_sansio.SpDevicedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Devicedefinition), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.devicedefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.devicedefinition
    },
  )
}

pub fn devicemetric_create(
  resource: r4b.Devicemetric,
  client: FhirClient,
  handle_response: fn(Result(r4b.Devicemetric, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.devicemetric_to_json(resource),
    "DeviceMetric",
    r4b.devicemetric_decoder(),
    client,
    handle_response,
  )
}

pub fn devicemetric_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Devicemetric, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DeviceMetric",
    r4b.devicemetric_decoder(),
    client,
    handle_response,
  )
}

pub fn devicemetric_update(
  resource: r4b.Devicemetric,
  client: FhirClient,
  handle_response: fn(Result(r4b.Devicemetric, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.devicemetric_to_json(resource),
    "DeviceMetric",
    r4b.devicemetric_decoder(),
    client,
    handle_response,
  )
}

pub fn devicemetric_delete(
  resource: r4b.Devicemetric,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DeviceMetric", client, handle_response)
}

pub fn devicemetric_search_bundled(
  search_for search_args: r4b_sansio.SpDevicemetric,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.devicemetric_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn devicemetric_search(
  search_for search_args: r4b_sansio.SpDevicemetric,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Devicemetric), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.devicemetric_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.devicemetric
    },
  )
}

pub fn devicerequest_create(
  resource: r4b.Devicerequest,
  client: FhirClient,
  handle_response: fn(Result(r4b.Devicerequest, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.devicerequest_to_json(resource),
    "DeviceRequest",
    r4b.devicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn devicerequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Devicerequest, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DeviceRequest",
    r4b.devicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn devicerequest_update(
  resource: r4b.Devicerequest,
  client: FhirClient,
  handle_response: fn(Result(r4b.Devicerequest, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.devicerequest_to_json(resource),
    "DeviceRequest",
    r4b.devicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn devicerequest_delete(
  resource: r4b.Devicerequest,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DeviceRequest", client, handle_response)
}

pub fn devicerequest_search_bundled(
  search_for search_args: r4b_sansio.SpDevicerequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.devicerequest_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn devicerequest_search(
  search_for search_args: r4b_sansio.SpDevicerequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Devicerequest), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.devicerequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.devicerequest
    },
  )
}

pub fn deviceusestatement_create(
  resource: r4b.Deviceusestatement,
  client: FhirClient,
  handle_response: fn(Result(r4b.Deviceusestatement, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.deviceusestatement_to_json(resource),
    "DeviceUseStatement",
    r4b.deviceusestatement_decoder(),
    client,
    handle_response,
  )
}

pub fn deviceusestatement_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Deviceusestatement, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DeviceUseStatement",
    r4b.deviceusestatement_decoder(),
    client,
    handle_response,
  )
}

pub fn deviceusestatement_update(
  resource: r4b.Deviceusestatement,
  client: FhirClient,
  handle_response: fn(Result(r4b.Deviceusestatement, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.deviceusestatement_to_json(resource),
    "DeviceUseStatement",
    r4b.deviceusestatement_decoder(),
    client,
    handle_response,
  )
}

pub fn deviceusestatement_delete(
  resource: r4b.Deviceusestatement,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DeviceUseStatement", client, handle_response)
}

pub fn deviceusestatement_search_bundled(
  search_for search_args: r4b_sansio.SpDeviceusestatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.deviceusestatement_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn deviceusestatement_search(
  search_for search_args: r4b_sansio.SpDeviceusestatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Deviceusestatement), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.deviceusestatement_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.deviceusestatement
    },
  )
}

pub fn diagnosticreport_create(
  resource: r4b.Diagnosticreport,
  client: FhirClient,
  handle_response: fn(Result(r4b.Diagnosticreport, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.diagnosticreport_to_json(resource),
    "DiagnosticReport",
    r4b.diagnosticreport_decoder(),
    client,
    handle_response,
  )
}

pub fn diagnosticreport_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Diagnosticreport, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DiagnosticReport",
    r4b.diagnosticreport_decoder(),
    client,
    handle_response,
  )
}

pub fn diagnosticreport_update(
  resource: r4b.Diagnosticreport,
  client: FhirClient,
  handle_response: fn(Result(r4b.Diagnosticreport, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.diagnosticreport_to_json(resource),
    "DiagnosticReport",
    r4b.diagnosticreport_decoder(),
    client,
    handle_response,
  )
}

pub fn diagnosticreport_delete(
  resource: r4b.Diagnosticreport,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DiagnosticReport", client, handle_response)
}

pub fn diagnosticreport_search_bundled(
  search_for search_args: r4b_sansio.SpDiagnosticreport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.diagnosticreport_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn diagnosticreport_search(
  search_for search_args: r4b_sansio.SpDiagnosticreport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Diagnosticreport), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.diagnosticreport_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.diagnosticreport
    },
  )
}

pub fn documentmanifest_create(
  resource: r4b.Documentmanifest,
  client: FhirClient,
  handle_response: fn(Result(r4b.Documentmanifest, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.documentmanifest_to_json(resource),
    "DocumentManifest",
    r4b.documentmanifest_decoder(),
    client,
    handle_response,
  )
}

pub fn documentmanifest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Documentmanifest, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DocumentManifest",
    r4b.documentmanifest_decoder(),
    client,
    handle_response,
  )
}

pub fn documentmanifest_update(
  resource: r4b.Documentmanifest,
  client: FhirClient,
  handle_response: fn(Result(r4b.Documentmanifest, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.documentmanifest_to_json(resource),
    "DocumentManifest",
    r4b.documentmanifest_decoder(),
    client,
    handle_response,
  )
}

pub fn documentmanifest_delete(
  resource: r4b.Documentmanifest,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DocumentManifest", client, handle_response)
}

pub fn documentmanifest_search_bundled(
  search_for search_args: r4b_sansio.SpDocumentmanifest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.documentmanifest_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn documentmanifest_search(
  search_for search_args: r4b_sansio.SpDocumentmanifest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Documentmanifest), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.documentmanifest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.documentmanifest
    },
  )
}

pub fn documentreference_create(
  resource: r4b.Documentreference,
  client: FhirClient,
  handle_response: fn(Result(r4b.Documentreference, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.documentreference_to_json(resource),
    "DocumentReference",
    r4b.documentreference_decoder(),
    client,
    handle_response,
  )
}

pub fn documentreference_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Documentreference, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DocumentReference",
    r4b.documentreference_decoder(),
    client,
    handle_response,
  )
}

pub fn documentreference_update(
  resource: r4b.Documentreference,
  client: FhirClient,
  handle_response: fn(Result(r4b.Documentreference, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.documentreference_to_json(resource),
    "DocumentReference",
    r4b.documentreference_decoder(),
    client,
    handle_response,
  )
}

pub fn documentreference_delete(
  resource: r4b.Documentreference,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DocumentReference", client, handle_response)
}

pub fn documentreference_search_bundled(
  search_for search_args: r4b_sansio.SpDocumentreference,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.documentreference_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn documentreference_search(
  search_for search_args: r4b_sansio.SpDocumentreference,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Documentreference), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.documentreference_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.documentreference
    },
  )
}

pub fn encounter_create(
  resource: r4b.Encounter,
  client: FhirClient,
  handle_response: fn(Result(r4b.Encounter, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.encounter_to_json(resource),
    "Encounter",
    r4b.encounter_decoder(),
    client,
    handle_response,
  )
}

pub fn encounter_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Encounter, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Encounter", r4b.encounter_decoder(), client, handle_response)
}

pub fn encounter_update(
  resource: r4b.Encounter,
  client: FhirClient,
  handle_response: fn(Result(r4b.Encounter, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.encounter_to_json(resource),
    "Encounter",
    r4b.encounter_decoder(),
    client,
    handle_response,
  )
}

pub fn encounter_delete(
  resource: r4b.Encounter,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Encounter", client, handle_response)
}

pub fn encounter_search_bundled(
  search_for search_args: r4b_sansio.SpEncounter,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.encounter_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn encounter_search(
  search_for search_args: r4b_sansio.SpEncounter,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Encounter), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.encounter_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.encounter },
  )
}

pub fn endpoint_create(
  resource: r4b.Endpoint,
  client: FhirClient,
  handle_response: fn(Result(r4b.Endpoint, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.endpoint_to_json(resource),
    "Endpoint",
    r4b.endpoint_decoder(),
    client,
    handle_response,
  )
}

pub fn endpoint_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Endpoint, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Endpoint", r4b.endpoint_decoder(), client, handle_response)
}

pub fn endpoint_update(
  resource: r4b.Endpoint,
  client: FhirClient,
  handle_response: fn(Result(r4b.Endpoint, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.endpoint_to_json(resource),
    "Endpoint",
    r4b.endpoint_decoder(),
    client,
    handle_response,
  )
}

pub fn endpoint_delete(
  resource: r4b.Endpoint,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Endpoint", client, handle_response)
}

pub fn endpoint_search_bundled(
  search_for search_args: r4b_sansio.SpEndpoint,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.endpoint_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn endpoint_search(
  search_for search_args: r4b_sansio.SpEndpoint,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Endpoint), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.endpoint_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.endpoint },
  )
}

pub fn enrollmentrequest_create(
  resource: r4b.Enrollmentrequest,
  client: FhirClient,
  handle_response: fn(Result(r4b.Enrollmentrequest, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.enrollmentrequest_to_json(resource),
    "EnrollmentRequest",
    r4b.enrollmentrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Enrollmentrequest, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EnrollmentRequest",
    r4b.enrollmentrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentrequest_update(
  resource: r4b.Enrollmentrequest,
  client: FhirClient,
  handle_response: fn(Result(r4b.Enrollmentrequest, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.enrollmentrequest_to_json(resource),
    "EnrollmentRequest",
    r4b.enrollmentrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentrequest_delete(
  resource: r4b.Enrollmentrequest,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "EnrollmentRequest", client, handle_response)
}

pub fn enrollmentrequest_search_bundled(
  search_for search_args: r4b_sansio.SpEnrollmentrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.enrollmentrequest_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn enrollmentrequest_search(
  search_for search_args: r4b_sansio.SpEnrollmentrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Enrollmentrequest), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.enrollmentrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.enrollmentrequest
    },
  )
}

pub fn enrollmentresponse_create(
  resource: r4b.Enrollmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r4b.Enrollmentresponse, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.enrollmentresponse_to_json(resource),
    "EnrollmentResponse",
    r4b.enrollmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Enrollmentresponse, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EnrollmentResponse",
    r4b.enrollmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentresponse_update(
  resource: r4b.Enrollmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r4b.Enrollmentresponse, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.enrollmentresponse_to_json(resource),
    "EnrollmentResponse",
    r4b.enrollmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentresponse_delete(
  resource: r4b.Enrollmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "EnrollmentResponse", client, handle_response)
}

pub fn enrollmentresponse_search_bundled(
  search_for search_args: r4b_sansio.SpEnrollmentresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.enrollmentresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn enrollmentresponse_search(
  search_for search_args: r4b_sansio.SpEnrollmentresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Enrollmentresponse), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.enrollmentresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.enrollmentresponse
    },
  )
}

pub fn episodeofcare_create(
  resource: r4b.Episodeofcare,
  client: FhirClient,
  handle_response: fn(Result(r4b.Episodeofcare, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.episodeofcare_to_json(resource),
    "EpisodeOfCare",
    r4b.episodeofcare_decoder(),
    client,
    handle_response,
  )
}

pub fn episodeofcare_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Episodeofcare, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EpisodeOfCare",
    r4b.episodeofcare_decoder(),
    client,
    handle_response,
  )
}

pub fn episodeofcare_update(
  resource: r4b.Episodeofcare,
  client: FhirClient,
  handle_response: fn(Result(r4b.Episodeofcare, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.episodeofcare_to_json(resource),
    "EpisodeOfCare",
    r4b.episodeofcare_decoder(),
    client,
    handle_response,
  )
}

pub fn episodeofcare_delete(
  resource: r4b.Episodeofcare,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "EpisodeOfCare", client, handle_response)
}

pub fn episodeofcare_search_bundled(
  search_for search_args: r4b_sansio.SpEpisodeofcare,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.episodeofcare_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn episodeofcare_search(
  search_for search_args: r4b_sansio.SpEpisodeofcare,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Episodeofcare), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.episodeofcare_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.episodeofcare
    },
  )
}

pub fn eventdefinition_create(
  resource: r4b.Eventdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Eventdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.eventdefinition_to_json(resource),
    "EventDefinition",
    r4b.eventdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn eventdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Eventdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EventDefinition",
    r4b.eventdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn eventdefinition_update(
  resource: r4b.Eventdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Eventdefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.eventdefinition_to_json(resource),
    "EventDefinition",
    r4b.eventdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn eventdefinition_delete(
  resource: r4b.Eventdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "EventDefinition", client, handle_response)
}

pub fn eventdefinition_search_bundled(
  search_for search_args: r4b_sansio.SpEventdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.eventdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn eventdefinition_search(
  search_for search_args: r4b_sansio.SpEventdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Eventdefinition), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.eventdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.eventdefinition
    },
  )
}

pub fn evidence_create(
  resource: r4b.Evidence,
  client: FhirClient,
  handle_response: fn(Result(r4b.Evidence, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.evidence_to_json(resource),
    "Evidence",
    r4b.evidence_decoder(),
    client,
    handle_response,
  )
}

pub fn evidence_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Evidence, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Evidence", r4b.evidence_decoder(), client, handle_response)
}

pub fn evidence_update(
  resource: r4b.Evidence,
  client: FhirClient,
  handle_response: fn(Result(r4b.Evidence, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.evidence_to_json(resource),
    "Evidence",
    r4b.evidence_decoder(),
    client,
    handle_response,
  )
}

pub fn evidence_delete(
  resource: r4b.Evidence,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Evidence", client, handle_response)
}

pub fn evidence_search_bundled(
  search_for search_args: r4b_sansio.SpEvidence,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.evidence_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn evidence_search(
  search_for search_args: r4b_sansio.SpEvidence,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Evidence), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.evidence_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.evidence },
  )
}

pub fn evidencereport_create(
  resource: r4b.Evidencereport,
  client: FhirClient,
  handle_response: fn(Result(r4b.Evidencereport, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.evidencereport_to_json(resource),
    "EvidenceReport",
    r4b.evidencereport_decoder(),
    client,
    handle_response,
  )
}

pub fn evidencereport_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Evidencereport, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EvidenceReport",
    r4b.evidencereport_decoder(),
    client,
    handle_response,
  )
}

pub fn evidencereport_update(
  resource: r4b.Evidencereport,
  client: FhirClient,
  handle_response: fn(Result(r4b.Evidencereport, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.evidencereport_to_json(resource),
    "EvidenceReport",
    r4b.evidencereport_decoder(),
    client,
    handle_response,
  )
}

pub fn evidencereport_delete(
  resource: r4b.Evidencereport,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "EvidenceReport", client, handle_response)
}

pub fn evidencereport_search_bundled(
  search_for search_args: r4b_sansio.SpEvidencereport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.evidencereport_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn evidencereport_search(
  search_for search_args: r4b_sansio.SpEvidencereport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Evidencereport), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.evidencereport_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.evidencereport
    },
  )
}

pub fn evidencevariable_create(
  resource: r4b.Evidencevariable,
  client: FhirClient,
  handle_response: fn(Result(r4b.Evidencevariable, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.evidencevariable_to_json(resource),
    "EvidenceVariable",
    r4b.evidencevariable_decoder(),
    client,
    handle_response,
  )
}

pub fn evidencevariable_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Evidencevariable, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EvidenceVariable",
    r4b.evidencevariable_decoder(),
    client,
    handle_response,
  )
}

pub fn evidencevariable_update(
  resource: r4b.Evidencevariable,
  client: FhirClient,
  handle_response: fn(Result(r4b.Evidencevariable, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.evidencevariable_to_json(resource),
    "EvidenceVariable",
    r4b.evidencevariable_decoder(),
    client,
    handle_response,
  )
}

pub fn evidencevariable_delete(
  resource: r4b.Evidencevariable,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "EvidenceVariable", client, handle_response)
}

pub fn evidencevariable_search_bundled(
  search_for search_args: r4b_sansio.SpEvidencevariable,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.evidencevariable_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn evidencevariable_search(
  search_for search_args: r4b_sansio.SpEvidencevariable,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Evidencevariable), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.evidencevariable_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.evidencevariable
    },
  )
}

pub fn examplescenario_create(
  resource: r4b.Examplescenario,
  client: FhirClient,
  handle_response: fn(Result(r4b.Examplescenario, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.examplescenario_to_json(resource),
    "ExampleScenario",
    r4b.examplescenario_decoder(),
    client,
    handle_response,
  )
}

pub fn examplescenario_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Examplescenario, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ExampleScenario",
    r4b.examplescenario_decoder(),
    client,
    handle_response,
  )
}

pub fn examplescenario_update(
  resource: r4b.Examplescenario,
  client: FhirClient,
  handle_response: fn(Result(r4b.Examplescenario, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.examplescenario_to_json(resource),
    "ExampleScenario",
    r4b.examplescenario_decoder(),
    client,
    handle_response,
  )
}

pub fn examplescenario_delete(
  resource: r4b.Examplescenario,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ExampleScenario", client, handle_response)
}

pub fn examplescenario_search_bundled(
  search_for search_args: r4b_sansio.SpExamplescenario,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.examplescenario_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn examplescenario_search(
  search_for search_args: r4b_sansio.SpExamplescenario,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Examplescenario), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.examplescenario_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.examplescenario
    },
  )
}

pub fn explanationofbenefit_create(
  resource: r4b.Explanationofbenefit,
  client: FhirClient,
  handle_response: fn(Result(r4b.Explanationofbenefit, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.explanationofbenefit_to_json(resource),
    "ExplanationOfBenefit",
    r4b.explanationofbenefit_decoder(),
    client,
    handle_response,
  )
}

pub fn explanationofbenefit_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Explanationofbenefit, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ExplanationOfBenefit",
    r4b.explanationofbenefit_decoder(),
    client,
    handle_response,
  )
}

pub fn explanationofbenefit_update(
  resource: r4b.Explanationofbenefit,
  client: FhirClient,
  handle_response: fn(Result(r4b.Explanationofbenefit, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.explanationofbenefit_to_json(resource),
    "ExplanationOfBenefit",
    r4b.explanationofbenefit_decoder(),
    client,
    handle_response,
  )
}

pub fn explanationofbenefit_delete(
  resource: r4b.Explanationofbenefit,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ExplanationOfBenefit", client, handle_response)
}

pub fn explanationofbenefit_search_bundled(
  search_for search_args: r4b_sansio.SpExplanationofbenefit,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.explanationofbenefit_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn explanationofbenefit_search(
  search_for search_args: r4b_sansio.SpExplanationofbenefit,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Explanationofbenefit), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.explanationofbenefit_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.explanationofbenefit
    },
  )
}

pub fn familymemberhistory_create(
  resource: r4b.Familymemberhistory,
  client: FhirClient,
  handle_response: fn(Result(r4b.Familymemberhistory, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    r4b.familymemberhistory_decoder(),
    client,
    handle_response,
  )
}

pub fn familymemberhistory_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Familymemberhistory, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "FamilyMemberHistory",
    r4b.familymemberhistory_decoder(),
    client,
    handle_response,
  )
}

pub fn familymemberhistory_update(
  resource: r4b.Familymemberhistory,
  client: FhirClient,
  handle_response: fn(Result(r4b.Familymemberhistory, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    r4b.familymemberhistory_decoder(),
    client,
    handle_response,
  )
}

pub fn familymemberhistory_delete(
  resource: r4b.Familymemberhistory,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "FamilyMemberHistory", client, handle_response)
}

pub fn familymemberhistory_search_bundled(
  search_for search_args: r4b_sansio.SpFamilymemberhistory,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.familymemberhistory_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn familymemberhistory_search(
  search_for search_args: r4b_sansio.SpFamilymemberhistory,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Familymemberhistory), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.familymemberhistory_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.familymemberhistory
    },
  )
}

pub fn flag_create(
  resource: r4b.Flag,
  client: FhirClient,
  handle_response: fn(Result(r4b.Flag, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.flag_to_json(resource),
    "Flag",
    r4b.flag_decoder(),
    client,
    handle_response,
  )
}

pub fn flag_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Flag, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Flag", r4b.flag_decoder(), client, handle_response)
}

pub fn flag_update(
  resource: r4b.Flag,
  client: FhirClient,
  handle_response: fn(Result(r4b.Flag, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.flag_to_json(resource),
    "Flag",
    r4b.flag_decoder(),
    client,
    handle_response,
  )
}

pub fn flag_delete(
  resource: r4b.Flag,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Flag", client, handle_response)
}

pub fn flag_search_bundled(
  search_for search_args: r4b_sansio.SpFlag,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.flag_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn flag_search(
  search_for search_args: r4b_sansio.SpFlag,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Flag), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.flag_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.flag },
  )
}

pub fn goal_create(
  resource: r4b.Goal,
  client: FhirClient,
  handle_response: fn(Result(r4b.Goal, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.goal_to_json(resource),
    "Goal",
    r4b.goal_decoder(),
    client,
    handle_response,
  )
}

pub fn goal_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Goal, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Goal", r4b.goal_decoder(), client, handle_response)
}

pub fn goal_update(
  resource: r4b.Goal,
  client: FhirClient,
  handle_response: fn(Result(r4b.Goal, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.goal_to_json(resource),
    "Goal",
    r4b.goal_decoder(),
    client,
    handle_response,
  )
}

pub fn goal_delete(
  resource: r4b.Goal,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Goal", client, handle_response)
}

pub fn goal_search_bundled(
  search_for search_args: r4b_sansio.SpGoal,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.goal_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn goal_search(
  search_for search_args: r4b_sansio.SpGoal,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Goal), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.goal_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.goal },
  )
}

pub fn graphdefinition_create(
  resource: r4b.Graphdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Graphdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.graphdefinition_to_json(resource),
    "GraphDefinition",
    r4b.graphdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn graphdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Graphdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "GraphDefinition",
    r4b.graphdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn graphdefinition_update(
  resource: r4b.Graphdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Graphdefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.graphdefinition_to_json(resource),
    "GraphDefinition",
    r4b.graphdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn graphdefinition_delete(
  resource: r4b.Graphdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "GraphDefinition", client, handle_response)
}

pub fn graphdefinition_search_bundled(
  search_for search_args: r4b_sansio.SpGraphdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.graphdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn graphdefinition_search(
  search_for search_args: r4b_sansio.SpGraphdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Graphdefinition), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.graphdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.graphdefinition
    },
  )
}

pub fn group_create(
  resource: r4b.Group,
  client: FhirClient,
  handle_response: fn(Result(r4b.Group, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.group_to_json(resource),
    "Group",
    r4b.group_decoder(),
    client,
    handle_response,
  )
}

pub fn group_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Group, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Group", r4b.group_decoder(), client, handle_response)
}

pub fn group_update(
  resource: r4b.Group,
  client: FhirClient,
  handle_response: fn(Result(r4b.Group, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.group_to_json(resource),
    "Group",
    r4b.group_decoder(),
    client,
    handle_response,
  )
}

pub fn group_delete(
  resource: r4b.Group,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Group", client, handle_response)
}

pub fn group_search_bundled(
  search_for search_args: r4b_sansio.SpGroup,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.group_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn group_search(
  search_for search_args: r4b_sansio.SpGroup,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Group), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.group_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.group },
  )
}

pub fn guidanceresponse_create(
  resource: r4b.Guidanceresponse,
  client: FhirClient,
  handle_response: fn(Result(r4b.Guidanceresponse, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.guidanceresponse_to_json(resource),
    "GuidanceResponse",
    r4b.guidanceresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn guidanceresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Guidanceresponse, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "GuidanceResponse",
    r4b.guidanceresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn guidanceresponse_update(
  resource: r4b.Guidanceresponse,
  client: FhirClient,
  handle_response: fn(Result(r4b.Guidanceresponse, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.guidanceresponse_to_json(resource),
    "GuidanceResponse",
    r4b.guidanceresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn guidanceresponse_delete(
  resource: r4b.Guidanceresponse,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "GuidanceResponse", client, handle_response)
}

pub fn guidanceresponse_search_bundled(
  search_for search_args: r4b_sansio.SpGuidanceresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.guidanceresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn guidanceresponse_search(
  search_for search_args: r4b_sansio.SpGuidanceresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Guidanceresponse), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.guidanceresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.guidanceresponse
    },
  )
}

pub fn healthcareservice_create(
  resource: r4b.Healthcareservice,
  client: FhirClient,
  handle_response: fn(Result(r4b.Healthcareservice, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.healthcareservice_to_json(resource),
    "HealthcareService",
    r4b.healthcareservice_decoder(),
    client,
    handle_response,
  )
}

pub fn healthcareservice_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Healthcareservice, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "HealthcareService",
    r4b.healthcareservice_decoder(),
    client,
    handle_response,
  )
}

pub fn healthcareservice_update(
  resource: r4b.Healthcareservice,
  client: FhirClient,
  handle_response: fn(Result(r4b.Healthcareservice, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.healthcareservice_to_json(resource),
    "HealthcareService",
    r4b.healthcareservice_decoder(),
    client,
    handle_response,
  )
}

pub fn healthcareservice_delete(
  resource: r4b.Healthcareservice,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "HealthcareService", client, handle_response)
}

pub fn healthcareservice_search_bundled(
  search_for search_args: r4b_sansio.SpHealthcareservice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.healthcareservice_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn healthcareservice_search(
  search_for search_args: r4b_sansio.SpHealthcareservice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Healthcareservice), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.healthcareservice_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.healthcareservice
    },
  )
}

pub fn imagingstudy_create(
  resource: r4b.Imagingstudy,
  client: FhirClient,
  handle_response: fn(Result(r4b.Imagingstudy, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.imagingstudy_to_json(resource),
    "ImagingStudy",
    r4b.imagingstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn imagingstudy_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Imagingstudy, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ImagingStudy",
    r4b.imagingstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn imagingstudy_update(
  resource: r4b.Imagingstudy,
  client: FhirClient,
  handle_response: fn(Result(r4b.Imagingstudy, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.imagingstudy_to_json(resource),
    "ImagingStudy",
    r4b.imagingstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn imagingstudy_delete(
  resource: r4b.Imagingstudy,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ImagingStudy", client, handle_response)
}

pub fn imagingstudy_search_bundled(
  search_for search_args: r4b_sansio.SpImagingstudy,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.imagingstudy_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn imagingstudy_search(
  search_for search_args: r4b_sansio.SpImagingstudy,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Imagingstudy), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.imagingstudy_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.imagingstudy
    },
  )
}

pub fn immunization_create(
  resource: r4b.Immunization,
  client: FhirClient,
  handle_response: fn(Result(r4b.Immunization, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.immunization_to_json(resource),
    "Immunization",
    r4b.immunization_decoder(),
    client,
    handle_response,
  )
}

pub fn immunization_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Immunization, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Immunization",
    r4b.immunization_decoder(),
    client,
    handle_response,
  )
}

pub fn immunization_update(
  resource: r4b.Immunization,
  client: FhirClient,
  handle_response: fn(Result(r4b.Immunization, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.immunization_to_json(resource),
    "Immunization",
    r4b.immunization_decoder(),
    client,
    handle_response,
  )
}

pub fn immunization_delete(
  resource: r4b.Immunization,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Immunization", client, handle_response)
}

pub fn immunization_search_bundled(
  search_for search_args: r4b_sansio.SpImmunization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.immunization_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn immunization_search(
  search_for search_args: r4b_sansio.SpImmunization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Immunization), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.immunization_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.immunization
    },
  )
}

pub fn immunizationevaluation_create(
  resource: r4b.Immunizationevaluation,
  client: FhirClient,
  handle_response: fn(Result(r4b.Immunizationevaluation, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.immunizationevaluation_to_json(resource),
    "ImmunizationEvaluation",
    r4b.immunizationevaluation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationevaluation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Immunizationevaluation, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ImmunizationEvaluation",
    r4b.immunizationevaluation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationevaluation_update(
  resource: r4b.Immunizationevaluation,
  client: FhirClient,
  handle_response: fn(Result(r4b.Immunizationevaluation, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.immunizationevaluation_to_json(resource),
    "ImmunizationEvaluation",
    r4b.immunizationevaluation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationevaluation_delete(
  resource: r4b.Immunizationevaluation,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ImmunizationEvaluation", client, handle_response)
}

pub fn immunizationevaluation_search_bundled(
  search_for search_args: r4b_sansio.SpImmunizationevaluation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.immunizationevaluation_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn immunizationevaluation_search(
  search_for search_args: r4b_sansio.SpImmunizationevaluation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Immunizationevaluation), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.immunizationevaluation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.immunizationevaluation
    },
  )
}

pub fn immunizationrecommendation_create(
  resource: r4b.Immunizationrecommendation,
  client: FhirClient,
  handle_response: fn(Result(r4b.Immunizationrecommendation, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.immunizationrecommendation_to_json(resource),
    "ImmunizationRecommendation",
    r4b.immunizationrecommendation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationrecommendation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Immunizationrecommendation, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ImmunizationRecommendation",
    r4b.immunizationrecommendation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationrecommendation_update(
  resource: r4b.Immunizationrecommendation,
  client: FhirClient,
  handle_response: fn(Result(r4b.Immunizationrecommendation, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.immunizationrecommendation_to_json(resource),
    "ImmunizationRecommendation",
    r4b.immunizationrecommendation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationrecommendation_delete(
  resource: r4b.Immunizationrecommendation,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ImmunizationRecommendation", client, handle_response)
}

pub fn immunizationrecommendation_search_bundled(
  search_for search_args: r4b_sansio.SpImmunizationrecommendation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req =
    r4b_sansio.immunizationrecommendation_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn immunizationrecommendation_search(
  search_for search_args: r4b_sansio.SpImmunizationrecommendation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Immunizationrecommendation), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4b_sansio.immunizationrecommendation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.immunizationrecommendation
    },
  )
}

pub fn implementationguide_create(
  resource: r4b.Implementationguide,
  client: FhirClient,
  handle_response: fn(Result(r4b.Implementationguide, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.implementationguide_to_json(resource),
    "ImplementationGuide",
    r4b.implementationguide_decoder(),
    client,
    handle_response,
  )
}

pub fn implementationguide_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Implementationguide, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ImplementationGuide",
    r4b.implementationguide_decoder(),
    client,
    handle_response,
  )
}

pub fn implementationguide_update(
  resource: r4b.Implementationguide,
  client: FhirClient,
  handle_response: fn(Result(r4b.Implementationguide, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.implementationguide_to_json(resource),
    "ImplementationGuide",
    r4b.implementationguide_decoder(),
    client,
    handle_response,
  )
}

pub fn implementationguide_delete(
  resource: r4b.Implementationguide,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ImplementationGuide", client, handle_response)
}

pub fn implementationguide_search_bundled(
  search_for search_args: r4b_sansio.SpImplementationguide,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.implementationguide_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn implementationguide_search(
  search_for search_args: r4b_sansio.SpImplementationguide,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Implementationguide), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.implementationguide_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.implementationguide
    },
  )
}

pub fn ingredient_create(
  resource: r4b.Ingredient,
  client: FhirClient,
  handle_response: fn(Result(r4b.Ingredient, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.ingredient_to_json(resource),
    "Ingredient",
    r4b.ingredient_decoder(),
    client,
    handle_response,
  )
}

pub fn ingredient_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Ingredient, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Ingredient", r4b.ingredient_decoder(), client, handle_response)
}

pub fn ingredient_update(
  resource: r4b.Ingredient,
  client: FhirClient,
  handle_response: fn(Result(r4b.Ingredient, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.ingredient_to_json(resource),
    "Ingredient",
    r4b.ingredient_decoder(),
    client,
    handle_response,
  )
}

pub fn ingredient_delete(
  resource: r4b.Ingredient,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Ingredient", client, handle_response)
}

pub fn ingredient_search_bundled(
  search_for search_args: r4b_sansio.SpIngredient,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.ingredient_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn ingredient_search(
  search_for search_args: r4b_sansio.SpIngredient,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Ingredient), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.ingredient_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.ingredient
    },
  )
}

pub fn insuranceplan_create(
  resource: r4b.Insuranceplan,
  client: FhirClient,
  handle_response: fn(Result(r4b.Insuranceplan, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.insuranceplan_to_json(resource),
    "InsurancePlan",
    r4b.insuranceplan_decoder(),
    client,
    handle_response,
  )
}

pub fn insuranceplan_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Insuranceplan, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "InsurancePlan",
    r4b.insuranceplan_decoder(),
    client,
    handle_response,
  )
}

pub fn insuranceplan_update(
  resource: r4b.Insuranceplan,
  client: FhirClient,
  handle_response: fn(Result(r4b.Insuranceplan, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.insuranceplan_to_json(resource),
    "InsurancePlan",
    r4b.insuranceplan_decoder(),
    client,
    handle_response,
  )
}

pub fn insuranceplan_delete(
  resource: r4b.Insuranceplan,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "InsurancePlan", client, handle_response)
}

pub fn insuranceplan_search_bundled(
  search_for search_args: r4b_sansio.SpInsuranceplan,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.insuranceplan_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn insuranceplan_search(
  search_for search_args: r4b_sansio.SpInsuranceplan,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Insuranceplan), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.insuranceplan_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.insuranceplan
    },
  )
}

pub fn invoice_create(
  resource: r4b.Invoice,
  client: FhirClient,
  handle_response: fn(Result(r4b.Invoice, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.invoice_to_json(resource),
    "Invoice",
    r4b.invoice_decoder(),
    client,
    handle_response,
  )
}

pub fn invoice_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Invoice, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Invoice", r4b.invoice_decoder(), client, handle_response)
}

pub fn invoice_update(
  resource: r4b.Invoice,
  client: FhirClient,
  handle_response: fn(Result(r4b.Invoice, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.invoice_to_json(resource),
    "Invoice",
    r4b.invoice_decoder(),
    client,
    handle_response,
  )
}

pub fn invoice_delete(
  resource: r4b.Invoice,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Invoice", client, handle_response)
}

pub fn invoice_search_bundled(
  search_for search_args: r4b_sansio.SpInvoice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.invoice_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn invoice_search(
  search_for search_args: r4b_sansio.SpInvoice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Invoice), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.invoice_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.invoice },
  )
}

pub fn library_create(
  resource: r4b.Library,
  client: FhirClient,
  handle_response: fn(Result(r4b.Library, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.library_to_json(resource),
    "Library",
    r4b.library_decoder(),
    client,
    handle_response,
  )
}

pub fn library_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Library, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Library", r4b.library_decoder(), client, handle_response)
}

pub fn library_update(
  resource: r4b.Library,
  client: FhirClient,
  handle_response: fn(Result(r4b.Library, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.library_to_json(resource),
    "Library",
    r4b.library_decoder(),
    client,
    handle_response,
  )
}

pub fn library_delete(
  resource: r4b.Library,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Library", client, handle_response)
}

pub fn library_search_bundled(
  search_for search_args: r4b_sansio.SpLibrary,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.library_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn library_search(
  search_for search_args: r4b_sansio.SpLibrary,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Library), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.library_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.library },
  )
}

pub fn linkage_create(
  resource: r4b.Linkage,
  client: FhirClient,
  handle_response: fn(Result(r4b.Linkage, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.linkage_to_json(resource),
    "Linkage",
    r4b.linkage_decoder(),
    client,
    handle_response,
  )
}

pub fn linkage_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Linkage, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Linkage", r4b.linkage_decoder(), client, handle_response)
}

pub fn linkage_update(
  resource: r4b.Linkage,
  client: FhirClient,
  handle_response: fn(Result(r4b.Linkage, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.linkage_to_json(resource),
    "Linkage",
    r4b.linkage_decoder(),
    client,
    handle_response,
  )
}

pub fn linkage_delete(
  resource: r4b.Linkage,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Linkage", client, handle_response)
}

pub fn linkage_search_bundled(
  search_for search_args: r4b_sansio.SpLinkage,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.linkage_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn linkage_search(
  search_for search_args: r4b_sansio.SpLinkage,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Linkage), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.linkage_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.linkage },
  )
}

pub fn listfhir_create(
  resource: r4b.Listfhir,
  client: FhirClient,
  handle_response: fn(Result(r4b.Listfhir, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.listfhir_to_json(resource),
    "List",
    r4b.listfhir_decoder(),
    client,
    handle_response,
  )
}

pub fn listfhir_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Listfhir, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "List", r4b.listfhir_decoder(), client, handle_response)
}

pub fn listfhir_update(
  resource: r4b.Listfhir,
  client: FhirClient,
  handle_response: fn(Result(r4b.Listfhir, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.listfhir_to_json(resource),
    "List",
    r4b.listfhir_decoder(),
    client,
    handle_response,
  )
}

pub fn listfhir_delete(
  resource: r4b.Listfhir,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "List", client, handle_response)
}

pub fn listfhir_search_bundled(
  search_for search_args: r4b_sansio.SpListfhir,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.listfhir_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn listfhir_search(
  search_for search_args: r4b_sansio.SpListfhir,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Listfhir), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.listfhir_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.listfhir },
  )
}

pub fn location_create(
  resource: r4b.Location,
  client: FhirClient,
  handle_response: fn(Result(r4b.Location, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.location_to_json(resource),
    "Location",
    r4b.location_decoder(),
    client,
    handle_response,
  )
}

pub fn location_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Location, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Location", r4b.location_decoder(), client, handle_response)
}

pub fn location_update(
  resource: r4b.Location,
  client: FhirClient,
  handle_response: fn(Result(r4b.Location, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.location_to_json(resource),
    "Location",
    r4b.location_decoder(),
    client,
    handle_response,
  )
}

pub fn location_delete(
  resource: r4b.Location,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Location", client, handle_response)
}

pub fn location_search_bundled(
  search_for search_args: r4b_sansio.SpLocation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.location_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn location_search(
  search_for search_args: r4b_sansio.SpLocation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Location), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.location_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.location },
  )
}

pub fn manufactureditemdefinition_create(
  resource: r4b.Manufactureditemdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Manufactureditemdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.manufactureditemdefinition_to_json(resource),
    "ManufacturedItemDefinition",
    r4b.manufactureditemdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn manufactureditemdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Manufactureditemdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ManufacturedItemDefinition",
    r4b.manufactureditemdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn manufactureditemdefinition_update(
  resource: r4b.Manufactureditemdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Manufactureditemdefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.manufactureditemdefinition_to_json(resource),
    "ManufacturedItemDefinition",
    r4b.manufactureditemdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn manufactureditemdefinition_delete(
  resource: r4b.Manufactureditemdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ManufacturedItemDefinition", client, handle_response)
}

pub fn manufactureditemdefinition_search_bundled(
  search_for search_args: r4b_sansio.SpManufactureditemdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req =
    r4b_sansio.manufactureditemdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn manufactureditemdefinition_search(
  search_for search_args: r4b_sansio.SpManufactureditemdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Manufactureditemdefinition), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4b_sansio.manufactureditemdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.manufactureditemdefinition
    },
  )
}

pub fn measure_create(
  resource: r4b.Measure,
  client: FhirClient,
  handle_response: fn(Result(r4b.Measure, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.measure_to_json(resource),
    "Measure",
    r4b.measure_decoder(),
    client,
    handle_response,
  )
}

pub fn measure_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Measure, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Measure", r4b.measure_decoder(), client, handle_response)
}

pub fn measure_update(
  resource: r4b.Measure,
  client: FhirClient,
  handle_response: fn(Result(r4b.Measure, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.measure_to_json(resource),
    "Measure",
    r4b.measure_decoder(),
    client,
    handle_response,
  )
}

pub fn measure_delete(
  resource: r4b.Measure,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Measure", client, handle_response)
}

pub fn measure_search_bundled(
  search_for search_args: r4b_sansio.SpMeasure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.measure_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn measure_search(
  search_for search_args: r4b_sansio.SpMeasure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Measure), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.measure_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.measure },
  )
}

pub fn measurereport_create(
  resource: r4b.Measurereport,
  client: FhirClient,
  handle_response: fn(Result(r4b.Measurereport, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.measurereport_to_json(resource),
    "MeasureReport",
    r4b.measurereport_decoder(),
    client,
    handle_response,
  )
}

pub fn measurereport_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Measurereport, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MeasureReport",
    r4b.measurereport_decoder(),
    client,
    handle_response,
  )
}

pub fn measurereport_update(
  resource: r4b.Measurereport,
  client: FhirClient,
  handle_response: fn(Result(r4b.Measurereport, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.measurereport_to_json(resource),
    "MeasureReport",
    r4b.measurereport_decoder(),
    client,
    handle_response,
  )
}

pub fn measurereport_delete(
  resource: r4b.Measurereport,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MeasureReport", client, handle_response)
}

pub fn measurereport_search_bundled(
  search_for search_args: r4b_sansio.SpMeasurereport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.measurereport_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn measurereport_search(
  search_for search_args: r4b_sansio.SpMeasurereport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Measurereport), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.measurereport_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.measurereport
    },
  )
}

pub fn media_create(
  resource: r4b.Media,
  client: FhirClient,
  handle_response: fn(Result(r4b.Media, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.media_to_json(resource),
    "Media",
    r4b.media_decoder(),
    client,
    handle_response,
  )
}

pub fn media_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Media, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Media", r4b.media_decoder(), client, handle_response)
}

pub fn media_update(
  resource: r4b.Media,
  client: FhirClient,
  handle_response: fn(Result(r4b.Media, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.media_to_json(resource),
    "Media",
    r4b.media_decoder(),
    client,
    handle_response,
  )
}

pub fn media_delete(
  resource: r4b.Media,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Media", client, handle_response)
}

pub fn media_search_bundled(
  search_for search_args: r4b_sansio.SpMedia,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.media_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn media_search(
  search_for search_args: r4b_sansio.SpMedia,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Media), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.media_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.media },
  )
}

pub fn medication_create(
  resource: r4b.Medication,
  client: FhirClient,
  handle_response: fn(Result(r4b.Medication, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.medication_to_json(resource),
    "Medication",
    r4b.medication_decoder(),
    client,
    handle_response,
  )
}

pub fn medication_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Medication, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Medication", r4b.medication_decoder(), client, handle_response)
}

pub fn medication_update(
  resource: r4b.Medication,
  client: FhirClient,
  handle_response: fn(Result(r4b.Medication, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.medication_to_json(resource),
    "Medication",
    r4b.medication_decoder(),
    client,
    handle_response,
  )
}

pub fn medication_delete(
  resource: r4b.Medication,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Medication", client, handle_response)
}

pub fn medication_search_bundled(
  search_for search_args: r4b_sansio.SpMedication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.medication_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn medication_search(
  search_for search_args: r4b_sansio.SpMedication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Medication), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.medication_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.medication
    },
  )
}

pub fn medicationadministration_create(
  resource: r4b.Medicationadministration,
  client: FhirClient,
  handle_response: fn(Result(r4b.Medicationadministration, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.medicationadministration_to_json(resource),
    "MedicationAdministration",
    r4b.medicationadministration_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationadministration_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Medicationadministration, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationAdministration",
    r4b.medicationadministration_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationadministration_update(
  resource: r4b.Medicationadministration,
  client: FhirClient,
  handle_response: fn(Result(r4b.Medicationadministration, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.medicationadministration_to_json(resource),
    "MedicationAdministration",
    r4b.medicationadministration_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationadministration_delete(
  resource: r4b.Medicationadministration,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicationAdministration", client, handle_response)
}

pub fn medicationadministration_search_bundled(
  search_for search_args: r4b_sansio.SpMedicationadministration,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.medicationadministration_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn medicationadministration_search(
  search_for search_args: r4b_sansio.SpMedicationadministration,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Medicationadministration), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.medicationadministration_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.medicationadministration
    },
  )
}

pub fn medicationdispense_create(
  resource: r4b.Medicationdispense,
  client: FhirClient,
  handle_response: fn(Result(r4b.Medicationdispense, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.medicationdispense_to_json(resource),
    "MedicationDispense",
    r4b.medicationdispense_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationdispense_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Medicationdispense, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationDispense",
    r4b.medicationdispense_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationdispense_update(
  resource: r4b.Medicationdispense,
  client: FhirClient,
  handle_response: fn(Result(r4b.Medicationdispense, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.medicationdispense_to_json(resource),
    "MedicationDispense",
    r4b.medicationdispense_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationdispense_delete(
  resource: r4b.Medicationdispense,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicationDispense", client, handle_response)
}

pub fn medicationdispense_search_bundled(
  search_for search_args: r4b_sansio.SpMedicationdispense,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.medicationdispense_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn medicationdispense_search(
  search_for search_args: r4b_sansio.SpMedicationdispense,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Medicationdispense), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.medicationdispense_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.medicationdispense
    },
  )
}

pub fn medicationknowledge_create(
  resource: r4b.Medicationknowledge,
  client: FhirClient,
  handle_response: fn(Result(r4b.Medicationknowledge, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.medicationknowledge_to_json(resource),
    "MedicationKnowledge",
    r4b.medicationknowledge_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationknowledge_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Medicationknowledge, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationKnowledge",
    r4b.medicationknowledge_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationknowledge_update(
  resource: r4b.Medicationknowledge,
  client: FhirClient,
  handle_response: fn(Result(r4b.Medicationknowledge, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.medicationknowledge_to_json(resource),
    "MedicationKnowledge",
    r4b.medicationknowledge_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationknowledge_delete(
  resource: r4b.Medicationknowledge,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicationKnowledge", client, handle_response)
}

pub fn medicationknowledge_search_bundled(
  search_for search_args: r4b_sansio.SpMedicationknowledge,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.medicationknowledge_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn medicationknowledge_search(
  search_for search_args: r4b_sansio.SpMedicationknowledge,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Medicationknowledge), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.medicationknowledge_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.medicationknowledge
    },
  )
}

pub fn medicationrequest_create(
  resource: r4b.Medicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r4b.Medicationrequest, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.medicationrequest_to_json(resource),
    "MedicationRequest",
    r4b.medicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Medicationrequest, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationRequest",
    r4b.medicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationrequest_update(
  resource: r4b.Medicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r4b.Medicationrequest, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.medicationrequest_to_json(resource),
    "MedicationRequest",
    r4b.medicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationrequest_delete(
  resource: r4b.Medicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicationRequest", client, handle_response)
}

pub fn medicationrequest_search_bundled(
  search_for search_args: r4b_sansio.SpMedicationrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.medicationrequest_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn medicationrequest_search(
  search_for search_args: r4b_sansio.SpMedicationrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Medicationrequest), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.medicationrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.medicationrequest
    },
  )
}

pub fn medicationstatement_create(
  resource: r4b.Medicationstatement,
  client: FhirClient,
  handle_response: fn(Result(r4b.Medicationstatement, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.medicationstatement_to_json(resource),
    "MedicationStatement",
    r4b.medicationstatement_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationstatement_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Medicationstatement, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationStatement",
    r4b.medicationstatement_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationstatement_update(
  resource: r4b.Medicationstatement,
  client: FhirClient,
  handle_response: fn(Result(r4b.Medicationstatement, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.medicationstatement_to_json(resource),
    "MedicationStatement",
    r4b.medicationstatement_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationstatement_delete(
  resource: r4b.Medicationstatement,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicationStatement", client, handle_response)
}

pub fn medicationstatement_search_bundled(
  search_for search_args: r4b_sansio.SpMedicationstatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.medicationstatement_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn medicationstatement_search(
  search_for search_args: r4b_sansio.SpMedicationstatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Medicationstatement), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.medicationstatement_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.medicationstatement
    },
  )
}

pub fn medicinalproductdefinition_create(
  resource: r4b.Medicinalproductdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Medicinalproductdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.medicinalproductdefinition_to_json(resource),
    "MedicinalProductDefinition",
    r4b.medicinalproductdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Medicinalproductdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductDefinition",
    r4b.medicinalproductdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductdefinition_update(
  resource: r4b.Medicinalproductdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Medicinalproductdefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.medicinalproductdefinition_to_json(resource),
    "MedicinalProductDefinition",
    r4b.medicinalproductdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductdefinition_delete(
  resource: r4b.Medicinalproductdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicinalProductDefinition", client, handle_response)
}

pub fn medicinalproductdefinition_search_bundled(
  search_for search_args: r4b_sansio.SpMedicinalproductdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req =
    r4b_sansio.medicinalproductdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn medicinalproductdefinition_search(
  search_for search_args: r4b_sansio.SpMedicinalproductdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Medicinalproductdefinition), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r4b_sansio.medicinalproductdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.medicinalproductdefinition
    },
  )
}

pub fn messagedefinition_create(
  resource: r4b.Messagedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Messagedefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.messagedefinition_to_json(resource),
    "MessageDefinition",
    r4b.messagedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn messagedefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Messagedefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MessageDefinition",
    r4b.messagedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn messagedefinition_update(
  resource: r4b.Messagedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Messagedefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.messagedefinition_to_json(resource),
    "MessageDefinition",
    r4b.messagedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn messagedefinition_delete(
  resource: r4b.Messagedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MessageDefinition", client, handle_response)
}

pub fn messagedefinition_search_bundled(
  search_for search_args: r4b_sansio.SpMessagedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.messagedefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn messagedefinition_search(
  search_for search_args: r4b_sansio.SpMessagedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Messagedefinition), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.messagedefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.messagedefinition
    },
  )
}

pub fn messageheader_create(
  resource: r4b.Messageheader,
  client: FhirClient,
  handle_response: fn(Result(r4b.Messageheader, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.messageheader_to_json(resource),
    "MessageHeader",
    r4b.messageheader_decoder(),
    client,
    handle_response,
  )
}

pub fn messageheader_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Messageheader, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MessageHeader",
    r4b.messageheader_decoder(),
    client,
    handle_response,
  )
}

pub fn messageheader_update(
  resource: r4b.Messageheader,
  client: FhirClient,
  handle_response: fn(Result(r4b.Messageheader, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.messageheader_to_json(resource),
    "MessageHeader",
    r4b.messageheader_decoder(),
    client,
    handle_response,
  )
}

pub fn messageheader_delete(
  resource: r4b.Messageheader,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MessageHeader", client, handle_response)
}

pub fn messageheader_search_bundled(
  search_for search_args: r4b_sansio.SpMessageheader,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.messageheader_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn messageheader_search(
  search_for search_args: r4b_sansio.SpMessageheader,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Messageheader), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.messageheader_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.messageheader
    },
  )
}

pub fn molecularsequence_create(
  resource: r4b.Molecularsequence,
  client: FhirClient,
  handle_response: fn(Result(r4b.Molecularsequence, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.molecularsequence_to_json(resource),
    "MolecularSequence",
    r4b.molecularsequence_decoder(),
    client,
    handle_response,
  )
}

pub fn molecularsequence_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Molecularsequence, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MolecularSequence",
    r4b.molecularsequence_decoder(),
    client,
    handle_response,
  )
}

pub fn molecularsequence_update(
  resource: r4b.Molecularsequence,
  client: FhirClient,
  handle_response: fn(Result(r4b.Molecularsequence, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.molecularsequence_to_json(resource),
    "MolecularSequence",
    r4b.molecularsequence_decoder(),
    client,
    handle_response,
  )
}

pub fn molecularsequence_delete(
  resource: r4b.Molecularsequence,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MolecularSequence", client, handle_response)
}

pub fn molecularsequence_search_bundled(
  search_for search_args: r4b_sansio.SpMolecularsequence,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.molecularsequence_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn molecularsequence_search(
  search_for search_args: r4b_sansio.SpMolecularsequence,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Molecularsequence), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.molecularsequence_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.molecularsequence
    },
  )
}

pub fn namingsystem_create(
  resource: r4b.Namingsystem,
  client: FhirClient,
  handle_response: fn(Result(r4b.Namingsystem, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.namingsystem_to_json(resource),
    "NamingSystem",
    r4b.namingsystem_decoder(),
    client,
    handle_response,
  )
}

pub fn namingsystem_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Namingsystem, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "NamingSystem",
    r4b.namingsystem_decoder(),
    client,
    handle_response,
  )
}

pub fn namingsystem_update(
  resource: r4b.Namingsystem,
  client: FhirClient,
  handle_response: fn(Result(r4b.Namingsystem, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.namingsystem_to_json(resource),
    "NamingSystem",
    r4b.namingsystem_decoder(),
    client,
    handle_response,
  )
}

pub fn namingsystem_delete(
  resource: r4b.Namingsystem,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "NamingSystem", client, handle_response)
}

pub fn namingsystem_search_bundled(
  search_for search_args: r4b_sansio.SpNamingsystem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.namingsystem_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn namingsystem_search(
  search_for search_args: r4b_sansio.SpNamingsystem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Namingsystem), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.namingsystem_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.namingsystem
    },
  )
}

pub fn nutritionorder_create(
  resource: r4b.Nutritionorder,
  client: FhirClient,
  handle_response: fn(Result(r4b.Nutritionorder, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.nutritionorder_to_json(resource),
    "NutritionOrder",
    r4b.nutritionorder_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionorder_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Nutritionorder, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "NutritionOrder",
    r4b.nutritionorder_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionorder_update(
  resource: r4b.Nutritionorder,
  client: FhirClient,
  handle_response: fn(Result(r4b.Nutritionorder, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.nutritionorder_to_json(resource),
    "NutritionOrder",
    r4b.nutritionorder_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionorder_delete(
  resource: r4b.Nutritionorder,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "NutritionOrder", client, handle_response)
}

pub fn nutritionorder_search_bundled(
  search_for search_args: r4b_sansio.SpNutritionorder,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.nutritionorder_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn nutritionorder_search(
  search_for search_args: r4b_sansio.SpNutritionorder,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Nutritionorder), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.nutritionorder_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.nutritionorder
    },
  )
}

pub fn nutritionproduct_create(
  resource: r4b.Nutritionproduct,
  client: FhirClient,
  handle_response: fn(Result(r4b.Nutritionproduct, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.nutritionproduct_to_json(resource),
    "NutritionProduct",
    r4b.nutritionproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionproduct_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Nutritionproduct, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "NutritionProduct",
    r4b.nutritionproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionproduct_update(
  resource: r4b.Nutritionproduct,
  client: FhirClient,
  handle_response: fn(Result(r4b.Nutritionproduct, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.nutritionproduct_to_json(resource),
    "NutritionProduct",
    r4b.nutritionproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionproduct_delete(
  resource: r4b.Nutritionproduct,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "NutritionProduct", client, handle_response)
}

pub fn nutritionproduct_search_bundled(
  search_for search_args: r4b_sansio.SpNutritionproduct,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.nutritionproduct_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn nutritionproduct_search(
  search_for search_args: r4b_sansio.SpNutritionproduct,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Nutritionproduct), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.nutritionproduct_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.nutritionproduct
    },
  )
}

pub fn observation_create(
  resource: r4b.Observation,
  client: FhirClient,
  handle_response: fn(Result(r4b.Observation, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.observation_to_json(resource),
    "Observation",
    r4b.observation_decoder(),
    client,
    handle_response,
  )
}

pub fn observation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Observation, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Observation",
    r4b.observation_decoder(),
    client,
    handle_response,
  )
}

pub fn observation_update(
  resource: r4b.Observation,
  client: FhirClient,
  handle_response: fn(Result(r4b.Observation, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.observation_to_json(resource),
    "Observation",
    r4b.observation_decoder(),
    client,
    handle_response,
  )
}

pub fn observation_delete(
  resource: r4b.Observation,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Observation", client, handle_response)
}

pub fn observation_search_bundled(
  search_for search_args: r4b_sansio.SpObservation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.observation_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn observation_search(
  search_for search_args: r4b_sansio.SpObservation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Observation), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.observation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.observation
    },
  )
}

pub fn observationdefinition_create(
  resource: r4b.Observationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Observationdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.observationdefinition_to_json(resource),
    "ObservationDefinition",
    r4b.observationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn observationdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Observationdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ObservationDefinition",
    r4b.observationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn observationdefinition_update(
  resource: r4b.Observationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Observationdefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.observationdefinition_to_json(resource),
    "ObservationDefinition",
    r4b.observationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn observationdefinition_delete(
  resource: r4b.Observationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ObservationDefinition", client, handle_response)
}

pub fn observationdefinition_search_bundled(
  search_for search_args: r4b_sansio.SpObservationdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.observationdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn observationdefinition_search(
  search_for search_args: r4b_sansio.SpObservationdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Observationdefinition), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.observationdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.observationdefinition
    },
  )
}

pub fn operationdefinition_create(
  resource: r4b.Operationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.operationdefinition_to_json(resource),
    "OperationDefinition",
    r4b.operationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn operationdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "OperationDefinition",
    r4b.operationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn operationdefinition_update(
  resource: r4b.Operationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationdefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.operationdefinition_to_json(resource),
    "OperationDefinition",
    r4b.operationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn operationdefinition_delete(
  resource: r4b.Operationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "OperationDefinition", client, handle_response)
}

pub fn operationdefinition_search_bundled(
  search_for search_args: r4b_sansio.SpOperationdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.operationdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn operationdefinition_search(
  search_for search_args: r4b_sansio.SpOperationdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Operationdefinition), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.operationdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.operationdefinition
    },
  )
}

pub fn operationoutcome_create(
  resource: r4b.Operationoutcome,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.operationoutcome_to_json(resource),
    "OperationOutcome",
    r4b.operationoutcome_decoder(),
    client,
    handle_response,
  )
}

pub fn operationoutcome_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "OperationOutcome",
    r4b.operationoutcome_decoder(),
    client,
    handle_response,
  )
}

pub fn operationoutcome_update(
  resource: r4b.Operationoutcome,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.operationoutcome_to_json(resource),
    "OperationOutcome",
    r4b.operationoutcome_decoder(),
    client,
    handle_response,
  )
}

pub fn operationoutcome_delete(
  resource: r4b.Operationoutcome,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "OperationOutcome", client, handle_response)
}

pub fn operationoutcome_search_bundled(
  search_for search_args: r4b_sansio.SpOperationoutcome,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.operationoutcome_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn operationoutcome_search(
  search_for search_args: r4b_sansio.SpOperationoutcome,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Operationoutcome), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.operationoutcome_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.operationoutcome
    },
  )
}

pub fn organization_create(
  resource: r4b.Organization,
  client: FhirClient,
  handle_response: fn(Result(r4b.Organization, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.organization_to_json(resource),
    "Organization",
    r4b.organization_decoder(),
    client,
    handle_response,
  )
}

pub fn organization_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Organization, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Organization",
    r4b.organization_decoder(),
    client,
    handle_response,
  )
}

pub fn organization_update(
  resource: r4b.Organization,
  client: FhirClient,
  handle_response: fn(Result(r4b.Organization, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.organization_to_json(resource),
    "Organization",
    r4b.organization_decoder(),
    client,
    handle_response,
  )
}

pub fn organization_delete(
  resource: r4b.Organization,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Organization", client, handle_response)
}

pub fn organization_search_bundled(
  search_for search_args: r4b_sansio.SpOrganization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.organization_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn organization_search(
  search_for search_args: r4b_sansio.SpOrganization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Organization), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.organization_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.organization
    },
  )
}

pub fn organizationaffiliation_create(
  resource: r4b.Organizationaffiliation,
  client: FhirClient,
  handle_response: fn(Result(r4b.Organizationaffiliation, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.organizationaffiliation_to_json(resource),
    "OrganizationAffiliation",
    r4b.organizationaffiliation_decoder(),
    client,
    handle_response,
  )
}

pub fn organizationaffiliation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Organizationaffiliation, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "OrganizationAffiliation",
    r4b.organizationaffiliation_decoder(),
    client,
    handle_response,
  )
}

pub fn organizationaffiliation_update(
  resource: r4b.Organizationaffiliation,
  client: FhirClient,
  handle_response: fn(Result(r4b.Organizationaffiliation, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.organizationaffiliation_to_json(resource),
    "OrganizationAffiliation",
    r4b.organizationaffiliation_decoder(),
    client,
    handle_response,
  )
}

pub fn organizationaffiliation_delete(
  resource: r4b.Organizationaffiliation,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "OrganizationAffiliation", client, handle_response)
}

pub fn organizationaffiliation_search_bundled(
  search_for search_args: r4b_sansio.SpOrganizationaffiliation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.organizationaffiliation_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn organizationaffiliation_search(
  search_for search_args: r4b_sansio.SpOrganizationaffiliation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Organizationaffiliation), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.organizationaffiliation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.organizationaffiliation
    },
  )
}

pub fn packagedproductdefinition_create(
  resource: r4b.Packagedproductdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Packagedproductdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.packagedproductdefinition_to_json(resource),
    "PackagedProductDefinition",
    r4b.packagedproductdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn packagedproductdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Packagedproductdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "PackagedProductDefinition",
    r4b.packagedproductdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn packagedproductdefinition_update(
  resource: r4b.Packagedproductdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Packagedproductdefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.packagedproductdefinition_to_json(resource),
    "PackagedProductDefinition",
    r4b.packagedproductdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn packagedproductdefinition_delete(
  resource: r4b.Packagedproductdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "PackagedProductDefinition", client, handle_response)
}

pub fn packagedproductdefinition_search_bundled(
  search_for search_args: r4b_sansio.SpPackagedproductdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.packagedproductdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn packagedproductdefinition_search(
  search_for search_args: r4b_sansio.SpPackagedproductdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Packagedproductdefinition), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.packagedproductdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.packagedproductdefinition
    },
  )
}

pub fn patient_create(
  resource: r4b.Patient,
  client: FhirClient,
  handle_response: fn(Result(r4b.Patient, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.patient_to_json(resource),
    "Patient",
    r4b.patient_decoder(),
    client,
    handle_response,
  )
}

pub fn patient_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Patient, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Patient", r4b.patient_decoder(), client, handle_response)
}

pub fn patient_update(
  resource: r4b.Patient,
  client: FhirClient,
  handle_response: fn(Result(r4b.Patient, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.patient_to_json(resource),
    "Patient",
    r4b.patient_decoder(),
    client,
    handle_response,
  )
}

pub fn patient_delete(
  resource: r4b.Patient,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Patient", client, handle_response)
}

pub fn patient_search_bundled(
  search_for search_args: r4b_sansio.SpPatient,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.patient_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn patient_search(
  search_for search_args: r4b_sansio.SpPatient,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Patient), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.patient_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.patient },
  )
}

pub fn paymentnotice_create(
  resource: r4b.Paymentnotice,
  client: FhirClient,
  handle_response: fn(Result(r4b.Paymentnotice, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.paymentnotice_to_json(resource),
    "PaymentNotice",
    r4b.paymentnotice_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentnotice_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Paymentnotice, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "PaymentNotice",
    r4b.paymentnotice_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentnotice_update(
  resource: r4b.Paymentnotice,
  client: FhirClient,
  handle_response: fn(Result(r4b.Paymentnotice, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.paymentnotice_to_json(resource),
    "PaymentNotice",
    r4b.paymentnotice_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentnotice_delete(
  resource: r4b.Paymentnotice,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "PaymentNotice", client, handle_response)
}

pub fn paymentnotice_search_bundled(
  search_for search_args: r4b_sansio.SpPaymentnotice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.paymentnotice_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn paymentnotice_search(
  search_for search_args: r4b_sansio.SpPaymentnotice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Paymentnotice), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.paymentnotice_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.paymentnotice
    },
  )
}

pub fn paymentreconciliation_create(
  resource: r4b.Paymentreconciliation,
  client: FhirClient,
  handle_response: fn(Result(r4b.Paymentreconciliation, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.paymentreconciliation_to_json(resource),
    "PaymentReconciliation",
    r4b.paymentreconciliation_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentreconciliation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Paymentreconciliation, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "PaymentReconciliation",
    r4b.paymentreconciliation_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentreconciliation_update(
  resource: r4b.Paymentreconciliation,
  client: FhirClient,
  handle_response: fn(Result(r4b.Paymentreconciliation, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.paymentreconciliation_to_json(resource),
    "PaymentReconciliation",
    r4b.paymentreconciliation_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentreconciliation_delete(
  resource: r4b.Paymentreconciliation,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "PaymentReconciliation", client, handle_response)
}

pub fn paymentreconciliation_search_bundled(
  search_for search_args: r4b_sansio.SpPaymentreconciliation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.paymentreconciliation_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn paymentreconciliation_search(
  search_for search_args: r4b_sansio.SpPaymentreconciliation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Paymentreconciliation), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.paymentreconciliation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.paymentreconciliation
    },
  )
}

pub fn person_create(
  resource: r4b.Person,
  client: FhirClient,
  handle_response: fn(Result(r4b.Person, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.person_to_json(resource),
    "Person",
    r4b.person_decoder(),
    client,
    handle_response,
  )
}

pub fn person_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Person, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Person", r4b.person_decoder(), client, handle_response)
}

pub fn person_update(
  resource: r4b.Person,
  client: FhirClient,
  handle_response: fn(Result(r4b.Person, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.person_to_json(resource),
    "Person",
    r4b.person_decoder(),
    client,
    handle_response,
  )
}

pub fn person_delete(
  resource: r4b.Person,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Person", client, handle_response)
}

pub fn person_search_bundled(
  search_for search_args: r4b_sansio.SpPerson,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.person_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn person_search(
  search_for search_args: r4b_sansio.SpPerson,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Person), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.person_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.person },
  )
}

pub fn plandefinition_create(
  resource: r4b.Plandefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Plandefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.plandefinition_to_json(resource),
    "PlanDefinition",
    r4b.plandefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn plandefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Plandefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "PlanDefinition",
    r4b.plandefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn plandefinition_update(
  resource: r4b.Plandefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Plandefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.plandefinition_to_json(resource),
    "PlanDefinition",
    r4b.plandefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn plandefinition_delete(
  resource: r4b.Plandefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "PlanDefinition", client, handle_response)
}

pub fn plandefinition_search_bundled(
  search_for search_args: r4b_sansio.SpPlandefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.plandefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn plandefinition_search(
  search_for search_args: r4b_sansio.SpPlandefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Plandefinition), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.plandefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.plandefinition
    },
  )
}

pub fn practitioner_create(
  resource: r4b.Practitioner,
  client: FhirClient,
  handle_response: fn(Result(r4b.Practitioner, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.practitioner_to_json(resource),
    "Practitioner",
    r4b.practitioner_decoder(),
    client,
    handle_response,
  )
}

pub fn practitioner_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Practitioner, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Practitioner",
    r4b.practitioner_decoder(),
    client,
    handle_response,
  )
}

pub fn practitioner_update(
  resource: r4b.Practitioner,
  client: FhirClient,
  handle_response: fn(Result(r4b.Practitioner, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.practitioner_to_json(resource),
    "Practitioner",
    r4b.practitioner_decoder(),
    client,
    handle_response,
  )
}

pub fn practitioner_delete(
  resource: r4b.Practitioner,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Practitioner", client, handle_response)
}

pub fn practitioner_search_bundled(
  search_for search_args: r4b_sansio.SpPractitioner,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.practitioner_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn practitioner_search(
  search_for search_args: r4b_sansio.SpPractitioner,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Practitioner), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.practitioner_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.practitioner
    },
  )
}

pub fn practitionerrole_create(
  resource: r4b.Practitionerrole,
  client: FhirClient,
  handle_response: fn(Result(r4b.Practitionerrole, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.practitionerrole_to_json(resource),
    "PractitionerRole",
    r4b.practitionerrole_decoder(),
    client,
    handle_response,
  )
}

pub fn practitionerrole_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Practitionerrole, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "PractitionerRole",
    r4b.practitionerrole_decoder(),
    client,
    handle_response,
  )
}

pub fn practitionerrole_update(
  resource: r4b.Practitionerrole,
  client: FhirClient,
  handle_response: fn(Result(r4b.Practitionerrole, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.practitionerrole_to_json(resource),
    "PractitionerRole",
    r4b.practitionerrole_decoder(),
    client,
    handle_response,
  )
}

pub fn practitionerrole_delete(
  resource: r4b.Practitionerrole,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "PractitionerRole", client, handle_response)
}

pub fn practitionerrole_search_bundled(
  search_for search_args: r4b_sansio.SpPractitionerrole,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.practitionerrole_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn practitionerrole_search(
  search_for search_args: r4b_sansio.SpPractitionerrole,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Practitionerrole), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.practitionerrole_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.practitionerrole
    },
  )
}

pub fn procedure_create(
  resource: r4b.Procedure,
  client: FhirClient,
  handle_response: fn(Result(r4b.Procedure, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.procedure_to_json(resource),
    "Procedure",
    r4b.procedure_decoder(),
    client,
    handle_response,
  )
}

pub fn procedure_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Procedure, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Procedure", r4b.procedure_decoder(), client, handle_response)
}

pub fn procedure_update(
  resource: r4b.Procedure,
  client: FhirClient,
  handle_response: fn(Result(r4b.Procedure, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.procedure_to_json(resource),
    "Procedure",
    r4b.procedure_decoder(),
    client,
    handle_response,
  )
}

pub fn procedure_delete(
  resource: r4b.Procedure,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Procedure", client, handle_response)
}

pub fn procedure_search_bundled(
  search_for search_args: r4b_sansio.SpProcedure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.procedure_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn procedure_search(
  search_for search_args: r4b_sansio.SpProcedure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Procedure), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.procedure_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.procedure },
  )
}

pub fn provenance_create(
  resource: r4b.Provenance,
  client: FhirClient,
  handle_response: fn(Result(r4b.Provenance, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.provenance_to_json(resource),
    "Provenance",
    r4b.provenance_decoder(),
    client,
    handle_response,
  )
}

pub fn provenance_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Provenance, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Provenance", r4b.provenance_decoder(), client, handle_response)
}

pub fn provenance_update(
  resource: r4b.Provenance,
  client: FhirClient,
  handle_response: fn(Result(r4b.Provenance, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.provenance_to_json(resource),
    "Provenance",
    r4b.provenance_decoder(),
    client,
    handle_response,
  )
}

pub fn provenance_delete(
  resource: r4b.Provenance,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Provenance", client, handle_response)
}

pub fn provenance_search_bundled(
  search_for search_args: r4b_sansio.SpProvenance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.provenance_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn provenance_search(
  search_for search_args: r4b_sansio.SpProvenance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Provenance), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.provenance_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.provenance
    },
  )
}

pub fn questionnaire_create(
  resource: r4b.Questionnaire,
  client: FhirClient,
  handle_response: fn(Result(r4b.Questionnaire, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.questionnaire_to_json(resource),
    "Questionnaire",
    r4b.questionnaire_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaire_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Questionnaire, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Questionnaire",
    r4b.questionnaire_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaire_update(
  resource: r4b.Questionnaire,
  client: FhirClient,
  handle_response: fn(Result(r4b.Questionnaire, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.questionnaire_to_json(resource),
    "Questionnaire",
    r4b.questionnaire_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaire_delete(
  resource: r4b.Questionnaire,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Questionnaire", client, handle_response)
}

pub fn questionnaire_search_bundled(
  search_for search_args: r4b_sansio.SpQuestionnaire,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.questionnaire_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn questionnaire_search(
  search_for search_args: r4b_sansio.SpQuestionnaire,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Questionnaire), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.questionnaire_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.questionnaire
    },
  )
}

pub fn questionnaireresponse_create(
  resource: r4b.Questionnaireresponse,
  client: FhirClient,
  handle_response: fn(Result(r4b.Questionnaireresponse, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    r4b.questionnaireresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaireresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Questionnaireresponse, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "QuestionnaireResponse",
    r4b.questionnaireresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaireresponse_update(
  resource: r4b.Questionnaireresponse,
  client: FhirClient,
  handle_response: fn(Result(r4b.Questionnaireresponse, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    r4b.questionnaireresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaireresponse_delete(
  resource: r4b.Questionnaireresponse,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "QuestionnaireResponse", client, handle_response)
}

pub fn questionnaireresponse_search_bundled(
  search_for search_args: r4b_sansio.SpQuestionnaireresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.questionnaireresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn questionnaireresponse_search(
  search_for search_args: r4b_sansio.SpQuestionnaireresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Questionnaireresponse), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.questionnaireresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.questionnaireresponse
    },
  )
}

pub fn regulatedauthorization_create(
  resource: r4b.Regulatedauthorization,
  client: FhirClient,
  handle_response: fn(Result(r4b.Regulatedauthorization, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.regulatedauthorization_to_json(resource),
    "RegulatedAuthorization",
    r4b.regulatedauthorization_decoder(),
    client,
    handle_response,
  )
}

pub fn regulatedauthorization_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Regulatedauthorization, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "RegulatedAuthorization",
    r4b.regulatedauthorization_decoder(),
    client,
    handle_response,
  )
}

pub fn regulatedauthorization_update(
  resource: r4b.Regulatedauthorization,
  client: FhirClient,
  handle_response: fn(Result(r4b.Regulatedauthorization, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.regulatedauthorization_to_json(resource),
    "RegulatedAuthorization",
    r4b.regulatedauthorization_decoder(),
    client,
    handle_response,
  )
}

pub fn regulatedauthorization_delete(
  resource: r4b.Regulatedauthorization,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "RegulatedAuthorization", client, handle_response)
}

pub fn regulatedauthorization_search_bundled(
  search_for search_args: r4b_sansio.SpRegulatedauthorization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.regulatedauthorization_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn regulatedauthorization_search(
  search_for search_args: r4b_sansio.SpRegulatedauthorization,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Regulatedauthorization), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.regulatedauthorization_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.regulatedauthorization
    },
  )
}

pub fn relatedperson_create(
  resource: r4b.Relatedperson,
  client: FhirClient,
  handle_response: fn(Result(r4b.Relatedperson, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.relatedperson_to_json(resource),
    "RelatedPerson",
    r4b.relatedperson_decoder(),
    client,
    handle_response,
  )
}

pub fn relatedperson_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Relatedperson, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "RelatedPerson",
    r4b.relatedperson_decoder(),
    client,
    handle_response,
  )
}

pub fn relatedperson_update(
  resource: r4b.Relatedperson,
  client: FhirClient,
  handle_response: fn(Result(r4b.Relatedperson, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.relatedperson_to_json(resource),
    "RelatedPerson",
    r4b.relatedperson_decoder(),
    client,
    handle_response,
  )
}

pub fn relatedperson_delete(
  resource: r4b.Relatedperson,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "RelatedPerson", client, handle_response)
}

pub fn relatedperson_search_bundled(
  search_for search_args: r4b_sansio.SpRelatedperson,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.relatedperson_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn relatedperson_search(
  search_for search_args: r4b_sansio.SpRelatedperson,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Relatedperson), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.relatedperson_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.relatedperson
    },
  )
}

pub fn requestgroup_create(
  resource: r4b.Requestgroup,
  client: FhirClient,
  handle_response: fn(Result(r4b.Requestgroup, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.requestgroup_to_json(resource),
    "RequestGroup",
    r4b.requestgroup_decoder(),
    client,
    handle_response,
  )
}

pub fn requestgroup_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Requestgroup, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "RequestGroup",
    r4b.requestgroup_decoder(),
    client,
    handle_response,
  )
}

pub fn requestgroup_update(
  resource: r4b.Requestgroup,
  client: FhirClient,
  handle_response: fn(Result(r4b.Requestgroup, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.requestgroup_to_json(resource),
    "RequestGroup",
    r4b.requestgroup_decoder(),
    client,
    handle_response,
  )
}

pub fn requestgroup_delete(
  resource: r4b.Requestgroup,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "RequestGroup", client, handle_response)
}

pub fn requestgroup_search_bundled(
  search_for search_args: r4b_sansio.SpRequestgroup,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.requestgroup_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn requestgroup_search(
  search_for search_args: r4b_sansio.SpRequestgroup,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Requestgroup), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.requestgroup_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.requestgroup
    },
  )
}

pub fn researchdefinition_create(
  resource: r4b.Researchdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Researchdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.researchdefinition_to_json(resource),
    "ResearchDefinition",
    r4b.researchdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn researchdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Researchdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ResearchDefinition",
    r4b.researchdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn researchdefinition_update(
  resource: r4b.Researchdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Researchdefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.researchdefinition_to_json(resource),
    "ResearchDefinition",
    r4b.researchdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn researchdefinition_delete(
  resource: r4b.Researchdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ResearchDefinition", client, handle_response)
}

pub fn researchdefinition_search_bundled(
  search_for search_args: r4b_sansio.SpResearchdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.researchdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn researchdefinition_search(
  search_for search_args: r4b_sansio.SpResearchdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Researchdefinition), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.researchdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.researchdefinition
    },
  )
}

pub fn researchelementdefinition_create(
  resource: r4b.Researchelementdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Researchelementdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.researchelementdefinition_to_json(resource),
    "ResearchElementDefinition",
    r4b.researchelementdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn researchelementdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Researchelementdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ResearchElementDefinition",
    r4b.researchelementdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn researchelementdefinition_update(
  resource: r4b.Researchelementdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Researchelementdefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.researchelementdefinition_to_json(resource),
    "ResearchElementDefinition",
    r4b.researchelementdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn researchelementdefinition_delete(
  resource: r4b.Researchelementdefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ResearchElementDefinition", client, handle_response)
}

pub fn researchelementdefinition_search_bundled(
  search_for search_args: r4b_sansio.SpResearchelementdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.researchelementdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn researchelementdefinition_search(
  search_for search_args: r4b_sansio.SpResearchelementdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Researchelementdefinition), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.researchelementdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.researchelementdefinition
    },
  )
}

pub fn researchstudy_create(
  resource: r4b.Researchstudy,
  client: FhirClient,
  handle_response: fn(Result(r4b.Researchstudy, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.researchstudy_to_json(resource),
    "ResearchStudy",
    r4b.researchstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn researchstudy_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Researchstudy, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ResearchStudy",
    r4b.researchstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn researchstudy_update(
  resource: r4b.Researchstudy,
  client: FhirClient,
  handle_response: fn(Result(r4b.Researchstudy, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.researchstudy_to_json(resource),
    "ResearchStudy",
    r4b.researchstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn researchstudy_delete(
  resource: r4b.Researchstudy,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ResearchStudy", client, handle_response)
}

pub fn researchstudy_search_bundled(
  search_for search_args: r4b_sansio.SpResearchstudy,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.researchstudy_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn researchstudy_search(
  search_for search_args: r4b_sansio.SpResearchstudy,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Researchstudy), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.researchstudy_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.researchstudy
    },
  )
}

pub fn researchsubject_create(
  resource: r4b.Researchsubject,
  client: FhirClient,
  handle_response: fn(Result(r4b.Researchsubject, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.researchsubject_to_json(resource),
    "ResearchSubject",
    r4b.researchsubject_decoder(),
    client,
    handle_response,
  )
}

pub fn researchsubject_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Researchsubject, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ResearchSubject",
    r4b.researchsubject_decoder(),
    client,
    handle_response,
  )
}

pub fn researchsubject_update(
  resource: r4b.Researchsubject,
  client: FhirClient,
  handle_response: fn(Result(r4b.Researchsubject, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.researchsubject_to_json(resource),
    "ResearchSubject",
    r4b.researchsubject_decoder(),
    client,
    handle_response,
  )
}

pub fn researchsubject_delete(
  resource: r4b.Researchsubject,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ResearchSubject", client, handle_response)
}

pub fn researchsubject_search_bundled(
  search_for search_args: r4b_sansio.SpResearchsubject,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.researchsubject_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn researchsubject_search(
  search_for search_args: r4b_sansio.SpResearchsubject,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Researchsubject), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.researchsubject_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.researchsubject
    },
  )
}

pub fn riskassessment_create(
  resource: r4b.Riskassessment,
  client: FhirClient,
  handle_response: fn(Result(r4b.Riskassessment, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.riskassessment_to_json(resource),
    "RiskAssessment",
    r4b.riskassessment_decoder(),
    client,
    handle_response,
  )
}

pub fn riskassessment_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Riskassessment, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "RiskAssessment",
    r4b.riskassessment_decoder(),
    client,
    handle_response,
  )
}

pub fn riskassessment_update(
  resource: r4b.Riskassessment,
  client: FhirClient,
  handle_response: fn(Result(r4b.Riskassessment, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.riskassessment_to_json(resource),
    "RiskAssessment",
    r4b.riskassessment_decoder(),
    client,
    handle_response,
  )
}

pub fn riskassessment_delete(
  resource: r4b.Riskassessment,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "RiskAssessment", client, handle_response)
}

pub fn riskassessment_search_bundled(
  search_for search_args: r4b_sansio.SpRiskassessment,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.riskassessment_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn riskassessment_search(
  search_for search_args: r4b_sansio.SpRiskassessment,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Riskassessment), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.riskassessment_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.riskassessment
    },
  )
}

pub fn schedule_create(
  resource: r4b.Schedule,
  client: FhirClient,
  handle_response: fn(Result(r4b.Schedule, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.schedule_to_json(resource),
    "Schedule",
    r4b.schedule_decoder(),
    client,
    handle_response,
  )
}

pub fn schedule_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Schedule, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Schedule", r4b.schedule_decoder(), client, handle_response)
}

pub fn schedule_update(
  resource: r4b.Schedule,
  client: FhirClient,
  handle_response: fn(Result(r4b.Schedule, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.schedule_to_json(resource),
    "Schedule",
    r4b.schedule_decoder(),
    client,
    handle_response,
  )
}

pub fn schedule_delete(
  resource: r4b.Schedule,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Schedule", client, handle_response)
}

pub fn schedule_search_bundled(
  search_for search_args: r4b_sansio.SpSchedule,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.schedule_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn schedule_search(
  search_for search_args: r4b_sansio.SpSchedule,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Schedule), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.schedule_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.schedule },
  )
}

pub fn searchparameter_create(
  resource: r4b.Searchparameter,
  client: FhirClient,
  handle_response: fn(Result(r4b.Searchparameter, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.searchparameter_to_json(resource),
    "SearchParameter",
    r4b.searchparameter_decoder(),
    client,
    handle_response,
  )
}

pub fn searchparameter_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Searchparameter, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SearchParameter",
    r4b.searchparameter_decoder(),
    client,
    handle_response,
  )
}

pub fn searchparameter_update(
  resource: r4b.Searchparameter,
  client: FhirClient,
  handle_response: fn(Result(r4b.Searchparameter, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.searchparameter_to_json(resource),
    "SearchParameter",
    r4b.searchparameter_decoder(),
    client,
    handle_response,
  )
}

pub fn searchparameter_delete(
  resource: r4b.Searchparameter,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SearchParameter", client, handle_response)
}

pub fn searchparameter_search_bundled(
  search_for search_args: r4b_sansio.SpSearchparameter,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.searchparameter_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn searchparameter_search(
  search_for search_args: r4b_sansio.SpSearchparameter,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Searchparameter), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.searchparameter_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.searchparameter
    },
  )
}

pub fn servicerequest_create(
  resource: r4b.Servicerequest,
  client: FhirClient,
  handle_response: fn(Result(r4b.Servicerequest, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.servicerequest_to_json(resource),
    "ServiceRequest",
    r4b.servicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn servicerequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Servicerequest, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ServiceRequest",
    r4b.servicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn servicerequest_update(
  resource: r4b.Servicerequest,
  client: FhirClient,
  handle_response: fn(Result(r4b.Servicerequest, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.servicerequest_to_json(resource),
    "ServiceRequest",
    r4b.servicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn servicerequest_delete(
  resource: r4b.Servicerequest,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ServiceRequest", client, handle_response)
}

pub fn servicerequest_search_bundled(
  search_for search_args: r4b_sansio.SpServicerequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.servicerequest_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn servicerequest_search(
  search_for search_args: r4b_sansio.SpServicerequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Servicerequest), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.servicerequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.servicerequest
    },
  )
}

pub fn slot_create(
  resource: r4b.Slot,
  client: FhirClient,
  handle_response: fn(Result(r4b.Slot, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.slot_to_json(resource),
    "Slot",
    r4b.slot_decoder(),
    client,
    handle_response,
  )
}

pub fn slot_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Slot, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Slot", r4b.slot_decoder(), client, handle_response)
}

pub fn slot_update(
  resource: r4b.Slot,
  client: FhirClient,
  handle_response: fn(Result(r4b.Slot, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.slot_to_json(resource),
    "Slot",
    r4b.slot_decoder(),
    client,
    handle_response,
  )
}

pub fn slot_delete(
  resource: r4b.Slot,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Slot", client, handle_response)
}

pub fn slot_search_bundled(
  search_for search_args: r4b_sansio.SpSlot,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.slot_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn slot_search(
  search_for search_args: r4b_sansio.SpSlot,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Slot), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.slot_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.slot },
  )
}

pub fn specimen_create(
  resource: r4b.Specimen,
  client: FhirClient,
  handle_response: fn(Result(r4b.Specimen, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.specimen_to_json(resource),
    "Specimen",
    r4b.specimen_decoder(),
    client,
    handle_response,
  )
}

pub fn specimen_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Specimen, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Specimen", r4b.specimen_decoder(), client, handle_response)
}

pub fn specimen_update(
  resource: r4b.Specimen,
  client: FhirClient,
  handle_response: fn(Result(r4b.Specimen, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.specimen_to_json(resource),
    "Specimen",
    r4b.specimen_decoder(),
    client,
    handle_response,
  )
}

pub fn specimen_delete(
  resource: r4b.Specimen,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Specimen", client, handle_response)
}

pub fn specimen_search_bundled(
  search_for search_args: r4b_sansio.SpSpecimen,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.specimen_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn specimen_search(
  search_for search_args: r4b_sansio.SpSpecimen,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Specimen), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.specimen_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.specimen },
  )
}

pub fn specimendefinition_create(
  resource: r4b.Specimendefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Specimendefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.specimendefinition_to_json(resource),
    "SpecimenDefinition",
    r4b.specimendefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn specimendefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Specimendefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SpecimenDefinition",
    r4b.specimendefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn specimendefinition_update(
  resource: r4b.Specimendefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Specimendefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.specimendefinition_to_json(resource),
    "SpecimenDefinition",
    r4b.specimendefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn specimendefinition_delete(
  resource: r4b.Specimendefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SpecimenDefinition", client, handle_response)
}

pub fn specimendefinition_search_bundled(
  search_for search_args: r4b_sansio.SpSpecimendefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.specimendefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn specimendefinition_search(
  search_for search_args: r4b_sansio.SpSpecimendefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Specimendefinition), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.specimendefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.specimendefinition
    },
  )
}

pub fn structuredefinition_create(
  resource: r4b.Structuredefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Structuredefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.structuredefinition_to_json(resource),
    "StructureDefinition",
    r4b.structuredefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn structuredefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Structuredefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "StructureDefinition",
    r4b.structuredefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn structuredefinition_update(
  resource: r4b.Structuredefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Structuredefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.structuredefinition_to_json(resource),
    "StructureDefinition",
    r4b.structuredefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn structuredefinition_delete(
  resource: r4b.Structuredefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "StructureDefinition", client, handle_response)
}

pub fn structuredefinition_search_bundled(
  search_for search_args: r4b_sansio.SpStructuredefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.structuredefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn structuredefinition_search(
  search_for search_args: r4b_sansio.SpStructuredefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Structuredefinition), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.structuredefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.structuredefinition
    },
  )
}

pub fn structuremap_create(
  resource: r4b.Structuremap,
  client: FhirClient,
  handle_response: fn(Result(r4b.Structuremap, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.structuremap_to_json(resource),
    "StructureMap",
    r4b.structuremap_decoder(),
    client,
    handle_response,
  )
}

pub fn structuremap_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Structuremap, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "StructureMap",
    r4b.structuremap_decoder(),
    client,
    handle_response,
  )
}

pub fn structuremap_update(
  resource: r4b.Structuremap,
  client: FhirClient,
  handle_response: fn(Result(r4b.Structuremap, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.structuremap_to_json(resource),
    "StructureMap",
    r4b.structuremap_decoder(),
    client,
    handle_response,
  )
}

pub fn structuremap_delete(
  resource: r4b.Structuremap,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "StructureMap", client, handle_response)
}

pub fn structuremap_search_bundled(
  search_for search_args: r4b_sansio.SpStructuremap,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.structuremap_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn structuremap_search(
  search_for search_args: r4b_sansio.SpStructuremap,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Structuremap), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.structuremap_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.structuremap
    },
  )
}

pub fn subscription_create(
  resource: r4b.Subscription,
  client: FhirClient,
  handle_response: fn(Result(r4b.Subscription, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.subscription_to_json(resource),
    "Subscription",
    r4b.subscription_decoder(),
    client,
    handle_response,
  )
}

pub fn subscription_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Subscription, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Subscription",
    r4b.subscription_decoder(),
    client,
    handle_response,
  )
}

pub fn subscription_update(
  resource: r4b.Subscription,
  client: FhirClient,
  handle_response: fn(Result(r4b.Subscription, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.subscription_to_json(resource),
    "Subscription",
    r4b.subscription_decoder(),
    client,
    handle_response,
  )
}

pub fn subscription_delete(
  resource: r4b.Subscription,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Subscription", client, handle_response)
}

pub fn subscription_search_bundled(
  search_for search_args: r4b_sansio.SpSubscription,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.subscription_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn subscription_search(
  search_for search_args: r4b_sansio.SpSubscription,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Subscription), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.subscription_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.subscription
    },
  )
}

pub fn subscriptionstatus_create(
  resource: r4b.Subscriptionstatus,
  client: FhirClient,
  handle_response: fn(Result(r4b.Subscriptionstatus, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.subscriptionstatus_to_json(resource),
    "SubscriptionStatus",
    r4b.subscriptionstatus_decoder(),
    client,
    handle_response,
  )
}

pub fn subscriptionstatus_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Subscriptionstatus, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubscriptionStatus",
    r4b.subscriptionstatus_decoder(),
    client,
    handle_response,
  )
}

pub fn subscriptionstatus_update(
  resource: r4b.Subscriptionstatus,
  client: FhirClient,
  handle_response: fn(Result(r4b.Subscriptionstatus, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.subscriptionstatus_to_json(resource),
    "SubscriptionStatus",
    r4b.subscriptionstatus_decoder(),
    client,
    handle_response,
  )
}

pub fn subscriptionstatus_delete(
  resource: r4b.Subscriptionstatus,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SubscriptionStatus", client, handle_response)
}

pub fn subscriptionstatus_search_bundled(
  search_for search_args: r4b_sansio.SpSubscriptionstatus,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.subscriptionstatus_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn subscriptionstatus_search(
  search_for search_args: r4b_sansio.SpSubscriptionstatus,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Subscriptionstatus), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.subscriptionstatus_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.subscriptionstatus
    },
  )
}

pub fn subscriptiontopic_create(
  resource: r4b.Subscriptiontopic,
  client: FhirClient,
  handle_response: fn(Result(r4b.Subscriptiontopic, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.subscriptiontopic_to_json(resource),
    "SubscriptionTopic",
    r4b.subscriptiontopic_decoder(),
    client,
    handle_response,
  )
}

pub fn subscriptiontopic_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Subscriptiontopic, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubscriptionTopic",
    r4b.subscriptiontopic_decoder(),
    client,
    handle_response,
  )
}

pub fn subscriptiontopic_update(
  resource: r4b.Subscriptiontopic,
  client: FhirClient,
  handle_response: fn(Result(r4b.Subscriptiontopic, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.subscriptiontopic_to_json(resource),
    "SubscriptionTopic",
    r4b.subscriptiontopic_decoder(),
    client,
    handle_response,
  )
}

pub fn subscriptiontopic_delete(
  resource: r4b.Subscriptiontopic,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SubscriptionTopic", client, handle_response)
}

pub fn subscriptiontopic_search_bundled(
  search_for search_args: r4b_sansio.SpSubscriptiontopic,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.subscriptiontopic_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn subscriptiontopic_search(
  search_for search_args: r4b_sansio.SpSubscriptiontopic,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Subscriptiontopic), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.subscriptiontopic_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.subscriptiontopic
    },
  )
}

pub fn substance_create(
  resource: r4b.Substance,
  client: FhirClient,
  handle_response: fn(Result(r4b.Substance, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.substance_to_json(resource),
    "Substance",
    r4b.substance_decoder(),
    client,
    handle_response,
  )
}

pub fn substance_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Substance, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Substance", r4b.substance_decoder(), client, handle_response)
}

pub fn substance_update(
  resource: r4b.Substance,
  client: FhirClient,
  handle_response: fn(Result(r4b.Substance, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.substance_to_json(resource),
    "Substance",
    r4b.substance_decoder(),
    client,
    handle_response,
  )
}

pub fn substance_delete(
  resource: r4b.Substance,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Substance", client, handle_response)
}

pub fn substance_search_bundled(
  search_for search_args: r4b_sansio.SpSubstance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.substance_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn substance_search(
  search_for search_args: r4b_sansio.SpSubstance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Substance), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.substance_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.substance },
  )
}

pub fn substancedefinition_create(
  resource: r4b.Substancedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Substancedefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.substancedefinition_to_json(resource),
    "SubstanceDefinition",
    r4b.substancedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn substancedefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Substancedefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstanceDefinition",
    r4b.substancedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn substancedefinition_update(
  resource: r4b.Substancedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Substancedefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.substancedefinition_to_json(resource),
    "SubstanceDefinition",
    r4b.substancedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn substancedefinition_delete(
  resource: r4b.Substancedefinition,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SubstanceDefinition", client, handle_response)
}

pub fn substancedefinition_search_bundled(
  search_for search_args: r4b_sansio.SpSubstancedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.substancedefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn substancedefinition_search(
  search_for search_args: r4b_sansio.SpSubstancedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Substancedefinition), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.substancedefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.substancedefinition
    },
  )
}

pub fn supplydelivery_create(
  resource: r4b.Supplydelivery,
  client: FhirClient,
  handle_response: fn(Result(r4b.Supplydelivery, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.supplydelivery_to_json(resource),
    "SupplyDelivery",
    r4b.supplydelivery_decoder(),
    client,
    handle_response,
  )
}

pub fn supplydelivery_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Supplydelivery, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SupplyDelivery",
    r4b.supplydelivery_decoder(),
    client,
    handle_response,
  )
}

pub fn supplydelivery_update(
  resource: r4b.Supplydelivery,
  client: FhirClient,
  handle_response: fn(Result(r4b.Supplydelivery, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.supplydelivery_to_json(resource),
    "SupplyDelivery",
    r4b.supplydelivery_decoder(),
    client,
    handle_response,
  )
}

pub fn supplydelivery_delete(
  resource: r4b.Supplydelivery,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SupplyDelivery", client, handle_response)
}

pub fn supplydelivery_search_bundled(
  search_for search_args: r4b_sansio.SpSupplydelivery,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.supplydelivery_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn supplydelivery_search(
  search_for search_args: r4b_sansio.SpSupplydelivery,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Supplydelivery), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.supplydelivery_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.supplydelivery
    },
  )
}

pub fn supplyrequest_create(
  resource: r4b.Supplyrequest,
  client: FhirClient,
  handle_response: fn(Result(r4b.Supplyrequest, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.supplyrequest_to_json(resource),
    "SupplyRequest",
    r4b.supplyrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn supplyrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Supplyrequest, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SupplyRequest",
    r4b.supplyrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn supplyrequest_update(
  resource: r4b.Supplyrequest,
  client: FhirClient,
  handle_response: fn(Result(r4b.Supplyrequest, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.supplyrequest_to_json(resource),
    "SupplyRequest",
    r4b.supplyrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn supplyrequest_delete(
  resource: r4b.Supplyrequest,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SupplyRequest", client, handle_response)
}

pub fn supplyrequest_search_bundled(
  search_for search_args: r4b_sansio.SpSupplyrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.supplyrequest_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn supplyrequest_search(
  search_for search_args: r4b_sansio.SpSupplyrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Supplyrequest), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.supplyrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.supplyrequest
    },
  )
}

pub fn task_create(
  resource: r4b.Task,
  client: FhirClient,
  handle_response: fn(Result(r4b.Task, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.task_to_json(resource),
    "Task",
    r4b.task_decoder(),
    client,
    handle_response,
  )
}

pub fn task_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Task, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Task", r4b.task_decoder(), client, handle_response)
}

pub fn task_update(
  resource: r4b.Task,
  client: FhirClient,
  handle_response: fn(Result(r4b.Task, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.task_to_json(resource),
    "Task",
    r4b.task_decoder(),
    client,
    handle_response,
  )
}

pub fn task_delete(
  resource: r4b.Task,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Task", client, handle_response)
}

pub fn task_search_bundled(
  search_for search_args: r4b_sansio.SpTask,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.task_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn task_search(
  search_for search_args: r4b_sansio.SpTask,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Task), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.task_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.task },
  )
}

pub fn terminologycapabilities_create(
  resource: r4b.Terminologycapabilities,
  client: FhirClient,
  handle_response: fn(Result(r4b.Terminologycapabilities, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.terminologycapabilities_to_json(resource),
    "TerminologyCapabilities",
    r4b.terminologycapabilities_decoder(),
    client,
    handle_response,
  )
}

pub fn terminologycapabilities_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Terminologycapabilities, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "TerminologyCapabilities",
    r4b.terminologycapabilities_decoder(),
    client,
    handle_response,
  )
}

pub fn terminologycapabilities_update(
  resource: r4b.Terminologycapabilities,
  client: FhirClient,
  handle_response: fn(Result(r4b.Terminologycapabilities, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.terminologycapabilities_to_json(resource),
    "TerminologyCapabilities",
    r4b.terminologycapabilities_decoder(),
    client,
    handle_response,
  )
}

pub fn terminologycapabilities_delete(
  resource: r4b.Terminologycapabilities,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "TerminologyCapabilities", client, handle_response)
}

pub fn terminologycapabilities_search_bundled(
  search_for search_args: r4b_sansio.SpTerminologycapabilities,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.terminologycapabilities_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn terminologycapabilities_search(
  search_for search_args: r4b_sansio.SpTerminologycapabilities,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r4b.Terminologycapabilities), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.terminologycapabilities_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.terminologycapabilities
    },
  )
}

pub fn testreport_create(
  resource: r4b.Testreport,
  client: FhirClient,
  handle_response: fn(Result(r4b.Testreport, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.testreport_to_json(resource),
    "TestReport",
    r4b.testreport_decoder(),
    client,
    handle_response,
  )
}

pub fn testreport_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Testreport, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "TestReport", r4b.testreport_decoder(), client, handle_response)
}

pub fn testreport_update(
  resource: r4b.Testreport,
  client: FhirClient,
  handle_response: fn(Result(r4b.Testreport, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.testreport_to_json(resource),
    "TestReport",
    r4b.testreport_decoder(),
    client,
    handle_response,
  )
}

pub fn testreport_delete(
  resource: r4b.Testreport,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "TestReport", client, handle_response)
}

pub fn testreport_search_bundled(
  search_for search_args: r4b_sansio.SpTestreport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.testreport_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn testreport_search(
  search_for search_args: r4b_sansio.SpTestreport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Testreport), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.testreport_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.testreport
    },
  )
}

pub fn testscript_create(
  resource: r4b.Testscript,
  client: FhirClient,
  handle_response: fn(Result(r4b.Testscript, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.testscript_to_json(resource),
    "TestScript",
    r4b.testscript_decoder(),
    client,
    handle_response,
  )
}

pub fn testscript_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Testscript, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "TestScript", r4b.testscript_decoder(), client, handle_response)
}

pub fn testscript_update(
  resource: r4b.Testscript,
  client: FhirClient,
  handle_response: fn(Result(r4b.Testscript, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.testscript_to_json(resource),
    "TestScript",
    r4b.testscript_decoder(),
    client,
    handle_response,
  )
}

pub fn testscript_delete(
  resource: r4b.Testscript,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "TestScript", client, handle_response)
}

pub fn testscript_search_bundled(
  search_for search_args: r4b_sansio.SpTestscript,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.testscript_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn testscript_search(
  search_for search_args: r4b_sansio.SpTestscript,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Testscript), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.testscript_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.testscript
    },
  )
}

pub fn valueset_create(
  resource: r4b.Valueset,
  client: FhirClient,
  handle_response: fn(Result(r4b.Valueset, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.valueset_to_json(resource),
    "ValueSet",
    r4b.valueset_decoder(),
    client,
    handle_response,
  )
}

pub fn valueset_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Valueset, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "ValueSet", r4b.valueset_decoder(), client, handle_response)
}

pub fn valueset_update(
  resource: r4b.Valueset,
  client: FhirClient,
  handle_response: fn(Result(r4b.Valueset, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.valueset_to_json(resource),
    "ValueSet",
    r4b.valueset_decoder(),
    client,
    handle_response,
  )
}

pub fn valueset_delete(
  resource: r4b.Valueset,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ValueSet", client, handle_response)
}

pub fn valueset_search_bundled(
  search_for search_args: r4b_sansio.SpValueset,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.valueset_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn valueset_search(
  search_for search_args: r4b_sansio.SpValueset,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Valueset), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.valueset_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4b_sansio.bundle_to_groupedresources }.valueset },
  )
}

pub fn verificationresult_create(
  resource: r4b.Verificationresult,
  client: FhirClient,
  handle_response: fn(Result(r4b.Verificationresult, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.verificationresult_to_json(resource),
    "VerificationResult",
    r4b.verificationresult_decoder(),
    client,
    handle_response,
  )
}

pub fn verificationresult_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Verificationresult, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "VerificationResult",
    r4b.verificationresult_decoder(),
    client,
    handle_response,
  )
}

pub fn verificationresult_update(
  resource: r4b.Verificationresult,
  client: FhirClient,
  handle_response: fn(Result(r4b.Verificationresult, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.verificationresult_to_json(resource),
    "VerificationResult",
    r4b.verificationresult_decoder(),
    client,
    handle_response,
  )
}

pub fn verificationresult_delete(
  resource: r4b.Verificationresult,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "VerificationResult", client, handle_response)
}

pub fn verificationresult_search_bundled(
  search_for search_args: r4b_sansio.SpVerificationresult,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.verificationresult_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn verificationresult_search(
  search_for search_args: r4b_sansio.SpVerificationresult,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Verificationresult), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.verificationresult_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.verificationresult
    },
  )
}

pub fn visionprescription_create(
  resource: r4b.Visionprescription,
  client: FhirClient,
  handle_response: fn(Result(r4b.Visionprescription, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r4b.visionprescription_to_json(resource),
    "VisionPrescription",
    r4b.visionprescription_decoder(),
    client,
    handle_response,
  )
}

pub fn visionprescription_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r4b.Visionprescription, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "VisionPrescription",
    r4b.visionprescription_decoder(),
    client,
    handle_response,
  )
}

pub fn visionprescription_update(
  resource: r4b.Visionprescription,
  client: FhirClient,
  handle_response: fn(Result(r4b.Visionprescription, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r4b.visionprescription_to_json(resource),
    "VisionPrescription",
    r4b.visionprescription_decoder(),
    client,
    handle_response,
  )
}

pub fn visionprescription_delete(
  resource: r4b.Visionprescription,
  client: FhirClient,
  handle_response: fn(Result(r4b.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "VisionPrescription", client, handle_response)
}

pub fn visionprescription_search_bundled(
  search_for search_args: r4b_sansio.SpVisionprescription,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4b.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4b_sansio.visionprescription_search_req(search_args, client)
  sendreq_handleresponse(req, r4b.bundle_decoder(), handle_response)
}

pub fn visionprescription_search(
  search_for search_args: r4b_sansio.SpVisionprescription,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4b.Visionprescription), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r4b_sansio.visionprescription_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4b.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r4b_sansio.bundle_to_groupedresources }.visionprescription
    },
  )
}
