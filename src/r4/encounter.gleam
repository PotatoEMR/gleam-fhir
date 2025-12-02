import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Coding, type Duration, type Extension,
  type Identifier, type Meta, type Narrative, type Period, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/Encounter#resource
pub type Encounter {
  Encounter(
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
    status_history: List(EncounterStatushistory),
    class: Coding,
    class_history: List(EncounterClasshistory),
    type_: List(Codeableconcept),
    service_type: Option(Codeableconcept),
    priority: Option(Codeableconcept),
    subject: Option(Reference),
    episode_of_care: List(Reference),
    based_on: List(Reference),
    participant: List(EncounterParticipant),
    appointment: List(Reference),
    period: Option(Period),
    length: Option(Duration),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    diagnosis: List(EncounterDiagnosis),
    account: List(Reference),
    hospitalization: Option(EncounterHospitalization),
    location: List(EncounterLocation),
    service_provider: Option(Reference),
    part_of: Option(Reference),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Encounter#resource
pub type EncounterStatushistory {
  EncounterStatushistory(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    status: String,
    period: Period,
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Encounter#resource
pub type EncounterClasshistory {
  EncounterClasshistory(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    class: Coding,
    period: Period,
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Encounter#resource
pub type EncounterParticipant {
  EncounterParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: List(Codeableconcept),
    period: Option(Period),
    individual: Option(Reference),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Encounter#resource
pub type EncounterDiagnosis {
  EncounterDiagnosis(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    condition: Reference,
    use_: Option(Codeableconcept),
    rank: Option(Int),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Encounter#resource
pub type EncounterHospitalization {
  EncounterHospitalization(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    pre_admission_identifier: Option(Identifier),
    origin: Option(Reference),
    admit_source: Option(Codeableconcept),
    re_admission: Option(Codeableconcept),
    diet_preference: List(Codeableconcept),
    special_courtesy: List(Codeableconcept),
    special_arrangement: List(Codeableconcept),
    destination: Option(Reference),
    discharge_disposition: Option(Codeableconcept),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Encounter#resource
pub type EncounterLocation {
  EncounterLocation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    location: Reference,
    status: Option(String),
    physical_type: Option(Codeableconcept),
    period: Option(Period),
  )
}
