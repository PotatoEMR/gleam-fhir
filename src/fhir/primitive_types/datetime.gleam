//// FHIR dateTime uses a subset of ISO 8601
//// so this is based on https://hexdocs.pm/datetime_iso8601/datetime_iso8601.html#DateTime
////
//// the goal is to make only valid times representable,
//// but also roundtrip string exactly, including millisec implicit precision

import fhir/primitive_types/shared_time_parsing.{byte_minus, byte_t_uppercase}
import gleam/dynamic/decode
import gleam/json
import gleam/option.{type Option}
import gleam/result
import gleam/string
import gleam/time/calendar

// [FHIR dateTime](https://build.fhir.org/datatypes.html#dateTime)
//
// A date, date-time or partial date (e.g., just year or year + month)
// as used in human communication. The format is a subset of [ISO8601](https://www.iso.org/iso-8601-date-and-time-format.html)
// YYYY, YYYY-MM, YYYY-MM-DD or YYYY-MM-DDThh:mm:ss+zz:zz,
// e.g., 2018, 1973-06, 1905-08-23, 2015-02-07T13:28:17-05:00 or 2017-01-01T00:00:00.000Z.
// If hours and minutes are specified, a timezone offset SHALL be populated.
// Actual timezone codes can be sent using the Timezone Code extension, if desired.
// Seconds must be provided due to schema type constraints but may be zero-filled
// and may be ignored at receiver discretion. Milliseconds are optionally allowed.
// Dates SHALL be valid dates. The time "24:00" is not allowed. Leap Seconds are allowed

pub type NanosecWithPrecision =
  shared_time_parsing.NanosecWithPrecision

pub type Timezone =
  shared_time_parsing.Timezone

pub type Sign =
  shared_time_parsing.Sign

pub type DateTime {
  Year(year: Int)
  YearMonth(year: Int, month: calendar.Month)
  YearMonthDay(year: Int, month: calendar.Month, day: Int)
  YearMonthDayTime(
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

pub fn parse(input: String) -> Result(DateTime, Nil) {
  use #(year, bytes) <- result.try(shared_time_parsing.parse_digits(
    from: <<input:utf8>>,
    count: 4,
  ))
  case bytes {
    <<>> -> Ok(Year(year))
    <<byte, rest:bytes>> if byte == byte_minus -> {
      use #(month_num, bytes) <- result.try(shared_time_parsing.parse_digits(
        from: rest,
        count: 2,
      ))
      use month <- result.try(calendar.month_from_int(month_num))
      case bytes {
        <<>> -> Ok(YearMonth(year, month))
        <<byte, rest:bytes>> if byte == byte_minus -> {
          use #(day, bytes) <- result.try(shared_time_parsing.parse_digits(
            from: rest,
            count: 2,
          ))
          use _ <- result.try(shared_time_parsing.validate_day(year, month, day))
          case bytes {
            <<>> -> Ok(YearMonthDay(year, month, day))
            _ -> parse_time_part(bytes, year, month, day)
          }
        }
        _ -> Error(Nil)
      }
    }
    _ -> Error(Nil)
  }
}

fn parse_time_part(
  bytes: BitArray,
  year: Int,
  month: calendar.Month,
  day: Int,
) -> Result(DateTime, Nil) {
  case bytes {
    <<byte, rest:bytes>> if byte == byte_t_uppercase -> {
      use #(hour, minute, second, nanosec, bytes) <- result.try(
        shared_time_parsing.parse_time_of_day(rest),
      )
      use #(timezone, bytes) <- result.try(shared_time_parsing.parse_timezone(
        bytes,
      ))
      case bytes {
        <<>> ->
          Ok(YearMonthDayTime(
            year,
            month,
            day,
            hour,
            minute,
            second,
            nanosec,
            timezone,
          ))
        _ -> Error(Nil)
      }
    }
    _ -> Error(Nil)
  }
}

pub fn to_string(dt: DateTime) -> String {
  case dt {
    Year(year) -> shared_time_parsing.n4(year)
    YearMonth(year, month) ->
      string.concat([
        shared_time_parsing.n4(year),
        "-",
        shared_time_parsing.month_to_string(month),
      ])
    YearMonthDay(year, month, day) ->
      string.concat([
        shared_time_parsing.n4(year),
        "-",
        shared_time_parsing.month_to_string(month),
        "-",
        shared_time_parsing.n2(day),
      ])
    YearMonthDayTime(year, month, day, hour, minute, second, nanosec, tz) ->
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
}

pub fn decoder() -> decode.Decoder(DateTime) {
  use s <- decode.then(decode.string)
  case parse(s) {
    Ok(dt) -> decode.success(dt)
    Error(Nil) -> decode.failure(Year(123), "DateTime")
  }
}

pub fn to_json(dt: DateTime) -> json.Json {
  json.string(to_string(dt))
}
