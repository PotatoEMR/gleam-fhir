import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Extension, type Meta, type Narrative,
  type Reference, type Signature,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/Provenance#resource
pub type Provenance {
  Provenance(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    target: List(Reference),
    occurred: Option(Nil),
    recorded: String,
    policy: List(String),
    location: Option(Reference),
    reason: List(Codeableconcept),
    activity: Option(Codeableconcept),
    agent: List(ProvenanceAgent),
    entity: List(ProvenanceEntity),
    signature: List(Signature),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Provenance#resource
pub type ProvenanceAgent {
  ProvenanceAgent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    role: List(Codeableconcept),
    who: Reference,
    on_behalf_of: Option(Reference),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Provenance#resource
pub type ProvenanceEntity {
  ProvenanceEntity(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    role: String,
    what: Reference,
    agent: List(Nil),
  )
}
