import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Attachment, type Codeableconcept, type Contactpoint, type Extension,
  type Identifier, type Meta, type Narrative, type Period, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/HealthcareService#resource
pub type Healthcareservice {
  Healthcareservice(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    active: Option(Bool),
    provided_by: Option(Reference),
    category: List(Codeableconcept),
    type_: List(Codeableconcept),
    specialty: List(Codeableconcept),
    location: List(Reference),
    name: Option(String),
    comment: Option(String),
    extra_details: Option(String),
    photo: Option(Attachment),
    telecom: List(Contactpoint),
    coverage_area: List(Reference),
    service_provision_code: List(Codeableconcept),
    eligibility: List(HealthcareserviceEligibility),
    program: List(Codeableconcept),
    characteristic: List(Codeableconcept),
    communication: List(Codeableconcept),
    referral_method: List(Codeableconcept),
    appointment_required: Option(Bool),
    available_time: List(HealthcareserviceAvailabletime),
    not_available: List(HealthcareserviceNotavailable),
    availability_exceptions: Option(String),
    endpoint: List(Reference),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/HealthcareService#resource
pub type HealthcareserviceEligibility {
  HealthcareserviceEligibility(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(Codeableconcept),
    comment: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/HealthcareService#resource
pub type HealthcareserviceAvailabletime {
  HealthcareserviceAvailabletime(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    days_of_week: List(String),
    all_day: Option(Bool),
    available_start_time: Option(String),
    available_end_time: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/HealthcareService#resource
pub type HealthcareserviceNotavailable {
  HealthcareserviceNotavailable(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: String,
    during: Option(Period),
  )
}
