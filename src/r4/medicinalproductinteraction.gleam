import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Extension, type Meta, type Narrative,
  type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductInteraction#resource
pub type Medicinalproductinteraction {
  Medicinalproductinteraction(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    subject: List(Reference),
    description: Option(String),
    interactant: List(MedicinalproductinteractionInteractant),
    type_: Option(Codeableconcept),
    effect: Option(Codeableconcept),
    incidence: Option(Codeableconcept),
    management: Option(Codeableconcept),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductInteraction#resource
pub type MedicinalproductinteractionInteractant {
  MedicinalproductinteractionInteractant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item: Nil,
  )
}
