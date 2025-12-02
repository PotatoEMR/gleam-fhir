import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Contactdetail, type Extension, type Meta,
  type Narrative, type Usagecontext,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/GraphDefinition#resource
pub type Graphdefinition {
  Graphdefinition(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    version: Option(String),
    name: String,
    status: String,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    start: String,
    profile: Option(String),
    link: List(GraphdefinitionLink),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/GraphDefinition#resource
pub type GraphdefinitionLink {
  GraphdefinitionLink(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    path: Option(String),
    slice_name: Option(String),
    min: Option(Int),
    max: Option(String),
    description: Option(String),
    target: List(GraphdefinitionLinkTarget),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/GraphDefinition#resource
pub type GraphdefinitionLinkTarget {
  GraphdefinitionLinkTarget(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: String,
    params: Option(String),
    profile: Option(String),
    compartment: List(GraphdefinitionLinkTargetCompartment),
    link: List(Nil),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/GraphDefinition#resource
pub type GraphdefinitionLinkTargetCompartment {
  GraphdefinitionLinkTargetCompartment(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    use_: String,
    code: String,
    rule: String,
    expression: Option(String),
    description: Option(String),
  )
}
