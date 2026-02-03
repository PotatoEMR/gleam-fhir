# Complex Type

FHIR [complex types](https://hl7.org/fhir/datatypes.html#complex) have multiple child elements. In Gleam, complex types are custom types with a record of their child fields. For example, an [Address](https://hl7.org/fhir/datatypes.html#Address) has a bunch of elements, which all are in [r4.Address](https://hexdocs.pm/fhir/fhir/r4.html#Address).

![Address](https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/Address.png)
```gleam
pub type Address {
  Address(
    id: Option(String),
    extension: List(Extension),
    use_: Option(r4_valuesets.Addressuse),
    type_: Option(r4_valuesets.Addresstype),
    text: Option(String),
    line: List(String),
    city: Option(String),
    district: Option(String),
    state: Option(String),
    postal_code: Option(String),
    country: Option(String),
    period: Option(Period),
  )
}
```
