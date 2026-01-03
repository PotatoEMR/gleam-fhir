import gleeunit

/// "gleam test" runs all the whatever_test.gleam files in this folder
/// simple r4/r4b/r5 are basically same, except r5 uses codeablereference instead of codeableconcept
pub fn main() -> Nil {
  gleeunit.main()
}
