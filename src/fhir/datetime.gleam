//// FHIR dateTime uses a subset of ISO 8601
//// so this is based on https://hexdocs.pm/datetime_iso8601/datetime_iso8601.html#DateTime
////
//// the goal is to make only valid times representable,
//// but also roundtrip string exactly, including millisec implicit precision

import gleam/int
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import gleam/time/calendar

const nanoseconds_per_second: Int = 1_000_000_000

const byte_colon: Int = 0x3A

const byte_minus: Int = 0x2D

const byte_plus: Int = 0x2B

const byte_dot: Int = 0x2E

const byte_zero: Int = 0x30

const byte_nine: Int = 0x39

const byte_t_uppercase: Int = 0x54

const byte_z_lowercase: Int = 0x7A

const byte_z_uppercase: Int = 0x5A

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

// millisec are optional in FHIR datetime
// and can have trailing zeros eg  2017-01-01T12:34:56.000Z
// we have to either store millisec as string or as int value + int precision
// in order to preserve string exactly in round trip
// which seems needed to match other FHIR implementations
pub type NanosecWithPrecision {
  NanosecWithPrecision(value: Int, precision: Int)
}

pub type Timezone {
  Utc
  // https://chat.fhir.org/#narrow/channel/179166-implementers/topic/Subsecond.20resolution.20of.20dateTime.20and.20instant/near/469589261
  // dateTime & instant regexes permit -00:00 as a time zone offset.
  // I don't think this offset is permitted by ISO 8601, but is
  // permitted in RFC 3339. (It means "time expressed in UTC; offset
  // to local unknown", as opposed to +00:00 which means "time expressed
  // in UTC; local time is UTC".) Does FHIR allow an offset of -00:00?
  // Yes
  Minus0000
  Offset(hours: Int, minutes: Int)
}

