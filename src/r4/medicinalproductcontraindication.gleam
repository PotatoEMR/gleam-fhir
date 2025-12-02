import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Extension, type Meta, type Narrative,
  type Population, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductContraindication#resource
pub type Medicinalproductcontraindication {
  Medicinalproductcontraindication(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    subject: List(Reference),
    disease: Option(Codeableconcept),
    disease_status: Option(Codeableconcept),
    comorbidity: List(Codeableconcept),
    therapeutic_indication: List(Reference),
    other_therapy: List(MedicinalproductcontraindicationOthertherapy),
    population: List(Population),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductContraindication#resource
pub type MedicinalproductcontraindicationOthertherapy {
  MedicinalproductcontraindicationOthertherapy(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    therapy_relationship_type: Codeableconcept,
    medication: Nil,
  )
}
