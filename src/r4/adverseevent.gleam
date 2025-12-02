import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Extension, type Identifier, type Meta,
  type Narrative, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/AdverseEvent#resource
pub type Adverseevent {
  Adverseevent(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Option(Identifier),
    actuality: String,
    category: List(Codeableconcept),
    event: Option(Codeableconcept),
    subject: Reference,
    encounter: Option(Reference),
    date: Option(String),
    detected: Option(String),
    recorded_date: Option(String),
    resulting_condition: List(Reference),
    location: Option(Reference),
    seriousness: Option(Codeableconcept),
    severity: Option(Codeableconcept),
    outcome: Option(Codeableconcept),
    recorder: Option(Reference),
    contributor: List(Reference),
    suspect_entity: List(AdverseeventSuspectentity),
    subject_medical_history: List(Reference),
    reference_document: List(Reference),
    study: List(Reference),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/AdverseEvent#resource
pub type AdverseeventSuspectentity {
  AdverseeventSuspectentity(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    instance: Reference,
    causality: List(AdverseeventSuspectentityCausality),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/AdverseEvent#resource
pub type AdverseeventSuspectentityCausality {
  AdverseeventSuspectentityCausality(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    assessment: Option(Codeableconcept),
    product_relatedness: Option(String),
    author: Option(Reference),
    method: Option(Codeableconcept),
  )
}
