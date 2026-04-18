////[https://hl7.org/fhir/r4us](https://hl7.org/fhir/r4us) r4us client using httpc

import fhir/r4us
import fhir/r4us_sansio
import gleam/dynamic/decode.{type Decoder}
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/httpc
import gleam/json.{type Json}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result

/// FHIR client for sending http requests to server such as
/// `let pat = r4us.patient_read("123", client)`
///
/// create client from server base url with fhirclient_new(baseurl)`
///
/// `let assert Ok(client) = r4us_httpc.fhirclient_new("r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = r4us_httpc.fhirclient_new("https://r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = r4us_httpc.fhirclient_new("https://hapi.fhir.org/baseR4")`
///
/// `let assert Ok(client) = r4us_httpc.fhirclient_new("127.0.0.1:8000")`
pub type FhirClient =
  r4us_sansio.FhirClient

/// creates a new client from server base url
///
/// `let assert Ok(client) = r4us_httpc.fhirclient_new("r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = r4us_httpc.fhirclient_new("https://r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = r4us_httpc.fhirclient_new("https://hapi.fhir.org/baseR4")`
///
/// `let assert Ok(client) = r4us_httpc.fhirclient_new("127.0.0.1:8000")`
pub fn fhirclient_new(
  baseurl: String,
) -> Result(FhirClient, r4us_sansio.ErrBaseUrl) {
  r4us_sansio.fhirclient_new(baseurl)
}

pub type Err {
  ErrHttpc(err: httpc.HttpError)
  ErrSansio(err: ErrFromSansio)
}

pub type ErrFromSansio {
  ///got json but could not parse it, probably a missing required field
  ErrParseJson(json.DecodeError)
  ///did not get resource json, often server eg nginx gives basic html response
  ErrNotJson(Response(String))
  ///got operationoutcome error from fhir server
  ErrOperationoutcome(r4us.Operationoutcome)
  ///could not make an update or delete request because resource has no id
  ErrNoId
}

fn any_create(
  resource: Json,
  res_type: String,
  resource_dec: Decoder(r),
  client: FhirClient,
) -> Result(r, Err) {
  let req = r4us_sansio.any_create_req(resource, res_type, client)
  sendreq_parseresource(req, resource_dec, res_type)
}

fn any_read(
  id: String,
  client: FhirClient,
  res_type: String,
  resource_dec: Decoder(a),
) -> Result(a, Err) {
  let req = r4us_sansio.any_read_req(id, res_type, client)
  sendreq_parseresource(req, resource_dec, res_type)
}

fn any_update(
  id: Option(String),
  resource: Json,
  res_type: String,
  res_dec: Decoder(r),
  client: FhirClient,
) -> Result(r, Err) {
  let req = r4us_sansio.any_update_req(id, resource, res_type, client)
  case req {
    Ok(req) -> sendreq_parseresource(req, res_dec, res_type)
    Error(_) -> Error(ErrSansio(ErrNoId))
    //can have error preparing update request if resource has no id
  }
}

fn any_delete(
  id: String,
  res_type: String,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  let req = r4us_sansio.any_delete_req(id, res_type, client)
  case httpc.send(req |> request.set_body("")) {
    Error(err) -> Error(ErrHttpc(err))
    Ok(resp) ->
      case r4us_sansio.http_or_operationoutcome_resp(resp) {
        Ok(oo_or_http) -> Ok(oo_or_http)
        Error(err) ->
          Error(
            ErrSansio(case err {
              r4us_sansio.ErrParseJson(e) -> ErrParseJson(e)
              r4us_sansio.ErrNotJson(e) -> ErrNotJson(e)
              r4us_sansio.ErrOperationoutcome(e) -> ErrOperationoutcome(e)
            }),
          )
      }
  }
}

/// write out search string manually, in case typed search params don't work
pub fn search_any(
  search_string: String,
  res_type: String,
  client: FhirClient,
) -> Result(r4us.Bundle, Err) {
  let req = r4us_sansio.any_search_req(search_string, res_type, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

/// get all resources in paginated bundle,
/// then stick them all in one bundle and pretend not paginated
///
/// r4us_httpc.search_any("name=e&_count=25", "Patient", client) |> r4us_httpc.all_pages(client)
pub fn all_pages(
  first_bundle: Result(r4us.Bundle, Err),
  client: FhirClient,
) -> Result(r4us.Bundle, Err) {
  case all_pages_loop(first_bundle, [], client) {
    Error(err) -> Error(err)
    Ok(#(last_bundle, bundles)) -> {
      let entries =
        list.fold(from: [], over: bundles, with: fn(acc, bundle) {
          list.append(bundle.entry, acc)
        })
      Ok(r4us.Bundle(..last_bundle, entry: entries, link: []))
    }
  }
}

/// searchs each bundle and returns list
/// also returns last bundle individually
/// because all_pages smushes everything in there
pub fn all_pages_loop(
  curr_bundle: Result(r4us.Bundle, Err),
  acc_bundles: List(r4us.Bundle),
  client: FhirClient,
) -> Result(#(r4us.Bundle, List(r4us.Bundle)), Err) {
  case curr_bundle {
    Error(err) -> Error(err)
    Ok(curr_bundle) -> {
      let acc_bundles = [curr_bundle, ..acc_bundles]
      case r4us_sansio.bundle_next_page_req(curr_bundle, client) {
        // Error(_) -> reached last page
        Error(_) -> Ok(#(curr_bundle, acc_bundles))
        Ok(req) -> {
          let next = sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
          all_pages_loop(next, acc_bundles, client)
        }
      }
    }
  }
}

/// run any operation string on any resource string, optionally using Parameters
pub fn operation_any(
  params params: Option(r4us.Parameters),
  operation_name operation_name: String,
  res_type res_type: String,
  res_id res_id: Option(String),
  res_decoder res_decoder: Decoder(res),
  return_res_type return_res_type: String,
  client client: FhirClient,
) -> Result(res, Err) {
  let req =
    r4us_sansio.any_operation_req(
      res_type,
      res_id,
      operation_name,
      params,
      client,
    )
  sendreq_parseresource(req, res_decoder, return_res_type)
}

pub fn batch(
  reqs: List(Request(Option(Json))),
  bundle_type: r4us_sansio.PostBundleType,
  client: FhirClient,
) -> Result(r4us.Bundle, Err) {
  let req = r4us_sansio.batch_req(reqs, bundle_type, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

fn sendreq_parseresource(
  req: Request(Option(Json)),
  res_dec: Decoder(r),
  res_type: String,
) -> Result(r, Err) {
  case
    req
    |> request.set_body(case req.body {
      None -> ""
      Some(body) -> json.to_string(body)
    })
    |> httpc.send
  {
    Error(err) -> Error(ErrHttpc(err))
    Ok(resp) ->
      case r4us_sansio.any_resp(resp, res_dec, res_type) {
        Ok(resource) -> Ok(resource)
        Error(err) ->
          Error(
            ErrSansio(case err {
              r4us_sansio.ErrParseJson(e) -> ErrParseJson(e)
              r4us_sansio.ErrNotJson(e) -> ErrNotJson(e)
              r4us_sansio.ErrOperationoutcome(e) -> ErrOperationoutcome(e)
            }),
          )
      }
  }
}

pub fn account_create(
  resource: r4us.Account,
  client: FhirClient,
) -> Result(r4us.Account, Err) {
  any_create(
    r4us.account_to_json(resource),
    "Account",
    r4us.account_decoder(),
    client,
  )
}

pub fn account_read(id: String, client: FhirClient) -> Result(r4us.Account, Err) {
  any_read(id, client, "Account", r4us.account_decoder())
}

pub fn account_update(
  resource: r4us.Account,
  client: FhirClient,
) -> Result(r4us.Account, Err) {
  any_update(
    resource.id,
    r4us.account_to_json(resource),
    "Account",
    r4us.account_decoder(),
    client,
  )
}

pub fn account_delete(
  resource: r4us.Account,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Account", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn account_search_bundled(sp: r4us_sansio.SpAccount, client: FhirClient) {
  let req = r4us_sansio.account_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn account_search(
  sp: r4us_sansio.SpAccount,
  client: FhirClient,
) -> Result(List(r4us.Account), Err) {
  let req = r4us_sansio.account_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.account
  })
}

pub fn activitydefinition_create(
  resource: r4us.Activitydefinition,
  client: FhirClient,
) -> Result(r4us.Activitydefinition, Err) {
  any_create(
    r4us.activitydefinition_to_json(resource),
    "ActivityDefinition",
    r4us.activitydefinition_decoder(),
    client,
  )
}

pub fn activitydefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Activitydefinition, Err) {
  any_read(id, client, "ActivityDefinition", r4us.activitydefinition_decoder())
}

pub fn activitydefinition_update(
  resource: r4us.Activitydefinition,
  client: FhirClient,
) -> Result(r4us.Activitydefinition, Err) {
  any_update(
    resource.id,
    r4us.activitydefinition_to_json(resource),
    "ActivityDefinition",
    r4us.activitydefinition_decoder(),
    client,
  )
}

pub fn activitydefinition_delete(
  resource: r4us.Activitydefinition,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Activitydefinition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn activitydefinition_search_bundled(
  sp: r4us_sansio.SpActivitydefinition,
  client: FhirClient,
) {
  let req = r4us_sansio.activitydefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn activitydefinition_search(
  sp: r4us_sansio.SpActivitydefinition,
  client: FhirClient,
) -> Result(List(r4us.Activitydefinition), Err) {
  let req = r4us_sansio.activitydefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.activitydefinition
  })
}

pub fn adverseevent_create(
  resource: r4us.Adverseevent,
  client: FhirClient,
) -> Result(r4us.Adverseevent, Err) {
  any_create(
    r4us.adverseevent_to_json(resource),
    "AdverseEvent",
    r4us.adverseevent_decoder(),
    client,
  )
}

pub fn adverseevent_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Adverseevent, Err) {
  any_read(id, client, "AdverseEvent", r4us.adverseevent_decoder())
}

pub fn adverseevent_update(
  resource: r4us.Adverseevent,
  client: FhirClient,
) -> Result(r4us.Adverseevent, Err) {
  any_update(
    resource.id,
    r4us.adverseevent_to_json(resource),
    "AdverseEvent",
    r4us.adverseevent_decoder(),
    client,
  )
}

pub fn adverseevent_delete(
  resource: r4us.Adverseevent,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Adverseevent", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn adverseevent_search_bundled(
  sp: r4us_sansio.SpAdverseevent,
  client: FhirClient,
) {
  let req = r4us_sansio.adverseevent_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn adverseevent_search(
  sp: r4us_sansio.SpAdverseevent,
  client: FhirClient,
) -> Result(List(r4us.Adverseevent), Err) {
  let req = r4us_sansio.adverseevent_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.adverseevent
  })
}

pub fn allergyintolerance_create(
  resource: r4us.Allergyintolerance,
  client: FhirClient,
) -> Result(r4us.Allergyintolerance, Err) {
  any_create(
    r4us.allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    r4us.allergyintolerance_decoder(),
    client,
  )
}

pub fn allergyintolerance_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Allergyintolerance, Err) {
  any_read(id, client, "AllergyIntolerance", r4us.allergyintolerance_decoder())
}

pub fn allergyintolerance_update(
  resource: r4us.Allergyintolerance,
  client: FhirClient,
) -> Result(r4us.Allergyintolerance, Err) {
  any_update(
    resource.id,
    r4us.allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    r4us.allergyintolerance_decoder(),
    client,
  )
}

pub fn allergyintolerance_delete(
  resource: r4us.Allergyintolerance,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Allergyintolerance", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn allergyintolerance_search_bundled(
  sp: r4us_sansio.SpAllergyintolerance,
  client: FhirClient,
) {
  let req = r4us_sansio.allergyintolerance_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn allergyintolerance_search(
  sp: r4us_sansio.SpAllergyintolerance,
  client: FhirClient,
) -> Result(List(r4us.Allergyintolerance), Err) {
  let req = r4us_sansio.allergyintolerance_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.allergyintolerance
  })
}

pub fn appointment_create(
  resource: r4us.Appointment,
  client: FhirClient,
) -> Result(r4us.Appointment, Err) {
  any_create(
    r4us.appointment_to_json(resource),
    "Appointment",
    r4us.appointment_decoder(),
    client,
  )
}

pub fn appointment_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Appointment, Err) {
  any_read(id, client, "Appointment", r4us.appointment_decoder())
}

pub fn appointment_update(
  resource: r4us.Appointment,
  client: FhirClient,
) -> Result(r4us.Appointment, Err) {
  any_update(
    resource.id,
    r4us.appointment_to_json(resource),
    "Appointment",
    r4us.appointment_decoder(),
    client,
  )
}

pub fn appointment_delete(
  resource: r4us.Appointment,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Appointment", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn appointment_search_bundled(
  sp: r4us_sansio.SpAppointment,
  client: FhirClient,
) {
  let req = r4us_sansio.appointment_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn appointment_search(
  sp: r4us_sansio.SpAppointment,
  client: FhirClient,
) -> Result(List(r4us.Appointment), Err) {
  let req = r4us_sansio.appointment_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.appointment
  })
}

pub fn appointmentresponse_create(
  resource: r4us.Appointmentresponse,
  client: FhirClient,
) -> Result(r4us.Appointmentresponse, Err) {
  any_create(
    r4us.appointmentresponse_to_json(resource),
    "AppointmentResponse",
    r4us.appointmentresponse_decoder(),
    client,
  )
}

pub fn appointmentresponse_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Appointmentresponse, Err) {
  any_read(
    id,
    client,
    "AppointmentResponse",
    r4us.appointmentresponse_decoder(),
  )
}

pub fn appointmentresponse_update(
  resource: r4us.Appointmentresponse,
  client: FhirClient,
) -> Result(r4us.Appointmentresponse, Err) {
  any_update(
    resource.id,
    r4us.appointmentresponse_to_json(resource),
    "AppointmentResponse",
    r4us.appointmentresponse_decoder(),
    client,
  )
}

pub fn appointmentresponse_delete(
  resource: r4us.Appointmentresponse,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Appointmentresponse", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn appointmentresponse_search_bundled(
  sp: r4us_sansio.SpAppointmentresponse,
  client: FhirClient,
) {
  let req = r4us_sansio.appointmentresponse_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn appointmentresponse_search(
  sp: r4us_sansio.SpAppointmentresponse,
  client: FhirClient,
) -> Result(List(r4us.Appointmentresponse), Err) {
  let req = r4us_sansio.appointmentresponse_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.appointmentresponse
  })
}

pub fn auditevent_create(
  resource: r4us.Auditevent,
  client: FhirClient,
) -> Result(r4us.Auditevent, Err) {
  any_create(
    r4us.auditevent_to_json(resource),
    "AuditEvent",
    r4us.auditevent_decoder(),
    client,
  )
}

pub fn auditevent_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Auditevent, Err) {
  any_read(id, client, "AuditEvent", r4us.auditevent_decoder())
}

pub fn auditevent_update(
  resource: r4us.Auditevent,
  client: FhirClient,
) -> Result(r4us.Auditevent, Err) {
  any_update(
    resource.id,
    r4us.auditevent_to_json(resource),
    "AuditEvent",
    r4us.auditevent_decoder(),
    client,
  )
}

pub fn auditevent_delete(
  resource: r4us.Auditevent,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Auditevent", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn auditevent_search_bundled(
  sp: r4us_sansio.SpAuditevent,
  client: FhirClient,
) {
  let req = r4us_sansio.auditevent_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn auditevent_search(
  sp: r4us_sansio.SpAuditevent,
  client: FhirClient,
) -> Result(List(r4us.Auditevent), Err) {
  let req = r4us_sansio.auditevent_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.auditevent
  })
}

pub fn basic_create(
  resource: r4us.Basic,
  client: FhirClient,
) -> Result(r4us.Basic, Err) {
  any_create(
    r4us.basic_to_json(resource),
    "Basic",
    r4us.basic_decoder(),
    client,
  )
}

pub fn basic_read(id: String, client: FhirClient) -> Result(r4us.Basic, Err) {
  any_read(id, client, "Basic", r4us.basic_decoder())
}

pub fn basic_update(
  resource: r4us.Basic,
  client: FhirClient,
) -> Result(r4us.Basic, Err) {
  any_update(
    resource.id,
    r4us.basic_to_json(resource),
    "Basic",
    r4us.basic_decoder(),
    client,
  )
}

pub fn basic_delete(
  resource: r4us.Basic,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Basic", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn basic_search_bundled(sp: r4us_sansio.SpBasic, client: FhirClient) {
  let req = r4us_sansio.basic_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn basic_search(
  sp: r4us_sansio.SpBasic,
  client: FhirClient,
) -> Result(List(r4us.Basic), Err) {
  let req = r4us_sansio.basic_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.basic
  })
}

pub fn binary_create(
  resource: r4us.Binary,
  client: FhirClient,
) -> Result(r4us.Binary, Err) {
  any_create(
    r4us.binary_to_json(resource),
    "Binary",
    r4us.binary_decoder(),
    client,
  )
}

pub fn binary_read(id: String, client: FhirClient) -> Result(r4us.Binary, Err) {
  any_read(id, client, "Binary", r4us.binary_decoder())
}

pub fn binary_update(
  resource: r4us.Binary,
  client: FhirClient,
) -> Result(r4us.Binary, Err) {
  any_update(
    resource.id,
    r4us.binary_to_json(resource),
    "Binary",
    r4us.binary_decoder(),
    client,
  )
}

pub fn binary_delete(
  resource: r4us.Binary,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Binary", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn binary_search_bundled(sp: r4us_sansio.SpBinary, client: FhirClient) {
  let req = r4us_sansio.binary_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn binary_search(
  sp: r4us_sansio.SpBinary,
  client: FhirClient,
) -> Result(List(r4us.Binary), Err) {
  let req = r4us_sansio.binary_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.binary
  })
}

pub fn biologicallyderivedproduct_create(
  resource: r4us.Biologicallyderivedproduct,
  client: FhirClient,
) -> Result(r4us.Biologicallyderivedproduct, Err) {
  any_create(
    r4us.biologicallyderivedproduct_to_json(resource),
    "BiologicallyDerivedProduct",
    r4us.biologicallyderivedproduct_decoder(),
    client,
  )
}

pub fn biologicallyderivedproduct_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Biologicallyderivedproduct, Err) {
  any_read(
    id,
    client,
    "BiologicallyDerivedProduct",
    r4us.biologicallyderivedproduct_decoder(),
  )
}

pub fn biologicallyderivedproduct_update(
  resource: r4us.Biologicallyderivedproduct,
  client: FhirClient,
) -> Result(r4us.Biologicallyderivedproduct, Err) {
  any_update(
    resource.id,
    r4us.biologicallyderivedproduct_to_json(resource),
    "BiologicallyDerivedProduct",
    r4us.biologicallyderivedproduct_decoder(),
    client,
  )
}

pub fn biologicallyderivedproduct_delete(
  resource: r4us.Biologicallyderivedproduct,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Biologicallyderivedproduct", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn biologicallyderivedproduct_search_bundled(
  sp: r4us_sansio.SpBiologicallyderivedproduct,
  client: FhirClient,
) {
  let req = r4us_sansio.biologicallyderivedproduct_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn biologicallyderivedproduct_search(
  sp: r4us_sansio.SpBiologicallyderivedproduct,
  client: FhirClient,
) -> Result(List(r4us.Biologicallyderivedproduct), Err) {
  let req = r4us_sansio.biologicallyderivedproduct_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.biologicallyderivedproduct
  })
}

pub fn bodystructure_create(
  resource: r4us.Bodystructure,
  client: FhirClient,
) -> Result(r4us.Bodystructure, Err) {
  any_create(
    r4us.bodystructure_to_json(resource),
    "BodyStructure",
    r4us.bodystructure_decoder(),
    client,
  )
}

pub fn bodystructure_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Bodystructure, Err) {
  any_read(id, client, "BodyStructure", r4us.bodystructure_decoder())
}

pub fn bodystructure_update(
  resource: r4us.Bodystructure,
  client: FhirClient,
) -> Result(r4us.Bodystructure, Err) {
  any_update(
    resource.id,
    r4us.bodystructure_to_json(resource),
    "BodyStructure",
    r4us.bodystructure_decoder(),
    client,
  )
}

pub fn bodystructure_delete(
  resource: r4us.Bodystructure,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Bodystructure", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn bodystructure_search_bundled(
  sp: r4us_sansio.SpBodystructure,
  client: FhirClient,
) {
  let req = r4us_sansio.bodystructure_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn bodystructure_search(
  sp: r4us_sansio.SpBodystructure,
  client: FhirClient,
) -> Result(List(r4us.Bodystructure), Err) {
  let req = r4us_sansio.bodystructure_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.bodystructure
  })
}

pub fn bundle_create(
  resource: r4us.Bundle,
  client: FhirClient,
) -> Result(r4us.Bundle, Err) {
  any_create(
    r4us.bundle_to_json(resource),
    "Bundle",
    r4us.bundle_decoder(),
    client,
  )
}

pub fn bundle_read(id: String, client: FhirClient) -> Result(r4us.Bundle, Err) {
  any_read(id, client, "Bundle", r4us.bundle_decoder())
}

pub fn bundle_update(
  resource: r4us.Bundle,
  client: FhirClient,
) -> Result(r4us.Bundle, Err) {
  any_update(
    resource.id,
    r4us.bundle_to_json(resource),
    "Bundle",
    r4us.bundle_decoder(),
    client,
  )
}

pub fn bundle_delete(
  resource: r4us.Bundle,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Bundle", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn bundle_search_bundled(sp: r4us_sansio.SpBundle, client: FhirClient) {
  let req = r4us_sansio.bundle_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn bundle_search(
  sp: r4us_sansio.SpBundle,
  client: FhirClient,
) -> Result(List(r4us.Bundle), Err) {
  let req = r4us_sansio.bundle_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.bundle
  })
}

pub fn capabilitystatement_create(
  resource: r4us.Capabilitystatement,
  client: FhirClient,
) -> Result(r4us.Capabilitystatement, Err) {
  any_create(
    r4us.capabilitystatement_to_json(resource),
    "CapabilityStatement",
    r4us.capabilitystatement_decoder(),
    client,
  )
}

pub fn capabilitystatement_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Capabilitystatement, Err) {
  any_read(
    id,
    client,
    "CapabilityStatement",
    r4us.capabilitystatement_decoder(),
  )
}

pub fn capabilitystatement_update(
  resource: r4us.Capabilitystatement,
  client: FhirClient,
) -> Result(r4us.Capabilitystatement, Err) {
  any_update(
    resource.id,
    r4us.capabilitystatement_to_json(resource),
    "CapabilityStatement",
    r4us.capabilitystatement_decoder(),
    client,
  )
}

pub fn capabilitystatement_delete(
  resource: r4us.Capabilitystatement,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Capabilitystatement", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn capabilitystatement_search_bundled(
  sp: r4us_sansio.SpCapabilitystatement,
  client: FhirClient,
) {
  let req = r4us_sansio.capabilitystatement_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn capabilitystatement_search(
  sp: r4us_sansio.SpCapabilitystatement,
  client: FhirClient,
) -> Result(List(r4us.Capabilitystatement), Err) {
  let req = r4us_sansio.capabilitystatement_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.capabilitystatement
  })
}

pub fn careplan_create(
  resource: r4us.Careplan,
  client: FhirClient,
) -> Result(r4us.Careplan, Err) {
  any_create(
    r4us.careplan_to_json(resource),
    "CarePlan",
    r4us.careplan_decoder(),
    client,
  )
}

pub fn careplan_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Careplan, Err) {
  any_read(id, client, "CarePlan", r4us.careplan_decoder())
}

pub fn careplan_update(
  resource: r4us.Careplan,
  client: FhirClient,
) -> Result(r4us.Careplan, Err) {
  any_update(
    resource.id,
    r4us.careplan_to_json(resource),
    "CarePlan",
    r4us.careplan_decoder(),
    client,
  )
}

