////[https://hl7.org/fhir/r4usp](https://hl7.org/fhir/r4usp) r4usp client using httpc

import fhir/r4usp/resources
import fhir/r4usp/sansio
import gleam/dynamic/decode.{type Decoder}
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/httpc
import gleam/json.{type Json}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result

/// FHIR client for sending http requests to server such as
/// `let pat = resources.patient_read("123", client)`
///
/// create client from server base url with fhirclient_new(baseurl)`
///
/// `let assert Ok(client) = fhirclient_httpc.fhirclient_new("r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = fhirclient_httpc.fhirclient_new("https://r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = fhirclient_httpc.fhirclient_new("https://hapi.fhir.org/baseR4")`
///
/// `let assert Ok(client) = fhirclient_httpc.fhirclient_new("127.0.0.1:8000")`
pub type FhirClient =
  sansio.FhirClient

/// creates a new client from server base url
///
/// `let assert Ok(client) = fhirclient_httpc.fhirclient_new("r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = fhirclient_httpc.fhirclient_new("https://r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = fhirclient_httpc.fhirclient_new("https://hapi.fhir.org/baseR4")`
///
/// `let assert Ok(client) = fhirclient_httpc.fhirclient_new("127.0.0.1:8000")`
pub fn fhirclient_new(baseurl: String) -> Result(FhirClient, sansio.ErrBaseUrl) {
  sansio.fhirclient_new(baseurl)
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
  ErrOperationoutcome(resources.Operationoutcome)
  ///could not make an update or delete request because resource has no id
  ErrNoId
}

fn any_create(
  resource: Json,
  res_type: String,
  resource_dec: Decoder(r),
  client: FhirClient,
) -> Result(r, Err) {
  let req = sansio.any_create_req(resource, res_type, client)
  sendreq_parseresource(req, resource_dec, res_type)
}

fn any_read(
  id: String,
  client: FhirClient,
  res_type: String,
  resource_dec: Decoder(a),
) -> Result(a, Err) {
  let req = sansio.any_read_req(id, res_type, client)
  sendreq_parseresource(req, resource_dec, res_type)
}

fn any_update(
  id: Option(String),
  resource: Json,
  res_type: String,
  res_dec: Decoder(r),
  client: FhirClient,
) -> Result(r, Err) {
  let req = sansio.any_update_req(id, resource, res_type, client)
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
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  let req = sansio.any_delete_req(id, res_type, client)
  case httpc.send(req |> request.set_body("")) {
    Error(err) -> Error(ErrHttpc(err))
    Ok(resp) ->
      case sansio.http_or_operationoutcome_resp(resp) {
        Ok(oo_or_http) -> Ok(oo_or_http)
        Error(err) ->
          Error(
            ErrSansio(case err {
              sansio.ErrParseJson(e) -> ErrParseJson(e)
              sansio.ErrNotJson(e) -> ErrNotJson(e)
              sansio.ErrOperationoutcome(e) -> ErrOperationoutcome(e)
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
) -> Result(resources.Bundle, Err) {
  let req = sansio.any_search_req(search_string, res_type, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
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
pub fn all_pages_loop(
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
            sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
          all_pages_loop(next, acc_bundles, client)
        }
      }
    }
  }
}

/// run any operation string on any resource string, optionally using Parameters
pub fn operation_any(
  params params: Option(resources.Parameters),
  operation_name operation_name: String,
  res_type res_type: String,
  res_id res_id: Option(String),
  res_decoder res_decoder: Decoder(res),
  return_res_type return_res_type: String,
  client client: FhirClient,
) -> Result(res, Err) {
  let req =
    sansio.any_operation_req(res_type, res_id, operation_name, params, client)
  sendreq_parseresource(req, res_decoder, return_res_type)
}

pub fn batch(
  reqs: List(Request(Option(Json))),
  bundle_type: sansio.PostBundleType,
  client: FhirClient,
) -> Result(resources.Bundle, Err) {
  let req = sansio.batch_req(reqs, bundle_type, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
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
      case sansio.any_resp(resp, res_dec, res_type) {
        Ok(resource) -> Ok(resource)
        Error(err) ->
          Error(
            ErrSansio(case err {
              sansio.ErrParseJson(e) -> ErrParseJson(e)
              sansio.ErrNotJson(e) -> ErrNotJson(e)
              sansio.ErrOperationoutcome(e) -> ErrOperationoutcome(e)
            }),
          )
      }
  }
}

pub fn account_create(
  resource: resources.Account,
  client: FhirClient,
) -> Result(resources.Account, Err) {
  any_create(
    resources.account_to_json(resource),
    "Account",
    resources.account_decoder(),
    client,
  )
}

pub fn account_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Account, Err) {
  any_read(id, client, "Account", resources.account_decoder())
}

pub fn account_update(
  resource: resources.Account,
  client: FhirClient,
) -> Result(resources.Account, Err) {
  any_update(
    resource.id,
    resources.account_to_json(resource),
    "Account",
    resources.account_decoder(),
    client,
  )
}

pub fn account_delete(
  resource: resources.Account,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Account", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn account_search_bundled(sp: sansio.SpAccount, client: FhirClient) {
  let req = sansio.account_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn account_search(
  sp: sansio.SpAccount,
  client: FhirClient,
) -> Result(List(resources.Account), Err) {
  let req = sansio.account_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.account
  })
}

pub fn activitydefinition_create(
  resource: resources.Activitydefinition,
  client: FhirClient,
) -> Result(resources.Activitydefinition, Err) {
  any_create(
    resources.activitydefinition_to_json(resource),
    "ActivityDefinition",
    resources.activitydefinition_decoder(),
    client,
  )
}

pub fn activitydefinition_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Activitydefinition, Err) {
  any_read(
    id,
    client,
    "ActivityDefinition",
    resources.activitydefinition_decoder(),
  )
}

pub fn activitydefinition_update(
  resource: resources.Activitydefinition,
  client: FhirClient,
) -> Result(resources.Activitydefinition, Err) {
  any_update(
    resource.id,
    resources.activitydefinition_to_json(resource),
    "ActivityDefinition",
    resources.activitydefinition_decoder(),
    client,
  )
}

pub fn activitydefinition_delete(
  resource: resources.Activitydefinition,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Activitydefinition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn activitydefinition_search_bundled(
  sp: sansio.SpActivitydefinition,
  client: FhirClient,
) {
  let req = sansio.activitydefinition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn activitydefinition_search(
  sp: sansio.SpActivitydefinition,
  client: FhirClient,
) -> Result(List(resources.Activitydefinition), Err) {
  let req = sansio.activitydefinition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.activitydefinition
  })
}

pub fn adverseevent_create(
  resource: resources.Adverseevent,
  client: FhirClient,
) -> Result(resources.Adverseevent, Err) {
  any_create(
    resources.adverseevent_to_json(resource),
    "AdverseEvent",
    resources.adverseevent_decoder(),
    client,
  )
}

pub fn adverseevent_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Adverseevent, Err) {
  any_read(id, client, "AdverseEvent", resources.adverseevent_decoder())
}

pub fn adverseevent_update(
  resource: resources.Adverseevent,
  client: FhirClient,
) -> Result(resources.Adverseevent, Err) {
  any_update(
    resource.id,
    resources.adverseevent_to_json(resource),
    "AdverseEvent",
    resources.adverseevent_decoder(),
    client,
  )
}

pub fn adverseevent_delete(
  resource: resources.Adverseevent,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Adverseevent", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn adverseevent_search_bundled(
  sp: sansio.SpAdverseevent,
  client: FhirClient,
) {
  let req = sansio.adverseevent_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn adverseevent_search(
  sp: sansio.SpAdverseevent,
  client: FhirClient,
) -> Result(List(resources.Adverseevent), Err) {
  let req = sansio.adverseevent_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.adverseevent
  })
}

pub fn allergyintolerance_create(
  resource: resources.Allergyintolerance,
  client: FhirClient,
) -> Result(resources.Allergyintolerance, Err) {
  any_create(
    resources.allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    resources.allergyintolerance_decoder(),
    client,
  )
}

pub fn allergyintolerance_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Allergyintolerance, Err) {
  any_read(
    id,
    client,
    "AllergyIntolerance",
    resources.allergyintolerance_decoder(),
  )
}

pub fn allergyintolerance_update(
  resource: resources.Allergyintolerance,
  client: FhirClient,
) -> Result(resources.Allergyintolerance, Err) {
  any_update(
    resource.id,
    resources.allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    resources.allergyintolerance_decoder(),
    client,
  )
}

pub fn allergyintolerance_delete(
  resource: resources.Allergyintolerance,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Allergyintolerance", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn allergyintolerance_search_bundled(
  sp: sansio.SpAllergyintolerance,
  client: FhirClient,
) {
  let req = sansio.allergyintolerance_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn allergyintolerance_search(
  sp: sansio.SpAllergyintolerance,
  client: FhirClient,
) -> Result(List(resources.Allergyintolerance), Err) {
  let req = sansio.allergyintolerance_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.allergyintolerance
  })
}

pub fn appointment_create(
  resource: resources.Appointment,
  client: FhirClient,
) -> Result(resources.Appointment, Err) {
  any_create(
    resources.appointment_to_json(resource),
    "Appointment",
    resources.appointment_decoder(),
    client,
  )
}

pub fn appointment_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Appointment, Err) {
  any_read(id, client, "Appointment", resources.appointment_decoder())
}

pub fn appointment_update(
  resource: resources.Appointment,
  client: FhirClient,
) -> Result(resources.Appointment, Err) {
  any_update(
    resource.id,
    resources.appointment_to_json(resource),
    "Appointment",
    resources.appointment_decoder(),
    client,
  )
}

pub fn appointment_delete(
  resource: resources.Appointment,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Appointment", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn appointment_search_bundled(sp: sansio.SpAppointment, client: FhirClient) {
  let req = sansio.appointment_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn appointment_search(
  sp: sansio.SpAppointment,
  client: FhirClient,
) -> Result(List(resources.Appointment), Err) {
  let req = sansio.appointment_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.appointment
  })
}

pub fn appointmentresponse_create(
  resource: resources.Appointmentresponse,
  client: FhirClient,
) -> Result(resources.Appointmentresponse, Err) {
  any_create(
    resources.appointmentresponse_to_json(resource),
    "AppointmentResponse",
    resources.appointmentresponse_decoder(),
    client,
  )
}

pub fn appointmentresponse_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Appointmentresponse, Err) {
  any_read(
    id,
    client,
    "AppointmentResponse",
    resources.appointmentresponse_decoder(),
  )
}

pub fn appointmentresponse_update(
  resource: resources.Appointmentresponse,
  client: FhirClient,
) -> Result(resources.Appointmentresponse, Err) {
  any_update(
    resource.id,
    resources.appointmentresponse_to_json(resource),
    "AppointmentResponse",
    resources.appointmentresponse_decoder(),
    client,
  )
}

pub fn appointmentresponse_delete(
  resource: resources.Appointmentresponse,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Appointmentresponse", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn appointmentresponse_search_bundled(
  sp: sansio.SpAppointmentresponse,
  client: FhirClient,
) {
  let req = sansio.appointmentresponse_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn appointmentresponse_search(
  sp: sansio.SpAppointmentresponse,
  client: FhirClient,
) -> Result(List(resources.Appointmentresponse), Err) {
  let req = sansio.appointmentresponse_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.appointmentresponse
  })
}

pub fn auditevent_create(
  resource: resources.Auditevent,
  client: FhirClient,
) -> Result(resources.Auditevent, Err) {
  any_create(
    resources.auditevent_to_json(resource),
    "AuditEvent",
    resources.auditevent_decoder(),
    client,
  )
}

pub fn auditevent_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Auditevent, Err) {
  any_read(id, client, "AuditEvent", resources.auditevent_decoder())
}

pub fn auditevent_update(
  resource: resources.Auditevent,
  client: FhirClient,
) -> Result(resources.Auditevent, Err) {
  any_update(
    resource.id,
    resources.auditevent_to_json(resource),
    "AuditEvent",
    resources.auditevent_decoder(),
    client,
  )
}

pub fn auditevent_delete(
  resource: resources.Auditevent,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Auditevent", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn auditevent_search_bundled(sp: sansio.SpAuditevent, client: FhirClient) {
  let req = sansio.auditevent_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn auditevent_search(
  sp: sansio.SpAuditevent,
  client: FhirClient,
) -> Result(List(resources.Auditevent), Err) {
  let req = sansio.auditevent_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.auditevent
  })
}

pub fn basic_create(
  resource: resources.Basic,
  client: FhirClient,
) -> Result(resources.Basic, Err) {
  any_create(
    resources.basic_to_json(resource),
    "Basic",
    resources.basic_decoder(),
    client,
  )
}

pub fn basic_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Basic, Err) {
  any_read(id, client, "Basic", resources.basic_decoder())
}

pub fn basic_update(
  resource: resources.Basic,
  client: FhirClient,
) -> Result(resources.Basic, Err) {
  any_update(
    resource.id,
    resources.basic_to_json(resource),
    "Basic",
    resources.basic_decoder(),
    client,
  )
}

pub fn basic_delete(
  resource: resources.Basic,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Basic", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn basic_search_bundled(sp: sansio.SpBasic, client: FhirClient) {
  let req = sansio.basic_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn basic_search(
  sp: sansio.SpBasic,
  client: FhirClient,
) -> Result(List(resources.Basic), Err) {
  let req = sansio.basic_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.basic
  })
}

pub fn binary_create(
  resource: resources.Binary,
  client: FhirClient,
) -> Result(resources.Binary, Err) {
  any_create(
    resources.binary_to_json(resource),
    "Binary",
    resources.binary_decoder(),
    client,
  )
}

pub fn binary_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Binary, Err) {
  any_read(id, client, "Binary", resources.binary_decoder())
}

pub fn binary_update(
  resource: resources.Binary,
  client: FhirClient,
) -> Result(resources.Binary, Err) {
  any_update(
    resource.id,
    resources.binary_to_json(resource),
    "Binary",
    resources.binary_decoder(),
    client,
  )
}

pub fn binary_delete(
  resource: resources.Binary,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Binary", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn binary_search_bundled(sp: sansio.SpBinary, client: FhirClient) {
  let req = sansio.binary_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn binary_search(
  sp: sansio.SpBinary,
  client: FhirClient,
) -> Result(List(resources.Binary), Err) {
  let req = sansio.binary_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.binary
  })
}

pub fn biologicallyderivedproduct_create(
  resource: resources.Biologicallyderivedproduct,
  client: FhirClient,
) -> Result(resources.Biologicallyderivedproduct, Err) {
  any_create(
    resources.biologicallyderivedproduct_to_json(resource),
    "BiologicallyDerivedProduct",
    resources.biologicallyderivedproduct_decoder(),
    client,
  )
}

pub fn biologicallyderivedproduct_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Biologicallyderivedproduct, Err) {
  any_read(
    id,
    client,
    "BiologicallyDerivedProduct",
    resources.biologicallyderivedproduct_decoder(),
  )
}

pub fn biologicallyderivedproduct_update(
  resource: resources.Biologicallyderivedproduct,
  client: FhirClient,
) -> Result(resources.Biologicallyderivedproduct, Err) {
  any_update(
    resource.id,
    resources.biologicallyderivedproduct_to_json(resource),
    "BiologicallyDerivedProduct",
    resources.biologicallyderivedproduct_decoder(),
    client,
  )
}

pub fn biologicallyderivedproduct_delete(
  resource: resources.Biologicallyderivedproduct,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Biologicallyderivedproduct", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn biologicallyderivedproduct_search_bundled(
  sp: sansio.SpBiologicallyderivedproduct,
  client: FhirClient,
) {
  let req = sansio.biologicallyderivedproduct_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn biologicallyderivedproduct_search(
  sp: sansio.SpBiologicallyderivedproduct,
  client: FhirClient,
) -> Result(List(resources.Biologicallyderivedproduct), Err) {
  let req = sansio.biologicallyderivedproduct_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.biologicallyderivedproduct
  })
}

pub fn bodystructure_create(
  resource: resources.Bodystructure,
  client: FhirClient,
) -> Result(resources.Bodystructure, Err) {
  any_create(
    resources.bodystructure_to_json(resource),
    "BodyStructure",
    resources.bodystructure_decoder(),
    client,
  )
}

pub fn bodystructure_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Bodystructure, Err) {
  any_read(id, client, "BodyStructure", resources.bodystructure_decoder())
}

pub fn bodystructure_update(
  resource: resources.Bodystructure,
  client: FhirClient,
) -> Result(resources.Bodystructure, Err) {
  any_update(
    resource.id,
    resources.bodystructure_to_json(resource),
    "BodyStructure",
    resources.bodystructure_decoder(),
    client,
  )
}

pub fn bodystructure_delete(
  resource: resources.Bodystructure,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Bodystructure", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn bodystructure_search_bundled(
  sp: sansio.SpBodystructure,
  client: FhirClient,
) {
  let req = sansio.bodystructure_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn bodystructure_search(
  sp: sansio.SpBodystructure,
  client: FhirClient,
) -> Result(List(resources.Bodystructure), Err) {
  let req = sansio.bodystructure_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.bodystructure
  })
}

pub fn bundle_create(
  resource: resources.Bundle,
  client: FhirClient,
) -> Result(resources.Bundle, Err) {
  any_create(
    resources.bundle_to_json(resource),
    "Bundle",
    resources.bundle_decoder(),
    client,
  )
}

pub fn bundle_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Bundle, Err) {
  any_read(id, client, "Bundle", resources.bundle_decoder())
}

pub fn bundle_update(
  resource: resources.Bundle,
  client: FhirClient,
) -> Result(resources.Bundle, Err) {
  any_update(
    resource.id,
    resources.bundle_to_json(resource),
    "Bundle",
    resources.bundle_decoder(),
    client,
  )
}

pub fn bundle_delete(
  resource: resources.Bundle,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Bundle", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn bundle_search_bundled(sp: sansio.SpBundle, client: FhirClient) {
  let req = sansio.bundle_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn bundle_search(
  sp: sansio.SpBundle,
  client: FhirClient,
) -> Result(List(resources.Bundle), Err) {
  let req = sansio.bundle_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.bundle
  })
}

pub fn capabilitystatement_create(
  resource: resources.Capabilitystatement,
  client: FhirClient,
) -> Result(resources.Capabilitystatement, Err) {
  any_create(
    resources.capabilitystatement_to_json(resource),
    "CapabilityStatement",
    resources.capabilitystatement_decoder(),
    client,
  )
}

pub fn capabilitystatement_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Capabilitystatement, Err) {
  any_read(
    id,
    client,
    "CapabilityStatement",
    resources.capabilitystatement_decoder(),
  )
}

pub fn capabilitystatement_update(
  resource: resources.Capabilitystatement,
  client: FhirClient,
) -> Result(resources.Capabilitystatement, Err) {
  any_update(
    resource.id,
    resources.capabilitystatement_to_json(resource),
    "CapabilityStatement",
    resources.capabilitystatement_decoder(),
    client,
  )
}

pub fn capabilitystatement_delete(
  resource: resources.Capabilitystatement,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Capabilitystatement", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn capabilitystatement_search_bundled(
  sp: sansio.SpCapabilitystatement,
  client: FhirClient,
) {
  let req = sansio.capabilitystatement_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn capabilitystatement_search(
  sp: sansio.SpCapabilitystatement,
  client: FhirClient,
) -> Result(List(resources.Capabilitystatement), Err) {
  let req = sansio.capabilitystatement_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.capabilitystatement
  })
}

pub fn careplan_create(
  resource: resources.Careplan,
  client: FhirClient,
) -> Result(resources.Careplan, Err) {
  any_create(
    resources.careplan_to_json(resource),
    "CarePlan",
    resources.careplan_decoder(),
    client,
  )
}

pub fn careplan_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Careplan, Err) {
  any_read(id, client, "CarePlan", resources.careplan_decoder())
}

pub fn careplan_update(
  resource: resources.Careplan,
  client: FhirClient,
) -> Result(resources.Careplan, Err) {
  any_update(
    resource.id,
    resources.careplan_to_json(resource),
    "CarePlan",
    resources.careplan_decoder(),
    client,
  )
}

pub fn careplan_delete(
  resource: resources.Careplan,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Careplan", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn careplan_search_bundled(sp: sansio.SpCareplan, client: FhirClient) {
  let req = sansio.careplan_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn careplan_search(
  sp: sansio.SpCareplan,
  client: FhirClient,
) -> Result(List(resources.Careplan), Err) {
  let req = sansio.careplan_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.careplan
  })
}

pub fn careteam_create(
  resource: resources.Careteam,
  client: FhirClient,
) -> Result(resources.Careteam, Err) {
  any_create(
    resources.careteam_to_json(resource),
    "CareTeam",
    resources.careteam_decoder(),
    client,
  )
}

pub fn careteam_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Careteam, Err) {
  any_read(id, client, "CareTeam", resources.careteam_decoder())
}

pub fn careteam_update(
  resource: resources.Careteam,
  client: FhirClient,
) -> Result(resources.Careteam, Err) {
  any_update(
    resource.id,
    resources.careteam_to_json(resource),
    "CareTeam",
    resources.careteam_decoder(),
    client,
  )
}

pub fn careteam_delete(
  resource: resources.Careteam,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Careteam", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn careteam_search_bundled(sp: sansio.SpCareteam, client: FhirClient) {
  let req = sansio.careteam_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn careteam_search(
  sp: sansio.SpCareteam,
  client: FhirClient,
) -> Result(List(resources.Careteam), Err) {
  let req = sansio.careteam_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.careteam
  })
}

pub fn catalogentry_create(
  resource: resources.Catalogentry,
  client: FhirClient,
) -> Result(resources.Catalogentry, Err) {
  any_create(
    resources.catalogentry_to_json(resource),
    "CatalogEntry",
    resources.catalogentry_decoder(),
    client,
  )
}

pub fn catalogentry_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Catalogentry, Err) {
  any_read(id, client, "CatalogEntry", resources.catalogentry_decoder())
}

pub fn catalogentry_update(
  resource: resources.Catalogentry,
  client: FhirClient,
) -> Result(resources.Catalogentry, Err) {
  any_update(
    resource.id,
    resources.catalogentry_to_json(resource),
    "CatalogEntry",
    resources.catalogentry_decoder(),
    client,
  )
}

pub fn catalogentry_delete(
  resource: resources.Catalogentry,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Catalogentry", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn catalogentry_search_bundled(
  sp: sansio.SpCatalogentry,
  client: FhirClient,
) {
  let req = sansio.catalogentry_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn catalogentry_search(
  sp: sansio.SpCatalogentry,
  client: FhirClient,
) -> Result(List(resources.Catalogentry), Err) {
  let req = sansio.catalogentry_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.catalogentry
  })
}

