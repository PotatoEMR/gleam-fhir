import codegen_helpers
import gleam/option.{type Option, Some}
import gleam/string

pub type DiscriminatorCall {
  ResultDiscriminatorCall(String)
}

pub fn discriminator_from_base_call(
  current_bucket: codegen_helpers.Category,
  discriminator_type: String,
  value: String,
  system: String,
  code: String,
  display: Option(String),
) -> Result(DiscriminatorCall, Nil) {
  let complex_prefix = codegen_helpers.bucket_prefix("Quantity", current_bucket)
  case discriminator_type {
    "FixedValueDiscriminator" ->
      Ok(ResultDiscriminatorCall(
        "case "
        <> value
        <> " == \""
        <> system
        <> "\" { True -> Ok("
        <> value
        <> ") False -> Error(Nil) }",
      ))
    "ct.CodingFixedSystem" ->
      Ok(ResultDiscriminatorCall(
        complex_prefix
        <> "coding_fixed_system_from_coding("
        <> value
        <> ", \""
        <> system
        <> "\")",
      ))
    "ct.CodingFixedSystemCode" ->
      Ok(ResultDiscriminatorCall(
        complex_prefix
        <> "coding_fixed_system_code_from_coding("
        <> value
        <> ", \""
        <> system
        <> "\", \""
        <> code
        <> "\")",
      ))
    "ct.CodingFixedSystemCodeDisplay" -> {
      let assert Some(display) = display
      Ok(ResultDiscriminatorCall(
        complex_prefix
        <> "coding_fixed_system_code_display_from_coding("
        <> value
        <> ", \""
        <> system
        <> "\", \""
        <> code
        <> "\", \""
        <> display
        <> "\")",
      ))
    }
    "ct.CodingFixedSystemRequiredCodeDisplay" ->
      Ok(ResultDiscriminatorCall(
        complex_prefix
        <> "coding_fixed_system_required_code_display_from_coding("
        <> value
        <> ", \""
        <> system
        <> "\")",
      ))
    "ct.CodeableconceptList1FixedSystemCode" ->
      Ok(ResultDiscriminatorCall(
        complex_prefix
        <> "codeableconcept_list1_fixed_system_code_from_codeableconcept("
        <> value
        <> ", \""
        <> system
        <> "\""
        <> ", \""
        <> code
        <> "\""
        <> ")",
      ))
    "ct.CodeableconceptFixedSystemCode" ->
      Ok(ResultDiscriminatorCall(
        complex_prefix
        <> "codeableconcept_fixed_system_code_from_codeableconcept("
        <> value
        <> ", \""
        <> system
        <> "\", \""
        <> code
        <> "\")",
      ))
    "ct.CodeableconceptList1FixedSystem" ->
      Ok(ResultDiscriminatorCall(
        complex_prefix
        <> "codeableconcept_list1_fixed_system_from_codeableconcept("
        <> value
        <> ", \""
        <> system
        <> "\""
        <> ")",
      ))
    "ct.CodeableconceptFixedSystem" ->
      Ok(ResultDiscriminatorCall(
        complex_prefix
        <> "codeableconcept_fixed_system_from_codeableconcept("
        <> value
        <> ", \""
        <> system
        <> "\")",
      ))
    "ct.CodeableconceptList1FixedSystemCodeDisplay" -> {
      let assert Some(display) = display
      Ok(ResultDiscriminatorCall(
        complex_prefix
        <> "codeableconcept_list1_fixed_system_code_display_from_codeableconcept("
        <> value
        <> ", \""
        <> system
        <> "\""
        <> ", \""
        <> code
        <> "\""
        <> ", \""
        <> display
        <> "\""
        <> ")",
      ))
    }
    "ct.CodeableconceptFixedSystemCodeDisplay" -> {
      let assert Some(display) = display
      Ok(ResultDiscriminatorCall(
        complex_prefix
        <> "codeableconcept_fixed_system_code_display_from_codeableconcept("
        <> value
        <> ", \""
        <> system
        <> "\", \""
        <> code
        <> "\", \""
        <> display
        <> "\")",
      ))
    }
    _ -> Error(Nil)
  }
}

