import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Annotation, type Attachment, type Codeableconcept, type Extension,
  type Identifier, type Meta, type Narrative, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/Media#resource
pub type Media {
  Media(
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
    part_of: List(Reference),
    status: String,
    type_: Option(Codeableconcept),
    modality: Option(Codeableconcept),
    view: Option(Codeableconcept),
    subject: Option(Reference),
    encounter: Option(Reference),
    created: Option(Nil),
    issued: Option(String),
    operator: Option(Reference),
    reason_code: List(Codeableconcept),
    body_site: Option(Codeableconcept),
    device_name: Option(String),
    device: Option(Reference),
    height: Option(Int),
    width: Option(Int),
    frames: Option(Int),
    duration: Option(Float),
    content: Attachment,
    note: List(Annotation),
  )
}
