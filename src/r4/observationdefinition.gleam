import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Extension, type Identifier, type Meta,
  type Narrative, type Range, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/ObservationDefinition#resource
pub type Observationdefinition {
  Observationdefinition(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    category: List(Codeableconcept),
    code: Codeableconcept,
    identifier: List(Identifier),
    permitted_data_type: List(String),
    multiple_results_allowed: Option(Bool),
    method: Option(Codeableconcept),
    preferred_report_name: Option(String),
    quantitative_details: Option(ObservationdefinitionQuantitativedetails),
    qualified_interval: List(ObservationdefinitionQualifiedinterval),
    valid_coded_value_set: Option(Reference),
    normal_coded_value_set: Option(Reference),
    abnormal_coded_value_set: Option(Reference),
    critical_coded_value_set: Option(Reference),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/ObservationDefinition#resource
pub type ObservationdefinitionQuantitativedetails {
  ObservationdefinitionQuantitativedetails(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    customary_unit: Option(Codeableconcept),
    unit: Option(Codeableconcept),
    conversion_factor: Option(Float),
    decimal_precision: Option(Int),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/ObservationDefinition#resource
pub type ObservationdefinitionQualifiedinterval {
  ObservationdefinitionQualifiedinterval(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    category: Option(String),
    range: Option(Range),
    context: Option(Codeableconcept),
    applies_to: List(Codeableconcept),
    gender: Option(String),
    age: Option(Range),
    gestational_age: Option(Range),
    condition: Option(String),
  )
}
