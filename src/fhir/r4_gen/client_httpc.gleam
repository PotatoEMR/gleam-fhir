////[https://hl7.org/fhir/r4](https://hl7.org/fhir/r4) r4 client using httpc

import fhir/r4_gen/resources
import fhir/r4_gen/sansio.{type FhirClient}
import fhir/r4_gen/search_params
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
  ErrOperationoutcome(resources.Operationoutcome)
  ///could not make an update or delete request because resource has no id
  ErrNoId
}

pub fn err_to_string(err: Err) -> String {
  case err {
    ErrSansio(err:) ->
      case err {
        ErrParseJson(err) -> sansio.err_resp_to_string(sansio.ErrParseJson(err))
        ErrServer(err) -> sansio.err_resp_to_string(sansio.ErrServer(err))
        ErrOperationoutcome(err) ->
          sansio.err_resp_to_string(sansio.ErrOperationoutcome(err))
        ErrNoId -> sansio.err_req_to_string
      }
    ErrHttpc(err:) -> http_err_to_string(err)
  }
}

fn any_create(
  resource: Json,
  res_type: resources.ResourceType,
  resource_dec: Decoder(r),
  client: FhirClient,
) -> Result(r, Err) {
  let req = sansio.any_create_req(resource, res_type, client)
  sendreq_parseresource(req, resource_dec, client)
}

fn any_read(
  id: String,
  client: FhirClient,
  res_type: resources.ResourceType,
  resource_dec: Decoder(a),
) -> Result(a, Err) {
  let req = sansio.any_read_req(id, res_type, client)
  sendreq_parseresource(req, resource_dec, client)
}

fn any_update(
  id: Option(String),
  resource: Json,
  res_type: resources.ResourceType,
  res_dec: Decoder(r),
  client: FhirClient,
) -> Result(r, Err) {
  let req = sansio.any_update_req(id, resource, res_type, client)
  case req {
    Ok(req) -> sendreq_parseresource(req, res_dec, client)
    Error(_) -> Error(ErrSansio(ErrNoId))
    //can have error preparing update request if resource has no id
  }
}