pub fn discriminator_new_call(
  current_bucket: codegen_helpers.Category,
  discriminator_type: String,
) -> Result(String, Nil) {
  let complex_prefix = codegen_helpers.bucket_prefix("Quantity", current_bucket)
  case discriminator_type {
    "ct.CodingFixedSystem" -> Ok(complex_prefix <> "coding_fixed_system_new()")
    "ct.CodingFixedSystemCode" ->
      Ok(complex_prefix <> "coding_fixed_system_code_new()")
    "ct.CodingFixedSystemCodeDisplay" ->
      Ok(complex_prefix <> "coding_fixed_system_code_display_new()")
    "ct.CodingFixedSystemRequiredCodeDisplay" ->
      Ok(
        complex_prefix
        <> "coding_fixed_system_required_code_display_new(\"\", \"\")",
      )
    "ct.CodeableconceptList1FixedSystemCode" ->
      Ok(
        complex_prefix
        <> "codeableconcept_list1_fixed_system_code_new("
        <> complex_prefix
        <> "List1(first: "
        <> complex_prefix
        <> "coding_fixed_system_code_new(), rest: []))",
      )
    "ct.CodeableconceptFixedSystemCode" ->
      Ok(complex_prefix <> "codeableconcept_fixed_system_code_new()")
    "ct.CodeableconceptList1FixedSystem" ->
      Ok(
        complex_prefix
        <> "codeableconcept_list1_fixed_system_new("
        <> complex_prefix
        <> "List1(first: "
        <> complex_prefix
        <> "coding_fixed_system_new(), rest: []))",
      )
    "ct.CodeableconceptFixedSystem" ->
      Ok(complex_prefix <> "codeableconcept_fixed_system_new()")
    "ct.CodeableconceptList1FixedSystemCodeDisplay" ->
      Ok(
        complex_prefix
        <> "codeableconcept_list1_fixed_system_code_display_new("
        <> complex_prefix
        <> "List1(first: "
        <> complex_prefix
        <> "coding_fixed_system_code_display_new(), rest: []))",
      )
    "ct.CodeableconceptFixedSystemCodeDisplay" ->
      Ok(complex_prefix <> "codeableconcept_fixed_system_code_display_new()")
    _ -> Error(Nil)
  }
}

pub fn discriminator_from_required_profile_call(
  _discriminator_type: String,
  _value: String,
  _system: String,
) -> Result(DiscriminatorCall, Nil) {
  Error(Nil)
}

pub const slice_coding_fixed_system =
  "
pub type CodingFixedSystem {
  CodingFixedSystem(
    id: Option(String),
    extension: List(Extension),
    version: Option(String),
    code: Option(String),
    display: Option(String),
    user_selected: Option(Bool),
  )
}

pub fn coding_fixed_system_new() -> CodingFixedSystem {
  CodingFixedSystem(
    id: None,
    extension: [],
    version: None,
    code: None,
    display: None,
    user_selected: None,
  )
}

pub fn coding_fixed_system_from_coding(
  coding: Coding,
  system: String,
) -> Result(CodingFixedSystem, Nil) {
  case coding.system == Some(system) {
    True ->
      Ok(CodingFixedSystem(
        id: coding.id,
        extension: coding.extension,
        version: coding.version,
        code: coding.code,
        display: coding.display,
        user_selected: coding.user_selected,
      ))
    False -> Error(Nil)
  }
}

pub fn coding_fixed_system_to_json(
  coding: CodingFixedSystem,
  system: String,
) -> Json {
  coding_to_json(coding_fixed_system_to_coding(coding, system))
}

fn coding_fixed_system_to_coding(
  coding: CodingFixedSystem,
  system: String,
) -> Coding {
  Coding(
    id: coding.id,
    extension: coding.extension,
    system: Some(system),
    version: coding.version,
    code: coding.code,
    display: coding.display,
    user_selected: coding.user_selected,
  )
}

"

pub const slice_coding_fixed_system_code =
  "
pub type CodingFixedSystemCode {
  CodingFixedSystemCode(
    id: Option(String),
    extension: List(Extension),
    version: Option(String),
    display: Option(String),
    user_selected: Option(Bool),
  )
}

pub fn coding_fixed_system_code_new() -> CodingFixedSystemCode {
  CodingFixedSystemCode(
    id: None,
    extension: [],
    version: None,
    display: None,
    user_selected: None,
  )
}

pub fn coding_fixed_system_code_from_coding(
  coding: Coding,
  system: String,
  code: String,
) -> Result(CodingFixedSystemCode, Nil) {
  case coding.system, coding.code {
    Some(coding_system_value), Some(coding_code_value) ->
      case coding_system_value == system && coding_code_value == code {
        True -> Ok(CodingFixedSystemCode(
          id: coding.id,
          extension: coding.extension,
          version: coding.version,
          display: coding.display,
          user_selected: coding.user_selected,
        ))
        False -> Error(Nil)
      }
    _, _ -> Error(Nil)
  }
}

