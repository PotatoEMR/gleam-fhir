import argv
import codegen_constraint
import fhir/r4_gen/client_httpc
import fhir/r4_gen/complex_type as r4ct
import fhir/r4_gen/resource as r4
import fhir/r4_gen/sansio
import fhir/r4_gen/valueset
import filepath
import gleam/bool
import gleam/dict.{type Dict}
import gleam/dynamic/decode
import gleam/int
import gleam/io
import gleam/json
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/set.{type Set}
import gleam/string
import simplifile

pub const client_resource_fields = [
  #("Bundle", [
    "Bundle.type",
    "Bundle.link",
    "Bundle.link.relation",
    "Bundle.link.url",
    "Bundle.entry",
    "Bundle.entry.resource",
  ]),
  #("Parameters", []),
  #("OperationOutcome", [
    "OperationOutcome.issue",
    "OperationOutcome.issue.severity",
    "OperationOutcome.issue.code",
  ]),
]

pub const valueset_parameter_fields = [
  "Parameters.parameter",
  "Parameters.parameter.name",
  "Parameters.parameter.value[x]",
  "Parameters.parameter.resource",
]

pub const valueset_parameter_types = ["uri", "string", "integer", "boolean"]

// These names come from resolved field types and decoder decisions, never
// from searching generated source.
pub type RequiredCode {
  RequiredCode(
    types: Set(String),
    functions: Set(String),
    modules: Set(String),
    valuesets: Dict(String, ValuesetItem),
  )
}

pub fn required_code() -> RequiredCode {
  RequiredCode(set.new(), set.new(), set.new(), dict.new())
}

pub fn merge_required_code(
  left: RequiredCode,
  right: RequiredCode,
) -> RequiredCode {
  RequiredCode(
    set.union(left.types, right.types),
    set.union(left.functions, right.functions),
    set.union(left.modules, right.modules),
    dict.fold(right.valuesets, left.valuesets, fn(valuesets, url, item) {
      insert_valueset(valuesets, url, item)
    }),
  )
}

pub fn require_function(required: RequiredCode, name: String) -> RequiredCode {
  RequiredCode(..required, functions: set.insert(required.functions, name))
}

// The generator represents resolved types as names with optional type arguments.
// Read that representation here, before it is placed in any generated source.
pub fn require_type(
  required: RequiredCode,
  field_type: String,
) -> RequiredCode {
  let names =
    field_type
    |> string.replace("(", ",")
    |> string.replace(")", ",")
    |> string.split(",")
    |> list.map(string.trim)
    |> list.filter(fn(name) { name != "" })
  list.fold(names, required, fn(required, name) {
    let required =
      RequiredCode(..required, types: set.insert(required.types, name))
    case name {
      "Float" -> require_function(required, "decode_number")
      "BoundCoding" -> require_function(required, "bound_coding_decoder")
      "ct.BoundCoding" -> require_function(required, "ct.bound_coding_decoder")
      "List1" | "List2" | "List3" -> {
        let name = string.lowercase(name)
        required
        |> require_function(name <> "_decoder")
        |> require_function(name <> "_to_json")
      }
      "Date" | "DateTime" | "Instant" | "Time" ->
        RequiredCode(..required, modules: set.insert(required.modules, "pt"))
      _ ->
        RequiredCode(..required, modules: case string.split(name, ".") {
          [module, _] -> set.insert(required.modules, module)
          _ -> required.modules
        })
    }
  })
}

pub fn required_names(
  dependencies: Dict(String, List(String)),
  pending: Set(String),
  required: Set(String),
) -> Set(String) {
  case set.to_list(pending) {
    [] -> required
    [name, ..] -> {
      let pending = set.delete(pending, name)
      case set.contains(required, name) {
        True -> required_names(dependencies, pending, required)
        False ->
          required_names(
            dependencies,
            set.union(
              pending,
              dict.get(dependencies, name) |> result.unwrap([]) |> set.from_list,
            ),
            set.insert(required, name),
          )
      }
    }
  }
}

pub type Bundle {
  Bundle(entry: List(Entry))
}

pub fn bundle_decoder() -> decode.Decoder(Bundle) {
  use entry <- decode.field("entry", decode.list(entry_decoder()))
  decode.success(Bundle(entry:))
}

pub type Entry {
  Entry(resource: Resource)
}

pub fn entry_decoder() -> decode.Decoder(Entry) {
  use resource <- decode.field("resource", resource_decoder())
  decode.success(Entry(resource:))
}

pub type Resource {
  Resource(
    snapshot: Option(Snapshot),
    resource_type: String,
    id: String,
    name: String,
    url: String,
    kind: Option(String),
    base_definition: Option(String),
    type_: Option(String),
    context: List(StructuredefinitionContext),
  )
}

pub fn resource_decoder() -> decode.Decoder(Resource) {
  use snapshot <- decode.optional_field(
    "snapshot",
    None,
    decode.optional(snapshot_decoder()),
  )
  use resource_type <- decode.field("resourceType", decode.string)
  use id <- decode.field("id", decode.string)
  use name <- decode.field("name", decode.string)
  use url <- decode.field("url", decode.string)
  use kind <- decode.optional_field(
    "kind",
    None,
    decode.optional(decode.string),
  )
  use base_definition <- decode.optional_field(
    "baseDefinition",
    None,
    decode.optional(decode.string),
  )
  use context <- decode.optional_field(
    "context",
    [],
    decode.list(structuredefinition_context_decoder()),
  )
  case resource_type {
    "StructureDefinition" -> {
      use type_ <- decode.optional_field(
        "type",
        None,
        decode.optional(decode.string),
      )
      decode.success(Resource(
        snapshot:,
        resource_type:,
        id:,
        name:,
        url:,
        kind:,
        base_definition:,
        type_:,
        context:,
      ))
    }
    _ ->
      decode.success(Resource(
        snapshot:,
        resource_type:,
        id:,
        name:,
        url:,
        kind:,
        base_definition:,
        type_: None,
        context:,
      ))
  }
}

pub type Snapshot {
  Snapshot(element: List(Element))
}

pub fn snapshot_decoder() -> decode.Decoder(Snapshot) {
  use element <- decode.optional_field(
    "element",
    [],
    decode.list(element_decoder()),
  )
  decode.success(
    Snapshot(
      element: list.index_map(element, fn(element, index) {
        Element(..element, definition_order: index)
      }),
    ),
  )
}

pub type Element {
  Element(
    id: String,
    path: String,
    definition_order: Int,
    gleam_field_name: Option(String),
    gleam_type: Option(String),
    gleam_arguments: Option(List(String)),
    base: ElementBase,
    slice_name: Option(String),
    slicing: Option(Slicing),
    min: Int,
    max: String,
    type_: List(Type),
    binding: Option(Binding),
    content_reference: Option(String),
    constraint: Option(codegen_constraint.Constraint),
    // Scalar entries required by an array inside an object pattern.
    pattern_literals: List(codegen_constraint.Value),
    fixed_code: Option(String),
    fixed_uri: Option(String),
    pattern_coding: Option(DiscriminatorCodingValue),
    pattern_codeableconcept: Option(DiscriminatorCodeableconceptValue),
    pattern_identifier: Option(DiscriminatorIdentifierValue),
    // Derived coding slices implementing a CodeableConcept pattern.
    pattern_match: Bool,
  )
}

