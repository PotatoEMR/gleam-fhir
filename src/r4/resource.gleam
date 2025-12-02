import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{type Meta}

//http://hl7.org/fhir/r4/StructureDefinition/Resource#resource
pub type Resource {
  Resource(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
  )
}
