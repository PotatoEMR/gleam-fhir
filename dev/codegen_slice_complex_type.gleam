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
"