pub fn careplan_delete(
  resource: r4us.Careplan,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Careplan", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn careplan_search_bundled(sp: r4us_sansio.SpCareplan, client: FhirClient) {
  let req = r4us_sansio.careplan_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn careplan_search(
  sp: r4us_sansio.SpCareplan,
  client: FhirClient,
) -> Result(List(r4us.Careplan), Err) {
  let req = r4us_sansio.careplan_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.careplan
  })
}

pub fn careteam_create(
  resource: r4us.Careteam,
  client: FhirClient,
) -> Result(r4us.Careteam, Err) {
  any_create(
    r4us.careteam_to_json(resource),
    "CareTeam",
    r4us.careteam_decoder(),
    client,
  )
}

pub fn careteam_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Careteam, Err) {
  any_read(id, client, "CareTeam", r4us.careteam_decoder())
}

pub fn careteam_update(
  resource: r4us.Careteam,
  client: FhirClient,
) -> Result(r4us.Careteam, Err) {
  any_update(
    resource.id,
    r4us.careteam_to_json(resource),
    "CareTeam",
    r4us.careteam_decoder(),
    client,
  )
}

pub fn careteam_delete(
  resource: r4us.Careteam,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Careteam", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn careteam_search_bundled(sp: r4us_sansio.SpCareteam, client: FhirClient) {
  let req = r4us_sansio.careteam_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn careteam_search(
  sp: r4us_sansio.SpCareteam,
  client: FhirClient,
) -> Result(List(r4us.Careteam), Err) {
  let req = r4us_sansio.careteam_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.careteam
  })
}

pub fn catalogentry_create(
  resource: r4us.Catalogentry,
  client: FhirClient,
) -> Result(r4us.Catalogentry, Err) {
  any_create(
    r4us.catalogentry_to_json(resource),
    "CatalogEntry",
    r4us.catalogentry_decoder(),
    client,
  )
}

pub fn catalogentry_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Catalogentry, Err) {
  any_read(id, client, "CatalogEntry", r4us.catalogentry_decoder())
}

pub fn catalogentry_update(
  resource: r4us.Catalogentry,
  client: FhirClient,
) -> Result(r4us.Catalogentry, Err) {
  any_update(
    resource.id,
    r4us.catalogentry_to_json(resource),
    "CatalogEntry",
    r4us.catalogentry_decoder(),
    client,
  )
}

pub fn catalogentry_delete(
  resource: r4us.Catalogentry,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Catalogentry", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn catalogentry_search_bundled(
  sp: r4us_sansio.SpCatalogentry,
  client: FhirClient,
) {
  let req = r4us_sansio.catalogentry_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn catalogentry_search(
  sp: r4us_sansio.SpCatalogentry,
  client: FhirClient,
) -> Result(List(r4us.Catalogentry), Err) {
  let req = r4us_sansio.catalogentry_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.catalogentry
  })
}

pub fn chargeitem_create(
  resource: r4us.Chargeitem,
  client: FhirClient,
) -> Result(r4us.Chargeitem, Err) {
  any_create(
    r4us.chargeitem_to_json(resource),
    "ChargeItem",
    r4us.chargeitem_decoder(),
    client,
  )
}

pub fn chargeitem_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Chargeitem, Err) {
  any_read(id, client, "ChargeItem", r4us.chargeitem_decoder())
}

pub fn chargeitem_update(
  resource: r4us.Chargeitem,
  client: FhirClient,
) -> Result(r4us.Chargeitem, Err) {
  any_update(
    resource.id,
    r4us.chargeitem_to_json(resource),
    "ChargeItem",
    r4us.chargeitem_decoder(),
    client,
  )
}

pub fn chargeitem_delete(
  resource: r4us.Chargeitem,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Chargeitem", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn chargeitem_search_bundled(
  sp: r4us_sansio.SpChargeitem,
  client: FhirClient,
) {
  let req = r4us_sansio.chargeitem_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn chargeitem_search(
  sp: r4us_sansio.SpChargeitem,
  client: FhirClient,
) -> Result(List(r4us.Chargeitem), Err) {
  let req = r4us_sansio.chargeitem_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.chargeitem
  })
}

pub fn chargeitemdefinition_create(
  resource: r4us.Chargeitemdefinition,
  client: FhirClient,
) -> Result(r4us.Chargeitemdefinition, Err) {
  any_create(
    r4us.chargeitemdefinition_to_json(resource),
    "ChargeItemDefinition",
    r4us.chargeitemdefinition_decoder(),
    client,
  )
}

pub fn chargeitemdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Chargeitemdefinition, Err) {
  any_read(
    id,
    client,
    "ChargeItemDefinition",
    r4us.chargeitemdefinition_decoder(),
  )
}

pub fn chargeitemdefinition_update(
  resource: r4us.Chargeitemdefinition,
  client: FhirClient,
) -> Result(r4us.Chargeitemdefinition, Err) {
  any_update(
    resource.id,
    r4us.chargeitemdefinition_to_json(resource),
    "ChargeItemDefinition",
    r4us.chargeitemdefinition_decoder(),
    client,
  )
}

pub fn chargeitemdefinition_delete(
  resource: r4us.Chargeitemdefinition,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Chargeitemdefinition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn chargeitemdefinition_search_bundled(
  sp: r4us_sansio.SpChargeitemdefinition,
  client: FhirClient,
) {
  let req = r4us_sansio.chargeitemdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn chargeitemdefinition_search(
  sp: r4us_sansio.SpChargeitemdefinition,
  client: FhirClient,
) -> Result(List(r4us.Chargeitemdefinition), Err) {
  let req = r4us_sansio.chargeitemdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.chargeitemdefinition
  })
}

pub fn claim_create(
  resource: r4us.Claim,
  client: FhirClient,
) -> Result(r4us.Claim, Err) {
  any_create(
    r4us.claim_to_json(resource),
    "Claim",
    r4us.claim_decoder(),
    client,
  )
}

pub fn claim_read(id: String, client: FhirClient) -> Result(r4us.Claim, Err) {
  any_read(id, client, "Claim", r4us.claim_decoder())
}

pub fn claim_update(
  resource: r4us.Claim,
  client: FhirClient,
) -> Result(r4us.Claim, Err) {
  any_update(
    resource.id,
    r4us.claim_to_json(resource),
    "Claim",
    r4us.claim_decoder(),
    client,
  )
}

pub fn claim_delete(
  resource: r4us.Claim,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Claim", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn claim_search_bundled(sp: r4us_sansio.SpClaim, client: FhirClient) {
  let req = r4us_sansio.claim_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn claim_search(
  sp: r4us_sansio.SpClaim,
  client: FhirClient,
) -> Result(List(r4us.Claim), Err) {
  let req = r4us_sansio.claim_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.claim
  })
}

pub fn claimresponse_create(
  resource: r4us.Claimresponse,
  client: FhirClient,
) -> Result(r4us.Claimresponse, Err) {
  any_create(
    r4us.claimresponse_to_json(resource),
    "ClaimResponse",
    r4us.claimresponse_decoder(),
    client,
  )
}

pub fn claimresponse_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Claimresponse, Err) {
  any_read(id, client, "ClaimResponse", r4us.claimresponse_decoder())
}

pub fn claimresponse_update(
  resource: r4us.Claimresponse,
  client: FhirClient,
) -> Result(r4us.Claimresponse, Err) {
  any_update(
    resource.id,
    r4us.claimresponse_to_json(resource),
    "ClaimResponse",
    r4us.claimresponse_decoder(),
    client,
  )
}

pub fn claimresponse_delete(
  resource: r4us.Claimresponse,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Claimresponse", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn claimresponse_search_bundled(
  sp: r4us_sansio.SpClaimresponse,
  client: FhirClient,
) {
  let req = r4us_sansio.claimresponse_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn claimresponse_search(
  sp: r4us_sansio.SpClaimresponse,
  client: FhirClient,
) -> Result(List(r4us.Claimresponse), Err) {
  let req = r4us_sansio.claimresponse_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.claimresponse
  })
}

pub fn clinicalimpression_create(
  resource: r4us.Clinicalimpression,
  client: FhirClient,
) -> Result(r4us.Clinicalimpression, Err) {
  any_create(
    r4us.clinicalimpression_to_json(resource),
    "ClinicalImpression",
    r4us.clinicalimpression_decoder(),
    client,
  )
}

pub fn clinicalimpression_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Clinicalimpression, Err) {
  any_read(id, client, "ClinicalImpression", r4us.clinicalimpression_decoder())
}

pub fn clinicalimpression_update(
  resource: r4us.Clinicalimpression,
  client: FhirClient,
) -> Result(r4us.Clinicalimpression, Err) {
  any_update(
    resource.id,
    r4us.clinicalimpression_to_json(resource),
    "ClinicalImpression",
    r4us.clinicalimpression_decoder(),
    client,
  )
}

pub fn clinicalimpression_delete(
  resource: r4us.Clinicalimpression,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Clinicalimpression", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn clinicalimpression_search_bundled(
  sp: r4us_sansio.SpClinicalimpression,
  client: FhirClient,
) {
  let req = r4us_sansio.clinicalimpression_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn clinicalimpression_search(
  sp: r4us_sansio.SpClinicalimpression,
  client: FhirClient,
) -> Result(List(r4us.Clinicalimpression), Err) {
  let req = r4us_sansio.clinicalimpression_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.clinicalimpression
  })
}

pub fn codesystem_create(
  resource: r4us.Codesystem,
  client: FhirClient,
) -> Result(r4us.Codesystem, Err) {
  any_create(
    r4us.codesystem_to_json(resource),
    "CodeSystem",
    r4us.codesystem_decoder(),
    client,
  )
}

pub fn codesystem_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Codesystem, Err) {
  any_read(id, client, "CodeSystem", r4us.codesystem_decoder())
}

pub fn codesystem_update(
  resource: r4us.Codesystem,
  client: FhirClient,
) -> Result(r4us.Codesystem, Err) {
  any_update(
    resource.id,
    r4us.codesystem_to_json(resource),
    "CodeSystem",
    r4us.codesystem_decoder(),
    client,
  )
}

pub fn codesystem_delete(
  resource: r4us.Codesystem,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Codesystem", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn codesystem_search_bundled(
  sp: r4us_sansio.SpCodesystem,
  client: FhirClient,
) {
  let req = r4us_sansio.codesystem_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn codesystem_search(
  sp: r4us_sansio.SpCodesystem,
  client: FhirClient,
) -> Result(List(r4us.Codesystem), Err) {
  let req = r4us_sansio.codesystem_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.codesystem
  })
}

pub fn communication_create(
  resource: r4us.Communication,
  client: FhirClient,
) -> Result(r4us.Communication, Err) {
  any_create(
    r4us.communication_to_json(resource),
    "Communication",
    r4us.communication_decoder(),
    client,
  )
}

pub fn communication_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Communication, Err) {
  any_read(id, client, "Communication", r4us.communication_decoder())
}

pub fn communication_update(
  resource: r4us.Communication,
  client: FhirClient,
) -> Result(r4us.Communication, Err) {
  any_update(
    resource.id,
    r4us.communication_to_json(resource),
    "Communication",
    r4us.communication_decoder(),
    client,
  )
}

pub fn communication_delete(
  resource: r4us.Communication,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Communication", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn communication_search_bundled(
  sp: r4us_sansio.SpCommunication,
  client: FhirClient,
) {
  let req = r4us_sansio.communication_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn communication_search(
  sp: r4us_sansio.SpCommunication,
  client: FhirClient,
) -> Result(List(r4us.Communication), Err) {
  let req = r4us_sansio.communication_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.communication
  })
}

pub fn communicationrequest_create(
  resource: r4us.Communicationrequest,
  client: FhirClient,
) -> Result(r4us.Communicationrequest, Err) {
  any_create(
    r4us.communicationrequest_to_json(resource),
    "CommunicationRequest",
    r4us.communicationrequest_decoder(),
    client,
  )
}

pub fn communicationrequest_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Communicationrequest, Err) {
  any_read(
    id,
    client,
    "CommunicationRequest",
    r4us.communicationrequest_decoder(),
  )
}

pub fn communicationrequest_update(
  resource: r4us.Communicationrequest,
  client: FhirClient,
) -> Result(r4us.Communicationrequest, Err) {
  any_update(
    resource.id,
    r4us.communicationrequest_to_json(resource),
    "CommunicationRequest",
    r4us.communicationrequest_decoder(),
    client,
  )
}

pub fn communicationrequest_delete(
  resource: r4us.Communicationrequest,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Communicationrequest", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn communicationrequest_search_bundled(
  sp: r4us_sansio.SpCommunicationrequest,
  client: FhirClient,
) {
  let req = r4us_sansio.communicationrequest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn communicationrequest_search(
  sp: r4us_sansio.SpCommunicationrequest,
  client: FhirClient,
) -> Result(List(r4us.Communicationrequest), Err) {
  let req = r4us_sansio.communicationrequest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.communicationrequest
  })
}

pub fn compartmentdefinition_create(
  resource: r4us.Compartmentdefinition,
  client: FhirClient,
) -> Result(r4us.Compartmentdefinition, Err) {
  any_create(
    r4us.compartmentdefinition_to_json(resource),
    "CompartmentDefinition",
    r4us.compartmentdefinition_decoder(),
    client,
  )
}

pub fn compartmentdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Compartmentdefinition, Err) {
  any_read(
    id,
    client,
    "CompartmentDefinition",
    r4us.compartmentdefinition_decoder(),
  )
}

pub fn compartmentdefinition_update(
  resource: r4us.Compartmentdefinition,
  client: FhirClient,
) -> Result(r4us.Compartmentdefinition, Err) {
  any_update(
    resource.id,
    r4us.compartmentdefinition_to_json(resource),
    "CompartmentDefinition",
    r4us.compartmentdefinition_decoder(),
    client,
  )
}

pub fn compartmentdefinition_delete(
  resource: r4us.Compartmentdefinition,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Compartmentdefinition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn compartmentdefinition_search_bundled(
  sp: r4us_sansio.SpCompartmentdefinition,
  client: FhirClient,
) {
  let req = r4us_sansio.compartmentdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn compartmentdefinition_search(
  sp: r4us_sansio.SpCompartmentdefinition,
  client: FhirClient,
) -> Result(List(r4us.Compartmentdefinition), Err) {
  let req = r4us_sansio.compartmentdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.compartmentdefinition
  })
}

pub fn composition_create(
  resource: r4us.Composition,
  client: FhirClient,
) -> Result(r4us.Composition, Err) {
  any_create(
    r4us.composition_to_json(resource),
    "Composition",
    r4us.composition_decoder(),
    client,
  )
}

pub fn composition_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Composition, Err) {
  any_read(id, client, "Composition", r4us.composition_decoder())
}

pub fn composition_update(
  resource: r4us.Composition,
  client: FhirClient,
) -> Result(r4us.Composition, Err) {
  any_update(
    resource.id,
    r4us.composition_to_json(resource),
    "Composition",
    r4us.composition_decoder(),
    client,
  )
}

pub fn composition_delete(
  resource: r4us.Composition,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Composition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn composition_search_bundled(
  sp: r4us_sansio.SpComposition,
  client: FhirClient,
) {
  let req = r4us_sansio.composition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn composition_search(
  sp: r4us_sansio.SpComposition,
  client: FhirClient,
) -> Result(List(r4us.Composition), Err) {
  let req = r4us_sansio.composition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.composition
  })
}

pub fn conceptmap_create(
  resource: r4us.Conceptmap,
  client: FhirClient,
) -> Result(r4us.Conceptmap, Err) {
  any_create(
    r4us.conceptmap_to_json(resource),
    "ConceptMap",
    r4us.conceptmap_decoder(),
    client,
  )
}

pub fn conceptmap_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Conceptmap, Err) {
  any_read(id, client, "ConceptMap", r4us.conceptmap_decoder())
}

pub fn conceptmap_update(
  resource: r4us.Conceptmap,
  client: FhirClient,
) -> Result(r4us.Conceptmap, Err) {
  any_update(
    resource.id,
    r4us.conceptmap_to_json(resource),
    "ConceptMap",
    r4us.conceptmap_decoder(),
    client,
  )
}

pub fn conceptmap_delete(
  resource: r4us.Conceptmap,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Conceptmap", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn conceptmap_search_bundled(
  sp: r4us_sansio.SpConceptmap,
  client: FhirClient,
) {
  let req = r4us_sansio.conceptmap_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn conceptmap_search(
  sp: r4us_sansio.SpConceptmap,
  client: FhirClient,
) -> Result(List(r4us.Conceptmap), Err) {
  let req = r4us_sansio.conceptmap_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.conceptmap
  })
}

pub fn condition_create(
  resource: r4us.Condition,
  client: FhirClient,
) -> Result(r4us.Condition, Err) {
  any_create(
    r4us.condition_to_json(resource),
    "Condition",
    r4us.condition_decoder(),
    client,
  )
}

pub fn condition_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Condition, Err) {
  any_read(id, client, "Condition", r4us.condition_decoder())
}

pub fn condition_update(
  resource: r4us.Condition,
  client: FhirClient,
) -> Result(r4us.Condition, Err) {
  any_update(
    resource.id,
    r4us.condition_to_json(resource),
    "Condition",
    r4us.condition_decoder(),
    client,
  )
}

pub fn condition_delete(
  resource: r4us.Condition,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Condition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn condition_search_bundled(sp: r4us_sansio.SpCondition, client: FhirClient) {
  let req = r4us_sansio.condition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn condition_search(
  sp: r4us_sansio.SpCondition,
  client: FhirClient,
) -> Result(List(r4us.Condition), Err) {
  let req = r4us_sansio.condition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.condition
  })
}

pub fn consent_create(
  resource: r4us.Consent,
  client: FhirClient,
) -> Result(r4us.Consent, Err) {
  any_create(
    r4us.consent_to_json(resource),
    "Consent",
    r4us.consent_decoder(),
    client,
  )
}

pub fn consent_read(id: String, client: FhirClient) -> Result(r4us.Consent, Err) {
  any_read(id, client, "Consent", r4us.consent_decoder())
}

pub fn consent_update(
  resource: r4us.Consent,
  client: FhirClient,
) -> Result(r4us.Consent, Err) {
  any_update(
    resource.id,
    r4us.consent_to_json(resource),
    "Consent",
    r4us.consent_decoder(),
    client,
  )
}

pub fn consent_delete(
  resource: r4us.Consent,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Consent", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn consent_search_bundled(sp: r4us_sansio.SpConsent, client: FhirClient) {
  let req = r4us_sansio.consent_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn consent_search(
  sp: r4us_sansio.SpConsent,
  client: FhirClient,
) -> Result(List(r4us.Consent), Err) {
  let req = r4us_sansio.consent_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.consent
  })
}

pub fn contract_create(
  resource: r4us.Contract,
  client: FhirClient,
) -> Result(r4us.Contract, Err) {
  any_create(
    r4us.contract_to_json(resource),
    "Contract",
    r4us.contract_decoder(),
    client,
  )
}

pub fn contract_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Contract, Err) {
  any_read(id, client, "Contract", r4us.contract_decoder())
}

pub fn contract_update(
  resource: r4us.Contract,
  client: FhirClient,
) -> Result(r4us.Contract, Err) {
  any_update(
    resource.id,
    r4us.contract_to_json(resource),
    "Contract",
    r4us.contract_decoder(),
    client,
  )
}

pub fn contract_delete(
  resource: r4us.Contract,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Contract", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn contract_search_bundled(sp: r4us_sansio.SpContract, client: FhirClient) {
  let req = r4us_sansio.contract_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn contract_search(
  sp: r4us_sansio.SpContract,
  client: FhirClient,
) -> Result(List(r4us.Contract), Err) {
  let req = r4us_sansio.contract_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.contract
  })
}

pub fn coverage_create(
  resource: r4us.Coverage,
  client: FhirClient,
) -> Result(r4us.Coverage, Err) {
  any_create(
    r4us.coverage_to_json(resource),
    "Coverage",
    r4us.coverage_decoder(),
    client,
  )
}

pub fn coverage_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Coverage, Err) {
  any_read(id, client, "Coverage", r4us.coverage_decoder())
}

pub fn coverage_update(
  resource: r4us.Coverage,
  client: FhirClient,
) -> Result(r4us.Coverage, Err) {
  any_update(
    resource.id,
    r4us.coverage_to_json(resource),
    "Coverage",
    r4us.coverage_decoder(),
    client,
  )
}

pub fn coverage_delete(
  resource: r4us.Coverage,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Coverage", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn coverage_search_bundled(sp: r4us_sansio.SpCoverage, client: FhirClient) {
  let req = r4us_sansio.coverage_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn coverage_search(
  sp: r4us_sansio.SpCoverage,
  client: FhirClient,
) -> Result(List(r4us.Coverage), Err) {
  let req = r4us_sansio.coverage_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.coverage
  })
}

pub fn coverageeligibilityrequest_create(
  resource: r4us.Coverageeligibilityrequest,
  client: FhirClient,
) -> Result(r4us.Coverageeligibilityrequest, Err) {
  any_create(
    r4us.coverageeligibilityrequest_to_json(resource),
    "CoverageEligibilityRequest",
    r4us.coverageeligibilityrequest_decoder(),
    client,
  )
}

pub fn coverageeligibilityrequest_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Coverageeligibilityrequest, Err) {
  any_read(
    id,
    client,
    "CoverageEligibilityRequest",
    r4us.coverageeligibilityrequest_decoder(),
  )
}

pub fn coverageeligibilityrequest_update(
  resource: r4us.Coverageeligibilityrequest,
  client: FhirClient,
) -> Result(r4us.Coverageeligibilityrequest, Err) {
  any_update(
    resource.id,
    r4us.coverageeligibilityrequest_to_json(resource),
    "CoverageEligibilityRequest",
    r4us.coverageeligibilityrequest_decoder(),
    client,
  )
}

pub fn coverageeligibilityrequest_delete(
  resource: r4us.Coverageeligibilityrequest,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Coverageeligibilityrequest", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn coverageeligibilityrequest_search_bundled(
  sp: r4us_sansio.SpCoverageeligibilityrequest,
  client: FhirClient,
) {
  let req = r4us_sansio.coverageeligibilityrequest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn coverageeligibilityrequest_search(
  sp: r4us_sansio.SpCoverageeligibilityrequest,
  client: FhirClient,
) -> Result(List(r4us.Coverageeligibilityrequest), Err) {
  let req = r4us_sansio.coverageeligibilityrequest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.coverageeligibilityrequest
  })
}

pub fn coverageeligibilityresponse_create(
  resource: r4us.Coverageeligibilityresponse,
  client: FhirClient,
) -> Result(r4us.Coverageeligibilityresponse, Err) {
  any_create(
    r4us.coverageeligibilityresponse_to_json(resource),
    "CoverageEligibilityResponse",
    r4us.coverageeligibilityresponse_decoder(),
    client,
  )
}

pub fn coverageeligibilityresponse_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Coverageeligibilityresponse, Err) {
  any_read(
    id,
    client,
    "CoverageEligibilityResponse",
    r4us.coverageeligibilityresponse_decoder(),
  )
}

pub fn coverageeligibilityresponse_update(
  resource: r4us.Coverageeligibilityresponse,
  client: FhirClient,
) -> Result(r4us.Coverageeligibilityresponse, Err) {
  any_update(
    resource.id,
    r4us.coverageeligibilityresponse_to_json(resource),
    "CoverageEligibilityResponse",
    r4us.coverageeligibilityresponse_decoder(),
    client,
  )
}

pub fn coverageeligibilityresponse_delete(
  resource: r4us.Coverageeligibilityresponse,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Coverageeligibilityresponse", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn coverageeligibilityresponse_search_bundled(
  sp: r4us_sansio.SpCoverageeligibilityresponse,
  client: FhirClient,
) {
  let req = r4us_sansio.coverageeligibilityresponse_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn coverageeligibilityresponse_search(
  sp: r4us_sansio.SpCoverageeligibilityresponse,
  client: FhirClient,
) -> Result(List(r4us.Coverageeligibilityresponse), Err) {
  let req = r4us_sansio.coverageeligibilityresponse_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.coverageeligibilityresponse
  })
}

