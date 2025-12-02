import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{type Extension, type Meta}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/Parameters#resource
pub type Parameters {
  Parameters(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    parameter: List(ParametersParameter),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Parameters#resource
pub type ParametersParameter {
  ParametersParameter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    value: Option(Nil),
    resource: Option(Resource),
    part: List(Nil),
  )
}
