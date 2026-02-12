import gleam/int
import gleam/result
import gleam/string
import gleam/time/calendar
import gleam/time/duration
import gleam/time/timestamp

const nanoseconds_per_second: Int = 1_000_000_000

const byte_colon: Int = 0x3A

const byte_minus: Int = 0x2D

const byte_zero: Int = 0x30

const byte_nine: Int = 0x39

const byte_t_lowercase: Int = 0x74

const byte_t_uppercase: Int = 0x54

const byte_space: Int = 0x20

pub type Datetime {
  Datetime(timestamp: timestamp.Timestamp, precision: DatetimePrecision)
}

pub type DatetimePrecision {
  YYYY
  YYYYMM
  YYYYMMDD
  YYYYMMDDThhmmsszzzz(timezone: Timezone, precision: Int)
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

pub type NanosecWithPrecision {
  NanosecWithPrecision(nanosec: Int, digits: Int)
}

// pub type DatetimeSafe {
//   YYYYdts(year: Int)
//   YYYYMMdts(year: Int, month: calendar.Month)
//   YYYYMMDDdts(year: Int, month: calendar.Month, day: Int)
//   YYYYMMDDThhmmsszzzzdts(
//     year: Int,
//     month: calendar.Month,
//     day: Int,
//     hour: Int,
//     minute: Int,
//     second: Int,
//     nanosecond: option.Option(NanosecWithPrecision),
//     timezone: Timezone,
//   )
// }

pub fn parse(input: String) -> Result(Datetime, Nil) {
  use #(year, bytes) <- result.try(parse_digits(from: <<input:utf8>>, count: 4))
  let date = calendar.Date(year:, month: calendar.January, day: 0)
  let time = calendar.TimeOfDay(0, 0, 0, 0)
  let offset = duration.seconds(0)
  case bytes {
    <<>> -> Ok(Datetime(timestamp.from_calendar(date:, time:, offset:), YYYY))
    _ -> {
      use bytes <- result.try(accept_byte(from: bytes, value: byte_minus))
      use #(month, bytes) <- result.try(parse_month(from: bytes))
      case bytes {
        <<>> -> {
          let date = calendar.Date(year:, month:, day: 0)
          Ok(Datetime(timestamp.from_calendar(date:, time:, offset:), YYYYMM))
        }
        _ -> {
          use bytes <- result.try(accept_byte(from: bytes, value: byte_minus))
          use #(day, bytes) <- result.try(parse_day(from: bytes, year:, month:))
          let date = calendar.Date(year:, month:, day:)
          case bytes {
            <<>> ->
              Ok(Datetime(
                timestamp.from_calendar(date:, time:, offset:),
                YYYYMMDD,
              ))
            _ -> {
              use bytes <- result.try(accept_date_time_separator(from: bytes))
              use #(hours, bytes) <- result.try(parse_hours(from: bytes))
              use bytes <- result.try(accept_byte(
                from: bytes,
                value: byte_colon,
              ))
              use #(minutes, bytes) <- result.try(parse_minutes(from: bytes))
              use bytes <- result.try(accept_byte(
                from: bytes,
                value: byte_colon,
              ))
              use #(seconds, bytes) <- result.try(parse_seconds(from: bytes))
              use #(second_fraction_as_nanoseconds, bytes) <- result.try(
                parse_second_fraction_as_nanoseconds(from: bytes),
              )
              use #(timezone, bytes) <- result.try(parse_offset(from: bytes))
              use Nil <- result.try(accept_empty(bytes))

              let timeofday =
                calendar.TimeOfDay(
                  hours:,
                  minutes:,
                  seconds:,
                  nanoseconds: second_fraction_as_nanoseconds.nanosec,
                )

              let timezone_offset = case timezone {
                Utc -> calendar.utc_offset
                // https://chat.fhir.org/#narrow/channel/179166-implementers/topic/Subsecond.20resolution.20of.20dateTime.20and.20instant/near/469589261
                // minus -00:00 timezone may be unknown but will just treat it as utc
                Minus0000 -> calendar.utc_offset
                Offset(offset_hours, offset_minutes) ->
                  duration.add(
                    duration.hours(offset_hours),
                    duration.minutes(offset_minutes),
                  )
              }

              let timestamp =
                timestamp.from_calendar(
                  date:,
                  offset: timezone_offset,
                  time: timeofday,
                )
              let precision =
                YYYYMMDDThhmmsszzzz(
                  timezone:,
                  precision: second_fraction_as_nanoseconds.digits,
                )
              Ok(Datetime(timestamp:, precision:))
            }
          }
        }
      }
    }
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

fn parse_month(from bytes: BitArray) -> Result(#(calendar.Month, BitArray), Nil) {
  use #(month_num, bytes) <- result.try(parse_digits(from: bytes, count: 2))
  case calendar.month_from_int(month_num) {
    Ok(month) -> Ok(#(month, bytes))
    Error(_) -> Error(Nil)
  }
}

fn parse_day(
  from bytes: BitArray,
  year year,
  month month: calendar.Month,
) -> Result(#(Int, BitArray), Nil) {
  use #(day, bytes) <- result.try(parse_digits(from: bytes, count: 2))

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
    calendar.February -> {
      case is_leap_year(year) {
        True -> 29
        False -> 28
      }
    }
  }

  case 1 <= day && day <= max_day {
    True -> Ok(#(day, bytes))
    False -> Error(Nil)
  }
}

// Implementation from RFC 3339 Appendix C
fn is_leap_year(year: Int) -> Bool {
  year % 4 == 0 && { year % 100 != 0 || year % 400 == 0 }
}

fn parse_hours(from bytes: BitArray) -> Result(#(Int, BitArray), Nil) {
  use #(hours, bytes) <- result.try(parse_digits(from: bytes, count: 2))
  case 0 <= hours && hours <= 23 {
    True -> Ok(#(hours, bytes))
    False -> Error(Nil)
  }
}

fn parse_minutes(from bytes: BitArray) -> Result(#(Int, BitArray), Nil) {
  use #(minutes, bytes) <- result.try(parse_digits(from: bytes, count: 2))
  case 0 <= minutes && minutes <= 59 {
    True -> Ok(#(minutes, bytes))
    False -> Error(Nil)
  }
}

fn parse_seconds(from bytes: BitArray) -> Result(#(Int, BitArray), Nil) {
  use #(seconds, bytes) <- result.try(parse_digits(from: bytes, count: 2))
  // Max of 60 for leap seconds.  We don't bother to check if this leap second
  // actually occurred in the past or not.
  case 0 <= seconds && seconds <= 60 {
    True -> Ok(#(seconds, bytes))
    False -> Error(Nil)
  }
}

// Truncates any part of the fraction that is beyond the nanosecond precision.
fn parse_second_fraction_as_nanoseconds(
  from bytes: BitArray,
) -> Result(#(NanosecWithPrecision, BitArray), Nil) {
  case bytes {
    <<".", byte, remaining_bytes:bytes>>
      if byte_zero <= byte && byte <= byte_nine
    -> {
      Ok(do_parse_second_fraction_as_nanoseconds(
        from: <<byte, remaining_bytes:bits>>,
        acc: NanosecWithPrecision(0, 0),
        power: nanoseconds_per_second,
      ))
    }
    // bytes starts with a ".", which should introduce a fraction, but it does
    // not, and so it is an ill-formed input.
    <<".", _:bytes>> -> Error(Nil)
    // bytes does not start with a "." so
    // this is 0 nanoseconds with precision 0
    _ -> Ok(#(NanosecWithPrecision(0, 0), bytes))
  }
}

fn do_parse_second_fraction_as_nanoseconds(
  from bytes: BitArray,
  acc acc: NanosecWithPrecision,
  power power: Int,
) -> #(NanosecWithPrecision, BitArray) {
  // Each digit place to the left in the fractional second is 10x fewer
  // nanoseconds.
  let power = power / 10

  case bytes {
    // arguably this should error if trying to parse > 9 digits
    // rather than keep parsing digits but do nothing with them
    // as fhir only accepts 9 digit precision per regex
    // https://chat.fhir.org/#narrow/channel/179166-implementers/topic/Subsecond.20resolution.20of.20dateTime.20and.20instant
    <<byte, remaining_bytes:bytes>>
      if byte_zero <= byte && byte <= byte_nine && power < 1
    -> {
      // We already have the max precision for nanoseconds. Truncate any
      // remaining digits.
      do_parse_second_fraction_as_nanoseconds(
        from: remaining_bytes,
        acc:,
        power:,
      )
    }
    <<byte, remaining_bytes:bytes>> if byte_zero <= byte && byte <= byte_nine -> {
      // We have not yet reached the precision limit. Parse the next digit.
      let digit = byte - 0x30
      do_parse_second_fraction_as_nanoseconds(
        from: remaining_bytes,
        acc: NanosecWithPrecision(acc.nanosec + digit * power, acc.digits + 1),
        power:,
      )
    }
    _ -> #(acc, bytes)
  }
}

fn accept_byte(from bytes: BitArray, value value: Int) -> Result(BitArray, Nil) {
  case bytes {
    <<byte, remaining_bytes:bytes>> if byte == value -> Ok(remaining_bytes)
    _ -> Error(Nil)
  }
}

fn accept_date_time_separator(from bytes: BitArray) -> Result(BitArray, Nil) {
  case bytes {
    <<byte, remaining_bytes:bytes>>
      if byte == byte_t_uppercase
      || byte == byte_t_lowercase
      || byte == byte_space
    -> Ok(remaining_bytes)
    _ -> Error(Nil)
  }
}

fn accept_empty(from bytes: BitArray) -> Result(Nil, Nil) {
  case bytes {
    <<>> -> Ok(Nil)
    _ -> Error(Nil)
  }
}

fn parse_offset(from bytes: BitArray) -> Result(#(Timezone, BitArray), Nil) {
  case bytes {
    <<"Z", remaining_bytes:bytes>> | <<"z", remaining_bytes:bytes>> ->
      Ok(#(Utc, remaining_bytes))
    _ -> parse_numeric_offset(bytes)
  }
}

fn parse_numeric_offset(
  from bytes: BitArray,
) -> Result(#(Timezone, BitArray), Nil) {
  use #(sign, bytes) <- result.try(parse_sign(from: bytes))
  use #(hours, bytes) <- result.try(parse_hours(from: bytes))
  use bytes <- result.try(accept_byte(from: bytes, value: byte_colon))
  use #(minutes, bytes) <- result.try(parse_minutes(from: bytes))

  case sign, hours, minutes {
    "-", 0, 0 -> Ok(#(Minus0000, bytes))
    "-", _, _ -> Ok(#(Offset(hours: -hours, minutes: -minutes), bytes))
    "+", _, _ -> Ok(#(Offset(hours:, minutes:), bytes))
    _, _, _ -> Error(Nil)
  }
}

fn parse_sign(from bytes: BitArray) -> Result(#(String, BitArray), Nil) {
  case bytes {
    <<"+", remaining_bytes:bytes>> -> Ok(#("+", remaining_bytes))
    <<"-", remaining_bytes:bytes>> -> Ok(#("-", remaining_bytes))
    _ -> Error(Nil)
  }
}

pub fn to_string(dt: Datetime) -> String {
  // maybe a simpler way would be to call timestamp.to_string then truncate but oh well
  // actually maybe need this for -00:00 vs +00:00
  // also wonder is int.to_string(digit) faster than case statement on 0..59?
  // but maybe inconsequential
  let offset = case dt.precision {
    YYYYMMDDThhmmsszzzz(Offset(hours, minutes), _) ->
      duration.add(duration.hours(hours), duration.minutes(minutes))
    _ -> calendar.utc_offset
  }

  let #(date, time) = timestamp.to_calendar(dt.timestamp, offset)

  case dt.precision {
    YYYY -> n4(date.year)
    YYYYMM -> string.concat([n4(date.year), "-", month2(date.month)])
    YYYYMMDD ->
      string.concat([n4(date.year), "-", month2(date.month), "-", n2(date.day)])
    YYYYMMDDThhmmsszzzz(tz, frac_digits) ->
      string.concat([
        n4(date.year),
        "-",
        month2(date.month),
        "-",
        n2(date.day),
        "T",
        n2(time.hours),
        ":",
        n2(time.minutes),
        ":",
        n2(time.seconds),
        fraction_to_string(time.nanoseconds, frac_digits),
        timezone_to_string(tz),
      ])
  }
}

fn fraction_to_string(nanoseconds: Int, digits: Int) -> String {
  case digits {
    0 -> ""
    _ -> {
      let all = int.to_string(nanoseconds) |> string.pad_start(9, "0")
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

fn n2(d) {
  pad_digit(d, to: 2)
}

fn n4(d) {
  pad_digit(d, to: 4)
}

fn pad_digit(digit: Int, to desired_length: Int) -> String {
  int.to_string(digit) |> string.pad_start(desired_length, "0")
}

fn month2(month: calendar.Month) {
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