pub fn detectedissue_create(
  resource: r4us.Detectedissue,
  client: FhirClient,
) -> Result(r4us.Detectedissue, Err) {
  any_create(
    r4us.detectedissue_to_json(resource),
    "DetectedIssue",
    r4us.detectedissue_decoder(),
    client,
  )
}

pub fn detectedissue_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Detectedissue, Err) {
  any_read(id, client, "DetectedIssue", r4us.detectedissue_decoder())
}

pub fn detectedissue_update(
  resource: r4us.Detectedissue,
  client: FhirClient,
) -> Result(r4us.Detectedissue, Err) {
  any_update(
    resource.id,
    r4us.detectedissue_to_json(resource),
    "DetectedIssue",
    r4us.detectedissue_decoder(),
    client,
  )
}

pub fn detectedissue_delete(
  resource: r4us.Detectedissue,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Detectedissue", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn detectedissue_search_bundled(
  sp: r4us_sansio.SpDetectedissue,
  client: FhirClient,
) {
  let req = r4us_sansio.detectedissue_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn detectedissue_search(
  sp: r4us_sansio.SpDetectedissue,
  client: FhirClient,
) -> Result(List(r4us.Detectedissue), Err) {
  let req = r4us_sansio.detectedissue_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.detectedissue
  })
}

pub fn device_create(
  resource: r4us.Device,
  client: FhirClient,
) -> Result(r4us.Device, Err) {
  any_create(
    r4us.device_to_json(resource),
    "Device",
    r4us.device_decoder(),
    client,
  )
}

pub fn device_read(id: String, client: FhirClient) -> Result(r4us.Device, Err) {
  any_read(id, client, "Device", r4us.device_decoder())
}

pub fn device_update(
  resource: r4us.Device,
  client: FhirClient,
) -> Result(r4us.Device, Err) {
  any_update(
    resource.id,
    r4us.device_to_json(resource),
    "Device",
    r4us.device_decoder(),
    client,
  )
}

pub fn device_delete(
  resource: r4us.Device,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Device", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn device_search_bundled(sp: r4us_sansio.SpDevice, client: FhirClient) {
  let req = r4us_sansio.device_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn device_search(
  sp: r4us_sansio.SpDevice,
  client: FhirClient,
) -> Result(List(r4us.Device), Err) {
  let req = r4us_sansio.device_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.device
  })
}

pub fn devicedefinition_create(
  resource: r4us.Devicedefinition,
  client: FhirClient,
) -> Result(r4us.Devicedefinition, Err) {
  any_create(
    r4us.devicedefinition_to_json(resource),
    "DeviceDefinition",
    r4us.devicedefinition_decoder(),
    client,
  )
}

pub fn devicedefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Devicedefinition, Err) {
  any_read(id, client, "DeviceDefinition", r4us.devicedefinition_decoder())
}

pub fn devicedefinition_update(
  resource: r4us.Devicedefinition,
  client: FhirClient,
) -> Result(r4us.Devicedefinition, Err) {
  any_update(
    resource.id,
    r4us.devicedefinition_to_json(resource),
    "DeviceDefinition",
    r4us.devicedefinition_decoder(),
    client,
  )
}

pub fn devicedefinition_delete(
  resource: r4us.Devicedefinition,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Devicedefinition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn devicedefinition_search_bundled(
  sp: r4us_sansio.SpDevicedefinition,
  client: FhirClient,
) {
  let req = r4us_sansio.devicedefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn devicedefinition_search(
  sp: r4us_sansio.SpDevicedefinition,
  client: FhirClient,
) -> Result(List(r4us.Devicedefinition), Err) {
  let req = r4us_sansio.devicedefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.devicedefinition
  })
}

pub fn devicemetric_create(
  resource: r4us.Devicemetric,
  client: FhirClient,
) -> Result(r4us.Devicemetric, Err) {
  any_create(
    r4us.devicemetric_to_json(resource),
    "DeviceMetric",
    r4us.devicemetric_decoder(),
    client,
  )
}

pub fn devicemetric_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Devicemetric, Err) {
  any_read(id, client, "DeviceMetric", r4us.devicemetric_decoder())
}

pub fn devicemetric_update(
  resource: r4us.Devicemetric,
  client: FhirClient,
) -> Result(r4us.Devicemetric, Err) {
  any_update(
    resource.id,
    r4us.devicemetric_to_json(resource),
    "DeviceMetric",
    r4us.devicemetric_decoder(),
    client,
  )
}

pub fn devicemetric_delete(
  resource: r4us.Devicemetric,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Devicemetric", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn devicemetric_search_bundled(
  sp: r4us_sansio.SpDevicemetric,
  client: FhirClient,
) {
  let req = r4us_sansio.devicemetric_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn devicemetric_search(
  sp: r4us_sansio.SpDevicemetric,
  client: FhirClient,
) -> Result(List(r4us.Devicemetric), Err) {
  let req = r4us_sansio.devicemetric_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.devicemetric
  })
}

pub fn devicerequest_create(
  resource: r4us.Devicerequest,
  client: FhirClient,
) -> Result(r4us.Devicerequest, Err) {
  any_create(
    r4us.devicerequest_to_json(resource),
    "DeviceRequest",
    r4us.devicerequest_decoder(),
    client,
  )
}

pub fn devicerequest_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Devicerequest, Err) {
  any_read(id, client, "DeviceRequest", r4us.devicerequest_decoder())
}

pub fn devicerequest_update(
  resource: r4us.Devicerequest,
  client: FhirClient,
) -> Result(r4us.Devicerequest, Err) {
  any_update(
    resource.id,
    r4us.devicerequest_to_json(resource),
    "DeviceRequest",
    r4us.devicerequest_decoder(),
    client,
  )
}

pub fn devicerequest_delete(
  resource: r4us.Devicerequest,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Devicerequest", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn devicerequest_search_bundled(
  sp: r4us_sansio.SpDevicerequest,
  client: FhirClient,
) {
  let req = r4us_sansio.devicerequest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn devicerequest_search(
  sp: r4us_sansio.SpDevicerequest,
  client: FhirClient,
) -> Result(List(r4us.Devicerequest), Err) {
  let req = r4us_sansio.devicerequest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.devicerequest
  })
}

pub fn deviceusestatement_create(
  resource: r4us.Deviceusestatement,
  client: FhirClient,
) -> Result(r4us.Deviceusestatement, Err) {
  any_create(
    r4us.deviceusestatement_to_json(resource),
    "DeviceUseStatement",
    r4us.deviceusestatement_decoder(),
    client,
  )
}

pub fn deviceusestatement_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Deviceusestatement, Err) {
  any_read(id, client, "DeviceUseStatement", r4us.deviceusestatement_decoder())
}

pub fn deviceusestatement_update(
  resource: r4us.Deviceusestatement,
  client: FhirClient,
) -> Result(r4us.Deviceusestatement, Err) {
  any_update(
    resource.id,
    r4us.deviceusestatement_to_json(resource),
    "DeviceUseStatement",
    r4us.deviceusestatement_decoder(),
    client,
  )
}

pub fn deviceusestatement_delete(
  resource: r4us.Deviceusestatement,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Deviceusestatement", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn deviceusestatement_search_bundled(
  sp: r4us_sansio.SpDeviceusestatement,
  client: FhirClient,
) {
  let req = r4us_sansio.deviceusestatement_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn deviceusestatement_search(
  sp: r4us_sansio.SpDeviceusestatement,
  client: FhirClient,
) -> Result(List(r4us.Deviceusestatement), Err) {
  let req = r4us_sansio.deviceusestatement_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.deviceusestatement
  })
}

pub fn diagnosticreport_create(
  resource: r4us.Diagnosticreport,
  client: FhirClient,
) -> Result(r4us.Diagnosticreport, Err) {
  any_create(
    r4us.diagnosticreport_to_json(resource),
    "DiagnosticReport",
    r4us.diagnosticreport_decoder(),
    client,
  )
}

pub fn diagnosticreport_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Diagnosticreport, Err) {
  any_read(id, client, "DiagnosticReport", r4us.diagnosticreport_decoder())
}

pub fn diagnosticreport_update(
  resource: r4us.Diagnosticreport,
  client: FhirClient,
) -> Result(r4us.Diagnosticreport, Err) {
  any_update(
    resource.id,
    r4us.diagnosticreport_to_json(resource),
    "DiagnosticReport",
    r4us.diagnosticreport_decoder(),
    client,
  )
}

pub fn diagnosticreport_delete(
  resource: r4us.Diagnosticreport,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Diagnosticreport", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn diagnosticreport_search_bundled(
  sp: r4us_sansio.SpDiagnosticreport,
  client: FhirClient,
) {
  let req = r4us_sansio.diagnosticreport_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn diagnosticreport_search(
  sp: r4us_sansio.SpDiagnosticreport,
  client: FhirClient,
) -> Result(List(r4us.Diagnosticreport), Err) {
  let req = r4us_sansio.diagnosticreport_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.diagnosticreport
  })
}

pub fn documentmanifest_create(
  resource: r4us.Documentmanifest,
  client: FhirClient,
) -> Result(r4us.Documentmanifest, Err) {
  any_create(
    r4us.documentmanifest_to_json(resource),
    "DocumentManifest",
    r4us.documentmanifest_decoder(),
    client,
  )
}

pub fn documentmanifest_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Documentmanifest, Err) {
  any_read(id, client, "DocumentManifest", r4us.documentmanifest_decoder())
}

pub fn documentmanifest_update(
  resource: r4us.Documentmanifest,
  client: FhirClient,
) -> Result(r4us.Documentmanifest, Err) {
  any_update(
    resource.id,
    r4us.documentmanifest_to_json(resource),
    "DocumentManifest",
    r4us.documentmanifest_decoder(),
    client,
  )
}

pub fn documentmanifest_delete(
  resource: r4us.Documentmanifest,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Documentmanifest", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn documentmanifest_search_bundled(
  sp: r4us_sansio.SpDocumentmanifest,
  client: FhirClient,
) {
  let req = r4us_sansio.documentmanifest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn documentmanifest_search(
  sp: r4us_sansio.SpDocumentmanifest,
  client: FhirClient,
) -> Result(List(r4us.Documentmanifest), Err) {
  let req = r4us_sansio.documentmanifest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.documentmanifest
  })
}

pub fn documentreference_create(
  resource: r4us.Documentreference,
  client: FhirClient,
) -> Result(r4us.Documentreference, Err) {
  any_create(
    r4us.documentreference_to_json(resource),
    "DocumentReference",
    r4us.documentreference_decoder(),
    client,
  )
}

pub fn documentreference_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Documentreference, Err) {
  any_read(id, client, "DocumentReference", r4us.documentreference_decoder())
}

pub fn documentreference_update(
  resource: r4us.Documentreference,
  client: FhirClient,
) -> Result(r4us.Documentreference, Err) {
  any_update(
    resource.id,
    r4us.documentreference_to_json(resource),
    "DocumentReference",
    r4us.documentreference_decoder(),
    client,
  )
}

pub fn documentreference_delete(
  resource: r4us.Documentreference,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Documentreference", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn documentreference_search_bundled(
  sp: r4us_sansio.SpDocumentreference,
  client: FhirClient,
) {
  let req = r4us_sansio.documentreference_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn documentreference_search(
  sp: r4us_sansio.SpDocumentreference,
  client: FhirClient,
) -> Result(List(r4us.Documentreference), Err) {
  let req = r4us_sansio.documentreference_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.documentreference
  })
}

pub fn effectevidencesynthesis_create(
  resource: r4us.Effectevidencesynthesis,
  client: FhirClient,
) -> Result(r4us.Effectevidencesynthesis, Err) {
  any_create(
    r4us.effectevidencesynthesis_to_json(resource),
    "EffectEvidenceSynthesis",
    r4us.effectevidencesynthesis_decoder(),
    client,
  )
}

pub fn effectevidencesynthesis_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Effectevidencesynthesis, Err) {
  any_read(
    id,
    client,
    "EffectEvidenceSynthesis",
    r4us.effectevidencesynthesis_decoder(),
  )
}

pub fn effectevidencesynthesis_update(
  resource: r4us.Effectevidencesynthesis,
  client: FhirClient,
) -> Result(r4us.Effectevidencesynthesis, Err) {
  any_update(
    resource.id,
    r4us.effectevidencesynthesis_to_json(resource),
    "EffectEvidenceSynthesis",
    r4us.effectevidencesynthesis_decoder(),
    client,
  )
}

pub fn effectevidencesynthesis_delete(
  resource: r4us.Effectevidencesynthesis,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Effectevidencesynthesis", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn effectevidencesynthesis_search_bundled(
  sp: r4us_sansio.SpEffectevidencesynthesis,
  client: FhirClient,
) {
  let req = r4us_sansio.effectevidencesynthesis_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn effectevidencesynthesis_search(
  sp: r4us_sansio.SpEffectevidencesynthesis,
  client: FhirClient,
) -> Result(List(r4us.Effectevidencesynthesis), Err) {
  let req = r4us_sansio.effectevidencesynthesis_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.effectevidencesynthesis
  })
}

pub fn encounter_create(
  resource: r4us.Encounter,
  client: FhirClient,
) -> Result(r4us.Encounter, Err) {
  any_create(
    r4us.encounter_to_json(resource),
    "Encounter",
    r4us.encounter_decoder(),
    client,
  )
}

pub fn encounter_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Encounter, Err) {
  any_read(id, client, "Encounter", r4us.encounter_decoder())
}

pub fn encounter_update(
  resource: r4us.Encounter,
  client: FhirClient,
) -> Result(r4us.Encounter, Err) {
  any_update(
    resource.id,
    r4us.encounter_to_json(resource),
    "Encounter",
    r4us.encounter_decoder(),
    client,
  )
}

pub fn encounter_delete(
  resource: r4us.Encounter,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Encounter", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn encounter_search_bundled(sp: r4us_sansio.SpEncounter, client: FhirClient) {
  let req = r4us_sansio.encounter_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn encounter_search(
  sp: r4us_sansio.SpEncounter,
  client: FhirClient,
) -> Result(List(r4us.Encounter), Err) {
  let req = r4us_sansio.encounter_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.encounter
  })
}

pub fn endpoint_create(
  resource: r4us.Endpoint,
  client: FhirClient,
) -> Result(r4us.Endpoint, Err) {
  any_create(
    r4us.endpoint_to_json(resource),
    "Endpoint",
    r4us.endpoint_decoder(),
    client,
  )
}

pub fn endpoint_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Endpoint, Err) {
  any_read(id, client, "Endpoint", r4us.endpoint_decoder())
}

pub fn endpoint_update(
  resource: r4us.Endpoint,
  client: FhirClient,
) -> Result(r4us.Endpoint, Err) {
  any_update(
    resource.id,
    r4us.endpoint_to_json(resource),
    "Endpoint",
    r4us.endpoint_decoder(),
    client,
  )
}

pub fn endpoint_delete(
  resource: r4us.Endpoint,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Endpoint", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn endpoint_search_bundled(sp: r4us_sansio.SpEndpoint, client: FhirClient) {
  let req = r4us_sansio.endpoint_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn endpoint_search(
  sp: r4us_sansio.SpEndpoint,
  client: FhirClient,
) -> Result(List(r4us.Endpoint), Err) {
  let req = r4us_sansio.endpoint_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.endpoint
  })
}

pub fn enrollmentrequest_create(
  resource: r4us.Enrollmentrequest,
  client: FhirClient,
) -> Result(r4us.Enrollmentrequest, Err) {
  any_create(
    r4us.enrollmentrequest_to_json(resource),
    "EnrollmentRequest",
    r4us.enrollmentrequest_decoder(),
    client,
  )
}

pub fn enrollmentrequest_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Enrollmentrequest, Err) {
  any_read(id, client, "EnrollmentRequest", r4us.enrollmentrequest_decoder())
}

pub fn enrollmentrequest_update(
  resource: r4us.Enrollmentrequest,
  client: FhirClient,
) -> Result(r4us.Enrollmentrequest, Err) {
  any_update(
    resource.id,
    r4us.enrollmentrequest_to_json(resource),
    "EnrollmentRequest",
    r4us.enrollmentrequest_decoder(),
    client,
  )
}

pub fn enrollmentrequest_delete(
  resource: r4us.Enrollmentrequest,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Enrollmentrequest", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn enrollmentrequest_search_bundled(
  sp: r4us_sansio.SpEnrollmentrequest,
  client: FhirClient,
) {
  let req = r4us_sansio.enrollmentrequest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn enrollmentrequest_search(
  sp: r4us_sansio.SpEnrollmentrequest,
  client: FhirClient,
) -> Result(List(r4us.Enrollmentrequest), Err) {
  let req = r4us_sansio.enrollmentrequest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.enrollmentrequest
  })
}

pub fn enrollmentresponse_create(
  resource: r4us.Enrollmentresponse,
  client: FhirClient,
) -> Result(r4us.Enrollmentresponse, Err) {
  any_create(
    r4us.enrollmentresponse_to_json(resource),
    "EnrollmentResponse",
    r4us.enrollmentresponse_decoder(),
    client,
  )
}

pub fn enrollmentresponse_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Enrollmentresponse, Err) {
  any_read(id, client, "EnrollmentResponse", r4us.enrollmentresponse_decoder())
}

pub fn enrollmentresponse_update(
  resource: r4us.Enrollmentresponse,
  client: FhirClient,
) -> Result(r4us.Enrollmentresponse, Err) {
  any_update(
    resource.id,
    r4us.enrollmentresponse_to_json(resource),
    "EnrollmentResponse",
    r4us.enrollmentresponse_decoder(),
    client,
  )
}

pub fn enrollmentresponse_delete(
  resource: r4us.Enrollmentresponse,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Enrollmentresponse", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn enrollmentresponse_search_bundled(
  sp: r4us_sansio.SpEnrollmentresponse,
  client: FhirClient,
) {
  let req = r4us_sansio.enrollmentresponse_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn enrollmentresponse_search(
  sp: r4us_sansio.SpEnrollmentresponse,
  client: FhirClient,
) -> Result(List(r4us.Enrollmentresponse), Err) {
  let req = r4us_sansio.enrollmentresponse_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.enrollmentresponse
  })
}

pub fn episodeofcare_create(
  resource: r4us.Episodeofcare,
  client: FhirClient,
) -> Result(r4us.Episodeofcare, Err) {
  any_create(
    r4us.episodeofcare_to_json(resource),
    "EpisodeOfCare",
    r4us.episodeofcare_decoder(),
    client,
  )
}

pub fn episodeofcare_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Episodeofcare, Err) {
  any_read(id, client, "EpisodeOfCare", r4us.episodeofcare_decoder())
}

pub fn episodeofcare_update(
  resource: r4us.Episodeofcare,
  client: FhirClient,
) -> Result(r4us.Episodeofcare, Err) {
  any_update(
    resource.id,
    r4us.episodeofcare_to_json(resource),
    "EpisodeOfCare",
    r4us.episodeofcare_decoder(),
    client,
  )
}

pub fn episodeofcare_delete(
  resource: r4us.Episodeofcare,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Episodeofcare", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn episodeofcare_search_bundled(
  sp: r4us_sansio.SpEpisodeofcare,
  client: FhirClient,
) {
  let req = r4us_sansio.episodeofcare_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn episodeofcare_search(
  sp: r4us_sansio.SpEpisodeofcare,
  client: FhirClient,
) -> Result(List(r4us.Episodeofcare), Err) {
  let req = r4us_sansio.episodeofcare_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.episodeofcare
  })
}

pub fn eventdefinition_create(
  resource: r4us.Eventdefinition,
  client: FhirClient,
) -> Result(r4us.Eventdefinition, Err) {
  any_create(
    r4us.eventdefinition_to_json(resource),
    "EventDefinition",
    r4us.eventdefinition_decoder(),
    client,
  )
}

pub fn eventdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Eventdefinition, Err) {
  any_read(id, client, "EventDefinition", r4us.eventdefinition_decoder())
}

pub fn eventdefinition_update(
  resource: r4us.Eventdefinition,
  client: FhirClient,
) -> Result(r4us.Eventdefinition, Err) {
  any_update(
    resource.id,
    r4us.eventdefinition_to_json(resource),
    "EventDefinition",
    r4us.eventdefinition_decoder(),
    client,
  )
}

pub fn eventdefinition_delete(
  resource: r4us.Eventdefinition,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Eventdefinition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn eventdefinition_search_bundled(
  sp: r4us_sansio.SpEventdefinition,
  client: FhirClient,
) {
  let req = r4us_sansio.eventdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn eventdefinition_search(
  sp: r4us_sansio.SpEventdefinition,
  client: FhirClient,
) -> Result(List(r4us.Eventdefinition), Err) {
  let req = r4us_sansio.eventdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.eventdefinition
  })
}

pub fn evidence_create(
  resource: r4us.Evidence,
  client: FhirClient,
) -> Result(r4us.Evidence, Err) {
  any_create(
    r4us.evidence_to_json(resource),
    "Evidence",
    r4us.evidence_decoder(),
    client,
  )
}

pub fn evidence_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Evidence, Err) {
  any_read(id, client, "Evidence", r4us.evidence_decoder())
}

pub fn evidence_update(
  resource: r4us.Evidence,
  client: FhirClient,
) -> Result(r4us.Evidence, Err) {
  any_update(
    resource.id,
    r4us.evidence_to_json(resource),
    "Evidence",
    r4us.evidence_decoder(),
    client,
  )
}

pub fn evidence_delete(
  resource: r4us.Evidence,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Evidence", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn evidence_search_bundled(sp: r4us_sansio.SpEvidence, client: FhirClient) {
  let req = r4us_sansio.evidence_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn evidence_search(
  sp: r4us_sansio.SpEvidence,
  client: FhirClient,
) -> Result(List(r4us.Evidence), Err) {
  let req = r4us_sansio.evidence_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.evidence
  })
}

pub fn evidencevariable_create(
  resource: r4us.Evidencevariable,
  client: FhirClient,
) -> Result(r4us.Evidencevariable, Err) {
  any_create(
    r4us.evidencevariable_to_json(resource),
    "EvidenceVariable",
    r4us.evidencevariable_decoder(),
    client,
  )
}

pub fn evidencevariable_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Evidencevariable, Err) {
  any_read(id, client, "EvidenceVariable", r4us.evidencevariable_decoder())
}

pub fn evidencevariable_update(
  resource: r4us.Evidencevariable,
  client: FhirClient,
) -> Result(r4us.Evidencevariable, Err) {
  any_update(
    resource.id,
    r4us.evidencevariable_to_json(resource),
    "EvidenceVariable",
    r4us.evidencevariable_decoder(),
    client,
  )
}

pub fn evidencevariable_delete(
  resource: r4us.Evidencevariable,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Evidencevariable", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn evidencevariable_search_bundled(
  sp: r4us_sansio.SpEvidencevariable,
  client: FhirClient,
) {
  let req = r4us_sansio.evidencevariable_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn evidencevariable_search(
  sp: r4us_sansio.SpEvidencevariable,
  client: FhirClient,
) -> Result(List(r4us.Evidencevariable), Err) {
  let req = r4us_sansio.evidencevariable_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.evidencevariable
  })
}

pub fn examplescenario_create(
  resource: r4us.Examplescenario,
  client: FhirClient,
) -> Result(r4us.Examplescenario, Err) {
  any_create(
    r4us.examplescenario_to_json(resource),
    "ExampleScenario",
    r4us.examplescenario_decoder(),
    client,
  )
}

pub fn examplescenario_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Examplescenario, Err) {
  any_read(id, client, "ExampleScenario", r4us.examplescenario_decoder())
}

pub fn examplescenario_update(
  resource: r4us.Examplescenario,
  client: FhirClient,
) -> Result(r4us.Examplescenario, Err) {
  any_update(
    resource.id,
    r4us.examplescenario_to_json(resource),
    "ExampleScenario",
    r4us.examplescenario_decoder(),
    client,
  )
}

