import codegen_constraint
import fhir/r4_gen/complex_types as r4ct
import fhir/r4_gen/resources as r4
import filepath
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
      field_name <> ": Primitive(id: None, ext: [], value: None),",
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
          case
            string.contains(url, "v3-Confidentiality")
            || string.contains(url, "mimetypes")
            || string.contains(url, "currencies")
            || string.contains(url, "all-languages")
            || string.contains(url, "ucum-units")
            || string.contains(url, "color-codes")
          {
            True -> #("String", required_value_sets_acc)
            False -> #(
              "valuesets." <> concept_name_from_url(url),
              insert_valueset(
                required_value_sets_acc,
                url,
                ValuesetCodeOnlyDontNeedSystem,
              ),
            )
          }
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
          <> bound_type
          <> "(valuesets."
          <> concept_name_from_url(url)
          <> ")",
        insert_valueset(
          required_value_sets_acc,
          url,
          ValuesetBoundCodingOrCcNeedsSystem,
        ),
      )
    }
    Some(_) -> #(prefix <> normal_type, required_value_sets_acc)
  }
}

pub type ValuesetItem {
  ValuesetBoundCodingOrCcNeedsSystem
  ValuesetCodeOnlyDontNeedSystem
}

fn insert_valueset(
  valuesets: Dict(String, ValuesetItem),
  url: String,
  item: ValuesetItem,
) -> Dict(String, ValuesetItem) {
  case dict.get(valuesets, url), item {
    Ok(ValuesetBoundCodingOrCcNeedsSystem), _ -> valuesets
    _, ValuesetBoundCodingOrCcNeedsSystem ->
      dict.insert(valuesets, url, ValuesetBoundCodingOrCcNeedsSystem)
    _, ValuesetCodeOnlyDontNeedSystem ->
      dict.insert(valuesets, url, ValuesetCodeOnlyDontNeedSystem)
  }
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
  urlname
  |> string.replace(" ", "")
  |> codetovarname
  |> string.capitalise
}

pub type VsOrCs {
  VocValueset(v: r4.Valueset, package_dir: String)
  VocCodesystem(c: r4.Codesystem)
}

pub fn valueset_can_generate_system(
  vs_url: String,
  all_vs_or_cs: Dict(String, VsOrCs),
) -> Bool {
  case dict.get(all_vs_or_cs, vs_url) {
    Ok(VocValueset(r4.Valueset(compose: Some(compose), ..), _)) ->
      [compose.include.first, ..compose.include.rest]
      |> list.all(fn(include) {
        case include.system, include.value_set {
          Some(_), _ -> True
          None, [] -> False
          None, value_sets ->
            list.all(value_sets, fn(value_set) {
              valueset_can_generate_system(value_set, all_vs_or_cs)
            })
        }
      })
    _ -> False
  }
}

pub fn valueset_can_generate_discriminator(
  vs_url: String,
  all_vs_or_cs: Dict(String, VsOrCs),
) -> Bool {
  case dict.get(all_vs_or_cs, vs_url) {
    Ok(VocValueset(r4.Valueset(compose: Some(compose), ..), _)) ->
      compose.exclude == []
      && [compose.include.first, ..compose.include.rest]
      |> list.all(fn(include) {
        case
          include.concept,
          include.filter,
          include.system,
          include.value_set
        {
          [_, ..], [], Some(_), [] -> True
          [], [], Some(_), [] -> True
          [], [], None, [_, ..] as value_sets ->
            list.all(value_sets, fn(value_set) {
              valueset_can_generate_discriminator(value_set, all_vs_or_cs)
            })
          _, _, _, _ -> False
        }
      })
    _ -> False
  }
}

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

