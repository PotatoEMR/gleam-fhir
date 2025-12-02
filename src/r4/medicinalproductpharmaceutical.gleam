import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Duration, type Extension, type Identifier,
  type Meta, type Narrative, type Quantity, type Ratio, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductPharmaceutical#resource
pub type Medicinalproductpharmaceutical {
  Medicinalproductpharmaceutical(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    administrable_dose_form: Codeableconcept,
    unit_of_presentation: Option(Codeableconcept),
    ingredient: List(Reference),
    device: List(Reference),
    characteristics: List(MedicinalproductpharmaceuticalCharacteristics),
    route_of_administration: List(
      MedicinalproductpharmaceuticalRouteofadministration,
    ),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductPharmaceutical#resource
pub type MedicinalproductpharmaceuticalCharacteristics {
  MedicinalproductpharmaceuticalCharacteristics(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
    status: Option(Codeableconcept),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductPharmaceutical#resource
pub type MedicinalproductpharmaceuticalRouteofadministration {
  MedicinalproductpharmaceuticalRouteofadministration(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
    first_dose: Option(Quantity),
    max_single_dose: Option(Quantity),
    max_dose_per_day: Option(Quantity),
    max_dose_per_treatment_period: Option(Ratio),
    max_treatment_period: Option(Duration),
    target_species: List(
      MedicinalproductpharmaceuticalRouteofadministrationTargetspecies,
    ),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductPharmaceutical#resource
pub type MedicinalproductpharmaceuticalRouteofadministrationTargetspecies {
  MedicinalproductpharmaceuticalRouteofadministrationTargetspecies(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
    withdrawal_period: List(
      MedicinalproductpharmaceuticalRouteofadministrationTargetspeciesWithdrawalperiod,
    ),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductPharmaceutical#resource
pub type MedicinalproductpharmaceuticalRouteofadministrationTargetspeciesWithdrawalperiod {
  MedicinalproductpharmaceuticalRouteofadministrationTargetspeciesWithdrawalperiod(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    tissue: Codeableconcept,
    value: Quantity,
    supporting_information: Option(String),
  )
}
