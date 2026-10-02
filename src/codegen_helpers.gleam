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
    fixed_code: Option(String),
    fixed_uri: Option(String),
    pattern_coding: Option(DiscriminatorCodingValue),
    pattern_codeableconcept: Option(DiscriminatorCodeableconceptValue),
    pattern_identifier: Option(DiscriminatorIdentifierValue),
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
  use fixed_code <- decode.optional_field(
    "fixedCode",
    None,
    decode.optional(decode.string),
  )
  use pattern_code <- decode.optional_field(
    "patternCode",
    None,
    decode.optional(decode.string),
  )
  let fixed_code = case fixed_code, pattern_code {
    Some(fixed), Some(pattern) if fixed != pattern ->
      panic as { "conflicting fixedCode and patternCode for " <> id }
    Some(fixed), _ -> Some(fixed)
    None, pattern -> pattern
  }
  use fixed_uri <- decode.optional_field(
    "fixedUri",
    None,
    decode.optional(decode.string),
  )
  use pattern_uri <- decode.optional_field(
    "patternUri",
    None,
    decode.optional(decode.string),
  )
  let fixed_uri = case fixed_uri, pattern_uri {
    Some(fixed), Some(pattern) if fixed != pattern ->
      panic as { "conflicting fixedUri and patternUri for " <> id }
    Some(fixed), _ -> Some(fixed)
    None, pattern -> pattern
  }
  use pattern_coding <- decode.optional_field(
    "patternCoding",
    None,
    decode.optional(discriminator_coding_value_decoder()),
  )
  use pattern_codeableconcept <- decode.optional_field(
    "patternCodeableConcept",
    None,
    decode.optional(discriminator_codeableconcept_value_decoder()),
  )
  use pattern_identifier <- decode.optional_field(
    "patternIdentifier",
    None,
    decode.optional(discriminator_identifier_value_decoder()),
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
    fixed_code:,
    fixed_uri:,
    pattern_coding:,
    pattern_codeableconcept:,
    pattern_identifier:,
  ))
}

pub type DiscriminatorCodingValue {
  DiscriminatorCodingValue(
    system: Option(String),
    code: Option(String),
    display: Option(String),
  )
}

fn discriminator_coding_value_decoder() {
  use system <- decode.optional_field(
    "system",
    None,
    decode.optional(decode.string),
  )
  use code <- decode.optional_field(
    "code",
    None,
    decode.optional(decode.string),
  )
  use display <- decode.optional_field(
    "display",
    None,
    decode.optional(decode.string),
  )
  decode.success(DiscriminatorCodingValue(system:, code:, display:))
}

pub type DiscriminatorCodeableconceptValue {
  DiscriminatorCodeableconceptValue(coding: List(DiscriminatorCodingValue))
}

fn discriminator_codeableconcept_value_decoder() {
  use coding <- decode.optional_field(
    "coding",
    [],
    decode.list(discriminator_coding_value_decoder()),
  )
  decode.success(DiscriminatorCodeableconceptValue(coding:))
}

pub type DiscriminatorIdentifierValue {
  DiscriminatorIdentifierValue(system: Option(String), value: Option(String))
}

fn discriminator_identifier_value_decoder() {
  use system <- decode.optional_field(
    "system",
    None,
    decode.optional(decode.string),
  )
  use value <- decode.optional_field(
    "value",
    None,
    decode.optional(decode.string),
  )
  decode.success(DiscriminatorIdentifierValue(system:, value:))
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

pub fn new_fn_arg_and_field(
  field_name: String,
  field_type: String,
  min: Int,
  max: String,
  is_primitive: Bool,
) -> #(String, String) {
  case min, max {
    0, "*" -> #("", field_name <> ": [],")
    1, "*" ->
      case is_primitive {
        True -> #("", field_name <> ": [],")
        False -> #(
          field_name <> " " <> field_name <> ": List1(" <> field_type <> "),",
          field_name <> ":,",
        )
      }
    2, "*" -> #(
      field_name <> " " <> field_name <> ": List2(" <> field_type <> "),",
      field_name <> ":,",
    )
    3, "*" -> #(
      field_name <> " " <> field_name <> ": List3(" <> field_type <> "),",
      field_name <> ":,",
    )
    0, "1" -> #(
      "",
      field_name
        <> ": "
        <> case is_primitive {
        True -> "Primitive(id: None, ext: [], value: None)"
        False -> "None"
      }
        <> ",",
    )
    0, _ -> #("", field_name <> ": [],")
    1, _ ->
      case is_primitive {
        True -> #(
          "",
          field_name <> ": Primitive(id: None, ext: [], value: None),",
        )
        False -> #(
          field_name <> " " <> field_name <> ": " <> field_type <> ",",
          field_name <> ":,",
        )
      }
    _, _ -> panic as "cardinality panic 2"
  }
}

pub fn escape_field_name(name: String) -> String {
  case name {
    "type" -> "type_"
    "use" -> "use_"
    "case" -> "case_"
    "const" -> "const_"
    "import" -> "import_"
    "test" -> "test_"
    "assert" -> "assert_"
    _ -> name
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
        Some(Binding(strength: "required", value_set: Some(value_set))) -> {
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
        Some(Binding(strength: "required", value_set: None)) ->
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
    None | Some(Binding(strength: "required", value_set: None)) -> #(
      prefix <> normal_type,
      required_value_sets_acc,
    )
    Some(Binding(strength: "required", value_set: Some(value_set))) -> {
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
  VocValueset(v: r4.Valueset)
  VocCodesystem(c: r4.Codesystem)
}

pub fn valueset_can_generate_system(
  vs_url: String,
  all_vs_or_cs: Dict(String, VsOrCs),
) -> Bool {
  case dict.get(all_vs_or_cs, vs_url) {
    Ok(VocValueset(r4.Valueset(compose: Some(compose), ..))) ->
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
    Ok(VocValueset(r4.Valueset(compose: Some(compose), ..))) ->
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
        VocValueset(r4.Valueset(compose: None, ..)) -> []
        VocValueset(r4.Valueset(compose: Some(compose), ..)) ->
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
                  Some(url) -> dict.insert(acc, url, VocCodesystem(codesystem))
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
                _, _ -> dict.insert(all_vs_or_cs, url, VocValueset(valueset))
              }
            None -> all_vs_or_cs
          }
        }
      }
    }
    _ -> all_vs_or_cs
  }
}

pub fn get_codes_with_system(
  url: String,
  all_vs_or_cs: Dict(String, VsOrCs),
  exclude_not_selectable: Bool,
) {
  let assert [url, ..] = string.split(url, "|")
  case url {
    "http://unitsofmeasure.org" -> []
    _ ->
      case dict.get(all_vs_or_cs, url) {
        Error(_) -> panic as url
        Ok(VocValueset(vs)) ->
          case vs.compose {
            None -> []
            Some(compose) ->
              valuesetcompose_get_codes_with_system(
                compose,
                all_vs_or_cs,
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
        [], Some(system) ->
          get_codes_with_system(system, all_vs_or_cs, exclude_not_selectable)
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
  fields_list: String,
  fields_json_always: String,
  fields_json_options: String,
  is_domainresource: Bool,
) -> String {
  let resource_type = case is_domainresource {
    True ->
      "\n  let fields = [#(\"resourceType\", json.string(\""
      <> respascal
      <> "\")), ..fields]"
    False -> ""
  }
  let template =
    "pub fn RESNAMELOWER_to_json(RESNAMELOWER: RESNAMECAMEL) -> Json {
    let RESNAMECAMEL(" <> fields_list <> ") = RESNAMELOWER
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
