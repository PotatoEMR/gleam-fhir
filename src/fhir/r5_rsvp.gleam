////[https://hl7.org/fhir/r5](https://hl7.org/fhir/r5) r5 client using rsvp

import fhir/r5
import fhir/r5_sansio
import gleam/dynamic/decode.{type Decoder}
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/json.{type Json}
import gleam/option.{type Option}
import lustre/effect.{type Effect}
import rsvp

pub type FhirClient =
  r5_sansio.FhirClient

pub fn fhirclient_new(baseurl: String) -> FhirClient {
  r5_sansio.fhirclient_new(baseurl)
}

pub type ReqErr {
  ReqErrRsvp(err: rsvp.Error)
  ReqErrSansio(err: r5_sansio.Err)
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
  let req = r5_sansio.any_create_req(resource, res_type, client)
  sendreq_handleresponse(req, resource_dec, handle_response)
}

fn any_read(
  id: String,
  res_type: String,
  resource_dec: Decoder(r),
  client: FhirClient,
  handle_response: fn(Result(r, ReqErr)) -> a,
) -> Effect(a) {
  let req = r5_sansio.any_read_req(id, res_type, client)
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
  let req = r5_sansio.any_update_req(id, resource, res_type, client)
  case req {
    Ok(req) -> Ok(sendreq_handleresponse(req, resource_dec, handle_response))
    Error(r5_sansio.ErrNoId) -> Error(ErrNoId)
    Error(_) ->
      panic as "should never get any errors besides NoId before making request"
  }
}

fn any_delete(
  id: Option(String),
  res_type: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  let req = r5_sansio.any_delete_req(id, res_type, client)
  case req {
    Ok(req) ->
      Ok(sendreq_handleresponse(
        req,
        r5.operationoutcome_decoder(),
        handle_response,
      ))
    Error(r5_sansio.ErrNoId) -> Error(ErrNoId)
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
        case r5_sansio.any_resp(resp_res, res_dec) {
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
  resource: r5.Account,
  client: FhirClient,
  handle_response: fn(Result(r5.Account, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.account_to_json(resource),
    "Account",
    r5.account_decoder(),
    client,
    handle_response,
  )
}

pub fn account_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Account, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Account", r5.account_decoder(), client, handle_response)
}

pub fn account_update(
  resource: r5.Account,
  client: FhirClient,
  handle_response: fn(Result(r5.Account, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.account_to_json(resource),
    "Account",
    r5.account_decoder(),
    client,
    handle_response,
  )
}

pub fn account_delete(
  resource: r5.Account,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Account", client, handle_response)
}

pub fn account_search_bundled(
  search_for search_args: r5_sansio.SpAccount,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.account_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn account_search(
  search_for search_args: r5_sansio.SpAccount,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Account), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.account_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.account },
  )
}

pub fn activitydefinition_create(
  resource: r5.Activitydefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Activitydefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.activitydefinition_to_json(resource),
    "ActivityDefinition",
    r5.activitydefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn activitydefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Activitydefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ActivityDefinition",
    r5.activitydefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn activitydefinition_update(
  resource: r5.Activitydefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Activitydefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.activitydefinition_to_json(resource),
    "ActivityDefinition",
    r5.activitydefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn activitydefinition_delete(
  resource: r5.Activitydefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ActivityDefinition", client, handle_response)
}

pub fn activitydefinition_search_bundled(
  search_for search_args: r5_sansio.SpActivitydefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.activitydefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn activitydefinition_search(
  search_for search_args: r5_sansio.SpActivitydefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Activitydefinition), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.activitydefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.activitydefinition
    },
  )
}

pub fn actordefinition_create(
  resource: r5.Actordefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Actordefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.actordefinition_to_json(resource),
    "ActorDefinition",
    r5.actordefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn actordefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Actordefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ActorDefinition",
    r5.actordefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn actordefinition_update(
  resource: r5.Actordefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Actordefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.actordefinition_to_json(resource),
    "ActorDefinition",
    r5.actordefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn actordefinition_delete(
  resource: r5.Actordefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ActorDefinition", client, handle_response)
}

pub fn actordefinition_search_bundled(
  search_for search_args: r5_sansio.SpActordefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.actordefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn actordefinition_search(
  search_for search_args: r5_sansio.SpActordefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Actordefinition), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.actordefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.actordefinition
    },
  )
}

pub fn administrableproductdefinition_create(
  resource: r5.Administrableproductdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Administrableproductdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.administrableproductdefinition_to_json(resource),
    "AdministrableProductDefinition",
    r5.administrableproductdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn administrableproductdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Administrableproductdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "AdministrableProductDefinition",
    r5.administrableproductdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn administrableproductdefinition_update(
  resource: r5.Administrableproductdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Administrableproductdefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.administrableproductdefinition_to_json(resource),
    "AdministrableProductDefinition",
    r5.administrableproductdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn administrableproductdefinition_delete(
  resource: r5.Administrableproductdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(
    resource.id,
    "AdministrableProductDefinition",
    client,
    handle_response,
  )
}

pub fn administrableproductdefinition_search_bundled(
  search_for search_args: r5_sansio.SpAdministrableproductdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req =
    r5_sansio.administrableproductdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn administrableproductdefinition_search(
  search_for search_args: r5_sansio.SpAdministrableproductdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r5.Administrableproductdefinition), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r5_sansio.administrableproductdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.administrableproductdefinition
    },
  )
}

pub fn adverseevent_create(
  resource: r5.Adverseevent,
  client: FhirClient,
  handle_response: fn(Result(r5.Adverseevent, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.adverseevent_to_json(resource),
    "AdverseEvent",
    r5.adverseevent_decoder(),
    client,
    handle_response,
  )
}

pub fn adverseevent_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Adverseevent, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "AdverseEvent",
    r5.adverseevent_decoder(),
    client,
    handle_response,
  )
}

pub fn adverseevent_update(
  resource: r5.Adverseevent,
  client: FhirClient,
  handle_response: fn(Result(r5.Adverseevent, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.adverseevent_to_json(resource),
    "AdverseEvent",
    r5.adverseevent_decoder(),
    client,
    handle_response,
  )
}

pub fn adverseevent_delete(
  resource: r5.Adverseevent,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "AdverseEvent", client, handle_response)
}

pub fn adverseevent_search_bundled(
  search_for search_args: r5_sansio.SpAdverseevent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.adverseevent_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn adverseevent_search(
  search_for search_args: r5_sansio.SpAdverseevent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Adverseevent), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.adverseevent_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.adverseevent
    },
  )
}

pub fn allergyintolerance_create(
  resource: r5.Allergyintolerance,
  client: FhirClient,
  handle_response: fn(Result(r5.Allergyintolerance, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    r5.allergyintolerance_decoder(),
    client,
    handle_response,
  )
}

pub fn allergyintolerance_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Allergyintolerance, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "AllergyIntolerance",
    r5.allergyintolerance_decoder(),
    client,
    handle_response,
  )
}

pub fn allergyintolerance_update(
  resource: r5.Allergyintolerance,
  client: FhirClient,
  handle_response: fn(Result(r5.Allergyintolerance, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    r5.allergyintolerance_decoder(),
    client,
    handle_response,
  )
}

pub fn allergyintolerance_delete(
  resource: r5.Allergyintolerance,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "AllergyIntolerance", client, handle_response)
}

pub fn allergyintolerance_search_bundled(
  search_for search_args: r5_sansio.SpAllergyintolerance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.allergyintolerance_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn allergyintolerance_search(
  search_for search_args: r5_sansio.SpAllergyintolerance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Allergyintolerance), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.allergyintolerance_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.allergyintolerance
    },
  )
}

pub fn appointment_create(
  resource: r5.Appointment,
  client: FhirClient,
  handle_response: fn(Result(r5.Appointment, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.appointment_to_json(resource),
    "Appointment",
    r5.appointment_decoder(),
    client,
    handle_response,
  )
}

pub fn appointment_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Appointment, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Appointment", r5.appointment_decoder(), client, handle_response)
}

pub fn appointment_update(
  resource: r5.Appointment,
  client: FhirClient,
  handle_response: fn(Result(r5.Appointment, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.appointment_to_json(resource),
    "Appointment",
    r5.appointment_decoder(),
    client,
    handle_response,
  )
}

pub fn appointment_delete(
  resource: r5.Appointment,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Appointment", client, handle_response)
}

pub fn appointment_search_bundled(
  search_for search_args: r5_sansio.SpAppointment,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.appointment_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn appointment_search(
  search_for search_args: r5_sansio.SpAppointment,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Appointment), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.appointment_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.appointment
    },
  )
}

pub fn appointmentresponse_create(
  resource: r5.Appointmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r5.Appointmentresponse, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.appointmentresponse_to_json(resource),
    "AppointmentResponse",
    r5.appointmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn appointmentresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Appointmentresponse, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "AppointmentResponse",
    r5.appointmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn appointmentresponse_update(
  resource: r5.Appointmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r5.Appointmentresponse, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.appointmentresponse_to_json(resource),
    "AppointmentResponse",
    r5.appointmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn appointmentresponse_delete(
  resource: r5.Appointmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "AppointmentResponse", client, handle_response)
}

pub fn appointmentresponse_search_bundled(
  search_for search_args: r5_sansio.SpAppointmentresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.appointmentresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn appointmentresponse_search(
  search_for search_args: r5_sansio.SpAppointmentresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Appointmentresponse), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.appointmentresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.appointmentresponse
    },
  )
}

pub fn artifactassessment_create(
  resource: r5.Artifactassessment,
  client: FhirClient,
  handle_response: fn(Result(r5.Artifactassessment, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.artifactassessment_to_json(resource),
    "ArtifactAssessment",
    r5.artifactassessment_decoder(),
    client,
    handle_response,
  )
}

pub fn artifactassessment_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Artifactassessment, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ArtifactAssessment",
    r5.artifactassessment_decoder(),
    client,
    handle_response,
  )
}

pub fn artifactassessment_update(
  resource: r5.Artifactassessment,
  client: FhirClient,
  handle_response: fn(Result(r5.Artifactassessment, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.artifactassessment_to_json(resource),
    "ArtifactAssessment",
    r5.artifactassessment_decoder(),
    client,
    handle_response,
  )
}

pub fn artifactassessment_delete(
  resource: r5.Artifactassessment,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ArtifactAssessment", client, handle_response)
}

pub fn artifactassessment_search_bundled(
  search_for search_args: r5_sansio.SpArtifactassessment,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.artifactassessment_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn artifactassessment_search(
  search_for search_args: r5_sansio.SpArtifactassessment,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Artifactassessment), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.artifactassessment_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.artifactassessment
    },
  )
}

pub fn auditevent_create(
  resource: r5.Auditevent,
  client: FhirClient,
  handle_response: fn(Result(r5.Auditevent, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.auditevent_to_json(resource),
    "AuditEvent",
    r5.auditevent_decoder(),
    client,
    handle_response,
  )
}

pub fn auditevent_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Auditevent, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "AuditEvent", r5.auditevent_decoder(), client, handle_response)
}

pub fn auditevent_update(
  resource: r5.Auditevent,
  client: FhirClient,
  handle_response: fn(Result(r5.Auditevent, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.auditevent_to_json(resource),
    "AuditEvent",
    r5.auditevent_decoder(),
    client,
    handle_response,
  )
}

pub fn auditevent_delete(
  resource: r5.Auditevent,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "AuditEvent", client, handle_response)
}

pub fn auditevent_search_bundled(
  search_for search_args: r5_sansio.SpAuditevent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.auditevent_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn auditevent_search(
  search_for search_args: r5_sansio.SpAuditevent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Auditevent), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.auditevent_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.auditevent },
  )
}

pub fn basic_create(
  resource: r5.Basic,
  client: FhirClient,
  handle_response: fn(Result(r5.Basic, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.basic_to_json(resource),
    "Basic",
    r5.basic_decoder(),
    client,
    handle_response,
  )
}

pub fn basic_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Basic, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Basic", r5.basic_decoder(), client, handle_response)
}

pub fn basic_update(
  resource: r5.Basic,
  client: FhirClient,
  handle_response: fn(Result(r5.Basic, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.basic_to_json(resource),
    "Basic",
    r5.basic_decoder(),
    client,
    handle_response,
  )
}

pub fn basic_delete(
  resource: r5.Basic,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Basic", client, handle_response)
}

pub fn basic_search_bundled(
  search_for search_args: r5_sansio.SpBasic,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.basic_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn basic_search(
  search_for search_args: r5_sansio.SpBasic,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Basic), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.basic_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.basic },
  )
}

pub fn binary_create(
  resource: r5.Binary,
  client: FhirClient,
  handle_response: fn(Result(r5.Binary, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.binary_to_json(resource),
    "Binary",
    r5.binary_decoder(),
    client,
    handle_response,
  )
}

pub fn binary_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Binary, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Binary", r5.binary_decoder(), client, handle_response)
}

pub fn binary_update(
  resource: r5.Binary,
  client: FhirClient,
  handle_response: fn(Result(r5.Binary, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.binary_to_json(resource),
    "Binary",
    r5.binary_decoder(),
    client,
    handle_response,
  )
}

pub fn binary_delete(
  resource: r5.Binary,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Binary", client, handle_response)
}

pub fn binary_search_bundled(
  search_for search_args: r5_sansio.SpBinary,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.binary_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn binary_search(
  search_for search_args: r5_sansio.SpBinary,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Binary), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.binary_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.binary },
  )
}

pub fn biologicallyderivedproduct_create(
  resource: r5.Biologicallyderivedproduct,
  client: FhirClient,
  handle_response: fn(Result(r5.Biologicallyderivedproduct, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.biologicallyderivedproduct_to_json(resource),
    "BiologicallyDerivedProduct",
    r5.biologicallyderivedproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn biologicallyderivedproduct_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Biologicallyderivedproduct, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "BiologicallyDerivedProduct",
    r5.biologicallyderivedproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn biologicallyderivedproduct_update(
  resource: r5.Biologicallyderivedproduct,
  client: FhirClient,
  handle_response: fn(Result(r5.Biologicallyderivedproduct, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.biologicallyderivedproduct_to_json(resource),
    "BiologicallyDerivedProduct",
    r5.biologicallyderivedproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn biologicallyderivedproduct_delete(
  resource: r5.Biologicallyderivedproduct,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "BiologicallyDerivedProduct", client, handle_response)
}

pub fn biologicallyderivedproduct_search_bundled(
  search_for search_args: r5_sansio.SpBiologicallyderivedproduct,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.biologicallyderivedproduct_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn biologicallyderivedproduct_search(
  search_for search_args: r5_sansio.SpBiologicallyderivedproduct,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r5.Biologicallyderivedproduct), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.biologicallyderivedproduct_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.biologicallyderivedproduct
    },
  )
}

pub fn biologicallyderivedproductdispense_create(
  resource: r5.Biologicallyderivedproductdispense,
  client: FhirClient,
  handle_response: fn(Result(r5.Biologicallyderivedproductdispense, ReqErr)) ->
    a,
) -> Effect(a) {
  any_create(
    r5.biologicallyderivedproductdispense_to_json(resource),
    "BiologicallyDerivedProductDispense",
    r5.biologicallyderivedproductdispense_decoder(),
    client,
    handle_response,
  )
}

pub fn biologicallyderivedproductdispense_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Biologicallyderivedproductdispense, ReqErr)) ->
    a,
) -> Effect(a) {
  any_read(
    id,
    "BiologicallyDerivedProductDispense",
    r5.biologicallyderivedproductdispense_decoder(),
    client,
    handle_response,
  )
}

pub fn biologicallyderivedproductdispense_update(
  resource: r5.Biologicallyderivedproductdispense,
  client: FhirClient,
  handle_response: fn(Result(r5.Biologicallyderivedproductdispense, ReqErr)) ->
    a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.biologicallyderivedproductdispense_to_json(resource),
    "BiologicallyDerivedProductDispense",
    r5.biologicallyderivedproductdispense_decoder(),
    client,
    handle_response,
  )
}

pub fn biologicallyderivedproductdispense_delete(
  resource: r5.Biologicallyderivedproductdispense,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(
    resource.id,
    "BiologicallyDerivedProductDispense",
    client,
    handle_response,
  )
}

pub fn biologicallyderivedproductdispense_search_bundled(
  search_for search_args: r5_sansio.SpBiologicallyderivedproductdispense,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req =
    r5_sansio.biologicallyderivedproductdispense_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn biologicallyderivedproductdispense_search(
  search_for search_args: r5_sansio.SpBiologicallyderivedproductdispense,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r5.Biologicallyderivedproductdispense), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r5_sansio.biologicallyderivedproductdispense_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.biologicallyderivedproductdispense
    },
  )
}

pub fn bodystructure_create(
  resource: r5.Bodystructure,
  client: FhirClient,
  handle_response: fn(Result(r5.Bodystructure, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.bodystructure_to_json(resource),
    "BodyStructure",
    r5.bodystructure_decoder(),
    client,
    handle_response,
  )
}

pub fn bodystructure_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Bodystructure, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "BodyStructure",
    r5.bodystructure_decoder(),
    client,
    handle_response,
  )
}

pub fn bodystructure_update(
  resource: r5.Bodystructure,
  client: FhirClient,
  handle_response: fn(Result(r5.Bodystructure, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.bodystructure_to_json(resource),
    "BodyStructure",
    r5.bodystructure_decoder(),
    client,
    handle_response,
  )
}

pub fn bodystructure_delete(
  resource: r5.Bodystructure,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "BodyStructure", client, handle_response)
}

pub fn bodystructure_search_bundled(
  search_for search_args: r5_sansio.SpBodystructure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.bodystructure_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn bodystructure_search(
  search_for search_args: r5_sansio.SpBodystructure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Bodystructure), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.bodystructure_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.bodystructure
    },
  )
}

pub fn bundle_create(
  resource: r5.Bundle,
  client: FhirClient,
  handle_response: fn(Result(r5.Bundle, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.bundle_to_json(resource),
    "Bundle",
    r5.bundle_decoder(),
    client,
    handle_response,
  )
}

pub fn bundle_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Bundle, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Bundle", r5.bundle_decoder(), client, handle_response)
}

pub fn bundle_update(
  resource: r5.Bundle,
  client: FhirClient,
  handle_response: fn(Result(r5.Bundle, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.bundle_to_json(resource),
    "Bundle",
    r5.bundle_decoder(),
    client,
    handle_response,
  )
}

pub fn bundle_delete(
  resource: r5.Bundle,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Bundle", client, handle_response)
}

pub fn bundle_search_bundled(
  search_for search_args: r5_sansio.SpBundle,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.bundle_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn bundle_search(
  search_for search_args: r5_sansio.SpBundle,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Bundle), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.bundle_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.bundle },
  )
}

pub fn capabilitystatement_create(
  resource: r5.Capabilitystatement,
  client: FhirClient,
  handle_response: fn(Result(r5.Capabilitystatement, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.capabilitystatement_to_json(resource),
    "CapabilityStatement",
    r5.capabilitystatement_decoder(),
    client,
    handle_response,
  )
}

pub fn capabilitystatement_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Capabilitystatement, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CapabilityStatement",
    r5.capabilitystatement_decoder(),
    client,
    handle_response,
  )
}

pub fn capabilitystatement_update(
  resource: r5.Capabilitystatement,
  client: FhirClient,
  handle_response: fn(Result(r5.Capabilitystatement, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.capabilitystatement_to_json(resource),
    "CapabilityStatement",
    r5.capabilitystatement_decoder(),
    client,
    handle_response,
  )
}

pub fn capabilitystatement_delete(
  resource: r5.Capabilitystatement,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CapabilityStatement", client, handle_response)
}

pub fn capabilitystatement_search_bundled(
  search_for search_args: r5_sansio.SpCapabilitystatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.capabilitystatement_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn capabilitystatement_search(
  search_for search_args: r5_sansio.SpCapabilitystatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Capabilitystatement), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.capabilitystatement_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.capabilitystatement
    },
  )
}

pub fn careplan_create(
  resource: r5.Careplan,
  client: FhirClient,
  handle_response: fn(Result(r5.Careplan, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.careplan_to_json(resource),
    "CarePlan",
    r5.careplan_decoder(),
    client,
    handle_response,
  )
}

pub fn careplan_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Careplan, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "CarePlan", r5.careplan_decoder(), client, handle_response)
}

