////[https://hl7.org/fhir/r4us](https://hl7.org/fhir/r4us) r4us client using httpc

import fhir/r4us
import fhir/r4us_sansio
import gleam/dynamic/decode.{type Decoder}
import gleam/http/request.{type Request}
import gleam/httpc
import gleam/json.{type Json}
import gleam/option.{type Option}
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
  ErrHttpc(httpc.HttpError)
  ErrSansio(err: r4us_sansio.Err)
}

fn any_create(
  resource: Json,
  res_type: String,
  resource_dec: Decoder(r),
  client: FhirClient,
) -> Result(r, Err) {
  let req = r4us_sansio.any_create_req(resource, res_type, client)
  sendreq_parseresource(req, resource_dec)
}

fn any_read(
  id: String,
  client: FhirClient,
  res_type: String,
  resource_dec: Decoder(a),
) -> Result(a, Err) {
  let req = r4us_sansio.any_read_req(id, res_type, client)
  sendreq_parseresource(req, resource_dec)
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
    Ok(req) -> sendreq_parseresource(req, res_dec)
    Error(err) -> Error(ErrSansio(err))
    //can have error preparing update request if resource has no id
  }
}

fn any_delete(
  id: Option(String),
  res_type: String,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  let req = r4us_sansio.any_delete_req(id, res_type, client)
  case req {
    Ok(req) -> sendreq_parseresource(req, r4us.operationoutcome_decoder())
    Error(err) -> Error(ErrSansio(err))
    //can have error preparing delete request if resource has no id
  }
}

/// write out search string manually, in case typed search params don't work
pub fn search_any(
  search_string: String,
  res_type: String,
  client: FhirClient,
) -> Result(r4us.Bundle, Err) {
  let req = r4us_sansio.any_search_req(search_string, res_type, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

/// run any operation string on any resource string, optionally using Parameters
pub fn operation_any(
  params params: Option(r4us.Parameters),
  operation_name operation_name: String,
  res_type res_type: String,
  res_id res_id: Option(String),
  res_decoder res_decoder: Decoder(res),
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
  sendreq_parseresource(req, res_decoder)
}

fn sendreq_parseresource(
  req: Request(String),
  res_dec: Decoder(r),
) -> Result(r, Err) {
  case httpc.send(req) {
    Error(err) -> Error(ErrHttpc(err))
    Ok(resp) ->
      case r4us_sansio.any_resp(resp, res_dec) {
        Ok(resource) -> Ok(resource)
        Error(err) -> Error(ErrSansio(err))
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Account", client)
}

pub fn account_search_bundled(sp: r4us_sansio.SpAccount, client: FhirClient) {
  let req = r4us_sansio.account_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn account_search(
  sp: r4us_sansio.SpAccount,
  client: FhirClient,
) -> Result(List(r4us.Account), Err) {
  let req = r4us_sansio.account_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "ActivityDefinition", client)
}

pub fn activitydefinition_search_bundled(
  sp: r4us_sansio.SpActivitydefinition,
  client: FhirClient,
) {
  let req = r4us_sansio.activitydefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn activitydefinition_search(
  sp: r4us_sansio.SpActivitydefinition,
  client: FhirClient,
) -> Result(List(r4us.Activitydefinition), Err) {
  let req = r4us_sansio.activitydefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "AdverseEvent", client)
}

pub fn adverseevent_search_bundled(
  sp: r4us_sansio.SpAdverseevent,
  client: FhirClient,
) {
  let req = r4us_sansio.adverseevent_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn adverseevent_search(
  sp: r4us_sansio.SpAdverseevent,
  client: FhirClient,
) -> Result(List(r4us.Adverseevent), Err) {
  let req = r4us_sansio.adverseevent_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.adverseevent
  })
}

pub fn us_core_allergyintolerance_create(
  resource: r4us.UsCoreAllergyintolerance,
  client: FhirClient,
) -> Result(r4us.UsCoreAllergyintolerance, Err) {
  any_create(
    r4us.us_core_allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    r4us.us_core_allergyintolerance_decoder(),
    client,
  )
}

pub fn us_core_allergyintolerance_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreAllergyintolerance, Err) {
  any_read(
    id,
    client,
    "AllergyIntolerance",
    r4us.us_core_allergyintolerance_decoder(),
  )
}

pub fn us_core_allergyintolerance_update(
  resource: r4us.UsCoreAllergyintolerance,
  client: FhirClient,
) -> Result(r4us.UsCoreAllergyintolerance, Err) {
  any_update(
    resource.id,
    r4us.us_core_allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    r4us.us_core_allergyintolerance_decoder(),
    client,
  )
}

pub fn us_core_allergyintolerance_delete(
  resource: r4us.UsCoreAllergyintolerance,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "AllergyIntolerance", client)
}

pub fn us_core_allergyintolerance_search_bundled(
  sp: r4us_sansio.SpUsCoreAllergyintolerance,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_allergyintolerance_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_allergyintolerance_search(
  sp: r4us_sansio.SpUsCoreAllergyintolerance,
  client: FhirClient,
) -> Result(List(r4us.UsCoreAllergyintolerance), Err) {
  let req = r4us_sansio.us_core_allergyintolerance_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_allergyintolerance
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Appointment", client)
}

pub fn appointment_search_bundled(
  sp: r4us_sansio.SpAppointment,
  client: FhirClient,
) {
  let req = r4us_sansio.appointment_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn appointment_search(
  sp: r4us_sansio.SpAppointment,
  client: FhirClient,
) -> Result(List(r4us.Appointment), Err) {
  let req = r4us_sansio.appointment_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "AppointmentResponse", client)
}

pub fn appointmentresponse_search_bundled(
  sp: r4us_sansio.SpAppointmentresponse,
  client: FhirClient,
) {
  let req = r4us_sansio.appointmentresponse_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn appointmentresponse_search(
  sp: r4us_sansio.SpAppointmentresponse,
  client: FhirClient,
) -> Result(List(r4us.Appointmentresponse), Err) {
  let req = r4us_sansio.appointmentresponse_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "AuditEvent", client)
}

pub fn auditevent_search_bundled(
  sp: r4us_sansio.SpAuditevent,
  client: FhirClient,
) {
  let req = r4us_sansio.auditevent_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn auditevent_search(
  sp: r4us_sansio.SpAuditevent,
  client: FhirClient,
) -> Result(List(r4us.Auditevent), Err) {
  let req = r4us_sansio.auditevent_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Basic", client)
}

pub fn basic_search_bundled(sp: r4us_sansio.SpBasic, client: FhirClient) {
  let req = r4us_sansio.basic_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn basic_search(
  sp: r4us_sansio.SpBasic,
  client: FhirClient,
) -> Result(List(r4us.Basic), Err) {
  let req = r4us_sansio.basic_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Binary", client)
}

pub fn binary_search_bundled(sp: r4us_sansio.SpBinary, client: FhirClient) {
  let req = r4us_sansio.binary_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn binary_search(
  sp: r4us_sansio.SpBinary,
  client: FhirClient,
) -> Result(List(r4us.Binary), Err) {
  let req = r4us_sansio.binary_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "BiologicallyDerivedProduct", client)
}

pub fn biologicallyderivedproduct_search_bundled(
  sp: r4us_sansio.SpBiologicallyderivedproduct,
  client: FhirClient,
) {
  let req = r4us_sansio.biologicallyderivedproduct_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn biologicallyderivedproduct_search(
  sp: r4us_sansio.SpBiologicallyderivedproduct,
  client: FhirClient,
) -> Result(List(r4us.Biologicallyderivedproduct), Err) {
  let req = r4us_sansio.biologicallyderivedproduct_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "BodyStructure", client)
}

pub fn bodystructure_search_bundled(
  sp: r4us_sansio.SpBodystructure,
  client: FhirClient,
) {
  let req = r4us_sansio.bodystructure_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn bodystructure_search(
  sp: r4us_sansio.SpBodystructure,
  client: FhirClient,
) -> Result(List(r4us.Bodystructure), Err) {
  let req = r4us_sansio.bodystructure_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Bundle", client)
}

pub fn bundle_search_bundled(sp: r4us_sansio.SpBundle, client: FhirClient) {
  let req = r4us_sansio.bundle_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn bundle_search(
  sp: r4us_sansio.SpBundle,
  client: FhirClient,
) -> Result(List(r4us.Bundle), Err) {
  let req = r4us_sansio.bundle_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "CapabilityStatement", client)
}

pub fn capabilitystatement_search_bundled(
  sp: r4us_sansio.SpCapabilitystatement,
  client: FhirClient,
) {
  let req = r4us_sansio.capabilitystatement_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn capabilitystatement_search(
  sp: r4us_sansio.SpCapabilitystatement,
  client: FhirClient,
) -> Result(List(r4us.Capabilitystatement), Err) {
  let req = r4us_sansio.capabilitystatement_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.capabilitystatement
  })
}

pub fn us_core_careplan_create(
  resource: r4us.UsCoreCareplan,
  client: FhirClient,
) -> Result(r4us.UsCoreCareplan, Err) {
  any_create(
    r4us.us_core_careplan_to_json(resource),
    "CarePlan",
    r4us.us_core_careplan_decoder(),
    client,
  )
}

pub fn us_core_careplan_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreCareplan, Err) {
  any_read(id, client, "CarePlan", r4us.us_core_careplan_decoder())
}

pub fn us_core_careplan_update(
  resource: r4us.UsCoreCareplan,
  client: FhirClient,
) -> Result(r4us.UsCoreCareplan, Err) {
  any_update(
    resource.id,
    r4us.us_core_careplan_to_json(resource),
    "CarePlan",
    r4us.us_core_careplan_decoder(),
    client,
  )
}

pub fn us_core_careplan_delete(
  resource: r4us.UsCoreCareplan,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "CarePlan", client)
}

pub fn us_core_careplan_search_bundled(
  sp: r4us_sansio.SpUsCoreCareplan,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_careplan_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_careplan_search(
  sp: r4us_sansio.SpUsCoreCareplan,
  client: FhirClient,
) -> Result(List(r4us.UsCoreCareplan), Err) {
  let req = r4us_sansio.us_core_careplan_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_careplan
  })
}

pub fn us_core_careteam_create(
  resource: r4us.UsCoreCareteam,
  client: FhirClient,
) -> Result(r4us.UsCoreCareteam, Err) {
  any_create(
    r4us.us_core_careteam_to_json(resource),
    "CareTeam",
    r4us.us_core_careteam_decoder(),
    client,
  )
}

pub fn us_core_careteam_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreCareteam, Err) {
  any_read(id, client, "CareTeam", r4us.us_core_careteam_decoder())
}

pub fn us_core_careteam_update(
  resource: r4us.UsCoreCareteam,
  client: FhirClient,
) -> Result(r4us.UsCoreCareteam, Err) {
  any_update(
    resource.id,
    r4us.us_core_careteam_to_json(resource),
    "CareTeam",
    r4us.us_core_careteam_decoder(),
    client,
  )
}

pub fn us_core_careteam_delete(
  resource: r4us.UsCoreCareteam,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "CareTeam", client)
}

pub fn us_core_careteam_search_bundled(
  sp: r4us_sansio.SpUsCoreCareteam,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_careteam_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_careteam_search(
  sp: r4us_sansio.SpUsCoreCareteam,
  client: FhirClient,
) -> Result(List(r4us.UsCoreCareteam), Err) {
  let req = r4us_sansio.us_core_careteam_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_careteam
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "CatalogEntry", client)
}

pub fn catalogentry_search_bundled(
  sp: r4us_sansio.SpCatalogentry,
  client: FhirClient,
) {
  let req = r4us_sansio.catalogentry_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn catalogentry_search(
  sp: r4us_sansio.SpCatalogentry,
  client: FhirClient,
) -> Result(List(r4us.Catalogentry), Err) {
  let req = r4us_sansio.catalogentry_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "ChargeItem", client)
}

pub fn chargeitem_search_bundled(
  sp: r4us_sansio.SpChargeitem,
  client: FhirClient,
) {
  let req = r4us_sansio.chargeitem_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn chargeitem_search(
  sp: r4us_sansio.SpChargeitem,
  client: FhirClient,
) -> Result(List(r4us.Chargeitem), Err) {
  let req = r4us_sansio.chargeitem_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "ChargeItemDefinition", client)
}

pub fn chargeitemdefinition_search_bundled(
  sp: r4us_sansio.SpChargeitemdefinition,
  client: FhirClient,
) {
  let req = r4us_sansio.chargeitemdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn chargeitemdefinition_search(
  sp: r4us_sansio.SpChargeitemdefinition,
  client: FhirClient,
) -> Result(List(r4us.Chargeitemdefinition), Err) {
  let req = r4us_sansio.chargeitemdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Claim", client)
}

pub fn claim_search_bundled(sp: r4us_sansio.SpClaim, client: FhirClient) {
  let req = r4us_sansio.claim_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn claim_search(
  sp: r4us_sansio.SpClaim,
  client: FhirClient,
) -> Result(List(r4us.Claim), Err) {
  let req = r4us_sansio.claim_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "ClaimResponse", client)
}

pub fn claimresponse_search_bundled(
  sp: r4us_sansio.SpClaimresponse,
  client: FhirClient,
) {
  let req = r4us_sansio.claimresponse_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn claimresponse_search(
  sp: r4us_sansio.SpClaimresponse,
  client: FhirClient,
) -> Result(List(r4us.Claimresponse), Err) {
  let req = r4us_sansio.claimresponse_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "ClinicalImpression", client)
}

pub fn clinicalimpression_search_bundled(
  sp: r4us_sansio.SpClinicalimpression,
  client: FhirClient,
) {
  let req = r4us_sansio.clinicalimpression_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn clinicalimpression_search(
  sp: r4us_sansio.SpClinicalimpression,
  client: FhirClient,
) -> Result(List(r4us.Clinicalimpression), Err) {
  let req = r4us_sansio.clinicalimpression_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "CodeSystem", client)
}

pub fn codesystem_search_bundled(
  sp: r4us_sansio.SpCodesystem,
  client: FhirClient,
) {
  let req = r4us_sansio.codesystem_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn codesystem_search(
  sp: r4us_sansio.SpCodesystem,
  client: FhirClient,
) -> Result(List(r4us.Codesystem), Err) {
  let req = r4us_sansio.codesystem_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Communication", client)
}

pub fn communication_search_bundled(
  sp: r4us_sansio.SpCommunication,
  client: FhirClient,
) {
  let req = r4us_sansio.communication_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn communication_search(
  sp: r4us_sansio.SpCommunication,
  client: FhirClient,
) -> Result(List(r4us.Communication), Err) {
  let req = r4us_sansio.communication_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "CommunicationRequest", client)
}

pub fn communicationrequest_search_bundled(
  sp: r4us_sansio.SpCommunicationrequest,
  client: FhirClient,
) {
  let req = r4us_sansio.communicationrequest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn communicationrequest_search(
  sp: r4us_sansio.SpCommunicationrequest,
  client: FhirClient,
) -> Result(List(r4us.Communicationrequest), Err) {
  let req = r4us_sansio.communicationrequest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "CompartmentDefinition", client)
}

pub fn compartmentdefinition_search_bundled(
  sp: r4us_sansio.SpCompartmentdefinition,
  client: FhirClient,
) {
  let req = r4us_sansio.compartmentdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn compartmentdefinition_search(
  sp: r4us_sansio.SpCompartmentdefinition,
  client: FhirClient,
) -> Result(List(r4us.Compartmentdefinition), Err) {
  let req = r4us_sansio.compartmentdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Composition", client)
}

pub fn composition_search_bundled(
  sp: r4us_sansio.SpComposition,
  client: FhirClient,
) {
  let req = r4us_sansio.composition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn composition_search(
  sp: r4us_sansio.SpComposition,
  client: FhirClient,
) -> Result(List(r4us.Composition), Err) {
  let req = r4us_sansio.composition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "ConceptMap", client)
}

pub fn conceptmap_search_bundled(
  sp: r4us_sansio.SpConceptmap,
  client: FhirClient,
) {
  let req = r4us_sansio.conceptmap_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn conceptmap_search(
  sp: r4us_sansio.SpConceptmap,
  client: FhirClient,
) -> Result(List(r4us.Conceptmap), Err) {
  let req = r4us_sansio.conceptmap_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.conceptmap
  })
}

pub fn us_core_condition_encounter_diagnosis_create(
  resource: r4us.UsCoreConditionEncounterDiagnosis,
  client: FhirClient,
) -> Result(r4us.UsCoreConditionEncounterDiagnosis, Err) {
  any_create(
    r4us.us_core_condition_encounter_diagnosis_to_json(resource),
    "Condition",
    r4us.us_core_condition_encounter_diagnosis_decoder(),
    client,
  )
}

pub fn us_core_condition_encounter_diagnosis_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreConditionEncounterDiagnosis, Err) {
  any_read(
    id,
    client,
    "Condition",
    r4us.us_core_condition_encounter_diagnosis_decoder(),
  )
}

pub fn us_core_condition_encounter_diagnosis_update(
  resource: r4us.UsCoreConditionEncounterDiagnosis,
  client: FhirClient,
) -> Result(r4us.UsCoreConditionEncounterDiagnosis, Err) {
  any_update(
    resource.id,
    r4us.us_core_condition_encounter_diagnosis_to_json(resource),
    "Condition",
    r4us.us_core_condition_encounter_diagnosis_decoder(),
    client,
  )
}

pub fn us_core_condition_encounter_diagnosis_delete(
  resource: r4us.UsCoreConditionEncounterDiagnosis,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Condition", client)
}

pub fn us_core_condition_encounter_diagnosis_search_bundled(
  sp: r4us_sansio.SpUsCoreConditionEncounterDiagnosis,
  client: FhirClient,
) {
  let req =
    r4us_sansio.us_core_condition_encounter_diagnosis_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_condition_encounter_diagnosis_search(
  sp: r4us_sansio.SpUsCoreConditionEncounterDiagnosis,
  client: FhirClient,
) -> Result(List(r4us.UsCoreConditionEncounterDiagnosis), Err) {
  let req =
    r4us_sansio.us_core_condition_encounter_diagnosis_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_condition_encounter_diagnosis
  })
}

