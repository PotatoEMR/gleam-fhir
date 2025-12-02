import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Extension, type Identifier, type Meta,
  type Narrative, type Reference, type Timing,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/DeviceMetric#resource
pub type Devicemetric {
  Devicemetric(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    type_: Codeableconcept,
    unit: Option(Codeableconcept),
    source: Option(Reference),
    parent: Option(Reference),
    operational_status: Option(String),
    color: Option(String),
    category: String,
    measurement_period: Option(Timing),
    calibration: List(DevicemetricCalibration),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/DeviceMetric#resource
pub type DevicemetricCalibration {
  DevicemetricCalibration(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(String),
    state: Option(String),
    time: Option(String),
  )
}
