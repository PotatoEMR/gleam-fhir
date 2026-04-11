//// parsing logic common to date, datetime, instant, time
//// FHIR dateTime uses a subset of ISO 8601
//// so this is based on https://hexdocs.pm/datetime_iso8601/datetime_iso8601.html#DateTime
////
//// the goal is to make only valid times representable,
//// but also roundtrip string exactly, including millisec implicit precision

import gleam/dynamic/decode
import gleam/int
import gleam/json
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import gleam/time/calendar

const nanoseconds_per_second: Int = 1_000_000_000

pub const byte_colon: Int = 0x3A

pub const byte_minus: Int = 0x2D

pub const byte_plus: Int = 0x2B

pub const byte_dot: Int = 0x2E

pub const byte_zero: Int = 0x30

pub const byte_nine: Int = 0x39

pub const byte_t_uppercase: Int = 0x54

pub const byte_z_uppercase: Int = 0x5A

/// part of time after decimal point
/// where precision is number of digits after decimal point
/// and value is nanoseconds
/// eg 123_000_000 nanoseconds = 0.123 seconds
/// NanosecWithPrecision(123_000_000, Some(3)) -> .123
/// NanosecWithPrecision(123_000_000, Some(4)) -> .1230
/// NanosecWithPrecision(123_000, Some(5)) -> .00012
pub type NanosecWithPrecision {
  NanosecWithPrecision(value: Int, precision: Option(Int))
}

pub type Timezone {
  // a timezone offset in hours or minutes
  // in form +HH:MM or -HH:MM
  // eg +12:34 or -03:30
  // I believe the regex does not allow timezone offsets greater than 14 hours
  // but that's not strictly enforced here
  // -00:00 is distinct from +00:00
  Offset(sign: Sign, hours: Int, minutes: Int)
  // Z indicates UTC
  // timezone offset equivalent to Offset(Plus, 0, 0)
  Z
}

pub type Sign {
  Plus
  Minus
}

pub fn expect_byte(bytes: BitArray, expected: Int) -> Result(BitArray, Nil) {
  case bytes {
    <<byte, rest:bytes>> -> {
      case byte == expected {
        True -> Ok(rest)
        False -> Error(Nil)
      }
    }
    _ -> Error(Nil)
  }
}

pub fn parse_digits(
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
  case k >= count {
    True -> Ok(#(acc, bytes))
    False ->
      case bytes {
        <<byte, rest:bytes>> -> {
          case byte >= byte_zero && byte <= byte_nine {
            True ->
              parse_digits_loop(
                rest,
                count,
                acc * 10 + { byte - byte_zero },
                k + 1,
              )
            False -> Error(Nil)
          }
        }
        _ -> Error(Nil)
      }
  }
}

pub fn validate_day(
  year: Int,
  month: calendar.Month,
  day: Int,
) -> Result(Nil, Nil) {
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
      case year % 4 == 0 && { year % 100 != 0 || year % 400 == 0 } {
        True -> 29
        False -> 28
      }
  }
  case day >= 1 && day <= max_day {
    True -> Ok(Nil)
    False -> Error(Nil)
  }
}

pub fn validate_hour(hour: Int) -> Result(Nil, Nil) {
  case hour >= 0 && hour <= 23 {
    True -> Ok(Nil)
    False -> Error(Nil)
  }
}

pub fn validate_minute(minute: Int) -> Result(Nil, Nil) {
  case minute >= 0 && minute <= 59 {
    True -> Ok(Nil)
    False -> Error(Nil)
  }
}

pub fn validate_second(second: Int) -> Result(Nil, Nil) {
  // Leap seconds allowed per FHIR spec
  case second >= 0 && second <= 60 {
    True -> Ok(Nil)
    False -> Error(Nil)
  }
}

