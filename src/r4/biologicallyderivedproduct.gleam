import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Extension, type Identifier, type Meta,
  type Narrative, type Period, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/BiologicallyDerivedProduct#resource
pub type Biologicallyderivedproduct {
  Biologicallyderivedproduct(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    product_category: Option(String),
    product_code: Option(Codeableconcept),
    status: Option(String),
    request: List(Reference),
    quantity: Option(Int),
    parent: List(Reference),
    collection: Option(BiologicallyderivedproductCollection),
    processing: List(BiologicallyderivedproductProcessing),
    manipulation: Option(BiologicallyderivedproductManipulation),
    storage: List(BiologicallyderivedproductStorage),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/BiologicallyDerivedProduct#resource
pub type BiologicallyderivedproductCollection {
  BiologicallyderivedproductCollection(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    collector: Option(Reference),
    source: Option(Reference),
    collected: Option(Nil),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/BiologicallyDerivedProduct#resource
pub type BiologicallyderivedproductProcessing {
  BiologicallyderivedproductProcessing(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    procedure: Option(Codeableconcept),
    additive: Option(Reference),
    time: Option(Nil),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/BiologicallyDerivedProduct#resource
pub type BiologicallyderivedproductManipulation {
  BiologicallyderivedproductManipulation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    time: Option(Nil),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/BiologicallyDerivedProduct#resource
pub type BiologicallyderivedproductStorage {
  BiologicallyderivedproductStorage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    temperature: Option(Float),
    scale: Option(String),
    duration: Option(Period),
  )
}
