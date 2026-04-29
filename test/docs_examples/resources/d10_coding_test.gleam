import fhir/r4/complex_types as ct

import gleam/option.{Some}

pub fn resources_docs_10_coding_1_test() {
  let _terrible_news =
    ct.Coding(
      ..ct.coding_new(),
      system: Some("http://snomed.info/sct"),
      code: Some("267425008"),
      display: Some("Lactose intolerance"),
    )
  let _another_way_to_put_it =
    ct.Coding(
      ..ct.coding_new(),
      system: Some("http://hl7.org/fhir/sid/icd-10-cm"),
      code: Some("E73.9"),
    )
  Nil
}
