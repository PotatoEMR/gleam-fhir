import codegen_helpers
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/set.{type Set}
import gleam/string

pub const bound_coding_and_cc = "pub type BoundCoding(required_binding) {
        BoundCoding(
          id: Option(String),
          extension: List(Extension),
          code: required_binding,
          version: Option(String),
          display: Option(String),
          user_selected: Option(Bool),
        )
      }

      pub fn bound_coding_new(code: required_binding) -> BoundCoding(required_binding) {
        BoundCoding(
          user_selected: None,
          display: None,
          code:,
          version: None,
          extension: [],
          id: None,
        )
      }

      pub fn bound_coding_from_coding(
        coding: Coding,
        binding_from_code_and_system: fn(String, String) -> Result(required_binding, Nil),
      ) -> Result(BoundCoding(required_binding), Nil) {
        let Coding(
          id:,
          extension:,
          system:,
          version:,
          code:,
          display:,
          user_selected:,
        ) = coding
        case code, system {
          Some(code), Some(system) -> case binding_from_code_and_system(code, system) {
            Error(Nil) -> Error(Nil)
            Ok(code) -> Ok(BoundCoding(
              id:,
              extension:,
              code:,
              version:,
              display:,
              user_selected:,
            ))
          }
          _, _ -> Error(Nil)
        }
      }

      pub fn bound_coding_to_json(coding: BoundCoding(required_binding), get_code: fn(required_binding) -> String,  get_system: fn(required_binding) -> String, ) -> Json {
        let BoundCoding(
          user_selected:,
          display:,
          code: bound_code,
          version:,
          extension:,
          id:,
        ) = coding
        let fields = [
           #(\"code\", json.string(get_code(bound_code))),
           #(\"system\", json.string(get_system(bound_code))),
        ]
        let fields = case user_selected {
          Some(v) -> [#(\"userSelected\", json.bool(v)), ..fields]
          None -> fields
        }
        let fields = case display {
          Some(v) -> [#(\"display\", json.string(v)), ..fields]
          None -> fields
        }
        let fields = case version {
          Some(v) -> [#(\"version\", json.string(v)), ..fields]
          None -> fields
        }
        let fields = case extension {
          [] -> fields
          _ -> [#(\"extension\", json.array(extension, extension_to_json)), ..fields]
        }
        let fields = case id {
          Some(v) -> [#(\"id\", json.string(v)), ..fields]
          None -> fields
        }
        json.object(fields)
      }

      pub fn bound_coding_decoder(binding_from_code_and_system: fn(String, String) -> Result(required_binding, Nil), failure_placeholder: required_binding) -> Decoder(BoundCoding(required_binding)) {
        use <- decode.recursive
        use code <- decode.field(\"code\", decode.string)
        use system <- decode.field(\"system\", decode.string)
        case binding_from_code_and_system(code, system) {
        Error(_) ->         decode.failure(bound_coding_new(failure_placeholder),
          \"need code + system from required ValueSet\"
        )
        Ok(binding) -> {
        use user_selected <- decode.optional_field(
          \"userSelected\",
          None,
          decode.optional(decode.bool),
        )
        use display <- decode.optional_field(
          \"display\",
          None,
          decode.optional(decode.string),
        )
        use version <- decode.optional_field(
          \"version\",
          None,
          decode.optional(decode.string),
        )
        use extension <- decode.optional_field(
          \"extension\",
          [],
          decode.list(extension_decoder()),
        )
        use id <- decode.optional_field(\"id\", None, decode.optional(decode.string))
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

      pub fn bound_codeableconcept_new(code: required_binding) -> BoundCodeableconcept(required_binding) {
        let required = bound_coding_new(code)
        BoundCodeableconcept(text: None, required:, more: [], extension: [], id: None)
      }

      pub fn bound_codeableconcept_from_codeableconcept(
        concept: Codeableconcept,
        binding_from_code_and_system: fn(String, String) -> Result(required_binding, Nil),
      ) -> Result(BoundCodeableconcept(required_binding), Nil) {
        let Codeableconcept(id:, extension:, coding:, text:) = concept
        case find_valueset_coding(coding, binding_from_code_and_system) {
          Error(Nil) -> Error(Nil)
          Ok(#(required, more)) -> Ok(BoundCodeableconcept(
            id:,
            extension:,
            required:,
            more:,
            text:,
          ))
        }
      }

      pub fn bound_codeableconcept_to_json(codeableconcept: BoundCodeableconcept(required_binding),  get_code: fn(required_binding) -> String,  get_system: fn(required_binding) -> String, ) -> Json {
      let BoundCodeableconcept(text:, required:, more:, extension:, id:) = codeableconcept
      let required_coding = bound_coding_to_json(required, get_code, get_system)
      let other_codings = list.map(more, coding_to_json)
      let all_codings = json.preprocessed_array([required_coding, ..other_codings])
      let fields = [#(\"coding\", all_codings)]
        let fields = case text {
          Some(v) -> [#(\"text\", json.string(v)), ..fields]
          None -> fields
        }
        let fields = case extension {
          [] -> fields
          _ -> [#(\"extension\", json.array(extension, extension_to_json)), ..fields]
        }
        let fields = case id {
          Some(v) -> [#(\"id\", json.string(v)), ..fields]
          None -> fields
        }
        json.object(fields)
      }

      pub fn bound_codeableconcept_decoder(binding_from_code_and_system: fn(String, String) -> Result(required_binding, Nil), failure_placeholder: required_binding) -> Decoder(BoundCodeableconcept(required_binding)) {
        use <- decode.recursive
        use coding <- decode.optional_field(
          \"coding\",
          [],
          decode.list(coding_decoder()),
        )
        let valueset_coding = find_valueset_coding(coding, binding_from_code_and_system)
        case valueset_coding {
          Error(_) -> decode.failure(bound_codeableconcept_new(failure_placeholder),
          \"need a coding with code + system from required ValueSet\")
          Ok(#(required, more)) -> {
          use text <- decode.optional_field(
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
          decode.success(BoundCodeableconcept(text:, required:, more:, extension:, id:))
          }
        }
      }

      fn find_valueset_coding(items: List(Coding), binding_from_code_and_system: fn(String, String) -> Result(required_binding, Nil)) -> Result(#(BoundCoding(required_binding), List(Coding)), Nil) {
        let is_bound_valueset = fn(coding: Coding) {
          bound_coding_from_coding(coding, binding_from_code_and_system)
        }
        find_elt_and_rest_result(in: items, one_that: is_bound_valueset)
      }"
  <> find_elt_and_rest_result

pub const found_result = "
  type Found(a){
    FoundValid(a)
    FoundInvalid
    NotFound
  }
  "

pub const bound_codeable_reference = "      pub type BoundCodeablereference(required_binding) {
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
  let BoundCodeablereference(reference:, concept:, extension:, id:) =
    codeablereference
  let fields = []
  let fields = case reference {
    Some(v) -> [#(\"reference\", reference_to_json(v)), ..fields]
    None -> fields
  }
  let fields = case concept {
    Some(v) -> [#(\"concept\", bound_codeableconcept_to_json(v, get_code, get_system)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#(\"extension\", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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

pub const bound_quantity = "pub type BoundQuantity(required_binding) {
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
  let BoundQuantity(code:, unit:, comparator:, value:, extension:, id:) =
    quantity
    let fields = case code {
      Some(bound_code) -> [
         #(\"code\", json.string(get_code(bound_code))),
         #(\"system\", json.string(get_system(bound_code))),
      ]
      None -> []
    }
  let fields = case unit {
    Some(v) -> [#(\"unit\", json.string(v)), ..fields]
    None -> fields
  }
  let fields = case comparator {
    Some(v) -> [
      #(\"comparator\", valuesets.quantitycomparator_to_json(v)),
      ..fields
    ]
    None -> fields
  }
  let fields = case value {
    Some(v) -> [#(\"value\", json.float(v)), ..fields]
    None -> fields
  }
  let fields = case extension {
    [] -> fields
    _ -> [#(\"extension\", json.array(extension, extension_to_json)), ..fields]
  }
  let fields = case id {
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
    Some(code), Some(system) -> case   binding_from_code_and_system(code, system) {
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

pub type ValuesetIncludeCodes {
  ValuesetIncludeExpanded(List(ValuesetCodeWithSystem))
  ValuesetIncludeString(system: String)
}

// need to keep track of system because some valuesets contain multiple systems
// but we flatten valuesets to flat list of codes
// so need to get system from code or create valueset item from system and code
pub type ValuesetCodeWithSystem {
  ValuesetCodeWithSystem(code: String, system: String)
}

pub type OpenValuesetVariant {
  OpenValuesetVariant(name: String, system: String)
}

pub fn bound_valueset_function_name(
  elt: codegen_helpers.Element,
) -> Option(String) {
  case elt.type_, elt.binding {
    [_], Some(binding) ->
      case binding.strength, binding.value_set {
        "required", Some(value_set) -> {
          let assert [url, ..] = string.split(value_set, "|")
          Some(
            url
            |> codegen_helpers.concept_name_from_url
            |> codegen_helpers.to_snake_case,
          )
        }
        _, _ -> None
      }
    _, _ -> None
  }
}

pub fn bound_coding_encoder_source(prefix: String, valueset: String) -> String {
  "fn(coding) { "
  <> bound_coding_encoder_call_source(prefix, valueset, "coding")
  <> " }"
}

pub fn bound_coding_encoder_call_source(
  prefix: String,
  valueset: String,
  value: String,
) -> String {
  prefix
  <> "bound_coding_to_json("
  <> value
  <> ", valuesets."
  <> valueset
  <> "_to_code, valuesets."
  <> valueset
  <> "_system)"
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

pub fn bound_coding_decoder_source(prefix: String, valueset: String) -> String {
  prefix
  <> "bound_coding_decoder(valuesets."
  <> valueset
  <> "_from_code_and_system, valuesets."
  <> valueset
  <> "_failure_variant)"
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

pub fn gen_valueset_from_code_and_system(
  vsname: String,
  vs_codes: List(ValuesetCodeWithSystem),
  open_variants: List(OpenValuesetVariant),
) -> String {
  let vsname_lower = string.lowercase(vsname)
  let template =
    "pub fn CNAMELOWER_from_code_and_system(code code: String, system system: String) -> Result(CNAMECAPITAL, Nil) {
    case code, system {"
    <> list.fold(
      from: "",
      over: vs_codes,
      with: fn(acc: String, member: ValuesetCodeWithSystem) {
        let ValuesetCodeWithSystem(code:, system:) = member
        acc
        <> "\"ACTUALCODE\", \"ACTUALSYSTEM\" -> Ok(CODETYPE)\n"
        |> string.replace(
          "CODETYPE",
          vsname <> string.capitalise(codegen_helpers.codetovarname(code)),
        )
        |> string.replace("ACTUALCODE", code)
        |> string.replace("ACTUALSYSTEM", system)
      },
    )
    <> list.fold(open_variants, "", fn(acc, open_variant) {
      let OpenValuesetVariant(name:, system:) = open_variant
      acc <> "code, \"" <> system <> "\" -> Ok(" <> name <> "(code))\n"
    })
    <> "_, _ -> Error(Nil)}
  }
  "
  template
  |> string.replace("CNAMELOWER", vsname_lower)
  |> string.replace("CNAMECAPITAL", string.capitalise(vsname))
}

pub fn gen_valueset_system(
  vsname: String,
  vs_codes: List(ValuesetCodeWithSystem),
  open_variants: List(OpenValuesetVariant),
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
      <> ") -> String {\n  \""
      <> system
      <> "\"\n}\n"
    _ ->
      gen_multisystem_valueset_system(
        vsname,
        vsname_lower,
        vs_codes,
        open_variants,
      )
  }
}

pub fn gen_multisystem_valueset_system(
  vsname: String,
  vsname_lower: String,
  vs_codes: List(ValuesetCodeWithSystem),
  open_variants: List(OpenValuesetVariant),
) -> String {
  let expanded_system_arms =
    list.fold(vs_codes, "", fn(acc, member) {
      let ValuesetCodeWithSystem(code:, system:) = member
      acc
      <> vsname
      <> string.capitalise(codegen_helpers.codetovarname(code))
      <> " -> \""
      <> system
      <> "\"\n"
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
  <> list.fold(open_variants, "", fn(acc, open_variant) {
    let OpenValuesetVariant(name:, system:) = open_variant
    acc <> name <> "(value: _) -> \"" <> system <> "\"\n"
  })
  <> "}\n}\n"
}

pub fn valueset_failure_variant_source(
  vsname: String,
  vs_codes: List(ValuesetCodeWithSystem),
  open_variants: List(OpenValuesetVariant),
) -> String {
  case vs_codes, open_variants {
    [ValuesetCodeWithSystem(code:, ..), ..], _ ->
      vsname <> string.capitalise(codegen_helpers.codetovarname(code))
    [], [OpenValuesetVariant(name:, ..), ..] -> name <> "(\"\")"
    [], [] -> panic as { "ValueSet " <> vsname <> " has no variants" }
  }
}

pub const find_elt_and_rest_result = "fn find_elt_and_rest_result(
  in items: List(a),
  one_that is_desired: fn(a) -> Result(b, Nil),
) -> Result(#(b, List(a)), Nil) {
  find_elt_and_rest_result_loop(
    in: items,
    one_that: is_desired,
    already: [],
  )
}

fn find_elt_and_rest_result_loop(
  in items: List(a),
  one_that is_desired: fn(a) -> Result(b, Nil),
  already past_list: List(a),
) -> Result(#(b, List(a)), Nil) {
  case items {
    [] -> Error(Nil)
    [first, ..rest] ->
      case is_desired(first) {
        Ok(found_elt) -> {
          let more = past_list |> list.reverse |> list.append(rest)
          Ok(#(found_elt, more))
        }
        Error(_) -> {
          let others = [first, ..past_list]
          find_elt_and_rest_result_loop(
            in: rest,
            one_that: is_desired,
            already: others,
          )
        }
      }
  }
}
"

pub const find_elt_and_rest_found = "fn find_elt_and_rest_found(
  in items: List(a),
  one_that is_desired: fn(a) -> Found(b),
) -> Found(#(b, List(a))) {
  find_elt_and_rest_found_loop(in: items, one_that: is_desired, already: [])
}

fn find_elt_and_rest_found_loop(
  in items: List(a),
  one_that is_desired: fn(a) -> Found(b),
  already past_list: List(a),
) -> Found(#(b, List(a))) {
  case items {
    [] -> NotFound
    [first, ..rest] ->
      case is_desired(first) {
        FoundValid(found_elt) -> {
          let more = past_list |> list.reverse |> list.append(rest)
          FoundValid(#(found_elt, more))
        }
        FoundInvalid -> FoundInvalid
        NotFound -> {
          let others = [first, ..past_list]
          find_elt_and_rest_found_loop(
            in: rest,
            one_that: is_desired,
            already: others,
          )
        }
      }
  }
}
"

pub const find_n_elts_and_rest_result = "fn find_n_elts_and_rest_result(
  in items: List(a),
  items_that are_desired: fn(a) -> Result(b, Nil),
  num to_find: Int,
) -> Result(#(List(b), List(a)), Nil) {
  find_n_elts_and_rest_result_loop(
    in: items,
    items_that: are_desired,
    num: to_find,
    already: [],
    have: [],
  )
}

fn find_n_elts_and_rest_result_loop(
  in items: List(a),
  items_that are_desired: fn(a) -> Result(b, Nil),
  num to_find: Int,
  already past_list: List(a),
  have found_acc: List(b),
) -> Result(#(List(b), List(a)), Nil) {
  case items {
    [] -> Error(Nil)
    [first, ..rest] ->
      case are_desired(first) {
        Ok(found_elt) -> {
          let found_acc = [found_elt, ..found_acc]
          let to_find = to_find - 1
          case to_find <= 0 {
            True -> {
              let more = past_list |> list.reverse |> list.append(rest)
              let found_acc = list.reverse(found_acc)
              Ok(#(found_acc, more))
            }
            False ->
              find_n_elts_and_rest_result_loop(
                in: rest,
                items_that: are_desired,
                num: to_find,
                already: past_list,
                have: found_acc,
              )
          }
        }
        Error(_) -> {
          let others = [first, ..past_list]
          find_n_elts_and_rest_result_loop(
            in: rest,
            items_that: are_desired,
            num: to_find,
            already: others,
            have: found_acc,
          )
        }
      }
  }
}
"

pub const find_n_elts_and_rest_found = "fn find_n_elts_and_rest_found(
  in items: List(a),
  items_that are_desired: fn(a) -> Found(b),
  num to_find: Int,
) -> Found(#(List(b), List(a))) {
  find_n_elts_and_rest_found_loop(
    in: items,
    items_that: are_desired,
    num: to_find,
    already: [],
    have: [],
  )
}

fn find_n_elts_and_rest_found_loop(
  in items: List(a),
  items_that are_desired: fn(a) -> Found(b),
  num to_find: Int,
  already past_list: List(a),
  have found_acc: List(b),
) -> Found(#(List(b), List(a))) {
  case items {
    [] -> NotFound
    [first, ..rest] ->
      case are_desired(first) {
        FoundValid(found_elt) -> {
          let found_acc = [found_elt, ..found_acc]
          let to_find = to_find - 1
          case to_find <= 0 {
            True -> {
              let more = past_list |> list.reverse |> list.append(rest)
              let found_acc = list.reverse(found_acc)
              FoundValid(#(found_acc, more))
            }
            False ->
              find_n_elts_and_rest_found_loop(
                in: rest,
                items_that: are_desired,
                num: to_find,
                already: past_list,
                have: found_acc,
              )
          }
        }
        FoundInvalid -> FoundInvalid
        NotFound -> {
          let others = [first, ..past_list]
          find_n_elts_and_rest_found_loop(
            in: rest,
            items_that: are_desired,
            num: to_find,
            already: others,
            have: found_acc,
          )
        }
      }
  }
}
"

// These are like list.partition, except they also apply the matching function
// and return an error if there are not enough matching elements.
pub const find_at_least_n_elts_and_rest_result = "fn find_at_least_n_elts_and_rest_result(
  in items: List(a),
  items_that are_desired: fn(a) -> Result(b, Nil),
  at_least to_find: Int,
) -> Result(#(List(b), List(a)), Nil) {
  find_at_least_n_elts_and_rest_result_loop(
    in: items,
    items_that: are_desired,
    at_least: to_find,
    already: [],
    have: [],
  )
}

fn find_at_least_n_elts_and_rest_result_loop(
  in items: List(a),
  items_that are_desired: fn(a) -> Result(b, Nil),
  at_least to_find: Int,
  already past_list: List(a),
  have found_acc: List(b),
) -> Result(#(List(b), List(a)), Nil) {
  case items {
    [] ->
      case to_find <= 0 {
        False -> Error(Nil)
        True -> {
          let more = list.reverse(past_list)
          let found_acc = list.reverse(found_acc)
          Ok(#(found_acc, more))
        }
      }
    [first, ..rest] ->
      case are_desired(first) {
        Ok(found_elt) -> {
          let found_acc = [found_elt, ..found_acc]
          let to_find = to_find - 1
          find_at_least_n_elts_and_rest_result_loop(
            in: rest,
            items_that: are_desired,
            at_least: to_find,
            already: past_list,
            have: found_acc,
          )
        }
        Error(_) -> {
          let others = [first, ..past_list]
          find_at_least_n_elts_and_rest_result_loop(
            in: rest,
            items_that: are_desired,
            at_least: to_find,
            already: others,
            have: found_acc,
          )
        }
      }
  }
}
"

pub const find_at_least_n_elts_and_rest_found = "fn find_at_least_n_elts_and_rest_found(
  in items: List(a),
  items_that are_desired: fn(a) -> Found(b),
  at_least to_find: Int,
) -> Found(#(List(b), List(a))) {
  find_at_least_n_elts_and_rest_found_loop(
    in: items,
    items_that: are_desired,
    at_least: to_find,
    already: [],
    have: [],
  )
}

fn find_at_least_n_elts_and_rest_found_loop(
  in items: List(a),
  items_that are_desired: fn(a) -> Found(b),
  at_least to_find: Int,
  already past_list: List(a),
  have found_acc: List(b),
) -> Found(#(List(b), List(a))) {
  case items {
    [] ->
      case to_find <= 0 {
        False -> NotFound
        True -> {
          let more = list.reverse(past_list)
          let found_acc = list.reverse(found_acc)
          FoundValid(#(found_acc, more))
        }
      }
    [first, ..rest] ->
      case are_desired(first) {
        FoundValid(found_elt) -> {
          let found_acc = [found_elt, ..found_acc]
          let to_find = to_find - 1
          find_at_least_n_elts_and_rest_found_loop(
            in: rest,
            items_that: are_desired,
            at_least: to_find,
            already: past_list,
            have: found_acc,
          )
        }
        FoundInvalid -> FoundInvalid
        NotFound -> {
          let others = [first, ..past_list]
          find_at_least_n_elts_and_rest_found_loop(
            in: rest,
            items_that: are_desired,
            at_least: to_find,
            already: others,
            have: found_acc,
          )
        }
      }
  }
}
"

pub const find_elts_and_rest = "
fn find_elts_and_rest(
  in items: List(a),
  items_that are_desired: fn(a) -> Result(b, Nil),
) -> #(List(b), List(a)) {
  find_elts_and_rest_loop(
    in: items,
    items_that: are_desired,
    found: [],
    rest: [],
  )
}

fn find_elts_and_rest_loop(
  in items: List(a),
  items_that are_desired: fn(a) -> Result(b, Nil),
  found found_acc: List(b),
  rest rest_acc: List(a),
) -> #(List(b), List(a)) {
  case items {
    [] -> #(list.reverse(found_acc), list.reverse(rest_acc))

    [first, ..items] ->
      case are_desired(first) {
        Ok(found_elt) ->
          find_elts_and_rest_loop(
            in: items,
            items_that: are_desired,
            found: [found_elt, ..found_acc],
            rest: rest_acc,
          )
        Error(_) ->
          find_elts_and_rest_loop(
            in: items,
            items_that: are_desired,
            found: found_acc,
            rest: [first, ..rest_acc],
          )
      }
  }
}
"
