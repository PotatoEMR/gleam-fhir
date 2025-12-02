import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Extension, type Meta, type Narrative,
  type Prodcharacteristic, type Quantity, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductManufactured#resource
pub type Medicinalproductmanufactured {
  Medicinalproductmanufactured(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    manufactured_dose_form: Codeableconcept,
    unit_of_presentation: Option(Codeableconcept),
    quantity: Quantity,
    manufacturer: List(Reference),
    ingredient: List(Reference),
    physical_characteristics: Option(Prodcharacteristic),
    other_characteristics: List(Codeableconcept),
  )
}
