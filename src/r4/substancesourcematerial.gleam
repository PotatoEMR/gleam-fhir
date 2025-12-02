import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Extension, type Identifier, type Meta,
  type Narrative,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceSourceMaterial#resource
pub type Substancesourcematerial {
  Substancesourcematerial(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    source_material_class: Option(Codeableconcept),
    source_material_type: Option(Codeableconcept),
    source_material_state: Option(Codeableconcept),
    organism_id: Option(Identifier),
    organism_name: Option(String),
    parent_substance_id: List(Identifier),
    parent_substance_name: List(String),
    country_of_origin: List(Codeableconcept),
    geographical_location: List(String),
    development_stage: Option(Codeableconcept),
    fraction_description: List(SubstancesourcematerialFractiondescription),
    organism: Option(SubstancesourcematerialOrganism),
    part_description: List(SubstancesourcematerialPartdescription),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceSourceMaterial#resource
pub type SubstancesourcematerialFractiondescription {
  SubstancesourcematerialFractiondescription(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    fraction: Option(String),
    material_type: Option(Codeableconcept),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceSourceMaterial#resource
pub type SubstancesourcematerialOrganism {
  SubstancesourcematerialOrganism(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    family: Option(Codeableconcept),
    genus: Option(Codeableconcept),
    species: Option(Codeableconcept),
    intraspecific_type: Option(Codeableconcept),
    intraspecific_description: Option(String),
    author: List(SubstancesourcematerialOrganismAuthor),
    hybrid: Option(SubstancesourcematerialOrganismHybrid),
    organism_general: Option(SubstancesourcematerialOrganismOrganismgeneral),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceSourceMaterial#resource
pub type SubstancesourcematerialOrganismAuthor {
  SubstancesourcematerialOrganismAuthor(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    author_type: Option(Codeableconcept),
    author_description: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceSourceMaterial#resource
pub type SubstancesourcematerialOrganismHybrid {
  SubstancesourcematerialOrganismHybrid(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    maternal_organism_id: Option(String),
    maternal_organism_name: Option(String),
    paternal_organism_id: Option(String),
    paternal_organism_name: Option(String),
    hybrid_type: Option(Codeableconcept),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceSourceMaterial#resource
pub type SubstancesourcematerialOrganismOrganismgeneral {
  SubstancesourcematerialOrganismOrganismgeneral(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    kingdom: Option(Codeableconcept),
    phylum: Option(Codeableconcept),
    class: Option(Codeableconcept),
    order: Option(Codeableconcept),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceSourceMaterial#resource
pub type SubstancesourcematerialPartdescription {
  SubstancesourcematerialPartdescription(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    part: Option(Codeableconcept),
    part_location: Option(Codeableconcept),
  )
}