pub fn careplan_update(
  resource: r5.Careplan,
  client: FhirClient,
  handle_response: fn(Result(r5.Careplan, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.careplan_to_json(resource),
    "CarePlan",
    r5.careplan_decoder(),
    client,
    handle_response,
  )
}

pub fn careplan_delete(
  resource: r5.Careplan,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CarePlan", client, handle_response)
}

pub fn careplan_search_bundled(
  search_for search_args: r5_sansio.SpCareplan,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.careplan_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn careplan_search(
  search_for search_args: r5_sansio.SpCareplan,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Careplan), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.careplan_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.careplan },
  )
}

pub fn careteam_create(
  resource: r5.Careteam,
  client: FhirClient,
  handle_response: fn(Result(r5.Careteam, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.careteam_to_json(resource),
    "CareTeam",
    r5.careteam_decoder(),
    client,
    handle_response,
  )
}

pub fn careteam_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Careteam, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "CareTeam", r5.careteam_decoder(), client, handle_response)
}

pub fn careteam_update(
  resource: r5.Careteam,
  client: FhirClient,
  handle_response: fn(Result(r5.Careteam, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.careteam_to_json(resource),
    "CareTeam",
    r5.careteam_decoder(),
    client,
    handle_response,
  )
}

pub fn careteam_delete(
  resource: r5.Careteam,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CareTeam", client, handle_response)
}

pub fn careteam_search_bundled(
  search_for search_args: r5_sansio.SpCareteam,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.careteam_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn careteam_search(
  search_for search_args: r5_sansio.SpCareteam,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Careteam), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.careteam_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.careteam },
  )
}

pub fn chargeitem_create(
  resource: r5.Chargeitem,
  client: FhirClient,
  handle_response: fn(Result(r5.Chargeitem, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.chargeitem_to_json(resource),
    "ChargeItem",
    r5.chargeitem_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitem_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Chargeitem, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "ChargeItem", r5.chargeitem_decoder(), client, handle_response)
}

pub fn chargeitem_update(
  resource: r5.Chargeitem,
  client: FhirClient,
  handle_response: fn(Result(r5.Chargeitem, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.chargeitem_to_json(resource),
    "ChargeItem",
    r5.chargeitem_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitem_delete(
  resource: r5.Chargeitem,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ChargeItem", client, handle_response)
}

pub fn chargeitem_search_bundled(
  search_for search_args: r5_sansio.SpChargeitem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.chargeitem_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn chargeitem_search(
  search_for search_args: r5_sansio.SpChargeitem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Chargeitem), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.chargeitem_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.chargeitem },
  )
}

pub fn chargeitemdefinition_create(
  resource: r5.Chargeitemdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Chargeitemdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.chargeitemdefinition_to_json(resource),
    "ChargeItemDefinition",
    r5.chargeitemdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitemdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Chargeitemdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ChargeItemDefinition",
    r5.chargeitemdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitemdefinition_update(
  resource: r5.Chargeitemdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Chargeitemdefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.chargeitemdefinition_to_json(resource),
    "ChargeItemDefinition",
    r5.chargeitemdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn chargeitemdefinition_delete(
  resource: r5.Chargeitemdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ChargeItemDefinition", client, handle_response)
}

pub fn chargeitemdefinition_search_bundled(
  search_for search_args: r5_sansio.SpChargeitemdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.chargeitemdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn chargeitemdefinition_search(
  search_for search_args: r5_sansio.SpChargeitemdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r5.Chargeitemdefinition), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.chargeitemdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.chargeitemdefinition
    },
  )
}

pub fn citation_create(
  resource: r5.Citation,
  client: FhirClient,
  handle_response: fn(Result(r5.Citation, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.citation_to_json(resource),
    "Citation",
    r5.citation_decoder(),
    client,
    handle_response,
  )
}

pub fn citation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Citation, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Citation", r5.citation_decoder(), client, handle_response)
}

pub fn citation_update(
  resource: r5.Citation,
  client: FhirClient,
  handle_response: fn(Result(r5.Citation, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.citation_to_json(resource),
    "Citation",
    r5.citation_decoder(),
    client,
    handle_response,
  )
}

pub fn citation_delete(
  resource: r5.Citation,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Citation", client, handle_response)
}

pub fn citation_search_bundled(
  search_for search_args: r5_sansio.SpCitation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.citation_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn citation_search(
  search_for search_args: r5_sansio.SpCitation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Citation), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.citation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.citation },
  )
}

pub fn claim_create(
  resource: r5.Claim,
  client: FhirClient,
  handle_response: fn(Result(r5.Claim, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.claim_to_json(resource),
    "Claim",
    r5.claim_decoder(),
    client,
    handle_response,
  )
}

pub fn claim_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Claim, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Claim", r5.claim_decoder(), client, handle_response)
}

pub fn claim_update(
  resource: r5.Claim,
  client: FhirClient,
  handle_response: fn(Result(r5.Claim, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.claim_to_json(resource),
    "Claim",
    r5.claim_decoder(),
    client,
    handle_response,
  )
}

pub fn claim_delete(
  resource: r5.Claim,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Claim", client, handle_response)
}

pub fn claim_search_bundled(
  search_for search_args: r5_sansio.SpClaim,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.claim_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn claim_search(
  search_for search_args: r5_sansio.SpClaim,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Claim), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.claim_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.claim },
  )
}

pub fn claimresponse_create(
  resource: r5.Claimresponse,
  client: FhirClient,
  handle_response: fn(Result(r5.Claimresponse, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.claimresponse_to_json(resource),
    "ClaimResponse",
    r5.claimresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn claimresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Claimresponse, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ClaimResponse",
    r5.claimresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn claimresponse_update(
  resource: r5.Claimresponse,
  client: FhirClient,
  handle_response: fn(Result(r5.Claimresponse, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.claimresponse_to_json(resource),
    "ClaimResponse",
    r5.claimresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn claimresponse_delete(
  resource: r5.Claimresponse,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ClaimResponse", client, handle_response)
}

pub fn claimresponse_search_bundled(
  search_for search_args: r5_sansio.SpClaimresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.claimresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn claimresponse_search(
  search_for search_args: r5_sansio.SpClaimresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Claimresponse), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.claimresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.claimresponse
    },
  )
}

pub fn clinicalimpression_create(
  resource: r5.Clinicalimpression,
  client: FhirClient,
  handle_response: fn(Result(r5.Clinicalimpression, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.clinicalimpression_to_json(resource),
    "ClinicalImpression",
    r5.clinicalimpression_decoder(),
    client,
    handle_response,
  )
}

pub fn clinicalimpression_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Clinicalimpression, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ClinicalImpression",
    r5.clinicalimpression_decoder(),
    client,
    handle_response,
  )
}

pub fn clinicalimpression_update(
  resource: r5.Clinicalimpression,
  client: FhirClient,
  handle_response: fn(Result(r5.Clinicalimpression, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.clinicalimpression_to_json(resource),
    "ClinicalImpression",
    r5.clinicalimpression_decoder(),
    client,
    handle_response,
  )
}

pub fn clinicalimpression_delete(
  resource: r5.Clinicalimpression,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ClinicalImpression", client, handle_response)
}

pub fn clinicalimpression_search_bundled(
  search_for search_args: r5_sansio.SpClinicalimpression,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.clinicalimpression_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn clinicalimpression_search(
  search_for search_args: r5_sansio.SpClinicalimpression,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Clinicalimpression), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.clinicalimpression_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.clinicalimpression
    },
  )
}

pub fn clinicalusedefinition_create(
  resource: r5.Clinicalusedefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Clinicalusedefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.clinicalusedefinition_to_json(resource),
    "ClinicalUseDefinition",
    r5.clinicalusedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn clinicalusedefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Clinicalusedefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ClinicalUseDefinition",
    r5.clinicalusedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn clinicalusedefinition_update(
  resource: r5.Clinicalusedefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Clinicalusedefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.clinicalusedefinition_to_json(resource),
    "ClinicalUseDefinition",
    r5.clinicalusedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn clinicalusedefinition_delete(
  resource: r5.Clinicalusedefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ClinicalUseDefinition", client, handle_response)
}

pub fn clinicalusedefinition_search_bundled(
  search_for search_args: r5_sansio.SpClinicalusedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.clinicalusedefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn clinicalusedefinition_search(
  search_for search_args: r5_sansio.SpClinicalusedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r5.Clinicalusedefinition), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.clinicalusedefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.clinicalusedefinition
    },
  )
}

pub fn codesystem_create(
  resource: r5.Codesystem,
  client: FhirClient,
  handle_response: fn(Result(r5.Codesystem, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.codesystem_to_json(resource),
    "CodeSystem",
    r5.codesystem_decoder(),
    client,
    handle_response,
  )
}

pub fn codesystem_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Codesystem, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "CodeSystem", r5.codesystem_decoder(), client, handle_response)
}

pub fn codesystem_update(
  resource: r5.Codesystem,
  client: FhirClient,
  handle_response: fn(Result(r5.Codesystem, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.codesystem_to_json(resource),
    "CodeSystem",
    r5.codesystem_decoder(),
    client,
    handle_response,
  )
}

pub fn codesystem_delete(
  resource: r5.Codesystem,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CodeSystem", client, handle_response)
}

pub fn codesystem_search_bundled(
  search_for search_args: r5_sansio.SpCodesystem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.codesystem_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn codesystem_search(
  search_for search_args: r5_sansio.SpCodesystem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Codesystem), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.codesystem_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.codesystem },
  )
}

pub fn communication_create(
  resource: r5.Communication,
  client: FhirClient,
  handle_response: fn(Result(r5.Communication, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.communication_to_json(resource),
    "Communication",
    r5.communication_decoder(),
    client,
    handle_response,
  )
}

pub fn communication_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Communication, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Communication",
    r5.communication_decoder(),
    client,
    handle_response,
  )
}

pub fn communication_update(
  resource: r5.Communication,
  client: FhirClient,
  handle_response: fn(Result(r5.Communication, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.communication_to_json(resource),
    "Communication",
    r5.communication_decoder(),
    client,
    handle_response,
  )
}

pub fn communication_delete(
  resource: r5.Communication,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Communication", client, handle_response)
}

pub fn communication_search_bundled(
  search_for search_args: r5_sansio.SpCommunication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.communication_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn communication_search(
  search_for search_args: r5_sansio.SpCommunication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Communication), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.communication_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.communication
    },
  )
}

pub fn communicationrequest_create(
  resource: r5.Communicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r5.Communicationrequest, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.communicationrequest_to_json(resource),
    "CommunicationRequest",
    r5.communicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn communicationrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Communicationrequest, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CommunicationRequest",
    r5.communicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn communicationrequest_update(
  resource: r5.Communicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r5.Communicationrequest, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.communicationrequest_to_json(resource),
    "CommunicationRequest",
    r5.communicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn communicationrequest_delete(
  resource: r5.Communicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CommunicationRequest", client, handle_response)
}

pub fn communicationrequest_search_bundled(
  search_for search_args: r5_sansio.SpCommunicationrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.communicationrequest_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn communicationrequest_search(
  search_for search_args: r5_sansio.SpCommunicationrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r5.Communicationrequest), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.communicationrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.communicationrequest
    },
  )
}

pub fn compartmentdefinition_create(
  resource: r5.Compartmentdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Compartmentdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.compartmentdefinition_to_json(resource),
    "CompartmentDefinition",
    r5.compartmentdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn compartmentdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Compartmentdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CompartmentDefinition",
    r5.compartmentdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn compartmentdefinition_update(
  resource: r5.Compartmentdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Compartmentdefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.compartmentdefinition_to_json(resource),
    "CompartmentDefinition",
    r5.compartmentdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn compartmentdefinition_delete(
  resource: r5.Compartmentdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CompartmentDefinition", client, handle_response)
}

pub fn compartmentdefinition_search_bundled(
  search_for search_args: r5_sansio.SpCompartmentdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.compartmentdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn compartmentdefinition_search(
  search_for search_args: r5_sansio.SpCompartmentdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r5.Compartmentdefinition), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.compartmentdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.compartmentdefinition
    },
  )
}

pub fn composition_create(
  resource: r5.Composition,
  client: FhirClient,
  handle_response: fn(Result(r5.Composition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.composition_to_json(resource),
    "Composition",
    r5.composition_decoder(),
    client,
    handle_response,
  )
}

pub fn composition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Composition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Composition", r5.composition_decoder(), client, handle_response)
}

pub fn composition_update(
  resource: r5.Composition,
  client: FhirClient,
  handle_response: fn(Result(r5.Composition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.composition_to_json(resource),
    "Composition",
    r5.composition_decoder(),
    client,
    handle_response,
  )
}

pub fn composition_delete(
  resource: r5.Composition,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Composition", client, handle_response)
}

pub fn composition_search_bundled(
  search_for search_args: r5_sansio.SpComposition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.composition_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn composition_search(
  search_for search_args: r5_sansio.SpComposition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Composition), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.composition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.composition
    },
  )
}

pub fn conceptmap_create(
  resource: r5.Conceptmap,
  client: FhirClient,
  handle_response: fn(Result(r5.Conceptmap, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.conceptmap_to_json(resource),
    "ConceptMap",
    r5.conceptmap_decoder(),
    client,
    handle_response,
  )
}

pub fn conceptmap_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Conceptmap, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "ConceptMap", r5.conceptmap_decoder(), client, handle_response)
}

pub fn conceptmap_update(
  resource: r5.Conceptmap,
  client: FhirClient,
  handle_response: fn(Result(r5.Conceptmap, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.conceptmap_to_json(resource),
    "ConceptMap",
    r5.conceptmap_decoder(),
    client,
    handle_response,
  )
}

pub fn conceptmap_delete(
  resource: r5.Conceptmap,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ConceptMap", client, handle_response)
}

pub fn conceptmap_search_bundled(
  search_for search_args: r5_sansio.SpConceptmap,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.conceptmap_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn conceptmap_search(
  search_for search_args: r5_sansio.SpConceptmap,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Conceptmap), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.conceptmap_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.conceptmap },
  )
}

pub fn condition_create(
  resource: r5.Condition,
  client: FhirClient,
  handle_response: fn(Result(r5.Condition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.condition_to_json(resource),
    "Condition",
    r5.condition_decoder(),
    client,
    handle_response,
  )
}

pub fn condition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Condition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Condition", r5.condition_decoder(), client, handle_response)
}

pub fn condition_update(
  resource: r5.Condition,
  client: FhirClient,
  handle_response: fn(Result(r5.Condition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.condition_to_json(resource),
    "Condition",
    r5.condition_decoder(),
    client,
    handle_response,
  )
}

pub fn condition_delete(
  resource: r5.Condition,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Condition", client, handle_response)
}

pub fn condition_search_bundled(
  search_for search_args: r5_sansio.SpCondition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.condition_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn condition_search(
  search_for search_args: r5_sansio.SpCondition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Condition), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.condition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.condition },
  )
}

pub fn conditiondefinition_create(
  resource: r5.Conditiondefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Conditiondefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.conditiondefinition_to_json(resource),
    "ConditionDefinition",
    r5.conditiondefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn conditiondefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Conditiondefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ConditionDefinition",
    r5.conditiondefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn conditiondefinition_update(
  resource: r5.Conditiondefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Conditiondefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.conditiondefinition_to_json(resource),
    "ConditionDefinition",
    r5.conditiondefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn conditiondefinition_delete(
  resource: r5.Conditiondefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ConditionDefinition", client, handle_response)
}

pub fn conditiondefinition_search_bundled(
  search_for search_args: r5_sansio.SpConditiondefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.conditiondefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn conditiondefinition_search(
  search_for search_args: r5_sansio.SpConditiondefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Conditiondefinition), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.conditiondefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.conditiondefinition
    },
  )
}

pub fn consent_create(
  resource: r5.Consent,
  client: FhirClient,
  handle_response: fn(Result(r5.Consent, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.consent_to_json(resource),
    "Consent",
    r5.consent_decoder(),
    client,
    handle_response,
  )
}

pub fn consent_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Consent, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Consent", r5.consent_decoder(), client, handle_response)
}

pub fn consent_update(
  resource: r5.Consent,
  client: FhirClient,
  handle_response: fn(Result(r5.Consent, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.consent_to_json(resource),
    "Consent",
    r5.consent_decoder(),
    client,
    handle_response,
  )
}

pub fn consent_delete(
  resource: r5.Consent,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Consent", client, handle_response)
}

pub fn consent_search_bundled(
  search_for search_args: r5_sansio.SpConsent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.consent_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn consent_search(
  search_for search_args: r5_sansio.SpConsent,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Consent), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.consent_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.consent },
  )
}

pub fn contract_create(
  resource: r5.Contract,
  client: FhirClient,
  handle_response: fn(Result(r5.Contract, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.contract_to_json(resource),
    "Contract",
    r5.contract_decoder(),
    client,
    handle_response,
  )
}

pub fn contract_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Contract, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Contract", r5.contract_decoder(), client, handle_response)
}

pub fn contract_update(
  resource: r5.Contract,
  client: FhirClient,
  handle_response: fn(Result(r5.Contract, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.contract_to_json(resource),
    "Contract",
    r5.contract_decoder(),
    client,
    handle_response,
  )
}

pub fn contract_delete(
  resource: r5.Contract,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Contract", client, handle_response)
}

pub fn contract_search_bundled(
  search_for search_args: r5_sansio.SpContract,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.contract_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn contract_search(
  search_for search_args: r5_sansio.SpContract,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Contract), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.contract_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.contract },
  )
}

pub fn coverage_create(
  resource: r5.Coverage,
  client: FhirClient,
  handle_response: fn(Result(r5.Coverage, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.coverage_to_json(resource),
    "Coverage",
    r5.coverage_decoder(),
    client,
    handle_response,
  )
}

pub fn coverage_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Coverage, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Coverage", r5.coverage_decoder(), client, handle_response)
}

pub fn coverage_update(
  resource: r5.Coverage,
  client: FhirClient,
  handle_response: fn(Result(r5.Coverage, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.coverage_to_json(resource),
    "Coverage",
    r5.coverage_decoder(),
    client,
    handle_response,
  )
}

pub fn coverage_delete(
  resource: r5.Coverage,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Coverage", client, handle_response)
}

pub fn coverage_search_bundled(
  search_for search_args: r5_sansio.SpCoverage,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.coverage_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn coverage_search(
  search_for search_args: r5_sansio.SpCoverage,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Coverage), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.coverage_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.coverage },
  )
}

