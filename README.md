# fhir

## Type-safe FHIR resources and client

[![Package Version](https://img.shields.io/hexpm/v/fhir)](https://hex.pm/packages/fhir)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/fhir/)

## Warning

Breaking changes are planned for at least primitive extensions, implicit precision in decimal types, and date/datetime, possibly more. This package is published to get feedback on the most convenient ways to implement these. Lots of stuff will break until a version 1.

## [Full Docs](https://hexdocs.pm/fhir/documentation.html) <- good starting point if new to Gleam or FHIR

## Quick Start

```sh
gleam new hello_fhir && cd hello_fhir && gleam add fhir
```
```gleam

//In hello_fhir.gleam
import fhir/r4
import fhir/r4_httpc
import fhir/r4_valuesets
import gleam/option.{Some}

pub fn main() {
  let joe =
    r4.Patient(
      ..r4.patient_new(),
      identifier: [
        r4.Identifier(
          ..r4.identifier_new(),
          system: Some("https://fhir.nhs.uk/Id/nhs-number"),
          value: Some("0123456789"),
        ),
      ],
      name: [
        r4.Humanname(
          ..r4.humanname_new(),
          given: ["Joe"],
          family: Some("Armstrong"),
        ),
      ],
      gender: Some(r4_valuesets.AdministrativegenderMale),
      marital_status: Some(
        r4.Codeableconcept(..r4.codeableconcept_new(), coding: [
          r4.Coding(
            ..r4.coding_new(),
            system: Some(
              "http://terminology.hl7.org/CodeSystem/v3-MaritalStatus",
            ),
            code: Some("M"),
            display: Some("Married"),
          ),
        ]),
      ),
    )

  echo joe

  let client = r4_httpc.fhirclient_new("https://hapi.fhir.org/baseR4")

  let assert Ok(created) = r4_httpc.patient_create(joe, client)
  let assert Some(id) = created.id
  let assert Ok(read) = r4_httpc.patient_read(id, client)
  echo read
  let rip = r4.Patient(..read, deceased: Some(r4.PatientDeceasedBoolean(True)))
  let assert Ok(updated) = r4_httpc.patient_update(rip, client)
  echo updated
  let assert Ok(_) = r4_httpc.patient_delete(updated, client)
}
```
```sh
gleam run
```

## Why Gleam

Cardinality and choice types feel very natural in Gleam, and the compiler can prevent mistakes on complex resources such as operating on a missing field or on a bool instead of int. Plus it's simple, you can [learn](https://tour.gleam.run/) the whole language in a day.
