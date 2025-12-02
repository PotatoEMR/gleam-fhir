import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Annotation, type Codeableconcept, type Contactpoint, type Extension,
  type Identifier, type Meta, type Narrative, type Prodcharacteristic,
  type Productshelflife, type Quantity, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/DeviceDefinition#resource
pub type Devicedefinition {
  Devicedefinition(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    udi_device_identifier: List(DevicedefinitionUdideviceidentifier),
    manufacturer: Option(Nil),
    device_name: List(DevicedefinitionDevicename),
    model_number: Option(String),
    type_: Option(Codeableconcept),
    specialization: List(DevicedefinitionSpecialization),
    version: List(String),
    safety: List(Codeableconcept),
    shelf_life_storage: List(Productshelflife),
    physical_characteristics: Option(Prodcharacteristic),
    language_code: List(Codeableconcept),
    capability: List(DevicedefinitionCapability),
    property: List(DevicedefinitionProperty),
    owner: Option(Reference),
    contact: List(Contactpoint),
    url: Option(String),
    online_information: Option(String),
    note: List(Annotation),
    quantity: Option(Quantity),
    parent_device: Option(Reference),
    material: List(DevicedefinitionMaterial),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionUdideviceidentifier {
  DevicedefinitionUdideviceidentifier(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    device_identifier: String,
    issuer: String,
    jurisdiction: String,
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionDevicename {
  DevicedefinitionDevicename(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    type_: String,
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionSpecialization {
  DevicedefinitionSpecialization(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    system_type: String,
    version: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionCapability {
  DevicedefinitionCapability(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    description: List(Codeableconcept),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionProperty {
  DevicedefinitionProperty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value_quantity: List(Quantity),
    value_code: List(Codeableconcept),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionMaterial {
  DevicedefinitionMaterial(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    substance: Codeableconcept,
    alternate: Option(Bool),
    allergenic_indicator: Option(Bool),
  )
}