pub fn coverageeligibilityrequest_create(
  resource: r5.Coverageeligibilityrequest,
  client: FhirClient,
  handle_response: fn(Result(r5.Coverageeligibilityrequest, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.coverageeligibilityrequest_to_json(resource),
    "CoverageEligibilityRequest",
    r5.coverageeligibilityrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Coverageeligibilityrequest, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CoverageEligibilityRequest",
    r5.coverageeligibilityrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityrequest_update(
  resource: r5.Coverageeligibilityrequest,
  client: FhirClient,
  handle_response: fn(Result(r5.Coverageeligibilityrequest, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.coverageeligibilityrequest_to_json(resource),
    "CoverageEligibilityRequest",
    r5.coverageeligibilityrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityrequest_delete(
  resource: r5.Coverageeligibilityrequest,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "CoverageEligibilityRequest", client, handle_response)
}

pub fn coverageeligibilityrequest_search_bundled(
  search_for search_args: r5_sansio.SpCoverageeligibilityrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.coverageeligibilityrequest_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn coverageeligibilityrequest_search(
  search_for search_args: r5_sansio.SpCoverageeligibilityrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r5.Coverageeligibilityrequest), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.coverageeligibilityrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.coverageeligibilityrequest
    },
  )
}

pub fn coverageeligibilityresponse_create(
  resource: r5.Coverageeligibilityresponse,
  client: FhirClient,
  handle_response: fn(Result(r5.Coverageeligibilityresponse, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.coverageeligibilityresponse_to_json(resource),
    "CoverageEligibilityResponse",
    r5.coverageeligibilityresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Coverageeligibilityresponse, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "CoverageEligibilityResponse",
    r5.coverageeligibilityresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityresponse_update(
  resource: r5.Coverageeligibilityresponse,
  client: FhirClient,
  handle_response: fn(Result(r5.Coverageeligibilityresponse, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.coverageeligibilityresponse_to_json(resource),
    "CoverageEligibilityResponse",
    r5.coverageeligibilityresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn coverageeligibilityresponse_delete(
  resource: r5.Coverageeligibilityresponse,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(
    resource.id,
    "CoverageEligibilityResponse",
    client,
    handle_response,
  )
}

pub fn coverageeligibilityresponse_search_bundled(
  search_for search_args: r5_sansio.SpCoverageeligibilityresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req =
    r5_sansio.coverageeligibilityresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn coverageeligibilityresponse_search(
  search_for search_args: r5_sansio.SpCoverageeligibilityresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r5.Coverageeligibilityresponse), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r5_sansio.coverageeligibilityresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.coverageeligibilityresponse
    },
  )
}

pub fn detectedissue_create(
  resource: r5.Detectedissue,
  client: FhirClient,
  handle_response: fn(Result(r5.Detectedissue, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.detectedissue_to_json(resource),
    "DetectedIssue",
    r5.detectedissue_decoder(),
    client,
    handle_response,
  )
}

pub fn detectedissue_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Detectedissue, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DetectedIssue",
    r5.detectedissue_decoder(),
    client,
    handle_response,
  )
}

pub fn detectedissue_update(
  resource: r5.Detectedissue,
  client: FhirClient,
  handle_response: fn(Result(r5.Detectedissue, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.detectedissue_to_json(resource),
    "DetectedIssue",
    r5.detectedissue_decoder(),
    client,
    handle_response,
  )
}

pub fn detectedissue_delete(
  resource: r5.Detectedissue,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DetectedIssue", client, handle_response)
}

pub fn detectedissue_search_bundled(
  search_for search_args: r5_sansio.SpDetectedissue,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.detectedissue_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn detectedissue_search(
  search_for search_args: r5_sansio.SpDetectedissue,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Detectedissue), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.detectedissue_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.detectedissue
    },
  )
}

pub fn device_create(
  resource: r5.Device,
  client: FhirClient,
  handle_response: fn(Result(r5.Device, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.device_to_json(resource),
    "Device",
    r5.device_decoder(),
    client,
    handle_response,
  )
}

pub fn device_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Device, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Device", r5.device_decoder(), client, handle_response)
}

pub fn device_update(
  resource: r5.Device,
  client: FhirClient,
  handle_response: fn(Result(r5.Device, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.device_to_json(resource),
    "Device",
    r5.device_decoder(),
    client,
    handle_response,
  )
}

pub fn device_delete(
  resource: r5.Device,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Device", client, handle_response)
}

pub fn device_search_bundled(
  search_for search_args: r5_sansio.SpDevice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.device_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn device_search(
  search_for search_args: r5_sansio.SpDevice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Device), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.device_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.device },
  )
}

pub fn deviceassociation_create(
  resource: r5.Deviceassociation,
  client: FhirClient,
  handle_response: fn(Result(r5.Deviceassociation, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.deviceassociation_to_json(resource),
    "DeviceAssociation",
    r5.deviceassociation_decoder(),
    client,
    handle_response,
  )
}

pub fn deviceassociation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Deviceassociation, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DeviceAssociation",
    r5.deviceassociation_decoder(),
    client,
    handle_response,
  )
}

pub fn deviceassociation_update(
  resource: r5.Deviceassociation,
  client: FhirClient,
  handle_response: fn(Result(r5.Deviceassociation, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.deviceassociation_to_json(resource),
    "DeviceAssociation",
    r5.deviceassociation_decoder(),
    client,
    handle_response,
  )
}

pub fn deviceassociation_delete(
  resource: r5.Deviceassociation,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DeviceAssociation", client, handle_response)
}

pub fn deviceassociation_search_bundled(
  search_for search_args: r5_sansio.SpDeviceassociation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.deviceassociation_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn deviceassociation_search(
  search_for search_args: r5_sansio.SpDeviceassociation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Deviceassociation), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.deviceassociation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.deviceassociation
    },
  )
}

pub fn devicedefinition_create(
  resource: r5.Devicedefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Devicedefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.devicedefinition_to_json(resource),
    "DeviceDefinition",
    r5.devicedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn devicedefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Devicedefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DeviceDefinition",
    r5.devicedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn devicedefinition_update(
  resource: r5.Devicedefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Devicedefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.devicedefinition_to_json(resource),
    "DeviceDefinition",
    r5.devicedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn devicedefinition_delete(
  resource: r5.Devicedefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DeviceDefinition", client, handle_response)
}

pub fn devicedefinition_search_bundled(
  search_for search_args: r5_sansio.SpDevicedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.devicedefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn devicedefinition_search(
  search_for search_args: r5_sansio.SpDevicedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Devicedefinition), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.devicedefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.devicedefinition
    },
  )
}

pub fn devicedispense_create(
  resource: r5.Devicedispense,
  client: FhirClient,
  handle_response: fn(Result(r5.Devicedispense, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.devicedispense_to_json(resource),
    "DeviceDispense",
    r5.devicedispense_decoder(),
    client,
    handle_response,
  )
}

pub fn devicedispense_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Devicedispense, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DeviceDispense",
    r5.devicedispense_decoder(),
    client,
    handle_response,
  )
}

pub fn devicedispense_update(
  resource: r5.Devicedispense,
  client: FhirClient,
  handle_response: fn(Result(r5.Devicedispense, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.devicedispense_to_json(resource),
    "DeviceDispense",
    r5.devicedispense_decoder(),
    client,
    handle_response,
  )
}

pub fn devicedispense_delete(
  resource: r5.Devicedispense,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DeviceDispense", client, handle_response)
}

pub fn devicedispense_search_bundled(
  search_for search_args: r5_sansio.SpDevicedispense,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.devicedispense_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn devicedispense_search(
  search_for search_args: r5_sansio.SpDevicedispense,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Devicedispense), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.devicedispense_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.devicedispense
    },
  )
}

pub fn devicemetric_create(
  resource: r5.Devicemetric,
  client: FhirClient,
  handle_response: fn(Result(r5.Devicemetric, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.devicemetric_to_json(resource),
    "DeviceMetric",
    r5.devicemetric_decoder(),
    client,
    handle_response,
  )
}

pub fn devicemetric_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Devicemetric, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DeviceMetric",
    r5.devicemetric_decoder(),
    client,
    handle_response,
  )
}

pub fn devicemetric_update(
  resource: r5.Devicemetric,
  client: FhirClient,
  handle_response: fn(Result(r5.Devicemetric, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.devicemetric_to_json(resource),
    "DeviceMetric",
    r5.devicemetric_decoder(),
    client,
    handle_response,
  )
}

pub fn devicemetric_delete(
  resource: r5.Devicemetric,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DeviceMetric", client, handle_response)
}

pub fn devicemetric_search_bundled(
  search_for search_args: r5_sansio.SpDevicemetric,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.devicemetric_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn devicemetric_search(
  search_for search_args: r5_sansio.SpDevicemetric,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Devicemetric), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.devicemetric_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.devicemetric
    },
  )
}

pub fn devicerequest_create(
  resource: r5.Devicerequest,
  client: FhirClient,
  handle_response: fn(Result(r5.Devicerequest, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.devicerequest_to_json(resource),
    "DeviceRequest",
    r5.devicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn devicerequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Devicerequest, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DeviceRequest",
    r5.devicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn devicerequest_update(
  resource: r5.Devicerequest,
  client: FhirClient,
  handle_response: fn(Result(r5.Devicerequest, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.devicerequest_to_json(resource),
    "DeviceRequest",
    r5.devicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn devicerequest_delete(
  resource: r5.Devicerequest,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DeviceRequest", client, handle_response)
}

pub fn devicerequest_search_bundled(
  search_for search_args: r5_sansio.SpDevicerequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.devicerequest_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn devicerequest_search(
  search_for search_args: r5_sansio.SpDevicerequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Devicerequest), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.devicerequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.devicerequest
    },
  )
}

pub fn deviceusage_create(
  resource: r5.Deviceusage,
  client: FhirClient,
  handle_response: fn(Result(r5.Deviceusage, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.deviceusage_to_json(resource),
    "DeviceUsage",
    r5.deviceusage_decoder(),
    client,
    handle_response,
  )
}

pub fn deviceusage_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Deviceusage, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "DeviceUsage", r5.deviceusage_decoder(), client, handle_response)
}

pub fn deviceusage_update(
  resource: r5.Deviceusage,
  client: FhirClient,
  handle_response: fn(Result(r5.Deviceusage, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.deviceusage_to_json(resource),
    "DeviceUsage",
    r5.deviceusage_decoder(),
    client,
    handle_response,
  )
}

pub fn deviceusage_delete(
  resource: r5.Deviceusage,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DeviceUsage", client, handle_response)
}

pub fn deviceusage_search_bundled(
  search_for search_args: r5_sansio.SpDeviceusage,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.deviceusage_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn deviceusage_search(
  search_for search_args: r5_sansio.SpDeviceusage,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Deviceusage), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.deviceusage_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.deviceusage
    },
  )
}

pub fn diagnosticreport_create(
  resource: r5.Diagnosticreport,
  client: FhirClient,
  handle_response: fn(Result(r5.Diagnosticreport, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.diagnosticreport_to_json(resource),
    "DiagnosticReport",
    r5.diagnosticreport_decoder(),
    client,
    handle_response,
  )
}

pub fn diagnosticreport_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Diagnosticreport, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DiagnosticReport",
    r5.diagnosticreport_decoder(),
    client,
    handle_response,
  )
}

pub fn diagnosticreport_update(
  resource: r5.Diagnosticreport,
  client: FhirClient,
  handle_response: fn(Result(r5.Diagnosticreport, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.diagnosticreport_to_json(resource),
    "DiagnosticReport",
    r5.diagnosticreport_decoder(),
    client,
    handle_response,
  )
}

pub fn diagnosticreport_delete(
  resource: r5.Diagnosticreport,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DiagnosticReport", client, handle_response)
}

pub fn diagnosticreport_search_bundled(
  search_for search_args: r5_sansio.SpDiagnosticreport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.diagnosticreport_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn diagnosticreport_search(
  search_for search_args: r5_sansio.SpDiagnosticreport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Diagnosticreport), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.diagnosticreport_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.diagnosticreport
    },
  )
}

pub fn documentreference_create(
  resource: r5.Documentreference,
  client: FhirClient,
  handle_response: fn(Result(r5.Documentreference, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.documentreference_to_json(resource),
    "DocumentReference",
    r5.documentreference_decoder(),
    client,
    handle_response,
  )
}

pub fn documentreference_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Documentreference, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "DocumentReference",
    r5.documentreference_decoder(),
    client,
    handle_response,
  )
}

pub fn documentreference_update(
  resource: r5.Documentreference,
  client: FhirClient,
  handle_response: fn(Result(r5.Documentreference, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.documentreference_to_json(resource),
    "DocumentReference",
    r5.documentreference_decoder(),
    client,
    handle_response,
  )
}

pub fn documentreference_delete(
  resource: r5.Documentreference,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "DocumentReference", client, handle_response)
}

pub fn documentreference_search_bundled(
  search_for search_args: r5_sansio.SpDocumentreference,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.documentreference_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn documentreference_search(
  search_for search_args: r5_sansio.SpDocumentreference,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Documentreference), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.documentreference_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.documentreference
    },
  )
}

pub fn encounter_create(
  resource: r5.Encounter,
  client: FhirClient,
  handle_response: fn(Result(r5.Encounter, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.encounter_to_json(resource),
    "Encounter",
    r5.encounter_decoder(),
    client,
    handle_response,
  )
}

pub fn encounter_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Encounter, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Encounter", r5.encounter_decoder(), client, handle_response)
}

pub fn encounter_update(
  resource: r5.Encounter,
  client: FhirClient,
  handle_response: fn(Result(r5.Encounter, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.encounter_to_json(resource),
    "Encounter",
    r5.encounter_decoder(),
    client,
    handle_response,
  )
}

pub fn encounter_delete(
  resource: r5.Encounter,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Encounter", client, handle_response)
}

pub fn encounter_search_bundled(
  search_for search_args: r5_sansio.SpEncounter,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.encounter_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn encounter_search(
  search_for search_args: r5_sansio.SpEncounter,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Encounter), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.encounter_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.encounter },
  )
}

pub fn encounterhistory_create(
  resource: r5.Encounterhistory,
  client: FhirClient,
  handle_response: fn(Result(r5.Encounterhistory, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.encounterhistory_to_json(resource),
    "EncounterHistory",
    r5.encounterhistory_decoder(),
    client,
    handle_response,
  )
}

pub fn encounterhistory_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Encounterhistory, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EncounterHistory",
    r5.encounterhistory_decoder(),
    client,
    handle_response,
  )
}

pub fn encounterhistory_update(
  resource: r5.Encounterhistory,
  client: FhirClient,
  handle_response: fn(Result(r5.Encounterhistory, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.encounterhistory_to_json(resource),
    "EncounterHistory",
    r5.encounterhistory_decoder(),
    client,
    handle_response,
  )
}

pub fn encounterhistory_delete(
  resource: r5.Encounterhistory,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "EncounterHistory", client, handle_response)
}

pub fn encounterhistory_search_bundled(
  search_for search_args: r5_sansio.SpEncounterhistory,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.encounterhistory_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn encounterhistory_search(
  search_for search_args: r5_sansio.SpEncounterhistory,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Encounterhistory), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.encounterhistory_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.encounterhistory
    },
  )
}

pub fn endpoint_create(
  resource: r5.Endpoint,
  client: FhirClient,
  handle_response: fn(Result(r5.Endpoint, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.endpoint_to_json(resource),
    "Endpoint",
    r5.endpoint_decoder(),
    client,
    handle_response,
  )
}

pub fn endpoint_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Endpoint, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Endpoint", r5.endpoint_decoder(), client, handle_response)
}

pub fn endpoint_update(
  resource: r5.Endpoint,
  client: FhirClient,
  handle_response: fn(Result(r5.Endpoint, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.endpoint_to_json(resource),
    "Endpoint",
    r5.endpoint_decoder(),
    client,
    handle_response,
  )
}

pub fn endpoint_delete(
  resource: r5.Endpoint,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Endpoint", client, handle_response)
}

pub fn endpoint_search_bundled(
  search_for search_args: r5_sansio.SpEndpoint,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.endpoint_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn endpoint_search(
  search_for search_args: r5_sansio.SpEndpoint,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Endpoint), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.endpoint_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.endpoint },
  )
}

pub fn enrollmentrequest_create(
  resource: r5.Enrollmentrequest,
  client: FhirClient,
  handle_response: fn(Result(r5.Enrollmentrequest, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.enrollmentrequest_to_json(resource),
    "EnrollmentRequest",
    r5.enrollmentrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Enrollmentrequest, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EnrollmentRequest",
    r5.enrollmentrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentrequest_update(
  resource: r5.Enrollmentrequest,
  client: FhirClient,
  handle_response: fn(Result(r5.Enrollmentrequest, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.enrollmentrequest_to_json(resource),
    "EnrollmentRequest",
    r5.enrollmentrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentrequest_delete(
  resource: r5.Enrollmentrequest,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "EnrollmentRequest", client, handle_response)
}

pub fn enrollmentrequest_search_bundled(
  search_for search_args: r5_sansio.SpEnrollmentrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.enrollmentrequest_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn enrollmentrequest_search(
  search_for search_args: r5_sansio.SpEnrollmentrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Enrollmentrequest), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.enrollmentrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.enrollmentrequest
    },
  )
}

pub fn enrollmentresponse_create(
  resource: r5.Enrollmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r5.Enrollmentresponse, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.enrollmentresponse_to_json(resource),
    "EnrollmentResponse",
    r5.enrollmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Enrollmentresponse, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EnrollmentResponse",
    r5.enrollmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentresponse_update(
  resource: r5.Enrollmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r5.Enrollmentresponse, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.enrollmentresponse_to_json(resource),
    "EnrollmentResponse",
    r5.enrollmentresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn enrollmentresponse_delete(
  resource: r5.Enrollmentresponse,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "EnrollmentResponse", client, handle_response)
}

pub fn enrollmentresponse_search_bundled(
  search_for search_args: r5_sansio.SpEnrollmentresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.enrollmentresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn enrollmentresponse_search(
  search_for search_args: r5_sansio.SpEnrollmentresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Enrollmentresponse), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.enrollmentresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.enrollmentresponse
    },
  )
}

pub fn episodeofcare_create(
  resource: r5.Episodeofcare,
  client: FhirClient,
  handle_response: fn(Result(r5.Episodeofcare, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.episodeofcare_to_json(resource),
    "EpisodeOfCare",
    r5.episodeofcare_decoder(),
    client,
    handle_response,
  )
}

pub fn episodeofcare_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Episodeofcare, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EpisodeOfCare",
    r5.episodeofcare_decoder(),
    client,
    handle_response,
  )
}

pub fn episodeofcare_update(
  resource: r5.Episodeofcare,
  client: FhirClient,
  handle_response: fn(Result(r5.Episodeofcare, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.episodeofcare_to_json(resource),
    "EpisodeOfCare",
    r5.episodeofcare_decoder(),
    client,
    handle_response,
  )
}

pub fn episodeofcare_delete(
  resource: r5.Episodeofcare,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "EpisodeOfCare", client, handle_response)
}

pub fn episodeofcare_search_bundled(
  search_for search_args: r5_sansio.SpEpisodeofcare,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.episodeofcare_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn episodeofcare_search(
  search_for search_args: r5_sansio.SpEpisodeofcare,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Episodeofcare), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.episodeofcare_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.episodeofcare
    },
  )
}

pub fn eventdefinition_create(
  resource: r5.Eventdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Eventdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.eventdefinition_to_json(resource),
    "EventDefinition",
    r5.eventdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn eventdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Eventdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EventDefinition",
    r5.eventdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn eventdefinition_update(
  resource: r5.Eventdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Eventdefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.eventdefinition_to_json(resource),
    "EventDefinition",
    r5.eventdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn eventdefinition_delete(
  resource: r5.Eventdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "EventDefinition", client, handle_response)
}

pub fn eventdefinition_search_bundled(
  search_for search_args: r5_sansio.SpEventdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.eventdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn eventdefinition_search(
  search_for search_args: r5_sansio.SpEventdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Eventdefinition), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.eventdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.eventdefinition
    },
  )
}

pub fn evidence_create(
  resource: r5.Evidence,
  client: FhirClient,
  handle_response: fn(Result(r5.Evidence, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.evidence_to_json(resource),
    "Evidence",
    r5.evidence_decoder(),
    client,
    handle_response,
  )
}

pub fn evidence_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Evidence, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Evidence", r5.evidence_decoder(), client, handle_response)
}

pub fn evidence_update(
  resource: r5.Evidence,
  client: FhirClient,
  handle_response: fn(Result(r5.Evidence, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.evidence_to_json(resource),
    "Evidence",
    r5.evidence_decoder(),
    client,
    handle_response,
  )
}

pub fn evidence_delete(
  resource: r5.Evidence,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Evidence", client, handle_response)
}

pub fn evidence_search_bundled(
  search_for search_args: r5_sansio.SpEvidence,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.evidence_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn evidence_search(
  search_for search_args: r5_sansio.SpEvidence,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Evidence), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.evidence_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.evidence },
  )
}

pub fn evidencereport_create(
  resource: r5.Evidencereport,
  client: FhirClient,
  handle_response: fn(Result(r5.Evidencereport, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.evidencereport_to_json(resource),
    "EvidenceReport",
    r5.evidencereport_decoder(),
    client,
    handle_response,
  )
}

pub fn evidencereport_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Evidencereport, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EvidenceReport",
    r5.evidencereport_decoder(),
    client,
    handle_response,
  )
}

pub fn evidencereport_update(
  resource: r5.Evidencereport,
  client: FhirClient,
  handle_response: fn(Result(r5.Evidencereport, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.evidencereport_to_json(resource),
    "EvidenceReport",
    r5.evidencereport_decoder(),
    client,
    handle_response,
  )
}

pub fn evidencereport_delete(
  resource: r5.Evidencereport,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "EvidenceReport", client, handle_response)
}

pub fn evidencereport_search_bundled(
  search_for search_args: r5_sansio.SpEvidencereport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.evidencereport_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn evidencereport_search(
  search_for search_args: r5_sansio.SpEvidencereport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Evidencereport), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.evidencereport_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.evidencereport
    },
  )
}

pub fn evidencevariable_create(
  resource: r5.Evidencevariable,
  client: FhirClient,
  handle_response: fn(Result(r5.Evidencevariable, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.evidencevariable_to_json(resource),
    "EvidenceVariable",
    r5.evidencevariable_decoder(),
    client,
    handle_response,
  )
}

pub fn evidencevariable_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Evidencevariable, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "EvidenceVariable",
    r5.evidencevariable_decoder(),
    client,
    handle_response,
  )
}

