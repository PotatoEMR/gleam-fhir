pub const source =
  "////[https://hl7.org/fhir/FHIRVERSION](https://hl7.org/fhir/FHIRVERSION) FHIRVERSION client using rsvp

import fhir/FHIRVERSION/resource
import fhir/FHIRVERSION/sansio
import fhir/FHIRVERSION/search_param
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
/// `let pat = resource.patient_read(\"123\", client)`
///
/// create client from server base url with fhirclient_new(base_url)`
///
/// `let assert Ok(client) = client_rsvp.fhirclient_new(\"r4.smarthealthit.org/\")`
///
/// `let assert Ok(client) = client_rsvp.fhirclient_new(\"https://r4.smarthealthit.org/\")`
///
/// `let assert Ok(client) = client_rsvp.fhirclient_new(\"https://hapi.fhir.org/baseR4\")`
///
/// `let assert Ok(client) = client_rsvp.fhirclient_new(\"127.0.0.1:8000\")`
/// 
/// rsvp client wraps sansio client
pub type FhirClient {
  FhirClient(
    client: sansio.FhirClient,
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
) -> Result(FhirClient, sansio.ErrBaseUrl) {
  case sansio.fhirclient_new(in_url) {
    Ok(client) -> Ok(FhirClient(client:))
    Error(err) -> Error(err)
  }
}

pub type Err {
  ErrRsvp(err: rsvp.Error(String))
  ErrSansio(err: sansio.ErrResponse)
}

pub fn err_to_string(err: Err) -> String {
  case err {
    ErrRsvp(err:) -> rsvp_err_to_string(err)
    ErrSansio(err:) -> sansio.err_response_to_string(err)
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
  resource_type: resource.ResourceType,
  resource_decoder: Decoder(r),
  client: FhirClient,
  handle_response: fn(Result(r, Err)) -> msg,
) -> Effect(msg) {
  let http_request = sansio.any_create_request(resource, resource_type, client.client)
  send_request_and_handle_response(http_request, resource_decoder, handle_response, client)
}

fn any_read(
  id: String,
  resource_type: resource.ResourceType,
  resource_decoder: Decoder(r),
  client: FhirClient,
  handle_response: fn(Result(r, Err)) -> msg,
) -> Effect(msg) {
  let http_request = sansio.any_read_request(id, resource_type, client.client)
  send_request_and_handle_response(http_request, resource_decoder, handle_response, client)
}

fn any_update(
  id: Option(String),
  resource: Json,
  resource_type: resource.ResourceType,
  resource_decoder: Decoder(r),
  client: FhirClient,
  handle_response: fn(Result(r, Err)) -> msg,
) -> Result(Effect(msg), ErrNoId) {
  let http_request = sansio.any_update_request(id, resource, resource_type, client.client)
  case http_request {
    Ok(http_request) ->
      Ok(send_request_and_handle_response(http_request, resource_decoder, handle_response, client))
    Error(_) -> Error(ErrNoId)
  }
}

pub fn any_delete(
  id: String,
  resource_type: resource.ResourceType,
  client: FhirClient,
  handle_response: fn(Result(sansio.OperationoutcomeOrHttp, Err)) -> msg,
) -> Effect(msg) {
  let http_request = sansio.any_delete_request(id, resource_type, client.client)
  case client.client.print_sent_requests {
    sansio.LoggingOn -> http_request |> sansio.request_to_string |> io.println
    sansio.LoggingOff -> Nil
  }
  let handle_read = fn(
    response_result: Result(Response(String), rsvp.Error(String)),
  ) {
    case client.client.print_received_responses {
      sansio.LoggingOn ->
        case response_result {
          Ok(http_response) -> http_response |> sansio.response_to_string
          Error(err) -> err |> rsvp_err_to_string
        }
        |> io.println
      sansio.LoggingOff -> Nil
    }
    case response_result {
      Error(err) -> Error(ErrRsvp(err)) |> handle_response
      Ok(response) ->
        case sansio.delete_response(response) {
          Ok(operation_outcome_or_http) -> Ok(operation_outcome_or_http) |> handle_response
          Error(err) -> Error(ErrSansio(err)) |> handle_response
        }
    }
  }
  let handler = rsvp.expect_any_response(handle_read)
  http_request
  |> request.set_body(case http_request.body {
    None -> \"\"
    Some(body) -> json.to_string(body)
  })
  |> rsvp.send(handler)
}

/// write out search string manually, in case typed search params don't work
pub fn search_any(
  search_string: String,
  resource_type: resource.ResourceType,
  client: FhirClient,
  handle_response: fn(Result(resource.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let http_request = sansio.any_search_request(search_string, resource_type, client.client)
  send_request_and_handle_response(
    http_request,
    resource.bundle_decoder(),
    handle_response,
    client,
  )
}

/// instead of failing whole decoder on bundle entry with invalid resource,
/// return valid resources alongside list of errors
pub fn search_any_forgiving(
  search_string: String,
  resource_type: resource.ResourceType,
  client: FhirClient,
  handle_response: fn(Result(resource.BundleForgiving, Err)) -> msg,
) -> Effect(msg) {
  let http_request = sansio.any_search_request(search_string, resource_type, client.client)
  send_request_and_handle_response(
    http_request,
    resource.bundle_decoder_forgiving(),
    handle_response,
    client,
  )
}

// run any operation string on any resource string, optionally using Parameters
pub fn operation_any(
  params params: Option(resource.Parameters),
  operation_name operation_name: String,
  resource_type resource_type: resource.ResourceType,
  resource_id resource_id: Option(String),
  resource_decoder resource_decoder: Decoder(resource),
  client client: FhirClient,
  handle_response handle_response: fn(Result(resource, Err)) -> msg,
) -> Effect(msg) {
  let http_request =
    sansio.any_operation_request(
      resource_type,
      resource_id,
      operation_name,
      params,
      client.client,
    )
  send_request_and_handle_response(http_request, resource_decoder, handle_response, client)
}

pub fn batch(
  http_requests: List(Request(Option(Json))),
  bundle_type: sansio.PostBundleType,
  client: FhirClient,
  handle_response: fn(Result(resource.Bundle, Err)) -> msg,
) -> Effect(msg) {
  let http_request = sansio.batch_request(http_requests, bundle_type, client.client)
  send_request_and_handle_response(
    http_request,
    resource.bundle_decoder(),
    handle_response,
    client,
  )
}

fn send_request_and_handle_response(
  http_request: Request(Option(Json)),
  resource_decoder: Decoder(resource),
  handle_response: fn(Result(resource, Err)) -> msg,
  client: FhirClient,
) -> Effect(msg) {
  case client.client.print_sent_requests {
    sansio.LoggingOn -> http_request |> sansio.request_to_string |> io.println
    sansio.LoggingOff -> Nil
  }
  let handle_read = fn(
    response_result: Result(Response(String), rsvp.Error(String)),
  ) {
    case client.client.print_received_responses {
      sansio.LoggingOn ->
        case response_result {
          Ok(http_response) -> http_response |> sansio.response_to_string
          Error(err) -> err |> rsvp_err_to_string
        }
        |> io.println
      sansio.LoggingOff -> Nil
    }
    case response_result {
      Error(err) -> Error(ErrRsvp(err)) |> handle_response
      Ok(response) -> {
        case sansio.any_response(response, resource_decoder) {
          Ok(resource) -> Ok(resource) |> handle_response
          Error(err) -> Error(ErrSansio(err)) |> handle_response
        }
      }
    }
  }
  let handler = rsvp.expect_any_response(handle_read)
  http_request
  |> request.set_body(case http_request.body {
    None -> \"\"
    Some(body) -> json.to_string(body)
  })
  |> rsvp.send(handler)
}

fn rsvp_err_to_string(err: rsvp.Error(String)) -> String {
  case err {
    rsvp.BadBody -> \"invalid http response body\"
    rsvp.BadUrl(url) -> \"invalid url: \" <> url
    rsvp.HttpError(http_response) -> \"http_response not 2xx: \" <> sansio.response_to_string(http_response)
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
    rsvp.UnhandledResponse(http_response) ->
      \"rsvp handler does not know how to handle response: \"
      <> sansio.response_to_string(http_response)
  }
}
"
