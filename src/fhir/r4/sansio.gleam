////[https://hl7.org/fhir/r4](https://hl7.org/fhir/r4) r4 sans-io request/response helpers suitable for building clients on top of, such as fhirclient_httpc.gleam and fhirclient_rsvp.gleam

import fhir/r4/resources
import gleam/dynamic/decode
import gleam/http
import gleam/http/request.{type Request, Request}
import gleam/http/response.{type Response}
import gleam/int
import gleam/json.{type Json}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import gleam/uri

/// FHIR client for sending http requests to server such as
/// `let pat = resources.patient_read("123", client)`
///
/// create client from server base url with fhirclient_new(baseurl)`
///
/// `let assert Ok(client) = sansio.fhirclient_new("r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = sansio.fhirclient_new("https://r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = sansio.fhirclient_new("https://hapi.fhir.org/baser4")`
///
/// `let assert Ok(client) = sansio.fhirclient_new("127.0.0.1:8000")`
pub type FhirClient {
  FhirClient(
    baseurl: uri.Uri,
    basereq: Request(Option(Json)),
    print_sent_requests: Logging,
    print_received_responses: Logging,
  )
}

/// creates a new client from server base url
///
/// `let assert Ok(client) = sansio.fhirclient_new("r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = sansio.fhirclient_new("https://r4.smarthealthit.org/")`
///
/// `let assert Ok(client) = sansio.fhirclient_new("https://hapi.fhir.org/baser4")`
///
/// `let assert Ok(client) = sansio.fhirclient_new("127.0.0.1:8000")`
pub fn fhirclient_new(
  server_base_url in_url: String,
) -> Result(FhirClient, ErrBaseUrl) {
  let in_url = case
    string.starts_with(in_url, "localhost")
    || string.starts_with(in_url, "127.0.0.1")
  {
    False -> in_url
    True -> "http://" <> in_url
  }
  let in_url = case string.starts_with(in_url, "http") {
    True -> in_url
    False -> "https://" <> in_url
  }
  case uri.parse(in_url) {
    Error(_) -> Error(UriParseFail)
    Ok(baseurl) ->
      case baseurl.host {
        None -> Error(UriNoHost)
        Some(host) -> {
          case baseurl.scheme {
            Some("http") -> Ok(create_base_req(http.Http, host, baseurl))
            Some("https") -> Ok(create_base_req(http.Https, host, baseurl))
            _ -> Error(UriNoHttpOrHttps)
          }
        }
      }
  }
}

/// use SMART app access token when making requests with client
pub fn set_access_token(client: FhirClient, token: String) -> FhirClient {
  FhirClient(
    ..client,
    basereq: client.basereq
      |> request.set_header("authorization", "Bearer " <> token),
  )
}

/// a problem with your baseurl in `fhirclient_new(baseurl)`,
/// which you should only see if you have typo in server base url
pub type ErrBaseUrl {
  UriParseFail
  UriNoHttpOrHttps
  UriNoHost
}

pub type Logging {
  LoggingOn
  LoggingOff
}