pub fn examplescenario_delete(
  resource: r4us.Examplescenario,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Examplescenario", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn examplescenario_search_bundled(
  sp: r4us_sansio.SpExamplescenario,
  client: FhirClient,
) {
  let req = r4us_sansio.examplescenario_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn examplescenario_search(
  sp: r4us_sansio.SpExamplescenario,
  client: FhirClient,
) -> Result(List(r4us.Examplescenario), Err) {
  let req = r4us_sansio.examplescenario_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.examplescenario
  })
}

pub fn explanationofbenefit_create(
  resource: r4us.Explanationofbenefit,
  client: FhirClient,
) -> Result(r4us.Explanationofbenefit, Err) {
  any_create(
    r4us.explanationofbenefit_to_json(resource),
    "ExplanationOfBenefit",
    r4us.explanationofbenefit_decoder(),
    client,
  )
}

pub fn explanationofbenefit_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Explanationofbenefit, Err) {
  any_read(
    id,
    client,
    "ExplanationOfBenefit",
    r4us.explanationofbenefit_decoder(),
  )
}

pub fn explanationofbenefit_update(
  resource: r4us.Explanationofbenefit,
  client: FhirClient,
) -> Result(r4us.Explanationofbenefit, Err) {
  any_update(
    resource.id,
    r4us.explanationofbenefit_to_json(resource),
    "ExplanationOfBenefit",
    r4us.explanationofbenefit_decoder(),
    client,
  )
}

pub fn explanationofbenefit_delete(
  resource: r4us.Explanationofbenefit,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Explanationofbenefit", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn explanationofbenefit_search_bundled(
  sp: r4us_sansio.SpExplanationofbenefit,
  client: FhirClient,
) {
  let req = r4us_sansio.explanationofbenefit_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn explanationofbenefit_search(
  sp: r4us_sansio.SpExplanationofbenefit,
  client: FhirClient,
) -> Result(List(r4us.Explanationofbenefit), Err) {
  let req = r4us_sansio.explanationofbenefit_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.explanationofbenefit
  })
}

pub fn familymemberhistory_create(
  resource: r4us.Familymemberhistory,
  client: FhirClient,
) -> Result(r4us.Familymemberhistory, Err) {
  any_create(
    r4us.familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    r4us.familymemberhistory_decoder(),
    client,
  )
}

pub fn familymemberhistory_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Familymemberhistory, Err) {
  any_read(
    id,
    client,
    "FamilyMemberHistory",
    r4us.familymemberhistory_decoder(),
  )
}

pub fn familymemberhistory_update(
  resource: r4us.Familymemberhistory,
  client: FhirClient,
) -> Result(r4us.Familymemberhistory, Err) {
  any_update(
    resource.id,
    r4us.familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    r4us.familymemberhistory_decoder(),
    client,
  )
}

pub fn familymemberhistory_delete(
  resource: r4us.Familymemberhistory,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Familymemberhistory", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn familymemberhistory_search_bundled(
  sp: r4us_sansio.SpFamilymemberhistory,
  client: FhirClient,
) {
  let req = r4us_sansio.familymemberhistory_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn familymemberhistory_search(
  sp: r4us_sansio.SpFamilymemberhistory,
  client: FhirClient,
) -> Result(List(r4us.Familymemberhistory), Err) {
  let req = r4us_sansio.familymemberhistory_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.familymemberhistory
  })
}

pub fn flag_create(
  resource: r4us.Flag,
  client: FhirClient,
) -> Result(r4us.Flag, Err) {
  any_create(r4us.flag_to_json(resource), "Flag", r4us.flag_decoder(), client)
}

pub fn flag_read(id: String, client: FhirClient) -> Result(r4us.Flag, Err) {
  any_read(id, client, "Flag", r4us.flag_decoder())
}

pub fn flag_update(
  resource: r4us.Flag,
  client: FhirClient,
) -> Result(r4us.Flag, Err) {
  any_update(
    resource.id,
    r4us.flag_to_json(resource),
    "Flag",
    r4us.flag_decoder(),
    client,
  )
}

pub fn flag_delete(
  resource: r4us.Flag,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Flag", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn flag_search_bundled(sp: r4us_sansio.SpFlag, client: FhirClient) {
  let req = r4us_sansio.flag_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn flag_search(
  sp: r4us_sansio.SpFlag,
  client: FhirClient,
) -> Result(List(r4us.Flag), Err) {
  let req = r4us_sansio.flag_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.flag
  })
}

pub fn goal_create(
  resource: r4us.Goal,
  client: FhirClient,
) -> Result(r4us.Goal, Err) {
  any_create(r4us.goal_to_json(resource), "Goal", r4us.goal_decoder(), client)
}

pub fn goal_read(id: String, client: FhirClient) -> Result(r4us.Goal, Err) {
  any_read(id, client, "Goal", r4us.goal_decoder())
}

pub fn goal_update(
  resource: r4us.Goal,
  client: FhirClient,
) -> Result(r4us.Goal, Err) {
  any_update(
    resource.id,
    r4us.goal_to_json(resource),
    "Goal",
    r4us.goal_decoder(),
    client,
  )
}

pub fn goal_delete(
  resource: r4us.Goal,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Goal", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn goal_search_bundled(sp: r4us_sansio.SpGoal, client: FhirClient) {
  let req = r4us_sansio.goal_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn goal_search(
  sp: r4us_sansio.SpGoal,
  client: FhirClient,
) -> Result(List(r4us.Goal), Err) {
  let req = r4us_sansio.goal_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.goal
  })
}

pub fn graphdefinition_create(
  resource: r4us.Graphdefinition,
  client: FhirClient,
) -> Result(r4us.Graphdefinition, Err) {
  any_create(
    r4us.graphdefinition_to_json(resource),
    "GraphDefinition",
    r4us.graphdefinition_decoder(),
    client,
  )
}

pub fn graphdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Graphdefinition, Err) {
  any_read(id, client, "GraphDefinition", r4us.graphdefinition_decoder())
}

pub fn graphdefinition_update(
  resource: r4us.Graphdefinition,
  client: FhirClient,
) -> Result(r4us.Graphdefinition, Err) {
  any_update(
    resource.id,
    r4us.graphdefinition_to_json(resource),
    "GraphDefinition",
    r4us.graphdefinition_decoder(),
    client,
  )
}

pub fn graphdefinition_delete(
  resource: r4us.Graphdefinition,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Graphdefinition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn graphdefinition_search_bundled(
  sp: r4us_sansio.SpGraphdefinition,
  client: FhirClient,
) {
  let req = r4us_sansio.graphdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn graphdefinition_search(
  sp: r4us_sansio.SpGraphdefinition,
  client: FhirClient,
) -> Result(List(r4us.Graphdefinition), Err) {
  let req = r4us_sansio.graphdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.graphdefinition
  })
}

pub fn group_create(
  resource: r4us.Group,
  client: FhirClient,
) -> Result(r4us.Group, Err) {
  any_create(
    r4us.group_to_json(resource),
    "Group",
    r4us.group_decoder(),
    client,
  )
}

pub fn group_read(id: String, client: FhirClient) -> Result(r4us.Group, Err) {
  any_read(id, client, "Group", r4us.group_decoder())
}

pub fn group_update(
  resource: r4us.Group,
  client: FhirClient,
) -> Result(r4us.Group, Err) {
  any_update(
    resource.id,
    r4us.group_to_json(resource),
    "Group",
    r4us.group_decoder(),
    client,
  )
}

pub fn group_delete(
  resource: r4us.Group,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Group", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn group_search_bundled(sp: r4us_sansio.SpGroup, client: FhirClient) {
  let req = r4us_sansio.group_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn group_search(
  sp: r4us_sansio.SpGroup,
  client: FhirClient,
) -> Result(List(r4us.Group), Err) {
  let req = r4us_sansio.group_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.group
  })
}

pub fn guidanceresponse_create(
  resource: r4us.Guidanceresponse,
  client: FhirClient,
) -> Result(r4us.Guidanceresponse, Err) {
  any_create(
    r4us.guidanceresponse_to_json(resource),
    "GuidanceResponse",
    r4us.guidanceresponse_decoder(),
    client,
  )
}

pub fn guidanceresponse_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Guidanceresponse, Err) {
  any_read(id, client, "GuidanceResponse", r4us.guidanceresponse_decoder())
}

pub fn guidanceresponse_update(
  resource: r4us.Guidanceresponse,
  client: FhirClient,
) -> Result(r4us.Guidanceresponse, Err) {
  any_update(
    resource.id,
    r4us.guidanceresponse_to_json(resource),
    "GuidanceResponse",
    r4us.guidanceresponse_decoder(),
    client,
  )
}

pub fn guidanceresponse_delete(
  resource: r4us.Guidanceresponse,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Guidanceresponse", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn guidanceresponse_search_bundled(
  sp: r4us_sansio.SpGuidanceresponse,
  client: FhirClient,
) {
  let req = r4us_sansio.guidanceresponse_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn guidanceresponse_search(
  sp: r4us_sansio.SpGuidanceresponse,
  client: FhirClient,
) -> Result(List(r4us.Guidanceresponse), Err) {
  let req = r4us_sansio.guidanceresponse_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.guidanceresponse
  })
}

pub fn healthcareservice_create(
  resource: r4us.Healthcareservice,
  client: FhirClient,
) -> Result(r4us.Healthcareservice, Err) {
  any_create(
    r4us.healthcareservice_to_json(resource),
    "HealthcareService",
    r4us.healthcareservice_decoder(),
    client,
  )
}

pub fn healthcareservice_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Healthcareservice, Err) {
  any_read(id, client, "HealthcareService", r4us.healthcareservice_decoder())
}

pub fn healthcareservice_update(
  resource: r4us.Healthcareservice,
  client: FhirClient,
) -> Result(r4us.Healthcareservice, Err) {
  any_update(
    resource.id,
    r4us.healthcareservice_to_json(resource),
    "HealthcareService",
    r4us.healthcareservice_decoder(),
    client,
  )
}

pub fn healthcareservice_delete(
  resource: r4us.Healthcareservice,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Healthcareservice", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn healthcareservice_search_bundled(
  sp: r4us_sansio.SpHealthcareservice,
  client: FhirClient,
) {
  let req = r4us_sansio.healthcareservice_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn healthcareservice_search(
  sp: r4us_sansio.SpHealthcareservice,
  client: FhirClient,
) -> Result(List(r4us.Healthcareservice), Err) {
  let req = r4us_sansio.healthcareservice_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.healthcareservice
  })
}

pub fn imagingstudy_create(
  resource: r4us.Imagingstudy,
  client: FhirClient,
) -> Result(r4us.Imagingstudy, Err) {
  any_create(
    r4us.imagingstudy_to_json(resource),
    "ImagingStudy",
    r4us.imagingstudy_decoder(),
    client,
  )
}

pub fn imagingstudy_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Imagingstudy, Err) {
  any_read(id, client, "ImagingStudy", r4us.imagingstudy_decoder())
}

pub fn imagingstudy_update(
  resource: r4us.Imagingstudy,
  client: FhirClient,
) -> Result(r4us.Imagingstudy, Err) {
  any_update(
    resource.id,
    r4us.imagingstudy_to_json(resource),
    "ImagingStudy",
    r4us.imagingstudy_decoder(),
    client,
  )
}

pub fn imagingstudy_delete(
  resource: r4us.Imagingstudy,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Imagingstudy", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn imagingstudy_search_bundled(
  sp: r4us_sansio.SpImagingstudy,
  client: FhirClient,
) {
  let req = r4us_sansio.imagingstudy_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn imagingstudy_search(
  sp: r4us_sansio.SpImagingstudy,
  client: FhirClient,
) -> Result(List(r4us.Imagingstudy), Err) {
  let req = r4us_sansio.imagingstudy_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.imagingstudy
  })
}

pub fn immunization_create(
  resource: r4us.Immunization,
  client: FhirClient,
) -> Result(r4us.Immunization, Err) {
  any_create(
    r4us.immunization_to_json(resource),
    "Immunization",
    r4us.immunization_decoder(),
    client,
  )
}

pub fn immunization_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Immunization, Err) {
  any_read(id, client, "Immunization", r4us.immunization_decoder())
}

pub fn immunization_update(
  resource: r4us.Immunization,
  client: FhirClient,
) -> Result(r4us.Immunization, Err) {
  any_update(
    resource.id,
    r4us.immunization_to_json(resource),
    "Immunization",
    r4us.immunization_decoder(),
    client,
  )
}

pub fn immunization_delete(
  resource: r4us.Immunization,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Immunization", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn immunization_search_bundled(
  sp: r4us_sansio.SpImmunization,
  client: FhirClient,
) {
  let req = r4us_sansio.immunization_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn immunization_search(
  sp: r4us_sansio.SpImmunization,
  client: FhirClient,
) -> Result(List(r4us.Immunization), Err) {
  let req = r4us_sansio.immunization_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.immunization
  })
}

pub fn immunizationevaluation_create(
  resource: r4us.Immunizationevaluation,
  client: FhirClient,
) -> Result(r4us.Immunizationevaluation, Err) {
  any_create(
    r4us.immunizationevaluation_to_json(resource),
    "ImmunizationEvaluation",
    r4us.immunizationevaluation_decoder(),
    client,
  )
}

pub fn immunizationevaluation_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Immunizationevaluation, Err) {
  any_read(
    id,
    client,
    "ImmunizationEvaluation",
    r4us.immunizationevaluation_decoder(),
  )
}

pub fn immunizationevaluation_update(
  resource: r4us.Immunizationevaluation,
  client: FhirClient,
) -> Result(r4us.Immunizationevaluation, Err) {
  any_update(
    resource.id,
    r4us.immunizationevaluation_to_json(resource),
    "ImmunizationEvaluation",
    r4us.immunizationevaluation_decoder(),
    client,
  )
}

pub fn immunizationevaluation_delete(
  resource: r4us.Immunizationevaluation,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Immunizationevaluation", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn immunizationevaluation_search_bundled(
  sp: r4us_sansio.SpImmunizationevaluation,
  client: FhirClient,
) {
  let req = r4us_sansio.immunizationevaluation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn immunizationevaluation_search(
  sp: r4us_sansio.SpImmunizationevaluation,
  client: FhirClient,
) -> Result(List(r4us.Immunizationevaluation), Err) {
  let req = r4us_sansio.immunizationevaluation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.immunizationevaluation
  })
}

pub fn immunizationrecommendation_create(
  resource: r4us.Immunizationrecommendation,
  client: FhirClient,
) -> Result(r4us.Immunizationrecommendation, Err) {
  any_create(
    r4us.immunizationrecommendation_to_json(resource),
    "ImmunizationRecommendation",
    r4us.immunizationrecommendation_decoder(),
    client,
  )
}

pub fn immunizationrecommendation_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Immunizationrecommendation, Err) {
  any_read(
    id,
    client,
    "ImmunizationRecommendation",
    r4us.immunizationrecommendation_decoder(),
  )
}

pub fn immunizationrecommendation_update(
  resource: r4us.Immunizationrecommendation,
  client: FhirClient,
) -> Result(r4us.Immunizationrecommendation, Err) {
  any_update(
    resource.id,
    r4us.immunizationrecommendation_to_json(resource),
    "ImmunizationRecommendation",
    r4us.immunizationrecommendation_decoder(),
    client,
  )
}

pub fn immunizationrecommendation_delete(
  resource: r4us.Immunizationrecommendation,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Immunizationrecommendation", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn immunizationrecommendation_search_bundled(
  sp: r4us_sansio.SpImmunizationrecommendation,
  client: FhirClient,
) {
  let req = r4us_sansio.immunizationrecommendation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn immunizationrecommendation_search(
  sp: r4us_sansio.SpImmunizationrecommendation,
  client: FhirClient,
) -> Result(List(r4us.Immunizationrecommendation), Err) {
  let req = r4us_sansio.immunizationrecommendation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.immunizationrecommendation
  })
}

pub fn implementationguide_create(
  resource: r4us.Implementationguide,
  client: FhirClient,
) -> Result(r4us.Implementationguide, Err) {
  any_create(
    r4us.implementationguide_to_json(resource),
    "ImplementationGuide",
    r4us.implementationguide_decoder(),
    client,
  )
}

pub fn implementationguide_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Implementationguide, Err) {
  any_read(
    id,
    client,
    "ImplementationGuide",
    r4us.implementationguide_decoder(),
  )
}

pub fn implementationguide_update(
  resource: r4us.Implementationguide,
  client: FhirClient,
) -> Result(r4us.Implementationguide, Err) {
  any_update(
    resource.id,
    r4us.implementationguide_to_json(resource),
    "ImplementationGuide",
    r4us.implementationguide_decoder(),
    client,
  )
}

pub fn implementationguide_delete(
  resource: r4us.Implementationguide,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Implementationguide", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn implementationguide_search_bundled(
  sp: r4us_sansio.SpImplementationguide,
  client: FhirClient,
) {
  let req = r4us_sansio.implementationguide_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn implementationguide_search(
  sp: r4us_sansio.SpImplementationguide,
  client: FhirClient,
) -> Result(List(r4us.Implementationguide), Err) {
  let req = r4us_sansio.implementationguide_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.implementationguide
  })
}

pub fn insuranceplan_create(
  resource: r4us.Insuranceplan,
  client: FhirClient,
) -> Result(r4us.Insuranceplan, Err) {
  any_create(
    r4us.insuranceplan_to_json(resource),
    "InsurancePlan",
    r4us.insuranceplan_decoder(),
    client,
  )
}

pub fn insuranceplan_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Insuranceplan, Err) {
  any_read(id, client, "InsurancePlan", r4us.insuranceplan_decoder())
}

pub fn insuranceplan_update(
  resource: r4us.Insuranceplan,
  client: FhirClient,
) -> Result(r4us.Insuranceplan, Err) {
  any_update(
    resource.id,
    r4us.insuranceplan_to_json(resource),
    "InsurancePlan",
    r4us.insuranceplan_decoder(),
    client,
  )
}

pub fn insuranceplan_delete(
  resource: r4us.Insuranceplan,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Insuranceplan", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn insuranceplan_search_bundled(
  sp: r4us_sansio.SpInsuranceplan,
  client: FhirClient,
) {
  let req = r4us_sansio.insuranceplan_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn insuranceplan_search(
  sp: r4us_sansio.SpInsuranceplan,
  client: FhirClient,
) -> Result(List(r4us.Insuranceplan), Err) {
  let req = r4us_sansio.insuranceplan_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.insuranceplan
  })
}

pub fn invoice_create(
  resource: r4us.Invoice,
  client: FhirClient,
) -> Result(r4us.Invoice, Err) {
  any_create(
    r4us.invoice_to_json(resource),
    "Invoice",
    r4us.invoice_decoder(),
    client,
  )
}

pub fn invoice_read(id: String, client: FhirClient) -> Result(r4us.Invoice, Err) {
  any_read(id, client, "Invoice", r4us.invoice_decoder())
}

pub fn invoice_update(
  resource: r4us.Invoice,
  client: FhirClient,
) -> Result(r4us.Invoice, Err) {
  any_update(
    resource.id,
    r4us.invoice_to_json(resource),
    "Invoice",
    r4us.invoice_decoder(),
    client,
  )
}

pub fn invoice_delete(
  resource: r4us.Invoice,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Invoice", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn invoice_search_bundled(sp: r4us_sansio.SpInvoice, client: FhirClient) {
  let req = r4us_sansio.invoice_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn invoice_search(
  sp: r4us_sansio.SpInvoice,
  client: FhirClient,
) -> Result(List(r4us.Invoice), Err) {
  let req = r4us_sansio.invoice_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.invoice
  })
}

pub fn library_create(
  resource: r4us.Library,
  client: FhirClient,
) -> Result(r4us.Library, Err) {
  any_create(
    r4us.library_to_json(resource),
    "Library",
    r4us.library_decoder(),
    client,
  )
}

pub fn library_read(id: String, client: FhirClient) -> Result(r4us.Library, Err) {
  any_read(id, client, "Library", r4us.library_decoder())
}

pub fn library_update(
  resource: r4us.Library,
  client: FhirClient,
) -> Result(r4us.Library, Err) {
  any_update(
    resource.id,
    r4us.library_to_json(resource),
    "Library",
    r4us.library_decoder(),
    client,
  )
}

pub fn library_delete(
  resource: r4us.Library,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Library", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn library_search_bundled(sp: r4us_sansio.SpLibrary, client: FhirClient) {
  let req = r4us_sansio.library_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn library_search(
  sp: r4us_sansio.SpLibrary,
  client: FhirClient,
) -> Result(List(r4us.Library), Err) {
  let req = r4us_sansio.library_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.library
  })
}

pub fn linkage_create(
  resource: r4us.Linkage,
  client: FhirClient,
) -> Result(r4us.Linkage, Err) {
  any_create(
    r4us.linkage_to_json(resource),
    "Linkage",
    r4us.linkage_decoder(),
    client,
  )
}

pub fn linkage_read(id: String, client: FhirClient) -> Result(r4us.Linkage, Err) {
  any_read(id, client, "Linkage", r4us.linkage_decoder())
}

pub fn linkage_update(
  resource: r4us.Linkage,
  client: FhirClient,
) -> Result(r4us.Linkage, Err) {
  any_update(
    resource.id,
    r4us.linkage_to_json(resource),
    "Linkage",
    r4us.linkage_decoder(),
    client,
  )
}

pub fn linkage_delete(
  resource: r4us.Linkage,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Linkage", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn linkage_search_bundled(sp: r4us_sansio.SpLinkage, client: FhirClient) {
  let req = r4us_sansio.linkage_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn linkage_search(
  sp: r4us_sansio.SpLinkage,
  client: FhirClient,
) -> Result(List(r4us.Linkage), Err) {
  let req = r4us_sansio.linkage_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.linkage
  })
}

pub fn listfhir_create(
  resource: r4us.Listfhir,
  client: FhirClient,
) -> Result(r4us.Listfhir, Err) {
  any_create(
    r4us.listfhir_to_json(resource),
    "List",
    r4us.listfhir_decoder(),
    client,
  )
}

pub fn listfhir_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Listfhir, Err) {
  any_read(id, client, "List", r4us.listfhir_decoder())
}

pub fn listfhir_update(
  resource: r4us.Listfhir,
  client: FhirClient,
) -> Result(r4us.Listfhir, Err) {
  any_update(
    resource.id,
    r4us.listfhir_to_json(resource),
    "List",
    r4us.listfhir_decoder(),
    client,
  )
}

pub fn listfhir_delete(
  resource: r4us.Listfhir,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Listfhir", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn listfhir_search_bundled(sp: r4us_sansio.SpListfhir, client: FhirClient) {
  let req = r4us_sansio.listfhir_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn listfhir_search(
  sp: r4us_sansio.SpListfhir,
  client: FhirClient,
) -> Result(List(r4us.Listfhir), Err) {
  let req = r4us_sansio.listfhir_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.listfhir
  })
}

pub fn location_create(
  resource: r4us.Location,
  client: FhirClient,
) -> Result(r4us.Location, Err) {
  any_create(
    r4us.location_to_json(resource),
    "Location",
    r4us.location_decoder(),
    client,
  )
}

pub fn location_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Location, Err) {
  any_read(id, client, "Location", r4us.location_decoder())
}

pub fn location_update(
  resource: r4us.Location,
  client: FhirClient,
) -> Result(r4us.Location, Err) {
  any_update(
    resource.id,
    r4us.location_to_json(resource),
    "Location",
    r4us.location_decoder(),
    client,
  )
}

pub fn location_delete(
  resource: r4us.Location,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Location", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn location_search_bundled(sp: r4us_sansio.SpLocation, client: FhirClient) {
  let req = r4us_sansio.location_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn location_search(
  sp: r4us_sansio.SpLocation,
  client: FhirClient,
) -> Result(List(r4us.Location), Err) {
  let req = r4us_sansio.location_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.location
  })
}

