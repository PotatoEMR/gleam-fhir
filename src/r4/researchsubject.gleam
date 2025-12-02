import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Extension, type Identifier, type Meta, type Narrative, type Period,
  type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/ResearchSubject#resource
pub type Researchsubject {
  Researchsubject(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    period: Option(Period),
    study: Reference,
    individual: Reference,
    assigned_arm: Option(String),
    actual_arm: Option(String),
    consent: Option(Reference),
  )
}
