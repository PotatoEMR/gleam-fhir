import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Annotation, type Codeableconcept, type Contactpoint, type Extension,
  type Identifier, type Meta, type Narrative, type Period, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/CareTeam#resource
pub type Careteam {
  Careteam(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: Option(String),
    category: List(Codeableconcept),
    name: Option(String),
    subject: Option(Reference),
    encounter: Option(Reference),
    period: Option(Period),
    participant: List(CareteamParticipant),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    managing_organization: List(Reference),
    telecom: List(Contactpoint),
    note: List(Annotation),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/CareTeam#resource
pub type CareteamParticipant {
  CareteamParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    role: List(Codeableconcept),
    member: Option(Reference),
    on_behalf_of: Option(Reference),
    period: Option(Period),
  )
}
