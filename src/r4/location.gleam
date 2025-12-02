import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Address, type Codeableconcept, type Coding, type Contactpoint,
  type Extension, type Identifier, type Meta, type Narrative, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/Location#resource
pub type Location {
  Location(
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
    operational_status: Option(Coding),
    name: Option(String),
    alias: List(String),
    description: Option(String),
    mode: Option(String),
    type_: List(Codeableconcept),
    telecom: List(Contactpoint),
    address: Option(Address),
    physical_type: Option(Codeableconcept),
    position: Option(LocationPosition),
    managing_organization: Option(Reference),
    part_of: Option(Reference),
    hours_of_operation: List(LocationHoursofoperation),
    availability_exceptions: Option(String),
    endpoint: List(Reference),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Location#resource
pub type LocationPosition {
  LocationPosition(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    longitude: Float,
    latitude: Float,
    altitude: Option(Float),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Location#resource
pub type LocationHoursofoperation {
  LocationHoursofoperation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    days_of_week: List(String),
    all_day: Option(Bool),
    opening_time: Option(String),
    closing_time: Option(String),
  )
}
