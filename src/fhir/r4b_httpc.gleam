////[https://hl7.org/fhir/r4b](https://hl7.org/fhir/r4b) r4b client using httpc

import fhir/r4b
import fhir/r4b_sansio
import gleam/dynamic/decode.{type Decoder}
import gleam/http/request.{type Request}
import gleam/httpc
import gleam/json.{type Json}
import gleam/option.{type Option}
import gleam/result

/// FHIR client for sending http requests to server such as
/// `let pat = r4b.patient_read("123", client)`
///
/// create client from server base url with fhirclient_new(baseurl)`
///
/// `let assert Ok(client) = r4b_httpc.fhirclient_new("r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = r4b_httpc.fhirclient_new("https://r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = r4b_httpc.fhirclient_new("https://hapi.fhir.org/baseR4")`
///
/// `let assert Ok(client) = r4b_httpc.fhirclient_new("127.0.0.1:8000")`
pub type FhirClient =
  r4b_sansio.FhirClient

/// creates a new client from server base url
///
/// `let assert Ok(client) = r4b_httpc.fhirclient_new("r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = r4b_httpc.fhirclient_new("https://r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = r4b_httpc.fhirclient_new("https://hapi.fhir.org/baseR4")`
///
/// `let assert Ok(client) = r4b_httpc.fhirclient_new("127.0.0.1:8000")`
pub fn fhirclient_new(
  baseurl: String,
) -> Result(FhirClient, r4b_sansio.ErrBaseUrl) {
  r4b_sansio.fhirclient_new(baseurl)
}

pub type Err {
  ErrHttpc(httpc.HttpError)
  ErrSansio(err: r4b_sansio.Err)
}

fn any_create(
  resource: Json,
  res_type: String,
  resource_dec: Decoder(r),
  client: FhirClient,
) -> Result(r, Err) {
  let req = r4b_sansio.any_create_req(resource, res_type, client)
  sendreq_parseresource(req, resource_dec)
}

fn any_read(
  id: String,
  client: FhirClient,
  res_type: String,
  resource_dec: Decoder(a),
) -> Result(a, Err) {
  let req = r4b_sansio.any_read_req(id, res_type, client)
  sendreq_parseresource(req, resource_dec)
}

fn any_update(
  id: Option(String),
  resource: Json,
  res_type: String,
  res_dec: Decoder(r),
  client: FhirClient,
) -> Result(r, Err) {
  let req = r4b_sansio.any_update_req(id, resource, res_type, client)
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
) -> Result(r4b.Operationoutcome, Err) {
  let req = r4b_sansio.any_delete_req(id, res_type, client)
  case req {
    Ok(req) -> sendreq_parseresource(req, r4b.operationoutcome_decoder())
    Error(err) -> Error(ErrSansio(err))
    //can have error preparing delete request if resource has no id
  }
}

/// write out search string manually, in case typed search params don't work
pub fn search_any(
  search_string: String,
  res_type: String,
  client: FhirClient,
) -> Result(r4b.Bundle, Err) {
  let req = r4b_sansio.any_search_req(search_string, res_type, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

/// run any operation string on any resource string, optionally using Parameters
pub fn operation_any(
  params params: Option(r4b.Parameters),
  operation_name operation_name: String,
  res_type res_type: String,
  res_id res_id: Option(String),
  res_decoder res_decoder: Decoder(res),
  client client: FhirClient,
) -> Result(res, Err) {
  let req =
    r4b_sansio.any_operation_req(
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
      case r4b_sansio.any_resp(resp, res_dec) {
        Ok(resource) -> Ok(resource)
        Error(err) -> Error(ErrSansio(err))
      }
  }
}

pub fn account_create(
  resource: r4b.Account,
  client: FhirClient,
) -> Result(r4b.Account, Err) {
  any_create(
    r4b.account_to_json(resource),
    "Account",
    r4b.account_decoder(),
    client,
  )
}

pub fn account_read(id: String, client: FhirClient) -> Result(r4b.Account, Err) {
  any_read(id, client, "Account", r4b.account_decoder())
}

pub fn account_update(
  resource: r4b.Account,
  client: FhirClient,
) -> Result(r4b.Account, Err) {
  any_update(
    resource.id,
    r4b.account_to_json(resource),
    "Account",
    r4b.account_decoder(),
    client,
  )
}

pub fn account_delete(
  resource: r4b.Account,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Account", client)
}

pub fn account_search_bundled(sp: r4b_sansio.SpAccount, client: FhirClient) {
  let req = r4b_sansio.account_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn account_search(
  sp: r4b_sansio.SpAccount,
  client: FhirClient,
) -> Result(List(r4b.Account), Err) {
  let req = r4b_sansio.account_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.account
  })
}

pub fn activitydefinition_create(
  resource: r4b.Activitydefinition,
  client: FhirClient,
) -> Result(r4b.Activitydefinition, Err) {
  any_create(
    r4b.activitydefinition_to_json(resource),
    "ActivityDefinition",
    r4b.activitydefinition_decoder(),
    client,
  )
}

pub fn activitydefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Activitydefinition, Err) {
  any_read(id, client, "ActivityDefinition", r4b.activitydefinition_decoder())
}

pub fn activitydefinition_update(
  resource: r4b.Activitydefinition,
  client: FhirClient,
) -> Result(r4b.Activitydefinition, Err) {
  any_update(
    resource.id,
    r4b.activitydefinition_to_json(resource),
    "ActivityDefinition",
    r4b.activitydefinition_decoder(),
    client,
  )
}

pub fn activitydefinition_delete(
  resource: r4b.Activitydefinition,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "ActivityDefinition", client)
}

pub fn activitydefinition_search_bundled(
  sp: r4b_sansio.SpActivitydefinition,
  client: FhirClient,
) {
  let req = r4b_sansio.activitydefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn activitydefinition_search(
  sp: r4b_sansio.SpActivitydefinition,
  client: FhirClient,
) -> Result(List(r4b.Activitydefinition), Err) {
  let req = r4b_sansio.activitydefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.activitydefinition
  })
}

pub fn administrableproductdefinition_create(
  resource: r4b.Administrableproductdefinition,
  client: FhirClient,
) -> Result(r4b.Administrableproductdefinition, Err) {
  any_create(
    r4b.administrableproductdefinition_to_json(resource),
    "AdministrableProductDefinition",
    r4b.administrableproductdefinition_decoder(),
    client,
  )
}

pub fn administrableproductdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Administrableproductdefinition, Err) {
  any_read(
    id,
    client,
    "AdministrableProductDefinition",
    r4b.administrableproductdefinition_decoder(),
  )
}

pub fn administrableproductdefinition_update(
  resource: r4b.Administrableproductdefinition,
  client: FhirClient,
) -> Result(r4b.Administrableproductdefinition, Err) {
  any_update(
    resource.id,
    r4b.administrableproductdefinition_to_json(resource),
    "AdministrableProductDefinition",
    r4b.administrableproductdefinition_decoder(),
    client,
  )
}

pub fn administrableproductdefinition_delete(
  resource: r4b.Administrableproductdefinition,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "AdministrableProductDefinition", client)
}

pub fn administrableproductdefinition_search_bundled(
  sp: r4b_sansio.SpAdministrableproductdefinition,
  client: FhirClient,
) {
  let req = r4b_sansio.administrableproductdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn administrableproductdefinition_search(
  sp: r4b_sansio.SpAdministrableproductdefinition,
  client: FhirClient,
) -> Result(List(r4b.Administrableproductdefinition), Err) {
  let req = r4b_sansio.administrableproductdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.administrableproductdefinition
  })
}

pub fn adverseevent_create(
  resource: r4b.Adverseevent,
  client: FhirClient,
) -> Result(r4b.Adverseevent, Err) {
  any_create(
    r4b.adverseevent_to_json(resource),
    "AdverseEvent",
    r4b.adverseevent_decoder(),
    client,
  )
}

pub fn adverseevent_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Adverseevent, Err) {
  any_read(id, client, "AdverseEvent", r4b.adverseevent_decoder())
}

pub fn adverseevent_update(
  resource: r4b.Adverseevent,
  client: FhirClient,
) -> Result(r4b.Adverseevent, Err) {
  any_update(
    resource.id,
    r4b.adverseevent_to_json(resource),
    "AdverseEvent",
    r4b.adverseevent_decoder(),
    client,
  )
}

pub fn adverseevent_delete(
  resource: r4b.Adverseevent,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "AdverseEvent", client)
}

pub fn adverseevent_search_bundled(
  sp: r4b_sansio.SpAdverseevent,
  client: FhirClient,
) {
  let req = r4b_sansio.adverseevent_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn adverseevent_search(
  sp: r4b_sansio.SpAdverseevent,
  client: FhirClient,
) -> Result(List(r4b.Adverseevent), Err) {
  let req = r4b_sansio.adverseevent_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.adverseevent
  })
}

pub fn allergyintolerance_create(
  resource: r4b.Allergyintolerance,
  client: FhirClient,
) -> Result(r4b.Allergyintolerance, Err) {
  any_create(
    r4b.allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    r4b.allergyintolerance_decoder(),
    client,
  )
}

pub fn allergyintolerance_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Allergyintolerance, Err) {
  any_read(id, client, "AllergyIntolerance", r4b.allergyintolerance_decoder())
}

pub fn allergyintolerance_update(
  resource: r4b.Allergyintolerance,
  client: FhirClient,
) -> Result(r4b.Allergyintolerance, Err) {
  any_update(
    resource.id,
    r4b.allergyintolerance_to_json(resource),
    "AllergyIntolerance",
    r4b.allergyintolerance_decoder(),
    client,
  )
}

pub fn allergyintolerance_delete(
  resource: r4b.Allergyintolerance,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "AllergyIntolerance", client)
}

pub fn allergyintolerance_search_bundled(
  sp: r4b_sansio.SpAllergyintolerance,
  client: FhirClient,
) {
  let req = r4b_sansio.allergyintolerance_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn allergyintolerance_search(
  sp: r4b_sansio.SpAllergyintolerance,
  client: FhirClient,
) -> Result(List(r4b.Allergyintolerance), Err) {
  let req = r4b_sansio.allergyintolerance_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.allergyintolerance
  })
}

pub fn appointment_create(
  resource: r4b.Appointment,
  client: FhirClient,
) -> Result(r4b.Appointment, Err) {
  any_create(
    r4b.appointment_to_json(resource),
    "Appointment",
    r4b.appointment_decoder(),
    client,
  )
}

pub fn appointment_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Appointment, Err) {
  any_read(id, client, "Appointment", r4b.appointment_decoder())
}

pub fn appointment_update(
  resource: r4b.Appointment,
  client: FhirClient,
) -> Result(r4b.Appointment, Err) {
  any_update(
    resource.id,
    r4b.appointment_to_json(resource),
    "Appointment",
    r4b.appointment_decoder(),
    client,
  )
}

pub fn appointment_delete(
  resource: r4b.Appointment,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Appointment", client)
}

pub fn appointment_search_bundled(
  sp: r4b_sansio.SpAppointment,
  client: FhirClient,
) {
  let req = r4b_sansio.appointment_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn appointment_search(
  sp: r4b_sansio.SpAppointment,
  client: FhirClient,
) -> Result(List(r4b.Appointment), Err) {
  let req = r4b_sansio.appointment_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.appointment
  })
}

pub fn appointmentresponse_create(
  resource: r4b.Appointmentresponse,
  client: FhirClient,
) -> Result(r4b.Appointmentresponse, Err) {
  any_create(
    r4b.appointmentresponse_to_json(resource),
    "AppointmentResponse",
    r4b.appointmentresponse_decoder(),
    client,
  )
}

pub fn appointmentresponse_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Appointmentresponse, Err) {
  any_read(id, client, "AppointmentResponse", r4b.appointmentresponse_decoder())
}

pub fn appointmentresponse_update(
  resource: r4b.Appointmentresponse,
  client: FhirClient,
) -> Result(r4b.Appointmentresponse, Err) {
  any_update(
    resource.id,
    r4b.appointmentresponse_to_json(resource),
    "AppointmentResponse",
    r4b.appointmentresponse_decoder(),
    client,
  )
}

pub fn appointmentresponse_delete(
  resource: r4b.Appointmentresponse,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "AppointmentResponse", client)
}

pub fn appointmentresponse_search_bundled(
  sp: r4b_sansio.SpAppointmentresponse,
  client: FhirClient,
) {
  let req = r4b_sansio.appointmentresponse_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn appointmentresponse_search(
  sp: r4b_sansio.SpAppointmentresponse,
  client: FhirClient,
) -> Result(List(r4b.Appointmentresponse), Err) {
  let req = r4b_sansio.appointmentresponse_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.appointmentresponse
  })
}

pub fn auditevent_create(
  resource: r4b.Auditevent,
  client: FhirClient,
) -> Result(r4b.Auditevent, Err) {
  any_create(
    r4b.auditevent_to_json(resource),
    "AuditEvent",
    r4b.auditevent_decoder(),
    client,
  )
}

pub fn auditevent_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Auditevent, Err) {
  any_read(id, client, "AuditEvent", r4b.auditevent_decoder())
}

pub fn auditevent_update(
  resource: r4b.Auditevent,
  client: FhirClient,
) -> Result(r4b.Auditevent, Err) {
  any_update(
    resource.id,
    r4b.auditevent_to_json(resource),
    "AuditEvent",
    r4b.auditevent_decoder(),
    client,
  )
}

pub fn auditevent_delete(
  resource: r4b.Auditevent,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "AuditEvent", client)
}

pub fn auditevent_search_bundled(
  sp: r4b_sansio.SpAuditevent,
  client: FhirClient,
) {
  let req = r4b_sansio.auditevent_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn auditevent_search(
  sp: r4b_sansio.SpAuditevent,
  client: FhirClient,
) -> Result(List(r4b.Auditevent), Err) {
  let req = r4b_sansio.auditevent_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.auditevent
  })
}

pub fn basic_create(
  resource: r4b.Basic,
  client: FhirClient,
) -> Result(r4b.Basic, Err) {
  any_create(r4b.basic_to_json(resource), "Basic", r4b.basic_decoder(), client)
}

pub fn basic_read(id: String, client: FhirClient) -> Result(r4b.Basic, Err) {
  any_read(id, client, "Basic", r4b.basic_decoder())
}

pub fn basic_update(
  resource: r4b.Basic,
  client: FhirClient,
) -> Result(r4b.Basic, Err) {
  any_update(
    resource.id,
    r4b.basic_to_json(resource),
    "Basic",
    r4b.basic_decoder(),
    client,
  )
}

pub fn basic_delete(
  resource: r4b.Basic,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Basic", client)
}

pub fn basic_search_bundled(sp: r4b_sansio.SpBasic, client: FhirClient) {
  let req = r4b_sansio.basic_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn basic_search(
  sp: r4b_sansio.SpBasic,
  client: FhirClient,
) -> Result(List(r4b.Basic), Err) {
  let req = r4b_sansio.basic_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.basic
  })
}

pub fn binary_create(
  resource: r4b.Binary,
  client: FhirClient,
) -> Result(r4b.Binary, Err) {
  any_create(
    r4b.binary_to_json(resource),
    "Binary",
    r4b.binary_decoder(),
    client,
  )
}

pub fn binary_read(id: String, client: FhirClient) -> Result(r4b.Binary, Err) {
  any_read(id, client, "Binary", r4b.binary_decoder())
}

pub fn binary_update(
  resource: r4b.Binary,
  client: FhirClient,
) -> Result(r4b.Binary, Err) {
  any_update(
    resource.id,
    r4b.binary_to_json(resource),
    "Binary",
    r4b.binary_decoder(),
    client,
  )
}

pub fn binary_delete(
  resource: r4b.Binary,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Binary", client)
}

pub fn binary_search_bundled(sp: r4b_sansio.SpBinary, client: FhirClient) {
  let req = r4b_sansio.binary_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn binary_search(
  sp: r4b_sansio.SpBinary,
  client: FhirClient,
) -> Result(List(r4b.Binary), Err) {
  let req = r4b_sansio.binary_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.binary
  })
}

pub fn biologicallyderivedproduct_create(
  resource: r4b.Biologicallyderivedproduct,
  client: FhirClient,
) -> Result(r4b.Biologicallyderivedproduct, Err) {
  any_create(
    r4b.biologicallyderivedproduct_to_json(resource),
    "BiologicallyDerivedProduct",
    r4b.biologicallyderivedproduct_decoder(),
    client,
  )
}

pub fn biologicallyderivedproduct_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Biologicallyderivedproduct, Err) {
  any_read(
    id,
    client,
    "BiologicallyDerivedProduct",
    r4b.biologicallyderivedproduct_decoder(),
  )
}

pub fn biologicallyderivedproduct_update(
  resource: r4b.Biologicallyderivedproduct,
  client: FhirClient,
) -> Result(r4b.Biologicallyderivedproduct, Err) {
  any_update(
    resource.id,
    r4b.biologicallyderivedproduct_to_json(resource),
    "BiologicallyDerivedProduct",
    r4b.biologicallyderivedproduct_decoder(),
    client,
  )
}

pub fn biologicallyderivedproduct_delete(
  resource: r4b.Biologicallyderivedproduct,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "BiologicallyDerivedProduct", client)
}

pub fn biologicallyderivedproduct_search_bundled(
  sp: r4b_sansio.SpBiologicallyderivedproduct,
  client: FhirClient,
) {
  let req = r4b_sansio.biologicallyderivedproduct_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn biologicallyderivedproduct_search(
  sp: r4b_sansio.SpBiologicallyderivedproduct,
  client: FhirClient,
) -> Result(List(r4b.Biologicallyderivedproduct), Err) {
  let req = r4b_sansio.biologicallyderivedproduct_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.biologicallyderivedproduct
  })
}

pub fn bodystructure_create(
  resource: r4b.Bodystructure,
  client: FhirClient,
) -> Result(r4b.Bodystructure, Err) {
  any_create(
    r4b.bodystructure_to_json(resource),
    "BodyStructure",
    r4b.bodystructure_decoder(),
    client,
  )
}

pub fn bodystructure_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Bodystructure, Err) {
  any_read(id, client, "BodyStructure", r4b.bodystructure_decoder())
}

pub fn bodystructure_update(
  resource: r4b.Bodystructure,
  client: FhirClient,
) -> Result(r4b.Bodystructure, Err) {
  any_update(
    resource.id,
    r4b.bodystructure_to_json(resource),
    "BodyStructure",
    r4b.bodystructure_decoder(),
    client,
  )
}

pub fn bodystructure_delete(
  resource: r4b.Bodystructure,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "BodyStructure", client)
}

pub fn bodystructure_search_bundled(
  sp: r4b_sansio.SpBodystructure,
  client: FhirClient,
) {
  let req = r4b_sansio.bodystructure_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn bodystructure_search(
  sp: r4b_sansio.SpBodystructure,
  client: FhirClient,
) -> Result(List(r4b.Bodystructure), Err) {
  let req = r4b_sansio.bodystructure_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.bodystructure
  })
}

pub fn bundle_create(
  resource: r4b.Bundle,
  client: FhirClient,
) -> Result(r4b.Bundle, Err) {
  any_create(
    r4b.bundle_to_json(resource),
    "Bundle",
    r4b.bundle_decoder(),
    client,
  )
}

pub fn bundle_read(id: String, client: FhirClient) -> Result(r4b.Bundle, Err) {
  any_read(id, client, "Bundle", r4b.bundle_decoder())
}

pub fn bundle_update(
  resource: r4b.Bundle,
  client: FhirClient,
) -> Result(r4b.Bundle, Err) {
  any_update(
    resource.id,
    r4b.bundle_to_json(resource),
    "Bundle",
    r4b.bundle_decoder(),
    client,
  )
}

pub fn bundle_delete(
  resource: r4b.Bundle,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Bundle", client)
}

pub fn bundle_search_bundled(sp: r4b_sansio.SpBundle, client: FhirClient) {
  let req = r4b_sansio.bundle_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn bundle_search(
  sp: r4b_sansio.SpBundle,
  client: FhirClient,
) -> Result(List(r4b.Bundle), Err) {
  let req = r4b_sansio.bundle_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.bundle
  })
}

pub fn capabilitystatement_create(
  resource: r4b.Capabilitystatement,
  client: FhirClient,
) -> Result(r4b.Capabilitystatement, Err) {
  any_create(
    r4b.capabilitystatement_to_json(resource),
    "CapabilityStatement",
    r4b.capabilitystatement_decoder(),
    client,
  )
}

pub fn capabilitystatement_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Capabilitystatement, Err) {
  any_read(id, client, "CapabilityStatement", r4b.capabilitystatement_decoder())
}

pub fn capabilitystatement_update(
  resource: r4b.Capabilitystatement,
  client: FhirClient,
) -> Result(r4b.Capabilitystatement, Err) {
  any_update(
    resource.id,
    r4b.capabilitystatement_to_json(resource),
    "CapabilityStatement",
    r4b.capabilitystatement_decoder(),
    client,
  )
}

pub fn capabilitystatement_delete(
  resource: r4b.Capabilitystatement,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "CapabilityStatement", client)
}

pub fn capabilitystatement_search_bundled(
  sp: r4b_sansio.SpCapabilitystatement,
  client: FhirClient,
) {
  let req = r4b_sansio.capabilitystatement_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn capabilitystatement_search(
  sp: r4b_sansio.SpCapabilitystatement,
  client: FhirClient,
) -> Result(List(r4b.Capabilitystatement), Err) {
  let req = r4b_sansio.capabilitystatement_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.capabilitystatement
  })
}

pub fn careplan_create(
  resource: r4b.Careplan,
  client: FhirClient,
) -> Result(r4b.Careplan, Err) {
  any_create(
    r4b.careplan_to_json(resource),
    "CarePlan",
    r4b.careplan_decoder(),
    client,
  )
}

pub fn careplan_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Careplan, Err) {
  any_read(id, client, "CarePlan", r4b.careplan_decoder())
}

pub fn careplan_update(
  resource: r4b.Careplan,
  client: FhirClient,
) -> Result(r4b.Careplan, Err) {
  any_update(
    resource.id,
    r4b.careplan_to_json(resource),
    "CarePlan",
    r4b.careplan_decoder(),
    client,
  )
}

pub fn careplan_delete(
  resource: r4b.Careplan,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "CarePlan", client)
}

pub fn careplan_search_bundled(sp: r4b_sansio.SpCareplan, client: FhirClient) {
  let req = r4b_sansio.careplan_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn careplan_search(
  sp: r4b_sansio.SpCareplan,
  client: FhirClient,
) -> Result(List(r4b.Careplan), Err) {
  let req = r4b_sansio.careplan_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.careplan
  })
}