fn create_base_req(
  scheme: http.Scheme,
  host: String,
  baseurl: uri.Uri,
) -> FhirClient {
  let basereq =
    Request(
      method: http.Get,
      headers: [#("Accept", "application/fhir+json")],
      body: None,
      scheme:,
      host:,
      port: baseurl.port,
      path: case string.ends_with(baseurl.path, "/") {
        True -> string.drop_end(baseurl.path, 1)
        False -> baseurl.path
      },
      query: None,
    )
  FhirClient(
    baseurl:,
    basereq:,
    print_sent_requests: LoggingOff,
    print_received_responses: LoggingOff,
  )
}

pub type ErrResp {
  ///got json but could not parse it, probably a missing required field
  ErrParseJson(json.DecodeError)
  ///did not get resource json, often server eg nginx gives basic html response
  ErrNotJson(Response(String))
  ///got operationoutcome error from fhir server
  ErrOperationoutcome(resources.Operationoutcome)
}

pub type ErrReq {
  ///could not make an update request because resource has no id
  ErrNoId
}

pub fn any_create_req(
  resource_json: Json,
  res_type: resources.ResourceType,
  client: FhirClient,
) {
  client.basereq
  |> request.set_path(
    string.concat([
      client.basereq.path,
      "/",
      resources.resource_type_to_string(res_type),
    ]),
  )
  |> request.set_header("Content-Type", "application/fhir+json")
  |> request.set_header("Prefer", "return=representation")
  |> request.set_body(Some(resource_json))
  |> request.set_method(http.Post)
}

pub fn any_read_req(
  id: String,
  res_type: resources.ResourceType,
  client: FhirClient,
) {
  client.basereq
  |> request.set_path(
    string.concat([
      client.basereq.path,
      "/",
      resources.resource_type_to_string(res_type),
      "/",
      id,
    ]),
  )
}

pub fn any_update_req(
  id: Option(String),
  resource_json: Json,
  res_type: resources.ResourceType,
  client: FhirClient,
) -> Result(Request(Option(Json)), ErrReq) {
  case id {
    None -> Error(ErrNoId)
    Some(id) ->
      Ok(
        client.basereq
        |> request.set_path(
          string.concat([
            client.basereq.path,
            "/",
            resources.resource_type_to_string(res_type),
            "/",
            id,
          ]),
        )
        |> request.set_header("Content-Type", "application/fhir+json")
        |> request.set_header("Prefer", "return=representation")
        |> request.set_body(Some(resource_json))
        |> request.set_method(http.Put),
      )
  }
}

pub fn any_delete_req(
  id: String,
  res_type: resources.ResourceType,
  client: FhirClient,
) -> Request(Option(Json)) {
  client.basereq
  |> request.set_path(
    string.concat([
      client.basereq.path,
      "/",
      resources.resource_type_to_string(res_type),
      "/",
      id,
    ]),
  )
  |> request.set_method(http.Delete)
}

pub fn any_search_req(
  search_string: String,
  res_type: resources.ResourceType,
  client: FhirClient,
) -> Request(Option(Json)) {
  client.basereq
  |> request.set_path(
    string.concat([
      client.basereq.path,
      "/",
      resources.resource_type_to_string(res_type),
      "?",
      search_string,
    ]),
  )
}

pub fn any_operation_req(
  res_type: resources.ResourceType,
  res_id: Option(String),
  operation_name: String,
  params: Option(resources.Parameters),
  client: FhirClient,
) -> Request(Option(Json)) {
  let path = case res_id {
    Some(res_id) ->
      string.concat([
        client.basereq.path,
        "/",
        resources.resource_type_to_string(res_type),
        "/",
        res_id,
        "/$",
        operation_name,
      ])
    None ->
      string.concat([
        client.basereq.path,
        "/",
        resources.resource_type_to_string(res_type),
        "/$",
        operation_name,
      ])
  }
  let req =
    client.basereq
    |> request.set_path(path)
    |> request.set_header("Content-Type", "application/fhir+json")
    |> request.set_header("Prefer", "return=representation")
  case params {
    None -> req
    Some(params) ->
      req
      |> request.set_body(params |> resources.parameters_to_json |> Some)
      |> request.set_method(http.Post)
  }
}

/// decodes an Ok(resource) of given decoder type
/// or Error(ErrOperationoutcome(operationoutcome))
///
/// if resp.body is not a JSON, returns Error(ErrNotJson(resp))
pub fn any_resp(
  resp: Response(String),
  resource_dec: decode.Decoder(a),
  resource_type: resources.ResourceType,
) -> Result(a, ErrResp) {
  let resource_type = resources.resource_type_to_string(resource_type)
  case
    resp.body
    |> json.parse({
      use tag <- decode.field("resourceType", decode.string)
      case tag == resource_type {
        True -> resource_dec |> decode.map(Ok)
        False ->
          case tag == "OperationOutcome" {
            True ->
              resources.operationoutcome_decoder()
              |> decode.map(fn(oo) { Error(ErrOperationoutcome(oo)) })
            // if resourceType tag is neither desired res type or oo,
            // don't even bother trying to decode
            False ->
              decode.failure(Error(ErrNotJson(resp)), "")
              |> decode.map_errors(fn(_errs) {
                [
                  decode.DecodeError(
                    expected: resource_type <> " or OperationOutcome",
                    found: tag,
                    path: ["resourceType"],
                  ),
                ]
              })
          }
      }
    })
  {
    Ok(decoded) -> decoded
    Error(json_err) ->
      case json_err {
        json.UnableToDecode(_) -> Error(ErrParseJson(json_err))
        _ -> Error(ErrNotJson(resp))
      }
  }
}

pub type OperationoutcomeOrHTTP {
  SuccessOperationoutcome(resources.Operationoutcome)
  SuccessHttpResponse(Response(String))
}

/// returns Ok if http status code 200-299, otherwise Error,
/// and can return an OperationOutcome or HTTP response,
/// depending on if server sense OperationOutcome or empty body
pub fn http_or_operationoutcome_resp(
  resp: Response(String),
) -> Result(OperationoutcomeOrHTTP, ErrResp) {
  case resp.body {
    "" ->
      case resp.status < 300 {
        True -> Ok(SuccessHttpResponse(resp))
        False -> Error(ErrNotJson(resp))
      }
    _ -> {
      case resp.body |> json.parse(resources.operationoutcome_decoder()) {
        Ok(decoded_oo) ->
          case resp.status < 300 {
            True -> Ok(SuccessOperationoutcome(decoded_oo))
            False -> Error(ErrOperationoutcome(decoded_oo))
          }
        Error(json_err) ->
          case json_err {
            json.UnableToDecode(_) -> Error(ErrParseJson(json_err))
            _ -> Error(ErrNotJson(resp))
          }
      }
    }
  }
}

pub type PostBundleType {
  /// server executes all operations in transaction as one atomic operation
  Transaction
  /// server executes each operation in batch independently
  /// meaning an operation can fail without stopping other operations
  Batch
}

pub fn batch_req(
  reqs: List(Request(Option(Json))),
  bundle_type: PostBundleType,
  client: FhirClient,
) {
  // each request in list already has serialized json body
  // so we have to construct bundle json as json
  // rather than type safe bundle Bundle variable then serialize
  let base_len = string.length(client.basereq.path) + 1
  // request path is minus server base part
  // eg http://hapi.fhir.org/baseR4/Immunization/123 -> Immunization/123
  let entries =
    reqs
    |> list.map(fn(req) {
      let entry_req =
        json.object([
          #(
            "method",
            case req.method {
              http.Get -> "GET"
              http.Post -> "POST"
              http.Put -> "PUT"
              http.Delete -> "DELETE"
              http.Patch -> "PATCH"
              _ ->
                "invalid http verb which should never happen, you probably called batch_req with reqs created or modified by something other than this module"
            }
              |> json.string,
          ),
          #("url", json.string(string.drop_start(req.path, base_len))),
        ])
      let obj = [#("request", entry_req)]
      let obj = case req.body {
        None -> obj
        Some(resource) -> [#("resource", resource), ..obj]
      }
      json.object(obj)
    })
  let bundle_type = case bundle_type {
    Transaction -> "transaction"
    Batch -> "batch"
  }
  let batch_bundle =
    json.object([
      #("resourceType", json.string("Bundle")),
      #("type", json.string(bundle_type)),
      #("entry", json.preprocessed_array(entries)),
    ])
  client.basereq
  |> request.set_header("Prefer", "return=representation")
  |> request.set_header("Content-Type", "application/fhir+json")
  |> request.set_body(Some(batch_bundle))
  |> request.set_method(http.Post)
}

pub fn bundle_next_page_req(
  bundle: resources.Bundle,
  client: FhirClient,
) -> Result(Request(Option(Json)), Nil) {
  result.try(list.find(bundle.link, fn(l) { l.relation == "next" }), fn(link) {
    result.try(uri.parse(link.url), fn(uri) {
      Ok(Request(..client.basereq, path: uri.path, query: uri.query))
    })
  })
}

pub fn bundle_next_page_req_forgiving(
  bundle: resources.BundleForgiving,
  client: FhirClient,
) -> Result(Request(Option(Json)), Nil) {
  result.try(list.find(bundle.link, fn(l) { l.relation == "next" }), fn(link) {
    result.try(uri.parse(link.url), fn(uri) {
      Ok(Request(..client.basereq, path: uri.path, query: uri.query))
    })
  })
}

pub fn req_to_string(req: Request(Option(Json))) -> String {
  let to_uri = req |> request.to_uri |> uri.to_string
  let method = req.method |> http.method_to_string
  let headers =
    req.headers
    |> list.map(fn(hdr) { hdr.0 <> ": " <> hdr.1 })
    |> string.join("; ")

  //kind of duplicating but want to put body at end and maybe this performs better? idk maybe doesn't matter
  case req.body {
    Some(body) -> [
      "send request:",
      "to uri:  " <> to_uri,
      "method:  " <> method,
      "headers: " <> headers,
      "body:    " <> json.to_string(body),
    ]
    None -> [
      "send request:",
      "to uri:  " <> to_uri,
      "method:  " <> method,
      "headers: " <> headers,
    ]
  }
  |> string.join("\n")
}

pub fn resp_to_string(resp: Response(String)) -> String {
  let status = resp.status |> int.to_string
  let headers =
    resp.headers
    |> list.map(fn(hdr) { hdr.0 <> ": " <> hdr.1 })
    |> string.join("; ")
  [
    "receive response:",
    "status:  " <> status,
    "headers: " <> headers,
    "body:    " <> resp.body,
  ]
  |> string.join("\n")
}

pub type GroupedResources {
  GroupedResources(
    account: List(resources.Account),
    activitydefinition: List(resources.Activitydefinition),
    adverseevent: List(resources.Adverseevent),
    allergyintolerance: List(resources.Allergyintolerance),
    appointment: List(resources.Appointment),
    appointmentresponse: List(resources.Appointmentresponse),
    auditevent: List(resources.Auditevent),
    basic: List(resources.Basic),
    binary: List(resources.Binary),
    biologicallyderivedproduct: List(resources.Biologicallyderivedproduct),
    bodystructure: List(resources.Bodystructure),
    bundle: List(resources.Bundle),
    capabilitystatement: List(resources.Capabilitystatement),
    careplan: List(resources.Careplan),
    careteam: List(resources.Careteam),
    catalogentry: List(resources.Catalogentry),
    chargeitem: List(resources.Chargeitem),
    chargeitemdefinition: List(resources.Chargeitemdefinition),
    claim: List(resources.Claim),
    claimresponse: List(resources.Claimresponse),
    clinicalimpression: List(resources.Clinicalimpression),
    codesystem: List(resources.Codesystem),
    communication: List(resources.Communication),
    communicationrequest: List(resources.Communicationrequest),
    compartmentdefinition: List(resources.Compartmentdefinition),
    composition: List(resources.Composition),
    conceptmap: List(resources.Conceptmap),
    condition: List(resources.Condition),
    consent: List(resources.Consent),
    contract: List(resources.Contract),
    coverage: List(resources.Coverage),
    coverageeligibilityrequest: List(resources.Coverageeligibilityrequest),
    coverageeligibilityresponse: List(resources.Coverageeligibilityresponse),
    detectedissue: List(resources.Detectedissue),
    device: List(resources.Device),
    devicedefinition: List(resources.Devicedefinition),
    devicemetric: List(resources.Devicemetric),
    devicerequest: List(resources.Devicerequest),
    deviceusestatement: List(resources.Deviceusestatement),
    diagnosticreport: List(resources.Diagnosticreport),
    documentmanifest: List(resources.Documentmanifest),
    documentreference: List(resources.Documentreference),
    effectevidencesynthesis: List(resources.Effectevidencesynthesis),
    encounter: List(resources.Encounter),
    endpoint: List(resources.Endpoint),
    enrollmentrequest: List(resources.Enrollmentrequest),
    enrollmentresponse: List(resources.Enrollmentresponse),
    episodeofcare: List(resources.Episodeofcare),
    eventdefinition: List(resources.Eventdefinition),
    evidence: List(resources.Evidence),
    evidencevariable: List(resources.Evidencevariable),
    examplescenario: List(resources.Examplescenario),
    explanationofbenefit: List(resources.Explanationofbenefit),
    familymemberhistory: List(resources.Familymemberhistory),
    flag: List(resources.Flag),
    goal: List(resources.Goal),
    graphdefinition: List(resources.Graphdefinition),
    group: List(resources.Group),
    guidanceresponse: List(resources.Guidanceresponse),
    healthcareservice: List(resources.Healthcareservice),
    imagingstudy: List(resources.Imagingstudy),
    immunization: List(resources.Immunization),
    immunizationevaluation: List(resources.Immunizationevaluation),
    immunizationrecommendation: List(resources.Immunizationrecommendation),
    implementationguide: List(resources.Implementationguide),
    insuranceplan: List(resources.Insuranceplan),
    invoice: List(resources.Invoice),
    library: List(resources.Library),
    linkage: List(resources.Linkage),
    listfhir: List(resources.Listfhir),
    location: List(resources.Location),
    measure: List(resources.Measure),
    measurereport: List(resources.Measurereport),
    media: List(resources.Media),
    medication: List(resources.Medication),
    medicationadministration: List(resources.Medicationadministration),
    medicationdispense: List(resources.Medicationdispense),
    medicationknowledge: List(resources.Medicationknowledge),
    medicationrequest: List(resources.Medicationrequest),
    medicationstatement: List(resources.Medicationstatement),
    medicinalproduct: List(resources.Medicinalproduct),
    medicinalproductauthorization: List(resources.Medicinalproductauthorization),
    medicinalproductcontraindication: List(
      resources.Medicinalproductcontraindication,
    ),
    medicinalproductindication: List(resources.Medicinalproductindication),
    medicinalproductingredient: List(resources.Medicinalproductingredient),
    medicinalproductinteraction: List(resources.Medicinalproductinteraction),
    medicinalproductmanufactured: List(resources.Medicinalproductmanufactured),
    medicinalproductpackaged: List(resources.Medicinalproductpackaged),
    medicinalproductpharmaceutical: List(
      resources.Medicinalproductpharmaceutical,
    ),
    medicinalproductundesirableeffect: List(
      resources.Medicinalproductundesirableeffect,
    ),
    messagedefinition: List(resources.Messagedefinition),
    messageheader: List(resources.Messageheader),
    molecularsequence: List(resources.Molecularsequence),
    namingsystem: List(resources.Namingsystem),
    nutritionorder: List(resources.Nutritionorder),
    observation: List(resources.Observation),
    observationdefinition: List(resources.Observationdefinition),
    operationdefinition: List(resources.Operationdefinition),
    operationoutcome: List(resources.Operationoutcome),
    organization: List(resources.Organization),
    organizationaffiliation: List(resources.Organizationaffiliation),
    patient: List(resources.Patient),
    paymentnotice: List(resources.Paymentnotice),
    paymentreconciliation: List(resources.Paymentreconciliation),
    person: List(resources.Person),
    plandefinition: List(resources.Plandefinition),
    practitioner: List(resources.Practitioner),
    practitionerrole: List(resources.Practitionerrole),
    procedure: List(resources.Procedure),
    provenance: List(resources.Provenance),
    questionnaire: List(resources.Questionnaire),
    questionnaireresponse: List(resources.Questionnaireresponse),
    relatedperson: List(resources.Relatedperson),
    requestgroup: List(resources.Requestgroup),
    researchdefinition: List(resources.Researchdefinition),
    researchelementdefinition: List(resources.Researchelementdefinition),
    researchstudy: List(resources.Researchstudy),
    researchsubject: List(resources.Researchsubject),
    riskassessment: List(resources.Riskassessment),
    riskevidencesynthesis: List(resources.Riskevidencesynthesis),
    schedule: List(resources.Schedule),
    searchparameter: List(resources.Searchparameter),
    servicerequest: List(resources.Servicerequest),
    slot: List(resources.Slot),
    specimen: List(resources.Specimen),
    specimendefinition: List(resources.Specimendefinition),
    structuredefinition: List(resources.Structuredefinition),
    structuremap: List(resources.Structuremap),
    subscription: List(resources.Subscription),
    substance: List(resources.Substance),
    substancenucleicacid: List(resources.Substancenucleicacid),
    substancepolymer: List(resources.Substancepolymer),
    substanceprotein: List(resources.Substanceprotein),
    substancereferenceinformation: List(resources.Substancereferenceinformation),
    substancesourcematerial: List(resources.Substancesourcematerial),
    substancespecification: List(resources.Substancespecification),
    supplydelivery: List(resources.Supplydelivery),
    supplyrequest: List(resources.Supplyrequest),
    task: List(resources.Task),
    terminologycapabilities: List(resources.Terminologycapabilities),
    testreport: List(resources.Testreport),
    testscript: List(resources.Testscript),
    valueset: List(resources.Valueset),
    verificationresult: List(resources.Verificationresult),
    visionprescription: List(resources.Visionprescription),
  )
}

pub fn groupedresources_new() {
  GroupedResources(
    account: [],
    activitydefinition: [],
    adverseevent: [],
    allergyintolerance: [],
    appointment: [],
    appointmentresponse: [],
    auditevent: [],
    basic: [],
    binary: [],
    biologicallyderivedproduct: [],
    bodystructure: [],
    bundle: [],
    capabilitystatement: [],
    careplan: [],
    careteam: [],
    catalogentry: [],
    chargeitem: [],
    chargeitemdefinition: [],
    claim: [],
    claimresponse: [],
    clinicalimpression: [],
    codesystem: [],
    communication: [],
    communicationrequest: [],
    compartmentdefinition: [],
    composition: [],
    conceptmap: [],
    condition: [],
    consent: [],
    contract: [],
    coverage: [],
    coverageeligibilityrequest: [],
    coverageeligibilityresponse: [],
    detectedissue: [],
    device: [],
    devicedefinition: [],
    devicemetric: [],
    devicerequest: [],
    deviceusestatement: [],
    diagnosticreport: [],
    documentmanifest: [],
    documentreference: [],
    effectevidencesynthesis: [],
    encounter: [],
    endpoint: [],
    enrollmentrequest: [],
    enrollmentresponse: [],
    episodeofcare: [],
    eventdefinition: [],
    evidence: [],
    evidencevariable: [],
    examplescenario: [],
    explanationofbenefit: [],
    familymemberhistory: [],
    flag: [],
    goal: [],
    graphdefinition: [],
    group: [],
    guidanceresponse: [],
    healthcareservice: [],
    imagingstudy: [],
    immunization: [],
    immunizationevaluation: [],
    immunizationrecommendation: [],
    implementationguide: [],
    insuranceplan: [],
    invoice: [],
    library: [],
    linkage: [],
    listfhir: [],
    location: [],
    measure: [],
    measurereport: [],
    media: [],
    medication: [],
    medicationadministration: [],
    medicationdispense: [],
    medicationknowledge: [],
    medicationrequest: [],
    medicationstatement: [],
    medicinalproduct: [],
    medicinalproductauthorization: [],
    medicinalproductcontraindication: [],
    medicinalproductindication: [],
    medicinalproductingredient: [],
    medicinalproductinteraction: [],
    medicinalproductmanufactured: [],
    medicinalproductpackaged: [],
    medicinalproductpharmaceutical: [],
    medicinalproductundesirableeffect: [],
    messagedefinition: [],
    messageheader: [],
    molecularsequence: [],
    namingsystem: [],
    nutritionorder: [],
    observation: [],
    observationdefinition: [],
    operationdefinition: [],
    operationoutcome: [],
    organization: [],
    organizationaffiliation: [],
    patient: [],
    paymentnotice: [],
    paymentreconciliation: [],
    person: [],
    plandefinition: [],
    practitioner: [],
    practitionerrole: [],
    procedure: [],
    provenance: [],
    questionnaire: [],
    questionnaireresponse: [],
    relatedperson: [],
    requestgroup: [],
    researchdefinition: [],
    researchelementdefinition: [],
    researchstudy: [],
    researchsubject: [],
    riskassessment: [],
    riskevidencesynthesis: [],
    schedule: [],
    searchparameter: [],
    servicerequest: [],
    slot: [],
    specimen: [],
    specimendefinition: [],
    structuredefinition: [],
    structuremap: [],
    subscription: [],
    substance: [],
    substancenucleicacid: [],
    substancepolymer: [],
    substanceprotein: [],
    substancereferenceinformation: [],
    substancesourcematerial: [],
    substancespecification: [],
    supplydelivery: [],
    supplyrequest: [],
    task: [],
    terminologycapabilities: [],
    testreport: [],
    testscript: [],
    valueset: [],
    verificationresult: [],
    visionprescription: [],
  )
}

pub fn bundle_to_groupedresources(from bundle: resources.Bundle) {
  list.fold(
    from: groupedresources_new(),
    over: bundle.entry,
    with: fn(acc, entry) {
      case entry.resource {
        None -> acc
        Some(res) ->
          case res {
            resources.ResourceAccount(r) ->
              GroupedResources(..acc, account: [r, ..acc.account])
            resources.ResourceActivitydefinition(r) ->
              GroupedResources(..acc, activitydefinition: [
                r,
                ..acc.activitydefinition
              ])
            resources.ResourceAdverseevent(r) ->
              GroupedResources(..acc, adverseevent: [r, ..acc.adverseevent])
            resources.ResourceAllergyintolerance(r) ->
              GroupedResources(..acc, allergyintolerance: [
                r,
                ..acc.allergyintolerance
              ])
            resources.ResourceAppointment(r) ->
              GroupedResources(..acc, appointment: [r, ..acc.appointment])
            resources.ResourceAppointmentresponse(r) ->
              GroupedResources(..acc, appointmentresponse: [
                r,
                ..acc.appointmentresponse
              ])
            resources.ResourceAuditevent(r) ->
              GroupedResources(..acc, auditevent: [r, ..acc.auditevent])
            resources.ResourceBasic(r) ->
              GroupedResources(..acc, basic: [r, ..acc.basic])
            resources.ResourceBinary(r) ->
              GroupedResources(..acc, binary: [r, ..acc.binary])
            resources.ResourceBiologicallyderivedproduct(r) ->
              GroupedResources(..acc, biologicallyderivedproduct: [
                r,
                ..acc.biologicallyderivedproduct
              ])
            resources.ResourceBodystructure(r) ->
              GroupedResources(..acc, bodystructure: [r, ..acc.bodystructure])
            resources.ResourceBundle(r) ->
              GroupedResources(..acc, bundle: [r, ..acc.bundle])
            resources.ResourceCapabilitystatement(r) ->
              GroupedResources(..acc, capabilitystatement: [
                r,
                ..acc.capabilitystatement
              ])
            resources.ResourceCareplan(r) ->
              GroupedResources(..acc, careplan: [r, ..acc.careplan])
            resources.ResourceCareteam(r) ->
              GroupedResources(..acc, careteam: [r, ..acc.careteam])
            resources.ResourceCatalogentry(r) ->
              GroupedResources(..acc, catalogentry: [r, ..acc.catalogentry])
            resources.ResourceChargeitem(r) ->
              GroupedResources(..acc, chargeitem: [r, ..acc.chargeitem])
            resources.ResourceChargeitemdefinition(r) ->
              GroupedResources(..acc, chargeitemdefinition: [
                r,
                ..acc.chargeitemdefinition
              ])
            resources.ResourceClaim(r) ->
              GroupedResources(..acc, claim: [r, ..acc.claim])
            resources.ResourceClaimresponse(r) ->
              GroupedResources(..acc, claimresponse: [r, ..acc.claimresponse])
            resources.ResourceClinicalimpression(r) ->
              GroupedResources(..acc, clinicalimpression: [
                r,
                ..acc.clinicalimpression
              ])
            resources.ResourceCodesystem(r) ->
              GroupedResources(..acc, codesystem: [r, ..acc.codesystem])
            resources.ResourceCommunication(r) ->
              GroupedResources(..acc, communication: [r, ..acc.communication])
            resources.ResourceCommunicationrequest(r) ->
              GroupedResources(..acc, communicationrequest: [
                r,
                ..acc.communicationrequest
              ])
            resources.ResourceCompartmentdefinition(r) ->
              GroupedResources(..acc, compartmentdefinition: [
                r,
                ..acc.compartmentdefinition
              ])
            resources.ResourceComposition(r) ->
              GroupedResources(..acc, composition: [r, ..acc.composition])
            resources.ResourceConceptmap(r) ->
              GroupedResources(..acc, conceptmap: [r, ..acc.conceptmap])
            resources.ResourceCondition(r) ->
              GroupedResources(..acc, condition: [r, ..acc.condition])
            resources.ResourceConsent(r) ->
              GroupedResources(..acc, consent: [r, ..acc.consent])
            resources.ResourceContract(r) ->
              GroupedResources(..acc, contract: [r, ..acc.contract])
            resources.ResourceCoverage(r) ->
              GroupedResources(..acc, coverage: [r, ..acc.coverage])
            resources.ResourceCoverageeligibilityrequest(r) ->
              GroupedResources(..acc, coverageeligibilityrequest: [
                r,
                ..acc.coverageeligibilityrequest
              ])
            resources.ResourceCoverageeligibilityresponse(r) ->
              GroupedResources(..acc, coverageeligibilityresponse: [
                r,
                ..acc.coverageeligibilityresponse
              ])
            resources.ResourceDetectedissue(r) ->
              GroupedResources(..acc, detectedissue: [r, ..acc.detectedissue])
            resources.ResourceDevice(r) ->
              GroupedResources(..acc, device: [r, ..acc.device])
            resources.ResourceDevicedefinition(r) ->
              GroupedResources(..acc, devicedefinition: [
                r,
                ..acc.devicedefinition
              ])
            resources.ResourceDevicemetric(r) ->
              GroupedResources(..acc, devicemetric: [r, ..acc.devicemetric])
            resources.ResourceDevicerequest(r) ->
              GroupedResources(..acc, devicerequest: [r, ..acc.devicerequest])
            resources.ResourceDeviceusestatement(r) ->
              GroupedResources(..acc, deviceusestatement: [
                r,
                ..acc.deviceusestatement
              ])
            resources.ResourceDiagnosticreport(r) ->
              GroupedResources(..acc, diagnosticreport: [
                r,
                ..acc.diagnosticreport
              ])
            resources.ResourceDocumentmanifest(r) ->
              GroupedResources(..acc, documentmanifest: [
                r,
                ..acc.documentmanifest
              ])
            resources.ResourceDocumentreference(r) ->
              GroupedResources(..acc, documentreference: [
                r,
                ..acc.documentreference
              ])
            resources.ResourceEffectevidencesynthesis(r) ->
              GroupedResources(..acc, effectevidencesynthesis: [
                r,
                ..acc.effectevidencesynthesis
              ])
            resources.ResourceEncounter(r) ->
              GroupedResources(..acc, encounter: [r, ..acc.encounter])
            resources.ResourceEndpoint(r) ->
              GroupedResources(..acc, endpoint: [r, ..acc.endpoint])
            resources.ResourceEnrollmentrequest(r) ->
              GroupedResources(..acc, enrollmentrequest: [
                r,
                ..acc.enrollmentrequest
              ])
            resources.ResourceEnrollmentresponse(r) ->
              GroupedResources(..acc, enrollmentresponse: [
                r,
                ..acc.enrollmentresponse
              ])
            resources.ResourceEpisodeofcare(r) ->
              GroupedResources(..acc, episodeofcare: [r, ..acc.episodeofcare])
            resources.ResourceEventdefinition(r) ->
              GroupedResources(..acc, eventdefinition: [
                r,
                ..acc.eventdefinition
              ])
            resources.ResourceEvidence(r) ->
              GroupedResources(..acc, evidence: [r, ..acc.evidence])
            resources.ResourceEvidencevariable(r) ->
              GroupedResources(..acc, evidencevariable: [
                r,
                ..acc.evidencevariable
              ])
            resources.ResourceExamplescenario(r) ->
              GroupedResources(..acc, examplescenario: [
                r,
                ..acc.examplescenario
              ])
            resources.ResourceExplanationofbenefit(r) ->
              GroupedResources(..acc, explanationofbenefit: [
                r,
                ..acc.explanationofbenefit
              ])
            resources.ResourceFamilymemberhistory(r) ->
              GroupedResources(..acc, familymemberhistory: [
                r,
                ..acc.familymemberhistory
              ])
            resources.ResourceFlag(r) ->
              GroupedResources(..acc, flag: [r, ..acc.flag])
            resources.ResourceGoal(r) ->
              GroupedResources(..acc, goal: [r, ..acc.goal])
            resources.ResourceGraphdefinition(r) ->
              GroupedResources(..acc, graphdefinition: [
                r,
                ..acc.graphdefinition
              ])
            resources.ResourceGroup(r) ->
              GroupedResources(..acc, group: [r, ..acc.group])
            resources.ResourceGuidanceresponse(r) ->
              GroupedResources(..acc, guidanceresponse: [
                r,
                ..acc.guidanceresponse
              ])
            resources.ResourceHealthcareservice(r) ->
              GroupedResources(..acc, healthcareservice: [
                r,
                ..acc.healthcareservice
              ])
            resources.ResourceImagingstudy(r) ->
              GroupedResources(..acc, imagingstudy: [r, ..acc.imagingstudy])
            resources.ResourceImmunization(r) ->
              GroupedResources(..acc, immunization: [r, ..acc.immunization])
            resources.ResourceImmunizationevaluation(r) ->
              GroupedResources(..acc, immunizationevaluation: [
                r,
                ..acc.immunizationevaluation
              ])
            resources.ResourceImmunizationrecommendation(r) ->
              GroupedResources(..acc, immunizationrecommendation: [
                r,
                ..acc.immunizationrecommendation
              ])
            resources.ResourceImplementationguide(r) ->
              GroupedResources(..acc, implementationguide: [
                r,
                ..acc.implementationguide
              ])
            resources.ResourceInsuranceplan(r) ->
              GroupedResources(..acc, insuranceplan: [r, ..acc.insuranceplan])
            resources.ResourceInvoice(r) ->
              GroupedResources(..acc, invoice: [r, ..acc.invoice])
            resources.ResourceLibrary(r) ->
              GroupedResources(..acc, library: [r, ..acc.library])
            resources.ResourceLinkage(r) ->
              GroupedResources(..acc, linkage: [r, ..acc.linkage])
            resources.ResourceListfhir(r) ->
              GroupedResources(..acc, listfhir: [r, ..acc.listfhir])
            resources.ResourceLocation(r) ->
              GroupedResources(..acc, location: [r, ..acc.location])
            resources.ResourceMeasure(r) ->
              GroupedResources(..acc, measure: [r, ..acc.measure])
            resources.ResourceMeasurereport(r) ->
              GroupedResources(..acc, measurereport: [r, ..acc.measurereport])
            resources.ResourceMedia(r) ->
              GroupedResources(..acc, media: [r, ..acc.media])
            resources.ResourceMedication(r) ->
              GroupedResources(..acc, medication: [r, ..acc.medication])
            resources.ResourceMedicationadministration(r) ->
              GroupedResources(..acc, medicationadministration: [
                r,
                ..acc.medicationadministration
              ])
            resources.ResourceMedicationdispense(r) ->
              GroupedResources(..acc, medicationdispense: [
                r,
                ..acc.medicationdispense
              ])
            resources.ResourceMedicationknowledge(r) ->
              GroupedResources(..acc, medicationknowledge: [
                r,
                ..acc.medicationknowledge
              ])
            resources.ResourceMedicationrequest(r) ->
              GroupedResources(..acc, medicationrequest: [
                r,
                ..acc.medicationrequest
              ])
            resources.ResourceMedicationstatement(r) ->
              GroupedResources(..acc, medicationstatement: [
                r,
                ..acc.medicationstatement
              ])
            resources.ResourceMedicinalproduct(r) ->
              GroupedResources(..acc, medicinalproduct: [
                r,
                ..acc.medicinalproduct
              ])
            resources.ResourceMedicinalproductauthorization(r) ->
              GroupedResources(..acc, medicinalproductauthorization: [
                r,
                ..acc.medicinalproductauthorization
              ])
            resources.ResourceMedicinalproductcontraindication(r) ->
              GroupedResources(..acc, medicinalproductcontraindication: [
                r,
                ..acc.medicinalproductcontraindication
              ])
            resources.ResourceMedicinalproductindication(r) ->
              GroupedResources(..acc, medicinalproductindication: [
                r,
                ..acc.medicinalproductindication
              ])
            resources.ResourceMedicinalproductingredient(r) ->
              GroupedResources(..acc, medicinalproductingredient: [
                r,
                ..acc.medicinalproductingredient
              ])
            resources.ResourceMedicinalproductinteraction(r) ->
              GroupedResources(..acc, medicinalproductinteraction: [
                r,
                ..acc.medicinalproductinteraction
              ])
            resources.ResourceMedicinalproductmanufactured(r) ->
              GroupedResources(..acc, medicinalproductmanufactured: [
                r,
                ..acc.medicinalproductmanufactured
              ])
            resources.ResourceMedicinalproductpackaged(r) ->
              GroupedResources(..acc, medicinalproductpackaged: [
                r,
                ..acc.medicinalproductpackaged
              ])
            resources.ResourceMedicinalproductpharmaceutical(r) ->
              GroupedResources(..acc, medicinalproductpharmaceutical: [
                r,
                ..acc.medicinalproductpharmaceutical
              ])
            resources.ResourceMedicinalproductundesirableeffect(r) ->
              GroupedResources(..acc, medicinalproductundesirableeffect: [
                r,
                ..acc.medicinalproductundesirableeffect
              ])
            resources.ResourceMessagedefinition(r) ->
              GroupedResources(..acc, messagedefinition: [
                r,
                ..acc.messagedefinition
              ])
            resources.ResourceMessageheader(r) ->
              GroupedResources(..acc, messageheader: [r, ..acc.messageheader])
            resources.ResourceMolecularsequence(r) ->
              GroupedResources(..acc, molecularsequence: [
                r,
                ..acc.molecularsequence
              ])
            resources.ResourceNamingsystem(r) ->
              GroupedResources(..acc, namingsystem: [r, ..acc.namingsystem])
            resources.ResourceNutritionorder(r) ->
              GroupedResources(..acc, nutritionorder: [r, ..acc.nutritionorder])
            resources.ResourceObservation(r) ->
              GroupedResources(..acc, observation: [r, ..acc.observation])
            resources.ResourceObservationdefinition(r) ->
              GroupedResources(..acc, observationdefinition: [
                r,
                ..acc.observationdefinition
              ])
            resources.ResourceOperationdefinition(r) ->
              GroupedResources(..acc, operationdefinition: [
                r,
                ..acc.operationdefinition
              ])
            resources.ResourceOperationoutcome(r) ->
              GroupedResources(..acc, operationoutcome: [
                r,
                ..acc.operationoutcome
              ])
            resources.ResourceOrganization(r) ->
              GroupedResources(..acc, organization: [r, ..acc.organization])
            resources.ResourceOrganizationaffiliation(r) ->
              GroupedResources(..acc, organizationaffiliation: [
                r,
                ..acc.organizationaffiliation
              ])
            resources.ResourcePatient(r) ->
              GroupedResources(..acc, patient: [r, ..acc.patient])
            resources.ResourcePaymentnotice(r) ->
              GroupedResources(..acc, paymentnotice: [r, ..acc.paymentnotice])
            resources.ResourcePaymentreconciliation(r) ->
              GroupedResources(..acc, paymentreconciliation: [
                r,
                ..acc.paymentreconciliation
              ])
            resources.ResourcePerson(r) ->
              GroupedResources(..acc, person: [r, ..acc.person])
            resources.ResourcePlandefinition(r) ->
              GroupedResources(..acc, plandefinition: [r, ..acc.plandefinition])
            resources.ResourcePractitioner(r) ->
              GroupedResources(..acc, practitioner: [r, ..acc.practitioner])
            resources.ResourcePractitionerrole(r) ->
              GroupedResources(..acc, practitionerrole: [
                r,
                ..acc.practitionerrole
              ])
            resources.ResourceProcedure(r) ->
              GroupedResources(..acc, procedure: [r, ..acc.procedure])
            resources.ResourceProvenance(r) ->
              GroupedResources(..acc, provenance: [r, ..acc.provenance])
            resources.ResourceQuestionnaire(r) ->
              GroupedResources(..acc, questionnaire: [r, ..acc.questionnaire])
            resources.ResourceQuestionnaireresponse(r) ->
              GroupedResources(..acc, questionnaireresponse: [
                r,
                ..acc.questionnaireresponse
              ])
            resources.ResourceRelatedperson(r) ->
              GroupedResources(..acc, relatedperson: [r, ..acc.relatedperson])
            resources.ResourceRequestgroup(r) ->
              GroupedResources(..acc, requestgroup: [r, ..acc.requestgroup])
            resources.ResourceResearchdefinition(r) ->
              GroupedResources(..acc, researchdefinition: [
                r,
                ..acc.researchdefinition
              ])
            resources.ResourceResearchelementdefinition(r) ->
              GroupedResources(..acc, researchelementdefinition: [
                r,
                ..acc.researchelementdefinition
              ])
            resources.ResourceResearchstudy(r) ->
              GroupedResources(..acc, researchstudy: [r, ..acc.researchstudy])
            resources.ResourceResearchsubject(r) ->
              GroupedResources(..acc, researchsubject: [
                r,
                ..acc.researchsubject
              ])
            resources.ResourceRiskassessment(r) ->
              GroupedResources(..acc, riskassessment: [r, ..acc.riskassessment])
            resources.ResourceRiskevidencesynthesis(r) ->
              GroupedResources(..acc, riskevidencesynthesis: [
                r,
                ..acc.riskevidencesynthesis
              ])
            resources.ResourceSchedule(r) ->
              GroupedResources(..acc, schedule: [r, ..acc.schedule])
            resources.ResourceSearchparameter(r) ->
              GroupedResources(..acc, searchparameter: [
                r,
                ..acc.searchparameter
              ])
            resources.ResourceServicerequest(r) ->
              GroupedResources(..acc, servicerequest: [r, ..acc.servicerequest])
            resources.ResourceSlot(r) ->
              GroupedResources(..acc, slot: [r, ..acc.slot])
            resources.ResourceSpecimen(r) ->
              GroupedResources(..acc, specimen: [r, ..acc.specimen])
            resources.ResourceSpecimendefinition(r) ->
              GroupedResources(..acc, specimendefinition: [
                r,
                ..acc.specimendefinition
              ])
            resources.ResourceStructuredefinition(r) ->
              GroupedResources(..acc, structuredefinition: [
                r,
                ..acc.structuredefinition
              ])
            resources.ResourceStructuremap(r) ->
              GroupedResources(..acc, structuremap: [r, ..acc.structuremap])
            resources.ResourceSubscription(r) ->
              GroupedResources(..acc, subscription: [r, ..acc.subscription])
            resources.ResourceSubstance(r) ->
              GroupedResources(..acc, substance: [r, ..acc.substance])
            resources.ResourceSubstancenucleicacid(r) ->
              GroupedResources(..acc, substancenucleicacid: [
                r,
                ..acc.substancenucleicacid
              ])
            resources.ResourceSubstancepolymer(r) ->
              GroupedResources(..acc, substancepolymer: [
                r,
                ..acc.substancepolymer
              ])
            resources.ResourceSubstanceprotein(r) ->
              GroupedResources(..acc, substanceprotein: [
                r,
                ..acc.substanceprotein
              ])
            resources.ResourceSubstancereferenceinformation(r) ->
              GroupedResources(..acc, substancereferenceinformation: [
                r,
                ..acc.substancereferenceinformation
              ])
            resources.ResourceSubstancesourcematerial(r) ->
              GroupedResources(..acc, substancesourcematerial: [
                r,
                ..acc.substancesourcematerial
              ])
            resources.ResourceSubstancespecification(r) ->
              GroupedResources(..acc, substancespecification: [
                r,
                ..acc.substancespecification
              ])
            resources.ResourceSupplydelivery(r) ->
              GroupedResources(..acc, supplydelivery: [r, ..acc.supplydelivery])
            resources.ResourceSupplyrequest(r) ->
              GroupedResources(..acc, supplyrequest: [r, ..acc.supplyrequest])
            resources.ResourceTask(r) ->
              GroupedResources(..acc, task: [r, ..acc.task])
            resources.ResourceTerminologycapabilities(r) ->
              GroupedResources(..acc, terminologycapabilities: [
                r,
                ..acc.terminologycapabilities
              ])
            resources.ResourceTestreport(r) ->
              GroupedResources(..acc, testreport: [r, ..acc.testreport])
            resources.ResourceTestscript(r) ->
              GroupedResources(..acc, testscript: [r, ..acc.testscript])
            resources.ResourceValueset(r) ->
              GroupedResources(..acc, valueset: [r, ..acc.valueset])
            resources.ResourceVerificationresult(r) ->
              GroupedResources(..acc, verificationresult: [
                r,
                ..acc.verificationresult
              ])
            resources.ResourceVisionprescription(r) ->
              GroupedResources(..acc, visionprescription: [
                r,
                ..acc.visionprescription
              ])
            _ -> acc
          }
      }
    },
  )
}