pub fn coding_fixed_system_code_to_json(
  coding: CodingFixedSystemCode,
  system: String,
  code: String,
) -> Json {
  coding_to_json(coding_fixed_system_code_to_coding(coding, system, code))
}

fn coding_fixed_system_code_to_coding(
  coding: CodingFixedSystemCode,
  system: String,
  code: String,
) -> Coding {
  Coding(
    id: coding.id,
    extension: coding.extension,
    system: Some(system),
    version: coding.version,
    code: Some(code),
    display: coding.display,
    user_selected: coding.user_selected,
  )
}
"

pub const slice_coding_display =
  "
pub type CodingFixedSystemCodeDisplay {
  CodingFixedSystemCodeDisplay(
    id: Option(String),
    extension: List(Extension),
    version: Option(String),
    user_selected: Option(Bool),
  )
}

pub fn coding_fixed_system_code_display_new() -> CodingFixedSystemCodeDisplay {
  CodingFixedSystemCodeDisplay(
    id: None,
    extension: [],
    version: None,
    user_selected: None,
  )
}

pub fn coding_fixed_system_code_display_from_coding(
  coding: Coding,
  system: String,
  code: String,
  display: String,
) -> Result(CodingFixedSystemCodeDisplay, Nil) {
  case coding.system, coding.code, coding.display {
    Some(coding_system_value), Some(coding_code_value), Some(coding_display_value) ->
      case
        coding_system_value == system
        && coding_code_value == code
        && coding_display_value == display
      {
        True -> Ok(CodingFixedSystemCodeDisplay(
          id: coding.id,
          extension: coding.extension,
          version: coding.version,
          user_selected: coding.user_selected,
        ))
        False -> Error(Nil)
      }
    _, _, _ -> Error(Nil)
  }
}

pub fn coding_fixed_system_code_display_to_json(
  coding: CodingFixedSystemCodeDisplay,
  system: String,
  code: String,
  display: String,
) -> Json {
  coding_to_json(coding_fixed_system_code_display_to_coding(coding, system, code, display))
}

fn coding_fixed_system_code_display_to_coding(
  coding: CodingFixedSystemCodeDisplay,
  system: String,
  code: String,
  display: String,
) -> Coding {
  Coding(
    id: coding.id,
    extension: coding.extension,
    system: Some(system),
    version: coding.version,
    code: Some(code),
    display: Some(display),
    user_selected: coding.user_selected,
  )
}
"

pub const slice_coding_fixeduri =
  "
pub type CodingFixedSystemRequiredCodeDisplay {
  CodingFixedSystemRequiredCodeDisplay(
    id: Option(String),
    extension: List(Extension),
    code: String,
    version: Option(String),
    display: String,
    user_selected: Option(Bool),
  )
}

pub fn coding_fixed_system_required_code_display_new(
  code code: String,
  display display: String,
) -> CodingFixedSystemRequiredCodeDisplay {
  CodingFixedSystemRequiredCodeDisplay(
    id: None,
    extension: [],
    version: None,
    code:,
    display:,
    user_selected: None,
  )
}

pub fn coding_fixed_system_required_code_display_from_coding(
  coding: Coding,
  system: String,
) -> Result(CodingFixedSystemRequiredCodeDisplay, Nil) {
  case coding.system, coding.code, coding.display {
    Some(coding_system_value), Some(coding_code), Some(coding_display) ->
      case coding_system_value == system {
        True -> Ok(CodingFixedSystemRequiredCodeDisplay(
          id: coding.id,
          extension: coding.extension,
          version: coding.version,
          code: coding_code,
          display: coding_display,
          user_selected: coding.user_selected,
        ))
        False -> Error(Nil)
      }
    _, _, _ -> Error(Nil)
  }
}

pub fn coding_fixed_system_required_code_display_to_json(
  coding: CodingFixedSystemRequiredCodeDisplay,
  system: String,
) -> Json {
  coding_to_json(Coding(
    id: coding.id,
    extension: coding.extension,
    system: Some(system),
    version: coding.version,
    code: Some(coding.code),
    display: Some(coding.display),
    user_selected: coding.user_selected,
  ))
}
"

