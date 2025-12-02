import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Annotation, type Codeableconcept, type Extension, type Identifier,
  type Meta, type Narrative, type Period, type Quantity, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/CarePlan#resource
pub type Careplan {
  Careplan(
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
    part_of: List(Reference),
    status: String,
    intent: String,
    category: List(Codeableconcept),
    title: Option(String),
    description: Option(String),
    subject: Reference,
    encounter: Option(Reference),
    period: Option(Period),
    created: Option(String),
    author: Option(Reference),
    contributor: List(Reference),
    care_team: List(Reference),
    addresses: List(Reference),
    supporting_info: List(Reference),
    goal: List(Reference),
    activity: List(CareplanActivity),
    note: List(Annotation),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/CarePlan#resource
pub type CareplanActivity {
  CareplanActivity(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    outcome_codeable_concept: List(Codeableconcept),
    outcome_reference: List(Reference),
    progress: List(Annotation),
    reference: Option(Reference),
    detail: Option(CareplanActivityDetail),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/CarePlan#resource
pub type CareplanActivityDetail {
  CareplanActivityDetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    kind: Option(String),
    instantiates_canonical: List(String),
    instantiates_uri: List(String),
    code: Option(Codeableconcept),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    goal: List(Reference),
    status: String,
    status_reason: Option(Codeableconcept),
    do_not_perform: Option(Bool),
    scheduled: Option(Nil),
    location: Option(Reference),
    performer: List(Reference),
    product: Option(Nil),
    daily_amount: Option(Quantity),
    quantity: Option(Quantity),
    description: Option(String),
  )
}