pub fn careteam_create(
  resource: r4b.Careteam,
  client: FhirClient,
) -> Result(r4b.Careteam, Err) {
  any_create(
    r4b.careteam_to_json(resource),
    "CareTeam",
    r4b.careteam_decoder(),
    client,
  )
}

pub fn careteam_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Careteam, Err) {
  any_read(id, client, "CareTeam", r4b.careteam_decoder())
}

pub fn careteam_update(
  resource: r4b.Careteam,
  client: FhirClient,
) -> Result(r4b.Careteam, Err) {
  any_update(
    resource.id,
    r4b.careteam_to_json(resource),
    "CareTeam",
    r4b.careteam_decoder(),
    client,
  )
}

pub fn careteam_delete(
  resource: r4b.Careteam,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "CareTeam", client)
}

pub fn careteam_search_bundled(sp: r4b_sansio.SpCareteam, client: FhirClient) {
  let req = r4b_sansio.careteam_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn careteam_search(
  sp: r4b_sansio.SpCareteam,
  client: FhirClient,
) -> Result(List(r4b.Careteam), Err) {
  let req = r4b_sansio.careteam_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.careteam
  })
}

pub fn catalogentry_create(
  resource: r4b.Catalogentry,
  client: FhirClient,
) -> Result(r4b.Catalogentry, Err) {
  any_create(
    r4b.catalogentry_to_json(resource),
    "CatalogEntry",
    r4b.catalogentry_decoder(),
    client,
  )
}

pub fn catalogentry_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Catalogentry, Err) {
  any_read(id, client, "CatalogEntry", r4b.catalogentry_decoder())
}

pub fn catalogentry_update(
  resource: r4b.Catalogentry,
  client: FhirClient,
) -> Result(r4b.Catalogentry, Err) {
  any_update(
    resource.id,
    r4b.catalogentry_to_json(resource),
    "CatalogEntry",
    r4b.catalogentry_decoder(),
    client,
  )
}

pub fn catalogentry_delete(
  resource: r4b.Catalogentry,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "CatalogEntry", client)
}

pub fn catalogentry_search_bundled(
  sp: r4b_sansio.SpCatalogentry,
  client: FhirClient,
) {
  let req = r4b_sansio.catalogentry_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn catalogentry_search(
  sp: r4b_sansio.SpCatalogentry,
  client: FhirClient,
) -> Result(List(r4b.Catalogentry), Err) {
  let req = r4b_sansio.catalogentry_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.catalogentry
  })
}

pub fn chargeitem_create(
  resource: r4b.Chargeitem,
  client: FhirClient,
) -> Result(r4b.Chargeitem, Err) {
  any_create(
    r4b.chargeitem_to_json(resource),
    "ChargeItem",
    r4b.chargeitem_decoder(),
    client,
  )
}

pub fn chargeitem_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Chargeitem, Err) {
  any_read(id, client, "ChargeItem", r4b.chargeitem_decoder())
}

pub fn chargeitem_update(
  resource: r4b.Chargeitem,
  client: FhirClient,
) -> Result(r4b.Chargeitem, Err) {
  any_update(
    resource.id,
    r4b.chargeitem_to_json(resource),
    "ChargeItem",
    r4b.chargeitem_decoder(),
    client,
  )
}

pub fn chargeitem_delete(
  resource: r4b.Chargeitem,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "ChargeItem", client)
}

pub fn chargeitem_search_bundled(
  sp: r4b_sansio.SpChargeitem,
  client: FhirClient,
) {
  let req = r4b_sansio.chargeitem_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn chargeitem_search(
  sp: r4b_sansio.SpChargeitem,
  client: FhirClient,
) -> Result(List(r4b.Chargeitem), Err) {
  let req = r4b_sansio.chargeitem_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.chargeitem
  })
}

pub fn chargeitemdefinition_create(
  resource: r4b.Chargeitemdefinition,
  client: FhirClient,
) -> Result(r4b.Chargeitemdefinition, Err) {
  any_create(
    r4b.chargeitemdefinition_to_json(resource),
    "ChargeItemDefinition",
    r4b.chargeitemdefinition_decoder(),
    client,
  )
}

pub fn chargeitemdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Chargeitemdefinition, Err) {
  any_read(
    id,
    client,
    "ChargeItemDefinition",
    r4b.chargeitemdefinition_decoder(),
  )
}

pub fn chargeitemdefinition_update(
  resource: r4b.Chargeitemdefinition,
  client: FhirClient,
) -> Result(r4b.Chargeitemdefinition, Err) {
  any_update(
    resource.id,
    r4b.chargeitemdefinition_to_json(resource),
    "ChargeItemDefinition",
    r4b.chargeitemdefinition_decoder(),
    client,
  )
}

pub fn chargeitemdefinition_delete(
  resource: r4b.Chargeitemdefinition,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "ChargeItemDefinition", client)
}

pub fn chargeitemdefinition_search_bundled(
  sp: r4b_sansio.SpChargeitemdefinition,
  client: FhirClient,
) {
  let req = r4b_sansio.chargeitemdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn chargeitemdefinition_search(
  sp: r4b_sansio.SpChargeitemdefinition,
  client: FhirClient,
) -> Result(List(r4b.Chargeitemdefinition), Err) {
  let req = r4b_sansio.chargeitemdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.chargeitemdefinition
  })
}

pub fn citation_create(
  resource: r4b.Citation,
  client: FhirClient,
) -> Result(r4b.Citation, Err) {
  any_create(
    r4b.citation_to_json(resource),
    "Citation",
    r4b.citation_decoder(),
    client,
  )
}

pub fn citation_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Citation, Err) {
  any_read(id, client, "Citation", r4b.citation_decoder())
}

pub fn citation_update(
  resource: r4b.Citation,
  client: FhirClient,
) -> Result(r4b.Citation, Err) {
  any_update(
    resource.id,
    r4b.citation_to_json(resource),
    "Citation",
    r4b.citation_decoder(),
    client,
  )
}

pub fn citation_delete(
  resource: r4b.Citation,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Citation", client)
}

pub fn citation_search_bundled(sp: r4b_sansio.SpCitation, client: FhirClient) {
  let req = r4b_sansio.citation_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn citation_search(
  sp: r4b_sansio.SpCitation,
  client: FhirClient,
) -> Result(List(r4b.Citation), Err) {
  let req = r4b_sansio.citation_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.citation
  })
}

pub fn claim_create(
  resource: r4b.Claim,
  client: FhirClient,
) -> Result(r4b.Claim, Err) {
  any_create(r4b.claim_to_json(resource), "Claim", r4b.claim_decoder(), client)
}

pub fn claim_read(id: String, client: FhirClient) -> Result(r4b.Claim, Err) {
  any_read(id, client, "Claim", r4b.claim_decoder())
}

pub fn claim_update(
  resource: r4b.Claim,
  client: FhirClient,
) -> Result(r4b.Claim, Err) {
  any_update(
    resource.id,
    r4b.claim_to_json(resource),
    "Claim",
    r4b.claim_decoder(),
    client,
  )
}

pub fn claim_delete(
  resource: r4b.Claim,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Claim", client)
}

pub fn claim_search_bundled(sp: r4b_sansio.SpClaim, client: FhirClient) {
  let req = r4b_sansio.claim_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn claim_search(
  sp: r4b_sansio.SpClaim,
  client: FhirClient,
) -> Result(List(r4b.Claim), Err) {
  let req = r4b_sansio.claim_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.claim
  })
}

pub fn claimresponse_create(
  resource: r4b.Claimresponse,
  client: FhirClient,
) -> Result(r4b.Claimresponse, Err) {
  any_create(
    r4b.claimresponse_to_json(resource),
    "ClaimResponse",
    r4b.claimresponse_decoder(),
    client,
  )
}

pub fn claimresponse_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Claimresponse, Err) {
  any_read(id, client, "ClaimResponse", r4b.claimresponse_decoder())
}

pub fn claimresponse_update(
  resource: r4b.Claimresponse,
  client: FhirClient,
) -> Result(r4b.Claimresponse, Err) {
  any_update(
    resource.id,
    r4b.claimresponse_to_json(resource),
    "ClaimResponse",
    r4b.claimresponse_decoder(),
    client,
  )
}

pub fn claimresponse_delete(
  resource: r4b.Claimresponse,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "ClaimResponse", client)
}

pub fn claimresponse_search_bundled(
  sp: r4b_sansio.SpClaimresponse,
  client: FhirClient,
) {
  let req = r4b_sansio.claimresponse_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn claimresponse_search(
  sp: r4b_sansio.SpClaimresponse,
  client: FhirClient,
) -> Result(List(r4b.Claimresponse), Err) {
  let req = r4b_sansio.claimresponse_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.claimresponse
  })
}

pub fn clinicalimpression_create(
  resource: r4b.Clinicalimpression,
  client: FhirClient,
) -> Result(r4b.Clinicalimpression, Err) {
  any_create(
    r4b.clinicalimpression_to_json(resource),
    "ClinicalImpression",
    r4b.clinicalimpression_decoder(),
    client,
  )
}

pub fn clinicalimpression_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Clinicalimpression, Err) {
  any_read(id, client, "ClinicalImpression", r4b.clinicalimpression_decoder())
}

pub fn clinicalimpression_update(
  resource: r4b.Clinicalimpression,
  client: FhirClient,
) -> Result(r4b.Clinicalimpression, Err) {
  any_update(
    resource.id,
    r4b.clinicalimpression_to_json(resource),
    "ClinicalImpression",
    r4b.clinicalimpression_decoder(),
    client,
  )
}

pub fn clinicalimpression_delete(
  resource: r4b.Clinicalimpression,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "ClinicalImpression", client)
}

pub fn clinicalimpression_search_bundled(
  sp: r4b_sansio.SpClinicalimpression,
  client: FhirClient,
) {
  let req = r4b_sansio.clinicalimpression_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn clinicalimpression_search(
  sp: r4b_sansio.SpClinicalimpression,
  client: FhirClient,
) -> Result(List(r4b.Clinicalimpression), Err) {
  let req = r4b_sansio.clinicalimpression_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.clinicalimpression
  })
}

pub fn clinicalusedefinition_create(
  resource: r4b.Clinicalusedefinition,
  client: FhirClient,
) -> Result(r4b.Clinicalusedefinition, Err) {
  any_create(
    r4b.clinicalusedefinition_to_json(resource),
    "ClinicalUseDefinition",
    r4b.clinicalusedefinition_decoder(),
    client,
  )
}

pub fn clinicalusedefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Clinicalusedefinition, Err) {
  any_read(
    id,
    client,
    "ClinicalUseDefinition",
    r4b.clinicalusedefinition_decoder(),
  )
}

pub fn clinicalusedefinition_update(
  resource: r4b.Clinicalusedefinition,
  client: FhirClient,
) -> Result(r4b.Clinicalusedefinition, Err) {
  any_update(
    resource.id,
    r4b.clinicalusedefinition_to_json(resource),
    "ClinicalUseDefinition",
    r4b.clinicalusedefinition_decoder(),
    client,
  )
}

pub fn clinicalusedefinition_delete(
  resource: r4b.Clinicalusedefinition,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "ClinicalUseDefinition", client)
}

pub fn clinicalusedefinition_search_bundled(
  sp: r4b_sansio.SpClinicalusedefinition,
  client: FhirClient,
) {
  let req = r4b_sansio.clinicalusedefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn clinicalusedefinition_search(
  sp: r4b_sansio.SpClinicalusedefinition,
  client: FhirClient,
) -> Result(List(r4b.Clinicalusedefinition), Err) {
  let req = r4b_sansio.clinicalusedefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.clinicalusedefinition
  })
}

pub fn codesystem_create(
  resource: r4b.Codesystem,
  client: FhirClient,
) -> Result(r4b.Codesystem, Err) {
  any_create(
    r4b.codesystem_to_json(resource),
    "CodeSystem",
    r4b.codesystem_decoder(),
    client,
  )
}

pub fn codesystem_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Codesystem, Err) {
  any_read(id, client, "CodeSystem", r4b.codesystem_decoder())
}

pub fn codesystem_update(
  resource: r4b.Codesystem,
  client: FhirClient,
) -> Result(r4b.Codesystem, Err) {
  any_update(
    resource.id,
    r4b.codesystem_to_json(resource),
    "CodeSystem",
    r4b.codesystem_decoder(),
    client,
  )
}

pub fn codesystem_delete(
  resource: r4b.Codesystem,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "CodeSystem", client)
}

pub fn codesystem_search_bundled(
  sp: r4b_sansio.SpCodesystem,
  client: FhirClient,
) {
  let req = r4b_sansio.codesystem_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn codesystem_search(
  sp: r4b_sansio.SpCodesystem,
  client: FhirClient,
) -> Result(List(r4b.Codesystem), Err) {
  let req = r4b_sansio.codesystem_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.codesystem
  })
}

pub fn communication_create(
  resource: r4b.Communication,
  client: FhirClient,
) -> Result(r4b.Communication, Err) {
  any_create(
    r4b.communication_to_json(resource),
    "Communication",
    r4b.communication_decoder(),
    client,
  )
}

pub fn communication_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Communication, Err) {
  any_read(id, client, "Communication", r4b.communication_decoder())
}

pub fn communication_update(
  resource: r4b.Communication,
  client: FhirClient,
) -> Result(r4b.Communication, Err) {
  any_update(
    resource.id,
    r4b.communication_to_json(resource),
    "Communication",
    r4b.communication_decoder(),
    client,
  )
}

pub fn communication_delete(
  resource: r4b.Communication,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Communication", client)
}

pub fn communication_search_bundled(
  sp: r4b_sansio.SpCommunication,
  client: FhirClient,
) {
  let req = r4b_sansio.communication_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn communication_search(
  sp: r4b_sansio.SpCommunication,
  client: FhirClient,
) -> Result(List(r4b.Communication), Err) {
  let req = r4b_sansio.communication_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.communication
  })
}

pub fn communicationrequest_create(
  resource: r4b.Communicationrequest,
  client: FhirClient,
) -> Result(r4b.Communicationrequest, Err) {
  any_create(
    r4b.communicationrequest_to_json(resource),
    "CommunicationRequest",
    r4b.communicationrequest_decoder(),
    client,
  )
}

pub fn communicationrequest_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Communicationrequest, Err) {
  any_read(
    id,
    client,
    "CommunicationRequest",
    r4b.communicationrequest_decoder(),
  )
}

pub fn communicationrequest_update(
  resource: r4b.Communicationrequest,
  client: FhirClient,
) -> Result(r4b.Communicationrequest, Err) {
  any_update(
    resource.id,
    r4b.communicationrequest_to_json(resource),
    "CommunicationRequest",
    r4b.communicationrequest_decoder(),
    client,
  )
}

pub fn communicationrequest_delete(
  resource: r4b.Communicationrequest,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "CommunicationRequest", client)
}

pub fn communicationrequest_search_bundled(
  sp: r4b_sansio.SpCommunicationrequest,
  client: FhirClient,
) {
  let req = r4b_sansio.communicationrequest_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn communicationrequest_search(
  sp: r4b_sansio.SpCommunicationrequest,
  client: FhirClient,
) -> Result(List(r4b.Communicationrequest), Err) {
  let req = r4b_sansio.communicationrequest_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.communicationrequest
  })
}

pub fn compartmentdefinition_create(
  resource: r4b.Compartmentdefinition,
  client: FhirClient,
) -> Result(r4b.Compartmentdefinition, Err) {
  any_create(
    r4b.compartmentdefinition_to_json(resource),
    "CompartmentDefinition",
    r4b.compartmentdefinition_decoder(),
    client,
  )
}

pub fn compartmentdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Compartmentdefinition, Err) {
  any_read(
    id,
    client,
    "CompartmentDefinition",
    r4b.compartmentdefinition_decoder(),
  )
}

pub fn compartmentdefinition_update(
  resource: r4b.Compartmentdefinition,
  client: FhirClient,
) -> Result(r4b.Compartmentdefinition, Err) {
  any_update(
    resource.id,
    r4b.compartmentdefinition_to_json(resource),
    "CompartmentDefinition",
    r4b.compartmentdefinition_decoder(),
    client,
  )
}

pub fn compartmentdefinition_delete(
  resource: r4b.Compartmentdefinition,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "CompartmentDefinition", client)
}

pub fn compartmentdefinition_search_bundled(
  sp: r4b_sansio.SpCompartmentdefinition,
  client: FhirClient,
) {
  let req = r4b_sansio.compartmentdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn compartmentdefinition_search(
  sp: r4b_sansio.SpCompartmentdefinition,
  client: FhirClient,
) -> Result(List(r4b.Compartmentdefinition), Err) {
  let req = r4b_sansio.compartmentdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.compartmentdefinition
  })
}

pub fn composition_create(
  resource: r4b.Composition,
  client: FhirClient,
) -> Result(r4b.Composition, Err) {
  any_create(
    r4b.composition_to_json(resource),
    "Composition",
    r4b.composition_decoder(),
    client,
  )
}

pub fn composition_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Composition, Err) {
  any_read(id, client, "Composition", r4b.composition_decoder())
}

pub fn composition_update(
  resource: r4b.Composition,
  client: FhirClient,
) -> Result(r4b.Composition, Err) {
  any_update(
    resource.id,
    r4b.composition_to_json(resource),
    "Composition",
    r4b.composition_decoder(),
    client,
  )
}

pub fn composition_delete(
  resource: r4b.Composition,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Composition", client)
}

pub fn composition_search_bundled(
  sp: r4b_sansio.SpComposition,
  client: FhirClient,
) {
  let req = r4b_sansio.composition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn composition_search(
  sp: r4b_sansio.SpComposition,
  client: FhirClient,
) -> Result(List(r4b.Composition), Err) {
  let req = r4b_sansio.composition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.composition
  })
}

pub fn conceptmap_create(
  resource: r4b.Conceptmap,
  client: FhirClient,
) -> Result(r4b.Conceptmap, Err) {
  any_create(
    r4b.conceptmap_to_json(resource),
    "ConceptMap",
    r4b.conceptmap_decoder(),
    client,
  )
}

pub fn conceptmap_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Conceptmap, Err) {
  any_read(id, client, "ConceptMap", r4b.conceptmap_decoder())
}

pub fn conceptmap_update(
  resource: r4b.Conceptmap,
  client: FhirClient,
) -> Result(r4b.Conceptmap, Err) {
  any_update(
    resource.id,
    r4b.conceptmap_to_json(resource),
    "ConceptMap",
    r4b.conceptmap_decoder(),
    client,
  )
}

pub fn conceptmap_delete(
  resource: r4b.Conceptmap,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "ConceptMap", client)
}

pub fn conceptmap_search_bundled(
  sp: r4b_sansio.SpConceptmap,
  client: FhirClient,
) {
  let req = r4b_sansio.conceptmap_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn conceptmap_search(
  sp: r4b_sansio.SpConceptmap,
  client: FhirClient,
) -> Result(List(r4b.Conceptmap), Err) {
  let req = r4b_sansio.conceptmap_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.conceptmap
  })
}

pub fn condition_create(
  resource: r4b.Condition,
  client: FhirClient,
) -> Result(r4b.Condition, Err) {
  any_create(
    r4b.condition_to_json(resource),
    "Condition",
    r4b.condition_decoder(),
    client,
  )
}

pub fn condition_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Condition, Err) {
  any_read(id, client, "Condition", r4b.condition_decoder())
}

pub fn condition_update(
  resource: r4b.Condition,
  client: FhirClient,
) -> Result(r4b.Condition, Err) {
  any_update(
    resource.id,
    r4b.condition_to_json(resource),
    "Condition",
    r4b.condition_decoder(),
    client,
  )
}

pub fn condition_delete(
  resource: r4b.Condition,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Condition", client)
}

pub fn condition_search_bundled(sp: r4b_sansio.SpCondition, client: FhirClient) {
  let req = r4b_sansio.condition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn condition_search(
  sp: r4b_sansio.SpCondition,
  client: FhirClient,
) -> Result(List(r4b.Condition), Err) {
  let req = r4b_sansio.condition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.condition
  })
}

pub fn consent_create(
  resource: r4b.Consent,
  client: FhirClient,
) -> Result(r4b.Consent, Err) {
  any_create(
    r4b.consent_to_json(resource),
    "Consent",
    r4b.consent_decoder(),
    client,
  )
}

pub fn consent_read(id: String, client: FhirClient) -> Result(r4b.Consent, Err) {
  any_read(id, client, "Consent", r4b.consent_decoder())
}

pub fn consent_update(
  resource: r4b.Consent,
  client: FhirClient,
) -> Result(r4b.Consent, Err) {
  any_update(
    resource.id,
    r4b.consent_to_json(resource),
    "Consent",
    r4b.consent_decoder(),
    client,
  )
}

pub fn consent_delete(
  resource: r4b.Consent,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Consent", client)
}

pub fn consent_search_bundled(sp: r4b_sansio.SpConsent, client: FhirClient) {
  let req = r4b_sansio.consent_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn consent_search(
  sp: r4b_sansio.SpConsent,
  client: FhirClient,
) -> Result(List(r4b.Consent), Err) {
  let req = r4b_sansio.consent_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.consent
  })
}

pub fn contract_create(
  resource: r4b.Contract,
  client: FhirClient,
) -> Result(r4b.Contract, Err) {
  any_create(
    r4b.contract_to_json(resource),
    "Contract",
    r4b.contract_decoder(),
    client,
  )
}

pub fn contract_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Contract, Err) {
  any_read(id, client, "Contract", r4b.contract_decoder())
}

pub fn contract_update(
  resource: r4b.Contract,
  client: FhirClient,
) -> Result(r4b.Contract, Err) {
  any_update(
    resource.id,
    r4b.contract_to_json(resource),
    "Contract",
    r4b.contract_decoder(),
    client,
  )
}

pub fn contract_delete(
  resource: r4b.Contract,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Contract", client)
}

pub fn contract_search_bundled(sp: r4b_sansio.SpContract, client: FhirClient) {
  let req = r4b_sansio.contract_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn contract_search(
  sp: r4b_sansio.SpContract,
  client: FhirClient,
) -> Result(List(r4b.Contract), Err) {
  let req = r4b_sansio.contract_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.contract
  })
}

pub fn coverage_create(
  resource: r4b.Coverage,
  client: FhirClient,
) -> Result(r4b.Coverage, Err) {
  any_create(
    r4b.coverage_to_json(resource),
    "Coverage",
    r4b.coverage_decoder(),
    client,
  )
}

pub fn coverage_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Coverage, Err) {
  any_read(id, client, "Coverage", r4b.coverage_decoder())
}

pub fn coverage_update(
  resource: r4b.Coverage,
  client: FhirClient,
) -> Result(r4b.Coverage, Err) {
  any_update(
    resource.id,
    r4b.coverage_to_json(resource),
    "Coverage",
    r4b.coverage_decoder(),
    client,
  )
}

