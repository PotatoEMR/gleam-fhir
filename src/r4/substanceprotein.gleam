import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Attachment, type Codeableconcept, type Extension, type Identifier,
  type Meta, type Narrative,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceProtein#resource
pub type Substanceprotein {
  Substanceprotein(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence_type: Option(Codeableconcept),
    number_of_subunits: Option(Int),
    disulfide_linkage: List(String),
    subunit: List(SubstanceproteinSubunit),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceProtein#resource
pub type SubstanceproteinSubunit {
  SubstanceproteinSubunit(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    subunit: Option(Int),
    sequence: Option(String),
    length: Option(Int),
    sequence_attachment: Option(Attachment),
    n_terminal_modification_id: Option(Identifier),
    n_terminal_modification: Option(String),
    c_terminal_modification_id: Option(Identifier),
    c_terminal_modification: Option(String),
  )
}