pub fn us_core_condition_problems_health_concerns_create(
  resource: r4us.UsCoreConditionProblemsHealthConcerns,
  client: FhirClient,
) -> Result(r4us.UsCoreConditionProblemsHealthConcerns, Err) {
  any_create(
    r4us.us_core_condition_problems_health_concerns_to_json(resource),
    "Condition",
    r4us.us_core_condition_problems_health_concerns_decoder(),
    client,
  )
}

pub fn us_core_condition_problems_health_concerns_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreConditionProblemsHealthConcerns, Err) {
  any_read(
    id,
    client,
    "Condition",
    r4us.us_core_condition_problems_health_concerns_decoder(),
  )
}

pub fn us_core_condition_problems_health_concerns_update(
  resource: r4us.UsCoreConditionProblemsHealthConcerns,
  client: FhirClient,
) -> Result(r4us.UsCoreConditionProblemsHealthConcerns, Err) {
  any_update(
    resource.id,
    r4us.us_core_condition_problems_health_concerns_to_json(resource),
    "Condition",
    r4us.us_core_condition_problems_health_concerns_decoder(),
    client,
  )
}

pub fn us_core_condition_problems_health_concerns_delete(
  resource: r4us.UsCoreConditionProblemsHealthConcerns,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Condition", client)
}

pub fn us_core_condition_problems_health_concerns_search_bundled(
  sp: r4us_sansio.SpUsCoreConditionProblemsHealthConcerns,
  client: FhirClient,
) {
  let req =
    r4us_sansio.us_core_condition_problems_health_concerns_search_req(
      sp,
      client,
    )
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_condition_problems_health_concerns_search(
  sp: r4us_sansio.SpUsCoreConditionProblemsHealthConcerns,
  client: FhirClient,
) -> Result(List(r4us.UsCoreConditionProblemsHealthConcerns), Err) {
  let req =
    r4us_sansio.us_core_condition_problems_health_concerns_search_req(
      sp,
      client,
    )
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_condition_problems_health_concerns
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Consent", client)
}

pub fn consent_search_bundled(sp: r4us_sansio.SpConsent, client: FhirClient) {
  let req = r4us_sansio.consent_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn consent_search(
  sp: r4us_sansio.SpConsent,
  client: FhirClient,
) -> Result(List(r4us.Consent), Err) {
  let req = r4us_sansio.consent_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Contract", client)
}

pub fn contract_search_bundled(sp: r4us_sansio.SpContract, client: FhirClient) {
  let req = r4us_sansio.contract_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn contract_search(
  sp: r4us_sansio.SpContract,
  client: FhirClient,
) -> Result(List(r4us.Contract), Err) {
  let req = r4us_sansio.contract_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.contract
  })
}

pub fn us_core_coverage_create(
  resource: r4us.UsCoreCoverage,
  client: FhirClient,
) -> Result(r4us.UsCoreCoverage, Err) {
  any_create(
    r4us.us_core_coverage_to_json(resource),
    "Coverage",
    r4us.us_core_coverage_decoder(),
    client,
  )
}

pub fn us_core_coverage_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreCoverage, Err) {
  any_read(id, client, "Coverage", r4us.us_core_coverage_decoder())
}

pub fn us_core_coverage_update(
  resource: r4us.UsCoreCoverage,
  client: FhirClient,
) -> Result(r4us.UsCoreCoverage, Err) {
  any_update(
    resource.id,
    r4us.us_core_coverage_to_json(resource),
    "Coverage",
    r4us.us_core_coverage_decoder(),
    client,
  )
}

pub fn us_core_coverage_delete(
  resource: r4us.UsCoreCoverage,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Coverage", client)
}

pub fn us_core_coverage_search_bundled(
  sp: r4us_sansio.SpUsCoreCoverage,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_coverage_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_coverage_search(
  sp: r4us_sansio.SpUsCoreCoverage,
  client: FhirClient,
) -> Result(List(r4us.UsCoreCoverage), Err) {
  let req = r4us_sansio.us_core_coverage_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_coverage
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "CoverageEligibilityRequest", client)
}

pub fn coverageeligibilityrequest_search_bundled(
  sp: r4us_sansio.SpCoverageeligibilityrequest,
  client: FhirClient,
) {
  let req = r4us_sansio.coverageeligibilityrequest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn coverageeligibilityrequest_search(
  sp: r4us_sansio.SpCoverageeligibilityrequest,
  client: FhirClient,
) -> Result(List(r4us.Coverageeligibilityrequest), Err) {
  let req = r4us_sansio.coverageeligibilityrequest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "CoverageEligibilityResponse", client)
}

pub fn coverageeligibilityresponse_search_bundled(
  sp: r4us_sansio.SpCoverageeligibilityresponse,
  client: FhirClient,
) {
  let req = r4us_sansio.coverageeligibilityresponse_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn coverageeligibilityresponse_search(
  sp: r4us_sansio.SpCoverageeligibilityresponse,
  client: FhirClient,
) -> Result(List(r4us.Coverageeligibilityresponse), Err) {
  let req = r4us_sansio.coverageeligibilityresponse_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "DetectedIssue", client)
}

pub fn detectedissue_search_bundled(
  sp: r4us_sansio.SpDetectedissue,
  client: FhirClient,
) {
  let req = r4us_sansio.detectedissue_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn detectedissue_search(
  sp: r4us_sansio.SpDetectedissue,
  client: FhirClient,
) -> Result(List(r4us.Detectedissue), Err) {
  let req = r4us_sansio.detectedissue_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.detectedissue
  })
}

pub fn us_core_device_create(
  resource: r4us.UsCoreDevice,
  client: FhirClient,
) -> Result(r4us.UsCoreDevice, Err) {
  any_create(
    r4us.us_core_device_to_json(resource),
    "Device",
    r4us.us_core_device_decoder(),
    client,
  )
}

pub fn us_core_device_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreDevice, Err) {
  any_read(id, client, "Device", r4us.us_core_device_decoder())
}

pub fn us_core_device_update(
  resource: r4us.UsCoreDevice,
  client: FhirClient,
) -> Result(r4us.UsCoreDevice, Err) {
  any_update(
    resource.id,
    r4us.us_core_device_to_json(resource),
    "Device",
    r4us.us_core_device_decoder(),
    client,
  )
}

pub fn us_core_device_delete(
  resource: r4us.UsCoreDevice,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Device", client)
}

pub fn us_core_device_search_bundled(
  sp: r4us_sansio.SpUsCoreDevice,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_device_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_device_search(
  sp: r4us_sansio.SpUsCoreDevice,
  client: FhirClient,
) -> Result(List(r4us.UsCoreDevice), Err) {
  let req = r4us_sansio.us_core_device_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_device
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "DeviceDefinition", client)
}

pub fn devicedefinition_search_bundled(
  sp: r4us_sansio.SpDevicedefinition,
  client: FhirClient,
) {
  let req = r4us_sansio.devicedefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn devicedefinition_search(
  sp: r4us_sansio.SpDevicedefinition,
  client: FhirClient,
) -> Result(List(r4us.Devicedefinition), Err) {
  let req = r4us_sansio.devicedefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "DeviceMetric", client)
}

pub fn devicemetric_search_bundled(
  sp: r4us_sansio.SpDevicemetric,
  client: FhirClient,
) {
  let req = r4us_sansio.devicemetric_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn devicemetric_search(
  sp: r4us_sansio.SpDevicemetric,
  client: FhirClient,
) -> Result(List(r4us.Devicemetric), Err) {
  let req = r4us_sansio.devicemetric_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "DeviceRequest", client)
}

pub fn devicerequest_search_bundled(
  sp: r4us_sansio.SpDevicerequest,
  client: FhirClient,
) {
  let req = r4us_sansio.devicerequest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn devicerequest_search(
  sp: r4us_sansio.SpDevicerequest,
  client: FhirClient,
) -> Result(List(r4us.Devicerequest), Err) {
  let req = r4us_sansio.devicerequest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "DeviceUseStatement", client)
}

pub fn deviceusestatement_search_bundled(
  sp: r4us_sansio.SpDeviceusestatement,
  client: FhirClient,
) {
  let req = r4us_sansio.deviceusestatement_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn deviceusestatement_search(
  sp: r4us_sansio.SpDeviceusestatement,
  client: FhirClient,
) -> Result(List(r4us.Deviceusestatement), Err) {
  let req = r4us_sansio.deviceusestatement_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.deviceusestatement
  })
}

pub fn us_core_diagnosticreport_lab_create(
  resource: r4us.UsCoreDiagnosticreportLab,
  client: FhirClient,
) -> Result(r4us.UsCoreDiagnosticreportLab, Err) {
  any_create(
    r4us.us_core_diagnosticreport_lab_to_json(resource),
    "DiagnosticReport",
    r4us.us_core_diagnosticreport_lab_decoder(),
    client,
  )
}

pub fn us_core_diagnosticreport_lab_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreDiagnosticreportLab, Err) {
  any_read(
    id,
    client,
    "DiagnosticReport",
    r4us.us_core_diagnosticreport_lab_decoder(),
  )
}

pub fn us_core_diagnosticreport_lab_update(
  resource: r4us.UsCoreDiagnosticreportLab,
  client: FhirClient,
) -> Result(r4us.UsCoreDiagnosticreportLab, Err) {
  any_update(
    resource.id,
    r4us.us_core_diagnosticreport_lab_to_json(resource),
    "DiagnosticReport",
    r4us.us_core_diagnosticreport_lab_decoder(),
    client,
  )
}

pub fn us_core_diagnosticreport_lab_delete(
  resource: r4us.UsCoreDiagnosticreportLab,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "DiagnosticReport", client)
}

pub fn us_core_diagnosticreport_lab_search_bundled(
  sp: r4us_sansio.SpUsCoreDiagnosticreportLab,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_diagnosticreport_lab_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_diagnosticreport_lab_search(
  sp: r4us_sansio.SpUsCoreDiagnosticreportLab,
  client: FhirClient,
) -> Result(List(r4us.UsCoreDiagnosticreportLab), Err) {
  let req = r4us_sansio.us_core_diagnosticreport_lab_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_diagnosticreport_lab
  })
}

pub fn us_core_diagnosticreport_note_create(
  resource: r4us.UsCoreDiagnosticreportNote,
  client: FhirClient,
) -> Result(r4us.UsCoreDiagnosticreportNote, Err) {
  any_create(
    r4us.us_core_diagnosticreport_note_to_json(resource),
    "DiagnosticReport",
    r4us.us_core_diagnosticreport_note_decoder(),
    client,
  )
}

pub fn us_core_diagnosticreport_note_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreDiagnosticreportNote, Err) {
  any_read(
    id,
    client,
    "DiagnosticReport",
    r4us.us_core_diagnosticreport_note_decoder(),
  )
}

pub fn us_core_diagnosticreport_note_update(
  resource: r4us.UsCoreDiagnosticreportNote,
  client: FhirClient,
) -> Result(r4us.UsCoreDiagnosticreportNote, Err) {
  any_update(
    resource.id,
    r4us.us_core_diagnosticreport_note_to_json(resource),
    "DiagnosticReport",
    r4us.us_core_diagnosticreport_note_decoder(),
    client,
  )
}

pub fn us_core_diagnosticreport_note_delete(
  resource: r4us.UsCoreDiagnosticreportNote,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "DiagnosticReport", client)
}

pub fn us_core_diagnosticreport_note_search_bundled(
  sp: r4us_sansio.SpUsCoreDiagnosticreportNote,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_diagnosticreport_note_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_diagnosticreport_note_search(
  sp: r4us_sansio.SpUsCoreDiagnosticreportNote,
  client: FhirClient,
) -> Result(List(r4us.UsCoreDiagnosticreportNote), Err) {
  let req = r4us_sansio.us_core_diagnosticreport_note_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_diagnosticreport_note
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "DocumentManifest", client)
}

pub fn documentmanifest_search_bundled(
  sp: r4us_sansio.SpDocumentmanifest,
  client: FhirClient,
) {
  let req = r4us_sansio.documentmanifest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn documentmanifest_search(
  sp: r4us_sansio.SpDocumentmanifest,
  client: FhirClient,
) -> Result(List(r4us.Documentmanifest), Err) {
  let req = r4us_sansio.documentmanifest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.documentmanifest
  })
}

pub fn us_core_documentreference_create(
  resource: r4us.UsCoreDocumentreference,
  client: FhirClient,
) -> Result(r4us.UsCoreDocumentreference, Err) {
  any_create(
    r4us.us_core_documentreference_to_json(resource),
    "DocumentReference",
    r4us.us_core_documentreference_decoder(),
    client,
  )
}

pub fn us_core_documentreference_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreDocumentreference, Err) {
  any_read(
    id,
    client,
    "DocumentReference",
    r4us.us_core_documentreference_decoder(),
  )
}

pub fn us_core_documentreference_update(
  resource: r4us.UsCoreDocumentreference,
  client: FhirClient,
) -> Result(r4us.UsCoreDocumentreference, Err) {
  any_update(
    resource.id,
    r4us.us_core_documentreference_to_json(resource),
    "DocumentReference",
    r4us.us_core_documentreference_decoder(),
    client,
  )
}

pub fn us_core_documentreference_delete(
  resource: r4us.UsCoreDocumentreference,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "DocumentReference", client)
}

pub fn us_core_documentreference_search_bundled(
  sp: r4us_sansio.SpUsCoreDocumentreference,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_documentreference_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_documentreference_search(
  sp: r4us_sansio.SpUsCoreDocumentreference,
  client: FhirClient,
) -> Result(List(r4us.UsCoreDocumentreference), Err) {
  let req = r4us_sansio.us_core_documentreference_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_documentreference
  })
}

pub fn us_core_adi_documentreference_create(
  resource: r4us.UsCoreAdiDocumentreference,
  client: FhirClient,
) -> Result(r4us.UsCoreAdiDocumentreference, Err) {
  any_create(
    r4us.us_core_adi_documentreference_to_json(resource),
    "DocumentReference",
    r4us.us_core_adi_documentreference_decoder(),
    client,
  )
}

pub fn us_core_adi_documentreference_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreAdiDocumentreference, Err) {
  any_read(
    id,
    client,
    "DocumentReference",
    r4us.us_core_adi_documentreference_decoder(),
  )
}

pub fn us_core_adi_documentreference_update(
  resource: r4us.UsCoreAdiDocumentreference,
  client: FhirClient,
) -> Result(r4us.UsCoreAdiDocumentreference, Err) {
  any_update(
    resource.id,
    r4us.us_core_adi_documentreference_to_json(resource),
    "DocumentReference",
    r4us.us_core_adi_documentreference_decoder(),
    client,
  )
}

pub fn us_core_adi_documentreference_delete(
  resource: r4us.UsCoreAdiDocumentreference,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "DocumentReference", client)
}

pub fn us_core_adi_documentreference_search_bundled(
  sp: r4us_sansio.SpUsCoreAdiDocumentreference,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_adi_documentreference_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_adi_documentreference_search(
  sp: r4us_sansio.SpUsCoreAdiDocumentreference,
  client: FhirClient,
) -> Result(List(r4us.UsCoreAdiDocumentreference), Err) {
  let req = r4us_sansio.us_core_adi_documentreference_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_adi_documentreference
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "EffectEvidenceSynthesis", client)
}

