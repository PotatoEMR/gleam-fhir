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

pub fn codeableconcept_discriminator_from_codeableconcept(
  concept: Codeableconcept,
  system: String,
  code: String,
) -> Result(CodeableconceptDiscriminator, Nil) {
  let Codeableconcept(id:, extension:, coding:, text:) = concept
  case find_elt_and_rest(
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
        Error(Nil) -> Error(Nil)
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

pub fn identifier_discriminator_system_required_value_from_identifier(
   identifier: Identifier,
   expected_system: String,
 ) -> Result(
   Result(IdentifierDiscriminatorSystemRequiredValue, Nil),
   Nil,
 ) {
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
     Some(system) ->
       case system == expected_system {
         False -> Error(Nil)
         True ->
           case value {
             None -> Ok(Error(Nil))
             Some(value) ->
               Ok(Ok(IdentifierDiscriminatorSystemRequiredValue(
                 id:,
                 extension:,
                 use_:,
                 value:,
                 type_:,
                 period:,
                 assigner:,
               )))
           }
       }
     None -> Error(Nil)
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
