import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Extension, type Identifier, type Meta,
  type Narrative, type Ratio, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductIngredient#resource
pub type Medicinalproductingredient {
  Medicinalproductingredient(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Option(Identifier),
    role: Codeableconcept,
    allergenic_indicator: Option(Bool),
    manufacturer: List(Reference),
    specified_substance: List(MedicinalproductingredientSpecifiedsubstance),
    substance: Option(MedicinalproductingredientSubstance),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductIngredient#resource
pub type MedicinalproductingredientSpecifiedsubstance {
  MedicinalproductingredientSpecifiedsubstance(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
    group: Codeableconcept,
    confidentiality: Option(Codeableconcept),
    strength: List(MedicinalproductingredientSpecifiedsubstanceStrength),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductIngredient#resource
pub type MedicinalproductingredientSpecifiedsubstanceStrength {
  MedicinalproductingredientSpecifiedsubstanceStrength(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    presentation: Ratio,
    presentation_low_limit: Option(Ratio),
    concentration: Option(Ratio),
    concentration_low_limit: Option(Ratio),
    measurement_point: Option(String),
    country: List(Codeableconcept),
    reference_strength: List(
      MedicinalproductingredientSpecifiedsubstanceStrengthReferencestrength,
    ),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductIngredient#resource
pub type MedicinalproductingredientSpecifiedsubstanceStrengthReferencestrength {
  MedicinalproductingredientSpecifiedsubstanceStrengthReferencestrength(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    substance: Option(Codeableconcept),
    strength: Ratio,
    strength_low_limit: Option(Ratio),
    measurement_point: Option(String),
    country: List(Codeableconcept),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductIngredient#resource
pub type MedicinalproductingredientSubstance {
  MedicinalproductingredientSubstance(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
    strength: List(Nil),
  )
}
