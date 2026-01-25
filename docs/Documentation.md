# Documentation

## [Welcome](#welcome)

Welcome to the Gleam FHIR documentation! [FHIR](https://hl7.org/fhir/) (Fast Healthcare Interoperability Resources) is a standard for health care data exchange, published by HL7®.

## [Quick Start](#quickstart)

```sh
gleam new mything && cd mything && gleam add fhir
```
```gleam
//In src/mything.gleam
import fhir/r4_httpc

pub fn main() {
  let fc = r4_httpc.fhirclient_new("https://r4.smarthealthit.org/")
  let assert Ok(pat) =
    r4_httpc.patient_read("2cda5aad-e409-4070-9a15-e1c35c46ed5a", fc)
}
```
```sh
gleam run
```

## [Modules](#modules)

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

## [Documentation Pages](#documentationpages)

Documentation - you are here

[Working with resources](https://hexdocs.pm/fhir/fhir/resources.html)

[Parsing JSON](https://hexdocs.pm/fhir/fhir/serialization.html)

[REST clients](https://hexdocs.pm/fhir/fhir/clients.html)

## [Further Reading](#furtherreading)

These pages provide only an intro to FHIR and the Gleam implementation. For comprehensive information, see the FHIR docs, e.g. for [R4 AllergyIntolerance](https://hl7.org/fhir/R4/allergyintolerance.html#resource).

Gleam FHIR is not a mature project. For an application with high stakes, you are probably better off with a mature FHIR SDK such as [https://docs.fire.ly/](https://docs.fire.ly/). These Gleam FHIR pages are modelled on their .NET SDK documentation.

[https://chat.fhir.org/](https://chat.fhir.org/) is a public chatroom with many FHIR implementers. If you have a question, there is a good chance someone has already asked it there.
