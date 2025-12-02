import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Contactdetail, type Extension, type Meta,
  type Narrative, type Usagecontext,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/SearchParameter#resource
pub type Searchparameter {
  Searchparameter(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: String,
    version: Option(String),
    name: String,
    derived_from: Option(String),
    status: String,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: String,
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    code: String,
    base: List(String),
    type_: String,
    expression: Option(String),
    xpath: Option(String),
    xpath_usage: Option(String),
    target: List(String),
    multiple_or: Option(Bool),
    multiple_and: Option(Bool),
    comparator: List(String),
    modifier: List(String),
    chain: List(String),
    component: List(SearchparameterComponent),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SearchParameter#resource
pub type SearchparameterComponent {
  SearchparameterComponent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    definition: String,
    expression: String,
  )
}
