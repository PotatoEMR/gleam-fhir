import gleam/option.{type Option, Some}

pub type DiscriminatorCall {
  ResultDiscriminatorCall(String)
}

pub fn discriminator_from_base_call(
  discriminator_type: String,
  value: String,
  system: String,
  code: String,
  display: Option(String),
) -> Result(DiscriminatorCall, Nil) {
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
        "ct.coding_fixed_system_from_coding("
        <> value
        <> ", \""
        <> system
        <> "\")",
      ))
    "ct.CodingFixedSystemCode" ->
      Ok(ResultDiscriminatorCall(
        "ct.coding_fixed_system_code_from_coding("
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
        "ct.coding_fixed_system_code_display_from_coding("
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
        "ct.coding_fixed_system_required_code_display_from_coding("
        <> value
        <> ", \""
        <> system
        <> "\")",
      ))
    "ct.CodeableconceptFixedSystemCode" ->
      Ok(ResultDiscriminatorCall(
        "ct.codeableconcept_fixed_system_code_from_codeableconcept("
        <> value
        <> ", \""
        <> system
        <> "\", \""
        <> code
        <> "\")",
      ))
    "ct.CodeableconceptFixedSystem" ->
      Ok(ResultDiscriminatorCall(
        "ct.codeableconcept_fixed_system_from_codeableconcept("
        <> value
        <> ", \""
        <> system
        <> "\")",
      ))
    "ct.CodeableconceptFixedSystemCodeDisplay" -> {
      let assert Some(display) = display
      Ok(ResultDiscriminatorCall(
        "ct.codeableconcept_fixed_system_code_display_from_codeableconcept("
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
  discriminator_type: String,
) -> Result(String, Nil) {
  case discriminator_type {
    "ct.CodingFixedSystem" -> Ok("ct.coding_fixed_system_new()")
    "ct.CodingFixedSystemCode" -> Ok("ct.coding_fixed_system_code_new()")
    "ct.CodingFixedSystemCodeDisplay" ->
      Ok("ct.coding_fixed_system_code_display_new()")
    "ct.CodingFixedSystemRequiredCodeDisplay" ->
      Ok("ct.coding_fixed_system_required_code_display_new(\"\", \"\")")
    "ct.CodeableconceptFixedSystemCode" ->
      Ok("ct.codeableconcept_fixed_system_code_new()")
    "ct.CodeableconceptFixedSystem" ->
      Ok("ct.codeableconcept_fixed_system_new()")
    "ct.CodeableconceptFixedSystemCodeDisplay" ->
      Ok("ct.codeableconcept_fixed_system_code_display_new()")
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

pub const slice_coding = "
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
  let Coding(
    id:,
    extension:,
    system: coding_system,
    version:,
    code:,
    display:,
    user_selected:,
  ) = coding
  case coding_system == Some(system) {
    True ->
      Ok(CodingFixedSystem(
        id:,
        extension:,
        version:,
        code:,
        display:,
        user_selected:,
      ))
    False -> Error(Nil)
  }
}

pub fn coding_fixed_system_to_json(
  coding: CodingFixedSystem,
  system: String,
) -> Json {
  let CodingFixedSystem(
    id:,
    extension:,
    version:,
    code:,
    display:,
    user_selected:,
  ) = coding
  coding_to_json(Coding(
    id:,
    extension:,
    system: Some(system),
    version:,
    code:,
    display:,
    user_selected:,
  ))
}

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
  let Coding(
    id:,
    extension:,
    system: coding_system,
    version:,
    code: coding_code,
    display:,
    user_selected:,
  ) = coding
  case coding_system, coding_code {
    Some(coding_system_value), Some(coding_code_value) ->
      case coding_system_value == system && coding_code_value == code {
        True -> Ok(CodingFixedSystemCode(
          id:,
          extension:,
          version:,
          display:,
          user_selected:,
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
  let CodingFixedSystemCode(
    id:,
    extension:,
    version:,
    display:,
    user_selected:,
  ) = coding
  coding_to_json(Coding(
    id:,
    extension:,
    system: Some(system),
    version:,
    code: Some(code),
    display:,
    user_selected:,
  ))
}
"

pub const slice_coding_display = "
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
  let Coding(
    id:,
    extension:,
    system: coding_system,
    version:,
    code: coding_code,
    display: coding_display,
    user_selected:,
  ) = coding
  case coding_system, coding_code, coding_display {
    Some(coding_system_value), Some(coding_code_value), Some(coding_display_value) ->
      case
        coding_system_value == system
        && coding_code_value == code
        && coding_display_value == display
      {
        True -> Ok(CodingFixedSystemCodeDisplay(
          id:,
          extension:,
          version:,
          user_selected:,
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
  let CodingFixedSystemCodeDisplay(
    id:,
    extension:,
    version:,
    user_selected:,
  ) = coding
  coding_to_json(Coding(
    id:,
    extension:,
    system: Some(system),
    version:,
    code: Some(code),
    display: Some(display),
    user_selected:,
  ))
}
"

pub const slice_coding_fixeduri = "
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
  let Coding(
    id:,
    extension:,
    system: coding_system,
    version:,
    code: coding_code,
    display: coding_display,
    user_selected:,
  ) = coding
  case coding_system, coding_code, coding_display {
    Some(coding_system_value), Some(coding_code), Some(coding_display) ->
      case coding_system_value == system {
        True -> Ok(CodingFixedSystemRequiredCodeDisplay(
          id:,
          extension:,
          version:,
          code: coding_code,
          display: coding_display,
          user_selected:,
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
  let CodingFixedSystemRequiredCodeDisplay(
    id:,
    extension:,
    version:,
    code:,
    display:,
    user_selected:,
  ) = coding
  coding_to_json(Coding(
    id:,
    extension:,
    system: Some(system),
    version:,
    code: Some(code),
    display: Some(display),
    user_selected:,
  ))
}
"

pub const slice_codeableconcept = "
pub type CodeableconceptFixedSystem {
  CodeableconceptFixedSystem(
    id: Option(String),
    extension: List(Extension),
    disc: CodingFixedSystem,
    others: List(Coding),
    text: Option(String),
  )
}

pub fn codeableconcept_fixed_system_new() -> CodeableconceptFixedSystem {
  CodeableconceptFixedSystem(
    id: None,
    extension: [],
    disc: coding_fixed_system_new(),
    others: [],
    text: None,
  )
}

pub fn codeableconcept_fixed_system_from_codeableconcept(
  concept: Codeableconcept,
  system: String,
) -> Result(CodeableconceptFixedSystem, Nil) {
  let Codeableconcept(id:, extension:, coding:, text:) = concept
  case find_elt_and_rest_result(
    in: coding,
    one_that: fn(coding) { coding_fixed_system_from_coding(coding, system) },
  ) {
    Error(Nil) -> Error(Nil)
    Ok(#(disc, others)) ->
      Ok(CodeableconceptFixedSystem(
        id:,
        extension:,
        disc:,
        others:,
        text:,
      ))
  }
}

pub fn codeableconcept_fixed_system_to_json(
  concept: CodeableconceptFixedSystem,
  system: String,
) -> Json {
  let CodeableconceptFixedSystem(
    id:,
    extension:,
    disc:,
    others:,
    text:,
  ) = concept
  codeableconcept_to_json(Codeableconcept(
    id:,
    extension:,
    coding: [coding_fixed_system_to_coding(disc, system), ..others],
    text:,
  ))
}

fn coding_fixed_system_to_coding(
  coding: CodingFixedSystem,
  system: String,
) -> Coding {
  let CodingFixedSystem(
    id:,
    extension:,
    version:,
    code:,
    display:,
    user_selected:,
  ) = coding
  Coding(
    id:,
    extension:,
    system: Some(system),
    version:,
    code:,
    display:,
    user_selected:,
  )
}

pub type CodeableconceptFixedSystemCode {
  CodeableconceptFixedSystemCode(
    id: Option(String),
    extension: List(Extension),
    disc: CodingFixedSystemCode,
    others: List(Coding),
    text: Option(String),
  )
}

pub fn codeableconcept_fixed_system_code_new() -> CodeableconceptFixedSystemCode {
  CodeableconceptFixedSystemCode(
    id: None,
    extension: [],
    disc: coding_fixed_system_code_new(),
    others: [],
    text: None,
  )
}

pub fn codeableconcept_fixed_system_code_from_codeableconcept(
  concept: Codeableconcept,
  system: String,
  code: String,
) -> Result(CodeableconceptFixedSystemCode, Nil) {
  let Codeableconcept(id:, extension:, coding:, text:) = concept
  case find_elt_and_rest_result(
    in: coding,
    one_that: fn(coding) {
      coding_fixed_system_code_from_coding(coding, system, code)
    },
  ) {
    Error(Nil) -> Error(Nil)
    Ok(#(disc, others)) ->
      Ok(CodeableconceptFixedSystemCode(
        id:,
        extension:,
        disc:,
        others:,
        text:,
      ))
  }
}

pub fn codeableconcept_fixed_system_code_to_json(
  concept: CodeableconceptFixedSystemCode,
  system: String,
  code: String,
) -> Json {
  let CodeableconceptFixedSystemCode(
    id:,
    extension:,
    disc:,
    others:,
    text:,
  ) = concept
  codeableconcept_to_json(Codeableconcept(
    id:,
    extension:,
    coding: [coding_fixed_system_code_to_coding(disc, system, code), ..others],
    text:,
  ))
}

fn coding_fixed_system_code_to_coding(
  coding: CodingFixedSystemCode,
  system: String,
  code: String,
) -> Coding {
  let CodingFixedSystemCode(
    id:,
    extension:,
    version:,
    display:,
    user_selected:,
  ) = coding
  Coding(
    id:,
    extension:,
    system: Some(system),
    version:,
    code: Some(code),
    display:,
    user_selected:,
  )
}
"

pub const slice_codeableconcept_display = "
pub type CodeableconceptFixedSystemCodeDisplay {
  CodeableconceptFixedSystemCodeDisplay(
    id: Option(String),
    extension: List(Extension),
    disc: CodingFixedSystemCodeDisplay,
    others: List(Coding),
    text: Option(String),
  )
}

pub fn codeableconcept_fixed_system_code_display_new(
) -> CodeableconceptFixedSystemCodeDisplay {
  CodeableconceptFixedSystemCodeDisplay(
    id: None,
    extension: [],
    disc: coding_fixed_system_code_display_new(),
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
  let Codeableconcept(id:, extension:, coding:, text:) = concept
  case find_elt_and_rest_result(
    in: coding,
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
    Ok(#(disc, others)) ->
      Ok(CodeableconceptFixedSystemCodeDisplay(
        id:,
        extension:,
        disc:,
        others:,
        text:,
      ))
  }
}

pub fn codeableconcept_fixed_system_code_display_to_json(
  concept: CodeableconceptFixedSystemCodeDisplay,
  system: String,
  code: String,
  display: String,
) -> Json {
  let CodeableconceptFixedSystemCodeDisplay(
    id:,
    extension:,
    disc:,
    others:,
    text:,
  ) = concept
  codeableconcept_to_json(Codeableconcept(
    id:,
    extension:,
    coding: [
      coding_fixed_system_code_display_to_coding(disc, system, code, display),
      ..others
    ],
    text:,
  ))
}

fn coding_fixed_system_code_display_to_coding(
  coding: CodingFixedSystemCodeDisplay,
  system: String,
  code: String,
  display: String,
) -> Coding {
  let CodingFixedSystemCodeDisplay(
    id:,
    extension:,
    version:,
    user_selected:,
  ) = coding
  Coding(
    id:,
    extension:,
    system: Some(system),
    version:,
    code: Some(code),
    display: Some(display),
    user_selected:,
  )
}
"
