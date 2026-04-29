import fhir/r4/complex_types as ct

import gleam/option.{None, Some}

pub fn resources_docs_11_codeableconcept_1_test() {
  let _terrible_news =
    ct.Codeableconcept(
      id: None,
      extension: [],
      coding: [
        ct.Coding(
          ..ct.coding_new(),
          system: Some("http://snomed.info/sct"),
          code: Some("267425008"),
          display: Some("Lactose intolerance"),
        ),
        ct.Coding(
          ..ct.coding_new(),
          system: Some("http://hl7.org/fhir/sid/icd-10-cm"),
          code: Some("E73.9"),
        ),
      ],
      text: Some("Lactose intolerance"),
    )
  Nil
}
