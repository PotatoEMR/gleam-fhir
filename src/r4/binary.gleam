import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{type Meta, type Reference}

//http://hl7.org/fhir/r4/StructureDefinition/Binary#resource
pub type Binary {
  Binary(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    content_type: String,
    security_context: Option(Reference),
    data: Option(String),
  )
}
