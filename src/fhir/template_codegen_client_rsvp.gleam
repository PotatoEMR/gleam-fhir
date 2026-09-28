pub const source = "////[https://hl7.org/fhir/FHIRVERSION](https://hl7.org/fhir/FHIRVERSION) FHIRVERSION client using rsvp

import fhir/FHIRVERSION/resources
import fhir/FHIRVERSION/sansio
import fhir/FHIRVERSION/search_params
import gleam/dynamic/decode.{type Decoder}
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/io
import gleam/json.{type Json}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/effect.{type Effect}
import rsvp

/// FHIR client for sending http requests to server such as
/// `let pat = resources.patient_read(\"123\", client)`
///
/// create client from server base url with fhirclient_new(baseurl)`
///
/// `let assert Ok(client) = client_rsvp.fhirclient_new(\"r4.smarthealthit.org/\")`
///
/// `let assert Ok(client) = client_rsvp.fhirclient_new(\"https://r4.smarthealthit.org/\")`
///
/// `let assert Ok(client) = client_rsvp.fhirclient_new(\"https://hapi.fhir.org/baseR4\")`
///
/// `let assert Ok(client) = client_rsvp.fhirclient_new(\"127.0.0.1:8000\")`
/// 
/// rsvp client wraps sansio client, along with an optional handle_unauthorized fn,
/// for the client to call when a request returns 401 unauthorized
pub type FhirClient(msg) {
  FhirClient(
    client: sansio.FhirClient,
    handle_unauthorized: Option(fn(sansio.ErrResp) -> msg),
  )
}

/// creates a new client from server base url
///
/// `let assert Ok(client) = client_rsvp.fhirclient_new(\"r4.smarthealthit.org/\")`
///
/// `let assert Ok(client) = client_rsvp.fhirclient_new(\"https://r4.smarthealthit.org/\")`
///
/// `let assert Ok(client) = client_rsvp.fhirclient_new(\"https://hapi.fhir.org/baseR4\")`
///
/// `let assert Ok(client) = client_rsvp.fhirclient_new(\"127.0.0.1:8000\")`
pub fn fhirclient_new(
  server_base_url in_url: String,
) -> Result(FhirClient(msg), sansio.ErrBaseUrl) {
  case sansio.fhirclient_new(in_url) {
    Ok(client) -> Ok(FhirClient(client:, handle_unauthorized: None))
    Error(err) -> Error(err)
  }
}

pub type Err {
  ErrRsvp(err: rsvp.Error(String))
  ErrSansio(err: sansio.ErrResp)
}

pub fn err_to_string(err: Err) -> String {
  case err {
    ErrRsvp(err:) -> rsvp_err_to_string(err)
    ErrSansio(err:) -> sansio.err_resp_to_string(err)
  }
}

/// When using rsvp, if you attempt update or delete a resource with no id,
/// we do not even send the request or give you an effect to use.
/// Instead of an effect you get just Error(ErrNoId)
pub type ErrNoId {
  ErrNoId
}

