import fhir/datetime
import gleam/list

pub fn main() {
  invalid_test()
  roundtrip_test()
  truncate_after_nine_nanosec_test()
}

pub fn invalid_test() {
  let invalid = [
    "2024-03-15T14:30:00x05:10",
    "2024-03-15T24:00:00Z",
    "2016-04-14T09:50:27",
    "2024-03-15T14:30:00.123",
    "2024-03-15T14:30.5",
    "2024-03-15T14:30.12xd3",
    "2024-03-15T14:30.12xZ",
  ]

  list.each(invalid, fn(input) {
    let assert Error(_) = datetime.parse(input)
      as { input <> " should be invalid" }
  })
}

pub fn roundtrip_test() {
  let valid = [
    "2024",
    "2018",
    "2024-03",
    "1973-06",
    "2024-03-15",
    "1905-08-23",
    "2024-03-15T14:30:00Z",
    "2024-03-15T14:30:00.123Z",
    "2024-03-15T14:30:00.0Z",
    "2024-03-15T14:30:00-05:10",
    "2024-03-15T14:30:00+05:10",
    "2024-03-15T14:30:00.123+09:00",
    "2024-03-15T14:30:00.123456789+09:00",
    "2015-02-07T13:28:17-05:00",
    "2017-01-01T00:00:00.000Z",
  ]

  list.each(valid, fn(input) {
    let assert Ok(dt) = datetime.parse(input) as { input <> " should be valid" }
    assert datetime.to_string(dt) == datetime.to_string(dt)
      as { datetime.to_string(dt) <> " should roundtrip to " <> input }
  })
}

pub fn truncate_after_nine_nanosec_test() {
  let assert Ok(dt) = datetime.parse("2024-03-15T14:30:00.1234567890+09:00")
    as "truncate parse"
  assert "2024-03-15T14:30:00.123456789+09:00" == datetime.to_string(dt)
    as "truncate roundtrip"
}
