# fhir

## Type-safe FHIR resources and client

[![Package Version](https://img.shields.io/hexpm/v/fhir)](https://hex.pm/packages/fhir)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/fhir/)
![GitHub License](https://img.shields.io/github/license/PotatoEMR/gleam-fhir?color=%23750014)

## Welcome

<div style="display: flex">
<img src="https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/lucy.svg" title="Gleam Lucy" alt="Gleam Lucy" width="35%">
<img src="https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/fhir.svg" title="HL7® FHIR® Flame" alt="HL7® FHIR Flame" width="35%">
</div>

[FHIR®](https://hl7.org/fhir/) (Fast Healthcare Interoperability Resources) is a standard for health care data exchange, published by HL7®. [Gleam](https://gleam.run/) is simple and type-safe, making FHIR resource features like cardinality and choice types easy to work with.

## Features
- Supports R4, R4B, R5
- Gleam types for FHIR data types and resources
- Primitive types to represent valid FHIR date, dateTime, instant, time
- JSON encoder and to_json functions
- Enums for valuesets with required binding
- Sans-io request/response for Create, Read, Update, Delete, Search
- Client layers over sans-io for easy use on Erlang target and Lustre apps
- Primitive extensions, optionally generated for each type
- Standard extension on all complex type, and optionally type safe extension generation for specific extension

## Warning

!!! fhir@0.3.0 (current version) supports r4us ONLY; r4/r4b/r5 are not available, because of hex.pm package size limits. !!!


## Quick Start

```sh
gleam new hello_fhir && cd hello_fhir && gleam add fhir
```
```gleam

//In hello_fhir.gleam
import fhir/r4us
import fhir/r4us_httpc
import fhir/r4us_valuesets
import gleam/option.{Some}

pub fn main() {
  let joe =
    r4us.Patient(
      ..r4us.patient_new(),
      identifier: [
        r4us.Identifier(
          ..r4us.identifier_new(),
          system: Some("https://fhir.nhs.uk/Id/nhs-number"),
          value: Some("0123456789"),
        ),
      ],
      name: [
        r4us.Humanname(
          ..r4us.humanname_new(),
          given: ["Joe"],
          family: Some("Armstrong"),
        ),
      ],
      gender: Some(r4us_valuesets.AdministrativegenderMale),
      marital_status: Some(
        r4us.Codeableconcept(..r4us.codeableconcept_new(), coding: [
          r4us.Coding(
            ..r4us.coding_new(),
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

  let assert Ok(client) =
    r4us_httpc.fhirclient_new("https://r4us.smarthealthit.org/")

  // https://r4us.smarthealthit.org/ might be down and give an error creating patient
  // if so try these alternatives:
  // fhirclient_new("https://hapi.fhir.org/baseR4")
  // fhirclient_new("https://server.fire.ly")

  let assert Ok(created) = r4us_httpc.patient_create(joe, client)
  let assert Some(id) = created.id
  let assert Ok(read) = r4us_httpc.patient_read(id, client)
  echo read
  let rip =
    r4us.Patient(..read, deceased: Some(r4us.PatientDeceasedBoolean(True)))
  let assert Ok(updated) = r4us_httpc.patient_update(rip, client)
  echo updated
  let assert Ok(_) = r4us_httpc.patient_delete(updated, client)
}
```
```sh
gleam run
```

## AI use

AI in parts of codegen (which creates Gleam code from FHIR data) and some tests. No AI in API design or documentation. 

## Other FHIR Docs

These pages provide only an intro to FHIR and the Gleam implementation. For comprehensive information, see the FHIR docs, e.g. for [R4 AllergyIntolerance](https://hl7.org/fhir/R4/allergyintolerance.html#resource).

Gleam FHIR is not a mature project. For an application with real users and regulations, you are probably better off with a mature FHIR SDK such as [https://docs.fire.ly/](https://docs.fire.ly/). These Gleam FHIR pages are modelled on their .NET SDK documentation.

[https://chat.fhir.org/](https://chat.fhir.org/) is a public chatroom with many FHIR implementers. If you have a question, there is a good chance someone has asked it there.