pub fn slice_codeableconcept(preserve_slice_order: Bool) -> #(String, String) {
  let fixed_system =
    string.concat([
      "
pub type CodeableconceptFixedSystem {
  CodeableconceptFixedSystem(
    id: Option(String),
    extension: List(Extension),
",
      case preserve_slice_order {
        True ->
          "    internal_gleam_fhir_index: Option(Int),
"
        False -> ""
      },
      "    disc: CodingFixedSystem,
    others: List(Coding),
    text: Option(String),
  )
}

pub fn codeableconcept_fixed_system_new() -> CodeableconceptFixedSystem {
  CodeableconceptFixedSystem(
    id: None,
    extension: [],
",
      case preserve_slice_order {
        True ->
          "    internal_gleam_fhir_index: None,
"
        False -> ""
      },
      "    disc: coding_fixed_system_new(),
    others: [],
    text: None,
  )
}

pub fn codeableconcept_fixed_system_from_codeableconcept(
  concept: Codeableconcept,
  system: String,
) -> Result(CodeableconceptFixedSystem, Nil) {
  case find_elt_and_rest_result(
    in: concept.coding,
    one_that: fn(coding) { coding_fixed_system_from_coding(coding, system) },
  ) {
    Error(Nil) -> Error(Nil)
",
      case preserve_slice_order {
        True ->
          "    Ok(#(disc, others, index)) ->
"
        False ->
          "    Ok(#(disc, others)) ->
"
      },
      "      Ok(CodeableconceptFixedSystem(
        id: concept.id,
        extension: concept.extension,
",
      case preserve_slice_order {
        True ->
          "        internal_gleam_fhir_index: Some(index),
"
        False -> ""
      },
      "        disc:,
        others:,
        text: concept.text,
      ))
  }
}

pub fn codeableconcept_fixed_system_to_json(
  concept: CodeableconceptFixedSystem,
  system: String,
) -> Json {
",
      case preserve_slice_order {
        True ->
          "  let selected_coding = coding_fixed_system_to_coding(concept.disc, system)
  let coding = case concept.internal_gleam_fhir_index {
    None -> [selected_coding, ..concept.others]
    Some(index) -> insert_at(selected_coding, concept.others, index)
  }
"
        False -> ""
      },
      "  codeableconcept_to_json(Codeableconcept(
    id: concept.id,
    extension: concept.extension,
",
      case preserve_slice_order {
        True ->
          "    coding:,
"
        False ->
          "    coding: [coding_fixed_system_to_coding(concept.disc, system), ..concept.others],
"
      },
      "    text: concept.text,
  ))
}

",
    ])
  let fixed_system_code =
    string.concat([
      "
pub type CodeableconceptFixedSystemCode {
  CodeableconceptFixedSystemCode(
    id: Option(String),
    extension: List(Extension),
",
      case preserve_slice_order {
        True ->
          "    internal_gleam_fhir_index: Option(Int),
"
        False -> ""
      },
      "    disc: CodingFixedSystemCode,
    others: List(Coding),
    text: Option(String),
  )
}

pub fn codeableconcept_fixed_system_code_new() -> CodeableconceptFixedSystemCode {
  CodeableconceptFixedSystemCode(
    id: None,
    extension: [],
",
      case preserve_slice_order {
        True ->
          "    internal_gleam_fhir_index: None,
"
        False -> ""
      },
      "    disc: coding_fixed_system_code_new(),
    others: [],
    text: None,
  )
}

pub fn codeableconcept_fixed_system_code_from_codeableconcept(
  concept: Codeableconcept,
  system: String,
  code: String,
) -> Result(CodeableconceptFixedSystemCode, Nil) {
  case find_elt_and_rest_result(
    in: concept.coding,
    one_that: fn(coding) {
      coding_fixed_system_code_from_coding(coding, system, code)
    },
  ) {
    Error(Nil) -> Error(Nil)
",
      case preserve_slice_order {
        True ->
          "    Ok(#(disc, others, index)) ->
"
        False ->
          "    Ok(#(disc, others)) ->
"
      },
      "      Ok(CodeableconceptFixedSystemCode(
        id: concept.id,
        extension: concept.extension,
",
      case preserve_slice_order {
        True ->
          "        internal_gleam_fhir_index: Some(index),
"
        False -> ""
      },
      "        disc:,
        others:,
        text: concept.text,
      ))
  }
}