pub fn coverage_delete(
  resource: r4b.Coverage,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Coverage", client)
}

pub fn coverage_search_bundled(sp: r4b_sansio.SpCoverage, client: FhirClient) {
  let req = r4b_sansio.coverage_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn coverage_search(
  sp: r4b_sansio.SpCoverage,
  client: FhirClient,
) -> Result(List(r4b.Coverage), Err) {
  let req = r4b_sansio.coverage_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.coverage
  })
}

pub fn coverageeligibilityrequest_create(
  resource: r4b.Coverageeligibilityrequest,
  client: FhirClient,
) -> Result(r4b.Coverageeligibilityrequest, Err) {
  any_create(
    r4b.coverageeligibilityrequest_to_json(resource),
    "CoverageEligibilityRequest",
    r4b.coverageeligibilityrequest_decoder(),
    client,
  )
}

pub fn coverageeligibilityrequest_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Coverageeligibilityrequest, Err) {
  any_read(
    id,
    client,
    "CoverageEligibilityRequest",
    r4b.coverageeligibilityrequest_decoder(),
  )
}

pub fn coverageeligibilityrequest_update(
  resource: r4b.Coverageeligibilityrequest,
  client: FhirClient,
) -> Result(r4b.Coverageeligibilityrequest, Err) {
  any_update(
    resource.id,
    r4b.coverageeligibilityrequest_to_json(resource),
    "CoverageEligibilityRequest",
    r4b.coverageeligibilityrequest_decoder(),
    client,
  )
}

pub fn coverageeligibilityrequest_delete(
  resource: r4b.Coverageeligibilityrequest,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "CoverageEligibilityRequest", client)
}

pub fn coverageeligibilityrequest_search_bundled(
  sp: r4b_sansio.SpCoverageeligibilityrequest,
  client: FhirClient,
) {
  let req = r4b_sansio.coverageeligibilityrequest_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn coverageeligibilityrequest_search(
  sp: r4b_sansio.SpCoverageeligibilityrequest,
  client: FhirClient,
) -> Result(List(r4b.Coverageeligibilityrequest), Err) {
  let req = r4b_sansio.coverageeligibilityrequest_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.coverageeligibilityrequest
  })
}

pub fn coverageeligibilityresponse_create(
  resource: r4b.Coverageeligibilityresponse,
  client: FhirClient,
) -> Result(r4b.Coverageeligibilityresponse, Err) {
  any_create(
    r4b.coverageeligibilityresponse_to_json(resource),
    "CoverageEligibilityResponse",
    r4b.coverageeligibilityresponse_decoder(),
    client,
  )
}

pub fn coverageeligibilityresponse_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Coverageeligibilityresponse, Err) {
  any_read(
    id,
    client,
    "CoverageEligibilityResponse",
    r4b.coverageeligibilityresponse_decoder(),
  )
}

pub fn coverageeligibilityresponse_update(
  resource: r4b.Coverageeligibilityresponse,
  client: FhirClient,
) -> Result(r4b.Coverageeligibilityresponse, Err) {
  any_update(
    resource.id,
    r4b.coverageeligibilityresponse_to_json(resource),
    "CoverageEligibilityResponse",
    r4b.coverageeligibilityresponse_decoder(),
    client,
  )
}

pub fn coverageeligibilityresponse_delete(
  resource: r4b.Coverageeligibilityresponse,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "CoverageEligibilityResponse", client)
}

pub fn coverageeligibilityresponse_search_bundled(
  sp: r4b_sansio.SpCoverageeligibilityresponse,
  client: FhirClient,
) {
  let req = r4b_sansio.coverageeligibilityresponse_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn coverageeligibilityresponse_search(
  sp: r4b_sansio.SpCoverageeligibilityresponse,
  client: FhirClient,
) -> Result(List(r4b.Coverageeligibilityresponse), Err) {
  let req = r4b_sansio.coverageeligibilityresponse_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.coverageeligibilityresponse
  })
}

pub fn detectedissue_create(
  resource: r4b.Detectedissue,
  client: FhirClient,
) -> Result(r4b.Detectedissue, Err) {
  any_create(
    r4b.detectedissue_to_json(resource),
    "DetectedIssue",
    r4b.detectedissue_decoder(),
    client,
  )
}

pub fn detectedissue_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Detectedissue, Err) {
  any_read(id, client, "DetectedIssue", r4b.detectedissue_decoder())
}

pub fn detectedissue_update(
  resource: r4b.Detectedissue,
  client: FhirClient,
) -> Result(r4b.Detectedissue, Err) {
  any_update(
    resource.id,
    r4b.detectedissue_to_json(resource),
    "DetectedIssue",
    r4b.detectedissue_decoder(),
    client,
  )
}

pub fn detectedissue_delete(
  resource: r4b.Detectedissue,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "DetectedIssue", client)
}

pub fn detectedissue_search_bundled(
  sp: r4b_sansio.SpDetectedissue,
  client: FhirClient,
) {
  let req = r4b_sansio.detectedissue_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn detectedissue_search(
  sp: r4b_sansio.SpDetectedissue,
  client: FhirClient,
) -> Result(List(r4b.Detectedissue), Err) {
  let req = r4b_sansio.detectedissue_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.detectedissue
  })
}

pub fn device_create(
  resource: r4b.Device,
  client: FhirClient,
) -> Result(r4b.Device, Err) {
  any_create(
    r4b.device_to_json(resource),
    "Device",
    r4b.device_decoder(),
    client,
  )
}

pub fn device_read(id: String, client: FhirClient) -> Result(r4b.Device, Err) {
  any_read(id, client, "Device", r4b.device_decoder())
}

pub fn device_update(
  resource: r4b.Device,
  client: FhirClient,
) -> Result(r4b.Device, Err) {
  any_update(
    resource.id,
    r4b.device_to_json(resource),
    "Device",
    r4b.device_decoder(),
    client,
  )
}

pub fn device_delete(
  resource: r4b.Device,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Device", client)
}

pub fn device_search_bundled(sp: r4b_sansio.SpDevice, client: FhirClient) {
  let req = r4b_sansio.device_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn device_search(
  sp: r4b_sansio.SpDevice,
  client: FhirClient,
) -> Result(List(r4b.Device), Err) {
  let req = r4b_sansio.device_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.device
  })
}

pub fn devicedefinition_create(
  resource: r4b.Devicedefinition,
  client: FhirClient,
) -> Result(r4b.Devicedefinition, Err) {
  any_create(
    r4b.devicedefinition_to_json(resource),
    "DeviceDefinition",
    r4b.devicedefinition_decoder(),
    client,
  )
}

pub fn devicedefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Devicedefinition, Err) {
  any_read(id, client, "DeviceDefinition", r4b.devicedefinition_decoder())
}

pub fn devicedefinition_update(
  resource: r4b.Devicedefinition,
  client: FhirClient,
) -> Result(r4b.Devicedefinition, Err) {
  any_update(
    resource.id,
    r4b.devicedefinition_to_json(resource),
    "DeviceDefinition",
    r4b.devicedefinition_decoder(),
    client,
  )
}

pub fn devicedefinition_delete(
  resource: r4b.Devicedefinition,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "DeviceDefinition", client)
}

pub fn devicedefinition_search_bundled(
  sp: r4b_sansio.SpDevicedefinition,
  client: FhirClient,
) {
  let req = r4b_sansio.devicedefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn devicedefinition_search(
  sp: r4b_sansio.SpDevicedefinition,
  client: FhirClient,
) -> Result(List(r4b.Devicedefinition), Err) {
  let req = r4b_sansio.devicedefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.devicedefinition
  })
}

pub fn devicemetric_create(
  resource: r4b.Devicemetric,
  client: FhirClient,
) -> Result(r4b.Devicemetric, Err) {
  any_create(
    r4b.devicemetric_to_json(resource),
    "DeviceMetric",
    r4b.devicemetric_decoder(),
    client,
  )
}

pub fn devicemetric_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Devicemetric, Err) {
  any_read(id, client, "DeviceMetric", r4b.devicemetric_decoder())
}

pub fn devicemetric_update(
  resource: r4b.Devicemetric,
  client: FhirClient,
) -> Result(r4b.Devicemetric, Err) {
  any_update(
    resource.id,
    r4b.devicemetric_to_json(resource),
    "DeviceMetric",
    r4b.devicemetric_decoder(),
    client,
  )
}

pub fn devicemetric_delete(
  resource: r4b.Devicemetric,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "DeviceMetric", client)
}

pub fn devicemetric_search_bundled(
  sp: r4b_sansio.SpDevicemetric,
  client: FhirClient,
) {
  let req = r4b_sansio.devicemetric_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn devicemetric_search(
  sp: r4b_sansio.SpDevicemetric,
  client: FhirClient,
) -> Result(List(r4b.Devicemetric), Err) {
  let req = r4b_sansio.devicemetric_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.devicemetric
  })
}

pub fn devicerequest_create(
  resource: r4b.Devicerequest,
  client: FhirClient,
) -> Result(r4b.Devicerequest, Err) {
  any_create(
    r4b.devicerequest_to_json(resource),
    "DeviceRequest",
    r4b.devicerequest_decoder(),
    client,
  )
}

pub fn devicerequest_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Devicerequest, Err) {
  any_read(id, client, "DeviceRequest", r4b.devicerequest_decoder())
}

pub fn devicerequest_update(
  resource: r4b.Devicerequest,
  client: FhirClient,
) -> Result(r4b.Devicerequest, Err) {
  any_update(
    resource.id,
    r4b.devicerequest_to_json(resource),
    "DeviceRequest",
    r4b.devicerequest_decoder(),
    client,
  )
}

pub fn devicerequest_delete(
  resource: r4b.Devicerequest,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "DeviceRequest", client)
}

pub fn devicerequest_search_bundled(
  sp: r4b_sansio.SpDevicerequest,
  client: FhirClient,
) {
  let req = r4b_sansio.devicerequest_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn devicerequest_search(
  sp: r4b_sansio.SpDevicerequest,
  client: FhirClient,
) -> Result(List(r4b.Devicerequest), Err) {
  let req = r4b_sansio.devicerequest_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.devicerequest
  })
}

pub fn deviceusestatement_create(
  resource: r4b.Deviceusestatement,
  client: FhirClient,
) -> Result(r4b.Deviceusestatement, Err) {
  any_create(
    r4b.deviceusestatement_to_json(resource),
    "DeviceUseStatement",
    r4b.deviceusestatement_decoder(),
    client,
  )
}

pub fn deviceusestatement_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Deviceusestatement, Err) {
  any_read(id, client, "DeviceUseStatement", r4b.deviceusestatement_decoder())
}

pub fn deviceusestatement_update(
  resource: r4b.Deviceusestatement,
  client: FhirClient,
) -> Result(r4b.Deviceusestatement, Err) {
  any_update(
    resource.id,
    r4b.deviceusestatement_to_json(resource),
    "DeviceUseStatement",
    r4b.deviceusestatement_decoder(),
    client,
  )
}

pub fn deviceusestatement_delete(
  resource: r4b.Deviceusestatement,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "DeviceUseStatement", client)
}

pub fn deviceusestatement_search_bundled(
  sp: r4b_sansio.SpDeviceusestatement,
  client: FhirClient,
) {
  let req = r4b_sansio.deviceusestatement_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn deviceusestatement_search(
  sp: r4b_sansio.SpDeviceusestatement,
  client: FhirClient,
) -> Result(List(r4b.Deviceusestatement), Err) {
  let req = r4b_sansio.deviceusestatement_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.deviceusestatement
  })
}

pub fn diagnosticreport_create(
  resource: r4b.Diagnosticreport,
  client: FhirClient,
) -> Result(r4b.Diagnosticreport, Err) {
  any_create(
    r4b.diagnosticreport_to_json(resource),
    "DiagnosticReport",
    r4b.diagnosticreport_decoder(),
    client,
  )
}

pub fn diagnosticreport_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Diagnosticreport, Err) {
  any_read(id, client, "DiagnosticReport", r4b.diagnosticreport_decoder())
}

pub fn diagnosticreport_update(
  resource: r4b.Diagnosticreport,
  client: FhirClient,
) -> Result(r4b.Diagnosticreport, Err) {
  any_update(
    resource.id,
    r4b.diagnosticreport_to_json(resource),
    "DiagnosticReport",
    r4b.diagnosticreport_decoder(),
    client,
  )
}

pub fn diagnosticreport_delete(
  resource: r4b.Diagnosticreport,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "DiagnosticReport", client)
}

pub fn diagnosticreport_search_bundled(
  sp: r4b_sansio.SpDiagnosticreport,
  client: FhirClient,
) {
  let req = r4b_sansio.diagnosticreport_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn diagnosticreport_search(
  sp: r4b_sansio.SpDiagnosticreport,
  client: FhirClient,
) -> Result(List(r4b.Diagnosticreport), Err) {
  let req = r4b_sansio.diagnosticreport_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.diagnosticreport
  })
}

pub fn documentmanifest_create(
  resource: r4b.Documentmanifest,
  client: FhirClient,
) -> Result(r4b.Documentmanifest, Err) {
  any_create(
    r4b.documentmanifest_to_json(resource),
    "DocumentManifest",
    r4b.documentmanifest_decoder(),
    client,
  )
}

pub fn documentmanifest_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Documentmanifest, Err) {
  any_read(id, client, "DocumentManifest", r4b.documentmanifest_decoder())
}

pub fn documentmanifest_update(
  resource: r4b.Documentmanifest,
  client: FhirClient,
) -> Result(r4b.Documentmanifest, Err) {
  any_update(
    resource.id,
    r4b.documentmanifest_to_json(resource),
    "DocumentManifest",
    r4b.documentmanifest_decoder(),
    client,
  )
}

pub fn documentmanifest_delete(
  resource: r4b.Documentmanifest,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "DocumentManifest", client)
}

pub fn documentmanifest_search_bundled(
  sp: r4b_sansio.SpDocumentmanifest,
  client: FhirClient,
) {
  let req = r4b_sansio.documentmanifest_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn documentmanifest_search(
  sp: r4b_sansio.SpDocumentmanifest,
  client: FhirClient,
) -> Result(List(r4b.Documentmanifest), Err) {
  let req = r4b_sansio.documentmanifest_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.documentmanifest
  })
}

pub fn documentreference_create(
  resource: r4b.Documentreference,
  client: FhirClient,
) -> Result(r4b.Documentreference, Err) {
  any_create(
    r4b.documentreference_to_json(resource),
    "DocumentReference",
    r4b.documentreference_decoder(),
    client,
  )
}

pub fn documentreference_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Documentreference, Err) {
  any_read(id, client, "DocumentReference", r4b.documentreference_decoder())
}

pub fn documentreference_update(
  resource: r4b.Documentreference,
  client: FhirClient,
) -> Result(r4b.Documentreference, Err) {
  any_update(
    resource.id,
    r4b.documentreference_to_json(resource),
    "DocumentReference",
    r4b.documentreference_decoder(),
    client,
  )
}

pub fn documentreference_delete(
  resource: r4b.Documentreference,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "DocumentReference", client)
}

pub fn documentreference_search_bundled(
  sp: r4b_sansio.SpDocumentreference,
  client: FhirClient,
) {
  let req = r4b_sansio.documentreference_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn documentreference_search(
  sp: r4b_sansio.SpDocumentreference,
  client: FhirClient,
) -> Result(List(r4b.Documentreference), Err) {
  let req = r4b_sansio.documentreference_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.documentreference
  })
}

pub fn encounter_create(
  resource: r4b.Encounter,
  client: FhirClient,
) -> Result(r4b.Encounter, Err) {
  any_create(
    r4b.encounter_to_json(resource),
    "Encounter",
    r4b.encounter_decoder(),
    client,
  )
}

pub fn encounter_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Encounter, Err) {
  any_read(id, client, "Encounter", r4b.encounter_decoder())
}

pub fn encounter_update(
  resource: r4b.Encounter,
  client: FhirClient,
) -> Result(r4b.Encounter, Err) {
  any_update(
    resource.id,
    r4b.encounter_to_json(resource),
    "Encounter",
    r4b.encounter_decoder(),
    client,
  )
}

pub fn encounter_delete(
  resource: r4b.Encounter,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Encounter", client)
}

pub fn encounter_search_bundled(sp: r4b_sansio.SpEncounter, client: FhirClient) {
  let req = r4b_sansio.encounter_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn encounter_search(
  sp: r4b_sansio.SpEncounter,
  client: FhirClient,
) -> Result(List(r4b.Encounter), Err) {
  let req = r4b_sansio.encounter_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.encounter
  })
}

pub fn endpoint_create(
  resource: r4b.Endpoint,
  client: FhirClient,
) -> Result(r4b.Endpoint, Err) {
  any_create(
    r4b.endpoint_to_json(resource),
    "Endpoint",
    r4b.endpoint_decoder(),
    client,
  )
}

pub fn endpoint_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Endpoint, Err) {
  any_read(id, client, "Endpoint", r4b.endpoint_decoder())
}

pub fn endpoint_update(
  resource: r4b.Endpoint,
  client: FhirClient,
) -> Result(r4b.Endpoint, Err) {
  any_update(
    resource.id,
    r4b.endpoint_to_json(resource),
    "Endpoint",
    r4b.endpoint_decoder(),
    client,
  )
}

pub fn endpoint_delete(
  resource: r4b.Endpoint,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Endpoint", client)
}

pub fn endpoint_search_bundled(sp: r4b_sansio.SpEndpoint, client: FhirClient) {
  let req = r4b_sansio.endpoint_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn endpoint_search(
  sp: r4b_sansio.SpEndpoint,
  client: FhirClient,
) -> Result(List(r4b.Endpoint), Err) {
  let req = r4b_sansio.endpoint_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.endpoint
  })
}

pub fn enrollmentrequest_create(
  resource: r4b.Enrollmentrequest,
  client: FhirClient,
) -> Result(r4b.Enrollmentrequest, Err) {
  any_create(
    r4b.enrollmentrequest_to_json(resource),
    "EnrollmentRequest",
    r4b.enrollmentrequest_decoder(),
    client,
  )
}

pub fn enrollmentrequest_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Enrollmentrequest, Err) {
  any_read(id, client, "EnrollmentRequest", r4b.enrollmentrequest_decoder())
}

pub fn enrollmentrequest_update(
  resource: r4b.Enrollmentrequest,
  client: FhirClient,
) -> Result(r4b.Enrollmentrequest, Err) {
  any_update(
    resource.id,
    r4b.enrollmentrequest_to_json(resource),
    "EnrollmentRequest",
    r4b.enrollmentrequest_decoder(),
    client,
  )
}

pub fn enrollmentrequest_delete(
  resource: r4b.Enrollmentrequest,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "EnrollmentRequest", client)
}

pub fn enrollmentrequest_search_bundled(
  sp: r4b_sansio.SpEnrollmentrequest,
  client: FhirClient,
) {
  let req = r4b_sansio.enrollmentrequest_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn enrollmentrequest_search(
  sp: r4b_sansio.SpEnrollmentrequest,
  client: FhirClient,
) -> Result(List(r4b.Enrollmentrequest), Err) {
  let req = r4b_sansio.enrollmentrequest_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.enrollmentrequest
  })
}

pub fn enrollmentresponse_create(
  resource: r4b.Enrollmentresponse,
  client: FhirClient,
) -> Result(r4b.Enrollmentresponse, Err) {
  any_create(
    r4b.enrollmentresponse_to_json(resource),
    "EnrollmentResponse",
    r4b.enrollmentresponse_decoder(),
    client,
  )
}

pub fn enrollmentresponse_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Enrollmentresponse, Err) {
  any_read(id, client, "EnrollmentResponse", r4b.enrollmentresponse_decoder())
}

pub fn enrollmentresponse_update(
  resource: r4b.Enrollmentresponse,
  client: FhirClient,
) -> Result(r4b.Enrollmentresponse, Err) {
  any_update(
    resource.id,
    r4b.enrollmentresponse_to_json(resource),
    "EnrollmentResponse",
    r4b.enrollmentresponse_decoder(),
    client,
  )
}

pub fn enrollmentresponse_delete(
  resource: r4b.Enrollmentresponse,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "EnrollmentResponse", client)
}

pub fn enrollmentresponse_search_bundled(
  sp: r4b_sansio.SpEnrollmentresponse,
  client: FhirClient,
) {
  let req = r4b_sansio.enrollmentresponse_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn enrollmentresponse_search(
  sp: r4b_sansio.SpEnrollmentresponse,
  client: FhirClient,
) -> Result(List(r4b.Enrollmentresponse), Err) {
  let req = r4b_sansio.enrollmentresponse_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.enrollmentresponse
  })
}

pub fn episodeofcare_create(
  resource: r4b.Episodeofcare,
  client: FhirClient,
) -> Result(r4b.Episodeofcare, Err) {
  any_create(
    r4b.episodeofcare_to_json(resource),
    "EpisodeOfCare",
    r4b.episodeofcare_decoder(),
    client,
  )
}

pub fn episodeofcare_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Episodeofcare, Err) {
  any_read(id, client, "EpisodeOfCare", r4b.episodeofcare_decoder())
}

pub fn episodeofcare_update(
  resource: r4b.Episodeofcare,
  client: FhirClient,
) -> Result(r4b.Episodeofcare, Err) {
  any_update(
    resource.id,
    r4b.episodeofcare_to_json(resource),
    "EpisodeOfCare",
    r4b.episodeofcare_decoder(),
    client,
  )
}

pub fn episodeofcare_delete(
  resource: r4b.Episodeofcare,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "EpisodeOfCare", client)
}

pub fn episodeofcare_search_bundled(
  sp: r4b_sansio.SpEpisodeofcare,
  client: FhirClient,
) {
  let req = r4b_sansio.episodeofcare_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn episodeofcare_search(
  sp: r4b_sansio.SpEpisodeofcare,
  client: FhirClient,
) -> Result(List(r4b.Episodeofcare), Err) {
  let req = r4b_sansio.episodeofcare_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.episodeofcare
  })
}

pub fn eventdefinition_create(
  resource: r4b.Eventdefinition,
  client: FhirClient,
) -> Result(r4b.Eventdefinition, Err) {
  any_create(
    r4b.eventdefinition_to_json(resource),
    "EventDefinition",
    r4b.eventdefinition_decoder(),
    client,
  )
}

pub fn eventdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Eventdefinition, Err) {
  any_read(id, client, "EventDefinition", r4b.eventdefinition_decoder())
}

pub fn eventdefinition_update(
  resource: r4b.Eventdefinition,
  client: FhirClient,
) -> Result(r4b.Eventdefinition, Err) {
  any_update(
    resource.id,
    r4b.eventdefinition_to_json(resource),
    "EventDefinition",
    r4b.eventdefinition_decoder(),
    client,
  )
}

