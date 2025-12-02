import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Codeableconcept, type Extension, type Identifier, type Meta,
  type Narrative, type Quantity, type Reference,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/SupplyRequest#resource
pub type Supplyrequest {
  Supplyrequest(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: Option(String),
    category: Option(Codeableconcept),
    priority: Option(String),
    item: Nil,
    quantity: Quantity,
    parameter: List(SupplyrequestParameter),
    occurrence: Option(Nil),
    authored_on: Option(String),
    requester: Option(Reference),
    supplier: List(Reference),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    deliver_from: Option(Reference),
    deliver_to: Option(Reference),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SupplyRequest#resource
pub type SupplyrequestParameter {
  SupplyrequestParameter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(Codeableconcept),
    value: Option(Nil),
  )
}
