import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Address, type Attachment, type Contactpoint, type Extension,
  type Humanname, type Identifier, type Meta, type Narrative, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/Person#resource
pub type Person {
  Person(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    name: List(Humanname),
    telecom: List(Contactpoint),
    gender: Option(String),
    birth_date: Option(String),
    address: List(Address),
    photo: Option(Attachment),
    managing_organization: Option(Reference),
    active: Option(Bool),
    link: List(PersonLink),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Person#resource
pub type PersonLink {
  PersonLink(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    target: Reference,
    assurance: Option(String),
  )
}
