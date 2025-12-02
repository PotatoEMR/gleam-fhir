import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Address, type Attachment, type Codeableconcept, type Contactpoint,
  type Extension, type Humanname, type Identifier, type Meta, type Narrative,
  type Period, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/Patient#resource
pub type Patient {
  Patient(
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
    name: List(Humanname),
    telecom: List(Contactpoint),
    gender: Option(String),
    birth_date: Option(String),
    deceased: Option(Nil),
    address: List(Address),
    marital_status: Option(Codeableconcept),
    multiple_birth: Option(Nil),
    photo: List(Attachment),
    contact: List(PatientContact),
    communication: List(PatientCommunication),
    general_practitioner: List(Reference),
    managing_organization: Option(Reference),
    link: List(PatientLink),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Patient#resource
pub type PatientContact {
  PatientContact(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    relationship: List(Codeableconcept),
    name: Option(Humanname),
    telecom: List(Contactpoint),
    address: Option(Address),
    gender: Option(String),
    organization: Option(Reference),
    period: Option(Period),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Patient#resource
pub type PatientCommunication {
  PatientCommunication(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    language: Codeableconcept,
    preferred: Option(Bool),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Patient#resource
pub type PatientLink {
  PatientLink(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    other: Reference,
    type_: String,
  )
}