pub fn effectevidencesynthesis_search_bundled(
  sp: r4us_sansio.SpEffectevidencesynthesis,
  client: FhirClient,
) {
  let req = r4us_sansio.effectevidencesynthesis_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn effectevidencesynthesis_search(
  sp: r4us_sansio.SpEffectevidencesynthesis,
  client: FhirClient,
) -> Result(List(r4us.Effectevidencesynthesis), Err) {
  let req = r4us_sansio.effectevidencesynthesis_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.effectevidencesynthesis
  })
}

pub fn us_core_encounter_create(
  resource: r4us.UsCoreEncounter,
  client: FhirClient,
) -> Result(r4us.UsCoreEncounter, Err) {
  any_create(
    r4us.us_core_encounter_to_json(resource),
    "Encounter",
    r4us.us_core_encounter_decoder(),
    client,
  )
}

pub fn us_core_encounter_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreEncounter, Err) {
  any_read(id, client, "Encounter", r4us.us_core_encounter_decoder())
}

pub fn us_core_encounter_update(
  resource: r4us.UsCoreEncounter,
  client: FhirClient,
) -> Result(r4us.UsCoreEncounter, Err) {
  any_update(
    resource.id,
    r4us.us_core_encounter_to_json(resource),
    "Encounter",
    r4us.us_core_encounter_decoder(),
    client,
  )
}

pub fn us_core_encounter_delete(
  resource: r4us.UsCoreEncounter,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Encounter", client)
}

pub fn us_core_encounter_search_bundled(
  sp: r4us_sansio.SpUsCoreEncounter,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_encounter_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_encounter_search(
  sp: r4us_sansio.SpUsCoreEncounter,
  client: FhirClient,
) -> Result(List(r4us.UsCoreEncounter), Err) {
  let req = r4us_sansio.us_core_encounter_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_encounter
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Endpoint", client)
}

pub fn endpoint_search_bundled(sp: r4us_sansio.SpEndpoint, client: FhirClient) {
  let req = r4us_sansio.endpoint_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn endpoint_search(
  sp: r4us_sansio.SpEndpoint,
  client: FhirClient,
) -> Result(List(r4us.Endpoint), Err) {
  let req = r4us_sansio.endpoint_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "EnrollmentRequest", client)
}

pub fn enrollmentrequest_search_bundled(
  sp: r4us_sansio.SpEnrollmentrequest,
  client: FhirClient,
) {
  let req = r4us_sansio.enrollmentrequest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn enrollmentrequest_search(
  sp: r4us_sansio.SpEnrollmentrequest,
  client: FhirClient,
) -> Result(List(r4us.Enrollmentrequest), Err) {
  let req = r4us_sansio.enrollmentrequest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "EnrollmentResponse", client)
}

pub fn enrollmentresponse_search_bundled(
  sp: r4us_sansio.SpEnrollmentresponse,
  client: FhirClient,
) {
  let req = r4us_sansio.enrollmentresponse_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn enrollmentresponse_search(
  sp: r4us_sansio.SpEnrollmentresponse,
  client: FhirClient,
) -> Result(List(r4us.Enrollmentresponse), Err) {
  let req = r4us_sansio.enrollmentresponse_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "EpisodeOfCare", client)
}

pub fn episodeofcare_search_bundled(
  sp: r4us_sansio.SpEpisodeofcare,
  client: FhirClient,
) {
  let req = r4us_sansio.episodeofcare_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn episodeofcare_search(
  sp: r4us_sansio.SpEpisodeofcare,
  client: FhirClient,
) -> Result(List(r4us.Episodeofcare), Err) {
  let req = r4us_sansio.episodeofcare_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "EventDefinition", client)
}

pub fn eventdefinition_search_bundled(
  sp: r4us_sansio.SpEventdefinition,
  client: FhirClient,
) {
  let req = r4us_sansio.eventdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn eventdefinition_search(
  sp: r4us_sansio.SpEventdefinition,
  client: FhirClient,
) -> Result(List(r4us.Eventdefinition), Err) {
  let req = r4us_sansio.eventdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Evidence", client)
}

pub fn evidence_search_bundled(sp: r4us_sansio.SpEvidence, client: FhirClient) {
  let req = r4us_sansio.evidence_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn evidence_search(
  sp: r4us_sansio.SpEvidence,
  client: FhirClient,
) -> Result(List(r4us.Evidence), Err) {
  let req = r4us_sansio.evidence_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "EvidenceVariable", client)
}

pub fn evidencevariable_search_bundled(
  sp: r4us_sansio.SpEvidencevariable,
  client: FhirClient,
) {
  let req = r4us_sansio.evidencevariable_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn evidencevariable_search(
  sp: r4us_sansio.SpEvidencevariable,
  client: FhirClient,
) -> Result(List(r4us.Evidencevariable), Err) {
  let req = r4us_sansio.evidencevariable_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "ExampleScenario", client)
}

pub fn examplescenario_search_bundled(
  sp: r4us_sansio.SpExamplescenario,
  client: FhirClient,
) {
  let req = r4us_sansio.examplescenario_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn examplescenario_search(
  sp: r4us_sansio.SpExamplescenario,
  client: FhirClient,
) -> Result(List(r4us.Examplescenario), Err) {
  let req = r4us_sansio.examplescenario_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "ExplanationOfBenefit", client)
}

pub fn explanationofbenefit_search_bundled(
  sp: r4us_sansio.SpExplanationofbenefit,
  client: FhirClient,
) {
  let req = r4us_sansio.explanationofbenefit_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn explanationofbenefit_search(
  sp: r4us_sansio.SpExplanationofbenefit,
  client: FhirClient,
) -> Result(List(r4us.Explanationofbenefit), Err) {
  let req = r4us_sansio.explanationofbenefit_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.explanationofbenefit
  })
}

pub fn us_core_familymemberhistory_create(
  resource: r4us.UsCoreFamilymemberhistory,
  client: FhirClient,
) -> Result(r4us.UsCoreFamilymemberhistory, Err) {
  any_create(
    r4us.us_core_familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    r4us.us_core_familymemberhistory_decoder(),
    client,
  )
}

pub fn us_core_familymemberhistory_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreFamilymemberhistory, Err) {
  any_read(
    id,
    client,
    "FamilyMemberHistory",
    r4us.us_core_familymemberhistory_decoder(),
  )
}

pub fn us_core_familymemberhistory_update(
  resource: r4us.UsCoreFamilymemberhistory,
  client: FhirClient,
) -> Result(r4us.UsCoreFamilymemberhistory, Err) {
  any_update(
    resource.id,
    r4us.us_core_familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    r4us.us_core_familymemberhistory_decoder(),
    client,
  )
}

pub fn us_core_familymemberhistory_delete(
  resource: r4us.UsCoreFamilymemberhistory,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "FamilyMemberHistory", client)
}

pub fn us_core_familymemberhistory_search_bundled(
  sp: r4us_sansio.SpUsCoreFamilymemberhistory,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_familymemberhistory_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_familymemberhistory_search(
  sp: r4us_sansio.SpUsCoreFamilymemberhistory,
  client: FhirClient,
) -> Result(List(r4us.UsCoreFamilymemberhistory), Err) {
  let req = r4us_sansio.us_core_familymemberhistory_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_familymemberhistory
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Flag", client)
}

pub fn flag_search_bundled(sp: r4us_sansio.SpFlag, client: FhirClient) {
  let req = r4us_sansio.flag_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn flag_search(
  sp: r4us_sansio.SpFlag,
  client: FhirClient,
) -> Result(List(r4us.Flag), Err) {
  let req = r4us_sansio.flag_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.flag
  })
}

pub fn us_core_goal_create(
  resource: r4us.UsCoreGoal,
  client: FhirClient,
) -> Result(r4us.UsCoreGoal, Err) {
  any_create(
    r4us.us_core_goal_to_json(resource),
    "Goal",
    r4us.us_core_goal_decoder(),
    client,
  )
}

pub fn us_core_goal_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreGoal, Err) {
  any_read(id, client, "Goal", r4us.us_core_goal_decoder())
}

pub fn us_core_goal_update(
  resource: r4us.UsCoreGoal,
  client: FhirClient,
) -> Result(r4us.UsCoreGoal, Err) {
  any_update(
    resource.id,
    r4us.us_core_goal_to_json(resource),
    "Goal",
    r4us.us_core_goal_decoder(),
    client,
  )
}

pub fn us_core_goal_delete(
  resource: r4us.UsCoreGoal,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Goal", client)
}

pub fn us_core_goal_search_bundled(
  sp: r4us_sansio.SpUsCoreGoal,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_goal_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_goal_search(
  sp: r4us_sansio.SpUsCoreGoal,
  client: FhirClient,
) -> Result(List(r4us.UsCoreGoal), Err) {
  let req = r4us_sansio.us_core_goal_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_goal
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "GraphDefinition", client)
}

pub fn graphdefinition_search_bundled(
  sp: r4us_sansio.SpGraphdefinition,
  client: FhirClient,
) {
  let req = r4us_sansio.graphdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn graphdefinition_search(
  sp: r4us_sansio.SpGraphdefinition,
  client: FhirClient,
) -> Result(List(r4us.Graphdefinition), Err) {
  let req = r4us_sansio.graphdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Group", client)
}

pub fn group_search_bundled(sp: r4us_sansio.SpGroup, client: FhirClient) {
  let req = r4us_sansio.group_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn group_search(
  sp: r4us_sansio.SpGroup,
  client: FhirClient,
) -> Result(List(r4us.Group), Err) {
  let req = r4us_sansio.group_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "GuidanceResponse", client)
}

pub fn guidanceresponse_search_bundled(
  sp: r4us_sansio.SpGuidanceresponse,
  client: FhirClient,
) {
  let req = r4us_sansio.guidanceresponse_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn guidanceresponse_search(
  sp: r4us_sansio.SpGuidanceresponse,
  client: FhirClient,
) -> Result(List(r4us.Guidanceresponse), Err) {
  let req = r4us_sansio.guidanceresponse_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "HealthcareService", client)
}

pub fn healthcareservice_search_bundled(
  sp: r4us_sansio.SpHealthcareservice,
  client: FhirClient,
) {
  let req = r4us_sansio.healthcareservice_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn healthcareservice_search(
  sp: r4us_sansio.SpHealthcareservice,
  client: FhirClient,
) -> Result(List(r4us.Healthcareservice), Err) {
  let req = r4us_sansio.healthcareservice_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "ImagingStudy", client)
}

pub fn imagingstudy_search_bundled(
  sp: r4us_sansio.SpImagingstudy,
  client: FhirClient,
) {
  let req = r4us_sansio.imagingstudy_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn imagingstudy_search(
  sp: r4us_sansio.SpImagingstudy,
  client: FhirClient,
) -> Result(List(r4us.Imagingstudy), Err) {
  let req = r4us_sansio.imagingstudy_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.imagingstudy
  })
}

pub fn us_core_immunization_create(
  resource: r4us.UsCoreImmunization,
  client: FhirClient,
) -> Result(r4us.UsCoreImmunization, Err) {
  any_create(
    r4us.us_core_immunization_to_json(resource),
    "Immunization",
    r4us.us_core_immunization_decoder(),
    client,
  )
}

pub fn us_core_immunization_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreImmunization, Err) {
  any_read(id, client, "Immunization", r4us.us_core_immunization_decoder())
}

pub fn us_core_immunization_update(
  resource: r4us.UsCoreImmunization,
  client: FhirClient,
) -> Result(r4us.UsCoreImmunization, Err) {
  any_update(
    resource.id,
    r4us.us_core_immunization_to_json(resource),
    "Immunization",
    r4us.us_core_immunization_decoder(),
    client,
  )
}

pub fn us_core_immunization_delete(
  resource: r4us.UsCoreImmunization,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Immunization", client)
}

pub fn us_core_immunization_search_bundled(
  sp: r4us_sansio.SpUsCoreImmunization,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_immunization_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_immunization_search(
  sp: r4us_sansio.SpUsCoreImmunization,
  client: FhirClient,
) -> Result(List(r4us.UsCoreImmunization), Err) {
  let req = r4us_sansio.us_core_immunization_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_immunization
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "ImmunizationEvaluation", client)
}

pub fn immunizationevaluation_search_bundled(
  sp: r4us_sansio.SpImmunizationevaluation,
  client: FhirClient,
) {
  let req = r4us_sansio.immunizationevaluation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn immunizationevaluation_search(
  sp: r4us_sansio.SpImmunizationevaluation,
  client: FhirClient,
) -> Result(List(r4us.Immunizationevaluation), Err) {
  let req = r4us_sansio.immunizationevaluation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "ImmunizationRecommendation", client)
}

pub fn immunizationrecommendation_search_bundled(
  sp: r4us_sansio.SpImmunizationrecommendation,
  client: FhirClient,
) {
  let req = r4us_sansio.immunizationrecommendation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn immunizationrecommendation_search(
  sp: r4us_sansio.SpImmunizationrecommendation,
  client: FhirClient,
) -> Result(List(r4us.Immunizationrecommendation), Err) {
  let req = r4us_sansio.immunizationrecommendation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "ImplementationGuide", client)
}

pub fn implementationguide_search_bundled(
  sp: r4us_sansio.SpImplementationguide,
  client: FhirClient,
) {
  let req = r4us_sansio.implementationguide_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn implementationguide_search(
  sp: r4us_sansio.SpImplementationguide,
  client: FhirClient,
) -> Result(List(r4us.Implementationguide), Err) {
  let req = r4us_sansio.implementationguide_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "InsurancePlan", client)
}

pub fn insuranceplan_search_bundled(
  sp: r4us_sansio.SpInsuranceplan,
  client: FhirClient,
) {
  let req = r4us_sansio.insuranceplan_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn insuranceplan_search(
  sp: r4us_sansio.SpInsuranceplan,
  client: FhirClient,
) -> Result(List(r4us.Insuranceplan), Err) {
  let req = r4us_sansio.insuranceplan_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Invoice", client)
}

pub fn invoice_search_bundled(sp: r4us_sansio.SpInvoice, client: FhirClient) {
  let req = r4us_sansio.invoice_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn invoice_search(
  sp: r4us_sansio.SpInvoice,
  client: FhirClient,
) -> Result(List(r4us.Invoice), Err) {
  let req = r4us_sansio.invoice_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Library", client)
}

pub fn library_search_bundled(sp: r4us_sansio.SpLibrary, client: FhirClient) {
  let req = r4us_sansio.library_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn library_search(
  sp: r4us_sansio.SpLibrary,
  client: FhirClient,
) -> Result(List(r4us.Library), Err) {
  let req = r4us_sansio.library_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Linkage", client)
}

pub fn linkage_search_bundled(sp: r4us_sansio.SpLinkage, client: FhirClient) {
  let req = r4us_sansio.linkage_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn linkage_search(
  sp: r4us_sansio.SpLinkage,
  client: FhirClient,
) -> Result(List(r4us.Linkage), Err) {
  let req = r4us_sansio.linkage_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "List", client)
}

pub fn listfhir_search_bundled(sp: r4us_sansio.SpListfhir, client: FhirClient) {
  let req = r4us_sansio.listfhir_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn listfhir_search(
  sp: r4us_sansio.SpListfhir,
  client: FhirClient,
) -> Result(List(r4us.Listfhir), Err) {
  let req = r4us_sansio.listfhir_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.listfhir
  })
}

pub fn us_core_location_create(
  resource: r4us.UsCoreLocation,
  client: FhirClient,
) -> Result(r4us.UsCoreLocation, Err) {
  any_create(
    r4us.us_core_location_to_json(resource),
    "Location",
    r4us.us_core_location_decoder(),
    client,
  )
}

pub fn us_core_location_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreLocation, Err) {
  any_read(id, client, "Location", r4us.us_core_location_decoder())
}

pub fn us_core_location_update(
  resource: r4us.UsCoreLocation,
  client: FhirClient,
) -> Result(r4us.UsCoreLocation, Err) {
  any_update(
    resource.id,
    r4us.us_core_location_to_json(resource),
    "Location",
    r4us.us_core_location_decoder(),
    client,
  )
}

pub fn us_core_location_delete(
  resource: r4us.UsCoreLocation,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Location", client)
}

pub fn us_core_location_search_bundled(
  sp: r4us_sansio.SpUsCoreLocation,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_location_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_location_search(
  sp: r4us_sansio.SpUsCoreLocation,
  client: FhirClient,
) -> Result(List(r4us.UsCoreLocation), Err) {
  let req = r4us_sansio.us_core_location_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_location
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Measure", client)
}

pub fn measure_search_bundled(sp: r4us_sansio.SpMeasure, client: FhirClient) {
  let req = r4us_sansio.measure_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn measure_search(
  sp: r4us_sansio.SpMeasure,
  client: FhirClient,
) -> Result(List(r4us.Measure), Err) {
  let req = r4us_sansio.measure_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "MeasureReport", client)
}

pub fn measurereport_search_bundled(
  sp: r4us_sansio.SpMeasurereport,
  client: FhirClient,
) {
  let req = r4us_sansio.measurereport_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn measurereport_search(
  sp: r4us_sansio.SpMeasurereport,
  client: FhirClient,
) -> Result(List(r4us.Measurereport), Err) {
  let req = r4us_sansio.measurereport_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Media", client)
}

pub fn media_search_bundled(sp: r4us_sansio.SpMedia, client: FhirClient) {
  let req = r4us_sansio.media_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn media_search(
  sp: r4us_sansio.SpMedia,
  client: FhirClient,
) -> Result(List(r4us.Media), Err) {
  let req = r4us_sansio.media_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.media
  })
}

pub fn us_core_medication_create(
  resource: r4us.UsCoreMedication,
  client: FhirClient,
) -> Result(r4us.UsCoreMedication, Err) {
  any_create(
    r4us.us_core_medication_to_json(resource),
    "Medication",
    r4us.us_core_medication_decoder(),
    client,
  )
}

pub fn us_core_medication_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreMedication, Err) {
  any_read(id, client, "Medication", r4us.us_core_medication_decoder())
}

pub fn us_core_medication_update(
  resource: r4us.UsCoreMedication,
  client: FhirClient,
) -> Result(r4us.UsCoreMedication, Err) {
  any_update(
    resource.id,
    r4us.us_core_medication_to_json(resource),
    "Medication",
    r4us.us_core_medication_decoder(),
    client,
  )
}

pub fn us_core_medication_delete(
  resource: r4us.UsCoreMedication,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Medication", client)
}

pub fn us_core_medication_search_bundled(
  sp: r4us_sansio.SpUsCoreMedication,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_medication_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_medication_search(
  sp: r4us_sansio.SpUsCoreMedication,
  client: FhirClient,
) -> Result(List(r4us.UsCoreMedication), Err) {
  let req = r4us_sansio.us_core_medication_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_medication
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "MedicationAdministration", client)
}

pub fn medicationadministration_search_bundled(
  sp: r4us_sansio.SpMedicationadministration,
  client: FhirClient,
) {
  let req = r4us_sansio.medicationadministration_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn medicationadministration_search(
  sp: r4us_sansio.SpMedicationadministration,
  client: FhirClient,
) -> Result(List(r4us.Medicationadministration), Err) {
  let req = r4us_sansio.medicationadministration_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.medicationadministration
  })
}

