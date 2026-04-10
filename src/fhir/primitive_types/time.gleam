//// A time during the day, in the format hh:mm:ss
//// a subset of [ISO8601](https://www.iso.org/iso-8601-date-and-time-format.html)
//// There is no date specified. Seconds must be provided due to schema type constraints
//// but may be zero-filled and may be ignored at receiver discretion.
//// The time "24:00" SHALL NOT be used. A timezone offset SHALL NOT be present.
//// Times can be converted to a Duration since midnight.
//// Regex: ([01][0-9]|2[0-3]):[0-5][0-9]:([0-5][0-9]|60)(\.[0-9]{1,9})?

import fhir/primitive_types/shared_time_parsing
import gleam/dynamic/decode
import gleam/json
import gleam/option.{type Option, None}
import gleam/result

pub type NanosecWithPrecision =
  shared_time_parsing.NanosecWithPrecision

pub type Time {
  Time(
    hour: Int,
    minute: Int,
    second: Int,
    nanosec: Option(NanosecWithPrecision),
  )
}

pub fn parse(input: String) -> Result(Time, Nil) {
  use #(hour, minute, second, nanosec, bytes) <- result.try(
    shared_time_parsing.parse_time_of_day(<<input:utf8>>),
  )
  case bytes {
    <<>> -> Ok(Time(hour, minute, second, nanosec))
    _ -> Error(Nil)
  }
}

pub fn to_string(time: Time) -> String {
  let Time(hour, minute, second, nanosec) = time
  shared_time_parsing.time_of_day_to_string(hour, minute, second, nanosec)
}

pub fn decoder() -> decode.Decoder(Time) {
  use s <- decode.then(decode.string)
  case parse(s) {
    Ok(t) -> decode.success(t)
    Error(Nil) -> decode.failure(Time(0, 0, 0, None), "Time")
  }
}

pub fn to_json(time: Time) -> json.Json {
  json.string(to_string(time))
}