pub fn measure_create(
  resource: r4us.Measure,
  client: FhirClient,
) -> Result(r4us.Measure, Err) {
  any_create(
    r4us.measure_to_json(resource),
    "Measure",
    r4us.measure_decoder(),
    client,
  )
}

pub fn measure_read(id: String, client: FhirClient) -> Result(r4us.Measure, Err) {
  any_read(id, client, "Measure", r4us.measure_decoder())
}

pub fn measure_update(
  resource: r4us.Measure,
  client: FhirClient,
) -> Result(r4us.Measure, Err) {
  any_update(
    resource.id,
    r4us.measure_to_json(resource),
    "Measure",
    r4us.measure_decoder(),
    client,
  )
}

pub fn measure_delete(
  resource: r4us.Measure,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Measure", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn measure_search_bundled(sp: r4us_sansio.SpMeasure, client: FhirClient) {
  let req = r4us_sansio.measure_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn measure_search(
  sp: r4us_sansio.SpMeasure,
  client: FhirClient,
) -> Result(List(r4us.Measure), Err) {
  let req = r4us_sansio.measure_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.measure
  })
}

pub fn measurereport_create(
  resource: r4us.Measurereport,
  client: FhirClient,
) -> Result(r4us.Measurereport, Err) {
  any_create(
    r4us.measurereport_to_json(resource),
    "MeasureReport",
    r4us.measurereport_decoder(),
    client,
  )
}

pub fn measurereport_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Measurereport, Err) {
  any_read(id, client, "MeasureReport", r4us.measurereport_decoder())
}

pub fn measurereport_update(
  resource: r4us.Measurereport,
  client: FhirClient,
) -> Result(r4us.Measurereport, Err) {
  any_update(
    resource.id,
    r4us.measurereport_to_json(resource),
    "MeasureReport",
    r4us.measurereport_decoder(),
    client,
  )
}

pub fn measurereport_delete(
  resource: r4us.Measurereport,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Measurereport", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn measurereport_search_bundled(
  sp: r4us_sansio.SpMeasurereport,
  client: FhirClient,
) {
  let req = r4us_sansio.measurereport_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn measurereport_search(
  sp: r4us_sansio.SpMeasurereport,
  client: FhirClient,
) -> Result(List(r4us.Measurereport), Err) {
  let req = r4us_sansio.measurereport_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.measurereport
  })
}

pub fn media_create(
  resource: r4us.Media,
  client: FhirClient,
) -> Result(r4us.Media, Err) {
  any_create(
    r4us.media_to_json(resource),
    "Media",
    r4us.media_decoder(),
    client,
  )
}

pub fn media_read(id: String, client: FhirClient) -> Result(r4us.Media, Err) {
  any_read(id, client, "Media", r4us.media_decoder())
}

pub fn media_update(
  resource: r4us.Media,
  client: FhirClient,
) -> Result(r4us.Media, Err) {
  any_update(
    resource.id,
    r4us.media_to_json(resource),
    "Media",
    r4us.media_decoder(),
    client,
  )
}

pub fn media_delete(
  resource: r4us.Media,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Media", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn media_search_bundled(sp: r4us_sansio.SpMedia, client: FhirClient) {
  let req = r4us_sansio.media_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn media_search(
  sp: r4us_sansio.SpMedia,
  client: FhirClient,
) -> Result(List(r4us.Media), Err) {
  let req = r4us_sansio.media_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.media
  })
}

pub fn medication_create(
  resource: r4us.Medication,
  client: FhirClient,
) -> Result(r4us.Medication, Err) {
  any_create(
    r4us.medication_to_json(resource),
    "Medication",
    r4us.medication_decoder(),
    client,
  )
}

pub fn medication_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Medication, Err) {
  any_read(id, client, "Medication", r4us.medication_decoder())
}

pub fn medication_update(
  resource: r4us.Medication,
  client: FhirClient,
) -> Result(r4us.Medication, Err) {
  any_update(
    resource.id,
    r4us.medication_to_json(resource),
    "Medication",
    r4us.medication_decoder(),
    client,
  )
}

pub fn medication_delete(
  resource: r4us.Medication,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medication", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medication_search_bundled(
  sp: r4us_sansio.SpMedication,
  client: FhirClient,
) {
  let req = r4us_sansio.medication_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn medication_search(
  sp: r4us_sansio.SpMedication,
  client: FhirClient,
) -> Result(List(r4us.Medication), Err) {
  let req = r4us_sansio.medication_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.medication
  })
}

pub fn medicationadministration_create(
  resource: r4us.Medicationadministration,
  client: FhirClient,
) -> Result(r4us.Medicationadministration, Err) {
  any_create(
    r4us.medicationadministration_to_json(resource),
    "MedicationAdministration",
    r4us.medicationadministration_decoder(),
    client,
  )
}

pub fn medicationadministration_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Medicationadministration, Err) {
  any_read(
    id,
    client,
    "MedicationAdministration",
    r4us.medicationadministration_decoder(),
  )
}

pub fn medicationadministration_update(
  resource: r4us.Medicationadministration,
  client: FhirClient,
) -> Result(r4us.Medicationadministration, Err) {
  any_update(
    resource.id,
    r4us.medicationadministration_to_json(resource),
    "MedicationAdministration",
    r4us.medicationadministration_decoder(),
    client,
  )
}

pub fn medicationadministration_delete(
  resource: r4us.Medicationadministration,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicationadministration", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicationadministration_search_bundled(
  sp: r4us_sansio.SpMedicationadministration,
  client: FhirClient,
) {
  let req = r4us_sansio.medicationadministration_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn medicationadministration_search(
  sp: r4us_sansio.SpMedicationadministration,
  client: FhirClient,
) -> Result(List(r4us.Medicationadministration), Err) {
  let req = r4us_sansio.medicationadministration_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.medicationadministration
  })
}

pub fn medicationdispense_create(
  resource: r4us.Medicationdispense,
  client: FhirClient,
) -> Result(r4us.Medicationdispense, Err) {
  any_create(
    r4us.medicationdispense_to_json(resource),
    "MedicationDispense",
    r4us.medicationdispense_decoder(),
    client,
  )
}

pub fn medicationdispense_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Medicationdispense, Err) {
  any_read(id, client, "MedicationDispense", r4us.medicationdispense_decoder())
}

pub fn medicationdispense_update(
  resource: r4us.Medicationdispense,
  client: FhirClient,
) -> Result(r4us.Medicationdispense, Err) {
  any_update(
    resource.id,
    r4us.medicationdispense_to_json(resource),
    "MedicationDispense",
    r4us.medicationdispense_decoder(),
    client,
  )
}

pub fn medicationdispense_delete(
  resource: r4us.Medicationdispense,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicationdispense", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicationdispense_search_bundled(
  sp: r4us_sansio.SpMedicationdispense,
  client: FhirClient,
) {
  let req = r4us_sansio.medicationdispense_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn medicationdispense_search(
  sp: r4us_sansio.SpMedicationdispense,
  client: FhirClient,
) -> Result(List(r4us.Medicationdispense), Err) {
  let req = r4us_sansio.medicationdispense_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.medicationdispense
  })
}

pub fn medicationknowledge_create(
  resource: r4us.Medicationknowledge,
  client: FhirClient,
) -> Result(r4us.Medicationknowledge, Err) {
  any_create(
    r4us.medicationknowledge_to_json(resource),
    "MedicationKnowledge",
    r4us.medicationknowledge_decoder(),
    client,
  )
}

pub fn medicationknowledge_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Medicationknowledge, Err) {
  any_read(
    id,
    client,
    "MedicationKnowledge",
    r4us.medicationknowledge_decoder(),
  )
}

pub fn medicationknowledge_update(
  resource: r4us.Medicationknowledge,
  client: FhirClient,
) -> Result(r4us.Medicationknowledge, Err) {
  any_update(
    resource.id,
    r4us.medicationknowledge_to_json(resource),
    "MedicationKnowledge",
    r4us.medicationknowledge_decoder(),
    client,
  )
}

pub fn medicationknowledge_delete(
  resource: r4us.Medicationknowledge,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicationknowledge", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicationknowledge_search_bundled(
  sp: r4us_sansio.SpMedicationknowledge,
  client: FhirClient,
) {
  let req = r4us_sansio.medicationknowledge_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn medicationknowledge_search(
  sp: r4us_sansio.SpMedicationknowledge,
  client: FhirClient,
) -> Result(List(r4us.Medicationknowledge), Err) {
  let req = r4us_sansio.medicationknowledge_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.medicationknowledge
  })
}

pub fn medicationrequest_create(
  resource: r4us.Medicationrequest,
  client: FhirClient,
) -> Result(r4us.Medicationrequest, Err) {
  any_create(
    r4us.medicationrequest_to_json(resource),
    "MedicationRequest",
    r4us.medicationrequest_decoder(),
    client,
  )
}

pub fn medicationrequest_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Medicationrequest, Err) {
  any_read(id, client, "MedicationRequest", r4us.medicationrequest_decoder())
}

pub fn medicationrequest_update(
  resource: r4us.Medicationrequest,
  client: FhirClient,
) -> Result(r4us.Medicationrequest, Err) {
  any_update(
    resource.id,
    r4us.medicationrequest_to_json(resource),
    "MedicationRequest",
    r4us.medicationrequest_decoder(),
    client,
  )
}

pub fn medicationrequest_delete(
  resource: r4us.Medicationrequest,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicationrequest", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicationrequest_search_bundled(
  sp: r4us_sansio.SpMedicationrequest,
  client: FhirClient,
) {
  let req = r4us_sansio.medicationrequest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn medicationrequest_search(
  sp: r4us_sansio.SpMedicationrequest,
  client: FhirClient,
) -> Result(List(r4us.Medicationrequest), Err) {
  let req = r4us_sansio.medicationrequest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.medicationrequest
  })
}

pub fn medicationstatement_create(
  resource: r4us.Medicationstatement,
  client: FhirClient,
) -> Result(r4us.Medicationstatement, Err) {
  any_create(
    r4us.medicationstatement_to_json(resource),
    "MedicationStatement",
    r4us.medicationstatement_decoder(),
    client,
  )
}

pub fn medicationstatement_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Medicationstatement, Err) {
  any_read(
    id,
    client,
    "MedicationStatement",
    r4us.medicationstatement_decoder(),
  )
}

pub fn medicationstatement_update(
  resource: r4us.Medicationstatement,
  client: FhirClient,
) -> Result(r4us.Medicationstatement, Err) {
  any_update(
    resource.id,
    r4us.medicationstatement_to_json(resource),
    "MedicationStatement",
    r4us.medicationstatement_decoder(),
    client,
  )
}

pub fn medicationstatement_delete(
  resource: r4us.Medicationstatement,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicationstatement", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicationstatement_search_bundled(
  sp: r4us_sansio.SpMedicationstatement,
  client: FhirClient,
) {
  let req = r4us_sansio.medicationstatement_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn medicationstatement_search(
  sp: r4us_sansio.SpMedicationstatement,
  client: FhirClient,
) -> Result(List(r4us.Medicationstatement), Err) {
  let req = r4us_sansio.medicationstatement_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.medicationstatement
  })
}

pub fn medicinalproduct_create(
  resource: r4us.Medicinalproduct,
  client: FhirClient,
) -> Result(r4us.Medicinalproduct, Err) {
  any_create(
    r4us.medicinalproduct_to_json(resource),
    "MedicinalProduct",
    r4us.medicinalproduct_decoder(),
    client,
  )
}

pub fn medicinalproduct_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Medicinalproduct, Err) {
  any_read(id, client, "MedicinalProduct", r4us.medicinalproduct_decoder())
}

pub fn medicinalproduct_update(
  resource: r4us.Medicinalproduct,
  client: FhirClient,
) -> Result(r4us.Medicinalproduct, Err) {
  any_update(
    resource.id,
    r4us.medicinalproduct_to_json(resource),
    "MedicinalProduct",
    r4us.medicinalproduct_decoder(),
    client,
  )
}

pub fn medicinalproduct_delete(
  resource: r4us.Medicinalproduct,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicinalproduct", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicinalproduct_search_bundled(
  sp: r4us_sansio.SpMedicinalproduct,
  client: FhirClient,
) {
  let req = r4us_sansio.medicinalproduct_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn medicinalproduct_search(
  sp: r4us_sansio.SpMedicinalproduct,
  client: FhirClient,
) -> Result(List(r4us.Medicinalproduct), Err) {
  let req = r4us_sansio.medicinalproduct_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.medicinalproduct
  })
}

pub fn medicinalproductauthorization_create(
  resource: r4us.Medicinalproductauthorization,
  client: FhirClient,
) -> Result(r4us.Medicinalproductauthorization, Err) {
  any_create(
    r4us.medicinalproductauthorization_to_json(resource),
    "MedicinalProductAuthorization",
    r4us.medicinalproductauthorization_decoder(),
    client,
  )
}

pub fn medicinalproductauthorization_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Medicinalproductauthorization, Err) {
  any_read(
    id,
    client,
    "MedicinalProductAuthorization",
    r4us.medicinalproductauthorization_decoder(),
  )
}

pub fn medicinalproductauthorization_update(
  resource: r4us.Medicinalproductauthorization,
  client: FhirClient,
) -> Result(r4us.Medicinalproductauthorization, Err) {
  any_update(
    resource.id,
    r4us.medicinalproductauthorization_to_json(resource),
    "MedicinalProductAuthorization",
    r4us.medicinalproductauthorization_decoder(),
    client,
  )
}

pub fn medicinalproductauthorization_delete(
  resource: r4us.Medicinalproductauthorization,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicinalproductauthorization", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicinalproductauthorization_search_bundled(
  sp: r4us_sansio.SpMedicinalproductauthorization,
  client: FhirClient,
) {
  let req = r4us_sansio.medicinalproductauthorization_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn medicinalproductauthorization_search(
  sp: r4us_sansio.SpMedicinalproductauthorization,
  client: FhirClient,
) -> Result(List(r4us.Medicinalproductauthorization), Err) {
  let req = r4us_sansio.medicinalproductauthorization_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.medicinalproductauthorization
  })
}

pub fn medicinalproductcontraindication_create(
  resource: r4us.Medicinalproductcontraindication,
  client: FhirClient,
) -> Result(r4us.Medicinalproductcontraindication, Err) {
  any_create(
    r4us.medicinalproductcontraindication_to_json(resource),
    "MedicinalProductContraindication",
    r4us.medicinalproductcontraindication_decoder(),
    client,
  )
}

pub fn medicinalproductcontraindication_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Medicinalproductcontraindication, Err) {
  any_read(
    id,
    client,
    "MedicinalProductContraindication",
    r4us.medicinalproductcontraindication_decoder(),
  )
}

pub fn medicinalproductcontraindication_update(
  resource: r4us.Medicinalproductcontraindication,
  client: FhirClient,
) -> Result(r4us.Medicinalproductcontraindication, Err) {
  any_update(
    resource.id,
    r4us.medicinalproductcontraindication_to_json(resource),
    "MedicinalProductContraindication",
    r4us.medicinalproductcontraindication_decoder(),
    client,
  )
}

pub fn medicinalproductcontraindication_delete(
  resource: r4us.Medicinalproductcontraindication,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicinalproductcontraindication", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicinalproductcontraindication_search_bundled(
  sp: r4us_sansio.SpMedicinalproductcontraindication,
  client: FhirClient,
) {
  let req = r4us_sansio.medicinalproductcontraindication_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn medicinalproductcontraindication_search(
  sp: r4us_sansio.SpMedicinalproductcontraindication,
  client: FhirClient,
) -> Result(List(r4us.Medicinalproductcontraindication), Err) {
  let req = r4us_sansio.medicinalproductcontraindication_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.medicinalproductcontraindication
  })
}

pub fn medicinalproductindication_create(
  resource: r4us.Medicinalproductindication,
  client: FhirClient,
) -> Result(r4us.Medicinalproductindication, Err) {
  any_create(
    r4us.medicinalproductindication_to_json(resource),
    "MedicinalProductIndication",
    r4us.medicinalproductindication_decoder(),
    client,
  )
}

pub fn medicinalproductindication_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Medicinalproductindication, Err) {
  any_read(
    id,
    client,
    "MedicinalProductIndication",
    r4us.medicinalproductindication_decoder(),
  )
}

pub fn medicinalproductindication_update(
  resource: r4us.Medicinalproductindication,
  client: FhirClient,
) -> Result(r4us.Medicinalproductindication, Err) {
  any_update(
    resource.id,
    r4us.medicinalproductindication_to_json(resource),
    "MedicinalProductIndication",
    r4us.medicinalproductindication_decoder(),
    client,
  )
}

pub fn medicinalproductindication_delete(
  resource: r4us.Medicinalproductindication,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicinalproductindication", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicinalproductindication_search_bundled(
  sp: r4us_sansio.SpMedicinalproductindication,
  client: FhirClient,
) {
  let req = r4us_sansio.medicinalproductindication_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn medicinalproductindication_search(
  sp: r4us_sansio.SpMedicinalproductindication,
  client: FhirClient,
) -> Result(List(r4us.Medicinalproductindication), Err) {
  let req = r4us_sansio.medicinalproductindication_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.medicinalproductindication
  })
}

pub fn medicinalproductingredient_create(
  resource: r4us.Medicinalproductingredient,
  client: FhirClient,
) -> Result(r4us.Medicinalproductingredient, Err) {
  any_create(
    r4us.medicinalproductingredient_to_json(resource),
    "MedicinalProductIngredient",
    r4us.medicinalproductingredient_decoder(),
    client,
  )
}

pub fn medicinalproductingredient_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Medicinalproductingredient, Err) {
  any_read(
    id,
    client,
    "MedicinalProductIngredient",
    r4us.medicinalproductingredient_decoder(),
  )
}

pub fn medicinalproductingredient_update(
  resource: r4us.Medicinalproductingredient,
  client: FhirClient,
) -> Result(r4us.Medicinalproductingredient, Err) {
  any_update(
    resource.id,
    r4us.medicinalproductingredient_to_json(resource),
    "MedicinalProductIngredient",
    r4us.medicinalproductingredient_decoder(),
    client,
  )
}

pub fn medicinalproductingredient_delete(
  resource: r4us.Medicinalproductingredient,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicinalproductingredient", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicinalproductingredient_search_bundled(
  sp: r4us_sansio.SpMedicinalproductingredient,
  client: FhirClient,
) {
  let req = r4us_sansio.medicinalproductingredient_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn medicinalproductingredient_search(
  sp: r4us_sansio.SpMedicinalproductingredient,
  client: FhirClient,
) -> Result(List(r4us.Medicinalproductingredient), Err) {
  let req = r4us_sansio.medicinalproductingredient_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.medicinalproductingredient
  })
}

pub fn medicinalproductinteraction_create(
  resource: r4us.Medicinalproductinteraction,
  client: FhirClient,
) -> Result(r4us.Medicinalproductinteraction, Err) {
  any_create(
    r4us.medicinalproductinteraction_to_json(resource),
    "MedicinalProductInteraction",
    r4us.medicinalproductinteraction_decoder(),
    client,
  )
}

pub fn medicinalproductinteraction_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Medicinalproductinteraction, Err) {
  any_read(
    id,
    client,
    "MedicinalProductInteraction",
    r4us.medicinalproductinteraction_decoder(),
  )
}

pub fn medicinalproductinteraction_update(
  resource: r4us.Medicinalproductinteraction,
  client: FhirClient,
) -> Result(r4us.Medicinalproductinteraction, Err) {
  any_update(
    resource.id,
    r4us.medicinalproductinteraction_to_json(resource),
    "MedicinalProductInteraction",
    r4us.medicinalproductinteraction_decoder(),
    client,
  )
}

pub fn medicinalproductinteraction_delete(
  resource: r4us.Medicinalproductinteraction,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicinalproductinteraction", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicinalproductinteraction_search_bundled(
  sp: r4us_sansio.SpMedicinalproductinteraction,
  client: FhirClient,
) {
  let req = r4us_sansio.medicinalproductinteraction_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn medicinalproductinteraction_search(
  sp: r4us_sansio.SpMedicinalproductinteraction,
  client: FhirClient,
) -> Result(List(r4us.Medicinalproductinteraction), Err) {
  let req = r4us_sansio.medicinalproductinteraction_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.medicinalproductinteraction
  })
}

pub fn medicinalproductmanufactured_create(
  resource: r4us.Medicinalproductmanufactured,
  client: FhirClient,
) -> Result(r4us.Medicinalproductmanufactured, Err) {
  any_create(
    r4us.medicinalproductmanufactured_to_json(resource),
    "MedicinalProductManufactured",
    r4us.medicinalproductmanufactured_decoder(),
    client,
  )
}

pub fn medicinalproductmanufactured_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Medicinalproductmanufactured, Err) {
  any_read(
    id,
    client,
    "MedicinalProductManufactured",
    r4us.medicinalproductmanufactured_decoder(),
  )
}

pub fn medicinalproductmanufactured_update(
  resource: r4us.Medicinalproductmanufactured,
  client: FhirClient,
) -> Result(r4us.Medicinalproductmanufactured, Err) {
  any_update(
    resource.id,
    r4us.medicinalproductmanufactured_to_json(resource),
    "MedicinalProductManufactured",
    r4us.medicinalproductmanufactured_decoder(),
    client,
  )
}

pub fn medicinalproductmanufactured_delete(
  resource: r4us.Medicinalproductmanufactured,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicinalproductmanufactured", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicinalproductmanufactured_search_bundled(
  sp: r4us_sansio.SpMedicinalproductmanufactured,
  client: FhirClient,
) {
  let req = r4us_sansio.medicinalproductmanufactured_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn medicinalproductmanufactured_search(
  sp: r4us_sansio.SpMedicinalproductmanufactured,
  client: FhirClient,
) -> Result(List(r4us.Medicinalproductmanufactured), Err) {
  let req = r4us_sansio.medicinalproductmanufactured_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.medicinalproductmanufactured
  })
}

pub fn medicinalproductpackaged_create(
  resource: r4us.Medicinalproductpackaged,
  client: FhirClient,
) -> Result(r4us.Medicinalproductpackaged, Err) {
  any_create(
    r4us.medicinalproductpackaged_to_json(resource),
    "MedicinalProductPackaged",
    r4us.medicinalproductpackaged_decoder(),
    client,
  )
}

pub fn medicinalproductpackaged_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Medicinalproductpackaged, Err) {
  any_read(
    id,
    client,
    "MedicinalProductPackaged",
    r4us.medicinalproductpackaged_decoder(),
  )
}

pub fn medicinalproductpackaged_update(
  resource: r4us.Medicinalproductpackaged,
  client: FhirClient,
) -> Result(r4us.Medicinalproductpackaged, Err) {
  any_update(
    resource.id,
    r4us.medicinalproductpackaged_to_json(resource),
    "MedicinalProductPackaged",
    r4us.medicinalproductpackaged_decoder(),
    client,
  )
}

pub fn medicinalproductpackaged_delete(
  resource: r4us.Medicinalproductpackaged,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicinalproductpackaged", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicinalproductpackaged_search_bundled(
  sp: r4us_sansio.SpMedicinalproductpackaged,
  client: FhirClient,
) {
  let req = r4us_sansio.medicinalproductpackaged_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn medicinalproductpackaged_search(
  sp: r4us_sansio.SpMedicinalproductpackaged,
  client: FhirClient,
) -> Result(List(r4us.Medicinalproductpackaged), Err) {
  let req = r4us_sansio.medicinalproductpackaged_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.medicinalproductpackaged
  })
}

pub fn medicinalproductpharmaceutical_create(
  resource: r4us.Medicinalproductpharmaceutical,
  client: FhirClient,
) -> Result(r4us.Medicinalproductpharmaceutical, Err) {
  any_create(
    r4us.medicinalproductpharmaceutical_to_json(resource),
    "MedicinalProductPharmaceutical",
    r4us.medicinalproductpharmaceutical_decoder(),
    client,
  )
}

pub fn medicinalproductpharmaceutical_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Medicinalproductpharmaceutical, Err) {
  any_read(
    id,
    client,
    "MedicinalProductPharmaceutical",
    r4us.medicinalproductpharmaceutical_decoder(),
  )
}

