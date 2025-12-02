import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Extension, type Meta, type Narrative,
  type Population, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductUndesirableEffect#resource
pub type Medicinalproductundesirableeffect {
  Medicinalproductundesirableeffect(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    subject: List(Reference),
    symptom_condition_effect: Option(Codeableconcept),
    classification: Option(Codeableconcept),
    frequency_of_occurrence: Option(Codeableconcept),
    population: List(Population),
  )
}
