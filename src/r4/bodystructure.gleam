import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Attachment, type Codeableconcept, type Extension, type Identifier,
  type Meta, type Narrative, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/BodyStructure#resource
pub type Bodystructure {
  Bodystructure(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    active: Option(Bool),
    morphology: Option(Codeableconcept),
    location: Option(Codeableconcept),
    location_qualifier: List(Codeableconcept),
    description: Option(String),
    image: List(Attachment),
    patient: Reference,
  )
}