pub fn chargeitem_create(
  resource: resources.Chargeitem,
  client: FhirClient,
) -> Result(resources.Chargeitem, Err) {
  any_create(
    resources.chargeitem_to_json(resource),
    "ChargeItem",
    resources.chargeitem_decoder(),
    client,
  )
}

pub fn chargeitem_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Chargeitem, Err) {
  any_read(id, client, "ChargeItem", resources.chargeitem_decoder())
}

pub fn chargeitem_update(
  resource: resources.Chargeitem,
  client: FhirClient,
) -> Result(resources.Chargeitem, Err) {
  any_update(
    resource.id,
    resources.chargeitem_to_json(resource),
    "ChargeItem",
    resources.chargeitem_decoder(),
    client,
  )
}

pub fn chargeitem_delete(
  resource: resources.Chargeitem,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Chargeitem", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn chargeitem_search_bundled(sp: sansio.SpChargeitem, client: FhirClient) {
  let req = sansio.chargeitem_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn chargeitem_search(
  sp: sansio.SpChargeitem,
  client: FhirClient,
) -> Result(List(resources.Chargeitem), Err) {
  let req = sansio.chargeitem_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.chargeitem
  })
}

pub fn chargeitemdefinition_create(
  resource: resources.Chargeitemdefinition,
  client: FhirClient,
) -> Result(resources.Chargeitemdefinition, Err) {
  any_create(
    resources.chargeitemdefinition_to_json(resource),
    "ChargeItemDefinition",
    resources.chargeitemdefinition_decoder(),
    client,
  )
}

pub fn chargeitemdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Chargeitemdefinition, Err) {
  any_read(
    id,
    client,
    "ChargeItemDefinition",
    resources.chargeitemdefinition_decoder(),
  )
}

pub fn chargeitemdefinition_update(
  resource: resources.Chargeitemdefinition,
  client: FhirClient,
) -> Result(resources.Chargeitemdefinition, Err) {
  any_update(
    resource.id,
    resources.chargeitemdefinition_to_json(resource),
    "ChargeItemDefinition",
    resources.chargeitemdefinition_decoder(),
    client,
  )
}

pub fn chargeitemdefinition_delete(
  resource: resources.Chargeitemdefinition,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Chargeitemdefinition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn chargeitemdefinition_search_bundled(
  sp: sansio.SpChargeitemdefinition,
  client: FhirClient,
) {
  let req = sansio.chargeitemdefinition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn chargeitemdefinition_search(
  sp: sansio.SpChargeitemdefinition,
  client: FhirClient,
) -> Result(List(resources.Chargeitemdefinition), Err) {
  let req = sansio.chargeitemdefinition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.chargeitemdefinition
  })
}

pub fn claim_create(
  resource: resources.Claim,
  client: FhirClient,
) -> Result(resources.Claim, Err) {
  any_create(
    resources.claim_to_json(resource),
    "Claim",
    resources.claim_decoder(),
    client,
  )
}

pub fn claim_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Claim, Err) {
  any_read(id, client, "Claim", resources.claim_decoder())
}

pub fn claim_update(
  resource: resources.Claim,
  client: FhirClient,
) -> Result(resources.Claim, Err) {
  any_update(
    resource.id,
    resources.claim_to_json(resource),
    "Claim",
    resources.claim_decoder(),
    client,
  )
}

pub fn claim_delete(
  resource: resources.Claim,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Claim", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn claim_search_bundled(sp: sansio.SpClaim, client: FhirClient) {
  let req = sansio.claim_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn claim_search(
  sp: sansio.SpClaim,
  client: FhirClient,
) -> Result(List(resources.Claim), Err) {
  let req = sansio.claim_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.claim
  })
}

pub fn claimresponse_create(
  resource: resources.Claimresponse,
  client: FhirClient,
) -> Result(resources.Claimresponse, Err) {
  any_create(
    resources.claimresponse_to_json(resource),
    "ClaimResponse",
    resources.claimresponse_decoder(),
    client,
  )
}

pub fn claimresponse_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Claimresponse, Err) {
  any_read(id, client, "ClaimResponse", resources.claimresponse_decoder())
}

pub fn claimresponse_update(
  resource: resources.Claimresponse,
  client: FhirClient,
) -> Result(resources.Claimresponse, Err) {
  any_update(
    resource.id,
    resources.claimresponse_to_json(resource),
    "ClaimResponse",
    resources.claimresponse_decoder(),
    client,
  )
}

pub fn claimresponse_delete(
  resource: resources.Claimresponse,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Claimresponse", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn claimresponse_search_bundled(
  sp: sansio.SpClaimresponse,
  client: FhirClient,
) {
  let req = sansio.claimresponse_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn claimresponse_search(
  sp: sansio.SpClaimresponse,
  client: FhirClient,
) -> Result(List(resources.Claimresponse), Err) {
  let req = sansio.claimresponse_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.claimresponse
  })
}

pub fn clinicalimpression_create(
  resource: resources.Clinicalimpression,
  client: FhirClient,
) -> Result(resources.Clinicalimpression, Err) {
  any_create(
    resources.clinicalimpression_to_json(resource),
    "ClinicalImpression",
    resources.clinicalimpression_decoder(),
    client,
  )
}

pub fn clinicalimpression_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Clinicalimpression, Err) {
  any_read(
    id,
    client,
    "ClinicalImpression",
    resources.clinicalimpression_decoder(),
  )
}

pub fn clinicalimpression_update(
  resource: resources.Clinicalimpression,
  client: FhirClient,
) -> Result(resources.Clinicalimpression, Err) {
  any_update(
    resource.id,
    resources.clinicalimpression_to_json(resource),
    "ClinicalImpression",
    resources.clinicalimpression_decoder(),
    client,
  )
}

pub fn clinicalimpression_delete(
  resource: resources.Clinicalimpression,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Clinicalimpression", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn clinicalimpression_search_bundled(
  sp: sansio.SpClinicalimpression,
  client: FhirClient,
) {
  let req = sansio.clinicalimpression_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn clinicalimpression_search(
  sp: sansio.SpClinicalimpression,
  client: FhirClient,
) -> Result(List(resources.Clinicalimpression), Err) {
  let req = sansio.clinicalimpression_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.clinicalimpression
  })
}

pub fn codesystem_create(
  resource: resources.Codesystem,
  client: FhirClient,
) -> Result(resources.Codesystem, Err) {
  any_create(
    resources.codesystem_to_json(resource),
    "CodeSystem",
    resources.codesystem_decoder(),
    client,
  )
}

pub fn codesystem_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Codesystem, Err) {
  any_read(id, client, "CodeSystem", resources.codesystem_decoder())
}

pub fn codesystem_update(
  resource: resources.Codesystem,
  client: FhirClient,
) -> Result(resources.Codesystem, Err) {
  any_update(
    resource.id,
    resources.codesystem_to_json(resource),
    "CodeSystem",
    resources.codesystem_decoder(),
    client,
  )
}

pub fn codesystem_delete(
  resource: resources.Codesystem,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Codesystem", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn codesystem_search_bundled(sp: sansio.SpCodesystem, client: FhirClient) {
  let req = sansio.codesystem_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn codesystem_search(
  sp: sansio.SpCodesystem,
  client: FhirClient,
) -> Result(List(resources.Codesystem), Err) {
  let req = sansio.codesystem_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.codesystem
  })
}

pub fn communication_create(
  resource: resources.Communication,
  client: FhirClient,
) -> Result(resources.Communication, Err) {
  any_create(
    resources.communication_to_json(resource),
    "Communication",
    resources.communication_decoder(),
    client,
  )
}

pub fn communication_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Communication, Err) {
  any_read(id, client, "Communication", resources.communication_decoder())
}

pub fn communication_update(
  resource: resources.Communication,
  client: FhirClient,
) -> Result(resources.Communication, Err) {
  any_update(
    resource.id,
    resources.communication_to_json(resource),
    "Communication",
    resources.communication_decoder(),
    client,
  )
}

pub fn communication_delete(
  resource: resources.Communication,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Communication", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn communication_search_bundled(
  sp: sansio.SpCommunication,
  client: FhirClient,
) {
  let req = sansio.communication_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn communication_search(
  sp: sansio.SpCommunication,
  client: FhirClient,
) -> Result(List(resources.Communication), Err) {
  let req = sansio.communication_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.communication
  })
}

pub fn communicationrequest_create(
  resource: resources.Communicationrequest,
  client: FhirClient,
) -> Result(resources.Communicationrequest, Err) {
  any_create(
    resources.communicationrequest_to_json(resource),
    "CommunicationRequest",
    resources.communicationrequest_decoder(),
    client,
  )
}

pub fn communicationrequest_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Communicationrequest, Err) {
  any_read(
    id,
    client,
    "CommunicationRequest",
    resources.communicationrequest_decoder(),
  )
}

pub fn communicationrequest_update(
  resource: resources.Communicationrequest,
  client: FhirClient,
) -> Result(resources.Communicationrequest, Err) {
  any_update(
    resource.id,
    resources.communicationrequest_to_json(resource),
    "CommunicationRequest",
    resources.communicationrequest_decoder(),
    client,
  )
}

pub fn communicationrequest_delete(
  resource: resources.Communicationrequest,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Communicationrequest", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn communicationrequest_search_bundled(
  sp: sansio.SpCommunicationrequest,
  client: FhirClient,
) {
  let req = sansio.communicationrequest_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn communicationrequest_search(
  sp: sansio.SpCommunicationrequest,
  client: FhirClient,
) -> Result(List(resources.Communicationrequest), Err) {
  let req = sansio.communicationrequest_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.communicationrequest
  })
}

pub fn compartmentdefinition_create(
  resource: resources.Compartmentdefinition,
  client: FhirClient,
) -> Result(resources.Compartmentdefinition, Err) {
  any_create(
    resources.compartmentdefinition_to_json(resource),
    "CompartmentDefinition",
    resources.compartmentdefinition_decoder(),
    client,
  )
}

pub fn compartmentdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Compartmentdefinition, Err) {
  any_read(
    id,
    client,
    "CompartmentDefinition",
    resources.compartmentdefinition_decoder(),
  )
}

pub fn compartmentdefinition_update(
  resource: resources.Compartmentdefinition,
  client: FhirClient,
) -> Result(resources.Compartmentdefinition, Err) {
  any_update(
    resource.id,
    resources.compartmentdefinition_to_json(resource),
    "CompartmentDefinition",
    resources.compartmentdefinition_decoder(),
    client,
  )
}

pub fn compartmentdefinition_delete(
  resource: resources.Compartmentdefinition,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Compartmentdefinition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn compartmentdefinition_search_bundled(
  sp: sansio.SpCompartmentdefinition,
  client: FhirClient,
) {
  let req = sansio.compartmentdefinition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn compartmentdefinition_search(
  sp: sansio.SpCompartmentdefinition,
  client: FhirClient,
) -> Result(List(resources.Compartmentdefinition), Err) {
  let req = sansio.compartmentdefinition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.compartmentdefinition
  })
}

pub fn composition_create(
  resource: resources.Composition,
  client: FhirClient,
) -> Result(resources.Composition, Err) {
  any_create(
    resources.composition_to_json(resource),
    "Composition",
    resources.composition_decoder(),
    client,
  )
}

pub fn composition_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Composition, Err) {
  any_read(id, client, "Composition", resources.composition_decoder())
}

pub fn composition_update(
  resource: resources.Composition,
  client: FhirClient,
) -> Result(resources.Composition, Err) {
  any_update(
    resource.id,
    resources.composition_to_json(resource),
    "Composition",
    resources.composition_decoder(),
    client,
  )
}

pub fn composition_delete(
  resource: resources.Composition,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Composition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn composition_search_bundled(sp: sansio.SpComposition, client: FhirClient) {
  let req = sansio.composition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn composition_search(
  sp: sansio.SpComposition,
  client: FhirClient,
) -> Result(List(resources.Composition), Err) {
  let req = sansio.composition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.composition
  })
}

pub fn conceptmap_create(
  resource: resources.Conceptmap,
  client: FhirClient,
) -> Result(resources.Conceptmap, Err) {
  any_create(
    resources.conceptmap_to_json(resource),
    "ConceptMap",
    resources.conceptmap_decoder(),
    client,
  )
}

pub fn conceptmap_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Conceptmap, Err) {
  any_read(id, client, "ConceptMap", resources.conceptmap_decoder())
}

pub fn conceptmap_update(
  resource: resources.Conceptmap,
  client: FhirClient,
) -> Result(resources.Conceptmap, Err) {
  any_update(
    resource.id,
    resources.conceptmap_to_json(resource),
    "ConceptMap",
    resources.conceptmap_decoder(),
    client,
  )
}

pub fn conceptmap_delete(
  resource: resources.Conceptmap,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Conceptmap", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn conceptmap_search_bundled(sp: sansio.SpConceptmap, client: FhirClient) {
  let req = sansio.conceptmap_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn conceptmap_search(
  sp: sansio.SpConceptmap,
  client: FhirClient,
) -> Result(List(resources.Conceptmap), Err) {
  let req = sansio.conceptmap_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.conceptmap
  })
}

pub fn condition_create(
  resource: resources.Condition,
  client: FhirClient,
) -> Result(resources.Condition, Err) {
  any_create(
    resources.condition_to_json(resource),
    "Condition",
    resources.condition_decoder(),
    client,
  )
}

pub fn condition_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Condition, Err) {
  any_read(id, client, "Condition", resources.condition_decoder())
}

pub fn condition_update(
  resource: resources.Condition,
  client: FhirClient,
) -> Result(resources.Condition, Err) {
  any_update(
    resource.id,
    resources.condition_to_json(resource),
    "Condition",
    resources.condition_decoder(),
    client,
  )
}

pub fn condition_delete(
  resource: resources.Condition,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Condition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn condition_search_bundled(sp: sansio.SpCondition, client: FhirClient) {
  let req = sansio.condition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn condition_search(
  sp: sansio.SpCondition,
  client: FhirClient,
) -> Result(List(resources.Condition), Err) {
  let req = sansio.condition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.condition
  })
}

pub fn consent_create(
  resource: resources.Consent,
  client: FhirClient,
) -> Result(resources.Consent, Err) {
  any_create(
    resources.consent_to_json(resource),
    "Consent",
    resources.consent_decoder(),
    client,
  )
}

pub fn consent_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Consent, Err) {
  any_read(id, client, "Consent", resources.consent_decoder())
}

pub fn consent_update(
  resource: resources.Consent,
  client: FhirClient,
) -> Result(resources.Consent, Err) {
  any_update(
    resource.id,
    resources.consent_to_json(resource),
    "Consent",
    resources.consent_decoder(),
    client,
  )
}

pub fn consent_delete(
  resource: resources.Consent,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Consent", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn consent_search_bundled(sp: sansio.SpConsent, client: FhirClient) {
  let req = sansio.consent_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn consent_search(
  sp: sansio.SpConsent,
  client: FhirClient,
) -> Result(List(resources.Consent), Err) {
  let req = sansio.consent_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.consent
  })
}

pub fn contract_create(
  resource: resources.Contract,
  client: FhirClient,
) -> Result(resources.Contract, Err) {
  any_create(
    resources.contract_to_json(resource),
    "Contract",
    resources.contract_decoder(),
    client,
  )
}

pub fn contract_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Contract, Err) {
  any_read(id, client, "Contract", resources.contract_decoder())
}

pub fn contract_update(
  resource: resources.Contract,
  client: FhirClient,
) -> Result(resources.Contract, Err) {
  any_update(
    resource.id,
    resources.contract_to_json(resource),
    "Contract",
    resources.contract_decoder(),
    client,
  )
}

pub fn contract_delete(
  resource: resources.Contract,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Contract", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn contract_search_bundled(sp: sansio.SpContract, client: FhirClient) {
  let req = sansio.contract_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn contract_search(
  sp: sansio.SpContract,
  client: FhirClient,
) -> Result(List(resources.Contract), Err) {
  let req = sansio.contract_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.contract
  })
}

pub fn coverage_create(
  resource: resources.Coverage,
  client: FhirClient,
) -> Result(resources.Coverage, Err) {
  any_create(
    resources.coverage_to_json(resource),
    "Coverage",
    resources.coverage_decoder(),
    client,
  )
}

pub fn coverage_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Coverage, Err) {
  any_read(id, client, "Coverage", resources.coverage_decoder())
}

pub fn coverage_update(
  resource: resources.Coverage,
  client: FhirClient,
) -> Result(resources.Coverage, Err) {
  any_update(
    resource.id,
    resources.coverage_to_json(resource),
    "Coverage",
    resources.coverage_decoder(),
    client,
  )
}

pub fn coverage_delete(
  resource: resources.Coverage,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Coverage", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn coverage_search_bundled(sp: sansio.SpCoverage, client: FhirClient) {
  let req = sansio.coverage_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn coverage_search(
  sp: sansio.SpCoverage,
  client: FhirClient,
) -> Result(List(resources.Coverage), Err) {
  let req = sansio.coverage_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.coverage
  })
}

pub fn coverageeligibilityrequest_create(
  resource: resources.Coverageeligibilityrequest,
  client: FhirClient,
) -> Result(resources.Coverageeligibilityrequest, Err) {
  any_create(
    resources.coverageeligibilityrequest_to_json(resource),
    "CoverageEligibilityRequest",
    resources.coverageeligibilityrequest_decoder(),
    client,
  )
}

pub fn coverageeligibilityrequest_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Coverageeligibilityrequest, Err) {
  any_read(
    id,
    client,
    "CoverageEligibilityRequest",
    resources.coverageeligibilityrequest_decoder(),
  )
}

pub fn coverageeligibilityrequest_update(
  resource: resources.Coverageeligibilityrequest,
  client: FhirClient,
) -> Result(resources.Coverageeligibilityrequest, Err) {
  any_update(
    resource.id,
    resources.coverageeligibilityrequest_to_json(resource),
    "CoverageEligibilityRequest",
    resources.coverageeligibilityrequest_decoder(),
    client,
  )
}

pub fn coverageeligibilityrequest_delete(
  resource: resources.Coverageeligibilityrequest,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Coverageeligibilityrequest", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn coverageeligibilityrequest_search_bundled(
  sp: sansio.SpCoverageeligibilityrequest,
  client: FhirClient,
) {
  let req = sansio.coverageeligibilityrequest_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn coverageeligibilityrequest_search(
  sp: sansio.SpCoverageeligibilityrequest,
  client: FhirClient,
) -> Result(List(resources.Coverageeligibilityrequest), Err) {
  let req = sansio.coverageeligibilityrequest_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.coverageeligibilityrequest
  })
}

pub fn coverageeligibilityresponse_create(
  resource: resources.Coverageeligibilityresponse,
  client: FhirClient,
) -> Result(resources.Coverageeligibilityresponse, Err) {
  any_create(
    resources.coverageeligibilityresponse_to_json(resource),
    "CoverageEligibilityResponse",
    resources.coverageeligibilityresponse_decoder(),
    client,
  )
}

pub fn coverageeligibilityresponse_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Coverageeligibilityresponse, Err) {
  any_read(
    id,
    client,
    "CoverageEligibilityResponse",
    resources.coverageeligibilityresponse_decoder(),
  )
}

pub fn coverageeligibilityresponse_update(
  resource: resources.Coverageeligibilityresponse,
  client: FhirClient,
) -> Result(resources.Coverageeligibilityresponse, Err) {
  any_update(
    resource.id,
    resources.coverageeligibilityresponse_to_json(resource),
    "CoverageEligibilityResponse",
    resources.coverageeligibilityresponse_decoder(),
    client,
  )
}

pub fn coverageeligibilityresponse_delete(
  resource: resources.Coverageeligibilityresponse,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Coverageeligibilityresponse", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn coverageeligibilityresponse_search_bundled(
  sp: sansio.SpCoverageeligibilityresponse,
  client: FhirClient,
) {
  let req = sansio.coverageeligibilityresponse_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn coverageeligibilityresponse_search(
  sp: sansio.SpCoverageeligibilityresponse,
  client: FhirClient,
) -> Result(List(resources.Coverageeligibilityresponse), Err) {
  let req = sansio.coverageeligibilityresponse_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.coverageeligibilityresponse
  })
}

pub fn detectedissue_create(
  resource: resources.Detectedissue,
  client: FhirClient,
) -> Result(resources.Detectedissue, Err) {
  any_create(
    resources.detectedissue_to_json(resource),
    "DetectedIssue",
    resources.detectedissue_decoder(),
    client,
  )
}

pub fn detectedissue_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Detectedissue, Err) {
  any_read(id, client, "DetectedIssue", resources.detectedissue_decoder())
}

pub fn detectedissue_update(
  resource: resources.Detectedissue,
  client: FhirClient,
) -> Result(resources.Detectedissue, Err) {
  any_update(
    resource.id,
    resources.detectedissue_to_json(resource),
    "DetectedIssue",
    resources.detectedissue_decoder(),
    client,
  )
}

pub fn detectedissue_delete(
  resource: resources.Detectedissue,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Detectedissue", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn detectedissue_search_bundled(
  sp: sansio.SpDetectedissue,
  client: FhirClient,
) {
  let req = sansio.detectedissue_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn detectedissue_search(
  sp: sansio.SpDetectedissue,
  client: FhirClient,
) -> Result(List(resources.Detectedissue), Err) {
  let req = sansio.detectedissue_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.detectedissue
  })
}

pub fn device_create(
  resource: resources.Device,
  client: FhirClient,
) -> Result(resources.Device, Err) {
  any_create(
    resources.device_to_json(resource),
    "Device",
    resources.device_decoder(),
    client,
  )
}

pub fn device_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Device, Err) {
  any_read(id, client, "Device", resources.device_decoder())
}

pub fn device_update(
  resource: resources.Device,
  client: FhirClient,
) -> Result(resources.Device, Err) {
  any_update(
    resource.id,
    resources.device_to_json(resource),
    "Device",
    resources.device_decoder(),
    client,
  )
}

pub fn device_delete(
  resource: resources.Device,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Device", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn device_search_bundled(sp: sansio.SpDevice, client: FhirClient) {
  let req = sansio.device_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn device_search(
  sp: sansio.SpDevice,
  client: FhirClient,
) -> Result(List(resources.Device), Err) {
  let req = sansio.device_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.device
  })
}

