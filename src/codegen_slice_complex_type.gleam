import codegen_helpers
import gleam/dict
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string

pub type DiscriminatorCall {
  ResultDiscriminatorCall(String)
}

// Field lists follow the datatype definition's order. Constant fields are not
// repeated in Required: they are supplied by the profile instead of the caller.
pub fn constrained_type_name(
  datatype: String,
  fixed: List(String),
  required: List(String),
  list1: Bool,
) -> String {
  codegen_helpers.to_camel_case(datatype)
  <> case list1 {
    True -> "List1"
    False -> ""
  }
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
}

// The shared types have stable public names. Their names describe which
// fields are supplied by the profile and which remain constructor arguments.
pub fn helper_fields(
  type_name: String,
) -> Result(#(String, String, List(String), Bool), Nil) {
  let type_name = string.replace(type_name, "ct.", "")
  let name = codegen_helpers.to_snake_case(type_name)
  let assert [base, ..parts] = string.split(name, "_")
  case list.contains(parts, "fixed") || list.contains(parts, "required") {
    False -> Error(Nil)
    True -> {
      let required = list.contains(parts, "required")
      let fields =
        parts
        |> list.drop_while(fn(part) { part != "fixed" })
        |> list.drop(1)
        |> list.take_while(fn(part) { part != "required" })
      Ok(#(base, name, fields, required))
    }
  }
}

// Resolve complete field names, including names containing several words,
// against the datatype fields instead of splitting them at underscores.
pub fn required_fields(
  type_name: String,
  fields: List(codegen_helpers.Element),
) -> List(String) {
  let suffix = case string.split(type_name, "Required") {
    [_, suffix] -> suffix
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
        ..required_fields(
          "Required"
            <> string.drop_start(
            suffix,
            string.length(codegen_helpers.to_camel_case(name)),
          ),
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

pub fn discriminator_from_base_call(
  current_bucket: codegen_helpers.Category,
  discriminator_type: String,
  value: String,
  system: String,
  code: String,
  display: Option(String),
) -> Result(DiscriminatorCall, Nil) {
  let complex_prefix = codegen_helpers.bucket_prefix("Quantity", current_bucket)
  case discriminator_type {
    "FixedValueDiscriminator" ->
      Ok(ResultDiscriminatorCall(
        "case "
        <> value
        <> " == \""
        <> system
        <> "\" { True -> Ok("
        <> value
        <> ") False -> Error(Nil) }",
      ))
    _ -> {
      use #(base, name, arguments) <- result.try(helper_arguments(
        discriminator_type,
        system,
        code,
        display,
      ))
      Ok(ResultDiscriminatorCall(
        complex_prefix
        <> name
        <> "_from_"
        <> base
        <> "("
        <> value
        <> arguments
        <> ")",
      ))
    }
  }
}

pub fn discriminator_new_call(
  current_bucket: codegen_helpers.Category,
  discriminator_type: String,
  elements: dict.Dict(String, codegen_helpers.Element),
) -> Result(String, Nil) {
  let complex_prefix = codegen_helpers.bucket_prefix("Quantity", current_bucket)
  use #(base, name, fixed, required) <- result.try(helper_fields(
    discriminator_type,
  ))
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
  let direct =
    list.all(fixed, fn(name) {
      list.any(fields, fn(field) { codegen_helpers.field_name(field) == name })
    })
  let arguments = case string.contains(name, "_list1_") {
    False if required && direct -> {
      required_fields(discriminator_type, fields)
      |> list.map(fn(name) {
        let assert Ok(field) =
          list.find(fields, fn(field) {
            codegen_helpers.field_name(field) == name
          })
        name
        <> ": "
        <> case field_type(field) {
          "String" -> "\"\""
          "Bool" -> "False"
          "Int" -> "0"
          "Float" -> "0.0"
          type_ ->
            case string.starts_with(type_, "valuesets.") {
              True -> string.lowercase(type_) <> "_failure_variant"
              False ->
                complex_prefix
                <> codegen_helpers.to_snake_case(type_)
                <> "_new()"
            }
        }
      })
      |> string.join(", ")
    }
    True -> {
      let assert Ok(member) =
        fields
        |> list.find(fn(field) {
          case field.type_, field.max {
            [type_], max if max != "1" && max != "0" ->
              list.all(fixed, fn(name) {
                list.any(datatype_fields(type_.code, elements), fn(field) {
                  codegen_helpers.field_name(field) == name
                })
              })
            _, _ -> False
          }
        })
      let child_type =
        field_type(member)
        <> string.drop_start(
          string.replace(discriminator_type, "ct.", ""),
          string.length(codegen_helpers.to_camel_case(root.path) <> "List1"),
        )
      let assert Ok(child) =
        discriminator_new_call(current_bucket, child_type, elements)
      complex_prefix <> "List1(first: " <> child <> ", rest: [])"
    }
    False -> ""
  }
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
  let assert [type_] = field.type_
  let #(type_name, _) =
    codegen_helpers.string_to_type(
      type_.code,
      string.split(field.path, "."),
      field,
      codegen_helpers.ComplexTypes,
      dict.new(),
    )
  type_name
}

