pub type DiscriminatorCall {
  ResultDiscriminatorCall(String)
  FoundDiscriminatorCall(String)
}

pub fn discriminator_from_base_call(
  discriminator_type: String,
  value: String,
  system: String,
  code: String,
) -> Result(DiscriminatorCall, Nil) {
  case discriminator_type {
    "ct.CodingDiscriminator" ->
      Ok(ResultDiscriminatorCall(
        "ct.coding_discriminator_from_coding("
        <> value
        <> ", \""
        <> system
        <> "\", \""
        <> code
        <> "\")",
      ))
    "ct.CodeableconceptDiscriminator" ->
      Ok(ResultDiscriminatorCall(
        "ct.codeableconcept_discriminator_from_codeableconcept("
        <> value
        <> ", \""
        <> system
        <> "\", \""
        <> code
        <> "\")",
      ))
    "ct.IdentifierDiscriminatorType" ->
      Ok(ResultDiscriminatorCall(
        "ct.identifier_discriminator_type_from_identifier("
        <> value
        <> ", \""
        <> system
        <> "\", \""
        <> code
        <> "\")",
      ))
    "ct.IdentifierDiscriminatorSystem" ->
      Ok(ResultDiscriminatorCall(
        "ct.identifier_discriminator_system_from_identifier("
        <> value
        <> ", \""
        <> system
        <> "\")",
      ))
    "ct.IdentifierDiscriminatorSystemRequiredValue" ->
      Ok(FoundDiscriminatorCall(
        "ct.identifier_discriminator_system_required_value_from_identifier("
        <> value
        <> ", \""
        <> system
        <> "\")",
      ))
    _ -> Error(Nil)
  }
}

pub fn discriminator_new_call(
  discriminator_type: String,
) -> Result(String, Nil) {
  case discriminator_type {
    "ct.CodingDiscriminator" -> Ok("ct.coding_discriminator_new()")
    "ct.CodeableconceptDiscriminator" ->
      Ok("ct.codeableconcept_discriminator_new()")
    "ct.IdentifierDiscriminatorType" ->
      Ok("ct.identifier_discriminator_type_new()")
    "ct.IdentifierDiscriminatorSystem" ->
      Ok("ct.identifier_discriminator_system_new()")
    "ct.IdentifierDiscriminatorSystemRequiredValue" ->
      Ok("ct.identifier_discriminator_system_required_value_new(\"\")")
    _ -> Error(Nil)
  }
}

pub const slice_coding = "
pub type CodingDiscriminator {
  CodingDiscriminator(
    id: Option(String),
    extension: List(Extension),
    version: Option(String),
    display: Option(String),
    user_selected: Option(Bool),
  )
}

pub fn coding_discriminator_new() -> CodingDiscriminator {
  CodingDiscriminator(
    id: None,
    extension: [],
    version: None,
    display: None,
    user_selected: None,
  )
}

