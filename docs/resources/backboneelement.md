# Backbone Element

A backbone element is a group of elements specific to the resource the backbone element is in. In Gleam, backbone elements are custom types with a record of all their child fields, much like complex types except they are only used in one specific resource type. For example, the [Patient.contact](https://hl7.org/fhir/R4/patient-definitions.html#Patient.contact) backbone element, r4.PatientContact in Gleam, is not used by any other resources. Whereas Patient.contact.telecom uses the [ContactPoint](https://hl7.org/fhir/R4/datatypes.html#ContactPoint) complex type, r4.Contactpoint in Gleam, which is used by many different resources.

Backbone elements let resources have multiple of some group of elements (using cardinality).

![PatientContact](https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/PatientContact.png)

```gleam
pub type PatientContact {
  PatientContact(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    relationship: List(Codeableconcept),
    name: Option(Humanname),
    telecom: List(Contactpoint),
    address: Option(Address),
    gender: Option(r4_valuesets.Administrativegender),
    organization: Option(Reference),
    period: Option(Period),
  )
}
```
