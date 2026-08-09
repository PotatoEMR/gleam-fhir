import fhir/r4/complex_types as ct
import fhir/r4/valuesets

import gleam/option.{None, Some}

pub fn main() {
  let terrible_news =
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
  echo terrible_news

  let allergy_active: ct.BoundCodeableconcept(
    valuesets.Allergyintoleranceclinical,
  ) = ct.bound_codeableconcept_new(valuesets.AllergyintoleranceclinicalActive)
  echo allergy_active.required.code
  echo valuesets.allergyintoleranceclinical_system(allergy_active.required.code)

  let other_coding_1 = ct.Coding(..ct.coding_new(), code: Some("current"), system: Some("my-made-up-system-1"))
  let other_coding_2 = ct.Coding(..ct.coding_new(), code: Some("in-progress"), system: Some("my-made-up-system-2"))
  let allergy_active = ct.BoundCodeableconcept(..allergy_active, more: [other_coding_1, other_coding_2])
  echo allergy_active
}
