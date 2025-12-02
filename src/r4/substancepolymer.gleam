import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Attachment, type Codeableconcept, type Extension, type Meta,
  type Narrative, type Substanceamount,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/SubstancePolymer#resource
pub type Substancepolymer {
  Substancepolymer(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    class: Option(Codeableconcept),
    geometry: Option(Codeableconcept),
    copolymer_connectivity: List(Codeableconcept),
    modification: List(String),
    monomer_set: List(SubstancepolymerMonomerset),
    repeat: List(SubstancepolymerRepeat),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstancePolymer#resource
pub type SubstancepolymerMonomerset {
  SubstancepolymerMonomerset(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    ratio_type: Option(Codeableconcept),
    starting_material: List(SubstancepolymerMonomersetStartingmaterial),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstancePolymer#resource
pub type SubstancepolymerMonomersetStartingmaterial {
  SubstancepolymerMonomersetStartingmaterial(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    material: Option(Codeableconcept),
    type_: Option(Codeableconcept),
    is_defining: Option(Bool),
    amount: Option(Substanceamount),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstancePolymer#resource
pub type SubstancepolymerRepeat {
  SubstancepolymerRepeat(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    number_of_units: Option(Int),
    average_molecular_formula: Option(String),
    repeat_unit_amount_type: Option(Codeableconcept),
    repeat_unit: List(SubstancepolymerRepeatRepeatunit),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstancePolymer#resource
pub type SubstancepolymerRepeatRepeatunit {
  SubstancepolymerRepeatRepeatunit(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    orientation_of_polymerisation: Option(Codeableconcept),
    repeat_unit: Option(String),
    amount: Option(Substanceamount),
    degree_of_polymerisation: List(
      SubstancepolymerRepeatRepeatunitDegreeofpolymerisation,
    ),
    structural_representation: List(
      SubstancepolymerRepeatRepeatunitStructuralrepresentation,
    ),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstancePolymer#resource
pub type SubstancepolymerRepeatRepeatunitDegreeofpolymerisation {
  SubstancepolymerRepeatRepeatunitDegreeofpolymerisation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    degree: Option(Codeableconcept),
    amount: Option(Substanceamount),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstancePolymer#resource
pub type SubstancepolymerRepeatRepeatunitStructuralrepresentation {
  SubstancepolymerRepeatRepeatunitStructuralrepresentation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    representation: Option(String),
    attachment: Option(Attachment),
  )
}
