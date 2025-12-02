import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Annotation, type Codeableconcept, type Expression, type Extension,
  type Identifier, type Meta, type Narrative, type Reference,
  type Relatedartifact,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/RequestGroup#resource
pub type Requestgroup {
  Requestgroup(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    instantiates_canonical: List(String),
    instantiates_uri: List(String),
    based_on: List(Reference),
    replaces: List(Reference),
    group_identifier: Option(Identifier),
    status: String,
    intent: String,
    priority: Option(String),
    code: Option(Codeableconcept),
    subject: Option(Reference),
    encounter: Option(Reference),
    authored_on: Option(String),
    author: Option(Reference),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    note: List(Annotation),
    action: List(RequestgroupAction),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/RequestGroup#resource
pub type RequestgroupAction {
  RequestgroupAction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    prefix: Option(String),
    title: Option(String),
    description: Option(String),
    text_equivalent: Option(String),
    priority: Option(String),
    code: List(Codeableconcept),
    documentation: List(Relatedartifact),
    condition: List(RequestgroupActionCondition),
    related_action: List(RequestgroupActionRelatedaction),
    timing: Option(Nil),
    participant: List(Reference),
    type_: Option(Codeableconcept),
    grouping_behavior: Option(String),
    selection_behavior: Option(String),
    required_behavior: Option(String),
    precheck_behavior: Option(String),
    cardinality_behavior: Option(String),
    resource: Option(Reference),
    action: List(Nil),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/RequestGroup#resource
pub type RequestgroupActionCondition {
  RequestgroupActionCondition(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    kind: String,
    expression: Option(Expression),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/RequestGroup#resource
pub type RequestgroupActionRelatedaction {
  RequestgroupActionRelatedaction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    action_id: String,
    relationship: String,
    offset: Option(Nil),
  )
}
