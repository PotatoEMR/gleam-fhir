import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Contactdetail, type Extension, type Meta,
  type Narrative, type Period, type Usagecontext,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/NamingSystem#resource
pub type Namingsystem {
  Namingsystem(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    status: String,
    kind: String,
    date: String,
    publisher: Option(String),
    contact: List(Contactdetail),
    responsible: Option(String),
    type_: Option(Codeableconcept),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    usage: Option(String),
    unique_id: List(NamingsystemUniqueid),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/NamingSystem#resource
pub type NamingsystemUniqueid {
  NamingsystemUniqueid(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: String,
    value: String,
    preferred: Option(Bool),
    comment: Option(String),
    period: Option(Period),
  )
}
