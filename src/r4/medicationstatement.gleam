import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Annotation, type Codeableconcept, type Dosage, type Extension,
  type Identifier, type Meta, type Narrative, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/MedicationStatement#resource
pub type Medicationstatement {
  Medicationstatement(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    based_on: List(Reference),
    part_of: List(Reference),
    status: String,
    status_reason: List(Codeableconcept),
    category: Option(Codeableconcept),
    medication: Nil,
    subject: Reference,
    context: Option(Reference),
    effective: Option(Nil),
    date_asserted: Option(String),
    information_source: Option(Reference),
    derived_from: List(Reference),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    note: List(Annotation),
    dosage: List(Dosage),
  )
}
