import gleam/dict
import gleam/dynamic/decode
import gleam/float
import gleam/int
import gleam/io
import gleam/json
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/set.{type Set}
import gleam/string

pub type Value {
  Text(String)
  Integer(Int)
  Decimal(Float)
  Boolean(Bool)
  Object(List(#(String, Value)))
  Array(List(Value))
}

pub type Constraint {
  Constraint(fixed: Bool, type_name: String, value: Value)
}

fn value_decoder(fixed: Bool) -> decode.Decoder(Value) {
  use <- decode.recursive
  decode.one_of(decode.map(decode.string, Text), [
    decode.map(decode.int, Integer),
    decode.map(decode.float, Decimal),
    decode.map(decode.bool, Boolean),
    decode.map(decode.list(value_decoder(fixed)), Array),
    decode.map(decode.dict(decode.string, value_decoder(fixed)), fn(fields) {
      let fields = case fixed, dict.get(fields, "coding") {
        False,
          Ok(Array([
            Object([#("system", Text(system))]),
            Object([#("code", Text(code))]),
          ]))
        | False,
          Ok(Array([
            Object([#("code", Text(code))]),
            Object([#("system", Text(system))]),
          ]))
        -> {
          io.println(
            "assuming they made a mistake in profile by separating system/code pattern, so we will put both  on same coding",
          )
          dict.insert(
            fields,
            "coding",
            Array([
              Object([#("system", Text(system)), #("code", Text(code))]),
            ]),
          )
        }
        _, _ -> fields
      }
      Object(dict.to_list(fields))
    }),
  ])
}

pub fn decoder() -> decode.Decoder(Option(Constraint)) {
  use fields <- decode.then(decode.dict(decode.string, decode.dynamic))
  let constraints =
    fields
    |> dict.to_list
    |> list.filter_map(fn(field) {
      let #(key, value) = field
      let prefix = case string.starts_with(key, "fixed") {
        True -> "fixed"
        False -> "pattern"
      }
      case string.starts_with(key, prefix) {
        False -> Error(Nil)
        True -> {
          let assert Ok(value) =
            decode.run(value, value_decoder(prefix == "fixed"))
            as { "invalid constraint " <> key }
          Ok(Constraint(
            fixed: prefix == "fixed",
            type_name: string.drop_start(key, string.length(prefix)),
            value:,
          ))
        }
      }
    })
  let constraint = case constraints {
    [] -> None
    [constraint] -> Some(constraint)
    _ -> panic as "element has more than one fixed or pattern constraint"
  }
  decode.success(constraint)
}

pub fn field(value: Value, name: String) -> Option(Value) {
  case value {
    Object(fields) ->
      fields
      |> list.find(fn(field) { field.0 == name })
      |> result.map(fn(field) { field.1 })
      |> option.from_result
    _ -> None
  }
}

pub fn text(value: Option(Value)) -> Option(String) {
  case value {
    Some(Text(value)) ->
      case text_can_use_legacy_template(value) {
        True -> Some(value)
        False -> None
      }
    _ -> None
  }
}

pub fn text_can_use_legacy_template(value: String) -> Bool {
  json.to_string(json.string(value)) == "\"" <> value <> "\""
}

pub fn json_source(value: Value) -> String {
  case value {
    Text(value) -> "json.string(" <> json.to_string(json.string(value)) <> ")"
    Integer(value) -> "json.int(" <> int.to_string(value) <> ")"
    Decimal(value) -> "json.float(" <> float.to_string(value) <> ")"
    Boolean(value) ->
      "json.bool("
      <> case value {
        True -> "True"
        False -> "False"
      }
      <> ")"
    Object(fields) ->
      "json.object(["
      <> string.join(
        list.map(fields, fn(field) {
          "#("
          <> json.to_string(json.string(field.0))
          <> ", "
          <> json_source(field.1)
          <> ")"
        }),
        ", ",
      )
      <> "])"
    Array(values) ->
      "json.preprocessed_array(["
      <> string.join(list.map(values, json_source), ", ")
      <> "])"
  }
}

// Generate a boolean match and a decoder from the same constraint.
// The decoder reports errors at the constrained fields; the boolean match
// selects slices without treating a failed parse as an open slice.
pub fn sources(value: Value, fixed: Bool, input: String) -> #(String, String) {
  let matches = case value {
    Object(fields) -> {
      let checks =
        list.map(fields, fn(field) {
          "case dict.get(fields, "
          <> json.to_string(json.string(field.0))
          <> ") { Ok(value) -> { "
          <> sources(field.1, fixed, "value").0
          <> " } Error(_) -> False }"
        })
      let checks = case fixed {
        True -> [
          "dict.size(fields) == " <> int.to_string(list.length(fields)),
          ..checks
        ]
        False -> checks
      }
      "case decode.run("
      <> input
      <> ", decode.dict(decode.string, decode.dynamic)) { Ok(fields) -> { "
      <> case checks {
        [] -> "True"
        _ -> string.join(checks, " && ")
      }
      <> " } Error(_) -> False }"
    }
    Array(values) -> {
      let checks =
        list.map(values, fn(value) {
          "list.any(values, fn(value) { "
          <> sources(value, fixed, "value").0
          <> " })"
        })
      case fixed {
        False ->
          "case decode.run("
          <> input
          <> ", decode.list(decode.dynamic)) { Ok(values) -> { "
          <> case checks {
            [] -> "True"
            _ -> string.join(checks, " && ")
          }
          <> " } Error(_) -> False }"
        True -> {
          let checks =
            list.index_map(values, fn(value, index) {
              "case list.first(list.drop(values, "
              <> int.to_string(index)
              <> ")) { Ok(value) -> { "
              <> sources(value, True, "value").0
              <> " } Error(_) -> False }"
            })
          "case decode.run("
          <> input
          <> ", decode.list(decode.dynamic)) { Ok(values) -> { list.length(values) == "
          <> int.to_string(list.length(values))
          <> case checks {
            [] -> ""
            _ -> " && " <> string.join(checks, " && ")
          }
          <> " } Error(_) -> False }"
        }
      }
    }
    _ -> {
      let #(decoder, literal) = case value {
        Text(value) -> #("decode.string", json.to_string(json.string(value)))
        Boolean(value) -> #("decode.bool", case value {
          True -> "True"
          False -> "False"
        })
        Integer(value) -> #(
          "decode.one_of(decode.float, [decode.map(decode.int, int.to_float)])",
          float.to_string(int.to_float(value)),
        )
        Decimal(value) -> #(
          "decode.one_of(decode.float, [decode.map(decode.int, int.to_float)])",
          float.to_string(value),
        )
        _ -> panic as "expected scalar constraint"
      }
      "case decode.run("
      <> input
      <> ", "
      <> decoder
      <> ") { Ok(value) -> value == "
      <> literal
      <> " Error(_) -> False }"
    }
  }

  let expected = "json.to_string(" <> json_source(value) <> ")"
  let decoder = case value {
    Object(fields) -> {
      let bindings =
        fields
        |> list.map(fn(field) {
          "use _ <- decode.field("
          <> json.to_string(json.string(field.0))
          <> ", "
          <> sources(field.1, fixed, "value").1
          <> ")\n"
        })
        |> string.concat
      "{ use fields <- decode.then(decode.dict(decode.string, decode.dynamic))\n"
      <> bindings
      <> case fixed {
        False -> "let _ = fields\n"
        True ->
          "use _ <- decode.then(case dict.size(fields) == "
          <> int.to_string(list.length(fields))
          <> " { True -> decode.success(Nil) False -> decode.failure(Nil, "
          <> expected
          <> ") |> decode.map_errors(fn(errors) { list.map(errors, fn(error) { decode.DecodeError(..error, found: \"fields: \" <> string.join(dict.keys(fields), \", \")) }) }) })\n"
      }
      <> "decode.success(Nil) }"
    }
    Array(values) if fixed -> {
      let bindings =
        values
        |> list.index_map(fn(value, index) {
          "use _ <- decode.field("
          <> int.to_string(index)
          <> ", "
          <> sources(value, True, "value").1
          <> ")\n"
        })
        |> string.concat
      "{ use values <- decode.then(decode.list(decode.dynamic))\n"
      <> bindings
      <> "case list.length(values) == "
      <> int.to_string(list.length(values))
      <> " { True -> decode.success(Nil) False -> decode.failure(Nil, "
      <> expected
      <> ") |> decode.map_errors(fn(errors) { list.map(errors, fn(error) { decode.DecodeError(..error, found: int.to_string(list.length(values)) <> \" elements\") }) }) } }"
    }
    Array(values) -> {
      let checks =
        values
        |> list.map(fn(value) {
          let decoder = sources(value, False, "value").1
          let expected = "json.to_string(" <> json_source(value) <> ")"
          "use _ <- decode.then({ let candidates = list.index_map(values, fn(value, index) { decode.run(value, "
          <> decoder
          <> ") |> result.map_error(fn(errors) { list.map(errors, fn(error) { decode.DecodeError(..error, path: [int.to_string(index), ..error.path]) }) }) })\n"
          <> "case list.any(candidates, result.is_ok) { True -> decode.success(Nil) False -> { let errors = case list.sort(list.filter_map(candidates, fn(candidate) { case candidate { Error(errors) -> Ok(errors) Ok(_) -> Error(Nil) } }), fn(a, b) { int.compare(list.length(a), list.length(b)) }) { [errors, ..] -> errors [] -> [decode.DecodeError(expected: "
          <> expected
          <> ", found: \"no matching element\", path: [])] } decode.failure(Nil, "
          <> expected
          <> ") |> decode.map_errors(fn(_) { errors }) } } })\n"
        })
        |> string.concat
      "{ use values <- decode.then(decode.list(decode.dynamic))\n"
      <> checks
      <> "decode.success(Nil) }"
    }
    _ -> {
      let #(decoder, literal, found, expected) = case value {
        Text(value) -> #(
          "decode.string",
          json.to_string(json.string(value)),
          "value",
          json.to_string(json.string(value)),
        )
        Boolean(value) -> #(
          "decode.bool",
          case value {
            True -> "True"
            False -> "False"
          },
          "case value { True -> \"true\" False -> \"false\" }",
          case value {
            True -> "\"true\""
            False -> "\"false\""
          },
        )
        Integer(value) -> #(
          "decode.one_of(decode.float, [decode.map(decode.int, int.to_float)])",
          float.to_string(int.to_float(value)),
          "float.to_string(value)",
          json.to_string(json.string(int.to_string(value))),
        )
        Decimal(value) -> #(
          "decode.one_of(decode.float, [decode.map(decode.int, int.to_float)])",
          float.to_string(value),
          "float.to_string(value)",
          json.to_string(json.string(float.to_string(value))),
        )
        _ -> panic as "expected scalar constraint"
      }
      "decode.then("
      <> decoder
      <> ", fn(value) { case value == "
      <> literal
      <> " { True -> decode.success(Nil) False -> decode.failure(Nil, "
      <> expected
      <> ") |> decode.map_errors(fn(errors) { list.map(errors, fn(error) { decode.DecodeError(..error, found: "
      <> found
      <> ") }) }) } })"
    }
  }
  #(matches, decoder)
}

pub fn required_modules(value: Value, fixed: Bool) -> Set(String) {
  case value {
    Integer(_) | Decimal(_) -> set.from_list(["float", "int"])
    Object(fields) ->
      list.fold(
        fields,
        case fixed {
          True -> set.from_list(["dict", "list"])
          False -> set.from_list(["dict"])
        },
        fn(modules, field) {
          set.union(modules, required_modules(field.1, fixed))
        },
      )
    Array(values) ->
      list.fold(
        values,
        case fixed {
          True -> set.from_list(["list"])
          False -> set.from_list(["list", "result"])
        },
        fn(modules, value) {
          set.union(modules, required_modules(value, fixed))
        },
      )
    _ -> set.new()
  }
}
