import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Coding, type Extension, type Meta, type Narrative,
  type Period, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/AuditEvent#resource
pub type Auditevent {
  Auditevent(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Coding,
    subtype: List(Coding),
    action: Option(String),
    period: Option(Period),
    recorded: String,
    outcome: Option(String),
    outcome_desc: Option(String),
    purpose_of_event: List(Codeableconcept),
    agent: List(AuditeventAgent),
    source: AuditeventSource,
    entity: List(AuditeventEntity),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/AuditEvent#resource
pub type AuditeventAgent {
  AuditeventAgent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    role: List(Codeableconcept),
    who: Option(Reference),
    alt_id: Option(String),
    name: Option(String),
    requestor: Bool,
    location: Option(Reference),
    policy: List(String),
    media: Option(Coding),
    network: Option(AuditeventAgentNetwork),
    purpose_of_use: List(Codeableconcept),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/AuditEvent#resource
pub type AuditeventAgentNetwork {
  AuditeventAgentNetwork(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    address: Option(String),
    type_: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/AuditEvent#resource
pub type AuditeventSource {
  AuditeventSource(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    site: Option(String),
    observer: Reference,
    type_: List(Coding),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/AuditEvent#resource
pub type AuditeventEntity {
  AuditeventEntity(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    what: Option(Reference),
    type_: Option(Coding),
    role: Option(Coding),
    lifecycle: Option(Coding),
    security_label: List(Coding),
    name: Option(String),
    description: Option(String),
    query: Option(String),
    detail: List(AuditeventEntityDetail),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/AuditEvent#resource
pub type AuditeventEntityDetail {
  AuditeventEntityDetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: String,
    value: Nil,
  )
}
