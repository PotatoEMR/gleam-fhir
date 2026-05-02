# Complex Type

FHIR [complex types](https://hl7.org/fhir/datatypes.html#complex) have multiple child elements. In Gleam, complex types are custom types with a record of their child fields. For example, an [Address](https://hl7.org/fhir/datatypes.html#Address) has a bunch of elements, which all are in `complex_types.Address`

![Address](https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/Address.png)
```gleam
import fhir/r4/complex_types as ct
import fhir/r4/valuesets

import gleam/option.{None, Some}

pub fn main() {
  let address =
    ct.Address(
      ..ct.address_new(),
      use_: Some(valuesets.AddressuseWork),
      type_: None,
      line: ["1979 Milky Way"],
      city: Some("Verona"),
      state: Some("WI"),
      postal_code: Some("53593"),
      country: Some("US"),
    )
  echo address
}
```