pub fn devicedefinition_create(
  resource: resources.Devicedefinition,
  client: FhirClient,
) -> Result(resources.Devicedefinition, Err) {
  any_create(
    resources.devicedefinition_to_json(resource),
    "DeviceDefinition",
    resources.devicedefinition_decoder(),
    client,
  )
}

pub fn devicedefinition_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Devicedefinition, Err) {
  any_read(id, client, "DeviceDefinition", resources.devicedefinition_decoder())
}

pub fn devicedefinition_update(
  resource: resources.Devicedefinition,
  client: FhirClient,
) -> Result(resources.Devicedefinition, Err) {
  any_update(
    resource.id,
    resources.devicedefinition_to_json(resource),
    "DeviceDefinition",
    resources.devicedefinition_decoder(),
    client,
  )
}

pub fn devicedefinition_delete(
  resource: resources.Devicedefinition,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Devicedefinition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn devicedefinition_search_bundled(
  sp: sansio.SpDevicedefinition,
  client: FhirClient,
) {
  let req = sansio.devicedefinition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn devicedefinition_search(
  sp: sansio.SpDevicedefinition,
  client: FhirClient,
) -> Result(List(resources.Devicedefinition), Err) {
  let req = sansio.devicedefinition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.devicedefinition
  })
}

pub fn devicemetric_create(
  resource: resources.Devicemetric,
  client: FhirClient,
) -> Result(resources.Devicemetric, Err) {
  any_create(
    resources.devicemetric_to_json(resource),
    "DeviceMetric",
    resources.devicemetric_decoder(),
    client,
  )
}

pub fn devicemetric_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Devicemetric, Err) {
  any_read(id, client, "DeviceMetric", resources.devicemetric_decoder())
}

pub fn devicemetric_update(
  resource: resources.Devicemetric,
  client: FhirClient,
) -> Result(resources.Devicemetric, Err) {
  any_update(
    resource.id,
    resources.devicemetric_to_json(resource),
    "DeviceMetric",
    resources.devicemetric_decoder(),
    client,
  )
}

pub fn devicemetric_delete(
  resource: resources.Devicemetric,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Devicemetric", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn devicemetric_search_bundled(
  sp: sansio.SpDevicemetric,
  client: FhirClient,
) {
  let req = sansio.devicemetric_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn devicemetric_search(
  sp: sansio.SpDevicemetric,
  client: FhirClient,
) -> Result(List(resources.Devicemetric), Err) {
  let req = sansio.devicemetric_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.devicemetric
  })
}

pub fn devicerequest_create(
  resource: resources.Devicerequest,
  client: FhirClient,
) -> Result(resources.Devicerequest, Err) {
  any_create(
    resources.devicerequest_to_json(resource),
    "DeviceRequest",
    resources.devicerequest_decoder(),
    client,
  )
}

pub fn devicerequest_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Devicerequest, Err) {
  any_read(id, client, "DeviceRequest", resources.devicerequest_decoder())
}

pub fn devicerequest_update(
  resource: resources.Devicerequest,
  client: FhirClient,
) -> Result(resources.Devicerequest, Err) {
  any_update(
    resource.id,
    resources.devicerequest_to_json(resource),
    "DeviceRequest",
    resources.devicerequest_decoder(),
    client,
  )
}

pub fn devicerequest_delete(
  resource: resources.Devicerequest,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Devicerequest", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn devicerequest_search_bundled(
  sp: sansio.SpDevicerequest,
  client: FhirClient,
) {
  let req = sansio.devicerequest_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn devicerequest_search(
  sp: sansio.SpDevicerequest,
  client: FhirClient,
) -> Result(List(resources.Devicerequest), Err) {
  let req = sansio.devicerequest_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.devicerequest
  })
}

pub fn deviceusestatement_create(
  resource: resources.Deviceusestatement,
  client: FhirClient,
) -> Result(resources.Deviceusestatement, Err) {
  any_create(
    resources.deviceusestatement_to_json(resource),
    "DeviceUseStatement",
    resources.deviceusestatement_decoder(),
    client,
  )
}

pub fn deviceusestatement_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Deviceusestatement, Err) {
  any_read(
    id,
    client,
    "DeviceUseStatement",
    resources.deviceusestatement_decoder(),
  )
}

pub fn deviceusestatement_update(
  resource: resources.Deviceusestatement,
  client: FhirClient,
) -> Result(resources.Deviceusestatement, Err) {
  any_update(
    resource.id,
    resources.deviceusestatement_to_json(resource),
    "DeviceUseStatement",
    resources.deviceusestatement_decoder(),
    client,
  )
}

pub fn deviceusestatement_delete(
  resource: resources.Deviceusestatement,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Deviceusestatement", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn deviceusestatement_search_bundled(
  sp: sansio.SpDeviceusestatement,
  client: FhirClient,
) {
  let req = sansio.deviceusestatement_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn deviceusestatement_search(
  sp: sansio.SpDeviceusestatement,
  client: FhirClient,
) -> Result(List(resources.Deviceusestatement), Err) {
  let req = sansio.deviceusestatement_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.deviceusestatement
  })
}

pub fn diagnosticreport_create(
  resource: resources.Diagnosticreport,
  client: FhirClient,
) -> Result(resources.Diagnosticreport, Err) {
  any_create(
    resources.diagnosticreport_to_json(resource),
    "DiagnosticReport",
    resources.diagnosticreport_decoder(),
    client,
  )
}

pub fn diagnosticreport_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Diagnosticreport, Err) {
  any_read(id, client, "DiagnosticReport", resources.diagnosticreport_decoder())
}

pub fn diagnosticreport_update(
  resource: resources.Diagnosticreport,
  client: FhirClient,
) -> Result(resources.Diagnosticreport, Err) {
  any_update(
    resource.id,
    resources.diagnosticreport_to_json(resource),
    "DiagnosticReport",
    resources.diagnosticreport_decoder(),
    client,
  )
}

pub fn diagnosticreport_delete(
  resource: resources.Diagnosticreport,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Diagnosticreport", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn diagnosticreport_search_bundled(
  sp: sansio.SpDiagnosticreport,
  client: FhirClient,
) {
  let req = sansio.diagnosticreport_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn diagnosticreport_search(
  sp: sansio.SpDiagnosticreport,
  client: FhirClient,
) -> Result(List(resources.Diagnosticreport), Err) {
  let req = sansio.diagnosticreport_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.diagnosticreport
  })
}

pub fn documentmanifest_create(
  resource: resources.Documentmanifest,
  client: FhirClient,
) -> Result(resources.Documentmanifest, Err) {
  any_create(
    resources.documentmanifest_to_json(resource),
    "DocumentManifest",
    resources.documentmanifest_decoder(),
    client,
  )
}

pub fn documentmanifest_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Documentmanifest, Err) {
  any_read(id, client, "DocumentManifest", resources.documentmanifest_decoder())
}

pub fn documentmanifest_update(
  resource: resources.Documentmanifest,
  client: FhirClient,
) -> Result(resources.Documentmanifest, Err) {
  any_update(
    resource.id,
    resources.documentmanifest_to_json(resource),
    "DocumentManifest",
    resources.documentmanifest_decoder(),
    client,
  )
}

pub fn documentmanifest_delete(
  resource: resources.Documentmanifest,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Documentmanifest", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn documentmanifest_search_bundled(
  sp: sansio.SpDocumentmanifest,
  client: FhirClient,
) {
  let req = sansio.documentmanifest_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn documentmanifest_search(
  sp: sansio.SpDocumentmanifest,
  client: FhirClient,
) -> Result(List(resources.Documentmanifest), Err) {
  let req = sansio.documentmanifest_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.documentmanifest
  })
}

pub fn documentreference_create(
  resource: resources.Documentreference,
  client: FhirClient,
) -> Result(resources.Documentreference, Err) {
  any_create(
    resources.documentreference_to_json(resource),
    "DocumentReference",
    resources.documentreference_decoder(),
    client,
  )
}

pub fn documentreference_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Documentreference, Err) {
  any_read(
    id,
    client,
    "DocumentReference",
    resources.documentreference_decoder(),
  )
}

pub fn documentreference_update(
  resource: resources.Documentreference,
  client: FhirClient,
) -> Result(resources.Documentreference, Err) {
  any_update(
    resource.id,
    resources.documentreference_to_json(resource),
    "DocumentReference",
    resources.documentreference_decoder(),
    client,
  )
}

pub fn documentreference_delete(
  resource: resources.Documentreference,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Documentreference", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn documentreference_search_bundled(
  sp: sansio.SpDocumentreference,
  client: FhirClient,
) {
  let req = sansio.documentreference_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn documentreference_search(
  sp: sansio.SpDocumentreference,
  client: FhirClient,
) -> Result(List(resources.Documentreference), Err) {
  let req = sansio.documentreference_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.documentreference
  })
}

pub fn effectevidencesynthesis_create(
  resource: resources.Effectevidencesynthesis,
  client: FhirClient,
) -> Result(resources.Effectevidencesynthesis, Err) {
  any_create(
    resources.effectevidencesynthesis_to_json(resource),
    "EffectEvidenceSynthesis",
    resources.effectevidencesynthesis_decoder(),
    client,
  )
}

pub fn effectevidencesynthesis_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Effectevidencesynthesis, Err) {
  any_read(
    id,
    client,
    "EffectEvidenceSynthesis",
    resources.effectevidencesynthesis_decoder(),
  )
}

pub fn effectevidencesynthesis_update(
  resource: resources.Effectevidencesynthesis,
  client: FhirClient,
) -> Result(resources.Effectevidencesynthesis, Err) {
  any_update(
    resource.id,
    resources.effectevidencesynthesis_to_json(resource),
    "EffectEvidenceSynthesis",
    resources.effectevidencesynthesis_decoder(),
    client,
  )
}

pub fn effectevidencesynthesis_delete(
  resource: resources.Effectevidencesynthesis,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Effectevidencesynthesis", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn effectevidencesynthesis_search_bundled(
  sp: sansio.SpEffectevidencesynthesis,
  client: FhirClient,
) {
  let req = sansio.effectevidencesynthesis_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn effectevidencesynthesis_search(
  sp: sansio.SpEffectevidencesynthesis,
  client: FhirClient,
) -> Result(List(resources.Effectevidencesynthesis), Err) {
  let req = sansio.effectevidencesynthesis_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.effectevidencesynthesis
  })
}

pub fn encounter_create(
  resource: resources.Encounter,
  client: FhirClient,
) -> Result(resources.Encounter, Err) {
  any_create(
    resources.encounter_to_json(resource),
    "Encounter",
    resources.encounter_decoder(),
    client,
  )
}

pub fn encounter_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Encounter, Err) {
  any_read(id, client, "Encounter", resources.encounter_decoder())
}

pub fn encounter_update(
  resource: resources.Encounter,
  client: FhirClient,
) -> Result(resources.Encounter, Err) {
  any_update(
    resource.id,
    resources.encounter_to_json(resource),
    "Encounter",
    resources.encounter_decoder(),
    client,
  )
}

pub fn encounter_delete(
  resource: resources.Encounter,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Encounter", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn encounter_search_bundled(sp: sansio.SpEncounter, client: FhirClient) {
  let req = sansio.encounter_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn encounter_search(
  sp: sansio.SpEncounter,
  client: FhirClient,
) -> Result(List(resources.Encounter), Err) {
  let req = sansio.encounter_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.encounter
  })
}

pub fn endpoint_create(
  resource: resources.Endpoint,
  client: FhirClient,
) -> Result(resources.Endpoint, Err) {
  any_create(
    resources.endpoint_to_json(resource),
    "Endpoint",
    resources.endpoint_decoder(),
    client,
  )
}

pub fn endpoint_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Endpoint, Err) {
  any_read(id, client, "Endpoint", resources.endpoint_decoder())
}

pub fn endpoint_update(
  resource: resources.Endpoint,
  client: FhirClient,
) -> Result(resources.Endpoint, Err) {
  any_update(
    resource.id,
    resources.endpoint_to_json(resource),
    "Endpoint",
    resources.endpoint_decoder(),
    client,
  )
}

pub fn endpoint_delete(
  resource: resources.Endpoint,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Endpoint", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn endpoint_search_bundled(sp: sansio.SpEndpoint, client: FhirClient) {
  let req = sansio.endpoint_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn endpoint_search(
  sp: sansio.SpEndpoint,
  client: FhirClient,
) -> Result(List(resources.Endpoint), Err) {
  let req = sansio.endpoint_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.endpoint
  })
}

pub fn enrollmentrequest_create(
  resource: resources.Enrollmentrequest,
  client: FhirClient,
) -> Result(resources.Enrollmentrequest, Err) {
  any_create(
    resources.enrollmentrequest_to_json(resource),
    "EnrollmentRequest",
    resources.enrollmentrequest_decoder(),
    client,
  )
}

pub fn enrollmentrequest_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Enrollmentrequest, Err) {
  any_read(
    id,
    client,
    "EnrollmentRequest",
    resources.enrollmentrequest_decoder(),
  )
}

pub fn enrollmentrequest_update(
  resource: resources.Enrollmentrequest,
  client: FhirClient,
) -> Result(resources.Enrollmentrequest, Err) {
  any_update(
    resource.id,
    resources.enrollmentrequest_to_json(resource),
    "EnrollmentRequest",
    resources.enrollmentrequest_decoder(),
    client,
  )
}

pub fn enrollmentrequest_delete(
  resource: resources.Enrollmentrequest,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Enrollmentrequest", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn enrollmentrequest_search_bundled(
  sp: sansio.SpEnrollmentrequest,
  client: FhirClient,
) {
  let req = sansio.enrollmentrequest_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn enrollmentrequest_search(
  sp: sansio.SpEnrollmentrequest,
  client: FhirClient,
) -> Result(List(resources.Enrollmentrequest), Err) {
  let req = sansio.enrollmentrequest_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.enrollmentrequest
  })
}

pub fn enrollmentresponse_create(
  resource: resources.Enrollmentresponse,
  client: FhirClient,
) -> Result(resources.Enrollmentresponse, Err) {
  any_create(
    resources.enrollmentresponse_to_json(resource),
    "EnrollmentResponse",
    resources.enrollmentresponse_decoder(),
    client,
  )
}

pub fn enrollmentresponse_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Enrollmentresponse, Err) {
  any_read(
    id,
    client,
    "EnrollmentResponse",
    resources.enrollmentresponse_decoder(),
  )
}

pub fn enrollmentresponse_update(
  resource: resources.Enrollmentresponse,
  client: FhirClient,
) -> Result(resources.Enrollmentresponse, Err) {
  any_update(
    resource.id,
    resources.enrollmentresponse_to_json(resource),
    "EnrollmentResponse",
    resources.enrollmentresponse_decoder(),
    client,
  )
}

pub fn enrollmentresponse_delete(
  resource: resources.Enrollmentresponse,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Enrollmentresponse", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn enrollmentresponse_search_bundled(
  sp: sansio.SpEnrollmentresponse,
  client: FhirClient,
) {
  let req = sansio.enrollmentresponse_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn enrollmentresponse_search(
  sp: sansio.SpEnrollmentresponse,
  client: FhirClient,
) -> Result(List(resources.Enrollmentresponse), Err) {
  let req = sansio.enrollmentresponse_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.enrollmentresponse
  })
}

pub fn episodeofcare_create(
  resource: resources.Episodeofcare,
  client: FhirClient,
) -> Result(resources.Episodeofcare, Err) {
  any_create(
    resources.episodeofcare_to_json(resource),
    "EpisodeOfCare",
    resources.episodeofcare_decoder(),
    client,
  )
}

pub fn episodeofcare_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Episodeofcare, Err) {
  any_read(id, client, "EpisodeOfCare", resources.episodeofcare_decoder())
}

pub fn episodeofcare_update(
  resource: resources.Episodeofcare,
  client: FhirClient,
) -> Result(resources.Episodeofcare, Err) {
  any_update(
    resource.id,
    resources.episodeofcare_to_json(resource),
    "EpisodeOfCare",
    resources.episodeofcare_decoder(),
    client,
  )
}

pub fn episodeofcare_delete(
  resource: resources.Episodeofcare,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Episodeofcare", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn episodeofcare_search_bundled(
  sp: sansio.SpEpisodeofcare,
  client: FhirClient,
) {
  let req = sansio.episodeofcare_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn episodeofcare_search(
  sp: sansio.SpEpisodeofcare,
  client: FhirClient,
) -> Result(List(resources.Episodeofcare), Err) {
  let req = sansio.episodeofcare_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.episodeofcare
  })
}

pub fn eventdefinition_create(
  resource: resources.Eventdefinition,
  client: FhirClient,
) -> Result(resources.Eventdefinition, Err) {
  any_create(
    resources.eventdefinition_to_json(resource),
    "EventDefinition",
    resources.eventdefinition_decoder(),
    client,
  )
}

pub fn eventdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Eventdefinition, Err) {
  any_read(id, client, "EventDefinition", resources.eventdefinition_decoder())
}

pub fn eventdefinition_update(
  resource: resources.Eventdefinition,
  client: FhirClient,
) -> Result(resources.Eventdefinition, Err) {
  any_update(
    resource.id,
    resources.eventdefinition_to_json(resource),
    "EventDefinition",
    resources.eventdefinition_decoder(),
    client,
  )
}

pub fn eventdefinition_delete(
  resource: resources.Eventdefinition,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Eventdefinition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn eventdefinition_search_bundled(
  sp: sansio.SpEventdefinition,
  client: FhirClient,
) {
  let req = sansio.eventdefinition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn eventdefinition_search(
  sp: sansio.SpEventdefinition,
  client: FhirClient,
) -> Result(List(resources.Eventdefinition), Err) {
  let req = sansio.eventdefinition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.eventdefinition
  })
}

pub fn evidence_create(
  resource: resources.Evidence,
  client: FhirClient,
) -> Result(resources.Evidence, Err) {
  any_create(
    resources.evidence_to_json(resource),
    "Evidence",
    resources.evidence_decoder(),
    client,
  )
}

pub fn evidence_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Evidence, Err) {
  any_read(id, client, "Evidence", resources.evidence_decoder())
}

pub fn evidence_update(
  resource: resources.Evidence,
  client: FhirClient,
) -> Result(resources.Evidence, Err) {
  any_update(
    resource.id,
    resources.evidence_to_json(resource),
    "Evidence",
    resources.evidence_decoder(),
    client,
  )
}

pub fn evidence_delete(
  resource: resources.Evidence,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Evidence", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn evidence_search_bundled(sp: sansio.SpEvidence, client: FhirClient) {
  let req = sansio.evidence_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn evidence_search(
  sp: sansio.SpEvidence,
  client: FhirClient,
) -> Result(List(resources.Evidence), Err) {
  let req = sansio.evidence_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.evidence
  })
}

pub fn evidencevariable_create(
  resource: resources.Evidencevariable,
  client: FhirClient,
) -> Result(resources.Evidencevariable, Err) {
  any_create(
    resources.evidencevariable_to_json(resource),
    "EvidenceVariable",
    resources.evidencevariable_decoder(),
    client,
  )
}

pub fn evidencevariable_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Evidencevariable, Err) {
  any_read(id, client, "EvidenceVariable", resources.evidencevariable_decoder())
}

pub fn evidencevariable_update(
  resource: resources.Evidencevariable,
  client: FhirClient,
) -> Result(resources.Evidencevariable, Err) {
  any_update(
    resource.id,
    resources.evidencevariable_to_json(resource),
    "EvidenceVariable",
    resources.evidencevariable_decoder(),
    client,
  )
}

pub fn evidencevariable_delete(
  resource: resources.Evidencevariable,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Evidencevariable", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn evidencevariable_search_bundled(
  sp: sansio.SpEvidencevariable,
  client: FhirClient,
) {
  let req = sansio.evidencevariable_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn evidencevariable_search(
  sp: sansio.SpEvidencevariable,
  client: FhirClient,
) -> Result(List(resources.Evidencevariable), Err) {
  let req = sansio.evidencevariable_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.evidencevariable
  })
}

pub fn examplescenario_create(
  resource: resources.Examplescenario,
  client: FhirClient,
) -> Result(resources.Examplescenario, Err) {
  any_create(
    resources.examplescenario_to_json(resource),
    "ExampleScenario",
    resources.examplescenario_decoder(),
    client,
  )
}

pub fn examplescenario_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Examplescenario, Err) {
  any_read(id, client, "ExampleScenario", resources.examplescenario_decoder())
}

pub fn examplescenario_update(
  resource: resources.Examplescenario,
  client: FhirClient,
) -> Result(resources.Examplescenario, Err) {
  any_update(
    resource.id,
    resources.examplescenario_to_json(resource),
    "ExampleScenario",
    resources.examplescenario_decoder(),
    client,
  )
}

pub fn examplescenario_delete(
  resource: resources.Examplescenario,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Examplescenario", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn examplescenario_search_bundled(
  sp: sansio.SpExamplescenario,
  client: FhirClient,
) {
  let req = sansio.examplescenario_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn examplescenario_search(
  sp: sansio.SpExamplescenario,
  client: FhirClient,
) -> Result(List(resources.Examplescenario), Err) {
  let req = sansio.examplescenario_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.examplescenario
  })
}

pub fn explanationofbenefit_create(
  resource: resources.Explanationofbenefit,
  client: FhirClient,
) -> Result(resources.Explanationofbenefit, Err) {
  any_create(
    resources.explanationofbenefit_to_json(resource),
    "ExplanationOfBenefit",
    resources.explanationofbenefit_decoder(),
    client,
  )
}

pub fn explanationofbenefit_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Explanationofbenefit, Err) {
  any_read(
    id,
    client,
    "ExplanationOfBenefit",
    resources.explanationofbenefit_decoder(),
  )
}

pub fn explanationofbenefit_update(
  resource: resources.Explanationofbenefit,
  client: FhirClient,
) -> Result(resources.Explanationofbenefit, Err) {
  any_update(
    resource.id,
    resources.explanationofbenefit_to_json(resource),
    "ExplanationOfBenefit",
    resources.explanationofbenefit_decoder(),
    client,
  )
}

pub fn explanationofbenefit_delete(
  resource: resources.Explanationofbenefit,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Explanationofbenefit", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn explanationofbenefit_search_bundled(
  sp: sansio.SpExplanationofbenefit,
  client: FhirClient,
) {
  let req = sansio.explanationofbenefit_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn explanationofbenefit_search(
  sp: sansio.SpExplanationofbenefit,
  client: FhirClient,
) -> Result(List(resources.Explanationofbenefit), Err) {
  let req = sansio.explanationofbenefit_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.explanationofbenefit
  })
}

