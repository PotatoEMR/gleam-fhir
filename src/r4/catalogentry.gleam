import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Extension, type Identifier, type Meta,
  type Narrative, type Period, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/CatalogEntry#resource
pub type Catalogentry {
  Catalogentry(
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
    orderable: Bool,
    referenced_item: Reference,
    additional_identifier: List(Identifier),
    classification: List(Codeableconcept),
    status: Option(String),
    validity_period: Option(Period),
    valid_to: Option(String),
    last_updated: Option(String),
    additional_characteristic: List(Codeableconcept),
    additional_classification: List(Codeableconcept),
    related_entry: List(CatalogentryRelatedentry),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/CatalogEntry#resource
pub type CatalogentryRelatedentry {
  CatalogentryRelatedentry(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    relationtype: String,
    item: Reference,
  )
}