pub fn load_valuesets(
  package_dir: String,
  required_value_sets: Set(String),
) -> Dict(String, VsOrCs) {
  let required_value_set_files =
    required_value_sets
    |> set.map(value_set_filename)
  let required_versions =
    required_value_sets
    |> set.fold(dict.new(), insert_required_valueset_version)

  let num_vs_files = required_value_set_files |> set.size |> int.to_string
  io.println("loading " <> num_vs_files <> " valueset json files")

  let package_directories = package_directories(package_dir)
  let all_vs_or_cs =
    package_directories
    |> list.fold(dict.new(), fn(all_vs_or_cs, directory) {
      io.println("loading valuesets from " <> directory)
      load_valuesets_from_directory(
        directory,
        all_vs_or_cs,
        required_value_set_files,
        required_versions,
      )
    })
  load_imported_valuesets(
    package_directories,
    all_vs_or_cs,
    required_value_set_files,
    required_versions,
  )
}

fn insert_required_valueset_version(
  versions: Dict(String, String),
  reference: String,
) -> Dict(String, String) {
  case string.split(reference, "|") {
    [url, version] ->
      case dict.get(versions, url) {
        Ok(previous) if previous != version ->
          panic as {
            "conflicting required ValueSet versions for "
            <> url
            <> ": "
            <> previous
            <> " and "
            <> version
          }
        _ -> dict.insert(versions, url, version)
      }
    _ -> versions
  }
}

fn load_imported_valuesets(
  package_directories: List(String),
  all_vs_or_cs: Dict(String, VsOrCs),
  loaded_value_set_files: Set(String),
  required_versions: Dict(String, String),
) -> Dict(String, VsOrCs) {
  let imported_value_sets =
    all_vs_or_cs
    |> dict.to_list
    |> list.flat_map(fn(entry) {
      case entry.1 {
        VocCodesystem(_) -> []
        VocValueset(r4.Valueset(compose: None, ..), _) -> []
        VocValueset(r4.Valueset(compose: Some(compose), ..), _) ->
          list.append(
            [compose.include.first, ..compose.include.rest],
            compose.exclude,
          )
          |> list.flat_map(fn(include) { include.value_set })
      }
    })
    |> set.from_list
  let required_versions =
    imported_value_sets
    |> set.fold(required_versions, insert_required_valueset_version)
  let imported_value_set_files =
    imported_value_sets
    |> set.map(value_set_filename)
    |> set.difference(loaded_value_set_files)

  case set.is_empty(imported_value_set_files) {
    True -> all_vs_or_cs
    False -> {
      let all_vs_or_cs =
        package_directories
        |> list.fold(all_vs_or_cs, fn(all_vs_or_cs, package_dir) {
          imported_value_set_files
          |> set.fold(all_vs_or_cs, fn(all_vs_or_cs, filename) {
            load_valueset_file(
              filepath.join(package_dir, filename),
              all_vs_or_cs,
              required_versions,
            )
          })
        })
      load_imported_valuesets(
        package_directories,
        all_vs_or_cs,
        set.union(loaded_value_set_files, imported_value_set_files),
        required_versions,
      )
    }
  }
}

fn value_set_filename(url: String) -> String {
  let assert [url, ..] = string.split(url, "|")
  let assert Ok(name) = url |> string.split("/") |> list.last
  "ValueSet-" <> name <> ".json"
}

fn load_valuesets_from_directory(
  package_dir: String,
  all_vs_or_cs: Dict(String, VsOrCs),
  required_value_set_files: Set(String),
  required_versions: Dict(String, String),
) {
  let assert Ok(files) = simplifile.read_directory(package_dir)
  list.fold(from: all_vs_or_cs, over: files, with: fn(acc, filename) {
    let path = filepath.join(package_dir, filename)
    case
      string.starts_with(filename, "ValueSet-")
      && set.contains(required_value_set_files, filename)
    {
      True -> load_valueset_file(path, acc, required_versions)
      False ->
        case string.starts_with(filename, "CodeSystem-") {
          True -> {
            let assert Ok(contents) = simplifile.read(path)
            //TODO CodeSystem-v2-0229.json has _valueString primitive extension without valueString which our ct.Extension rejects
            case json.parse(contents, r4.codesystem_decoder()) {
              Ok(codesystem) ->
                case codesystem.url {
                  Some(url) -> {
                    let definition = VocCodesystem(codesystem)
                    let acc = case codesystem.version {
                      Some(version) ->
                        dict.insert(acc, url <> "|" <> version, definition)
                      None -> acc
                    }
                    acc
                    |> dict.insert(url, definition)
                    |> dict.insert(package_dir <> "|" <> url, definition)
                  }
                  None -> acc
                }
              Error(_) -> acc
            }
          }
          False -> acc
        }
    }
  })
}

