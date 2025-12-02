import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Extension, type Identifier, type Meta,
  type Narrative, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceReferenceInformation#resource
pub type Substancereferenceinformation {
  Substancereferenceinformation(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    comment: Option(String),
    gene: List(SubstancereferenceinformationGene),
    gene_element: List(SubstancereferenceinformationGeneelement),
    classification: List(SubstancereferenceinformationClassification),
    target: List(SubstancereferenceinformationTarget),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceReferenceInformation#resource
pub type SubstancereferenceinformationGene {
  SubstancereferenceinformationGene(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    gene_sequence_origin: Option(Codeableconcept),
    gene: Option(Codeableconcept),
    source: List(Reference),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceReferenceInformation#resource
pub type SubstancereferenceinformationGeneelement {
  SubstancereferenceinformationGeneelement(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    element: Option(Identifier),
    source: List(Reference),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceReferenceInformation#resource
pub type SubstancereferenceinformationClassification {
  SubstancereferenceinformationClassification(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    domain: Option(Codeableconcept),
    classification: Option(Codeableconcept),
    subtype: List(Codeableconcept),
    source: List(Reference),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceReferenceInformation#resource
pub type SubstancereferenceinformationTarget {
  SubstancereferenceinformationTarget(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    target: Option(Identifier),
    type_: Option(Codeableconcept),
    interaction: Option(Codeableconcept),
    organism: Option(Codeableconcept),
    organism_type: Option(Codeableconcept),
    amount: Option(Nil),
    amount_type: Option(Codeableconcept),
    source: List(Reference),
  )
}