pub fn medicinalproductpharmaceutical_update(
  resource: r4us.Medicinalproductpharmaceutical,
  client: FhirClient,
) -> Result(r4us.Medicinalproductpharmaceutical, Err) {
  any_update(
    resource.id,
    r4us.medicinalproductpharmaceutical_to_json(resource),
    "MedicinalProductPharmaceutical",
    r4us.medicinalproductpharmaceutical_decoder(),
    client,
  )
}

pub fn medicinalproductpharmaceutical_delete(
  resource: r4us.Medicinalproductpharmaceutical,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicinalproductpharmaceutical", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicinalproductpharmaceutical_search_bundled(
  sp: r4us_sansio.SpMedicinalproductpharmaceutical,
  client: FhirClient,
) {
  let req = r4us_sansio.medicinalproductpharmaceutical_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn medicinalproductpharmaceutical_search(
  sp: r4us_sansio.SpMedicinalproductpharmaceutical,
  client: FhirClient,
) -> Result(List(r4us.Medicinalproductpharmaceutical), Err) {
  let req = r4us_sansio.medicinalproductpharmaceutical_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.medicinalproductpharmaceutical
  })
}

pub fn medicinalproductundesirableeffect_create(
  resource: r4us.Medicinalproductundesirableeffect,
  client: FhirClient,
) -> Result(r4us.Medicinalproductundesirableeffect, Err) {
  any_create(
    r4us.medicinalproductundesirableeffect_to_json(resource),
    "MedicinalProductUndesirableEffect",
    r4us.medicinalproductundesirableeffect_decoder(),
    client,
  )
}

pub fn medicinalproductundesirableeffect_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Medicinalproductundesirableeffect, Err) {
  any_read(
    id,
    client,
    "MedicinalProductUndesirableEffect",
    r4us.medicinalproductundesirableeffect_decoder(),
  )
}

pub fn medicinalproductundesirableeffect_update(
  resource: r4us.Medicinalproductundesirableeffect,
  client: FhirClient,
) -> Result(r4us.Medicinalproductundesirableeffect, Err) {
  any_update(
    resource.id,
    r4us.medicinalproductundesirableeffect_to_json(resource),
    "MedicinalProductUndesirableEffect",
    r4us.medicinalproductundesirableeffect_decoder(),
    client,
  )
}

pub fn medicinalproductundesirableeffect_delete(
  resource: r4us.Medicinalproductundesirableeffect,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicinalproductundesirableeffect", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicinalproductundesirableeffect_search_bundled(
  sp: r4us_sansio.SpMedicinalproductundesirableeffect,
  client: FhirClient,
) {
  let req = r4us_sansio.medicinalproductundesirableeffect_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn medicinalproductundesirableeffect_search(
  sp: r4us_sansio.SpMedicinalproductundesirableeffect,
  client: FhirClient,
) -> Result(List(r4us.Medicinalproductundesirableeffect), Err) {
  let req = r4us_sansio.medicinalproductundesirableeffect_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.medicinalproductundesirableeffect
  })
}

pub fn messagedefinition_create(
  resource: r4us.Messagedefinition,
  client: FhirClient,
) -> Result(r4us.Messagedefinition, Err) {
  any_create(
    r4us.messagedefinition_to_json(resource),
    "MessageDefinition",
    r4us.messagedefinition_decoder(),
    client,
  )
}

pub fn messagedefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Messagedefinition, Err) {
  any_read(id, client, "MessageDefinition", r4us.messagedefinition_decoder())
}

pub fn messagedefinition_update(
  resource: r4us.Messagedefinition,
  client: FhirClient,
) -> Result(r4us.Messagedefinition, Err) {
  any_update(
    resource.id,
    r4us.messagedefinition_to_json(resource),
    "MessageDefinition",
    r4us.messagedefinition_decoder(),
    client,
  )
}

pub fn messagedefinition_delete(
  resource: r4us.Messagedefinition,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Messagedefinition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn messagedefinition_search_bundled(
  sp: r4us_sansio.SpMessagedefinition,
  client: FhirClient,
) {
  let req = r4us_sansio.messagedefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn messagedefinition_search(
  sp: r4us_sansio.SpMessagedefinition,
  client: FhirClient,
) -> Result(List(r4us.Messagedefinition), Err) {
  let req = r4us_sansio.messagedefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.messagedefinition
  })
}

pub fn messageheader_create(
  resource: r4us.Messageheader,
  client: FhirClient,
) -> Result(r4us.Messageheader, Err) {
  any_create(
    r4us.messageheader_to_json(resource),
    "MessageHeader",
    r4us.messageheader_decoder(),
    client,
  )
}

pub fn messageheader_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Messageheader, Err) {
  any_read(id, client, "MessageHeader", r4us.messageheader_decoder())
}

pub fn messageheader_update(
  resource: r4us.Messageheader,
  client: FhirClient,
) -> Result(r4us.Messageheader, Err) {
  any_update(
    resource.id,
    r4us.messageheader_to_json(resource),
    "MessageHeader",
    r4us.messageheader_decoder(),
    client,
  )
}

pub fn messageheader_delete(
  resource: r4us.Messageheader,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Messageheader", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn messageheader_search_bundled(
  sp: r4us_sansio.SpMessageheader,
  client: FhirClient,
) {
  let req = r4us_sansio.messageheader_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn messageheader_search(
  sp: r4us_sansio.SpMessageheader,
  client: FhirClient,
) -> Result(List(r4us.Messageheader), Err) {
  let req = r4us_sansio.messageheader_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.messageheader
  })
}

pub fn molecularsequence_create(
  resource: r4us.Molecularsequence,
  client: FhirClient,
) -> Result(r4us.Molecularsequence, Err) {
  any_create(
    r4us.molecularsequence_to_json(resource),
    "MolecularSequence",
    r4us.molecularsequence_decoder(),
    client,
  )
}

pub fn molecularsequence_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Molecularsequence, Err) {
  any_read(id, client, "MolecularSequence", r4us.molecularsequence_decoder())
}

pub fn molecularsequence_update(
  resource: r4us.Molecularsequence,
  client: FhirClient,
) -> Result(r4us.Molecularsequence, Err) {
  any_update(
    resource.id,
    r4us.molecularsequence_to_json(resource),
    "MolecularSequence",
    r4us.molecularsequence_decoder(),
    client,
  )
}

pub fn molecularsequence_delete(
  resource: r4us.Molecularsequence,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Molecularsequence", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn molecularsequence_search_bundled(
  sp: r4us_sansio.SpMolecularsequence,
  client: FhirClient,
) {
  let req = r4us_sansio.molecularsequence_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn molecularsequence_search(
  sp: r4us_sansio.SpMolecularsequence,
  client: FhirClient,
) -> Result(List(r4us.Molecularsequence), Err) {
  let req = r4us_sansio.molecularsequence_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.molecularsequence
  })
}

pub fn namingsystem_create(
  resource: r4us.Namingsystem,
  client: FhirClient,
) -> Result(r4us.Namingsystem, Err) {
  any_create(
    r4us.namingsystem_to_json(resource),
    "NamingSystem",
    r4us.namingsystem_decoder(),
    client,
  )
}

pub fn namingsystem_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Namingsystem, Err) {
  any_read(id, client, "NamingSystem", r4us.namingsystem_decoder())
}

pub fn namingsystem_update(
  resource: r4us.Namingsystem,
  client: FhirClient,
) -> Result(r4us.Namingsystem, Err) {
  any_update(
    resource.id,
    r4us.namingsystem_to_json(resource),
    "NamingSystem",
    r4us.namingsystem_decoder(),
    client,
  )
}

pub fn namingsystem_delete(
  resource: r4us.Namingsystem,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Namingsystem", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn namingsystem_search_bundled(
  sp: r4us_sansio.SpNamingsystem,
  client: FhirClient,
) {
  let req = r4us_sansio.namingsystem_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn namingsystem_search(
  sp: r4us_sansio.SpNamingsystem,
  client: FhirClient,
) -> Result(List(r4us.Namingsystem), Err) {
  let req = r4us_sansio.namingsystem_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.namingsystem
  })
}

pub fn nutritionorder_create(
  resource: r4us.Nutritionorder,
  client: FhirClient,
) -> Result(r4us.Nutritionorder, Err) {
  any_create(
    r4us.nutritionorder_to_json(resource),
    "NutritionOrder",
    r4us.nutritionorder_decoder(),
    client,
  )
}

pub fn nutritionorder_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Nutritionorder, Err) {
  any_read(id, client, "NutritionOrder", r4us.nutritionorder_decoder())
}

pub fn nutritionorder_update(
  resource: r4us.Nutritionorder,
  client: FhirClient,
) -> Result(r4us.Nutritionorder, Err) {
  any_update(
    resource.id,
    r4us.nutritionorder_to_json(resource),
    "NutritionOrder",
    r4us.nutritionorder_decoder(),
    client,
  )
}

pub fn nutritionorder_delete(
  resource: r4us.Nutritionorder,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Nutritionorder", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn nutritionorder_search_bundled(
  sp: r4us_sansio.SpNutritionorder,
  client: FhirClient,
) {
  let req = r4us_sansio.nutritionorder_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn nutritionorder_search(
  sp: r4us_sansio.SpNutritionorder,
  client: FhirClient,
) -> Result(List(r4us.Nutritionorder), Err) {
  let req = r4us_sansio.nutritionorder_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.nutritionorder
  })
}

pub fn observation_create(
  resource: r4us.Observation,
  client: FhirClient,
) -> Result(r4us.Observation, Err) {
  any_create(
    r4us.observation_to_json(resource),
    "Observation",
    r4us.observation_decoder(),
    client,
  )
}

pub fn observation_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Observation, Err) {
  any_read(id, client, "Observation", r4us.observation_decoder())
}

pub fn observation_update(
  resource: r4us.Observation,
  client: FhirClient,
) -> Result(r4us.Observation, Err) {
  any_update(
    resource.id,
    r4us.observation_to_json(resource),
    "Observation",
    r4us.observation_decoder(),
    client,
  )
}

pub fn observation_delete(
  resource: r4us.Observation,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Observation", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn observation_search_bundled(
  sp: r4us_sansio.SpObservation,
  client: FhirClient,
) {
  let req = r4us_sansio.observation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn observation_search(
  sp: r4us_sansio.SpObservation,
  client: FhirClient,
) -> Result(List(r4us.Observation), Err) {
  let req = r4us_sansio.observation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.observation
  })
}

pub fn observationdefinition_create(
  resource: r4us.Observationdefinition,
  client: FhirClient,
) -> Result(r4us.Observationdefinition, Err) {
  any_create(
    r4us.observationdefinition_to_json(resource),
    "ObservationDefinition",
    r4us.observationdefinition_decoder(),
    client,
  )
}

pub fn observationdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Observationdefinition, Err) {
  any_read(
    id,
    client,
    "ObservationDefinition",
    r4us.observationdefinition_decoder(),
  )
}

pub fn observationdefinition_update(
  resource: r4us.Observationdefinition,
  client: FhirClient,
) -> Result(r4us.Observationdefinition, Err) {
  any_update(
    resource.id,
    r4us.observationdefinition_to_json(resource),
    "ObservationDefinition",
    r4us.observationdefinition_decoder(),
    client,
  )
}

pub fn observationdefinition_delete(
  resource: r4us.Observationdefinition,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Observationdefinition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn observationdefinition_search_bundled(
  sp: r4us_sansio.SpObservationdefinition,
  client: FhirClient,
) {
  let req = r4us_sansio.observationdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn observationdefinition_search(
  sp: r4us_sansio.SpObservationdefinition,
  client: FhirClient,
) -> Result(List(r4us.Observationdefinition), Err) {
  let req = r4us_sansio.observationdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.observationdefinition
  })
}

pub fn operationdefinition_create(
  resource: r4us.Operationdefinition,
  client: FhirClient,
) -> Result(r4us.Operationdefinition, Err) {
  any_create(
    r4us.operationdefinition_to_json(resource),
    "OperationDefinition",
    r4us.operationdefinition_decoder(),
    client,
  )
}

pub fn operationdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Operationdefinition, Err) {
  any_read(
    id,
    client,
    "OperationDefinition",
    r4us.operationdefinition_decoder(),
  )
}

pub fn operationdefinition_update(
  resource: r4us.Operationdefinition,
  client: FhirClient,
) -> Result(r4us.Operationdefinition, Err) {
  any_update(
    resource.id,
    r4us.operationdefinition_to_json(resource),
    "OperationDefinition",
    r4us.operationdefinition_decoder(),
    client,
  )
}

pub fn operationdefinition_delete(
  resource: r4us.Operationdefinition,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Operationdefinition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn operationdefinition_search_bundled(
  sp: r4us_sansio.SpOperationdefinition,
  client: FhirClient,
) {
  let req = r4us_sansio.operationdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn operationdefinition_search(
  sp: r4us_sansio.SpOperationdefinition,
  client: FhirClient,
) -> Result(List(r4us.Operationdefinition), Err) {
  let req = r4us_sansio.operationdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.operationdefinition
  })
}

pub fn operationoutcome_create(
  resource: r4us.Operationoutcome,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_create(
    r4us.operationoutcome_to_json(resource),
    "OperationOutcome",
    r4us.operationoutcome_decoder(),
    client,
  )
}

pub fn operationoutcome_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_read(id, client, "OperationOutcome", r4us.operationoutcome_decoder())
}

pub fn operationoutcome_update(
  resource: r4us.Operationoutcome,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_update(
    resource.id,
    r4us.operationoutcome_to_json(resource),
    "OperationOutcome",
    r4us.operationoutcome_decoder(),
    client,
  )
}

pub fn operationoutcome_delete(
  resource: r4us.Operationoutcome,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Operationoutcome", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn operationoutcome_search_bundled(
  sp: r4us_sansio.SpOperationoutcome,
  client: FhirClient,
) {
  let req = r4us_sansio.operationoutcome_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn operationoutcome_search(
  sp: r4us_sansio.SpOperationoutcome,
  client: FhirClient,
) -> Result(List(r4us.Operationoutcome), Err) {
  let req = r4us_sansio.operationoutcome_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.operationoutcome
  })
}

pub fn organization_create(
  resource: r4us.Organization,
  client: FhirClient,
) -> Result(r4us.Organization, Err) {
  any_create(
    r4us.organization_to_json(resource),
    "Organization",
    r4us.organization_decoder(),
    client,
  )
}

pub fn organization_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Organization, Err) {
  any_read(id, client, "Organization", r4us.organization_decoder())
}

pub fn organization_update(
  resource: r4us.Organization,
  client: FhirClient,
) -> Result(r4us.Organization, Err) {
  any_update(
    resource.id,
    r4us.organization_to_json(resource),
    "Organization",
    r4us.organization_decoder(),
    client,
  )
}

pub fn organization_delete(
  resource: r4us.Organization,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Organization", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn organization_search_bundled(
  sp: r4us_sansio.SpOrganization,
  client: FhirClient,
) {
  let req = r4us_sansio.organization_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn organization_search(
  sp: r4us_sansio.SpOrganization,
  client: FhirClient,
) -> Result(List(r4us.Organization), Err) {
  let req = r4us_sansio.organization_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.organization
  })
}

pub fn organizationaffiliation_create(
  resource: r4us.Organizationaffiliation,
  client: FhirClient,
) -> Result(r4us.Organizationaffiliation, Err) {
  any_create(
    r4us.organizationaffiliation_to_json(resource),
    "OrganizationAffiliation",
    r4us.organizationaffiliation_decoder(),
    client,
  )
}

pub fn organizationaffiliation_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Organizationaffiliation, Err) {
  any_read(
    id,
    client,
    "OrganizationAffiliation",
    r4us.organizationaffiliation_decoder(),
  )
}

pub fn organizationaffiliation_update(
  resource: r4us.Organizationaffiliation,
  client: FhirClient,
) -> Result(r4us.Organizationaffiliation, Err) {
  any_update(
    resource.id,
    r4us.organizationaffiliation_to_json(resource),
    "OrganizationAffiliation",
    r4us.organizationaffiliation_decoder(),
    client,
  )
}

pub fn organizationaffiliation_delete(
  resource: r4us.Organizationaffiliation,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Organizationaffiliation", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn organizationaffiliation_search_bundled(
  sp: r4us_sansio.SpOrganizationaffiliation,
  client: FhirClient,
) {
  let req = r4us_sansio.organizationaffiliation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn organizationaffiliation_search(
  sp: r4us_sansio.SpOrganizationaffiliation,
  client: FhirClient,
) -> Result(List(r4us.Organizationaffiliation), Err) {
  let req = r4us_sansio.organizationaffiliation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.organizationaffiliation
  })
}

pub fn patient_create(
  resource: r4us.Patient,
  client: FhirClient,
) -> Result(r4us.Patient, Err) {
  any_create(
    r4us.patient_to_json(resource),
    "Patient",
    r4us.patient_decoder(),
    client,
  )
}

pub fn patient_read(id: String, client: FhirClient) -> Result(r4us.Patient, Err) {
  any_read(id, client, "Patient", r4us.patient_decoder())
}

pub fn patient_update(
  resource: r4us.Patient,
  client: FhirClient,
) -> Result(r4us.Patient, Err) {
  any_update(
    resource.id,
    r4us.patient_to_json(resource),
    "Patient",
    r4us.patient_decoder(),
    client,
  )
}

pub fn patient_delete(
  resource: r4us.Patient,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Patient", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn patient_search_bundled(sp: r4us_sansio.SpPatient, client: FhirClient) {
  let req = r4us_sansio.patient_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn patient_search(
  sp: r4us_sansio.SpPatient,
  client: FhirClient,
) -> Result(List(r4us.Patient), Err) {
  let req = r4us_sansio.patient_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.patient
  })
}

pub fn paymentnotice_create(
  resource: r4us.Paymentnotice,
  client: FhirClient,
) -> Result(r4us.Paymentnotice, Err) {
  any_create(
    r4us.paymentnotice_to_json(resource),
    "PaymentNotice",
    r4us.paymentnotice_decoder(),
    client,
  )
}

pub fn paymentnotice_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Paymentnotice, Err) {
  any_read(id, client, "PaymentNotice", r4us.paymentnotice_decoder())
}

pub fn paymentnotice_update(
  resource: r4us.Paymentnotice,
  client: FhirClient,
) -> Result(r4us.Paymentnotice, Err) {
  any_update(
    resource.id,
    r4us.paymentnotice_to_json(resource),
    "PaymentNotice",
    r4us.paymentnotice_decoder(),
    client,
  )
}

pub fn paymentnotice_delete(
  resource: r4us.Paymentnotice,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Paymentnotice", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn paymentnotice_search_bundled(
  sp: r4us_sansio.SpPaymentnotice,
  client: FhirClient,
) {
  let req = r4us_sansio.paymentnotice_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn paymentnotice_search(
  sp: r4us_sansio.SpPaymentnotice,
  client: FhirClient,
) -> Result(List(r4us.Paymentnotice), Err) {
  let req = r4us_sansio.paymentnotice_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.paymentnotice
  })
}

pub fn paymentreconciliation_create(
  resource: r4us.Paymentreconciliation,
  client: FhirClient,
) -> Result(r4us.Paymentreconciliation, Err) {
  any_create(
    r4us.paymentreconciliation_to_json(resource),
    "PaymentReconciliation",
    r4us.paymentreconciliation_decoder(),
    client,
  )
}

pub fn paymentreconciliation_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Paymentreconciliation, Err) {
  any_read(
    id,
    client,
    "PaymentReconciliation",
    r4us.paymentreconciliation_decoder(),
  )
}

pub fn paymentreconciliation_update(
  resource: r4us.Paymentreconciliation,
  client: FhirClient,
) -> Result(r4us.Paymentreconciliation, Err) {
  any_update(
    resource.id,
    r4us.paymentreconciliation_to_json(resource),
    "PaymentReconciliation",
    r4us.paymentreconciliation_decoder(),
    client,
  )
}

pub fn paymentreconciliation_delete(
  resource: r4us.Paymentreconciliation,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Paymentreconciliation", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn paymentreconciliation_search_bundled(
  sp: r4us_sansio.SpPaymentreconciliation,
  client: FhirClient,
) {
  let req = r4us_sansio.paymentreconciliation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn paymentreconciliation_search(
  sp: r4us_sansio.SpPaymentreconciliation,
  client: FhirClient,
) -> Result(List(r4us.Paymentreconciliation), Err) {
  let req = r4us_sansio.paymentreconciliation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.paymentreconciliation
  })
}

pub fn person_create(
  resource: r4us.Person,
  client: FhirClient,
) -> Result(r4us.Person, Err) {
  any_create(
    r4us.person_to_json(resource),
    "Person",
    r4us.person_decoder(),
    client,
  )
}

pub fn person_read(id: String, client: FhirClient) -> Result(r4us.Person, Err) {
  any_read(id, client, "Person", r4us.person_decoder())
}

pub fn person_update(
  resource: r4us.Person,
  client: FhirClient,
) -> Result(r4us.Person, Err) {
  any_update(
    resource.id,
    r4us.person_to_json(resource),
    "Person",
    r4us.person_decoder(),
    client,
  )
}

pub fn person_delete(
  resource: r4us.Person,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Person", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn person_search_bundled(sp: r4us_sansio.SpPerson, client: FhirClient) {
  let req = r4us_sansio.person_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn person_search(
  sp: r4us_sansio.SpPerson,
  client: FhirClient,
) -> Result(List(r4us.Person), Err) {
  let req = r4us_sansio.person_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.person
  })
}

pub fn plandefinition_create(
  resource: r4us.Plandefinition,
  client: FhirClient,
) -> Result(r4us.Plandefinition, Err) {
  any_create(
    r4us.plandefinition_to_json(resource),
    "PlanDefinition",
    r4us.plandefinition_decoder(),
    client,
  )
}

pub fn plandefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Plandefinition, Err) {
  any_read(id, client, "PlanDefinition", r4us.plandefinition_decoder())
}

pub fn plandefinition_update(
  resource: r4us.Plandefinition,
  client: FhirClient,
) -> Result(r4us.Plandefinition, Err) {
  any_update(
    resource.id,
    r4us.plandefinition_to_json(resource),
    "PlanDefinition",
    r4us.plandefinition_decoder(),
    client,
  )
}

pub fn plandefinition_delete(
  resource: r4us.Plandefinition,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Plandefinition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn plandefinition_search_bundled(
  sp: r4us_sansio.SpPlandefinition,
  client: FhirClient,
) {
  let req = r4us_sansio.plandefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn plandefinition_search(
  sp: r4us_sansio.SpPlandefinition,
  client: FhirClient,
) -> Result(List(r4us.Plandefinition), Err) {
  let req = r4us_sansio.plandefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.plandefinition
  })
}

pub fn practitioner_create(
  resource: r4us.Practitioner,
  client: FhirClient,
) -> Result(r4us.Practitioner, Err) {
  any_create(
    r4us.practitioner_to_json(resource),
    "Practitioner",
    r4us.practitioner_decoder(),
    client,
  )
}

pub fn practitioner_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Practitioner, Err) {
  any_read(id, client, "Practitioner", r4us.practitioner_decoder())
}

pub fn practitioner_update(
  resource: r4us.Practitioner,
  client: FhirClient,
) -> Result(r4us.Practitioner, Err) {
  any_update(
    resource.id,
    r4us.practitioner_to_json(resource),
    "Practitioner",
    r4us.practitioner_decoder(),
    client,
  )
}

pub fn practitioner_delete(
  resource: r4us.Practitioner,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Practitioner", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn practitioner_search_bundled(
  sp: r4us_sansio.SpPractitioner,
  client: FhirClient,
) {
  let req = r4us_sansio.practitioner_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn practitioner_search(
  sp: r4us_sansio.SpPractitioner,
  client: FhirClient,
) -> Result(List(r4us.Practitioner), Err) {
  let req = r4us_sansio.practitioner_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.practitioner
  })
}

