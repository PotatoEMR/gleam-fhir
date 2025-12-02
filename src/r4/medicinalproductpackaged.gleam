import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Extension, type Identifier, type Marketingstatus,
  type Meta, type Narrative, type Prodcharacteristic, type Productshelflife,
  type Quantity, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductPackaged#resource
pub type Medicinalproductpackaged {
  Medicinalproductpackaged(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    subject: List(Reference),
    description: Option(String),
    legal_status_of_supply: Option(Codeableconcept),
    marketing_status: List(Marketingstatus),
    marketing_authorization: Option(Reference),
    manufacturer: List(Reference),
    batch_identifier: List(MedicinalproductpackagedBatchidentifier),
    package_item: List(MedicinalproductpackagedPackageitem),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductPackaged#resource
pub type MedicinalproductpackagedBatchidentifier {
  MedicinalproductpackagedBatchidentifier(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    outer_packaging: Identifier,
    immediate_packaging: Option(Identifier),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductPackaged#resource
pub type MedicinalproductpackagedPackageitem {
  MedicinalproductpackagedPackageitem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    type_: Codeableconcept,
    quantity: Quantity,
    material: List(Codeableconcept),
    alternate_material: List(Codeableconcept),
    device: List(Reference),
    manufactured_item: List(Reference),
    package_item: List(Nil),
    physical_characteristics: Option(Prodcharacteristic),
    other_characteristics: List(Codeableconcept),
    shelf_life_storage: List(Productshelflife),
    manufacturer: List(Reference),
  )
}
