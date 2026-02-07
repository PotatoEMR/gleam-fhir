# Choice Element

A choice element can be one of multiple types, so in Gleam they are custom types with multiple variants. For example, Patient.multipleBirth[x] can be either multipleBirthBoolean or multipleBirthInteger, which are the the two choices for r4.PatientMultiplebirth:

![Patient.multipleBirth[x]](https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/PatientMultiplebirth.png)

```gleam
pub type PatientMultiplebirth {
  PatientMultiplebirthBoolean(multiple_birth: Bool)
  PatientMultiplebirthInteger(multiple_birth: Int)
}
```

```gleam
import fhir/r4
import gleam/int
import gleam/io
import gleam/option.{None, Some}

pub fn main() {
  let pat1 =
    r4.Patient(
      ..r4.patient_new(),
      multiple_birth: Some(r4.PatientMultiplebirthBoolean(False)),
    )
  print_order(pat1)

  let pat2 = r4.patient_new()
  print_order(pat2)

  let pat3 =
    r4.Patient(
      ..r4.patient_new(),
      multiple_birth: Some(r4.PatientMultiplebirthInteger(2)),
    )
  print_order(pat3)
}

pub fn print_order(pat: r4.Patient) {
  case pat.multiple_birth {
    None -> io.println("No birth data recorded")
    Some(r4.PatientMultiplebirthBoolean(False)) ->
      io.println("Not a multiple birth")
    Some(r4.PatientMultiplebirthBoolean(True)) ->
      io.println("Part of a multiple birth")
    Some(r4.PatientMultiplebirthInteger(order)) ->
      io.println(
        "Number " <> int.to_string(order) <> " in multiple birth sequence",
      )
  }
}
```
