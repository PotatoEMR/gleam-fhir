////FHIR r5 types
////https://hl7.org/fhir/r5

import gleam/option.{type Option}

///http://hl7.org/fhir/r5/StructureDefinition/Element#resource
pub type Element {
  Element(id: Option(String), extension: List(Extension))
}

///http://hl7.org/fhir/r5/StructureDefinition/Address#resource
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

///http://hl7.org/fhir/r5/StructureDefinition/Age#resource
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

///http://hl7.org/fhir/r5/StructureDefinition/Annotation#resource
pub type Annotation {
  Annotation(
    id: Option(String),
    extension: List(Extension),
    author: Option(AnnotationAuthor),
    time: Option(String),
    text: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Annotation#resource
pub type AnnotationAuthor {
  AnnotationAuthorReference(author: Reference)
  AnnotationAuthorString(author: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/Attachment#resource
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
    height: Option(Int),
    width: Option(Int),
    frames: Option(Int),
    duration: Option(Float),
    pages: Option(Int),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Availability#resource
pub type Availability {
  Availability(
    id: Option(String),
    extension: List(Extension),
    available_time: List(Element),
    not_available_time: List(Element),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/BackboneType#resource
pub type Backbonetype {
  Backbonetype(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CodeableConcept#resource
pub type Codeableconcept {
  Codeableconcept(
    id: Option(String),
    extension: List(Extension),
    coding: List(Coding),
    text: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CodeableReference#resource
pub type Codeablereference {
  Codeablereference(
    id: Option(String),
    extension: List(Extension),
    concept: Option(Codeableconcept),
    reference: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Coding#resource
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

///http://hl7.org/fhir/r5/StructureDefinition/ContactDetail#resource
pub type Contactdetail {
  Contactdetail(
    id: Option(String),
    extension: List(Extension),
    name: Option(String),
    telecom: List(Contactpoint),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ContactPoint#resource
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

///http://hl7.org/fhir/r5/StructureDefinition/Contributor#resource
pub type Contributor {
  Contributor(
    id: Option(String),
    extension: List(Extension),
    type_: String,
    name: String,
    contact: List(Contactdetail),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Count#resource
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

///http://hl7.org/fhir/r5/StructureDefinition/DataRequirement#resource
pub type Datarequirement {
  Datarequirement(
    id: Option(String),
    extension: List(Extension),
    type_: String,
    profile: List(String),
    subject: Option(DatarequirementSubject),
    must_support: List(String),
    code_filter: List(Element),
    date_filter: List(Element),
    value_filter: List(Element),
    limit: Option(Int),
    sort: List(Element),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DataRequirement#resource
pub type DatarequirementSubject {
  DatarequirementSubjectCodeableconcept(subject: Codeableconcept)
  DatarequirementSubjectReference(subject: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/DataType#resource
pub type Datatype {
  Datatype(id: Option(String), extension: List(Extension))
}

///http://hl7.org/fhir/r5/StructureDefinition/Distance#resource
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

///http://hl7.org/fhir/r5/StructureDefinition/Dosage#resource
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
    as_needed: Option(Bool),
    as_needed_for: List(Codeableconcept),
    site: Option(Codeableconcept),
    route: Option(Codeableconcept),
    method: Option(Codeableconcept),
    dose_and_rate: List(Element),
    max_dose_per_period: List(Ratio),
    max_dose_per_administration: Option(Quantity),
    max_dose_per_lifetime: Option(Quantity),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Duration#resource
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

///http://hl7.org/fhir/r5/StructureDefinition/ElementDefinition#resource
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
    default_value: Option(ElementdefinitionDefaultvalue),
    meaning_when_missing: Option(String),
    order_meaning: Option(String),
    fixed: Option(ElementdefinitionFixed),
    pattern: Option(ElementdefinitionPattern),
    example: List(Element),
    min_value: Option(ElementdefinitionMinvalue),
    max_value: Option(ElementdefinitionMaxvalue),
    max_length: Option(Int),
    condition: List(String),
    constraint: List(Element),
    must_have_value: Option(Bool),
    value_alternatives: List(String),
    must_support: Option(Bool),
    is_modifier: Option(Bool),
    is_modifier_reason: Option(String),
    is_summary: Option(Bool),
    binding: Option(Element),
    mapping: List(Element),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ElementDefinition#resource
pub type ElementdefinitionDefaultvalue {
  ElementdefinitionDefaultvalueBase64binary(default_value: String)
  ElementdefinitionDefaultvalueBoolean(default_value: Bool)
  ElementdefinitionDefaultvalueCanonical(default_value: String)
  ElementdefinitionDefaultvalueCode(default_value: String)
  ElementdefinitionDefaultvalueDate(default_value: String)
  ElementdefinitionDefaultvalueDatetime(default_value: String)
  ElementdefinitionDefaultvalueDecimal(default_value: Float)
  ElementdefinitionDefaultvalueId(default_value: String)
  ElementdefinitionDefaultvalueInstant(default_value: String)
  ElementdefinitionDefaultvalueInteger(default_value: Int)
  ElementdefinitionDefaultvalueInteger64(default_value: Int)
  ElementdefinitionDefaultvalueMarkdown(default_value: String)
  ElementdefinitionDefaultvalueOid(default_value: String)
  ElementdefinitionDefaultvaluePositiveint(default_value: Int)
  ElementdefinitionDefaultvalueString(default_value: String)
  ElementdefinitionDefaultvalueTime(default_value: String)
  ElementdefinitionDefaultvalueUnsignedint(default_value: Int)
  ElementdefinitionDefaultvalueUri(default_value: String)
  ElementdefinitionDefaultvalueUrl(default_value: String)
  ElementdefinitionDefaultvalueUuid(default_value: String)
  ElementdefinitionDefaultvalueAddress(default_value: Address)
  ElementdefinitionDefaultvalueAge(default_value: Age)
  ElementdefinitionDefaultvalueAnnotation(default_value: Annotation)
  ElementdefinitionDefaultvalueAttachment(default_value: Attachment)
  ElementdefinitionDefaultvalueCodeableconcept(default_value: Codeableconcept)
  ElementdefinitionDefaultvalueCodeablereference(
    default_value: Codeablereference,
  )
  ElementdefinitionDefaultvalueCoding(default_value: Coding)
  ElementdefinitionDefaultvalueContactpoint(default_value: Contactpoint)
  ElementdefinitionDefaultvalueCount(default_value: Count)
  ElementdefinitionDefaultvalueDistance(default_value: Distance)
  ElementdefinitionDefaultvalueDuration(default_value: Duration)
  ElementdefinitionDefaultvalueHumanname(default_value: Humanname)
  ElementdefinitionDefaultvalueIdentifier(default_value: Identifier)
  ElementdefinitionDefaultvalueMoney(default_value: Money)
  ElementdefinitionDefaultvaluePeriod(default_value: Period)
  ElementdefinitionDefaultvalueQuantity(default_value: Quantity)
  ElementdefinitionDefaultvalueRange(default_value: Range)
  ElementdefinitionDefaultvalueRatio(default_value: Ratio)
  ElementdefinitionDefaultvalueRatiorange(default_value: Ratiorange)
  ElementdefinitionDefaultvalueReference(default_value: Reference)
  ElementdefinitionDefaultvalueSampleddata(default_value: Sampleddata)
  ElementdefinitionDefaultvalueSignature(default_value: Signature)
  ElementdefinitionDefaultvalueTiming(default_value: Timing)
  ElementdefinitionDefaultvalueContactdetail(default_value: Contactdetail)
  ElementdefinitionDefaultvalueDatarequirement(default_value: Datarequirement)
  ElementdefinitionDefaultvalueExpression(default_value: Expression)
  ElementdefinitionDefaultvalueParameterdefinition(
    default_value: Parameterdefinition,
  )
  ElementdefinitionDefaultvalueRelatedartifact(default_value: Relatedartifact)
  ElementdefinitionDefaultvalueTriggerdefinition(
    default_value: Triggerdefinition,
  )
  ElementdefinitionDefaultvalueUsagecontext(default_value: Usagecontext)
  ElementdefinitionDefaultvalueAvailability(default_value: Availability)
  ElementdefinitionDefaultvalueExtendedcontactdetail(
    default_value: Extendedcontactdetail,
  )
  ElementdefinitionDefaultvalueDosage(default_value: Dosage)
  ElementdefinitionDefaultvalueMeta(default_value: Meta)
}

///http://hl7.org/fhir/r5/StructureDefinition/ElementDefinition#resource
pub type ElementdefinitionFixed {
  ElementdefinitionFixedBase64binary(fixed: String)
  ElementdefinitionFixedBoolean(fixed: Bool)
  ElementdefinitionFixedCanonical(fixed: String)
  ElementdefinitionFixedCode(fixed: String)
  ElementdefinitionFixedDate(fixed: String)
  ElementdefinitionFixedDatetime(fixed: String)
  ElementdefinitionFixedDecimal(fixed: Float)
  ElementdefinitionFixedId(fixed: String)
  ElementdefinitionFixedInstant(fixed: String)
  ElementdefinitionFixedInteger(fixed: Int)
  ElementdefinitionFixedInteger64(fixed: Int)
  ElementdefinitionFixedMarkdown(fixed: String)
  ElementdefinitionFixedOid(fixed: String)
  ElementdefinitionFixedPositiveint(fixed: Int)
  ElementdefinitionFixedString(fixed: String)
  ElementdefinitionFixedTime(fixed: String)
  ElementdefinitionFixedUnsignedint(fixed: Int)
  ElementdefinitionFixedUri(fixed: String)
  ElementdefinitionFixedUrl(fixed: String)
  ElementdefinitionFixedUuid(fixed: String)
  ElementdefinitionFixedAddress(fixed: Address)
  ElementdefinitionFixedAge(fixed: Age)
  ElementdefinitionFixedAnnotation(fixed: Annotation)
  ElementdefinitionFixedAttachment(fixed: Attachment)
  ElementdefinitionFixedCodeableconcept(fixed: Codeableconcept)
  ElementdefinitionFixedCodeablereference(fixed: Codeablereference)
  ElementdefinitionFixedCoding(fixed: Coding)
  ElementdefinitionFixedContactpoint(fixed: Contactpoint)
  ElementdefinitionFixedCount(fixed: Count)
  ElementdefinitionFixedDistance(fixed: Distance)
  ElementdefinitionFixedDuration(fixed: Duration)
  ElementdefinitionFixedHumanname(fixed: Humanname)
  ElementdefinitionFixedIdentifier(fixed: Identifier)
  ElementdefinitionFixedMoney(fixed: Money)
  ElementdefinitionFixedPeriod(fixed: Period)
  ElementdefinitionFixedQuantity(fixed: Quantity)
  ElementdefinitionFixedRange(fixed: Range)
  ElementdefinitionFixedRatio(fixed: Ratio)
  ElementdefinitionFixedRatiorange(fixed: Ratiorange)
  ElementdefinitionFixedReference(fixed: Reference)
  ElementdefinitionFixedSampleddata(fixed: Sampleddata)
  ElementdefinitionFixedSignature(fixed: Signature)
  ElementdefinitionFixedTiming(fixed: Timing)
  ElementdefinitionFixedContactdetail(fixed: Contactdetail)
  ElementdefinitionFixedDatarequirement(fixed: Datarequirement)
  ElementdefinitionFixedExpression(fixed: Expression)
  ElementdefinitionFixedParameterdefinition(fixed: Parameterdefinition)
  ElementdefinitionFixedRelatedartifact(fixed: Relatedartifact)
  ElementdefinitionFixedTriggerdefinition(fixed: Triggerdefinition)
  ElementdefinitionFixedUsagecontext(fixed: Usagecontext)
  ElementdefinitionFixedAvailability(fixed: Availability)
  ElementdefinitionFixedExtendedcontactdetail(fixed: Extendedcontactdetail)
  ElementdefinitionFixedDosage(fixed: Dosage)
  ElementdefinitionFixedMeta(fixed: Meta)
}

///http://hl7.org/fhir/r5/StructureDefinition/ElementDefinition#resource
pub type ElementdefinitionPattern {
  ElementdefinitionPatternBase64binary(pattern: String)
  ElementdefinitionPatternBoolean(pattern: Bool)
  ElementdefinitionPatternCanonical(pattern: String)
  ElementdefinitionPatternCode(pattern: String)
  ElementdefinitionPatternDate(pattern: String)
  ElementdefinitionPatternDatetime(pattern: String)
  ElementdefinitionPatternDecimal(pattern: Float)
  ElementdefinitionPatternId(pattern: String)
  ElementdefinitionPatternInstant(pattern: String)
  ElementdefinitionPatternInteger(pattern: Int)
  ElementdefinitionPatternInteger64(pattern: Int)
  ElementdefinitionPatternMarkdown(pattern: String)
  ElementdefinitionPatternOid(pattern: String)
  ElementdefinitionPatternPositiveint(pattern: Int)
  ElementdefinitionPatternString(pattern: String)
  ElementdefinitionPatternTime(pattern: String)
  ElementdefinitionPatternUnsignedint(pattern: Int)
  ElementdefinitionPatternUri(pattern: String)
  ElementdefinitionPatternUrl(pattern: String)
  ElementdefinitionPatternUuid(pattern: String)
  ElementdefinitionPatternAddress(pattern: Address)
  ElementdefinitionPatternAge(pattern: Age)
  ElementdefinitionPatternAnnotation(pattern: Annotation)
  ElementdefinitionPatternAttachment(pattern: Attachment)
  ElementdefinitionPatternCodeableconcept(pattern: Codeableconcept)
  ElementdefinitionPatternCodeablereference(pattern: Codeablereference)
  ElementdefinitionPatternCoding(pattern: Coding)
  ElementdefinitionPatternContactpoint(pattern: Contactpoint)
  ElementdefinitionPatternCount(pattern: Count)
  ElementdefinitionPatternDistance(pattern: Distance)
  ElementdefinitionPatternDuration(pattern: Duration)
  ElementdefinitionPatternHumanname(pattern: Humanname)
  ElementdefinitionPatternIdentifier(pattern: Identifier)
  ElementdefinitionPatternMoney(pattern: Money)
  ElementdefinitionPatternPeriod(pattern: Period)
  ElementdefinitionPatternQuantity(pattern: Quantity)
  ElementdefinitionPatternRange(pattern: Range)
  ElementdefinitionPatternRatio(pattern: Ratio)
  ElementdefinitionPatternRatiorange(pattern: Ratiorange)
  ElementdefinitionPatternReference(pattern: Reference)
  ElementdefinitionPatternSampleddata(pattern: Sampleddata)
  ElementdefinitionPatternSignature(pattern: Signature)
  ElementdefinitionPatternTiming(pattern: Timing)
  ElementdefinitionPatternContactdetail(pattern: Contactdetail)
  ElementdefinitionPatternDatarequirement(pattern: Datarequirement)
  ElementdefinitionPatternExpression(pattern: Expression)
  ElementdefinitionPatternParameterdefinition(pattern: Parameterdefinition)
  ElementdefinitionPatternRelatedartifact(pattern: Relatedartifact)
  ElementdefinitionPatternTriggerdefinition(pattern: Triggerdefinition)
  ElementdefinitionPatternUsagecontext(pattern: Usagecontext)
  ElementdefinitionPatternAvailability(pattern: Availability)
  ElementdefinitionPatternExtendedcontactdetail(pattern: Extendedcontactdetail)
  ElementdefinitionPatternDosage(pattern: Dosage)
  ElementdefinitionPatternMeta(pattern: Meta)
}

///http://hl7.org/fhir/r5/StructureDefinition/ElementDefinition#resource
pub type ElementdefinitionMinvalue {
  ElementdefinitionMinvalueDate(min_value: String)
  ElementdefinitionMinvalueDatetime(min_value: String)
  ElementdefinitionMinvalueInstant(min_value: String)
  ElementdefinitionMinvalueTime(min_value: String)
  ElementdefinitionMinvalueDecimal(min_value: Float)
  ElementdefinitionMinvalueInteger(min_value: Int)
  ElementdefinitionMinvalueInteger64(min_value: Int)
  ElementdefinitionMinvaluePositiveint(min_value: Int)
  ElementdefinitionMinvalueUnsignedint(min_value: Int)
  ElementdefinitionMinvalueQuantity(min_value: Quantity)
}

///http://hl7.org/fhir/r5/StructureDefinition/ElementDefinition#resource
pub type ElementdefinitionMaxvalue {
  ElementdefinitionMaxvalueDate(max_value: String)
  ElementdefinitionMaxvalueDatetime(max_value: String)
  ElementdefinitionMaxvalueInstant(max_value: String)
  ElementdefinitionMaxvalueTime(max_value: String)
  ElementdefinitionMaxvalueDecimal(max_value: Float)
  ElementdefinitionMaxvalueInteger(max_value: Int)
  ElementdefinitionMaxvalueInteger64(max_value: Int)
  ElementdefinitionMaxvaluePositiveint(max_value: Int)
  ElementdefinitionMaxvalueUnsignedint(max_value: Int)
  ElementdefinitionMaxvalueQuantity(max_value: Quantity)
}

///http://hl7.org/fhir/r5/StructureDefinition/Expression#resource
pub type Expression {
  Expression(
    id: Option(String),
    extension: List(Extension),
    description: Option(String),
    name: Option(String),
    language: Option(String),
    expression: Option(String),
    reference: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExtendedContactDetail#resource
pub type Extendedcontactdetail {
  Extendedcontactdetail(
    id: Option(String),
    extension: List(Extension),
    purpose: Option(Codeableconcept),
    name: List(Humanname),
    telecom: List(Contactpoint),
    address: Option(Address),
    organization: Option(Reference),
    period: Option(Period),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Extension#resource
pub type Extension {
  Extension(
    id: Option(String),
    extension: List(Extension),
    url: String,
    value: Option(ExtensionValue),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Extension#resource
pub type ExtensionValue {
  ExtensionValueBase64binary(value: String)
  ExtensionValueBoolean(value: Bool)
  ExtensionValueCanonical(value: String)
  ExtensionValueCode(value: String)
  ExtensionValueDate(value: String)
  ExtensionValueDatetime(value: String)
  ExtensionValueDecimal(value: Float)
  ExtensionValueId(value: String)
  ExtensionValueInstant(value: String)
  ExtensionValueInteger(value: Int)
  ExtensionValueInteger64(value: Int)
  ExtensionValueMarkdown(value: String)
  ExtensionValueOid(value: String)
  ExtensionValuePositiveint(value: Int)
  ExtensionValueString(value: String)
  ExtensionValueTime(value: String)
  ExtensionValueUnsignedint(value: Int)
  ExtensionValueUri(value: String)
  ExtensionValueUrl(value: String)
  ExtensionValueUuid(value: String)
  ExtensionValueAddress(value: Address)
  ExtensionValueAge(value: Age)
  ExtensionValueAnnotation(value: Annotation)
  ExtensionValueAttachment(value: Attachment)
  ExtensionValueCodeableconcept(value: Codeableconcept)
  ExtensionValueCodeablereference(value: Codeablereference)
  ExtensionValueCoding(value: Coding)
  ExtensionValueContactpoint(value: Contactpoint)
  ExtensionValueCount(value: Count)
  ExtensionValueDistance(value: Distance)
  ExtensionValueDuration(value: Duration)
  ExtensionValueHumanname(value: Humanname)
  ExtensionValueIdentifier(value: Identifier)
  ExtensionValueMoney(value: Money)
  ExtensionValuePeriod(value: Period)
  ExtensionValueQuantity(value: Quantity)
  ExtensionValueRange(value: Range)
  ExtensionValueRatio(value: Ratio)
  ExtensionValueRatiorange(value: Ratiorange)
  ExtensionValueReference(value: Reference)
  ExtensionValueSampleddata(value: Sampleddata)
  ExtensionValueSignature(value: Signature)
  ExtensionValueTiming(value: Timing)
  ExtensionValueContactdetail(value: Contactdetail)
  ExtensionValueDatarequirement(value: Datarequirement)
  ExtensionValueExpression(value: Expression)
  ExtensionValueParameterdefinition(value: Parameterdefinition)
  ExtensionValueRelatedartifact(value: Relatedartifact)
  ExtensionValueTriggerdefinition(value: Triggerdefinition)
  ExtensionValueUsagecontext(value: Usagecontext)
  ExtensionValueAvailability(value: Availability)
  ExtensionValueExtendedcontactdetail(value: Extendedcontactdetail)
  ExtensionValueDosage(value: Dosage)
  ExtensionValueMeta(value: Meta)
}

///http://hl7.org/fhir/r5/StructureDefinition/HumanName#resource
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

///http://hl7.org/fhir/r5/StructureDefinition/Identifier#resource
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

///http://hl7.org/fhir/r5/StructureDefinition/MarketingStatus#resource
pub type Marketingstatus {
  Marketingstatus(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    country: Option(Codeableconcept),
    jurisdiction: Option(Codeableconcept),
    status: Codeableconcept,
    date_range: Option(Period),
    restore_date: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Meta#resource
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

///http://hl7.org/fhir/r5/StructureDefinition/MonetaryComponent#resource
pub type Monetarycomponent {
  Monetarycomponent(
    id: Option(String),
    extension: List(Extension),
    type_: String,
    code: Option(Codeableconcept),
    factor: Option(Float),
    amount: Option(Money),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Money#resource
pub type Money {
  Money(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    currency: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Narrative#resource
pub type Narrative {
  Narrative(
    id: Option(String),
    extension: List(Extension),
    status: String,
    div: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ParameterDefinition#resource
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

///http://hl7.org/fhir/r5/StructureDefinition/Period#resource
pub type Period {
  Period(
    id: Option(String),
    extension: List(Extension),
    start: Option(String),
    end: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/PrimitiveType#resource
pub type Primitivetype {
  Primitivetype(id: Option(String), extension: List(Extension))
}

///http://hl7.org/fhir/r5/StructureDefinition/ProductShelfLife#resource
pub type Productshelflife {
  Productshelflife(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    period: Option(ProductshelflifePeriod),
    special_precautions_for_storage: List(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ProductShelfLife#resource
pub type ProductshelflifePeriod {
  ProductshelflifePeriodDuration(period: Duration)
  ProductshelflifePeriodString(period: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/Quantity#resource
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

///http://hl7.org/fhir/r5/StructureDefinition/Range#resource
pub type Range {
  Range(
    id: Option(String),
    extension: List(Extension),
    low: Option(Quantity),
    high: Option(Quantity),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Ratio#resource
pub type Ratio {
  Ratio(
    id: Option(String),
    extension: List(Extension),
    numerator: Option(Quantity),
    denominator: Option(Quantity),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/RatioRange#resource
pub type Ratiorange {
  Ratiorange(
    id: Option(String),
    extension: List(Extension),
    low_numerator: Option(Quantity),
    high_numerator: Option(Quantity),
    denominator: Option(Quantity),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Reference#resource
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

///http://hl7.org/fhir/r5/StructureDefinition/RelatedArtifact#resource
pub type Relatedartifact {
  Relatedartifact(
    id: Option(String),
    extension: List(Extension),
    type_: String,
    classifier: List(Codeableconcept),
    label: Option(String),
    display: Option(String),
    citation: Option(String),
    document: Option(Attachment),
    resource: Option(String),
    resource_reference: Option(Reference),
    publication_status: Option(String),
    publication_date: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SampledData#resource
pub type Sampleddata {
  Sampleddata(
    id: Option(String),
    extension: List(Extension),
    origin: Quantity,
    interval: Option(Float),
    interval_unit: String,
    factor: Option(Float),
    lower_limit: Option(Float),
    upper_limit: Option(Float),
    dimensions: Int,
    code_map: Option(String),
    offsets: Option(String),
    data: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Signature#resource
pub type Signature {
  Signature(
    id: Option(String),
    extension: List(Extension),
    type_: List(Coding),
    when: Option(String),
    who: Option(Reference),
    on_behalf_of: Option(Reference),
    target_format: Option(String),
    sig_format: Option(String),
    data: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Timing#resource
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

///http://hl7.org/fhir/r5/StructureDefinition/TriggerDefinition#resource
pub type Triggerdefinition {
  Triggerdefinition(
    id: Option(String),
    extension: List(Extension),
    type_: String,
    name: Option(String),
    code: Option(Codeableconcept),
    subscription_topic: Option(String),
    timing: Option(TriggerdefinitionTiming),
    data: List(Datarequirement),
    condition: Option(Expression),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TriggerDefinition#resource
pub type TriggerdefinitionTiming {
  TriggerdefinitionTimingTiming(timing: Timing)
  TriggerdefinitionTimingReference(timing: Reference)
  TriggerdefinitionTimingDate(timing: String)
  TriggerdefinitionTimingDatetime(timing: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/UsageContext#resource
pub type Usagecontext {
  Usagecontext(
    id: Option(String),
    extension: List(Extension),
    code: Coding,
    value: UsagecontextValue,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/UsageContext#resource
pub type UsagecontextValue {
  UsagecontextValueCodeableconcept(value: Codeableconcept)
  UsagecontextValueQuantity(value: Quantity)
  UsagecontextValueRange(value: Range)
  UsagecontextValueReference(value: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/VirtualServiceDetail#resource
pub type Virtualservicedetail {
  Virtualservicedetail(
    id: Option(String),
    extension: List(Extension),
    channel_type: Option(Coding),
    address: Option(VirtualservicedetailAddress),
    additional_info: List(String),
    max_participants: Option(Int),
    session_key: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/VirtualServiceDetail#resource
pub type VirtualservicedetailAddress {
  VirtualservicedetailAddressUrl(address: String)
  VirtualservicedetailAddressString(address: String)
  VirtualservicedetailAddressContactpoint(address: Contactpoint)
  VirtualservicedetailAddressExtendedcontactdetail(
    address: Extendedcontactdetail,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MoneyQuantity#resource
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

///http://hl7.org/fhir/r5/StructureDefinition/SimpleQuantity#resource
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

///http://hl7.org/fhir/r5/StructureDefinition/Resource#resource
pub type Resource {
  Resource(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Account#resource
pub type Account {
  Account(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    billing_status: Option(Codeableconcept),
    type_: Option(Codeableconcept),
    name: Option(String),
    subject: List(Reference),
    service_period: Option(Period),
    coverage: List(AccountCoverage),
    owner: Option(Reference),
    description: Option(String),
    guarantor: List(AccountGuarantor),
    diagnosis: List(AccountDiagnosis),
    procedure: List(AccountProcedure),
    related_account: List(AccountRelatedaccount),
    currency: Option(Codeableconcept),
    balance: List(AccountBalance),
    calculated_at: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Account#resource
pub type AccountCoverage {
  AccountCoverage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    coverage: Reference,
    priority: Option(Int),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Account#resource
pub type AccountGuarantor {
  AccountGuarantor(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    party: Reference,
    on_hold: Option(Bool),
    period: Option(Period),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Account#resource
pub type AccountDiagnosis {
  AccountDiagnosis(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Option(Int),
    condition: Codeablereference,
    date_of_diagnosis: Option(String),
    type_: List(Codeableconcept),
    on_admission: Option(Bool),
    package_code: List(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Account#resource
pub type AccountProcedure {
  AccountProcedure(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Option(Int),
    code: Codeablereference,
    date_of_service: Option(String),
    type_: List(Codeableconcept),
    package_code: List(Codeableconcept),
    device: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Account#resource
pub type AccountRelatedaccount {
  AccountRelatedaccount(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    relationship: Option(Codeableconcept),
    account: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Account#resource
pub type AccountBalance {
  AccountBalance(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    aggregate: Option(Codeableconcept),
    term: Option(Codeableconcept),
    estimate: Option(Bool),
    amount: Money,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ActivityDefinition#resource
pub type Activitydefinition {
  Activitydefinition(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(ActivitydefinitionVersionalgorithm),
    name: Option(String),
    title: Option(String),
    subtitle: Option(String),
    status: String,
    experimental: Option(Bool),
    subject: Option(ActivitydefinitionSubject),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    usage: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    approval_date: Option(String),
    last_review_date: Option(String),
    effective_period: Option(Period),
    topic: List(Codeableconcept),
    author: List(Contactdetail),
    editor: List(Contactdetail),
    reviewer: List(Contactdetail),
    endorser: List(Contactdetail),
    related_artifact: List(Relatedartifact),
    library: List(String),
    kind: Option(String),
    profile: Option(String),
    code: Option(Codeableconcept),
    intent: Option(String),
    priority: Option(String),
    do_not_perform: Option(Bool),
    timing: Option(ActivitydefinitionTiming),
    as_needed: Option(ActivitydefinitionAsneeded),
    location: Option(Codeablereference),
    participant: List(ActivitydefinitionParticipant),
    product: Option(ActivitydefinitionProduct),
    quantity: Option(Quantity),
    dosage: List(Dosage),
    body_site: List(Codeableconcept),
    specimen_requirement: List(String),
    observation_requirement: List(String),
    observation_result_requirement: List(String),
    transform: Option(String),
    dynamic_value: List(ActivitydefinitionDynamicvalue),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ActivityDefinition#resource
pub type ActivitydefinitionVersionalgorithm {
  ActivitydefinitionVersionalgorithmString(version_algorithm: String)
  ActivitydefinitionVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/ActivityDefinition#resource
pub type ActivitydefinitionSubject {
  ActivitydefinitionSubjectCodeableconcept(subject: Codeableconcept)
  ActivitydefinitionSubjectReference(subject: Reference)
  ActivitydefinitionSubjectCanonical(subject: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/ActivityDefinition#resource
pub type ActivitydefinitionTiming {
  ActivitydefinitionTimingTiming(timing: Timing)
  ActivitydefinitionTimingAge(timing: Age)
  ActivitydefinitionTimingRange(timing: Range)
  ActivitydefinitionTimingDuration(timing: Duration)
}

///http://hl7.org/fhir/r5/StructureDefinition/ActivityDefinition#resource
pub type ActivitydefinitionAsneeded {
  ActivitydefinitionAsneededBoolean(as_needed: Bool)
  ActivitydefinitionAsneededCodeableconcept(as_needed: Codeableconcept)
}

///http://hl7.org/fhir/r5/StructureDefinition/ActivityDefinition#resource
pub type ActivitydefinitionProduct {
  ActivitydefinitionProductReference(product: Reference)
  ActivitydefinitionProductCodeableconcept(product: Codeableconcept)
}

///http://hl7.org/fhir/r5/StructureDefinition/ActivityDefinition#resource
pub type ActivitydefinitionParticipant {
  ActivitydefinitionParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(String),
    type_canonical: Option(String),
    type_reference: Option(Reference),
    role: Option(Codeableconcept),
    function: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ActivityDefinition#resource
pub type ActivitydefinitionDynamicvalue {
  ActivitydefinitionDynamicvalue(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    path: String,
    expression: Expression,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ActorDefinition#resource
pub type Actordefinition {
  Actordefinition(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(ActordefinitionVersionalgorithm),
    name: Option(String),
    title: Option(String),
    status: String,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    type_: String,
    documentation: Option(String),
    reference: List(String),
    capabilities: Option(String),
    derived_from: List(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ActorDefinition#resource
pub type ActordefinitionVersionalgorithm {
  ActordefinitionVersionalgorithmString(version_algorithm: String)
  ActordefinitionVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/AdministrableProductDefinition#resource
pub type Administrableproductdefinition {
  Administrableproductdefinition(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    form_of: List(Reference),
    administrable_dose_form: Option(Codeableconcept),
    unit_of_presentation: Option(Codeableconcept),
    produced_from: List(Reference),
    ingredient: List(Codeableconcept),
    device: Option(Reference),
    description: Option(String),
    property: List(AdministrableproductdefinitionProperty),
    route_of_administration: List(
      AdministrableproductdefinitionRouteofadministration,
    ),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/AdministrableProductDefinition#resource
pub type AdministrableproductdefinitionProperty {
  AdministrableproductdefinitionProperty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value: Option(AdministrableproductdefinitionPropertyValue),
    status: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/AdministrableProductDefinition#resource
pub type AdministrableproductdefinitionPropertyValue {
  AdministrableproductdefinitionPropertyValueCodeableconcept(
    value: Codeableconcept,
  )
  AdministrableproductdefinitionPropertyValueQuantity(value: Quantity)
  AdministrableproductdefinitionPropertyValueDate(value: String)
  AdministrableproductdefinitionPropertyValueBoolean(value: Bool)
  AdministrableproductdefinitionPropertyValueMarkdown(value: String)
  AdministrableproductdefinitionPropertyValueAttachment(value: Attachment)
  AdministrableproductdefinitionPropertyValueReference(value: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/AdministrableProductDefinition#resource
pub type AdministrableproductdefinitionRouteofadministration {
  AdministrableproductdefinitionRouteofadministration(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
    first_dose: Option(Quantity),
    max_single_dose: Option(Quantity),
    max_dose_per_day: Option(Quantity),
    max_dose_per_treatment_period: Option(Ratio),
    max_treatment_period: Option(Duration),
    target_species: List(
      AdministrableproductdefinitionRouteofadministrationTargetspecies,
    ),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/AdministrableProductDefinition#resource
pub type AdministrableproductdefinitionRouteofadministrationTargetspecies {
  AdministrableproductdefinitionRouteofadministrationTargetspecies(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
    withdrawal_period: List(
      AdministrableproductdefinitionRouteofadministrationTargetspeciesWithdrawalperiod,
    ),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/AdministrableProductDefinition#resource
pub type AdministrableproductdefinitionRouteofadministrationTargetspeciesWithdrawalperiod {
  AdministrableproductdefinitionRouteofadministrationTargetspeciesWithdrawalperiod(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    tissue: Codeableconcept,
    value: Quantity,
    supporting_information: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/AdverseEvent#resource
pub type Adverseevent {
  Adverseevent(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    actuality: String,
    category: List(Codeableconcept),
    code: Option(Codeableconcept),
    subject: Reference,
    encounter: Option(Reference),
    occurrence: Option(AdverseeventOccurrence),
    detected: Option(String),
    recorded_date: Option(String),
    resulting_effect: List(Reference),
    location: Option(Reference),
    seriousness: Option(Codeableconcept),
    outcome: List(Codeableconcept),
    recorder: Option(Reference),
    participant: List(AdverseeventParticipant),
    study: List(Reference),
    expected_in_research_study: Option(Bool),
    suspect_entity: List(AdverseeventSuspectentity),
    contributing_factor: List(AdverseeventContributingfactor),
    preventive_action: List(AdverseeventPreventiveaction),
    mitigating_action: List(AdverseeventMitigatingaction),
    supporting_info: List(AdverseeventSupportinginfo),
    note: List(Annotation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/AdverseEvent#resource
pub type AdverseeventOccurrence {
  AdverseeventOccurrenceDatetime(occurrence: String)
  AdverseeventOccurrencePeriod(occurrence: Period)
  AdverseeventOccurrenceTiming(occurrence: Timing)
}

///http://hl7.org/fhir/r5/StructureDefinition/AdverseEvent#resource
pub type AdverseeventParticipant {
  AdverseeventParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    function: Option(Codeableconcept),
    actor: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/AdverseEvent#resource
pub type AdverseeventSuspectentity {
  AdverseeventSuspectentity(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    instance: AdverseeventSuspectentityInstance,
    causality: Option(AdverseeventSuspectentityCausality),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/AdverseEvent#resource
pub type AdverseeventSuspectentityInstance {
  AdverseeventSuspectentityInstanceCodeableconcept(instance: Codeableconcept)
  AdverseeventSuspectentityInstanceReference(instance: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/AdverseEvent#resource
pub type AdverseeventSuspectentityCausality {
  AdverseeventSuspectentityCausality(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    assessment_method: Option(Codeableconcept),
    entity_relatedness: Option(Codeableconcept),
    author: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/AdverseEvent#resource
pub type AdverseeventContributingfactor {
  AdverseeventContributingfactor(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item: AdverseeventContributingfactorItem,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/AdverseEvent#resource
pub type AdverseeventContributingfactorItem {
  AdverseeventContributingfactorItemReference(item: Reference)
  AdverseeventContributingfactorItemCodeableconcept(item: Codeableconcept)
}

///http://hl7.org/fhir/r5/StructureDefinition/AdverseEvent#resource
pub type AdverseeventPreventiveaction {
  AdverseeventPreventiveaction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item: AdverseeventPreventiveactionItem,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/AdverseEvent#resource
pub type AdverseeventPreventiveactionItem {
  AdverseeventPreventiveactionItemReference(item: Reference)
  AdverseeventPreventiveactionItemCodeableconcept(item: Codeableconcept)
}

///http://hl7.org/fhir/r5/StructureDefinition/AdverseEvent#resource
pub type AdverseeventMitigatingaction {
  AdverseeventMitigatingaction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item: AdverseeventMitigatingactionItem,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/AdverseEvent#resource
pub type AdverseeventMitigatingactionItem {
  AdverseeventMitigatingactionItemReference(item: Reference)
  AdverseeventMitigatingactionItemCodeableconcept(item: Codeableconcept)
}

///http://hl7.org/fhir/r5/StructureDefinition/AdverseEvent#resource
pub type AdverseeventSupportinginfo {
  AdverseeventSupportinginfo(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item: AdverseeventSupportinginfoItem,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/AdverseEvent#resource
pub type AdverseeventSupportinginfoItem {
  AdverseeventSupportinginfoItemReference(item: Reference)
  AdverseeventSupportinginfoItemCodeableconcept(item: Codeableconcept)
}

///http://hl7.org/fhir/r5/StructureDefinition/AllergyIntolerance#resource
pub type Allergyintolerance {
  Allergyintolerance(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    clinical_status: Option(Codeableconcept),
    verification_status: Option(Codeableconcept),
    type_: Option(Codeableconcept),
    category: List(String),
    criticality: Option(String),
    code: Option(Codeableconcept),
    patient: Reference,
    encounter: Option(Reference),
    onset: Option(AllergyintoleranceOnset),
    recorded_date: Option(String),
    participant: List(AllergyintoleranceParticipant),
    last_occurrence: Option(String),
    note: List(Annotation),
    reaction: List(AllergyintoleranceReaction),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/AllergyIntolerance#resource
pub type AllergyintoleranceOnset {
  AllergyintoleranceOnsetDatetime(onset: String)
  AllergyintoleranceOnsetAge(onset: Age)
  AllergyintoleranceOnsetPeriod(onset: Period)
  AllergyintoleranceOnsetRange(onset: Range)
  AllergyintoleranceOnsetString(onset: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/AllergyIntolerance#resource
pub type AllergyintoleranceParticipant {
  AllergyintoleranceParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    function: Option(Codeableconcept),
    actor: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/AllergyIntolerance#resource
pub type AllergyintoleranceReaction {
  AllergyintoleranceReaction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    substance: Option(Codeableconcept),
    manifestation: List(Codeablereference),
    description: Option(String),
    onset: Option(String),
    severity: Option(String),
    exposure_route: Option(Codeableconcept),
    note: List(Annotation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Appointment#resource
pub type Appointment {
  Appointment(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    cancellation_reason: Option(Codeableconcept),
    class: List(Codeableconcept),
    service_category: List(Codeableconcept),
    service_type: List(Codeablereference),
    specialty: List(Codeableconcept),
    appointment_type: Option(Codeableconcept),
    reason: List(Codeablereference),
    priority: Option(Codeableconcept),
    description: Option(String),
    replaces: List(Reference),
    virtual_service: List(Virtualservicedetail),
    supporting_information: List(Reference),
    previous_appointment: Option(Reference),
    originating_appointment: Option(Reference),
    start: Option(String),
    end: Option(String),
    minutes_duration: Option(Int),
    requested_period: List(Period),
    slot: List(Reference),
    account: List(Reference),
    created: Option(String),
    cancellation_date: Option(String),
    note: List(Annotation),
    patient_instruction: List(Codeablereference),
    based_on: List(Reference),
    subject: Option(Reference),
    participant: List(AppointmentParticipant),
    recurrence_id: Option(Int),
    occurrence_changed: Option(Bool),
    recurrence_template: List(AppointmentRecurrencetemplate),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Appointment#resource
pub type AppointmentParticipant {
  AppointmentParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: List(Codeableconcept),
    period: Option(Period),
    actor: Option(Reference),
    required: Option(Bool),
    status: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Appointment#resource
pub type AppointmentRecurrencetemplate {
  AppointmentRecurrencetemplate(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    timezone: Option(Codeableconcept),
    recurrence_type: Codeableconcept,
    last_occurrence_date: Option(String),
    occurrence_count: Option(Int),
    occurrence_date: List(String),
    weekly_template: Option(AppointmentRecurrencetemplateWeeklytemplate),
    monthly_template: Option(AppointmentRecurrencetemplateMonthlytemplate),
    yearly_template: Option(AppointmentRecurrencetemplateYearlytemplate),
    excluding_date: List(String),
    excluding_recurrence_id: List(Int),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Appointment#resource
pub type AppointmentRecurrencetemplateWeeklytemplate {
  AppointmentRecurrencetemplateWeeklytemplate(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    monday: Option(Bool),
    tuesday: Option(Bool),
    wednesday: Option(Bool),
    thursday: Option(Bool),
    friday: Option(Bool),
    saturday: Option(Bool),
    sunday: Option(Bool),
    week_interval: Option(Int),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Appointment#resource
pub type AppointmentRecurrencetemplateMonthlytemplate {
  AppointmentRecurrencetemplateMonthlytemplate(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    day_of_month: Option(Int),
    nth_week_of_month: Option(Coding),
    day_of_week: Option(Coding),
    month_interval: Int,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Appointment#resource
pub type AppointmentRecurrencetemplateYearlytemplate {
  AppointmentRecurrencetemplateYearlytemplate(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    year_interval: Int,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/AppointmentResponse#resource
pub type Appointmentresponse {
  Appointmentresponse(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    appointment: Reference,
    proposed_new_time: Option(Bool),
    start: Option(String),
    end: Option(String),
    participant_type: List(Codeableconcept),
    actor: Option(Reference),
    participant_status: String,
    comment: Option(String),
    recurring: Option(Bool),
    occurrence_date: Option(String),
    recurrence_id: Option(Int),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ArtifactAssessment#resource
pub type Artifactassessment {
  Artifactassessment(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    title: Option(String),
    cite_as: Option(ArtifactassessmentCiteas),
    date: Option(String),
    copyright: Option(String),
    approval_date: Option(String),
    last_review_date: Option(String),
    artifact: ArtifactassessmentArtifact,
    content: List(ArtifactassessmentContent),
    workflow_status: Option(String),
    disposition: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ArtifactAssessment#resource
pub type ArtifactassessmentCiteas {
  ArtifactassessmentCiteasReference(cite_as: Reference)
  ArtifactassessmentCiteasMarkdown(cite_as: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/ArtifactAssessment#resource
pub type ArtifactassessmentArtifact {
  ArtifactassessmentArtifactReference(artifact: Reference)
  ArtifactassessmentArtifactCanonical(artifact: String)
  ArtifactassessmentArtifactUri(artifact: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/ArtifactAssessment#resource
pub type ArtifactassessmentContent {
  ArtifactassessmentContent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    information_type: Option(String),
    summary: Option(String),
    type_: Option(Codeableconcept),
    classifier: List(Codeableconcept),
    quantity: Option(Quantity),
    author: Option(Reference),
    path: List(String),
    related_artifact: List(Relatedartifact),
    free_to_share: Option(Bool),
    component: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/AuditEvent#resource
pub type Auditevent {
  Auditevent(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    category: List(Codeableconcept),
    code: Codeableconcept,
    action: Option(String),
    severity: Option(String),
    occurred: Option(AuditeventOccurred),
    recorded: String,
    outcome: Option(AuditeventOutcome),
    authorization: List(Codeableconcept),
    based_on: List(Reference),
    patient: Option(Reference),
    encounter: Option(Reference),
    agent: List(AuditeventAgent),
    source: AuditeventSource,
    entity: List(AuditeventEntity),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/AuditEvent#resource
pub type AuditeventOccurred {
  AuditeventOccurredPeriod(occurred: Period)
  AuditeventOccurredDatetime(occurred: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/AuditEvent#resource
pub type AuditeventOutcome {
  AuditeventOutcome(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Coding,
    detail: List(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/AuditEvent#resource
pub type AuditeventAgent {
  AuditeventAgent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    role: List(Codeableconcept),
    who: Reference,
    requestor: Option(Bool),
    location: Option(Reference),
    policy: List(String),
    network: Option(AuditeventAgentNetwork),
    authorization: List(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/AuditEvent#resource
pub type AuditeventAgentNetwork {
  AuditeventAgentNetworkReference(network: Reference)
  AuditeventAgentNetworkUri(network: String)
  AuditeventAgentNetworkString(network: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/AuditEvent#resource
pub type AuditeventSource {
  AuditeventSource(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    site: Option(Reference),
    observer: Reference,
    type_: List(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/AuditEvent#resource
pub type AuditeventEntity {
  AuditeventEntity(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    what: Option(Reference),
    role: Option(Codeableconcept),
    security_label: List(Codeableconcept),
    query: Option(String),
    detail: List(AuditeventEntityDetail),
    agent: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/AuditEvent#resource
pub type AuditeventEntityDetail {
  AuditeventEntityDetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value: AuditeventEntityDetailValue,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/AuditEvent#resource
pub type AuditeventEntityDetailValue {
  AuditeventEntityDetailValueQuantity(value: Quantity)
  AuditeventEntityDetailValueCodeableconcept(value: Codeableconcept)
  AuditeventEntityDetailValueString(value: String)
  AuditeventEntityDetailValueBoolean(value: Bool)
  AuditeventEntityDetailValueInteger(value: Int)
  AuditeventEntityDetailValueRange(value: Range)
  AuditeventEntityDetailValueRatio(value: Ratio)
  AuditeventEntityDetailValueTime(value: String)
  AuditeventEntityDetailValueDatetime(value: String)
  AuditeventEntityDetailValuePeriod(value: Period)
  AuditeventEntityDetailValueBase64binary(value: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/Basic#resource
pub type Basic {
  Basic(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    code: Codeableconcept,
    subject: Option(Reference),
    created: Option(String),
    author: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Binary#resource
pub type Binary {
  Binary(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    content_type: String,
    security_context: Option(Reference),
    data: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/BiologicallyDerivedProduct#resource
pub type Biologicallyderivedproduct {
  Biologicallyderivedproduct(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    product_category: Option(Coding),
    product_code: Option(Codeableconcept),
    parent: List(Reference),
    request: List(Reference),
    identifier: List(Identifier),
    biological_source_event: Option(Identifier),
    processing_facility: List(Reference),
    division: Option(String),
    product_status: Option(Coding),
    expiration_date: Option(String),
    collection: Option(BiologicallyderivedproductCollection),
    storage_temp_requirements: Option(Range),
    property: List(BiologicallyderivedproductProperty),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/BiologicallyDerivedProduct#resource
pub type BiologicallyderivedproductCollection {
  BiologicallyderivedproductCollection(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    collector: Option(Reference),
    source: Option(Reference),
    collected: Option(BiologicallyderivedproductCollectionCollected),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/BiologicallyDerivedProduct#resource
pub type BiologicallyderivedproductCollectionCollected {
  BiologicallyderivedproductCollectionCollectedDatetime(collected: String)
  BiologicallyderivedproductCollectionCollectedPeriod(collected: Period)
}

///http://hl7.org/fhir/r5/StructureDefinition/BiologicallyDerivedProduct#resource
pub type BiologicallyderivedproductProperty {
  BiologicallyderivedproductProperty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value: BiologicallyderivedproductPropertyValue,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/BiologicallyDerivedProduct#resource
pub type BiologicallyderivedproductPropertyValue {
  BiologicallyderivedproductPropertyValueBoolean(value: Bool)
  BiologicallyderivedproductPropertyValueInteger(value: Int)
  BiologicallyderivedproductPropertyValueCodeableconcept(value: Codeableconcept)
  BiologicallyderivedproductPropertyValuePeriod(value: Period)
  BiologicallyderivedproductPropertyValueQuantity(value: Quantity)
  BiologicallyderivedproductPropertyValueRange(value: Range)
  BiologicallyderivedproductPropertyValueRatio(value: Ratio)
  BiologicallyderivedproductPropertyValueString(value: String)
  BiologicallyderivedproductPropertyValueAttachment(value: Attachment)
}

///http://hl7.org/fhir/r5/StructureDefinition/BiologicallyDerivedProductDispense#resource
pub type Biologicallyderivedproductdispense {
  Biologicallyderivedproductdispense(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    based_on: List(Reference),
    part_of: List(Reference),
    status: String,
    origin_relationship_type: Option(Codeableconcept),
    product: Reference,
    patient: Reference,
    match_status: Option(Codeableconcept),
    performer: List(BiologicallyderivedproductdispensePerformer),
    location: Option(Reference),
    quantity: Option(Quantity),
    prepared_date: Option(String),
    when_handed_over: Option(String),
    destination: Option(Reference),
    note: List(Annotation),
    usage_instruction: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/BiologicallyDerivedProductDispense#resource
pub type BiologicallyderivedproductdispensePerformer {
  BiologicallyderivedproductdispensePerformer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    function: Option(Codeableconcept),
    actor: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/BodyStructure#resource
pub type Bodystructure {
  Bodystructure(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    active: Option(Bool),
    morphology: Option(Codeableconcept),
    included_structure: List(BodystructureIncludedstructure),
    excluded_structure: List(Nil),
    description: Option(String),
    image: List(Attachment),
    patient: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/BodyStructure#resource
pub type BodystructureIncludedstructure {
  BodystructureIncludedstructure(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    structure: Codeableconcept,
    laterality: Option(Codeableconcept),
    body_landmark_orientation: List(
      BodystructureIncludedstructureBodylandmarkorientation,
    ),
    spatial_reference: List(Reference),
    qualifier: List(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/BodyStructure#resource
pub type BodystructureIncludedstructureBodylandmarkorientation {
  BodystructureIncludedstructureBodylandmarkorientation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    landmark_description: List(Codeableconcept),
    clock_face_position: List(Codeableconcept),
    distance_from_landmark: List(
      BodystructureIncludedstructureBodylandmarkorientationDistancefromlandmark,
    ),
    surface_orientation: List(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/BodyStructure#resource
pub type BodystructureIncludedstructureBodylandmarkorientationDistancefromlandmark {
  BodystructureIncludedstructureBodylandmarkorientationDistancefromlandmark(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    device: List(Codeablereference),
    value: List(Quantity),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Bundle#resource
pub type Bundle {
  Bundle(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    identifier: Option(Identifier),
    type_: String,
    timestamp: Option(String),
    total: Option(Int),
    link: List(BundleLink),
    entry: List(BundleEntry),
    signature: Option(Signature),
    issues: Option(Resource),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Bundle#resource
pub type BundleLink {
  BundleLink(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    relation: String,
    url: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Bundle#resource
pub type BundleEntry {
  BundleEntry(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    link: List(Nil),
    full_url: Option(String),
    resource: Option(Resource),
    search: Option(BundleEntrySearch),
    request: Option(BundleEntryRequest),
    response: Option(BundleEntryResponse),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Bundle#resource
pub type BundleEntrySearch {
  BundleEntrySearch(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    mode: Option(String),
    score: Option(Float),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Bundle#resource
pub type BundleEntryRequest {
  BundleEntryRequest(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    method: String,
    url: String,
    if_none_match: Option(String),
    if_modified_since: Option(String),
    if_match: Option(String),
    if_none_exist: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Bundle#resource
pub type BundleEntryResponse {
  BundleEntryResponse(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    status: String,
    location: Option(String),
    etag: Option(String),
    last_modified: Option(String),
    outcome: Option(Resource),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CanonicalResource#resource
pub type Canonicalresource {
  Canonicalresource(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(CanonicalresourceVersionalgorithm),
    name: Option(String),
    title: Option(String),
    status: String,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CanonicalResource#resource
pub type CanonicalresourceVersionalgorithm {
  CanonicalresourceVersionalgorithmString(version_algorithm: String)
  CanonicalresourceVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/CapabilityStatement#resource
pub type Capabilitystatement {
  Capabilitystatement(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(CapabilitystatementVersionalgorithm),
    name: Option(String),
    title: Option(String),
    status: String,
    experimental: Option(Bool),
    date: String,
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    kind: String,
    instantiates: List(String),
    imports: List(String),
    software: Option(CapabilitystatementSoftware),
    implementation: Option(CapabilitystatementImplementation),
    fhir_version: String,
    format: List(String),
    patch_format: List(String),
    accept_language: List(String),
    implementation_guide: List(String),
    rest: List(CapabilitystatementRest),
    messaging: List(CapabilitystatementMessaging),
    document: List(CapabilitystatementDocument),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementVersionalgorithm {
  CapabilitystatementVersionalgorithmString(version_algorithm: String)
  CapabilitystatementVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementSoftware {
  CapabilitystatementSoftware(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    version: Option(String),
    release_date: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementImplementation {
  CapabilitystatementImplementation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: String,
    url: Option(String),
    custodian: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementRest {
  CapabilitystatementRest(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    mode: String,
    documentation: Option(String),
    security: Option(CapabilitystatementRestSecurity),
    resource: List(CapabilitystatementRestResource),
    interaction: List(CapabilitystatementRestInteraction),
    search_param: List(Nil),
    operation: List(Nil),
    compartment: List(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementRestSecurity {
  CapabilitystatementRestSecurity(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    cors: Option(Bool),
    service: List(Codeableconcept),
    description: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementRestResource {
  CapabilitystatementRestResource(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: String,
    profile: Option(String),
    supported_profile: List(String),
    documentation: Option(String),
    interaction: List(CapabilitystatementRestResourceInteraction),
    versioning: Option(String),
    read_history: Option(Bool),
    update_create: Option(Bool),
    conditional_create: Option(Bool),
    conditional_read: Option(String),
    conditional_update: Option(Bool),
    conditional_patch: Option(Bool),
    conditional_delete: Option(String),
    reference_policy: List(String),
    search_include: List(String),
    search_rev_include: List(String),
    search_param: List(CapabilitystatementRestResourceSearchparam),
    operation: List(CapabilitystatementRestResourceOperation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementRestResourceInteraction {
  CapabilitystatementRestResourceInteraction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    documentation: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementRestResourceSearchparam {
  CapabilitystatementRestResourceSearchparam(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    definition: Option(String),
    type_: String,
    documentation: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementRestResourceOperation {
  CapabilitystatementRestResourceOperation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    definition: String,
    documentation: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementRestInteraction {
  CapabilitystatementRestInteraction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    documentation: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementMessaging {
  CapabilitystatementMessaging(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    endpoint: List(CapabilitystatementMessagingEndpoint),
    reliable_cache: Option(Int),
    documentation: Option(String),
    supported_message: List(CapabilitystatementMessagingSupportedmessage),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementMessagingEndpoint {
  CapabilitystatementMessagingEndpoint(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    protocol: Coding,
    address: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementMessagingSupportedmessage {
  CapabilitystatementMessagingSupportedmessage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    mode: String,
    definition: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementDocument {
  CapabilitystatementDocument(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    mode: String,
    documentation: Option(String),
    profile: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CarePlan#resource
pub type Careplan {
  Careplan(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    instantiates_canonical: List(String),
    instantiates_uri: List(String),
    based_on: List(Reference),
    replaces: List(Reference),
    part_of: List(Reference),
    status: String,
    intent: String,
    category: List(Codeableconcept),
    title: Option(String),
    description: Option(String),
    subject: Reference,
    encounter: Option(Reference),
    period: Option(Period),
    created: Option(String),
    custodian: Option(Reference),
    contributor: List(Reference),
    care_team: List(Reference),
    addresses: List(Codeablereference),
    supporting_info: List(Reference),
    goal: List(Reference),
    activity: List(CareplanActivity),
    note: List(Annotation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CarePlan#resource
pub type CareplanActivity {
  CareplanActivity(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    performed_activity: List(Codeablereference),
    progress: List(Annotation),
    planned_activity_reference: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CareTeam#resource
pub type Careteam {
  Careteam(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: Option(String),
    category: List(Codeableconcept),
    name: Option(String),
    subject: Option(Reference),
    period: Option(Period),
    participant: List(CareteamParticipant),
    reason: List(Codeablereference),
    managing_organization: List(Reference),
    telecom: List(Contactpoint),
    note: List(Annotation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CareTeam#resource
pub type CareteamParticipant {
  CareteamParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    role: Option(Codeableconcept),
    member: Option(Reference),
    on_behalf_of: Option(Reference),
    coverage: Option(CareteamParticipantCoverage),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CareTeam#resource
pub type CareteamParticipantCoverage {
  CareteamParticipantCoveragePeriod(coverage: Period)
  CareteamParticipantCoverageTiming(coverage: Timing)
}

///http://hl7.org/fhir/r5/StructureDefinition/ChargeItem#resource
pub type Chargeitem {
  Chargeitem(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    definition_uri: List(String),
    definition_canonical: List(String),
    status: String,
    part_of: List(Reference),
    code: Codeableconcept,
    subject: Reference,
    encounter: Option(Reference),
    occurrence: Option(ChargeitemOccurrence),
    performer: List(ChargeitemPerformer),
    performing_organization: Option(Reference),
    requesting_organization: Option(Reference),
    cost_center: Option(Reference),
    quantity: Option(Quantity),
    bodysite: List(Codeableconcept),
    unit_price_component: Option(Monetarycomponent),
    total_price_component: Option(Monetarycomponent),
    override_reason: Option(Codeableconcept),
    enterer: Option(Reference),
    entered_date: Option(String),
    reason: List(Codeableconcept),
    service: List(Codeablereference),
    product: List(Codeablereference),
    account: List(Reference),
    note: List(Annotation),
    supporting_information: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ChargeItem#resource
pub type ChargeitemOccurrence {
  ChargeitemOccurrenceDatetime(occurrence: String)
  ChargeitemOccurrencePeriod(occurrence: Period)
  ChargeitemOccurrenceTiming(occurrence: Timing)
}

///http://hl7.org/fhir/r5/StructureDefinition/ChargeItem#resource
pub type ChargeitemPerformer {
  ChargeitemPerformer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    function: Option(Codeableconcept),
    actor: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ChargeItemDefinition#resource
pub type Chargeitemdefinition {
  Chargeitemdefinition(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(ChargeitemdefinitionVersionalgorithm),
    name: Option(String),
    title: Option(String),
    derived_from_uri: List(String),
    part_of: List(String),
    replaces: List(String),
    status: String,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    approval_date: Option(String),
    last_review_date: Option(String),
    code: Option(Codeableconcept),
    instance: List(Reference),
    applicability: List(ChargeitemdefinitionApplicability),
    property_group: List(ChargeitemdefinitionPropertygroup),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ChargeItemDefinition#resource
pub type ChargeitemdefinitionVersionalgorithm {
  ChargeitemdefinitionVersionalgorithmString(version_algorithm: String)
  ChargeitemdefinitionVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/ChargeItemDefinition#resource
pub type ChargeitemdefinitionApplicability {
  ChargeitemdefinitionApplicability(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    condition: Option(Expression),
    effective_period: Option(Period),
    related_artifact: Option(Relatedartifact),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ChargeItemDefinition#resource
pub type ChargeitemdefinitionPropertygroup {
  ChargeitemdefinitionPropertygroup(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    applicability: List(Nil),
    price_component: List(Monetarycomponent),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Citation#resource
pub type Citation {
  Citation(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(CitationVersionalgorithm),
    name: Option(String),
    title: Option(String),
    status: String,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    approval_date: Option(String),
    last_review_date: Option(String),
    effective_period: Option(Period),
    author: List(Contactdetail),
    editor: List(Contactdetail),
    reviewer: List(Contactdetail),
    endorser: List(Contactdetail),
    summary: List(CitationSummary),
    classification: List(CitationClassification),
    note: List(Annotation),
    current_state: List(Codeableconcept),
    status_date: List(CitationStatusdate),
    related_artifact: List(Relatedartifact),
    cited_artifact: Option(CitationCitedartifact),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Citation#resource
pub type CitationVersionalgorithm {
  CitationVersionalgorithmString(version_algorithm: String)
  CitationVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/Citation#resource
pub type CitationSummary {
  CitationSummary(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    style: Option(Codeableconcept),
    text: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Citation#resource
pub type CitationClassification {
  CitationClassification(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    classifier: List(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Citation#resource
pub type CitationStatusdate {
  CitationStatusdate(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    activity: Codeableconcept,
    actual: Option(Bool),
    period: Period,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Citation#resource
pub type CitationCitedartifact {
  CitationCitedartifact(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    related_identifier: List(Identifier),
    date_accessed: Option(String),
    version: Option(CitationCitedartifactVersion),
    current_state: List(Codeableconcept),
    status_date: List(CitationCitedartifactStatusdate),
    title: List(CitationCitedartifactTitle),
    abstract: List(CitationCitedartifactAbstract),
    part: Option(CitationCitedartifactPart),
    relates_to: List(CitationCitedartifactRelatesto),
    publication_form: List(CitationCitedartifactPublicationform),
    web_location: List(CitationCitedartifactWeblocation),
    classification: List(CitationCitedartifactClassification),
    contributorship: Option(CitationCitedartifactContributorship),
    note: List(Annotation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Citation#resource
pub type CitationCitedartifactVersion {
  CitationCitedartifactVersion(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    value: String,
    base_citation: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Citation#resource
pub type CitationCitedartifactStatusdate {
  CitationCitedartifactStatusdate(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    activity: Codeableconcept,
    actual: Option(Bool),
    period: Period,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Citation#resource
pub type CitationCitedartifactTitle {
  CitationCitedartifactTitle(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: List(Codeableconcept),
    language: Option(Codeableconcept),
    text: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Citation#resource
pub type CitationCitedartifactAbstract {
  CitationCitedartifactAbstract(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    language: Option(Codeableconcept),
    text: String,
    copyright: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Citation#resource
pub type CitationCitedartifactPart {
  CitationCitedartifactPart(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    value: Option(String),
    base_citation: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Citation#resource
pub type CitationCitedartifactRelatesto {
  CitationCitedartifactRelatesto(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: String,
    classifier: List(Codeableconcept),
    label: Option(String),
    display: Option(String),
    citation: Option(String),
    document: Option(Attachment),
    resource: Option(String),
    resource_reference: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Citation#resource
pub type CitationCitedartifactPublicationform {
  CitationCitedartifactPublicationform(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    published_in: Option(CitationCitedartifactPublicationformPublishedin),
    cited_medium: Option(Codeableconcept),
    volume: Option(String),
    issue: Option(String),
    article_date: Option(String),
    publication_date_text: Option(String),
    publication_date_season: Option(String),
    last_revision_date: Option(String),
    language: List(Codeableconcept),
    accession_number: Option(String),
    page_string: Option(String),
    first_page: Option(String),
    last_page: Option(String),
    page_count: Option(String),
    copyright: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Citation#resource
pub type CitationCitedartifactPublicationformPublishedin {
  CitationCitedartifactPublicationformPublishedin(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    identifier: List(Identifier),
    title: Option(String),
    publisher: Option(Reference),
    publisher_location: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Citation#resource
pub type CitationCitedartifactWeblocation {
  CitationCitedartifactWeblocation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    classifier: List(Codeableconcept),
    url: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Citation#resource
pub type CitationCitedartifactClassification {
  CitationCitedartifactClassification(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    classifier: List(Codeableconcept),
    artifact_assessment: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Citation#resource
pub type CitationCitedartifactContributorship {
  CitationCitedartifactContributorship(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    complete: Option(Bool),
    entry: List(CitationCitedartifactContributorshipEntry),
    summary: List(CitationCitedartifactContributorshipSummary),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Citation#resource
pub type CitationCitedartifactContributorshipEntry {
  CitationCitedartifactContributorshipEntry(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    contributor: Reference,
    forename_initials: Option(String),
    affiliation: List(Reference),
    contribution_type: List(Codeableconcept),
    role: Option(Codeableconcept),
    contribution_instance: List(
      CitationCitedartifactContributorshipEntryContributioninstance,
    ),
    corresponding_contact: Option(Bool),
    ranking_order: Option(Int),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Citation#resource
pub type CitationCitedartifactContributorshipEntryContributioninstance {
  CitationCitedartifactContributorshipEntryContributioninstance(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    time: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Citation#resource
pub type CitationCitedartifactContributorshipSummary {
  CitationCitedartifactContributorshipSummary(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    style: Option(Codeableconcept),
    source: Option(Codeableconcept),
    value: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Claim#resource
pub type Claim {
  Claim(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    trace_number: List(Identifier),
    status: String,
    type_: Codeableconcept,
    sub_type: Option(Codeableconcept),
    use_: String,
    patient: Reference,
    billable_period: Option(Period),
    created: String,
    enterer: Option(Reference),
    insurer: Option(Reference),
    provider: Option(Reference),
    priority: Option(Codeableconcept),
    funds_reserve: Option(Codeableconcept),
    related: List(ClaimRelated),
    prescription: Option(Reference),
    original_prescription: Option(Reference),
    payee: Option(ClaimPayee),
    referral: Option(Reference),
    encounter: List(Reference),
    facility: Option(Reference),
    diagnosis_related_group: Option(Codeableconcept),
    event: List(ClaimEvent),
    care_team: List(ClaimCareteam),
    supporting_info: List(ClaimSupportinginfo),
    diagnosis: List(ClaimDiagnosis),
    procedure: List(ClaimProcedure),
    insurance: List(ClaimInsurance),
    accident: Option(ClaimAccident),
    patient_paid: Option(Money),
    item: List(ClaimItem),
    total: Option(Money),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Claim#resource
pub type ClaimRelated {
  ClaimRelated(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    claim: Option(Reference),
    relationship: Option(Codeableconcept),
    reference: Option(Identifier),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Claim#resource
pub type ClaimPayee {
  ClaimPayee(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    party: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Claim#resource
pub type ClaimEvent {
  ClaimEvent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    when: ClaimEventWhen,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Claim#resource
pub type ClaimEventWhen {
  ClaimEventWhenDatetime(when: String)
  ClaimEventWhenPeriod(when: Period)
}

///http://hl7.org/fhir/r5/StructureDefinition/Claim#resource
pub type ClaimCareteam {
  ClaimCareteam(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Int,
    provider: Reference,
    responsible: Option(Bool),
    role: Option(Codeableconcept),
    specialty: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Claim#resource
pub type ClaimSupportinginfo {
  ClaimSupportinginfo(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Int,
    category: Codeableconcept,
    code: Option(Codeableconcept),
    timing: Option(ClaimSupportinginfoTiming),
    value: Option(ClaimSupportinginfoValue),
    reason: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Claim#resource
pub type ClaimSupportinginfoTiming {
  ClaimSupportinginfoTimingDate(timing: String)
  ClaimSupportinginfoTimingPeriod(timing: Period)
}

///http://hl7.org/fhir/r5/StructureDefinition/Claim#resource
pub type ClaimSupportinginfoValue {
  ClaimSupportinginfoValueBoolean(value: Bool)
  ClaimSupportinginfoValueString(value: String)
  ClaimSupportinginfoValueQuantity(value: Quantity)
  ClaimSupportinginfoValueAttachment(value: Attachment)
  ClaimSupportinginfoValueReference(value: Reference)
  ClaimSupportinginfoValueIdentifier(value: Identifier)
}

///http://hl7.org/fhir/r5/StructureDefinition/Claim#resource
pub type ClaimDiagnosis {
  ClaimDiagnosis(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Int,
    diagnosis: ClaimDiagnosisDiagnosis,
    type_: List(Codeableconcept),
    on_admission: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Claim#resource
pub type ClaimDiagnosisDiagnosis {
  ClaimDiagnosisDiagnosisCodeableconcept(diagnosis: Codeableconcept)
  ClaimDiagnosisDiagnosisReference(diagnosis: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/Claim#resource
pub type ClaimProcedure {
  ClaimProcedure(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Int,
    type_: List(Codeableconcept),
    date: Option(String),
    procedure: ClaimProcedureProcedure,
    udi: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Claim#resource
pub type ClaimProcedureProcedure {
  ClaimProcedureProcedureCodeableconcept(procedure: Codeableconcept)
  ClaimProcedureProcedureReference(procedure: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/Claim#resource
pub type ClaimInsurance {
  ClaimInsurance(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Int,
    focal: Bool,
    identifier: Option(Identifier),
    coverage: Reference,
    business_arrangement: Option(String),
    pre_auth_ref: List(String),
    claim_response: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Claim#resource
pub type ClaimAccident {
  ClaimAccident(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    date: String,
    type_: Option(Codeableconcept),
    location: Option(ClaimAccidentLocation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Claim#resource
pub type ClaimAccidentLocation {
  ClaimAccidentLocationAddress(location: Address)
  ClaimAccidentLocationReference(location: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/Claim#resource
pub type ClaimItem {
  ClaimItem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Int,
    trace_number: List(Identifier),
    care_team_sequence: List(Int),
    diagnosis_sequence: List(Int),
    procedure_sequence: List(Int),
    information_sequence: List(Int),
    revenue: Option(Codeableconcept),
    category: Option(Codeableconcept),
    product_or_service: Option(Codeableconcept),
    product_or_service_end: Option(Codeableconcept),
    request: List(Reference),
    modifier: List(Codeableconcept),
    program_code: List(Codeableconcept),
    serviced: Option(ClaimItemServiced),
    location: Option(ClaimItemLocation),
    patient_paid: Option(Money),
    quantity: Option(Quantity),
    unit_price: Option(Money),
    factor: Option(Float),
    tax: Option(Money),
    net: Option(Money),
    udi: List(Reference),
    body_site: List(ClaimItemBodysite),
    encounter: List(Reference),
    detail: List(ClaimItemDetail),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Claim#resource
pub type ClaimItemServiced {
  ClaimItemServicedDate(serviced: String)
  ClaimItemServicedPeriod(serviced: Period)
}

///http://hl7.org/fhir/r5/StructureDefinition/Claim#resource
pub type ClaimItemLocation {
  ClaimItemLocationCodeableconcept(location: Codeableconcept)
  ClaimItemLocationAddress(location: Address)
  ClaimItemLocationReference(location: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/Claim#resource
pub type ClaimItemBodysite {
  ClaimItemBodysite(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    site: List(Codeablereference),
    sub_site: List(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Claim#resource
pub type ClaimItemDetail {
  ClaimItemDetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Int,
    trace_number: List(Identifier),
    revenue: Option(Codeableconcept),
    category: Option(Codeableconcept),
    product_or_service: Option(Codeableconcept),
    product_or_service_end: Option(Codeableconcept),
    modifier: List(Codeableconcept),
    program_code: List(Codeableconcept),
    patient_paid: Option(Money),
    quantity: Option(Quantity),
    unit_price: Option(Money),
    factor: Option(Float),
    tax: Option(Money),
    net: Option(Money),
    udi: List(Reference),
    sub_detail: List(ClaimItemDetailSubdetail),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Claim#resource
pub type ClaimItemDetailSubdetail {
  ClaimItemDetailSubdetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Int,
    trace_number: List(Identifier),
    revenue: Option(Codeableconcept),
    category: Option(Codeableconcept),
    product_or_service: Option(Codeableconcept),
    product_or_service_end: Option(Codeableconcept),
    modifier: List(Codeableconcept),
    program_code: List(Codeableconcept),
    patient_paid: Option(Money),
    quantity: Option(Quantity),
    unit_price: Option(Money),
    factor: Option(Float),
    tax: Option(Money),
    net: Option(Money),
    udi: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ClaimResponse#resource
pub type Claimresponse {
  Claimresponse(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    trace_number: List(Identifier),
    status: String,
    type_: Codeableconcept,
    sub_type: Option(Codeableconcept),
    use_: String,
    patient: Reference,
    created: String,
    insurer: Option(Reference),
    requestor: Option(Reference),
    request: Option(Reference),
    outcome: String,
    decision: Option(Codeableconcept),
    disposition: Option(String),
    pre_auth_ref: Option(String),
    pre_auth_period: Option(Period),
    event: List(ClaimresponseEvent),
    payee_type: Option(Codeableconcept),
    encounter: List(Reference),
    diagnosis_related_group: Option(Codeableconcept),
    item: List(ClaimresponseItem),
    add_item: List(ClaimresponseAdditem),
    adjudication: List(Nil),
    total: List(ClaimresponseTotal),
    payment: Option(ClaimresponsePayment),
    funds_reserve: Option(Codeableconcept),
    form_code: Option(Codeableconcept),
    form: Option(Attachment),
    process_note: List(ClaimresponseProcessnote),
    communication_request: List(Reference),
    insurance: List(ClaimresponseInsurance),
    error: List(ClaimresponseError),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseEvent {
  ClaimresponseEvent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    when: ClaimresponseEventWhen,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseEventWhen {
  ClaimresponseEventWhenDatetime(when: String)
  ClaimresponseEventWhenPeriod(when: Period)
}

///http://hl7.org/fhir/r5/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseItem {
  ClaimresponseItem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item_sequence: Int,
    trace_number: List(Identifier),
    note_number: List(Int),
    review_outcome: Option(ClaimresponseItemReviewoutcome),
    adjudication: List(ClaimresponseItemAdjudication),
    detail: List(ClaimresponseItemDetail),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseItemReviewoutcome {
  ClaimresponseItemReviewoutcome(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    decision: Option(Codeableconcept),
    reason: List(Codeableconcept),
    pre_auth_ref: Option(String),
    pre_auth_period: Option(Period),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseItemAdjudication {
  ClaimresponseItemAdjudication(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    category: Codeableconcept,
    reason: Option(Codeableconcept),
    amount: Option(Money),
    quantity: Option(Quantity),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseItemDetail {
  ClaimresponseItemDetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    detail_sequence: Int,
    trace_number: List(Identifier),
    note_number: List(Int),
    review_outcome: Option(Nil),
    adjudication: List(Nil),
    sub_detail: List(ClaimresponseItemDetailSubdetail),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseItemDetailSubdetail {
  ClaimresponseItemDetailSubdetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sub_detail_sequence: Int,
    trace_number: List(Identifier),
    note_number: List(Int),
    review_outcome: Option(Nil),
    adjudication: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseAdditem {
  ClaimresponseAdditem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item_sequence: List(Int),
    detail_sequence: List(Int),
    subdetail_sequence: List(Int),
    trace_number: List(Identifier),
    provider: List(Reference),
    revenue: Option(Codeableconcept),
    product_or_service: Option(Codeableconcept),
    product_or_service_end: Option(Codeableconcept),
    request: List(Reference),
    modifier: List(Codeableconcept),
    program_code: List(Codeableconcept),
    serviced: Option(ClaimresponseAdditemServiced),
    location: Option(ClaimresponseAdditemLocation),
    quantity: Option(Quantity),
    unit_price: Option(Money),
    factor: Option(Float),
    tax: Option(Money),
    net: Option(Money),
    body_site: List(ClaimresponseAdditemBodysite),
    note_number: List(Int),
    review_outcome: Option(Nil),
    adjudication: List(Nil),
    detail: List(ClaimresponseAdditemDetail),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseAdditemServiced {
  ClaimresponseAdditemServicedDate(serviced: String)
  ClaimresponseAdditemServicedPeriod(serviced: Period)
}

///http://hl7.org/fhir/r5/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseAdditemLocation {
  ClaimresponseAdditemLocationCodeableconcept(location: Codeableconcept)
  ClaimresponseAdditemLocationAddress(location: Address)
  ClaimresponseAdditemLocationReference(location: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseAdditemBodysite {
  ClaimresponseAdditemBodysite(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    site: List(Codeablereference),
    sub_site: List(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseAdditemDetail {
  ClaimresponseAdditemDetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    trace_number: List(Identifier),
    revenue: Option(Codeableconcept),
    product_or_service: Option(Codeableconcept),
    product_or_service_end: Option(Codeableconcept),
    modifier: List(Codeableconcept),
    quantity: Option(Quantity),
    unit_price: Option(Money),
    factor: Option(Float),
    tax: Option(Money),
    net: Option(Money),
    note_number: List(Int),
    review_outcome: Option(Nil),
    adjudication: List(Nil),
    sub_detail: List(ClaimresponseAdditemDetailSubdetail),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseAdditemDetailSubdetail {
  ClaimresponseAdditemDetailSubdetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    trace_number: List(Identifier),
    revenue: Option(Codeableconcept),
    product_or_service: Option(Codeableconcept),
    product_or_service_end: Option(Codeableconcept),
    modifier: List(Codeableconcept),
    quantity: Option(Quantity),
    unit_price: Option(Money),
    factor: Option(Float),
    tax: Option(Money),
    net: Option(Money),
    note_number: List(Int),
    review_outcome: Option(Nil),
    adjudication: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseTotal {
  ClaimresponseTotal(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    category: Codeableconcept,
    amount: Money,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ClaimResponse#resource
pub type ClaimresponsePayment {
  ClaimresponsePayment(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    adjustment: Option(Money),
    adjustment_reason: Option(Codeableconcept),
    date: Option(String),
    amount: Money,
    identifier: Option(Identifier),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseProcessnote {
  ClaimresponseProcessnote(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    number: Option(Int),
    type_: Option(Codeableconcept),
    text: String,
    language: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseInsurance {
  ClaimresponseInsurance(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Int,
    focal: Bool,
    coverage: Reference,
    business_arrangement: Option(String),
    claim_response: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseError {
  ClaimresponseError(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item_sequence: Option(Int),
    detail_sequence: Option(Int),
    sub_detail_sequence: Option(Int),
    code: Codeableconcept,
    expression: List(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ClinicalImpression#resource
pub type Clinicalimpression {
  Clinicalimpression(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    status_reason: Option(Codeableconcept),
    description: Option(String),
    subject: Reference,
    encounter: Option(Reference),
    effective: Option(ClinicalimpressionEffective),
    date: Option(String),
    performer: Option(Reference),
    previous: Option(Reference),
    problem: List(Reference),
    change_pattern: Option(Codeableconcept),
    protocol: List(String),
    summary: Option(String),
    finding: List(ClinicalimpressionFinding),
    prognosis_codeable_concept: List(Codeableconcept),
    prognosis_reference: List(Reference),
    supporting_info: List(Reference),
    note: List(Annotation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ClinicalImpression#resource
pub type ClinicalimpressionEffective {
  ClinicalimpressionEffectiveDatetime(effective: String)
  ClinicalimpressionEffectivePeriod(effective: Period)
}

///http://hl7.org/fhir/r5/StructureDefinition/ClinicalImpression#resource
pub type ClinicalimpressionFinding {
  ClinicalimpressionFinding(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item: Option(Codeablereference),
    basis: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ClinicalUseDefinition#resource
pub type Clinicalusedefinition {
  Clinicalusedefinition(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    type_: String,
    category: List(Codeableconcept),
    subject: List(Reference),
    status: Option(Codeableconcept),
    contraindication: Option(ClinicalusedefinitionContraindication),
    indication: Option(ClinicalusedefinitionIndication),
    interaction: Option(ClinicalusedefinitionInteraction),
    population: List(Reference),
    library: List(String),
    undesirable_effect: Option(ClinicalusedefinitionUndesirableeffect),
    warning: Option(ClinicalusedefinitionWarning),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ClinicalUseDefinition#resource
pub type ClinicalusedefinitionContraindication {
  ClinicalusedefinitionContraindication(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    disease_symptom_procedure: Option(Codeablereference),
    disease_status: Option(Codeablereference),
    comorbidity: List(Codeablereference),
    indication: List(Reference),
    applicability: Option(Expression),
    other_therapy: List(ClinicalusedefinitionContraindicationOthertherapy),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ClinicalUseDefinition#resource
pub type ClinicalusedefinitionContraindicationOthertherapy {
  ClinicalusedefinitionContraindicationOthertherapy(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    relationship_type: Codeableconcept,
    treatment: Codeablereference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ClinicalUseDefinition#resource
pub type ClinicalusedefinitionIndication {
  ClinicalusedefinitionIndication(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    disease_symptom_procedure: Option(Codeablereference),
    disease_status: Option(Codeablereference),
    comorbidity: List(Codeablereference),
    intended_effect: Option(Codeablereference),
    duration: Option(ClinicalusedefinitionIndicationDuration),
    undesirable_effect: List(Reference),
    applicability: Option(Expression),
    other_therapy: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ClinicalUseDefinition#resource
pub type ClinicalusedefinitionIndicationDuration {
  ClinicalusedefinitionIndicationDurationRange(duration: Range)
  ClinicalusedefinitionIndicationDurationString(duration: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/ClinicalUseDefinition#resource
pub type ClinicalusedefinitionInteraction {
  ClinicalusedefinitionInteraction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    interactant: List(ClinicalusedefinitionInteractionInteractant),
    type_: Option(Codeableconcept),
    effect: Option(Codeablereference),
    incidence: Option(Codeableconcept),
    management: List(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ClinicalUseDefinition#resource
pub type ClinicalusedefinitionInteractionInteractant {
  ClinicalusedefinitionInteractionInteractant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item: ClinicalusedefinitionInteractionInteractantItem,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ClinicalUseDefinition#resource
pub type ClinicalusedefinitionInteractionInteractantItem {
  ClinicalusedefinitionInteractionInteractantItemReference(item: Reference)
  ClinicalusedefinitionInteractionInteractantItemCodeableconcept(
    item: Codeableconcept,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ClinicalUseDefinition#resource
pub type ClinicalusedefinitionUndesirableeffect {
  ClinicalusedefinitionUndesirableeffect(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    symptom_condition_effect: Option(Codeablereference),
    classification: Option(Codeableconcept),
    frequency_of_occurrence: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ClinicalUseDefinition#resource
pub type ClinicalusedefinitionWarning {
  ClinicalusedefinitionWarning(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    code: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CodeSystem#resource
pub type Codesystem {
  Codesystem(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(CodesystemVersionalgorithm),
    name: Option(String),
    title: Option(String),
    status: String,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    approval_date: Option(String),
    last_review_date: Option(String),
    effective_period: Option(Period),
    topic: List(Codeableconcept),
    author: List(Contactdetail),
    editor: List(Contactdetail),
    reviewer: List(Contactdetail),
    endorser: List(Contactdetail),
    related_artifact: List(Relatedartifact),
    case_sensitive: Option(Bool),
    value_set: Option(String),
    hierarchy_meaning: Option(String),
    compositional: Option(Bool),
    version_needed: Option(Bool),
    content: String,
    supplements: Option(String),
    count: Option(Int),
    filter: List(CodesystemFilter),
    property: List(CodesystemProperty),
    concept: List(CodesystemConcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CodeSystem#resource
pub type CodesystemVersionalgorithm {
  CodesystemVersionalgorithmString(version_algorithm: String)
  CodesystemVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/CodeSystem#resource
pub type CodesystemFilter {
  CodesystemFilter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    description: Option(String),
    operator: List(String),
    value: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CodeSystem#resource
pub type CodesystemProperty {
  CodesystemProperty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    uri: Option(String),
    description: Option(String),
    type_: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CodeSystem#resource
pub type CodesystemConcept {
  CodesystemConcept(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    display: Option(String),
    definition: Option(String),
    designation: List(CodesystemConceptDesignation),
    property: List(CodesystemConceptProperty),
    concept: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CodeSystem#resource
pub type CodesystemConceptDesignation {
  CodesystemConceptDesignation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    language: Option(String),
    use_: Option(Coding),
    additional_use: List(Coding),
    value: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CodeSystem#resource
pub type CodesystemConceptProperty {
  CodesystemConceptProperty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    value: CodesystemConceptPropertyValue,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CodeSystem#resource
pub type CodesystemConceptPropertyValue {
  CodesystemConceptPropertyValueCode(value: String)
  CodesystemConceptPropertyValueCoding(value: Coding)
  CodesystemConceptPropertyValueString(value: String)
  CodesystemConceptPropertyValueInteger(value: Int)
  CodesystemConceptPropertyValueBoolean(value: Bool)
  CodesystemConceptPropertyValueDatetime(value: String)
  CodesystemConceptPropertyValueDecimal(value: Float)
}

///http://hl7.org/fhir/r5/StructureDefinition/Communication#resource
pub type Communication {
  Communication(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    instantiates_canonical: List(String),
    instantiates_uri: List(String),
    based_on: List(Reference),
    part_of: List(Reference),
    in_response_to: List(Reference),
    status: String,
    status_reason: Option(Codeableconcept),
    category: List(Codeableconcept),
    priority: Option(String),
    medium: List(Codeableconcept),
    subject: Option(Reference),
    topic: Option(Codeableconcept),
    about: List(Reference),
    encounter: Option(Reference),
    sent: Option(String),
    received: Option(String),
    recipient: List(Reference),
    sender: Option(Reference),
    reason: List(Codeablereference),
    payload: List(CommunicationPayload),
    note: List(Annotation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Communication#resource
pub type CommunicationPayload {
  CommunicationPayload(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    content: CommunicationPayloadContent,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Communication#resource
pub type CommunicationPayloadContent {
  CommunicationPayloadContentAttachment(content: Attachment)
  CommunicationPayloadContentReference(content: Reference)
  CommunicationPayloadContentCodeableconcept(content: Codeableconcept)
}

///http://hl7.org/fhir/r5/StructureDefinition/CommunicationRequest#resource
pub type Communicationrequest {
  Communicationrequest(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    based_on: List(Reference),
    replaces: List(Reference),
    group_identifier: Option(Identifier),
    status: String,
    status_reason: Option(Codeableconcept),
    intent: String,
    category: List(Codeableconcept),
    priority: Option(String),
    do_not_perform: Option(Bool),
    medium: List(Codeableconcept),
    subject: Option(Reference),
    about: List(Reference),
    encounter: Option(Reference),
    payload: List(CommunicationrequestPayload),
    occurrence: Option(CommunicationrequestOccurrence),
    authored_on: Option(String),
    requester: Option(Reference),
    recipient: List(Reference),
    information_provider: List(Reference),
    reason: List(Codeablereference),
    note: List(Annotation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CommunicationRequest#resource
pub type CommunicationrequestOccurrence {
  CommunicationrequestOccurrenceDatetime(occurrence: String)
  CommunicationrequestOccurrencePeriod(occurrence: Period)
}

///http://hl7.org/fhir/r5/StructureDefinition/CommunicationRequest#resource
pub type CommunicationrequestPayload {
  CommunicationrequestPayload(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    content: CommunicationrequestPayloadContent,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CommunicationRequest#resource
pub type CommunicationrequestPayloadContent {
  CommunicationrequestPayloadContentAttachment(content: Attachment)
  CommunicationrequestPayloadContentReference(content: Reference)
  CommunicationrequestPayloadContentCodeableconcept(content: Codeableconcept)
}

///http://hl7.org/fhir/r5/StructureDefinition/CompartmentDefinition#resource
pub type Compartmentdefinition {
  Compartmentdefinition(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: String,
    version: Option(String),
    version_algorithm: Option(CompartmentdefinitionVersionalgorithm),
    name: String,
    title: Option(String),
    status: String,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    purpose: Option(String),
    code: String,
    search: Bool,
    resource: List(CompartmentdefinitionResource),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CompartmentDefinition#resource
pub type CompartmentdefinitionVersionalgorithm {
  CompartmentdefinitionVersionalgorithmString(version_algorithm: String)
  CompartmentdefinitionVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/CompartmentDefinition#resource
pub type CompartmentdefinitionResource {
  CompartmentdefinitionResource(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    param: List(String),
    documentation: Option(String),
    start_param: Option(String),
    end_param: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Composition#resource
pub type Composition {
  Composition(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    status: String,
    type_: Codeableconcept,
    category: List(Codeableconcept),
    subject: List(Reference),
    encounter: Option(Reference),
    date: String,
    use_context: List(Usagecontext),
    author: List(Reference),
    name: Option(String),
    title: String,
    note: List(Annotation),
    attester: List(CompositionAttester),
    custodian: Option(Reference),
    relates_to: List(Relatedartifact),
    event: List(CompositionEvent),
    section: List(CompositionSection),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Composition#resource
pub type CompositionAttester {
  CompositionAttester(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    mode: Codeableconcept,
    time: Option(String),
    party: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Composition#resource
pub type CompositionEvent {
  CompositionEvent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    period: Option(Period),
    detail: List(Codeablereference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Composition#resource
pub type CompositionSection {
  CompositionSection(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    title: Option(String),
    code: Option(Codeableconcept),
    author: List(Reference),
    focus: Option(Reference),
    text: Option(Narrative),
    ordered_by: Option(Codeableconcept),
    entry: List(Reference),
    empty_reason: Option(Codeableconcept),
    section: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ConceptMap#resource
pub type Conceptmap {
  Conceptmap(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(ConceptmapVersionalgorithm),
    name: Option(String),
    title: Option(String),
    status: String,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    approval_date: Option(String),
    last_review_date: Option(String),
    effective_period: Option(Period),
    topic: List(Codeableconcept),
    author: List(Contactdetail),
    editor: List(Contactdetail),
    reviewer: List(Contactdetail),
    endorser: List(Contactdetail),
    related_artifact: List(Relatedartifact),
    property: List(ConceptmapProperty),
    additional_attribute: List(ConceptmapAdditionalattribute),
    source_scope: Option(ConceptmapSourcescope),
    target_scope: Option(ConceptmapTargetscope),
    group: List(ConceptmapGroup),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ConceptMap#resource
pub type ConceptmapVersionalgorithm {
  ConceptmapVersionalgorithmString(version_algorithm: String)
  ConceptmapVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/ConceptMap#resource
pub type ConceptmapSourcescope {
  ConceptmapSourcescopeUri(source_scope: String)
  ConceptmapSourcescopeCanonical(source_scope: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/ConceptMap#resource
pub type ConceptmapTargetscope {
  ConceptmapTargetscopeUri(target_scope: String)
  ConceptmapTargetscopeCanonical(target_scope: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/ConceptMap#resource
pub type ConceptmapProperty {
  ConceptmapProperty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    uri: Option(String),
    description: Option(String),
    type_: String,
    system: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ConceptMap#resource
pub type ConceptmapAdditionalattribute {
  ConceptmapAdditionalattribute(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    uri: Option(String),
    description: Option(String),
    type_: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ConceptMap#resource
pub type ConceptmapGroup {
  ConceptmapGroup(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    source: Option(String),
    target: Option(String),
    element: List(ConceptmapGroupElement),
    unmapped: Option(ConceptmapGroupUnmapped),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ConceptMap#resource
pub type ConceptmapGroupElement {
  ConceptmapGroupElement(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(String),
    display: Option(String),
    value_set: Option(String),
    no_map: Option(Bool),
    target: List(ConceptmapGroupElementTarget),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ConceptMap#resource
pub type ConceptmapGroupElementTarget {
  ConceptmapGroupElementTarget(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(String),
    display: Option(String),
    value_set: Option(String),
    relationship: String,
    comment: Option(String),
    property: List(ConceptmapGroupElementTargetProperty),
    depends_on: List(ConceptmapGroupElementTargetDependson),
    product: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ConceptMap#resource
pub type ConceptmapGroupElementTargetProperty {
  ConceptmapGroupElementTargetProperty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    value: ConceptmapGroupElementTargetPropertyValue,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ConceptMap#resource
pub type ConceptmapGroupElementTargetPropertyValue {
  ConceptmapGroupElementTargetPropertyValueCoding(value: Coding)
  ConceptmapGroupElementTargetPropertyValueString(value: String)
  ConceptmapGroupElementTargetPropertyValueInteger(value: Int)
  ConceptmapGroupElementTargetPropertyValueBoolean(value: Bool)
  ConceptmapGroupElementTargetPropertyValueDatetime(value: String)
  ConceptmapGroupElementTargetPropertyValueDecimal(value: Float)
  ConceptmapGroupElementTargetPropertyValueCode(value: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/ConceptMap#resource
pub type ConceptmapGroupElementTargetDependson {
  ConceptmapGroupElementTargetDependson(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    attribute: String,
    value: Option(ConceptmapGroupElementTargetDependsonValue),
    value_set: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ConceptMap#resource
pub type ConceptmapGroupElementTargetDependsonValue {
  ConceptmapGroupElementTargetDependsonValueCode(value: String)
  ConceptmapGroupElementTargetDependsonValueCoding(value: Coding)
  ConceptmapGroupElementTargetDependsonValueString(value: String)
  ConceptmapGroupElementTargetDependsonValueBoolean(value: Bool)
  ConceptmapGroupElementTargetDependsonValueQuantity(value: Quantity)
}

///http://hl7.org/fhir/r5/StructureDefinition/ConceptMap#resource
pub type ConceptmapGroupUnmapped {
  ConceptmapGroupUnmapped(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    mode: String,
    code: Option(String),
    display: Option(String),
    value_set: Option(String),
    relationship: Option(String),
    other_map: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Condition#resource
pub type Condition {
  Condition(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    clinical_status: Codeableconcept,
    verification_status: Option(Codeableconcept),
    category: List(Codeableconcept),
    severity: Option(Codeableconcept),
    code: Option(Codeableconcept),
    body_site: List(Codeableconcept),
    subject: Reference,
    encounter: Option(Reference),
    onset: Option(ConditionOnset),
    abatement: Option(ConditionAbatement),
    recorded_date: Option(String),
    participant: List(ConditionParticipant),
    stage: List(ConditionStage),
    evidence: List(Codeablereference),
    note: List(Annotation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Condition#resource
pub type ConditionOnset {
  ConditionOnsetDatetime(onset: String)
  ConditionOnsetAge(onset: Age)
  ConditionOnsetPeriod(onset: Period)
  ConditionOnsetRange(onset: Range)
  ConditionOnsetString(onset: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/Condition#resource
pub type ConditionAbatement {
  ConditionAbatementDatetime(abatement: String)
  ConditionAbatementAge(abatement: Age)
  ConditionAbatementPeriod(abatement: Period)
  ConditionAbatementRange(abatement: Range)
  ConditionAbatementString(abatement: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/Condition#resource
pub type ConditionParticipant {
  ConditionParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    function: Option(Codeableconcept),
    actor: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Condition#resource
pub type ConditionStage {
  ConditionStage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    summary: Option(Codeableconcept),
    assessment: List(Reference),
    type_: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ConditionDefinition#resource
pub type Conditiondefinition {
  Conditiondefinition(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(ConditiondefinitionVersionalgorithm),
    name: Option(String),
    title: Option(String),
    subtitle: Option(String),
    status: String,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    code: Codeableconcept,
    severity: Option(Codeableconcept),
    body_site: Option(Codeableconcept),
    stage: Option(Codeableconcept),
    has_severity: Option(Bool),
    has_body_site: Option(Bool),
    has_stage: Option(Bool),
    definition: List(String),
    observation: List(ConditiondefinitionObservation),
    medication: List(ConditiondefinitionMedication),
    precondition: List(ConditiondefinitionPrecondition),
    team: List(Reference),
    questionnaire: List(ConditiondefinitionQuestionnaire),
    plan: List(ConditiondefinitionPlan),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ConditionDefinition#resource
pub type ConditiondefinitionVersionalgorithm {
  ConditiondefinitionVersionalgorithmString(version_algorithm: String)
  ConditiondefinitionVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/ConditionDefinition#resource
pub type ConditiondefinitionObservation {
  ConditiondefinitionObservation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    category: Option(Codeableconcept),
    code: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ConditionDefinition#resource
pub type ConditiondefinitionMedication {
  ConditiondefinitionMedication(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    category: Option(Codeableconcept),
    code: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ConditionDefinition#resource
pub type ConditiondefinitionPrecondition {
  ConditiondefinitionPrecondition(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: String,
    code: Codeableconcept,
    value: Option(ConditiondefinitionPreconditionValue),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ConditionDefinition#resource
pub type ConditiondefinitionPreconditionValue {
  ConditiondefinitionPreconditionValueCodeableconcept(value: Codeableconcept)
  ConditiondefinitionPreconditionValueQuantity(value: Quantity)
}

///http://hl7.org/fhir/r5/StructureDefinition/ConditionDefinition#resource
pub type ConditiondefinitionQuestionnaire {
  ConditiondefinitionQuestionnaire(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    purpose: String,
    reference: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ConditionDefinition#resource
pub type ConditiondefinitionPlan {
  ConditiondefinitionPlan(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    role: Option(Codeableconcept),
    reference: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Consent#resource
pub type Consent {
  Consent(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    category: List(Codeableconcept),
    subject: Option(Reference),
    date: Option(String),
    period: Option(Period),
    grantor: List(Reference),
    grantee: List(Reference),
    manager: List(Reference),
    controller: List(Reference),
    source_attachment: List(Attachment),
    source_reference: List(Reference),
    regulatory_basis: List(Codeableconcept),
    policy_basis: Option(ConsentPolicybasis),
    policy_text: List(Reference),
    verification: List(ConsentVerification),
    decision: Option(String),
    provision: List(ConsentProvision),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Consent#resource
pub type ConsentPolicybasis {
  ConsentPolicybasis(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    reference: Option(Reference),
    url: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Consent#resource
pub type ConsentVerification {
  ConsentVerification(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    verified: Bool,
    verification_type: Option(Codeableconcept),
    verified_by: Option(Reference),
    verified_with: Option(Reference),
    verification_date: List(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Consent#resource
pub type ConsentProvision {
  ConsentProvision(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    period: Option(Period),
    actor: List(ConsentProvisionActor),
    action: List(Codeableconcept),
    security_label: List(Coding),
    purpose: List(Coding),
    document_type: List(Coding),
    resource_type: List(Coding),
    code: List(Codeableconcept),
    data_period: Option(Period),
    data: List(ConsentProvisionData),
    expression: Option(Expression),
    provision: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Consent#resource
pub type ConsentProvisionActor {
  ConsentProvisionActor(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    role: Option(Codeableconcept),
    reference: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Consent#resource
pub type ConsentProvisionData {
  ConsentProvisionData(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    meaning: String,
    reference: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Contract#resource
pub type Contract {
  Contract(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    url: Option(String),
    version: Option(String),
    status: Option(String),
    legal_state: Option(Codeableconcept),
    instantiates_canonical: Option(Reference),
    instantiates_uri: Option(String),
    content_derivative: Option(Codeableconcept),
    issued: Option(String),
    applies: Option(Period),
    expiration_type: Option(Codeableconcept),
    subject: List(Reference),
    authority: List(Reference),
    domain: List(Reference),
    site: List(Reference),
    name: Option(String),
    title: Option(String),
    subtitle: Option(String),
    alias: List(String),
    author: Option(Reference),
    scope: Option(Codeableconcept),
    topic: Option(ContractTopic),
    type_: Option(Codeableconcept),
    sub_type: List(Codeableconcept),
    content_definition: Option(ContractContentdefinition),
    term: List(ContractTerm),
    supporting_info: List(Reference),
    relevant_history: List(Reference),
    signer: List(ContractSigner),
    friendly: List(ContractFriendly),
    legal: List(ContractLegal),
    rule: List(ContractRule),
    legally_binding: Option(ContractLegallybinding),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Contract#resource
pub type ContractTopic {
  ContractTopicCodeableconcept(topic: Codeableconcept)
  ContractTopicReference(topic: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/Contract#resource
pub type ContractLegallybinding {
  ContractLegallybindingAttachment(legally_binding: Attachment)
  ContractLegallybindingReference(legally_binding: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/Contract#resource
pub type ContractContentdefinition {
  ContractContentdefinition(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    sub_type: Option(Codeableconcept),
    publisher: Option(Reference),
    publication_date: Option(String),
    publication_status: String,
    copyright: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Contract#resource
pub type ContractTerm {
  ContractTerm(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Option(Identifier),
    issued: Option(String),
    applies: Option(Period),
    topic: Option(ContractTermTopic),
    type_: Option(Codeableconcept),
    sub_type: Option(Codeableconcept),
    text: Option(String),
    security_label: List(ContractTermSecuritylabel),
    offer: ContractTermOffer,
    asset: List(ContractTermAsset),
    action: List(ContractTermAction),
    group: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Contract#resource
pub type ContractTermTopic {
  ContractTermTopicCodeableconcept(topic: Codeableconcept)
  ContractTermTopicReference(topic: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/Contract#resource
pub type ContractTermSecuritylabel {
  ContractTermSecuritylabel(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    number: List(Int),
    classification: Coding,
    category: List(Coding),
    control: List(Coding),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Contract#resource
pub type ContractTermOffer {
  ContractTermOffer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    party: List(ContractTermOfferParty),
    topic: Option(Reference),
    type_: Option(Codeableconcept),
    decision: Option(Codeableconcept),
    decision_mode: List(Codeableconcept),
    answer: List(ContractTermOfferAnswer),
    text: Option(String),
    link_id: List(String),
    security_label_number: List(Int),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Contract#resource
pub type ContractTermOfferParty {
  ContractTermOfferParty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    reference: List(Reference),
    role: Codeableconcept,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Contract#resource
pub type ContractTermOfferAnswer {
  ContractTermOfferAnswer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    value: ContractTermOfferAnswerValue,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Contract#resource
pub type ContractTermOfferAnswerValue {
  ContractTermOfferAnswerValueBoolean(value: Bool)
  ContractTermOfferAnswerValueDecimal(value: Float)
  ContractTermOfferAnswerValueInteger(value: Int)
  ContractTermOfferAnswerValueDate(value: String)
  ContractTermOfferAnswerValueDatetime(value: String)
  ContractTermOfferAnswerValueTime(value: String)
  ContractTermOfferAnswerValueString(value: String)
  ContractTermOfferAnswerValueUri(value: String)
  ContractTermOfferAnswerValueAttachment(value: Attachment)
  ContractTermOfferAnswerValueCoding(value: Coding)
  ContractTermOfferAnswerValueQuantity(value: Quantity)
  ContractTermOfferAnswerValueReference(value: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/Contract#resource
pub type ContractTermAsset {
  ContractTermAsset(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    scope: Option(Codeableconcept),
    type_: List(Codeableconcept),
    type_reference: List(Reference),
    subtype: List(Codeableconcept),
    relationship: Option(Coding),
    context: List(ContractTermAssetContext),
    condition: Option(String),
    period_type: List(Codeableconcept),
    period: List(Period),
    use_period: List(Period),
    text: Option(String),
    link_id: List(String),
    answer: List(Nil),
    security_label_number: List(Int),
    valued_item: List(ContractTermAssetValueditem),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Contract#resource
pub type ContractTermAssetContext {
  ContractTermAssetContext(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    reference: Option(Reference),
    code: List(Codeableconcept),
    text: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Contract#resource
pub type ContractTermAssetValueditem {
  ContractTermAssetValueditem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    entity: Option(ContractTermAssetValueditemEntity),
    identifier: Option(Identifier),
    effective_time: Option(String),
    quantity: Option(Quantity),
    unit_price: Option(Money),
    factor: Option(Float),
    points: Option(Float),
    net: Option(Money),
    payment: Option(String),
    payment_date: Option(String),
    responsible: Option(Reference),
    recipient: Option(Reference),
    link_id: List(String),
    security_label_number: List(Int),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Contract#resource
pub type ContractTermAssetValueditemEntity {
  ContractTermAssetValueditemEntityCodeableconcept(entity: Codeableconcept)
  ContractTermAssetValueditemEntityReference(entity: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/Contract#resource
pub type ContractTermAction {
  ContractTermAction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    do_not_perform: Option(Bool),
    type_: Codeableconcept,
    subject: List(ContractTermActionSubject),
    intent: Codeableconcept,
    link_id: List(String),
    status: Codeableconcept,
    context: Option(Reference),
    context_link_id: List(String),
    occurrence: Option(ContractTermActionOccurrence),
    requester: List(Reference),
    requester_link_id: List(String),
    performer_type: List(Codeableconcept),
    performer_role: Option(Codeableconcept),
    performer: Option(Reference),
    performer_link_id: List(String),
    reason: List(Codeablereference),
    reason_link_id: List(String),
    note: List(Annotation),
    security_label_number: List(Int),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Contract#resource
pub type ContractTermActionOccurrence {
  ContractTermActionOccurrenceDatetime(occurrence: String)
  ContractTermActionOccurrencePeriod(occurrence: Period)
  ContractTermActionOccurrenceTiming(occurrence: Timing)
}

///http://hl7.org/fhir/r5/StructureDefinition/Contract#resource
pub type ContractTermActionSubject {
  ContractTermActionSubject(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    reference: List(Reference),
    role: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Contract#resource
pub type ContractSigner {
  ContractSigner(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Coding,
    party: Reference,
    signature: List(Signature),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Contract#resource
pub type ContractFriendly {
  ContractFriendly(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    content: ContractFriendlyContent,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Contract#resource
pub type ContractFriendlyContent {
  ContractFriendlyContentAttachment(content: Attachment)
  ContractFriendlyContentReference(content: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/Contract#resource
pub type ContractLegal {
  ContractLegal(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    content: ContractLegalContent,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Contract#resource
pub type ContractLegalContent {
  ContractLegalContentAttachment(content: Attachment)
  ContractLegalContentReference(content: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/Contract#resource
pub type ContractRule {
  ContractRule(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    content: ContractRuleContent,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Contract#resource
pub type ContractRuleContent {
  ContractRuleContentAttachment(content: Attachment)
  ContractRuleContentReference(content: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/Coverage#resource
pub type Coverage {
  Coverage(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    kind: String,
    payment_by: List(CoveragePaymentby),
    type_: Option(Codeableconcept),
    policy_holder: Option(Reference),
    subscriber: Option(Reference),
    subscriber_id: List(Identifier),
    beneficiary: Reference,
    dependent: Option(String),
    relationship: Option(Codeableconcept),
    period: Option(Period),
    insurer: Option(Reference),
    class: List(CoverageClass),
    order: Option(Int),
    network: Option(String),
    cost_to_beneficiary: List(CoverageCosttobeneficiary),
    subrogation: Option(Bool),
    contract: List(Reference),
    insurance_plan: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Coverage#resource
pub type CoveragePaymentby {
  CoveragePaymentby(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    party: Reference,
    responsibility: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Coverage#resource
pub type CoverageClass {
  CoverageClass(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value: Identifier,
    name: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Coverage#resource
pub type CoverageCosttobeneficiary {
  CoverageCosttobeneficiary(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    category: Option(Codeableconcept),
    network: Option(Codeableconcept),
    unit: Option(Codeableconcept),
    term: Option(Codeableconcept),
    value: Option(CoverageCosttobeneficiaryValue),
    exception: List(CoverageCosttobeneficiaryException),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Coverage#resource
pub type CoverageCosttobeneficiaryValue {
  CoverageCosttobeneficiaryValueQuantity(value: Quantity)
  CoverageCosttobeneficiaryValueMoney(value: Money)
}

///http://hl7.org/fhir/r5/StructureDefinition/Coverage#resource
pub type CoverageCosttobeneficiaryException {
  CoverageCosttobeneficiaryException(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    period: Option(Period),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CoverageEligibilityRequest#resource
pub type Coverageeligibilityrequest {
  Coverageeligibilityrequest(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    priority: Option(Codeableconcept),
    purpose: List(String),
    patient: Reference,
    event: List(CoverageeligibilityrequestEvent),
    serviced: Option(CoverageeligibilityrequestServiced),
    created: String,
    enterer: Option(Reference),
    provider: Option(Reference),
    insurer: Reference,
    facility: Option(Reference),
    supporting_info: List(CoverageeligibilityrequestSupportinginfo),
    insurance: List(CoverageeligibilityrequestInsurance),
    item: List(CoverageeligibilityrequestItem),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CoverageEligibilityRequest#resource
pub type CoverageeligibilityrequestServiced {
  CoverageeligibilityrequestServicedDate(serviced: String)
  CoverageeligibilityrequestServicedPeriod(serviced: Period)
}

///http://hl7.org/fhir/r5/StructureDefinition/CoverageEligibilityRequest#resource
pub type CoverageeligibilityrequestEvent {
  CoverageeligibilityrequestEvent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    when: CoverageeligibilityrequestEventWhen,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CoverageEligibilityRequest#resource
pub type CoverageeligibilityrequestEventWhen {
  CoverageeligibilityrequestEventWhenDatetime(when: String)
  CoverageeligibilityrequestEventWhenPeriod(when: Period)
}

///http://hl7.org/fhir/r5/StructureDefinition/CoverageEligibilityRequest#resource
pub type CoverageeligibilityrequestSupportinginfo {
  CoverageeligibilityrequestSupportinginfo(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Int,
    information: Reference,
    applies_to_all: Option(Bool),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CoverageEligibilityRequest#resource
pub type CoverageeligibilityrequestInsurance {
  CoverageeligibilityrequestInsurance(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    focal: Option(Bool),
    coverage: Reference,
    business_arrangement: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CoverageEligibilityRequest#resource
pub type CoverageeligibilityrequestItem {
  CoverageeligibilityrequestItem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    supporting_info_sequence: List(Int),
    category: Option(Codeableconcept),
    product_or_service: Option(Codeableconcept),
    modifier: List(Codeableconcept),
    provider: Option(Reference),
    quantity: Option(Quantity),
    unit_price: Option(Money),
    facility: Option(Reference),
    diagnosis: List(CoverageeligibilityrequestItemDiagnosis),
    detail: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CoverageEligibilityRequest#resource
pub type CoverageeligibilityrequestItemDiagnosis {
  CoverageeligibilityrequestItemDiagnosis(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    diagnosis: Option(CoverageeligibilityrequestItemDiagnosisDiagnosis),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CoverageEligibilityRequest#resource
pub type CoverageeligibilityrequestItemDiagnosisDiagnosis {
  CoverageeligibilityrequestItemDiagnosisDiagnosisCodeableconcept(
    diagnosis: Codeableconcept,
  )
  CoverageeligibilityrequestItemDiagnosisDiagnosisReference(
    diagnosis: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CoverageEligibilityResponse#resource
pub type Coverageeligibilityresponse {
  Coverageeligibilityresponse(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    purpose: List(String),
    patient: Reference,
    event: List(CoverageeligibilityresponseEvent),
    serviced: Option(CoverageeligibilityresponseServiced),
    created: String,
    requestor: Option(Reference),
    request: Reference,
    outcome: String,
    disposition: Option(String),
    insurer: Reference,
    insurance: List(CoverageeligibilityresponseInsurance),
    pre_auth_ref: Option(String),
    form: Option(Codeableconcept),
    error: List(CoverageeligibilityresponseError),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CoverageEligibilityResponse#resource
pub type CoverageeligibilityresponseServiced {
  CoverageeligibilityresponseServicedDate(serviced: String)
  CoverageeligibilityresponseServicedPeriod(serviced: Period)
}

///http://hl7.org/fhir/r5/StructureDefinition/CoverageEligibilityResponse#resource
pub type CoverageeligibilityresponseEvent {
  CoverageeligibilityresponseEvent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    when: CoverageeligibilityresponseEventWhen,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CoverageEligibilityResponse#resource
pub type CoverageeligibilityresponseEventWhen {
  CoverageeligibilityresponseEventWhenDatetime(when: String)
  CoverageeligibilityresponseEventWhenPeriod(when: Period)
}

///http://hl7.org/fhir/r5/StructureDefinition/CoverageEligibilityResponse#resource
pub type CoverageeligibilityresponseInsurance {
  CoverageeligibilityresponseInsurance(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    coverage: Reference,
    inforce: Option(Bool),
    benefit_period: Option(Period),
    item: List(CoverageeligibilityresponseInsuranceItem),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CoverageEligibilityResponse#resource
pub type CoverageeligibilityresponseInsuranceItem {
  CoverageeligibilityresponseInsuranceItem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    category: Option(Codeableconcept),
    product_or_service: Option(Codeableconcept),
    modifier: List(Codeableconcept),
    provider: Option(Reference),
    excluded: Option(Bool),
    name: Option(String),
    description: Option(String),
    network: Option(Codeableconcept),
    unit: Option(Codeableconcept),
    term: Option(Codeableconcept),
    benefit: List(CoverageeligibilityresponseInsuranceItemBenefit),
    authorization_required: Option(Bool),
    authorization_supporting: List(Codeableconcept),
    authorization_url: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CoverageEligibilityResponse#resource
pub type CoverageeligibilityresponseInsuranceItemBenefit {
  CoverageeligibilityresponseInsuranceItemBenefit(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    allowed: Option(CoverageeligibilityresponseInsuranceItemBenefitAllowed),
    used: Option(CoverageeligibilityresponseInsuranceItemBenefitUsed),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CoverageEligibilityResponse#resource
pub type CoverageeligibilityresponseInsuranceItemBenefitAllowed {
  CoverageeligibilityresponseInsuranceItemBenefitAllowedUnsignedint(
    allowed: Int,
  )
  CoverageeligibilityresponseInsuranceItemBenefitAllowedString(allowed: String)
  CoverageeligibilityresponseInsuranceItemBenefitAllowedMoney(allowed: Money)
}

///http://hl7.org/fhir/r5/StructureDefinition/CoverageEligibilityResponse#resource
pub type CoverageeligibilityresponseInsuranceItemBenefitUsed {
  CoverageeligibilityresponseInsuranceItemBenefitUsedUnsignedint(used: Int)
  CoverageeligibilityresponseInsuranceItemBenefitUsedString(used: String)
  CoverageeligibilityresponseInsuranceItemBenefitUsedMoney(used: Money)
}

///http://hl7.org/fhir/r5/StructureDefinition/CoverageEligibilityResponse#resource
pub type CoverageeligibilityresponseError {
  CoverageeligibilityresponseError(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
    expression: List(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DetectedIssue#resource
pub type Detectedissue {
  Detectedissue(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    category: List(Codeableconcept),
    code: Option(Codeableconcept),
    severity: Option(String),
    subject: Option(Reference),
    encounter: Option(Reference),
    identified: Option(DetectedissueIdentified),
    author: Option(Reference),
    implicated: List(Reference),
    evidence: List(DetectedissueEvidence),
    detail: Option(String),
    reference: Option(String),
    mitigation: List(DetectedissueMitigation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DetectedIssue#resource
pub type DetectedissueIdentified {
  DetectedissueIdentifiedDatetime(identified: String)
  DetectedissueIdentifiedPeriod(identified: Period)
}

///http://hl7.org/fhir/r5/StructureDefinition/DetectedIssue#resource
pub type DetectedissueEvidence {
  DetectedissueEvidence(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: List(Codeableconcept),
    detail: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DetectedIssue#resource
pub type DetectedissueMitigation {
  DetectedissueMitigation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    action: Codeableconcept,
    date: Option(String),
    author: Option(Reference),
    note: List(Annotation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Device#resource
pub type Device {
  Device(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    display_name: Option(String),
    definition: Option(Codeablereference),
    udi_carrier: List(DeviceUdicarrier),
    status: Option(String),
    availability_status: Option(Codeableconcept),
    biological_source_event: Option(Identifier),
    manufacturer: Option(String),
    manufacture_date: Option(String),
    expiration_date: Option(String),
    lot_number: Option(String),
    serial_number: Option(String),
    name: List(DeviceName),
    model_number: Option(String),
    part_number: Option(String),
    category: List(Codeableconcept),
    type_: List(Codeableconcept),
    version: List(DeviceVersion),
    conforms_to: List(DeviceConformsto),
    property: List(DeviceProperty),
    mode: Option(Codeableconcept),
    cycle: Option(Count),
    duration: Option(Duration),
    owner: Option(Reference),
    contact: List(Contactpoint),
    location: Option(Reference),
    url: Option(String),
    endpoint: List(Reference),
    gateway: List(Codeablereference),
    note: List(Annotation),
    safety: List(Codeableconcept),
    parent: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Device#resource
pub type DeviceUdicarrier {
  DeviceUdicarrier(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    device_identifier: String,
    issuer: String,
    jurisdiction: Option(String),
    carrier_aidc: Option(String),
    carrier_hrf: Option(String),
    entry_type: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Device#resource
pub type DeviceName {
  DeviceName(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    value: String,
    type_: String,
    display: Option(Bool),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Device#resource
pub type DeviceVersion {
  DeviceVersion(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    component: Option(Identifier),
    install_date: Option(String),
    value: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Device#resource
pub type DeviceConformsto {
  DeviceConformsto(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    category: Option(Codeableconcept),
    specification: Codeableconcept,
    version: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Device#resource
pub type DeviceProperty {
  DeviceProperty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value: DevicePropertyValue,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Device#resource
pub type DevicePropertyValue {
  DevicePropertyValueQuantity(value: Quantity)
  DevicePropertyValueCodeableconcept(value: Codeableconcept)
  DevicePropertyValueString(value: String)
  DevicePropertyValueBoolean(value: Bool)
  DevicePropertyValueInteger(value: Int)
  DevicePropertyValueRange(value: Range)
  DevicePropertyValueAttachment(value: Attachment)
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceAssociation#resource
pub type Deviceassociation {
  Deviceassociation(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    device: Reference,
    category: List(Codeableconcept),
    status: Codeableconcept,
    status_reason: List(Codeableconcept),
    subject: Option(Reference),
    body_structure: Option(Reference),
    period: Option(Period),
    operation: List(DeviceassociationOperation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceAssociation#resource
pub type DeviceassociationOperation {
  DeviceassociationOperation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    status: Codeableconcept,
    operator: List(Reference),
    period: Option(Period),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceDefinition#resource
pub type Devicedefinition {
  Devicedefinition(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    identifier: List(Identifier),
    udi_device_identifier: List(DevicedefinitionUdideviceidentifier),
    regulatory_identifier: List(DevicedefinitionRegulatoryidentifier),
    part_number: Option(String),
    manufacturer: Option(Reference),
    device_name: List(DevicedefinitionDevicename),
    model_number: Option(String),
    classification: List(DevicedefinitionClassification),
    conforms_to: List(DevicedefinitionConformsto),
    has_part: List(DevicedefinitionHaspart),
    packaging: List(DevicedefinitionPackaging),
    version: List(DevicedefinitionVersion),
    safety: List(Codeableconcept),
    shelf_life_storage: List(Productshelflife),
    language_code: List(Codeableconcept),
    property: List(DevicedefinitionProperty),
    owner: Option(Reference),
    contact: List(Contactpoint),
    link: List(DevicedefinitionLink),
    note: List(Annotation),
    material: List(DevicedefinitionMaterial),
    production_identifier_in_udi: List(String),
    guideline: Option(DevicedefinitionGuideline),
    corrective_action: Option(DevicedefinitionCorrectiveaction),
    charge_item: List(DevicedefinitionChargeitem),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionUdideviceidentifier {
  DevicedefinitionUdideviceidentifier(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    device_identifier: String,
    issuer: String,
    jurisdiction: String,
    market_distribution: List(
      DevicedefinitionUdideviceidentifierMarketdistribution,
    ),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionUdideviceidentifierMarketdistribution {
  DevicedefinitionUdideviceidentifierMarketdistribution(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    market_period: Period,
    sub_jurisdiction: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionRegulatoryidentifier {
  DevicedefinitionRegulatoryidentifier(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: String,
    device_identifier: String,
    issuer: String,
    jurisdiction: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionDevicename {
  DevicedefinitionDevicename(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    type_: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionClassification {
  DevicedefinitionClassification(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    justification: List(Relatedartifact),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionConformsto {
  DevicedefinitionConformsto(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    category: Option(Codeableconcept),
    specification: Codeableconcept,
    version: List(String),
    source: List(Relatedartifact),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionHaspart {
  DevicedefinitionHaspart(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    reference: Reference,
    count: Option(Int),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionPackaging {
  DevicedefinitionPackaging(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Option(Identifier),
    type_: Option(Codeableconcept),
    count: Option(Int),
    distributor: List(DevicedefinitionPackagingDistributor),
    udi_device_identifier: List(Nil),
    packaging: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionPackagingDistributor {
  DevicedefinitionPackagingDistributor(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: Option(String),
    organization_reference: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionVersion {
  DevicedefinitionVersion(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    component: Option(Identifier),
    value: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionProperty {
  DevicedefinitionProperty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value: DevicedefinitionPropertyValue,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionPropertyValue {
  DevicedefinitionPropertyValueQuantity(value: Quantity)
  DevicedefinitionPropertyValueCodeableconcept(value: Codeableconcept)
  DevicedefinitionPropertyValueString(value: String)
  DevicedefinitionPropertyValueBoolean(value: Bool)
  DevicedefinitionPropertyValueInteger(value: Int)
  DevicedefinitionPropertyValueRange(value: Range)
  DevicedefinitionPropertyValueAttachment(value: Attachment)
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionLink {
  DevicedefinitionLink(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    relation: Coding,
    related_device: Codeablereference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionMaterial {
  DevicedefinitionMaterial(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    substance: Codeableconcept,
    alternate: Option(Bool),
    allergenic_indicator: Option(Bool),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionGuideline {
  DevicedefinitionGuideline(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    use_context: List(Usagecontext),
    usage_instruction: Option(String),
    related_artifact: List(Relatedartifact),
    indication: List(Codeableconcept),
    contraindication: List(Codeableconcept),
    warning: List(Codeableconcept),
    intended_use: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionCorrectiveaction {
  DevicedefinitionCorrectiveaction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    recall: Bool,
    scope: Option(String),
    period: Period,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionChargeitem {
  DevicedefinitionChargeitem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    charge_item_code: Codeablereference,
    count: Quantity,
    effective_period: Option(Period),
    use_context: List(Usagecontext),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceDispense#resource
pub type Devicedispense {
  Devicedispense(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    based_on: List(Reference),
    part_of: List(Reference),
    status: String,
    status_reason: Option(Codeablereference),
    category: List(Codeableconcept),
    device: Codeablereference,
    subject: Reference,
    receiver: Option(Reference),
    encounter: Option(Reference),
    supporting_information: List(Reference),
    performer: List(DevicedispensePerformer),
    location: Option(Reference),
    type_: Option(Codeableconcept),
    quantity: Option(Quantity),
    prepared_date: Option(String),
    when_handed_over: Option(String),
    destination: Option(Reference),
    note: List(Annotation),
    usage_instruction: Option(String),
    event_history: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceDispense#resource
pub type DevicedispensePerformer {
  DevicedispensePerformer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    function: Option(Codeableconcept),
    actor: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceMetric#resource
pub type Devicemetric {
  Devicemetric(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    type_: Codeableconcept,
    unit: Option(Codeableconcept),
    device: Reference,
    operational_status: Option(String),
    color: Option(String),
    category: String,
    measurement_frequency: Option(Quantity),
    calibration: List(DevicemetricCalibration),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceMetric#resource
pub type DevicemetricCalibration {
  DevicemetricCalibration(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(String),
    state: Option(String),
    time: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceRequest#resource
pub type Devicerequest {
  Devicerequest(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    instantiates_canonical: List(String),
    instantiates_uri: List(String),
    based_on: List(Reference),
    replaces: List(Reference),
    group_identifier: Option(Identifier),
    status: Option(String),
    intent: String,
    priority: Option(String),
    do_not_perform: Option(Bool),
    code: Codeablereference,
    quantity: Option(Int),
    parameter: List(DevicerequestParameter),
    subject: Reference,
    encounter: Option(Reference),
    occurrence: Option(DevicerequestOccurrence),
    authored_on: Option(String),
    requester: Option(Reference),
    performer: Option(Codeablereference),
    reason: List(Codeablereference),
    as_needed: Option(Bool),
    as_needed_for: Option(Codeableconcept),
    insurance: List(Reference),
    supporting_info: List(Reference),
    note: List(Annotation),
    relevant_history: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceRequest#resource
pub type DevicerequestOccurrence {
  DevicerequestOccurrenceDatetime(occurrence: String)
  DevicerequestOccurrencePeriod(occurrence: Period)
  DevicerequestOccurrenceTiming(occurrence: Timing)
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceRequest#resource
pub type DevicerequestParameter {
  DevicerequestParameter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(Codeableconcept),
    value: Option(DevicerequestParameterValue),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceRequest#resource
pub type DevicerequestParameterValue {
  DevicerequestParameterValueCodeableconcept(value: Codeableconcept)
  DevicerequestParameterValueQuantity(value: Quantity)
  DevicerequestParameterValueRange(value: Range)
  DevicerequestParameterValueBoolean(value: Bool)
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceUsage#resource
pub type Deviceusage {
  Deviceusage(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    based_on: List(Reference),
    status: String,
    category: List(Codeableconcept),
    patient: Reference,
    derived_from: List(Reference),
    context: Option(Reference),
    timing: Option(DeviceusageTiming),
    date_asserted: Option(String),
    usage_status: Option(Codeableconcept),
    usage_reason: List(Codeableconcept),
    adherence: Option(DeviceusageAdherence),
    information_source: Option(Reference),
    device: Codeablereference,
    reason: List(Codeablereference),
    body_site: Option(Codeablereference),
    note: List(Annotation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceUsage#resource
pub type DeviceusageTiming {
  DeviceusageTimingTiming(timing: Timing)
  DeviceusageTimingPeriod(timing: Period)
  DeviceusageTimingDatetime(timing: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceUsage#resource
pub type DeviceusageAdherence {
  DeviceusageAdherence(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
    reason: List(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DiagnosticReport#resource
pub type Diagnosticreport {
  Diagnosticreport(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    based_on: List(Reference),
    status: String,
    category: List(Codeableconcept),
    code: Codeableconcept,
    subject: Option(Reference),
    encounter: Option(Reference),
    effective: Option(DiagnosticreportEffective),
    issued: Option(String),
    performer: List(Reference),
    results_interpreter: List(Reference),
    specimen: List(Reference),
    result: List(Reference),
    note: List(Annotation),
    study: List(Reference),
    supporting_info: List(DiagnosticreportSupportinginfo),
    media: List(DiagnosticreportMedia),
    composition: Option(Reference),
    conclusion: Option(String),
    conclusion_code: List(Codeableconcept),
    presented_form: List(Attachment),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DiagnosticReport#resource
pub type DiagnosticreportEffective {
  DiagnosticreportEffectiveDatetime(effective: String)
  DiagnosticreportEffectivePeriod(effective: Period)
}

///http://hl7.org/fhir/r5/StructureDefinition/DiagnosticReport#resource
pub type DiagnosticreportSupportinginfo {
  DiagnosticreportSupportinginfo(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    reference: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DiagnosticReport#resource
pub type DiagnosticreportMedia {
  DiagnosticreportMedia(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    comment: Option(String),
    link: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DocumentReference#resource
pub type Documentreference {
  Documentreference(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    version: Option(String),
    based_on: List(Reference),
    status: String,
    doc_status: Option(String),
    modality: List(Codeableconcept),
    type_: Option(Codeableconcept),
    category: List(Codeableconcept),
    subject: Option(Reference),
    context: List(Reference),
    event: List(Codeablereference),
    body_site: List(Codeablereference),
    facility_type: Option(Codeableconcept),
    practice_setting: Option(Codeableconcept),
    period: Option(Period),
    date: Option(String),
    author: List(Reference),
    attester: List(DocumentreferenceAttester),
    custodian: Option(Reference),
    relates_to: List(DocumentreferenceRelatesto),
    description: Option(String),
    security_label: List(Codeableconcept),
    content: List(DocumentreferenceContent),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DocumentReference#resource
pub type DocumentreferenceAttester {
  DocumentreferenceAttester(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    mode: Codeableconcept,
    time: Option(String),
    party: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DocumentReference#resource
pub type DocumentreferenceRelatesto {
  DocumentreferenceRelatesto(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
    target: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DocumentReference#resource
pub type DocumentreferenceContent {
  DocumentreferenceContent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    attachment: Attachment,
    profile: List(DocumentreferenceContentProfile),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DocumentReference#resource
pub type DocumentreferenceContentProfile {
  DocumentreferenceContentProfile(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    value: DocumentreferenceContentProfileValue,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DocumentReference#resource
pub type DocumentreferenceContentProfileValue {
  DocumentreferenceContentProfileValueCoding(value: Coding)
  DocumentreferenceContentProfileValueUri(value: String)
  DocumentreferenceContentProfileValueCanonical(value: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/DomainResource#resource
pub type Domainresource {
  Domainresource(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Encounter#resource
pub type Encounter {
  Encounter(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    class: List(Codeableconcept),
    priority: Option(Codeableconcept),
    type_: List(Codeableconcept),
    service_type: List(Codeablereference),
    subject: Option(Reference),
    subject_status: Option(Codeableconcept),
    episode_of_care: List(Reference),
    based_on: List(Reference),
    care_team: List(Reference),
    part_of: Option(Reference),
    service_provider: Option(Reference),
    participant: List(EncounterParticipant),
    appointment: List(Reference),
    virtual_service: List(Virtualservicedetail),
    actual_period: Option(Period),
    planned_start_date: Option(String),
    planned_end_date: Option(String),
    length: Option(Duration),
    reason: List(EncounterReason),
    diagnosis: List(EncounterDiagnosis),
    account: List(Reference),
    diet_preference: List(Codeableconcept),
    special_arrangement: List(Codeableconcept),
    special_courtesy: List(Codeableconcept),
    admission: Option(EncounterAdmission),
    location: List(EncounterLocation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Encounter#resource
pub type EncounterParticipant {
  EncounterParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: List(Codeableconcept),
    period: Option(Period),
    actor: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Encounter#resource
pub type EncounterReason {
  EncounterReason(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    use_: List(Codeableconcept),
    value: List(Codeablereference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Encounter#resource
pub type EncounterDiagnosis {
  EncounterDiagnosis(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    condition: List(Codeablereference),
    use_: List(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Encounter#resource
pub type EncounterAdmission {
  EncounterAdmission(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    pre_admission_identifier: Option(Identifier),
    origin: Option(Reference),
    admit_source: Option(Codeableconcept),
    re_admission: Option(Codeableconcept),
    destination: Option(Reference),
    discharge_disposition: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Encounter#resource
pub type EncounterLocation {
  EncounterLocation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    location: Reference,
    status: Option(String),
    form: Option(Codeableconcept),
    period: Option(Period),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/EncounterHistory#resource
pub type Encounterhistory {
  Encounterhistory(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    encounter: Option(Reference),
    identifier: List(Identifier),
    status: String,
    class: Codeableconcept,
    type_: List(Codeableconcept),
    service_type: List(Codeablereference),
    subject: Option(Reference),
    subject_status: Option(Codeableconcept),
    actual_period: Option(Period),
    planned_start_date: Option(String),
    planned_end_date: Option(String),
    length: Option(Duration),
    location: List(EncounterhistoryLocation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/EncounterHistory#resource
pub type EncounterhistoryLocation {
  EncounterhistoryLocation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    location: Reference,
    form: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Endpoint#resource
pub type Endpoint {
  Endpoint(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    connection_type: List(Codeableconcept),
    name: Option(String),
    description: Option(String),
    environment_type: List(Codeableconcept),
    managing_organization: Option(Reference),
    contact: List(Contactpoint),
    period: Option(Period),
    payload: List(EndpointPayload),
    address: String,
    header: List(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Endpoint#resource
pub type EndpointPayload {
  EndpointPayload(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: List(Codeableconcept),
    mime_type: List(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/EnrollmentRequest#resource
pub type Enrollmentrequest {
  Enrollmentrequest(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: Option(String),
    created: Option(String),
    insurer: Option(Reference),
    provider: Option(Reference),
    candidate: Option(Reference),
    coverage: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/EnrollmentResponse#resource
pub type Enrollmentresponse {
  Enrollmentresponse(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: Option(String),
    request: Option(Reference),
    outcome: Option(String),
    disposition: Option(String),
    created: Option(String),
    organization: Option(Reference),
    request_provider: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/EpisodeOfCare#resource
pub type Episodeofcare {
  Episodeofcare(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    status_history: List(EpisodeofcareStatushistory),
    type_: List(Codeableconcept),
    reason: List(EpisodeofcareReason),
    diagnosis: List(EpisodeofcareDiagnosis),
    patient: Reference,
    managing_organization: Option(Reference),
    period: Option(Period),
    referral_request: List(Reference),
    care_manager: Option(Reference),
    care_team: List(Reference),
    account: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/EpisodeOfCare#resource
pub type EpisodeofcareStatushistory {
  EpisodeofcareStatushistory(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    status: String,
    period: Period,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/EpisodeOfCare#resource
pub type EpisodeofcareReason {
  EpisodeofcareReason(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    use_: Option(Codeableconcept),
    value: List(Codeablereference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/EpisodeOfCare#resource
pub type EpisodeofcareDiagnosis {
  EpisodeofcareDiagnosis(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    condition: List(Codeablereference),
    use_: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/EventDefinition#resource
pub type Eventdefinition {
  Eventdefinition(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(EventdefinitionVersionalgorithm),
    name: Option(String),
    title: Option(String),
    subtitle: Option(String),
    status: String,
    experimental: Option(Bool),
    subject: Option(EventdefinitionSubject),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    usage: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    approval_date: Option(String),
    last_review_date: Option(String),
    effective_period: Option(Period),
    topic: List(Codeableconcept),
    author: List(Contactdetail),
    editor: List(Contactdetail),
    reviewer: List(Contactdetail),
    endorser: List(Contactdetail),
    related_artifact: List(Relatedartifact),
    trigger: List(Triggerdefinition),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/EventDefinition#resource
pub type EventdefinitionVersionalgorithm {
  EventdefinitionVersionalgorithmString(version_algorithm: String)
  EventdefinitionVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/EventDefinition#resource
pub type EventdefinitionSubject {
  EventdefinitionSubjectCodeableconcept(subject: Codeableconcept)
  EventdefinitionSubjectReference(subject: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/Evidence#resource
pub type Evidence {
  Evidence(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(EvidenceVersionalgorithm),
    name: Option(String),
    title: Option(String),
    cite_as: Option(EvidenceCiteas),
    status: String,
    experimental: Option(Bool),
    date: Option(String),
    approval_date: Option(String),
    last_review_date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    author: List(Contactdetail),
    editor: List(Contactdetail),
    reviewer: List(Contactdetail),
    endorser: List(Contactdetail),
    use_context: List(Usagecontext),
    purpose: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    related_artifact: List(Relatedartifact),
    description: Option(String),
    assertion: Option(String),
    note: List(Annotation),
    variable_definition: List(EvidenceVariabledefinition),
    synthesis_type: Option(Codeableconcept),
    study_design: List(Codeableconcept),
    statistic: List(EvidenceStatistic),
    certainty: List(EvidenceCertainty),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Evidence#resource
pub type EvidenceVersionalgorithm {
  EvidenceVersionalgorithmString(version_algorithm: String)
  EvidenceVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/Evidence#resource
pub type EvidenceCiteas {
  EvidenceCiteasReference(cite_as: Reference)
  EvidenceCiteasMarkdown(cite_as: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/Evidence#resource
pub type EvidenceVariabledefinition {
  EvidenceVariabledefinition(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    note: List(Annotation),
    variable_role: Codeableconcept,
    observed: Option(Reference),
    intended: Option(Reference),
    directness_match: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Evidence#resource
pub type EvidenceStatistic {
  EvidenceStatistic(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    note: List(Annotation),
    statistic_type: Option(Codeableconcept),
    category: Option(Codeableconcept),
    quantity: Option(Quantity),
    number_of_events: Option(Int),
    number_affected: Option(Int),
    sample_size: Option(EvidenceStatisticSamplesize),
    attribute_estimate: List(EvidenceStatisticAttributeestimate),
    model_characteristic: List(EvidenceStatisticModelcharacteristic),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Evidence#resource
pub type EvidenceStatisticSamplesize {
  EvidenceStatisticSamplesize(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    note: List(Annotation),
    number_of_studies: Option(Int),
    number_of_participants: Option(Int),
    known_data_count: Option(Int),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Evidence#resource
pub type EvidenceStatisticAttributeestimate {
  EvidenceStatisticAttributeestimate(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    note: List(Annotation),
    type_: Option(Codeableconcept),
    quantity: Option(Quantity),
    level: Option(Float),
    range: Option(Range),
    attribute_estimate: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Evidence#resource
pub type EvidenceStatisticModelcharacteristic {
  EvidenceStatisticModelcharacteristic(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
    value: Option(Quantity),
    variable: List(EvidenceStatisticModelcharacteristicVariable),
    attribute_estimate: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Evidence#resource
pub type EvidenceStatisticModelcharacteristicVariable {
  EvidenceStatisticModelcharacteristicVariable(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    variable_definition: Reference,
    handling: Option(String),
    value_category: List(Codeableconcept),
    value_quantity: List(Quantity),
    value_range: List(Range),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Evidence#resource
pub type EvidenceCertainty {
  EvidenceCertainty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    note: List(Annotation),
    type_: Option(Codeableconcept),
    rating: Option(Codeableconcept),
    rater: Option(String),
    subcomponent: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/EvidenceReport#resource
pub type Evidencereport {
  Evidencereport(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    status: String,
    use_context: List(Usagecontext),
    identifier: List(Identifier),
    related_identifier: List(Identifier),
    cite_as: Option(EvidencereportCiteas),
    type_: Option(Codeableconcept),
    note: List(Annotation),
    related_artifact: List(Relatedartifact),
    subject: EvidencereportSubject,
    publisher: Option(String),
    contact: List(Contactdetail),
    author: List(Contactdetail),
    editor: List(Contactdetail),
    reviewer: List(Contactdetail),
    endorser: List(Contactdetail),
    relates_to: List(EvidencereportRelatesto),
    section: List(EvidencereportSection),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/EvidenceReport#resource
pub type EvidencereportCiteas {
  EvidencereportCiteasReference(cite_as: Reference)
  EvidencereportCiteasMarkdown(cite_as: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/EvidenceReport#resource
pub type EvidencereportSubject {
  EvidencereportSubject(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    characteristic: List(EvidencereportSubjectCharacteristic),
    note: List(Annotation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/EvidenceReport#resource
pub type EvidencereportSubjectCharacteristic {
  EvidencereportSubjectCharacteristic(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
    value: EvidencereportSubjectCharacteristicValue,
    exclude: Option(Bool),
    period: Option(Period),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/EvidenceReport#resource
pub type EvidencereportSubjectCharacteristicValue {
  EvidencereportSubjectCharacteristicValueReference(value: Reference)
  EvidencereportSubjectCharacteristicValueCodeableconcept(
    value: Codeableconcept,
  )
  EvidencereportSubjectCharacteristicValueBoolean(value: Bool)
  EvidencereportSubjectCharacteristicValueQuantity(value: Quantity)
  EvidencereportSubjectCharacteristicValueRange(value: Range)
}

///http://hl7.org/fhir/r5/StructureDefinition/EvidenceReport#resource
pub type EvidencereportRelatesto {
  EvidencereportRelatesto(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    target: EvidencereportRelatestoTarget,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/EvidenceReport#resource
pub type EvidencereportRelatestoTarget {
  EvidencereportRelatestoTarget(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: Option(Identifier),
    display: Option(String),
    resource: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/EvidenceReport#resource
pub type EvidencereportSection {
  EvidencereportSection(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    title: Option(String),
    focus: Option(Codeableconcept),
    focus_reference: Option(Reference),
    author: List(Reference),
    text: Option(Narrative),
    mode: Option(String),
    ordered_by: Option(Codeableconcept),
    entry_classifier: List(Codeableconcept),
    entry_reference: List(Reference),
    entry_quantity: List(Quantity),
    empty_reason: Option(Codeableconcept),
    section: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/EvidenceVariable#resource
pub type Evidencevariable {
  Evidencevariable(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(EvidencevariableVersionalgorithm),
    name: Option(String),
    title: Option(String),
    short_title: Option(String),
    status: String,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    note: List(Annotation),
    use_context: List(Usagecontext),
    purpose: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    approval_date: Option(String),
    last_review_date: Option(String),
    effective_period: Option(Period),
    author: List(Contactdetail),
    editor: List(Contactdetail),
    reviewer: List(Contactdetail),
    endorser: List(Contactdetail),
    related_artifact: List(Relatedartifact),
    actual: Option(Bool),
    characteristic: List(EvidencevariableCharacteristic),
    handling: Option(String),
    category: List(EvidencevariableCategory),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/EvidenceVariable#resource
pub type EvidencevariableVersionalgorithm {
  EvidencevariableVersionalgorithmString(version_algorithm: String)
  EvidencevariableVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/EvidenceVariable#resource
pub type EvidencevariableCharacteristic {
  EvidencevariableCharacteristic(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    link_id: Option(String),
    description: Option(String),
    note: List(Annotation),
    exclude: Option(Bool),
    definition_reference: Option(Reference),
    definition_canonical: Option(String),
    definition_codeable_concept: Option(Codeableconcept),
    definition_expression: Option(Expression),
    definition_id: Option(String),
    definition_by_type_and_value: Option(
      EvidencevariableCharacteristicDefinitionbytypeandvalue,
    ),
    definition_by_combination: Option(
      EvidencevariableCharacteristicDefinitionbycombination,
    ),
    instances: Option(EvidencevariableCharacteristicInstances),
    duration: Option(EvidencevariableCharacteristicDuration),
    time_from_event: List(EvidencevariableCharacteristicTimefromevent),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/EvidenceVariable#resource
pub type EvidencevariableCharacteristicInstances {
  EvidencevariableCharacteristicInstancesQuantity(instances: Quantity)
  EvidencevariableCharacteristicInstancesRange(instances: Range)
}

///http://hl7.org/fhir/r5/StructureDefinition/EvidenceVariable#resource
pub type EvidencevariableCharacteristicDuration {
  EvidencevariableCharacteristicDurationQuantity(duration: Quantity)
  EvidencevariableCharacteristicDurationRange(duration: Range)
}

///http://hl7.org/fhir/r5/StructureDefinition/EvidenceVariable#resource
pub type EvidencevariableCharacteristicDefinitionbytypeandvalue {
  EvidencevariableCharacteristicDefinitionbytypeandvalue(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    method: List(Codeableconcept),
    device: Option(Reference),
    value: EvidencevariableCharacteristicDefinitionbytypeandvalueValue,
    offset: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/EvidenceVariable#resource
pub type EvidencevariableCharacteristicDefinitionbytypeandvalueValue {
  EvidencevariableCharacteristicDefinitionbytypeandvalueValueCodeableconcept(
    value: Codeableconcept,
  )
  EvidencevariableCharacteristicDefinitionbytypeandvalueValueBoolean(
    value: Bool,
  )
  EvidencevariableCharacteristicDefinitionbytypeandvalueValueQuantity(
    value: Quantity,
  )
  EvidencevariableCharacteristicDefinitionbytypeandvalueValueRange(value: Range)
  EvidencevariableCharacteristicDefinitionbytypeandvalueValueReference(
    value: Reference,
  )
  EvidencevariableCharacteristicDefinitionbytypeandvalueValueId(value: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/EvidenceVariable#resource
pub type EvidencevariableCharacteristicDefinitionbycombination {
  EvidencevariableCharacteristicDefinitionbycombination(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    threshold: Option(Int),
    characteristic: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/EvidenceVariable#resource
pub type EvidencevariableCharacteristicTimefromevent {
  EvidencevariableCharacteristicTimefromevent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    note: List(Annotation),
    event: Option(EvidencevariableCharacteristicTimefromeventEvent),
    quantity: Option(Quantity),
    range: Option(Range),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/EvidenceVariable#resource
pub type EvidencevariableCharacteristicTimefromeventEvent {
  EvidencevariableCharacteristicTimefromeventEventCodeableconcept(
    event: Codeableconcept,
  )
  EvidencevariableCharacteristicTimefromeventEventReference(event: Reference)
  EvidencevariableCharacteristicTimefromeventEventDatetime(event: String)
  EvidencevariableCharacteristicTimefromeventEventId(event: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/EvidenceVariable#resource
pub type EvidencevariableCategory {
  EvidencevariableCategory(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: Option(String),
    value: Option(EvidencevariableCategoryValue),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/EvidenceVariable#resource
pub type EvidencevariableCategoryValue {
  EvidencevariableCategoryValueCodeableconcept(value: Codeableconcept)
  EvidencevariableCategoryValueQuantity(value: Quantity)
  EvidencevariableCategoryValueRange(value: Range)
}

///http://hl7.org/fhir/r5/StructureDefinition/ExampleScenario#resource
pub type Examplescenario {
  Examplescenario(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(ExamplescenarioVersionalgorithm),
    name: Option(String),
    title: Option(String),
    status: String,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    actor: List(ExamplescenarioActor),
    instance: List(ExamplescenarioInstance),
    process: List(ExamplescenarioProcess),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExampleScenario#resource
pub type ExamplescenarioVersionalgorithm {
  ExamplescenarioVersionalgorithmString(version_algorithm: String)
  ExamplescenarioVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/ExampleScenario#resource
pub type ExamplescenarioActor {
  ExamplescenarioActor(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    key: String,
    type_: String,
    title: String,
    description: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExampleScenario#resource
pub type ExamplescenarioInstance {
  ExamplescenarioInstance(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    key: String,
    structure_type: Coding,
    structure_version: Option(String),
    structure_profile: Option(ExamplescenarioInstanceStructureprofile),
    title: String,
    description: Option(String),
    content: Option(Reference),
    version: List(ExamplescenarioInstanceVersion),
    contained_instance: List(ExamplescenarioInstanceContainedinstance),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExampleScenario#resource
pub type ExamplescenarioInstanceStructureprofile {
  ExamplescenarioInstanceStructureprofileCanonical(structure_profile: String)
  ExamplescenarioInstanceStructureprofileUri(structure_profile: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/ExampleScenario#resource
pub type ExamplescenarioInstanceVersion {
  ExamplescenarioInstanceVersion(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    key: String,
    title: String,
    description: Option(String),
    content: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExampleScenario#resource
pub type ExamplescenarioInstanceContainedinstance {
  ExamplescenarioInstanceContainedinstance(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    instance_reference: String,
    version_reference: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExampleScenario#resource
pub type ExamplescenarioProcess {
  ExamplescenarioProcess(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    title: String,
    description: Option(String),
    pre_conditions: Option(String),
    post_conditions: Option(String),
    step: List(ExamplescenarioProcessStep),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExampleScenario#resource
pub type ExamplescenarioProcessStep {
  ExamplescenarioProcessStep(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    number: Option(String),
    process: Option(Nil),
    workflow: Option(String),
    operation: Option(ExamplescenarioProcessStepOperation),
    alternative: List(ExamplescenarioProcessStepAlternative),
    pause: Option(Bool),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExampleScenario#resource
pub type ExamplescenarioProcessStepOperation {
  ExamplescenarioProcessStepOperation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Coding),
    title: String,
    initiator: Option(String),
    receiver: Option(String),
    description: Option(String),
    initiator_active: Option(Bool),
    receiver_active: Option(Bool),
    request: Option(Nil),
    response: Option(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExampleScenario#resource
pub type ExamplescenarioProcessStepAlternative {
  ExamplescenarioProcessStepAlternative(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    title: String,
    description: Option(String),
    step: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type Explanationofbenefit {
  Explanationofbenefit(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    trace_number: List(Identifier),
    status: String,
    type_: Codeableconcept,
    sub_type: Option(Codeableconcept),
    use_: String,
    patient: Reference,
    billable_period: Option(Period),
    created: String,
    enterer: Option(Reference),
    insurer: Option(Reference),
    provider: Option(Reference),
    priority: Option(Codeableconcept),
    funds_reserve_requested: Option(Codeableconcept),
    funds_reserve: Option(Codeableconcept),
    related: List(ExplanationofbenefitRelated),
    prescription: Option(Reference),
    original_prescription: Option(Reference),
    event: List(ExplanationofbenefitEvent),
    payee: Option(ExplanationofbenefitPayee),
    referral: Option(Reference),
    encounter: List(Reference),
    facility: Option(Reference),
    claim: Option(Reference),
    claim_response: Option(Reference),
    outcome: String,
    decision: Option(Codeableconcept),
    disposition: Option(String),
    pre_auth_ref: List(String),
    pre_auth_ref_period: List(Period),
    diagnosis_related_group: Option(Codeableconcept),
    care_team: List(ExplanationofbenefitCareteam),
    supporting_info: List(ExplanationofbenefitSupportinginfo),
    diagnosis: List(ExplanationofbenefitDiagnosis),
    procedure: List(ExplanationofbenefitProcedure),
    precedence: Option(Int),
    insurance: List(ExplanationofbenefitInsurance),
    accident: Option(ExplanationofbenefitAccident),
    patient_paid: Option(Money),
    item: List(ExplanationofbenefitItem),
    add_item: List(ExplanationofbenefitAdditem),
    adjudication: List(Nil),
    total: List(ExplanationofbenefitTotal),
    payment: Option(ExplanationofbenefitPayment),
    form_code: Option(Codeableconcept),
    form: Option(Attachment),
    process_note: List(ExplanationofbenefitProcessnote),
    benefit_period: Option(Period),
    benefit_balance: List(ExplanationofbenefitBenefitbalance),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitRelated {
  ExplanationofbenefitRelated(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    claim: Option(Reference),
    relationship: Option(Codeableconcept),
    reference: Option(Identifier),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitEvent {
  ExplanationofbenefitEvent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    when: ExplanationofbenefitEventWhen,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitEventWhen {
  ExplanationofbenefitEventWhenDatetime(when: String)
  ExplanationofbenefitEventWhenPeriod(when: Period)
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitPayee {
  ExplanationofbenefitPayee(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    party: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitCareteam {
  ExplanationofbenefitCareteam(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Int,
    provider: Reference,
    responsible: Option(Bool),
    role: Option(Codeableconcept),
    specialty: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitSupportinginfo {
  ExplanationofbenefitSupportinginfo(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Int,
    category: Codeableconcept,
    code: Option(Codeableconcept),
    timing: Option(ExplanationofbenefitSupportinginfoTiming),
    value: Option(ExplanationofbenefitSupportinginfoValue),
    reason: Option(Coding),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitSupportinginfoTiming {
  ExplanationofbenefitSupportinginfoTimingDate(timing: String)
  ExplanationofbenefitSupportinginfoTimingPeriod(timing: Period)
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitSupportinginfoValue {
  ExplanationofbenefitSupportinginfoValueBoolean(value: Bool)
  ExplanationofbenefitSupportinginfoValueString(value: String)
  ExplanationofbenefitSupportinginfoValueQuantity(value: Quantity)
  ExplanationofbenefitSupportinginfoValueAttachment(value: Attachment)
  ExplanationofbenefitSupportinginfoValueReference(value: Reference)
  ExplanationofbenefitSupportinginfoValueIdentifier(value: Identifier)
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitDiagnosis {
  ExplanationofbenefitDiagnosis(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Int,
    diagnosis: ExplanationofbenefitDiagnosisDiagnosis,
    type_: List(Codeableconcept),
    on_admission: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitDiagnosisDiagnosis {
  ExplanationofbenefitDiagnosisDiagnosisCodeableconcept(
    diagnosis: Codeableconcept,
  )
  ExplanationofbenefitDiagnosisDiagnosisReference(diagnosis: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitProcedure {
  ExplanationofbenefitProcedure(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Int,
    type_: List(Codeableconcept),
    date: Option(String),
    procedure: ExplanationofbenefitProcedureProcedure,
    udi: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitProcedureProcedure {
  ExplanationofbenefitProcedureProcedureCodeableconcept(
    procedure: Codeableconcept,
  )
  ExplanationofbenefitProcedureProcedureReference(procedure: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitInsurance {
  ExplanationofbenefitInsurance(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    focal: Bool,
    coverage: Reference,
    pre_auth_ref: List(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitAccident {
  ExplanationofbenefitAccident(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    date: Option(String),
    type_: Option(Codeableconcept),
    location: Option(ExplanationofbenefitAccidentLocation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitAccidentLocation {
  ExplanationofbenefitAccidentLocationAddress(location: Address)
  ExplanationofbenefitAccidentLocationReference(location: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitItem {
  ExplanationofbenefitItem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Int,
    care_team_sequence: List(Int),
    diagnosis_sequence: List(Int),
    procedure_sequence: List(Int),
    information_sequence: List(Int),
    trace_number: List(Identifier),
    revenue: Option(Codeableconcept),
    category: Option(Codeableconcept),
    product_or_service: Option(Codeableconcept),
    product_or_service_end: Option(Codeableconcept),
    request: List(Reference),
    modifier: List(Codeableconcept),
    program_code: List(Codeableconcept),
    serviced: Option(ExplanationofbenefitItemServiced),
    location: Option(ExplanationofbenefitItemLocation),
    patient_paid: Option(Money),
    quantity: Option(Quantity),
    unit_price: Option(Money),
    factor: Option(Float),
    tax: Option(Money),
    net: Option(Money),
    udi: List(Reference),
    body_site: List(ExplanationofbenefitItemBodysite),
    encounter: List(Reference),
    note_number: List(Int),
    review_outcome: Option(ExplanationofbenefitItemReviewoutcome),
    adjudication: List(ExplanationofbenefitItemAdjudication),
    detail: List(ExplanationofbenefitItemDetail),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitItemServiced {
  ExplanationofbenefitItemServicedDate(serviced: String)
  ExplanationofbenefitItemServicedPeriod(serviced: Period)
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitItemLocation {
  ExplanationofbenefitItemLocationCodeableconcept(location: Codeableconcept)
  ExplanationofbenefitItemLocationAddress(location: Address)
  ExplanationofbenefitItemLocationReference(location: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitItemBodysite {
  ExplanationofbenefitItemBodysite(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    site: List(Codeablereference),
    sub_site: List(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitItemReviewoutcome {
  ExplanationofbenefitItemReviewoutcome(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    decision: Option(Codeableconcept),
    reason: List(Codeableconcept),
    pre_auth_ref: Option(String),
    pre_auth_period: Option(Period),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitItemAdjudication {
  ExplanationofbenefitItemAdjudication(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    category: Codeableconcept,
    reason: Option(Codeableconcept),
    amount: Option(Money),
    quantity: Option(Quantity),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitItemDetail {
  ExplanationofbenefitItemDetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Int,
    trace_number: List(Identifier),
    revenue: Option(Codeableconcept),
    category: Option(Codeableconcept),
    product_or_service: Option(Codeableconcept),
    product_or_service_end: Option(Codeableconcept),
    modifier: List(Codeableconcept),
    program_code: List(Codeableconcept),
    patient_paid: Option(Money),
    quantity: Option(Quantity),
    unit_price: Option(Money),
    factor: Option(Float),
    tax: Option(Money),
    net: Option(Money),
    udi: List(Reference),
    note_number: List(Int),
    review_outcome: Option(Nil),
    adjudication: List(Nil),
    sub_detail: List(ExplanationofbenefitItemDetailSubdetail),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitItemDetailSubdetail {
  ExplanationofbenefitItemDetailSubdetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Int,
    trace_number: List(Identifier),
    revenue: Option(Codeableconcept),
    category: Option(Codeableconcept),
    product_or_service: Option(Codeableconcept),
    product_or_service_end: Option(Codeableconcept),
    modifier: List(Codeableconcept),
    program_code: List(Codeableconcept),
    patient_paid: Option(Money),
    quantity: Option(Quantity),
    unit_price: Option(Money),
    factor: Option(Float),
    tax: Option(Money),
    net: Option(Money),
    udi: List(Reference),
    note_number: List(Int),
    review_outcome: Option(Nil),
    adjudication: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitAdditem {
  ExplanationofbenefitAdditem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item_sequence: List(Int),
    detail_sequence: List(Int),
    sub_detail_sequence: List(Int),
    trace_number: List(Identifier),
    provider: List(Reference),
    revenue: Option(Codeableconcept),
    product_or_service: Option(Codeableconcept),
    product_or_service_end: Option(Codeableconcept),
    request: List(Reference),
    modifier: List(Codeableconcept),
    program_code: List(Codeableconcept),
    serviced: Option(ExplanationofbenefitAdditemServiced),
    location: Option(ExplanationofbenefitAdditemLocation),
    patient_paid: Option(Money),
    quantity: Option(Quantity),
    unit_price: Option(Money),
    factor: Option(Float),
    tax: Option(Money),
    net: Option(Money),
    body_site: List(ExplanationofbenefitAdditemBodysite),
    note_number: List(Int),
    review_outcome: Option(Nil),
    adjudication: List(Nil),
    detail: List(ExplanationofbenefitAdditemDetail),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitAdditemServiced {
  ExplanationofbenefitAdditemServicedDate(serviced: String)
  ExplanationofbenefitAdditemServicedPeriod(serviced: Period)
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitAdditemLocation {
  ExplanationofbenefitAdditemLocationCodeableconcept(location: Codeableconcept)
  ExplanationofbenefitAdditemLocationAddress(location: Address)
  ExplanationofbenefitAdditemLocationReference(location: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitAdditemBodysite {
  ExplanationofbenefitAdditemBodysite(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    site: List(Codeablereference),
    sub_site: List(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitAdditemDetail {
  ExplanationofbenefitAdditemDetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    trace_number: List(Identifier),
    revenue: Option(Codeableconcept),
    product_or_service: Option(Codeableconcept),
    product_or_service_end: Option(Codeableconcept),
    modifier: List(Codeableconcept),
    patient_paid: Option(Money),
    quantity: Option(Quantity),
    unit_price: Option(Money),
    factor: Option(Float),
    tax: Option(Money),
    net: Option(Money),
    note_number: List(Int),
    review_outcome: Option(Nil),
    adjudication: List(Nil),
    sub_detail: List(ExplanationofbenefitAdditemDetailSubdetail),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitAdditemDetailSubdetail {
  ExplanationofbenefitAdditemDetailSubdetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    trace_number: List(Identifier),
    revenue: Option(Codeableconcept),
    product_or_service: Option(Codeableconcept),
    product_or_service_end: Option(Codeableconcept),
    modifier: List(Codeableconcept),
    patient_paid: Option(Money),
    quantity: Option(Quantity),
    unit_price: Option(Money),
    factor: Option(Float),
    tax: Option(Money),
    net: Option(Money),
    note_number: List(Int),
    review_outcome: Option(Nil),
    adjudication: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitTotal {
  ExplanationofbenefitTotal(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    category: Codeableconcept,
    amount: Money,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitPayment {
  ExplanationofbenefitPayment(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    adjustment: Option(Money),
    adjustment_reason: Option(Codeableconcept),
    date: Option(String),
    amount: Option(Money),
    identifier: Option(Identifier),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitProcessnote {
  ExplanationofbenefitProcessnote(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    number: Option(Int),
    type_: Option(Codeableconcept),
    text: Option(String),
    language: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitBenefitbalance {
  ExplanationofbenefitBenefitbalance(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    category: Codeableconcept,
    excluded: Option(Bool),
    name: Option(String),
    description: Option(String),
    network: Option(Codeableconcept),
    unit: Option(Codeableconcept),
    term: Option(Codeableconcept),
    financial: List(ExplanationofbenefitBenefitbalanceFinancial),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitBenefitbalanceFinancial {
  ExplanationofbenefitBenefitbalanceFinancial(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    allowed: Option(ExplanationofbenefitBenefitbalanceFinancialAllowed),
    used: Option(ExplanationofbenefitBenefitbalanceFinancialUsed),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitBenefitbalanceFinancialAllowed {
  ExplanationofbenefitBenefitbalanceFinancialAllowedUnsignedint(allowed: Int)
  ExplanationofbenefitBenefitbalanceFinancialAllowedString(allowed: String)
  ExplanationofbenefitBenefitbalanceFinancialAllowedMoney(allowed: Money)
}

///http://hl7.org/fhir/r5/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitBenefitbalanceFinancialUsed {
  ExplanationofbenefitBenefitbalanceFinancialUsedUnsignedint(used: Int)
  ExplanationofbenefitBenefitbalanceFinancialUsedMoney(used: Money)
}

///http://hl7.org/fhir/r5/StructureDefinition/FamilyMemberHistory#resource
pub type Familymemberhistory {
  Familymemberhistory(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    instantiates_canonical: List(String),
    instantiates_uri: List(String),
    status: String,
    data_absent_reason: Option(Codeableconcept),
    patient: Reference,
    date: Option(String),
    participant: List(FamilymemberhistoryParticipant),
    name: Option(String),
    relationship: Codeableconcept,
    sex: Option(Codeableconcept),
    born: Option(FamilymemberhistoryBorn),
    age: Option(FamilymemberhistoryAge),
    estimated_age: Option(Bool),
    deceased: Option(FamilymemberhistoryDeceased),
    reason: List(Codeablereference),
    note: List(Annotation),
    condition: List(FamilymemberhistoryCondition),
    procedure: List(FamilymemberhistoryProcedure),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/FamilyMemberHistory#resource
pub type FamilymemberhistoryBorn {
  FamilymemberhistoryBornPeriod(born: Period)
  FamilymemberhistoryBornDate(born: String)
  FamilymemberhistoryBornString(born: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/FamilyMemberHistory#resource
pub type FamilymemberhistoryAge {
  FamilymemberhistoryAgeAge(age: Age)
  FamilymemberhistoryAgeRange(age: Range)
  FamilymemberhistoryAgeString(age: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/FamilyMemberHistory#resource
pub type FamilymemberhistoryDeceased {
  FamilymemberhistoryDeceasedBoolean(deceased: Bool)
  FamilymemberhistoryDeceasedAge(deceased: Age)
  FamilymemberhistoryDeceasedRange(deceased: Range)
  FamilymemberhistoryDeceasedDate(deceased: String)
  FamilymemberhistoryDeceasedString(deceased: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/FamilyMemberHistory#resource
pub type FamilymemberhistoryParticipant {
  FamilymemberhistoryParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    function: Option(Codeableconcept),
    actor: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/FamilyMemberHistory#resource
pub type FamilymemberhistoryCondition {
  FamilymemberhistoryCondition(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
    outcome: Option(Codeableconcept),
    contributed_to_death: Option(Bool),
    onset: Option(FamilymemberhistoryConditionOnset),
    note: List(Annotation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/FamilyMemberHistory#resource
pub type FamilymemberhistoryConditionOnset {
  FamilymemberhistoryConditionOnsetAge(onset: Age)
  FamilymemberhistoryConditionOnsetRange(onset: Range)
  FamilymemberhistoryConditionOnsetPeriod(onset: Period)
  FamilymemberhistoryConditionOnsetString(onset: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/FamilyMemberHistory#resource
pub type FamilymemberhistoryProcedure {
  FamilymemberhistoryProcedure(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
    outcome: Option(Codeableconcept),
    contributed_to_death: Option(Bool),
    performed: Option(FamilymemberhistoryProcedurePerformed),
    note: List(Annotation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/FamilyMemberHistory#resource
pub type FamilymemberhistoryProcedurePerformed {
  FamilymemberhistoryProcedurePerformedAge(performed: Age)
  FamilymemberhistoryProcedurePerformedRange(performed: Range)
  FamilymemberhistoryProcedurePerformedPeriod(performed: Period)
  FamilymemberhistoryProcedurePerformedString(performed: String)
  FamilymemberhistoryProcedurePerformedDatetime(performed: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/Flag#resource
pub type Flag {
  Flag(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    category: List(Codeableconcept),
    code: Codeableconcept,
    subject: Reference,
    period: Option(Period),
    encounter: Option(Reference),
    author: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/FormularyItem#resource
pub type Formularyitem {
  Formularyitem(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    code: Option(Codeableconcept),
    status: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/GenomicStudy#resource
pub type Genomicstudy {
  Genomicstudy(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    type_: List(Codeableconcept),
    subject: Reference,
    encounter: Option(Reference),
    start_date: Option(String),
    based_on: List(Reference),
    referrer: Option(Reference),
    interpreter: List(Reference),
    reason: List(Codeablereference),
    instantiates_canonical: Option(String),
    instantiates_uri: Option(String),
    note: List(Annotation),
    description: Option(String),
    analysis: List(GenomicstudyAnalysis),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/GenomicStudy#resource
pub type GenomicstudyAnalysis {
  GenomicstudyAnalysis(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    method_type: List(Codeableconcept),
    change_type: List(Codeableconcept),
    genome_build: Option(Codeableconcept),
    instantiates_canonical: Option(String),
    instantiates_uri: Option(String),
    title: Option(String),
    focus: List(Reference),
    specimen: List(Reference),
    date: Option(String),
    note: List(Annotation),
    protocol_performed: Option(Reference),
    regions_studied: List(Reference),
    regions_called: List(Reference),
    input: List(GenomicstudyAnalysisInput),
    output: List(GenomicstudyAnalysisOutput),
    performer: List(GenomicstudyAnalysisPerformer),
    device: List(GenomicstudyAnalysisDevice),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/GenomicStudy#resource
pub type GenomicstudyAnalysisInput {
  GenomicstudyAnalysisInput(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    file: Option(Reference),
    type_: Option(Codeableconcept),
    generated_by: Option(GenomicstudyAnalysisInputGeneratedby),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/GenomicStudy#resource
pub type GenomicstudyAnalysisInputGeneratedby {
  GenomicstudyAnalysisInputGeneratedbyIdentifier(generated_by: Identifier)
  GenomicstudyAnalysisInputGeneratedbyReference(generated_by: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/GenomicStudy#resource
pub type GenomicstudyAnalysisOutput {
  GenomicstudyAnalysisOutput(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    file: Option(Reference),
    type_: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/GenomicStudy#resource
pub type GenomicstudyAnalysisPerformer {
  GenomicstudyAnalysisPerformer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    actor: Option(Reference),
    role: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/GenomicStudy#resource
pub type GenomicstudyAnalysisDevice {
  GenomicstudyAnalysisDevice(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    device: Option(Reference),
    function: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Goal#resource
pub type Goal {
  Goal(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    lifecycle_status: String,
    achievement_status: Option(Codeableconcept),
    category: List(Codeableconcept),
    continuous: Option(Bool),
    priority: Option(Codeableconcept),
    description: Codeableconcept,
    subject: Reference,
    start: Option(GoalStart),
    target: List(GoalTarget),
    status_date: Option(String),
    status_reason: Option(String),
    source: Option(Reference),
    addresses: List(Reference),
    note: List(Annotation),
    outcome: List(Codeablereference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Goal#resource
pub type GoalStart {
  GoalStartDate(start: String)
  GoalStartCodeableconcept(start: Codeableconcept)
}

///http://hl7.org/fhir/r5/StructureDefinition/Goal#resource
pub type GoalTarget {
  GoalTarget(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    measure: Option(Codeableconcept),
    detail: Option(GoalTargetDetail),
    due: Option(GoalTargetDue),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Goal#resource
pub type GoalTargetDetail {
  GoalTargetDetailQuantity(detail: Quantity)
  GoalTargetDetailRange(detail: Range)
  GoalTargetDetailCodeableconcept(detail: Codeableconcept)
  GoalTargetDetailString(detail: String)
  GoalTargetDetailBoolean(detail: Bool)
  GoalTargetDetailInteger(detail: Int)
  GoalTargetDetailRatio(detail: Ratio)
}

///http://hl7.org/fhir/r5/StructureDefinition/Goal#resource
pub type GoalTargetDue {
  GoalTargetDueDate(due: String)
  GoalTargetDueDuration(due: Duration)
}

///http://hl7.org/fhir/r5/StructureDefinition/GraphDefinition#resource
pub type Graphdefinition {
  Graphdefinition(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(GraphdefinitionVersionalgorithm),
    name: String,
    title: Option(String),
    status: String,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    start: Option(String),
    node: List(GraphdefinitionNode),
    link: List(GraphdefinitionLink),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/GraphDefinition#resource
pub type GraphdefinitionVersionalgorithm {
  GraphdefinitionVersionalgorithmString(version_algorithm: String)
  GraphdefinitionVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/GraphDefinition#resource
pub type GraphdefinitionNode {
  GraphdefinitionNode(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    node_id: String,
    description: Option(String),
    type_: String,
    profile: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/GraphDefinition#resource
pub type GraphdefinitionLink {
  GraphdefinitionLink(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    min: Option(Int),
    max: Option(String),
    source_id: String,
    path: Option(String),
    slice_name: Option(String),
    target_id: String,
    params: Option(String),
    compartment: List(GraphdefinitionLinkCompartment),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/GraphDefinition#resource
pub type GraphdefinitionLinkCompartment {
  GraphdefinitionLinkCompartment(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    use_: String,
    rule: String,
    code: String,
    expression: Option(String),
    description: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Group#resource
pub type Group {
  Group(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    active: Option(Bool),
    type_: String,
    membership: String,
    code: Option(Codeableconcept),
    name: Option(String),
    description: Option(String),
    quantity: Option(Int),
    managing_entity: Option(Reference),
    characteristic: List(GroupCharacteristic),
    member: List(GroupMember),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Group#resource
pub type GroupCharacteristic {
  GroupCharacteristic(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
    value: GroupCharacteristicValue,
    exclude: Bool,
    period: Option(Period),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Group#resource
pub type GroupCharacteristicValue {
  GroupCharacteristicValueCodeableconcept(value: Codeableconcept)
  GroupCharacteristicValueBoolean(value: Bool)
  GroupCharacteristicValueQuantity(value: Quantity)
  GroupCharacteristicValueRange(value: Range)
  GroupCharacteristicValueReference(value: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/Group#resource
pub type GroupMember {
  GroupMember(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    entity: Reference,
    period: Option(Period),
    inactive: Option(Bool),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/GuidanceResponse#resource
pub type Guidanceresponse {
  Guidanceresponse(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    request_identifier: Option(Identifier),
    identifier: List(Identifier),
    module: GuidanceresponseModule,
    status: String,
    subject: Option(Reference),
    encounter: Option(Reference),
    occurrence_date_time: Option(String),
    performer: Option(Reference),
    reason: List(Codeablereference),
    note: List(Annotation),
    evaluation_message: Option(Reference),
    output_parameters: Option(Reference),
    result: List(Reference),
    data_requirement: List(Datarequirement),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/GuidanceResponse#resource
pub type GuidanceresponseModule {
  GuidanceresponseModuleUri(module: String)
  GuidanceresponseModuleCanonical(module: String)
  GuidanceresponseModuleCodeableconcept(module: Codeableconcept)
}

///http://hl7.org/fhir/r5/StructureDefinition/HealthcareService#resource
pub type Healthcareservice {
  Healthcareservice(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    active: Option(Bool),
    provided_by: Option(Reference),
    offered_in: List(Reference),
    category: List(Codeableconcept),
    type_: List(Codeableconcept),
    specialty: List(Codeableconcept),
    location: List(Reference),
    name: Option(String),
    comment: Option(String),
    extra_details: Option(String),
    photo: Option(Attachment),
    contact: List(Extendedcontactdetail),
    coverage_area: List(Reference),
    service_provision_code: List(Codeableconcept),
    eligibility: List(HealthcareserviceEligibility),
    program: List(Codeableconcept),
    characteristic: List(Codeableconcept),
    communication: List(Codeableconcept),
    referral_method: List(Codeableconcept),
    appointment_required: Option(Bool),
    availability: List(Availability),
    endpoint: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/HealthcareService#resource
pub type HealthcareserviceEligibility {
  HealthcareserviceEligibility(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(Codeableconcept),
    comment: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ImagingSelection#resource
pub type Imagingselection {
  Imagingselection(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    subject: Option(Reference),
    issued: Option(String),
    performer: List(ImagingselectionPerformer),
    based_on: List(Reference),
    category: List(Codeableconcept),
    code: Codeableconcept,
    study_uid: Option(String),
    derived_from: List(Reference),
    endpoint: List(Reference),
    series_uid: Option(String),
    series_number: Option(Int),
    frame_of_reference_uid: Option(String),
    body_site: Option(Codeablereference),
    focus: List(Reference),
    instance: List(ImagingselectionInstance),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ImagingSelection#resource
pub type ImagingselectionPerformer {
  ImagingselectionPerformer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    function: Option(Codeableconcept),
    actor: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ImagingSelection#resource
pub type ImagingselectionInstance {
  ImagingselectionInstance(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    uid: String,
    number: Option(Int),
    sop_class: Option(Coding),
    subset: List(String),
    image_region2_d: List(ImagingselectionInstanceImageregion2d),
    image_region3_d: List(ImagingselectionInstanceImageregion3d),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ImagingSelection#resource
pub type ImagingselectionInstanceImageregion2d {
  ImagingselectionInstanceImageregion2d(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    region_type: String,
    coordinate: List(Float),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ImagingSelection#resource
pub type ImagingselectionInstanceImageregion3d {
  ImagingselectionInstanceImageregion3d(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    region_type: String,
    coordinate: List(Float),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ImagingStudy#resource
pub type Imagingstudy {
  Imagingstudy(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    modality: List(Codeableconcept),
    subject: Reference,
    encounter: Option(Reference),
    started: Option(String),
    based_on: List(Reference),
    part_of: List(Reference),
    referrer: Option(Reference),
    endpoint: List(Reference),
    number_of_series: Option(Int),
    number_of_instances: Option(Int),
    procedure: List(Codeablereference),
    location: Option(Reference),
    reason: List(Codeablereference),
    note: List(Annotation),
    description: Option(String),
    series: List(ImagingstudySeries),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ImagingStudy#resource
pub type ImagingstudySeries {
  ImagingstudySeries(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    uid: String,
    number: Option(Int),
    modality: Codeableconcept,
    description: Option(String),
    number_of_instances: Option(Int),
    endpoint: List(Reference),
    body_site: Option(Codeablereference),
    laterality: Option(Codeableconcept),
    specimen: List(Reference),
    started: Option(String),
    performer: List(ImagingstudySeriesPerformer),
    instance: List(ImagingstudySeriesInstance),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ImagingStudy#resource
pub type ImagingstudySeriesPerformer {
  ImagingstudySeriesPerformer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    function: Option(Codeableconcept),
    actor: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ImagingStudy#resource
pub type ImagingstudySeriesInstance {
  ImagingstudySeriesInstance(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    uid: String,
    sop_class: Coding,
    number: Option(Int),
    title: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Immunization#resource
pub type Immunization {
  Immunization(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    based_on: List(Reference),
    status: String,
    status_reason: Option(Codeableconcept),
    vaccine_code: Codeableconcept,
    administered_product: Option(Codeablereference),
    manufacturer: Option(Codeablereference),
    lot_number: Option(String),
    expiration_date: Option(String),
    patient: Reference,
    encounter: Option(Reference),
    supporting_information: List(Reference),
    occurrence: ImmunizationOccurrence,
    primary_source: Option(Bool),
    information_source: Option(Codeablereference),
    location: Option(Reference),
    site: Option(Codeableconcept),
    route: Option(Codeableconcept),
    dose_quantity: Option(Quantity),
    performer: List(ImmunizationPerformer),
    note: List(Annotation),
    reason: List(Codeablereference),
    is_subpotent: Option(Bool),
    subpotent_reason: List(Codeableconcept),
    program_eligibility: List(ImmunizationProgrameligibility),
    funding_source: Option(Codeableconcept),
    reaction: List(ImmunizationReaction),
    protocol_applied: List(ImmunizationProtocolapplied),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Immunization#resource
pub type ImmunizationOccurrence {
  ImmunizationOccurrenceDatetime(occurrence: String)
  ImmunizationOccurrenceString(occurrence: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/Immunization#resource
pub type ImmunizationPerformer {
  ImmunizationPerformer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    function: Option(Codeableconcept),
    actor: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Immunization#resource
pub type ImmunizationProgrameligibility {
  ImmunizationProgrameligibility(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    program: Codeableconcept,
    program_status: Codeableconcept,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Immunization#resource
pub type ImmunizationReaction {
  ImmunizationReaction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    date: Option(String),
    manifestation: Option(Codeablereference),
    reported: Option(Bool),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Immunization#resource
pub type ImmunizationProtocolapplied {
  ImmunizationProtocolapplied(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    series: Option(String),
    authority: Option(Reference),
    target_disease: List(Codeableconcept),
    dose_number: String,
    series_doses: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ImmunizationEvaluation#resource
pub type Immunizationevaluation {
  Immunizationevaluation(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    patient: Reference,
    date: Option(String),
    authority: Option(Reference),
    target_disease: Codeableconcept,
    immunization_event: Reference,
    dose_status: Codeableconcept,
    dose_status_reason: List(Codeableconcept),
    description: Option(String),
    series: Option(String),
    dose_number: Option(String),
    series_doses: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ImmunizationRecommendation#resource
pub type Immunizationrecommendation {
  Immunizationrecommendation(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    patient: Reference,
    date: String,
    authority: Option(Reference),
    recommendation: List(ImmunizationrecommendationRecommendation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ImmunizationRecommendation#resource
pub type ImmunizationrecommendationRecommendation {
  ImmunizationrecommendationRecommendation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    vaccine_code: List(Codeableconcept),
    target_disease: List(Codeableconcept),
    contraindicated_vaccine_code: List(Codeableconcept),
    forecast_status: Codeableconcept,
    forecast_reason: List(Codeableconcept),
    date_criterion: List(ImmunizationrecommendationRecommendationDatecriterion),
    description: Option(String),
    series: Option(String),
    dose_number: Option(String),
    series_doses: Option(String),
    supporting_immunization: List(Reference),
    supporting_patient_information: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ImmunizationRecommendation#resource
pub type ImmunizationrecommendationRecommendationDatecriterion {
  ImmunizationrecommendationRecommendationDatecriterion(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
    value: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ImplementationGuide#resource
pub type Implementationguide {
  Implementationguide(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: String,
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(ImplementationguideVersionalgorithm),
    name: String,
    title: Option(String),
    status: String,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    package_id: String,
    license: Option(String),
    fhir_version: List(String),
    depends_on: List(ImplementationguideDependson),
    global: List(ImplementationguideGlobal),
    definition: Option(ImplementationguideDefinition),
    manifest: Option(ImplementationguideManifest),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideVersionalgorithm {
  ImplementationguideVersionalgorithmString(version_algorithm: String)
  ImplementationguideVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideDependson {
  ImplementationguideDependson(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    uri: String,
    package_id: Option(String),
    version: Option(String),
    reason: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideGlobal {
  ImplementationguideGlobal(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: String,
    profile: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideDefinition {
  ImplementationguideDefinition(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    grouping: List(ImplementationguideDefinitionGrouping),
    resource: List(ImplementationguideDefinitionResource),
    page: Option(ImplementationguideDefinitionPage),
    parameter: List(ImplementationguideDefinitionParameter),
    template: List(ImplementationguideDefinitionTemplate),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideDefinitionGrouping {
  ImplementationguideDefinitionGrouping(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    description: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideDefinitionResource {
  ImplementationguideDefinitionResource(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    reference: Reference,
    fhir_version: List(String),
    name: Option(String),
    description: Option(String),
    is_example: Option(Bool),
    profile: List(String),
    grouping_id: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideDefinitionPage {
  ImplementationguideDefinitionPage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    source: Option(ImplementationguideDefinitionPageSource),
    name: String,
    title: String,
    generation: String,
    page: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideDefinitionPageSource {
  ImplementationguideDefinitionPageSourceUrl(source: String)
  ImplementationguideDefinitionPageSourceString(source: String)
  ImplementationguideDefinitionPageSourceMarkdown(source: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideDefinitionParameter {
  ImplementationguideDefinitionParameter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Coding,
    value: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideDefinitionTemplate {
  ImplementationguideDefinitionTemplate(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    source: String,
    scope: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideManifest {
  ImplementationguideManifest(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    rendering: Option(String),
    resource: List(ImplementationguideManifestResource),
    page: List(ImplementationguideManifestPage),
    image: List(String),
    other: List(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideManifestResource {
  ImplementationguideManifestResource(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    reference: Reference,
    is_example: Option(Bool),
    profile: List(String),
    relative_path: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideManifestPage {
  ImplementationguideManifestPage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    title: Option(String),
    anchor: List(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Ingredient#resource
pub type Ingredient {
  Ingredient(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Option(Identifier),
    status: String,
    for: List(Reference),
    role: Codeableconcept,
    function: List(Codeableconcept),
    group: Option(Codeableconcept),
    allergenic_indicator: Option(Bool),
    comment: Option(String),
    manufacturer: List(IngredientManufacturer),
    substance: IngredientSubstance,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Ingredient#resource
pub type IngredientManufacturer {
  IngredientManufacturer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    role: Option(String),
    manufacturer: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Ingredient#resource
pub type IngredientSubstance {
  IngredientSubstance(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeablereference,
    strength: List(IngredientSubstanceStrength),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Ingredient#resource
pub type IngredientSubstanceStrength {
  IngredientSubstanceStrength(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    presentation: Option(IngredientSubstanceStrengthPresentation),
    text_presentation: Option(String),
    concentration: Option(IngredientSubstanceStrengthConcentration),
    text_concentration: Option(String),
    basis: Option(Codeableconcept),
    measurement_point: Option(String),
    country: List(Codeableconcept),
    reference_strength: List(IngredientSubstanceStrengthReferencestrength),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Ingredient#resource
pub type IngredientSubstanceStrengthPresentation {
  IngredientSubstanceStrengthPresentationRatio(presentation: Ratio)
  IngredientSubstanceStrengthPresentationRatiorange(presentation: Ratiorange)
  IngredientSubstanceStrengthPresentationCodeableconcept(
    presentation: Codeableconcept,
  )
  IngredientSubstanceStrengthPresentationQuantity(presentation: Quantity)
}

///http://hl7.org/fhir/r5/StructureDefinition/Ingredient#resource
pub type IngredientSubstanceStrengthConcentration {
  IngredientSubstanceStrengthConcentrationRatio(concentration: Ratio)
  IngredientSubstanceStrengthConcentrationRatiorange(concentration: Ratiorange)
  IngredientSubstanceStrengthConcentrationCodeableconcept(
    concentration: Codeableconcept,
  )
  IngredientSubstanceStrengthConcentrationQuantity(concentration: Quantity)
}

///http://hl7.org/fhir/r5/StructureDefinition/Ingredient#resource
pub type IngredientSubstanceStrengthReferencestrength {
  IngredientSubstanceStrengthReferencestrength(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    substance: Codeablereference,
    strength: IngredientSubstanceStrengthReferencestrengthStrength,
    measurement_point: Option(String),
    country: List(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Ingredient#resource
pub type IngredientSubstanceStrengthReferencestrengthStrength {
  IngredientSubstanceStrengthReferencestrengthStrengthRatio(strength: Ratio)
  IngredientSubstanceStrengthReferencestrengthStrengthRatiorange(
    strength: Ratiorange,
  )
  IngredientSubstanceStrengthReferencestrengthStrengthQuantity(
    strength: Quantity,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/InsurancePlan#resource
pub type Insuranceplan {
  Insuranceplan(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: Option(String),
    type_: List(Codeableconcept),
    name: Option(String),
    alias: List(String),
    period: Option(Period),
    owned_by: Option(Reference),
    administered_by: Option(Reference),
    coverage_area: List(Reference),
    contact: List(Extendedcontactdetail),
    endpoint: List(Reference),
    network: List(Reference),
    coverage: List(InsuranceplanCoverage),
    plan: List(InsuranceplanPlan),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/InsurancePlan#resource
pub type InsuranceplanCoverage {
  InsuranceplanCoverage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    network: List(Reference),
    benefit: List(InsuranceplanCoverageBenefit),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/InsurancePlan#resource
pub type InsuranceplanCoverageBenefit {
  InsuranceplanCoverageBenefit(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    requirement: Option(String),
    limit: List(InsuranceplanCoverageBenefitLimit),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/InsurancePlan#resource
pub type InsuranceplanCoverageBenefitLimit {
  InsuranceplanCoverageBenefitLimit(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    value: Option(Quantity),
    code: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/InsurancePlan#resource
pub type InsuranceplanPlan {
  InsuranceplanPlan(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    type_: Option(Codeableconcept),
    coverage_area: List(Reference),
    network: List(Reference),
    general_cost: List(InsuranceplanPlanGeneralcost),
    specific_cost: List(InsuranceplanPlanSpecificcost),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/InsurancePlan#resource
pub type InsuranceplanPlanGeneralcost {
  InsuranceplanPlanGeneralcost(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    group_size: Option(Int),
    cost: Option(Money),
    comment: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/InsurancePlan#resource
pub type InsuranceplanPlanSpecificcost {
  InsuranceplanPlanSpecificcost(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    category: Codeableconcept,
    benefit: List(InsuranceplanPlanSpecificcostBenefit),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/InsurancePlan#resource
pub type InsuranceplanPlanSpecificcostBenefit {
  InsuranceplanPlanSpecificcostBenefit(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    cost: List(InsuranceplanPlanSpecificcostBenefitCost),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/InsurancePlan#resource
pub type InsuranceplanPlanSpecificcostBenefitCost {
  InsuranceplanPlanSpecificcostBenefitCost(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    applicability: Option(Codeableconcept),
    qualifiers: List(Codeableconcept),
    value: Option(Quantity),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/InventoryItem#resource
pub type Inventoryitem {
  Inventoryitem(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    category: List(Codeableconcept),
    code: List(Codeableconcept),
    name: List(InventoryitemName),
    responsible_organization: List(InventoryitemResponsibleorganization),
    description: Option(InventoryitemDescription),
    inventory_status: List(Codeableconcept),
    base_unit: Option(Codeableconcept),
    net_content: Option(Quantity),
    association: List(InventoryitemAssociation),
    characteristic: List(InventoryitemCharacteristic),
    instance: Option(InventoryitemInstance),
    product_reference: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/InventoryItem#resource
pub type InventoryitemName {
  InventoryitemName(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name_type: Coding,
    language: String,
    name: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/InventoryItem#resource
pub type InventoryitemResponsibleorganization {
  InventoryitemResponsibleorganization(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    role: Codeableconcept,
    organization: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/InventoryItem#resource
pub type InventoryitemDescription {
  InventoryitemDescription(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    language: Option(String),
    description: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/InventoryItem#resource
pub type InventoryitemAssociation {
  InventoryitemAssociation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    association_type: Codeableconcept,
    related_item: Reference,
    quantity: Ratio,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/InventoryItem#resource
pub type InventoryitemCharacteristic {
  InventoryitemCharacteristic(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    characteristic_type: Codeableconcept,
    value: InventoryitemCharacteristicValue,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/InventoryItem#resource
pub type InventoryitemCharacteristicValue {
  InventoryitemCharacteristicValueString(value: String)
  InventoryitemCharacteristicValueInteger(value: Int)
  InventoryitemCharacteristicValueDecimal(value: Float)
  InventoryitemCharacteristicValueBoolean(value: Bool)
  InventoryitemCharacteristicValueUrl(value: String)
  InventoryitemCharacteristicValueDatetime(value: String)
  InventoryitemCharacteristicValueQuantity(value: Quantity)
  InventoryitemCharacteristicValueRange(value: Range)
  InventoryitemCharacteristicValueRatio(value: Ratio)
  InventoryitemCharacteristicValueAnnotation(value: Annotation)
  InventoryitemCharacteristicValueAddress(value: Address)
  InventoryitemCharacteristicValueDuration(value: Duration)
  InventoryitemCharacteristicValueCodeableconcept(value: Codeableconcept)
}

///http://hl7.org/fhir/r5/StructureDefinition/InventoryItem#resource
pub type InventoryitemInstance {
  InventoryitemInstance(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    lot_number: Option(String),
    expiry: Option(String),
    subject: Option(Reference),
    location: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/InventoryReport#resource
pub type Inventoryreport {
  Inventoryreport(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    count_type: String,
    operation_type: Option(Codeableconcept),
    operation_type_reason: Option(Codeableconcept),
    reported_date_time: String,
    reporter: Option(Reference),
    reporting_period: Option(Period),
    inventory_listing: List(InventoryreportInventorylisting),
    note: List(Annotation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/InventoryReport#resource
pub type InventoryreportInventorylisting {
  InventoryreportInventorylisting(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    location: Option(Reference),
    item_status: Option(Codeableconcept),
    counting_date_time: Option(String),
    item: List(InventoryreportInventorylistingItem),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/InventoryReport#resource
pub type InventoryreportInventorylistingItem {
  InventoryreportInventorylistingItem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    category: Option(Codeableconcept),
    quantity: Quantity,
    item: Codeablereference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Invoice#resource
pub type Invoice {
  Invoice(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    cancelled_reason: Option(String),
    type_: Option(Codeableconcept),
    subject: Option(Reference),
    recipient: Option(Reference),
    date: Option(String),
    creation: Option(String),
    period: Option(InvoicePeriod),
    participant: List(InvoiceParticipant),
    issuer: Option(Reference),
    account: Option(Reference),
    line_item: List(InvoiceLineitem),
    total_price_component: List(Monetarycomponent),
    total_net: Option(Money),
    total_gross: Option(Money),
    payment_terms: Option(String),
    note: List(Annotation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Invoice#resource
pub type InvoicePeriod {
  InvoicePeriodDate(period: String)
  InvoicePeriodPeriod(period: Period)
}

///http://hl7.org/fhir/r5/StructureDefinition/Invoice#resource
pub type InvoiceParticipant {
  InvoiceParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    role: Option(Codeableconcept),
    actor: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Invoice#resource
pub type InvoiceLineitem {
  InvoiceLineitem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Option(Int),
    serviced: Option(InvoiceLineitemServiced),
    charge_item: InvoiceLineitemChargeitem,
    price_component: List(Monetarycomponent),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Invoice#resource
pub type InvoiceLineitemServiced {
  InvoiceLineitemServicedDate(serviced: String)
  InvoiceLineitemServicedPeriod(serviced: Period)
}

///http://hl7.org/fhir/r5/StructureDefinition/Invoice#resource
pub type InvoiceLineitemChargeitem {
  InvoiceLineitemChargeitemReference(charge_item: Reference)
  InvoiceLineitemChargeitemCodeableconcept(charge_item: Codeableconcept)
}

///http://hl7.org/fhir/r5/StructureDefinition/Library#resource
pub type Library {
  Library(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(LibraryVersionalgorithm),
    name: Option(String),
    title: Option(String),
    subtitle: Option(String),
    status: String,
    experimental: Option(Bool),
    type_: Codeableconcept,
    subject: Option(LibrarySubject),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    usage: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    approval_date: Option(String),
    last_review_date: Option(String),
    effective_period: Option(Period),
    topic: List(Codeableconcept),
    author: List(Contactdetail),
    editor: List(Contactdetail),
    reviewer: List(Contactdetail),
    endorser: List(Contactdetail),
    related_artifact: List(Relatedartifact),
    parameter: List(Parameterdefinition),
    data_requirement: List(Datarequirement),
    content: List(Attachment),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Library#resource
pub type LibraryVersionalgorithm {
  LibraryVersionalgorithmString(version_algorithm: String)
  LibraryVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/Library#resource
pub type LibrarySubject {
  LibrarySubjectCodeableconcept(subject: Codeableconcept)
  LibrarySubjectReference(subject: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/Linkage#resource
pub type Linkage {
  Linkage(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    active: Option(Bool),
    author: Option(Reference),
    item: List(LinkageItem),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Linkage#resource
pub type LinkageItem {
  LinkageItem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: String,
    resource: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/List#resource
pub type FhirList {
  FhirList(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    mode: String,
    title: Option(String),
    code: Option(Codeableconcept),
    subject: List(Reference),
    encounter: Option(Reference),
    date: Option(String),
    source: Option(Reference),
    ordered_by: Option(Codeableconcept),
    note: List(Annotation),
    entry: List(ListEntry),
    empty_reason: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/List#resource
pub type ListEntry {
  ListEntry(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    flag: Option(Codeableconcept),
    deleted: Option(Bool),
    date: Option(String),
    item: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Location#resource
pub type Location {
  Location(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: Option(String),
    operational_status: Option(Coding),
    name: Option(String),
    alias: List(String),
    description: Option(String),
    mode: Option(String),
    type_: List(Codeableconcept),
    contact: List(Extendedcontactdetail),
    address: Option(Address),
    form: Option(Codeableconcept),
    position: Option(LocationPosition),
    managing_organization: Option(Reference),
    part_of: Option(Reference),
    characteristic: List(Codeableconcept),
    hours_of_operation: List(Availability),
    virtual_service: List(Virtualservicedetail),
    endpoint: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Location#resource
pub type LocationPosition {
  LocationPosition(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    longitude: Float,
    latitude: Float,
    altitude: Option(Float),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ManufacturedItemDefinition#resource
pub type Manufactureditemdefinition {
  Manufactureditemdefinition(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    name: Option(String),
    manufactured_dose_form: Codeableconcept,
    unit_of_presentation: Option(Codeableconcept),
    manufacturer: List(Reference),
    marketing_status: List(Marketingstatus),
    ingredient: List(Codeableconcept),
    property: List(ManufactureditemdefinitionProperty),
    component: List(ManufactureditemdefinitionComponent),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ManufacturedItemDefinition#resource
pub type ManufactureditemdefinitionProperty {
  ManufactureditemdefinitionProperty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value: Option(ManufactureditemdefinitionPropertyValue),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ManufacturedItemDefinition#resource
pub type ManufactureditemdefinitionPropertyValue {
  ManufactureditemdefinitionPropertyValueCodeableconcept(value: Codeableconcept)
  ManufactureditemdefinitionPropertyValueQuantity(value: Quantity)
  ManufactureditemdefinitionPropertyValueDate(value: String)
  ManufactureditemdefinitionPropertyValueBoolean(value: Bool)
  ManufactureditemdefinitionPropertyValueMarkdown(value: String)
  ManufactureditemdefinitionPropertyValueAttachment(value: Attachment)
  ManufactureditemdefinitionPropertyValueReference(value: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/ManufacturedItemDefinition#resource
pub type ManufactureditemdefinitionComponent {
  ManufactureditemdefinitionComponent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    function: List(Codeableconcept),
    amount: List(Quantity),
    constituent: List(ManufactureditemdefinitionComponentConstituent),
    property: List(Nil),
    component: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ManufacturedItemDefinition#resource
pub type ManufactureditemdefinitionComponentConstituent {
  ManufactureditemdefinitionComponentConstituent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    amount: List(Quantity),
    location: List(Codeableconcept),
    function: List(Codeableconcept),
    has_ingredient: List(Codeablereference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Measure#resource
pub type Measure {
  Measure(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(MeasureVersionalgorithm),
    name: Option(String),
    title: Option(String),
    subtitle: Option(String),
    status: String,
    experimental: Option(Bool),
    subject: Option(MeasureSubject),
    basis: Option(String),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    usage: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    approval_date: Option(String),
    last_review_date: Option(String),
    effective_period: Option(Period),
    topic: List(Codeableconcept),
    author: List(Contactdetail),
    editor: List(Contactdetail),
    reviewer: List(Contactdetail),
    endorser: List(Contactdetail),
    related_artifact: List(Relatedartifact),
    library: List(String),
    disclaimer: Option(String),
    scoring: Option(Codeableconcept),
    scoring_unit: Option(Codeableconcept),
    composite_scoring: Option(Codeableconcept),
    type_: List(Codeableconcept),
    risk_adjustment: Option(String),
    rate_aggregation: Option(String),
    rationale: Option(String),
    clinical_recommendation_statement: Option(String),
    improvement_notation: Option(Codeableconcept),
    term: List(MeasureTerm),
    guidance: Option(String),
    group: List(MeasureGroup),
    supplemental_data: List(MeasureSupplementaldata),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Measure#resource
pub type MeasureVersionalgorithm {
  MeasureVersionalgorithmString(version_algorithm: String)
  MeasureVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/Measure#resource
pub type MeasureSubject {
  MeasureSubjectCodeableconcept(subject: Codeableconcept)
  MeasureSubjectReference(subject: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/Measure#resource
pub type MeasureTerm {
  MeasureTerm(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(Codeableconcept),
    definition: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Measure#resource
pub type MeasureGroup {
  MeasureGroup(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    link_id: Option(String),
    code: Option(Codeableconcept),
    description: Option(String),
    type_: List(Codeableconcept),
    subject: Option(MeasureGroupSubject),
    basis: Option(String),
    scoring: Option(Codeableconcept),
    scoring_unit: Option(Codeableconcept),
    rate_aggregation: Option(String),
    improvement_notation: Option(Codeableconcept),
    library: List(String),
    population: List(MeasureGroupPopulation),
    stratifier: List(MeasureGroupStratifier),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Measure#resource
pub type MeasureGroupSubject {
  MeasureGroupSubjectCodeableconcept(subject: Codeableconcept)
  MeasureGroupSubjectReference(subject: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/Measure#resource
pub type MeasureGroupPopulation {
  MeasureGroupPopulation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    link_id: Option(String),
    code: Option(Codeableconcept),
    description: Option(String),
    criteria: Option(Expression),
    group_definition: Option(Reference),
    input_population_id: Option(String),
    aggregate_method: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Measure#resource
pub type MeasureGroupStratifier {
  MeasureGroupStratifier(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    link_id: Option(String),
    code: Option(Codeableconcept),
    description: Option(String),
    criteria: Option(Expression),
    group_definition: Option(Reference),
    component: List(MeasureGroupStratifierComponent),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Measure#resource
pub type MeasureGroupStratifierComponent {
  MeasureGroupStratifierComponent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    link_id: Option(String),
    code: Option(Codeableconcept),
    description: Option(String),
    criteria: Option(Expression),
    group_definition: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Measure#resource
pub type MeasureSupplementaldata {
  MeasureSupplementaldata(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    link_id: Option(String),
    code: Option(Codeableconcept),
    usage: List(Codeableconcept),
    description: Option(String),
    criteria: Expression,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MeasureReport#resource
pub type Measurereport {
  Measurereport(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    type_: String,
    data_update_type: Option(String),
    measure: Option(String),
    subject: Option(Reference),
    date: Option(String),
    reporter: Option(Reference),
    reporting_vendor: Option(Reference),
    location: Option(Reference),
    period: Period,
    input_parameters: Option(Reference),
    scoring: Option(Codeableconcept),
    improvement_notation: Option(Codeableconcept),
    group: List(MeasurereportGroup),
    supplemental_data: List(Reference),
    evaluated_resource: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MeasureReport#resource
pub type MeasurereportGroup {
  MeasurereportGroup(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    link_id: Option(String),
    code: Option(Codeableconcept),
    subject: Option(Reference),
    population: List(MeasurereportGroupPopulation),
    measure_score: Option(MeasurereportGroupMeasurescore),
    stratifier: List(MeasurereportGroupStratifier),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MeasureReport#resource
pub type MeasurereportGroupMeasurescore {
  MeasurereportGroupMeasurescoreQuantity(measure_score: Quantity)
  MeasurereportGroupMeasurescoreDatetime(measure_score: String)
  MeasurereportGroupMeasurescoreCodeableconcept(measure_score: Codeableconcept)
  MeasurereportGroupMeasurescorePeriod(measure_score: Period)
  MeasurereportGroupMeasurescoreRange(measure_score: Range)
  MeasurereportGroupMeasurescoreDuration(measure_score: Duration)
}

///http://hl7.org/fhir/r5/StructureDefinition/MeasureReport#resource
pub type MeasurereportGroupPopulation {
  MeasurereportGroupPopulation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    link_id: Option(String),
    code: Option(Codeableconcept),
    count: Option(Int),
    subject_results: Option(Reference),
    subject_report: List(Reference),
    subjects: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MeasureReport#resource
pub type MeasurereportGroupStratifier {
  MeasurereportGroupStratifier(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    link_id: Option(String),
    code: Option(Codeableconcept),
    stratum: List(MeasurereportGroupStratifierStratum),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MeasureReport#resource
pub type MeasurereportGroupStratifierStratum {
  MeasurereportGroupStratifierStratum(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    value: Option(MeasurereportGroupStratifierStratumValue),
    component: List(MeasurereportGroupStratifierStratumComponent),
    population: List(MeasurereportGroupStratifierStratumPopulation),
    measure_score: Option(MeasurereportGroupStratifierStratumMeasurescore),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MeasureReport#resource
pub type MeasurereportGroupStratifierStratumValue {
  MeasurereportGroupStratifierStratumValueCodeableconcept(
    value: Codeableconcept,
  )
  MeasurereportGroupStratifierStratumValueBoolean(value: Bool)
  MeasurereportGroupStratifierStratumValueQuantity(value: Quantity)
  MeasurereportGroupStratifierStratumValueRange(value: Range)
  MeasurereportGroupStratifierStratumValueReference(value: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/MeasureReport#resource
pub type MeasurereportGroupStratifierStratumMeasurescore {
  MeasurereportGroupStratifierStratumMeasurescoreQuantity(
    measure_score: Quantity,
  )
  MeasurereportGroupStratifierStratumMeasurescoreDatetime(measure_score: String)
  MeasurereportGroupStratifierStratumMeasurescoreCodeableconcept(
    measure_score: Codeableconcept,
  )
  MeasurereportGroupStratifierStratumMeasurescorePeriod(measure_score: Period)
  MeasurereportGroupStratifierStratumMeasurescoreRange(measure_score: Range)
  MeasurereportGroupStratifierStratumMeasurescoreDuration(
    measure_score: Duration,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MeasureReport#resource
pub type MeasurereportGroupStratifierStratumComponent {
  MeasurereportGroupStratifierStratumComponent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    link_id: Option(String),
    code: Codeableconcept,
    value: MeasurereportGroupStratifierStratumComponentValue,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MeasureReport#resource
pub type MeasurereportGroupStratifierStratumComponentValue {
  MeasurereportGroupStratifierStratumComponentValueCodeableconcept(
    value: Codeableconcept,
  )
  MeasurereportGroupStratifierStratumComponentValueBoolean(value: Bool)
  MeasurereportGroupStratifierStratumComponentValueQuantity(value: Quantity)
  MeasurereportGroupStratifierStratumComponentValueRange(value: Range)
  MeasurereportGroupStratifierStratumComponentValueReference(value: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/MeasureReport#resource
pub type MeasurereportGroupStratifierStratumPopulation {
  MeasurereportGroupStratifierStratumPopulation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    link_id: Option(String),
    code: Option(Codeableconcept),
    count: Option(Int),
    subject_results: Option(Reference),
    subject_report: List(Reference),
    subjects: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Medication#resource
pub type Medication {
  Medication(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    code: Option(Codeableconcept),
    status: Option(String),
    marketing_authorization_holder: Option(Reference),
    dose_form: Option(Codeableconcept),
    total_volume: Option(Quantity),
    ingredient: List(MedicationIngredient),
    batch: Option(MedicationBatch),
    definition: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Medication#resource
pub type MedicationIngredient {
  MedicationIngredient(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item: Codeablereference,
    is_active: Option(Bool),
    strength: Option(MedicationIngredientStrength),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Medication#resource
pub type MedicationIngredientStrength {
  MedicationIngredientStrengthRatio(strength: Ratio)
  MedicationIngredientStrengthCodeableconcept(strength: Codeableconcept)
  MedicationIngredientStrengthQuantity(strength: Quantity)
}

///http://hl7.org/fhir/r5/StructureDefinition/Medication#resource
pub type MedicationBatch {
  MedicationBatch(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    lot_number: Option(String),
    expiration_date: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationAdministration#resource
pub type Medicationadministration {
  Medicationadministration(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    based_on: List(Reference),
    part_of: List(Reference),
    status: String,
    status_reason: List(Codeableconcept),
    category: List(Codeableconcept),
    medication: Codeablereference,
    subject: Reference,
    encounter: Option(Reference),
    supporting_information: List(Reference),
    occurence: MedicationadministrationOccurence,
    recorded: Option(String),
    is_sub_potent: Option(Bool),
    sub_potent_reason: List(Codeableconcept),
    performer: List(MedicationadministrationPerformer),
    reason: List(Codeablereference),
    request: Option(Reference),
    device: List(Codeablereference),
    note: List(Annotation),
    dosage: Option(MedicationadministrationDosage),
    event_history: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationAdministration#resource
pub type MedicationadministrationOccurence {
  MedicationadministrationOccurenceDatetime(occurence: String)
  MedicationadministrationOccurencePeriod(occurence: Period)
  MedicationadministrationOccurenceTiming(occurence: Timing)
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationAdministration#resource
pub type MedicationadministrationPerformer {
  MedicationadministrationPerformer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    function: Option(Codeableconcept),
    actor: Codeablereference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationAdministration#resource
pub type MedicationadministrationDosage {
  MedicationadministrationDosage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    text: Option(String),
    site: Option(Codeableconcept),
    route: Option(Codeableconcept),
    method: Option(Codeableconcept),
    dose: Option(Quantity),
    rate: Option(MedicationadministrationDosageRate),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationAdministration#resource
pub type MedicationadministrationDosageRate {
  MedicationadministrationDosageRateRatio(rate: Ratio)
  MedicationadministrationDosageRateQuantity(rate: Quantity)
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationDispense#resource
pub type Medicationdispense {
  Medicationdispense(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    based_on: List(Reference),
    part_of: List(Reference),
    status: String,
    not_performed_reason: Option(Codeablereference),
    status_changed: Option(String),
    category: List(Codeableconcept),
    medication: Codeablereference,
    subject: Reference,
    encounter: Option(Reference),
    supporting_information: List(Reference),
    performer: List(MedicationdispensePerformer),
    location: Option(Reference),
    authorizing_prescription: List(Reference),
    type_: Option(Codeableconcept),
    quantity: Option(Quantity),
    days_supply: Option(Quantity),
    recorded: Option(String),
    when_prepared: Option(String),
    when_handed_over: Option(String),
    destination: Option(Reference),
    receiver: List(Reference),
    note: List(Annotation),
    rendered_dosage_instruction: Option(String),
    dosage_instruction: List(Dosage),
    substitution: Option(MedicationdispenseSubstitution),
    event_history: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationDispense#resource
pub type MedicationdispensePerformer {
  MedicationdispensePerformer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    function: Option(Codeableconcept),
    actor: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationDispense#resource
pub type MedicationdispenseSubstitution {
  MedicationdispenseSubstitution(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    was_substituted: Bool,
    type_: Option(Codeableconcept),
    reason: List(Codeableconcept),
    responsible_party: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationKnowledge#resource
pub type Medicationknowledge {
  Medicationknowledge(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    code: Option(Codeableconcept),
    status: Option(String),
    author: Option(Reference),
    intended_jurisdiction: List(Codeableconcept),
    name: List(String),
    related_medication_knowledge: List(
      MedicationknowledgeRelatedmedicationknowledge,
    ),
    associated_medication: List(Reference),
    product_type: List(Codeableconcept),
    monograph: List(MedicationknowledgeMonograph),
    preparation_instruction: Option(String),
    cost: List(MedicationknowledgeCost),
    monitoring_program: List(MedicationknowledgeMonitoringprogram),
    indication_guideline: List(MedicationknowledgeIndicationguideline),
    medicine_classification: List(MedicationknowledgeMedicineclassification),
    packaging: List(MedicationknowledgePackaging),
    clinical_use_issue: List(Reference),
    storage_guideline: List(MedicationknowledgeStorageguideline),
    regulatory: List(MedicationknowledgeRegulatory),
    definitional: Option(MedicationknowledgeDefinitional),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeRelatedmedicationknowledge {
  MedicationknowledgeRelatedmedicationknowledge(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    reference: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeMonograph {
  MedicationknowledgeMonograph(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    source: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeCost {
  MedicationknowledgeCost(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    effective_date: List(Period),
    type_: Codeableconcept,
    source: Option(String),
    cost: MedicationknowledgeCostCost,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeCostCost {
  MedicationknowledgeCostCostMoney(cost: Money)
  MedicationknowledgeCostCostCodeableconcept(cost: Codeableconcept)
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeMonitoringprogram {
  MedicationknowledgeMonitoringprogram(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    name: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeIndicationguideline {
  MedicationknowledgeIndicationguideline(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    indication: List(Codeablereference),
    dosing_guideline: List(
      MedicationknowledgeIndicationguidelineDosingguideline,
    ),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeIndicationguidelineDosingguideline {
  MedicationknowledgeIndicationguidelineDosingguideline(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    treatment_intent: Option(Codeableconcept),
    dosage: List(MedicationknowledgeIndicationguidelineDosingguidelineDosage),
    administration_treatment: Option(Codeableconcept),
    patient_characteristic: List(
      MedicationknowledgeIndicationguidelineDosingguidelinePatientcharacteristic,
    ),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeIndicationguidelineDosingguidelineDosage {
  MedicationknowledgeIndicationguidelineDosingguidelineDosage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    dosage: List(Dosage),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeIndicationguidelineDosingguidelinePatientcharacteristic {
  MedicationknowledgeIndicationguidelineDosingguidelinePatientcharacteristic(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value: Option(
      MedicationknowledgeIndicationguidelineDosingguidelinePatientcharacteristicValue,
    ),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeIndicationguidelineDosingguidelinePatientcharacteristicValue {
  MedicationknowledgeIndicationguidelineDosingguidelinePatientcharacteristicValueCodeableconcept(
    value: Codeableconcept,
  )
  MedicationknowledgeIndicationguidelineDosingguidelinePatientcharacteristicValueQuantity(
    value: Quantity,
  )
  MedicationknowledgeIndicationguidelineDosingguidelinePatientcharacteristicValueRange(
    value: Range,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeMedicineclassification {
  MedicationknowledgeMedicineclassification(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    source: Option(MedicationknowledgeMedicineclassificationSource),
    classification: List(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeMedicineclassificationSource {
  MedicationknowledgeMedicineclassificationSourceString(source: String)
  MedicationknowledgeMedicineclassificationSourceUri(source: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgePackaging {
  MedicationknowledgePackaging(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    cost: List(Nil),
    packaged_product: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeStorageguideline {
  MedicationknowledgeStorageguideline(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    reference: Option(String),
    note: List(Annotation),
    stability_duration: Option(Duration),
    environmental_setting: List(
      MedicationknowledgeStorageguidelineEnvironmentalsetting,
    ),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeStorageguidelineEnvironmentalsetting {
  MedicationknowledgeStorageguidelineEnvironmentalsetting(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value: MedicationknowledgeStorageguidelineEnvironmentalsettingValue,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeStorageguidelineEnvironmentalsettingValue {
  MedicationknowledgeStorageguidelineEnvironmentalsettingValueQuantity(
    value: Quantity,
  )
  MedicationknowledgeStorageguidelineEnvironmentalsettingValueRange(
    value: Range,
  )
  MedicationknowledgeStorageguidelineEnvironmentalsettingValueCodeableconcept(
    value: Codeableconcept,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeRegulatory {
  MedicationknowledgeRegulatory(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    regulatory_authority: Reference,
    substitution: List(MedicationknowledgeRegulatorySubstitution),
    schedule: List(Codeableconcept),
    max_dispense: Option(MedicationknowledgeRegulatoryMaxdispense),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeRegulatorySubstitution {
  MedicationknowledgeRegulatorySubstitution(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    allowed: Bool,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeRegulatoryMaxdispense {
  MedicationknowledgeRegulatoryMaxdispense(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    quantity: Quantity,
    period: Option(Duration),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeDefinitional {
  MedicationknowledgeDefinitional(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    definition: List(Reference),
    dose_form: Option(Codeableconcept),
    intended_route: List(Codeableconcept),
    ingredient: List(MedicationknowledgeDefinitionalIngredient),
    drug_characteristic: List(MedicationknowledgeDefinitionalDrugcharacteristic),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeDefinitionalIngredient {
  MedicationknowledgeDefinitionalIngredient(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item: Codeablereference,
    type_: Option(Codeableconcept),
    strength: Option(MedicationknowledgeDefinitionalIngredientStrength),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeDefinitionalIngredientStrength {
  MedicationknowledgeDefinitionalIngredientStrengthRatio(strength: Ratio)
  MedicationknowledgeDefinitionalIngredientStrengthCodeableconcept(
    strength: Codeableconcept,
  )
  MedicationknowledgeDefinitionalIngredientStrengthQuantity(strength: Quantity)
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeDefinitionalDrugcharacteristic {
  MedicationknowledgeDefinitionalDrugcharacteristic(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    value: Option(MedicationknowledgeDefinitionalDrugcharacteristicValue),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeDefinitionalDrugcharacteristicValue {
  MedicationknowledgeDefinitionalDrugcharacteristicValueCodeableconcept(
    value: Codeableconcept,
  )
  MedicationknowledgeDefinitionalDrugcharacteristicValueString(value: String)
  MedicationknowledgeDefinitionalDrugcharacteristicValueQuantity(
    value: Quantity,
  )
  MedicationknowledgeDefinitionalDrugcharacteristicValueBase64binary(
    value: String,
  )
  MedicationknowledgeDefinitionalDrugcharacteristicValueAttachment(
    value: Attachment,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationRequest#resource
pub type Medicationrequest {
  Medicationrequest(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    based_on: List(Reference),
    prior_prescription: Option(Reference),
    group_identifier: Option(Identifier),
    status: String,
    status_reason: Option(Codeableconcept),
    status_changed: Option(String),
    intent: String,
    category: List(Codeableconcept),
    priority: Option(String),
    do_not_perform: Option(Bool),
    medication: Codeablereference,
    subject: Reference,
    information_source: List(Reference),
    encounter: Option(Reference),
    supporting_information: List(Reference),
    authored_on: Option(String),
    requester: Option(Reference),
    reported: Option(Bool),
    performer_type: Option(Codeableconcept),
    performer: List(Reference),
    device: List(Codeablereference),
    recorder: Option(Reference),
    reason: List(Codeablereference),
    course_of_therapy_type: Option(Codeableconcept),
    insurance: List(Reference),
    note: List(Annotation),
    rendered_dosage_instruction: Option(String),
    effective_dose_period: Option(Period),
    dosage_instruction: List(Dosage),
    dispense_request: Option(MedicationrequestDispenserequest),
    substitution: Option(MedicationrequestSubstitution),
    event_history: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationRequest#resource
pub type MedicationrequestDispenserequest {
  MedicationrequestDispenserequest(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    initial_fill: Option(MedicationrequestDispenserequestInitialfill),
    dispense_interval: Option(Duration),
    validity_period: Option(Period),
    number_of_repeats_allowed: Option(Int),
    quantity: Option(Quantity),
    expected_supply_duration: Option(Duration),
    dispenser: Option(Reference),
    dispenser_instruction: List(Annotation),
    dose_administration_aid: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationRequest#resource
pub type MedicationrequestDispenserequestInitialfill {
  MedicationrequestDispenserequestInitialfill(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    quantity: Option(Quantity),
    duration: Option(Duration),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationRequest#resource
pub type MedicationrequestSubstitution {
  MedicationrequestSubstitution(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    allowed: MedicationrequestSubstitutionAllowed,
    reason: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationRequest#resource
pub type MedicationrequestSubstitutionAllowed {
  MedicationrequestSubstitutionAllowedBoolean(allowed: Bool)
  MedicationrequestSubstitutionAllowedCodeableconcept(allowed: Codeableconcept)
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationStatement#resource
pub type Medicationstatement {
  Medicationstatement(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    part_of: List(Reference),
    status: String,
    category: List(Codeableconcept),
    medication: Codeablereference,
    subject: Reference,
    encounter: Option(Reference),
    effective: Option(MedicationstatementEffective),
    date_asserted: Option(String),
    information_source: List(Reference),
    derived_from: List(Reference),
    reason: List(Codeablereference),
    note: List(Annotation),
    related_clinical_information: List(Reference),
    rendered_dosage_instruction: Option(String),
    dosage: List(Dosage),
    adherence: Option(MedicationstatementAdherence),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationStatement#resource
pub type MedicationstatementEffective {
  MedicationstatementEffectiveDatetime(effective: String)
  MedicationstatementEffectivePeriod(effective: Period)
  MedicationstatementEffectiveTiming(effective: Timing)
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicationStatement#resource
pub type MedicationstatementAdherence {
  MedicationstatementAdherence(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
    reason: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicinalProductDefinition#resource
pub type Medicinalproductdefinition {
  Medicinalproductdefinition(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    type_: Option(Codeableconcept),
    domain: Option(Codeableconcept),
    version: Option(String),
    status: Option(Codeableconcept),
    status_date: Option(String),
    description: Option(String),
    combined_pharmaceutical_dose_form: Option(Codeableconcept),
    route: List(Codeableconcept),
    indication: Option(String),
    legal_status_of_supply: Option(Codeableconcept),
    additional_monitoring_indicator: Option(Codeableconcept),
    special_measures: List(Codeableconcept),
    pediatric_use_indicator: Option(Codeableconcept),
    classification: List(Codeableconcept),
    marketing_status: List(Marketingstatus),
    packaged_medicinal_product: List(Codeableconcept),
    comprised_of: List(Reference),
    ingredient: List(Codeableconcept),
    impurity: List(Codeablereference),
    attached_document: List(Reference),
    master_file: List(Reference),
    contact: List(MedicinalproductdefinitionContact),
    clinical_trial: List(Reference),
    code: List(Coding),
    name: List(MedicinalproductdefinitionName),
    cross_reference: List(MedicinalproductdefinitionCrossreference),
    operation: List(MedicinalproductdefinitionOperation),
    characteristic: List(MedicinalproductdefinitionCharacteristic),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicinalProductDefinition#resource
pub type MedicinalproductdefinitionContact {
  MedicinalproductdefinitionContact(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    contact: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicinalProductDefinition#resource
pub type MedicinalproductdefinitionName {
  MedicinalproductdefinitionName(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    product_name: String,
    type_: Option(Codeableconcept),
    part: List(MedicinalproductdefinitionNamePart),
    usage: List(MedicinalproductdefinitionNameUsage),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicinalProductDefinition#resource
pub type MedicinalproductdefinitionNamePart {
  MedicinalproductdefinitionNamePart(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    part: String,
    type_: Codeableconcept,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicinalProductDefinition#resource
pub type MedicinalproductdefinitionNameUsage {
  MedicinalproductdefinitionNameUsage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    country: Codeableconcept,
    jurisdiction: Option(Codeableconcept),
    language: Codeableconcept,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicinalProductDefinition#resource
pub type MedicinalproductdefinitionCrossreference {
  MedicinalproductdefinitionCrossreference(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    product: Codeablereference,
    type_: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicinalProductDefinition#resource
pub type MedicinalproductdefinitionOperation {
  MedicinalproductdefinitionOperation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeablereference),
    effective_date: Option(Period),
    organization: List(Reference),
    confidentiality_indicator: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicinalProductDefinition#resource
pub type MedicinalproductdefinitionCharacteristic {
  MedicinalproductdefinitionCharacteristic(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value: Option(MedicinalproductdefinitionCharacteristicValue),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MedicinalProductDefinition#resource
pub type MedicinalproductdefinitionCharacteristicValue {
  MedicinalproductdefinitionCharacteristicValueCodeableconcept(
    value: Codeableconcept,
  )
  MedicinalproductdefinitionCharacteristicValueMarkdown(value: String)
  MedicinalproductdefinitionCharacteristicValueQuantity(value: Quantity)
  MedicinalproductdefinitionCharacteristicValueInteger(value: Int)
  MedicinalproductdefinitionCharacteristicValueDate(value: String)
  MedicinalproductdefinitionCharacteristicValueBoolean(value: Bool)
  MedicinalproductdefinitionCharacteristicValueAttachment(value: Attachment)
}

///http://hl7.org/fhir/r5/StructureDefinition/MessageDefinition#resource
pub type Messagedefinition {
  Messagedefinition(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(MessagedefinitionVersionalgorithm),
    name: Option(String),
    title: Option(String),
    replaces: List(String),
    status: String,
    experimental: Option(Bool),
    date: String,
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    base: Option(String),
    parent: List(String),
    event: MessagedefinitionEvent,
    category: Option(String),
    focus: List(MessagedefinitionFocus),
    response_required: Option(String),
    allowed_response: List(MessagedefinitionAllowedresponse),
    graph: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MessageDefinition#resource
pub type MessagedefinitionVersionalgorithm {
  MessagedefinitionVersionalgorithmString(version_algorithm: String)
  MessagedefinitionVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/MessageDefinition#resource
pub type MessagedefinitionEvent {
  MessagedefinitionEventCoding(event: Coding)
  MessagedefinitionEventUri(event: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/MessageDefinition#resource
pub type MessagedefinitionFocus {
  MessagedefinitionFocus(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    profile: Option(String),
    min: Int,
    max: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MessageDefinition#resource
pub type MessagedefinitionAllowedresponse {
  MessagedefinitionAllowedresponse(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    message: String,
    situation: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MessageHeader#resource
pub type Messageheader {
  Messageheader(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    event: MessageheaderEvent,
    destination: List(MessageheaderDestination),
    sender: Option(Reference),
    author: Option(Reference),
    source: MessageheaderSource,
    responsible: Option(Reference),
    reason: Option(Codeableconcept),
    response: Option(MessageheaderResponse),
    focus: List(Reference),
    definition: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MessageHeader#resource
pub type MessageheaderEvent {
  MessageheaderEventCoding(event: Coding)
  MessageheaderEventCanonical(event: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/MessageHeader#resource
pub type MessageheaderDestination {
  MessageheaderDestination(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    endpoint: Option(MessageheaderDestinationEndpoint),
    name: Option(String),
    target: Option(Reference),
    receiver: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MessageHeader#resource
pub type MessageheaderDestinationEndpoint {
  MessageheaderDestinationEndpointUrl(endpoint: String)
  MessageheaderDestinationEndpointReference(endpoint: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/MessageHeader#resource
pub type MessageheaderSource {
  MessageheaderSource(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    endpoint: Option(MessageheaderSourceEndpoint),
    name: Option(String),
    software: Option(String),
    version: Option(String),
    contact: Option(Contactpoint),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MessageHeader#resource
pub type MessageheaderSourceEndpoint {
  MessageheaderSourceEndpointUrl(endpoint: String)
  MessageheaderSourceEndpointReference(endpoint: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/MessageHeader#resource
pub type MessageheaderResponse {
  MessageheaderResponse(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Identifier,
    code: String,
    details: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MetadataResource#resource
pub type Metadataresource {
  Metadataresource(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(MetadataresourceVersionalgorithm),
    name: Option(String),
    title: Option(String),
    status: String,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    approval_date: Option(String),
    last_review_date: Option(String),
    effective_period: Option(Period),
    topic: List(Codeableconcept),
    author: List(Contactdetail),
    editor: List(Contactdetail),
    reviewer: List(Contactdetail),
    endorser: List(Contactdetail),
    related_artifact: List(Relatedartifact),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MetadataResource#resource
pub type MetadataresourceVersionalgorithm {
  MetadataresourceVersionalgorithmString(version_algorithm: String)
  MetadataresourceVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/MolecularSequence#resource
pub type Molecularsequence {
  Molecularsequence(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    type_: Option(String),
    subject: Option(Reference),
    focus: List(Reference),
    specimen: Option(Reference),
    device: Option(Reference),
    performer: Option(Reference),
    literal: Option(String),
    formatted: List(Attachment),
    relative: List(MolecularsequenceRelative),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MolecularSequence#resource
pub type MolecularsequenceRelative {
  MolecularsequenceRelative(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    coordinate_system: Codeableconcept,
    ordinal_position: Option(Int),
    sequence_range: Option(Range),
    starting_sequence: Option(MolecularsequenceRelativeStartingsequence),
    edit: List(MolecularsequenceRelativeEdit),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MolecularSequence#resource
pub type MolecularsequenceRelativeStartingsequence {
  MolecularsequenceRelativeStartingsequence(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    genome_assembly: Option(Codeableconcept),
    chromosome: Option(Codeableconcept),
    sequence: Option(MolecularsequenceRelativeStartingsequenceSequence),
    window_start: Option(Int),
    window_end: Option(Int),
    orientation: Option(String),
    strand: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MolecularSequence#resource
pub type MolecularsequenceRelativeStartingsequenceSequence {
  MolecularsequenceRelativeStartingsequenceSequenceCodeableconcept(
    sequence: Codeableconcept,
  )
  MolecularsequenceRelativeStartingsequenceSequenceString(sequence: String)
  MolecularsequenceRelativeStartingsequenceSequenceReference(
    sequence: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MolecularSequence#resource
pub type MolecularsequenceRelativeEdit {
  MolecularsequenceRelativeEdit(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    start: Option(Int),
    end: Option(Int),
    replacement_sequence: Option(String),
    replaced_sequence: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/NamingSystem#resource
pub type Namingsystem {
  Namingsystem(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(NamingsystemVersionalgorithm),
    name: String,
    title: Option(String),
    status: String,
    kind: String,
    experimental: Option(Bool),
    date: String,
    publisher: Option(String),
    contact: List(Contactdetail),
    responsible: Option(String),
    type_: Option(Codeableconcept),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    approval_date: Option(String),
    last_review_date: Option(String),
    effective_period: Option(Period),
    topic: List(Codeableconcept),
    author: List(Contactdetail),
    editor: List(Contactdetail),
    reviewer: List(Contactdetail),
    endorser: List(Contactdetail),
    related_artifact: List(Relatedartifact),
    usage: Option(String),
    unique_id: List(NamingsystemUniqueid),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/NamingSystem#resource
pub type NamingsystemVersionalgorithm {
  NamingsystemVersionalgorithmString(version_algorithm: String)
  NamingsystemVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/NamingSystem#resource
pub type NamingsystemUniqueid {
  NamingsystemUniqueid(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: String,
    value: String,
    preferred: Option(Bool),
    comment: Option(String),
    period: Option(Period),
    authoritative: Option(Bool),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/NutritionIntake#resource
pub type Nutritionintake {
  Nutritionintake(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    instantiates_canonical: List(String),
    instantiates_uri: List(String),
    based_on: List(Reference),
    part_of: List(Reference),
    status: String,
    status_reason: List(Codeableconcept),
    code: Option(Codeableconcept),
    subject: Reference,
    encounter: Option(Reference),
    occurrence: Option(NutritionintakeOccurrence),
    recorded: Option(String),
    reported: Option(NutritionintakeReported),
    consumed_item: List(NutritionintakeConsumeditem),
    ingredient_label: List(NutritionintakeIngredientlabel),
    performer: List(NutritionintakePerformer),
    location: Option(Reference),
    derived_from: List(Reference),
    reason: List(Codeablereference),
    note: List(Annotation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/NutritionIntake#resource
pub type NutritionintakeOccurrence {
  NutritionintakeOccurrenceDatetime(occurrence: String)
  NutritionintakeOccurrencePeriod(occurrence: Period)
}

///http://hl7.org/fhir/r5/StructureDefinition/NutritionIntake#resource
pub type NutritionintakeReported {
  NutritionintakeReportedBoolean(reported: Bool)
  NutritionintakeReportedReference(reported: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/NutritionIntake#resource
pub type NutritionintakeConsumeditem {
  NutritionintakeConsumeditem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    nutrition_product: Codeablereference,
    schedule: Option(Timing),
    amount: Option(Quantity),
    rate: Option(Quantity),
    not_consumed: Option(Bool),
    not_consumed_reason: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/NutritionIntake#resource
pub type NutritionintakeIngredientlabel {
  NutritionintakeIngredientlabel(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    nutrient: Codeablereference,
    amount: Quantity,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/NutritionIntake#resource
pub type NutritionintakePerformer {
  NutritionintakePerformer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    function: Option(Codeableconcept),
    actor: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/NutritionOrder#resource
pub type Nutritionorder {
  Nutritionorder(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    instantiates_canonical: List(String),
    instantiates_uri: List(String),
    instantiates: List(String),
    based_on: List(Reference),
    group_identifier: Option(Identifier),
    status: String,
    intent: String,
    priority: Option(String),
    subject: Reference,
    encounter: Option(Reference),
    supporting_information: List(Reference),
    date_time: String,
    orderer: Option(Reference),
    performer: List(Codeablereference),
    allergy_intolerance: List(Reference),
    food_preference_modifier: List(Codeableconcept),
    exclude_food_modifier: List(Codeableconcept),
    outside_food_allowed: Option(Bool),
    oral_diet: Option(NutritionorderOraldiet),
    supplement: List(NutritionorderSupplement),
    enteral_formula: Option(NutritionorderEnteralformula),
    note: List(Annotation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/NutritionOrder#resource
pub type NutritionorderOraldiet {
  NutritionorderOraldiet(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: List(Codeableconcept),
    schedule: Option(NutritionorderOraldietSchedule),
    nutrient: List(NutritionorderOraldietNutrient),
    texture: List(NutritionorderOraldietTexture),
    fluid_consistency_type: List(Codeableconcept),
    instruction: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/NutritionOrder#resource
pub type NutritionorderOraldietSchedule {
  NutritionorderOraldietSchedule(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    timing: List(Timing),
    as_needed: Option(Bool),
    as_needed_for: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/NutritionOrder#resource
pub type NutritionorderOraldietNutrient {
  NutritionorderOraldietNutrient(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    modifier: Option(Codeableconcept),
    amount: Option(Quantity),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/NutritionOrder#resource
pub type NutritionorderOraldietTexture {
  NutritionorderOraldietTexture(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    modifier: Option(Codeableconcept),
    food_type: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/NutritionOrder#resource
pub type NutritionorderSupplement {
  NutritionorderSupplement(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeablereference),
    product_name: Option(String),
    schedule: Option(NutritionorderSupplementSchedule),
    quantity: Option(Quantity),
    instruction: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/NutritionOrder#resource
pub type NutritionorderSupplementSchedule {
  NutritionorderSupplementSchedule(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    timing: List(Timing),
    as_needed: Option(Bool),
    as_needed_for: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/NutritionOrder#resource
pub type NutritionorderEnteralformula {
  NutritionorderEnteralformula(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    base_formula_type: Option(Codeablereference),
    base_formula_product_name: Option(String),
    delivery_device: List(Codeablereference),
    additive: List(NutritionorderEnteralformulaAdditive),
    caloric_density: Option(Quantity),
    route_of_administration: Option(Codeableconcept),
    administration: List(NutritionorderEnteralformulaAdministration),
    max_volume_to_deliver: Option(Quantity),
    administration_instruction: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/NutritionOrder#resource
pub type NutritionorderEnteralformulaAdditive {
  NutritionorderEnteralformulaAdditive(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeablereference),
    product_name: Option(String),
    quantity: Option(Quantity),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/NutritionOrder#resource
pub type NutritionorderEnteralformulaAdministration {
  NutritionorderEnteralformulaAdministration(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    schedule: Option(NutritionorderEnteralformulaAdministrationSchedule),
    quantity: Option(Quantity),
    rate: Option(NutritionorderEnteralformulaAdministrationRate),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/NutritionOrder#resource
pub type NutritionorderEnteralformulaAdministrationRate {
  NutritionorderEnteralformulaAdministrationRateQuantity(rate: Quantity)
  NutritionorderEnteralformulaAdministrationRateRatio(rate: Ratio)
}

///http://hl7.org/fhir/r5/StructureDefinition/NutritionOrder#resource
pub type NutritionorderEnteralformulaAdministrationSchedule {
  NutritionorderEnteralformulaAdministrationSchedule(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    timing: List(Timing),
    as_needed: Option(Bool),
    as_needed_for: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/NutritionProduct#resource
pub type Nutritionproduct {
  Nutritionproduct(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(Codeableconcept),
    status: String,
    category: List(Codeableconcept),
    manufacturer: List(Reference),
    nutrient: List(NutritionproductNutrient),
    ingredient: List(NutritionproductIngredient),
    known_allergen: List(Codeablereference),
    characteristic: List(NutritionproductCharacteristic),
    instance: List(NutritionproductInstance),
    note: List(Annotation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/NutritionProduct#resource
pub type NutritionproductNutrient {
  NutritionproductNutrient(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item: Option(Codeablereference),
    amount: List(Ratio),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/NutritionProduct#resource
pub type NutritionproductIngredient {
  NutritionproductIngredient(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item: Codeablereference,
    amount: List(Ratio),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/NutritionProduct#resource
pub type NutritionproductCharacteristic {
  NutritionproductCharacteristic(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value: NutritionproductCharacteristicValue,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/NutritionProduct#resource
pub type NutritionproductCharacteristicValue {
  NutritionproductCharacteristicValueCodeableconcept(value: Codeableconcept)
  NutritionproductCharacteristicValueString(value: String)
  NutritionproductCharacteristicValueQuantity(value: Quantity)
  NutritionproductCharacteristicValueBase64binary(value: String)
  NutritionproductCharacteristicValueAttachment(value: Attachment)
  NutritionproductCharacteristicValueBoolean(value: Bool)
}

///http://hl7.org/fhir/r5/StructureDefinition/NutritionProduct#resource
pub type NutritionproductInstance {
  NutritionproductInstance(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    quantity: Option(Quantity),
    identifier: List(Identifier),
    name: Option(String),
    lot_number: Option(String),
    expiry: Option(String),
    use_by: Option(String),
    biological_source_event: Option(Identifier),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Observation#resource
pub type Observation {
  Observation(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    instantiates: Option(ObservationInstantiates),
    based_on: List(Reference),
    triggered_by: List(ObservationTriggeredby),
    part_of: List(Reference),
    status: String,
    category: List(Codeableconcept),
    code: Codeableconcept,
    subject: Option(Reference),
    focus: List(Reference),
    encounter: Option(Reference),
    effective: Option(ObservationEffective),
    issued: Option(String),
    performer: List(Reference),
    value: Option(ObservationValue),
    data_absent_reason: Option(Codeableconcept),
    interpretation: List(Codeableconcept),
    note: List(Annotation),
    body_site: Option(Codeableconcept),
    body_structure: Option(Reference),
    method: Option(Codeableconcept),
    specimen: Option(Reference),
    device: Option(Reference),
    reference_range: List(ObservationReferencerange),
    has_member: List(Reference),
    derived_from: List(Reference),
    component: List(ObservationComponent),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Observation#resource
pub type ObservationInstantiates {
  ObservationInstantiatesCanonical(instantiates: String)
  ObservationInstantiatesReference(instantiates: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/Observation#resource
pub type ObservationEffective {
  ObservationEffectiveDatetime(effective: String)
  ObservationEffectivePeriod(effective: Period)
  ObservationEffectiveTiming(effective: Timing)
  ObservationEffectiveInstant(effective: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/Observation#resource
pub type ObservationValue {
  ObservationValueQuantity(value: Quantity)
  ObservationValueCodeableconcept(value: Codeableconcept)
  ObservationValueString(value: String)
  ObservationValueBoolean(value: Bool)
  ObservationValueInteger(value: Int)
  ObservationValueRange(value: Range)
  ObservationValueRatio(value: Ratio)
  ObservationValueSampleddata(value: Sampleddata)
  ObservationValueTime(value: String)
  ObservationValueDatetime(value: String)
  ObservationValuePeriod(value: Period)
  ObservationValueAttachment(value: Attachment)
  ObservationValueReference(value: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/Observation#resource
pub type ObservationTriggeredby {
  ObservationTriggeredby(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    observation: Reference,
    type_: String,
    reason: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Observation#resource
pub type ObservationReferencerange {
  ObservationReferencerange(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    low: Option(Quantity),
    high: Option(Quantity),
    normal_value: Option(Codeableconcept),
    type_: Option(Codeableconcept),
    applies_to: List(Codeableconcept),
    age: Option(Range),
    text: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Observation#resource
pub type ObservationComponent {
  ObservationComponent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
    value: Option(ObservationComponentValue),
    data_absent_reason: Option(Codeableconcept),
    interpretation: List(Codeableconcept),
    reference_range: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Observation#resource
pub type ObservationComponentValue {
  ObservationComponentValueQuantity(value: Quantity)
  ObservationComponentValueCodeableconcept(value: Codeableconcept)
  ObservationComponentValueString(value: String)
  ObservationComponentValueBoolean(value: Bool)
  ObservationComponentValueInteger(value: Int)
  ObservationComponentValueRange(value: Range)
  ObservationComponentValueRatio(value: Ratio)
  ObservationComponentValueSampleddata(value: Sampleddata)
  ObservationComponentValueTime(value: String)
  ObservationComponentValueDatetime(value: String)
  ObservationComponentValuePeriod(value: Period)
  ObservationComponentValueAttachment(value: Attachment)
  ObservationComponentValueReference(value: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/ObservationDefinition#resource
pub type Observationdefinition {
  Observationdefinition(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: Option(Identifier),
    version: Option(String),
    version_algorithm: Option(ObservationdefinitionVersionalgorithm),
    name: Option(String),
    title: Option(String),
    status: String,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    approval_date: Option(String),
    last_review_date: Option(String),
    effective_period: Option(Period),
    derived_from_canonical: List(String),
    derived_from_uri: List(String),
    subject: List(Codeableconcept),
    performer_type: Option(Codeableconcept),
    category: List(Codeableconcept),
    code: Codeableconcept,
    permitted_data_type: List(String),
    multiple_results_allowed: Option(Bool),
    body_site: Option(Codeableconcept),
    method: Option(Codeableconcept),
    specimen: List(Reference),
    device: List(Reference),
    preferred_report_name: Option(String),
    permitted_unit: List(Coding),
    qualified_value: List(ObservationdefinitionQualifiedvalue),
    has_member: List(Reference),
    component: List(ObservationdefinitionComponent),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ObservationDefinition#resource
pub type ObservationdefinitionVersionalgorithm {
  ObservationdefinitionVersionalgorithmString(version_algorithm: String)
  ObservationdefinitionVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/ObservationDefinition#resource
pub type ObservationdefinitionQualifiedvalue {
  ObservationdefinitionQualifiedvalue(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    context: Option(Codeableconcept),
    applies_to: List(Codeableconcept),
    gender: Option(String),
    age: Option(Range),
    gestational_age: Option(Range),
    condition: Option(String),
    range_category: Option(String),
    range: Option(Range),
    valid_coded_value_set: Option(String),
    normal_coded_value_set: Option(String),
    abnormal_coded_value_set: Option(String),
    critical_coded_value_set: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ObservationDefinition#resource
pub type ObservationdefinitionComponent {
  ObservationdefinitionComponent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
    permitted_data_type: List(String),
    permitted_unit: List(Coding),
    qualified_value: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/OperationDefinition#resource
pub type Operationdefinition {
  Operationdefinition(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(OperationdefinitionVersionalgorithm),
    name: String,
    title: Option(String),
    status: String,
    kind: String,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    affects_state: Option(Bool),
    code: String,
    comment: Option(String),
    base: Option(String),
    resource: List(String),
    system: Bool,
    type_: Bool,
    instance: Bool,
    input_profile: Option(String),
    output_profile: Option(String),
    parameter: List(OperationdefinitionParameter),
    overload: List(OperationdefinitionOverload),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/OperationDefinition#resource
pub type OperationdefinitionVersionalgorithm {
  OperationdefinitionVersionalgorithmString(version_algorithm: String)
  OperationdefinitionVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/OperationDefinition#resource
pub type OperationdefinitionParameter {
  OperationdefinitionParameter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    use_: String,
    scope: List(String),
    min: Int,
    max: String,
    documentation: Option(String),
    type_: Option(String),
    allowed_type: List(String),
    target_profile: List(String),
    search_type: Option(String),
    binding: Option(OperationdefinitionParameterBinding),
    referenced_from: List(OperationdefinitionParameterReferencedfrom),
    part: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/OperationDefinition#resource
pub type OperationdefinitionParameterBinding {
  OperationdefinitionParameterBinding(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    strength: String,
    value_set: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/OperationDefinition#resource
pub type OperationdefinitionParameterReferencedfrom {
  OperationdefinitionParameterReferencedfrom(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    source: String,
    source_id: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/OperationDefinition#resource
pub type OperationdefinitionOverload {
  OperationdefinitionOverload(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    parameter_name: List(String),
    comment: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/OperationOutcome#resource
pub type Operationoutcome {
  Operationoutcome(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    issue: List(OperationoutcomeIssue),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/OperationOutcome#resource
pub type OperationoutcomeIssue {
  OperationoutcomeIssue(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    severity: String,
    code: String,
    details: Option(Codeableconcept),
    diagnostics: Option(String),
    location: List(String),
    expression: List(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Organization#resource
pub type Organization {
  Organization(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    active: Option(Bool),
    type_: List(Codeableconcept),
    name: Option(String),
    alias: List(String),
    description: Option(String),
    contact: List(Extendedcontactdetail),
    part_of: Option(Reference),
    endpoint: List(Reference),
    qualification: List(OrganizationQualification),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Organization#resource
pub type OrganizationQualification {
  OrganizationQualification(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    code: Codeableconcept,
    period: Option(Period),
    issuer: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/OrganizationAffiliation#resource
pub type Organizationaffiliation {
  Organizationaffiliation(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    active: Option(Bool),
    period: Option(Period),
    organization: Option(Reference),
    participating_organization: Option(Reference),
    network: List(Reference),
    code: List(Codeableconcept),
    specialty: List(Codeableconcept),
    location: List(Reference),
    healthcare_service: List(Reference),
    contact: List(Extendedcontactdetail),
    endpoint: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/PackagedProductDefinition#resource
pub type Packagedproductdefinition {
  Packagedproductdefinition(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    name: Option(String),
    type_: Option(Codeableconcept),
    package_for: List(Reference),
    status: Option(Codeableconcept),
    status_date: Option(String),
    contained_item_quantity: List(Quantity),
    description: Option(String),
    legal_status_of_supply: List(PackagedproductdefinitionLegalstatusofsupply),
    marketing_status: List(Marketingstatus),
    copackaged_indicator: Option(Bool),
    manufacturer: List(Reference),
    attached_document: List(Reference),
    packaging: Option(PackagedproductdefinitionPackaging),
    characteristic: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/PackagedProductDefinition#resource
pub type PackagedproductdefinitionLegalstatusofsupply {
  PackagedproductdefinitionLegalstatusofsupply(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(Codeableconcept),
    jurisdiction: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/PackagedProductDefinition#resource
pub type PackagedproductdefinitionPackaging {
  PackagedproductdefinitionPackaging(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    type_: Option(Codeableconcept),
    component_part: Option(Bool),
    quantity: Option(Int),
    material: List(Codeableconcept),
    alternate_material: List(Codeableconcept),
    shelf_life_storage: List(Productshelflife),
    manufacturer: List(Reference),
    property: List(PackagedproductdefinitionPackagingProperty),
    contained_item: List(PackagedproductdefinitionPackagingContaineditem),
    packaging: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/PackagedProductDefinition#resource
pub type PackagedproductdefinitionPackagingProperty {
  PackagedproductdefinitionPackagingProperty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value: Option(PackagedproductdefinitionPackagingPropertyValue),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/PackagedProductDefinition#resource
pub type PackagedproductdefinitionPackagingPropertyValue {
  PackagedproductdefinitionPackagingPropertyValueCodeableconcept(
    value: Codeableconcept,
  )
  PackagedproductdefinitionPackagingPropertyValueQuantity(value: Quantity)
  PackagedproductdefinitionPackagingPropertyValueDate(value: String)
  PackagedproductdefinitionPackagingPropertyValueBoolean(value: Bool)
  PackagedproductdefinitionPackagingPropertyValueAttachment(value: Attachment)
}

///http://hl7.org/fhir/r5/StructureDefinition/PackagedProductDefinition#resource
pub type PackagedproductdefinitionPackagingContaineditem {
  PackagedproductdefinitionPackagingContaineditem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item: Codeablereference,
    amount: Option(Quantity),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Parameters#resource
pub type Parameters {
  Parameters(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    parameter: List(ParametersParameter),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Parameters#resource
pub type ParametersParameter {
  ParametersParameter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    value: Option(ParametersParameterValue),
    resource: Option(Resource),
    part: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Parameters#resource
pub type ParametersParameterValue {
  ParametersParameterValueBase64binary(value: String)
  ParametersParameterValueBoolean(value: Bool)
  ParametersParameterValueCanonical(value: String)
  ParametersParameterValueCode(value: String)
  ParametersParameterValueDate(value: String)
  ParametersParameterValueDatetime(value: String)
  ParametersParameterValueDecimal(value: Float)
  ParametersParameterValueId(value: String)
  ParametersParameterValueInstant(value: String)
  ParametersParameterValueInteger(value: Int)
  ParametersParameterValueInteger64(value: Int)
  ParametersParameterValueMarkdown(value: String)
  ParametersParameterValueOid(value: String)
  ParametersParameterValuePositiveint(value: Int)
  ParametersParameterValueString(value: String)
  ParametersParameterValueTime(value: String)
  ParametersParameterValueUnsignedint(value: Int)
  ParametersParameterValueUri(value: String)
  ParametersParameterValueUrl(value: String)
  ParametersParameterValueUuid(value: String)
  ParametersParameterValueAddress(value: Address)
  ParametersParameterValueAge(value: Age)
  ParametersParameterValueAnnotation(value: Annotation)
  ParametersParameterValueAttachment(value: Attachment)
  ParametersParameterValueCodeableconcept(value: Codeableconcept)
  ParametersParameterValueCodeablereference(value: Codeablereference)
  ParametersParameterValueCoding(value: Coding)
  ParametersParameterValueContactpoint(value: Contactpoint)
  ParametersParameterValueCount(value: Count)
  ParametersParameterValueDistance(value: Distance)
  ParametersParameterValueDuration(value: Duration)
  ParametersParameterValueHumanname(value: Humanname)
  ParametersParameterValueIdentifier(value: Identifier)
  ParametersParameterValueMoney(value: Money)
  ParametersParameterValuePeriod(value: Period)
  ParametersParameterValueQuantity(value: Quantity)
  ParametersParameterValueRange(value: Range)
  ParametersParameterValueRatio(value: Ratio)
  ParametersParameterValueRatiorange(value: Ratiorange)
  ParametersParameterValueReference(value: Reference)
  ParametersParameterValueSampleddata(value: Sampleddata)
  ParametersParameterValueSignature(value: Signature)
  ParametersParameterValueTiming(value: Timing)
  ParametersParameterValueContactdetail(value: Contactdetail)
  ParametersParameterValueDatarequirement(value: Datarequirement)
  ParametersParameterValueExpression(value: Expression)
  ParametersParameterValueParameterdefinition(value: Parameterdefinition)
  ParametersParameterValueRelatedartifact(value: Relatedartifact)
  ParametersParameterValueTriggerdefinition(value: Triggerdefinition)
  ParametersParameterValueUsagecontext(value: Usagecontext)
  ParametersParameterValueAvailability(value: Availability)
  ParametersParameterValueExtendedcontactdetail(value: Extendedcontactdetail)
  ParametersParameterValueDosage(value: Dosage)
  ParametersParameterValueMeta(value: Meta)
}

///http://hl7.org/fhir/r5/StructureDefinition/Patient#resource
pub type Patient {
  Patient(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    active: Option(Bool),
    name: List(Humanname),
    telecom: List(Contactpoint),
    gender: Option(String),
    birth_date: Option(String),
    deceased: Option(PatientDeceased),
    address: List(Address),
    marital_status: Option(Codeableconcept),
    multiple_birth: Option(PatientMultiplebirth),
    photo: List(Attachment),
    contact: List(PatientContact),
    communication: List(PatientCommunication),
    general_practitioner: List(Reference),
    managing_organization: Option(Reference),
    link: List(PatientLink),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Patient#resource
pub type PatientDeceased {
  PatientDeceasedBoolean(deceased: Bool)
  PatientDeceasedDatetime(deceased: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/Patient#resource
pub type PatientMultiplebirth {
  PatientMultiplebirthBoolean(multiple_birth: Bool)
  PatientMultiplebirthInteger(multiple_birth: Int)
}

///http://hl7.org/fhir/r5/StructureDefinition/Patient#resource
pub type PatientContact {
  PatientContact(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    relationship: List(Codeableconcept),
    name: Option(Humanname),
    telecom: List(Contactpoint),
    address: Option(Address),
    gender: Option(String),
    organization: Option(Reference),
    period: Option(Period),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Patient#resource
pub type PatientCommunication {
  PatientCommunication(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    language: Codeableconcept,
    preferred: Option(Bool),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Patient#resource
pub type PatientLink {
  PatientLink(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    other: Reference,
    type_: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/PaymentNotice#resource
pub type Paymentnotice {
  Paymentnotice(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    request: Option(Reference),
    response: Option(Reference),
    created: String,
    reporter: Option(Reference),
    payment: Option(Reference),
    payment_date: Option(String),
    payee: Option(Reference),
    recipient: Reference,
    amount: Money,
    payment_status: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/PaymentReconciliation#resource
pub type Paymentreconciliation {
  Paymentreconciliation(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    type_: Codeableconcept,
    status: String,
    kind: Option(Codeableconcept),
    period: Option(Period),
    created: String,
    enterer: Option(Reference),
    issuer_type: Option(Codeableconcept),
    payment_issuer: Option(Reference),
    request: Option(Reference),
    requestor: Option(Reference),
    outcome: Option(String),
    disposition: Option(String),
    date: String,
    location: Option(Reference),
    method: Option(Codeableconcept),
    card_brand: Option(String),
    account_number: Option(String),
    expiration_date: Option(String),
    processor: Option(String),
    reference_number: Option(String),
    authorization: Option(String),
    tendered_amount: Option(Money),
    returned_amount: Option(Money),
    amount: Money,
    payment_identifier: Option(Identifier),
    allocation: List(PaymentreconciliationAllocation),
    form_code: Option(Codeableconcept),
    process_note: List(PaymentreconciliationProcessnote),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/PaymentReconciliation#resource
pub type PaymentreconciliationAllocation {
  PaymentreconciliationAllocation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Option(Identifier),
    predecessor: Option(Identifier),
    target: Option(Reference),
    target_item: Option(PaymentreconciliationAllocationTargetitem),
    encounter: Option(Reference),
    account: Option(Reference),
    type_: Option(Codeableconcept),
    submitter: Option(Reference),
    response: Option(Reference),
    date: Option(String),
    responsible: Option(Reference),
    payee: Option(Reference),
    amount: Option(Money),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/PaymentReconciliation#resource
pub type PaymentreconciliationAllocationTargetitem {
  PaymentreconciliationAllocationTargetitemString(target_item: String)
  PaymentreconciliationAllocationTargetitemIdentifier(target_item: Identifier)
  PaymentreconciliationAllocationTargetitemPositiveint(target_item: Int)
}

///http://hl7.org/fhir/r5/StructureDefinition/PaymentReconciliation#resource
pub type PaymentreconciliationProcessnote {
  PaymentreconciliationProcessnote(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(String),
    text: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Permission#resource
pub type Permission {
  Permission(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    status: String,
    asserter: Option(Reference),
    date: List(String),
    validity: Option(Period),
    justification: Option(PermissionJustification),
    combining: String,
    rule: List(PermissionRule),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Permission#resource
pub type PermissionJustification {
  PermissionJustification(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    basis: List(Codeableconcept),
    evidence: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Permission#resource
pub type PermissionRule {
  PermissionRule(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(String),
    data: List(PermissionRuleData),
    activity: List(PermissionRuleActivity),
    limit: List(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Permission#resource
pub type PermissionRuleData {
  PermissionRuleData(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    resource: List(PermissionRuleDataResource),
    security: List(Coding),
    period: List(Period),
    expression: Option(Expression),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Permission#resource
pub type PermissionRuleDataResource {
  PermissionRuleDataResource(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    meaning: String,
    reference: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Permission#resource
pub type PermissionRuleActivity {
  PermissionRuleActivity(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    actor: List(Reference),
    action: List(Codeableconcept),
    purpose: List(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Person#resource
pub type Person {
  Person(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    active: Option(Bool),
    name: List(Humanname),
    telecom: List(Contactpoint),
    gender: Option(String),
    birth_date: Option(String),
    deceased: Option(PersonDeceased),
    address: List(Address),
    marital_status: Option(Codeableconcept),
    photo: List(Attachment),
    communication: List(PersonCommunication),
    managing_organization: Option(Reference),
    link: List(PersonLink),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Person#resource
pub type PersonDeceased {
  PersonDeceasedBoolean(deceased: Bool)
  PersonDeceasedDatetime(deceased: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/Person#resource
pub type PersonCommunication {
  PersonCommunication(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    language: Codeableconcept,
    preferred: Option(Bool),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Person#resource
pub type PersonLink {
  PersonLink(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    target: Reference,
    assurance: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/PlanDefinition#resource
pub type Plandefinition {
  Plandefinition(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(PlandefinitionVersionalgorithm),
    name: Option(String),
    title: Option(String),
    subtitle: Option(String),
    type_: Option(Codeableconcept),
    status: String,
    experimental: Option(Bool),
    subject: Option(PlandefinitionSubject),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    usage: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    approval_date: Option(String),
    last_review_date: Option(String),
    effective_period: Option(Period),
    topic: List(Codeableconcept),
    author: List(Contactdetail),
    editor: List(Contactdetail),
    reviewer: List(Contactdetail),
    endorser: List(Contactdetail),
    related_artifact: List(Relatedartifact),
    library: List(String),
    goal: List(PlandefinitionGoal),
    actor: List(PlandefinitionActor),
    action: List(PlandefinitionAction),
    as_needed: Option(PlandefinitionAsneeded),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionVersionalgorithm {
  PlandefinitionVersionalgorithmString(version_algorithm: String)
  PlandefinitionVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionSubject {
  PlandefinitionSubjectCodeableconcept(subject: Codeableconcept)
  PlandefinitionSubjectReference(subject: Reference)
  PlandefinitionSubjectCanonical(subject: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionAsneeded {
  PlandefinitionAsneededBoolean(as_needed: Bool)
  PlandefinitionAsneededCodeableconcept(as_needed: Codeableconcept)
}

///http://hl7.org/fhir/r5/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionGoal {
  PlandefinitionGoal(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    category: Option(Codeableconcept),
    description: Codeableconcept,
    priority: Option(Codeableconcept),
    start: Option(Codeableconcept),
    addresses: List(Codeableconcept),
    documentation: List(Relatedartifact),
    target: List(PlandefinitionGoalTarget),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionGoalTarget {
  PlandefinitionGoalTarget(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    measure: Option(Codeableconcept),
    detail: Option(PlandefinitionGoalTargetDetail),
    due: Option(Duration),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionGoalTargetDetail {
  PlandefinitionGoalTargetDetailQuantity(detail: Quantity)
  PlandefinitionGoalTargetDetailRange(detail: Range)
  PlandefinitionGoalTargetDetailCodeableconcept(detail: Codeableconcept)
  PlandefinitionGoalTargetDetailString(detail: String)
  PlandefinitionGoalTargetDetailBoolean(detail: Bool)
  PlandefinitionGoalTargetDetailInteger(detail: Int)
  PlandefinitionGoalTargetDetailRatio(detail: Ratio)
}

///http://hl7.org/fhir/r5/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActor {
  PlandefinitionActor(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    title: Option(String),
    description: Option(String),
    option: List(PlandefinitionActorOption),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActorOption {
  PlandefinitionActorOption(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(String),
    type_canonical: Option(String),
    type_reference: Option(Reference),
    role: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionAction {
  PlandefinitionAction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    link_id: Option(String),
    prefix: Option(String),
    title: Option(String),
    description: Option(String),
    text_equivalent: Option(String),
    priority: Option(String),
    code: Option(Codeableconcept),
    reason: List(Codeableconcept),
    documentation: List(Relatedartifact),
    goal_id: List(String),
    subject: Option(PlandefinitionActionSubject),
    trigger: List(Triggerdefinition),
    condition: List(PlandefinitionActionCondition),
    input: List(PlandefinitionActionInput),
    output: List(PlandefinitionActionOutput),
    related_action: List(PlandefinitionActionRelatedaction),
    timing: Option(PlandefinitionActionTiming),
    location: Option(Codeablereference),
    participant: List(PlandefinitionActionParticipant),
    type_: Option(Codeableconcept),
    grouping_behavior: Option(String),
    selection_behavior: Option(String),
    required_behavior: Option(String),
    precheck_behavior: Option(String),
    cardinality_behavior: Option(String),
    definition: Option(PlandefinitionActionDefinition),
    transform: Option(String),
    dynamic_value: List(PlandefinitionActionDynamicvalue),
    action: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionSubject {
  PlandefinitionActionSubjectCodeableconcept(subject: Codeableconcept)
  PlandefinitionActionSubjectReference(subject: Reference)
  PlandefinitionActionSubjectCanonical(subject: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionTiming {
  PlandefinitionActionTimingAge(timing: Age)
  PlandefinitionActionTimingDuration(timing: Duration)
  PlandefinitionActionTimingRange(timing: Range)
  PlandefinitionActionTimingTiming(timing: Timing)
}

///http://hl7.org/fhir/r5/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionDefinition {
  PlandefinitionActionDefinitionCanonical(definition: String)
  PlandefinitionActionDefinitionUri(definition: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionCondition {
  PlandefinitionActionCondition(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    kind: String,
    expression: Option(Expression),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionInput {
  PlandefinitionActionInput(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    title: Option(String),
    requirement: Option(Datarequirement),
    related_data: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionOutput {
  PlandefinitionActionOutput(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    title: Option(String),
    requirement: Option(Datarequirement),
    related_data: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionRelatedaction {
  PlandefinitionActionRelatedaction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    target_id: String,
    relationship: String,
    end_relationship: Option(String),
    offset: Option(PlandefinitionActionRelatedactionOffset),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionRelatedactionOffset {
  PlandefinitionActionRelatedactionOffsetDuration(offset: Duration)
  PlandefinitionActionRelatedactionOffsetRange(offset: Range)
}

///http://hl7.org/fhir/r5/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionParticipant {
  PlandefinitionActionParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    actor_id: Option(String),
    type_: Option(String),
    type_canonical: Option(String),
    type_reference: Option(Reference),
    role: Option(Codeableconcept),
    function: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionDynamicvalue {
  PlandefinitionActionDynamicvalue(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    path: Option(String),
    expression: Option(Expression),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Practitioner#resource
pub type Practitioner {
  Practitioner(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    active: Option(Bool),
    name: List(Humanname),
    telecom: List(Contactpoint),
    gender: Option(String),
    birth_date: Option(String),
    deceased: Option(PractitionerDeceased),
    address: List(Address),
    photo: List(Attachment),
    qualification: List(PractitionerQualification),
    communication: List(PractitionerCommunication),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Practitioner#resource
pub type PractitionerDeceased {
  PractitionerDeceasedBoolean(deceased: Bool)
  PractitionerDeceasedDatetime(deceased: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/Practitioner#resource
pub type PractitionerQualification {
  PractitionerQualification(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    code: Codeableconcept,
    period: Option(Period),
    issuer: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Practitioner#resource
pub type PractitionerCommunication {
  PractitionerCommunication(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    language: Codeableconcept,
    preferred: Option(Bool),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/PractitionerRole#resource
pub type Practitionerrole {
  Practitionerrole(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    active: Option(Bool),
    period: Option(Period),
    practitioner: Option(Reference),
    organization: Option(Reference),
    code: List(Codeableconcept),
    specialty: List(Codeableconcept),
    location: List(Reference),
    healthcare_service: List(Reference),
    contact: List(Extendedcontactdetail),
    characteristic: List(Codeableconcept),
    communication: List(Codeableconcept),
    availability: List(Availability),
    endpoint: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Procedure#resource
pub type Procedure {
  Procedure(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    instantiates_canonical: List(String),
    instantiates_uri: List(String),
    based_on: List(Reference),
    part_of: List(Reference),
    status: String,
    status_reason: Option(Codeableconcept),
    category: List(Codeableconcept),
    code: Option(Codeableconcept),
    subject: Reference,
    focus: Option(Reference),
    encounter: Option(Reference),
    occurrence: Option(ProcedureOccurrence),
    recorded: Option(String),
    recorder: Option(Reference),
    reported: Option(ProcedureReported),
    performer: List(ProcedurePerformer),
    location: Option(Reference),
    reason: List(Codeablereference),
    body_site: List(Codeableconcept),
    outcome: Option(Codeableconcept),
    report: List(Reference),
    complication: List(Codeablereference),
    follow_up: List(Codeableconcept),
    note: List(Annotation),
    focal_device: List(ProcedureFocaldevice),
    used: List(Codeablereference),
    supporting_info: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Procedure#resource
pub type ProcedureOccurrence {
  ProcedureOccurrenceDatetime(occurrence: String)
  ProcedureOccurrencePeriod(occurrence: Period)
  ProcedureOccurrenceString(occurrence: String)
  ProcedureOccurrenceAge(occurrence: Age)
  ProcedureOccurrenceRange(occurrence: Range)
  ProcedureOccurrenceTiming(occurrence: Timing)
}

///http://hl7.org/fhir/r5/StructureDefinition/Procedure#resource
pub type ProcedureReported {
  ProcedureReportedBoolean(reported: Bool)
  ProcedureReportedReference(reported: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/Procedure#resource
pub type ProcedurePerformer {
  ProcedurePerformer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    function: Option(Codeableconcept),
    actor: Reference,
    on_behalf_of: Option(Reference),
    period: Option(Period),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Procedure#resource
pub type ProcedureFocaldevice {
  ProcedureFocaldevice(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    action: Option(Codeableconcept),
    manipulated: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Provenance#resource
pub type Provenance {
  Provenance(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    target: List(Reference),
    occurred: Option(ProvenanceOccurred),
    recorded: Option(String),
    policy: List(String),
    location: Option(Reference),
    authorization: List(Codeablereference),
    activity: Option(Codeableconcept),
    based_on: List(Reference),
    patient: Option(Reference),
    encounter: Option(Reference),
    agent: List(ProvenanceAgent),
    entity: List(ProvenanceEntity),
    signature: List(Signature),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Provenance#resource
pub type ProvenanceOccurred {
  ProvenanceOccurredPeriod(occurred: Period)
  ProvenanceOccurredDatetime(occurred: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/Provenance#resource
pub type ProvenanceAgent {
  ProvenanceAgent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    role: List(Codeableconcept),
    who: Reference,
    on_behalf_of: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Provenance#resource
pub type ProvenanceEntity {
  ProvenanceEntity(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    role: String,
    what: Reference,
    agent: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Questionnaire#resource
pub type Questionnaire {
  Questionnaire(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(QuestionnaireVersionalgorithm),
    name: Option(String),
    title: Option(String),
    derived_from: List(String),
    status: String,
    experimental: Option(Bool),
    subject_type: List(String),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    approval_date: Option(String),
    last_review_date: Option(String),
    effective_period: Option(Period),
    code: List(Coding),
    item: List(QuestionnaireItem),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Questionnaire#resource
pub type QuestionnaireVersionalgorithm {
  QuestionnaireVersionalgorithmString(version_algorithm: String)
  QuestionnaireVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/Questionnaire#resource
pub type QuestionnaireItem {
  QuestionnaireItem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    link_id: String,
    definition: Option(String),
    code: List(Coding),
    prefix: Option(String),
    text: Option(String),
    type_: String,
    enable_when: List(QuestionnaireItemEnablewhen),
    enable_behavior: Option(String),
    disabled_display: Option(String),
    required: Option(Bool),
    repeats: Option(Bool),
    read_only: Option(Bool),
    max_length: Option(Int),
    answer_constraint: Option(String),
    answer_value_set: Option(String),
    answer_option: List(QuestionnaireItemAnsweroption),
    initial: List(QuestionnaireItemInitial),
    item: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Questionnaire#resource
pub type QuestionnaireItemEnablewhen {
  QuestionnaireItemEnablewhen(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    question: String,
    operator: String,
    answer: QuestionnaireItemEnablewhenAnswer,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Questionnaire#resource
pub type QuestionnaireItemEnablewhenAnswer {
  QuestionnaireItemEnablewhenAnswerBoolean(answer: Bool)
  QuestionnaireItemEnablewhenAnswerDecimal(answer: Float)
  QuestionnaireItemEnablewhenAnswerInteger(answer: Int)
  QuestionnaireItemEnablewhenAnswerDate(answer: String)
  QuestionnaireItemEnablewhenAnswerDatetime(answer: String)
  QuestionnaireItemEnablewhenAnswerTime(answer: String)
  QuestionnaireItemEnablewhenAnswerString(answer: String)
  QuestionnaireItemEnablewhenAnswerCoding(answer: Coding)
  QuestionnaireItemEnablewhenAnswerQuantity(answer: Quantity)
  QuestionnaireItemEnablewhenAnswerReference(answer: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/Questionnaire#resource
pub type QuestionnaireItemAnsweroption {
  QuestionnaireItemAnsweroption(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    value: QuestionnaireItemAnsweroptionValue,
    initial_selected: Option(Bool),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Questionnaire#resource
pub type QuestionnaireItemAnsweroptionValue {
  QuestionnaireItemAnsweroptionValueInteger(value: Int)
  QuestionnaireItemAnsweroptionValueDate(value: String)
  QuestionnaireItemAnsweroptionValueTime(value: String)
  QuestionnaireItemAnsweroptionValueString(value: String)
  QuestionnaireItemAnsweroptionValueCoding(value: Coding)
  QuestionnaireItemAnsweroptionValueReference(value: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/Questionnaire#resource
pub type QuestionnaireItemInitial {
  QuestionnaireItemInitial(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    value: QuestionnaireItemInitialValue,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Questionnaire#resource
pub type QuestionnaireItemInitialValue {
  QuestionnaireItemInitialValueBoolean(value: Bool)
  QuestionnaireItemInitialValueDecimal(value: Float)
  QuestionnaireItemInitialValueInteger(value: Int)
  QuestionnaireItemInitialValueDate(value: String)
  QuestionnaireItemInitialValueDatetime(value: String)
  QuestionnaireItemInitialValueTime(value: String)
  QuestionnaireItemInitialValueString(value: String)
  QuestionnaireItemInitialValueUri(value: String)
  QuestionnaireItemInitialValueAttachment(value: Attachment)
  QuestionnaireItemInitialValueCoding(value: Coding)
  QuestionnaireItemInitialValueQuantity(value: Quantity)
  QuestionnaireItemInitialValueReference(value: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/QuestionnaireResponse#resource
pub type Questionnaireresponse {
  Questionnaireresponse(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    based_on: List(Reference),
    part_of: List(Reference),
    questionnaire: String,
    status: String,
    subject: Option(Reference),
    encounter: Option(Reference),
    authored: Option(String),
    author: Option(Reference),
    source: Option(Reference),
    item: List(QuestionnaireresponseItem),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/QuestionnaireResponse#resource
pub type QuestionnaireresponseItem {
  QuestionnaireresponseItem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    link_id: String,
    definition: Option(String),
    text: Option(String),
    answer: List(QuestionnaireresponseItemAnswer),
    item: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/QuestionnaireResponse#resource
pub type QuestionnaireresponseItemAnswer {
  QuestionnaireresponseItemAnswer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    value: QuestionnaireresponseItemAnswerValue,
    item: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/QuestionnaireResponse#resource
pub type QuestionnaireresponseItemAnswerValue {
  QuestionnaireresponseItemAnswerValueBoolean(value: Bool)
  QuestionnaireresponseItemAnswerValueDecimal(value: Float)
  QuestionnaireresponseItemAnswerValueInteger(value: Int)
  QuestionnaireresponseItemAnswerValueDate(value: String)
  QuestionnaireresponseItemAnswerValueDatetime(value: String)
  QuestionnaireresponseItemAnswerValueTime(value: String)
  QuestionnaireresponseItemAnswerValueString(value: String)
  QuestionnaireresponseItemAnswerValueUri(value: String)
  QuestionnaireresponseItemAnswerValueAttachment(value: Attachment)
  QuestionnaireresponseItemAnswerValueCoding(value: Coding)
  QuestionnaireresponseItemAnswerValueQuantity(value: Quantity)
  QuestionnaireresponseItemAnswerValueReference(value: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/RegulatedAuthorization#resource
pub type Regulatedauthorization {
  Regulatedauthorization(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    subject: List(Reference),
    type_: Option(Codeableconcept),
    description: Option(String),
    region: List(Codeableconcept),
    status: Option(Codeableconcept),
    status_date: Option(String),
    validity_period: Option(Period),
    indication: List(Codeablereference),
    intended_use: Option(Codeableconcept),
    basis: List(Codeableconcept),
    holder: Option(Reference),
    regulator: Option(Reference),
    attached_document: List(Reference),
    case_: Option(RegulatedauthorizationCase),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/RegulatedAuthorization#resource
pub type RegulatedauthorizationCase {
  RegulatedauthorizationCase(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Option(Identifier),
    type_: Option(Codeableconcept),
    status: Option(Codeableconcept),
    date: Option(RegulatedauthorizationCaseDate),
    application: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/RegulatedAuthorization#resource
pub type RegulatedauthorizationCaseDate {
  RegulatedauthorizationCaseDatePeriod(date: Period)
  RegulatedauthorizationCaseDateDatetime(date: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/RelatedPerson#resource
pub type Relatedperson {
  Relatedperson(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    active: Option(Bool),
    patient: Reference,
    relationship: List(Codeableconcept),
    name: List(Humanname),
    telecom: List(Contactpoint),
    gender: Option(String),
    birth_date: Option(String),
    address: List(Address),
    photo: List(Attachment),
    period: Option(Period),
    communication: List(RelatedpersonCommunication),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/RelatedPerson#resource
pub type RelatedpersonCommunication {
  RelatedpersonCommunication(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    language: Codeableconcept,
    preferred: Option(Bool),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/RequestOrchestration#resource
pub type Requestorchestration {
  Requestorchestration(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    instantiates_canonical: List(String),
    instantiates_uri: List(String),
    based_on: List(Reference),
    replaces: List(Reference),
    group_identifier: Option(Identifier),
    status: String,
    intent: String,
    priority: Option(String),
    code: Option(Codeableconcept),
    subject: Option(Reference),
    encounter: Option(Reference),
    authored_on: Option(String),
    author: Option(Reference),
    reason: List(Codeablereference),
    goal: List(Reference),
    note: List(Annotation),
    action: List(RequestorchestrationAction),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/RequestOrchestration#resource
pub type RequestorchestrationAction {
  RequestorchestrationAction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    link_id: Option(String),
    prefix: Option(String),
    title: Option(String),
    description: Option(String),
    text_equivalent: Option(String),
    priority: Option(String),
    code: List(Codeableconcept),
    documentation: List(Relatedartifact),
    goal: List(Reference),
    condition: List(RequestorchestrationActionCondition),
    input: List(RequestorchestrationActionInput),
    output: List(RequestorchestrationActionOutput),
    related_action: List(RequestorchestrationActionRelatedaction),
    timing: Option(RequestorchestrationActionTiming),
    location: Option(Codeablereference),
    participant: List(RequestorchestrationActionParticipant),
    type_: Option(Codeableconcept),
    grouping_behavior: Option(String),
    selection_behavior: Option(String),
    required_behavior: Option(String),
    precheck_behavior: Option(String),
    cardinality_behavior: Option(String),
    resource: Option(Reference),
    definition: Option(RequestorchestrationActionDefinition),
    transform: Option(String),
    dynamic_value: List(RequestorchestrationActionDynamicvalue),
    action: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/RequestOrchestration#resource
pub type RequestorchestrationActionTiming {
  RequestorchestrationActionTimingDatetime(timing: String)
  RequestorchestrationActionTimingAge(timing: Age)
  RequestorchestrationActionTimingPeriod(timing: Period)
  RequestorchestrationActionTimingDuration(timing: Duration)
  RequestorchestrationActionTimingRange(timing: Range)
  RequestorchestrationActionTimingTiming(timing: Timing)
}

///http://hl7.org/fhir/r5/StructureDefinition/RequestOrchestration#resource
pub type RequestorchestrationActionDefinition {
  RequestorchestrationActionDefinitionCanonical(definition: String)
  RequestorchestrationActionDefinitionUri(definition: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/RequestOrchestration#resource
pub type RequestorchestrationActionCondition {
  RequestorchestrationActionCondition(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    kind: String,
    expression: Option(Expression),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/RequestOrchestration#resource
pub type RequestorchestrationActionInput {
  RequestorchestrationActionInput(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    title: Option(String),
    requirement: Option(Datarequirement),
    related_data: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/RequestOrchestration#resource
pub type RequestorchestrationActionOutput {
  RequestorchestrationActionOutput(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    title: Option(String),
    requirement: Option(Datarequirement),
    related_data: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/RequestOrchestration#resource
pub type RequestorchestrationActionRelatedaction {
  RequestorchestrationActionRelatedaction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    target_id: String,
    relationship: String,
    end_relationship: Option(String),
    offset: Option(RequestorchestrationActionRelatedactionOffset),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/RequestOrchestration#resource
pub type RequestorchestrationActionRelatedactionOffset {
  RequestorchestrationActionRelatedactionOffsetDuration(offset: Duration)
  RequestorchestrationActionRelatedactionOffsetRange(offset: Range)
}

///http://hl7.org/fhir/r5/StructureDefinition/RequestOrchestration#resource
pub type RequestorchestrationActionParticipant {
  RequestorchestrationActionParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(String),
    type_canonical: Option(String),
    type_reference: Option(Reference),
    role: Option(Codeableconcept),
    function: Option(Codeableconcept),
    actor: Option(RequestorchestrationActionParticipantActor),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/RequestOrchestration#resource
pub type RequestorchestrationActionParticipantActor {
  RequestorchestrationActionParticipantActorCanonical(actor: String)
  RequestorchestrationActionParticipantActorReference(actor: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/RequestOrchestration#resource
pub type RequestorchestrationActionDynamicvalue {
  RequestorchestrationActionDynamicvalue(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    path: Option(String),
    expression: Option(Expression),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Requirements#resource
pub type Requirements {
  Requirements(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(RequirementsVersionalgorithm),
    name: Option(String),
    title: Option(String),
    status: String,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    derived_from: List(String),
    reference: List(String),
    actor: List(String),
    statement: List(RequirementsStatement),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Requirements#resource
pub type RequirementsVersionalgorithm {
  RequirementsVersionalgorithmString(version_algorithm: String)
  RequirementsVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/Requirements#resource
pub type RequirementsStatement {
  RequirementsStatement(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    key: String,
    label: Option(String),
    conformance: List(String),
    conditionality: Option(Bool),
    requirement: String,
    derived_from: Option(String),
    parent: Option(String),
    satisfied_by: List(String),
    reference: List(String),
    source: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ResearchStudy#resource
pub type Researchstudy {
  Researchstudy(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    name: Option(String),
    title: Option(String),
    label: List(ResearchstudyLabel),
    protocol: List(Reference),
    part_of: List(Reference),
    related_artifact: List(Relatedartifact),
    date: Option(String),
    status: String,
    primary_purpose_type: Option(Codeableconcept),
    phase: Option(Codeableconcept),
    study_design: List(Codeableconcept),
    focus: List(Codeablereference),
    condition: List(Codeableconcept),
    keyword: List(Codeableconcept),
    region: List(Codeableconcept),
    description_summary: Option(String),
    description: Option(String),
    period: Option(Period),
    site: List(Reference),
    note: List(Annotation),
    classifier: List(Codeableconcept),
    associated_party: List(ResearchstudyAssociatedparty),
    progress_status: List(ResearchstudyProgressstatus),
    why_stopped: Option(Codeableconcept),
    recruitment: Option(ResearchstudyRecruitment),
    comparison_group: List(ResearchstudyComparisongroup),
    objective: List(ResearchstudyObjective),
    outcome_measure: List(ResearchstudyOutcomemeasure),
    result: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ResearchStudy#resource
pub type ResearchstudyLabel {
  ResearchstudyLabel(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    value: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ResearchStudy#resource
pub type ResearchstudyAssociatedparty {
  ResearchstudyAssociatedparty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: Option(String),
    role: Codeableconcept,
    period: List(Period),
    classifier: List(Codeableconcept),
    party: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ResearchStudy#resource
pub type ResearchstudyProgressstatus {
  ResearchstudyProgressstatus(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    state: Codeableconcept,
    actual: Option(Bool),
    period: Option(Period),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ResearchStudy#resource
pub type ResearchstudyRecruitment {
  ResearchstudyRecruitment(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    target_number: Option(Int),
    actual_number: Option(Int),
    eligibility: Option(Reference),
    actual_group: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ResearchStudy#resource
pub type ResearchstudyComparisongroup {
  ResearchstudyComparisongroup(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    link_id: Option(String),
    name: String,
    type_: Option(Codeableconcept),
    description: Option(String),
    intended_exposure: List(Reference),
    observed_group: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ResearchStudy#resource
pub type ResearchstudyObjective {
  ResearchstudyObjective(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: Option(String),
    type_: Option(Codeableconcept),
    description: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ResearchStudy#resource
pub type ResearchstudyOutcomemeasure {
  ResearchstudyOutcomemeasure(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: Option(String),
    type_: List(Codeableconcept),
    description: Option(String),
    reference: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ResearchSubject#resource
pub type Researchsubject {
  Researchsubject(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    progress: List(ResearchsubjectProgress),
    period: Option(Period),
    study: Reference,
    subject: Reference,
    assigned_comparison_group: Option(String),
    actual_comparison_group: Option(String),
    consent: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ResearchSubject#resource
pub type ResearchsubjectProgress {
  ResearchsubjectProgress(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    subject_state: Option(Codeableconcept),
    milestone: Option(Codeableconcept),
    reason: Option(Codeableconcept),
    start_date: Option(String),
    end_date: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/RiskAssessment#resource
pub type Riskassessment {
  Riskassessment(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    based_on: Option(Reference),
    parent: Option(Reference),
    status: String,
    method: Option(Codeableconcept),
    code: Option(Codeableconcept),
    subject: Reference,
    encounter: Option(Reference),
    occurrence: Option(RiskassessmentOccurrence),
    condition: Option(Reference),
    performer: Option(Reference),
    reason: List(Codeablereference),
    basis: List(Reference),
    prediction: List(RiskassessmentPrediction),
    mitigation: Option(String),
    note: List(Annotation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/RiskAssessment#resource
pub type RiskassessmentOccurrence {
  RiskassessmentOccurrenceDatetime(occurrence: String)
  RiskassessmentOccurrencePeriod(occurrence: Period)
}

///http://hl7.org/fhir/r5/StructureDefinition/RiskAssessment#resource
pub type RiskassessmentPrediction {
  RiskassessmentPrediction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    outcome: Option(Codeableconcept),
    probability: Option(RiskassessmentPredictionProbability),
    qualitative_risk: Option(Codeableconcept),
    relative_risk: Option(Float),
    when: Option(RiskassessmentPredictionWhen),
    rationale: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/RiskAssessment#resource
pub type RiskassessmentPredictionProbability {
  RiskassessmentPredictionProbabilityDecimal(probability: Float)
  RiskassessmentPredictionProbabilityRange(probability: Range)
}

///http://hl7.org/fhir/r5/StructureDefinition/RiskAssessment#resource
pub type RiskassessmentPredictionWhen {
  RiskassessmentPredictionWhenPeriod(when: Period)
  RiskassessmentPredictionWhenRange(when: Range)
}

///http://hl7.org/fhir/r5/StructureDefinition/Schedule#resource
pub type Schedule {
  Schedule(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    active: Option(Bool),
    service_category: List(Codeableconcept),
    service_type: List(Codeablereference),
    specialty: List(Codeableconcept),
    name: Option(String),
    actor: List(Reference),
    planning_horizon: Option(Period),
    comment: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SearchParameter#resource
pub type Searchparameter {
  Searchparameter(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: String,
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(SearchparameterVersionalgorithm),
    name: String,
    title: Option(String),
    derived_from: Option(String),
    status: String,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: String,
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    code: String,
    base: List(String),
    type_: String,
    expression: Option(String),
    processing_mode: Option(String),
    constraint: Option(String),
    target: List(String),
    multiple_or: Option(Bool),
    multiple_and: Option(Bool),
    comparator: List(String),
    modifier: List(String),
    chain: List(String),
    component: List(SearchparameterComponent),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SearchParameter#resource
pub type SearchparameterVersionalgorithm {
  SearchparameterVersionalgorithmString(version_algorithm: String)
  SearchparameterVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/SearchParameter#resource
pub type SearchparameterComponent {
  SearchparameterComponent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    definition: String,
    expression: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ServiceRequest#resource
pub type Servicerequest {
  Servicerequest(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    instantiates_canonical: List(String),
    instantiates_uri: List(String),
    based_on: List(Reference),
    replaces: List(Reference),
    requisition: Option(Identifier),
    status: String,
    intent: String,
    category: List(Codeableconcept),
    priority: Option(String),
    do_not_perform: Option(Bool),
    code: Option(Codeablereference),
    order_detail: List(ServicerequestOrderdetail),
    quantity: Option(ServicerequestQuantity),
    subject: Reference,
    focus: List(Reference),
    encounter: Option(Reference),
    occurrence: Option(ServicerequestOccurrence),
    as_needed: Option(ServicerequestAsneeded),
    authored_on: Option(String),
    requester: Option(Reference),
    performer_type: Option(Codeableconcept),
    performer: List(Reference),
    location: List(Codeablereference),
    reason: List(Codeablereference),
    insurance: List(Reference),
    supporting_info: List(Codeablereference),
    specimen: List(Reference),
    body_site: List(Codeableconcept),
    body_structure: Option(Reference),
    note: List(Annotation),
    patient_instruction: List(ServicerequestPatientinstruction),
    relevant_history: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ServiceRequest#resource
pub type ServicerequestQuantity {
  ServicerequestQuantityQuantity(quantity: Quantity)
  ServicerequestQuantityRatio(quantity: Ratio)
  ServicerequestQuantityRange(quantity: Range)
}

///http://hl7.org/fhir/r5/StructureDefinition/ServiceRequest#resource
pub type ServicerequestOccurrence {
  ServicerequestOccurrenceDatetime(occurrence: String)
  ServicerequestOccurrencePeriod(occurrence: Period)
  ServicerequestOccurrenceTiming(occurrence: Timing)
}

///http://hl7.org/fhir/r5/StructureDefinition/ServiceRequest#resource
pub type ServicerequestAsneeded {
  ServicerequestAsneededBoolean(as_needed: Bool)
  ServicerequestAsneededCodeableconcept(as_needed: Codeableconcept)
}

///http://hl7.org/fhir/r5/StructureDefinition/ServiceRequest#resource
pub type ServicerequestOrderdetail {
  ServicerequestOrderdetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    parameter_focus: Option(Codeablereference),
    parameter: List(ServicerequestOrderdetailParameter),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ServiceRequest#resource
pub type ServicerequestOrderdetailParameter {
  ServicerequestOrderdetailParameter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
    value: ServicerequestOrderdetailParameterValue,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ServiceRequest#resource
pub type ServicerequestOrderdetailParameterValue {
  ServicerequestOrderdetailParameterValueQuantity(value: Quantity)
  ServicerequestOrderdetailParameterValueRatio(value: Ratio)
  ServicerequestOrderdetailParameterValueRange(value: Range)
  ServicerequestOrderdetailParameterValueBoolean(value: Bool)
  ServicerequestOrderdetailParameterValueCodeableconcept(value: Codeableconcept)
  ServicerequestOrderdetailParameterValueString(value: String)
  ServicerequestOrderdetailParameterValuePeriod(value: Period)
}

///http://hl7.org/fhir/r5/StructureDefinition/ServiceRequest#resource
pub type ServicerequestPatientinstruction {
  ServicerequestPatientinstruction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    instruction: Option(ServicerequestPatientinstructionInstruction),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ServiceRequest#resource
pub type ServicerequestPatientinstructionInstruction {
  ServicerequestPatientinstructionInstructionMarkdown(instruction: String)
  ServicerequestPatientinstructionInstructionReference(instruction: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/Slot#resource
pub type Slot {
  Slot(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    service_category: List(Codeableconcept),
    service_type: List(Codeablereference),
    specialty: List(Codeableconcept),
    appointment_type: List(Codeableconcept),
    schedule: Reference,
    status: String,
    start: String,
    end: String,
    overbooked: Option(Bool),
    comment: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Specimen#resource
pub type Specimen {
  Specimen(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    accession_identifier: Option(Identifier),
    status: Option(String),
    type_: Option(Codeableconcept),
    subject: Option(Reference),
    received_time: Option(String),
    parent: List(Reference),
    request: List(Reference),
    combined: Option(String),
    role: List(Codeableconcept),
    feature: List(SpecimenFeature),
    collection: Option(SpecimenCollection),
    processing: List(SpecimenProcessing),
    container: List(SpecimenContainer),
    condition: List(Codeableconcept),
    note: List(Annotation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Specimen#resource
pub type SpecimenFeature {
  SpecimenFeature(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    description: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Specimen#resource
pub type SpecimenCollection {
  SpecimenCollection(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    collector: Option(Reference),
    collected: Option(SpecimenCollectionCollected),
    duration: Option(Duration),
    quantity: Option(Quantity),
    method: Option(Codeableconcept),
    device: Option(Codeablereference),
    procedure: Option(Reference),
    body_site: Option(Codeablereference),
    fasting_status: Option(SpecimenCollectionFastingstatus),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Specimen#resource
pub type SpecimenCollectionCollected {
  SpecimenCollectionCollectedDatetime(collected: String)
  SpecimenCollectionCollectedPeriod(collected: Period)
}

///http://hl7.org/fhir/r5/StructureDefinition/Specimen#resource
pub type SpecimenCollectionFastingstatus {
  SpecimenCollectionFastingstatusCodeableconcept(
    fasting_status: Codeableconcept,
  )
  SpecimenCollectionFastingstatusDuration(fasting_status: Duration)
}

///http://hl7.org/fhir/r5/StructureDefinition/Specimen#resource
pub type SpecimenProcessing {
  SpecimenProcessing(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    method: Option(Codeableconcept),
    additive: List(Reference),
    time: Option(SpecimenProcessingTime),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Specimen#resource
pub type SpecimenProcessingTime {
  SpecimenProcessingTimeDatetime(time: String)
  SpecimenProcessingTimePeriod(time: Period)
}

///http://hl7.org/fhir/r5/StructureDefinition/Specimen#resource
pub type SpecimenContainer {
  SpecimenContainer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    device: Reference,
    location: Option(Reference),
    specimen_quantity: Option(Quantity),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SpecimenDefinition#resource
pub type Specimendefinition {
  Specimendefinition(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: Option(Identifier),
    version: Option(String),
    version_algorithm: Option(SpecimendefinitionVersionalgorithm),
    name: Option(String),
    title: Option(String),
    derived_from_canonical: List(String),
    derived_from_uri: List(String),
    status: String,
    experimental: Option(Bool),
    subject: Option(SpecimendefinitionSubject),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    approval_date: Option(String),
    last_review_date: Option(String),
    effective_period: Option(Period),
    type_collected: Option(Codeableconcept),
    patient_preparation: List(Codeableconcept),
    time_aspect: Option(String),
    collection: List(Codeableconcept),
    type_tested: List(SpecimendefinitionTypetested),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SpecimenDefinition#resource
pub type SpecimendefinitionVersionalgorithm {
  SpecimendefinitionVersionalgorithmString(version_algorithm: String)
  SpecimendefinitionVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/SpecimenDefinition#resource
pub type SpecimendefinitionSubject {
  SpecimendefinitionSubjectCodeableconcept(subject: Codeableconcept)
  SpecimendefinitionSubjectReference(subject: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/SpecimenDefinition#resource
pub type SpecimendefinitionTypetested {
  SpecimendefinitionTypetested(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    is_derived: Option(Bool),
    type_: Option(Codeableconcept),
    preference: String,
    container: Option(SpecimendefinitionTypetestedContainer),
    requirement: Option(String),
    retention_time: Option(Duration),
    single_use: Option(Bool),
    rejection_criterion: List(Codeableconcept),
    handling: List(SpecimendefinitionTypetestedHandling),
    testing_destination: List(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SpecimenDefinition#resource
pub type SpecimendefinitionTypetestedContainer {
  SpecimendefinitionTypetestedContainer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    material: Option(Codeableconcept),
    type_: Option(Codeableconcept),
    cap: Option(Codeableconcept),
    description: Option(String),
    capacity: Option(Quantity),
    minimum_volume: Option(SpecimendefinitionTypetestedContainerMinimumvolume),
    additive: List(SpecimendefinitionTypetestedContainerAdditive),
    preparation: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SpecimenDefinition#resource
pub type SpecimendefinitionTypetestedContainerMinimumvolume {
  SpecimendefinitionTypetestedContainerMinimumvolumeQuantity(
    minimum_volume: Quantity,
  )
  SpecimendefinitionTypetestedContainerMinimumvolumeString(
    minimum_volume: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SpecimenDefinition#resource
pub type SpecimendefinitionTypetestedContainerAdditive {
  SpecimendefinitionTypetestedContainerAdditive(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    additive: SpecimendefinitionTypetestedContainerAdditiveAdditive,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SpecimenDefinition#resource
pub type SpecimendefinitionTypetestedContainerAdditiveAdditive {
  SpecimendefinitionTypetestedContainerAdditiveAdditiveCodeableconcept(
    additive: Codeableconcept,
  )
  SpecimendefinitionTypetestedContainerAdditiveAdditiveReference(
    additive: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SpecimenDefinition#resource
pub type SpecimendefinitionTypetestedHandling {
  SpecimendefinitionTypetestedHandling(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    temperature_qualifier: Option(Codeableconcept),
    temperature_range: Option(Range),
    max_duration: Option(Duration),
    instruction: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/StructureDefinition#resource
pub type Structuredefinition {
  Structuredefinition(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: String,
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(StructuredefinitionVersionalgorithm),
    name: String,
    title: Option(String),
    status: String,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    keyword: List(Coding),
    fhir_version: Option(String),
    mapping: List(StructuredefinitionMapping),
    kind: String,
    abstract: Bool,
    context: List(StructuredefinitionContext),
    context_invariant: List(String),
    type_: String,
    base_definition: Option(String),
    derivation: Option(String),
    snapshot: Option(StructuredefinitionSnapshot),
    differential: Option(StructuredefinitionDifferential),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/StructureDefinition#resource
pub type StructuredefinitionVersionalgorithm {
  StructuredefinitionVersionalgorithmString(version_algorithm: String)
  StructuredefinitionVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/StructureDefinition#resource
pub type StructuredefinitionMapping {
  StructuredefinitionMapping(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identity: String,
    uri: Option(String),
    name: Option(String),
    comment: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/StructureDefinition#resource
pub type StructuredefinitionContext {
  StructuredefinitionContext(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: String,
    expression: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/StructureDefinition#resource
pub type StructuredefinitionSnapshot {
  StructuredefinitionSnapshot(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    element: List(Elementdefinition),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/StructureDefinition#resource
pub type StructuredefinitionDifferential {
  StructuredefinitionDifferential(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    element: List(Elementdefinition),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/StructureMap#resource
pub type Structuremap {
  Structuremap(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: String,
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(StructuremapVersionalgorithm),
    name: String,
    title: Option(String),
    status: String,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    structure: List(StructuremapStructure),
    import_: List(String),
    const_: List(StructuremapConst),
    group: List(StructuremapGroup),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/StructureMap#resource
pub type StructuremapVersionalgorithm {
  StructuremapVersionalgorithmString(version_algorithm: String)
  StructuremapVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/StructureMap#resource
pub type StructuremapStructure {
  StructuremapStructure(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: String,
    mode: String,
    alias: Option(String),
    documentation: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/StructureMap#resource
pub type StructuremapConst {
  StructuremapConst(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: Option(String),
    value: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/StructureMap#resource
pub type StructuremapGroup {
  StructuremapGroup(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    extends: Option(String),
    type_mode: Option(String),
    documentation: Option(String),
    input: List(StructuremapGroupInput),
    rule: List(StructuremapGroupRule),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/StructureMap#resource
pub type StructuremapGroupInput {
  StructuremapGroupInput(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    type_: Option(String),
    mode: String,
    documentation: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/StructureMap#resource
pub type StructuremapGroupRule {
  StructuremapGroupRule(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: Option(String),
    source: List(StructuremapGroupRuleSource),
    target: List(StructuremapGroupRuleTarget),
    rule: List(Nil),
    dependent: List(StructuremapGroupRuleDependent),
    documentation: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/StructureMap#resource
pub type StructuremapGroupRuleSource {
  StructuremapGroupRuleSource(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    context: String,
    min: Option(Int),
    max: Option(String),
    type_: Option(String),
    default_value: Option(String),
    element: Option(String),
    list_mode: Option(String),
    variable: Option(String),
    condition: Option(String),
    check: Option(String),
    log_message: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/StructureMap#resource
pub type StructuremapGroupRuleTarget {
  StructuremapGroupRuleTarget(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    context: Option(String),
    element: Option(String),
    variable: Option(String),
    list_mode: List(String),
    list_rule_id: Option(String),
    transform: Option(String),
    parameter: List(StructuremapGroupRuleTargetParameter),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/StructureMap#resource
pub type StructuremapGroupRuleTargetParameter {
  StructuremapGroupRuleTargetParameter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    value: StructuremapGroupRuleTargetParameterValue,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/StructureMap#resource
pub type StructuremapGroupRuleTargetParameterValue {
  StructuremapGroupRuleTargetParameterValueId(value: String)
  StructuremapGroupRuleTargetParameterValueString(value: String)
  StructuremapGroupRuleTargetParameterValueBoolean(value: Bool)
  StructuremapGroupRuleTargetParameterValueInteger(value: Int)
  StructuremapGroupRuleTargetParameterValueDecimal(value: Float)
  StructuremapGroupRuleTargetParameterValueDate(value: String)
  StructuremapGroupRuleTargetParameterValueTime(value: String)
  StructuremapGroupRuleTargetParameterValueDatetime(value: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/StructureMap#resource
pub type StructuremapGroupRuleDependent {
  StructuremapGroupRuleDependent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    parameter: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Subscription#resource
pub type Subscription {
  Subscription(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    name: Option(String),
    status: String,
    topic: String,
    contact: List(Contactpoint),
    end: Option(String),
    managing_entity: Option(Reference),
    reason: Option(String),
    filter_by: List(SubscriptionFilterby),
    channel_type: Coding,
    endpoint: Option(String),
    parameter: List(SubscriptionParameter),
    heartbeat_period: Option(Int),
    timeout: Option(Int),
    content_type: Option(String),
    content: Option(String),
    max_count: Option(Int),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Subscription#resource
pub type SubscriptionFilterby {
  SubscriptionFilterby(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    resource_type: Option(String),
    filter_parameter: String,
    comparator: Option(String),
    modifier: Option(String),
    value: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Subscription#resource
pub type SubscriptionParameter {
  SubscriptionParameter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    value: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubscriptionStatus#resource
pub type Subscriptionstatus {
  Subscriptionstatus(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    status: Option(String),
    type_: String,
    events_since_subscription_start: Option(Int),
    notification_event: List(SubscriptionstatusNotificationevent),
    subscription: Reference,
    topic: Option(String),
    error: List(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubscriptionStatus#resource
pub type SubscriptionstatusNotificationevent {
  SubscriptionstatusNotificationevent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    event_number: Int,
    timestamp: Option(String),
    focus: Option(Reference),
    additional_context: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubscriptionTopic#resource
pub type Subscriptiontopic {
  Subscriptiontopic(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: String,
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(SubscriptiontopicVersionalgorithm),
    name: Option(String),
    title: Option(String),
    derived_from: List(String),
    status: String,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    approval_date: Option(String),
    last_review_date: Option(String),
    effective_period: Option(Period),
    resource_trigger: List(SubscriptiontopicResourcetrigger),
    event_trigger: List(SubscriptiontopicEventtrigger),
    can_filter_by: List(SubscriptiontopicCanfilterby),
    notification_shape: List(SubscriptiontopicNotificationshape),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubscriptionTopic#resource
pub type SubscriptiontopicVersionalgorithm {
  SubscriptiontopicVersionalgorithmString(version_algorithm: String)
  SubscriptiontopicVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/SubscriptionTopic#resource
pub type SubscriptiontopicResourcetrigger {
  SubscriptiontopicResourcetrigger(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    resource: String,
    supported_interaction: List(String),
    query_criteria: Option(SubscriptiontopicResourcetriggerQuerycriteria),
    fhir_path_criteria: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubscriptionTopic#resource
pub type SubscriptiontopicResourcetriggerQuerycriteria {
  SubscriptiontopicResourcetriggerQuerycriteria(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    previous: Option(String),
    result_for_create: Option(String),
    current: Option(String),
    result_for_delete: Option(String),
    require_both: Option(Bool),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubscriptionTopic#resource
pub type SubscriptiontopicEventtrigger {
  SubscriptiontopicEventtrigger(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    event: Codeableconcept,
    resource: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubscriptionTopic#resource
pub type SubscriptiontopicCanfilterby {
  SubscriptiontopicCanfilterby(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    resource: Option(String),
    filter_parameter: String,
    filter_definition: Option(String),
    comparator: List(String),
    modifier: List(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubscriptionTopic#resource
pub type SubscriptiontopicNotificationshape {
  SubscriptiontopicNotificationshape(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    resource: String,
    include: List(String),
    rev_include: List(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Substance#resource
pub type Substance {
  Substance(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    instance: Bool,
    status: Option(String),
    category: List(Codeableconcept),
    code: Codeablereference,
    description: Option(String),
    expiry: Option(String),
    quantity: Option(Quantity),
    ingredient: List(SubstanceIngredient),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Substance#resource
pub type SubstanceIngredient {
  SubstanceIngredient(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    quantity: Option(Ratio),
    substance: SubstanceIngredientSubstance,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Substance#resource
pub type SubstanceIngredientSubstance {
  SubstanceIngredientSubstanceCodeableconcept(substance: Codeableconcept)
  SubstanceIngredientSubstanceReference(substance: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceDefinition#resource
pub type Substancedefinition {
  Substancedefinition(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    version: Option(String),
    status: Option(Codeableconcept),
    classification: List(Codeableconcept),
    domain: Option(Codeableconcept),
    grade: List(Codeableconcept),
    description: Option(String),
    information_source: List(Reference),
    note: List(Annotation),
    manufacturer: List(Reference),
    supplier: List(Reference),
    moiety: List(SubstancedefinitionMoiety),
    characterization: List(SubstancedefinitionCharacterization),
    property: List(SubstancedefinitionProperty),
    reference_information: Option(Reference),
    molecular_weight: List(SubstancedefinitionMolecularweight),
    structure: Option(SubstancedefinitionStructure),
    code: List(SubstancedefinitionCode),
    name: List(SubstancedefinitionName),
    relationship: List(SubstancedefinitionRelationship),
    nucleic_acid: Option(Reference),
    polymer: Option(Reference),
    protein: Option(Reference),
    source_material: Option(SubstancedefinitionSourcematerial),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceDefinition#resource
pub type SubstancedefinitionMoiety {
  SubstancedefinitionMoiety(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    role: Option(Codeableconcept),
    identifier: Option(Identifier),
    name: Option(String),
    stereochemistry: Option(Codeableconcept),
    optical_activity: Option(Codeableconcept),
    molecular_formula: Option(String),
    amount: Option(SubstancedefinitionMoietyAmount),
    measurement_type: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceDefinition#resource
pub type SubstancedefinitionMoietyAmount {
  SubstancedefinitionMoietyAmountQuantity(amount: Quantity)
  SubstancedefinitionMoietyAmountString(amount: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceDefinition#resource
pub type SubstancedefinitionCharacterization {
  SubstancedefinitionCharacterization(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    technique: Option(Codeableconcept),
    form: Option(Codeableconcept),
    description: Option(String),
    file: List(Attachment),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceDefinition#resource
pub type SubstancedefinitionProperty {
  SubstancedefinitionProperty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value: Option(SubstancedefinitionPropertyValue),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceDefinition#resource
pub type SubstancedefinitionPropertyValue {
  SubstancedefinitionPropertyValueCodeableconcept(value: Codeableconcept)
  SubstancedefinitionPropertyValueQuantity(value: Quantity)
  SubstancedefinitionPropertyValueDate(value: String)
  SubstancedefinitionPropertyValueBoolean(value: Bool)
  SubstancedefinitionPropertyValueAttachment(value: Attachment)
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceDefinition#resource
pub type SubstancedefinitionMolecularweight {
  SubstancedefinitionMolecularweight(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    method: Option(Codeableconcept),
    type_: Option(Codeableconcept),
    amount: Quantity,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceDefinition#resource
pub type SubstancedefinitionStructure {
  SubstancedefinitionStructure(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    stereochemistry: Option(Codeableconcept),
    optical_activity: Option(Codeableconcept),
    molecular_formula: Option(String),
    molecular_formula_by_moiety: Option(String),
    molecular_weight: Option(Nil),
    technique: List(Codeableconcept),
    source_document: List(Reference),
    representation: List(SubstancedefinitionStructureRepresentation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceDefinition#resource
pub type SubstancedefinitionStructureRepresentation {
  SubstancedefinitionStructureRepresentation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    representation: Option(String),
    format: Option(Codeableconcept),
    document: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceDefinition#resource
pub type SubstancedefinitionCode {
  SubstancedefinitionCode(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(Codeableconcept),
    status: Option(Codeableconcept),
    status_date: Option(String),
    note: List(Annotation),
    source: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceDefinition#resource
pub type SubstancedefinitionName {
  SubstancedefinitionName(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    type_: Option(Codeableconcept),
    status: Option(Codeableconcept),
    preferred: Option(Bool),
    language: List(Codeableconcept),
    domain: List(Codeableconcept),
    jurisdiction: List(Codeableconcept),
    synonym: List(Nil),
    translation: List(Nil),
    official: List(SubstancedefinitionNameOfficial),
    source: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceDefinition#resource
pub type SubstancedefinitionNameOfficial {
  SubstancedefinitionNameOfficial(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    authority: Option(Codeableconcept),
    status: Option(Codeableconcept),
    date: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceDefinition#resource
pub type SubstancedefinitionRelationship {
  SubstancedefinitionRelationship(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    substance_definition: Option(
      SubstancedefinitionRelationshipSubstancedefinition,
    ),
    type_: Codeableconcept,
    is_defining: Option(Bool),
    amount: Option(SubstancedefinitionRelationshipAmount),
    ratio_high_limit_amount: Option(Ratio),
    comparator: Option(Codeableconcept),
    source: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceDefinition#resource
pub type SubstancedefinitionRelationshipSubstancedefinition {
  SubstancedefinitionRelationshipSubstancedefinitionReference(
    substance_definition: Reference,
  )
  SubstancedefinitionRelationshipSubstancedefinitionCodeableconcept(
    substance_definition: Codeableconcept,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceDefinition#resource
pub type SubstancedefinitionRelationshipAmount {
  SubstancedefinitionRelationshipAmountQuantity(amount: Quantity)
  SubstancedefinitionRelationshipAmountRatio(amount: Ratio)
  SubstancedefinitionRelationshipAmountString(amount: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceDefinition#resource
pub type SubstancedefinitionSourcematerial {
  SubstancedefinitionSourcematerial(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    genus: Option(Codeableconcept),
    species: Option(Codeableconcept),
    part: Option(Codeableconcept),
    country_of_origin: List(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceNucleicAcid#resource
pub type Substancenucleicacid {
  Substancenucleicacid(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence_type: Option(Codeableconcept),
    number_of_subunits: Option(Int),
    area_of_hybridisation: Option(String),
    oligo_nucleotide_type: Option(Codeableconcept),
    subunit: List(SubstancenucleicacidSubunit),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceNucleicAcid#resource
pub type SubstancenucleicacidSubunit {
  SubstancenucleicacidSubunit(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    subunit: Option(Int),
    sequence: Option(String),
    length: Option(Int),
    sequence_attachment: Option(Attachment),
    five_prime: Option(Codeableconcept),
    three_prime: Option(Codeableconcept),
    linkage: List(SubstancenucleicacidSubunitLinkage),
    sugar: List(SubstancenucleicacidSubunitSugar),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceNucleicAcid#resource
pub type SubstancenucleicacidSubunitLinkage {
  SubstancenucleicacidSubunitLinkage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    connectivity: Option(String),
    identifier: Option(Identifier),
    name: Option(String),
    residue_site: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceNucleicAcid#resource
pub type SubstancenucleicacidSubunitSugar {
  SubstancenucleicacidSubunitSugar(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Option(Identifier),
    name: Option(String),
    residue_site: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstancePolymer#resource
pub type Substancepolymer {
  Substancepolymer(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Option(Identifier),
    class: Option(Codeableconcept),
    geometry: Option(Codeableconcept),
    copolymer_connectivity: List(Codeableconcept),
    modification: Option(String),
    monomer_set: List(SubstancepolymerMonomerset),
    repeat: List(SubstancepolymerRepeat),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstancePolymer#resource
pub type SubstancepolymerMonomerset {
  SubstancepolymerMonomerset(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    ratio_type: Option(Codeableconcept),
    starting_material: List(SubstancepolymerMonomersetStartingmaterial),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstancePolymer#resource
pub type SubstancepolymerMonomersetStartingmaterial {
  SubstancepolymerMonomersetStartingmaterial(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(Codeableconcept),
    category: Option(Codeableconcept),
    is_defining: Option(Bool),
    amount: Option(Quantity),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstancePolymer#resource
pub type SubstancepolymerRepeat {
  SubstancepolymerRepeat(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    average_molecular_formula: Option(String),
    repeat_unit_amount_type: Option(Codeableconcept),
    repeat_unit: List(SubstancepolymerRepeatRepeatunit),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstancePolymer#resource
pub type SubstancepolymerRepeatRepeatunit {
  SubstancepolymerRepeatRepeatunit(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    unit: Option(String),
    orientation: Option(Codeableconcept),
    amount: Option(Int),
    degree_of_polymerisation: List(
      SubstancepolymerRepeatRepeatunitDegreeofpolymerisation,
    ),
    structural_representation: List(
      SubstancepolymerRepeatRepeatunitStructuralrepresentation,
    ),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstancePolymer#resource
pub type SubstancepolymerRepeatRepeatunitDegreeofpolymerisation {
  SubstancepolymerRepeatRepeatunitDegreeofpolymerisation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    average: Option(Int),
    low: Option(Int),
    high: Option(Int),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstancePolymer#resource
pub type SubstancepolymerRepeatRepeatunitStructuralrepresentation {
  SubstancepolymerRepeatRepeatunitStructuralrepresentation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    representation: Option(String),
    format: Option(Codeableconcept),
    attachment: Option(Attachment),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceProtein#resource
pub type Substanceprotein {
  Substanceprotein(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence_type: Option(Codeableconcept),
    number_of_subunits: Option(Int),
    disulfide_linkage: List(String),
    subunit: List(SubstanceproteinSubunit),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceProtein#resource
pub type SubstanceproteinSubunit {
  SubstanceproteinSubunit(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    subunit: Option(Int),
    sequence: Option(String),
    length: Option(Int),
    sequence_attachment: Option(Attachment),
    n_terminal_modification_id: Option(Identifier),
    n_terminal_modification: Option(String),
    c_terminal_modification_id: Option(Identifier),
    c_terminal_modification: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceReferenceInformation#resource
pub type Substancereferenceinformation {
  Substancereferenceinformation(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    comment: Option(String),
    gene: List(SubstancereferenceinformationGene),
    gene_element: List(SubstancereferenceinformationGeneelement),
    target: List(SubstancereferenceinformationTarget),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceReferenceInformation#resource
pub type SubstancereferenceinformationGene {
  SubstancereferenceinformationGene(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    gene_sequence_origin: Option(Codeableconcept),
    gene: Option(Codeableconcept),
    source: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceReferenceInformation#resource
pub type SubstancereferenceinformationGeneelement {
  SubstancereferenceinformationGeneelement(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    element: Option(Identifier),
    source: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceReferenceInformation#resource
pub type SubstancereferenceinformationTarget {
  SubstancereferenceinformationTarget(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    target: Option(Identifier),
    type_: Option(Codeableconcept),
    interaction: Option(Codeableconcept),
    organism: Option(Codeableconcept),
    organism_type: Option(Codeableconcept),
    amount: Option(SubstancereferenceinformationTargetAmount),
    amount_type: Option(Codeableconcept),
    source: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceReferenceInformation#resource
pub type SubstancereferenceinformationTargetAmount {
  SubstancereferenceinformationTargetAmountQuantity(amount: Quantity)
  SubstancereferenceinformationTargetAmountRange(amount: Range)
  SubstancereferenceinformationTargetAmountString(amount: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceSourceMaterial#resource
pub type Substancesourcematerial {
  Substancesourcematerial(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    source_material_class: Option(Codeableconcept),
    source_material_type: Option(Codeableconcept),
    source_material_state: Option(Codeableconcept),
    organism_id: Option(Identifier),
    organism_name: Option(String),
    parent_substance_id: List(Identifier),
    parent_substance_name: List(String),
    country_of_origin: List(Codeableconcept),
    geographical_location: List(String),
    development_stage: Option(Codeableconcept),
    fraction_description: List(SubstancesourcematerialFractiondescription),
    organism: Option(SubstancesourcematerialOrganism),
    part_description: List(SubstancesourcematerialPartdescription),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceSourceMaterial#resource
pub type SubstancesourcematerialFractiondescription {
  SubstancesourcematerialFractiondescription(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    fraction: Option(String),
    material_type: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceSourceMaterial#resource
pub type SubstancesourcematerialOrganism {
  SubstancesourcematerialOrganism(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    family: Option(Codeableconcept),
    genus: Option(Codeableconcept),
    species: Option(Codeableconcept),
    intraspecific_type: Option(Codeableconcept),
    intraspecific_description: Option(String),
    author: List(SubstancesourcematerialOrganismAuthor),
    hybrid: Option(SubstancesourcematerialOrganismHybrid),
    organism_general: Option(SubstancesourcematerialOrganismOrganismgeneral),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceSourceMaterial#resource
pub type SubstancesourcematerialOrganismAuthor {
  SubstancesourcematerialOrganismAuthor(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    author_type: Option(Codeableconcept),
    author_description: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceSourceMaterial#resource
pub type SubstancesourcematerialOrganismHybrid {
  SubstancesourcematerialOrganismHybrid(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    maternal_organism_id: Option(String),
    maternal_organism_name: Option(String),
    paternal_organism_id: Option(String),
    paternal_organism_name: Option(String),
    hybrid_type: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceSourceMaterial#resource
pub type SubstancesourcematerialOrganismOrganismgeneral {
  SubstancesourcematerialOrganismOrganismgeneral(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    kingdom: Option(Codeableconcept),
    phylum: Option(Codeableconcept),
    class: Option(Codeableconcept),
    order: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SubstanceSourceMaterial#resource
pub type SubstancesourcematerialPartdescription {
  SubstancesourcematerialPartdescription(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    part: Option(Codeableconcept),
    part_location: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SupplyDelivery#resource
pub type Supplydelivery {
  Supplydelivery(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    based_on: List(Reference),
    part_of: List(Reference),
    status: Option(String),
    patient: Option(Reference),
    type_: Option(Codeableconcept),
    supplied_item: List(SupplydeliverySupplieditem),
    occurrence: Option(SupplydeliveryOccurrence),
    supplier: Option(Reference),
    destination: Option(Reference),
    receiver: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SupplyDelivery#resource
pub type SupplydeliveryOccurrence {
  SupplydeliveryOccurrenceDatetime(occurrence: String)
  SupplydeliveryOccurrencePeriod(occurrence: Period)
  SupplydeliveryOccurrenceTiming(occurrence: Timing)
}

///http://hl7.org/fhir/r5/StructureDefinition/SupplyDelivery#resource
pub type SupplydeliverySupplieditem {
  SupplydeliverySupplieditem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    quantity: Option(Quantity),
    item: Option(SupplydeliverySupplieditemItem),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SupplyDelivery#resource
pub type SupplydeliverySupplieditemItem {
  SupplydeliverySupplieditemItemCodeableconcept(item: Codeableconcept)
  SupplydeliverySupplieditemItemReference(item: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/SupplyRequest#resource
pub type Supplyrequest {
  Supplyrequest(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: Option(String),
    based_on: List(Reference),
    category: Option(Codeableconcept),
    priority: Option(String),
    deliver_for: Option(Reference),
    item: Codeablereference,
    quantity: Quantity,
    parameter: List(SupplyrequestParameter),
    occurrence: Option(SupplyrequestOccurrence),
    authored_on: Option(String),
    requester: Option(Reference),
    supplier: List(Reference),
    reason: List(Codeablereference),
    deliver_from: Option(Reference),
    deliver_to: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SupplyRequest#resource
pub type SupplyrequestOccurrence {
  SupplyrequestOccurrenceDatetime(occurrence: String)
  SupplyrequestOccurrencePeriod(occurrence: Period)
  SupplyrequestOccurrenceTiming(occurrence: Timing)
}

///http://hl7.org/fhir/r5/StructureDefinition/SupplyRequest#resource
pub type SupplyrequestParameter {
  SupplyrequestParameter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(Codeableconcept),
    value: Option(SupplyrequestParameterValue),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SupplyRequest#resource
pub type SupplyrequestParameterValue {
  SupplyrequestParameterValueCodeableconcept(value: Codeableconcept)
  SupplyrequestParameterValueQuantity(value: Quantity)
  SupplyrequestParameterValueRange(value: Range)
  SupplyrequestParameterValueBoolean(value: Bool)
}

///http://hl7.org/fhir/r5/StructureDefinition/Task#resource
pub type Task {
  Task(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    instantiates_canonical: Option(String),
    instantiates_uri: Option(String),
    based_on: List(Reference),
    group_identifier: Option(Identifier),
    part_of: List(Reference),
    status: String,
    status_reason: Option(Codeablereference),
    business_status: Option(Codeableconcept),
    intent: String,
    priority: Option(String),
    do_not_perform: Option(Bool),
    code: Option(Codeableconcept),
    description: Option(String),
    focus: Option(Reference),
    for: Option(Reference),
    encounter: Option(Reference),
    requested_period: Option(Period),
    execution_period: Option(Period),
    authored_on: Option(String),
    last_modified: Option(String),
    requester: Option(Reference),
    requested_performer: List(Codeablereference),
    owner: Option(Reference),
    performer: List(TaskPerformer),
    location: Option(Reference),
    reason: List(Codeablereference),
    insurance: List(Reference),
    note: List(Annotation),
    relevant_history: List(Reference),
    restriction: Option(TaskRestriction),
    input: List(TaskInput),
    output: List(TaskOutput),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Task#resource
pub type TaskPerformer {
  TaskPerformer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    function: Option(Codeableconcept),
    actor: Reference,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Task#resource
pub type TaskRestriction {
  TaskRestriction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    repetitions: Option(Int),
    period: Option(Period),
    recipient: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Task#resource
pub type TaskInput {
  TaskInput(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value: TaskInputValue,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Task#resource
pub type TaskInputValue {
  TaskInputValueBase64binary(value: String)
  TaskInputValueBoolean(value: Bool)
  TaskInputValueCanonical(value: String)
  TaskInputValueCode(value: String)
  TaskInputValueDate(value: String)
  TaskInputValueDatetime(value: String)
  TaskInputValueDecimal(value: Float)
  TaskInputValueId(value: String)
  TaskInputValueInstant(value: String)
  TaskInputValueInteger(value: Int)
  TaskInputValueInteger64(value: Int)
  TaskInputValueMarkdown(value: String)
  TaskInputValueOid(value: String)
  TaskInputValuePositiveint(value: Int)
  TaskInputValueString(value: String)
  TaskInputValueTime(value: String)
  TaskInputValueUnsignedint(value: Int)
  TaskInputValueUri(value: String)
  TaskInputValueUrl(value: String)
  TaskInputValueUuid(value: String)
  TaskInputValueAddress(value: Address)
  TaskInputValueAge(value: Age)
  TaskInputValueAnnotation(value: Annotation)
  TaskInputValueAttachment(value: Attachment)
  TaskInputValueCodeableconcept(value: Codeableconcept)
  TaskInputValueCodeablereference(value: Codeablereference)
  TaskInputValueCoding(value: Coding)
  TaskInputValueContactpoint(value: Contactpoint)
  TaskInputValueCount(value: Count)
  TaskInputValueDistance(value: Distance)
  TaskInputValueDuration(value: Duration)
  TaskInputValueHumanname(value: Humanname)
  TaskInputValueIdentifier(value: Identifier)
  TaskInputValueMoney(value: Money)
  TaskInputValuePeriod(value: Period)
  TaskInputValueQuantity(value: Quantity)
  TaskInputValueRange(value: Range)
  TaskInputValueRatio(value: Ratio)
  TaskInputValueRatiorange(value: Ratiorange)
  TaskInputValueReference(value: Reference)
  TaskInputValueSampleddata(value: Sampleddata)
  TaskInputValueSignature(value: Signature)
  TaskInputValueTiming(value: Timing)
  TaskInputValueContactdetail(value: Contactdetail)
  TaskInputValueDatarequirement(value: Datarequirement)
  TaskInputValueExpression(value: Expression)
  TaskInputValueParameterdefinition(value: Parameterdefinition)
  TaskInputValueRelatedartifact(value: Relatedartifact)
  TaskInputValueTriggerdefinition(value: Triggerdefinition)
  TaskInputValueUsagecontext(value: Usagecontext)
  TaskInputValueAvailability(value: Availability)
  TaskInputValueExtendedcontactdetail(value: Extendedcontactdetail)
  TaskInputValueDosage(value: Dosage)
  TaskInputValueMeta(value: Meta)
}

///http://hl7.org/fhir/r5/StructureDefinition/Task#resource
pub type TaskOutput {
  TaskOutput(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value: TaskOutputValue,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Task#resource
pub type TaskOutputValue {
  TaskOutputValueBase64binary(value: String)
  TaskOutputValueBoolean(value: Bool)
  TaskOutputValueCanonical(value: String)
  TaskOutputValueCode(value: String)
  TaskOutputValueDate(value: String)
  TaskOutputValueDatetime(value: String)
  TaskOutputValueDecimal(value: Float)
  TaskOutputValueId(value: String)
  TaskOutputValueInstant(value: String)
  TaskOutputValueInteger(value: Int)
  TaskOutputValueInteger64(value: Int)
  TaskOutputValueMarkdown(value: String)
  TaskOutputValueOid(value: String)
  TaskOutputValuePositiveint(value: Int)
  TaskOutputValueString(value: String)
  TaskOutputValueTime(value: String)
  TaskOutputValueUnsignedint(value: Int)
  TaskOutputValueUri(value: String)
  TaskOutputValueUrl(value: String)
  TaskOutputValueUuid(value: String)
  TaskOutputValueAddress(value: Address)
  TaskOutputValueAge(value: Age)
  TaskOutputValueAnnotation(value: Annotation)
  TaskOutputValueAttachment(value: Attachment)
  TaskOutputValueCodeableconcept(value: Codeableconcept)
  TaskOutputValueCodeablereference(value: Codeablereference)
  TaskOutputValueCoding(value: Coding)
  TaskOutputValueContactpoint(value: Contactpoint)
  TaskOutputValueCount(value: Count)
  TaskOutputValueDistance(value: Distance)
  TaskOutputValueDuration(value: Duration)
  TaskOutputValueHumanname(value: Humanname)
  TaskOutputValueIdentifier(value: Identifier)
  TaskOutputValueMoney(value: Money)
  TaskOutputValuePeriod(value: Period)
  TaskOutputValueQuantity(value: Quantity)
  TaskOutputValueRange(value: Range)
  TaskOutputValueRatio(value: Ratio)
  TaskOutputValueRatiorange(value: Ratiorange)
  TaskOutputValueReference(value: Reference)
  TaskOutputValueSampleddata(value: Sampleddata)
  TaskOutputValueSignature(value: Signature)
  TaskOutputValueTiming(value: Timing)
  TaskOutputValueContactdetail(value: Contactdetail)
  TaskOutputValueDatarequirement(value: Datarequirement)
  TaskOutputValueExpression(value: Expression)
  TaskOutputValueParameterdefinition(value: Parameterdefinition)
  TaskOutputValueRelatedartifact(value: Relatedartifact)
  TaskOutputValueTriggerdefinition(value: Triggerdefinition)
  TaskOutputValueUsagecontext(value: Usagecontext)
  TaskOutputValueAvailability(value: Availability)
  TaskOutputValueExtendedcontactdetail(value: Extendedcontactdetail)
  TaskOutputValueDosage(value: Dosage)
  TaskOutputValueMeta(value: Meta)
}

///http://hl7.org/fhir/r5/StructureDefinition/TerminologyCapabilities#resource
pub type Terminologycapabilities {
  Terminologycapabilities(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(TerminologycapabilitiesVersionalgorithm),
    name: Option(String),
    title: Option(String),
    status: String,
    experimental: Option(Bool),
    date: String,
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    kind: String,
    software: Option(TerminologycapabilitiesSoftware),
    implementation: Option(TerminologycapabilitiesImplementation),
    locked_date: Option(Bool),
    code_system: List(TerminologycapabilitiesCodesystem),
    expansion: Option(TerminologycapabilitiesExpansion),
    code_search: Option(String),
    validate_code: Option(TerminologycapabilitiesValidatecode),
    translation: Option(TerminologycapabilitiesTranslation),
    closure: Option(TerminologycapabilitiesClosure),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TerminologyCapabilities#resource
pub type TerminologycapabilitiesVersionalgorithm {
  TerminologycapabilitiesVersionalgorithmString(version_algorithm: String)
  TerminologycapabilitiesVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/TerminologyCapabilities#resource
pub type TerminologycapabilitiesSoftware {
  TerminologycapabilitiesSoftware(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    version: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TerminologyCapabilities#resource
pub type TerminologycapabilitiesImplementation {
  TerminologycapabilitiesImplementation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: String,
    url: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TerminologyCapabilities#resource
pub type TerminologycapabilitiesCodesystem {
  TerminologycapabilitiesCodesystem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    uri: Option(String),
    version: List(TerminologycapabilitiesCodesystemVersion),
    content: String,
    subsumption: Option(Bool),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TerminologyCapabilities#resource
pub type TerminologycapabilitiesCodesystemVersion {
  TerminologycapabilitiesCodesystemVersion(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(String),
    is_default: Option(Bool),
    compositional: Option(Bool),
    language: List(String),
    filter: List(TerminologycapabilitiesCodesystemVersionFilter),
    property: List(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TerminologyCapabilities#resource
pub type TerminologycapabilitiesCodesystemVersionFilter {
  TerminologycapabilitiesCodesystemVersionFilter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    op: List(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TerminologyCapabilities#resource
pub type TerminologycapabilitiesExpansion {
  TerminologycapabilitiesExpansion(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    hierarchical: Option(Bool),
    paging: Option(Bool),
    incomplete: Option(Bool),
    parameter: List(TerminologycapabilitiesExpansionParameter),
    text_filter: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TerminologyCapabilities#resource
pub type TerminologycapabilitiesExpansionParameter {
  TerminologycapabilitiesExpansionParameter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    documentation: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TerminologyCapabilities#resource
pub type TerminologycapabilitiesValidatecode {
  TerminologycapabilitiesValidatecode(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    translations: Bool,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TerminologyCapabilities#resource
pub type TerminologycapabilitiesTranslation {
  TerminologycapabilitiesTranslation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    needs_map: Bool,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TerminologyCapabilities#resource
pub type TerminologycapabilitiesClosure {
  TerminologycapabilitiesClosure(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    translation: Option(Bool),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestPlan#resource
pub type Testplan {
  Testplan(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(TestplanVersionalgorithm),
    name: Option(String),
    title: Option(String),
    status: String,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    category: List(Codeableconcept),
    scope: List(Reference),
    test_tools: Option(String),
    dependency: List(TestplanDependency),
    exit_criteria: Option(String),
    test_case: List(TestplanTestcase),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestPlan#resource
pub type TestplanVersionalgorithm {
  TestplanVersionalgorithmString(version_algorithm: String)
  TestplanVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/TestPlan#resource
pub type TestplanDependency {
  TestplanDependency(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    predecessor: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestPlan#resource
pub type TestplanTestcase {
  TestplanTestcase(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Option(Int),
    scope: List(Reference),
    dependency: List(TestplanTestcaseDependency),
    test_run: List(TestplanTestcaseTestrun),
    test_data: List(TestplanTestcaseTestdata),
    assertion: List(TestplanTestcaseAssertion),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestPlan#resource
pub type TestplanTestcaseDependency {
  TestplanTestcaseDependency(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    predecessor: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestPlan#resource
pub type TestplanTestcaseTestrun {
  TestplanTestcaseTestrun(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    narrative: Option(String),
    script: Option(TestplanTestcaseTestrunScript),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestPlan#resource
pub type TestplanTestcaseTestrunScript {
  TestplanTestcaseTestrunScript(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    language: Option(Codeableconcept),
    source: Option(TestplanTestcaseTestrunScriptSource),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestPlan#resource
pub type TestplanTestcaseTestrunScriptSource {
  TestplanTestcaseTestrunScriptSourceString(source: String)
  TestplanTestcaseTestrunScriptSourceReference(source: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/TestPlan#resource
pub type TestplanTestcaseTestdata {
  TestplanTestcaseTestdata(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Coding,
    content: Option(Reference),
    source: Option(TestplanTestcaseTestdataSource),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestPlan#resource
pub type TestplanTestcaseTestdataSource {
  TestplanTestcaseTestdataSourceString(source: String)
  TestplanTestcaseTestdataSourceReference(source: Reference)
}

///http://hl7.org/fhir/r5/StructureDefinition/TestPlan#resource
pub type TestplanTestcaseAssertion {
  TestplanTestcaseAssertion(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: List(Codeableconcept),
    object: List(Codeablereference),
    result: List(Codeablereference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestReport#resource
pub type Testreport {
  Testreport(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Option(Identifier),
    name: Option(String),
    status: String,
    test_script: String,
    result: String,
    score: Option(Float),
    tester: Option(String),
    issued: Option(String),
    participant: List(TestreportParticipant),
    setup: Option(TestreportSetup),
    test_: List(TestreportTest),
    teardown: Option(TestreportTeardown),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestReport#resource
pub type TestreportParticipant {
  TestreportParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: String,
    uri: String,
    display: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestReport#resource
pub type TestreportSetup {
  TestreportSetup(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    action: List(TestreportSetupAction),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestReport#resource
pub type TestreportSetupAction {
  TestreportSetupAction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    operation: Option(TestreportSetupActionOperation),
    assert_: Option(TestreportSetupActionAssert),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestReport#resource
pub type TestreportSetupActionOperation {
  TestreportSetupActionOperation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    result: String,
    message: Option(String),
    detail: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestReport#resource
pub type TestreportSetupActionAssert {
  TestreportSetupActionAssert(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    result: String,
    message: Option(String),
    detail: Option(String),
    requirement: List(TestreportSetupActionAssertRequirement),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestReport#resource
pub type TestreportSetupActionAssertRequirement {
  TestreportSetupActionAssertRequirement(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    link: Option(TestreportSetupActionAssertRequirementLink),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestReport#resource
pub type TestreportSetupActionAssertRequirementLink {
  TestreportSetupActionAssertRequirementLinkUri(link: String)
  TestreportSetupActionAssertRequirementLinkCanonical(link: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/TestReport#resource
pub type TestreportTest {
  TestreportTest(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: Option(String),
    description: Option(String),
    action: List(TestreportTestAction),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestReport#resource
pub type TestreportTestAction {
  TestreportTestAction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    operation: Option(Nil),
    assert_: Option(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestReport#resource
pub type TestreportTeardown {
  TestreportTeardown(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    action: List(TestreportTeardownAction),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestReport#resource
pub type TestreportTeardownAction {
  TestreportTeardownAction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    operation: Nil,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestScript#resource
pub type Testscript {
  Testscript(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(TestscriptVersionalgorithm),
    name: String,
    title: Option(String),
    status: String,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    origin: List(TestscriptOrigin),
    destination: List(TestscriptDestination),
    metadata: Option(TestscriptMetadata),
    scope: List(TestscriptScope),
    fixture: List(TestscriptFixture),
    profile: List(String),
    variable: List(TestscriptVariable),
    setup: Option(TestscriptSetup),
    test_: List(TestscriptTest),
    teardown: Option(TestscriptTeardown),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestScript#resource
pub type TestscriptVersionalgorithm {
  TestscriptVersionalgorithmString(version_algorithm: String)
  TestscriptVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/TestScript#resource
pub type TestscriptOrigin {
  TestscriptOrigin(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    index: Int,
    profile: Coding,
    url: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestScript#resource
pub type TestscriptDestination {
  TestscriptDestination(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    index: Int,
    profile: Coding,
    url: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestScript#resource
pub type TestscriptMetadata {
  TestscriptMetadata(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    link: List(TestscriptMetadataLink),
    capability: List(TestscriptMetadataCapability),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestScript#resource
pub type TestscriptMetadataLink {
  TestscriptMetadataLink(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: String,
    description: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestScript#resource
pub type TestscriptMetadataCapability {
  TestscriptMetadataCapability(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    required: Bool,
    validated: Bool,
    description: Option(String),
    origin: List(Int),
    destination: Option(Int),
    link: List(String),
    capabilities: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestScript#resource
pub type TestscriptScope {
  TestscriptScope(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    artifact: String,
    conformance: Option(Codeableconcept),
    phase: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestScript#resource
pub type TestscriptFixture {
  TestscriptFixture(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    autocreate: Bool,
    autodelete: Bool,
    resource: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestScript#resource
pub type TestscriptVariable {
  TestscriptVariable(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    default_value: Option(String),
    description: Option(String),
    expression: Option(String),
    header_field: Option(String),
    hint: Option(String),
    path: Option(String),
    source_id: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestScript#resource
pub type TestscriptSetup {
  TestscriptSetup(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    action: List(TestscriptSetupAction),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestScript#resource
pub type TestscriptSetupAction {
  TestscriptSetupAction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    operation: Option(TestscriptSetupActionOperation),
    assert_: Option(TestscriptSetupActionAssert),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestScript#resource
pub type TestscriptSetupActionOperation {
  TestscriptSetupActionOperation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Coding),
    resource: Option(String),
    label: Option(String),
    description: Option(String),
    accept: Option(String),
    content_type: Option(String),
    destination: Option(Int),
    encode_request_url: Bool,
    method: Option(String),
    origin: Option(Int),
    params: Option(String),
    request_header: List(TestscriptSetupActionOperationRequestheader),
    request_id: Option(String),
    response_id: Option(String),
    source_id: Option(String),
    target_id: Option(String),
    url: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestScript#resource
pub type TestscriptSetupActionOperationRequestheader {
  TestscriptSetupActionOperationRequestheader(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    field: String,
    value: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestScript#resource
pub type TestscriptSetupActionAssert {
  TestscriptSetupActionAssert(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    label: Option(String),
    description: Option(String),
    direction: Option(String),
    compare_to_source_id: Option(String),
    compare_to_source_expression: Option(String),
    compare_to_source_path: Option(String),
    content_type: Option(String),
    default_manual_completion: Option(String),
    expression: Option(String),
    header_field: Option(String),
    minimum_id: Option(String),
    navigation_links: Option(Bool),
    operator: Option(String),
    path: Option(String),
    request_method: Option(String),
    request_url: Option(String),
    resource: Option(String),
    response: Option(String),
    response_code: Option(String),
    source_id: Option(String),
    stop_test_on_fail: Bool,
    validate_profile_id: Option(String),
    value: Option(String),
    warning_only: Bool,
    requirement: List(TestscriptSetupActionAssertRequirement),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestScript#resource
pub type TestscriptSetupActionAssertRequirement {
  TestscriptSetupActionAssertRequirement(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    link: Option(TestscriptSetupActionAssertRequirementLink),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestScript#resource
pub type TestscriptSetupActionAssertRequirementLink {
  TestscriptSetupActionAssertRequirementLinkUri(link: String)
  TestscriptSetupActionAssertRequirementLinkCanonical(link: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/TestScript#resource
pub type TestscriptTest {
  TestscriptTest(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: Option(String),
    description: Option(String),
    action: List(TestscriptTestAction),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestScript#resource
pub type TestscriptTestAction {
  TestscriptTestAction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    operation: Option(Nil),
    assert_: Option(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestScript#resource
pub type TestscriptTeardown {
  TestscriptTeardown(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    action: List(TestscriptTeardownAction),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestScript#resource
pub type TestscriptTeardownAction {
  TestscriptTeardownAction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    operation: Nil,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Transport#resource
pub type Transport {
  Transport(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    instantiates_canonical: Option(String),
    instantiates_uri: Option(String),
    based_on: List(Reference),
    group_identifier: Option(Identifier),
    part_of: List(Reference),
    status: Option(String),
    status_reason: Option(Codeableconcept),
    intent: String,
    priority: Option(String),
    code: Option(Codeableconcept),
    description: Option(String),
    focus: Option(Reference),
    for: Option(Reference),
    encounter: Option(Reference),
    completion_time: Option(String),
    authored_on: Option(String),
    last_modified: Option(String),
    requester: Option(Reference),
    performer_type: List(Codeableconcept),
    owner: Option(Reference),
    location: Option(Reference),
    insurance: List(Reference),
    note: List(Annotation),
    relevant_history: List(Reference),
    restriction: Option(TransportRestriction),
    input: List(TransportInput),
    output: List(TransportOutput),
    requested_location: Reference,
    current_location: Reference,
    reason: Option(Codeablereference),
    history: Option(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Transport#resource
pub type TransportRestriction {
  TransportRestriction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    repetitions: Option(Int),
    period: Option(Period),
    recipient: List(Reference),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Transport#resource
pub type TransportInput {
  TransportInput(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value: TransportInputValue,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Transport#resource
pub type TransportInputValue {
  TransportInputValueBase64binary(value: String)
  TransportInputValueBoolean(value: Bool)
  TransportInputValueCanonical(value: String)
  TransportInputValueCode(value: String)
  TransportInputValueDate(value: String)
  TransportInputValueDatetime(value: String)
  TransportInputValueDecimal(value: Float)
  TransportInputValueId(value: String)
  TransportInputValueInstant(value: String)
  TransportInputValueInteger(value: Int)
  TransportInputValueInteger64(value: Int)
  TransportInputValueMarkdown(value: String)
  TransportInputValueOid(value: String)
  TransportInputValuePositiveint(value: Int)
  TransportInputValueString(value: String)
  TransportInputValueTime(value: String)
  TransportInputValueUnsignedint(value: Int)
  TransportInputValueUri(value: String)
  TransportInputValueUrl(value: String)
  TransportInputValueUuid(value: String)
  TransportInputValueAddress(value: Address)
  TransportInputValueAge(value: Age)
  TransportInputValueAnnotation(value: Annotation)
  TransportInputValueAttachment(value: Attachment)
  TransportInputValueCodeableconcept(value: Codeableconcept)
  TransportInputValueCodeablereference(value: Codeablereference)
  TransportInputValueCoding(value: Coding)
  TransportInputValueContactpoint(value: Contactpoint)
  TransportInputValueCount(value: Count)
  TransportInputValueDistance(value: Distance)
  TransportInputValueDuration(value: Duration)
  TransportInputValueHumanname(value: Humanname)
  TransportInputValueIdentifier(value: Identifier)
  TransportInputValueMoney(value: Money)
  TransportInputValuePeriod(value: Period)
  TransportInputValueQuantity(value: Quantity)
  TransportInputValueRange(value: Range)
  TransportInputValueRatio(value: Ratio)
  TransportInputValueRatiorange(value: Ratiorange)
  TransportInputValueReference(value: Reference)
  TransportInputValueSampleddata(value: Sampleddata)
  TransportInputValueSignature(value: Signature)
  TransportInputValueTiming(value: Timing)
  TransportInputValueContactdetail(value: Contactdetail)
  TransportInputValueDatarequirement(value: Datarequirement)
  TransportInputValueExpression(value: Expression)
  TransportInputValueParameterdefinition(value: Parameterdefinition)
  TransportInputValueRelatedartifact(value: Relatedartifact)
  TransportInputValueTriggerdefinition(value: Triggerdefinition)
  TransportInputValueUsagecontext(value: Usagecontext)
  TransportInputValueAvailability(value: Availability)
  TransportInputValueExtendedcontactdetail(value: Extendedcontactdetail)
  TransportInputValueDosage(value: Dosage)
  TransportInputValueMeta(value: Meta)
}

///http://hl7.org/fhir/r5/StructureDefinition/Transport#resource
pub type TransportOutput {
  TransportOutput(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value: TransportOutputValue,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Transport#resource
pub type TransportOutputValue {
  TransportOutputValueBase64binary(value: String)
  TransportOutputValueBoolean(value: Bool)
  TransportOutputValueCanonical(value: String)
  TransportOutputValueCode(value: String)
  TransportOutputValueDate(value: String)
  TransportOutputValueDatetime(value: String)
  TransportOutputValueDecimal(value: Float)
  TransportOutputValueId(value: String)
  TransportOutputValueInstant(value: String)
  TransportOutputValueInteger(value: Int)
  TransportOutputValueInteger64(value: Int)
  TransportOutputValueMarkdown(value: String)
  TransportOutputValueOid(value: String)
  TransportOutputValuePositiveint(value: Int)
  TransportOutputValueString(value: String)
  TransportOutputValueTime(value: String)
  TransportOutputValueUnsignedint(value: Int)
  TransportOutputValueUri(value: String)
  TransportOutputValueUrl(value: String)
  TransportOutputValueUuid(value: String)
  TransportOutputValueAddress(value: Address)
  TransportOutputValueAge(value: Age)
  TransportOutputValueAnnotation(value: Annotation)
  TransportOutputValueAttachment(value: Attachment)
  TransportOutputValueCodeableconcept(value: Codeableconcept)
  TransportOutputValueCodeablereference(value: Codeablereference)
  TransportOutputValueCoding(value: Coding)
  TransportOutputValueContactpoint(value: Contactpoint)
  TransportOutputValueCount(value: Count)
  TransportOutputValueDistance(value: Distance)
  TransportOutputValueDuration(value: Duration)
  TransportOutputValueHumanname(value: Humanname)
  TransportOutputValueIdentifier(value: Identifier)
  TransportOutputValueMoney(value: Money)
  TransportOutputValuePeriod(value: Period)
  TransportOutputValueQuantity(value: Quantity)
  TransportOutputValueRange(value: Range)
  TransportOutputValueRatio(value: Ratio)
  TransportOutputValueRatiorange(value: Ratiorange)
  TransportOutputValueReference(value: Reference)
  TransportOutputValueSampleddata(value: Sampleddata)
  TransportOutputValueSignature(value: Signature)
  TransportOutputValueTiming(value: Timing)
  TransportOutputValueContactdetail(value: Contactdetail)
  TransportOutputValueDatarequirement(value: Datarequirement)
  TransportOutputValueExpression(value: Expression)
  TransportOutputValueParameterdefinition(value: Parameterdefinition)
  TransportOutputValueRelatedartifact(value: Relatedartifact)
  TransportOutputValueTriggerdefinition(value: Triggerdefinition)
  TransportOutputValueUsagecontext(value: Usagecontext)
  TransportOutputValueAvailability(value: Availability)
  TransportOutputValueExtendedcontactdetail(value: Extendedcontactdetail)
  TransportOutputValueDosage(value: Dosage)
  TransportOutputValueMeta(value: Meta)
}

///http://hl7.org/fhir/r5/StructureDefinition/ValueSet#resource
pub type Valueset {
  Valueset(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: Option(String),
    identifier: List(Identifier),
    version: Option(String),
    version_algorithm: Option(ValuesetVersionalgorithm),
    name: Option(String),
    title: Option(String),
    status: String,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    immutable: Option(Bool),
    purpose: Option(String),
    copyright: Option(String),
    copyright_label: Option(String),
    approval_date: Option(String),
    last_review_date: Option(String),
    effective_period: Option(Period),
    topic: List(Codeableconcept),
    author: List(Contactdetail),
    editor: List(Contactdetail),
    reviewer: List(Contactdetail),
    endorser: List(Contactdetail),
    related_artifact: List(Relatedartifact),
    compose: Option(ValuesetCompose),
    expansion: Option(ValuesetExpansion),
    scope: Option(ValuesetScope),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ValueSet#resource
pub type ValuesetVersionalgorithm {
  ValuesetVersionalgorithmString(version_algorithm: String)
  ValuesetVersionalgorithmCoding(version_algorithm: Coding)
}

///http://hl7.org/fhir/r5/StructureDefinition/ValueSet#resource
pub type ValuesetCompose {
  ValuesetCompose(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    locked_date: Option(String),
    inactive: Option(Bool),
    include: List(ValuesetComposeInclude),
    exclude: List(Nil),
    property: List(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ValueSet#resource
pub type ValuesetComposeInclude {
  ValuesetComposeInclude(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    system: Option(String),
    version: Option(String),
    concept: List(ValuesetComposeIncludeConcept),
    filter: List(ValuesetComposeIncludeFilter),
    value_set: List(String),
    copyright: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ValueSet#resource
pub type ValuesetComposeIncludeConcept {
  ValuesetComposeIncludeConcept(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    display: Option(String),
    designation: List(ValuesetComposeIncludeConceptDesignation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ValueSet#resource
pub type ValuesetComposeIncludeConceptDesignation {
  ValuesetComposeIncludeConceptDesignation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    language: Option(String),
    use_: Option(Coding),
    additional_use: List(Coding),
    value: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ValueSet#resource
pub type ValuesetComposeIncludeFilter {
  ValuesetComposeIncludeFilter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    property: String,
    op: String,
    value: String,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ValueSet#resource
pub type ValuesetExpansion {
  ValuesetExpansion(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Option(String),
    next: Option(String),
    timestamp: String,
    total: Option(Int),
    offset: Option(Int),
    parameter: List(ValuesetExpansionParameter),
    property: List(ValuesetExpansionProperty),
    contains: List(ValuesetExpansionContains),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ValueSet#resource
pub type ValuesetExpansionParameter {
  ValuesetExpansionParameter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    value: Option(ValuesetExpansionParameterValue),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ValueSet#resource
pub type ValuesetExpansionParameterValue {
  ValuesetExpansionParameterValueString(value: String)
  ValuesetExpansionParameterValueBoolean(value: Bool)
  ValuesetExpansionParameterValueInteger(value: Int)
  ValuesetExpansionParameterValueDecimal(value: Float)
  ValuesetExpansionParameterValueUri(value: String)
  ValuesetExpansionParameterValueCode(value: String)
  ValuesetExpansionParameterValueDatetime(value: String)
}

///http://hl7.org/fhir/r5/StructureDefinition/ValueSet#resource
pub type ValuesetExpansionProperty {
  ValuesetExpansionProperty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    uri: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ValueSet#resource
pub type ValuesetExpansionContains {
  ValuesetExpansionContains(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    system: Option(String),
    abstract: Option(Bool),
    inactive: Option(Bool),
    version: Option(String),
    code: Option(String),
    display: Option(String),
    designation: List(Nil),
    property: List(ValuesetExpansionContainsProperty),
    contains: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ValueSet#resource
pub type ValuesetExpansionContainsProperty {
  ValuesetExpansionContainsProperty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    value: ValuesetExpansionContainsPropertyValue,
    sub_property: List(ValuesetExpansionContainsPropertySubproperty),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ValueSet#resource
pub type ValuesetExpansionContainsPropertyValue {
  ValuesetExpansionContainsPropertyValueCode(value: String)
  ValuesetExpansionContainsPropertyValueCoding(value: Coding)
  ValuesetExpansionContainsPropertyValueString(value: String)
  ValuesetExpansionContainsPropertyValueInteger(value: Int)
  ValuesetExpansionContainsPropertyValueBoolean(value: Bool)
  ValuesetExpansionContainsPropertyValueDatetime(value: String)
  ValuesetExpansionContainsPropertyValueDecimal(value: Float)
}

///http://hl7.org/fhir/r5/StructureDefinition/ValueSet#resource
pub type ValuesetExpansionContainsPropertySubproperty {
  ValuesetExpansionContainsPropertySubproperty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    value: ValuesetExpansionContainsPropertySubpropertyValue,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ValueSet#resource
pub type ValuesetExpansionContainsPropertySubpropertyValue {
  ValuesetExpansionContainsPropertySubpropertyValueCode(value: String)
  ValuesetExpansionContainsPropertySubpropertyValueCoding(value: Coding)
  ValuesetExpansionContainsPropertySubpropertyValueString(value: String)
  ValuesetExpansionContainsPropertySubpropertyValueInteger(value: Int)
  ValuesetExpansionContainsPropertySubpropertyValueBoolean(value: Bool)
  ValuesetExpansionContainsPropertySubpropertyValueDatetime(value: String)
  ValuesetExpansionContainsPropertySubpropertyValueDecimal(value: Float)
}

///http://hl7.org/fhir/r5/StructureDefinition/ValueSet#resource
pub type ValuesetScope {
  ValuesetScope(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    inclusion_criteria: Option(String),
    exclusion_criteria: Option(String),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/VerificationResult#resource
pub type Verificationresult {
  Verificationresult(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    target: List(Reference),
    target_location: List(String),
    need: Option(Codeableconcept),
    status: String,
    status_date: Option(String),
    validation_type: Option(Codeableconcept),
    validation_process: List(Codeableconcept),
    frequency: Option(Timing),
    last_performed: Option(String),
    next_scheduled: Option(String),
    failure_action: Option(Codeableconcept),
    primary_source: List(VerificationresultPrimarysource),
    attestation: Option(VerificationresultAttestation),
    validator: List(VerificationresultValidator),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/VerificationResult#resource
pub type VerificationresultPrimarysource {
  VerificationresultPrimarysource(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    who: Option(Reference),
    type_: List(Codeableconcept),
    communication_method: List(Codeableconcept),
    validation_status: Option(Codeableconcept),
    validation_date: Option(String),
    can_push_updates: Option(Codeableconcept),
    push_type_available: List(Codeableconcept),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/VerificationResult#resource
pub type VerificationresultAttestation {
  VerificationresultAttestation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    who: Option(Reference),
    on_behalf_of: Option(Reference),
    communication_method: Option(Codeableconcept),
    date: Option(String),
    source_identity_certificate: Option(String),
    proxy_identity_certificate: Option(String),
    proxy_signature: Option(Signature),
    source_signature: Option(Signature),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/VerificationResult#resource
pub type VerificationresultValidator {
  VerificationresultValidator(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    organization: Reference,
    identity_certificate: Option(String),
    attestation_signature: Option(Signature),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/VisionPrescription#resource
pub type Visionprescription {
  Visionprescription(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    status: String,
    created: String,
    patient: Reference,
    encounter: Option(Reference),
    date_written: String,
    prescriber: Reference,
    lens_specification: List(VisionprescriptionLensspecification),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/VisionPrescription#resource
pub type VisionprescriptionLensspecification {
  VisionprescriptionLensspecification(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    product: Codeableconcept,
    eye: String,
    sphere: Option(Float),
    cylinder: Option(Float),
    axis: Option(Int),
    prism: List(VisionprescriptionLensspecificationPrism),
    add: Option(Float),
    power: Option(Float),
    back_curve: Option(Float),
    diameter: Option(Float),
    duration: Option(Quantity),
    color: Option(String),
    brand: Option(String),
    note: List(Annotation),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/VisionPrescription#resource
pub type VisionprescriptionLensspecificationPrism {
  VisionprescriptionLensspecificationPrism(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    amount: Float,
    base: String,
  )
}
