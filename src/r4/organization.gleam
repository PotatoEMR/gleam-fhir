import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Address, type Codeableconcept, type Contactpoint, type Extension,
  type Humanname, type Identifier, type Meta, type Narrative, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/Organization#resource
pub type Organization {
  Organization(
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
    type_: List(Codeableconcept),
    name: Option(String),
    alias: List(String),
    telecom: List(Contactpoint),
    address: List(Address),
    part_of: Option(Reference),
    contact: List(OrganizationContact),
    endpoint: List(Reference),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Organization#resource
pub type OrganizationContact {
  OrganizationContact(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    purpose: Option(Codeableconcept),
    name: Option(Humanname),
    telecom: List(Contactpoint),
    address: Option(Address),
  )
}
