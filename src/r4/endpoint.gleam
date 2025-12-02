import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Coding, type Contactpoint, type Extension,
  type Identifier, type Meta, type Narrative, type Period, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/Endpoint#resource
pub type Endpoint {
  Endpoint(
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
    connection_type: Coding,
    name: Option(String),
    managing_organization: Option(Reference),
    contact: List(Contactpoint),
    period: Option(Period),
    payload_type: List(Codeableconcept),
    payload_mime_type: List(String),
    address: String,
    header: List(String),
  )
}
