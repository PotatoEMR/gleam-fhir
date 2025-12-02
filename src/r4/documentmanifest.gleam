import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Extension, type Identifier, type Meta,
  type Narrative, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/DocumentManifest#resource
pub type Documentmanifest {
  Documentmanifest(
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
    type_: Option(Codeableconcept),
    subject: Option(Reference),
    created: Option(String),
    author: List(Reference),
    recipient: List(Reference),
    source: Option(String),
    description: Option(String),
    content: List(Reference),
    related: List(DocumentmanifestRelated),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/DocumentManifest#resource
pub type DocumentmanifestRelated {
  DocumentmanifestRelated(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Option(Identifier),
    ref: Option(Reference),
  )
}
