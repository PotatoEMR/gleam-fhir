////[https://hl7.org/fhir/r4](https://hl7.org/fhir/r4) complex types

import fhir/r4us/primitive_types.{
  type Date, type DateTime, type Instant, type Time,
} as pt
import fhir/r4us/valuesets
import gleam/dict.{type Dict}
import gleam/dynamic/decode.{type Decoder}
import gleam/int
import gleam/json.{type Json}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result

/// 1..*
pub type List1(a) {
  List1(first: a, rest: List(a))
}

/// 2..*
pub type List2(a) {
  List2(first: a, second: a, rest: List(a))
}

/// 3..*
pub type List3(a) {
  List3(first: a, second: a, third: a, rest: List(a))
}

///[http://hl7.org/fhir/r4us/StructureDefinition/Address#resource](http://hl7.org/fhir/r4us/StructureDefinition/Address#resource)
pub type Address {
  Address(
    id: Option(String),
    extension: List(Extension),
    use_: Option(valuesets.Addressuse),
    type_: Option(valuesets.Addresstype),
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
  let Address(
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
  ) = address
  let fields = []
  let fields = case period {
    Some(v) -> [#("period", period_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case country {
    Some(v) -> [#("country", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case postal_code {
    Some(v) -> [#("postalCode", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case state {
    Some(v) -> [#("state", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case district {
    Some(v) -> [#("district", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case city {
    Some(v) -> [#("city", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case line {
    [] -> fields
    _ -> [#("line", json.array(line, json.string)), ..fields]
  }
  let fields = case text {
    Some(v) -> [#("text", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case type_ {
    Some(v) -> [#("type", valuesets.addresstype_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case use_ {
    Some(v) -> [#("use", valuesets.addressuse_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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
    decode.optional(valuesets.addresstype_decoder()),
  )
  use use_ <- decode.optional_field(
    "use",
    None,
    decode.optional(valuesets.addressuse_decoder()),
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

///[http://hl7.org/fhir/r4us/StructureDefinition/Age#resource](http://hl7.org/fhir/r4us/StructureDefinition/Age#resource)
pub type Age {
  Age(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(valuesets.Quantitycomparator),
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
  let Age(code:, system:, unit:, comparator:, value:, extension:, id:) = age
  let fields = []
  let fields = case code {
    Some(v) -> [#("code", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case system {
    Some(v) -> [#("system", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case unit {
    Some(v) -> [#("unit", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case comparator {
    Some(v) -> [
      #("comparator", valuesets.quantitycomparator_to_json(v)),
      ..fields
    ]
    None -> fields
  }
  let fields = case value {
    Some(v) -> [#("value", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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
    decode.optional(valuesets.quantitycomparator_decoder()),
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

///[http://hl7.org/fhir/r4us/StructureDefinition/Annotation#resource](http://hl7.org/fhir/r4us/StructureDefinition/Annotation#resource)
pub type Annotation {
  Annotation(
    id: Option(String),
    extension: List(Extension),
    author: Option(AnnotationAuthor),
    time: Option(DateTime),
    text: String,
  )
}

///[http://hl7.org/fhir/r4us/StructureDefinition/Annotation#resource](http://hl7.org/fhir/r4us/StructureDefinition/Annotation#resource)
pub type AnnotationAuthor {
  AnnotationAuthorReference(author: Reference)
  AnnotationAuthorString(author: String)
}

pub fn annotation_author_to_json(elt: AnnotationAuthor) -> Json {
  case elt {
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
  let Annotation(text:, time:, author:, extension:, id:) = annotation
  let fields = [
    #("text", json.string(text)),
  ]
  let fields = case time {
    Some(v) -> [#("time", pt.datetime_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case author {
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
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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

///[http://hl7.org/fhir/r4us/StructureDefinition/Attachment#resource](http://hl7.org/fhir/r4us/StructureDefinition/Attachment#resource)
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
  let Attachment(
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
  ) = attachment
  let fields = []
  let fields = case creation {
    Some(v) -> [#("creation", pt.datetime_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case title {
    Some(v) -> [#("title", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case hash {
    Some(v) -> [#("hash", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case size {
    Some(v) -> [#("size", json.int(v)), ..fields]
    None -> fields
  }
  let fields = case url {
    Some(v) -> [#("url", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case data {
    Some(v) -> [#("data", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case language {
    Some(v) -> [#("language", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case content_type {
    Some(v) -> [#("contentType", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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

///[http://hl7.org/fhir/r4us/StructureDefinition/CodeableConcept#resource](http://hl7.org/fhir/r4us/StructureDefinition/CodeableConcept#resource)
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
  let Codeableconcept(text:, coding:, extension:, id:) = codeableconcept
  let fields = []
  let fields = case text {
    Some(v) -> [#("text", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case coding {
    [] -> fields
    _ -> [#("coding", json.array(coding, coding_to_json)), ..fields]
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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

///[http://hl7.org/fhir/r4us/StructureDefinition/Coding#resource](http://hl7.org/fhir/r4us/StructureDefinition/Coding#resource)
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
  let Coding(
    user_selected:,
    display:,
    code:,
    version:,
    system:,
    extension:,
    id:,
  ) = coding
  let fields = []
  let fields = case user_selected {
    Some(v) -> [#("userSelected", json.bool(v)), ..fields]
    None -> fields
  }
  let fields = case display {
    Some(v) -> [#("display", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case code {
    Some(v) -> [#("code", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case version {
    Some(v) -> [#("version", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case system {
    Some(v) -> [#("system", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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

///[http://hl7.org/fhir/r4us/StructureDefinition/ContactDetail#resource](http://hl7.org/fhir/r4us/StructureDefinition/ContactDetail#resource)
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
  let Contactdetail(telecom:, name:, extension:, id:) = contactdetail
  let fields = []
  let fields = case telecom {
    [] -> fields
    _ -> [#("telecom", json.array(telecom, contactpoint_to_json)), ..fields]
  }
  let fields = case name {
    Some(v) -> [#("name", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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

///[http://hl7.org/fhir/r4us/StructureDefinition/ContactPoint#resource](http://hl7.org/fhir/r4us/StructureDefinition/ContactPoint#resource)
pub type Contactpoint {
  Contactpoint(
    us_core_direct: List(Bool),
    id: Option(String),
    extension: List(Extension),
    system: Option(valuesets.Contactpointsystem),
    value: Option(String),
    use_: Option(valuesets.Contactpointuse),
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
    us_core_direct: [],
  )
}

pub fn contactpoint_to_json(contactpoint: Contactpoint) -> Json {
  let Contactpoint(
    period:,
    rank:,
    use_:,
    value:,
    system:,
    extension:,
    id:,
    us_core_direct:,
  ) = contactpoint
  let fields = []
  let extension =
    list.flatten([extension, list.map(us_core_direct, us_core_direct_to_ext)])
  let fields = case period {
    Some(v) -> [#("period", period_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case rank {
    Some(v) -> [#("rank", json.int(v)), ..fields]
    None -> fields
  }
  let fields = case use_ {
    Some(v) -> [#("use", valuesets.contactpointuse_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case value {
    Some(v) -> [#("value", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case system {
    Some(v) -> [#("system", valuesets.contactpointsystem_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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
    decode.optional(valuesets.contactpointuse_decoder()),
  )
  use value <- decode.optional_field(
    "value",
    None,
    decode.optional(decode.string),
  )
  use system <- decode.optional_field(
    "system",
    None,
    decode.optional(valuesets.contactpointsystem_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  let #(us_core_direct_, extension) =
    list.fold(from: #([], []), over: extension, with: fn(acc, ext) {
      let #(a0, plain) = acc
      case us_core_direct_from_ext(ext) {
        Ok(v) -> #([v, ..a0], plain)
        Error(_) -> #(a0, [ext, ..plain])
      }
    })
  let us_core_direct = us_core_direct_
  decode.success(Contactpoint(
    period:,
    rank:,
    use_:,
    value:,
    system:,
    extension:,
    id:,
    us_core_direct:,
  ))
}

///[http://hl7.org/fhir/r4us/StructureDefinition/Contributor#resource](http://hl7.org/fhir/r4us/StructureDefinition/Contributor#resource)
pub type Contributor {
  Contributor(
    id: Option(String),
    extension: List(Extension),
    type_: valuesets.Contributortype,
    name: String,
    contact: List(Contactdetail),
  )
}

pub fn contributor_new(
  name name: String,
  type_ type_: valuesets.Contributortype,
) -> Contributor {
  Contributor(contact: [], name:, type_:, extension: [], id: None)
}

pub fn contributor_to_json(contributor: Contributor) -> Json {
  let Contributor(contact:, name:, type_:, extension:, id:) = contributor
  let fields = [
    #("name", json.string(name)),
    #("type", valuesets.contributortype_to_json(type_)),
  ]
  let fields = case contact {
    [] -> fields
    _ -> [#("contact", json.array(contact, contactdetail_to_json)), ..fields]
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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
  use type_ <- decode.field("type", valuesets.contributortype_decoder())
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Contributor(contact:, name:, type_:, extension:, id:))
}

///[http://hl7.org/fhir/r4us/StructureDefinition/Count#resource](http://hl7.org/fhir/r4us/StructureDefinition/Count#resource)
pub type Count {
  Count(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(valuesets.Quantitycomparator),
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
  let Count(code:, system:, unit:, comparator:, value:, extension:, id:) = count
  let fields = []
  let fields = case code {
    Some(v) -> [#("code", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case system {
    Some(v) -> [#("system", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case unit {
    Some(v) -> [#("unit", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case comparator {
    Some(v) -> [
      #("comparator", valuesets.quantitycomparator_to_json(v)),
      ..fields
    ]
    None -> fields
  }
  let fields = case value {
    Some(v) -> [#("value", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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
    decode.optional(valuesets.quantitycomparator_decoder()),
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

///[http://hl7.org/fhir/r4us/StructureDefinition/DataRequirement#resource](http://hl7.org/fhir/r4us/StructureDefinition/DataRequirement#resource)
pub type Datarequirement {
  Datarequirement(
    id: Option(String),
    extension: List(Extension),
    type_: valuesets.Alltypes,
    profile: List(String),
    subject: Option(DatarequirementSubject),
    must_support: List(String),
    code_filter: List(DatarequirementCodefilter),
    date_filter: List(DatarequirementDatefilter),
    limit: Option(Int),
    sort: List(DatarequirementSort),
  )
}

///[http://hl7.org/fhir/r4us/StructureDefinition/DataRequirement#resource](http://hl7.org/fhir/r4us/StructureDefinition/DataRequirement#resource)
pub type DatarequirementSubject {
  DatarequirementSubjectCodeableconcept(subject: Codeableconcept)
  DatarequirementSubjectReference(subject: Reference)
}

pub fn datarequirement_subject_to_json(elt: DatarequirementSubject) -> Json {
  case elt {
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

pub fn datarequirement_new(type_ type_: valuesets.Alltypes) -> Datarequirement {
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

///[http://hl7.org/fhir/r4us/StructureDefinition/DataRequirement#resource](http://hl7.org/fhir/r4us/StructureDefinition/DataRequirement#resource)
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

///[http://hl7.org/fhir/r4us/StructureDefinition/DataRequirement#resource](http://hl7.org/fhir/r4us/StructureDefinition/DataRequirement#resource)
pub type DatarequirementDatefilter {
  DatarequirementDatefilter(
    id: Option(String),
    extension: List(Extension),
    path: Option(String),
    search_param: Option(String),
    value: Option(DatarequirementDatefilterValue),
  )
}

///[http://hl7.org/fhir/r4us/StructureDefinition/DataRequirement#resource](http://hl7.org/fhir/r4us/StructureDefinition/DataRequirement#resource)
pub type DatarequirementDatefilterValue {
  DatarequirementDatefilterValueDatetime(value: DateTime)
  DatarequirementDatefilterValuePeriod(value: Period)
  DatarequirementDatefilterValueDuration(value: Duration)
}

pub fn datarequirement_datefilter_value_to_json(
  elt: DatarequirementDatefilterValue,
) -> Json {
  case elt {
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

///[http://hl7.org/fhir/r4us/StructureDefinition/DataRequirement#resource](http://hl7.org/fhir/r4us/StructureDefinition/DataRequirement#resource)
pub type DatarequirementSort {
  DatarequirementSort(
    id: Option(String),
    extension: List(Extension),
    path: String,
    direction: valuesets.Sortdirection,
  )
}

pub fn datarequirement_sort_new(
  direction direction: valuesets.Sortdirection,
  path path: String,
) -> DatarequirementSort {
  DatarequirementSort(direction:, path:, extension: [], id: None)
}

pub fn datarequirement_sort_to_json(
  datarequirement_sort: DatarequirementSort,
) -> Json {
  let DatarequirementSort(direction:, path:, extension:, id:) =
    datarequirement_sort
  let fields = [
    #("direction", valuesets.sortdirection_to_json(direction)),
    #("path", json.string(path)),
  ]
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn datarequirement_sort_decoder() -> Decoder(DatarequirementSort) {
  use <- decode.recursive
  use direction <- decode.field("direction", valuesets.sortdirection_decoder())
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
  let DatarequirementDatefilter(value:, search_param:, path:, extension:, id:) =
    datarequirement_datefilter
  let fields = []
  let fields = case value {
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
  let fields = case search_param {
    Some(v) -> [#("searchParam", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case path {
    Some(v) -> [#("path", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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
  let DatarequirementCodefilter(
    code:,
    value_set:,
    search_param:,
    path:,
    extension:,
    id:,
  ) = datarequirement_codefilter
  let fields = []
  let fields = case code {
    [] -> fields
    _ -> [#("code", json.array(code, coding_to_json)), ..fields]
  }
  let fields = case value_set {
    Some(v) -> [#("valueSet", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case search_param {
    Some(v) -> [#("searchParam", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case path {
    Some(v) -> [#("path", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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
  let Datarequirement(
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
  ) = datarequirement
  let fields = [
    #("type", valuesets.alltypes_to_json(type_)),
  ]
  let fields = case sort {
    [] -> fields
    _ -> [#("sort", json.array(sort, datarequirement_sort_to_json)), ..fields]
  }
  let fields = case limit {
    Some(v) -> [#("limit", json.int(v)), ..fields]
    None -> fields
  }
  let fields = case date_filter {
    [] -> fields
    _ -> [
      #(
        "dateFilter",
        json.array(date_filter, datarequirement_datefilter_to_json),
      ),
      ..fields
    ]
  }
  let fields = case code_filter {
    [] -> fields
    _ -> [
      #(
        "codeFilter",
        json.array(code_filter, datarequirement_codefilter_to_json),
      ),
      ..fields
    ]
  }
  let fields = case must_support {
    [] -> fields
    _ -> [#("mustSupport", json.array(must_support, json.string)), ..fields]
  }
  let fields = case subject {
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
  let fields = case profile {
    [] -> fields
    _ -> [#("profile", json.array(profile, json.string)), ..fields]
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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
  use type_ <- decode.field("type", valuesets.alltypes_decoder())
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

///[http://hl7.org/fhir/r4us/StructureDefinition/Distance#resource](http://hl7.org/fhir/r4us/StructureDefinition/Distance#resource)
pub type Distance {
  Distance(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(valuesets.Quantitycomparator),
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
  let Distance(code:, system:, unit:, comparator:, value:, extension:, id:) =
    distance
  let fields = []
  let fields = case code {
    Some(v) -> [#("code", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case system {
    Some(v) -> [#("system", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case unit {
    Some(v) -> [#("unit", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case comparator {
    Some(v) -> [
      #("comparator", valuesets.quantitycomparator_to_json(v)),
      ..fields
    ]
    None -> fields
  }
  let fields = case value {
    Some(v) -> [#("value", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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
    decode.optional(valuesets.quantitycomparator_decoder()),
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

///[http://hl7.org/fhir/r4us/StructureDefinition/Dosage#resource](http://hl7.org/fhir/r4us/StructureDefinition/Dosage#resource)
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

///[http://hl7.org/fhir/r4us/StructureDefinition/Dosage#resource](http://hl7.org/fhir/r4us/StructureDefinition/Dosage#resource)
pub type DosageAsneeded {
  DosageAsneededBoolean(as_needed: Bool)
  DosageAsneededCodeableconcept(as_needed: Codeableconcept)
}

pub fn dosage_asneeded_to_json(elt: DosageAsneeded) -> Json {
  case elt {
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

///[http://hl7.org/fhir/r4us/StructureDefinition/Dosage#resource](http://hl7.org/fhir/r4us/StructureDefinition/Dosage#resource)
pub type DosageDoseandrate {
  DosageDoseandrate(
    id: Option(String),
    extension: List(Extension),
    type_: Option(Codeableconcept),
    dose: Option(DosageDoseandrateDose),
    rate: Option(DosageDoseandrateRate),
  )
}

///[http://hl7.org/fhir/r4us/StructureDefinition/Dosage#resource](http://hl7.org/fhir/r4us/StructureDefinition/Dosage#resource)
pub type DosageDoseandrateDose {
  DosageDoseandrateDoseRange(dose: Range)
  DosageDoseandrateDoseQuantity(dose: Quantity)
}

pub fn dosage_doseandrate_dose_to_json(elt: DosageDoseandrateDose) -> Json {
  case elt {
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

///[http://hl7.org/fhir/r4us/StructureDefinition/Dosage#resource](http://hl7.org/fhir/r4us/StructureDefinition/Dosage#resource)
pub type DosageDoseandrateRate {
  DosageDoseandrateRateRatio(rate: Ratio)
  DosageDoseandrateRateRange(rate: Range)
  DosageDoseandrateRateQuantity(rate: Quantity)
}

pub fn dosage_doseandrate_rate_to_json(elt: DosageDoseandrateRate) -> Json {
  case elt {
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

pub fn dosage_doseandrate_to_json(dosage_doseandrate: DosageDoseandrate) -> Json {
  let DosageDoseandrate(rate:, dose:, type_:, extension:, id:) =
    dosage_doseandrate
  let fields = []
  let fields = case rate {
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
  let fields = case dose {
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
  let fields = case type_ {
    Some(v) -> [#("type", codeableconcept_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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
  let Dosage(
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
  ) = dosage
  let fields = []
  let fields = case max_dose_per_lifetime {
    Some(v) -> [#("maxDosePerLifetime", quantity_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case max_dose_per_administration {
    Some(v) -> [#("maxDosePerAdministration", quantity_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case max_dose_per_period {
    Some(v) -> [#("maxDosePerPeriod", ratio_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case dose_and_rate {
    [] -> fields
    _ -> [
      #("doseAndRate", json.array(dose_and_rate, dosage_doseandrate_to_json)),
      ..fields
    ]
  }
  let fields = case method {
    Some(v) -> [#("method", codeableconcept_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case route {
    Some(v) -> [#("route", codeableconcept_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case site {
    Some(v) -> [#("site", codeableconcept_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case as_needed {
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
  let fields = case timing {
    Some(v) -> [#("timing", timing_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case patient_instruction {
    Some(v) -> [#("patientInstruction", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case additional_instruction {
    [] -> fields
    _ -> [
      #(
        "additionalInstruction",
        json.array(additional_instruction, codeableconcept_to_json),
      ),
      ..fields
    ]
  }
  let fields = case text {
    Some(v) -> [#("text", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case sequence {
    Some(v) -> [#("sequence", json.int(v)), ..fields]
    None -> fields
  }
  let fields = case modifier_extension {
    [] -> fields
    _ -> [
      #("modifierExtension", json.array(modifier_extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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

///[http://hl7.org/fhir/r4us/StructureDefinition/Duration#resource](http://hl7.org/fhir/r4us/StructureDefinition/Duration#resource)
pub type Duration {
  Duration(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(valuesets.Quantitycomparator),
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
  let Duration(code:, system:, unit:, comparator:, value:, extension:, id:) =
    duration
  let fields = []
  let fields = case code {
    Some(v) -> [#("code", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case system {
    Some(v) -> [#("system", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case unit {
    Some(v) -> [#("unit", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case comparator {
    Some(v) -> [
      #("comparator", valuesets.quantitycomparator_to_json(v)),
      ..fields
    ]
    None -> fields
  }
  let fields = case value {
    Some(v) -> [#("value", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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
    decode.optional(valuesets.quantitycomparator_decoder()),
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

///[http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource](http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource)
pub type Elementdefinition {
  Elementdefinition(
    uscdi_requirement: List(Bool),
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    path: String,
    representation: List(valuesets.Propertyrepresentation),
    slice_name: Option(String),
    slice_is_constraining: Option(Bool),
    label: Option(String),
    code: List(Coding),
    slicing: Option(ElementdefinitionSlicing),
    short: Option(String),
    definition: Option(String),
    comment: Option(String),
    requirements: Option(String),
    alias: List(String),
    min: Option(Int),
    max: Option(String),
    base: Option(ElementdefinitionBase),
    content_reference: Option(String),
    type_: List(ElementdefinitionType),
    default_value: Option(ElementdefinitionDefaultvalue),
    meaning_when_missing: Option(String),
    order_meaning: Option(String),
    fixed: Option(ElementdefinitionFixed),
    pattern: Option(ElementdefinitionPattern),
    example: List(ElementdefinitionExample),
    min_value: Option(ElementdefinitionMinvalue),
    max_value: Option(ElementdefinitionMaxvalue),
    max_length: Option(Int),
    condition: List(String),
    constraint: List(ElementdefinitionConstraint),
    must_support: Option(Bool),
    is_modifier: Option(Bool),
    is_modifier_reason: Option(String),
    is_summary: Option(Bool),
    binding: Option(ElementdefinitionBinding),
    mapping: List(ElementdefinitionMapping),
  )
}

///[http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource](http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource)
pub type ElementdefinitionDefaultvalue {
  ElementdefinitionDefaultvalueBase64binary(default_value: String)
  ElementdefinitionDefaultvalueBoolean(default_value: Bool)
  ElementdefinitionDefaultvalueCanonical(default_value: String)
  ElementdefinitionDefaultvalueCode(default_value: String)
  ElementdefinitionDefaultvalueDate(default_value: Date)
  ElementdefinitionDefaultvalueDatetime(default_value: DateTime)
  ElementdefinitionDefaultvalueDecimal(default_value: Float)
  ElementdefinitionDefaultvalueId(default_value: String)
  ElementdefinitionDefaultvalueInstant(default_value: Instant)
  ElementdefinitionDefaultvalueInteger(default_value: Int)
  ElementdefinitionDefaultvalueMarkdown(default_value: String)
  ElementdefinitionDefaultvalueOid(default_value: String)
  ElementdefinitionDefaultvaluePositiveint(default_value: Int)
  ElementdefinitionDefaultvalueString(default_value: String)
  ElementdefinitionDefaultvalueTime(default_value: Time)
  ElementdefinitionDefaultvalueUnsignedint(default_value: Int)
  ElementdefinitionDefaultvalueUri(default_value: String)
  ElementdefinitionDefaultvalueUrl(default_value: String)
  ElementdefinitionDefaultvalueUuid(default_value: String)
  ElementdefinitionDefaultvalueAddress(default_value: Address)
  ElementdefinitionDefaultvalueAge(default_value: Age)
  ElementdefinitionDefaultvalueAnnotation(default_value: Annotation)
  ElementdefinitionDefaultvalueAttachment(default_value: Attachment)
  ElementdefinitionDefaultvalueCodeableconcept(default_value: Codeableconcept)
  ElementdefinitionDefaultvalueCoding(default_value: Coding)
  ElementdefinitionDefaultvalueContactpoint(default_value: Contactpoint)
  ElementdefinitionDefaultvalueCount(default_value: Count)
  ElementdefinitionDefaultvalueDistance(default_value: Distance)
  ElementdefinitionDefaultvalueDuration(default_value: Duration)
  ElementdefinitionDefaultvalueHumanname(default_value: Humanname)
  ElementdefinitionDefaultvalueIdentifier(default_value: Identifier)
  ElementdefinitionDefaultvalueMoney(default_value: Money)
  ElementdefinitionDefaultvaluePeriod(default_value: Period)
  ElementdefinitionDefaultvalueQuantity(default_value: Quantity)
  ElementdefinitionDefaultvalueRange(default_value: Range)
  ElementdefinitionDefaultvalueRatio(default_value: Ratio)
  ElementdefinitionDefaultvalueReference(default_value: Reference)
  ElementdefinitionDefaultvalueSampleddata(default_value: Sampleddata)
  ElementdefinitionDefaultvalueSignature(default_value: Signature)
  ElementdefinitionDefaultvalueTiming(default_value: Timing)
  ElementdefinitionDefaultvalueContactdetail(default_value: Contactdetail)
  ElementdefinitionDefaultvalueContributor(default_value: Contributor)
  ElementdefinitionDefaultvalueDatarequirement(default_value: Datarequirement)
  ElementdefinitionDefaultvalueExpression(default_value: Expression)
  ElementdefinitionDefaultvalueParameterdefinition(
    default_value: Parameterdefinition,
  )
  ElementdefinitionDefaultvalueRelatedartifact(default_value: Relatedartifact)
  ElementdefinitionDefaultvalueTriggerdefinition(
    default_value: Triggerdefinition,
  )
  ElementdefinitionDefaultvalueUsagecontext(default_value: Usagecontext)
  ElementdefinitionDefaultvalueDosage(default_value: Dosage)
  ElementdefinitionDefaultvalueMeta(default_value: Meta)
}

pub fn elementdefinition_defaultvalue_to_json(
  elt: ElementdefinitionDefaultvalue,
) -> Json {
  case elt {
    ElementdefinitionDefaultvalueBase64binary(v) -> json.string(v)
    ElementdefinitionDefaultvalueBoolean(v) -> json.bool(v)
    ElementdefinitionDefaultvalueCanonical(v) -> json.string(v)
    ElementdefinitionDefaultvalueCode(v) -> json.string(v)
    ElementdefinitionDefaultvalueDate(v) -> pt.date_to_json(v)
    ElementdefinitionDefaultvalueDatetime(v) -> pt.datetime_to_json(v)
    ElementdefinitionDefaultvalueDecimal(v) -> json.float(v)
    ElementdefinitionDefaultvalueId(v) -> json.string(v)
    ElementdefinitionDefaultvalueInstant(v) -> pt.instant_to_json(v)
    ElementdefinitionDefaultvalueInteger(v) -> json.int(v)
    ElementdefinitionDefaultvalueMarkdown(v) -> json.string(v)
    ElementdefinitionDefaultvalueOid(v) -> json.string(v)
    ElementdefinitionDefaultvaluePositiveint(v) -> json.int(v)
    ElementdefinitionDefaultvalueString(v) -> json.string(v)
    ElementdefinitionDefaultvalueTime(v) -> pt.time_to_json(v)
    ElementdefinitionDefaultvalueUnsignedint(v) -> json.int(v)
    ElementdefinitionDefaultvalueUri(v) -> json.string(v)
    ElementdefinitionDefaultvalueUrl(v) -> json.string(v)
    ElementdefinitionDefaultvalueUuid(v) -> json.string(v)
    ElementdefinitionDefaultvalueAddress(v) -> address_to_json(v)
    ElementdefinitionDefaultvalueAge(v) -> age_to_json(v)
    ElementdefinitionDefaultvalueAnnotation(v) -> annotation_to_json(v)
    ElementdefinitionDefaultvalueAttachment(v) -> attachment_to_json(v)
    ElementdefinitionDefaultvalueCodeableconcept(v) ->
      codeableconcept_to_json(v)
    ElementdefinitionDefaultvalueCoding(v) -> coding_to_json(v)
    ElementdefinitionDefaultvalueContactpoint(v) -> contactpoint_to_json(v)
    ElementdefinitionDefaultvalueCount(v) -> count_to_json(v)
    ElementdefinitionDefaultvalueDistance(v) -> distance_to_json(v)
    ElementdefinitionDefaultvalueDuration(v) -> duration_to_json(v)
    ElementdefinitionDefaultvalueHumanname(v) -> humanname_to_json(v)
    ElementdefinitionDefaultvalueIdentifier(v) -> identifier_to_json(v)
    ElementdefinitionDefaultvalueMoney(v) -> money_to_json(v)
    ElementdefinitionDefaultvaluePeriod(v) -> period_to_json(v)
    ElementdefinitionDefaultvalueQuantity(v) -> quantity_to_json(v)
    ElementdefinitionDefaultvalueRange(v) -> range_to_json(v)
    ElementdefinitionDefaultvalueRatio(v) -> ratio_to_json(v)
    ElementdefinitionDefaultvalueReference(v) -> reference_to_json(v)
    ElementdefinitionDefaultvalueSampleddata(v) -> sampleddata_to_json(v)
    ElementdefinitionDefaultvalueSignature(v) -> signature_to_json(v)
    ElementdefinitionDefaultvalueTiming(v) -> timing_to_json(v)
    ElementdefinitionDefaultvalueContactdetail(v) -> contactdetail_to_json(v)
    ElementdefinitionDefaultvalueContributor(v) -> contributor_to_json(v)
    ElementdefinitionDefaultvalueDatarequirement(v) ->
      datarequirement_to_json(v)
    ElementdefinitionDefaultvalueExpression(v) -> expression_to_json(v)
    ElementdefinitionDefaultvalueParameterdefinition(v) ->
      parameterdefinition_to_json(v)
    ElementdefinitionDefaultvalueRelatedartifact(v) ->
      relatedartifact_to_json(v)
    ElementdefinitionDefaultvalueTriggerdefinition(v) ->
      triggerdefinition_to_json(v)
    ElementdefinitionDefaultvalueUsagecontext(v) -> usagecontext_to_json(v)
    ElementdefinitionDefaultvalueDosage(v) -> dosage_to_json(v)
    ElementdefinitionDefaultvalueMeta(v) -> meta_to_json(v)
  }
}

pub fn elementdefinition_defaultvalue_decoder() -> Decoder(
  ElementdefinitionDefaultvalue,
) {
  decode.one_of(
    decode.field("defaultValueBase64Binary", decode.string, decode.success)
      |> decode.map(ElementdefinitionDefaultvalueBase64binary),
    [
      decode.field("defaultValueBoolean", decode.bool, decode.success)
        |> decode.map(ElementdefinitionDefaultvalueBoolean),
      decode.field("defaultValueCanonical", decode.string, decode.success)
        |> decode.map(ElementdefinitionDefaultvalueCanonical),
      decode.field("defaultValueCode", decode.string, decode.success)
        |> decode.map(ElementdefinitionDefaultvalueCode),
      decode.field("defaultValueDate", pt.date_decoder(), decode.success)
        |> decode.map(ElementdefinitionDefaultvalueDate),
      decode.field(
        "defaultValueDateTime",
        pt.datetime_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionDefaultvalueDatetime),
      decode.field("defaultValueDecimal", decode_number(), decode.success)
        |> decode.map(ElementdefinitionDefaultvalueDecimal),
      decode.field("defaultValueId", decode.string, decode.success)
        |> decode.map(ElementdefinitionDefaultvalueId),
      decode.field("defaultValueInstant", pt.instant_decoder(), decode.success)
        |> decode.map(ElementdefinitionDefaultvalueInstant),
      decode.field("defaultValueInteger", decode.int, decode.success)
        |> decode.map(ElementdefinitionDefaultvalueInteger),
      decode.field("defaultValueMarkdown", decode.string, decode.success)
        |> decode.map(ElementdefinitionDefaultvalueMarkdown),
      decode.field("defaultValueOid", decode.string, decode.success)
        |> decode.map(ElementdefinitionDefaultvalueOid),
      decode.field("defaultValuePositiveInt", decode.int, decode.success)
        |> decode.map(ElementdefinitionDefaultvaluePositiveint),
      decode.field("defaultValueString", decode.string, decode.success)
        |> decode.map(ElementdefinitionDefaultvalueString),
      decode.field("defaultValueTime", pt.time_decoder(), decode.success)
        |> decode.map(ElementdefinitionDefaultvalueTime),
      decode.field("defaultValueUnsignedInt", decode.int, decode.success)
        |> decode.map(ElementdefinitionDefaultvalueUnsignedint),
      decode.field("defaultValueUri", decode.string, decode.success)
        |> decode.map(ElementdefinitionDefaultvalueUri),
      decode.field("defaultValueUrl", decode.string, decode.success)
        |> decode.map(ElementdefinitionDefaultvalueUrl),
      decode.field("defaultValueUuid", decode.string, decode.success)
        |> decode.map(ElementdefinitionDefaultvalueUuid),
      decode.field("defaultValueAddress", address_decoder(), decode.success)
        |> decode.map(ElementdefinitionDefaultvalueAddress),
      decode.field("defaultValueAge", age_decoder(), decode.success)
        |> decode.map(ElementdefinitionDefaultvalueAge),
      decode.field(
        "defaultValueAnnotation",
        annotation_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionDefaultvalueAnnotation),
      decode.field(
        "defaultValueAttachment",
        attachment_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionDefaultvalueAttachment),
      decode.field(
        "defaultValueCodeableConcept",
        codeableconcept_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionDefaultvalueCodeableconcept),
      decode.field("defaultValueCoding", coding_decoder(), decode.success)
        |> decode.map(ElementdefinitionDefaultvalueCoding),
      decode.field(
        "defaultValueContactPoint",
        contactpoint_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionDefaultvalueContactpoint),
      decode.field("defaultValueCount", count_decoder(), decode.success)
        |> decode.map(ElementdefinitionDefaultvalueCount),
      decode.field("defaultValueDistance", distance_decoder(), decode.success)
        |> decode.map(ElementdefinitionDefaultvalueDistance),
      decode.field("defaultValueDuration", duration_decoder(), decode.success)
        |> decode.map(ElementdefinitionDefaultvalueDuration),
      decode.field("defaultValueHumanName", humanname_decoder(), decode.success)
        |> decode.map(ElementdefinitionDefaultvalueHumanname),
      decode.field(
        "defaultValueIdentifier",
        identifier_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionDefaultvalueIdentifier),
      decode.field("defaultValueMoney", money_decoder(), decode.success)
        |> decode.map(ElementdefinitionDefaultvalueMoney),
      decode.field("defaultValuePeriod", period_decoder(), decode.success)
        |> decode.map(ElementdefinitionDefaultvaluePeriod),
      decode.field("defaultValueQuantity", quantity_decoder(), decode.success)
        |> decode.map(ElementdefinitionDefaultvalueQuantity),
      decode.field("defaultValueRange", range_decoder(), decode.success)
        |> decode.map(ElementdefinitionDefaultvalueRange),
      decode.field("defaultValueRatio", ratio_decoder(), decode.success)
        |> decode.map(ElementdefinitionDefaultvalueRatio),
      decode.field("defaultValueReference", reference_decoder(), decode.success)
        |> decode.map(ElementdefinitionDefaultvalueReference),
      decode.field(
        "defaultValueSampledData",
        sampleddata_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionDefaultvalueSampleddata),
      decode.field("defaultValueSignature", signature_decoder(), decode.success)
        |> decode.map(ElementdefinitionDefaultvalueSignature),
      decode.field("defaultValueTiming", timing_decoder(), decode.success)
        |> decode.map(ElementdefinitionDefaultvalueTiming),
      decode.field(
        "defaultValueContactDetail",
        contactdetail_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionDefaultvalueContactdetail),
      decode.field(
        "defaultValueContributor",
        contributor_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionDefaultvalueContributor),
      decode.field(
        "defaultValueDataRequirement",
        datarequirement_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionDefaultvalueDatarequirement),
      decode.field(
        "defaultValueExpression",
        expression_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionDefaultvalueExpression),
      decode.field(
        "defaultValueParameterDefinition",
        parameterdefinition_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionDefaultvalueParameterdefinition),
      decode.field(
        "defaultValueRelatedArtifact",
        relatedartifact_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionDefaultvalueRelatedartifact),
      decode.field(
        "defaultValueTriggerDefinition",
        triggerdefinition_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionDefaultvalueTriggerdefinition),
      decode.field(
        "defaultValueUsageContext",
        usagecontext_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionDefaultvalueUsagecontext),
      decode.field("defaultValueDosage", dosage_decoder(), decode.success)
        |> decode.map(ElementdefinitionDefaultvalueDosage),
      decode.field("defaultValueMeta", meta_decoder(), decode.success)
        |> decode.map(ElementdefinitionDefaultvalueMeta),
    ],
  )
}

///[http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource](http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource)
pub type ElementdefinitionFixed {
  ElementdefinitionFixedBase64binary(fixed: String)
  ElementdefinitionFixedBoolean(fixed: Bool)
  ElementdefinitionFixedCanonical(fixed: String)
  ElementdefinitionFixedCode(fixed: String)
  ElementdefinitionFixedDate(fixed: Date)
  ElementdefinitionFixedDatetime(fixed: DateTime)
  ElementdefinitionFixedDecimal(fixed: Float)
  ElementdefinitionFixedId(fixed: String)
  ElementdefinitionFixedInstant(fixed: Instant)
  ElementdefinitionFixedInteger(fixed: Int)
  ElementdefinitionFixedMarkdown(fixed: String)
  ElementdefinitionFixedOid(fixed: String)
  ElementdefinitionFixedPositiveint(fixed: Int)
  ElementdefinitionFixedString(fixed: String)
  ElementdefinitionFixedTime(fixed: Time)
  ElementdefinitionFixedUnsignedint(fixed: Int)
  ElementdefinitionFixedUri(fixed: String)
  ElementdefinitionFixedUrl(fixed: String)
  ElementdefinitionFixedUuid(fixed: String)
  ElementdefinitionFixedAddress(fixed: Address)
  ElementdefinitionFixedAge(fixed: Age)
  ElementdefinitionFixedAnnotation(fixed: Annotation)
  ElementdefinitionFixedAttachment(fixed: Attachment)
  ElementdefinitionFixedCodeableconcept(fixed: Codeableconcept)
  ElementdefinitionFixedCoding(fixed: Coding)
  ElementdefinitionFixedContactpoint(fixed: Contactpoint)
  ElementdefinitionFixedCount(fixed: Count)
  ElementdefinitionFixedDistance(fixed: Distance)
  ElementdefinitionFixedDuration(fixed: Duration)
  ElementdefinitionFixedHumanname(fixed: Humanname)
  ElementdefinitionFixedIdentifier(fixed: Identifier)
  ElementdefinitionFixedMoney(fixed: Money)
  ElementdefinitionFixedPeriod(fixed: Period)
  ElementdefinitionFixedQuantity(fixed: Quantity)
  ElementdefinitionFixedRange(fixed: Range)
  ElementdefinitionFixedRatio(fixed: Ratio)
  ElementdefinitionFixedReference(fixed: Reference)
  ElementdefinitionFixedSampleddata(fixed: Sampleddata)
  ElementdefinitionFixedSignature(fixed: Signature)
  ElementdefinitionFixedTiming(fixed: Timing)
  ElementdefinitionFixedContactdetail(fixed: Contactdetail)
  ElementdefinitionFixedContributor(fixed: Contributor)
  ElementdefinitionFixedDatarequirement(fixed: Datarequirement)
  ElementdefinitionFixedExpression(fixed: Expression)
  ElementdefinitionFixedParameterdefinition(fixed: Parameterdefinition)
  ElementdefinitionFixedRelatedartifact(fixed: Relatedartifact)
  ElementdefinitionFixedTriggerdefinition(fixed: Triggerdefinition)
  ElementdefinitionFixedUsagecontext(fixed: Usagecontext)
  ElementdefinitionFixedDosage(fixed: Dosage)
  ElementdefinitionFixedMeta(fixed: Meta)
}

pub fn elementdefinition_fixed_to_json(elt: ElementdefinitionFixed) -> Json {
  case elt {
    ElementdefinitionFixedBase64binary(v) -> json.string(v)
    ElementdefinitionFixedBoolean(v) -> json.bool(v)
    ElementdefinitionFixedCanonical(v) -> json.string(v)
    ElementdefinitionFixedCode(v) -> json.string(v)
    ElementdefinitionFixedDate(v) -> pt.date_to_json(v)
    ElementdefinitionFixedDatetime(v) -> pt.datetime_to_json(v)
    ElementdefinitionFixedDecimal(v) -> json.float(v)
    ElementdefinitionFixedId(v) -> json.string(v)
    ElementdefinitionFixedInstant(v) -> pt.instant_to_json(v)
    ElementdefinitionFixedInteger(v) -> json.int(v)
    ElementdefinitionFixedMarkdown(v) -> json.string(v)
    ElementdefinitionFixedOid(v) -> json.string(v)
    ElementdefinitionFixedPositiveint(v) -> json.int(v)
    ElementdefinitionFixedString(v) -> json.string(v)
    ElementdefinitionFixedTime(v) -> pt.time_to_json(v)
    ElementdefinitionFixedUnsignedint(v) -> json.int(v)
    ElementdefinitionFixedUri(v) -> json.string(v)
    ElementdefinitionFixedUrl(v) -> json.string(v)
    ElementdefinitionFixedUuid(v) -> json.string(v)
    ElementdefinitionFixedAddress(v) -> address_to_json(v)
    ElementdefinitionFixedAge(v) -> age_to_json(v)
    ElementdefinitionFixedAnnotation(v) -> annotation_to_json(v)
    ElementdefinitionFixedAttachment(v) -> attachment_to_json(v)
    ElementdefinitionFixedCodeableconcept(v) -> codeableconcept_to_json(v)
    ElementdefinitionFixedCoding(v) -> coding_to_json(v)
    ElementdefinitionFixedContactpoint(v) -> contactpoint_to_json(v)
    ElementdefinitionFixedCount(v) -> count_to_json(v)
    ElementdefinitionFixedDistance(v) -> distance_to_json(v)
    ElementdefinitionFixedDuration(v) -> duration_to_json(v)
    ElementdefinitionFixedHumanname(v) -> humanname_to_json(v)
    ElementdefinitionFixedIdentifier(v) -> identifier_to_json(v)
    ElementdefinitionFixedMoney(v) -> money_to_json(v)
    ElementdefinitionFixedPeriod(v) -> period_to_json(v)
    ElementdefinitionFixedQuantity(v) -> quantity_to_json(v)
    ElementdefinitionFixedRange(v) -> range_to_json(v)
    ElementdefinitionFixedRatio(v) -> ratio_to_json(v)
    ElementdefinitionFixedReference(v) -> reference_to_json(v)
    ElementdefinitionFixedSampleddata(v) -> sampleddata_to_json(v)
    ElementdefinitionFixedSignature(v) -> signature_to_json(v)
    ElementdefinitionFixedTiming(v) -> timing_to_json(v)
    ElementdefinitionFixedContactdetail(v) -> contactdetail_to_json(v)
    ElementdefinitionFixedContributor(v) -> contributor_to_json(v)
    ElementdefinitionFixedDatarequirement(v) -> datarequirement_to_json(v)
    ElementdefinitionFixedExpression(v) -> expression_to_json(v)
    ElementdefinitionFixedParameterdefinition(v) ->
      parameterdefinition_to_json(v)
    ElementdefinitionFixedRelatedartifact(v) -> relatedartifact_to_json(v)
    ElementdefinitionFixedTriggerdefinition(v) -> triggerdefinition_to_json(v)
    ElementdefinitionFixedUsagecontext(v) -> usagecontext_to_json(v)
    ElementdefinitionFixedDosage(v) -> dosage_to_json(v)
    ElementdefinitionFixedMeta(v) -> meta_to_json(v)
  }
}

pub fn elementdefinition_fixed_decoder() -> Decoder(ElementdefinitionFixed) {
  decode.one_of(
    decode.field("fixedBase64Binary", decode.string, decode.success)
      |> decode.map(ElementdefinitionFixedBase64binary),
    [
      decode.field("fixedBoolean", decode.bool, decode.success)
        |> decode.map(ElementdefinitionFixedBoolean),
      decode.field("fixedCanonical", decode.string, decode.success)
        |> decode.map(ElementdefinitionFixedCanonical),
      decode.field("fixedCode", decode.string, decode.success)
        |> decode.map(ElementdefinitionFixedCode),
      decode.field("fixedDate", pt.date_decoder(), decode.success)
        |> decode.map(ElementdefinitionFixedDate),
      decode.field("fixedDateTime", pt.datetime_decoder(), decode.success)
        |> decode.map(ElementdefinitionFixedDatetime),
      decode.field("fixedDecimal", decode_number(), decode.success)
        |> decode.map(ElementdefinitionFixedDecimal),
      decode.field("fixedId", decode.string, decode.success)
        |> decode.map(ElementdefinitionFixedId),
      decode.field("fixedInstant", pt.instant_decoder(), decode.success)
        |> decode.map(ElementdefinitionFixedInstant),
      decode.field("fixedInteger", decode.int, decode.success)
        |> decode.map(ElementdefinitionFixedInteger),
      decode.field("fixedMarkdown", decode.string, decode.success)
        |> decode.map(ElementdefinitionFixedMarkdown),
      decode.field("fixedOid", decode.string, decode.success)
        |> decode.map(ElementdefinitionFixedOid),
      decode.field("fixedPositiveInt", decode.int, decode.success)
        |> decode.map(ElementdefinitionFixedPositiveint),
      decode.field("fixedString", decode.string, decode.success)
        |> decode.map(ElementdefinitionFixedString),
      decode.field("fixedTime", pt.time_decoder(), decode.success)
        |> decode.map(ElementdefinitionFixedTime),
      decode.field("fixedUnsignedInt", decode.int, decode.success)
        |> decode.map(ElementdefinitionFixedUnsignedint),
      decode.field("fixedUri", decode.string, decode.success)
        |> decode.map(ElementdefinitionFixedUri),
      decode.field("fixedUrl", decode.string, decode.success)
        |> decode.map(ElementdefinitionFixedUrl),
      decode.field("fixedUuid", decode.string, decode.success)
        |> decode.map(ElementdefinitionFixedUuid),
      decode.field("fixedAddress", address_decoder(), decode.success)
        |> decode.map(ElementdefinitionFixedAddress),
      decode.field("fixedAge", age_decoder(), decode.success)
        |> decode.map(ElementdefinitionFixedAge),
      decode.field("fixedAnnotation", annotation_decoder(), decode.success)
        |> decode.map(ElementdefinitionFixedAnnotation),
      decode.field("fixedAttachment", attachment_decoder(), decode.success)
        |> decode.map(ElementdefinitionFixedAttachment),
      decode.field(
        "fixedCodeableConcept",
        codeableconcept_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionFixedCodeableconcept),
      decode.field("fixedCoding", coding_decoder(), decode.success)
        |> decode.map(ElementdefinitionFixedCoding),
      decode.field("fixedContactPoint", contactpoint_decoder(), decode.success)
        |> decode.map(ElementdefinitionFixedContactpoint),
      decode.field("fixedCount", count_decoder(), decode.success)
        |> decode.map(ElementdefinitionFixedCount),
      decode.field("fixedDistance", distance_decoder(), decode.success)
        |> decode.map(ElementdefinitionFixedDistance),
      decode.field("fixedDuration", duration_decoder(), decode.success)
        |> decode.map(ElementdefinitionFixedDuration),
      decode.field("fixedHumanName", humanname_decoder(), decode.success)
        |> decode.map(ElementdefinitionFixedHumanname),
      decode.field("fixedIdentifier", identifier_decoder(), decode.success)
        |> decode.map(ElementdefinitionFixedIdentifier),
      decode.field("fixedMoney", money_decoder(), decode.success)
        |> decode.map(ElementdefinitionFixedMoney),
      decode.field("fixedPeriod", period_decoder(), decode.success)
        |> decode.map(ElementdefinitionFixedPeriod),
      decode.field("fixedQuantity", quantity_decoder(), decode.success)
        |> decode.map(ElementdefinitionFixedQuantity),
      decode.field("fixedRange", range_decoder(), decode.success)
        |> decode.map(ElementdefinitionFixedRange),
      decode.field("fixedRatio", ratio_decoder(), decode.success)
        |> decode.map(ElementdefinitionFixedRatio),
      decode.field("fixedReference", reference_decoder(), decode.success)
        |> decode.map(ElementdefinitionFixedReference),
      decode.field("fixedSampledData", sampleddata_decoder(), decode.success)
        |> decode.map(ElementdefinitionFixedSampleddata),
      decode.field("fixedSignature", signature_decoder(), decode.success)
        |> decode.map(ElementdefinitionFixedSignature),
      decode.field("fixedTiming", timing_decoder(), decode.success)
        |> decode.map(ElementdefinitionFixedTiming),
      decode.field(
        "fixedContactDetail",
        contactdetail_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionFixedContactdetail),
      decode.field("fixedContributor", contributor_decoder(), decode.success)
        |> decode.map(ElementdefinitionFixedContributor),
      decode.field(
        "fixedDataRequirement",
        datarequirement_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionFixedDatarequirement),
      decode.field("fixedExpression", expression_decoder(), decode.success)
        |> decode.map(ElementdefinitionFixedExpression),
      decode.field(
        "fixedParameterDefinition",
        parameterdefinition_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionFixedParameterdefinition),
      decode.field(
        "fixedRelatedArtifact",
        relatedartifact_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionFixedRelatedartifact),
      decode.field(
        "fixedTriggerDefinition",
        triggerdefinition_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionFixedTriggerdefinition),
      decode.field("fixedUsageContext", usagecontext_decoder(), decode.success)
        |> decode.map(ElementdefinitionFixedUsagecontext),
      decode.field("fixedDosage", dosage_decoder(), decode.success)
        |> decode.map(ElementdefinitionFixedDosage),
      decode.field("fixedMeta", meta_decoder(), decode.success)
        |> decode.map(ElementdefinitionFixedMeta),
    ],
  )
}

///[http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource](http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource)
pub type ElementdefinitionPattern {
  ElementdefinitionPatternBase64binary(pattern: String)
  ElementdefinitionPatternBoolean(pattern: Bool)
  ElementdefinitionPatternCanonical(pattern: String)
  ElementdefinitionPatternCode(pattern: String)
  ElementdefinitionPatternDate(pattern: Date)
  ElementdefinitionPatternDatetime(pattern: DateTime)
  ElementdefinitionPatternDecimal(pattern: Float)
  ElementdefinitionPatternId(pattern: String)
  ElementdefinitionPatternInstant(pattern: Instant)
  ElementdefinitionPatternInteger(pattern: Int)
  ElementdefinitionPatternMarkdown(pattern: String)
  ElementdefinitionPatternOid(pattern: String)
  ElementdefinitionPatternPositiveint(pattern: Int)
  ElementdefinitionPatternString(pattern: String)
  ElementdefinitionPatternTime(pattern: Time)
  ElementdefinitionPatternUnsignedint(pattern: Int)
  ElementdefinitionPatternUri(pattern: String)
  ElementdefinitionPatternUrl(pattern: String)
  ElementdefinitionPatternUuid(pattern: String)
  ElementdefinitionPatternAddress(pattern: Address)
  ElementdefinitionPatternAge(pattern: Age)
  ElementdefinitionPatternAnnotation(pattern: Annotation)
  ElementdefinitionPatternAttachment(pattern: Attachment)
  ElementdefinitionPatternCodeableconcept(pattern: Codeableconcept)
  ElementdefinitionPatternCoding(pattern: Coding)
  ElementdefinitionPatternContactpoint(pattern: Contactpoint)
  ElementdefinitionPatternCount(pattern: Count)
  ElementdefinitionPatternDistance(pattern: Distance)
  ElementdefinitionPatternDuration(pattern: Duration)
  ElementdefinitionPatternHumanname(pattern: Humanname)
  ElementdefinitionPatternIdentifier(pattern: Identifier)
  ElementdefinitionPatternMoney(pattern: Money)
  ElementdefinitionPatternPeriod(pattern: Period)
  ElementdefinitionPatternQuantity(pattern: Quantity)
  ElementdefinitionPatternRange(pattern: Range)
  ElementdefinitionPatternRatio(pattern: Ratio)
  ElementdefinitionPatternReference(pattern: Reference)
  ElementdefinitionPatternSampleddata(pattern: Sampleddata)
  ElementdefinitionPatternSignature(pattern: Signature)
  ElementdefinitionPatternTiming(pattern: Timing)
  ElementdefinitionPatternContactdetail(pattern: Contactdetail)
  ElementdefinitionPatternContributor(pattern: Contributor)
  ElementdefinitionPatternDatarequirement(pattern: Datarequirement)
  ElementdefinitionPatternExpression(pattern: Expression)
  ElementdefinitionPatternParameterdefinition(pattern: Parameterdefinition)
  ElementdefinitionPatternRelatedartifact(pattern: Relatedartifact)
  ElementdefinitionPatternTriggerdefinition(pattern: Triggerdefinition)
  ElementdefinitionPatternUsagecontext(pattern: Usagecontext)
  ElementdefinitionPatternDosage(pattern: Dosage)
  ElementdefinitionPatternMeta(pattern: Meta)
}

pub fn elementdefinition_pattern_to_json(elt: ElementdefinitionPattern) -> Json {
  case elt {
    ElementdefinitionPatternBase64binary(v) -> json.string(v)
    ElementdefinitionPatternBoolean(v) -> json.bool(v)
    ElementdefinitionPatternCanonical(v) -> json.string(v)
    ElementdefinitionPatternCode(v) -> json.string(v)
    ElementdefinitionPatternDate(v) -> pt.date_to_json(v)
    ElementdefinitionPatternDatetime(v) -> pt.datetime_to_json(v)
    ElementdefinitionPatternDecimal(v) -> json.float(v)
    ElementdefinitionPatternId(v) -> json.string(v)
    ElementdefinitionPatternInstant(v) -> pt.instant_to_json(v)
    ElementdefinitionPatternInteger(v) -> json.int(v)
    ElementdefinitionPatternMarkdown(v) -> json.string(v)
    ElementdefinitionPatternOid(v) -> json.string(v)
    ElementdefinitionPatternPositiveint(v) -> json.int(v)
    ElementdefinitionPatternString(v) -> json.string(v)
    ElementdefinitionPatternTime(v) -> pt.time_to_json(v)
    ElementdefinitionPatternUnsignedint(v) -> json.int(v)
    ElementdefinitionPatternUri(v) -> json.string(v)
    ElementdefinitionPatternUrl(v) -> json.string(v)
    ElementdefinitionPatternUuid(v) -> json.string(v)
    ElementdefinitionPatternAddress(v) -> address_to_json(v)
    ElementdefinitionPatternAge(v) -> age_to_json(v)
    ElementdefinitionPatternAnnotation(v) -> annotation_to_json(v)
    ElementdefinitionPatternAttachment(v) -> attachment_to_json(v)
    ElementdefinitionPatternCodeableconcept(v) -> codeableconcept_to_json(v)
    ElementdefinitionPatternCoding(v) -> coding_to_json(v)
    ElementdefinitionPatternContactpoint(v) -> contactpoint_to_json(v)
    ElementdefinitionPatternCount(v) -> count_to_json(v)
    ElementdefinitionPatternDistance(v) -> distance_to_json(v)
    ElementdefinitionPatternDuration(v) -> duration_to_json(v)
    ElementdefinitionPatternHumanname(v) -> humanname_to_json(v)
    ElementdefinitionPatternIdentifier(v) -> identifier_to_json(v)
    ElementdefinitionPatternMoney(v) -> money_to_json(v)
    ElementdefinitionPatternPeriod(v) -> period_to_json(v)
    ElementdefinitionPatternQuantity(v) -> quantity_to_json(v)
    ElementdefinitionPatternRange(v) -> range_to_json(v)
    ElementdefinitionPatternRatio(v) -> ratio_to_json(v)
    ElementdefinitionPatternReference(v) -> reference_to_json(v)
    ElementdefinitionPatternSampleddata(v) -> sampleddata_to_json(v)
    ElementdefinitionPatternSignature(v) -> signature_to_json(v)
    ElementdefinitionPatternTiming(v) -> timing_to_json(v)
    ElementdefinitionPatternContactdetail(v) -> contactdetail_to_json(v)
    ElementdefinitionPatternContributor(v) -> contributor_to_json(v)
    ElementdefinitionPatternDatarequirement(v) -> datarequirement_to_json(v)
    ElementdefinitionPatternExpression(v) -> expression_to_json(v)
    ElementdefinitionPatternParameterdefinition(v) ->
      parameterdefinition_to_json(v)
    ElementdefinitionPatternRelatedartifact(v) -> relatedartifact_to_json(v)
    ElementdefinitionPatternTriggerdefinition(v) -> triggerdefinition_to_json(v)
    ElementdefinitionPatternUsagecontext(v) -> usagecontext_to_json(v)
    ElementdefinitionPatternDosage(v) -> dosage_to_json(v)
    ElementdefinitionPatternMeta(v) -> meta_to_json(v)
  }
}

pub fn elementdefinition_pattern_decoder() -> Decoder(ElementdefinitionPattern) {
  decode.one_of(
    decode.field("patternBase64Binary", decode.string, decode.success)
      |> decode.map(ElementdefinitionPatternBase64binary),
    [
      decode.field("patternBoolean", decode.bool, decode.success)
        |> decode.map(ElementdefinitionPatternBoolean),
      decode.field("patternCanonical", decode.string, decode.success)
        |> decode.map(ElementdefinitionPatternCanonical),
      decode.field("patternCode", decode.string, decode.success)
        |> decode.map(ElementdefinitionPatternCode),
      decode.field("patternDate", pt.date_decoder(), decode.success)
        |> decode.map(ElementdefinitionPatternDate),
      decode.field("patternDateTime", pt.datetime_decoder(), decode.success)
        |> decode.map(ElementdefinitionPatternDatetime),
      decode.field("patternDecimal", decode_number(), decode.success)
        |> decode.map(ElementdefinitionPatternDecimal),
      decode.field("patternId", decode.string, decode.success)
        |> decode.map(ElementdefinitionPatternId),
      decode.field("patternInstant", pt.instant_decoder(), decode.success)
        |> decode.map(ElementdefinitionPatternInstant),
      decode.field("patternInteger", decode.int, decode.success)
        |> decode.map(ElementdefinitionPatternInteger),
      decode.field("patternMarkdown", decode.string, decode.success)
        |> decode.map(ElementdefinitionPatternMarkdown),
      decode.field("patternOid", decode.string, decode.success)
        |> decode.map(ElementdefinitionPatternOid),
      decode.field("patternPositiveInt", decode.int, decode.success)
        |> decode.map(ElementdefinitionPatternPositiveint),
      decode.field("patternString", decode.string, decode.success)
        |> decode.map(ElementdefinitionPatternString),
      decode.field("patternTime", pt.time_decoder(), decode.success)
        |> decode.map(ElementdefinitionPatternTime),
      decode.field("patternUnsignedInt", decode.int, decode.success)
        |> decode.map(ElementdefinitionPatternUnsignedint),
      decode.field("patternUri", decode.string, decode.success)
        |> decode.map(ElementdefinitionPatternUri),
      decode.field("patternUrl", decode.string, decode.success)
        |> decode.map(ElementdefinitionPatternUrl),
      decode.field("patternUuid", decode.string, decode.success)
        |> decode.map(ElementdefinitionPatternUuid),
      decode.field("patternAddress", address_decoder(), decode.success)
        |> decode.map(ElementdefinitionPatternAddress),
      decode.field("patternAge", age_decoder(), decode.success)
        |> decode.map(ElementdefinitionPatternAge),
      decode.field("patternAnnotation", annotation_decoder(), decode.success)
        |> decode.map(ElementdefinitionPatternAnnotation),
      decode.field("patternAttachment", attachment_decoder(), decode.success)
        |> decode.map(ElementdefinitionPatternAttachment),
      decode.field(
        "patternCodeableConcept",
        codeableconcept_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionPatternCodeableconcept),
      decode.field("patternCoding", coding_decoder(), decode.success)
        |> decode.map(ElementdefinitionPatternCoding),
      decode.field(
        "patternContactPoint",
        contactpoint_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionPatternContactpoint),
      decode.field("patternCount", count_decoder(), decode.success)
        |> decode.map(ElementdefinitionPatternCount),
      decode.field("patternDistance", distance_decoder(), decode.success)
        |> decode.map(ElementdefinitionPatternDistance),
      decode.field("patternDuration", duration_decoder(), decode.success)
        |> decode.map(ElementdefinitionPatternDuration),
      decode.field("patternHumanName", humanname_decoder(), decode.success)
        |> decode.map(ElementdefinitionPatternHumanname),
      decode.field("patternIdentifier", identifier_decoder(), decode.success)
        |> decode.map(ElementdefinitionPatternIdentifier),
      decode.field("patternMoney", money_decoder(), decode.success)
        |> decode.map(ElementdefinitionPatternMoney),
      decode.field("patternPeriod", period_decoder(), decode.success)
        |> decode.map(ElementdefinitionPatternPeriod),
      decode.field("patternQuantity", quantity_decoder(), decode.success)
        |> decode.map(ElementdefinitionPatternQuantity),
      decode.field("patternRange", range_decoder(), decode.success)
        |> decode.map(ElementdefinitionPatternRange),
      decode.field("patternRatio", ratio_decoder(), decode.success)
        |> decode.map(ElementdefinitionPatternRatio),
      decode.field("patternReference", reference_decoder(), decode.success)
        |> decode.map(ElementdefinitionPatternReference),
      decode.field("patternSampledData", sampleddata_decoder(), decode.success)
        |> decode.map(ElementdefinitionPatternSampleddata),
      decode.field("patternSignature", signature_decoder(), decode.success)
        |> decode.map(ElementdefinitionPatternSignature),
      decode.field("patternTiming", timing_decoder(), decode.success)
        |> decode.map(ElementdefinitionPatternTiming),
      decode.field(
        "patternContactDetail",
        contactdetail_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionPatternContactdetail),
      decode.field("patternContributor", contributor_decoder(), decode.success)
        |> decode.map(ElementdefinitionPatternContributor),
      decode.field(
        "patternDataRequirement",
        datarequirement_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionPatternDatarequirement),
      decode.field("patternExpression", expression_decoder(), decode.success)
        |> decode.map(ElementdefinitionPatternExpression),
      decode.field(
        "patternParameterDefinition",
        parameterdefinition_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionPatternParameterdefinition),
      decode.field(
        "patternRelatedArtifact",
        relatedartifact_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionPatternRelatedartifact),
      decode.field(
        "patternTriggerDefinition",
        triggerdefinition_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionPatternTriggerdefinition),
      decode.field(
        "patternUsageContext",
        usagecontext_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionPatternUsagecontext),
      decode.field("patternDosage", dosage_decoder(), decode.success)
        |> decode.map(ElementdefinitionPatternDosage),
      decode.field("patternMeta", meta_decoder(), decode.success)
        |> decode.map(ElementdefinitionPatternMeta),
    ],
  )
}

///[http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource](http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource)
pub type ElementdefinitionMinvalue {
  ElementdefinitionMinvalueDate(min_value: Date)
  ElementdefinitionMinvalueDatetime(min_value: DateTime)
  ElementdefinitionMinvalueInstant(min_value: Instant)
  ElementdefinitionMinvalueTime(min_value: Time)
  ElementdefinitionMinvalueDecimal(min_value: Float)
  ElementdefinitionMinvalueInteger(min_value: Int)
  ElementdefinitionMinvaluePositiveint(min_value: Int)
  ElementdefinitionMinvalueUnsignedint(min_value: Int)
  ElementdefinitionMinvalueQuantity(min_value: Quantity)
}

pub fn elementdefinition_minvalue_to_json(
  elt: ElementdefinitionMinvalue,
) -> Json {
  case elt {
    ElementdefinitionMinvalueDate(v) -> pt.date_to_json(v)
    ElementdefinitionMinvalueDatetime(v) -> pt.datetime_to_json(v)
    ElementdefinitionMinvalueInstant(v) -> pt.instant_to_json(v)
    ElementdefinitionMinvalueTime(v) -> pt.time_to_json(v)
    ElementdefinitionMinvalueDecimal(v) -> json.float(v)
    ElementdefinitionMinvalueInteger(v) -> json.int(v)
    ElementdefinitionMinvaluePositiveint(v) -> json.int(v)
    ElementdefinitionMinvalueUnsignedint(v) -> json.int(v)
    ElementdefinitionMinvalueQuantity(v) -> quantity_to_json(v)
  }
}

pub fn elementdefinition_minvalue_decoder() -> Decoder(
  ElementdefinitionMinvalue,
) {
  decode.one_of(
    decode.field("minValueDate", pt.date_decoder(), decode.success)
      |> decode.map(ElementdefinitionMinvalueDate),
    [
      decode.field("minValueDateTime", pt.datetime_decoder(), decode.success)
        |> decode.map(ElementdefinitionMinvalueDatetime),
      decode.field("minValueInstant", pt.instant_decoder(), decode.success)
        |> decode.map(ElementdefinitionMinvalueInstant),
      decode.field("minValueTime", pt.time_decoder(), decode.success)
        |> decode.map(ElementdefinitionMinvalueTime),
      decode.field("minValueDecimal", decode_number(), decode.success)
        |> decode.map(ElementdefinitionMinvalueDecimal),
      decode.field("minValueInteger", decode.int, decode.success)
        |> decode.map(ElementdefinitionMinvalueInteger),
      decode.field("minValuePositiveInt", decode.int, decode.success)
        |> decode.map(ElementdefinitionMinvaluePositiveint),
      decode.field("minValueUnsignedInt", decode.int, decode.success)
        |> decode.map(ElementdefinitionMinvalueUnsignedint),
      decode.field("minValueQuantity", quantity_decoder(), decode.success)
        |> decode.map(ElementdefinitionMinvalueQuantity),
    ],
  )
}

///[http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource](http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource)
pub type ElementdefinitionMaxvalue {
  ElementdefinitionMaxvalueDate(max_value: Date)
  ElementdefinitionMaxvalueDatetime(max_value: DateTime)
  ElementdefinitionMaxvalueInstant(max_value: Instant)
  ElementdefinitionMaxvalueTime(max_value: Time)
  ElementdefinitionMaxvalueDecimal(max_value: Float)
  ElementdefinitionMaxvalueInteger(max_value: Int)
  ElementdefinitionMaxvaluePositiveint(max_value: Int)
  ElementdefinitionMaxvalueUnsignedint(max_value: Int)
  ElementdefinitionMaxvalueQuantity(max_value: Quantity)
}

pub fn elementdefinition_maxvalue_to_json(
  elt: ElementdefinitionMaxvalue,
) -> Json {
  case elt {
    ElementdefinitionMaxvalueDate(v) -> pt.date_to_json(v)
    ElementdefinitionMaxvalueDatetime(v) -> pt.datetime_to_json(v)
    ElementdefinitionMaxvalueInstant(v) -> pt.instant_to_json(v)
    ElementdefinitionMaxvalueTime(v) -> pt.time_to_json(v)
    ElementdefinitionMaxvalueDecimal(v) -> json.float(v)
    ElementdefinitionMaxvalueInteger(v) -> json.int(v)
    ElementdefinitionMaxvaluePositiveint(v) -> json.int(v)
    ElementdefinitionMaxvalueUnsignedint(v) -> json.int(v)
    ElementdefinitionMaxvalueQuantity(v) -> quantity_to_json(v)
  }
}

pub fn elementdefinition_maxvalue_decoder() -> Decoder(
  ElementdefinitionMaxvalue,
) {
  decode.one_of(
    decode.field("maxValueDate", pt.date_decoder(), decode.success)
      |> decode.map(ElementdefinitionMaxvalueDate),
    [
      decode.field("maxValueDateTime", pt.datetime_decoder(), decode.success)
        |> decode.map(ElementdefinitionMaxvalueDatetime),
      decode.field("maxValueInstant", pt.instant_decoder(), decode.success)
        |> decode.map(ElementdefinitionMaxvalueInstant),
      decode.field("maxValueTime", pt.time_decoder(), decode.success)
        |> decode.map(ElementdefinitionMaxvalueTime),
      decode.field("maxValueDecimal", decode_number(), decode.success)
        |> decode.map(ElementdefinitionMaxvalueDecimal),
      decode.field("maxValueInteger", decode.int, decode.success)
        |> decode.map(ElementdefinitionMaxvalueInteger),
      decode.field("maxValuePositiveInt", decode.int, decode.success)
        |> decode.map(ElementdefinitionMaxvaluePositiveint),
      decode.field("maxValueUnsignedInt", decode.int, decode.success)
        |> decode.map(ElementdefinitionMaxvalueUnsignedint),
      decode.field("maxValueQuantity", quantity_decoder(), decode.success)
        |> decode.map(ElementdefinitionMaxvalueQuantity),
    ],
  )
}

pub fn elementdefinition_new(path path: String) -> Elementdefinition {
  Elementdefinition(
    mapping: [],
    binding: None,
    is_summary: None,
    is_modifier_reason: None,
    is_modifier: None,
    must_support: None,
    constraint: [],
    condition: [],
    max_length: None,
    max_value: None,
    min_value: None,
    example: [],
    pattern: None,
    fixed: None,
    order_meaning: None,
    meaning_when_missing: None,
    default_value: None,
    type_: [],
    content_reference: None,
    base: None,
    max: None,
    min: None,
    alias: [],
    requirements: None,
    comment: None,
    definition: None,
    short: None,
    slicing: None,
    code: [],
    label: None,
    slice_is_constraining: None,
    slice_name: None,
    representation: [],
    path:,
    modifier_extension: [],
    extension: [],
    id: None,
    uscdi_requirement: [],
  )
}

///[http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource](http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource)
pub type ElementdefinitionSlicing {
  ElementdefinitionSlicing(
    id: Option(String),
    extension: List(Extension),
    discriminator: List(ElementdefinitionSlicingDiscriminator),
    description: Option(String),
    ordered: Option(Bool),
    rules: valuesets.Resourceslicingrules,
  )
}

pub fn elementdefinition_slicing_new(
  rules rules: valuesets.Resourceslicingrules,
) -> ElementdefinitionSlicing {
  ElementdefinitionSlicing(
    rules:,
    ordered: None,
    description: None,
    discriminator: [],
    extension: [],
    id: None,
  )
}

///[http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource](http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource)
pub type ElementdefinitionSlicingDiscriminator {
  ElementdefinitionSlicingDiscriminator(
    id: Option(String),
    extension: List(Extension),
    type_: valuesets.Discriminatortype,
    path: String,
  )
}

pub fn elementdefinition_slicing_discriminator_new(
  path path: String,
  type_ type_: valuesets.Discriminatortype,
) -> ElementdefinitionSlicingDiscriminator {
  ElementdefinitionSlicingDiscriminator(path:, type_:, extension: [], id: None)
}

///[http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource](http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource)
pub type ElementdefinitionBase {
  ElementdefinitionBase(
    id: Option(String),
    extension: List(Extension),
    path: String,
    min: Int,
    max: String,
  )
}

pub fn elementdefinition_base_new(
  max max: String,
  min min: Int,
  path path: String,
) -> ElementdefinitionBase {
  ElementdefinitionBase(max:, min:, path:, extension: [], id: None)
}

///[http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource](http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource)
pub type ElementdefinitionType {
  ElementdefinitionType(
    id: Option(String),
    extension: List(Extension),
    code: String,
    profile: List(String),
    target_profile: List(String),
    aggregation: List(valuesets.Resourceaggregationmode),
    versioning: Option(valuesets.Referenceversionrules),
  )
}

pub fn elementdefinition_type_new(code code: String) -> ElementdefinitionType {
  ElementdefinitionType(
    versioning: None,
    aggregation: [],
    target_profile: [],
    profile: [],
    code:,
    extension: [],
    id: None,
  )
}

///[http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource](http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource)
pub type ElementdefinitionExample {
  ElementdefinitionExample(
    id: Option(String),
    extension: List(Extension),
    label: String,
    value: ElementdefinitionExampleValue,
  )
}

///[http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource](http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource)
pub type ElementdefinitionExampleValue {
  ElementdefinitionExampleValueBase64binary(value: String)
  ElementdefinitionExampleValueBoolean(value: Bool)
  ElementdefinitionExampleValueCanonical(value: String)
  ElementdefinitionExampleValueCode(value: String)
  ElementdefinitionExampleValueDate(value: Date)
  ElementdefinitionExampleValueDatetime(value: DateTime)
  ElementdefinitionExampleValueDecimal(value: Float)
  ElementdefinitionExampleValueId(value: String)
  ElementdefinitionExampleValueInstant(value: Instant)
  ElementdefinitionExampleValueInteger(value: Int)
  ElementdefinitionExampleValueMarkdown(value: String)
  ElementdefinitionExampleValueOid(value: String)
  ElementdefinitionExampleValuePositiveint(value: Int)
  ElementdefinitionExampleValueString(value: String)
  ElementdefinitionExampleValueTime(value: Time)
  ElementdefinitionExampleValueUnsignedint(value: Int)
  ElementdefinitionExampleValueUri(value: String)
  ElementdefinitionExampleValueUrl(value: String)
  ElementdefinitionExampleValueUuid(value: String)
  ElementdefinitionExampleValueAddress(value: Address)
  ElementdefinitionExampleValueAge(value: Age)
  ElementdefinitionExampleValueAnnotation(value: Annotation)
  ElementdefinitionExampleValueAttachment(value: Attachment)
  ElementdefinitionExampleValueCodeableconcept(value: Codeableconcept)
  ElementdefinitionExampleValueCoding(value: Coding)
  ElementdefinitionExampleValueContactpoint(value: Contactpoint)
  ElementdefinitionExampleValueCount(value: Count)
  ElementdefinitionExampleValueDistance(value: Distance)
  ElementdefinitionExampleValueDuration(value: Duration)
  ElementdefinitionExampleValueHumanname(value: Humanname)
  ElementdefinitionExampleValueIdentifier(value: Identifier)
  ElementdefinitionExampleValueMoney(value: Money)
  ElementdefinitionExampleValuePeriod(value: Period)
  ElementdefinitionExampleValueQuantity(value: Quantity)
  ElementdefinitionExampleValueRange(value: Range)
  ElementdefinitionExampleValueRatio(value: Ratio)
  ElementdefinitionExampleValueReference(value: Reference)
  ElementdefinitionExampleValueSampleddata(value: Sampleddata)
  ElementdefinitionExampleValueSignature(value: Signature)
  ElementdefinitionExampleValueTiming(value: Timing)
  ElementdefinitionExampleValueContactdetail(value: Contactdetail)
  ElementdefinitionExampleValueContributor(value: Contributor)
  ElementdefinitionExampleValueDatarequirement(value: Datarequirement)
  ElementdefinitionExampleValueExpression(value: Expression)
  ElementdefinitionExampleValueParameterdefinition(value: Parameterdefinition)
  ElementdefinitionExampleValueRelatedartifact(value: Relatedartifact)
  ElementdefinitionExampleValueTriggerdefinition(value: Triggerdefinition)
  ElementdefinitionExampleValueUsagecontext(value: Usagecontext)
  ElementdefinitionExampleValueDosage(value: Dosage)
  ElementdefinitionExampleValueMeta(value: Meta)
}

pub fn elementdefinition_example_value_to_json(
  elt: ElementdefinitionExampleValue,
) -> Json {
  case elt {
    ElementdefinitionExampleValueBase64binary(v) -> json.string(v)
    ElementdefinitionExampleValueBoolean(v) -> json.bool(v)
    ElementdefinitionExampleValueCanonical(v) -> json.string(v)
    ElementdefinitionExampleValueCode(v) -> json.string(v)
    ElementdefinitionExampleValueDate(v) -> pt.date_to_json(v)
    ElementdefinitionExampleValueDatetime(v) -> pt.datetime_to_json(v)
    ElementdefinitionExampleValueDecimal(v) -> json.float(v)
    ElementdefinitionExampleValueId(v) -> json.string(v)
    ElementdefinitionExampleValueInstant(v) -> pt.instant_to_json(v)
    ElementdefinitionExampleValueInteger(v) -> json.int(v)
    ElementdefinitionExampleValueMarkdown(v) -> json.string(v)
    ElementdefinitionExampleValueOid(v) -> json.string(v)
    ElementdefinitionExampleValuePositiveint(v) -> json.int(v)
    ElementdefinitionExampleValueString(v) -> json.string(v)
    ElementdefinitionExampleValueTime(v) -> pt.time_to_json(v)
    ElementdefinitionExampleValueUnsignedint(v) -> json.int(v)
    ElementdefinitionExampleValueUri(v) -> json.string(v)
    ElementdefinitionExampleValueUrl(v) -> json.string(v)
    ElementdefinitionExampleValueUuid(v) -> json.string(v)
    ElementdefinitionExampleValueAddress(v) -> address_to_json(v)
    ElementdefinitionExampleValueAge(v) -> age_to_json(v)
    ElementdefinitionExampleValueAnnotation(v) -> annotation_to_json(v)
    ElementdefinitionExampleValueAttachment(v) -> attachment_to_json(v)
    ElementdefinitionExampleValueCodeableconcept(v) ->
      codeableconcept_to_json(v)
    ElementdefinitionExampleValueCoding(v) -> coding_to_json(v)
    ElementdefinitionExampleValueContactpoint(v) -> contactpoint_to_json(v)
    ElementdefinitionExampleValueCount(v) -> count_to_json(v)
    ElementdefinitionExampleValueDistance(v) -> distance_to_json(v)
    ElementdefinitionExampleValueDuration(v) -> duration_to_json(v)
    ElementdefinitionExampleValueHumanname(v) -> humanname_to_json(v)
    ElementdefinitionExampleValueIdentifier(v) -> identifier_to_json(v)
    ElementdefinitionExampleValueMoney(v) -> money_to_json(v)
    ElementdefinitionExampleValuePeriod(v) -> period_to_json(v)
    ElementdefinitionExampleValueQuantity(v) -> quantity_to_json(v)
    ElementdefinitionExampleValueRange(v) -> range_to_json(v)
    ElementdefinitionExampleValueRatio(v) -> ratio_to_json(v)
    ElementdefinitionExampleValueReference(v) -> reference_to_json(v)
    ElementdefinitionExampleValueSampleddata(v) -> sampleddata_to_json(v)
    ElementdefinitionExampleValueSignature(v) -> signature_to_json(v)
    ElementdefinitionExampleValueTiming(v) -> timing_to_json(v)
    ElementdefinitionExampleValueContactdetail(v) -> contactdetail_to_json(v)
    ElementdefinitionExampleValueContributor(v) -> contributor_to_json(v)
    ElementdefinitionExampleValueDatarequirement(v) ->
      datarequirement_to_json(v)
    ElementdefinitionExampleValueExpression(v) -> expression_to_json(v)
    ElementdefinitionExampleValueParameterdefinition(v) ->
      parameterdefinition_to_json(v)
    ElementdefinitionExampleValueRelatedartifact(v) ->
      relatedartifact_to_json(v)
    ElementdefinitionExampleValueTriggerdefinition(v) ->
      triggerdefinition_to_json(v)
    ElementdefinitionExampleValueUsagecontext(v) -> usagecontext_to_json(v)
    ElementdefinitionExampleValueDosage(v) -> dosage_to_json(v)
    ElementdefinitionExampleValueMeta(v) -> meta_to_json(v)
  }
}

pub fn elementdefinition_example_value_decoder() -> Decoder(
  ElementdefinitionExampleValue,
) {
  decode.one_of(
    decode.field("valueBase64Binary", decode.string, decode.success)
      |> decode.map(ElementdefinitionExampleValueBase64binary),
    [
      decode.field("valueBoolean", decode.bool, decode.success)
        |> decode.map(ElementdefinitionExampleValueBoolean),
      decode.field("valueCanonical", decode.string, decode.success)
        |> decode.map(ElementdefinitionExampleValueCanonical),
      decode.field("valueCode", decode.string, decode.success)
        |> decode.map(ElementdefinitionExampleValueCode),
      decode.field("valueDate", pt.date_decoder(), decode.success)
        |> decode.map(ElementdefinitionExampleValueDate),
      decode.field("valueDateTime", pt.datetime_decoder(), decode.success)
        |> decode.map(ElementdefinitionExampleValueDatetime),
      decode.field("valueDecimal", decode_number(), decode.success)
        |> decode.map(ElementdefinitionExampleValueDecimal),
      decode.field("valueId", decode.string, decode.success)
        |> decode.map(ElementdefinitionExampleValueId),
      decode.field("valueInstant", pt.instant_decoder(), decode.success)
        |> decode.map(ElementdefinitionExampleValueInstant),
      decode.field("valueInteger", decode.int, decode.success)
        |> decode.map(ElementdefinitionExampleValueInteger),
      decode.field("valueMarkdown", decode.string, decode.success)
        |> decode.map(ElementdefinitionExampleValueMarkdown),
      decode.field("valueOid", decode.string, decode.success)
        |> decode.map(ElementdefinitionExampleValueOid),
      decode.field("valuePositiveInt", decode.int, decode.success)
        |> decode.map(ElementdefinitionExampleValuePositiveint),
      decode.field("valueString", decode.string, decode.success)
        |> decode.map(ElementdefinitionExampleValueString),
      decode.field("valueTime", pt.time_decoder(), decode.success)
        |> decode.map(ElementdefinitionExampleValueTime),
      decode.field("valueUnsignedInt", decode.int, decode.success)
        |> decode.map(ElementdefinitionExampleValueUnsignedint),
      decode.field("valueUri", decode.string, decode.success)
        |> decode.map(ElementdefinitionExampleValueUri),
      decode.field("valueUrl", decode.string, decode.success)
        |> decode.map(ElementdefinitionExampleValueUrl),
      decode.field("valueUuid", decode.string, decode.success)
        |> decode.map(ElementdefinitionExampleValueUuid),
      decode.field("valueAddress", address_decoder(), decode.success)
        |> decode.map(ElementdefinitionExampleValueAddress),
      decode.field("valueAge", age_decoder(), decode.success)
        |> decode.map(ElementdefinitionExampleValueAge),
      decode.field("valueAnnotation", annotation_decoder(), decode.success)
        |> decode.map(ElementdefinitionExampleValueAnnotation),
      decode.field("valueAttachment", attachment_decoder(), decode.success)
        |> decode.map(ElementdefinitionExampleValueAttachment),
      decode.field(
        "valueCodeableConcept",
        codeableconcept_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionExampleValueCodeableconcept),
      decode.field("valueCoding", coding_decoder(), decode.success)
        |> decode.map(ElementdefinitionExampleValueCoding),
      decode.field("valueContactPoint", contactpoint_decoder(), decode.success)
        |> decode.map(ElementdefinitionExampleValueContactpoint),
      decode.field("valueCount", count_decoder(), decode.success)
        |> decode.map(ElementdefinitionExampleValueCount),
      decode.field("valueDistance", distance_decoder(), decode.success)
        |> decode.map(ElementdefinitionExampleValueDistance),
      decode.field("valueDuration", duration_decoder(), decode.success)
        |> decode.map(ElementdefinitionExampleValueDuration),
      decode.field("valueHumanName", humanname_decoder(), decode.success)
        |> decode.map(ElementdefinitionExampleValueHumanname),
      decode.field("valueIdentifier", identifier_decoder(), decode.success)
        |> decode.map(ElementdefinitionExampleValueIdentifier),
      decode.field("valueMoney", money_decoder(), decode.success)
        |> decode.map(ElementdefinitionExampleValueMoney),
      decode.field("valuePeriod", period_decoder(), decode.success)
        |> decode.map(ElementdefinitionExampleValuePeriod),
      decode.field("valueQuantity", quantity_decoder(), decode.success)
        |> decode.map(ElementdefinitionExampleValueQuantity),
      decode.field("valueRange", range_decoder(), decode.success)
        |> decode.map(ElementdefinitionExampleValueRange),
      decode.field("valueRatio", ratio_decoder(), decode.success)
        |> decode.map(ElementdefinitionExampleValueRatio),
      decode.field("valueReference", reference_decoder(), decode.success)
        |> decode.map(ElementdefinitionExampleValueReference),
      decode.field("valueSampledData", sampleddata_decoder(), decode.success)
        |> decode.map(ElementdefinitionExampleValueSampleddata),
      decode.field("valueSignature", signature_decoder(), decode.success)
        |> decode.map(ElementdefinitionExampleValueSignature),
      decode.field("valueTiming", timing_decoder(), decode.success)
        |> decode.map(ElementdefinitionExampleValueTiming),
      decode.field(
        "valueContactDetail",
        contactdetail_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionExampleValueContactdetail),
      decode.field("valueContributor", contributor_decoder(), decode.success)
        |> decode.map(ElementdefinitionExampleValueContributor),
      decode.field(
        "valueDataRequirement",
        datarequirement_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionExampleValueDatarequirement),
      decode.field("valueExpression", expression_decoder(), decode.success)
        |> decode.map(ElementdefinitionExampleValueExpression),
      decode.field(
        "valueParameterDefinition",
        parameterdefinition_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionExampleValueParameterdefinition),
      decode.field(
        "valueRelatedArtifact",
        relatedartifact_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionExampleValueRelatedartifact),
      decode.field(
        "valueTriggerDefinition",
        triggerdefinition_decoder(),
        decode.success,
      )
        |> decode.map(ElementdefinitionExampleValueTriggerdefinition),
      decode.field("valueUsageContext", usagecontext_decoder(), decode.success)
        |> decode.map(ElementdefinitionExampleValueUsagecontext),
      decode.field("valueDosage", dosage_decoder(), decode.success)
        |> decode.map(ElementdefinitionExampleValueDosage),
      decode.field("valueMeta", meta_decoder(), decode.success)
        |> decode.map(ElementdefinitionExampleValueMeta),
    ],
  )
}

pub fn elementdefinition_example_new(
  value value: ElementdefinitionExampleValue,
  label label: String,
) -> ElementdefinitionExample {
  ElementdefinitionExample(value:, label:, extension: [], id: None)
}

///[http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource](http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource)
pub type ElementdefinitionConstraint {
  ElementdefinitionConstraint(
    id: Option(String),
    extension: List(Extension),
    key: String,
    requirements: Option(String),
    severity: valuesets.Constraintseverity,
    human: String,
    expression: Option(String),
    xpath: Option(String),
    source: Option(String),
  )
}

pub fn elementdefinition_constraint_new(
  human human: String,
  severity severity: valuesets.Constraintseverity,
  key key: String,
) -> ElementdefinitionConstraint {
  ElementdefinitionConstraint(
    source: None,
    xpath: None,
    expression: None,
    human:,
    severity:,
    requirements: None,
    key:,
    extension: [],
    id: None,
  )
}

///[http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource](http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource)
pub type ElementdefinitionBinding {
  ElementdefinitionBinding(
    id: Option(String),
    extension: List(Extension),
    strength: valuesets.Bindingstrength,
    description: Option(String),
    value_set: Option(String),
  )
}

pub fn elementdefinition_binding_new(
  strength strength: valuesets.Bindingstrength,
) -> ElementdefinitionBinding {
  ElementdefinitionBinding(
    value_set: None,
    description: None,
    strength:,
    extension: [],
    id: None,
  )
}

///[http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource](http://hl7.org/fhir/r4us/StructureDefinition/ElementDefinition#resource)
pub type ElementdefinitionMapping {
  ElementdefinitionMapping(
    id: Option(String),
    extension: List(Extension),
    identity: String,
    language: Option(String),
    map: String,
    comment: Option(String),
  )
}

pub fn elementdefinition_mapping_new(
  map map: String,
  identity identity: String,
) -> ElementdefinitionMapping {
  ElementdefinitionMapping(
    comment: None,
    map:,
    language: None,
    identity:,
    extension: [],
    id: None,
  )
}

pub fn elementdefinition_mapping_to_json(
  elementdefinition_mapping: ElementdefinitionMapping,
) -> Json {
  let ElementdefinitionMapping(
    comment:,
    map:,
    language:,
    identity:,
    extension:,
    id:,
  ) = elementdefinition_mapping
  let fields = [
    #("map", json.string(map)),
    #("identity", json.string(identity)),
  ]
  let fields = case comment {
    Some(v) -> [#("comment", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case language {
    Some(v) -> [#("language", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn elementdefinition_mapping_decoder() -> Decoder(ElementdefinitionMapping) {
  use <- decode.recursive
  use comment <- decode.optional_field(
    "comment",
    None,
    decode.optional(decode.string),
  )
  use map <- decode.field("map", decode.string)
  use language <- decode.optional_field(
    "language",
    None,
    decode.optional(decode.string),
  )
  use identity <- decode.field("identity", decode.string)
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(ElementdefinitionMapping(
    comment:,
    map:,
    language:,
    identity:,
    extension:,
    id:,
  ))
}

pub fn elementdefinition_binding_to_json(
  elementdefinition_binding: ElementdefinitionBinding,
) -> Json {
  let ElementdefinitionBinding(
    value_set:,
    description:,
    strength:,
    extension:,
    id:,
  ) = elementdefinition_binding
  let fields = [
    #("strength", valuesets.bindingstrength_to_json(strength)),
  ]
  let fields = case value_set {
    Some(v) -> [#("valueSet", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case description {
    Some(v) -> [#("description", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn elementdefinition_binding_decoder() -> Decoder(ElementdefinitionBinding) {
  use <- decode.recursive
  use value_set <- decode.optional_field(
    "valueSet",
    None,
    decode.optional(decode.string),
  )
  use description <- decode.optional_field(
    "description",
    None,
    decode.optional(decode.string),
  )
  use strength <- decode.field("strength", valuesets.bindingstrength_decoder())
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(ElementdefinitionBinding(
    value_set:,
    description:,
    strength:,
    extension:,
    id:,
  ))
}

pub fn elementdefinition_constraint_to_json(
  elementdefinition_constraint: ElementdefinitionConstraint,
) -> Json {
  let ElementdefinitionConstraint(
    source:,
    xpath:,
    expression:,
    human:,
    severity:,
    requirements:,
    key:,
    extension:,
    id:,
  ) = elementdefinition_constraint
  let fields = [
    #("human", json.string(human)),
    #("severity", valuesets.constraintseverity_to_json(severity)),
    #("key", json.string(key)),
  ]
  let fields = case source {
    Some(v) -> [#("source", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case xpath {
    Some(v) -> [#("xpath", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case expression {
    Some(v) -> [#("expression", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case requirements {
    Some(v) -> [#("requirements", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn elementdefinition_constraint_decoder() -> Decoder(
  ElementdefinitionConstraint,
) {
  use <- decode.recursive
  use source <- decode.optional_field(
    "source",
    None,
    decode.optional(decode.string),
  )
  use xpath <- decode.optional_field(
    "xpath",
    None,
    decode.optional(decode.string),
  )
  use expression <- decode.optional_field(
    "expression",
    None,
    decode.optional(decode.string),
  )
  use human <- decode.field("human", decode.string)
  use severity <- decode.field(
    "severity",
    valuesets.constraintseverity_decoder(),
  )
  use requirements <- decode.optional_field(
    "requirements",
    None,
    decode.optional(decode.string),
  )
  use key <- decode.field("key", decode.string)
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(ElementdefinitionConstraint(
    source:,
    xpath:,
    expression:,
    human:,
    severity:,
    requirements:,
    key:,
    extension:,
    id:,
  ))
}

pub fn elementdefinition_example_to_json(
  elementdefinition_example: ElementdefinitionExample,
) -> Json {
  let ElementdefinitionExample(value:, label:, extension:, id:) =
    elementdefinition_example
  let fields = [
    #(
      "value"
        <> case value {
        ElementdefinitionExampleValueBase64binary(_) -> "Base64Binary"
        ElementdefinitionExampleValueBoolean(_) -> "Boolean"
        ElementdefinitionExampleValueCanonical(_) -> "Canonical"
        ElementdefinitionExampleValueCode(_) -> "Code"
        ElementdefinitionExampleValueDate(_) -> "Date"
        ElementdefinitionExampleValueDatetime(_) -> "DateTime"
        ElementdefinitionExampleValueDecimal(_) -> "Decimal"
        ElementdefinitionExampleValueId(_) -> "Id"
        ElementdefinitionExampleValueInstant(_) -> "Instant"
        ElementdefinitionExampleValueInteger(_) -> "Integer"
        ElementdefinitionExampleValueMarkdown(_) -> "Markdown"
        ElementdefinitionExampleValueOid(_) -> "Oid"
        ElementdefinitionExampleValuePositiveint(_) -> "PositiveInt"
        ElementdefinitionExampleValueString(_) -> "String"
        ElementdefinitionExampleValueTime(_) -> "Time"
        ElementdefinitionExampleValueUnsignedint(_) -> "UnsignedInt"
        ElementdefinitionExampleValueUri(_) -> "Uri"
        ElementdefinitionExampleValueUrl(_) -> "Url"
        ElementdefinitionExampleValueUuid(_) -> "Uuid"
        ElementdefinitionExampleValueAddress(_) -> "Address"
        ElementdefinitionExampleValueAge(_) -> "Age"
        ElementdefinitionExampleValueAnnotation(_) -> "Annotation"
        ElementdefinitionExampleValueAttachment(_) -> "Attachment"
        ElementdefinitionExampleValueCodeableconcept(_) -> "CodeableConcept"
        ElementdefinitionExampleValueCoding(_) -> "Coding"
        ElementdefinitionExampleValueContactpoint(_) -> "ContactPoint"
        ElementdefinitionExampleValueCount(_) -> "Count"
        ElementdefinitionExampleValueDistance(_) -> "Distance"
        ElementdefinitionExampleValueDuration(_) -> "Duration"
        ElementdefinitionExampleValueHumanname(_) -> "HumanName"
        ElementdefinitionExampleValueIdentifier(_) -> "Identifier"
        ElementdefinitionExampleValueMoney(_) -> "Money"
        ElementdefinitionExampleValuePeriod(_) -> "Period"
        ElementdefinitionExampleValueQuantity(_) -> "Quantity"
        ElementdefinitionExampleValueRange(_) -> "Range"
        ElementdefinitionExampleValueRatio(_) -> "Ratio"
        ElementdefinitionExampleValueReference(_) -> "Reference"
        ElementdefinitionExampleValueSampleddata(_) -> "SampledData"
        ElementdefinitionExampleValueSignature(_) -> "Signature"
        ElementdefinitionExampleValueTiming(_) -> "Timing"
        ElementdefinitionExampleValueContactdetail(_) -> "ContactDetail"
        ElementdefinitionExampleValueContributor(_) -> "Contributor"
        ElementdefinitionExampleValueDatarequirement(_) -> "DataRequirement"
        ElementdefinitionExampleValueExpression(_) -> "Expression"
        ElementdefinitionExampleValueParameterdefinition(_) ->
          "ParameterDefinition"
        ElementdefinitionExampleValueRelatedartifact(_) -> "RelatedArtifact"
        ElementdefinitionExampleValueTriggerdefinition(_) -> "TriggerDefinition"
        ElementdefinitionExampleValueUsagecontext(_) -> "UsageContext"
        ElementdefinitionExampleValueDosage(_) -> "Dosage"
        ElementdefinitionExampleValueMeta(_) -> "Meta"
      },
      elementdefinition_example_value_to_json(value),
    ),
    #("label", json.string(label)),
  ]
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn elementdefinition_example_decoder() -> Decoder(ElementdefinitionExample) {
  use <- decode.recursive
  use value <- decode.then(elementdefinition_example_value_decoder())
  use label <- decode.field("label", decode.string)
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(ElementdefinitionExample(value:, label:, extension:, id:))
}

pub fn elementdefinition_type_to_json(
  elementdefinition_type: ElementdefinitionType,
) -> Json {
  let ElementdefinitionType(
    versioning:,
    aggregation:,
    target_profile:,
    profile:,
    code:,
    extension:,
    id:,
  ) = elementdefinition_type
  let fields = [
    #("code", json.string(code)),
  ]
  let fields = case versioning {
    Some(v) -> [
      #("versioning", valuesets.referenceversionrules_to_json(v)),
      ..fields
    ]
    None -> fields
  }
  let fields = case aggregation {
    [] -> fields
    _ -> [
      #(
        "aggregation",
        json.array(aggregation, valuesets.resourceaggregationmode_to_json),
      ),
      ..fields
    ]
  }
  let fields = case target_profile {
    [] -> fields
    _ -> [#("targetProfile", json.array(target_profile, json.string)), ..fields]
  }
  let fields = case profile {
    [] -> fields
    _ -> [#("profile", json.array(profile, json.string)), ..fields]
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn elementdefinition_type_decoder() -> Decoder(ElementdefinitionType) {
  use <- decode.recursive
  use versioning <- decode.optional_field(
    "versioning",
    None,
    decode.optional(valuesets.referenceversionrules_decoder()),
  )
  use aggregation <- decode.optional_field(
    "aggregation",
    [],
    decode.list(valuesets.resourceaggregationmode_decoder()),
  )
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
  use code <- decode.field("code", decode.string)
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(ElementdefinitionType(
    versioning:,
    aggregation:,
    target_profile:,
    profile:,
    code:,
    extension:,
    id:,
  ))
}

pub fn elementdefinition_base_to_json(
  elementdefinition_base: ElementdefinitionBase,
) -> Json {
  let ElementdefinitionBase(max:, min:, path:, extension:, id:) =
    elementdefinition_base
  let fields = [
    #("max", json.string(max)),
    #("min", json.int(min)),
    #("path", json.string(path)),
  ]
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn elementdefinition_base_decoder() -> Decoder(ElementdefinitionBase) {
  use <- decode.recursive
  use max <- decode.field("max", decode.string)
  use min <- decode.field("min", decode.int)
  use path <- decode.field("path", decode.string)
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(ElementdefinitionBase(max:, min:, path:, extension:, id:))
}

pub fn elementdefinition_slicing_discriminator_to_json(
  elementdefinition_slicing_discriminator: ElementdefinitionSlicingDiscriminator,
) -> Json {
  let ElementdefinitionSlicingDiscriminator(path:, type_:, extension:, id:) =
    elementdefinition_slicing_discriminator
  let fields = [
    #("path", json.string(path)),
    #("type", valuesets.discriminatortype_to_json(type_)),
  ]
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn elementdefinition_slicing_discriminator_decoder() -> Decoder(
  ElementdefinitionSlicingDiscriminator,
) {
  use <- decode.recursive
  use path <- decode.field("path", decode.string)
  use type_ <- decode.field("type", valuesets.discriminatortype_decoder())
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(ElementdefinitionSlicingDiscriminator(
    path:,
    type_:,
    extension:,
    id:,
  ))
}

pub fn elementdefinition_slicing_to_json(
  elementdefinition_slicing: ElementdefinitionSlicing,
) -> Json {
  let ElementdefinitionSlicing(
    rules:,
    ordered:,
    description:,
    discriminator:,
    extension:,
    id:,
  ) = elementdefinition_slicing
  let fields = [
    #("rules", valuesets.resourceslicingrules_to_json(rules)),
  ]
  let fields = case ordered {
    Some(v) -> [#("ordered", json.bool(v)), ..fields]
    None -> fields
  }
  let fields = case description {
    Some(v) -> [#("description", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case discriminator {
    [] -> fields
    _ -> [
      #(
        "discriminator",
        json.array(
          discriminator,
          elementdefinition_slicing_discriminator_to_json,
        ),
      ),
      ..fields
    ]
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn elementdefinition_slicing_decoder() -> Decoder(ElementdefinitionSlicing) {
  use <- decode.recursive
  use rules <- decode.field("rules", valuesets.resourceslicingrules_decoder())
  use ordered <- decode.optional_field(
    "ordered",
    None,
    decode.optional(decode.bool),
  )
  use description <- decode.optional_field(
    "description",
    None,
    decode.optional(decode.string),
  )
  use discriminator <- decode.optional_field(
    "discriminator",
    [],
    decode.list(elementdefinition_slicing_discriminator_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(ElementdefinitionSlicing(
    rules:,
    ordered:,
    description:,
    discriminator:,
    extension:,
    id:,
  ))
}

pub fn elementdefinition_to_json(elementdefinition: Elementdefinition) -> Json {
  let Elementdefinition(
    mapping:,
    binding:,
    is_summary:,
    is_modifier_reason:,
    is_modifier:,
    must_support:,
    constraint:,
    condition:,
    max_length:,
    max_value:,
    min_value:,
    example:,
    pattern:,
    fixed:,
    order_meaning:,
    meaning_when_missing:,
    default_value:,
    type_:,
    content_reference:,
    base:,
    max:,
    min:,
    alias:,
    requirements:,
    comment:,
    definition:,
    short:,
    slicing:,
    code:,
    label:,
    slice_is_constraining:,
    slice_name:,
    representation:,
    path:,
    modifier_extension:,
    extension:,
    id:,
    uscdi_requirement:,
  ) = elementdefinition
  let fields = [
    #("path", json.string(path)),
  ]
  let extension =
    list.flatten([
      extension,
      list.map(uscdi_requirement, uscdi_requirement_to_ext),
    ])
  let fields = case mapping {
    [] -> fields
    _ -> [
      #("mapping", json.array(mapping, elementdefinition_mapping_to_json)),
      ..fields
    ]
  }
  let fields = case binding {
    Some(v) -> [#("binding", elementdefinition_binding_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case is_summary {
    Some(v) -> [#("isSummary", json.bool(v)), ..fields]
    None -> fields
  }
  let fields = case is_modifier_reason {
    Some(v) -> [#("isModifierReason", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case is_modifier {
    Some(v) -> [#("isModifier", json.bool(v)), ..fields]
    None -> fields
  }
  let fields = case must_support {
    Some(v) -> [#("mustSupport", json.bool(v)), ..fields]
    None -> fields
  }
  let fields = case constraint {
    [] -> fields
    _ -> [
      #(
        "constraint",
        json.array(constraint, elementdefinition_constraint_to_json),
      ),
      ..fields
    ]
  }
  let fields = case condition {
    [] -> fields
    _ -> [#("condition", json.array(condition, json.string)), ..fields]
  }
  let fields = case max_length {
    Some(v) -> [#("maxLength", json.int(v)), ..fields]
    None -> fields
  }
  let fields = case max_value {
    Some(v) -> [
      #(
        "maxValue"
          <> case v {
          ElementdefinitionMaxvalueDate(_) -> "Date"
          ElementdefinitionMaxvalueDatetime(_) -> "DateTime"
          ElementdefinitionMaxvalueInstant(_) -> "Instant"
          ElementdefinitionMaxvalueTime(_) -> "Time"
          ElementdefinitionMaxvalueDecimal(_) -> "Decimal"
          ElementdefinitionMaxvalueInteger(_) -> "Integer"
          ElementdefinitionMaxvaluePositiveint(_) -> "PositiveInt"
          ElementdefinitionMaxvalueUnsignedint(_) -> "UnsignedInt"
          ElementdefinitionMaxvalueQuantity(_) -> "Quantity"
        },
        elementdefinition_maxvalue_to_json(v),
      ),
      ..fields
    ]
    None -> fields
  }
  let fields = case min_value {
    Some(v) -> [
      #(
        "minValue"
          <> case v {
          ElementdefinitionMinvalueDate(_) -> "Date"
          ElementdefinitionMinvalueDatetime(_) -> "DateTime"
          ElementdefinitionMinvalueInstant(_) -> "Instant"
          ElementdefinitionMinvalueTime(_) -> "Time"
          ElementdefinitionMinvalueDecimal(_) -> "Decimal"
          ElementdefinitionMinvalueInteger(_) -> "Integer"
          ElementdefinitionMinvaluePositiveint(_) -> "PositiveInt"
          ElementdefinitionMinvalueUnsignedint(_) -> "UnsignedInt"
          ElementdefinitionMinvalueQuantity(_) -> "Quantity"
        },
        elementdefinition_minvalue_to_json(v),
      ),
      ..fields
    ]
    None -> fields
  }
  let fields = case example {
    [] -> fields
    _ -> [
      #("example", json.array(example, elementdefinition_example_to_json)),
      ..fields
    ]
  }
  let fields = case pattern {
    Some(v) -> [
      #(
        "pattern"
          <> case v {
          ElementdefinitionPatternBase64binary(_) -> "Base64Binary"
          ElementdefinitionPatternBoolean(_) -> "Boolean"
          ElementdefinitionPatternCanonical(_) -> "Canonical"
          ElementdefinitionPatternCode(_) -> "Code"
          ElementdefinitionPatternDate(_) -> "Date"
          ElementdefinitionPatternDatetime(_) -> "DateTime"
          ElementdefinitionPatternDecimal(_) -> "Decimal"
          ElementdefinitionPatternId(_) -> "Id"
          ElementdefinitionPatternInstant(_) -> "Instant"
          ElementdefinitionPatternInteger(_) -> "Integer"
          ElementdefinitionPatternMarkdown(_) -> "Markdown"
          ElementdefinitionPatternOid(_) -> "Oid"
          ElementdefinitionPatternPositiveint(_) -> "PositiveInt"
          ElementdefinitionPatternString(_) -> "String"
          ElementdefinitionPatternTime(_) -> "Time"
          ElementdefinitionPatternUnsignedint(_) -> "UnsignedInt"
          ElementdefinitionPatternUri(_) -> "Uri"
          ElementdefinitionPatternUrl(_) -> "Url"
          ElementdefinitionPatternUuid(_) -> "Uuid"
          ElementdefinitionPatternAddress(_) -> "Address"
          ElementdefinitionPatternAge(_) -> "Age"
          ElementdefinitionPatternAnnotation(_) -> "Annotation"
          ElementdefinitionPatternAttachment(_) -> "Attachment"
          ElementdefinitionPatternCodeableconcept(_) -> "CodeableConcept"
          ElementdefinitionPatternCoding(_) -> "Coding"
          ElementdefinitionPatternContactpoint(_) -> "ContactPoint"
          ElementdefinitionPatternCount(_) -> "Count"
          ElementdefinitionPatternDistance(_) -> "Distance"
          ElementdefinitionPatternDuration(_) -> "Duration"
          ElementdefinitionPatternHumanname(_) -> "HumanName"
          ElementdefinitionPatternIdentifier(_) -> "Identifier"
          ElementdefinitionPatternMoney(_) -> "Money"
          ElementdefinitionPatternPeriod(_) -> "Period"
          ElementdefinitionPatternQuantity(_) -> "Quantity"
          ElementdefinitionPatternRange(_) -> "Range"
          ElementdefinitionPatternRatio(_) -> "Ratio"
          ElementdefinitionPatternReference(_) -> "Reference"
          ElementdefinitionPatternSampleddata(_) -> "SampledData"
          ElementdefinitionPatternSignature(_) -> "Signature"
          ElementdefinitionPatternTiming(_) -> "Timing"
          ElementdefinitionPatternContactdetail(_) -> "ContactDetail"
          ElementdefinitionPatternContributor(_) -> "Contributor"
          ElementdefinitionPatternDatarequirement(_) -> "DataRequirement"
          ElementdefinitionPatternExpression(_) -> "Expression"
          ElementdefinitionPatternParameterdefinition(_) ->
            "ParameterDefinition"
          ElementdefinitionPatternRelatedartifact(_) -> "RelatedArtifact"
          ElementdefinitionPatternTriggerdefinition(_) -> "TriggerDefinition"
          ElementdefinitionPatternUsagecontext(_) -> "UsageContext"
          ElementdefinitionPatternDosage(_) -> "Dosage"
          ElementdefinitionPatternMeta(_) -> "Meta"
        },
        elementdefinition_pattern_to_json(v),
      ),
      ..fields
    ]
    None -> fields
  }
  let fields = case fixed {
    Some(v) -> [
      #(
        "fixed"
          <> case v {
          ElementdefinitionFixedBase64binary(_) -> "Base64Binary"
          ElementdefinitionFixedBoolean(_) -> "Boolean"
          ElementdefinitionFixedCanonical(_) -> "Canonical"
          ElementdefinitionFixedCode(_) -> "Code"
          ElementdefinitionFixedDate(_) -> "Date"
          ElementdefinitionFixedDatetime(_) -> "DateTime"
          ElementdefinitionFixedDecimal(_) -> "Decimal"
          ElementdefinitionFixedId(_) -> "Id"
          ElementdefinitionFixedInstant(_) -> "Instant"
          ElementdefinitionFixedInteger(_) -> "Integer"
          ElementdefinitionFixedMarkdown(_) -> "Markdown"
          ElementdefinitionFixedOid(_) -> "Oid"
          ElementdefinitionFixedPositiveint(_) -> "PositiveInt"
          ElementdefinitionFixedString(_) -> "String"
          ElementdefinitionFixedTime(_) -> "Time"
          ElementdefinitionFixedUnsignedint(_) -> "UnsignedInt"
          ElementdefinitionFixedUri(_) -> "Uri"
          ElementdefinitionFixedUrl(_) -> "Url"
          ElementdefinitionFixedUuid(_) -> "Uuid"
          ElementdefinitionFixedAddress(_) -> "Address"
          ElementdefinitionFixedAge(_) -> "Age"
          ElementdefinitionFixedAnnotation(_) -> "Annotation"
          ElementdefinitionFixedAttachment(_) -> "Attachment"
          ElementdefinitionFixedCodeableconcept(_) -> "CodeableConcept"
          ElementdefinitionFixedCoding(_) -> "Coding"
          ElementdefinitionFixedContactpoint(_) -> "ContactPoint"
          ElementdefinitionFixedCount(_) -> "Count"
          ElementdefinitionFixedDistance(_) -> "Distance"
          ElementdefinitionFixedDuration(_) -> "Duration"
          ElementdefinitionFixedHumanname(_) -> "HumanName"
          ElementdefinitionFixedIdentifier(_) -> "Identifier"
          ElementdefinitionFixedMoney(_) -> "Money"
          ElementdefinitionFixedPeriod(_) -> "Period"
          ElementdefinitionFixedQuantity(_) -> "Quantity"
          ElementdefinitionFixedRange(_) -> "Range"
          ElementdefinitionFixedRatio(_) -> "Ratio"
          ElementdefinitionFixedReference(_) -> "Reference"
          ElementdefinitionFixedSampleddata(_) -> "SampledData"
          ElementdefinitionFixedSignature(_) -> "Signature"
          ElementdefinitionFixedTiming(_) -> "Timing"
          ElementdefinitionFixedContactdetail(_) -> "ContactDetail"
          ElementdefinitionFixedContributor(_) -> "Contributor"
          ElementdefinitionFixedDatarequirement(_) -> "DataRequirement"
          ElementdefinitionFixedExpression(_) -> "Expression"
          ElementdefinitionFixedParameterdefinition(_) -> "ParameterDefinition"
          ElementdefinitionFixedRelatedartifact(_) -> "RelatedArtifact"
          ElementdefinitionFixedTriggerdefinition(_) -> "TriggerDefinition"
          ElementdefinitionFixedUsagecontext(_) -> "UsageContext"
          ElementdefinitionFixedDosage(_) -> "Dosage"
          ElementdefinitionFixedMeta(_) -> "Meta"
        },
        elementdefinition_fixed_to_json(v),
      ),
      ..fields
    ]
    None -> fields
  }
  let fields = case order_meaning {
    Some(v) -> [#("orderMeaning", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case meaning_when_missing {
    Some(v) -> [#("meaningWhenMissing", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case default_value {
    Some(v) -> [
      #(
        "defaultValue"
          <> case v {
          ElementdefinitionDefaultvalueBase64binary(_) -> "Base64Binary"
          ElementdefinitionDefaultvalueBoolean(_) -> "Boolean"
          ElementdefinitionDefaultvalueCanonical(_) -> "Canonical"
          ElementdefinitionDefaultvalueCode(_) -> "Code"
          ElementdefinitionDefaultvalueDate(_) -> "Date"
          ElementdefinitionDefaultvalueDatetime(_) -> "DateTime"
          ElementdefinitionDefaultvalueDecimal(_) -> "Decimal"
          ElementdefinitionDefaultvalueId(_) -> "Id"
          ElementdefinitionDefaultvalueInstant(_) -> "Instant"
          ElementdefinitionDefaultvalueInteger(_) -> "Integer"
          ElementdefinitionDefaultvalueMarkdown(_) -> "Markdown"
          ElementdefinitionDefaultvalueOid(_) -> "Oid"
          ElementdefinitionDefaultvaluePositiveint(_) -> "PositiveInt"
          ElementdefinitionDefaultvalueString(_) -> "String"
          ElementdefinitionDefaultvalueTime(_) -> "Time"
          ElementdefinitionDefaultvalueUnsignedint(_) -> "UnsignedInt"
          ElementdefinitionDefaultvalueUri(_) -> "Uri"
          ElementdefinitionDefaultvalueUrl(_) -> "Url"
          ElementdefinitionDefaultvalueUuid(_) -> "Uuid"
          ElementdefinitionDefaultvalueAddress(_) -> "Address"
          ElementdefinitionDefaultvalueAge(_) -> "Age"
          ElementdefinitionDefaultvalueAnnotation(_) -> "Annotation"
          ElementdefinitionDefaultvalueAttachment(_) -> "Attachment"
          ElementdefinitionDefaultvalueCodeableconcept(_) -> "CodeableConcept"
          ElementdefinitionDefaultvalueCoding(_) -> "Coding"
          ElementdefinitionDefaultvalueContactpoint(_) -> "ContactPoint"
          ElementdefinitionDefaultvalueCount(_) -> "Count"
          ElementdefinitionDefaultvalueDistance(_) -> "Distance"
          ElementdefinitionDefaultvalueDuration(_) -> "Duration"
          ElementdefinitionDefaultvalueHumanname(_) -> "HumanName"
          ElementdefinitionDefaultvalueIdentifier(_) -> "Identifier"
          ElementdefinitionDefaultvalueMoney(_) -> "Money"
          ElementdefinitionDefaultvaluePeriod(_) -> "Period"
          ElementdefinitionDefaultvalueQuantity(_) -> "Quantity"
          ElementdefinitionDefaultvalueRange(_) -> "Range"
          ElementdefinitionDefaultvalueRatio(_) -> "Ratio"
          ElementdefinitionDefaultvalueReference(_) -> "Reference"
          ElementdefinitionDefaultvalueSampleddata(_) -> "SampledData"
          ElementdefinitionDefaultvalueSignature(_) -> "Signature"
          ElementdefinitionDefaultvalueTiming(_) -> "Timing"
          ElementdefinitionDefaultvalueContactdetail(_) -> "ContactDetail"
          ElementdefinitionDefaultvalueContributor(_) -> "Contributor"
          ElementdefinitionDefaultvalueDatarequirement(_) -> "DataRequirement"
          ElementdefinitionDefaultvalueExpression(_) -> "Expression"
          ElementdefinitionDefaultvalueParameterdefinition(_) ->
            "ParameterDefinition"
          ElementdefinitionDefaultvalueRelatedartifact(_) -> "RelatedArtifact"
          ElementdefinitionDefaultvalueTriggerdefinition(_) ->
            "TriggerDefinition"
          ElementdefinitionDefaultvalueUsagecontext(_) -> "UsageContext"
          ElementdefinitionDefaultvalueDosage(_) -> "Dosage"
          ElementdefinitionDefaultvalueMeta(_) -> "Meta"
        },
        elementdefinition_defaultvalue_to_json(v),
      ),
      ..fields
    ]
    None -> fields
  }
  let fields = case type_ {
    [] -> fields
    _ -> [
      #("type", json.array(type_, elementdefinition_type_to_json)),
      ..fields
    ]
  }
  let fields = case content_reference {
    Some(v) -> [#("contentReference", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case base {
    Some(v) -> [#("base", elementdefinition_base_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case max {
    Some(v) -> [#("max", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case min {
    Some(v) -> [#("min", json.int(v)), ..fields]
    None -> fields
  }
  let fields = case alias {
    [] -> fields
    _ -> [#("alias", json.array(alias, json.string)), ..fields]
  }
  let fields = case requirements {
    Some(v) -> [#("requirements", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case comment {
    Some(v) -> [#("comment", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case definition {
    Some(v) -> [#("definition", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case short {
    Some(v) -> [#("short", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case slicing {
    Some(v) -> [#("slicing", elementdefinition_slicing_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case code {
    [] -> fields
    _ -> [#("code", json.array(code, coding_to_json)), ..fields]
  }
  let fields = case label {
    Some(v) -> [#("label", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case slice_is_constraining {
    Some(v) -> [#("sliceIsConstraining", json.bool(v)), ..fields]
    None -> fields
  }
  let fields = case slice_name {
    Some(v) -> [#("sliceName", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case representation {
    [] -> fields
    _ -> [
      #(
        "representation",
        json.array(representation, valuesets.propertyrepresentation_to_json),
      ),
      ..fields
    ]
  }
  let fields = case modifier_extension {
    [] -> fields
    _ -> [
      #("modifierExtension", json.array(modifier_extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn elementdefinition_decoder() -> Decoder(Elementdefinition) {
  use <- decode.recursive
  use mapping <- decode.optional_field(
    "mapping",
    [],
    decode.list(elementdefinition_mapping_decoder()),
  )
  use binding <- decode.optional_field(
    "binding",
    None,
    decode.optional(elementdefinition_binding_decoder()),
  )
  use is_summary <- decode.optional_field(
    "isSummary",
    None,
    decode.optional(decode.bool),
  )
  use is_modifier_reason <- decode.optional_field(
    "isModifierReason",
    None,
    decode.optional(decode.string),
  )
  use is_modifier <- decode.optional_field(
    "isModifier",
    None,
    decode.optional(decode.bool),
  )
  use must_support <- decode.optional_field(
    "mustSupport",
    None,
    decode.optional(decode.bool),
  )
  use constraint <- decode.optional_field(
    "constraint",
    [],
    decode.list(elementdefinition_constraint_decoder()),
  )
  use condition <- decode.optional_field(
    "condition",
    [],
    decode.list(decode.string),
  )
  use max_length <- decode.optional_field(
    "maxLength",
    None,
    decode.optional(decode.int),
  )
  use max_value <- decode.then(
    none_if_omitted(elementdefinition_maxvalue_decoder()),
  )
  use min_value <- decode.then(
    none_if_omitted(elementdefinition_minvalue_decoder()),
  )
  use example <- decode.optional_field(
    "example",
    [],
    decode.list(elementdefinition_example_decoder()),
  )
  use pattern <- decode.then(
    none_if_omitted(elementdefinition_pattern_decoder()),
  )
  use fixed <- decode.then(none_if_omitted(elementdefinition_fixed_decoder()))
  use order_meaning <- decode.optional_field(
    "orderMeaning",
    None,
    decode.optional(decode.string),
  )
  use meaning_when_missing <- decode.optional_field(
    "meaningWhenMissing",
    None,
    decode.optional(decode.string),
  )
  use default_value <- decode.then(
    none_if_omitted(elementdefinition_defaultvalue_decoder()),
  )
  use type_ <- decode.optional_field(
    "type",
    [],
    decode.list(elementdefinition_type_decoder()),
  )
  use content_reference <- decode.optional_field(
    "contentReference",
    None,
    decode.optional(decode.string),
  )
  use base <- decode.optional_field(
    "base",
    None,
    decode.optional(elementdefinition_base_decoder()),
  )
  use max <- decode.optional_field("max", None, decode.optional(decode.string))
  use min <- decode.optional_field("min", None, decode.optional(decode.int))
  use alias <- decode.optional_field("alias", [], decode.list(decode.string))
  use requirements <- decode.optional_field(
    "requirements",
    None,
    decode.optional(decode.string),
  )
  use comment <- decode.optional_field(
    "comment",
    None,
    decode.optional(decode.string),
  )
  use definition <- decode.optional_field(
    "definition",
    None,
    decode.optional(decode.string),
  )
  use short <- decode.optional_field(
    "short",
    None,
    decode.optional(decode.string),
  )
  use slicing <- decode.optional_field(
    "slicing",
    None,
    decode.optional(elementdefinition_slicing_decoder()),
  )
  use code <- decode.optional_field("code", [], decode.list(coding_decoder()))
  use label <- decode.optional_field(
    "label",
    None,
    decode.optional(decode.string),
  )
  use slice_is_constraining <- decode.optional_field(
    "sliceIsConstraining",
    None,
    decode.optional(decode.bool),
  )
  use slice_name <- decode.optional_field(
    "sliceName",
    None,
    decode.optional(decode.string),
  )
  use representation <- decode.optional_field(
    "representation",
    [],
    decode.list(valuesets.propertyrepresentation_decoder()),
  )
  use path <- decode.field("path", decode.string)
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
  let #(uscdi_requirement_, extension) =
    list.fold(from: #([], []), over: extension, with: fn(acc, ext) {
      let #(a0, plain) = acc
      case uscdi_requirement_from_ext(ext) {
        Ok(v) -> #([v, ..a0], plain)
        Error(_) -> #(a0, [ext, ..plain])
      }
    })
  let uscdi_requirement = uscdi_requirement_
  decode.success(Elementdefinition(
    mapping:,
    binding:,
    is_summary:,
    is_modifier_reason:,
    is_modifier:,
    must_support:,
    constraint:,
    condition:,
    max_length:,
    max_value:,
    min_value:,
    example:,
    pattern:,
    fixed:,
    order_meaning:,
    meaning_when_missing:,
    default_value:,
    type_:,
    content_reference:,
    base:,
    max:,
    min:,
    alias:,
    requirements:,
    comment:,
    definition:,
    short:,
    slicing:,
    code:,
    label:,
    slice_is_constraining:,
    slice_name:,
    representation:,
    path:,
    modifier_extension:,
    extension:,
    id:,
    uscdi_requirement:,
  ))
}

///[http://hl7.org/fhir/r4us/StructureDefinition/Expression#resource](http://hl7.org/fhir/r4us/StructureDefinition/Expression#resource)
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
  let Expression(
    reference:,
    expression:,
    language:,
    name:,
    description:,
    extension:,
    id:,
  ) = expression
  let fields = [
    #("language", json.string(language)),
  ]
  let fields = case reference {
    Some(v) -> [#("reference", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case expression {
    Some(v) -> [#("expression", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case name {
    Some(v) -> [#("name", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case description {
    Some(v) -> [#("description", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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

///[http://hl7.org/fhir/r4us/us/core/StructureDefinition/us-core-direct#resource](http://hl7.org/fhir/r4us/us/core/StructureDefinition/us-core-direct#resource)
pub fn us_core_direct_to_ext(value: Bool) -> Extension {
  Extension(
    id: None,
    url: "http://hl7.org/fhir/us/core/StructureDefinition/us-core-direct",
    ext: ExtSimple(ExtensionValueBoolean(value)),
  )
}

pub fn us_core_direct_to_json(us_core_direct: Bool) -> Json {
  extension_to_json(us_core_direct_to_ext(us_core_direct))
}

pub fn us_core_direct_decoder() -> Decoder(Result(Bool, Extension)) {
  use ext <- decode.then(extension_decoder())
  case us_core_direct_from_ext(ext) {
    Ok(result) -> decode.success(Ok(result))
    Error(Nil) -> decode.success(Error(ext))
  }
}

pub fn us_core_direct_from_ext(ext: Extension) -> Result(Bool, Nil) {
  case ext.url, ext.ext {
    "http://hl7.org/fhir/us/core/StructureDefinition/us-core-direct",
      ExtSimple(ExtensionValueBoolean(v))
    -> Ok(v)
    _, _ -> Error(Nil)
  }
}

///[http://hl7.org/fhir/r4us/us/core/StructureDefinition/us-core-ethnicity#resource](http://hl7.org/fhir/r4us/us/core/StructureDefinition/us-core-ethnicity#resource)
pub type UsCoreEthnicity {
  UsCoreEthnicity(
    text: String,
    detailed: List(Coding),
    omb_category: Option(Coding),
  )
}

pub fn us_core_ethnicity_to_ext(to_ext: UsCoreEthnicity) -> Extension {
  Extension(
    id: None,
    url: "http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity",
    ext: ExtComplex(
      list.flatten([
        case to_ext.omb_category {
          None -> []
          Some(c) -> [
            Extension(
              id: None,
              url: "ombCategory",
              ext: ExtSimple(ExtensionValueCoding(c)),
            ),
          ]
        },
        to_ext.detailed
          |> list.map(fn(c) {
            Extension(
              id: None,
              url: "detailed",
              ext: ExtSimple(ExtensionValueCoding(c)),
            )
          }),
        [
          Extension(
            id: None,
            url: "text",
            ext: ExtSimple(ExtensionValueString(to_ext.text)),
          ),
        ],
      ]),
    ),
  )
}

pub fn us_core_ethnicity_to_json(us_core_ethnicity: UsCoreEthnicity) -> Json {
  extension_to_json(us_core_ethnicity_to_ext(us_core_ethnicity))
}

pub fn us_core_ethnicity_decoder() -> Decoder(
  Result(UsCoreEthnicity, Extension),
) {
  use ext <- decode.then(extension_decoder())
  case us_core_ethnicity_from_ext(ext) {
    Ok(result) -> decode.success(Ok(result))
    Error(Nil) -> decode.success(Error(ext))
  }
}

pub fn us_core_ethnicity_from_ext(
  ext: Extension,
) -> Result(UsCoreEthnicity, Nil) {
  case ext.url, ext.ext {
    "http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity",
      ExtComplex(children)
    -> {
      let ext_dict = exts_to_extdict(children)
      use omb_category <- result.try(
        case dict.get(ext_dict.exts_by_url, "ombCategory") {
          Error(_) -> Ok(None)
          Ok([
            ExtDictContent(content: ExtDictSimple(ExtensionValueCoding(v)), ..),
          ]) -> Ok(Some(v))
          Ok(_) -> Error(Nil)
        },
      )
      use detailed <- result.try(
        case dict.get(ext_dict.exts_by_url, "detailed") {
          Error(_) -> Ok([])
          Ok(entries) ->
            list.fold(from: Ok([]), over: entries, with: fn(acc, entry) {
              use so_far <- result.try(acc)
              case entry.content {
                ExtDictSimple(ExtensionValueCoding(v)) -> Ok([v, ..so_far])
                _ -> Error(Nil)
              }
            })
        },
      )
      use text <- result.try(case dict.get(ext_dict.exts_by_url, "text") {
        Error(_) -> Error(Nil)
        Ok([ExtDictContent(content: ExtDictSimple(ExtensionValueString(v)), ..)]) ->
          Ok(v)
        Ok(_) -> Error(Nil)
      })
      Ok(UsCoreEthnicity(omb_category:, detailed:, text:))
    }
    _, _ -> Error(Nil)
  }
}

///[http://hl7.org/fhir/r4us/us/core/StructureDefinition/us-core-extension-questionnaire-uri#resource](http://hl7.org/fhir/r4us/us/core/StructureDefinition/us-core-extension-questionnaire-uri#resource)
pub fn us_core_extension_questionnaire_uri_to_ext(value: String) -> Extension {
  Extension(
    id: None,
    url: "http://hl7.org/fhir/us/core/StructureDefinition/us-core-extension-questionnaire-uri",
    ext: ExtSimple(ExtensionValueUri(value)),
  )
}

pub fn us_core_extension_questionnaire_uri_to_json(
  us_core_extension_questionnaire_uri: String,
) -> Json {
  extension_to_json(us_core_extension_questionnaire_uri_to_ext(
    us_core_extension_questionnaire_uri,
  ))
}

pub fn us_core_extension_questionnaire_uri_decoder() -> Decoder(
  Result(String, Extension),
) {
  use ext <- decode.then(extension_decoder())
  case us_core_extension_questionnaire_uri_from_ext(ext) {
    Ok(result) -> decode.success(Ok(result))
    Error(Nil) -> decode.success(Error(ext))
  }
}

pub fn us_core_extension_questionnaire_uri_from_ext(
  ext: Extension,
) -> Result(String, Nil) {
  case ext.url, ext.ext {
    "http://hl7.org/fhir/us/core/StructureDefinition/us-core-extension-questionnaire-uri",
      ExtSimple(ExtensionValueUri(v))
    -> Ok(v)
    _, _ -> Error(Nil)
  }
}

///[http://hl7.org/fhir/r4us/us/core/StructureDefinition/us-core-individual-sex#resource](http://hl7.org/fhir/r4us/us/core/StructureDefinition/us-core-individual-sex#resource)
pub fn us_core_individual_sex_to_ext(value: Coding) -> Extension {
  Extension(
    id: None,
    url: "http://hl7.org/fhir/us/core/StructureDefinition/us-core-individual-sex",
    ext: ExtSimple(ExtensionValueCoding(value)),
  )
}

pub fn us_core_individual_sex_to_json(us_core_individual_sex: Coding) -> Json {
  extension_to_json(us_core_individual_sex_to_ext(us_core_individual_sex))
}

pub fn us_core_individual_sex_decoder() -> Decoder(Result(Coding, Extension)) {
  use ext <- decode.then(extension_decoder())
  case us_core_individual_sex_from_ext(ext) {
    Ok(result) -> decode.success(Ok(result))
    Error(Nil) -> decode.success(Error(ext))
  }
}

pub fn us_core_individual_sex_from_ext(ext: Extension) -> Result(Coding, Nil) {
  case ext.url, ext.ext {
    "http://hl7.org/fhir/us/core/StructureDefinition/us-core-individual-sex",
      ExtSimple(ExtensionValueCoding(v))
    -> Ok(v)
    _, _ -> Error(Nil)
  }
}

///[http://hl7.org/fhir/r4us/StructureDefinition/individual-recordedSexOrGender#resource](http://hl7.org/fhir/r4us/StructureDefinition/individual-recordedSexOrGender#resource)
pub type IndividualRecordedsexorgender {
  IndividualRecordedsexorgender(
    gender_element_qualifier: Option(Bool),
    comment: Option(String),
    jurisdiction: Option(Codeableconcept),
    source_field: Option(String),
    source_document: Option(IndividualRecordedsexorgenderSourcedocument),
    source: Option(IndividualRecordedsexorgenderSource),
    acquisition_date: Option(DateTime),
    effective_period: Option(Period),
    type_: Option(Codeableconcept),
    value: Codeableconcept,
  )
}

///[http://hl7.org/fhir/r4us/StructureDefinition/individual-recordedSexOrGender#resource](http://hl7.org/fhir/r4us/StructureDefinition/individual-recordedSexOrGender#resource)
pub type IndividualRecordedsexorgenderSourcedocument {
  IndividualRecordedsexorgenderSourcedocumentCodeableconcept(
    source_document: Codeableconcept,
  )
  IndividualRecordedsexorgenderSourcedocumentReference(
    source_document: Reference,
  )
}

pub fn individual_recordedsexorgender_sourcedocument_to_json(
  elt: IndividualRecordedsexorgenderSourcedocument,
) -> Json {
  case elt {
    IndividualRecordedsexorgenderSourcedocumentCodeableconcept(v) ->
      codeableconcept_to_json(v)
    IndividualRecordedsexorgenderSourcedocumentReference(v) ->
      reference_to_json(v)
  }
}

pub fn individual_recordedsexorgender_sourcedocument_decoder() -> Decoder(
  IndividualRecordedsexorgenderSourcedocument,
) {
  decode.one_of(
    decode.field(
      "sourceDocumentCodeableConcept",
      codeableconcept_decoder(),
      decode.success,
    )
      |> decode.map(IndividualRecordedsexorgenderSourcedocumentCodeableconcept),
    [
      decode.field(
        "sourceDocumentReference",
        reference_decoder(),
        decode.success,
      )
      |> decode.map(IndividualRecordedsexorgenderSourcedocumentReference),
    ],
  )
}

///[http://hl7.org/fhir/r4us/StructureDefinition/individual-recordedSexOrGender#resource](http://hl7.org/fhir/r4us/StructureDefinition/individual-recordedSexOrGender#resource)
pub type IndividualRecordedsexorgenderSource {
  IndividualRecordedsexorgenderSourceCodeableconcept(source: Codeableconcept)
  IndividualRecordedsexorgenderSourceReference(source: Reference)
}

pub fn individual_recordedsexorgender_source_to_json(
  elt: IndividualRecordedsexorgenderSource,
) -> Json {
  case elt {
    IndividualRecordedsexorgenderSourceCodeableconcept(v) ->
      codeableconcept_to_json(v)
    IndividualRecordedsexorgenderSourceReference(v) -> reference_to_json(v)
  }
}

pub fn individual_recordedsexorgender_source_decoder() -> Decoder(
  IndividualRecordedsexorgenderSource,
) {
  decode.one_of(
    decode.field(
      "sourceCodeableConcept",
      codeableconcept_decoder(),
      decode.success,
    )
      |> decode.map(IndividualRecordedsexorgenderSourceCodeableconcept),
    [
      decode.field("sourceReference", reference_decoder(), decode.success)
      |> decode.map(IndividualRecordedsexorgenderSourceReference),
    ],
  )
}

pub fn individual_recordedsexorgender_to_ext(
  to_ext: IndividualRecordedsexorgender,
) -> Extension {
  Extension(
    id: None,
    url: "http://hl7.org/fhir/StructureDefinition/individual-recordedSexOrGender",
    ext: ExtComplex(
      list.flatten([
        [
          Extension(
            id: None,
            url: "value",
            ext: ExtSimple(ExtensionValueCodeableconcept(to_ext.value)),
          ),
        ],
        case to_ext.type_ {
          None -> []
          Some(c) -> [
            Extension(
              id: None,
              url: "type",
              ext: ExtSimple(ExtensionValueCodeableconcept(c)),
            ),
          ]
        },
        case to_ext.effective_period {
          None -> []
          Some(c) -> [
            Extension(
              id: None,
              url: "effectivePeriod",
              ext: ExtSimple(ExtensionValuePeriod(c)),
            ),
          ]
        },
        case to_ext.acquisition_date {
          None -> []
          Some(c) -> [
            Extension(
              id: None,
              url: "acquisitionDate",
              ext: ExtSimple(ExtensionValueDatetime(c)),
            ),
          ]
        },
        case to_ext.source {
          None -> []
          Some(c) -> [
            case c {
              IndividualRecordedsexorgenderSourceCodeableconcept(v) ->
                Extension(
                  id: None,
                  url: "source",
                  ext: ExtSimple(ExtensionValueCodeableconcept(v)),
                )
              IndividualRecordedsexorgenderSourceReference(v) ->
                Extension(
                  id: None,
                  url: "source",
                  ext: ExtSimple(ExtensionValueReference(v)),
                )
            },
          ]
        },
        case to_ext.source_document {
          None -> []
          Some(c) -> [
            case c {
              IndividualRecordedsexorgenderSourcedocumentCodeableconcept(v) ->
                Extension(
                  id: None,
                  url: "sourceDocument",
                  ext: ExtSimple(ExtensionValueCodeableconcept(v)),
                )
              IndividualRecordedsexorgenderSourcedocumentReference(v) ->
                Extension(
                  id: None,
                  url: "sourceDocument",
                  ext: ExtSimple(ExtensionValueReference(v)),
                )
            },
          ]
        },
        case to_ext.source_field {
          None -> []
          Some(c) -> [
            Extension(
              id: None,
              url: "sourceField",
              ext: ExtSimple(ExtensionValueString(c)),
            ),
          ]
        },
        case to_ext.jurisdiction {
          None -> []
          Some(c) -> [
            Extension(
              id: None,
              url: "jurisdiction",
              ext: ExtSimple(ExtensionValueCodeableconcept(c)),
            ),
          ]
        },
        case to_ext.comment {
          None -> []
          Some(c) -> [
            Extension(
              id: None,
              url: "comment",
              ext: ExtSimple(ExtensionValueString(c)),
            ),
          ]
        },
        case to_ext.gender_element_qualifier {
          None -> []
          Some(c) -> [
            Extension(
              id: None,
              url: "genderElementQualifier",
              ext: ExtSimple(ExtensionValueBoolean(c)),
            ),
          ]
        },
      ]),
    ),
  )
}

pub fn individual_recordedsexorgender_to_json(
  individual_recordedsexorgender: IndividualRecordedsexorgender,
) -> Json {
  extension_to_json(individual_recordedsexorgender_to_ext(
    individual_recordedsexorgender,
  ))
}

pub fn individual_recordedsexorgender_decoder() -> Decoder(
  Result(IndividualRecordedsexorgender, Extension),
) {
  use ext <- decode.then(extension_decoder())
  case individual_recordedsexorgender_from_ext(ext) {
    Ok(result) -> decode.success(Ok(result))
    Error(Nil) -> decode.success(Error(ext))
  }
}

pub fn individual_recordedsexorgender_from_ext(
  ext: Extension,
) -> Result(IndividualRecordedsexorgender, Nil) {
  case ext.url, ext.ext {
    "http://hl7.org/fhir/StructureDefinition/individual-recordedSexOrGender",
      ExtComplex(children)
    -> {
      let ext_dict = exts_to_extdict(children)
      use value <- result.try(case dict.get(ext_dict.exts_by_url, "value") {
        Error(_) -> Error(Nil)
        Ok([
          ExtDictContent(
            content: ExtDictSimple(ExtensionValueCodeableconcept(v)),
            ..,
          ),
        ]) -> Ok(v)
        Ok(_) -> Error(Nil)
      })
      use type_ <- result.try(case dict.get(ext_dict.exts_by_url, "type") {
        Error(_) -> Ok(None)
        Ok([
          ExtDictContent(
            content: ExtDictSimple(ExtensionValueCodeableconcept(v)),
            ..,
          ),
        ]) -> Ok(Some(v))
        Ok(_) -> Error(Nil)
      })
      use effective_period <- result.try(
        case dict.get(ext_dict.exts_by_url, "effectivePeriod") {
          Error(_) -> Ok(None)
          Ok([
            ExtDictContent(content: ExtDictSimple(ExtensionValuePeriod(v)), ..),
          ]) -> Ok(Some(v))
          Ok(_) -> Error(Nil)
        },
      )
      use acquisition_date <- result.try(
        case dict.get(ext_dict.exts_by_url, "acquisitionDate") {
          Error(_) -> Ok(None)
          Ok([
            ExtDictContent(
              content: ExtDictSimple(ExtensionValueDatetime(v)),
              ..,
            ),
          ]) -> Ok(Some(v))
          Ok(_) -> Error(Nil)
        },
      )
      use source <- result.try(case dict.get(ext_dict.exts_by_url, "source") {
        Error(_) -> Ok(None)
        Ok([
          ExtDictContent(
            content: ExtDictSimple(ExtensionValueCodeableconcept(v)),
            ..,
          ),
        ]) -> Ok(Some(IndividualRecordedsexorgenderSourceCodeableconcept(v)))
        Ok([
          ExtDictContent(content: ExtDictSimple(ExtensionValueReference(v)), ..),
        ]) -> Ok(Some(IndividualRecordedsexorgenderSourceReference(v)))
        Ok(_) -> Error(Nil)
      })
      use source_document <- result.try(
        case dict.get(ext_dict.exts_by_url, "sourceDocument") {
          Error(_) -> Ok(None)
          Ok([
            ExtDictContent(
              content: ExtDictSimple(ExtensionValueCodeableconcept(v)),
              ..,
            ),
          ]) ->
            Ok(
              Some(IndividualRecordedsexorgenderSourcedocumentCodeableconcept(v)),
            )
          Ok([
            ExtDictContent(
              content: ExtDictSimple(ExtensionValueReference(v)),
              ..,
            ),
          ]) ->
            Ok(Some(IndividualRecordedsexorgenderSourcedocumentReference(v)))
          Ok(_) -> Error(Nil)
        },
      )
      use source_field <- result.try(
        case dict.get(ext_dict.exts_by_url, "sourceField") {
          Error(_) -> Ok(None)
          Ok([
            ExtDictContent(content: ExtDictSimple(ExtensionValueString(v)), ..),
          ]) -> Ok(Some(v))
          Ok(_) -> Error(Nil)
        },
      )
      use jurisdiction <- result.try(
        case dict.get(ext_dict.exts_by_url, "jurisdiction") {
          Error(_) -> Ok(None)
          Ok([
            ExtDictContent(
              content: ExtDictSimple(ExtensionValueCodeableconcept(v)),
              ..,
            ),
          ]) -> Ok(Some(v))
          Ok(_) -> Error(Nil)
        },
      )
      use comment <- result.try(case dict.get(ext_dict.exts_by_url, "comment") {
        Error(_) -> Ok(None)
        Ok([ExtDictContent(content: ExtDictSimple(ExtensionValueString(v)), ..)]) ->
          Ok(Some(v))
        Ok(_) -> Error(Nil)
      })
      use gender_element_qualifier <- result.try(
        case dict.get(ext_dict.exts_by_url, "genderElementQualifier") {
          Error(_) -> Ok(None)
          Ok([
            ExtDictContent(content: ExtDictSimple(ExtensionValueBoolean(v)), ..),
          ]) -> Ok(Some(v))
          Ok(_) -> Error(Nil)
        },
      )
      Ok(IndividualRecordedsexorgender(
        value:,
        type_:,
        effective_period:,
        acquisition_date:,
        source:,
        source_document:,
        source_field:,
        jurisdiction:,
        comment:,
        gender_element_qualifier:,
      ))
    }
    _, _ -> Error(Nil)
  }
}

///[http://hl7.org/fhir/r4us/us/core/StructureDefinition/us-core-familymemberhistory-recorder#resource](http://hl7.org/fhir/r4us/us/core/StructureDefinition/us-core-familymemberhistory-recorder#resource)
pub fn us_core_familymemberhistory_recorder_to_ext(
  value: Reference,
) -> Extension {
  Extension(
    id: None,
    url: "http://hl7.org/fhir/us/core/StructureDefinition/us-core-familymemberhistory-recorder",
    ext: ExtSimple(ExtensionValueReference(value)),
  )
}

pub fn us_core_familymemberhistory_recorder_to_json(
  us_core_familymemberhistory_recorder: Reference,
) -> Json {
  extension_to_json(us_core_familymemberhistory_recorder_to_ext(
    us_core_familymemberhistory_recorder,
  ))
}

pub fn us_core_familymemberhistory_recorder_decoder() -> Decoder(
  Result(Reference, Extension),
) {
  use ext <- decode.then(extension_decoder())
  case us_core_familymemberhistory_recorder_from_ext(ext) {
    Ok(result) -> decode.success(Ok(result))
    Error(Nil) -> decode.success(Error(ext))
  }
}

pub fn us_core_familymemberhistory_recorder_from_ext(
  ext: Extension,
) -> Result(Reference, Nil) {
  case ext.url, ext.ext {
    "http://hl7.org/fhir/us/core/StructureDefinition/us-core-familymemberhistory-recorder",
      ExtSimple(ExtensionValueReference(v))
    -> Ok(v)
    _, _ -> Error(Nil)
  }
}

///[http://hl7.org/fhir/r4us/us/core/StructureDefinition/us-core-birthsex#resource](http://hl7.org/fhir/r4us/us/core/StructureDefinition/us-core-birthsex#resource)
pub fn us_core_birthsex_to_ext(
  value: valuesets.Two16840111376214102124,
) -> Extension {
  Extension(
    id: None,
    url: "http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex",
    ext: ExtSimple(
      ExtensionValueCode(valuesets.two16840111376214102124_to_string(value)),
    ),
  )
}

pub fn us_core_birthsex_to_json(
  us_core_birthsex: valuesets.Two16840111376214102124,
) -> Json {
  extension_to_json(us_core_birthsex_to_ext(us_core_birthsex))
}

pub fn us_core_birthsex_decoder() -> Decoder(
  Result(valuesets.Two16840111376214102124, Extension),
) {
  use ext <- decode.then(extension_decoder())
  case us_core_birthsex_from_ext(ext) {
    Ok(result) -> decode.success(Ok(result))
    Error(Nil) -> decode.success(Error(ext))
  }
}

pub fn us_core_birthsex_from_ext(
  ext: Extension,
) -> Result(valuesets.Two16840111376214102124, Nil) {
  case ext.url, ext.ext {
    "http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex",
      ExtSimple(ExtensionValueCode(s))
    -> valuesets.two16840111376214102124_from_string(s)
    _, _ -> Error(Nil)
  }
}

///[http://hl7.org/fhir/r4us/us/core/StructureDefinition/us-core-authentication-time#resource](http://hl7.org/fhir/r4us/us/core/StructureDefinition/us-core-authentication-time#resource)
pub fn us_core_authentication_time_to_ext(value: DateTime) -> Extension {
  Extension(
    id: None,
    url: "http://hl7.org/fhir/us/core/StructureDefinition/us-core-authentication-time",
    ext: ExtSimple(ExtensionValueDatetime(value)),
  )
}

pub fn us_core_authentication_time_to_json(
  us_core_authentication_time: DateTime,
) -> Json {
  extension_to_json(us_core_authentication_time_to_ext(
    us_core_authentication_time,
  ))
}

pub fn us_core_authentication_time_decoder() -> Decoder(
  Result(DateTime, Extension),
) {
  use ext <- decode.then(extension_decoder())
  case us_core_authentication_time_from_ext(ext) {
    Ok(result) -> decode.success(Ok(result))
    Error(Nil) -> decode.success(Error(ext))
  }
}

pub fn us_core_authentication_time_from_ext(
  ext: Extension,
) -> Result(DateTime, Nil) {
  case ext.url, ext.ext {
    "http://hl7.org/fhir/us/core/StructureDefinition/us-core-authentication-time",
      ExtSimple(ExtensionValueDatetime(v))
    -> Ok(v)
    _, _ -> Error(Nil)
  }
}

///[http://hl7.org/fhir/r4us/us/core/StructureDefinition/us-core-sex#resource](http://hl7.org/fhir/r4us/us/core/StructureDefinition/us-core-sex#resource)
pub fn us_core_sex_to_ext(value: String) -> Extension {
  Extension(
    id: None,
    url: "http://hl7.org/fhir/us/core/StructureDefinition/us-core-sex",
    ext: ExtSimple(ExtensionValueCode(value)),
  )
}

pub fn us_core_sex_to_json(us_core_sex: String) -> Json {
  extension_to_json(us_core_sex_to_ext(us_core_sex))
}

pub fn us_core_sex_decoder() -> Decoder(Result(String, Extension)) {
  use ext <- decode.then(extension_decoder())
  case us_core_sex_from_ext(ext) {
    Ok(result) -> decode.success(Ok(result))
    Error(Nil) -> decode.success(Error(ext))
  }
}

pub fn us_core_sex_from_ext(ext: Extension) -> Result(String, Nil) {
  case ext.url, ext.ext {
    "http://hl7.org/fhir/us/core/StructureDefinition/us-core-sex",
      ExtSimple(ExtensionValueCode(v))
    -> Ok(v)
    _, _ -> Error(Nil)
  }
}

///[http://hl7.org/fhir/r4us/us/core/StructureDefinition/uscdi-requirement#resource](http://hl7.org/fhir/r4us/us/core/StructureDefinition/uscdi-requirement#resource)
pub fn uscdi_requirement_to_ext(value: Bool) -> Extension {
  Extension(
    id: None,
    url: "http://hl7.org/fhir/us/core/StructureDefinition/uscdi-requirement",
    ext: ExtSimple(ExtensionValueBoolean(value)),
  )
}

pub fn uscdi_requirement_to_json(uscdi_requirement: Bool) -> Json {
  extension_to_json(uscdi_requirement_to_ext(uscdi_requirement))
}

pub fn uscdi_requirement_decoder() -> Decoder(Result(Bool, Extension)) {
  use ext <- decode.then(extension_decoder())
  case uscdi_requirement_from_ext(ext) {
    Ok(result) -> decode.success(Ok(result))
    Error(Nil) -> decode.success(Error(ext))
  }
}

pub fn uscdi_requirement_from_ext(ext: Extension) -> Result(Bool, Nil) {
  case ext.url, ext.ext {
    "http://hl7.org/fhir/us/core/StructureDefinition/uscdi-requirement",
      ExtSimple(ExtensionValueBoolean(v))
    -> Ok(v)
    _, _ -> Error(Nil)
  }
}

///[http://hl7.org/fhir/r4us/us/core/StructureDefinition/us-core-race#resource](http://hl7.org/fhir/r4us/us/core/StructureDefinition/us-core-race#resource)
pub type UsCoreRace {
  UsCoreRace(text: String, detailed: List(Coding), omb_category: List(Coding))
}

pub fn us_core_race_to_ext(to_ext: UsCoreRace) -> Extension {
  Extension(
    id: None,
    url: "http://hl7.org/fhir/us/core/StructureDefinition/us-core-race",
    ext: ExtComplex(
      list.flatten([
        to_ext.omb_category
          |> list.map(fn(c) {
            Extension(
              id: None,
              url: "ombCategory",
              ext: ExtSimple(ExtensionValueCoding(c)),
            )
          }),
        to_ext.detailed
          |> list.map(fn(c) {
            Extension(
              id: None,
              url: "detailed",
              ext: ExtSimple(ExtensionValueCoding(c)),
            )
          }),
        [
          Extension(
            id: None,
            url: "text",
            ext: ExtSimple(ExtensionValueString(to_ext.text)),
          ),
        ],
      ]),
    ),
  )
}

pub fn us_core_race_to_json(us_core_race: UsCoreRace) -> Json {
  extension_to_json(us_core_race_to_ext(us_core_race))
}

pub fn us_core_race_decoder() -> Decoder(Result(UsCoreRace, Extension)) {
  use ext <- decode.then(extension_decoder())
  case us_core_race_from_ext(ext) {
    Ok(result) -> decode.success(Ok(result))
    Error(Nil) -> decode.success(Error(ext))
  }
}

pub fn us_core_race_from_ext(ext: Extension) -> Result(UsCoreRace, Nil) {
  case ext.url, ext.ext {
    "http://hl7.org/fhir/us/core/StructureDefinition/us-core-race",
      ExtComplex(children)
    -> {
      let ext_dict = exts_to_extdict(children)
      use omb_category <- result.try(
        case dict.get(ext_dict.exts_by_url, "ombCategory") {
          Error(_) -> Ok([])
          Ok(entries) ->
            list.fold(from: Ok([]), over: entries, with: fn(acc, entry) {
              use so_far <- result.try(acc)
              case entry.content {
                ExtDictSimple(ExtensionValueCoding(v)) -> Ok([v, ..so_far])
                _ -> Error(Nil)
              }
            })
        },
      )
      use detailed <- result.try(
        case dict.get(ext_dict.exts_by_url, "detailed") {
          Error(_) -> Ok([])
          Ok(entries) ->
            list.fold(from: Ok([]), over: entries, with: fn(acc, entry) {
              use so_far <- result.try(acc)
              case entry.content {
                ExtDictSimple(ExtensionValueCoding(v)) -> Ok([v, ..so_far])
                _ -> Error(Nil)
              }
            })
        },
      )
      use text <- result.try(case dict.get(ext_dict.exts_by_url, "text") {
        Error(_) -> Error(Nil)
        Ok([ExtDictContent(content: ExtDictSimple(ExtensionValueString(v)), ..)]) ->
          Ok(v)
        Ok(_) -> Error(Nil)
      })
      Ok(UsCoreRace(omb_category:, detailed:, text:))
    }
    _, _ -> Error(Nil)
  }
}

///[http://hl7.org/fhir/r4us/us/core/StructureDefinition/us-core-interpreter-needed#resource](http://hl7.org/fhir/r4us/us/core/StructureDefinition/us-core-interpreter-needed#resource)
pub fn us_core_interpreter_needed_to_ext(value: Coding) -> Extension {
  Extension(
    id: None,
    url: "http://hl7.org/fhir/us/core/StructureDefinition/us-core-interpreter-needed",
    ext: ExtSimple(ExtensionValueCoding(value)),
  )
}

pub fn us_core_interpreter_needed_to_json(
  us_core_interpreter_needed: Coding,
) -> Json {
  extension_to_json(us_core_interpreter_needed_to_ext(
    us_core_interpreter_needed,
  ))
}

pub fn us_core_interpreter_needed_decoder() -> Decoder(
  Result(Coding, Extension),
) {
  use ext <- decode.then(extension_decoder())
  case us_core_interpreter_needed_from_ext(ext) {
    Ok(result) -> decode.success(Ok(result))
    Error(Nil) -> decode.success(Error(ext))
  }
}

pub fn us_core_interpreter_needed_from_ext(
  ext: Extension,
) -> Result(Coding, Nil) {
  case ext.url, ext.ext {
    "http://hl7.org/fhir/us/core/StructureDefinition/us-core-interpreter-needed",
      ExtSimple(ExtensionValueCoding(v))
    -> Ok(v)
    _, _ -> Error(Nil)
  }
}

///[http://hl7.org/fhir/r4us/us/core/StructureDefinition/us-core-genderIdentity#resource](http://hl7.org/fhir/r4us/us/core/StructureDefinition/us-core-genderIdentity#resource)
pub fn us_core_genderidentity_to_ext(value: Codeableconcept) -> Extension {
  Extension(
    id: None,
    url: "http://hl7.org/fhir/us/core/StructureDefinition/us-core-genderIdentity",
    ext: ExtSimple(ExtensionValueCodeableconcept(value)),
  )
}

pub fn us_core_genderidentity_to_json(
  us_core_genderidentity: Codeableconcept,
) -> Json {
  extension_to_json(us_core_genderidentity_to_ext(us_core_genderidentity))
}

pub fn us_core_genderidentity_decoder() -> Decoder(
  Result(Codeableconcept, Extension),
) {
  use ext <- decode.then(extension_decoder())
  case us_core_genderidentity_from_ext(ext) {
    Ok(result) -> decode.success(Ok(result))
    Error(Nil) -> decode.success(Error(ext))
  }
}

pub fn us_core_genderidentity_from_ext(
  ext: Extension,
) -> Result(Codeableconcept, Nil) {
  case ext.url, ext.ext {
    "http://hl7.org/fhir/us/core/StructureDefinition/us-core-genderIdentity",
      ExtSimple(ExtensionValueCodeableconcept(v))
    -> Ok(v)
    _, _ -> Error(Nil)
  }
}

///[http://hl7.org/fhir/r4us/us/core/StructureDefinition/us-core-medication-adherence#resource](http://hl7.org/fhir/r4us/us/core/StructureDefinition/us-core-medication-adherence#resource)
pub type UsCoreMedicationAdherence {
  UsCoreMedicationAdherence(
    information_source: List(Codeableconcept),
    date_asserted: DateTime,
    medication_adherence: Codeableconcept,
  )
}

pub fn us_core_medication_adherence_to_ext(
  to_ext: UsCoreMedicationAdherence,
) -> Extension {
  Extension(
    id: None,
    url: "http://hl7.org/fhir/us/core/StructureDefinition/us-core-medication-adherence",
    ext: ExtComplex(
      list.flatten([
        [
          Extension(
            id: None,
            url: "medicationAdherence",
            ext: ExtSimple(ExtensionValueCodeableconcept(
              to_ext.medication_adherence,
            )),
          ),
        ],
        [
          Extension(
            id: None,
            url: "dateAsserted",
            ext: ExtSimple(ExtensionValueDatetime(to_ext.date_asserted)),
          ),
        ],
        to_ext.information_source
          |> list.map(fn(c) {
            Extension(
              id: None,
              url: "informationSource",
              ext: ExtSimple(ExtensionValueCodeableconcept(c)),
            )
          }),
      ]),
    ),
  )
}

pub fn us_core_medication_adherence_to_json(
  us_core_medication_adherence: UsCoreMedicationAdherence,
) -> Json {
  extension_to_json(us_core_medication_adherence_to_ext(
    us_core_medication_adherence,
  ))
}

pub fn us_core_medication_adherence_decoder() -> Decoder(
  Result(UsCoreMedicationAdherence, Extension),
) {
  use ext <- decode.then(extension_decoder())
  case us_core_medication_adherence_from_ext(ext) {
    Ok(result) -> decode.success(Ok(result))
    Error(Nil) -> decode.success(Error(ext))
  }
}

pub fn us_core_medication_adherence_from_ext(
  ext: Extension,
) -> Result(UsCoreMedicationAdherence, Nil) {
  case ext.url, ext.ext {
    "http://hl7.org/fhir/us/core/StructureDefinition/us-core-medication-adherence",
      ExtComplex(children)
    -> {
      let ext_dict = exts_to_extdict(children)
      use medication_adherence <- result.try(
        case dict.get(ext_dict.exts_by_url, "medicationAdherence") {
          Error(_) -> Error(Nil)
          Ok([
            ExtDictContent(
              content: ExtDictSimple(ExtensionValueCodeableconcept(v)),
              ..,
            ),
          ]) -> Ok(v)
          Ok(_) -> Error(Nil)
        },
      )
      use date_asserted <- result.try(
        case dict.get(ext_dict.exts_by_url, "dateAsserted") {
          Error(_) -> Error(Nil)
          Ok([
            ExtDictContent(
              content: ExtDictSimple(ExtensionValueDatetime(v)),
              ..,
            ),
          ]) -> Ok(v)
          Ok(_) -> Error(Nil)
        },
      )
      use information_source <- result.try(
        case dict.get(ext_dict.exts_by_url, "informationSource") {
          Error(_) -> Ok([])
          Ok(entries) ->
            list.fold(from: Ok([]), over: entries, with: fn(acc, entry) {
              use so_far <- result.try(acc)
              case entry.content {
                ExtDictSimple(ExtensionValueCodeableconcept(v)) ->
                  Ok([v, ..so_far])
                _ -> Error(Nil)
              }
            })
        },
      )
      Ok(UsCoreMedicationAdherence(
        medication_adherence:,
        date_asserted:,
        information_source:,
      ))
    }
    _, _ -> Error(Nil)
  }
}

///[http://hl7.org/fhir/r4us/us/core/StructureDefinition/us-core-tribal-affiliation#resource](http://hl7.org/fhir/r4us/us/core/StructureDefinition/us-core-tribal-affiliation#resource)
pub type UsCoreTribalAffiliation {
  UsCoreTribalAffiliation(
    is_enrolled: Option(Bool),
    tribal_affiliation: Codeableconcept,
  )
}

pub fn us_core_tribal_affiliation_to_ext(
  to_ext: UsCoreTribalAffiliation,
) -> Extension {
  Extension(
    id: None,
    url: "http://hl7.org/fhir/us/core/StructureDefinition/us-core-tribal-affiliation",
    ext: ExtComplex(
      list.flatten([
        [
          Extension(
            id: None,
            url: "tribalAffiliation",
            ext: ExtSimple(ExtensionValueCodeableconcept(
              to_ext.tribal_affiliation,
            )),
          ),
        ],
        case to_ext.is_enrolled {
          None -> []
          Some(c) -> [
            Extension(
              id: None,
              url: "isEnrolled",
              ext: ExtSimple(ExtensionValueBoolean(c)),
            ),
          ]
        },
      ]),
    ),
  )
}

pub fn us_core_tribal_affiliation_to_json(
  us_core_tribal_affiliation: UsCoreTribalAffiliation,
) -> Json {
  extension_to_json(us_core_tribal_affiliation_to_ext(
    us_core_tribal_affiliation,
  ))
}

pub fn us_core_tribal_affiliation_decoder() -> Decoder(
  Result(UsCoreTribalAffiliation, Extension),
) {
  use ext <- decode.then(extension_decoder())
  case us_core_tribal_affiliation_from_ext(ext) {
    Ok(result) -> decode.success(Ok(result))
    Error(Nil) -> decode.success(Error(ext))
  }
}

pub fn us_core_tribal_affiliation_from_ext(
  ext: Extension,
) -> Result(UsCoreTribalAffiliation, Nil) {
  case ext.url, ext.ext {
    "http://hl7.org/fhir/us/core/StructureDefinition/us-core-tribal-affiliation",
      ExtComplex(children)
    -> {
      let ext_dict = exts_to_extdict(children)
      use tribal_affiliation <- result.try(
        case dict.get(ext_dict.exts_by_url, "tribalAffiliation") {
          Error(_) -> Error(Nil)
          Ok([
            ExtDictContent(
              content: ExtDictSimple(ExtensionValueCodeableconcept(v)),
              ..,
            ),
          ]) -> Ok(v)
          Ok(_) -> Error(Nil)
        },
      )
      use is_enrolled <- result.try(
        case dict.get(ext_dict.exts_by_url, "isEnrolled") {
          Error(_) -> Ok(None)
          Ok([
            ExtDictContent(content: ExtDictSimple(ExtensionValueBoolean(v)), ..),
          ]) -> Ok(Some(v))
          Ok(_) -> Error(Nil)
        },
      )
      Ok(UsCoreTribalAffiliation(tribal_affiliation:, is_enrolled:))
    }
    _, _ -> Error(Nil)
  }
}

///[http://hl7.org/fhir/r4us/us/core/StructureDefinition/us-core-jurisdiction#resource](http://hl7.org/fhir/r4us/us/core/StructureDefinition/us-core-jurisdiction#resource)
pub fn us_core_jurisdiction_to_ext(value: Codeableconcept) -> Extension {
  Extension(
    id: None,
    url: "http://hl7.org/fhir/us/core/StructureDefinition/us-core-jurisdiction",
    ext: ExtSimple(ExtensionValueCodeableconcept(value)),
  )
}

pub fn us_core_jurisdiction_to_json(
  us_core_jurisdiction: Codeableconcept,
) -> Json {
  extension_to_json(us_core_jurisdiction_to_ext(us_core_jurisdiction))
}

pub fn us_core_jurisdiction_decoder() -> Decoder(
  Result(Codeableconcept, Extension),
) {
  use ext <- decode.then(extension_decoder())
  case us_core_jurisdiction_from_ext(ext) {
    Ok(result) -> decode.success(Ok(result))
    Error(Nil) -> decode.success(Error(ext))
  }
}

pub fn us_core_jurisdiction_from_ext(
  ext: Extension,
) -> Result(Codeableconcept, Nil) {
  case ext.url, ext.ext {
    "http://hl7.org/fhir/us/core/StructureDefinition/us-core-jurisdiction",
      ExtSimple(ExtensionValueCodeableconcept(v))
    -> Ok(v)
    _, _ -> Error(Nil)
  }
}

pub type ExtDict {
  ExtDict(exts_by_url: Dict(String, List(ExtDictContent)))
}

pub type ExtDictContent {
  ExtDictContent(id: Option(String), content: ExtDictSimpleOrComplex)
}

pub type ExtDictSimpleOrComplex {
  ExtDictComplex(children: ExtDict)
  ExtDictSimple(value: ExtensionValue)
}

pub fn exts_to_extdict(exts: List(Extension)) -> ExtDict {
  list.fold(from: dict.new(), over: exts, with: fn(acc, ext) {
    let content = case ext.ext {
      ExtSimple(v) -> ExtDictSimple(v)
      ExtComplex(c) -> ExtDictComplex(exts_to_extdict(c))
    }
    let new_ext = ExtDictContent(id: ext.id, content:)
    let new_ext_list = case dict.get(acc, ext.url) {
      Ok(exts) -> [new_ext, ..exts]
      Error(_) -> [new_ext]
    }
    acc |> dict.insert(ext.url, new_ext_list)
  })
  |> ExtDict
}

///[http://hl7.org/fhir/r4/StructureDefinition/Extension#resource](http://hl7.org/fhir/r4/StructureDefinition/Extension#resource)
pub type Extension {
  Extension(id: Option(String), url: String, ext: ExtensionSimpleOrComplex)
}

///[http://hl7.org/fhir/r4/StructureDefinition/Extension#resource](http://hl7.org/fhir/r4/StructureDefinition/Extension#resource)
pub type ExtensionSimpleOrComplex {
  ExtComplex(children: List(Extension))
  ExtSimple(value: ExtensionValue)
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
  let Extension(id:, url:, ext:) = extension
  let fields = [#("url", json.string(url))]
  let fields = case id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  let fields = [ext_simple_or_complex_to_json(ext), ..fields]
  json.object(fields)
}

fn ext_simple_or_complex_to_json(ext) {
  case ext {
    ExtComplex(children) -> #(
      "extension",
      json.array(children, extension_to_json),
    )
    ExtSimple(val) -> extsimple_to_json(val)
  }
}

fn extsimple_to_json(v: ExtensionValue) -> #(String, Json) {
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

pub fn extension_value_to_json(elt: ExtensionValue) -> Json {
  case elt {
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
  use ext <- decode.then(ext_simple_or_complex_decoder())
  decode.success(Extension(url:, id:, ext:))
}

pub fn ext_simple_or_complex_decoder() {
  decode.one_of(
    decode.field("extension", decode.list(extension_decoder()), decode.success)
      |> decode.map(ExtComplex),
    [
      decode.field("valueBase64Binary", decode.string, decode.success)
        |> decode.map(ExtensionValueBase64binary)
        |> decode.map(ExtSimple),
      decode.field("valueBoolean", decode.bool, decode.success)
        |> decode.map(ExtensionValueBoolean)
        |> decode.map(ExtSimple),
      decode.field("valueCanonical", decode.string, decode.success)
        |> decode.map(ExtensionValueCanonical)
        |> decode.map(ExtSimple),
      decode.field("valueCode", decode.string, decode.success)
        |> decode.map(ExtensionValueCode)
        |> decode.map(ExtSimple),
      decode.field("valueDate", pt.date_decoder(), decode.success)
        |> decode.map(ExtensionValueDate)
        |> decode.map(ExtSimple),
      decode.field("valueDateTime", pt.datetime_decoder(), decode.success)
        |> decode.map(ExtensionValueDatetime)
        |> decode.map(ExtSimple),
      decode.field("valueDecimal", decode_number(), decode.success)
        |> decode.map(ExtensionValueDecimal)
        |> decode.map(ExtSimple),
      decode.field("valueId", decode.string, decode.success)
        |> decode.map(ExtensionValueId)
        |> decode.map(ExtSimple),
      decode.field("valueInstant", pt.instant_decoder(), decode.success)
        |> decode.map(ExtensionValueInstant)
        |> decode.map(ExtSimple),
      decode.field("valueInteger", decode.int, decode.success)
        |> decode.map(ExtensionValueInteger)
        |> decode.map(ExtSimple),
      decode.field("valueMarkdown", decode.string, decode.success)
        |> decode.map(ExtensionValueMarkdown)
        |> decode.map(ExtSimple),
      decode.field("valueOid", decode.string, decode.success)
        |> decode.map(ExtensionValueOid)
        |> decode.map(ExtSimple),
      decode.field("valuePositiveInt", decode.int, decode.success)
        |> decode.map(ExtensionValuePositiveint)
        |> decode.map(ExtSimple),
      decode.field("valueString", decode.string, decode.success)
        |> decode.map(ExtensionValueString)
        |> decode.map(ExtSimple),
      decode.field("valueTime", pt.time_decoder(), decode.success)
        |> decode.map(ExtensionValueTime)
        |> decode.map(ExtSimple),
      decode.field("valueUnsignedInt", decode.int, decode.success)
        |> decode.map(ExtensionValueUnsignedint)
        |> decode.map(ExtSimple),
      decode.field("valueUri", decode.string, decode.success)
        |> decode.map(ExtensionValueUri)
        |> decode.map(ExtSimple),
      decode.field("valueUrl", decode.string, decode.success)
        |> decode.map(ExtensionValueUrl)
        |> decode.map(ExtSimple),
      decode.field("valueUuid", decode.string, decode.success)
        |> decode.map(ExtensionValueUuid)
        |> decode.map(ExtSimple),
      decode.field("valueAddress", address_decoder(), decode.success)
        |> decode.map(ExtensionValueAddress)
        |> decode.map(ExtSimple),
      decode.field("valueAge", age_decoder(), decode.success)
        |> decode.map(ExtensionValueAge)
        |> decode.map(ExtSimple),
      decode.field("valueAnnotation", annotation_decoder(), decode.success)
        |> decode.map(ExtensionValueAnnotation)
        |> decode.map(ExtSimple),
      decode.field("valueAttachment", attachment_decoder(), decode.success)
        |> decode.map(ExtensionValueAttachment)
        |> decode.map(ExtSimple),
      decode.field(
        "valueCodeableConcept",
        codeableconcept_decoder(),
        decode.success,
      )
        |> decode.map(ExtensionValueCodeableconcept)
        |> decode.map(ExtSimple),
      decode.field("valueCoding", coding_decoder(), decode.success)
        |> decode.map(ExtensionValueCoding)
        |> decode.map(ExtSimple),
      decode.field("valueContactPoint", contactpoint_decoder(), decode.success)
        |> decode.map(ExtensionValueContactpoint)
        |> decode.map(ExtSimple),
      decode.field("valueCount", count_decoder(), decode.success)
        |> decode.map(ExtensionValueCount)
        |> decode.map(ExtSimple),
      decode.field("valueDistance", distance_decoder(), decode.success)
        |> decode.map(ExtensionValueDistance)
        |> decode.map(ExtSimple),
      decode.field("valueDuration", duration_decoder(), decode.success)
        |> decode.map(ExtensionValueDuration)
        |> decode.map(ExtSimple),
      decode.field("valueHumanName", humanname_decoder(), decode.success)
        |> decode.map(ExtensionValueHumanname)
        |> decode.map(ExtSimple),
      decode.field("valueIdentifier", identifier_decoder(), decode.success)
        |> decode.map(ExtensionValueIdentifier)
        |> decode.map(ExtSimple),
      decode.field("valueMoney", money_decoder(), decode.success)
        |> decode.map(ExtensionValueMoney)
        |> decode.map(ExtSimple),
      decode.field("valuePeriod", period_decoder(), decode.success)
        |> decode.map(ExtensionValuePeriod)
        |> decode.map(ExtSimple),
      decode.field("valueQuantity", quantity_decoder(), decode.success)
        |> decode.map(ExtensionValueQuantity)
        |> decode.map(ExtSimple),
      decode.field("valueRange", range_decoder(), decode.success)
        |> decode.map(ExtensionValueRange)
        |> decode.map(ExtSimple),
      decode.field("valueRatio", ratio_decoder(), decode.success)
        |> decode.map(ExtensionValueRatio)
        |> decode.map(ExtSimple),
      decode.field("valueReference", reference_decoder(), decode.success)
        |> decode.map(ExtensionValueReference)
        |> decode.map(ExtSimple),
      decode.field("valueSampledData", sampleddata_decoder(), decode.success)
        |> decode.map(ExtensionValueSampleddata)
        |> decode.map(ExtSimple),
      decode.field("valueSignature", signature_decoder(), decode.success)
        |> decode.map(ExtensionValueSignature)
        |> decode.map(ExtSimple),
      decode.field("valueTiming", timing_decoder(), decode.success)
        |> decode.map(ExtensionValueTiming)
        |> decode.map(ExtSimple),
      decode.field(
        "valueContactDetail",
        contactdetail_decoder(),
        decode.success,
      )
        |> decode.map(ExtensionValueContactdetail)
        |> decode.map(ExtSimple),
      decode.field("valueContributor", contributor_decoder(), decode.success)
        |> decode.map(ExtensionValueContributor)
        |> decode.map(ExtSimple),
      decode.field(
        "valueDataRequirement",
        datarequirement_decoder(),
        decode.success,
      )
        |> decode.map(ExtensionValueDatarequirement)
        |> decode.map(ExtSimple),
      decode.field("valueExpression", expression_decoder(), decode.success)
        |> decode.map(ExtensionValueExpression)
        |> decode.map(ExtSimple),
      decode.field(
        "valueParameterDefinition",
        parameterdefinition_decoder(),
        decode.success,
      )
        |> decode.map(ExtensionValueParameterdefinition)
        |> decode.map(ExtSimple),
      decode.field(
        "valueRelatedArtifact",
        relatedartifact_decoder(),
        decode.success,
      )
        |> decode.map(ExtensionValueRelatedartifact)
        |> decode.map(ExtSimple),
      decode.field(
        "valueTriggerDefinition",
        triggerdefinition_decoder(),
        decode.success,
      )
        |> decode.map(ExtensionValueTriggerdefinition)
        |> decode.map(ExtSimple),
      decode.field("valueUsageContext", usagecontext_decoder(), decode.success)
        |> decode.map(ExtensionValueUsagecontext)
        |> decode.map(ExtSimple),
      decode.field("valueDosage", dosage_decoder(), decode.success)
        |> decode.map(ExtensionValueDosage)
        |> decode.map(ExtSimple),
      decode.field("valueMeta", meta_decoder(), decode.success)
        |> decode.map(ExtensionValueMeta)
        |> decode.map(ExtSimple),
    ],
  )
}

///[http://hl7.org/fhir/r4us/StructureDefinition/HumanName#resource](http://hl7.org/fhir/r4us/StructureDefinition/HumanName#resource)
pub type Humanname {
  Humanname(
    id: Option(String),
    extension: List(Extension),
    use_: Option(valuesets.Nameuse),
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
  let Humanname(
    period:,
    suffix:,
    prefix:,
    given:,
    family:,
    text:,
    use_:,
    extension:,
    id:,
  ) = humanname
  let fields = []
  let fields = case period {
    Some(v) -> [#("period", period_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case suffix {
    [] -> fields
    _ -> [#("suffix", json.array(suffix, json.string)), ..fields]
  }
  let fields = case prefix {
    [] -> fields
    _ -> [#("prefix", json.array(prefix, json.string)), ..fields]
  }
  let fields = case given {
    [] -> fields
    _ -> [#("given", json.array(given, json.string)), ..fields]
  }
  let fields = case family {
    Some(v) -> [#("family", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case text {
    Some(v) -> [#("text", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case use_ {
    Some(v) -> [#("use", valuesets.nameuse_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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
    decode.optional(valuesets.nameuse_decoder()),
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

///[http://hl7.org/fhir/r4us/StructureDefinition/Identifier#resource](http://hl7.org/fhir/r4us/StructureDefinition/Identifier#resource)
pub type Identifier {
  Identifier(
    id: Option(String),
    extension: List(Extension),
    use_: Option(valuesets.Identifieruse),
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
  let Identifier(
    assigner:,
    period:,
    value:,
    system:,
    type_:,
    use_:,
    extension:,
    id:,
  ) = identifier
  let fields = []
  let fields = case assigner {
    Some(v) -> [#("assigner", reference_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case period {
    Some(v) -> [#("period", period_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case value {
    Some(v) -> [#("value", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case system {
    Some(v) -> [#("system", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case type_ {
    Some(v) -> [#("type", codeableconcept_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case use_ {
    Some(v) -> [#("use", valuesets.identifieruse_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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
    decode.optional(valuesets.identifieruse_decoder()),
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

///[http://hl7.org/fhir/r4us/StructureDefinition/MarketingStatus#resource](http://hl7.org/fhir/r4us/StructureDefinition/MarketingStatus#resource)
pub type Marketingstatus {
  Marketingstatus(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    country: Codeableconcept,
    jurisdiction: Option(Codeableconcept),
    status: Codeableconcept,
    date_range: Period,
    restore_date: Option(DateTime),
  )
}

pub fn marketingstatus_new(
  date_range date_range: Period,
  status status: Codeableconcept,
  country country: Codeableconcept,
) -> Marketingstatus {
  Marketingstatus(
    restore_date: None,
    date_range:,
    status:,
    jurisdiction: None,
    country:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

pub fn marketingstatus_to_json(marketingstatus: Marketingstatus) -> Json {
  let Marketingstatus(
    restore_date:,
    date_range:,
    status:,
    jurisdiction:,
    country:,
    modifier_extension:,
    extension:,
    id:,
  ) = marketingstatus
  let fields = [
    #("dateRange", period_to_json(date_range)),
    #("status", codeableconcept_to_json(status)),
    #("country", codeableconcept_to_json(country)),
  ]
  let fields = case restore_date {
    Some(v) -> [#("restoreDate", pt.datetime_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case jurisdiction {
    Some(v) -> [#("jurisdiction", codeableconcept_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case modifier_extension {
    [] -> fields
    _ -> [
      #("modifierExtension", json.array(modifier_extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn marketingstatus_decoder() -> Decoder(Marketingstatus) {
  use <- decode.recursive
  use restore_date <- decode.optional_field(
    "restoreDate",
    None,
    decode.optional(pt.datetime_decoder()),
  )
  use date_range <- decode.field("dateRange", period_decoder())
  use status <- decode.field("status", codeableconcept_decoder())
  use jurisdiction <- decode.optional_field(
    "jurisdiction",
    None,
    decode.optional(codeableconcept_decoder()),
  )
  use country <- decode.field("country", codeableconcept_decoder())
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
  decode.success(Marketingstatus(
    restore_date:,
    date_range:,
    status:,
    jurisdiction:,
    country:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4us/StructureDefinition/Meta#resource](http://hl7.org/fhir/r4us/StructureDefinition/Meta#resource)
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
  let Meta(
    tag:,
    security:,
    profile:,
    source:,
    last_updated:,
    version_id:,
    extension:,
    id:,
  ) = meta
  let fields = []
  let fields = case tag {
    [] -> fields
    _ -> [#("tag", json.array(tag, coding_to_json)), ..fields]
  }
  let fields = case security {
    [] -> fields
    _ -> [#("security", json.array(security, coding_to_json)), ..fields]
  }
  let fields = case profile {
    [] -> fields
    _ -> [#("profile", json.array(profile, json.string)), ..fields]
  }
  let fields = case source {
    Some(v) -> [#("source", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case last_updated {
    Some(v) -> [#("lastUpdated", pt.instant_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case version_id {
    Some(v) -> [#("versionId", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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

///[http://hl7.org/fhir/r4us/StructureDefinition/Money#resource](http://hl7.org/fhir/r4us/StructureDefinition/Money#resource)
pub type Money {
  Money(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    currency: Option(String),
  )
}

pub fn money_new() -> Money {
  Money(currency: None, value: None, extension: [], id: None)
}

pub fn money_to_json(money: Money) -> Json {
  let Money(currency:, value:, extension:, id:) = money
  let fields = []
  let fields = case currency {
    Some(v) -> [#("currency", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case value {
    Some(v) -> [#("value", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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
    decode.optional(decode.string),
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

///[http://hl7.org/fhir/r4us/StructureDefinition/Narrative#resource](http://hl7.org/fhir/r4us/StructureDefinition/Narrative#resource)
pub type Narrative {
  Narrative(
    id: Option(String),
    extension: List(Extension),
    status: valuesets.Narrativestatus,
    div: String,
  )
}

pub fn narrative_new(
  div div: String,
  status status: valuesets.Narrativestatus,
) -> Narrative {
  Narrative(div:, status:, extension: [], id: None)
}

pub fn narrative_to_json(narrative: Narrative) -> Json {
  let Narrative(div:, status:, extension:, id:) = narrative
  let fields = [
    #("div", json.string(div)),
    #("status", valuesets.narrativestatus_to_json(status)),
  ]
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn narrative_decoder() -> Decoder(Narrative) {
  use <- decode.recursive
  use div <- decode.field("div", decode.string)
  use status <- decode.field("status", valuesets.narrativestatus_decoder())
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(Narrative(div:, status:, extension:, id:))
}

///[http://hl7.org/fhir/r4us/StructureDefinition/ParameterDefinition#resource](http://hl7.org/fhir/r4us/StructureDefinition/ParameterDefinition#resource)
pub type Parameterdefinition {
  Parameterdefinition(
    id: Option(String),
    extension: List(Extension),
    name: Option(String),
    use_: valuesets.Operationparameteruse,
    min: Option(Int),
    max: Option(String),
    documentation: Option(String),
    type_: valuesets.Alltypes,
    profile: Option(String),
  )
}

pub fn parameterdefinition_new(
  type_ type_: valuesets.Alltypes,
  use_ use_: valuesets.Operationparameteruse,
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
  let Parameterdefinition(
    profile:,
    type_:,
    documentation:,
    max:,
    min:,
    use_:,
    name:,
    extension:,
    id:,
  ) = parameterdefinition
  let fields = [
    #("type", valuesets.alltypes_to_json(type_)),
    #("use", valuesets.operationparameteruse_to_json(use_)),
  ]
  let fields = case profile {
    Some(v) -> [#("profile", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case documentation {
    Some(v) -> [#("documentation", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case max {
    Some(v) -> [#("max", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case min {
    Some(v) -> [#("min", json.int(v)), ..fields]
    None -> fields
  }
  let fields = case name {
    Some(v) -> [#("name", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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
  use type_ <- decode.field("type", valuesets.alltypes_decoder())
  use documentation <- decode.optional_field(
    "documentation",
    None,
    decode.optional(decode.string),
  )
  use max <- decode.optional_field("max", None, decode.optional(decode.string))
  use min <- decode.optional_field("min", None, decode.optional(decode.int))
  use use_ <- decode.field("use", valuesets.operationparameteruse_decoder())
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

///[http://hl7.org/fhir/r4us/StructureDefinition/Period#resource](http://hl7.org/fhir/r4us/StructureDefinition/Period#resource)
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
  let Period(end:, start:, extension:, id:) = period
  let fields = []
  let fields = case end {
    Some(v) -> [#("end", pt.datetime_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case start {
    Some(v) -> [#("start", pt.datetime_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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

///[http://hl7.org/fhir/r4us/StructureDefinition/Population#resource](http://hl7.org/fhir/r4us/StructureDefinition/Population#resource)
pub type Population {
  Population(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    age: Option(PopulationAge),
    gender: Option(Codeableconcept),
    race: Option(Codeableconcept),
    physiological_condition: Option(Codeableconcept),
  )
}

///[http://hl7.org/fhir/r4us/StructureDefinition/Population#resource](http://hl7.org/fhir/r4us/StructureDefinition/Population#resource)
pub type PopulationAge {
  PopulationAgeRange(age: Range)
  PopulationAgeCodeableconcept(age: Codeableconcept)
}

pub fn population_age_to_json(elt: PopulationAge) -> Json {
  case elt {
    PopulationAgeRange(v) -> range_to_json(v)
    PopulationAgeCodeableconcept(v) -> codeableconcept_to_json(v)
  }
}

pub fn population_age_decoder() -> Decoder(PopulationAge) {
  decode.one_of(
    decode.field("ageRange", range_decoder(), decode.success)
      |> decode.map(PopulationAgeRange),
    [
      decode.field(
        "ageCodeableConcept",
        codeableconcept_decoder(),
        decode.success,
      )
      |> decode.map(PopulationAgeCodeableconcept),
    ],
  )
}

pub fn population_new() -> Population {
  Population(
    physiological_condition: None,
    race: None,
    gender: None,
    age: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

pub fn population_to_json(population: Population) -> Json {
  let Population(
    physiological_condition:,
    race:,
    gender:,
    age:,
    modifier_extension:,
    extension:,
    id:,
  ) = population
  let fields = []
  let fields = case physiological_condition {
    Some(v) -> [
      #("physiologicalCondition", codeableconcept_to_json(v)),
      ..fields
    ]
    None -> fields
  }
  let fields = case race {
    Some(v) -> [#("race", codeableconcept_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case gender {
    Some(v) -> [#("gender", codeableconcept_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case age {
    Some(v) -> [
      #(
        "age"
          <> case v {
          PopulationAgeRange(_) -> "Range"
          PopulationAgeCodeableconcept(_) -> "CodeableConcept"
        },
        population_age_to_json(v),
      ),
      ..fields
    ]
    None -> fields
  }
  let fields = case modifier_extension {
    [] -> fields
    _ -> [
      #("modifierExtension", json.array(modifier_extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn population_decoder() -> Decoder(Population) {
  use <- decode.recursive
  use physiological_condition <- decode.optional_field(
    "physiologicalCondition",
    None,
    decode.optional(codeableconcept_decoder()),
  )
  use race <- decode.optional_field(
    "race",
    None,
    decode.optional(codeableconcept_decoder()),
  )
  use gender <- decode.optional_field(
    "gender",
    None,
    decode.optional(codeableconcept_decoder()),
  )
  use age <- decode.then(none_if_omitted(population_age_decoder()))
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
  decode.success(Population(
    physiological_condition:,
    race:,
    gender:,
    age:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4us/StructureDefinition/ProdCharacteristic#resource](http://hl7.org/fhir/r4us/StructureDefinition/ProdCharacteristic#resource)
pub type Prodcharacteristic {
  Prodcharacteristic(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    height: Option(Quantity),
    width: Option(Quantity),
    depth: Option(Quantity),
    weight: Option(Quantity),
    nominal_volume: Option(Quantity),
    external_diameter: Option(Quantity),
    shape: Option(String),
    color: List(String),
    imprint: List(String),
    image: List(Attachment),
    scoring: Option(Codeableconcept),
  )
}

pub fn prodcharacteristic_new() -> Prodcharacteristic {
  Prodcharacteristic(
    scoring: None,
    image: [],
    imprint: [],
    color: [],
    shape: None,
    external_diameter: None,
    nominal_volume: None,
    weight: None,
    depth: None,
    width: None,
    height: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

pub fn prodcharacteristic_to_json(
  prodcharacteristic: Prodcharacteristic,
) -> Json {
  let Prodcharacteristic(
    scoring:,
    image:,
    imprint:,
    color:,
    shape:,
    external_diameter:,
    nominal_volume:,
    weight:,
    depth:,
    width:,
    height:,
    modifier_extension:,
    extension:,
    id:,
  ) = prodcharacteristic
  let fields = []
  let fields = case scoring {
    Some(v) -> [#("scoring", codeableconcept_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case image {
    [] -> fields
    _ -> [#("image", json.array(image, attachment_to_json)), ..fields]
  }
  let fields = case imprint {
    [] -> fields
    _ -> [#("imprint", json.array(imprint, json.string)), ..fields]
  }
  let fields = case color {
    [] -> fields
    _ -> [#("color", json.array(color, json.string)), ..fields]
  }
  let fields = case shape {
    Some(v) -> [#("shape", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case external_diameter {
    Some(v) -> [#("externalDiameter", quantity_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case nominal_volume {
    Some(v) -> [#("nominalVolume", quantity_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case weight {
    Some(v) -> [#("weight", quantity_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case depth {
    Some(v) -> [#("depth", quantity_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case width {
    Some(v) -> [#("width", quantity_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case height {
    Some(v) -> [#("height", quantity_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case modifier_extension {
    [] -> fields
    _ -> [
      #("modifierExtension", json.array(modifier_extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn prodcharacteristic_decoder() -> Decoder(Prodcharacteristic) {
  use <- decode.recursive
  use scoring <- decode.optional_field(
    "scoring",
    None,
    decode.optional(codeableconcept_decoder()),
  )
  use image <- decode.optional_field(
    "image",
    [],
    decode.list(attachment_decoder()),
  )
  use imprint <- decode.optional_field(
    "imprint",
    [],
    decode.list(decode.string),
  )
  use color <- decode.optional_field("color", [], decode.list(decode.string))
  use shape <- decode.optional_field(
    "shape",
    None,
    decode.optional(decode.string),
  )
  use external_diameter <- decode.optional_field(
    "externalDiameter",
    None,
    decode.optional(quantity_decoder()),
  )
  use nominal_volume <- decode.optional_field(
    "nominalVolume",
    None,
    decode.optional(quantity_decoder()),
  )
  use weight <- decode.optional_field(
    "weight",
    None,
    decode.optional(quantity_decoder()),
  )
  use depth <- decode.optional_field(
    "depth",
    None,
    decode.optional(quantity_decoder()),
  )
  use width <- decode.optional_field(
    "width",
    None,
    decode.optional(quantity_decoder()),
  )
  use height <- decode.optional_field(
    "height",
    None,
    decode.optional(quantity_decoder()),
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
  decode.success(Prodcharacteristic(
    scoring:,
    image:,
    imprint:,
    color:,
    shape:,
    external_diameter:,
    nominal_volume:,
    weight:,
    depth:,
    width:,
    height:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4us/StructureDefinition/ProductShelfLife#resource](http://hl7.org/fhir/r4us/StructureDefinition/ProductShelfLife#resource)
pub type Productshelflife {
  Productshelflife(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Option(Identifier),
    type_: Codeableconcept,
    period: Quantity,
    special_precautions_for_storage: List(Codeableconcept),
  )
}

pub fn productshelflife_new(
  period period: Quantity,
  type_ type_: Codeableconcept,
) -> Productshelflife {
  Productshelflife(
    special_precautions_for_storage: [],
    period:,
    type_:,
    identifier: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

pub fn productshelflife_to_json(productshelflife: Productshelflife) -> Json {
  let Productshelflife(
    special_precautions_for_storage:,
    period:,
    type_:,
    identifier:,
    modifier_extension:,
    extension:,
    id:,
  ) = productshelflife
  let fields = [
    #("period", quantity_to_json(period)),
    #("type", codeableconcept_to_json(type_)),
  ]
  let fields = case special_precautions_for_storage {
    [] -> fields
    _ -> [
      #(
        "specialPrecautionsForStorage",
        json.array(special_precautions_for_storage, codeableconcept_to_json),
      ),
      ..fields
    ]
  }
  let fields = case identifier {
    Some(v) -> [#("identifier", identifier_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case modifier_extension {
    [] -> fields
    _ -> [
      #("modifierExtension", json.array(modifier_extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn productshelflife_decoder() -> Decoder(Productshelflife) {
  use <- decode.recursive
  use special_precautions_for_storage <- decode.optional_field(
    "specialPrecautionsForStorage",
    [],
    decode.list(codeableconcept_decoder()),
  )
  use period <- decode.field("period", quantity_decoder())
  use type_ <- decode.field("type", codeableconcept_decoder())
  use identifier <- decode.optional_field(
    "identifier",
    None,
    decode.optional(identifier_decoder()),
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
  decode.success(Productshelflife(
    special_precautions_for_storage:,
    period:,
    type_:,
    identifier:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4us/StructureDefinition/Quantity#resource](http://hl7.org/fhir/r4us/StructureDefinition/Quantity#resource)
pub type Quantity {
  Quantity(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(valuesets.Quantitycomparator),
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
  let Quantity(code:, system:, unit:, comparator:, value:, extension:, id:) =
    quantity
  let fields = []
  let fields = case code {
    Some(v) -> [#("code", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case system {
    Some(v) -> [#("system", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case unit {
    Some(v) -> [#("unit", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case comparator {
    Some(v) -> [
      #("comparator", valuesets.quantitycomparator_to_json(v)),
      ..fields
    ]
    None -> fields
  }
  let fields = case value {
    Some(v) -> [#("value", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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
    decode.optional(valuesets.quantitycomparator_decoder()),
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

///[http://hl7.org/fhir/r4us/StructureDefinition/Range#resource](http://hl7.org/fhir/r4us/StructureDefinition/Range#resource)
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
  let Range(high:, low:, extension:, id:) = range
  let fields = []
  let fields = case high {
    Some(v) -> [#("high", quantity_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case low {
    Some(v) -> [#("low", quantity_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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

///[http://hl7.org/fhir/r4us/StructureDefinition/Ratio#resource](http://hl7.org/fhir/r4us/StructureDefinition/Ratio#resource)
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
  let Ratio(denominator:, numerator:, extension:, id:) = ratio
  let fields = []
  let fields = case denominator {
    Some(v) -> [#("denominator", quantity_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case numerator {
    Some(v) -> [#("numerator", quantity_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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

///[http://hl7.org/fhir/r4us/StructureDefinition/Reference#resource](http://hl7.org/fhir/r4us/StructureDefinition/Reference#resource)
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
  let Reference(display:, identifier:, type_:, reference:, extension:, id:) =
    reference
  let fields = []
  let fields = case display {
    Some(v) -> [#("display", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case identifier {
    Some(v) -> [#("identifier", identifier_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case type_ {
    Some(v) -> [#("type", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case reference {
    Some(v) -> [#("reference", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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

///[http://hl7.org/fhir/r4us/StructureDefinition/RelatedArtifact#resource](http://hl7.org/fhir/r4us/StructureDefinition/RelatedArtifact#resource)
pub type Relatedartifact {
  Relatedartifact(
    id: Option(String),
    extension: List(Extension),
    type_: valuesets.Relatedartifacttype,
    label: Option(String),
    display: Option(String),
    citation: Option(String),
    url: Option(String),
    document: Option(Attachment),
    resource: Option(String),
  )
}

pub fn relatedartifact_new(
  type_ type_: valuesets.Relatedartifacttype,
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
  let Relatedartifact(
    resource:,
    document:,
    url:,
    citation:,
    display:,
    label:,
    type_:,
    extension:,
    id:,
  ) = relatedartifact
  let fields = [
    #("type", valuesets.relatedartifacttype_to_json(type_)),
  ]
  let fields = case resource {
    Some(v) -> [#("resource", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case document {
    Some(v) -> [#("document", attachment_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case url {
    Some(v) -> [#("url", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case citation {
    Some(v) -> [#("citation", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case display {
    Some(v) -> [#("display", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case label {
    Some(v) -> [#("label", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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
  use type_ <- decode.field("type", valuesets.relatedartifacttype_decoder())
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

///[http://hl7.org/fhir/r4us/StructureDefinition/SampledData#resource](http://hl7.org/fhir/r4us/StructureDefinition/SampledData#resource)
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
  let Sampleddata(
    data:,
    dimensions:,
    upper_limit:,
    lower_limit:,
    factor:,
    period:,
    origin:,
    extension:,
    id:,
  ) = sampleddata
  let fields = [
    #("dimensions", json.int(dimensions)),
    #("period", json.float(period)),
    #("origin", quantity_to_json(origin)),
  ]
  let fields = case data {
    Some(v) -> [#("data", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case upper_limit {
    Some(v) -> [#("upperLimit", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case lower_limit {
    Some(v) -> [#("lowerLimit", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case factor {
    Some(v) -> [#("factor", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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

///[http://hl7.org/fhir/r4us/StructureDefinition/Signature#resource](http://hl7.org/fhir/r4us/StructureDefinition/Signature#resource)
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
  let Signature(
    data:,
    sig_format:,
    target_format:,
    on_behalf_of:,
    who:,
    when:,
    type_:,
    extension:,
    id:,
  ) = signature
  let fields = [
    #("who", reference_to_json(who)),
    #("when", pt.instant_to_json(when)),
    #("type", list1_to_json(type_, coding_to_json)),
  ]
  let fields = case data {
    Some(v) -> [#("data", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case sig_format {
    Some(v) -> [#("sigFormat", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case target_format {
    Some(v) -> [#("targetFormat", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case on_behalf_of {
    Some(v) -> [#("onBehalfOf", reference_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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

///[http://hl7.org/fhir/r4us/StructureDefinition/SubstanceAmount#resource](http://hl7.org/fhir/r4us/StructureDefinition/SubstanceAmount#resource)
pub type Substanceamount {
  Substanceamount(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    amount: Option(SubstanceamountAmount),
    amount_type: Option(Codeableconcept),
    amount_text: Option(String),
    reference_range: Option(SubstanceamountReferencerange),
  )
}

///[http://hl7.org/fhir/r4us/StructureDefinition/SubstanceAmount#resource](http://hl7.org/fhir/r4us/StructureDefinition/SubstanceAmount#resource)
pub type SubstanceamountAmount {
  SubstanceamountAmountQuantity(amount: Quantity)
  SubstanceamountAmountRange(amount: Range)
  SubstanceamountAmountString(amount: String)
}

pub fn substanceamount_amount_to_json(elt: SubstanceamountAmount) -> Json {
  case elt {
    SubstanceamountAmountQuantity(v) -> quantity_to_json(v)
    SubstanceamountAmountRange(v) -> range_to_json(v)
    SubstanceamountAmountString(v) -> json.string(v)
  }
}

pub fn substanceamount_amount_decoder() -> Decoder(SubstanceamountAmount) {
  decode.one_of(
    decode.field("amountQuantity", quantity_decoder(), decode.success)
      |> decode.map(SubstanceamountAmountQuantity),
    [
      decode.field("amountRange", range_decoder(), decode.success)
        |> decode.map(SubstanceamountAmountRange),
      decode.field("amountString", decode.string, decode.success)
        |> decode.map(SubstanceamountAmountString),
    ],
  )
}

pub fn substanceamount_new() -> Substanceamount {
  Substanceamount(
    reference_range: None,
    amount_text: None,
    amount_type: None,
    amount: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///[http://hl7.org/fhir/r4us/StructureDefinition/SubstanceAmount#resource](http://hl7.org/fhir/r4us/StructureDefinition/SubstanceAmount#resource)
pub type SubstanceamountReferencerange {
  SubstanceamountReferencerange(
    id: Option(String),
    extension: List(Extension),
    low_limit: Option(Quantity),
    high_limit: Option(Quantity),
  )
}

pub fn substanceamount_referencerange_new() -> SubstanceamountReferencerange {
  SubstanceamountReferencerange(
    high_limit: None,
    low_limit: None,
    extension: [],
    id: None,
  )
}

pub fn substanceamount_referencerange_to_json(
  substanceamount_referencerange: SubstanceamountReferencerange,
) -> Json {
  let SubstanceamountReferencerange(high_limit:, low_limit:, extension:, id:) =
    substanceamount_referencerange
  let fields = []
  let fields = case high_limit {
    Some(v) -> [#("highLimit", quantity_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case low_limit {
    Some(v) -> [#("lowLimit", quantity_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn substanceamount_referencerange_decoder() -> Decoder(
  SubstanceamountReferencerange,
) {
  use <- decode.recursive
  use high_limit <- decode.optional_field(
    "highLimit",
    None,
    decode.optional(quantity_decoder()),
  )
  use low_limit <- decode.optional_field(
    "lowLimit",
    None,
    decode.optional(quantity_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(SubstanceamountReferencerange(
    high_limit:,
    low_limit:,
    extension:,
    id:,
  ))
}

pub fn substanceamount_to_json(substanceamount: Substanceamount) -> Json {
  let Substanceamount(
    reference_range:,
    amount_text:,
    amount_type:,
    amount:,
    modifier_extension:,
    extension:,
    id:,
  ) = substanceamount
  let fields = []
  let fields = case reference_range {
    Some(v) -> [
      #("referenceRange", substanceamount_referencerange_to_json(v)),
      ..fields
    ]
    None -> fields
  }
  let fields = case amount_text {
    Some(v) -> [#("amountText", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case amount_type {
    Some(v) -> [#("amountType", codeableconcept_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case amount {
    Some(v) -> [
      #(
        "amount"
          <> case v {
          SubstanceamountAmountQuantity(_) -> "Quantity"
          SubstanceamountAmountRange(_) -> "Range"
          SubstanceamountAmountString(_) -> "String"
        },
        substanceamount_amount_to_json(v),
      ),
      ..fields
    ]
    None -> fields
  }
  let fields = case modifier_extension {
    [] -> fields
    _ -> [
      #("modifierExtension", json.array(modifier_extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn substanceamount_decoder() -> Decoder(Substanceamount) {
  use <- decode.recursive
  use reference_range <- decode.optional_field(
    "referenceRange",
    None,
    decode.optional(substanceamount_referencerange_decoder()),
  )
  use amount_text <- decode.optional_field(
    "amountText",
    None,
    decode.optional(decode.string),
  )
  use amount_type <- decode.optional_field(
    "amountType",
    None,
    decode.optional(codeableconcept_decoder()),
  )
  use amount <- decode.then(none_if_omitted(substanceamount_amount_decoder()))
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
  decode.success(Substanceamount(
    reference_range:,
    amount_text:,
    amount_type:,
    amount:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4us/StructureDefinition/Timing#resource](http://hl7.org/fhir/r4us/StructureDefinition/Timing#resource)
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

///[http://hl7.org/fhir/r4us/StructureDefinition/Timing#resource](http://hl7.org/fhir/r4us/StructureDefinition/Timing#resource)
pub type TimingRepeat {
  TimingRepeat(
    id: Option(String),
    extension: List(Extension),
    bounds: Option(TimingRepeatBounds),
    count: Option(Int),
    count_max: Option(Int),
    duration: Option(Float),
    duration_max: Option(Float),
    duration_unit: Option(valuesets.Unitsoftime),
    frequency: Option(Int),
    frequency_max: Option(Int),
    period: Option(Float),
    period_max: Option(Float),
    period_unit: Option(valuesets.Unitsoftime),
    day_of_week: List(valuesets.Daysofweek),
    time_of_day: List(Time),
    when: List(valuesets.Eventtiming),
    offset: Option(Int),
  )
}

///[http://hl7.org/fhir/r4us/StructureDefinition/Timing#resource](http://hl7.org/fhir/r4us/StructureDefinition/Timing#resource)
pub type TimingRepeatBounds {
  TimingRepeatBoundsDuration(bounds: Duration)
  TimingRepeatBoundsRange(bounds: Range)
  TimingRepeatBoundsPeriod(bounds: Period)
}

pub fn timing_repeat_bounds_to_json(elt: TimingRepeatBounds) -> Json {
  case elt {
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
  let TimingRepeat(
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
  ) = timing_repeat
  let fields = []
  let fields = case offset {
    Some(v) -> [#("offset", json.int(v)), ..fields]
    None -> fields
  }
  let fields = case when {
    [] -> fields
    _ -> [#("when", json.array(when, valuesets.eventtiming_to_json)), ..fields]
  }
  let fields = case time_of_day {
    [] -> fields
    _ -> [#("timeOfDay", json.array(time_of_day, pt.time_to_json)), ..fields]
  }
  let fields = case day_of_week {
    [] -> fields
    _ -> [
      #("dayOfWeek", json.array(day_of_week, valuesets.daysofweek_to_json)),
      ..fields
    ]
  }
  let fields = case period_unit {
    Some(v) -> [#("periodUnit", valuesets.unitsoftime_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case period_max {
    Some(v) -> [#("periodMax", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case period {
    Some(v) -> [#("period", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case frequency_max {
    Some(v) -> [#("frequencyMax", json.int(v)), ..fields]
    None -> fields
  }
  let fields = case frequency {
    Some(v) -> [#("frequency", json.int(v)), ..fields]
    None -> fields
  }
  let fields = case duration_unit {
    Some(v) -> [#("durationUnit", valuesets.unitsoftime_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case duration_max {
    Some(v) -> [#("durationMax", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case duration {
    Some(v) -> [#("duration", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case count_max {
    Some(v) -> [#("countMax", json.int(v)), ..fields]
    None -> fields
  }
  let fields = case count {
    Some(v) -> [#("count", json.int(v)), ..fields]
    None -> fields
  }
  let fields = case bounds {
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
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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
    decode.list(valuesets.eventtiming_decoder()),
  )
  use time_of_day <- decode.optional_field(
    "timeOfDay",
    [],
    decode.list(pt.time_decoder()),
  )
  use day_of_week <- decode.optional_field(
    "dayOfWeek",
    [],
    decode.list(valuesets.daysofweek_decoder()),
  )
  use period_unit <- decode.optional_field(
    "periodUnit",
    None,
    decode.optional(valuesets.unitsoftime_decoder()),
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
    decode.optional(valuesets.unitsoftime_decoder()),
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
  let Timing(code:, repeat:, event:, modifier_extension:, extension:, id:) =
    timing
  let fields = []
  let fields = case code {
    Some(v) -> [#("code", codeableconcept_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case repeat {
    Some(v) -> [#("repeat", timing_repeat_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case event {
    [] -> fields
    _ -> [#("event", json.array(event, pt.datetime_to_json)), ..fields]
  }
  let fields = case modifier_extension {
    [] -> fields
    _ -> [
      #("modifierExtension", json.array(modifier_extension, extension_to_json)),
      ..fields
    ]
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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

///[http://hl7.org/fhir/r4us/StructureDefinition/TriggerDefinition#resource](http://hl7.org/fhir/r4us/StructureDefinition/TriggerDefinition#resource)
pub type Triggerdefinition {
  Triggerdefinition(
    id: Option(String),
    extension: List(Extension),
    type_: valuesets.Triggertype,
    name: Option(String),
    timing: Option(TriggerdefinitionTiming),
    data: List(Datarequirement),
    condition: Option(Expression),
  )
}

///[http://hl7.org/fhir/r4us/StructureDefinition/TriggerDefinition#resource](http://hl7.org/fhir/r4us/StructureDefinition/TriggerDefinition#resource)
pub type TriggerdefinitionTiming {
  TriggerdefinitionTimingTiming(timing: Timing)
  TriggerdefinitionTimingReference(timing: Reference)
  TriggerdefinitionTimingDate(timing: Date)
  TriggerdefinitionTimingDatetime(timing: DateTime)
}

pub fn triggerdefinition_timing_to_json(elt: TriggerdefinitionTiming) -> Json {
  case elt {
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
  type_ type_: valuesets.Triggertype,
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
  let Triggerdefinition(
    condition:,
    data:,
    timing:,
    name:,
    type_:,
    extension:,
    id:,
  ) = triggerdefinition
  let fields = [
    #("type", valuesets.triggertype_to_json(type_)),
  ]
  let fields = case condition {
    Some(v) -> [#("condition", expression_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case data {
    [] -> fields
    _ -> [#("data", json.array(data, datarequirement_to_json)), ..fields]
  }
  let fields = case timing {
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
  let fields = case name {
    Some(v) -> [#("name", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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
  use type_ <- decode.field("type", valuesets.triggertype_decoder())
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

///[http://hl7.org/fhir/r4us/StructureDefinition/UsageContext#resource](http://hl7.org/fhir/r4us/StructureDefinition/UsageContext#resource)
pub type Usagecontext {
  Usagecontext(
    id: Option(String),
    extension: List(Extension),
    code: Coding,
    value: UsagecontextValue,
  )
}

///[http://hl7.org/fhir/r4us/StructureDefinition/UsageContext#resource](http://hl7.org/fhir/r4us/StructureDefinition/UsageContext#resource)
pub type UsagecontextValue {
  UsagecontextValueCodeableconcept(value: Codeableconcept)
  UsagecontextValueQuantity(value: Quantity)
  UsagecontextValueRange(value: Range)
  UsagecontextValueReference(value: Reference)
}

pub fn usagecontext_value_to_json(elt: UsagecontextValue) -> Json {
  case elt {
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
  let Usagecontext(value:, code:, extension:, id:) = usagecontext
  let fields = [
    #(
      "value"
        <> case value {
        UsagecontextValueCodeableconcept(_) -> "CodeableConcept"
        UsagecontextValueQuantity(_) -> "Quantity"
        UsagecontextValueRange(_) -> "Range"
        UsagecontextValueReference(_) -> "Reference"
      },
      usagecontext_value_to_json(value),
    ),
    #("code", coding_to_json(code)),
  ]
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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

///[http://hl7.org/fhir/r4us/StructureDefinition/MoneyQuantity#resource](http://hl7.org/fhir/r4us/StructureDefinition/MoneyQuantity#resource)
pub type Moneyquantity {
  Moneyquantity(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(valuesets.Quantitycomparator),
    unit: Option(String),
    system: Option(String),
    code: Option(String),
  )
}

pub fn moneyquantity_new() -> Moneyquantity {
  Moneyquantity(
    code: None,
    system: None,
    unit: None,
    comparator: None,
    value: None,
    extension: [],
    id: None,
  )
}

pub fn moneyquantity_to_json(moneyquantity: Moneyquantity) -> Json {
  let Moneyquantity(code:, system:, unit:, comparator:, value:, extension:, id:) =
    moneyquantity
  let fields = []
  let fields = case code {
    Some(v) -> [#("code", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case system {
    Some(v) -> [#("system", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case unit {
    Some(v) -> [#("unit", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case comparator {
    Some(v) -> [
      #("comparator", valuesets.quantitycomparator_to_json(v)),
      ..fields
    ]
    None -> fields
  }
  let fields = case value {
    Some(v) -> [#("value", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn moneyquantity_decoder() -> Decoder(Moneyquantity) {
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
    decode.optional(valuesets.quantitycomparator_decoder()),
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
  decode.success(Moneyquantity(
    code:,
    system:,
    unit:,
    comparator:,
    value:,
    extension:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4us/StructureDefinition/SimpleQuantity#resource](http://hl7.org/fhir/r4us/StructureDefinition/SimpleQuantity#resource)
pub type Simplequantity {
  Simplequantity(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    unit: Option(String),
    system: Option(String),
    code: Option(String),
  )
}

pub fn simplequantity_new() -> Simplequantity {
  Simplequantity(
    code: None,
    system: None,
    unit: None,
    value: None,
    extension: [],
    id: None,
  )
}

pub fn simplequantity_to_json(simplequantity: Simplequantity) -> Json {
  let Simplequantity(code:, system:, unit:, value:, extension:, id:) =
    simplequantity
  let fields = []
  let fields = case code {
    Some(v) -> [#("code", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case system {
    Some(v) -> [#("system", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case unit {
    Some(v) -> [#("unit", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case value {
    Some(v) -> [#("value", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn simplequantity_decoder() -> Decoder(Simplequantity) {
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
  decode.success(Simplequantity(code:, system:, unit:, value:, extension:, id:))
}

//std lib decode.optional supports myfield: null but what if myfield is omitted from json entirely?
pub fn none_if_omitted(d: decode.Decoder(a)) -> decode.Decoder(Option(a)) {
  decode.one_of(d |> decode.map(Some), [decode.success(None)])
}

//std lib decode.float will NOT decode numbers without decimal point eg 4, only 4.0
pub fn decode_number() {
  decode.one_of(decode.float, [decode.map(decode.int, int.to_float)])
}

pub fn list1_to_json(l: List1(a), tj: fn(a) -> Json) {
  let List1(first:, rest:) = l
  json.array([first, ..rest], tj)
}

pub fn list2_to_json(l: List2(a), tj: fn(a) -> Json) {
  let List2(first:, second:, rest:) = l
  json.array([first, second, ..rest], tj)
}

pub fn list3_to_json(l: List3(a), tj: fn(a) -> Json) {
  let List3(first:, second:, third:, rest:) = l
  json.array([first, second, third, ..rest], tj)
}

pub fn list1_decoder(
  name: String,
  inner: decode.Decoder(a),
  next: fn(List1(a)) -> decode.Decoder(b),
) -> decode.Decoder(b) {
  use lst <- decode.field(name, decode.list(inner))
  case lst {
    [first, ..rest] -> next(List1(first:, rest:))
    _ -> {
      use fail_decode_to_satisfy_gleam_type <- decode.field(name, inner)
      next(List1(first: fail_decode_to_satisfy_gleam_type, rest: []))
    }
  }
}

pub fn list2_decoder(
  name: String,
  inner: decode.Decoder(a),
  next: fn(List2(a)) -> decode.Decoder(b),
) -> decode.Decoder(b) {
  use lst <- decode.field(name, decode.list(inner))
  case lst {
    [first, second, ..rest] -> next(List2(first:, second:, rest:))
    _ -> {
      use fail_decode_to_satisfy_gleam_type <- decode.field(name, inner)
      next(
        List2(
          first: fail_decode_to_satisfy_gleam_type,
          second: fail_decode_to_satisfy_gleam_type,
          rest: [],
        ),
      )
    }
  }
}

pub fn list3_decoder(
  name: String,
  inner: decode.Decoder(a),
  next: fn(List3(a)) -> decode.Decoder(b),
) -> decode.Decoder(b) {
  use lst <- decode.field(name, decode.list(inner))
  case lst {
    [first, second, third, ..rest] ->
      next(List3(first:, second:, third:, rest:))
    _ -> {
      use fail_decode_to_satisfy_gleam_type <- decode.field(name, inner)
      next(
        List3(
          first: fail_decode_to_satisfy_gleam_type,
          second: fail_decode_to_satisfy_gleam_type,
          third: fail_decode_to_satisfy_gleam_type,
          rest: [],
        ),
      )
    }
  }
}

pub type Primitive(a) {
  Primitive(id: Option(String), ext: List(Extension), value: Option(a))
}

pub type PrimitiveExtPart {
  PrimitiveExtPart(id: Option(String), ext: List(Extension))
}

pub fn primitive_ext_part_to_json(p: Primitive(_)) {
  let Primitive(id, ext, _) = p
  let fields = []
  let fields = case id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case ext {
    [] -> fields
    _ -> [#("extension", json.array(ext, extension_to_json)), ..fields]
  }
  json.object(fields)
}

pub fn primitive_to_json(
  old_fields: List(#(String, Json)),
  primitive: Primitive(a),
  field_to_json: fn(a) -> Json,
  name: String,
) {
  let old_fields = case primitive.id, primitive.ext {
    None, [] -> old_fields
    _, _ -> [
      #("_" <> name, primitive_ext_part_to_json(primitive)),
      ..old_fields
    ]
  }
  case primitive.value {
    None -> old_fields
    Some(v) -> [#(name, field_to_json(v)), ..old_fields]
  }
}

pub fn primitives_to_json(
  old_fields: List(#(String, Json)),
  field: List(Primitive(a)),
  field_to_json: fn(a) -> Json,
  name: String,
) {
  let vals =
    list.map(field, fn(primitive) {
      json.nullable(primitive.value, field_to_json)
    })
  let exts =
    list.map(field, fn(primitive) {
      case primitive.id, primitive.ext {
        None, [] -> json.null()
        _, _ -> primitive_ext_part_to_json(primitive)
      }
    })
  let old_fields = case list.any(vals, fn(j) { j != json.null() }) {
    False -> old_fields
    True -> [#(name, json.preprocessed_array(vals)), ..old_fields]
  }
  case list.any(exts, fn(j) { j != json.null() }) {
    False -> old_fields
    True -> [#("_" <> name, json.preprocessed_array(exts)), ..old_fields]
  }
}

pub fn primitive_ext_part_decoder() {
  use ext <- decode.optional_field(
    "extension",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(PrimitiveExtPart(ext:, id:))
}

pub fn primitive_decoder(
  name: String,
  thing_decoder: Decoder(a),
  next: fn(Primitive(a)) -> Decoder(b),
) -> Decoder(b) {
  use value <- decode.optional_field(name, None, decode.optional(thing_decoder))
  use pwe <- decode.optional_field(
    "_" <> name,
    None,
    decode.optional(primitive_ext_part_decoder()),
  )
  let #(id, ext) = case pwe {
    None -> #(None, [])
    Some(PrimitiveExtPart(id, ext)) -> #(id, ext)
  }
  let together = Primitive(id:, ext:, value:)
  next(together)
}

pub fn primitives_decoder(
  name: String,
  thing_decoder: Decoder(a),
  next: fn(List(Primitive(a))) -> Decoder(b),
) -> Decoder(b) {
  use values <- decode.optional_field(
    name,
    [],
    decode.list(decode.optional(thing_decoder)),
  )
  use pwes <- decode.optional_field(
    "_" <> name,
    [],
    decode.list(decode.optional(primitive_ext_part_decoder())),
  )
  let together =
    map2_fillnone(pwes, values, fn(pwe, value) {
      let #(id, ext) = case pwe {
        None -> #(None, [])
        Some(PrimitiveExtPart(id, ext)) -> #(id, ext)
      }
      Primitive(id:, ext:, value:)
    })
  next(together)
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
