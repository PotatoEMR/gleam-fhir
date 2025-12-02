import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Extension, type Identifier, type Meta,
  type Narrative, type Period, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductAuthorization#resource
pub type Medicinalproductauthorization {
  Medicinalproductauthorization(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    subject: Option(Reference),
    country: List(Codeableconcept),
    jurisdiction: List(Codeableconcept),
    status: Option(Codeableconcept),
    status_date: Option(String),
    restore_date: Option(String),
    validity_period: Option(Period),
    data_exclusivity_period: Option(Period),
    date_of_first_authorization: Option(String),
    international_birth_date: Option(String),
    legal_basis: Option(Codeableconcept),
    jurisdictional_authorization: List(
      MedicinalproductauthorizationJurisdictionalauthorization,
    ),
    holder: Option(Reference),
    regulator: Option(Reference),
    procedure: Option(MedicinalproductauthorizationProcedure),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductAuthorization#resource
pub type MedicinalproductauthorizationJurisdictionalauthorization {
  MedicinalproductauthorizationJurisdictionalauthorization(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    country: Option(Codeableconcept),
    jurisdiction: List(Codeableconcept),
    legal_status_of_supply: Option(Codeableconcept),
    validity_period: Option(Period),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductAuthorization#resource
pub type MedicinalproductauthorizationProcedure {
  MedicinalproductauthorizationProcedure(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Option(Identifier),
    type_: Codeableconcept,
    date: Option(Nil),
    application: List(Nil),
  )
}