pub fn familymemberhistory_create(
  resource: resources.Familymemberhistory,
  client: FhirClient,
) -> Result(resources.Familymemberhistory, Err) {
  any_create(
    resources.familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    resources.familymemberhistory_decoder(),
    client,
  )
}

pub fn familymemberhistory_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Familymemberhistory, Err) {
  any_read(
    id,
    client,
    "FamilyMemberHistory",
    resources.familymemberhistory_decoder(),
  )
}

pub fn familymemberhistory_update(
  resource: resources.Familymemberhistory,
  client: FhirClient,
) -> Result(resources.Familymemberhistory, Err) {
  any_update(
    resource.id,
    resources.familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    resources.familymemberhistory_decoder(),
    client,
  )
}

pub fn familymemberhistory_delete(
  resource: resources.Familymemberhistory,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Familymemberhistory", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn familymemberhistory_search_bundled(
  sp: sansio.SpFamilymemberhistory,
  client: FhirClient,
) {
  let req = sansio.familymemberhistory_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn familymemberhistory_search(
  sp: sansio.SpFamilymemberhistory,
  client: FhirClient,
) -> Result(List(resources.Familymemberhistory), Err) {
  let req = sansio.familymemberhistory_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.familymemberhistory
  })
}

pub fn flag_create(
  resource: resources.Flag,
  client: FhirClient,
) -> Result(resources.Flag, Err) {
  any_create(
    resources.flag_to_json(resource),
    "Flag",
    resources.flag_decoder(),
    client,
  )
}

pub fn flag_read(id: String, client: FhirClient) -> Result(resources.Flag, Err) {
  any_read(id, client, "Flag", resources.flag_decoder())
}

pub fn flag_update(
  resource: resources.Flag,
  client: FhirClient,
) -> Result(resources.Flag, Err) {
  any_update(
    resource.id,
    resources.flag_to_json(resource),
    "Flag",
    resources.flag_decoder(),
    client,
  )
}

pub fn flag_delete(
  resource: resources.Flag,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Flag", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn flag_search_bundled(sp: sansio.SpFlag, client: FhirClient) {
  let req = sansio.flag_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn flag_search(
  sp: sansio.SpFlag,
  client: FhirClient,
) -> Result(List(resources.Flag), Err) {
  let req = sansio.flag_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.flag
  })
}

pub fn goal_create(
  resource: resources.Goal,
  client: FhirClient,
) -> Result(resources.Goal, Err) {
  any_create(
    resources.goal_to_json(resource),
    "Goal",
    resources.goal_decoder(),
    client,
  )
}

pub fn goal_read(id: String, client: FhirClient) -> Result(resources.Goal, Err) {
  any_read(id, client, "Goal", resources.goal_decoder())
}

pub fn goal_update(
  resource: resources.Goal,
  client: FhirClient,
) -> Result(resources.Goal, Err) {
  any_update(
    resource.id,
    resources.goal_to_json(resource),
    "Goal",
    resources.goal_decoder(),
    client,
  )
}

pub fn goal_delete(
  resource: resources.Goal,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Goal", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn goal_search_bundled(sp: sansio.SpGoal, client: FhirClient) {
  let req = sansio.goal_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn goal_search(
  sp: sansio.SpGoal,
  client: FhirClient,
) -> Result(List(resources.Goal), Err) {
  let req = sansio.goal_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.goal
  })
}

pub fn graphdefinition_create(
  resource: resources.Graphdefinition,
  client: FhirClient,
) -> Result(resources.Graphdefinition, Err) {
  any_create(
    resources.graphdefinition_to_json(resource),
    "GraphDefinition",
    resources.graphdefinition_decoder(),
    client,
  )
}

pub fn graphdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Graphdefinition, Err) {
  any_read(id, client, "GraphDefinition", resources.graphdefinition_decoder())
}

pub fn graphdefinition_update(
  resource: resources.Graphdefinition,
  client: FhirClient,
) -> Result(resources.Graphdefinition, Err) {
  any_update(
    resource.id,
    resources.graphdefinition_to_json(resource),
    "GraphDefinition",
    resources.graphdefinition_decoder(),
    client,
  )
}

pub fn graphdefinition_delete(
  resource: resources.Graphdefinition,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Graphdefinition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn graphdefinition_search_bundled(
  sp: sansio.SpGraphdefinition,
  client: FhirClient,
) {
  let req = sansio.graphdefinition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn graphdefinition_search(
  sp: sansio.SpGraphdefinition,
  client: FhirClient,
) -> Result(List(resources.Graphdefinition), Err) {
  let req = sansio.graphdefinition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.graphdefinition
  })
}

pub fn group_create(
  resource: resources.Group,
  client: FhirClient,
) -> Result(resources.Group, Err) {
  any_create(
    resources.group_to_json(resource),
    "Group",
    resources.group_decoder(),
    client,
  )
}

pub fn group_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Group, Err) {
  any_read(id, client, "Group", resources.group_decoder())
}

pub fn group_update(
  resource: resources.Group,
  client: FhirClient,
) -> Result(resources.Group, Err) {
  any_update(
    resource.id,
    resources.group_to_json(resource),
    "Group",
    resources.group_decoder(),
    client,
  )
}

pub fn group_delete(
  resource: resources.Group,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Group", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn group_search_bundled(sp: sansio.SpGroup, client: FhirClient) {
  let req = sansio.group_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn group_search(
  sp: sansio.SpGroup,
  client: FhirClient,
) -> Result(List(resources.Group), Err) {
  let req = sansio.group_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.group
  })
}

pub fn guidanceresponse_create(
  resource: resources.Guidanceresponse,
  client: FhirClient,
) -> Result(resources.Guidanceresponse, Err) {
  any_create(
    resources.guidanceresponse_to_json(resource),
    "GuidanceResponse",
    resources.guidanceresponse_decoder(),
    client,
  )
}

pub fn guidanceresponse_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Guidanceresponse, Err) {
  any_read(id, client, "GuidanceResponse", resources.guidanceresponse_decoder())
}

pub fn guidanceresponse_update(
  resource: resources.Guidanceresponse,
  client: FhirClient,
) -> Result(resources.Guidanceresponse, Err) {
  any_update(
    resource.id,
    resources.guidanceresponse_to_json(resource),
    "GuidanceResponse",
    resources.guidanceresponse_decoder(),
    client,
  )
}

pub fn guidanceresponse_delete(
  resource: resources.Guidanceresponse,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Guidanceresponse", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn guidanceresponse_search_bundled(
  sp: sansio.SpGuidanceresponse,
  client: FhirClient,
) {
  let req = sansio.guidanceresponse_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn guidanceresponse_search(
  sp: sansio.SpGuidanceresponse,
  client: FhirClient,
) -> Result(List(resources.Guidanceresponse), Err) {
  let req = sansio.guidanceresponse_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.guidanceresponse
  })
}

pub fn healthcareservice_create(
  resource: resources.Healthcareservice,
  client: FhirClient,
) -> Result(resources.Healthcareservice, Err) {
  any_create(
    resources.healthcareservice_to_json(resource),
    "HealthcareService",
    resources.healthcareservice_decoder(),
    client,
  )
}

pub fn healthcareservice_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Healthcareservice, Err) {
  any_read(
    id,
    client,
    "HealthcareService",
    resources.healthcareservice_decoder(),
  )
}

pub fn healthcareservice_update(
  resource: resources.Healthcareservice,
  client: FhirClient,
) -> Result(resources.Healthcareservice, Err) {
  any_update(
    resource.id,
    resources.healthcareservice_to_json(resource),
    "HealthcareService",
    resources.healthcareservice_decoder(),
    client,
  )
}

pub fn healthcareservice_delete(
  resource: resources.Healthcareservice,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Healthcareservice", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn healthcareservice_search_bundled(
  sp: sansio.SpHealthcareservice,
  client: FhirClient,
) {
  let req = sansio.healthcareservice_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn healthcareservice_search(
  sp: sansio.SpHealthcareservice,
  client: FhirClient,
) -> Result(List(resources.Healthcareservice), Err) {
  let req = sansio.healthcareservice_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.healthcareservice
  })
}

pub fn imagingstudy_create(
  resource: resources.Imagingstudy,
  client: FhirClient,
) -> Result(resources.Imagingstudy, Err) {
  any_create(
    resources.imagingstudy_to_json(resource),
    "ImagingStudy",
    resources.imagingstudy_decoder(),
    client,
  )
}

pub fn imagingstudy_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Imagingstudy, Err) {
  any_read(id, client, "ImagingStudy", resources.imagingstudy_decoder())
}

pub fn imagingstudy_update(
  resource: resources.Imagingstudy,
  client: FhirClient,
) -> Result(resources.Imagingstudy, Err) {
  any_update(
    resource.id,
    resources.imagingstudy_to_json(resource),
    "ImagingStudy",
    resources.imagingstudy_decoder(),
    client,
  )
}

pub fn imagingstudy_delete(
  resource: resources.Imagingstudy,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Imagingstudy", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn imagingstudy_search_bundled(
  sp: sansio.SpImagingstudy,
  client: FhirClient,
) {
  let req = sansio.imagingstudy_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn imagingstudy_search(
  sp: sansio.SpImagingstudy,
  client: FhirClient,
) -> Result(List(resources.Imagingstudy), Err) {
  let req = sansio.imagingstudy_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.imagingstudy
  })
}

pub fn immunization_create(
  resource: resources.Immunization,
  client: FhirClient,
) -> Result(resources.Immunization, Err) {
  any_create(
    resources.immunization_to_json(resource),
    "Immunization",
    resources.immunization_decoder(),
    client,
  )
}

pub fn immunization_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Immunization, Err) {
  any_read(id, client, "Immunization", resources.immunization_decoder())
}

pub fn immunization_update(
  resource: resources.Immunization,
  client: FhirClient,
) -> Result(resources.Immunization, Err) {
  any_update(
    resource.id,
    resources.immunization_to_json(resource),
    "Immunization",
    resources.immunization_decoder(),
    client,
  )
}

pub fn immunization_delete(
  resource: resources.Immunization,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Immunization", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn immunization_search_bundled(
  sp: sansio.SpImmunization,
  client: FhirClient,
) {
  let req = sansio.immunization_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn immunization_search(
  sp: sansio.SpImmunization,
  client: FhirClient,
) -> Result(List(resources.Immunization), Err) {
  let req = sansio.immunization_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.immunization
  })
}

pub fn immunizationevaluation_create(
  resource: resources.Immunizationevaluation,
  client: FhirClient,
) -> Result(resources.Immunizationevaluation, Err) {
  any_create(
    resources.immunizationevaluation_to_json(resource),
    "ImmunizationEvaluation",
    resources.immunizationevaluation_decoder(),
    client,
  )
}

pub fn immunizationevaluation_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Immunizationevaluation, Err) {
  any_read(
    id,
    client,
    "ImmunizationEvaluation",
    resources.immunizationevaluation_decoder(),
  )
}

pub fn immunizationevaluation_update(
  resource: resources.Immunizationevaluation,
  client: FhirClient,
) -> Result(resources.Immunizationevaluation, Err) {
  any_update(
    resource.id,
    resources.immunizationevaluation_to_json(resource),
    "ImmunizationEvaluation",
    resources.immunizationevaluation_decoder(),
    client,
  )
}

pub fn immunizationevaluation_delete(
  resource: resources.Immunizationevaluation,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Immunizationevaluation", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn immunizationevaluation_search_bundled(
  sp: sansio.SpImmunizationevaluation,
  client: FhirClient,
) {
  let req = sansio.immunizationevaluation_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn immunizationevaluation_search(
  sp: sansio.SpImmunizationevaluation,
  client: FhirClient,
) -> Result(List(resources.Immunizationevaluation), Err) {
  let req = sansio.immunizationevaluation_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.immunizationevaluation
  })
}

pub fn immunizationrecommendation_create(
  resource: resources.Immunizationrecommendation,
  client: FhirClient,
) -> Result(resources.Immunizationrecommendation, Err) {
  any_create(
    resources.immunizationrecommendation_to_json(resource),
    "ImmunizationRecommendation",
    resources.immunizationrecommendation_decoder(),
    client,
  )
}

pub fn immunizationrecommendation_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Immunizationrecommendation, Err) {
  any_read(
    id,
    client,
    "ImmunizationRecommendation",
    resources.immunizationrecommendation_decoder(),
  )
}

pub fn immunizationrecommendation_update(
  resource: resources.Immunizationrecommendation,
  client: FhirClient,
) -> Result(resources.Immunizationrecommendation, Err) {
  any_update(
    resource.id,
    resources.immunizationrecommendation_to_json(resource),
    "ImmunizationRecommendation",
    resources.immunizationrecommendation_decoder(),
    client,
  )
}

pub fn immunizationrecommendation_delete(
  resource: resources.Immunizationrecommendation,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Immunizationrecommendation", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn immunizationrecommendation_search_bundled(
  sp: sansio.SpImmunizationrecommendation,
  client: FhirClient,
) {
  let req = sansio.immunizationrecommendation_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn immunizationrecommendation_search(
  sp: sansio.SpImmunizationrecommendation,
  client: FhirClient,
) -> Result(List(resources.Immunizationrecommendation), Err) {
  let req = sansio.immunizationrecommendation_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.immunizationrecommendation
  })
}

pub fn implementationguide_create(
  resource: resources.Implementationguide,
  client: FhirClient,
) -> Result(resources.Implementationguide, Err) {
  any_create(
    resources.implementationguide_to_json(resource),
    "ImplementationGuide",
    resources.implementationguide_decoder(),
    client,
  )
}

pub fn implementationguide_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Implementationguide, Err) {
  any_read(
    id,
    client,
    "ImplementationGuide",
    resources.implementationguide_decoder(),
  )
}

pub fn implementationguide_update(
  resource: resources.Implementationguide,
  client: FhirClient,
) -> Result(resources.Implementationguide, Err) {
  any_update(
    resource.id,
    resources.implementationguide_to_json(resource),
    "ImplementationGuide",
    resources.implementationguide_decoder(),
    client,
  )
}

pub fn implementationguide_delete(
  resource: resources.Implementationguide,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Implementationguide", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn implementationguide_search_bundled(
  sp: sansio.SpImplementationguide,
  client: FhirClient,
) {
  let req = sansio.implementationguide_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn implementationguide_search(
  sp: sansio.SpImplementationguide,
  client: FhirClient,
) -> Result(List(resources.Implementationguide), Err) {
  let req = sansio.implementationguide_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.implementationguide
  })
}

pub fn insuranceplan_create(
  resource: resources.Insuranceplan,
  client: FhirClient,
) -> Result(resources.Insuranceplan, Err) {
  any_create(
    resources.insuranceplan_to_json(resource),
    "InsurancePlan",
    resources.insuranceplan_decoder(),
    client,
  )
}

pub fn insuranceplan_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Insuranceplan, Err) {
  any_read(id, client, "InsurancePlan", resources.insuranceplan_decoder())
}

pub fn insuranceplan_update(
  resource: resources.Insuranceplan,
  client: FhirClient,
) -> Result(resources.Insuranceplan, Err) {
  any_update(
    resource.id,
    resources.insuranceplan_to_json(resource),
    "InsurancePlan",
    resources.insuranceplan_decoder(),
    client,
  )
}

pub fn insuranceplan_delete(
  resource: resources.Insuranceplan,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Insuranceplan", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn insuranceplan_search_bundled(
  sp: sansio.SpInsuranceplan,
  client: FhirClient,
) {
  let req = sansio.insuranceplan_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn insuranceplan_search(
  sp: sansio.SpInsuranceplan,
  client: FhirClient,
) -> Result(List(resources.Insuranceplan), Err) {
  let req = sansio.insuranceplan_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.insuranceplan
  })
}

pub fn invoice_create(
  resource: resources.Invoice,
  client: FhirClient,
) -> Result(resources.Invoice, Err) {
  any_create(
    resources.invoice_to_json(resource),
    "Invoice",
    resources.invoice_decoder(),
    client,
  )
}

pub fn invoice_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Invoice, Err) {
  any_read(id, client, "Invoice", resources.invoice_decoder())
}

pub fn invoice_update(
  resource: resources.Invoice,
  client: FhirClient,
) -> Result(resources.Invoice, Err) {
  any_update(
    resource.id,
    resources.invoice_to_json(resource),
    "Invoice",
    resources.invoice_decoder(),
    client,
  )
}

pub fn invoice_delete(
  resource: resources.Invoice,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Invoice", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn invoice_search_bundled(sp: sansio.SpInvoice, client: FhirClient) {
  let req = sansio.invoice_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn invoice_search(
  sp: sansio.SpInvoice,
  client: FhirClient,
) -> Result(List(resources.Invoice), Err) {
  let req = sansio.invoice_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.invoice
  })
}

pub fn library_create(
  resource: resources.Library,
  client: FhirClient,
) -> Result(resources.Library, Err) {
  any_create(
    resources.library_to_json(resource),
    "Library",
    resources.library_decoder(),
    client,
  )
}

pub fn library_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Library, Err) {
  any_read(id, client, "Library", resources.library_decoder())
}

pub fn library_update(
  resource: resources.Library,
  client: FhirClient,
) -> Result(resources.Library, Err) {
  any_update(
    resource.id,
    resources.library_to_json(resource),
    "Library",
    resources.library_decoder(),
    client,
  )
}

pub fn library_delete(
  resource: resources.Library,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Library", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn library_search_bundled(sp: sansio.SpLibrary, client: FhirClient) {
  let req = sansio.library_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn library_search(
  sp: sansio.SpLibrary,
  client: FhirClient,
) -> Result(List(resources.Library), Err) {
  let req = sansio.library_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.library
  })
}

pub fn linkage_create(
  resource: resources.Linkage,
  client: FhirClient,
) -> Result(resources.Linkage, Err) {
  any_create(
    resources.linkage_to_json(resource),
    "Linkage",
    resources.linkage_decoder(),
    client,
  )
}

pub fn linkage_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Linkage, Err) {
  any_read(id, client, "Linkage", resources.linkage_decoder())
}

pub fn linkage_update(
  resource: resources.Linkage,
  client: FhirClient,
) -> Result(resources.Linkage, Err) {
  any_update(
    resource.id,
    resources.linkage_to_json(resource),
    "Linkage",
    resources.linkage_decoder(),
    client,
  )
}

pub fn linkage_delete(
  resource: resources.Linkage,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Linkage", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn linkage_search_bundled(sp: sansio.SpLinkage, client: FhirClient) {
  let req = sansio.linkage_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn linkage_search(
  sp: sansio.SpLinkage,
  client: FhirClient,
) -> Result(List(resources.Linkage), Err) {
  let req = sansio.linkage_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.linkage
  })
}

pub fn listfhir_create(
  resource: resources.Listfhir,
  client: FhirClient,
) -> Result(resources.Listfhir, Err) {
  any_create(
    resources.listfhir_to_json(resource),
    "List",
    resources.listfhir_decoder(),
    client,
  )
}

pub fn listfhir_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Listfhir, Err) {
  any_read(id, client, "List", resources.listfhir_decoder())
}

pub fn listfhir_update(
  resource: resources.Listfhir,
  client: FhirClient,
) -> Result(resources.Listfhir, Err) {
  any_update(
    resource.id,
    resources.listfhir_to_json(resource),
    "List",
    resources.listfhir_decoder(),
    client,
  )
}

pub fn listfhir_delete(
  resource: resources.Listfhir,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Listfhir", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn listfhir_search_bundled(sp: sansio.SpListfhir, client: FhirClient) {
  let req = sansio.listfhir_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn listfhir_search(
  sp: sansio.SpListfhir,
  client: FhirClient,
) -> Result(List(resources.Listfhir), Err) {
  let req = sansio.listfhir_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.listfhir
  })
}

pub fn location_create(
  resource: resources.Location,
  client: FhirClient,
) -> Result(resources.Location, Err) {
  any_create(
    resources.location_to_json(resource),
    "Location",
    resources.location_decoder(),
    client,
  )
}

pub fn location_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Location, Err) {
  any_read(id, client, "Location", resources.location_decoder())
}

pub fn location_update(
  resource: resources.Location,
  client: FhirClient,
) -> Result(resources.Location, Err) {
  any_update(
    resource.id,
    resources.location_to_json(resource),
    "Location",
    resources.location_decoder(),
    client,
  )
}

pub fn location_delete(
  resource: resources.Location,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Location", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn location_search_bundled(sp: sansio.SpLocation, client: FhirClient) {
  let req = sansio.location_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn location_search(
  sp: sansio.SpLocation,
  client: FhirClient,
) -> Result(List(resources.Location), Err) {
  let req = sansio.location_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.location
  })
}

pub fn measure_create(
  resource: resources.Measure,
  client: FhirClient,
) -> Result(resources.Measure, Err) {
  any_create(
    resources.measure_to_json(resource),
    "Measure",
    resources.measure_decoder(),
    client,
  )
}

pub fn measure_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Measure, Err) {
  any_read(id, client, "Measure", resources.measure_decoder())
}

pub fn measure_update(
  resource: resources.Measure,
  client: FhirClient,
) -> Result(resources.Measure, Err) {
  any_update(
    resource.id,
    resources.measure_to_json(resource),
    "Measure",
    resources.measure_decoder(),
    client,
  )
}

pub fn measure_delete(
  resource: resources.Measure,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Measure", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn measure_search_bundled(sp: sansio.SpMeasure, client: FhirClient) {
  let req = sansio.measure_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn measure_search(
  sp: sansio.SpMeasure,
  client: FhirClient,
) -> Result(List(resources.Measure), Err) {
  let req = sansio.measure_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.measure
  })
}

pub fn measurereport_create(
  resource: resources.Measurereport,
  client: FhirClient,
) -> Result(resources.Measurereport, Err) {
  any_create(
    resources.measurereport_to_json(resource),
    "MeasureReport",
    resources.measurereport_decoder(),
    client,
  )
}

pub fn measurereport_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Measurereport, Err) {
  any_read(id, client, "MeasureReport", resources.measurereport_decoder())
}

pub fn measurereport_update(
  resource: resources.Measurereport,
  client: FhirClient,
) -> Result(resources.Measurereport, Err) {
  any_update(
    resource.id,
    resources.measurereport_to_json(resource),
    "MeasureReport",
    resources.measurereport_decoder(),
    client,
  )
}

pub fn measurereport_delete(
  resource: resources.Measurereport,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Measurereport", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn measurereport_search_bundled(
  sp: sansio.SpMeasurereport,
  client: FhirClient,
) {
  let req = sansio.measurereport_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn measurereport_search(
  sp: sansio.SpMeasurereport,
  client: FhirClient,
) -> Result(List(resources.Measurereport), Err) {
  let req = sansio.measurereport_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.measurereport
  })
}

