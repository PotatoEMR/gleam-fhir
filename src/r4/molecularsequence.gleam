import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Extension, type Identifier, type Meta,
  type Narrative, type Quantity, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/MolecularSequence#resource
pub type Molecularsequence {
  Molecularsequence(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    type_: Option(String),
    coordinate_system: Int,
    patient: Option(Reference),
    specimen: Option(Reference),
    device: Option(Reference),
    performer: Option(Reference),
    quantity: Option(Quantity),
    reference_seq: Option(MolecularsequenceReferenceseq),
    variant: List(MolecularsequenceVariant),
    observed_seq: Option(String),
    quality: List(MolecularsequenceQuality),
    read_coverage: Option(Int),
    repository: List(MolecularsequenceRepository),
    pointer: List(Reference),
    structure_variant: List(MolecularsequenceStructurevariant),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MolecularSequence#resource
pub type MolecularsequenceReferenceseq {
  MolecularsequenceReferenceseq(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    chromosome: Option(Codeableconcept),
    genome_build: Option(String),
    orientation: Option(String),
    reference_seq_id: Option(Codeableconcept),
    reference_seq_pointer: Option(Reference),
    reference_seq_string: Option(String),
    strand: Option(String),
    window_start: Option(Int),
    window_end: Option(Int),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MolecularSequence#resource
pub type MolecularsequenceVariant {
  MolecularsequenceVariant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    start: Option(Int),
    end: Option(Int),
    observed_allele: Option(String),
    reference_allele: Option(String),
    cigar: Option(String),
    variant_pointer: Option(Reference),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MolecularSequence#resource
pub type MolecularsequenceQuality {
  MolecularsequenceQuality(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: String,
    standard_sequence: Option(Codeableconcept),
    start: Option(Int),
    end: Option(Int),
    score: Option(Quantity),
    method: Option(Codeableconcept),
    truth_t_p: Option(Float),
    query_t_p: Option(Float),
    truth_f_n: Option(Float),
    query_f_p: Option(Float),
    gt_f_p: Option(Float),
    precision: Option(Float),
    recall: Option(Float),
    f_score: Option(Float),
    roc: Option(MolecularsequenceQualityRoc),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MolecularSequence#resource
pub type MolecularsequenceQualityRoc {
  MolecularsequenceQualityRoc(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    score: List(Int),
    num_t_p: List(Int),
    num_f_p: List(Int),
    num_f_n: List(Int),
    precision: List(Float),
    sensitivity: List(Float),
    f_measure: List(Float),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MolecularSequence#resource
pub type MolecularsequenceRepository {
  MolecularsequenceRepository(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: String,
    url: Option(String),
    name: Option(String),
    dataset_id: Option(String),
    variantset_id: Option(String),
    readset_id: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MolecularSequence#resource
pub type MolecularsequenceStructurevariant {
  MolecularsequenceStructurevariant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    variant_type: Option(Codeableconcept),
    exact: Option(Bool),
    length: Option(Int),
    outer: Option(MolecularsequenceStructurevariantOuter),
    inner: Option(MolecularsequenceStructurevariantInner),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MolecularSequence#resource
pub type MolecularsequenceStructurevariantOuter {
  MolecularsequenceStructurevariantOuter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    start: Option(Int),
    end: Option(Int),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MolecularSequence#resource
pub type MolecularsequenceStructurevariantInner {
  MolecularsequenceStructurevariantInner(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    start: Option(Int),
    end: Option(Int),
  )
}
