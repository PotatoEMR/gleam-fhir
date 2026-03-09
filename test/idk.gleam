import fhir/r4
import gleam/dynamic/decode
import gleam/json.{type Json}
import gleam/option.{type Option, None, Some}
import gleam/list

pub type PrimitiveWithExtension(a) {
  PrimitiveWithExtension(id: Option(String), ext: List(r4.Extension), value: Option(a))
}

pub type PrimitiveExtPart {
  PrimitiveExtPart(id: Option(String), ext: List(r4.Extension))
}


pub fn primitive_ext_part_to_json(p: PrimitiveWithExtension(_)) {
  let PrimitiveWithExtension(id, ext, _) = p
  let fields = []
  let fields = case id {
    Some(v) -> [#("id", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case ext {
    [] -> fields
    _ -> [#("extension", json.array(ext, r4.extension_to_json)), ..fields]
  }
  json.object(fields)
}

pub fn primitives_to_json(old_fields: List(#(String, Json)), field: List(PrimitiveWithExtension(a)), field_to_json: fn(a) -> Json, name: String){
    let vals = list.map(field, fn(primitive){
        json.nullable(primitive.value, field_to_json)
    })
    let exts = list.map(field, fn(primitive){
        case primitive.id, primitive.ext {
            None, [] -> json.null()
            _, _ -> primitive_ext_part_to_json(primitive)
        }
    })
    let old_fields = case list.any(vals, fn(j){j != json.null()}){
        False -> old_fields
        True -> [#(name, json.preprocessed_array(vals)), ..old_fields]
    }
    case list.any(exts, fn(j){j != json.null()}){
        False -> old_fields
        True -> [#("_" <> name, json.preprocessed_array(exts)), ..old_fields]
    }
}


pub fn primitive_ext_part_decoder() {
  use ext <- decode.optional_field(
    "extension",
    [],
    decode.list(r4.extension_decoder()),
  )
  use id <- decode.optional_field("id", None, decode.optional(decode.string))
  decode.success(PrimitiveExtPart(ext:, id:))
}

pub fn primitives_decoder(name: String, thing_decoder){
    use values <- decode.optional_field(name, [], decode.list(decode.optional(thing_decoder())))
    use pwes <- decode.optional_field("_" <> name, [], decode.list(decode.optional(primitive_ext_part_decoder())))
    let together = list.map2(pwes, values, fn(pwe, value){
        let #(id, ext) = case pwe {
            None -> #(None, [])
            Some(pwe) -> #(pwe.id, pwe.ext)
        }
        PrimitiveWithExtension(id:, ext:, value:,)
    })
    decode.success(together)
}
