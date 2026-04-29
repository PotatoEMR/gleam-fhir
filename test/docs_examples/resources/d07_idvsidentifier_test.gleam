import fhir/r4/complex_types as ct

import gleam/option.{None, Some}

pub fn resources_docs_07_idvsidentifier_1_test() {
  let _identifier_list = [
    ct.Identifier(
      id: None,
      extension: [],
      use_: None,
      type_: None,
      system: Some("https://github.com/synthetichealth/synthea"),
      value: Some("73a7d6b7-0310-4fff-9b0b-7891a5e390f5"),
      period: None,
      assigner: None,
    ),
    ct.Identifier(
      id: None,
      extension: [],
      use_: None,
      type_: Some(ct.Codeableconcept(
        id: None,
        extension: [],
        coding: [
          ct.Coding(
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
    ct.Identifier(
      id: None,
      extension: [],
      use_: None,
      type_: Some(ct.Codeableconcept(
        id: None,
        extension: [],
        coding: [
          ct.Coding(
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
    ct.Identifier(
      id: None,
      extension: [],
      use_: None,
      type_: Some(ct.Codeableconcept(
        id: None,
        extension: [],
        coding: [
          ct.Coding(
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
    ct.Identifier(
      id: None,
      extension: [],
      use_: None,
      type_: Some(ct.Codeableconcept(
        id: None,
        extension: [],
        coding: [
          ct.Coding(
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
  Nil
}