pub fn evidencevariable_update(
  resource: r5.Evidencevariable,
  client: FhirClient,
  handle_response: fn(Result(r5.Evidencevariable, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.evidencevariable_to_json(resource),
    "EvidenceVariable",
    r5.evidencevariable_decoder(),
    client,
    handle_response,
  )
}

pub fn evidencevariable_delete(
  resource: r5.Evidencevariable,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "EvidenceVariable", client, handle_response)
}

pub fn evidencevariable_search_bundled(
  search_for search_args: r5_sansio.SpEvidencevariable,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.evidencevariable_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn evidencevariable_search(
  search_for search_args: r5_sansio.SpEvidencevariable,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Evidencevariable), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.evidencevariable_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.evidencevariable
    },
  )
}

pub fn examplescenario_create(
  resource: r5.Examplescenario,
  client: FhirClient,
  handle_response: fn(Result(r5.Examplescenario, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.examplescenario_to_json(resource),
    "ExampleScenario",
    r5.examplescenario_decoder(),
    client,
    handle_response,
  )
}

pub fn examplescenario_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Examplescenario, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ExampleScenario",
    r5.examplescenario_decoder(),
    client,
    handle_response,
  )
}

pub fn examplescenario_update(
  resource: r5.Examplescenario,
  client: FhirClient,
  handle_response: fn(Result(r5.Examplescenario, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.examplescenario_to_json(resource),
    "ExampleScenario",
    r5.examplescenario_decoder(),
    client,
    handle_response,
  )
}

pub fn examplescenario_delete(
  resource: r5.Examplescenario,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ExampleScenario", client, handle_response)
}

pub fn examplescenario_search_bundled(
  search_for search_args: r5_sansio.SpExamplescenario,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.examplescenario_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn examplescenario_search(
  search_for search_args: r5_sansio.SpExamplescenario,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Examplescenario), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.examplescenario_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.examplescenario
    },
  )
}

pub fn explanationofbenefit_create(
  resource: r5.Explanationofbenefit,
  client: FhirClient,
  handle_response: fn(Result(r5.Explanationofbenefit, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.explanationofbenefit_to_json(resource),
    "ExplanationOfBenefit",
    r5.explanationofbenefit_decoder(),
    client,
    handle_response,
  )
}

pub fn explanationofbenefit_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Explanationofbenefit, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ExplanationOfBenefit",
    r5.explanationofbenefit_decoder(),
    client,
    handle_response,
  )
}

pub fn explanationofbenefit_update(
  resource: r5.Explanationofbenefit,
  client: FhirClient,
  handle_response: fn(Result(r5.Explanationofbenefit, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.explanationofbenefit_to_json(resource),
    "ExplanationOfBenefit",
    r5.explanationofbenefit_decoder(),
    client,
    handle_response,
  )
}

pub fn explanationofbenefit_delete(
  resource: r5.Explanationofbenefit,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ExplanationOfBenefit", client, handle_response)
}

pub fn explanationofbenefit_search_bundled(
  search_for search_args: r5_sansio.SpExplanationofbenefit,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.explanationofbenefit_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn explanationofbenefit_search(
  search_for search_args: r5_sansio.SpExplanationofbenefit,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r5.Explanationofbenefit), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.explanationofbenefit_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.explanationofbenefit
    },
  )
}

pub fn familymemberhistory_create(
  resource: r5.Familymemberhistory,
  client: FhirClient,
  handle_response: fn(Result(r5.Familymemberhistory, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    r5.familymemberhistory_decoder(),
    client,
    handle_response,
  )
}

pub fn familymemberhistory_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Familymemberhistory, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "FamilyMemberHistory",
    r5.familymemberhistory_decoder(),
    client,
    handle_response,
  )
}

pub fn familymemberhistory_update(
  resource: r5.Familymemberhistory,
  client: FhirClient,
  handle_response: fn(Result(r5.Familymemberhistory, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    r5.familymemberhistory_decoder(),
    client,
    handle_response,
  )
}

pub fn familymemberhistory_delete(
  resource: r5.Familymemberhistory,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "FamilyMemberHistory", client, handle_response)
}

pub fn familymemberhistory_search_bundled(
  search_for search_args: r5_sansio.SpFamilymemberhistory,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.familymemberhistory_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn familymemberhistory_search(
  search_for search_args: r5_sansio.SpFamilymemberhistory,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Familymemberhistory), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.familymemberhistory_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.familymemberhistory
    },
  )
}

pub fn flag_create(
  resource: r5.Flag,
  client: FhirClient,
  handle_response: fn(Result(r5.Flag, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.flag_to_json(resource),
    "Flag",
    r5.flag_decoder(),
    client,
    handle_response,
  )
}

pub fn flag_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Flag, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Flag", r5.flag_decoder(), client, handle_response)
}

pub fn flag_update(
  resource: r5.Flag,
  client: FhirClient,
  handle_response: fn(Result(r5.Flag, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.flag_to_json(resource),
    "Flag",
    r5.flag_decoder(),
    client,
    handle_response,
  )
}

pub fn flag_delete(
  resource: r5.Flag,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Flag", client, handle_response)
}

pub fn flag_search_bundled(
  search_for search_args: r5_sansio.SpFlag,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.flag_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn flag_search(
  search_for search_args: r5_sansio.SpFlag,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Flag), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.flag_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.flag },
  )
}

pub fn formularyitem_create(
  resource: r5.Formularyitem,
  client: FhirClient,
  handle_response: fn(Result(r5.Formularyitem, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.formularyitem_to_json(resource),
    "FormularyItem",
    r5.formularyitem_decoder(),
    client,
    handle_response,
  )
}

pub fn formularyitem_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Formularyitem, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "FormularyItem",
    r5.formularyitem_decoder(),
    client,
    handle_response,
  )
}

pub fn formularyitem_update(
  resource: r5.Formularyitem,
  client: FhirClient,
  handle_response: fn(Result(r5.Formularyitem, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.formularyitem_to_json(resource),
    "FormularyItem",
    r5.formularyitem_decoder(),
    client,
    handle_response,
  )
}

pub fn formularyitem_delete(
  resource: r5.Formularyitem,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "FormularyItem", client, handle_response)
}

pub fn formularyitem_search_bundled(
  search_for search_args: r5_sansio.SpFormularyitem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.formularyitem_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn formularyitem_search(
  search_for search_args: r5_sansio.SpFormularyitem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Formularyitem), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.formularyitem_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.formularyitem
    },
  )
}

pub fn genomicstudy_create(
  resource: r5.Genomicstudy,
  client: FhirClient,
  handle_response: fn(Result(r5.Genomicstudy, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.genomicstudy_to_json(resource),
    "GenomicStudy",
    r5.genomicstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn genomicstudy_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Genomicstudy, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "GenomicStudy",
    r5.genomicstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn genomicstudy_update(
  resource: r5.Genomicstudy,
  client: FhirClient,
  handle_response: fn(Result(r5.Genomicstudy, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.genomicstudy_to_json(resource),
    "GenomicStudy",
    r5.genomicstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn genomicstudy_delete(
  resource: r5.Genomicstudy,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "GenomicStudy", client, handle_response)
}

pub fn genomicstudy_search_bundled(
  search_for search_args: r5_sansio.SpGenomicstudy,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.genomicstudy_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn genomicstudy_search(
  search_for search_args: r5_sansio.SpGenomicstudy,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Genomicstudy), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.genomicstudy_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.genomicstudy
    },
  )
}

pub fn goal_create(
  resource: r5.Goal,
  client: FhirClient,
  handle_response: fn(Result(r5.Goal, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.goal_to_json(resource),
    "Goal",
    r5.goal_decoder(),
    client,
    handle_response,
  )
}

pub fn goal_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Goal, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Goal", r5.goal_decoder(), client, handle_response)
}

pub fn goal_update(
  resource: r5.Goal,
  client: FhirClient,
  handle_response: fn(Result(r5.Goal, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.goal_to_json(resource),
    "Goal",
    r5.goal_decoder(),
    client,
    handle_response,
  )
}

pub fn goal_delete(
  resource: r5.Goal,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Goal", client, handle_response)
}

pub fn goal_search_bundled(
  search_for search_args: r5_sansio.SpGoal,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.goal_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn goal_search(
  search_for search_args: r5_sansio.SpGoal,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Goal), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.goal_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.goal },
  )
}

pub fn graphdefinition_create(
  resource: r5.Graphdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Graphdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.graphdefinition_to_json(resource),
    "GraphDefinition",
    r5.graphdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn graphdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Graphdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "GraphDefinition",
    r5.graphdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn graphdefinition_update(
  resource: r5.Graphdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Graphdefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.graphdefinition_to_json(resource),
    "GraphDefinition",
    r5.graphdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn graphdefinition_delete(
  resource: r5.Graphdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "GraphDefinition", client, handle_response)
}

pub fn graphdefinition_search_bundled(
  search_for search_args: r5_sansio.SpGraphdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.graphdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn graphdefinition_search(
  search_for search_args: r5_sansio.SpGraphdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Graphdefinition), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.graphdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.graphdefinition
    },
  )
}

pub fn group_create(
  resource: r5.Group,
  client: FhirClient,
  handle_response: fn(Result(r5.Group, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.group_to_json(resource),
    "Group",
    r5.group_decoder(),
    client,
    handle_response,
  )
}

pub fn group_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Group, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Group", r5.group_decoder(), client, handle_response)
}

pub fn group_update(
  resource: r5.Group,
  client: FhirClient,
  handle_response: fn(Result(r5.Group, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.group_to_json(resource),
    "Group",
    r5.group_decoder(),
    client,
    handle_response,
  )
}

pub fn group_delete(
  resource: r5.Group,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Group", client, handle_response)
}

pub fn group_search_bundled(
  search_for search_args: r5_sansio.SpGroup,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.group_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn group_search(
  search_for search_args: r5_sansio.SpGroup,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Group), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.group_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.group },
  )
}

pub fn guidanceresponse_create(
  resource: r5.Guidanceresponse,
  client: FhirClient,
  handle_response: fn(Result(r5.Guidanceresponse, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.guidanceresponse_to_json(resource),
    "GuidanceResponse",
    r5.guidanceresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn guidanceresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Guidanceresponse, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "GuidanceResponse",
    r5.guidanceresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn guidanceresponse_update(
  resource: r5.Guidanceresponse,
  client: FhirClient,
  handle_response: fn(Result(r5.Guidanceresponse, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.guidanceresponse_to_json(resource),
    "GuidanceResponse",
    r5.guidanceresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn guidanceresponse_delete(
  resource: r5.Guidanceresponse,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "GuidanceResponse", client, handle_response)
}

pub fn guidanceresponse_search_bundled(
  search_for search_args: r5_sansio.SpGuidanceresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.guidanceresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn guidanceresponse_search(
  search_for search_args: r5_sansio.SpGuidanceresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Guidanceresponse), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.guidanceresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.guidanceresponse
    },
  )
}

pub fn healthcareservice_create(
  resource: r5.Healthcareservice,
  client: FhirClient,
  handle_response: fn(Result(r5.Healthcareservice, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.healthcareservice_to_json(resource),
    "HealthcareService",
    r5.healthcareservice_decoder(),
    client,
    handle_response,
  )
}

pub fn healthcareservice_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Healthcareservice, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "HealthcareService",
    r5.healthcareservice_decoder(),
    client,
    handle_response,
  )
}

pub fn healthcareservice_update(
  resource: r5.Healthcareservice,
  client: FhirClient,
  handle_response: fn(Result(r5.Healthcareservice, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.healthcareservice_to_json(resource),
    "HealthcareService",
    r5.healthcareservice_decoder(),
    client,
    handle_response,
  )
}

pub fn healthcareservice_delete(
  resource: r5.Healthcareservice,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "HealthcareService", client, handle_response)
}

pub fn healthcareservice_search_bundled(
  search_for search_args: r5_sansio.SpHealthcareservice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.healthcareservice_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn healthcareservice_search(
  search_for search_args: r5_sansio.SpHealthcareservice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Healthcareservice), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.healthcareservice_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.healthcareservice
    },
  )
}

pub fn imagingselection_create(
  resource: r5.Imagingselection,
  client: FhirClient,
  handle_response: fn(Result(r5.Imagingselection, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.imagingselection_to_json(resource),
    "ImagingSelection",
    r5.imagingselection_decoder(),
    client,
    handle_response,
  )
}

pub fn imagingselection_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Imagingselection, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ImagingSelection",
    r5.imagingselection_decoder(),
    client,
    handle_response,
  )
}

pub fn imagingselection_update(
  resource: r5.Imagingselection,
  client: FhirClient,
  handle_response: fn(Result(r5.Imagingselection, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.imagingselection_to_json(resource),
    "ImagingSelection",
    r5.imagingselection_decoder(),
    client,
    handle_response,
  )
}

pub fn imagingselection_delete(
  resource: r5.Imagingselection,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ImagingSelection", client, handle_response)
}

pub fn imagingselection_search_bundled(
  search_for search_args: r5_sansio.SpImagingselection,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.imagingselection_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn imagingselection_search(
  search_for search_args: r5_sansio.SpImagingselection,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Imagingselection), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.imagingselection_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.imagingselection
    },
  )
}

pub fn imagingstudy_create(
  resource: r5.Imagingstudy,
  client: FhirClient,
  handle_response: fn(Result(r5.Imagingstudy, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.imagingstudy_to_json(resource),
    "ImagingStudy",
    r5.imagingstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn imagingstudy_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Imagingstudy, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ImagingStudy",
    r5.imagingstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn imagingstudy_update(
  resource: r5.Imagingstudy,
  client: FhirClient,
  handle_response: fn(Result(r5.Imagingstudy, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.imagingstudy_to_json(resource),
    "ImagingStudy",
    r5.imagingstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn imagingstudy_delete(
  resource: r5.Imagingstudy,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ImagingStudy", client, handle_response)
}

pub fn imagingstudy_search_bundled(
  search_for search_args: r5_sansio.SpImagingstudy,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.imagingstudy_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn imagingstudy_search(
  search_for search_args: r5_sansio.SpImagingstudy,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Imagingstudy), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.imagingstudy_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.imagingstudy
    },
  )
}

pub fn immunization_create(
  resource: r5.Immunization,
  client: FhirClient,
  handle_response: fn(Result(r5.Immunization, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.immunization_to_json(resource),
    "Immunization",
    r5.immunization_decoder(),
    client,
    handle_response,
  )
}

pub fn immunization_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Immunization, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Immunization",
    r5.immunization_decoder(),
    client,
    handle_response,
  )
}

pub fn immunization_update(
  resource: r5.Immunization,
  client: FhirClient,
  handle_response: fn(Result(r5.Immunization, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.immunization_to_json(resource),
    "Immunization",
    r5.immunization_decoder(),
    client,
    handle_response,
  )
}

pub fn immunization_delete(
  resource: r5.Immunization,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Immunization", client, handle_response)
}

pub fn immunization_search_bundled(
  search_for search_args: r5_sansio.SpImmunization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.immunization_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn immunization_search(
  search_for search_args: r5_sansio.SpImmunization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Immunization), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.immunization_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.immunization
    },
  )
}

pub fn immunizationevaluation_create(
  resource: r5.Immunizationevaluation,
  client: FhirClient,
  handle_response: fn(Result(r5.Immunizationevaluation, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.immunizationevaluation_to_json(resource),
    "ImmunizationEvaluation",
    r5.immunizationevaluation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationevaluation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Immunizationevaluation, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ImmunizationEvaluation",
    r5.immunizationevaluation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationevaluation_update(
  resource: r5.Immunizationevaluation,
  client: FhirClient,
  handle_response: fn(Result(r5.Immunizationevaluation, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.immunizationevaluation_to_json(resource),
    "ImmunizationEvaluation",
    r5.immunizationevaluation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationevaluation_delete(
  resource: r5.Immunizationevaluation,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ImmunizationEvaluation", client, handle_response)
}

pub fn immunizationevaluation_search_bundled(
  search_for search_args: r5_sansio.SpImmunizationevaluation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.immunizationevaluation_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn immunizationevaluation_search(
  search_for search_args: r5_sansio.SpImmunizationevaluation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r5.Immunizationevaluation), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.immunizationevaluation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.immunizationevaluation
    },
  )
}

pub fn immunizationrecommendation_create(
  resource: r5.Immunizationrecommendation,
  client: FhirClient,
  handle_response: fn(Result(r5.Immunizationrecommendation, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.immunizationrecommendation_to_json(resource),
    "ImmunizationRecommendation",
    r5.immunizationrecommendation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationrecommendation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Immunizationrecommendation, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ImmunizationRecommendation",
    r5.immunizationrecommendation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationrecommendation_update(
  resource: r5.Immunizationrecommendation,
  client: FhirClient,
  handle_response: fn(Result(r5.Immunizationrecommendation, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.immunizationrecommendation_to_json(resource),
    "ImmunizationRecommendation",
    r5.immunizationrecommendation_decoder(),
    client,
    handle_response,
  )
}

pub fn immunizationrecommendation_delete(
  resource: r5.Immunizationrecommendation,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ImmunizationRecommendation", client, handle_response)
}

pub fn immunizationrecommendation_search_bundled(
  search_for search_args: r5_sansio.SpImmunizationrecommendation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.immunizationrecommendation_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn immunizationrecommendation_search(
  search_for search_args: r5_sansio.SpImmunizationrecommendation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r5.Immunizationrecommendation), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.immunizationrecommendation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.immunizationrecommendation
    },
  )
}

pub fn implementationguide_create(
  resource: r5.Implementationguide,
  client: FhirClient,
  handle_response: fn(Result(r5.Implementationguide, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.implementationguide_to_json(resource),
    "ImplementationGuide",
    r5.implementationguide_decoder(),
    client,
    handle_response,
  )
}

pub fn implementationguide_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Implementationguide, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ImplementationGuide",
    r5.implementationguide_decoder(),
    client,
    handle_response,
  )
}

pub fn implementationguide_update(
  resource: r5.Implementationguide,
  client: FhirClient,
  handle_response: fn(Result(r5.Implementationguide, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.implementationguide_to_json(resource),
    "ImplementationGuide",
    r5.implementationguide_decoder(),
    client,
    handle_response,
  )
}

pub fn implementationguide_delete(
  resource: r5.Implementationguide,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ImplementationGuide", client, handle_response)
}

pub fn implementationguide_search_bundled(
  search_for search_args: r5_sansio.SpImplementationguide,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.implementationguide_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn implementationguide_search(
  search_for search_args: r5_sansio.SpImplementationguide,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Implementationguide), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.implementationguide_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.implementationguide
    },
  )
}

pub fn ingredient_create(
  resource: r5.Ingredient,
  client: FhirClient,
  handle_response: fn(Result(r5.Ingredient, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.ingredient_to_json(resource),
    "Ingredient",
    r5.ingredient_decoder(),
    client,
    handle_response,
  )
}

pub fn ingredient_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Ingredient, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Ingredient", r5.ingredient_decoder(), client, handle_response)
}

pub fn ingredient_update(
  resource: r5.Ingredient,
  client: FhirClient,
  handle_response: fn(Result(r5.Ingredient, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.ingredient_to_json(resource),
    "Ingredient",
    r5.ingredient_decoder(),
    client,
    handle_response,
  )
}

pub fn ingredient_delete(
  resource: r5.Ingredient,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Ingredient", client, handle_response)
}

pub fn ingredient_search_bundled(
  search_for search_args: r5_sansio.SpIngredient,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.ingredient_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn ingredient_search(
  search_for search_args: r5_sansio.SpIngredient,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Ingredient), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.ingredient_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.ingredient },
  )
}

pub fn insuranceplan_create(
  resource: r5.Insuranceplan,
  client: FhirClient,
  handle_response: fn(Result(r5.Insuranceplan, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.insuranceplan_to_json(resource),
    "InsurancePlan",
    r5.insuranceplan_decoder(),
    client,
    handle_response,
  )
}

pub fn insuranceplan_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Insuranceplan, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "InsurancePlan",
    r5.insuranceplan_decoder(),
    client,
    handle_response,
  )
}

pub fn insuranceplan_update(
  resource: r5.Insuranceplan,
  client: FhirClient,
  handle_response: fn(Result(r5.Insuranceplan, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.insuranceplan_to_json(resource),
    "InsurancePlan",
    r5.insuranceplan_decoder(),
    client,
    handle_response,
  )
}

pub fn insuranceplan_delete(
  resource: r5.Insuranceplan,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "InsurancePlan", client, handle_response)
}

pub fn insuranceplan_search_bundled(
  search_for search_args: r5_sansio.SpInsuranceplan,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.insuranceplan_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn insuranceplan_search(
  search_for search_args: r5_sansio.SpInsuranceplan,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Insuranceplan), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.insuranceplan_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.insuranceplan
    },
  )
}

pub fn inventoryitem_create(
  resource: r5.Inventoryitem,
  client: FhirClient,
  handle_response: fn(Result(r5.Inventoryitem, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.inventoryitem_to_json(resource),
    "InventoryItem",
    r5.inventoryitem_decoder(),
    client,
    handle_response,
  )
}

pub fn inventoryitem_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Inventoryitem, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "InventoryItem",
    r5.inventoryitem_decoder(),
    client,
    handle_response,
  )
}

pub fn inventoryitem_update(
  resource: r5.Inventoryitem,
  client: FhirClient,
  handle_response: fn(Result(r5.Inventoryitem, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.inventoryitem_to_json(resource),
    "InventoryItem",
    r5.inventoryitem_decoder(),
    client,
    handle_response,
  )
}

pub fn inventoryitem_delete(
  resource: r5.Inventoryitem,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "InventoryItem", client, handle_response)
}

pub fn inventoryitem_search_bundled(
  search_for search_args: r5_sansio.SpInventoryitem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.inventoryitem_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn inventoryitem_search(
  search_for search_args: r5_sansio.SpInventoryitem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Inventoryitem), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.inventoryitem_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.inventoryitem
    },
  )
}

