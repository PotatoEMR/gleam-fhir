import fhir/r4/complex_types as ct
import fhir/r4/resources

import gleam/option.{Some}

pub fn main() {
  let allergy =
    resources.Allergyintolerance(
      ..resources.allergyintolerance_new(patient: ct.Reference(
        ..ct.reference_new(),
        reference: Some("Patient/272539c2-e516-4f16-8f47-573923bf9924"),
      )),
      code: Some(
        ct.Codeableconcept(..ct.codeableconcept_new(), coding: [
          ct.Coding(
            ..ct.coding_new(),
            system: Some("http://snomed.info/sct"),
            code: Some("91936005"),
            display: Some("Allergy to penicillin"),
          ),
        ]),
      ),
    )
  echo allergy
}
