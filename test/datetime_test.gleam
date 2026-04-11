import fhir/primitive_types.{
  DateTime, NanosecWithPrecision, Time, TimeAndZone, YearMonthDay, Z,
} as pt
import gleam/list
import gleam/option.{Some}
import gleam/time/calendar

pub fn main() {
  invalid_test()
  roundtrip_test()
  truncate_after_nine_nanosec_test()
}

pub fn invalid_test() {
  let invalid = [
    "2024-03-15T14",
    "2024-03-15T14:30",
    "2024-03-15T14:30:00",
    "2024-03-15T14:30:00x05:10",
    "2024-03-15T24:00:00Z",
    "2016-04-14T09:50:27",
    "2024-03-15T14:30:00.123",
    "2024-03-15T14:30.5",
    "2024-03-15T14:30.12xd3",
    "2024-03-15T14:30.12xZ",
    "2024-03-15t14:30:00Z",
    "2024-03-15 14:30:00Z",
  ]

  list.each(invalid, fn(input) {
    let assert Error(_) = pt.parse_datetime(input)
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
    "2024-03-15T14:30:00.40000+09:00",
    "2015-02-07T13:28:17-05:00",
    "2017-01-01T00:00:00.000Z",
    "2015-02-07T13:28:17-00:00",
    "2015-02-07T13:28:17+00:00",
  ]

  list.each(valid, fn(input) {
    let assert Ok(dt) = pt.parse_datetime(input)
      as { input <> " should be valid" }
    assert input == pt.datetime_to_string(dt)
      as { input <> " roundtrips to " <> pt.datetime_to_string(dt) }
  })
  let prec = NanosecWithPrecision(123_000_000, Some(3))
  let idk =
    DateTime(
      date: YearMonthDay(year: 1, month: calendar.February, day: 3),
      time: Some(TimeAndZone(
        time: Time(hour: 4, minute: 5, second: 6, nanosec: Some(prec)),
        zone: Z,
      )),
    )
  assert "0001-02-03T04:05:06.123Z" == pt.datetime_to_string(idk)
  let prec = NanosecWithPrecision(123_000, Some(5))
  let idk =
    DateTime(
      date: YearMonthDay(year: 1, month: calendar.February, day: 3),
      time: Some(TimeAndZone(
        time: Time(hour: 4, minute: 5, second: 6, nanosec: Some(prec)),
        zone: Z,
      )),
    )
    assert "0001-02-03T04:05:06.00012Z" == pt.datetime_to_string(idk)
}

pub fn truncate_after_nine_nanosec_test() {
  let assert Ok(dt) = pt.parse_datetime("2024-03-15T14:30:00.1234567890+09:00")
    as "truncate parse"
  assert "2024-03-15T14:30:00.123456789+09:00" == pt.datetime_to_string(dt)
    as "truncate roundtrip"
}