fn load_valueset_file(
  path: String,
  all_vs_or_cs: Dict(String, VsOrCs),
  required_versions: Dict(String, String),
) {
  case simplifile.is_file(path) {
    Ok(True) -> {
      let assert Ok(contents) = simplifile.read(path)
      case json.parse(contents, r4.valueset_decoder()) {
        Error(_) -> all_vs_or_cs
        Ok(valueset) -> {
          let valueset = case valueset.compose, valueset.expansion {
            None, Some(expansion) -> {
              let includes =
                list.map(expansion.contains, fn(item) {
                  let assert Some(system) = item.system
                  let assert Some(code) = item.code
                  r4.ValuesetComposeInclude(
                    ..r4.valueset_compose_include_new(),
                    system: Some(system),
                    concept: [r4.valueset_compose_include_concept_new(code)],
                  )
                })
              let assert [first, ..rest] = includes
              r4.Valueset(
                ..valueset,
                compose: Some(
                  r4.valueset_compose_new(r4ct.List1(first:, rest:)),
                ),
              )
            }
            _, _ -> valueset
          }
          case valueset.url {
            Some(url) ->
              case dict.get(required_versions, url), valueset.version {
                Ok(required), Some(version) if required != version ->
                  all_vs_or_cs
                Ok(_), None -> all_vs_or_cs
                _, _ -> {
                  let definition =
                    VocValueset(valueset, filepath.directory_name(path))
                  let all_vs_or_cs = case valueset.version {
                    Some(version) ->
                      dict.insert(
                        all_vs_or_cs,
                        url <> "|" <> version,
                        definition,
                      )
                    None -> all_vs_or_cs
                  }
                  dict.insert(all_vs_or_cs, url, definition)
                }
              }
            None -> all_vs_or_cs
          }
        }
      }
    }
    _ -> all_vs_or_cs
  }
}

pub fn valueset_codesystems(
  package_dir: String,
  all_vs_or_cs: Dict(String, VsOrCs),
) -> Dict(String, VsOrCs) {
  let directories = package_directories(package_dir)
  // Resolve unversioned systems within this ValueSet's package dependencies.
  let scoped =
    dict.filter(all_vs_or_cs, fn(key, definition) {
      case definition {
        VocCodesystem(_) -> string.contains(key, "|")
        VocValueset(_, _) -> True
      }
    })
  let scoped =
    list.fold(directories, scoped, fn(scoped, directory) {
      let prefix = directory <> "|"
      dict.fold(all_vs_or_cs, scoped, fn(scoped, key, definition) {
        case string.starts_with(key, prefix) {
          True ->
            dict.insert(
              scoped,
              string.drop_start(key, string.length(prefix)),
              definition,
            )
          False -> scoped
        }
      })
    })
  let assert Ok(contents) =
    simplifile.read(filepath.join(package_dir, "package.json"))
  let assert Ok(fhir_versions) =
    json.parse(contents, {
      use versions <- decode.optional_field(
        "fhirVersions",
        [],
        decode.list(decode.string),
      )
      decode.success(versions)
    })
  // Dependencies may export another release's core systems under the same URL.
  list.fold(directories, scoped, fn(scoped, directory) {
    let version_dir = filepath.directory_name(directory)
    let name = filepath.base_name(filepath.directory_name(version_dir))
    let version = filepath.base_name(version_dir)
    case
      list.contains(
        ["hl7.fhir.r4.core", "hl7.fhir.r4b.core", "hl7.fhir.r5.core"],
        name,
      )
      && { fhir_versions == [] || list.contains(fhir_versions, version) }
    {
      False -> scoped
      True -> {
        let prefix = directory <> "|"
        dict.fold(all_vs_or_cs, scoped, fn(scoped, key, definition) {
          let url = string.drop_start(key, string.length(prefix))
          case
            string.starts_with(key, prefix <> "http://hl7.org/fhir/")
            && !dict.has_key(all_vs_or_cs, package_dir <> "|" <> url)
          {
            True -> dict.insert(scoped, url, definition)
            False -> scoped
          }
        })
      }
    }
  })
}

