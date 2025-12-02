import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Extension, type Identifier, type Meta,
  type Narrative, type Quantity, type Ratio,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/Substance#resource
pub type Substance {
  Substance(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: Option(String),
    category: List(Codeableconcept),
    code: Codeableconcept,
    description: Option(String),
    instance: List(SubstanceInstance),
    ingredient: List(SubstanceIngredient),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Substance#resource
pub type SubstanceInstance {
  SubstanceInstance(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Option(Identifier),
    expiry: Option(String),
    quantity: Option(Quantity),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Substance#resource
pub type SubstanceIngredient {
  SubstanceIngredient(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    quantity: Option(Ratio),
    substance: Nil,
  )
}
