import codegen_helpers
import gleam/json
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/set.{type Set}
import gleam/string

pub fn bound_coding_and_cc(
  preserve_slice_order: Bool,
  required: Set(String),
  variant: Option(#(String, List(String), List(String))),
) -> String {
  let coding = case set.contains(required, "BoundCoding") || variant != None {
    False -> ""
    True -> {
      let #(name, required_fields, omitted) =
        option.unwrap(variant, #("BoundCoding", [], []))

      let function = codegen_helpers.to_snake_case(name)
      let fields =
        [
          #("id", "id", "String", "decode.string", "json.string", "\"\""),
          #(
            "extension",
            "extension",
            "List(Extension)",
            "decode.list(extension_decoder())",
            "fn(values) { json.array(values, extension_to_json) }",
            "[]",
          ),
          #(
            "version",
            "version",
            "String",
            "decode.string",
            "json.string",
            "\"\"",
          ),
          #(
            "display",
            "display",
            "String",
            "decode.string",
            "json.string",
            "\"\"",
          ),
          #(
            "user_selected",
            "userSelected",
            "Bool",
            "decode.bool",
            "json.bool",
            "False",
          ),
        ]
        |> list.filter(fn(field) { !list.contains(omitted, field.0) })
      let #(
        declarations,
        arguments,
        defaults,
        bindings,
        values,
        json_fields,
        fallback,
      ) =
        list.fold(fields, #("", "", "", "", "", "", ""), fn(acc, field) {
          let #(
            declarations,
            arguments,
            defaults,
            bindings,
            values,
            json_fields,
            fallback,
          ) = acc
          let #(field, json_name, type_, decoder, encoder, default) = field
          let required = list.contains(required_fields, field)
          let repeated = field == "extension"
          let optional = !required && !repeated
          #(
            declarations
              <> field
              <> ": "
              <> case optional {
              True -> "Option(" <> type_ <> ")"
              False -> type_
            }
              <> ",",
            arguments
              <> case required {
              True -> field <> " " <> field <> ": " <> type_ <> ","
              False -> ""
            },
            defaults
              <> field
              <> ": "
              <> case required {
              True -> field
              False if repeated -> "[]"
              False -> "None"
            }
              <> ",",
            bindings
              <> "use "
              <> field
              <> " <- "
              <> case required {
              True -> "decode.field(\"" <> json_name <> "\", " <> decoder <> ")"
              False ->
                "decode.optional_field(\""
                <> json_name
                <> "\", "
                <> case repeated {
                  True -> "[]"
                  False -> "None"
                }
                <> ", "
                <> case optional {
                  True -> "decode.optional(" <> decoder <> ")"
                  False -> decoder
                }
                <> ")"
            }
              <> "\n",
            values <> field <> ":,",
            json_fields
              <> "let fields = "
              <> case required {
              True ->
                "[#(\""
                <> json_name
                <> "\", "
                <> encoder
                <> "(coding."
                <> field
                <> ")), ..fields]"
              False if repeated ->
                "case coding."
                <> field
                <> " { [] -> fields values -> [#(\""
                <> json_name
                <> "\", "
                <> "json.array(values, extension_to_json)), ..fields] }"
              False ->
                "case coding."
                <> field
                <> " { None -> fields Some(value) -> [#(\""
                <> json_name
                <> "\", "
                <> encoder
                <> "(value)), ..fields] }"
            }
              <> "\n",
            fallback
              <> case required {
              True -> ", " <> field <> ": " <> default
              False -> ""
            },
          )
        })
      "pub type "
      <> name
      <> "(required_binding) { "
      <> name
      <> "(code: required_binding,"
      <> declarations
      <> ") }\n"
      <> "pub fn "
      <> function
      <> "_new(code code: required_binding,"
      <> arguments
      <> ") -> "
      <> name
      <> "(required_binding) { "
      <> name
      <> "(code:,"
      <> defaults
      <> ") }\n"
      <> case
        variant != None || set.contains(required, "bound_coding_decoder")
      {
        False -> ""
        True ->
          "pub fn "
          <> function
          <> "_decoder(from_code_and_system: fn(String, String) -> Result(required_binding, Nil), failure_placeholder: required_binding) -> Decoder("
          <> name
          <> "(required_binding)) {\n"
          <> "use <- decode.recursive\nuse code <- decode.field(\"code\", decode.string)\nuse system <- decode.field(\"system\", decode.string)\n"
          <> "case from_code_and_system(code, system) { Error(_) -> decode.failure("
          <> function
          <> "_new(code: failure_placeholder"
          <> fallback
          <> "), \"need code + system from required ValueSet\") Ok(code) -> "
          <> function
          <> "_slice_decoder(code) }\n}\n"
          <> "pub fn "
          <> function
          <> "_slice_decoder(code: required_binding) -> Decoder("
          <> name
          <> "(required_binding)) {\nuse <- decode.recursive\n"
          <> bindings
          <> "decode.success("
          <> name
          <> "(code:,"
          <> values
          <> "))\n}\n"
      }
      <> "pub fn "
      <> function
      <> "_to_json(coding: "
      <> name
      <> "(required_binding), get_code: fn(required_binding) -> String, get_system: fn(required_binding) -> String) -> Json {\n"
      <> "let fields = [#(\"code\", json.string(get_code(coding.code))), #(\"system\", json.string(get_system(coding.code)))]\n"
      <> json_fields
      <> "json.object(fields)\n}\n"
    }
  }

  let concept = case set.contains(required, "BoundCodeableconcept") {
    True ->
      string.concat([
        "
      pub type BoundCodeableconcept(required_binding) {
        BoundCodeableconcept(
          id: Option(String),
          extension: List(Extension),
",
        case preserve_slice_order {
          True ->
            "          internal_gleam_fhir_index: Option(Int),
"
          False -> ""
        },
        "          required: BoundCoding(required_binding),
          more: List(Coding),
          text: Option(String),
        )
      }

      pub fn bound_codeableconcept_new(code: required_binding) -> BoundCodeableconcept(required_binding) {
        let required = bound_coding_new(code)
",
        case preserve_slice_order {
          True ->
            "        BoundCodeableconcept(internal_gleam_fhir_index: None, text: None, required:, more: [], extension: [], id: None)
"
          False ->
            "        BoundCodeableconcept(text: None, required:, more: [], extension: [], id: None)
"
        },
        "      }

",
        "      pub fn bound_codeableconcept_to_json(codeableconcept: BoundCodeableconcept(required_binding),  get_code: fn(required_binding) -> String,  get_system: fn(required_binding) -> String, ) -> Json {
      let required_coding = bound_coding_to_json(codeableconcept.required, get_code, get_system)
      let other_codings = list.map(codeableconcept.more, coding_to_json)
",
        case preserve_slice_order {
          True ->
            "      let codings = case codeableconcept.internal_gleam_fhir_index {
        None -> [required_coding, ..other_codings]
        Some(index) -> insert_at(required_coding, other_codings, index)
      }
      let all_codings = json.preprocessed_array(codings)
"
          False ->
            "      let all_codings = json.preprocessed_array([required_coding, ..other_codings])
"
        },
        "      let fields = [#(\"coding\", all_codings)]
        let fields = case codeableconcept.text {
          Some(v) -> [#(\"text\", json.string(v)), ..fields]
          None -> fields
        }
        let fields = case codeableconcept.extension {
          [] -> fields
          _ -> [#(\"extension\", json.array(codeableconcept.extension, extension_to_json)), ..fields]
        }
        let fields = case codeableconcept.id {
          Some(v) -> [#(\"id\", json.string(v)), ..fields]
          None -> fields
        }
        json.object(fields)
      }

      type ParsedBoundCoding(binding) {
        CodingInBinding(BoundCoding(binding), code: String, system: String)
        CodingOutsideBinding(Coding)
      }

      pub fn bound_codeableconcept_discriminator(from_code_and_system: fn(String, String) -> Result(required_binding, Nil)) -> Decoder(#(Option(#(BoundCoding(required_binding), Int)), List(Coding))) {
        use codings <- decode.optional_field(\"coding\", [], decode.list({
          use code <- decode.optional_field(\"code\", None, decode.optional(decode.string))
          use system <- decode.optional_field(\"system\", None, decode.optional(decode.string))
          use id <- decode.optional_field(\"id\", None, decode.optional(decode.string))
          use extension <- decode.optional_field(\"extension\", [], decode.list(extension_decoder()))
          use version <- decode.optional_field(\"version\", None, decode.optional(decode.string))
          use display <- decode.optional_field(\"display\", None, decode.optional(decode.string))
          use user_selected <- decode.optional_field(\"userSelected\", None, decode.optional(decode.bool))
          let binding = case code, system {
            Some(code), Some(system) -> from_code_and_system(code, system)
            _, _ -> Error(Nil)
          }
          case binding, code, system {
            Ok(binding), Some(code), Some(system) ->
              decode.success(CodingInBinding(BoundCoding(code: binding, id:, extension:, version:, display:, user_selected:), code:, system:))
            _, _, _ ->
              decode.success(CodingOutsideBinding(Coding(code:, system:, id:, extension:, version:, display:, user_selected:)))
          }
        }))
        let #(required, more) = list.index_fold(codings, #(None, []), fn(acc, coding, index) {
          let #(required, more) = acc
          case coding, required {
            CodingInBinding(value, _, _), None -> #(Some(#(value, index)), more)
            CodingInBinding(value, code, system), Some(_) ->
              #(required, [Coding(code: Some(code), system: Some(system), id: value.id, extension: value.extension, version: value.version, display: value.display, user_selected: value.user_selected), ..more])
            CodingOutsideBinding(value), _ -> #(required, [value, ..more])
          }
        })
        decode.success(#(required, list.reverse(more)))
      }

      pub fn bound_codeableconcept_decoder(binding_from_code_and_system: fn(String, String) -> Result(required_binding, Nil), failure_placeholder: required_binding) -> Decoder(BoundCodeableconcept(required_binding)) {
        use <- decode.recursive
        use matched <- decode.then(bound_codeableconcept_discriminator(binding_from_code_and_system))
        case matched {
          #(None, _) -> decode.failure(bound_codeableconcept_new(failure_placeholder), \"need a coding with code + system from required ValueSet\")
          #(Some(#(required, index)), more) -> bound_codeableconcept_slice_decoder(required, index, more)
        }
      }

      pub fn bound_codeableconcept_slice_decoder(required: BoundCoding(required_binding), ",
        case preserve_slice_order {
          True -> "index"
          False -> "_index"
        },
        ": Int, more: List(Coding)) -> Decoder(BoundCodeableconcept(required_binding)) {
        use <- decode.recursive
",
        "          use text <- decode.optional_field(
            \"text\",
            None,
            decode.optional(decode.string),
          )
          use extension <- decode.optional_field(
            \"extension\",
            [],
            decode.list(extension_decoder()),
          )
          use id <- decode.optional_field(\"id\", None, decode.optional(decode.string))
",
        case preserve_slice_order {
          True ->
            "          decode.success(BoundCodeableconcept(internal_gleam_fhir_index: Some(index), text:, required:, more:, extension:, id:))
"
          False ->
            "          decode.success(BoundCodeableconcept(text:, required:, more:, extension:, id:))
"
        },
        "      }\n\n",
      ])
    False -> ""
  }
  coding <> concept
}

pub const bound_codeable_reference =
  "      pub type BoundCodeablereference(required_binding) {
  BoundCodeablereference(
    id: Option(String),
    extension: List(Extension),
    concept: Option(BoundCodeableconcept(required_binding)),
    reference: Option(Reference),
  )
}

pub fn bound_codeablereference_new() -> BoundCodeablereference(required_binding) {
  BoundCodeablereference(reference: None, concept: None, extension: [], id: None)
}

pub fn bound_codeablereference_to_json(codeablereference: BoundCodeablereference(required_binding),  get_code: fn(required_binding) -> String,  get_system: fn(required_binding) -> String, ) -> Json {
  let fields = []
  let fields = case codeablereference.reference {
    Some(v) -> [#(\"reference\", reference_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case codeablereference.concept {
    Some(v) -> [#(\"concept\", bound_codeableconcept_to_json(v, get_code, get_system)), ..fields]
    None -> fields
  }
  let fields = case codeablereference.extension {
    [] -> fields
    _ -> [#(\"extension\", json.array(codeablereference.extension, extension_to_json)), ..fields]
  }
  let fields = case codeablereference.id {
    Some(v) -> [#(\"id\", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn bound_codeablereference_decoder(binding_from_code_and_system: fn(String, String) -> Result(required_binding, Nil), failure_placeholder: required_binding) -> Decoder(BoundCodeablereference(required_binding)) {
  use <- decode.recursive
  use reference <- decode.optional_field(
    \"reference\",
    None,
    decode.optional(reference_decoder()),
  )
  use concept <- decode.optional_field(
    \"concept\",
    None,
    decode.optional(bound_codeableconcept_decoder(binding_from_code_and_system, failure_placeholder)),
  )
  use extension <- decode.optional_field(
    \"extension\",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field(\"id\", None, decode.optional(decode.string))
  decode.success(BoundCodeablereference(reference:, concept:, extension:, id:))
}"

// https://chat.fhir.org/#narrow/channel/179252-IG-creation/topic/Unexpected.20error.20when.20Quantity.2Ecomparator.20missing
// Cardinality is orthogonal to binding. The binding applies if the element is present. If there's no element, then there's no "concept in this element" for the SHALL to apply to :slight_smile:
// In the special case of Quantity, the binding is actually to the implicit 'Coding' that is built into the Quantity. That implicit Coding is only considered to be 'present' if either the 'code' or 'system' are there. So it's totally legal to have a Quantity with just a value or a value + unit. (Not best practice, but legal.)

pub const bound_quantity =
  "pub type BoundQuantity(required_binding) {
  BoundQuantity(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(valuesets.Quantitycomparator),
    unit: Option(String),
    code: Option(required_binding)
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

pub fn bound_quantity_to_json(quantity: BoundQuantity(required_binding), get_code: fn(required_binding) -> String,  get_system: fn(required_binding) -> String, ) -> Json {
    let fields = case quantity.code {
      Some(bound_code) -> [
         #(\"code\", json.string(get_code(bound_code))),
         #(\"system\", json.string(get_system(bound_code))),
      ]
      None -> []
    }
  let fields = case quantity.unit {
    Some(v) -> [#(\"unit\", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case quantity.comparator {
    Some(v) -> [
      #(\"comparator\", valuesets.quantitycomparator_to_json(v)),
      ..fields
    ]
    None -> fields
  }
  let fields = case quantity.value {
    Some(v) -> [#(\"value\", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case quantity.extension {
    [] -> fields
    _ -> [#(\"extension\", json.array(quantity.extension, extension_to_json)), ..fields]
  }
  let fields = case quantity.id {
    Some(v) -> [#(\"id\", json.string(v)), ..fields]
    None -> fields
  }
  json.object(fields)
}

pub fn bound_quantity_decoder(binding_from_code_and_system: fn(String, String) -> Result(required_binding, Nil)) -> Decoder(BoundQuantity(required_binding)) {
  use <- decode.recursive
  use code <- decode.optional_field(
    \"code\",
    None,
    decode.optional(decode.string),
  )
  use system <- decode.optional_field(
    \"system\",
    None,
    decode.optional(decode.string),
  )
  case code, system {
    None, None -> bound_quantity_decode_rest(None)
    Some(code), Some(system) -> case binding_from_code_and_system(code, system) {
        Error(_) -> decode.failure(bound_quantity_new(), \"need code + system from required ValueSet\")
        Ok(binding) -> bound_quantity_decode_rest(Some(binding))
      }
    _, _ -> decode.failure(bound_quantity_new(), \"need code + system from required ValueSet\")
  }
}

fn bound_quantity_decode_rest(with_binding: Option(required_binding)) -> Decoder(BoundQuantity(required_binding)) {
  use unit <- decode.optional_field(
    \"unit\",
    None,
    decode.optional(decode.string),
  )
  use comparator <- decode.optional_field(
    \"comparator\",
    None,
    decode.optional(valuesets.quantitycomparator_decoder()),
  )
  use value <- decode.optional_field(
    \"value\",
    None,
    decode.optional(decode_number()),
  )
  use extension <- decode.optional_field(
    \"extension\",
    [],
    decode.list(extension_decoder()),
  )
  use id <- decode.optional_field(\"id\", None, decode.optional(decode.string))
  decode.success(BoundQuantity(
    code: with_binding,
    unit:,
    comparator:,
    value:,
    extension:,
    id:,
  ))
}
"

// need to keep track of system because some valuesets contain multiple systems
// but we flatten valuesets to flat list of codes
// so need to get system from code or create valueset item from system and code
pub type ValuesetCodeWithSystem {
  ValuesetCodeWithSystem(code: String, system: String, variant: String)
}

// pub type OpenValuesetVariant {
//   OpenValuesetVariant(name: String, system: String)
// }
//
pub fn bound_valueset_function_name(gleam_type: String) -> Option(String) {
  case string.split(gleam_type, "(valuesets.") {
    [_, valueset] ->
      Some(valueset |> string.drop_end(1) |> codegen_helpers.to_snake_case)
    _ -> None
  }
}

pub fn bound_codeableconcept_encoder_source(
  prefix: String,
  valueset: String,
) -> String {
  "fn(codeableconcept) { "
  <> bound_codeableconcept_encoder_call_source(
    prefix,
    valueset,
    "codeableconcept",
  )
  <> " }"
}

pub fn bound_codeableconcept_encoder_call_source(
  prefix: String,
  valueset: String,
  value: String,
) -> String {
  prefix
  <> "bound_codeableconcept_to_json("
  <> value
  <> ", valuesets."
  <> valueset
  <> "_to_code, valuesets."
  <> valueset
  <> "_system)"
}

pub fn bound_codeablereference_encoder_source(
  prefix: String,
  valueset: String,
) -> String {
  "fn(codeablereference) { "
  <> bound_codeablereference_encoder_call_source(
    prefix,
    valueset,
    "codeablereference",
  )
  <> " }"
}

pub fn bound_codeablereference_encoder_call_source(
  prefix: String,
  valueset: String,
  value: String,
) -> String {
  prefix
  <> "bound_codeablereference_to_json("
  <> value
  <> ", valuesets."
  <> valueset
  <> "_to_code, valuesets."
  <> valueset
  <> "_system)"
}

pub fn bound_quantity_encoder_source(
  prefix: String,
  valueset: String,
) -> String {
  "fn(quantity) { "
  <> bound_quantity_encoder_call_source(prefix, valueset, "quantity")
  <> " }"
}

pub fn bound_quantity_encoder_call_source(
  prefix: String,
  valueset: String,
  value: String,
) -> String {
  prefix
  <> "bound_quantity_to_json("
  <> value
  <> ", valuesets."
  <> valueset
  <> "_to_code, valuesets."
  <> valueset
  <> "_system)"
}

pub fn bound_codeableconcept_decoder_source(
  prefix: String,
  valueset: String,
) -> String {
  prefix
  <> "bound_codeableconcept_decoder(valuesets."
  <> valueset
  <> "_from_code_and_system, valuesets."
  <> valueset
  <> "_failure_variant)"
}

pub fn bound_codeablereference_decoder_source(
  prefix: String,
  valueset: String,
) -> String {
  prefix
  <> "bound_codeablereference_decoder(valuesets."
  <> valueset
  <> "_from_code_and_system, valuesets."
  <> valueset
  <> "_failure_variant)"
}

pub fn bound_quantity_decoder_source(
  prefix: String,
  valueset: String,
) -> String {
  prefix
  <> "bound_quantity_decoder(valuesets."
  <> valueset
  <> "_from_code_and_system)"
}

//
//   <> list.fold(open_variants, "", fn(acc, open_variant) {
//     let OpenValuesetVariant(name:, system:) = open_variant
//     acc <> name <> "(value: _) -> \"" <> system <> "\"\n"
//   })
//
//     <> list.fold(open_variants, "", fn(acc, open_variant) {
//       let OpenValuesetVariant(name:, system:) = open_variant
//       acc <> "code, \"" <> system <> "\" -> Ok(" <> name <> "(code))\n"
//     })
pub fn gen_valueset_from_code_and_system(
  vsname: String,
  vs_codes: List(ValuesetCodeWithSystem),
  with_type: Bool,
) -> String {
  let vsname_lower = string.lowercase(vsname)
  let template =
    "pub fn "
    <> vsname_lower
    <> "_from_code_and_system(code code: String, system system: String) -> Result("
    <> case with_type {
      True -> vsname
      False -> "Nil"
    }
    <> ", Nil) {
    case code, system {"
    <> list.fold(
      from: "",
      over: vs_codes,
      with: fn(acc: String, member: ValuesetCodeWithSystem) {
        let ValuesetCodeWithSystem(code:, system:, variant:) = member
        acc
        <> json.to_string(json.string(code))
        <> ", "
        <> json.to_string(json.string(system))
        <> " -> Ok("
        <> case with_type {
          True -> vsname <> variant
          False -> "Nil"
        }
        <> ")\n"
      },
    )
    <> "_, _ -> Error(Nil)}
  }
  "
  template
}

pub fn gen_valueset_system(
  vsname: String,
  vs_codes: List(ValuesetCodeWithSystem),
  systems: Set(String),
) -> String {
  let vsname_lower = string.lowercase(vsname)
  case set.to_list(systems) {
    [system] ->
      "pub fn "
      <> vsname_lower
      <> "_system(_"
      <> vsname_lower
      <> ": "
      <> vsname
      <> ") -> String {\n  "
      <> json.to_string(json.string(system))
      <> "\n}\n"
    _ -> gen_multisystem_valueset_system(vsname, vsname_lower, vs_codes)
  }
}

pub fn gen_multisystem_valueset_system(
  vsname: String,
  vsname_lower: String,
  vs_codes: List(ValuesetCodeWithSystem),
) -> String {
  let expanded_system_arms =
    list.fold(vs_codes, "", fn(acc, member) {
      let ValuesetCodeWithSystem(system:, variant:, ..) = member
      acc
      <> vsname
      <> variant
      <> " -> "
      <> json.to_string(json.string(system))
      <> "\n"
    })
  "pub fn "
  <> vsname_lower
  <> "_system("
  <> vsname_lower
  <> ": "
  <> vsname
  <> ") -> String {\n  case "
  <> vsname_lower
  <> " {"
  <> expanded_system_arms
  <> "}\n}\n"
}

pub fn valueset_failure_variant_source(
  vsname: String,
  vs_codes: List(ValuesetCodeWithSystem),
) -> String {
  case vs_codes {
    [ValuesetCodeWithSystem(variant:, ..), ..] -> vsname <> variant
    // [], [OpenValuesetVariant(name:, ..), ..] -> name <> "(\"\")"
    [] -> panic as { "ValueSet " <> vsname <> " has no variants" }
  }
}

pub const insert_at =
  "fn insert_at(elt: a, in: List(a), at: Int) {
  let #(before, after) = list.split(in, at)
  before |> list.append([elt, ..after])
}
"