pub fn element_decoder() -> decode.Decoder(Element) {
  use id <- decode.field("id", decode.string)
  use path <- decode.field("path", decode.string)
  use base <- decode.field("base", element_base_decoder())
  use slice_name <- decode.optional_field(
    "sliceName",
    None,
    decode.optional(decode.string),
  )
  use slicing <- decode.optional_field(
    "slicing",
    None,
    decode.optional(slicing_decoder()),
  )
  use min <- decode.field("min", decode.int)
  use max <- decode.field("max", decode.string)
  use type_ <- decode.optional_field("type", [], decode.list(type_decoder()))
  use binding <- decode.optional_field(
    "binding",
    None,
    decode.optional(binding_decoder()),
  )
  use content_reference <- decode.optional_field(
    "contentReference",
    None,
    decode.optional(decode.string),
  )
  use constraint <- decode.then(codegen_constraint.decoder())
  let value = option.map(constraint, fn(constraint) { constraint.value })
  let fixed_code = case constraint {
    Some(codegen_constraint.Constraint(
      type_name: "Code",
      value: codegen_constraint.Text(value),
      ..,
    )) -> codegen_constraint.text(Some(codegen_constraint.Text(value)))
    _ -> None
  }
  let fixed_uri = case constraint {
    Some(codegen_constraint.Constraint(
      type_name: "Uri",
      value: codegen_constraint.Text(value),
      ..,
    )) -> codegen_constraint.text(Some(codegen_constraint.Text(value)))
    _ -> None
  }
  let pattern_coding = case constraint {
    Some(codegen_constraint.Constraint(fixed: False, type_name: "Coding", ..)) ->
      option.map(value, coding_pattern)
    _ -> None
  }
  let pattern_codeableconcept = case constraint {
    Some(codegen_constraint.Constraint(
      fixed: False,
      type_name: "CodeableConcept",
      value:,
    )) -> {
      let coding = case codegen_constraint.field(value, "coding") {
        Some(codegen_constraint.Array(values)) ->
          list.map(values, coding_pattern)
        None -> []
        _ -> panic as "CodeableConcept coding pattern must be an array"
      }
      Some(DiscriminatorCodeableconceptValue(coding:))
    }
    _ -> None
  }
  let pattern_identifier = case constraint {
    Some(codegen_constraint.Constraint(
      fixed: False,
      type_name: "Identifier",
      value:,
    )) ->
      Some(DiscriminatorIdentifierValue(
        system: codegen_constraint.text(codegen_constraint.field(
          value,
          "system",
        )),
        value: codegen_constraint.text(codegen_constraint.field(value, "value")),
      ))
    _ -> None
  }
  decode.success(Element(
    id:,
    path:,
    definition_order: 0,
    gleam_field_name: None,
    gleam_type: None,
    gleam_arguments: None,
    base:,
    slice_name:,
    slicing:,
    min:,
    max:,
    type_:,
    binding:,
    content_reference:,
    constraint:,
    pattern_literals: [],
    fixed_code:,
    fixed_uri:,
    pattern_coding:,
    pattern_codeableconcept:,
    pattern_identifier:,
    pattern_match: False,
  ))
}

// Constant scalar values use the same field omission rules for every datatype.
pub fn constant(element: Element) -> Option(codegen_constraint.Value) {
  case element.fixed_code, element.fixed_uri, element.constraint {
    Some(value), _, _ | _, Some(value), _ ->
      Some(codegen_constraint.Text(value))
    _, _, Some(codegen_constraint.Constraint(value: value, ..)) ->
      case value {
        codegen_constraint.Object(_) | codegen_constraint.Array(_) ->
          case element.constraint {
            Some(codegen_constraint.Constraint(fixed: True, ..)) ->
              case element.slice_name {
                None -> Some(value)
                Some(_) -> None
              }
            _ -> None
          }
        _ -> Some(value)
      }
    _, _, _ -> None
  }
}