pub fn us_core_medicationdispense_create(
  resource: r4us.UsCoreMedicationdispense,
  client: FhirClient,
) -> Result(r4us.UsCoreMedicationdispense, Err) {
  any_create(
    r4us.us_core_medicationdispense_to_json(resource),
    "MedicationDispense",
    r4us.us_core_medicationdispense_decoder(),
    client,
  )
}

pub fn us_core_medicationdispense_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreMedicationdispense, Err) {
  any_read(
    id,
    client,
    "MedicationDispense",
    r4us.us_core_medicationdispense_decoder(),
  )
}

pub fn us_core_medicationdispense_update(
  resource: r4us.UsCoreMedicationdispense,
  client: FhirClient,
) -> Result(r4us.UsCoreMedicationdispense, Err) {
  any_update(
    resource.id,
    r4us.us_core_medicationdispense_to_json(resource),
    "MedicationDispense",
    r4us.us_core_medicationdispense_decoder(),
    client,
  )
}

pub fn us_core_medicationdispense_delete(
  resource: r4us.UsCoreMedicationdispense,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "MedicationDispense", client)
}

pub fn us_core_medicationdispense_search_bundled(
  sp: r4us_sansio.SpUsCoreMedicationdispense,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_medicationdispense_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_medicationdispense_search(
  sp: r4us_sansio.SpUsCoreMedicationdispense,
  client: FhirClient,
) -> Result(List(r4us.UsCoreMedicationdispense), Err) {
  let req = r4us_sansio.us_core_medicationdispense_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_medicationdispense
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "MedicationKnowledge", client)
}

pub fn medicationknowledge_search_bundled(
  sp: r4us_sansio.SpMedicationknowledge,
  client: FhirClient,
) {
  let req = r4us_sansio.medicationknowledge_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn medicationknowledge_search(
  sp: r4us_sansio.SpMedicationknowledge,
  client: FhirClient,
) -> Result(List(r4us.Medicationknowledge), Err) {
  let req = r4us_sansio.medicationknowledge_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.medicationknowledge
  })
}

pub fn us_core_medicationrequest_create(
  resource: r4us.UsCoreMedicationrequest,
  client: FhirClient,
) -> Result(r4us.UsCoreMedicationrequest, Err) {
  any_create(
    r4us.us_core_medicationrequest_to_json(resource),
    "MedicationRequest",
    r4us.us_core_medicationrequest_decoder(),
    client,
  )
}

pub fn us_core_medicationrequest_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreMedicationrequest, Err) {
  any_read(
    id,
    client,
    "MedicationRequest",
    r4us.us_core_medicationrequest_decoder(),
  )
}

pub fn us_core_medicationrequest_update(
  resource: r4us.UsCoreMedicationrequest,
  client: FhirClient,
) -> Result(r4us.UsCoreMedicationrequest, Err) {
  any_update(
    resource.id,
    r4us.us_core_medicationrequest_to_json(resource),
    "MedicationRequest",
    r4us.us_core_medicationrequest_decoder(),
    client,
  )
}

pub fn us_core_medicationrequest_delete(
  resource: r4us.UsCoreMedicationrequest,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "MedicationRequest", client)
}

pub fn us_core_medicationrequest_search_bundled(
  sp: r4us_sansio.SpUsCoreMedicationrequest,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_medicationrequest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_medicationrequest_search(
  sp: r4us_sansio.SpUsCoreMedicationrequest,
  client: FhirClient,
) -> Result(List(r4us.UsCoreMedicationrequest), Err) {
  let req = r4us_sansio.us_core_medicationrequest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_medicationrequest
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "MedicationStatement", client)
}

pub fn medicationstatement_search_bundled(
  sp: r4us_sansio.SpMedicationstatement,
  client: FhirClient,
) {
  let req = r4us_sansio.medicationstatement_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn medicationstatement_search(
  sp: r4us_sansio.SpMedicationstatement,
  client: FhirClient,
) -> Result(List(r4us.Medicationstatement), Err) {
  let req = r4us_sansio.medicationstatement_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "MedicinalProduct", client)
}

pub fn medicinalproduct_search_bundled(
  sp: r4us_sansio.SpMedicinalproduct,
  client: FhirClient,
) {
  let req = r4us_sansio.medicinalproduct_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn medicinalproduct_search(
  sp: r4us_sansio.SpMedicinalproduct,
  client: FhirClient,
) -> Result(List(r4us.Medicinalproduct), Err) {
  let req = r4us_sansio.medicinalproduct_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "MedicinalProductAuthorization", client)
}

pub fn medicinalproductauthorization_search_bundled(
  sp: r4us_sansio.SpMedicinalproductauthorization,
  client: FhirClient,
) {
  let req = r4us_sansio.medicinalproductauthorization_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn medicinalproductauthorization_search(
  sp: r4us_sansio.SpMedicinalproductauthorization,
  client: FhirClient,
) -> Result(List(r4us.Medicinalproductauthorization), Err) {
  let req = r4us_sansio.medicinalproductauthorization_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "MedicinalProductContraindication", client)
}

pub fn medicinalproductcontraindication_search_bundled(
  sp: r4us_sansio.SpMedicinalproductcontraindication,
  client: FhirClient,
) {
  let req = r4us_sansio.medicinalproductcontraindication_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn medicinalproductcontraindication_search(
  sp: r4us_sansio.SpMedicinalproductcontraindication,
  client: FhirClient,
) -> Result(List(r4us.Medicinalproductcontraindication), Err) {
  let req = r4us_sansio.medicinalproductcontraindication_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "MedicinalProductIndication", client)
}

pub fn medicinalproductindication_search_bundled(
  sp: r4us_sansio.SpMedicinalproductindication,
  client: FhirClient,
) {
  let req = r4us_sansio.medicinalproductindication_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn medicinalproductindication_search(
  sp: r4us_sansio.SpMedicinalproductindication,
  client: FhirClient,
) -> Result(List(r4us.Medicinalproductindication), Err) {
  let req = r4us_sansio.medicinalproductindication_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "MedicinalProductIngredient", client)
}

pub fn medicinalproductingredient_search_bundled(
  sp: r4us_sansio.SpMedicinalproductingredient,
  client: FhirClient,
) {
  let req = r4us_sansio.medicinalproductingredient_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn medicinalproductingredient_search(
  sp: r4us_sansio.SpMedicinalproductingredient,
  client: FhirClient,
) -> Result(List(r4us.Medicinalproductingredient), Err) {
  let req = r4us_sansio.medicinalproductingredient_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "MedicinalProductInteraction", client)
}

pub fn medicinalproductinteraction_search_bundled(
  sp: r4us_sansio.SpMedicinalproductinteraction,
  client: FhirClient,
) {
  let req = r4us_sansio.medicinalproductinteraction_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn medicinalproductinteraction_search(
  sp: r4us_sansio.SpMedicinalproductinteraction,
  client: FhirClient,
) -> Result(List(r4us.Medicinalproductinteraction), Err) {
  let req = r4us_sansio.medicinalproductinteraction_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "MedicinalProductManufactured", client)
}

pub fn medicinalproductmanufactured_search_bundled(
  sp: r4us_sansio.SpMedicinalproductmanufactured,
  client: FhirClient,
) {
  let req = r4us_sansio.medicinalproductmanufactured_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn medicinalproductmanufactured_search(
  sp: r4us_sansio.SpMedicinalproductmanufactured,
  client: FhirClient,
) -> Result(List(r4us.Medicinalproductmanufactured), Err) {
  let req = r4us_sansio.medicinalproductmanufactured_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "MedicinalProductPackaged", client)
}

pub fn medicinalproductpackaged_search_bundled(
  sp: r4us_sansio.SpMedicinalproductpackaged,
  client: FhirClient,
) {
  let req = r4us_sansio.medicinalproductpackaged_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn medicinalproductpackaged_search(
  sp: r4us_sansio.SpMedicinalproductpackaged,
  client: FhirClient,
) -> Result(List(r4us.Medicinalproductpackaged), Err) {
  let req = r4us_sansio.medicinalproductpackaged_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "MedicinalProductPharmaceutical", client)
}

pub fn medicinalproductpharmaceutical_search_bundled(
  sp: r4us_sansio.SpMedicinalproductpharmaceutical,
  client: FhirClient,
) {
  let req = r4us_sansio.medicinalproductpharmaceutical_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn medicinalproductpharmaceutical_search(
  sp: r4us_sansio.SpMedicinalproductpharmaceutical,
  client: FhirClient,
) -> Result(List(r4us.Medicinalproductpharmaceutical), Err) {
  let req = r4us_sansio.medicinalproductpharmaceutical_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "MedicinalProductUndesirableEffect", client)
}

pub fn medicinalproductundesirableeffect_search_bundled(
  sp: r4us_sansio.SpMedicinalproductundesirableeffect,
  client: FhirClient,
) {
  let req = r4us_sansio.medicinalproductundesirableeffect_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn medicinalproductundesirableeffect_search(
  sp: r4us_sansio.SpMedicinalproductundesirableeffect,
  client: FhirClient,
) -> Result(List(r4us.Medicinalproductundesirableeffect), Err) {
  let req = r4us_sansio.medicinalproductundesirableeffect_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "MessageDefinition", client)
}

pub fn messagedefinition_search_bundled(
  sp: r4us_sansio.SpMessagedefinition,
  client: FhirClient,
) {
  let req = r4us_sansio.messagedefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn messagedefinition_search(
  sp: r4us_sansio.SpMessagedefinition,
  client: FhirClient,
) -> Result(List(r4us.Messagedefinition), Err) {
  let req = r4us_sansio.messagedefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "MessageHeader", client)
}

pub fn messageheader_search_bundled(
  sp: r4us_sansio.SpMessageheader,
  client: FhirClient,
) {
  let req = r4us_sansio.messageheader_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn messageheader_search(
  sp: r4us_sansio.SpMessageheader,
  client: FhirClient,
) -> Result(List(r4us.Messageheader), Err) {
  let req = r4us_sansio.messageheader_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "MolecularSequence", client)
}

pub fn molecularsequence_search_bundled(
  sp: r4us_sansio.SpMolecularsequence,
  client: FhirClient,
) {
  let req = r4us_sansio.molecularsequence_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn molecularsequence_search(
  sp: r4us_sansio.SpMolecularsequence,
  client: FhirClient,
) -> Result(List(r4us.Molecularsequence), Err) {
  let req = r4us_sansio.molecularsequence_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "NamingSystem", client)
}

pub fn namingsystem_search_bundled(
  sp: r4us_sansio.SpNamingsystem,
  client: FhirClient,
) {
  let req = r4us_sansio.namingsystem_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn namingsystem_search(
  sp: r4us_sansio.SpNamingsystem,
  client: FhirClient,
) -> Result(List(r4us.Namingsystem), Err) {
  let req = r4us_sansio.namingsystem_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "NutritionOrder", client)
}

pub fn nutritionorder_search_bundled(
  sp: r4us_sansio.SpNutritionorder,
  client: FhirClient,
) {
  let req = r4us_sansio.nutritionorder_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn nutritionorder_search(
  sp: r4us_sansio.SpNutritionorder,
  client: FhirClient,
) -> Result(List(r4us.Nutritionorder), Err) {
  let req = r4us_sansio.nutritionorder_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.nutritionorder
  })
}

pub fn us_core_body_temperature_create(
  resource: r4us.UsCoreBodyTemperature,
  client: FhirClient,
) -> Result(r4us.UsCoreBodyTemperature, Err) {
  any_create(
    r4us.us_core_body_temperature_to_json(resource),
    "Observation",
    r4us.us_core_body_temperature_decoder(),
    client,
  )
}

pub fn us_core_body_temperature_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreBodyTemperature, Err) {
  any_read(id, client, "Observation", r4us.us_core_body_temperature_decoder())
}

pub fn us_core_body_temperature_update(
  resource: r4us.UsCoreBodyTemperature,
  client: FhirClient,
) -> Result(r4us.UsCoreBodyTemperature, Err) {
  any_update(
    resource.id,
    r4us.us_core_body_temperature_to_json(resource),
    "Observation",
    r4us.us_core_body_temperature_decoder(),
    client,
  )
}

pub fn us_core_body_temperature_delete(
  resource: r4us.UsCoreBodyTemperature,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Observation", client)
}

pub fn us_core_body_temperature_search_bundled(
  sp: r4us_sansio.SpUsCoreBodyTemperature,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_body_temperature_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_body_temperature_search(
  sp: r4us_sansio.SpUsCoreBodyTemperature,
  client: FhirClient,
) -> Result(List(r4us.UsCoreBodyTemperature), Err) {
  let req = r4us_sansio.us_core_body_temperature_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_body_temperature
  })
}

pub fn us_core_observation_clinical_result_create(
  resource: r4us.UsCoreObservationClinicalResult,
  client: FhirClient,
) -> Result(r4us.UsCoreObservationClinicalResult, Err) {
  any_create(
    r4us.us_core_observation_clinical_result_to_json(resource),
    "Observation",
    r4us.us_core_observation_clinical_result_decoder(),
    client,
  )
}

pub fn us_core_observation_clinical_result_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreObservationClinicalResult, Err) {
  any_read(
    id,
    client,
    "Observation",
    r4us.us_core_observation_clinical_result_decoder(),
  )
}

pub fn us_core_observation_clinical_result_update(
  resource: r4us.UsCoreObservationClinicalResult,
  client: FhirClient,
) -> Result(r4us.UsCoreObservationClinicalResult, Err) {
  any_update(
    resource.id,
    r4us.us_core_observation_clinical_result_to_json(resource),
    "Observation",
    r4us.us_core_observation_clinical_result_decoder(),
    client,
  )
}

pub fn us_core_observation_clinical_result_delete(
  resource: r4us.UsCoreObservationClinicalResult,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Observation", client)
}

pub fn us_core_observation_clinical_result_search_bundled(
  sp: r4us_sansio.SpUsCoreObservationClinicalResult,
  client: FhirClient,
) {
  let req =
    r4us_sansio.us_core_observation_clinical_result_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_observation_clinical_result_search(
  sp: r4us_sansio.SpUsCoreObservationClinicalResult,
  client: FhirClient,
) -> Result(List(r4us.UsCoreObservationClinicalResult), Err) {
  let req =
    r4us_sansio.us_core_observation_clinical_result_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_observation_clinical_result
  })
}

pub fn us_core_observation_lab_create(
  resource: r4us.UsCoreObservationLab,
  client: FhirClient,
) -> Result(r4us.UsCoreObservationLab, Err) {
  any_create(
    r4us.us_core_observation_lab_to_json(resource),
    "Observation",
    r4us.us_core_observation_lab_decoder(),
    client,
  )
}

