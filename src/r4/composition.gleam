import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Extension, type Identifier, type Meta,
  type Narrative, type Period, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/Composition#resource
pub type Composition {
  Composition(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Option(Identifier),
    status: String,
    type_: Codeableconcept,
    category: List(Codeableconcept),
    subject: Option(Reference),
    encounter: Option(Reference),
    date: String,
    author: List(Reference),
    title: String,
    confidentiality: Option(String),
    attester: List(CompositionAttester),
    custodian: Option(Reference),
    relates_to: List(CompositionRelatesto),
    event: List(CompositionEvent),
    section: List(CompositionSection),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Composition#resource
pub type CompositionAttester {
  CompositionAttester(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    mode: String,
    time: Option(String),
    party: Option(Reference),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Composition#resource
pub type CompositionRelatesto {
  CompositionRelatesto(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    target: Nil,
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Composition#resource
pub type CompositionEvent {
  CompositionEvent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: List(Codeableconcept),
    period: Option(Period),
    detail: List(Reference),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Composition#resource
pub type CompositionSection {
  CompositionSection(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    title: Option(String),
    code: Option(Codeableconcept),
    author: List(Reference),
    focus: Option(Reference),
    text: Option(Narrative),
    mode: Option(String),
    ordered_by: Option(Codeableconcept),
    entry: List(Reference),
    empty_reason: Option(Codeableconcept),
    section: List(Nil),
  )
}