pub fn eventdefinition_delete(
  resource: r4b.Eventdefinition,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "EventDefinition", client)
}

pub fn eventdefinition_search_bundled(
  sp: r4b_sansio.SpEventdefinition,
  client: FhirClient,
) {
  let req = r4b_sansio.eventdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn eventdefinition_search(
  sp: r4b_sansio.SpEventdefinition,
  client: FhirClient,
) -> Result(List(r4b.Eventdefinition), Err) {
  let req = r4b_sansio.eventdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.eventdefinition
  })
}

pub fn evidence_create(
  resource: r4b.Evidence,
  client: FhirClient,
) -> Result(r4b.Evidence, Err) {
  any_create(
    r4b.evidence_to_json(resource),
    "Evidence",
    r4b.evidence_decoder(),
    client,
  )
}

pub fn evidence_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Evidence, Err) {
  any_read(id, client, "Evidence", r4b.evidence_decoder())
}

pub fn evidence_update(
  resource: r4b.Evidence,
  client: FhirClient,
) -> Result(r4b.Evidence, Err) {
  any_update(
    resource.id,
    r4b.evidence_to_json(resource),
    "Evidence",
    r4b.evidence_decoder(),
    client,
  )
}

pub fn evidence_delete(
  resource: r4b.Evidence,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Evidence", client)
}

pub fn evidence_search_bundled(sp: r4b_sansio.SpEvidence, client: FhirClient) {
  let req = r4b_sansio.evidence_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn evidence_search(
  sp: r4b_sansio.SpEvidence,
  client: FhirClient,
) -> Result(List(r4b.Evidence), Err) {
  let req = r4b_sansio.evidence_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.evidence
  })
}

pub fn evidencereport_create(
  resource: r4b.Evidencereport,
  client: FhirClient,
) -> Result(r4b.Evidencereport, Err) {
  any_create(
    r4b.evidencereport_to_json(resource),
    "EvidenceReport",
    r4b.evidencereport_decoder(),
    client,
  )
}

pub fn evidencereport_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Evidencereport, Err) {
  any_read(id, client, "EvidenceReport", r4b.evidencereport_decoder())
}

pub fn evidencereport_update(
  resource: r4b.Evidencereport,
  client: FhirClient,
) -> Result(r4b.Evidencereport, Err) {
  any_update(
    resource.id,
    r4b.evidencereport_to_json(resource),
    "EvidenceReport",
    r4b.evidencereport_decoder(),
    client,
  )
}

pub fn evidencereport_delete(
  resource: r4b.Evidencereport,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "EvidenceReport", client)
}

pub fn evidencereport_search_bundled(
  sp: r4b_sansio.SpEvidencereport,
  client: FhirClient,
) {
  let req = r4b_sansio.evidencereport_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn evidencereport_search(
  sp: r4b_sansio.SpEvidencereport,
  client: FhirClient,
) -> Result(List(r4b.Evidencereport), Err) {
  let req = r4b_sansio.evidencereport_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.evidencereport
  })
}

pub fn evidencevariable_create(
  resource: r4b.Evidencevariable,
  client: FhirClient,
) -> Result(r4b.Evidencevariable, Err) {
  any_create(
    r4b.evidencevariable_to_json(resource),
    "EvidenceVariable",
    r4b.evidencevariable_decoder(),
    client,
  )
}

pub fn evidencevariable_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Evidencevariable, Err) {
  any_read(id, client, "EvidenceVariable", r4b.evidencevariable_decoder())
}

pub fn evidencevariable_update(
  resource: r4b.Evidencevariable,
  client: FhirClient,
) -> Result(r4b.Evidencevariable, Err) {
  any_update(
    resource.id,
    r4b.evidencevariable_to_json(resource),
    "EvidenceVariable",
    r4b.evidencevariable_decoder(),
    client,
  )
}

pub fn evidencevariable_delete(
  resource: r4b.Evidencevariable,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "EvidenceVariable", client)
}

pub fn evidencevariable_search_bundled(
  sp: r4b_sansio.SpEvidencevariable,
  client: FhirClient,
) {
  let req = r4b_sansio.evidencevariable_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn evidencevariable_search(
  sp: r4b_sansio.SpEvidencevariable,
  client: FhirClient,
) -> Result(List(r4b.Evidencevariable), Err) {
  let req = r4b_sansio.evidencevariable_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.evidencevariable
  })
}

pub fn examplescenario_create(
  resource: r4b.Examplescenario,
  client: FhirClient,
) -> Result(r4b.Examplescenario, Err) {
  any_create(
    r4b.examplescenario_to_json(resource),
    "ExampleScenario",
    r4b.examplescenario_decoder(),
    client,
  )
}

pub fn examplescenario_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Examplescenario, Err) {
  any_read(id, client, "ExampleScenario", r4b.examplescenario_decoder())
}

pub fn examplescenario_update(
  resource: r4b.Examplescenario,
  client: FhirClient,
) -> Result(r4b.Examplescenario, Err) {
  any_update(
    resource.id,
    r4b.examplescenario_to_json(resource),
    "ExampleScenario",
    r4b.examplescenario_decoder(),
    client,
  )
}

pub fn examplescenario_delete(
  resource: r4b.Examplescenario,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "ExampleScenario", client)
}

pub fn examplescenario_search_bundled(
  sp: r4b_sansio.SpExamplescenario,
  client: FhirClient,
) {
  let req = r4b_sansio.examplescenario_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn examplescenario_search(
  sp: r4b_sansio.SpExamplescenario,
  client: FhirClient,
) -> Result(List(r4b.Examplescenario), Err) {
  let req = r4b_sansio.examplescenario_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.examplescenario
  })
}

pub fn explanationofbenefit_create(
  resource: r4b.Explanationofbenefit,
  client: FhirClient,
) -> Result(r4b.Explanationofbenefit, Err) {
  any_create(
    r4b.explanationofbenefit_to_json(resource),
    "ExplanationOfBenefit",
    r4b.explanationofbenefit_decoder(),
    client,
  )
}

pub fn explanationofbenefit_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Explanationofbenefit, Err) {
  any_read(
    id,
    client,
    "ExplanationOfBenefit",
    r4b.explanationofbenefit_decoder(),
  )
}

pub fn explanationofbenefit_update(
  resource: r4b.Explanationofbenefit,
  client: FhirClient,
) -> Result(r4b.Explanationofbenefit, Err) {
  any_update(
    resource.id,
    r4b.explanationofbenefit_to_json(resource),
    "ExplanationOfBenefit",
    r4b.explanationofbenefit_decoder(),
    client,
  )
}

pub fn explanationofbenefit_delete(
  resource: r4b.Explanationofbenefit,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "ExplanationOfBenefit", client)
}

pub fn explanationofbenefit_search_bundled(
  sp: r4b_sansio.SpExplanationofbenefit,
  client: FhirClient,
) {
  let req = r4b_sansio.explanationofbenefit_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn explanationofbenefit_search(
  sp: r4b_sansio.SpExplanationofbenefit,
  client: FhirClient,
) -> Result(List(r4b.Explanationofbenefit), Err) {
  let req = r4b_sansio.explanationofbenefit_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.explanationofbenefit
  })
}

pub fn familymemberhistory_create(
  resource: r4b.Familymemberhistory,
  client: FhirClient,
) -> Result(r4b.Familymemberhistory, Err) {
  any_create(
    r4b.familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    r4b.familymemberhistory_decoder(),
    client,
  )
}

pub fn familymemberhistory_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Familymemberhistory, Err) {
  any_read(id, client, "FamilyMemberHistory", r4b.familymemberhistory_decoder())
}

pub fn familymemberhistory_update(
  resource: r4b.Familymemberhistory,
  client: FhirClient,
) -> Result(r4b.Familymemberhistory, Err) {
  any_update(
    resource.id,
    r4b.familymemberhistory_to_json(resource),
    "FamilyMemberHistory",
    r4b.familymemberhistory_decoder(),
    client,
  )
}

pub fn familymemberhistory_delete(
  resource: r4b.Familymemberhistory,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "FamilyMemberHistory", client)
}

pub fn familymemberhistory_search_bundled(
  sp: r4b_sansio.SpFamilymemberhistory,
  client: FhirClient,
) {
  let req = r4b_sansio.familymemberhistory_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn familymemberhistory_search(
  sp: r4b_sansio.SpFamilymemberhistory,
  client: FhirClient,
) -> Result(List(r4b.Familymemberhistory), Err) {
  let req = r4b_sansio.familymemberhistory_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.familymemberhistory
  })
}

pub fn flag_create(
  resource: r4b.Flag,
  client: FhirClient,
) -> Result(r4b.Flag, Err) {
  any_create(r4b.flag_to_json(resource), "Flag", r4b.flag_decoder(), client)
}

pub fn flag_read(id: String, client: FhirClient) -> Result(r4b.Flag, Err) {
  any_read(id, client, "Flag", r4b.flag_decoder())
}

pub fn flag_update(
  resource: r4b.Flag,
  client: FhirClient,
) -> Result(r4b.Flag, Err) {
  any_update(
    resource.id,
    r4b.flag_to_json(resource),
    "Flag",
    r4b.flag_decoder(),
    client,
  )
}

pub fn flag_delete(
  resource: r4b.Flag,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Flag", client)
}

pub fn flag_search_bundled(sp: r4b_sansio.SpFlag, client: FhirClient) {
  let req = r4b_sansio.flag_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn flag_search(
  sp: r4b_sansio.SpFlag,
  client: FhirClient,
) -> Result(List(r4b.Flag), Err) {
  let req = r4b_sansio.flag_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.flag
  })
}

pub fn goal_create(
  resource: r4b.Goal,
  client: FhirClient,
) -> Result(r4b.Goal, Err) {
  any_create(r4b.goal_to_json(resource), "Goal", r4b.goal_decoder(), client)
}

pub fn goal_read(id: String, client: FhirClient) -> Result(r4b.Goal, Err) {
  any_read(id, client, "Goal", r4b.goal_decoder())
}

pub fn goal_update(
  resource: r4b.Goal,
  client: FhirClient,
) -> Result(r4b.Goal, Err) {
  any_update(
    resource.id,
    r4b.goal_to_json(resource),
    "Goal",
    r4b.goal_decoder(),
    client,
  )
}

pub fn goal_delete(
  resource: r4b.Goal,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Goal", client)
}

pub fn goal_search_bundled(sp: r4b_sansio.SpGoal, client: FhirClient) {
  let req = r4b_sansio.goal_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn goal_search(
  sp: r4b_sansio.SpGoal,
  client: FhirClient,
) -> Result(List(r4b.Goal), Err) {
  let req = r4b_sansio.goal_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.goal
  })
}

pub fn graphdefinition_create(
  resource: r4b.Graphdefinition,
  client: FhirClient,
) -> Result(r4b.Graphdefinition, Err) {
  any_create(
    r4b.graphdefinition_to_json(resource),
    "GraphDefinition",
    r4b.graphdefinition_decoder(),
    client,
  )
}

pub fn graphdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Graphdefinition, Err) {
  any_read(id, client, "GraphDefinition", r4b.graphdefinition_decoder())
}

pub fn graphdefinition_update(
  resource: r4b.Graphdefinition,
  client: FhirClient,
) -> Result(r4b.Graphdefinition, Err) {
  any_update(
    resource.id,
    r4b.graphdefinition_to_json(resource),
    "GraphDefinition",
    r4b.graphdefinition_decoder(),
    client,
  )
}

pub fn graphdefinition_delete(
  resource: r4b.Graphdefinition,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "GraphDefinition", client)
}

pub fn graphdefinition_search_bundled(
  sp: r4b_sansio.SpGraphdefinition,
  client: FhirClient,
) {
  let req = r4b_sansio.graphdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn graphdefinition_search(
  sp: r4b_sansio.SpGraphdefinition,
  client: FhirClient,
) -> Result(List(r4b.Graphdefinition), Err) {
  let req = r4b_sansio.graphdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.graphdefinition
  })
}

pub fn group_create(
  resource: r4b.Group,
  client: FhirClient,
) -> Result(r4b.Group, Err) {
  any_create(r4b.group_to_json(resource), "Group", r4b.group_decoder(), client)
}

pub fn group_read(id: String, client: FhirClient) -> Result(r4b.Group, Err) {
  any_read(id, client, "Group", r4b.group_decoder())
}

pub fn group_update(
  resource: r4b.Group,
  client: FhirClient,
) -> Result(r4b.Group, Err) {
  any_update(
    resource.id,
    r4b.group_to_json(resource),
    "Group",
    r4b.group_decoder(),
    client,
  )
}

pub fn group_delete(
  resource: r4b.Group,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Group", client)
}

pub fn group_search_bundled(sp: r4b_sansio.SpGroup, client: FhirClient) {
  let req = r4b_sansio.group_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn group_search(
  sp: r4b_sansio.SpGroup,
  client: FhirClient,
) -> Result(List(r4b.Group), Err) {
  let req = r4b_sansio.group_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.group
  })
}

pub fn guidanceresponse_create(
  resource: r4b.Guidanceresponse,
  client: FhirClient,
) -> Result(r4b.Guidanceresponse, Err) {
  any_create(
    r4b.guidanceresponse_to_json(resource),
    "GuidanceResponse",
    r4b.guidanceresponse_decoder(),
    client,
  )
}

pub fn guidanceresponse_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Guidanceresponse, Err) {
  any_read(id, client, "GuidanceResponse", r4b.guidanceresponse_decoder())
}

pub fn guidanceresponse_update(
  resource: r4b.Guidanceresponse,
  client: FhirClient,
) -> Result(r4b.Guidanceresponse, Err) {
  any_update(
    resource.id,
    r4b.guidanceresponse_to_json(resource),
    "GuidanceResponse",
    r4b.guidanceresponse_decoder(),
    client,
  )
}

pub fn guidanceresponse_delete(
  resource: r4b.Guidanceresponse,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "GuidanceResponse", client)
}

pub fn guidanceresponse_search_bundled(
  sp: r4b_sansio.SpGuidanceresponse,
  client: FhirClient,
) {
  let req = r4b_sansio.guidanceresponse_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn guidanceresponse_search(
  sp: r4b_sansio.SpGuidanceresponse,
  client: FhirClient,
) -> Result(List(r4b.Guidanceresponse), Err) {
  let req = r4b_sansio.guidanceresponse_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.guidanceresponse
  })
}

pub fn healthcareservice_create(
  resource: r4b.Healthcareservice,
  client: FhirClient,
) -> Result(r4b.Healthcareservice, Err) {
  any_create(
    r4b.healthcareservice_to_json(resource),
    "HealthcareService",
    r4b.healthcareservice_decoder(),
    client,
  )
}

pub fn healthcareservice_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Healthcareservice, Err) {
  any_read(id, client, "HealthcareService", r4b.healthcareservice_decoder())
}

pub fn healthcareservice_update(
  resource: r4b.Healthcareservice,
  client: FhirClient,
) -> Result(r4b.Healthcareservice, Err) {
  any_update(
    resource.id,
    r4b.healthcareservice_to_json(resource),
    "HealthcareService",
    r4b.healthcareservice_decoder(),
    client,
  )
}

pub fn healthcareservice_delete(
  resource: r4b.Healthcareservice,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "HealthcareService", client)
}

pub fn healthcareservice_search_bundled(
  sp: r4b_sansio.SpHealthcareservice,
  client: FhirClient,
) {
  let req = r4b_sansio.healthcareservice_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn healthcareservice_search(
  sp: r4b_sansio.SpHealthcareservice,
  client: FhirClient,
) -> Result(List(r4b.Healthcareservice), Err) {
  let req = r4b_sansio.healthcareservice_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.healthcareservice
  })
}

pub fn imagingstudy_create(
  resource: r4b.Imagingstudy,
  client: FhirClient,
) -> Result(r4b.Imagingstudy, Err) {
  any_create(
    r4b.imagingstudy_to_json(resource),
    "ImagingStudy",
    r4b.imagingstudy_decoder(),
    client,
  )
}

pub fn imagingstudy_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Imagingstudy, Err) {
  any_read(id, client, "ImagingStudy", r4b.imagingstudy_decoder())
}

pub fn imagingstudy_update(
  resource: r4b.Imagingstudy,
  client: FhirClient,
) -> Result(r4b.Imagingstudy, Err) {
  any_update(
    resource.id,
    r4b.imagingstudy_to_json(resource),
    "ImagingStudy",
    r4b.imagingstudy_decoder(),
    client,
  )
}

pub fn imagingstudy_delete(
  resource: r4b.Imagingstudy,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "ImagingStudy", client)
}

pub fn imagingstudy_search_bundled(
  sp: r4b_sansio.SpImagingstudy,
  client: FhirClient,
) {
  let req = r4b_sansio.imagingstudy_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn imagingstudy_search(
  sp: r4b_sansio.SpImagingstudy,
  client: FhirClient,
) -> Result(List(r4b.Imagingstudy), Err) {
  let req = r4b_sansio.imagingstudy_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.imagingstudy
  })
}

pub fn immunization_create(
  resource: r4b.Immunization,
  client: FhirClient,
) -> Result(r4b.Immunization, Err) {
  any_create(
    r4b.immunization_to_json(resource),
    "Immunization",
    r4b.immunization_decoder(),
    client,
  )
}

pub fn immunization_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Immunization, Err) {
  any_read(id, client, "Immunization", r4b.immunization_decoder())
}

pub fn immunization_update(
  resource: r4b.Immunization,
  client: FhirClient,
) -> Result(r4b.Immunization, Err) {
  any_update(
    resource.id,
    r4b.immunization_to_json(resource),
    "Immunization",
    r4b.immunization_decoder(),
    client,
  )
}

pub fn immunization_delete(
  resource: r4b.Immunization,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Immunization", client)
}

pub fn immunization_search_bundled(
  sp: r4b_sansio.SpImmunization,
  client: FhirClient,
) {
  let req = r4b_sansio.immunization_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn immunization_search(
  sp: r4b_sansio.SpImmunization,
  client: FhirClient,
) -> Result(List(r4b.Immunization), Err) {
  let req = r4b_sansio.immunization_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.immunization
  })
}

pub fn immunizationevaluation_create(
  resource: r4b.Immunizationevaluation,
  client: FhirClient,
) -> Result(r4b.Immunizationevaluation, Err) {
  any_create(
    r4b.immunizationevaluation_to_json(resource),
    "ImmunizationEvaluation",
    r4b.immunizationevaluation_decoder(),
    client,
  )
}

pub fn immunizationevaluation_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Immunizationevaluation, Err) {
  any_read(
    id,
    client,
    "ImmunizationEvaluation",
    r4b.immunizationevaluation_decoder(),
  )
}

pub fn immunizationevaluation_update(
  resource: r4b.Immunizationevaluation,
  client: FhirClient,
) -> Result(r4b.Immunizationevaluation, Err) {
  any_update(
    resource.id,
    r4b.immunizationevaluation_to_json(resource),
    "ImmunizationEvaluation",
    r4b.immunizationevaluation_decoder(),
    client,
  )
}

pub fn immunizationevaluation_delete(
  resource: r4b.Immunizationevaluation,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "ImmunizationEvaluation", client)
}

pub fn immunizationevaluation_search_bundled(
  sp: r4b_sansio.SpImmunizationevaluation,
  client: FhirClient,
) {
  let req = r4b_sansio.immunizationevaluation_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn immunizationevaluation_search(
  sp: r4b_sansio.SpImmunizationevaluation,
  client: FhirClient,
) -> Result(List(r4b.Immunizationevaluation), Err) {
  let req = r4b_sansio.immunizationevaluation_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.immunizationevaluation
  })
}

pub fn immunizationrecommendation_create(
  resource: r4b.Immunizationrecommendation,
  client: FhirClient,
) -> Result(r4b.Immunizationrecommendation, Err) {
  any_create(
    r4b.immunizationrecommendation_to_json(resource),
    "ImmunizationRecommendation",
    r4b.immunizationrecommendation_decoder(),
    client,
  )
}

pub fn immunizationrecommendation_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Immunizationrecommendation, Err) {
  any_read(
    id,
    client,
    "ImmunizationRecommendation",
    r4b.immunizationrecommendation_decoder(),
  )
}

pub fn immunizationrecommendation_update(
  resource: r4b.Immunizationrecommendation,
  client: FhirClient,
) -> Result(r4b.Immunizationrecommendation, Err) {
  any_update(
    resource.id,
    r4b.immunizationrecommendation_to_json(resource),
    "ImmunizationRecommendation",
    r4b.immunizationrecommendation_decoder(),
    client,
  )
}

pub fn immunizationrecommendation_delete(
  resource: r4b.Immunizationrecommendation,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "ImmunizationRecommendation", client)
}

pub fn immunizationrecommendation_search_bundled(
  sp: r4b_sansio.SpImmunizationrecommendation,
  client: FhirClient,
) {
  let req = r4b_sansio.immunizationrecommendation_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn immunizationrecommendation_search(
  sp: r4b_sansio.SpImmunizationrecommendation,
  client: FhirClient,
) -> Result(List(r4b.Immunizationrecommendation), Err) {
  let req = r4b_sansio.immunizationrecommendation_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.immunizationrecommendation
  })
}

pub fn implementationguide_create(
  resource: r4b.Implementationguide,
  client: FhirClient,
) -> Result(r4b.Implementationguide, Err) {
  any_create(
    r4b.implementationguide_to_json(resource),
    "ImplementationGuide",
    r4b.implementationguide_decoder(),
    client,
  )
}

pub fn implementationguide_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Implementationguide, Err) {
  any_read(id, client, "ImplementationGuide", r4b.implementationguide_decoder())
}

pub fn implementationguide_update(
  resource: r4b.Implementationguide,
  client: FhirClient,
) -> Result(r4b.Implementationguide, Err) {
  any_update(
    resource.id,
    r4b.implementationguide_to_json(resource),
    "ImplementationGuide",
    r4b.implementationguide_decoder(),
    client,
  )
}

pub fn implementationguide_delete(
  resource: r4b.Implementationguide,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "ImplementationGuide", client)
}

pub fn implementationguide_search_bundled(
  sp: r4b_sansio.SpImplementationguide,
  client: FhirClient,
) {
  let req = r4b_sansio.implementationguide_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn implementationguide_search(
  sp: r4b_sansio.SpImplementationguide,
  client: FhirClient,
) -> Result(List(r4b.Implementationguide), Err) {
  let req = r4b_sansio.implementationguide_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.implementationguide
  })
}

pub fn ingredient_create(
  resource: r4b.Ingredient,
  client: FhirClient,
) -> Result(r4b.Ingredient, Err) {
  any_create(
    r4b.ingredient_to_json(resource),
    "Ingredient",
    r4b.ingredient_decoder(),
    client,
  )
}