pub fn codeableconcept_fixed_system_code_to_json(
  concept: CodeableconceptFixedSystemCode,
  system: String,
  code: String,
) -> Json {
",
      case preserve_slice_order {
        True ->
          "  let selected_coding = coding_fixed_system_code_to_coding(concept.disc, system, code)
  let coding = case concept.internal_gleam_fhir_index {
    None -> [selected_coding, ..concept.others]
    Some(index) -> insert_at(selected_coding, concept.others, index)
  }
"
        False -> ""
      },
      "  codeableconcept_to_json(Codeableconcept(
    id: concept.id,
    extension: concept.extension,
",
      case preserve_slice_order {
        True ->
          "    coding:,
"
        False ->
          "    coding: [coding_fixed_system_code_to_coding(concept.disc, system, code), ..concept.others],
"
      },
      "    text: concept.text,
  ))
}

",
    ])
  #(fixed_system, fixed_system_code)
}

pub fn slice_codeableconcept_display(preserve_slice_order: Bool) -> String {
  string.concat([
    "
pub type CodeableconceptFixedSystemCodeDisplay {
  CodeableconceptFixedSystemCodeDisplay(
    id: Option(String),
    extension: List(Extension),
",
    case preserve_slice_order {
      True ->
        "    internal_gleam_fhir_index: Option(Int),
"
      False -> ""
    },
    "    disc: CodingFixedSystemCodeDisplay,
    others: List(Coding),
    text: Option(String),
  )
}

pub fn codeableconcept_fixed_system_code_display_new(
) -> CodeableconceptFixedSystemCodeDisplay {
  CodeableconceptFixedSystemCodeDisplay(
    id: None,
    extension: [],
",
    case preserve_slice_order {
      True ->
        "    internal_gleam_fhir_index: None,
"
      False -> ""
    },
    "    disc: coding_fixed_system_code_display_new(),
    others: [],
    text: None,
  )
}

pub fn codeableconcept_fixed_system_code_display_from_codeableconcept(
  concept: Codeableconcept,
  system: String,
  code: String,
  display: String,
) -> Result(CodeableconceptFixedSystemCodeDisplay, Nil) {
  case find_elt_and_rest_result(
    in: concept.coding,
    one_that: fn(coding) {
      coding_fixed_system_code_display_from_coding(
        coding,
        system,
        code,
        display,
      )
    },
  ) {
    Error(Nil) -> Error(Nil)
",
    case preserve_slice_order {
      True ->
        "    Ok(#(disc, others, index)) ->
"
      False ->
        "    Ok(#(disc, others)) ->
"
    },
    "      Ok(CodeableconceptFixedSystemCodeDisplay(
        id: concept.id,
        extension: concept.extension,
",
    case preserve_slice_order {
      True ->
        "        internal_gleam_fhir_index: Some(index),
"
      False -> ""
    },
    "        disc:,
        others:,
        text: concept.text,
      ))
  }
}

pub fn codeableconcept_fixed_system_code_display_to_json(
  concept: CodeableconceptFixedSystemCodeDisplay,
  system: String,
  code: String,
  display: String,
) -> Json {
",
    case preserve_slice_order {
      True ->
        "  let selected_coding = coding_fixed_system_code_display_to_coding(concept.disc, system, code, display)
  let coding = case concept.internal_gleam_fhir_index {
    None -> [selected_coding, ..concept.others]
    Some(index) -> insert_at(selected_coding, concept.others, index)
  }
"
      False -> ""
    },
    "  codeableconcept_to_json(Codeableconcept(
    id: concept.id,
    extension: concept.extension,
",
    case preserve_slice_order {
      True ->
        "    coding:,
"
      False ->
        "    coding: [
      coding_fixed_system_code_display_to_coding(concept.disc, system, code, display),
      ..concept.others
    ],
"
    },
    "    text: concept.text,
  ))
}

",
  ])
}

pub const slice_codeableconcept_list1_fixed_system =
  "
pub type CodeableconceptList1FixedSystem {
  CodeableconceptList1FixedSystem(
    id: Option(String),
    extension: List(Extension),
    coding: List1(CodingFixedSystem),
    text: Option(String),
  )
}

pub fn codeableconcept_list1_fixed_system_new(
  coding coding: List1(CodingFixedSystem),
) -> CodeableconceptList1FixedSystem {
  CodeableconceptList1FixedSystem(id: None, extension: [], coding:, text: None)
}

