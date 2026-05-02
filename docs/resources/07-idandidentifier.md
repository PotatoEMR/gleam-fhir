# id and identifier

All [resources](https://hl7.org/fhir/R4/resource.html#Resource) have an id, which says where the resource is. For example, a patient with id 2cda5aad-e409-4070-9a15-e1c35c46ed5a would be at [https://r4.smarthealthit.org/Patient/2cda5aad-e409-4070-9a15-e1c35c46ed5a](https://r4.smarthealthit.org/Patient/2cda5aad-e409-4070-9a15-e1c35c46ed5a) if it exists on the r4.smarthealthit.org server. The FHIR server should always assign an id upon creating a resource, but a resource that has not yet been created on the server will not yet have an id, so id is an `Option(String)` in Gleam.

An [Identifier](https://build.fhir.org/datatypes.html#Identifier) is a business identifier with a meaning in some system, such as a patient's MRN in a hospital. 
For instance, the system could be http://hl7.org/fhir/sid/us-ssn for US social security numbers or http://ns.electronichealth.net.au/id/hi/ihi/1.0 for Australian Individual Healthcare Identifier numbers. Not all resourcs have an Identifier (e.g. [AuditEvent](https://hl7.org/fhir/R4/auditevent.html#resource)). A resource with `0..*` Identifier cardinality can have multiple identifiers, which is `List(Identifier)` in Gleam. For example, a Patient may have an Identifier in many different systems.

```gleam
import fhir/r4/complex_types as ct
import fhir/r4/resources

import gleam/option.{Some}

pub fn main() {
  let mrn_type =
    ct.Codeableconcept(..ct.codeableconcept_new(), coding: [
      ct.Coding(
        ..ct.coding_new(),
        system: Some("http://terminology.hl7.org/CodeSystem/v2-0203"),
        code: Some("MR"),
        display: Some("Medical Record Number"),
      ),
    ])
  let ssn_type =
    ct.Codeableconcept(..ct.codeableconcept_new(), coding: [
      ct.Coding(
        ..ct.coding_new(),
        system: Some("http://terminology.hl7.org/CodeSystem/v2-0203"),
        code: Some("SS"),
        display: Some("Social Security Number"),
      ),
    ])
  let pat =
    resources.Patient(..resources.patient_new(), identifier: [
      ct.Identifier(
        ..ct.identifier_new(),
        type_: Some(mrn_type),
        system: Some("http://hospital.smarthealthit.org"),
        value: Some("73a7d6b7-0310-4fff-9b0b-7891a5e390f5"),
      ),
      ct.Identifier(
        ..ct.identifier_new(),
        type_: Some(ssn_type),
        system: Some("http://hl7.org/fhir/sid/us-ssn"),
        value: Some("999-91-2751"),
      ),
    ])
  echo pat
}
```