pub fn ingredient_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Ingredient, Err) {
  any_read(id, client, "Ingredient", r4b.ingredient_decoder())
}

pub fn ingredient_update(
  resource: r4b.Ingredient,
  client: FhirClient,
) -> Result(r4b.Ingredient, Err) {
  any_update(
    resource.id,
    r4b.ingredient_to_json(resource),
    "Ingredient",
    r4b.ingredient_decoder(),
    client,
  )
}

pub fn ingredient_delete(
  resource: r4b.Ingredient,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Ingredient", client)
}

pub fn ingredient_search_bundled(
  sp: r4b_sansio.SpIngredient,
  client: FhirClient,
) {
  let req = r4b_sansio.ingredient_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn ingredient_search(
  sp: r4b_sansio.SpIngredient,
  client: FhirClient,
) -> Result(List(r4b.Ingredient), Err) {
  let req = r4b_sansio.ingredient_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.ingredient
  })
}

pub fn insuranceplan_create(
  resource: r4b.Insuranceplan,
  client: FhirClient,
) -> Result(r4b.Insuranceplan, Err) {
  any_create(
    r4b.insuranceplan_to_json(resource),
    "InsurancePlan",
    r4b.insuranceplan_decoder(),
    client,
  )
}

pub fn insuranceplan_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Insuranceplan, Err) {
  any_read(id, client, "InsurancePlan", r4b.insuranceplan_decoder())
}

pub fn insuranceplan_update(
  resource: r4b.Insuranceplan,
  client: FhirClient,
) -> Result(r4b.Insuranceplan, Err) {
  any_update(
    resource.id,
    r4b.insuranceplan_to_json(resource),
    "InsurancePlan",
    r4b.insuranceplan_decoder(),
    client,
  )
}

pub fn insuranceplan_delete(
  resource: r4b.Insuranceplan,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "InsurancePlan", client)
}

pub fn insuranceplan_search_bundled(
  sp: r4b_sansio.SpInsuranceplan,
  client: FhirClient,
) {
  let req = r4b_sansio.insuranceplan_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn insuranceplan_search(
  sp: r4b_sansio.SpInsuranceplan,
  client: FhirClient,
) -> Result(List(r4b.Insuranceplan), Err) {
  let req = r4b_sansio.insuranceplan_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.insuranceplan
  })
}

pub fn invoice_create(
  resource: r4b.Invoice,
  client: FhirClient,
) -> Result(r4b.Invoice, Err) {
  any_create(
    r4b.invoice_to_json(resource),
    "Invoice",
    r4b.invoice_decoder(),
    client,
  )
}

pub fn invoice_read(id: String, client: FhirClient) -> Result(r4b.Invoice, Err) {
  any_read(id, client, "Invoice", r4b.invoice_decoder())
}

pub fn invoice_update(
  resource: r4b.Invoice,
  client: FhirClient,
) -> Result(r4b.Invoice, Err) {
  any_update(
    resource.id,
    r4b.invoice_to_json(resource),
    "Invoice",
    r4b.invoice_decoder(),
    client,
  )
}

pub fn invoice_delete(
  resource: r4b.Invoice,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Invoice", client)
}

pub fn invoice_search_bundled(sp: r4b_sansio.SpInvoice, client: FhirClient) {
  let req = r4b_sansio.invoice_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn invoice_search(
  sp: r4b_sansio.SpInvoice,
  client: FhirClient,
) -> Result(List(r4b.Invoice), Err) {
  let req = r4b_sansio.invoice_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.invoice
  })
}

pub fn library_create(
  resource: r4b.Library,
  client: FhirClient,
) -> Result(r4b.Library, Err) {
  any_create(
    r4b.library_to_json(resource),
    "Library",
    r4b.library_decoder(),
    client,
  )
}

pub fn library_read(id: String, client: FhirClient) -> Result(r4b.Library, Err) {
  any_read(id, client, "Library", r4b.library_decoder())
}

pub fn library_update(
  resource: r4b.Library,
  client: FhirClient,
) -> Result(r4b.Library, Err) {
  any_update(
    resource.id,
    r4b.library_to_json(resource),
    "Library",
    r4b.library_decoder(),
    client,
  )
}

pub fn library_delete(
  resource: r4b.Library,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Library", client)
}

pub fn library_search_bundled(sp: r4b_sansio.SpLibrary, client: FhirClient) {
  let req = r4b_sansio.library_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn library_search(
  sp: r4b_sansio.SpLibrary,
  client: FhirClient,
) -> Result(List(r4b.Library), Err) {
  let req = r4b_sansio.library_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.library
  })
}

pub fn linkage_create(
  resource: r4b.Linkage,
  client: FhirClient,
) -> Result(r4b.Linkage, Err) {
  any_create(
    r4b.linkage_to_json(resource),
    "Linkage",
    r4b.linkage_decoder(),
    client,
  )
}

pub fn linkage_read(id: String, client: FhirClient) -> Result(r4b.Linkage, Err) {
  any_read(id, client, "Linkage", r4b.linkage_decoder())
}

pub fn linkage_update(
  resource: r4b.Linkage,
  client: FhirClient,
) -> Result(r4b.Linkage, Err) {
  any_update(
    resource.id,
    r4b.linkage_to_json(resource),
    "Linkage",
    r4b.linkage_decoder(),
    client,
  )
}

pub fn linkage_delete(
  resource: r4b.Linkage,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Linkage", client)
}

pub fn linkage_search_bundled(sp: r4b_sansio.SpLinkage, client: FhirClient) {
  let req = r4b_sansio.linkage_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn linkage_search(
  sp: r4b_sansio.SpLinkage,
  client: FhirClient,
) -> Result(List(r4b.Linkage), Err) {
  let req = r4b_sansio.linkage_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.linkage
  })
}

pub fn listfhir_create(
  resource: r4b.Listfhir,
  client: FhirClient,
) -> Result(r4b.Listfhir, Err) {
  any_create(
    r4b.listfhir_to_json(resource),
    "List",
    r4b.listfhir_decoder(),
    client,
  )
}

pub fn listfhir_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Listfhir, Err) {
  any_read(id, client, "List", r4b.listfhir_decoder())
}

pub fn listfhir_update(
  resource: r4b.Listfhir,
  client: FhirClient,
) -> Result(r4b.Listfhir, Err) {
  any_update(
    resource.id,
    r4b.listfhir_to_json(resource),
    "List",
    r4b.listfhir_decoder(),
    client,
  )
}

pub fn listfhir_delete(
  resource: r4b.Listfhir,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "List", client)
}

pub fn listfhir_search_bundled(sp: r4b_sansio.SpListfhir, client: FhirClient) {
  let req = r4b_sansio.listfhir_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn listfhir_search(
  sp: r4b_sansio.SpListfhir,
  client: FhirClient,
) -> Result(List(r4b.Listfhir), Err) {
  let req = r4b_sansio.listfhir_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.listfhir
  })
}

pub fn location_create(
  resource: r4b.Location,
  client: FhirClient,
) -> Result(r4b.Location, Err) {
  any_create(
    r4b.location_to_json(resource),
    "Location",
    r4b.location_decoder(),
    client,
  )
}

pub fn location_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Location, Err) {
  any_read(id, client, "Location", r4b.location_decoder())
}

pub fn location_update(
  resource: r4b.Location,
  client: FhirClient,
) -> Result(r4b.Location, Err) {
  any_update(
    resource.id,
    r4b.location_to_json(resource),
    "Location",
    r4b.location_decoder(),
    client,
  )
}

pub fn location_delete(
  resource: r4b.Location,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Location", client)
}

pub fn location_search_bundled(sp: r4b_sansio.SpLocation, client: FhirClient) {
  let req = r4b_sansio.location_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn location_search(
  sp: r4b_sansio.SpLocation,
  client: FhirClient,
) -> Result(List(r4b.Location), Err) {
  let req = r4b_sansio.location_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.location
  })
}

pub fn manufactureditemdefinition_create(
  resource: r4b.Manufactureditemdefinition,
  client: FhirClient,
) -> Result(r4b.Manufactureditemdefinition, Err) {
  any_create(
    r4b.manufactureditemdefinition_to_json(resource),
    "ManufacturedItemDefinition",
    r4b.manufactureditemdefinition_decoder(),
    client,
  )
}

pub fn manufactureditemdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Manufactureditemdefinition, Err) {
  any_read(
    id,
    client,
    "ManufacturedItemDefinition",
    r4b.manufactureditemdefinition_decoder(),
  )
}

pub fn manufactureditemdefinition_update(
  resource: r4b.Manufactureditemdefinition,
  client: FhirClient,
) -> Result(r4b.Manufactureditemdefinition, Err) {
  any_update(
    resource.id,
    r4b.manufactureditemdefinition_to_json(resource),
    "ManufacturedItemDefinition",
    r4b.manufactureditemdefinition_decoder(),
    client,
  )
}

pub fn manufactureditemdefinition_delete(
  resource: r4b.Manufactureditemdefinition,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "ManufacturedItemDefinition", client)
}

pub fn manufactureditemdefinition_search_bundled(
  sp: r4b_sansio.SpManufactureditemdefinition,
  client: FhirClient,
) {
  let req = r4b_sansio.manufactureditemdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn manufactureditemdefinition_search(
  sp: r4b_sansio.SpManufactureditemdefinition,
  client: FhirClient,
) -> Result(List(r4b.Manufactureditemdefinition), Err) {
  let req = r4b_sansio.manufactureditemdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.manufactureditemdefinition
  })
}

pub fn measure_create(
  resource: r4b.Measure,
  client: FhirClient,
) -> Result(r4b.Measure, Err) {
  any_create(
    r4b.measure_to_json(resource),
    "Measure",
    r4b.measure_decoder(),
    client,
  )
}

pub fn measure_read(id: String, client: FhirClient) -> Result(r4b.Measure, Err) {
  any_read(id, client, "Measure", r4b.measure_decoder())
}

pub fn measure_update(
  resource: r4b.Measure,
  client: FhirClient,
) -> Result(r4b.Measure, Err) {
  any_update(
    resource.id,
    r4b.measure_to_json(resource),
    "Measure",
    r4b.measure_decoder(),
    client,
  )
}

pub fn measure_delete(
  resource: r4b.Measure,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Measure", client)
}

pub fn measure_search_bundled(sp: r4b_sansio.SpMeasure, client: FhirClient) {
  let req = r4b_sansio.measure_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn measure_search(
  sp: r4b_sansio.SpMeasure,
  client: FhirClient,
) -> Result(List(r4b.Measure), Err) {
  let req = r4b_sansio.measure_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.measure
  })
}

pub fn measurereport_create(
  resource: r4b.Measurereport,
  client: FhirClient,
) -> Result(r4b.Measurereport, Err) {
  any_create(
    r4b.measurereport_to_json(resource),
    "MeasureReport",
    r4b.measurereport_decoder(),
    client,
  )
}

pub fn measurereport_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Measurereport, Err) {
  any_read(id, client, "MeasureReport", r4b.measurereport_decoder())
}

pub fn measurereport_update(
  resource: r4b.Measurereport,
  client: FhirClient,
) -> Result(r4b.Measurereport, Err) {
  any_update(
    resource.id,
    r4b.measurereport_to_json(resource),
    "MeasureReport",
    r4b.measurereport_decoder(),
    client,
  )
}

pub fn measurereport_delete(
  resource: r4b.Measurereport,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "MeasureReport", client)
}

pub fn measurereport_search_bundled(
  sp: r4b_sansio.SpMeasurereport,
  client: FhirClient,
) {
  let req = r4b_sansio.measurereport_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn measurereport_search(
  sp: r4b_sansio.SpMeasurereport,
  client: FhirClient,
) -> Result(List(r4b.Measurereport), Err) {
  let req = r4b_sansio.measurereport_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.measurereport
  })
}

pub fn media_create(
  resource: r4b.Media,
  client: FhirClient,
) -> Result(r4b.Media, Err) {
  any_create(r4b.media_to_json(resource), "Media", r4b.media_decoder(), client)
}

pub fn media_read(id: String, client: FhirClient) -> Result(r4b.Media, Err) {
  any_read(id, client, "Media", r4b.media_decoder())
}

pub fn media_update(
  resource: r4b.Media,
  client: FhirClient,
) -> Result(r4b.Media, Err) {
  any_update(
    resource.id,
    r4b.media_to_json(resource),
    "Media",
    r4b.media_decoder(),
    client,
  )
}

pub fn media_delete(
  resource: r4b.Media,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Media", client)
}

pub fn media_search_bundled(sp: r4b_sansio.SpMedia, client: FhirClient) {
  let req = r4b_sansio.media_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn media_search(
  sp: r4b_sansio.SpMedia,
  client: FhirClient,
) -> Result(List(r4b.Media), Err) {
  let req = r4b_sansio.media_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.media
  })
}

pub fn medication_create(
  resource: r4b.Medication,
  client: FhirClient,
) -> Result(r4b.Medication, Err) {
  any_create(
    r4b.medication_to_json(resource),
    "Medication",
    r4b.medication_decoder(),
    client,
  )
}

pub fn medication_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Medication, Err) {
  any_read(id, client, "Medication", r4b.medication_decoder())
}

pub fn medication_update(
  resource: r4b.Medication,
  client: FhirClient,
) -> Result(r4b.Medication, Err) {
  any_update(
    resource.id,
    r4b.medication_to_json(resource),
    "Medication",
    r4b.medication_decoder(),
    client,
  )
}

pub fn medication_delete(
  resource: r4b.Medication,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Medication", client)
}

pub fn medication_search_bundled(
  sp: r4b_sansio.SpMedication,
  client: FhirClient,
) {
  let req = r4b_sansio.medication_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn medication_search(
  sp: r4b_sansio.SpMedication,
  client: FhirClient,
) -> Result(List(r4b.Medication), Err) {
  let req = r4b_sansio.medication_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.medication
  })
}

pub fn medicationadministration_create(
  resource: r4b.Medicationadministration,
  client: FhirClient,
) -> Result(r4b.Medicationadministration, Err) {
  any_create(
    r4b.medicationadministration_to_json(resource),
    "MedicationAdministration",
    r4b.medicationadministration_decoder(),
    client,
  )
}

pub fn medicationadministration_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Medicationadministration, Err) {
  any_read(
    id,
    client,
    "MedicationAdministration",
    r4b.medicationadministration_decoder(),
  )
}

pub fn medicationadministration_update(
  resource: r4b.Medicationadministration,
  client: FhirClient,
) -> Result(r4b.Medicationadministration, Err) {
  any_update(
    resource.id,
    r4b.medicationadministration_to_json(resource),
    "MedicationAdministration",
    r4b.medicationadministration_decoder(),
    client,
  )
}

pub fn medicationadministration_delete(
  resource: r4b.Medicationadministration,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "MedicationAdministration", client)
}

pub fn medicationadministration_search_bundled(
  sp: r4b_sansio.SpMedicationadministration,
  client: FhirClient,
) {
  let req = r4b_sansio.medicationadministration_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn medicationadministration_search(
  sp: r4b_sansio.SpMedicationadministration,
  client: FhirClient,
) -> Result(List(r4b.Medicationadministration), Err) {
  let req = r4b_sansio.medicationadministration_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.medicationadministration
  })
}

pub fn medicationdispense_create(
  resource: r4b.Medicationdispense,
  client: FhirClient,
) -> Result(r4b.Medicationdispense, Err) {
  any_create(
    r4b.medicationdispense_to_json(resource),
    "MedicationDispense",
    r4b.medicationdispense_decoder(),
    client,
  )
}

pub fn medicationdispense_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Medicationdispense, Err) {
  any_read(id, client, "MedicationDispense", r4b.medicationdispense_decoder())
}

pub fn medicationdispense_update(
  resource: r4b.Medicationdispense,
  client: FhirClient,
) -> Result(r4b.Medicationdispense, Err) {
  any_update(
    resource.id,
    r4b.medicationdispense_to_json(resource),
    "MedicationDispense",
    r4b.medicationdispense_decoder(),
    client,
  )
}

pub fn medicationdispense_delete(
  resource: r4b.Medicationdispense,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "MedicationDispense", client)
}

pub fn medicationdispense_search_bundled(
  sp: r4b_sansio.SpMedicationdispense,
  client: FhirClient,
) {
  let req = r4b_sansio.medicationdispense_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn medicationdispense_search(
  sp: r4b_sansio.SpMedicationdispense,
  client: FhirClient,
) -> Result(List(r4b.Medicationdispense), Err) {
  let req = r4b_sansio.medicationdispense_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.medicationdispense
  })
}

pub fn medicationknowledge_create(
  resource: r4b.Medicationknowledge,
  client: FhirClient,
) -> Result(r4b.Medicationknowledge, Err) {
  any_create(
    r4b.medicationknowledge_to_json(resource),
    "MedicationKnowledge",
    r4b.medicationknowledge_decoder(),
    client,
  )
}

pub fn medicationknowledge_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Medicationknowledge, Err) {
  any_read(id, client, "MedicationKnowledge", r4b.medicationknowledge_decoder())
}

pub fn medicationknowledge_update(
  resource: r4b.Medicationknowledge,
  client: FhirClient,
) -> Result(r4b.Medicationknowledge, Err) {
  any_update(
    resource.id,
    r4b.medicationknowledge_to_json(resource),
    "MedicationKnowledge",
    r4b.medicationknowledge_decoder(),
    client,
  )
}

pub fn medicationknowledge_delete(
  resource: r4b.Medicationknowledge,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "MedicationKnowledge", client)
}

pub fn medicationknowledge_search_bundled(
  sp: r4b_sansio.SpMedicationknowledge,
  client: FhirClient,
) {
  let req = r4b_sansio.medicationknowledge_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn medicationknowledge_search(
  sp: r4b_sansio.SpMedicationknowledge,
  client: FhirClient,
) -> Result(List(r4b.Medicationknowledge), Err) {
  let req = r4b_sansio.medicationknowledge_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.medicationknowledge
  })
}

pub fn medicationrequest_create(
  resource: r4b.Medicationrequest,
  client: FhirClient,
) -> Result(r4b.Medicationrequest, Err) {
  any_create(
    r4b.medicationrequest_to_json(resource),
    "MedicationRequest",
    r4b.medicationrequest_decoder(),
    client,
  )
}

pub fn medicationrequest_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Medicationrequest, Err) {
  any_read(id, client, "MedicationRequest", r4b.medicationrequest_decoder())
}

pub fn medicationrequest_update(
  resource: r4b.Medicationrequest,
  client: FhirClient,
) -> Result(r4b.Medicationrequest, Err) {
  any_update(
    resource.id,
    r4b.medicationrequest_to_json(resource),
    "MedicationRequest",
    r4b.medicationrequest_decoder(),
    client,
  )
}

pub fn medicationrequest_delete(
  resource: r4b.Medicationrequest,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "MedicationRequest", client)
}

pub fn medicationrequest_search_bundled(
  sp: r4b_sansio.SpMedicationrequest,
  client: FhirClient,
) {
  let req = r4b_sansio.medicationrequest_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn medicationrequest_search(
  sp: r4b_sansio.SpMedicationrequest,
  client: FhirClient,
) -> Result(List(r4b.Medicationrequest), Err) {
  let req = r4b_sansio.medicationrequest_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.medicationrequest
  })
}

pub fn medicationstatement_create(
  resource: r4b.Medicationstatement,
  client: FhirClient,
) -> Result(r4b.Medicationstatement, Err) {
  any_create(
    r4b.medicationstatement_to_json(resource),
    "MedicationStatement",
    r4b.medicationstatement_decoder(),
    client,
  )
}

pub fn medicationstatement_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Medicationstatement, Err) {
  any_read(id, client, "MedicationStatement", r4b.medicationstatement_decoder())
}

pub fn medicationstatement_update(
  resource: r4b.Medicationstatement,
  client: FhirClient,
) -> Result(r4b.Medicationstatement, Err) {
  any_update(
    resource.id,
    r4b.medicationstatement_to_json(resource),
    "MedicationStatement",
    r4b.medicationstatement_decoder(),
    client,
  )
}

pub fn medicationstatement_delete(
  resource: r4b.Medicationstatement,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "MedicationStatement", client)
}

pub fn medicationstatement_search_bundled(
  sp: r4b_sansio.SpMedicationstatement,
  client: FhirClient,
) {
  let req = r4b_sansio.medicationstatement_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn medicationstatement_search(
  sp: r4b_sansio.SpMedicationstatement,
  client: FhirClient,
) -> Result(List(r4b.Medicationstatement), Err) {
  let req = r4b_sansio.medicationstatement_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.medicationstatement
  })
}

pub fn medicinalproductdefinition_create(
  resource: r4b.Medicinalproductdefinition,
  client: FhirClient,
) -> Result(r4b.Medicinalproductdefinition, Err) {
  any_create(
    r4b.medicinalproductdefinition_to_json(resource),
    "MedicinalProductDefinition",
    r4b.medicinalproductdefinition_decoder(),
    client,
  )
}

pub fn medicinalproductdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Medicinalproductdefinition, Err) {
  any_read(
    id,
    client,
    "MedicinalProductDefinition",
    r4b.medicinalproductdefinition_decoder(),
  )
}

pub fn medicinalproductdefinition_update(
  resource: r4b.Medicinalproductdefinition,
  client: FhirClient,
) -> Result(r4b.Medicinalproductdefinition, Err) {
  any_update(
    resource.id,
    r4b.medicinalproductdefinition_to_json(resource),
    "MedicinalProductDefinition",
    r4b.medicinalproductdefinition_decoder(),
    client,
  )
}

pub fn medicinalproductdefinition_delete(
  resource: r4b.Medicinalproductdefinition,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "MedicinalProductDefinition", client)
}

pub fn medicinalproductdefinition_search_bundled(
  sp: r4b_sansio.SpMedicinalproductdefinition,
  client: FhirClient,
) {
  let req = r4b_sansio.medicinalproductdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn medicinalproductdefinition_search(
  sp: r4b_sansio.SpMedicinalproductdefinition,
  client: FhirClient,
) -> Result(List(r4b.Medicinalproductdefinition), Err) {
  let req = r4b_sansio.medicinalproductdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.medicinalproductdefinition
  })
}

pub fn messagedefinition_create(
  resource: r4b.Messagedefinition,
  client: FhirClient,
) -> Result(r4b.Messagedefinition, Err) {
  any_create(
    r4b.messagedefinition_to_json(resource),
    "MessageDefinition",
    r4b.messagedefinition_decoder(),
    client,
  )
}

pub fn messagedefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Messagedefinition, Err) {
  any_read(id, client, "MessageDefinition", r4b.messagedefinition_decoder())
}

