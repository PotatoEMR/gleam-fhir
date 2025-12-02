import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Annotation, type Codeableconcept, type Extension, type Identifier,
  type Meta, type Narrative, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/ServiceRequest#resource
pub type Servicerequest {
  Servicerequest(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    instantiates_canonical: List(String),
    instantiates_uri: List(String),
    based_on: List(Reference),
    replaces: List(Reference),
    requisition: Option(Identifier),
    status: String,
    intent: String,
    category: List(Codeableconcept),
    priority: Option(String),
    do_not_perform: Option(Bool),
    code: Option(Codeableconcept),
    order_detail: List(Codeableconcept),
    quantity: Option(Nil),
    subject: Reference,
    encounter: Option(Reference),
    occurrence: Option(Nil),
    as_needed: Option(Nil),
    authored_on: Option(String),
    requester: Option(Reference),
    performer_type: Option(Codeableconcept),
    performer: List(Reference),
    location_code: List(Codeableconcept),
    location_reference: List(Reference),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    insurance: List(Reference),
    supporting_info: List(Reference),
    specimen: List(Reference),
    body_site: List(Codeableconcept),
    note: List(Annotation),
    patient_instruction: Option(String),
    relevant_history: List(Reference),
  )
}