pub fn coding_discriminator_from_coding(
  coding: Coding,
  system: String,
  code: String,
) -> Result(CodingDiscriminator, Nil) {
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
    Some(coding_system), Some(coding_code) ->
      case coding_system == system && coding_code == code {
        True -> Ok(CodingDiscriminator(
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

pub fn coding_discriminator_to_json(
  coding: CodingDiscriminator,
  system: String,
  code: String,
) -> Json {
  let CodingDiscriminator(
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

pub const slice_codeableconcept = "
pub type CodeableconceptDiscriminator {
  CodeableconceptDiscriminator(
    id: Option(String),
    extension: List(Extension),
    discriminator: CodingDiscriminator ,
    more: List(Coding),
    text: Option(String),
  )
}

pub fn codeableconcept_discriminator_new() -> CodeableconceptDiscriminator {
  CodeableconceptDiscriminator(
    id: None,
    extension: [],
    discriminator: coding_discriminator_new(),
    more: [],
    text: None,
  )
}

pub fn codeableconcept_discriminator_from_codeableconcept(
  concept: Codeableconcept,
  system: String,
  code: String,
) -> Result(CodeableconceptDiscriminator, Nil) {
  let Codeableconcept(id:, extension:, coding:, text:) = concept
  case find_elt_and_rest_result(
    in: coding,
    one_that: fn(coding) {
      coding_discriminator_from_coding(coding, system, code)
    },
  ) {
    Error(Nil) -> Error(Nil)
    Ok(#(discriminator, more)) ->
      Ok(CodeableconceptDiscriminator(
        id:,
        extension:,
        discriminator:,
        more:,
        text:,
      ))
  }
}

pub fn codeableconcept_discriminator_to_json(
  concept: CodeableconceptDiscriminator,
  system: String,
  code: String,
) -> Json {
  let CodeableconceptDiscriminator(
    id:,
    extension:,
    discriminator:,
    more:,
    text:,
  ) = concept
  codeableconcept_to_json(Codeableconcept(
    id:,
    extension:,
    coding: [coding_discriminator_to_coding(discriminator, system, code), ..more],
    text:,
  ))
}

fn coding_discriminator_to_coding(
  coding: CodingDiscriminator,
  system: String,
  code: String,
) -> Coding {
  let CodingDiscriminator(
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

// rather than required: fixed system/value and more: rest
// all codings in this codeableconcept have fixed system and value
// also requires 1..* coding
pub const slice_codeableconcept_all_coding_discriminator = "
pub type CodeableconceptDiscriminatorAllCoding {
  CodeableconceptDiscriminatorAllCoding(
    id: Option(String),
    extension: List(Extension),
    coding: List1(CodingDiscriminator),
    text: Option(String),
  )
}

pub fn codeableconcept_discriminator_all_coding_new(
) -> CodeableconceptDiscriminatorAllCoding {
  CodeableconceptDiscriminatorAllCoding(
    id: None,
    extension: [],
    coding: List1(
      first: coding_discriminator_new(),
      rest: [],
    ),
    text: None,
  )
}
pub fn codeableconcept_all_codings_discriminator_from_codeableconcept(
  concept: Codeableconcept,
  system: String,
  code: String,
) -> Result(CodeableconceptDiscriminatorAllCoding, Nil) {
  let Codeableconcept(id:, extension:, coding:, text:) = concept
  let discriminator_codings = coding |> list.try_map(fn(hope_has_fixed_system_and_code){
    coding_discriminator_from_coding(hope_has_fixed_system_and_code, system, code)
  })
  case discriminator_codings {
    Error(_) -> Error(Nil)
    Ok([first_coding, ..rest_coding]) ->
      Ok(CodeableconceptDiscriminatorAllCoding(
        id:,
        extension:,
        coding: List1(first_coding, rest_coding),
        text:,
      ))
    Ok(_) -> Error(Nil)
  }
}

pub fn codeableconcept_discriminator_all_coding_to_json(
  concept: CodeableconceptDiscriminatorAllCoding,
  system: String,
  code: String,
) -> Json {
  let CodeableconceptDiscriminatorAllCoding(
    id:,
    extension:,
    coding:,
    text:,
  ) = concept
  codeableconcept_to_json(Codeableconcept(
    id:,
    extension:,
    coding: [coding.first, ..coding.rest] |> list.map(fn(c){coding_discriminator_to_coding(c, system, code)}),
    text:,
  ))
}
"

pub const slice_identifier_type = "
pub type IdentifierDiscriminatorType {
  IdentifierDiscriminatorType(
    id: Option(String),
    extension: List(Extension),
    use_: Option(valuesets.Identifieruse),
    type_: CodeableconceptDiscriminator,
    system: Option(String),
    value: Option(String),
    period: Option(Period),
    assigner: Option(Reference),
  )
}

pub fn identifier_discriminator_type_new() -> IdentifierDiscriminatorType {
  IdentifierDiscriminatorType(
    id: None,
    extension: [],
    use_: None,
    type_: codeableconcept_discriminator_new(),
    system: None,
    value: None,
    period: None,
    assigner: None,
  )
}

pub fn identifier_discriminator_type_from_identifier(
  identifier: Identifier,
  type_system: String,
  type_code: String,
) -> Result(IdentifierDiscriminatorType, Nil) {
  let Identifier(
    id:,
    extension:,
    use_:,
    type_:,
    system:,
    value:,
    period:,
    assigner:,
  ) = identifier
  case type_ {
    None -> Error(Nil)
    Some(type_) ->
      case codeableconcept_discriminator_from_codeableconcept(
        type_,
        type_system,
        type_code,
      ) {
        Error(_) -> Error(Nil)
        Ok(type_) ->
          Ok(IdentifierDiscriminatorType(
            id:,
            extension:,
            use_:,
            type_:,
            system:,
            value:,
            period:,
            assigner:,
          ))
      }
  }
}

pub fn identifier_discriminator_type_to_json(
  identifier: IdentifierDiscriminatorType,
  type_system: String,
  type_code: String,
) -> Json {
  let IdentifierDiscriminatorType(
    id:,
    extension:,
    use_:,
    type_:,
    system:,
    value:,
    period:,
    assigner:,
  ) = identifier
  let CodeableconceptDiscriminator(
    id: type_id,
    extension: type_extension,
    discriminator:,
    more:,
    text: type_text,
  ) = type_
  identifier_to_json(Identifier(
    id:,
    extension:,
    use_:,
    type_: Some(Codeableconcept(
      id: type_id,
      extension: type_extension,
      coding: [coding_discriminator_to_coding(discriminator, type_system, type_code), ..more],
      text: type_text,
    )),
    system:,
    value:,
    period:,
    assigner:,
  ))
}
"

pub const slice_identifier_system = "
pub type IdentifierDiscriminatorSystem {
  IdentifierDiscriminatorSystem(
    id: Option(String),
    extension: List(Extension),
    use_: Option(valuesets.Identifieruse),
    value: Option(String),
    type_: Option(Codeableconcept),
    period: Option(Period),
    assigner: Option(Reference),
  )
}

pub fn identifier_discriminator_system_new(
) -> IdentifierDiscriminatorSystem {
  IdentifierDiscriminatorSystem(
    id: None,
    extension: [],
    use_: None,
    value: None,
    type_: None,
    period: None,
    assigner: None,
  )
}

pub fn identifier_discriminator_system_from_identifier(
  identifier: Identifier,
  expected_system: String,
) -> Result(IdentifierDiscriminatorSystem, Nil) {
  let Identifier(
    id:,
    extension:,
    use_:,
    type_:,
    system:,
    value:,
    period:,
    assigner:,
  ) = identifier
  case system {
    Some(system) -> case system == expected_system {
      True -> Ok(IdentifierDiscriminatorSystem(
        id:,
        extension:,
        use_:,
        value:,
        type_:,
        period:,
        assigner:,
      ))
      False -> Error(Nil)
    }
    _ -> Error(Nil)
  }
}

pub fn identifier_discriminator_system_to_json(
  identifier: IdentifierDiscriminatorSystem,
  system: String,
) -> Json {
  let IdentifierDiscriminatorSystem(
    id:,
    extension:,
    use_:,
    value:,
    type_:,
    period:,
    assigner:,
  ) = identifier
  identifier_to_json(Identifier(
    id:,
    extension:,
    use_:,
    type_:,
    system: Some(system),
    value:,
    period:,
    assigner:,
  ))
}
"

pub const slice_identifier_system_reqvalue = "
pub type IdentifierDiscriminatorSystemRequiredValue {
  IdentifierDiscriminatorSystemRequiredValue(
    id: Option(String),
    extension: List(Extension),
    use_: Option(valuesets.Identifieruse),
    value: String,
    type_: Option(Codeableconcept),
    period: Option(Period),
    assigner: Option(Reference),
  )
}

pub fn identifier_discriminator_system_required_value_new(
  value value: String,
) -> IdentifierDiscriminatorSystemRequiredValue {
  IdentifierDiscriminatorSystemRequiredValue(
    id: None,
    extension: [],
    use_: None,
    value:,
    type_: None,
    period: None,
    assigner: None,
  )
}

pub fn identifier_discriminator_system_required_value_from_identifier(
  identifier: Identifier,
  expected_system: String,
) -> Found(IdentifierDiscriminatorSystemRequiredValue) {
  let Identifier(
    id:,
    extension:,
    use_:,
    type_:,
    system:,
    value:,
    period:,
    assigner:,
  ) = identifier

  case system {
    Some(system) if system == expected_system ->
      case value {
        None ->
          FoundInvalid(\"identifier has system \" <> system <> \" but no required value\")
        Some(value) ->
          FoundValid(IdentifierDiscriminatorSystemRequiredValue(
            id:,
            extension:,
            use_:,
            value:,
            type_:,
            period:,
            assigner:,
          ))
      }
    _ ->
      NotFound
  }
}

pub fn identifier_discriminator_system_required_value_to_json(
  identifier: IdentifierDiscriminatorSystemRequiredValue,
  system: String,
) -> Json {
  let IdentifierDiscriminatorSystemRequiredValue(
    id:,
    extension:,
    use_:,
    value:,
    type_:,
    period:,
    assigner:,
  ) = identifier
  identifier_to_json(Identifier(
    id:,
    extension:,
    use_:,
    type_:,
    system: Some(system),
    value: Some(value),
    period:,
    assigner:,
  ))
}
"