pub fn messagedefinition_update(
  resource: r4b.Messagedefinition,
  client: FhirClient,
) -> Result(r4b.Messagedefinition, Err) {
  any_update(
    resource.id,
    r4b.messagedefinition_to_json(resource),
    "MessageDefinition",
    r4b.messagedefinition_decoder(),
    client,
  )
}

pub fn messagedefinition_delete(
  resource: r4b.Messagedefinition,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "MessageDefinition", client)
}

pub fn messagedefinition_search_bundled(
  sp: r4b_sansio.SpMessagedefinition,
  client: FhirClient,
) {
  let req = r4b_sansio.messagedefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn messagedefinition_search(
  sp: r4b_sansio.SpMessagedefinition,
  client: FhirClient,
) -> Result(List(r4b.Messagedefinition), Err) {
  let req = r4b_sansio.messagedefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.messagedefinition
  })
}

pub fn messageheader_create(
  resource: r4b.Messageheader,
  client: FhirClient,
) -> Result(r4b.Messageheader, Err) {
  any_create(
    r4b.messageheader_to_json(resource),
    "MessageHeader",
    r4b.messageheader_decoder(),
    client,
  )
}

pub fn messageheader_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Messageheader, Err) {
  any_read(id, client, "MessageHeader", r4b.messageheader_decoder())
}

pub fn messageheader_update(
  resource: r4b.Messageheader,
  client: FhirClient,
) -> Result(r4b.Messageheader, Err) {
  any_update(
    resource.id,
    r4b.messageheader_to_json(resource),
    "MessageHeader",
    r4b.messageheader_decoder(),
    client,
  )
}

pub fn messageheader_delete(
  resource: r4b.Messageheader,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "MessageHeader", client)
}

pub fn messageheader_search_bundled(
  sp: r4b_sansio.SpMessageheader,
  client: FhirClient,
) {
  let req = r4b_sansio.messageheader_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn messageheader_search(
  sp: r4b_sansio.SpMessageheader,
  client: FhirClient,
) -> Result(List(r4b.Messageheader), Err) {
  let req = r4b_sansio.messageheader_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.messageheader
  })
}

pub fn molecularsequence_create(
  resource: r4b.Molecularsequence,
  client: FhirClient,
) -> Result(r4b.Molecularsequence, Err) {
  any_create(
    r4b.molecularsequence_to_json(resource),
    "MolecularSequence",
    r4b.molecularsequence_decoder(),
    client,
  )
}

pub fn molecularsequence_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Molecularsequence, Err) {
  any_read(id, client, "MolecularSequence", r4b.molecularsequence_decoder())
}

pub fn molecularsequence_update(
  resource: r4b.Molecularsequence,
  client: FhirClient,
) -> Result(r4b.Molecularsequence, Err) {
  any_update(
    resource.id,
    r4b.molecularsequence_to_json(resource),
    "MolecularSequence",
    r4b.molecularsequence_decoder(),
    client,
  )
}

pub fn molecularsequence_delete(
  resource: r4b.Molecularsequence,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "MolecularSequence", client)
}

pub fn molecularsequence_search_bundled(
  sp: r4b_sansio.SpMolecularsequence,
  client: FhirClient,
) {
  let req = r4b_sansio.molecularsequence_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn molecularsequence_search(
  sp: r4b_sansio.SpMolecularsequence,
  client: FhirClient,
) -> Result(List(r4b.Molecularsequence), Err) {
  let req = r4b_sansio.molecularsequence_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.molecularsequence
  })
}

pub fn namingsystem_create(
  resource: r4b.Namingsystem,
  client: FhirClient,
) -> Result(r4b.Namingsystem, Err) {
  any_create(
    r4b.namingsystem_to_json(resource),
    "NamingSystem",
    r4b.namingsystem_decoder(),
    client,
  )
}

pub fn namingsystem_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Namingsystem, Err) {
  any_read(id, client, "NamingSystem", r4b.namingsystem_decoder())
}

pub fn namingsystem_update(
  resource: r4b.Namingsystem,
  client: FhirClient,
) -> Result(r4b.Namingsystem, Err) {
  any_update(
    resource.id,
    r4b.namingsystem_to_json(resource),
    "NamingSystem",
    r4b.namingsystem_decoder(),
    client,
  )
}

pub fn namingsystem_delete(
  resource: r4b.Namingsystem,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "NamingSystem", client)
}

pub fn namingsystem_search_bundled(
  sp: r4b_sansio.SpNamingsystem,
  client: FhirClient,
) {
  let req = r4b_sansio.namingsystem_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn namingsystem_search(
  sp: r4b_sansio.SpNamingsystem,
  client: FhirClient,
) -> Result(List(r4b.Namingsystem), Err) {
  let req = r4b_sansio.namingsystem_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.namingsystem
  })
}

pub fn nutritionorder_create(
  resource: r4b.Nutritionorder,
  client: FhirClient,
) -> Result(r4b.Nutritionorder, Err) {
  any_create(
    r4b.nutritionorder_to_json(resource),
    "NutritionOrder",
    r4b.nutritionorder_decoder(),
    client,
  )
}

pub fn nutritionorder_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Nutritionorder, Err) {
  any_read(id, client, "NutritionOrder", r4b.nutritionorder_decoder())
}

pub fn nutritionorder_update(
  resource: r4b.Nutritionorder,
  client: FhirClient,
) -> Result(r4b.Nutritionorder, Err) {
  any_update(
    resource.id,
    r4b.nutritionorder_to_json(resource),
    "NutritionOrder",
    r4b.nutritionorder_decoder(),
    client,
  )
}

pub fn nutritionorder_delete(
  resource: r4b.Nutritionorder,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "NutritionOrder", client)
}

pub fn nutritionorder_search_bundled(
  sp: r4b_sansio.SpNutritionorder,
  client: FhirClient,
) {
  let req = r4b_sansio.nutritionorder_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn nutritionorder_search(
  sp: r4b_sansio.SpNutritionorder,
  client: FhirClient,
) -> Result(List(r4b.Nutritionorder), Err) {
  let req = r4b_sansio.nutritionorder_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.nutritionorder
  })
}

pub fn nutritionproduct_create(
  resource: r4b.Nutritionproduct,
  client: FhirClient,
) -> Result(r4b.Nutritionproduct, Err) {
  any_create(
    r4b.nutritionproduct_to_json(resource),
    "NutritionProduct",
    r4b.nutritionproduct_decoder(),
    client,
  )
}

pub fn nutritionproduct_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Nutritionproduct, Err) {
  any_read(id, client, "NutritionProduct", r4b.nutritionproduct_decoder())
}

pub fn nutritionproduct_update(
  resource: r4b.Nutritionproduct,
  client: FhirClient,
) -> Result(r4b.Nutritionproduct, Err) {
  any_update(
    resource.id,
    r4b.nutritionproduct_to_json(resource),
    "NutritionProduct",
    r4b.nutritionproduct_decoder(),
    client,
  )
}

pub fn nutritionproduct_delete(
  resource: r4b.Nutritionproduct,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "NutritionProduct", client)
}

pub fn nutritionproduct_search_bundled(
  sp: r4b_sansio.SpNutritionproduct,
  client: FhirClient,
) {
  let req = r4b_sansio.nutritionproduct_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn nutritionproduct_search(
  sp: r4b_sansio.SpNutritionproduct,
  client: FhirClient,
) -> Result(List(r4b.Nutritionproduct), Err) {
  let req = r4b_sansio.nutritionproduct_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.nutritionproduct
  })
}

pub fn observation_create(
  resource: r4b.Observation,
  client: FhirClient,
) -> Result(r4b.Observation, Err) {
  any_create(
    r4b.observation_to_json(resource),
    "Observation",
    r4b.observation_decoder(),
    client,
  )
}

pub fn observation_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Observation, Err) {
  any_read(id, client, "Observation", r4b.observation_decoder())
}

pub fn observation_update(
  resource: r4b.Observation,
  client: FhirClient,
) -> Result(r4b.Observation, Err) {
  any_update(
    resource.id,
    r4b.observation_to_json(resource),
    "Observation",
    r4b.observation_decoder(),
    client,
  )
}

pub fn observation_delete(
  resource: r4b.Observation,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Observation", client)
}

pub fn observation_search_bundled(
  sp: r4b_sansio.SpObservation,
  client: FhirClient,
) {
  let req = r4b_sansio.observation_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn observation_search(
  sp: r4b_sansio.SpObservation,
  client: FhirClient,
) -> Result(List(r4b.Observation), Err) {
  let req = r4b_sansio.observation_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.observation
  })
}

pub fn observationdefinition_create(
  resource: r4b.Observationdefinition,
  client: FhirClient,
) -> Result(r4b.Observationdefinition, Err) {
  any_create(
    r4b.observationdefinition_to_json(resource),
    "ObservationDefinition",
    r4b.observationdefinition_decoder(),
    client,
  )
}

pub fn observationdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Observationdefinition, Err) {
  any_read(
    id,
    client,
    "ObservationDefinition",
    r4b.observationdefinition_decoder(),
  )
}

pub fn observationdefinition_update(
  resource: r4b.Observationdefinition,
  client: FhirClient,
) -> Result(r4b.Observationdefinition, Err) {
  any_update(
    resource.id,
    r4b.observationdefinition_to_json(resource),
    "ObservationDefinition",
    r4b.observationdefinition_decoder(),
    client,
  )
}

pub fn observationdefinition_delete(
  resource: r4b.Observationdefinition,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "ObservationDefinition", client)
}

pub fn observationdefinition_search_bundled(
  sp: r4b_sansio.SpObservationdefinition,
  client: FhirClient,
) {
  let req = r4b_sansio.observationdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn observationdefinition_search(
  sp: r4b_sansio.SpObservationdefinition,
  client: FhirClient,
) -> Result(List(r4b.Observationdefinition), Err) {
  let req = r4b_sansio.observationdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.observationdefinition
  })
}

pub fn operationdefinition_create(
  resource: r4b.Operationdefinition,
  client: FhirClient,
) -> Result(r4b.Operationdefinition, Err) {
  any_create(
    r4b.operationdefinition_to_json(resource),
    "OperationDefinition",
    r4b.operationdefinition_decoder(),
    client,
  )
}

pub fn operationdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Operationdefinition, Err) {
  any_read(id, client, "OperationDefinition", r4b.operationdefinition_decoder())
}

pub fn operationdefinition_update(
  resource: r4b.Operationdefinition,
  client: FhirClient,
) -> Result(r4b.Operationdefinition, Err) {
  any_update(
    resource.id,
    r4b.operationdefinition_to_json(resource),
    "OperationDefinition",
    r4b.operationdefinition_decoder(),
    client,
  )
}

pub fn operationdefinition_delete(
  resource: r4b.Operationdefinition,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "OperationDefinition", client)
}

pub fn operationdefinition_search_bundled(
  sp: r4b_sansio.SpOperationdefinition,
  client: FhirClient,
) {
  let req = r4b_sansio.operationdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn operationdefinition_search(
  sp: r4b_sansio.SpOperationdefinition,
  client: FhirClient,
) -> Result(List(r4b.Operationdefinition), Err) {
  let req = r4b_sansio.operationdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.operationdefinition
  })
}

pub fn operationoutcome_create(
  resource: r4b.Operationoutcome,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_create(
    r4b.operationoutcome_to_json(resource),
    "OperationOutcome",
    r4b.operationoutcome_decoder(),
    client,
  )
}

pub fn operationoutcome_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_read(id, client, "OperationOutcome", r4b.operationoutcome_decoder())
}

pub fn operationoutcome_update(
  resource: r4b.Operationoutcome,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_update(
    resource.id,
    r4b.operationoutcome_to_json(resource),
    "OperationOutcome",
    r4b.operationoutcome_decoder(),
    client,
  )
}

pub fn operationoutcome_delete(
  resource: r4b.Operationoutcome,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "OperationOutcome", client)
}

pub fn operationoutcome_search_bundled(
  sp: r4b_sansio.SpOperationoutcome,
  client: FhirClient,
) {
  let req = r4b_sansio.operationoutcome_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn operationoutcome_search(
  sp: r4b_sansio.SpOperationoutcome,
  client: FhirClient,
) -> Result(List(r4b.Operationoutcome), Err) {
  let req = r4b_sansio.operationoutcome_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.operationoutcome
  })
}

pub fn organization_create(
  resource: r4b.Organization,
  client: FhirClient,
) -> Result(r4b.Organization, Err) {
  any_create(
    r4b.organization_to_json(resource),
    "Organization",
    r4b.organization_decoder(),
    client,
  )
}

pub fn organization_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Organization, Err) {
  any_read(id, client, "Organization", r4b.organization_decoder())
}

pub fn organization_update(
  resource: r4b.Organization,
  client: FhirClient,
) -> Result(r4b.Organization, Err) {
  any_update(
    resource.id,
    r4b.organization_to_json(resource),
    "Organization",
    r4b.organization_decoder(),
    client,
  )
}

pub fn organization_delete(
  resource: r4b.Organization,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Organization", client)
}

pub fn organization_search_bundled(
  sp: r4b_sansio.SpOrganization,
  client: FhirClient,
) {
  let req = r4b_sansio.organization_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn organization_search(
  sp: r4b_sansio.SpOrganization,
  client: FhirClient,
) -> Result(List(r4b.Organization), Err) {
  let req = r4b_sansio.organization_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.organization
  })
}

pub fn organizationaffiliation_create(
  resource: r4b.Organizationaffiliation,
  client: FhirClient,
) -> Result(r4b.Organizationaffiliation, Err) {
  any_create(
    r4b.organizationaffiliation_to_json(resource),
    "OrganizationAffiliation",
    r4b.organizationaffiliation_decoder(),
    client,
  )
}

pub fn organizationaffiliation_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Organizationaffiliation, Err) {
  any_read(
    id,
    client,
    "OrganizationAffiliation",
    r4b.organizationaffiliation_decoder(),
  )
}

pub fn organizationaffiliation_update(
  resource: r4b.Organizationaffiliation,
  client: FhirClient,
) -> Result(r4b.Organizationaffiliation, Err) {
  any_update(
    resource.id,
    r4b.organizationaffiliation_to_json(resource),
    "OrganizationAffiliation",
    r4b.organizationaffiliation_decoder(),
    client,
  )
}

pub fn organizationaffiliation_delete(
  resource: r4b.Organizationaffiliation,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "OrganizationAffiliation", client)
}

pub fn organizationaffiliation_search_bundled(
  sp: r4b_sansio.SpOrganizationaffiliation,
  client: FhirClient,
) {
  let req = r4b_sansio.organizationaffiliation_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn organizationaffiliation_search(
  sp: r4b_sansio.SpOrganizationaffiliation,
  client: FhirClient,
) -> Result(List(r4b.Organizationaffiliation), Err) {
  let req = r4b_sansio.organizationaffiliation_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.organizationaffiliation
  })
}

pub fn packagedproductdefinition_create(
  resource: r4b.Packagedproductdefinition,
  client: FhirClient,
) -> Result(r4b.Packagedproductdefinition, Err) {
  any_create(
    r4b.packagedproductdefinition_to_json(resource),
    "PackagedProductDefinition",
    r4b.packagedproductdefinition_decoder(),
    client,
  )
}

pub fn packagedproductdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Packagedproductdefinition, Err) {
  any_read(
    id,
    client,
    "PackagedProductDefinition",
    r4b.packagedproductdefinition_decoder(),
  )
}

pub fn packagedproductdefinition_update(
  resource: r4b.Packagedproductdefinition,
  client: FhirClient,
) -> Result(r4b.Packagedproductdefinition, Err) {
  any_update(
    resource.id,
    r4b.packagedproductdefinition_to_json(resource),
    "PackagedProductDefinition",
    r4b.packagedproductdefinition_decoder(),
    client,
  )
}

pub fn packagedproductdefinition_delete(
  resource: r4b.Packagedproductdefinition,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "PackagedProductDefinition", client)
}

pub fn packagedproductdefinition_search_bundled(
  sp: r4b_sansio.SpPackagedproductdefinition,
  client: FhirClient,
) {
  let req = r4b_sansio.packagedproductdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn packagedproductdefinition_search(
  sp: r4b_sansio.SpPackagedproductdefinition,
  client: FhirClient,
) -> Result(List(r4b.Packagedproductdefinition), Err) {
  let req = r4b_sansio.packagedproductdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.packagedproductdefinition
  })
}

pub fn patient_create(
  resource: r4b.Patient,
  client: FhirClient,
) -> Result(r4b.Patient, Err) {
  any_create(
    r4b.patient_to_json(resource),
    "Patient",
    r4b.patient_decoder(),
    client,
  )
}

pub fn patient_read(id: String, client: FhirClient) -> Result(r4b.Patient, Err) {
  any_read(id, client, "Patient", r4b.patient_decoder())
}

pub fn patient_update(
  resource: r4b.Patient,
  client: FhirClient,
) -> Result(r4b.Patient, Err) {
  any_update(
    resource.id,
    r4b.patient_to_json(resource),
    "Patient",
    r4b.patient_decoder(),
    client,
  )
}

pub fn patient_delete(
  resource: r4b.Patient,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Patient", client)
}

pub fn patient_search_bundled(sp: r4b_sansio.SpPatient, client: FhirClient) {
  let req = r4b_sansio.patient_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn patient_search(
  sp: r4b_sansio.SpPatient,
  client: FhirClient,
) -> Result(List(r4b.Patient), Err) {
  let req = r4b_sansio.patient_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.patient
  })
}

pub fn paymentnotice_create(
  resource: r4b.Paymentnotice,
  client: FhirClient,
) -> Result(r4b.Paymentnotice, Err) {
  any_create(
    r4b.paymentnotice_to_json(resource),
    "PaymentNotice",
    r4b.paymentnotice_decoder(),
    client,
  )
}

pub fn paymentnotice_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Paymentnotice, Err) {
  any_read(id, client, "PaymentNotice", r4b.paymentnotice_decoder())
}

pub fn paymentnotice_update(
  resource: r4b.Paymentnotice,
  client: FhirClient,
) -> Result(r4b.Paymentnotice, Err) {
  any_update(
    resource.id,
    r4b.paymentnotice_to_json(resource),
    "PaymentNotice",
    r4b.paymentnotice_decoder(),
    client,
  )
}

pub fn paymentnotice_delete(
  resource: r4b.Paymentnotice,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "PaymentNotice", client)
}

pub fn paymentnotice_search_bundled(
  sp: r4b_sansio.SpPaymentnotice,
  client: FhirClient,
) {
  let req = r4b_sansio.paymentnotice_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn paymentnotice_search(
  sp: r4b_sansio.SpPaymentnotice,
  client: FhirClient,
) -> Result(List(r4b.Paymentnotice), Err) {
  let req = r4b_sansio.paymentnotice_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.paymentnotice
  })
}

pub fn paymentreconciliation_create(
  resource: r4b.Paymentreconciliation,
  client: FhirClient,
) -> Result(r4b.Paymentreconciliation, Err) {
  any_create(
    r4b.paymentreconciliation_to_json(resource),
    "PaymentReconciliation",
    r4b.paymentreconciliation_decoder(),
    client,
  )
}

pub fn paymentreconciliation_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Paymentreconciliation, Err) {
  any_read(
    id,
    client,
    "PaymentReconciliation",
    r4b.paymentreconciliation_decoder(),
  )
}

pub fn paymentreconciliation_update(
  resource: r4b.Paymentreconciliation,
  client: FhirClient,
) -> Result(r4b.Paymentreconciliation, Err) {
  any_update(
    resource.id,
    r4b.paymentreconciliation_to_json(resource),
    "PaymentReconciliation",
    r4b.paymentreconciliation_decoder(),
    client,
  )
}

pub fn paymentreconciliation_delete(
  resource: r4b.Paymentreconciliation,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "PaymentReconciliation", client)
}

pub fn paymentreconciliation_search_bundled(
  sp: r4b_sansio.SpPaymentreconciliation,
  client: FhirClient,
) {
  let req = r4b_sansio.paymentreconciliation_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn paymentreconciliation_search(
  sp: r4b_sansio.SpPaymentreconciliation,
  client: FhirClient,
) -> Result(List(r4b.Paymentreconciliation), Err) {
  let req = r4b_sansio.paymentreconciliation_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.paymentreconciliation
  })
}

pub fn person_create(
  resource: r4b.Person,
  client: FhirClient,
) -> Result(r4b.Person, Err) {
  any_create(
    r4b.person_to_json(resource),
    "Person",
    r4b.person_decoder(),
    client,
  )
}

pub fn person_read(id: String, client: FhirClient) -> Result(r4b.Person, Err) {
  any_read(id, client, "Person", r4b.person_decoder())
}

pub fn person_update(
  resource: r4b.Person,
  client: FhirClient,
) -> Result(r4b.Person, Err) {
  any_update(
    resource.id,
    r4b.person_to_json(resource),
    "Person",
    r4b.person_decoder(),
    client,
  )
}

pub fn person_delete(
  resource: r4b.Person,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Person", client)
}

pub fn person_search_bundled(sp: r4b_sansio.SpPerson, client: FhirClient) {
  let req = r4b_sansio.person_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn person_search(
  sp: r4b_sansio.SpPerson,
  client: FhirClient,
) -> Result(List(r4b.Person), Err) {
  let req = r4b_sansio.person_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.person
  })
}

pub fn plandefinition_create(
  resource: r4b.Plandefinition,
  client: FhirClient,
) -> Result(r4b.Plandefinition, Err) {
  any_create(
    r4b.plandefinition_to_json(resource),
    "PlanDefinition",
    r4b.plandefinition_decoder(),
    client,
  )
}

pub fn plandefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Plandefinition, Err) {
  any_read(id, client, "PlanDefinition", r4b.plandefinition_decoder())
}

pub fn plandefinition_update(
  resource: r4b.Plandefinition,
  client: FhirClient,
) -> Result(r4b.Plandefinition, Err) {
  any_update(
    resource.id,
    r4b.plandefinition_to_json(resource),
    "PlanDefinition",
    r4b.plandefinition_decoder(),
    client,
  )
}

pub fn plandefinition_delete(
  resource: r4b.Plandefinition,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "PlanDefinition", client)
}

pub fn plandefinition_search_bundled(
  sp: r4b_sansio.SpPlandefinition,
  client: FhirClient,
) {
  let req = r4b_sansio.plandefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn plandefinition_search(
  sp: r4b_sansio.SpPlandefinition,
  client: FhirClient,
) -> Result(List(r4b.Plandefinition), Err) {
  let req = r4b_sansio.plandefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.plandefinition
  })
}

pub fn practitioner_create(
  resource: r4b.Practitioner,
  client: FhirClient,
) -> Result(r4b.Practitioner, Err) {
  any_create(
    r4b.practitioner_to_json(resource),
    "Practitioner",
    r4b.practitioner_decoder(),
    client,
  )
}

pub fn practitioner_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Practitioner, Err) {
  any_read(id, client, "Practitioner", r4b.practitioner_decoder())
}