pub fn practitionerrole_create(
  resource: r4us.Practitionerrole,
  client: FhirClient,
) -> Result(r4us.Practitionerrole, Err) {
  any_create(
    r4us.practitionerrole_to_json(resource),
    "PractitionerRole",
    r4us.practitionerrole_decoder(),
    client,
  )
}

pub fn practitionerrole_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Practitionerrole, Err) {
  any_read(id, client, "PractitionerRole", r4us.practitionerrole_decoder())
}

pub fn practitionerrole_update(
  resource: r4us.Practitionerrole,
  client: FhirClient,
) -> Result(r4us.Practitionerrole, Err) {
  any_update(
    resource.id,
    r4us.practitionerrole_to_json(resource),
    "PractitionerRole",
    r4us.practitionerrole_decoder(),
    client,
  )
}

pub fn practitionerrole_delete(
  resource: r4us.Practitionerrole,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Practitionerrole", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn practitionerrole_search_bundled(
  sp: r4us_sansio.SpPractitionerrole,
  client: FhirClient,
) {
  let req = r4us_sansio.practitionerrole_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn practitionerrole_search(
  sp: r4us_sansio.SpPractitionerrole,
  client: FhirClient,
) -> Result(List(r4us.Practitionerrole), Err) {
  let req = r4us_sansio.practitionerrole_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.practitionerrole
  })
}

pub fn procedure_create(
  resource: r4us.Procedure,
  client: FhirClient,
) -> Result(r4us.Procedure, Err) {
  any_create(
    r4us.procedure_to_json(resource),
    "Procedure",
    r4us.procedure_decoder(),
    client,
  )
}

pub fn procedure_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Procedure, Err) {
  any_read(id, client, "Procedure", r4us.procedure_decoder())
}

pub fn procedure_update(
  resource: r4us.Procedure,
  client: FhirClient,
) -> Result(r4us.Procedure, Err) {
  any_update(
    resource.id,
    r4us.procedure_to_json(resource),
    "Procedure",
    r4us.procedure_decoder(),
    client,
  )
}

pub fn procedure_delete(
  resource: r4us.Procedure,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Procedure", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn procedure_search_bundled(sp: r4us_sansio.SpProcedure, client: FhirClient) {
  let req = r4us_sansio.procedure_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn procedure_search(
  sp: r4us_sansio.SpProcedure,
  client: FhirClient,
) -> Result(List(r4us.Procedure), Err) {
  let req = r4us_sansio.procedure_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.procedure
  })
}

pub fn provenance_create(
  resource: r4us.Provenance,
  client: FhirClient,
) -> Result(r4us.Provenance, Err) {
  any_create(
    r4us.provenance_to_json(resource),
    "Provenance",
    r4us.provenance_decoder(),
    client,
  )
}

pub fn provenance_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Provenance, Err) {
  any_read(id, client, "Provenance", r4us.provenance_decoder())
}

pub fn provenance_update(
  resource: r4us.Provenance,
  client: FhirClient,
) -> Result(r4us.Provenance, Err) {
  any_update(
    resource.id,
    r4us.provenance_to_json(resource),
    "Provenance",
    r4us.provenance_decoder(),
    client,
  )
}

pub fn provenance_delete(
  resource: r4us.Provenance,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Provenance", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn provenance_search_bundled(
  sp: r4us_sansio.SpProvenance,
  client: FhirClient,
) {
  let req = r4us_sansio.provenance_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn provenance_search(
  sp: r4us_sansio.SpProvenance,
  client: FhirClient,
) -> Result(List(r4us.Provenance), Err) {
  let req = r4us_sansio.provenance_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.provenance
  })
}

pub fn questionnaire_create(
  resource: r4us.Questionnaire,
  client: FhirClient,
) -> Result(r4us.Questionnaire, Err) {
  any_create(
    r4us.questionnaire_to_json(resource),
    "Questionnaire",
    r4us.questionnaire_decoder(),
    client,
  )
}

pub fn questionnaire_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Questionnaire, Err) {
  any_read(id, client, "Questionnaire", r4us.questionnaire_decoder())
}

pub fn questionnaire_update(
  resource: r4us.Questionnaire,
  client: FhirClient,
) -> Result(r4us.Questionnaire, Err) {
  any_update(
    resource.id,
    r4us.questionnaire_to_json(resource),
    "Questionnaire",
    r4us.questionnaire_decoder(),
    client,
  )
}

pub fn questionnaire_delete(
  resource: r4us.Questionnaire,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Questionnaire", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn questionnaire_search_bundled(
  sp: r4us_sansio.SpQuestionnaire,
  client: FhirClient,
) {
  let req = r4us_sansio.questionnaire_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn questionnaire_search(
  sp: r4us_sansio.SpQuestionnaire,
  client: FhirClient,
) -> Result(List(r4us.Questionnaire), Err) {
  let req = r4us_sansio.questionnaire_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.questionnaire
  })
}

pub fn questionnaireresponse_create(
  resource: r4us.Questionnaireresponse,
  client: FhirClient,
) -> Result(r4us.Questionnaireresponse, Err) {
  any_create(
    r4us.questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    r4us.questionnaireresponse_decoder(),
    client,
  )
}

pub fn questionnaireresponse_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Questionnaireresponse, Err) {
  any_read(
    id,
    client,
    "QuestionnaireResponse",
    r4us.questionnaireresponse_decoder(),
  )
}

pub fn questionnaireresponse_update(
  resource: r4us.Questionnaireresponse,
  client: FhirClient,
) -> Result(r4us.Questionnaireresponse, Err) {
  any_update(
    resource.id,
    r4us.questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    r4us.questionnaireresponse_decoder(),
    client,
  )
}

pub fn questionnaireresponse_delete(
  resource: r4us.Questionnaireresponse,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Questionnaireresponse", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn questionnaireresponse_search_bundled(
  sp: r4us_sansio.SpQuestionnaireresponse,
  client: FhirClient,
) {
  let req = r4us_sansio.questionnaireresponse_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn questionnaireresponse_search(
  sp: r4us_sansio.SpQuestionnaireresponse,
  client: FhirClient,
) -> Result(List(r4us.Questionnaireresponse), Err) {
  let req = r4us_sansio.questionnaireresponse_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.questionnaireresponse
  })
}

pub fn relatedperson_create(
  resource: r4us.Relatedperson,
  client: FhirClient,
) -> Result(r4us.Relatedperson, Err) {
  any_create(
    r4us.relatedperson_to_json(resource),
    "RelatedPerson",
    r4us.relatedperson_decoder(),
    client,
  )
}

pub fn relatedperson_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Relatedperson, Err) {
  any_read(id, client, "RelatedPerson", r4us.relatedperson_decoder())
}

pub fn relatedperson_update(
  resource: r4us.Relatedperson,
  client: FhirClient,
) -> Result(r4us.Relatedperson, Err) {
  any_update(
    resource.id,
    r4us.relatedperson_to_json(resource),
    "RelatedPerson",
    r4us.relatedperson_decoder(),
    client,
  )
}

pub fn relatedperson_delete(
  resource: r4us.Relatedperson,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Relatedperson", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn relatedperson_search_bundled(
  sp: r4us_sansio.SpRelatedperson,
  client: FhirClient,
) {
  let req = r4us_sansio.relatedperson_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn relatedperson_search(
  sp: r4us_sansio.SpRelatedperson,
  client: FhirClient,
) -> Result(List(r4us.Relatedperson), Err) {
  let req = r4us_sansio.relatedperson_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.relatedperson
  })
}

pub fn requestgroup_create(
  resource: r4us.Requestgroup,
  client: FhirClient,
) -> Result(r4us.Requestgroup, Err) {
  any_create(
    r4us.requestgroup_to_json(resource),
    "RequestGroup",
    r4us.requestgroup_decoder(),
    client,
  )
}

pub fn requestgroup_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Requestgroup, Err) {
  any_read(id, client, "RequestGroup", r4us.requestgroup_decoder())
}

pub fn requestgroup_update(
  resource: r4us.Requestgroup,
  client: FhirClient,
) -> Result(r4us.Requestgroup, Err) {
  any_update(
    resource.id,
    r4us.requestgroup_to_json(resource),
    "RequestGroup",
    r4us.requestgroup_decoder(),
    client,
  )
}

pub fn requestgroup_delete(
  resource: r4us.Requestgroup,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Requestgroup", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn requestgroup_search_bundled(
  sp: r4us_sansio.SpRequestgroup,
  client: FhirClient,
) {
  let req = r4us_sansio.requestgroup_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn requestgroup_search(
  sp: r4us_sansio.SpRequestgroup,
  client: FhirClient,
) -> Result(List(r4us.Requestgroup), Err) {
  let req = r4us_sansio.requestgroup_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.requestgroup
  })
}

pub fn researchdefinition_create(
  resource: r4us.Researchdefinition,
  client: FhirClient,
) -> Result(r4us.Researchdefinition, Err) {
  any_create(
    r4us.researchdefinition_to_json(resource),
    "ResearchDefinition",
    r4us.researchdefinition_decoder(),
    client,
  )
}

pub fn researchdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Researchdefinition, Err) {
  any_read(id, client, "ResearchDefinition", r4us.researchdefinition_decoder())
}

pub fn researchdefinition_update(
  resource: r4us.Researchdefinition,
  client: FhirClient,
) -> Result(r4us.Researchdefinition, Err) {
  any_update(
    resource.id,
    r4us.researchdefinition_to_json(resource),
    "ResearchDefinition",
    r4us.researchdefinition_decoder(),
    client,
  )
}

pub fn researchdefinition_delete(
  resource: r4us.Researchdefinition,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Researchdefinition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn researchdefinition_search_bundled(
  sp: r4us_sansio.SpResearchdefinition,
  client: FhirClient,
) {
  let req = r4us_sansio.researchdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn researchdefinition_search(
  sp: r4us_sansio.SpResearchdefinition,
  client: FhirClient,
) -> Result(List(r4us.Researchdefinition), Err) {
  let req = r4us_sansio.researchdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.researchdefinition
  })
}

pub fn researchelementdefinition_create(
  resource: r4us.Researchelementdefinition,
  client: FhirClient,
) -> Result(r4us.Researchelementdefinition, Err) {
  any_create(
    r4us.researchelementdefinition_to_json(resource),
    "ResearchElementDefinition",
    r4us.researchelementdefinition_decoder(),
    client,
  )
}

pub fn researchelementdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Researchelementdefinition, Err) {
  any_read(
    id,
    client,
    "ResearchElementDefinition",
    r4us.researchelementdefinition_decoder(),
  )
}

pub fn researchelementdefinition_update(
  resource: r4us.Researchelementdefinition,
  client: FhirClient,
) -> Result(r4us.Researchelementdefinition, Err) {
  any_update(
    resource.id,
    r4us.researchelementdefinition_to_json(resource),
    "ResearchElementDefinition",
    r4us.researchelementdefinition_decoder(),
    client,
  )
}

pub fn researchelementdefinition_delete(
  resource: r4us.Researchelementdefinition,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Researchelementdefinition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn researchelementdefinition_search_bundled(
  sp: r4us_sansio.SpResearchelementdefinition,
  client: FhirClient,
) {
  let req = r4us_sansio.researchelementdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn researchelementdefinition_search(
  sp: r4us_sansio.SpResearchelementdefinition,
  client: FhirClient,
) -> Result(List(r4us.Researchelementdefinition), Err) {
  let req = r4us_sansio.researchelementdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.researchelementdefinition
  })
}

pub fn researchstudy_create(
  resource: r4us.Researchstudy,
  client: FhirClient,
) -> Result(r4us.Researchstudy, Err) {
  any_create(
    r4us.researchstudy_to_json(resource),
    "ResearchStudy",
    r4us.researchstudy_decoder(),
    client,
  )
}

pub fn researchstudy_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Researchstudy, Err) {
  any_read(id, client, "ResearchStudy", r4us.researchstudy_decoder())
}

pub fn researchstudy_update(
  resource: r4us.Researchstudy,
  client: FhirClient,
) -> Result(r4us.Researchstudy, Err) {
  any_update(
    resource.id,
    r4us.researchstudy_to_json(resource),
    "ResearchStudy",
    r4us.researchstudy_decoder(),
    client,
  )
}

pub fn researchstudy_delete(
  resource: r4us.Researchstudy,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Researchstudy", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn researchstudy_search_bundled(
  sp: r4us_sansio.SpResearchstudy,
  client: FhirClient,
) {
  let req = r4us_sansio.researchstudy_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn researchstudy_search(
  sp: r4us_sansio.SpResearchstudy,
  client: FhirClient,
) -> Result(List(r4us.Researchstudy), Err) {
  let req = r4us_sansio.researchstudy_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.researchstudy
  })
}

pub fn researchsubject_create(
  resource: r4us.Researchsubject,
  client: FhirClient,
) -> Result(r4us.Researchsubject, Err) {
  any_create(
    r4us.researchsubject_to_json(resource),
    "ResearchSubject",
    r4us.researchsubject_decoder(),
    client,
  )
}

pub fn researchsubject_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Researchsubject, Err) {
  any_read(id, client, "ResearchSubject", r4us.researchsubject_decoder())
}

pub fn researchsubject_update(
  resource: r4us.Researchsubject,
  client: FhirClient,
) -> Result(r4us.Researchsubject, Err) {
  any_update(
    resource.id,
    r4us.researchsubject_to_json(resource),
    "ResearchSubject",
    r4us.researchsubject_decoder(),
    client,
  )
}

pub fn researchsubject_delete(
  resource: r4us.Researchsubject,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Researchsubject", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn researchsubject_search_bundled(
  sp: r4us_sansio.SpResearchsubject,
  client: FhirClient,
) {
  let req = r4us_sansio.researchsubject_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn researchsubject_search(
  sp: r4us_sansio.SpResearchsubject,
  client: FhirClient,
) -> Result(List(r4us.Researchsubject), Err) {
  let req = r4us_sansio.researchsubject_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.researchsubject
  })
}

pub fn riskassessment_create(
  resource: r4us.Riskassessment,
  client: FhirClient,
) -> Result(r4us.Riskassessment, Err) {
  any_create(
    r4us.riskassessment_to_json(resource),
    "RiskAssessment",
    r4us.riskassessment_decoder(),
    client,
  )
}

pub fn riskassessment_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Riskassessment, Err) {
  any_read(id, client, "RiskAssessment", r4us.riskassessment_decoder())
}

pub fn riskassessment_update(
  resource: r4us.Riskassessment,
  client: FhirClient,
) -> Result(r4us.Riskassessment, Err) {
  any_update(
    resource.id,
    r4us.riskassessment_to_json(resource),
    "RiskAssessment",
    r4us.riskassessment_decoder(),
    client,
  )
}

pub fn riskassessment_delete(
  resource: r4us.Riskassessment,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Riskassessment", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn riskassessment_search_bundled(
  sp: r4us_sansio.SpRiskassessment,
  client: FhirClient,
) {
  let req = r4us_sansio.riskassessment_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn riskassessment_search(
  sp: r4us_sansio.SpRiskassessment,
  client: FhirClient,
) -> Result(List(r4us.Riskassessment), Err) {
  let req = r4us_sansio.riskassessment_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.riskassessment
  })
}

pub fn riskevidencesynthesis_create(
  resource: r4us.Riskevidencesynthesis,
  client: FhirClient,
) -> Result(r4us.Riskevidencesynthesis, Err) {
  any_create(
    r4us.riskevidencesynthesis_to_json(resource),
    "RiskEvidenceSynthesis",
    r4us.riskevidencesynthesis_decoder(),
    client,
  )
}

pub fn riskevidencesynthesis_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Riskevidencesynthesis, Err) {
  any_read(
    id,
    client,
    "RiskEvidenceSynthesis",
    r4us.riskevidencesynthesis_decoder(),
  )
}

pub fn riskevidencesynthesis_update(
  resource: r4us.Riskevidencesynthesis,
  client: FhirClient,
) -> Result(r4us.Riskevidencesynthesis, Err) {
  any_update(
    resource.id,
    r4us.riskevidencesynthesis_to_json(resource),
    "RiskEvidenceSynthesis",
    r4us.riskevidencesynthesis_decoder(),
    client,
  )
}

pub fn riskevidencesynthesis_delete(
  resource: r4us.Riskevidencesynthesis,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Riskevidencesynthesis", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn riskevidencesynthesis_search_bundled(
  sp: r4us_sansio.SpRiskevidencesynthesis,
  client: FhirClient,
) {
  let req = r4us_sansio.riskevidencesynthesis_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn riskevidencesynthesis_search(
  sp: r4us_sansio.SpRiskevidencesynthesis,
  client: FhirClient,
) -> Result(List(r4us.Riskevidencesynthesis), Err) {
  let req = r4us_sansio.riskevidencesynthesis_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.riskevidencesynthesis
  })
}

pub fn schedule_create(
  resource: r4us.Schedule,
  client: FhirClient,
) -> Result(r4us.Schedule, Err) {
  any_create(
    r4us.schedule_to_json(resource),
    "Schedule",
    r4us.schedule_decoder(),
    client,
  )
}

pub fn schedule_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Schedule, Err) {
  any_read(id, client, "Schedule", r4us.schedule_decoder())
}

pub fn schedule_update(
  resource: r4us.Schedule,
  client: FhirClient,
) -> Result(r4us.Schedule, Err) {
  any_update(
    resource.id,
    r4us.schedule_to_json(resource),
    "Schedule",
    r4us.schedule_decoder(),
    client,
  )
}

pub fn schedule_delete(
  resource: r4us.Schedule,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Schedule", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn schedule_search_bundled(sp: r4us_sansio.SpSchedule, client: FhirClient) {
  let req = r4us_sansio.schedule_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn schedule_search(
  sp: r4us_sansio.SpSchedule,
  client: FhirClient,
) -> Result(List(r4us.Schedule), Err) {
  let req = r4us_sansio.schedule_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.schedule
  })
}

pub fn searchparameter_create(
  resource: r4us.Searchparameter,
  client: FhirClient,
) -> Result(r4us.Searchparameter, Err) {
  any_create(
    r4us.searchparameter_to_json(resource),
    "SearchParameter",
    r4us.searchparameter_decoder(),
    client,
  )
}

pub fn searchparameter_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Searchparameter, Err) {
  any_read(id, client, "SearchParameter", r4us.searchparameter_decoder())
}

pub fn searchparameter_update(
  resource: r4us.Searchparameter,
  client: FhirClient,
) -> Result(r4us.Searchparameter, Err) {
  any_update(
    resource.id,
    r4us.searchparameter_to_json(resource),
    "SearchParameter",
    r4us.searchparameter_decoder(),
    client,
  )
}

pub fn searchparameter_delete(
  resource: r4us.Searchparameter,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Searchparameter", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn searchparameter_search_bundled(
  sp: r4us_sansio.SpSearchparameter,
  client: FhirClient,
) {
  let req = r4us_sansio.searchparameter_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn searchparameter_search(
  sp: r4us_sansio.SpSearchparameter,
  client: FhirClient,
) -> Result(List(r4us.Searchparameter), Err) {
  let req = r4us_sansio.searchparameter_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.searchparameter
  })
}

pub fn servicerequest_create(
  resource: r4us.Servicerequest,
  client: FhirClient,
) -> Result(r4us.Servicerequest, Err) {
  any_create(
    r4us.servicerequest_to_json(resource),
    "ServiceRequest",
    r4us.servicerequest_decoder(),
    client,
  )
}

pub fn servicerequest_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Servicerequest, Err) {
  any_read(id, client, "ServiceRequest", r4us.servicerequest_decoder())
}

pub fn servicerequest_update(
  resource: r4us.Servicerequest,
  client: FhirClient,
) -> Result(r4us.Servicerequest, Err) {
  any_update(
    resource.id,
    r4us.servicerequest_to_json(resource),
    "ServiceRequest",
    r4us.servicerequest_decoder(),
    client,
  )
}

pub fn servicerequest_delete(
  resource: r4us.Servicerequest,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Servicerequest", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn servicerequest_search_bundled(
  sp: r4us_sansio.SpServicerequest,
  client: FhirClient,
) {
  let req = r4us_sansio.servicerequest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn servicerequest_search(
  sp: r4us_sansio.SpServicerequest,
  client: FhirClient,
) -> Result(List(r4us.Servicerequest), Err) {
  let req = r4us_sansio.servicerequest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.servicerequest
  })
}

pub fn slot_create(
  resource: r4us.Slot,
  client: FhirClient,
) -> Result(r4us.Slot, Err) {
  any_create(r4us.slot_to_json(resource), "Slot", r4us.slot_decoder(), client)
}

pub fn slot_read(id: String, client: FhirClient) -> Result(r4us.Slot, Err) {
  any_read(id, client, "Slot", r4us.slot_decoder())
}

pub fn slot_update(
  resource: r4us.Slot,
  client: FhirClient,
) -> Result(r4us.Slot, Err) {
  any_update(
    resource.id,
    r4us.slot_to_json(resource),
    "Slot",
    r4us.slot_decoder(),
    client,
  )
}

pub fn slot_delete(
  resource: r4us.Slot,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Slot", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn slot_search_bundled(sp: r4us_sansio.SpSlot, client: FhirClient) {
  let req = r4us_sansio.slot_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn slot_search(
  sp: r4us_sansio.SpSlot,
  client: FhirClient,
) -> Result(List(r4us.Slot), Err) {
  let req = r4us_sansio.slot_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.slot
  })
}

pub fn specimen_create(
  resource: r4us.Specimen,
  client: FhirClient,
) -> Result(r4us.Specimen, Err) {
  any_create(
    r4us.specimen_to_json(resource),
    "Specimen",
    r4us.specimen_decoder(),
    client,
  )
}

pub fn specimen_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Specimen, Err) {
  any_read(id, client, "Specimen", r4us.specimen_decoder())
}

pub fn specimen_update(
  resource: r4us.Specimen,
  client: FhirClient,
) -> Result(r4us.Specimen, Err) {
  any_update(
    resource.id,
    r4us.specimen_to_json(resource),
    "Specimen",
    r4us.specimen_decoder(),
    client,
  )
}

pub fn specimen_delete(
  resource: r4us.Specimen,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Specimen", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn specimen_search_bundled(sp: r4us_sansio.SpSpecimen, client: FhirClient) {
  let req = r4us_sansio.specimen_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn specimen_search(
  sp: r4us_sansio.SpSpecimen,
  client: FhirClient,
) -> Result(List(r4us.Specimen), Err) {
  let req = r4us_sansio.specimen_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.specimen
  })
}

pub fn specimendefinition_create(
  resource: r4us.Specimendefinition,
  client: FhirClient,
) -> Result(r4us.Specimendefinition, Err) {
  any_create(
    r4us.specimendefinition_to_json(resource),
    "SpecimenDefinition",
    r4us.specimendefinition_decoder(),
    client,
  )
}

pub fn specimendefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Specimendefinition, Err) {
  any_read(id, client, "SpecimenDefinition", r4us.specimendefinition_decoder())
}

pub fn specimendefinition_update(
  resource: r4us.Specimendefinition,
  client: FhirClient,
) -> Result(r4us.Specimendefinition, Err) {
  any_update(
    resource.id,
    r4us.specimendefinition_to_json(resource),
    "SpecimenDefinition",
    r4us.specimendefinition_decoder(),
    client,
  )
}

pub fn specimendefinition_delete(
  resource: r4us.Specimendefinition,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Specimendefinition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn specimendefinition_search_bundled(
  sp: r4us_sansio.SpSpecimendefinition,
  client: FhirClient,
) {
  let req = r4us_sansio.specimendefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn specimendefinition_search(
  sp: r4us_sansio.SpSpecimendefinition,
  client: FhirClient,
) -> Result(List(r4us.Specimendefinition), Err) {
  let req = r4us_sansio.specimendefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.specimendefinition
  })
}

pub fn structuredefinition_create(
  resource: r4us.Structuredefinition,
  client: FhirClient,
) -> Result(r4us.Structuredefinition, Err) {
  any_create(
    r4us.structuredefinition_to_json(resource),
    "StructureDefinition",
    r4us.structuredefinition_decoder(),
    client,
  )
}