pub fn us_core_observation_lab_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreObservationLab, Err) {
  any_read(id, client, "Observation", r4us.us_core_observation_lab_decoder())
}

pub fn us_core_observation_lab_update(
  resource: r4us.UsCoreObservationLab,
  client: FhirClient,
) -> Result(r4us.UsCoreObservationLab, Err) {
  any_update(
    resource.id,
    r4us.us_core_observation_lab_to_json(resource),
    "Observation",
    r4us.us_core_observation_lab_decoder(),
    client,
  )
}

pub fn us_core_observation_lab_delete(
  resource: r4us.UsCoreObservationLab,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Observation", client)
}

pub fn us_core_observation_lab_search_bundled(
  sp: r4us_sansio.SpUsCoreObservationLab,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_observation_lab_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_observation_lab_search(
  sp: r4us_sansio.SpUsCoreObservationLab,
  client: FhirClient,
) -> Result(List(r4us.UsCoreObservationLab), Err) {
  let req = r4us_sansio.us_core_observation_lab_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_observation_lab
  })
}

pub fn us_core_treatment_intervention_preference_create(
  resource: r4us.UsCoreTreatmentInterventionPreference,
  client: FhirClient,
) -> Result(r4us.UsCoreTreatmentInterventionPreference, Err) {
  any_create(
    r4us.us_core_treatment_intervention_preference_to_json(resource),
    "Observation",
    r4us.us_core_treatment_intervention_preference_decoder(),
    client,
  )
}

pub fn us_core_treatment_intervention_preference_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreTreatmentInterventionPreference, Err) {
  any_read(
    id,
    client,
    "Observation",
    r4us.us_core_treatment_intervention_preference_decoder(),
  )
}

pub fn us_core_treatment_intervention_preference_update(
  resource: r4us.UsCoreTreatmentInterventionPreference,
  client: FhirClient,
) -> Result(r4us.UsCoreTreatmentInterventionPreference, Err) {
  any_update(
    resource.id,
    r4us.us_core_treatment_intervention_preference_to_json(resource),
    "Observation",
    r4us.us_core_treatment_intervention_preference_decoder(),
    client,
  )
}

pub fn us_core_treatment_intervention_preference_delete(
  resource: r4us.UsCoreTreatmentInterventionPreference,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Observation", client)
}

pub fn us_core_treatment_intervention_preference_search_bundled(
  sp: r4us_sansio.SpUsCoreTreatmentInterventionPreference,
  client: FhirClient,
) {
  let req =
    r4us_sansio.us_core_treatment_intervention_preference_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_treatment_intervention_preference_search(
  sp: r4us_sansio.SpUsCoreTreatmentInterventionPreference,
  client: FhirClient,
) -> Result(List(r4us.UsCoreTreatmentInterventionPreference), Err) {
  let req =
    r4us_sansio.us_core_treatment_intervention_preference_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_treatment_intervention_preference
  })
}

pub fn us_core_observation_pregnancyintent_create(
  resource: r4us.UsCoreObservationPregnancyintent,
  client: FhirClient,
) -> Result(r4us.UsCoreObservationPregnancyintent, Err) {
  any_create(
    r4us.us_core_observation_pregnancyintent_to_json(resource),
    "Observation",
    r4us.us_core_observation_pregnancyintent_decoder(),
    client,
  )
}

pub fn us_core_observation_pregnancyintent_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreObservationPregnancyintent, Err) {
  any_read(
    id,
    client,
    "Observation",
    r4us.us_core_observation_pregnancyintent_decoder(),
  )
}

pub fn us_core_observation_pregnancyintent_update(
  resource: r4us.UsCoreObservationPregnancyintent,
  client: FhirClient,
) -> Result(r4us.UsCoreObservationPregnancyintent, Err) {
  any_update(
    resource.id,
    r4us.us_core_observation_pregnancyintent_to_json(resource),
    "Observation",
    r4us.us_core_observation_pregnancyintent_decoder(),
    client,
  )
}

pub fn us_core_observation_pregnancyintent_delete(
  resource: r4us.UsCoreObservationPregnancyintent,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Observation", client)
}

pub fn us_core_observation_pregnancyintent_search_bundled(
  sp: r4us_sansio.SpUsCoreObservationPregnancyintent,
  client: FhirClient,
) {
  let req =
    r4us_sansio.us_core_observation_pregnancyintent_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_observation_pregnancyintent_search(
  sp: r4us_sansio.SpUsCoreObservationPregnancyintent,
  client: FhirClient,
) -> Result(List(r4us.UsCoreObservationPregnancyintent), Err) {
  let req =
    r4us_sansio.us_core_observation_pregnancyintent_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_observation_pregnancyintent
  })
}

pub fn us_core_simple_observation_create(
  resource: r4us.UsCoreSimpleObservation,
  client: FhirClient,
) -> Result(r4us.UsCoreSimpleObservation, Err) {
  any_create(
    r4us.us_core_simple_observation_to_json(resource),
    "Observation",
    r4us.us_core_simple_observation_decoder(),
    client,
  )
}

pub fn us_core_simple_observation_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreSimpleObservation, Err) {
  any_read(id, client, "Observation", r4us.us_core_simple_observation_decoder())
}

pub fn us_core_simple_observation_update(
  resource: r4us.UsCoreSimpleObservation,
  client: FhirClient,
) -> Result(r4us.UsCoreSimpleObservation, Err) {
  any_update(
    resource.id,
    r4us.us_core_simple_observation_to_json(resource),
    "Observation",
    r4us.us_core_simple_observation_decoder(),
    client,
  )
}

pub fn us_core_simple_observation_delete(
  resource: r4us.UsCoreSimpleObservation,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Observation", client)
}

pub fn us_core_simple_observation_search_bundled(
  sp: r4us_sansio.SpUsCoreSimpleObservation,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_simple_observation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_simple_observation_search(
  sp: r4us_sansio.SpUsCoreSimpleObservation,
  client: FhirClient,
) -> Result(List(r4us.UsCoreSimpleObservation), Err) {
  let req = r4us_sansio.us_core_simple_observation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_simple_observation
  })
}

pub fn us_core_respiratory_rate_create(
  resource: r4us.UsCoreRespiratoryRate,
  client: FhirClient,
) -> Result(r4us.UsCoreRespiratoryRate, Err) {
  any_create(
    r4us.us_core_respiratory_rate_to_json(resource),
    "Observation",
    r4us.us_core_respiratory_rate_decoder(),
    client,
  )
}

pub fn us_core_respiratory_rate_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreRespiratoryRate, Err) {
  any_read(id, client, "Observation", r4us.us_core_respiratory_rate_decoder())
}

pub fn us_core_respiratory_rate_update(
  resource: r4us.UsCoreRespiratoryRate,
  client: FhirClient,
) -> Result(r4us.UsCoreRespiratoryRate, Err) {
  any_update(
    resource.id,
    r4us.us_core_respiratory_rate_to_json(resource),
    "Observation",
    r4us.us_core_respiratory_rate_decoder(),
    client,
  )
}

pub fn us_core_respiratory_rate_delete(
  resource: r4us.UsCoreRespiratoryRate,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Observation", client)
}

pub fn us_core_respiratory_rate_search_bundled(
  sp: r4us_sansio.SpUsCoreRespiratoryRate,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_respiratory_rate_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_respiratory_rate_search(
  sp: r4us_sansio.SpUsCoreRespiratoryRate,
  client: FhirClient,
) -> Result(List(r4us.UsCoreRespiratoryRate), Err) {
  let req = r4us_sansio.us_core_respiratory_rate_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_respiratory_rate
  })
}

pub fn us_core_observation_occupation_create(
  resource: r4us.UsCoreObservationOccupation,
  client: FhirClient,
) -> Result(r4us.UsCoreObservationOccupation, Err) {
  any_create(
    r4us.us_core_observation_occupation_to_json(resource),
    "Observation",
    r4us.us_core_observation_occupation_decoder(),
    client,
  )
}

pub fn us_core_observation_occupation_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreObservationOccupation, Err) {
  any_read(
    id,
    client,
    "Observation",
    r4us.us_core_observation_occupation_decoder(),
  )
}

pub fn us_core_observation_occupation_update(
  resource: r4us.UsCoreObservationOccupation,
  client: FhirClient,
) -> Result(r4us.UsCoreObservationOccupation, Err) {
  any_update(
    resource.id,
    r4us.us_core_observation_occupation_to_json(resource),
    "Observation",
    r4us.us_core_observation_occupation_decoder(),
    client,
  )
}

pub fn us_core_observation_occupation_delete(
  resource: r4us.UsCoreObservationOccupation,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Observation", client)
}

pub fn us_core_observation_occupation_search_bundled(
  sp: r4us_sansio.SpUsCoreObservationOccupation,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_observation_occupation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_observation_occupation_search(
  sp: r4us_sansio.SpUsCoreObservationOccupation,
  client: FhirClient,
) -> Result(List(r4us.UsCoreObservationOccupation), Err) {
  let req = r4us_sansio.us_core_observation_occupation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_observation_occupation
  })
}

pub fn us_core_vital_signs_create(
  resource: r4us.UsCoreVitalSigns,
  client: FhirClient,
) -> Result(r4us.UsCoreVitalSigns, Err) {
  any_create(
    r4us.us_core_vital_signs_to_json(resource),
    "Observation",
    r4us.us_core_vital_signs_decoder(),
    client,
  )
}

pub fn us_core_vital_signs_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreVitalSigns, Err) {
  any_read(id, client, "Observation", r4us.us_core_vital_signs_decoder())
}

pub fn us_core_vital_signs_update(
  resource: r4us.UsCoreVitalSigns,
  client: FhirClient,
) -> Result(r4us.UsCoreVitalSigns, Err) {
  any_update(
    resource.id,
    r4us.us_core_vital_signs_to_json(resource),
    "Observation",
    r4us.us_core_vital_signs_decoder(),
    client,
  )
}

pub fn us_core_vital_signs_delete(
  resource: r4us.UsCoreVitalSigns,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Observation", client)
}

pub fn us_core_vital_signs_search_bundled(
  sp: r4us_sansio.SpUsCoreVitalSigns,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_vital_signs_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_vital_signs_search(
  sp: r4us_sansio.SpUsCoreVitalSigns,
  client: FhirClient,
) -> Result(List(r4us.UsCoreVitalSigns), Err) {
  let req = r4us_sansio.us_core_vital_signs_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_vital_signs
  })
}

pub fn us_core_body_weight_create(
  resource: r4us.UsCoreBodyWeight,
  client: FhirClient,
) -> Result(r4us.UsCoreBodyWeight, Err) {
  any_create(
    r4us.us_core_body_weight_to_json(resource),
    "Observation",
    r4us.us_core_body_weight_decoder(),
    client,
  )
}

pub fn us_core_body_weight_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreBodyWeight, Err) {
  any_read(id, client, "Observation", r4us.us_core_body_weight_decoder())
}

pub fn us_core_body_weight_update(
  resource: r4us.UsCoreBodyWeight,
  client: FhirClient,
) -> Result(r4us.UsCoreBodyWeight, Err) {
  any_update(
    resource.id,
    r4us.us_core_body_weight_to_json(resource),
    "Observation",
    r4us.us_core_body_weight_decoder(),
    client,
  )
}

pub fn us_core_body_weight_delete(
  resource: r4us.UsCoreBodyWeight,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Observation", client)
}

pub fn us_core_body_weight_search_bundled(
  sp: r4us_sansio.SpUsCoreBodyWeight,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_body_weight_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_body_weight_search(
  sp: r4us_sansio.SpUsCoreBodyWeight,
  client: FhirClient,
) -> Result(List(r4us.UsCoreBodyWeight), Err) {
  let req = r4us_sansio.us_core_body_weight_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_body_weight
  })
}

pub fn us_core_observation_pregnancystatus_create(
  resource: r4us.UsCoreObservationPregnancystatus,
  client: FhirClient,
) -> Result(r4us.UsCoreObservationPregnancystatus, Err) {
  any_create(
    r4us.us_core_observation_pregnancystatus_to_json(resource),
    "Observation",
    r4us.us_core_observation_pregnancystatus_decoder(),
    client,
  )
}

pub fn us_core_observation_pregnancystatus_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreObservationPregnancystatus, Err) {
  any_read(
    id,
    client,
    "Observation",
    r4us.us_core_observation_pregnancystatus_decoder(),
  )
}

pub fn us_core_observation_pregnancystatus_update(
  resource: r4us.UsCoreObservationPregnancystatus,
  client: FhirClient,
) -> Result(r4us.UsCoreObservationPregnancystatus, Err) {
  any_update(
    resource.id,
    r4us.us_core_observation_pregnancystatus_to_json(resource),
    "Observation",
    r4us.us_core_observation_pregnancystatus_decoder(),
    client,
  )
}

pub fn us_core_observation_pregnancystatus_delete(
  resource: r4us.UsCoreObservationPregnancystatus,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Observation", client)
}

pub fn us_core_observation_pregnancystatus_search_bundled(
  sp: r4us_sansio.SpUsCoreObservationPregnancystatus,
  client: FhirClient,
) {
  let req =
    r4us_sansio.us_core_observation_pregnancystatus_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_observation_pregnancystatus_search(
  sp: r4us_sansio.SpUsCoreObservationPregnancystatus,
  client: FhirClient,
) -> Result(List(r4us.UsCoreObservationPregnancystatus), Err) {
  let req =
    r4us_sansio.us_core_observation_pregnancystatus_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_observation_pregnancystatus
  })
}

pub fn us_core_blood_pressure_create(
  resource: r4us.UsCoreBloodPressure,
  client: FhirClient,
) -> Result(r4us.UsCoreBloodPressure, Err) {
  any_create(
    r4us.us_core_blood_pressure_to_json(resource),
    "Observation",
    r4us.us_core_blood_pressure_decoder(),
    client,
  )
}

pub fn us_core_blood_pressure_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreBloodPressure, Err) {
  any_read(id, client, "Observation", r4us.us_core_blood_pressure_decoder())
}

pub fn us_core_blood_pressure_update(
  resource: r4us.UsCoreBloodPressure,
  client: FhirClient,
) -> Result(r4us.UsCoreBloodPressure, Err) {
  any_update(
    resource.id,
    r4us.us_core_blood_pressure_to_json(resource),
    "Observation",
    r4us.us_core_blood_pressure_decoder(),
    client,
  )
}

pub fn us_core_blood_pressure_delete(
  resource: r4us.UsCoreBloodPressure,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Observation", client)
}

pub fn us_core_blood_pressure_search_bundled(
  sp: r4us_sansio.SpUsCoreBloodPressure,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_blood_pressure_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_blood_pressure_search(
  sp: r4us_sansio.SpUsCoreBloodPressure,
  client: FhirClient,
) -> Result(List(r4us.UsCoreBloodPressure), Err) {
  let req = r4us_sansio.us_core_blood_pressure_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_blood_pressure
  })
}

pub fn pediatric_bmi_for_age_create(
  resource: r4us.PediatricBmiForAge,
  client: FhirClient,
) -> Result(r4us.PediatricBmiForAge, Err) {
  any_create(
    r4us.pediatric_bmi_for_age_to_json(resource),
    "Observation",
    r4us.pediatric_bmi_for_age_decoder(),
    client,
  )
}

pub fn pediatric_bmi_for_age_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.PediatricBmiForAge, Err) {
  any_read(id, client, "Observation", r4us.pediatric_bmi_for_age_decoder())
}

pub fn pediatric_bmi_for_age_update(
  resource: r4us.PediatricBmiForAge,
  client: FhirClient,
) -> Result(r4us.PediatricBmiForAge, Err) {
  any_update(
    resource.id,
    r4us.pediatric_bmi_for_age_to_json(resource),
    "Observation",
    r4us.pediatric_bmi_for_age_decoder(),
    client,
  )
}

pub fn pediatric_bmi_for_age_delete(
  resource: r4us.PediatricBmiForAge,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Observation", client)
}

pub fn pediatric_bmi_for_age_search_bundled(
  sp: r4us_sansio.SpPediatricBmiForAge,
  client: FhirClient,
) {
  let req = r4us_sansio.pediatric_bmi_for_age_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn pediatric_bmi_for_age_search(
  sp: r4us_sansio.SpPediatricBmiForAge,
  client: FhirClient,
) -> Result(List(r4us.PediatricBmiForAge), Err) {
  let req = r4us_sansio.pediatric_bmi_for_age_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.pediatric_bmi_for_age
  })
}

pub fn us_core_care_experience_preference_create(
  resource: r4us.UsCoreCareExperiencePreference,
  client: FhirClient,
) -> Result(r4us.UsCoreCareExperiencePreference, Err) {
  any_create(
    r4us.us_core_care_experience_preference_to_json(resource),
    "Observation",
    r4us.us_core_care_experience_preference_decoder(),
    client,
  )
}

