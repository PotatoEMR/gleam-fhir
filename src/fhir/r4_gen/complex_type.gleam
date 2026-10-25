////[https://hl7.org/fhir/r4](https://hl7.org/fhir/r4) complex types

import fhir/r4_gen/primitive_type.{
  type Date, type DateTime, type Instant, type Time,
} as pt
import fhir/r4_gen/valueset
import gleam/dynamic/decode.{type Decoder}
import gleam/int
import gleam/json.{type Json}
import gleam/list
import gleam/option.{type Option, None, Some}

/// 1..*
pub type List1(a) {
  List1(first: a, rest: List(a))
}

pub type BoundCoding(required_binding) {
  BoundCoding(
    id: Option(String),
    extension: List(Extension),
    code: required_binding,
    version: Option(String),
    display: Option(String),
    user_selected: Option(Bool),
  )
}

pub fn bound_coding_new(
  code: required_binding,
) -> BoundCoding(required_binding) {
  BoundCoding(
    user_selected: None,
    display: None,
    code:,
    version: None,
    extension: [],
    id: None,
  )
}

pub fn bound_coding_parse_coding(
  coding: Coding,
  binding_parse_code_and_system: fn(String, String) ->
    Result(required_binding, Nil),
) -> Result(BoundCoding(required_binding), Nil) {
  case coding.code, coding.system {
    Some(code), Some(system) ->
      case binding_parse_code_and_system(code, system) {
        Error(Nil) -> Error(Nil)
        Ok(code) ->
          Ok(BoundCoding(
            id: coding.id,
            extension: coding.extension,
            code:,
            version: coding.version,
            display: coding.display,
            user_selected: coding.user_selected,
          ))
      }
    _, _ -> Error(Nil)
  }
}

