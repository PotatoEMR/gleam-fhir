import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Annotation, type Codeableconcept, type Extension, type Identifier,
  type Meta, type Narrative, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/ClinicalImpression#resource
pub type Clinicalimpression {
  Clinicalimpression(
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
    code: Option(Codeableconcept),
    description: Option(String),
    subject: Reference,
    encounter: Option(Reference),
    effective: Option(Nil),
    date: Option(String),
    assessor: Option(Reference),
    previous: Option(Reference),
    problem: List(Reference),
    investigation: List(ClinicalimpressionInvestigation),
    protocol: List(String),
    summary: Option(String),
    finding: List(ClinicalimpressionFinding),
    prognosis_codeable_concept: List(Codeableconcept),
    prognosis_reference: List(Reference),
    supporting_info: List(Reference),
    note: List(Annotation),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/ClinicalImpression#resource
pub type ClinicalimpressionInvestigation {
  ClinicalimpressionInvestigation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
    item: List(Reference),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/ClinicalImpression#resource
pub type ClinicalimpressionFinding {
  ClinicalimpressionFinding(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item_codeable_concept: Option(Codeableconcept),
    item_reference: Option(Reference),
    basis: Option(String),
  )
}
