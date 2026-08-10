import fhir/r5/complex_types as ct
import gleam/option.{Some}

pub fn main() {
  let manifestation_1 =
    ct.Codeablereference(
      ..ct.codeablereference_new(),
      reference: Some(
        ct.Reference(..ct.reference_new(), reference: Some("Observation/123")),
      ),
    )
  echo manifestation_1

  let manifestation_2 =
    ct.Codeablereference(
      ..ct.codeablereference_new(),
      concept: Some(
        ct.Codeableconcept(..ct.codeableconcept_new(), coding: [
          ct.Coding(
            ..ct.coding_new(),
            system: Some("http://snomed.info/sct"),
            code: Some("310008"),
          ),
        ]),
      ),
    )
  echo manifestation_2
}