pub fn us_core_care_experience_preference_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreCareExperiencePreference, Err) {
  any_read(
    id,
    client,
    "Observation",
    r4us.us_core_care_experience_preference_decoder(),
  )
}

pub fn us_core_care_experience_preference_update(
  resource: r4us.UsCoreCareExperiencePreference,
  client: FhirClient,
) -> Result(r4us.UsCoreCareExperiencePreference, Err) {
  any_update(
    resource.id,
    r4us.us_core_care_experience_preference_to_json(resource),
    "Observation",
    r4us.us_core_care_experience_preference_decoder(),
    client,
  )
}

pub fn us_core_care_experience_preference_delete(
  resource: r4us.UsCoreCareExperiencePreference,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Observation", client)
}

pub fn us_core_care_experience_preference_search_bundled(
  sp: r4us_sansio.SpUsCoreCareExperiencePreference,
  client: FhirClient,
) {
  let req =
    r4us_sansio.us_core_care_experience_preference_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_care_experience_preference_search(
  sp: r4us_sansio.SpUsCoreCareExperiencePreference,
  client: FhirClient,
) -> Result(List(r4us.UsCoreCareExperiencePreference), Err) {
  let req =
    r4us_sansio.us_core_care_experience_preference_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_care_experience_preference
  })
}

pub fn us_core_observation_screening_assessment_create(
  resource: r4us.UsCoreObservationScreeningAssessment,
  client: FhirClient,
) -> Result(r4us.UsCoreObservationScreeningAssessment, Err) {
  any_create(
    r4us.us_core_observation_screening_assessment_to_json(resource),
    "Observation",
    r4us.us_core_observation_screening_assessment_decoder(),
    client,
  )
}

pub fn us_core_observation_screening_assessment_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreObservationScreeningAssessment, Err) {
  any_read(
    id,
    client,
    "Observation",
    r4us.us_core_observation_screening_assessment_decoder(),
  )
}

pub fn us_core_observation_screening_assessment_update(
  resource: r4us.UsCoreObservationScreeningAssessment,
  client: FhirClient,
) -> Result(r4us.UsCoreObservationScreeningAssessment, Err) {
  any_update(
    resource.id,
    r4us.us_core_observation_screening_assessment_to_json(resource),
    "Observation",
    r4us.us_core_observation_screening_assessment_decoder(),
    client,
  )
}

pub fn us_core_observation_screening_assessment_delete(
  resource: r4us.UsCoreObservationScreeningAssessment,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Observation", client)
}

pub fn us_core_observation_screening_assessment_search_bundled(
  sp: r4us_sansio.SpUsCoreObservationScreeningAssessment,
  client: FhirClient,
) {
  let req =
    r4us_sansio.us_core_observation_screening_assessment_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_observation_screening_assessment_search(
  sp: r4us_sansio.SpUsCoreObservationScreeningAssessment,
  client: FhirClient,
) -> Result(List(r4us.UsCoreObservationScreeningAssessment), Err) {
  let req =
    r4us_sansio.us_core_observation_screening_assessment_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_observation_screening_assessment
  })
}

pub fn us_core_head_circumference_create(
  resource: r4us.UsCoreHeadCircumference,
  client: FhirClient,
) -> Result(r4us.UsCoreHeadCircumference, Err) {
  any_create(
    r4us.us_core_head_circumference_to_json(resource),
    "Observation",
    r4us.us_core_head_circumference_decoder(),
    client,
  )
}

pub fn us_core_head_circumference_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreHeadCircumference, Err) {
  any_read(id, client, "Observation", r4us.us_core_head_circumference_decoder())
}

pub fn us_core_head_circumference_update(
  resource: r4us.UsCoreHeadCircumference,
  client: FhirClient,
) -> Result(r4us.UsCoreHeadCircumference, Err) {
  any_update(
    resource.id,
    r4us.us_core_head_circumference_to_json(resource),
    "Observation",
    r4us.us_core_head_circumference_decoder(),
    client,
  )
}

pub fn us_core_head_circumference_delete(
  resource: r4us.UsCoreHeadCircumference,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Observation", client)
}

pub fn us_core_head_circumference_search_bundled(
  sp: r4us_sansio.SpUsCoreHeadCircumference,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_head_circumference_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_head_circumference_search(
  sp: r4us_sansio.SpUsCoreHeadCircumference,
  client: FhirClient,
) -> Result(List(r4us.UsCoreHeadCircumference), Err) {
  let req = r4us_sansio.us_core_head_circumference_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_head_circumference
  })
}

pub fn us_core_heart_rate_create(
  resource: r4us.UsCoreHeartRate,
  client: FhirClient,
) -> Result(r4us.UsCoreHeartRate, Err) {
  any_create(
    r4us.us_core_heart_rate_to_json(resource),
    "Observation",
    r4us.us_core_heart_rate_decoder(),
    client,
  )
}

pub fn us_core_heart_rate_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreHeartRate, Err) {
  any_read(id, client, "Observation", r4us.us_core_heart_rate_decoder())
}

pub fn us_core_heart_rate_update(
  resource: r4us.UsCoreHeartRate,
  client: FhirClient,
) -> Result(r4us.UsCoreHeartRate, Err) {
  any_update(
    resource.id,
    r4us.us_core_heart_rate_to_json(resource),
    "Observation",
    r4us.us_core_heart_rate_decoder(),
    client,
  )
}

pub fn us_core_heart_rate_delete(
  resource: r4us.UsCoreHeartRate,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Observation", client)
}

pub fn us_core_heart_rate_search_bundled(
  sp: r4us_sansio.SpUsCoreHeartRate,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_heart_rate_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_heart_rate_search(
  sp: r4us_sansio.SpUsCoreHeartRate,
  client: FhirClient,
) -> Result(List(r4us.UsCoreHeartRate), Err) {
  let req = r4us_sansio.us_core_heart_rate_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_heart_rate
  })
}

pub fn us_core_observation_sexual_orientation_create(
  resource: r4us.UsCoreObservationSexualOrientation,
  client: FhirClient,
) -> Result(r4us.UsCoreObservationSexualOrientation, Err) {
  any_create(
    r4us.us_core_observation_sexual_orientation_to_json(resource),
    "Observation",
    r4us.us_core_observation_sexual_orientation_decoder(),
    client,
  )
}

pub fn us_core_observation_sexual_orientation_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreObservationSexualOrientation, Err) {
  any_read(
    id,
    client,
    "Observation",
    r4us.us_core_observation_sexual_orientation_decoder(),
  )
}

pub fn us_core_observation_sexual_orientation_update(
  resource: r4us.UsCoreObservationSexualOrientation,
  client: FhirClient,
) -> Result(r4us.UsCoreObservationSexualOrientation, Err) {
  any_update(
    resource.id,
    r4us.us_core_observation_sexual_orientation_to_json(resource),
    "Observation",
    r4us.us_core_observation_sexual_orientation_decoder(),
    client,
  )
}

pub fn us_core_observation_sexual_orientation_delete(
  resource: r4us.UsCoreObservationSexualOrientation,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Observation", client)
}

pub fn us_core_observation_sexual_orientation_search_bundled(
  sp: r4us_sansio.SpUsCoreObservationSexualOrientation,
  client: FhirClient,
) {
  let req =
    r4us_sansio.us_core_observation_sexual_orientation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_observation_sexual_orientation_search(
  sp: r4us_sansio.SpUsCoreObservationSexualOrientation,
  client: FhirClient,
) -> Result(List(r4us.UsCoreObservationSexualOrientation), Err) {
  let req =
    r4us_sansio.us_core_observation_sexual_orientation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_observation_sexual_orientation
  })
}

pub fn pediatric_weight_for_height_create(
  resource: r4us.PediatricWeightForHeight,
  client: FhirClient,
) -> Result(r4us.PediatricWeightForHeight, Err) {
  any_create(
    r4us.pediatric_weight_for_height_to_json(resource),
    "Observation",
    r4us.pediatric_weight_for_height_decoder(),
    client,
  )
}

pub fn pediatric_weight_for_height_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.PediatricWeightForHeight, Err) {
  any_read(
    id,
    client,
    "Observation",
    r4us.pediatric_weight_for_height_decoder(),
  )
}

pub fn pediatric_weight_for_height_update(
  resource: r4us.PediatricWeightForHeight,
  client: FhirClient,
) -> Result(r4us.PediatricWeightForHeight, Err) {
  any_update(
    resource.id,
    r4us.pediatric_weight_for_height_to_json(resource),
    "Observation",
    r4us.pediatric_weight_for_height_decoder(),
    client,
  )
}

pub fn pediatric_weight_for_height_delete(
  resource: r4us.PediatricWeightForHeight,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Observation", client)
}

pub fn pediatric_weight_for_height_search_bundled(
  sp: r4us_sansio.SpPediatricWeightForHeight,
  client: FhirClient,
) {
  let req = r4us_sansio.pediatric_weight_for_height_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn pediatric_weight_for_height_search(
  sp: r4us_sansio.SpPediatricWeightForHeight,
  client: FhirClient,
) -> Result(List(r4us.PediatricWeightForHeight), Err) {
  let req = r4us_sansio.pediatric_weight_for_height_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.pediatric_weight_for_height
  })
}

pub fn us_core_bmi_create(
  resource: r4us.UsCoreBmi,
  client: FhirClient,
) -> Result(r4us.UsCoreBmi, Err) {
  any_create(
    r4us.us_core_bmi_to_json(resource),
    "Observation",
    r4us.us_core_bmi_decoder(),
    client,
  )
}

pub fn us_core_bmi_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreBmi, Err) {
  any_read(id, client, "Observation", r4us.us_core_bmi_decoder())
}

pub fn us_core_bmi_update(
  resource: r4us.UsCoreBmi,
  client: FhirClient,
) -> Result(r4us.UsCoreBmi, Err) {
  any_update(
    resource.id,
    r4us.us_core_bmi_to_json(resource),
    "Observation",
    r4us.us_core_bmi_decoder(),
    client,
  )
}

pub fn us_core_bmi_delete(
  resource: r4us.UsCoreBmi,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Observation", client)
}

pub fn us_core_bmi_search_bundled(
  sp: r4us_sansio.SpUsCoreBmi,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_bmi_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_bmi_search(
  sp: r4us_sansio.SpUsCoreBmi,
  client: FhirClient,
) -> Result(List(r4us.UsCoreBmi), Err) {
  let req = r4us_sansio.us_core_bmi_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_bmi
  })
}

pub fn us_core_body_height_create(
  resource: r4us.UsCoreBodyHeight,
  client: FhirClient,
) -> Result(r4us.UsCoreBodyHeight, Err) {
  any_create(
    r4us.us_core_body_height_to_json(resource),
    "Observation",
    r4us.us_core_body_height_decoder(),
    client,
  )
}

pub fn us_core_body_height_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreBodyHeight, Err) {
  any_read(id, client, "Observation", r4us.us_core_body_height_decoder())
}

pub fn us_core_body_height_update(
  resource: r4us.UsCoreBodyHeight,
  client: FhirClient,
) -> Result(r4us.UsCoreBodyHeight, Err) {
  any_update(
    resource.id,
    r4us.us_core_body_height_to_json(resource),
    "Observation",
    r4us.us_core_body_height_decoder(),
    client,
  )
}

pub fn us_core_body_height_delete(
  resource: r4us.UsCoreBodyHeight,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Observation", client)
}

pub fn us_core_body_height_search_bundled(
  sp: r4us_sansio.SpUsCoreBodyHeight,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_body_height_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_body_height_search(
  sp: r4us_sansio.SpUsCoreBodyHeight,
  client: FhirClient,
) -> Result(List(r4us.UsCoreBodyHeight), Err) {
  let req = r4us_sansio.us_core_body_height_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_body_height
  })
}

pub fn us_core_smokingstatus_create(
  resource: r4us.UsCoreSmokingstatus,
  client: FhirClient,
) -> Result(r4us.UsCoreSmokingstatus, Err) {
  any_create(
    r4us.us_core_smokingstatus_to_json(resource),
    "Observation",
    r4us.us_core_smokingstatus_decoder(),
    client,
  )
}

pub fn us_core_smokingstatus_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreSmokingstatus, Err) {
  any_read(id, client, "Observation", r4us.us_core_smokingstatus_decoder())
}

pub fn us_core_smokingstatus_update(
  resource: r4us.UsCoreSmokingstatus,
  client: FhirClient,
) -> Result(r4us.UsCoreSmokingstatus, Err) {
  any_update(
    resource.id,
    r4us.us_core_smokingstatus_to_json(resource),
    "Observation",
    r4us.us_core_smokingstatus_decoder(),
    client,
  )
}

pub fn us_core_smokingstatus_delete(
  resource: r4us.UsCoreSmokingstatus,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Observation", client)
}

pub fn us_core_smokingstatus_search_bundled(
  sp: r4us_sansio.SpUsCoreSmokingstatus,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_smokingstatus_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_smokingstatus_search(
  sp: r4us_sansio.SpUsCoreSmokingstatus,
  client: FhirClient,
) -> Result(List(r4us.UsCoreSmokingstatus), Err) {
  let req = r4us_sansio.us_core_smokingstatus_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_smokingstatus
  })
}

pub fn us_core_pulse_oximetry_create(
  resource: r4us.UsCorePulseOximetry,
  client: FhirClient,
) -> Result(r4us.UsCorePulseOximetry, Err) {
  any_create(
    r4us.us_core_pulse_oximetry_to_json(resource),
    "Observation",
    r4us.us_core_pulse_oximetry_decoder(),
    client,
  )
}

pub fn us_core_pulse_oximetry_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCorePulseOximetry, Err) {
  any_read(id, client, "Observation", r4us.us_core_pulse_oximetry_decoder())
}

pub fn us_core_pulse_oximetry_update(
  resource: r4us.UsCorePulseOximetry,
  client: FhirClient,
) -> Result(r4us.UsCorePulseOximetry, Err) {
  any_update(
    resource.id,
    r4us.us_core_pulse_oximetry_to_json(resource),
    "Observation",
    r4us.us_core_pulse_oximetry_decoder(),
    client,
  )
}

pub fn us_core_pulse_oximetry_delete(
  resource: r4us.UsCorePulseOximetry,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Observation", client)
}

pub fn us_core_pulse_oximetry_search_bundled(
  sp: r4us_sansio.SpUsCorePulseOximetry,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_pulse_oximetry_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_pulse_oximetry_search(
  sp: r4us_sansio.SpUsCorePulseOximetry,
  client: FhirClient,
) -> Result(List(r4us.UsCorePulseOximetry), Err) {
  let req = r4us_sansio.us_core_pulse_oximetry_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_pulse_oximetry
  })
}

pub fn head_occipital_frontal_circumference_percentile_create(
  resource: r4us.HeadOccipitalFrontalCircumferencePercentile,
  client: FhirClient,
) -> Result(r4us.HeadOccipitalFrontalCircumferencePercentile, Err) {
  any_create(
    r4us.head_occipital_frontal_circumference_percentile_to_json(resource),
    "Observation",
    r4us.head_occipital_frontal_circumference_percentile_decoder(),
    client,
  )
}

pub fn head_occipital_frontal_circumference_percentile_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.HeadOccipitalFrontalCircumferencePercentile, Err) {
  any_read(
    id,
    client,
    "Observation",
    r4us.head_occipital_frontal_circumference_percentile_decoder(),
  )
}

pub fn head_occipital_frontal_circumference_percentile_update(
  resource: r4us.HeadOccipitalFrontalCircumferencePercentile,
  client: FhirClient,
) -> Result(r4us.HeadOccipitalFrontalCircumferencePercentile, Err) {
  any_update(
    resource.id,
    r4us.head_occipital_frontal_circumference_percentile_to_json(resource),
    "Observation",
    r4us.head_occipital_frontal_circumference_percentile_decoder(),
    client,
  )
}

pub fn head_occipital_frontal_circumference_percentile_delete(
  resource: r4us.HeadOccipitalFrontalCircumferencePercentile,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Observation", client)
}

pub fn head_occipital_frontal_circumference_percentile_search_bundled(
  sp: r4us_sansio.SpHeadOccipitalFrontalCircumferencePercentile,
  client: FhirClient,
) {
  let req =
    r4us_sansio.head_occipital_frontal_circumference_percentile_search_req(
      sp,
      client,
    )
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn head_occipital_frontal_circumference_percentile_search(
  sp: r4us_sansio.SpHeadOccipitalFrontalCircumferencePercentile,
  client: FhirClient,
) -> Result(List(r4us.HeadOccipitalFrontalCircumferencePercentile), Err) {
  let req =
    r4us_sansio.head_occipital_frontal_circumference_percentile_search_req(
      sp,
      client,
    )
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.head_occipital_frontal_circumference_percentile
  })
}