pub fn parse_time_of_day(
  bytes: BitArray,
) -> Result(#(Int, Int, Int, Option(NanosecWithPrecision), BitArray), Nil) {
  use #(hour, bytes) <- result.try(parse_digits(from: bytes, count: 2))
  use _ <- result.try(validate_hour(hour))
  use bytes <- result.try(expect_byte(bytes, byte_colon))
  use #(minute, bytes) <- result.try(parse_digits(from: bytes, count: 2))
  use _ <- result.try(validate_minute(minute))
  use bytes <- result.try(expect_byte(bytes, byte_colon))
  use #(second, bytes) <- result.try(parse_digits(from: bytes, count: 2))
  use _ <- result.try(validate_second(second))
  use #(nanosec, bytes) <- result.try(parse_optional_fraction_as_nanoseconds(
    bytes,
  ))
  Ok(#(hour, minute, second, nanosec, bytes))
}

pub fn time_of_day_to_string(
  hour: Int,
  minute: Int,
  second: Int,
  nanosec: Option(NanosecWithPrecision),
) -> String {
  string.concat([
    n2(hour),
    ":",
    n2(minute),
    ":",
    n2(second),
    nanosec_to_string(nanosec),
  ])
}

pub fn parse_optional_fraction_as_nanoseconds(
  bytes: BitArray,
) -> Result(#(Option(NanosecWithPrecision), BitArray), Nil) {
  case bytes {
    <<byte, rest:bytes>> -> {
      case byte == byte_dot {
        True -> {
          use #(ns, bytes) <- result.try(parse_fraction_as_nanoseconds(rest))
          Ok(#(Some(ns), bytes))
        }
        False -> Ok(#(None, <<byte, rest:bits>>))
      }
    }
    _ -> Ok(#(None, bytes))
  }
}

fn parse_fraction_as_nanoseconds(
  bytes: BitArray,
) -> Result(#(NanosecWithPrecision, BitArray), Nil) {
  case bytes {
    <<byte, _:bytes>> -> {
      case byte >= byte_zero && byte <= byte_nine {
        True ->
          parse_fraction_as_nanoseconds_loop(
            bytes,
            0,
            nanoseconds_per_second,
            0,
          )
        False -> Error(Nil)
      }
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
    <<byte, rest:bytes>> -> {
      case byte >= byte_zero && byte <= byte_nine {
        True -> {
          case power < 1 {
            True -> parse_fraction_as_nanoseconds_loop(rest, acc, power, digits)
            False -> {
              let digit = byte - byte_zero
              parse_fraction_as_nanoseconds_loop(
                rest,
                acc + digit * power,
                power,
                digits + 1,
              )
            }
          }
        }
        False -> Ok(#(NanosecWithPrecision(acc, Some(digits)), bytes))
      }
    }
    _ -> Ok(#(NanosecWithPrecision(acc, Some(digits)), bytes))
  }
}

pub fn parse_timezone(bytes: BitArray) -> Result(#(Timezone, BitArray), Nil) {
  case bytes {
    <<byte, rest:bytes>> -> {
      case byte == byte_z_uppercase {
        True -> Ok(#(Z, rest))
        False -> {
          case byte == byte_plus || byte == byte_minus {
            True -> parse_timezone_offset(<<byte, rest:bits>>)
            False -> Error(Nil)
          }
        }
      }
    }
    _ -> Error(Nil)
  }
}

fn parse_timezone_offset(bytes: BitArray) -> Result(#(Timezone, BitArray), Nil) {
  use #(sign, bytes) <- result.try(parse_sign(bytes))
  use #(hours, bytes) <- result.try(parse_digits(from: bytes, count: 2))
  use bytes <- result.try(expect_byte(bytes, byte_colon))
  use #(minutes, bytes) <- result.try(parse_digits(from: bytes, count: 2))
  Ok(#(Offset(sign, hours, minutes), bytes))
}

fn parse_sign(bytes: BitArray) -> Result(#(Sign, BitArray), Nil) {
  case bytes {
    <<byte, rest:bytes>> -> {
      case byte == byte_plus {
        True -> Ok(#(Plus, rest))
        False -> {
          case byte == byte_minus {
            True -> Ok(#(Minus, rest))
            False -> Error(Nil)
          }
        }
      }
    }
    _ -> Error(Nil)
  }
}

pub fn nanosec_to_string(nanosec: Option(NanosecWithPrecision)) -> String {
  case nanosec {
    None -> ""
    Some(NanosecWithPrecision(value, Some(digits))) -> {
      let all = int.to_string(value) |> string.pad_start(9, "0")
      "." <> string.slice(all, 0, digits)
    }
    Some(NanosecWithPrecision(value, None)) -> {
      let all = int.to_string(value) |> string.pad_start(9, "0")
      "." <> all
    }
  }
}

pub fn timezone_to_string(tz: Timezone) -> String {
  case tz {
    Z -> "Z"
    Offset(Plus, hours, minutes) ->
      string.concat(["+", n2(hours), ":", n2(minutes)])
    Offset(Minus, hours, minutes) ->
      string.concat(["-", n2(hours), ":", n2(minutes)])
  }
}

pub fn n2(d: Int) -> String {
  int.to_string(d) |> string.pad_start(2, "0")
}

pub fn n4(d: Int) -> String {
  int.to_string(d) |> string.pad_start(4, "0")
}

pub fn month_to_string(month: calendar.Month) -> String {
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

// --------------------------------Date---------------------------------------------------------

/// A date, or partial date (e.g., just year or year + month) as used in human communication.
/// The format is a subset of [ISO8601] icon: YYYY, YYYY-MM, or YYYY-MM-DD,
/// e.g., 2018, 1973-06, or 1905-08-23. There SHALL be no timezone offset.
/// Dates SHALL be valid dates.
/// Regex: ([0-9]([0-9]([0-9][1-9]|[1-9]0)|[1-9]00)|[1-9]000)(-(0[1-9]|1[0-2])(-(0[1-9]|[1-2][0-9]|3[0-1]))?)?
pub type Date {
  Year(year: Int)
  YearMonth(year: Int, month: calendar.Month)
  YearMonthDay(year: Int, month: calendar.Month, day: Int)
}

pub fn parse_date(input: String) -> Result(Date, Nil) {
  use #(year, bytes) <- result.try(parse_digits(from: <<input:utf8>>, count: 4))
  case bytes {
    <<>> -> Ok(Year(year))
    <<byte, rest:bytes>> -> {
      case byte == byte_minus {
        True -> {
          use #(month_num, bytes) <- result.try(parse_digits(
            from: rest,
            count: 2,
          ))
          use month <- result.try(calendar.month_from_int(month_num))
          case bytes {
            <<>> -> Ok(YearMonth(year, month))
            <<byte, rest:bytes>> -> {
              case byte == byte_minus {
                True -> {
                  use #(day, bytes) <- result.try(parse_digits(
                    from: rest,
                    count: 2,
                  ))
                  use _ <- result.try(validate_day(year, month, day))
                  case bytes {
                    <<>> -> Ok(YearMonthDay(year, month, day))
                    _ -> Error(Nil)
                  }
                }
                False -> Error(Nil)
              }
            }
            _ -> Error(Nil)
          }
        }
        False -> Error(Nil)
      }
    }
    _ -> Error(Nil)
  }
}

pub fn date_to_string(date: Date) -> String {
  case date {
    Year(year) -> n4(year)
    YearMonth(year, month) ->
      string.concat([
        n4(year),
        "-",
        month_to_string(month),
      ])
    YearMonthDay(year, month, day) ->
      string.concat([
        n4(year),
        "-",
        month_to_string(month),
        "-",
        n2(day),
      ])
  }
}

pub fn date_decoder() -> decode.Decoder(Date) {
  use s <- decode.then(decode.string)
  case parse_date(s) {
    Ok(d) -> decode.success(d)
    Error(Nil) -> decode.failure(Year(123), "Date")
  }
}

pub fn date_to_json(date: Date) -> json.Json {
  json.string(date_to_string(date))
}

//-------------------------------------------time----------------------------------------

/// A time during the day, in the format hh:mm:ss
/// a subset of [ISO8601](https://www.iso.org/iso-8601-date-and-time-format.html)
/// There is no date specified. Seconds must be provided due to schema type constraints
/// but may be zero-filled and may be ignored at receiver discretion.
/// The time "24:00" SHALL NOT be used. A timezone offset SHALL NOT be present.
/// Times can be converted to a Duration since midnight.
/// Regex: ([01][0-9]|2[0-3]):[0-5][0-9]:([0-5][0-9]|60)(\.[0-9]{1,9})?
pub type Time {
  Time(
    hour: Int,
    minute: Int,
    second: Int,
    nanosec: Option(NanosecWithPrecision),
  )
}

pub fn parse_time(input: String) -> Result(Time, Nil) {
  use #(hour, minute, second, nanosec, bytes) <- result.try(
    parse_time_of_day(<<input:utf8>>),
  )
  case bytes {
    <<>> -> Ok(Time(hour, minute, second, nanosec))
    _ -> Error(Nil)
  }
}

pub fn time_to_string(time: Time) -> String {
  let Time(hour, minute, second, nanosec) = time
  time_of_day_to_string(hour, minute, second, nanosec)
}

pub fn time_decoder() -> decode.Decoder(Time) {
  use s <- decode.then(decode.string)
  case parse_time(s) {
    Ok(t) -> decode.success(t)
    Error(Nil) -> decode.failure(Time(0, 0, 0, None), "Time")
  }
}

pub fn time_to_json(time: Time) -> json.Json {
  json.string(time_to_string(time))
}

//----------------------------------------datetime----------------------------------------

// [FHIR dateTime](https://build.fhir.org/datatypes.html#dateTime)
// uses a subset of ISO 8601
// so this is based on https://hexdocs.pm/datetime_iso8601/datetime_iso8601.html#DateTime
//
// the goal is to make only valid times representable,
// but also roundtrip string exactly, including millisec implicit precision

/// A date, date-time or partial date (e.g., just year or year + month)
/// as used in human communication. The format is a subset of [ISO8601](https://www.iso.org/iso-8601-date-and-time-format.html)
/// YYYY, YYYY-MM, YYYY-MM-DD or YYYY-MM-DDThh:mm:ss+zz:zz,
/// e.g., 2018, 1973-06, 1905-08-23, 2015-02-07T13:28:17-05:00 or 2017-01-01T00:00:00.000Z.
/// If hours and minutes are specified, a timezone offset SHALL be populated.
/// Actual timezone codes can be sent using the Timezone Code extension, if desired.
/// Seconds must be provided due to schema type constraints but may be zero-filled
/// and may be ignored at receiver discretion. Milliseconds are optionally allowed.
/// Dates SHALL be valid dates. The time "24:00" is not allowed. Leap Seconds are allowed
pub type DateTime {
  DateTime(date: Date, time: Option(TimeAndZone))
}

pub type TimeAndZone {
  TimeAndZone(time: Time, zone: Timezone)
}

pub fn parse_datetime(input: String) -> Result(DateTime, Nil) {
  use #(year, bytes) <- result.try(parse_digits(from: <<input:utf8>>, count: 4))
  case bytes {
    <<>> -> Ok(DateTime(Year(year), None))
    <<byte, rest:bytes>> if byte == byte_minus -> {
      use #(month_num, bytes) <- result.try(parse_digits(from: rest, count: 2))
      use month <- result.try(calendar.month_from_int(month_num))
      case bytes {
        <<>> -> Ok(DateTime(YearMonth(year, month), None))
        <<byte, rest:bytes>> if byte == byte_minus -> {
          use #(day, bytes) <- result.try(parse_digits(from: rest, count: 2))
          use _ <- result.try(validate_day(year, month, day))
          case bytes {
            <<>> -> Ok(DateTime(YearMonthDay(year, month, day), None))
            _ -> parse_datetime_time_part(bytes, YearMonthDay(year, month, day))
          }
        }
        _ -> Error(Nil)
      }
    }
    _ -> Error(Nil)
  }
}

fn parse_datetime_time_part(
  bytes: BitArray,
  date: Date,
) -> Result(DateTime, Nil) {
  case bytes {
    <<byte, rest:bytes>> if byte == byte_t_uppercase -> {
      use #(hour, minute, second, nanosec, bytes) <- result.try(
        parse_time_of_day(rest),
      )
      use #(timezone, bytes) <- result.try(parse_timezone(bytes))
      case bytes {
        <<>> ->
          Ok(DateTime(
            date,
            Some(TimeAndZone(Time(hour, minute, second, nanosec), timezone)),
          ))
        _ -> Error(Nil)
      }
    }
    _ -> Error(Nil)
  }
}

pub fn datetime_to_string(dt: DateTime) -> String {
  let DateTime(date, time) = dt
  case time {
    None -> date_to_string(date)
    Some(TimeAndZone(t, tz)) ->
      string.concat([
        date_to_string(date),
        "T",
        time_to_string(t),
        timezone_to_string(tz),
      ])
  }
}

pub fn datetime_decoder() -> decode.Decoder(DateTime) {
  use s <- decode.then(decode.string)
  case parse_datetime(s) {
    Ok(dt) -> decode.success(dt)
    Error(Nil) -> decode.failure(DateTime(Year(123), None), "DateTime")
  }
}

pub fn datetime_to_json(dt: DateTime) -> json.Json {
  json.string(datetime_to_string(dt))
}

//-----------------------------------------instant-----------------------------------------

/// An instant in time in a format that is a subset of
/// [ISO8601](https://www.iso.org/iso-8601-date-and-time-format.html)
/// YYYY-MM-DDThh:mm:ss.sss+zz:zz (e.g., 2015-02-07T13:28:17.239+02:00 or 2017-01-01T00:00:00Z).
/// The time SHALL specified at least to the second and SHALL include a timezone offset.
/// Sub-millisecond precision is optionally allowed.
/// Note: This is intended for when precisely observed times are required (typically system logs etc.),
/// and not human-reported times - for those, use date or dateTime.
/// Regex: ([0-9]([0-9]([0-9][1-9]|[1-9]0)|[1-9]00)|[1-9]000)-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])T([01][0-9]|2[0-3]):[0-5][0-9]:([0-5][0-9]|60)(\.[0-9]{1,9})?(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))
pub type Instant {
  Instant(date: Date, time: Time, timezone: Timezone)
}

pub fn parse_instant(input: String) -> Result(Instant, Nil) {
  let bytes = <<input:utf8>>
  use #(year, bytes) <- result.try(parse_digits(from: bytes, count: 4))
  use bytes <- result.try(expect_byte(bytes, byte_minus))
  use #(month_num, bytes) <- result.try(parse_digits(from: bytes, count: 2))
  use month <- result.try(calendar.month_from_int(month_num))
  use bytes <- result.try(expect_byte(bytes, byte_minus))
  use #(day, bytes) <- result.try(parse_digits(from: bytes, count: 2))
  use _ <- result.try(validate_day(year, month, day))
  use bytes <- result.try(expect_byte(bytes, byte_t_uppercase))
  use #(hour, minute, second, nanosec, bytes) <- result.try(parse_time_of_day(
    bytes,
  ))
  use #(timezone, bytes) <- result.try(parse_timezone(bytes))
  case bytes {
    <<>> ->
      Ok(Instant(
        YearMonthDay(year, month, day),
        Time(hour, minute, second, nanosec),
        timezone,
      ))
    _ -> Error(Nil)
  }
}

pub fn instant_to_string(instant: Instant) -> String {
  let Instant(date, time, timezone) = instant
  string.concat([
    date_to_string(date),
    "T",
    time_to_string(time),
    timezone_to_string(timezone),
  ])
}

pub fn instant_decoder() -> decode.Decoder(Instant) {
  use s <- decode.then(decode.string)
  case parse_instant(s) {
    Ok(i) -> decode.success(i)
    Error(Nil) ->
      decode.failure(
        Instant(YearMonthDay(1, calendar.January, 1), Time(0, 0, 0, None), Z),
        "Instant",
      )
  }
}

pub fn instant_to_json(instant: Instant) -> json.Json {
  json.string(instant_to_string(instant))
}
