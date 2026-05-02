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
