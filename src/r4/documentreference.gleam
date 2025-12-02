import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Attachment, type Codeableconcept, type Coding, type Extension,
  type Identifier, type Meta, type Narrative, type Period, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/DocumentReference#resource
pub type Documentreference {
  Documentreference(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    master_identifier: Option(Identifier),
    identifier: List(Identifier),
    status: String,
    doc_status: Option(String),
    type_: Option(Codeableconcept),
    category: List(Codeableconcept),
    subject: Option(Reference),
    date: Option(String),
    author: List(Reference),
    authenticator: Option(Reference),
    custodian: Option(Reference),
    relates_to: List(DocumentreferenceRelatesto),
    description: Option(String),
    security_label: List(Codeableconcept),
    content: List(DocumentreferenceContent),
    context: Option(DocumentreferenceContext),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/DocumentReference#resource
pub type DocumentreferenceRelatesto {
  DocumentreferenceRelatesto(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    target: Reference,
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/DocumentReference#resource
pub type DocumentreferenceContent {
  DocumentreferenceContent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    attachment: Attachment,
    format: Option(Coding),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/DocumentReference#resource
pub type DocumentreferenceContext {
  DocumentreferenceContext(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    encounter: List(Reference),
    event: List(Codeableconcept),
    period: Option(Period),
    facility_type: Option(Codeableconcept),
    practice_setting: Option(Codeableconcept),
    source_patient_info: Option(Reference),
    related: List(Reference),
  )
}
