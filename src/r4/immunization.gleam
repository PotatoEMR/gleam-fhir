import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Annotation, type Codeableconcept, type Extension, type Identifier,
  type Meta, type Narrative, type Quantity, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/Immunization#resource
pub type Immunization {
  Immunization(
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
    vaccine_code: Codeableconcept,
    patient: Reference,
    encounter: Option(Reference),
    occurrence: Nil,
    recorded: Option(String),
    primary_source: Option(Bool),
    report_origin: Option(Codeableconcept),
    location: Option(Reference),
    manufacturer: Option(Reference),
    lot_number: Option(String),
    expiration_date: Option(String),
    site: Option(Codeableconcept),
    route: Option(Codeableconcept),
    dose_quantity: Option(Quantity),
    performer: List(ImmunizationPerformer),
    note: List(Annotation),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    is_subpotent: Option(Bool),
    subpotent_reason: List(Codeableconcept),
    education: List(ImmunizationEducation),
    program_eligibility: List(Codeableconcept),
    funding_source: Option(Codeableconcept),
    reaction: List(ImmunizationReaction),
    protocol_applied: List(ImmunizationProtocolapplied),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Immunization#resource
pub type ImmunizationPerformer {
  ImmunizationPerformer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    function: Option(Codeableconcept),
    actor: Reference,
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Immunization#resource
pub type ImmunizationEducation {
  ImmunizationEducation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    document_type: Option(String),
    reference: Option(String),
    publication_date: Option(String),
    presentation_date: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Immunization#resource
pub type ImmunizationReaction {
  ImmunizationReaction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    date: Option(String),
    detail: Option(Reference),
    reported: Option(Bool),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Immunization#resource
pub type ImmunizationProtocolapplied {
  ImmunizationProtocolapplied(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    series: Option(String),
    authority: Option(Reference),
    target_disease: List(Codeableconcept),
    dose_number: Nil,
    series_doses: Option(Nil),
  )
}