pub fn media_create(
  resource: resources.Media,
  client: FhirClient,
) -> Result(resources.Media, Err) {
  any_create(
    resources.media_to_json(resource),
    "Media",
    resources.media_decoder(),
    client,
  )
}

pub fn media_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Media, Err) {
  any_read(id, client, "Media", resources.media_decoder())
}

pub fn media_update(
  resource: resources.Media,
  client: FhirClient,
) -> Result(resources.Media, Err) {
  any_update(
    resource.id,
    resources.media_to_json(resource),
    "Media",
    resources.media_decoder(),
    client,
  )
}

pub fn media_delete(
  resource: resources.Media,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Media", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn media_search_bundled(sp: sansio.SpMedia, client: FhirClient) {
  let req = sansio.media_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn media_search(
  sp: sansio.SpMedia,
  client: FhirClient,
) -> Result(List(resources.Media), Err) {
  let req = sansio.media_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.media
  })
}

pub fn medication_create(
  resource: resources.Medication,
  client: FhirClient,
) -> Result(resources.Medication, Err) {
  any_create(
    resources.medication_to_json(resource),
    "Medication",
    resources.medication_decoder(),
    client,
  )
}

pub fn medication_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Medication, Err) {
  any_read(id, client, "Medication", resources.medication_decoder())
}

pub fn medication_update(
  resource: resources.Medication,
  client: FhirClient,
) -> Result(resources.Medication, Err) {
  any_update(
    resource.id,
    resources.medication_to_json(resource),
    "Medication",
    resources.medication_decoder(),
    client,
  )
}

pub fn medication_delete(
  resource: resources.Medication,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medication", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medication_search_bundled(sp: sansio.SpMedication, client: FhirClient) {
  let req = sansio.medication_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn medication_search(
  sp: sansio.SpMedication,
  client: FhirClient,
) -> Result(List(resources.Medication), Err) {
  let req = sansio.medication_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.medication
  })
}

pub fn medicationadministration_create(
  resource: resources.Medicationadministration,
  client: FhirClient,
) -> Result(resources.Medicationadministration, Err) {
  any_create(
    resources.medicationadministration_to_json(resource),
    "MedicationAdministration",
    resources.medicationadministration_decoder(),
    client,
  )
}

pub fn medicationadministration_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Medicationadministration, Err) {
  any_read(
    id,
    client,
    "MedicationAdministration",
    resources.medicationadministration_decoder(),
  )
}

pub fn medicationadministration_update(
  resource: resources.Medicationadministration,
  client: FhirClient,
) -> Result(resources.Medicationadministration, Err) {
  any_update(
    resource.id,
    resources.medicationadministration_to_json(resource),
    "MedicationAdministration",
    resources.medicationadministration_decoder(),
    client,
  )
}

pub fn medicationadministration_delete(
  resource: resources.Medicationadministration,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicationadministration", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicationadministration_search_bundled(
  sp: sansio.SpMedicationadministration,
  client: FhirClient,
) {
  let req = sansio.medicationadministration_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn medicationadministration_search(
  sp: sansio.SpMedicationadministration,
  client: FhirClient,
) -> Result(List(resources.Medicationadministration), Err) {
  let req = sansio.medicationadministration_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.medicationadministration
  })
}

pub fn medicationdispense_create(
  resource: resources.Medicationdispense,
  client: FhirClient,
) -> Result(resources.Medicationdispense, Err) {
  any_create(
    resources.medicationdispense_to_json(resource),
    "MedicationDispense",
    resources.medicationdispense_decoder(),
    client,
  )
}

pub fn medicationdispense_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Medicationdispense, Err) {
  any_read(
    id,
    client,
    "MedicationDispense",
    resources.medicationdispense_decoder(),
  )
}

pub fn medicationdispense_update(
  resource: resources.Medicationdispense,
  client: FhirClient,
) -> Result(resources.Medicationdispense, Err) {
  any_update(
    resource.id,
    resources.medicationdispense_to_json(resource),
    "MedicationDispense",
    resources.medicationdispense_decoder(),
    client,
  )
}

pub fn medicationdispense_delete(
  resource: resources.Medicationdispense,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicationdispense", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicationdispense_search_bundled(
  sp: sansio.SpMedicationdispense,
  client: FhirClient,
) {
  let req = sansio.medicationdispense_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn medicationdispense_search(
  sp: sansio.SpMedicationdispense,
  client: FhirClient,
) -> Result(List(resources.Medicationdispense), Err) {
  let req = sansio.medicationdispense_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.medicationdispense
  })
}

pub fn medicationknowledge_create(
  resource: resources.Medicationknowledge,
  client: FhirClient,
) -> Result(resources.Medicationknowledge, Err) {
  any_create(
    resources.medicationknowledge_to_json(resource),
    "MedicationKnowledge",
    resources.medicationknowledge_decoder(),
    client,
  )
}

pub fn medicationknowledge_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Medicationknowledge, Err) {
  any_read(
    id,
    client,
    "MedicationKnowledge",
    resources.medicationknowledge_decoder(),
  )
}

pub fn medicationknowledge_update(
  resource: resources.Medicationknowledge,
  client: FhirClient,
) -> Result(resources.Medicationknowledge, Err) {
  any_update(
    resource.id,
    resources.medicationknowledge_to_json(resource),
    "MedicationKnowledge",
    resources.medicationknowledge_decoder(),
    client,
  )
}

pub fn medicationknowledge_delete(
  resource: resources.Medicationknowledge,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicationknowledge", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicationknowledge_search_bundled(
  sp: sansio.SpMedicationknowledge,
  client: FhirClient,
) {
  let req = sansio.medicationknowledge_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn medicationknowledge_search(
  sp: sansio.SpMedicationknowledge,
  client: FhirClient,
) -> Result(List(resources.Medicationknowledge), Err) {
  let req = sansio.medicationknowledge_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.medicationknowledge
  })
}

pub fn medicationrequest_create(
  resource: resources.Medicationrequest,
  client: FhirClient,
) -> Result(resources.Medicationrequest, Err) {
  any_create(
    resources.medicationrequest_to_json(resource),
    "MedicationRequest",
    resources.medicationrequest_decoder(),
    client,
  )
}

pub fn medicationrequest_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Medicationrequest, Err) {
  any_read(
    id,
    client,
    "MedicationRequest",
    resources.medicationrequest_decoder(),
  )
}

pub fn medicationrequest_update(
  resource: resources.Medicationrequest,
  client: FhirClient,
) -> Result(resources.Medicationrequest, Err) {
  any_update(
    resource.id,
    resources.medicationrequest_to_json(resource),
    "MedicationRequest",
    resources.medicationrequest_decoder(),
    client,
  )
}

pub fn medicationrequest_delete(
  resource: resources.Medicationrequest,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicationrequest", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicationrequest_search_bundled(
  sp: sansio.SpMedicationrequest,
  client: FhirClient,
) {
  let req = sansio.medicationrequest_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn medicationrequest_search(
  sp: sansio.SpMedicationrequest,
  client: FhirClient,
) -> Result(List(resources.Medicationrequest), Err) {
  let req = sansio.medicationrequest_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.medicationrequest
  })
}

pub fn medicationstatement_create(
  resource: resources.Medicationstatement,
  client: FhirClient,
) -> Result(resources.Medicationstatement, Err) {
  any_create(
    resources.medicationstatement_to_json(resource),
    "MedicationStatement",
    resources.medicationstatement_decoder(),
    client,
  )
}

pub fn medicationstatement_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Medicationstatement, Err) {
  any_read(
    id,
    client,
    "MedicationStatement",
    resources.medicationstatement_decoder(),
  )
}

pub fn medicationstatement_update(
  resource: resources.Medicationstatement,
  client: FhirClient,
) -> Result(resources.Medicationstatement, Err) {
  any_update(
    resource.id,
    resources.medicationstatement_to_json(resource),
    "MedicationStatement",
    resources.medicationstatement_decoder(),
    client,
  )
}

pub fn medicationstatement_delete(
  resource: resources.Medicationstatement,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicationstatement", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicationstatement_search_bundled(
  sp: sansio.SpMedicationstatement,
  client: FhirClient,
) {
  let req = sansio.medicationstatement_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn medicationstatement_search(
  sp: sansio.SpMedicationstatement,
  client: FhirClient,
) -> Result(List(resources.Medicationstatement), Err) {
  let req = sansio.medicationstatement_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.medicationstatement
  })
}

pub fn medicinalproduct_create(
  resource: resources.Medicinalproduct,
  client: FhirClient,
) -> Result(resources.Medicinalproduct, Err) {
  any_create(
    resources.medicinalproduct_to_json(resource),
    "MedicinalProduct",
    resources.medicinalproduct_decoder(),
    client,
  )
}

pub fn medicinalproduct_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Medicinalproduct, Err) {
  any_read(id, client, "MedicinalProduct", resources.medicinalproduct_decoder())
}

pub fn medicinalproduct_update(
  resource: resources.Medicinalproduct,
  client: FhirClient,
) -> Result(resources.Medicinalproduct, Err) {
  any_update(
    resource.id,
    resources.medicinalproduct_to_json(resource),
    "MedicinalProduct",
    resources.medicinalproduct_decoder(),
    client,
  )
}

pub fn medicinalproduct_delete(
  resource: resources.Medicinalproduct,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicinalproduct", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicinalproduct_search_bundled(
  sp: sansio.SpMedicinalproduct,
  client: FhirClient,
) {
  let req = sansio.medicinalproduct_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn medicinalproduct_search(
  sp: sansio.SpMedicinalproduct,
  client: FhirClient,
) -> Result(List(resources.Medicinalproduct), Err) {
  let req = sansio.medicinalproduct_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.medicinalproduct
  })
}

pub fn medicinalproductauthorization_create(
  resource: resources.Medicinalproductauthorization,
  client: FhirClient,
) -> Result(resources.Medicinalproductauthorization, Err) {
  any_create(
    resources.medicinalproductauthorization_to_json(resource),
    "MedicinalProductAuthorization",
    resources.medicinalproductauthorization_decoder(),
    client,
  )
}

pub fn medicinalproductauthorization_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Medicinalproductauthorization, Err) {
  any_read(
    id,
    client,
    "MedicinalProductAuthorization",
    resources.medicinalproductauthorization_decoder(),
  )
}

pub fn medicinalproductauthorization_update(
  resource: resources.Medicinalproductauthorization,
  client: FhirClient,
) -> Result(resources.Medicinalproductauthorization, Err) {
  any_update(
    resource.id,
    resources.medicinalproductauthorization_to_json(resource),
    "MedicinalProductAuthorization",
    resources.medicinalproductauthorization_decoder(),
    client,
  )
}

pub fn medicinalproductauthorization_delete(
  resource: resources.Medicinalproductauthorization,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicinalproductauthorization", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicinalproductauthorization_search_bundled(
  sp: sansio.SpMedicinalproductauthorization,
  client: FhirClient,
) {
  let req = sansio.medicinalproductauthorization_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn medicinalproductauthorization_search(
  sp: sansio.SpMedicinalproductauthorization,
  client: FhirClient,
) -> Result(List(resources.Medicinalproductauthorization), Err) {
  let req = sansio.medicinalproductauthorization_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.medicinalproductauthorization
  })
}

pub fn medicinalproductcontraindication_create(
  resource: resources.Medicinalproductcontraindication,
  client: FhirClient,
) -> Result(resources.Medicinalproductcontraindication, Err) {
  any_create(
    resources.medicinalproductcontraindication_to_json(resource),
    "MedicinalProductContraindication",
    resources.medicinalproductcontraindication_decoder(),
    client,
  )
}

pub fn medicinalproductcontraindication_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Medicinalproductcontraindication, Err) {
  any_read(
    id,
    client,
    "MedicinalProductContraindication",
    resources.medicinalproductcontraindication_decoder(),
  )
}

pub fn medicinalproductcontraindication_update(
  resource: resources.Medicinalproductcontraindication,
  client: FhirClient,
) -> Result(resources.Medicinalproductcontraindication, Err) {
  any_update(
    resource.id,
    resources.medicinalproductcontraindication_to_json(resource),
    "MedicinalProductContraindication",
    resources.medicinalproductcontraindication_decoder(),
    client,
  )
}

pub fn medicinalproductcontraindication_delete(
  resource: resources.Medicinalproductcontraindication,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicinalproductcontraindication", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicinalproductcontraindication_search_bundled(
  sp: sansio.SpMedicinalproductcontraindication,
  client: FhirClient,
) {
  let req = sansio.medicinalproductcontraindication_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn medicinalproductcontraindication_search(
  sp: sansio.SpMedicinalproductcontraindication,
  client: FhirClient,
) -> Result(List(resources.Medicinalproductcontraindication), Err) {
  let req = sansio.medicinalproductcontraindication_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.medicinalproductcontraindication
  })
}

pub fn medicinalproductindication_create(
  resource: resources.Medicinalproductindication,
  client: FhirClient,
) -> Result(resources.Medicinalproductindication, Err) {
  any_create(
    resources.medicinalproductindication_to_json(resource),
    "MedicinalProductIndication",
    resources.medicinalproductindication_decoder(),
    client,
  )
}

pub fn medicinalproductindication_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Medicinalproductindication, Err) {
  any_read(
    id,
    client,
    "MedicinalProductIndication",
    resources.medicinalproductindication_decoder(),
  )
}

pub fn medicinalproductindication_update(
  resource: resources.Medicinalproductindication,
  client: FhirClient,
) -> Result(resources.Medicinalproductindication, Err) {
  any_update(
    resource.id,
    resources.medicinalproductindication_to_json(resource),
    "MedicinalProductIndication",
    resources.medicinalproductindication_decoder(),
    client,
  )
}

pub fn medicinalproductindication_delete(
  resource: resources.Medicinalproductindication,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicinalproductindication", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicinalproductindication_search_bundled(
  sp: sansio.SpMedicinalproductindication,
  client: FhirClient,
) {
  let req = sansio.medicinalproductindication_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn medicinalproductindication_search(
  sp: sansio.SpMedicinalproductindication,
  client: FhirClient,
) -> Result(List(resources.Medicinalproductindication), Err) {
  let req = sansio.medicinalproductindication_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.medicinalproductindication
  })
}

pub fn medicinalproductingredient_create(
  resource: resources.Medicinalproductingredient,
  client: FhirClient,
) -> Result(resources.Medicinalproductingredient, Err) {
  any_create(
    resources.medicinalproductingredient_to_json(resource),
    "MedicinalProductIngredient",
    resources.medicinalproductingredient_decoder(),
    client,
  )
}

pub fn medicinalproductingredient_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Medicinalproductingredient, Err) {
  any_read(
    id,
    client,
    "MedicinalProductIngredient",
    resources.medicinalproductingredient_decoder(),
  )
}

pub fn medicinalproductingredient_update(
  resource: resources.Medicinalproductingredient,
  client: FhirClient,
) -> Result(resources.Medicinalproductingredient, Err) {
  any_update(
    resource.id,
    resources.medicinalproductingredient_to_json(resource),
    "MedicinalProductIngredient",
    resources.medicinalproductingredient_decoder(),
    client,
  )
}

pub fn medicinalproductingredient_delete(
  resource: resources.Medicinalproductingredient,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicinalproductingredient", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicinalproductingredient_search_bundled(
  sp: sansio.SpMedicinalproductingredient,
  client: FhirClient,
) {
  let req = sansio.medicinalproductingredient_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn medicinalproductingredient_search(
  sp: sansio.SpMedicinalproductingredient,
  client: FhirClient,
) -> Result(List(resources.Medicinalproductingredient), Err) {
  let req = sansio.medicinalproductingredient_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.medicinalproductingredient
  })
}

pub fn medicinalproductinteraction_create(
  resource: resources.Medicinalproductinteraction,
  client: FhirClient,
) -> Result(resources.Medicinalproductinteraction, Err) {
  any_create(
    resources.medicinalproductinteraction_to_json(resource),
    "MedicinalProductInteraction",
    resources.medicinalproductinteraction_decoder(),
    client,
  )
}

pub fn medicinalproductinteraction_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Medicinalproductinteraction, Err) {
  any_read(
    id,
    client,
    "MedicinalProductInteraction",
    resources.medicinalproductinteraction_decoder(),
  )
}

pub fn medicinalproductinteraction_update(
  resource: resources.Medicinalproductinteraction,
  client: FhirClient,
) -> Result(resources.Medicinalproductinteraction, Err) {
  any_update(
    resource.id,
    resources.medicinalproductinteraction_to_json(resource),
    "MedicinalProductInteraction",
    resources.medicinalproductinteraction_decoder(),
    client,
  )
}

pub fn medicinalproductinteraction_delete(
  resource: resources.Medicinalproductinteraction,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicinalproductinteraction", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicinalproductinteraction_search_bundled(
  sp: sansio.SpMedicinalproductinteraction,
  client: FhirClient,
) {
  let req = sansio.medicinalproductinteraction_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn medicinalproductinteraction_search(
  sp: sansio.SpMedicinalproductinteraction,
  client: FhirClient,
) -> Result(List(resources.Medicinalproductinteraction), Err) {
  let req = sansio.medicinalproductinteraction_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.medicinalproductinteraction
  })
}

pub fn medicinalproductmanufactured_create(
  resource: resources.Medicinalproductmanufactured,
  client: FhirClient,
) -> Result(resources.Medicinalproductmanufactured, Err) {
  any_create(
    resources.medicinalproductmanufactured_to_json(resource),
    "MedicinalProductManufactured",
    resources.medicinalproductmanufactured_decoder(),
    client,
  )
}

pub fn medicinalproductmanufactured_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Medicinalproductmanufactured, Err) {
  any_read(
    id,
    client,
    "MedicinalProductManufactured",
    resources.medicinalproductmanufactured_decoder(),
  )
}

pub fn medicinalproductmanufactured_update(
  resource: resources.Medicinalproductmanufactured,
  client: FhirClient,
) -> Result(resources.Medicinalproductmanufactured, Err) {
  any_update(
    resource.id,
    resources.medicinalproductmanufactured_to_json(resource),
    "MedicinalProductManufactured",
    resources.medicinalproductmanufactured_decoder(),
    client,
  )
}

pub fn medicinalproductmanufactured_delete(
  resource: resources.Medicinalproductmanufactured,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicinalproductmanufactured", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicinalproductmanufactured_search_bundled(
  sp: sansio.SpMedicinalproductmanufactured,
  client: FhirClient,
) {
  let req = sansio.medicinalproductmanufactured_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn medicinalproductmanufactured_search(
  sp: sansio.SpMedicinalproductmanufactured,
  client: FhirClient,
) -> Result(List(resources.Medicinalproductmanufactured), Err) {
  let req = sansio.medicinalproductmanufactured_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.medicinalproductmanufactured
  })
}

pub fn medicinalproductpackaged_create(
  resource: resources.Medicinalproductpackaged,
  client: FhirClient,
) -> Result(resources.Medicinalproductpackaged, Err) {
  any_create(
    resources.medicinalproductpackaged_to_json(resource),
    "MedicinalProductPackaged",
    resources.medicinalproductpackaged_decoder(),
    client,
  )
}

pub fn medicinalproductpackaged_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Medicinalproductpackaged, Err) {
  any_read(
    id,
    client,
    "MedicinalProductPackaged",
    resources.medicinalproductpackaged_decoder(),
  )
}

pub fn medicinalproductpackaged_update(
  resource: resources.Medicinalproductpackaged,
  client: FhirClient,
) -> Result(resources.Medicinalproductpackaged, Err) {
  any_update(
    resource.id,
    resources.medicinalproductpackaged_to_json(resource),
    "MedicinalProductPackaged",
    resources.medicinalproductpackaged_decoder(),
    client,
  )
}

pub fn medicinalproductpackaged_delete(
  resource: resources.Medicinalproductpackaged,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicinalproductpackaged", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicinalproductpackaged_search_bundled(
  sp: sansio.SpMedicinalproductpackaged,
  client: FhirClient,
) {
  let req = sansio.medicinalproductpackaged_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn medicinalproductpackaged_search(
  sp: sansio.SpMedicinalproductpackaged,
  client: FhirClient,
) -> Result(List(resources.Medicinalproductpackaged), Err) {
  let req = sansio.medicinalproductpackaged_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.medicinalproductpackaged
  })
}

pub fn medicinalproductpharmaceutical_create(
  resource: resources.Medicinalproductpharmaceutical,
  client: FhirClient,
) -> Result(resources.Medicinalproductpharmaceutical, Err) {
  any_create(
    resources.medicinalproductpharmaceutical_to_json(resource),
    "MedicinalProductPharmaceutical",
    resources.medicinalproductpharmaceutical_decoder(),
    client,
  )
}

pub fn medicinalproductpharmaceutical_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Medicinalproductpharmaceutical, Err) {
  any_read(
    id,
    client,
    "MedicinalProductPharmaceutical",
    resources.medicinalproductpharmaceutical_decoder(),
  )
}

pub fn medicinalproductpharmaceutical_update(
  resource: resources.Medicinalproductpharmaceutical,
  client: FhirClient,
) -> Result(resources.Medicinalproductpharmaceutical, Err) {
  any_update(
    resource.id,
    resources.medicinalproductpharmaceutical_to_json(resource),
    "MedicinalProductPharmaceutical",
    resources.medicinalproductpharmaceutical_decoder(),
    client,
  )
}

pub fn medicinalproductpharmaceutical_delete(
  resource: resources.Medicinalproductpharmaceutical,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicinalproductpharmaceutical", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicinalproductpharmaceutical_search_bundled(
  sp: sansio.SpMedicinalproductpharmaceutical,
  client: FhirClient,
) {
  let req = sansio.medicinalproductpharmaceutical_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn medicinalproductpharmaceutical_search(
  sp: sansio.SpMedicinalproductpharmaceutical,
  client: FhirClient,
) -> Result(List(resources.Medicinalproductpharmaceutical), Err) {
  let req = sansio.medicinalproductpharmaceutical_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.medicinalproductpharmaceutical
  })
}

pub fn medicinalproductundesirableeffect_create(
  resource: resources.Medicinalproductundesirableeffect,
  client: FhirClient,
) -> Result(resources.Medicinalproductundesirableeffect, Err) {
  any_create(
    resources.medicinalproductundesirableeffect_to_json(resource),
    "MedicinalProductUndesirableEffect",
    resources.medicinalproductundesirableeffect_decoder(),
    client,
  )
}

