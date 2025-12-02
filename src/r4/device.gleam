import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Annotation, type Codeableconcept, type Contactpoint, type Extension,
  type Identifier, type Meta, type Narrative, type Quantity, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/Device#resource
pub type Device {
  Device(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    definition: Option(Reference),
    udi_carrier: List(DeviceUdicarrier),
    status: Option(String),
    status_reason: List(Codeableconcept),
    distinct_identifier: Option(String),
    manufacturer: Option(String),
    manufacture_date: Option(String),
    expiration_date: Option(String),
    lot_number: Option(String),
    serial_number: Option(String),
    device_name: List(DeviceDevicename),
    model_number: Option(String),
    part_number: Option(String),
    type_: Option(Codeableconcept),
    specialization: List(DeviceSpecialization),
    version: List(DeviceVersion),
    property: List(DeviceProperty),
    patient: Option(Reference),
    owner: Option(Reference),
    contact: List(Contactpoint),
    location: Option(Reference),
    url: Option(String),
    note: List(Annotation),
    safety: List(Codeableconcept),
    parent: Option(Reference),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Device#resource
pub type DeviceUdicarrier {
  DeviceUdicarrier(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    device_identifier: Option(String),
    issuer: Option(String),
    jurisdiction: Option(String),
    carrier_a_i_d_c: Option(String),
    carrier_h_r_f: Option(String),
    entry_type: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Device#resource
pub type DeviceDevicename {
  DeviceDevicename(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    type_: String,
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Device#resource
pub type DeviceSpecialization {
  DeviceSpecialization(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    system_type: Codeableconcept,
    version: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Device#resource
pub type DeviceVersion {
  DeviceVersion(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    component: Option(Identifier),
    value: String,
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Device#resource
pub type DeviceProperty {
  DeviceProperty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value_quantity: List(Quantity),
    value_code: List(Codeableconcept),
  )
}