// These public shared types predate the recursive constraint representation.
// Avoid adding duplicate checks to their generated output.
pub fn constraint_uses_shared_type(element: Element) -> Bool {
  let shared_coding_fields = fn(
    fields: List(#(String, codegen_constraint.Value)),
  ) {
    list.all(fields, fn(field) {
      list.contains(["system", "code", "display"], field.0)
      && case field.1 {
        codegen_constraint.Text(value) ->
          codegen_constraint.text_can_use_legacy_template(value)
        _ -> False
      }
    })
  }
  case element.constraint {
    None -> False
    Some(codegen_constraint.Constraint(value: codegen_constraint.Text(_), ..)) ->
      element.fixed_code != None || element.fixed_uri != None
    Some(codegen_constraint.Constraint(fixed: False, value: value, type_name:)) ->
      case value {
        codegen_constraint.Object(fields) if type_name == "Coding" ->
          shared_coding_fields(fields)
        codegen_constraint.Object([
          #(
            "coding",
            codegen_constraint.Array([codegen_constraint.Object(fields)]),
          ),
        ])
          if type_name == "CodeableConcept"
        -> shared_coding_fields(fields)
        codegen_constraint.Object([#("system", codegen_constraint.Text(value))])
          if type_name == "Identifier"
        -> codegen_constraint.text_can_use_legacy_template(value)
        _ -> False
      }
    _ -> False
  }
}

pub fn constraint_needs_check(element: Element) -> Bool {
  element.constraint != None && !constraint_uses_shared_type(element)
}

pub type DiscriminatorCodingValue {
  DiscriminatorCodingValue(
    system: Option(String),
    code: Option(String),
    display: Option(String),
  )
}

pub fn coding_pattern(
  value: codegen_constraint.Value,
) -> DiscriminatorCodingValue {
  DiscriminatorCodingValue(
    system: codegen_constraint.text(codegen_constraint.field(value, "system")),
    code: codegen_constraint.text(codegen_constraint.field(value, "code")),
    display: codegen_constraint.text(codegen_constraint.field(value, "display")),
  )
}

pub type DiscriminatorCodeableconceptValue {
  DiscriminatorCodeableconceptValue(coding: List(DiscriminatorCodingValue))
}

pub type DiscriminatorIdentifierValue {
  DiscriminatorIdentifierValue(system: Option(String), value: Option(String))
}

pub type ElementBase {
  ElementBase(path: String, min: Int, max: String)
}

pub fn element_base_decoder() -> decode.Decoder(ElementBase) {
  use path <- decode.field("path", decode.string)
  use min <- decode.field("min", decode.int)
  use max <- decode.field("max", decode.string)
  decode.success(ElementBase(path:, min:, max:))
}

pub type Slicing {
  Slicing(discriminator: List(Discriminator), ordered: Bool, rules: String)
}

pub fn slicing_decoder() -> decode.Decoder(Slicing) {
  use discriminator <- decode.optional_field(
    "discriminator",
    [],
    decode.list(discriminator_decoder()),
  )
  use ordered <- decode.optional_field("ordered", False, decode.bool)
  use rules <- decode.field("rules", decode.string)
  decode.success(Slicing(discriminator:, ordered:, rules:))
}

pub type Discriminator {
  Discriminator(type_: String, path: String)
}

pub fn discriminator_decoder() -> decode.Decoder(Discriminator) {
  use type_ <- decode.field("type", decode.string)
  use path <- decode.field("path", decode.string)
  decode.success(Discriminator(type_:, path:))
}

pub type DiscriminatorCheck {
  DiscriminatorCheck(path: String, value: String)
}

pub type Type {
  Type(code: String, target_profile: List(String), profile: List(String))
}

pub fn type_decoder() -> decode.Decoder(Type) {
  use code <- decode.field("code", decode.string)
  use extensions <- decode.optional_field(
    "extension",
    [],
    decode.list({
      use url <- decode.field("url", decode.string)
      use value_url <- decode.optional_field("valueUrl", "", decode.string)
      decode.success(#(url, value_url))
    }),
  )
  let code =
    list.fold(extensions, code, fn(code, extension) {
      case
        string.starts_with(code, "http://hl7.org/fhirpath/System."),
        extension
      {
        True,
          #(
            "http://hl7.org/fhir/StructureDefinition/structuredefinition-fhir-type",
            fhir_type,
          )
          if fhir_type != ""
        -> fhir_type
        _, _ -> code
      }
    })
  use target_profile <- decode.optional_field(
    "targetProfile",
    [],
    decode.list(decode.string),
  )
  use profile <- decode.optional_field(
    "profile",
    [],
    decode.list(decode.string),
  )
  decode.success(Type(code:, target_profile:, profile:))
}

pub type Binding {
  Binding(strength: String, value_set: Option(String), available: Bool)
}

pub fn binding_decoder() -> decode.Decoder(Binding) {
  use strength <- decode.field("strength", decode.string)
  use value_set <- decode.optional_field(
    "valueSet",
    None,
    decode.optional(decode.string),
  )
  decode.success(Binding(strength:, value_set:, available: True))
}

pub type StructuredefinitionContext {
  StructuredefinitionContext(expression: String)
}

pub fn structuredefinition_context_decoder() {
  use expression <- decode.field("expression", decode.string)
  decode.success(StructuredefinitionContext(expression:))
}

// --------------- idk ----------------

pub fn to_camel_case(input: String) -> String {
  // only first letter and then each backbone elt is capital
  // so you can see nested backbone elements
  input
  |> string.replace("-", "_")
  |> string.replace(".", "_")
  |> string.split("_")
  |> list.map(fn(s) { string.capitalise(s) })
  |> string.concat
}

pub fn cardinality(fieldtype: String, fieldmin: Int, fieldmax: String) {
  case fieldmin, fieldmax {
    0, "1" -> "Option(" <> fieldtype <> ")"
    1, "1" -> fieldtype
    // TODO enforce max somehow
    0, _ -> "List(" <> fieldtype <> ")"
    1, _ -> "List1(" <> fieldtype <> ")"
    2, _ -> "List2(" <> fieldtype <> ")"
    3, _ -> "List3(" <> fieldtype <> ")"
    _, _ ->
      panic as {
        "unsupported cardinality "
        <> int.to_string(fieldmin)
        <> ".."
        <> fieldmax
        <> " for "
        <> fieldtype
      }
  }
}

// The emitted signature and recorded argument use the same field type.
pub fn new_fn_arg_and_field(
  field_name: String,
  field_type: String,
  min: Int,
  max: String,
  is_primitive: Bool,
) -> #(String, String, Option(#(String, String))) {
  let max = case max {
    "0" | "1" -> max
    _ -> "*"
  }
  let #(required, field) = case min, max {
    0, "*" -> #(False, field_name <> ": [],")
    1, "*" if is_primitive -> #(False, field_name <> ": [],")
    1, "*" | 2, "*" | 3, "*" -> #(True, field_name <> ":,")
    0, "1" | 1, _ if is_primitive -> #(
      False,
      field_name <> ": Primitive(id: None, extension: [], value: None),",
    )
    0, "1" -> #(False, field_name <> ": None,")
    0, _ -> #(False, field_name <> ": [],")
    1, _ -> #(True, field_name <> ":,")
    _, _ -> panic as "cardinality panic 2"
  }
  let required = case required {
    False -> None
    True -> Some(#(field_name, cardinality(field_type, min, max)))
  }
  let argument = case required {
    None -> ""
    Some(#(name, type_)) -> name <> " " <> name <> ": " <> type_ <> ","
  }
  #(argument, field, required)
}

pub fn field_name(element: Element) -> String {
  case element.gleam_field_name {
    Some(name) -> name
    None -> {
      let assert Ok(last) = element.id |> string.split(".") |> list.last
      element.slice_name
      |> option.unwrap(last)
      |> string.replace("[x]", "")
      |> escape_field_name
      |> to_snake_case
      |> string.append(case element.pattern_literals {
        [] -> ""
        _ -> "_others"
      })
    }
  }
}

// Assign names once per record, including each occurrence of a repeated element.
pub fn name_record_fields(
  fields: List(Element),
  emitted_fields: List(Element),
) -> List(Element) {
  let counts =
    list.fold(emitted_fields, dict.new(), fn(counts, field) {
      let name = field_name(Element(..field, gleam_field_name: None))
      let count = dict.get(counts, name) |> result.unwrap(0)
      dict.insert(counts, name, count + 1)
    })
  // Reserve existing names so a suffix cannot collide with another field.
  let reserved = counts |> dict.keys |> set.from_list
  let #(fields, _) =
    list.fold(fields, #([], reserved), fn(acc, field) {
      let #(assigned, reserved) = acc
      let name = field_name(Element(..field, gleam_field_name: None))
      let count = dict.get(counts, name) |> result.unwrap(0)
      let name = case count > 1 && list.contains(emitted_fields, field) {
        False -> name
        True -> {
          let stem = case string.ends_with(name, "_") {
            True -> name
            False -> name <> "_"
          }
          let assert Some(name) =
            int.range(
              1,
              list.length(fields) + set.size(reserved),
              None,
              fn(found, number) {
                case found {
                  Some(_) -> found
                  None -> {
                    let candidate = stem <> int.to_string(number)
                    case set.contains(reserved, candidate) {
                      True -> None
                      False -> Some(candidate)
                    }
                  }
                }
              },
            )
          name
        }
      }
      #(
        [Element(..field, gleam_field_name: Some(name)), ..assigned],
        set.insert(reserved, name),
      )
    })
  list.reverse(fields)
}

pub fn record_update_source(
  constructor: String,
  record: String,
  fields: List(String),
  updates: List(#(String, String)),
) -> String {
  let updated_fields = list.map(updates, fn(update) { update.0 })
  let assert True =
    list.all(updated_fields, fn(field) { list.contains(fields, field) })
    as "record update contains an unknown field"
  let spread = case
    list.all(fields, fn(field) { list.contains(updated_fields, field) })
  {
    True -> ""
    False -> ".." <> record <> ", "
  }
  constructor
  <> "("
  <> spread
  <> string.join(
    list.map(updates, fn(update) { update.0 <> ": " <> update.1 }),
    ", ",
  )
  <> ")"
}

pub fn escape_field_name(name: String) -> String {
  case name {
    "as" -> "as_"
    "assert" -> "assert_"
    "auto" -> "auto_"
    "case" -> "case_"
    "const" -> "const_"
    "delegate" -> "delegate_"
    "derive" -> "derive_"
    "echo" -> "echo_"
    "else" -> "else_"
    "fn" -> "fn_"
    "if" -> "if_"
    "implement" -> "implement_"
    "import" -> "import_"
    "let" -> "let_"
    "macro" -> "macro_"
    "opaque" -> "opaque_"
    "panic" -> "panic_"
    "pub" -> "pub_"
    "test" -> "test_"
    "todo" -> "todo_"
    "type" -> "type_"
    "use" -> "use_"
    _ -> {
      case
        list.contains(
          ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
          string.slice(name, 0, 1),
        )
      {
        True -> "num_" <> name
        False -> name
      }
    }
  }
}

// replace capital HelloThere with lowercase hello_there
// but if the previous character was a capital it will not add an underscore
pub fn to_snake_case(input: String) -> String {
  input
  |> string.replace("-", "_")
  |> string.to_graphemes
  |> list.fold(#("", False), fn(acc, char) {
    let #(result, prev_was_upper) = acc
    case char == string.uppercase(char) && char != string.lowercase(char) {
      True -> {
        case result, prev_was_upper {
          "", _ -> #(string.lowercase(char), True)
          _, True -> #(result <> string.lowercase(char), True)
          _, False -> #(result <> "_" <> string.lowercase(char), True)
        }
      }
      False -> #(result <> char, False)
    }
  })
  |> fn(pair) { pair.0 }
}

pub fn link_type_from(
  content_reference: Option(String),
  resource_name: String,
) {
  let assert Some(link_type) = content_reference
  let assert [_, link_type] = string.split(link_type, "#")
  let assert [_, ..rest] = string.split(link_type, ".")
  [resource_name, ..rest]
  |> string.join("_")
  |> string.lowercase()
}