pub fn any_delete(
  id: String,
  res_type: resources.ResourceType,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  let req = sansio.any_delete_req(id, res_type, client)
  case httpc.send(req |> request.set_body("")) {
    Error(err) -> Error(ErrHttpc(err))
    Ok(resp) ->
      case sansio.delete_response(resp) {
        Ok(oo_or_http) -> Ok(oo_or_http)
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
  res_type: resources.ResourceType,
  client: FhirClient,
) -> Result(resources.Bundle, Err) {
  sansio.any_search_req(search_string, res_type, client)
  |> sendreq_parseresource(resources.bundle_decoder(), client)
}

/// get all resources in paginated bundle,
/// then stick them all in one bundle and pretend not paginated
///
/// fhirclient_httpc.search_any("name=e&_count=25", "Patient", client) |> fhirclient_httpc.all_pages(client)
pub fn all_pages(
  first_bundle: Result(resources.Bundle, Err),
  client: FhirClient,
) -> Result(resources.Bundle, Err) {
  case all_pages_loop(first_bundle, [], client) {
    Error(err) -> Error(err)
    Ok(#(last_bundle, bundles)) -> {
      let entries =
        list.fold(from: [], over: bundles, with: fn(acc, bundle) {
          list.append(bundle.entry, acc)
        })
      Ok(resources.Bundle(..last_bundle, entry: entries, link: []))
    }
  }
}

/// searchs each bundle and returns list
/// also returns last bundle individually
/// because all_pages smushes everything in there
fn all_pages_loop(
  curr_bundle: Result(resources.Bundle, Err),
  acc_bundles: List(resources.Bundle),
  client: FhirClient,
) -> Result(#(resources.Bundle, List(resources.Bundle)), Err) {
  case curr_bundle {
    Error(err) -> Error(err)
    Ok(curr_bundle) -> {
      let acc_bundles = [curr_bundle, ..acc_bundles]
      case sansio.bundle_next_page_req(curr_bundle, client) {
        // Error(_) -> reached last page
        Error(_) -> Ok(#(curr_bundle, acc_bundles))
        Ok(req) -> {
          let next =
            sendreq_parseresource(req, resources.bundle_decoder(), client)
          all_pages_loop(next, acc_bundles, client)
        }
      }
    }
  }
}

pub fn all_pages_forgiving(
  first_bundle: Result(resources.BundleForgiving, Err),
  client: FhirClient,
) -> Result(resources.BundleForgiving, Err) {
  case all_pages_loop_forgiving(first_bundle, [], client) {
    Error(err) -> Error(err)
    Ok(#(last_bundle, bundles)) -> {
      let entries =
        list.fold(from: [], over: bundles, with: fn(acc, bundle) {
          list.append(bundle.entry, acc)
        })
      Ok(resources.BundleForgiving(..last_bundle, entry: entries, link: []))
    }
  }
}

// arguably very duplicated, maybe should be combined somehow
fn all_pages_loop_forgiving(
  curr_bundle: Result(resources.BundleForgiving, Err),
  acc_bundles: List(resources.BundleForgiving),
  client: FhirClient,
) -> Result(#(resources.BundleForgiving, List(resources.BundleForgiving)), Err) {
  case curr_bundle {
    Error(err) -> Error(err)
    Ok(curr_bundle) -> {
      let acc_bundles = [curr_bundle, ..acc_bundles]
      case sansio.bundle_next_page_req_forgiving(curr_bundle, client) {
        // Error(_) -> reached last page
        Error(_) -> Ok(#(curr_bundle, acc_bundles))
        Ok(req) -> {
          let next =
            sendreq_parseresource(
              req,
              resources.bundle_decoder_forgiving(),
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
  res_type: resources.ResourceType,
  client: FhirClient,
) -> Result(resources.BundleForgiving, Err) {
  sansio.any_search_req(search_string, res_type, client)
  |> sendreq_parseresource(resources.bundle_decoder_forgiving(), client)
}

/// run any operation string on any resource type, optionally using Parameters
pub fn operation_any(
  params params: Option(resources.Parameters),
  operation_name operation_name: String,
  res_type res_type: resources.ResourceType,
  res_id res_id: Option(String),
  res_decoder res_decoder: Decoder(res),
  client client: FhirClient,
) -> Result(res, Err) {
  let req =
    sansio.any_operation_req(res_type, res_id, operation_name, params, client)
  sendreq_parseresource(req, res_decoder, client)
}

pub fn batch(
  reqs: List(Request(Option(Json))),
  bundle_type: sansio.PostBundleType,
  client: FhirClient,
) -> Result(resources.Bundle, Err) {
  let req = sansio.batch_req(reqs, bundle_type, client)
  sendreq_parseresource(req, resources.bundle_decoder(), client)
}

fn sendreq_parseresource(
  req: Request(Option(Json)),
  res_dec: Decoder(r),
  client: sansio.FhirClient,
) -> Result(r, Err) {
  case client.print_sent_requests {
    sansio.LoggingOn -> req |> sansio.req_to_string |> io.println
    sansio.LoggingOff -> Nil
  }
  let req =
    request.set_body(req, case req.body {
      None -> ""
      Some(body) -> json.to_string(body)
    })
  let resp = httpc.send(req)
  case client.print_received_responses {
    sansio.LoggingOn ->
      case resp {
        Ok(resp) -> resp |> sansio.resp_to_string
        Error(err) -> err |> http_err_to_string
      }
      |> io.println
    sansio.LoggingOff -> Nil
  }
  case resp {
    Error(err) -> Error(ErrHttpc(err))
    Ok(resp) ->
      case sansio.any_response(resp, res_dec) {
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

fn http_err_to_string(err: httpc.HttpError) {
  case err {
    httpc.InvalidUtf8Response -> "non-UTF-8 data in response"
    httpc.FailedToConnect(ip4:, ip6:) ->
      "could not connect to host: ip4 "
      <> connect_err_to_string(ip4)
      <> ", ip6 "
      <> connect_err_to_string(ip6)
    httpc.ResponseTimeout -> "timed out waiting for response"
  }
}

fn connect_err_to_string(err: httpc.ConnectError) -> String {
  case err {
    httpc.Posix(code:) -> "posix code " <> code
    httpc.TlsAlert(code:, detail:) ->
      "TLS alert code " <> code <> " and detail " <> detail
  }
}

pub type ErrValueset {
  ErrValuesetHttpc(err: httpc.HttpError)
  ErrValuesetSansio(err: sansio.SansioValuesetErr)
}

pub fn err_valueset_to_string(err: ErrValueset) -> String {
  case err {
    ErrValuesetHttpc(err) -> http_err_to_string(err)
    ErrValuesetSansio(err) ->
      case err {
        sansio.ValuesetResponseError(err) -> sansio.err_resp_to_string(err)
        sansio.ValuesetMissingExpansion -> "ValueSet response has no expansion"
        sansio.ValuesetUnexpectedOffset ->
          "ValueSet expansion returned an unexpected offset"
        sansio.ValuesetNestedEntries ->
          "ValueSet expansion returned nested entries despite excludeNested"
        sansio.ValuesetIncompleteExpansion ->
          "ValueSet expansion is marked incomplete"
        sansio.ValuesetTerminologyChanged ->
          "ValueSet expansion terminology versions changed between pages"
        sansio.ValuesetRepeatedCode ->
          "ValueSet expansion repeated a system/code pair"
        sansio.ValuesetMissingSystem -> "ValueSet expansion code has no system"
        sansio.ValuesetTotalChanged ->
          "ValueSet expansion total changed between pages"
        sansio.ValuesetTotalMismatch ->
          "ValueSet expansion does not agree with its total"
      }
  }
}

/// Expand a supplied ValueSet definition and collect every page.
pub fn valueset_expand(
  value_set: resources.Valueset,
  client: FhirClient,
) -> Result(resources.Valueset, ErrValueset) {
  valueset_expand_loop(sansio.valueset_expand_req(value_set, client), client)
}

fn valueset_expand_loop(
  step: sansio.ValuesetExpandStep,
  client: FhirClient,
) -> Result(resources.Valueset, ErrValueset) {
  case step {
    sansio.ValuesetExpandDone(value_set) -> Ok(value_set)
    sansio.ValuesetExpandNext(req, state) -> {
      case client.print_sent_requests {
        sansio.LoggingOn -> req |> sansio.req_to_string |> io.println
        sansio.LoggingOff -> Nil
      }
      let req =
        request.set_body(req, case req.body {
          None -> ""
          Some(body) -> json.to_string(body)
        })
      let resp = httpc.send(req)
      case client.print_received_responses {
        sansio.LoggingOn -> {
          case resp {
            Ok(resp) -> sansio.resp_to_string(resp)
            Error(err) -> http_err_to_string(err)
          }
          |> io.println
        }
        sansio.LoggingOff -> Nil
      }
      case resp {
        Error(err) -> Error(ErrValuesetHttpc(err))
        Ok(resp) ->
          case sansio.any_response(resp, resources.valueset_decoder()) {
            Error(err) ->
              Error(ErrValuesetSansio(sansio.ValuesetResponseError(err)))
            Ok(page) ->
              case sansio.valueset_expand_response(page, state, client) {
                Error(err) -> Error(ErrValuesetSansio(err))
                Ok(next) -> valueset_expand_loop(next, client)
              }
          }
      }
    }
  }
}

pub fn bundle_create(
  resource: resources.Bundle,
  client: FhirClient,
) -> Result(resources.Bundle, Err) {
  any_create(
    resources.bundle_to_json(resource),
    resources.RtBundle,
    resources.bundle_decoder(),
    client,
  )
}

pub fn bundle_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Bundle, Err) {
  any_read(id, client, resources.RtBundle, resources.bundle_decoder())
}

pub fn bundle_update(
  resource: resources.Bundle,
  client: FhirClient,
) -> Result(resources.Bundle, Err) {
  let id = resource.id
  any_update(
    id,
    resources.bundle_to_json(resource),
    resources.RtBundle,
    resources.bundle_decoder(),
    client,
  )
}

pub fn bundle_delete(
  resource: resources.Bundle,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  let id = resource.id
  case id {
    Some(id) -> any_delete(id, resources.RtBundle, client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn codesystem_create(
  resource: resources.Codesystem,
  client: FhirClient,
) -> Result(resources.Codesystem, Err) {
  any_create(
    resources.codesystem_to_json(resource),
    resources.RtCodesystem,
    resources.codesystem_decoder(),
    client,
  )
}

pub fn codesystem_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Codesystem, Err) {
  any_read(id, client, resources.RtCodesystem, resources.codesystem_decoder())
}

pub fn codesystem_update(
  resource: resources.Codesystem,
  client: FhirClient,
) -> Result(resources.Codesystem, Err) {
  let id = resource.id
  any_update(
    id,
    resources.codesystem_to_json(resource),
    resources.RtCodesystem,
    resources.codesystem_decoder(),
    client,
  )
}

pub fn codesystem_delete(
  resource: resources.Codesystem,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  let id = resource.id
  case id {
    Some(id) -> any_delete(id, resources.RtCodesystem, client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn operationoutcome_create(
  resource: resources.Operationoutcome,
  client: FhirClient,
) -> Result(resources.Operationoutcome, Err) {
  any_create(
    resources.operationoutcome_to_json(resource),
    resources.RtOperationoutcome,
    resources.operationoutcome_decoder(),
    client,
  )
}

pub fn operationoutcome_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Operationoutcome, Err) {
  any_read(
    id,
    client,
    resources.RtOperationoutcome,
    resources.operationoutcome_decoder(),
  )
}

pub fn operationoutcome_update(
  resource: resources.Operationoutcome,
  client: FhirClient,
) -> Result(resources.Operationoutcome, Err) {
  let id = resource.id
  any_update(
    id,
    resources.operationoutcome_to_json(resource),
    resources.RtOperationoutcome,
    resources.operationoutcome_decoder(),
    client,
  )
}

pub fn operationoutcome_delete(
  resource: resources.Operationoutcome,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  let id = resource.id
  case id {
    Some(id) -> any_delete(id, resources.RtOperationoutcome, client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn valueset_create(
  resource: resources.Valueset,
  client: FhirClient,
) -> Result(resources.Valueset, Err) {
  any_create(
    resources.valueset_to_json(resource),
    resources.RtValueset,
    resources.valueset_decoder(),
    client,
  )
}

pub fn valueset_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Valueset, Err) {
  any_read(id, client, resources.RtValueset, resources.valueset_decoder())
}

pub fn valueset_update(
  resource: resources.Valueset,
  client: FhirClient,
) -> Result(resources.Valueset, Err) {
  let id = resource.id
  any_update(
    id,
    resources.valueset_to_json(resource),
    resources.RtValueset,
    resources.valueset_decoder(),
    client,
  )
}

pub fn valueset_delete(
  resource: resources.Valueset,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  let id = resource.id
  case id {
    Some(id) -> any_delete(id, resources.RtValueset, client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn bundle_search_bundled(sp: search_params.Bundle, client: FhirClient) {
  search_params.to_string([
    #("identifier", sp.identifier),
    #("composition", sp.composition),
    #("type", sp.type_),
    #("message", sp.message),
    #("timestamp", sp.timestamp),
  ])
  |> search_any(resources.RtBundle, client)
}

pub fn bundle_search(
  sp: search_params.Bundle,
  client: FhirClient,
) -> Result(List(resources.Bundle), Err) {
  case bundle_search_bundled(sp, client) {
    Ok(bundle) -> Ok({ bundle |> sansio.bundle_to_groupedresources }.bundle)
    Error(error) -> Error(error)
  }
}

pub fn codesystem_search_bundled(
  sp: search_params.Codesystem,
  client: FhirClient,
) {
  search_params.to_string([
    #("date", sp.date),
    #("identifier", sp.identifier),
    #("code", sp.code),
    #("context-type-value", sp.context_type_value),
    #("content-mode", sp.content_mode),
    #("jurisdiction", sp.jurisdiction),
    #("description", sp.description),
    #("context-type", sp.context_type),
    #("language", sp.language),
    #("title", sp.title),
    #("version", sp.version),
    #("url", sp.url),
    #("context-quantity", sp.context_quantity),
    #("supplements", sp.supplements),
    #("system", sp.system),
    #("name", sp.name),
    #("context", sp.context),
    #("publisher", sp.publisher),
    #("context-type-quantity", sp.context_type_quantity),
    #("status", sp.status),
  ])
  |> search_any(resources.RtCodesystem, client)
}

pub fn codesystem_search(
  sp: search_params.Codesystem,
  client: FhirClient,
) -> Result(List(resources.Codesystem), Err) {
  case codesystem_search_bundled(sp, client) {
    Ok(bundle) -> Ok({ bundle |> sansio.bundle_to_groupedresources }.codesystem)
    Error(error) -> Error(error)
  }
}

pub fn operationoutcome_search_bundled(
  _sp: search_params.Operationoutcome,
  client: FhirClient,
) {
  search_params.to_string([])
  |> search_any(resources.RtOperationoutcome, client)
}

pub fn operationoutcome_search(
  sp: search_params.Operationoutcome,
  client: FhirClient,
) -> Result(List(resources.Operationoutcome), Err) {
  case operationoutcome_search_bundled(sp, client) {
    Ok(bundle) ->
      Ok({ bundle |> sansio.bundle_to_groupedresources }.operationoutcome)
    Error(error) -> Error(error)
  }
}

pub fn valueset_search_bundled(sp: search_params.Valueset, client: FhirClient) {
  search_params.to_string([
    #("date", sp.date),
    #("identifier", sp.identifier),
    #("code", sp.code),
    #("context-type-value", sp.context_type_value),
    #("jurisdiction", sp.jurisdiction),
    #("description", sp.description),
    #("context-type", sp.context_type),
    #("title", sp.title),
    #("version", sp.version),
    #("url", sp.url),
    #("expansion", sp.expansion),
    #("reference", sp.reference),
    #("context-quantity", sp.context_quantity),
    #("name", sp.name),
    #("context", sp.context),
    #("publisher", sp.publisher),
    #("context-type-quantity", sp.context_type_quantity),
    #("status", sp.status),
  ])
  |> search_any(resources.RtValueset, client)
}

pub fn valueset_search(
  sp: search_params.Valueset,
  client: FhirClient,
) -> Result(List(resources.Valueset), Err) {
  case valueset_search_bundled(sp, client) {
    Ok(bundle) -> Ok({ bundle |> sansio.bundle_to_groupedresources }.valueset)
    Error(error) -> Error(error)
  }
}