pub fn medicinalproductundesirableeffect_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Medicinalproductundesirableeffect, Err) {
  any_read(
    id,
    client,
    "MedicinalProductUndesirableEffect",
    resources.medicinalproductundesirableeffect_decoder(),
  )
}

pub fn medicinalproductundesirableeffect_update(
  resource: resources.Medicinalproductundesirableeffect,
  client: FhirClient,
) -> Result(resources.Medicinalproductundesirableeffect, Err) {
  any_update(
    resource.id,
    resources.medicinalproductundesirableeffect_to_json(resource),
    "MedicinalProductUndesirableEffect",
    resources.medicinalproductundesirableeffect_decoder(),
    client,
  )
}

pub fn medicinalproductundesirableeffect_delete(
  resource: resources.Medicinalproductundesirableeffect,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Medicinalproductundesirableeffect", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn medicinalproductundesirableeffect_search_bundled(
  sp: sansio.SpMedicinalproductundesirableeffect,
  client: FhirClient,
) {
  let req = sansio.medicinalproductundesirableeffect_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn medicinalproductundesirableeffect_search(
  sp: sansio.SpMedicinalproductundesirableeffect,
  client: FhirClient,
) -> Result(List(resources.Medicinalproductundesirableeffect), Err) {
  let req = sansio.medicinalproductundesirableeffect_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.medicinalproductundesirableeffect
  })
}

pub fn messagedefinition_create(
  resource: resources.Messagedefinition,
  client: FhirClient,
) -> Result(resources.Messagedefinition, Err) {
  any_create(
    resources.messagedefinition_to_json(resource),
    "MessageDefinition",
    resources.messagedefinition_decoder(),
    client,
  )
}

pub fn messagedefinition_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Messagedefinition, Err) {
  any_read(
    id,
    client,
    "MessageDefinition",
    resources.messagedefinition_decoder(),
  )
}

pub fn messagedefinition_update(
  resource: resources.Messagedefinition,
  client: FhirClient,
) -> Result(resources.Messagedefinition, Err) {
  any_update(
    resource.id,
    resources.messagedefinition_to_json(resource),
    "MessageDefinition",
    resources.messagedefinition_decoder(),
    client,
  )
}

pub fn messagedefinition_delete(
  resource: resources.Messagedefinition,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Messagedefinition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn messagedefinition_search_bundled(
  sp: sansio.SpMessagedefinition,
  client: FhirClient,
) {
  let req = sansio.messagedefinition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn messagedefinition_search(
  sp: sansio.SpMessagedefinition,
  client: FhirClient,
) -> Result(List(resources.Messagedefinition), Err) {
  let req = sansio.messagedefinition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.messagedefinition
  })
}

pub fn messageheader_create(
  resource: resources.Messageheader,
  client: FhirClient,
) -> Result(resources.Messageheader, Err) {
  any_create(
    resources.messageheader_to_json(resource),
    "MessageHeader",
    resources.messageheader_decoder(),
    client,
  )
}

pub fn messageheader_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Messageheader, Err) {
  any_read(id, client, "MessageHeader", resources.messageheader_decoder())
}

pub fn messageheader_update(
  resource: resources.Messageheader,
  client: FhirClient,
) -> Result(resources.Messageheader, Err) {
  any_update(
    resource.id,
    resources.messageheader_to_json(resource),
    "MessageHeader",
    resources.messageheader_decoder(),
    client,
  )
}

pub fn messageheader_delete(
  resource: resources.Messageheader,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Messageheader", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn messageheader_search_bundled(
  sp: sansio.SpMessageheader,
  client: FhirClient,
) {
  let req = sansio.messageheader_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn messageheader_search(
  sp: sansio.SpMessageheader,
  client: FhirClient,
) -> Result(List(resources.Messageheader), Err) {
  let req = sansio.messageheader_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.messageheader
  })
}

pub fn molecularsequence_create(
  resource: resources.Molecularsequence,
  client: FhirClient,
) -> Result(resources.Molecularsequence, Err) {
  any_create(
    resources.molecularsequence_to_json(resource),
    "MolecularSequence",
    resources.molecularsequence_decoder(),
    client,
  )
}

pub fn molecularsequence_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Molecularsequence, Err) {
  any_read(
    id,
    client,
    "MolecularSequence",
    resources.molecularsequence_decoder(),
  )
}

pub fn molecularsequence_update(
  resource: resources.Molecularsequence,
  client: FhirClient,
) -> Result(resources.Molecularsequence, Err) {
  any_update(
    resource.id,
    resources.molecularsequence_to_json(resource),
    "MolecularSequence",
    resources.molecularsequence_decoder(),
    client,
  )
}

pub fn molecularsequence_delete(
  resource: resources.Molecularsequence,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Molecularsequence", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn molecularsequence_search_bundled(
  sp: sansio.SpMolecularsequence,
  client: FhirClient,
) {
  let req = sansio.molecularsequence_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn molecularsequence_search(
  sp: sansio.SpMolecularsequence,
  client: FhirClient,
) -> Result(List(resources.Molecularsequence), Err) {
  let req = sansio.molecularsequence_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.molecularsequence
  })
}

pub fn namingsystem_create(
  resource: resources.Namingsystem,
  client: FhirClient,
) -> Result(resources.Namingsystem, Err) {
  any_create(
    resources.namingsystem_to_json(resource),
    "NamingSystem",
    resources.namingsystem_decoder(),
    client,
  )
}

pub fn namingsystem_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Namingsystem, Err) {
  any_read(id, client, "NamingSystem", resources.namingsystem_decoder())
}

pub fn namingsystem_update(
  resource: resources.Namingsystem,
  client: FhirClient,
) -> Result(resources.Namingsystem, Err) {
  any_update(
    resource.id,
    resources.namingsystem_to_json(resource),
    "NamingSystem",
    resources.namingsystem_decoder(),
    client,
  )
}

pub fn namingsystem_delete(
  resource: resources.Namingsystem,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Namingsystem", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn namingsystem_search_bundled(
  sp: sansio.SpNamingsystem,
  client: FhirClient,
) {
  let req = sansio.namingsystem_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn namingsystem_search(
  sp: sansio.SpNamingsystem,
  client: FhirClient,
) -> Result(List(resources.Namingsystem), Err) {
  let req = sansio.namingsystem_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.namingsystem
  })
}

pub fn nutritionorder_create(
  resource: resources.Nutritionorder,
  client: FhirClient,
) -> Result(resources.Nutritionorder, Err) {
  any_create(
    resources.nutritionorder_to_json(resource),
    "NutritionOrder",
    resources.nutritionorder_decoder(),
    client,
  )
}

pub fn nutritionorder_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Nutritionorder, Err) {
  any_read(id, client, "NutritionOrder", resources.nutritionorder_decoder())
}

pub fn nutritionorder_update(
  resource: resources.Nutritionorder,
  client: FhirClient,
) -> Result(resources.Nutritionorder, Err) {
  any_update(
    resource.id,
    resources.nutritionorder_to_json(resource),
    "NutritionOrder",
    resources.nutritionorder_decoder(),
    client,
  )
}

pub fn nutritionorder_delete(
  resource: resources.Nutritionorder,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Nutritionorder", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn nutritionorder_search_bundled(
  sp: sansio.SpNutritionorder,
  client: FhirClient,
) {
  let req = sansio.nutritionorder_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn nutritionorder_search(
  sp: sansio.SpNutritionorder,
  client: FhirClient,
) -> Result(List(resources.Nutritionorder), Err) {
  let req = sansio.nutritionorder_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.nutritionorder
  })
}

pub fn observation_create(
  resource: resources.Observation,
  client: FhirClient,
) -> Result(resources.Observation, Err) {
  any_create(
    resources.observation_to_json(resource),
    "Observation",
    resources.observation_decoder(),
    client,
  )
}

pub fn observation_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Observation, Err) {
  any_read(id, client, "Observation", resources.observation_decoder())
}

pub fn observation_update(
  resource: resources.Observation,
  client: FhirClient,
) -> Result(resources.Observation, Err) {
  any_update(
    resource.id,
    resources.observation_to_json(resource),
    "Observation",
    resources.observation_decoder(),
    client,
  )
}

pub fn observation_delete(
  resource: resources.Observation,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Observation", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn observation_search_bundled(sp: sansio.SpObservation, client: FhirClient) {
  let req = sansio.observation_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn observation_search(
  sp: sansio.SpObservation,
  client: FhirClient,
) -> Result(List(resources.Observation), Err) {
  let req = sansio.observation_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.observation
  })
}

pub fn observationdefinition_create(
  resource: resources.Observationdefinition,
  client: FhirClient,
) -> Result(resources.Observationdefinition, Err) {
  any_create(
    resources.observationdefinition_to_json(resource),
    "ObservationDefinition",
    resources.observationdefinition_decoder(),
    client,
  )
}

pub fn observationdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Observationdefinition, Err) {
  any_read(
    id,
    client,
    "ObservationDefinition",
    resources.observationdefinition_decoder(),
  )
}

pub fn observationdefinition_update(
  resource: resources.Observationdefinition,
  client: FhirClient,
) -> Result(resources.Observationdefinition, Err) {
  any_update(
    resource.id,
    resources.observationdefinition_to_json(resource),
    "ObservationDefinition",
    resources.observationdefinition_decoder(),
    client,
  )
}

pub fn observationdefinition_delete(
  resource: resources.Observationdefinition,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Observationdefinition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn observationdefinition_search_bundled(
  sp: sansio.SpObservationdefinition,
  client: FhirClient,
) {
  let req = sansio.observationdefinition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn observationdefinition_search(
  sp: sansio.SpObservationdefinition,
  client: FhirClient,
) -> Result(List(resources.Observationdefinition), Err) {
  let req = sansio.observationdefinition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.observationdefinition
  })
}

pub fn operationdefinition_create(
  resource: resources.Operationdefinition,
  client: FhirClient,
) -> Result(resources.Operationdefinition, Err) {
  any_create(
    resources.operationdefinition_to_json(resource),
    "OperationDefinition",
    resources.operationdefinition_decoder(),
    client,
  )
}

pub fn operationdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Operationdefinition, Err) {
  any_read(
    id,
    client,
    "OperationDefinition",
    resources.operationdefinition_decoder(),
  )
}

pub fn operationdefinition_update(
  resource: resources.Operationdefinition,
  client: FhirClient,
) -> Result(resources.Operationdefinition, Err) {
  any_update(
    resource.id,
    resources.operationdefinition_to_json(resource),
    "OperationDefinition",
    resources.operationdefinition_decoder(),
    client,
  )
}

pub fn operationdefinition_delete(
  resource: resources.Operationdefinition,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Operationdefinition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn operationdefinition_search_bundled(
  sp: sansio.SpOperationdefinition,
  client: FhirClient,
) {
  let req = sansio.operationdefinition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn operationdefinition_search(
  sp: sansio.SpOperationdefinition,
  client: FhirClient,
) -> Result(List(resources.Operationdefinition), Err) {
  let req = sansio.operationdefinition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.operationdefinition
  })
}

pub fn operationoutcome_create(
  resource: resources.Operationoutcome,
  client: FhirClient,
) -> Result(resources.Operationoutcome, Err) {
  any_create(
    resources.operationoutcome_to_json(resource),
    "OperationOutcome",
    resources.operationoutcome_decoder(),
    client,
  )
}

pub fn operationoutcome_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Operationoutcome, Err) {
  any_read(id, client, "OperationOutcome", resources.operationoutcome_decoder())
}

pub fn operationoutcome_update(
  resource: resources.Operationoutcome,
  client: FhirClient,
) -> Result(resources.Operationoutcome, Err) {
  any_update(
    resource.id,
    resources.operationoutcome_to_json(resource),
    "OperationOutcome",
    resources.operationoutcome_decoder(),
    client,
  )
}

pub fn operationoutcome_delete(
  resource: resources.Operationoutcome,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Operationoutcome", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn operationoutcome_search_bundled(
  sp: sansio.SpOperationoutcome,
  client: FhirClient,
) {
  let req = sansio.operationoutcome_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn operationoutcome_search(
  sp: sansio.SpOperationoutcome,
  client: FhirClient,
) -> Result(List(resources.Operationoutcome), Err) {
  let req = sansio.operationoutcome_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.operationoutcome
  })
}

pub fn organization_create(
  resource: resources.Organization,
  client: FhirClient,
) -> Result(resources.Organization, Err) {
  any_create(
    resources.organization_to_json(resource),
    "Organization",
    resources.organization_decoder(),
    client,
  )
}

pub fn organization_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Organization, Err) {
  any_read(id, client, "Organization", resources.organization_decoder())
}

pub fn organization_update(
  resource: resources.Organization,
  client: FhirClient,
) -> Result(resources.Organization, Err) {
  any_update(
    resource.id,
    resources.organization_to_json(resource),
    "Organization",
    resources.organization_decoder(),
    client,
  )
}

pub fn organization_delete(
  resource: resources.Organization,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Organization", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn organization_search_bundled(
  sp: sansio.SpOrganization,
  client: FhirClient,
) {
  let req = sansio.organization_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn organization_search(
  sp: sansio.SpOrganization,
  client: FhirClient,
) -> Result(List(resources.Organization), Err) {
  let req = sansio.organization_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.organization
  })
}

pub fn organizationaffiliation_create(
  resource: resources.Organizationaffiliation,
  client: FhirClient,
) -> Result(resources.Organizationaffiliation, Err) {
  any_create(
    resources.organizationaffiliation_to_json(resource),
    "OrganizationAffiliation",
    resources.organizationaffiliation_decoder(),
    client,
  )
}

pub fn organizationaffiliation_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Organizationaffiliation, Err) {
  any_read(
    id,
    client,
    "OrganizationAffiliation",
    resources.organizationaffiliation_decoder(),
  )
}

pub fn organizationaffiliation_update(
  resource: resources.Organizationaffiliation,
  client: FhirClient,
) -> Result(resources.Organizationaffiliation, Err) {
  any_update(
    resource.id,
    resources.organizationaffiliation_to_json(resource),
    "OrganizationAffiliation",
    resources.organizationaffiliation_decoder(),
    client,
  )
}

pub fn organizationaffiliation_delete(
  resource: resources.Organizationaffiliation,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Organizationaffiliation", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn organizationaffiliation_search_bundled(
  sp: sansio.SpOrganizationaffiliation,
  client: FhirClient,
) {
  let req = sansio.organizationaffiliation_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn organizationaffiliation_search(
  sp: sansio.SpOrganizationaffiliation,
  client: FhirClient,
) -> Result(List(resources.Organizationaffiliation), Err) {
  let req = sansio.organizationaffiliation_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.organizationaffiliation
  })
}

pub fn patient_create(
  resource: resources.Patient,
  client: FhirClient,
) -> Result(resources.Patient, Err) {
  any_create(
    resources.patient_to_json(resource),
    "Patient",
    resources.patient_decoder(),
    client,
  )
}

pub fn patient_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Patient, Err) {
  any_read(id, client, "Patient", resources.patient_decoder())
}

pub fn patient_update(
  resource: resources.Patient,
  client: FhirClient,
) -> Result(resources.Patient, Err) {
  any_update(
    resource.id,
    resources.patient_to_json(resource),
    "Patient",
    resources.patient_decoder(),
    client,
  )
}

pub fn patient_delete(
  resource: resources.Patient,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Patient", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn patient_search_bundled(sp: sansio.SpPatient, client: FhirClient) {
  let req = sansio.patient_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn patient_search(
  sp: sansio.SpPatient,
  client: FhirClient,
) -> Result(List(resources.Patient), Err) {
  let req = sansio.patient_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.patient
  })
}

pub fn paymentnotice_create(
  resource: resources.Paymentnotice,
  client: FhirClient,
) -> Result(resources.Paymentnotice, Err) {
  any_create(
    resources.paymentnotice_to_json(resource),
    "PaymentNotice",
    resources.paymentnotice_decoder(),
    client,
  )
}

pub fn paymentnotice_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Paymentnotice, Err) {
  any_read(id, client, "PaymentNotice", resources.paymentnotice_decoder())
}

pub fn paymentnotice_update(
  resource: resources.Paymentnotice,
  client: FhirClient,
) -> Result(resources.Paymentnotice, Err) {
  any_update(
    resource.id,
    resources.paymentnotice_to_json(resource),
    "PaymentNotice",
    resources.paymentnotice_decoder(),
    client,
  )
}

pub fn paymentnotice_delete(
  resource: resources.Paymentnotice,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Paymentnotice", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn paymentnotice_search_bundled(
  sp: sansio.SpPaymentnotice,
  client: FhirClient,
) {
  let req = sansio.paymentnotice_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn paymentnotice_search(
  sp: sansio.SpPaymentnotice,
  client: FhirClient,
) -> Result(List(resources.Paymentnotice), Err) {
  let req = sansio.paymentnotice_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.paymentnotice
  })
}

pub fn paymentreconciliation_create(
  resource: resources.Paymentreconciliation,
  client: FhirClient,
) -> Result(resources.Paymentreconciliation, Err) {
  any_create(
    resources.paymentreconciliation_to_json(resource),
    "PaymentReconciliation",
    resources.paymentreconciliation_decoder(),
    client,
  )
}

pub fn paymentreconciliation_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Paymentreconciliation, Err) {
  any_read(
    id,
    client,
    "PaymentReconciliation",
    resources.paymentreconciliation_decoder(),
  )
}

pub fn paymentreconciliation_update(
  resource: resources.Paymentreconciliation,
  client: FhirClient,
) -> Result(resources.Paymentreconciliation, Err) {
  any_update(
    resource.id,
    resources.paymentreconciliation_to_json(resource),
    "PaymentReconciliation",
    resources.paymentreconciliation_decoder(),
    client,
  )
}

pub fn paymentreconciliation_delete(
  resource: resources.Paymentreconciliation,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Paymentreconciliation", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn paymentreconciliation_search_bundled(
  sp: sansio.SpPaymentreconciliation,
  client: FhirClient,
) {
  let req = sansio.paymentreconciliation_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn paymentreconciliation_search(
  sp: sansio.SpPaymentreconciliation,
  client: FhirClient,
) -> Result(List(resources.Paymentreconciliation), Err) {
  let req = sansio.paymentreconciliation_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.paymentreconciliation
  })
}

pub fn person_create(
  resource: resources.Person,
  client: FhirClient,
) -> Result(resources.Person, Err) {
  any_create(
    resources.person_to_json(resource),
    "Person",
    resources.person_decoder(),
    client,
  )
}

pub fn person_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Person, Err) {
  any_read(id, client, "Person", resources.person_decoder())
}

pub fn person_update(
  resource: resources.Person,
  client: FhirClient,
) -> Result(resources.Person, Err) {
  any_update(
    resource.id,
    resources.person_to_json(resource),
    "Person",
    resources.person_decoder(),
    client,
  )
}

pub fn person_delete(
  resource: resources.Person,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Person", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn person_search_bundled(sp: sansio.SpPerson, client: FhirClient) {
  let req = sansio.person_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn person_search(
  sp: sansio.SpPerson,
  client: FhirClient,
) -> Result(List(resources.Person), Err) {
  let req = sansio.person_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.person
  })
}

pub fn plandefinition_create(
  resource: resources.Plandefinition,
  client: FhirClient,
) -> Result(resources.Plandefinition, Err) {
  any_create(
    resources.plandefinition_to_json(resource),
    "PlanDefinition",
    resources.plandefinition_decoder(),
    client,
  )
}

pub fn plandefinition_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Plandefinition, Err) {
  any_read(id, client, "PlanDefinition", resources.plandefinition_decoder())
}

pub fn plandefinition_update(
  resource: resources.Plandefinition,
  client: FhirClient,
) -> Result(resources.Plandefinition, Err) {
  any_update(
    resource.id,
    resources.plandefinition_to_json(resource),
    "PlanDefinition",
    resources.plandefinition_decoder(),
    client,
  )
}

pub fn plandefinition_delete(
  resource: resources.Plandefinition,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Plandefinition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn plandefinition_search_bundled(
  sp: sansio.SpPlandefinition,
  client: FhirClient,
) {
  let req = sansio.plandefinition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn plandefinition_search(
  sp: sansio.SpPlandefinition,
  client: FhirClient,
) -> Result(List(resources.Plandefinition), Err) {
  let req = sansio.plandefinition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.plandefinition
  })
}

pub fn practitioner_create(
  resource: resources.Practitioner,
  client: FhirClient,
) -> Result(resources.Practitioner, Err) {
  any_create(
    resources.practitioner_to_json(resource),
    "Practitioner",
    resources.practitioner_decoder(),
    client,
  )
}

pub fn practitioner_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Practitioner, Err) {
  any_read(id, client, "Practitioner", resources.practitioner_decoder())
}

pub fn practitioner_update(
  resource: resources.Practitioner,
  client: FhirClient,
) -> Result(resources.Practitioner, Err) {
  any_update(
    resource.id,
    resources.practitioner_to_json(resource),
    "Practitioner",
    resources.practitioner_decoder(),
    client,
  )
}

pub fn practitioner_delete(
  resource: resources.Practitioner,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Practitioner", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn practitioner_search_bundled(
  sp: sansio.SpPractitioner,
  client: FhirClient,
) {
  let req = sansio.practitioner_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn practitioner_search(
  sp: sansio.SpPractitioner,
  client: FhirClient,
) -> Result(List(resources.Practitioner), Err) {
  let req = sansio.practitioner_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.practitioner
  })
}

pub fn practitionerrole_create(
  resource: resources.Practitionerrole,
  client: FhirClient,
) -> Result(resources.Practitionerrole, Err) {
  any_create(
    resources.practitionerrole_to_json(resource),
    "PractitionerRole",
    resources.practitionerrole_decoder(),
    client,
  )
}

pub fn practitionerrole_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Practitionerrole, Err) {
  any_read(id, client, "PractitionerRole", resources.practitionerrole_decoder())
}

pub fn practitionerrole_update(
  resource: resources.Practitionerrole,
  client: FhirClient,
) -> Result(resources.Practitionerrole, Err) {
  any_update(
    resource.id,
    resources.practitionerrole_to_json(resource),
    "PractitionerRole",
    resources.practitionerrole_decoder(),
    client,
  )
}

pub fn practitionerrole_delete(
  resource: resources.Practitionerrole,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Practitionerrole", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn practitionerrole_search_bundled(
  sp: sansio.SpPractitionerrole,
  client: FhirClient,
) {
  let req = sansio.practitionerrole_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn practitionerrole_search(
  sp: sansio.SpPractitionerrole,
  client: FhirClient,
) -> Result(List(resources.Practitionerrole), Err) {
  let req = sansio.practitionerrole_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.practitionerrole
  })
}

