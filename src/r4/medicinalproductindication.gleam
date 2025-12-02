import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Extension, type Meta, type Narrative,
  type Population, type Quantity, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductIndication#resource
pub type Medicinalproductindication {
  Medicinalproductindication(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    subject: List(Reference),
    disease_symptom_procedure: Option(Codeableconcept),
    disease_status: Option(Codeableconcept),
    comorbidity: List(Codeableconcept),
    intended_effect: Option(Codeableconcept),
    duration: Option(Quantity),
    other_therapy: List(MedicinalproductindicationOthertherapy),
    undesirable_effect: List(Reference),
    population: List(Population),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductIndication#resource
pub type MedicinalproductindicationOthertherapy {
  MedicinalproductindicationOthertherapy(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    therapy_relationship_type: Codeableconcept,
    medication: Nil,
  )
}