pub fn string_to_type(
  fhir_type: String,
  allparts: List(String),
  elt: Element,
  current: Category,
  required_value_sets_acc: Dict(String, ValuesetItem),
) -> #(String, Dict(String, ValuesetItem)) {
  case fhir_type {
    "Coding" ->
      bound_complex_type(
        "BoundCoding",
        "Coding",
        elt,
        current,
        required_value_sets_acc,
      )
    "CodeableConcept" ->
      bound_complex_type(
        "BoundCodeableconcept",
        "Codeableconcept",
        elt,
        current,
        required_value_sets_acc,
      )
    "CodeableReference" ->
      bound_complex_type(
        "BoundCodeablereference",
        "Codeablereference",
        elt,
        current,
        required_value_sets_acc,
      )
    "Quantity" ->
      bound_complex_type(
        "BoundQuantity",
        "Quantity",
        elt,
        current,
        required_value_sets_acc,
      )
    "code" -> {
      case elt.binding {
        Some(Binding(
          strength: "required",
          value_set: Some(value_set),
          available: True,
        )) -> {
          let assert [url, ..] = string.split(value_set, "|")
          // case
          //   string.contains(url, "v3-Confidentiality")
          //   || string.contains(url, "mimetypes")
          //   || string.contains(url, "currencies")
          //   || string.contains(url, "all-languages")
          //   || string.contains(url, "ucum-units")
          //   || string.contains(url, "color-codes")
          // {
          //   True -> #("String", required_value_sets_acc)
          //   False -> #(
          //     "valueset." <> concept_name_from_url(url),
          //     insert_valueset(
          //       required_value_sets_acc,
          //       url,
          //       ValuesetItem(needs_system: False, needs_code: True),
          //     ),
          //   )
          // }
          #(
            "valueset." <> concept_name_from_url(url),
            insert_valueset(
              required_value_sets_acc,
              url,
              ValuesetItem(
                needs_system: False,
                needs_code: True,
                needs_membership: False,
              ),
            ),
          )
        }
        Some(Binding(strength: "required", value_set: None, available: True)) ->
          panic as "required code binding has no ValueSet"
        _ -> #("String", required_value_sets_acc)
      }
    }
    // keeping track of required valueset codes
    // but if type is not code, Coding, CodeableConcept, or CodeableReference, it couldn't
    // possibly have a required code binding
    non_code_type -> #(
      case non_code_type {
        "BackboneElement" ->
          allparts |> list.map(string.capitalise) |> string.concat()
        "Element" -> allparts |> list.map(string.capitalise) |> string.concat()
        "base64Binary" -> "String"
        "boolean" -> "Bool"
        "canonical" -> "String"
        "date" -> "Date"
        "dateTime" -> "DateTime"
        "decimal" -> "Float"
        "id" -> "String"
        "instant" -> "Instant"
        "integer" -> "Int"
        "integer64" -> "String"
        "markdown" -> "String"
        "oid" -> "String"
        "positiveInt" -> "Int"
        "string" -> "String"
        "time" -> "Time"
        "unsignedInt" -> "Int"
        "uri" -> "String"
        "url" -> "String"
        "uuid" -> "String"
        "xhtml" -> "String"
        "http://hl7.org/fhirpath/System.String" -> "String"
        _ -> {
          let camel = to_camel_case(fhir_type)
          bucket_prefix(camel, current) <> camel
        }
        //other complex type case will just be itself eg "Annotation" -> "Annotation"
        // and will require importing that type
      },
      required_value_sets_acc,
    )
  }
}

fn bound_complex_type(
  bound_type: String,
  normal_type: String,
  elt: Element,
  current: Category,
  required_value_sets_acc: Dict(String, ValuesetItem),
) -> #(String, Dict(String, ValuesetItem)) {
  let prefix = bucket_prefix(normal_type, current)
  case elt.binding {
    None | Some(Binding(strength: "required", value_set: None, ..)) -> #(
      prefix <> normal_type,
      required_value_sets_acc,
    )
    Some(Binding(
      strength: "required",
      value_set: Some(value_set),
      available: True,
    )) -> {
      let assert [url, ..] = string.split(value_set, "|")
      #(
        prefix
          <> case elt.gleam_type {
          Some(name) ->
            case string.starts_with(name, "BoundCoding") {
              True -> name
              False -> bound_type
            }
          _ -> bound_type
        }
          <> "(valueset."
          <> concept_name_from_url(url)
          <> ")",
        insert_valueset(
          required_value_sets_acc,
          url,
          ValuesetItem(
            needs_system: True,
            needs_code: False,
            needs_membership: False,
          ),
        ),
      )
    }
    Some(_) -> #(prefix <> normal_type, required_value_sets_acc)
  }
}

pub type ValuesetItem {
  ValuesetItem(needs_system: Bool, needs_code: Bool, needs_membership: Bool)
}

pub fn insert_valueset(
  valuesets: Dict(String, ValuesetItem),
  url: String,
  item: ValuesetItem,
) -> Dict(String, ValuesetItem) {
  let previous = dict.get(valuesets, url) |> result.unwrap(item)
  dict.insert(
    valuesets,
    url,
    ValuesetItem(
      needs_system: previous.needs_system || item.needs_system,
      needs_code: previous.needs_code || item.needs_code,
      needs_membership: previous.needs_membership || item.needs_membership,
    ),
  )
}

// Category: where a top-level FHIR type lives in the split output.
// All complex-type datatypes (general-purpose, special-purpose, metadata)
// live together in {prefix}_complex_types.gleam. Resources live in the main
// {prefix}.gleam. Single complex-types file avoids import cycles from
// Extension.value[x] referencing metadata types like DataRequirement.
pub type Category {
  ComplexTypes
  Resources
}

// "" or prefix if needed to import from module
pub fn bucket_prefix(type_name: String, current: Category) -> String {
  let target = case type_name {
    "Resource" | "DomainResource" -> Resources
    _ -> ComplexTypes
  }

  case target == current, target {
    True, _ -> ""
    False, ComplexTypes -> "ct."
    False, Resources -> ""
  }
}

pub fn concept_name_from_url(url) {
  let url = case url |> string.ends_with("/") {
    False -> url
    True -> url |> string.drop_end(1)
  }
  let assert Ok(urlname) = url |> string.split("/") |> list.last()
  let assert [fst, ..rest] = string.to_graphemes(urlname)
  let urlname = case fst {
    "0" -> string.concat(["Zero", ..rest])
    "1" -> string.concat(["One", ..rest])
    "2" -> string.concat(["Two", ..rest])
    "3" -> string.concat(["Three", ..rest])
    "4" -> string.concat(["Four", ..rest])
    "5" -> string.concat(["Five", ..rest])
    "6" -> string.concat(["Six", ..rest])
    "7" -> string.concat(["Seven", ..rest])
    "8" -> string.concat(["Eight", ..rest])
    "9" -> string.concat(["Nine", ..rest])
    _ -> urlname
  }
  let urlname =
    list.fold(valueset.all_types, urlname, fn(name, type_) {
      let type_name = valueset.all_types_to_code(type_)
      let prefix = type_name |> to_snake_case |> string.replace("_", "-")
      case string.starts_with(string.lowercase(name), prefix <> "-") {
        True ->
          string.lowercase(type_name)
          <> string.drop_start(name, string.length(prefix))
        False -> name
      }
    })
  urlname
  |> string.replace(" ", "")
  |> to_camel_case
  |> codetovarname
}

