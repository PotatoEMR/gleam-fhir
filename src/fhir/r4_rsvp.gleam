import fhir/r4
import fhir/r4_sansio
import gleam/dynamic/decode.{type Decoder}
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/httpc
import gleam/json.{type Json}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/effect.{type Effect}
import rsvp

pub type FhirClient =
  r4_sansio.FhirClient

pub fn fhirclient_new(baseurl: String) -> FhirClient {
  r4_sansio.fhirclient_new(baseurl)
}

pub type ReqErr {
  ReqErrRsvp(err: rsvp.Error)
  ReqErrSansio(err: r4_sansio.Err)
}

/// when using rsvp, if you attempt update or delete a resource with no id
/// we do not even send the request or give you an effect to use
/// instead just an Error(ErrNoId)
pub type ErrNoId {
  ErrNoId
}

pub fn patient_create(
  resource: r4.Patient,
  client: FhirClient,
  handle_response: fn(Result(r4.Patient, ReqErr)) -> a,
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
  handle_response: fn(Result(r4.Patient, ReqErr)) -> a,
) -> Effect(a) {
  any_read(id, "Patient", r4.patient_decoder(), client, handle_response)
}

pub fn patient_update(
  resource: r4.Patient,
  client: FhirClient,
  handle_response: fn(Result(r4.Patient, ReqErr)) -> a,
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
  handle_response: fn(Result(r4.Operationoutcome, ReqErr)) -> a,
) -> Result(Effect(a), ErrNoId) {
  any_delete(resource.id, "Patient", client, handle_response)
}

fn any_create(
  resource: Json,
  res_type: String,
  resource_dec: Decoder(r),
  client: FhirClient,
  handle_response: fn(Result(r, ReqErr)) -> a,
) -> Effect(a) {
  let req = r4_sansio.any_create_req(resource, res_type, client)
  sendreq_handleresponse(req, resource_dec, handle_response)
}

fn any_read(
  id: String,
  res_type: String,
  resource_dec: Decoder(r),
  client: FhirClient,
  handle_response: fn(Result(r, ReqErr)) -> a,
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
  handle_response: fn(Result(r, ReqErr)) -> a,
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
  handle_response: fn(Result(r4.Operationoutcome, ReqErr)) -> a,
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

pub fn patient_search_bundled(
  search_for search_args: r4_sansio.SpPatient,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(r4.Bundle, ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.patient_search_req(search_args, client)
  sendreq_handleresponse(req, r4.bundle_decoder(), handle_response)
}

pub fn patient_search(
  search_for search_args: r4_sansio.SpPatient,
  with_client client: FhirClient,
  response_msg handle_response: fn(Result(List(r4.Patient), ReqErr)) -> msg,
) -> Effect(msg) {
  let req = r4_sansio.patient_search_req(search_args, client)
  sendreq_handleresponse_andprocess(
    req,
    r4.bundle_decoder(),
    handle_response,
    fn(bundle) { { bundle |> r4_sansio.bundle_to_groupedresources }.patient },
  )
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
        case r4_sansio.any_resp(resp_res, res_dec) {
          Ok(res) -> Ok(process_res(res))
          Error(err) -> Error(ReqErrSansio(err))
        }
      }
    })
  }
  let handler = rsvp.expect_any_response(handle_read)
  rsvp.send(req, handler)
}
