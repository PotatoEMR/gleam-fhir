import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Contactpoint, type Extension, type Identifier,
  type Meta, type Narrative, type Period, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/PractitionerRole#resource
pub type Practitionerrole {
  Practitionerrole(
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
    period: Option(Period),
    practitioner: Option(Reference),
    organization: Option(Reference),
    code: List(Codeableconcept),
    specialty: List(Codeableconcept),
    location: List(Reference),
    healthcare_service: List(Reference),
    telecom: List(Contactpoint),
    available_time: List(PractitionerroleAvailabletime),
    not_available: List(PractitionerroleNotavailable),
    availability_exceptions: Option(String),
    endpoint: List(Reference),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/PractitionerRole#resource
pub type PractitionerroleAvailabletime {
  PractitionerroleAvailabletime(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    days_of_week: List(String),
    all_day: Option(Bool),
    available_start_time: Option(String),
    available_end_time: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/PractitionerRole#resource
pub type PractitionerroleNotavailable {
  PractitionerroleNotavailable(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: String,
    during: Option(Period),
  )
}