pub type VsOrCs {
  VocValueset(
    version: Option(String),
    codes: List(#(String, String)),
    // package_dir: String,
  )
  VocUnavailable
  // VocCodesystem(c: r4.Codesystem)
}

// Only complete expansions can produce an enum.
pub fn valueset_can_generate_system(
  vs_url: String,
  all_vs_or_cs: Dict(String, VsOrCs),
) -> Bool {
  case dict.get(all_vs_or_cs, vs_url) {
    Ok(VocValueset(_, _)) -> True
    _ -> False
  }
}

// pub fn valueset_can_generate_system(
//   vs_url: String,
//   all_vs_or_cs: Dict(String, VsOrCs),
// ) -> Bool {
//   case dict.get(all_vs_or_cs, vs_url) {
//     Ok(VocValueset(r4.Valueset(compose: Some(compose), ..), _)) ->
//       [compose.include.first, ..compose.include.rest]
//       |> list.all(fn(include) {
//         case include.system, include.value_set {
//           Some(_), _ -> True
//           None, [] -> False
//           None, value_sets ->
//             list.all(value_sets, fn(value_set) {
//               valueset_can_generate_system(value_set, all_vs_or_cs)
//             })
//         }
//       })
//     _ -> False
//   }
// }
//
// pub fn valueset_can_generate_discriminator(
//   vs_url: String,
//   all_vs_or_cs: Dict(String, VsOrCs),
// ) -> Bool {
//   case dict.get(all_vs_or_cs, vs_url) {
//     Ok(VocValueset(r4.Valueset(compose: Some(compose), ..), _)) ->
//       compose.exclude == []
//       && [compose.include.first, ..compose.include.rest]
//       |> list.all(fn(include) {
//         case
//           include.concept,
//           include.filter,
//           include.system,
//           include.value_set
//         {
//           [_, ..], [], Some(_), [] -> True
//           [], [], Some(_), [] -> True
//           [], [], None, [_, ..] as value_sets ->
//             list.all(value_sets, fn(value_set) {
//               valueset_can_generate_discriminator(value_set, all_vs_or_cs)
//             })
//           _, _, _, _ -> False
//         }
//       })
//     _ -> False
//   }
// }
//

fn package_dependencies_decoder() {
  use dependencies <- decode.optional_field(
    "dependencies",
    dict.new(),
    decode.dict(decode.string, decode.string),
  )
  decode.success(dependencies)
}

fn package_dependencies(package_dir: String) {
  let package_json = filepath.join(package_dir, "package.json")
  let assert Ok(contents) = simplifile.read(package_json)
  let assert Ok(dependencies) =
    json.parse(contents, package_dependencies_decoder())
  dependencies
}

pub fn package_directories(profiles_dir: String) {
  let package_store =
    profiles_dir
    |> filepath.directory_name
    |> filepath.directory_name
    |> filepath.directory_name
  package_directories_loop([#(profiles_dir, 0)], package_store, dict.new())
  |> dict.to_list
  |> list.sort(fn(first, second) { int.compare(second.1, first.1) })
  |> list.map(fn(entry) { entry.0 })
}

fn package_directories_loop(
  pending: List(#(String, Int)),
  package_store: String,
  directories: Dict(String, Int),
) -> Dict(String, Int) {
  case pending {
    [] -> directories
    [#(package_dir, depth), ..rest] ->
      case dict.get(directories, package_dir) {
        Ok(previous_depth) if previous_depth <= depth ->
          package_directories_loop(rest, package_store, directories)
        Error(_) | Ok(_) -> {
          let dependencies = package_dependencies(package_dir)
          let pending =
            dependencies
            |> dict.to_list
            |> list.fold(rest, fn(pending, dependency) {
              let dependency_dir =
                package_store
                |> filepath.join(dependency.0)
                |> filepath.join(dependency.1)
                |> filepath.join("package")
              [#(dependency_dir, depth + 1), ..pending]
            })
          package_directories_loop(
            pending,
            package_store,
            dict.insert(directories, package_dir, depth),
          )
        }
      }
  }
}

/// Use downloaded expansions or explicit code lists, then the server, then strings.
/// Cache complete server responses with the source definition and server URL.
pub fn load_valuesets(
  package_dir: String,
  required_value_sets: Set(String),
  previous: Dict(String, VsOrCs),
  fhir_version: String,
) -> Dict(String, VsOrCs) {
  let directories = package_directories(package_dir) |> list.reverse
  let server =
    argv.load().arguments
    |> list.find(fn(arg) { string.starts_with(arg, "terminologyserver=") })
    |> result.map(fn(arg) {
      string.drop_start(arg, string.length("terminologyserver="))
    })
    |> result.unwrap("https://tx.fhir.org/" <> fhir_version)
  let assert Ok(client) = sansio.fhirclient_new(server)
  let required_versions =
    set.fold(required_value_sets, dict.new(), fn(versions, reference) {
      case string.split(reference, "|") {
        [url, version] -> {
          let assert True =
            result.unwrap(dict.get(versions, url), version) == version
            as { "conflicting required ValueSet versions for " <> url }
          dict.insert(versions, url, version)
        }
        _ -> versions
      }
    })
  set.fold(required_value_sets, previous, fn(loaded, reference) {
    let assert [url, ..] = string.split(reference, "|")
    case dict.get(loaded, url) {
      Ok(item) -> {
        case item, dict.get(required_versions, url) {
          VocValueset(loaded_version, _), Ok(version) -> {
            let assert True = loaded_version == Some(version)
              as { "conflicting required ValueSet versions for " <> url }
            Nil
          }
          _, _ -> Nil
        }
        dict.insert(loaded, reference, item)
      }
      Error(_) -> {
        let assert Ok(name) = list.last(string.split(url, "/"))
        let version = dict.get(required_versions, url) |> option.from_result
        let downloaded =
          directories
          |> list.find_map(fn(directory) {
            let path = filepath.join(directory, "ValueSet-" <> name <> ".json")
            use contents <- result.try(
              simplifile.read(path) |> result.replace_error(Nil),
            )
            use definition <- result.try(
              json.parse(contents, r4.valueset_decoder())
              |> result.replace_error(Nil),
            )
            case
              definition.url == Some(url)
              && { version == None || definition.version == version }
            {
              True -> Ok(#(definition, path, contents))
              False -> Error(Nil)
            }
          })
        let #(definition, path, source) = case downloaded {
          Ok(found) -> found
          Error(_) -> {
            let definition =
              r4.Valueset(
                ..r4.valueset_new(valueset.PublicationStatusActive),
                url: Some(url),
                version:,
              )
            #(
              definition,
              filepath.join(package_dir, "ValueSet-" <> name <> ".json"),
              "",
            )
          }
        }
        let cache_path = path <> ".expansion.json"
        let expanded = case
          complete_valueset(definition)
          |> result.lazy_or(fn() {
            complete_valueset(r4.Valueset(..definition, expansion: None))
          })
        {
          Ok(complete) -> Ok(complete)
          Error(_) -> {
            let cached = {
              use contents <- result.try(
                simplifile.read(cache_path) |> result.replace_error(Nil),
              )
              use cached <- result.try(
                json.parse(contents, {
                  use cached_source <- decode.field("source", decode.string)
                  use cached_server <- decode.field("server", decode.string)
                  use value_set <- decode.field(
                    "valueSet",
                    r4.valueset_decoder(),
                  )
                  decode.success(#(cached_source, cached_server, value_set))
                })
                |> result.replace_error(Nil),
              )
              case
                cached.0 == source
                && cached.1 == server
                && cached.2.url == Some(url)
                && { version == None || cached.2.version == version }
              {
                True -> complete_valueset(cached.2)
                False -> Error(Nil)
              }
            }
            case cached {
              Ok(complete) -> Ok(complete)
              Error(_) -> {
                io.println(
                  "expanding valueset " <> reference <> " at " <> server,
                )
                let response =
                  client_httpc.valueset_expand(
                    r4.Valueset(..definition, expansion: None),
                    client,
                  )
                case response {
                  Ok(value_set) -> {
                    let complete = case
                      value_set.url == Some(url)
                      && { version == None || value_set.version == version }
                    {
                      True -> complete_valueset(value_set)
                      False -> Error(Nil)
                    }
                    case complete {
                      Ok(_) -> {
                        let cache =
                          json.object([
                            #("source", json.string(source)),
                            #("server", json.string(server)),
                            #("valueSet", r4.valueset_to_json(value_set)),
                          ])
                          |> json.to_string
                        let assert Ok(_) = simplifile.write(cache_path, cache)
                        Nil
                      }
                      Error(_) ->
                        io.println(
                          "incomplete or mismatched expansion for " <> reference,
                        )
                    }
                    complete
                  }
                  Error(err) -> {
                    io.println(
                      "could not expand "
                      <> reference
                      <> ": "
                      <> client_httpc.err_valueset_to_string(err),
                    )
                    Error(Nil)
                  }
                }
              }
            }
          }
        }
        case expanded {
          Error(_) -> {
            let assert True =
              url != "http://hl7.org/fhir/ValueSet/quantity-comparator"
              as "Quantity.comparator requires a complete ValueSet expansion"
            loaded
            |> dict.insert(reference, VocUnavailable)
            |> dict.insert(url, VocUnavailable)
          }
          Ok(item) -> {
            // let package_dir = filepath.directory_name(path)
            loaded |> dict.insert(reference, item) |> dict.insert(url, item)
          }
        }
      }
    }
  })
}

// Both downloaded and server expansions must pass the same completeness checks.
fn complete_valueset(value_set: r4.Valueset) -> Result(VsOrCs, Nil) {
  use entries <- result.try(case value_set.expansion {
    Some(expansion) ->
      Ok(
        list.map(expansion_entries(expansion.contains), fn(entry) {
          #(entry.system, entry.code, entry.abstract)
        }),
      )
    None -> {
      use compose <- result.try(option.to_result(value_set.compose, Nil))
      let includes = [compose.include.first, ..compose.include.rest]
      use <- bool.guard(
        compose.exclude != []
          || compose.locked_date != None
          || compose.inactive == Some(False)
          || compose.modifier_extension != []
          || value_set.modifier_extension != []
          || list.any(includes, fn(include) {
          include.system == None
          || include.concept == []
          || include.filter != []
          || include.value_set != []
          || include.modifier_extension != []
          || list.any(include.concept, fn(concept) {
            concept.modifier_extension != []
          })
        }),
        Error(Nil),
      )
      Ok(
        list.flat_map(includes, fn(include) {
          list.map(include.concept, fn(concept) {
            #(include.system, Some(concept.code), None)
          })
        }),
      )
    }
  })
  use members <- result.try(
    list.try_fold(entries, dict.new(), fn(members, entry) {
      case entry {
        #(Some(system), Some(code), _) ->
          Ok(dict.insert(members, #(system, code), entry))
        #(_, None, _) -> Ok(members)
        #(None, Some(_), _) -> Error(Nil)
      }
    }),
  )
  // Different codes must not turn into the same Gleam constructor.
  use _ <- result.try(
    list.try_fold(dict.keys(members), dict.new(), fn(names, member) {
      let name = codetovarname(member.1) |> string.capitalise
      case dict.get(names, name) {
        Ok(code) if code != member.1 -> Error(Nil)
        _ -> Ok(dict.insert(names, name, member.1))
      }
    }),
  )
  let complete = case value_set.expansion {
    None -> True
    Some(expansion) ->
      option.unwrap(expansion.offset, 0) == 0
      && case expansion.total, expansion.offset {
        Some(total), _ -> total == dict.size(members)
        None, None -> True
        None, Some(_) -> False
      }
      && !list.any(expansion.parameter, fn(parameter) {
        case parameter.name, parameter.value {
          "filter", _ | "exclude-system", _ | "force-system-version", _ -> True
          "offset", Some(r4.ValuesetExpansionParameterValueInteger(0)) -> False
          "offset", _ -> True
          "count", _ -> expansion.total == None
          "excludeNotForUI",
            Some(r4.ValuesetExpansionParameterValueBoolean(True))
          | "activeOnly", Some(r4.ValuesetExpansionParameterValueBoolean(True))
          | "excludePostCoordinated",
            Some(r4.ValuesetExpansionParameterValueBoolean(True))
          -> True
          _, _ -> False
        }
      })
      && !list.any(expansion.extension, fn(extension) {
        extension.url
        == "http://hl7.org/fhir/StructureDefinition/valueset-unclosed"
        && extension.extension
        == r4ct.ExtensionSimple(r4ct.ExtensionValueBoolean(True))
      })
  }
  case complete {
    False -> Error(Nil)
    True -> {
      let codes =
        entries
        |> list.filter_map(fn(entry) {
          case entry {
            #(Some(system), Some(code), abstract) if abstract != Some(True) ->
              Ok(#(system, code))
            _ -> Error(Nil)
          }
        })
        |> list.unique
      case codes {
        [] -> Error(Nil)
        _ -> Ok(VocValueset(value_set.version, codes))
      }
    }
  }
}

// pub fn load_valuesets(
//   package_dir: String,
//   required_value_sets: Set(String),
// ) -> Dict(String, VsOrCs) {
//   let required_value_set_files =
//     required_value_sets
//     |> set.map(value_set_filename)
//   let required_versions =
//     required_value_sets
//     |> set.fold(dict.new(), insert_required_valueset_version)
//
//   let num_vs_files = required_value_set_files |> set.size |> int.to_string
//   io.println("loading " <> num_vs_files <> " valueset json files")
//
//   let package_directories = package_directories(package_dir)
//   let all_vs_or_cs =
//     package_directories
//     |> list.fold(dict.new(), fn(all_vs_or_cs, directory) {
//       io.println("loading valuesets from " <> directory)
//       load_valuesets_from_directory(
//         directory,
//         all_vs_or_cs,
//         required_value_set_files,
//         required_versions,
//       )
//     })
//   load_imported_valuesets(
//     package_directories,
//     all_vs_or_cs,
//     required_value_set_files,
//     required_versions,
//   )
// }
//
// fn insert_required_valueset_version(
//   versions: Dict(String, String),
//   reference: String,
// ) -> Dict(String, String) {
//   case string.split(reference, "|") {
//     [url, version] ->
//       case dict.get(versions, url) {
//         Ok(previous) if previous != version ->
//           panic as {
//             "conflicting required ValueSet versions for "
//             <> url
//             <> ": "
//             <> previous
//             <> " and "
//             <> version
//           }
//         _ -> dict.insert(versions, url, version)
//       }
//     _ -> versions
//   }
// }
//
// fn load_imported_valuesets(
//   package_directories: List(String),
//   all_vs_or_cs: Dict(String, VsOrCs),
//   loaded_value_set_files: Set(String),
//   required_versions: Dict(String, String),
// ) -> Dict(String, VsOrCs) {
//   let imported_value_sets =
//     all_vs_or_cs
//     |> dict.to_list
//     |> list.flat_map(fn(entry) {
//       case entry.1 {
//         VocCodesystem(_) -> []
//         VocValueset(r4.Valueset(compose: None, ..), _) -> []
//         VocValueset(r4.Valueset(compose: Some(compose), ..), _) ->
//           list.append(
//             [compose.include.first, ..compose.include.rest],
//             compose.exclude,
//           )
//           |> list.flat_map(fn(include) { include.value_set })
//       }
//     })
//     |> set.from_list
//   let required_versions =
//     imported_value_sets
//     |> set.fold(required_versions, insert_required_valueset_version)
//   let imported_value_set_files =
//     imported_value_sets
//     |> set.map(value_set_filename)
//     |> set.difference(loaded_value_set_files)
//
//   case set.is_empty(imported_value_set_files) {
//     True -> all_vs_or_cs
//     False -> {
//       let all_vs_or_cs =
//         package_directories
//         |> list.fold(all_vs_or_cs, fn(all_vs_or_cs, package_dir) {
//           imported_value_set_files
//           |> set.fold(all_vs_or_cs, fn(all_vs_or_cs, filename) {
//             load_valueset_file(
//               filepath.join(package_dir, filename),
//               all_vs_or_cs,
//               required_versions,
//             )
//           })
//         })
//       load_imported_valuesets(
//         package_directories,
//         all_vs_or_cs,
//         set.union(loaded_value_set_files, imported_value_set_files),
//         required_versions,
//       )
//     }
//   }
// }
//
// fn value_set_filename(url: String) -> String {
//   let assert [url, ..] = string.split(url, "|")
//   let assert Ok(name) = url |> string.split("/") |> list.last
//   "ValueSet-" <> name <> ".json"
// }
//
// fn load_valuesets_from_directory(
//   package_dir: String,
//   all_vs_or_cs: Dict(String, VsOrCs),
//   required_value_set_files: Set(String),
//   required_versions: Dict(String, String),
// ) {
//   let assert Ok(files) = simplifile.read_directory(package_dir)
//   list.fold(from: all_vs_or_cs, over: files, with: fn(acc, filename) {
//     let path = filepath.join(package_dir, filename)
//     case
//       string.starts_with(filename, "ValueSet-")
//       && set.contains(required_value_set_files, filename)
//     {
//       True -> load_valueset_file(path, acc, required_versions)
//       False ->
//         case string.starts_with(filename, "CodeSystem-") {
//           True -> {
//             let assert Ok(contents) = simplifile.read(path)
//             //TODO CodeSystem-v2-0229.json has _valueString primitive extension without valueString which our ct.Extension rejects
//             case json.parse(contents, r4.codesystem_decoder()) {
//               Ok(codesystem) ->
//                 case codesystem.url {
//                   Some(url) -> {
//                     let definition = VocCodesystem(codesystem)
//                     let acc = case codesystem.version {
//                       Some(version) ->
//                         dict.insert(acc, url <> "|" <> version, definition)
//                       None -> acc
//                     }
//                     acc
//                     |> dict.insert(url, definition)
//                     |> dict.insert(package_dir <> "|" <> url, definition)
//                   }
//                   None -> acc
//                 }
//               Error(_) -> acc
//             }
//           }
//           False -> acc
//         }
//     }
//   })
// }
//
// fn load_valueset_file(
//   path: String,
//   all_vs_or_cs: Dict(String, VsOrCs),
//   required_versions: Dict(String, String),
// ) {
//   case simplifile.is_file(path) {
//     Ok(True) -> {
//       let assert Ok(contents) = simplifile.read(path)
//       case json.parse(contents, r4.valueset_decoder()) {
//         Error(_) -> all_vs_or_cs
//         Ok(valueset) -> {
//           let valueset = case valueset.expansion {
//             Some(expansion) -> {
//               let entries =
//                 concepts_get_codes(expansion.contains, fn(entry) {
//                   #(Some(entry), entry.contains)
//                 })
//               let concepts =
//                 entries
//                 |> list.filter_map(fn(entry) {
//                   case entry.code {
//                     None -> Error(Nil)
//                     Some(code) -> {
//                       let assert Some(system) = entry.system
//                         as "ValueSet expansion code has no system"
//                       Ok(#(system, code))
//                     }
//                   }
//                 })
//                 |> set.from_list
//               let complete =
//                 option.unwrap(expansion.offset, 0) == 0
//                 && {
//                   case expansion.total, expansion.offset {
//                     Some(total), _ -> total == set.size(concepts)
//                     None, None -> True
//                     None, Some(_) -> False
//                   }
//                 }
//                 && !list.any(expansion.parameter, fn(parameter) {
//                   case parameter.name, parameter.value {
//                     "filter", _
//                     | "exclude-system", _
//                     | "force-system-version", _
//                     -> True
//                     "offset", Some(r4.ValuesetExpansionParameterValueInteger(0))
//                     -> False
//                     "offset", _ -> True
//                     "count", _ -> expansion.total == None
//                     "activeOnly",
//                       Some(r4.ValuesetExpansionParameterValueBoolean(True))
//                     | "excludePostCoordinated",
//                       Some(r4.ValuesetExpansionParameterValueBoolean(True))
//                     -> True
//                     _, _ -> False
//                   }
//                 })
//                 && !list.any(expansion.extension, fn(extension) {
//                   extension.url
//                   == "http://hl7.org/fhir/StructureDefinition/valueset-unclosed"
//                   && extension.extension
//                   == r4ct.ExtSimple(r4ct.ExtensionValueBoolean(True))
//                 })
//               let includes =
//                 entries
//                 |> list.filter(fn(item) {
//                   item.code != None && item.abstract != Some(True)
//                 })
//                 |> list.map(fn(item) {
//                   let assert Some(system) = item.system
//                   let assert Some(code) = item.code
//                   r4.ValuesetComposeInclude(
//                     ..r4.valueset_compose_include_new(),
//                     system: Some(system),
//                     version: item.version,
//                     concept: [r4.valueset_compose_include_concept_new(code)],
//                   )
//                 })
//               case complete, includes, valueset.compose {
//                 True, [first, ..rest], _ ->
//                   r4.Valueset(
//                     ..valueset,
//                     compose: Some(
//                       r4.valueset_compose_new(r4ct.List1(first:, rest:)),
//                     ),
//                   )
//                 True, [], _ -> panic as "ValueSet has no selectable codes"
//                 False, _, Some(_) -> valueset
//                 False, _, None ->
//                   panic as "ValueSet expansion is partial or filtered and has no compose"
//               }
//             }
//             None -> valueset
//           }
//           case valueset.url {
//             Some(url) ->
//               case dict.get(required_versions, url), valueset.version {
//                 Ok(required), Some(version) if required != version ->
//                   all_vs_or_cs
//                 Ok(_), None -> all_vs_or_cs
//                 _, _ -> {
//                   let definition =
//                     VocValueset(valueset, filepath.directory_name(path))
//                   let all_vs_or_cs = case valueset.version {
//                     Some(version) ->
//                       dict.insert(
//                         all_vs_or_cs,
//                         url <> "|" <> version,
//                         definition,
//                       )
//                     None -> all_vs_or_cs
//                   }
//                   dict.insert(all_vs_or_cs, url, definition)
//                 }
//               }
//             None -> all_vs_or_cs
//           }
//         }
//       }
//     }
//     _ -> all_vs_or_cs
//   }
// }
//
// pub fn valueset_codesystems(
//   package_dir: String,
//   all_vs_or_cs: Dict(String, VsOrCs),
// ) -> Dict(String, VsOrCs) {
//   let directories = package_directories(package_dir)
//   // Resolve unversioned systems within this ValueSet's package dependencies.
//   let scoped =
//     dict.filter(all_vs_or_cs, fn(key, definition) {
//       case definition {
//         VocCodesystem(_) -> string.contains(key, "|")
//         VocValueset(_, _) -> True
//       }
//     })
//   let scoped =
//     list.fold(directories, scoped, fn(scoped, directory) {
//       let prefix = directory <> "|"
//       dict.fold(all_vs_or_cs, scoped, fn(scoped, key, definition) {
//         case string.starts_with(key, prefix) {
//           True ->
//             dict.insert(
//               scoped,
//               string.drop_start(key, string.length(prefix)),
//               definition,
//             )
//           False -> scoped
//         }
//       })
//     })
//   let assert Ok(contents) =
//     simplifile.read(filepath.join(package_dir, "package.json"))
//   let assert Ok(fhir_versions) =
//     json.parse(contents, {
//       use versions <- decode.optional_field(
//         "fhirVersions",
//         [],
//         decode.list(decode.string),
//       )
//       decode.success(versions)
//     })
//   // Dependencies may export another release's core systems under the same URL.
//   list.fold(directories, scoped, fn(scoped, directory) {
//     let version_dir = filepath.directory_name(directory)
//     let name = filepath.base_name(filepath.directory_name(version_dir))
//     let version = filepath.base_name(version_dir)
//     case
//       list.contains(
//         ["hl7.fhir.r4.core", "hl7.fhir.r4b.core", "hl7.fhir.r5.core"],
//         name,
//       )
//       && { fhir_versions == [] || list.contains(fhir_versions, version) }
//     {
//       False -> scoped
//       True -> {
//         let prefix = directory <> "|"
//         dict.fold(all_vs_or_cs, scoped, fn(scoped, key, definition) {
//           let url = string.drop_start(key, string.length(prefix))
//           case
//             string.starts_with(key, prefix <> "http://hl7.org/fhir/")
//             && !dict.has_key(all_vs_or_cs, package_dir <> "|" <> url)
//           {
//             True -> dict.insert(scoped, url, definition)
//             False -> scoped
//           }
//         })
//       }
//     }
//   })
// }
//
// pub fn valueset_include_reference(
//   include: r4.ValuesetComposeInclude,
// ) -> String {
//   let assert Some(system) = include.system
//   case include.version {
//     Some(version) -> system <> "|" <> version
//     None -> system
//   }
// }
//
// pub fn get_codes_with_system(
//   url: String,
//   all_vs_or_cs: Dict(String, VsOrCs),
//   exclude_not_selectable: Bool,
// ) {
//   let reference = url
//   let assert [url, ..] = string.split(reference, "|")
//   case url {
//     "http://unitsofmeasure.org" -> [#(url, None)]
//     _ ->
//       case dict.get(all_vs_or_cs, reference) {
//         Error(_) -> panic as reference
//         Ok(VocValueset(vs, package_dir)) ->
//           case vs.compose {
//             None -> panic as { "ValueSet " <> reference <> " has no compose" }
//             Some(compose) ->
//               valuesetcompose_get_codes_with_system(
//                 compose,
//                 valueset_codesystems(package_dir, all_vs_or_cs),
//                 exclude_not_selectable,
//               )
//           }
//         Ok(VocCodesystem(cs)) ->
//           concepts_get_codes(cs.concept, fn(concept) {
//             let code = case
//               exclude_not_selectable
//               && list.any(concept.property, fn(property) {
//                 case property.code, property.value {
//                   "notSelectable",
//                     r4.CodesystemConceptPropertyValueBoolean(True)
//                   -> True
//                   _, _ -> False
//                 }
//               })
//             {
//               True -> None
//               False -> Some(concept.code)
//             }
//             #(code, concept.concept)
//           })
//           |> list.map(fn(code) { #(url, Some(code)) })
//       }
//   }
// }
//
// fn valuesetcompose_get_codes_with_system(
//   compose: r4.ValuesetCompose,
//   all_vs_or_cs: Dict(String, VsOrCs),
//   exclude_not_selectable: Bool,
// ) {
//   let groups =
//     [[compose.include.first, ..compose.include.rest], compose.exclude]
//     |> list.map(fn(includes) {
//       list.flat_map(includes, fn(include) {
//         valueset_include_codes(include, all_vs_or_cs, exclude_not_selectable)
//       })
//     })
//   let assert [included, excluded] = groups
//   let assert False = list.any(excluded, fn(member) { member.1 == None })
//     as "Cannot resolve ValueSet exclusion without a complete expansion"
//   let excluded_systems =
//     excluded |> list.map(fn(member) { member.0 }) |> set.from_list
//   let assert False =
//     list.any(included, fn(member) {
//       member.1 == None && set.contains(excluded_systems, member.0)
//     })
//     as "Cannot apply ValueSet exclusions to unexpanded codes"
//   let excluded = set.from_list(excluded)
//   let #(_, members) =
//     list.fold(included, #(excluded, []), fn(acc, member) {
//       let #(seen, members) = acc
//       case set.contains(seen, member) {
//         True -> acc
//         False -> #(set.insert(seen, member), [member, ..members])
//       }
//     })
//   list.reverse(members)
// }
//
// // None represents a String variant for a system we cannot enumerate.
// pub fn valueset_include_codes(
//   include: r4.ValuesetComposeInclude,
//   all_vs_or_cs: Dict(String, VsOrCs),
//   exclude_not_selectable: Bool,
// ) {
//   case include.concept, include.filter, include.system {
//     [_, ..] as concepts, _, Some(system) ->
//       list.map(concepts, fn(concept) { #(system, Some(concept.code)) })
//     [_, ..], _, None -> panic as "ValueSet include with concepts has no system"
//     [], [_, ..], Some(system) -> [#(system, None)]
//     [], [_, ..], None -> panic as "ValueSet include with filters has no system"
//     [], [], Some(system) -> {
//       let reference = valueset_include_reference(include)
//       case dict.get(all_vs_or_cs, reference) {
//         Error(_) ->
//           case include.version {
//             Some(_) -> panic as { "Could not load CodeSystem " <> reference }
//             None -> [#(system, None)]
//           }
//         Ok(_) ->
//           case
//             get_codes_with_system(
//               reference,
//               all_vs_or_cs,
//               exclude_not_selectable,
//             )
//           {
//             [] -> [#(system, None)]
//             members -> members
//           }
//       }
//     }
//     [], [], None ->
//       list.flat_map(include.value_set, fn(value_set) {
//         get_codes_with_system(value_set, all_vs_or_cs, exclude_not_selectable)
//       })
//   }
// }
//

// doesnt need to be option anymore because codesystem expansion no longer supported
// fn concepts_get_codes(
//   concepts: List(concept),
//   read: fn(concept) -> #(Option(value), List(concept)),
// ) {
//   list.flat_map(concepts, fn(concept) {
//     let #(value, children) = read(concept)
//     let codes = concepts_get_codes(children, read)
//     case value {
//       None -> codes
//       Some(value) -> [value, ..codes]
//     }
//   })
// }

fn expansion_entries(entries: List(r4.ValuesetExpansionContains)) {
  list.flat_map(entries, fn(entry) {
    [entry, ..expansion_entries(entry.contains)]
  })
}

pub fn codetovarname(c: String) {
  str_replace_many(c, [
    #(":", ""),
    #("-", ""),
    #(".", ""),
    #("_", ""),
    #("/", ""),
    #("[", ""),
    #("]", ""),
    #("!=", "Notequal"),
    #("=", "Equal"),
    #(">=", "Greaterthanoreq"),
    #(">", "Greaterthan"),
    #("<=", "Lessthanoreq"),
    #("<", "Lessthan"),
  ])
  |> string.to_utf_codepoints
  |> list.map(fn(codepoint) {
    case string.utf_codepoint_to_int(codepoint) {
      value
        if !{
          value >= 48
          && value <= 57
          || value >= 65
          && value <= 90
          || value >= 97
          && value <= 122
        }
      -> {
        let assert Ok(hex) = int.to_base_string(value, 16)
        "U" <> hex
      }
      _ -> string.from_utf_codepoints([codepoint])
    }
  })
  |> string.concat
}

pub fn gen_res_encoder(
  respascal: String,
  rescamel: String,
  reslower: String,
  fields_json_always: String,
  fields_json_options: String,
  is_domainresource: Bool,
  argument_used: Bool,
) -> String {
  let resource_type = case is_domainresource {
    True ->
      "\n  let fields = [#(\"resourceType\", json.string(\""
      <> respascal
      <> "\")), ..fields]"
    False -> ""
  }
  let argument = case argument_used {
    True -> reslower
    False -> "_" <> reslower
  }
  let template =
    "pub fn RESNAMELOWER_to_json(" <> argument <> ": RESNAMECAMEL) -> Json {
    let fields = [" <> fields_json_always <> "]" <> fields_json_options <> resource_type <> "\njson.object(fields)}
  "
  template
  |> string.replace("RESNAMELOWER", reslower)
  |> string.replace("RESNAMECAMEL", rescamel)
}

fn str_replace_many(s: String, badchars: List(#(String, String))) -> String {
  list.fold(from: s, over: badchars, with: fn(acc, bc) {
    string.replace(acc, bc.0, bc.1)
  })
}
