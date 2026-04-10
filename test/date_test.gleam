import fhir/primitive_types/date
import gleam/list

pub fn main() {
  invalid_test()
  roundtrip_test()
}

pub fn invalid_test() {
  let invalid = [
    // no timezone allowed
    "2024-03-15T14:30:00Z",
    "2024-03-15Z",
    // invalid months
    "2024-00",
    "2024-13",
    // invalid days
    "2024-03-00",
    "2024-03-32",
    "2024-02-30",
    "2023-02-29",
    // trailing garbage
    "2024-03-15X",
    "2024-03X",
    // too few digits
    "202",
    "2024-3",
    "2024-03-1",
    // empty
    "",
    // lowercase or spaces
    "abcd",
  ]

  list.each(invalid, fn(input) {
    let assert Error(_) = date.parse(input) as { input <> " should be invalid" }
  })
}

pub fn roundtrip_test() {
  let valid = [
    "2024",
    "2018",
    "1973-06",
    "2024-03",
    "2024-12",
    "1905-08-23",
    "2024-03-15",
    "2024-02-29",
    "2000-02-29",
    "1900-02-28",
    "2024-01-31",
    "2024-06-30",
  ]

  list.each(valid, fn(input) {
    let assert Ok(d) = date.parse(input) as { input <> " should be valid" }
    assert input == date.to_string(d)
      as { input <> " roundtrips to " <> date.to_string(d) }
  })
}
