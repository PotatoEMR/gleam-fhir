import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Contactdetail, type Duration, type Extension,
  type Identifier, type Meta, type Narrative, type Period, type Relatedartifact,
  type Usagecontext,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/ResearchElementDefinition#resource
pub type Researchelementdefinition {
  Researchelementdefinition(
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
    experimental: Option(Bool),
    subject: Option(Nil),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    comment: List(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    usage: Option(String),
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
    library: List(String),
    type_: String,
    variable_type: Option(String),
    characteristic: List(ResearchelementdefinitionCharacteristic),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/ResearchElementDefinition#resource
pub type ResearchelementdefinitionCharacteristic {
  ResearchelementdefinitionCharacteristic(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    definition: Nil,
    usage_context: List(Usagecontext),
    exclude: Option(Bool),
    unit_of_measure: Option(Codeableconcept),
    study_effective_description: Option(String),
    study_effective: Option(Nil),
    study_effective_time_from_start: Option(Duration),
    study_effective_group_measure: Option(String),
    participant_effective_description: Option(String),
    participant_effective: Option(Nil),
    participant_effective_time_from_start: Option(Duration),
    participant_effective_group_measure: Option(String),
  )
}
