import fhir/r4/complex_types.{type List1, list1_decoder, list1_to_json} as ct
import fhir/r4/primitive_types.{type DateTime} as pt
import fhir/r4/valuesets
import gleam/bool
import gleam/dynamic/decode.{type Decoder}
import gleam/json.{type Json}
import gleam/option.{type Option, None, Some}

pub type Structuredefinition {
  Structuredefinition(
    id: Option(String),
    meta: Option(ct.Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(ct.Narrative),
    extension: List(ct.Extension),
    modifier_extension: List(ct.Extension),
    url: String,
    identifier: List(ct.Identifier),
    version: Option(String),
    name: String,
    title: Option(String),
    status: valuesets.Publicationstatus,
    experimental: Option(Bool),
    date: Option(DateTime),
    publisher: Option(String),
    contact: List(ct.Contactdetail),
    description: Option(String),
    use_context: List(ct.Usagecontext),
    jurisdiction: List(ct.Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    keyword: List(ct.Coding),
    fhir_version: Option(valuesets.Fhirversion),
    mapping: List(StructuredefinitionMapping),
    kind: valuesets.Structuredefinitionkind,
    abstract: Bool,
    context: List(StructuredefinitionContext),
    context_invariant: List(String),
    type_: String,
    base_definition: Option(String),
    derivation: Option(valuesets.Typederivationrule),
    snapshot: Option(StructuredefinitionSnapshot),
    differential: Option(StructuredefinitionDifferential),
  )
}

pub fn structuredefinition_new(
  type_ type_: String,
  abstract abstract: Bool,
  kind kind: valuesets.Structuredefinitionkind,
  status status: valuesets.Publicationstatus,
  name name: String,
  url url: String,
) -> Structuredefinition {
  Structuredefinition(
    differential: None,
    snapshot: None,
    derivation: None,
    base_definition: None,
    type_:,
    context_invariant: [],
    context: [],
    abstract:,
    kind:,
    mapping: [],
    fhir_version: None,
    keyword: [],
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
    name:,
    version: None,
    identifier: [],
    url:,
    modifier_extension: [],
    extension: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/StructureDefinition#resource](http://hl7.org/fhir/r4/StructureDefinition/StructureDefinition#resource)
pub type StructuredefinitionMapping {
  StructuredefinitionMapping(
    id: Option(String),
    extension: List(ct.Extension),
    modifier_extension: List(ct.Extension),
    identity: String,
    uri: Option(String),
    name: Option(String),
    comment: Option(String),
  )
}

pub fn structuredefinition_mapping_new(
  identity identity: String,
) -> StructuredefinitionMapping {
  StructuredefinitionMapping(
    comment: None,
    name: None,
    uri: None,
    identity:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/StructureDefinition#resource](http://hl7.org/fhir/r4/StructureDefinition/StructureDefinition#resource)
pub type StructuredefinitionContext {
  StructuredefinitionContext(
    id: Option(String),
    extension: List(ct.Extension),
    modifier_extension: List(ct.Extension),
    type_: valuesets.Extensioncontexttype,
    expression: String,
  )
}

pub fn structuredefinition_context_new(
  expression expression: String,
  type_ type_: valuesets.Extensioncontexttype,
) -> StructuredefinitionContext {
  StructuredefinitionContext(
    expression:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/StructureDefinition#resource](http://hl7.org/fhir/r4/StructureDefinition/StructureDefinition#resource)
pub type StructuredefinitionSnapshot {
  StructuredefinitionSnapshot(
    id: Option(String),
    extension: List(ct.Extension),
    modifier_extension: List(ct.Extension),
    element: List1(ct.Elementdefinition),
  )
}

pub fn structuredefinition_snapshot_new(
  element element: List1(ct.Elementdefinition),
) -> StructuredefinitionSnapshot {
  StructuredefinitionSnapshot(
    element:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///[http://hl7.org/fhir/r4/StructureDefinition/StructureDefinition#resource](http://hl7.org/fhir/r4/StructureDefinition/StructureDefinition#resource)
pub type StructuredefinitionDifferential {
  StructuredefinitionDifferential(
    id: Option(String),
    extension: List(ct.Extension),
    modifier_extension: List(ct.Extension),
    element: List1(ct.Elementdefinition),
  )
}

pub fn structuredefinition_differential_new(
  element element: List1(ct.Elementdefinition),
) -> StructuredefinitionDifferential {
  StructuredefinitionDifferential(
    element:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

pub fn structuredefinition_differential_to_json(
  structuredefinition_differential: StructuredefinitionDifferential,
) -> Json {
  let StructuredefinitionDifferential(
    element:,
    modifier_extension:,
    extension:,
    id:,
  ) = structuredefinition_differential
  let fields = [
    #("element", list1_to_json(element, ct.elementdefinition_to_json)),
  ]
  let fields = case modifier_extension {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(modifier_extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, ct.extension_to_json)), ..fields]
  }
  let fields = case id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn structuredefinition_differential_decoder() -> Decoder(
  StructuredefinitionDifferential,
) {
  use <- decode.recursive
  use element <- list1_decoder("element", ct.elementdefinition_decoder())
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
  decode.success(StructuredefinitionDifferential(
    element:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

pub fn structuredefinition_snapshot_to_json(
  structuredefinition_snapshot: StructuredefinitionSnapshot,
) -> Json {
  let StructuredefinitionSnapshot(
    element:,
    modifier_extension:,
    extension:,
    id:,
  ) = structuredefinition_snapshot
  let fields = [
    #("element", list1_to_json(element, ct.elementdefinition_to_json)),
  ]
  let fields = case modifier_extension {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(modifier_extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, ct.extension_to_json)), ..fields]
  }
  let fields = case id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn structuredefinition_snapshot_decoder() -> Decoder(
  StructuredefinitionSnapshot,
) {
  use <- decode.recursive
  use element <- list1_decoder("element", ct.elementdefinition_decoder())
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
  decode.success(StructuredefinitionSnapshot(
    element:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

pub fn structuredefinition_context_to_json(
  structuredefinition_context: StructuredefinitionContext,
) -> Json {
  let StructuredefinitionContext(
    expression:,
    type_:,
    modifier_extension:,
    extension:,
    id:,
  ) = structuredefinition_context
  let fields = [
    #("expression", json.string(expression)),
    #("type", valuesets.extensioncontexttype_to_json(type_)),
  ]
  let fields = case modifier_extension {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(modifier_extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, ct.extension_to_json)), ..fields]
  }
  let fields = case id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn structuredefinition_context_decoder() -> Decoder(
  StructuredefinitionContext,
) {
  use <- decode.recursive
  use expression <- decode.field("expression", decode.string)
  use type_ <- decode.field("type", valuesets.extensioncontexttype_decoder())
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
  decode.success(StructuredefinitionContext(
    expression:,
    type_:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

pub fn structuredefinition_mapping_to_json(
  structuredefinition_mapping: StructuredefinitionMapping,
) -> Json {
  let StructuredefinitionMapping(
    comment:,
    name:,
    uri:,
    identity:,
    modifier_extension:,
    extension:,
    id:,
  ) = structuredefinition_mapping
  let fields = [
    #("identity", json.string(identity)),
  ]
  let fields = case comment {
    Some(v) -> [#("comment", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case name {
    Some(v) -> [#("name", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case uri {
    Some(v) -> [#("uri", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case modifier_extension {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(modifier_extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, ct.extension_to_json)), ..fields]
  }
  let fields = case id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn structuredefinition_mapping_decoder() -> Decoder(
  StructuredefinitionMapping,
) {
  use <- decode.recursive
  use comment <- decode.optional_field(
    "comment",
    None,
    decode.optional(decode.string),
  )
  use name <- decode.optional_field(
    "name",
    None,
    decode.optional(decode.string),
  )
  use uri <- decode.optional_field("uri", None, decode.optional(decode.string))
  use identity <- decode.field("identity", decode.string)
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
  decode.success(StructuredefinitionMapping(
    comment:,
    name:,
    uri:,
    identity:,
    modifier_extension:,
    extension:,
    id:,
  ))
}

pub fn structuredefinition_to_json(
  structuredefinition: Structuredefinition,
) -> Json {
  let Structuredefinition(
    differential:,
    snapshot:,
    derivation:,
    base_definition:,
    type_:,
    context_invariant:,
    context:,
    abstract:,
    kind:,
    mapping:,
    fhir_version:,
    keyword:,
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
    text:,
    language:,
    implicit_rules:,
    meta:,
    id:,
  ) = structuredefinition
  let fields = [
    #("type", json.string(type_)),
    #("abstract", json.bool(abstract)),
    #("kind", valuesets.structuredefinitionkind_to_json(kind)),
    #("status", valuesets.publicationstatus_to_json(status)),
    #("name", json.string(name)),
    #("url", json.string(url)),
  ]
  let fields = case differential {
    Some(v) -> [
      #("differential", structuredefinition_differential_to_json(v)),
      ..fields
    ]
    None -> fields
  }
  let fields = case snapshot {
    Some(v) -> [
      #("snapshot", structuredefinition_snapshot_to_json(v)),
      ..fields
    ]
    None -> fields
  }
  let fields = case derivation {
    Some(v) -> [
      #("derivation", valuesets.typederivationrule_to_json(v)),
      ..fields
    ]
    None -> fields
  }
  let fields = case base_definition {
    Some(v) -> [#("baseDefinition", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case context_invariant {
    [] -> fields
    _ -> [
      #("contextInvariant", json.array(context_invariant, json.string)),
      ..fields
    ]
  }
  let fields = case context {
    [] -> fields
    _ -> [
      #("context", json.array(context, structuredefinition_context_to_json)),
      ..fields
    ]
  }
  let fields = case mapping {
    [] -> fields
    _ -> [
      #("mapping", json.array(mapping, structuredefinition_mapping_to_json)),
      ..fields
    ]
  }
  let fields = case fhir_version {
    Some(v) -> [#("fhirVersion", valuesets.fhirversion_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case keyword {
    [] -> fields
    _ -> [#("keyword", json.array(keyword, ct.coding_to_json)), ..fields]
  }
  let fields = case copyright {
    Some(v) -> [#("copyright", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case purpose {
    Some(v) -> [#("purpose", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case jurisdiction {
    [] -> fields
    _ -> [
      #("jurisdiction", json.array(jurisdiction, ct.codeableconcept_to_json)),
      ..fields
    ]
  }
  let fields = case use_context {
    [] -> fields
    _ -> [
      #("useContext", json.array(use_context, ct.usagecontext_to_json)),
      ..fields
    ]
  }
  let fields = case description {
    Some(v) -> [#("description", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case contact {
    [] -> fields
    _ -> [#("contact", json.array(contact, ct.contactdetail_to_json)), ..fields]
  }
  let fields = case publisher {
    Some(v) -> [#("publisher", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case date {
    Some(v) -> [#("date", pt.datetime_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case experimental {
    Some(v) -> [#("experimental", json.bool(v)), ..fields]
    None -> fields
  }
  let fields = case title {
    Some(v) -> [#("title", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case version {
    Some(v) -> [#("version", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case identifier {
    [] -> fields
    _ -> [
      #("identifier", json.array(identifier, ct.identifier_to_json)),
      ..fields
    ]
  }
  let fields = case modifier_extension {
    [] -> fields
    _ -> [
      #(
        "modifierExtension",
        json.array(modifier_extension, ct.extension_to_json),
      ),
      ..fields
    ]
  }
  let fields = case extension {
    [] -> fields
    _ -> [#("extension", json.array(extension, ct.extension_to_json)), ..fields]
  }
  let fields = case text {
    Some(v) -> [#("text", ct.narrative_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case language {
    Some(v) -> [#("language", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case implicit_rules {
    Some(v) -> [#("implicitRules", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case meta {
    Some(v) -> [#("meta", ct.meta_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  let fields = [#("resourceType", json.string("StructureDefinition")), ..fields]
  json.object(fields)
}

pub fn structuredefinition_decoder() -> Decoder(Structuredefinition) {
  use <- decode.recursive
  use differential <- decode.optional_field(
    "differential",
    None,
    decode.optional(structuredefinition_differential_decoder()),
  )
  use snapshot <- decode.optional_field(
    "snapshot",
    None,
    decode.optional(structuredefinition_snapshot_decoder()),
  )
  use derivation <- decode.optional_field(
    "derivation",
    None,
    decode.optional(valuesets.typederivationrule_decoder()),
  )
  use base_definition <- decode.optional_field(
    "baseDefinition",
    None,
    decode.optional(decode.string),
  )
  use type_ <- decode.field("type", decode.string)
  use context_invariant <- decode.optional_field(
    "contextInvariant",
    [],
    decode.list(decode.string),
  )
  use context <- decode.optional_field(
    "context",
    [],
    decode.list(structuredefinition_context_decoder()),
  )
  use abstract <- decode.field("abstract", decode.bool)
  use kind <- decode.field("kind", valuesets.structuredefinitionkind_decoder())
  use mapping <- decode.optional_field(
    "mapping",
    [],
    decode.list(structuredefinition_mapping_decoder()),
  )
  use fhir_version <- decode.optional_field(
    "fhirVersion",
    None,
    decode.optional(valuesets.fhirversion_decoder()),
  )
  use keyword <- decode.optional_field(
    "keyword",
    [],
    decode.list(ct.coding_decoder()),
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
  use status <- decode.field("status", valuesets.publicationstatus_decoder())
  use title <- decode.optional_field(
    "title",
    None,
    decode.optional(decode.string),
  )
  use name <- decode.field("name", decode.string)
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
  use url <- decode.field("url", decode.string)
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

  use rt <- decode.field("resourceType", decode.string)
  use <- bool.guard(
    rt != "StructureDefinition",
    decode.failure(
      structuredefinition_new(type_:, abstract:, kind:, status:, name:, url:),
      "resourceType",
    ),
  )
  decode.success(Structuredefinition(
    differential:,
    snapshot:,
    derivation:,
    base_definition:,
    type_:,
    context_invariant:,
    context:,
    abstract:,
    kind:,
    mapping:,
    fhir_version:,
    keyword:,
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
    text:,
    language:,
    implicit_rules:,
    meta:,
    id:,
  ))
}
