////[https://hl7.org/fhir/r4](https://hl7.org/fhir/r4) resources

import fhir/r4_gen/complex_type.{
  type List1, decode_number, list1_decoder, list1_to_json, none_if_omitted,
} as ct
import fhir/r4_gen/primitive_type.{
  type Date, type DateTime, type Instant, type Time,
} as pt
import fhir/r4_gen/valueset
import gleam/bool
import gleam/dynamic/decode.{type Decoder}
import gleam/json.{type Json}
import gleam/list
import gleam/option.{type Option, None, Some}

///[http://hl7.org/fhir/r4/StructureDefinition/Bundle#resource](http://hl7.org/fhir/r4/StructureDefinition/Bundle#resource)
pub type Bundle {
  Bundle(
    id: Option(String),
    meta: Option(ct.Meta),
    implicit_rules: Option(String),
    language: Option(String),
    identifier: Option(ct.Identifier),
    type_: valueset.BundleType,
    timestamp: Option(Instant),
    total: Option(Int),
    link: List(BundleLink),
    entry: List(BundleEntry),
    signature: Option(ct.Signature),
  )
}

pub fn bundle_new(type_ type_: valueset.BundleType) -> Bundle {
  Bundle(
    signature: None,
    entry: [],
    link: [],
    total: None,
    timestamp: None,
    type_:,
    identifier: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/Bundle#resource](http://hl7.org/fhir/r4/StructureDefinition/Bundle#resource)
pub type BundleLink {
  BundleLink(
    id: Option(String),
    extension: List(ct.Extension),
    modifier_extension: List(ct.Extension),
    relation: String,
    url: String,
  )
}

pub fn bundle_link_new(
  url url: String,
  relation relation: String,
) -> BundleLink {
  BundleLink(url:, relation:, modifier_extension: [], extension: [], id: None)
}

///[http://hl7.org/fhir/r4/StructureDefinition/Bundle#resource](http://hl7.org/fhir/r4/StructureDefinition/Bundle#resource)
pub type BundleEntry {
  BundleEntry(
    id: Option(String),
    extension: List(ct.Extension),
    modifier_extension: List(ct.Extension),
    link: List(BundleLink),
    full_url: Option(String),
    resource: Option(Resource),
    search: Option(BundleEntrySearch),
    request: Option(BundleEntryRequest),
    response: Option(BundleEntryResponse),
  )
}

pub fn bundle_entry_new() -> BundleEntry {
  BundleEntry(
    response: None,
    request: None,
    search: None,
    resource: None,
    full_url: None,
    link: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/Bundle#resource](http://hl7.org/fhir/r4/StructureDefinition/Bundle#resource)
pub type BundleEntrySearch {
  BundleEntrySearch(
    id: Option(String),
    extension: List(ct.Extension),
    modifier_extension: List(ct.Extension),
    mode: Option(valueset.SearchEntryMode),
    score: Option(Float),
  )
}

pub fn bundle_entry_search_new() -> BundleEntrySearch {
  BundleEntrySearch(
    score: None,
    mode: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/Bundle#resource](http://hl7.org/fhir/r4/StructureDefinition/Bundle#resource)
pub type BundleEntryRequest {
  BundleEntryRequest(
    id: Option(String),
    extension: List(ct.Extension),
    modifier_extension: List(ct.Extension),
    method: valueset.HttpVerb,
    url: String,
    if_none_match: Option(String),
    if_modified_since: Option(Instant),
    if_match: Option(String),
    if_none_exist: Option(String),
  )
}

pub fn bundle_entry_request_new(
  url url: String,
  method method: valueset.HttpVerb,
) -> BundleEntryRequest {
  BundleEntryRequest(
    if_none_exist: None,
    if_match: None,
    if_modified_since: None,
    if_none_match: None,
    url:,
    method:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/Bundle#resource](http://hl7.org/fhir/r4/StructureDefinition/Bundle#resource)
pub type BundleEntryResponse {
  BundleEntryResponse(
    id: Option(String),
    extension: List(ct.Extension),
    modifier_extension: List(ct.Extension),
    status: String,
    location: Option(String),
    etag: Option(String),
    last_modified: Option(Instant),
    outcome: Option(Resource),
  )
}

pub fn bundle_entry_response_new(status status: String) -> BundleEntryResponse {
  BundleEntryResponse(
    outcome: None,
    last_modified: None,
    etag: None,
    location: None,
    status:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

pub fn bundle_entry_response_to_json(
  bundle_entry_response: BundleEntryResponse,
) -> Json {
  let fields = [
    #("status", json.string(bundle_entry_response.status)),
  ]
  let fields = case bundle_entry_response.outcome {
    Some(v) -> [#("outcome", to_json(v)), ..fields]
    None -> fields
  }
  let fields = case bundle_entry_response.last_modified {
    Some(v) -> [#("lastModified", pt.instant_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case bundle_entry_response.etag {
    Some(v) -> [#("etag", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case bundle_entry_response.location {
    Some(v) -> [#("location", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case bundle_entry_response.modifier_extension {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(
          bundle_entry_response.modifier_extension,
          ct.extension_to_json,
        ),
      ),
      ..fields
    ]
  }
  let fields = case bundle_entry_response.extension {
    [] -> fields
    _ -> [
      #(
        "extension",
        json.array(bundle_entry_response.extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case bundle_entry_response.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn bundle_entry_response_decoder() -> Decoder(BundleEntryResponse) {
  use <- decode.recursive
  use outcome <- decode.optional_field(
    "outcome",
    None,
    decode.optional(resource_decoder()),
  )
  use last_modified <- decode.optional_field(
    "lastModified",
    None,
    decode.optional(pt.instant_decoder()),
  )
  use etag <- decode.optional_field(
    "etag",
    None,
    decode.optional(decode.string),
  )
  use location <- decode.optional_field(
    "location",
    None,
    decode.optional(decode.string),
  )
  use status <- decode.field("status", decode.string)
  use modifier_extension <- decode.optional_field(
    "modifierExtension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(BundleEntryResponse(
    outcome:,
    last_modified:,
    etag:,
    location:,
    status:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

pub fn bundle_entry_request_to_json(
  bundle_entry_request: BundleEntryRequest,
) -> Json {
  let fields = [
    #("url", json.string(bundle_entry_request.url)),
    #("method", valueset.http_verb_to_json(bundle_entry_request.method)),
  ]
  let fields = case bundle_entry_request.if_none_exist {
    Some(v) -> [#("ifNoneExist", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case bundle_entry_request.if_match {
    Some(v) -> [#("ifMatch", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case bundle_entry_request.if_modified_since {
    Some(v) -> [#("ifModifiedSince", pt.instant_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case bundle_entry_request.if_none_match {
    Some(v) -> [#("ifNoneMatch", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case bundle_entry_request.modifier_extension {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(
          bundle_entry_request.modifier_extension,
          ct.extension_to_json,
        ),
      ),
      ..fields
    ]
  }
  let fields = case bundle_entry_request.extension {
    [] -> fields
    _ -> [
      #(
        "extension",
        json.array(bundle_entry_request.extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case bundle_entry_request.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn bundle_entry_request_decoder() -> Decoder(BundleEntryRequest) {
  use <- decode.recursive
  use if_none_exist <- decode.optional_field(
    "ifNoneExist",
    None,
    decode.optional(decode.string),
  )
  use if_match <- decode.optional_field(
    "ifMatch",
    None,
    decode.optional(decode.string),
  )
  use if_modified_since <- decode.optional_field(
    "ifModifiedSince",
    None,
    decode.optional(pt.instant_decoder()),
  )
  use if_none_match <- decode.optional_field(
    "ifNoneMatch",
    None,
    decode.optional(decode.string),
  )
  use url <- decode.field("url", decode.string)
  use method <- decode.field("method", valueset.http_verb_decoder())
  use modifier_extension <- decode.optional_field(
    "modifierExtension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(BundleEntryRequest(
    if_none_exist:,
    if_match:,
    if_modified_since:,
    if_none_match:,
    url:,
    method:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

pub fn bundle_entry_search_to_json(
  bundle_entry_search: BundleEntrySearch,
) -> Json {
  let fields = []
  let fields = case bundle_entry_search.score {
    Some(v) -> [#("score", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case bundle_entry_search.mode {
    Some(v) -> [#("mode", valueset.search_entry_mode_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case bundle_entry_search.modifier_extension {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(bundle_entry_search.modifier_extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case bundle_entry_search.extension {
    [] -> fields
    _ -> [
      #(
        "extension",
        json.array(bundle_entry_search.extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case bundle_entry_search.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn bundle_entry_search_decoder() -> Decoder(BundleEntrySearch) {
  use <- decode.recursive
  use score <- decode.optional_field(
    "score",
    None,
    decode.optional(decode_number()),
  )
  use mode <- decode.optional_field(
    "mode",
    None,
    decode.optional(valueset.search_entry_mode_decoder()),
  )
  use modifier_extension <- decode.optional_field(
    "modifierExtension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(BundleEntrySearch(
    score:,
    mode:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

pub fn bundle_entry_to_json(bundle_entry: BundleEntry) -> Json {
  let fields = []
  let fields = case bundle_entry.response {
    Some(v) -> [#("response", bundle_entry_response_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case bundle_entry.request {
    Some(v) -> [#("request", bundle_entry_request_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case bundle_entry.search {
    Some(v) -> [#("search", bundle_entry_search_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case bundle_entry.resource {
    Some(v) -> [#("resource", to_json(v)), ..fields]
    None -> fields
  }
  let fields = case bundle_entry.full_url {
    Some(v) -> [#("fullUrl", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case bundle_entry.link {
    [] -> fields
    _ -> [
      #("link", json.array(bundle_entry.link, bundle_link_to_json)),
      ..fields
    ]
  }
  let fields = case bundle_entry.modifier_extension {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(bundle_entry.modifier_extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case bundle_entry.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(bundle_entry.extension, ct.extension_to_json)),
      ..fields
    ]
  }
  let fields = case bundle_entry.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn bundle_entry_decoder() -> Decoder(BundleEntry) {
  use <- decode.recursive
  use response <- decode.optional_field(
    "response",
    None,
    decode.optional(bundle_entry_response_decoder()),
  )
  use request <- decode.optional_field(
    "request",
    None,
    decode.optional(bundle_entry_request_decoder()),
  )
  use search <- decode.optional_field(
    "search",
    None,
    decode.optional(bundle_entry_search_decoder()),
  )
  use resource <- decode.optional_field(
    "resource",
    None,
    decode.optional(resource_decoder()),
  )
  use full_url <- decode.optional_field(
    "fullUrl",
    None,
    decode.optional(decode.string),
  )
  use link <- decode.optional_field(
    "link",
    [],
    decode.list(bundle_link_decoder()),
  )
  use modifier_extension <- decode.optional_field(
    "modifierExtension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(BundleEntry(
    response:,
    request:,
    search:,
    resource:,
    full_url:,
    link:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

pub type BundleEntryForgiving {
  BundleEntryForgiving(
    id: Option(String),
    extension: List(ct.Extension),
    modifier_extension: List(ct.Extension),
    link: List(BundleLink),
    full_url: Option(String),
    resource: Option(Result(Resource, List(decode.DecodeError))),
    search: Option(BundleEntrySearch),
    request: Option(BundleEntryRequest),
    response: Option(BundleEntryResponse),
  )
}

pub fn bundle_entry_decoder_forgiving() -> Decoder(BundleEntryForgiving) {
  use <- decode.recursive
  use response <- decode.optional_field(
    "response",
    None,
    decode.optional(bundle_entry_response_decoder()),
  )
  use request <- decode.optional_field(
    "request",
    None,
    decode.optional(bundle_entry_request_decoder()),
  )
  use search <- decode.optional_field(
    "search",
    None,
    decode.optional(bundle_entry_search_decoder()),
  )
  use resource <- decode.optional_field(
    "resource",
    None,
    decode.optional(
      decode.one_of(resource_decoder() |> decode.map(Ok), [
        decode.dynamic
        |> decode.map(fn(resource_json) {
          decode.run(resource_json, resource_decoder())
        }),
      ]),
    ),
  )
  use full_url <- decode.optional_field(
    "fullUrl",
    None,
    decode.optional(decode.string),
  )
  use link <- decode.optional_field(
    "link",
    [],
    decode.list(bundle_link_decoder()),
  )
  use modifier_extension <- decode.optional_field(
    "modifierExtension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(BundleEntryForgiving(
    response:,
    request:,
    search:,
    resource:,
    full_url:,
    link:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

pub fn bundle_link_to_json(bundle_link: BundleLink) -> Json {
  let fields = [
    #("url", json.string(bundle_link.url)),
    #("relation", json.string(bundle_link.relation)),
  ]
  let fields = case bundle_link.modifier_extension {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(bundle_link.modifier_extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case bundle_link.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(bundle_link.extension, ct.extension_to_json)),
      ..fields
    ]
  }
  let fields = case bundle_link.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn bundle_link_decoder() -> Decoder(BundleLink) {
  use <- decode.recursive
  use url <- decode.field("url", decode.string)
  use relation <- decode.field("relation", decode.string)
  use modifier_extension <- decode.optional_field(
    "modifierExtension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(BundleLink(
    url:,
    relation:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

pub fn bundle_to_json(bundle: Bundle) -> Json {
  let fields = [
    #("type", valueset.bundle_type_to_json(bundle.type_)),
  ]
  let fields = case bundle.signature {
    Some(v) -> [#("signature", ct.signature_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case bundle.entry {
    [] -> fields
    _ -> [#("entry", json.array(bundle.entry, bundle_entry_to_json)), ..fields]
  }
  let fields = case bundle.link {
    [] -> fields
    _ -> [#("link", json.array(bundle.link, bundle_link_to_json)), ..fields]
  }
  let fields = case bundle.total {
    Some(v) -> [#("total", json.int(v)), ..fields]
    None -> fields
  }
  let fields = case bundle.timestamp {
    Some(v) -> [#("timestamp", pt.instant_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case bundle.identifier {
    Some(v) -> [#("identifier", ct.identifier_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case bundle.language {
    Some(v) -> [#("language", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case bundle.implicit_rules {
    Some(v) -> [#("implicitRules", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case bundle.meta {
    Some(v) -> [#("meta", ct.meta_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case bundle.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  let fields = [#("resourceType", json.string("Bundle")), ..fields]
  json.object(fields)
}

pub fn bundle_decoder() -> Decoder(Bundle) {
  use <- decode.recursive
  use signature <- decode.optional_field(
    "signature",
    None,
    decode.optional(ct.signature_decoder()),
  )
  use entry <- decode.optional_field(
    "entry",
    [],
    decode.list(bundle_entry_decoder()),
  )
  use link <- decode.optional_field(
    "link",
    [],
    decode.list(bundle_link_decoder()),
  )
  use total <- decode.optional_field("total", None, decode.optional(decode.int))
  use timestamp <- decode.optional_field(
    "timestamp",
    None,
    decode.optional(pt.instant_decoder()),
  )
  use type_ <- decode.field("type", valueset.bundle_type_decoder())
  use identifier <- decode.optional_field(
    "identifier",
    None,
    decode.optional(ct.identifier_decoder()),
  )
  use language <- decode.optional_field(
    "language",
    None,
    decode.optional(decode.string),
  )
  use implicit_rules <- decode.optional_field(
    "implicitRules",
    None,
    decode.optional(decode.string),
  )
  use meta <- decode.optional_field(
    "meta",
    None,
    decode.optional(ct.meta_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))

  use resource_type <- decode.field("resourceType", decode.string)
  use <- bool.guard(
    resource_type != "Bundle",
    decode.failure(bundle_new(type_:), "resourceType"),
  )
  decode.success(Bundle(
    signature:,
    entry:,
    link:,
    total:,
    timestamp:,
    type_:,
    identifier:,
    language:,
    implicit_rules:,
    meta:,
    id:,
  ))
}

pub type BundleForgiving {
  BundleForgiving(
    id: Option(String),
    meta: Option(ct.Meta),
    implicit_rules: Option(String),
    language: Option(String),
    identifier: Option(ct.Identifier),
    type_: valueset.BundleType,
    timestamp: Option(Instant),
    total: Option(Int),
    link: List(BundleLink),
    entry: List(BundleEntryForgiving),
    signature: Option(ct.Signature),
  )
}

pub fn bundle_decoder_forgiving() -> Decoder(BundleForgiving) {
  use <- decode.recursive
  use signature <- decode.optional_field(
    "signature",
    None,
    decode.optional(ct.signature_decoder()),
  )
  use entry <- decode.optional_field(
    "entry",
    [],
    decode.list(bundle_entry_decoder_forgiving()),
  )
  use link <- decode.optional_field(
    "link",
    [],
    decode.list(bundle_link_decoder()),
  )
  use total <- decode.optional_field("total", None, decode.optional(decode.int))
  use timestamp <- decode.optional_field(
    "timestamp",
    None,
    decode.optional(pt.instant_decoder()),
  )
  use type_ <- decode.field("type", valueset.bundle_type_decoder())
  use identifier <- decode.optional_field(
    "identifier",
    None,
    decode.optional(ct.identifier_decoder()),
  )
  use language <- decode.optional_field(
    "language",
    None,
    decode.optional(decode.string),
  )
  use implicit_rules <- decode.optional_field(
    "implicitRules",
    None,
    decode.optional(decode.string),
  )
  use meta <- decode.optional_field(
    "meta",
    None,
    decode.optional(ct.meta_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))

  use resource_type <- decode.field("resourceType", decode.string)
  use <- bool.guard(
    resource_type != "Bundle",
    decode.failure(
      BundleForgiving(
        signature:,
        entry:,
        link:,
        total:,
        timestamp:,
        type_:,
        identifier:,
        language:,
        implicit_rules:,
        meta:,
        id:,
      ),
      "resourceType",
    ),
  )
  decode.success(BundleForgiving(
    signature:,
    entry:,
    link:,
    total:,
    timestamp:,
    type_:,
    identifier:,
    language:,
    implicit_rules:,
    meta:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4/StructureDefinition/CodeSystem#resource](http://hl7.org/fhir/r4/StructureDefinition/CodeSystem#resource)
pub type Codesystem {
  Codesystem(
    id: Option(String),
    meta: Option(ct.Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(ct.Narrative),
    contained: List(Resource),
    extension: List(ct.Extension),
    modifier_extension: List(ct.Extension),
    url: Option(String),
    identifier: List(ct.Identifier),
    version: Option(String),
    name: Option(String),
    title: Option(String),
    status: valueset.PublicationStatus,
    experimental: Option(Bool),
    date: Option(DateTime),
    publisher: Option(String),
    contact: List(ct.Contactdetail),
    description: Option(String),
    use_context: List(ct.Usagecontext),
    jurisdiction: List(ct.Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    case_sensitive: Option(Bool),
    value_set: Option(String),
    hierarchy_meaning: Option(valueset.CodesystemHierarchyMeaning),
    compositional: Option(Bool),
    version_needed: Option(Bool),
    content: valueset.CodesystemContentMode,
    supplements: Option(String),
    count: Option(Int),
    filter: List(CodesystemFilter),
    property: List(CodesystemProperty),
    concept: List(CodesystemConcept),
  )
}

pub fn codesystem_new(
  content content: valueset.CodesystemContentMode,
  status status: valueset.PublicationStatus,
) -> Codesystem {
  Codesystem(
    concept: [],
    property: [],
    filter: [],
    count: None,
    supplements: None,
    content:,
    version_needed: None,
    compositional: None,
    hierarchy_meaning: None,
    value_set: None,
    case_sensitive: None,
    copyright: None,
    purpose: None,
    jurisdiction: [],
    use_context: [],
    description: None,
    contact: [],
    publisher: None,
    date: None,
    experimental: None,
    status:,
    title: None,
    name: None,
    version: None,
    identifier: [],
    url: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/CodeSystem#resource](http://hl7.org/fhir/r4/StructureDefinition/CodeSystem#resource)
pub type CodesystemFilter {
  CodesystemFilter(
    id: Option(String),
    extension: List(ct.Extension),
    modifier_extension: List(ct.Extension),
    code: String,
    description: Option(String),
    operator: List1(valueset.FilterOperator),
    value: String,
  )
}

pub fn codesystem_filter_new(
  value value: String,
  operator operator: List1(valueset.FilterOperator),
  code code: String,
) -> CodesystemFilter {
  CodesystemFilter(
    value:,
    operator:,
    description: None,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/CodeSystem#resource](http://hl7.org/fhir/r4/StructureDefinition/CodeSystem#resource)
pub type CodesystemProperty {
  CodesystemProperty(
    id: Option(String),
    extension: List(ct.Extension),
    modifier_extension: List(ct.Extension),
    code: String,
    uri: Option(String),
    description: Option(String),
    type_: valueset.ConceptPropertyType,
  )
}

pub fn codesystem_property_new(
  type_ type_: valueset.ConceptPropertyType,
  code code: String,
) -> CodesystemProperty {
  CodesystemProperty(
    type_:,
    description: None,
    uri: None,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/CodeSystem#resource](http://hl7.org/fhir/r4/StructureDefinition/CodeSystem#resource)
pub type CodesystemConcept {
  CodesystemConcept(
    id: Option(String),
    extension: List(ct.Extension),
    modifier_extension: List(ct.Extension),
    code: String,
    display: Option(String),
    definition: Option(String),
    designation: List(CodesystemConceptDesignation),
    property: List(CodesystemConceptProperty),
    concept: List(CodesystemConcept),
  )
}

pub fn codesystem_concept_new(code code: String) -> CodesystemConcept {
  CodesystemConcept(
    concept: [],
    property: [],
    designation: [],
    definition: None,
    display: None,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/CodeSystem#resource](http://hl7.org/fhir/r4/StructureDefinition/CodeSystem#resource)
pub type CodesystemConceptDesignation {
  CodesystemConceptDesignation(
    id: Option(String),
    extension: List(ct.Extension),
    modifier_extension: List(ct.Extension),
    language: Option(String),
    use_: Option(ct.Coding),
    value: String,
  )
}

pub fn codesystem_concept_designation_new(
  value value: String,
) -> CodesystemConceptDesignation {
  CodesystemConceptDesignation(
    value:,
    use_: None,
    language: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/CodeSystem#resource](http://hl7.org/fhir/r4/StructureDefinition/CodeSystem#resource)
pub type CodesystemConceptProperty {
  CodesystemConceptProperty(
    id: Option(String),
    extension: List(ct.Extension),
    modifier_extension: List(ct.Extension),
    code: String,
    value: CodesystemConceptPropertyValue,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/CodeSystem#resource](http://hl7.org/fhir/r4/StructureDefinition/CodeSystem#resource)
pub type CodesystemConceptPropertyValue {
  CodesystemConceptPropertyValueCode(value: String)
  CodesystemConceptPropertyValueCoding(value: ct.Coding)
  CodesystemConceptPropertyValueString(value: String)
  CodesystemConceptPropertyValueInteger(value: Int)
  CodesystemConceptPropertyValueBoolean(value: Bool)
  CodesystemConceptPropertyValueDatetime(value: DateTime)
  CodesystemConceptPropertyValueDecimal(value: Float)
}

pub fn codesystem_concept_property_value_to_json(
  element: CodesystemConceptPropertyValue,
) -> Json {
  case element {
    CodesystemConceptPropertyValueCode(v) -> json.string(v)
    CodesystemConceptPropertyValueCoding(v) -> ct.coding_to_json(v)
    CodesystemConceptPropertyValueString(v) -> json.string(v)
    CodesystemConceptPropertyValueInteger(v) -> json.int(v)
    CodesystemConceptPropertyValueBoolean(v) -> json.bool(v)
    CodesystemConceptPropertyValueDatetime(v) -> pt.datetime_to_json(v)
    CodesystemConceptPropertyValueDecimal(v) -> json.float(v)
  }
}

pub fn codesystem_concept_property_value_decoder() -> Decoder(
  CodesystemConceptPropertyValue,
) {
  decode.one_of(
    decode.field("valueCode", decode.string, decode.success)
      |> decode.map(CodesystemConceptPropertyValueCode),
    [
      decode.field("valueCoding", ct.coding_decoder(), decode.success)
        |> decode.map(CodesystemConceptPropertyValueCoding),
      decode.field("valueString", decode.string, decode.success)
        |> decode.map(CodesystemConceptPropertyValueString),
      decode.field("valueInteger", decode.int, decode.success)
        |> decode.map(CodesystemConceptPropertyValueInteger),
      decode.field("valueBoolean", decode.bool, decode.success)
        |> decode.map(CodesystemConceptPropertyValueBoolean),
      decode.field("valueDateTime", pt.datetime_decoder(), decode.success)
        |> decode.map(CodesystemConceptPropertyValueDatetime),
      decode.field("valueDecimal", decode_number(), decode.success)
        |> decode.map(CodesystemConceptPropertyValueDecimal),
    ],
  )
}

pub fn codesystem_concept_property_new(
  value value: CodesystemConceptPropertyValue,
  code code: String,
) -> CodesystemConceptProperty {
  CodesystemConceptProperty(
    value:,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

pub fn codesystem_concept_property_to_json(
  codesystem_concept_property: CodesystemConceptProperty,
) -> Json {
  let fields = [
    #(
      "value"
        <> case codesystem_concept_property.value {
        CodesystemConceptPropertyValueCode(_) -> "Code"
        CodesystemConceptPropertyValueCoding(_) -> "Coding"
        CodesystemConceptPropertyValueString(_) -> "String"
        CodesystemConceptPropertyValueInteger(_) -> "Integer"
        CodesystemConceptPropertyValueBoolean(_) -> "Boolean"
        CodesystemConceptPropertyValueDatetime(_) -> "DateTime"
        CodesystemConceptPropertyValueDecimal(_) -> "Decimal"
      },
      codesystem_concept_property_value_to_json(
        codesystem_concept_property.value,
      ),
    ),
    #("code", json.string(codesystem_concept_property.code)),
  ]
  let fields = case codesystem_concept_property.modifier_extension {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(
          codesystem_concept_property.modifier_extension,
          ct.extension_to_json,
        ),
      ),
      ..fields
    ]
  }
  let fields = case codesystem_concept_property.extension {
    [] -> fields
    _ -> [
      #(
        "extension",
        json.array(codesystem_concept_property.extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case codesystem_concept_property.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn codesystem_concept_property_decoder() -> Decoder(
  CodesystemConceptProperty,
) {
  use <- decode.recursive
  use value <- decode.then(codesystem_concept_property_value_decoder())
  use code <- decode.field("code", decode.string)
  use modifier_extension <- decode.optional_field(
    "modifierExtension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(CodesystemConceptProperty(
    value:,
    code:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

pub fn codesystem_concept_designation_to_json(
  codesystem_concept_designation: CodesystemConceptDesignation,
) -> Json {
  let fields = [
    #("value", json.string(codesystem_concept_designation.value)),
  ]
  let fields = case codesystem_concept_designation.use_ {
    Some(v) -> [#("use", ct.coding_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case codesystem_concept_designation.language {
    Some(v) -> [#("language", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case codesystem_concept_designation.modifier_extension {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(
          codesystem_concept_designation.modifier_extension,
          ct.extension_to_json,
        ),
      ),
      ..fields
    ]
  }
  let fields = case codesystem_concept_designation.extension {
    [] -> fields
    _ -> [
      #(
        "extension",
        json.array(
          codesystem_concept_designation.extension,
          ct.extension_to_json,
        ),
      ),
      ..fields
    ]
  }
  let fields = case codesystem_concept_designation.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn codesystem_concept_designation_decoder() -> Decoder(
  CodesystemConceptDesignation,
) {
  use <- decode.recursive
  use value <- decode.field("value", decode.string)
  use use_ <- decode.optional_field(
    "use",
    None,
    decode.optional(ct.coding_decoder()),
  )
  use language <- decode.optional_field(
    "language",
    None,
    decode.optional(decode.string),
  )
  use modifier_extension <- decode.optional_field(
    "modifierExtension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(CodesystemConceptDesignation(
    value:,
    use_:,
    language:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

pub fn codesystem_concept_to_json(
  codesystem_concept: CodesystemConcept,
) -> Json {
  let fields = [
    #("code", json.string(codesystem_concept.code)),
  ]
  let fields = case codesystem_concept.concept {
    [] -> fields
    _ -> [
      #(
        "concept",
        json.array(codesystem_concept.concept, codesystem_concept_to_json),
      ),
      ..fields
    ]
  }
  let fields = case codesystem_concept.property {
    [] -> fields
    _ -> [
      #(
        "property",
        json.array(
          codesystem_concept.property,
          codesystem_concept_property_to_json,
        ),
      ),
      ..fields
    ]
  }
  let fields = case codesystem_concept.designation {
    [] -> fields
    _ -> [
      #(
        "designation",
        json.array(
          codesystem_concept.designation,
          codesystem_concept_designation_to_json,
        ),
      ),
      ..fields
    ]
  }
  let fields = case codesystem_concept.definition {
    Some(v) -> [#("definition", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case codesystem_concept.display {
    Some(v) -> [#("display", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case codesystem_concept.modifier_extension {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(codesystem_concept.modifier_extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case codesystem_concept.extension {
    [] -> fields
    _ -> [
      #(
        "extension",
        json.array(codesystem_concept.extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case codesystem_concept.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn codesystem_concept_decoder() -> Decoder(CodesystemConcept) {
  use <- decode.recursive
  use concept <- decode.optional_field(
    "concept",
    [],
    decode.list(codesystem_concept_decoder()),
  )
  use property <- decode.optional_field(
    "property",
    [],
    decode.list(codesystem_concept_property_decoder()),
  )
  use designation <- decode.optional_field(
    "designation",
    [],
    decode.list(codesystem_concept_designation_decoder()),
  )
  use definition <- decode.optional_field(
    "definition",
    None,
    decode.optional(decode.string),
  )
  use display <- decode.optional_field(
    "display",
    None,
    decode.optional(decode.string),
  )
  use code <- decode.field("code", decode.string)
  use modifier_extension <- decode.optional_field(
    "modifierExtension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(CodesystemConcept(
    concept:,
    property:,
    designation:,
    definition:,
    display:,
    code:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

pub fn codesystem_property_to_json(
  codesystem_property: CodesystemProperty,
) -> Json {
  let fields = [
    #("type", valueset.concept_property_type_to_json(codesystem_property.type_)),
    #("code", json.string(codesystem_property.code)),
  ]
  let fields = case codesystem_property.description {
    Some(v) -> [#("description", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case codesystem_property.uri {
    Some(v) -> [#("uri", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case codesystem_property.modifier_extension {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(codesystem_property.modifier_extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case codesystem_property.extension {
    [] -> fields
    _ -> [
      #(
        "extension",
        json.array(codesystem_property.extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case codesystem_property.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn codesystem_property_decoder() -> Decoder(CodesystemProperty) {
  use <- decode.recursive
  use type_ <- decode.field("type", valueset.concept_property_type_decoder())
  use description <- decode.optional_field(
    "description",
    None,
    decode.optional(decode.string),
  )
  use uri <- decode.optional_field("uri", None, decode.optional(decode.string))
  use code <- decode.field("code", decode.string)
  use modifier_extension <- decode.optional_field(
    "modifierExtension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(CodesystemProperty(
    type_:,
    description:,
    uri:,
    code:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

pub fn codesystem_filter_to_json(codesystem_filter: CodesystemFilter) -> Json {
  let fields = [
    #("value", json.string(codesystem_filter.value)),
    #(
      "operator",
      list1_to_json(
        codesystem_filter.operator,
        valueset.filter_operator_to_json,
      ),
    ),
    #("code", json.string(codesystem_filter.code)),
  ]
  let fields = case codesystem_filter.description {
    Some(v) -> [#("description", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case codesystem_filter.modifier_extension {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(codesystem_filter.modifier_extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case codesystem_filter.extension {
    [] -> fields
    _ -> [
      #(
        "extension",
        json.array(codesystem_filter.extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case codesystem_filter.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn codesystem_filter_decoder() -> Decoder(CodesystemFilter) {
  use <- decode.recursive
  use value <- decode.field("value", decode.string)
  use operator <- list1_decoder("operator", valueset.filter_operator_decoder())
  use description <- decode.optional_field(
    "description",
    None,
    decode.optional(decode.string),
  )
  use code <- decode.field("code", decode.string)
  use modifier_extension <- decode.optional_field(
    "modifierExtension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(CodesystemFilter(
    value:,
    operator:,
    description:,
    code:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

pub fn codesystem_to_json(codesystem: Codesystem) -> Json {
  let fields = [
    #("content", valueset.codesystem_content_mode_to_json(codesystem.content)),
    #("status", valueset.publication_status_to_json(codesystem.status)),
  ]
  let fields = case codesystem.concept {
    [] -> fields
    _ -> [
      #("concept", json.array(codesystem.concept, codesystem_concept_to_json)),
      ..fields
    ]
  }
  let fields = case codesystem.property {
    [] -> fields
    _ -> [
      #(
        "property",
        json.array(codesystem.property, codesystem_property_to_json),
      ),
      ..fields
    ]
  }
  let fields = case codesystem.filter {
    [] -> fields
    _ -> [
      #("filter", json.array(codesystem.filter, codesystem_filter_to_json)),
      ..fields
    ]
  }
  let fields = case codesystem.count {
    Some(v) -> [#("count", json.int(v)), ..fields]
    None -> fields
  }
  let fields = case codesystem.supplements {
    Some(v) -> [#("supplements", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case codesystem.version_needed {
    Some(v) -> [#("versionNeeded", json.bool(v)), ..fields]
    None -> fields
  }
  let fields = case codesystem.compositional {
    Some(v) -> [#("compositional", json.bool(v)), ..fields]
    None -> fields
  }
  let fields = case codesystem.hierarchy_meaning {
    Some(v) -> [
      #("hierarchyMeaning", valueset.codesystem_hierarchy_meaning_to_json(v)),
      ..fields
    ]
    None -> fields
  }
  let fields = case codesystem.value_set {
    Some(v) -> [#("valueSet", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case codesystem.case_sensitive {
    Some(v) -> [#("caseSensitive", json.bool(v)), ..fields]
    None -> fields
  }
  let fields = case codesystem.copyright {
    Some(v) -> [#("copyright", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case codesystem.purpose {
    Some(v) -> [#("purpose", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case codesystem.jurisdiction {
    [] -> fields
    _ -> [
      #(
        "jurisdiction",
        json.array(codesystem.jurisdiction, ct.codeableconcept_to_json),
      ),
      ..fields
    ]
  }
  let fields = case codesystem.use_context {
    [] -> fields
    _ -> [
      #(
        "useContext",
        json.array(codesystem.use_context, ct.usagecontext_to_json),
      ),
      ..fields
    ]
  }
  let fields = case codesystem.description {
    Some(v) -> [#("description", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case codesystem.contact {
    [] -> fields
    _ -> [
      #("contact", json.array(codesystem.contact, ct.contactdetail_to_json)),
      ..fields
    ]
  }
  let fields = case codesystem.publisher {
    Some(v) -> [#("publisher", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case codesystem.date {
    Some(v) -> [#("date", pt.datetime_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case codesystem.experimental {
    Some(v) -> [#("experimental", json.bool(v)), ..fields]
    None -> fields
  }
  let fields = case codesystem.title {
    Some(v) -> [#("title", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case codesystem.name {
    Some(v) -> [#("name", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case codesystem.version {
    Some(v) -> [#("version", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case codesystem.identifier {
    [] -> fields
    _ -> [
      #("identifier", json.array(codesystem.identifier, ct.identifier_to_json)),
      ..fields
    ]
  }
  let fields = case codesystem.url {
    Some(v) -> [#("url", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case codesystem.modifier_extension {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(codesystem.modifier_extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case codesystem.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(codesystem.extension, ct.extension_to_json)),
      ..fields
    ]
  }
  let fields = case codesystem.contained {
    [] -> fields
    _ -> [#("contained", json.array(codesystem.contained, to_json)), ..fields]
  }
  let fields = case codesystem.text {
    Some(v) -> [#("text", ct.narrative_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case codesystem.language {
    Some(v) -> [#("language", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case codesystem.implicit_rules {
    Some(v) -> [#("implicitRules", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case codesystem.meta {
    Some(v) -> [#("meta", ct.meta_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case codesystem.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  let fields = [#("resourceType", json.string("CodeSystem")), ..fields]
  json.object(fields)
}

pub fn codesystem_decoder() -> Decoder(Codesystem) {
  use <- decode.recursive
  use concept <- decode.optional_field(
    "concept",
    [],
    decode.list(codesystem_concept_decoder()),
  )
  use property <- decode.optional_field(
    "property",
    [],
    decode.list(codesystem_property_decoder()),
  )
  use filter <- decode.optional_field(
    "filter",
    [],
    decode.list(codesystem_filter_decoder()),
  )
  use count <- decode.optional_field("count", None, decode.optional(decode.int))
  use supplements <- decode.optional_field(
    "supplements",
    None,
    decode.optional(decode.string),
  )
  use content <- decode.field(
    "content",
    valueset.codesystem_content_mode_decoder(),
  )
  use version_needed <- decode.optional_field(
    "versionNeeded",
    None,
    decode.optional(decode.bool),
  )
  use compositional <- decode.optional_field(
    "compositional",
    None,
    decode.optional(decode.bool),
  )
  use hierarchy_meaning <- decode.optional_field(
    "hierarchyMeaning",
    None,
    decode.optional(valueset.codesystem_hierarchy_meaning_decoder()),
  )
  use value_set <- decode.optional_field(
    "valueSet",
    None,
    decode.optional(decode.string),
  )
  use case_sensitive <- decode.optional_field(
    "caseSensitive",
    None,
    decode.optional(decode.bool),
  )
  use copyright <- decode.optional_field(
    "copyright",
    None,
    decode.optional(decode.string),
  )
  use purpose <- decode.optional_field(
    "purpose",
    None,
    decode.optional(decode.string),
  )
  use jurisdiction <- decode.optional_field(
    "jurisdiction",
    [],
    decode.list(ct.codeableconcept_decoder()),
  )
  use use_context <- decode.optional_field(
    "useContext",
    [],
    decode.list(ct.usagecontext_decoder()),
  )
  use description <- decode.optional_field(
    "description",
    None,
    decode.optional(decode.string),
  )
  use contact <- decode.optional_field(
    "contact",
    [],
    decode.list(ct.contactdetail_decoder()),
  )
  use publisher <- decode.optional_field(
    "publisher",
    None,
    decode.optional(decode.string),
  )
  use date <- decode.optional_field(
    "date",
    None,
    decode.optional(pt.datetime_decoder()),
  )
  use experimental <- decode.optional_field(
    "experimental",
    None,
    decode.optional(decode.bool),
  )
  use status <- decode.field("status", valueset.publication_status_decoder())
  use title <- decode.optional_field(
    "title",
    None,
    decode.optional(decode.string),
  )
  use name <- decode.optional_field(
    "name",
    None,
    decode.optional(decode.string),
  )
  use version <- decode.optional_field(
    "version",
    None,
    decode.optional(decode.string),
  )
  use identifier <- decode.optional_field(
    "identifier",
    [],
    decode.list(ct.identifier_decoder()),
  )
  use url <- decode.optional_field("url", None, decode.optional(decode.string))
  use modifier_extension <- decode.optional_field(
    "modifierExtension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use contained <- decode.optional_field(
    "contained",
    [],
    decode.list(resource_decoder()),
  )
  use text <- decode.optional_field(
    "text",
    None,
    decode.optional(ct.narrative_decoder()),
  )
  use language <- decode.optional_field(
    "language",
    None,
    decode.optional(decode.string),
  )
  use implicit_rules <- decode.optional_field(
    "implicitRules",
    None,
    decode.optional(decode.string),
  )
  use meta <- decode.optional_field(
    "meta",
    None,
    decode.optional(ct.meta_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))

  use resource_type <- decode.field("resourceType", decode.string)
  use <- bool.guard(
    resource_type != "CodeSystem",
    decode.failure(codesystem_new(content:, status:), "resourceType"),
  )
  decode.success(Codesystem(
    concept:,
    property:,
    filter:,
    count:,
    supplements:,
    content:,
    version_needed:,
    compositional:,
    hierarchy_meaning:,
    value_set:,
    case_sensitive:,
    copyright:,
    purpose:,
    jurisdiction:,
    use_context:,
    description:,
    contact:,
    publisher:,
    date:,
    experimental:,
    status:,
    title:,
    name:,
    version:,
    identifier:,
    url:,
    modifier_extension:,
    extension:,
    contained:,
    text:,
    language:,
    implicit_rules:,
    meta:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4/StructureDefinition/OperationOutcome#resource](http://hl7.org/fhir/r4/StructureDefinition/OperationOutcome#resource)
pub type Operationoutcome {
  Operationoutcome(
    id: Option(String),
    meta: Option(ct.Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(ct.Narrative),
    contained: List(Resource),
    extension: List(ct.Extension),
    modifier_extension: List(ct.Extension),
    issue: List1(OperationoutcomeIssue),
  )
}

pub fn operationoutcome_new(
  issue issue: List1(OperationoutcomeIssue),
) -> Operationoutcome {
  Operationoutcome(
    issue:,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/OperationOutcome#resource](http://hl7.org/fhir/r4/StructureDefinition/OperationOutcome#resource)
pub type OperationoutcomeIssue {
  OperationoutcomeIssue(
    id: Option(String),
    extension: List(ct.Extension),
    modifier_extension: List(ct.Extension),
    severity: valueset.IssueSeverity,
    code: valueset.IssueType,
    details: Option(ct.Codeableconcept),
    diagnostics: Option(String),
    location: List(String),
    expression: List(String),
  )
}

pub fn operationoutcome_issue_new(
  code code: valueset.IssueType,
  severity severity: valueset.IssueSeverity,
) -> OperationoutcomeIssue {
  OperationoutcomeIssue(
    expression: [],
    location: [],
    diagnostics: None,
    details: None,
    code:,
    severity:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

pub fn operationoutcome_issue_to_json(
  operationoutcome_issue: OperationoutcomeIssue,
) -> Json {
  let fields = [
    #("code", valueset.issue_type_to_json(operationoutcome_issue.code)),
    #(
      "severity",
      valueset.issue_severity_to_json(operationoutcome_issue.severity),
    ),
  ]
  let fields = case operationoutcome_issue.expression {
    [] -> fields
    _ -> [
      #(
        "expression",
        json.array(operationoutcome_issue.expression, json.string),
      ),
      ..fields
    ]
  }
  let fields = case operationoutcome_issue.location {
    [] -> fields
    _ -> [
      #("location", json.array(operationoutcome_issue.location, json.string)),
      ..fields
    ]
  }
  let fields = case operationoutcome_issue.diagnostics {
    Some(v) -> [#("diagnostics", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case operationoutcome_issue.details {
    Some(v) -> [#("details", ct.codeableconcept_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case operationoutcome_issue.modifier_extension {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(
          operationoutcome_issue.modifier_extension,
          ct.extension_to_json,
        ),
      ),
      ..fields
    ]
  }
  let fields = case operationoutcome_issue.extension {
    [] -> fields
    _ -> [
      #(
        "extension",
        json.array(operationoutcome_issue.extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case operationoutcome_issue.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn operationoutcome_issue_decoder() -> Decoder(OperationoutcomeIssue) {
  use <- decode.recursive
  use expression <- decode.optional_field(
    "expression",
    [],
    decode.list(decode.string),
  )
  use location <- decode.optional_field(
    "location",
    [],
    decode.list(decode.string),
  )
  use diagnostics <- decode.optional_field(
    "diagnostics",
    None,
    decode.optional(decode.string),
  )
  use details <- decode.optional_field(
    "details",
    None,
    decode.optional(ct.codeableconcept_decoder()),
  )
  use code <- decode.field("code", valueset.issue_type_decoder())
  use severity <- decode.field("severity", valueset.issue_severity_decoder())
  use modifier_extension <- decode.optional_field(
    "modifierExtension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(OperationoutcomeIssue(
    expression:,
    location:,
    diagnostics:,
    details:,
    code:,
    severity:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

pub fn operationoutcome_to_json(operationoutcome: Operationoutcome) -> Json {
  let fields = [
    #(
      "issue",
      list1_to_json(operationoutcome.issue, operationoutcome_issue_to_json),
    ),
  ]
  let fields = case operationoutcome.modifier_extension {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(operationoutcome.modifier_extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case operationoutcome.extension {
    [] -> fields
    _ -> [
      #(
        "extension",
        json.array(operationoutcome.extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case operationoutcome.contained {
    [] -> fields
    _ -> [
      #("contained", json.array(operationoutcome.contained, to_json)),
      ..fields
    ]
  }
  let fields = case operationoutcome.text {
    Some(v) -> [#("text", ct.narrative_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case operationoutcome.language {
    Some(v) -> [#("language", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case operationoutcome.implicit_rules {
    Some(v) -> [#("implicitRules", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case operationoutcome.meta {
    Some(v) -> [#("meta", ct.meta_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case operationoutcome.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  let fields = [#("resourceType", json.string("OperationOutcome")), ..fields]
  json.object(fields)
}

pub fn operationoutcome_decoder() -> Decoder(Operationoutcome) {
  use <- decode.recursive
  use issue <- list1_decoder("issue", operationoutcome_issue_decoder())
  use modifier_extension <- decode.optional_field(
    "modifierExtension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use contained <- decode.optional_field(
    "contained",
    [],
    decode.list(resource_decoder()),
  )
  use text <- decode.optional_field(
    "text",
    None,
    decode.optional(ct.narrative_decoder()),
  )
  use language <- decode.optional_field(
    "language",
    None,
    decode.optional(decode.string),
  )
  use implicit_rules <- decode.optional_field(
    "implicitRules",
    None,
    decode.optional(decode.string),
  )
  use meta <- decode.optional_field(
    "meta",
    None,
    decode.optional(ct.meta_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))

  use resource_type <- decode.field("resourceType", decode.string)
  use <- bool.guard(
    resource_type != "OperationOutcome",
    decode.failure(operationoutcome_new(issue:), "resourceType"),
  )
  decode.success(Operationoutcome(
    issue:,
    modifier_extension:,
    extension:,
    contained:,
    text:,
    language:,
    implicit_rules:,
    meta:,
    id:,
  ))
}

///[http://hl7.org/fhir/r4/StructureDefinition/Parameters#resource](http://hl7.org/fhir/r4/StructureDefinition/Parameters#resource)
pub type Parameters {
  Parameters(
    id: Option(String),
    meta: Option(ct.Meta),
    implicit_rules: Option(String),
    language: Option(String),
    parameter: List(ParametersParameter),
  )
}

pub fn parameters_new() -> Parameters {
  Parameters(
    parameter: [],
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/Parameters#resource](http://hl7.org/fhir/r4/StructureDefinition/Parameters#resource)
pub type ParametersParameter {
  ParametersParameter(
    id: Option(String),
    extension: List(ct.Extension),
    modifier_extension: List(ct.Extension),
    name: String,
    value: Option(ParametersParameterValue),
    resource: Option(Resource),
    part: List(ParametersParameter),
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/Parameters#resource](http://hl7.org/fhir/r4/StructureDefinition/Parameters#resource)
pub type ParametersParameterValue {
  ParametersParameterValueBase64binary(value: String)
  ParametersParameterValueBoolean(value: Bool)
  ParametersParameterValueCanonical(value: String)
  ParametersParameterValueCode(value: String)
  ParametersParameterValueDate(value: Date)
  ParametersParameterValueDatetime(value: DateTime)
  ParametersParameterValueDecimal(value: Float)
  ParametersParameterValueId(value: String)
  ParametersParameterValueInstant(value: Instant)
  ParametersParameterValueInteger(value: Int)
  ParametersParameterValueMarkdown(value: String)
  ParametersParameterValueOid(value: String)
  ParametersParameterValuePositiveint(value: Int)
  ParametersParameterValueString(value: String)
  ParametersParameterValueTime(value: Time)
  ParametersParameterValueUnsignedint(value: Int)
  ParametersParameterValueUri(value: String)
  ParametersParameterValueUrl(value: String)
  ParametersParameterValueUuid(value: String)
  ParametersParameterValueAddress(value: ct.Address)
  ParametersParameterValueAge(value: ct.Age)
  ParametersParameterValueAnnotation(value: ct.Annotation)
  ParametersParameterValueAttachment(value: ct.Attachment)
  ParametersParameterValueCodeableconcept(value: ct.Codeableconcept)
  ParametersParameterValueCoding(value: ct.Coding)
  ParametersParameterValueContactpoint(value: ct.Contactpoint)
  ParametersParameterValueCount(value: ct.Count)
  ParametersParameterValueDistance(value: ct.Distance)
  ParametersParameterValueDuration(value: ct.Duration)
  ParametersParameterValueHumanname(value: ct.Humanname)
  ParametersParameterValueIdentifier(value: ct.Identifier)
  ParametersParameterValueMoney(value: ct.Money)
  ParametersParameterValuePeriod(value: ct.Period)
  ParametersParameterValueQuantity(value: ct.Quantity)
  ParametersParameterValueRange(value: ct.Range)
  ParametersParameterValueRatio(value: ct.Ratio)
  ParametersParameterValueReference(value: ct.Reference)
  ParametersParameterValueSampleddata(value: ct.Sampleddata)
  ParametersParameterValueSignature(value: ct.Signature)
  ParametersParameterValueTiming(value: ct.Timing)
  ParametersParameterValueContactdetail(value: ct.Contactdetail)
  ParametersParameterValueContributor(value: ct.Contributor)
  ParametersParameterValueDatarequirement(value: ct.Datarequirement)
  ParametersParameterValueExpression(value: ct.Expression)
  ParametersParameterValueParameterdefinition(value: ct.Parameterdefinition)
  ParametersParameterValueRelatedartifact(value: ct.Relatedartifact)
  ParametersParameterValueTriggerdefinition(value: ct.Triggerdefinition)
  ParametersParameterValueUsagecontext(value: ct.Usagecontext)
  ParametersParameterValueDosage(value: ct.Dosage)
  ParametersParameterValueMeta(value: ct.Meta)
}

pub fn parameters_parameter_value_to_json(
  element: ParametersParameterValue,
) -> Json {
  case element {
    ParametersParameterValueBase64binary(v) -> json.string(v)
    ParametersParameterValueBoolean(v) -> json.bool(v)
    ParametersParameterValueCanonical(v) -> json.string(v)
    ParametersParameterValueCode(v) -> json.string(v)
    ParametersParameterValueDate(v) -> pt.date_to_json(v)
    ParametersParameterValueDatetime(v) -> pt.datetime_to_json(v)
    ParametersParameterValueDecimal(v) -> json.float(v)
    ParametersParameterValueId(v) -> json.string(v)
    ParametersParameterValueInstant(v) -> pt.instant_to_json(v)
    ParametersParameterValueInteger(v) -> json.int(v)
    ParametersParameterValueMarkdown(v) -> json.string(v)
    ParametersParameterValueOid(v) -> json.string(v)
    ParametersParameterValuePositiveint(v) -> json.int(v)
    ParametersParameterValueString(v) -> json.string(v)
    ParametersParameterValueTime(v) -> pt.time_to_json(v)
    ParametersParameterValueUnsignedint(v) -> json.int(v)
    ParametersParameterValueUri(v) -> json.string(v)
    ParametersParameterValueUrl(v) -> json.string(v)
    ParametersParameterValueUuid(v) -> json.string(v)
    ParametersParameterValueAddress(v) -> ct.address_to_json(v)
    ParametersParameterValueAge(v) -> ct.age_to_json(v)
    ParametersParameterValueAnnotation(v) -> ct.annotation_to_json(v)
    ParametersParameterValueAttachment(v) -> ct.attachment_to_json(v)
    ParametersParameterValueCodeableconcept(v) -> ct.codeableconcept_to_json(v)
    ParametersParameterValueCoding(v) -> ct.coding_to_json(v)
    ParametersParameterValueContactpoint(v) -> ct.contactpoint_to_json(v)
    ParametersParameterValueCount(v) -> ct.count_to_json(v)
    ParametersParameterValueDistance(v) -> ct.distance_to_json(v)
    ParametersParameterValueDuration(v) -> ct.duration_to_json(v)
    ParametersParameterValueHumanname(v) -> ct.humanname_to_json(v)
    ParametersParameterValueIdentifier(v) -> ct.identifier_to_json(v)
    ParametersParameterValueMoney(v) -> ct.money_to_json(v)
    ParametersParameterValuePeriod(v) -> ct.period_to_json(v)
    ParametersParameterValueQuantity(v) -> ct.quantity_to_json(v)
    ParametersParameterValueRange(v) -> ct.range_to_json(v)
    ParametersParameterValueRatio(v) -> ct.ratio_to_json(v)
    ParametersParameterValueReference(v) -> ct.reference_to_json(v)
    ParametersParameterValueSampleddata(v) -> ct.sampleddata_to_json(v)
    ParametersParameterValueSignature(v) -> ct.signature_to_json(v)
    ParametersParameterValueTiming(v) -> ct.timing_to_json(v)
    ParametersParameterValueContactdetail(v) -> ct.contactdetail_to_json(v)
    ParametersParameterValueContributor(v) -> ct.contributor_to_json(v)
    ParametersParameterValueDatarequirement(v) -> ct.datarequirement_to_json(v)
    ParametersParameterValueExpression(v) -> ct.expression_to_json(v)
    ParametersParameterValueParameterdefinition(v) ->
      ct.parameterdefinition_to_json(v)
    ParametersParameterValueRelatedartifact(v) -> ct.relatedartifact_to_json(v)
    ParametersParameterValueTriggerdefinition(v) ->
      ct.triggerdefinition_to_json(v)
    ParametersParameterValueUsagecontext(v) -> ct.usagecontext_to_json(v)
    ParametersParameterValueDosage(v) -> ct.dosage_to_json(v)
    ParametersParameterValueMeta(v) -> ct.meta_to_json(v)
  }
}

pub fn parameters_parameter_value_decoder() -> Decoder(ParametersParameterValue) {
  decode.one_of(
    decode.field("valueBase64Binary", decode.string, decode.success)
      |> decode.map(ParametersParameterValueBase64binary),
    [
      decode.field("valueBoolean", decode.bool, decode.success)
        |> decode.map(ParametersParameterValueBoolean),
      decode.field("valueCanonical", decode.string, decode.success)
        |> decode.map(ParametersParameterValueCanonical),
      decode.field("valueCode", decode.string, decode.success)
        |> decode.map(ParametersParameterValueCode),
      decode.field("valueDate", pt.date_decoder(), decode.success)
        |> decode.map(ParametersParameterValueDate),
      decode.field("valueDateTime", pt.datetime_decoder(), decode.success)
        |> decode.map(ParametersParameterValueDatetime),
      decode.field("valueDecimal", decode_number(), decode.success)
        |> decode.map(ParametersParameterValueDecimal),
      decode.field("valueId", decode.string, decode.success)
        |> decode.map(ParametersParameterValueId),
      decode.field("valueInstant", pt.instant_decoder(), decode.success)
        |> decode.map(ParametersParameterValueInstant),
      decode.field("valueInteger", decode.int, decode.success)
        |> decode.map(ParametersParameterValueInteger),
      decode.field("valueMarkdown", decode.string, decode.success)
        |> decode.map(ParametersParameterValueMarkdown),
      decode.field("valueOid", decode.string, decode.success)
        |> decode.map(ParametersParameterValueOid),
      decode.field("valuePositiveInt", decode.int, decode.success)
        |> decode.map(ParametersParameterValuePositiveint),
      decode.field("valueString", decode.string, decode.success)
        |> decode.map(ParametersParameterValueString),
      decode.field("valueTime", pt.time_decoder(), decode.success)
        |> decode.map(ParametersParameterValueTime),
      decode.field("valueUnsignedInt", decode.int, decode.success)
        |> decode.map(ParametersParameterValueUnsignedint),
      decode.field("valueUri", decode.string, decode.success)
        |> decode.map(ParametersParameterValueUri),
      decode.field("valueUrl", decode.string, decode.success)
        |> decode.map(ParametersParameterValueUrl),
      decode.field("valueUuid", decode.string, decode.success)
        |> decode.map(ParametersParameterValueUuid),
      decode.field("valueAddress", ct.address_decoder(), decode.success)
        |> decode.map(ParametersParameterValueAddress),
      decode.field("valueAge", ct.age_decoder(), decode.success)
        |> decode.map(ParametersParameterValueAge),
      decode.field("valueAnnotation", ct.annotation_decoder(), decode.success)
        |> decode.map(ParametersParameterValueAnnotation),
      decode.field("valueAttachment", ct.attachment_decoder(), decode.success)
        |> decode.map(ParametersParameterValueAttachment),
      decode.field(
        "valueCodeableConcept",
        ct.codeableconcept_decoder(),
        decode.success,
      )
        |> decode.map(ParametersParameterValueCodeableconcept),
      decode.field("valueCoding", ct.coding_decoder(), decode.success)
        |> decode.map(ParametersParameterValueCoding),
      decode.field(
        "valueContactPoint",
        ct.contactpoint_decoder(),
        decode.success,
      )
        |> decode.map(ParametersParameterValueContactpoint),
      decode.field("valueCount", ct.count_decoder(), decode.success)
        |> decode.map(ParametersParameterValueCount),
      decode.field("valueDistance", ct.distance_decoder(), decode.success)
        |> decode.map(ParametersParameterValueDistance),
      decode.field("valueDuration", ct.duration_decoder(), decode.success)
        |> decode.map(ParametersParameterValueDuration),
      decode.field("valueHumanName", ct.humanname_decoder(), decode.success)
        |> decode.map(ParametersParameterValueHumanname),
      decode.field("valueIdentifier", ct.identifier_decoder(), decode.success)
        |> decode.map(ParametersParameterValueIdentifier),
      decode.field("valueMoney", ct.money_decoder(), decode.success)
        |> decode.map(ParametersParameterValueMoney),
      decode.field("valuePeriod", ct.period_decoder(), decode.success)
        |> decode.map(ParametersParameterValuePeriod),
      decode.field("valueQuantity", ct.quantity_decoder(), decode.success)
        |> decode.map(ParametersParameterValueQuantity),
      decode.field("valueRange", ct.range_decoder(), decode.success)
        |> decode.map(ParametersParameterValueRange),
      decode.field("valueRatio", ct.ratio_decoder(), decode.success)
        |> decode.map(ParametersParameterValueRatio),
      decode.field("valueReference", ct.reference_decoder(), decode.success)
        |> decode.map(ParametersParameterValueReference),
      decode.field("valueSampledData", ct.sampleddata_decoder(), decode.success)
        |> decode.map(ParametersParameterValueSampleddata),
      decode.field("valueSignature", ct.signature_decoder(), decode.success)
        |> decode.map(ParametersParameterValueSignature),
      decode.field("valueTiming", ct.timing_decoder(), decode.success)
        |> decode.map(ParametersParameterValueTiming),
      decode.field(
        "valueContactDetail",
        ct.contactdetail_decoder(),
        decode.success,
      )
        |> decode.map(ParametersParameterValueContactdetail),
      decode.field("valueContributor", ct.contributor_decoder(), decode.success)
        |> decode.map(ParametersParameterValueContributor),
      decode.field(
        "valueDataRequirement",
        ct.datarequirement_decoder(),
        decode.success,
      )
        |> decode.map(ParametersParameterValueDatarequirement),
      decode.field("valueExpression", ct.expression_decoder(), decode.success)
        |> decode.map(ParametersParameterValueExpression),
      decode.field(
        "valueParameterDefinition",
        ct.parameterdefinition_decoder(),
        decode.success,
      )
        |> decode.map(ParametersParameterValueParameterdefinition),
      decode.field(
        "valueRelatedArtifact",
        ct.relatedartifact_decoder(),
        decode.success,
      )
        |> decode.map(ParametersParameterValueRelatedartifact),
      decode.field(
        "valueTriggerDefinition",
        ct.triggerdefinition_decoder(),
        decode.success,
      )
        |> decode.map(ParametersParameterValueTriggerdefinition),
      decode.field(
        "valueUsageContext",
        ct.usagecontext_decoder(),
        decode.success,
      )
        |> decode.map(ParametersParameterValueUsagecontext),
      decode.field("valueDosage", ct.dosage_decoder(), decode.success)
        |> decode.map(ParametersParameterValueDosage),
      decode.field("valueMeta", ct.meta_decoder(), decode.success)
        |> decode.map(ParametersParameterValueMeta),
    ],
  )
}

pub fn parameters_parameter_new(name name: String) -> ParametersParameter {
  ParametersParameter(
    part: [],
    resource: None,
    value: None,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

pub fn parameters_parameter_to_json(
  parameters_parameter: ParametersParameter,
) -> Json {
  let fields = [
    #("name", json.string(parameters_parameter.name)),
  ]
  let fields = case parameters_parameter.part {
    [] -> fields
    _ -> [
      #(
        "part",
        json.array(parameters_parameter.part, parameters_parameter_to_json),
      ),
      ..fields
    ]
  }
  let fields = case parameters_parameter.resource {
    Some(v) -> [#("resource", to_json(v)), ..fields]
    None -> fields
  }
  let fields = case parameters_parameter.value {
    Some(v) -> [
      #(
        "value"
          <> case v {
          ParametersParameterValueBase64binary(_) -> "Base64Binary"
          ParametersParameterValueBoolean(_) -> "Boolean"
          ParametersParameterValueCanonical(_) -> "Canonical"
          ParametersParameterValueCode(_) -> "Code"
          ParametersParameterValueDate(_) -> "Date"
          ParametersParameterValueDatetime(_) -> "DateTime"
          ParametersParameterValueDecimal(_) -> "Decimal"
          ParametersParameterValueId(_) -> "Id"
          ParametersParameterValueInstant(_) -> "Instant"
          ParametersParameterValueInteger(_) -> "Integer"
          ParametersParameterValueMarkdown(_) -> "Markdown"
          ParametersParameterValueOid(_) -> "Oid"
          ParametersParameterValuePositiveint(_) -> "PositiveInt"
          ParametersParameterValueString(_) -> "String"
          ParametersParameterValueTime(_) -> "Time"
          ParametersParameterValueUnsignedint(_) -> "UnsignedInt"
          ParametersParameterValueUri(_) -> "Uri"
          ParametersParameterValueUrl(_) -> "Url"
          ParametersParameterValueUuid(_) -> "Uuid"
          ParametersParameterValueAddress(_) -> "Address"
          ParametersParameterValueAge(_) -> "Age"
          ParametersParameterValueAnnotation(_) -> "Annotation"
          ParametersParameterValueAttachment(_) -> "Attachment"
          ParametersParameterValueCodeableconcept(_) -> "CodeableConcept"
          ParametersParameterValueCoding(_) -> "Coding"
          ParametersParameterValueContactpoint(_) -> "ContactPoint"
          ParametersParameterValueCount(_) -> "Count"
          ParametersParameterValueDistance(_) -> "Distance"
          ParametersParameterValueDuration(_) -> "Duration"
          ParametersParameterValueHumanname(_) -> "HumanName"
          ParametersParameterValueIdentifier(_) -> "Identifier"
          ParametersParameterValueMoney(_) -> "Money"
          ParametersParameterValuePeriod(_) -> "Period"
          ParametersParameterValueQuantity(_) -> "Quantity"
          ParametersParameterValueRange(_) -> "Range"
          ParametersParameterValueRatio(_) -> "Ratio"
          ParametersParameterValueReference(_) -> "Reference"
          ParametersParameterValueSampleddata(_) -> "SampledData"
          ParametersParameterValueSignature(_) -> "Signature"
          ParametersParameterValueTiming(_) -> "Timing"
          ParametersParameterValueContactdetail(_) -> "ContactDetail"
          ParametersParameterValueContributor(_) -> "Contributor"
          ParametersParameterValueDatarequirement(_) -> "DataRequirement"
          ParametersParameterValueExpression(_) -> "Expression"
          ParametersParameterValueParameterdefinition(_) ->
            "ParameterDefinition"
          ParametersParameterValueRelatedartifact(_) -> "RelatedArtifact"
          ParametersParameterValueTriggerdefinition(_) -> "TriggerDefinition"
          ParametersParameterValueUsagecontext(_) -> "UsageContext"
          ParametersParameterValueDosage(_) -> "Dosage"
          ParametersParameterValueMeta(_) -> "Meta"
        },
        parameters_parameter_value_to_json(v),
      ),
      ..fields
    ]
    None -> fields
  }
  let fields = case parameters_parameter.modifier_extension {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(
          parameters_parameter.modifier_extension,
          ct.extension_to_json,
        ),
      ),
      ..fields
    ]
  }
  let fields = case parameters_parameter.extension {
    [] -> fields
    _ -> [
      #(
        "extension",
        json.array(parameters_parameter.extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case parameters_parameter.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn parameters_parameter_decoder() -> Decoder(ParametersParameter) {
  use <- decode.recursive
  use part <- decode.optional_field(
    "part",
    [],
    decode.list(parameters_parameter_decoder()),
  )
  use resource <- decode.optional_field(
    "resource",
    None,
    decode.optional(resource_decoder()),
  )
  use value <- decode.then(
    none_if_omitted(parameters_parameter_value_decoder()),
  )
  use name <- decode.field("name", decode.string)
  use modifier_extension <- decode.optional_field(
    "modifierExtension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(ParametersParameter(
    part:,
    resource:,
    value:,
    name:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

pub fn parameters_to_json(parameters: Parameters) -> Json {
  let fields = []
  let fields = case parameters.parameter {
    [] -> fields
    _ -> [
      #(
        "parameter",
        json.array(parameters.parameter, parameters_parameter_to_json),
      ),
      ..fields
    ]
  }
  let fields = case parameters.language {
    Some(v) -> [#("language", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case parameters.implicit_rules {
    Some(v) -> [#("implicitRules", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case parameters.meta {
    Some(v) -> [#("meta", ct.meta_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case parameters.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  let fields = [#("resourceType", json.string("Parameters")), ..fields]
  json.object(fields)
}

pub fn parameters_decoder() -> Decoder(Parameters) {
  use <- decode.recursive
  use parameter <- decode.optional_field(
    "parameter",
    [],
    decode.list(parameters_parameter_decoder()),
  )
  use language <- decode.optional_field(
    "language",
    None,
    decode.optional(decode.string),
  )
  use implicit_rules <- decode.optional_field(
    "implicitRules",
    None,
    decode.optional(decode.string),
  )
  use meta <- decode.optional_field(
    "meta",
    None,
    decode.optional(ct.meta_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))

  use resource_type <- decode.field("resourceType", decode.string)
  use <- bool.guard(
    resource_type != "Parameters",
    decode.failure(parameters_new(), "resourceType"),
  )
  decode.success(Parameters(parameter:, language:, implicit_rules:, meta:, id:))
}

///[http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource](http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource)
pub type Valueset {
  Valueset(
    id: Option(String),
    meta: Option(ct.Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(ct.Narrative),
    contained: List(Resource),
    extension: List(ct.Extension),
    modifier_extension: List(ct.Extension),
    url: Option(String),
    identifier: List(ct.Identifier),
    version: Option(String),
    name: Option(String),
    title: Option(String),
    status: valueset.PublicationStatus,
    experimental: Option(Bool),
    date: Option(DateTime),
    publisher: Option(String),
    contact: List(ct.Contactdetail),
    description: Option(String),
    use_context: List(ct.Usagecontext),
    jurisdiction: List(ct.Codeableconcept),
    immutable: Option(Bool),
    purpose: Option(String),
    copyright: Option(String),
    compose: Option(ValuesetCompose),
    expansion: Option(ValuesetExpansion),
  )
}

pub fn valueset_new(status status: valueset.PublicationStatus) -> Valueset {
  Valueset(
    expansion: None,
    compose: None,
    copyright: None,
    purpose: None,
    immutable: None,
    jurisdiction: [],
    use_context: [],
    description: None,
    contact: [],
    publisher: None,
    date: None,
    experimental: None,
    status:,
    title: None,
    name: None,
    version: None,
    identifier: [],
    url: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource](http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource)
pub type ValuesetCompose {
  ValuesetCompose(
    id: Option(String),
    extension: List(ct.Extension),
    modifier_extension: List(ct.Extension),
    locked_date: Option(Date),
    inactive: Option(Bool),
    include: List1(ValuesetComposeInclude),
    exclude: List(ValuesetComposeInclude),
  )
}

pub fn valueset_compose_new(
  include include: List1(ValuesetComposeInclude),
) -> ValuesetCompose {
  ValuesetCompose(
    exclude: [],
    include:,
    inactive: None,
    locked_date: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource](http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource)
pub type ValuesetComposeInclude {
  ValuesetComposeInclude(
    id: Option(String),
    extension: List(ct.Extension),
    modifier_extension: List(ct.Extension),
    system: Option(String),
    version: Option(String),
    concept: List(ValuesetComposeIncludeConcept),
    filter: List(ValuesetComposeIncludeFilter),
    value_set: List(String),
  )
}

pub fn valueset_compose_include_new() -> ValuesetComposeInclude {
  ValuesetComposeInclude(
    value_set: [],
    filter: [],
    concept: [],
    version: None,
    system: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource](http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource)
pub type ValuesetComposeIncludeConcept {
  ValuesetComposeIncludeConcept(
    id: Option(String),
    extension: List(ct.Extension),
    modifier_extension: List(ct.Extension),
    code: String,
    display: Option(String),
    designation: List(ValuesetComposeIncludeConceptDesignation),
  )
}

pub fn valueset_compose_include_concept_new(
  code code: String,
) -> ValuesetComposeIncludeConcept {
  ValuesetComposeIncludeConcept(
    designation: [],
    display: None,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource](http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource)
pub type ValuesetComposeIncludeConceptDesignation {
  ValuesetComposeIncludeConceptDesignation(
    id: Option(String),
    extension: List(ct.Extension),
    modifier_extension: List(ct.Extension),
    language: Option(String),
    use_: Option(ct.Coding),
    value: String,
  )
}

pub fn valueset_compose_include_concept_designation_new(
  value value: String,
) -> ValuesetComposeIncludeConceptDesignation {
  ValuesetComposeIncludeConceptDesignation(
    value:,
    use_: None,
    language: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource](http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource)
pub type ValuesetComposeIncludeFilter {
  ValuesetComposeIncludeFilter(
    id: Option(String),
    extension: List(ct.Extension),
    modifier_extension: List(ct.Extension),
    property: String,
    op: valueset.FilterOperator,
    value: String,
  )
}

pub fn valueset_compose_include_filter_new(
  value value: String,
  op op: valueset.FilterOperator,
  property property: String,
) -> ValuesetComposeIncludeFilter {
  ValuesetComposeIncludeFilter(
    value:,
    op:,
    property:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource](http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource)
pub type ValuesetExpansion {
  ValuesetExpansion(
    id: Option(String),
    extension: List(ct.Extension),
    modifier_extension: List(ct.Extension),
    identifier: Option(String),
    timestamp: DateTime,
    total: Option(Int),
    offset: Option(Int),
    parameter: List(ValuesetExpansionParameter),
    contains: List(ValuesetExpansionContains),
  )
}

pub fn valueset_expansion_new(
  timestamp timestamp: DateTime,
) -> ValuesetExpansion {
  ValuesetExpansion(
    contains: [],
    parameter: [],
    offset: None,
    total: None,
    timestamp:,
    identifier: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource](http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource)
pub type ValuesetExpansionParameter {
  ValuesetExpansionParameter(
    id: Option(String),
    extension: List(ct.Extension),
    modifier_extension: List(ct.Extension),
    name: String,
    value: Option(ValuesetExpansionParameterValue),
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource](http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource)
pub type ValuesetExpansionParameterValue {
  ValuesetExpansionParameterValueString(value: String)
  ValuesetExpansionParameterValueBoolean(value: Bool)
  ValuesetExpansionParameterValueInteger(value: Int)
  ValuesetExpansionParameterValueDecimal(value: Float)
  ValuesetExpansionParameterValueUri(value: String)
  ValuesetExpansionParameterValueCode(value: String)
  ValuesetExpansionParameterValueDatetime(value: DateTime)
}

pub fn valueset_expansion_parameter_value_to_json(
  element: ValuesetExpansionParameterValue,
) -> Json {
  case element {
    ValuesetExpansionParameterValueString(v) -> json.string(v)
    ValuesetExpansionParameterValueBoolean(v) -> json.bool(v)
    ValuesetExpansionParameterValueInteger(v) -> json.int(v)
    ValuesetExpansionParameterValueDecimal(v) -> json.float(v)
    ValuesetExpansionParameterValueUri(v) -> json.string(v)
    ValuesetExpansionParameterValueCode(v) -> json.string(v)
    ValuesetExpansionParameterValueDatetime(v) -> pt.datetime_to_json(v)
  }
}

pub fn valueset_expansion_parameter_value_decoder() -> Decoder(
  ValuesetExpansionParameterValue,
) {
  decode.one_of(
    decode.field("valueString", decode.string, decode.success)
      |> decode.map(ValuesetExpansionParameterValueString),
    [
      decode.field("valueBoolean", decode.bool, decode.success)
        |> decode.map(ValuesetExpansionParameterValueBoolean),
      decode.field("valueInteger", decode.int, decode.success)
        |> decode.map(ValuesetExpansionParameterValueInteger),
      decode.field("valueDecimal", decode_number(), decode.success)
        |> decode.map(ValuesetExpansionParameterValueDecimal),
      decode.field("valueUri", decode.string, decode.success)
        |> decode.map(ValuesetExpansionParameterValueUri),
      decode.field("valueCode", decode.string, decode.success)
        |> decode.map(ValuesetExpansionParameterValueCode),
      decode.field("valueDateTime", pt.datetime_decoder(), decode.success)
        |> decode.map(ValuesetExpansionParameterValueDatetime),
    ],
  )
}

pub fn valueset_expansion_parameter_new(
  name name: String,
) -> ValuesetExpansionParameter {
  ValuesetExpansionParameter(
    value: None,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource](http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource)
pub type ValuesetExpansionContains {
  ValuesetExpansionContains(
    id: Option(String),
    extension: List(ct.Extension),
    modifier_extension: List(ct.Extension),
    system: Option(String),
    abstract: Option(Bool),
    inactive: Option(Bool),
    version: Option(String),
    code: Option(String),
    display: Option(String),
    designation: List(ValuesetComposeIncludeConceptDesignation),
    contains: List(ValuesetExpansionContains),
  )
}

pub fn valueset_expansion_contains_new() -> ValuesetExpansionContains {
  ValuesetExpansionContains(
    contains: [],
    designation: [],
    display: None,
    code: None,
    version: None,
    inactive: None,
    abstract: None,
    system: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

pub fn valueset_expansion_contains_to_json(
  valueset_expansion_contains: ValuesetExpansionContains,
) -> Json {
  let fields = []
  let fields = case valueset_expansion_contains.contains {
    [] -> fields
    _ -> [
      #(
        "contains",
        json.array(
          valueset_expansion_contains.contains,
          valueset_expansion_contains_to_json,
        ),
      ),
      ..fields
    ]
  }
  let fields = case valueset_expansion_contains.designation {
    [] -> fields
    _ -> [
      #(
        "designation",
        json.array(
          valueset_expansion_contains.designation,
          valueset_compose_include_concept_designation_to_json,
        ),
      ),
      ..fields
    ]
  }
  let fields = case valueset_expansion_contains.display {
    Some(v) -> [#("display", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case valueset_expansion_contains.code {
    Some(v) -> [#("code", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case valueset_expansion_contains.version {
    Some(v) -> [#("version", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case valueset_expansion_contains.inactive {
    Some(v) -> [#("inactive", json.bool(v)), ..fields]
    None -> fields
  }
  let fields = case valueset_expansion_contains.abstract {
    Some(v) -> [#("abstract", json.bool(v)), ..fields]
    None -> fields
  }
  let fields = case valueset_expansion_contains.system {
    Some(v) -> [#("system", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case valueset_expansion_contains.modifier_extension {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(
          valueset_expansion_contains.modifier_extension,
          ct.extension_to_json,
        ),
      ),
      ..fields
    ]
  }
  let fields = case valueset_expansion_contains.extension {
    [] -> fields
    _ -> [
      #(
        "extension",
        json.array(valueset_expansion_contains.extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case valueset_expansion_contains.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn valueset_expansion_contains_decoder() -> Decoder(
  ValuesetExpansionContains,
) {
  use <- decode.recursive
  use contains <- decode.optional_field(
    "contains",
    [],
    decode.list(valueset_expansion_contains_decoder()),
  )
  use designation <- decode.optional_field(
    "designation",
    [],
    decode.list(valueset_compose_include_concept_designation_decoder()),
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
  use inactive <- decode.optional_field(
    "inactive",
    None,
    decode.optional(decode.bool),
  )
  use abstract <- decode.optional_field(
    "abstract",
    None,
    decode.optional(decode.bool),
  )
  use system <- decode.optional_field(
    "system",
    None,
    decode.optional(decode.string),
  )
  use modifier_extension <- decode.optional_field(
    "modifierExtension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(ValuesetExpansionContains(
    contains:,
    designation:,
    display:,
    code:,
    version:,
    inactive:,
    abstract:,
    system:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

pub fn valueset_expansion_parameter_to_json(
  valueset_expansion_parameter: ValuesetExpansionParameter,
) -> Json {
  let fields = [
    #("name", json.string(valueset_expansion_parameter.name)),
  ]
  let fields = case valueset_expansion_parameter.value {
    Some(v) -> [
      #(
        "value"
          <> case v {
          ValuesetExpansionParameterValueString(_) -> "String"
          ValuesetExpansionParameterValueBoolean(_) -> "Boolean"
          ValuesetExpansionParameterValueInteger(_) -> "Integer"
          ValuesetExpansionParameterValueDecimal(_) -> "Decimal"
          ValuesetExpansionParameterValueUri(_) -> "Uri"
          ValuesetExpansionParameterValueCode(_) -> "Code"
          ValuesetExpansionParameterValueDatetime(_) -> "DateTime"
        },
        valueset_expansion_parameter_value_to_json(v),
      ),
      ..fields
    ]
    None -> fields
  }
  let fields = case valueset_expansion_parameter.modifier_extension {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(
          valueset_expansion_parameter.modifier_extension,
          ct.extension_to_json,
        ),
      ),
      ..fields
    ]
  }
  let fields = case valueset_expansion_parameter.extension {
    [] -> fields
    _ -> [
      #(
        "extension",
        json.array(valueset_expansion_parameter.extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case valueset_expansion_parameter.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn valueset_expansion_parameter_decoder() -> Decoder(
  ValuesetExpansionParameter,
) {
  use <- decode.recursive
  use value <- decode.then(
    none_if_omitted(valueset_expansion_parameter_value_decoder()),
  )
  use name <- decode.field("name", decode.string)
  use modifier_extension <- decode.optional_field(
    "modifierExtension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(ValuesetExpansionParameter(
    value:,
    name:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

pub fn valueset_expansion_to_json(
  valueset_expansion: ValuesetExpansion,
) -> Json {
  let fields = [
    #("timestamp", pt.datetime_to_json(valueset_expansion.timestamp)),
  ]
  let fields = case valueset_expansion.contains {
    [] -> fields
    _ -> [
      #(
        "contains",
        json.array(
          valueset_expansion.contains,
          valueset_expansion_contains_to_json,
        ),
      ),
      ..fields
    ]
  }
  let fields = case valueset_expansion.parameter {
    [] -> fields
    _ -> [
      #(
        "parameter",
        json.array(
          valueset_expansion.parameter,
          valueset_expansion_parameter_to_json,
        ),
      ),
      ..fields
    ]
  }
  let fields = case valueset_expansion.offset {
    Some(v) -> [#("offset", json.int(v)), ..fields]
    None -> fields
  }
  let fields = case valueset_expansion.total {
    Some(v) -> [#("total", json.int(v)), ..fields]
    None -> fields
  }
  let fields = case valueset_expansion.identifier {
    Some(v) -> [#("identifier", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case valueset_expansion.modifier_extension {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(valueset_expansion.modifier_extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case valueset_expansion.extension {
    [] -> fields
    _ -> [
      #(
        "extension",
        json.array(valueset_expansion.extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case valueset_expansion.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn valueset_expansion_decoder() -> Decoder(ValuesetExpansion) {
  use <- decode.recursive
  use contains <- decode.optional_field(
    "contains",
    [],
    decode.list(valueset_expansion_contains_decoder()),
  )
  use parameter <- decode.optional_field(
    "parameter",
    [],
    decode.list(valueset_expansion_parameter_decoder()),
  )
  use offset <- decode.optional_field(
    "offset",
    None,
    decode.optional(decode.int),
  )
  use total <- decode.optional_field("total", None, decode.optional(decode.int))
  use timestamp <- decode.field("timestamp", pt.datetime_decoder())
  use identifier <- decode.optional_field(
    "identifier",
    None,
    decode.optional(decode.string),
  )
  use modifier_extension <- decode.optional_field(
    "modifierExtension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(ValuesetExpansion(
    contains:,
    parameter:,
    offset:,
    total:,
    timestamp:,
    identifier:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

pub fn valueset_compose_include_filter_to_json(
  valueset_compose_include_filter: ValuesetComposeIncludeFilter,
) -> Json {
  let fields = [
    #("value", json.string(valueset_compose_include_filter.value)),
    #(
      "op",
      valueset.filter_operator_to_json(valueset_compose_include_filter.op),
    ),
    #("property", json.string(valueset_compose_include_filter.property)),
  ]
  let fields = case valueset_compose_include_filter.modifier_extension {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(
          valueset_compose_include_filter.modifier_extension,
          ct.extension_to_json,
        ),
      ),
      ..fields
    ]
  }
  let fields = case valueset_compose_include_filter.extension {
    [] -> fields
    _ -> [
      #(
        "extension",
        json.array(
          valueset_compose_include_filter.extension,
          ct.extension_to_json,
        ),
      ),
      ..fields
    ]
  }
  let fields = case valueset_compose_include_filter.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn valueset_compose_include_filter_decoder() -> Decoder(
  ValuesetComposeIncludeFilter,
) {
  use <- decode.recursive
  use value <- decode.field("value", decode.string)
  use op <- decode.field("op", valueset.filter_operator_decoder())
  use property <- decode.field("property", decode.string)
  use modifier_extension <- decode.optional_field(
    "modifierExtension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(ValuesetComposeIncludeFilter(
    value:,
    op:,
    property:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

pub fn valueset_compose_include_concept_designation_to_json(
  valueset_compose_include_concept_designation: ValuesetComposeIncludeConceptDesignation,
) -> Json {
  let fields = [
    #("value", json.string(valueset_compose_include_concept_designation.value)),
  ]
  let fields = case valueset_compose_include_concept_designation.use_ {
    Some(v) -> [#("use", ct.coding_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case valueset_compose_include_concept_designation.language {
    Some(v) -> [#("language", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case
    valueset_compose_include_concept_designation.modifier_extension
  {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(
          valueset_compose_include_concept_designation.modifier_extension,
          ct.extension_to_json,
        ),
      ),
      ..fields
    ]
  }
  let fields = case valueset_compose_include_concept_designation.extension {
    [] -> fields
    _ -> [
      #(
        "extension",
        json.array(
          valueset_compose_include_concept_designation.extension,
          ct.extension_to_json,
        ),
      ),
      ..fields
    ]
  }
  let fields = case valueset_compose_include_concept_designation.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn valueset_compose_include_concept_designation_decoder() -> Decoder(
  ValuesetComposeIncludeConceptDesignation,
) {
  use <- decode.recursive
  use value <- decode.field("value", decode.string)
  use use_ <- decode.optional_field(
    "use",
    None,
    decode.optional(ct.coding_decoder()),
  )
  use language <- decode.optional_field(
    "language",
    None,
    decode.optional(decode.string),
  )
  use modifier_extension <- decode.optional_field(
    "modifierExtension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(ValuesetComposeIncludeConceptDesignation(
    value:,
    use_:,
    language:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

pub fn valueset_compose_include_concept_to_json(
  valueset_compose_include_concept: ValuesetComposeIncludeConcept,
) -> Json {
  let fields = [
    #("code", json.string(valueset_compose_include_concept.code)),
  ]
  let fields = case valueset_compose_include_concept.designation {
    [] -> fields
    _ -> [
      #(
        "designation",
        json.array(
          valueset_compose_include_concept.designation,
          valueset_compose_include_concept_designation_to_json,
        ),
      ),
      ..fields
    ]
  }
  let fields = case valueset_compose_include_concept.display {
    Some(v) -> [#("display", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case valueset_compose_include_concept.modifier_extension {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(
          valueset_compose_include_concept.modifier_extension,
          ct.extension_to_json,
        ),
      ),
      ..fields
    ]
  }
  let fields = case valueset_compose_include_concept.extension {
    [] -> fields
    _ -> [
      #(
        "extension",
        json.array(
          valueset_compose_include_concept.extension,
          ct.extension_to_json,
        ),
      ),
      ..fields
    ]
  }
  let fields = case valueset_compose_include_concept.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn valueset_compose_include_concept_decoder() -> Decoder(
  ValuesetComposeIncludeConcept,
) {
  use <- decode.recursive
  use designation <- decode.optional_field(
    "designation",
    [],
    decode.list(valueset_compose_include_concept_designation_decoder()),
  )
  use display <- decode.optional_field(
    "display",
    None,
    decode.optional(decode.string),
  )
  use code <- decode.field("code", decode.string)
  use modifier_extension <- decode.optional_field(
    "modifierExtension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(ValuesetComposeIncludeConcept(
    designation:,
    display:,
    code:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

pub fn valueset_compose_include_to_json(
  valueset_compose_include: ValuesetComposeInclude,
) -> Json {
  let fields = []
  let fields = case valueset_compose_include.value_set {
    [] -> fields
    _ -> [
      #("valueSet", json.array(valueset_compose_include.value_set, json.string)),
      ..fields
    ]
  }
  let fields = case valueset_compose_include.filter {
    [] -> fields
    _ -> [
      #(
        "filter",
        json.array(
          valueset_compose_include.filter,
          valueset_compose_include_filter_to_json,
        ),
      ),
      ..fields
    ]
  }
  let fields = case valueset_compose_include.concept {
    [] -> fields
    _ -> [
      #(
        "concept",
        json.array(
          valueset_compose_include.concept,
          valueset_compose_include_concept_to_json,
        ),
      ),
      ..fields
    ]
  }
  let fields = case valueset_compose_include.version {
    Some(v) -> [#("version", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case valueset_compose_include.system {
    Some(v) -> [#("system", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case valueset_compose_include.modifier_extension {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(
          valueset_compose_include.modifier_extension,
          ct.extension_to_json,
        ),
      ),
      ..fields
    ]
  }
  let fields = case valueset_compose_include.extension {
    [] -> fields
    _ -> [
      #(
        "extension",
        json.array(valueset_compose_include.extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case valueset_compose_include.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn valueset_compose_include_decoder() -> Decoder(ValuesetComposeInclude) {
  use <- decode.recursive
  use value_set <- decode.optional_field(
    "valueSet",
    [],
    decode.list(decode.string),
  )
  use filter <- decode.optional_field(
    "filter",
    [],
    decode.list(valueset_compose_include_filter_decoder()),
  )
  use concept <- decode.optional_field(
    "concept",
    [],
    decode.list(valueset_compose_include_concept_decoder()),
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
  use modifier_extension <- decode.optional_field(
    "modifierExtension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(ValuesetComposeInclude(
    value_set:,
    filter:,
    concept:,
    version:,
    system:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

pub fn valueset_compose_to_json(valueset_compose: ValuesetCompose) -> Json {
  let fields = [
    #(
      "include",
      list1_to_json(valueset_compose.include, valueset_compose_include_to_json),
    ),
  ]
  let fields = case valueset_compose.exclude {
    [] -> fields
    _ -> [
      #(
        "exclude",
        json.array(valueset_compose.exclude, valueset_compose_include_to_json),
      ),
      ..fields
    ]
  }
  let fields = case valueset_compose.inactive {
    Some(v) -> [#("inactive", json.bool(v)), ..fields]
    None -> fields
  }
  let fields = case valueset_compose.locked_date {
    Some(v) -> [#("lockedDate", pt.date_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case valueset_compose.modifier_extension {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(valueset_compose.modifier_extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case valueset_compose.extension {
    [] -> fields
    _ -> [
      #(
        "extension",
        json.array(valueset_compose.extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case valueset_compose.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn valueset_compose_decoder() -> Decoder(ValuesetCompose) {
  use <- decode.recursive
  use exclude <- decode.optional_field(
    "exclude",
    [],
    decode.list(valueset_compose_include_decoder()),
  )
  use include <- list1_decoder("include", valueset_compose_include_decoder())
  use inactive <- decode.optional_field(
    "inactive",
    None,
    decode.optional(decode.bool),
  )
  use locked_date <- decode.optional_field(
    "lockedDate",
    None,
    decode.optional(pt.date_decoder()),
  )
  use modifier_extension <- decode.optional_field(
    "modifierExtension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(ValuesetCompose(
    exclude:,
    include:,
    inactive:,
    locked_date:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

pub fn valueset_to_json(valueset: Valueset) -> Json {
  let fields = [
    #("status", valueset.publication_status_to_json(valueset.status)),
  ]
  let fields = case valueset.expansion {
    Some(v) -> [#("expansion", valueset_expansion_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case valueset.compose {
    Some(v) -> [#("compose", valueset_compose_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case valueset.copyright {
    Some(v) -> [#("copyright", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case valueset.purpose {
    Some(v) -> [#("purpose", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case valueset.immutable {
    Some(v) -> [#("immutable", json.bool(v)), ..fields]
    None -> fields
  }
  let fields = case valueset.jurisdiction {
    [] -> fields
    _ -> [
      #(
        "jurisdiction",
        json.array(valueset.jurisdiction, ct.codeableconcept_to_json),
      ),
      ..fields
    ]
  }
  let fields = case valueset.use_context {
    [] -> fields
    _ -> [
      #("useContext", json.array(valueset.use_context, ct.usagecontext_to_json)),
      ..fields
    ]
  }
  let fields = case valueset.description {
    Some(v) -> [#("description", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case valueset.contact {
    [] -> fields
    _ -> [
      #("contact", json.array(valueset.contact, ct.contactdetail_to_json)),
      ..fields
    ]
  }
  let fields = case valueset.publisher {
    Some(v) -> [#("publisher", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case valueset.date {
    Some(v) -> [#("date", pt.datetime_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case valueset.experimental {
    Some(v) -> [#("experimental", json.bool(v)), ..fields]
    None -> fields
  }
  let fields = case valueset.title {
    Some(v) -> [#("title", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case valueset.name {
    Some(v) -> [#("name", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case valueset.version {
    Some(v) -> [#("version", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case valueset.identifier {
    [] -> fields
    _ -> [
      #("identifier", json.array(valueset.identifier, ct.identifier_to_json)),
      ..fields
    ]
  }
  let fields = case valueset.url {
    Some(v) -> [#("url", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case valueset.modifier_extension {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(valueset.modifier_extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case valueset.extension {
    [] -> fields
    _ -> [
      #("extension", json.array(valueset.extension, ct.extension_to_json)),
      ..fields
    ]
  }
  let fields = case valueset.contained {
    [] -> fields
    _ -> [#("contained", json.array(valueset.contained, to_json)), ..fields]
  }
  let fields = case valueset.text {
    Some(v) -> [#("text", ct.narrative_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case valueset.language {
    Some(v) -> [#("language", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case valueset.implicit_rules {
    Some(v) -> [#("implicitRules", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case valueset.meta {
    Some(v) -> [#("meta", ct.meta_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case valueset.id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  let fields = [#("resourceType", json.string("ValueSet")), ..fields]
  json.object(fields)
}

pub fn valueset_decoder() -> Decoder(Valueset) {
  use <- decode.recursive
  use expansion <- decode.optional_field(
    "expansion",
    None,
    decode.optional(valueset_expansion_decoder()),
  )
  use compose <- decode.optional_field(
    "compose",
    None,
    decode.optional(valueset_compose_decoder()),
  )
  use copyright <- decode.optional_field(
    "copyright",
    None,
    decode.optional(decode.string),
  )
  use purpose <- decode.optional_field(
    "purpose",
    None,
    decode.optional(decode.string),
  )
  use immutable <- decode.optional_field(
    "immutable",
    None,
    decode.optional(decode.bool),
  )
  use jurisdiction <- decode.optional_field(
    "jurisdiction",
    [],
    decode.list(ct.codeableconcept_decoder()),
  )
  use use_context <- decode.optional_field(
    "useContext",
    [],
    decode.list(ct.usagecontext_decoder()),
  )
  use description <- decode.optional_field(
    "description",
    None,
    decode.optional(decode.string),
  )
  use contact <- decode.optional_field(
    "contact",
    [],
    decode.list(ct.contactdetail_decoder()),
  )
  use publisher <- decode.optional_field(
    "publisher",
    None,
    decode.optional(decode.string),
  )
  use date <- decode.optional_field(
    "date",
    None,
    decode.optional(pt.datetime_decoder()),
  )
  use experimental <- decode.optional_field(
    "experimental",
    None,
    decode.optional(decode.bool),
  )
  use status <- decode.field("status", valueset.publication_status_decoder())
  use title <- decode.optional_field(
    "title",
    None,
    decode.optional(decode.string),
  )
  use name <- decode.optional_field(
    "name",
    None,
    decode.optional(decode.string),
  )
  use version <- decode.optional_field(
    "version",
    None,
    decode.optional(decode.string),
  )
  use identifier <- decode.optional_field(
    "identifier",
    [],
    decode.list(ct.identifier_decoder()),
  )
  use url <- decode.optional_field("url", None, decode.optional(decode.string))
  use modifier_extension <- decode.optional_field(
    "modifierExtension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use extension <- decode.optional_field(
    "extension",
    [],
    decode.list(ct.extension_decoder()),
  )
  use contained <- decode.optional_field(
    "contained",
    [],
    decode.list(resource_decoder()),
  )
  use text <- decode.optional_field(
    "text",
    None,
    decode.optional(ct.narrative_decoder()),
  )
  use language <- decode.optional_field(
    "language",
    None,
    decode.optional(decode.string),
  )
  use implicit_rules <- decode.optional_field(
    "implicitRules",
    None,
    decode.optional(decode.string),
  )
  use meta <- decode.optional_field(
    "meta",
    None,
    decode.optional(ct.meta_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))

  use resource_type <- decode.field("resourceType", decode.string)
  use <- bool.guard(
    resource_type != "ValueSet",
    decode.failure(valueset_new(status:), "resourceType"),
  )
  decode.success(Valueset(
    expansion:,
    compose:,
    copyright:,
    purpose:,
    immutable:,
    jurisdiction:,
    use_context:,
    description:,
    contact:,
    publisher:,
    date:,
    experimental:,
    status:,
    title:,
    name:,
    version:,
    identifier:,
    url:,
    modifier_extension:,
    extension:,
    contained:,
    text:,
    language:,
    implicit_rules:,
    meta:,
    id:,
  ))
}

pub type ResourceType {
  ResourceTypeBundle
  ResourceTypeCodesystem
  ResourceTypeOperationoutcome
  ResourceTypeParameters
  ResourceTypeValueset
}

pub fn resource_type_to_string(resource_type: ResourceType) -> String {
  case resource_type {
    ResourceTypeBundle -> "Bundle"
    ResourceTypeCodesystem -> "CodeSystem"
    ResourceTypeOperationoutcome -> "OperationOutcome"
    ResourceTypeParameters -> "Parameters"
    ResourceTypeValueset -> "ValueSet"
  }
}

pub type Resource {
  ResourceBundle(Bundle)
  ResourceCodesystem(Codesystem)
  ResourceOperationoutcome(Operationoutcome)
  ResourceParameters(Parameters)
  ResourceValueset(Valueset)
}

pub fn to_json(resource: Resource) -> Json {
  case resource {
    ResourceBundle(resource) -> bundle_to_json(resource)
    ResourceCodesystem(resource) -> codesystem_to_json(resource)
    ResourceOperationoutcome(resource) -> operationoutcome_to_json(resource)
    ResourceParameters(resource) -> parameters_to_json(resource)
    ResourceValueset(resource) -> valueset_to_json(resource)
  }
}

pub fn resource_decoder() -> Decoder(Resource) {
  use tag <- decode.field("resourceType", decode.string)
  case tag {
    "Bundle" -> bundle_decoder() |> decode.map(ResourceBundle)
    "CodeSystem" -> codesystem_decoder() |> decode.map(ResourceCodesystem)
    "OperationOutcome" ->
      operationoutcome_decoder() |> decode.map(ResourceOperationoutcome)
    "Parameters" -> parameters_decoder() |> decode.map(ResourceParameters)
    "ValueSet" -> valueset_decoder() |> decode.map(ResourceValueset)
    _ ->
      decode.failure(ResourceParameters(parameters_new()), expected: "")
      |> decode.map_errors(fn(_errors) {
        [
          decode.DecodeError(
            expected: "one of Account, ActivityDefinition, AdverseEvent, AllergyIntolerance... or any resource name",
            found: tag,
            path: ["resourceType"],
          ),
        ]
      })
  }
  |> decode.map_errors(fn(errors) {
    list.map(errors, fn(error) {
      decode.DecodeError(..error, path: ["(" <> tag <> ")", ..error.path])
    })
  })
}
