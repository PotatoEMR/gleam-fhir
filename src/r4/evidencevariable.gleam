import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Annotation, type Codeableconcept, type Contactdetail, type Duration,
  type Extension, type Identifier, type Meta, type Narrative, type Period,
  type Relatedartifact, type Usagecontext,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/EvidenceVariable#resource
pub type Evidencevariable {
  Evidencevariable(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    name: Option(String),
    title: Option(String),
    short_title: Option(String),
    subtitle: Option(String),
    status: String,
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    note: List(Annotation),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    copyright: Option(String),
    approval_date: Option(String),
    last_review_date: Option(String),
    effective_period: Option(Period),
    topic: List(Codeableconcept),
    author: List(Contactdetail),
    editor: List(Contactdetail),
    reviewer: List(Contactdetail),
    endorser: List(Contactdetail),
    related_artifact: List(Relatedartifact),
    type_: Option(String),
    characteristic: List(EvidencevariableCharacteristic),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/EvidenceVariable#resource
pub type EvidencevariableCharacteristic {
  EvidencevariableCharacteristic(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    definition: Nil,
    usage_context: List(Usagecontext),
    exclude: Option(Bool),
    participant_effective: Option(Nil),
    time_from_start: Option(Duration),
    group_measure: Option(String),
  )
}
