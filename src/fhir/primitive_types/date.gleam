//// A date, or partial date (e.g., just year or year + month) as used in human communication.
//// The format is a subset of [ISO8601] icon: YYYY, YYYY-MM, or YYYY-MM-DD,
//// e.g., 2018, 1973-06, or 1905-08-23. There SHALL be no timezone offset.
//// Dates SHALL be valid dates.
//// Regex: ([0-9]([0-9]([0-9][1-9]|[1-9]0)|[1-9]00)|[1-9]000)(-(0[1-9]|1[0-2])(-(0[1-9]|[1-2][0-9]|3[0-1]))?)?

import fhir/primitive_types/shared_time_parsing.{byte_minus}
import gleam/dynamic/decode
import gleam/json
import gleam/result
import gleam/string
import gleam/time/calendar

pub type Date {
  Year(year: Int)
  YearMonth(year: Int, month: calendar.Month)
  YearMonthDay(year: Int, month: calendar.Month, day: Int)
}

pub fn parse(input: String) -> Result(Date, Nil) {
  use #(year, bytes) <- result.try(shared_time_parsing.parse_digits(
    from: <<input:utf8>>,
    count: 4,
  ))
  case bytes {
    <<>> -> Ok(Year(year))
    <<byte, rest:bytes>> -> {
      case byte == byte_minus {
        True -> {
          use #(month_num, bytes) <- result.try(
            shared_time_parsing.parse_digits(from: rest, count: 2),
          )
          use month <- result.try(calendar.month_from_int(month_num))
          case bytes {
            <<>> -> Ok(YearMonth(year, month))
            <<byte, rest:bytes>> -> {
              case byte == byte_minus {
                True -> {
                  use #(day, bytes) <- result.try(
                    shared_time_parsing.parse_digits(from: rest, count: 2),
                  )
                  use _ <- result.try(shared_time_parsing.validate_day(
                    year,
                    month,
                    day,
                  ))
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

pub fn to_string(date: Date) -> String {
  case date {
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
  }
}

pub fn decoder() -> decode.Decoder(Date) {
  use s <- decode.then(decode.string)
  case parse(s) {
    Ok(d) -> decode.success(d)
    Error(Nil) -> decode.failure(Year(123), "Date")
  }
}

pub fn to_json(date: Date) -> json.Json {
  json.string(to_string(date))
}
