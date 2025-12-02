# fhir

[![Package Version](https://img.shields.io/hexpm/v/fhir)](https://hex.pm/packages/fhir)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/fhir/)

```sh
gleam add fhir@1
```
```gleam
import fhir

pub fn main() -> Nil {
  // TODO: An example of the project in use
}
```

Further documentation can be found at <https://hexdocs.pm/fhir>.

## Development

```sh
gleam run -m internal/codegen R4 R4B R5 download 
```

```sh
rm -r .\src\r4\; gleam run -m internal/codegen r4; gleam format
```
