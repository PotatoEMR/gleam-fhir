import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Annotation, type Codeableconcept, type Extension, type Identifier,
  type Meta, type Narrative, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/Goal#resource
pub type Goal {
  Goal(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    lifecycle_status: String,
    achievement_status: Option(Codeableconcept),
    category: List(Codeableconcept),
    priority: Option(Codeableconcept),
    description: Codeableconcept,
    subject: Reference,
    start: Option(Nil),
    target: List(GoalTarget),
    status_date: Option(String),
    status_reason: Option(String),
    expressed_by: Option(Reference),
    addresses: List(Reference),
    note: List(Annotation),
    outcome_code: List(Codeableconcept),
    outcome_reference: List(Reference),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Goal#resource
pub type GoalTarget {
  GoalTarget(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    measure: Option(Codeableconcept),
    detail: Option(Nil),
    due: Option(Nil),
  )
}