pub fn us_core_average_blood_pressure_create(
  resource: r4us.UsCoreAverageBloodPressure,
  client: FhirClient,
) -> Result(r4us.UsCoreAverageBloodPressure, Err) {
  any_create(
    r4us.us_core_average_blood_pressure_to_json(resource),
    "Observation",
    r4us.us_core_average_blood_pressure_decoder(),
    client,
  )
}

pub fn us_core_average_blood_pressure_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreAverageBloodPressure, Err) {
  any_read(
    id,
    client,
    "Observation",
    r4us.us_core_average_blood_pressure_decoder(),
  )
}

pub fn us_core_average_blood_pressure_update(
  resource: r4us.UsCoreAverageBloodPressure,
  client: FhirClient,
) -> Result(r4us.UsCoreAverageBloodPressure, Err) {
  any_update(
    resource.id,
    r4us.us_core_average_blood_pressure_to_json(resource),
    "Observation",
    r4us.us_core_average_blood_pressure_decoder(),
    client,
  )
}

pub fn us_core_average_blood_pressure_delete(
  resource: r4us.UsCoreAverageBloodPressure,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Observation", client)
}

pub fn us_core_average_blood_pressure_search_bundled(
  sp: r4us_sansio.SpUsCoreAverageBloodPressure,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_average_blood_pressure_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_average_blood_pressure_search(
  sp: r4us_sansio.SpUsCoreAverageBloodPressure,
  client: FhirClient,
) -> Result(List(r4us.UsCoreAverageBloodPressure), Err) {
  let req = r4us_sansio.us_core_average_blood_pressure_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_average_blood_pressure
  })
}

pub fn us_core_observation_adi_documentation_create(
  resource: r4us.UsCoreObservationAdiDocumentation,
  client: FhirClient,
) -> Result(r4us.UsCoreObservationAdiDocumentation, Err) {
  any_create(
    r4us.us_core_observation_adi_documentation_to_json(resource),
    "Observation",
    r4us.us_core_observation_adi_documentation_decoder(),
    client,
  )
}

pub fn us_core_observation_adi_documentation_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreObservationAdiDocumentation, Err) {
  any_read(
    id,
    client,
    "Observation",
    r4us.us_core_observation_adi_documentation_decoder(),
  )
}

pub fn us_core_observation_adi_documentation_update(
  resource: r4us.UsCoreObservationAdiDocumentation,
  client: FhirClient,
) -> Result(r4us.UsCoreObservationAdiDocumentation, Err) {
  any_update(
    resource.id,
    r4us.us_core_observation_adi_documentation_to_json(resource),
    "Observation",
    r4us.us_core_observation_adi_documentation_decoder(),
    client,
  )
}

pub fn us_core_observation_adi_documentation_delete(
  resource: r4us.UsCoreObservationAdiDocumentation,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Observation", client)
}

pub fn us_core_observation_adi_documentation_search_bundled(
  sp: r4us_sansio.SpUsCoreObservationAdiDocumentation,
  client: FhirClient,
) {
  let req =
    r4us_sansio.us_core_observation_adi_documentation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_observation_adi_documentation_search(
  sp: r4us_sansio.SpUsCoreObservationAdiDocumentation,
  client: FhirClient,
) -> Result(List(r4us.UsCoreObservationAdiDocumentation), Err) {
  let req =
    r4us_sansio.us_core_observation_adi_documentation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_observation_adi_documentation
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "ObservationDefinition", client)
}

pub fn observationdefinition_search_bundled(
  sp: r4us_sansio.SpObservationdefinition,
  client: FhirClient,
) {
  let req = r4us_sansio.observationdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn observationdefinition_search(
  sp: r4us_sansio.SpObservationdefinition,
  client: FhirClient,
) -> Result(List(r4us.Observationdefinition), Err) {
  let req = r4us_sansio.observationdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "OperationDefinition", client)
}

pub fn operationdefinition_search_bundled(
  sp: r4us_sansio.SpOperationdefinition,
  client: FhirClient,
) {
  let req = r4us_sansio.operationdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn operationdefinition_search(
  sp: r4us_sansio.SpOperationdefinition,
  client: FhirClient,
) -> Result(List(r4us.Operationdefinition), Err) {
  let req = r4us_sansio.operationdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "OperationOutcome", client)
}

pub fn operationoutcome_search_bundled(
  sp: r4us_sansio.SpOperationoutcome,
  client: FhirClient,
) {
  let req = r4us_sansio.operationoutcome_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn operationoutcome_search(
  sp: r4us_sansio.SpOperationoutcome,
  client: FhirClient,
) -> Result(List(r4us.Operationoutcome), Err) {
  let req = r4us_sansio.operationoutcome_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.operationoutcome
  })
}

pub fn us_core_organization_create(
  resource: r4us.UsCoreOrganization,
  client: FhirClient,
) -> Result(r4us.UsCoreOrganization, Err) {
  any_create(
    r4us.us_core_organization_to_json(resource),
    "Organization",
    r4us.us_core_organization_decoder(),
    client,
  )
}

pub fn us_core_organization_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreOrganization, Err) {
  any_read(id, client, "Organization", r4us.us_core_organization_decoder())
}

pub fn us_core_organization_update(
  resource: r4us.UsCoreOrganization,
  client: FhirClient,
) -> Result(r4us.UsCoreOrganization, Err) {
  any_update(
    resource.id,
    r4us.us_core_organization_to_json(resource),
    "Organization",
    r4us.us_core_organization_decoder(),
    client,
  )
}

pub fn us_core_organization_delete(
  resource: r4us.UsCoreOrganization,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Organization", client)
}

pub fn us_core_organization_search_bundled(
  sp: r4us_sansio.SpUsCoreOrganization,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_organization_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_organization_search(
  sp: r4us_sansio.SpUsCoreOrganization,
  client: FhirClient,
) -> Result(List(r4us.UsCoreOrganization), Err) {
  let req = r4us_sansio.us_core_organization_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_organization
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "OrganizationAffiliation", client)
}

pub fn organizationaffiliation_search_bundled(
  sp: r4us_sansio.SpOrganizationaffiliation,
  client: FhirClient,
) {
  let req = r4us_sansio.organizationaffiliation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn organizationaffiliation_search(
  sp: r4us_sansio.SpOrganizationaffiliation,
  client: FhirClient,
) -> Result(List(r4us.Organizationaffiliation), Err) {
  let req = r4us_sansio.organizationaffiliation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.organizationaffiliation
  })
}

pub fn us_core_patient_create(
  resource: r4us.UsCorePatient,
  client: FhirClient,
) -> Result(r4us.UsCorePatient, Err) {
  any_create(
    r4us.us_core_patient_to_json(resource),
    "Patient",
    r4us.us_core_patient_decoder(),
    client,
  )
}

pub fn us_core_patient_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCorePatient, Err) {
  any_read(id, client, "Patient", r4us.us_core_patient_decoder())
}

pub fn us_core_patient_update(
  resource: r4us.UsCorePatient,
  client: FhirClient,
) -> Result(r4us.UsCorePatient, Err) {
  any_update(
    resource.id,
    r4us.us_core_patient_to_json(resource),
    "Patient",
    r4us.us_core_patient_decoder(),
    client,
  )
}

pub fn us_core_patient_delete(
  resource: r4us.UsCorePatient,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Patient", client)
}

pub fn us_core_patient_search_bundled(
  sp: r4us_sansio.SpUsCorePatient,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_patient_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_patient_search(
  sp: r4us_sansio.SpUsCorePatient,
  client: FhirClient,
) -> Result(List(r4us.UsCorePatient), Err) {
  let req = r4us_sansio.us_core_patient_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_patient
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "PaymentNotice", client)
}

pub fn paymentnotice_search_bundled(
  sp: r4us_sansio.SpPaymentnotice,
  client: FhirClient,
) {
  let req = r4us_sansio.paymentnotice_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn paymentnotice_search(
  sp: r4us_sansio.SpPaymentnotice,
  client: FhirClient,
) -> Result(List(r4us.Paymentnotice), Err) {
  let req = r4us_sansio.paymentnotice_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "PaymentReconciliation", client)
}

pub fn paymentreconciliation_search_bundled(
  sp: r4us_sansio.SpPaymentreconciliation,
  client: FhirClient,
) {
  let req = r4us_sansio.paymentreconciliation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn paymentreconciliation_search(
  sp: r4us_sansio.SpPaymentreconciliation,
  client: FhirClient,
) -> Result(List(r4us.Paymentreconciliation), Err) {
  let req = r4us_sansio.paymentreconciliation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Person", client)
}

pub fn person_search_bundled(sp: r4us_sansio.SpPerson, client: FhirClient) {
  let req = r4us_sansio.person_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn person_search(
  sp: r4us_sansio.SpPerson,
  client: FhirClient,
) -> Result(List(r4us.Person), Err) {
  let req = r4us_sansio.person_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "PlanDefinition", client)
}

pub fn plandefinition_search_bundled(
  sp: r4us_sansio.SpPlandefinition,
  client: FhirClient,
) {
  let req = r4us_sansio.plandefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn plandefinition_search(
  sp: r4us_sansio.SpPlandefinition,
  client: FhirClient,
) -> Result(List(r4us.Plandefinition), Err) {
  let req = r4us_sansio.plandefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.plandefinition
  })
}

pub fn us_core_practitioner_create(
  resource: r4us.UsCorePractitioner,
  client: FhirClient,
) -> Result(r4us.UsCorePractitioner, Err) {
  any_create(
    r4us.us_core_practitioner_to_json(resource),
    "Practitioner",
    r4us.us_core_practitioner_decoder(),
    client,
  )
}

pub fn us_core_practitioner_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCorePractitioner, Err) {
  any_read(id, client, "Practitioner", r4us.us_core_practitioner_decoder())
}

pub fn us_core_practitioner_update(
  resource: r4us.UsCorePractitioner,
  client: FhirClient,
) -> Result(r4us.UsCorePractitioner, Err) {
  any_update(
    resource.id,
    r4us.us_core_practitioner_to_json(resource),
    "Practitioner",
    r4us.us_core_practitioner_decoder(),
    client,
  )
}

pub fn us_core_practitioner_delete(
  resource: r4us.UsCorePractitioner,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Practitioner", client)
}

pub fn us_core_practitioner_search_bundled(
  sp: r4us_sansio.SpUsCorePractitioner,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_practitioner_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_practitioner_search(
  sp: r4us_sansio.SpUsCorePractitioner,
  client: FhirClient,
) -> Result(List(r4us.UsCorePractitioner), Err) {
  let req = r4us_sansio.us_core_practitioner_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_practitioner
  })
}

pub fn us_core_practitionerrole_create(
  resource: r4us.UsCorePractitionerrole,
  client: FhirClient,
) -> Result(r4us.UsCorePractitionerrole, Err) {
  any_create(
    r4us.us_core_practitionerrole_to_json(resource),
    "PractitionerRole",
    r4us.us_core_practitionerrole_decoder(),
    client,
  )
}

pub fn us_core_practitionerrole_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCorePractitionerrole, Err) {
  any_read(
    id,
    client,
    "PractitionerRole",
    r4us.us_core_practitionerrole_decoder(),
  )
}

pub fn us_core_practitionerrole_update(
  resource: r4us.UsCorePractitionerrole,
  client: FhirClient,
) -> Result(r4us.UsCorePractitionerrole, Err) {
  any_update(
    resource.id,
    r4us.us_core_practitionerrole_to_json(resource),
    "PractitionerRole",
    r4us.us_core_practitionerrole_decoder(),
    client,
  )
}

pub fn us_core_practitionerrole_delete(
  resource: r4us.UsCorePractitionerrole,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "PractitionerRole", client)
}

pub fn us_core_practitionerrole_search_bundled(
  sp: r4us_sansio.SpUsCorePractitionerrole,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_practitionerrole_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_practitionerrole_search(
  sp: r4us_sansio.SpUsCorePractitionerrole,
  client: FhirClient,
) -> Result(List(r4us.UsCorePractitionerrole), Err) {
  let req = r4us_sansio.us_core_practitionerrole_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_practitionerrole
  })
}

pub fn us_core_procedure_create(
  resource: r4us.UsCoreProcedure,
  client: FhirClient,
) -> Result(r4us.UsCoreProcedure, Err) {
  any_create(
    r4us.us_core_procedure_to_json(resource),
    "Procedure",
    r4us.us_core_procedure_decoder(),
    client,
  )
}

pub fn us_core_procedure_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreProcedure, Err) {
  any_read(id, client, "Procedure", r4us.us_core_procedure_decoder())
}

pub fn us_core_procedure_update(
  resource: r4us.UsCoreProcedure,
  client: FhirClient,
) -> Result(r4us.UsCoreProcedure, Err) {
  any_update(
    resource.id,
    r4us.us_core_procedure_to_json(resource),
    "Procedure",
    r4us.us_core_procedure_decoder(),
    client,
  )
}

pub fn us_core_procedure_delete(
  resource: r4us.UsCoreProcedure,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Procedure", client)
}

pub fn us_core_procedure_search_bundled(
  sp: r4us_sansio.SpUsCoreProcedure,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_procedure_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_procedure_search(
  sp: r4us_sansio.SpUsCoreProcedure,
  client: FhirClient,
) -> Result(List(r4us.UsCoreProcedure), Err) {
  let req = r4us_sansio.us_core_procedure_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_procedure
  })
}

pub fn us_core_provenance_create(
  resource: r4us.UsCoreProvenance,
  client: FhirClient,
) -> Result(r4us.UsCoreProvenance, Err) {
  any_create(
    r4us.us_core_provenance_to_json(resource),
    "Provenance",
    r4us.us_core_provenance_decoder(),
    client,
  )
}

pub fn us_core_provenance_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreProvenance, Err) {
  any_read(id, client, "Provenance", r4us.us_core_provenance_decoder())
}

pub fn us_core_provenance_update(
  resource: r4us.UsCoreProvenance,
  client: FhirClient,
) -> Result(r4us.UsCoreProvenance, Err) {
  any_update(
    resource.id,
    r4us.us_core_provenance_to_json(resource),
    "Provenance",
    r4us.us_core_provenance_decoder(),
    client,
  )
}

pub fn us_core_provenance_delete(
  resource: r4us.UsCoreProvenance,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Provenance", client)
}

pub fn us_core_provenance_search_bundled(
  sp: r4us_sansio.SpUsCoreProvenance,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_provenance_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_provenance_search(
  sp: r4us_sansio.SpUsCoreProvenance,
  client: FhirClient,
) -> Result(List(r4us.UsCoreProvenance), Err) {
  let req = r4us_sansio.us_core_provenance_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_provenance
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Questionnaire", client)
}

pub fn questionnaire_search_bundled(
  sp: r4us_sansio.SpQuestionnaire,
  client: FhirClient,
) {
  let req = r4us_sansio.questionnaire_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn questionnaire_search(
  sp: r4us_sansio.SpQuestionnaire,
  client: FhirClient,
) -> Result(List(r4us.Questionnaire), Err) {
  let req = r4us_sansio.questionnaire_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.questionnaire
  })
}

pub fn us_core_questionnaireresponse_create(
  resource: r4us.UsCoreQuestionnaireresponse,
  client: FhirClient,
) -> Result(r4us.UsCoreQuestionnaireresponse, Err) {
  any_create(
    r4us.us_core_questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    r4us.us_core_questionnaireresponse_decoder(),
    client,
  )
}

pub fn us_core_questionnaireresponse_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreQuestionnaireresponse, Err) {
  any_read(
    id,
    client,
    "QuestionnaireResponse",
    r4us.us_core_questionnaireresponse_decoder(),
  )
}

pub fn us_core_questionnaireresponse_update(
  resource: r4us.UsCoreQuestionnaireresponse,
  client: FhirClient,
) -> Result(r4us.UsCoreQuestionnaireresponse, Err) {
  any_update(
    resource.id,
    r4us.us_core_questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    r4us.us_core_questionnaireresponse_decoder(),
    client,
  )
}

pub fn us_core_questionnaireresponse_delete(
  resource: r4us.UsCoreQuestionnaireresponse,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "QuestionnaireResponse", client)
}

pub fn us_core_questionnaireresponse_search_bundled(
  sp: r4us_sansio.SpUsCoreQuestionnaireresponse,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_questionnaireresponse_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_questionnaireresponse_search(
  sp: r4us_sansio.SpUsCoreQuestionnaireresponse,
  client: FhirClient,
) -> Result(List(r4us.UsCoreQuestionnaireresponse), Err) {
  let req = r4us_sansio.us_core_questionnaireresponse_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_questionnaireresponse
  })
}

pub fn us_core_relatedperson_create(
  resource: r4us.UsCoreRelatedperson,
  client: FhirClient,
) -> Result(r4us.UsCoreRelatedperson, Err) {
  any_create(
    r4us.us_core_relatedperson_to_json(resource),
    "RelatedPerson",
    r4us.us_core_relatedperson_decoder(),
    client,
  )
}

