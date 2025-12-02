import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Annotation, type Codeableconcept, type Contactdetail, type Extension,
  type Identifier, type Meta, type Narrative, type Period, type Reference,
  type Relatedartifact, type Usagecontext,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/EffectEvidenceSynthesis#resource
pub type Effectevidencesynthesis {
  Effectevidencesynthesis(
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
    exposure: Reference,
    exposure_alternative: Reference,
    outcome: Reference,
    sample_size: Option(EffectevidencesynthesisSamplesize),
    results_by_exposure: List(EffectevidencesynthesisResultsbyexposure),
    effect_estimate: List(EffectevidencesynthesisEffectestimate),
    certainty: List(EffectevidencesynthesisCertainty),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/EffectEvidenceSynthesis#resource
pub type EffectevidencesynthesisSamplesize {
  EffectevidencesynthesisSamplesize(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    number_of_studies: Option(Int),
    number_of_participants: Option(Int),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/EffectEvidenceSynthesis#resource
pub type EffectevidencesynthesisResultsbyexposure {
  EffectevidencesynthesisResultsbyexposure(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    exposure_state: Option(String),
    variant_state: Option(Codeableconcept),
    risk_evidence_synthesis: Reference,
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/EffectEvidenceSynthesis#resource
pub type EffectevidencesynthesisEffectestimate {
  EffectevidencesynthesisEffectestimate(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    type_: Option(Codeableconcept),
    variant_state: Option(Codeableconcept),
    value: Option(Float),
    unit_of_measure: Option(Codeableconcept),
    precision_estimate: List(
      EffectevidencesynthesisEffectestimatePrecisionestimate,
    ),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/EffectEvidenceSynthesis#resource
pub type EffectevidencesynthesisEffectestimatePrecisionestimate {
  EffectevidencesynthesisEffectestimatePrecisionestimate(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    level: Option(Float),
    from: Option(Float),
    to: Option(Float),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/EffectEvidenceSynthesis#resource
pub type EffectevidencesynthesisCertainty {
  EffectevidencesynthesisCertainty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    rating: List(Codeableconcept),
    note: List(Annotation),
    certainty_subcomponent: List(
      EffectevidencesynthesisCertaintyCertaintysubcomponent,
    ),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/EffectEvidenceSynthesis#resource
pub type EffectevidencesynthesisCertaintyCertaintysubcomponent {
  EffectevidencesynthesisCertaintyCertaintysubcomponent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    rating: List(Codeableconcept),
    note: List(Annotation),
  )
}
