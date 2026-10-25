pub const source =
  "////[https://hl7.org/fhir/FHIRVERSION](https://hl7.org/fhir/FHIRVERSION) FHIRVERSION client using httpc

import fhir/FHIRVERSION/resource
import fhir/FHIRVERSION/sansio.{type FhirClient}
import fhir/FHIRVERSION/search_param
import gleam/dynamic/decode.{type Decoder}
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/httpc
import gleam/io
import gleam/json.{type Json}
import gleam/list
import gleam/option.{type Option, None, Some}

pub type Err {
  ErrHttpc(err: httpc.HttpError)
  ErrSansio(err: ErrFromSansio)
}

pub type ErrFromSansio {
  ///got json but could not parse it, probably a missing required field
  ErrParseJson(json.DecodeError)
  ///did not get resource json, often server eg nginx gives basic html response
  ErrServer(Response(String))
  ///got operationoutcome error from fhir server
  ErrOperationoutcome(resource.Operationoutcome)
  ///could not make an update or delete request because resource has no id
  ErrNoId
}

pub fn err_to_string(err: Err) -> String {
  case err {
    ErrSansio(err:) ->
      case err {
        ErrParseJson(err) -> sansio.err_response_to_string(sansio.ErrParseJson(err))
        ErrServer(err) -> sansio.err_response_to_string(sansio.ErrServer(err))
        ErrOperationoutcome(err) ->
          sansio.err_response_to_string(sansio.ErrOperationoutcome(err))
        ErrNoId -> sansio.err_request_to_string
      }
    ErrHttpc(err:) -> http_err_to_string(err)
  }
}

fn any_create(
  resource: Json,
  resource_type: resource.ResourceType,
  resource_decoder: Decoder(r),
  client: FhirClient,
) -> Result(r, Err) {
  let http_request = sansio.any_create_request(resource, resource_type, client)
  send_request_and_parse_resource(http_request, resource_decoder, client)
}

fn any_read(
  id: String,
  client: FhirClient,
  resource_type: resource.ResourceType,
  resource_decoder: Decoder(a),
) -> Result(a, Err) {
  let http_request = sansio.any_read_request(id, resource_type, client)
  send_request_and_parse_resource(http_request, resource_decoder, client)
}

fn any_update(
  id: Option(String),
  resource: Json,
  resource_type: resource.ResourceType,
  resource_decoder: Decoder(r),
  client: FhirClient,
) -> Result(r, Err) {
  let http_request = sansio.any_update_request(id, resource, resource_type, client)
  case http_request {
    Ok(http_request) -> send_request_and_parse_resource(http_request, resource_decoder, client)
    Error(_) -> Error(ErrSansio(ErrNoId))
    //can have error preparing update request if resource has no id
  }
}