pub fn us_core_relatedperson_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreRelatedperson, Err) {
  any_read(id, client, "RelatedPerson", r4us.us_core_relatedperson_decoder())
}

pub fn us_core_relatedperson_update(
  resource: r4us.UsCoreRelatedperson,
  client: FhirClient,
) -> Result(r4us.UsCoreRelatedperson, Err) {
  any_update(
    resource.id,
    r4us.us_core_relatedperson_to_json(resource),
    "RelatedPerson",
    r4us.us_core_relatedperson_decoder(),
    client,
  )
}

pub fn us_core_relatedperson_delete(
  resource: r4us.UsCoreRelatedperson,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "RelatedPerson", client)
}

pub fn us_core_relatedperson_search_bundled(
  sp: r4us_sansio.SpUsCoreRelatedperson,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_relatedperson_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_relatedperson_search(
  sp: r4us_sansio.SpUsCoreRelatedperson,
  client: FhirClient,
) -> Result(List(r4us.UsCoreRelatedperson), Err) {
  let req = r4us_sansio.us_core_relatedperson_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_relatedperson
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "RequestGroup", client)
}

pub fn requestgroup_search_bundled(
  sp: r4us_sansio.SpRequestgroup,
  client: FhirClient,
) {
  let req = r4us_sansio.requestgroup_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn requestgroup_search(
  sp: r4us_sansio.SpRequestgroup,
  client: FhirClient,
) -> Result(List(r4us.Requestgroup), Err) {
  let req = r4us_sansio.requestgroup_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "ResearchDefinition", client)
}

pub fn researchdefinition_search_bundled(
  sp: r4us_sansio.SpResearchdefinition,
  client: FhirClient,
) {
  let req = r4us_sansio.researchdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn researchdefinition_search(
  sp: r4us_sansio.SpResearchdefinition,
  client: FhirClient,
) -> Result(List(r4us.Researchdefinition), Err) {
  let req = r4us_sansio.researchdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "ResearchElementDefinition", client)
}

pub fn researchelementdefinition_search_bundled(
  sp: r4us_sansio.SpResearchelementdefinition,
  client: FhirClient,
) {
  let req = r4us_sansio.researchelementdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn researchelementdefinition_search(
  sp: r4us_sansio.SpResearchelementdefinition,
  client: FhirClient,
) -> Result(List(r4us.Researchelementdefinition), Err) {
  let req = r4us_sansio.researchelementdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "ResearchStudy", client)
}

pub fn researchstudy_search_bundled(
  sp: r4us_sansio.SpResearchstudy,
  client: FhirClient,
) {
  let req = r4us_sansio.researchstudy_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn researchstudy_search(
  sp: r4us_sansio.SpResearchstudy,
  client: FhirClient,
) -> Result(List(r4us.Researchstudy), Err) {
  let req = r4us_sansio.researchstudy_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "ResearchSubject", client)
}

pub fn researchsubject_search_bundled(
  sp: r4us_sansio.SpResearchsubject,
  client: FhirClient,
) {
  let req = r4us_sansio.researchsubject_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn researchsubject_search(
  sp: r4us_sansio.SpResearchsubject,
  client: FhirClient,
) -> Result(List(r4us.Researchsubject), Err) {
  let req = r4us_sansio.researchsubject_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "RiskAssessment", client)
}

pub fn riskassessment_search_bundled(
  sp: r4us_sansio.SpRiskassessment,
  client: FhirClient,
) {
  let req = r4us_sansio.riskassessment_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn riskassessment_search(
  sp: r4us_sansio.SpRiskassessment,
  client: FhirClient,
) -> Result(List(r4us.Riskassessment), Err) {
  let req = r4us_sansio.riskassessment_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "RiskEvidenceSynthesis", client)
}

pub fn riskevidencesynthesis_search_bundled(
  sp: r4us_sansio.SpRiskevidencesynthesis,
  client: FhirClient,
) {
  let req = r4us_sansio.riskevidencesynthesis_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn riskevidencesynthesis_search(
  sp: r4us_sansio.SpRiskevidencesynthesis,
  client: FhirClient,
) -> Result(List(r4us.Riskevidencesynthesis), Err) {
  let req = r4us_sansio.riskevidencesynthesis_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Schedule", client)
}

pub fn schedule_search_bundled(sp: r4us_sansio.SpSchedule, client: FhirClient) {
  let req = r4us_sansio.schedule_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn schedule_search(
  sp: r4us_sansio.SpSchedule,
  client: FhirClient,
) -> Result(List(r4us.Schedule), Err) {
  let req = r4us_sansio.schedule_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "SearchParameter", client)
}

pub fn searchparameter_search_bundled(
  sp: r4us_sansio.SpSearchparameter,
  client: FhirClient,
) {
  let req = r4us_sansio.searchparameter_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn searchparameter_search(
  sp: r4us_sansio.SpSearchparameter,
  client: FhirClient,
) -> Result(List(r4us.Searchparameter), Err) {
  let req = r4us_sansio.searchparameter_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.searchparameter
  })
}

pub fn us_core_servicerequest_create(
  resource: r4us.UsCoreServicerequest,
  client: FhirClient,
) -> Result(r4us.UsCoreServicerequest, Err) {
  any_create(
    r4us.us_core_servicerequest_to_json(resource),
    "ServiceRequest",
    r4us.us_core_servicerequest_decoder(),
    client,
  )
}

pub fn us_core_servicerequest_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreServicerequest, Err) {
  any_read(id, client, "ServiceRequest", r4us.us_core_servicerequest_decoder())
}

pub fn us_core_servicerequest_update(
  resource: r4us.UsCoreServicerequest,
  client: FhirClient,
) -> Result(r4us.UsCoreServicerequest, Err) {
  any_update(
    resource.id,
    r4us.us_core_servicerequest_to_json(resource),
    "ServiceRequest",
    r4us.us_core_servicerequest_decoder(),
    client,
  )
}

pub fn us_core_servicerequest_delete(
  resource: r4us.UsCoreServicerequest,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "ServiceRequest", client)
}

pub fn us_core_servicerequest_search_bundled(
  sp: r4us_sansio.SpUsCoreServicerequest,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_servicerequest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_servicerequest_search(
  sp: r4us_sansio.SpUsCoreServicerequest,
  client: FhirClient,
) -> Result(List(r4us.UsCoreServicerequest), Err) {
  let req = r4us_sansio.us_core_servicerequest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_servicerequest
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Slot", client)
}

pub fn slot_search_bundled(sp: r4us_sansio.SpSlot, client: FhirClient) {
  let req = r4us_sansio.slot_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn slot_search(
  sp: r4us_sansio.SpSlot,
  client: FhirClient,
) -> Result(List(r4us.Slot), Err) {
  let req = r4us_sansio.slot_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.slot
  })
}

pub fn us_core_specimen_create(
  resource: r4us.UsCoreSpecimen,
  client: FhirClient,
) -> Result(r4us.UsCoreSpecimen, Err) {
  any_create(
    r4us.us_core_specimen_to_json(resource),
    "Specimen",
    r4us.us_core_specimen_decoder(),
    client,
  )
}

pub fn us_core_specimen_read(
  id: String,
  client: FhirClient,
) -> Result(r4us.UsCoreSpecimen, Err) {
  any_read(id, client, "Specimen", r4us.us_core_specimen_decoder())
}

pub fn us_core_specimen_update(
  resource: r4us.UsCoreSpecimen,
  client: FhirClient,
) -> Result(r4us.UsCoreSpecimen, Err) {
  any_update(
    resource.id,
    r4us.us_core_specimen_to_json(resource),
    "Specimen",
    r4us.us_core_specimen_decoder(),
    client,
  )
}

pub fn us_core_specimen_delete(
  resource: r4us.UsCoreSpecimen,
  client: FhirClient,
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Specimen", client)
}

pub fn us_core_specimen_search_bundled(
  sp: r4us_sansio.SpUsCoreSpecimen,
  client: FhirClient,
) {
  let req = r4us_sansio.us_core_specimen_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn us_core_specimen_search(
  sp: r4us_sansio.SpUsCoreSpecimen,
  client: FhirClient,
) -> Result(List(r4us.UsCoreSpecimen), Err) {
  let req = r4us_sansio.us_core_specimen_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.us_core_specimen
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "SpecimenDefinition", client)
}

pub fn specimendefinition_search_bundled(
  sp: r4us_sansio.SpSpecimendefinition,
  client: FhirClient,
) {
  let req = r4us_sansio.specimendefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn specimendefinition_search(
  sp: r4us_sansio.SpSpecimendefinition,
  client: FhirClient,
) -> Result(List(r4us.Specimendefinition), Err) {
  let req = r4us_sansio.specimendefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "StructureDefinition", client)
}

pub fn structuredefinition_search_bundled(
  sp: r4us_sansio.SpStructuredefinition,
  client: FhirClient,
) {
  let req = r4us_sansio.structuredefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn structuredefinition_search(
  sp: r4us_sansio.SpStructuredefinition,
  client: FhirClient,
) -> Result(List(r4us.Structuredefinition), Err) {
  let req = r4us_sansio.structuredefinition_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "StructureMap", client)
}

pub fn structuremap_search_bundled(
  sp: r4us_sansio.SpStructuremap,
  client: FhirClient,
) {
  let req = r4us_sansio.structuremap_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn structuremap_search(
  sp: r4us_sansio.SpStructuremap,
  client: FhirClient,
) -> Result(List(r4us.Structuremap), Err) {
  let req = r4us_sansio.structuremap_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Subscription", client)
}

pub fn subscription_search_bundled(
  sp: r4us_sansio.SpSubscription,
  client: FhirClient,
) {
  let req = r4us_sansio.subscription_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn subscription_search(
  sp: r4us_sansio.SpSubscription,
  client: FhirClient,
) -> Result(List(r4us.Subscription), Err) {
  let req = r4us_sansio.subscription_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Substance", client)
}

pub fn substance_search_bundled(sp: r4us_sansio.SpSubstance, client: FhirClient) {
  let req = r4us_sansio.substance_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn substance_search(
  sp: r4us_sansio.SpSubstance,
  client: FhirClient,
) -> Result(List(r4us.Substance), Err) {
  let req = r4us_sansio.substance_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "SubstanceNucleicAcid", client)
}

pub fn substancenucleicacid_search_bundled(
  sp: r4us_sansio.SpSubstancenucleicacid,
  client: FhirClient,
) {
  let req = r4us_sansio.substancenucleicacid_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn substancenucleicacid_search(
  sp: r4us_sansio.SpSubstancenucleicacid,
  client: FhirClient,
) -> Result(List(r4us.Substancenucleicacid), Err) {
  let req = r4us_sansio.substancenucleicacid_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "SubstancePolymer", client)
}

pub fn substancepolymer_search_bundled(
  sp: r4us_sansio.SpSubstancepolymer,
  client: FhirClient,
) {
  let req = r4us_sansio.substancepolymer_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn substancepolymer_search(
  sp: r4us_sansio.SpSubstancepolymer,
  client: FhirClient,
) -> Result(List(r4us.Substancepolymer), Err) {
  let req = r4us_sansio.substancepolymer_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "SubstanceProtein", client)
}

pub fn substanceprotein_search_bundled(
  sp: r4us_sansio.SpSubstanceprotein,
  client: FhirClient,
) {
  let req = r4us_sansio.substanceprotein_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn substanceprotein_search(
  sp: r4us_sansio.SpSubstanceprotein,
  client: FhirClient,
) -> Result(List(r4us.Substanceprotein), Err) {
  let req = r4us_sansio.substanceprotein_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "SubstanceReferenceInformation", client)
}

pub fn substancereferenceinformation_search_bundled(
  sp: r4us_sansio.SpSubstancereferenceinformation,
  client: FhirClient,
) {
  let req = r4us_sansio.substancereferenceinformation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn substancereferenceinformation_search(
  sp: r4us_sansio.SpSubstancereferenceinformation,
  client: FhirClient,
) -> Result(List(r4us.Substancereferenceinformation), Err) {
  let req = r4us_sansio.substancereferenceinformation_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "SubstanceSourceMaterial", client)
}

pub fn substancesourcematerial_search_bundled(
  sp: r4us_sansio.SpSubstancesourcematerial,
  client: FhirClient,
) {
  let req = r4us_sansio.substancesourcematerial_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn substancesourcematerial_search(
  sp: r4us_sansio.SpSubstancesourcematerial,
  client: FhirClient,
) -> Result(List(r4us.Substancesourcematerial), Err) {
  let req = r4us_sansio.substancesourcematerial_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "SubstanceSpecification", client)
}

pub fn substancespecification_search_bundled(
  sp: r4us_sansio.SpSubstancespecification,
  client: FhirClient,
) {
  let req = r4us_sansio.substancespecification_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn substancespecification_search(
  sp: r4us_sansio.SpSubstancespecification,
  client: FhirClient,
) -> Result(List(r4us.Substancespecification), Err) {
  let req = r4us_sansio.substancespecification_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "SupplyDelivery", client)
}

pub fn supplydelivery_search_bundled(
  sp: r4us_sansio.SpSupplydelivery,
  client: FhirClient,
) {
  let req = r4us_sansio.supplydelivery_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn supplydelivery_search(
  sp: r4us_sansio.SpSupplydelivery,
  client: FhirClient,
) -> Result(List(r4us.Supplydelivery), Err) {
  let req = r4us_sansio.supplydelivery_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "SupplyRequest", client)
}

pub fn supplyrequest_search_bundled(
  sp: r4us_sansio.SpSupplyrequest,
  client: FhirClient,
) {
  let req = r4us_sansio.supplyrequest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn supplyrequest_search(
  sp: r4us_sansio.SpSupplyrequest,
  client: FhirClient,
) -> Result(List(r4us.Supplyrequest), Err) {
  let req = r4us_sansio.supplyrequest_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "Task", client)
}

pub fn task_search_bundled(sp: r4us_sansio.SpTask, client: FhirClient) {
  let req = r4us_sansio.task_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn task_search(
  sp: r4us_sansio.SpTask,
  client: FhirClient,
) -> Result(List(r4us.Task), Err) {
  let req = r4us_sansio.task_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "TerminologyCapabilities", client)
}

pub fn terminologycapabilities_search_bundled(
  sp: r4us_sansio.SpTerminologycapabilities,
  client: FhirClient,
) {
  let req = r4us_sansio.terminologycapabilities_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn terminologycapabilities_search(
  sp: r4us_sansio.SpTerminologycapabilities,
  client: FhirClient,
) -> Result(List(r4us.Terminologycapabilities), Err) {
  let req = r4us_sansio.terminologycapabilities_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "TestReport", client)
}

pub fn testreport_search_bundled(
  sp: r4us_sansio.SpTestreport,
  client: FhirClient,
) {
  let req = r4us_sansio.testreport_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn testreport_search(
  sp: r4us_sansio.SpTestreport,
  client: FhirClient,
) -> Result(List(r4us.Testreport), Err) {
  let req = r4us_sansio.testreport_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "TestScript", client)
}

pub fn testscript_search_bundled(
  sp: r4us_sansio.SpTestscript,
  client: FhirClient,
) {
  let req = r4us_sansio.testscript_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn testscript_search(
  sp: r4us_sansio.SpTestscript,
  client: FhirClient,
) -> Result(List(r4us.Testscript), Err) {
  let req = r4us_sansio.testscript_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "ValueSet", client)
}

pub fn valueset_search_bundled(sp: r4us_sansio.SpValueset, client: FhirClient) {
  let req = r4us_sansio.valueset_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn valueset_search(
  sp: r4us_sansio.SpValueset,
  client: FhirClient,
) -> Result(List(r4us.Valueset), Err) {
  let req = r4us_sansio.valueset_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "VerificationResult", client)
}

pub fn verificationresult_search_bundled(
  sp: r4us_sansio.SpVerificationresult,
  client: FhirClient,
) {
  let req = r4us_sansio.verificationresult_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn verificationresult_search(
  sp: r4us_sansio.SpVerificationresult,
  client: FhirClient,
) -> Result(List(r4us.Verificationresult), Err) {
  let req = r4us_sansio.verificationresult_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
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
) -> Result(r4us.Operationoutcome, Err) {
  any_delete(resource.id, "VisionPrescription", client)
}

pub fn visionprescription_search_bundled(
  sp: r4us_sansio.SpVisionprescription,
  client: FhirClient,
) {
  let req = r4us_sansio.visionprescription_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
}

pub fn visionprescription_search(
  sp: r4us_sansio.SpVisionprescription,
  client: FhirClient,
) -> Result(List(r4us.Visionprescription), Err) {
  let req = r4us_sansio.visionprescription_search_req(sp, client)
  sendreq_parseresource(req, r4us.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4us_sansio.bundle_to_groupedresources }.visionprescription
  })
}
