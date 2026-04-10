//// An instant in time in a format that is a subset of
//// [ISO8601](https://www.iso.org/iso-8601-date-and-time-format.html)
//// YYYY-MM-DDThh:mm:ss.sss+zz:zz (e.g., 2015-02-07T13:28:17.239+02:00 or 2017-01-01T00:00:00Z).
//// The time SHALL specified at least to the second and SHALL include a timezone offset.
//// Sub-millisecond precision is optionally allowed.
//// Note: This is intended for when precisely observed times are required (typically system logs etc.),
//// and not human-reported times - for those, use date or dateTime.
//// Regex: ([0-9]([0-9]([0-9][1-9]|[1-9]0)|[1-9]00)|[1-9]000)-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])T([01][0-9]|2[0-3]):[0-5][0-9]:([0-5][0-9]|60)(\.[0-9]{1,9})?(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))

import fhir/primitive_types/shared_time_parsing.{Z, byte_minus, byte_t_uppercase}
import gleam/dynamic/decode
import gleam/json
import gleam/option.{type Option, None}
import gleam/result
import gleam/string
import gleam/time/calendar

pub type NanosecWithPrecision =
  shared_time_parsing.NanosecWithPrecision

pub type Timezone =
  shared_time_parsing.Timezone

pub type Sign =
  shared_time_parsing.Sign

pub type Instant {
  Instant(
    year: Int,
    month: calendar.Month,
    day: Int,
    hour: Int,
    minute: Int,
    second: Int,
    nanosec: Option(NanosecWithPrecision),
    timezone: Timezone,
  )
}

pub fn parse(input: String) -> Result(Instant, Nil) {
  let bytes = <<input:utf8>>
  use #(year, bytes) <- result.try(shared_time_parsing.parse_digits(
    from: bytes,
    count: 4,
  ))
  use bytes <- result.try(shared_time_parsing.expect_byte(bytes, byte_minus))
  use #(month_num, bytes) <- result.try(shared_time_parsing.parse_digits(
    from: bytes,
    count: 2,
  ))
  use month <- result.try(calendar.month_from_int(month_num))
  use bytes <- result.try(shared_time_parsing.expect_byte(bytes, byte_minus))
  use #(day, bytes) <- result.try(shared_time_parsing.parse_digits(
    from: bytes,
    count: 2,
  ))
  use _ <- result.try(shared_time_parsing.validate_day(year, month, day))
  use bytes <- result.try(shared_time_parsing.expect_byte(
    bytes,
    byte_t_uppercase,
  ))
  use #(hour, minute, second, nanosec, bytes) <- result.try(
    shared_time_parsing.parse_time_of_day(bytes),
  )
  use #(timezone, bytes) <- result.try(shared_time_parsing.parse_timezone(bytes))
  case bytes {
    <<>> ->
      Ok(Instant(year, month, day, hour, minute, second, nanosec, timezone))
    _ -> Error(Nil)
  }
}

pub fn to_string(instant: Instant) -> String {
  let Instant(year, month, day, hour, minute, second, nanosec, tz) = instant
  string.concat([
    shared_time_parsing.n4(year),
    "-",
    shared_time_parsing.month_to_string(month),
    "-",
    shared_time_parsing.n2(day),
    "T",
    shared_time_parsing.time_of_day_to_string(hour, minute, second, nanosec),
    shared_time_parsing.timezone_to_string(tz),
  ])
}

pub fn decoder() -> decode.Decoder(Instant) {
  use s <- decode.then(decode.string)
  case parse(s) {
    Ok(i) -> decode.success(i)
    Error(Nil) ->
      decode.failure(
        Instant(0, calendar.January, 1, 0, 0, 0, None, Z),
        "Instant",
      )
  }
}

pub fn to_json(instant: Instant) -> json.Json {
  json.string(to_string(instant))
}