pub fn inventoryreport_create(
  resource: r5.Inventoryreport,
  client: FhirClient,
  handle_response: fn(Result(r5.Inventoryreport, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.inventoryreport_to_json(resource),
    "InventoryReport",
    r5.inventoryreport_decoder(),
    client,
    handle_response,
  )
}

pub fn inventoryreport_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Inventoryreport, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "InventoryReport",
    r5.inventoryreport_decoder(),
    client,
    handle_response,
  )
}

pub fn inventoryreport_update(
  resource: r5.Inventoryreport,
  client: FhirClient,
  handle_response: fn(Result(r5.Inventoryreport, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.inventoryreport_to_json(resource),
    "InventoryReport",
    r5.inventoryreport_decoder(),
    client,
    handle_response,
  )
}

pub fn inventoryreport_delete(
  resource: r5.Inventoryreport,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "InventoryReport", client, handle_response)
}

pub fn inventoryreport_search_bundled(
  search_for search_args: r5_sansio.SpInventoryreport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.inventoryreport_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn inventoryreport_search(
  search_for search_args: r5_sansio.SpInventoryreport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Inventoryreport), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.inventoryreport_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.inventoryreport
    },
  )
}

pub fn invoice_create(
  resource: r5.Invoice,
  client: FhirClient,
  handle_response: fn(Result(r5.Invoice, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.invoice_to_json(resource),
    "Invoice",
    r5.invoice_decoder(),
    client,
    handle_response,
  )
}

pub fn invoice_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Invoice, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Invoice", r5.invoice_decoder(), client, handle_response)
}

pub fn invoice_update(
  resource: r5.Invoice,
  client: FhirClient,
  handle_response: fn(Result(r5.Invoice, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.invoice_to_json(resource),
    "Invoice",
    r5.invoice_decoder(),
    client,
    handle_response,
  )
}

pub fn invoice_delete(
  resource: r5.Invoice,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Invoice", client, handle_response)
}

pub fn invoice_search_bundled(
  search_for search_args: r5_sansio.SpInvoice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.invoice_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn invoice_search(
  search_for search_args: r5_sansio.SpInvoice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Invoice), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.invoice_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.invoice },
  )
}

pub fn library_create(
  resource: r5.Library,
  client: FhirClient,
  handle_response: fn(Result(r5.Library, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.library_to_json(resource),
    "Library",
    r5.library_decoder(),
    client,
    handle_response,
  )
}

pub fn library_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Library, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Library", r5.library_decoder(), client, handle_response)
}

pub fn library_update(
  resource: r5.Library,
  client: FhirClient,
  handle_response: fn(Result(r5.Library, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.library_to_json(resource),
    "Library",
    r5.library_decoder(),
    client,
    handle_response,
  )
}

pub fn library_delete(
  resource: r5.Library,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Library", client, handle_response)
}

pub fn library_search_bundled(
  search_for search_args: r5_sansio.SpLibrary,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.library_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn library_search(
  search_for search_args: r5_sansio.SpLibrary,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Library), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.library_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.library },
  )
}

pub fn linkage_create(
  resource: r5.Linkage,
  client: FhirClient,
  handle_response: fn(Result(r5.Linkage, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.linkage_to_json(resource),
    "Linkage",
    r5.linkage_decoder(),
    client,
    handle_response,
  )
}

pub fn linkage_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Linkage, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Linkage", r5.linkage_decoder(), client, handle_response)
}

pub fn linkage_update(
  resource: r5.Linkage,
  client: FhirClient,
  handle_response: fn(Result(r5.Linkage, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.linkage_to_json(resource),
    "Linkage",
    r5.linkage_decoder(),
    client,
    handle_response,
  )
}

pub fn linkage_delete(
  resource: r5.Linkage,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Linkage", client, handle_response)
}

pub fn linkage_search_bundled(
  search_for search_args: r5_sansio.SpLinkage,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.linkage_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn linkage_search(
  search_for search_args: r5_sansio.SpLinkage,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Linkage), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.linkage_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.linkage },
  )
}

pub fn listfhir_create(
  resource: r5.Listfhir,
  client: FhirClient,
  handle_response: fn(Result(r5.Listfhir, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.listfhir_to_json(resource),
    "List",
    r5.listfhir_decoder(),
    client,
    handle_response,
  )
}

pub fn listfhir_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Listfhir, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "List", r5.listfhir_decoder(), client, handle_response)
}

pub fn listfhir_update(
  resource: r5.Listfhir,
  client: FhirClient,
  handle_response: fn(Result(r5.Listfhir, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.listfhir_to_json(resource),
    "List",
    r5.listfhir_decoder(),
    client,
    handle_response,
  )
}

pub fn listfhir_delete(
  resource: r5.Listfhir,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "List", client, handle_response)
}

pub fn listfhir_search_bundled(
  search_for search_args: r5_sansio.SpListfhir,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.listfhir_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn listfhir_search(
  search_for search_args: r5_sansio.SpListfhir,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Listfhir), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.listfhir_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.listfhir },
  )
}

pub fn location_create(
  resource: r5.Location,
  client: FhirClient,
  handle_response: fn(Result(r5.Location, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.location_to_json(resource),
    "Location",
    r5.location_decoder(),
    client,
    handle_response,
  )
}

pub fn location_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Location, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Location", r5.location_decoder(), client, handle_response)
}

pub fn location_update(
  resource: r5.Location,
  client: FhirClient,
  handle_response: fn(Result(r5.Location, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.location_to_json(resource),
    "Location",
    r5.location_decoder(),
    client,
    handle_response,
  )
}

pub fn location_delete(
  resource: r5.Location,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Location", client, handle_response)
}

pub fn location_search_bundled(
  search_for search_args: r5_sansio.SpLocation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.location_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn location_search(
  search_for search_args: r5_sansio.SpLocation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Location), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.location_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.location },
  )
}

pub fn manufactureditemdefinition_create(
  resource: r5.Manufactureditemdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Manufactureditemdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.manufactureditemdefinition_to_json(resource),
    "ManufacturedItemDefinition",
    r5.manufactureditemdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn manufactureditemdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Manufactureditemdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ManufacturedItemDefinition",
    r5.manufactureditemdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn manufactureditemdefinition_update(
  resource: r5.Manufactureditemdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Manufactureditemdefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.manufactureditemdefinition_to_json(resource),
    "ManufacturedItemDefinition",
    r5.manufactureditemdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn manufactureditemdefinition_delete(
  resource: r5.Manufactureditemdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ManufacturedItemDefinition", client, handle_response)
}

pub fn manufactureditemdefinition_search_bundled(
  search_for search_args: r5_sansio.SpManufactureditemdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.manufactureditemdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn manufactureditemdefinition_search(
  search_for search_args: r5_sansio.SpManufactureditemdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r5.Manufactureditemdefinition), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.manufactureditemdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.manufactureditemdefinition
    },
  )
}

pub fn measure_create(
  resource: r5.Measure,
  client: FhirClient,
  handle_response: fn(Result(r5.Measure, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.measure_to_json(resource),
    "Measure",
    r5.measure_decoder(),
    client,
    handle_response,
  )
}

pub fn measure_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Measure, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Measure", r5.measure_decoder(), client, handle_response)
}

pub fn measure_update(
  resource: r5.Measure,
  client: FhirClient,
  handle_response: fn(Result(r5.Measure, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.measure_to_json(resource),
    "Measure",
    r5.measure_decoder(),
    client,
    handle_response,
  )
}

pub fn measure_delete(
  resource: r5.Measure,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Measure", client, handle_response)
}

pub fn measure_search_bundled(
  search_for search_args: r5_sansio.SpMeasure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.measure_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn measure_search(
  search_for search_args: r5_sansio.SpMeasure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Measure), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.measure_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.measure },
  )
}

pub fn measurereport_create(
  resource: r5.Measurereport,
  client: FhirClient,
  handle_response: fn(Result(r5.Measurereport, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.measurereport_to_json(resource),
    "MeasureReport",
    r5.measurereport_decoder(),
    client,
    handle_response,
  )
}

pub fn measurereport_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Measurereport, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MeasureReport",
    r5.measurereport_decoder(),
    client,
    handle_response,
  )
}

pub fn measurereport_update(
  resource: r5.Measurereport,
  client: FhirClient,
  handle_response: fn(Result(r5.Measurereport, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.measurereport_to_json(resource),
    "MeasureReport",
    r5.measurereport_decoder(),
    client,
    handle_response,
  )
}

pub fn measurereport_delete(
  resource: r5.Measurereport,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MeasureReport", client, handle_response)
}

pub fn measurereport_search_bundled(
  search_for search_args: r5_sansio.SpMeasurereport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.measurereport_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn measurereport_search(
  search_for search_args: r5_sansio.SpMeasurereport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Measurereport), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.measurereport_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.measurereport
    },
  )
}

pub fn medication_create(
  resource: r5.Medication,
  client: FhirClient,
  handle_response: fn(Result(r5.Medication, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.medication_to_json(resource),
    "Medication",
    r5.medication_decoder(),
    client,
    handle_response,
  )
}

pub fn medication_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Medication, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Medication", r5.medication_decoder(), client, handle_response)
}

pub fn medication_update(
  resource: r5.Medication,
  client: FhirClient,
  handle_response: fn(Result(r5.Medication, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.medication_to_json(resource),
    "Medication",
    r5.medication_decoder(),
    client,
    handle_response,
  )
}

pub fn medication_delete(
  resource: r5.Medication,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Medication", client, handle_response)
}

pub fn medication_search_bundled(
  search_for search_args: r5_sansio.SpMedication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.medication_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn medication_search(
  search_for search_args: r5_sansio.SpMedication,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Medication), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.medication_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.medication },
  )
}

pub fn medicationadministration_create(
  resource: r5.Medicationadministration,
  client: FhirClient,
  handle_response: fn(Result(r5.Medicationadministration, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.medicationadministration_to_json(resource),
    "MedicationAdministration",
    r5.medicationadministration_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationadministration_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Medicationadministration, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationAdministration",
    r5.medicationadministration_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationadministration_update(
  resource: r5.Medicationadministration,
  client: FhirClient,
  handle_response: fn(Result(r5.Medicationadministration, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.medicationadministration_to_json(resource),
    "MedicationAdministration",
    r5.medicationadministration_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationadministration_delete(
  resource: r5.Medicationadministration,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicationAdministration", client, handle_response)
}

pub fn medicationadministration_search_bundled(
  search_for search_args: r5_sansio.SpMedicationadministration,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.medicationadministration_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn medicationadministration_search(
  search_for search_args: r5_sansio.SpMedicationadministration,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r5.Medicationadministration), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.medicationadministration_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.medicationadministration
    },
  )
}

pub fn medicationdispense_create(
  resource: r5.Medicationdispense,
  client: FhirClient,
  handle_response: fn(Result(r5.Medicationdispense, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.medicationdispense_to_json(resource),
    "MedicationDispense",
    r5.medicationdispense_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationdispense_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Medicationdispense, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationDispense",
    r5.medicationdispense_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationdispense_update(
  resource: r5.Medicationdispense,
  client: FhirClient,
  handle_response: fn(Result(r5.Medicationdispense, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.medicationdispense_to_json(resource),
    "MedicationDispense",
    r5.medicationdispense_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationdispense_delete(
  resource: r5.Medicationdispense,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicationDispense", client, handle_response)
}

pub fn medicationdispense_search_bundled(
  search_for search_args: r5_sansio.SpMedicationdispense,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.medicationdispense_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn medicationdispense_search(
  search_for search_args: r5_sansio.SpMedicationdispense,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Medicationdispense), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.medicationdispense_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.medicationdispense
    },
  )
}

pub fn medicationknowledge_create(
  resource: r5.Medicationknowledge,
  client: FhirClient,
  handle_response: fn(Result(r5.Medicationknowledge, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.medicationknowledge_to_json(resource),
    "MedicationKnowledge",
    r5.medicationknowledge_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationknowledge_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Medicationknowledge, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationKnowledge",
    r5.medicationknowledge_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationknowledge_update(
  resource: r5.Medicationknowledge,
  client: FhirClient,
  handle_response: fn(Result(r5.Medicationknowledge, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.medicationknowledge_to_json(resource),
    "MedicationKnowledge",
    r5.medicationknowledge_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationknowledge_delete(
  resource: r5.Medicationknowledge,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicationKnowledge", client, handle_response)
}

pub fn medicationknowledge_search_bundled(
  search_for search_args: r5_sansio.SpMedicationknowledge,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.medicationknowledge_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn medicationknowledge_search(
  search_for search_args: r5_sansio.SpMedicationknowledge,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Medicationknowledge), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.medicationknowledge_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.medicationknowledge
    },
  )
}

pub fn medicationrequest_create(
  resource: r5.Medicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r5.Medicationrequest, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.medicationrequest_to_json(resource),
    "MedicationRequest",
    r5.medicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Medicationrequest, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationRequest",
    r5.medicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationrequest_update(
  resource: r5.Medicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r5.Medicationrequest, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.medicationrequest_to_json(resource),
    "MedicationRequest",
    r5.medicationrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationrequest_delete(
  resource: r5.Medicationrequest,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicationRequest", client, handle_response)
}

pub fn medicationrequest_search_bundled(
  search_for search_args: r5_sansio.SpMedicationrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.medicationrequest_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn medicationrequest_search(
  search_for search_args: r5_sansio.SpMedicationrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Medicationrequest), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.medicationrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.medicationrequest
    },
  )
}

pub fn medicationstatement_create(
  resource: r5.Medicationstatement,
  client: FhirClient,
  handle_response: fn(Result(r5.Medicationstatement, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.medicationstatement_to_json(resource),
    "MedicationStatement",
    r5.medicationstatement_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationstatement_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Medicationstatement, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicationStatement",
    r5.medicationstatement_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationstatement_update(
  resource: r5.Medicationstatement,
  client: FhirClient,
  handle_response: fn(Result(r5.Medicationstatement, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.medicationstatement_to_json(resource),
    "MedicationStatement",
    r5.medicationstatement_decoder(),
    client,
    handle_response,
  )
}

pub fn medicationstatement_delete(
  resource: r5.Medicationstatement,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicationStatement", client, handle_response)
}

pub fn medicationstatement_search_bundled(
  search_for search_args: r5_sansio.SpMedicationstatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.medicationstatement_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn medicationstatement_search(
  search_for search_args: r5_sansio.SpMedicationstatement,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Medicationstatement), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.medicationstatement_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.medicationstatement
    },
  )
}

pub fn medicinalproductdefinition_create(
  resource: r5.Medicinalproductdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Medicinalproductdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.medicinalproductdefinition_to_json(resource),
    "MedicinalProductDefinition",
    r5.medicinalproductdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Medicinalproductdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MedicinalProductDefinition",
    r5.medicinalproductdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductdefinition_update(
  resource: r5.Medicinalproductdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Medicinalproductdefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.medicinalproductdefinition_to_json(resource),
    "MedicinalProductDefinition",
    r5.medicinalproductdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn medicinalproductdefinition_delete(
  resource: r5.Medicinalproductdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MedicinalProductDefinition", client, handle_response)
}

pub fn medicinalproductdefinition_search_bundled(
  search_for search_args: r5_sansio.SpMedicinalproductdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.medicinalproductdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn medicinalproductdefinition_search(
  search_for search_args: r5_sansio.SpMedicinalproductdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r5.Medicinalproductdefinition), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.medicinalproductdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.medicinalproductdefinition
    },
  )
}

pub fn messagedefinition_create(
  resource: r5.Messagedefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Messagedefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.messagedefinition_to_json(resource),
    "MessageDefinition",
    r5.messagedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn messagedefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Messagedefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MessageDefinition",
    r5.messagedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn messagedefinition_update(
  resource: r5.Messagedefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Messagedefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.messagedefinition_to_json(resource),
    "MessageDefinition",
    r5.messagedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn messagedefinition_delete(
  resource: r5.Messagedefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MessageDefinition", client, handle_response)
}

pub fn messagedefinition_search_bundled(
  search_for search_args: r5_sansio.SpMessagedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.messagedefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn messagedefinition_search(
  search_for search_args: r5_sansio.SpMessagedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Messagedefinition), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.messagedefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.messagedefinition
    },
  )
}

pub fn messageheader_create(
  resource: r5.Messageheader,
  client: FhirClient,
  handle_response: fn(Result(r5.Messageheader, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.messageheader_to_json(resource),
    "MessageHeader",
    r5.messageheader_decoder(),
    client,
    handle_response,
  )
}

pub fn messageheader_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Messageheader, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MessageHeader",
    r5.messageheader_decoder(),
    client,
    handle_response,
  )
}

pub fn messageheader_update(
  resource: r5.Messageheader,
  client: FhirClient,
  handle_response: fn(Result(r5.Messageheader, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.messageheader_to_json(resource),
    "MessageHeader",
    r5.messageheader_decoder(),
    client,
    handle_response,
  )
}

pub fn messageheader_delete(
  resource: r5.Messageheader,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MessageHeader", client, handle_response)
}

pub fn messageheader_search_bundled(
  search_for search_args: r5_sansio.SpMessageheader,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.messageheader_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn messageheader_search(
  search_for search_args: r5_sansio.SpMessageheader,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Messageheader), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.messageheader_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.messageheader
    },
  )
}

pub fn molecularsequence_create(
  resource: r5.Molecularsequence,
  client: FhirClient,
  handle_response: fn(Result(r5.Molecularsequence, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.molecularsequence_to_json(resource),
    "MolecularSequence",
    r5.molecularsequence_decoder(),
    client,
    handle_response,
  )
}

pub fn molecularsequence_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Molecularsequence, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "MolecularSequence",
    r5.molecularsequence_decoder(),
    client,
    handle_response,
  )
}

pub fn molecularsequence_update(
  resource: r5.Molecularsequence,
  client: FhirClient,
  handle_response: fn(Result(r5.Molecularsequence, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.molecularsequence_to_json(resource),
    "MolecularSequence",
    r5.molecularsequence_decoder(),
    client,
    handle_response,
  )
}

pub fn molecularsequence_delete(
  resource: r5.Molecularsequence,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "MolecularSequence", client, handle_response)
}

pub fn molecularsequence_search_bundled(
  search_for search_args: r5_sansio.SpMolecularsequence,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.molecularsequence_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn molecularsequence_search(
  search_for search_args: r5_sansio.SpMolecularsequence,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Molecularsequence), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.molecularsequence_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.molecularsequence
    },
  )
}

pub fn namingsystem_create(
  resource: r5.Namingsystem,
  client: FhirClient,
  handle_response: fn(Result(r5.Namingsystem, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.namingsystem_to_json(resource),
    "NamingSystem",
    r5.namingsystem_decoder(),
    client,
    handle_response,
  )
}

pub fn namingsystem_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Namingsystem, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "NamingSystem",
    r5.namingsystem_decoder(),
    client,
    handle_response,
  )
}

pub fn namingsystem_update(
  resource: r5.Namingsystem,
  client: FhirClient,
  handle_response: fn(Result(r5.Namingsystem, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.namingsystem_to_json(resource),
    "NamingSystem",
    r5.namingsystem_decoder(),
    client,
    handle_response,
  )
}

pub fn namingsystem_delete(
  resource: r5.Namingsystem,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "NamingSystem", client, handle_response)
}

pub fn namingsystem_search_bundled(
  search_for search_args: r5_sansio.SpNamingsystem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.namingsystem_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn namingsystem_search(
  search_for search_args: r5_sansio.SpNamingsystem,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Namingsystem), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.namingsystem_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.namingsystem
    },
  )
}

pub fn nutritionintake_create(
  resource: r5.Nutritionintake,
  client: FhirClient,
  handle_response: fn(Result(r5.Nutritionintake, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.nutritionintake_to_json(resource),
    "NutritionIntake",
    r5.nutritionintake_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionintake_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Nutritionintake, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "NutritionIntake",
    r5.nutritionintake_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionintake_update(
  resource: r5.Nutritionintake,
  client: FhirClient,
  handle_response: fn(Result(r5.Nutritionintake, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.nutritionintake_to_json(resource),
    "NutritionIntake",
    r5.nutritionintake_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionintake_delete(
  resource: r5.Nutritionintake,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "NutritionIntake", client, handle_response)
}

pub fn nutritionintake_search_bundled(
  search_for search_args: r5_sansio.SpNutritionintake,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.nutritionintake_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn nutritionintake_search(
  search_for search_args: r5_sansio.SpNutritionintake,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Nutritionintake), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.nutritionintake_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.nutritionintake
    },
  )
}

pub fn nutritionorder_create(
  resource: r5.Nutritionorder,
  client: FhirClient,
  handle_response: fn(Result(r5.Nutritionorder, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.nutritionorder_to_json(resource),
    "NutritionOrder",
    r5.nutritionorder_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionorder_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Nutritionorder, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "NutritionOrder",
    r5.nutritionorder_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionorder_update(
  resource: r5.Nutritionorder,
  client: FhirClient,
  handle_response: fn(Result(r5.Nutritionorder, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.nutritionorder_to_json(resource),
    "NutritionOrder",
    r5.nutritionorder_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionorder_delete(
  resource: r5.Nutritionorder,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "NutritionOrder", client, handle_response)
}

pub fn nutritionorder_search_bundled(
  search_for search_args: r5_sansio.SpNutritionorder,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.nutritionorder_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn nutritionorder_search(
  search_for search_args: r5_sansio.SpNutritionorder,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Nutritionorder), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.nutritionorder_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.nutritionorder
    },
  )
}

pub fn nutritionproduct_create(
  resource: r5.Nutritionproduct,
  client: FhirClient,
  handle_response: fn(Result(r5.Nutritionproduct, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.nutritionproduct_to_json(resource),
    "NutritionProduct",
    r5.nutritionproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionproduct_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Nutritionproduct, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "NutritionProduct",
    r5.nutritionproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionproduct_update(
  resource: r5.Nutritionproduct,
  client: FhirClient,
  handle_response: fn(Result(r5.Nutritionproduct, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.nutritionproduct_to_json(resource),
    "NutritionProduct",
    r5.nutritionproduct_decoder(),
    client,
    handle_response,
  )
}

pub fn nutritionproduct_delete(
  resource: r5.Nutritionproduct,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "NutritionProduct", client, handle_response)
}

pub fn nutritionproduct_search_bundled(
  search_for search_args: r5_sansio.SpNutritionproduct,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.nutritionproduct_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn nutritionproduct_search(
  search_for search_args: r5_sansio.SpNutritionproduct,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Nutritionproduct), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.nutritionproduct_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.nutritionproduct
    },
  )
}

pub fn observation_create(
  resource: r5.Observation,
  client: FhirClient,
  handle_response: fn(Result(r5.Observation, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.observation_to_json(resource),
    "Observation",
    r5.observation_decoder(),
    client,
    handle_response,
  )
}

pub fn observation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Observation, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Observation", r5.observation_decoder(), client, handle_response)
}

pub fn observation_update(
  resource: r5.Observation,
  client: FhirClient,
  handle_response: fn(Result(r5.Observation, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.observation_to_json(resource),
    "Observation",
    r5.observation_decoder(),
    client,
    handle_response,
  )
}

pub fn observation_delete(
  resource: r5.Observation,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Observation", client, handle_response)
}

pub fn observation_search_bundled(
  search_for search_args: r5_sansio.SpObservation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.observation_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn observation_search(
  search_for search_args: r5_sansio.SpObservation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Observation), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.observation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.observation
    },
  )
}

pub fn observationdefinition_create(
  resource: r5.Observationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Observationdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.observationdefinition_to_json(resource),
    "ObservationDefinition",
    r5.observationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn observationdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Observationdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ObservationDefinition",
    r5.observationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn observationdefinition_update(
  resource: r5.Observationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Observationdefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.observationdefinition_to_json(resource),
    "ObservationDefinition",
    r5.observationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn observationdefinition_delete(
  resource: r5.Observationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ObservationDefinition", client, handle_response)
}

pub fn observationdefinition_search_bundled(
  search_for search_args: r5_sansio.SpObservationdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.observationdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn observationdefinition_search(
  search_for search_args: r5_sansio.SpObservationdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r5.Observationdefinition), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.observationdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.observationdefinition
    },
  )
}

pub fn operationdefinition_create(
  resource: r5.Operationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.operationdefinition_to_json(resource),
    "OperationDefinition",
    r5.operationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn operationdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "OperationDefinition",
    r5.operationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn operationdefinition_update(
  resource: r5.Operationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationdefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.operationdefinition_to_json(resource),
    "OperationDefinition",
    r5.operationdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn operationdefinition_delete(
  resource: r5.Operationdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "OperationDefinition", client, handle_response)
}

pub fn operationdefinition_search_bundled(
  search_for search_args: r5_sansio.SpOperationdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.operationdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn operationdefinition_search(
  search_for search_args: r5_sansio.SpOperationdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Operationdefinition), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.operationdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.operationdefinition
    },
  )
}

pub fn operationoutcome_create(
  resource: r5.Operationoutcome,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.operationoutcome_to_json(resource),
    "OperationOutcome",
    r5.operationoutcome_decoder(),
    client,
    handle_response,
  )
}

pub fn operationoutcome_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "OperationOutcome",
    r5.operationoutcome_decoder(),
    client,
    handle_response,
  )
}

pub fn operationoutcome_update(
  resource: r5.Operationoutcome,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.operationoutcome_to_json(resource),
    "OperationOutcome",
    r5.operationoutcome_decoder(),
    client,
    handle_response,
  )
}

pub fn operationoutcome_delete(
  resource: r5.Operationoutcome,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "OperationOutcome", client, handle_response)
}

pub fn operationoutcome_search_bundled(
  search_for search_args: r5_sansio.SpOperationoutcome,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.operationoutcome_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn operationoutcome_search(
  search_for search_args: r5_sansio.SpOperationoutcome,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Operationoutcome), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.operationoutcome_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.operationoutcome
    },
  )
}

pub fn organization_create(
  resource: r5.Organization,
  client: FhirClient,
  handle_response: fn(Result(r5.Organization, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.organization_to_json(resource),
    "Organization",
    r5.organization_decoder(),
    client,
    handle_response,
  )
}

pub fn organization_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Organization, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Organization",
    r5.organization_decoder(),
    client,
    handle_response,
  )
}

pub fn organization_update(
  resource: r5.Organization,
  client: FhirClient,
  handle_response: fn(Result(r5.Organization, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.organization_to_json(resource),
    "Organization",
    r5.organization_decoder(),
    client,
    handle_response,
  )
}

pub fn organization_delete(
  resource: r5.Organization,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Organization", client, handle_response)
}

pub fn organization_search_bundled(
  search_for search_args: r5_sansio.SpOrganization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.organization_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn organization_search(
  search_for search_args: r5_sansio.SpOrganization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Organization), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.organization_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.organization
    },
  )
}

pub fn organizationaffiliation_create(
  resource: r5.Organizationaffiliation,
  client: FhirClient,
  handle_response: fn(Result(r5.Organizationaffiliation, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.organizationaffiliation_to_json(resource),
    "OrganizationAffiliation",
    r5.organizationaffiliation_decoder(),
    client,
    handle_response,
  )
}

pub fn organizationaffiliation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Organizationaffiliation, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "OrganizationAffiliation",
    r5.organizationaffiliation_decoder(),
    client,
    handle_response,
  )
}

pub fn organizationaffiliation_update(
  resource: r5.Organizationaffiliation,
  client: FhirClient,
  handle_response: fn(Result(r5.Organizationaffiliation, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.organizationaffiliation_to_json(resource),
    "OrganizationAffiliation",
    r5.organizationaffiliation_decoder(),
    client,
    handle_response,
  )
}

pub fn organizationaffiliation_delete(
  resource: r5.Organizationaffiliation,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "OrganizationAffiliation", client, handle_response)
}

pub fn organizationaffiliation_search_bundled(
  search_for search_args: r5_sansio.SpOrganizationaffiliation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.organizationaffiliation_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn organizationaffiliation_search(
  search_for search_args: r5_sansio.SpOrganizationaffiliation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r5.Organizationaffiliation), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.organizationaffiliation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.organizationaffiliation
    },
  )
}