pub fn procedure_create(
  resource: resources.Procedure,
  client: FhirClient,
) -> Result(resources.Procedure, Err) {
  any_create(
    resources.procedure_to_json(resource),
    "Procedure",
    resources.procedure_decoder(),
    client,
  )
}

pub fn procedure_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Procedure, Err) {
  any_read(id, client, "Procedure", resources.procedure_decoder())
}

pub fn procedure_update(
  resource: resources.Procedure,
  client: FhirClient,
) -> Result(resources.Procedure, Err) {
  any_update(
    resource.id,
    resources.procedure_to_json(resource),
    "Procedure",
    resources.procedure_decoder(),
    client,
  )
}

pub fn procedure_delete(
  resource: resources.Procedure,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Procedure", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn procedure_search_bundled(sp: sansio.SpProcedure, client: FhirClient) {
  let req = sansio.procedure_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn procedure_search(
  sp: sansio.SpProcedure,
  client: FhirClient,
) -> Result(List(resources.Procedure), Err) {
  let req = sansio.procedure_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.procedure
  })
}

pub fn provenance_create(
  resource: resources.Provenance,
  client: FhirClient,
) -> Result(resources.Provenance, Err) {
  any_create(
    resources.provenance_to_json(resource),
    "Provenance",
    resources.provenance_decoder(),
    client,
  )
}

pub fn provenance_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Provenance, Err) {
  any_read(id, client, "Provenance", resources.provenance_decoder())
}

pub fn provenance_update(
  resource: resources.Provenance,
  client: FhirClient,
) -> Result(resources.Provenance, Err) {
  any_update(
    resource.id,
    resources.provenance_to_json(resource),
    "Provenance",
    resources.provenance_decoder(),
    client,
  )
}

pub fn provenance_delete(
  resource: resources.Provenance,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Provenance", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn provenance_search_bundled(sp: sansio.SpProvenance, client: FhirClient) {
  let req = sansio.provenance_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn provenance_search(
  sp: sansio.SpProvenance,
  client: FhirClient,
) -> Result(List(resources.Provenance), Err) {
  let req = sansio.provenance_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.provenance
  })
}

pub fn questionnaire_create(
  resource: resources.Questionnaire,
  client: FhirClient,
) -> Result(resources.Questionnaire, Err) {
  any_create(
    resources.questionnaire_to_json(resource),
    "Questionnaire",
    resources.questionnaire_decoder(),
    client,
  )
}

pub fn questionnaire_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Questionnaire, Err) {
  any_read(id, client, "Questionnaire", resources.questionnaire_decoder())
}

pub fn questionnaire_update(
  resource: resources.Questionnaire,
  client: FhirClient,
) -> Result(resources.Questionnaire, Err) {
  any_update(
    resource.id,
    resources.questionnaire_to_json(resource),
    "Questionnaire",
    resources.questionnaire_decoder(),
    client,
  )
}

pub fn questionnaire_delete(
  resource: resources.Questionnaire,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Questionnaire", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn questionnaire_search_bundled(
  sp: sansio.SpQuestionnaire,
  client: FhirClient,
) {
  let req = sansio.questionnaire_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn questionnaire_search(
  sp: sansio.SpQuestionnaire,
  client: FhirClient,
) -> Result(List(resources.Questionnaire), Err) {
  let req = sansio.questionnaire_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.questionnaire
  })
}

pub fn questionnaireresponse_create(
  resource: resources.Questionnaireresponse,
  client: FhirClient,
) -> Result(resources.Questionnaireresponse, Err) {
  any_create(
    resources.questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    resources.questionnaireresponse_decoder(),
    client,
  )
}

pub fn questionnaireresponse_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Questionnaireresponse, Err) {
  any_read(
    id,
    client,
    "QuestionnaireResponse",
    resources.questionnaireresponse_decoder(),
  )
}

pub fn questionnaireresponse_update(
  resource: resources.Questionnaireresponse,
  client: FhirClient,
) -> Result(resources.Questionnaireresponse, Err) {
  any_update(
    resource.id,
    resources.questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    resources.questionnaireresponse_decoder(),
    client,
  )
}

pub fn questionnaireresponse_delete(
  resource: resources.Questionnaireresponse,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Questionnaireresponse", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn questionnaireresponse_search_bundled(
  sp: sansio.SpQuestionnaireresponse,
  client: FhirClient,
) {
  let req = sansio.questionnaireresponse_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn questionnaireresponse_search(
  sp: sansio.SpQuestionnaireresponse,
  client: FhirClient,
) -> Result(List(resources.Questionnaireresponse), Err) {
  let req = sansio.questionnaireresponse_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.questionnaireresponse
  })
}

pub fn relatedperson_create(
  resource: resources.Relatedperson,
  client: FhirClient,
) -> Result(resources.Relatedperson, Err) {
  any_create(
    resources.relatedperson_to_json(resource),
    "RelatedPerson",
    resources.relatedperson_decoder(),
    client,
  )
}

pub fn relatedperson_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Relatedperson, Err) {
  any_read(id, client, "RelatedPerson", resources.relatedperson_decoder())
}

pub fn relatedperson_update(
  resource: resources.Relatedperson,
  client: FhirClient,
) -> Result(resources.Relatedperson, Err) {
  any_update(
    resource.id,
    resources.relatedperson_to_json(resource),
    "RelatedPerson",
    resources.relatedperson_decoder(),
    client,
  )
}

pub fn relatedperson_delete(
  resource: resources.Relatedperson,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Relatedperson", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn relatedperson_search_bundled(
  sp: sansio.SpRelatedperson,
  client: FhirClient,
) {
  let req = sansio.relatedperson_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn relatedperson_search(
  sp: sansio.SpRelatedperson,
  client: FhirClient,
) -> Result(List(resources.Relatedperson), Err) {
  let req = sansio.relatedperson_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.relatedperson
  })
}

pub fn requestgroup_create(
  resource: resources.Requestgroup,
  client: FhirClient,
) -> Result(resources.Requestgroup, Err) {
  any_create(
    resources.requestgroup_to_json(resource),
    "RequestGroup",
    resources.requestgroup_decoder(),
    client,
  )
}

pub fn requestgroup_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Requestgroup, Err) {
  any_read(id, client, "RequestGroup", resources.requestgroup_decoder())
}

pub fn requestgroup_update(
  resource: resources.Requestgroup,
  client: FhirClient,
) -> Result(resources.Requestgroup, Err) {
  any_update(
    resource.id,
    resources.requestgroup_to_json(resource),
    "RequestGroup",
    resources.requestgroup_decoder(),
    client,
  )
}

pub fn requestgroup_delete(
  resource: resources.Requestgroup,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Requestgroup", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn requestgroup_search_bundled(
  sp: sansio.SpRequestgroup,
  client: FhirClient,
) {
  let req = sansio.requestgroup_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn requestgroup_search(
  sp: sansio.SpRequestgroup,
  client: FhirClient,
) -> Result(List(resources.Requestgroup), Err) {
  let req = sansio.requestgroup_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.requestgroup
  })
}

pub fn researchdefinition_create(
  resource: resources.Researchdefinition,
  client: FhirClient,
) -> Result(resources.Researchdefinition, Err) {
  any_create(
    resources.researchdefinition_to_json(resource),
    "ResearchDefinition",
    resources.researchdefinition_decoder(),
    client,
  )
}

pub fn researchdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Researchdefinition, Err) {
  any_read(
    id,
    client,
    "ResearchDefinition",
    resources.researchdefinition_decoder(),
  )
}

pub fn researchdefinition_update(
  resource: resources.Researchdefinition,
  client: FhirClient,
) -> Result(resources.Researchdefinition, Err) {
  any_update(
    resource.id,
    resources.researchdefinition_to_json(resource),
    "ResearchDefinition",
    resources.researchdefinition_decoder(),
    client,
  )
}

pub fn researchdefinition_delete(
  resource: resources.Researchdefinition,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Researchdefinition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn researchdefinition_search_bundled(
  sp: sansio.SpResearchdefinition,
  client: FhirClient,
) {
  let req = sansio.researchdefinition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn researchdefinition_search(
  sp: sansio.SpResearchdefinition,
  client: FhirClient,
) -> Result(List(resources.Researchdefinition), Err) {
  let req = sansio.researchdefinition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.researchdefinition
  })
}

pub fn researchelementdefinition_create(
  resource: resources.Researchelementdefinition,
  client: FhirClient,
) -> Result(resources.Researchelementdefinition, Err) {
  any_create(
    resources.researchelementdefinition_to_json(resource),
    "ResearchElementDefinition",
    resources.researchelementdefinition_decoder(),
    client,
  )
}

pub fn researchelementdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Researchelementdefinition, Err) {
  any_read(
    id,
    client,
    "ResearchElementDefinition",
    resources.researchelementdefinition_decoder(),
  )
}

pub fn researchelementdefinition_update(
  resource: resources.Researchelementdefinition,
  client: FhirClient,
) -> Result(resources.Researchelementdefinition, Err) {
  any_update(
    resource.id,
    resources.researchelementdefinition_to_json(resource),
    "ResearchElementDefinition",
    resources.researchelementdefinition_decoder(),
    client,
  )
}

pub fn researchelementdefinition_delete(
  resource: resources.Researchelementdefinition,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Researchelementdefinition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn researchelementdefinition_search_bundled(
  sp: sansio.SpResearchelementdefinition,
  client: FhirClient,
) {
  let req = sansio.researchelementdefinition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn researchelementdefinition_search(
  sp: sansio.SpResearchelementdefinition,
  client: FhirClient,
) -> Result(List(resources.Researchelementdefinition), Err) {
  let req = sansio.researchelementdefinition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.researchelementdefinition
  })
}

pub fn researchstudy_create(
  resource: resources.Researchstudy,
  client: FhirClient,
) -> Result(resources.Researchstudy, Err) {
  any_create(
    resources.researchstudy_to_json(resource),
    "ResearchStudy",
    resources.researchstudy_decoder(),
    client,
  )
}

pub fn researchstudy_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Researchstudy, Err) {
  any_read(id, client, "ResearchStudy", resources.researchstudy_decoder())
}

pub fn researchstudy_update(
  resource: resources.Researchstudy,
  client: FhirClient,
) -> Result(resources.Researchstudy, Err) {
  any_update(
    resource.id,
    resources.researchstudy_to_json(resource),
    "ResearchStudy",
    resources.researchstudy_decoder(),
    client,
  )
}

pub fn researchstudy_delete(
  resource: resources.Researchstudy,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Researchstudy", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn researchstudy_search_bundled(
  sp: sansio.SpResearchstudy,
  client: FhirClient,
) {
  let req = sansio.researchstudy_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn researchstudy_search(
  sp: sansio.SpResearchstudy,
  client: FhirClient,
) -> Result(List(resources.Researchstudy), Err) {
  let req = sansio.researchstudy_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.researchstudy
  })
}

pub fn researchsubject_create(
  resource: resources.Researchsubject,
  client: FhirClient,
) -> Result(resources.Researchsubject, Err) {
  any_create(
    resources.researchsubject_to_json(resource),
    "ResearchSubject",
    resources.researchsubject_decoder(),
    client,
  )
}

pub fn researchsubject_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Researchsubject, Err) {
  any_read(id, client, "ResearchSubject", resources.researchsubject_decoder())
}

pub fn researchsubject_update(
  resource: resources.Researchsubject,
  client: FhirClient,
) -> Result(resources.Researchsubject, Err) {
  any_update(
    resource.id,
    resources.researchsubject_to_json(resource),
    "ResearchSubject",
    resources.researchsubject_decoder(),
    client,
  )
}

pub fn researchsubject_delete(
  resource: resources.Researchsubject,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Researchsubject", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn researchsubject_search_bundled(
  sp: sansio.SpResearchsubject,
  client: FhirClient,
) {
  let req = sansio.researchsubject_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn researchsubject_search(
  sp: sansio.SpResearchsubject,
  client: FhirClient,
) -> Result(List(resources.Researchsubject), Err) {
  let req = sansio.researchsubject_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.researchsubject
  })
}

pub fn riskassessment_create(
  resource: resources.Riskassessment,
  client: FhirClient,
) -> Result(resources.Riskassessment, Err) {
  any_create(
    resources.riskassessment_to_json(resource),
    "RiskAssessment",
    resources.riskassessment_decoder(),
    client,
  )
}

pub fn riskassessment_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Riskassessment, Err) {
  any_read(id, client, "RiskAssessment", resources.riskassessment_decoder())
}

pub fn riskassessment_update(
  resource: resources.Riskassessment,
  client: FhirClient,
) -> Result(resources.Riskassessment, Err) {
  any_update(
    resource.id,
    resources.riskassessment_to_json(resource),
    "RiskAssessment",
    resources.riskassessment_decoder(),
    client,
  )
}

pub fn riskassessment_delete(
  resource: resources.Riskassessment,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Riskassessment", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn riskassessment_search_bundled(
  sp: sansio.SpRiskassessment,
  client: FhirClient,
) {
  let req = sansio.riskassessment_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn riskassessment_search(
  sp: sansio.SpRiskassessment,
  client: FhirClient,
) -> Result(List(resources.Riskassessment), Err) {
  let req = sansio.riskassessment_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.riskassessment
  })
}

pub fn riskevidencesynthesis_create(
  resource: resources.Riskevidencesynthesis,
  client: FhirClient,
) -> Result(resources.Riskevidencesynthesis, Err) {
  any_create(
    resources.riskevidencesynthesis_to_json(resource),
    "RiskEvidenceSynthesis",
    resources.riskevidencesynthesis_decoder(),
    client,
  )
}

pub fn riskevidencesynthesis_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Riskevidencesynthesis, Err) {
  any_read(
    id,
    client,
    "RiskEvidenceSynthesis",
    resources.riskevidencesynthesis_decoder(),
  )
}

pub fn riskevidencesynthesis_update(
  resource: resources.Riskevidencesynthesis,
  client: FhirClient,
) -> Result(resources.Riskevidencesynthesis, Err) {
  any_update(
    resource.id,
    resources.riskevidencesynthesis_to_json(resource),
    "RiskEvidenceSynthesis",
    resources.riskevidencesynthesis_decoder(),
    client,
  )
}

pub fn riskevidencesynthesis_delete(
  resource: resources.Riskevidencesynthesis,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Riskevidencesynthesis", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn riskevidencesynthesis_search_bundled(
  sp: sansio.SpRiskevidencesynthesis,
  client: FhirClient,
) {
  let req = sansio.riskevidencesynthesis_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn riskevidencesynthesis_search(
  sp: sansio.SpRiskevidencesynthesis,
  client: FhirClient,
) -> Result(List(resources.Riskevidencesynthesis), Err) {
  let req = sansio.riskevidencesynthesis_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.riskevidencesynthesis
  })
}

pub fn schedule_create(
  resource: resources.Schedule,
  client: FhirClient,
) -> Result(resources.Schedule, Err) {
  any_create(
    resources.schedule_to_json(resource),
    "Schedule",
    resources.schedule_decoder(),
    client,
  )
}

pub fn schedule_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Schedule, Err) {
  any_read(id, client, "Schedule", resources.schedule_decoder())
}

pub fn schedule_update(
  resource: resources.Schedule,
  client: FhirClient,
) -> Result(resources.Schedule, Err) {
  any_update(
    resource.id,
    resources.schedule_to_json(resource),
    "Schedule",
    resources.schedule_decoder(),
    client,
  )
}

pub fn schedule_delete(
  resource: resources.Schedule,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Schedule", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn schedule_search_bundled(sp: sansio.SpSchedule, client: FhirClient) {
  let req = sansio.schedule_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn schedule_search(
  sp: sansio.SpSchedule,
  client: FhirClient,
) -> Result(List(resources.Schedule), Err) {
  let req = sansio.schedule_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.schedule
  })
}

pub fn searchparameter_create(
  resource: resources.Searchparameter,
  client: FhirClient,
) -> Result(resources.Searchparameter, Err) {
  any_create(
    resources.searchparameter_to_json(resource),
    "SearchParameter",
    resources.searchparameter_decoder(),
    client,
  )
}

pub fn searchparameter_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Searchparameter, Err) {
  any_read(id, client, "SearchParameter", resources.searchparameter_decoder())
}

pub fn searchparameter_update(
  resource: resources.Searchparameter,
  client: FhirClient,
) -> Result(resources.Searchparameter, Err) {
  any_update(
    resource.id,
    resources.searchparameter_to_json(resource),
    "SearchParameter",
    resources.searchparameter_decoder(),
    client,
  )
}

pub fn searchparameter_delete(
  resource: resources.Searchparameter,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Searchparameter", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn searchparameter_search_bundled(
  sp: sansio.SpSearchparameter,
  client: FhirClient,
) {
  let req = sansio.searchparameter_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn searchparameter_search(
  sp: sansio.SpSearchparameter,
  client: FhirClient,
) -> Result(List(resources.Searchparameter), Err) {
  let req = sansio.searchparameter_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.searchparameter
  })
}

pub fn servicerequest_create(
  resource: resources.Servicerequest,
  client: FhirClient,
) -> Result(resources.Servicerequest, Err) {
  any_create(
    resources.servicerequest_to_json(resource),
    "ServiceRequest",
    resources.servicerequest_decoder(),
    client,
  )
}

pub fn servicerequest_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Servicerequest, Err) {
  any_read(id, client, "ServiceRequest", resources.servicerequest_decoder())
}

pub fn servicerequest_update(
  resource: resources.Servicerequest,
  client: FhirClient,
) -> Result(resources.Servicerequest, Err) {
  any_update(
    resource.id,
    resources.servicerequest_to_json(resource),
    "ServiceRequest",
    resources.servicerequest_decoder(),
    client,
  )
}

pub fn servicerequest_delete(
  resource: resources.Servicerequest,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Servicerequest", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn servicerequest_search_bundled(
  sp: sansio.SpServicerequest,
  client: FhirClient,
) {
  let req = sansio.servicerequest_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn servicerequest_search(
  sp: sansio.SpServicerequest,
  client: FhirClient,
) -> Result(List(resources.Servicerequest), Err) {
  let req = sansio.servicerequest_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.servicerequest
  })
}

pub fn slot_create(
  resource: resources.Slot,
  client: FhirClient,
) -> Result(resources.Slot, Err) {
  any_create(
    resources.slot_to_json(resource),
    "Slot",
    resources.slot_decoder(),
    client,
  )
}

pub fn slot_read(id: String, client: FhirClient) -> Result(resources.Slot, Err) {
  any_read(id, client, "Slot", resources.slot_decoder())
}

pub fn slot_update(
  resource: resources.Slot,
  client: FhirClient,
) -> Result(resources.Slot, Err) {
  any_update(
    resource.id,
    resources.slot_to_json(resource),
    "Slot",
    resources.slot_decoder(),
    client,
  )
}

pub fn slot_delete(
  resource: resources.Slot,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Slot", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn slot_search_bundled(sp: sansio.SpSlot, client: FhirClient) {
  let req = sansio.slot_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn slot_search(
  sp: sansio.SpSlot,
  client: FhirClient,
) -> Result(List(resources.Slot), Err) {
  let req = sansio.slot_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.slot
  })
}

pub fn specimen_create(
  resource: resources.Specimen,
  client: FhirClient,
) -> Result(resources.Specimen, Err) {
  any_create(
    resources.specimen_to_json(resource),
    "Specimen",
    resources.specimen_decoder(),
    client,
  )
}

pub fn specimen_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Specimen, Err) {
  any_read(id, client, "Specimen", resources.specimen_decoder())
}

pub fn specimen_update(
  resource: resources.Specimen,
  client: FhirClient,
) -> Result(resources.Specimen, Err) {
  any_update(
    resource.id,
    resources.specimen_to_json(resource),
    "Specimen",
    resources.specimen_decoder(),
    client,
  )
}

pub fn specimen_delete(
  resource: resources.Specimen,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Specimen", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn specimen_search_bundled(sp: sansio.SpSpecimen, client: FhirClient) {
  let req = sansio.specimen_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn specimen_search(
  sp: sansio.SpSpecimen,
  client: FhirClient,
) -> Result(List(resources.Specimen), Err) {
  let req = sansio.specimen_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.specimen
  })
}

pub fn specimendefinition_create(
  resource: resources.Specimendefinition,
  client: FhirClient,
) -> Result(resources.Specimendefinition, Err) {
  any_create(
    resources.specimendefinition_to_json(resource),
    "SpecimenDefinition",
    resources.specimendefinition_decoder(),
    client,
  )
}

pub fn specimendefinition_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Specimendefinition, Err) {
  any_read(
    id,
    client,
    "SpecimenDefinition",
    resources.specimendefinition_decoder(),
  )
}

pub fn specimendefinition_update(
  resource: resources.Specimendefinition,
  client: FhirClient,
) -> Result(resources.Specimendefinition, Err) {
  any_update(
    resource.id,
    resources.specimendefinition_to_json(resource),
    "SpecimenDefinition",
    resources.specimendefinition_decoder(),
    client,
  )
}

pub fn specimendefinition_delete(
  resource: resources.Specimendefinition,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Specimendefinition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn specimendefinition_search_bundled(
  sp: sansio.SpSpecimendefinition,
  client: FhirClient,
) {
  let req = sansio.specimendefinition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn specimendefinition_search(
  sp: sansio.SpSpecimendefinition,
  client: FhirClient,
) -> Result(List(resources.Specimendefinition), Err) {
  let req = sansio.specimendefinition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.specimendefinition
  })
}

pub fn structuredefinition_create(
  resource: resources.Structuredefinition,
  client: FhirClient,
) -> Result(resources.Structuredefinition, Err) {
  any_create(
    resources.structuredefinition_to_json(resource),
    "StructureDefinition",
    resources.structuredefinition_decoder(),
    client,
  )
}

pub fn structuredefinition_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Structuredefinition, Err) {
  any_read(
    id,
    client,
    "StructureDefinition",
    resources.structuredefinition_decoder(),
  )
}

pub fn structuredefinition_update(
  resource: resources.Structuredefinition,
  client: FhirClient,
) -> Result(resources.Structuredefinition, Err) {
  any_update(
    resource.id,
    resources.structuredefinition_to_json(resource),
    "StructureDefinition",
    resources.structuredefinition_decoder(),
    client,
  )
}

