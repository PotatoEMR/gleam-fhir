import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{type Extension, type Meta, type Narrative}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/DomainResource#resource
pub type Domainresource {
  Domainresource(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
  )
}