pub fn packagedproductdefinition_create(
  resource: r5.Packagedproductdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Packagedproductdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.packagedproductdefinition_to_json(resource),
    "PackagedProductDefinition",
    r5.packagedproductdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn packagedproductdefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Packagedproductdefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "PackagedProductDefinition",
    r5.packagedproductdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn packagedproductdefinition_update(
  resource: r5.Packagedproductdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Packagedproductdefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.packagedproductdefinition_to_json(resource),
    "PackagedProductDefinition",
    r5.packagedproductdefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn packagedproductdefinition_delete(
  resource: r5.Packagedproductdefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "PackagedProductDefinition", client, handle_response)
}

pub fn packagedproductdefinition_search_bundled(
  search_for search_args: r5_sansio.SpPackagedproductdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.packagedproductdefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn packagedproductdefinition_search(
  search_for search_args: r5_sansio.SpPackagedproductdefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r5.Packagedproductdefinition), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.packagedproductdefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.packagedproductdefinition
    },
  )
}

pub fn patient_create(
  resource: r5.Patient,
  client: FhirClient,
  handle_response: fn(Result(r5.Patient, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.patient_to_json(resource),
    "Patient",
    r5.patient_decoder(),
    client,
    handle_response,
  )
}

pub fn patient_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Patient, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Patient", r5.patient_decoder(), client, handle_response)
}

pub fn patient_update(
  resource: r5.Patient,
  client: FhirClient,
  handle_response: fn(Result(r5.Patient, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.patient_to_json(resource),
    "Patient",
    r5.patient_decoder(),
    client,
    handle_response,
  )
}

pub fn patient_delete(
  resource: r5.Patient,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Patient", client, handle_response)
}

pub fn patient_search_bundled(
  search_for search_args: r5_sansio.SpPatient,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.patient_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn patient_search(
  search_for search_args: r5_sansio.SpPatient,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Patient), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.patient_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.patient },
  )
}

pub fn paymentnotice_create(
  resource: r5.Paymentnotice,
  client: FhirClient,
  handle_response: fn(Result(r5.Paymentnotice, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.paymentnotice_to_json(resource),
    "PaymentNotice",
    r5.paymentnotice_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentnotice_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Paymentnotice, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "PaymentNotice",
    r5.paymentnotice_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentnotice_update(
  resource: r5.Paymentnotice,
  client: FhirClient,
  handle_response: fn(Result(r5.Paymentnotice, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.paymentnotice_to_json(resource),
    "PaymentNotice",
    r5.paymentnotice_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentnotice_delete(
  resource: r5.Paymentnotice,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "PaymentNotice", client, handle_response)
}

pub fn paymentnotice_search_bundled(
  search_for search_args: r5_sansio.SpPaymentnotice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.paymentnotice_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn paymentnotice_search(
  search_for search_args: r5_sansio.SpPaymentnotice,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Paymentnotice), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.paymentnotice_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.paymentnotice
    },
  )
}

pub fn paymentreconciliation_create(
  resource: r5.Paymentreconciliation,
  client: FhirClient,
  handle_response: fn(Result(r5.Paymentreconciliation, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.paymentreconciliation_to_json(resource),
    "PaymentReconciliation",
    r5.paymentreconciliation_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentreconciliation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Paymentreconciliation, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "PaymentReconciliation",
    r5.paymentreconciliation_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentreconciliation_update(
  resource: r5.Paymentreconciliation,
  client: FhirClient,
  handle_response: fn(Result(r5.Paymentreconciliation, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.paymentreconciliation_to_json(resource),
    "PaymentReconciliation",
    r5.paymentreconciliation_decoder(),
    client,
    handle_response,
  )
}

pub fn paymentreconciliation_delete(
  resource: r5.Paymentreconciliation,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "PaymentReconciliation", client, handle_response)
}

pub fn paymentreconciliation_search_bundled(
  search_for search_args: r5_sansio.SpPaymentreconciliation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.paymentreconciliation_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn paymentreconciliation_search(
  search_for search_args: r5_sansio.SpPaymentreconciliation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r5.Paymentreconciliation), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.paymentreconciliation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.paymentreconciliation
    },
  )
}

pub fn permission_create(
  resource: r5.Permission,
  client: FhirClient,
  handle_response: fn(Result(r5.Permission, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.permission_to_json(resource),
    "Permission",
    r5.permission_decoder(),
    client,
    handle_response,
  )
}

pub fn permission_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Permission, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Permission", r5.permission_decoder(), client, handle_response)
}

pub fn permission_update(
  resource: r5.Permission,
  client: FhirClient,
  handle_response: fn(Result(r5.Permission, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.permission_to_json(resource),
    "Permission",
    r5.permission_decoder(),
    client,
    handle_response,
  )
}

pub fn permission_delete(
  resource: r5.Permission,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Permission", client, handle_response)
}

pub fn permission_search_bundled(
  search_for search_args: r5_sansio.SpPermission,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.permission_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn permission_search(
  search_for search_args: r5_sansio.SpPermission,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Permission), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.permission_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.permission },
  )
}

pub fn person_create(
  resource: r5.Person,
  client: FhirClient,
  handle_response: fn(Result(r5.Person, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.person_to_json(resource),
    "Person",
    r5.person_decoder(),
    client,
    handle_response,
  )
}

pub fn person_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Person, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Person", r5.person_decoder(), client, handle_response)
}

pub fn person_update(
  resource: r5.Person,
  client: FhirClient,
  handle_response: fn(Result(r5.Person, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.person_to_json(resource),
    "Person",
    r5.person_decoder(),
    client,
    handle_response,
  )
}

pub fn person_delete(
  resource: r5.Person,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Person", client, handle_response)
}

pub fn person_search_bundled(
  search_for search_args: r5_sansio.SpPerson,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.person_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn person_search(
  search_for search_args: r5_sansio.SpPerson,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Person), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.person_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.person },
  )
}

pub fn plandefinition_create(
  resource: r5.Plandefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Plandefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.plandefinition_to_json(resource),
    "PlanDefinition",
    r5.plandefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn plandefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Plandefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "PlanDefinition",
    r5.plandefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn plandefinition_update(
  resource: r5.Plandefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Plandefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.plandefinition_to_json(resource),
    "PlanDefinition",
    r5.plandefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn plandefinition_delete(
  resource: r5.Plandefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "PlanDefinition", client, handle_response)
}

pub fn plandefinition_search_bundled(
  search_for search_args: r5_sansio.SpPlandefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.plandefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn plandefinition_search(
  search_for search_args: r5_sansio.SpPlandefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Plandefinition), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.plandefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.plandefinition
    },
  )
}

pub fn practitioner_create(
  resource: r5.Practitioner,
  client: FhirClient,
  handle_response: fn(Result(r5.Practitioner, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.practitioner_to_json(resource),
    "Practitioner",
    r5.practitioner_decoder(),
    client,
    handle_response,
  )
}

pub fn practitioner_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Practitioner, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Practitioner",
    r5.practitioner_decoder(),
    client,
    handle_response,
  )
}

pub fn practitioner_update(
  resource: r5.Practitioner,
  client: FhirClient,
  handle_response: fn(Result(r5.Practitioner, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.practitioner_to_json(resource),
    "Practitioner",
    r5.practitioner_decoder(),
    client,
    handle_response,
  )
}

pub fn practitioner_delete(
  resource: r5.Practitioner,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Practitioner", client, handle_response)
}

pub fn practitioner_search_bundled(
  search_for search_args: r5_sansio.SpPractitioner,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.practitioner_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn practitioner_search(
  search_for search_args: r5_sansio.SpPractitioner,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Practitioner), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.practitioner_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.practitioner
    },
  )
}

pub fn practitionerrole_create(
  resource: r5.Practitionerrole,
  client: FhirClient,
  handle_response: fn(Result(r5.Practitionerrole, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.practitionerrole_to_json(resource),
    "PractitionerRole",
    r5.practitionerrole_decoder(),
    client,
    handle_response,
  )
}

pub fn practitionerrole_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Practitionerrole, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "PractitionerRole",
    r5.practitionerrole_decoder(),
    client,
    handle_response,
  )
}

pub fn practitionerrole_update(
  resource: r5.Practitionerrole,
  client: FhirClient,
  handle_response: fn(Result(r5.Practitionerrole, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.practitionerrole_to_json(resource),
    "PractitionerRole",
    r5.practitionerrole_decoder(),
    client,
    handle_response,
  )
}

pub fn practitionerrole_delete(
  resource: r5.Practitionerrole,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "PractitionerRole", client, handle_response)
}

pub fn practitionerrole_search_bundled(
  search_for search_args: r5_sansio.SpPractitionerrole,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.practitionerrole_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn practitionerrole_search(
  search_for search_args: r5_sansio.SpPractitionerrole,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Practitionerrole), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.practitionerrole_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.practitionerrole
    },
  )
}

pub fn procedure_create(
  resource: r5.Procedure,
  client: FhirClient,
  handle_response: fn(Result(r5.Procedure, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.procedure_to_json(resource),
    "Procedure",
    r5.procedure_decoder(),
    client,
    handle_response,
  )
}

pub fn procedure_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Procedure, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Procedure", r5.procedure_decoder(), client, handle_response)
}

pub fn procedure_update(
  resource: r5.Procedure,
  client: FhirClient,
  handle_response: fn(Result(r5.Procedure, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.procedure_to_json(resource),
    "Procedure",
    r5.procedure_decoder(),
    client,
    handle_response,
  )
}

pub fn procedure_delete(
  resource: r5.Procedure,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Procedure", client, handle_response)
}

pub fn procedure_search_bundled(
  search_for search_args: r5_sansio.SpProcedure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.procedure_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn procedure_search(
  search_for search_args: r5_sansio.SpProcedure,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Procedure), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.procedure_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.procedure },
  )
}

pub fn provenance_create(
  resource: r5.Provenance,
  client: FhirClient,
  handle_response: fn(Result(r5.Provenance, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.provenance_to_json(resource),
    "Provenance",
    r5.provenance_decoder(),
    client,
    handle_response,
  )
}

pub fn provenance_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Provenance, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Provenance", r5.provenance_decoder(), client, handle_response)
}

pub fn provenance_update(
  resource: r5.Provenance,
  client: FhirClient,
  handle_response: fn(Result(r5.Provenance, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.provenance_to_json(resource),
    "Provenance",
    r5.provenance_decoder(),
    client,
    handle_response,
  )
}

pub fn provenance_delete(
  resource: r5.Provenance,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Provenance", client, handle_response)
}

pub fn provenance_search_bundled(
  search_for search_args: r5_sansio.SpProvenance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.provenance_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn provenance_search(
  search_for search_args: r5_sansio.SpProvenance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Provenance), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.provenance_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.provenance },
  )
}