pub fn parse(input: String) -> Result(DateTime, Nil) {
  use #(year, bytes) <- result.try(parse_digits(from: <<input:utf8>>, count: 4))
  case bytes {
    <<>> -> Ok(Year(year))
    <<byte, rest:bytes>> if byte == byte_minus -> {
      use #(month_num, bytes) <- result.try(parse_digits(from: rest, count: 2))
      use month <- result.try(calendar.month_from_int(month_num))
      case bytes {
        <<>> -> Ok(YearMonth(year, month))
        <<byte, rest:bytes>> if byte == byte_minus -> {
          use #(day, bytes) <- result.try(parse_digits(from: rest, count: 2))
          use _ <- result.try(validate_day(year, month, day))
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
      use #(hour, bytes) <- result.try(parse_digits(from: rest, count: 2))
      use _ <- result.try(validate_hour(hour))
      case bytes {
        <<byte, rest:bytes>> if byte == byte_colon -> {
          use #(minute, bytes) <- result.try(parse_digits(from: rest, count: 2))
          use _ <- result.try(validate_minute(minute))
          case bytes {
            <<byte, rest:bytes>> if byte == byte_colon -> {
              use #(second, bytes) <- result.try(parse_digits(
                from: rest,
                count: 2,
              ))
              use _ <- result.try(validate_second(second))
              use #(nanosec, bytes) <- result.try(
                parse_optional_fraction_as_nanoseconds(bytes),
              )
              use #(timezone, bytes) <- result.try(parse_timezone(bytes))
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
        _ -> Error(Nil)
      }
    }
    _ -> Error(Nil)
  }
}

fn parse_optional_fraction_as_nanoseconds(
  bytes: BitArray,
) -> Result(#(Option(NanosecWithPrecision), BitArray), Nil) {
  case bytes {
    <<byte, rest:bytes>> if byte == byte_dot -> {
      use #(ns, bytes) <- result.try(parse_fraction_as_nanoseconds(rest))
      Ok(#(Some(ns), bytes))
    }
    _ -> Ok(#(None, bytes))
  }
}

fn parse_fraction_as_nanoseconds(
  bytes: BitArray,
) -> Result(#(NanosecWithPrecision, BitArray), Nil) {
  case bytes {
    <<byte, rest:bytes>> if byte >= byte_zero && byte <= byte_nine -> {
      parse_fraction_as_nanoseconds_loop(
        <<byte, rest:bits>>,
        0,
        nanoseconds_per_second,
        0,
      )
    }
    _ -> Error(Nil)
  }
}

fn parse_fraction_as_nanoseconds_loop(
  bytes: BitArray,
  acc: Int,
  power: Int,
  digits: Int,
) -> Result(#(NanosecWithPrecision, BitArray), Nil) {
  let power = power / 10
  case bytes {
    <<byte, rest:bytes>> if byte >= byte_zero && byte <= byte_nine && power < 1 -> {
      // Truncate remaining digits beyond nanosecond precision
      parse_fraction_as_nanoseconds_loop(rest, acc, power, digits)
    }
    <<byte, rest:bytes>> if byte >= byte_zero && byte <= byte_nine -> {
      let digit = byte - byte_zero
      parse_fraction_as_nanoseconds_loop(
        rest,
        acc + digit * power,
        power,
        digits + 1,
      )
    }
    _ -> Ok(#(NanosecWithPrecision(acc, digits), bytes))
  }
}

fn parse_timezone(
  bytes: BitArray,
) -> Result(#(Timezone, BitArray), Nil) {
  case bytes {
    <<byte, rest:bytes>>
      if byte == byte_z_uppercase || byte == byte_z_lowercase
    -> Ok(#(Utc, rest))
    <<byte, _:bytes>> if byte == byte_plus || byte == byte_minus ->
      parse_timezone_offset(bytes)
    _ -> Error(Nil)
  }
}

fn parse_timezone_offset(
  bytes: BitArray,
) -> Result(#(Timezone, BitArray), Nil) {
  use #(sign, bytes) <- result.try(parse_sign(bytes))
  use #(hours, bytes) <- result.try(parse_digits(from: bytes, count: 2))
  case bytes {
    <<byte, rest:bytes>> if byte == byte_colon -> {
      use #(minutes, bytes) <- result.try(parse_digits(from: rest, count: 2))
      case sign, hours, minutes {
        "-", 0, 0 -> Ok(#(Minus0000, bytes))
        "-", _, _ -> Ok(#(Offset(-hours, -minutes), bytes))
        _, _, _ -> Ok(#(Offset(hours, minutes), bytes))
      }
    }
    _ -> Error(Nil)
  }
}

fn parse_sign(bytes: BitArray) -> Result(#(String, BitArray), Nil) {
  case bytes {
    <<byte, rest:bytes>> if byte == byte_plus -> Ok(#("+", rest))
    <<byte, rest:bytes>> if byte == byte_minus -> Ok(#("-", rest))
    _ -> Error(Nil)
  }
}

fn parse_digits(
  from bytes: BitArray,
  count count: Int,
) -> Result(#(Int, BitArray), Nil) {
  parse_digits_loop(bytes, count, 0, 0)
}

fn parse_digits_loop(
  bytes: BitArray,
  count: Int,
  acc: Int,
  k: Int,
) -> Result(#(Int, BitArray), Nil) {
  case bytes {
    _ if k >= count -> Ok(#(acc, bytes))
    <<byte, rest:bytes>> if byte >= byte_zero && byte <= byte_nine ->
      parse_digits_loop(rest, count, acc * 10 + { byte - byte_zero }, k + 1)
    _ -> Error(Nil)
  }
}

fn validate_day(year: Int, month: calendar.Month, day: Int) -> Result(Nil, Nil) {
  let max_day = case month {
    calendar.January
    | calendar.March
    | calendar.May
    | calendar.July
    | calendar.August
    | calendar.October
    | calendar.December -> 31
    calendar.April | calendar.June | calendar.September | calendar.November ->
      30
    calendar.February ->
      case is_leap_year(year) {
        True -> 29
        False -> 28
      }
  }
  case day >= 1 && day <= max_day {
    True -> Ok(Nil)
    False -> Error(Nil)
  }
}

fn is_leap_year(year: Int) -> Bool {
  year % 4 == 0 && { year % 100 != 0 || year % 400 == 0 }
}

fn validate_hour(hour: Int) -> Result(Nil, Nil) {
  case hour >= 0 && hour <= 23 {
    True -> Ok(Nil)
    False -> Error(Nil)
  }
}

fn validate_minute(minute: Int) -> Result(Nil, Nil) {
  case minute >= 0 && minute <= 59 {
    True -> Ok(Nil)
    False -> Error(Nil)
  }
}

fn validate_second(second: Int) -> Result(Nil, Nil) {
  case second >= 0 && second <= 59 {
    True -> Ok(Nil)
    False -> Error(Nil)
  }
}

pub fn to_string(dt: DateTime) -> String {
  case dt {
    Year(year) -> n4(year)
    YearMonth(year, month) ->
      string.concat([n4(year), "-", month_to_string(month)])
    YearMonthDay(year, month, day) ->
      string.concat([n4(year), "-", month_to_string(month), "-", n2(day)])
    YearMonthDayTime(year, month, day, hour, minute, second, nanosec, tz) ->
      string.concat([
        n4(year),
        "-",
        month_to_string(month),
        "-",
        n2(day),
        "T",
        n2(hour),
        ":",
        n2(minute),
        ":",
        n2(second),
        nanosec_to_string(nanosec),
        timezone_to_string(tz),
      ])
  }
}

fn nanosec_to_string(nanosec: Option(NanosecWithPrecision)) -> String {
  case nanosec {
    None -> ""
    Some(NanosecWithPrecision(value, digits)) -> {
      let all = int.to_string(value) |> string.pad_start(9, "0")
      "." <> string.slice(all, 0, digits)
    }
  }
}

fn timezone_to_string(tz: Timezone) -> String {
  case tz {
    Utc -> "Z"
    Minus0000 -> "-00:00"
    Offset(hours, minutes) ->
      case hours >= 0 {
        True -> string.concat(["+", n2(hours), ":", n2(minutes)])
        False ->
          string.concat([
            "-",
            n2(int.absolute_value(hours)),
            ":",
            n2(int.absolute_value(minutes)),
          ])
      }
  }
}

fn n2(d: Int) -> String {
  int.to_string(d) |> string.pad_start(2, "0")
}

fn n4(d: Int) -> String {
  int.to_string(d) |> string.pad_start(4, "0")
}

fn month_to_string(month: calendar.Month) -> String {
  case month {
    calendar.January -> "01"
    calendar.February -> "02"
    calendar.March -> "03"
    calendar.April -> "04"
    calendar.May -> "05"
    calendar.June -> "06"
    calendar.July -> "07"
    calendar.August -> "08"
    calendar.September -> "09"
    calendar.October -> "10"
    calendar.November -> "11"
    calendar.December -> "12"
  }
}