pub fn bound_coding_to_json(
  coding: BoundCoding(required_binding),
  get_code: fn(required_binding) -> String,
  get_system: fn(required_binding) -> String,
) -> Json {
  let fields = [
    #("code", json.string(get_code(coding.code))),
    #("system", json.string(get_system(coding.code))),
  ]
  let fields = case coding.user_selected {
    Some(v) -> [#("userSelected", json.bool(v)), ..fields]
    None -> fields
  }
  let fields = case coding.display {
    Some(v) -> [#("display", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case coding.version {
    Some(v) -> [#("version", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case coding.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(coding.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case coding.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn bound_coding_decoder(
  binding_parse_code_and_system: fn(String, String) ->
    Result(required_binding, Nil),
  failure_placeholder: required_binding,
) -> Decoder(BoundCoding(required_binding)) {
  use <- decode.recursive
  use code <- decode.field("code", decode.string)
  use system <- decode.field("system", decode.string)
  case binding_parse_code_and_system(code, system) {
    Error(_) ->
      decode.failure(
        bound_coding_new(failure_placeholder),
        "need code + system from required ValueSet",
      )
    Ok(binding) -> {
      use user_selected <- decode.optional_field(
        "userSelected",
        None,
        decode.optional(decode.bool),
      )
      use display <- decode.optional_field(
        "display",
        None,
        decode.optional(decode.string),
      )
      use version <- decode.optional_field(
        "version",
        None,
        decode.optional(decode.string),
      )
      use extension <- decode.optional_field(
        "extension",
        [],
        decode.list(extension_decoder()),
      )
      use id <- decode.optional_field(
        "id",
        None,
        decode.optional(decode.string),
      )
      decode.success(BoundCoding(
        user_selected:,
        display:,
        code: binding,
        version:,
        extension:,
        id:,
      ))
    }
  }
}

pub type BoundCodeableconcept(required_binding) {
  BoundCodeableconcept(
    id: Option(String),
    extension: List(Extension),
    required: BoundCoding(required_binding),
    more: List(Coding),
    text: Option(String),
  )
}

pub fn bound_codeableconcept_new(
  code: required_binding,
) -> BoundCodeableconcept(required_binding) {
  let required = bound_coding_new(code)
  BoundCodeableconcept(text: None, required:, more: [], extension: [], id: None)
}

pub fn bound_codeableconcept_parse_codeableconcept(
  concept: Codeableconcept,
  binding_parse_code_and_system: fn(String, String) ->
    Result(required_binding, Nil),
) -> Result(BoundCodeableconcept(required_binding), Nil) {
  case find_valueset_coding(concept.coding, binding_parse_code_and_system) {
    Error(Nil) -> Error(Nil)
    Ok(#(required, more)) ->
      Ok(BoundCodeableconcept(
        id: concept.id,
        extension: concept.extension,
        required:,
        more:,
        text: concept.text,
      ))
  }
}

pub fn bound_codeableconcept_to_json(
  codeableconcept: BoundCodeableconcept(required_binding),
  get_code: fn(required_binding) -> String,
  get_system: fn(required_binding) -> String,
) -> Json {
  let required_coding =
    bound_coding_to_json(codeableconcept.required, get_code, get_system)
  let other_codings = list.map(codeableconcept.more, coding_to_json)
  let all_codings = json.preprocessed_array([required_coding, ..other_codings])
  let fields = [#("coding", all_codings)]
  let fields = case codeableconcept.text {
    Some(v) -> [#("text", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case codeableconcept.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(codeableconcept.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case codeableconcept.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn bound_codeableconcept_decoder(
  binding_parse_code_and_system: fn(String, String) ->
    Result(required_binding, Nil),
  failure_placeholder: required_binding,
) -> Decoder(BoundCodeableconcept(required_binding)) {
  use <- decode.recursive
  use coding <- decode.optional_field(
    "coding",
    [],
    decode.list(coding_decoder()),
  )
  let valueset_coding =
    find_valueset_coding(coding, binding_parse_code_and_system)
  case valueset_coding {
    Error(_) ->
      decode.failure(
        bound_codeableconcept_new(failure_placeholder),
        "need a coding with code + system from required ValueSet",
      )
    Ok(#(required, more)) -> {
      use text <- decode.optional_field(
        "text",
        None,
        decode.optional(decode.string),
      )
      use extension <- decode.optional_field(
        "extension",
        [],
        decode.list(extension_decoder()),
      )
      use id <- decode.optional_field(
        "id",
        None,
        decode.optional(decode.string),
      )
      decode.success(BoundCodeableconcept(
        text:,
        required:,
        more:,
        extension:,
        id:,
      ))
    }
  }
}

fn find_valueset_coding(
  items: List(Coding),
  binding_parse_code_and_system: fn(String, String) ->
    Result(required_binding, Nil),
) -> Result(#(BoundCoding(required_binding), List(Coding)), Nil) {
  let is_bound_valueset = fn(coding: Coding) {
    bound_coding_parse_coding(coding, binding_parse_code_and_system)
  }
  find_element_and_rest_result(in: items, one_that: is_bound_valueset)
}

fn find_element_and_rest_result(
  in items: List(a),
  one_that is_desired: fn(a) -> Result(b, Nil),
) -> Result(#(b, List(a)), Nil) {
  find_element_and_rest_result_loop(
    in: items,
    one_that: is_desired,
    already: [],
  )
}

fn find_element_and_rest_result_loop(
  in items: List(a),
  one_that is_desired: fn(a) -> Result(b, Nil),
  already past_list: List(a),
) -> Result(#(b, List(a)), Nil) {
  case items {
    [] -> Error(Nil)
    [first, ..rest] ->
      case is_desired(first) {
        Ok(found_element) -> {
          let more = past_list |> list.reverse |> list.append(rest)
          Ok(#(found_element, more))
        }
        Error(_) -> {
          let others = [first, ..past_list]
          find_element_and_rest_result_loop(
            in: rest,
            one_that: is_desired,
            already: others,
          )
        }
      }
  }
}

pub type BoundQuantity(required_binding) {
  BoundQuantity(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(valueset.QuantityComparator),
    unit: Option(String),
    code: Option(required_binding),
  )
}

pub fn bound_quantity_new() -> BoundQuantity(required_binding) {
  BoundQuantity(
    code: None,
    unit: None,
    comparator: None,
    value: None,
    extension: [],
    id: None,
  )
}

pub fn bound_quantity_parse_quantity(
  quantity: Quantity,
  binding_parse_code_and_system: fn(String, String) ->
    Result(required_binding, Nil),
) -> Result(BoundQuantity(required_binding), Nil) {
  case quantity.code, quantity.system {
    None, None ->
      Ok(BoundQuantity(
        id: quantity.id,
        extension: quantity.extension,
        value: quantity.value,
        comparator: quantity.comparator,
        unit: quantity.unit,
        code: None,
      ))
    Some(code), Some(system) ->
      case binding_parse_code_and_system(code, system) {
        Ok(code) ->
          Ok(BoundQuantity(
            id: quantity.id,
            extension: quantity.extension,
            value: quantity.value,
            comparator: quantity.comparator,
            unit: quantity.unit,
            code: Some(code),
          ))
        Error(_) -> Error(Nil)
      }
    _, _ -> Error(Nil)
  }
}

pub fn bound_quantity_to_json(
  quantity: BoundQuantity(required_binding),
  get_code: fn(required_binding) -> String,
  get_system: fn(required_binding) -> String,
) -> Json {
  let fields = case quantity.code {
    Some(bound_code) -> [
      #("code", json.string(get_code(bound_code))),
      #("system", json.string(get_system(bound_code))),
    ]
    None -> []
  }
  let fields = case quantity.unit {
    Some(v) -> [#("unit", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case quantity.comparator {
    Some(v) -> [
      #("comparator", valueset.quantity_comparator_to_json(v)),
      ..fields
    ]
    None -> fields
  }
  let fields = case quantity.value {
    Some(v) -> [#("value", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case quantity.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(quantity.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case quantity.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn bound_quantity_decoder(
  binding_parse_code_and_system: fn(String, String) ->
    Result(required_binding, Nil),
) -> Decoder(BoundQuantity(required_binding)) {
  use <- decode.recursive
  use code <- decode.optional_field(
    "code",
    None,
    decode.optional(decode.string),
  )
  use system <- decode.optional_field(
    "system",
    None,
    decode.optional(decode.string),
  )
  case code, system {
    None, None -> bound_quantity_decode_rest(None)
    Some(code), Some(system) ->
      case binding_parse_code_and_system(code, system) {
        Error(_) ->
          decode.failure(
            bound_quantity_new(),
            "need code + system from required ValueSet",
          )
        Ok(binding) -> bound_quantity_decode_rest(Some(binding))
      }
    _, _ ->
      decode.failure(
        bound_quantity_new(),
        "need code + system from required ValueSet",
      )
  }
}

fn bound_quantity_decode_rest(
  with_binding: Option(required_binding),
) -> Decoder(BoundQuantity(required_binding)) {
  use unit <- decode.optional_field(
    "unit",
    None,
    decode.optional(decode.string),
  )
  use comparator <- decode.optional_field(
    "comparator",
    None,
    decode.optional(valueset.quantity_comparator_decoder()),
  )
  use value <- decode.optional_field(
    "value",
    None,
    decode.optional(decode_number()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(BoundQuantity(
    code: with_binding,
    unit:,
    comparator:,
    value:,
    extension:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4/StructureDefinition/Address#resource](http://hl7.org/fhir/r4/StructureDefinition/Address#resource)
pub type Address {
  Address(
    id: Option(String),
    extension: List(Extension),
    use_: Option(valueset.AddressUse),
    type_: Option(valueset.AddressType),
    text: Option(String),
    line: List(String),
    city: Option(String),
    district: Option(String),
    state: Option(String),
    postal_code: Option(String),
    country: Option(String),
    period: Option(Period),
  )
}

pub fn address_new() -> Address {
  Address(
    period: None,
    country: None,
    postal_code: None,
    state: None,
    district: None,
    city: None,
    line: [],
    text: None,
    type_: None,
    use_: None,
    extension: [],
    id: None,
  )
}

pub fn address_to_json(address: Address) -> Json {
  let fields = []
  let fields = case address.period {
    Some(v) -> [#("period", period_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case address.country {
    Some(v) -> [#("country", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case address.postal_code {
    Some(v) -> [#("postalCode", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case address.state {
    Some(v) -> [#("state", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case address.district {
    Some(v) -> [#("district", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case address.city {
    Some(v) -> [#("city", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case address.line {
    [] -> fields
    _ -> [#("line", json.array(address.line, json.string)), ..fields]
  }
  let fields = case address.text {
    Some(v) -> [#("text", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case address.type_ {
    Some(v) -> [#("type", valueset.address_type_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case address.use_ {
    Some(v) -> [#("use", valueset.address_use_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case address.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(address.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case address.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn address_decoder() -> Decoder(Address) {
  use <- decode.recursive
  use period <- decode.optional_field(
    "period",
    None,
    decode.optional(period_decoder()),
  )
  use country <- decode.optional_field(
    "country",
    None,
    decode.optional(decode.string),
  )
  use postal_code <- decode.optional_field(
    "postalCode",
    None,
    decode.optional(decode.string),
  )
  use state <- decode.optional_field(
    "state",
    None,
    decode.optional(decode.string),
  )
  use district <- decode.optional_field(
    "district",
    None,
    decode.optional(decode.string),
  )
  use city <- decode.optional_field(
    "city",
    None,
    decode.optional(decode.string),
  )
  use line <- decode.optional_field("line", [], decode.list(decode.string))
  use text <- decode.optional_field(
    "text",
    None,
    decode.optional(decode.string),
  )
  use type_ <- decode.optional_field(
    "type",
    None,
    decode.optional(valueset.address_type_decoder()),
  )
  use use_ <- decode.optional_field(
    "use",
    None,
    decode.optional(valueset.address_use_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Address(
    period:,
    country:,
    postal_code:,
    state:,
    district:,
    city:,
    line:,
    text:,
    type_:,
    use_:,
    extension:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4/StructureDefinition/Age#resource](http://hl7.org/fhir/r4/StructureDefinition/Age#resource)
pub type Age {
  Age(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(valueset.QuantityComparator),
    unit: Option(String),
    system: Option(String),
    code: Option(String),
  )
}

pub fn age_new() -> Age {
  Age(
    code: None,
    system: None,
    unit: None,
    comparator: None,
    value: None,
    extension: [],
    id: None,
  )
}

pub fn age_to_json(age: Age) -> Json {
  let fields = []
  let fields = case age.code {
    Some(v) -> [#("code", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case age.system {
    Some(v) -> [#("system", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case age.unit {
    Some(v) -> [#("unit", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case age.comparator {
    Some(v) -> [
      #("comparator", valueset.quantity_comparator_to_json(v)),
      ..fields
    ]
    None -> fields
  }
  let fields = case age.value {
    Some(v) -> [#("value", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case age.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(age.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case age.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn age_decoder() -> Decoder(Age) {
  use <- decode.recursive
  use code <- decode.optional_field(
    "code",
    None,
    decode.optional(decode.string),
  )
  use system <- decode.optional_field(
    "system",
    None,
    decode.optional(decode.string),
  )
  use unit <- decode.optional_field(
    "unit",
    None,
    decode.optional(decode.string),
  )
  use comparator <- decode.optional_field(
    "comparator",
    None,
    decode.optional(valueset.quantity_comparator_decoder()),
  )
  use value <- decode.optional_field(
    "value",
    None,
    decode.optional(decode_number()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Age(
    code:,
    system:,
    unit:,
    comparator:,
    value:,
    extension:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4/StructureDefinition/Annotation#resource](http://hl7.org/fhir/r4/StructureDefinition/Annotation#resource)
pub type Annotation {
  Annotation(
    id: Option(String),
    extension: List(Extension),
    author: Option(AnnotationAuthor),
    time: Option(DateTime),
    text: String,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/Annotation#resource](http://hl7.org/fhir/r4/StructureDefinition/Annotation#resource)
pub type AnnotationAuthor {
  AnnotationAuthorReference(author: Reference)
  AnnotationAuthorString(author: String)
}

pub fn annotation_author_to_json(element: AnnotationAuthor) -> Json {
  case element {
    AnnotationAuthorReference(v) -> reference_to_json(v)
    AnnotationAuthorString(v) -> json.string(v)
  }
}

pub fn annotation_author_decoder() -> Decoder(AnnotationAuthor) {
  decode.one_of(
    decode.field("authorReference", reference_decoder(), decode.success)
      |> decode.map(AnnotationAuthorReference),
    [
      decode.field("authorString", decode.string, decode.success)
      |> decode.map(AnnotationAuthorString),
    ],
  )
}

pub fn annotation_new(text text: String) -> Annotation {
  Annotation(text:, time: None, author: None, extension: [], id: None)
}

pub fn annotation_to_json(annotation: Annotation) -> Json {
  let fields = [
    #("text", json.string(annotation.text)),
  ]
  let fields = case annotation.time {
    Some(v) -> [#("time", pt.datetime_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case annotation.author {
    Some(v) -> [
      #(
        "author"
          <> case v {
          AnnotationAuthorReference(_) -> "Reference"
          AnnotationAuthorString(_) -> "String"
        },
        annotation_author_to_json(v),
      ),
      ..fields
    ]
    None -> fields
  }
  let fields = case annotation.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(annotation.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case annotation.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn annotation_decoder() -> Decoder(Annotation) {
  use <- decode.recursive
  use text <- decode.field("text", decode.string)
  use time <- decode.optional_field(
    "time",
    None,
    decode.optional(pt.datetime_decoder()),
  )
  use author <- decode.then(none_if_omitted(annotation_author_decoder()))
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Annotation(text:, time:, author:, extension:, id:))
}

///[http://hl7.org/fhir/r4/StructureDefinition/Attachment#resource](http://hl7.org/fhir/r4/StructureDefinition/Attachment#resource)
pub type Attachment {
  Attachment(
    id: Option(String),
    extension: List(Extension),
    content_type: Option(String),
    language: Option(String),
    data: Option(String),
    url: Option(String),
    size: Option(Int),
    hash: Option(String),
    title: Option(String),
    creation: Option(DateTime),
  )
}

pub fn attachment_new() -> Attachment {
  Attachment(
    creation: None,
    title: None,
    hash: None,
    size: None,
    url: None,
    data: None,
    language: None,
    content_type: None,
    extension: [],
    id: None,
  )
}

pub fn attachment_to_json(attachment: Attachment) -> Json {
  let fields = []
  let fields = case attachment.creation {
    Some(v) -> [#("creation", pt.datetime_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case attachment.title {
    Some(v) -> [#("title", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case attachment.hash {
    Some(v) -> [#("hash", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case attachment.size {
    Some(v) -> [#("size", json.int(v)), ..fields]
    None -> fields
  }
  let fields = case attachment.url {
    Some(v) -> [#("url", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case attachment.data {
    Some(v) -> [#("data", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case attachment.language {
    Some(v) -> [#("language", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case attachment.content_type {
    Some(v) -> [#("contentType", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case attachment.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(attachment.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case attachment.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn attachment_decoder() -> Decoder(Attachment) {
  use <- decode.recursive
  use creation <- decode.optional_field(
    "creation",
    None,
    decode.optional(pt.datetime_decoder()),
  )
  use title <- decode.optional_field(
    "title",
    None,
    decode.optional(decode.string),
  )
  use hash <- decode.optional_field(
    "hash",
    None,
    decode.optional(decode.string),
  )
  use size <- decode.optional_field("size", None, decode.optional(decode.int))
  use url <- decode.optional_field("url", None, decode.optional(decode.string))
  use data <- decode.optional_field(
    "data",
    None,
    decode.optional(decode.string),
  )
  use language <- decode.optional_field(
    "language",
    None,
    decode.optional(decode.string),
  )
  use content_type <- decode.optional_field(
    "contentType",
    None,
    decode.optional(decode.string),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Attachment(
    creation:,
    title:,
    hash:,
    size:,
    url:,
    data:,
    language:,
    content_type:,
    extension:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4/StructureDefinition/CodeableConcept#resource](http://hl7.org/fhir/r4/StructureDefinition/CodeableConcept#resource)
pub type Codeableconcept {
  Codeableconcept(
    id: Option(String),
    extension: List(Extension),
    coding: List(Coding),
    text: Option(String),
  )
}

pub fn codeableconcept_new() -> Codeableconcept {
  Codeableconcept(text: None, coding: [], extension: [], id: None)
}

pub fn codeableconcept_to_json(codeableconcept: Codeableconcept) -> Json {
  let fields = []
  let fields = case codeableconcept.text {
    Some(v) -> [#("text", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case codeableconcept.coding {
    [] -> fields
    _ -> [
      #("coding", json.array(codeableconcept.coding, coding_to_json)),
      ..fields
    ]
  }
  let fields = case codeableconcept.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(codeableconcept.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case codeableconcept.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn codeableconcept_decoder() -> Decoder(Codeableconcept) {
  use <- decode.recursive
  use text <- decode.optional_field(
    "text",
    None,
    decode.optional(decode.string),
  )
  use coding <- decode.optional_field(
    "coding",
    [],
    decode.list(coding_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Codeableconcept(text:, coding:, extension:, id:))
}

///[http://hl7.org/fhir/r4/StructureDefinition/Coding#resource](http://hl7.org/fhir/r4/StructureDefinition/Coding#resource)
pub type Coding {
  Coding(
    id: Option(String),
    extension: List(Extension),
    system: Option(String),
    version: Option(String),
    code: Option(String),
    display: Option(String),
    user_selected: Option(Bool),
  )
}

pub fn coding_new() -> Coding {
  Coding(
    user_selected: None,
    display: None,
    code: None,
    version: None,
    system: None,
    extension: [],
    id: None,
  )
}

pub fn coding_to_json(coding: Coding) -> Json {
  let fields = []
  let fields = case coding.user_selected {
    Some(v) -> [#("userSelected", json.bool(v)), ..fields]
    None -> fields
  }
  let fields = case coding.display {
    Some(v) -> [#("display", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case coding.code {
    Some(v) -> [#("code", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case coding.version {
    Some(v) -> [#("version", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case coding.system {
    Some(v) -> [#("system", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case coding.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(coding.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case coding.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn coding_decoder() -> Decoder(Coding) {
  use <- decode.recursive
  use user_selected <- decode.optional_field(
    "userSelected",
    None,
    decode.optional(decode.bool),
  )
  use display <- decode.optional_field(
    "display",
    None,
    decode.optional(decode.string),
  )
  use code <- decode.optional_field(
    "code",
    None,
    decode.optional(decode.string),
  )
  use version <- decode.optional_field(
    "version",
    None,
    decode.optional(decode.string),
  )
  use system <- decode.optional_field(
    "system",
    None,
    decode.optional(decode.string),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Coding(
    user_selected:,
    display:,
    code:,
    version:,
    system:,
    extension:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4/StructureDefinition/ContactDetail#resource](http://hl7.org/fhir/r4/StructureDefinition/ContactDetail#resource)
pub type Contactdetail {
  Contactdetail(
    id: Option(String),
    extension: List(Extension),
    name: Option(String),
    telecom: List(Contactpoint),
  )
}

pub fn contactdetail_new() -> Contactdetail {
  Contactdetail(telecom: [], name: None, extension: [], id: None)
}

pub fn contactdetail_to_json(contactdetail: Contactdetail) -> Json {
  let fields = []
  let fields = case contactdetail.telecom {
    [] -> fields
    _ -> [
      #("telecom", json.array(contactdetail.telecom, contactpoint_to_json)),
      ..fields
    ]
  }
  let fields = case contactdetail.name {
    Some(v) -> [#("name", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case contactdetail.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(contactdetail.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case contactdetail.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn contactdetail_decoder() -> Decoder(Contactdetail) {
  use <- decode.recursive
  use telecom <- decode.optional_field(
    "telecom",
    [],
    decode.list(contactpoint_decoder()),
  )
  use name <- decode.optional_field(
    "name",
    None,
    decode.optional(decode.string),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Contactdetail(telecom:, name:, extension:, id:))
}

///[http://hl7.org/fhir/r4/StructureDefinition/ContactPoint#resource](http://hl7.org/fhir/r4/StructureDefinition/ContactPoint#resource)
pub type Contactpoint {
  Contactpoint(
    id: Option(String),
    extension: List(Extension),
    system: Option(valueset.ContactpointSystem),
    value: Option(String),
    use_: Option(valueset.ContactpointUse),
    rank: Option(Int),
    period: Option(Period),
  )
}

pub fn contactpoint_new() -> Contactpoint {
  Contactpoint(
    period: None,
    rank: None,
    use_: None,
    value: None,
    system: None,
    extension: [],
    id: None,
  )
}

pub fn contactpoint_to_json(contactpoint: Contactpoint) -> Json {
  let fields = []
  let fields = case contactpoint.period {
    Some(v) -> [#("period", period_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case contactpoint.rank {
    Some(v) -> [#("rank", json.int(v)), ..fields]
    None -> fields
  }
  let fields = case contactpoint.use_ {
    Some(v) -> [#("use", valueset.contactpoint_use_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case contactpoint.value {
    Some(v) -> [#("value", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case contactpoint.system {
    Some(v) -> [#("system", valueset.contactpoint_system_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case contactpoint.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(contactpoint.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case contactpoint.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn contactpoint_decoder() -> Decoder(Contactpoint) {
  use <- decode.recursive
  use period <- decode.optional_field(
    "period",
    None,
    decode.optional(period_decoder()),
  )
  use rank <- decode.optional_field("rank", None, decode.optional(decode.int))
  use use_ <- decode.optional_field(
    "use",
    None,
    decode.optional(valueset.contactpoint_use_decoder()),
  )
  use value <- decode.optional_field(
    "value",
    None,
    decode.optional(decode.string),
  )
  use system <- decode.optional_field(
    "system",
    None,
    decode.optional(valueset.contactpoint_system_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Contactpoint(
    period:,
    rank:,
    use_:,
    value:,
    system:,
    extension:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4/StructureDefinition/Contributor#resource](http://hl7.org/fhir/r4/StructureDefinition/Contributor#resource)
pub type Contributor {
  Contributor(
    id: Option(String),
    extension: List(Extension),
    type_: valueset.ContributorType,
    name: String,
    contact: List(Contactdetail),
  )
}

pub fn contributor_new(
  name name: String,
  type_ type_: valueset.ContributorType,
) -> Contributor {
  Contributor(contact: [], name:, type_:, extension: [], id: None)
}

pub fn contributor_to_json(contributor: Contributor) -> Json {
  let fields = [
    #("name", json.string(contributor.name)),
    #("type", valueset.contributor_type_to_json(contributor.type_)),
  ]
  let fields = case contributor.contact {
    [] -> fields
    _ -> [
      #("contact", json.array(contributor.contact, contactdetail_to_json)),
      ..fields
    ]
  }
  let fields = case contributor.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(contributor.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case contributor.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn contributor_decoder() -> Decoder(Contributor) {
  use <- decode.recursive
  use contact <- decode.optional_field(
    "contact",
    [],
    decode.list(contactdetail_decoder()),
  )
  use name <- decode.field("name", decode.string)
  use type_ <- decode.field("type", valueset.contributor_type_decoder())
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Contributor(contact:, name:, type_:, extension:, id:))
}

///[http://hl7.org/fhir/r4/StructureDefinition/Count#resource](http://hl7.org/fhir/r4/StructureDefinition/Count#resource)
pub type Count {
  Count(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(valueset.QuantityComparator),
    unit: Option(String),
    system: Option(String),
    code: Option(String),
  )
}

pub fn count_new() -> Count {
  Count(
    code: None,
    system: None,
    unit: None,
    comparator: None,
    value: None,
    extension: [],
    id: None,
  )
}

pub fn count_to_json(count: Count) -> Json {
  let fields = []
  let fields = case count.code {
    Some(v) -> [#("code", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case count.system {
    Some(v) -> [#("system", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case count.unit {
    Some(v) -> [#("unit", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case count.comparator {
    Some(v) -> [
      #("comparator", valueset.quantity_comparator_to_json(v)),
      ..fields
    ]
    None -> fields
  }
  let fields = case count.value {
    Some(v) -> [#("value", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case count.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(count.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case count.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn count_decoder() -> Decoder(Count) {
  use <- decode.recursive
  use code <- decode.optional_field(
    "code",
    None,
    decode.optional(decode.string),
  )
  use system <- decode.optional_field(
    "system",
    None,
    decode.optional(decode.string),
  )
  use unit <- decode.optional_field(
    "unit",
    None,
    decode.optional(decode.string),
  )
  use comparator <- decode.optional_field(
    "comparator",
    None,
    decode.optional(valueset.quantity_comparator_decoder()),
  )
  use value <- decode.optional_field(
    "value",
    None,
    decode.optional(decode_number()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Count(
    code:,
    system:,
    unit:,
    comparator:,
    value:,
    extension:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4/StructureDefinition/DataRequirement#resource](http://hl7.org/fhir/r4/StructureDefinition/DataRequirement#resource)
pub type Datarequirement {
  Datarequirement(
    id: Option(String),
    extension: List(Extension),
    type_: valueset.AllTypes,
    profile: List(String),
    subject: Option(DatarequirementSubject),
    must_support: List(String),
    code_filter: List(DatarequirementCodefilter),
    date_filter: List(DatarequirementDatefilter),
    limit: Option(Int),
    sort: List(DatarequirementSort),
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/DataRequirement#resource](http://hl7.org/fhir/r4/StructureDefinition/DataRequirement#resource)
pub type DatarequirementSubject {
  DatarequirementSubjectCodeableconcept(subject: Codeableconcept)
  DatarequirementSubjectReference(subject: Reference)
}

pub fn datarequirement_subject_to_json(
  element: DatarequirementSubject,
) -> Json {
  case element {
    DatarequirementSubjectCodeableconcept(v) -> codeableconcept_to_json(v)
    DatarequirementSubjectReference(v) -> reference_to_json(v)
  }
}

pub fn datarequirement_subject_decoder() -> Decoder(DatarequirementSubject) {
  decode.one_of(
    decode.field(
      "subjectCodeableConcept",
      codeableconcept_decoder(),
      decode.success,
    )
      |> decode.map(DatarequirementSubjectCodeableconcept),
    [
      decode.field("subjectReference", reference_decoder(), decode.success)
      |> decode.map(DatarequirementSubjectReference),
    ],
  )
}

pub fn datarequirement_new(type_ type_: valueset.AllTypes) -> Datarequirement {
  Datarequirement(
    sort: [],
    limit: None,
    date_filter: [],
    code_filter: [],
    must_support: [],
    subject: None,
    profile: [],
    type_:,
    extension: [],
    id: None,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/DataRequirement#resource](http://hl7.org/fhir/r4/StructureDefinition/DataRequirement#resource)
pub type DatarequirementCodefilter {
  DatarequirementCodefilter(
    id: Option(String),
    extension: List(Extension),
    path: Option(String),
    search_param: Option(String),
    value_set: Option(String),
    code: List(Coding),
  )
}

pub fn datarequirement_codefilter_new() -> DatarequirementCodefilter {
  DatarequirementCodefilter(
    code: [],
    value_set: None,
    search_param: None,
    path: None,
    extension: [],
    id: None,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/DataRequirement#resource](http://hl7.org/fhir/r4/StructureDefinition/DataRequirement#resource)
pub type DatarequirementDatefilter {
  DatarequirementDatefilter(
    id: Option(String),
    extension: List(Extension),
    path: Option(String),
    search_param: Option(String),
    value: Option(DatarequirementDatefilterValue),
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/DataRequirement#resource](http://hl7.org/fhir/r4/StructureDefinition/DataRequirement#resource)
pub type DatarequirementDatefilterValue {
  DatarequirementDatefilterValueDatetime(value: DateTime)
  DatarequirementDatefilterValuePeriod(value: Period)
  DatarequirementDatefilterValueDuration(value: Duration)
}

pub fn datarequirement_datefilter_value_to_json(
  element: DatarequirementDatefilterValue,
) -> Json {
  case element {
    DatarequirementDatefilterValueDatetime(v) -> pt.datetime_to_json(v)
    DatarequirementDatefilterValuePeriod(v) -> period_to_json(v)
    DatarequirementDatefilterValueDuration(v) -> duration_to_json(v)
  }
}

pub fn datarequirement_datefilter_value_decoder() -> Decoder(
  DatarequirementDatefilterValue,
) {
  decode.one_of(
    decode.field("valueDateTime", pt.datetime_decoder(), decode.success)
      |> decode.map(DatarequirementDatefilterValueDatetime),
    [
      decode.field("valuePeriod", period_decoder(), decode.success)
        |> decode.map(DatarequirementDatefilterValuePeriod),
      decode.field("valueDuration", duration_decoder(), decode.success)
        |> decode.map(DatarequirementDatefilterValueDuration),
    ],
  )
}

pub fn datarequirement_datefilter_new() -> DatarequirementDatefilter {
  DatarequirementDatefilter(
    value: None,
    search_param: None,
    path: None,
    extension: [],
    id: None,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/DataRequirement#resource](http://hl7.org/fhir/r4/StructureDefinition/DataRequirement#resource)
pub type DatarequirementSort {
  DatarequirementSort(
    id: Option(String),
    extension: List(Extension),
    path: String,
    direction: valueset.SortDirection,
  )
}

pub fn datarequirement_sort_new(
  direction direction: valueset.SortDirection,
  path path: String,
) -> DatarequirementSort {
  DatarequirementSort(direction:, path:, extension: [], id: None)
}

pub fn datarequirement_sort_to_json(
  datarequirement_sort: DatarequirementSort,
) -> Json {
  let fields = [
    #(
      "direction",
      valueset.sort_direction_to_json(datarequirement_sort.direction),
    ),
    #("path", json.string(datarequirement_sort.path)),
  ]
  let fields = case datarequirement_sort.extension {
    [] -> fields
    _ -> [
      #(
        "extension",
        json.array(datarequirement_sort.extension, extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case datarequirement_sort.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn datarequirement_sort_decoder() -> Decoder(DatarequirementSort) {
  use <- decode.recursive
  use direction <- decode.field("direction", valueset.sort_direction_decoder())
  use path <- decode.field("path", decode.string)
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(DatarequirementSort(direction:, path:, extension:, id:))
}

pub fn datarequirement_datefilter_to_json(
  datarequirement_datefilter: DatarequirementDatefilter,
) -> Json {
  let fields = []
  let fields = case datarequirement_datefilter.value {
    Some(v) -> [
      #(
        "value"
          <> case v {
          DatarequirementDatefilterValueDatetime(_) -> "DateTime"
          DatarequirementDatefilterValuePeriod(_) -> "Period"
          DatarequirementDatefilterValueDuration(_) -> "Duration"
        },
        datarequirement_datefilter_value_to_json(v),
      ),
      ..fields
    ]
    None -> fields
  }
  let fields = case datarequirement_datefilter.search_param {
    Some(v) -> [#("searchParam", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case datarequirement_datefilter.path {
    Some(v) -> [#("path", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case datarequirement_datefilter.extension {
    [] -> fields
    _ -> [
      #(
        "extension",
        json.array(datarequirement_datefilter.extension, extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case datarequirement_datefilter.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn datarequirement_datefilter_decoder() -> Decoder(
  DatarequirementDatefilter,
) {
  use <- decode.recursive
  use value <- decode.then(
    none_if_omitted(datarequirement_datefilter_value_decoder()),
  )
  use search_param <- decode.optional_field(
    "searchParam",
    None,
    decode.optional(decode.string),
  )
  use path <- decode.optional_field(
    "path",
    None,
    decode.optional(decode.string),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(DatarequirementDatefilter(
    value:,
    search_param:,
    path:,
    extension:,
    id:,
  ))
}

pub fn datarequirement_codefilter_to_json(
  datarequirement_codefilter: DatarequirementCodefilter,
) -> Json {
  let fields = []
  let fields = case datarequirement_codefilter.code {
    [] -> fields
    _ -> [
      #("code", json.array(datarequirement_codefilter.code, coding_to_json)),
      ..fields
    ]
  }
  let fields = case datarequirement_codefilter.value_set {
    Some(v) -> [#("valueSet", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case datarequirement_codefilter.search_param {
    Some(v) -> [#("searchParam", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case datarequirement_codefilter.path {
    Some(v) -> [#("path", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case datarequirement_codefilter.extension {
    [] -> fields
    _ -> [
      #(
        "extension",
        json.array(datarequirement_codefilter.extension, extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case datarequirement_codefilter.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn datarequirement_codefilter_decoder() -> Decoder(
  DatarequirementCodefilter,
) {
  use <- decode.recursive
  use code <- decode.optional_field("code", [], decode.list(coding_decoder()))
  use value_set <- decode.optional_field(
    "valueSet",
    None,
    decode.optional(decode.string),
  )
  use search_param <- decode.optional_field(
    "searchParam",
    None,
    decode.optional(decode.string),
  )
  use path <- decode.optional_field(
    "path",
    None,
    decode.optional(decode.string),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(DatarequirementCodefilter(
    code:,
    value_set:,
    search_param:,
    path:,
    extension:,
    id:,
  ))
}

pub fn datarequirement_to_json(datarequirement: Datarequirement) -> Json {
  let fields = [
    #("type", valueset.all_types_to_json(datarequirement.type_)),
  ]
  let fields = case datarequirement.sort {
    [] -> fields
    _ -> [
      #("sort", json.array(datarequirement.sort, datarequirement_sort_to_json)),
      ..fields
    ]
  }
  let fields = case datarequirement.limit {
    Some(v) -> [#("limit", json.int(v)), ..fields]
    None -> fields
  }
  let fields = case datarequirement.date_filter {
    [] -> fields
    _ -> [
      #(
        "dateFilter",
        json.array(
          datarequirement.date_filter,
          datarequirement_datefilter_to_json,
        ),
      ),
      ..fields
    ]
  }
  let fields = case datarequirement.code_filter {
    [] -> fields
    _ -> [
      #(
        "codeFilter",
        json.array(
          datarequirement.code_filter,
          datarequirement_codefilter_to_json,
        ),
      ),
      ..fields
    ]
  }
  let fields = case datarequirement.must_support {
    [] -> fields
    _ -> [
      #("mustSupport", json.array(datarequirement.must_support, json.string)),
      ..fields
    ]
  }
  let fields = case datarequirement.subject {
    Some(v) -> [
      #(
        "subject"
          <> case v {
          DatarequirementSubjectCodeableconcept(_) -> "CodeableConcept"
          DatarequirementSubjectReference(_) -> "Reference"
        },
        datarequirement_subject_to_json(v),
      ),
      ..fields
    ]
    None -> fields
  }
  let fields = case datarequirement.profile {
    [] -> fields
    _ -> [
      #("profile", json.array(datarequirement.profile, json.string)),
      ..fields
    ]
  }
  let fields = case datarequirement.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(datarequirement.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case datarequirement.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn datarequirement_decoder() -> Decoder(Datarequirement) {
  use <- decode.recursive
  use sort <- decode.optional_field(
    "sort",
    [],
    decode.list(datarequirement_sort_decoder()),
  )
  use limit <- decode.optional_field("limit", None, decode.optional(decode.int))
  use date_filter <- decode.optional_field(
    "dateFilter",
    [],
    decode.list(datarequirement_datefilter_decoder()),
  )
  use code_filter <- decode.optional_field(
    "codeFilter",
    [],
    decode.list(datarequirement_codefilter_decoder()),
  )
  use must_support <- decode.optional_field(
    "mustSupport",
    [],
    decode.list(decode.string),
  )
  use subject <- decode.then(none_if_omitted(datarequirement_subject_decoder()))
  use profile <- decode.optional_field(
    "profile",
    [],
    decode.list(decode.string),
  )
  use type_ <- decode.field("type", valueset.all_types_decoder())
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Datarequirement(
    sort:,
    limit:,
    date_filter:,
    code_filter:,
    must_support:,
    subject:,
    profile:,
    type_:,
    extension:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4/StructureDefinition/Distance#resource](http://hl7.org/fhir/r4/StructureDefinition/Distance#resource)
pub type Distance {
  Distance(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(valueset.QuantityComparator),
    unit: Option(String),
    system: Option(String),
    code: Option(String),
  )
}

pub fn distance_new() -> Distance {
  Distance(
    code: None,
    system: None,
    unit: None,
    comparator: None,
    value: None,
    extension: [],
    id: None,
  )
}

pub fn distance_to_json(distance: Distance) -> Json {
  let fields = []
  let fields = case distance.code {
    Some(v) -> [#("code", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case distance.system {
    Some(v) -> [#("system", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case distance.unit {
    Some(v) -> [#("unit", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case distance.comparator {
    Some(v) -> [
      #("comparator", valueset.quantity_comparator_to_json(v)),
      ..fields
    ]
    None -> fields
  }
  let fields = case distance.value {
    Some(v) -> [#("value", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case distance.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(distance.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case distance.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn distance_decoder() -> Decoder(Distance) {
  use <- decode.recursive
  use code <- decode.optional_field(
    "code",
    None,
    decode.optional(decode.string),
  )
  use system <- decode.optional_field(
    "system",
    None,
    decode.optional(decode.string),
  )
  use unit <- decode.optional_field(
    "unit",
    None,
    decode.optional(decode.string),
  )
  use comparator <- decode.optional_field(
    "comparator",
    None,
    decode.optional(valueset.quantity_comparator_decoder()),
  )
  use value <- decode.optional_field(
    "value",
    None,
    decode.optional(decode_number()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Distance(
    code:,
    system:,
    unit:,
    comparator:,
    value:,
    extension:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4/StructureDefinition/Dosage#resource](http://hl7.org/fhir/r4/StructureDefinition/Dosage#resource)
pub type Dosage {
  Dosage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Option(Int),
    text: Option(String),
    additional_instruction: List(Codeableconcept),
    patient_instruction: Option(String),
    timing: Option(Timing),
    as_needed: Option(DosageAsneeded),
    site: Option(Codeableconcept),
    route: Option(Codeableconcept),
    method: Option(Codeableconcept),
    dose_and_rate: List(DosageDoseandrate),
    max_dose_per_period: Option(Ratio),
    max_dose_per_administration: Option(Quantity),
    max_dose_per_lifetime: Option(Quantity),
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/Dosage#resource](http://hl7.org/fhir/r4/StructureDefinition/Dosage#resource)
pub type DosageAsneeded {
  DosageAsneededBoolean(as_needed: Bool)
  DosageAsneededCodeableconcept(as_needed: Codeableconcept)
}

pub fn dosage_asneeded_to_json(element: DosageAsneeded) -> Json {
  case element {
    DosageAsneededBoolean(v) -> json.bool(v)
    DosageAsneededCodeableconcept(v) -> codeableconcept_to_json(v)
  }
}

pub fn dosage_asneeded_decoder() -> Decoder(DosageAsneeded) {
  decode.one_of(
    decode.field("asNeededBoolean", decode.bool, decode.success)
      |> decode.map(DosageAsneededBoolean),
    [
      decode.field(
        "asNeededCodeableConcept",
        codeableconcept_decoder(),
        decode.success,
      )
      |> decode.map(DosageAsneededCodeableconcept),
    ],
  )
}

pub fn dosage_new() -> Dosage {
  Dosage(
    max_dose_per_lifetime: None,
    max_dose_per_administration: None,
    max_dose_per_period: None,
    dose_and_rate: [],
    method: None,
    route: None,
    site: None,
    as_needed: None,
    timing: None,
    patient_instruction: None,
    additional_instruction: [],
    text: None,
    sequence: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/Dosage#resource](http://hl7.org/fhir/r4/StructureDefinition/Dosage#resource)
pub type DosageDoseandrate {
  DosageDoseandrate(
    id: Option(String),
    extension: List(Extension),
    type_: Option(Codeableconcept),
    dose: Option(DosageDoseandrateDose),
    rate: Option(DosageDoseandrateRate),
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/Dosage#resource](http://hl7.org/fhir/r4/StructureDefinition/Dosage#resource)
pub type DosageDoseandrateDose {
  DosageDoseandrateDoseRange(dose: Range)
  DosageDoseandrateDoseQuantity(dose: Quantity)
}

pub fn dosage_doseandrate_dose_to_json(element: DosageDoseandrateDose) -> Json {
  case element {
    DosageDoseandrateDoseRange(v) -> range_to_json(v)
    DosageDoseandrateDoseQuantity(v) -> quantity_to_json(v)
  }
}

pub fn dosage_doseandrate_dose_decoder() -> Decoder(DosageDoseandrateDose) {
  decode.one_of(
    decode.field("doseRange", range_decoder(), decode.success)
      |> decode.map(DosageDoseandrateDoseRange),
    [
      decode.field("doseQuantity", quantity_decoder(), decode.success)
      |> decode.map(DosageDoseandrateDoseQuantity),
    ],
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/Dosage#resource](http://hl7.org/fhir/r4/StructureDefinition/Dosage#resource)
pub type DosageDoseandrateRate {
  DosageDoseandrateRateRatio(rate: Ratio)
  DosageDoseandrateRateRange(rate: Range)
  DosageDoseandrateRateQuantity(rate: Quantity)
}

pub fn dosage_doseandrate_rate_to_json(element: DosageDoseandrateRate) -> Json {
  case element {
    DosageDoseandrateRateRatio(v) -> ratio_to_json(v)
    DosageDoseandrateRateRange(v) -> range_to_json(v)
    DosageDoseandrateRateQuantity(v) -> quantity_to_json(v)
  }
}

pub fn dosage_doseandrate_rate_decoder() -> Decoder(DosageDoseandrateRate) {
  decode.one_of(
    decode.field("rateRatio", ratio_decoder(), decode.success)
      |> decode.map(DosageDoseandrateRateRatio),
    [
      decode.field("rateRange", range_decoder(), decode.success)
        |> decode.map(DosageDoseandrateRateRange),
      decode.field("rateQuantity", quantity_decoder(), decode.success)
        |> decode.map(DosageDoseandrateRateQuantity),
    ],
  )
}

pub fn dosage_doseandrate_new() -> DosageDoseandrate {
  DosageDoseandrate(
    rate: None,
    dose: None,
    type_: None,
    extension: [],
    id: None,
  )
}

pub fn dosage_doseandrate_to_json(
  dosage_doseandrate: DosageDoseandrate,
) -> Json {
  let fields = []
  let fields = case dosage_doseandrate.rate {
    Some(v) -> [
      #(
        "rate"
          <> case v {
          DosageDoseandrateRateRatio(_) -> "Ratio"
          DosageDoseandrateRateRange(_) -> "Range"
          DosageDoseandrateRateQuantity(_) -> "Quantity"
        },
        dosage_doseandrate_rate_to_json(v),
      ),
      ..fields
    ]
    None -> fields
  }
  let fields = case dosage_doseandrate.dose {
    Some(v) -> [
      #(
        "dose"
          <> case v {
          DosageDoseandrateDoseRange(_) -> "Range"
          DosageDoseandrateDoseQuantity(_) -> "Quantity"
        },
        dosage_doseandrate_dose_to_json(v),
      ),
      ..fields
    ]
    None -> fields
  }
  let fields = case dosage_doseandrate.type_ {
    Some(v) -> [#("type", codeableconcept_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case dosage_doseandrate.extension {
    [] -> fields
    _ -> [
      #(
        "extension",
        json.array(dosage_doseandrate.extension, extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case dosage_doseandrate.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn dosage_doseandrate_decoder() -> Decoder(DosageDoseandrate) {
  use <- decode.recursive
  use rate <- decode.then(none_if_omitted(dosage_doseandrate_rate_decoder()))
  use dose <- decode.then(none_if_omitted(dosage_doseandrate_dose_decoder()))
  use type_ <- decode.optional_field(
    "type",
    None,
    decode.optional(codeableconcept_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(DosageDoseandrate(rate:, dose:, type_:, extension:, id:))
}

pub fn dosage_to_json(dosage: Dosage) -> Json {
  let fields = []
  let fields = case dosage.max_dose_per_lifetime {
    Some(v) -> [#("maxDosePerLifetime", quantity_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case dosage.max_dose_per_administration {
    Some(v) -> [#("maxDosePerAdministration", quantity_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case dosage.max_dose_per_period {
    Some(v) -> [#("maxDosePerPeriod", ratio_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case dosage.dose_and_rate {
    [] -> fields
    _ -> [
      #(
        "doseAndRate",
        json.array(dosage.dose_and_rate, dosage_doseandrate_to_json),
      ),
      ..fields
    ]
  }
  let fields = case dosage.method {
    Some(v) -> [#("method", codeableconcept_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case dosage.route {
    Some(v) -> [#("route", codeableconcept_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case dosage.site {
    Some(v) -> [#("site", codeableconcept_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case dosage.as_needed {
    Some(v) -> [
      #(
        "asNeeded"
          <> case v {
          DosageAsneededBoolean(_) -> "Boolean"
          DosageAsneededCodeableconcept(_) -> "CodeableConcept"
        },
        dosage_asneeded_to_json(v),
      ),
      ..fields
    ]
    None -> fields
  }
  let fields = case dosage.timing {
    Some(v) -> [#("timing", timing_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case dosage.patient_instruction {
    Some(v) -> [#("patientInstruction", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case dosage.additional_instruction {
    [] -> fields
    _ -> [
      #(
        "additionalInstruction",
        json.array(dosage.additional_instruction, codeableconcept_to_json),
      ),
      ..fields
    ]
  }
  let fields = case dosage.text {
    Some(v) -> [#("text", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case dosage.sequence {
    Some(v) -> [#("sequence", json.int(v)), ..fields]
    None -> fields
  }
  let fields = case dosage.modifier_extension {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(dosage.modifier_extension, extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case dosage.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(dosage.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case dosage.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn dosage_decoder() -> Decoder(Dosage) {
  use <- decode.recursive
  use max_dose_per_lifetime <- decode.optional_field(
    "maxDosePerLifetime",
    None,
    decode.optional(quantity_decoder()),
  )
  use max_dose_per_administration <- decode.optional_field(
    "maxDosePerAdministration",
    None,
    decode.optional(quantity_decoder()),
  )
  use max_dose_per_period <- decode.optional_field(
    "maxDosePerPeriod",
    None,
    decode.optional(ratio_decoder()),
  )
  use dose_and_rate <- decode.optional_field(
    "doseAndRate",
    [],
    decode.list(dosage_doseandrate_decoder()),
  )
  use method <- decode.optional_field(
    "method",
    None,
    decode.optional(codeableconcept_decoder()),
  )
  use route <- decode.optional_field(
    "route",
    None,
    decode.optional(codeableconcept_decoder()),
  )
  use site <- decode.optional_field(
    "site",
    None,
    decode.optional(codeableconcept_decoder()),
  )
  use as_needed <- decode.then(none_if_omitted(dosage_asneeded_decoder()))
  use timing <- decode.optional_field(
    "timing",
    None,
    decode.optional(timing_decoder()),
  )
  use patient_instruction <- decode.optional_field(
    "patientInstruction",
    None,
    decode.optional(decode.string),
  )
  use additional_instruction <- decode.optional_field(
    "additionalInstruction",
    [],
    decode.list(codeableconcept_decoder()),
  )
  use text <- decode.optional_field(
    "text",
    None,
    decode.optional(decode.string),
  )
  use sequence <- decode.optional_field(
    "sequence",
    None,
    decode.optional(decode.int),
  )
  use modifier_extension <- decode.optional_field(
    "modifierExtension",
    [],
    decode.list(extension_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Dosage(
    max_dose_per_lifetime:,
    max_dose_per_administration:,
    max_dose_per_period:,
    dose_and_rate:,
    method:,
    route:,
    site:,
    as_needed:,
    timing:,
    patient_instruction:,
    additional_instruction:,
    text:,
    sequence:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4/StructureDefinition/Duration#resource](http://hl7.org/fhir/r4/StructureDefinition/Duration#resource)
pub type Duration {
  Duration(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(valueset.QuantityComparator),
    unit: Option(String),
    system: Option(String),
    code: Option(String),
  )
}

pub fn duration_new() -> Duration {
  Duration(
    code: None,
    system: None,
    unit: None,
    comparator: None,
    value: None,
    extension: [],
    id: None,
  )
}

pub fn duration_to_json(duration: Duration) -> Json {
  let fields = []
  let fields = case duration.code {
    Some(v) -> [#("code", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case duration.system {
    Some(v) -> [#("system", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case duration.unit {
    Some(v) -> [#("unit", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case duration.comparator {
    Some(v) -> [
      #("comparator", valueset.quantity_comparator_to_json(v)),
      ..fields
    ]
    None -> fields
  }
  let fields = case duration.value {
    Some(v) -> [#("value", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case duration.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(duration.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case duration.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn duration_decoder() -> Decoder(Duration) {
  use <- decode.recursive
  use code <- decode.optional_field(
    "code",
    None,
    decode.optional(decode.string),
  )
  use system <- decode.optional_field(
    "system",
    None,
    decode.optional(decode.string),
  )
  use unit <- decode.optional_field(
    "unit",
    None,
    decode.optional(decode.string),
  )
  use comparator <- decode.optional_field(
    "comparator",
    None,
    decode.optional(valueset.quantity_comparator_decoder()),
  )
  use value <- decode.optional_field(
    "value",
    None,
    decode.optional(decode_number()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Duration(
    code:,
    system:,
    unit:,
    comparator:,
    value:,
    extension:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4/StructureDefinition/Expression#resource](http://hl7.org/fhir/r4/StructureDefinition/Expression#resource)
pub type Expression {
  Expression(
    id: Option(String),
    extension: List(Extension),
    description: Option(String),
    name: Option(String),
    language: String,
    expression: Option(String),
    reference: Option(String),
  )
}

pub fn expression_new(language language: String) -> Expression {
  Expression(
    reference: None,
    expression: None,
    language:,
    name: None,
    description: None,
    extension: [],
    id: None,
  )
}

pub fn expression_to_json(expression: Expression) -> Json {
  let fields = [
    #("language", json.string(expression.language)),
  ]
  let fields = case expression.reference {
    Some(v) -> [#("reference", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case expression.expression {
    Some(v) -> [#("expression", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case expression.name {
    Some(v) -> [#("name", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case expression.description {
    Some(v) -> [#("description", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case expression.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(expression.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case expression.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn expression_decoder() -> Decoder(Expression) {
  use <- decode.recursive
  use reference <- decode.optional_field(
    "reference",
    None,
    decode.optional(decode.string),
  )
  use expression <- decode.optional_field(
    "expression",
    None,
    decode.optional(decode.string),
  )
  use language <- decode.field("language", decode.string)
  use name <- decode.optional_field(
    "name",
    None,
    decode.optional(decode.string),
  )
  use description <- decode.optional_field(
    "description",
    None,
    decode.optional(decode.string),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Expression(
    reference:,
    expression:,
    language:,
    name:,
    description:,
    extension:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4/StructureDefinition/Extension#resource](http://hl7.org/fhir/r4/StructureDefinition/Extension#resource)
pub type Extension {
  Extension(
    id: Option(String),
    url: String,
    extension: ExtensionSimpleOrComplex,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/Extension#resource](http://hl7.org/fhir/r4/StructureDefinition/Extension#resource)
pub type ExtensionSimpleOrComplex {
  ExtensionComplex(children: List(Extension))
  ExtensionSimple(value: ExtensionValue)
}

///[http://hl7.org/fhir/r4/StructureDefinition/Extension#resource](http://hl7.org/fhir/r4/StructureDefinition/Extension#resource)
pub type ExtensionValue {
  ExtensionValueBase64binary(value: String)
  ExtensionValueBoolean(value: Bool)
  ExtensionValueCanonical(value: String)
  ExtensionValueCode(value: String)
  ExtensionValueDate(value: Date)
  ExtensionValueDatetime(value: DateTime)
  ExtensionValueDecimal(value: Float)
  ExtensionValueId(value: String)
  ExtensionValueInstant(value: Instant)
  ExtensionValueInteger(value: Int)
  ExtensionValueMarkdown(value: String)
  ExtensionValueOid(value: String)
  ExtensionValuePositiveint(value: Int)
  ExtensionValueString(value: String)
  ExtensionValueTime(value: Time)
  ExtensionValueUnsignedint(value: Int)
  ExtensionValueUri(value: String)
  ExtensionValueUrl(value: String)
  ExtensionValueUuid(value: String)
  ExtensionValueAddress(value: Address)
  ExtensionValueAge(value: Age)
  ExtensionValueAnnotation(value: Annotation)
  ExtensionValueAttachment(value: Attachment)
  ExtensionValueCodeableconcept(value: Codeableconcept)
  ExtensionValueCoding(value: Coding)
  ExtensionValueContactpoint(value: Contactpoint)
  ExtensionValueCount(value: Count)
  ExtensionValueDistance(value: Distance)
  ExtensionValueDuration(value: Duration)
  ExtensionValueHumanname(value: Humanname)
  ExtensionValueIdentifier(value: Identifier)
  ExtensionValueMoney(value: Money)
  ExtensionValuePeriod(value: Period)
  ExtensionValueQuantity(value: Quantity)
  ExtensionValueRange(value: Range)
  ExtensionValueRatio(value: Ratio)
  ExtensionValueReference(value: Reference)
  ExtensionValueSampleddata(value: Sampleddata)
  ExtensionValueSignature(value: Signature)
  ExtensionValueTiming(value: Timing)
  ExtensionValueContactdetail(value: Contactdetail)
  ExtensionValueContributor(value: Contributor)
  ExtensionValueDatarequirement(value: Datarequirement)
  ExtensionValueExpression(value: Expression)
  ExtensionValueParameterdefinition(value: Parameterdefinition)
  ExtensionValueRelatedartifact(value: Relatedartifact)
  ExtensionValueTriggerdefinition(value: Triggerdefinition)
  ExtensionValueUsagecontext(value: Usagecontext)
  ExtensionValueDosage(value: Dosage)
  ExtensionValueMeta(value: Meta)
}

pub fn extension_to_json(extension: Extension) -> Json {
  let fields = [#("url", json.string(extension.url))]
  let fields = case extension.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  let fields = [
    extension_simple_or_complex_to_json(extension.extension),
    ..fields
  ]
  json.object(fields)
}

fn extension_simple_or_complex_to_json(
  extension: ExtensionSimpleOrComplex,
) -> #(String, Json) {
  case extension {
    ExtensionComplex(children) -> #(
      "extension",
      json.array(children, extension_to_json),
    )
    ExtensionSimple(value) -> extension_simple_to_json(value)
  }
}

fn extension_simple_to_json(v: ExtensionValue) -> #(String, Json) {
  #(
    "value"
      <> case v {
      ExtensionValueBase64binary(_) -> "Base64Binary"
      ExtensionValueBoolean(_) -> "Boolean"
      ExtensionValueCanonical(_) -> "Canonical"
      ExtensionValueCode(_) -> "Code"
      ExtensionValueDate(_) -> "Date"
      ExtensionValueDatetime(_) -> "DateTime"
      ExtensionValueDecimal(_) -> "Decimal"
      ExtensionValueId(_) -> "Id"
      ExtensionValueInstant(_) -> "Instant"
      ExtensionValueInteger(_) -> "Integer"
      ExtensionValueMarkdown(_) -> "Markdown"
      ExtensionValueOid(_) -> "Oid"
      ExtensionValuePositiveint(_) -> "PositiveInt"
      ExtensionValueString(_) -> "String"
      ExtensionValueTime(_) -> "Time"
      ExtensionValueUnsignedint(_) -> "UnsignedInt"
      ExtensionValueUri(_) -> "Uri"
      ExtensionValueUrl(_) -> "Url"
      ExtensionValueUuid(_) -> "Uuid"
      ExtensionValueAddress(_) -> "Address"
      ExtensionValueAge(_) -> "Age"
      ExtensionValueAnnotation(_) -> "Annotation"
      ExtensionValueAttachment(_) -> "Attachment"
      ExtensionValueCodeableconcept(_) -> "CodeableConcept"
      ExtensionValueCoding(_) -> "Coding"
      ExtensionValueContactpoint(_) -> "ContactPoint"
      ExtensionValueCount(_) -> "Count"
      ExtensionValueDistance(_) -> "Distance"
      ExtensionValueDuration(_) -> "Duration"
      ExtensionValueHumanname(_) -> "HumanName"
      ExtensionValueIdentifier(_) -> "Identifier"
      ExtensionValueMoney(_) -> "Money"
      ExtensionValuePeriod(_) -> "Period"
      ExtensionValueQuantity(_) -> "Quantity"
      ExtensionValueRange(_) -> "Range"
      ExtensionValueRatio(_) -> "Ratio"
      ExtensionValueReference(_) -> "Reference"
      ExtensionValueSampleddata(_) -> "SampledData"
      ExtensionValueSignature(_) -> "Signature"
      ExtensionValueTiming(_) -> "Timing"
      ExtensionValueContactdetail(_) -> "ContactDetail"
      ExtensionValueContributor(_) -> "Contributor"
      ExtensionValueDatarequirement(_) -> "DataRequirement"
      ExtensionValueExpression(_) -> "Expression"
      ExtensionValueParameterdefinition(_) -> "ParameterDefinition"
      ExtensionValueRelatedartifact(_) -> "RelatedArtifact"
      ExtensionValueTriggerdefinition(_) -> "TriggerDefinition"
      ExtensionValueUsagecontext(_) -> "UsageContext"
      ExtensionValueDosage(_) -> "Dosage"
      ExtensionValueMeta(_) -> "Meta"
    },
    extension_value_to_json(v),
  )
}

pub fn extension_value_to_json(element: ExtensionValue) -> Json {
  case element {
    ExtensionValueBase64binary(v) -> json.string(v)
    ExtensionValueBoolean(v) -> json.bool(v)
    ExtensionValueCanonical(v) -> json.string(v)
    ExtensionValueCode(v) -> json.string(v)
    ExtensionValueDate(v) -> pt.date_to_json(v)
    ExtensionValueDatetime(v) -> pt.datetime_to_json(v)
    ExtensionValueDecimal(v) -> json.float(v)
    ExtensionValueId(v) -> json.string(v)
    ExtensionValueInstant(v) -> pt.instant_to_json(v)
    ExtensionValueInteger(v) -> json.int(v)
    ExtensionValueMarkdown(v) -> json.string(v)
    ExtensionValueOid(v) -> json.string(v)
    ExtensionValuePositiveint(v) -> json.int(v)
    ExtensionValueString(v) -> json.string(v)
    ExtensionValueTime(v) -> pt.time_to_json(v)
    ExtensionValueUnsignedint(v) -> json.int(v)
    ExtensionValueUri(v) -> json.string(v)
    ExtensionValueUrl(v) -> json.string(v)
    ExtensionValueUuid(v) -> json.string(v)
    ExtensionValueAddress(v) -> address_to_json(v)
    ExtensionValueAge(v) -> age_to_json(v)
    ExtensionValueAnnotation(v) -> annotation_to_json(v)
    ExtensionValueAttachment(v) -> attachment_to_json(v)
    ExtensionValueCodeableconcept(v) -> codeableconcept_to_json(v)
    ExtensionValueCoding(v) -> coding_to_json(v)
    ExtensionValueContactpoint(v) -> contactpoint_to_json(v)
    ExtensionValueCount(v) -> count_to_json(v)
    ExtensionValueDistance(v) -> distance_to_json(v)
    ExtensionValueDuration(v) -> duration_to_json(v)
    ExtensionValueHumanname(v) -> humanname_to_json(v)
    ExtensionValueIdentifier(v) -> identifier_to_json(v)
    ExtensionValueMoney(v) -> money_to_json(v)
    ExtensionValuePeriod(v) -> period_to_json(v)
    ExtensionValueQuantity(v) -> quantity_to_json(v)
    ExtensionValueRange(v) -> range_to_json(v)
    ExtensionValueRatio(v) -> ratio_to_json(v)
    ExtensionValueReference(v) -> reference_to_json(v)
    ExtensionValueSampleddata(v) -> sampleddata_to_json(v)
    ExtensionValueSignature(v) -> signature_to_json(v)
    ExtensionValueTiming(v) -> timing_to_json(v)
    ExtensionValueContactdetail(v) -> contactdetail_to_json(v)
    ExtensionValueContributor(v) -> contributor_to_json(v)
    ExtensionValueDatarequirement(v) -> datarequirement_to_json(v)
    ExtensionValueExpression(v) -> expression_to_json(v)
    ExtensionValueParameterdefinition(v) -> parameterdefinition_to_json(v)
    ExtensionValueRelatedartifact(v) -> relatedartifact_to_json(v)
    ExtensionValueTriggerdefinition(v) -> triggerdefinition_to_json(v)
    ExtensionValueUsagecontext(v) -> usagecontext_to_json(v)
    ExtensionValueDosage(v) -> dosage_to_json(v)
    ExtensionValueMeta(v) -> meta_to_json(v)
  }
}

pub fn extension_decoder() -> Decoder(Extension) {
  use url <- decode.field("url", decode.string)
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  use extension <- decode.then(extension_simple_or_complex_decoder())
  decode.success(Extension(url:, id:, extension:))
}

pub fn extension_simple_or_complex_decoder() -> Decoder(
  ExtensionSimpleOrComplex,
) {
  decode.one_of(
    decode.field("extension", decode.list(extension_decoder()), decode.success)
      |> decode.map(ExtensionComplex),
    [
      decode.field("valueBase64Binary", decode.string, decode.success)
        |> decode.map(ExtensionValueBase64binary)
        |> decode.map(ExtensionSimple),
      decode.field("valueBoolean", decode.bool, decode.success)
        |> decode.map(ExtensionValueBoolean)
        |> decode.map(ExtensionSimple),
      decode.field("valueCanonical", decode.string, decode.success)
        |> decode.map(ExtensionValueCanonical)
        |> decode.map(ExtensionSimple),
      decode.field("valueCode", decode.string, decode.success)
        |> decode.map(ExtensionValueCode)
        |> decode.map(ExtensionSimple),
      decode.field("valueDate", pt.date_decoder(), decode.success)
        |> decode.map(ExtensionValueDate)
        |> decode.map(ExtensionSimple),
      decode.field("valueDateTime", pt.datetime_decoder(), decode.success)
        |> decode.map(ExtensionValueDatetime)
        |> decode.map(ExtensionSimple),
      decode.field("valueDecimal", decode_number(), decode.success)
        |> decode.map(ExtensionValueDecimal)
        |> decode.map(ExtensionSimple),
      decode.field("valueId", decode.string, decode.success)
        |> decode.map(ExtensionValueId)
        |> decode.map(ExtensionSimple),
      decode.field("valueInstant", pt.instant_decoder(), decode.success)
        |> decode.map(ExtensionValueInstant)
        |> decode.map(ExtensionSimple),
      decode.field("valueInteger", decode.int, decode.success)
        |> decode.map(ExtensionValueInteger)
        |> decode.map(ExtensionSimple),
      decode.field("valueMarkdown", decode.string, decode.success)
        |> decode.map(ExtensionValueMarkdown)
        |> decode.map(ExtensionSimple),
      decode.field("valueOid", decode.string, decode.success)
        |> decode.map(ExtensionValueOid)
        |> decode.map(ExtensionSimple),
      decode.field("valuePositiveInt", decode.int, decode.success)
        |> decode.map(ExtensionValuePositiveint)
        |> decode.map(ExtensionSimple),
      decode.field("valueString", decode.string, decode.success)
        |> decode.map(ExtensionValueString)
        |> decode.map(ExtensionSimple),
      decode.field("valueTime", pt.time_decoder(), decode.success)
        |> decode.map(ExtensionValueTime)
        |> decode.map(ExtensionSimple),
      decode.field("valueUnsignedInt", decode.int, decode.success)
        |> decode.map(ExtensionValueUnsignedint)
        |> decode.map(ExtensionSimple),
      decode.field("valueUri", decode.string, decode.success)
        |> decode.map(ExtensionValueUri)
        |> decode.map(ExtensionSimple),
      decode.field("valueUrl", decode.string, decode.success)
        |> decode.map(ExtensionValueUrl)
        |> decode.map(ExtensionSimple),
      decode.field("valueUuid", decode.string, decode.success)
        |> decode.map(ExtensionValueUuid)
        |> decode.map(ExtensionSimple),
      decode.field("valueAddress", address_decoder(), decode.success)
        |> decode.map(ExtensionValueAddress)
        |> decode.map(ExtensionSimple),
      decode.field("valueAge", age_decoder(), decode.success)
        |> decode.map(ExtensionValueAge)
        |> decode.map(ExtensionSimple),
      decode.field("valueAnnotation", annotation_decoder(), decode.success)
        |> decode.map(ExtensionValueAnnotation)
        |> decode.map(ExtensionSimple),
      decode.field("valueAttachment", attachment_decoder(), decode.success)
        |> decode.map(ExtensionValueAttachment)
        |> decode.map(ExtensionSimple),
      decode.field(
        "valueCodeableConcept",
        codeableconcept_decoder(),
        decode.success,
      )
        |> decode.map(ExtensionValueCodeableconcept)
        |> decode.map(ExtensionSimple),
      decode.field("valueCoding", coding_decoder(), decode.success)
        |> decode.map(ExtensionValueCoding)
        |> decode.map(ExtensionSimple),
      decode.field("valueContactPoint", contactpoint_decoder(), decode.success)
        |> decode.map(ExtensionValueContactpoint)
        |> decode.map(ExtensionSimple),
      decode.field("valueCount", count_decoder(), decode.success)
        |> decode.map(ExtensionValueCount)
        |> decode.map(ExtensionSimple),
      decode.field("valueDistance", distance_decoder(), decode.success)
        |> decode.map(ExtensionValueDistance)
        |> decode.map(ExtensionSimple),
      decode.field("valueDuration", duration_decoder(), decode.success)
        |> decode.map(ExtensionValueDuration)
        |> decode.map(ExtensionSimple),
      decode.field("valueHumanName", humanname_decoder(), decode.success)
        |> decode.map(ExtensionValueHumanname)
        |> decode.map(ExtensionSimple),
      decode.field("valueIdentifier", identifier_decoder(), decode.success)
        |> decode.map(ExtensionValueIdentifier)
        |> decode.map(ExtensionSimple),
      decode.field("valueMoney", money_decoder(), decode.success)
        |> decode.map(ExtensionValueMoney)
        |> decode.map(ExtensionSimple),
      decode.field("valuePeriod", period_decoder(), decode.success)
        |> decode.map(ExtensionValuePeriod)
        |> decode.map(ExtensionSimple),
      decode.field("valueQuantity", quantity_decoder(), decode.success)
        |> decode.map(ExtensionValueQuantity)
        |> decode.map(ExtensionSimple),
      decode.field("valueRange", range_decoder(), decode.success)
        |> decode.map(ExtensionValueRange)
        |> decode.map(ExtensionSimple),
      decode.field("valueRatio", ratio_decoder(), decode.success)
        |> decode.map(ExtensionValueRatio)
        |> decode.map(ExtensionSimple),
      decode.field("valueReference", reference_decoder(), decode.success)
        |> decode.map(ExtensionValueReference)
        |> decode.map(ExtensionSimple),
      decode.field("valueSampledData", sampleddata_decoder(), decode.success)
        |> decode.map(ExtensionValueSampleddata)
        |> decode.map(ExtensionSimple),
      decode.field("valueSignature", signature_decoder(), decode.success)
        |> decode.map(ExtensionValueSignature)
        |> decode.map(ExtensionSimple),
      decode.field("valueTiming", timing_decoder(), decode.success)
        |> decode.map(ExtensionValueTiming)
        |> decode.map(ExtensionSimple),
      decode.field(
        "valueContactDetail",
        contactdetail_decoder(),
        decode.success,
      )
        |> decode.map(ExtensionValueContactdetail)
        |> decode.map(ExtensionSimple),
      decode.field("valueContributor", contributor_decoder(), decode.success)
        |> decode.map(ExtensionValueContributor)
        |> decode.map(ExtensionSimple),
      decode.field(
        "valueDataRequirement",
        datarequirement_decoder(),
        decode.success,
      )
        |> decode.map(ExtensionValueDatarequirement)
        |> decode.map(ExtensionSimple),
      decode.field("valueExpression", expression_decoder(), decode.success)
        |> decode.map(ExtensionValueExpression)
        |> decode.map(ExtensionSimple),
      decode.field(
        "valueParameterDefinition",
        parameterdefinition_decoder(),
        decode.success,
      )
        |> decode.map(ExtensionValueParameterdefinition)
        |> decode.map(ExtensionSimple),
      decode.field(
        "valueRelatedArtifact",
        relatedartifact_decoder(),
        decode.success,
      )
        |> decode.map(ExtensionValueRelatedartifact)
        |> decode.map(ExtensionSimple),
      decode.field(
        "valueTriggerDefinition",
        triggerdefinition_decoder(),
        decode.success,
      )
        |> decode.map(ExtensionValueTriggerdefinition)
        |> decode.map(ExtensionSimple),
      decode.field("valueUsageContext", usagecontext_decoder(), decode.success)
        |> decode.map(ExtensionValueUsagecontext)
        |> decode.map(ExtensionSimple),
      decode.field("valueDosage", dosage_decoder(), decode.success)
        |> decode.map(ExtensionValueDosage)
        |> decode.map(ExtensionSimple),
      decode.field("valueMeta", meta_decoder(), decode.success)
        |> decode.map(ExtensionValueMeta)
        |> decode.map(ExtensionSimple),
    ],
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/HumanName#resource](http://hl7.org/fhir/r4/StructureDefinition/HumanName#resource)
pub type Humanname {
  Humanname(
    id: Option(String),
    extension: List(Extension),
    use_: Option(valueset.NameUse),
    text: Option(String),
    family: Option(String),
    given: List(String),
    prefix: List(String),
    suffix: List(String),
    period: Option(Period),
  )
}

pub fn humanname_new() -> Humanname {
  Humanname(
    period: None,
    suffix: [],
    prefix: [],
    given: [],
    family: None,
    text: None,
    use_: None,
    extension: [],
    id: None,
  )
}

pub fn humanname_to_json(humanname: Humanname) -> Json {
  let fields = []
  let fields = case humanname.period {
    Some(v) -> [#("period", period_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case humanname.suffix {
    [] -> fields
    _ -> [#("suffix", json.array(humanname.suffix, json.string)), ..fields]
  }
  let fields = case humanname.prefix {
    [] -> fields
    _ -> [#("prefix", json.array(humanname.prefix, json.string)), ..fields]
  }
  let fields = case humanname.given {
    [] -> fields
    _ -> [#("given", json.array(humanname.given, json.string)), ..fields]
  }
  let fields = case humanname.family {
    Some(v) -> [#("family", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case humanname.text {
    Some(v) -> [#("text", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case humanname.use_ {
    Some(v) -> [#("use", valueset.name_use_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case humanname.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(humanname.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case humanname.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn humanname_decoder() -> Decoder(Humanname) {
  use <- decode.recursive
  use period <- decode.optional_field(
    "period",
    None,
    decode.optional(period_decoder()),
  )
  use suffix <- decode.optional_field("suffix", [], decode.list(decode.string))
  use prefix <- decode.optional_field("prefix", [], decode.list(decode.string))
  use given <- decode.optional_field("given", [], decode.list(decode.string))
  use family <- decode.optional_field(
    "family",
    None,
    decode.optional(decode.string),
  )
  use text <- decode.optional_field(
    "text",
    None,
    decode.optional(decode.string),
  )
  use use_ <- decode.optional_field(
    "use",
    None,
    decode.optional(valueset.name_use_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Humanname(
    period:,
    suffix:,
    prefix:,
    given:,
    family:,
    text:,
    use_:,
    extension:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4/StructureDefinition/Identifier#resource](http://hl7.org/fhir/r4/StructureDefinition/Identifier#resource)
pub type Identifier {
  Identifier(
    id: Option(String),
    extension: List(Extension),
    use_: Option(valueset.IdentifierUse),
    type_: Option(Codeableconcept),
    system: Option(String),
    value: Option(String),
    period: Option(Period),
    assigner: Option(Reference),
  )
}

pub fn identifier_new() -> Identifier {
  Identifier(
    assigner: None,
    period: None,
    value: None,
    system: None,
    type_: None,
    use_: None,
    extension: [],
    id: None,
  )
}

pub fn identifier_to_json(identifier: Identifier) -> Json {
  let fields = []
  let fields = case identifier.assigner {
    Some(v) -> [#("assigner", reference_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case identifier.period {
    Some(v) -> [#("period", period_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case identifier.value {
    Some(v) -> [#("value", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case identifier.system {
    Some(v) -> [#("system", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case identifier.type_ {
    Some(v) -> [#("type", codeableconcept_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case identifier.use_ {
    Some(v) -> [#("use", valueset.identifier_use_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case identifier.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(identifier.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case identifier.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn identifier_decoder() -> Decoder(Identifier) {
  use <- decode.recursive
  use assigner <- decode.optional_field(
    "assigner",
    None,
    decode.optional(reference_decoder()),
  )
  use period <- decode.optional_field(
    "period",
    None,
    decode.optional(period_decoder()),
  )
  use value <- decode.optional_field(
    "value",
    None,
    decode.optional(decode.string),
  )
  use system <- decode.optional_field(
    "system",
    None,
    decode.optional(decode.string),
  )
  use type_ <- decode.optional_field(
    "type",
    None,
    decode.optional(codeableconcept_decoder()),
  )
  use use_ <- decode.optional_field(
    "use",
    None,
    decode.optional(valueset.identifier_use_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Identifier(
    assigner:,
    period:,
    value:,
    system:,
    type_:,
    use_:,
    extension:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4/StructureDefinition/Meta#resource](http://hl7.org/fhir/r4/StructureDefinition/Meta#resource)
pub type Meta {
  Meta(
    id: Option(String),
    extension: List(Extension),
    version_id: Option(String),
    last_updated: Option(Instant),
    source: Option(String),
    profile: List(String),
    security: List(Coding),
    tag: List(Coding),
  )
}

pub fn meta_new() -> Meta {
  Meta(
    tag: [],
    security: [],
    profile: [],
    source: None,
    last_updated: None,
    version_id: None,
    extension: [],
    id: None,
  )
}

pub fn meta_to_json(meta: Meta) -> Json {
  let fields = []
  let fields = case meta.tag {
    [] -> fields
    _ -> [#("tag", json.array(meta.tag, coding_to_json)), ..fields]
  }
  let fields = case meta.security {
    [] -> fields
    _ -> [#("security", json.array(meta.security, coding_to_json)), ..fields]
  }
  let fields = case meta.profile {
    [] -> fields
    _ -> [#("profile", json.array(meta.profile, json.string)), ..fields]
  }
  let fields = case meta.source {
    Some(v) -> [#("source", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case meta.last_updated {
    Some(v) -> [#("lastUpdated", pt.instant_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case meta.version_id {
    Some(v) -> [#("versionId", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case meta.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(meta.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case meta.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn meta_decoder() -> Decoder(Meta) {
  use <- decode.recursive
  use tag <- decode.optional_field("tag", [], decode.list(coding_decoder()))
  use security <- decode.optional_field(
    "security",
    [],
    decode.list(coding_decoder()),
  )
  use profile <- decode.optional_field(
    "profile",
    [],
    decode.list(decode.string),
  )
  use source <- decode.optional_field(
    "source",
    None,
    decode.optional(decode.string),
  )
  use last_updated <- decode.optional_field(
    "lastUpdated",
    None,
    decode.optional(pt.instant_decoder()),
  )
  use version_id <- decode.optional_field(
    "versionId",
    None,
    decode.optional(decode.string),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Meta(
    tag:,
    security:,
    profile:,
    source:,
    last_updated:,
    version_id:,
    extension:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4/StructureDefinition/Money#resource](http://hl7.org/fhir/r4/StructureDefinition/Money#resource)
pub type Money {
  Money(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    currency: Option(valueset.Currencies),
  )
}

pub fn money_new() -> Money {
  Money(currency: None, value: None, extension: [], id: None)
}

pub fn money_to_json(money: Money) -> Json {
  let fields = []
  let fields = case money.currency {
    Some(v) -> [#("currency", valueset.currencies_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case money.value {
    Some(v) -> [#("value", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case money.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(money.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case money.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn money_decoder() -> Decoder(Money) {
  use <- decode.recursive
  use currency <- decode.optional_field(
    "currency",
    None,
    decode.optional(valueset.currencies_decoder()),
  )
  use value <- decode.optional_field(
    "value",
    None,
    decode.optional(decode_number()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Money(currency:, value:, extension:, id:))
}

///[http://hl7.org/fhir/r4/StructureDefinition/Narrative#resource](http://hl7.org/fhir/r4/StructureDefinition/Narrative#resource)
pub type Narrative {
  Narrative(
    id: Option(String),
    extension: List(Extension),
    status: valueset.NarrativeStatus,
    div: String,
  )
}

pub fn narrative_new(
  div div: String,
  status status: valueset.NarrativeStatus,
) -> Narrative {
  Narrative(div:, status:, extension: [], id: None)
}

pub fn narrative_to_json(narrative: Narrative) -> Json {
  let fields = [
    #("div", json.string(narrative.div)),
    #("status", valueset.narrative_status_to_json(narrative.status)),
  ]
  let fields = case narrative.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(narrative.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case narrative.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn narrative_decoder() -> Decoder(Narrative) {
  use <- decode.recursive
  use div <- decode.field("div", decode.string)
  use status <- decode.field("status", valueset.narrative_status_decoder())
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Narrative(div:, status:, extension:, id:))
}

///[http://hl7.org/fhir/r4/StructureDefinition/ParameterDefinition#resource](http://hl7.org/fhir/r4/StructureDefinition/ParameterDefinition#resource)
pub type Parameterdefinition {
  Parameterdefinition(
    id: Option(String),
    extension: List(Extension),
    name: Option(String),
    use_: valueset.OperationParameterUse,
    min: Option(Int),
    max: Option(String),
    documentation: Option(String),
    type_: valueset.AllTypes,
    profile: Option(String),
  )
}

pub fn parameterdefinition_new(
  type_ type_: valueset.AllTypes,
  use_ use_: valueset.OperationParameterUse,
) -> Parameterdefinition {
  Parameterdefinition(
    profile: None,
    type_:,
    documentation: None,
    max: None,
    min: None,
    use_:,
    name: None,
    extension: [],
    id: None,
  )
}

pub fn parameterdefinition_to_json(
  parameterdefinition: Parameterdefinition,
) -> Json {
  let fields = [
    #("type", valueset.all_types_to_json(parameterdefinition.type_)),
    #("use", valueset.operation_parameter_use_to_json(parameterdefinition.use_)),
  ]
  let fields = case parameterdefinition.profile {
    Some(v) -> [#("profile", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case parameterdefinition.documentation {
    Some(v) -> [#("documentation", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case parameterdefinition.max {
    Some(v) -> [#("max", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case parameterdefinition.min {
    Some(v) -> [#("min", json.int(v)), ..fields]
    None -> fields
  }
  let fields = case parameterdefinition.name {
    Some(v) -> [#("name", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case parameterdefinition.extension {
    [] -> fields
    _ -> [
      #(
        "extension",
        json.array(parameterdefinition.extension, extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case parameterdefinition.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn parameterdefinition_decoder() -> Decoder(Parameterdefinition) {
  use <- decode.recursive
  use profile <- decode.optional_field(
    "profile",
    None,
    decode.optional(decode.string),
  )
  use type_ <- decode.field("type", valueset.all_types_decoder())
  use documentation <- decode.optional_field(
    "documentation",
    None,
    decode.optional(decode.string),
  )
  use max <- decode.optional_field("max", None, decode.optional(decode.string))
  use min <- decode.optional_field("min", None, decode.optional(decode.int))
  use use_ <- decode.field("use", valueset.operation_parameter_use_decoder())
  use name <- decode.optional_field(
    "name",
    None,
    decode.optional(decode.string),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Parameterdefinition(
    profile:,
    type_:,
    documentation:,
    max:,
    min:,
    use_:,
    name:,
    extension:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4/StructureDefinition/Period#resource](http://hl7.org/fhir/r4/StructureDefinition/Period#resource)
pub type Period {
  Period(
    id: Option(String),
    extension: List(Extension),
    start: Option(DateTime),
    end: Option(DateTime),
  )
}

pub fn period_new() -> Period {
  Period(end: None, start: None, extension: [], id: None)
}

pub fn period_to_json(period: Period) -> Json {
  let fields = []
  let fields = case period.end {
    Some(v) -> [#("end", pt.datetime_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case period.start {
    Some(v) -> [#("start", pt.datetime_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case period.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(period.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case period.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn period_decoder() -> Decoder(Period) {
  use <- decode.recursive
  use end <- decode.optional_field(
    "end",
    None,
    decode.optional(pt.datetime_decoder()),
  )
  use start <- decode.optional_field(
    "start",
    None,
    decode.optional(pt.datetime_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Period(end:, start:, extension:, id:))
}

///[http://hl7.org/fhir/r4/StructureDefinition/Quantity#resource](http://hl7.org/fhir/r4/StructureDefinition/Quantity#resource)
pub type Quantity {
  Quantity(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(valueset.QuantityComparator),
    unit: Option(String),
    system: Option(String),
    code: Option(String),
  )
}

pub fn quantity_new() -> Quantity {
  Quantity(
    code: None,
    system: None,
    unit: None,
    comparator: None,
    value: None,
    extension: [],
    id: None,
  )
}

pub fn quantity_to_json(quantity: Quantity) -> Json {
  let fields = []
  let fields = case quantity.code {
    Some(v) -> [#("code", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case quantity.system {
    Some(v) -> [#("system", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case quantity.unit {
    Some(v) -> [#("unit", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case quantity.comparator {
    Some(v) -> [
      #("comparator", valueset.quantity_comparator_to_json(v)),
      ..fields
    ]
    None -> fields
  }
  let fields = case quantity.value {
    Some(v) -> [#("value", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case quantity.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(quantity.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case quantity.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn quantity_decoder() -> Decoder(Quantity) {
  use <- decode.recursive
  use code <- decode.optional_field(
    "code",
    None,
    decode.optional(decode.string),
  )
  use system <- decode.optional_field(
    "system",
    None,
    decode.optional(decode.string),
  )
  use unit <- decode.optional_field(
    "unit",
    None,
    decode.optional(decode.string),
  )
  use comparator <- decode.optional_field(
    "comparator",
    None,
    decode.optional(valueset.quantity_comparator_decoder()),
  )
  use value <- decode.optional_field(
    "value",
    None,
    decode.optional(decode_number()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Quantity(
    code:,
    system:,
    unit:,
    comparator:,
    value:,
    extension:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4/StructureDefinition/Range#resource](http://hl7.org/fhir/r4/StructureDefinition/Range#resource)
pub type Range {
  Range(
    id: Option(String),
    extension: List(Extension),
    low: Option(Quantity),
    high: Option(Quantity),
  )
}

pub fn range_new() -> Range {
  Range(high: None, low: None, extension: [], id: None)
}

pub fn range_to_json(range: Range) -> Json {
  let fields = []
  let fields = case range.high {
    Some(v) -> [#("high", quantity_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case range.low {
    Some(v) -> [#("low", quantity_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case range.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(range.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case range.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn range_decoder() -> Decoder(Range) {
  use <- decode.recursive
  use high <- decode.optional_field(
    "high",
    None,
    decode.optional(quantity_decoder()),
  )
  use low <- decode.optional_field(
    "low",
    None,
    decode.optional(quantity_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Range(high:, low:, extension:, id:))
}

///[http://hl7.org/fhir/r4/StructureDefinition/Ratio#resource](http://hl7.org/fhir/r4/StructureDefinition/Ratio#resource)
pub type Ratio {
  Ratio(
    id: Option(String),
    extension: List(Extension),
    numerator: Option(Quantity),
    denominator: Option(Quantity),
  )
}

pub fn ratio_new() -> Ratio {
  Ratio(denominator: None, numerator: None, extension: [], id: None)
}

pub fn ratio_to_json(ratio: Ratio) -> Json {
  let fields = []
  let fields = case ratio.denominator {
    Some(v) -> [#("denominator", quantity_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case ratio.numerator {
    Some(v) -> [#("numerator", quantity_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case ratio.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(ratio.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case ratio.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn ratio_decoder() -> Decoder(Ratio) {
  use <- decode.recursive
  use denominator <- decode.optional_field(
    "denominator",
    None,
    decode.optional(quantity_decoder()),
  )
  use numerator <- decode.optional_field(
    "numerator",
    None,
    decode.optional(quantity_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Ratio(denominator:, numerator:, extension:, id:))
}

///[http://hl7.org/fhir/r4/StructureDefinition/Reference#resource](http://hl7.org/fhir/r4/StructureDefinition/Reference#resource)
pub type Reference {
  Reference(
    id: Option(String),
    extension: List(Extension),
    reference: Option(String),
    type_: Option(String),
    identifier: Option(Identifier),
    display: Option(String),
  )
}

pub fn reference_new() -> Reference {
  Reference(
    display: None,
    identifier: None,
    type_: None,
    reference: None,
    extension: [],
    id: None,
  )
}

pub fn reference_to_json(reference: Reference) -> Json {
  let fields = []
  let fields = case reference.display {
    Some(v) -> [#("display", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case reference.identifier {
    Some(v) -> [#("identifier", identifier_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case reference.type_ {
    Some(v) -> [#("type", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case reference.reference {
    Some(v) -> [#("reference", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case reference.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(reference.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case reference.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn reference_decoder() -> Decoder(Reference) {
  use <- decode.recursive
  use display <- decode.optional_field(
    "display",
    None,
    decode.optional(decode.string),
  )
  use identifier <- decode.optional_field(
    "identifier",
    None,
    decode.optional(identifier_decoder()),
  )
  use type_ <- decode.optional_field(
    "type",
    None,
    decode.optional(decode.string),
  )
  use reference <- decode.optional_field(
    "reference",
    None,
    decode.optional(decode.string),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Reference(
    display:,
    identifier:,
    type_:,
    reference:,
    extension:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4/StructureDefinition/RelatedArtifact#resource](http://hl7.org/fhir/r4/StructureDefinition/RelatedArtifact#resource)
pub type Relatedartifact {
  Relatedartifact(
    id: Option(String),
    extension: List(Extension),
    type_: valueset.RelatedartifactType,
    label: Option(String),
    display: Option(String),
    citation: Option(String),
    url: Option(String),
    document: Option(Attachment),
    resource: Option(String),
  )
}

pub fn relatedartifact_new(
  type_ type_: valueset.RelatedartifactType,
) -> Relatedartifact {
  Relatedartifact(
    resource: None,
    document: None,
    url: None,
    citation: None,
    display: None,
    label: None,
    type_:,
    extension: [],
    id: None,
  )
}

pub fn relatedartifact_to_json(relatedartifact: Relatedartifact) -> Json {
  let fields = [
    #("type", valueset.relatedartifact_type_to_json(relatedartifact.type_)),
  ]
  let fields = case relatedartifact.resource {
    Some(v) -> [#("resource", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case relatedartifact.document {
    Some(v) -> [#("document", attachment_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case relatedartifact.url {
    Some(v) -> [#("url", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case relatedartifact.citation {
    Some(v) -> [#("citation", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case relatedartifact.display {
    Some(v) -> [#("display", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case relatedartifact.label {
    Some(v) -> [#("label", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case relatedartifact.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(relatedartifact.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case relatedartifact.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn relatedartifact_decoder() -> Decoder(Relatedartifact) {
  use <- decode.recursive
  use resource <- decode.optional_field(
    "resource",
    None,
    decode.optional(decode.string),
  )
  use document <- decode.optional_field(
    "document",
    None,
    decode.optional(attachment_decoder()),
  )
  use url <- decode.optional_field("url", None, decode.optional(decode.string))
  use citation <- decode.optional_field(
    "citation",
    None,
    decode.optional(decode.string),
  )
  use display <- decode.optional_field(
    "display",
    None,
    decode.optional(decode.string),
  )
  use label <- decode.optional_field(
    "label",
    None,
    decode.optional(decode.string),
  )
  use type_ <- decode.field("type", valueset.relatedartifact_type_decoder())
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Relatedartifact(
    resource:,
    document:,
    url:,
    citation:,
    display:,
    label:,
    type_:,
    extension:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4/StructureDefinition/SampledData#resource](http://hl7.org/fhir/r4/StructureDefinition/SampledData#resource)
pub type Sampleddata {
  Sampleddata(
    id: Option(String),
    extension: List(Extension),
    origin: Quantity,
    period: Float,
    factor: Option(Float),
    lower_limit: Option(Float),
    upper_limit: Option(Float),
    dimensions: Int,
    data: Option(String),
  )
}

pub fn sampleddata_new(
  dimensions dimensions: Int,
  period period: Float,
  origin origin: Quantity,
) -> Sampleddata {
  Sampleddata(
    data: None,
    dimensions:,
    upper_limit: None,
    lower_limit: None,
    factor: None,
    period:,
    origin:,
    extension: [],
    id: None,
  )
}

pub fn sampleddata_to_json(sampleddata: Sampleddata) -> Json {
  let fields = [
    #("dimensions", json.int(sampleddata.dimensions)),
    #("period", json.float(sampleddata.period)),
    #("origin", quantity_to_json(sampleddata.origin)),
  ]
  let fields = case sampleddata.data {
    Some(v) -> [#("data", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case sampleddata.upper_limit {
    Some(v) -> [#("upperLimit", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case sampleddata.lower_limit {
    Some(v) -> [#("lowerLimit", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case sampleddata.factor {
    Some(v) -> [#("factor", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case sampleddata.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(sampleddata.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case sampleddata.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn sampleddata_decoder() -> Decoder(Sampleddata) {
  use <- decode.recursive
  use data <- decode.optional_field(
    "data",
    None,
    decode.optional(decode.string),
  )
  use dimensions <- decode.field("dimensions", decode.int)
  use upper_limit <- decode.optional_field(
    "upperLimit",
    None,
    decode.optional(decode_number()),
  )
  use lower_limit <- decode.optional_field(
    "lowerLimit",
    None,
    decode.optional(decode_number()),
  )
  use factor <- decode.optional_field(
    "factor",
    None,
    decode.optional(decode_number()),
  )
  use period <- decode.field("period", decode_number())
  use origin <- decode.field("origin", quantity_decoder())
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Sampleddata(
    data:,
    dimensions:,
    upper_limit:,
    lower_limit:,
    factor:,
    period:,
    origin:,
    extension:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4/StructureDefinition/Signature#resource](http://hl7.org/fhir/r4/StructureDefinition/Signature#resource)
pub type Signature {
  Signature(
    id: Option(String),
    extension: List(Extension),
    type_: List1(Coding),
    when: Instant,
    who: Reference,
    on_behalf_of: Option(Reference),
    target_format: Option(String),
    sig_format: Option(String),
    data: Option(String),
  )
}

pub fn signature_new(
  who who: Reference,
  when when: Instant,
  type_ type_: List1(Coding),
) -> Signature {
  Signature(
    data: None,
    sig_format: None,
    target_format: None,
    on_behalf_of: None,
    who:,
    when:,
    type_:,
    extension: [],
    id: None,
  )
}

pub fn signature_to_json(signature: Signature) -> Json {
  let fields = [
    #("who", reference_to_json(signature.who)),
    #("when", pt.instant_to_json(signature.when)),
    #("type", list1_to_json(signature.type_, coding_to_json)),
  ]
  let fields = case signature.data {
    Some(v) -> [#("data", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case signature.sig_format {
    Some(v) -> [#("sigFormat", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case signature.target_format {
    Some(v) -> [#("targetFormat", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case signature.on_behalf_of {
    Some(v) -> [#("onBehalfOf", reference_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case signature.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(signature.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case signature.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn signature_decoder() -> Decoder(Signature) {
  use <- decode.recursive
  use data <- decode.optional_field(
    "data",
    None,
    decode.optional(decode.string),
  )
  use sig_format <- decode.optional_field(
    "sigFormat",
    None,
    decode.optional(decode.string),
  )
  use target_format <- decode.optional_field(
    "targetFormat",
    None,
    decode.optional(decode.string),
  )
  use on_behalf_of <- decode.optional_field(
    "onBehalfOf",
    None,
    decode.optional(reference_decoder()),
  )
  use who <- decode.field("who", reference_decoder())
  use when <- decode.field("when", pt.instant_decoder())
  use type_ <- list1_decoder("type", coding_decoder())
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Signature(
    data:,
    sig_format:,
    target_format:,
    on_behalf_of:,
    who:,
    when:,
    type_:,
    extension:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4/StructureDefinition/Timing#resource](http://hl7.org/fhir/r4/StructureDefinition/Timing#resource)
pub type Timing {
  Timing(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    event: List(DateTime),
    repeat: Option(TimingRepeat),
    code: Option(Codeableconcept),
  )
}

pub fn timing_new() -> Timing {
  Timing(
    code: None,
    repeat: None,
    event: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/Timing#resource](http://hl7.org/fhir/r4/StructureDefinition/Timing#resource)
pub type TimingRepeat {
  TimingRepeat(
    id: Option(String),
    extension: List(Extension),
    bounds: Option(TimingRepeatBounds),
    count: Option(Int),
    count_max: Option(Int),
    duration: Option(Float),
    duration_max: Option(Float),
    duration_unit: Option(valueset.UnitsOfTime),
    frequency: Option(Int),
    frequency_max: Option(Int),
    period: Option(Float),
    period_max: Option(Float),
    period_unit: Option(valueset.UnitsOfTime),
    day_of_week: List(valueset.DaysOfWeek),
    time_of_day: List(Time),
    when: List(valueset.EventTiming),
    offset: Option(Int),
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/Timing#resource](http://hl7.org/fhir/r4/StructureDefinition/Timing#resource)
pub type TimingRepeatBounds {
  TimingRepeatBoundsDuration(bounds: Duration)
  TimingRepeatBoundsRange(bounds: Range)
  TimingRepeatBoundsPeriod(bounds: Period)
}

pub fn timing_repeat_bounds_to_json(element: TimingRepeatBounds) -> Json {
  case element {
    TimingRepeatBoundsDuration(v) -> duration_to_json(v)
    TimingRepeatBoundsRange(v) -> range_to_json(v)
    TimingRepeatBoundsPeriod(v) -> period_to_json(v)
  }
}

pub fn timing_repeat_bounds_decoder() -> Decoder(TimingRepeatBounds) {
  decode.one_of(
    decode.field("boundsDuration", duration_decoder(), decode.success)
      |> decode.map(TimingRepeatBoundsDuration),
    [
      decode.field("boundsRange", range_decoder(), decode.success)
        |> decode.map(TimingRepeatBoundsRange),
      decode.field("boundsPeriod", period_decoder(), decode.success)
        |> decode.map(TimingRepeatBoundsPeriod),
    ],
  )
}

pub fn timing_repeat_new() -> TimingRepeat {
  TimingRepeat(
    offset: None,
    when: [],
    time_of_day: [],
    day_of_week: [],
    period_unit: None,
    period_max: None,
    period: None,
    frequency_max: None,
    frequency: None,
    duration_unit: None,
    duration_max: None,
    duration: None,
    count_max: None,
    count: None,
    bounds: None,
    extension: [],
    id: None,
  )
}

pub fn timing_repeat_to_json(timing_repeat: TimingRepeat) -> Json {
  let fields = []
  let fields = case timing_repeat.offset {
    Some(v) -> [#("offset", json.int(v)), ..fields]
    None -> fields
  }
  let fields = case timing_repeat.when {
    [] -> fields
    _ -> [
      #("when", json.array(timing_repeat.when, valueset.event_timing_to_json)),
      ..fields
    ]
  }
  let fields = case timing_repeat.time_of_day {
    [] -> fields
    _ -> [
      #("timeOfDay", json.array(timing_repeat.time_of_day, pt.time_to_json)),
      ..fields
    ]
  }
  let fields = case timing_repeat.day_of_week {
    [] -> fields
    _ -> [
      #(
        "dayOfWeek",
        json.array(timing_repeat.day_of_week, valueset.days_of_week_to_json),
      ),
      ..fields
    ]
  }
  let fields = case timing_repeat.period_unit {
    Some(v) -> [#("periodUnit", valueset.units_of_time_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case timing_repeat.period_max {
    Some(v) -> [#("periodMax", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case timing_repeat.period {
    Some(v) -> [#("period", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case timing_repeat.frequency_max {
    Some(v) -> [#("frequencyMax", json.int(v)), ..fields]
    None -> fields
  }
  let fields = case timing_repeat.frequency {
    Some(v) -> [#("frequency", json.int(v)), ..fields]
    None -> fields
  }
  let fields = case timing_repeat.duration_unit {
    Some(v) -> [#("durationUnit", valueset.units_of_time_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case timing_repeat.duration_max {
    Some(v) -> [#("durationMax", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case timing_repeat.duration {
    Some(v) -> [#("duration", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case timing_repeat.count_max {
    Some(v) -> [#("countMax", json.int(v)), ..fields]
    None -> fields
  }
  let fields = case timing_repeat.count {
    Some(v) -> [#("count", json.int(v)), ..fields]
    None -> fields
  }
  let fields = case timing_repeat.bounds {
    Some(v) -> [
      #(
        "bounds"
          <> case v {
          TimingRepeatBoundsDuration(_) -> "Duration"
          TimingRepeatBoundsRange(_) -> "Range"
          TimingRepeatBoundsPeriod(_) -> "Period"
        },
        timing_repeat_bounds_to_json(v),
      ),
      ..fields
    ]
    None -> fields
  }
  let fields = case timing_repeat.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(timing_repeat.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case timing_repeat.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn timing_repeat_decoder() -> Decoder(TimingRepeat) {
  use <- decode.recursive
  use offset <- decode.optional_field(
    "offset",
    None,
    decode.optional(decode.int),
  )
  use when <- decode.optional_field(
    "when",
    [],
    decode.list(valueset.event_timing_decoder()),
  )
  use time_of_day <- decode.optional_field(
    "timeOfDay",
    [],
    decode.list(pt.time_decoder()),
  )
  use day_of_week <- decode.optional_field(
    "dayOfWeek",
    [],
    decode.list(valueset.days_of_week_decoder()),
  )
  use period_unit <- decode.optional_field(
    "periodUnit",
    None,
    decode.optional(valueset.units_of_time_decoder()),
  )
  use period_max <- decode.optional_field(
    "periodMax",
    None,
    decode.optional(decode_number()),
  )
  use period <- decode.optional_field(
    "period",
    None,
    decode.optional(decode_number()),
  )
  use frequency_max <- decode.optional_field(
    "frequencyMax",
    None,
    decode.optional(decode.int),
  )
  use frequency <- decode.optional_field(
    "frequency",
    None,
    decode.optional(decode.int),
  )
  use duration_unit <- decode.optional_field(
    "durationUnit",
    None,
    decode.optional(valueset.units_of_time_decoder()),
  )
  use duration_max <- decode.optional_field(
    "durationMax",
    None,
    decode.optional(decode_number()),
  )
  use duration <- decode.optional_field(
    "duration",
    None,
    decode.optional(decode_number()),
  )
  use count_max <- decode.optional_field(
    "countMax",
    None,
    decode.optional(decode.int),
  )
  use count <- decode.optional_field("count", None, decode.optional(decode.int))
  use bounds <- decode.then(none_if_omitted(timing_repeat_bounds_decoder()))
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(TimingRepeat(
    offset:,
    when:,
    time_of_day:,
    day_of_week:,
    period_unit:,
    period_max:,
    period:,
    frequency_max:,
    frequency:,
    duration_unit:,
    duration_max:,
    duration:,
    count_max:,
    count:,
    bounds:,
    extension:,
    id:,
  ))
}

pub fn timing_to_json(timing: Timing) -> Json {
  let fields = []
  let fields = case timing.code {
    Some(v) -> [#("code", codeableconcept_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case timing.repeat {
    Some(v) -> [#("repeat", timing_repeat_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case timing.event {
    [] -> fields
    _ -> [#("event", json.array(timing.event, pt.datetime_to_json)), ..fields]
  }
  let fields = case timing.modifier_extension {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(timing.modifier_extension, extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case timing.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(timing.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case timing.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn timing_decoder() -> Decoder(Timing) {
  use <- decode.recursive
  use code <- decode.optional_field(
    "code",
    None,
    decode.optional(codeableconcept_decoder()),
  )
  use repeat <- decode.optional_field(
    "repeat",
    None,
    decode.optional(timing_repeat_decoder()),
  )
  use event <- decode.optional_field(
    "event",
    [],
    decode.list(pt.datetime_decoder()),
  )
  use modifier_extension <- decode.optional_field(
    "modifierExtension",
    [],
    decode.list(extension_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Timing(
    code:,
    repeat:,
    event:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4/StructureDefinition/TriggerDefinition#resource](http://hl7.org/fhir/r4/StructureDefinition/TriggerDefinition#resource)
pub type Triggerdefinition {
  Triggerdefinition(
    id: Option(String),
    extension: List(Extension),
    type_: valueset.TriggerType,
    name: Option(String),
    timing: Option(TriggerdefinitionTiming),
    data: List(Datarequirement),
    condition: Option(Expression),
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/TriggerDefinition#resource](http://hl7.org/fhir/r4/StructureDefinition/TriggerDefinition#resource)
pub type TriggerdefinitionTiming {
  TriggerdefinitionTimingTiming(timing: Timing)
  TriggerdefinitionTimingReference(timing: Reference)
  TriggerdefinitionTimingDate(timing: Date)
  TriggerdefinitionTimingDatetime(timing: DateTime)
}

pub fn triggerdefinition_timing_to_json(
  element: TriggerdefinitionTiming,
) -> Json {
  case element {
    TriggerdefinitionTimingTiming(v) -> timing_to_json(v)
    TriggerdefinitionTimingReference(v) -> reference_to_json(v)
    TriggerdefinitionTimingDate(v) -> pt.date_to_json(v)
    TriggerdefinitionTimingDatetime(v) -> pt.datetime_to_json(v)
  }
}

pub fn triggerdefinition_timing_decoder() -> Decoder(TriggerdefinitionTiming) {
  decode.one_of(
    decode.field("timingTiming", timing_decoder(), decode.success)
      |> decode.map(TriggerdefinitionTimingTiming),
    [
      decode.field("timingReference", reference_decoder(), decode.success)
        |> decode.map(TriggerdefinitionTimingReference),
      decode.field("timingDate", pt.date_decoder(), decode.success)
        |> decode.map(TriggerdefinitionTimingDate),
      decode.field("timingDateTime", pt.datetime_decoder(), decode.success)
        |> decode.map(TriggerdefinitionTimingDatetime),
    ],
  )
}

pub fn triggerdefinition_new(
  type_ type_: valueset.TriggerType,
) -> Triggerdefinition {
  Triggerdefinition(
    condition: None,
    data: [],
    timing: None,
    name: None,
    type_:,
    extension: [],
    id: None,
  )
}

pub fn triggerdefinition_to_json(triggerdefinition: Triggerdefinition) -> Json {
  let fields = [
    #("type", valueset.trigger_type_to_json(triggerdefinition.type_)),
  ]
  let fields = case triggerdefinition.condition {
    Some(v) -> [#("condition", expression_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case triggerdefinition.data {
    [] -> fields
    _ -> [
      #("data", json.array(triggerdefinition.data, datarequirement_to_json)),
      ..fields
    ]
  }
  let fields = case triggerdefinition.timing {
    Some(v) -> [
      #(
        "timing"
          <> case v {
          TriggerdefinitionTimingTiming(_) -> "Timing"
          TriggerdefinitionTimingReference(_) -> "Reference"
          TriggerdefinitionTimingDate(_) -> "Date"
          TriggerdefinitionTimingDatetime(_) -> "DateTime"
        },
        triggerdefinition_timing_to_json(v),
      ),
      ..fields
    ]
    None -> fields
  }
  let fields = case triggerdefinition.name {
    Some(v) -> [#("name", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case triggerdefinition.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(triggerdefinition.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case triggerdefinition.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn triggerdefinition_decoder() -> Decoder(Triggerdefinition) {
  use <- decode.recursive
  use condition <- decode.optional_field(
    "condition",
    None,
    decode.optional(expression_decoder()),
  )
  use data <- decode.optional_field(
    "data",
    [],
    decode.list(datarequirement_decoder()),
  )
  use timing <- decode.then(none_if_omitted(triggerdefinition_timing_decoder()))
  use name <- decode.optional_field(
    "name",
    None,
    decode.optional(decode.string),
  )
  use type_ <- decode.field("type", valueset.trigger_type_decoder())
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Triggerdefinition(
    condition:,
    data:,
    timing:,
    name:,
    type_:,
    extension:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4/StructureDefinition/UsageContext#resource](http://hl7.org/fhir/r4/StructureDefinition/UsageContext#resource)
pub type Usagecontext {
  Usagecontext(
    id: Option(String),
    extension: List(Extension),
    code: Coding,
    value: UsagecontextValue,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/UsageContext#resource](http://hl7.org/fhir/r4/StructureDefinition/UsageContext#resource)
pub type UsagecontextValue {
  UsagecontextValueCodeableconcept(value: Codeableconcept)
  UsagecontextValueQuantity(value: Quantity)
  UsagecontextValueRange(value: Range)
  UsagecontextValueReference(value: Reference)
}

pub fn usagecontext_value_to_json(element: UsagecontextValue) -> Json {
  case element {
    UsagecontextValueCodeableconcept(v) -> codeableconcept_to_json(v)
    UsagecontextValueQuantity(v) -> quantity_to_json(v)
    UsagecontextValueRange(v) -> range_to_json(v)
    UsagecontextValueReference(v) -> reference_to_json(v)
  }
}

pub fn usagecontext_value_decoder() -> Decoder(UsagecontextValue) {
  decode.one_of(
    decode.field(
      "valueCodeableConcept",
      codeableconcept_decoder(),
      decode.success,
    )
      |> decode.map(UsagecontextValueCodeableconcept),
    [
      decode.field("valueQuantity", quantity_decoder(), decode.success)
        |> decode.map(UsagecontextValueQuantity),
      decode.field("valueRange", range_decoder(), decode.success)
        |> decode.map(UsagecontextValueRange),
      decode.field("valueReference", reference_decoder(), decode.success)
        |> decode.map(UsagecontextValueReference),
    ],
  )
}

pub fn usagecontext_new(
  value value: UsagecontextValue,
  code code: Coding,
) -> Usagecontext {
  Usagecontext(value:, code:, extension: [], id: None)
}

pub fn usagecontext_to_json(usagecontext: Usagecontext) -> Json {
  let fields = [
    #(
      "value"
        <> case usagecontext.value {
        UsagecontextValueCodeableconcept(_) -> "CodeableConcept"
        UsagecontextValueQuantity(_) -> "Quantity"
        UsagecontextValueRange(_) -> "Range"
        UsagecontextValueReference(_) -> "Reference"
      },
      usagecontext_value_to_json(usagecontext.value),
    ),
    #("code", coding_to_json(usagecontext.code)),
  ]
  let fields = case usagecontext.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(usagecontext.extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case usagecontext.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn usagecontext_decoder() -> Decoder(Usagecontext) {
  use <- decode.recursive
  use value <- decode.then(usagecontext_value_decoder())
  use code <- decode.field("code", coding_decoder())
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Usagecontext(value:, code:, extension:, id:))
}

pub fn list1_to_json(l: List1(a), to_json: fn(a) -> Json) -> Json {
  json.array([l.first, ..l.rest], to_json)
}

pub fn list1_decoder(
  name: String,
  inner: decode.Decoder(a),
  next: fn(List1(a)) -> decode.Decoder(b),
) -> decode.Decoder(b) {
  use items <- decode.field(name, decode.list(inner))
  case items {
    [first, ..rest] -> next(List1(first:, rest:))
    _ -> {
      use fail_decode_to_satisfy_gleam_type <- decode.field(name, inner)
      next(List1(first: fail_decode_to_satisfy_gleam_type, rest: []))
    }
  }
}

//std lib decode.optional supports myfield: null but what if myfield is omitted from json entirely?
pub fn none_if_omitted(d: decode.Decoder(a)) -> decode.Decoder(Option(a)) {
  decode.one_of(d |> decode.map(Some), [decode.success(None)])
}

//std lib decode.float will NOT decode numbers without decimal point eg 4, only 4.0
pub fn decode_number() -> Decoder(Float) {
  decode.one_of(decode.float, [decode.map(decode.int, int.to_float)])
}

// Primitive and PrimitiveExtPart are used for decoding JSON
// but generic primitive extensions are NOT supported;
// the only supported primitive extensions are when profiles define them
// in which case they are generated as actual types
// for example
// pub type UsCoreQuestionnaireresponseQuestionnaire {
//   UsCoreQuestionnaireresponseQuestionnaire(
//     id: Option(String),
//     extension: List(ct.Extension),
//     questionnaire_display: Option(String),
//     url: Option(String),
//     value: Option(String),
//   )
// }
// so a user should never do anything with the Primitive type
@internal
pub type Primitive(a, b) {
  Primitive(id: Option(String), extension: List(b), value: Option(a))
}

@internal
pub type PrimitiveExtensionPart(b) {
  PrimitiveExtensionPart(id: Option(String), extension: List(b))
}

pub fn primitive_slice_to_json(
  old_fields: List(#(String, Json)),
  primitive: a,
  field_value_to_json: fn(a) -> Option(Json),
  field_rest_to_json: fn(a) -> Option(Json),
  name: String,
) -> List(#(String, Json)) {
  let old_fields = case field_rest_to_json(primitive) {
    None -> old_fields
    Some(value) -> [#("_" <> name, value), ..old_fields]
  }
  case field_value_to_json(primitive) {
    None -> old_fields
    Some(value) -> [#(name, value), ..old_fields]
  }
}

pub fn primitive_slice_list_to_json(
  old_fields: List(#(String, Json)),
  field: List(a),
  field_value_to_json: fn(a) -> Option(Json),
  field_rest_to_json: fn(a) -> Option(Json),
  name: String,
) -> List(#(String, Json)) {
  let values =
    list.map(field, fn(value) {
      json.nullable(field_value_to_json(value), fn(json) { json })
    })
  let extensions =
    list.map(field, fn(value) {
      json.nullable(field_rest_to_json(value), fn(json) { json })
    })
  let old_fields = case list.any(values, fn(j) { j != json.null() }) {
    False -> old_fields
    True -> [#(name, json.preprocessed_array(values)), ..old_fields]
  }
  case list.any(extensions, fn(j) { j != json.null() }) {
    False -> old_fields
    True -> [#("_" <> name, json.preprocessed_array(extensions)), ..old_fields]
  }
}

pub fn primitive_extension_part_decoder(
  extension_decoder: Decoder(a),
) -> Decoder(PrimitiveExtensionPart(a)) {
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(PrimitiveExtensionPart(extension:, id:))
}

pub fn primitive_decoder(
  name: String,
  thing_decoder: Decoder(a),
  extension_decoder: Decoder(b),
  next: fn(Primitive(a, b)) -> Decoder(c),
) -> Decoder(c) {
  use value <- decode.optional_field(name, None, decode.optional(thing_decoder))
  use primitive_extension_part <- decode.optional_field(
    "_" <> name,
    None,
    decode.optional(primitive_extension_part_decoder(extension_decoder)),
  )
  let #(id, extension) = case primitive_extension_part {
    None -> #(None, [])
    Some(PrimitiveExtensionPart(id, extension)) -> #(id, extension)
  }
  let together = Primitive(id:, extension:, value:)
  next(together)
}

pub fn primitives_decoder(
  name: String,
  thing_decoder: Decoder(a),
  extension_decoder: Decoder(b),
  next: fn(List(Primitive(a, b))) -> Decoder(c),
) -> Decoder(c) {
  use values <- decode.optional_field(
    name,
    [],
    decode.list(decode.optional(thing_decoder)),
  )
  use primitive_extension_parts <- decode.optional_field(
    "_" <> name,
    [],
    decode.list(
      decode.optional(primitive_extension_part_decoder(extension_decoder)),
    ),
  )
  let together =
    map2_fillnone(
      primitive_extension_parts,
      values,
      fn(primitive_extension_part, value) {
        let #(id, extension) = case primitive_extension_part {
          None -> #(None, [])
          Some(PrimitiveExtensionPart(id, extension)) -> #(id, extension)
        }
        Primitive(id:, extension:, value:)
      },
    )
  next(together)
}

pub fn primitive_slice_decoder(
  name: String,
  thing_decoder: Decoder(a),
  extension_decoder: Decoder(b),
  convert: fn(Primitive(a, b)) -> Decoder(c),
  next: fn(c) -> Decoder(d),
) -> Decoder(d) {
  use primitive <- primitive_decoder(name, thing_decoder, extension_decoder)
  use value <- decode.then(
    case primitive.value, primitive.id, primitive.extension {
      None, None, [] ->
        decode.field(name, thing_decoder, fn(_) { convert(primitive) })
      _, _, _ -> convert(primitive)
    },
  )
  next(value)
}

pub fn primitive_choice_slice_decoder(
  name: String,
  thing_decoder: Decoder(a),
  extension_decoder: Decoder(b),
  convert: fn(Primitive(a, b)) -> Decoder(c),
  next: fn(c) -> Decoder(d),
) -> Decoder(d) {
  use value_present <- decode.optional_field(name, False, decode.success(True))
  use extension_present <- decode.optional_field(
    "_" <> name,
    False,
    decode.success(True),
  )
  case value_present || extension_present {
    True ->
      primitive_slice_decoder(
        name,
        thing_decoder,
        extension_decoder,
        convert,
        next,
      )
    False -> {
      use _ <- decode.field(name, thing_decoder)
      primitive_slice_decoder(
        name,
        thing_decoder,
        extension_decoder,
        convert,
        next,
      )
    }
  }
}

pub fn primitive_slice_list_decoder(
  name: String,
  thing_decoder: Decoder(a),
  extension_decoder: Decoder(b),
  convert: fn(Primitive(a, b)) -> Decoder(c),
  next: fn(List(c)) -> Decoder(d),
) -> Decoder(d) {
  use primitives <- primitives_decoder(name, thing_decoder, extension_decoder)
  primitive_slice_list_parse_primitives(primitives, convert, name, 0, next)
}

fn primitive_slice_list_parse_primitives(
  primitives: List(Primitive(a, b)),
  convert: fn(Primitive(a, b)) -> Decoder(c),
  name: String,
  index: Int,
  next: fn(List(c)) -> Decoder(d),
) -> Decoder(d) {
  case primitives {
    [] -> next([])
    [first, ..rest] -> {
      use first <- decode.then(
        convert(first)
        |> decode.map_errors(fn(errors) {
          list.map(errors, fn(error) {
            case error.path {
              [field, ..path] if field == name ->
                decode.DecodeError(..error, path: [
                  field,
                  int.to_string(index),
                  ..path
                ])
              _ -> error
            }
          })
        }),
      )
      use rest <- primitive_slice_list_parse_primitives(
        rest,
        convert,
        name,
        index + 1,
      )
      next([first, ..rest])
    }
  }
}

pub fn map2_fillnone(
  list1: List(Option(a)),
  list2: List(Option(b)),
  with fun: fn(Option(a), Option(b)) -> c,
) -> List(c) {
  map2_fillnone_loop(list1, list2, fun, [])
}

fn map2_fillnone_loop(
  list1: List(Option(a)),
  list2: List(Option(b)),
  fun: fn(Option(a), Option(b)) -> c,
  acc: List(c),
) -> List(c) {
  case list1, list2 {
    [], [] -> list.reverse(acc)
    [a, ..as_], [] -> map2_fillnone_loop(as_, [], fun, [fun(a, None), ..acc])
    [], [b, ..bs] -> map2_fillnone_loop([], bs, fun, [fun(None, b), ..acc])
    [a, ..as_], [b, ..bs] ->
      map2_fillnone_loop(as_, bs, fun, [fun(a, b), ..acc])
  }
}

pub fn one_from_array_decoder(
  name: String,
  inner: decode.Decoder(a),
  next: fn(a) -> decode.Decoder(b),
) -> decode.Decoder(b) {
  use values <- decode.field(name, decode.list(inner))
  case values {
    [value] -> next(value)
    _ -> {
      use impossible_value <- decode.field(name, inner)
      next(impossible_value)
    }
  }
}

pub fn optional_one_from_array_decoder(
  name: String,
  inner: decode.Decoder(a),
  next: fn(Option(a)) -> decode.Decoder(b),
) -> decode.Decoder(b) {
  use values <- decode.optional_field(name, [], decode.list(inner))
  case values {
    [] -> next(None)
    [value] -> next(Some(value))
    _ -> {
      use impossible_value <- decode.field(name, inner)
      next(Some(impossible_value))
    }
  }
}