pub fn structuredefinition_delete(
  resource: resources.Structuredefinition,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Structuredefinition", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn structuredefinition_search_bundled(
  sp: sansio.SpStructuredefinition,
  client: FhirClient,
) {
  let req = sansio.structuredefinition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn structuredefinition_search(
  sp: sansio.SpStructuredefinition,
  client: FhirClient,
) -> Result(List(resources.Structuredefinition), Err) {
  let req = sansio.structuredefinition_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.structuredefinition
  })
}

pub fn structuremap_create(
  resource: resources.Structuremap,
  client: FhirClient,
) -> Result(resources.Structuremap, Err) {
  any_create(
    resources.structuremap_to_json(resource),
    "StructureMap",
    resources.structuremap_decoder(),
    client,
  )
}

pub fn structuremap_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Structuremap, Err) {
  any_read(id, client, "StructureMap", resources.structuremap_decoder())
}

pub fn structuremap_update(
  resource: resources.Structuremap,
  client: FhirClient,
) -> Result(resources.Structuremap, Err) {
  any_update(
    resource.id,
    resources.structuremap_to_json(resource),
    "StructureMap",
    resources.structuremap_decoder(),
    client,
  )
}

pub fn structuremap_delete(
  resource: resources.Structuremap,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Structuremap", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn structuremap_search_bundled(
  sp: sansio.SpStructuremap,
  client: FhirClient,
) {
  let req = sansio.structuremap_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn structuremap_search(
  sp: sansio.SpStructuremap,
  client: FhirClient,
) -> Result(List(resources.Structuremap), Err) {
  let req = sansio.structuremap_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.structuremap
  })
}

pub fn subscription_create(
  resource: resources.Subscription,
  client: FhirClient,
) -> Result(resources.Subscription, Err) {
  any_create(
    resources.subscription_to_json(resource),
    "Subscription",
    resources.subscription_decoder(),
    client,
  )
}

pub fn subscription_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Subscription, Err) {
  any_read(id, client, "Subscription", resources.subscription_decoder())
}

pub fn subscription_update(
  resource: resources.Subscription,
  client: FhirClient,
) -> Result(resources.Subscription, Err) {
  any_update(
    resource.id,
    resources.subscription_to_json(resource),
    "Subscription",
    resources.subscription_decoder(),
    client,
  )
}

pub fn subscription_delete(
  resource: resources.Subscription,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Subscription", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn subscription_search_bundled(
  sp: sansio.SpSubscription,
  client: FhirClient,
) {
  let req = sansio.subscription_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn subscription_search(
  sp: sansio.SpSubscription,
  client: FhirClient,
) -> Result(List(resources.Subscription), Err) {
  let req = sansio.subscription_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.subscription
  })
}

pub fn substance_create(
  resource: resources.Substance,
  client: FhirClient,
) -> Result(resources.Substance, Err) {
  any_create(
    resources.substance_to_json(resource),
    "Substance",
    resources.substance_decoder(),
    client,
  )
}

pub fn substance_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Substance, Err) {
  any_read(id, client, "Substance", resources.substance_decoder())
}

pub fn substance_update(
  resource: resources.Substance,
  client: FhirClient,
) -> Result(resources.Substance, Err) {
  any_update(
    resource.id,
    resources.substance_to_json(resource),
    "Substance",
    resources.substance_decoder(),
    client,
  )
}

pub fn substance_delete(
  resource: resources.Substance,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Substance", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn substance_search_bundled(sp: sansio.SpSubstance, client: FhirClient) {
  let req = sansio.substance_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn substance_search(
  sp: sansio.SpSubstance,
  client: FhirClient,
) -> Result(List(resources.Substance), Err) {
  let req = sansio.substance_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.substance
  })
}

pub fn substancenucleicacid_create(
  resource: resources.Substancenucleicacid,
  client: FhirClient,
) -> Result(resources.Substancenucleicacid, Err) {
  any_create(
    resources.substancenucleicacid_to_json(resource),
    "SubstanceNucleicAcid",
    resources.substancenucleicacid_decoder(),
    client,
  )
}

pub fn substancenucleicacid_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Substancenucleicacid, Err) {
  any_read(
    id,
    client,
    "SubstanceNucleicAcid",
    resources.substancenucleicacid_decoder(),
  )
}

pub fn substancenucleicacid_update(
  resource: resources.Substancenucleicacid,
  client: FhirClient,
) -> Result(resources.Substancenucleicacid, Err) {
  any_update(
    resource.id,
    resources.substancenucleicacid_to_json(resource),
    "SubstanceNucleicAcid",
    resources.substancenucleicacid_decoder(),
    client,
  )
}

pub fn substancenucleicacid_delete(
  resource: resources.Substancenucleicacid,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Substancenucleicacid", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn substancenucleicacid_search_bundled(
  sp: sansio.SpSubstancenucleicacid,
  client: FhirClient,
) {
  let req = sansio.substancenucleicacid_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn substancenucleicacid_search(
  sp: sansio.SpSubstancenucleicacid,
  client: FhirClient,
) -> Result(List(resources.Substancenucleicacid), Err) {
  let req = sansio.substancenucleicacid_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.substancenucleicacid
  })
}

pub fn substancepolymer_create(
  resource: resources.Substancepolymer,
  client: FhirClient,
) -> Result(resources.Substancepolymer, Err) {
  any_create(
    resources.substancepolymer_to_json(resource),
    "SubstancePolymer",
    resources.substancepolymer_decoder(),
    client,
  )
}

pub fn substancepolymer_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Substancepolymer, Err) {
  any_read(id, client, "SubstancePolymer", resources.substancepolymer_decoder())
}

pub fn substancepolymer_update(
  resource: resources.Substancepolymer,
  client: FhirClient,
) -> Result(resources.Substancepolymer, Err) {
  any_update(
    resource.id,
    resources.substancepolymer_to_json(resource),
    "SubstancePolymer",
    resources.substancepolymer_decoder(),
    client,
  )
}

pub fn substancepolymer_delete(
  resource: resources.Substancepolymer,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Substancepolymer", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn substancepolymer_search_bundled(
  sp: sansio.SpSubstancepolymer,
  client: FhirClient,
) {
  let req = sansio.substancepolymer_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn substancepolymer_search(
  sp: sansio.SpSubstancepolymer,
  client: FhirClient,
) -> Result(List(resources.Substancepolymer), Err) {
  let req = sansio.substancepolymer_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.substancepolymer
  })
}

pub fn substanceprotein_create(
  resource: resources.Substanceprotein,
  client: FhirClient,
) -> Result(resources.Substanceprotein, Err) {
  any_create(
    resources.substanceprotein_to_json(resource),
    "SubstanceProtein",
    resources.substanceprotein_decoder(),
    client,
  )
}

pub fn substanceprotein_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Substanceprotein, Err) {
  any_read(id, client, "SubstanceProtein", resources.substanceprotein_decoder())
}

pub fn substanceprotein_update(
  resource: resources.Substanceprotein,
  client: FhirClient,
) -> Result(resources.Substanceprotein, Err) {
  any_update(
    resource.id,
    resources.substanceprotein_to_json(resource),
    "SubstanceProtein",
    resources.substanceprotein_decoder(),
    client,
  )
}

pub fn substanceprotein_delete(
  resource: resources.Substanceprotein,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Substanceprotein", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn substanceprotein_search_bundled(
  sp: sansio.SpSubstanceprotein,
  client: FhirClient,
) {
  let req = sansio.substanceprotein_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn substanceprotein_search(
  sp: sansio.SpSubstanceprotein,
  client: FhirClient,
) -> Result(List(resources.Substanceprotein), Err) {
  let req = sansio.substanceprotein_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.substanceprotein
  })
}

pub fn substancereferenceinformation_create(
  resource: resources.Substancereferenceinformation,
  client: FhirClient,
) -> Result(resources.Substancereferenceinformation, Err) {
  any_create(
    resources.substancereferenceinformation_to_json(resource),
    "SubstanceReferenceInformation",
    resources.substancereferenceinformation_decoder(),
    client,
  )
}

pub fn substancereferenceinformation_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Substancereferenceinformation, Err) {
  any_read(
    id,
    client,
    "SubstanceReferenceInformation",
    resources.substancereferenceinformation_decoder(),
  )
}

pub fn substancereferenceinformation_update(
  resource: resources.Substancereferenceinformation,
  client: FhirClient,
) -> Result(resources.Substancereferenceinformation, Err) {
  any_update(
    resource.id,
    resources.substancereferenceinformation_to_json(resource),
    "SubstanceReferenceInformation",
    resources.substancereferenceinformation_decoder(),
    client,
  )
}

pub fn substancereferenceinformation_delete(
  resource: resources.Substancereferenceinformation,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Substancereferenceinformation", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn substancereferenceinformation_search_bundled(
  sp: sansio.SpSubstancereferenceinformation,
  client: FhirClient,
) {
  let req = sansio.substancereferenceinformation_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn substancereferenceinformation_search(
  sp: sansio.SpSubstancereferenceinformation,
  client: FhirClient,
) -> Result(List(resources.Substancereferenceinformation), Err) {
  let req = sansio.substancereferenceinformation_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.substancereferenceinformation
  })
}

pub fn substancesourcematerial_create(
  resource: resources.Substancesourcematerial,
  client: FhirClient,
) -> Result(resources.Substancesourcematerial, Err) {
  any_create(
    resources.substancesourcematerial_to_json(resource),
    "SubstanceSourceMaterial",
    resources.substancesourcematerial_decoder(),
    client,
  )
}

pub fn substancesourcematerial_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Substancesourcematerial, Err) {
  any_read(
    id,
    client,
    "SubstanceSourceMaterial",
    resources.substancesourcematerial_decoder(),
  )
}

pub fn substancesourcematerial_update(
  resource: resources.Substancesourcematerial,
  client: FhirClient,
) -> Result(resources.Substancesourcematerial, Err) {
  any_update(
    resource.id,
    resources.substancesourcematerial_to_json(resource),
    "SubstanceSourceMaterial",
    resources.substancesourcematerial_decoder(),
    client,
  )
}

pub fn substancesourcematerial_delete(
  resource: resources.Substancesourcematerial,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Substancesourcematerial", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn substancesourcematerial_search_bundled(
  sp: sansio.SpSubstancesourcematerial,
  client: FhirClient,
) {
  let req = sansio.substancesourcematerial_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn substancesourcematerial_search(
  sp: sansio.SpSubstancesourcematerial,
  client: FhirClient,
) -> Result(List(resources.Substancesourcematerial), Err) {
  let req = sansio.substancesourcematerial_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.substancesourcematerial
  })
}

pub fn substancespecification_create(
  resource: resources.Substancespecification,
  client: FhirClient,
) -> Result(resources.Substancespecification, Err) {
  any_create(
    resources.substancespecification_to_json(resource),
    "SubstanceSpecification",
    resources.substancespecification_decoder(),
    client,
  )
}

pub fn substancespecification_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Substancespecification, Err) {
  any_read(
    id,
    client,
    "SubstanceSpecification",
    resources.substancespecification_decoder(),
  )
}

pub fn substancespecification_update(
  resource: resources.Substancespecification,
  client: FhirClient,
) -> Result(resources.Substancespecification, Err) {
  any_update(
    resource.id,
    resources.substancespecification_to_json(resource),
    "SubstanceSpecification",
    resources.substancespecification_decoder(),
    client,
  )
}

pub fn substancespecification_delete(
  resource: resources.Substancespecification,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Substancespecification", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn substancespecification_search_bundled(
  sp: sansio.SpSubstancespecification,
  client: FhirClient,
) {
  let req = sansio.substancespecification_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn substancespecification_search(
  sp: sansio.SpSubstancespecification,
  client: FhirClient,
) -> Result(List(resources.Substancespecification), Err) {
  let req = sansio.substancespecification_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.substancespecification
  })
}

pub fn supplydelivery_create(
  resource: resources.Supplydelivery,
  client: FhirClient,
) -> Result(resources.Supplydelivery, Err) {
  any_create(
    resources.supplydelivery_to_json(resource),
    "SupplyDelivery",
    resources.supplydelivery_decoder(),
    client,
  )
}

pub fn supplydelivery_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Supplydelivery, Err) {
  any_read(id, client, "SupplyDelivery", resources.supplydelivery_decoder())
}

pub fn supplydelivery_update(
  resource: resources.Supplydelivery,
  client: FhirClient,
) -> Result(resources.Supplydelivery, Err) {
  any_update(
    resource.id,
    resources.supplydelivery_to_json(resource),
    "SupplyDelivery",
    resources.supplydelivery_decoder(),
    client,
  )
}

pub fn supplydelivery_delete(
  resource: resources.Supplydelivery,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Supplydelivery", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn supplydelivery_search_bundled(
  sp: sansio.SpSupplydelivery,
  client: FhirClient,
) {
  let req = sansio.supplydelivery_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn supplydelivery_search(
  sp: sansio.SpSupplydelivery,
  client: FhirClient,
) -> Result(List(resources.Supplydelivery), Err) {
  let req = sansio.supplydelivery_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.supplydelivery
  })
}

pub fn supplyrequest_create(
  resource: resources.Supplyrequest,
  client: FhirClient,
) -> Result(resources.Supplyrequest, Err) {
  any_create(
    resources.supplyrequest_to_json(resource),
    "SupplyRequest",
    resources.supplyrequest_decoder(),
    client,
  )
}

pub fn supplyrequest_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Supplyrequest, Err) {
  any_read(id, client, "SupplyRequest", resources.supplyrequest_decoder())
}

pub fn supplyrequest_update(
  resource: resources.Supplyrequest,
  client: FhirClient,
) -> Result(resources.Supplyrequest, Err) {
  any_update(
    resource.id,
    resources.supplyrequest_to_json(resource),
    "SupplyRequest",
    resources.supplyrequest_decoder(),
    client,
  )
}

pub fn supplyrequest_delete(
  resource: resources.Supplyrequest,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Supplyrequest", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn supplyrequest_search_bundled(
  sp: sansio.SpSupplyrequest,
  client: FhirClient,
) {
  let req = sansio.supplyrequest_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn supplyrequest_search(
  sp: sansio.SpSupplyrequest,
  client: FhirClient,
) -> Result(List(resources.Supplyrequest), Err) {
  let req = sansio.supplyrequest_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.supplyrequest
  })
}

pub fn task_create(
  resource: resources.Task,
  client: FhirClient,
) -> Result(resources.Task, Err) {
  any_create(
    resources.task_to_json(resource),
    "Task",
    resources.task_decoder(),
    client,
  )
}

pub fn task_read(id: String, client: FhirClient) -> Result(resources.Task, Err) {
  any_read(id, client, "Task", resources.task_decoder())
}

pub fn task_update(
  resource: resources.Task,
  client: FhirClient,
) -> Result(resources.Task, Err) {
  any_update(
    resource.id,
    resources.task_to_json(resource),
    "Task",
    resources.task_decoder(),
    client,
  )
}

pub fn task_delete(
  resource: resources.Task,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Task", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn task_search_bundled(sp: sansio.SpTask, client: FhirClient) {
  let req = sansio.task_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn task_search(
  sp: sansio.SpTask,
  client: FhirClient,
) -> Result(List(resources.Task), Err) {
  let req = sansio.task_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.task
  })
}

pub fn terminologycapabilities_create(
  resource: resources.Terminologycapabilities,
  client: FhirClient,
) -> Result(resources.Terminologycapabilities, Err) {
  any_create(
    resources.terminologycapabilities_to_json(resource),
    "TerminologyCapabilities",
    resources.terminologycapabilities_decoder(),
    client,
  )
}

pub fn terminologycapabilities_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Terminologycapabilities, Err) {
  any_read(
    id,
    client,
    "TerminologyCapabilities",
    resources.terminologycapabilities_decoder(),
  )
}

pub fn terminologycapabilities_update(
  resource: resources.Terminologycapabilities,
  client: FhirClient,
) -> Result(resources.Terminologycapabilities, Err) {
  any_update(
    resource.id,
    resources.terminologycapabilities_to_json(resource),
    "TerminologyCapabilities",
    resources.terminologycapabilities_decoder(),
    client,
  )
}

pub fn terminologycapabilities_delete(
  resource: resources.Terminologycapabilities,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Terminologycapabilities", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn terminologycapabilities_search_bundled(
  sp: sansio.SpTerminologycapabilities,
  client: FhirClient,
) {
  let req = sansio.terminologycapabilities_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn terminologycapabilities_search(
  sp: sansio.SpTerminologycapabilities,
  client: FhirClient,
) -> Result(List(resources.Terminologycapabilities), Err) {
  let req = sansio.terminologycapabilities_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.terminologycapabilities
  })
}

pub fn testreport_create(
  resource: resources.Testreport,
  client: FhirClient,
) -> Result(resources.Testreport, Err) {
  any_create(
    resources.testreport_to_json(resource),
    "TestReport",
    resources.testreport_decoder(),
    client,
  )
}

pub fn testreport_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Testreport, Err) {
  any_read(id, client, "TestReport", resources.testreport_decoder())
}

pub fn testreport_update(
  resource: resources.Testreport,
  client: FhirClient,
) -> Result(resources.Testreport, Err) {
  any_update(
    resource.id,
    resources.testreport_to_json(resource),
    "TestReport",
    resources.testreport_decoder(),
    client,
  )
}

pub fn testreport_delete(
  resource: resources.Testreport,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Testreport", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn testreport_search_bundled(sp: sansio.SpTestreport, client: FhirClient) {
  let req = sansio.testreport_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn testreport_search(
  sp: sansio.SpTestreport,
  client: FhirClient,
) -> Result(List(resources.Testreport), Err) {
  let req = sansio.testreport_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.testreport
  })
}

pub fn testscript_create(
  resource: resources.Testscript,
  client: FhirClient,
) -> Result(resources.Testscript, Err) {
  any_create(
    resources.testscript_to_json(resource),
    "TestScript",
    resources.testscript_decoder(),
    client,
  )
}

pub fn testscript_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Testscript, Err) {
  any_read(id, client, "TestScript", resources.testscript_decoder())
}

pub fn testscript_update(
  resource: resources.Testscript,
  client: FhirClient,
) -> Result(resources.Testscript, Err) {
  any_update(
    resource.id,
    resources.testscript_to_json(resource),
    "TestScript",
    resources.testscript_decoder(),
    client,
  )
}

pub fn testscript_delete(
  resource: resources.Testscript,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Testscript", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn testscript_search_bundled(sp: sansio.SpTestscript, client: FhirClient) {
  let req = sansio.testscript_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn testscript_search(
  sp: sansio.SpTestscript,
  client: FhirClient,
) -> Result(List(resources.Testscript), Err) {
  let req = sansio.testscript_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.testscript
  })
}

pub fn valueset_create(
  resource: resources.Valueset,
  client: FhirClient,
) -> Result(resources.Valueset, Err) {
  any_create(
    resources.valueset_to_json(resource),
    "ValueSet",
    resources.valueset_decoder(),
    client,
  )
}

pub fn valueset_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Valueset, Err) {
  any_read(id, client, "ValueSet", resources.valueset_decoder())
}

pub fn valueset_update(
  resource: resources.Valueset,
  client: FhirClient,
) -> Result(resources.Valueset, Err) {
  any_update(
    resource.id,
    resources.valueset_to_json(resource),
    "ValueSet",
    resources.valueset_decoder(),
    client,
  )
}

pub fn valueset_delete(
  resource: resources.Valueset,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Valueset", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn valueset_search_bundled(sp: sansio.SpValueset, client: FhirClient) {
  let req = sansio.valueset_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn valueset_search(
  sp: sansio.SpValueset,
  client: FhirClient,
) -> Result(List(resources.Valueset), Err) {
  let req = sansio.valueset_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.valueset
  })
}

pub fn verificationresult_create(
  resource: resources.Verificationresult,
  client: FhirClient,
) -> Result(resources.Verificationresult, Err) {
  any_create(
    resources.verificationresult_to_json(resource),
    "VerificationResult",
    resources.verificationresult_decoder(),
    client,
  )
}

pub fn verificationresult_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Verificationresult, Err) {
  any_read(
    id,
    client,
    "VerificationResult",
    resources.verificationresult_decoder(),
  )
}

pub fn verificationresult_update(
  resource: resources.Verificationresult,
  client: FhirClient,
) -> Result(resources.Verificationresult, Err) {
  any_update(
    resource.id,
    resources.verificationresult_to_json(resource),
    "VerificationResult",
    resources.verificationresult_decoder(),
    client,
  )
}

pub fn verificationresult_delete(
  resource: resources.Verificationresult,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Verificationresult", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn verificationresult_search_bundled(
  sp: sansio.SpVerificationresult,
  client: FhirClient,
) {
  let req = sansio.verificationresult_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn verificationresult_search(
  sp: sansio.SpVerificationresult,
  client: FhirClient,
) -> Result(List(resources.Verificationresult), Err) {
  let req = sansio.verificationresult_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.verificationresult
  })
}

pub fn visionprescription_create(
  resource: resources.Visionprescription,
  client: FhirClient,
) -> Result(resources.Visionprescription, Err) {
  any_create(
    resources.visionprescription_to_json(resource),
    "VisionPrescription",
    resources.visionprescription_decoder(),
    client,
  )
}

pub fn visionprescription_read(
  id: String,
  client: FhirClient,
) -> Result(resources.Visionprescription, Err) {
  any_read(
    id,
    client,
    "VisionPrescription",
    resources.visionprescription_decoder(),
  )
}

pub fn visionprescription_update(
  resource: resources.Visionprescription,
  client: FhirClient,
) -> Result(resources.Visionprescription, Err) {
  any_update(
    resource.id,
    resources.visionprescription_to_json(resource),
    "VisionPrescription",
    resources.visionprescription_decoder(),
    client,
  )
}

pub fn visionprescription_delete(
  resource: resources.Visionprescription,
  client: FhirClient,
) -> Result(sansio.OperationoutcomeOrHTTP, Err) {
  case resource.id {
    Some(id) -> any_delete(id, "Visionprescription", client)
    None -> Error(ErrSansio(ErrNoId))
  }
}

pub fn visionprescription_search_bundled(
  sp: sansio.SpVisionprescription,
  client: FhirClient,
) {
  let req = sansio.visionprescription_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
}

pub fn visionprescription_search(
  sp: sansio.SpVisionprescription,
  client: FhirClient,
) -> Result(List(resources.Visionprescription), Err) {
  let req = sansio.visionprescription_search_req(sp, client)
  sendreq_parseresource(req, resources.bundle_decoder(), "Bundle")
  |> result.map(fn(bundle) {
    { bundle |> sansio.bundle_to_groupedresources }.visionprescription
  })
}
