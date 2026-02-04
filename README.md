# fhir

## Type-safe FHIR resources and client

<div style="display: flex">
[![Package Version](https://img.shields.io/hexpm/v/fhir)](https://hex.pm/packages/fhir)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/fhir/)
</div>

## Warning

Breaking changes are planned for at least primitive extensions, implicit precision in decimal types, and date/datetime, possibly more. This package is published to get feedback on the most convenient ways to implement these. Lots of stuff will break until a version 1.

## Welcome

<img src="https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/lucy.svg" title="Gleam Lucy" alt="Gleam Lucy" width="35%">
<img src="https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/fhir.svg" title="HL7® FHIR® Flame" alt="HL7® FHIR Flame" width="35%">

[FHIR®](https://hl7.org/fhir/) (Fast Healthcare Interoperability Resources) is a standard for health care data exchange, published by HL7®. Welcome to Gleam FHIR!

## Documentation: [Resources](https://hexdocs.pm/fhir/resources.html) & [Client](https://hexdocs.pm/fhir/clients.html)

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

  let client = r4_httpc.fhirclient_new("https://r4.smarthealthit.org/")

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

## Modules

(for each of r4, r4b, r5)

<div style="display:grid;grid-template-columns:1fr;gap:8px;text-align:center;justify-items:center">
  <div style="background:rgba(0,0,0,.2);padding:6px">
    <a href="https://hexdocs.pm/fhir/fhir/r4_valuesets.html">r4_valuesets</a><br>
    Enums for valuesets with required binding
  </div>

  <div>↓</div>

  <div style="background:rgba(0,0,0,.2);padding:6px">
    <a href="https://hexdocs.pm/fhir/fhir/r4.html">r4</a><br>
    Resources and their data types, and decoder and to_json fns
  </div>

  <div>↓</div>

  <div style="background:rgba(0,0,0,.2);padding:6px">
    <a href="https://hexdocs.pm/fhir/fhir/r4_sansio.html">r4_sansio</a><br>
    Prepare http request and parse http response
  </div>

  <div style="display:grid;grid-template-columns:1fr 1fr;width:100%">
    <div>↓</div><div>↓</div>
  </div>

  <div style="display:grid;grid-template-columns:1fr 1fr;width:100%">
    <div style="background:rgba(0,0,0,.2);padding:6px">
      <a href="https://hexdocs.pm/fhir/fhir/r4_httpc.html">r4_httpc</a><br>
      Client for httpc (Erlang)
    </div>
    <div style="background:rgba(0,0,0,.2);padding:6px">
      <a href="https://hexdocs.pm/fhir/fhir/r4_rsvp.html">r4_rsvp</a><br>
      Client for rsvp (Lustre apps)
    </div>
  </div>
</div>

## Why Gleam

Cardinality and choice types feel very natural in Gleam, and the compiler can prevent mistakes on complex resources such as operating on a missing field or on a bool instead of int. Plus it's simple, you can [learn](https://tour.gleam.run/) the whole language in a day.

## Other FHIR Docs

These pages provide only an intro to FHIR and the Gleam implementation. For comprehensive information, see the FHIR docs, e.g. for [R4 AllergyIntolerance](https://hl7.org/fhir/R4/allergyintolerance.html#resource).

Gleam FHIR is not a mature project. For an application with real users and regulations, you are probably better off with a mature FHIR SDK such as [https://docs.fire.ly/](https://docs.fire.ly/). These Gleam FHIR pages are modelled on their .NET SDK documentation.

[https://chat.fhir.org/](https://chat.fhir.org/) is a public chatroom with many FHIR implementers. If you have a question, there is a good chance someone has asked it there.
