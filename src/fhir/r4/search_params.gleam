////[https://hl7.org/fhir/r4](https://hl7.org/fhir/r4) r4 search params

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string

pub fn to_string(params) {
  list.fold(
    from: [],
    over: params,
    with: fn(acc, param: #(String, Option(String))) {
      case param.1 {
        None -> acc
        Some(p) -> [param.0 <> "=" <> p, ..acc]
      }
    },
  )
  |> string.join("&")
}

pub type Account {
  Account(
    owner: Option(String),
    identifier: Option(String),
    period: Option(String),
    subject: Option(String),
    patient: Option(String),
    name: Option(String),
    type_: Option(String),
    status: Option(String),
  )
}

pub type Activitydefinition {
  Activitydefinition(
    date: Option(String),
    identifier: Option(String),
    successor: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    derived_from: Option(String),
    context_type: Option(String),
    predecessor: Option(String),
    title: Option(String),
    composed_of: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    effective: Option(String),
    depends_on: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    topic: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type Adverseevent {
  Adverseevent(
    date: Option(String),
    severity: Option(String),
    recorder: Option(String),
    study: Option(String),
    actuality: Option(String),
    seriousness: Option(String),
    subject: Option(String),
    resultingcondition: Option(String),
    substance: Option(String),
    location: Option(String),
    category: Option(String),
    event: Option(String),
  )
}

pub type Allergyintolerance {
  Allergyintolerance(
    severity: Option(String),
    date: Option(String),
    identifier: Option(String),
    manifestation: Option(String),
    recorder: Option(String),
    code: Option(String),
    verification_status: Option(String),
    criticality: Option(String),
    clinical_status: Option(String),
    type_: Option(String),
    onset: Option(String),
    route: Option(String),
    asserter: Option(String),
    patient: Option(String),
    category: Option(String),
    last_date: Option(String),
  )
}

pub type Appointment {
  Appointment(
    date: Option(String),
    identifier: Option(String),
    specialty: Option(String),
    service_category: Option(String),
    practitioner: Option(String),
    part_status: Option(String),
    appointment_type: Option(String),
    service_type: Option(String),
    slot: Option(String),
    reason_code: Option(String),
    actor: Option(String),
    based_on: Option(String),
    patient: Option(String),
    reason_reference: Option(String),
    supporting_info: Option(String),
    location: Option(String),
    status: Option(String),
  )
}

pub type Appointmentresponse {
  Appointmentresponse(
    actor: Option(String),
    identifier: Option(String),
    practitioner: Option(String),
    part_status: Option(String),
    patient: Option(String),
    appointment: Option(String),
    location: Option(String),
  )
}

pub type Auditevent {
  Auditevent(
    date: Option(String),
    entity_type: Option(String),
    agent: Option(String),
    address: Option(String),
    entity_role: Option(String),
    source: Option(String),
    type_: Option(String),
    altid: Option(String),
    site: Option(String),
    agent_name: Option(String),
    entity_name: Option(String),
    subtype: Option(String),
    patient: Option(String),
    action: Option(String),
    agent_role: Option(String),
    entity: Option(String),
    outcome: Option(String),
    policy: Option(String),
  )
}

pub type Basic {
  Basic(
    identifier: Option(String),
    code: Option(String),
    subject: Option(String),
    created: Option(String),
    patient: Option(String),
    author: Option(String),
  )
}

pub type Binary {
  Binary
}

pub type Biologicallyderivedproduct {
  Biologicallyderivedproduct
}

pub type Bodystructure {
  Bodystructure(
    identifier: Option(String),
    morphology: Option(String),
    patient: Option(String),
    location: Option(String),
  )
}

pub type Bundle {
  Bundle(
    identifier: Option(String),
    composition: Option(String),
    type_: Option(String),
    message: Option(String),
    timestamp: Option(String),
  )
}

pub type Capabilitystatement {
  Capabilitystatement(
    date: Option(String),
    resource_profile: Option(String),
    context_type_value: Option(String),
    software: Option(String),
    resource: Option(String),
    jurisdiction: Option(String),
    format: Option(String),
    description: Option(String),
    context_type: Option(String),
    title: Option(String),
    fhirversion: Option(String),
    version: Option(String),
    url: Option(String),
    supported_profile: Option(String),
    mode: Option(String),
    context_quantity: Option(String),
    security_service: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    guide: Option(String),
    status: Option(String),
  )
}

pub type Careplan {
  Careplan(
    date: Option(String),
    care_team: Option(String),
    identifier: Option(String),
    performer: Option(String),
    goal: Option(String),
    subject: Option(String),
    replaces: Option(String),
    instantiates_canonical: Option(String),
    part_of: Option(String),
    encounter: Option(String),
    intent: Option(String),
    activity_reference: Option(String),
    condition: Option(String),
    based_on: Option(String),
    patient: Option(String),
    activity_date: Option(String),
    instantiates_uri: Option(String),
    category: Option(String),
    activity_code: Option(String),
    status: Option(String),
  )
}

pub type Careteam {
  Careteam(
    date: Option(String),
    identifier: Option(String),
    patient: Option(String),
    subject: Option(String),
    encounter: Option(String),
    category: Option(String),
    participant: Option(String),
    status: Option(String),
  )
}

pub type Catalogentry {
  Catalogentry
}

pub type Chargeitem {
  Chargeitem(
    identifier: Option(String),
    performing_organization: Option(String),
    code: Option(String),
    quantity: Option(String),
    subject: Option(String),
    occurrence: Option(String),
    entered_date: Option(String),
    performer_function: Option(String),
    patient: Option(String),
    factor_override: Option(String),
    service: Option(String),
    price_override: Option(String),
    context: Option(String),
    enterer: Option(String),
    performer_actor: Option(String),
    account: Option(String),
    requesting_organization: Option(String),
  )
}

pub type Chargeitemdefinition {
  Chargeitemdefinition(
    date: Option(String),
    identifier: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    context_type: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    effective: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type Claim {
  Claim(
    care_team: Option(String),
    identifier: Option(String),
    use_: Option(String),
    created: Option(String),
    encounter: Option(String),
    priority: Option(String),
    payee: Option(String),
    provider: Option(String),
    patient: Option(String),
    insurer: Option(String),
    detail_udi: Option(String),
    enterer: Option(String),
    procedure_udi: Option(String),
    subdetail_udi: Option(String),
    facility: Option(String),
    item_udi: Option(String),
    status: Option(String),
  )
}

pub type Claimresponse {
  Claimresponse(
    identifier: Option(String),
    request: Option(String),
    disposition: Option(String),
    insurer: Option(String),
    created: Option(String),
    patient: Option(String),
    use_: Option(String),
    payment_date: Option(String),
    outcome: Option(String),
    requestor: Option(String),
    status: Option(String),
  )
}

pub type Clinicalimpression {
  Clinicalimpression(
    date: Option(String),
    identifier: Option(String),
    previous: Option(String),
    finding_code: Option(String),
    assessor: Option(String),
    subject: Option(String),
    encounter: Option(String),
    finding_ref: Option(String),
    problem: Option(String),
    patient: Option(String),
    supporting_info: Option(String),
    investigation: Option(String),
    status: Option(String),
  )
}

pub type Codesystem {
  Codesystem(
    date: Option(String),
    identifier: Option(String),
    code: Option(String),
    context_type_value: Option(String),
    content_mode: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    context_type: Option(String),
    language: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    supplements: Option(String),
    system: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type Communication {
  Communication(
    identifier: Option(String),
    subject: Option(String),
    instantiates_canonical: Option(String),
    received: Option(String),
    part_of: Option(String),
    medium: Option(String),
    encounter: Option(String),
    sent: Option(String),
    based_on: Option(String),
    sender: Option(String),
    patient: Option(String),
    recipient: Option(String),
    instantiates_uri: Option(String),
    category: Option(String),
    status: Option(String),
  )
}

pub type Communicationrequest {
  Communicationrequest(
    requester: Option(String),
    authored: Option(String),
    identifier: Option(String),
    subject: Option(String),
    replaces: Option(String),
    medium: Option(String),
    encounter: Option(String),
    occurrence: Option(String),
    priority: Option(String),
    group_identifier: Option(String),
    based_on: Option(String),
    sender: Option(String),
    patient: Option(String),
    recipient: Option(String),
    category: Option(String),
    status: Option(String),
  )
}

pub type Compartmentdefinition {
  Compartmentdefinition(
    date: Option(String),
    code: Option(String),
    context_type_value: Option(String),
    resource: Option(String),
    description: Option(String),
    context_type: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type Composition {
  Composition(
    date: Option(String),
    identifier: Option(String),
    period: Option(String),
    related_id: Option(String),
    subject: Option(String),
    author: Option(String),
    confidentiality: Option(String),
    section: Option(String),
    encounter: Option(String),
    type_: Option(String),
    title: Option(String),
    attester: Option(String),
    entry: Option(String),
    related_ref: Option(String),
    patient: Option(String),
    context: Option(String),
    category: Option(String),
    status: Option(String),
  )
}

pub type Conceptmap {
  Conceptmap(
    date: Option(String),
    other: Option(String),
    context_type_value: Option(String),
    target_system: Option(String),
    dependson: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    context_type: Option(String),
    source: Option(String),
    title: Option(String),
    context_quantity: Option(String),
    source_uri: Option(String),
    context: Option(String),
    context_type_quantity: Option(String),
    source_system: Option(String),
    target_code: Option(String),
    target_uri: Option(String),
    identifier: Option(String),
    product: Option(String),
    version: Option(String),
    url: Option(String),
    target: Option(String),
    source_code: Option(String),
    name: Option(String),
    publisher: Option(String),
    status: Option(String),
  )
}

pub type Condition {
  Condition(
    severity: Option(String),
    evidence_detail: Option(String),
    identifier: Option(String),
    onset_info: Option(String),
    recorded_date: Option(String),
    code: Option(String),
    evidence: Option(String),
    subject: Option(String),
    verification_status: Option(String),
    clinical_status: Option(String),
    encounter: Option(String),
    onset_date: Option(String),
    abatement_date: Option(String),
    asserter: Option(String),
    stage: Option(String),
    abatement_string: Option(String),
    patient: Option(String),
    onset_age: Option(String),
    abatement_age: Option(String),
    category: Option(String),
    body_site: Option(String),
  )
}

pub type Consent {
  Consent(
    date: Option(String),
    identifier: Option(String),
    period: Option(String),
    data: Option(String),
    purpose: Option(String),
    source_reference: Option(String),
    actor: Option(String),
    security_label: Option(String),
    patient: Option(String),
    organization: Option(String),
    scope: Option(String),
    action: Option(String),
    consentor: Option(String),
    category: Option(String),
    status: Option(String),
  )
}

pub type Contract {
  Contract(
    identifier: Option(String),
    instantiates: Option(String),
    patient: Option(String),
    subject: Option(String),
    authority: Option(String),
    domain: Option(String),
    issued: Option(String),
    url: Option(String),
    signer: Option(String),
    status: Option(String),
  )
}

pub type Coverage {
  Coverage(
    identifier: Option(String),
    payor: Option(String),
    subscriber: Option(String),
    beneficiary: Option(String),
    patient: Option(String),
    class_value: Option(String),
    type_: Option(String),
    dependent: Option(String),
    class_type: Option(String),
    policy_holder: Option(String),
    status: Option(String),
  )
}

pub type Coverageeligibilityrequest {
  Coverageeligibilityrequest(
    identifier: Option(String),
    provider: Option(String),
    patient: Option(String),
    created: Option(String),
    enterer: Option(String),
    facility: Option(String),
    status: Option(String),
  )
}

pub type Coverageeligibilityresponse {
  Coverageeligibilityresponse(
    identifier: Option(String),
    request: Option(String),
    disposition: Option(String),
    patient: Option(String),
    insurer: Option(String),
    created: Option(String),
    outcome: Option(String),
    requestor: Option(String),
    status: Option(String),
  )
}

pub type Detectedissue {
  Detectedissue(
    identifier: Option(String),
    code: Option(String),
    identified: Option(String),
    patient: Option(String),
    author: Option(String),
    implicated: Option(String),
  )
}

pub type Device {
  Device(
    udi_di: Option(String),
    identifier: Option(String),
    udi_carrier: Option(String),
    device_name: Option(String),
    patient: Option(String),
    organization: Option(String),
    model: Option(String),
    location: Option(String),
    type_: Option(String),
    url: Option(String),
    manufacturer: Option(String),
    status: Option(String),
  )
}

pub type Devicedefinition {
  Devicedefinition(
    parent: Option(String),
    identifier: Option(String),
    type_: Option(String),
  )
}

pub type Devicemetric {
  Devicemetric(
    parent: Option(String),
    identifier: Option(String),
    source: Option(String),
    type_: Option(String),
    category: Option(String),
  )
}

pub type Devicerequest {
  Devicerequest(
    requester: Option(String),
    insurance: Option(String),
    identifier: Option(String),
    code: Option(String),
    performer: Option(String),
    event_date: Option(String),
    subject: Option(String),
    instantiates_canonical: Option(String),
    encounter: Option(String),
    authored_on: Option(String),
    intent: Option(String),
    group_identifier: Option(String),
    based_on: Option(String),
    patient: Option(String),
    instantiates_uri: Option(String),
    prior_request: Option(String),
    device: Option(String),
    status: Option(String),
  )
}

pub type Deviceusestatement {
  Deviceusestatement(
    identifier: Option(String),
    subject: Option(String),
    patient: Option(String),
    device: Option(String),
  )
}

pub type Diagnosticreport {
  Diagnosticreport(
    date: Option(String),
    identifier: Option(String),
    performer: Option(String),
    code: Option(String),
    subject: Option(String),
    media: Option(String),
    encounter: Option(String),
    result: Option(String),
    conclusion: Option(String),
    based_on: Option(String),
    patient: Option(String),
    specimen: Option(String),
    issued: Option(String),
    category: Option(String),
    results_interpreter: Option(String),
    status: Option(String),
  )
}

pub type Documentmanifest {
  Documentmanifest(
    identifier: Option(String),
    item: Option(String),
    related_id: Option(String),
    subject: Option(String),
    author: Option(String),
    created: Option(String),
    description: Option(String),
    source: Option(String),
    type_: Option(String),
    related_ref: Option(String),
    patient: Option(String),
    recipient: Option(String),
    status: Option(String),
  )
}

pub type Documentreference {
  Documentreference(
    date: Option(String),
    subject: Option(String),
    description: Option(String),
    language: Option(String),
    type_: Option(String),
    relation: Option(String),
    setting: Option(String),
    related: Option(String),
    patient: Option(String),
    relationship: Option(String),
    event: Option(String),
    authenticator: Option(String),
    identifier: Option(String),
    period: Option(String),
    custodian: Option(String),
    author: Option(String),
    format: Option(String),
    encounter: Option(String),
    contenttype: Option(String),
    security_label: Option(String),
    location: Option(String),
    category: Option(String),
    relatesto: Option(String),
    facility: Option(String),
    status: Option(String),
  )
}

pub type Effectevidencesynthesis {
  Effectevidencesynthesis(
    date: Option(String),
    identifier: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    context_type: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    effective: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type Encounter {
  Encounter(
    date: Option(String),
    identifier: Option(String),
    participant_type: Option(String),
    practitioner: Option(String),
    subject: Option(String),
    length: Option(String),
    episode_of_care: Option(String),
    diagnosis: Option(String),
    appointment: Option(String),
    part_of: Option(String),
    type_: Option(String),
    reason_code: Option(String),
    participant: Option(String),
    based_on: Option(String),
    patient: Option(String),
    reason_reference: Option(String),
    location_period: Option(String),
    location: Option(String),
    service_provider: Option(String),
    special_arrangement: Option(String),
    class: Option(String),
    account: Option(String),
    status: Option(String),
  )
}

pub type Endpoint {
  Endpoint(
    payload_type: Option(String),
    identifier: Option(String),
    organization: Option(String),
    connection_type: Option(String),
    name: Option(String),
    status: Option(String),
  )
}

pub type Enrollmentrequest {
  Enrollmentrequest(
    identifier: Option(String),
    subject: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type Enrollmentresponse {
  Enrollmentresponse(
    identifier: Option(String),
    request: Option(String),
    status: Option(String),
  )
}

pub type Episodeofcare {
  Episodeofcare(
    date: Option(String),
    identifier: Option(String),
    condition: Option(String),
    patient: Option(String),
    organization: Option(String),
    type_: Option(String),
    care_manager: Option(String),
    status: Option(String),
    incoming_referral: Option(String),
  )
}

pub type Eventdefinition {
  Eventdefinition(
    date: Option(String),
    identifier: Option(String),
    successor: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    derived_from: Option(String),
    context_type: Option(String),
    predecessor: Option(String),
    title: Option(String),
    composed_of: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    effective: Option(String),
    depends_on: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    topic: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type Evidence {
  Evidence(
    date: Option(String),
    identifier: Option(String),
    successor: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    derived_from: Option(String),
    context_type: Option(String),
    predecessor: Option(String),
    title: Option(String),
    composed_of: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    effective: Option(String),
    depends_on: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    topic: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type Evidencevariable {
  Evidencevariable(
    date: Option(String),
    identifier: Option(String),
    successor: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    derived_from: Option(String),
    context_type: Option(String),
    predecessor: Option(String),
    title: Option(String),
    composed_of: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    effective: Option(String),
    depends_on: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    topic: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type Examplescenario {
  Examplescenario(
    date: Option(String),
    identifier: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    context_type: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type Explanationofbenefit {
  Explanationofbenefit(
    coverage: Option(String),
    care_team: Option(String),
    identifier: Option(String),
    created: Option(String),
    encounter: Option(String),
    payee: Option(String),
    disposition: Option(String),
    provider: Option(String),
    patient: Option(String),
    detail_udi: Option(String),
    claim: Option(String),
    enterer: Option(String),
    procedure_udi: Option(String),
    subdetail_udi: Option(String),
    facility: Option(String),
    item_udi: Option(String),
    status: Option(String),
  )
}

pub type Familymemberhistory {
  Familymemberhistory(
    date: Option(String),
    identifier: Option(String),
    code: Option(String),
    patient: Option(String),
    sex: Option(String),
    instantiates_canonical: Option(String),
    instantiates_uri: Option(String),
    relationship: Option(String),
    status: Option(String),
  )
}

pub type Flag {
  Flag(
    date: Option(String),
    identifier: Option(String),
    subject: Option(String),
    patient: Option(String),
    author: Option(String),
    encounter: Option(String),
  )
}

pub type Goal {
  Goal(
    identifier: Option(String),
    lifecycle_status: Option(String),
    achievement_status: Option(String),
    patient: Option(String),
    subject: Option(String),
    start_date: Option(String),
    category: Option(String),
    target_date: Option(String),
  )
}

pub type Graphdefinition {
  Graphdefinition(
    date: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    start: Option(String),
    description: Option(String),
    context_type: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type Group {
  Group(
    actual: Option(String),
    identifier: Option(String),
    characteristic_value: Option(String),
    managing_entity: Option(String),
    code: Option(String),
    member: Option(String),
    exclude: Option(String),
    type_: Option(String),
    value: Option(String),
    characteristic: Option(String),
  )
}

pub type Guidanceresponse {
  Guidanceresponse(
    request: Option(String),
    identifier: Option(String),
    patient: Option(String),
    subject: Option(String),
  )
}

pub type Healthcareservice {
  Healthcareservice(
    identifier: Option(String),
    specialty: Option(String),
    endpoint: Option(String),
    service_category: Option(String),
    coverage_area: Option(String),
    service_type: Option(String),
    organization: Option(String),
    name: Option(String),
    active: Option(String),
    location: Option(String),
    program: Option(String),
    characteristic: Option(String),
  )
}

pub type Imagingstudy {
  Imagingstudy(
    identifier: Option(String),
    reason: Option(String),
    dicom_class: Option(String),
    modality: Option(String),
    bodysite: Option(String),
    instance: Option(String),
    performer: Option(String),
    subject: Option(String),
    started: Option(String),
    interpreter: Option(String),
    encounter: Option(String),
    referrer: Option(String),
    endpoint: Option(String),
    patient: Option(String),
    series: Option(String),
    basedon: Option(String),
    status: Option(String),
  )
}

pub type Immunization {
  Immunization(
    date: Option(String),
    identifier: Option(String),
    performer: Option(String),
    reaction: Option(String),
    lot_number: Option(String),
    status_reason: Option(String),
    reason_code: Option(String),
    manufacturer: Option(String),
    target_disease: Option(String),
    patient: Option(String),
    series: Option(String),
    vaccine_code: Option(String),
    reason_reference: Option(String),
    location: Option(String),
    status: Option(String),
    reaction_date: Option(String),
  )
}

pub type Immunizationevaluation {
  Immunizationevaluation(
    date: Option(String),
    identifier: Option(String),
    target_disease: Option(String),
    patient: Option(String),
    dose_status: Option(String),
    immunization_event: Option(String),
    status: Option(String),
  )
}

pub type Immunizationrecommendation {
  Immunizationrecommendation(
    date: Option(String),
    identifier: Option(String),
    target_disease: Option(String),
    patient: Option(String),
    vaccine_type: Option(String),
    information: Option(String),
    support: Option(String),
    status: Option(String),
  )
}

pub type Implementationguide {
  Implementationguide(
    date: Option(String),
    context_type_value: Option(String),
    resource: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    context_type: Option(String),
    experimental: Option(String),
    global: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    depends_on: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type Insuranceplan {
  Insuranceplan(
    identifier: Option(String),
    address: Option(String),
    address_state: Option(String),
    owned_by: Option(String),
    type_: Option(String),
    address_postalcode: Option(String),
    administered_by: Option(String),
    address_country: Option(String),
    endpoint: Option(String),
    phonetic: Option(String),
    name: Option(String),
    address_use: Option(String),
    address_city: Option(String),
    status: Option(String),
  )
}

pub type Invoice {
  Invoice(
    date: Option(String),
    identifier: Option(String),
    totalgross: Option(String),
    subject: Option(String),
    participant_role: Option(String),
    type_: Option(String),
    issuer: Option(String),
    participant: Option(String),
    totalnet: Option(String),
    patient: Option(String),
    recipient: Option(String),
    account: Option(String),
    status: Option(String),
  )
}

pub type Library {
  Library(
    date: Option(String),
    identifier: Option(String),
    successor: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    derived_from: Option(String),
    context_type: Option(String),
    predecessor: Option(String),
    title: Option(String),
    composed_of: Option(String),
    type_: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    effective: Option(String),
    depends_on: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    topic: Option(String),
    content_type: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type Linkage {
  Linkage(item: Option(String), author: Option(String), source: Option(String))
}

pub type Listfhir {
  Listfhir(
    date: Option(String),
    identifier: Option(String),
    item: Option(String),
    empty_reason: Option(String),
    code: Option(String),
    notes: Option(String),
    subject: Option(String),
    patient: Option(String),
    source: Option(String),
    encounter: Option(String),
    title: Option(String),
    status: Option(String),
  )
}

pub type Location {
  Location(
    identifier: Option(String),
    partof: Option(String),
    address: Option(String),
    address_state: Option(String),
    operational_status: Option(String),
    type_: Option(String),
    address_postalcode: Option(String),
    address_country: Option(String),
    endpoint: Option(String),
    organization: Option(String),
    name: Option(String),
    address_use: Option(String),
    near: Option(String),
    address_city: Option(String),
    status: Option(String),
  )
}

pub type Measure {
  Measure(
    date: Option(String),
    identifier: Option(String),
    successor: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    derived_from: Option(String),
    context_type: Option(String),
    predecessor: Option(String),
    title: Option(String),
    composed_of: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    effective: Option(String),
    depends_on: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    topic: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type Measurereport {
  Measurereport(
    date: Option(String),
    identifier: Option(String),
    period: Option(String),
    measure: Option(String),
    patient: Option(String),
    subject: Option(String),
    reporter: Option(String),
    status: Option(String),
    evaluated_resource: Option(String),
  )
}

pub type Media {
  Media(
    identifier: Option(String),
    modality: Option(String),
    subject: Option(String),
    created: Option(String),
    encounter: Option(String),
    type_: Option(String),
    operator: Option(String),
    view: Option(String),
    site: Option(String),
    based_on: Option(String),
    patient: Option(String),
    device: Option(String),
    status: Option(String),
  )
}

pub type Medication {
  Medication(
    ingredient_code: Option(String),
    identifier: Option(String),
    code: Option(String),
    ingredient: Option(String),
    form: Option(String),
    lot_number: Option(String),
    expiration_date: Option(String),
    manufacturer: Option(String),
    status: Option(String),
  )
}

pub type Medicationadministration {
  Medicationadministration(
    identifier: Option(String),
    request: Option(String),
    code: Option(String),
    performer: Option(String),
    subject: Option(String),
    medication: Option(String),
    reason_given: Option(String),
    patient: Option(String),
    effective_time: Option(String),
    context: Option(String),
    reason_not_given: Option(String),
    device: Option(String),
    status: Option(String),
  )
}

pub type Medicationdispense {
  Medicationdispense(
    identifier: Option(String),
    performer: Option(String),
    code: Option(String),
    receiver: Option(String),
    subject: Option(String),
    destination: Option(String),
    medication: Option(String),
    responsibleparty: Option(String),
    type_: Option(String),
    whenhandedover: Option(String),
    whenprepared: Option(String),
    prescription: Option(String),
    patient: Option(String),
    context: Option(String),
    status: Option(String),
  )
}

pub type Medicationknowledge {
  Medicationknowledge(
    code: Option(String),
    ingredient: Option(String),
    doseform: Option(String),
    classification_type: Option(String),
    monograph_type: Option(String),
    classification: Option(String),
    manufacturer: Option(String),
    ingredient_code: Option(String),
    source_cost: Option(String),
    monograph: Option(String),
    monitoring_program_name: Option(String),
    monitoring_program_type: Option(String),
    status: Option(String),
  )
}

pub type Medicationrequest {
  Medicationrequest(
    requester: Option(String),
    date: Option(String),
    identifier: Option(String),
    intended_dispenser: Option(String),
    authoredon: Option(String),
    code: Option(String),
    subject: Option(String),
    medication: Option(String),
    encounter: Option(String),
    priority: Option(String),
    intent: Option(String),
    patient: Option(String),
    intended_performer: Option(String),
    intended_performertype: Option(String),
    category: Option(String),
    status: Option(String),
  )
}

pub type Medicationstatement {
  Medicationstatement(
    identifier: Option(String),
    effective: Option(String),
    code: Option(String),
    subject: Option(String),
    patient: Option(String),
    context: Option(String),
    medication: Option(String),
    part_of: Option(String),
    source: Option(String),
    category: Option(String),
    status: Option(String),
  )
}

pub type Medicinalproduct {
  Medicinalproduct(
    identifier: Option(String),
    name: Option(String),
    name_language: Option(String),
  )
}

pub type Medicinalproductauthorization {
  Medicinalproductauthorization(
    identifier: Option(String),
    country: Option(String),
    subject: Option(String),
    holder: Option(String),
    status: Option(String),
  )
}

pub type Medicinalproductcontraindication {
  Medicinalproductcontraindication(subject: Option(String))
}

pub type Medicinalproductindication {
  Medicinalproductindication(subject: Option(String))
}

pub type Medicinalproductingredient {
  Medicinalproductingredient
}

pub type Medicinalproductinteraction {
  Medicinalproductinteraction(subject: Option(String))
}

pub type Medicinalproductmanufactured {
  Medicinalproductmanufactured
}

pub type Medicinalproductpackaged {
  Medicinalproductpackaged(identifier: Option(String), subject: Option(String))
}

pub type Medicinalproductpharmaceutical {
  Medicinalproductpharmaceutical(
    identifier: Option(String),
    route: Option(String),
    target_species: Option(String),
  )
}

pub type Medicinalproductundesirableeffect {
  Medicinalproductundesirableeffect(subject: Option(String))
}

pub type Messagedefinition {
  Messagedefinition(
    date: Option(String),
    identifier: Option(String),
    parent: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    focus: Option(String),
    context_type: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    event: Option(String),
    category: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type Messageheader {
  Messageheader(
    code: Option(String),
    receiver: Option(String),
    author: Option(String),
    destination: Option(String),
    focus: Option(String),
    source: Option(String),
    target: Option(String),
    destination_uri: Option(String),
    source_uri: Option(String),
    sender: Option(String),
    responsible: Option(String),
    enterer: Option(String),
    response_id: Option(String),
    event: Option(String),
  )
}

pub type Molecularsequence {
  Molecularsequence(
    identifier: Option(String),
    referenceseqid_variant_coordinate: Option(String),
    chromosome: Option(String),
    window_end: Option(String),
    type_: Option(String),
    window_start: Option(String),
    variant_end: Option(String),
    chromosome_variant_coordinate: Option(String),
    patient: Option(String),
    variant_start: Option(String),
    chromosome_window_coordinate: Option(String),
    referenceseqid_window_coordinate: Option(String),
    referenceseqid: Option(String),
  )
}

pub type Namingsystem {
  Namingsystem(
    date: Option(String),
    period: Option(String),
    context_type_value: Option(String),
    kind: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    context_type: Option(String),
    type_: Option(String),
    id_type: Option(String),
    context_quantity: Option(String),
    responsible: Option(String),
    contact: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    telecom: Option(String),
    value: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type Nutritionorder {
  Nutritionorder(
    identifier: Option(String),
    datetime: Option(String),
    provider: Option(String),
    patient: Option(String),
    supplement: Option(String),
    formula: Option(String),
    instantiates_canonical: Option(String),
    instantiates_uri: Option(String),
    encounter: Option(String),
    oraldiet: Option(String),
    status: Option(String),
    additive: Option(String),
  )
}

pub type Observation {
  Observation(
    date: Option(String),
    combo_data_absent_reason: Option(String),
    code: Option(String),
    combo_code_value_quantity: Option(String),
    subject: Option(String),
    component_data_absent_reason: Option(String),
    value_concept: Option(String),
    value_date: Option(String),
    focus: Option(String),
    derived_from: Option(String),
    part_of: Option(String),
    has_member: Option(String),
    code_value_string: Option(String),
    component_code_value_quantity: Option(String),
    based_on: Option(String),
    code_value_date: Option(String),
    patient: Option(String),
    specimen: Option(String),
    component_code: Option(String),
    code_value_quantity: Option(String),
    combo_code_value_concept: Option(String),
    value_string: Option(String),
    identifier: Option(String),
    performer: Option(String),
    combo_code: Option(String),
    method: Option(String),
    value_quantity: Option(String),
    component_value_quantity: Option(String),
    data_absent_reason: Option(String),
    combo_value_quantity: Option(String),
    encounter: Option(String),
    code_value_concept: Option(String),
    component_code_value_concept: Option(String),
    component_value_concept: Option(String),
    category: Option(String),
    device: Option(String),
    combo_value_concept: Option(String),
    status: Option(String),
  )
}

pub type Observationdefinition {
  Observationdefinition
}

pub type Operationdefinition {
  Operationdefinition(
    date: Option(String),
    code: Option(String),
    instance: Option(String),
    context_type_value: Option(String),
    kind: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    context_type: Option(String),
    title: Option(String),
    type_: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    input_profile: Option(String),
    output_profile: Option(String),
    system: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
    base: Option(String),
  )
}

pub type Operationoutcome {
  Operationoutcome
}

pub type Organization {
  Organization(
    identifier: Option(String),
    partof: Option(String),
    address: Option(String),
    address_state: Option(String),
    active: Option(String),
    type_: Option(String),
    address_postalcode: Option(String),
    address_country: Option(String),
    endpoint: Option(String),
    phonetic: Option(String),
    name: Option(String),
    address_use: Option(String),
    address_city: Option(String),
  )
}

pub type Organizationaffiliation {
  Organizationaffiliation(
    date: Option(String),
    identifier: Option(String),
    specialty: Option(String),
    role: Option(String),
    active: Option(String),
    primary_organization: Option(String),
    network: Option(String),
    endpoint: Option(String),
    phone: Option(String),
    service: Option(String),
    participating_organization: Option(String),
    telecom: Option(String),
    location: Option(String),
    email: Option(String),
  )
}

pub type Patient {
  Patient(
    identifier: Option(String),
    given: Option(String),
    address: Option(String),
    birthdate: Option(String),
    deceased: Option(String),
    address_state: Option(String),
    gender: Option(String),
    general_practitioner: Option(String),
    link: Option(String),
    active: Option(String),
    language: Option(String),
    address_postalcode: Option(String),
    address_country: Option(String),
    death_date: Option(String),
    phonetic: Option(String),
    phone: Option(String),
    organization: Option(String),
    name: Option(String),
    address_use: Option(String),
    telecom: Option(String),
    family: Option(String),
    address_city: Option(String),
    email: Option(String),
  )
}

pub type Paymentnotice {
  Paymentnotice(
    identifier: Option(String),
    request: Option(String),
    provider: Option(String),
    created: Option(String),
    response: Option(String),
    payment_status: Option(String),
    status: Option(String),
  )
}

pub type Paymentreconciliation {
  Paymentreconciliation(
    identifier: Option(String),
    request: Option(String),
    disposition: Option(String),
    created: Option(String),
    payment_issuer: Option(String),
    outcome: Option(String),
    requestor: Option(String),
    status: Option(String),
  )
}

pub type Person {
  Person(
    identifier: Option(String),
    address: Option(String),
    birthdate: Option(String),
    address_state: Option(String),
    gender: Option(String),
    practitioner: Option(String),
    link: Option(String),
    relatedperson: Option(String),
    address_postalcode: Option(String),
    address_country: Option(String),
    phonetic: Option(String),
    phone: Option(String),
    patient: Option(String),
    organization: Option(String),
    name: Option(String),
    address_use: Option(String),
    telecom: Option(String),
    address_city: Option(String),
    email: Option(String),
  )
}

pub type Plandefinition {
  Plandefinition(
    date: Option(String),
    identifier: Option(String),
    successor: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    derived_from: Option(String),
    context_type: Option(String),
    predecessor: Option(String),
    title: Option(String),
    composed_of: Option(String),
    type_: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    effective: Option(String),
    depends_on: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    topic: Option(String),
    definition: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type Practitioner {
  Practitioner(
    identifier: Option(String),
    given: Option(String),
    address: Option(String),
    address_state: Option(String),
    gender: Option(String),
    active: Option(String),
    address_postalcode: Option(String),
    address_country: Option(String),
    phonetic: Option(String),
    phone: Option(String),
    name: Option(String),
    address_use: Option(String),
    telecom: Option(String),
    family: Option(String),
    address_city: Option(String),
    communication: Option(String),
    email: Option(String),
  )
}

pub type Practitionerrole {
  Practitionerrole(
    date: Option(String),
    identifier: Option(String),
    specialty: Option(String),
    role: Option(String),
    practitioner: Option(String),
    active: Option(String),
    endpoint: Option(String),
    phone: Option(String),
    service: Option(String),
    organization: Option(String),
    telecom: Option(String),
    location: Option(String),
    email: Option(String),
  )
}

pub type Procedure {
  Procedure(
    date: Option(String),
    identifier: Option(String),
    code: Option(String),
    performer: Option(String),
    subject: Option(String),
    instantiates_canonical: Option(String),
    part_of: Option(String),
    encounter: Option(String),
    reason_code: Option(String),
    based_on: Option(String),
    patient: Option(String),
    reason_reference: Option(String),
    location: Option(String),
    instantiates_uri: Option(String),
    category: Option(String),
    status: Option(String),
  )
}

pub type Provenance {
  Provenance(
    agent_type: Option(String),
    agent: Option(String),
    signature_type: Option(String),
    patient: Option(String),
    location: Option(String),
    recorded: Option(String),
    agent_role: Option(String),
    when: Option(String),
    entity: Option(String),
    target: Option(String),
  )
}

pub type Questionnaire {
  Questionnaire(
    date: Option(String),
    identifier: Option(String),
    code: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    context_type: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    effective: Option(String),
    subject_type: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    definition: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type Questionnaireresponse {
  Questionnaireresponse(
    authored: Option(String),
    identifier: Option(String),
    questionnaire: Option(String),
    based_on: Option(String),
    subject: Option(String),
    author: Option(String),
    patient: Option(String),
    part_of: Option(String),
    encounter: Option(String),
    source: Option(String),
    status: Option(String),
  )
}

pub type Relatedperson {
  Relatedperson(
    identifier: Option(String),
    address: Option(String),
    birthdate: Option(String),
    address_state: Option(String),
    gender: Option(String),
    active: Option(String),
    address_postalcode: Option(String),
    address_country: Option(String),
    phonetic: Option(String),
    phone: Option(String),
    patient: Option(String),
    name: Option(String),
    address_use: Option(String),
    telecom: Option(String),
    address_city: Option(String),
    relationship: Option(String),
    email: Option(String),
  )
}

pub type Requestgroup {
  Requestgroup(
    authored: Option(String),
    identifier: Option(String),
    code: Option(String),
    subject: Option(String),
    author: Option(String),
    instantiates_canonical: Option(String),
    encounter: Option(String),
    priority: Option(String),
    intent: Option(String),
    participant: Option(String),
    group_identifier: Option(String),
    patient: Option(String),
    instantiates_uri: Option(String),
    status: Option(String),
  )
}

pub type Researchdefinition {
  Researchdefinition(
    date: Option(String),
    identifier: Option(String),
    successor: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    derived_from: Option(String),
    context_type: Option(String),
    predecessor: Option(String),
    title: Option(String),
    composed_of: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    effective: Option(String),
    depends_on: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    topic: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type Researchelementdefinition {
  Researchelementdefinition(
    date: Option(String),
    identifier: Option(String),
    successor: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    derived_from: Option(String),
    context_type: Option(String),
    predecessor: Option(String),
    title: Option(String),
    composed_of: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    effective: Option(String),
    depends_on: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    topic: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type Researchstudy {
  Researchstudy(
    date: Option(String),
    identifier: Option(String),
    partof: Option(String),
    sponsor: Option(String),
    focus: Option(String),
    principalinvestigator: Option(String),
    title: Option(String),
    protocol: Option(String),
    site: Option(String),
    location: Option(String),
    category: Option(String),
    keyword: Option(String),
    status: Option(String),
  )
}

pub type Researchsubject {
  Researchsubject(
    date: Option(String),
    identifier: Option(String),
    study: Option(String),
    individual: Option(String),
    patient: Option(String),
    status: Option(String),
  )
}

pub type Riskassessment {
  Riskassessment(
    date: Option(String),
    identifier: Option(String),
    condition: Option(String),
    performer: Option(String),
    method: Option(String),
    subject: Option(String),
    patient: Option(String),
    probability: Option(String),
    risk: Option(String),
    encounter: Option(String),
  )
}

pub type Riskevidencesynthesis {
  Riskevidencesynthesis(
    date: Option(String),
    identifier: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    context_type: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    effective: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type Schedule {
  Schedule(
    actor: Option(String),
    date: Option(String),
    identifier: Option(String),
    specialty: Option(String),
    service_category: Option(String),
    service_type: Option(String),
    active: Option(String),
  )
}

pub type Searchparameter {
  Searchparameter(
    date: Option(String),
    code: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    derived_from: Option(String),
    context_type: Option(String),
    type_: Option(String),
    version: Option(String),
    url: Option(String),
    target: Option(String),
    context_quantity: Option(String),
    component: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
    base: Option(String),
  )
}

pub type Servicerequest {
  Servicerequest(
    authored: Option(String),
    requester: Option(String),
    identifier: Option(String),
    code: Option(String),
    performer: Option(String),
    requisition: Option(String),
    replaces: Option(String),
    subject: Option(String),
    instantiates_canonical: Option(String),
    encounter: Option(String),
    occurrence: Option(String),
    priority: Option(String),
    intent: Option(String),
    performer_type: Option(String),
    based_on: Option(String),
    patient: Option(String),
    specimen: Option(String),
    instantiates_uri: Option(String),
    body_site: Option(String),
    category: Option(String),
    status: Option(String),
  )
}

pub type Slot {
  Slot(
    schedule: Option(String),
    identifier: Option(String),
    specialty: Option(String),
    service_category: Option(String),
    appointment_type: Option(String),
    service_type: Option(String),
    start: Option(String),
    status: Option(String),
  )
}

pub type Specimen {
  Specimen(
    container: Option(String),
    identifier: Option(String),
    parent: Option(String),
    container_id: Option(String),
    bodysite: Option(String),
    subject: Option(String),
    patient: Option(String),
    collected: Option(String),
    accession: Option(String),
    type_: Option(String),
    collector: Option(String),
    status: Option(String),
  )
}

pub type Specimendefinition {
  Specimendefinition(
    container: Option(String),
    identifier: Option(String),
    type_: Option(String),
  )
}

pub type Structuredefinition {
  Structuredefinition(
    date: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    context_type: Option(String),
    experimental: Option(String),
    title: Option(String),
    type_: Option(String),
    context_quantity: Option(String),
    path: Option(String),
    context: Option(String),
    base_path: Option(String),
    keyword: Option(String),
    context_type_quantity: Option(String),
    identifier: Option(String),
    valueset: Option(String),
    kind: Option(String),
    abstract: Option(String),
    version: Option(String),
    url: Option(String),
    ext_context: Option(String),
    name: Option(String),
    publisher: Option(String),
    derivation: Option(String),
    status: Option(String),
    base: Option(String),
  )
}

pub type Structuremap {
  Structuremap(
    date: Option(String),
    identifier: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    context_type: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type Subscription {
  Subscription(
    payload: Option(String),
    criteria: Option(String),
    contact: Option(String),
    type_: Option(String),
    url: Option(String),
    status: Option(String),
  )
}

pub type Substance {
  Substance(
    identifier: Option(String),
    container_identifier: Option(String),
    code: Option(String),
    quantity: Option(String),
    substance_reference: Option(String),
    expiry: Option(String),
    category: Option(String),
    status: Option(String),
  )
}

pub type Substancenucleicacid {
  Substancenucleicacid
}

pub type Substancepolymer {
  Substancepolymer
}

pub type Substanceprotein {
  Substanceprotein
}

pub type Substancereferenceinformation {
  Substancereferenceinformation
}

pub type Substancesourcematerial {
  Substancesourcematerial
}

pub type Substancespecification {
  Substancespecification(code: Option(String))
}

pub type Supplydelivery {
  Supplydelivery(
    identifier: Option(String),
    receiver: Option(String),
    patient: Option(String),
    supplier: Option(String),
    status: Option(String),
  )
}

pub type Supplyrequest {
  Supplyrequest(
    requester: Option(String),
    date: Option(String),
    identifier: Option(String),
    subject: Option(String),
    supplier: Option(String),
    category: Option(String),
    status: Option(String),
  )
}

pub type Task {
  Task(
    owner: Option(String),
    requester: Option(String),
    identifier: Option(String),
    business_status: Option(String),
    period: Option(String),
    code: Option(String),
    performer: Option(String),
    subject: Option(String),
    focus: Option(String),
    part_of: Option(String),
    encounter: Option(String),
    priority: Option(String),
    authored_on: Option(String),
    intent: Option(String),
    group_identifier: Option(String),
    based_on: Option(String),
    patient: Option(String),
    modified: Option(String),
    status: Option(String),
  )
}

pub type Terminologycapabilities {
  Terminologycapabilities(
    date: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    context_type: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type Testreport {
  Testreport(
    result: Option(String),
    identifier: Option(String),
    tester: Option(String),
    testscript: Option(String),
    issued: Option(String),
    participant: Option(String),
  )
}

pub type Testscript {
  Testscript(
    date: Option(String),
    identifier: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    testscript_capability: Option(String),
    context_type: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    context_quantity: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type Valueset {
  Valueset(
    date: Option(String),
    identifier: Option(String),
    code: Option(String),
    context_type_value: Option(String),
    jurisdiction: Option(String),
    description: Option(String),
    context_type: Option(String),
    title: Option(String),
    version: Option(String),
    url: Option(String),
    expansion: Option(String),
    reference: Option(String),
    context_quantity: Option(String),
    name: Option(String),
    context: Option(String),
    publisher: Option(String),
    context_type_quantity: Option(String),
    status: Option(String),
  )
}

pub type Verificationresult {
  Verificationresult(target: Option(String))
}

pub type Visionprescription {
  Visionprescription(
    prescriber: Option(String),
    identifier: Option(String),
    patient: Option(String),
    datewritten: Option(String),
    encounter: Option(String),
    status: Option(String),
  )
}

pub fn account_new() {
  Account(None, None, None, None, None, None, None, None)
}

pub fn activitydefinition_new() {
  Activitydefinition(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn adverseevent_new() {
  Adverseevent(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn allergyintolerance_new() {
  Allergyintolerance(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn appointment_new() {
  Appointment(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn appointmentresponse_new() {
  Appointmentresponse(None, None, None, None, None, None, None)
}

pub fn auditevent_new() {
  Auditevent(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn basic_new() {
  Basic(None, None, None, None, None, None)
}

pub fn binary_new() {
  Binary
}

pub fn biologicallyderivedproduct_new() {
  Biologicallyderivedproduct
}

pub fn bodystructure_new() {
  Bodystructure(None, None, None, None)
}

pub fn bundle_new() {
  Bundle(None, None, None, None, None)
}

pub fn capabilitystatement_new() {
  Capabilitystatement(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn careplan_new() {
  Careplan(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn careteam_new() {
  Careteam(None, None, None, None, None, None, None, None)
}

pub fn catalogentry_new() {
  Catalogentry
}

pub fn chargeitem_new() {
  Chargeitem(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn chargeitemdefinition_new() {
  Chargeitemdefinition(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn claim_new() {
  Claim(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn claimresponse_new() {
  Claimresponse(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn clinicalimpression_new() {
  Clinicalimpression(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn codesystem_new() {
  Codesystem(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn communication_new() {
  Communication(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn communicationrequest_new() {
  Communicationrequest(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn compartmentdefinition_new() {
  Compartmentdefinition(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn composition_new() {
  Composition(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn conceptmap_new() {
  Conceptmap(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn condition_new() {
  Condition(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn consent_new() {
  Consent(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn contract_new() {
  Contract(None, None, None, None, None, None, None, None, None, None)
}

pub fn coverage_new() {
  Coverage(None, None, None, None, None, None, None, None, None, None, None)
}

pub fn coverageeligibilityrequest_new() {
  Coverageeligibilityrequest(None, None, None, None, None, None, None)
}

pub fn coverageeligibilityresponse_new() {
  Coverageeligibilityresponse(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn detectedissue_new() {
  Detectedissue(None, None, None, None, None, None)
}

pub fn device_new() {
  Device(None, None, None, None, None, None, None, None, None, None, None, None)
}

pub fn devicedefinition_new() {
  Devicedefinition(None, None, None)
}

pub fn devicemetric_new() {
  Devicemetric(None, None, None, None, None)
}

pub fn devicerequest_new() {
  Devicerequest(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn deviceusestatement_new() {
  Deviceusestatement(None, None, None, None)
}

pub fn diagnosticreport_new() {
  Diagnosticreport(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn documentmanifest_new() {
  Documentmanifest(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn documentreference_new() {
  Documentreference(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn effectevidencesynthesis_new() {
  Effectevidencesynthesis(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn encounter_new() {
  Encounter(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn endpoint_new() {
  Endpoint(None, None, None, None, None, None)
}

pub fn enrollmentrequest_new() {
  Enrollmentrequest(None, None, None, None)
}

pub fn enrollmentresponse_new() {
  Enrollmentresponse(None, None, None)
}

pub fn episodeofcare_new() {
  Episodeofcare(None, None, None, None, None, None, None, None, None)
}

pub fn eventdefinition_new() {
  Eventdefinition(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn evidence_new() {
  Evidence(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn evidencevariable_new() {
  Evidencevariable(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn examplescenario_new() {
  Examplescenario(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn explanationofbenefit_new() {
  Explanationofbenefit(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn familymemberhistory_new() {
  Familymemberhistory(None, None, None, None, None, None, None, None, None)
}

pub fn flag_new() {
  Flag(None, None, None, None, None, None)
}

pub fn goal_new() {
  Goal(None, None, None, None, None, None, None, None)
}

pub fn graphdefinition_new() {
  Graphdefinition(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn group_new() {
  Group(None, None, None, None, None, None, None, None, None, None)
}

pub fn guidanceresponse_new() {
  Guidanceresponse(None, None, None, None)
}

pub fn healthcareservice_new() {
  Healthcareservice(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn imagingstudy_new() {
  Imagingstudy(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn immunization_new() {
  Immunization(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn immunizationevaluation_new() {
  Immunizationevaluation(None, None, None, None, None, None, None)
}

pub fn immunizationrecommendation_new() {
  Immunizationrecommendation(None, None, None, None, None, None, None, None)
}

pub fn implementationguide_new() {
  Implementationguide(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn insuranceplan_new() {
  Insuranceplan(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn invoice_new() {
  Invoice(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn library_new() {
  Library(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn linkage_new() {
  Linkage(None, None, None)
}

pub fn listfhir_new() {
  Listfhir(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn location_new() {
  Location(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn measure_new() {
  Measure(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn measurereport_new() {
  Measurereport(None, None, None, None, None, None, None, None, None)
}

pub fn media_new() {
  Media(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn medication_new() {
  Medication(None, None, None, None, None, None, None, None, None)
}

pub fn medicationadministration_new() {
  Medicationadministration(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn medicationdispense_new() {
  Medicationdispense(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn medicationknowledge_new() {
  Medicationknowledge(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn medicationrequest_new() {
  Medicationrequest(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn medicationstatement_new() {
  Medicationstatement(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn medicinalproduct_new() {
  Medicinalproduct(None, None, None)
}

pub fn medicinalproductauthorization_new() {
  Medicinalproductauthorization(None, None, None, None, None)
}

pub fn medicinalproductcontraindication_new() {
  Medicinalproductcontraindication(None)
}

pub fn medicinalproductindication_new() {
  Medicinalproductindication(None)
}

pub fn medicinalproductingredient_new() {
  Medicinalproductingredient
}

pub fn medicinalproductinteraction_new() {
  Medicinalproductinteraction(None)
}

pub fn medicinalproductmanufactured_new() {
  Medicinalproductmanufactured
}

pub fn medicinalproductpackaged_new() {
  Medicinalproductpackaged(None, None)
}

pub fn medicinalproductpharmaceutical_new() {
  Medicinalproductpharmaceutical(None, None, None)
}

pub fn medicinalproductundesirableeffect_new() {
  Medicinalproductundesirableeffect(None)
}

pub fn messagedefinition_new() {
  Messagedefinition(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn messageheader_new() {
  Messageheader(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn molecularsequence_new() {
  Molecularsequence(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn namingsystem_new() {
  Namingsystem(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn nutritionorder_new() {
  Nutritionorder(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn observation_new() {
  Observation(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn observationdefinition_new() {
  Observationdefinition
}

pub fn operationdefinition_new() {
  Operationdefinition(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn operationoutcome_new() {
  Operationoutcome
}

pub fn organization_new() {
  Organization(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn organizationaffiliation_new() {
  Organizationaffiliation(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn patient_new() {
  Patient(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn paymentnotice_new() {
  Paymentnotice(None, None, None, None, None, None, None)
}

pub fn paymentreconciliation_new() {
  Paymentreconciliation(None, None, None, None, None, None, None, None)
}

pub fn person_new() {
  Person(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn plandefinition_new() {
  Plandefinition(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn practitioner_new() {
  Practitioner(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn practitionerrole_new() {
  Practitionerrole(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn procedure_new() {
  Procedure(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn provenance_new() {
  Provenance(None, None, None, None, None, None, None, None, None, None)
}

pub fn questionnaire_new() {
  Questionnaire(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn questionnaireresponse_new() {
  Questionnaireresponse(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn relatedperson_new() {
  Relatedperson(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn requestgroup_new() {
  Requestgroup(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn researchdefinition_new() {
  Researchdefinition(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn researchelementdefinition_new() {
  Researchelementdefinition(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn researchstudy_new() {
  Researchstudy(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn researchsubject_new() {
  Researchsubject(None, None, None, None, None, None)
}

pub fn riskassessment_new() {
  Riskassessment(None, None, None, None, None, None, None, None, None, None)
}

pub fn riskevidencesynthesis_new() {
  Riskevidencesynthesis(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn schedule_new() {
  Schedule(None, None, None, None, None, None, None)
}

pub fn searchparameter_new() {
  Searchparameter(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn servicerequest_new() {
  Servicerequest(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn slot_new() {
  Slot(None, None, None, None, None, None, None, None)
}

pub fn specimen_new() {
  Specimen(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn specimendefinition_new() {
  Specimendefinition(None, None, None)
}

pub fn structuredefinition_new() {
  Structuredefinition(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn structuremap_new() {
  Structuremap(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn subscription_new() {
  Subscription(None, None, None, None, None, None)
}

pub fn substance_new() {
  Substance(None, None, None, None, None, None, None, None)
}

pub fn substancenucleicacid_new() {
  Substancenucleicacid
}

pub fn substancepolymer_new() {
  Substancepolymer
}

pub fn substanceprotein_new() {
  Substanceprotein
}

pub fn substancereferenceinformation_new() {
  Substancereferenceinformation
}

pub fn substancesourcematerial_new() {
  Substancesourcematerial
}

pub fn substancespecification_new() {
  Substancespecification(None)
}

pub fn supplydelivery_new() {
  Supplydelivery(None, None, None, None, None)
}

pub fn supplyrequest_new() {
  Supplyrequest(None, None, None, None, None, None, None)
}

pub fn task_new() {
  Task(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn terminologycapabilities_new() {
  Terminologycapabilities(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn testreport_new() {
  Testreport(None, None, None, None, None, None)
}

pub fn testscript_new() {
  Testscript(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn valueset_new() {
  Valueset(
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
  )
}

pub fn verificationresult_new() {
  Verificationresult(None)
}

pub fn visionprescription_new() {
  Visionprescription(None, None, None, None, None, None)
}
