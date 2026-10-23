import codegen_decode
import codegen_helpers
import codegen_to_json
import gleam/dict
import gleam/int
import gleam/json
import gleam/list
import gleam/option.{type Option, Some}
import gleam/result
import gleam/set.{type Set}
import gleam/string

// Field lists follow the datatype definition's order. Constant fields are not
// repeated in Required: they are supplied by the profile instead of the caller.
pub fn constrained_type_name(
  datatype: String,
  fixed: List(String),
  required: List(String),
  omitted: List(String),
) -> String {
  codegen_helpers.to_camel_case(datatype)
  <> case fixed {
    [] -> ""
    _ ->
      "Fixed" <> string.concat(list.map(fixed, codegen_helpers.to_camel_case))
  }
  <> case list.filter(required, fn(field) { !list.contains(fixed, field) }) {
    [] -> ""
    fields ->
      "Required"
      <> string.concat(list.map(fields, codegen_helpers.to_camel_case))
  }
  <> case omitted {
    [] -> ""
    fields ->
      "Omit" <> string.concat(list.map(fields, codegen_helpers.to_camel_case))
  }
}

// The shared types have stable public names. Their names describe which
// fields are supplied by the profile and which remain constructor arguments.
pub fn helper_fields(
  type_name: String,
) -> Result(#(String, String, List(String), Bool), Nil) {
  let type_name = string.replace(type_name, "ct.", "")
  let name = codegen_helpers.to_snake_case(type_name)
  let assert [base, ..parts] = string.split(name, "_")
  case
    list.any(["fixed", "required", "omit"], fn(part) {
      list.contains(parts, part)
    })
  {
    False -> Error(Nil)
    True -> {
      let required = list.contains(parts, "required")
      let fields =
        parts
        |> list.drop_while(fn(part) { part != "fixed" })
        |> list.drop(1)
        |> list.take_while(fn(part) { part != "required" && part != "omit" })
      Ok(#(base, name, fields, required))
    }
  }
}

// Resolve complete field names, including names containing several words,
// against the datatype fields instead of splitting them at underscores.
pub fn constraint_fields(
  type_name: String,
  kind: String,
  fields: List(codegen_helpers.Element),
) -> List(String) {
  let suffix = case string.split(type_name, kind) {
    [_, suffix] -> {
      let assert [suffix, ..] = string.split(suffix, "Omit")
      suffix
    }
    _ -> ""
  }
  case suffix {
    "" -> []
    _ -> {
      let assert Ok(field) =
        fields
        |> list.sort(fn(a, b) {
          int.compare(
            string.length(codegen_helpers.field_name(b)),
            string.length(codegen_helpers.field_name(a)),
          )
        })
        |> list.find(fn(field) {
          string.starts_with(
            suffix,
            codegen_helpers.to_camel_case(codegen_helpers.field_name(field)),
          )
        })
        as { "unknown required field in " <> type_name }
      let name = codegen_helpers.field_name(field)
      [
        name,
        ..constraint_fields(
          kind
            <> string.drop_start(
            suffix,
            string.length(codegen_helpers.to_camel_case(name)),
          ),
          kind,
          fields,
        )
      ]
    }
  }
}

fn helper_arguments(
  type_name: String,
  system: String,
  code: String,
  display: Option(String),
) -> Result(#(String, String, String), Nil) {
  use #(base, name, fields, _) <- result.try(helper_fields(type_name))
  let arguments =
    list.map(fields, fn(field) {
      let literal = case field {
        "system" -> system
        "code" -> code
        "display" -> {
          let assert Some(display) = display
          display
        }
        _ -> panic as { "unknown shared constraint field " <> field }
      }
      ", \"" <> literal <> "\""
    })
    |> string.concat
  Ok(#(base, name, arguments))
}

pub fn discriminator_to_json_call(
  current_bucket: codegen_helpers.Category,
  type_name: String,
  system: String,
  code: String,
  display: Option(String),
  value: String,
) -> String {
  let assert Ok(#(_, name, arguments)) =
    helper_arguments(type_name, system, code, display)
  codegen_helpers.bucket_prefix("Quantity", current_bucket)
  <> name
  <> "_to_json("
  <> value
  <> arguments
  <> ")"
}

pub fn discriminator_new_call(
  current_bucket: codegen_helpers.Category,
  discriminator_type: String,
  elements: dict.Dict(String, codegen_helpers.Element),
  default: fn(String) -> String,
) -> Result(String, Nil) {
  let complex_prefix = codegen_helpers.bucket_prefix("Quantity", current_bucket)
  use #(base, name, _, _) <- result.try(helper_fields(discriminator_type))
  let assert Ok(root) =
    dict.values(elements)
    |> list.find(fn(element) {
      !string.contains(element.path, ".")
      && codegen_helpers.to_snake_case(codegen_helpers.to_camel_case(
        element.path,
      ))
      == base
    })
  let fields = datatype_fields(root.path, elements)
  let arguments =
    constraint_fields(discriminator_type, "Required", fields)
    |> list.map(fn(name) {
      let assert Ok(field) =
        list.find(fields, fn(field) {
          codegen_helpers.field_name(field) == name
        })
      name <> ": " <> default(field_type(field))
    })
    |> string.join(", ")
  Ok(complex_prefix <> name <> "_new(" <> arguments <> ")")
}

// Read fields from the same datatype definitions used by profile generation.
pub fn datatype_fields(
  root: String,
  elements: dict.Dict(String, codegen_helpers.Element),
) -> List(codegen_helpers.Element) {
  let prefix = root <> "."
  elements
  |> dict.values
  |> list.filter(fn(field) {
    string.starts_with(field.path, prefix)
    && !string.contains(
      string.drop_start(field.path, string.length(prefix)),
      ".",
    )
  })
  |> list.sort(fn(a, b) { string.compare(a.path, b.path) })
}

fn field_type(field: codegen_helpers.Element) -> String {
  let assert Some(type_name) = field.gleam_type
    as { "missing generated datatype field type " <> field.path }
  type_name
}

type RecordSource {
  RecordSource(
    declarations: List(String),
    arguments: List(String),
    defaults: List(String),
    restored: List(String),
  )
}

// A shared name describes its constrained fields. Resolve those fields against
// the datatype snapshot. Other cardinality changes use profile paths.
// There are no datatype field lists or datatype templates here.
pub fn shared_type(
  type_name: String,
  elements: dict.Dict(String, codegen_helpers.Element),
  encoders: Set(String),
  decoders: Set(String),
) -> List(#(String, #(String, codegen_helpers.RequiredCode))) {
  let type_name = string.replace(type_name, "ct.", "")
  let assert Ok(#(base, function, fixed, _)) = helper_fields(type_name)
  let assert Ok(root) =
    elements
    |> dict.values
    |> list.find(fn(element) {
      !string.contains(element.path, ".")
      && codegen_helpers.to_snake_case(codegen_helpers.to_camel_case(
        element.path,
      ))
      == base
    })
  let base_type = codegen_helpers.to_camel_case(root.path)
  let base_function = codegen_helpers.to_snake_case(base_type)
  let fields = datatype_fields(root.path, elements)
  let omitted = constraint_fields(type_name, "Omit", fields)
  let required_fields = constraint_fields(type_name, "Required", fields)
  let parameter_fields = fields
  let parameters =
    string.concat(
      list.map(fixed, fn(name) {
        let assert Ok(field) =
          list.find(parameter_fields, fn(field) {
            codegen_helpers.field_name(field) == name
          })
        name <> ": " <> field_type(field) <> ","
      }),
    )
  let arguments = string.concat(list.map(fixed, fn(name) { ", " <> name }))
  let source =
    list.fold(fields, RecordSource([], [], [], []), fn(source, field) {
      let name = codegen_helpers.field_name(field)
      case list.contains(omitted, name) {
        True ->
          RecordSource(..source, restored: [
            name
              <> ": "
              <> case field.max {
              "1" -> "None"
              _ -> "[]"
            }
              <> ",",
            ..source.restored
          ])
        False -> {
          let constant = list.contains(fixed, name)
          let min = case list.contains(required_fields, name) {
            True -> 1
            False -> field.min
          }
          let type_ = field_type(field)
          let restored = case min, field.min {
            1, 0 -> "Some(source." <> name <> ")"
            _, _ -> "source." <> name
          }
          let scalar = case field.min {
            0 -> "Some(" <> name <> ")"
            _ -> name
          }
          case constant {
            True ->
              RecordSource(..source, restored: [
                name <> ": " <> scalar <> ",",
                ..source.restored
              ])
            False -> {
              let #(argument, default, _) =
                codegen_helpers.new_fn_arg_and_field(
                  name,
                  type_,
                  min,
                  field.max,
                  False,
                )
              RecordSource(
                declarations: [
                  name
                    <> ": "
                    <> codegen_helpers.cardinality(type_, min, field.max)
                    <> ",",
                  ..source.declarations
                ],
                arguments: [argument, ..source.arguments],
                defaults: [default, ..source.defaults],
                restored: [name <> ": " <> restored <> ",", ..source.restored],
              )
            }
          }
        }
      }
    })
  let decoder = case
    omitted != []
    || set.contains(decoders, type_name)
    || set.contains(encoders, type_name)
  {
    False -> ""
    True -> {
      let #(bindings, values, checks) =
        list.fold(fields, #("", [], ""), fn(acc, field) {
          let #(bindings, values, checks) = acc
          let name = codegen_helpers.field_name(field)
          case list.contains(omitted, name) {
            True -> acc
            False -> {
              let inner = case field.type_ {
                [type_] ->
                  codegen_decode.decoder_for_type(
                    type_.code,
                    field_type(field),
                    codegen_helpers.ComplexTypes,
                  )
                _ ->
                  codegen_helpers.to_snake_case(field_type(field))
                  <> "_decoder()"
              }
              let constant = list.contains(fixed, name)
              let inner = case constant {
                True ->
                  inner
                  <> " |> decode.then(fn(value) { case value == "
                  <> name
                  <> " { True -> decode.success(value) False -> decode.failure("
                  <> name
                  <> ", "
                  <> name
                  <> ") } })"
                False -> inner
              }
              let min = case constant || list.contains(required_fields, name) {
                True -> 1
                False -> field.min
              }
              let binding =
                "use "
                <> case constant {
                  True -> "_"
                  False -> "decoded_" <> name
                }
                <> " <- "
                <> case field.type_ {
                  [_, _, ..] ->
                    case min {
                      0 -> "decode.then(none_if_omitted(" <> inner <> "))"
                      _ -> "decode.then(" <> inner <> ")"
                    }
                  _ ->
                    codegen_decode.field_decoder(
                      string.drop_start(
                        field.path,
                        string.length(root.path) + 1,
                      ),
                      inner,
                      min,
                      field.max,
                      False,
                    )
                }
                <> "\n"
              case constant {
                True -> #(bindings, values, checks <> binding)
                False -> #(
                  bindings <> binding,
                  [name <> ": decoded_" <> name, ..values],
                  checks,
                )
              }
            }
          }
        })
      let wrapper = case fixed {
        [] -> ""
        _ ->
          "pub fn "
          <> function
          <> "_decoder("
          <> parameters
          <> ") -> Decoder("
          <> type_name
          <> ") {\n"
          <> "use <- decode.recursive\n"
          <> checks
          <> function
          <> "_slice_decoder()\n}\n"
      }
      wrapper
      <> "pub fn "
      <> function
      <> case fixed {
        [] -> "_decoder("
        _ -> "_slice_decoder("
      }
      <> ") -> Decoder("
      <> type_name
      <> ") {\n"
      <> "use <- decode.recursive\n"
      <> bindings
      <> "decode.success("
      <> type_name
      <> case values {
        [] -> ""
        _ -> "(" <> string.join(list.reverse(values), ", ") <> ")"
      }
      <> ")\n}\n"
    }
  }
  let direct_json = case omitted {
    [] -> ""
    _ -> {
      let bindings =
        list.fold(fields, "let fields = []\n", fn(source, field) {
          let name = codegen_helpers.field_name(field)
          case list.contains(omitted, name) {
            True -> source
            False -> {
              let fixed_field = list.contains(fixed, name)
              let value = case fixed_field {
                True -> name
                False -> "source." <> name
              }
              let json_name =
                string.drop_start(field.path, string.length(root.path) + 1)
                |> string.replace("[x]", "")
                |> json.string
                |> json.to_string
              let json_name =
                json_name
                <> codegen_helpers.gen_choicetype_suffixes(
                  "value",
                  field.type_,
                  field_type(field),
                )
              let encode = case field.type_ {
                [type_] ->
                  codegen_to_json.string_to_encoder_call(
                    type_.code,
                    string.split(field.path, "."),
                    field,
                    codegen_helpers.ComplexTypes,
                    "value",
                  )
                _ ->
                  codegen_helpers.to_snake_case(field_type(field))
                  <> "_to_json(value)"
              }
              source
              <> case
                field.max,
                field.min > 0
                || list.contains(required_fields, name)
                || fixed_field
              {
                "1", True ->
                  "let value = "
                  <> value
                  <> "\nlet fields = [#("
                  <> json_name
                  <> ", "
                  <> encode
                  <> "), ..fields]\n"
                "1", False ->
                  "let fields = case "
                  <> value
                  <> " { Some(value) -> [#("
                  <> json_name
                  <> ", "
                  <> encode
                  <> "), ..fields] None -> fields }\n"
                _, _ ->
                  "let fields = case "
                  <> value
                  <> " { [] -> fields values -> [#("
                  <> json_name
                  <> ", json.array(values, fn(value) { "
                  <> encode
                  <> " })), ..fields] }\n"
              }
            }
          }
        })
      bindings <> "json.object(fields)"
    }
  }
  let generated =
    "pub type "
    <> type_name
    <> " { "
    <> type_name
    <> "("
    <> string.concat(list.reverse(source.declarations))
    <> ") }\n"
    <> "pub fn "
    <> function
    <> "_new("
    <> string.concat(list.reverse(source.arguments))
    <> ") -> "
    <> type_name
    <> " { "
    <> type_name
    <> "("
    <> string.concat(list.reverse(source.defaults))
    <> ") }\n"
    <> decoder
    <> case omitted == [] && set.contains(encoders, type_name) {
      False -> ""
      True ->
        "fn "
        <> function
        <> "_to_"
        <> base_function
        <> "(source: "
        <> type_name
        <> ","
        <> parameters
        <> ") -> "
        <> base_type
        <> " { "
        <> base_type
        <> "("
        <> string.concat(list.reverse(source.restored))
        <> ") }\n"
    }
    <> case set.contains(encoders, type_name) {
      False -> ""
      True ->
        "pub fn "
        <> function
        <> "_to_json(source: "
        <> type_name
        <> ","
        <> parameters
        <> ") -> Json { "
        <> case omitted {
          [] ->
            base_function
            <> "_to_json("
            <> function
            <> "_to_"
            <> base_function
            <> "(source"
            <> arguments
            <> "))"
          _ -> direct_json
        }
        <> " }\n\n"
    }
  let required =
    list.fold(fields, codegen_helpers.required_code(), fn(required, field) {
      let name = codegen_helpers.field_name(field)
      let required = case
        field.min,
        field.max,
        list.contains(omitted, name)
        || list.contains(required_fields, name)
        || list.contains(fixed, name),
        field_type(field)
      {
        0, "1", False, "String" ->
          codegen_helpers.require_function(required, "decode_optional_string")
        0, "1", False, "Bool" ->
          codegen_helpers.require_function(required, "decode_optional_bool")
        _, _, _, _ -> required
      }
      case field.type_ {
        [_, _, ..] if field.min == 0 -> {
          case
            list.contains(omitted, codegen_helpers.field_name(field))
            || list.contains(required_fields, codegen_helpers.field_name(field))
          {
            True -> required
            False ->
              codegen_helpers.require_function(required, "none_if_omitted")
          }
        }
        _ -> required
      }
    })
  [#(type_name, #(generated, required))]
}
