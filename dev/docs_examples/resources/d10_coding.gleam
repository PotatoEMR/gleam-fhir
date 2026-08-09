import fhir/r4/complex_types as ct
import fhir/r4/valuesets
import gleam/option.{Some}

pub fn main() {
  let terrible_news =
    ct.Coding(
      ..ct.coding_new(),
      system: Some("http://snomed.info/sct"),
      code: Some("267425008"),
      display: Some("Lactose intolerance"),
    )
  echo terrible_news
  let another_way_to_put_it =
    ct.Coding(
      ..ct.coding_new(),
      system: Some("http://hl7.org/fhir/sid/icd-10-cm"),
      code: Some("E73.9"),
    )
  echo another_way_to_put_it

  let allergy_active: ct.BoundCoding(valuesets.Allergyintoleranceclinical) =
    ct.bound_coding_new(valuesets.AllergyintoleranceclinicalActive)
  echo allergy_active.code
  echo valuesets.allergyintoleranceclinical_to_code(allergy_active.code)
  echo valuesets.allergyintoleranceclinical_system(allergy_active.code)

  let assert Ok(inactive_code) =
    valuesets.allergyintoleranceclinical_from_code_and_system(
      code: "inactive",
      system: "http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical",
    )
  let allergy_inactive = ct.bound_coding_new(inactive_code)
  echo allergy_inactive.code
}