pub fn practitioner_update(
  resource: r4b.Practitioner,
  client: FhirClient,
) -> Result(r4b.Practitioner, Err) {
  any_update(
    resource.id,
    r4b.practitioner_to_json(resource),
    "Practitioner",
    r4b.practitioner_decoder(),
    client,
  )
}

pub fn practitioner_delete(
  resource: r4b.Practitioner,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Practitioner", client)
}

pub fn practitioner_search_bundled(
  sp: r4b_sansio.SpPractitioner,
  client: FhirClient,
) {
  let req = r4b_sansio.practitioner_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn practitioner_search(
  sp: r4b_sansio.SpPractitioner,
  client: FhirClient,
) -> Result(List(r4b.Practitioner), Err) {
  let req = r4b_sansio.practitioner_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.practitioner
  })
}

pub fn practitionerrole_create(
  resource: r4b.Practitionerrole,
  client: FhirClient,
) -> Result(r4b.Practitionerrole, Err) {
  any_create(
    r4b.practitionerrole_to_json(resource),
    "PractitionerRole",
    r4b.practitionerrole_decoder(),
    client,
  )
}

pub fn practitionerrole_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Practitionerrole, Err) {
  any_read(id, client, "PractitionerRole", r4b.practitionerrole_decoder())
}

pub fn practitionerrole_update(
  resource: r4b.Practitionerrole,
  client: FhirClient,
) -> Result(r4b.Practitionerrole, Err) {
  any_update(
    resource.id,
    r4b.practitionerrole_to_json(resource),
    "PractitionerRole",
    r4b.practitionerrole_decoder(),
    client,
  )
}

pub fn practitionerrole_delete(
  resource: r4b.Practitionerrole,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "PractitionerRole", client)
}

pub fn practitionerrole_search_bundled(
  sp: r4b_sansio.SpPractitionerrole,
  client: FhirClient,
) {
  let req = r4b_sansio.practitionerrole_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn practitionerrole_search(
  sp: r4b_sansio.SpPractitionerrole,
  client: FhirClient,
) -> Result(List(r4b.Practitionerrole), Err) {
  let req = r4b_sansio.practitionerrole_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.practitionerrole
  })
}

pub fn procedure_create(
  resource: r4b.Procedure,
  client: FhirClient,
) -> Result(r4b.Procedure, Err) {
  any_create(
    r4b.procedure_to_json(resource),
    "Procedure",
    r4b.procedure_decoder(),
    client,
  )
}

pub fn procedure_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Procedure, Err) {
  any_read(id, client, "Procedure", r4b.procedure_decoder())
}

pub fn procedure_update(
  resource: r4b.Procedure,
  client: FhirClient,
) -> Result(r4b.Procedure, Err) {
  any_update(
    resource.id,
    r4b.procedure_to_json(resource),
    "Procedure",
    r4b.procedure_decoder(),
    client,
  )
}

pub fn procedure_delete(
  resource: r4b.Procedure,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Procedure", client)
}

pub fn procedure_search_bundled(sp: r4b_sansio.SpProcedure, client: FhirClient) {
  let req = r4b_sansio.procedure_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn procedure_search(
  sp: r4b_sansio.SpProcedure,
  client: FhirClient,
) -> Result(List(r4b.Procedure), Err) {
  let req = r4b_sansio.procedure_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.procedure
  })
}

pub fn provenance_create(
  resource: r4b.Provenance,
  client: FhirClient,
) -> Result(r4b.Provenance, Err) {
  any_create(
    r4b.provenance_to_json(resource),
    "Provenance",
    r4b.provenance_decoder(),
    client,
  )
}

pub fn provenance_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Provenance, Err) {
  any_read(id, client, "Provenance", r4b.provenance_decoder())
}

pub fn provenance_update(
  resource: r4b.Provenance,
  client: FhirClient,
) -> Result(r4b.Provenance, Err) {
  any_update(
    resource.id,
    r4b.provenance_to_json(resource),
    "Provenance",
    r4b.provenance_decoder(),
    client,
  )
}

pub fn provenance_delete(
  resource: r4b.Provenance,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Provenance", client)
}

pub fn provenance_search_bundled(
  sp: r4b_sansio.SpProvenance,
  client: FhirClient,
) {
  let req = r4b_sansio.provenance_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn provenance_search(
  sp: r4b_sansio.SpProvenance,
  client: FhirClient,
) -> Result(List(r4b.Provenance), Err) {
  let req = r4b_sansio.provenance_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.provenance
  })
}

pub fn questionnaire_create(
  resource: r4b.Questionnaire,
  client: FhirClient,
) -> Result(r4b.Questionnaire, Err) {
  any_create(
    r4b.questionnaire_to_json(resource),
    "Questionnaire",
    r4b.questionnaire_decoder(),
    client,
  )
}

pub fn questionnaire_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Questionnaire, Err) {
  any_read(id, client, "Questionnaire", r4b.questionnaire_decoder())
}

pub fn questionnaire_update(
  resource: r4b.Questionnaire,
  client: FhirClient,
) -> Result(r4b.Questionnaire, Err) {
  any_update(
    resource.id,
    r4b.questionnaire_to_json(resource),
    "Questionnaire",
    r4b.questionnaire_decoder(),
    client,
  )
}

pub fn questionnaire_delete(
  resource: r4b.Questionnaire,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Questionnaire", client)
}

pub fn questionnaire_search_bundled(
  sp: r4b_sansio.SpQuestionnaire,
  client: FhirClient,
) {
  let req = r4b_sansio.questionnaire_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn questionnaire_search(
  sp: r4b_sansio.SpQuestionnaire,
  client: FhirClient,
) -> Result(List(r4b.Questionnaire), Err) {
  let req = r4b_sansio.questionnaire_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.questionnaire
  })
}

pub fn questionnaireresponse_create(
  resource: r4b.Questionnaireresponse,
  client: FhirClient,
) -> Result(r4b.Questionnaireresponse, Err) {
  any_create(
    r4b.questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    r4b.questionnaireresponse_decoder(),
    client,
  )
}

pub fn questionnaireresponse_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Questionnaireresponse, Err) {
  any_read(
    id,
    client,
    "QuestionnaireResponse",
    r4b.questionnaireresponse_decoder(),
  )
}

pub fn questionnaireresponse_update(
  resource: r4b.Questionnaireresponse,
  client: FhirClient,
) -> Result(r4b.Questionnaireresponse, Err) {
  any_update(
    resource.id,
    r4b.questionnaireresponse_to_json(resource),
    "QuestionnaireResponse",
    r4b.questionnaireresponse_decoder(),
    client,
  )
}

pub fn questionnaireresponse_delete(
  resource: r4b.Questionnaireresponse,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "QuestionnaireResponse", client)
}

pub fn questionnaireresponse_search_bundled(
  sp: r4b_sansio.SpQuestionnaireresponse,
  client: FhirClient,
) {
  let req = r4b_sansio.questionnaireresponse_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn questionnaireresponse_search(
  sp: r4b_sansio.SpQuestionnaireresponse,
  client: FhirClient,
) -> Result(List(r4b.Questionnaireresponse), Err) {
  let req = r4b_sansio.questionnaireresponse_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.questionnaireresponse
  })
}

pub fn regulatedauthorization_create(
  resource: r4b.Regulatedauthorization,
  client: FhirClient,
) -> Result(r4b.Regulatedauthorization, Err) {
  any_create(
    r4b.regulatedauthorization_to_json(resource),
    "RegulatedAuthorization",
    r4b.regulatedauthorization_decoder(),
    client,
  )
}

pub fn regulatedauthorization_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Regulatedauthorization, Err) {
  any_read(
    id,
    client,
    "RegulatedAuthorization",
    r4b.regulatedauthorization_decoder(),
  )
}

pub fn regulatedauthorization_update(
  resource: r4b.Regulatedauthorization,
  client: FhirClient,
) -> Result(r4b.Regulatedauthorization, Err) {
  any_update(
    resource.id,
    r4b.regulatedauthorization_to_json(resource),
    "RegulatedAuthorization",
    r4b.regulatedauthorization_decoder(),
    client,
  )
}

pub fn regulatedauthorization_delete(
  resource: r4b.Regulatedauthorization,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "RegulatedAuthorization", client)
}

pub fn regulatedauthorization_search_bundled(
  sp: r4b_sansio.SpRegulatedauthorization,
  client: FhirClient,
) {
  let req = r4b_sansio.regulatedauthorization_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn regulatedauthorization_search(
  sp: r4b_sansio.SpRegulatedauthorization,
  client: FhirClient,
) -> Result(List(r4b.Regulatedauthorization), Err) {
  let req = r4b_sansio.regulatedauthorization_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.regulatedauthorization
  })
}

pub fn relatedperson_create(
  resource: r4b.Relatedperson,
  client: FhirClient,
) -> Result(r4b.Relatedperson, Err) {
  any_create(
    r4b.relatedperson_to_json(resource),
    "RelatedPerson",
    r4b.relatedperson_decoder(),
    client,
  )
}

pub fn relatedperson_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Relatedperson, Err) {
  any_read(id, client, "RelatedPerson", r4b.relatedperson_decoder())
}

pub fn relatedperson_update(
  resource: r4b.Relatedperson,
  client: FhirClient,
) -> Result(r4b.Relatedperson, Err) {
  any_update(
    resource.id,
    r4b.relatedperson_to_json(resource),
    "RelatedPerson",
    r4b.relatedperson_decoder(),
    client,
  )
}

pub fn relatedperson_delete(
  resource: r4b.Relatedperson,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "RelatedPerson", client)
}

pub fn relatedperson_search_bundled(
  sp: r4b_sansio.SpRelatedperson,
  client: FhirClient,
) {
  let req = r4b_sansio.relatedperson_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn relatedperson_search(
  sp: r4b_sansio.SpRelatedperson,
  client: FhirClient,
) -> Result(List(r4b.Relatedperson), Err) {
  let req = r4b_sansio.relatedperson_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.relatedperson
  })
}

pub fn requestgroup_create(
  resource: r4b.Requestgroup,
  client: FhirClient,
) -> Result(r4b.Requestgroup, Err) {
  any_create(
    r4b.requestgroup_to_json(resource),
    "RequestGroup",
    r4b.requestgroup_decoder(),
    client,
  )
}

pub fn requestgroup_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Requestgroup, Err) {
  any_read(id, client, "RequestGroup", r4b.requestgroup_decoder())
}

pub fn requestgroup_update(
  resource: r4b.Requestgroup,
  client: FhirClient,
) -> Result(r4b.Requestgroup, Err) {
  any_update(
    resource.id,
    r4b.requestgroup_to_json(resource),
    "RequestGroup",
    r4b.requestgroup_decoder(),
    client,
  )
}

pub fn requestgroup_delete(
  resource: r4b.Requestgroup,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "RequestGroup", client)
}

pub fn requestgroup_search_bundled(
  sp: r4b_sansio.SpRequestgroup,
  client: FhirClient,
) {
  let req = r4b_sansio.requestgroup_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn requestgroup_search(
  sp: r4b_sansio.SpRequestgroup,
  client: FhirClient,
) -> Result(List(r4b.Requestgroup), Err) {
  let req = r4b_sansio.requestgroup_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.requestgroup
  })
}

pub fn researchdefinition_create(
  resource: r4b.Researchdefinition,
  client: FhirClient,
) -> Result(r4b.Researchdefinition, Err) {
  any_create(
    r4b.researchdefinition_to_json(resource),
    "ResearchDefinition",
    r4b.researchdefinition_decoder(),
    client,
  )
}

pub fn researchdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Researchdefinition, Err) {
  any_read(id, client, "ResearchDefinition", r4b.researchdefinition_decoder())
}

pub fn researchdefinition_update(
  resource: r4b.Researchdefinition,
  client: FhirClient,
) -> Result(r4b.Researchdefinition, Err) {
  any_update(
    resource.id,
    r4b.researchdefinition_to_json(resource),
    "ResearchDefinition",
    r4b.researchdefinition_decoder(),
    client,
  )
}

pub fn researchdefinition_delete(
  resource: r4b.Researchdefinition,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "ResearchDefinition", client)
}

pub fn researchdefinition_search_bundled(
  sp: r4b_sansio.SpResearchdefinition,
  client: FhirClient,
) {
  let req = r4b_sansio.researchdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn researchdefinition_search(
  sp: r4b_sansio.SpResearchdefinition,
  client: FhirClient,
) -> Result(List(r4b.Researchdefinition), Err) {
  let req = r4b_sansio.researchdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.researchdefinition
  })
}

pub fn researchelementdefinition_create(
  resource: r4b.Researchelementdefinition,
  client: FhirClient,
) -> Result(r4b.Researchelementdefinition, Err) {
  any_create(
    r4b.researchelementdefinition_to_json(resource),
    "ResearchElementDefinition",
    r4b.researchelementdefinition_decoder(),
    client,
  )
}

pub fn researchelementdefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Researchelementdefinition, Err) {
  any_read(
    id,
    client,
    "ResearchElementDefinition",
    r4b.researchelementdefinition_decoder(),
  )
}

pub fn researchelementdefinition_update(
  resource: r4b.Researchelementdefinition,
  client: FhirClient,
) -> Result(r4b.Researchelementdefinition, Err) {
  any_update(
    resource.id,
    r4b.researchelementdefinition_to_json(resource),
    "ResearchElementDefinition",
    r4b.researchelementdefinition_decoder(),
    client,
  )
}

pub fn researchelementdefinition_delete(
  resource: r4b.Researchelementdefinition,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "ResearchElementDefinition", client)
}

pub fn researchelementdefinition_search_bundled(
  sp: r4b_sansio.SpResearchelementdefinition,
  client: FhirClient,
) {
  let req = r4b_sansio.researchelementdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn researchelementdefinition_search(
  sp: r4b_sansio.SpResearchelementdefinition,
  client: FhirClient,
) -> Result(List(r4b.Researchelementdefinition), Err) {
  let req = r4b_sansio.researchelementdefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.researchelementdefinition
  })
}

pub fn researchstudy_create(
  resource: r4b.Researchstudy,
  client: FhirClient,
) -> Result(r4b.Researchstudy, Err) {
  any_create(
    r4b.researchstudy_to_json(resource),
    "ResearchStudy",
    r4b.researchstudy_decoder(),
    client,
  )
}

pub fn researchstudy_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Researchstudy, Err) {
  any_read(id, client, "ResearchStudy", r4b.researchstudy_decoder())
}

pub fn researchstudy_update(
  resource: r4b.Researchstudy,
  client: FhirClient,
) -> Result(r4b.Researchstudy, Err) {
  any_update(
    resource.id,
    r4b.researchstudy_to_json(resource),
    "ResearchStudy",
    r4b.researchstudy_decoder(),
    client,
  )
}

pub fn researchstudy_delete(
  resource: r4b.Researchstudy,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "ResearchStudy", client)
}

pub fn researchstudy_search_bundled(
  sp: r4b_sansio.SpResearchstudy,
  client: FhirClient,
) {
  let req = r4b_sansio.researchstudy_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn researchstudy_search(
  sp: r4b_sansio.SpResearchstudy,
  client: FhirClient,
) -> Result(List(r4b.Researchstudy), Err) {
  let req = r4b_sansio.researchstudy_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.researchstudy
  })
}

pub fn researchsubject_create(
  resource: r4b.Researchsubject,
  client: FhirClient,
) -> Result(r4b.Researchsubject, Err) {
  any_create(
    r4b.researchsubject_to_json(resource),
    "ResearchSubject",
    r4b.researchsubject_decoder(),
    client,
  )
}

pub fn researchsubject_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Researchsubject, Err) {
  any_read(id, client, "ResearchSubject", r4b.researchsubject_decoder())
}

pub fn researchsubject_update(
  resource: r4b.Researchsubject,
  client: FhirClient,
) -> Result(r4b.Researchsubject, Err) {
  any_update(
    resource.id,
    r4b.researchsubject_to_json(resource),
    "ResearchSubject",
    r4b.researchsubject_decoder(),
    client,
  )
}

pub fn researchsubject_delete(
  resource: r4b.Researchsubject,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "ResearchSubject", client)
}

pub fn researchsubject_search_bundled(
  sp: r4b_sansio.SpResearchsubject,
  client: FhirClient,
) {
  let req = r4b_sansio.researchsubject_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn researchsubject_search(
  sp: r4b_sansio.SpResearchsubject,
  client: FhirClient,
) -> Result(List(r4b.Researchsubject), Err) {
  let req = r4b_sansio.researchsubject_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.researchsubject
  })
}

pub fn riskassessment_create(
  resource: r4b.Riskassessment,
  client: FhirClient,
) -> Result(r4b.Riskassessment, Err) {
  any_create(
    r4b.riskassessment_to_json(resource),
    "RiskAssessment",
    r4b.riskassessment_decoder(),
    client,
  )
}

pub fn riskassessment_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Riskassessment, Err) {
  any_read(id, client, "RiskAssessment", r4b.riskassessment_decoder())
}

pub fn riskassessment_update(
  resource: r4b.Riskassessment,
  client: FhirClient,
) -> Result(r4b.Riskassessment, Err) {
  any_update(
    resource.id,
    r4b.riskassessment_to_json(resource),
    "RiskAssessment",
    r4b.riskassessment_decoder(),
    client,
  )
}

pub fn riskassessment_delete(
  resource: r4b.Riskassessment,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "RiskAssessment", client)
}

pub fn riskassessment_search_bundled(
  sp: r4b_sansio.SpRiskassessment,
  client: FhirClient,
) {
  let req = r4b_sansio.riskassessment_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn riskassessment_search(
  sp: r4b_sansio.SpRiskassessment,
  client: FhirClient,
) -> Result(List(r4b.Riskassessment), Err) {
  let req = r4b_sansio.riskassessment_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.riskassessment
  })
}

pub fn schedule_create(
  resource: r4b.Schedule,
  client: FhirClient,
) -> Result(r4b.Schedule, Err) {
  any_create(
    r4b.schedule_to_json(resource),
    "Schedule",
    r4b.schedule_decoder(),
    client,
  )
}

pub fn schedule_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Schedule, Err) {
  any_read(id, client, "Schedule", r4b.schedule_decoder())
}

pub fn schedule_update(
  resource: r4b.Schedule,
  client: FhirClient,
) -> Result(r4b.Schedule, Err) {
  any_update(
    resource.id,
    r4b.schedule_to_json(resource),
    "Schedule",
    r4b.schedule_decoder(),
    client,
  )
}

pub fn schedule_delete(
  resource: r4b.Schedule,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Schedule", client)
}

pub fn schedule_search_bundled(sp: r4b_sansio.SpSchedule, client: FhirClient) {
  let req = r4b_sansio.schedule_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn schedule_search(
  sp: r4b_sansio.SpSchedule,
  client: FhirClient,
) -> Result(List(r4b.Schedule), Err) {
  let req = r4b_sansio.schedule_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.schedule
  })
}

pub fn searchparameter_create(
  resource: r4b.Searchparameter,
  client: FhirClient,
) -> Result(r4b.Searchparameter, Err) {
  any_create(
    r4b.searchparameter_to_json(resource),
    "SearchParameter",
    r4b.searchparameter_decoder(),
    client,
  )
}

pub fn searchparameter_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Searchparameter, Err) {
  any_read(id, client, "SearchParameter", r4b.searchparameter_decoder())
}

pub fn searchparameter_update(
  resource: r4b.Searchparameter,
  client: FhirClient,
) -> Result(r4b.Searchparameter, Err) {
  any_update(
    resource.id,
    r4b.searchparameter_to_json(resource),
    "SearchParameter",
    r4b.searchparameter_decoder(),
    client,
  )
}

pub fn searchparameter_delete(
  resource: r4b.Searchparameter,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "SearchParameter", client)
}

pub fn searchparameter_search_bundled(
  sp: r4b_sansio.SpSearchparameter,
  client: FhirClient,
) {
  let req = r4b_sansio.searchparameter_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn searchparameter_search(
  sp: r4b_sansio.SpSearchparameter,
  client: FhirClient,
) -> Result(List(r4b.Searchparameter), Err) {
  let req = r4b_sansio.searchparameter_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.searchparameter
  })
}

pub fn servicerequest_create(
  resource: r4b.Servicerequest,
  client: FhirClient,
) -> Result(r4b.Servicerequest, Err) {
  any_create(
    r4b.servicerequest_to_json(resource),
    "ServiceRequest",
    r4b.servicerequest_decoder(),
    client,
  )
}

pub fn servicerequest_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Servicerequest, Err) {
  any_read(id, client, "ServiceRequest", r4b.servicerequest_decoder())
}

pub fn servicerequest_update(
  resource: r4b.Servicerequest,
  client: FhirClient,
) -> Result(r4b.Servicerequest, Err) {
  any_update(
    resource.id,
    r4b.servicerequest_to_json(resource),
    "ServiceRequest",
    r4b.servicerequest_decoder(),
    client,
  )
}

pub fn servicerequest_delete(
  resource: r4b.Servicerequest,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "ServiceRequest", client)
}

pub fn servicerequest_search_bundled(
  sp: r4b_sansio.SpServicerequest,
  client: FhirClient,
) {
  let req = r4b_sansio.servicerequest_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn servicerequest_search(
  sp: r4b_sansio.SpServicerequest,
  client: FhirClient,
) -> Result(List(r4b.Servicerequest), Err) {
  let req = r4b_sansio.servicerequest_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.servicerequest
  })
}

pub fn slot_create(
  resource: r4b.Slot,
  client: FhirClient,
) -> Result(r4b.Slot, Err) {
  any_create(r4b.slot_to_json(resource), "Slot", r4b.slot_decoder(), client)
}

pub fn slot_read(id: String, client: FhirClient) -> Result(r4b.Slot, Err) {
  any_read(id, client, "Slot", r4b.slot_decoder())
}

pub fn slot_update(
  resource: r4b.Slot,
  client: FhirClient,
) -> Result(r4b.Slot, Err) {
  any_update(
    resource.id,
    r4b.slot_to_json(resource),
    "Slot",
    r4b.slot_decoder(),
    client,
  )
}

pub fn slot_delete(
  resource: r4b.Slot,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Slot", client)
}

pub fn slot_search_bundled(sp: r4b_sansio.SpSlot, client: FhirClient) {
  let req = r4b_sansio.slot_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn slot_search(
  sp: r4b_sansio.SpSlot,
  client: FhirClient,
) -> Result(List(r4b.Slot), Err) {
  let req = r4b_sansio.slot_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.slot
  })
}

pub fn specimen_create(
  resource: r4b.Specimen,
  client: FhirClient,
) -> Result(r4b.Specimen, Err) {
  any_create(
    r4b.specimen_to_json(resource),
    "Specimen",
    r4b.specimen_decoder(),
    client,
  )
}