pub fn codeableconcept_list1_fixed_system_from_codeableconcept(
  concept: Codeableconcept,
  system: String,
) -> Result(CodeableconceptList1FixedSystem, Nil) {
  case list.try_map(concept.coding, fn(value) {
    coding_fixed_system_from_coding(value, system)
  }) {
    Ok([first, ..rest]) -> Ok(CodeableconceptList1FixedSystem(
      id: concept.id,
      extension: concept.extension,
      coding: List1(first:, rest:),
      text: concept.text,
    ))
    Ok([]) | Error(_) -> Error(Nil)
  }
}

pub fn codeableconcept_list1_fixed_system_to_json(
  concept: CodeableconceptList1FixedSystem,
  system: String,
) -> Json {
  codeableconcept_to_json(Codeableconcept(
    id: concept.id,
    extension: concept.extension,
    coding: list.map([concept.coding.first, ..concept.coding.rest], fn(value) {
      coding_fixed_system_to_coding(value, system)
    }),
    text: concept.text,
  ))
}

"

pub const slice_codeableconcept_list1_fixed_system_code =
  "
pub type CodeableconceptList1FixedSystemCode {
  CodeableconceptList1FixedSystemCode(
    id: Option(String),
    extension: List(Extension),
    coding: List1(CodingFixedSystemCode),
    text: Option(String),
  )
}

pub fn codeableconcept_list1_fixed_system_code_new(
  coding coding: List1(CodingFixedSystemCode),
) -> CodeableconceptList1FixedSystemCode {
  CodeableconceptList1FixedSystemCode(id: None, extension: [], coding:, text: None)
}

pub fn codeableconcept_list1_fixed_system_code_from_codeableconcept(
  concept: Codeableconcept,
  system: String,
  code: String,
) -> Result(CodeableconceptList1FixedSystemCode, Nil) {
  case list.try_map(concept.coding, fn(value) {
    coding_fixed_system_code_from_coding(value, system, code)
  }) {
    Ok([first, ..rest]) -> Ok(CodeableconceptList1FixedSystemCode(
      id: concept.id,
      extension: concept.extension,
      coding: List1(first:, rest:),
      text: concept.text,
    ))
    Ok([]) | Error(_) -> Error(Nil)
  }
}

pub fn codeableconcept_list1_fixed_system_code_to_json(
  concept: CodeableconceptList1FixedSystemCode,
  system: String,
  code: String,
) -> Json {
  codeableconcept_to_json(Codeableconcept(
    id: concept.id,
    extension: concept.extension,
    coding: list.map([concept.coding.first, ..concept.coding.rest], fn(value) {
      coding_fixed_system_code_to_coding(value, system, code)
    }),
    text: concept.text,
  ))
}

"

pub const slice_codeableconcept_list1_fixed_system_code_display =
  "
pub type CodeableconceptList1FixedSystemCodeDisplay {
  CodeableconceptList1FixedSystemCodeDisplay(
    id: Option(String),
    extension: List(Extension),
    coding: List1(CodingFixedSystemCodeDisplay),
    text: Option(String),
  )
}

pub fn codeableconcept_list1_fixed_system_code_display_new(
  coding coding: List1(CodingFixedSystemCodeDisplay),
) -> CodeableconceptList1FixedSystemCodeDisplay {
  CodeableconceptList1FixedSystemCodeDisplay(id: None, extension: [], coding:, text: None)
}

pub fn codeableconcept_list1_fixed_system_code_display_from_codeableconcept(
  concept: Codeableconcept,
  system: String,
  code: String,
  display: String,
) -> Result(CodeableconceptList1FixedSystemCodeDisplay, Nil) {
  case list.try_map(concept.coding, fn(value) {
    coding_fixed_system_code_display_from_coding(value, system, code, display)
  }) {
    Ok([first, ..rest]) -> Ok(CodeableconceptList1FixedSystemCodeDisplay(
      id: concept.id,
      extension: concept.extension,
      coding: List1(first:, rest:),
      text: concept.text,
    ))
    Ok([]) | Error(_) -> Error(Nil)
  }
}

pub fn codeableconcept_list1_fixed_system_code_display_to_json(
  concept: CodeableconceptList1FixedSystemCodeDisplay,
  system: String,
  code: String,
  display: String,
) -> Json {
  codeableconcept_to_json(Codeableconcept(
    id: concept.id,
    extension: concept.extension,
    coding: list.map([concept.coding.first, ..concept.coding.rest], fn(value) {
      coding_fixed_system_code_display_to_coding(value, system, code, display)
    }),
    text: concept.text,
  ))
}
"
