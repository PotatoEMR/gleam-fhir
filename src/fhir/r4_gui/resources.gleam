import fhir/r4_gui/complex_types.{type List1, list1_decoder, list1_to_json} as ct
import gleam/bool
import gleam/dynamic/decode.{type Decoder}
import gleam/json.{type Json}
import gleam/option.{type Option, None, Some}

pub type Structuredefinition {
  Structuredefinition(
    id: Option(String),
    name: String,
    snapshot: Option(StructuredefinitionSnapshot),
  )
}

pub fn structuredefinition_new(name name: String) -> Structuredefinition {
  Structuredefinition(snapshot: None, name:, id: None)
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

pub fn structuredefinition_to_json(
  structuredefinition: Structuredefinition,
) -> Json {
  let Structuredefinition(snapshot:, name:, id:) = structuredefinition
  let fields = [
    #("name", json.string(name)),
  ]
  let fields = case snapshot {
    Some(v) -> [
      #("snapshot", structuredefinition_snapshot_to_json(v)),
      ..fields
    ]
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
  use snapshot <- decode.optional_field(
    "snapshot",
    None,
    decode.optional(structuredefinition_snapshot_decoder()),
  )
  use name <- decode.field("name", decode.string)
  use id <- decode.optional_field("id", None, decode.optional(decode.string))

  use rt <- decode.field("resourceType", decode.string)
  use <- bool.guard(
    rt != "StructureDefinition",
    decode.failure(structuredefinition_new(name:), "resourceType"),
  )
  decode.success(Structuredefinition(snapshot:, name:, id:))
}
