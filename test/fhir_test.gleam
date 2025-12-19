import gleam/json
import gleam/option.{Some}
import gleeunit

import fhir/r4

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  let ref = r4.reference_new()
  let myallergy =
    r4.Allergyintolerance(..r4.allergyintolerance_new(ref), id: Some("abc"))
  let json = myallergy |> r4.allergyintolerance_to_json() |> json.to_string()
  echo json
  let assert Ok(parsed_allergy) =
    json |> json.parse(r4.allergyintolerance_decoder())
  echo parsed_allergy
  assert parsed_allergy.id == myallergy.id
}
