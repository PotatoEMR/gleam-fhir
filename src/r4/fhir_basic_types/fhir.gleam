//basic fhir data types (primitive, general, meta, special purpose)
//in one .gleam module because reference and identifier have cyclic definition
import gleam/option.{type Option}

//http://hl7.org/fhir/r4/StructureDefinition/Element#resource
pub type Element {
  Element(id: Option(String), extension: List(Extension))
}

//http://hl7.org/fhir/r4/StructureDefinition/Address#resource
pub type Address {
  Address(
    id: Option(String),
    extension: List(Extension),
    use_: Option(String),
    type_: Option(String),
    text: Option(String),
    line: List(String),
    city: Option(String),
    district: Option(String),
    state: Option(String),
    postal_code: Option(String),
    country: Option(String),
    period: Option(Period),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Age#resource
pub type Age {
  Age(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(String),
    unit: Option(String),
    system: Option(String),
    code: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Annotation#resource
pub type Annotation {
  Annotation(
    id: Option(String),
    extension: List(Extension),
    author: Option(Nil),
    time: Option(String),
    text: String,
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Attachment#resource
pub type Attachment {
  Attachment(
    id: Option(String),
    extension: List(Extension),
    content_type: Option(String),
    language: Option(String),
    data: Option(String),
    url: Option(String),
    size: Option(Int),
    hash: Option(String),
    title: Option(String),
    creation: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/CodeableConcept#resource
pub type Codeableconcept {
  Codeableconcept(
    id: Option(String),
    extension: List(Extension),
    coding: List(Coding),
    text: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Coding#resource
pub type Coding {
  Coding(
    id: Option(String),
    extension: List(Extension),
    system: Option(String),
    version: Option(String),
    code: Option(String),
    display: Option(String),
    user_selected: Option(Bool),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/ContactDetail#resource
pub type Contactdetail {
  Contactdetail(
    id: Option(String),
    extension: List(Extension),
    name: Option(String),
    telecom: List(Contactpoint),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/ContactPoint#resource
pub type Contactpoint {
  Contactpoint(
    id: Option(String),
    extension: List(Extension),
    system: Option(String),
    value: Option(String),
    use_: Option(String),
    rank: Option(Int),
    period: Option(Period),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Contributor#resource
pub type Contributor {
  Contributor(
    id: Option(String),
    extension: List(Extension),
    type_: String,
    name: String,
    contact: List(Contactdetail),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Count#resource
pub type Count {
  Count(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(String),
    unit: Option(String),
    system: Option(String),
    code: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/DataRequirement#resource
pub type Datarequirement {
  Datarequirement(
    id: Option(String),
    extension: List(Extension),
    type_: String,
    profile: List(String),
    subject: Option(Nil),
    must_support: List(String),
    code_filter: List(Element),
    date_filter: List(Element),
    limit: Option(Int),
    sort: List(Element),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Distance#resource
pub type Distance {
  Distance(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(String),
    unit: Option(String),
    system: Option(String),
    code: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Dosage#resource
pub type Dosage {
  Dosage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Option(Int),
    text: Option(String),
    additional_instruction: List(Codeableconcept),
    patient_instruction: Option(String),
    timing: Option(Timing),
    as_needed: Option(Nil),
    site: Option(Codeableconcept),
    route: Option(Codeableconcept),
    method: Option(Codeableconcept),
    dose_and_rate: List(Element),
    max_dose_per_period: Option(Ratio),
    max_dose_per_administration: Option(Quantity),
    max_dose_per_lifetime: Option(Quantity),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Duration#resource
pub type Duration {
  Duration(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(String),
    unit: Option(String),
    system: Option(String),
    code: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/ElementDefinition#resource
pub type Elementdefinition {
  Elementdefinition(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    path: String,
    representation: List(String),
    slice_name: Option(String),
    slice_is_constraining: Option(Bool),
    label: Option(String),
    code: List(Coding),
    slicing: Option(Element),
    short: Option(String),
    definition: Option(String),
    comment: Option(String),
    requirements: Option(String),
    alias: List(String),
    min: Option(Int),
    max: Option(String),
    base: Option(Element),
    content_reference: Option(String),
    type_: List(Element),
    default_value: Option(Nil),
    meaning_when_missing: Option(String),
    order_meaning: Option(String),
    fixed: Option(Nil),
    pattern: Option(Nil),
    example: List(Element),
    min_value: Option(Nil),
    max_value: Option(Nil),
    max_length: Option(Int),
    condition: List(String),
    constraint: List(Element),
    must_support: Option(Bool),
    is_modifier: Option(Bool),
    is_modifier_reason: Option(String),
    is_summary: Option(Bool),
    binding: Option(Element),
    mapping: List(Element),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Expression#resource
pub type Expression {
  Expression(
    id: Option(String),
    extension: List(Extension),
    description: Option(String),
    name: Option(String),
    language: String,
    expression: Option(String),
    reference: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Extension#resource
pub type Extension {
  Extension(
    id: Option(String),
    extension: List(Extension),
    url: String,
    value: Option(Nil),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/HumanName#resource
pub type Humanname {
  Humanname(
    id: Option(String),
    extension: List(Extension),
    use_: Option(String),
    text: Option(String),
    family: Option(String),
    given: List(String),
    prefix: List(String),
    suffix: List(String),
    period: Option(Period),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Identifier#resource
pub type Identifier {
  Identifier(
    id: Option(String),
    extension: List(Extension),
    use_: Option(String),
    type_: Option(Codeableconcept),
    system: Option(String),
    value: Option(String),
    period: Option(Period),
    assigner: Option(Reference),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MarketingStatus#resource
pub type Marketingstatus {
  Marketingstatus(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    country: Codeableconcept,
    jurisdiction: Option(Codeableconcept),
    status: Codeableconcept,
    date_range: Period,
    restore_date: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Meta#resource
pub type Meta {
  Meta(
    id: Option(String),
    extension: List(Extension),
    version_id: Option(String),
    last_updated: Option(String),
    source: Option(String),
    profile: List(String),
    security: List(Coding),
    tag: List(Coding),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Money#resource
pub type Money {
  Money(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    currency: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Narrative#resource
pub type Narrative {
  Narrative(
    id: Option(String),
    extension: List(Extension),
    status: String,
    div: String,
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/ParameterDefinition#resource
pub type Parameterdefinition {
  Parameterdefinition(
    id: Option(String),
    extension: List(Extension),
    name: Option(String),
    use_: String,
    min: Option(Int),
    max: Option(String),
    documentation: Option(String),
    type_: String,
    profile: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Period#resource
pub type Period {
  Period(
    id: Option(String),
    extension: List(Extension),
    start: Option(String),
    end: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Population#resource
pub type Population {
  Population(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    age: Option(Nil),
    gender: Option(Codeableconcept),
    race: Option(Codeableconcept),
    physiological_condition: Option(Codeableconcept),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/ProdCharacteristic#resource
pub type Prodcharacteristic {
  Prodcharacteristic(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    height: Option(Quantity),
    width: Option(Quantity),
    depth: Option(Quantity),
    weight: Option(Quantity),
    nominal_volume: Option(Quantity),
    external_diameter: Option(Quantity),
    shape: Option(String),
    color: List(String),
    imprint: List(String),
    image: List(Attachment),
    scoring: Option(Codeableconcept),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/ProductShelfLife#resource
pub type Productshelflife {
  Productshelflife(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Option(Identifier),
    type_: Codeableconcept,
    period: Quantity,
    special_precautions_for_storage: List(Codeableconcept),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Quantity#resource
pub type Quantity {
  Quantity(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(String),
    unit: Option(String),
    system: Option(String),
    code: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Range#resource
pub type Range {
  Range(
    id: Option(String),
    extension: List(Extension),
    low: Option(Quantity),
    high: Option(Quantity),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Ratio#resource
pub type Ratio {
  Ratio(
    id: Option(String),
    extension: List(Extension),
    numerator: Option(Quantity),
    denominator: Option(Quantity),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Reference#resource
pub type Reference {
  Reference(
    id: Option(String),
    extension: List(Extension),
    reference: Option(String),
    type_: Option(String),
    identifier: Option(Identifier),
    display: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/RelatedArtifact#resource
pub type Relatedartifact {
  Relatedartifact(
    id: Option(String),
    extension: List(Extension),
    type_: String,
    label: Option(String),
    display: Option(String),
    citation: Option(String),
    url: Option(String),
    document: Option(Attachment),
    resource: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SampledData#resource
pub type Sampleddata {
  Sampleddata(
    id: Option(String),
    extension: List(Extension),
    origin: Quantity,
    period: Float,
    factor: Option(Float),
    lower_limit: Option(Float),
    upper_limit: Option(Float),
    dimensions: Int,
    data: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Signature#resource
pub type Signature {
  Signature(
    id: Option(String),
    extension: List(Extension),
    type_: List(Coding),
    when: String,
    who: Reference,
    on_behalf_of: Option(Reference),
    target_format: Option(String),
    sig_format: Option(String),
    data: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SubstanceAmount#resource
pub type Substanceamount {
  Substanceamount(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    amount: Option(Nil),
    amount_type: Option(Codeableconcept),
    amount_text: Option(String),
    reference_range: Option(Element),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/Timing#resource
pub type Timing {
  Timing(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    event: List(String),
    repeat: Option(Element),
    code: Option(Codeableconcept),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/TriggerDefinition#resource
pub type Triggerdefinition {
  Triggerdefinition(
    id: Option(String),
    extension: List(Extension),
    type_: String,
    name: Option(String),
    timing: Option(Nil),
    data: List(Datarequirement),
    condition: Option(Expression),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/UsageContext#resource
pub type Usagecontext {
  Usagecontext(
    id: Option(String),
    extension: List(Extension),
    code: Coding,
    value: Nil,
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/MoneyQuantity#resource
pub type Moneyquantity {
  Moneyquantity(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(String),
    unit: Option(String),
    system: Option(String),
    code: Option(String),
  )
}

//http://hl7.org/fhir/r4/StructureDefinition/SimpleQuantity#resource
pub type Simplequantity {
  Simplequantity(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(String),
    unit: Option(String),
    system: Option(String),
    code: Option(String),
  )
}
