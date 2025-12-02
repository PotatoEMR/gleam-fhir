import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Attachment, type Codeableconcept, type Extension, type Identifier,
  type Meta, type Narrative,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceNucleicAcid#resource
pub type Substancenucleicacid {
  Substancenucleicacid(
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
    area_of_hybridisation: Option(String),
    oligo_nucleotide_type: Option(Codeableconcept),
    subunit: List(SubstancenucleicacidSubunit),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceNucleicAcid#resource
pub type SubstancenucleicacidSubunit {
  SubstancenucleicacidSubunit(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    subunit: Option(Int),
    sequence: Option(String),
    length: Option(Int),
    sequence_attachment: Option(Attachment),
    five_prime: Option(Codeableconcept),
    three_prime: Option(Codeableconcept),
    linkage: List(SubstancenucleicacidSubunitLinkage),
    sugar: List(SubstancenucleicacidSubunitSugar),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceNucleicAcid#resource
pub type SubstancenucleicacidSubunitLinkage {
  SubstancenucleicacidSubunitLinkage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    connectivity: Option(String),
    identifier: Option(Identifier),
    name: Option(String),
    residue_site: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceNucleicAcid#resource
pub type SubstancenucleicacidSubunitSugar {
  SubstancenucleicacidSubunitSugar(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Option(Identifier),
    name: Option(String),
    residue_site: Option(String),
  )
}