pub fn specimen_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Specimen, Err) {
  any_read(id, client, "Specimen", r4b.specimen_decoder())
}

pub fn specimen_update(
  resource: r4b.Specimen,
  client: FhirClient,
) -> Result(r4b.Specimen, Err) {
  any_update(
    resource.id,
    r4b.specimen_to_json(resource),
    "Specimen",
    r4b.specimen_decoder(),
    client,
  )
}

pub fn specimen_delete(
  resource: r4b.Specimen,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Specimen", client)
}

pub fn specimen_search_bundled(sp: r4b_sansio.SpSpecimen, client: FhirClient) {
  let req = r4b_sansio.specimen_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn specimen_search(
  sp: r4b_sansio.SpSpecimen,
  client: FhirClient,
) -> Result(List(r4b.Specimen), Err) {
  let req = r4b_sansio.specimen_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.specimen
  })
}

pub fn specimendefinition_create(
  resource: r4b.Specimendefinition,
  client: FhirClient,
) -> Result(r4b.Specimendefinition, Err) {
  any_create(
    r4b.specimendefinition_to_json(resource),
    "SpecimenDefinition",
    r4b.specimendefinition_decoder(),
    client,
  )
}

pub fn specimendefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Specimendefinition, Err) {
  any_read(id, client, "SpecimenDefinition", r4b.specimendefinition_decoder())
}

pub fn specimendefinition_update(
  resource: r4b.Specimendefinition,
  client: FhirClient,
) -> Result(r4b.Specimendefinition, Err) {
  any_update(
    resource.id,
    r4b.specimendefinition_to_json(resource),
    "SpecimenDefinition",
    r4b.specimendefinition_decoder(),
    client,
  )
}

pub fn specimendefinition_delete(
  resource: r4b.Specimendefinition,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "SpecimenDefinition", client)
}

pub fn specimendefinition_search_bundled(
  sp: r4b_sansio.SpSpecimendefinition,
  client: FhirClient,
) {
  let req = r4b_sansio.specimendefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn specimendefinition_search(
  sp: r4b_sansio.SpSpecimendefinition,
  client: FhirClient,
) -> Result(List(r4b.Specimendefinition), Err) {
  let req = r4b_sansio.specimendefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.specimendefinition
  })
}

pub fn structuredefinition_create(
  resource: r4b.Structuredefinition,
  client: FhirClient,
) -> Result(r4b.Structuredefinition, Err) {
  any_create(
    r4b.structuredefinition_to_json(resource),
    "StructureDefinition",
    r4b.structuredefinition_decoder(),
    client,
  )
}

pub fn structuredefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Structuredefinition, Err) {
  any_read(id, client, "StructureDefinition", r4b.structuredefinition_decoder())
}

pub fn structuredefinition_update(
  resource: r4b.Structuredefinition,
  client: FhirClient,
) -> Result(r4b.Structuredefinition, Err) {
  any_update(
    resource.id,
    r4b.structuredefinition_to_json(resource),
    "StructureDefinition",
    r4b.structuredefinition_decoder(),
    client,
  )
}

pub fn structuredefinition_delete(
  resource: r4b.Structuredefinition,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "StructureDefinition", client)
}

pub fn structuredefinition_search_bundled(
  sp: r4b_sansio.SpStructuredefinition,
  client: FhirClient,
) {
  let req = r4b_sansio.structuredefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn structuredefinition_search(
  sp: r4b_sansio.SpStructuredefinition,
  client: FhirClient,
) -> Result(List(r4b.Structuredefinition), Err) {
  let req = r4b_sansio.structuredefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.structuredefinition
  })
}

pub fn structuremap_create(
  resource: r4b.Structuremap,
  client: FhirClient,
) -> Result(r4b.Structuremap, Err) {
  any_create(
    r4b.structuremap_to_json(resource),
    "StructureMap",
    r4b.structuremap_decoder(),
    client,
  )
}

pub fn structuremap_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Structuremap, Err) {
  any_read(id, client, "StructureMap", r4b.structuremap_decoder())
}

pub fn structuremap_update(
  resource: r4b.Structuremap,
  client: FhirClient,
) -> Result(r4b.Structuremap, Err) {
  any_update(
    resource.id,
    r4b.structuremap_to_json(resource),
    "StructureMap",
    r4b.structuremap_decoder(),
    client,
  )
}

pub fn structuremap_delete(
  resource: r4b.Structuremap,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "StructureMap", client)
}

pub fn structuremap_search_bundled(
  sp: r4b_sansio.SpStructuremap,
  client: FhirClient,
) {
  let req = r4b_sansio.structuremap_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn structuremap_search(
  sp: r4b_sansio.SpStructuremap,
  client: FhirClient,
) -> Result(List(r4b.Structuremap), Err) {
  let req = r4b_sansio.structuremap_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.structuremap
  })
}

pub fn subscription_create(
  resource: r4b.Subscription,
  client: FhirClient,
) -> Result(r4b.Subscription, Err) {
  any_create(
    r4b.subscription_to_json(resource),
    "Subscription",
    r4b.subscription_decoder(),
    client,
  )
}

pub fn subscription_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Subscription, Err) {
  any_read(id, client, "Subscription", r4b.subscription_decoder())
}

pub fn subscription_update(
  resource: r4b.Subscription,
  client: FhirClient,
) -> Result(r4b.Subscription, Err) {
  any_update(
    resource.id,
    r4b.subscription_to_json(resource),
    "Subscription",
    r4b.subscription_decoder(),
    client,
  )
}

pub fn subscription_delete(
  resource: r4b.Subscription,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Subscription", client)
}

pub fn subscription_search_bundled(
  sp: r4b_sansio.SpSubscription,
  client: FhirClient,
) {
  let req = r4b_sansio.subscription_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn subscription_search(
  sp: r4b_sansio.SpSubscription,
  client: FhirClient,
) -> Result(List(r4b.Subscription), Err) {
  let req = r4b_sansio.subscription_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.subscription
  })
}

pub fn subscriptionstatus_create(
  resource: r4b.Subscriptionstatus,
  client: FhirClient,
) -> Result(r4b.Subscriptionstatus, Err) {
  any_create(
    r4b.subscriptionstatus_to_json(resource),
    "SubscriptionStatus",
    r4b.subscriptionstatus_decoder(),
    client,
  )
}

pub fn subscriptionstatus_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Subscriptionstatus, Err) {
  any_read(id, client, "SubscriptionStatus", r4b.subscriptionstatus_decoder())
}

pub fn subscriptionstatus_update(
  resource: r4b.Subscriptionstatus,
  client: FhirClient,
) -> Result(r4b.Subscriptionstatus, Err) {
  any_update(
    resource.id,
    r4b.subscriptionstatus_to_json(resource),
    "SubscriptionStatus",
    r4b.subscriptionstatus_decoder(),
    client,
  )
}

pub fn subscriptionstatus_delete(
  resource: r4b.Subscriptionstatus,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "SubscriptionStatus", client)
}

pub fn subscriptionstatus_search_bundled(
  sp: r4b_sansio.SpSubscriptionstatus,
  client: FhirClient,
) {
  let req = r4b_sansio.subscriptionstatus_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn subscriptionstatus_search(
  sp: r4b_sansio.SpSubscriptionstatus,
  client: FhirClient,
) -> Result(List(r4b.Subscriptionstatus), Err) {
  let req = r4b_sansio.subscriptionstatus_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.subscriptionstatus
  })
}

pub fn subscriptiontopic_create(
  resource: r4b.Subscriptiontopic,
  client: FhirClient,
) -> Result(r4b.Subscriptiontopic, Err) {
  any_create(
    r4b.subscriptiontopic_to_json(resource),
    "SubscriptionTopic",
    r4b.subscriptiontopic_decoder(),
    client,
  )
}

pub fn subscriptiontopic_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Subscriptiontopic, Err) {
  any_read(id, client, "SubscriptionTopic", r4b.subscriptiontopic_decoder())
}

pub fn subscriptiontopic_update(
  resource: r4b.Subscriptiontopic,
  client: FhirClient,
) -> Result(r4b.Subscriptiontopic, Err) {
  any_update(
    resource.id,
    r4b.subscriptiontopic_to_json(resource),
    "SubscriptionTopic",
    r4b.subscriptiontopic_decoder(),
    client,
  )
}

pub fn subscriptiontopic_delete(
  resource: r4b.Subscriptiontopic,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "SubscriptionTopic", client)
}

pub fn subscriptiontopic_search_bundled(
  sp: r4b_sansio.SpSubscriptiontopic,
  client: FhirClient,
) {
  let req = r4b_sansio.subscriptiontopic_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn subscriptiontopic_search(
  sp: r4b_sansio.SpSubscriptiontopic,
  client: FhirClient,
) -> Result(List(r4b.Subscriptiontopic), Err) {
  let req = r4b_sansio.subscriptiontopic_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.subscriptiontopic
  })
}

pub fn substance_create(
  resource: r4b.Substance,
  client: FhirClient,
) -> Result(r4b.Substance, Err) {
  any_create(
    r4b.substance_to_json(resource),
    "Substance",
    r4b.substance_decoder(),
    client,
  )
}

pub fn substance_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Substance, Err) {
  any_read(id, client, "Substance", r4b.substance_decoder())
}

pub fn substance_update(
  resource: r4b.Substance,
  client: FhirClient,
) -> Result(r4b.Substance, Err) {
  any_update(
    resource.id,
    r4b.substance_to_json(resource),
    "Substance",
    r4b.substance_decoder(),
    client,
  )
}

pub fn substance_delete(
  resource: r4b.Substance,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Substance", client)
}

pub fn substance_search_bundled(sp: r4b_sansio.SpSubstance, client: FhirClient) {
  let req = r4b_sansio.substance_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn substance_search(
  sp: r4b_sansio.SpSubstance,
  client: FhirClient,
) -> Result(List(r4b.Substance), Err) {
  let req = r4b_sansio.substance_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.substance
  })
}

pub fn substancedefinition_create(
  resource: r4b.Substancedefinition,
  client: FhirClient,
) -> Result(r4b.Substancedefinition, Err) {
  any_create(
    r4b.substancedefinition_to_json(resource),
    "SubstanceDefinition",
    r4b.substancedefinition_decoder(),
    client,
  )
}

pub fn substancedefinition_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Substancedefinition, Err) {
  any_read(id, client, "SubstanceDefinition", r4b.substancedefinition_decoder())
}

pub fn substancedefinition_update(
  resource: r4b.Substancedefinition,
  client: FhirClient,
) -> Result(r4b.Substancedefinition, Err) {
  any_update(
    resource.id,
    r4b.substancedefinition_to_json(resource),
    "SubstanceDefinition",
    r4b.substancedefinition_decoder(),
    client,
  )
}

pub fn substancedefinition_delete(
  resource: r4b.Substancedefinition,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "SubstanceDefinition", client)
}

pub fn substancedefinition_search_bundled(
  sp: r4b_sansio.SpSubstancedefinition,
  client: FhirClient,
) {
  let req = r4b_sansio.substancedefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn substancedefinition_search(
  sp: r4b_sansio.SpSubstancedefinition,
  client: FhirClient,
) -> Result(List(r4b.Substancedefinition), Err) {
  let req = r4b_sansio.substancedefinition_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.substancedefinition
  })
}

pub fn supplydelivery_create(
  resource: r4b.Supplydelivery,
  client: FhirClient,
) -> Result(r4b.Supplydelivery, Err) {
  any_create(
    r4b.supplydelivery_to_json(resource),
    "SupplyDelivery",
    r4b.supplydelivery_decoder(),
    client,
  )
}

pub fn supplydelivery_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Supplydelivery, Err) {
  any_read(id, client, "SupplyDelivery", r4b.supplydelivery_decoder())
}

pub fn supplydelivery_update(
  resource: r4b.Supplydelivery,
  client: FhirClient,
) -> Result(r4b.Supplydelivery, Err) {
  any_update(
    resource.id,
    r4b.supplydelivery_to_json(resource),
    "SupplyDelivery",
    r4b.supplydelivery_decoder(),
    client,
  )
}

pub fn supplydelivery_delete(
  resource: r4b.Supplydelivery,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "SupplyDelivery", client)
}

pub fn supplydelivery_search_bundled(
  sp: r4b_sansio.SpSupplydelivery,
  client: FhirClient,
) {
  let req = r4b_sansio.supplydelivery_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn supplydelivery_search(
  sp: r4b_sansio.SpSupplydelivery,
  client: FhirClient,
) -> Result(List(r4b.Supplydelivery), Err) {
  let req = r4b_sansio.supplydelivery_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.supplydelivery
  })
}

pub fn supplyrequest_create(
  resource: r4b.Supplyrequest,
  client: FhirClient,
) -> Result(r4b.Supplyrequest, Err) {
  any_create(
    r4b.supplyrequest_to_json(resource),
    "SupplyRequest",
    r4b.supplyrequest_decoder(),
    client,
  )
}

pub fn supplyrequest_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Supplyrequest, Err) {
  any_read(id, client, "SupplyRequest", r4b.supplyrequest_decoder())
}

pub fn supplyrequest_update(
  resource: r4b.Supplyrequest,
  client: FhirClient,
) -> Result(r4b.Supplyrequest, Err) {
  any_update(
    resource.id,
    r4b.supplyrequest_to_json(resource),
    "SupplyRequest",
    r4b.supplyrequest_decoder(),
    client,
  )
}

pub fn supplyrequest_delete(
  resource: r4b.Supplyrequest,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "SupplyRequest", client)
}

pub fn supplyrequest_search_bundled(
  sp: r4b_sansio.SpSupplyrequest,
  client: FhirClient,
) {
  let req = r4b_sansio.supplyrequest_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn supplyrequest_search(
  sp: r4b_sansio.SpSupplyrequest,
  client: FhirClient,
) -> Result(List(r4b.Supplyrequest), Err) {
  let req = r4b_sansio.supplyrequest_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.supplyrequest
  })
}

pub fn task_create(
  resource: r4b.Task,
  client: FhirClient,
) -> Result(r4b.Task, Err) {
  any_create(r4b.task_to_json(resource), "Task", r4b.task_decoder(), client)
}

pub fn task_read(id: String, client: FhirClient) -> Result(r4b.Task, Err) {
  any_read(id, client, "Task", r4b.task_decoder())
}

pub fn task_update(
  resource: r4b.Task,
  client: FhirClient,
) -> Result(r4b.Task, Err) {
  any_update(
    resource.id,
    r4b.task_to_json(resource),
    "Task",
    r4b.task_decoder(),
    client,
  )
}

pub fn task_delete(
  resource: r4b.Task,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "Task", client)
}

pub fn task_search_bundled(sp: r4b_sansio.SpTask, client: FhirClient) {
  let req = r4b_sansio.task_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn task_search(
  sp: r4b_sansio.SpTask,
  client: FhirClient,
) -> Result(List(r4b.Task), Err) {
  let req = r4b_sansio.task_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.task
  })
}

pub fn terminologycapabilities_create(
  resource: r4b.Terminologycapabilities,
  client: FhirClient,
) -> Result(r4b.Terminologycapabilities, Err) {
  any_create(
    r4b.terminologycapabilities_to_json(resource),
    "TerminologyCapabilities",
    r4b.terminologycapabilities_decoder(),
    client,
  )
}

pub fn terminologycapabilities_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Terminologycapabilities, Err) {
  any_read(
    id,
    client,
    "TerminologyCapabilities",
    r4b.terminologycapabilities_decoder(),
  )
}

pub fn terminologycapabilities_update(
  resource: r4b.Terminologycapabilities,
  client: FhirClient,
) -> Result(r4b.Terminologycapabilities, Err) {
  any_update(
    resource.id,
    r4b.terminologycapabilities_to_json(resource),
    "TerminologyCapabilities",
    r4b.terminologycapabilities_decoder(),
    client,
  )
}

pub fn terminologycapabilities_delete(
  resource: r4b.Terminologycapabilities,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "TerminologyCapabilities", client)
}

pub fn terminologycapabilities_search_bundled(
  sp: r4b_sansio.SpTerminologycapabilities,
  client: FhirClient,
) {
  let req = r4b_sansio.terminologycapabilities_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn terminologycapabilities_search(
  sp: r4b_sansio.SpTerminologycapabilities,
  client: FhirClient,
) -> Result(List(r4b.Terminologycapabilities), Err) {
  let req = r4b_sansio.terminologycapabilities_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.terminologycapabilities
  })
}

pub fn testreport_create(
  resource: r4b.Testreport,
  client: FhirClient,
) -> Result(r4b.Testreport, Err) {
  any_create(
    r4b.testreport_to_json(resource),
    "TestReport",
    r4b.testreport_decoder(),
    client,
  )
}

pub fn testreport_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Testreport, Err) {
  any_read(id, client, "TestReport", r4b.testreport_decoder())
}

pub fn testreport_update(
  resource: r4b.Testreport,
  client: FhirClient,
) -> Result(r4b.Testreport, Err) {
  any_update(
    resource.id,
    r4b.testreport_to_json(resource),
    "TestReport",
    r4b.testreport_decoder(),
    client,
  )
}

pub fn testreport_delete(
  resource: r4b.Testreport,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "TestReport", client)
}

pub fn testreport_search_bundled(
  sp: r4b_sansio.SpTestreport,
  client: FhirClient,
) {
  let req = r4b_sansio.testreport_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn testreport_search(
  sp: r4b_sansio.SpTestreport,
  client: FhirClient,
) -> Result(List(r4b.Testreport), Err) {
  let req = r4b_sansio.testreport_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.testreport
  })
}

pub fn testscript_create(
  resource: r4b.Testscript,
  client: FhirClient,
) -> Result(r4b.Testscript, Err) {
  any_create(
    r4b.testscript_to_json(resource),
    "TestScript",
    r4b.testscript_decoder(),
    client,
  )
}

pub fn testscript_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Testscript, Err) {
  any_read(id, client, "TestScript", r4b.testscript_decoder())
}

pub fn testscript_update(
  resource: r4b.Testscript,
  client: FhirClient,
) -> Result(r4b.Testscript, Err) {
  any_update(
    resource.id,
    r4b.testscript_to_json(resource),
    "TestScript",
    r4b.testscript_decoder(),
    client,
  )
}

pub fn testscript_delete(
  resource: r4b.Testscript,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "TestScript", client)
}

pub fn testscript_search_bundled(
  sp: r4b_sansio.SpTestscript,
  client: FhirClient,
) {
  let req = r4b_sansio.testscript_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn testscript_search(
  sp: r4b_sansio.SpTestscript,
  client: FhirClient,
) -> Result(List(r4b.Testscript), Err) {
  let req = r4b_sansio.testscript_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.testscript
  })
}

pub fn valueset_create(
  resource: r4b.Valueset,
  client: FhirClient,
) -> Result(r4b.Valueset, Err) {
  any_create(
    r4b.valueset_to_json(resource),
    "ValueSet",
    r4b.valueset_decoder(),
    client,
  )
}

pub fn valueset_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Valueset, Err) {
  any_read(id, client, "ValueSet", r4b.valueset_decoder())
}

pub fn valueset_update(
  resource: r4b.Valueset,
  client: FhirClient,
) -> Result(r4b.Valueset, Err) {
  any_update(
    resource.id,
    r4b.valueset_to_json(resource),
    "ValueSet",
    r4b.valueset_decoder(),
    client,
  )
}

pub fn valueset_delete(
  resource: r4b.Valueset,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "ValueSet", client)
}

pub fn valueset_search_bundled(sp: r4b_sansio.SpValueset, client: FhirClient) {
  let req = r4b_sansio.valueset_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn valueset_search(
  sp: r4b_sansio.SpValueset,
  client: FhirClient,
) -> Result(List(r4b.Valueset), Err) {
  let req = r4b_sansio.valueset_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.valueset
  })
}

pub fn verificationresult_create(
  resource: r4b.Verificationresult,
  client: FhirClient,
) -> Result(r4b.Verificationresult, Err) {
  any_create(
    r4b.verificationresult_to_json(resource),
    "VerificationResult",
    r4b.verificationresult_decoder(),
    client,
  )
}

pub fn verificationresult_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Verificationresult, Err) {
  any_read(id, client, "VerificationResult", r4b.verificationresult_decoder())
}

pub fn verificationresult_update(
  resource: r4b.Verificationresult,
  client: FhirClient,
) -> Result(r4b.Verificationresult, Err) {
  any_update(
    resource.id,
    r4b.verificationresult_to_json(resource),
    "VerificationResult",
    r4b.verificationresult_decoder(),
    client,
  )
}

pub fn verificationresult_delete(
  resource: r4b.Verificationresult,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "VerificationResult", client)
}

pub fn verificationresult_search_bundled(
  sp: r4b_sansio.SpVerificationresult,
  client: FhirClient,
) {
  let req = r4b_sansio.verificationresult_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn verificationresult_search(
  sp: r4b_sansio.SpVerificationresult,
  client: FhirClient,
) -> Result(List(r4b.Verificationresult), Err) {
  let req = r4b_sansio.verificationresult_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.verificationresult
  })
}

pub fn visionprescription_create(
  resource: r4b.Visionprescription,
  client: FhirClient,
) -> Result(r4b.Visionprescription, Err) {
  any_create(
    r4b.visionprescription_to_json(resource),
    "VisionPrescription",
    r4b.visionprescription_decoder(),
    client,
  )
}

pub fn visionprescription_read(
  id: String,
  client: FhirClient,
) -> Result(r4b.Visionprescription, Err) {
  any_read(id, client, "VisionPrescription", r4b.visionprescription_decoder())
}

pub fn visionprescription_update(
  resource: r4b.Visionprescription,
  client: FhirClient,
) -> Result(r4b.Visionprescription, Err) {
  any_update(
    resource.id,
    r4b.visionprescription_to_json(resource),
    "VisionPrescription",
    r4b.visionprescription_decoder(),
    client,
  )
}

pub fn visionprescription_delete(
  resource: r4b.Visionprescription,
  client: FhirClient,
) -> Result(r4b.Operationoutcome, Err) {
  any_delete(resource.id, "VisionPrescription", client)
}

pub fn visionprescription_search_bundled(
  sp: r4b_sansio.SpVisionprescription,
  client: FhirClient,
) {
  let req = r4b_sansio.visionprescription_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
}

pub fn visionprescription_search(
  sp: r4b_sansio.SpVisionprescription,
  client: FhirClient,
) -> Result(List(r4b.Visionprescription), Err) {
  let req = r4b_sansio.visionprescription_search_req(sp, client)
  sendreq_parseresource(req, r4b.bundle_decoder())
  |> result.map(fn(bundle) {
    { bundle |> r4b_sansio.bundle_to_groupedresources }.visionprescription
  })
}