pub fn questionnaire_create(
  resource: r5.Questionnaire,
  client: FhirClient,
  handle_response: fn(Result(r5.Questionnaire, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.questionnaire_to_json(resource),
    "Questionnaire",
    r5.questionnaire_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaire_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Questionnaire, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Questionnaire",
    r5.questionnaire_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaire_update(
  resource: r5.Questionnaire,
  client: FhirClient,
  handle_response: fn(Result(r5.Questionnaire, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.questionnaire_to_json(resource),
    "Questionnaire",
    r5.questionnaire_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaire_delete(
  resource: r5.Questionnaire,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Questionnaire", client, handle_response)
}

pub fn questionnaire_search_bundled(
  search_for search_args: r5_sansio.SpQuestionnaire,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.questionnaire_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn questionnaire_search(
  search_for search_args: r5_sansio.SpQuestionnaire,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Questionnaire), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.questionnaire_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.questionnaire
    },
  )
}

pub fn questionnaireresponse_create(
  resource: r5.Questionnaireresponse,
  client: FhirClient,
  handle_response: fn(Result(r5.Questionnaireresponse, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    r5.questionnaireresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaireresponse_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Questionnaireresponse, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "QuestionnaireResponse",
    r5.questionnaireresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaireresponse_update(
  resource: r5.Questionnaireresponse,
  client: FhirClient,
  handle_response: fn(Result(r5.Questionnaireresponse, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    r5.questionnaireresponse_decoder(),
    client,
    handle_response,
  )
}

pub fn questionnaireresponse_delete(
  resource: r5.Questionnaireresponse,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "QuestionnaireResponse", client, handle_response)
}

pub fn questionnaireresponse_search_bundled(
  search_for search_args: r5_sansio.SpQuestionnaireresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.questionnaireresponse_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn questionnaireresponse_search(
  search_for search_args: r5_sansio.SpQuestionnaireresponse,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r5.Questionnaireresponse), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.questionnaireresponse_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.questionnaireresponse
    },
  )
}

pub fn regulatedauthorization_create(
  resource: r5.Regulatedauthorization,
  client: FhirClient,
  handle_response: fn(Result(r5.Regulatedauthorization, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.regulatedauthorization_to_json(resource),
    "RegulatedAuthorization",
    r5.regulatedauthorization_decoder(),
    client,
    handle_response,
  )
}

pub fn regulatedauthorization_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Regulatedauthorization, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "RegulatedAuthorization",
    r5.regulatedauthorization_decoder(),
    client,
    handle_response,
  )
}

pub fn regulatedauthorization_update(
  resource: r5.Regulatedauthorization,
  client: FhirClient,
  handle_response: fn(Result(r5.Regulatedauthorization, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.regulatedauthorization_to_json(resource),
    "RegulatedAuthorization",
    r5.regulatedauthorization_decoder(),
    client,
    handle_response,
  )
}

pub fn regulatedauthorization_delete(
  resource: r5.Regulatedauthorization,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "RegulatedAuthorization", client, handle_response)
}

pub fn regulatedauthorization_search_bundled(
  search_for search_args: r5_sansio.SpRegulatedauthorization,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.regulatedauthorization_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn regulatedauthorization_search(
  search_for search_args: r5_sansio.SpRegulatedauthorization,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r5.Regulatedauthorization), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.regulatedauthorization_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.regulatedauthorization
    },
  )
}

pub fn relatedperson_create(
  resource: r5.Relatedperson,
  client: FhirClient,
  handle_response: fn(Result(r5.Relatedperson, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.relatedperson_to_json(resource),
    "RelatedPerson",
    r5.relatedperson_decoder(),
    client,
    handle_response,
  )
}

pub fn relatedperson_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Relatedperson, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "RelatedPerson",
    r5.relatedperson_decoder(),
    client,
    handle_response,
  )
}

pub fn relatedperson_update(
  resource: r5.Relatedperson,
  client: FhirClient,
  handle_response: fn(Result(r5.Relatedperson, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.relatedperson_to_json(resource),
    "RelatedPerson",
    r5.relatedperson_decoder(),
    client,
    handle_response,
  )
}

pub fn relatedperson_delete(
  resource: r5.Relatedperson,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "RelatedPerson", client, handle_response)
}

pub fn relatedperson_search_bundled(
  search_for search_args: r5_sansio.SpRelatedperson,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.relatedperson_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn relatedperson_search(
  search_for search_args: r5_sansio.SpRelatedperson,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Relatedperson), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.relatedperson_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.relatedperson
    },
  )
}

pub fn requestorchestration_create(
  resource: r5.Requestorchestration,
  client: FhirClient,
  handle_response: fn(Result(r5.Requestorchestration, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.requestorchestration_to_json(resource),
    "RequestOrchestration",
    r5.requestorchestration_decoder(),
    client,
    handle_response,
  )
}

pub fn requestorchestration_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Requestorchestration, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "RequestOrchestration",
    r5.requestorchestration_decoder(),
    client,
    handle_response,
  )
}

pub fn requestorchestration_update(
  resource: r5.Requestorchestration,
  client: FhirClient,
  handle_response: fn(Result(r5.Requestorchestration, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.requestorchestration_to_json(resource),
    "RequestOrchestration",
    r5.requestorchestration_decoder(),
    client,
    handle_response,
  )
}

pub fn requestorchestration_delete(
  resource: r5.Requestorchestration,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "RequestOrchestration", client, handle_response)
}

pub fn requestorchestration_search_bundled(
  search_for search_args: r5_sansio.SpRequestorchestration,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.requestorchestration_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn requestorchestration_search(
  search_for search_args: r5_sansio.SpRequestorchestration,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r5.Requestorchestration), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.requestorchestration_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.requestorchestration
    },
  )
}

pub fn requirements_create(
  resource: r5.Requirements,
  client: FhirClient,
  handle_response: fn(Result(r5.Requirements, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.requirements_to_json(resource),
    "Requirements",
    r5.requirements_decoder(),
    client,
    handle_response,
  )
}

pub fn requirements_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Requirements, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Requirements",
    r5.requirements_decoder(),
    client,
    handle_response,
  )
}

pub fn requirements_update(
  resource: r5.Requirements,
  client: FhirClient,
  handle_response: fn(Result(r5.Requirements, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.requirements_to_json(resource),
    "Requirements",
    r5.requirements_decoder(),
    client,
    handle_response,
  )
}

pub fn requirements_delete(
  resource: r5.Requirements,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Requirements", client, handle_response)
}

pub fn requirements_search_bundled(
  search_for search_args: r5_sansio.SpRequirements,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.requirements_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn requirements_search(
  search_for search_args: r5_sansio.SpRequirements,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Requirements), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.requirements_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.requirements
    },
  )
}

pub fn researchstudy_create(
  resource: r5.Researchstudy,
  client: FhirClient,
  handle_response: fn(Result(r5.Researchstudy, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.researchstudy_to_json(resource),
    "ResearchStudy",
    r5.researchstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn researchstudy_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Researchstudy, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ResearchStudy",
    r5.researchstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn researchstudy_update(
  resource: r5.Researchstudy,
  client: FhirClient,
  handle_response: fn(Result(r5.Researchstudy, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.researchstudy_to_json(resource),
    "ResearchStudy",
    r5.researchstudy_decoder(),
    client,
    handle_response,
  )
}

pub fn researchstudy_delete(
  resource: r5.Researchstudy,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ResearchStudy", client, handle_response)
}

pub fn researchstudy_search_bundled(
  search_for search_args: r5_sansio.SpResearchstudy,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.researchstudy_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn researchstudy_search(
  search_for search_args: r5_sansio.SpResearchstudy,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Researchstudy), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.researchstudy_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.researchstudy
    },
  )
}

pub fn researchsubject_create(
  resource: r5.Researchsubject,
  client: FhirClient,
  handle_response: fn(Result(r5.Researchsubject, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.researchsubject_to_json(resource),
    "ResearchSubject",
    r5.researchsubject_decoder(),
    client,
    handle_response,
  )
}

pub fn researchsubject_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Researchsubject, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ResearchSubject",
    r5.researchsubject_decoder(),
    client,
    handle_response,
  )
}

pub fn researchsubject_update(
  resource: r5.Researchsubject,
  client: FhirClient,
  handle_response: fn(Result(r5.Researchsubject, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.researchsubject_to_json(resource),
    "ResearchSubject",
    r5.researchsubject_decoder(),
    client,
    handle_response,
  )
}

pub fn researchsubject_delete(
  resource: r5.Researchsubject,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ResearchSubject", client, handle_response)
}

pub fn researchsubject_search_bundled(
  search_for search_args: r5_sansio.SpResearchsubject,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.researchsubject_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn researchsubject_search(
  search_for search_args: r5_sansio.SpResearchsubject,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Researchsubject), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.researchsubject_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.researchsubject
    },
  )
}

pub fn riskassessment_create(
  resource: r5.Riskassessment,
  client: FhirClient,
  handle_response: fn(Result(r5.Riskassessment, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.riskassessment_to_json(resource),
    "RiskAssessment",
    r5.riskassessment_decoder(),
    client,
    handle_response,
  )
}

pub fn riskassessment_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Riskassessment, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "RiskAssessment",
    r5.riskassessment_decoder(),
    client,
    handle_response,
  )
}

pub fn riskassessment_update(
  resource: r5.Riskassessment,
  client: FhirClient,
  handle_response: fn(Result(r5.Riskassessment, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.riskassessment_to_json(resource),
    "RiskAssessment",
    r5.riskassessment_decoder(),
    client,
    handle_response,
  )
}

pub fn riskassessment_delete(
  resource: r5.Riskassessment,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "RiskAssessment", client, handle_response)
}

pub fn riskassessment_search_bundled(
  search_for search_args: r5_sansio.SpRiskassessment,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.riskassessment_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn riskassessment_search(
  search_for search_args: r5_sansio.SpRiskassessment,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Riskassessment), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.riskassessment_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.riskassessment
    },
  )
}

pub fn schedule_create(
  resource: r5.Schedule,
  client: FhirClient,
  handle_response: fn(Result(r5.Schedule, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.schedule_to_json(resource),
    "Schedule",
    r5.schedule_decoder(),
    client,
    handle_response,
  )
}

pub fn schedule_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Schedule, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Schedule", r5.schedule_decoder(), client, handle_response)
}

pub fn schedule_update(
  resource: r5.Schedule,
  client: FhirClient,
  handle_response: fn(Result(r5.Schedule, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.schedule_to_json(resource),
    "Schedule",
    r5.schedule_decoder(),
    client,
    handle_response,
  )
}

pub fn schedule_delete(
  resource: r5.Schedule,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Schedule", client, handle_response)
}

pub fn schedule_search_bundled(
  search_for search_args: r5_sansio.SpSchedule,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.schedule_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn schedule_search(
  search_for search_args: r5_sansio.SpSchedule,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Schedule), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.schedule_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.schedule },
  )
}

pub fn searchparameter_create(
  resource: r5.Searchparameter,
  client: FhirClient,
  handle_response: fn(Result(r5.Searchparameter, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.searchparameter_to_json(resource),
    "SearchParameter",
    r5.searchparameter_decoder(),
    client,
    handle_response,
  )
}

pub fn searchparameter_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Searchparameter, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SearchParameter",
    r5.searchparameter_decoder(),
    client,
    handle_response,
  )
}

pub fn searchparameter_update(
  resource: r5.Searchparameter,
  client: FhirClient,
  handle_response: fn(Result(r5.Searchparameter, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.searchparameter_to_json(resource),
    "SearchParameter",
    r5.searchparameter_decoder(),
    client,
    handle_response,
  )
}

pub fn searchparameter_delete(
  resource: r5.Searchparameter,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SearchParameter", client, handle_response)
}

pub fn searchparameter_search_bundled(
  search_for search_args: r5_sansio.SpSearchparameter,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.searchparameter_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn searchparameter_search(
  search_for search_args: r5_sansio.SpSearchparameter,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Searchparameter), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.searchparameter_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.searchparameter
    },
  )
}

pub fn servicerequest_create(
  resource: r5.Servicerequest,
  client: FhirClient,
  handle_response: fn(Result(r5.Servicerequest, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.servicerequest_to_json(resource),
    "ServiceRequest",
    r5.servicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn servicerequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Servicerequest, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "ServiceRequest",
    r5.servicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn servicerequest_update(
  resource: r5.Servicerequest,
  client: FhirClient,
  handle_response: fn(Result(r5.Servicerequest, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.servicerequest_to_json(resource),
    "ServiceRequest",
    r5.servicerequest_decoder(),
    client,
    handle_response,
  )
}

pub fn servicerequest_delete(
  resource: r5.Servicerequest,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ServiceRequest", client, handle_response)
}

pub fn servicerequest_search_bundled(
  search_for search_args: r5_sansio.SpServicerequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.servicerequest_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn servicerequest_search(
  search_for search_args: r5_sansio.SpServicerequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Servicerequest), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.servicerequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.servicerequest
    },
  )
}

pub fn slot_create(
  resource: r5.Slot,
  client: FhirClient,
  handle_response: fn(Result(r5.Slot, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.slot_to_json(resource),
    "Slot",
    r5.slot_decoder(),
    client,
    handle_response,
  )
}

pub fn slot_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Slot, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Slot", r5.slot_decoder(), client, handle_response)
}

pub fn slot_update(
  resource: r5.Slot,
  client: FhirClient,
  handle_response: fn(Result(r5.Slot, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.slot_to_json(resource),
    "Slot",
    r5.slot_decoder(),
    client,
    handle_response,
  )
}

pub fn slot_delete(
  resource: r5.Slot,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Slot", client, handle_response)
}

pub fn slot_search_bundled(
  search_for search_args: r5_sansio.SpSlot,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.slot_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn slot_search(
  search_for search_args: r5_sansio.SpSlot,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Slot), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.slot_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.slot },
  )
}

pub fn specimen_create(
  resource: r5.Specimen,
  client: FhirClient,
  handle_response: fn(Result(r5.Specimen, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.specimen_to_json(resource),
    "Specimen",
    r5.specimen_decoder(),
    client,
    handle_response,
  )
}

pub fn specimen_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Specimen, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Specimen", r5.specimen_decoder(), client, handle_response)
}

pub fn specimen_update(
  resource: r5.Specimen,
  client: FhirClient,
  handle_response: fn(Result(r5.Specimen, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.specimen_to_json(resource),
    "Specimen",
    r5.specimen_decoder(),
    client,
    handle_response,
  )
}

pub fn specimen_delete(
  resource: r5.Specimen,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Specimen", client, handle_response)
}

pub fn specimen_search_bundled(
  search_for search_args: r5_sansio.SpSpecimen,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.specimen_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn specimen_search(
  search_for search_args: r5_sansio.SpSpecimen,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Specimen), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.specimen_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.specimen },
  )
}

pub fn specimendefinition_create(
  resource: r5.Specimendefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Specimendefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.specimendefinition_to_json(resource),
    "SpecimenDefinition",
    r5.specimendefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn specimendefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Specimendefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SpecimenDefinition",
    r5.specimendefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn specimendefinition_update(
  resource: r5.Specimendefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Specimendefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.specimendefinition_to_json(resource),
    "SpecimenDefinition",
    r5.specimendefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn specimendefinition_delete(
  resource: r5.Specimendefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SpecimenDefinition", client, handle_response)
}

pub fn specimendefinition_search_bundled(
  search_for search_args: r5_sansio.SpSpecimendefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.specimendefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn specimendefinition_search(
  search_for search_args: r5_sansio.SpSpecimendefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Specimendefinition), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.specimendefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.specimendefinition
    },
  )
}

pub fn structuredefinition_create(
  resource: r5.Structuredefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Structuredefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.structuredefinition_to_json(resource),
    "StructureDefinition",
    r5.structuredefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn structuredefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Structuredefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "StructureDefinition",
    r5.structuredefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn structuredefinition_update(
  resource: r5.Structuredefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Structuredefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.structuredefinition_to_json(resource),
    "StructureDefinition",
    r5.structuredefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn structuredefinition_delete(
  resource: r5.Structuredefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "StructureDefinition", client, handle_response)
}

pub fn structuredefinition_search_bundled(
  search_for search_args: r5_sansio.SpStructuredefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.structuredefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn structuredefinition_search(
  search_for search_args: r5_sansio.SpStructuredefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Structuredefinition), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.structuredefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.structuredefinition
    },
  )
}

pub fn structuremap_create(
  resource: r5.Structuremap,
  client: FhirClient,
  handle_response: fn(Result(r5.Structuremap, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.structuremap_to_json(resource),
    "StructureMap",
    r5.structuremap_decoder(),
    client,
    handle_response,
  )
}

pub fn structuremap_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Structuremap, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "StructureMap",
    r5.structuremap_decoder(),
    client,
    handle_response,
  )
}

pub fn structuremap_update(
  resource: r5.Structuremap,
  client: FhirClient,
  handle_response: fn(Result(r5.Structuremap, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.structuremap_to_json(resource),
    "StructureMap",
    r5.structuremap_decoder(),
    client,
    handle_response,
  )
}

pub fn structuremap_delete(
  resource: r5.Structuremap,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "StructureMap", client, handle_response)
}

pub fn structuremap_search_bundled(
  search_for search_args: r5_sansio.SpStructuremap,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.structuremap_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn structuremap_search(
  search_for search_args: r5_sansio.SpStructuremap,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Structuremap), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.structuremap_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.structuremap
    },
  )
}

pub fn subscription_create(
  resource: r5.Subscription,
  client: FhirClient,
  handle_response: fn(Result(r5.Subscription, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.subscription_to_json(resource),
    "Subscription",
    r5.subscription_decoder(),
    client,
    handle_response,
  )
}

pub fn subscription_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Subscription, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "Subscription",
    r5.subscription_decoder(),
    client,
    handle_response,
  )
}

pub fn subscription_update(
  resource: r5.Subscription,
  client: FhirClient,
  handle_response: fn(Result(r5.Subscription, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.subscription_to_json(resource),
    "Subscription",
    r5.subscription_decoder(),
    client,
    handle_response,
  )
}

pub fn subscription_delete(
  resource: r5.Subscription,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Subscription", client, handle_response)
}

pub fn subscription_search_bundled(
  search_for search_args: r5_sansio.SpSubscription,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.subscription_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn subscription_search(
  search_for search_args: r5_sansio.SpSubscription,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Subscription), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.subscription_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.subscription
    },
  )
}

pub fn subscriptionstatus_create(
  resource: r5.Subscriptionstatus,
  client: FhirClient,
  handle_response: fn(Result(r5.Subscriptionstatus, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.subscriptionstatus_to_json(resource),
    "SubscriptionStatus",
    r5.subscriptionstatus_decoder(),
    client,
    handle_response,
  )
}

pub fn subscriptionstatus_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Subscriptionstatus, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubscriptionStatus",
    r5.subscriptionstatus_decoder(),
    client,
    handle_response,
  )
}

pub fn subscriptionstatus_update(
  resource: r5.Subscriptionstatus,
  client: FhirClient,
  handle_response: fn(Result(r5.Subscriptionstatus, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.subscriptionstatus_to_json(resource),
    "SubscriptionStatus",
    r5.subscriptionstatus_decoder(),
    client,
    handle_response,
  )
}

pub fn subscriptionstatus_delete(
  resource: r5.Subscriptionstatus,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SubscriptionStatus", client, handle_response)
}

pub fn subscriptionstatus_search_bundled(
  search_for search_args: r5_sansio.SpSubscriptionstatus,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.subscriptionstatus_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn subscriptionstatus_search(
  search_for search_args: r5_sansio.SpSubscriptionstatus,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Subscriptionstatus), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.subscriptionstatus_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.subscriptionstatus
    },
  )
}

pub fn subscriptiontopic_create(
  resource: r5.Subscriptiontopic,
  client: FhirClient,
  handle_response: fn(Result(r5.Subscriptiontopic, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.subscriptiontopic_to_json(resource),
    "SubscriptionTopic",
    r5.subscriptiontopic_decoder(),
    client,
    handle_response,
  )
}

pub fn subscriptiontopic_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Subscriptiontopic, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubscriptionTopic",
    r5.subscriptiontopic_decoder(),
    client,
    handle_response,
  )
}

pub fn subscriptiontopic_update(
  resource: r5.Subscriptiontopic,
  client: FhirClient,
  handle_response: fn(Result(r5.Subscriptiontopic, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.subscriptiontopic_to_json(resource),
    "SubscriptionTopic",
    r5.subscriptiontopic_decoder(),
    client,
    handle_response,
  )
}

pub fn subscriptiontopic_delete(
  resource: r5.Subscriptiontopic,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SubscriptionTopic", client, handle_response)
}

pub fn subscriptiontopic_search_bundled(
  search_for search_args: r5_sansio.SpSubscriptiontopic,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.subscriptiontopic_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn subscriptiontopic_search(
  search_for search_args: r5_sansio.SpSubscriptiontopic,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Subscriptiontopic), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.subscriptiontopic_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.subscriptiontopic
    },
  )
}

