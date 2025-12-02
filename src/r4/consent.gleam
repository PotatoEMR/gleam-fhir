import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Coding, type Extension, type Identifier, type Meta,
  type Narrative, type Period, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/Consent#resource
pub type Consent {
  Consent(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    scope: Codeableconcept,
    category: List(Codeableconcept),
    patient: Option(Reference),
    date_time: Option(String),
    performer: List(Reference),
    organization: List(Reference),
    source: Option(Nil),
    policy: List(ConsentPolicy),
    policy_rule: Option(Codeableconcept),
    verification: List(ConsentVerification),
    provision: Option(ConsentProvision),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Consent#resource
pub type ConsentPolicy {
  ConsentPolicy(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    authority: Option(String),
    uri: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Consent#resource
pub type ConsentVerification {
  ConsentVerification(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    verified: Bool,
    verified_with: Option(Reference),
    verification_date: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Consent#resource
pub type ConsentProvision {
  ConsentProvision(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(String),
    period: Option(Period),
    actor: List(ConsentProvisionActor),
    action: List(Codeableconcept),
    security_label: List(Coding),
    purpose: List(Coding),
    class: List(Coding),
    code: List(Codeableconcept),
    data_period: Option(Period),
    data: List(ConsentProvisionData),
    provision: List(Nil),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Consent#resource
pub type ConsentProvisionActor {
  ConsentProvisionActor(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    role: Codeableconcept,
    reference: Reference,
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Consent#resource
pub type ConsentProvisionData {
  ConsentProvisionData(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    meaning: String,
    reference: Reference,
  )
}
