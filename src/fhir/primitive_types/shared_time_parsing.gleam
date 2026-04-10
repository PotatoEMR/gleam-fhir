//// parsing logic common to date, datetime, instant, time

import gleam/int
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

pub type NanosecWithPrecision {
  NanosecWithPrecision(value: Int, precision: Int)
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
) -> Result(
  #(Int, Int, Int, Option(NanosecWithPrecision), BitArray),
  Nil,
) {
  use #(hour, bytes) <- result.try(parse_digits(from: bytes, count: 2))
  use _ <- result.try(validate_hour(hour))
  use bytes <- result.try(expect_byte(bytes, byte_colon))
  use #(minute, bytes) <- result.try(parse_digits(from: bytes, count: 2))
  use _ <- result.try(validate_minute(minute))
  use bytes <- result.try(expect_byte(bytes, byte_colon))
  use #(second, bytes) <- result.try(parse_digits(from: bytes, count: 2))
  use _ <- result.try(validate_second(second))
  use #(nanosec, bytes) <- result.try(
    parse_optional_fraction_as_nanoseconds(bytes),
  )
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
            True ->
              parse_fraction_as_nanoseconds_loop(rest, acc, power, digits)
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
        False -> Ok(#(NanosecWithPrecision(acc, digits), bytes))
      }
    }
    _ -> Ok(#(NanosecWithPrecision(acc, digits), bytes))
  }
}

pub fn parse_timezone(
  bytes: BitArray,
) -> Result(#(Timezone, BitArray), Nil) {
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
    Some(NanosecWithPrecision(value, digits)) -> {
      let all = int.to_string(value) |> string.pad_start(9, "0")
      "." <> string.slice(all, 0, digits)
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
