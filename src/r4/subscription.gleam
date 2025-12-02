import gleam/option.{type Option}
import r4/fhir_basic_types/fhir.{
  type Contactpoint, type Extension, type Meta, type Narrative,
}
import r4/resource.{type Resource}

//http://hl7.org/fhir/r4/StructureDefinition/Subscription#resource
pub type Subscription {
  Subscription(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    status: String,
    contact: List(Contactpoint),
    end: Option(String),
    reason: String,
    criteria: String,
    error: Option(String),
    channel: SubscriptionChannel,
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Subscription#resource
pub type SubscriptionChannel {
  SubscriptionChannel(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: String,
    endpoint: Option(String),
    payload: Option(String),
    header: List(String),
  )
}
