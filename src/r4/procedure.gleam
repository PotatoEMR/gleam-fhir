import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Annotation, type Codeableconcept, type Extension, type Identifier,
  type Meta, type Narrative, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/Procedure#resource
pub type Procedure {
  Procedure(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    instantiates_canonical: List(String),
    instantiates_uri: List(String),
    based_on: List(Reference),
    part_of: List(Reference),
    status: String,
    status_reason: Option(Codeableconcept),
    category: Option(Codeableconcept),
    code: Option(Codeableconcept),
    subject: Reference,
    encounter: Option(Reference),
    performed: Option(Nil),
    recorder: Option(Reference),
    asserter: Option(Reference),
    performer: List(ProcedurePerformer),
    location: Option(Reference),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    body_site: List(Codeableconcept),
    outcome: Option(Codeableconcept),
    report: List(Reference),
    complication: List(Codeableconcept),
    complication_detail: List(Reference),
    follow_up: List(Codeableconcept),
    note: List(Annotation),
    focal_device: List(ProcedureFocaldevice),
    used_reference: List(Reference),
    used_code: List(Codeableconcept),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Procedure#resource
pub type ProcedurePerformer {
  ProcedurePerformer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    function: Option(Codeableconcept),
    actor: Reference,
    on_behalf_of: Option(Reference),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Procedure#resource
pub type ProcedureFocaldevice {
  ProcedureFocaldevice(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    action: Option(Codeableconcept),
    manipulated: Reference,
  )
}