pub fn any_delete(
  id: String,
  resource_type: resource.ResourceType,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHttp, Err) {
  let http_request = sansio.any_delete_request(id, resource_type, client)
  case httpc.send(http_request |> request.set_body(\"\")) {
    Error(err) -> Error(ErrHttpc(err))
    Ok(http_response) ->
      case sansio.delete_response(http_response) {
        Ok(operation_outcome_or_http) -> Ok(operation_outcome_or_http)
        Error(err) ->
          Error(
            ErrSansio(case err {
              sansio.ErrParseJson(e) -> ErrParseJson(e)
              sansio.ErrServer(e) -> ErrServer(e)
              sansio.ErrOperationoutcome(e) -> ErrOperationoutcome(e)
            }),
          )
      }
  }
}

/// write out search string manually, in case typed search params don't work
pub fn search_any(
  search_string: String,
  resource_type: resource.ResourceType,
  client: FhirClient,
) -> Result(resource.Bundle, Err) {
  sansio.any_search_request(search_string, resource_type, client)
  |> send_request_and_parse_resource(resource.bundle_decoder(), client)
}

/// get all resources in paginated bundle,
/// then stick them all in one bundle and pretend not paginated
///
/// fhirclient_httpc.search_any(\"name=e&_count=25\", \"Patient\", client) |> fhirclient_httpc.all_pages(client)
pub fn all_pages(
  first_bundle: Result(resource.Bundle, Err),
  client: FhirClient,
) -> Result(resource.Bundle, Err) {
  case all_pages_loop(first_bundle, [], client) {
    Error(err) -> Error(err)
    Ok(#(last_bundle, bundles)) -> {
      let entries =
        list.fold(from: [], over: bundles, with: fn(acc, bundle) {
          list.append(bundle.entry, acc)
        })
      Ok(resource.Bundle(..last_bundle, entry: entries, link: []))
    }
  }
}

/// searchs each bundle and returns list
/// also returns last bundle individually
/// because all_pages smushes everything in there
fn all_pages_loop(
  current_bundle: Result(resource.Bundle, Err),
  acc_bundles: List(resource.Bundle),
  client: FhirClient,
) -> Result(#(resource.Bundle, List(resource.Bundle)), Err) {
  case current_bundle {
    Error(err) -> Error(err)
    Ok(current_bundle) -> {
      let acc_bundles = [current_bundle, ..acc_bundles]
      case sansio.bundle_next_page_request(current_bundle, client) {
        // Error(_) -> reached last page
        Error(_) -> Ok(#(current_bundle, acc_bundles))
        Ok(http_request) -> {
          let next =
            send_request_and_parse_resource(http_request, resource.bundle_decoder(), client)
          all_pages_loop(next, acc_bundles, client)
        }
      }
    }
  }
}

pub fn all_pages_forgiving(
  first_bundle: Result(resource.BundleForgiving, Err),
  client: FhirClient,
) -> Result(resource.BundleForgiving, Err) {
  case all_pages_loop_forgiving(first_bundle, [], client) {
    Error(err) -> Error(err)
    Ok(#(last_bundle, bundles)) -> {
      let entries =
        list.fold(from: [], over: bundles, with: fn(acc, bundle) {
          list.append(bundle.entry, acc)
        })
      Ok(resource.BundleForgiving(..last_bundle, entry: entries, link: []))
    }
  }
}

// arguably very duplicated, maybe should be combined somehow
fn all_pages_loop_forgiving(
  current_bundle: Result(resource.BundleForgiving, Err),
  acc_bundles: List(resource.BundleForgiving),
  client: FhirClient,
) -> Result(#(resource.BundleForgiving, List(resource.BundleForgiving)), Err) {
  case current_bundle {
    Error(err) -> Error(err)
    Ok(current_bundle) -> {
      let acc_bundles = [current_bundle, ..acc_bundles]
      case sansio.bundle_next_page_request_forgiving(current_bundle, client) {
        // Error(_) -> reached last page
        Error(_) -> Ok(#(current_bundle, acc_bundles))
        Ok(http_request) -> {
          let next =
            send_request_and_parse_resource(
              http_request,
              resource.bundle_decoder_forgiving(),
              client,
            )
          all_pages_loop_forgiving(next, acc_bundles, client)
        }
      }
    }
  }
}

/// instead of failing whole decoder on bundle entry with invalid resource,
/// return valid resources alongside list of errors
pub fn search_any_forgiving(
  search_string: String,
  resource_type: resource.ResourceType,
  client: FhirClient,
) -> Result(resource.BundleForgiving, Err) {
  sansio.any_search_request(search_string, resource_type, client)
  |> send_request_and_parse_resource(resource.bundle_decoder_forgiving(), client)
}

/// run any operation string on any resource type, optionally using Parameters
pub fn operation_any(
  params params: Option(resource.Parameters),
  operation_name operation_name: String,
  resource_type resource_type: resource.ResourceType,
  resource_id resource_id: Option(String),
  resource_decoder resource_decoder: Decoder(resource),
  client client: FhirClient,
) -> Result(resource, Err) {
  let http_request =
    sansio.any_operation_request(resource_type, resource_id, operation_name, params, client)
  send_request_and_parse_resource(http_request, resource_decoder, client)
}

pub fn batch(
  http_requests: List(Request(Option(Json))),
  bundle_type: sansio.PostBundleType,
  client: FhirClient,
) -> Result(resource.Bundle, Err) {
  let http_request = sansio.batch_request(http_requests, bundle_type, client)
  send_request_and_parse_resource(http_request, resource.bundle_decoder(), client)
}

fn send_request_and_parse_resource(
  http_request: Request(Option(Json)),
  resource_decoder: Decoder(r),
  client: sansio.FhirClient,
) -> Result(r, Err) {
  case client.print_sent_requests {
    sansio.LoggingOn -> http_request |> sansio.request_to_string |> io.println
    sansio.LoggingOff -> Nil
  }
  let http_request =
    request.set_body(http_request, case http_request.body {
      None -> \"\"
      Some(body) -> json.to_string(body)
    })
  let http_response = httpc.send(http_request)
  case client.print_received_responses {
    sansio.LoggingOn ->
      case http_response {
        Ok(http_response) -> http_response |> sansio.response_to_string
        Error(err) -> err |> http_err_to_string
      }
      |> io.println
    sansio.LoggingOff -> Nil
  }
  case http_response {
    Error(err) -> Error(ErrHttpc(err))
    Ok(http_response) ->
      case sansio.any_response(http_response, resource_decoder) {
        Ok(resource) -> Ok(resource)
        Error(err) ->
          Error(
            ErrSansio(case err {
              sansio.ErrParseJson(e) -> ErrParseJson(e)
              sansio.ErrServer(e) -> ErrServer(e)
              sansio.ErrOperationoutcome(e) -> ErrOperationoutcome(e)
            }),
          )
      }
  }
}

fn http_err_to_string(err: httpc.HttpError) -> String {
  case err {
    httpc.InvalidUtf8Response -> \"non-UTF-8 data in response\"
    httpc.FailedToConnect(ip4:, ip6:) ->
      \"could not connect to host: ip4 \"
      <> connect_err_to_string(ip4)
      <> \", ip6 \"
      <> connect_err_to_string(ip6)
    httpc.ResponseTimeout -> \"timed out waiting for response\"
  }
}

fn connect_err_to_string(err: httpc.ConnectError) -> String {
  case err {
    httpc.Posix(code:) -> \"posix code \" <> code
    httpc.TlsAlert(code:, detail:) ->
      \"TLS alert code \" <> code <> \" and detail \" <> detail
  }
}
"

pub const valueset_expand =
  "
pub type ErrValueset {
  ErrValuesetHttpc(err: httpc.HttpError)
  ErrValuesetSansio(err: sansio.SansioValuesetErr)
}

pub fn err_valueset_to_string(err: ErrValueset) -> String {
  case err {
    ErrValuesetHttpc(err) -> http_err_to_string(err)
    ErrValuesetSansio(err) -> case err {
      sansio.ValuesetResponseError(err) -> sansio.err_response_to_string(err)
      sansio.ValuesetMissingExpansion -> \"ValueSet response has no expansion\"
      sansio.ValuesetUnexpectedOffset -> \"ValueSet expansion returned an unexpected offset\"
      sansio.ValuesetNestedEntries -> \"ValueSet expansion returned nested entries despite excludeNested\"
      sansio.ValuesetIncompleteExpansion -> \"ValueSet expansion is marked incomplete\"
      sansio.ValuesetTerminologyChanged -> \"ValueSet expansion terminology versions changed between pages\"
      sansio.ValuesetRepeatedCode -> \"ValueSet expansion repeated a system/code pair\"
      sansio.ValuesetMissingSystem -> \"ValueSet expansion code has no system\"
      sansio.ValuesetTotalChanged -> \"ValueSet expansion total changed between pages\"
      sansio.ValuesetTotalMismatch -> \"ValueSet expansion does not agree with its total\"
    }
  }
}

/// Expand a supplied ValueSet definition and collect every page.
pub fn valueset_expand(
  value_set: resource.Valueset,
  client: FhirClient,
) -> Result(resource.Valueset, ErrValueset) {
  valueset_expand_loop(sansio.valueset_expand_request(value_set, client), client)
}

fn valueset_expand_loop(
  step: sansio.ValuesetExpandStep,
  client: FhirClient,
) -> Result(resource.Valueset, ErrValueset) {
  case step {
    sansio.ValuesetExpandDone(value_set) -> Ok(value_set)
    sansio.ValuesetExpandNext(http_request, state) -> {
      case client.print_sent_requests {
        sansio.LoggingOn -> http_request |> sansio.request_to_string |> io.println
        sansio.LoggingOff -> Nil
      }
      let http_request = request.set_body(http_request, case http_request.body {
        None -> \"\"
        Some(body) -> json.to_string(body)
      })
      let http_response = httpc.send(http_request)
      case client.print_received_responses {
        sansio.LoggingOn -> {
          case http_response {
            Ok(http_response) -> sansio.response_to_string(http_response)
            Error(err) -> http_err_to_string(err)
          }
          |> io.println
        }
        sansio.LoggingOff -> Nil
      }
      case http_response {
        Error(err) -> Error(ErrValuesetHttpc(err))
        Ok(http_response) -> case sansio.any_response(http_response, resource.valueset_decoder()) {
          Error(err) -> Error(ErrValuesetSansio(sansio.ValuesetResponseError(err)))
          Ok(page) -> case sansio.valueset_expand_response(page, state, client) {
            Error(err) -> Error(ErrValuesetSansio(err))
            Ok(next) -> valueset_expand_loop(next, client)
          }
        }
      }
    }
  }
}
"