fn any_create(
  resource: Json,
  res_type: resources.ResourceType,
  resource_dec: Decoder(r),
  client: FhirClient(msg),
  handle_response: fn(Result(r, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.any_create_req(resource, res_type, client.client)
  sendreq_handleresponse(req, resource_dec, handle_response, client)
}

fn any_read(
  id: String,
  res_type: resources.ResourceType,
  resource_dec: Decoder(r),
  client: FhirClient(msg),
  handle_response: fn(Result(r, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.any_read_req(id, res_type, client.client)
  sendreq_handleresponse(req, resource_dec, handle_response, client)
}

fn any_update(
  id: Option(String),
  resource: Json,
  res_type: resources.ResourceType,
  resource_dec: Decoder(r),
  client: FhirClient(msg),
  handle_response: fn(Result(r, Err)) -> msg,
) -> Result(Effect(msg), ErrNoId) {
  let req = sansio.any_update_req(id, resource, res_type, client.client)
  case req {
    Ok(req) ->
      Ok(sendreq_handleresponse(req, resource_dec, handle_response, client))
    Error(_) -> Error(ErrNoId)
  }
}

pub fn any_delete(
  id: String,
  res_type: resources.ResourceType,
  client: FhirClient(msg),
  handle_response: fn(Result(sansio.OperationoutcomeOrHTTP, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.any_delete_req(id, res_type, client.client)
  case client.client.print_sent_requests {
    sansio.LoggingOn -> req |> sansio.req_to_string |> io.println
    sansio.LoggingOff -> Nil
  }
  let handle_read = fn(
    response_result: Result(Response(String), rsvp.Error(String)),
  ) {
    case client.client.print_received_responses {
      sansio.LoggingOn ->
        case response_result {
          Ok(resp) -> resp |> sansio.resp_to_string
          Error(err) -> err |> rsvp_err_to_string
        }
        |> io.println
      sansio.LoggingOff -> Nil
    }
    case response_result {
      Error(err) -> Error(ErrRsvp(err)) |> handle_response
      Ok(response) ->
        case sansio.delete_response(response) {
          Ok(oo_or_http) -> Ok(oo_or_http) |> handle_response
          Error(err) ->
            case response.status, client.handle_unauthorized {
              401, Some(handle_unauthorized) -> handle_unauthorized(err)
              _, _ -> Error(ErrSansio(err)) |> handle_response
            }
        }
    }
  }
  let handler = rsvp.expect_any_response(handle_read)
  req
  |> request.set_body(case req.body {
    None -> \"\"
    Some(body) -> json.to_string(body)
  })
  |> rsvp.send(handler)
}

/// write out search string manually, in case typed search params don't work
pub fn search_any(
  search_string: String,
  res_type: resources.ResourceType,
  client: FhirClient(msg),
  handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.any_search_req(search_string, res_type, client.client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    handle_response,
    client,
  )
}

/// instead of failing whole decoder on bundle entry with invalid resource,
/// return valid resources alongside list of errors
pub fn search_any_forgiving(
  search_string: String,
  res_type: resources.ResourceType,
  client: FhirClient(msg),
  handle_response: fn(Result(resources.BundleForgiving, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.any_search_req(search_string, res_type, client.client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder_forgiving(),
    handle_response,
    client,
  )
}

// run any operation string on any resource string, optionally using Parameters
pub fn operation_any(
  params params: Option(resources.Parameters),
  operation_name operation_name: String,
  res_type res_type: resources.ResourceType,
  res_id res_id: Option(String),
  res_decoder res_decoder: Decoder(res),
  client client: FhirClient(msg),
  handle_response handle_response: fn(Result(res, Err)) -> msg,
) -> Effect(msg) {
  let req =
    sansio.any_operation_req(
      res_type,
      res_id,
      operation_name,
      params,
      client.client,
    )
  sendreq_handleresponse(req, res_decoder, handle_response, client)
}

pub fn batch(
  reqs: List(Request(Option(Json))),
  bundle_type: sansio.PostBundleType,
  client: FhirClient(msg),
  handle_response: fn(Result(resources.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let req = sansio.batch_req(reqs, bundle_type, client.client)
  sendreq_handleresponse(
    req,
    resources.bundle_decoder(),
    handle_response,
    client,
  )
}

fn sendreq_handleresponse(
  req: Request(Option(Json)),
  res_dec: Decoder(resource),
  handle_response: fn(Result(resource, Err)) -> msg,
  client: FhirClient(msg),
) -> Effect(msg) {
  case client.client.print_sent_requests {
    sansio.LoggingOn -> req |> sansio.req_to_string |> io.println
    sansio.LoggingOff -> Nil
  }
  let handle_read = fn(
    response_result: Result(Response(String), rsvp.Error(String)),
  ) {
    case client.client.print_received_responses {
      sansio.LoggingOn ->
        case response_result {
          Ok(resp) -> resp |> sansio.resp_to_string
          Error(err) -> err |> rsvp_err_to_string
        }
        |> io.println
      sansio.LoggingOff -> Nil
    }
    case response_result {
      // could maybe handle_unauthorized here as well for rsvp.Error variant HttpError
      // but expect_any_response will not error on status 401
      Error(err) -> Error(ErrRsvp(err)) |> handle_response
      Ok(response) -> {
        case sansio.any_response(response, res_dec) {
          Ok(res) -> Ok(res) |> handle_response
          Error(err) ->
            case response.status, client.handle_unauthorized {
              401, Some(handle_unauthorized) -> handle_unauthorized(err)
              _, _ -> Error(ErrSansio(err)) |> handle_response
            }
        }
      }
    }
  }
  let handler = rsvp.expect_any_response(handle_read)
  req
  |> request.set_body(case req.body {
    None -> \"\"
    Some(body) -> json.to_string(body)
  })
  |> rsvp.send(handler)
}

fn rsvp_err_to_string(err: rsvp.Error(String)) -> String {
  case err {
    rsvp.BadBody -> \"invalid http response body\"
    rsvp.BadUrl(url) -> \"invalid url: \" <> url
    rsvp.HttpError(resp) -> \"resp not 2xx: \" <> sansio.resp_to_string(resp)
    rsvp.JsonError(err) ->
      \"err decoding json: \"
      <> case err {
        json.UnexpectedEndOfInput -> \"unexpected end of input\"
        json.UnexpectedByte(err) -> \"unexpected byte: \" <> err
        json.UnexpectedSequence(err) -> \"unexpected sequence \" <> err
        json.UnableToDecode(errors) ->
          \"unable to decode: \"
          <> list.map(errors, fn(error) {
            \"expected \"
            <> error.expected
            <> \" but found \"
            <> error.found
            <> \" at \"
            <> string.join(error.path, \"/\")
          })
          |> string.join(\"\\n\")
      }
    rsvp.NetworkError ->
      \"network error, http request could not connect to server\"
    rsvp.UnhandledResponse(resp) ->
      \"rsvp handler does not know how to handle response: \"
      <> sansio.resp_to_string(resp)
  }
}
"