type RecordSource {
  RecordSource(
    declarations: List(String),
    arguments: List(String),
    defaults: List(String),
    conditions: List(String),
    bindings: List(String),
    decoded: List(String),
    restored: List(String),
  )
}

// A shared name describes its constrained fields. Resolve those fields against
// the datatype snapshot, including a required matching member of a nested list.
// There are no datatype field lists or datatype templates here.
pub fn shared_type(
  type_name: String,
  elements: dict.Dict(String, codegen_helpers.Element),
  preserve_slice_order: Bool,
) -> List(#(String, String)) {
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
  let direct =
    list.all(fixed, fn(name) {
      list.any(fields, fn(field) { codegen_helpers.field_name(field) == name })
    })
  let member = case direct {
    True -> None
    False -> {
      let assert Ok(member) =
        list.find(fields, fn(field) {
          case field.type_, field.max {
            [type_], max if max != "1" && max != "0" ->
              list.all(fixed, fn(name) {
                list.any(datatype_fields(type_.code, elements), fn(field) {
                  codegen_helpers.field_name(field) == name
                })
              })
            _, _ -> False
          }
        })
        as { "no list member for constrained type " <> type_name }
      Some(member)
    }
  }
  let parameter_fields = case member {
    None -> fields
    Some(member) -> {
      let assert [type_] = member.type_
      datatype_fields(type_.code, elements)
    }
  }
  let required_fields = required_fields(type_name, parameter_fields)
  let #(member_type, member_function, parameter_fields, children) = case
    member
  {
    None -> #("", "", fields, [])
    Some(member) -> {
      let assert [type_] = member.type_
      let child_type =
        constrained_type_name(type_.code, fixed, required_fields, False)
      #(
        child_type,
        codegen_helpers.to_snake_case(child_type),
        datatype_fields(type_.code, elements),
        shared_type(child_type, elements, preserve_slice_order),
      )
    }
  }
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
  let list1 = string.contains(function, "_list1_")
  let every_member = list1 || string.contains(function, "_all_")
  let source =
    list.fold(
      fields,
      RecordSource([], [], [], [], [], [], []),
      fn(source, field) {
        let name = codegen_helpers.field_name(field)
        let repeated = case member {
          Some(member) -> member.id == field.id
          None -> False
        }
        case repeated {
          True -> {
            let member_base = field_type(field)
            let member_base_fn = codegen_helpers.to_snake_case(member_base)
            let convert =
              member_function
              <> "_from_"
              <> member_base_fn
              <> "(value"
              <> arguments
              <> ")"
            let restore = member_function <> "_to_" <> member_base_fn
            case every_member, list1 {
              True, False ->
                RecordSource(
                  ..source,
                  declarations: [
                    name <> ": List(" <> member_type <> "),",
                    ..source.declarations
                  ],
                  defaults: [name <> ": [],", ..source.defaults],
                  bindings: [
                    "use "
                      <> name
                      <> " <- result.try(list.try_map(source."
                      <> name
                      <> ", fn(value) { "
                      <> convert
                      <> " }))\n",
                    ..source.bindings
                  ],
                  decoded: [name <> ":,", ..source.decoded],
                  restored: [
                    name
                      <> ": list.map(source."
                      <> name
                      <> ", fn(value) { "
                      <> restore
                      <> "(value"
                      <> arguments
                      <> ") }),",
                    ..source.restored
                  ],
                )
              True, True ->
                RecordSource(
                  ..source,
                  declarations: [
                    name <> ": List1(" <> member_type <> "),",
                    ..source.declarations
                  ],
                  arguments: [
                    name <> " " <> name <> ": List1(" <> member_type <> "),",
                    ..source.arguments
                  ],
                  defaults: [name <> ":,", ..source.defaults],
                  bindings: [
                    "use "
                      <> name
                      <> " <- result.try(case list.try_map(source."
                      <> name
                      <> ", fn(value) { "
                      <> convert
                      <> " }) { Ok([first, ..rest]) -> Ok(List1(first:, rest:)) Ok([]) | Error(_) -> Error(Nil) })\n",
                    ..source.bindings
                  ],
                  decoded: [name <> ":,", ..source.decoded],
                  restored: [
                    name
                      <> ": list.map([source."
                      <> name
                      <> ".first, ..source."
                      <> name
                      <> ".rest], fn(value) { "
                      <> restore
                      <> "(value"
                      <> arguments
                      <> ") }),",
                    ..source.restored
                  ],
                )
              False, _ -> {
                let #(
                  index_field,
                  index_default,
                  index_value,
                  index_pattern,
                  restored,
                ) = case preserve_slice_order {
                  False -> #(
                    "",
                    "",
                    "",
                    "#(disc, others)",
                    "["
                      <> restore
                      <> "(source.disc"
                      <> arguments
                      <> "), ..source.others]",
                  )
                  True -> #(
                    "internal_gleam_fhir_index: Option(Int),",
                    "internal_gleam_fhir_index: None,",
                    "internal_gleam_fhir_index: Some(index),",
                    "#(disc, others, index)",
                    "case source.internal_gleam_fhir_index { None -> ["
                      <> restore
                      <> "(source.disc"
                      <> arguments
                      <> "), ..source.others] Some(index) -> insert_at("
                      <> restore
                      <> "(source.disc"
                      <> arguments
                      <> "), source.others, index) }",
                  )
                }
                RecordSource(
                  ..source,
                  declarations: [
                    index_field
                      <> "disc: "
                      <> member_type
                      <> ",others: List("
                      <> member_base
                      <> "),",
                    ..source.declarations
                  ],
                  defaults: [
                    index_default
                      <> "disc: "
                      <> {
                      let assert Ok(child) =
                        discriminator_new_call(
                          codegen_helpers.ComplexTypes,
                          member_type,
                          elements,
                        )
                      child
                    }
                      <> ",others: [],",
                    ..source.defaults
                  ],
                  bindings: [
                    "use "
                      <> index_pattern
                      <> " <- result.try(find_elt_and_rest_result(in: source."
                      <> name
                      <> ", one_that: fn(value) { "
                      <> convert
                      <> " }))\n",
                    ..source.bindings
                  ],
                  decoded: [index_value <> "disc:,others:,", ..source.decoded],
                  restored: [name <> ": " <> restored <> ",", ..source.restored],
                )
              }
            }
          }
          False -> {
            let constant = direct && list.contains(fixed, name)
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
                RecordSource(
                  ..source,
                  conditions: [
                    "source." <> name <> " == " <> scalar,
                    ..source.conditions
                  ],
                  restored: [name <> ": " <> scalar <> ",", ..source.restored],
                )
              False -> {
                let #(argument, default, _) =
                  codegen_helpers.new_fn_arg_and_field(
                    name,
                    type_,
                    min,
                    field.max,
                    False,
                  )
                let unwrap = min == 1 && field.min == 0 && field.max == "1"
                let binding = case unwrap {
                  True ->
                    "use "
                    <> name
                    <> " <- result.try(case source."
                    <> name
                    <> " { Some(value) -> Ok(value) None -> Error(Nil) })\n"
                  False -> ""
                }
                RecordSource(
                  ..source,
                  declarations: [
                    name
                      <> ": "
                      <> codegen_helpers.cardinality(type_, min, field.max)
                      <> ",",
                    ..source.declarations
                  ],
                  arguments: [argument, ..source.arguments],
                  defaults: [default, ..source.defaults],
                  bindings: [binding, ..source.bindings],
                  decoded: [
                    name
                      <> ": "
                      <> case unwrap {
                      True -> name
                      False -> "source." <> name
                    }
                      <> ",",
                    ..source.decoded
                  ],
                  restored: [name <> ": " <> restored <> ",", ..source.restored],
                )
              }
            }
          }
        }
      },
    )
  let conditions = case list.reverse(source.conditions) {
    [] -> "True"
    conditions -> string.join(conditions, " && ")
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
    <> "pub fn "
    <> function
    <> "_from_"
    <> base_function
    <> "(source: "
    <> base_type
    <> ","
    <> parameters
    <> ") -> Result("
    <> type_name
    <> ", Nil) { case "
    <> conditions
    <> " { False -> Error(Nil) True -> {\n"
    <> string.concat(list.reverse(source.bindings))
    <> "Ok("
    <> type_name
    <> "("
    <> string.concat(list.reverse(source.decoded))
    <> ")) } } }\n"
    <> "fn "
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
    <> "pub fn "
    <> function
    <> "_to_json(source: "
    <> type_name
    <> ","
    <> parameters
    <> ") -> Json { "
    <> base_function
    <> "_to_json("
    <> function
    <> "_to_"
    <> base_function
    <> "(source"
    <> arguments
    <> ")) }\n\n"
  list.append(children, [#(type_name, generated)])
}
