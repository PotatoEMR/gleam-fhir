import fhir/r4/resources

import gleam/int
import gleam/io
import gleam/option.{None, Some}

pub fn main() {
  let pat1 =
    resources.Patient(
      ..resources.patient_new(),
      multiple_birth: Some(resources.PatientMultiplebirthBoolean(False)),
    )
  print_order(pat1)

  let pat2 = resources.patient_new()
  print_order(pat2)

  let pat3 =
    resources.Patient(
      ..resources.patient_new(),
      multiple_birth: Some(resources.PatientMultiplebirthInteger(2)),
    )
  print_order(pat3)
}

fn print_order(pat: resources.Patient) {
  case pat.multiple_birth {
    None -> io.println("No birth data recorded")
    Some(resources.PatientMultiplebirthBoolean(False)) ->
      io.println("Not a multiple birth")
    Some(resources.PatientMultiplebirthBoolean(True)) ->
      io.println("Part of a multiple birth")
    Some(resources.PatientMultiplebirthInteger(order)) ->
      io.println(
        "Number " <> int.to_string(order) <> " in multiple birth sequence",
      )
  }
}
