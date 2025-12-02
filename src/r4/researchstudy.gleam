import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Annotation, type Codeableconcept, type Contactdetail, type Extension,
  type Identifier, type Meta, type Narrative, type Period, type Reference,
  type Relatedartifact,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/ResearchStudy#resource
pub type Researchstudy {
  Researchstudy(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    title: Option(String),
    protocol: List(Reference),
    part_of: List(Reference),
    status: String,
    primary_purpose_type: Option(Codeableconcept),
    phase: Option(Codeableconcept),
    category: List(Codeableconcept),
    focus: List(Codeableconcept),
    condition: List(Codeableconcept),
    contact: List(Contactdetail),
    related_artifact: List(Relatedartifact),
    keyword: List(Codeableconcept),
    location: List(Codeableconcept),
    description: Option(String),
    enrollment: List(Reference),
    period: Option(Period),
    sponsor: Option(Reference),
    principal_investigator: Option(Reference),
    site: List(Reference),
    reason_stopped: Option(Codeableconcept),
    note: List(Annotation),
    arm: List(ResearchstudyArm),
    objective: List(ResearchstudyObjective),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/ResearchStudy#resource
pub type ResearchstudyArm {
  ResearchstudyArm(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    type_: Option(Codeableconcept),
    description: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/ResearchStudy#resource
pub type ResearchstudyObjective {
  ResearchstudyObjective(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: Option(String),
    type_: Option(Codeableconcept),
  )
}
