import fhir/r4/complex_types as ct
import fhir/r4/resources
import fhir/r4/valuesets

import gleam/option.{Some}

pub fn main() {
  let pat =
    resources.Patient(..resources.patient_new(), name: [
      ct.Humanname(
        ..ct.humanname_new(),
        given: ["Samuel"],
        family: Some("Vimes"),
      ),
    ])
  let pat2 =
    resources.Patient(..resources.patient_new(), name: [
      ct.Humanname(..ct.humanname_new(), given: ["Fred"], family: Some("Colon")),
    ])
  let bundle =
    resources.Bundle(
      ..resources.bundle_new(type_: valuesets.BundletypeSearchset),
      total: Some(2),
      entry: [
        resources.BundleEntry(
          ..resources.bundle_entry_new(),
          full_url: Some("https://example.org/fhir/Patient/dsfafsdadsf"),
          resource: Some(resources.ResourcePatient(pat)),
        ),
        resources.BundleEntry(
          ..resources.bundle_entry_new(),
          full_url: Some("https://example.org/fhir/Patient/345retgsdfg"),
          resource: Some(resources.ResourcePatient(pat2)),
        ),
      ],
    )
  echo bundle
}
