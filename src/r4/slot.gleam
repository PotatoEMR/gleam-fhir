import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Extension, type Identifier, type Meta,
  type Narrative, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/Slot#resource
pub type Slot {
  Slot(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    service_category: List(Codeableconcept),
    service_type: List(Codeableconcept),
    specialty: List(Codeableconcept),
    appointment_type: Option(Codeableconcept),
    schedule: Reference,
    status: String,
    start: String,
    end: String,
    overbooked: Option(Bool),
    comment: Option(String),
  )
}
