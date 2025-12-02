import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Annotation, type Codeableconcept, type Dosage, type Duration,
  type Extension, type Identifier, type Meta, type Narrative, type Period,
  type Quantity, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/MedicationRequest#resource
pub type Medicationrequest {
  Medicationrequest(
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
    status_reason: Option(Codeableconcept),
    intent: String,
    category: List(Codeableconcept),
    priority: Option(String),
    do_not_perform: Option(Bool),
    reported: Option(Nil),
    medication: Nil,
    subject: Reference,
    encounter: Option(Reference),
    supporting_information: List(Reference),
    authored_on: Option(String),
    requester: Option(Reference),
    performer: Option(Reference),
    performer_type: Option(Codeableconcept),
    recorder: Option(Reference),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    instantiates_canonical: List(String),
    instantiates_uri: List(String),
    based_on: List(Reference),
    group_identifier: Option(Identifier),
    course_of_therapy_type: Option(Codeableconcept),
    insurance: List(Reference),
    note: List(Annotation),
    dosage_instruction: List(Dosage),
    dispense_request: Option(MedicationrequestDispenserequest),
    substitution: Option(MedicationrequestSubstitution),
    prior_prescription: Option(Reference),
    detected_issue: List(Reference),
    event_history: List(Reference),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicationRequest#resource
pub type MedicationrequestDispenserequest {
  MedicationrequestDispenserequest(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    initial_fill: Option(MedicationrequestDispenserequestInitialfill),
    dispense_interval: Option(Duration),
    validity_period: Option(Period),
    number_of_repeats_allowed: Option(Int),
    quantity: Option(Quantity),
    expected_supply_duration: Option(Duration),
    performer: Option(Reference),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicationRequest#resource
pub type MedicationrequestDispenserequestInitialfill {
  MedicationrequestDispenserequestInitialfill(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    quantity: Option(Quantity),
    duration: Option(Duration),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicationRequest#resource
pub type MedicationrequestSubstitution {
  MedicationrequestSubstitution(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    allowed: Nil,
    reason: Option(Codeableconcept),
  )
}