pub fn structuredefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Structuredefinition, Err) {
  any_read(
    id,
    client,
    "StructureDefinition",
    r4us.structuredefinition_decoder(),
  )
}

pub fn structuredefinition_update(
  resource: r4us.Structuredefinition,
  client: FhirClient,
) -> Result(r4us.Structuredefinition, Err) {
  any_update(
    resource.id,
    r4us.structuredefinition_to_json(resource),
    "StructureDefinition",
    r4us.structuredefinition_decoder(),
    client,
  )
}

pub fn structuredefinition_delete(
  resource: r4us.Structuredefinition,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Structuredefinition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn structuredefinition_search_bundled(
  sp: r4us_sansio.SpStructuredefinition,
  client: FhirClient,
) {
  let req = r4us_sansio.structuredefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn structuredefinition_search(
  sp: r4us_sansio.SpStructuredefinition,
  client: FhirClient,
) -> Result(List(r4us.Structuredefinition), Err) {
  let req = r4us_sansio.structuredefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.structuredefinition
  })
}

pub fn structuremap_create(
  resource: r4us.Structuremap,
  client: FhirClient,
) -> Result(r4us.Structuremap, Err) {
  any_create(
    r4us.structuremap_to_json(resource),
    "StructureMap",
    r4us.structuremap_decoder(),
    client,
  )
}

pub fn structuremap_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Structuremap, Err) {
  any_read(id, client, "StructureMap", r4us.structuremap_decoder())
}

pub fn structuremap_update(
  resource: r4us.Structuremap,
  client: FhirClient,
) -> Result(r4us.Structuremap, Err) {
  any_update(
    resource.id,
    r4us.structuremap_to_json(resource),
    "StructureMap",
    r4us.structuremap_decoder(),
    client,
  )
}

pub fn structuremap_delete(
  resource: r4us.Structuremap,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Structuremap", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn structuremap_search_bundled(
  sp: r4us_sansio.SpStructuremap,
  client: FhirClient,
) {
  let req = r4us_sansio.structuremap_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn structuremap_search(
  sp: r4us_sansio.SpStructuremap,
  client: FhirClient,
) -> Result(List(r4us.Structuremap), Err) {
  let req = r4us_sansio.structuremap_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.structuremap
  })
}

pub fn subscription_create(
  resource: r4us.Subscription,
  client: FhirClient,
) -> Result(r4us.Subscription, Err) {
  any_create(
    r4us.subscription_to_json(resource),
    "Subscription",
    r4us.subscription_decoder(),
    client,
  )
}

pub fn subscription_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Subscription, Err) {
  any_read(id, client, "Subscription", r4us.subscription_decoder())
}

pub fn subscription_update(
  resource: r4us.Subscription,
  client: FhirClient,
) -> Result(r4us.Subscription, Err) {
  any_update(
    resource.id,
    r4us.subscription_to_json(resource),
    "Subscription",
    r4us.subscription_decoder(),
    client,
  )
}

pub fn subscription_delete(
  resource: r4us.Subscription,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Subscription", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn subscription_search_bundled(
  sp: r4us_sansio.SpSubscription,
  client: FhirClient,
) {
  let req = r4us_sansio.subscription_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn subscription_search(
  sp: r4us_sansio.SpSubscription,
  client: FhirClient,
) -> Result(List(r4us.Subscription), Err) {
  let req = r4us_sansio.subscription_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.subscription
  })
}

pub fn substance_create(
  resource: r4us.Substance,
  client: FhirClient,
) -> Result(r4us.Substance, Err) {
  any_create(
    r4us.substance_to_json(resource),
    "Substance",
    r4us.substance_decoder(),
    client,
  )
}

pub fn substance_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Substance, Err) {
  any_read(id, client, "Substance", r4us.substance_decoder())
}

pub fn substance_update(
  resource: r4us.Substance,
  client: FhirClient,
) -> Result(r4us.Substance, Err) {
  any_update(
    resource.id,
    r4us.substance_to_json(resource),
    "Substance",
    r4us.substance_decoder(),
    client,
  )
}

pub fn substance_delete(
  resource: r4us.Substance,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Substance", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn substance_search_bundled(sp: r4us_sansio.SpSubstance, client: FhirClient) {
  let req = r4us_sansio.substance_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn substance_search(
  sp: r4us_sansio.SpSubstance,
  client: FhirClient,
) -> Result(List(r4us.Substance), Err) {
  let req = r4us_sansio.substance_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.substance
  })
}

pub fn substancenucleicacid_create(
  resource: r4us.Substancenucleicacid,
  client: FhirClient,
) -> Result(r4us.Substancenucleicacid, Err) {
  any_create(
    r4us.substancenucleicacid_to_json(resource),
    "SubstanceNucleicAcid",
    r4us.substancenucleicacid_decoder(),
    client,
  )
}

pub fn substancenucleicacid_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Substancenucleicacid, Err) {
  any_read(
    id,
    client,
    "SubstanceNucleicAcid",
    r4us.substancenucleicacid_decoder(),
  )
}

pub fn substancenucleicacid_update(
  resource: r4us.Substancenucleicacid,
  client: FhirClient,
) -> Result(r4us.Substancenucleicacid, Err) {
  any_update(
    resource.id,
    r4us.substancenucleicacid_to_json(resource),
    "SubstanceNucleicAcid",
    r4us.substancenucleicacid_decoder(),
    client,
  )
}

pub fn substancenucleicacid_delete(
  resource: r4us.Substancenucleicacid,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Substancenucleicacid", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn substancenucleicacid_search_bundled(
  sp: r4us_sansio.SpSubstancenucleicacid,
  client: FhirClient,
) {
  let req = r4us_sansio.substancenucleicacid_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn substancenucleicacid_search(
  sp: r4us_sansio.SpSubstancenucleicacid,
  client: FhirClient,
) -> Result(List(r4us.Substancenucleicacid), Err) {
  let req = r4us_sansio.substancenucleicacid_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.substancenucleicacid
  })
}

pub fn substancepolymer_create(
  resource: r4us.Substancepolymer,
  client: FhirClient,
) -> Result(r4us.Substancepolymer, Err) {
  any_create(
    r4us.substancepolymer_to_json(resource),
    "SubstancePolymer",
    r4us.substancepolymer_decoder(),
    client,
  )
}

pub fn substancepolymer_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Substancepolymer, Err) {
  any_read(id, client, "SubstancePolymer", r4us.substancepolymer_decoder())
}

pub fn substancepolymer_update(
  resource: r4us.Substancepolymer,
  client: FhirClient,
) -> Result(r4us.Substancepolymer, Err) {
  any_update(
    resource.id,
    r4us.substancepolymer_to_json(resource),
    "SubstancePolymer",
    r4us.substancepolymer_decoder(),
    client,
  )
}

pub fn substancepolymer_delete(
  resource: r4us.Substancepolymer,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Substancepolymer", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn substancepolymer_search_bundled(
  sp: r4us_sansio.SpSubstancepolymer,
  client: FhirClient,
) {
  let req = r4us_sansio.substancepolymer_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn substancepolymer_search(
  sp: r4us_sansio.SpSubstancepolymer,
  client: FhirClient,
) -> Result(List(r4us.Substancepolymer), Err) {
  let req = r4us_sansio.substancepolymer_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.substancepolymer
  })
}

pub fn substanceprotein_create(
  resource: r4us.Substanceprotein,
  client: FhirClient,
) -> Result(r4us.Substanceprotein, Err) {
  any_create(
    r4us.substanceprotein_to_json(resource),
    "SubstanceProtein",
    r4us.substanceprotein_decoder(),
    client,
  )
}

pub fn substanceprotein_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Substanceprotein, Err) {
  any_read(id, client, "SubstanceProtein", r4us.substanceprotein_decoder())
}

pub fn substanceprotein_update(
  resource: r4us.Substanceprotein,
  client: FhirClient,
) -> Result(r4us.Substanceprotein, Err) {
  any_update(
    resource.id,
    r4us.substanceprotein_to_json(resource),
    "SubstanceProtein",
    r4us.substanceprotein_decoder(),
    client,
  )
}

pub fn substanceprotein_delete(
  resource: r4us.Substanceprotein,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Substanceprotein", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn substanceprotein_search_bundled(
  sp: r4us_sansio.SpSubstanceprotein,
  client: FhirClient,
) {
  let req = r4us_sansio.substanceprotein_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn substanceprotein_search(
  sp: r4us_sansio.SpSubstanceprotein,
  client: FhirClient,
) -> Result(List(r4us.Substanceprotein), Err) {
  let req = r4us_sansio.substanceprotein_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.substanceprotein
  })
}

pub fn substancereferenceinformation_create(
  resource: r4us.Substancereferenceinformation,
  client: FhirClient,
) -> Result(r4us.Substancereferenceinformation, Err) {
  any_create(
    r4us.substancereferenceinformation_to_json(resource),
    "SubstanceReferenceInformation",
    r4us.substancereferenceinformation_decoder(),
    client,
  )
}

pub fn substancereferenceinformation_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Substancereferenceinformation, Err) {
  any_read(
    id,
    client,
    "SubstanceReferenceInformation",
    r4us.substancereferenceinformation_decoder(),
  )
}

pub fn substancereferenceinformation_update(
  resource: r4us.Substancereferenceinformation,
  client: FhirClient,
) -> Result(r4us.Substancereferenceinformation, Err) {
  any_update(
    resource.id,
    r4us.substancereferenceinformation_to_json(resource),
    "SubstanceReferenceInformation",
    r4us.substancereferenceinformation_decoder(),
    client,
  )
}

pub fn substancereferenceinformation_delete(
  resource: r4us.Substancereferenceinformation,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Substancereferenceinformation", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn substancereferenceinformation_search_bundled(
  sp: r4us_sansio.SpSubstancereferenceinformation,
  client: FhirClient,
) {
  let req = r4us_sansio.substancereferenceinformation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn substancereferenceinformation_search(
  sp: r4us_sansio.SpSubstancereferenceinformation,
  client: FhirClient,
) -> Result(List(r4us.Substancereferenceinformation), Err) {
  let req = r4us_sansio.substancereferenceinformation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.substancereferenceinformation
  })
}

pub fn substancesourcematerial_create(
  resource: r4us.Substancesourcematerial,
  client: FhirClient,
) -> Result(r4us.Substancesourcematerial, Err) {
  any_create(
    r4us.substancesourcematerial_to_json(resource),
    "SubstanceSourceMaterial",
    r4us.substancesourcematerial_decoder(),
    client,
  )
}

pub fn substancesourcematerial_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Substancesourcematerial, Err) {
  any_read(
    id,
    client,
    "SubstanceSourceMaterial",
    r4us.substancesourcematerial_decoder(),
  )
}

pub fn substancesourcematerial_update(
  resource: r4us.Substancesourcematerial,
  client: FhirClient,
) -> Result(r4us.Substancesourcematerial, Err) {
  any_update(
    resource.id,
    r4us.substancesourcematerial_to_json(resource),
    "SubstanceSourceMaterial",
    r4us.substancesourcematerial_decoder(),
    client,
  )
}

pub fn substancesourcematerial_delete(
  resource: r4us.Substancesourcematerial,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Substancesourcematerial", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn substancesourcematerial_search_bundled(
  sp: r4us_sansio.SpSubstancesourcematerial,
  client: FhirClient,
) {
  let req = r4us_sansio.substancesourcematerial_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn substancesourcematerial_search(
  sp: r4us_sansio.SpSubstancesourcematerial,
  client: FhirClient,
) -> Result(List(r4us.Substancesourcematerial), Err) {
  let req = r4us_sansio.substancesourcematerial_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.substancesourcematerial
  })
}

pub fn substancespecification_create(
  resource: r4us.Substancespecification,
  client: FhirClient,
) -> Result(r4us.Substancespecification, Err) {
  any_create(
    r4us.substancespecification_to_json(resource),
    "SubstanceSpecification",
    r4us.substancespecification_decoder(),
    client,
  )
}

pub fn substancespecification_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Substancespecification, Err) {
  any_read(
    id,
    client,
    "SubstanceSpecification",
    r4us.substancespecification_decoder(),
  )
}

pub fn substancespecification_update(
  resource: r4us.Substancespecification,
  client: FhirClient,
) -> Result(r4us.Substancespecification, Err) {
  any_update(
    resource.id,
    r4us.substancespecification_to_json(resource),
    "SubstanceSpecification",
    r4us.substancespecification_decoder(),
    client,
  )
}

pub fn substancespecification_delete(
  resource: r4us.Substancespecification,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Substancespecification", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn substancespecification_search_bundled(
  sp: r4us_sansio.SpSubstancespecification,
  client: FhirClient,
) {
  let req = r4us_sansio.substancespecification_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn substancespecification_search(
  sp: r4us_sansio.SpSubstancespecification,
  client: FhirClient,
) -> Result(List(r4us.Substancespecification), Err) {
  let req = r4us_sansio.substancespecification_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.substancespecification
  })
}

pub fn supplydelivery_create(
  resource: r4us.Supplydelivery,
  client: FhirClient,
) -> Result(r4us.Supplydelivery, Err) {
  any_create(
    r4us.supplydelivery_to_json(resource),
    "SupplyDelivery",
    r4us.supplydelivery_decoder(),
    client,
  )
}

pub fn supplydelivery_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Supplydelivery, Err) {
  any_read(id, client, "SupplyDelivery", r4us.supplydelivery_decoder())
}

pub fn supplydelivery_update(
  resource: r4us.Supplydelivery,
  client: FhirClient,
) -> Result(r4us.Supplydelivery, Err) {
  any_update(
    resource.id,
    r4us.supplydelivery_to_json(resource),
    "SupplyDelivery",
    r4us.supplydelivery_decoder(),
    client,
  )
}

pub fn supplydelivery_delete(
  resource: r4us.Supplydelivery,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Supplydelivery", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn supplydelivery_search_bundled(
  sp: r4us_sansio.SpSupplydelivery,
  client: FhirClient,
) {
  let req = r4us_sansio.supplydelivery_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn supplydelivery_search(
  sp: r4us_sansio.SpSupplydelivery,
  client: FhirClient,
) -> Result(List(r4us.Supplydelivery), Err) {
  let req = r4us_sansio.supplydelivery_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.supplydelivery
  })
}

pub fn supplyrequest_create(
  resource: r4us.Supplyrequest,
  client: FhirClient,
) -> Result(r4us.Supplyrequest, Err) {
  any_create(
    r4us.supplyrequest_to_json(resource),
    "SupplyRequest",
    r4us.supplyrequest_decoder(),
    client,
  )
}

pub fn supplyrequest_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Supplyrequest, Err) {
  any_read(id, client, "SupplyRequest", r4us.supplyrequest_decoder())
}

pub fn supplyrequest_update(
  resource: r4us.Supplyrequest,
  client: FhirClient,
) -> Result(r4us.Supplyrequest, Err) {
  any_update(
    resource.id,
    r4us.supplyrequest_to_json(resource),
    "SupplyRequest",
    r4us.supplyrequest_decoder(),
    client,
  )
}

pub fn supplyrequest_delete(
  resource: r4us.Supplyrequest,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Supplyrequest", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn supplyrequest_search_bundled(
  sp: r4us_sansio.SpSupplyrequest,
  client: FhirClient,
) {
  let req = r4us_sansio.supplyrequest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn supplyrequest_search(
  sp: r4us_sansio.SpSupplyrequest,
  client: FhirClient,
) -> Result(List(r4us.Supplyrequest), Err) {
  let req = r4us_sansio.supplyrequest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.supplyrequest
  })
}

pub fn task_create(
  resource: r4us.Task,
  client: FhirClient,
) -> Result(r4us.Task, Err) {
  any_create(r4us.task_to_json(resource), "Task", r4us.task_decoder(), client)
}

pub fn task_read(id: String, client: FhirClient) -> Result(r4us.Task, Err) {
  any_read(id, client, "Task", r4us.task_decoder())
}

pub fn task_update(
  resource: r4us.Task,
  client: FhirClient,
) -> Result(r4us.Task, Err) {
  any_update(
    resource.id,
    r4us.task_to_json(resource),
    "Task",
    r4us.task_decoder(),
    client,
  )
}

pub fn task_delete(
  resource: r4us.Task,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Task", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn task_search_bundled(sp: r4us_sansio.SpTask, client: FhirClient) {
  let req = r4us_sansio.task_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn task_search(
  sp: r4us_sansio.SpTask,
  client: FhirClient,
) -> Result(List(r4us.Task), Err) {
  let req = r4us_sansio.task_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.task
  })
}

pub fn terminologycapabilities_create(
  resource: r4us.Terminologycapabilities,
  client: FhirClient,
) -> Result(r4us.Terminologycapabilities, Err) {
  any_create(
    r4us.terminologycapabilities_to_json(resource),
    "TerminologyCapabilities",
    r4us.terminologycapabilities_decoder(),
    client,
  )
}

pub fn terminologycapabilities_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Terminologycapabilities, Err) {
  any_read(
    id,
    client,
    "TerminologyCapabilities",
    r4us.terminologycapabilities_decoder(),
  )
}

pub fn terminologycapabilities_update(
  resource: r4us.Terminologycapabilities,
  client: FhirClient,
) -> Result(r4us.Terminologycapabilities, Err) {
  any_update(
    resource.id,
    r4us.terminologycapabilities_to_json(resource),
    "TerminologyCapabilities",
    r4us.terminologycapabilities_decoder(),
    client,
  )
}

pub fn terminologycapabilities_delete(
  resource: r4us.Terminologycapabilities,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Terminologycapabilities", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn terminologycapabilities_search_bundled(
  sp: r4us_sansio.SpTerminologycapabilities,
  client: FhirClient,
) {
  let req = r4us_sansio.terminologycapabilities_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn terminologycapabilities_search(
  sp: r4us_sansio.SpTerminologycapabilities,
  client: FhirClient,
) -> Result(List(r4us.Terminologycapabilities), Err) {
  let req = r4us_sansio.terminologycapabilities_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.terminologycapabilities
  })
}

pub fn testreport_create(
  resource: r4us.Testreport,
  client: FhirClient,
) -> Result(r4us.Testreport, Err) {
  any_create(
    r4us.testreport_to_json(resource),
    "TestReport",
    r4us.testreport_decoder(),
    client,
  )
}

pub fn testreport_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Testreport, Err) {
  any_read(id, client, "TestReport", r4us.testreport_decoder())
}

pub fn testreport_update(
  resource: r4us.Testreport,
  client: FhirClient,
) -> Result(r4us.Testreport, Err) {
  any_update(
    resource.id,
    r4us.testreport_to_json(resource),
    "TestReport",
    r4us.testreport_decoder(),
    client,
  )
}

pub fn testreport_delete(
  resource: r4us.Testreport,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Testreport", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn testreport_search_bundled(
  sp: r4us_sansio.SpTestreport,
  client: FhirClient,
) {
  let req = r4us_sansio.testreport_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn testreport_search(
  sp: r4us_sansio.SpTestreport,
  client: FhirClient,
) -> Result(List(r4us.Testreport), Err) {
  let req = r4us_sansio.testreport_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.testreport
  })
}

pub fn testscript_create(
  resource: r4us.Testscript,
  client: FhirClient,
) -> Result(r4us.Testscript, Err) {
  any_create(
    r4us.testscript_to_json(resource),
    "TestScript",
    r4us.testscript_decoder(),
    client,
  )
}

pub fn testscript_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Testscript, Err) {
  any_read(id, client, "TestScript", r4us.testscript_decoder())
}

pub fn testscript_update(
  resource: r4us.Testscript,
  client: FhirClient,
) -> Result(r4us.Testscript, Err) {
  any_update(
    resource.id,
    r4us.testscript_to_json(resource),
    "TestScript",
    r4us.testscript_decoder(),
    client,
  )
}

pub fn testscript_delete(
  resource: r4us.Testscript,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Testscript", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn testscript_search_bundled(
  sp: r4us_sansio.SpTestscript,
  client: FhirClient,
) {
  let req = r4us_sansio.testscript_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn testscript_search(
  sp: r4us_sansio.SpTestscript,
  client: FhirClient,
) -> Result(List(r4us.Testscript), Err) {
  let req = r4us_sansio.testscript_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.testscript
  })
}

pub fn valueset_create(
  resource: r4us.Valueset,
  client: FhirClient,
) -> Result(r4us.Valueset, Err) {
  any_create(
    r4us.valueset_to_json(resource),
    "ValueSet",
    r4us.valueset_decoder(),
    client,
  )
}

pub fn valueset_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Valueset, Err) {
  any_read(id, client, "ValueSet", r4us.valueset_decoder())
}

pub fn valueset_update(
  resource: r4us.Valueset,
  client: FhirClient,
) -> Result(r4us.Valueset, Err) {
  any_update(
    resource.id,
    r4us.valueset_to_json(resource),
    "ValueSet",
    r4us.valueset_decoder(),
    client,
  )
}

pub fn valueset_delete(
  resource: r4us.Valueset,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Valueset", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn valueset_search_bundled(sp: r4us_sansio.SpValueset, client: FhirClient) {
  let req = r4us_sansio.valueset_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn valueset_search(
  sp: r4us_sansio.SpValueset,
  client: FhirClient,
) -> Result(List(r4us.Valueset), Err) {
  let req = r4us_sansio.valueset_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.valueset
  })
}

pub fn verificationresult_create(
  resource: r4us.Verificationresult,
  client: FhirClient,
) -> Result(r4us.Verificationresult, Err) {
  any_create(
    r4us.verificationresult_to_json(resource),
    "VerificationResult",
    r4us.verificationresult_decoder(),
    client,
  )
}

pub fn verificationresult_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Verificationresult, Err) {
  any_read(id, client, "VerificationResult", r4us.verificationresult_decoder())
}

pub fn verificationresult_update(
  resource: r4us.Verificationresult,
  client: FhirClient,
) -> Result(r4us.Verificationresult, Err) {
  any_update(
    resource.id,
    r4us.verificationresult_to_json(resource),
    "VerificationResult",
    r4us.verificationresult_decoder(),
    client,
  )
}

pub fn verificationresult_delete(
  resource: r4us.Verificationresult,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Verificationresult", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn verificationresult_search_bundled(
  sp: r4us_sansio.SpVerificationresult,
  client: FhirClient,
) {
  let req = r4us_sansio.verificationresult_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn verificationresult_search(
  sp: r4us_sansio.SpVerificationresult,
  client: FhirClient,
) -> Result(List(r4us.Verificationresult), Err) {
  let req = r4us_sansio.verificationresult_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.verificationresult
  })
}

pub fn visionprescription_create(
  resource: r4us.Visionprescription,
  client: FhirClient,
) -> Result(r4us.Visionprescription, Err) {
  any_create(
    r4us.visionprescription_to_json(resource),
    "VisionPrescription",
    r4us.visionprescription_decoder(),
    client,
  )
}

pub fn visionprescription_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.Visionprescription, Err) {
  any_read(id, client, "VisionPrescription", r4us.visionprescription_decoder())
}

pub fn visionprescription_update(
  resource: r4us.Visionprescription,
  client: FhirClient,
) -> Result(r4us.Visionprescription, Err) {
  any_update(
    resource.id,
    r4us.visionprescription_to_json(resource),
    "VisionPrescription",
    r4us.visionprescription_decoder(),
    client,
  )
}

pub fn visionprescription_delete(
  resource: r4us.Visionprescription,
  client: FhirClient,
) -> Result(r4us_sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Visionprescription", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn visionprescription_search_bundled(
  sp: r4us_sansio.SpVisionprescription,
  client: FhirClient,
) {
  let req = r4us_sansio.visionprescription_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
}

pub fn visionprescription_search(
  sp: r4us_sansio.SpVisionprescription,
  client: FhirClient,
) -> Result(List(r4us.Visionprescription), Err) {
  let req = r4us_sansio.visionprescription_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.visionprescription
  })
}
