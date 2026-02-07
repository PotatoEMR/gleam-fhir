## [id vs Identifier](#id-vs-identifier){#id-vs-identifier}

All [resources](https://hl7.org/fhir/R4/resource.html#Resource) have an id, which says where the resource is. For example, a patient with id 2cda5aad-e409-4070-9a15-e1c35c46ed5a would be at [https://r4.smarthealthit.org/Patient/2cda5aad-e409-4070-9a15-e1c35c46ed5a](https://r4.smarthealthit.org/Patient/2cda5aad-e409-4070-9a15-e1c35c46ed5a) if it exists on the r4.smarthealthit.org server. The FHIR server should always assign an id upon creating a resource, but a resource that has not yet been created on the server will not yet have an id, so id is an `Option(String)` in Gleam.

An [Identifier](https://build.fhir.org/datatypes.html#Identifier) is a business identifier with a meaning in some system, such as a patient's MRN in a hospital. 
For instance, the system could be http://hl7.org/fhir/sid/us-ssn for US social security numbers or http://ns.electronichealth.net.au/id/hi/ihi/1.0 for Australian Individual Healthcare Identifier numbers. Not all resourcs have an Identifier (e.g. [AuditEvent](https://hl7.org/fhir/R4/auditevent.html#resource)). A resource with `0..*` Identifier cardinality can have multiple identifiers, which is `List(Identifier)` in Gleam. For example, a Patient may have an Identifier in many different systems.

```gleam
let identifier_list = [
  Identifier(
    id: None,
    extension: [],
    use_: None,
    type_: None,
    system: Some("https://github.com/synthetichealth/synthea"),
    value: Some("73a7d6b7-0310-4fff-9b0b-7891a5e390f5"),
    period: None,
    assigner: None,
  ),

  Identifier(
    id: None,
    extension: [],
    use_: None,
    type_: Some(Codeableconcept(
      id: None,
      extension: [],
      coding: [
        Coding(
          id: None,
          extension: [],
          system: Some("http://terminology.hl7.org/CodeSystem/v2-0203"),
          version: None,
          code: Some("MR"),
          display: Some("Medical Record Number"),
          user_selected: None,
        ),
      ],
      text: Some("Medical Record Number"),
    )),
    system: Some("http://hospital.smarthealthit.org"),
    value: Some("73a7d6b7-0310-4fff-9b0b-7891a5e390f5"),
    period: None,
    assigner: None,
  ),

  Identifier(
    id: None,
    extension: [],
    use_: None,
    type_: Some(Codeableconcept(
      id: None,
      extension: [],
      coding: [
        Coding(
          id: None,
          extension: [],
          system: Some("http://terminology.hl7.org/CodeSystem/v2-0203"),
          version: None,
          code: Some("SS"),
          display: Some("Social Security Number"),
          user_selected: None,
        ),
      ],
      text: Some("Social Security Number"),
    )),
    system: Some("http://hl7.org/fhir/sid/us-ssn"),
    value: Some("999-91-2751"),
    period: None,
    assigner: None,
  ),

  Identifier(
    id: None,
    extension: [],
    use_: None,
    type_: Some(Codeableconcept(
      id: None,
      extension: [],
      coding: [
        Coding(
          id: None,
          extension: [],
          system: Some("http://terminology.hl7.org/CodeSystem/v2-0203"),
          version: None,
          code: Some("DL"),
          display: Some("Driver's License"),
          user_selected: None,
        ),
      ],
      text: Some("Driver's License"),
    )),
    system: Some("urn:oid:2.16.840.1.113883.4.3.25"),
    value: Some("S99987436"),
    period: None,
    assigner: None,
  ),

  Identifier(
    id: None,
    extension: [],
    use_: None,
    type_: Some(Codeableconcept(
      id: None,
      extension: [],
      coding: [
        Coding(
          id: None,
          extension: [],
          system: Some("http://terminology.hl7.org/CodeSystem/v2-0203"),
          version: None,
          code: Some("PPN"),
          display: Some("Passport Number"),
          user_selected: None,
        ),
      ],
      text: Some("Passport Number"),
    )),
    system: Some(
      "http://standardhealthrecord.org/fhir/StructureDefinition/passportNumber",
    ),
    value: Some("X60445896X"),
    period: None,
    assigner: None,
  ),
]
```
