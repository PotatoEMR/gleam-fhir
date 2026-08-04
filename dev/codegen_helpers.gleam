import gleam/dynamic/decode
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/set.{type Set}
import gleam/string

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
  decode.success(Snapshot(element:))
}

pub type Element {
  Element(
    id: String,
    path: String,
    base: ElementBase,
    slice_name: Option(String),
    slicing: Option(Slicing),
    min: Int,
    max: String,
    type_: List(Type),
    binding: Option(Binding),
    content_reference: Option(String),
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
  decode.success(Element(
    id:,
    path:,
    base:,
    slice_name:,
    slicing:,
    min:,
    max:,
    type_:,
    binding:,
    content_reference:,
  ))
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
  Binding(strength: String, value_set: Option(String))
}

pub fn binding_decoder() -> decode.Decoder(Binding) {
  use strength <- decode.field("strength", decode.string)
  use value_set <- decode.optional_field(
    "valueSet",
    None,
    decode.optional(decode.string),
  )
  decode.success(Binding(strength:, value_set:))
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
  |> string.split("_")
  |> list.map(fn(s) { string.capitalise(s) })
  |> string.concat
}

pub fn cardinality(fieldtype: String, fieldmin: Int, fieldmax: String) {
  case fieldmin, fieldmax {
    0, "*" -> "List(" <> fieldtype <> ")"
    1, "*" -> "List1(" <> fieldtype <> ")"
    2, "*" -> "List2(" <> fieldtype <> ")"
    3, "*" -> "List3(" <> fieldtype <> ")"
    0, "1" -> "Option(" <> fieldtype <> ")"
    1, "1" -> fieldtype
    // TODO ListMaxN
    0, _n -> "List(" <> fieldtype <> ")"
    _, _ -> panic as "cardinality panic, if you have n..* with n > 3 idk"
  }
}

// replace capital HelloThere with lowercase hello_there
// but if the previous character was a capital it will not add an underscore
pub fn to_snake_case(input: String) -> String {
  input
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
  required_value_sets_acc: Set(String),
) -> #(String, Set(String)) {
  case fhir_type {
    "code" -> {
      let s = allparts |> string.concat()
      case s {
        "somehow this is used in [x] for any type (int, bool, code, etc) and ofc that code has no defined binding" -> #(
          "String",
          required_value_sets_acc,
        )
        //not a code idk should we even generate this?
        _ -> {
          case elt.binding {
            Some(x) ->
              case x.strength {
                "required" -> {
                  case x.value_set {
                    Some(vs) -> {
                      let assert [url, ..] = string.split(vs, "|")
                        as "split vs version"
                      //get rid of |version in http://some.valueset|4.0.1
                      case
                        string.contains(url, "v3-Confidentiality")
                        || string.contains(url, "mimetypes")
                        || string.contains(url, "currencies")
                        || string.contains(url, "all-languages")
                        || string.contains(url, "ucum-units")
                        || string.contains(url, "color-codes")
                      {
                        True -> #("String", required_value_sets_acc)
                        //idk whats going on here, probably i dont understand valueset composition
                        False -> #(
                          "valuesets." <> concept_name_from_url(url),
                          required_value_sets_acc |> set.insert(url),
                        )
                      }
                    }
                    _ -> panic as "huh idk 2"
                  }
                }
                _ -> #("String", required_value_sets_acc)
                //mostly just elt.languages doesnt have "required" code binding
              }
            None -> #("String", required_value_sets_acc)
            //these codes dont have required binding?
          }
        }
      }
    }
    // keeping track of required valueset codes
    // but if type is not a code, couldnt possibly be required code
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
  |> string.replace("-", "")
  |> string.replace("_", "")
  |> string.replace(".", "")
  |> string.capitalise
}
