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
        let is_bound_valueset = fn(coding: Coding){
          case coding.code, coding.system {
            Some(code), Some(system) -> case binding_from_code_and_system(code, system) {
              Error(_) -> Error(Nil)
              Ok(binding) -> Ok(BoundCoding(
                user_selected: coding.user_selected,
                display: coding.display,
                code: binding,
                version: coding.version,
                extension: coding.extension,
                id: coding.id,
              ))
            }
            _, _ -> Error(Nil)
          }
        }
        find_elt_and_rest(in: items, one_that: is_bound_valueset)
      }

      fn find_elt_and_rest(
        in items: List(a),
        one_that is_desired: fn(a) -> Result(b, Nil)
       ) -> Result(#(b, List(a)), Nil) {
         find_elt_and_rest_loop(in: items, one_that: is_desired, already: [])
       }

      fn find_elt_and_rest_loop(
        in items: List(a),
        one_that is_desired: fn(a) -> Result(b, Nil),
        already past_list: List(a)
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
                  // could also increment index here,
                  // if we want to keep track of where we found elt
                  // to not lose order in json roundtrip
                  let others = [first, ..past_list]
                  find_elt_and_rest_loop(in: rest, one_that: is_desired, already: others)
                }
            }
        }
      }
      "