pub fn substance_create(
  resource: r5.Substance,
  client: FhirClient,
  handle_response: fn(Result(r5.Substance, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.substance_to_json(resource),
    "Substance",
    r5.substance_decoder(),
    client,
    handle_response,
  )
}

pub fn substance_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Substance, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Substance", r5.substance_decoder(), client, handle_response)
}

pub fn substance_update(
  resource: r5.Substance,
  client: FhirClient,
  handle_response: fn(Result(r5.Substance, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.substance_to_json(resource),
    "Substance",
    r5.substance_decoder(),
    client,
    handle_response,
  )
}

pub fn substance_delete(
  resource: r5.Substance,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Substance", client, handle_response)
}

pub fn substance_search_bundled(
  search_for search_args: r5_sansio.SpSubstance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.substance_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn substance_search(
  search_for search_args: r5_sansio.SpSubstance,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Substance), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.substance_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.substance },
  )
}

pub fn substancedefinition_create(
  resource: r5.Substancedefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Substancedefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.substancedefinition_to_json(resource),
    "SubstanceDefinition",
    r5.substancedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn substancedefinition_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Substancedefinition, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstanceDefinition",
    r5.substancedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn substancedefinition_update(
  resource: r5.Substancedefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Substancedefinition, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.substancedefinition_to_json(resource),
    "SubstanceDefinition",
    r5.substancedefinition_decoder(),
    client,
    handle_response,
  )
}

pub fn substancedefinition_delete(
  resource: r5.Substancedefinition,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SubstanceDefinition", client, handle_response)
}

pub fn substancedefinition_search_bundled(
  search_for search_args: r5_sansio.SpSubstancedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.substancedefinition_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn substancedefinition_search(
  search_for search_args: r5_sansio.SpSubstancedefinition,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Substancedefinition), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.substancedefinition_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.substancedefinition
    },
  )
}

pub fn substancenucleicacid_create(
  resource: r5.Substancenucleicacid,
  client: FhirClient,
  handle_response: fn(Result(r5.Substancenucleicacid, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.substancenucleicacid_to_json(resource),
    "SubstanceNucleicAcid",
    r5.substancenucleicacid_decoder(),
    client,
    handle_response,
  )
}

pub fn substancenucleicacid_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Substancenucleicacid, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstanceNucleicAcid",
    r5.substancenucleicacid_decoder(),
    client,
    handle_response,
  )
}

pub fn substancenucleicacid_update(
  resource: r5.Substancenucleicacid,
  client: FhirClient,
  handle_response: fn(Result(r5.Substancenucleicacid, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.substancenucleicacid_to_json(resource),
    "SubstanceNucleicAcid",
    r5.substancenucleicacid_decoder(),
    client,
    handle_response,
  )
}

pub fn substancenucleicacid_delete(
  resource: r5.Substancenucleicacid,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SubstanceNucleicAcid", client, handle_response)
}

pub fn substancenucleicacid_search_bundled(
  search_for search_args: r5_sansio.SpSubstancenucleicacid,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.substancenucleicacid_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn substancenucleicacid_search(
  search_for search_args: r5_sansio.SpSubstancenucleicacid,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r5.Substancenucleicacid), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.substancenucleicacid_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.substancenucleicacid
    },
  )
}

pub fn substancepolymer_create(
  resource: r5.Substancepolymer,
  client: FhirClient,
  handle_response: fn(Result(r5.Substancepolymer, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.substancepolymer_to_json(resource),
    "SubstancePolymer",
    r5.substancepolymer_decoder(),
    client,
    handle_response,
  )
}

pub fn substancepolymer_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Substancepolymer, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstancePolymer",
    r5.substancepolymer_decoder(),
    client,
    handle_response,
  )
}

pub fn substancepolymer_update(
  resource: r5.Substancepolymer,
  client: FhirClient,
  handle_response: fn(Result(r5.Substancepolymer, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.substancepolymer_to_json(resource),
    "SubstancePolymer",
    r5.substancepolymer_decoder(),
    client,
    handle_response,
  )
}

pub fn substancepolymer_delete(
  resource: r5.Substancepolymer,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SubstancePolymer", client, handle_response)
}

pub fn substancepolymer_search_bundled(
  search_for search_args: r5_sansio.SpSubstancepolymer,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.substancepolymer_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn substancepolymer_search(
  search_for search_args: r5_sansio.SpSubstancepolymer,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Substancepolymer), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.substancepolymer_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.substancepolymer
    },
  )
}

pub fn substanceprotein_create(
  resource: r5.Substanceprotein,
  client: FhirClient,
  handle_response: fn(Result(r5.Substanceprotein, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.substanceprotein_to_json(resource),
    "SubstanceProtein",
    r5.substanceprotein_decoder(),
    client,
    handle_response,
  )
}

pub fn substanceprotein_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Substanceprotein, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstanceProtein",
    r5.substanceprotein_decoder(),
    client,
    handle_response,
  )
}

pub fn substanceprotein_update(
  resource: r5.Substanceprotein,
  client: FhirClient,
  handle_response: fn(Result(r5.Substanceprotein, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.substanceprotein_to_json(resource),
    "SubstanceProtein",
    r5.substanceprotein_decoder(),
    client,
    handle_response,
  )
}

pub fn substanceprotein_delete(
  resource: r5.Substanceprotein,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SubstanceProtein", client, handle_response)
}

pub fn substanceprotein_search_bundled(
  search_for search_args: r5_sansio.SpSubstanceprotein,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.substanceprotein_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn substanceprotein_search(
  search_for search_args: r5_sansio.SpSubstanceprotein,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Substanceprotein), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.substanceprotein_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.substanceprotein
    },
  )
}

pub fn substancereferenceinformation_create(
  resource: r5.Substancereferenceinformation,
  client: FhirClient,
  handle_response: fn(Result(r5.Substancereferenceinformation, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.substancereferenceinformation_to_json(resource),
    "SubstanceReferenceInformation",
    r5.substancereferenceinformation_decoder(),
    client,
    handle_response,
  )
}

pub fn substancereferenceinformation_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Substancereferenceinformation, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstanceReferenceInformation",
    r5.substancereferenceinformation_decoder(),
    client,
    handle_response,
  )
}

pub fn substancereferenceinformation_update(
  resource: r5.Substancereferenceinformation,
  client: FhirClient,
  handle_response: fn(Result(r5.Substancereferenceinformation, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.substancereferenceinformation_to_json(resource),
    "SubstanceReferenceInformation",
    r5.substancereferenceinformation_decoder(),
    client,
    handle_response,
  )
}

pub fn substancereferenceinformation_delete(
  resource: r5.Substancereferenceinformation,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(
    resource.id,
    "SubstanceReferenceInformation",
    client,
    handle_response,
  )
}

pub fn substancereferenceinformation_search_bundled(
  search_for search_args: r5_sansio.SpSubstancereferenceinformation,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req =
    r5_sansio.substancereferenceinformation_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn substancereferenceinformation_search(
  search_for search_args: r5_sansio.SpSubstancereferenceinformation,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r5.Substancereferenceinformation), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req =
    r5_sansio.substancereferenceinformation_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.substancereferenceinformation
    },
  )
}

pub fn substancesourcematerial_create(
  resource: r5.Substancesourcematerial,
  client: FhirClient,
  handle_response: fn(Result(r5.Substancesourcematerial, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.substancesourcematerial_to_json(resource),
    "SubstanceSourceMaterial",
    r5.substancesourcematerial_decoder(),
    client,
    handle_response,
  )
}

pub fn substancesourcematerial_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Substancesourcematerial, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SubstanceSourceMaterial",
    r5.substancesourcematerial_decoder(),
    client,
    handle_response,
  )
}

pub fn substancesourcematerial_update(
  resource: r5.Substancesourcematerial,
  client: FhirClient,
  handle_response: fn(Result(r5.Substancesourcematerial, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.substancesourcematerial_to_json(resource),
    "SubstanceSourceMaterial",
    r5.substancesourcematerial_decoder(),
    client,
    handle_response,
  )
}

pub fn substancesourcematerial_delete(
  resource: r5.Substancesourcematerial,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SubstanceSourceMaterial", client, handle_response)
}

pub fn substancesourcematerial_search_bundled(
  search_for search_args: r5_sansio.SpSubstancesourcematerial,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.substancesourcematerial_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn substancesourcematerial_search(
  search_for search_args: r5_sansio.SpSubstancesourcematerial,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r5.Substancesourcematerial), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.substancesourcematerial_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.substancesourcematerial
    },
  )
}

pub fn supplydelivery_create(
  resource: r5.Supplydelivery,
  client: FhirClient,
  handle_response: fn(Result(r5.Supplydelivery, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.supplydelivery_to_json(resource),
    "SupplyDelivery",
    r5.supplydelivery_decoder(),
    client,
    handle_response,
  )
}

pub fn supplydelivery_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Supplydelivery, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SupplyDelivery",
    r5.supplydelivery_decoder(),
    client,
    handle_response,
  )
}

pub fn supplydelivery_update(
  resource: r5.Supplydelivery,
  client: FhirClient,
  handle_response: fn(Result(r5.Supplydelivery, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.supplydelivery_to_json(resource),
    "SupplyDelivery",
    r5.supplydelivery_decoder(),
    client,
    handle_response,
  )
}

pub fn supplydelivery_delete(
  resource: r5.Supplydelivery,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SupplyDelivery", client, handle_response)
}

pub fn supplydelivery_search_bundled(
  search_for search_args: r5_sansio.SpSupplydelivery,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.supplydelivery_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn supplydelivery_search(
  search_for search_args: r5_sansio.SpSupplydelivery,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Supplydelivery), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.supplydelivery_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.supplydelivery
    },
  )
}

pub fn supplyrequest_create(
  resource: r5.Supplyrequest,
  client: FhirClient,
  handle_response: fn(Result(r5.Supplyrequest, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.supplyrequest_to_json(resource),
    "SupplyRequest",
    r5.supplyrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn supplyrequest_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Supplyrequest, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "SupplyRequest",
    r5.supplyrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn supplyrequest_update(
  resource: r5.Supplyrequest,
  client: FhirClient,
  handle_response: fn(Result(r5.Supplyrequest, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.supplyrequest_to_json(resource),
    "SupplyRequest",
    r5.supplyrequest_decoder(),
    client,
    handle_response,
  )
}

pub fn supplyrequest_delete(
  resource: r5.Supplyrequest,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "SupplyRequest", client, handle_response)
}

pub fn supplyrequest_search_bundled(
  search_for search_args: r5_sansio.SpSupplyrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.supplyrequest_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn supplyrequest_search(
  search_for search_args: r5_sansio.SpSupplyrequest,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Supplyrequest), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.supplyrequest_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.supplyrequest
    },
  )
}

pub fn task_create(
  resource: r5.Task,
  client: FhirClient,
  handle_response: fn(Result(r5.Task, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.task_to_json(resource),
    "Task",
    r5.task_decoder(),
    client,
    handle_response,
  )
}

pub fn task_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Task, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Task", r5.task_decoder(), client, handle_response)
}

pub fn task_update(
  resource: r5.Task,
  client: FhirClient,
  handle_response: fn(Result(r5.Task, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.task_to_json(resource),
    "Task",
    r5.task_decoder(),
    client,
    handle_response,
  )
}

pub fn task_delete(
  resource: r5.Task,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Task", client, handle_response)
}

pub fn task_search_bundled(
  search_for search_args: r5_sansio.SpTask,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.task_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn task_search(
  search_for search_args: r5_sansio.SpTask,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Task), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.task_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.task },
  )
}

pub fn terminologycapabilities_create(
  resource: r5.Terminologycapabilities,
  client: FhirClient,
  handle_response: fn(Result(r5.Terminologycapabilities, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.terminologycapabilities_to_json(resource),
    "TerminologyCapabilities",
    r5.terminologycapabilities_decoder(),
    client,
    handle_response,
  )
}

pub fn terminologycapabilities_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Terminologycapabilities, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "TerminologyCapabilities",
    r5.terminologycapabilities_decoder(),
    client,
    handle_response,
  )
}

pub fn terminologycapabilities_update(
  resource: r5.Terminologycapabilities,
  client: FhirClient,
  handle_response: fn(Result(r5.Terminologycapabilities, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.terminologycapabilities_to_json(resource),
    "TerminologyCapabilities",
    r5.terminologycapabilities_decoder(),
    client,
    handle_response,
  )
}

pub fn terminologycapabilities_delete(
  resource: r5.Terminologycapabilities,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "TerminologyCapabilities", client, handle_response)
}

pub fn terminologycapabilities_search_bundled(
  search_for search_args: r5_sansio.SpTerminologycapabilities,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.terminologycapabilities_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn terminologycapabilities_search(
  search_for search_args: r5_sansio.SpTerminologycapabilities,
  with_client client: FhirClient,
  response_msg handle_response: fn(
    Result(List(r5.Terminologycapabilities), ReqErr),
  ) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.terminologycapabilities_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.terminologycapabilities
    },
  )
}

pub fn testplan_create(
  resource: r5.Testplan,
  client: FhirClient,
  handle_response: fn(Result(r5.Testplan, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.testplan_to_json(resource),
    "TestPlan",
    r5.testplan_decoder(),
    client,
    handle_response,
  )
}

pub fn testplan_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Testplan, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "TestPlan", r5.testplan_decoder(), client, handle_response)
}

pub fn testplan_update(
  resource: r5.Testplan,
  client: FhirClient,
  handle_response: fn(Result(r5.Testplan, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.testplan_to_json(resource),
    "TestPlan",
    r5.testplan_decoder(),
    client,
    handle_response,
  )
}

pub fn testplan_delete(
  resource: r5.Testplan,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "TestPlan", client, handle_response)
}

pub fn testplan_search_bundled(
  search_for search_args: r5_sansio.SpTestplan,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.testplan_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn testplan_search(
  search_for search_args: r5_sansio.SpTestplan,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Testplan), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.testplan_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.testplan },
  )
}

pub fn testreport_create(
  resource: r5.Testreport,
  client: FhirClient,
  handle_response: fn(Result(r5.Testreport, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.testreport_to_json(resource),
    "TestReport",
    r5.testreport_decoder(),
    client,
    handle_response,
  )
}

pub fn testreport_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Testreport, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "TestReport", r5.testreport_decoder(), client, handle_response)
}

pub fn testreport_update(
  resource: r5.Testreport,
  client: FhirClient,
  handle_response: fn(Result(r5.Testreport, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.testreport_to_json(resource),
    "TestReport",
    r5.testreport_decoder(),
    client,
    handle_response,
  )
}

pub fn testreport_delete(
  resource: r5.Testreport,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "TestReport", client, handle_response)
}

pub fn testreport_search_bundled(
  search_for search_args: r5_sansio.SpTestreport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.testreport_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn testreport_search(
  search_for search_args: r5_sansio.SpTestreport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Testreport), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.testreport_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.testreport },
  )
}

pub fn testscript_create(
  resource: r5.Testscript,
  client: FhirClient,
  handle_response: fn(Result(r5.Testscript, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.testscript_to_json(resource),
    "TestScript",
    r5.testscript_decoder(),
    client,
    handle_response,
  )
}

pub fn testscript_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Testscript, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "TestScript", r5.testscript_decoder(), client, handle_response)
}

pub fn testscript_update(
  resource: r5.Testscript,
  client: FhirClient,
  handle_response: fn(Result(r5.Testscript, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.testscript_to_json(resource),
    "TestScript",
    r5.testscript_decoder(),
    client,
    handle_response,
  )
}

pub fn testscript_delete(
  resource: r5.Testscript,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "TestScript", client, handle_response)
}

pub fn testscript_search_bundled(
  search_for search_args: r5_sansio.SpTestscript,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.testscript_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn testscript_search(
  search_for search_args: r5_sansio.SpTestscript,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Testscript), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.testscript_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.testscript },
  )
}

pub fn transport_create(
  resource: r5.Transport,
  client: FhirClient,
  handle_response: fn(Result(r5.Transport, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.transport_to_json(resource),
    "Transport",
    r5.transport_decoder(),
    client,
    handle_response,
  )
}

pub fn transport_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Transport, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Transport", r5.transport_decoder(), client, handle_response)
}

pub fn transport_update(
  resource: r5.Transport,
  client: FhirClient,
  handle_response: fn(Result(r5.Transport, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.transport_to_json(resource),
    "Transport",
    r5.transport_decoder(),
    client,
    handle_response,
  )
}

pub fn transport_delete(
  resource: r5.Transport,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Transport", client, handle_response)
}

pub fn transport_search_bundled(
  search_for search_args: r5_sansio.SpTransport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.transport_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn transport_search(
  search_for search_args: r5_sansio.SpTransport,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Transport), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.transport_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.transport },
  )
}

pub fn valueset_create(
  resource: r5.Valueset,
  client: FhirClient,
  handle_response: fn(Result(r5.Valueset, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.valueset_to_json(resource),
    "ValueSet",
    r5.valueset_decoder(),
    client,
    handle_response,
  )
}

pub fn valueset_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Valueset, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "ValueSet", r5.valueset_decoder(), client, handle_response)
}

pub fn valueset_update(
  resource: r5.Valueset,
  client: FhirClient,
  handle_response: fn(Result(r5.Valueset, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.valueset_to_json(resource),
    "ValueSet",
    r5.valueset_decoder(),
    client,
    handle_response,
  )
}

pub fn valueset_delete(
  resource: r5.Valueset,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "ValueSet", client, handle_response)
}

pub fn valueset_search_bundled(
  search_for search_args: r5_sansio.SpValueset,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.valueset_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn valueset_search(
  search_for search_args: r5_sansio.SpValueset,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Valueset), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.valueset_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r5_sansio.bundle_to_groupedresources }.valueset },
  )
}

pub fn verificationresult_create(
  resource: r5.Verificationresult,
  client: FhirClient,
  handle_response: fn(Result(r5.Verificationresult, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.verificationresult_to_json(resource),
    "VerificationResult",
    r5.verificationresult_decoder(),
    client,
    handle_response,
  )
}

pub fn verificationresult_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Verificationresult, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "VerificationResult",
    r5.verificationresult_decoder(),
    client,
    handle_response,
  )
}

pub fn verificationresult_update(
  resource: r5.Verificationresult,
  client: FhirClient,
  handle_response: fn(Result(r5.Verificationresult, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.verificationresult_to_json(resource),
    "VerificationResult",
    r5.verificationresult_decoder(),
    client,
    handle_response,
  )
}

pub fn verificationresult_delete(
  resource: r5.Verificationresult,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "VerificationResult", client, handle_response)
}

pub fn verificationresult_search_bundled(
  search_for search_args: r5_sansio.SpVerificationresult,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.verificationresult_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn verificationresult_search(
  search_for search_args: r5_sansio.SpVerificationresult,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Verificationresult), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.verificationresult_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.verificationresult
    },
  )
}

pub fn visionprescription_create(
  resource: r5.Visionprescription,
  client: FhirClient,
  handle_response: fn(Result(r5.Visionprescription, ReqErr)) -> a,
) -> Effect(a) {
  any_create(
    r5.visionprescription_to_json(resource),
    "VisionPrescription",
    r5.visionprescription_decoder(),
    client,
    handle_response,
  )
}

pub fn visionprescription_read(
  id: String,
  client: FhirClient,
  handle_response: fn(Result(r5.Visionprescription, ReqErr)) -> a,
) -> Effect(a) {
  any_read(
    id,
    "VisionPrescription",
    r5.visionprescription_decoder(),
    client,
    handle_response,
  )
}

pub fn visionprescription_update(
  resource: r5.Visionprescription,
  client: FhirClient,
  handle_response: fn(Result(r5.Visionprescription, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_update(
    resource.id,
    r5.visionprescription_to_json(resource),
    "VisionPrescription",
    r5.visionprescription_decoder(),
    client,
    handle_response,
  )
}

pub fn visionprescription_delete(
  resource: r5.Visionprescription,
  client: FhirClient,
  handle_response: fn(Result(r5.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "VisionPrescription", client, handle_response)
}

pub fn visionprescription_search_bundled(
  search_for search_args: r5_sansio.SpVisionprescription,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r5.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r5_sansio.visionprescription_search_req(search_args, client)
  sendreq_handleresponse(req, r5.bundle_decoder(), handle_response)
}

pub fn visionprescription_search(
  search_for search_args: r5_sansio.SpVisionprescription,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r5.Visionprescription), ReqErr)) ->
    msg,
) -> Effect(msg) {
  let req = r5_sansio.visionprescription_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r5.bundle_decoder(),
    handle_response,
    fn(bundle) {
      { bundle |> r5_sansio.bundle_to_groupedresources }.visionprescription
    },
  )
}
