////FHIR r4b types
////https://hl7.org/fhir/r4b

import gleam/option.{type Option, None}
import r4bvaluesets

///http://hl7.org/fhir/r4b/StructureDefinition/Element#resource
pub type Element {
  Element(id: Option(String), extension: List(Extension))
}

pub fn element_new() -> Element {
  Element(extension: [], id: None)
}

///http://hl7.org/fhir/r4b/StructureDefinition/Address#resource
pub type Address {
  Address(
    id: Option(String),
    extension: List(Extension),
    use_: Option(r4bvaluesets.Addressuse),
    type_: Option(r4bvaluesets.Addresstype),
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

pub fn address_new() -> Address {
  Address(
    period: None,
    country: None,
    postal_code: None,
    state: None,
    district: None,
    city: None,
    line: [],
    text: None,
    type_: None,
    use_: None,
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Age#resource
pub type Age {
  Age(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(r4bvaluesets.Quantitycomparator),
    unit: Option(String),
    system: Option(String),
    code: Option(String),
  )
}

pub fn age_new() -> Age {
  Age(
    code: None,
    system: None,
    unit: None,
    comparator: None,
    value: None,
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Annotation#resource
pub type Annotation {
  Annotation(
    id: Option(String),
    extension: List(Extension),
    author: Option(AnnotationAuthor),
    time: Option(String),
    text: String,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Annotation#resource
pub type AnnotationAuthor {
  AnnotationAuthorReference(author: Reference)
  AnnotationAuthorString(author: String)
}

pub fn annotation_new(text) -> Annotation {
  Annotation(text:, time: None, author: None, extension: [], id: None)
}

///http://hl7.org/fhir/r4b/StructureDefinition/Attachment#resource
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

pub fn attachment_new() -> Attachment {
  Attachment(
    creation: None,
    title: None,
    hash: None,
    size: None,
    url: None,
    data: None,
    language: None,
    content_type: None,
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CodeableConcept#resource
pub type Codeableconcept {
  Codeableconcept(
    id: Option(String),
    extension: List(Extension),
    coding: List(Coding),
    text: Option(String),
  )
}

pub fn codeableconcept_new() -> Codeableconcept {
  Codeableconcept(text: None, coding: [], extension: [], id: None)
}

///http://hl7.org/fhir/r4b/StructureDefinition/CodeableReference#resource
pub type Codeablereference {
  Codeablereference(
    id: Option(String),
    extension: List(Extension),
    concept: Option(Codeableconcept),
    reference: Option(Reference),
  )
}

pub fn codeablereference_new() -> Codeablereference {
  Codeablereference(reference: None, concept: None, extension: [], id: None)
}

///http://hl7.org/fhir/r4b/StructureDefinition/Coding#resource
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

pub fn coding_new() -> Coding {
  Coding(
    user_selected: None,
    display: None,
    code: None,
    version: None,
    system: None,
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ContactDetail#resource
pub type Contactdetail {
  Contactdetail(
    id: Option(String),
    extension: List(Extension),
    name: Option(String),
    telecom: List(Contactpoint),
  )
}

pub fn contactdetail_new() -> Contactdetail {
  Contactdetail(telecom: [], name: None, extension: [], id: None)
}

///http://hl7.org/fhir/r4b/StructureDefinition/ContactPoint#resource
pub type Contactpoint {
  Contactpoint(
    id: Option(String),
    extension: List(Extension),
    system: Option(r4bvaluesets.Contactpointsystem),
    value: Option(String),
    use_: Option(r4bvaluesets.Contactpointuse),
    rank: Option(Int),
    period: Option(Period),
  )
}

pub fn contactpoint_new() -> Contactpoint {
  Contactpoint(
    period: None,
    rank: None,
    use_: None,
    value: None,
    system: None,
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Contributor#resource
pub type Contributor {
  Contributor(
    id: Option(String),
    extension: List(Extension),
    type_: r4bvaluesets.Contributortype,
    name: String,
    contact: List(Contactdetail),
  )
}

pub fn contributor_new(name, type_) -> Contributor {
  Contributor(contact: [], name:, type_:, extension: [], id: None)
}

///http://hl7.org/fhir/r4b/StructureDefinition/Count#resource
pub type Count {
  Count(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(r4bvaluesets.Quantitycomparator),
    unit: Option(String),
    system: Option(String),
    code: Option(String),
  )
}

pub fn count_new() -> Count {
  Count(
    code: None,
    system: None,
    unit: None,
    comparator: None,
    value: None,
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DataRequirement#resource
pub type Datarequirement {
  Datarequirement(
    id: Option(String),
    extension: List(Extension),
    type_: r4bvaluesets.Alltypes,
    profile: List(String),
    subject: Option(DatarequirementSubject),
    must_support: List(String),
    code_filter: List(Element),
    date_filter: List(Element),
    limit: Option(Int),
    sort: List(Element),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DataRequirement#resource
pub type DatarequirementSubject {
  DatarequirementSubjectCodeableconcept(subject: Codeableconcept)
  DatarequirementSubjectReference(subject: Reference)
}

pub fn datarequirement_new(type_) -> Datarequirement {
  Datarequirement(
    sort: [],
    limit: None,
    date_filter: [],
    code_filter: [],
    must_support: [],
    subject: None,
    profile: [],
    type_:,
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Distance#resource
pub type Distance {
  Distance(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(r4bvaluesets.Quantitycomparator),
    unit: Option(String),
    system: Option(String),
    code: Option(String),
  )
}

pub fn distance_new() -> Distance {
  Distance(
    code: None,
    system: None,
    unit: None,
    comparator: None,
    value: None,
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Dosage#resource
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
    as_needed: Option(DosageAsneeded),
    site: Option(Codeableconcept),
    route: Option(Codeableconcept),
    method: Option(Codeableconcept),
    dose_and_rate: List(Element),
    max_dose_per_period: Option(Ratio),
    max_dose_per_administration: Option(Quantity),
    max_dose_per_lifetime: Option(Quantity),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Dosage#resource
pub type DosageAsneeded {
  DosageAsneededBoolean(as_needed: Bool)
  DosageAsneededCodeableconcept(as_needed: Codeableconcept)
}

pub fn dosage_new() -> Dosage {
  Dosage(
    max_dose_per_lifetime: None,
    max_dose_per_administration: None,
    max_dose_per_period: None,
    dose_and_rate: [],
    method: None,
    route: None,
    site: None,
    as_needed: None,
    timing: None,
    patient_instruction: None,
    additional_instruction: [],
    text: None,
    sequence: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Duration#resource
pub type Duration {
  Duration(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(r4bvaluesets.Quantitycomparator),
    unit: Option(String),
    system: Option(String),
    code: Option(String),
  )
}

pub fn duration_new() -> Duration {
  Duration(
    code: None,
    system: None,
    unit: None,
    comparator: None,
    value: None,
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ElementDefinition#resource
pub type Elementdefinition {
  Elementdefinition(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    path: String,
    representation: List(r4bvaluesets.Propertyrepresentation),
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
    must_support: Option(Bool),
    is_modifier: Option(Bool),
    is_modifier_reason: Option(String),
    is_summary: Option(Bool),
    binding: Option(Element),
    mapping: List(Element),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ElementDefinition#resource
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
  ElementdefinitionDefaultvalueContributor(default_value: Contributor)
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
  ElementdefinitionDefaultvalueDosage(default_value: Dosage)
}

///http://hl7.org/fhir/r4b/StructureDefinition/ElementDefinition#resource
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
  ElementdefinitionFixedContributor(fixed: Contributor)
  ElementdefinitionFixedDatarequirement(fixed: Datarequirement)
  ElementdefinitionFixedExpression(fixed: Expression)
  ElementdefinitionFixedParameterdefinition(fixed: Parameterdefinition)
  ElementdefinitionFixedRelatedartifact(fixed: Relatedartifact)
  ElementdefinitionFixedTriggerdefinition(fixed: Triggerdefinition)
  ElementdefinitionFixedUsagecontext(fixed: Usagecontext)
  ElementdefinitionFixedDosage(fixed: Dosage)
}

///http://hl7.org/fhir/r4b/StructureDefinition/ElementDefinition#resource
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
  ElementdefinitionPatternContributor(pattern: Contributor)
  ElementdefinitionPatternDatarequirement(pattern: Datarequirement)
  ElementdefinitionPatternExpression(pattern: Expression)
  ElementdefinitionPatternParameterdefinition(pattern: Parameterdefinition)
  ElementdefinitionPatternRelatedartifact(pattern: Relatedartifact)
  ElementdefinitionPatternTriggerdefinition(pattern: Triggerdefinition)
  ElementdefinitionPatternUsagecontext(pattern: Usagecontext)
  ElementdefinitionPatternDosage(pattern: Dosage)
}

///http://hl7.org/fhir/r4b/StructureDefinition/ElementDefinition#resource
pub type ElementdefinitionMinvalue {
  ElementdefinitionMinvalueDate(min_value: String)
  ElementdefinitionMinvalueDatetime(min_value: String)
  ElementdefinitionMinvalueInstant(min_value: String)
  ElementdefinitionMinvalueTime(min_value: String)
  ElementdefinitionMinvalueDecimal(min_value: Float)
  ElementdefinitionMinvalueInteger(min_value: Int)
  ElementdefinitionMinvaluePositiveint(min_value: Int)
  ElementdefinitionMinvalueUnsignedint(min_value: Int)
  ElementdefinitionMinvalueQuantity(min_value: Quantity)
}

///http://hl7.org/fhir/r4b/StructureDefinition/ElementDefinition#resource
pub type ElementdefinitionMaxvalue {
  ElementdefinitionMaxvalueDate(max_value: String)
  ElementdefinitionMaxvalueDatetime(max_value: String)
  ElementdefinitionMaxvalueInstant(max_value: String)
  ElementdefinitionMaxvalueTime(max_value: String)
  ElementdefinitionMaxvalueDecimal(max_value: Float)
  ElementdefinitionMaxvalueInteger(max_value: Int)
  ElementdefinitionMaxvaluePositiveint(max_value: Int)
  ElementdefinitionMaxvalueUnsignedint(max_value: Int)
  ElementdefinitionMaxvalueQuantity(max_value: Quantity)
}

pub fn elementdefinition_new(path) -> Elementdefinition {
  Elementdefinition(
    mapping: [],
    binding: None,
    is_summary: None,
    is_modifier_reason: None,
    is_modifier: None,
    must_support: None,
    constraint: [],
    condition: [],
    max_length: None,
    max_value: None,
    min_value: None,
    example: [],
    pattern: None,
    fixed: None,
    order_meaning: None,
    meaning_when_missing: None,
    default_value: None,
    type_: [],
    content_reference: None,
    base: None,
    max: None,
    min: None,
    alias: [],
    requirements: None,
    comment: None,
    definition: None,
    short: None,
    slicing: None,
    code: [],
    label: None,
    slice_is_constraining: None,
    slice_name: None,
    representation: [],
    path:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Expression#resource
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

pub fn expression_new(language) -> Expression {
  Expression(
    reference: None,
    expression: None,
    language:,
    name: None,
    description: None,
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Extension#resource
pub type Extension {
  Extension(
    id: Option(String),
    extension: List(Extension),
    url: String,
    value: Option(ExtensionValue),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Extension#resource
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
  ExtensionValueContributor(value: Contributor)
  ExtensionValueDatarequirement(value: Datarequirement)
  ExtensionValueExpression(value: Expression)
  ExtensionValueParameterdefinition(value: Parameterdefinition)
  ExtensionValueRelatedartifact(value: Relatedartifact)
  ExtensionValueTriggerdefinition(value: Triggerdefinition)
  ExtensionValueUsagecontext(value: Usagecontext)
  ExtensionValueDosage(value: Dosage)
}

pub fn extension_new(url) -> Extension {
  Extension(value: None, url:, extension: [], id: None)
}

///http://hl7.org/fhir/r4b/StructureDefinition/HumanName#resource
pub type Humanname {
  Humanname(
    id: Option(String),
    extension: List(Extension),
    use_: Option(r4bvaluesets.Nameuse),
    text: Option(String),
    family: Option(String),
    given: List(String),
    prefix: List(String),
    suffix: List(String),
    period: Option(Period),
  )
}

pub fn humanname_new() -> Humanname {
  Humanname(
    period: None,
    suffix: [],
    prefix: [],
    given: [],
    family: None,
    text: None,
    use_: None,
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Identifier#resource
pub type Identifier {
  Identifier(
    id: Option(String),
    extension: List(Extension),
    use_: Option(r4bvaluesets.Identifieruse),
    type_: Option(Codeableconcept),
    system: Option(String),
    value: Option(String),
    period: Option(Period),
    assigner: Option(Reference),
  )
}

pub fn identifier_new() -> Identifier {
  Identifier(
    assigner: None,
    period: None,
    value: None,
    system: None,
    type_: None,
    use_: None,
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MarketingStatus#resource
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

pub fn marketingstatus_new(status) -> Marketingstatus {
  Marketingstatus(
    restore_date: None,
    date_range: None,
    status:,
    jurisdiction: None,
    country: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Meta#resource
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

pub fn meta_new() -> Meta {
  Meta(
    tag: [],
    security: [],
    profile: [],
    source: None,
    last_updated: None,
    version_id: None,
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Money#resource
pub type Money {
  Money(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    currency: Option(String),
  )
}

pub fn money_new() -> Money {
  Money(currency: None, value: None, extension: [], id: None)
}

///http://hl7.org/fhir/r4b/StructureDefinition/Narrative#resource
pub type Narrative {
  Narrative(
    id: Option(String),
    extension: List(Extension),
    status: r4bvaluesets.Narrativestatus,
    div: String,
  )
}

pub fn narrative_new(div, status) -> Narrative {
  Narrative(div:, status:, extension: [], id: None)
}

///http://hl7.org/fhir/r4b/StructureDefinition/ParameterDefinition#resource
pub type Parameterdefinition {
  Parameterdefinition(
    id: Option(String),
    extension: List(Extension),
    name: Option(String),
    use_: r4bvaluesets.Operationparameteruse,
    min: Option(Int),
    max: Option(String),
    documentation: Option(String),
    type_: r4bvaluesets.Alltypes,
    profile: Option(String),
  )
}

pub fn parameterdefinition_new(type_, use_) -> Parameterdefinition {
  Parameterdefinition(
    profile: None,
    type_:,
    documentation: None,
    max: None,
    min: None,
    use_:,
    name: None,
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Period#resource
pub type Period {
  Period(
    id: Option(String),
    extension: List(Extension),
    start: Option(String),
    end: Option(String),
  )
}

pub fn period_new() -> Period {
  Period(end: None, start: None, extension: [], id: None)
}

///http://hl7.org/fhir/r4b/StructureDefinition/Population#resource
pub type Population {
  Population(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    age: Option(PopulationAge),
    gender: Option(Codeableconcept),
    race: Option(Codeableconcept),
    physiological_condition: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Population#resource
pub type PopulationAge {
  PopulationAgeRange(age: Range)
  PopulationAgeCodeableconcept(age: Codeableconcept)
}

pub fn population_new() -> Population {
  Population(
    physiological_condition: None,
    race: None,
    gender: None,
    age: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ProdCharacteristic#resource
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

pub fn prodcharacteristic_new() -> Prodcharacteristic {
  Prodcharacteristic(
    scoring: None,
    image: [],
    imprint: [],
    color: [],
    shape: None,
    external_diameter: None,
    nominal_volume: None,
    weight: None,
    depth: None,
    width: None,
    height: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ProductShelfLife#resource
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

pub fn productshelflife_new(period, type_) -> Productshelflife {
  Productshelflife(
    special_precautions_for_storage: [],
    period:,
    type_:,
    identifier: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Quantity#resource
pub type Quantity {
  Quantity(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(r4bvaluesets.Quantitycomparator),
    unit: Option(String),
    system: Option(String),
    code: Option(String),
  )
}

pub fn quantity_new() -> Quantity {
  Quantity(
    code: None,
    system: None,
    unit: None,
    comparator: None,
    value: None,
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Range#resource
pub type Range {
  Range(
    id: Option(String),
    extension: List(Extension),
    low: Option(Quantity),
    high: Option(Quantity),
  )
}

pub fn range_new() -> Range {
  Range(high: None, low: None, extension: [], id: None)
}

///http://hl7.org/fhir/r4b/StructureDefinition/Ratio#resource
pub type Ratio {
  Ratio(
    id: Option(String),
    extension: List(Extension),
    numerator: Option(Quantity),
    denominator: Option(Quantity),
  )
}

pub fn ratio_new() -> Ratio {
  Ratio(denominator: None, numerator: None, extension: [], id: None)
}

///http://hl7.org/fhir/r4b/StructureDefinition/RatioRange#resource
pub type Ratiorange {
  Ratiorange(
    id: Option(String),
    extension: List(Extension),
    low_numerator: Option(Quantity),
    high_numerator: Option(Quantity),
    denominator: Option(Quantity),
  )
}

pub fn ratiorange_new() -> Ratiorange {
  Ratiorange(
    denominator: None,
    high_numerator: None,
    low_numerator: None,
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Reference#resource
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

pub fn reference_new() -> Reference {
  Reference(
    display: None,
    identifier: None,
    type_: None,
    reference: None,
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/RelatedArtifact#resource
pub type Relatedartifact {
  Relatedartifact(
    id: Option(String),
    extension: List(Extension),
    type_: r4bvaluesets.Relatedartifacttype,
    label: Option(String),
    display: Option(String),
    citation: Option(String),
    url: Option(String),
    document: Option(Attachment),
    resource: Option(String),
  )
}

pub fn relatedartifact_new(type_) -> Relatedartifact {
  Relatedartifact(
    resource: None,
    document: None,
    url: None,
    citation: None,
    display: None,
    label: None,
    type_:,
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SampledData#resource
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

pub fn sampleddata_new(dimensions, period, origin) -> Sampleddata {
  Sampleddata(
    data: None,
    dimensions:,
    upper_limit: None,
    lower_limit: None,
    factor: None,
    period:,
    origin:,
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Signature#resource
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

pub fn signature_new(who, when) -> Signature {
  Signature(
    data: None,
    sig_format: None,
    target_format: None,
    on_behalf_of: None,
    who:,
    when:,
    type_: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Timing#resource
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

pub fn timing_new() -> Timing {
  Timing(
    code: None,
    repeat: None,
    event: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TriggerDefinition#resource
pub type Triggerdefinition {
  Triggerdefinition(
    id: Option(String),
    extension: List(Extension),
    type_: r4bvaluesets.Triggertype,
    name: Option(String),
    timing: Option(TriggerdefinitionTiming),
    data: List(Datarequirement),
    condition: Option(Expression),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TriggerDefinition#resource
pub type TriggerdefinitionTiming {
  TriggerdefinitionTimingTiming(timing: Timing)
  TriggerdefinitionTimingReference(timing: Reference)
  TriggerdefinitionTimingDate(timing: String)
  TriggerdefinitionTimingDatetime(timing: String)
}

pub fn triggerdefinition_new(type_) -> Triggerdefinition {
  Triggerdefinition(
    condition: None,
    data: [],
    timing: None,
    name: None,
    type_:,
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/UsageContext#resource
pub type Usagecontext {
  Usagecontext(
    id: Option(String),
    extension: List(Extension),
    code: Coding,
    value: UsagecontextValue,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/UsageContext#resource
pub type UsagecontextValue {
  UsagecontextValueCodeableconcept(value: Codeableconcept)
  UsagecontextValueQuantity(value: Quantity)
  UsagecontextValueRange(value: Range)
  UsagecontextValueReference(value: Reference)
}

pub fn usagecontext_new(value, code) -> Usagecontext {
  Usagecontext(value:, code:, extension: [], id: None)
}

///http://hl7.org/fhir/r4b/StructureDefinition/MoneyQuantity#resource
pub type Moneyquantity {
  Moneyquantity(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(r4bvaluesets.Quantitycomparator),
    unit: Option(String),
    system: Option(String),
    code: Option(String),
  )
}

pub fn moneyquantity_new() -> Moneyquantity {
  Moneyquantity(
    code: None,
    system: None,
    unit: None,
    comparator: None,
    value: None,
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SimpleQuantity#resource
pub type Simplequantity {
  Simplequantity(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    unit: Option(String),
    system: Option(String),
    code: Option(String),
  )
}

pub fn simplequantity_new() -> Simplequantity {
  Simplequantity(
    code: None,
    system: None,
    unit: None,
    value: None,
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Resource#resource
pub type Resource {
  Resource(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
  )
}

pub fn resource_new() -> Resource {
  Resource(language: None, implicit_rules: None, meta: None, id: None)
}

///http://hl7.org/fhir/r4b/StructureDefinition/Account#resource
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
    status: r4bvaluesets.Accountstatus,
    type_: Option(Codeableconcept),
    name: Option(String),
    subject: List(Reference),
    service_period: Option(Period),
    coverage: List(AccountCoverage),
    owner: Option(Reference),
    description: Option(String),
    guarantor: List(AccountGuarantor),
    part_of: Option(Reference),
  )
}

pub fn account_new(status) -> Account {
  Account(
    part_of: None,
    guarantor: [],
    description: None,
    owner: None,
    coverage: [],
    service_period: None,
    subject: [],
    name: None,
    type_: None,
    status:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Account#resource
pub type AccountCoverage {
  AccountCoverage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    coverage: Reference,
    priority: Option(Int),
  )
}

pub fn account_coverage_new(coverage) -> AccountCoverage {
  AccountCoverage(
    priority: None,
    coverage:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Account#resource
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

pub fn account_guarantor_new(party) -> AccountGuarantor {
  AccountGuarantor(
    period: None,
    on_hold: None,
    party:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ActivityDefinition#resource
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
    name: Option(String),
    title: Option(String),
    subtitle: Option(String),
    status: r4bvaluesets.Publicationstatus,
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
    kind: Option(r4bvaluesets.Requestresourcetypes),
    profile: Option(String),
    code: Option(Codeableconcept),
    intent: Option(r4bvaluesets.Requestintent),
    priority: Option(r4bvaluesets.Requestpriority),
    do_not_perform: Option(Bool),
    timing: Option(ActivitydefinitionTiming),
    location: Option(Reference),
    participant: List(ActivitydefinitionParticipant),
    product: Option(ActivitydefinitionProduct),
    quantity: Option(Quantity),
    dosage: List(Dosage),
    body_site: List(Codeableconcept),
    specimen_requirement: List(Reference),
    observation_requirement: List(Reference),
    observation_result_requirement: List(Reference),
    transform: Option(String),
    dynamic_value: List(ActivitydefinitionDynamicvalue),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ActivityDefinition#resource
pub type ActivitydefinitionSubject {
  ActivitydefinitionSubjectCodeableconcept(subject: Codeableconcept)
  ActivitydefinitionSubjectReference(subject: Reference)
  ActivitydefinitionSubjectCanonical(subject: String)
}

///http://hl7.org/fhir/r4b/StructureDefinition/ActivityDefinition#resource
pub type ActivitydefinitionTiming {
  ActivitydefinitionTimingTiming(timing: Timing)
  ActivitydefinitionTimingDatetime(timing: String)
  ActivitydefinitionTimingAge(timing: Age)
  ActivitydefinitionTimingPeriod(timing: Period)
  ActivitydefinitionTimingRange(timing: Range)
  ActivitydefinitionTimingDuration(timing: Duration)
}

///http://hl7.org/fhir/r4b/StructureDefinition/ActivityDefinition#resource
pub type ActivitydefinitionProduct {
  ActivitydefinitionProductReference(product: Reference)
  ActivitydefinitionProductCodeableconcept(product: Codeableconcept)
}

pub fn activitydefinition_new(status) -> Activitydefinition {
  Activitydefinition(
    dynamic_value: [],
    transform: None,
    observation_result_requirement: [],
    observation_requirement: [],
    specimen_requirement: [],
    body_site: [],
    dosage: [],
    quantity: None,
    product: None,
    participant: [],
    location: None,
    timing: None,
    do_not_perform: None,
    priority: None,
    intent: None,
    code: None,
    profile: None,
    kind: None,
    library: [],
    related_artifact: [],
    endorser: [],
    reviewer: [],
    editor: [],
    author: [],
    topic: [],
    effective_period: None,
    last_review_date: None,
    approval_date: None,
    copyright: None,
    usage: None,
    purpose: None,
    jurisdiction: [],
    use_context: [],
    description: None,
    contact: [],
    publisher: None,
    date: None,
    subject: None,
    experimental: None,
    status:,
    subtitle: None,
    title: None,
    name: None,
    version: None,
    identifier: [],
    url: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ActivityDefinition#resource
pub type ActivitydefinitionParticipant {
  ActivitydefinitionParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r4bvaluesets.Actionparticipanttype,
    role: Option(Codeableconcept),
  )
}

pub fn activitydefinition_participant_new(
  type_,
) -> ActivitydefinitionParticipant {
  ActivitydefinitionParticipant(
    role: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ActivityDefinition#resource
pub type ActivitydefinitionDynamicvalue {
  ActivitydefinitionDynamicvalue(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    path: String,
    expression: Expression,
  )
}

pub fn activitydefinition_dynamicvalue_new(
  expression,
  path,
) -> ActivitydefinitionDynamicvalue {
  ActivitydefinitionDynamicvalue(
    expression:,
    path:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/AdministrableProductDefinition#resource
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
    status: r4bvaluesets.Publicationstatus,
    form_of: List(Reference),
    administrable_dose_form: Option(Codeableconcept),
    unit_of_presentation: Option(Codeableconcept),
    produced_from: List(Reference),
    ingredient: List(Codeableconcept),
    device: Option(Reference),
    property: List(AdministrableproductdefinitionProperty),
    route_of_administration: List(
      AdministrableproductdefinitionRouteofadministration,
    ),
  )
}

pub fn administrableproductdefinition_new(
  status,
) -> Administrableproductdefinition {
  Administrableproductdefinition(
    route_of_administration: [],
    property: [],
    device: None,
    ingredient: [],
    produced_from: [],
    unit_of_presentation: None,
    administrable_dose_form: None,
    form_of: [],
    status:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/AdministrableProductDefinition#resource
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

///http://hl7.org/fhir/r4b/StructureDefinition/AdministrableProductDefinition#resource
pub type AdministrableproductdefinitionPropertyValue {
  AdministrableproductdefinitionPropertyValueCodeableconcept(
    value: Codeableconcept,
  )
  AdministrableproductdefinitionPropertyValueQuantity(value: Quantity)
  AdministrableproductdefinitionPropertyValueDate(value: String)
  AdministrableproductdefinitionPropertyValueBoolean(value: Bool)
  AdministrableproductdefinitionPropertyValueAttachment(value: Attachment)
}

pub fn administrableproductdefinition_property_new(
  type_,
) -> AdministrableproductdefinitionProperty {
  AdministrableproductdefinitionProperty(
    status: None,
    value: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/AdministrableProductDefinition#resource
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

pub fn administrableproductdefinition_routeofadministration_new(
  code,
) -> AdministrableproductdefinitionRouteofadministration {
  AdministrableproductdefinitionRouteofadministration(
    target_species: [],
    max_treatment_period: None,
    max_dose_per_treatment_period: None,
    max_dose_per_day: None,
    max_single_dose: None,
    first_dose: None,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/AdministrableProductDefinition#resource
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

pub fn administrableproductdefinition_routeofadministration_targetspecies_new(
  code,
) -> AdministrableproductdefinitionRouteofadministrationTargetspecies {
  AdministrableproductdefinitionRouteofadministrationTargetspecies(
    withdrawal_period: [],
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/AdministrableProductDefinition#resource
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

pub fn administrableproductdefinition_routeofadministration_targetspecies_withdrawalperiod_new(
  value,
  tissue,
) -> AdministrableproductdefinitionRouteofadministrationTargetspeciesWithdrawalperiod {
  AdministrableproductdefinitionRouteofadministrationTargetspeciesWithdrawalperiod(
    supporting_information: None,
    value:,
    tissue:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/AdverseEvent#resource
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
    identifier: Option(Identifier),
    actuality: r4bvaluesets.Adverseeventactuality,
    category: List(Codeableconcept),
    event: Option(Codeableconcept),
    subject: Reference,
    encounter: Option(Reference),
    date: Option(String),
    detected: Option(String),
    recorded_date: Option(String),
    resulting_condition: List(Reference),
    location: Option(Reference),
    seriousness: Option(Codeableconcept),
    severity: Option(Codeableconcept),
    outcome: Option(Codeableconcept),
    recorder: Option(Reference),
    contributor: List(Reference),
    suspect_entity: List(AdverseeventSuspectentity),
    subject_medical_history: List(Reference),
    reference_document: List(Reference),
    study: List(Reference),
  )
}

pub fn adverseevent_new(subject, actuality) -> Adverseevent {
  Adverseevent(
    study: [],
    reference_document: [],
    subject_medical_history: [],
    suspect_entity: [],
    contributor: [],
    recorder: None,
    outcome: None,
    severity: None,
    seriousness: None,
    location: None,
    resulting_condition: [],
    recorded_date: None,
    detected: None,
    date: None,
    encounter: None,
    subject:,
    event: None,
    category: [],
    actuality:,
    identifier: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/AdverseEvent#resource
pub type AdverseeventSuspectentity {
  AdverseeventSuspectentity(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    instance: Reference,
    causality: List(AdverseeventSuspectentityCausality),
  )
}

pub fn adverseevent_suspectentity_new(instance) -> AdverseeventSuspectentity {
  AdverseeventSuspectentity(
    causality: [],
    instance:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/AdverseEvent#resource
pub type AdverseeventSuspectentityCausality {
  AdverseeventSuspectentityCausality(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    assessment: Option(Codeableconcept),
    product_relatedness: Option(String),
    author: Option(Reference),
    method: Option(Codeableconcept),
  )
}

pub fn adverseevent_suspectentity_causality_new() -> AdverseeventSuspectentityCausality {
  AdverseeventSuspectentityCausality(
    method: None,
    author: None,
    product_relatedness: None,
    assessment: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/AllergyIntolerance#resource
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
    type_: Option(r4bvaluesets.Allergyintolerancetype),
    category: List(r4bvaluesets.Allergyintolerancecategory),
    criticality: Option(r4bvaluesets.Allergyintolerancecriticality),
    code: Option(Codeableconcept),
    patient: Reference,
    encounter: Option(Reference),
    onset: Option(AllergyintoleranceOnset),
    recorded_date: Option(String),
    recorder: Option(Reference),
    asserter: Option(Reference),
    last_occurrence: Option(String),
    note: List(Annotation),
    reaction: List(AllergyintoleranceReaction),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/AllergyIntolerance#resource
pub type AllergyintoleranceOnset {
  AllergyintoleranceOnsetDatetime(onset: String)
  AllergyintoleranceOnsetAge(onset: Age)
  AllergyintoleranceOnsetPeriod(onset: Period)
  AllergyintoleranceOnsetRange(onset: Range)
  AllergyintoleranceOnsetString(onset: String)
}

pub fn allergyintolerance_new(patient) -> Allergyintolerance {
  Allergyintolerance(
    reaction: [],
    note: [],
    last_occurrence: None,
    asserter: None,
    recorder: None,
    recorded_date: None,
    onset: None,
    encounter: None,
    patient:,
    code: None,
    criticality: None,
    category: [],
    type_: None,
    verification_status: None,
    clinical_status: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/AllergyIntolerance#resource
pub type AllergyintoleranceReaction {
  AllergyintoleranceReaction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    substance: Option(Codeableconcept),
    manifestation: List(Codeableconcept),
    description: Option(String),
    onset: Option(String),
    severity: Option(r4bvaluesets.Reactioneventseverity),
    exposure_route: Option(Codeableconcept),
    note: List(Annotation),
  )
}

pub fn allergyintolerance_reaction_new() -> AllergyintoleranceReaction {
  AllergyintoleranceReaction(
    note: [],
    exposure_route: None,
    severity: None,
    onset: None,
    description: None,
    manifestation: [],
    substance: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Appointment#resource
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
    status: r4bvaluesets.Appointmentstatus,
    cancelation_reason: Option(Codeableconcept),
    service_category: List(Codeableconcept),
    service_type: List(Codeableconcept),
    specialty: List(Codeableconcept),
    appointment_type: Option(Codeableconcept),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    priority: Option(Int),
    description: Option(String),
    supporting_information: List(Reference),
    start: Option(String),
    end: Option(String),
    minutes_duration: Option(Int),
    slot: List(Reference),
    created: Option(String),
    comment: Option(String),
    patient_instruction: Option(String),
    based_on: List(Reference),
    participant: List(AppointmentParticipant),
    requested_period: List(Period),
  )
}

pub fn appointment_new(status) -> Appointment {
  Appointment(
    requested_period: [],
    participant: [],
    based_on: [],
    patient_instruction: None,
    comment: None,
    created: None,
    slot: [],
    minutes_duration: None,
    end: None,
    start: None,
    supporting_information: [],
    description: None,
    priority: None,
    reason_reference: [],
    reason_code: [],
    appointment_type: None,
    specialty: [],
    service_type: [],
    service_category: [],
    cancelation_reason: None,
    status:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Appointment#resource
pub type AppointmentParticipant {
  AppointmentParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: List(Codeableconcept),
    actor: Option(Reference),
    required: Option(r4bvaluesets.Participantrequired),
    status: r4bvaluesets.Participationstatus,
    period: Option(Period),
  )
}

pub fn appointment_participant_new(status) -> AppointmentParticipant {
  AppointmentParticipant(
    period: None,
    status:,
    required: None,
    actor: None,
    type_: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/AppointmentResponse#resource
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
    start: Option(String),
    end: Option(String),
    participant_type: List(Codeableconcept),
    actor: Option(Reference),
    participant_status: r4bvaluesets.Participationstatus,
    comment: Option(String),
  )
}

pub fn appointmentresponse_new(
  participant_status,
  appointment,
) -> Appointmentresponse {
  Appointmentresponse(
    comment: None,
    participant_status:,
    actor: None,
    participant_type: [],
    end: None,
    start: None,
    appointment:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/AuditEvent#resource
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
    type_: Coding,
    subtype: List(Coding),
    action: Option(r4bvaluesets.Auditeventaction),
    period: Option(Period),
    recorded: String,
    outcome: Option(r4bvaluesets.Auditeventoutcome),
    outcome_desc: Option(String),
    purpose_of_event: List(Codeableconcept),
    agent: List(AuditeventAgent),
    source: AuditeventSource,
    entity: List(AuditeventEntity),
  )
}

pub fn auditevent_new(source, recorded, type_) -> Auditevent {
  Auditevent(
    entity: [],
    source:,
    agent: [],
    purpose_of_event: [],
    outcome_desc: None,
    outcome: None,
    recorded:,
    period: None,
    action: None,
    subtype: [],
    type_:,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/AuditEvent#resource
pub type AuditeventAgent {
  AuditeventAgent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    role: List(Codeableconcept),
    who: Option(Reference),
    alt_id: Option(String),
    name: Option(String),
    requestor: Bool,
    location: Option(Reference),
    policy: List(String),
    media: Option(Coding),
    network: Option(AuditeventAgentNetwork),
    purpose_of_use: List(Codeableconcept),
  )
}

pub fn auditevent_agent_new(requestor) -> AuditeventAgent {
  AuditeventAgent(
    purpose_of_use: [],
    network: None,
    media: None,
    policy: [],
    location: None,
    requestor:,
    name: None,
    alt_id: None,
    who: None,
    role: [],
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/AuditEvent#resource
pub type AuditeventAgentNetwork {
  AuditeventAgentNetwork(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    address: Option(String),
    type_: Option(r4bvaluesets.Networktype),
  )
}

pub fn auditevent_agent_network_new() -> AuditeventAgentNetwork {
  AuditeventAgentNetwork(
    type_: None,
    address: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/AuditEvent#resource
pub type AuditeventSource {
  AuditeventSource(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    site: Option(String),
    observer: Reference,
    type_: List(Coding),
  )
}

pub fn auditevent_source_new(observer) -> AuditeventSource {
  AuditeventSource(
    type_: [],
    observer:,
    site: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/AuditEvent#resource
pub type AuditeventEntity {
  AuditeventEntity(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    what: Option(Reference),
    type_: Option(Coding),
    role: Option(Coding),
    lifecycle: Option(Coding),
    security_label: List(Coding),
    name: Option(String),
    description: Option(String),
    query: Option(String),
    detail: List(AuditeventEntityDetail),
  )
}

pub fn auditevent_entity_new() -> AuditeventEntity {
  AuditeventEntity(
    detail: [],
    query: None,
    description: None,
    name: None,
    security_label: [],
    lifecycle: None,
    role: None,
    type_: None,
    what: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/AuditEvent#resource
pub type AuditeventEntityDetail {
  AuditeventEntityDetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: String,
    value: AuditeventEntityDetailValue,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/AuditEvent#resource
pub type AuditeventEntityDetailValue {
  AuditeventEntityDetailValueString(value: String)
  AuditeventEntityDetailValueBase64binary(value: String)
}

pub fn auditevent_entity_detail_new(value, type_) -> AuditeventEntityDetail {
  AuditeventEntityDetail(
    value:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Basic#resource
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

pub fn basic_new(code) -> Basic {
  Basic(
    author: None,
    created: None,
    subject: None,
    code:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Binary#resource
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

pub fn binary_new(content_type) -> Binary {
  Binary(
    data: None,
    security_context: None,
    content_type:,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/BiologicallyDerivedProduct#resource
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
    identifier: List(Identifier),
    product_category: Option(r4bvaluesets.Productcategory),
    product_code: Option(Codeableconcept),
    status: Option(r4bvaluesets.Productstatus),
    request: List(Reference),
    quantity: Option(Int),
    parent: List(Reference),
    collection: Option(BiologicallyderivedproductCollection),
    processing: List(BiologicallyderivedproductProcessing),
    manipulation: Option(BiologicallyderivedproductManipulation),
    storage: List(BiologicallyderivedproductStorage),
  )
}

pub fn biologicallyderivedproduct_new() -> Biologicallyderivedproduct {
  Biologicallyderivedproduct(
    storage: [],
    manipulation: None,
    processing: [],
    collection: None,
    parent: [],
    quantity: None,
    request: [],
    status: None,
    product_code: None,
    product_category: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/BiologicallyDerivedProduct#resource
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

///http://hl7.org/fhir/r4b/StructureDefinition/BiologicallyDerivedProduct#resource
pub type BiologicallyderivedproductCollectionCollected {
  BiologicallyderivedproductCollectionCollectedDatetime(collected: String)
  BiologicallyderivedproductCollectionCollectedPeriod(collected: Period)
}

pub fn biologicallyderivedproduct_collection_new() -> BiologicallyderivedproductCollection {
  BiologicallyderivedproductCollection(
    collected: None,
    source: None,
    collector: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/BiologicallyDerivedProduct#resource
pub type BiologicallyderivedproductProcessing {
  BiologicallyderivedproductProcessing(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    procedure: Option(Codeableconcept),
    additive: Option(Reference),
    time: Option(BiologicallyderivedproductProcessingTime),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/BiologicallyDerivedProduct#resource
pub type BiologicallyderivedproductProcessingTime {
  BiologicallyderivedproductProcessingTimeDatetime(time: String)
  BiologicallyderivedproductProcessingTimePeriod(time: Period)
}

pub fn biologicallyderivedproduct_processing_new() -> BiologicallyderivedproductProcessing {
  BiologicallyderivedproductProcessing(
    time: None,
    additive: None,
    procedure: None,
    description: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/BiologicallyDerivedProduct#resource
pub type BiologicallyderivedproductManipulation {
  BiologicallyderivedproductManipulation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    time: Option(BiologicallyderivedproductManipulationTime),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/BiologicallyDerivedProduct#resource
pub type BiologicallyderivedproductManipulationTime {
  BiologicallyderivedproductManipulationTimeDatetime(time: String)
  BiologicallyderivedproductManipulationTimePeriod(time: Period)
}

pub fn biologicallyderivedproduct_manipulation_new() -> BiologicallyderivedproductManipulation {
  BiologicallyderivedproductManipulation(
    time: None,
    description: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/BiologicallyDerivedProduct#resource
pub type BiologicallyderivedproductStorage {
  BiologicallyderivedproductStorage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    temperature: Option(Float),
    scale: Option(r4bvaluesets.Productstoragescale),
    duration: Option(Period),
  )
}

pub fn biologicallyderivedproduct_storage_new() -> BiologicallyderivedproductStorage {
  BiologicallyderivedproductStorage(
    duration: None,
    scale: None,
    temperature: None,
    description: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/BodyStructure#resource
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
    location: Option(Codeableconcept),
    location_qualifier: List(Codeableconcept),
    description: Option(String),
    image: List(Attachment),
    patient: Reference,
  )
}

pub fn bodystructure_new(patient) -> Bodystructure {
  Bodystructure(
    patient:,
    image: [],
    description: None,
    location_qualifier: [],
    location: None,
    morphology: None,
    active: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Bundle#resource
pub type Bundle {
  Bundle(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    identifier: Option(Identifier),
    type_: r4bvaluesets.Bundletype,
    timestamp: Option(String),
    total: Option(Int),
    link: List(BundleLink),
    entry: List(BundleEntry),
    signature: Option(Signature),
  )
}

pub fn bundle_new(type_) -> Bundle {
  Bundle(
    signature: None,
    entry: [],
    link: [],
    total: None,
    timestamp: None,
    type_:,
    identifier: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Bundle#resource
pub type BundleLink {
  BundleLink(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    relation: String,
    url: String,
  )
}

pub fn bundle_link_new(url, relation) -> BundleLink {
  BundleLink(url:, relation:, modifier_extension: [], extension: [], id: None)
}

///http://hl7.org/fhir/r4b/StructureDefinition/Bundle#resource
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

pub fn bundle_entry_new() -> BundleEntry {
  BundleEntry(
    response: None,
    request: None,
    search: None,
    resource: None,
    full_url: None,
    link: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Bundle#resource
pub type BundleEntrySearch {
  BundleEntrySearch(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    mode: Option(r4bvaluesets.Searchentrymode),
    score: Option(Float),
  )
}

pub fn bundle_entry_search_new() -> BundleEntrySearch {
  BundleEntrySearch(
    score: None,
    mode: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Bundle#resource
pub type BundleEntryRequest {
  BundleEntryRequest(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    method: r4bvaluesets.Httpverb,
    url: String,
    if_none_match: Option(String),
    if_modified_since: Option(String),
    if_match: Option(String),
    if_none_exist: Option(String),
  )
}

pub fn bundle_entry_request_new(url, method) -> BundleEntryRequest {
  BundleEntryRequest(
    if_none_exist: None,
    if_match: None,
    if_modified_since: None,
    if_none_match: None,
    url:,
    method:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Bundle#resource
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

pub fn bundle_entry_response_new(status) -> BundleEntryResponse {
  BundleEntryResponse(
    outcome: None,
    last_modified: None,
    etag: None,
    location: None,
    status:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CapabilityStatement#resource
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
    version: Option(String),
    name: Option(String),
    title: Option(String),
    status: r4bvaluesets.Publicationstatus,
    experimental: Option(Bool),
    date: String,
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    kind: r4bvaluesets.Capabilitystatementkind,
    instantiates: List(String),
    imports: List(String),
    software: Option(CapabilitystatementSoftware),
    implementation: Option(CapabilitystatementImplementation),
    fhir_version: r4bvaluesets.Fhirversion,
    format: List(String),
    patch_format: List(String),
    implementation_guide: List(String),
    rest: List(CapabilitystatementRest),
    messaging: List(CapabilitystatementMessaging),
    document: List(CapabilitystatementDocument),
  )
}

pub fn capabilitystatement_new(
  fhir_version,
  kind,
  date,
  status,
) -> Capabilitystatement {
  Capabilitystatement(
    document: [],
    messaging: [],
    rest: [],
    implementation_guide: [],
    patch_format: [],
    format: [],
    fhir_version:,
    implementation: None,
    software: None,
    imports: [],
    instantiates: [],
    kind:,
    copyright: None,
    purpose: None,
    jurisdiction: [],
    use_context: [],
    description: None,
    contact: [],
    publisher: None,
    date:,
    experimental: None,
    status:,
    title: None,
    name: None,
    version: None,
    url: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CapabilityStatement#resource
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

pub fn capabilitystatement_software_new(name) -> CapabilitystatementSoftware {
  CapabilitystatementSoftware(
    release_date: None,
    version: None,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CapabilityStatement#resource
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

pub fn capabilitystatement_implementation_new(
  description,
) -> CapabilitystatementImplementation {
  CapabilitystatementImplementation(
    custodian: None,
    url: None,
    description:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementRest {
  CapabilitystatementRest(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    mode: r4bvaluesets.Restfulcapabilitymode,
    documentation: Option(String),
    security: Option(CapabilitystatementRestSecurity),
    resource: List(CapabilitystatementRestResource),
    interaction: List(CapabilitystatementRestInteraction),
    search_param: List(Nil),
    operation: List(Nil),
    compartment: List(String),
  )
}

pub fn capabilitystatement_rest_new(mode) -> CapabilitystatementRest {
  CapabilitystatementRest(
    compartment: [],
    operation: [],
    search_param: [],
    interaction: [],
    resource: [],
    security: None,
    documentation: None,
    mode:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CapabilityStatement#resource
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

pub fn capabilitystatement_rest_security_new() -> CapabilitystatementRestSecurity {
  CapabilitystatementRestSecurity(
    description: None,
    service: [],
    cors: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementRestResource {
  CapabilitystatementRestResource(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r4bvaluesets.Resourcetypes,
    profile: Option(String),
    supported_profile: List(String),
    documentation: Option(String),
    interaction: List(CapabilitystatementRestResourceInteraction),
    versioning: Option(r4bvaluesets.Versioningpolicy),
    read_history: Option(Bool),
    update_create: Option(Bool),
    conditional_create: Option(Bool),
    conditional_read: Option(r4bvaluesets.Conditionalreadstatus),
    conditional_update: Option(Bool),
    conditional_delete: Option(r4bvaluesets.Conditionaldeletestatus),
    reference_policy: List(r4bvaluesets.Referencehandlingpolicy),
    search_include: List(String),
    search_rev_include: List(String),
    search_param: List(CapabilitystatementRestResourceSearchparam),
    operation: List(CapabilitystatementRestResourceOperation),
  )
}

pub fn capabilitystatement_rest_resource_new(
  type_,
) -> CapabilitystatementRestResource {
  CapabilitystatementRestResource(
    operation: [],
    search_param: [],
    search_rev_include: [],
    search_include: [],
    reference_policy: [],
    conditional_delete: None,
    conditional_update: None,
    conditional_read: None,
    conditional_create: None,
    update_create: None,
    read_history: None,
    versioning: None,
    interaction: [],
    documentation: None,
    supported_profile: [],
    profile: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementRestResourceInteraction {
  CapabilitystatementRestResourceInteraction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: r4bvaluesets.Typerestfulinteraction,
    documentation: Option(String),
  )
}

pub fn capabilitystatement_rest_resource_interaction_new(
  code,
) -> CapabilitystatementRestResourceInteraction {
  CapabilitystatementRestResourceInteraction(
    documentation: None,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementRestResourceSearchparam {
  CapabilitystatementRestResourceSearchparam(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    definition: Option(String),
    type_: r4bvaluesets.Searchparamtype,
    documentation: Option(String),
  )
}

pub fn capabilitystatement_rest_resource_searchparam_new(
  type_,
  name,
) -> CapabilitystatementRestResourceSearchparam {
  CapabilitystatementRestResourceSearchparam(
    documentation: None,
    type_:,
    definition: None,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CapabilityStatement#resource
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

pub fn capabilitystatement_rest_resource_operation_new(
  definition,
  name,
) -> CapabilitystatementRestResourceOperation {
  CapabilitystatementRestResourceOperation(
    documentation: None,
    definition:,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementRestInteraction {
  CapabilitystatementRestInteraction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: r4bvaluesets.Systemrestfulinteraction,
    documentation: Option(String),
  )
}

pub fn capabilitystatement_rest_interaction_new(
  code,
) -> CapabilitystatementRestInteraction {
  CapabilitystatementRestInteraction(
    documentation: None,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CapabilityStatement#resource
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

pub fn capabilitystatement_messaging_new() -> CapabilitystatementMessaging {
  CapabilitystatementMessaging(
    supported_message: [],
    documentation: None,
    reliable_cache: None,
    endpoint: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementMessagingEndpoint {
  CapabilitystatementMessagingEndpoint(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    protocol: Coding,
    address: String,
  )
}

pub fn capabilitystatement_messaging_endpoint_new(
  address,
  protocol,
) -> CapabilitystatementMessagingEndpoint {
  CapabilitystatementMessagingEndpoint(
    address:,
    protocol:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementMessagingSupportedmessage {
  CapabilitystatementMessagingSupportedmessage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    mode: r4bvaluesets.Eventcapabilitymode,
    definition: String,
  )
}

pub fn capabilitystatement_messaging_supportedmessage_new(
  definition,
  mode,
) -> CapabilitystatementMessagingSupportedmessage {
  CapabilitystatementMessagingSupportedmessage(
    definition:,
    mode:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementDocument {
  CapabilitystatementDocument(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    mode: r4bvaluesets.Documentmode,
    documentation: Option(String),
    profile: String,
  )
}

pub fn capabilitystatement_document_new(
  profile,
  mode,
) -> CapabilitystatementDocument {
  CapabilitystatementDocument(
    profile:,
    documentation: None,
    mode:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CarePlan#resource
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
    status: r4bvaluesets.Requeststatus,
    intent: r4bvaluesets.Careplanintent,
    category: List(Codeableconcept),
    title: Option(String),
    description: Option(String),
    subject: Reference,
    encounter: Option(Reference),
    period: Option(Period),
    created: Option(String),
    author: Option(Reference),
    contributor: List(Reference),
    care_team: List(Reference),
    addresses: List(Reference),
    supporting_info: List(Reference),
    goal: List(Reference),
    activity: List(CareplanActivity),
    note: List(Annotation),
  )
}

pub fn careplan_new(subject, intent, status) -> Careplan {
  Careplan(
    note: [],
    activity: [],
    goal: [],
    supporting_info: [],
    addresses: [],
    care_team: [],
    contributor: [],
    author: None,
    created: None,
    period: None,
    encounter: None,
    subject:,
    description: None,
    title: None,
    category: [],
    intent:,
    status:,
    part_of: [],
    replaces: [],
    based_on: [],
    instantiates_uri: [],
    instantiates_canonical: [],
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CarePlan#resource
pub type CareplanActivity {
  CareplanActivity(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    outcome_codeable_concept: List(Codeableconcept),
    outcome_reference: List(Reference),
    progress: List(Annotation),
    reference: Option(Reference),
    detail: Option(CareplanActivityDetail),
  )
}

pub fn careplan_activity_new() -> CareplanActivity {
  CareplanActivity(
    detail: None,
    reference: None,
    progress: [],
    outcome_reference: [],
    outcome_codeable_concept: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CarePlan#resource
pub type CareplanActivityDetail {
  CareplanActivityDetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    kind: Option(r4bvaluesets.Careplanactivitykind),
    instantiates_canonical: List(String),
    instantiates_uri: List(String),
    code: Option(Codeableconcept),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    goal: List(Reference),
    status: r4bvaluesets.Careplanactivitystatus,
    status_reason: Option(Codeableconcept),
    do_not_perform: Option(Bool),
    scheduled: Option(CareplanActivityDetailScheduled),
    location: Option(Reference),
    performer: List(Reference),
    product: Option(CareplanActivityDetailProduct),
    daily_amount: Option(Quantity),
    quantity: Option(Quantity),
    description: Option(String),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CarePlan#resource
pub type CareplanActivityDetailScheduled {
  CareplanActivityDetailScheduledTiming(scheduled: Timing)
  CareplanActivityDetailScheduledPeriod(scheduled: Period)
  CareplanActivityDetailScheduledString(scheduled: String)
}

///http://hl7.org/fhir/r4b/StructureDefinition/CarePlan#resource
pub type CareplanActivityDetailProduct {
  CareplanActivityDetailProductCodeableconcept(product: Codeableconcept)
  CareplanActivityDetailProductReference(product: Reference)
}

pub fn careplan_activity_detail_new(status) -> CareplanActivityDetail {
  CareplanActivityDetail(
    description: None,
    quantity: None,
    daily_amount: None,
    product: None,
    performer: [],
    location: None,
    scheduled: None,
    do_not_perform: None,
    status_reason: None,
    status:,
    goal: [],
    reason_reference: [],
    reason_code: [],
    code: None,
    instantiates_uri: [],
    instantiates_canonical: [],
    kind: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CareTeam#resource
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
    status: Option(r4bvaluesets.Careteamstatus),
    category: List(Codeableconcept),
    name: Option(String),
    subject: Option(Reference),
    encounter: Option(Reference),
    period: Option(Period),
    participant: List(CareteamParticipant),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    managing_organization: List(Reference),
    telecom: List(Contactpoint),
    note: List(Annotation),
  )
}

pub fn careteam_new() -> Careteam {
  Careteam(
    note: [],
    telecom: [],
    managing_organization: [],
    reason_reference: [],
    reason_code: [],
    participant: [],
    period: None,
    encounter: None,
    subject: None,
    name: None,
    category: [],
    status: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CareTeam#resource
pub type CareteamParticipant {
  CareteamParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    role: List(Codeableconcept),
    member: Option(Reference),
    on_behalf_of: Option(Reference),
    period: Option(Period),
  )
}

pub fn careteam_participant_new() -> CareteamParticipant {
  CareteamParticipant(
    period: None,
    on_behalf_of: None,
    member: None,
    role: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CatalogEntry#resource
pub type Catalogentry {
  Catalogentry(
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
    orderable: Bool,
    referenced_item: Reference,
    additional_identifier: List(Identifier),
    classification: List(Codeableconcept),
    status: Option(r4bvaluesets.Publicationstatus),
    validity_period: Option(Period),
    valid_to: Option(String),
    last_updated: Option(String),
    additional_characteristic: List(Codeableconcept),
    additional_classification: List(Codeableconcept),
    related_entry: List(CatalogentryRelatedentry),
  )
}

pub fn catalogentry_new(referenced_item, orderable) -> Catalogentry {
  Catalogentry(
    related_entry: [],
    additional_classification: [],
    additional_characteristic: [],
    last_updated: None,
    valid_to: None,
    validity_period: None,
    status: None,
    classification: [],
    additional_identifier: [],
    referenced_item:,
    orderable:,
    type_: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CatalogEntry#resource
pub type CatalogentryRelatedentry {
  CatalogentryRelatedentry(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    relationtype: r4bvaluesets.Relationtype,
    item: Reference,
  )
}

pub fn catalogentry_relatedentry_new(
  item,
  relationtype,
) -> CatalogentryRelatedentry {
  CatalogentryRelatedentry(
    item:,
    relationtype:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ChargeItem#resource
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
    status: r4bvaluesets.Chargeitemstatus,
    part_of: List(Reference),
    code: Codeableconcept,
    subject: Reference,
    context: Option(Reference),
    occurrence: Option(ChargeitemOccurrence),
    performer: List(ChargeitemPerformer),
    performing_organization: Option(Reference),
    requesting_organization: Option(Reference),
    cost_center: Option(Reference),
    quantity: Option(Quantity),
    bodysite: List(Codeableconcept),
    factor_override: Option(Float),
    price_override: Option(Money),
    override_reason: Option(String),
    enterer: Option(Reference),
    entered_date: Option(String),
    reason: List(Codeableconcept),
    service: List(Reference),
    product: Option(ChargeitemProduct),
    account: List(Reference),
    note: List(Annotation),
    supporting_information: List(Reference),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ChargeItem#resource
pub type ChargeitemOccurrence {
  ChargeitemOccurrenceDatetime(occurrence: String)
  ChargeitemOccurrencePeriod(occurrence: Period)
  ChargeitemOccurrenceTiming(occurrence: Timing)
}

///http://hl7.org/fhir/r4b/StructureDefinition/ChargeItem#resource
pub type ChargeitemProduct {
  ChargeitemProductReference(product: Reference)
  ChargeitemProductCodeableconcept(product: Codeableconcept)
}

pub fn chargeitem_new(subject, code, status) -> Chargeitem {
  Chargeitem(
    supporting_information: [],
    note: [],
    account: [],
    product: None,
    service: [],
    reason: [],
    entered_date: None,
    enterer: None,
    override_reason: None,
    price_override: None,
    factor_override: None,
    bodysite: [],
    quantity: None,
    cost_center: None,
    requesting_organization: None,
    performing_organization: None,
    performer: [],
    occurrence: None,
    context: None,
    subject:,
    code:,
    part_of: [],
    status:,
    definition_canonical: [],
    definition_uri: [],
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ChargeItem#resource
pub type ChargeitemPerformer {
  ChargeitemPerformer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    function: Option(Codeableconcept),
    actor: Reference,
  )
}

pub fn chargeitem_performer_new(actor) -> ChargeitemPerformer {
  ChargeitemPerformer(
    actor:,
    function: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ChargeItemDefinition#resource
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
    url: String,
    identifier: List(Identifier),
    version: Option(String),
    title: Option(String),
    derived_from_uri: List(String),
    part_of: List(String),
    replaces: List(String),
    status: r4bvaluesets.Publicationstatus,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    copyright: Option(String),
    approval_date: Option(String),
    last_review_date: Option(String),
    effective_period: Option(Period),
    code: Option(Codeableconcept),
    instance: List(Reference),
    applicability: List(ChargeitemdefinitionApplicability),
    property_group: List(ChargeitemdefinitionPropertygroup),
  )
}

pub fn chargeitemdefinition_new(status, url) -> Chargeitemdefinition {
  Chargeitemdefinition(
    property_group: [],
    applicability: [],
    instance: [],
    code: None,
    effective_period: None,
    last_review_date: None,
    approval_date: None,
    copyright: None,
    jurisdiction: [],
    use_context: [],
    description: None,
    contact: [],
    publisher: None,
    date: None,
    experimental: None,
    status:,
    replaces: [],
    part_of: [],
    derived_from_uri: [],
    title: None,
    version: None,
    identifier: [],
    url:,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ChargeItemDefinition#resource
pub type ChargeitemdefinitionApplicability {
  ChargeitemdefinitionApplicability(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    language: Option(String),
    expression: Option(String),
  )
}

pub fn chargeitemdefinition_applicability_new() -> ChargeitemdefinitionApplicability {
  ChargeitemdefinitionApplicability(
    expression: None,
    language: None,
    description: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ChargeItemDefinition#resource
pub type ChargeitemdefinitionPropertygroup {
  ChargeitemdefinitionPropertygroup(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    applicability: List(Nil),
    price_component: List(ChargeitemdefinitionPropertygroupPricecomponent),
  )
}

pub fn chargeitemdefinition_propertygroup_new() -> ChargeitemdefinitionPropertygroup {
  ChargeitemdefinitionPropertygroup(
    price_component: [],
    applicability: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ChargeItemDefinition#resource
pub type ChargeitemdefinitionPropertygroupPricecomponent {
  ChargeitemdefinitionPropertygroupPricecomponent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r4bvaluesets.Invoicepricecomponenttype,
    code: Option(Codeableconcept),
    factor: Option(Float),
    amount: Option(Money),
  )
}

pub fn chargeitemdefinition_propertygroup_pricecomponent_new(
  type_,
) -> ChargeitemdefinitionPropertygroupPricecomponent {
  ChargeitemdefinitionPropertygroupPricecomponent(
    amount: None,
    factor: None,
    code: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Citation#resource
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
    name: Option(String),
    title: Option(String),
    status: r4bvaluesets.Publicationstatus,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
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
    relates_to: List(CitationRelatesto),
    cited_artifact: Option(CitationCitedartifact),
  )
}

pub fn citation_new(status) -> Citation {
  Citation(
    cited_artifact: None,
    relates_to: [],
    status_date: [],
    current_state: [],
    note: [],
    classification: [],
    summary: [],
    endorser: [],
    reviewer: [],
    editor: [],
    author: [],
    effective_period: None,
    last_review_date: None,
    approval_date: None,
    copyright: None,
    purpose: None,
    jurisdiction: [],
    use_context: [],
    description: None,
    contact: [],
    publisher: None,
    date: None,
    experimental: None,
    status:,
    title: None,
    name: None,
    version: None,
    identifier: [],
    url: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Citation#resource
pub type CitationSummary {
  CitationSummary(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    style: Option(Codeableconcept),
    text: String,
  )
}

pub fn citation_summary_new(text) -> CitationSummary {
  CitationSummary(
    text:,
    style: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Citation#resource
pub type CitationClassification {
  CitationClassification(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    classifier: List(Codeableconcept),
  )
}

pub fn citation_classification_new() -> CitationClassification {
  CitationClassification(
    classifier: [],
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Citation#resource
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

pub fn citation_statusdate_new(period, activity) -> CitationStatusdate {
  CitationStatusdate(
    period:,
    actual: None,
    activity:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Citation#resource
pub type CitationRelatesto {
  CitationRelatesto(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    relationship_type: Codeableconcept,
    target_classifier: List(Codeableconcept),
    target: CitationRelatestoTarget,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Citation#resource
pub type CitationRelatestoTarget {
  CitationRelatestoTargetUri(target: String)
  CitationRelatestoTargetIdentifier(target: Identifier)
  CitationRelatestoTargetReference(target: Reference)
  CitationRelatestoTargetAttachment(target: Attachment)
}

pub fn citation_relatesto_new(target, relationship_type) -> CitationRelatesto {
  CitationRelatesto(
    target:,
    target_classifier: [],
    relationship_type:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Citation#resource
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

pub fn citation_citedartifact_new() -> CitationCitedartifact {
  CitationCitedartifact(
    note: [],
    contributorship: None,
    classification: [],
    web_location: [],
    publication_form: [],
    relates_to: [],
    part: None,
    abstract: [],
    title: [],
    status_date: [],
    current_state: [],
    version: None,
    date_accessed: None,
    related_identifier: [],
    identifier: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Citation#resource
pub type CitationCitedartifactVersion {
  CitationCitedartifactVersion(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    value: String,
    base_citation: Option(Reference),
  )
}

pub fn citation_citedartifact_version_new(value) -> CitationCitedartifactVersion {
  CitationCitedartifactVersion(
    base_citation: None,
    value:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Citation#resource
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

pub fn citation_citedartifact_statusdate_new(
  period,
  activity,
) -> CitationCitedartifactStatusdate {
  CitationCitedartifactStatusdate(
    period:,
    actual: None,
    activity:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Citation#resource
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

pub fn citation_citedartifact_title_new(text) -> CitationCitedartifactTitle {
  CitationCitedartifactTitle(
    text:,
    language: None,
    type_: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Citation#resource
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

pub fn citation_citedartifact_abstract_new(
  text,
) -> CitationCitedartifactAbstract {
  CitationCitedartifactAbstract(
    copyright: None,
    text:,
    language: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Citation#resource
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

pub fn citation_citedartifact_part_new() -> CitationCitedartifactPart {
  CitationCitedartifactPart(
    base_citation: None,
    value: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Citation#resource
pub type CitationCitedartifactRelatesto {
  CitationCitedartifactRelatesto(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    relationship_type: Codeableconcept,
    target_classifier: List(Codeableconcept),
    target: CitationCitedartifactRelatestoTarget,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Citation#resource
pub type CitationCitedartifactRelatestoTarget {
  CitationCitedartifactRelatestoTargetUri(target: String)
  CitationCitedartifactRelatestoTargetIdentifier(target: Identifier)
  CitationCitedartifactRelatestoTargetReference(target: Reference)
  CitationCitedartifactRelatestoTargetAttachment(target: Attachment)
}

pub fn citation_citedartifact_relatesto_new(
  target,
  relationship_type,
) -> CitationCitedartifactRelatesto {
  CitationCitedartifactRelatesto(
    target:,
    target_classifier: [],
    relationship_type:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Citation#resource
pub type CitationCitedartifactPublicationform {
  CitationCitedartifactPublicationform(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    published_in: Option(CitationCitedartifactPublicationformPublishedin),
    periodic_release: Option(
      CitationCitedartifactPublicationformPeriodicrelease,
    ),
    article_date: Option(String),
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

pub fn citation_citedartifact_publicationform_new() -> CitationCitedartifactPublicationform {
  CitationCitedartifactPublicationform(
    copyright: None,
    page_count: None,
    last_page: None,
    first_page: None,
    page_string: None,
    accession_number: None,
    language: [],
    last_revision_date: None,
    article_date: None,
    periodic_release: None,
    published_in: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Citation#resource
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

pub fn citation_citedartifact_publicationform_publishedin_new() -> CitationCitedartifactPublicationformPublishedin {
  CitationCitedartifactPublicationformPublishedin(
    publisher_location: None,
    publisher: None,
    title: None,
    identifier: [],
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Citation#resource
pub type CitationCitedartifactPublicationformPeriodicrelease {
  CitationCitedartifactPublicationformPeriodicrelease(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    cited_medium: Option(Codeableconcept),
    volume: Option(String),
    issue: Option(String),
    date_of_publication: Option(
      CitationCitedartifactPublicationformPeriodicreleaseDateofpublication,
    ),
  )
}

pub fn citation_citedartifact_publicationform_periodicrelease_new() -> CitationCitedartifactPublicationformPeriodicrelease {
  CitationCitedartifactPublicationformPeriodicrelease(
    date_of_publication: None,
    issue: None,
    volume: None,
    cited_medium: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Citation#resource
pub type CitationCitedartifactPublicationformPeriodicreleaseDateofpublication {
  CitationCitedartifactPublicationformPeriodicreleaseDateofpublication(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    date: Option(String),
    year: Option(String),
    month: Option(String),
    day: Option(String),
    season: Option(String),
    text: Option(String),
  )
}

pub fn citation_citedartifact_publicationform_periodicrelease_dateofpublication_new() -> CitationCitedartifactPublicationformPeriodicreleaseDateofpublication {
  CitationCitedartifactPublicationformPeriodicreleaseDateofpublication(
    text: None,
    season: None,
    day: None,
    month: None,
    year: None,
    date: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Citation#resource
pub type CitationCitedartifactWeblocation {
  CitationCitedartifactWeblocation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    url: Option(String),
  )
}

pub fn citation_citedartifact_weblocation_new() -> CitationCitedartifactWeblocation {
  CitationCitedartifactWeblocation(
    url: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Citation#resource
pub type CitationCitedartifactClassification {
  CitationCitedartifactClassification(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    classifier: List(Codeableconcept),
    who_classified: Option(CitationCitedartifactClassificationWhoclassified),
  )
}

pub fn citation_citedartifact_classification_new() -> CitationCitedartifactClassification {
  CitationCitedartifactClassification(
    who_classified: None,
    classifier: [],
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Citation#resource
pub type CitationCitedartifactClassificationWhoclassified {
  CitationCitedartifactClassificationWhoclassified(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    person: Option(Reference),
    organization: Option(Reference),
    publisher: Option(Reference),
    classifier_copyright: Option(String),
    free_to_share: Option(Bool),
  )
}

pub fn citation_citedartifact_classification_whoclassified_new() -> CitationCitedartifactClassificationWhoclassified {
  CitationCitedartifactClassificationWhoclassified(
    free_to_share: None,
    classifier_copyright: None,
    publisher: None,
    organization: None,
    person: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Citation#resource
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

pub fn citation_citedartifact_contributorship_new() -> CitationCitedartifactContributorship {
  CitationCitedartifactContributorship(
    summary: [],
    entry: [],
    complete: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Citation#resource
pub type CitationCitedartifactContributorshipEntry {
  CitationCitedartifactContributorshipEntry(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: Option(Humanname),
    initials: Option(String),
    collective_name: Option(String),
    identifier: List(Identifier),
    affiliation_info: List(
      CitationCitedartifactContributorshipEntryAffiliationinfo,
    ),
    address: List(Address),
    telecom: List(Contactpoint),
    contribution_type: List(Codeableconcept),
    role: Option(Codeableconcept),
    contribution_instance: List(
      CitationCitedartifactContributorshipEntryContributioninstance,
    ),
    corresponding_contact: Option(Bool),
    list_order: Option(Int),
  )
}

pub fn citation_citedartifact_contributorship_entry_new() -> CitationCitedartifactContributorshipEntry {
  CitationCitedartifactContributorshipEntry(
    list_order: None,
    corresponding_contact: None,
    contribution_instance: [],
    role: None,
    contribution_type: [],
    telecom: [],
    address: [],
    affiliation_info: [],
    identifier: [],
    collective_name: None,
    initials: None,
    name: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Citation#resource
pub type CitationCitedartifactContributorshipEntryAffiliationinfo {
  CitationCitedartifactContributorshipEntryAffiliationinfo(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    affiliation: Option(String),
    role: Option(String),
    identifier: List(Identifier),
  )
}

pub fn citation_citedartifact_contributorship_entry_affiliationinfo_new() -> CitationCitedartifactContributorshipEntryAffiliationinfo {
  CitationCitedartifactContributorshipEntryAffiliationinfo(
    identifier: [],
    role: None,
    affiliation: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Citation#resource
pub type CitationCitedartifactContributorshipEntryContributioninstance {
  CitationCitedartifactContributorshipEntryContributioninstance(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    time: Option(String),
  )
}

pub fn citation_citedartifact_contributorship_entry_contributioninstance_new(
  type_,
) -> CitationCitedartifactContributorshipEntryContributioninstance {
  CitationCitedartifactContributorshipEntryContributioninstance(
    time: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Citation#resource
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

pub fn citation_citedartifact_contributorship_summary_new(
  value,
) -> CitationCitedartifactContributorshipSummary {
  CitationCitedartifactContributorshipSummary(
    value:,
    source: None,
    style: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Claim#resource
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
    status: r4bvaluesets.Fmstatus,
    type_: Codeableconcept,
    sub_type: Option(Codeableconcept),
    use_: r4bvaluesets.Claimuse,
    patient: Reference,
    billable_period: Option(Period),
    created: String,
    enterer: Option(Reference),
    insurer: Option(Reference),
    provider: Reference,
    priority: Codeableconcept,
    funds_reserve: Option(Codeableconcept),
    related: List(ClaimRelated),
    prescription: Option(Reference),
    original_prescription: Option(Reference),
    payee: Option(ClaimPayee),
    referral: Option(Reference),
    facility: Option(Reference),
    care_team: List(ClaimCareteam),
    supporting_info: List(ClaimSupportinginfo),
    diagnosis: List(ClaimDiagnosis),
    procedure: List(ClaimProcedure),
    insurance: List(ClaimInsurance),
    accident: Option(ClaimAccident),
    item: List(ClaimItem),
    total: Option(Money),
  )
}

pub fn claim_new(
  priority,
  provider,
  created,
  patient,
  use_,
  type_,
  status,
) -> Claim {
  Claim(
    total: None,
    item: [],
    accident: None,
    insurance: [],
    procedure: [],
    diagnosis: [],
    supporting_info: [],
    care_team: [],
    facility: None,
    referral: None,
    payee: None,
    original_prescription: None,
    prescription: None,
    related: [],
    funds_reserve: None,
    priority:,
    provider:,
    insurer: None,
    enterer: None,
    created:,
    billable_period: None,
    patient:,
    use_:,
    sub_type: None,
    type_:,
    status:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Claim#resource
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

pub fn claim_related_new() -> ClaimRelated {
  ClaimRelated(
    reference: None,
    relationship: None,
    claim: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Claim#resource
pub type ClaimPayee {
  ClaimPayee(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    party: Option(Reference),
  )
}

pub fn claim_payee_new(type_) -> ClaimPayee {
  ClaimPayee(
    party: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Claim#resource
pub type ClaimCareteam {
  ClaimCareteam(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Int,
    provider: Reference,
    responsible: Option(Bool),
    role: Option(Codeableconcept),
    qualification: Option(Codeableconcept),
  )
}

pub fn claim_careteam_new(provider, sequence) -> ClaimCareteam {
  ClaimCareteam(
    qualification: None,
    role: None,
    responsible: None,
    provider:,
    sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Claim#resource
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

///http://hl7.org/fhir/r4b/StructureDefinition/Claim#resource
pub type ClaimSupportinginfoTiming {
  ClaimSupportinginfoTimingDate(timing: String)
  ClaimSupportinginfoTimingPeriod(timing: Period)
}

///http://hl7.org/fhir/r4b/StructureDefinition/Claim#resource
pub type ClaimSupportinginfoValue {
  ClaimSupportinginfoValueBoolean(value: Bool)
  ClaimSupportinginfoValueString(value: String)
  ClaimSupportinginfoValueQuantity(value: Quantity)
  ClaimSupportinginfoValueAttachment(value: Attachment)
  ClaimSupportinginfoValueReference(value: Reference)
}

pub fn claim_supportinginfo_new(category, sequence) -> ClaimSupportinginfo {
  ClaimSupportinginfo(
    reason: None,
    value: None,
    timing: None,
    code: None,
    category:,
    sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Claim#resource
pub type ClaimDiagnosis {
  ClaimDiagnosis(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Int,
    diagnosis: ClaimDiagnosisDiagnosis,
    type_: List(Codeableconcept),
    on_admission: Option(Codeableconcept),
    package_code: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Claim#resource
pub type ClaimDiagnosisDiagnosis {
  ClaimDiagnosisDiagnosisCodeableconcept(diagnosis: Codeableconcept)
  ClaimDiagnosisDiagnosisReference(diagnosis: Reference)
}

pub fn claim_diagnosis_new(diagnosis, sequence) -> ClaimDiagnosis {
  ClaimDiagnosis(
    package_code: None,
    on_admission: None,
    type_: [],
    diagnosis:,
    sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Claim#resource
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

///http://hl7.org/fhir/r4b/StructureDefinition/Claim#resource
pub type ClaimProcedureProcedure {
  ClaimProcedureProcedureCodeableconcept(procedure: Codeableconcept)
  ClaimProcedureProcedureReference(procedure: Reference)
}

pub fn claim_procedure_new(procedure, sequence) -> ClaimProcedure {
  ClaimProcedure(
    udi: [],
    procedure:,
    date: None,
    type_: [],
    sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Claim#resource
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

pub fn claim_insurance_new(coverage, focal, sequence) -> ClaimInsurance {
  ClaimInsurance(
    claim_response: None,
    pre_auth_ref: [],
    business_arrangement: None,
    coverage:,
    identifier: None,
    focal:,
    sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Claim#resource
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

///http://hl7.org/fhir/r4b/StructureDefinition/Claim#resource
pub type ClaimAccidentLocation {
  ClaimAccidentLocationAddress(location: Address)
  ClaimAccidentLocationReference(location: Reference)
}

pub fn claim_accident_new(date) -> ClaimAccident {
  ClaimAccident(
    location: None,
    type_: None,
    date:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Claim#resource
pub type ClaimItem {
  ClaimItem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Int,
    care_team_sequence: List(Int),
    diagnosis_sequence: List(Int),
    procedure_sequence: List(Int),
    information_sequence: List(Int),
    revenue: Option(Codeableconcept),
    category: Option(Codeableconcept),
    product_or_service: Codeableconcept,
    modifier: List(Codeableconcept),
    program_code: List(Codeableconcept),
    serviced: Option(ClaimItemServiced),
    location: Option(ClaimItemLocation),
    quantity: Option(Quantity),
    unit_price: Option(Money),
    factor: Option(Float),
    net: Option(Money),
    udi: List(Reference),
    body_site: Option(Codeableconcept),
    sub_site: List(Codeableconcept),
    encounter: List(Reference),
    detail: List(ClaimItemDetail),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Claim#resource
pub type ClaimItemServiced {
  ClaimItemServicedDate(serviced: String)
  ClaimItemServicedPeriod(serviced: Period)
}

///http://hl7.org/fhir/r4b/StructureDefinition/Claim#resource
pub type ClaimItemLocation {
  ClaimItemLocationCodeableconcept(location: Codeableconcept)
  ClaimItemLocationAddress(location: Address)
  ClaimItemLocationReference(location: Reference)
}

pub fn claim_item_new(product_or_service, sequence) -> ClaimItem {
  ClaimItem(
    detail: [],
    encounter: [],
    sub_site: [],
    body_site: None,
    udi: [],
    net: None,
    factor: None,
    unit_price: None,
    quantity: None,
    location: None,
    serviced: None,
    program_code: [],
    modifier: [],
    product_or_service:,
    category: None,
    revenue: None,
    information_sequence: [],
    procedure_sequence: [],
    diagnosis_sequence: [],
    care_team_sequence: [],
    sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Claim#resource
pub type ClaimItemDetail {
  ClaimItemDetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Int,
    revenue: Option(Codeableconcept),
    category: Option(Codeableconcept),
    product_or_service: Codeableconcept,
    modifier: List(Codeableconcept),
    program_code: List(Codeableconcept),
    quantity: Option(Quantity),
    unit_price: Option(Money),
    factor: Option(Float),
    net: Option(Money),
    udi: List(Reference),
    sub_detail: List(ClaimItemDetailSubdetail),
  )
}

pub fn claim_item_detail_new(product_or_service, sequence) -> ClaimItemDetail {
  ClaimItemDetail(
    sub_detail: [],
    udi: [],
    net: None,
    factor: None,
    unit_price: None,
    quantity: None,
    program_code: [],
    modifier: [],
    product_or_service:,
    category: None,
    revenue: None,
    sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Claim#resource
pub type ClaimItemDetailSubdetail {
  ClaimItemDetailSubdetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Int,
    revenue: Option(Codeableconcept),
    category: Option(Codeableconcept),
    product_or_service: Codeableconcept,
    modifier: List(Codeableconcept),
    program_code: List(Codeableconcept),
    quantity: Option(Quantity),
    unit_price: Option(Money),
    factor: Option(Float),
    net: Option(Money),
    udi: List(Reference),
  )
}

pub fn claim_item_detail_subdetail_new(
  product_or_service,
  sequence,
) -> ClaimItemDetailSubdetail {
  ClaimItemDetailSubdetail(
    udi: [],
    net: None,
    factor: None,
    unit_price: None,
    quantity: None,
    program_code: [],
    modifier: [],
    product_or_service:,
    category: None,
    revenue: None,
    sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ClaimResponse#resource
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
    status: r4bvaluesets.Fmstatus,
    type_: Codeableconcept,
    sub_type: Option(Codeableconcept),
    use_: r4bvaluesets.Claimuse,
    patient: Reference,
    created: String,
    insurer: Reference,
    requestor: Option(Reference),
    request: Option(Reference),
    outcome: r4bvaluesets.Remittanceoutcome,
    disposition: Option(String),
    pre_auth_ref: Option(String),
    pre_auth_period: Option(Period),
    payee_type: Option(Codeableconcept),
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

pub fn claimresponse_new(
  outcome,
  insurer,
  created,
  patient,
  use_,
  type_,
  status,
) -> Claimresponse {
  Claimresponse(
    error: [],
    insurance: [],
    communication_request: [],
    process_note: [],
    form: None,
    form_code: None,
    funds_reserve: None,
    payment: None,
    total: [],
    adjudication: [],
    add_item: [],
    item: [],
    payee_type: None,
    pre_auth_period: None,
    pre_auth_ref: None,
    disposition: None,
    outcome:,
    request: None,
    requestor: None,
    insurer:,
    created:,
    patient:,
    use_:,
    sub_type: None,
    type_:,
    status:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseItem {
  ClaimresponseItem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item_sequence: Int,
    note_number: List(Int),
    adjudication: List(ClaimresponseItemAdjudication),
    detail: List(ClaimresponseItemDetail),
  )
}

pub fn claimresponse_item_new(item_sequence) -> ClaimresponseItem {
  ClaimresponseItem(
    detail: [],
    adjudication: [],
    note_number: [],
    item_sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseItemAdjudication {
  ClaimresponseItemAdjudication(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    category: Codeableconcept,
    reason: Option(Codeableconcept),
    amount: Option(Money),
    value: Option(Float),
  )
}

pub fn claimresponse_item_adjudication_new(
  category,
) -> ClaimresponseItemAdjudication {
  ClaimresponseItemAdjudication(
    value: None,
    amount: None,
    reason: None,
    category:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseItemDetail {
  ClaimresponseItemDetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    detail_sequence: Int,
    note_number: List(Int),
    adjudication: List(Nil),
    sub_detail: List(ClaimresponseItemDetailSubdetail),
  )
}

pub fn claimresponse_item_detail_new(detail_sequence) -> ClaimresponseItemDetail {
  ClaimresponseItemDetail(
    sub_detail: [],
    adjudication: [],
    note_number: [],
    detail_sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseItemDetailSubdetail {
  ClaimresponseItemDetailSubdetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sub_detail_sequence: Int,
    note_number: List(Int),
    adjudication: List(Nil),
  )
}

pub fn claimresponse_item_detail_subdetail_new(
  sub_detail_sequence,
) -> ClaimresponseItemDetailSubdetail {
  ClaimresponseItemDetailSubdetail(
    adjudication: [],
    note_number: [],
    sub_detail_sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseAdditem {
  ClaimresponseAdditem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item_sequence: List(Int),
    detail_sequence: List(Int),
    subdetail_sequence: List(Int),
    provider: List(Reference),
    product_or_service: Codeableconcept,
    modifier: List(Codeableconcept),
    program_code: List(Codeableconcept),
    serviced: Option(ClaimresponseAdditemServiced),
    location: Option(ClaimresponseAdditemLocation),
    quantity: Option(Quantity),
    unit_price: Option(Money),
    factor: Option(Float),
    net: Option(Money),
    body_site: Option(Codeableconcept),
    sub_site: List(Codeableconcept),
    note_number: List(Int),
    adjudication: List(Nil),
    detail: List(ClaimresponseAdditemDetail),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseAdditemServiced {
  ClaimresponseAdditemServicedDate(serviced: String)
  ClaimresponseAdditemServicedPeriod(serviced: Period)
}

///http://hl7.org/fhir/r4b/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseAdditemLocation {
  ClaimresponseAdditemLocationCodeableconcept(location: Codeableconcept)
  ClaimresponseAdditemLocationAddress(location: Address)
  ClaimresponseAdditemLocationReference(location: Reference)
}

pub fn claimresponse_additem_new(product_or_service) -> ClaimresponseAdditem {
  ClaimresponseAdditem(
    detail: [],
    adjudication: [],
    note_number: [],
    sub_site: [],
    body_site: None,
    net: None,
    factor: None,
    unit_price: None,
    quantity: None,
    location: None,
    serviced: None,
    program_code: [],
    modifier: [],
    product_or_service:,
    provider: [],
    subdetail_sequence: [],
    detail_sequence: [],
    item_sequence: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseAdditemDetail {
  ClaimresponseAdditemDetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    product_or_service: Codeableconcept,
    modifier: List(Codeableconcept),
    quantity: Option(Quantity),
    unit_price: Option(Money),
    factor: Option(Float),
    net: Option(Money),
    note_number: List(Int),
    adjudication: List(Nil),
    sub_detail: List(ClaimresponseAdditemDetailSubdetail),
  )
}

pub fn claimresponse_additem_detail_new(
  product_or_service,
) -> ClaimresponseAdditemDetail {
  ClaimresponseAdditemDetail(
    sub_detail: [],
    adjudication: [],
    note_number: [],
    net: None,
    factor: None,
    unit_price: None,
    quantity: None,
    modifier: [],
    product_or_service:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseAdditemDetailSubdetail {
  ClaimresponseAdditemDetailSubdetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    product_or_service: Codeableconcept,
    modifier: List(Codeableconcept),
    quantity: Option(Quantity),
    unit_price: Option(Money),
    factor: Option(Float),
    net: Option(Money),
    note_number: List(Int),
    adjudication: List(Nil),
  )
}

pub fn claimresponse_additem_detail_subdetail_new(
  product_or_service,
) -> ClaimresponseAdditemDetailSubdetail {
  ClaimresponseAdditemDetailSubdetail(
    adjudication: [],
    note_number: [],
    net: None,
    factor: None,
    unit_price: None,
    quantity: None,
    modifier: [],
    product_or_service:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseTotal {
  ClaimresponseTotal(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    category: Codeableconcept,
    amount: Money,
  )
}

pub fn claimresponse_total_new(amount, category) -> ClaimresponseTotal {
  ClaimresponseTotal(
    amount:,
    category:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ClaimResponse#resource
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

pub fn claimresponse_payment_new(amount, type_) -> ClaimresponsePayment {
  ClaimresponsePayment(
    identifier: None,
    amount:,
    date: None,
    adjustment_reason: None,
    adjustment: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseProcessnote {
  ClaimresponseProcessnote(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    number: Option(Int),
    type_: Option(r4bvaluesets.Notetype),
    text: String,
    language: Option(Codeableconcept),
  )
}

pub fn claimresponse_processnote_new(text) -> ClaimresponseProcessnote {
  ClaimresponseProcessnote(
    language: None,
    text:,
    type_: None,
    number: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ClaimResponse#resource
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

pub fn claimresponse_insurance_new(
  coverage,
  focal,
  sequence,
) -> ClaimresponseInsurance {
  ClaimresponseInsurance(
    claim_response: None,
    business_arrangement: None,
    coverage:,
    focal:,
    sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseError {
  ClaimresponseError(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item_sequence: Option(Int),
    detail_sequence: Option(Int),
    sub_detail_sequence: Option(Int),
    code: Codeableconcept,
  )
}

pub fn claimresponse_error_new(code) -> ClaimresponseError {
  ClaimresponseError(
    code:,
    sub_detail_sequence: None,
    detail_sequence: None,
    item_sequence: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ClinicalImpression#resource
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
    status: r4bvaluesets.Clinicalimpressionstatus,
    status_reason: Option(Codeableconcept),
    code: Option(Codeableconcept),
    description: Option(String),
    subject: Reference,
    encounter: Option(Reference),
    effective: Option(ClinicalimpressionEffective),
    date: Option(String),
    assessor: Option(Reference),
    previous: Option(Reference),
    problem: List(Reference),
    investigation: List(ClinicalimpressionInvestigation),
    protocol: List(String),
    summary: Option(String),
    finding: List(ClinicalimpressionFinding),
    prognosis_codeable_concept: List(Codeableconcept),
    prognosis_reference: List(Reference),
    supporting_info: List(Reference),
    note: List(Annotation),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ClinicalImpression#resource
pub type ClinicalimpressionEffective {
  ClinicalimpressionEffectiveDatetime(effective: String)
  ClinicalimpressionEffectivePeriod(effective: Period)
}

pub fn clinicalimpression_new(subject, status) -> Clinicalimpression {
  Clinicalimpression(
    note: [],
    supporting_info: [],
    prognosis_reference: [],
    prognosis_codeable_concept: [],
    finding: [],
    summary: None,
    protocol: [],
    investigation: [],
    problem: [],
    previous: None,
    assessor: None,
    date: None,
    effective: None,
    encounter: None,
    subject:,
    description: None,
    code: None,
    status_reason: None,
    status:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ClinicalImpression#resource
pub type ClinicalimpressionInvestigation {
  ClinicalimpressionInvestigation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
    item: List(Reference),
  )
}

pub fn clinicalimpression_investigation_new(
  code,
) -> ClinicalimpressionInvestigation {
  ClinicalimpressionInvestigation(
    item: [],
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ClinicalImpression#resource
pub type ClinicalimpressionFinding {
  ClinicalimpressionFinding(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item_codeable_concept: Option(Codeableconcept),
    item_reference: Option(Reference),
    basis: Option(String),
  )
}

pub fn clinicalimpression_finding_new() -> ClinicalimpressionFinding {
  ClinicalimpressionFinding(
    basis: None,
    item_reference: None,
    item_codeable_concept: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ClinicalUseDefinition#resource
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
    type_: r4bvaluesets.Clinicalusedefinitiontype,
    category: List(Codeableconcept),
    subject: List(Reference),
    status: Option(Codeableconcept),
    contraindication: Option(ClinicalusedefinitionContraindication),
    indication: Option(ClinicalusedefinitionIndication),
    interaction: Option(ClinicalusedefinitionInteraction),
    population: List(Reference),
    undesirable_effect: Option(ClinicalusedefinitionUndesirableeffect),
    warning: Option(ClinicalusedefinitionWarning),
  )
}

pub fn clinicalusedefinition_new(type_) -> Clinicalusedefinition {
  Clinicalusedefinition(
    warning: None,
    undesirable_effect: None,
    population: [],
    interaction: None,
    indication: None,
    contraindication: None,
    status: None,
    subject: [],
    category: [],
    type_:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ClinicalUseDefinition#resource
pub type ClinicalusedefinitionContraindication {
  ClinicalusedefinitionContraindication(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    disease_symptom_procedure: Option(Codeablereference),
    disease_status: Option(Codeablereference),
    comorbidity: List(Codeablereference),
    indication: List(Reference),
    other_therapy: List(ClinicalusedefinitionContraindicationOthertherapy),
  )
}

pub fn clinicalusedefinition_contraindication_new() -> ClinicalusedefinitionContraindication {
  ClinicalusedefinitionContraindication(
    other_therapy: [],
    indication: [],
    comorbidity: [],
    disease_status: None,
    disease_symptom_procedure: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ClinicalUseDefinition#resource
pub type ClinicalusedefinitionContraindicationOthertherapy {
  ClinicalusedefinitionContraindicationOthertherapy(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    relationship_type: Codeableconcept,
    therapy: Codeablereference,
  )
}

pub fn clinicalusedefinition_contraindication_othertherapy_new(
  therapy,
  relationship_type,
) -> ClinicalusedefinitionContraindicationOthertherapy {
  ClinicalusedefinitionContraindicationOthertherapy(
    therapy:,
    relationship_type:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ClinicalUseDefinition#resource
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
    other_therapy: List(Nil),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ClinicalUseDefinition#resource
pub type ClinicalusedefinitionIndicationDuration {
  ClinicalusedefinitionIndicationDurationRange(duration: Range)
  ClinicalusedefinitionIndicationDurationString(duration: String)
}

pub fn clinicalusedefinition_indication_new() -> ClinicalusedefinitionIndication {
  ClinicalusedefinitionIndication(
    other_therapy: [],
    undesirable_effect: [],
    duration: None,
    intended_effect: None,
    comorbidity: [],
    disease_status: None,
    disease_symptom_procedure: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ClinicalUseDefinition#resource
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

pub fn clinicalusedefinition_interaction_new() -> ClinicalusedefinitionInteraction {
  ClinicalusedefinitionInteraction(
    management: [],
    incidence: None,
    effect: None,
    type_: None,
    interactant: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ClinicalUseDefinition#resource
pub type ClinicalusedefinitionInteractionInteractant {
  ClinicalusedefinitionInteractionInteractant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item: ClinicalusedefinitionInteractionInteractantItem,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ClinicalUseDefinition#resource
pub type ClinicalusedefinitionInteractionInteractantItem {
  ClinicalusedefinitionInteractionInteractantItemReference(item: Reference)
  ClinicalusedefinitionInteractionInteractantItemCodeableconcept(
    item: Codeableconcept,
  )
}

pub fn clinicalusedefinition_interaction_interactant_new(
  item,
) -> ClinicalusedefinitionInteractionInteractant {
  ClinicalusedefinitionInteractionInteractant(
    item:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ClinicalUseDefinition#resource
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

pub fn clinicalusedefinition_undesirableeffect_new() -> ClinicalusedefinitionUndesirableeffect {
  ClinicalusedefinitionUndesirableeffect(
    frequency_of_occurrence: None,
    classification: None,
    symptom_condition_effect: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ClinicalUseDefinition#resource
pub type ClinicalusedefinitionWarning {
  ClinicalusedefinitionWarning(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    code: Option(Codeableconcept),
  )
}

pub fn clinicalusedefinition_warning_new() -> ClinicalusedefinitionWarning {
  ClinicalusedefinitionWarning(
    code: None,
    description: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CodeSystem#resource
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
    name: Option(String),
    title: Option(String),
    status: r4bvaluesets.Publicationstatus,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    case_sensitive: Option(Bool),
    value_set: Option(String),
    hierarchy_meaning: Option(r4bvaluesets.Codesystemhierarchymeaning),
    compositional: Option(Bool),
    version_needed: Option(Bool),
    content: r4bvaluesets.Codesystemcontentmode,
    supplements: Option(String),
    count: Option(Int),
    filter: List(CodesystemFilter),
    property: List(CodesystemProperty),
    concept: List(CodesystemConcept),
  )
}

pub fn codesystem_new(content, status) -> Codesystem {
  Codesystem(
    concept: [],
    property: [],
    filter: [],
    count: None,
    supplements: None,
    content:,
    version_needed: None,
    compositional: None,
    hierarchy_meaning: None,
    value_set: None,
    case_sensitive: None,
    copyright: None,
    purpose: None,
    jurisdiction: [],
    use_context: [],
    description: None,
    contact: [],
    publisher: None,
    date: None,
    experimental: None,
    status:,
    title: None,
    name: None,
    version: None,
    identifier: [],
    url: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CodeSystem#resource
pub type CodesystemFilter {
  CodesystemFilter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    description: Option(String),
    operator: List(r4bvaluesets.Filteroperator),
    value: String,
  )
}

pub fn codesystem_filter_new(value, code) -> CodesystemFilter {
  CodesystemFilter(
    value:,
    operator: [],
    description: None,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CodeSystem#resource
pub type CodesystemProperty {
  CodesystemProperty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    uri: Option(String),
    description: Option(String),
    type_: r4bvaluesets.Conceptpropertytype,
  )
}

pub fn codesystem_property_new(type_, code) -> CodesystemProperty {
  CodesystemProperty(
    type_:,
    description: None,
    uri: None,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CodeSystem#resource
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

pub fn codesystem_concept_new(code) -> CodesystemConcept {
  CodesystemConcept(
    concept: [],
    property: [],
    designation: [],
    definition: None,
    display: None,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CodeSystem#resource
pub type CodesystemConceptDesignation {
  CodesystemConceptDesignation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    language: Option(String),
    use_: Option(Coding),
    value: String,
  )
}

pub fn codesystem_concept_designation_new(value) -> CodesystemConceptDesignation {
  CodesystemConceptDesignation(
    value:,
    use_: None,
    language: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CodeSystem#resource
pub type CodesystemConceptProperty {
  CodesystemConceptProperty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    value: CodesystemConceptPropertyValue,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CodeSystem#resource
pub type CodesystemConceptPropertyValue {
  CodesystemConceptPropertyValueCode(value: String)
  CodesystemConceptPropertyValueCoding(value: Coding)
  CodesystemConceptPropertyValueString(value: String)
  CodesystemConceptPropertyValueInteger(value: Int)
  CodesystemConceptPropertyValueBoolean(value: Bool)
  CodesystemConceptPropertyValueDatetime(value: String)
  CodesystemConceptPropertyValueDecimal(value: Float)
}

pub fn codesystem_concept_property_new(value, code) -> CodesystemConceptProperty {
  CodesystemConceptProperty(
    value:,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Communication#resource
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
    status: r4bvaluesets.Eventstatus,
    status_reason: Option(Codeableconcept),
    category: List(Codeableconcept),
    priority: Option(r4bvaluesets.Requestpriority),
    medium: List(Codeableconcept),
    subject: Option(Reference),
    topic: Option(Codeableconcept),
    about: List(Reference),
    encounter: Option(Reference),
    sent: Option(String),
    received: Option(String),
    recipient: List(Reference),
    sender: Option(Reference),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    payload: List(CommunicationPayload),
    note: List(Annotation),
  )
}

pub fn communication_new(status) -> Communication {
  Communication(
    note: [],
    payload: [],
    reason_reference: [],
    reason_code: [],
    sender: None,
    recipient: [],
    received: None,
    sent: None,
    encounter: None,
    about: [],
    topic: None,
    subject: None,
    medium: [],
    priority: None,
    category: [],
    status_reason: None,
    status:,
    in_response_to: [],
    part_of: [],
    based_on: [],
    instantiates_uri: [],
    instantiates_canonical: [],
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Communication#resource
pub type CommunicationPayload {
  CommunicationPayload(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    content: CommunicationPayloadContent,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Communication#resource
pub type CommunicationPayloadContent {
  CommunicationPayloadContentString(content: String)
  CommunicationPayloadContentAttachment(content: Attachment)
  CommunicationPayloadContentReference(content: Reference)
}

pub fn communication_payload_new(content) -> CommunicationPayload {
  CommunicationPayload(
    content:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CommunicationRequest#resource
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
    status: r4bvaluesets.Requeststatus,
    status_reason: Option(Codeableconcept),
    category: List(Codeableconcept),
    priority: Option(r4bvaluesets.Requestpriority),
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
    sender: Option(Reference),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    note: List(Annotation),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CommunicationRequest#resource
pub type CommunicationrequestOccurrence {
  CommunicationrequestOccurrenceDatetime(occurrence: String)
  CommunicationrequestOccurrencePeriod(occurrence: Period)
}

pub fn communicationrequest_new(status) -> Communicationrequest {
  Communicationrequest(
    note: [],
    reason_reference: [],
    reason_code: [],
    sender: None,
    recipient: [],
    requester: None,
    authored_on: None,
    occurrence: None,
    payload: [],
    encounter: None,
    about: [],
    subject: None,
    medium: [],
    do_not_perform: None,
    priority: None,
    category: [],
    status_reason: None,
    status:,
    group_identifier: None,
    replaces: [],
    based_on: [],
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CommunicationRequest#resource
pub type CommunicationrequestPayload {
  CommunicationrequestPayload(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    content: CommunicationrequestPayloadContent,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CommunicationRequest#resource
pub type CommunicationrequestPayloadContent {
  CommunicationrequestPayloadContentString(content: String)
  CommunicationrequestPayloadContentAttachment(content: Attachment)
  CommunicationrequestPayloadContentReference(content: Reference)
}

pub fn communicationrequest_payload_new(content) -> CommunicationrequestPayload {
  CommunicationrequestPayload(
    content:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CompartmentDefinition#resource
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
    name: String,
    status: r4bvaluesets.Publicationstatus,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    purpose: Option(String),
    code: r4bvaluesets.Compartmenttype,
    search: Bool,
    resource: List(CompartmentdefinitionResource),
  )
}

pub fn compartmentdefinition_new(
  search,
  code,
  status,
  name,
  url,
) -> Compartmentdefinition {
  Compartmentdefinition(
    resource: [],
    search:,
    code:,
    purpose: None,
    use_context: [],
    description: None,
    contact: [],
    publisher: None,
    date: None,
    experimental: None,
    status:,
    name:,
    version: None,
    url:,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CompartmentDefinition#resource
pub type CompartmentdefinitionResource {
  CompartmentdefinitionResource(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: r4bvaluesets.Resourcetypes,
    param: List(String),
    documentation: Option(String),
  )
}

pub fn compartmentdefinition_resource_new(code) -> CompartmentdefinitionResource {
  CompartmentdefinitionResource(
    documentation: None,
    param: [],
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Composition#resource
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
    identifier: Option(Identifier),
    status: r4bvaluesets.Compositionstatus,
    type_: Codeableconcept,
    category: List(Codeableconcept),
    subject: Option(Reference),
    encounter: Option(Reference),
    date: String,
    author: List(Reference),
    title: String,
    confidentiality: Option(String),
    attester: List(CompositionAttester),
    custodian: Option(Reference),
    relates_to: List(CompositionRelatesto),
    event: List(CompositionEvent),
    section: List(CompositionSection),
  )
}

pub fn composition_new(title, date, type_, status) -> Composition {
  Composition(
    section: [],
    event: [],
    relates_to: [],
    custodian: None,
    attester: [],
    confidentiality: None,
    title:,
    author: [],
    date:,
    encounter: None,
    subject: None,
    category: [],
    type_:,
    status:,
    identifier: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Composition#resource
pub type CompositionAttester {
  CompositionAttester(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    mode: r4bvaluesets.Compositionattestationmode,
    time: Option(String),
    party: Option(Reference),
  )
}

pub fn composition_attester_new(mode) -> CompositionAttester {
  CompositionAttester(
    party: None,
    time: None,
    mode:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Composition#resource
pub type CompositionRelatesto {
  CompositionRelatesto(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: r4bvaluesets.Documentrelationshiptype,
    target: CompositionRelatestoTarget,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Composition#resource
pub type CompositionRelatestoTarget {
  CompositionRelatestoTargetIdentifier(target: Identifier)
  CompositionRelatestoTargetReference(target: Reference)
}

pub fn composition_relatesto_new(target, code) -> CompositionRelatesto {
  CompositionRelatesto(
    target:,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Composition#resource
pub type CompositionEvent {
  CompositionEvent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: List(Codeableconcept),
    period: Option(Period),
    detail: List(Reference),
  )
}

pub fn composition_event_new() -> CompositionEvent {
  CompositionEvent(
    detail: [],
    period: None,
    code: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Composition#resource
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
    mode: Option(r4bvaluesets.Listmode),
    ordered_by: Option(Codeableconcept),
    entry: List(Reference),
    empty_reason: Option(Codeableconcept),
    section: List(Nil),
  )
}

pub fn composition_section_new() -> CompositionSection {
  CompositionSection(
    section: [],
    empty_reason: None,
    entry: [],
    ordered_by: None,
    mode: None,
    text: None,
    focus: None,
    author: [],
    code: None,
    title: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ConceptMap#resource
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
    identifier: Option(Identifier),
    version: Option(String),
    name: Option(String),
    title: Option(String),
    status: r4bvaluesets.Publicationstatus,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    source: Option(ConceptmapSource),
    target: Option(ConceptmapTarget),
    group: List(ConceptmapGroup),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ConceptMap#resource
pub type ConceptmapSource {
  ConceptmapSourceUri(source: String)
  ConceptmapSourceCanonical(source: String)
}

///http://hl7.org/fhir/r4b/StructureDefinition/ConceptMap#resource
pub type ConceptmapTarget {
  ConceptmapTargetUri(target: String)
  ConceptmapTargetCanonical(target: String)
}

pub fn conceptmap_new(status) -> Conceptmap {
  Conceptmap(
    group: [],
    target: None,
    source: None,
    copyright: None,
    purpose: None,
    jurisdiction: [],
    use_context: [],
    description: None,
    contact: [],
    publisher: None,
    date: None,
    experimental: None,
    status:,
    title: None,
    name: None,
    version: None,
    identifier: None,
    url: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ConceptMap#resource
pub type ConceptmapGroup {
  ConceptmapGroup(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    source: Option(String),
    source_version: Option(String),
    target: Option(String),
    target_version: Option(String),
    element: List(ConceptmapGroupElement),
    unmapped: Option(ConceptmapGroupUnmapped),
  )
}

pub fn conceptmap_group_new() -> ConceptmapGroup {
  ConceptmapGroup(
    unmapped: None,
    element: [],
    target_version: None,
    target: None,
    source_version: None,
    source: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ConceptMap#resource
pub type ConceptmapGroupElement {
  ConceptmapGroupElement(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(String),
    display: Option(String),
    target: List(ConceptmapGroupElementTarget),
  )
}

pub fn conceptmap_group_element_new() -> ConceptmapGroupElement {
  ConceptmapGroupElement(
    target: [],
    display: None,
    code: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ConceptMap#resource
pub type ConceptmapGroupElementTarget {
  ConceptmapGroupElementTarget(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(String),
    display: Option(String),
    equivalence: r4bvaluesets.Conceptmapequivalence,
    comment: Option(String),
    depends_on: List(ConceptmapGroupElementTargetDependson),
    product: List(Nil),
  )
}

pub fn conceptmap_group_element_target_new(
  equivalence,
) -> ConceptmapGroupElementTarget {
  ConceptmapGroupElementTarget(
    product: [],
    depends_on: [],
    comment: None,
    equivalence:,
    display: None,
    code: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ConceptMap#resource
pub type ConceptmapGroupElementTargetDependson {
  ConceptmapGroupElementTargetDependson(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    property: String,
    system: Option(String),
    value: String,
    display: Option(String),
  )
}

pub fn conceptmap_group_element_target_dependson_new(
  value,
  property,
) -> ConceptmapGroupElementTargetDependson {
  ConceptmapGroupElementTargetDependson(
    display: None,
    value:,
    system: None,
    property:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ConceptMap#resource
pub type ConceptmapGroupUnmapped {
  ConceptmapGroupUnmapped(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    mode: r4bvaluesets.Conceptmapunmappedmode,
    code: Option(String),
    display: Option(String),
    url: Option(String),
  )
}

pub fn conceptmap_group_unmapped_new(mode) -> ConceptmapGroupUnmapped {
  ConceptmapGroupUnmapped(
    url: None,
    display: None,
    code: None,
    mode:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Condition#resource
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
    clinical_status: Option(Codeableconcept),
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
    recorder: Option(Reference),
    asserter: Option(Reference),
    stage: List(ConditionStage),
    evidence: List(ConditionEvidence),
    note: List(Annotation),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Condition#resource
pub type ConditionOnset {
  ConditionOnsetDatetime(onset: String)
  ConditionOnsetAge(onset: Age)
  ConditionOnsetPeriod(onset: Period)
  ConditionOnsetRange(onset: Range)
  ConditionOnsetString(onset: String)
}

///http://hl7.org/fhir/r4b/StructureDefinition/Condition#resource
pub type ConditionAbatement {
  ConditionAbatementDatetime(abatement: String)
  ConditionAbatementAge(abatement: Age)
  ConditionAbatementPeriod(abatement: Period)
  ConditionAbatementRange(abatement: Range)
  ConditionAbatementString(abatement: String)
}

pub fn condition_new(subject) -> Condition {
  Condition(
    note: [],
    evidence: [],
    stage: [],
    asserter: None,
    recorder: None,
    recorded_date: None,
    abatement: None,
    onset: None,
    encounter: None,
    subject:,
    body_site: [],
    code: None,
    severity: None,
    category: [],
    verification_status: None,
    clinical_status: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Condition#resource
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

pub fn condition_stage_new() -> ConditionStage {
  ConditionStage(
    type_: None,
    assessment: [],
    summary: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Condition#resource
pub type ConditionEvidence {
  ConditionEvidence(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: List(Codeableconcept),
    detail: List(Reference),
  )
}

pub fn condition_evidence_new() -> ConditionEvidence {
  ConditionEvidence(
    detail: [],
    code: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Consent#resource
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
    status: r4bvaluesets.Consentstatecodes,
    scope: Codeableconcept,
    category: List(Codeableconcept),
    patient: Option(Reference),
    date_time: Option(String),
    performer: List(Reference),
    organization: List(Reference),
    source: Option(ConsentSource),
    policy: List(ConsentPolicy),
    policy_rule: Option(Codeableconcept),
    verification: List(ConsentVerification),
    provision: Option(ConsentProvision),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Consent#resource
pub type ConsentSource {
  ConsentSourceAttachment(source: Attachment)
  ConsentSourceReference(source: Reference)
}

pub fn consent_new(scope, status) -> Consent {
  Consent(
    provision: None,
    verification: [],
    policy_rule: None,
    policy: [],
    source: None,
    organization: [],
    performer: [],
    date_time: None,
    patient: None,
    category: [],
    scope:,
    status:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Consent#resource
pub type ConsentPolicy {
  ConsentPolicy(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    authority: Option(String),
    uri: Option(String),
  )
}

pub fn consent_policy_new() -> ConsentPolicy {
  ConsentPolicy(
    uri: None,
    authority: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Consent#resource
pub type ConsentVerification {
  ConsentVerification(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    verified: Bool,
    verified_with: Option(Reference),
    verification_date: Option(String),
  )
}

pub fn consent_verification_new(verified) -> ConsentVerification {
  ConsentVerification(
    verification_date: None,
    verified_with: None,
    verified:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Consent#resource
pub type ConsentProvision {
  ConsentProvision(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(r4bvaluesets.Consentprovisiontype),
    period: Option(Period),
    actor: List(ConsentProvisionActor),
    action: List(Codeableconcept),
    security_label: List(Coding),
    purpose: List(Coding),
    class: List(Coding),
    code: List(Codeableconcept),
    data_period: Option(Period),
    data: List(ConsentProvisionData),
    provision: List(Nil),
  )
}

pub fn consent_provision_new() -> ConsentProvision {
  ConsentProvision(
    provision: [],
    data: [],
    data_period: None,
    code: [],
    class: [],
    purpose: [],
    security_label: [],
    action: [],
    actor: [],
    period: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Consent#resource
pub type ConsentProvisionActor {
  ConsentProvisionActor(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    role: Codeableconcept,
    reference: Reference,
  )
}

pub fn consent_provision_actor_new(reference, role) -> ConsentProvisionActor {
  ConsentProvisionActor(
    reference:,
    role:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Consent#resource
pub type ConsentProvisionData {
  ConsentProvisionData(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    meaning: r4bvaluesets.Consentdatameaning,
    reference: Reference,
  )
}

pub fn consent_provision_data_new(reference, meaning) -> ConsentProvisionData {
  ConsentProvisionData(
    reference:,
    meaning:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Contract#resource
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
    status: Option(r4bvaluesets.Contractstatus),
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

///http://hl7.org/fhir/r4b/StructureDefinition/Contract#resource
pub type ContractTopic {
  ContractTopicCodeableconcept(topic: Codeableconcept)
  ContractTopicReference(topic: Reference)
}

///http://hl7.org/fhir/r4b/StructureDefinition/Contract#resource
pub type ContractLegallybinding {
  ContractLegallybindingAttachment(legally_binding: Attachment)
  ContractLegallybindingReference(legally_binding: Reference)
}

pub fn contract_new() -> Contract {
  Contract(
    legally_binding: None,
    rule: [],
    legal: [],
    friendly: [],
    signer: [],
    relevant_history: [],
    supporting_info: [],
    term: [],
    content_definition: None,
    sub_type: [],
    type_: None,
    topic: None,
    scope: None,
    author: None,
    alias: [],
    subtitle: None,
    title: None,
    name: None,
    site: [],
    domain: [],
    authority: [],
    subject: [],
    expiration_type: None,
    applies: None,
    issued: None,
    content_derivative: None,
    instantiates_uri: None,
    instantiates_canonical: None,
    legal_state: None,
    status: None,
    version: None,
    url: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Contract#resource
pub type ContractContentdefinition {
  ContractContentdefinition(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    sub_type: Option(Codeableconcept),
    publisher: Option(Reference),
    publication_date: Option(String),
    publication_status: r4bvaluesets.Contractpublicationstatus,
    copyright: Option(String),
  )
}

pub fn contract_contentdefinition_new(
  publication_status,
  type_,
) -> ContractContentdefinition {
  ContractContentdefinition(
    copyright: None,
    publication_status:,
    publication_date: None,
    publisher: None,
    sub_type: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Contract#resource
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

///http://hl7.org/fhir/r4b/StructureDefinition/Contract#resource
pub type ContractTermTopic {
  ContractTermTopicCodeableconcept(topic: Codeableconcept)
  ContractTermTopicReference(topic: Reference)
}

pub fn contract_term_new(offer) -> ContractTerm {
  ContractTerm(
    group: [],
    action: [],
    asset: [],
    offer:,
    security_label: [],
    text: None,
    sub_type: None,
    type_: None,
    topic: None,
    applies: None,
    issued: None,
    identifier: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Contract#resource
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

pub fn contract_term_securitylabel_new(
  classification,
) -> ContractTermSecuritylabel {
  ContractTermSecuritylabel(
    control: [],
    category: [],
    classification:,
    number: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Contract#resource
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

pub fn contract_term_offer_new() -> ContractTermOffer {
  ContractTermOffer(
    security_label_number: [],
    link_id: [],
    text: None,
    answer: [],
    decision_mode: [],
    decision: None,
    type_: None,
    topic: None,
    party: [],
    identifier: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Contract#resource
pub type ContractTermOfferParty {
  ContractTermOfferParty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    reference: List(Reference),
    role: Codeableconcept,
  )
}

pub fn contract_term_offer_party_new(role) -> ContractTermOfferParty {
  ContractTermOfferParty(
    role:,
    reference: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Contract#resource
pub type ContractTermOfferAnswer {
  ContractTermOfferAnswer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    value: ContractTermOfferAnswerValue,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Contract#resource
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

pub fn contract_term_offer_answer_new(value) -> ContractTermOfferAnswer {
  ContractTermOfferAnswer(
    value:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Contract#resource
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

pub fn contract_term_asset_new() -> ContractTermAsset {
  ContractTermAsset(
    valued_item: [],
    security_label_number: [],
    answer: [],
    link_id: [],
    text: None,
    use_period: [],
    period: [],
    period_type: [],
    condition: None,
    context: [],
    relationship: None,
    subtype: [],
    type_reference: [],
    type_: [],
    scope: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Contract#resource
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

pub fn contract_term_asset_context_new() -> ContractTermAssetContext {
  ContractTermAssetContext(
    text: None,
    code: [],
    reference: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Contract#resource
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

///http://hl7.org/fhir/r4b/StructureDefinition/Contract#resource
pub type ContractTermAssetValueditemEntity {
  ContractTermAssetValueditemEntityCodeableconcept(entity: Codeableconcept)
  ContractTermAssetValueditemEntityReference(entity: Reference)
}

pub fn contract_term_asset_valueditem_new() -> ContractTermAssetValueditem {
  ContractTermAssetValueditem(
    security_label_number: [],
    link_id: [],
    recipient: None,
    responsible: None,
    payment_date: None,
    payment: None,
    net: None,
    points: None,
    factor: None,
    unit_price: None,
    quantity: None,
    effective_time: None,
    identifier: None,
    entity: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Contract#resource
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
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    reason: List(String),
    reason_link_id: List(String),
    note: List(Annotation),
    security_label_number: List(Int),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Contract#resource
pub type ContractTermActionOccurrence {
  ContractTermActionOccurrenceDatetime(occurrence: String)
  ContractTermActionOccurrencePeriod(occurrence: Period)
  ContractTermActionOccurrenceTiming(occurrence: Timing)
}

pub fn contract_term_action_new(status, intent, type_) -> ContractTermAction {
  ContractTermAction(
    security_label_number: [],
    note: [],
    reason_link_id: [],
    reason: [],
    reason_reference: [],
    reason_code: [],
    performer_link_id: [],
    performer: None,
    performer_role: None,
    performer_type: [],
    requester_link_id: [],
    requester: [],
    occurrence: None,
    context_link_id: [],
    context: None,
    status:,
    link_id: [],
    intent:,
    subject: [],
    type_:,
    do_not_perform: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Contract#resource
pub type ContractTermActionSubject {
  ContractTermActionSubject(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    reference: List(Reference),
    role: Option(Codeableconcept),
  )
}

pub fn contract_term_action_subject_new() -> ContractTermActionSubject {
  ContractTermActionSubject(
    role: None,
    reference: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Contract#resource
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

pub fn contract_signer_new(party, type_) -> ContractSigner {
  ContractSigner(
    signature: [],
    party:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Contract#resource
pub type ContractFriendly {
  ContractFriendly(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    content: ContractFriendlyContent,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Contract#resource
pub type ContractFriendlyContent {
  ContractFriendlyContentAttachment(content: Attachment)
  ContractFriendlyContentReference(content: Reference)
}

pub fn contract_friendly_new(content) -> ContractFriendly {
  ContractFriendly(content:, modifier_extension: [], extension: [], id: None)
}

///http://hl7.org/fhir/r4b/StructureDefinition/Contract#resource
pub type ContractLegal {
  ContractLegal(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    content: ContractLegalContent,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Contract#resource
pub type ContractLegalContent {
  ContractLegalContentAttachment(content: Attachment)
  ContractLegalContentReference(content: Reference)
}

pub fn contract_legal_new(content) -> ContractLegal {
  ContractLegal(content:, modifier_extension: [], extension: [], id: None)
}

///http://hl7.org/fhir/r4b/StructureDefinition/Contract#resource
pub type ContractRule {
  ContractRule(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    content: ContractRuleContent,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Contract#resource
pub type ContractRuleContent {
  ContractRuleContentAttachment(content: Attachment)
  ContractRuleContentReference(content: Reference)
}

pub fn contract_rule_new(content) -> ContractRule {
  ContractRule(content:, modifier_extension: [], extension: [], id: None)
}

///http://hl7.org/fhir/r4b/StructureDefinition/Coverage#resource
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
    status: r4bvaluesets.Fmstatus,
    type_: Option(Codeableconcept),
    policy_holder: Option(Reference),
    subscriber: Option(Reference),
    subscriber_id: Option(String),
    beneficiary: Reference,
    dependent: Option(String),
    relationship: Option(Codeableconcept),
    period: Option(Period),
    payor: List(Reference),
    class: List(CoverageClass),
    order: Option(Int),
    network: Option(String),
    cost_to_beneficiary: List(CoverageCosttobeneficiary),
    subrogation: Option(Bool),
    contract: List(Reference),
  )
}

pub fn coverage_new(beneficiary, status) -> Coverage {
  Coverage(
    contract: [],
    subrogation: None,
    cost_to_beneficiary: [],
    network: None,
    order: None,
    class: [],
    payor: [],
    period: None,
    relationship: None,
    dependent: None,
    beneficiary:,
    subscriber_id: None,
    subscriber: None,
    policy_holder: None,
    type_: None,
    status:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Coverage#resource
pub type CoverageClass {
  CoverageClass(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value: String,
    name: Option(String),
  )
}

pub fn coverage_class_new(value, type_) -> CoverageClass {
  CoverageClass(
    name: None,
    value:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Coverage#resource
pub type CoverageCosttobeneficiary {
  CoverageCosttobeneficiary(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    value: CoverageCosttobeneficiaryValue,
    exception: List(CoverageCosttobeneficiaryException),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Coverage#resource
pub type CoverageCosttobeneficiaryValue {
  CoverageCosttobeneficiaryValueQuantity(value: Quantity)
  CoverageCosttobeneficiaryValueMoney(value: Money)
}

pub fn coverage_costtobeneficiary_new(value) -> CoverageCosttobeneficiary {
  CoverageCosttobeneficiary(
    exception: [],
    value:,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Coverage#resource
pub type CoverageCosttobeneficiaryException {
  CoverageCosttobeneficiaryException(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    period: Option(Period),
  )
}

pub fn coverage_costtobeneficiary_exception_new(
  type_,
) -> CoverageCosttobeneficiaryException {
  CoverageCosttobeneficiaryException(
    period: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CoverageEligibilityRequest#resource
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
    status: r4bvaluesets.Fmstatus,
    priority: Option(Codeableconcept),
    purpose: List(r4bvaluesets.Eligibilityrequestpurpose),
    patient: Reference,
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

///http://hl7.org/fhir/r4b/StructureDefinition/CoverageEligibilityRequest#resource
pub type CoverageeligibilityrequestServiced {
  CoverageeligibilityrequestServicedDate(serviced: String)
  CoverageeligibilityrequestServicedPeriod(serviced: Period)
}

pub fn coverageeligibilityrequest_new(
  insurer,
  created,
  patient,
  status,
) -> Coverageeligibilityrequest {
  Coverageeligibilityrequest(
    item: [],
    insurance: [],
    supporting_info: [],
    facility: None,
    insurer:,
    provider: None,
    enterer: None,
    created:,
    serviced: None,
    patient:,
    purpose: [],
    priority: None,
    status:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CoverageEligibilityRequest#resource
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

pub fn coverageeligibilityrequest_supportinginfo_new(
  information,
  sequence,
) -> CoverageeligibilityrequestSupportinginfo {
  CoverageeligibilityrequestSupportinginfo(
    applies_to_all: None,
    information:,
    sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CoverageEligibilityRequest#resource
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

pub fn coverageeligibilityrequest_insurance_new(
  coverage,
) -> CoverageeligibilityrequestInsurance {
  CoverageeligibilityrequestInsurance(
    business_arrangement: None,
    coverage:,
    focal: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CoverageEligibilityRequest#resource
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

pub fn coverageeligibilityrequest_item_new() -> CoverageeligibilityrequestItem {
  CoverageeligibilityrequestItem(
    detail: [],
    diagnosis: [],
    facility: None,
    unit_price: None,
    quantity: None,
    provider: None,
    modifier: [],
    product_or_service: None,
    category: None,
    supporting_info_sequence: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CoverageEligibilityRequest#resource
pub type CoverageeligibilityrequestItemDiagnosis {
  CoverageeligibilityrequestItemDiagnosis(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    diagnosis: Option(CoverageeligibilityrequestItemDiagnosisDiagnosis),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CoverageEligibilityRequest#resource
pub type CoverageeligibilityrequestItemDiagnosisDiagnosis {
  CoverageeligibilityrequestItemDiagnosisDiagnosisCodeableconcept(
    diagnosis: Codeableconcept,
  )
  CoverageeligibilityrequestItemDiagnosisDiagnosisReference(
    diagnosis: Reference,
  )
}

pub fn coverageeligibilityrequest_item_diagnosis_new() -> CoverageeligibilityrequestItemDiagnosis {
  CoverageeligibilityrequestItemDiagnosis(
    diagnosis: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CoverageEligibilityResponse#resource
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
    status: r4bvaluesets.Fmstatus,
    purpose: List(r4bvaluesets.Eligibilityresponsepurpose),
    patient: Reference,
    serviced: Option(CoverageeligibilityresponseServiced),
    created: String,
    requestor: Option(Reference),
    request: Reference,
    outcome: r4bvaluesets.Remittanceoutcome,
    disposition: Option(String),
    insurer: Reference,
    insurance: List(CoverageeligibilityresponseInsurance),
    pre_auth_ref: Option(String),
    form: Option(Codeableconcept),
    error: List(CoverageeligibilityresponseError),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CoverageEligibilityResponse#resource
pub type CoverageeligibilityresponseServiced {
  CoverageeligibilityresponseServicedDate(serviced: String)
  CoverageeligibilityresponseServicedPeriod(serviced: Period)
}

pub fn coverageeligibilityresponse_new(
  insurer,
  outcome,
  request,
  created,
  patient,
  status,
) -> Coverageeligibilityresponse {
  Coverageeligibilityresponse(
    error: [],
    form: None,
    pre_auth_ref: None,
    insurance: [],
    insurer:,
    disposition: None,
    outcome:,
    request:,
    requestor: None,
    created:,
    serviced: None,
    patient:,
    purpose: [],
    status:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CoverageEligibilityResponse#resource
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

pub fn coverageeligibilityresponse_insurance_new(
  coverage,
) -> CoverageeligibilityresponseInsurance {
  CoverageeligibilityresponseInsurance(
    item: [],
    benefit_period: None,
    inforce: None,
    coverage:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CoverageEligibilityResponse#resource
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

pub fn coverageeligibilityresponse_insurance_item_new() -> CoverageeligibilityresponseInsuranceItem {
  CoverageeligibilityresponseInsuranceItem(
    authorization_url: None,
    authorization_supporting: [],
    authorization_required: None,
    benefit: [],
    term: None,
    unit: None,
    network: None,
    description: None,
    name: None,
    excluded: None,
    provider: None,
    modifier: [],
    product_or_service: None,
    category: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CoverageEligibilityResponse#resource
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

///http://hl7.org/fhir/r4b/StructureDefinition/CoverageEligibilityResponse#resource
pub type CoverageeligibilityresponseInsuranceItemBenefitAllowed {
  CoverageeligibilityresponseInsuranceItemBenefitAllowedUnsignedint(
    allowed: Int,
  )
  CoverageeligibilityresponseInsuranceItemBenefitAllowedString(allowed: String)
  CoverageeligibilityresponseInsuranceItemBenefitAllowedMoney(allowed: Money)
}

///http://hl7.org/fhir/r4b/StructureDefinition/CoverageEligibilityResponse#resource
pub type CoverageeligibilityresponseInsuranceItemBenefitUsed {
  CoverageeligibilityresponseInsuranceItemBenefitUsedUnsignedint(used: Int)
  CoverageeligibilityresponseInsuranceItemBenefitUsedString(used: String)
  CoverageeligibilityresponseInsuranceItemBenefitUsedMoney(used: Money)
}

pub fn coverageeligibilityresponse_insurance_item_benefit_new(
  type_,
) -> CoverageeligibilityresponseInsuranceItemBenefit {
  CoverageeligibilityresponseInsuranceItemBenefit(
    used: None,
    allowed: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/CoverageEligibilityResponse#resource
pub type CoverageeligibilityresponseError {
  CoverageeligibilityresponseError(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
  )
}

pub fn coverageeligibilityresponse_error_new(
  code,
) -> CoverageeligibilityresponseError {
  CoverageeligibilityresponseError(
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DetectedIssue#resource
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
    status: r4bvaluesets.Observationstatus,
    code: Option(Codeableconcept),
    severity: Option(r4bvaluesets.Detectedissueseverity),
    patient: Option(Reference),
    identified: Option(DetectedissueIdentified),
    author: Option(Reference),
    implicated: List(Reference),
    evidence: List(DetectedissueEvidence),
    detail: Option(String),
    reference: Option(String),
    mitigation: List(DetectedissueMitigation),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DetectedIssue#resource
pub type DetectedissueIdentified {
  DetectedissueIdentifiedDatetime(identified: String)
  DetectedissueIdentifiedPeriod(identified: Period)
}

pub fn detectedissue_new(status) -> Detectedissue {
  Detectedissue(
    mitigation: [],
    reference: None,
    detail: None,
    evidence: [],
    implicated: [],
    author: None,
    identified: None,
    patient: None,
    severity: None,
    code: None,
    status:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DetectedIssue#resource
pub type DetectedissueEvidence {
  DetectedissueEvidence(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: List(Codeableconcept),
    detail: List(Reference),
  )
}

pub fn detectedissue_evidence_new() -> DetectedissueEvidence {
  DetectedissueEvidence(
    detail: [],
    code: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DetectedIssue#resource
pub type DetectedissueMitigation {
  DetectedissueMitigation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    action: Codeableconcept,
    date: Option(String),
    author: Option(Reference),
  )
}

pub fn detectedissue_mitigation_new(action) -> DetectedissueMitigation {
  DetectedissueMitigation(
    author: None,
    date: None,
    action:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Device#resource
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
    definition: Option(Reference),
    udi_carrier: List(DeviceUdicarrier),
    status: Option(r4bvaluesets.Devicestatus),
    status_reason: List(Codeableconcept),
    distinct_identifier: Option(String),
    manufacturer: Option(String),
    manufacture_date: Option(String),
    expiration_date: Option(String),
    lot_number: Option(String),
    serial_number: Option(String),
    device_name: List(DeviceDevicename),
    model_number: Option(String),
    part_number: Option(String),
    type_: Option(Codeableconcept),
    specialization: List(DeviceSpecialization),
    version: List(DeviceVersion),
    property: List(DeviceProperty),
    patient: Option(Reference),
    owner: Option(Reference),
    contact: List(Contactpoint),
    location: Option(Reference),
    url: Option(String),
    note: List(Annotation),
    safety: List(Codeableconcept),
    parent: Option(Reference),
  )
}

pub fn device_new() -> Device {
  Device(
    parent: None,
    safety: [],
    note: [],
    url: None,
    location: None,
    contact: [],
    owner: None,
    patient: None,
    property: [],
    version: [],
    specialization: [],
    type_: None,
    part_number: None,
    model_number: None,
    device_name: [],
    serial_number: None,
    lot_number: None,
    expiration_date: None,
    manufacture_date: None,
    manufacturer: None,
    distinct_identifier: None,
    status_reason: [],
    status: None,
    udi_carrier: [],
    definition: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Device#resource
pub type DeviceUdicarrier {
  DeviceUdicarrier(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    device_identifier: Option(String),
    issuer: Option(String),
    jurisdiction: Option(String),
    carrier_aidc: Option(String),
    carrier_hrf: Option(String),
    entry_type: Option(r4bvaluesets.Udientrytype),
  )
}

pub fn device_udicarrier_new() -> DeviceUdicarrier {
  DeviceUdicarrier(
    entry_type: None,
    carrier_hrf: None,
    carrier_aidc: None,
    jurisdiction: None,
    issuer: None,
    device_identifier: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Device#resource
pub type DeviceDevicename {
  DeviceDevicename(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    type_: r4bvaluesets.Devicenametype,
  )
}

pub fn device_devicename_new(type_, name) -> DeviceDevicename {
  DeviceDevicename(
    type_:,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Device#resource
pub type DeviceSpecialization {
  DeviceSpecialization(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    system_type: Codeableconcept,
    version: Option(String),
  )
}

pub fn device_specialization_new(system_type) -> DeviceSpecialization {
  DeviceSpecialization(
    version: None,
    system_type:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Device#resource
pub type DeviceVersion {
  DeviceVersion(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    component: Option(Identifier),
    value: String,
  )
}

pub fn device_version_new(value) -> DeviceVersion {
  DeviceVersion(
    value:,
    component: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Device#resource
pub type DeviceProperty {
  DeviceProperty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value_quantity: List(Quantity),
    value_code: List(Codeableconcept),
  )
}

pub fn device_property_new(type_) -> DeviceProperty {
  DeviceProperty(
    value_code: [],
    value_quantity: [],
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DeviceDefinition#resource
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
    identifier: List(Identifier),
    udi_device_identifier: List(DevicedefinitionUdideviceidentifier),
    manufacturer: Option(DevicedefinitionManufacturer),
    device_name: List(DevicedefinitionDevicename),
    model_number: Option(String),
    type_: Option(Codeableconcept),
    specialization: List(DevicedefinitionSpecialization),
    version: List(String),
    safety: List(Codeableconcept),
    shelf_life_storage: List(Productshelflife),
    physical_characteristics: Option(Prodcharacteristic),
    language_code: List(Codeableconcept),
    capability: List(DevicedefinitionCapability),
    property: List(DevicedefinitionProperty),
    owner: Option(Reference),
    contact: List(Contactpoint),
    url: Option(String),
    online_information: Option(String),
    note: List(Annotation),
    quantity: Option(Quantity),
    parent_device: Option(Reference),
    material: List(DevicedefinitionMaterial),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionManufacturer {
  DevicedefinitionManufacturerString(manufacturer: String)
  DevicedefinitionManufacturerReference(manufacturer: Reference)
}

pub fn devicedefinition_new() -> Devicedefinition {
  Devicedefinition(
    material: [],
    parent_device: None,
    quantity: None,
    note: [],
    online_information: None,
    url: None,
    contact: [],
    owner: None,
    property: [],
    capability: [],
    language_code: [],
    physical_characteristics: None,
    shelf_life_storage: [],
    safety: [],
    version: [],
    specialization: [],
    type_: None,
    model_number: None,
    device_name: [],
    manufacturer: None,
    udi_device_identifier: [],
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionUdideviceidentifier {
  DevicedefinitionUdideviceidentifier(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    device_identifier: String,
    issuer: String,
    jurisdiction: String,
  )
}

pub fn devicedefinition_udideviceidentifier_new(
  jurisdiction,
  issuer,
  device_identifier,
) -> DevicedefinitionUdideviceidentifier {
  DevicedefinitionUdideviceidentifier(
    jurisdiction:,
    issuer:,
    device_identifier:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionDevicename {
  DevicedefinitionDevicename(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    type_: r4bvaluesets.Devicenametype,
  )
}

pub fn devicedefinition_devicename_new(
  type_,
  name,
) -> DevicedefinitionDevicename {
  DevicedefinitionDevicename(
    type_:,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionSpecialization {
  DevicedefinitionSpecialization(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    system_type: String,
    version: Option(String),
  )
}

pub fn devicedefinition_specialization_new(
  system_type,
) -> DevicedefinitionSpecialization {
  DevicedefinitionSpecialization(
    version: None,
    system_type:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionCapability {
  DevicedefinitionCapability(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    description: List(Codeableconcept),
  )
}

pub fn devicedefinition_capability_new(type_) -> DevicedefinitionCapability {
  DevicedefinitionCapability(
    description: [],
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionProperty {
  DevicedefinitionProperty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value_quantity: List(Quantity),
    value_code: List(Codeableconcept),
  )
}

pub fn devicedefinition_property_new(type_) -> DevicedefinitionProperty {
  DevicedefinitionProperty(
    value_code: [],
    value_quantity: [],
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DeviceDefinition#resource
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

pub fn devicedefinition_material_new(substance) -> DevicedefinitionMaterial {
  DevicedefinitionMaterial(
    allergenic_indicator: None,
    alternate: None,
    substance:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DeviceMetric#resource
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
    source: Option(Reference),
    parent: Option(Reference),
    operational_status: Option(r4bvaluesets.Metricoperationalstatus),
    color: Option(r4bvaluesets.Metriccolor),
    category: r4bvaluesets.Metriccategory,
    measurement_period: Option(Timing),
    calibration: List(DevicemetricCalibration),
  )
}

pub fn devicemetric_new(category, type_) -> Devicemetric {
  Devicemetric(
    calibration: [],
    measurement_period: None,
    category:,
    color: None,
    operational_status: None,
    parent: None,
    source: None,
    unit: None,
    type_:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DeviceMetric#resource
pub type DevicemetricCalibration {
  DevicemetricCalibration(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(r4bvaluesets.Metriccalibrationtype),
    state: Option(r4bvaluesets.Metriccalibrationstate),
    time: Option(String),
  )
}

pub fn devicemetric_calibration_new() -> DevicemetricCalibration {
  DevicemetricCalibration(
    time: None,
    state: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DeviceRequest#resource
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
    prior_request: List(Reference),
    group_identifier: Option(Identifier),
    status: Option(r4bvaluesets.Requeststatus),
    intent: r4bvaluesets.Requestintent,
    priority: Option(r4bvaluesets.Requestpriority),
    code: DevicerequestCode,
    parameter: List(DevicerequestParameter),
    subject: Reference,
    encounter: Option(Reference),
    occurrence: Option(DevicerequestOccurrence),
    authored_on: Option(String),
    requester: Option(Reference),
    performer_type: Option(Codeableconcept),
    performer: Option(Reference),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    insurance: List(Reference),
    supporting_info: List(Reference),
    note: List(Annotation),
    relevant_history: List(Reference),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DeviceRequest#resource
pub type DevicerequestCode {
  DevicerequestCodeReference(code: Reference)
  DevicerequestCodeCodeableconcept(code: Codeableconcept)
}

///http://hl7.org/fhir/r4b/StructureDefinition/DeviceRequest#resource
pub type DevicerequestOccurrence {
  DevicerequestOccurrenceDatetime(occurrence: String)
  DevicerequestOccurrencePeriod(occurrence: Period)
  DevicerequestOccurrenceTiming(occurrence: Timing)
}

pub fn devicerequest_new(subject, code, intent) -> Devicerequest {
  Devicerequest(
    relevant_history: [],
    note: [],
    supporting_info: [],
    insurance: [],
    reason_reference: [],
    reason_code: [],
    performer: None,
    performer_type: None,
    requester: None,
    authored_on: None,
    occurrence: None,
    encounter: None,
    subject:,
    parameter: [],
    code:,
    priority: None,
    intent:,
    status: None,
    group_identifier: None,
    prior_request: [],
    based_on: [],
    instantiates_uri: [],
    instantiates_canonical: [],
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DeviceRequest#resource
pub type DevicerequestParameter {
  DevicerequestParameter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(Codeableconcept),
    value: Option(DevicerequestParameterValue),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DeviceRequest#resource
pub type DevicerequestParameterValue {
  DevicerequestParameterValueCodeableconcept(value: Codeableconcept)
  DevicerequestParameterValueQuantity(value: Quantity)
  DevicerequestParameterValueRange(value: Range)
  DevicerequestParameterValueBoolean(value: Bool)
}

pub fn devicerequest_parameter_new() -> DevicerequestParameter {
  DevicerequestParameter(
    value: None,
    code: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DeviceUseStatement#resource
pub type Deviceusestatement {
  Deviceusestatement(
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
    status: r4bvaluesets.Devicestatementstatus,
    subject: Reference,
    derived_from: List(Reference),
    timing: Option(DeviceusestatementTiming),
    recorded_on: Option(String),
    source: Option(Reference),
    device: Reference,
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    body_site: Option(Codeableconcept),
    note: List(Annotation),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DeviceUseStatement#resource
pub type DeviceusestatementTiming {
  DeviceusestatementTimingTiming(timing: Timing)
  DeviceusestatementTimingPeriod(timing: Period)
  DeviceusestatementTimingDatetime(timing: String)
}

pub fn deviceusestatement_new(device, subject, status) -> Deviceusestatement {
  Deviceusestatement(
    note: [],
    body_site: None,
    reason_reference: [],
    reason_code: [],
    device:,
    source: None,
    recorded_on: None,
    timing: None,
    derived_from: [],
    subject:,
    status:,
    based_on: [],
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DiagnosticReport#resource
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
    status: r4bvaluesets.Diagnosticreportstatus,
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
    imaging_study: List(Reference),
    media: List(DiagnosticreportMedia),
    conclusion: Option(String),
    conclusion_code: List(Codeableconcept),
    presented_form: List(Attachment),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DiagnosticReport#resource
pub type DiagnosticreportEffective {
  DiagnosticreportEffectiveDatetime(effective: String)
  DiagnosticreportEffectivePeriod(effective: Period)
}

pub fn diagnosticreport_new(code, status) -> Diagnosticreport {
  Diagnosticreport(
    presented_form: [],
    conclusion_code: [],
    conclusion: None,
    media: [],
    imaging_study: [],
    result: [],
    specimen: [],
    results_interpreter: [],
    performer: [],
    issued: None,
    effective: None,
    encounter: None,
    subject: None,
    code:,
    category: [],
    status:,
    based_on: [],
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DiagnosticReport#resource
pub type DiagnosticreportMedia {
  DiagnosticreportMedia(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    comment: Option(String),
    link: Reference,
  )
}

pub fn diagnosticreport_media_new(link) -> DiagnosticreportMedia {
  DiagnosticreportMedia(
    link:,
    comment: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DocumentManifest#resource
pub type Documentmanifest {
  Documentmanifest(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    master_identifier: Option(Identifier),
    identifier: List(Identifier),
    status: r4bvaluesets.Documentreferencestatus,
    type_: Option(Codeableconcept),
    subject: Option(Reference),
    created: Option(String),
    author: List(Reference),
    recipient: List(Reference),
    source: Option(String),
    description: Option(String),
    content: List(Reference),
    related: List(DocumentmanifestRelated),
  )
}

pub fn documentmanifest_new(status) -> Documentmanifest {
  Documentmanifest(
    related: [],
    content: [],
    description: None,
    source: None,
    recipient: [],
    author: [],
    created: None,
    subject: None,
    type_: None,
    status:,
    identifier: [],
    master_identifier: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DocumentManifest#resource
pub type DocumentmanifestRelated {
  DocumentmanifestRelated(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Option(Identifier),
    ref: Option(Reference),
  )
}

pub fn documentmanifest_related_new() -> DocumentmanifestRelated {
  DocumentmanifestRelated(
    ref: None,
    identifier: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DocumentReference#resource
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
    master_identifier: Option(Identifier),
    identifier: List(Identifier),
    status: r4bvaluesets.Documentreferencestatus,
    doc_status: Option(r4bvaluesets.Compositionstatus),
    type_: Option(Codeableconcept),
    category: List(Codeableconcept),
    subject: Option(Reference),
    date: Option(String),
    author: List(Reference),
    authenticator: Option(Reference),
    custodian: Option(Reference),
    relates_to: List(DocumentreferenceRelatesto),
    description: Option(String),
    security_label: List(Codeableconcept),
    content: List(DocumentreferenceContent),
    context: Option(DocumentreferenceContext),
  )
}

pub fn documentreference_new(status) -> Documentreference {
  Documentreference(
    context: None,
    content: [],
    security_label: [],
    description: None,
    relates_to: [],
    custodian: None,
    authenticator: None,
    author: [],
    date: None,
    subject: None,
    category: [],
    type_: None,
    doc_status: None,
    status:,
    identifier: [],
    master_identifier: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DocumentReference#resource
pub type DocumentreferenceRelatesto {
  DocumentreferenceRelatesto(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: r4bvaluesets.Documentrelationshiptype,
    target: Reference,
  )
}

pub fn documentreference_relatesto_new(
  target,
  code,
) -> DocumentreferenceRelatesto {
  DocumentreferenceRelatesto(
    target:,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DocumentReference#resource
pub type DocumentreferenceContent {
  DocumentreferenceContent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    attachment: Attachment,
    format: Option(Coding),
  )
}

pub fn documentreference_content_new(attachment) -> DocumentreferenceContent {
  DocumentreferenceContent(
    format: None,
    attachment:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DocumentReference#resource
pub type DocumentreferenceContext {
  DocumentreferenceContext(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    encounter: List(Reference),
    event: List(Codeableconcept),
    period: Option(Period),
    facility_type: Option(Codeableconcept),
    practice_setting: Option(Codeableconcept),
    source_patient_info: Option(Reference),
    related: List(Reference),
  )
}

pub fn documentreference_context_new() -> DocumentreferenceContext {
  DocumentreferenceContext(
    related: [],
    source_patient_info: None,
    practice_setting: None,
    facility_type: None,
    period: None,
    event: [],
    encounter: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/DomainResource#resource
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

pub fn domainresource_new() -> Domainresource {
  Domainresource(
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Encounter#resource
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
    status: r4bvaluesets.Encounterstatus,
    status_history: List(EncounterStatushistory),
    class: Coding,
    class_history: List(EncounterClasshistory),
    type_: List(Codeableconcept),
    service_type: Option(Codeableconcept),
    priority: Option(Codeableconcept),
    subject: Option(Reference),
    episode_of_care: List(Reference),
    based_on: List(Reference),
    participant: List(EncounterParticipant),
    appointment: List(Reference),
    period: Option(Period),
    length: Option(Duration),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    diagnosis: List(EncounterDiagnosis),
    account: List(Reference),
    hospitalization: Option(EncounterHospitalization),
    location: List(EncounterLocation),
    service_provider: Option(Reference),
    part_of: Option(Reference),
  )
}

pub fn encounter_new(class, status) -> Encounter {
  Encounter(
    part_of: None,
    service_provider: None,
    location: [],
    hospitalization: None,
    account: [],
    diagnosis: [],
    reason_reference: [],
    reason_code: [],
    length: None,
    period: None,
    appointment: [],
    participant: [],
    based_on: [],
    episode_of_care: [],
    subject: None,
    priority: None,
    service_type: None,
    type_: [],
    class_history: [],
    class:,
    status_history: [],
    status:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Encounter#resource
pub type EncounterStatushistory {
  EncounterStatushistory(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    status: r4bvaluesets.Encounterstatus,
    period: Period,
  )
}

pub fn encounter_statushistory_new(period, status) -> EncounterStatushistory {
  EncounterStatushistory(
    period:,
    status:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Encounter#resource
pub type EncounterClasshistory {
  EncounterClasshistory(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    class: Coding,
    period: Period,
  )
}

pub fn encounter_classhistory_new(period, class) -> EncounterClasshistory {
  EncounterClasshistory(
    period:,
    class:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Encounter#resource
pub type EncounterParticipant {
  EncounterParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: List(Codeableconcept),
    period: Option(Period),
    individual: Option(Reference),
  )
}

pub fn encounter_participant_new() -> EncounterParticipant {
  EncounterParticipant(
    individual: None,
    period: None,
    type_: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Encounter#resource
pub type EncounterDiagnosis {
  EncounterDiagnosis(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    condition: Reference,
    use_: Option(Codeableconcept),
    rank: Option(Int),
  )
}

pub fn encounter_diagnosis_new(condition) -> EncounterDiagnosis {
  EncounterDiagnosis(
    rank: None,
    use_: None,
    condition:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Encounter#resource
pub type EncounterHospitalization {
  EncounterHospitalization(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    pre_admission_identifier: Option(Identifier),
    origin: Option(Reference),
    admit_source: Option(Codeableconcept),
    re_admission: Option(Codeableconcept),
    diet_preference: List(Codeableconcept),
    special_courtesy: List(Codeableconcept),
    special_arrangement: List(Codeableconcept),
    destination: Option(Reference),
    discharge_disposition: Option(Codeableconcept),
  )
}

pub fn encounter_hospitalization_new() -> EncounterHospitalization {
  EncounterHospitalization(
    discharge_disposition: None,
    destination: None,
    special_arrangement: [],
    special_courtesy: [],
    diet_preference: [],
    re_admission: None,
    admit_source: None,
    origin: None,
    pre_admission_identifier: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Encounter#resource
pub type EncounterLocation {
  EncounterLocation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    location: Reference,
    status: Option(r4bvaluesets.Encounterlocationstatus),
    physical_type: Option(Codeableconcept),
    period: Option(Period),
  )
}

pub fn encounter_location_new(location) -> EncounterLocation {
  EncounterLocation(
    period: None,
    physical_type: None,
    status: None,
    location:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Endpoint#resource
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
    status: r4bvaluesets.Endpointstatus,
    connection_type: Coding,
    name: Option(String),
    managing_organization: Option(Reference),
    contact: List(Contactpoint),
    period: Option(Period),
    payload_type: List(Codeableconcept),
    payload_mime_type: List(String),
    address: String,
    header: List(String),
  )
}

pub fn endpoint_new(address, connection_type, status) -> Endpoint {
  Endpoint(
    header: [],
    address:,
    payload_mime_type: [],
    payload_type: [],
    period: None,
    contact: [],
    managing_organization: None,
    name: None,
    connection_type:,
    status:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/EnrollmentRequest#resource
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
    status: Option(r4bvaluesets.Fmstatus),
    created: Option(String),
    insurer: Option(Reference),
    provider: Option(Reference),
    candidate: Option(Reference),
    coverage: Option(Reference),
  )
}

pub fn enrollmentrequest_new() -> Enrollmentrequest {
  Enrollmentrequest(
    coverage: None,
    candidate: None,
    provider: None,
    insurer: None,
    created: None,
    status: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/EnrollmentResponse#resource
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
    status: Option(r4bvaluesets.Fmstatus),
    request: Option(Reference),
    outcome: Option(r4bvaluesets.Remittanceoutcome),
    disposition: Option(String),
    created: Option(String),
    organization: Option(Reference),
    request_provider: Option(Reference),
  )
}

pub fn enrollmentresponse_new() -> Enrollmentresponse {
  Enrollmentresponse(
    request_provider: None,
    organization: None,
    created: None,
    disposition: None,
    outcome: None,
    request: None,
    status: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/EpisodeOfCare#resource
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
    status: r4bvaluesets.Episodeofcarestatus,
    status_history: List(EpisodeofcareStatushistory),
    type_: List(Codeableconcept),
    diagnosis: List(EpisodeofcareDiagnosis),
    patient: Reference,
    managing_organization: Option(Reference),
    period: Option(Period),
    referral_request: List(Reference),
    care_manager: Option(Reference),
    team: List(Reference),
    account: List(Reference),
  )
}

pub fn episodeofcare_new(patient, status) -> Episodeofcare {
  Episodeofcare(
    account: [],
    team: [],
    care_manager: None,
    referral_request: [],
    period: None,
    managing_organization: None,
    patient:,
    diagnosis: [],
    type_: [],
    status_history: [],
    status:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/EpisodeOfCare#resource
pub type EpisodeofcareStatushistory {
  EpisodeofcareStatushistory(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    status: r4bvaluesets.Episodeofcarestatus,
    period: Period,
  )
}

pub fn episodeofcare_statushistory_new(
  period,
  status,
) -> EpisodeofcareStatushistory {
  EpisodeofcareStatushistory(
    period:,
    status:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/EpisodeOfCare#resource
pub type EpisodeofcareDiagnosis {
  EpisodeofcareDiagnosis(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    condition: Reference,
    role: Option(Codeableconcept),
    rank: Option(Int),
  )
}

pub fn episodeofcare_diagnosis_new(condition) -> EpisodeofcareDiagnosis {
  EpisodeofcareDiagnosis(
    rank: None,
    role: None,
    condition:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/EventDefinition#resource
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
    name: Option(String),
    title: Option(String),
    subtitle: Option(String),
    status: r4bvaluesets.Publicationstatus,
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

///http://hl7.org/fhir/r4b/StructureDefinition/EventDefinition#resource
pub type EventdefinitionSubject {
  EventdefinitionSubjectCodeableconcept(subject: Codeableconcept)
  EventdefinitionSubjectReference(subject: Reference)
}

pub fn eventdefinition_new(status) -> Eventdefinition {
  Eventdefinition(
    trigger: [],
    related_artifact: [],
    endorser: [],
    reviewer: [],
    editor: [],
    author: [],
    topic: [],
    effective_period: None,
    last_review_date: None,
    approval_date: None,
    copyright: None,
    usage: None,
    purpose: None,
    jurisdiction: [],
    use_context: [],
    description: None,
    contact: [],
    publisher: None,
    date: None,
    subject: None,
    experimental: None,
    status:,
    subtitle: None,
    title: None,
    name: None,
    version: None,
    identifier: [],
    url: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Evidence#resource
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
    title: Option(String),
    cite_as: Option(EvidenceCiteas),
    status: r4bvaluesets.Publicationstatus,
    date: Option(String),
    use_context: List(Usagecontext),
    approval_date: Option(String),
    last_review_date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    author: List(Contactdetail),
    editor: List(Contactdetail),
    reviewer: List(Contactdetail),
    endorser: List(Contactdetail),
    related_artifact: List(Relatedartifact),
    description: Option(String),
    assertion: Option(String),
    note: List(Annotation),
    variable_definition: List(EvidenceVariabledefinition),
    synthesis_type: Option(Codeableconcept),
    study_type: Option(Codeableconcept),
    statistic: List(EvidenceStatistic),
    certainty: List(EvidenceCertainty),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Evidence#resource
pub type EvidenceCiteas {
  EvidenceCiteasReference(cite_as: Reference)
  EvidenceCiteasMarkdown(cite_as: String)
}

pub fn evidence_new(status) -> Evidence {
  Evidence(
    certainty: [],
    statistic: [],
    study_type: None,
    synthesis_type: None,
    variable_definition: [],
    note: [],
    assertion: None,
    description: None,
    related_artifact: [],
    endorser: [],
    reviewer: [],
    editor: [],
    author: [],
    contact: [],
    publisher: None,
    last_review_date: None,
    approval_date: None,
    use_context: [],
    date: None,
    status:,
    cite_as: None,
    title: None,
    version: None,
    identifier: [],
    url: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Evidence#resource
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

pub fn evidence_variabledefinition_new(
  variable_role,
) -> EvidenceVariabledefinition {
  EvidenceVariabledefinition(
    directness_match: None,
    intended: None,
    observed: None,
    variable_role:,
    note: [],
    description: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Evidence#resource
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

pub fn evidence_statistic_new() -> EvidenceStatistic {
  EvidenceStatistic(
    model_characteristic: [],
    attribute_estimate: [],
    sample_size: None,
    number_affected: None,
    number_of_events: None,
    quantity: None,
    category: None,
    statistic_type: None,
    note: [],
    description: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Evidence#resource
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

pub fn evidence_statistic_samplesize_new() -> EvidenceStatisticSamplesize {
  EvidenceStatisticSamplesize(
    known_data_count: None,
    number_of_participants: None,
    number_of_studies: None,
    note: [],
    description: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Evidence#resource
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

pub fn evidence_statistic_attributeestimate_new() -> EvidenceStatisticAttributeestimate {
  EvidenceStatisticAttributeestimate(
    attribute_estimate: [],
    range: None,
    level: None,
    quantity: None,
    type_: None,
    note: [],
    description: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Evidence#resource
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

pub fn evidence_statistic_modelcharacteristic_new(
  code,
) -> EvidenceStatisticModelcharacteristic {
  EvidenceStatisticModelcharacteristic(
    attribute_estimate: [],
    variable: [],
    value: None,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Evidence#resource
pub type EvidenceStatisticModelcharacteristicVariable {
  EvidenceStatisticModelcharacteristicVariable(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    variable_definition: Reference,
    handling: Option(r4bvaluesets.Variablehandling),
    value_category: List(Codeableconcept),
    value_quantity: List(Quantity),
    value_range: List(Range),
  )
}

pub fn evidence_statistic_modelcharacteristic_variable_new(
  variable_definition,
) -> EvidenceStatisticModelcharacteristicVariable {
  EvidenceStatisticModelcharacteristicVariable(
    value_range: [],
    value_quantity: [],
    value_category: [],
    handling: None,
    variable_definition:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Evidence#resource
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

pub fn evidence_certainty_new() -> EvidenceCertainty {
  EvidenceCertainty(
    subcomponent: [],
    rater: None,
    rating: None,
    type_: None,
    note: [],
    description: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/EvidenceReport#resource
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
    status: r4bvaluesets.Publicationstatus,
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

///http://hl7.org/fhir/r4b/StructureDefinition/EvidenceReport#resource
pub type EvidencereportCiteas {
  EvidencereportCiteasReference(cite_as: Reference)
  EvidencereportCiteasMarkdown(cite_as: String)
}

pub fn evidencereport_new(subject, status) -> Evidencereport {
  Evidencereport(
    section: [],
    relates_to: [],
    endorser: [],
    reviewer: [],
    editor: [],
    author: [],
    contact: [],
    publisher: None,
    subject:,
    related_artifact: [],
    note: [],
    type_: None,
    cite_as: None,
    related_identifier: [],
    identifier: [],
    use_context: [],
    status:,
    url: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/EvidenceReport#resource
pub type EvidencereportSubject {
  EvidencereportSubject(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    characteristic: List(EvidencereportSubjectCharacteristic),
    note: List(Annotation),
  )
}

pub fn evidencereport_subject_new() -> EvidencereportSubject {
  EvidencereportSubject(
    note: [],
    characteristic: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/EvidenceReport#resource
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

///http://hl7.org/fhir/r4b/StructureDefinition/EvidenceReport#resource
pub type EvidencereportSubjectCharacteristicValue {
  EvidencereportSubjectCharacteristicValueReference(value: Reference)
  EvidencereportSubjectCharacteristicValueCodeableconcept(
    value: Codeableconcept,
  )
  EvidencereportSubjectCharacteristicValueBoolean(value: Bool)
  EvidencereportSubjectCharacteristicValueQuantity(value: Quantity)
  EvidencereportSubjectCharacteristicValueRange(value: Range)
}

pub fn evidencereport_subject_characteristic_new(
  value,
  code,
) -> EvidencereportSubjectCharacteristic {
  EvidencereportSubjectCharacteristic(
    period: None,
    exclude: None,
    value:,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/EvidenceReport#resource
pub type EvidencereportRelatesto {
  EvidencereportRelatesto(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: r4bvaluesets.Reportrelationtype,
    target: EvidencereportRelatestoTarget,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/EvidenceReport#resource
pub type EvidencereportRelatestoTarget {
  EvidencereportRelatestoTargetIdentifier(target: Identifier)
  EvidencereportRelatestoTargetReference(target: Reference)
}

pub fn evidencereport_relatesto_new(target, code) -> EvidencereportRelatesto {
  EvidencereportRelatesto(
    target:,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/EvidenceReport#resource
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
    mode: Option(r4bvaluesets.Listmode),
    ordered_by: Option(Codeableconcept),
    entry_classifier: List(Codeableconcept),
    entry_reference: List(Reference),
    entry_quantity: List(Quantity),
    empty_reason: Option(Codeableconcept),
    section: List(Nil),
  )
}

pub fn evidencereport_section_new() -> EvidencereportSection {
  EvidencereportSection(
    section: [],
    empty_reason: None,
    entry_quantity: [],
    entry_reference: [],
    entry_classifier: [],
    ordered_by: None,
    mode: None,
    text: None,
    author: [],
    focus_reference: None,
    focus: None,
    title: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/EvidenceVariable#resource
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
    name: Option(String),
    title: Option(String),
    short_title: Option(String),
    subtitle: Option(String),
    status: r4bvaluesets.Publicationstatus,
    date: Option(String),
    description: Option(String),
    note: List(Annotation),
    use_context: List(Usagecontext),
    publisher: Option(String),
    contact: List(Contactdetail),
    author: List(Contactdetail),
    editor: List(Contactdetail),
    reviewer: List(Contactdetail),
    endorser: List(Contactdetail),
    related_artifact: List(Relatedartifact),
    actual: Option(Bool),
    characteristic_combination: Option(r4bvaluesets.Characteristiccombination),
    characteristic: List(EvidencevariableCharacteristic),
    handling: Option(r4bvaluesets.Variablehandling),
    category: List(EvidencevariableCategory),
  )
}

pub fn evidencevariable_new(status) -> Evidencevariable {
  Evidencevariable(
    category: [],
    handling: None,
    characteristic: [],
    characteristic_combination: None,
    actual: None,
    related_artifact: [],
    endorser: [],
    reviewer: [],
    editor: [],
    author: [],
    contact: [],
    publisher: None,
    use_context: [],
    note: [],
    description: None,
    date: None,
    status:,
    subtitle: None,
    short_title: None,
    title: None,
    name: None,
    version: None,
    identifier: [],
    url: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/EvidenceVariable#resource
pub type EvidencevariableCharacteristic {
  EvidencevariableCharacteristic(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    definition: EvidencevariableCharacteristicDefinition,
    method: Option(Codeableconcept),
    device: Option(Reference),
    exclude: Option(Bool),
    time_from_start: Option(EvidencevariableCharacteristicTimefromstart),
    group_measure: Option(r4bvaluesets.Groupmeasure),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/EvidenceVariable#resource
pub type EvidencevariableCharacteristicDefinition {
  EvidencevariableCharacteristicDefinitionReference(definition: Reference)
  EvidencevariableCharacteristicDefinitionCanonical(definition: String)
  EvidencevariableCharacteristicDefinitionCodeableconcept(
    definition: Codeableconcept,
  )
  EvidencevariableCharacteristicDefinitionExpression(definition: Expression)
}

pub fn evidencevariable_characteristic_new(
  definition,
) -> EvidencevariableCharacteristic {
  EvidencevariableCharacteristic(
    group_measure: None,
    time_from_start: None,
    exclude: None,
    device: None,
    method: None,
    definition:,
    description: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/EvidenceVariable#resource
pub type EvidencevariableCharacteristicTimefromstart {
  EvidencevariableCharacteristicTimefromstart(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    quantity: Option(Quantity),
    range: Option(Range),
    note: List(Annotation),
  )
}

pub fn evidencevariable_characteristic_timefromstart_new() -> EvidencevariableCharacteristicTimefromstart {
  EvidencevariableCharacteristicTimefromstart(
    note: [],
    range: None,
    quantity: None,
    description: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/EvidenceVariable#resource
pub type EvidencevariableCategory {
  EvidencevariableCategory(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: Option(String),
    value: Option(EvidencevariableCategoryValue),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/EvidenceVariable#resource
pub type EvidencevariableCategoryValue {
  EvidencevariableCategoryValueCodeableconcept(value: Codeableconcept)
  EvidencevariableCategoryValueQuantity(value: Quantity)
  EvidencevariableCategoryValueRange(value: Range)
}

pub fn evidencevariable_category_new() -> EvidencevariableCategory {
  EvidencevariableCategory(
    value: None,
    name: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExampleScenario#resource
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
    name: Option(String),
    status: r4bvaluesets.Publicationstatus,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    copyright: Option(String),
    purpose: Option(String),
    actor: List(ExamplescenarioActor),
    instance: List(ExamplescenarioInstance),
    process: List(ExamplescenarioProcess),
    workflow: List(String),
  )
}

pub fn examplescenario_new(status) -> Examplescenario {
  Examplescenario(
    workflow: [],
    process: [],
    instance: [],
    actor: [],
    purpose: None,
    copyright: None,
    jurisdiction: [],
    use_context: [],
    contact: [],
    publisher: None,
    date: None,
    experimental: None,
    status:,
    name: None,
    version: None,
    identifier: [],
    url: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExampleScenario#resource
pub type ExamplescenarioActor {
  ExamplescenarioActor(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    actor_id: String,
    type_: r4bvaluesets.Examplescenarioactortype,
    name: Option(String),
    description: Option(String),
  )
}

pub fn examplescenario_actor_new(type_, actor_id) -> ExamplescenarioActor {
  ExamplescenarioActor(
    description: None,
    name: None,
    type_:,
    actor_id:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExampleScenario#resource
pub type ExamplescenarioInstance {
  ExamplescenarioInstance(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    resource_id: String,
    resource_type: r4bvaluesets.Resourcetypes,
    name: Option(String),
    description: Option(String),
    version: List(ExamplescenarioInstanceVersion),
    contained_instance: List(ExamplescenarioInstanceContainedinstance),
  )
}

pub fn examplescenario_instance_new(
  resource_type,
  resource_id,
) -> ExamplescenarioInstance {
  ExamplescenarioInstance(
    contained_instance: [],
    version: [],
    description: None,
    name: None,
    resource_type:,
    resource_id:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExampleScenario#resource
pub type ExamplescenarioInstanceVersion {
  ExamplescenarioInstanceVersion(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    version_id: String,
    description: String,
  )
}

pub fn examplescenario_instance_version_new(
  description,
  version_id,
) -> ExamplescenarioInstanceVersion {
  ExamplescenarioInstanceVersion(
    description:,
    version_id:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExampleScenario#resource
pub type ExamplescenarioInstanceContainedinstance {
  ExamplescenarioInstanceContainedinstance(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    resource_id: String,
    version_id: Option(String),
  )
}

pub fn examplescenario_instance_containedinstance_new(
  resource_id,
) -> ExamplescenarioInstanceContainedinstance {
  ExamplescenarioInstanceContainedinstance(
    version_id: None,
    resource_id:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExampleScenario#resource
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

pub fn examplescenario_process_new(title) -> ExamplescenarioProcess {
  ExamplescenarioProcess(
    step: [],
    post_conditions: None,
    pre_conditions: None,
    description: None,
    title:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExampleScenario#resource
pub type ExamplescenarioProcessStep {
  ExamplescenarioProcessStep(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    process: List(Nil),
    pause: Option(Bool),
    operation: Option(ExamplescenarioProcessStepOperation),
    alternative: List(ExamplescenarioProcessStepAlternative),
  )
}

pub fn examplescenario_process_step_new() -> ExamplescenarioProcessStep {
  ExamplescenarioProcessStep(
    alternative: [],
    operation: None,
    pause: None,
    process: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExampleScenario#resource
pub type ExamplescenarioProcessStepOperation {
  ExamplescenarioProcessStepOperation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    number: String,
    type_: Option(String),
    name: Option(String),
    initiator: Option(String),
    receiver: Option(String),
    description: Option(String),
    initiator_active: Option(Bool),
    receiver_active: Option(Bool),
    request: Option(Nil),
    response: Option(Nil),
  )
}

pub fn examplescenario_process_step_operation_new(
  number,
) -> ExamplescenarioProcessStepOperation {
  ExamplescenarioProcessStepOperation(
    response: None,
    request: None,
    receiver_active: None,
    initiator_active: None,
    description: None,
    receiver: None,
    initiator: None,
    name: None,
    type_: None,
    number:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExampleScenario#resource
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

pub fn examplescenario_process_step_alternative_new(
  title,
) -> ExamplescenarioProcessStepAlternative {
  ExamplescenarioProcessStepAlternative(
    step: [],
    description: None,
    title:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
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
    status: r4bvaluesets.Explanationofbenefitstatus,
    type_: Codeableconcept,
    sub_type: Option(Codeableconcept),
    use_: r4bvaluesets.Claimuse,
    patient: Reference,
    billable_period: Option(Period),
    created: String,
    enterer: Option(Reference),
    insurer: Reference,
    provider: Reference,
    priority: Option(Codeableconcept),
    funds_reserve_requested: Option(Codeableconcept),
    funds_reserve: Option(Codeableconcept),
    related: List(ExplanationofbenefitRelated),
    prescription: Option(Reference),
    original_prescription: Option(Reference),
    payee: Option(ExplanationofbenefitPayee),
    referral: Option(Reference),
    facility: Option(Reference),
    claim: Option(Reference),
    claim_response: Option(Reference),
    outcome: r4bvaluesets.Remittanceoutcome,
    disposition: Option(String),
    pre_auth_ref: List(String),
    pre_auth_ref_period: List(Period),
    care_team: List(ExplanationofbenefitCareteam),
    supporting_info: List(ExplanationofbenefitSupportinginfo),
    diagnosis: List(ExplanationofbenefitDiagnosis),
    procedure: List(ExplanationofbenefitProcedure),
    precedence: Option(Int),
    insurance: List(ExplanationofbenefitInsurance),
    accident: Option(ExplanationofbenefitAccident),
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

pub fn explanationofbenefit_new(
  outcome,
  provider,
  insurer,
  created,
  patient,
  use_,
  type_,
  status,
) -> Explanationofbenefit {
  Explanationofbenefit(
    benefit_balance: [],
    benefit_period: None,
    process_note: [],
    form: None,
    form_code: None,
    payment: None,
    total: [],
    adjudication: [],
    add_item: [],
    item: [],
    accident: None,
    insurance: [],
    precedence: None,
    procedure: [],
    diagnosis: [],
    supporting_info: [],
    care_team: [],
    pre_auth_ref_period: [],
    pre_auth_ref: [],
    disposition: None,
    outcome:,
    claim_response: None,
    claim: None,
    facility: None,
    referral: None,
    payee: None,
    original_prescription: None,
    prescription: None,
    related: [],
    funds_reserve: None,
    funds_reserve_requested: None,
    priority: None,
    provider:,
    insurer:,
    enterer: None,
    created:,
    billable_period: None,
    patient:,
    use_:,
    sub_type: None,
    type_:,
    status:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
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

pub fn explanationofbenefit_related_new() -> ExplanationofbenefitRelated {
  ExplanationofbenefitRelated(
    reference: None,
    relationship: None,
    claim: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitPayee {
  ExplanationofbenefitPayee(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    party: Option(Reference),
  )
}

pub fn explanationofbenefit_payee_new() -> ExplanationofbenefitPayee {
  ExplanationofbenefitPayee(
    party: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitCareteam {
  ExplanationofbenefitCareteam(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Int,
    provider: Reference,
    responsible: Option(Bool),
    role: Option(Codeableconcept),
    qualification: Option(Codeableconcept),
  )
}

pub fn explanationofbenefit_careteam_new(
  provider,
  sequence,
) -> ExplanationofbenefitCareteam {
  ExplanationofbenefitCareteam(
    qualification: None,
    role: None,
    responsible: None,
    provider:,
    sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
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

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitSupportinginfoTiming {
  ExplanationofbenefitSupportinginfoTimingDate(timing: String)
  ExplanationofbenefitSupportinginfoTimingPeriod(timing: Period)
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitSupportinginfoValue {
  ExplanationofbenefitSupportinginfoValueBoolean(value: Bool)
  ExplanationofbenefitSupportinginfoValueString(value: String)
  ExplanationofbenefitSupportinginfoValueQuantity(value: Quantity)
  ExplanationofbenefitSupportinginfoValueAttachment(value: Attachment)
  ExplanationofbenefitSupportinginfoValueReference(value: Reference)
}

pub fn explanationofbenefit_supportinginfo_new(
  category,
  sequence,
) -> ExplanationofbenefitSupportinginfo {
  ExplanationofbenefitSupportinginfo(
    reason: None,
    value: None,
    timing: None,
    code: None,
    category:,
    sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitDiagnosis {
  ExplanationofbenefitDiagnosis(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Int,
    diagnosis: ExplanationofbenefitDiagnosisDiagnosis,
    type_: List(Codeableconcept),
    on_admission: Option(Codeableconcept),
    package_code: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitDiagnosisDiagnosis {
  ExplanationofbenefitDiagnosisDiagnosisCodeableconcept(
    diagnosis: Codeableconcept,
  )
  ExplanationofbenefitDiagnosisDiagnosisReference(diagnosis: Reference)
}

pub fn explanationofbenefit_diagnosis_new(
  diagnosis,
  sequence,
) -> ExplanationofbenefitDiagnosis {
  ExplanationofbenefitDiagnosis(
    package_code: None,
    on_admission: None,
    type_: [],
    diagnosis:,
    sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
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

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitProcedureProcedure {
  ExplanationofbenefitProcedureProcedureCodeableconcept(
    procedure: Codeableconcept,
  )
  ExplanationofbenefitProcedureProcedureReference(procedure: Reference)
}

pub fn explanationofbenefit_procedure_new(
  procedure,
  sequence,
) -> ExplanationofbenefitProcedure {
  ExplanationofbenefitProcedure(
    udi: [],
    procedure:,
    date: None,
    type_: [],
    sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
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

pub fn explanationofbenefit_insurance_new(
  coverage,
  focal,
) -> ExplanationofbenefitInsurance {
  ExplanationofbenefitInsurance(
    pre_auth_ref: [],
    coverage:,
    focal:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
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

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitAccidentLocation {
  ExplanationofbenefitAccidentLocationAddress(location: Address)
  ExplanationofbenefitAccidentLocationReference(location: Reference)
}

pub fn explanationofbenefit_accident_new() -> ExplanationofbenefitAccident {
  ExplanationofbenefitAccident(
    location: None,
    type_: None,
    date: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
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
    revenue: Option(Codeableconcept),
    category: Option(Codeableconcept),
    product_or_service: Codeableconcept,
    modifier: List(Codeableconcept),
    program_code: List(Codeableconcept),
    serviced: Option(ExplanationofbenefitItemServiced),
    location: Option(ExplanationofbenefitItemLocation),
    quantity: Option(Quantity),
    unit_price: Option(Money),
    factor: Option(Float),
    net: Option(Money),
    udi: List(Reference),
    body_site: Option(Codeableconcept),
    sub_site: List(Codeableconcept),
    encounter: List(Reference),
    note_number: List(Int),
    adjudication: List(ExplanationofbenefitItemAdjudication),
    detail: List(ExplanationofbenefitItemDetail),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitItemServiced {
  ExplanationofbenefitItemServicedDate(serviced: String)
  ExplanationofbenefitItemServicedPeriod(serviced: Period)
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitItemLocation {
  ExplanationofbenefitItemLocationCodeableconcept(location: Codeableconcept)
  ExplanationofbenefitItemLocationAddress(location: Address)
  ExplanationofbenefitItemLocationReference(location: Reference)
}

pub fn explanationofbenefit_item_new(
  product_or_service,
  sequence,
) -> ExplanationofbenefitItem {
  ExplanationofbenefitItem(
    detail: [],
    adjudication: [],
    note_number: [],
    encounter: [],
    sub_site: [],
    body_site: None,
    udi: [],
    net: None,
    factor: None,
    unit_price: None,
    quantity: None,
    location: None,
    serviced: None,
    program_code: [],
    modifier: [],
    product_or_service:,
    category: None,
    revenue: None,
    information_sequence: [],
    procedure_sequence: [],
    diagnosis_sequence: [],
    care_team_sequence: [],
    sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitItemAdjudication {
  ExplanationofbenefitItemAdjudication(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    category: Codeableconcept,
    reason: Option(Codeableconcept),
    amount: Option(Money),
    value: Option(Float),
  )
}

pub fn explanationofbenefit_item_adjudication_new(
  category,
) -> ExplanationofbenefitItemAdjudication {
  ExplanationofbenefitItemAdjudication(
    value: None,
    amount: None,
    reason: None,
    category:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitItemDetail {
  ExplanationofbenefitItemDetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Int,
    revenue: Option(Codeableconcept),
    category: Option(Codeableconcept),
    product_or_service: Codeableconcept,
    modifier: List(Codeableconcept),
    program_code: List(Codeableconcept),
    quantity: Option(Quantity),
    unit_price: Option(Money),
    factor: Option(Float),
    net: Option(Money),
    udi: List(Reference),
    note_number: List(Int),
    adjudication: List(Nil),
    sub_detail: List(ExplanationofbenefitItemDetailSubdetail),
  )
}

pub fn explanationofbenefit_item_detail_new(
  product_or_service,
  sequence,
) -> ExplanationofbenefitItemDetail {
  ExplanationofbenefitItemDetail(
    sub_detail: [],
    adjudication: [],
    note_number: [],
    udi: [],
    net: None,
    factor: None,
    unit_price: None,
    quantity: None,
    program_code: [],
    modifier: [],
    product_or_service:,
    category: None,
    revenue: None,
    sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitItemDetailSubdetail {
  ExplanationofbenefitItemDetailSubdetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Int,
    revenue: Option(Codeableconcept),
    category: Option(Codeableconcept),
    product_or_service: Codeableconcept,
    modifier: List(Codeableconcept),
    program_code: List(Codeableconcept),
    quantity: Option(Quantity),
    unit_price: Option(Money),
    factor: Option(Float),
    net: Option(Money),
    udi: List(Reference),
    note_number: List(Int),
    adjudication: List(Nil),
  )
}

pub fn explanationofbenefit_item_detail_subdetail_new(
  product_or_service,
  sequence,
) -> ExplanationofbenefitItemDetailSubdetail {
  ExplanationofbenefitItemDetailSubdetail(
    adjudication: [],
    note_number: [],
    udi: [],
    net: None,
    factor: None,
    unit_price: None,
    quantity: None,
    program_code: [],
    modifier: [],
    product_or_service:,
    category: None,
    revenue: None,
    sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitAdditem {
  ExplanationofbenefitAdditem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item_sequence: List(Int),
    detail_sequence: List(Int),
    sub_detail_sequence: List(Int),
    provider: List(Reference),
    product_or_service: Codeableconcept,
    modifier: List(Codeableconcept),
    program_code: List(Codeableconcept),
    serviced: Option(ExplanationofbenefitAdditemServiced),
    location: Option(ExplanationofbenefitAdditemLocation),
    quantity: Option(Quantity),
    unit_price: Option(Money),
    factor: Option(Float),
    net: Option(Money),
    body_site: Option(Codeableconcept),
    sub_site: List(Codeableconcept),
    note_number: List(Int),
    adjudication: List(Nil),
    detail: List(ExplanationofbenefitAdditemDetail),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitAdditemServiced {
  ExplanationofbenefitAdditemServicedDate(serviced: String)
  ExplanationofbenefitAdditemServicedPeriod(serviced: Period)
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitAdditemLocation {
  ExplanationofbenefitAdditemLocationCodeableconcept(location: Codeableconcept)
  ExplanationofbenefitAdditemLocationAddress(location: Address)
  ExplanationofbenefitAdditemLocationReference(location: Reference)
}

pub fn explanationofbenefit_additem_new(
  product_or_service,
) -> ExplanationofbenefitAdditem {
  ExplanationofbenefitAdditem(
    detail: [],
    adjudication: [],
    note_number: [],
    sub_site: [],
    body_site: None,
    net: None,
    factor: None,
    unit_price: None,
    quantity: None,
    location: None,
    serviced: None,
    program_code: [],
    modifier: [],
    product_or_service:,
    provider: [],
    sub_detail_sequence: [],
    detail_sequence: [],
    item_sequence: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitAdditemDetail {
  ExplanationofbenefitAdditemDetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    product_or_service: Codeableconcept,
    modifier: List(Codeableconcept),
    quantity: Option(Quantity),
    unit_price: Option(Money),
    factor: Option(Float),
    net: Option(Money),
    note_number: List(Int),
    adjudication: List(Nil),
    sub_detail: List(ExplanationofbenefitAdditemDetailSubdetail),
  )
}

pub fn explanationofbenefit_additem_detail_new(
  product_or_service,
) -> ExplanationofbenefitAdditemDetail {
  ExplanationofbenefitAdditemDetail(
    sub_detail: [],
    adjudication: [],
    note_number: [],
    net: None,
    factor: None,
    unit_price: None,
    quantity: None,
    modifier: [],
    product_or_service:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitAdditemDetailSubdetail {
  ExplanationofbenefitAdditemDetailSubdetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    product_or_service: Codeableconcept,
    modifier: List(Codeableconcept),
    quantity: Option(Quantity),
    unit_price: Option(Money),
    factor: Option(Float),
    net: Option(Money),
    note_number: List(Int),
    adjudication: List(Nil),
  )
}

pub fn explanationofbenefit_additem_detail_subdetail_new(
  product_or_service,
) -> ExplanationofbenefitAdditemDetailSubdetail {
  ExplanationofbenefitAdditemDetailSubdetail(
    adjudication: [],
    note_number: [],
    net: None,
    factor: None,
    unit_price: None,
    quantity: None,
    modifier: [],
    product_or_service:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitTotal {
  ExplanationofbenefitTotal(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    category: Codeableconcept,
    amount: Money,
  )
}

pub fn explanationofbenefit_total_new(
  amount,
  category,
) -> ExplanationofbenefitTotal {
  ExplanationofbenefitTotal(
    amount:,
    category:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
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

pub fn explanationofbenefit_payment_new() -> ExplanationofbenefitPayment {
  ExplanationofbenefitPayment(
    identifier: None,
    amount: None,
    date: None,
    adjustment_reason: None,
    adjustment: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitProcessnote {
  ExplanationofbenefitProcessnote(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    number: Option(Int),
    type_: Option(r4bvaluesets.Notetype),
    text: Option(String),
    language: Option(Codeableconcept),
  )
}

pub fn explanationofbenefit_processnote_new() -> ExplanationofbenefitProcessnote {
  ExplanationofbenefitProcessnote(
    language: None,
    text: None,
    type_: None,
    number: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
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

pub fn explanationofbenefit_benefitbalance_new(
  category,
) -> ExplanationofbenefitBenefitbalance {
  ExplanationofbenefitBenefitbalance(
    financial: [],
    term: None,
    unit: None,
    network: None,
    description: None,
    name: None,
    excluded: None,
    category:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
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

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitBenefitbalanceFinancialAllowed {
  ExplanationofbenefitBenefitbalanceFinancialAllowedUnsignedint(allowed: Int)
  ExplanationofbenefitBenefitbalanceFinancialAllowedString(allowed: String)
  ExplanationofbenefitBenefitbalanceFinancialAllowedMoney(allowed: Money)
}

///http://hl7.org/fhir/r4b/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitBenefitbalanceFinancialUsed {
  ExplanationofbenefitBenefitbalanceFinancialUsedUnsignedint(used: Int)
  ExplanationofbenefitBenefitbalanceFinancialUsedMoney(used: Money)
}

pub fn explanationofbenefit_benefitbalance_financial_new(
  type_,
) -> ExplanationofbenefitBenefitbalanceFinancial {
  ExplanationofbenefitBenefitbalanceFinancial(
    used: None,
    allowed: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/FamilyMemberHistory#resource
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
    status: r4bvaluesets.Historystatus,
    data_absent_reason: Option(Codeableconcept),
    patient: Reference,
    date: Option(String),
    name: Option(String),
    relationship: Codeableconcept,
    sex: Option(Codeableconcept),
    born: Option(FamilymemberhistoryBorn),
    age: Option(FamilymemberhistoryAge),
    estimated_age: Option(Bool),
    deceased: Option(FamilymemberhistoryDeceased),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    note: List(Annotation),
    condition: List(FamilymemberhistoryCondition),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/FamilyMemberHistory#resource
pub type FamilymemberhistoryBorn {
  FamilymemberhistoryBornPeriod(born: Period)
  FamilymemberhistoryBornDate(born: String)
  FamilymemberhistoryBornString(born: String)
}

///http://hl7.org/fhir/r4b/StructureDefinition/FamilyMemberHistory#resource
pub type FamilymemberhistoryAge {
  FamilymemberhistoryAgeAge(age: Age)
  FamilymemberhistoryAgeRange(age: Range)
  FamilymemberhistoryAgeString(age: String)
}

///http://hl7.org/fhir/r4b/StructureDefinition/FamilyMemberHistory#resource
pub type FamilymemberhistoryDeceased {
  FamilymemberhistoryDeceasedBoolean(deceased: Bool)
  FamilymemberhistoryDeceasedAge(deceased: Age)
  FamilymemberhistoryDeceasedRange(deceased: Range)
  FamilymemberhistoryDeceasedDate(deceased: String)
  FamilymemberhistoryDeceasedString(deceased: String)
}

pub fn familymemberhistory_new(
  relationship,
  patient,
  status,
) -> Familymemberhistory {
  Familymemberhistory(
    condition: [],
    note: [],
    reason_reference: [],
    reason_code: [],
    deceased: None,
    estimated_age: None,
    age: None,
    born: None,
    sex: None,
    relationship:,
    name: None,
    date: None,
    patient:,
    data_absent_reason: None,
    status:,
    instantiates_uri: [],
    instantiates_canonical: [],
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/FamilyMemberHistory#resource
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

///http://hl7.org/fhir/r4b/StructureDefinition/FamilyMemberHistory#resource
pub type FamilymemberhistoryConditionOnset {
  FamilymemberhistoryConditionOnsetAge(onset: Age)
  FamilymemberhistoryConditionOnsetRange(onset: Range)
  FamilymemberhistoryConditionOnsetPeriod(onset: Period)
  FamilymemberhistoryConditionOnsetString(onset: String)
}

pub fn familymemberhistory_condition_new(code) -> FamilymemberhistoryCondition {
  FamilymemberhistoryCondition(
    note: [],
    onset: None,
    contributed_to_death: None,
    outcome: None,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Flag#resource
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
    status: r4bvaluesets.Flagstatus,
    category: List(Codeableconcept),
    code: Codeableconcept,
    subject: Reference,
    period: Option(Period),
    encounter: Option(Reference),
    author: Option(Reference),
  )
}

pub fn flag_new(subject, code, status) -> Flag {
  Flag(
    author: None,
    encounter: None,
    period: None,
    subject:,
    code:,
    category: [],
    status:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Goal#resource
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
    lifecycle_status: r4bvaluesets.Goalstatus,
    achievement_status: Option(Codeableconcept),
    category: List(Codeableconcept),
    priority: Option(Codeableconcept),
    description: Codeableconcept,
    subject: Reference,
    start: Option(GoalStart),
    target: List(GoalTarget),
    status_date: Option(String),
    status_reason: Option(String),
    expressed_by: Option(Reference),
    addresses: List(Reference),
    note: List(Annotation),
    outcome_code: List(Codeableconcept),
    outcome_reference: List(Reference),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Goal#resource
pub type GoalStart {
  GoalStartDate(start: String)
  GoalStartCodeableconcept(start: Codeableconcept)
}

pub fn goal_new(subject, description, lifecycle_status) -> Goal {
  Goal(
    outcome_reference: [],
    outcome_code: [],
    note: [],
    addresses: [],
    expressed_by: None,
    status_reason: None,
    status_date: None,
    target: [],
    start: None,
    subject:,
    description:,
    priority: None,
    category: [],
    achievement_status: None,
    lifecycle_status:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Goal#resource
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

///http://hl7.org/fhir/r4b/StructureDefinition/Goal#resource
pub type GoalTargetDetail {
  GoalTargetDetailQuantity(detail: Quantity)
  GoalTargetDetailRange(detail: Range)
  GoalTargetDetailCodeableconcept(detail: Codeableconcept)
  GoalTargetDetailString(detail: String)
  GoalTargetDetailBoolean(detail: Bool)
  GoalTargetDetailInteger(detail: Int)
  GoalTargetDetailRatio(detail: Ratio)
}

///http://hl7.org/fhir/r4b/StructureDefinition/Goal#resource
pub type GoalTargetDue {
  GoalTargetDueDate(due: String)
  GoalTargetDueDuration(due: Duration)
}

pub fn goal_target_new() -> GoalTarget {
  GoalTarget(
    due: None,
    detail: None,
    measure: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/GraphDefinition#resource
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
    version: Option(String),
    name: String,
    status: r4bvaluesets.Publicationstatus,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    start: r4bvaluesets.Resourcetypes,
    profile: Option(String),
    link: List(GraphdefinitionLink),
  )
}

pub fn graphdefinition_new(start, status, name) -> Graphdefinition {
  Graphdefinition(
    link: [],
    profile: None,
    start:,
    purpose: None,
    jurisdiction: [],
    use_context: [],
    description: None,
    contact: [],
    publisher: None,
    date: None,
    experimental: None,
    status:,
    name:,
    version: None,
    url: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/GraphDefinition#resource
pub type GraphdefinitionLink {
  GraphdefinitionLink(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    path: Option(String),
    slice_name: Option(String),
    min: Option(Int),
    max: Option(String),
    description: Option(String),
    target: List(GraphdefinitionLinkTarget),
  )
}

pub fn graphdefinition_link_new() -> GraphdefinitionLink {
  GraphdefinitionLink(
    target: [],
    description: None,
    max: None,
    min: None,
    slice_name: None,
    path: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/GraphDefinition#resource
pub type GraphdefinitionLinkTarget {
  GraphdefinitionLinkTarget(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r4bvaluesets.Resourcetypes,
    params: Option(String),
    profile: Option(String),
    compartment: List(GraphdefinitionLinkTargetCompartment),
    link: List(Nil),
  )
}

pub fn graphdefinition_link_target_new(type_) -> GraphdefinitionLinkTarget {
  GraphdefinitionLinkTarget(
    link: [],
    compartment: [],
    profile: None,
    params: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/GraphDefinition#resource
pub type GraphdefinitionLinkTargetCompartment {
  GraphdefinitionLinkTargetCompartment(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    use_: r4bvaluesets.Graphcompartmentuse,
    code: r4bvaluesets.Compartmenttype,
    rule: r4bvaluesets.Graphcompartmentrule,
    expression: Option(String),
    description: Option(String),
  )
}

pub fn graphdefinition_link_target_compartment_new(
  rule,
  code,
  use_,
) -> GraphdefinitionLinkTargetCompartment {
  GraphdefinitionLinkTargetCompartment(
    description: None,
    expression: None,
    rule:,
    code:,
    use_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Group#resource
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
    type_: r4bvaluesets.Grouptype,
    actual: Bool,
    code: Option(Codeableconcept),
    name: Option(String),
    quantity: Option(Int),
    managing_entity: Option(Reference),
    characteristic: List(GroupCharacteristic),
    member: List(GroupMember),
  )
}

pub fn group_new(actual, type_) -> Group {
  Group(
    member: [],
    characteristic: [],
    managing_entity: None,
    quantity: None,
    name: None,
    code: None,
    actual:,
    type_:,
    active: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Group#resource
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

///http://hl7.org/fhir/r4b/StructureDefinition/Group#resource
pub type GroupCharacteristicValue {
  GroupCharacteristicValueCodeableconcept(value: Codeableconcept)
  GroupCharacteristicValueBoolean(value: Bool)
  GroupCharacteristicValueQuantity(value: Quantity)
  GroupCharacteristicValueRange(value: Range)
  GroupCharacteristicValueReference(value: Reference)
}

pub fn group_characteristic_new(exclude, value, code) -> GroupCharacteristic {
  GroupCharacteristic(
    period: None,
    exclude:,
    value:,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Group#resource
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

pub fn group_member_new(entity) -> GroupMember {
  GroupMember(
    inactive: None,
    period: None,
    entity:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/GuidanceResponse#resource
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
    status: r4bvaluesets.Guidanceresponsestatus,
    subject: Option(Reference),
    encounter: Option(Reference),
    occurrence_date_time: Option(String),
    performer: Option(Reference),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    note: List(Annotation),
    evaluation_message: List(Reference),
    output_parameters: Option(Reference),
    result: Option(Reference),
    data_requirement: List(Datarequirement),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/GuidanceResponse#resource
pub type GuidanceresponseModule {
  GuidanceresponseModuleUri(module: String)
  GuidanceresponseModuleCanonical(module: String)
  GuidanceresponseModuleCodeableconcept(module: Codeableconcept)
}

pub fn guidanceresponse_new(status, module) -> Guidanceresponse {
  Guidanceresponse(
    data_requirement: [],
    result: None,
    output_parameters: None,
    evaluation_message: [],
    note: [],
    reason_reference: [],
    reason_code: [],
    performer: None,
    occurrence_date_time: None,
    encounter: None,
    subject: None,
    status:,
    module:,
    identifier: [],
    request_identifier: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/HealthcareService#resource
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
    category: List(Codeableconcept),
    type_: List(Codeableconcept),
    specialty: List(Codeableconcept),
    location: List(Reference),
    name: Option(String),
    comment: Option(String),
    extra_details: Option(String),
    photo: Option(Attachment),
    telecom: List(Contactpoint),
    coverage_area: List(Reference),
    service_provision_code: List(Codeableconcept),
    eligibility: List(HealthcareserviceEligibility),
    program: List(Codeableconcept),
    characteristic: List(Codeableconcept),
    communication: List(Codeableconcept),
    referral_method: List(Codeableconcept),
    appointment_required: Option(Bool),
    available_time: List(HealthcareserviceAvailabletime),
    not_available: List(HealthcareserviceNotavailable),
    availability_exceptions: Option(String),
    endpoint: List(Reference),
  )
}

pub fn healthcareservice_new() -> Healthcareservice {
  Healthcareservice(
    endpoint: [],
    availability_exceptions: None,
    not_available: [],
    available_time: [],
    appointment_required: None,
    referral_method: [],
    communication: [],
    characteristic: [],
    program: [],
    eligibility: [],
    service_provision_code: [],
    coverage_area: [],
    telecom: [],
    photo: None,
    extra_details: None,
    comment: None,
    name: None,
    location: [],
    specialty: [],
    type_: [],
    category: [],
    provided_by: None,
    active: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/HealthcareService#resource
pub type HealthcareserviceEligibility {
  HealthcareserviceEligibility(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(Codeableconcept),
    comment: Option(String),
  )
}

pub fn healthcareservice_eligibility_new() -> HealthcareserviceEligibility {
  HealthcareserviceEligibility(
    comment: None,
    code: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/HealthcareService#resource
pub type HealthcareserviceAvailabletime {
  HealthcareserviceAvailabletime(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    days_of_week: List(r4bvaluesets.Daysofweek),
    all_day: Option(Bool),
    available_start_time: Option(String),
    available_end_time: Option(String),
  )
}

pub fn healthcareservice_availabletime_new() -> HealthcareserviceAvailabletime {
  HealthcareserviceAvailabletime(
    available_end_time: None,
    available_start_time: None,
    all_day: None,
    days_of_week: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/HealthcareService#resource
pub type HealthcareserviceNotavailable {
  HealthcareserviceNotavailable(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: String,
    during: Option(Period),
  )
}

pub fn healthcareservice_notavailable_new(
  description,
) -> HealthcareserviceNotavailable {
  HealthcareserviceNotavailable(
    during: None,
    description:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ImagingStudy#resource
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
    status: r4bvaluesets.Imagingstudystatus,
    modality: List(Coding),
    subject: Reference,
    encounter: Option(Reference),
    started: Option(String),
    based_on: List(Reference),
    referrer: Option(Reference),
    interpreter: List(Reference),
    endpoint: List(Reference),
    number_of_series: Option(Int),
    number_of_instances: Option(Int),
    procedure_reference: Option(Reference),
    procedure_code: List(Codeableconcept),
    location: Option(Reference),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    note: List(Annotation),
    description: Option(String),
    series: List(ImagingstudySeries),
  )
}

pub fn imagingstudy_new(subject, status) -> Imagingstudy {
  Imagingstudy(
    series: [],
    description: None,
    note: [],
    reason_reference: [],
    reason_code: [],
    location: None,
    procedure_code: [],
    procedure_reference: None,
    number_of_instances: None,
    number_of_series: None,
    endpoint: [],
    interpreter: [],
    referrer: None,
    based_on: [],
    started: None,
    encounter: None,
    subject:,
    modality: [],
    status:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ImagingStudy#resource
pub type ImagingstudySeries {
  ImagingstudySeries(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    uid: String,
    number: Option(Int),
    modality: Coding,
    description: Option(String),
    number_of_instances: Option(Int),
    endpoint: List(Reference),
    body_site: Option(Coding),
    laterality: Option(Coding),
    specimen: List(Reference),
    started: Option(String),
    performer: List(ImagingstudySeriesPerformer),
    instance: List(ImagingstudySeriesInstance),
  )
}

pub fn imagingstudy_series_new(modality, uid) -> ImagingstudySeries {
  ImagingstudySeries(
    instance: [],
    performer: [],
    started: None,
    specimen: [],
    laterality: None,
    body_site: None,
    endpoint: [],
    number_of_instances: None,
    description: None,
    modality:,
    number: None,
    uid:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ImagingStudy#resource
pub type ImagingstudySeriesPerformer {
  ImagingstudySeriesPerformer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    function: Option(Codeableconcept),
    actor: Reference,
  )
}

pub fn imagingstudy_series_performer_new(actor) -> ImagingstudySeriesPerformer {
  ImagingstudySeriesPerformer(
    actor:,
    function: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ImagingStudy#resource
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

pub fn imagingstudy_series_instance_new(
  sop_class,
  uid,
) -> ImagingstudySeriesInstance {
  ImagingstudySeriesInstance(
    title: None,
    number: None,
    sop_class:,
    uid:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Immunization#resource
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
    status: r4bvaluesets.Immunizationstatus,
    status_reason: Option(Codeableconcept),
    vaccine_code: Codeableconcept,
    patient: Reference,
    encounter: Option(Reference),
    occurrence: ImmunizationOccurrence,
    recorded: Option(String),
    primary_source: Option(Bool),
    report_origin: Option(Codeableconcept),
    location: Option(Reference),
    manufacturer: Option(Reference),
    lot_number: Option(String),
    expiration_date: Option(String),
    site: Option(Codeableconcept),
    route: Option(Codeableconcept),
    dose_quantity: Option(Quantity),
    performer: List(ImmunizationPerformer),
    note: List(Annotation),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    is_subpotent: Option(Bool),
    subpotent_reason: List(Codeableconcept),
    education: List(ImmunizationEducation),
    program_eligibility: List(Codeableconcept),
    funding_source: Option(Codeableconcept),
    reaction: List(ImmunizationReaction),
    protocol_applied: List(ImmunizationProtocolapplied),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Immunization#resource
pub type ImmunizationOccurrence {
  ImmunizationOccurrenceDatetime(occurrence: String)
  ImmunizationOccurrenceString(occurrence: String)
}

pub fn immunization_new(
  occurrence,
  patient,
  vaccine_code,
  status,
) -> Immunization {
  Immunization(
    protocol_applied: [],
    reaction: [],
    funding_source: None,
    program_eligibility: [],
    education: [],
    subpotent_reason: [],
    is_subpotent: None,
    reason_reference: [],
    reason_code: [],
    note: [],
    performer: [],
    dose_quantity: None,
    route: None,
    site: None,
    expiration_date: None,
    lot_number: None,
    manufacturer: None,
    location: None,
    report_origin: None,
    primary_source: None,
    recorded: None,
    occurrence:,
    encounter: None,
    patient:,
    vaccine_code:,
    status_reason: None,
    status:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Immunization#resource
pub type ImmunizationPerformer {
  ImmunizationPerformer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    function: Option(Codeableconcept),
    actor: Reference,
  )
}

pub fn immunization_performer_new(actor) -> ImmunizationPerformer {
  ImmunizationPerformer(
    actor:,
    function: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Immunization#resource
pub type ImmunizationEducation {
  ImmunizationEducation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    document_type: Option(String),
    reference: Option(String),
    publication_date: Option(String),
    presentation_date: Option(String),
  )
}

pub fn immunization_education_new() -> ImmunizationEducation {
  ImmunizationEducation(
    presentation_date: None,
    publication_date: None,
    reference: None,
    document_type: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Immunization#resource
pub type ImmunizationReaction {
  ImmunizationReaction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    date: Option(String),
    detail: Option(Reference),
    reported: Option(Bool),
  )
}

pub fn immunization_reaction_new() -> ImmunizationReaction {
  ImmunizationReaction(
    reported: None,
    detail: None,
    date: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Immunization#resource
pub type ImmunizationProtocolapplied {
  ImmunizationProtocolapplied(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    series: Option(String),
    authority: Option(Reference),
    target_disease: List(Codeableconcept),
    dose_number: ImmunizationProtocolappliedDosenumber,
    series_doses: Option(ImmunizationProtocolappliedSeriesdoses),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Immunization#resource
pub type ImmunizationProtocolappliedDosenumber {
  ImmunizationProtocolappliedDosenumberPositiveint(dose_number: Int)
  ImmunizationProtocolappliedDosenumberString(dose_number: String)
}

///http://hl7.org/fhir/r4b/StructureDefinition/Immunization#resource
pub type ImmunizationProtocolappliedSeriesdoses {
  ImmunizationProtocolappliedSeriesdosesPositiveint(series_doses: Int)
  ImmunizationProtocolappliedSeriesdosesString(series_doses: String)
}

pub fn immunization_protocolapplied_new(
  dose_number,
) -> ImmunizationProtocolapplied {
  ImmunizationProtocolapplied(
    series_doses: None,
    dose_number:,
    target_disease: [],
    authority: None,
    series: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ImmunizationEvaluation#resource
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
    status: r4bvaluesets.Immunizationevaluationstatus,
    patient: Reference,
    date: Option(String),
    authority: Option(Reference),
    target_disease: Codeableconcept,
    immunization_event: Reference,
    dose_status: Codeableconcept,
    dose_status_reason: List(Codeableconcept),
    description: Option(String),
    series: Option(String),
    dose_number: Option(ImmunizationevaluationDosenumber),
    series_doses: Option(ImmunizationevaluationSeriesdoses),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ImmunizationEvaluation#resource
pub type ImmunizationevaluationDosenumber {
  ImmunizationevaluationDosenumberPositiveint(dose_number: Int)
  ImmunizationevaluationDosenumberString(dose_number: String)
}

///http://hl7.org/fhir/r4b/StructureDefinition/ImmunizationEvaluation#resource
pub type ImmunizationevaluationSeriesdoses {
  ImmunizationevaluationSeriesdosesPositiveint(series_doses: Int)
  ImmunizationevaluationSeriesdosesString(series_doses: String)
}

pub fn immunizationevaluation_new(
  dose_status,
  immunization_event,
  target_disease,
  patient,
  status,
) -> Immunizationevaluation {
  Immunizationevaluation(
    series_doses: None,
    dose_number: None,
    series: None,
    description: None,
    dose_status_reason: [],
    dose_status:,
    immunization_event:,
    target_disease:,
    authority: None,
    date: None,
    patient:,
    status:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ImmunizationRecommendation#resource
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

pub fn immunizationrecommendation_new(
  date,
  patient,
) -> Immunizationrecommendation {
  Immunizationrecommendation(
    recommendation: [],
    authority: None,
    date:,
    patient:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ImmunizationRecommendation#resource
pub type ImmunizationrecommendationRecommendation {
  ImmunizationrecommendationRecommendation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    vaccine_code: List(Codeableconcept),
    target_disease: Option(Codeableconcept),
    contraindicated_vaccine_code: List(Codeableconcept),
    forecast_status: Codeableconcept,
    forecast_reason: List(Codeableconcept),
    date_criterion: List(ImmunizationrecommendationRecommendationDatecriterion),
    description: Option(String),
    series: Option(String),
    dose_number: Option(ImmunizationrecommendationRecommendationDosenumber),
    series_doses: Option(ImmunizationrecommendationRecommendationSeriesdoses),
    supporting_immunization: List(Reference),
    supporting_patient_information: List(Reference),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ImmunizationRecommendation#resource
pub type ImmunizationrecommendationRecommendationDosenumber {
  ImmunizationrecommendationRecommendationDosenumberPositiveint(
    dose_number: Int,
  )
  ImmunizationrecommendationRecommendationDosenumberString(dose_number: String)
}

///http://hl7.org/fhir/r4b/StructureDefinition/ImmunizationRecommendation#resource
pub type ImmunizationrecommendationRecommendationSeriesdoses {
  ImmunizationrecommendationRecommendationSeriesdosesPositiveint(
    series_doses: Int,
  )
  ImmunizationrecommendationRecommendationSeriesdosesString(
    series_doses: String,
  )
}

pub fn immunizationrecommendation_recommendation_new(
  forecast_status,
) -> ImmunizationrecommendationRecommendation {
  ImmunizationrecommendationRecommendation(
    supporting_patient_information: [],
    supporting_immunization: [],
    series_doses: None,
    dose_number: None,
    series: None,
    description: None,
    date_criterion: [],
    forecast_reason: [],
    forecast_status:,
    contraindicated_vaccine_code: [],
    target_disease: None,
    vaccine_code: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ImmunizationRecommendation#resource
pub type ImmunizationrecommendationRecommendationDatecriterion {
  ImmunizationrecommendationRecommendationDatecriterion(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
    value: String,
  )
}

pub fn immunizationrecommendation_recommendation_datecriterion_new(
  value,
  code,
) -> ImmunizationrecommendationRecommendationDatecriterion {
  ImmunizationrecommendationRecommendationDatecriterion(
    value:,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ImplementationGuide#resource
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
    version: Option(String),
    name: String,
    title: Option(String),
    status: r4bvaluesets.Publicationstatus,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    copyright: Option(String),
    package_id: String,
    license: Option(r4bvaluesets.Spdxlicense),
    fhir_version: List(r4bvaluesets.Fhirversion),
    depends_on: List(ImplementationguideDependson),
    global: List(ImplementationguideGlobal),
    definition: Option(ImplementationguideDefinition),
    manifest: Option(ImplementationguideManifest),
  )
}

pub fn implementationguide_new(
  package_id,
  status,
  name,
  url,
) -> Implementationguide {
  Implementationguide(
    manifest: None,
    definition: None,
    global: [],
    depends_on: [],
    fhir_version: [],
    license: None,
    package_id:,
    copyright: None,
    jurisdiction: [],
    use_context: [],
    description: None,
    contact: [],
    publisher: None,
    date: None,
    experimental: None,
    status:,
    title: None,
    name:,
    version: None,
    url:,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideDependson {
  ImplementationguideDependson(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    uri: String,
    package_id: Option(String),
    version: Option(String),
  )
}

pub fn implementationguide_dependson_new(uri) -> ImplementationguideDependson {
  ImplementationguideDependson(
    version: None,
    package_id: None,
    uri:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideGlobal {
  ImplementationguideGlobal(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r4bvaluesets.Resourcetypes,
    profile: String,
  )
}

pub fn implementationguide_global_new(
  profile,
  type_,
) -> ImplementationguideGlobal {
  ImplementationguideGlobal(
    profile:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ImplementationGuide#resource
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

pub fn implementationguide_definition_new() -> ImplementationguideDefinition {
  ImplementationguideDefinition(
    template: [],
    parameter: [],
    page: None,
    resource: [],
    grouping: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideDefinitionGrouping {
  ImplementationguideDefinitionGrouping(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    description: Option(String),
  )
}

pub fn implementationguide_definition_grouping_new(
  name,
) -> ImplementationguideDefinitionGrouping {
  ImplementationguideDefinitionGrouping(
    description: None,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideDefinitionResource {
  ImplementationguideDefinitionResource(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    reference: Reference,
    fhir_version: List(r4bvaluesets.Fhirversion),
    name: Option(String),
    description: Option(String),
    example: Option(ImplementationguideDefinitionResourceExample),
    grouping_id: Option(String),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideDefinitionResourceExample {
  ImplementationguideDefinitionResourceExampleBoolean(example: Bool)
  ImplementationguideDefinitionResourceExampleCanonical(example: String)
}

pub fn implementationguide_definition_resource_new(
  reference,
) -> ImplementationguideDefinitionResource {
  ImplementationguideDefinitionResource(
    grouping_id: None,
    example: None,
    description: None,
    name: None,
    fhir_version: [],
    reference:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideDefinitionPage {
  ImplementationguideDefinitionPage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: ImplementationguideDefinitionPageName,
    title: String,
    generation: r4bvaluesets.Guidepagegeneration,
    page: List(Nil),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideDefinitionPageName {
  ImplementationguideDefinitionPageNameUrl(name: String)
  ImplementationguideDefinitionPageNameReference(name: Reference)
}

pub fn implementationguide_definition_page_new(
  generation,
  title,
  name,
) -> ImplementationguideDefinitionPage {
  ImplementationguideDefinitionPage(
    page: [],
    generation:,
    title:,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideDefinitionParameter {
  ImplementationguideDefinitionParameter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: r4bvaluesets.Guideparametercode,
    value: String,
  )
}

pub fn implementationguide_definition_parameter_new(
  value,
  code,
) -> ImplementationguideDefinitionParameter {
  ImplementationguideDefinitionParameter(
    value:,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ImplementationGuide#resource
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

pub fn implementationguide_definition_template_new(
  source,
  code,
) -> ImplementationguideDefinitionTemplate {
  ImplementationguideDefinitionTemplate(
    scope: None,
    source:,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ImplementationGuide#resource
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

pub fn implementationguide_manifest_new() -> ImplementationguideManifest {
  ImplementationguideManifest(
    other: [],
    image: [],
    page: [],
    resource: [],
    rendering: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideManifestResource {
  ImplementationguideManifestResource(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    reference: Reference,
    example: Option(ImplementationguideManifestResourceExample),
    relative_path: Option(String),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideManifestResourceExample {
  ImplementationguideManifestResourceExampleBoolean(example: Bool)
  ImplementationguideManifestResourceExampleCanonical(example: String)
}

pub fn implementationguide_manifest_resource_new(
  reference,
) -> ImplementationguideManifestResource {
  ImplementationguideManifestResource(
    relative_path: None,
    example: None,
    reference:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ImplementationGuide#resource
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

pub fn implementationguide_manifest_page_new(
  name,
) -> ImplementationguideManifestPage {
  ImplementationguideManifestPage(
    anchor: [],
    title: None,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Ingredient#resource
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
    status: r4bvaluesets.Publicationstatus,
    for: List(Reference),
    role: Codeableconcept,
    function: List(Codeableconcept),
    allergenic_indicator: Option(Bool),
    manufacturer: List(IngredientManufacturer),
    substance: IngredientSubstance,
  )
}

pub fn ingredient_new(substance, role, status) -> Ingredient {
  Ingredient(
    substance:,
    manufacturer: [],
    allergenic_indicator: None,
    function: [],
    role:,
    for: [],
    status:,
    identifier: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Ingredient#resource
pub type IngredientManufacturer {
  IngredientManufacturer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    role: Option(r4bvaluesets.Ingredientmanufacturerrole),
    manufacturer: Reference,
  )
}

pub fn ingredient_manufacturer_new(manufacturer) -> IngredientManufacturer {
  IngredientManufacturer(
    manufacturer:,
    role: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Ingredient#resource
pub type IngredientSubstance {
  IngredientSubstance(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeablereference,
    strength: List(IngredientSubstanceStrength),
  )
}

pub fn ingredient_substance_new(code) -> IngredientSubstance {
  IngredientSubstance(
    strength: [],
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Ingredient#resource
pub type IngredientSubstanceStrength {
  IngredientSubstanceStrength(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    presentation: Option(IngredientSubstanceStrengthPresentation),
    text_presentation: Option(String),
    concentration: Option(IngredientSubstanceStrengthConcentration),
    text_concentration: Option(String),
    measurement_point: Option(String),
    country: List(Codeableconcept),
    reference_strength: List(IngredientSubstanceStrengthReferencestrength),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Ingredient#resource
pub type IngredientSubstanceStrengthPresentation {
  IngredientSubstanceStrengthPresentationRatio(presentation: Ratio)
  IngredientSubstanceStrengthPresentationRatiorange(presentation: Ratiorange)
}

///http://hl7.org/fhir/r4b/StructureDefinition/Ingredient#resource
pub type IngredientSubstanceStrengthConcentration {
  IngredientSubstanceStrengthConcentrationRatio(concentration: Ratio)
  IngredientSubstanceStrengthConcentrationRatiorange(concentration: Ratiorange)
}

pub fn ingredient_substance_strength_new() -> IngredientSubstanceStrength {
  IngredientSubstanceStrength(
    reference_strength: [],
    country: [],
    measurement_point: None,
    text_concentration: None,
    concentration: None,
    text_presentation: None,
    presentation: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Ingredient#resource
pub type IngredientSubstanceStrengthReferencestrength {
  IngredientSubstanceStrengthReferencestrength(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    substance: Option(Codeablereference),
    strength: IngredientSubstanceStrengthReferencestrengthStrength,
    measurement_point: Option(String),
    country: List(Codeableconcept),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Ingredient#resource
pub type IngredientSubstanceStrengthReferencestrengthStrength {
  IngredientSubstanceStrengthReferencestrengthStrengthRatio(strength: Ratio)
  IngredientSubstanceStrengthReferencestrengthStrengthRatiorange(
    strength: Ratiorange,
  )
}

pub fn ingredient_substance_strength_referencestrength_new(
  strength,
) -> IngredientSubstanceStrengthReferencestrength {
  IngredientSubstanceStrengthReferencestrength(
    country: [],
    measurement_point: None,
    strength:,
    substance: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/InsurancePlan#resource
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
    status: Option(r4bvaluesets.Publicationstatus),
    type_: List(Codeableconcept),
    name: Option(String),
    alias: List(String),
    period: Option(Period),
    owned_by: Option(Reference),
    administered_by: Option(Reference),
    coverage_area: List(Reference),
    contact: List(InsuranceplanContact),
    endpoint: List(Reference),
    network: List(Reference),
    coverage: List(InsuranceplanCoverage),
    plan: List(InsuranceplanPlan),
  )
}

pub fn insuranceplan_new() -> Insuranceplan {
  Insuranceplan(
    plan: [],
    coverage: [],
    network: [],
    endpoint: [],
    contact: [],
    coverage_area: [],
    administered_by: None,
    owned_by: None,
    period: None,
    alias: [],
    name: None,
    type_: [],
    status: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/InsurancePlan#resource
pub type InsuranceplanContact {
  InsuranceplanContact(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    purpose: Option(Codeableconcept),
    name: Option(Humanname),
    telecom: List(Contactpoint),
    address: Option(Address),
  )
}

pub fn insuranceplan_contact_new() -> InsuranceplanContact {
  InsuranceplanContact(
    address: None,
    telecom: [],
    name: None,
    purpose: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/InsurancePlan#resource
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

pub fn insuranceplan_coverage_new(type_) -> InsuranceplanCoverage {
  InsuranceplanCoverage(
    benefit: [],
    network: [],
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/InsurancePlan#resource
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

pub fn insuranceplan_coverage_benefit_new(type_) -> InsuranceplanCoverageBenefit {
  InsuranceplanCoverageBenefit(
    limit: [],
    requirement: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/InsurancePlan#resource
pub type InsuranceplanCoverageBenefitLimit {
  InsuranceplanCoverageBenefitLimit(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    value: Option(Quantity),
    code: Option(Codeableconcept),
  )
}

pub fn insuranceplan_coverage_benefit_limit_new() -> InsuranceplanCoverageBenefitLimit {
  InsuranceplanCoverageBenefitLimit(
    code: None,
    value: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/InsurancePlan#resource
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

pub fn insuranceplan_plan_new() -> InsuranceplanPlan {
  InsuranceplanPlan(
    specific_cost: [],
    general_cost: [],
    network: [],
    coverage_area: [],
    type_: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/InsurancePlan#resource
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

pub fn insuranceplan_plan_generalcost_new() -> InsuranceplanPlanGeneralcost {
  InsuranceplanPlanGeneralcost(
    comment: None,
    cost: None,
    group_size: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/InsurancePlan#resource
pub type InsuranceplanPlanSpecificcost {
  InsuranceplanPlanSpecificcost(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    category: Codeableconcept,
    benefit: List(InsuranceplanPlanSpecificcostBenefit),
  )
}

pub fn insuranceplan_plan_specificcost_new(
  category,
) -> InsuranceplanPlanSpecificcost {
  InsuranceplanPlanSpecificcost(
    benefit: [],
    category:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/InsurancePlan#resource
pub type InsuranceplanPlanSpecificcostBenefit {
  InsuranceplanPlanSpecificcostBenefit(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    cost: List(InsuranceplanPlanSpecificcostBenefitCost),
  )
}

pub fn insuranceplan_plan_specificcost_benefit_new(
  type_,
) -> InsuranceplanPlanSpecificcostBenefit {
  InsuranceplanPlanSpecificcostBenefit(
    cost: [],
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/InsurancePlan#resource
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

pub fn insuranceplan_plan_specificcost_benefit_cost_new(
  type_,
) -> InsuranceplanPlanSpecificcostBenefitCost {
  InsuranceplanPlanSpecificcostBenefitCost(
    value: None,
    qualifiers: [],
    applicability: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Invoice#resource
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
    status: r4bvaluesets.Invoicestatus,
    cancelled_reason: Option(String),
    type_: Option(Codeableconcept),
    subject: Option(Reference),
    recipient: Option(Reference),
    date: Option(String),
    participant: List(InvoiceParticipant),
    issuer: Option(Reference),
    account: Option(Reference),
    line_item: List(InvoiceLineitem),
    total_price_component: List(Nil),
    total_net: Option(Money),
    total_gross: Option(Money),
    payment_terms: Option(String),
    note: List(Annotation),
  )
}

pub fn invoice_new(status) -> Invoice {
  Invoice(
    note: [],
    payment_terms: None,
    total_gross: None,
    total_net: None,
    total_price_component: [],
    line_item: [],
    account: None,
    issuer: None,
    participant: [],
    date: None,
    recipient: None,
    subject: None,
    type_: None,
    cancelled_reason: None,
    status:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Invoice#resource
pub type InvoiceParticipant {
  InvoiceParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    role: Option(Codeableconcept),
    actor: Reference,
  )
}

pub fn invoice_participant_new(actor) -> InvoiceParticipant {
  InvoiceParticipant(
    actor:,
    role: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Invoice#resource
pub type InvoiceLineitem {
  InvoiceLineitem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    sequence: Option(Int),
    charge_item: InvoiceLineitemChargeitem,
    price_component: List(InvoiceLineitemPricecomponent),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Invoice#resource
pub type InvoiceLineitemChargeitem {
  InvoiceLineitemChargeitemReference(charge_item: Reference)
  InvoiceLineitemChargeitemCodeableconcept(charge_item: Codeableconcept)
}

pub fn invoice_lineitem_new(charge_item) -> InvoiceLineitem {
  InvoiceLineitem(
    price_component: [],
    charge_item:,
    sequence: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Invoice#resource
pub type InvoiceLineitemPricecomponent {
  InvoiceLineitemPricecomponent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r4bvaluesets.Invoicepricecomponenttype,
    code: Option(Codeableconcept),
    factor: Option(Float),
    amount: Option(Money),
  )
}

pub fn invoice_lineitem_pricecomponent_new(
  type_,
) -> InvoiceLineitemPricecomponent {
  InvoiceLineitemPricecomponent(
    amount: None,
    factor: None,
    code: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Library#resource
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
    name: Option(String),
    title: Option(String),
    subtitle: Option(String),
    status: r4bvaluesets.Publicationstatus,
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

///http://hl7.org/fhir/r4b/StructureDefinition/Library#resource
pub type LibrarySubject {
  LibrarySubjectCodeableconcept(subject: Codeableconcept)
  LibrarySubjectReference(subject: Reference)
}

pub fn library_new(type_, status) -> Library {
  Library(
    content: [],
    data_requirement: [],
    parameter: [],
    related_artifact: [],
    endorser: [],
    reviewer: [],
    editor: [],
    author: [],
    topic: [],
    effective_period: None,
    last_review_date: None,
    approval_date: None,
    copyright: None,
    usage: None,
    purpose: None,
    jurisdiction: [],
    use_context: [],
    description: None,
    contact: [],
    publisher: None,
    date: None,
    subject: None,
    type_:,
    experimental: None,
    status:,
    subtitle: None,
    title: None,
    name: None,
    version: None,
    identifier: [],
    url: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Linkage#resource
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

pub fn linkage_new() -> Linkage {
  Linkage(
    item: [],
    author: None,
    active: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Linkage#resource
pub type LinkageItem {
  LinkageItem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r4bvaluesets.Linkagetype,
    resource: Reference,
  )
}

pub fn linkage_item_new(resource, type_) -> LinkageItem {
  LinkageItem(
    resource:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/List#resource
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
    status: r4bvaluesets.Liststatus,
    mode: r4bvaluesets.Listmode,
    title: Option(String),
    code: Option(Codeableconcept),
    subject: Option(Reference),
    encounter: Option(Reference),
    date: Option(String),
    source: Option(Reference),
    ordered_by: Option(Codeableconcept),
    note: List(Annotation),
    entry: List(ListEntry),
    empty_reason: Option(Codeableconcept),
  )
}

pub fn fhir_list_new(mode, status) -> FhirList {
  FhirList(
    empty_reason: None,
    entry: [],
    note: [],
    ordered_by: None,
    source: None,
    date: None,
    encounter: None,
    subject: None,
    code: None,
    title: None,
    mode:,
    status:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/List#resource
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

pub fn list_entry_new(item) -> ListEntry {
  ListEntry(
    item:,
    date: None,
    deleted: None,
    flag: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Location#resource
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
    status: Option(r4bvaluesets.Locationstatus),
    operational_status: Option(Coding),
    name: Option(String),
    alias: List(String),
    description: Option(String),
    mode: Option(r4bvaluesets.Locationmode),
    type_: List(Codeableconcept),
    telecom: List(Contactpoint),
    address: Option(Address),
    physical_type: Option(Codeableconcept),
    position: Option(LocationPosition),
    managing_organization: Option(Reference),
    part_of: Option(Reference),
    hours_of_operation: List(LocationHoursofoperation),
    availability_exceptions: Option(String),
    endpoint: List(Reference),
  )
}

pub fn location_new() -> Location {
  Location(
    endpoint: [],
    availability_exceptions: None,
    hours_of_operation: [],
    part_of: None,
    managing_organization: None,
    position: None,
    physical_type: None,
    address: None,
    telecom: [],
    type_: [],
    mode: None,
    description: None,
    alias: [],
    name: None,
    operational_status: None,
    status: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Location#resource
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

pub fn location_position_new(latitude, longitude) -> LocationPosition {
  LocationPosition(
    altitude: None,
    latitude:,
    longitude:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Location#resource
pub type LocationHoursofoperation {
  LocationHoursofoperation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    days_of_week: List(r4bvaluesets.Daysofweek),
    all_day: Option(Bool),
    opening_time: Option(String),
    closing_time: Option(String),
  )
}

pub fn location_hoursofoperation_new() -> LocationHoursofoperation {
  LocationHoursofoperation(
    closing_time: None,
    opening_time: None,
    all_day: None,
    days_of_week: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ManufacturedItemDefinition#resource
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
    status: r4bvaluesets.Publicationstatus,
    manufactured_dose_form: Codeableconcept,
    unit_of_presentation: Option(Codeableconcept),
    manufacturer: List(Reference),
    ingredient: List(Codeableconcept),
    property: List(ManufactureditemdefinitionProperty),
  )
}

pub fn manufactureditemdefinition_new(
  manufactured_dose_form,
  status,
) -> Manufactureditemdefinition {
  Manufactureditemdefinition(
    property: [],
    ingredient: [],
    manufacturer: [],
    unit_of_presentation: None,
    manufactured_dose_form:,
    status:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ManufacturedItemDefinition#resource
pub type ManufactureditemdefinitionProperty {
  ManufactureditemdefinitionProperty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value: Option(ManufactureditemdefinitionPropertyValue),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ManufacturedItemDefinition#resource
pub type ManufactureditemdefinitionPropertyValue {
  ManufactureditemdefinitionPropertyValueCodeableconcept(value: Codeableconcept)
  ManufactureditemdefinitionPropertyValueQuantity(value: Quantity)
  ManufactureditemdefinitionPropertyValueDate(value: String)
  ManufactureditemdefinitionPropertyValueBoolean(value: Bool)
  ManufactureditemdefinitionPropertyValueAttachment(value: Attachment)
}

pub fn manufactureditemdefinition_property_new(
  type_,
) -> ManufactureditemdefinitionProperty {
  ManufactureditemdefinitionProperty(
    value: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Measure#resource
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
    name: Option(String),
    title: Option(String),
    subtitle: Option(String),
    status: r4bvaluesets.Publicationstatus,
    experimental: Option(Bool),
    subject: Option(MeasureSubject),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    usage: Option(String),
    copyright: Option(String),
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
    composite_scoring: Option(Codeableconcept),
    type_: List(Codeableconcept),
    risk_adjustment: Option(String),
    rate_aggregation: Option(String),
    rationale: Option(String),
    clinical_recommendation_statement: Option(String),
    improvement_notation: Option(Codeableconcept),
    definition: List(String),
    guidance: Option(String),
    group: List(MeasureGroup),
    supplemental_data: List(MeasureSupplementaldata),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Measure#resource
pub type MeasureSubject {
  MeasureSubjectCodeableconcept(subject: Codeableconcept)
  MeasureSubjectReference(subject: Reference)
}

pub fn measure_new(status) -> Measure {
  Measure(
    supplemental_data: [],
    group: [],
    guidance: None,
    definition: [],
    improvement_notation: None,
    clinical_recommendation_statement: None,
    rationale: None,
    rate_aggregation: None,
    risk_adjustment: None,
    type_: [],
    composite_scoring: None,
    scoring: None,
    disclaimer: None,
    library: [],
    related_artifact: [],
    endorser: [],
    reviewer: [],
    editor: [],
    author: [],
    topic: [],
    effective_period: None,
    last_review_date: None,
    approval_date: None,
    copyright: None,
    usage: None,
    purpose: None,
    jurisdiction: [],
    use_context: [],
    description: None,
    contact: [],
    publisher: None,
    date: None,
    subject: None,
    experimental: None,
    status:,
    subtitle: None,
    title: None,
    name: None,
    version: None,
    identifier: [],
    url: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Measure#resource
pub type MeasureGroup {
  MeasureGroup(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(Codeableconcept),
    description: Option(String),
    population: List(MeasureGroupPopulation),
    stratifier: List(MeasureGroupStratifier),
  )
}

pub fn measure_group_new() -> MeasureGroup {
  MeasureGroup(
    stratifier: [],
    population: [],
    description: None,
    code: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Measure#resource
pub type MeasureGroupPopulation {
  MeasureGroupPopulation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(Codeableconcept),
    description: Option(String),
    criteria: Expression,
  )
}

pub fn measure_group_population_new(criteria) -> MeasureGroupPopulation {
  MeasureGroupPopulation(
    criteria:,
    description: None,
    code: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Measure#resource
pub type MeasureGroupStratifier {
  MeasureGroupStratifier(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(Codeableconcept),
    description: Option(String),
    criteria: Option(Expression),
    component: List(MeasureGroupStratifierComponent),
  )
}

pub fn measure_group_stratifier_new() -> MeasureGroupStratifier {
  MeasureGroupStratifier(
    component: [],
    criteria: None,
    description: None,
    code: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Measure#resource
pub type MeasureGroupStratifierComponent {
  MeasureGroupStratifierComponent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(Codeableconcept),
    description: Option(String),
    criteria: Expression,
  )
}

pub fn measure_group_stratifier_component_new(
  criteria,
) -> MeasureGroupStratifierComponent {
  MeasureGroupStratifierComponent(
    criteria:,
    description: None,
    code: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Measure#resource
pub type MeasureSupplementaldata {
  MeasureSupplementaldata(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(Codeableconcept),
    usage: List(Codeableconcept),
    description: Option(String),
    criteria: Expression,
  )
}

pub fn measure_supplementaldata_new(criteria) -> MeasureSupplementaldata {
  MeasureSupplementaldata(
    criteria:,
    description: None,
    usage: [],
    code: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MeasureReport#resource
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
    status: r4bvaluesets.Measurereportstatus,
    type_: r4bvaluesets.Measurereporttype,
    measure: String,
    subject: Option(Reference),
    date: Option(String),
    reporter: Option(Reference),
    period: Period,
    improvement_notation: Option(Codeableconcept),
    group: List(MeasurereportGroup),
    evaluated_resource: List(Reference),
  )
}

pub fn measurereport_new(period, measure, type_, status) -> Measurereport {
  Measurereport(
    evaluated_resource: [],
    group: [],
    improvement_notation: None,
    period:,
    reporter: None,
    date: None,
    subject: None,
    measure:,
    type_:,
    status:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MeasureReport#resource
pub type MeasurereportGroup {
  MeasurereportGroup(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(Codeableconcept),
    population: List(MeasurereportGroupPopulation),
    measure_score: Option(Quantity),
    stratifier: List(MeasurereportGroupStratifier),
  )
}

pub fn measurereport_group_new() -> MeasurereportGroup {
  MeasurereportGroup(
    stratifier: [],
    measure_score: None,
    population: [],
    code: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MeasureReport#resource
pub type MeasurereportGroupPopulation {
  MeasurereportGroupPopulation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(Codeableconcept),
    count: Option(Int),
    subject_results: Option(Reference),
  )
}

pub fn measurereport_group_population_new() -> MeasurereportGroupPopulation {
  MeasurereportGroupPopulation(
    subject_results: None,
    count: None,
    code: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MeasureReport#resource
pub type MeasurereportGroupStratifier {
  MeasurereportGroupStratifier(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: List(Codeableconcept),
    stratum: List(MeasurereportGroupStratifierStratum),
  )
}

pub fn measurereport_group_stratifier_new() -> MeasurereportGroupStratifier {
  MeasurereportGroupStratifier(
    stratum: [],
    code: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MeasureReport#resource
pub type MeasurereportGroupStratifierStratum {
  MeasurereportGroupStratifierStratum(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    value: Option(Codeableconcept),
    component: List(MeasurereportGroupStratifierStratumComponent),
    population: List(MeasurereportGroupStratifierStratumPopulation),
    measure_score: Option(Quantity),
  )
}

pub fn measurereport_group_stratifier_stratum_new() -> MeasurereportGroupStratifierStratum {
  MeasurereportGroupStratifierStratum(
    measure_score: None,
    population: [],
    component: [],
    value: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MeasureReport#resource
pub type MeasurereportGroupStratifierStratumComponent {
  MeasurereportGroupStratifierStratumComponent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
    value: Codeableconcept,
  )
}

pub fn measurereport_group_stratifier_stratum_component_new(
  value,
  code,
) -> MeasurereportGroupStratifierStratumComponent {
  MeasurereportGroupStratifierStratumComponent(
    value:,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MeasureReport#resource
pub type MeasurereportGroupStratifierStratumPopulation {
  MeasurereportGroupStratifierStratumPopulation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(Codeableconcept),
    count: Option(Int),
    subject_results: Option(Reference),
  )
}

pub fn measurereport_group_stratifier_stratum_population_new() -> MeasurereportGroupStratifierStratumPopulation {
  MeasurereportGroupStratifierStratumPopulation(
    subject_results: None,
    count: None,
    code: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Media#resource
pub type Media {
  Media(
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
    status: r4bvaluesets.Eventstatus,
    type_: Option(Codeableconcept),
    modality: Option(Codeableconcept),
    view: Option(Codeableconcept),
    subject: Option(Reference),
    encounter: Option(Reference),
    created: Option(MediaCreated),
    issued: Option(String),
    operator: Option(Reference),
    reason_code: List(Codeableconcept),
    body_site: Option(Codeableconcept),
    device_name: Option(String),
    device: Option(Reference),
    height: Option(Int),
    width: Option(Int),
    frames: Option(Int),
    duration: Option(Float),
    content: Attachment,
    note: List(Annotation),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Media#resource
pub type MediaCreated {
  MediaCreatedDatetime(created: String)
  MediaCreatedPeriod(created: Period)
}

pub fn media_new(content, status) -> Media {
  Media(
    note: [],
    content:,
    duration: None,
    frames: None,
    width: None,
    height: None,
    device: None,
    device_name: None,
    body_site: None,
    reason_code: [],
    operator: None,
    issued: None,
    created: None,
    encounter: None,
    subject: None,
    view: None,
    modality: None,
    type_: None,
    status:,
    part_of: [],
    based_on: [],
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Medication#resource
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
    status: Option(r4bvaluesets.Medicationstatus),
    manufacturer: Option(Reference),
    form: Option(Codeableconcept),
    amount: Option(Ratio),
    ingredient: List(MedicationIngredient),
    batch: Option(MedicationBatch),
  )
}

pub fn medication_new() -> Medication {
  Medication(
    batch: None,
    ingredient: [],
    amount: None,
    form: None,
    manufacturer: None,
    status: None,
    code: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Medication#resource
pub type MedicationIngredient {
  MedicationIngredient(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item: MedicationIngredientItem,
    is_active: Option(Bool),
    strength: Option(Ratio),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Medication#resource
pub type MedicationIngredientItem {
  MedicationIngredientItemCodeableconcept(item: Codeableconcept)
  MedicationIngredientItemReference(item: Reference)
}

pub fn medication_ingredient_new(item) -> MedicationIngredient {
  MedicationIngredient(
    strength: None,
    is_active: None,
    item:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Medication#resource
pub type MedicationBatch {
  MedicationBatch(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    lot_number: Option(String),
    expiration_date: Option(String),
  )
}

pub fn medication_batch_new() -> MedicationBatch {
  MedicationBatch(
    expiration_date: None,
    lot_number: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationAdministration#resource
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
    instantiates: List(String),
    part_of: List(Reference),
    status: r4bvaluesets.Medicationadminstatus,
    status_reason: List(Codeableconcept),
    category: Option(Codeableconcept),
    medication: MedicationadministrationMedication,
    subject: Reference,
    context: Option(Reference),
    supporting_information: List(Reference),
    effective: MedicationadministrationEffective,
    performer: List(MedicationadministrationPerformer),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    request: Option(Reference),
    device: List(Reference),
    note: List(Annotation),
    dosage: Option(MedicationadministrationDosage),
    event_history: List(Reference),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationAdministration#resource
pub type MedicationadministrationMedication {
  MedicationadministrationMedicationCodeableconcept(medication: Codeableconcept)
  MedicationadministrationMedicationReference(medication: Reference)
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationAdministration#resource
pub type MedicationadministrationEffective {
  MedicationadministrationEffectiveDatetime(effective: String)
  MedicationadministrationEffectivePeriod(effective: Period)
}

pub fn medicationadministration_new(
  effective,
  subject,
  medication,
  status,
) -> Medicationadministration {
  Medicationadministration(
    event_history: [],
    dosage: None,
    note: [],
    device: [],
    request: None,
    reason_reference: [],
    reason_code: [],
    performer: [],
    effective:,
    supporting_information: [],
    context: None,
    subject:,
    medication:,
    category: None,
    status_reason: [],
    status:,
    part_of: [],
    instantiates: [],
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationAdministration#resource
pub type MedicationadministrationPerformer {
  MedicationadministrationPerformer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    function: Option(Codeableconcept),
    actor: Reference,
  )
}

pub fn medicationadministration_performer_new(
  actor,
) -> MedicationadministrationPerformer {
  MedicationadministrationPerformer(
    actor:,
    function: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationAdministration#resource
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

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationAdministration#resource
pub type MedicationadministrationDosageRate {
  MedicationadministrationDosageRateRatio(rate: Ratio)
  MedicationadministrationDosageRateQuantity(rate: Quantity)
}

pub fn medicationadministration_dosage_new() -> MedicationadministrationDosage {
  MedicationadministrationDosage(
    rate: None,
    dose: None,
    method: None,
    route: None,
    site: None,
    text: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationDispense#resource
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
    part_of: List(Reference),
    status: r4bvaluesets.Medicationdispensestatus,
    status_reason: Option(MedicationdispenseStatusreason),
    category: Option(Codeableconcept),
    medication: MedicationdispenseMedication,
    subject: Option(Reference),
    context: Option(Reference),
    supporting_information: List(Reference),
    performer: List(MedicationdispensePerformer),
    location: Option(Reference),
    authorizing_prescription: List(Reference),
    type_: Option(Codeableconcept),
    quantity: Option(Quantity),
    days_supply: Option(Quantity),
    when_prepared: Option(String),
    when_handed_over: Option(String),
    destination: Option(Reference),
    receiver: List(Reference),
    note: List(Annotation),
    dosage_instruction: List(Dosage),
    substitution: Option(MedicationdispenseSubstitution),
    detected_issue: List(Reference),
    event_history: List(Reference),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationDispense#resource
pub type MedicationdispenseStatusreason {
  MedicationdispenseStatusreasonCodeableconcept(status_reason: Codeableconcept)
  MedicationdispenseStatusreasonReference(status_reason: Reference)
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationDispense#resource
pub type MedicationdispenseMedication {
  MedicationdispenseMedicationCodeableconcept(medication: Codeableconcept)
  MedicationdispenseMedicationReference(medication: Reference)
}

pub fn medicationdispense_new(medication, status) -> Medicationdispense {
  Medicationdispense(
    event_history: [],
    detected_issue: [],
    substitution: None,
    dosage_instruction: [],
    note: [],
    receiver: [],
    destination: None,
    when_handed_over: None,
    when_prepared: None,
    days_supply: None,
    quantity: None,
    type_: None,
    authorizing_prescription: [],
    location: None,
    performer: [],
    supporting_information: [],
    context: None,
    subject: None,
    medication:,
    category: None,
    status_reason: None,
    status:,
    part_of: [],
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationDispense#resource
pub type MedicationdispensePerformer {
  MedicationdispensePerformer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    function: Option(Codeableconcept),
    actor: Reference,
  )
}

pub fn medicationdispense_performer_new(actor) -> MedicationdispensePerformer {
  MedicationdispensePerformer(
    actor:,
    function: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationDispense#resource
pub type MedicationdispenseSubstitution {
  MedicationdispenseSubstitution(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    was_substituted: Bool,
    type_: Option(Codeableconcept),
    reason: List(Codeableconcept),
    responsible_party: List(Reference),
  )
}

pub fn medicationdispense_substitution_new(
  was_substituted,
) -> MedicationdispenseSubstitution {
  MedicationdispenseSubstitution(
    responsible_party: [],
    reason: [],
    type_: None,
    was_substituted:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationKnowledge#resource
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
    code: Option(Codeableconcept),
    status: Option(r4bvaluesets.Medicationknowledgestatus),
    manufacturer: Option(Reference),
    dose_form: Option(Codeableconcept),
    amount: Option(Quantity),
    synonym: List(String),
    related_medication_knowledge: List(
      MedicationknowledgeRelatedmedicationknowledge,
    ),
    associated_medication: List(Reference),
    product_type: List(Codeableconcept),
    monograph: List(MedicationknowledgeMonograph),
    ingredient: List(MedicationknowledgeIngredient),
    preparation_instruction: Option(String),
    intended_route: List(Codeableconcept),
    cost: List(MedicationknowledgeCost),
    monitoring_program: List(MedicationknowledgeMonitoringprogram),
    administration_guidelines: List(MedicationknowledgeAdministrationguidelines),
    medicine_classification: List(MedicationknowledgeMedicineclassification),
    packaging: Option(MedicationknowledgePackaging),
    drug_characteristic: List(MedicationknowledgeDrugcharacteristic),
    contraindication: List(Reference),
    regulatory: List(MedicationknowledgeRegulatory),
    kinetics: List(MedicationknowledgeKinetics),
  )
}

pub fn medicationknowledge_new() -> Medicationknowledge {
  Medicationknowledge(
    kinetics: [],
    regulatory: [],
    contraindication: [],
    drug_characteristic: [],
    packaging: None,
    medicine_classification: [],
    administration_guidelines: [],
    monitoring_program: [],
    cost: [],
    intended_route: [],
    preparation_instruction: None,
    ingredient: [],
    monograph: [],
    product_type: [],
    associated_medication: [],
    related_medication_knowledge: [],
    synonym: [],
    amount: None,
    dose_form: None,
    manufacturer: None,
    status: None,
    code: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeRelatedmedicationknowledge {
  MedicationknowledgeRelatedmedicationknowledge(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    reference: List(Reference),
  )
}

pub fn medicationknowledge_relatedmedicationknowledge_new(
  type_,
) -> MedicationknowledgeRelatedmedicationknowledge {
  MedicationknowledgeRelatedmedicationknowledge(
    reference: [],
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeMonograph {
  MedicationknowledgeMonograph(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    source: Option(Reference),
  )
}

pub fn medicationknowledge_monograph_new() -> MedicationknowledgeMonograph {
  MedicationknowledgeMonograph(
    source: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeIngredient {
  MedicationknowledgeIngredient(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item: MedicationknowledgeIngredientItem,
    is_active: Option(Bool),
    strength: Option(Ratio),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeIngredientItem {
  MedicationknowledgeIngredientItemCodeableconcept(item: Codeableconcept)
  MedicationknowledgeIngredientItemReference(item: Reference)
}

pub fn medicationknowledge_ingredient_new(item) -> MedicationknowledgeIngredient {
  MedicationknowledgeIngredient(
    strength: None,
    is_active: None,
    item:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeCost {
  MedicationknowledgeCost(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    source: Option(String),
    cost: Money,
  )
}

pub fn medicationknowledge_cost_new(cost, type_) -> MedicationknowledgeCost {
  MedicationknowledgeCost(
    cost:,
    source: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeMonitoringprogram {
  MedicationknowledgeMonitoringprogram(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    name: Option(String),
  )
}

pub fn medicationknowledge_monitoringprogram_new() -> MedicationknowledgeMonitoringprogram {
  MedicationknowledgeMonitoringprogram(
    name: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeAdministrationguidelines {
  MedicationknowledgeAdministrationguidelines(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    dosage: List(MedicationknowledgeAdministrationguidelinesDosage),
    indication: Option(MedicationknowledgeAdministrationguidelinesIndication),
    patient_characteristics: List(
      MedicationknowledgeAdministrationguidelinesPatientcharacteristics,
    ),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeAdministrationguidelinesIndication {
  MedicationknowledgeAdministrationguidelinesIndicationCodeableconcept(
    indication: Codeableconcept,
  )
  MedicationknowledgeAdministrationguidelinesIndicationReference(
    indication: Reference,
  )
}

pub fn medicationknowledge_administrationguidelines_new() -> MedicationknowledgeAdministrationguidelines {
  MedicationknowledgeAdministrationguidelines(
    patient_characteristics: [],
    indication: None,
    dosage: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeAdministrationguidelinesDosage {
  MedicationknowledgeAdministrationguidelinesDosage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    dosage: List(Dosage),
  )
}

pub fn medicationknowledge_administrationguidelines_dosage_new(
  type_,
) -> MedicationknowledgeAdministrationguidelinesDosage {
  MedicationknowledgeAdministrationguidelinesDosage(
    dosage: [],
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeAdministrationguidelinesPatientcharacteristics {
  MedicationknowledgeAdministrationguidelinesPatientcharacteristics(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    characteristic: MedicationknowledgeAdministrationguidelinesPatientcharacteristicsCharacteristic,
    value: List(String),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeAdministrationguidelinesPatientcharacteristicsCharacteristic {
  MedicationknowledgeAdministrationguidelinesPatientcharacteristicsCharacteristicCodeableconcept(
    characteristic: Codeableconcept,
  )
  MedicationknowledgeAdministrationguidelinesPatientcharacteristicsCharacteristicQuantity(
    characteristic: Quantity,
  )
}

pub fn medicationknowledge_administrationguidelines_patientcharacteristics_new(
  characteristic,
) -> MedicationknowledgeAdministrationguidelinesPatientcharacteristics {
  MedicationknowledgeAdministrationguidelinesPatientcharacteristics(
    value: [],
    characteristic:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeMedicineclassification {
  MedicationknowledgeMedicineclassification(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    classification: List(Codeableconcept),
  )
}

pub fn medicationknowledge_medicineclassification_new(
  type_,
) -> MedicationknowledgeMedicineclassification {
  MedicationknowledgeMedicineclassification(
    classification: [],
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgePackaging {
  MedicationknowledgePackaging(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    quantity: Option(Quantity),
  )
}

pub fn medicationknowledge_packaging_new() -> MedicationknowledgePackaging {
  MedicationknowledgePackaging(
    quantity: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeDrugcharacteristic {
  MedicationknowledgeDrugcharacteristic(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    value: Option(MedicationknowledgeDrugcharacteristicValue),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeDrugcharacteristicValue {
  MedicationknowledgeDrugcharacteristicValueCodeableconcept(
    value: Codeableconcept,
  )
  MedicationknowledgeDrugcharacteristicValueString(value: String)
  MedicationknowledgeDrugcharacteristicValueQuantity(value: Quantity)
  MedicationknowledgeDrugcharacteristicValueBase64binary(value: String)
}

pub fn medicationknowledge_drugcharacteristic_new() -> MedicationknowledgeDrugcharacteristic {
  MedicationknowledgeDrugcharacteristic(
    value: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeRegulatory {
  MedicationknowledgeRegulatory(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    regulatory_authority: Reference,
    substitution: List(MedicationknowledgeRegulatorySubstitution),
    schedule: List(MedicationknowledgeRegulatorySchedule),
    max_dispense: Option(MedicationknowledgeRegulatoryMaxdispense),
  )
}

pub fn medicationknowledge_regulatory_new(
  regulatory_authority,
) -> MedicationknowledgeRegulatory {
  MedicationknowledgeRegulatory(
    max_dispense: None,
    schedule: [],
    substitution: [],
    regulatory_authority:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeRegulatorySubstitution {
  MedicationknowledgeRegulatorySubstitution(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    allowed: Bool,
  )
}

pub fn medicationknowledge_regulatory_substitution_new(
  allowed,
  type_,
) -> MedicationknowledgeRegulatorySubstitution {
  MedicationknowledgeRegulatorySubstitution(
    allowed:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeRegulatorySchedule {
  MedicationknowledgeRegulatorySchedule(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    schedule: Codeableconcept,
  )
}

pub fn medicationknowledge_regulatory_schedule_new(
  schedule,
) -> MedicationknowledgeRegulatorySchedule {
  MedicationknowledgeRegulatorySchedule(
    schedule:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeRegulatoryMaxdispense {
  MedicationknowledgeRegulatoryMaxdispense(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    quantity: Quantity,
    period: Option(Duration),
  )
}

pub fn medicationknowledge_regulatory_maxdispense_new(
  quantity,
) -> MedicationknowledgeRegulatoryMaxdispense {
  MedicationknowledgeRegulatoryMaxdispense(
    period: None,
    quantity:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeKinetics {
  MedicationknowledgeKinetics(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    area_under_curve: List(Quantity),
    lethal_dose50: List(Quantity),
    half_life_period: Option(Duration),
  )
}

pub fn medicationknowledge_kinetics_new() -> MedicationknowledgeKinetics {
  MedicationknowledgeKinetics(
    half_life_period: None,
    lethal_dose50: [],
    area_under_curve: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationRequest#resource
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
    status: r4bvaluesets.Medicationrequeststatus,
    status_reason: Option(Codeableconcept),
    intent: r4bvaluesets.Medicationrequestintent,
    category: List(Codeableconcept),
    priority: Option(r4bvaluesets.Requestpriority),
    do_not_perform: Option(Bool),
    reported: Option(MedicationrequestReported),
    medication: MedicationrequestMedication,
    subject: Reference,
    encounter: Option(Reference),
    supporting_information: List(Reference),
    authored_on: Option(String),
    requester: Option(Reference),
    performer: Option(Reference),
    performer_type: Option(Codeableconcept),
    recorder: Option(Reference),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    instantiates_canonical: List(String),
    instantiates_uri: List(String),
    based_on: List(Reference),
    group_identifier: Option(Identifier),
    course_of_therapy_type: Option(Codeableconcept),
    insurance: List(Reference),
    note: List(Annotation),
    dosage_instruction: List(Dosage),
    dispense_request: Option(MedicationrequestDispenserequest),
    substitution: Option(MedicationrequestSubstitution),
    prior_prescription: Option(Reference),
    detected_issue: List(Reference),
    event_history: List(Reference),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationRequest#resource
pub type MedicationrequestReported {
  MedicationrequestReportedBoolean(reported: Bool)
  MedicationrequestReportedReference(reported: Reference)
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationRequest#resource
pub type MedicationrequestMedication {
  MedicationrequestMedicationCodeableconcept(medication: Codeableconcept)
  MedicationrequestMedicationReference(medication: Reference)
}

pub fn medicationrequest_new(
  subject,
  medication,
  intent,
  status,
) -> Medicationrequest {
  Medicationrequest(
    event_history: [],
    detected_issue: [],
    prior_prescription: None,
    substitution: None,
    dispense_request: None,
    dosage_instruction: [],
    note: [],
    insurance: [],
    course_of_therapy_type: None,
    group_identifier: None,
    based_on: [],
    instantiates_uri: [],
    instantiates_canonical: [],
    reason_reference: [],
    reason_code: [],
    recorder: None,
    performer_type: None,
    performer: None,
    requester: None,
    authored_on: None,
    supporting_information: [],
    encounter: None,
    subject:,
    medication:,
    reported: None,
    do_not_perform: None,
    priority: None,
    category: [],
    intent:,
    status_reason: None,
    status:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationRequest#resource
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
    performer: Option(Reference),
  )
}

pub fn medicationrequest_dispenserequest_new() -> MedicationrequestDispenserequest {
  MedicationrequestDispenserequest(
    performer: None,
    expected_supply_duration: None,
    quantity: None,
    number_of_repeats_allowed: None,
    validity_period: None,
    dispense_interval: None,
    initial_fill: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationRequest#resource
pub type MedicationrequestDispenserequestInitialfill {
  MedicationrequestDispenserequestInitialfill(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    quantity: Option(Quantity),
    duration: Option(Duration),
  )
}

pub fn medicationrequest_dispenserequest_initialfill_new() -> MedicationrequestDispenserequestInitialfill {
  MedicationrequestDispenserequestInitialfill(
    duration: None,
    quantity: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationRequest#resource
pub type MedicationrequestSubstitution {
  MedicationrequestSubstitution(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    allowed: MedicationrequestSubstitutionAllowed,
    reason: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationRequest#resource
pub type MedicationrequestSubstitutionAllowed {
  MedicationrequestSubstitutionAllowedBoolean(allowed: Bool)
  MedicationrequestSubstitutionAllowedCodeableconcept(allowed: Codeableconcept)
}

pub fn medicationrequest_substitution_new(
  allowed,
) -> MedicationrequestSubstitution {
  MedicationrequestSubstitution(
    reason: None,
    allowed:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationStatement#resource
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
    based_on: List(Reference),
    part_of: List(Reference),
    status: r4bvaluesets.Medicationstatementstatus,
    status_reason: List(Codeableconcept),
    category: Option(Codeableconcept),
    medication: MedicationstatementMedication,
    subject: Reference,
    context: Option(Reference),
    effective: Option(MedicationstatementEffective),
    date_asserted: Option(String),
    information_source: Option(Reference),
    derived_from: List(Reference),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    note: List(Annotation),
    dosage: List(Dosage),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationStatement#resource
pub type MedicationstatementMedication {
  MedicationstatementMedicationCodeableconcept(medication: Codeableconcept)
  MedicationstatementMedicationReference(medication: Reference)
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicationStatement#resource
pub type MedicationstatementEffective {
  MedicationstatementEffectiveDatetime(effective: String)
  MedicationstatementEffectivePeriod(effective: Period)
}

pub fn medicationstatement_new(
  subject,
  medication,
  status,
) -> Medicationstatement {
  Medicationstatement(
    dosage: [],
    note: [],
    reason_reference: [],
    reason_code: [],
    derived_from: [],
    information_source: None,
    date_asserted: None,
    effective: None,
    context: None,
    subject:,
    medication:,
    category: None,
    status_reason: [],
    status:,
    part_of: [],
    based_on: [],
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicinalProductDefinition#resource
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

pub fn medicinalproductdefinition_new() -> Medicinalproductdefinition {
  Medicinalproductdefinition(
    characteristic: [],
    operation: [],
    cross_reference: [],
    name: [],
    code: [],
    clinical_trial: [],
    contact: [],
    master_file: [],
    attached_document: [],
    impurity: [],
    ingredient: [],
    packaged_medicinal_product: [],
    marketing_status: [],
    classification: [],
    pediatric_use_indicator: None,
    special_measures: [],
    additional_monitoring_indicator: None,
    legal_status_of_supply: None,
    indication: None,
    route: [],
    combined_pharmaceutical_dose_form: None,
    description: None,
    status_date: None,
    status: None,
    version: None,
    domain: None,
    type_: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicinalProductDefinition#resource
pub type MedicinalproductdefinitionContact {
  MedicinalproductdefinitionContact(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    contact: Reference,
  )
}

pub fn medicinalproductdefinition_contact_new(
  contact,
) -> MedicinalproductdefinitionContact {
  MedicinalproductdefinitionContact(
    contact:,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicinalProductDefinition#resource
pub type MedicinalproductdefinitionName {
  MedicinalproductdefinitionName(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    product_name: String,
    type_: Option(Codeableconcept),
    name_part: List(MedicinalproductdefinitionNameNamepart),
    country_language: List(MedicinalproductdefinitionNameCountrylanguage),
  )
}

pub fn medicinalproductdefinition_name_new(
  product_name,
) -> MedicinalproductdefinitionName {
  MedicinalproductdefinitionName(
    country_language: [],
    name_part: [],
    type_: None,
    product_name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicinalProductDefinition#resource
pub type MedicinalproductdefinitionNameNamepart {
  MedicinalproductdefinitionNameNamepart(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    part: String,
    type_: Codeableconcept,
  )
}

pub fn medicinalproductdefinition_name_namepart_new(
  type_,
  part,
) -> MedicinalproductdefinitionNameNamepart {
  MedicinalproductdefinitionNameNamepart(
    type_:,
    part:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicinalProductDefinition#resource
pub type MedicinalproductdefinitionNameCountrylanguage {
  MedicinalproductdefinitionNameCountrylanguage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    country: Codeableconcept,
    jurisdiction: Option(Codeableconcept),
    language: Codeableconcept,
  )
}

pub fn medicinalproductdefinition_name_countrylanguage_new(
  language,
  country,
) -> MedicinalproductdefinitionNameCountrylanguage {
  MedicinalproductdefinitionNameCountrylanguage(
    language:,
    jurisdiction: None,
    country:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicinalProductDefinition#resource
pub type MedicinalproductdefinitionCrossreference {
  MedicinalproductdefinitionCrossreference(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    product: Codeablereference,
    type_: Option(Codeableconcept),
  )
}

pub fn medicinalproductdefinition_crossreference_new(
  product,
) -> MedicinalproductdefinitionCrossreference {
  MedicinalproductdefinitionCrossreference(
    type_: None,
    product:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicinalProductDefinition#resource
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

pub fn medicinalproductdefinition_operation_new() -> MedicinalproductdefinitionOperation {
  MedicinalproductdefinitionOperation(
    confidentiality_indicator: None,
    organization: [],
    effective_date: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicinalProductDefinition#resource
pub type MedicinalproductdefinitionCharacteristic {
  MedicinalproductdefinitionCharacteristic(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value: Option(MedicinalproductdefinitionCharacteristicValue),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MedicinalProductDefinition#resource
pub type MedicinalproductdefinitionCharacteristicValue {
  MedicinalproductdefinitionCharacteristicValueCodeableconcept(
    value: Codeableconcept,
  )
  MedicinalproductdefinitionCharacteristicValueQuantity(value: Quantity)
  MedicinalproductdefinitionCharacteristicValueDate(value: String)
  MedicinalproductdefinitionCharacteristicValueBoolean(value: Bool)
  MedicinalproductdefinitionCharacteristicValueAttachment(value: Attachment)
}

pub fn medicinalproductdefinition_characteristic_new(
  type_,
) -> MedicinalproductdefinitionCharacteristic {
  MedicinalproductdefinitionCharacteristic(
    value: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MessageDefinition#resource
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
    name: Option(String),
    title: Option(String),
    replaces: List(String),
    status: r4bvaluesets.Publicationstatus,
    experimental: Option(Bool),
    date: String,
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    base: Option(String),
    parent: List(String),
    event: MessagedefinitionEvent,
    category: Option(r4bvaluesets.Messagesignificancecategory),
    focus: List(MessagedefinitionFocus),
    response_required: Option(r4bvaluesets.Messageheaderresponserequest),
    allowed_response: List(MessagedefinitionAllowedresponse),
    graph: List(String),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MessageDefinition#resource
pub type MessagedefinitionEvent {
  MessagedefinitionEventCoding(event: Coding)
  MessagedefinitionEventUri(event: String)
}

pub fn messagedefinition_new(event, date, status) -> Messagedefinition {
  Messagedefinition(
    graph: [],
    allowed_response: [],
    response_required: None,
    focus: [],
    category: None,
    event:,
    parent: [],
    base: None,
    copyright: None,
    purpose: None,
    jurisdiction: [],
    use_context: [],
    description: None,
    contact: [],
    publisher: None,
    date:,
    experimental: None,
    status:,
    replaces: [],
    title: None,
    name: None,
    version: None,
    identifier: [],
    url: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MessageDefinition#resource
pub type MessagedefinitionFocus {
  MessagedefinitionFocus(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: r4bvaluesets.Resourcetypes,
    profile: Option(String),
    min: Int,
    max: Option(String),
  )
}

pub fn messagedefinition_focus_new(min, code) -> MessagedefinitionFocus {
  MessagedefinitionFocus(
    max: None,
    min:,
    profile: None,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MessageDefinition#resource
pub type MessagedefinitionAllowedresponse {
  MessagedefinitionAllowedresponse(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    message: String,
    situation: Option(String),
  )
}

pub fn messagedefinition_allowedresponse_new(
  message,
) -> MessagedefinitionAllowedresponse {
  MessagedefinitionAllowedresponse(
    situation: None,
    message:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MessageHeader#resource
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
    enterer: Option(Reference),
    author: Option(Reference),
    source: MessageheaderSource,
    responsible: Option(Reference),
    reason: Option(Codeableconcept),
    response: Option(MessageheaderResponse),
    focus: List(Reference),
    definition: Option(String),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MessageHeader#resource
pub type MessageheaderEvent {
  MessageheaderEventCoding(event: Coding)
  MessageheaderEventUri(event: String)
}

pub fn messageheader_new(source, event) -> Messageheader {
  Messageheader(
    definition: None,
    focus: [],
    response: None,
    reason: None,
    responsible: None,
    source:,
    author: None,
    enterer: None,
    sender: None,
    destination: [],
    event:,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MessageHeader#resource
pub type MessageheaderDestination {
  MessageheaderDestination(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: Option(String),
    target: Option(Reference),
    endpoint: String,
    receiver: Option(Reference),
  )
}

pub fn messageheader_destination_new(endpoint) -> MessageheaderDestination {
  MessageheaderDestination(
    receiver: None,
    endpoint:,
    target: None,
    name: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MessageHeader#resource
pub type MessageheaderSource {
  MessageheaderSource(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: Option(String),
    software: Option(String),
    version: Option(String),
    contact: Option(Contactpoint),
    endpoint: String,
  )
}

pub fn messageheader_source_new(endpoint) -> MessageheaderSource {
  MessageheaderSource(
    endpoint:,
    contact: None,
    version: None,
    software: None,
    name: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MessageHeader#resource
pub type MessageheaderResponse {
  MessageheaderResponse(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: String,
    code: r4bvaluesets.Responsecode,
    details: Option(Reference),
  )
}

pub fn messageheader_response_new(code, identifier) -> MessageheaderResponse {
  MessageheaderResponse(
    details: None,
    code:,
    identifier:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MolecularSequence#resource
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
    type_: Option(r4bvaluesets.Sequencetype),
    coordinate_system: Int,
    patient: Option(Reference),
    specimen: Option(Reference),
    device: Option(Reference),
    performer: Option(Reference),
    quantity: Option(Quantity),
    reference_seq: Option(MolecularsequenceReferenceseq),
    variant: List(MolecularsequenceVariant),
    observed_seq: Option(String),
    quality: List(MolecularsequenceQuality),
    read_coverage: Option(Int),
    repository: List(MolecularsequenceRepository),
    pointer: List(Reference),
    structure_variant: List(MolecularsequenceStructurevariant),
  )
}

pub fn molecularsequence_new(coordinate_system) -> Molecularsequence {
  Molecularsequence(
    structure_variant: [],
    pointer: [],
    repository: [],
    read_coverage: None,
    quality: [],
    observed_seq: None,
    variant: [],
    reference_seq: None,
    quantity: None,
    performer: None,
    device: None,
    specimen: None,
    patient: None,
    coordinate_system:,
    type_: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MolecularSequence#resource
pub type MolecularsequenceReferenceseq {
  MolecularsequenceReferenceseq(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    chromosome: Option(Codeableconcept),
    genome_build: Option(String),
    orientation: Option(r4bvaluesets.Orientationtype),
    reference_seq_id: Option(Codeableconcept),
    reference_seq_pointer: Option(Reference),
    reference_seq_string: Option(String),
    strand: Option(r4bvaluesets.Strandtype),
    window_start: Option(Int),
    window_end: Option(Int),
  )
}

pub fn molecularsequence_referenceseq_new() -> MolecularsequenceReferenceseq {
  MolecularsequenceReferenceseq(
    window_end: None,
    window_start: None,
    strand: None,
    reference_seq_string: None,
    reference_seq_pointer: None,
    reference_seq_id: None,
    orientation: None,
    genome_build: None,
    chromosome: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MolecularSequence#resource
pub type MolecularsequenceVariant {
  MolecularsequenceVariant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    start: Option(Int),
    end: Option(Int),
    observed_allele: Option(String),
    reference_allele: Option(String),
    cigar: Option(String),
    variant_pointer: Option(Reference),
  )
}

pub fn molecularsequence_variant_new() -> MolecularsequenceVariant {
  MolecularsequenceVariant(
    variant_pointer: None,
    cigar: None,
    reference_allele: None,
    observed_allele: None,
    end: None,
    start: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MolecularSequence#resource
pub type MolecularsequenceQuality {
  MolecularsequenceQuality(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r4bvaluesets.Qualitytype,
    standard_sequence: Option(Codeableconcept),
    start: Option(Int),
    end: Option(Int),
    score: Option(Quantity),
    method: Option(Codeableconcept),
    truth_tp: Option(Float),
    query_tp: Option(Float),
    truth_fn: Option(Float),
    query_fp: Option(Float),
    gt_fp: Option(Float),
    precision: Option(Float),
    recall: Option(Float),
    f_score: Option(Float),
    roc: Option(MolecularsequenceQualityRoc),
  )
}

pub fn molecularsequence_quality_new(type_) -> MolecularsequenceQuality {
  MolecularsequenceQuality(
    roc: None,
    f_score: None,
    recall: None,
    precision: None,
    gt_fp: None,
    query_fp: None,
    truth_fn: None,
    query_tp: None,
    truth_tp: None,
    method: None,
    score: None,
    end: None,
    start: None,
    standard_sequence: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MolecularSequence#resource
pub type MolecularsequenceQualityRoc {
  MolecularsequenceQualityRoc(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    score: List(Int),
    num_tp: List(Int),
    num_fp: List(Int),
    num_fn: List(Int),
    precision: List(Float),
    sensitivity: List(Float),
    f_measure: List(Float),
  )
}

pub fn molecularsequence_quality_roc_new() -> MolecularsequenceQualityRoc {
  MolecularsequenceQualityRoc(
    f_measure: [],
    sensitivity: [],
    precision: [],
    num_fn: [],
    num_fp: [],
    num_tp: [],
    score: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MolecularSequence#resource
pub type MolecularsequenceRepository {
  MolecularsequenceRepository(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r4bvaluesets.Repositorytype,
    url: Option(String),
    name: Option(String),
    dataset_id: Option(String),
    variantset_id: Option(String),
    readset_id: Option(String),
  )
}

pub fn molecularsequence_repository_new(type_) -> MolecularsequenceRepository {
  MolecularsequenceRepository(
    readset_id: None,
    variantset_id: None,
    dataset_id: None,
    name: None,
    url: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MolecularSequence#resource
pub type MolecularsequenceStructurevariant {
  MolecularsequenceStructurevariant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    variant_type: Option(Codeableconcept),
    exact: Option(Bool),
    length: Option(Int),
    outer: Option(MolecularsequenceStructurevariantOuter),
    inner: Option(MolecularsequenceStructurevariantInner),
  )
}

pub fn molecularsequence_structurevariant_new() -> MolecularsequenceStructurevariant {
  MolecularsequenceStructurevariant(
    inner: None,
    outer: None,
    length: None,
    exact: None,
    variant_type: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MolecularSequence#resource
pub type MolecularsequenceStructurevariantOuter {
  MolecularsequenceStructurevariantOuter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    start: Option(Int),
    end: Option(Int),
  )
}

pub fn molecularsequence_structurevariant_outer_new() -> MolecularsequenceStructurevariantOuter {
  MolecularsequenceStructurevariantOuter(
    end: None,
    start: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/MolecularSequence#resource
pub type MolecularsequenceStructurevariantInner {
  MolecularsequenceStructurevariantInner(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    start: Option(Int),
    end: Option(Int),
  )
}

pub fn molecularsequence_structurevariant_inner_new() -> MolecularsequenceStructurevariantInner {
  MolecularsequenceStructurevariantInner(
    end: None,
    start: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/NamingSystem#resource
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
    name: String,
    status: r4bvaluesets.Publicationstatus,
    kind: r4bvaluesets.Namingsystemtype,
    date: String,
    publisher: Option(String),
    contact: List(Contactdetail),
    responsible: Option(String),
    type_: Option(Codeableconcept),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    usage: Option(String),
    unique_id: List(NamingsystemUniqueid),
  )
}

pub fn namingsystem_new(date, kind, status, name) -> Namingsystem {
  Namingsystem(
    unique_id: [],
    usage: None,
    jurisdiction: [],
    use_context: [],
    description: None,
    type_: None,
    responsible: None,
    contact: [],
    publisher: None,
    date:,
    kind:,
    status:,
    name:,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/NamingSystem#resource
pub type NamingsystemUniqueid {
  NamingsystemUniqueid(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r4bvaluesets.Namingsystemidentifiertype,
    value: String,
    preferred: Option(Bool),
    comment: Option(String),
    period: Option(Period),
  )
}

pub fn namingsystem_uniqueid_new(value, type_) -> NamingsystemUniqueid {
  NamingsystemUniqueid(
    period: None,
    comment: None,
    preferred: None,
    value:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/NutritionOrder#resource
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
    status: r4bvaluesets.Requeststatus,
    intent: r4bvaluesets.Requestintent,
    patient: Reference,
    encounter: Option(Reference),
    date_time: String,
    orderer: Option(Reference),
    allergy_intolerance: List(Reference),
    food_preference_modifier: List(Codeableconcept),
    exclude_food_modifier: List(Codeableconcept),
    oral_diet: Option(NutritionorderOraldiet),
    supplement: List(NutritionorderSupplement),
    enteral_formula: Option(NutritionorderEnteralformula),
    note: List(Annotation),
  )
}

pub fn nutritionorder_new(date_time, patient, intent, status) -> Nutritionorder {
  Nutritionorder(
    note: [],
    enteral_formula: None,
    supplement: [],
    oral_diet: None,
    exclude_food_modifier: [],
    food_preference_modifier: [],
    allergy_intolerance: [],
    orderer: None,
    date_time:,
    encounter: None,
    patient:,
    intent:,
    status:,
    instantiates: [],
    instantiates_uri: [],
    instantiates_canonical: [],
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/NutritionOrder#resource
pub type NutritionorderOraldiet {
  NutritionorderOraldiet(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: List(Codeableconcept),
    schedule: List(Timing),
    nutrient: List(NutritionorderOraldietNutrient),
    texture: List(NutritionorderOraldietTexture),
    fluid_consistency_type: List(Codeableconcept),
    instruction: Option(String),
  )
}

pub fn nutritionorder_oraldiet_new() -> NutritionorderOraldiet {
  NutritionorderOraldiet(
    instruction: None,
    fluid_consistency_type: [],
    texture: [],
    nutrient: [],
    schedule: [],
    type_: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/NutritionOrder#resource
pub type NutritionorderOraldietNutrient {
  NutritionorderOraldietNutrient(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    modifier: Option(Codeableconcept),
    amount: Option(Quantity),
  )
}

pub fn nutritionorder_oraldiet_nutrient_new() -> NutritionorderOraldietNutrient {
  NutritionorderOraldietNutrient(
    amount: None,
    modifier: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/NutritionOrder#resource
pub type NutritionorderOraldietTexture {
  NutritionorderOraldietTexture(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    modifier: Option(Codeableconcept),
    food_type: Option(Codeableconcept),
  )
}

pub fn nutritionorder_oraldiet_texture_new() -> NutritionorderOraldietTexture {
  NutritionorderOraldietTexture(
    food_type: None,
    modifier: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/NutritionOrder#resource
pub type NutritionorderSupplement {
  NutritionorderSupplement(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    product_name: Option(String),
    schedule: List(Timing),
    quantity: Option(Quantity),
    instruction: Option(String),
  )
}

pub fn nutritionorder_supplement_new() -> NutritionorderSupplement {
  NutritionorderSupplement(
    instruction: None,
    quantity: None,
    schedule: [],
    product_name: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/NutritionOrder#resource
pub type NutritionorderEnteralformula {
  NutritionorderEnteralformula(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    base_formula_type: Option(Codeableconcept),
    base_formula_product_name: Option(String),
    additive_type: Option(Codeableconcept),
    additive_product_name: Option(String),
    caloric_density: Option(Quantity),
    routeof_administration: Option(Codeableconcept),
    administration: List(NutritionorderEnteralformulaAdministration),
    max_volume_to_deliver: Option(Quantity),
    administration_instruction: Option(String),
  )
}

pub fn nutritionorder_enteralformula_new() -> NutritionorderEnteralformula {
  NutritionorderEnteralformula(
    administration_instruction: None,
    max_volume_to_deliver: None,
    administration: [],
    routeof_administration: None,
    caloric_density: None,
    additive_product_name: None,
    additive_type: None,
    base_formula_product_name: None,
    base_formula_type: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/NutritionOrder#resource
pub type NutritionorderEnteralformulaAdministration {
  NutritionorderEnteralformulaAdministration(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    schedule: Option(Timing),
    quantity: Option(Quantity),
    rate: Option(NutritionorderEnteralformulaAdministrationRate),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/NutritionOrder#resource
pub type NutritionorderEnteralformulaAdministrationRate {
  NutritionorderEnteralformulaAdministrationRateQuantity(rate: Quantity)
  NutritionorderEnteralformulaAdministrationRateRatio(rate: Ratio)
}

pub fn nutritionorder_enteralformula_administration_new() -> NutritionorderEnteralformulaAdministration {
  NutritionorderEnteralformulaAdministration(
    rate: None,
    quantity: None,
    schedule: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/NutritionProduct#resource
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
    status: r4bvaluesets.Nutritionproductstatus,
    category: List(Codeableconcept),
    code: Option(Codeableconcept),
    manufacturer: List(Reference),
    nutrient: List(NutritionproductNutrient),
    ingredient: List(NutritionproductIngredient),
    known_allergen: List(Codeablereference),
    product_characteristic: List(NutritionproductProductcharacteristic),
    instance: Option(NutritionproductInstance),
    note: List(Annotation),
  )
}

pub fn nutritionproduct_new(status) -> Nutritionproduct {
  Nutritionproduct(
    note: [],
    instance: None,
    product_characteristic: [],
    known_allergen: [],
    ingredient: [],
    nutrient: [],
    manufacturer: [],
    code: None,
    category: [],
    status:,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/NutritionProduct#resource
pub type NutritionproductNutrient {
  NutritionproductNutrient(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item: Option(Codeablereference),
    amount: List(Ratio),
  )
}

pub fn nutritionproduct_nutrient_new() -> NutritionproductNutrient {
  NutritionproductNutrient(
    amount: [],
    item: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/NutritionProduct#resource
pub type NutritionproductIngredient {
  NutritionproductIngredient(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item: Codeablereference,
    amount: List(Ratio),
  )
}

pub fn nutritionproduct_ingredient_new(item) -> NutritionproductIngredient {
  NutritionproductIngredient(
    amount: [],
    item:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/NutritionProduct#resource
pub type NutritionproductProductcharacteristic {
  NutritionproductProductcharacteristic(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value: NutritionproductProductcharacteristicValue,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/NutritionProduct#resource
pub type NutritionproductProductcharacteristicValue {
  NutritionproductProductcharacteristicValueCodeableconcept(
    value: Codeableconcept,
  )
  NutritionproductProductcharacteristicValueString(value: String)
  NutritionproductProductcharacteristicValueQuantity(value: Quantity)
  NutritionproductProductcharacteristicValueBase64binary(value: String)
  NutritionproductProductcharacteristicValueAttachment(value: Attachment)
  NutritionproductProductcharacteristicValueBoolean(value: Bool)
}

pub fn nutritionproduct_productcharacteristic_new(
  value,
  type_,
) -> NutritionproductProductcharacteristic {
  NutritionproductProductcharacteristic(
    value:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/NutritionProduct#resource
pub type NutritionproductInstance {
  NutritionproductInstance(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    quantity: Option(Quantity),
    identifier: List(Identifier),
    lot_number: Option(String),
    expiry: Option(String),
    use_by: Option(String),
  )
}

pub fn nutritionproduct_instance_new() -> NutritionproductInstance {
  NutritionproductInstance(
    use_by: None,
    expiry: None,
    lot_number: None,
    identifier: [],
    quantity: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Observation#resource
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
    based_on: List(Reference),
    part_of: List(Reference),
    status: r4bvaluesets.Observationstatus,
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
    method: Option(Codeableconcept),
    specimen: Option(Reference),
    device: Option(Reference),
    reference_range: List(ObservationReferencerange),
    has_member: List(Reference),
    derived_from: List(Reference),
    component: List(ObservationComponent),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Observation#resource
pub type ObservationEffective {
  ObservationEffectiveDatetime(effective: String)
  ObservationEffectivePeriod(effective: Period)
  ObservationEffectiveTiming(effective: Timing)
  ObservationEffectiveInstant(effective: String)
}

///http://hl7.org/fhir/r4b/StructureDefinition/Observation#resource
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
}

pub fn observation_new(code, status) -> Observation {
  Observation(
    component: [],
    derived_from: [],
    has_member: [],
    reference_range: [],
    device: None,
    specimen: None,
    method: None,
    body_site: None,
    note: [],
    interpretation: [],
    data_absent_reason: None,
    value: None,
    performer: [],
    issued: None,
    effective: None,
    encounter: None,
    focus: [],
    subject: None,
    code:,
    category: [],
    status:,
    part_of: [],
    based_on: [],
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Observation#resource
pub type ObservationReferencerange {
  ObservationReferencerange(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    low: Option(Quantity),
    high: Option(Quantity),
    type_: Option(Codeableconcept),
    applies_to: List(Codeableconcept),
    age: Option(Range),
    text: Option(String),
  )
}

pub fn observation_referencerange_new() -> ObservationReferencerange {
  ObservationReferencerange(
    text: None,
    age: None,
    applies_to: [],
    type_: None,
    high: None,
    low: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Observation#resource
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

///http://hl7.org/fhir/r4b/StructureDefinition/Observation#resource
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
}

pub fn observation_component_new(code) -> ObservationComponent {
  ObservationComponent(
    reference_range: [],
    interpretation: [],
    data_absent_reason: None,
    value: None,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ObservationDefinition#resource
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
    category: List(Codeableconcept),
    code: Codeableconcept,
    identifier: List(Identifier),
    permitted_data_type: List(r4bvaluesets.Permitteddatatype),
    multiple_results_allowed: Option(Bool),
    method: Option(Codeableconcept),
    preferred_report_name: Option(String),
    quantitative_details: Option(ObservationdefinitionQuantitativedetails),
    qualified_interval: List(ObservationdefinitionQualifiedinterval),
    valid_coded_value_set: Option(Reference),
    normal_coded_value_set: Option(Reference),
    abnormal_coded_value_set: Option(Reference),
    critical_coded_value_set: Option(Reference),
  )
}

pub fn observationdefinition_new(code) -> Observationdefinition {
  Observationdefinition(
    critical_coded_value_set: None,
    abnormal_coded_value_set: None,
    normal_coded_value_set: None,
    valid_coded_value_set: None,
    qualified_interval: [],
    quantitative_details: None,
    preferred_report_name: None,
    method: None,
    multiple_results_allowed: None,
    permitted_data_type: [],
    identifier: [],
    code:,
    category: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ObservationDefinition#resource
pub type ObservationdefinitionQuantitativedetails {
  ObservationdefinitionQuantitativedetails(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    customary_unit: Option(Codeableconcept),
    unit: Option(Codeableconcept),
    conversion_factor: Option(Float),
    decimal_precision: Option(Int),
  )
}

pub fn observationdefinition_quantitativedetails_new() -> ObservationdefinitionQuantitativedetails {
  ObservationdefinitionQuantitativedetails(
    decimal_precision: None,
    conversion_factor: None,
    unit: None,
    customary_unit: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ObservationDefinition#resource
pub type ObservationdefinitionQualifiedinterval {
  ObservationdefinitionQualifiedinterval(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    category: Option(r4bvaluesets.Observationrangecategory),
    range: Option(Range),
    context: Option(Codeableconcept),
    applies_to: List(Codeableconcept),
    gender: Option(r4bvaluesets.Administrativegender),
    age: Option(Range),
    gestational_age: Option(Range),
    condition: Option(String),
  )
}

pub fn observationdefinition_qualifiedinterval_new() -> ObservationdefinitionQualifiedinterval {
  ObservationdefinitionQualifiedinterval(
    condition: None,
    gestational_age: None,
    age: None,
    gender: None,
    applies_to: [],
    context: None,
    range: None,
    category: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/OperationDefinition#resource
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
    version: Option(String),
    name: String,
    title: Option(String),
    status: r4bvaluesets.Publicationstatus,
    kind: r4bvaluesets.Operationkind,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    affects_state: Option(Bool),
    code: String,
    comment: Option(String),
    base: Option(String),
    resource: List(r4bvaluesets.Resourcetypes),
    system: Bool,
    type_: Bool,
    instance: Bool,
    input_profile: Option(String),
    output_profile: Option(String),
    parameter: List(OperationdefinitionParameter),
    overload: List(OperationdefinitionOverload),
  )
}

pub fn operationdefinition_new(
  instance,
  type_,
  system,
  code,
  kind,
  status,
  name,
) -> Operationdefinition {
  Operationdefinition(
    overload: [],
    parameter: [],
    output_profile: None,
    input_profile: None,
    instance:,
    type_:,
    system:,
    resource: [],
    base: None,
    comment: None,
    code:,
    affects_state: None,
    purpose: None,
    jurisdiction: [],
    use_context: [],
    description: None,
    contact: [],
    publisher: None,
    date: None,
    experimental: None,
    kind:,
    status:,
    title: None,
    name:,
    version: None,
    url: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/OperationDefinition#resource
pub type OperationdefinitionParameter {
  OperationdefinitionParameter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    use_: r4bvaluesets.Operationparameteruse,
    min: Int,
    max: String,
    documentation: Option(String),
    type_: Option(r4bvaluesets.Alltypes),
    target_profile: List(String),
    search_type: Option(r4bvaluesets.Searchparamtype),
    binding: Option(OperationdefinitionParameterBinding),
    referenced_from: List(OperationdefinitionParameterReferencedfrom),
    part: List(Nil),
  )
}

pub fn operationdefinition_parameter_new(
  max,
  min,
  use_,
  name,
) -> OperationdefinitionParameter {
  OperationdefinitionParameter(
    part: [],
    referenced_from: [],
    binding: None,
    search_type: None,
    target_profile: [],
    type_: None,
    documentation: None,
    max:,
    min:,
    use_:,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/OperationDefinition#resource
pub type OperationdefinitionParameterBinding {
  OperationdefinitionParameterBinding(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    strength: r4bvaluesets.Bindingstrength,
    value_set: String,
  )
}

pub fn operationdefinition_parameter_binding_new(
  value_set,
  strength,
) -> OperationdefinitionParameterBinding {
  OperationdefinitionParameterBinding(
    value_set:,
    strength:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/OperationDefinition#resource
pub type OperationdefinitionParameterReferencedfrom {
  OperationdefinitionParameterReferencedfrom(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    source: String,
    source_id: Option(String),
  )
}

pub fn operationdefinition_parameter_referencedfrom_new(
  source,
) -> OperationdefinitionParameterReferencedfrom {
  OperationdefinitionParameterReferencedfrom(
    source_id: None,
    source:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/OperationDefinition#resource
pub type OperationdefinitionOverload {
  OperationdefinitionOverload(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    parameter_name: List(String),
    comment: Option(String),
  )
}

pub fn operationdefinition_overload_new() -> OperationdefinitionOverload {
  OperationdefinitionOverload(
    comment: None,
    parameter_name: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/OperationOutcome#resource
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

pub fn operationoutcome_new() -> Operationoutcome {
  Operationoutcome(
    issue: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/OperationOutcome#resource
pub type OperationoutcomeIssue {
  OperationoutcomeIssue(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    severity: r4bvaluesets.Issueseverity,
    code: r4bvaluesets.Issuetype,
    details: Option(Codeableconcept),
    diagnostics: Option(String),
    location: List(String),
    expression: List(String),
  )
}

pub fn operationoutcome_issue_new(code, severity) -> OperationoutcomeIssue {
  OperationoutcomeIssue(
    expression: [],
    location: [],
    diagnostics: None,
    details: None,
    code:,
    severity:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Organization#resource
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
    telecom: List(Contactpoint),
    address: List(Address),
    part_of: Option(Reference),
    contact: List(OrganizationContact),
    endpoint: List(Reference),
  )
}

pub fn organization_new() -> Organization {
  Organization(
    endpoint: [],
    contact: [],
    part_of: None,
    address: [],
    telecom: [],
    alias: [],
    name: None,
    type_: [],
    active: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Organization#resource
pub type OrganizationContact {
  OrganizationContact(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    purpose: Option(Codeableconcept),
    name: Option(Humanname),
    telecom: List(Contactpoint),
    address: Option(Address),
  )
}

pub fn organization_contact_new() -> OrganizationContact {
  OrganizationContact(
    address: None,
    telecom: [],
    name: None,
    purpose: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/OrganizationAffiliation#resource
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
    telecom: List(Contactpoint),
    endpoint: List(Reference),
  )
}

pub fn organizationaffiliation_new() -> Organizationaffiliation {
  Organizationaffiliation(
    endpoint: [],
    telecom: [],
    healthcare_service: [],
    location: [],
    specialty: [],
    code: [],
    network: [],
    participating_organization: None,
    organization: None,
    period: None,
    active: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/PackagedProductDefinition#resource
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
    characteristic: List(Codeableconcept),
    copackaged_indicator: Option(Bool),
    manufacturer: List(Reference),
    package: Option(PackagedproductdefinitionPackage),
  )
}

pub fn packagedproductdefinition_new() -> Packagedproductdefinition {
  Packagedproductdefinition(
    package: None,
    manufacturer: [],
    copackaged_indicator: None,
    characteristic: [],
    marketing_status: [],
    legal_status_of_supply: [],
    description: None,
    contained_item_quantity: [],
    status_date: None,
    status: None,
    package_for: [],
    type_: None,
    name: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/PackagedProductDefinition#resource
pub type PackagedproductdefinitionLegalstatusofsupply {
  PackagedproductdefinitionLegalstatusofsupply(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(Codeableconcept),
    jurisdiction: Option(Codeableconcept),
  )
}

pub fn packagedproductdefinition_legalstatusofsupply_new() -> PackagedproductdefinitionLegalstatusofsupply {
  PackagedproductdefinitionLegalstatusofsupply(
    jurisdiction: None,
    code: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/PackagedProductDefinition#resource
pub type PackagedproductdefinitionPackage {
  PackagedproductdefinitionPackage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    type_: Option(Codeableconcept),
    quantity: Option(Int),
    material: List(Codeableconcept),
    alternate_material: List(Codeableconcept),
    shelf_life_storage: List(PackagedproductdefinitionPackageShelflifestorage),
    manufacturer: List(Reference),
    property: List(PackagedproductdefinitionPackageProperty),
    contained_item: List(PackagedproductdefinitionPackageContaineditem),
    package: List(Nil),
  )
}

pub fn packagedproductdefinition_package_new() -> PackagedproductdefinitionPackage {
  PackagedproductdefinitionPackage(
    package: [],
    contained_item: [],
    property: [],
    manufacturer: [],
    shelf_life_storage: [],
    alternate_material: [],
    material: [],
    quantity: None,
    type_: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/PackagedProductDefinition#resource
pub type PackagedproductdefinitionPackageShelflifestorage {
  PackagedproductdefinitionPackageShelflifestorage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    period: Option(PackagedproductdefinitionPackageShelflifestoragePeriod),
    special_precautions_for_storage: List(Codeableconcept),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/PackagedProductDefinition#resource
pub type PackagedproductdefinitionPackageShelflifestoragePeriod {
  PackagedproductdefinitionPackageShelflifestoragePeriodDuration(
    period: Duration,
  )
  PackagedproductdefinitionPackageShelflifestoragePeriodString(period: String)
}

pub fn packagedproductdefinition_package_shelflifestorage_new() -> PackagedproductdefinitionPackageShelflifestorage {
  PackagedproductdefinitionPackageShelflifestorage(
    special_precautions_for_storage: [],
    period: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/PackagedProductDefinition#resource
pub type PackagedproductdefinitionPackageProperty {
  PackagedproductdefinitionPackageProperty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value: Option(PackagedproductdefinitionPackagePropertyValue),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/PackagedProductDefinition#resource
pub type PackagedproductdefinitionPackagePropertyValue {
  PackagedproductdefinitionPackagePropertyValueCodeableconcept(
    value: Codeableconcept,
  )
  PackagedproductdefinitionPackagePropertyValueQuantity(value: Quantity)
  PackagedproductdefinitionPackagePropertyValueDate(value: String)
  PackagedproductdefinitionPackagePropertyValueBoolean(value: Bool)
  PackagedproductdefinitionPackagePropertyValueAttachment(value: Attachment)
}

pub fn packagedproductdefinition_package_property_new(
  type_,
) -> PackagedproductdefinitionPackageProperty {
  PackagedproductdefinitionPackageProperty(
    value: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/PackagedProductDefinition#resource
pub type PackagedproductdefinitionPackageContaineditem {
  PackagedproductdefinitionPackageContaineditem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item: Codeablereference,
    amount: Option(Quantity),
  )
}

pub fn packagedproductdefinition_package_containeditem_new(
  item,
) -> PackagedproductdefinitionPackageContaineditem {
  PackagedproductdefinitionPackageContaineditem(
    amount: None,
    item:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Parameters#resource
pub type Parameters {
  Parameters(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    parameter: List(ParametersParameter),
  )
}

pub fn parameters_new() -> Parameters {
  Parameters(
    parameter: [],
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Parameters#resource
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

///http://hl7.org/fhir/r4b/StructureDefinition/Parameters#resource
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
  ParametersParameterValueReference(value: Reference)
  ParametersParameterValueSampleddata(value: Sampleddata)
  ParametersParameterValueSignature(value: Signature)
  ParametersParameterValueTiming(value: Timing)
  ParametersParameterValueContactdetail(value: Contactdetail)
  ParametersParameterValueContributor(value: Contributor)
  ParametersParameterValueDatarequirement(value: Datarequirement)
  ParametersParameterValueExpression(value: Expression)
  ParametersParameterValueParameterdefinition(value: Parameterdefinition)
  ParametersParameterValueRelatedartifact(value: Relatedartifact)
  ParametersParameterValueTriggerdefinition(value: Triggerdefinition)
  ParametersParameterValueUsagecontext(value: Usagecontext)
  ParametersParameterValueDosage(value: Dosage)
  ParametersParameterValueMeta(value: Meta)
}

pub fn parameters_parameter_new(name) -> ParametersParameter {
  ParametersParameter(
    part: [],
    resource: None,
    value: None,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Patient#resource
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
    gender: Option(r4bvaluesets.Administrativegender),
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

///http://hl7.org/fhir/r4b/StructureDefinition/Patient#resource
pub type PatientDeceased {
  PatientDeceasedBoolean(deceased: Bool)
  PatientDeceasedDatetime(deceased: String)
}

///http://hl7.org/fhir/r4b/StructureDefinition/Patient#resource
pub type PatientMultiplebirth {
  PatientMultiplebirthBoolean(multiple_birth: Bool)
  PatientMultiplebirthInteger(multiple_birth: Int)
}

pub fn patient_new() -> Patient {
  Patient(
    link: [],
    managing_organization: None,
    general_practitioner: [],
    communication: [],
    contact: [],
    photo: [],
    multiple_birth: None,
    marital_status: None,
    address: [],
    deceased: None,
    birth_date: None,
    gender: None,
    telecom: [],
    name: [],
    active: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Patient#resource
pub type PatientContact {
  PatientContact(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    relationship: List(Codeableconcept),
    name: Option(Humanname),
    telecom: List(Contactpoint),
    address: Option(Address),
    gender: Option(r4bvaluesets.Administrativegender),
    organization: Option(Reference),
    period: Option(Period),
  )
}

pub fn patient_contact_new() -> PatientContact {
  PatientContact(
    period: None,
    organization: None,
    gender: None,
    address: None,
    telecom: [],
    name: None,
    relationship: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Patient#resource
pub type PatientCommunication {
  PatientCommunication(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    language: Codeableconcept,
    preferred: Option(Bool),
  )
}

pub fn patient_communication_new(language) -> PatientCommunication {
  PatientCommunication(
    preferred: None,
    language:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Patient#resource
pub type PatientLink {
  PatientLink(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    other: Reference,
    type_: r4bvaluesets.Linktype,
  )
}

pub fn patient_link_new(type_, other) -> PatientLink {
  PatientLink(type_:, other:, modifier_extension: [], extension: [], id: None)
}

///http://hl7.org/fhir/r4b/StructureDefinition/PaymentNotice#resource
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
    status: r4bvaluesets.Fmstatus,
    request: Option(Reference),
    response: Option(Reference),
    created: String,
    provider: Option(Reference),
    payment: Reference,
    payment_date: Option(String),
    payee: Option(Reference),
    recipient: Reference,
    amount: Money,
    payment_status: Option(Codeableconcept),
  )
}

pub fn paymentnotice_new(
  amount,
  recipient,
  payment,
  created,
  status,
) -> Paymentnotice {
  Paymentnotice(
    payment_status: None,
    amount:,
    recipient:,
    payee: None,
    payment_date: None,
    payment:,
    provider: None,
    created:,
    response: None,
    request: None,
    status:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/PaymentReconciliation#resource
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
    status: r4bvaluesets.Fmstatus,
    period: Option(Period),
    created: String,
    payment_issuer: Option(Reference),
    request: Option(Reference),
    requestor: Option(Reference),
    outcome: Option(r4bvaluesets.Remittanceoutcome),
    disposition: Option(String),
    payment_date: String,
    payment_amount: Money,
    payment_identifier: Option(Identifier),
    detail: List(PaymentreconciliationDetail),
    form_code: Option(Codeableconcept),
    process_note: List(PaymentreconciliationProcessnote),
  )
}

pub fn paymentreconciliation_new(
  payment_amount,
  payment_date,
  created,
  status,
) -> Paymentreconciliation {
  Paymentreconciliation(
    process_note: [],
    form_code: None,
    detail: [],
    payment_identifier: None,
    payment_amount:,
    payment_date:,
    disposition: None,
    outcome: None,
    requestor: None,
    request: None,
    payment_issuer: None,
    created:,
    period: None,
    status:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/PaymentReconciliation#resource
pub type PaymentreconciliationDetail {
  PaymentreconciliationDetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Option(Identifier),
    predecessor: Option(Identifier),
    type_: Codeableconcept,
    request: Option(Reference),
    submitter: Option(Reference),
    response: Option(Reference),
    date: Option(String),
    responsible: Option(Reference),
    payee: Option(Reference),
    amount: Option(Money),
  )
}

pub fn paymentreconciliation_detail_new(type_) -> PaymentreconciliationDetail {
  PaymentreconciliationDetail(
    amount: None,
    payee: None,
    responsible: None,
    date: None,
    response: None,
    submitter: None,
    request: None,
    type_:,
    predecessor: None,
    identifier: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/PaymentReconciliation#resource
pub type PaymentreconciliationProcessnote {
  PaymentreconciliationProcessnote(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(r4bvaluesets.Notetype),
    text: Option(String),
  )
}

pub fn paymentreconciliation_processnote_new() -> PaymentreconciliationProcessnote {
  PaymentreconciliationProcessnote(
    text: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Person#resource
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
    name: List(Humanname),
    telecom: List(Contactpoint),
    gender: Option(r4bvaluesets.Administrativegender),
    birth_date: Option(String),
    address: List(Address),
    photo: Option(Attachment),
    managing_organization: Option(Reference),
    active: Option(Bool),
    link: List(PersonLink),
  )
}

pub fn person_new() -> Person {
  Person(
    link: [],
    active: None,
    managing_organization: None,
    photo: None,
    address: [],
    birth_date: None,
    gender: None,
    telecom: [],
    name: [],
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Person#resource
pub type PersonLink {
  PersonLink(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    target: Reference,
    assurance: Option(r4bvaluesets.Identityassurancelevel),
  )
}

pub fn person_link_new(target) -> PersonLink {
  PersonLink(
    assurance: None,
    target:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/PlanDefinition#resource
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
    name: Option(String),
    title: Option(String),
    subtitle: Option(String),
    type_: Option(Codeableconcept),
    status: r4bvaluesets.Publicationstatus,
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
    action: List(PlandefinitionAction),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionSubject {
  PlandefinitionSubjectCodeableconcept(subject: Codeableconcept)
  PlandefinitionSubjectReference(subject: Reference)
  PlandefinitionSubjectCanonical(subject: String)
}

pub fn plandefinition_new(status) -> Plandefinition {
  Plandefinition(
    action: [],
    goal: [],
    library: [],
    related_artifact: [],
    endorser: [],
    reviewer: [],
    editor: [],
    author: [],
    topic: [],
    effective_period: None,
    last_review_date: None,
    approval_date: None,
    copyright: None,
    usage: None,
    purpose: None,
    jurisdiction: [],
    use_context: [],
    description: None,
    contact: [],
    publisher: None,
    date: None,
    subject: None,
    experimental: None,
    status:,
    type_: None,
    subtitle: None,
    title: None,
    name: None,
    version: None,
    identifier: [],
    url: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/PlanDefinition#resource
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

pub fn plandefinition_goal_new(description) -> PlandefinitionGoal {
  PlandefinitionGoal(
    target: [],
    documentation: [],
    addresses: [],
    start: None,
    priority: None,
    description:,
    category: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/PlanDefinition#resource
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

///http://hl7.org/fhir/r4b/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionGoalTargetDetail {
  PlandefinitionGoalTargetDetailQuantity(detail: Quantity)
  PlandefinitionGoalTargetDetailRange(detail: Range)
  PlandefinitionGoalTargetDetailCodeableconcept(detail: Codeableconcept)
}

pub fn plandefinition_goal_target_new() -> PlandefinitionGoalTarget {
  PlandefinitionGoalTarget(
    due: None,
    detail: None,
    measure: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionAction {
  PlandefinitionAction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    prefix: Option(String),
    title: Option(String),
    description: Option(String),
    text_equivalent: Option(String),
    priority: Option(r4bvaluesets.Requestpriority),
    code: List(Codeableconcept),
    reason: List(Codeableconcept),
    documentation: List(Relatedartifact),
    goal_id: List(String),
    subject: Option(PlandefinitionActionSubject),
    trigger: List(Triggerdefinition),
    condition: List(PlandefinitionActionCondition),
    input: List(Datarequirement),
    output: List(Datarequirement),
    related_action: List(PlandefinitionActionRelatedaction),
    timing: Option(PlandefinitionActionTiming),
    participant: List(PlandefinitionActionParticipant),
    type_: Option(Codeableconcept),
    grouping_behavior: Option(r4bvaluesets.Actiongroupingbehavior),
    selection_behavior: Option(r4bvaluesets.Actionselectionbehavior),
    required_behavior: Option(r4bvaluesets.Actionrequiredbehavior),
    precheck_behavior: Option(r4bvaluesets.Actionprecheckbehavior),
    cardinality_behavior: Option(r4bvaluesets.Actioncardinalitybehavior),
    definition: Option(PlandefinitionActionDefinition),
    transform: Option(String),
    dynamic_value: List(PlandefinitionActionDynamicvalue),
    action: List(Nil),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionSubject {
  PlandefinitionActionSubjectCodeableconcept(subject: Codeableconcept)
  PlandefinitionActionSubjectReference(subject: Reference)
  PlandefinitionActionSubjectCanonical(subject: String)
}

///http://hl7.org/fhir/r4b/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionTiming {
  PlandefinitionActionTimingDatetime(timing: String)
  PlandefinitionActionTimingAge(timing: Age)
  PlandefinitionActionTimingPeriod(timing: Period)
  PlandefinitionActionTimingDuration(timing: Duration)
  PlandefinitionActionTimingRange(timing: Range)
  PlandefinitionActionTimingTiming(timing: Timing)
}

///http://hl7.org/fhir/r4b/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionDefinition {
  PlandefinitionActionDefinitionCanonical(definition: String)
  PlandefinitionActionDefinitionUri(definition: String)
}

pub fn plandefinition_action_new() -> PlandefinitionAction {
  PlandefinitionAction(
    action: [],
    dynamic_value: [],
    transform: None,
    definition: None,
    cardinality_behavior: None,
    precheck_behavior: None,
    required_behavior: None,
    selection_behavior: None,
    grouping_behavior: None,
    type_: None,
    participant: [],
    timing: None,
    related_action: [],
    output: [],
    input: [],
    condition: [],
    trigger: [],
    subject: None,
    goal_id: [],
    documentation: [],
    reason: [],
    code: [],
    priority: None,
    text_equivalent: None,
    description: None,
    title: None,
    prefix: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionCondition {
  PlandefinitionActionCondition(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    kind: r4bvaluesets.Actionconditionkind,
    expression: Option(Expression),
  )
}

pub fn plandefinition_action_condition_new(
  kind,
) -> PlandefinitionActionCondition {
  PlandefinitionActionCondition(
    expression: None,
    kind:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionRelatedaction {
  PlandefinitionActionRelatedaction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    action_id: String,
    relationship: r4bvaluesets.Actionrelationshiptype,
    offset: Option(PlandefinitionActionRelatedactionOffset),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionRelatedactionOffset {
  PlandefinitionActionRelatedactionOffsetDuration(offset: Duration)
  PlandefinitionActionRelatedactionOffsetRange(offset: Range)
}

pub fn plandefinition_action_relatedaction_new(
  relationship,
  action_id,
) -> PlandefinitionActionRelatedaction {
  PlandefinitionActionRelatedaction(
    offset: None,
    relationship:,
    action_id:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionParticipant {
  PlandefinitionActionParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r4bvaluesets.Actionparticipanttype,
    role: Option(Codeableconcept),
  )
}

pub fn plandefinition_action_participant_new(
  type_,
) -> PlandefinitionActionParticipant {
  PlandefinitionActionParticipant(
    role: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionDynamicvalue {
  PlandefinitionActionDynamicvalue(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    path: Option(String),
    expression: Option(Expression),
  )
}

pub fn plandefinition_action_dynamicvalue_new() -> PlandefinitionActionDynamicvalue {
  PlandefinitionActionDynamicvalue(
    expression: None,
    path: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Practitioner#resource
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
    address: List(Address),
    gender: Option(r4bvaluesets.Administrativegender),
    birth_date: Option(String),
    photo: List(Attachment),
    qualification: List(PractitionerQualification),
    communication: List(Codeableconcept),
  )
}

pub fn practitioner_new() -> Practitioner {
  Practitioner(
    communication: [],
    qualification: [],
    photo: [],
    birth_date: None,
    gender: None,
    address: [],
    telecom: [],
    name: [],
    active: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Practitioner#resource
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

pub fn practitioner_qualification_new(code) -> PractitionerQualification {
  PractitionerQualification(
    issuer: None,
    period: None,
    code:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/PractitionerRole#resource
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
    telecom: List(Contactpoint),
    available_time: List(PractitionerroleAvailabletime),
    not_available: List(PractitionerroleNotavailable),
    availability_exceptions: Option(String),
    endpoint: List(Reference),
  )
}

pub fn practitionerrole_new() -> Practitionerrole {
  Practitionerrole(
    endpoint: [],
    availability_exceptions: None,
    not_available: [],
    available_time: [],
    telecom: [],
    healthcare_service: [],
    location: [],
    specialty: [],
    code: [],
    organization: None,
    practitioner: None,
    period: None,
    active: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/PractitionerRole#resource
pub type PractitionerroleAvailabletime {
  PractitionerroleAvailabletime(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    days_of_week: List(r4bvaluesets.Daysofweek),
    all_day: Option(Bool),
    available_start_time: Option(String),
    available_end_time: Option(String),
  )
}

pub fn practitionerrole_availabletime_new() -> PractitionerroleAvailabletime {
  PractitionerroleAvailabletime(
    available_end_time: None,
    available_start_time: None,
    all_day: None,
    days_of_week: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/PractitionerRole#resource
pub type PractitionerroleNotavailable {
  PractitionerroleNotavailable(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: String,
    during: Option(Period),
  )
}

pub fn practitionerrole_notavailable_new(
  description,
) -> PractitionerroleNotavailable {
  PractitionerroleNotavailable(
    during: None,
    description:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Procedure#resource
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
    status: r4bvaluesets.Eventstatus,
    status_reason: Option(Codeableconcept),
    category: Option(Codeableconcept),
    code: Option(Codeableconcept),
    subject: Reference,
    encounter: Option(Reference),
    performed: Option(ProcedurePerformed),
    recorder: Option(Reference),
    asserter: Option(Reference),
    performer: List(ProcedurePerformer),
    location: Option(Reference),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    body_site: List(Codeableconcept),
    outcome: Option(Codeableconcept),
    report: List(Reference),
    complication: List(Codeableconcept),
    complication_detail: List(Reference),
    follow_up: List(Codeableconcept),
    note: List(Annotation),
    focal_device: List(ProcedureFocaldevice),
    used_reference: List(Reference),
    used_code: List(Codeableconcept),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Procedure#resource
pub type ProcedurePerformed {
  ProcedurePerformedDatetime(performed: String)
  ProcedurePerformedPeriod(performed: Period)
  ProcedurePerformedString(performed: String)
  ProcedurePerformedAge(performed: Age)
  ProcedurePerformedRange(performed: Range)
}

pub fn procedure_new(subject, status) -> Procedure {
  Procedure(
    used_code: [],
    used_reference: [],
    focal_device: [],
    note: [],
    follow_up: [],
    complication_detail: [],
    complication: [],
    report: [],
    outcome: None,
    body_site: [],
    reason_reference: [],
    reason_code: [],
    location: None,
    performer: [],
    asserter: None,
    recorder: None,
    performed: None,
    encounter: None,
    subject:,
    code: None,
    category: None,
    status_reason: None,
    status:,
    part_of: [],
    based_on: [],
    instantiates_uri: [],
    instantiates_canonical: [],
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Procedure#resource
pub type ProcedurePerformer {
  ProcedurePerformer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    function: Option(Codeableconcept),
    actor: Reference,
    on_behalf_of: Option(Reference),
  )
}

pub fn procedure_performer_new(actor) -> ProcedurePerformer {
  ProcedurePerformer(
    on_behalf_of: None,
    actor:,
    function: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Procedure#resource
pub type ProcedureFocaldevice {
  ProcedureFocaldevice(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    action: Option(Codeableconcept),
    manipulated: Reference,
  )
}

pub fn procedure_focaldevice_new(manipulated) -> ProcedureFocaldevice {
  ProcedureFocaldevice(
    manipulated:,
    action: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Provenance#resource
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
    recorded: String,
    policy: List(String),
    location: Option(Reference),
    reason: List(Codeableconcept),
    activity: Option(Codeableconcept),
    agent: List(ProvenanceAgent),
    entity: List(ProvenanceEntity),
    signature: List(Signature),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Provenance#resource
pub type ProvenanceOccurred {
  ProvenanceOccurredPeriod(occurred: Period)
  ProvenanceOccurredDatetime(occurred: String)
}

pub fn provenance_new(recorded) -> Provenance {
  Provenance(
    signature: [],
    entity: [],
    agent: [],
    activity: None,
    reason: [],
    location: None,
    policy: [],
    recorded:,
    occurred: None,
    target: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Provenance#resource
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

pub fn provenance_agent_new(who) -> ProvenanceAgent {
  ProvenanceAgent(
    on_behalf_of: None,
    who:,
    role: [],
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Provenance#resource
pub type ProvenanceEntity {
  ProvenanceEntity(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    role: r4bvaluesets.Provenanceentityrole,
    what: Reference,
    agent: List(Nil),
  )
}

pub fn provenance_entity_new(what, role) -> ProvenanceEntity {
  ProvenanceEntity(
    agent: [],
    what:,
    role:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Questionnaire#resource
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
    name: Option(String),
    title: Option(String),
    derived_from: List(String),
    status: r4bvaluesets.Publicationstatus,
    experimental: Option(Bool),
    subject_type: List(r4bvaluesets.Resourcetypes),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    approval_date: Option(String),
    last_review_date: Option(String),
    effective_period: Option(Period),
    code: List(Coding),
    item: List(QuestionnaireItem),
  )
}

pub fn questionnaire_new(status) -> Questionnaire {
  Questionnaire(
    item: [],
    code: [],
    effective_period: None,
    last_review_date: None,
    approval_date: None,
    copyright: None,
    purpose: None,
    jurisdiction: [],
    use_context: [],
    description: None,
    contact: [],
    publisher: None,
    date: None,
    subject_type: [],
    experimental: None,
    status:,
    derived_from: [],
    title: None,
    name: None,
    version: None,
    identifier: [],
    url: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Questionnaire#resource
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
    type_: r4bvaluesets.Itemtype,
    enable_when: List(QuestionnaireItemEnablewhen),
    enable_behavior: Option(r4bvaluesets.Questionnaireenablebehavior),
    required: Option(Bool),
    repeats: Option(Bool),
    read_only: Option(Bool),
    max_length: Option(Int),
    answer_value_set: Option(String),
    answer_option: List(QuestionnaireItemAnsweroption),
    initial: List(QuestionnaireItemInitial),
    item: List(Nil),
  )
}

pub fn questionnaire_item_new(type_, link_id) -> QuestionnaireItem {
  QuestionnaireItem(
    item: [],
    initial: [],
    answer_option: [],
    answer_value_set: None,
    max_length: None,
    read_only: None,
    repeats: None,
    required: None,
    enable_behavior: None,
    enable_when: [],
    type_:,
    text: None,
    prefix: None,
    code: [],
    definition: None,
    link_id:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Questionnaire#resource
pub type QuestionnaireItemEnablewhen {
  QuestionnaireItemEnablewhen(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    question: String,
    operator: r4bvaluesets.Questionnaireenableoperator,
    answer: QuestionnaireItemEnablewhenAnswer,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Questionnaire#resource
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

pub fn questionnaire_item_enablewhen_new(
  answer,
  operator,
  question,
) -> QuestionnaireItemEnablewhen {
  QuestionnaireItemEnablewhen(
    answer:,
    operator:,
    question:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Questionnaire#resource
pub type QuestionnaireItemAnsweroption {
  QuestionnaireItemAnsweroption(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    value: QuestionnaireItemAnsweroptionValue,
    initial_selected: Option(Bool),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Questionnaire#resource
pub type QuestionnaireItemAnsweroptionValue {
  QuestionnaireItemAnsweroptionValueInteger(value: Int)
  QuestionnaireItemAnsweroptionValueDate(value: String)
  QuestionnaireItemAnsweroptionValueTime(value: String)
  QuestionnaireItemAnsweroptionValueString(value: String)
  QuestionnaireItemAnsweroptionValueCoding(value: Coding)
  QuestionnaireItemAnsweroptionValueReference(value: Reference)
}

pub fn questionnaire_item_answeroption_new(
  value,
) -> QuestionnaireItemAnsweroption {
  QuestionnaireItemAnsweroption(
    initial_selected: None,
    value:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Questionnaire#resource
pub type QuestionnaireItemInitial {
  QuestionnaireItemInitial(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    value: QuestionnaireItemInitialValue,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Questionnaire#resource
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

pub fn questionnaire_item_initial_new(value) -> QuestionnaireItemInitial {
  QuestionnaireItemInitial(
    value:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/QuestionnaireResponse#resource
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
    identifier: Option(Identifier),
    based_on: List(Reference),
    part_of: List(Reference),
    questionnaire: Option(String),
    status: r4bvaluesets.Questionnaireanswersstatus,
    subject: Option(Reference),
    encounter: Option(Reference),
    authored: Option(String),
    author: Option(Reference),
    source: Option(Reference),
    item: List(QuestionnaireresponseItem),
  )
}

pub fn questionnaireresponse_new(status) -> Questionnaireresponse {
  Questionnaireresponse(
    item: [],
    source: None,
    author: None,
    authored: None,
    encounter: None,
    subject: None,
    status:,
    questionnaire: None,
    part_of: [],
    based_on: [],
    identifier: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/QuestionnaireResponse#resource
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

pub fn questionnaireresponse_item_new(link_id) -> QuestionnaireresponseItem {
  QuestionnaireresponseItem(
    item: [],
    answer: [],
    text: None,
    definition: None,
    link_id:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/QuestionnaireResponse#resource
pub type QuestionnaireresponseItemAnswer {
  QuestionnaireresponseItemAnswer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    value: Option(QuestionnaireresponseItemAnswerValue),
    item: List(Nil),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/QuestionnaireResponse#resource
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

pub fn questionnaireresponse_item_answer_new() -> QuestionnaireresponseItemAnswer {
  QuestionnaireresponseItemAnswer(
    item: [],
    value: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/RegulatedAuthorization#resource
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
    indication: Option(Codeablereference),
    intended_use: Option(Codeableconcept),
    basis: List(Codeableconcept),
    holder: Option(Reference),
    regulator: Option(Reference),
    case_: Option(RegulatedauthorizationCase),
  )
}

pub fn regulatedauthorization_new() -> Regulatedauthorization {
  Regulatedauthorization(
    case_: None,
    regulator: None,
    holder: None,
    basis: [],
    intended_use: None,
    indication: None,
    validity_period: None,
    status_date: None,
    status: None,
    region: [],
    description: None,
    type_: None,
    subject: [],
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/RegulatedAuthorization#resource
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

///http://hl7.org/fhir/r4b/StructureDefinition/RegulatedAuthorization#resource
pub type RegulatedauthorizationCaseDate {
  RegulatedauthorizationCaseDatePeriod(date: Period)
  RegulatedauthorizationCaseDateDatetime(date: String)
}

pub fn regulatedauthorization_case_new() -> RegulatedauthorizationCase {
  RegulatedauthorizationCase(
    application: [],
    date: None,
    status: None,
    type_: None,
    identifier: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/RelatedPerson#resource
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
    gender: Option(r4bvaluesets.Administrativegender),
    birth_date: Option(String),
    address: List(Address),
    photo: List(Attachment),
    period: Option(Period),
    communication: List(RelatedpersonCommunication),
  )
}

pub fn relatedperson_new(patient) -> Relatedperson {
  Relatedperson(
    communication: [],
    period: None,
    photo: [],
    address: [],
    birth_date: None,
    gender: None,
    telecom: [],
    name: [],
    relationship: [],
    patient:,
    active: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/RelatedPerson#resource
pub type RelatedpersonCommunication {
  RelatedpersonCommunication(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    language: Codeableconcept,
    preferred: Option(Bool),
  )
}

pub fn relatedperson_communication_new(language) -> RelatedpersonCommunication {
  RelatedpersonCommunication(
    preferred: None,
    language:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/RequestGroup#resource
pub type Requestgroup {
  Requestgroup(
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
    status: r4bvaluesets.Requeststatus,
    intent: r4bvaluesets.Requestintent,
    priority: Option(r4bvaluesets.Requestpriority),
    code: Option(Codeableconcept),
    subject: Option(Reference),
    encounter: Option(Reference),
    authored_on: Option(String),
    author: Option(Reference),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    note: List(Annotation),
    action: List(RequestgroupAction),
  )
}

pub fn requestgroup_new(intent, status) -> Requestgroup {
  Requestgroup(
    action: [],
    note: [],
    reason_reference: [],
    reason_code: [],
    author: None,
    authored_on: None,
    encounter: None,
    subject: None,
    code: None,
    priority: None,
    intent:,
    status:,
    group_identifier: None,
    replaces: [],
    based_on: [],
    instantiates_uri: [],
    instantiates_canonical: [],
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/RequestGroup#resource
pub type RequestgroupAction {
  RequestgroupAction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    prefix: Option(String),
    title: Option(String),
    description: Option(String),
    text_equivalent: Option(String),
    priority: Option(r4bvaluesets.Requestpriority),
    code: List(Codeableconcept),
    documentation: List(Relatedartifact),
    condition: List(RequestgroupActionCondition),
    related_action: List(RequestgroupActionRelatedaction),
    timing: Option(RequestgroupActionTiming),
    participant: List(Reference),
    type_: Option(Codeableconcept),
    grouping_behavior: Option(r4bvaluesets.Actiongroupingbehavior),
    selection_behavior: Option(r4bvaluesets.Actionselectionbehavior),
    required_behavior: Option(r4bvaluesets.Actionrequiredbehavior),
    precheck_behavior: Option(r4bvaluesets.Actionprecheckbehavior),
    cardinality_behavior: Option(r4bvaluesets.Actioncardinalitybehavior),
    resource: Option(Reference),
    action: List(Nil),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/RequestGroup#resource
pub type RequestgroupActionTiming {
  RequestgroupActionTimingDatetime(timing: String)
  RequestgroupActionTimingAge(timing: Age)
  RequestgroupActionTimingPeriod(timing: Period)
  RequestgroupActionTimingDuration(timing: Duration)
  RequestgroupActionTimingRange(timing: Range)
  RequestgroupActionTimingTiming(timing: Timing)
}

pub fn requestgroup_action_new() -> RequestgroupAction {
  RequestgroupAction(
    action: [],
    resource: None,
    cardinality_behavior: None,
    precheck_behavior: None,
    required_behavior: None,
    selection_behavior: None,
    grouping_behavior: None,
    type_: None,
    participant: [],
    timing: None,
    related_action: [],
    condition: [],
    documentation: [],
    code: [],
    priority: None,
    text_equivalent: None,
    description: None,
    title: None,
    prefix: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/RequestGroup#resource
pub type RequestgroupActionCondition {
  RequestgroupActionCondition(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    kind: r4bvaluesets.Actionconditionkind,
    expression: Option(Expression),
  )
}

pub fn requestgroup_action_condition_new(kind) -> RequestgroupActionCondition {
  RequestgroupActionCondition(
    expression: None,
    kind:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/RequestGroup#resource
pub type RequestgroupActionRelatedaction {
  RequestgroupActionRelatedaction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    action_id: String,
    relationship: r4bvaluesets.Actionrelationshiptype,
    offset: Option(RequestgroupActionRelatedactionOffset),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/RequestGroup#resource
pub type RequestgroupActionRelatedactionOffset {
  RequestgroupActionRelatedactionOffsetDuration(offset: Duration)
  RequestgroupActionRelatedactionOffsetRange(offset: Range)
}

pub fn requestgroup_action_relatedaction_new(
  relationship,
  action_id,
) -> RequestgroupActionRelatedaction {
  RequestgroupActionRelatedaction(
    offset: None,
    relationship:,
    action_id:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ResearchDefinition#resource
pub type Researchdefinition {
  Researchdefinition(
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
    short_title: Option(String),
    subtitle: Option(String),
    status: r4bvaluesets.Publicationstatus,
    experimental: Option(Bool),
    subject: Option(ResearchdefinitionSubject),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    comment: List(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    usage: Option(String),
    copyright: Option(String),
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
    population: Reference,
    exposure: Option(Reference),
    exposure_alternative: Option(Reference),
    outcome: Option(Reference),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ResearchDefinition#resource
pub type ResearchdefinitionSubject {
  ResearchdefinitionSubjectCodeableconcept(subject: Codeableconcept)
  ResearchdefinitionSubjectReference(subject: Reference)
}

pub fn researchdefinition_new(population, status) -> Researchdefinition {
  Researchdefinition(
    outcome: None,
    exposure_alternative: None,
    exposure: None,
    population:,
    library: [],
    related_artifact: [],
    endorser: [],
    reviewer: [],
    editor: [],
    author: [],
    topic: [],
    effective_period: None,
    last_review_date: None,
    approval_date: None,
    copyright: None,
    usage: None,
    purpose: None,
    jurisdiction: [],
    use_context: [],
    comment: [],
    description: None,
    contact: [],
    publisher: None,
    date: None,
    subject: None,
    experimental: None,
    status:,
    subtitle: None,
    short_title: None,
    title: None,
    name: None,
    version: None,
    identifier: [],
    url: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ResearchElementDefinition#resource
pub type Researchelementdefinition {
  Researchelementdefinition(
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
    short_title: Option(String),
    subtitle: Option(String),
    status: r4bvaluesets.Publicationstatus,
    experimental: Option(Bool),
    subject: Option(ResearchelementdefinitionSubject),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    comment: List(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    usage: Option(String),
    copyright: Option(String),
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
    type_: r4bvaluesets.Researchelementtype,
    variable_type: Option(r4bvaluesets.Variabletype),
    characteristic: List(ResearchelementdefinitionCharacteristic),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ResearchElementDefinition#resource
pub type ResearchelementdefinitionSubject {
  ResearchelementdefinitionSubjectCodeableconcept(subject: Codeableconcept)
  ResearchelementdefinitionSubjectReference(subject: Reference)
}

pub fn researchelementdefinition_new(type_, status) -> Researchelementdefinition {
  Researchelementdefinition(
    characteristic: [],
    variable_type: None,
    type_:,
    library: [],
    related_artifact: [],
    endorser: [],
    reviewer: [],
    editor: [],
    author: [],
    topic: [],
    effective_period: None,
    last_review_date: None,
    approval_date: None,
    copyright: None,
    usage: None,
    purpose: None,
    jurisdiction: [],
    use_context: [],
    comment: [],
    description: None,
    contact: [],
    publisher: None,
    date: None,
    subject: None,
    experimental: None,
    status:,
    subtitle: None,
    short_title: None,
    title: None,
    name: None,
    version: None,
    identifier: [],
    url: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ResearchElementDefinition#resource
pub type ResearchelementdefinitionCharacteristic {
  ResearchelementdefinitionCharacteristic(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    definition: ResearchelementdefinitionCharacteristicDefinition,
    usage_context: List(Usagecontext),
    exclude: Option(Bool),
    unit_of_measure: Option(Codeableconcept),
    study_effective_description: Option(String),
    study_effective: Option(
      ResearchelementdefinitionCharacteristicStudyeffective,
    ),
    study_effective_time_from_start: Option(Duration),
    study_effective_group_measure: Option(r4bvaluesets.Groupmeasure),
    participant_effective_description: Option(String),
    participant_effective: Option(
      ResearchelementdefinitionCharacteristicParticipanteffective,
    ),
    participant_effective_time_from_start: Option(Duration),
    participant_effective_group_measure: Option(r4bvaluesets.Groupmeasure),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ResearchElementDefinition#resource
pub type ResearchelementdefinitionCharacteristicDefinition {
  ResearchelementdefinitionCharacteristicDefinitionCodeableconcept(
    definition: Codeableconcept,
  )
  ResearchelementdefinitionCharacteristicDefinitionCanonical(definition: String)
  ResearchelementdefinitionCharacteristicDefinitionExpression(
    definition: Expression,
  )
  ResearchelementdefinitionCharacteristicDefinitionDatarequirement(
    definition: Datarequirement,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ResearchElementDefinition#resource
pub type ResearchelementdefinitionCharacteristicStudyeffective {
  ResearchelementdefinitionCharacteristicStudyeffectiveDatetime(
    study_effective: String,
  )
  ResearchelementdefinitionCharacteristicStudyeffectivePeriod(
    study_effective: Period,
  )
  ResearchelementdefinitionCharacteristicStudyeffectiveDuration(
    study_effective: Duration,
  )
  ResearchelementdefinitionCharacteristicStudyeffectiveTiming(
    study_effective: Timing,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ResearchElementDefinition#resource
pub type ResearchelementdefinitionCharacteristicParticipanteffective {
  ResearchelementdefinitionCharacteristicParticipanteffectiveDatetime(
    participant_effective: String,
  )
  ResearchelementdefinitionCharacteristicParticipanteffectivePeriod(
    participant_effective: Period,
  )
  ResearchelementdefinitionCharacteristicParticipanteffectiveDuration(
    participant_effective: Duration,
  )
  ResearchelementdefinitionCharacteristicParticipanteffectiveTiming(
    participant_effective: Timing,
  )
}

pub fn researchelementdefinition_characteristic_new(
  definition,
) -> ResearchelementdefinitionCharacteristic {
  ResearchelementdefinitionCharacteristic(
    participant_effective_group_measure: None,
    participant_effective_time_from_start: None,
    participant_effective: None,
    participant_effective_description: None,
    study_effective_group_measure: None,
    study_effective_time_from_start: None,
    study_effective: None,
    study_effective_description: None,
    unit_of_measure: None,
    exclude: None,
    usage_context: [],
    definition:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ResearchStudy#resource
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
    identifier: List(Identifier),
    title: Option(String),
    protocol: List(Reference),
    part_of: List(Reference),
    status: r4bvaluesets.Researchstudystatus,
    primary_purpose_type: Option(Codeableconcept),
    phase: Option(Codeableconcept),
    category: List(Codeableconcept),
    focus: List(Codeableconcept),
    condition: List(Codeableconcept),
    contact: List(Contactdetail),
    related_artifact: List(Relatedartifact),
    keyword: List(Codeableconcept),
    location: List(Codeableconcept),
    description: Option(String),
    enrollment: List(Reference),
    period: Option(Period),
    sponsor: Option(Reference),
    principal_investigator: Option(Reference),
    site: List(Reference),
    reason_stopped: Option(Codeableconcept),
    note: List(Annotation),
    arm: List(ResearchstudyArm),
    objective: List(ResearchstudyObjective),
  )
}

pub fn researchstudy_new(status) -> Researchstudy {
  Researchstudy(
    objective: [],
    arm: [],
    note: [],
    reason_stopped: None,
    site: [],
    principal_investigator: None,
    sponsor: None,
    period: None,
    enrollment: [],
    description: None,
    location: [],
    keyword: [],
    related_artifact: [],
    contact: [],
    condition: [],
    focus: [],
    category: [],
    phase: None,
    primary_purpose_type: None,
    status:,
    part_of: [],
    protocol: [],
    title: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ResearchStudy#resource
pub type ResearchstudyArm {
  ResearchstudyArm(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    type_: Option(Codeableconcept),
    description: Option(String),
  )
}

pub fn researchstudy_arm_new(name) -> ResearchstudyArm {
  ResearchstudyArm(
    description: None,
    type_: None,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ResearchStudy#resource
pub type ResearchstudyObjective {
  ResearchstudyObjective(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: Option(String),
    type_: Option(Codeableconcept),
  )
}

pub fn researchstudy_objective_new() -> ResearchstudyObjective {
  ResearchstudyObjective(
    type_: None,
    name: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ResearchSubject#resource
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
    status: r4bvaluesets.Researchsubjectstatus,
    period: Option(Period),
    study: Reference,
    individual: Reference,
    assigned_arm: Option(String),
    actual_arm: Option(String),
    consent: Option(Reference),
  )
}

pub fn researchsubject_new(individual, study, status) -> Researchsubject {
  Researchsubject(
    consent: None,
    actual_arm: None,
    assigned_arm: None,
    individual:,
    study:,
    period: None,
    status:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/RiskAssessment#resource
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
    status: r4bvaluesets.Observationstatus,
    method: Option(Codeableconcept),
    code: Option(Codeableconcept),
    subject: Reference,
    encounter: Option(Reference),
    occurrence: Option(RiskassessmentOccurrence),
    condition: Option(Reference),
    performer: Option(Reference),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    basis: List(Reference),
    prediction: List(RiskassessmentPrediction),
    mitigation: Option(String),
    note: List(Annotation),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/RiskAssessment#resource
pub type RiskassessmentOccurrence {
  RiskassessmentOccurrenceDatetime(occurrence: String)
  RiskassessmentOccurrencePeriod(occurrence: Period)
}

pub fn riskassessment_new(subject, status) -> Riskassessment {
  Riskassessment(
    note: [],
    mitigation: None,
    prediction: [],
    basis: [],
    reason_reference: [],
    reason_code: [],
    performer: None,
    condition: None,
    occurrence: None,
    encounter: None,
    subject:,
    code: None,
    method: None,
    status:,
    parent: None,
    based_on: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/RiskAssessment#resource
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

///http://hl7.org/fhir/r4b/StructureDefinition/RiskAssessment#resource
pub type RiskassessmentPredictionProbability {
  RiskassessmentPredictionProbabilityDecimal(probability: Float)
  RiskassessmentPredictionProbabilityRange(probability: Range)
}

///http://hl7.org/fhir/r4b/StructureDefinition/RiskAssessment#resource
pub type RiskassessmentPredictionWhen {
  RiskassessmentPredictionWhenPeriod(when: Period)
  RiskassessmentPredictionWhenRange(when: Range)
}

pub fn riskassessment_prediction_new() -> RiskassessmentPrediction {
  RiskassessmentPrediction(
    rationale: None,
    when: None,
    relative_risk: None,
    qualitative_risk: None,
    probability: None,
    outcome: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Schedule#resource
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
    service_type: List(Codeableconcept),
    specialty: List(Codeableconcept),
    actor: List(Reference),
    planning_horizon: Option(Period),
    comment: Option(String),
  )
}

pub fn schedule_new() -> Schedule {
  Schedule(
    comment: None,
    planning_horizon: None,
    actor: [],
    specialty: [],
    service_type: [],
    service_category: [],
    active: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SearchParameter#resource
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
    version: Option(String),
    name: String,
    derived_from: Option(String),
    status: r4bvaluesets.Publicationstatus,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: String,
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    code: String,
    base: List(r4bvaluesets.Resourcetypes),
    type_: r4bvaluesets.Searchparamtype,
    expression: Option(String),
    xpath: Option(String),
    xpath_usage: Option(r4bvaluesets.Searchxpathusage),
    target: List(r4bvaluesets.Resourcetypes),
    multiple_or: Option(Bool),
    multiple_and: Option(Bool),
    comparator: List(r4bvaluesets.Searchcomparator),
    modifier: List(r4bvaluesets.Searchmodifiercode),
    chain: List(String),
    component: List(SearchparameterComponent),
  )
}

pub fn searchparameter_new(
  type_,
  code,
  description,
  status,
  name,
  url,
) -> Searchparameter {
  Searchparameter(
    component: [],
    chain: [],
    modifier: [],
    comparator: [],
    multiple_and: None,
    multiple_or: None,
    target: [],
    xpath_usage: None,
    xpath: None,
    expression: None,
    type_:,
    base: [],
    code:,
    purpose: None,
    jurisdiction: [],
    use_context: [],
    description:,
    contact: [],
    publisher: None,
    date: None,
    experimental: None,
    status:,
    derived_from: None,
    name:,
    version: None,
    url:,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SearchParameter#resource
pub type SearchparameterComponent {
  SearchparameterComponent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    definition: String,
    expression: String,
  )
}

pub fn searchparameter_component_new(
  expression,
  definition,
) -> SearchparameterComponent {
  SearchparameterComponent(
    expression:,
    definition:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ServiceRequest#resource
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
    status: r4bvaluesets.Requeststatus,
    intent: r4bvaluesets.Requestintent,
    category: List(Codeableconcept),
    priority: Option(r4bvaluesets.Requestpriority),
    do_not_perform: Option(Bool),
    code: Option(Codeableconcept),
    order_detail: List(Codeableconcept),
    quantity: Option(ServicerequestQuantity),
    subject: Reference,
    encounter: Option(Reference),
    occurrence: Option(ServicerequestOccurrence),
    as_needed: Option(ServicerequestAsneeded),
    authored_on: Option(String),
    requester: Option(Reference),
    performer_type: Option(Codeableconcept),
    performer: List(Reference),
    location_code: List(Codeableconcept),
    location_reference: List(Reference),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    insurance: List(Reference),
    supporting_info: List(Reference),
    specimen: List(Reference),
    body_site: List(Codeableconcept),
    note: List(Annotation),
    patient_instruction: Option(String),
    relevant_history: List(Reference),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ServiceRequest#resource
pub type ServicerequestQuantity {
  ServicerequestQuantityQuantity(quantity: Quantity)
  ServicerequestQuantityRatio(quantity: Ratio)
  ServicerequestQuantityRange(quantity: Range)
}

///http://hl7.org/fhir/r4b/StructureDefinition/ServiceRequest#resource
pub type ServicerequestOccurrence {
  ServicerequestOccurrenceDatetime(occurrence: String)
  ServicerequestOccurrencePeriod(occurrence: Period)
  ServicerequestOccurrenceTiming(occurrence: Timing)
}

///http://hl7.org/fhir/r4b/StructureDefinition/ServiceRequest#resource
pub type ServicerequestAsneeded {
  ServicerequestAsneededBoolean(as_needed: Bool)
  ServicerequestAsneededCodeableconcept(as_needed: Codeableconcept)
}

pub fn servicerequest_new(subject, intent, status) -> Servicerequest {
  Servicerequest(
    relevant_history: [],
    patient_instruction: None,
    note: [],
    body_site: [],
    specimen: [],
    supporting_info: [],
    insurance: [],
    reason_reference: [],
    reason_code: [],
    location_reference: [],
    location_code: [],
    performer: [],
    performer_type: None,
    requester: None,
    authored_on: None,
    as_needed: None,
    occurrence: None,
    encounter: None,
    subject:,
    quantity: None,
    order_detail: [],
    code: None,
    do_not_perform: None,
    priority: None,
    category: [],
    intent:,
    status:,
    requisition: None,
    replaces: [],
    based_on: [],
    instantiates_uri: [],
    instantiates_canonical: [],
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Slot#resource
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
    service_type: List(Codeableconcept),
    specialty: List(Codeableconcept),
    appointment_type: Option(Codeableconcept),
    schedule: Reference,
    status: r4bvaluesets.Slotstatus,
    start: String,
    end: String,
    overbooked: Option(Bool),
    comment: Option(String),
  )
}

pub fn slot_new(end, start, status, schedule) -> Slot {
  Slot(
    comment: None,
    overbooked: None,
    end:,
    start:,
    status:,
    schedule:,
    appointment_type: None,
    specialty: [],
    service_type: [],
    service_category: [],
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Specimen#resource
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
    status: Option(r4bvaluesets.Specimenstatus),
    type_: Option(Codeableconcept),
    subject: Option(Reference),
    received_time: Option(String),
    parent: List(Reference),
    request: List(Reference),
    collection: Option(SpecimenCollection),
    processing: List(SpecimenProcessing),
    container: List(SpecimenContainer),
    condition: List(Codeableconcept),
    note: List(Annotation),
  )
}

pub fn specimen_new() -> Specimen {
  Specimen(
    note: [],
    condition: [],
    container: [],
    processing: [],
    collection: None,
    request: [],
    parent: [],
    received_time: None,
    subject: None,
    type_: None,
    status: None,
    accession_identifier: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Specimen#resource
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
    body_site: Option(Codeableconcept),
    fasting_status: Option(SpecimenCollectionFastingstatus),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Specimen#resource
pub type SpecimenCollectionCollected {
  SpecimenCollectionCollectedDatetime(collected: String)
  SpecimenCollectionCollectedPeriod(collected: Period)
}

///http://hl7.org/fhir/r4b/StructureDefinition/Specimen#resource
pub type SpecimenCollectionFastingstatus {
  SpecimenCollectionFastingstatusCodeableconcept(
    fasting_status: Codeableconcept,
  )
  SpecimenCollectionFastingstatusDuration(fasting_status: Duration)
}

pub fn specimen_collection_new() -> SpecimenCollection {
  SpecimenCollection(
    fasting_status: None,
    body_site: None,
    method: None,
    quantity: None,
    duration: None,
    collected: None,
    collector: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Specimen#resource
pub type SpecimenProcessing {
  SpecimenProcessing(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    procedure: Option(Codeableconcept),
    additive: List(Reference),
    time: Option(SpecimenProcessingTime),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Specimen#resource
pub type SpecimenProcessingTime {
  SpecimenProcessingTimeDatetime(time: String)
  SpecimenProcessingTimePeriod(time: Period)
}

pub fn specimen_processing_new() -> SpecimenProcessing {
  SpecimenProcessing(
    time: None,
    additive: [],
    procedure: None,
    description: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Specimen#resource
pub type SpecimenContainer {
  SpecimenContainer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    description: Option(String),
    type_: Option(Codeableconcept),
    capacity: Option(Quantity),
    specimen_quantity: Option(Quantity),
    additive: Option(SpecimenContainerAdditive),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Specimen#resource
pub type SpecimenContainerAdditive {
  SpecimenContainerAdditiveCodeableconcept(additive: Codeableconcept)
  SpecimenContainerAdditiveReference(additive: Reference)
}

pub fn specimen_container_new() -> SpecimenContainer {
  SpecimenContainer(
    additive: None,
    specimen_quantity: None,
    capacity: None,
    type_: None,
    description: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SpecimenDefinition#resource
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
    identifier: Option(Identifier),
    type_collected: Option(Codeableconcept),
    patient_preparation: List(Codeableconcept),
    time_aspect: Option(String),
    collection: List(Codeableconcept),
    type_tested: List(SpecimendefinitionTypetested),
  )
}

pub fn specimendefinition_new() -> Specimendefinition {
  Specimendefinition(
    type_tested: [],
    collection: [],
    time_aspect: None,
    patient_preparation: [],
    type_collected: None,
    identifier: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SpecimenDefinition#resource
pub type SpecimendefinitionTypetested {
  SpecimendefinitionTypetested(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    is_derived: Option(Bool),
    type_: Option(Codeableconcept),
    preference: r4bvaluesets.Specimencontainedpreference,
    container: Option(SpecimendefinitionTypetestedContainer),
    requirement: Option(String),
    retention_time: Option(Duration),
    rejection_criterion: List(Codeableconcept),
    handling: List(SpecimendefinitionTypetestedHandling),
  )
}

pub fn specimendefinition_typetested_new(
  preference,
) -> SpecimendefinitionTypetested {
  SpecimendefinitionTypetested(
    handling: [],
    rejection_criterion: [],
    retention_time: None,
    requirement: None,
    container: None,
    preference:,
    type_: None,
    is_derived: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SpecimenDefinition#resource
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

///http://hl7.org/fhir/r4b/StructureDefinition/SpecimenDefinition#resource
pub type SpecimendefinitionTypetestedContainerMinimumvolume {
  SpecimendefinitionTypetestedContainerMinimumvolumeQuantity(
    minimum_volume: Quantity,
  )
  SpecimendefinitionTypetestedContainerMinimumvolumeString(
    minimum_volume: String,
  )
}

pub fn specimendefinition_typetested_container_new() -> SpecimendefinitionTypetestedContainer {
  SpecimendefinitionTypetestedContainer(
    preparation: None,
    additive: [],
    minimum_volume: None,
    capacity: None,
    description: None,
    cap: None,
    type_: None,
    material: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SpecimenDefinition#resource
pub type SpecimendefinitionTypetestedContainerAdditive {
  SpecimendefinitionTypetestedContainerAdditive(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    additive: SpecimendefinitionTypetestedContainerAdditiveAdditive,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SpecimenDefinition#resource
pub type SpecimendefinitionTypetestedContainerAdditiveAdditive {
  SpecimendefinitionTypetestedContainerAdditiveAdditiveCodeableconcept(
    additive: Codeableconcept,
  )
  SpecimendefinitionTypetestedContainerAdditiveAdditiveReference(
    additive: Reference,
  )
}

pub fn specimendefinition_typetested_container_additive_new(
  additive,
) -> SpecimendefinitionTypetestedContainerAdditive {
  SpecimendefinitionTypetestedContainerAdditive(
    additive:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SpecimenDefinition#resource
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

pub fn specimendefinition_typetested_handling_new() -> SpecimendefinitionTypetestedHandling {
  SpecimendefinitionTypetestedHandling(
    instruction: None,
    max_duration: None,
    temperature_range: None,
    temperature_qualifier: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/StructureDefinition#resource
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
    name: String,
    title: Option(String),
    status: r4bvaluesets.Publicationstatus,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    keyword: List(Coding),
    fhir_version: Option(r4bvaluesets.Fhirversion),
    mapping: List(StructuredefinitionMapping),
    kind: r4bvaluesets.Structuredefinitionkind,
    abstract: Bool,
    context: List(StructuredefinitionContext),
    context_invariant: List(String),
    type_: String,
    base_definition: Option(String),
    derivation: Option(r4bvaluesets.Typederivationrule),
    snapshot: Option(StructuredefinitionSnapshot),
    differential: Option(StructuredefinitionDifferential),
  )
}

pub fn structuredefinition_new(
  type_,
  abstract,
  kind,
  status,
  name,
  url,
) -> Structuredefinition {
  Structuredefinition(
    differential: None,
    snapshot: None,
    derivation: None,
    base_definition: None,
    type_:,
    context_invariant: [],
    context: [],
    abstract:,
    kind:,
    mapping: [],
    fhir_version: None,
    keyword: [],
    copyright: None,
    purpose: None,
    jurisdiction: [],
    use_context: [],
    description: None,
    contact: [],
    publisher: None,
    date: None,
    experimental: None,
    status:,
    title: None,
    name:,
    version: None,
    identifier: [],
    url:,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/StructureDefinition#resource
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

pub fn structuredefinition_mapping_new(identity) -> StructuredefinitionMapping {
  StructuredefinitionMapping(
    comment: None,
    name: None,
    uri: None,
    identity:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/StructureDefinition#resource
pub type StructuredefinitionContext {
  StructuredefinitionContext(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r4bvaluesets.Extensioncontexttype,
    expression: String,
  )
}

pub fn structuredefinition_context_new(
  expression,
  type_,
) -> StructuredefinitionContext {
  StructuredefinitionContext(
    expression:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/StructureDefinition#resource
pub type StructuredefinitionSnapshot {
  StructuredefinitionSnapshot(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    element: List(Elementdefinition),
  )
}

pub fn structuredefinition_snapshot_new() -> StructuredefinitionSnapshot {
  StructuredefinitionSnapshot(
    element: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/StructureDefinition#resource
pub type StructuredefinitionDifferential {
  StructuredefinitionDifferential(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    element: List(Elementdefinition),
  )
}

pub fn structuredefinition_differential_new() -> StructuredefinitionDifferential {
  StructuredefinitionDifferential(
    element: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/StructureMap#resource
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
    name: String,
    title: Option(String),
    status: r4bvaluesets.Publicationstatus,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    structure: List(StructuremapStructure),
    import_: List(String),
    group: List(StructuremapGroup),
  )
}

pub fn structuremap_new(status, name, url) -> Structuremap {
  Structuremap(
    group: [],
    import_: [],
    structure: [],
    copyright: None,
    purpose: None,
    jurisdiction: [],
    use_context: [],
    description: None,
    contact: [],
    publisher: None,
    date: None,
    experimental: None,
    status:,
    title: None,
    name:,
    version: None,
    identifier: [],
    url:,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/StructureMap#resource
pub type StructuremapStructure {
  StructuremapStructure(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: String,
    mode: r4bvaluesets.Mapmodelmode,
    alias: Option(String),
    documentation: Option(String),
  )
}

pub fn structuremap_structure_new(mode, url) -> StructuremapStructure {
  StructuremapStructure(
    documentation: None,
    alias: None,
    mode:,
    url:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/StructureMap#resource
pub type StructuremapGroup {
  StructuremapGroup(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    extends: Option(String),
    type_mode: r4bvaluesets.Mapgrouptypemode,
    documentation: Option(String),
    input: List(StructuremapGroupInput),
    rule: List(StructuremapGroupRule),
  )
}

pub fn structuremap_group_new(type_mode, name) -> StructuremapGroup {
  StructuremapGroup(
    rule: [],
    input: [],
    documentation: None,
    type_mode:,
    extends: None,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/StructureMap#resource
pub type StructuremapGroupInput {
  StructuremapGroupInput(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    type_: Option(String),
    mode: r4bvaluesets.Mapinputmode,
    documentation: Option(String),
  )
}

pub fn structuremap_group_input_new(mode, name) -> StructuremapGroupInput {
  StructuremapGroupInput(
    documentation: None,
    mode:,
    type_: None,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/StructureMap#resource
pub type StructuremapGroupRule {
  StructuremapGroupRule(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    source: List(StructuremapGroupRuleSource),
    target: List(StructuremapGroupRuleTarget),
    rule: List(Nil),
    dependent: List(StructuremapGroupRuleDependent),
    documentation: Option(String),
  )
}

pub fn structuremap_group_rule_new(name) -> StructuremapGroupRule {
  StructuremapGroupRule(
    documentation: None,
    dependent: [],
    rule: [],
    target: [],
    source: [],
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/StructureMap#resource
pub type StructuremapGroupRuleSource {
  StructuremapGroupRuleSource(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    context: String,
    min: Option(Int),
    max: Option(String),
    type_: Option(String),
    default_value: Option(StructuremapGroupRuleSourceDefaultvalue),
    element: Option(String),
    list_mode: Option(r4bvaluesets.Mapsourcelistmode),
    variable: Option(String),
    condition: Option(String),
    check: Option(String),
    log_message: Option(String),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/StructureMap#resource
pub type StructuremapGroupRuleSourceDefaultvalue {
  StructuremapGroupRuleSourceDefaultvalueBase64binary(default_value: String)
  StructuremapGroupRuleSourceDefaultvalueBoolean(default_value: Bool)
  StructuremapGroupRuleSourceDefaultvalueCanonical(default_value: String)
  StructuremapGroupRuleSourceDefaultvalueCode(default_value: String)
  StructuremapGroupRuleSourceDefaultvalueDate(default_value: String)
  StructuremapGroupRuleSourceDefaultvalueDatetime(default_value: String)
  StructuremapGroupRuleSourceDefaultvalueDecimal(default_value: Float)
  StructuremapGroupRuleSourceDefaultvalueId(default_value: String)
  StructuremapGroupRuleSourceDefaultvalueInstant(default_value: String)
  StructuremapGroupRuleSourceDefaultvalueInteger(default_value: Int)
  StructuremapGroupRuleSourceDefaultvalueMarkdown(default_value: String)
  StructuremapGroupRuleSourceDefaultvalueOid(default_value: String)
  StructuremapGroupRuleSourceDefaultvaluePositiveint(default_value: Int)
  StructuremapGroupRuleSourceDefaultvalueString(default_value: String)
  StructuremapGroupRuleSourceDefaultvalueTime(default_value: String)
  StructuremapGroupRuleSourceDefaultvalueUnsignedint(default_value: Int)
  StructuremapGroupRuleSourceDefaultvalueUri(default_value: String)
  StructuremapGroupRuleSourceDefaultvalueUrl(default_value: String)
  StructuremapGroupRuleSourceDefaultvalueUuid(default_value: String)
  StructuremapGroupRuleSourceDefaultvalueAddress(default_value: Address)
  StructuremapGroupRuleSourceDefaultvalueAge(default_value: Age)
  StructuremapGroupRuleSourceDefaultvalueAnnotation(default_value: Annotation)
  StructuremapGroupRuleSourceDefaultvalueAttachment(default_value: Attachment)
  StructuremapGroupRuleSourceDefaultvalueCodeableconcept(
    default_value: Codeableconcept,
  )
  StructuremapGroupRuleSourceDefaultvalueCoding(default_value: Coding)
  StructuremapGroupRuleSourceDefaultvalueContactpoint(
    default_value: Contactpoint,
  )
  StructuremapGroupRuleSourceDefaultvalueCount(default_value: Count)
  StructuremapGroupRuleSourceDefaultvalueDistance(default_value: Distance)
  StructuremapGroupRuleSourceDefaultvalueDuration(default_value: Duration)
  StructuremapGroupRuleSourceDefaultvalueHumanname(default_value: Humanname)
  StructuremapGroupRuleSourceDefaultvalueIdentifier(default_value: Identifier)
  StructuremapGroupRuleSourceDefaultvalueMoney(default_value: Money)
  StructuremapGroupRuleSourceDefaultvaluePeriod(default_value: Period)
  StructuremapGroupRuleSourceDefaultvalueQuantity(default_value: Quantity)
  StructuremapGroupRuleSourceDefaultvalueRange(default_value: Range)
  StructuremapGroupRuleSourceDefaultvalueRatio(default_value: Ratio)
  StructuremapGroupRuleSourceDefaultvalueReference(default_value: Reference)
  StructuremapGroupRuleSourceDefaultvalueSampleddata(default_value: Sampleddata)
  StructuremapGroupRuleSourceDefaultvalueSignature(default_value: Signature)
  StructuremapGroupRuleSourceDefaultvalueTiming(default_value: Timing)
  StructuremapGroupRuleSourceDefaultvalueContactdetail(
    default_value: Contactdetail,
  )
  StructuremapGroupRuleSourceDefaultvalueContributor(default_value: Contributor)
  StructuremapGroupRuleSourceDefaultvalueDatarequirement(
    default_value: Datarequirement,
  )
  StructuremapGroupRuleSourceDefaultvalueExpression(default_value: Expression)
  StructuremapGroupRuleSourceDefaultvalueParameterdefinition(
    default_value: Parameterdefinition,
  )
  StructuremapGroupRuleSourceDefaultvalueRelatedartifact(
    default_value: Relatedartifact,
  )
  StructuremapGroupRuleSourceDefaultvalueTriggerdefinition(
    default_value: Triggerdefinition,
  )
  StructuremapGroupRuleSourceDefaultvalueUsagecontext(
    default_value: Usagecontext,
  )
  StructuremapGroupRuleSourceDefaultvalueDosage(default_value: Dosage)
  StructuremapGroupRuleSourceDefaultvalueMeta(default_value: Meta)
}

pub fn structuremap_group_rule_source_new(
  context,
) -> StructuremapGroupRuleSource {
  StructuremapGroupRuleSource(
    log_message: None,
    check: None,
    condition: None,
    variable: None,
    list_mode: None,
    element: None,
    default_value: None,
    type_: None,
    max: None,
    min: None,
    context:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/StructureMap#resource
pub type StructuremapGroupRuleTarget {
  StructuremapGroupRuleTarget(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    context: Option(String),
    context_type: Option(r4bvaluesets.Mapcontexttype),
    element: Option(String),
    variable: Option(String),
    list_mode: List(r4bvaluesets.Maptargetlistmode),
    list_rule_id: Option(String),
    transform: Option(r4bvaluesets.Maptransform),
    parameter: List(StructuremapGroupRuleTargetParameter),
  )
}

pub fn structuremap_group_rule_target_new() -> StructuremapGroupRuleTarget {
  StructuremapGroupRuleTarget(
    parameter: [],
    transform: None,
    list_rule_id: None,
    list_mode: [],
    variable: None,
    element: None,
    context_type: None,
    context: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/StructureMap#resource
pub type StructuremapGroupRuleTargetParameter {
  StructuremapGroupRuleTargetParameter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    value: StructuremapGroupRuleTargetParameterValue,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/StructureMap#resource
pub type StructuremapGroupRuleTargetParameterValue {
  StructuremapGroupRuleTargetParameterValueId(value: String)
  StructuremapGroupRuleTargetParameterValueString(value: String)
  StructuremapGroupRuleTargetParameterValueBoolean(value: Bool)
  StructuremapGroupRuleTargetParameterValueInteger(value: Int)
  StructuremapGroupRuleTargetParameterValueDecimal(value: Float)
}

pub fn structuremap_group_rule_target_parameter_new(
  value,
) -> StructuremapGroupRuleTargetParameter {
  StructuremapGroupRuleTargetParameter(
    value:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/StructureMap#resource
pub type StructuremapGroupRuleDependent {
  StructuremapGroupRuleDependent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    variable: List(String),
  )
}

pub fn structuremap_group_rule_dependent_new(
  name,
) -> StructuremapGroupRuleDependent {
  StructuremapGroupRuleDependent(
    variable: [],
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Subscription#resource
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
    status: r4bvaluesets.Subscriptionstatus,
    contact: List(Contactpoint),
    end: Option(String),
    reason: String,
    criteria: String,
    error: Option(String),
    channel: SubscriptionChannel,
  )
}

pub fn subscription_new(channel, criteria, reason, status) -> Subscription {
  Subscription(
    channel:,
    error: None,
    criteria:,
    reason:,
    end: None,
    contact: [],
    status:,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Subscription#resource
pub type SubscriptionChannel {
  SubscriptionChannel(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r4bvaluesets.Subscriptionchanneltype,
    endpoint: Option(String),
    payload: Option(String),
    header: List(String),
  )
}

pub fn subscription_channel_new(type_) -> SubscriptionChannel {
  SubscriptionChannel(
    header: [],
    payload: None,
    endpoint: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SubscriptionStatus#resource
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
    status: Option(r4bvaluesets.Subscriptionstatus),
    type_: r4bvaluesets.Subscriptionnotificationtype,
    events_since_subscription_start: Option(String),
    notification_event: List(SubscriptionstatusNotificationevent),
    subscription: Reference,
    topic: Option(String),
    error: List(Codeableconcept),
  )
}

pub fn subscriptionstatus_new(subscription, type_) -> Subscriptionstatus {
  Subscriptionstatus(
    error: [],
    topic: None,
    subscription:,
    notification_event: [],
    events_since_subscription_start: None,
    type_:,
    status: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SubscriptionStatus#resource
pub type SubscriptionstatusNotificationevent {
  SubscriptionstatusNotificationevent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    event_number: String,
    timestamp: Option(String),
    focus: Option(Reference),
    additional_context: List(Reference),
  )
}

pub fn subscriptionstatus_notificationevent_new(
  event_number,
) -> SubscriptionstatusNotificationevent {
  SubscriptionstatusNotificationevent(
    additional_context: [],
    focus: None,
    timestamp: None,
    event_number:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SubscriptionTopic#resource
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
    title: Option(String),
    derived_from: List(String),
    status: r4bvaluesets.Publicationstatus,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    approval_date: Option(String),
    last_review_date: Option(String),
    effective_period: Option(Period),
    resource_trigger: List(SubscriptiontopicResourcetrigger),
    event_trigger: List(SubscriptiontopicEventtrigger),
    can_filter_by: List(SubscriptiontopicCanfilterby),
    notification_shape: List(SubscriptiontopicNotificationshape),
  )
}

pub fn subscriptiontopic_new(status, url) -> Subscriptiontopic {
  Subscriptiontopic(
    notification_shape: [],
    can_filter_by: [],
    event_trigger: [],
    resource_trigger: [],
    effective_period: None,
    last_review_date: None,
    approval_date: None,
    copyright: None,
    purpose: None,
    jurisdiction: [],
    use_context: [],
    description: None,
    contact: [],
    publisher: None,
    date: None,
    experimental: None,
    status:,
    derived_from: [],
    title: None,
    version: None,
    identifier: [],
    url:,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SubscriptionTopic#resource
pub type SubscriptiontopicResourcetrigger {
  SubscriptiontopicResourcetrigger(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    resource: String,
    supported_interaction: List(r4bvaluesets.Interactiontrigger),
    query_criteria: Option(SubscriptiontopicResourcetriggerQuerycriteria),
    fhir_path_criteria: Option(String),
  )
}

pub fn subscriptiontopic_resourcetrigger_new(
  resource,
) -> SubscriptiontopicResourcetrigger {
  SubscriptiontopicResourcetrigger(
    fhir_path_criteria: None,
    query_criteria: None,
    supported_interaction: [],
    resource:,
    description: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SubscriptionTopic#resource
pub type SubscriptiontopicResourcetriggerQuerycriteria {
  SubscriptiontopicResourcetriggerQuerycriteria(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    previous: Option(String),
    result_for_create: Option(r4bvaluesets.Subscriptiontopiccrbehavior),
    current: Option(String),
    result_for_delete: Option(r4bvaluesets.Subscriptiontopiccrbehavior),
    require_both: Option(Bool),
  )
}

pub fn subscriptiontopic_resourcetrigger_querycriteria_new() -> SubscriptiontopicResourcetriggerQuerycriteria {
  SubscriptiontopicResourcetriggerQuerycriteria(
    require_both: None,
    result_for_delete: None,
    current: None,
    result_for_create: None,
    previous: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SubscriptionTopic#resource
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

pub fn subscriptiontopic_eventtrigger_new(
  resource,
  event,
) -> SubscriptiontopicEventtrigger {
  SubscriptiontopicEventtrigger(
    resource:,
    event:,
    description: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SubscriptionTopic#resource
pub type SubscriptiontopicCanfilterby {
  SubscriptiontopicCanfilterby(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    resource: Option(String),
    filter_parameter: String,
    filter_definition: Option(String),
    modifier: List(r4bvaluesets.Subscriptionsearchmodifier),
  )
}

pub fn subscriptiontopic_canfilterby_new(
  filter_parameter,
) -> SubscriptiontopicCanfilterby {
  SubscriptiontopicCanfilterby(
    modifier: [],
    filter_definition: None,
    filter_parameter:,
    resource: None,
    description: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SubscriptionTopic#resource
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

pub fn subscriptiontopic_notificationshape_new(
  resource,
) -> SubscriptiontopicNotificationshape {
  SubscriptiontopicNotificationshape(
    rev_include: [],
    include: [],
    resource:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Substance#resource
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
    status: Option(r4bvaluesets.Substancestatus),
    category: List(Codeableconcept),
    code: Codeableconcept,
    description: Option(String),
    instance: List(SubstanceInstance),
    ingredient: List(SubstanceIngredient),
  )
}

pub fn substance_new(code) -> Substance {
  Substance(
    ingredient: [],
    instance: [],
    description: None,
    code:,
    category: [],
    status: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Substance#resource
pub type SubstanceInstance {
  SubstanceInstance(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Option(Identifier),
    expiry: Option(String),
    quantity: Option(Quantity),
  )
}

pub fn substance_instance_new() -> SubstanceInstance {
  SubstanceInstance(
    quantity: None,
    expiry: None,
    identifier: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Substance#resource
pub type SubstanceIngredient {
  SubstanceIngredient(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    quantity: Option(Ratio),
    substance: SubstanceIngredientSubstance,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Substance#resource
pub type SubstanceIngredientSubstance {
  SubstanceIngredientSubstanceCodeableconcept(substance: Codeableconcept)
  SubstanceIngredientSubstanceReference(substance: Reference)
}

pub fn substance_ingredient_new(substance) -> SubstanceIngredient {
  SubstanceIngredient(
    substance:,
    quantity: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SubstanceDefinition#resource
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
    property: List(SubstancedefinitionProperty),
    molecular_weight: List(SubstancedefinitionMolecularweight),
    structure: Option(SubstancedefinitionStructure),
    code: List(SubstancedefinitionCode),
    name: List(SubstancedefinitionName),
    relationship: List(SubstancedefinitionRelationship),
    source_material: Option(SubstancedefinitionSourcematerial),
  )
}

pub fn substancedefinition_new() -> Substancedefinition {
  Substancedefinition(
    source_material: None,
    relationship: [],
    name: [],
    code: [],
    structure: None,
    molecular_weight: [],
    property: [],
    moiety: [],
    supplier: [],
    manufacturer: [],
    note: [],
    information_source: [],
    description: None,
    grade: [],
    domain: None,
    classification: [],
    status: None,
    version: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SubstanceDefinition#resource
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

///http://hl7.org/fhir/r4b/StructureDefinition/SubstanceDefinition#resource
pub type SubstancedefinitionMoietyAmount {
  SubstancedefinitionMoietyAmountQuantity(amount: Quantity)
  SubstancedefinitionMoietyAmountString(amount: String)
}

pub fn substancedefinition_moiety_new() -> SubstancedefinitionMoiety {
  SubstancedefinitionMoiety(
    measurement_type: None,
    amount: None,
    molecular_formula: None,
    optical_activity: None,
    stereochemistry: None,
    name: None,
    identifier: None,
    role: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SubstanceDefinition#resource
pub type SubstancedefinitionProperty {
  SubstancedefinitionProperty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value: Option(SubstancedefinitionPropertyValue),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SubstanceDefinition#resource
pub type SubstancedefinitionPropertyValue {
  SubstancedefinitionPropertyValueCodeableconcept(value: Codeableconcept)
  SubstancedefinitionPropertyValueQuantity(value: Quantity)
  SubstancedefinitionPropertyValueDate(value: String)
  SubstancedefinitionPropertyValueBoolean(value: Bool)
  SubstancedefinitionPropertyValueAttachment(value: Attachment)
}

pub fn substancedefinition_property_new(type_) -> SubstancedefinitionProperty {
  SubstancedefinitionProperty(
    value: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SubstanceDefinition#resource
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

pub fn substancedefinition_molecularweight_new(
  amount,
) -> SubstancedefinitionMolecularweight {
  SubstancedefinitionMolecularweight(
    amount:,
    type_: None,
    method: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SubstanceDefinition#resource
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

pub fn substancedefinition_structure_new() -> SubstancedefinitionStructure {
  SubstancedefinitionStructure(
    representation: [],
    source_document: [],
    technique: [],
    molecular_weight: None,
    molecular_formula_by_moiety: None,
    molecular_formula: None,
    optical_activity: None,
    stereochemistry: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SubstanceDefinition#resource
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

pub fn substancedefinition_structure_representation_new() -> SubstancedefinitionStructureRepresentation {
  SubstancedefinitionStructureRepresentation(
    document: None,
    format: None,
    representation: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SubstanceDefinition#resource
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

pub fn substancedefinition_code_new() -> SubstancedefinitionCode {
  SubstancedefinitionCode(
    source: [],
    note: [],
    status_date: None,
    status: None,
    code: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SubstanceDefinition#resource
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

pub fn substancedefinition_name_new(name) -> SubstancedefinitionName {
  SubstancedefinitionName(
    source: [],
    official: [],
    translation: [],
    synonym: [],
    jurisdiction: [],
    domain: [],
    language: [],
    preferred: None,
    status: None,
    type_: None,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SubstanceDefinition#resource
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

pub fn substancedefinition_name_official_new() -> SubstancedefinitionNameOfficial {
  SubstancedefinitionNameOfficial(
    date: None,
    status: None,
    authority: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SubstanceDefinition#resource
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

///http://hl7.org/fhir/r4b/StructureDefinition/SubstanceDefinition#resource
pub type SubstancedefinitionRelationshipSubstancedefinition {
  SubstancedefinitionRelationshipSubstancedefinitionReference(
    substance_definition: Reference,
  )
  SubstancedefinitionRelationshipSubstancedefinitionCodeableconcept(
    substance_definition: Codeableconcept,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SubstanceDefinition#resource
pub type SubstancedefinitionRelationshipAmount {
  SubstancedefinitionRelationshipAmountQuantity(amount: Quantity)
  SubstancedefinitionRelationshipAmountRatio(amount: Ratio)
  SubstancedefinitionRelationshipAmountString(amount: String)
}

pub fn substancedefinition_relationship_new(
  type_,
) -> SubstancedefinitionRelationship {
  SubstancedefinitionRelationship(
    source: [],
    comparator: None,
    ratio_high_limit_amount: None,
    amount: None,
    is_defining: None,
    type_:,
    substance_definition: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SubstanceDefinition#resource
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

pub fn substancedefinition_sourcematerial_new() -> SubstancedefinitionSourcematerial {
  SubstancedefinitionSourcematerial(
    country_of_origin: [],
    part: None,
    species: None,
    genus: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SupplyDelivery#resource
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
    status: Option(r4bvaluesets.Supplydeliverystatus),
    patient: Option(Reference),
    type_: Option(Codeableconcept),
    supplied_item: Option(SupplydeliverySupplieditem),
    occurrence: Option(SupplydeliveryOccurrence),
    supplier: Option(Reference),
    destination: Option(Reference),
    receiver: List(Reference),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SupplyDelivery#resource
pub type SupplydeliveryOccurrence {
  SupplydeliveryOccurrenceDatetime(occurrence: String)
  SupplydeliveryOccurrencePeriod(occurrence: Period)
  SupplydeliveryOccurrenceTiming(occurrence: Timing)
}

pub fn supplydelivery_new() -> Supplydelivery {
  Supplydelivery(
    receiver: [],
    destination: None,
    supplier: None,
    occurrence: None,
    supplied_item: None,
    type_: None,
    patient: None,
    status: None,
    part_of: [],
    based_on: [],
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SupplyDelivery#resource
pub type SupplydeliverySupplieditem {
  SupplydeliverySupplieditem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    quantity: Option(Quantity),
    item: Option(SupplydeliverySupplieditemItem),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SupplyDelivery#resource
pub type SupplydeliverySupplieditemItem {
  SupplydeliverySupplieditemItemCodeableconcept(item: Codeableconcept)
  SupplydeliverySupplieditemItemReference(item: Reference)
}

pub fn supplydelivery_supplieditem_new() -> SupplydeliverySupplieditem {
  SupplydeliverySupplieditem(
    item: None,
    quantity: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SupplyRequest#resource
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
    status: Option(r4bvaluesets.Supplyrequeststatus),
    category: Option(Codeableconcept),
    priority: Option(r4bvaluesets.Requestpriority),
    item: SupplyrequestItem,
    quantity: Quantity,
    parameter: List(SupplyrequestParameter),
    occurrence: Option(SupplyrequestOccurrence),
    authored_on: Option(String),
    requester: Option(Reference),
    supplier: List(Reference),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    deliver_from: Option(Reference),
    deliver_to: Option(Reference),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SupplyRequest#resource
pub type SupplyrequestItem {
  SupplyrequestItemCodeableconcept(item: Codeableconcept)
  SupplyrequestItemReference(item: Reference)
}

///http://hl7.org/fhir/r4b/StructureDefinition/SupplyRequest#resource
pub type SupplyrequestOccurrence {
  SupplyrequestOccurrenceDatetime(occurrence: String)
  SupplyrequestOccurrencePeriod(occurrence: Period)
  SupplyrequestOccurrenceTiming(occurrence: Timing)
}

pub fn supplyrequest_new(quantity, item) -> Supplyrequest {
  Supplyrequest(
    deliver_to: None,
    deliver_from: None,
    reason_reference: [],
    reason_code: [],
    supplier: [],
    requester: None,
    authored_on: None,
    occurrence: None,
    parameter: [],
    quantity:,
    item:,
    priority: None,
    category: None,
    status: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SupplyRequest#resource
pub type SupplyrequestParameter {
  SupplyrequestParameter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(Codeableconcept),
    value: Option(SupplyrequestParameterValue),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/SupplyRequest#resource
pub type SupplyrequestParameterValue {
  SupplyrequestParameterValueCodeableconcept(value: Codeableconcept)
  SupplyrequestParameterValueQuantity(value: Quantity)
  SupplyrequestParameterValueRange(value: Range)
  SupplyrequestParameterValueBoolean(value: Bool)
}

pub fn supplyrequest_parameter_new() -> SupplyrequestParameter {
  SupplyrequestParameter(
    value: None,
    code: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Task#resource
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
    status: r4bvaluesets.Taskstatus,
    status_reason: Option(Codeableconcept),
    business_status: Option(Codeableconcept),
    intent: r4bvaluesets.Taskintent,
    priority: Option(r4bvaluesets.Requestpriority),
    code: Option(Codeableconcept),
    description: Option(String),
    focus: Option(Reference),
    for: Option(Reference),
    encounter: Option(Reference),
    execution_period: Option(Period),
    authored_on: Option(String),
    last_modified: Option(String),
    requester: Option(Reference),
    performer_type: List(Codeableconcept),
    owner: Option(Reference),
    location: Option(Reference),
    reason_code: Option(Codeableconcept),
    reason_reference: Option(Reference),
    insurance: List(Reference),
    note: List(Annotation),
    relevant_history: List(Reference),
    restriction: Option(TaskRestriction),
    input: List(TaskInput),
    output: List(TaskOutput),
  )
}

pub fn task_new(intent, status) -> Task {
  Task(
    output: [],
    input: [],
    restriction: None,
    relevant_history: [],
    note: [],
    insurance: [],
    reason_reference: None,
    reason_code: None,
    location: None,
    owner: None,
    performer_type: [],
    requester: None,
    last_modified: None,
    authored_on: None,
    execution_period: None,
    encounter: None,
    for: None,
    focus: None,
    description: None,
    code: None,
    priority: None,
    intent:,
    business_status: None,
    status_reason: None,
    status:,
    part_of: [],
    group_identifier: None,
    based_on: [],
    instantiates_uri: None,
    instantiates_canonical: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Task#resource
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

pub fn task_restriction_new() -> TaskRestriction {
  TaskRestriction(
    recipient: [],
    period: None,
    repetitions: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Task#resource
pub type TaskInput {
  TaskInput(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value: TaskInputValue,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Task#resource
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
  TaskInputValueReference(value: Reference)
  TaskInputValueSampleddata(value: Sampleddata)
  TaskInputValueSignature(value: Signature)
  TaskInputValueTiming(value: Timing)
  TaskInputValueContactdetail(value: Contactdetail)
  TaskInputValueContributor(value: Contributor)
  TaskInputValueDatarequirement(value: Datarequirement)
  TaskInputValueExpression(value: Expression)
  TaskInputValueParameterdefinition(value: Parameterdefinition)
  TaskInputValueRelatedartifact(value: Relatedartifact)
  TaskInputValueTriggerdefinition(value: Triggerdefinition)
  TaskInputValueUsagecontext(value: Usagecontext)
  TaskInputValueDosage(value: Dosage)
  TaskInputValueMeta(value: Meta)
}

pub fn task_input_new(value, type_) -> TaskInput {
  TaskInput(value:, type_:, modifier_extension: [], extension: [], id: None)
}

///http://hl7.org/fhir/r4b/StructureDefinition/Task#resource
pub type TaskOutput {
  TaskOutput(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value: TaskOutputValue,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/Task#resource
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
  TaskOutputValueReference(value: Reference)
  TaskOutputValueSampleddata(value: Sampleddata)
  TaskOutputValueSignature(value: Signature)
  TaskOutputValueTiming(value: Timing)
  TaskOutputValueContactdetail(value: Contactdetail)
  TaskOutputValueContributor(value: Contributor)
  TaskOutputValueDatarequirement(value: Datarequirement)
  TaskOutputValueExpression(value: Expression)
  TaskOutputValueParameterdefinition(value: Parameterdefinition)
  TaskOutputValueRelatedartifact(value: Relatedartifact)
  TaskOutputValueTriggerdefinition(value: Triggerdefinition)
  TaskOutputValueUsagecontext(value: Usagecontext)
  TaskOutputValueDosage(value: Dosage)
  TaskOutputValueMeta(value: Meta)
}

pub fn task_output_new(value, type_) -> TaskOutput {
  TaskOutput(value:, type_:, modifier_extension: [], extension: [], id: None)
}

///http://hl7.org/fhir/r4b/StructureDefinition/TerminologyCapabilities#resource
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
    version: Option(String),
    name: Option(String),
    title: Option(String),
    status: r4bvaluesets.Publicationstatus,
    experimental: Option(Bool),
    date: String,
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    kind: r4bvaluesets.Capabilitystatementkind,
    software: Option(TerminologycapabilitiesSoftware),
    implementation: Option(TerminologycapabilitiesImplementation),
    locked_date: Option(Bool),
    code_system: List(TerminologycapabilitiesCodesystem),
    expansion: Option(TerminologycapabilitiesExpansion),
    code_search: Option(r4bvaluesets.Codesearchsupport),
    validate_code: Option(TerminologycapabilitiesValidatecode),
    translation: Option(TerminologycapabilitiesTranslation),
    closure: Option(TerminologycapabilitiesClosure),
  )
}

pub fn terminologycapabilities_new(
  kind,
  date,
  status,
) -> Terminologycapabilities {
  Terminologycapabilities(
    closure: None,
    translation: None,
    validate_code: None,
    code_search: None,
    expansion: None,
    code_system: [],
    locked_date: None,
    implementation: None,
    software: None,
    kind:,
    copyright: None,
    purpose: None,
    jurisdiction: [],
    use_context: [],
    description: None,
    contact: [],
    publisher: None,
    date:,
    experimental: None,
    status:,
    title: None,
    name: None,
    version: None,
    url: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TerminologyCapabilities#resource
pub type TerminologycapabilitiesSoftware {
  TerminologycapabilitiesSoftware(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    version: Option(String),
  )
}

pub fn terminologycapabilities_software_new(
  name,
) -> TerminologycapabilitiesSoftware {
  TerminologycapabilitiesSoftware(
    version: None,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TerminologyCapabilities#resource
pub type TerminologycapabilitiesImplementation {
  TerminologycapabilitiesImplementation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: String,
    url: Option(String),
  )
}

pub fn terminologycapabilities_implementation_new(
  description,
) -> TerminologycapabilitiesImplementation {
  TerminologycapabilitiesImplementation(
    url: None,
    description:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TerminologyCapabilities#resource
pub type TerminologycapabilitiesCodesystem {
  TerminologycapabilitiesCodesystem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    uri: Option(String),
    version: List(TerminologycapabilitiesCodesystemVersion),
    subsumption: Option(Bool),
  )
}

pub fn terminologycapabilities_codesystem_new() -> TerminologycapabilitiesCodesystem {
  TerminologycapabilitiesCodesystem(
    subsumption: None,
    version: [],
    uri: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TerminologyCapabilities#resource
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

pub fn terminologycapabilities_codesystem_version_new() -> TerminologycapabilitiesCodesystemVersion {
  TerminologycapabilitiesCodesystemVersion(
    property: [],
    filter: [],
    language: [],
    compositional: None,
    is_default: None,
    code: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TerminologyCapabilities#resource
pub type TerminologycapabilitiesCodesystemVersionFilter {
  TerminologycapabilitiesCodesystemVersionFilter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    op: List(String),
  )
}

pub fn terminologycapabilities_codesystem_version_filter_new(
  code,
) -> TerminologycapabilitiesCodesystemVersionFilter {
  TerminologycapabilitiesCodesystemVersionFilter(
    op: [],
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TerminologyCapabilities#resource
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

pub fn terminologycapabilities_expansion_new() -> TerminologycapabilitiesExpansion {
  TerminologycapabilitiesExpansion(
    text_filter: None,
    parameter: [],
    incomplete: None,
    paging: None,
    hierarchical: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TerminologyCapabilities#resource
pub type TerminologycapabilitiesExpansionParameter {
  TerminologycapabilitiesExpansionParameter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    documentation: Option(String),
  )
}

pub fn terminologycapabilities_expansion_parameter_new(
  name,
) -> TerminologycapabilitiesExpansionParameter {
  TerminologycapabilitiesExpansionParameter(
    documentation: None,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TerminologyCapabilities#resource
pub type TerminologycapabilitiesValidatecode {
  TerminologycapabilitiesValidatecode(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    translations: Bool,
  )
}

pub fn terminologycapabilities_validatecode_new(
  translations,
) -> TerminologycapabilitiesValidatecode {
  TerminologycapabilitiesValidatecode(
    translations:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TerminologyCapabilities#resource
pub type TerminologycapabilitiesTranslation {
  TerminologycapabilitiesTranslation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    needs_map: Bool,
  )
}

pub fn terminologycapabilities_translation_new(
  needs_map,
) -> TerminologycapabilitiesTranslation {
  TerminologycapabilitiesTranslation(
    needs_map:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TerminologyCapabilities#resource
pub type TerminologycapabilitiesClosure {
  TerminologycapabilitiesClosure(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    translation: Option(Bool),
  )
}

pub fn terminologycapabilities_closure_new() -> TerminologycapabilitiesClosure {
  TerminologycapabilitiesClosure(
    translation: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TestReport#resource
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
    status: r4bvaluesets.Reportstatuscodes,
    test_script: Reference,
    result: r4bvaluesets.Reportresultcodes,
    score: Option(Float),
    tester: Option(String),
    issued: Option(String),
    participant: List(TestreportParticipant),
    setup: Option(TestreportSetup),
    test_: List(TestreportTest),
    teardown: Option(TestreportTeardown),
  )
}

pub fn testreport_new(result, test_script, status) -> Testreport {
  Testreport(
    teardown: None,
    test_: [],
    setup: None,
    participant: [],
    issued: None,
    tester: None,
    score: None,
    result:,
    test_script:,
    status:,
    name: None,
    identifier: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TestReport#resource
pub type TestreportParticipant {
  TestreportParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r4bvaluesets.Reportparticipanttype,
    uri: String,
    display: Option(String),
  )
}

pub fn testreport_participant_new(uri, type_) -> TestreportParticipant {
  TestreportParticipant(
    display: None,
    uri:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TestReport#resource
pub type TestreportSetup {
  TestreportSetup(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    action: List(TestreportSetupAction),
  )
}

pub fn testreport_setup_new() -> TestreportSetup {
  TestreportSetup(action: [], modifier_extension: [], extension: [], id: None)
}

///http://hl7.org/fhir/r4b/StructureDefinition/TestReport#resource
pub type TestreportSetupAction {
  TestreportSetupAction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    operation: Option(TestreportSetupActionOperation),
    assert_: Option(TestreportSetupActionAssert),
  )
}

pub fn testreport_setup_action_new() -> TestreportSetupAction {
  TestreportSetupAction(
    assert_: None,
    operation: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TestReport#resource
pub type TestreportSetupActionOperation {
  TestreportSetupActionOperation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    result: r4bvaluesets.Reportactionresultcodes,
    message: Option(String),
    detail: Option(String),
  )
}

pub fn testreport_setup_action_operation_new(
  result,
) -> TestreportSetupActionOperation {
  TestreportSetupActionOperation(
    detail: None,
    message: None,
    result:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TestReport#resource
pub type TestreportSetupActionAssert {
  TestreportSetupActionAssert(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    result: r4bvaluesets.Reportactionresultcodes,
    message: Option(String),
    detail: Option(String),
  )
}

pub fn testreport_setup_action_assert_new(result) -> TestreportSetupActionAssert {
  TestreportSetupActionAssert(
    detail: None,
    message: None,
    result:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TestReport#resource
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

pub fn testreport_test_new() -> TestreportTest {
  TestreportTest(
    action: [],
    description: None,
    name: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TestReport#resource
pub type TestreportTestAction {
  TestreportTestAction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    operation: Option(Nil),
    assert_: Option(Nil),
  )
}

pub fn testreport_test_action_new() -> TestreportTestAction {
  TestreportTestAction(
    assert_: None,
    operation: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TestReport#resource
pub type TestreportTeardown {
  TestreportTeardown(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    action: List(TestreportTeardownAction),
  )
}

pub fn testreport_teardown_new() -> TestreportTeardown {
  TestreportTeardown(
    action: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TestReport#resource
pub type TestreportTeardownAction {
  TestreportTeardownAction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    operation: Nil,
  )
}

pub fn testreport_teardown_action_new(operation) -> TestreportTeardownAction {
  TestreportTeardownAction(
    operation:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TestScript#resource
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
    url: String,
    identifier: Option(Identifier),
    version: Option(String),
    name: String,
    title: Option(String),
    status: r4bvaluesets.Publicationstatus,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    origin: List(TestscriptOrigin),
    destination: List(TestscriptDestination),
    metadata: Option(TestscriptMetadata),
    fixture: List(TestscriptFixture),
    profile: List(Reference),
    variable: List(TestscriptVariable),
    setup: Option(TestscriptSetup),
    test_: List(TestscriptTest),
    teardown: Option(TestscriptTeardown),
  )
}

pub fn testscript_new(status, name, url) -> Testscript {
  Testscript(
    teardown: None,
    test_: [],
    setup: None,
    variable: [],
    profile: [],
    fixture: [],
    metadata: None,
    destination: [],
    origin: [],
    copyright: None,
    purpose: None,
    jurisdiction: [],
    use_context: [],
    description: None,
    contact: [],
    publisher: None,
    date: None,
    experimental: None,
    status:,
    title: None,
    name:,
    version: None,
    identifier: None,
    url:,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TestScript#resource
pub type TestscriptOrigin {
  TestscriptOrigin(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    index: Int,
    profile: Coding,
  )
}

pub fn testscript_origin_new(profile, index) -> TestscriptOrigin {
  TestscriptOrigin(
    profile:,
    index:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TestScript#resource
pub type TestscriptDestination {
  TestscriptDestination(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    index: Int,
    profile: Coding,
  )
}

pub fn testscript_destination_new(profile, index) -> TestscriptDestination {
  TestscriptDestination(
    profile:,
    index:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TestScript#resource
pub type TestscriptMetadata {
  TestscriptMetadata(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    link: List(TestscriptMetadataLink),
    capability: List(TestscriptMetadataCapability),
  )
}

pub fn testscript_metadata_new() -> TestscriptMetadata {
  TestscriptMetadata(
    capability: [],
    link: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TestScript#resource
pub type TestscriptMetadataLink {
  TestscriptMetadataLink(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: String,
    description: Option(String),
  )
}

pub fn testscript_metadata_link_new(url) -> TestscriptMetadataLink {
  TestscriptMetadataLink(
    description: None,
    url:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TestScript#resource
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

pub fn testscript_metadata_capability_new(
  capabilities,
  validated,
  required,
) -> TestscriptMetadataCapability {
  TestscriptMetadataCapability(
    capabilities:,
    link: [],
    destination: None,
    origin: [],
    description: None,
    validated:,
    required:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TestScript#resource
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

pub fn testscript_fixture_new(autodelete, autocreate) -> TestscriptFixture {
  TestscriptFixture(
    resource: None,
    autodelete:,
    autocreate:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TestScript#resource
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

pub fn testscript_variable_new(name) -> TestscriptVariable {
  TestscriptVariable(
    source_id: None,
    path: None,
    hint: None,
    header_field: None,
    expression: None,
    description: None,
    default_value: None,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TestScript#resource
pub type TestscriptSetup {
  TestscriptSetup(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    action: List(TestscriptSetupAction),
  )
}

pub fn testscript_setup_new() -> TestscriptSetup {
  TestscriptSetup(action: [], modifier_extension: [], extension: [], id: None)
}

///http://hl7.org/fhir/r4b/StructureDefinition/TestScript#resource
pub type TestscriptSetupAction {
  TestscriptSetupAction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    operation: Option(TestscriptSetupActionOperation),
    assert_: Option(TestscriptSetupActionAssert),
  )
}

pub fn testscript_setup_action_new() -> TestscriptSetupAction {
  TestscriptSetupAction(
    assert_: None,
    operation: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TestScript#resource
pub type TestscriptSetupActionOperation {
  TestscriptSetupActionOperation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Coding),
    resource: Option(r4bvaluesets.Definedtypes),
    label: Option(String),
    description: Option(String),
    accept: Option(String),
    content_type: Option(String),
    destination: Option(Int),
    encode_request_url: Bool,
    method: Option(r4bvaluesets.Httpoperations),
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

pub fn testscript_setup_action_operation_new(
  encode_request_url,
) -> TestscriptSetupActionOperation {
  TestscriptSetupActionOperation(
    url: None,
    target_id: None,
    source_id: None,
    response_id: None,
    request_id: None,
    request_header: [],
    params: None,
    origin: None,
    method: None,
    encode_request_url:,
    destination: None,
    content_type: None,
    accept: None,
    description: None,
    label: None,
    resource: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TestScript#resource
pub type TestscriptSetupActionOperationRequestheader {
  TestscriptSetupActionOperationRequestheader(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    field: String,
    value: String,
  )
}

pub fn testscript_setup_action_operation_requestheader_new(
  value,
  field,
) -> TestscriptSetupActionOperationRequestheader {
  TestscriptSetupActionOperationRequestheader(
    value:,
    field:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TestScript#resource
pub type TestscriptSetupActionAssert {
  TestscriptSetupActionAssert(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    label: Option(String),
    description: Option(String),
    direction: Option(r4bvaluesets.Assertdirectioncodes),
    compare_to_source_id: Option(String),
    compare_to_source_expression: Option(String),
    compare_to_source_path: Option(String),
    content_type: Option(String),
    expression: Option(String),
    header_field: Option(String),
    minimum_id: Option(String),
    navigation_links: Option(Bool),
    operator: Option(r4bvaluesets.Assertoperatorcodes),
    path: Option(String),
    request_method: Option(r4bvaluesets.Httpoperations),
    request_url: Option(String),
    resource: Option(r4bvaluesets.Definedtypes),
    response: Option(r4bvaluesets.Assertresponsecodetypes),
    response_code: Option(String),
    source_id: Option(String),
    validate_profile_id: Option(String),
    value: Option(String),
    warning_only: Bool,
  )
}

pub fn testscript_setup_action_assert_new(
  warning_only,
) -> TestscriptSetupActionAssert {
  TestscriptSetupActionAssert(
    warning_only:,
    value: None,
    validate_profile_id: None,
    source_id: None,
    response_code: None,
    response: None,
    resource: None,
    request_url: None,
    request_method: None,
    path: None,
    operator: None,
    navigation_links: None,
    minimum_id: None,
    header_field: None,
    expression: None,
    content_type: None,
    compare_to_source_path: None,
    compare_to_source_expression: None,
    compare_to_source_id: None,
    direction: None,
    description: None,
    label: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TestScript#resource
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

pub fn testscript_test_new() -> TestscriptTest {
  TestscriptTest(
    action: [],
    description: None,
    name: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TestScript#resource
pub type TestscriptTestAction {
  TestscriptTestAction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    operation: Option(Nil),
    assert_: Option(Nil),
  )
}

pub fn testscript_test_action_new() -> TestscriptTestAction {
  TestscriptTestAction(
    assert_: None,
    operation: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TestScript#resource
pub type TestscriptTeardown {
  TestscriptTeardown(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    action: List(TestscriptTeardownAction),
  )
}

pub fn testscript_teardown_new() -> TestscriptTeardown {
  TestscriptTeardown(
    action: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/TestScript#resource
pub type TestscriptTeardownAction {
  TestscriptTeardownAction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    operation: Nil,
  )
}

pub fn testscript_teardown_action_new(operation) -> TestscriptTeardownAction {
  TestscriptTeardownAction(
    operation:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ValueSet#resource
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
    name: Option(String),
    title: Option(String),
    status: r4bvaluesets.Publicationstatus,
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
    compose: Option(ValuesetCompose),
    expansion: Option(ValuesetExpansion),
  )
}

pub fn valueset_new(status) -> Valueset {
  Valueset(
    expansion: None,
    compose: None,
    copyright: None,
    purpose: None,
    immutable: None,
    jurisdiction: [],
    use_context: [],
    description: None,
    contact: [],
    publisher: None,
    date: None,
    experimental: None,
    status:,
    title: None,
    name: None,
    version: None,
    identifier: [],
    url: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ValueSet#resource
pub type ValuesetCompose {
  ValuesetCompose(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    locked_date: Option(String),
    inactive: Option(Bool),
    include: List(ValuesetComposeInclude),
    exclude: List(Nil),
  )
}

pub fn valueset_compose_new() -> ValuesetCompose {
  ValuesetCompose(
    exclude: [],
    include: [],
    inactive: None,
    locked_date: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ValueSet#resource
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
  )
}

pub fn valueset_compose_include_new() -> ValuesetComposeInclude {
  ValuesetComposeInclude(
    value_set: [],
    filter: [],
    concept: [],
    version: None,
    system: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ValueSet#resource
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

pub fn valueset_compose_include_concept_new(
  code,
) -> ValuesetComposeIncludeConcept {
  ValuesetComposeIncludeConcept(
    designation: [],
    display: None,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ValueSet#resource
pub type ValuesetComposeIncludeConceptDesignation {
  ValuesetComposeIncludeConceptDesignation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    language: Option(String),
    use_: Option(Coding),
    value: String,
  )
}

pub fn valueset_compose_include_concept_designation_new(
  value,
) -> ValuesetComposeIncludeConceptDesignation {
  ValuesetComposeIncludeConceptDesignation(
    value:,
    use_: None,
    language: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ValueSet#resource
pub type ValuesetComposeIncludeFilter {
  ValuesetComposeIncludeFilter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    property: String,
    op: r4bvaluesets.Filteroperator,
    value: String,
  )
}

pub fn valueset_compose_include_filter_new(
  value,
  op,
  property,
) -> ValuesetComposeIncludeFilter {
  ValuesetComposeIncludeFilter(
    value:,
    op:,
    property:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ValueSet#resource
pub type ValuesetExpansion {
  ValuesetExpansion(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Option(String),
    timestamp: String,
    total: Option(Int),
    offset: Option(Int),
    parameter: List(ValuesetExpansionParameter),
    contains: List(ValuesetExpansionContains),
  )
}

pub fn valueset_expansion_new(timestamp) -> ValuesetExpansion {
  ValuesetExpansion(
    contains: [],
    parameter: [],
    offset: None,
    total: None,
    timestamp:,
    identifier: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ValueSet#resource
pub type ValuesetExpansionParameter {
  ValuesetExpansionParameter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    value: Option(ValuesetExpansionParameterValue),
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ValueSet#resource
pub type ValuesetExpansionParameterValue {
  ValuesetExpansionParameterValueString(value: String)
  ValuesetExpansionParameterValueBoolean(value: Bool)
  ValuesetExpansionParameterValueInteger(value: Int)
  ValuesetExpansionParameterValueDecimal(value: Float)
  ValuesetExpansionParameterValueUri(value: String)
  ValuesetExpansionParameterValueCode(value: String)
  ValuesetExpansionParameterValueDatetime(value: String)
}

pub fn valueset_expansion_parameter_new(name) -> ValuesetExpansionParameter {
  ValuesetExpansionParameter(
    value: None,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/ValueSet#resource
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
    contains: List(Nil),
  )
}

pub fn valueset_expansion_contains_new() -> ValuesetExpansionContains {
  ValuesetExpansionContains(
    contains: [],
    designation: [],
    display: None,
    code: None,
    version: None,
    inactive: None,
    abstract: None,
    system: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/VerificationResult#resource
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
    status: r4bvaluesets.Verificationresultstatus,
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

pub fn verificationresult_new(status) -> Verificationresult {
  Verificationresult(
    validator: [],
    attestation: None,
    primary_source: [],
    failure_action: None,
    next_scheduled: None,
    last_performed: None,
    frequency: None,
    validation_process: [],
    validation_type: None,
    status_date: None,
    status:,
    need: None,
    target_location: [],
    target: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/VerificationResult#resource
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

pub fn verificationresult_primarysource_new() -> VerificationresultPrimarysource {
  VerificationresultPrimarysource(
    push_type_available: [],
    can_push_updates: None,
    validation_date: None,
    validation_status: None,
    communication_method: [],
    type_: [],
    who: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/VerificationResult#resource
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

pub fn verificationresult_attestation_new() -> VerificationresultAttestation {
  VerificationresultAttestation(
    source_signature: None,
    proxy_signature: None,
    proxy_identity_certificate: None,
    source_identity_certificate: None,
    date: None,
    communication_method: None,
    on_behalf_of: None,
    who: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/VerificationResult#resource
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

pub fn verificationresult_validator_new(
  organization,
) -> VerificationresultValidator {
  VerificationresultValidator(
    attestation_signature: None,
    identity_certificate: None,
    organization:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/VisionPrescription#resource
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
    status: r4bvaluesets.Fmstatus,
    created: String,
    patient: Reference,
    encounter: Option(Reference),
    date_written: String,
    prescriber: Reference,
    lens_specification: List(VisionprescriptionLensspecification),
  )
}

pub fn visionprescription_new(
  prescriber,
  date_written,
  patient,
  created,
  status,
) -> Visionprescription {
  Visionprescription(
    lens_specification: [],
    prescriber:,
    date_written:,
    encounter: None,
    patient:,
    created:,
    status:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/VisionPrescription#resource
pub type VisionprescriptionLensspecification {
  VisionprescriptionLensspecification(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    product: Codeableconcept,
    eye: r4bvaluesets.Visioneyecodes,
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

pub fn visionprescription_lensspecification_new(
  eye,
  product,
) -> VisionprescriptionLensspecification {
  VisionprescriptionLensspecification(
    note: [],
    brand: None,
    color: None,
    duration: None,
    diameter: None,
    back_curve: None,
    power: None,
    add: None,
    prism: [],
    axis: None,
    cylinder: None,
    sphere: None,
    eye:,
    product:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4b/StructureDefinition/VisionPrescription#resource
pub type VisionprescriptionLensspecificationPrism {
  VisionprescriptionLensspecificationPrism(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    amount: Float,
    base: r4bvaluesets.Visionbasecodes,
  )
}

pub fn visionprescription_lensspecification_prism_new(
  base,
  amount,
) -> VisionprescriptionLensspecificationPrism {
  VisionprescriptionLensspecificationPrism(
    base:,
    amount:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}
