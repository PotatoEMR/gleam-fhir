import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Annotation, type Codeableconcept, type Contactdetail, type Extension,
  type Identifier, type Meta, type Narrative, type Period, type Reference,
  type Relatedartifact, type Usagecontext,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/RiskEvidenceSynthesis#resource
pub type Riskevidencesynthesis {
  Riskevidencesynthesis(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    name: Option(String),
    title: Option(String),
    status: String,
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    note: List(Annotation),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    copyright: Option(String),
    approval_date: Option(String),
    last_review_date: Option(String),
    effective_period: Option(Period),
    topic: List(Codeableconcept),
    author: List(Contactdetail),
    editor: List(Contactdetail),
    reviewer: List(Contactdetail),
    endorser: List(Contactdetail),
    related_artifact: List(Relatedartifact),
    synthesis_type: Option(Codeableconcept),
    study_type: Option(Codeableconcept),
    population: Reference,
    exposure: Option(Reference),
    outcome: Reference,
    sample_size: Option(RiskevidencesynthesisSamplesize),
    risk_estimate: Option(RiskevidencesynthesisRiskestimate),
    certainty: List(RiskevidencesynthesisCertainty),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/RiskEvidenceSynthesis#resource
pub type RiskevidencesynthesisSamplesize {
  RiskevidencesynthesisSamplesize(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    number_of_studies: Option(Int),
    number_of_participants: Option(Int),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/RiskEvidenceSynthesis#resource
pub type RiskevidencesynthesisRiskestimate {
  RiskevidencesynthesisRiskestimate(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    type_: Option(Codeableconcept),
    value: Option(Float),
    unit_of_measure: Option(Codeableconcept),
    denominator_count: Option(Int),
    numerator_count: Option(Int),
    precision_estimate: List(RiskevidencesynthesisRiskestimatePrecisionestimate),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/RiskEvidenceSynthesis#resource
pub type RiskevidencesynthesisRiskestimatePrecisionestimate {
  RiskevidencesynthesisRiskestimatePrecisionestimate(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    level: Option(Float),
    from: Option(Float),
    to: Option(Float),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/RiskEvidenceSynthesis#resource
pub type RiskevidencesynthesisCertainty {
  RiskevidencesynthesisCertainty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    rating: List(Codeableconcept),
    note: List(Annotation),
    certainty_subcomponent: List(
      RiskevidencesynthesisCertaintyCertaintysubcomponent,
    ),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/RiskEvidenceSynthesis#resource
pub type RiskevidencesynthesisCertaintyCertaintysubcomponent {
  RiskevidencesynthesisCertaintyCertaintysubcomponent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    rating: List(Codeableconcept),
    note: List(Annotation),
  )
}
