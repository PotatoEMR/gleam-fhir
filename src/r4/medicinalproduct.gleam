import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Coding, type Extension, type Identifier,
  type Marketingstatus, type Meta, type Narrative, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProduct#resource
pub type Medicinalproduct {
  Medicinalproduct(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    type_: Option(Codeableconcept),
    domain: Option(Coding),
    combined_pharmaceutical_dose_form: Option(Codeableconcept),
    legal_status_of_supply: Option(Codeableconcept),
    additional_monitoring_indicator: Option(Codeableconcept),
    special_measures: List(String),
    paediatric_use_indicator: Option(Codeableconcept),
    product_classification: List(Codeableconcept),
    marketing_status: List(Marketingstatus),
    pharmaceutical_product: List(Reference),
    packaged_medicinal_product: List(Reference),
    attached_document: List(Reference),
    master_file: List(Reference),
    contact: List(Reference),
    clinical_trial: List(Reference),
    name: List(MedicinalproductName),
    cross_reference: List(Identifier),
    manufacturing_business_operation: List(
      MedicinalproductManufacturingbusinessoperation,
    ),
    special_designation: List(MedicinalproductSpecialdesignation),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProduct#resource
pub type MedicinalproductName {
  MedicinalproductName(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    product_name: String,
    name_part: List(MedicinalproductNameNamepart),
    country_language: List(MedicinalproductNameCountrylanguage),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProduct#resource
pub type MedicinalproductNameNamepart {
  MedicinalproductNameNamepart(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    part: String,
    type_: Coding,
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProduct#resource
pub type MedicinalproductNameCountrylanguage {
  MedicinalproductNameCountrylanguage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    country: Codeableconcept,
    jurisdiction: Option(Codeableconcept),
    language: Codeableconcept,
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProduct#resource
pub type MedicinalproductManufacturingbusinessoperation {
  MedicinalproductManufacturingbusinessoperation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    operation_type: Option(Codeableconcept),
    authorisation_reference_number: Option(Identifier),
    effective_date: Option(String),
    confidentiality_indicator: Option(Codeableconcept),
    manufacturer: List(Reference),
    regulator: Option(Reference),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProduct#resource
pub type MedicinalproductSpecialdesignation {
  MedicinalproductSpecialdesignation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    type_: Option(Codeableconcept),
    intended_use: Option(Codeableconcept),
    indication: Option(Nil),
    status: Option(Codeableconcept),
    date: Option(String),
    species: Option(Codeableconcept),
  )
}
