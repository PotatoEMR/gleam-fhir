import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Attachment, type Codeableconcept, type Extension, type Identifier,
  type Meta, type Narrative, type Quantity, type Ratio, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceSpecification#resource
pub type Substancespecification {
  Substancespecification(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Option(Identifier),
    type_: Option(Codeableconcept),
    status: Option(Codeableconcept),
    domain: Option(Codeableconcept),
    description: Option(String),
    source: List(Reference),
    comment: Option(String),
    moiety: List(SubstancespecificationMoiety),
    property: List(SubstancespecificationProperty),
    reference_information: Option(Reference),
    structure: Option(SubstancespecificationStructure),
    code: List(SubstancespecificationCode),
    name: List(SubstancespecificationName),
    molecular_weight: List(Nil),
    relationship: List(SubstancespecificationRelationship),
    nucleic_acid: Option(Reference),
    polymer: Option(Reference),
    protein: Option(Reference),
    source_material: Option(Reference),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceSpecification#resource
pub type SubstancespecificationMoiety {
  SubstancespecificationMoiety(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    role: Option(Codeableconcept),
    identifier: Option(Identifier),
    name: Option(String),
    stereochemistry: Option(Codeableconcept),
    optical_activity: Option(Codeableconcept),
    molecular_formula: Option(String),
    amount: Option(Nil),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceSpecification#resource
pub type SubstancespecificationProperty {
  SubstancespecificationProperty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    category: Option(Codeableconcept),
    code: Option(Codeableconcept),
    parameters: Option(String),
    defining_substance: Option(Nil),
    amount: Option(Nil),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceSpecification#resource
pub type SubstancespecificationStructure {
  SubstancespecificationStructure(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    stereochemistry: Option(Codeableconcept),
    optical_activity: Option(Codeableconcept),
    molecular_formula: Option(String),
    molecular_formula_by_moiety: Option(String),
    isotope: List(SubstancespecificationStructureIsotope),
    molecular_weight: Option(Nil),
    source: List(Reference),
    representation: List(SubstancespecificationStructureRepresentation),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceSpecification#resource
pub type SubstancespecificationStructureIsotope {
  SubstancespecificationStructureIsotope(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Option(Identifier),
    name: Option(Codeableconcept),
    substitution: Option(Codeableconcept),
    half_life: Option(Quantity),
    molecular_weight: Option(
      SubstancespecificationStructureIsotopeMolecularweight,
    ),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceSpecification#resource
pub type SubstancespecificationStructureIsotopeMolecularweight {
  SubstancespecificationStructureIsotopeMolecularweight(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    method: Option(Codeableconcept),
    type_: Option(Codeableconcept),
    amount: Option(Quantity),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceSpecification#resource
pub type SubstancespecificationStructureRepresentation {
  SubstancespecificationStructureRepresentation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    representation: Option(String),
    attachment: Option(Attachment),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceSpecification#resource
pub type SubstancespecificationCode {
  SubstancespecificationCode(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(Codeableconcept),
    status: Option(Codeableconcept),
    status_date: Option(String),
    comment: Option(String),
    source: List(Reference),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceSpecification#resource
pub type SubstancespecificationName {
  SubstancespecificationName(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    type_: Option(Codeableconcept),
    status: Option(Codeableconcept),
    preferred: Option(Bool),
    language: List(Codeableconcept),
    domain: List(Codeableconcept),
    jurisdiction: List(Codeableconcept),
    synonym: List(Nil),
    translation: List(Nil),
    official: List(SubstancespecificationNameOfficial),
    source: List(Reference),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceSpecification#resource
pub type SubstancespecificationNameOfficial {
  SubstancespecificationNameOfficial(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    authority: Option(Codeableconcept),
    status: Option(Codeableconcept),
    date: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceSpecification#resource
pub type SubstancespecificationRelationship {
  SubstancespecificationRelationship(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    substance: Option(Nil),
    relationship: Option(Codeableconcept),
    is_defining: Option(Bool),
    amount: Option(Nil),
    amount_ratio_low_limit: Option(Ratio),
    amount_type: Option(Codeableconcept),
    source: List(Reference),
  )
}