pub fn valueset_include_reference(
  include: r4.ValuesetComposeInclude,
) -> String {
  let assert Some(system) = include.system
  case include.version {
    Some(version) -> system <> "|" <> version
    None -> system
  }
}

pub fn get_codes_with_system(
  url: String,
  all_vs_or_cs: Dict(String, VsOrCs),
  exclude_not_selectable: Bool,
) {
  let reference = url
  let assert [url, ..] = string.split(reference, "|")
  case url {
    "http://unitsofmeasure.org" -> []
    _ ->
      case dict.get(all_vs_or_cs, reference) {
        Error(_) -> panic as reference
        Ok(VocValueset(vs, package_dir)) ->
          case vs.compose {
            None -> []
            Some(compose) ->
              valuesetcompose_get_codes_with_system(
                compose,
                valueset_codesystems(package_dir, all_vs_or_cs),
                exclude_not_selectable,
              )
          }
        Ok(VocCodesystem(cs)) ->
          codesystemconcepts_get_codes(cs.concept, exclude_not_selectable)
          |> list.map(fn(code) { #(url, code) })
      }
  }
}

fn valuesetcompose_get_codes_with_system(
  compose: r4.ValuesetCompose,
  all_vs_or_cs: Dict(String, VsOrCs),
  exclude_not_selectable: Bool,
) {
  list.fold(
    [compose.include.first, ..compose.include.rest],
    [],
    fn(members, include) {
      let members =
        include.value_set
        |> list.fold(members, fn(members, value_set) {
          list.append(
            get_codes_with_system(
              value_set,
              all_vs_or_cs,
              exclude_not_selectable,
            ),
            members,
          )
        })
      case include.concept, include.system {
        [_, ..] as concepts, Some(system) ->
          concepts
          |> list.map(fn(concept) { #(system, concept.code) })
          |> list.append(members)
        [_, ..], None -> panic as "ValueSet include with concepts has no system"
        [], Some(_) ->
          get_codes_with_system(
            valueset_include_reference(include),
            all_vs_or_cs,
            exclude_not_selectable,
          )
          |> list.append(members)
        [], None -> members
      }
    },
  )
}

fn codesystemconcepts_get_codes(
  codesystem_concepts: List(r4.CodesystemConcept),
  exclude_not_selectable: Bool,
) {
  list.fold(from: [], over: codesystem_concepts, with: fn(acc, csc) {
    let codes =
      codesystemconcepts_get_codes(csc.concept, exclude_not_selectable)
    let codes = case
      exclude_not_selectable
      && list.any(csc.property, fn(property) {
        case property.code, property.value {
          "notSelectable", r4.CodesystemConceptPropertyValueBoolean(True) ->
            True
          _, _ -> False
        }
      })
    {
      True -> codes
      False -> [csc.code, ..codes]
    }
    acc |> list.append(codes)
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
      value if value > 127 -> {
        let assert Ok(hex) = int.to_base_string(value, 16)
        "U" <> hex
      }
      _ -> string.from_utf_codepoints([codepoint])
    }
  })
  |> string.concat
}

pub fn gen_choicetype_suffixes(
  match_var: String,
  types: List(Type),
  field_name_new: String,
) -> String {
  case types {
    [_, _, ..] ->
      string.concat([
        " <> case ",
        match_var,
        " {",
        list.fold(from: "", over: types, with: fn(suffixes_acc, ct) {
          let assert [first_letter, ..rest] = ct.code |> string.to_graphemes
          let capital_ct =
            string.concat([string.uppercase(first_letter), ..rest])
          suffixes_acc
          <> field_name_new
          <> string.capitalise(ct.code)
          <> "(_) -> \""
          <> capital_ct
          <> "\"\n"
        }),
        "}",
      ])
    _ -> ""
  }
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
