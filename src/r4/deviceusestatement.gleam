import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Annotation, type Codeableconcept, type Extension, type Identifier,
  type Meta, type Narrative, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/DeviceUseStatement#resource
pub type Deviceusestatement {
  Deviceusestatement(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    based_on: List(Reference),
    status: String,
    subject: Reference,
    derived_from: List(Reference),
    timing: Option(Nil),
    recorded_on: Option(String),
    source: Option(Reference),
    device: Reference,
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    body_site: Option(Codeableconcept),
    note: List(Annotation),
  )
}
