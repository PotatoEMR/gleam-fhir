import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Extension, type Identifier, type Meta,
  type Narrative, type Period, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/Appointment#resource
pub type Appointment {
  Appointment(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    cancelation_reason: Option(Codeableconcept),
    service_category: List(Codeableconcept),
    service_type: List(Codeableconcept),
    specialty: List(Codeableconcept),
    appointment_type: Option(Codeableconcept),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    priority: Option(Int),
    description: Option(String),
    supporting_information: List(Reference),
    start: Option(String),
    end: Option(String),
    minutes_duration: Option(Int),
    slot: List(Reference),
    created: Option(String),
    comment: Option(String),
    patient_instruction: Option(String),
    based_on: List(Reference),
    participant: List(AppointmentParticipant),
    requested_period: List(Period),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Appointment#resource
pub type AppointmentParticipant {
  AppointmentParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: List(Codeableconcept),
    actor: Option(Reference),
    required: Option(String),
    status: String,
    period: Option(Period),
  )
}
