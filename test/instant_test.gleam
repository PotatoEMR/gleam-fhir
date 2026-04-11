import fhir/primitive_types as pt
import gleam/list

pub fn main() {
  invalid_test()
  roundtrip_test()
  truncate_after_nine_nanosec_test()
}

pub fn invalid_test() {
  let invalid = [
    // partial dates not allowed
    "2024",
    "2024-03",
    "2024-03-15",
    // missing timezone
    "2024-03-15T14:30:00",
    "2024-03-15T14:30:00.123",
    // missing seconds
    "2024-03-15T14:30Z",
    // 24:00 not allowed
    "2024-03-15T24:00:00Z",
    // invalid month
    "2024-00-15T14:30:00Z",
    "2024-13-15T14:30:00Z",
    // invalid day
    "2024-03-00T14:30:00Z",
    "2024-03-32T14:30:00Z",
    "2023-02-29T14:30:00Z",
    // minute out of range
    "2024-03-15T14:60:00Z",
    // second out of range
    "2024-03-15T14:30:61Z",
    // lowercase t
    "2024-03-15t14:30:00Z",
    // space instead of T
    "2024-03-15 14:30:00Z",
    // lowercase z
    "2024-03-15T14:30:00z",
    // trailing garbage
    "2024-03-15T14:30:00ZX",
    // empty
    "",
    // fraction with no digits
    "2024-03-15T14:30:00.Z",
  ]

  list.each(invalid, fn(input) {
    let assert Error(_) = pt.parse_instant(input)
      as { input <> " should be invalid" }
  })
}

pub fn roundtrip_test() {
  let valid = [
    "2024-03-15T14:30:00Z",
    "2024-03-15T14:30:00.123Z",
    "2024-03-15T14:30:00.0Z",
    "2024-03-15T14:30:00.000Z",
    "2024-03-15T14:30:00-05:10",
    "2024-03-15T14:30:00+05:10",
    "2024-03-15T14:30:00.123+09:00",
    "2024-03-15T14:30:00.123456789+09:00",
    "2024-03-15T14:30:00.40000+09:00",
    "2015-02-07T13:28:17.239+02:00",
    "2017-01-01T00:00:00Z",
    "2017-01-01T00:00:00.000Z",
    "2015-02-07T13:28:17-00:00",
    "2015-02-07T13:28:17+00:00",
    // leap second
    "2024-06-30T23:59:60Z",
    // leap day
    "2024-02-29T00:00:00Z",
    "2000-02-29T12:00:00+05:30",
  ]

  list.each(valid, fn(input) {
    let assert Ok(i) = pt.parse_instant(input)
      as { input <> " should be valid" }
    assert input == pt.instant_to_string(i)
      as { input <> " roundtrips to " <> pt.instant_to_string(i) }
  })
}

pub fn truncate_after_nine_nanosec_test() {
  let assert Ok(i) = pt.parse_instant("2024-03-15T14:30:00.1234567890+09:00")
    as "truncate parse"
  assert "2024-03-15T14:30:00.123456789+09:00" == pt.instant_to_string(i)
    as "truncate roundtrip"
}
