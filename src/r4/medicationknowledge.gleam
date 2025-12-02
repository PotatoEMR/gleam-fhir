import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Dosage, type Duration, type Extension, type Meta,
  type Money, type Narrative, type Quantity, type Ratio, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
pub type Medicationknowledge {
  Medicationknowledge(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(Codeableconcept),
    status: Option(String),
    manufacturer: Option(Reference),
    dose_form: Option(Codeableconcept),
    amount: Option(Quantity),
    synonym: List(String),
    related_medication_knowledge: List(
      MedicationknowledgeRelatedmedicationknowledge,
    ),
    associated_medication: List(Reference),
    product_type: List(Codeableconcept),
    monograph: List(MedicationknowledgeMonograph),
    ingredient: List(MedicationknowledgeIngredient),
    preparation_instruction: Option(String),
    intended_route: List(Codeableconcept),
    cost: List(MedicationknowledgeCost),
    monitoring_program: List(MedicationknowledgeMonitoringprogram),
    administration_guidelines: List(MedicationknowledgeAdministrationguidelines),
    medicine_classification: List(MedicationknowledgeMedicineclassification),
    packaging: Option(MedicationknowledgePackaging),
    drug_characteristic: List(MedicationknowledgeDrugcharacteristic),
    contraindication: List(Reference),
    regulatory: List(MedicationknowledgeRegulatory),
    kinetics: List(MedicationknowledgeKinetics),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeRelatedmedicationknowledge {
  MedicationknowledgeRelatedmedicationknowledge(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    reference: List(Reference),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeMonograph {
  MedicationknowledgeMonograph(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    source: Option(Reference),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeIngredient {
  MedicationknowledgeIngredient(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item: Nil,
    is_active: Option(Bool),
    strength: Option(Ratio),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeCost {
  MedicationknowledgeCost(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    source: Option(String),
    cost: Money,
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeMonitoringprogram {
  MedicationknowledgeMonitoringprogram(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    name: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeAdministrationguidelines {
  MedicationknowledgeAdministrationguidelines(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    dosage: List(MedicationknowledgeAdministrationguidelinesDosage),
    indication: Option(Nil),
    patient_characteristics: List(
      MedicationknowledgeAdministrationguidelinesPatientcharacteristics,
    ),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeAdministrationguidelinesDosage {
  MedicationknowledgeAdministrationguidelinesDosage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    dosage: List(Dosage),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeAdministrationguidelinesPatientcharacteristics {
  MedicationknowledgeAdministrationguidelinesPatientcharacteristics(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    characteristic: Nil,
    value: List(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeMedicineclassification {
  MedicationknowledgeMedicineclassification(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    classification: List(Codeableconcept),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgePackaging {
  MedicationknowledgePackaging(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    quantity: Option(Quantity),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeDrugcharacteristic {
  MedicationknowledgeDrugcharacteristic(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    value: Option(Nil),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeRegulatory {
  MedicationknowledgeRegulatory(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    regulatory_authority: Reference,
    substitution: List(MedicationknowledgeRegulatorySubstitution),
    schedule: List(MedicationknowledgeRegulatorySchedule),
    max_dispense: Option(MedicationknowledgeRegulatoryMaxdispense),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeRegulatorySubstitution {
  MedicationknowledgeRegulatorySubstitution(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    allowed: Bool,
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeRegulatorySchedule {
  MedicationknowledgeRegulatorySchedule(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    schedule: Codeableconcept,
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeRegulatoryMaxdispense {
  MedicationknowledgeRegulatoryMaxdispense(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    quantity: Quantity,
    period: Option(Duration),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeKinetics {
  MedicationknowledgeKinetics(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    area_under_curve: List(Quantity),
    lethal_dose50: List(Quantity),
    half_life_period: Option(Duration),
  )
}
