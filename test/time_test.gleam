import fhir/primitive_types as pt
import gleam/list

pub fn main() {
  invalid_test()
  roundtrip_test()
  truncate_after_nine_nanosec_test()
}

pub fn invalid_test() {
  let invalid = [
    // 24:00 not allowed
    "24:00:00",
    // missing seconds
    "14:30",
    // hour out of range
    "25:00:00",
    // minute out of range
    "14:60:00",
    // second out of range (61)
    "14:30:61",
    // no timezone allowed
    "14:30:00Z",
    "14:30:00+05:00",
    // trailing garbage
    "14:30:00X",
    // too few digits
    "1:30:00",
    "14:3:00",
    "14:30:0",
    // empty
    "",
    // missing colons
    "143000",
    // fraction with no digits
    "14:30:00.",
  ]

  list.each(invalid, fn(input) {
    let assert Error(_) = pt.parse_time(input)
      as { input <> " should be invalid" }
  })
}

pub fn roundtrip_test() {
  let valid = [
    "00:00:00",
    "23:59:59",
    "12:34:56",
    "14:30:00.123",
    "14:30:00.0",
    "14:30:00.000",
    "14:30:00.123456789",
    "14:30:00.40000",
    // leap second
    "23:59:60",
    "23:59:60.999",
  ]

  list.each(valid, fn(input) {
    let assert Ok(t) = pt.parse_time(input) as { input <> " should be valid" }
    assert input == pt.time_to_string(t)
      as { input <> " roundtrips to " <> pt.time_to_string(t) }
  })
}

pub fn truncate_after_nine_nanosec_test() {
  let assert Ok(t) = pt.parse_time("14:30:00.1234567890") as "truncate parse"
  assert "14:30:00.123456789" == pt.time_to_string(t) as "truncate roundtrip"
}
